// Praktikum JS Modul 6 — modul kasir (starter)
// Salin file ini ke Jawaban/kasir.js. File soal-js6.js meng-import fungsi dari file ini.
// Lengkapi setiap fungsi bertanda TODO.

// ===== Beginner 1 =====
// formatRupiah(n: number): string
export function formatRupiah(n) {
  // TODO
  return String(n);
}

// ===== Beginner 2 =====
// bulatkanKe(n: number, kelipatan: number): number
export function bulatkanKe(n, kelipatan) {
  // TODO
  return n;
}

// ===== Beginner 3 =====
// kategoriUnik(produk: Produk[]): string[]
export function kategoriUnik(produk) {
  // TODO: pakai Set
  return [];
}

// ===== Intermediate 1 =====
// buatIndex(produk: Produk[]): Map<string, Produk>   (key: id produk)
export function buatIndex(produk) {
  // TODO
  return new Map();
}

// ===== Intermediate 2 =====
// validasiQty(qty: unknown): number   (melempar Error jika tidak valid)
export function validasiQty(qty) {
  // TODO
  return qty;
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// formatTanggal(tgl: Date): string   format DD-MM-YYYY
export function formatTanggal(tgl) {
  return `${tgl.getDate()}-${tgl.getMonth()}-${tgl.getFullYear()}`;
}

// ===== Advanced 1 =====
// buatStruk(keranjang: { id: string, qty: number }[], index: Map<string, Produk>, tanggal: Date): string
// Melempar Error jika produk tidak ada atau qty tidak valid.
export function buatStruk(keranjang, index, tanggal) {
  // TODO (opsional)
  return "";
}
