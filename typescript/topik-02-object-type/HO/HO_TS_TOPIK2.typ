#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "TypeScript Modul 2", judul: "Object Type")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menulis bentuk object dengan `type` dan `interface`, lalu membaca error field yang hilang atau berlebih
- Menandai field yang boleh tidak ada (`?`) dan menanganinya sebelum dipakai
- Menandai field yang tidak boleh diubah (`readonly`) dan array yang hanya bisa dibaca
- Memakai tuple untuk pasangan nilai pendek
- Memakai `Record` untuk object yang key-nya tidak diketahui sebelumnya
- Memilih antara `type` dan `interface`, dan menjelaskan alasannya

= Dasar Teori

== Bentuk Object

*Untuk apa:* menulis field apa saja yang harus ada di sebuah object, beserta tipe setiap field. Di JavaScript, object boleh berisi apa saja. Salah ketik nama field tidak menghasilkan error, hanya `undefined` yang diam-diam terbawa sampai ke layar.

#listing("bug salah ketik field di JavaScript")[```js
const kaos = { id: "P01", nama: "Kaos Polos", hrga: 50000 };   // salah ketik: hrga
console.log(`Rp${kaos.harga * 2}`);                              // "RpNaN", tanpa error
```]

*Cara kerja:* tulis bentuknya sekali, beri nama, lalu pakai nama itu sebagai tipe. Ada dua cara menulisnya, `interface` dan `type`. Untuk object biasa, hasil keduanya sama.

#listing("dua cara menulis bentuk object")[```ts
interface Produk {
  id: string;
  nama: string;
  harga: number;
}

type ProdukB = {
  id: string;
  nama: string;
  harga: number;
};

const kaos: Produk = { id: "P01", nama: "Kaos Polos", harga: 50000 };
const daftar: Produk[] = [kaos, { id: "P05", nama: "Buku Tulis", harga: 8000 }];

function labelHarga(p: Produk): string {
  return `${p.nama}: ${p.harga}`;
}
```]

Perbedaan penulisan: `interface` tidak memakai tanda `=`, sedangkan `type` memakai `=` dan ditutup `;`. Pemisah antar-field boleh `;` atau `,`. Praktikum ini memakai `;`.

Analogi database: `interface Produk` seperti `CREATE TABLE produk (id VARCHAR, nama VARCHAR, harga INT)`. Setiap object yang bertipe `Produk` adalah satu baris yang harus mengikuti tabel itu. Bedanya, tipe hanya diperiksa oleh `tsc`. Saat program jalan, tidak ada yang memeriksa.

`tsc` memeriksa dua arah. Field yang *wajib* tapi tidak ditulis ditolak, dan field yang *tidak ada* di bentuknya juga ditolak. Pemeriksaan field berlebih ini hanya berlaku pada object yang ditulis langsung (object literal), karena di situlah salah ketik biasanya terjadi.

#listing("dua jenis kesalahan yang ditangkap")[```ts
const a: Produk = { id: "P06", nama: "Topi" };
// TS2741: Property 'harga' is missing in type '{ id: string; nama: string; }'
//         but required in type 'Produk'.

const b: Produk = { id: "P06", nama: "Topi", hrga: 35000 };
// TS2561: Object literal may only specify known properties,
//         but 'hrga' does not exist in type 'Produk'. Did you mean to write 'harga'?

const c: Produk = { id: "P06", nama: "Topi", harga: 35000, warna: "hitam" };
// TS2353: Object literal may only specify known properties,
//         and 'warna' does not exist in type 'Produk'.

console.log(kaos.harag);
// TS2551: Property 'harag' does not exist on type 'Produk'. Did you mean 'harga'?
```]

*Kesalahan umum:* menulis `interface Produk = { ... }` (dengan `=`). Tanda `=` hanya dipakai `type`.

#dipakai[
  - Beginner 1, untuk menulis `interface Produk`.
  - Beginner 3, untuk menjelaskan error `TS2353` saat staf menambah field `warna`.
  - Intermediate 2, untuk menulis `type Alamat` dan `interface Pembeli`.
]

== Field yang Boleh Tidak Ada

*Untuk apa:* sebagian data memang tidak selalu ada. Tidak semua produk sedang diskon, dan tidak semua pembeli sudah mengisi alamat. Field seperti ini ditandai `?`.

*Cara kerja:* `diskonPersen?: number` berarti field itu boleh tidak ditulis. Akibatnya, tipe `p.diskonPersen` menjadi `number | undefined`. Aturan dari TS-1 berlaku: nilai yang mungkin `undefined` harus ditangani sebelum dipakai sebagai `number`.

#listing("field opsional dan cara menanganinya")[```ts
interface Produk {
  id: string;
  harga: number;
  diskonPersen?: number;          // boleh tidak ada
}

const kaos: Produk = { id: "P01", harga: 50000 };                    // valid
const lampu: Produk = { id: "P04", harga: 120000, diskonPersen: 25 }; // valid

console.log(lampu.diskonPersen * 2);       // TS18048: 'lampu.diskonPersen' is possibly 'undefined'.
console.log((kaos.diskonPersen ?? 0) * 2); // 0   (?? dari JS-1: pakai 0 jika undefined)
```]

Untuk object di dalam object, pakai `?.` (_optional chaining_). `p.alamat?.kota` berarti "ambil `kota` jika `alamat` ada, selain itu hasilnya `undefined`". Tanpa `?.`, `p.alamat.kota` pada pembeli tanpa alamat melempar `TypeError: Cannot read properties of undefined (reading 'kota')`.

#listing("object bersarang yang opsional")[```ts
type Alamat = { kota: string; kodePos: string };
interface Pembeli {
  nama: string;
  alamat?: Alamat;
}

const joko: Pembeli = { nama: "Joko" };

console.log(joko.alamat.kota);             // TS18048: 'joko.alamat' is possibly 'undefined'.
console.log(joko.alamat?.kota);            // undefined
console.log(joko.alamat?.kota ?? "-");     // "-"

if (joko.alamat !== undefined) {
  console.log(joko.alamat.kota);           // di sini alamat pasti ada
}
```]

Analogi database: field `?` seperti kolom yang boleh `NULL`. `?? "-"` mirip `COALESCE(kota, '-')`.

#table(
  columns: (1fr, auto),
  inset: 6pt,
  [*Penulisan*], [*Tipe `p.diskonPersen`*],
  [`diskonPersen: number`], [`number`, wajib ditulis],
  [`diskonPersen?: number`], [`number | undefined`, boleh tidak ditulis],
)

#dipakai[
  - Beginner 1, untuk `diskonPersen` yang boleh tidak ada, lalu dianggap `0` di `hargaAkhir`.
  - Beginner 3, untuk field `warna` yang hanya dimiliki sebagian produk.
  - Intermediate 2, untuk `alamat` yang boleh tidak ada di `Pembeli`.
]

== Field yang Tidak Boleh Diubah

*Untuk apa:* sebagian field tidak boleh berubah setelah object dibuat, misalnya id produk yang sudah dipakai di laporan dan keranjang. `readonly` membuat `tsc` menolak setiap perubahan pada field itu.

#listing("readonly")[```ts
interface Produk {
  readonly id: string;
  nama: string;
}

const kaos: Produk = { id: "P01", nama: "Kaos Polos" };
kaos.nama = "Kaos Polos Putih";   // boleh
kaos.id = "P99";                  // TS2540: Cannot assign to 'id' because it is a read-only property.
```]

`readonly` hanya diperiksa `tsc`. Jika kode itu dijalankan dengan `node` tanpa `tsc`, `kaos.id` tetap berubah. Berbeda dengan field `#private` di JS-5 yang benar-benar terkunci saat program jalan, `readonly` adalah perjanjian yang dijaga pemeriksa tipe.

Analogi database: `readonly id` mirip primary key yang tidak boleh di-`UPDATE` karena dirujuk tabel lain.

*Kesalahan umum:* mengira `readonly` membuat isi di dalamnya ikut terkunci. `readonly alamat: Alamat` hanya mencegah `p.alamat = ...`. `p.alamat.kota = "Solo"` tetap boleh.

#dipakai[Beginner 1, untuk field `id` di `interface Produk`.]

== Array Object dan Array yang Hanya Bisa Dibaca

*Untuk apa:* hampir semua data toko berupa array object, misalnya daftar produk. Tipe array object ditulis `Produk[]`. Jika sebuah fungsi hanya perlu *membaca* array, tipe parameternya bisa ditulis `readonly Produk[]` supaya fungsi itu tidak bisa mengubah array milik pemanggil.

*Cara kerja:* `readonly Produk[]` menyembunyikan semua method yang mengubah array, yaitu `push`, `pop`, `splice`, `sort`, dan `reverse`. Method yang membuat array baru (`map`, `filter`, `find`, `reduce`, `slice`) tetap boleh.

#listing("sort mengubah array asli (ingat JS-3)")[```ts
function urutHarga(daftar: readonly Produk[]): Produk[] {
  return daftar.sort((a, b) => a.harga - b.harga);
  // TS2339: Property 'sort' does not exist on type 'readonly Produk[]'.
}

function urutHargaBenar(daftar: readonly Produk[]): Produk[] {
  return [...daftar].sort((a, b) => a.harga - b.harga);   // salin dulu, lalu urutkan salinannya
}
```]

Ingat bug JS-3: `sort` mengubah array aslinya, sehingga data di tempat lain ikut berubah tanpa disadari. Dengan `readonly`, kesalahan itu tertangkap `tsc` sebelum program jalan. Setelah `sort` ditolak, `tsc` biasanya juga menampilkan `TS7006` untuk parameter `a` dan `b`. Error itu ikut hilang setelah baris `sort`-nya diperbaiki.

#catatan[
  JavaScript terbaru punya `toSorted()`, yang mengurutkan tanpa mengubah array asli. Pengaturan `tsconfig` praktikum ini (`target: es2022`) belum mengenalnya: `TS2550: Property 'toSorted' does not exist on type 'number[]'. Do you need to change your target library?`. Pakai `[...daftar].sort(...)`.
]

Mencari satu object di array tetap memakai `find`, dan hasilnya tetap bisa `undefined` seperti di TS-1.

#listing("find pada array object")[```ts
const p = daftar.find((x) => x.id === "P99");   // Produk | undefined
console.log(p.nama);                            // TS18048: 'p' is possibly 'undefined'.
if (p !== undefined) console.log(p.nama);       // aman
```]

#dipakai[
  - Intermediate 1, untuk parameter `daftar` bertipe `readonly Produk[]`.
  - Intermediate 3, untuk memperbaiki `urutTermurah` yang mengubah `katalog`.
  - Advanced 1, untuk mencari produk dengan `find` dan menangani hasil `undefined`.
]

== Tuple

*Untuk apa:* menyimpan beberapa nilai pendek yang posisinya tetap, misalnya pasangan id produk dan jumlahnya. Tuple adalah array yang panjangnya tetap dan tipe setiap posisinya sudah ditentukan.

*Cara kerja:* `[string, number]` berarti tepat dua isi: posisi `0` string, posisi `1` number. Posisi bisa diberi label supaya mudah dibaca, misalnya `[id: string, qty: number]`. Label hanya untuk dibaca dan tidak mengubah cara pakai.

#listing("tuple dan destructuring")[```ts
type BarisKeranjang = [id: string, qty: number];

const baris: BarisKeranjang = ["P01", 2];
const keranjang: BarisKeranjang[] = [["P01", 2], ["P05", 3]];

const [id, qty] = baris;                         // destructuring array (JS-4)
for (const [kode, jumlah] of keranjang) {
  console.log(`${kode} x${jumlah}`);             // P01 x2, lalu P05 x3
}

// melewati posisi pertama dengan koma kosong
const totalQty = keranjang.reduce((n, [, q]) => n + q, 0);   // 5
```]

Jalannya `reduce` di atas:

#table(
  columns: (auto, auto, auto, auto),
  inset: 6pt,
  [*Putaran*], [*`n` sebelum*], [*Baris*], [*`n` sesudah*],
  [1], [`0`], [`["P01", 2]`], [`2`],
  [2], [`2`], [`["P05", 3]`], [`5`],
)

Kesalahan yang ditangkap `tsc`:

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Kode*], [*Pesan `tsc`*],
  [`const b: BarisKeranjang = ["P01", 2, 5];`], [`TS2322: Type '[string, number, number]' is not assignable to type 'BarisKeranjang'.` disertai `Source has 3 element(s) but target allows only 2.`],
  [`const b: BarisKeranjang = [2, "P01"];`], [`TS2322: Type 'number' is not assignable to type 'string'.` dan sebaliknya untuk posisi kedua],
)

Kapan tuple, kapan object? Tuple cocok untuk dua atau tiga nilai yang artinya sudah jelas dari konteks. Jika isinya lebih banyak, atau orang harus menebak arti posisi ke-3, pakai object dengan nama field.

#dipakai[
  - Beginner 2, untuk menulis `type BarisKeranjang` dan menjumlah qty dengan destructuring `[, qty]`.
  - Advanced 1, untuk membaca setiap baris keranjang dengan `for (const [id, qty] of keranjang)`.
]

== Record

*Untuk apa:* object yang dipakai seperti tabel pencarian, yang key-nya baru diketahui saat program jalan. Contohnya total stok per kategori, dengan kategori yang bisa bertambah kapan saja.

*Cara kerja:* `Record<string, number>` berarti object dengan key string apa saja dan value number. Pola GROUP BY dari JS-3 tetap sama, hanya tipenya yang ditulis.

#listing("GROUP BY dengan Record")[```ts
const daftar: { kategori: string; stok: number }[] = [
  { kategori: "pakaian", stok: 10 },
  { kategori: "pakaian", stok: 3 },
  { kategori: "rumah", stok: 0 },
];

const stok: Record<string, number> = {};
for (const p of daftar) {
  stok[p.kategori] = (stok[p.kategori] ?? 0) + p.stok;
}
console.log(stok);   // { pakaian: 13, rumah: 0 }
```]

#table(
  columns: (auto, auto, auto),
  inset: 6pt,
  [*Putaran*], [*`p.kategori`*], [*`stok` sesudah*],
  [1], [`"pakaian"`], [`{ pakaian: 10 }`],
  [2], [`"pakaian"`], [`{ pakaian: 13 }`],
  [3], [`"rumah"`], [`{ pakaian: 13, rumah: 0 }`],
)

Analogi SQL: `SELECT kategori, SUM(stok) FROM produk GROUP BY kategori`.

#perhatian[
  `stok["elektronik"]` bertipe `number` menurut `tsc`, padahal nilainya `undefined` karena key itu tidak ada. Dengan pengaturan praktikum ini, `tsc` tidak memeriksa apakah sebuah key benar-benar ada di `Record`. Karena itu tulis `?? 0` saat membaca key yang mungkin belum ada, seperti di listing di atas.
]

Jika key-nya sudah pasti dan sedikit, `Record` juga bisa memakai literal union dari TS-1: `Record<"tunai" | "qris", number>` mewajibkan tepat dua key itu.

#dipakai[Intermediate 1, untuk hasil `stokPerKategori` bertipe `Record<string, number>`.]

== type atau interface?

Untuk object biasa, keduanya bisa dipakai dan hasilnya sama. Perbedaannya ada di bentuk yang *bukan* object, dan di cara memperluasnya.

#table(
  columns: (1fr, auto, auto),
  inset: 6pt,
  [*Kebutuhan*], [*`interface`*], [*`type`*],
  [bentuk object], [bisa], [bisa],
  [union (`"tunai" | "qris"`)], [tidak bisa], [bisa],
  [tuple (`[string, number]`)], [tidak bisa], [bisa],
  [tipe fungsi (`(n: number) => number`)], [bisa, tapi jarang], [bisa],
  [memperluas bentuk lain], [`extends`], [`&` (intersection)],
  [ditulis dua kali dengan nama sama], [digabung otomatis], [error `TS2300: Duplicate identifier`],
)

#listing("memperluas bentuk")[```ts
interface ProdukDigital extends Produk {
  linkUnduh: string;
}

type ProdukDigitalB = Produk & { linkUnduh: string };

const ebook: ProdukDigital = { id: "D01", nama: "E-book TS", harga: 30000, linkUnduh: "..." };
```]

Aturan praktis yang dipakai di praktikum ini:
- Bentuk object yang mewakili "benda" di aplikasi (produk, pembeli, rekening): `interface`.
- Union, tuple, tipe fungsi, dan bentuk kecil pendukung: `type`.

#catatan[
  Saat live coding, interviewer bisa bertanya "kenapa pakai interface, bukan type?". Jawaban yang baik: untuk object keduanya setara. `interface` dipilih untuk bentuk object karena bisa di-`extends` dan pesan error-nya menyebut nama interface-nya. `type` wajib untuk union dan tuple. Yang penting konsisten dalam satu proyek. Perbandingan dengan `class` dibahas di TS-3.
]

#dipakai[
  - Beginner 1 dan Intermediate 2, untuk memilih `interface` pada `Produk` dan `Pembeli`.
  - Beginner 2, karena `BarisKeranjang` adalah tuple sehingga harus ditulis dengan `type`.
  - Intermediate 2, untuk `type Alamat` sebagai bentuk kecil pendukung.
]

== Membaca Pesan Error tsc (tambahan TS-2)

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Nomor*], [*Pesan*], [*Penyebab umum*],
  [`TS2741`], [`Property 'x' is missing in type '...' but required in type 'Y'.`], [Field wajib tidak ditulis.],
  [`TS2353`], [`Object literal may only specify known properties, and 'x' does not exist in type 'Y'.`], [Field berlebih yang tidak ada di bentuknya.],
  [`TS2561`], [`Object literal may only specify known properties, but 'x' does not exist in type 'Y'. Did you mean to write 'z'?`], [Salah ketik nama field saat menulis object. `tsc` menyarankan nama yang mirip.],
  [`TS2551`], [`Property 'x' does not exist on type 'Y'. Did you mean 'z'?`], [Salah ketik saat membaca field.],
  [`TS2339`], [`Property 'x' does not exist on type 'Y'.`], [Field atau method tidak ada, termasuk `sort` pada array `readonly`.],
  [`TS2540`], [`Cannot assign to 'x' because it is a read-only property.`], [Mengubah field `readonly`.],
  [`TS18048`], [`'x' is possibly 'undefined'.`], [Field `?` dipakai sebelum diperiksa.],
)

#dipakai[seluruh soal. Saat `tsc` menampilkan error, cari nomornya di tabel ini dan di tabel TS-1.]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-ts2.ts` (sudah tersedia di starter).

  ```ts
  type Titik = [number, number];
  const t: Titik = [3, 4];

  interface Kota {
    readonly nama: string;
    penduduk?: number;
  }
  const solo: Kota = { nama: "Solo" };

  const nilai: Record<string, number> = { a: 1 };
  console.log(t[0] + t[1], solo.penduduk, nilai["b"]);

  // Bagian 2: buka satu baris, jalankan npx tsc --noEmit, lalu tutup lagi.
  // solo.nama = "Surakarta";
  // const t2: Titik = [3, 4, 5];
  // const solo2: Kota = { nama: "Solo", provinsi: "Jawa Tengah" };
  // console.log(solo.penduduk + 1);
  ```

  1. Tulis tebakan output baris `console.log` sebelum menjalankan `node Jawaban/soal-ts2.ts coba`. Tebakan mana yang salah, dan mengapa?
  2. Bagian 2: untuk setiap baris, tulis nomor dan pesan error `tsc`-nya.
  3. `nilai["b"]` bertipe `number` menurut `tsc`, tetapi isinya `undefined`. Mengapa `tsc` tidak memperingatkan, dan bagaimana kamu menjaga diri dari kasus ini?
  4. `Titik` ditulis dengan `type`, `Kota` dengan `interface`. Bisakah keduanya ditukar? Jelaskan untuk masing-masing.

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
