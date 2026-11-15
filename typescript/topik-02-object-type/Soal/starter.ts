// Praktikum TS Modul 2 — file starter
// 1. Salin file ini ke Jawaban/soal-ts2.ts.
// 2. Lengkapi bagian bertanda TODO dan perbaiki kode milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Cek tipe dulu: npx tsc --noEmit   (harus tanpa error di akhir)
//    Saat baru disalin, tsc menampilkan error di bagian DATA karena interface masih kosong.
//    Error itu hilang setelah interface dan type di bawah lengkap.
// 4. Lalu jalankan: node Jawaban/soal-ts2.ts
// 5. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.

// ===== Coba Sendiri (dari HO) =====
// Bagian 1: tulis tebakan output sebagai komentar di ujung baris console.log.
// Jalankan bagian ini saja: node Jawaban/soal-ts2.ts coba
function cobaSendiri() {
  type Titik = [number, number];
  const t: Titik = [3, 4];

  interface Kota {
    readonly nama: string;
    penduduk?: number;
  }
  const solo: Kota = { nama: "Solo" };

  const nilai: Record<string, number> = { a: 1 };
  console.log(t[0] + t[1], solo.penduduk, nilai["b"]);

  // Bagian 2: hapus // di depan SATU baris, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // solo.nama = "Surakarta";
  // const t2: Titik = [3, 4, 5];
  // const solo2: Kota = { nama: "Solo", provinsi: "Jawa Tengah" };
  // console.log(solo.penduduk + 1);
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

// Sudah jadi: format Rupiah dari TS-1.
const rupiah = (n: number): string => `Rp${new Intl.NumberFormat("id-ID").format(n)}`;

// ===== TIPE (Beginner 1, Beginner 2, Intermediate 2) =====
// TODO Beginner 1: id (tidak boleh diubah), nama, kategori, harga, stok, diskonPersen (boleh tidak ada)
interface Produk {}

// TODO Beginner 2: pasangan [id, qty]
type BarisKeranjang = unknown;

// TODO Intermediate 2: type Alamat (kota, kodePos) dan interface Pembeli (nama, alamat boleh tidak ada)
type Alamat = {};
interface Pembeli {}

// Sudah jadi, dipakai Advanced 1.
interface Ringkasan {
  totalBayar: number;
  jumlahBarang: number;
  ditolak: string[];
}

// ===== DATA (JANGAN DIUBAH) =====
const katalog: Produk[] = [
  { id: "P01", nama: "Kaos Polos", kategori: "pakaian", harga: 50000, stok: 10 },
  { id: "P02", nama: "Celana Chino", kategori: "pakaian", harga: 150000, stok: 3, diskonPersen: 10 },
  { id: "P03", nama: "Botol Minum", kategori: "rumah", harga: 45000, stok: 0 },
  { id: "P04", nama: "Lampu Meja", kategori: "rumah", harga: 120000, stok: 5, diskonPersen: 25 },
  { id: "P05", nama: "Buku Tulis", kategori: "alat tulis", harga: 8000, stok: 50 },
];

const keranjangA: BarisKeranjang[] = [["P01", 2], ["P02", 1], ["P05", 3]];
const keranjangB: BarisKeranjang[] = [["P03", 1], ["P04", 6], ["P99", 1], ["P04", 2]];

const daftarPembeli: Pembeli[] = [
  { nama: "Rina", alamat: { kota: "Salatiga", kodePos: "50711" } },
  { nama: "Joko" },
];

// ===== Beginner 1 =====
function hargaAkhir(p: Produk): number {
  // TODO
  return 0;
}

// ===== Beginner 2 =====
function jumlahBarang(keranjang: BarisKeranjang[]): number {
  // TODO
  return 0;
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (pesan error tsc, mengapa ditolak, apa yang diubah agar warna bisa disimpan):
//

// ===== Intermediate 1 =====
function stokPerKategori(daftar: readonly Produk[]): Record<string, number> {
  // TODO
  return {};
}

// ===== Intermediate 2 =====
function labelPengiriman(p: Pembeli): string {
  // TODO
  return "";
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
function urutTermurah(daftar: Produk[]): string[] {
  return daftar.sort((a, b) => hargaAkhir(a) - hargaAkhir(b)).map((p) => p.nama);
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah, bentuk data per langkah, kapan sebuah baris ditolak):
//
function ringkasPesanan(keranjang: BarisKeranjang[], daftar: readonly Produk[]): Ringkasan {
  // TODO (opsional)
  return { totalBayar: 0, jumlahBarang: 0, ditolak: [] };
}

// Sudah jadi, jangan diubah.
function cetakRingkasan(r: Ringkasan): string {
  return [
    `Total bayar: ${rupiah(r.totalBayar)}`,
    `Jumlah barang: ${r.jumlahBarang}`,
    `Ditolak: ${r.ditolak.length === 0 ? "-" : r.ditolak.join(", ")}`,
  ].join("\n");
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(hargaAkhir(katalog[0]), hargaAkhir(katalog[1]), hargaAkhir(katalog[3]));

console.log("== Beginner 2 ==");
console.log(jumlahBarang(keranjangA));
console.log(jumlahBarang([]));

console.log("== Intermediate 1 ==");
console.log(JSON.stringify(stokPerKategori(katalog)));

console.log("== Intermediate 2 ==");
console.log(labelPengiriman(daftarPembeli[0]));
console.log(labelPengiriman(daftarPembeli[1]));

console.log("== Intermediate 3 ==");
console.log(urutTermurah(katalog).join(", "));
console.log(katalog[0].nama);

console.log("== Advanced 1 ==");
console.log(cetakRingkasan(ringkasPesanan(keranjangA, katalog)));
console.log(cetakRingkasan(ringkasPesanan(keranjangB, katalog)));
