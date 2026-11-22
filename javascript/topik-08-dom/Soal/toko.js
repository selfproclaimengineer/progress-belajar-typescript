// Logika toko: fungsi murni, TANPA DOM (tidak memakai document).
// Dipakai oleh soal-js8.js (dijalankan dengan node) dan halaman.js (dijalankan di browser).

// ===== DATA (JANGAN DIUBAH) =====
// Produk = { id: string, nama: string, harga: number }
export const produk = [
  { id: "R01", nama: "Roti Tawar", harga: 15000 },
  { id: "R02", nama: "Donat Cokelat", harga: 8000 },
  { id: "R03", nama: "Croissant", harga: 18000 },
  { id: "R04", nama: "Bolu Pandan", harga: 45000 },
];

// Sudah jadi.
export const formatRupiah = (n) => `Rp${new Intl.NumberFormat("id-ID").format(n)}`;

// Keranjang = { id: string, qty: number }[]

// ===== Beginner 1 =====
// teksMenu(p: Produk): string
export function teksMenu(p) {
  // TODO
  // ≈ 3 baris
  return "";
}

// ===== Beginner 2 =====
// kurangiItem(keranjang: Keranjang, id: string): Keranjang   (keranjang lama tidak boleh berubah)
export function kurangiItem(keranjang, id) {
  // TODO
  // ≈ 3 baris
  return keranjang;
}

// ===== Intermediate 1 =====
// hitungTotal(keranjang: Keranjang, daftarProduk: Produk[]): number
export function hitungTotal(keranjang, daftarProduk) {
  // TODO
  // ≈ 6 baris
  return 0;
}

// ===== Intermediate 2 =====
// validasiBayar(teksUang: string, total: number): { ok: boolean, pesan: string }
export function validasiBayar(teksUang, total) {
  // TODO
  // ≈ 8 baris
  return { ok: false, pesan: "" };
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// tambahItem(keranjang: Keranjang, id: string): Keranjang   (keranjang lama tidak boleh berubah)
export function tambahItem(keranjang, id) {
  const baru = [...keranjang];
  const item = baru.find((x) => x.id === id);
  if (item) item.qty++;
  else baru.push({ id, qty: 1 });
  return baru;
}
