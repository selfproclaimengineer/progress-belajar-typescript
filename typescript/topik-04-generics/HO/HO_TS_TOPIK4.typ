#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "TypeScript Modul 4", judul: "Generics")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menjelaskan masalah yang diselesaikan generics: kode kembar atau kode bertipe `any`
- Menulis fungsi generik dengan parameter tipe `T`, dan membaca tipe hasil yang ditebak TypeScript
- Membatasi parameter tipe dengan `extends` (constraint)
- Menulis class dan interface generik
- Membentuk tipe baru dari tipe lama dengan `Partial`, `Pick`, dan `Omit`

= Dasar Teori

== Masalah: Kode Kembar atau any

*Untuk apa:* sering ada fungsi yang langkahnya sama persis untuk berbagai jenis data. Mencari berdasarkan id, misalnya, sama saja untuk pasien, dokter, dan obat. Tanpa generics hanya ada dua pilihan, dan keduanya buruk.

#listing("pilihan 1: fungsi kembar")[```ts
function cariPasien(daftar: Pasien[], id: string): Pasien | undefined {
  return daftar.find((x) => x.id === id);
}
function cariDokter(daftar: Dokter[], id: string): Dokter | undefined {
  return daftar.find((x) => x.id === id);
}
// ... dan seterusnya untuk setiap jenis data
```]

#listing("pilihan 2: satu fungsi any")[```ts
function cariAny(daftar: any[], id: string): any {
  return daftar.find((x) => x.id === id);
}
const d = cariAny(daftarDokter, "DR03");   // d bertipe any
console.log(d.spesialisasi);                // lolos tsc, padahal field-nya bernama spesialis
```]

Pilihan 1 aman tetapi berulang. Bug yang diperbaiki di satu fungsi mudah terlupa di fungsi lain. Pilihan 2 pendek, tetapi hasilnya `any`, sehingga `tsc` berhenti memeriksa semua kode yang memakai hasil itu.

Generics memberi pilihan ketiga: satu fungsi, dan tipe hasilnya tetap mengikuti data yang dikirim.

#dipakai[Beginner 3, untuk membandingkan versi `any` dengan `cariById` generik. Cerita soal berawal dari masalah di bagian ini.]

== Fungsi Generik

*Cara kerja:* tulis parameter tipe di dalam `< >` setelah nama fungsi, biasanya dinamai `T`. `T` dipakai seperti tipe biasa di parameter dan nilai kembalian. Saat fungsi dipanggil, TypeScript mengisi `T` dari argumen yang dikirim.

#listing("satu fungsi untuk semua jenis array")[```ts
function pertama<T>(daftar: readonly T[]): T | undefined {
  return daftar[0];
}

const a = pertama([10, 20, 30]);         // T = number,  a: number | undefined
const b = pertama(["umum", "gigi"]);     // T = string,  b: string | undefined
const c = pertama(daftarPasien);         // T = Pasien,  c: Pasien | undefined
console.log(c?.nama);                    // tsc tahu c punya field nama
console.log(c?.namaa);                   // TS2551: Property 'namaa' does not exist on type 'Pasien'. Did you mean 'nama'?
```]

Analogi: `T` adalah *parameter untuk tipe*. Parameter biasa diisi nilai saat fungsi dipanggil (`daftar` diisi `[10, 20, 30]`). Parameter tipe diisi tipe (`T` diisi `number`). Analogi SQL: seperti satu query yang sama dijalankan pada tabel berbeda. Bentuk hasilnya mengikuti kolom tabel yang dipakai.

Bagaimana TypeScript mengisi `T` pada `pertama([10, 20, 30])`:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Langkah*], [*Yang terjadi*],
  [1], [Parameter `daftar` bertipe `readonly T[]`. Argumennya `[10, 20, 30]` bertipe `number[]`.],
  [2], [Kedua tipe dicocokkan: `T[]` dengan `number[]`, jadi `T` = `number`.],
  [3], [Semua `T` di signature diganti `number`. Nilai kembaliannya menjadi `number | undefined`.],
)

`T` bisa juga diisi secara tertulis: `pertama<string>([])`. Ini perlu jika TypeScript tidak punya petunjuk, misalnya untuk array kosong atau untuk class yang dibuat tanpa argumen (`new Antrian<string>()`).

=== Callback yang ikut bertipe

Jika parameter callback memakai `T`, parameter callback itu otomatis bertipe sama dengan isi array. Inilah sebabnya `daftarPasien.filter((p) => p.umur > 40)` tahu bahwa `p` adalah `Pasien`: `filter` milik array juga fungsi generik.

#listing("callback memakai T")[```ts
function ambilJika<T>(daftar: readonly T[], syarat: (x: T) => boolean): T[] {
  return daftar.filter(syarat);
}

ambilJika(daftarPasien, (p) => p.poli === "anak");   // p: Pasien
ambilJika([5, 12, 8], (n) => n > 6);                 // n: number, hasil [12, 8]
ambilJika([5, 12, 8], (n) => n.length > 0);          // TS2339: Property 'length' does not exist on type 'number'.
```]

=== `T` atau `any`?

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [], [*`any`*], [*`T`*],
  [Arti], ["jangan periksa apa pun"], ["tipe tertentu yang ditentukan saat dipanggil"],
  [Hasil `pertama(daftarPasien)`], [`any`], [`Pasien | undefined`],
  [Salah ketik field pada hasil], [lolos `tsc`, `undefined` saat jalan], [ditolak `tsc`],
  [Hubungan input dan output], [hilang], [tetap: output bertipe sama dengan isi input],
)

#dipakai[
  - Beginner 1, untuk `terakhir<T>` dan `hitungJika<T>` dengan callback `syarat: (x: T) => boolean`.
  - Beginner 3, untuk menjelaskan beda `T` dengan `any`.
  - Intermediate 1, untuk `kelompokkan<T>` dengan callback `kunci: (x: T) => string`.
]

== Constraint: Membatasi T

*Untuk apa:* kadang fungsi generik perlu memakai field tertentu dari `T`, misalnya `id`. Tanpa batasan, `T` bisa apa saja, termasuk number yang tidak punya `id`, sehingga `tsc` menolak `x.id`.

*Cara kerja:* `T extends { id: string }` berarti "`T` boleh tipe apa saja *asalkan* punya field `id` bertipe string". Di dalam fungsi, `x.id` jadi boleh dipakai. Di luar fungsi, `tsc` menolak argumen yang tidak memenuhi syarat itu.

#listing("constraint")[```ts
function panjang<T>(x: T): number {
  return x.length;                 // TS2339: Property 'length' does not exist on type 'T'.
}

function panjangAman<T extends { length: number }>(x: T): number {
  return x.length;                 // boleh: T pasti punya length
}

panjangAman("halo");               // 4    (string punya length)
panjangAman([1, 2, 3]);            // 3    (array punya length)
panjangAman(5);                    // TS2345: Argument of type 'number' is not assignable
                                   //         to parameter of type '{ length: number; }'.
```]

Tipe yang punya field *lebih banyak* dari syarat tetap diterima. `Pasien` punya `id`, `nama`, `umur`, dan field lain, tetapi tetap memenuhi `{ id: string }` karena syaratnya hanya "punya `id`". Ini sama dengan aturan bentuk di TS-3.

`extends` di sini *bukan* pewarisan class seperti `class Kilat extends Ongkir`. Di dalam `< >`, `extends` berarti "harus memenuhi bentuk".

#dipakai[Beginner 2, untuk `cariById<T extends { id: string }>` yang dipakai untuk `Pasien` dan `Dokter`.]

== Class dan Interface Generik

*Untuk apa:* class atau interface yang menyimpan data jenis apa saja, tetapi jenisnya tetap satu dan tetap diperiksa. Contohnya antrian: isinya bisa pasien atau nomor karcis, tetapi satu antrian hanya berisi satu jenis.

Sebenarnya kamu sudah memakai tipe generik sejak TS-1. `Map<string, number>` adalah class generik dengan dua parameter tipe, dan `number[]` adalah cara singkat menulis `Array<number>`.

#listing("class generik")[```ts
class Tumpukan<T> {
  private isi: T[] = [];
  taruh(x: T): void {
    this.isi.push(x);
  }
  ambil(): T | undefined {
    return this.isi.pop();      // yang terakhir ditaruh, pertama diambil
  }
  get jumlah(): number {
    return this.isi.length;
  }
}

const piring = new Tumpukan<string>();
piring.taruh("piring merah");
piring.taruh("piring biru");
console.log(piring.ambil());     // "piring biru"
console.log(piring.jumlah);      // 1
piring.taruh(5);                 // TS2345: Argument of type 'number' is not assignable to parameter of type 'string'.
```]

`Tumpukan` mengambil dari belakang dengan `pop`. Antrian (yang datang duluan keluar duluan) mengambil dari depan. Method array yang mengeluarkan isi *pertama* adalah `shift()`, yang juga mengembalikan `undefined` jika array kosong.

#table(
  columns: (auto, auto, auto),
  inset: 6pt,
  [*Method*], [*Mengeluarkan*], [*Isi array sesudahnya, dari `["A", "B", "C"]`*],
  [`pop()`], [`"C"` (terakhir)], [`["A", "B"]`],
  [`shift()`], [`"A"` (pertama)], [`["B", "C"]`],
)

Interface juga bisa generik. Bentuk "hasil beserta keterangannya" sering ditulis begini:

#listing("interface generik")[```ts
interface Kotak<T> {
  isi: T;
  label: string;
}

const k1: Kotak<number> = { isi: 42, label: "jawaban" };
const k2: Kotak<Pasien[]> = { isi: daftarPasien, label: "semua pasien" };
console.log(k2.isi[0].nama);    // tsc tahu isi adalah Pasien[]
```]

#catatan[
  Untuk mengambil potongan array, pakai `slice(awal, akhir)` dari JS-4. Isi yang diambil mulai index `awal` sampai *sebelum* index `akhir`, dan array asli tidak berubah. Jika `awal` sudah melewati panjang array, hasilnya array kosong, bukan error: `[1, 2, 3].slice(6, 9)` menghasilkan `[]`.
]

#dipakai[
  - Intermediate 2, untuk `class Antrian<T>` dengan field `private isi: T[]` dan `panggil()` yang memakai `shift()`.
  - Advanced 1, untuk membaca interface `Halaman<T>` dan mengambil isi halaman dengan `slice`.
]

== Utility Type: Partial, Pick, Omit

*Untuk apa:* membentuk tipe baru dari tipe yang sudah ada, tanpa menulis ulang field-nya. Jika `Pasien` berubah, tipe turunannya ikut berubah.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Utility type*], [*Artinya*], [*Contoh dari `Pasien`*],
  [`Partial<T>`], [semua field menjadi opsional (`?`)], [`Partial<Pasien>`: `{ id?, nama?, umur?, poli?, telepon? }`],
  [`Pick<T, K>`], [hanya ambil field yang disebut], [`Pick<Pasien, "nama" | "poli">`: `{ nama, poli }`],
  [`Omit<T, K>`], [semua field kecuali yang disebut], [`Omit<Pasien, "id">`: `{ nama, umur, poli, telepon }`],
  [`Readonly<T>`], [semua field menjadi `readonly`], [`Readonly<Pasien>`],
  [`Record<K, V>`], [object dengan key `K` dan value `V` (TS-2)], [`Record<string, Pasien[]>`],
)

Analogi SQL: `Pick<Pasien, "nama" | "poli">` seperti `SELECT nama, poli FROM pasien`. `Omit` seperti memilih semua kolom kecuali beberapa.

Utility type bisa digabung. Baca dari dalam ke luar:

#listing("menggabung utility type")[```ts
type DataPasienBaru = Omit<Pasien, "id">;            // pendaftaran: id dibuat sistem
type PerubahanPasien = Partial<Omit<Pasien, "id">>;  // ubah sebagian, kecuali id

// Partial<Omit<Pasien, "id">> dibaca:
// 1. Omit<Pasien, "id">  menjadi  { nama; umur; poli; telepon }
// 2. Partial<...>        menjadi  { nama?; umur?; poli?; telepon? }

const ubah1: PerubahanPasien = { telepon: "0812" };        // boleh, sebagian saja
const ubah2: PerubahanPasien = {};                         // boleh, tidak ada yang diubah
const ubah3: PerubahanPasien = { id: "PS99" };
// TS2353: Object literal may only specify known properties, and 'id' does not exist in type 'Partial<Omit<Pasien, "id">>'.
```]

=== Membuat salinan yang diperbarui

Spread object dari JS-4 membuat object *baru*. Field di sebelah kanan menimpa field yang sama di sebelah kiri. `Object.assign(p, ...)` justru *mengubah* `p`.

#listing("salinan baru vs mengubah asli")[```ts
const obat = { kode: "OB01", nama: "Paracetamol", stok: 40 };

const salinan = { ...obat, stok: 35 };   // object baru
console.log(obat.stok, salinan.stok);    // 40 35

Object.assign(obat, { stok: 35 });       // mengubah obat itu sendiri
console.log(obat.stok);                  // 35
```]

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Cara*], [*Hasil*], [*Object asli*],
  [`{ ...p, ...perubahan }`], [object baru], [tidak berubah],
  [`Object.assign(p, perubahan)`], [`p` itu sendiri], [berubah],
)

#dipakai[
  - Intermediate 3, untuk tipe `perubahan` di `perbaruiPasien` (`Partial` dan `Omit`) dan untuk membuat salinan dengan spread.
  - Coba Sendiri, untuk `Partial<Pasien>`, `Pick`, dan `Omit<Pasien, "id">`.
]

== Membaca Pesan Error tsc (tambahan TS-4)

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Nomor*], [*Pesan*], [*Penyebab umum*],
  [`TS2339`], [`Property 'length' does not exist on type 'T'.`], [Memakai field dari `T` tanpa constraint.],
  [`TS2345`], [`Argument of type 'number' is not assignable to parameter of type '{ length: number; }'.`], [Argumen tidak memenuhi constraint `extends`.],
  [`TS2558`], [`Expected 0 type arguments, but got 1.`], [Menulis `<T>` saat memakai fungsi atau class yang belum generik.],
  [`TS2353`], [`... and 'id' does not exist in type 'PasienBaru'.`], [Mengisi field yang sudah dibuang `Omit` atau tidak diambil `Pick`.],
  [`TS18048`], [`'draf.umur' is possibly 'undefined'.`], [Field dari `Partial` dipakai sebelum diperiksa.],
)

#dipakai[seluruh soal. Saat `tsc` menampilkan error, cari nomornya di tabel ini dan di HO sebelumnya.]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-ts4.ts` (sudah tersedia di starter).

  ```ts
  function bungkus<T>(x: T): T[] {
    return [x];
  }
  const a = bungkus(5);
  const b = bungkus("qris");
  const c = bungkus<number | string>(5);
  console.log(a, b, c);

  type PasienBaru = Omit<Pasien, "id">;
  const draf: Partial<Pasien> = { nama: "Ani" };
  console.log(draf.umur);

  // Bagian 2: buka satu baris, jalankan npx tsc --noEmit, lalu tutup lagi.
  // const d: number[] = bungkus("x");
  // const p: Pick<Pasien, "nama"> = { nama: "Ani", umur: 3 };
  // const q: PasienBaru = { id: "PS99", nama: "Ani", umur: 3, poli: "umum", telepon: "-" };
  // console.log(draf.umur + 1);
  ```

  1. Tulis tebakan tipe `a`, `b`, dan `c` di komentar ujung barisnya, lalu cek dengan mengarahkan kursor di VS Code. Tulis juga tebakan output kedua baris `console.log`, lalu jalankan `node Jawaban/soal-ts4.ts coba`. Tebakan mana yang salah?
  2. Bagian 2: untuk setiap baris, tulis nomor dan pesan error `tsc`-nya.
  3. `draf` hanya diisi `nama`, tetapi tetap diterima sebagai `Partial<Pasien>`. Apa tipe `draf.umur`, dan mengapa?
  4. `a` dan `c` sama-sama berisi `[5]`. Apa beda tipe keduanya, dan kapan menulis `<number | string>` secara tertulis berguna?

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
