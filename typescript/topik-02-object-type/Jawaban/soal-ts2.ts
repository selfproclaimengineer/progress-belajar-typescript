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
  console.log(t[0] + t[1], solo.penduduk, nilai["b"]); // 7, undefined, undefined

  // Bagian 2: hapus // di depan SATU baris, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // solo.nama = "Surakarta";
  // const t2: Titik = [3, 4, 5];
  // soal-ts2.ts:30:9 - error TS2322: Type '[number, number, number]' is not assignable to type 'Titik'.
  // Source has 3 element(s) but target allows only 2.
  // 30   const t2: Titik = [3, 4, 5];

  // const solo2: Kota = { nama: "Solo", provinsi: "Jawa Tengah" };
  // 34:39 - error TS2353: Object literal may only specify known properties, and 'provinsi' does not exist in type 'Kota'.
  // 34   const solo2: Kota = { nama: "Solo", provinsi: "Jawa Tengah" };

  // console.log(solo.penduduk + 1);
  // soal-ts2.ts:39:15 - error TS18048: 'solo.penduduk' is possibly 'undefined'.
  // 39   console.log(solo.penduduk + 1);

}

// JAWABAN Coba Sendiri 1:
// tidak ada, benar semua
// JAWABAN Coba Sendiri 2:
// Sudah di atas
// JAWABAN Coba Sendiri 3:
// Karena pada record, ada 2 parameter yaitu string dan number
// JAWABAN Coba Sendiri 4:
// Tidak bisa, karena keunggulan tipe adalah union dan literal
// sementara keunggulan interface adalah menciptakan deskripsi
// bentuk object

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// Sudah jadi: format Rupiah dari TS-1.
const rupiah = (n: number): string => `Rp${new Intl.NumberFormat("id-ID").format(n)}`;

// ===== TIPE (Beginner 1, Beginner 2, Intermediate 2) =====
// Beginner 1: id (tidak boleh diubah), nama,
// kategori, harga, stok, diskonPersen (boleh tidak ada)
// ≈ 8 baris
interface Produk {
  readonly id: string;
  nama: string;
  kategori: string;
  harga: number;
  stok: number;
  diskonPersen?: number;
}

// Beginner 2: pasangan [id, qty]
// ≈ 1 baris
type BarisKeranjang = [id:string,qty:number];

// : type Alamat (kota, kodePos) dan interface Pembeli
// (nama, alamat boleh tidak ada)
// ≈ 5 baris
type Alamat = {
  kota:string;
  kodePos:string;
};
interface Pembeli {
  nama:string;
  alamat?:Alamat;
}

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
  
  // ≈ 3 baris
  let potongan = Math.floor(p.harga * (p.diskonPersen ?? 0)/100);
  return p.harga-potongan;
}

// ===== Beginner 2 =====
function jumlahBarang(keranjang: BarisKeranjang[]): number {
  
  // ≈ 3 baris
  let jumlah:number=0;
  for (const [kode,qty] of keranjang){
    jumlah += qty
  }
  return jumlah;
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (pesan error tsc, mengapa ditolak, apa yang diubah agar warna bisa disimpan):
// 
// const baru: Produk = { id: "P06", nama: "Topi", kategori: "pakaian", harga: 35000, stok: 4, warna: "hitam" };
// Object literal may only specify known properties, and 'warna' does not exist in type 'Produk'.

// Karena di Interface Produk, tidak ada attribut warna, sama seperti
// hrga tidak ada di attribut Produk, jadi tidak bisa menambah sembarangan
// variabel ke interface.
// kalau ingin opsional pakai
// warna?: string


// ===== Intermediate 1 =====
function stokPerKategori(daftar: readonly Produk[]): Record<string, number> {
  const stok: Record<string,number> = {};
  for (const p of daftar){
    stok[p.kategori] = (stok[p.kategori] ?? 0) + p.stok
  }
  return stok;
}

// ===== Intermediate 2 =====
function labelPengiriman(p: Pembeli): string {
  
  if(p.alamat !== undefined){
    return `${p.nama} - ${p.alamat?.kota} ${p.alamat?.kodePos}`;
  } else{
    return `${p.nama} - alamat belum diisi`
  }
  
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
// error TS2339: Property 'sort' does not exist on type 'readonly Produk[]'
// tsc tidak menolak karena tidak ada readonly pada Produk sehingga
// program menganggap datanya boleh diubah
// error itu justru membantu menemukan logic error yang sulit ditemukan
// di javascript seperti kasus ini di mana arraynya sebenarnya tidak boleh
// diubah di function ini. Jadi untuk debuggingnya lebih mudah.

function urutTermurah(daftar: readonly Produk[]): string[] {
  return daftar.map((p)=>p).sort((a, b) => hargaAkhir(a) - hargaAkhir(b)).map((p) => p.nama);
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah, bentuk data per langkah, kapan sebuah baris ditolak):
//
function ringkasPesanan(keranjang: BarisKeranjang[], daftar: readonly Produk[]): Ringkasan {
  // TODO (opsional)
  // ≈ 15 baris
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
