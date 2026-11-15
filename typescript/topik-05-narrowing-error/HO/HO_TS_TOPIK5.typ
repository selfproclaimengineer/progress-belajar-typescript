#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "TypeScript Modul 5", judul: "Narrowing dan Error Handling")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menjelaskan _narrowing_: cara TypeScript mempersempit tipe union di dalam `if` dan `switch`
- Memakai `typeof`, `in`, `instanceof`, dan perbandingan `===` untuk mempersempit tipe
- Menulis discriminated union dan memastikan semua kasus ditangani dengan `never`
- Membuat class error sendiri yang membawa data tambahan, lalu membedakannya di `catch`
- Menjelaskan bahaya `as`
- Memilih antara `throw` dan pola Result untuk kegagalan

= Dasar Teori

== Narrowing

*Untuk apa:* nilai bertipe union, misalnya `number | string`, belum boleh dipakai sebagai salah satu tipe saja. Method string tidak ada di number, dan sebaliknya. Program harus memeriksa dulu, dan TypeScript mengikuti pemeriksaan itu.

#listing("union harus diperiksa dulu")[```ts
function besar(x: string | number): string {
  return x.toUpperCase();
  // TS2339: Property 'toUpperCase' does not exist on type 'string | number'.
  //         Property 'toUpperCase' does not exist on type 'number'.
}

function besarAman(x: string | number): string {
  if (typeof x === "string") {
    return x.toUpperCase();      // di sini x: string
  }
  return x.toFixed(2);           // di sini x: number (string sudah keluar lewat return)
}
```]

*Cara kerja:* TypeScript membaca alur program. Di dalam `if (typeof x === "string")`, tipe `x` dipersempit menjadi `string`. Setelah cabang itu selesai dengan `return`, sisa kemungkinannya hanya `number`. Proses ini disebut _narrowing_. Kamu sudah memakainya di TS-1 saat memeriksa `if (stok === undefined)`.

Jalannya tipe `x` di `besarAman`:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Posisi*], [*Alasan*], [*Tipe `x`*],
  [awal fungsi], [dari parameter], [`string | number`],
  [di dalam `if`], [`typeof x === "string"` benar], [`string`],
  [setelah `if`], [cabang string sudah `return`], [`number`],
)

Analogi SQL: seperti `CASE WHEN jenis = 'transfer' THEN tujuan ... END`. Kolom `tujuan` hanya bermakna di cabang yang jenisnya transfer.

#dipakai[seluruh soal. Setiap tugas meminta kamu memeriksa bentuk data sebelum memakainya.]

== typeof

*Untuk apa:* membedakan tipe dasar: string, number, boolean, undefined, function.

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt,
  [*Nilai*], [*`typeof`*], [*Catatan*],
  [`"abc"`], [`"string"`], [],
  [`15000`, `NaN`], [`"number"`], [`NaN` juga number],
  [`true`], [`"boolean"`], [],
  [`undefined`], [`"undefined"`], [],
  [`() => 1`], [`"function"`], [],
  [`{}`, `[]`, `null`], [`"object"`], [jebakan: array dan `null` juga `"object"`],
)

Karena `typeof [] === "object"`, pakai `Array.isArray(x)` untuk memeriksa array. Untuk `null`, bandingkan langsung: `x === null`.

#listing("dari teks form menjadi number")[```ts
const teks = "1.250.000";
const tanpaTitik = teks.replaceAll(".", "");   // "1250000"  (replaceAll dari JS-4)
const n = Number(tanpaTitik);                   // 1250000
console.log(Number("dua"));                     // NaN
console.log(Number.isNaN(Number("dua")));       // true
console.log(Number("dua") === NaN);             // false  (NaN tidak sama dengan apa pun, termasuk dirinya)
```]

*Kesalahan umum:* memeriksa `NaN` dengan `=== NaN`. Hasilnya selalu `false`. Pakai `Number.isNaN(n)`.

#dipakai[Beginner 1, untuk memisahkan `number` dan `string` di `formatNominal`, lalu memeriksa hasil ubahan dengan `Number.isNaN`.]

== Discriminated Union

*Untuk apa:* data yang bentuknya bermacam-macam tetapi punya satu field penanda yang sama. Contohnya mutasi rekening: semuanya punya `jenis` dan `nominal`, tetapi hanya transfer yang punya `tujuan`.

*Cara kerja:* setiap anggota union punya field penanda dengan literal type berbeda (TS-1). Memeriksa field itu dengan `switch` atau `if` mempersempit object ke satu bentuk.

#listing("discriminated union dan switch")[```ts
type Pengiriman =
  | { metode: "ambil"; cabang: string }
  | { metode: "kurir"; alamat: string; ongkir: number };

function label(p: Pengiriman): string {
  switch (p.metode) {
    case "ambil":
      return `Ambil di cabang ${p.cabang}`;           // p: { metode: "ambil"; cabang }
    case "kurir":
      return `Kirim ke ${p.alamat}, ongkir ${p.ongkir}`; // p: { metode: "kurir"; alamat; ongkir }
  }
}

console.log(label({ metode: "kurir", alamat: "Salatiga", ongkir: 9000 }));
// "Kirim ke Salatiga, ongkir 9000"
```]

Membaca field yang hanya ada di salah satu bentuk *sebelum* diperiksa akan ditolak:

```text
p.alamat   (di luar switch)
TS2339: Property 'alamat' does not exist on type 'Pengiriman'.
        Property 'alamat' does not exist on type '{ metode: "ambil"; cabang: string; }'.
```

=== Memastikan semua kasus ditangani dengan never

`never` adalah tipe tanpa nilai sama sekali. Jika semua anggota union sudah ditangani di `case`, sisa kemungkinan di `default` adalah `never`. Jika ada anggota baru yang lupa ditangani, sisa itu bukan lagi `never`, dan `tsc` protes.

#listing("pemeriksaan never")[```ts
function label(p: Pengiriman): string {
  switch (p.metode) {
    case "ambil":
      return `Ambil di cabang ${p.cabang}`;
    case "kurir":
      return `Kirim ke ${p.alamat}`;
    default: {
      const sisa: never = p;   // semua kasus sudah ditangani, jadi p di sini: never
      return sisa;
    }
  }
}
```]

Misalkan `Pengiriman` mendapat anggota baru `{ metode: "drone"; koordinat: string }`, tetapi `label` tidak diubah. Baris `const sisa: never = p` menjadi error:

```text
TS2322: Type '{ metode: "drone"; koordinat: string; }' is not assignable to type 'never'.
```

#dipakai[
  - Beginner 2, untuk `keterangan` dengan `switch` pada `t.jenis` dan cabang `default` berisi `never`.
  - Beginner 3, untuk menjelaskan error yang muncul saat jenis `"bayar"` ditambahkan.
]

== Operator in

*Untuk apa:* membedakan bentuk object yang *tidak* punya field penanda yang sama. Contohnya balasan layanan luar: balasan berhasil berisi `idTransaksi`, balasan gagal berisi `alasan`.

*Cara kerja:* `"nama" in obj` bernilai `true` jika object punya field itu. TypeScript mempersempit union ke anggota yang punya field tersebut.

#listing("in untuk union tanpa penanda")[```ts
type HasilCek = { stokTersedia: number } | { pesan: string };

function tampil(h: HasilCek): string {
  if ("stokTersedia" in h) {
    return `Tersedia ${h.stokTersedia}`;   // h: { stokTersedia: number }
  }
  return `Gagal: ${h.pesan}`;              // h: { pesan: string }
}
```]

Nama field ditulis sebagai *string* di sebelah kiri `in`. Salah ketik nama field di sini tidak menghasilkan error di TS 7, tetapi tipe tidak menyempit, sehingga baris sesudahnya yang ditolak.

#dipakai[Intermediate 3, untuk membedakan dua bentuk `ResponTransfer` setelah `as` dibuang.]

== instanceof dan Class Error Sendiri

*Untuk apa:* `instanceof` memeriksa apakah sebuah object dibuat dari class tertentu atau turunannya. Pemeriksaan ini paling sering dipakai di `catch`, untuk membedakan jenis error.

=== Membuat class error

Class error sendiri meng-`extends` `Error` (JS-5 dan TS-3). Pesan dikirim ke `super(...)`, dan data tambahan disimpan di field.

#listing("class error dengan data tambahan")[```ts
class StokHabisError extends Error {
  readonly kodeObat: string;
  constructor(kodeObat: string) {
    super(`stok ${kodeObat} habis`);   // menjadi e.message
    this.name = "StokHabisError";       // tampil di console dan e.name
    this.kodeObat = kodeObat;
  }
}

const e = new StokHabisError("OB02");
console.log(e.message);                  // "stok OB02 habis"
console.log(e.kodeObat);                 // "OB02"
console.log(e instanceof StokHabisError, e instanceof Error);   // true true
```]

Tanpa `this.name = ...`, `e.name` tetap `"Error"`, dan pesan di console tidak menunjukkan jenis error-nya.

=== Membedakan error di catch

Di `catch (e)`, tipe `e` adalah `unknown` (TS-1), karena yang dilempar bisa apa saja, bahkan bukan `Error`. `instanceof` mempersempit `e`, dan setelah itu field khusus bisa dibaca.

#listing("instanceof di catch")[```ts
function ambilObat(kode: string, stok: number): string {
  if (stok === 0) throw new StokHabisError(kode);
  return `${kode} diambil`;
}

function cobaAmbil(kode: string, stok: number): string {
  try {
    return ambilObat(kode, stok);
  } catch (e) {
    // console.log(e.message);   TS18046: 'e' is of type 'unknown'.
    if (e instanceof StokHabisError) return `Habis: ${e.kodeObat}`;   // e: StokHabisError
    if (e instanceof Error) return `Error: ${e.message}`;             // e: Error
    return "Error tidak dikenal";                                     // e: unknown
  }
}
```]

#perhatian[
  Urutan pemeriksaan penting. `StokHabisError` juga `instanceof Error`. Jika `if (e instanceof Error)` ditulis lebih dulu, cabang itu selalu menangkap `StokHabisError`, dan cabang khususnya tidak pernah jalan. Periksa class yang paling khusus dulu, baru yang umum.
]

Membaca field khusus dari `Error` biasa juga ditolak: `TS2339: Property 'kodeObat' does not exist on type 'Error'.` Field itu baru bisa dibaca setelah `e` dipersempit menjadi `StokHabisError`.

#dipakai[
  - Intermediate 1, untuk class `SaldoKurangError` dan `RekeningBekuError` beserta field `kekurangan` dan `nomor`.
  - Intermediate 2, untuk `cobaTarik` yang membedakan error dengan `instanceof` dan membaca field khususnya.
]

== Bahaya as

*Untuk apa `as`:* `nilai as Tipe` memerintahkan `tsc` untuk *menganggap* nilai itu bertipe tertentu. `as` tidak memeriksa apa pun dan tidak mengubah nilai saat program jalan. Ia hanya membungkam `tsc`.

#listing("as membungkam tsc")[```ts
function tampilSalah(h: HasilCek): string {
  const ada = h as { stokTersedia: number };   // "percayalah, ini pasti bentuk berhasil"
  return `Tersedia ${ada.stokTersedia}`;
}

tampilSalah({ pesan: "gudang tutup" });        // "Tersedia undefined", tanpa error
```]

`tsc` hanya menolak `as` jika kedua tipe sama sekali tidak mirip, misalnya `h as number`:

```text
TS2352: Conversion of type 'HasilCek' to type 'number' may be a mistake because
        neither type sufficiently overlaps with the other.
```

Antara anggota union dan union-nya sendiri, `as` selalu diterima. Karena itu `as` pada union adalah cara paling mudah memasukkan bug yang tidak terlihat `tsc`. Gunakan narrowing (`in`, `typeof`, `instanceof`, field penanda) yang benar-benar memeriksa saat program jalan.

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Narrowing (`in`, `typeof`, ...)*], [*`as`*],
  [diperiksa saat program jalan], [tidak diperiksa sama sekali],
  [salah bentuk masuk cabang lain], [salah bentuk tetap dipakai, hasilnya `undefined`],
  [`tsc` ikut menjaga], [`tsc` dibungkam],
)

#dipakai[Intermediate 3, untuk menjelaskan mengapa `ringkasRespon` milik temanmu lolos `tsc` tetapi mencetak `id undefined`.]

== throw atau Hasil?

Ada dua cara memberi tahu pemanggil bahwa sesuatu gagal.

*Cara 1, `throw`:* fungsi berhenti, dan error naik sampai ada `try...catch` yang menangkapnya. Tipe nilai kembalian fungsi tidak menunjukkan bahwa fungsi itu bisa gagal.

*Cara 2, Hasil (pola Result):* fungsi selalu kembali normal, dengan nilai yang menyatakan berhasil atau gagal. Bentuknya discriminated union generik (TS-4):

#listing("pola Hasil")[```ts
type Hasil<T> = { ok: true; nilai: T } | { ok: false; error: string };

function bagi(a: number, b: number): Hasil<number> {
  if (b === 0) return { ok: false, error: "pembagi nol" };
  return { ok: true, nilai: a / b };
}

const h = bagi(10, 0);
console.log(h.nilai);
// TS2339: Property 'nilai' does not exist on type 'Hasil<number>'.
//         Property 'nilai' does not exist on type '{ ok: false; error: string; }'.

if (h.ok) {
  console.log(h.nilai);    // di sini h: { ok: true; nilai: number }
} else {
  console.log(h.error);    // "pembagi nol"
}
```]

Dengan `Hasil`, `tsc` *memaksa* pemanggil memeriksa `ok` sebelum memakai `nilai`. Dengan `throw`, pemanggil bisa lupa menulis `try...catch`, dan `tsc` tidak memperingatkan.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [], [*`throw`*], [*`Hasil`*],
  [Terlihat di tipe fungsi], [tidak], [ya],
  [Pemanggil dipaksa menangani], [tidak], [ya, oleh `tsc`],
  [Cocok untuk], [kejadian yang tidak diharapkan (bug, data rusak, koneksi putus)], [kegagalan yang wajar dan sering (input salah, aturan bisnis menolak)],
  [Cara menangani], [`try...catch` dan `instanceof`], [`if (h.ok)`],
)

Analogi database: `throw` seperti transaksi yang di-`ROLLBACK` karena error. `Hasil` seperti query yang selalu mengembalikan baris berisi kolom `status` dan `keterangan`.

#dipakai[Advanced 1, untuk `transfer` yang mengembalikan `Hasil<...>` dan `cetakHasil` yang memeriksa `ok` sebelum membaca `nilai`.]

== Membaca Pesan Error tsc (tambahan TS-5)

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Nomor*], [*Pesan*], [*Penyebab umum*],
  [`TS2339`], [`Property 'x' does not exist on type 'A | B'.` disertai `Property 'x' does not exist on type 'B'.`], [Field hanya ada di sebagian anggota union. Periksa dulu.],
  [`TS2322`], [`Type '{ ... }' is not assignable to type 'never'.`], [Ada anggota union yang belum ditangani di `switch`.],
  [`TS18046`], [`'e' is of type 'unknown'.`], [Memakai `e` di `catch` sebelum `instanceof`.],
  [`TS2352`], [`Conversion of type 'X' to type 'Y' may be a mistake ...`], [`as` antara tipe yang sama sekali berbeda.],
)

#dipakai[seluruh soal. Saat `tsc` menampilkan error, cari nomornya di tabel ini dan di HO sebelumnya.]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-ts5.ts` (sudah tersedia di starter).

  ```ts
  function jelaskan(x: string | number | boolean): string {
    if (typeof x === "string") return `teks ${x.length} huruf`;
    if (typeof x === "number") return `angka ${x.toFixed(1)}`;
    return `boolean ${x}`;
  }
  console.log(jelaskan("abc"), jelaskan(2), jelaskan(false));

  const err = new RangeError("di luar batas");
  console.log(err instanceof RangeError, err instanceof Error, typeof err);
  console.log(typeof null, typeof [], Array.isArray([]));

  // Bagian 2: buka satu baris, jalankan npx tsc --noEmit, lalu tutup lagi.
  // const besar = (x: string | number) => x.toUpperCase();
  // const y = jelaskan(null);
  // let z: never = "a";
  ```

  1. Tulis tebakan output setiap baris `console.log` sebelum menjalankan `node Jawaban/soal-ts5.ts coba`. Tebakan mana yang salah, dan mengapa?
  2. Bagian 2: untuk setiap baris, tulis nomor dan pesan error `tsc`-nya.
  3. Di baris terakhir `jelaskan` (`return \`boolean ${x}\``), apa tipe `x`, dan bagaimana TypeScript tahu?
  4. `typeof null` dan `typeof []` sama-sama `"object"`. Bagaimana kamu memeriksa bahwa sebuah nilai benar-benar array? Bagaimana memeriksa `null`?

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
