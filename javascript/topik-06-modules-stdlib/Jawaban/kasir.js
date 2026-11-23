// Praktikum JS Modul 6 — modul kasir (starter)
// Salin file ini ke Jawaban/kasir.js. File soal-js6.js meng-import fungsi dari file ini.
// Lengkapi setiap fungsi bertanda TODO.

// ===== Beginner 1 =====
// formatRupiah(n: number): string
export function formatRupiah(n) {

  const formatID = new Intl.NumberFormat("id-ID",{maximumFractionDigits:2})
  return `Rp${formatID.format(n)}`;
}

// ===== Beginner 2 =====
// bulatkanKe(n: number, kelipatan: number): number
export function bulatkanKe(n, kelipatan) {
  
  // ≈ 3 baris
  let bulat = 0
  if (n%kelipatan !== 0 ) bulat = 1 ;
  n = Math.floor(n/kelipatan) * kelipatan + bulat * kelipatan;
  return n;
}

// ===== Beginner 3 =====
// kategoriUnik(produk: Produk[]): string[]
export function kategoriUnik(produk) {
  
  // ≈ 3 baris
  const s = new Set(produk.map((p)=>p.kategori))
  return [...s];
}

// ===== Intermediate 1 =====
// buatIndex(produk: Produk[]): Map<string, Produk>   (key: id produk)
export function buatIndex(produk) {
  const indexProduk = new Map();
  for(const p of produk){
    indexProduk.set(p.id,p)
  } 
  return indexProduk
  
}

// ===== Intermediate 2 =====
// validasiQty(qty: unknown): number   (melempar Error jika tidak valid)
export function validasiQty(qty) {
  
  // ≈ 6 baris
  if(qty <= 0 || !Number.isInteger(qty)){
    throw new Error("qty harus bilangan bulat positif");
  }
  return qty;
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// formatTanggal(tgl: Date): string   format DD-MM-YYYY
export function formatTanggal(tgl) {
  return `${String(tgl.getDate()).padStart(2,"0")}-${String(tgl.getMonth()+1).padStart(2,"0")}-${String(tgl.getFullYear()).padStart(4,"0")}`;
}

// ===== Advanced 1 =====
// buatStruk(keranjang: { id: string, qty: number }[], index: Map<string, Produk>, tanggal: Date): string
// Melempar Error jika produk tidak ada atau qty tidak valid.
export function buatStruk(keranjang, index, tanggal) {
  // TODO (opsional)
  // ≈ 10 baris
  return "";
}
