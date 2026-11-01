// Praktikum JS Modul 3 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js3.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
// 3. Jalankan: node Jawaban/soal-js3.js
// 4. Bandingkan output dengan Contoh Output di PDF soal.

// ===== DATA (JANGAN DIUBAH) =====
const produk = [
  { id: "P01", nama: "Beras Premium 5kg", kategori: "Sembako", harga: 78000, stok: 25, rating: 4.7, terjual: 320 },
  { id: "P02", nama: "Minyak Goreng 2L", kategori: "Sembako", harga: 36000, stok: 0, rating: 4.5, terjual: 410 },
  { id: "P03", nama: "Kopi Bubuk 200g", kategori: "Minuman", harga: 24500, stok: 40, rating: 4.8, terjual: 150 },
  { id: "P04", nama: "Teh Celup 25s", kategori: "Minuman", harga: 9800, stok: 60, rating: 4.2, terjual: 95 },
  { id: "P05", nama: "Sabun Mandi Cair", kategori: "Perawatan", harga: 21000, stok: 12, rating: 4.4, terjual: 210 },
  { id: "P06", nama: "Pasta Gigi 190g", kategori: "Perawatan", harga: 15500, stok: 8, rating: 4.6, terjual: 180 },
  { id: "P07", nama: "Mi Instan Goreng", kategori: "Sembako", harga: 3100, stok: 200, rating: 4.9, terjual: 1500 },
  { id: "P08", nama: "Susu UHT 1L", kategori: "Minuman", harga: 18900, stok: 0, rating: 4.3, terjual: 260 },
];

const keranjang = [
  { idProduk: "P01", qty: 1 },
  { idProduk: "P07", qty: 10 },
  { idProduk: "P03", qty: 2 },
  { idProduk: "P06", qty: 1 },
];

// ===== Beginner 1 =====
function namaProdukTersedia(produk) {
  // TODO
  return [];
}

// ===== Beginner 2 =====
function totalStok(produk) {
  // TODO
}

// ===== Beginner 3 =====
function adaKategori(produk, kategori) {
  // TODO
}

function semuaRatingDiAtas(produk, batas) {
  // TODO
}

// ===== Intermediate 1 =====
function rincianCheckout(keranjang, produk) {
  // TODO: kembalikan array of string
  return [];
}

function totalCheckout(keranjang, produk) {
  // TODO
}

// ===== Intermediate 2 (kode temanmu, perbaiki) =====
function totalTerjual(produk) {
  return produk.reduce((acc, p) => acc + p.terjual);
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
function urutHargaTermurah(produk) {
  return produk.sort((a, b) => a.harga - b.harga);
}

// ===== Intermediate 4 (kode temanmu, perbaiki) =====
function cariProdukHabis(produk) {
  let hasil = null;
  produk.forEach((p) => {
    if (p.stok === 0) {
      hasil = p.nama;
      return;
    }
  });
  return hasil;
}

// ===== Advanced 1 =====
function laporanKategori(produk) {
  // TODO: kembalikan array of string
  return [];
}

// ===== Advanced 2 =====
function checkout(keranjang, produk, kodePromo) {
  // TODO
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(namaProdukTersedia(produk).join(", "));

console.log("== Beginner 2 ==");
console.log(totalStok(produk));

console.log("== Beginner 3 ==");
console.log(adaKategori(produk, "Minuman"), adaKategori(produk, "Elektronik"));
console.log(semuaRatingDiAtas(produk, 4.0), semuaRatingDiAtas(produk, 4.5));

console.log("== Intermediate 1 ==");
for (const baris of rincianCheckout(keranjang, produk)) console.log(baris);
console.log(`Total: ${totalCheckout(keranjang, produk)}`);

console.log("== Intermediate 2 ==");
console.log(totalTerjual(produk));

console.log("== Intermediate 3 ==");
const termurah = urutHargaTermurah(produk);
console.log(termurah.slice(0, 3).map((p) => p.nama).join(", "));
console.log(`Produk pertama di data asli: ${produk[0].nama}`);

console.log("== Intermediate 4 ==");
console.log(cariProdukHabis(produk));
console.log(cariProdukHabis(produk.filter((p) => p.stok > 0)));

console.log("== Advanced 1 ==");
for (const baris of laporanKategori(produk)) console.log(baris);

console.log("== Advanced 2 ==");
console.log(checkout(keranjang, produk, null));
console.log(checkout(keranjang, produk, "HEMAT10"));
console.log(checkout([{ idProduk: "P03", qty: 1 }, { idProduk: "P04", qty: 2 }], produk, "GRATIS-ONGKIR"));
console.log(checkout([{ idProduk: "P03", qty: 1 }, { idProduk: "P04", qty: 2 }], produk, null));
console.log(checkout([{ idProduk: "P01", qty: 3 }], produk, "HEMAT10"));
console.log(checkout([{ idProduk: "P01", qty: 3 }, { idProduk: "P06", qty: 9 }], produk, null));
console.log(checkout([{ idProduk: "P02", qty: 1 }], produk, null));
console.log(checkout([{ idProduk: "P99", qty: 1 }], produk, null));
console.log(checkout(keranjang, produk, "DISKON50"));
console.log(checkout([], produk, null));
