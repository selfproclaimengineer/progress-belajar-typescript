#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "TypeScript Modul 6", judul: "Validasi Data dari Luar")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menjelaskan mengapa tipe TypeScript tidak melindungi data yang datang saat program jalan
- Membedakan `any` dan `unknown`, dan memilih `unknown` untuk data dari luar
- Menulis type guard dengan `x is T` dan menjelaskan risikonya jika guard itu salah
- Memvalidasi data bertahap secara manual dan mengembalikan `Hasil<T>`
- Memakai library `zod`: skema, `safeParse`, pesan error, dan `z.infer`
- Menangani teks JSON yang rusak dengan `try...catch`

= Dasar Teori

== Tipe Hanya Ada Saat Compile

*Untuk apa:* memahami batas `tsc`. Sampai TS-5, semua data ditulis sendiri di dalam kode, jadi `tsc` bisa memeriksa bentuknya. Data dari luar program (teks JSON dari aplikasi lain, isi file, input form) baru ada saat program *jalan*. Saat itu `tsc` sudah selesai bekerja.

#listing("tsc percaya pada tipe yang kamu tulis")[```ts
interface Siswa {
  nama: string;
  nilai: number;
}

const s: Siswa = JSON.parse('{"nama":"Rina","nilai":"90"}');  // tsc diam
console.log(s.nilai + 5, typeof s.nilai);                      // 905 string
```]

*Cara kerja:* `JSON.parse` bertipe kembalian `any`. Nilai `any` boleh dimasukkan ke variabel bertipe apa saja, jadi `tsc` menerima `s: Siswa` tanpa memeriksa isinya. Saat program jalan, tipe TypeScript sudah dihapus (TS-1: `node` membuang semua tipe sebelum menjalankan). Yang tersisa hanya JavaScript, dan `"90" + 5` adalah penggabungan teks.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Tahap*], [*Yang diketahui tentang `s.nilai`*], [*Kenyataannya*],
  [`tsc --noEmit`], [`number`, karena kamu menulis `s: Siswa`], [belum ada data],
  [`node`], [tipe sudah dihapus], [`"90"` (string)],
  [`s.nilai + 5`], [`tsc` mengira penjumlahan], [penggabungan teks: `"905"`],
)

Artinya, tipe di kode hanyalah *janji* tentang bentuk data. Untuk data dari luar, janji itu harus dibuktikan dengan pemeriksaan yang ikut berjalan saat program jalan. Pemeriksaan ini disebut _validasi_. Tempat data masuk ke program disebut _batas_ (boundary), dan di sanalah validasi ditulis.

Analogi SQL: kolom bertipe `INT` dengan `CHECK (nilai BETWEEN 0 AND 100)` menolak baris yang salah saat `INSERT`. File CSV yang dibaca langsung oleh aplikasi tidak punya pemeriksaan itu, jadi aplikasi sendiri yang harus memeriksanya.

#dipakai[Beginner 3, dan seluruh soal. Setiap data di soal masuk sebagai teks JSON.]

== any dan unknown

*Untuk apa:* memberi tipe yang jujur pada data yang bentuknya belum diketahui.

#listing("any mematikan pemeriksaan, unknown memaksa memeriksa")[```ts
const bebas = JSON.parse('{"nama":"Rina"}');           // bebas: any
console.log(bebas.alamat.kota);                         // tsc diam, node: TypeError

const data: unknown = JSON.parse('{"nama":"Rina"}');
console.log(data.nama);
// TS18046: 'data' is of type 'unknown'.

const s: Siswa = data;
// TS2322: Type 'unknown' is not assignable to type 'Siswa'.
```]

*Cara kerja:* keduanya bisa menampung nilai apa pun. Bedanya ada pada apa yang boleh dilakukan setelahnya.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [], [*`any`*], [*`unknown`*],
  [Boleh diisi apa saja], [ya], [ya],
  [Boleh dibaca field-nya], [ya, tanpa pemeriksaan], [tidak, sebelum dipersempit],
  [Boleh dimasukkan ke variabel bertipe lain], [ya, ke tipe apa saja], [tidak, sebelum dipersempit],
  [Akibat salah bentuk], [ketahuan saat program jalan, atau tidak ketahuan sama sekali], [`tsc` memaksa kamu memeriksa dulu],
)

`any` menular: field dari `any` juga `any`, hasil method-nya juga `any`. Satu `JSON.parse` tanpa tipe bisa membuat satu fungsi penuh tidak diperiksa. Karena itu, simpan hasil `JSON.parse` sebagai `unknown`, lalu persempit dengan cara yang sudah kamu kenal dari TS-5 (`typeof`, `in`, `Array.isArray`), atau dengan type guard di bagian berikut.

*Kesalahan umum:* menulis `JSON.parse(teks) as Siswa`. Seperti di TS-5, `as` tidak memeriksa apa pun. Masalahnya sama dengan `const s: Siswa = JSON.parse(...)`.

#dipakai[Beginner 3 (mengganti tipe menjadi `unknown`), Intermediate 1, dan Intermediate 3 (hasil `JSON.parse` temanmu bertipe `any`).]

== Type Guard

*Untuk apa:* membungkus pemeriksaan yang panjang menjadi satu fungsi, lalu memakainya di `if` atau `filter` seperti `typeof`.

*Cara kerja:* tipe kembalian `x is T` (disebut _type predicate_) memberi tahu TypeScript: jika fungsi ini mengembalikan `true`, perlakukan `x` sebagai `T`.

#listing("dua type guard")[```ts
function apakahObject(x: unknown): x is Record<string, unknown> {
  return typeof x === "object" && x !== null && !Array.isArray(x);
}

function apakahSiswa(x: unknown): x is Siswa {
  return apakahObject(x) && typeof x.nama === "string" && typeof x.nilai === "number";
}

const data: unknown = JSON.parse('{"nama":"Rina","nilai":"90"}');
console.log(apakahSiswa(data), apakahSiswa({ nama: "Rina", nilai: 90 }));  // false true

if (apakahSiswa(data)) {
  console.log(data.nilai + 5);   // di sini data: Siswa
}
```]

Jalannya tipe di dalam `apakahSiswa`:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Posisi*], [*Alasan*], [*Tipe*],
  [awal fungsi], [dari parameter], [`x: unknown`],
  [setelah `apakahObject(x) &&`], [guard bernilai `true`], [`x: Record<string, unknown>`],
  [`x.nama`], [field dari `Record<string, unknown>`], [`unknown`],
  [setelah `typeof x.nama === "string" &&`], [`typeof` mempersempit], [`x.nama: string`],
)

`Record<string, unknown>` artinya object dengan key string apa saja dan value yang belum diketahui. Field-nya boleh dibaca, tetapi setiap field masih `unknown` dan harus diperiksa sendiri.

Mengapa `apakahObject` perlu tiga pemeriksaan:

#table(
  columns: (auto, auto, auto, auto),
  inset: 6pt,
  [*Nilai*], [*`typeof x === "object"`*], [*`x !== null`*], [*`!Array.isArray(x)`*],
  [`{ a: 1 }`], [`true`], [`true`], [`true`],
  [`null`], [`true` (jebakan dari TS-5)], [`false`], [],
  [`[1]`], [`true`], [`true`], [`false`],
  [`"x"`], [`false`], [], [],
)

Untuk memeriksa bilangan bulat, pakai `Number.isInteger`:

```ts
console.log(Number.isInteger(3), Number.isInteger(3.5), Number.isInteger("3"));  // true false false
```

=== Guard yang salah tidak ditolak

`tsc` *tidak* memeriksa apakah isi guard sesuai dengan `x is T`. Isi guard dipercaya begitu saja, sama seperti `as`.

#listing("guard yang berbohong")[```ts
function apakahAngka(x: unknown): x is number {
  return typeof x === "string";   // salah, tetapi tsc diam
}

// guard yang terlalu longgar: hanya memeriksa field ADA, bukan tipenya
const lemah = (x: unknown) => typeof x === "object" && x !== null && "nilai" in x;
console.log(lemah({ nilai: "sembilan puluh" }));   // true
```]

Operator `in` (TS-5) hanya menjawab "apakah field ini ada". Nilai field itu tetap bisa bertipe apa saja, termasuk `undefined` atau string. Jika guard memeriksa terlalu sedikit, data yang salah ikut lolos, dan `tsc` menganggapnya benar.

*Kesalahan umum:*
- Lupa `x !== null`. `typeof null` adalah `"object"`, jadi `null` lolos, lalu `x.nama` melempar `TypeError` saat program jalan.
- Hanya memeriksa sebagian field, atau hanya memeriksa keberadaan field dengan `in`.
- Menulis `x.nama` sebelum `apakahObject(x)`. Hasilnya `TS18046: 'x' is of type 'unknown'.`

#dipakai[Beginner 1 (`apakahObject`), Beginner 2 (`apakahItem`), dan Intermediate 3 (guard temanmu terlalu longgar).]

== Validasi Manual Bertahap

*Untuk apa:* memeriksa object yang berisi object lain atau array, dan memberi tahu alasan *pertama* data ditolak.

*Cara kerja:* periksa dari luar ke dalam. Setiap pemeriksaan yang gagal langsung mengembalikan `Hasil` gagal (pola dari TS-5). Setiap pemeriksaan yang lolos mempersempit tipe untuk langkah berikutnya.

#listing("validasi data kelas")[```ts
interface Kelas {
  wali: string;
  siswa: Siswa[];
}

function validasiKelas(x: unknown): Hasil<Kelas> {
  if (!apakahObject(x)) return { ok: false, error: "kelas harus object" };
  if (typeof x.wali !== "string") return { ok: false, error: "wali harus teks" };
  if (!Array.isArray(x.siswa)) return { ok: false, error: "siswa harus array" };

  const daftar: unknown[] = x.siswa;      // lihat penjelasan any[] di bawah
  const siswa: Siswa[] = [];
  for (let i = 0; i < daftar.length; i++) {
    const s = daftar[i];                  // s: unknown
    if (!apakahSiswa(s)) return { ok: false, error: `siswa ke-${i + 1} salah` };
    siswa.push(s);                        // s: Siswa
  }
  return { ok: true, nilai: { wali: x.wali, siswa } };
}
```]

Jalannya tipe `x.siswa`:

#table(
  columns: (auto, auto),
  inset: 6pt,
  [*Posisi*], [*Tipe `x.siswa`*],
  [setelah `apakahObject(x)`], [`unknown`],
  [setelah `Array.isArray(x.siswa)` lolos], [`any[]`],
  [disimpan ke `daftar: unknown[]`], [`unknown[]`],
)

`Array.isArray` mempersempit menjadi `any[]`, bukan `unknown[]`. Jika langsung dipakai, setiap elemennya `any`, dan pemeriksaan `tsc` hilang lagi. Menyimpannya ke variabel bertipe `unknown[]` mengembalikan kewajiban memeriksa setiap elemen.

Perhatikan juga baris `return`: object `Kelas` dibangun baru dari field yang sudah diperiksa, bukan dengan mengembalikan `x` apa adanya. Dengan begitu, field lain yang tidak dikenal di `x` tidak ikut terbawa.

Field yang boleh tidak ada (`catatan?: string`, TS-2) diperiksa hanya jika ada: `x.catatan !== undefined && typeof x.catatan !== "string"` berarti "ada, tetapi bukan teks".

#dipakai[Intermediate 1 (`validasiManual`), dan Intermediate 3 (isi JSON harus diperiksa array dulu).]

== Library zod

*Untuk apa:* menulis aturan bentuk data *sekali*, sebagai _skema_. Dari skema yang sama, `zod` memberi pemeriksaan saat program jalan *dan* tipe TypeScript-nya. Validasi manual di atas menulis bentuk `Siswa` dua kali: sekali di `interface`, sekali di guard. Jika salah satunya diubah dan yang lain lupa, keduanya tidak cocok lagi.

`zod` sudah terpasang di repo ini (`npm install zod`). Pakai dengan `import { z } from "zod";` di awal file.

#listing("skema, safeParse, dan z.infer")[```ts
import { z } from "zod";

const SkemaSiswa = z.object({
  nama: z.string({ error: "nama harus teks" }).min(1, "nama wajib diisi"),
  nilai: z.number({ error: "nilai harus angka" }).int().min(0).max(100, "nilai maksimal 100"),
  kelas: z.string().optional(),
});

type SiswaZod = z.infer<typeof SkemaSiswa>;
// { nama: string; nilai: number; kelas?: string | undefined }

const r1 = SkemaSiswa.safeParse({ nama: "Rina", nilai: 90, hobi: "voli" });
console.log(r1);
// { success: true, data: { nama: 'Rina', nilai: 90 } }      (field hobi dibuang)

const r2 = SkemaSiswa.safeParse({ nama: "Rina", nilai: 120 });
if (!r2.success) console.log(r2.error.issues[0].path, r2.error.issues[0].message);
// [ 'nilai' ] nilai maksimal 100
```]

*Cara kerja:*

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Bagian*], [*Arti*],
  [`z.string()`, `z.number()`, `z.boolean()`], [harus bertipe itu],
  [`z.object({ ... })`], [object dengan field-field ini],
  [`z.array(skema)`], [array yang setiap elemennya cocok dengan `skema`],
  [`.optional()`], [boleh tidak ada (`undefined`)],
  [`.min(n)`, `.max(n)`], [untuk string dan array: panjang. Untuk number: nilai],
  [`.int()`, `.positive()`], [bilangan bulat, lebih dari 0],
  [`{ error: "..." }` di dalam `z.string(...)`, `z.object(..., ...)`, `z.array(..., ...)`], [pesan jika *tipenya* salah],
  [argumen teks di `.min(1, "...")`, `.int("...")`, `.positive("...")`], [pesan jika *aturan* itu gagal. Aturan tanpa pesan sendiri memakai pesan dari `{ error }` di atas, jadi beri setiap aturan pesannya sendiri.],
  [`z.infer<typeof Skema>`], [tipe TypeScript yang diturunkan dari skema],
)

`typeof Skema` di sini adalah `typeof` milik TypeScript (mengambil tipe dari sebuah variabel), bukan `typeof` JavaScript yang menghasilkan teks.

=== safeParse dan issues

`safeParse` tidak pernah melempar error. Hasilnya discriminated union (TS-5) dengan penanda `success`:
- `{ success: true, data }`: `data` sudah bertipe hasil `z.infer`.
- `{ success: false, error }`: `error.issues` adalah array masalah. Setiap masalah punya `path` (letak masalah, array berisi nama field dan index) dan `message`.

#listing("membaca issues")[```ts
const r3 = SkemaSiswa.safeParse({ nama: "", nilai: "90" });
if (!r3.success) console.log(r3.error.issues.map((m) => `${m.path.join(".")}: ${m.message}`));
// [ 'nama: nama wajib diisi', 'nilai: nilai harus angka' ]

const SkemaKelas = z.object({ siswa: z.array(SkemaSiswa).min(1, "minimal 1 siswa") });
const r5 = SkemaKelas.safeParse({ siswa: [{ nama: "A", nilai: 80 }, { nama: "B", nilai: 8.5 }] });
if (!r5.success) console.log(r5.error.issues[0].path, r5.error.issues[0].path.join("."));
// [ 'siswa', 1, 'nilai' ] siswa.1.nilai

const r6 = SkemaSiswa.safeParse("Rina");
if (!r6.success) console.log(r6.error.issues[0].path, r6.error.issues[0].message);
// [] Invalid input: expected object, received string
```]

Beberapa hal dari contoh di atas:
- `zod` mengumpulkan *semua* masalah, berurutan sesuai urutan field di skema. Masalah pertama ada di `issues[0]`.
- Index array di `path` dimulai dari `0`. `siswa.1.nilai` berarti siswa kedua.
- Jika seluruh data salah tipe (bukan object), `path` kosong.
- Tanpa pesan sendiri, `zod` memakai pesan bawaan berbahasa Inggris, seperti `Invalid input: expected number, received string` atau `Invalid input: expected int, received number`.

Sebelum memeriksa `success`, `data` belum tentu ada:

```text
console.log(r.data.nama);
TS18048: 'r.data' is possibly 'undefined'.
```

Ada juga `Skema.parse(x)`. Bedanya, `parse` *melempar* `ZodError` (turunan `Error`) jika gagal, dan langsung mengembalikan data jika berhasil. Untuk data dari luar yang memang sering salah, `safeParse` lebih cocok, alasannya sama dengan memilih `Hasil` daripada `throw` di TS-5.

*Kesalahan umum:*
- Lupa `.optional()` pada field yang boleh tidak ada. Data tanpa field itu ditolak.
- Menulis `type` sendiri lalu skema terpisah. Pakai `z.infer` supaya hanya ada satu sumber.
- Objek yang dibuat dengan tipe `z.infer` tetap diperiksa `tsc`. Field yang kurang ditolak:

```text
const p: SiswaZod = { nama: "Rina" };
TS2741: Property 'nilai' is missing in type '{ nama: string; }' but required in type '{ nama: string; nilai: number; kelas?: string | undefined; }'.
```

Analogi SQL: skema `zod` seperti `CREATE TABLE` lengkap dengan `NOT NULL` dan `CHECK`. Satu definisi menentukan bentuk data dan aturan penolakannya sekaligus.

#dipakai[Intermediate 2 (`SkemaPesanan` dan `validasiZod`), dan Advanced 1.]

== JSON yang Rusak

*Untuk apa:* teks yang bukan JSON sah (terpotong, salah tanda kutip) membuat `JSON.parse` melempar `SyntaxError`. Ini terjadi *sebelum* ada data untuk divalidasi, jadi type guard dan `zod` tidak bisa menangkapnya.

#listing("menangkap JSON rusak")[```ts
try {
  JSON.parse('{"nama":"Rina"');
} catch (e) {
  console.log(e instanceof SyntaxError, e instanceof Error ? e.message : "");
}
// true Expected ',' or '}' after property value in JSON at position 14 (line 1 column 15)
```]

Saat memproses banyak teks, satu teks rusak tidak boleh menghentikan sisanya. Bungkus *hanya* `JSON.parse` dengan `try...catch`, catat kegagalannya, lalu lanjut ke teks berikutnya (`continue` di `for`, atau `return` di dalam callback `forEach`).

#listing("pola pemrosesan banyak teks")[```ts
for (const teks of daftarTeks) {
  let data: unknown;
  try {
    data = JSON.parse(teks);
  } catch {
    console.log("rusak");      // catat, lalu lanjut
    continue;
  }
  const r = SkemaSiswa.safeParse(data);
  if (!r.success) { console.log(r.error.issues[0].message); continue; }
  console.log(r.data.nama);    // r.data: SiswaZod
}
```]

`catch` tanpa `(e)` boleh ditulis jika error-nya tidak dibaca. `data` dideklarasikan di luar `try` supaya bisa dipakai setelah blok `try` selesai.

#dipakai[Advanced 1 (baris `JSON rusak`).]

== Kapan Memakai Apa

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Cara*], [*Memeriksa saat program jalan?*], [*Cocok untuk*],
  [`as T` atau `const x: T = JSON.parse(...)`], [tidak], [hampir tidak pernah untuk data dari luar],
  [type guard manual], [ya, sesuai isi guard], [bentuk kecil, tanpa library, atau pemeriksaan khusus],
  [skema `zod`], [ya, dan tipenya diturunkan dari skema], [bentuk besar atau bersarang, dan perlu pesan error per field],
)

#dipakai[seluruh soal. Beginner dan Intermediate 1 memakai guard manual, Intermediate 2 dan Advanced memakai `zod`.]

== Membaca Pesan Error tsc (tambahan TS-6)

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Nomor*], [*Pesan*], [*Penyebab umum*],
  [`TS18046`], [`'data' is of type 'unknown'.`], [Membaca field dari `unknown` sebelum dipersempit.],
  [`TS2322`], [`Type 'unknown' is not assignable to type 'Siswa'.`], [Memasukkan `unknown` ke variabel bertipe lain sebelum diperiksa.],
  [`TS2339`], [`Property 'nama' does not exist on type 'object'.`], [Hanya memeriksa `typeof x === "object"`. Pakai `apakahObject` atau `in`.],
  [`TS18048`], [`'r.data' is possibly 'undefined'.`], [Membaca hasil `safeParse` sebelum memeriksa `success`.],
  [`TS2741`], [`Property 'nilai' is missing in type ...`], [Object bertipe `z.infer` kurang field.],
  [`TS2345`], [`Argument of type 'Hasil<Record<string, never>>' is not assignable ...`], [Skema `z.object({})` masih kosong, jadi tipenya tidak punya field.],
)

#dipakai[seluruh soal. Saat `tsc` menampilkan error, cari nomornya di tabel ini dan di HO sebelumnya.]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-ts6.ts` (sudah tersedia di starter).

  ```ts
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

  // Bagian 2: buka satu baris, jalankan npx tsc --noEmit, lalu tutup lagi.
  // console.log(data.nama);
  // console.log(r.data.nama);
  // const p: z.infer<typeof Skema> = { nama: "Ani" };
  ```

  1. Tulis tebakan output setiap baris `console.log` sebelum menjalankan `node Jawaban/soal-ts6.ts coba`. Tebakan mana yang salah, dan mengapa?
  2. Bagian 2: untuk setiap baris, tulis nomor dan pesan error `tsc`-nya.
  3. `data` dan `bebas` berisi hasil `JSON.parse` yang sama. Mengapa `bebas.umur + 1` diterima `tsc`, tetapi `data.nama` ditolak?
  4. Ganti isi `apakahAngka` menjadi `return typeof x === "string";`. Apakah `tsc` protes? Jika `nilai` berisi `"42"` (string), apa yang terjadi saat program jalan, dan mengapa?

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
