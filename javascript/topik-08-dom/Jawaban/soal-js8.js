// Praktikum JS Modul 8 — file starter
// 1. Salin keempat file di folder Soal ke folder Jawaban:
//      starter.js -> Jawaban/soal-js8.js, toko.js, halaman.js, index.html (nama tetap).
// 2. Fungsi logika ditulis di toko.js, kode tampilan di halaman.js, jawaban (jelaskan) di file ini.
// 3. Cek logika dengan node: node Jawaban/soal-js8.js
//    Bandingkan output dengan kotak "Output dari console.log(...)" di PDF soal.
// 4. Cek tampilan di browser: npm run sajikan, lalu buka alamat yang dicetak.
//    Bandingkan dengan gambar "Tampilan yang diharapkan" di PDF soal.

import { produk, teksMenu, kurangiItem, hitungTotal, validasiBayar, tambahItem } from "./toko.js";

// ===== Coba Sendiri (dari HO) =====
// Bagian 1: tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js8.js coba
function cobaSendiri() {
  console.log(Number(""), Number("  12 "), Number("12rb"), parseInt("12rb"));
  console.log(typeof document);
  // Bagian 2: buka halaman di browser, tekan F12, pilih tab Console, lalu ketik satu per satu:
  //   document.querySelector("h1").textContent
  //   document.querySelectorAll("#daftar-produk li").length
  //   document.querySelector("#tidak-ada")
  //   typeof document.querySelector("#input-uang").value
  //   document.querySelector("h1").textContent = "<i>Toko</i>"
  //   document.querySelector("h1").innerHTML = "<i>Toko</i>"
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

// ===== Beginner 3 (tampilan, di halaman.js) =====
// JAWABAN Beginner 3 (mengapa textContent, bukan innerHTML):
//

// ===== Intermediate 2 (jelaskan) =====
// JAWABAN Intermediate 2 (mengapa "" harus diperiksa sebelum Number):
//

// ===== Intermediate 3 (kode temanmu) =====
// JAWABAN Intermediate 3:
//

// ===== Intermediate 4 (tampilan, di halaman.js) =====
// JAWABAN Intermediate 4 (mengapa listener dipasang di <ul>, bukan di setiap tombol):
//

// ===== Advanced 1 (tampilan, di halaman.js) =====
// JAWABAN Advanced 1a (alur dari submit sampai tampilan berubah, peran state dan render):
//

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(teksMenu(produk[0]));
console.log(produk.map(teksMenu).join("\n"));

console.log("== Beginner 2 ==");
const keranjangA = [{ id: "R01", qty: 2 }, { id: "R02", qty: 1 }];
console.log(JSON.stringify(kurangiItem(keranjangA, "R02")));
console.log(JSON.stringify(kurangiItem(keranjangA, "R01")));
console.log(JSON.stringify(keranjangA));

console.log("== Intermediate 1 ==");
console.log(hitungTotal([{ id: "R01", qty: 2 }, { id: "R03", qty: 1 }], produk));
console.log(hitungTotal([{ id: "R04", qty: 1 }, { id: "X99", qty: 3 }], produk));
console.log(hitungTotal([], produk));

console.log("== Intermediate 2 ==");
console.log(validasiBayar("10000", 0));
console.log(validasiBayar("  ", 48000));
console.log(validasiBayar("lima puluh", 48000));
console.log(validasiBayar("-5000", 48000));
console.log(validasiBayar("40000", 48000));
console.log(validasiBayar("50000", 48000));

console.log("== Intermediate 3 ==");
const k0 = [];
const k1 = tambahItem(k0, "R01");
const k2 = tambahItem(k1, "R01");
const k3 = tambahItem(k2, "R02");
console.log(JSON.stringify(k0));
console.log(JSON.stringify(k1));
console.log(JSON.stringify(k2));
console.log(JSON.stringify(k3));
