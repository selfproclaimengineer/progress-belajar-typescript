// Praktikum TS Modul 4 — file starter
// 1. Salin file ini ke Jawaban/soal-ts4.ts.
// 2. Lengkapi bagian bertanda TODO dan perbaiki kode milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Cek tipe dulu: npx tsc --noEmit   (harus tanpa error di akhir)
//    Saat baru disalin, tsc menampilkan error TS7006 dan TS2558. Itu disengaja:
//    error itu hilang setelah fungsi dan class diberi tipe generik.
// 4. Lalu jalankan: node Jawaban/soal-ts4.ts
// 5. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.

// ===== Coba Sendiri (dari HO) =====
// Bagian 1: tulis tebakan tipe a, b, c dan output console.log di komentar ujung baris,
//           lalu cek tipe dengan mengarahkan kursor ke nama variabel di VS Code.
// Jalankan bagian ini saja: node Jawaban/soal-ts4.ts coba
function cobaSendiri() {
  function bungkus<T>(x: T): T[] {
    return [x];
  }
  const a = bungkus(5);
  const b = bungkus("qris");
  const c = bungkus<number | string>(5);
  console.log(a, b, c);

  type PasienBaru = Omit<Pasien, "id">;
  const draf: Partial<Pasien> = { nama: "Ani" };
  console.log(draf.umur);

  // Bagian 2: hapus // di depan SATU baris, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // const d: number[] = bungkus("x");
  // const p: Pick<Pasien, "nama"> = { nama: "Ani", umur: 3 };
  // const q: PasienBaru = { id: "PS99", nama: "Ani", umur: 3, poli: "umum", telepon: "-" };
  // console.log(draf.umur + 1);
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

// ===== TIPE (JANGAN DIUBAH) =====
interface Pasien {
  readonly id: string;
  nama: string;
  umur: number;
  poli: string;
  telepon: string;
}

interface Dokter {
  readonly id: string;
  nama: string;
  spesialis: string;
}

interface Halaman<T> {
  isi: T[];
  halaman: number;
  totalHalaman: number;
  adaBerikutnya: boolean;
}

// ===== DATA (JANGAN DIUBAH) =====
const daftarPasien: Pasien[] = [
  { id: "PS01", nama: "Sari", umur: 34, poli: "umum", telepon: "081211110001" },
  { id: "PS02", nama: "Budi", umur: 52, poli: "gigi", telepon: "081211110002" },
  { id: "PS03", nama: "Wati", umur: 8, poli: "anak", telepon: "081211110003" },
  { id: "PS04", nama: "Dodi", umur: 41, poli: "umum", telepon: "081211110004" },
  { id: "PS05", nama: "Rina", umur: 29, poli: "gigi", telepon: "081211110005" },
  { id: "PS06", nama: "Tono", umur: 5, poli: "anak", telepon: "081211110006" },
  { id: "PS07", nama: "Lina", umur: 63, poli: "umum", telepon: "081211110007" },
];

const daftarDokter: Dokter[] = [
  { id: "DR01", nama: "dr. Andi", spesialis: "umum" },
  { id: "DR02", nama: "drg. Maya", spesialis: "gigi" },
  { id: "DR03", nama: "dr. Fajar", spesialis: "anak" },
];

// ===== Beginner 1 =====
// terakhir<T>(daftar: readonly T[]): T | undefined
function terakhir(daftar) {
  // TODO
  // ≈ 3 baris
  return undefined;
}

// hitungJika<T>(daftar: readonly T[], syarat: (x: T) => boolean): number
function hitungJika(daftar, syarat) {
  // TODO
  // ≈ 3 baris
  return 0;
}

// ===== Beginner 2 =====
// cariById<T extends { id: string }>(daftar: readonly T[], id: string): T | undefined
function cariById(daftar, id) {
  // TODO
  // ≈ 3 baris
  return undefined;
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (hasil tsc dan node untuk kedua versi, mengapa any berbahaya):
//

// ===== Intermediate 1 =====
// kelompokkan<T>(daftar: readonly T[], kunci: (x: T) => string): Record<string, T[]>
function kelompokkan(daftar, kunci) {
  // TODO
  // ≈ 9 baris
  return {};
}

// ===== Intermediate 2 =====
// class Antrian<T>
//   private isi: T[]
//   masuk(x: T): void
//   panggil(): T | undefined      (yang pertama masuk, pertama keluar)
//   get jumlah(): number
//   lihatSemua(): readonly T[]
class Antrian {
  // TODO
  // ≈ 15 baris untuk seluruh class
  masuk(x) {}
  panggil() {
    return undefined;
  }
  get jumlah() {
    return 0;
  }
  lihatSemua() {
    return [];
  }
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
function perbaruiPasien(p: Pasien, perubahan: any): Pasien {
  Object.assign(p, perubahan);
  return p;
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah, rumus, tipe data per langkah, mengapa generik dan bukan any):
//
function paginasi<T>(daftar: readonly T[], halaman: number, perHalaman: number): Halaman<T> {
  // TODO (opsional)
  // ≈ 10 baris
  return { isi: [], halaman, totalHalaman: 0, adaBerikutnya: false };
}

// Sudah jadi, jangan diubah.
function cetakHalaman<T>(h: Halaman<T>, label: (x: T) => string): string {
  const isi = h.isi.length === 0 ? "(kosong)" : h.isi.map(label).join(", ");
  return `Halaman ${h.halaman}/${h.totalHalaman}: ${isi}${h.adaBerikutnya ? " (berikutnya ada)" : ""}`;
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(terakhir([3, 1, 4]));
console.log(terakhir(daftarPasien)?.nama);
console.log(terakhir([]));
console.log(hitungJika(daftarPasien, (p) => p.umur >= 40), hitungJika(["a", "bb", "ccc"], (s) => s.length > 1));

console.log("== Beginner 2 ==");
console.log(cariById(daftarPasien, "PS02")?.nama);
console.log(cariById(daftarDokter, "DR03")?.spesialis);
console.log(cariById(daftarDokter, "DR09"));

console.log("== Intermediate 1 ==");
const perPoli = kelompokkan(daftarPasien, (p) => p.poli);
console.log(Object.keys(perPoli).join(", "));
console.log((perPoli["gigi"] ?? []).map((p) => p.nama).join(", "));
console.log(JSON.stringify(kelompokkan(["apel", "anggur", "jeruk"], (s) => s[0])));

console.log("== Intermediate 2 ==");
const antrianUmum = new Antrian<Pasien>();
antrianUmum.masuk(daftarPasien[0]);
antrianUmum.masuk(daftarPasien[3]);
antrianUmum.masuk(daftarPasien[6]);
console.log(antrianUmum.jumlah);
console.log(antrianUmum.panggil()?.nama);
console.log(antrianUmum.lihatSemua().map((p) => p.nama).join(", "));
const antrianNomor = new Antrian<string>();
antrianNomor.masuk("A-001");
console.log(antrianNomor.panggil(), antrianNomor.panggil());

console.log("== Intermediate 3 ==");
console.log(JSON.stringify(perbaruiPasien(daftarPasien[1], { telepon: "081299990000", umur: 53 })));
console.log(daftarPasien[1].umur);

console.log("== Advanced 1 ==");
console.log(cetakHalaman(paginasi(daftarPasien, 1, 3), (p) => p.nama));
console.log(cetakHalaman(paginasi(daftarPasien, 3, 3), (p) => p.nama));
console.log(cetakHalaman(paginasi(daftarDokter, 2, 2), (d) => d.nama));
console.log(cetakHalaman(paginasi(daftarPasien, 5, 3), (p) => p.nama));
