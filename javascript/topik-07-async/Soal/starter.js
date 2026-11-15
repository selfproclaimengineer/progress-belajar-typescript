// Praktikum JS Modul 7 — file starter
// 1. Salin file ini ke Jawaban/soal-js7.js, dan Soal/api.js ke Jawaban/api.js.
// 2. Lengkapi fungsi bertanda TODO dan perbaiki kode milik "temanmu". api.js jangan diubah.
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan soal: node Jawaban/soal-js7.js
// 4. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.

import { cekSaldoCallback, fetchBank } from "./api.js";

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js7.js coba
async function cobaSendiri() {
  console.log("A");
  setTimeout(() => console.log("B"), 0);
  Promise.resolve().then(() => console.log("C"));
  console.log("D");
  await new Promise((resolve) => setTimeout(resolve, 10));

  const angka = await Promise.all([1, Promise.resolve(2), new Promise((resolve) => setTimeout(() => resolve(3), 5))]);
  console.log(angka);

  try {
    await Promise.reject(new Error("gagal"));
  } catch (e) {
    console.log(e.message);
  } finally {
    console.log("selesai");
  }
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
  await cobaSendiri();
  await new Promise((resolve) => setTimeout(resolve, 0)); // beri kesempatan Node melaporkan Promise gagal yang tidak ditangkap
  process.exit(0);
}

// Sudah jadi: format Rupiah.
const rupiah = (n) => `Rp${new Intl.NumberFormat("id-ID").format(n)}`;

// ===== Beginner 1 =====
// tunda(ms: number, nilai: any): Promise<any>
function tunda(ms, nilai) {
  // TODO
  return Promise.resolve();
}

// ===== Beginner 2 =====
// cekSaldo(nomor: string): Promise<number>
function cekSaldo(nomor) {
  // TODO: bungkus cekSaldoCallback dengan new Promise
  return Promise.resolve(0);
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (output, mengapa begitu, perbaikannya):
//

// ===== Intermediate 1 =====
// ambilRekening(nomor: string): Promise<{ nomor: string, nama: string, saldo: number }>
async function ambilRekening(nomor) {
  // TODO
  return { nomor: "", nama: "", saldo: 0 };
}

// infoRekening(nomor: string): Promise<string>
async function infoRekening(nomor) {
  // TODO
  return "";
}

// ===== Intermediate 2 =====
// JAWABAN Intermediate 2 (berurutan vs bersamaan, mengapa satu gagal membuat semuanya gagal):
//
// totalSaldo(daftarNomor: string[]): Promise<number>
async function totalSaldo(daftarNomor) {
  // TODO: ambil semua rekening BERSAMAAN
  return 0;
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
// daftarNama(daftarNomor: string[]): Promise<string>
async function daftarNama(daftarNomor) {
  const nama = [];
  daftarNomor.forEach(async (nomor) => {
    const r = await ambilRekening(nomor);
    nama.push(r.nama);
  });
  return nama.join(", ");
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah per transfer, mengapa berurutan, cara batas waktu bekerja):
//
// denganBatasWaktu(janji: Promise<any>, ms: number): Promise<any>
function denganBatasWaktu(janji, ms) {
  // TODO (opsional)
  return janji;
}

// prosesAntrian(daftar: { dari: string, ke: string, nominal: number }[]): Promise<string>
async function prosesAntrian(daftar) {
  // TODO (opsional)
  return "";
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(await tunda(100, "siap"));
console.log(await tunda(10, 42) + 1);

console.log("== Beginner 2 ==");
console.log(await cekSaldo("1001"));
console.log(await cekSaldo("9999").catch((e) => e.message));

console.log("== Intermediate 1 ==");
console.log(await infoRekening("1002"));
console.log(await infoRekening("1009"));

console.log("== Intermediate 2 ==");
console.log(rupiah(await totalSaldo(["1001", "1002", "1003"])));
console.log(await totalSaldo(["1001", "1009"]).catch((e) => "Gagal: " + e.message));

console.log("== Intermediate 3 ==");
console.log(await daftarNama(["1003", "1001", "1002"]));

console.log("== Advanced 1 ==");
const antrian = [
  { dari: "1001", ke: "1002", nominal: 100000 },
  { dari: "1002", ke: "1009", nominal: 5000 },
  { dari: "1002", ke: "1003", nominal: 500000 },
  { dari: "1003", ke: "1004", nominal: 50000 },
  { dari: "1003", ke: "1001", nominal: 0 },
  { dari: "1002", ke: "1001", nominal: 175000 },
];
console.log(await prosesAntrian(antrian));
