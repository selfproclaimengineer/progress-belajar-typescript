#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "TypeScript Modul 1", judul: "Dasar TypeScript")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menjelaskan beda TypeScript dan JavaScript, dan seberapa banyak materi JavaScript yang tetap dipakai
- Memeriksa tipe dengan `tsc` dan menjalankan file `.ts` dengan `node`, serta menjelaskan beda keduanya
- Menulis anotasi tipe pada variabel, parameter, dan nilai kembalian fungsi
- Membiarkan TypeScript menebak tipe (_inference_) dan tahu kapan anotasi tetap perlu
- Membatasi nilai dengan union type dan literal type
- Menulis tipe fungsi untuk callback
- Memilih `unknown` daripada `any` untuk data yang belum jelas tipenya
- Menangani nilai yang mungkin `undefined` sebelum dipakai

= Dasar Teori

== Seberapa Jauh Lompatan dari JavaScript

*Untuk apa:* menangkap kesalahan tipe *sebelum* program dijalankan. Di JavaScript, kesalahan tipe sering tidak menghasilkan error. Program tetap jalan dan diam-diam menghasilkan nilai yang salah.

#listing("bug yang lolos di JavaScript")[```js
function subtotal(harga, qty) {
  return harga * qty;
}
const hargaDariForm = "15000";            // isian form selalu teks
console.log(subtotal(hargaDariForm, 2));  // 30000  (kebetulan benar: * mengubah teks jadi angka)
console.log(hargaDariForm + 1000);        // "150001000"  (salah: + menyambung teks)
```]

Di JavaScript, kedua baris di atas jalan tanpa error. Bug baru ketahuan saat pembeli melihat tagihannya. TypeScript menolak kode yang sama saat diperiksa, sebelum ada pembeli yang dilayani.

*Cara kerja:* TypeScript adalah JavaScript *ditambah* keterangan tipe. Semua yang kamu pelajari di JS-1 sampai JS-6 tetap berlaku dan ditulis dengan cara yang sama. Yang baru hanya keterangan tipe dan satu alat pemeriksa.

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Tetap sama seperti JavaScript*], [*Baru di TypeScript*],
  [`const`, `let`, `if`, `for`, fungsi, arrow function], [anotasi tipe: `let harga: number`],
  [method array (`map`, `filter`, `reduce`, `find`)], [union dan literal type: `"tunai" | "qris"`],
  [method string, object, destructuring, spread], [tipe fungsi: `(total: number) => number`],
  [`class`, `Map`, `Set`, `Date`, `throw`, `try...catch`], [`unknown`, pengecekan `undefined` yang wajib],
  [cara menjalankan program dengan `node`], [pemeriksa tipe `tsc`],
)

Analogi database: JavaScript seperti tabel yang semua kolomnya bertipe "apa saja". `INSERT` teks ke kolom harga tetap diterima, dan kesalahannya baru terlihat saat laporan dihitung. TypeScript seperti `CREATE TABLE` dengan kolom `harga INT`. `INSERT 'abc'` langsung ditolak.

#perhatian[
  Tipe hanya ada saat *diperiksa*. Saat program dijalankan, semua keterangan tipe dibuang, dan yang tersisa adalah JavaScript biasa. Karena itu `typeof` tetap menghasilkan tipe JavaScript (`"number"`, `"string"`, `"object"`), dan data dari luar (form, JSON, API) tidak otomatis diperiksa tipenya.
]

#dipakai[seluruh soal. Cerita soal berawal dari bug `"15000" + 1000` di atas, dan Beginner 3 memintamu membuktikannya sendiri.]

== Memeriksa dan Menjalankan

Ada dua perintah, dan keduanya punya tugas berbeda.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Perintah*], [*Yang dikerjakan*], [*Yang tidak dikerjakan*],
  [`npx tsc --noEmit`], [Memeriksa tipe semua file di `Jawaban/` topik ini, lalu mencetak daftar error. `--noEmit` berarti tidak membuat file baru.], [Tidak menjalankan program.],
  [`node Jawaban/soal-ts1.ts`], [Membuang keterangan tipe, lalu menjalankan sisanya seperti file `.js`.], [Tidak memeriksa tipe sama sekali. Kode yang salah tipe tetap dijalankan.],
)

Alur kerjanya: jalankan `tsc` dulu sampai tidak ada error, baru jalankan `node`. Aturan pemeriksaan ditulis di `tsconfig.json` di root repo, dengan mode `strict` menyala. Setiap folder topik punya `tsconfig.json` kecil yang memakai aturan itu dan hanya memeriksa `Jawaban/` topik tersebut, jadi error dari topik lain tidak ikut tampil.

#listing("satu file, dua perintah")[```ts
// coba.ts
const harga: number = "15000";
console.log(harga + 1000);
```]

```text
> node coba.ts
150001000

> npx tsc --noEmit
coba.ts:2:7 - error TS2322: Type 'string' is not assignable to type 'number'.
```

Cara membaca pesan `tsc`: `coba.ts:2:7` berarti file `coba.ts`, baris 2, kolom 7. `TS2322` adalah nomor error, yang bisa dicari di internet. Kalimat sesudahnya menjelaskan masalahnya. Di terminal, `tsc` juga menampilkan potongan baris itu dengan tanda `~~~` di bawah bagian yang salah.

*Kesalahan umum:* hanya menjalankan `node`, melihat outputnya keluar, lalu menganggap kodenya benar. `node` tidak pernah memeriksa tipe.

#dipakai[seluruh soal, sebagai alur kerja: `tsc` dulu, lalu `node`. Beginner 3 membandingkan hasil kedua perintah itu pada kode yang sama.]

== Anotasi Tipe

*Untuk apa:* menyatakan tipe yang diharapkan, supaya `tsc` menolak nilai bertipe lain.

*Cara kerja:* tulis `: tipe` setelah nama variabel atau parameter. Untuk nilai kembalian fungsi, tulis `: tipe` setelah kurung tutup parameter.

#listing("anotasi variabel dan fungsi")[```ts
let nama: string = "Paracetamol";
let stok: number = 40;
let tersedia: boolean = true;
let daftarHarga: number[] = [12000, 35000];   // array berisi number
let daftarNama: string[] = [];                // array kosong: anotasi wajib

function hargaSetelahPajak(harga: number, persenPajak: number): number {
  return harga + Math.round((harga * persenPajak) / 100);
}
```]

Padanan dengan JavaScript: buang semua bagian `: tipe`, dan hasilnya adalah kode JavaScript yang sama persis. Itulah yang dikerjakan `node` saat menjalankan file `.ts`.

Tipe dasar yang paling sering dipakai:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Tipe*], [*Isi*], [*Padanan SQL*],
  [`number`], [semua angka, bulat maupun desimal], [`INT`, `DECIMAL`],
  [`string`], [teks], [`VARCHAR`],
  [`boolean`], [`true` atau `false`], [`BOOLEAN`],
  [`number[]`], [array yang semua isinya number], [kolom yang diulang],
  [`void`], [fungsi yang tidak mengembalikan apa pun], [procedure tanpa hasil],
)

*Kesalahan umum* dan pesannya:

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Kode*], [*Pesan `tsc`*],
  [`let stok: number = "40";`], [`TS2322: Type 'string' is not assignable to type 'number'.`],
  [`hargaSetelahPajak("12000", 11)`], [`TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.`],
  [`hargaSetelahPajak(12000)`], [`TS2554: Expected 2 arguments, but got 1.`],
  [`function f(harga) { ... }` (parameter tanpa tipe)], [`TS7006: Parameter 'harga' implicitly has an 'any' type.`],
  [`daftarHarga.push("8500")`], [`TS2345: Argument of type 'string' is not assignable to parameter of type 'number'.`],
)

`TS7006` muncul karena mode `strict` tidak mengizinkan parameter tanpa tipe. Tanpa tipe, parameter dianggap `any` (bisa apa saja), dan pemeriksaan untuk parameter itu mati.

#dipakai[
  - Beginner 1, untuk memberi tipe `subtotal` dan `formatRupiah`. Sepuluh error `TS7006` di starter hilang satu per satu dengan cara ini.
  - Beginner 2, Intermediate 1 sampai 3, dan Advanced 1, untuk menulis tipe parameter dan nilai kembalian setiap fungsi baru.
]

== Inference: TypeScript Menebak Tipe

*Untuk apa:* tidak semua hal perlu ditulis tipenya. Jika nilai awalnya jelas, TypeScript menebak tipenya sendiri. Ini disebut _inference_.

#listing("tipe hasil tebakan")[```ts
let stok = 40;                    // number
let nama = "Paracetamol";         // string
const metode = "qris";            // "qris"  (bukan string, lihat di bawah)
let harga = [12000, 35000];       // number[]
const ketemu = harga.find((h) => h > 20000);   // number | undefined
const kali = harga.map((h) => h * 2);           // number[]  (h ditebak number)
stok = "banyak";                  // TS2322: Type 'string' is not assignable to type 'number'.
```]

Di VS Code, arahkan kursor ke nama variabel untuk melihat tipe hasil tebakan.

`const` dan `let` ditebak berbeda. `let metode = "qris"` ditebak `string`, karena isinya boleh diganti teks lain. `const metode = "qris"` ditebak tepat `"qris"`, karena isinya tidak pernah berubah. Ini menjawab lagi pertanyaan JS-1 tentang `const` dan `let`: `const` memberi TypeScript informasi yang lebih tepat.

Kapan anotasi tetap ditulis:
- *Parameter fungsi:* selalu, karena TypeScript tidak bisa menebak isi argumen yang akan diberikan (`TS7006`).
- *Nilai kembalian fungsi:* dianjurkan, supaya kesalahan di dalam fungsi ketahuan di fungsi itu sendiri.
- *Array kosong:* `let daftar: string[] = []`, karena array kosong tidak memberi petunjuk isinya.
- *Callback array:* tidak perlu. Pada `harga.map((h) => h * 2)`, `h` sudah ditebak `number` dari isi `harga`.

#dipakai[
  - Coba Sendiri Bagian 1, untuk menebak tipe `a`, `b`, `c`, dan `d`.
  - Intermediate 2, karena `(total) => ...` yang disimpan di variabel bertipe `AturanDiskon` tidak perlu menulis tipe `total` lagi.
  - Advanced 1, untuk tipe `daftarHarga` yang ditebak `Map<string, number>` dari isinya.
]

== Union dan Literal Type

*Untuk apa:* membatasi nilai ke beberapa tipe atau beberapa pilihan tertentu saja. Contohnya metode bayar yang hanya boleh `"tunai"`, `"debit"`, atau `"qris"`.

*Cara kerja:* tanda `|` dibaca "atau". _Literal type_ adalah satu nilai persis yang dipakai sebagai tipe, misalnya `"tunai"`. Gabungan beberapa literal dengan `|` menjadi daftar pilihan. Beri nama dengan `type`, supaya bisa dipakai di banyak tempat.

#listing("union dan literal type")[```ts
type StatusResep = "baru" | "diproses" | "selesai";   // hanya tiga pilihan
type KodeAtauNomor = string | number;                 // teks atau angka

function labelStatus(status: StatusResep): string {
  if (status === "baru") return "Menunggu apoteker";
  if (status === "diproses") return "Sedang disiapkan";
  return "Siap diambil";        // sisa pilihan pasti "selesai"
}

labelStatus("selesai");         // boleh
labelStatus("selsai");          // TS2345: Argument of type '"selsai"' is not assignable to parameter of type 'StatusResep'.
let s: StatusResep = "selsai";  // TS2820: Type '"selsai"' is not assignable to type 'StatusResep'. Did you mean '"selesai"'?
```]

Padanan SQL: `ENUM('baru', 'diproses', 'selesai')` atau constraint `CHECK (status IN (...))`. Bedanya, SQL menolak saat `INSERT`, sedangkan TypeScript menolak saat kode diperiksa.

*Kesalahan umum:* menyimpan teks di `let` lalu memberikannya ke parameter literal type.

#listing("let menjadi string")[```ts
let pilihan = "selesai";        // ditebak string, bukan "selesai"
labelStatus(pilihan);           // TS2345: Argument of type 'string' is not assignable to parameter of type 'StatusResep'.
const pilihanTetap = "selesai"; // ditebak "selesai"
labelStatus(pilihanTetap);      // boleh
```]

Di dalam `if (status === "baru")`, TypeScript tahu `status` pasti `"baru"`. Setelah semua `if` lewat, TypeScript tahu sisa pilihannya. Kemampuan ini disebut _narrowing_ dan dibahas lengkap di TS-5.

#dipakai[Beginner 2, untuk mengganti `type MetodeBayar = string` dengan tiga pilihan metode bayar, lalu memilih biaya admin dengan `if` atau `switch` seperti `labelStatus` di atas.]

== Tipe Fungsi

*Untuk apa:* menggambarkan *bentuk* sebuah fungsi: parameternya apa dan nilai kembaliannya apa. Ini dibutuhkan saat fungsi disimpan di variabel, dimasukkan ke array, atau diberikan sebagai callback.

*Cara kerja:* tulis `(parameter: tipe) => tipeKembalian`. Bentuknya mirip arrow function, tetapi isinya tipe, bukan kode.

#listing("tipe fungsi untuk aturan harga")[```ts
type AturanHarga = (harga: number) => number;

const naikkanPajak: AturanHarga = (harga) => harga + Math.round(harga * 0.11);   // harga ditebak number
const potongPelajar: AturanHarga = (harga) => harga - 2000;

const semuaAturan: AturanHarga[] = [naikkanPajak, potongPelajar];   // array berisi fungsi
let hasil = 10000;
for (const aturan of semuaAturan) {
  hasil = aturan(hasil);       // hasil satu aturan menjadi input aturan berikutnya
}
console.log(hasil);            // 9100

const salah: AturanHarga = (harga) => `${harga}`;   // mengembalikan string, bukan number
// TS2322: Type 'string' is not assignable to type 'number'.
```]

Jalannya perulangan di atas:

#table(
  columns: (auto, auto, auto, auto),
  inset: 6pt,
  [*Putaran*], [*`aturan`*], [*`hasil` sebelum*], [*`hasil` sesudah*],
  [1], [`naikkanPajak`], [`10000`], [`11100`],
  [2], [`potongPelajar`], [`11100`], [`9100`],
)

Perulangan yang sama bisa ditulis dengan `reduce` dari JS-3: `semuaAturan.reduce((h, aturan) => aturan(h), 10000)`. Nilai awal `10000` menjadi `h` di putaran pertama.

Parameter juga bisa dibuat tidak wajib dengan `?`, atau diberi nilai default seperti di JS-2:

#listing("parameter opsional dan default")[```ts
function labelHarga(harga: number, mataUang?: string): string {   // mataUang: string | undefined
  return `${mataUang ?? "Rp"}${harga}`;
}
function cetak(pesan: string, ulang: number = 1): void {           // void: tidak mengembalikan apa pun
  console.log(pesan.repeat(ulang));
}
```]

#dipakai[Intermediate 2, untuk menulis `type AturanDiskon`, memberi tipe `diskonMember` dan `voucher10rb`, lalu menerapkan array aturan berurutan di `terapkanDiskon`. Polanya sama dengan `semuaAturan` di atas.]

== any dan unknown

*Untuk apa:* keduanya dipakai untuk nilai yang tipenya belum diketahui, misalnya hasil `JSON.parse` atau data dari API. Keduanya sangat berbeda dalam hal keamanan.

*Cara kerja:*
- `any` *mematikan* pemeriksaan. Nilai `any` boleh dipakai sebagai apa saja, dan `tsc` tidak pernah protes. Kesalahannya baru terlihat saat program dijalankan.
- `unknown` berarti "belum tahu". Nilai `unknown` *tidak boleh* dipakai sebelum diperiksa tipenya, misalnya dengan `typeof`. Setelah diperiksa, TypeScript mengizinkannya.

#listing("any membocorkan tipe salah")[```ts
function bacaJumlah(teks: string): number {
  const data = JSON.parse(teks);     // JSON.parse mengembalikan any
  return data * 2;                   // tsc diam: any boleh dipakai sebagai apa saja
}
const harga: any = "12000";
harga.toFixed(2);                    // tsc diam, tetapi saat dijalankan:
// TypeError: harga.toFixed is not a function
```]

#listing("unknown memaksa pemeriksaan")[```ts
function bacaJumlahAman(teks: string): number {
  const data: unknown = JSON.parse(teks);
  // return data * 2;               // TS18046: 'data' is of type 'unknown'.
  if (typeof data !== "number") {
    throw new Error("jumlah harus angka");
  }
  return data * 2;                  // di sini TypeScript tahu data pasti number
}
console.log(bacaJumlahAman("4"));   // 8
bacaJumlahAman('"4"');              // melempar Error: jumlah harus angka
```]

Analogi: `any` seperti kolom database tanpa tipe dan tanpa validasi. `unknown` seperti data dari form yang wajib divalidasi dulu sebelum di-`INSERT`.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Hal*], [*`any`*], [*`unknown`*],
  [Boleh langsung dipakai?], [boleh, tanpa pemeriksaan], [tidak, `TS18046`],
  [Kesalahan ketahuan], [saat program jalan (atau tidak sama sekali)], [saat `tsc`],
  [Kapan dipakai], [hampir tidak pernah; jalan pintas saat memindahkan kode lama], [data dari luar: JSON, input pengguna, API],
)

#dipakai[Intermediate 3, untuk menjelaskan mengapa `tsc` diam pada `tambahStok` milik temanmu, lalu memperbaikinya dengan `unknown` dan `typeof`, seperti `bacaJumlahAman` di atas. Tipe `e` di dalam `catch` pada `cobaStok` juga `unknown`, karena apa pun bisa dilempar.]

== null, undefined, dan strictNullChecks

*Untuk apa:* mencegah error `Cannot read properties of undefined` dan hasil `NaN` yang muncul karena nilai kosong dipakai seolah-olah ada isinya.

*Cara kerja:* dengan `strict` menyala, `undefined` dan `null` adalah tipe tersendiri. Fungsi yang *mungkin* tidak menemukan hasil mengembalikan tipe gabungan, misalnya `number | undefined`. TypeScript tidak mengizinkan nilai itu dipakai sebagai `number` sebelum kemungkinan `undefined` ditangani.

#listing("hasil pencarian bisa kosong")[```ts
const stokObat = new Map([["OB01", 40], ["OB02", 0]]);   // Map<string, number>
const stok = stokObat.get("OB09");                       // number | undefined

console.log(stok + 5);                 // TS18048: 'stok' is possibly 'undefined'.
console.log(stokObat.get("OB01") * 2); // TS2532: Object is possibly 'undefined'.

// Cara 1: periksa dulu
if (stok === undefined) {
  console.log("obat tidak terdaftar");
} else {
  console.log(stok + 5);              // di sini stok pasti number
}

// Cara 2: nilai pengganti dengan ?? (JS-1)
console.log((stok ?? 0) + 5);         // 5
```]

`Map<string, number>` dibaca "Map dengan key string dan value number". Tanda `< >` adalah _generic_, yang dibahas di TS-4. Untuk sekarang, cukup bisa membacanya. Method lain yang juga bisa mengembalikan `undefined` adalah `find` pada array (`number | undefined`) dan akses index array.

Bandingkan dengan JavaScript biasa: `undefined + 5` menghasilkan `NaN` tanpa error, dan `NaN` itu bisa terbawa sampai ke struk sebagai `RpNaN`.

#catatan[
  Ada juga tanda `!` setelah nilai (`stokObat.get("OB01")!`) yang berarti "percayalah, ini pasti ada". Tanda ini mematikan pemeriksaan seperti `any`, jadi jangan dipakai di praktikum ini.
]

#dipakai[
  - Intermediate 1, untuk `hargaObat`. `daftarHarga.get(kode)` bertipe `number | undefined`, jadi periksa `undefined` dulu seperti Cara 1 di atas.
  - Advanced 1, untuk melempar error saat obat di keranjang tidak terdaftar. Pertanyaan *(jelaskan)* bagian (a) tentang langkah yang dipaksa `tsc` berkaitan dengan bagian ini.
  - Coba Sendiri Bagian 2, baris `console.log(d + 1)`.
]

== Membaca Pesan Error tsc

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Nomor*], [*Pesan*], [*Penyebab umum*],
  [`TS2322`], [`Type 'X' is not assignable to type 'Y'.`], [Nilai yang disimpan atau di-`return` bertipe lain dari anotasinya.],
  [`TS2345`], [`Argument of type 'X' is not assignable to parameter of type 'Y'.`], [Argumen fungsi bertipe salah, termasuk salah ketik pilihan literal.],
  [`TS2554`], [`Expected 2 arguments, but got 1.`], [Jumlah argumen kurang atau lebih.],
  [`TS2820`], [`Type '"X"' is not assignable to type 'Y'. Did you mean '"Z"'?`], [Salah ketik pilihan literal type. `tsc` menyarankan yang benar.],
  [`TS7006`], [`Parameter 'x' implicitly has an 'any' type.`], [Parameter fungsi belum diberi tipe.],
  [`TS18046`], [`'x' is of type 'unknown'.`], [Nilai `unknown` dipakai sebelum diperiksa.],
  [`TS18048`], [`'x' is possibly 'undefined'.`], [Variabel yang mungkin `undefined` dipakai sebelum diperiksa.],
  [`TS2532`], [`Object is possibly 'undefined'.`], [Sama dengan `TS18048`, untuk ekspresi seperti `map.get(...)`.],
)

#dipakai[seluruh soal. Saat `tsc` menampilkan error, cari nomornya di tabel ini dulu.]

#catatan[
  Saat live coding, pertanyaan yang sering muncul adalah "apa untungnya TypeScript?". Jawaban yang baik menyebut tiga hal. Pertama, kesalahan tipe ketahuan sebelum program dijalankan, bukan setelah pengguna melihat hasil yang salah. Kedua, tipe menjadi dokumentasi: dari `biayaAdmin(metode: MetodeBayar, total: number): number`, orang lain tahu cara memakainya tanpa membaca isinya. Ketiga, editor bisa memberi saran dan menandai kesalahan saat kode diketik.
]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-ts1.ts` (sudah tersedia di starter).

  ```ts
  let a = 10;
  const b = "qris";
  let c = [1, 2, 3];
  const d = c.find((x) => x > 5);
  let e: any = "x";
  console.log(a, b, c, d, e);

  // Bagian 2: buka satu baris, jalankan npx tsc --noEmit, lalu tutup lagi.
  // a = "sepuluh";
  // c.push("4");
  // console.log(d + 1);
  // console.log(e.toFixed(2));
  ```

  1. Bagian 1: tulis tebakan tipe `a`, `b`, `c`, `d`, dan `e` di komentar ujung barisnya, lalu cek dengan mengarahkan kursor di VS Code. Tebakan mana yang salah, dan mengapa?
  2. Bagian 2: untuk tiga baris pertama, tulis nomor dan pesan error `tsc`-nya.
  3. Baris keempat (`e.toFixed`) lolos `tsc`. Buka baris itu, lalu jalankan `node Jawaban/soal-ts1.ts coba`. Apa yang terjadi, dan mengapa `tsc` tidak memperingatkan?
  4. Ubah baris `console.log(d + 1)` supaya lolos `tsc` dan mencetak `1` saat `d` bernilai `undefined`.

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
