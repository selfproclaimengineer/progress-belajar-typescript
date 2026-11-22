// Praktikum TS Modul 6 — file starter
// 1. Salin file ini ke Jawaban/soal-ts6.ts.
// 2. Lengkapi bagian bertanda TODO dan perbaiki kode milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Cek tipe dulu: npx tsc --noEmit   (harus tanpa error di akhir)
// 4. Lalu jalankan: node Jawaban/soal-ts6.ts
// 5. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.
// Library zod sudah terpasang di repo (npm install sudah dijalankan).
import { z } from "zod";

// ===== Coba Sendiri (dari HO) =====
// Bagian 1: tulis tebakan output sebagai komentar di ujung setiap baris console.log.
// Jalankan bagian ini saja: node Jawaban/soal-ts6.ts coba
function cobaSendiri() {
  const data: unknown = JSON.parse('{"nama":"Ani","umur":"20"}');
  const bebas = JSON.parse('{"nama":"Ani","umur":"20"}');
  console.log(typeof data, bebas.umur + 1);

  function apakahAngka(x: unknown): x is number {
    return typeof x === "number";
  }
  const nilai: unknown = 42;
  if (apakahAngka(nilai)) console.log(nilai.toFixed(1));

  const Skema = z.object({ nama: z.string(), umur: z.number() });
  const r = Skema.safeParse({ nama: "Ani", umur: "20" });
  console.log(r.success);

  // Bagian 2: hapus // di depan SATU baris, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // console.log(data.nama);
  // console.log(r.data.nama);
  // const p: z.infer<typeof Skema> = { nama: "Ani" };
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

// ===== TIPE (JANGAN DIUBAH) =====
interface ItemPesanan {
  kode: string;
  qty: number;
}

interface Pesanan {
  idPelanggan: string;
  items: ItemPesanan[];
  catatan?: string;
}

interface Produk {
  kode: string;
  nama: string;
  harga: number;
}

type Hasil<T> = { ok: true; nilai: T } | { ok: false; error: string };

// ===== DATA (JANGAN DIUBAH) =====
// key: kode barang, value: harga
const katalog = new Map([
  ["B01", 68000], // Beras 5 kg
  ["B02", 18000], // Minyak goreng 1 L
  ["B03", 16500], // Gula 1 kg
  ["B04", 28000], // Telur 1 kg
]);

// Teks JSON pesanan dari aplikasi pelanggan (Intermediate 1 dan 2).
const contoh = [
  '{"idPelanggan":"C01","items":[{"kode":"B01","qty":2},{"kode":"B03","qty":1}]}',
  '{"idPelanggan":"C02","items":[{"kode":"B02","qty":"3"}]}',
  '{"idPelanggan":"","items":[]}',
  "[1, 2]",
  '{"idPelanggan":"C03","items":[{"kode":"B04","qty":1}],"catatan":12}',
];

// Kiriman pesanan dari mitra, satu teks JSON per baris (Advanced 1).
const kirimanMitra = [
  '{"idPelanggan":"C10","items":[{"kode":"B01","qty":1},{"kode":"B04","qty":2}]}',
  '{"idPelanggan":"C11","items":[{"kode":"B02","qty":2}]',
  '{"idPelanggan":"C12","items":[{"kode":"B09","qty":1}]}',
  '{"idPelanggan":"C13","items":[{"kode":"B03","qty":0}]}',
  '{"idPelanggan":"C14","items":[{"kode":"B02","qty":3},{"kode":"B03","qty":2}],"catatan":"antar sore"}',
];

// ===== Beginner 1 =====
function apakahObject(x: unknown): x is Record<string, unknown> {
  // TODO
  // ≈ 3 baris
  return false;
}

// ===== Beginner 2 =====
function apakahItem(x: unknown): x is ItemPesanan {
  // TODO
  // ≈ 3 baris
  return false;
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (hasil tsc dan node, mengapa tsc diam, apa yang berubah dengan unknown dan apakahItem):
//

// ===== Intermediate 1 =====
function validasiManual(x: unknown): Hasil<Pesanan> {
  // TODO
  // ≈ 16 baris
  return { ok: false, error: "belum dibuat" };
}

// ===== Intermediate 2 =====
// JAWABAN Intermediate 2 (bandingkan dengan Intermediate 1, dari mana tsc tahu bentuk PesananZod):
//
// TODO: tulis skema zod untuk Pesanan, lengkap dengan pesan error seperti di soal
// ≈ 16 baris
const SkemaPesanan = z.object({});

type PesananZod = z.infer<typeof SkemaPesanan>;

function validasiZod(x: unknown): Hasil<PesananZod> {
  // TODO
  // ≈ 7 baris
  return { ok: false, error: "belum dibuat" };
}

// Sudah jadi, jangan diubah.
function cetakHasil(h: Hasil<{ idPelanggan: string; items: ItemPesanan[] }>): string {
  if (!h.ok) return `GAGAL: ${h.error}`;
  return `OK: ${h.nilai.idPelanggan}, ${h.nilai.items.length} item`;
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
function apakahProduk(x: unknown): x is Produk {
  return typeof x === "object" && x !== null && "kode" in x;
}

function totalKatalogMitra(teksJson: string): number {
  const data = JSON.parse(teksJson);
  return data.filter(apakahProduk).reduce((total: number, p: Produk) => total + p.harga, 0);
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (lapisan pemeriksaan dan urutannya, bentuk data per langkah, kapan memakai try/catch):
//
function prosesKiriman(daftarTeks: string[], hargaPerKode: Map<string, number>): string {
  // TODO (opsional)
  // ≈ 32 baris
  return "";
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(apakahObject({ a: 1 }), apakahObject(null), apakahObject([1]), apakahObject("x"));

console.log("== Beginner 2 ==");
console.log(apakahItem({ kode: "B01", qty: 2 }), apakahItem({ kode: "B01", qty: "2" }), apakahItem({ kode: "B01", qty: 1.5 }), apakahItem({ qty: 2 }));

console.log("== Intermediate 1 ==");
for (const teks of contoh) console.log(cetakHasil(validasiManual(JSON.parse(teks))));

console.log("== Intermediate 2 ==");
for (const teks of contoh) console.log(cetakHasil(validasiZod(JSON.parse(teks))));

console.log("== Intermediate 3 ==");
console.log(totalKatalogMitra('[{"kode":"X1","nama":"Kopi","harga":15000},{"kode":"X2","nama":"Teh","harga":"12000"},{"kode":"X3","nama":"Susu"}]'));
console.log(totalKatalogMitra('[{"kode":"Y1","nama":"Roti","harga":9000},{"kode":"Y2","nama":"Keju","harga":31000}]'));

console.log("== Advanced 1 ==");
console.log(prosesKiriman(kirimanMitra, katalog));
