// Kode tampilan: hanya berjalan di browser (memakai document).
// Buka lewat server: npm run sajikan, lalu buka alamat yang dicetak.
import { produk, formatRupiah, teksMenu, kurangiItem, hitungTotal, validasiBayar, tambahItem } from "./toko.js";

// State: isi keranjang saat ini. Tampilan selalu dibuat ulang dari variabel ini.
let keranjang = [];

const daftarProduk = document.querySelector("#daftar-produk");
const daftarKeranjang = document.querySelector("#daftar-keranjang");
const elTotal = document.querySelector("#total");
const form = document.querySelector("#form-bayar");
const inputUang = document.querySelector("#input-uang");
const pesan = document.querySelector("#pesan");

// ===== Beginner 3 =====
function renderMenu() {
  // TODO: satu <li> untuk setiap produk, berisi <span> teksMenu dan <button> "Tambah" dengan data-id
}

// ===== Intermediate 4 =====
function renderKeranjang() {
  // TODO: kosongkan daftarKeranjang, isi ulang dari keranjang, lalu perbarui elTotal
}

// TODO (Intermediate 4): klik tombol "Tambah" di daftarProduk -> tambahItem -> renderKeranjang

// TODO (Intermediate 4): klik tombol "Kurangi" di daftarKeranjang -> kurangiItem -> renderKeranjang

// ===== Advanced 1 =====
// TODO (opsional): submit form -> validasiBayar -> tampilkan pesan -> kosongkan keranjang jika berhasil

renderMenu();
renderKeranjang();
