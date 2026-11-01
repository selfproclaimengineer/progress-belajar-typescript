// Catat progres harian ke PROGRESS.md, lalu commit dan push.
// Pakai: npm run selesai -- --durasi "2 jam" --macet "reduce tanpa nilai awal"
// Opsi: --dry (hanya tampilkan hasil, tanpa menulis file dan tanpa git)
import { execSync } from "node:child_process";
import { existsSync, readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const args = process.argv.slice(2);
const opsi = (nama) => {
  const i = args.indexOf(`--${nama}`);
  return i === -1 ? undefined : args[i + 1];
};
const dry = args.includes("--dry");
const git = (cmd) => execSync(`git ${cmd}`, { encoding: "utf8" }).trim();

const d = new Date();
const pad = (n) => String(n).padStart(2, "0");
const hariIni = `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`;

// topik-01-xxx di folder javascript menjadi JS-1, di typescript menjadi TS-1
function daftarTopik() {
  const hasil = [];
  for (const [folder, prefix] of [["javascript", "JS"], ["typescript", "TS"]]) {
    if (!existsSync(folder)) continue;
    for (const nama of readdirSync(folder).sort()) {
      const m = nama.match(/^topik-(\d+)/);
      if (m) hasil.push({ kode: `${prefix}-${Number(m[1])}`, dir: join(folder, nama) });
    }
  }
  return hasil;
}

function statusTopik(dir) {
  const jawaban = join(dir, "Jawaban");
  const isi = existsSync(jawaban) ? readdirSync(jawaban) : [];
  const feedback = join(dir, "Diskusi", "FEEDBACK.md");
  const nilai = existsSync(feedback)
    ? readFileSync(feedback, "utf8").match(/Total:\s*(\d+)/)?.[1]
    : undefined;
  return {
    soal: isi.some((f) => /\.(js|ts|html)$/.test(f)),
    laporan: isi.some((f) => f.toLowerCase().endsWith(".pdf")),
    nilai,
  };
}

// file yang berubah hari ini: commit hari ini + perubahan yang belum di-commit
function fileBerubahHariIni() {
  const commit = git(`log --since="${hariIni} 00:00" --name-only --format=`);
  const kerja = git("status --porcelain").split("\n").map((l) => l.slice(3));
  return [...commit.split("\n"), ...kerja].filter(Boolean).map((f) => f.replaceAll("\\", "/"));
}

function ringkasKegiatan(topik, berubah) {
  const bagian = [];
  for (const t of topik) {
    const prefixDir = t.dir.replaceAll("\\", "/") + "/";
    const f = berubah.filter((x) => x.startsWith(prefixDir));
    if (f.length === 0) continue;
    const jenis = [];
    if (f.some((x) => x.includes("/Jawaban/") && /\.(js|ts|html)$/.test(x))) jenis.push("kode jawaban");
    if (f.some((x) => x.includes("/Jawaban/") && x.toLowerCase().endsWith(".pdf"))) jenis.push("laporan");
    // file diskusi/feedback kosong ikut dibuat bersama materi, jadi hanya dihitung jika sudah berisi
    const diskusi = join(t.dir, "Diskusi", "DISKUSI.md");
    const feedback = join(t.dir, "Diskusi", "FEEDBACK.md");
    if (f.some((x) => x.endsWith("DISKUSI.md")) && readFileSync(diskusi, "utf8").includes("### ")) {
      jenis.push("tanya jawab");
    }
    if (f.some((x) => x.endsWith("FEEDBACK.md")) && /Total:\s*\d+/.test(readFileSync(feedback, "utf8"))) {
      jenis.push("feedback");
    }
    if (jenis.length) bagian.push({ kode: t.kode, teks: `${t.kode}: ${jenis.join(", ")}` });
  }
  return bagian;
}

function perbaruiChecklist(teks, topik) {
  return teks
    .split("\n")
    .map((baris) => {
      const t = topik.find((x) => baris.startsWith(`| ${x.kode} `));
      if (!t) return baris;
      const kolom = baris.split("|");
      // kolom: ["", topik, HO, Soal, Laporan, Nilai, ""]
      const s = statusTopik(t.dir);
      if (s.laporan) kolom[2] = " [x] "; // laporan memuat Coba Sendiri dari HO
      if (s.soal) kolom[3] = " [x] ";
      if (s.laporan) kolom[4] = " [x] ";
      if (s.nilai) kolom[5] = ` ${s.nilai} `;
      return kolom.join("|");
    })
    .join("\n");
}

function perbaruiLog(teks, kegiatan) {
  const baris = teks.split("\n");
  const iLama = baris.findIndex((b) => b.startsWith(`| ${hariIni} |`));
  const lama = iLama === -1 ? [] : baris[iLama].split("|").map((k) => k.trim());
  const kodeTopik = kegiatan.map((k) => k.kode).join(", ") || lama[2] || "-";
  const dikerjakan = kegiatan.map((k) => k.teks).join("; ") || lama[4] || "-";
  const durasi = opsi("durasi") ?? lama[3] ?? "-";
  const macet = opsi("macet") ?? lama[5] ?? "-";
  const baru = `| ${hariIni} | ${kodeTopik} | ${durasi} | ${dikerjakan} | ${macet} |`;
  if (iLama !== -1) {
    baris[iLama] = baru;
  } else {
    // sisipkan setelah baris terakhir tabel log harian
    const iJudul = baris.findIndex((b) => b.startsWith("## Log harian"));
    let i = iJudul + 1;
    while (i < baris.length && !baris[i].startsWith("|")) i++;
    while (i < baris.length && baris[i].startsWith("|")) i++;
    baris.splice(i, 0, baru);
  }
  return baris.join("\n");
}

const topik = daftarTopik();
const kegiatan = ringkasKegiatan(topik, fileBerubahHariIni());
const awal = readFileSync("PROGRESS.md", "utf8");
const akhir = perbaruiLog(perbaruiChecklist(awal, topik), kegiatan);

if (dry) {
  console.log(akhir);
  process.exit(0);
}

writeFileSync("PROGRESS.md", akhir);
git("add -A");
if (git("status --porcelain") === "") {
  console.log("Tidak ada perubahan.");
  process.exit(0);
}
git(`commit -q -m "progress: ${hariIni}"`);
console.log(`Commit progress: ${hariIni}`);
if (git("remote") !== "") {
  execSync("git push -q", { stdio: "inherit" });
  console.log("Push ke GitHub selesai.");
} else {
  console.log("Belum ada remote GitHub, push dilewati.");
}
