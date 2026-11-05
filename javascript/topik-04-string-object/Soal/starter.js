// Praktikum JS Modul 4 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js4.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan soal: node Jawaban/soal-js4.js
// 4. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.
// Tipe parameter ditulis gaya TypeScript di komentar atas setiap fungsi.
//   alergi?: string[] berarti properti alergi boleh tidak ada.

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js4.js coba
function cobaSendiri() {
  const kata = "Halo";
  console.log(kata.length);
  console.log(kata[0], kata[10]);
  console.log(kata.toUpperCase(), kata);
  console.log("a,b,,c".split(","));
  console.log("7".padStart(3, "0"));

  const a = { n: 1, dalam: { m: 2 } };
  const b = { ...a };
  b.n = 9;
  b.dalam.m = 9;
  console.log(a.n, a.dalam.m);
  console.log({ x: 1 } === { x: 1 });
  console.log(JSON.stringify({ nama: "Ani", umur: undefined, hobi: ["baca"] }));
}

// JAWABAN Coba Sendiri 1:
//
// JAWABAN Coba Sendiri 2:
//
// JAWABAN Coba Sendiri 3:
//
// JAWABAN Coba Sendiri 4:
//

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== DATA (JANGAN DIUBAH) =====
// Pasien = { id: string, nama: string, umur: number, poli: string,
//            alergi?: string[], kontak: { telepon: string, alamat: string } }
const pasien = [
  { id: "P001", nama: "budi santoso", umur: 40, poli: "Umum", alergi: ["Penisilin", "Debu"],
    kontak: { telepon: "081234567890", alamat: "Jl. Merpati 5" } },
  { id: "P002", nama: "  SARI   dewi ", umur: 7, poli: "Anak",
    kontak: { telepon: "085711112222", alamat: "Jl. Kenari 12" } },
  { id: "P003", nama: "joko", umur: 65, poli: "Umum", alergi: [],
    kontak: { telepon: "087733334444", alamat: "Jl. Cendrawasih 3" } },
  { id: "P004", nama: "rina AYU lestari", umur: 30, poli: "Gigi", alergi: ["Udang"],
    kontak: { telepon: "081355556666", alamat: "Jl. Nuri 8" } },
];

const teksPendaftaran = `P101;Dewi Anggraini;28;Umum;Debu|Udang
P102;Hendra;51;Jantung;
P103;Lina;9;Anak;Telur`;

// ===== Beginner 1 =====
// formatNama(nama: string): string
function formatNama(nama) {
  // TODO
  return nama;
}

// ===== Beginner 2 =====
// sensorTelepon(telepon: string): string
function sensorTelepon(telepon) {
  // TODO
  return telepon;
}

// ===== Beginner 3 =====
// kodeAntrean(poli: string, nomor: number): string
function kodeAntrean(poli, nomor) {
  // TODO
  return "";
}

// ===== Beginner 4 (jelaskan) =====
// JAWABAN Beginner 4 (pesan error, penyebab, versi benar):
//

// ===== Intermediate 1 =====
// ringkasPasien(p: Pasien): string
function ringkasPasien(p) {
  // TODO: pakai destructuring dengan default untuk alergi
  return "";
}

// ===== Intermediate 2 =====
// hitungPerPoli(daftar: Pasien[]): { [poli: string]: number }
function hitungPerPoli(daftar) {
  // TODO
  return {};
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
// gantiAlamat(p: Pasien, alamatBaru: string): Pasien  (p asli tidak boleh berubah)
function gantiAlamat(p, alamatBaru) {
  const salinan = { ...p };
  salinan.kontak.alamat = alamatBaru;
  return salinan;
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah, bentuk data, method; apa yang terjadi pada P102):
//
// parseDataPasien(teks: string): { id: string, nama: string, umur: number, poli: string, alergi: string[] }[]
function parseDataPasien(teks) {
  // TODO (opsional)
  return [];
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(pasien.map((p) => formatNama(p.nama)).join(", "));

console.log("== Beginner 2 ==");
console.log(sensorTelepon(pasien[0].kontak.telepon));
console.log(sensorTelepon("1234"));

console.log("== Beginner 3 ==");
console.log(kodeAntrean("Umum", 7));
console.log(kodeAntrean("gigi", 125));

console.log("== Intermediate 1 ==");
console.log(pasien.map(ringkasPasien).join("\n"));

console.log("== Intermediate 2 ==");
console.log(JSON.stringify(hitungPerPoli(pasien)));
console.log(JSON.stringify(hitungPerPoli([])));

console.log("== Intermediate 3 ==");
const pasienBaru = gantiAlamat(pasien[0], "Jl. Elang 9");
console.log(pasienBaru.kontak.alamat);
console.log(pasien[0].kontak.alamat);
console.log(pasienBaru === pasien[0], pasienBaru.kontak === pasien[0].kontak);

console.log("== Advanced 1 ==");
console.log(parseDataPasien(teksPendaftaran).map((p) => JSON.stringify(p)).join("\n"));
