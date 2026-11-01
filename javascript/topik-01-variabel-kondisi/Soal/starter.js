// Praktikum JS Modul 1 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js1.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan: node Jawaban/soal-js1.js
// 4. Bandingkan output dengan Contoh Output di PDF soal.

const LIMIT_HARIAN = 5000000;
const MINIMAL_TRANSFER = 10000;

// ===== Beginner 1 =====
function kategoriTriase(skorNyeri, sadar) {
  // TODO
}

// ===== Beginner 2 (jelaskan) =====
// JAWABAN Beginner 2a:
// 
// JAWABAN Beginner 2b:
// 

// ===== Beginner 3 =====
function hitungDiskon(totalBelanja, isMember) {
  // TODO
}

// ===== Intermediate 1 =====
// JAWABAN Intermediate 1b:
// 
function hitungBiayaRawat(kelas, malam, punyaBPJS) {
  // TODO
}

// ===== Intermediate 2a (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2a:
// 
function infoStok(namaBarang, stok) {
  const tampil = stok || "tidak diketahui";
  return `${namaBarang}: ${tampil}`;
}

// ===== Intermediate 2b (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2b (termasuk dua cara perbaikan):
// 
function labelBMI(bmi) {
  if (bmi >= 18.5) {
    return "Normal";
  } else if (bmi >= 25) {
    return "Berat berlebih";
  } else if (bmi >= 30) {
    return "Obesitas";
  } else {
    return "Kurus";
  }
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1b:
// 
function cekTransfer(saldo, nominal, pinBenar, sudahTransferHariIni) {
  // TODO
}

// ===== Advanced 2 =====
// JAWABAN Advanced 2b (termasuk versi ternary):
// 
function hitungOngkir(beratGram, zona, isPremium) {
  // TODO
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(kategoriTriase(9, true));
console.log(kategoriTriase(6, true));
console.log(kategoriTriase(2, true));
console.log(kategoriTriase(2, false));
console.log(kategoriTriase(0, true));
console.log(kategoriTriase(11, true));
console.log(kategoriTriase("7", true));

console.log("== Beginner 3 ==");
console.log(hitungDiskon(150000, true));
console.log(hitungDiskon(80000, true));
console.log(hitungDiskon(100000, true));
console.log(hitungDiskon(55555, true));
console.log(hitungDiskon(250000, false));
console.log(hitungDiskon(199999, false));

console.log("== Intermediate 1 ==");
console.log(hitungBiayaRawat("VIP", 2, true));
console.log(hitungBiayaRawat("1", 3, true));
console.log(hitungBiayaRawat("2", 2, false));
console.log(hitungBiayaRawat("3", 5, true));
console.log(hitungBiayaRawat("4", 1, false));
console.log(hitungBiayaRawat("2", 0, true));
console.log(hitungBiayaRawat("1", 1.5, false));
console.log(hitungBiayaRawat(3, 2, false));

console.log("== Intermediate 2a ==");
console.log(infoStok("Beras 5kg", 12));
console.log(infoStok("Minyak 1L", 0));
console.log(infoStok("Gula 1kg", undefined));

console.log("== Intermediate 2b ==");
console.log(labelBMI(17));
console.log(labelBMI(22));
console.log(labelBMI(25));
console.log(labelBMI(27));
console.log(labelBMI(32));

console.log("== Advanced 1 ==");
console.log(cekTransfer(1000000, 250000, true, 0));
console.log(cekTransfer(1000000, 250000, false, 0));
console.log(cekTransfer(1000000, 5000, true, 0));
console.log(cekTransfer(100000, 250000, true, 0));
console.log(cekTransfer(9000000, 2000000, true, 4000000));
console.log(cekTransfer(9000000, 1000000, true, 4000000));
console.log(cekTransfer(1000000, -50000, true, 0));
console.log(cekTransfer(1000000, 10000.5, true, 0));

console.log("== Advanced 2 ==");
console.log(hitungOngkir(1200, "A", false));
console.log(hitungOngkir(1000, "B", false));
console.log(hitungOngkir(4500, "C", false));
console.log(hitungOngkir(4500, "C", true));
console.log(hitungOngkir(800, "B", true));
console.log(hitungOngkir(30001, "A", false));
console.log(hitungOngkir(500, "D", false));
console.log(hitungOngkir(0, "A", false));
