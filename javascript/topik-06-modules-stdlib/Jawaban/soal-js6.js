// Praktikum JS Modul 6 — file starter
// 1. Salin file ini ke Jawaban/soal-js6.js, dan Soal/kasir.js ke Jawaban/kasir.js.
// 2. Sebagian besar tugas dikerjakan di kasir.js. Di file ini: Intermediate 2 (cobaTambah),
//    Advanced 1 (cetakStruk), dan jawaban (jelaskan).
// 3. Jalankan soal: node Jawaban/soal-js6.js
// 4. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.

import { formatRupiah, bulatkanKe, kategoriUnik, buatIndex, validasiQty, formatTanggal, buatStruk } from "./kasir.js";

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js6.js coba
function cobaSendiri() {
  console.log(Math.round(2.5), Math.round(-2.5), Math.floor(-2.5)); // 3 -2 -3
  console.log(Math.max(...[3, 9, 4]), Math.max([3, 9, 4])); // 9 NaN
  const s = new Set(["a", "b", "a"]);
  console.log(s.size, s.has("a"), [...s]); // 3 true ["a","b"]
  const m = new Map([["x", 1]]);
  console.log(m.get("x"), m.get("y"), m.size); // 1 undefined 1
  const d = new Date(2026, 0, 31);
  console.log(d.getMonth(), d.getDate()); // 0 31
  try {
    JSON.parse("{");
    console.log("lolos"); // lolos
  } catch (e) {
    console.log(e.name); //
  } finally {
    console.log("selesai"); // selesai
  }
   const n = new Set([3,1,3,2,1])
   console.log ([...n].sort((a,b)=>a-b))
}

// JAWABAN Coba Sendiri 1:
// salah 2, yang set salah karena 2 nilai sama dianggap 1, syntax error itu belum ketemu kenapa
// JAWABAN Coba Sendiri 2:
// Karena dianggap 1 nilai, bukan array
// JAWABAN Coba Sendiri 3:
// karena dalam try, console tidak dicetak, ketika ada finally dan jika ada catch baru dicetak.
// try pada dasarnya trigger untuk mengecek.
// JAWABAN Coba Sendiri 4:
// const n = new Set([3,1,3,2,1])
// console.log ([...n].sort((a,b)=>a-b)])

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== DATA (JANGAN DIUBAH) =====
// Produk = { id: string, nama: string, kategori: string, harga: number }
const produk = [
  { id: "K01", nama: "Beras 5kg", kategori: "Sembako", harga: 78000 },
  { id: "K02", nama: "Telur 1kg", kategori: "Sembako", harga: 28000 },
  { id: "K03", nama: "Kopi Sachet", kategori: "Minuman", harga: 1500 },
  { id: "K04", nama: "Sabun Batang", kategori: "Perawatan", harga: 4500 },
  { id: "K05", nama: "Teh Botol", kategori: "Minuman", harga: 5000 },
];

// ===== Beginner 4 (jelaskan) =====
// JAWABAN Beginner 4 (pesan error, mengapa baris pertama pun tidak tercetak, perbaikan):
//
//console.log("mulai");
//import { formatRp } from "./kasir.js";

// SyntaxError: The requested module './kasir.js' does not provide an export named 'formatRp'
// semuanya tidak dijalankan jika gagal import
// import { formatRupiah } from "./kasir.js"

// ===== Intermediate 1 (jelaskan) =====
// JAWABAN Intermediate 1:
// eksponensial, karena jika pakai find itu perbandingan 1 demi 1 ke semua data
// kalau cari berkali-kali ya perbandingannya 1 demi 1 ke semua data dilakukan berkali kali
// kalau map itu karena sudah pakai hashtable, key nya jadi alamat penyimpanan
// jadi get langsung lompat ke tempatnya.

// ===== Intermediate 2 =====
// cobaTambah(qty: unknown): string

function cobaTambah(qty) {
  // TODO: panggil validasiQty di dalam try...catch
  // ≈ 8 baris
  try{
    validasiQty(qty);
    return `OK ${qty}`;
  } catch (e){
    return `GAGAL: ${e.message}`;
  }
  
}

// ===== Intermediate 3 (jelaskan) =====
// JAWABAN Intermediate 3:
// Bulannya 10 karena dengan getMonth(), startnya itu dari 0, makanya harus ditambah 1
// sebelum diubah jadi string dan diberi padstart agar bisa 2 digit

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah, fungsi yang dipakai, di mana throw dan di mana catch):
// 
// cetakStruk(keranjang: { id: string, qty: number }[], index: Map<string, Produk>, tanggal: Date): string
function cetakStruk(keranjang, index, tanggal) {
  // TODO (opsional)
  // ≈ 7 baris
  return "";
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(formatRupiah(1250000));
console.log(formatRupiah(500));

console.log("== Beginner 2 ==");
console.log(bulatkanKe(12340, 500));
console.log(bulatkanKe(12500, 500));

console.log("== Beginner 3 ==");
console.log(kategoriUnik(produk).join(", "));

console.log("== Intermediate 1 ==");
const index = buatIndex(produk);
console.log(index.size);
console.log(index.get("K03").nama);
console.log(index.get("X99"));

console.log("== Intermediate 2 ==");
console.log([3, 0, 2.5, "2"].map(cobaTambah).join("\n"));

console.log("== Intermediate 3 ==");
console.log(formatTanggal(new Date(2026, 10, 5)));
console.log(formatTanggal(new Date(2026, 0, 31)));

console.log("== Advanced 1 ==");
const tanggal = new Date(2026, 10, 5);
console.log(cetakStruk([{ id: "K01", qty: 1 }, { id: "K02", qty: 2 }, { id: "K03", qty: 10 }], index, tanggal));
console.log(cetakStruk([{ id: "K01", qty: 1 }, { id: "X99", qty: 1 }], index, tanggal));
console.log(cetakStruk([{ id: "K05", qty: 0 }], index, tanggal));
