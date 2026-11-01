// Praktikum JS Modul 2 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js2.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan soal: node Jawaban/soal-js2.js
// 4. Bandingkan output dengan Contoh Output di PDF soal.
// Tipe parameter ditulis gaya TypeScript di komentar atas setiap fungsi:
//   number[] = array berisi number; string | null = string atau null.
//   Semua number adalah bilangan bulat, kecuali ditulis desimal.

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js2.js coba
function cobaSendiri() {
  const nilai = [10, 20, 30];
  for (const i in nilai) console.log(i, typeof i);
  for (const v of nilai) console.log(v, typeof v);

  let jumlah = 0;
  for (let i = 0; i <= nilai.length; i++) jumlah += nilai[i];
  console.log(jumlah);

  const kali2 = (x) => { x * 2 };
  console.log(kali2(5));

  console.log(sapa("Dion"));
  function sapa(nama) { return `Halo ${nama}`; }
}

// JAWABAN Coba Sendiri 1:
// 
// JAWABAN Coba Sendiri 2:
// 
// JAWABAN Coba Sendiri 3:
// 

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== Beginner 1 =====
// saldoAkhir(saldoAwal: number, mutasi: number[]): number
function saldoAkhir(saldoAwal, mutasi) {
  // TODO: pakai for klasik
}

// ===== Beginner 2 =====
// ringkasMutasi(mutasi: number[]): string
function ringkasMutasi(mutasi) {
  // TODO: pakai for...of
}

// ===== Beginner 3 (kode temanmu, perbaiki) =====
// JAWABAN Beginner 3a:
// 
// JAWABAN Beginner 3b (cara perbaikan yang tidak dipakai di kode):
// 
// hitungPPN(harga: number): number
const hitungPPN = (harga) => { harga * 11 / 100 };

// ===== Intermediate 1 =====
// JAWABAN Intermediate 1 (kondisi yang membuat target tidak tercapai):
// 
// bulanMencapaiTarget(saldoAwal: number, setoranBulanan: number, bungaPersenTahunan: number, target: number): number
function bulanMencapaiTarget(saldoAwal, setoranBulanan, bungaPersenTahunan, target) {
  // TODO
}

// ===== Intermediate 2 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2a:
// 
// JAWABAN Intermediate 2b (mengapa for...of aman):
// 
// totalTagihan(biaya: number[]): number
function totalTagihan(biaya) {
  let total = 0;
  for (let i = 1; i <= biaya.length; i++) total += biaya[i];
  return total;
}

// ===== Intermediate 3 =====
// JAWABAN Intermediate 3:
// 
// posisiPertama(antrean: string[], kodePoli: string): number
function posisiPertama(antrean, kodePoli) {
  // TODO
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1b:
// 
// jadwalCicilan(pokok: number, bungaPersenPerBulan: number, cicilanPerBulan: number): string[]
function jadwalCicilan(pokok, bungaPersenPerBulan, cicilanPerBulan) {
  // TODO: kembalikan array berisi string per bulan
  return [];
}

// ===== Advanced 2 =====
// JAWABAN Advanced 2c:
// 
const biayaFlat = (nominal) => 2500;
const biayaPersen = (nominal) => Math.ceil((nominal * 5) / 1000);

// biayaBertingkat(nominal: number): number
function biayaBertingkat(nominal) {
  // TODO
}

// totalBiayaAdmin(mutasi: number[], aturanBiaya: (nominal: number) => number): number
function totalBiayaAdmin(mutasi, aturanBiaya) {
  // TODO
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
const mutasi = [500000, -150000, -20000, 1000000, -350000, 75000];

console.log("== Beginner 1 ==");
console.log(saldoAkhir(250000, mutasi));
console.log(saldoAkhir(0, []));

console.log("== Beginner 2 ==");
console.log(ringkasMutasi(mutasi));
console.log(ringkasMutasi([]));

console.log("== Beginner 3 ==");
console.log(hitungPPN(100000));
console.log(hitungPPN(25000));

console.log("== Intermediate 1 ==");
console.log(bulanMencapaiTarget(1000000, 500000, 6, 4000000));
console.log(bulanMencapaiTarget(0, 250000, 0, 1000000));
console.log(bulanMencapaiTarget(5000000, 500000, 6, 4000000));
console.log(bulanMencapaiTarget(100000, 0, 0, 200000));

console.log("== Intermediate 2 ==");
console.log(totalTagihan([150000, 75000, 300000]));
console.log(totalTagihan([]));

console.log("== Intermediate 3 ==");
const antrean = ["U", "A", "G", "A", "U"];
console.log(posisiPertama(antrean, "A"));
console.log(posisiPertama(antrean, "G"));
console.log(posisiPertama(antrean, "M"));

console.log("== Advanced 1 ==");
for (const baris of jadwalCicilan(1000000, 2, 300000)) console.log(baris);
for (const baris of jadwalCicilan(500000, 5, 25000)) console.log(baris);

console.log("== Advanced 2 ==");
console.log(totalBiayaAdmin(mutasi, biayaFlat));
console.log(totalBiayaAdmin(mutasi, biayaPersen));
console.log(totalBiayaAdmin(mutasi, biayaBertingkat));
console.log(totalBiayaAdmin([500000], biayaFlat));
