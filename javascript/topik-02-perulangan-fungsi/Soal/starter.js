// Praktikum JS Modul 2 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js2.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan: node Jawaban/soal-js2.js
// 4. Bandingkan output dengan Contoh Output di PDF soal.

// ===== Beginner 1 =====
function saldoAkhir(saldoAwal, mutasi) {
  // TODO: pakai for klasik
}

// ===== Beginner 2 =====
function ringkasMutasi(mutasi) {
  // TODO: pakai for...of
}

// ===== Beginner 3 (kode temanmu, perbaiki) =====
// JAWABAN Beginner 3a:
// 
// JAWABAN Beginner 3b (cara perbaikan yang tidak dipakai di kode):
// 
const hitungPPN = (harga) => { harga * 11 / 100 };

// ===== Intermediate 1 =====
// JAWABAN Intermediate 1 (kondisi yang membuat target tidak tercapai):
// 
function bulanMencapaiTarget(saldoAwal, setoranBulanan, bungaPersenTahunan, target) {
  // TODO
}

// ===== Intermediate 2 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2a:
// 
// JAWABAN Intermediate 2b (mengapa for...of aman):
// 
function totalTagihan(biaya) {
  let total = 0;
  for (let i = 1; i <= biaya.length; i++) total += biaya[i];
  return total;
}

// ===== Intermediate 3 =====
// JAWABAN Intermediate 3:
// 
function posisiPertama(antrean, kodePoli) {
  // TODO
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1b:
// 
function jadwalCicilan(pokok, bungaPersenPerBulan, cicilanPerBulan) {
  // TODO: kembalikan array berisi string per bulan
  return [];
}

// ===== Advanced 2 =====
// JAWABAN Advanced 2c:
// 
const biayaFlat = (nominal) => 2500;
const biayaPersen = (nominal) => Math.ceil((nominal * 5) / 1000);

function biayaBertingkat(nominal) {
  // TODO
}

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
