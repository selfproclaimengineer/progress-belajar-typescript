#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "TypeScript Modul 7 (opsional)", judul: "REST API dengan Express")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menjelaskan REST: method, jalur, status code, dan isi JSON
- Membuat server dengan Express dan memberi tipe pada handler
- Membaca parameter jalur (`req.params`) dan isi permintaan (`req.body`)
- Membalas dengan status code yang tepat, dan selalu berhenti setelah membalas
- Memvalidasi isi permintaan dengan `zod` sebelum menyimpan data
- Menguji server dengan `fetch` dari program yang sama

= Dasar Teori

== REST dan HTTP

*Untuk apa:* di JS-7 kamu menjadi _client_: memanggil server palsu dengan `fetch`. Sekarang kamu menjadi _server_: program yang menunggu permintaan, memprosesnya, lalu membalas. REST adalah kebiasaan umum untuk menyusun alamat dan arti setiap permintaan, supaya client dan server dari tim berbeda bisa saling paham.

Setiap permintaan HTTP punya:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Bagian*], [*Contoh*],
  [method], [`GET`, `POST`, `PATCH`, `DELETE`],
  [jalur], [`/buku`, `/buku/B002`],
  [header], [`Content-Type: application/json`],
  [isi (_body_)], [`{"judul":"Cantik Itu Luka","stok":3}`, hanya untuk `POST`/`PATCH`/`PUT`],
)

Arti method dalam REST, dengan padanan SQL:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Method dan jalur*], [*Arti*], [*Padanan SQL*],
  [`GET /buku`], [ambil semua], [`SELECT * FROM buku`],
  [`GET /buku/B002`], [ambil satu], [`SELECT ... WHERE id = 'B002'`],
  [`POST /buku`], [tambah], [`INSERT INTO buku ...`],
  [`PATCH /buku/B002`], [ubah sebagian field], [`UPDATE buku SET stok = 4 WHERE id = 'B002'`],
  [`DELETE /buku/B002`], [hapus], [`DELETE FROM buku WHERE id = 'B002'`],
)

Jalur berisi *kata benda* (`/buku`), dan method menyatakan *kata kerja*-nya. Hindari jalur seperti `/hapusBuku`.

=== Status code

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt,
  [*Kode*], [*Nama*], [*Dipakai saat*],
  [`200`], [OK], [berhasil, ada isi balasan],
  [`201`], [Created], [berhasil membuat data baru (`POST`)],
  [`204`], [No Content], [berhasil, tanpa isi balasan (`DELETE`)],
  [`400`], [Bad Request], [isi permintaan salah bentuk atau tidak lolos validasi],
  [`404`], [Not Found], [data atau jalur tidak ada],
  [`409`], [Conflict], [permintaan benar, tetapi bertentangan dengan keadaan data (stok habis, batas tercapai)],
  [`500`], [Internal Server Error], [bug di server],
)

Kelompok `2xx` berarti berhasil (`res.ok` bernilai `true` di client), `4xx` berarti kesalahan di pihak client, `5xx` berarti kesalahan di pihak server. Client memakai status code untuk memutuskan apa yang ditampilkan, tanpa harus membaca dan menebak isi balasan.

#dipakai[seluruh soal, terutama Beginner 3 dan Advanced 1 (memilih `400`, `404`, atau `409`).]

== Express: Server Pertama

*Untuk apa:* Node punya modul `http` bawaan, tetapi menulis server dengannya cukup panjang. Express adalah library server yang paling banyak dipakai di Node. Express dan tipe TypeScript-nya (`@types/express`) sudah terpasang di repo ini.

#listing("server minimal")[```ts
import express from "express";
import type { Request, Response } from "express";

const app = express();
app.use(express.json());     // ubah isi permintaan JSON menjadi object di req.body

app.get("/halo", (req: Request, res: Response) => {
  res.json({ pesan: "halo" });
});

app.listen(3000, () => console.log("jalan di http://localhost:3000"));
```]

*Cara kerja:*
- `express()` membuat _app_. App menyimpan daftar route.
- `app.get(jalur, handler)` mendaftarkan _handler_ untuk method `GET` di jalur itu. Ada juga `app.post`, `app.patch`, `app.put`, `app.delete`.
- Handler adalah callback (JS-7) yang dipanggil Express setiap ada permintaan yang cocok. `req` berisi permintaan, `res` dipakai untuk membalas.
- `app.listen(port)` mulai menunggu permintaan di port itu. Program tidak berhenti sampai server dimatikan.
- `app.use(express.json())` memasang _middleware_: fungsi yang berjalan sebelum setiap handler. Middleware ini membaca isi permintaan yang ber-header `Content-Type: application/json` dan menaruh hasilnya di `req.body`.

`import type` dipakai untuk `Request` dan `Response` karena keduanya hanya tipe. Saat `node` membuang tipe (TS-1), baris `import type` ikut dibuang seluruhnya.

Jalur yang tidak didaftarkan dibalas Express dengan `404` dan halaman HTML `Cannot GET /jalur`, tanpa kamu menulis apa pun.

#dipakai[`buatApp` di starter (sudah ditulis), dan seluruh soal.]

== Parameter Jalur

*Untuk apa:* satu route untuk banyak id. `/buku/B001`, `/buku/B002`, dan seterusnya ditangani satu handler.

#listing("membaca :id")[```ts
app.get("/kue/:id", (req: Request<{ id: string }>, res: Response) => {
  const kue = daftarKue.find((k) => k.id === req.params.id);
  if (kue === undefined) {
    res.status(404).json({ pesan: "kue tidak ditemukan" });
    return;
  }
  res.json(kue);
});
```]

*Cara kerja:* bagian jalur yang diawali `:` adalah parameter. Untuk permintaan `/kue/K7`, `req.params.id` berisi `"K7"`. Parameter jalur *selalu* string, karena berasal dari teks alamat. Alamat `/kue/123` menghasilkan `"123"`, bukan `123`. Ubah sendiri dengan `Number(...)` jika butuh angka, dan periksa hasilnya (`Number.isNaN`).

`Request<{ id: string }>` adalah generic (TS-4): memberi tahu TypeScript bentuk `req.params`.

#dipakai[Beginner 2, Intermediate 2, Intermediate 3, dan Beginner 3 (jelaskan).]

== Membalas, lalu Berhenti

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Cara membalas*], [*Hasil*],
  [`res.json(data)`], [status `200`, isi `data` sebagai JSON],
  [`res.status(201).json(data)`], [status `201`, isi `data`],
  [`res.status(404).json({ pesan })`], [status `404`, isi pesan],
  [`res.status(204).end()`], [status `204`, tanpa isi],
)

`res.status(...)` mengembalikan `res` lagi, jadi bisa disambung dengan `.json(...)`.

*Penting:* `res.json(...)` *mengirim* balasan, tetapi *tidak menghentikan* fungsi. Baris setelahnya tetap dijalankan. Karena itu, setiap balasan gagal di tengah handler harus diikuti `return`, sama seperti pola pemeriksaan berurutan di TS-5.

#listing("lupa return")[```ts
app.get("/kue/:id", (req: Request<{ id: string }>, res: Response) => {
  const i = daftarKue.findIndex((k) => k.id === req.params.id);
  if (i === -1) {
    res.status(404).json({ pesan: "kue tidak ditemukan" });
    // tanpa return: lanjut ke bawah dengan i = -1
  }
  console.log(daftarKue.at(i));   // at(-1) adalah elemen TERAKHIR
  res.json({ ok: true });
  // Error: Cannot set headers after they are sent to the client  (kode ERR_HTTP_HEADERS_SENT)
});
```]

Jika handler membalas dua kali dengan `res.json`, Express melempar `ERR_HTTP_HEADERS_SENT`. Tetapi tidak semua cara membalas kedua kali melempar error. Bug "lupa `return`" bisa juga diam-diam menjalankan baris yang mengubah data, tanpa pesan apa pun. Index `-1` dari `findIndex` sangat berbahaya: `at(-1)` dan `splice(-1, 1)` sama-sama menunjuk elemen *terakhir*.

#dipakai[Beginner 2, Intermediate 1–2, Intermediate 3 (kode temanmu), dan aturan nomor 6 di kotak Perhatian.]

== Isi Permintaan dan Validasi

*Untuk apa:* isi permintaan dikirim program lain, jadi termasuk data dari luar (TS-6). Server tidak boleh percaya begitu saja.

*Cara kerja:* tipe `req.body` di Express adalah `any`. Artinya `tsc` diam saja apa pun yang kamu lakukan dengannya, persis masalah `JSON.parse` di TS-6. Perlakukan `req.body` sebagai `unknown`, dan periksa dengan skema `zod` sebelum dipakai.

#listing("POST dengan validasi zod")[```ts
const SkemaKueBaru = z.object({
  nama: z.string({ error: "nama harus teks" }).min(1, "nama wajib diisi"),
  harga: z.number({ error: "harga harus angka" }).int("harga harus bilangan bulat"),
});

app.post("/kue", (req: Request, res: Response) => {
  const hasil = SkemaKueBaru.safeParse(req.body);
  if (!hasil.success) {
    res.status(400).json({ pesan: hasil.error.issues[0].message });
    return;
  }
  nomor++;
  const kue: Kue = { id: `K${String(nomor).padStart(3, "0")}`, ...hasil.data };
  daftarKue.push(kue);
  res.status(201).json(kue);
});
```]

Hal yang perlu diperhatikan:
- Id dibuat server, bukan diambil dari isi permintaan. Client tidak boleh menentukan id sendiri, karena bisa bentrok dengan id yang sudah ada.
- `...hasil.data` menyebar field yang *sudah diperiksa*. Field asing di `req.body` sudah dibuang `zod` (TS-6), jadi tidak ikut tersimpan.
- `String(4).padStart(3, "0")` menghasilkan `"004"` (JS-4).

=== PATCH dan .partial()

`PATCH` mengubah sebagian field. Skemanya sama dengan skema tambah, tetapi semua field boleh tidak ada. `zod` menyediakan `.partial()` untuk itu, padanan `Partial<T>` di TS-4.

```ts
const SkemaUbahKue = SkemaKueBaru.partial();
// { nama?: string | undefined; harga?: number | undefined }

const hasil = SkemaUbahKue.safeParse(req.body);
if (hasil.success) Object.assign(kue, hasil.data);   // salin field yang dikirim saja
```

`Object.assign(target, sumber)` menyalin setiap field `sumber` ke `target`. Di sini aman, karena `sumber` sudah lolos skema. Bandingkan dengan kode temanmu di TS-4 Intermediate 3 yang memakai `Object.assign` dengan data `any`.

*Kesalahan umum:*
- Lupa `app.use(express.json())`. `req.body` menjadi `undefined`, dan `safeParse` gagal dengan pesan `Invalid input: expected object, received undefined`.
- Client lupa header `Content-Type: application/json`. `express.json()` tidak membaca isinya, dan `req.body` juga `undefined`.
- Isi permintaan bukan JSON sah. `express.json()` sendiri yang membalas `400` dengan pesan `SyntaxError`, sebelum handler-mu dipanggil.

#dipakai[Intermediate 1 (`SkemaBukuBaru`), Intermediate 2 (`.partial()` dan `Object.assign`), dan Advanced 1.]

== Urutan Pemeriksaan di Handler

Handler yang menerima data biasanya memeriksa dalam urutan yang sama, dan setiap langkah butuh hasil langkah sebelumnya:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Langkah*], [*Pertanyaan*], [*Gagal*],
  [1], [Apakah isi permintaan berbentuk benar?], [`400`],
  [2], [Apakah data yang dirujuk ada?], [`404`],
  [3], [Apakah aturan bisnis mengizinkan?], [`409`],
  [4], [Ubah data, lalu balas], [`200`/`201`/`204`],
)

Langkah 2 butuh id yang sudah pasti string dari langkah 1. Langkah 3 butuh object yang sudah pasti ada dari langkah 2. Pola ini sama dengan `transfer` di TS-5 dan `validasiManual` di TS-6, hanya hasil akhirnya berupa status code.

Aturan bisnis harus diperiksa di server walaupun client sudah memeriksanya. Server bisa dipanggil oleh client mana pun, termasuk versi aplikasi lama, aplikasi lain, atau orang yang mengirim permintaan langsung dengan `curl`. Pemeriksaan di client hanya untuk kenyamanan pengguna.

Analogi SQL: constraint `CHECK` dan foreign key ada di database, bukan di aplikasi, karena banyak aplikasi bisa menulis ke tabel yang sama.

#dipakai[Advanced 1 (`POST /pinjam`).]

== Menguji Server

=== Dengan fetch dari program yang sama

Soal ini menyalakan server, memanggilnya, lalu mematikannya, semuanya dalam satu file:

```ts
const server = app.listen(0);   // port 0: sistem memilih port kosong secara acak
// ... tunggu "listening", baca port dari server.address() ...
const res = await fetch(`http://127.0.0.1:${port}/buku`, { method: "GET" });
console.log(res.status, await res.text());
server.close();                 // berhenti menerima permintaan baru
server.closeAllConnections();   // putuskan koneksi yang masih terbuka
```

Port acak dipakai supaya tidak bentrok dengan program lain. Port yang sudah terpakai membuat `listen` gagal dengan error `EADDRINUSE`. Selama server masih menyala, `node` tidak berhenti, jadi server harus dimatikan di akhir.

=== Dengan curl saat server menyala terus

Untuk mencoba secara manual, nyalakan server dengan port tetap, lalu dari terminal lain:

```text
curl http://localhost:3000/buku
curl -X POST http://localhost:3000/buku -H "Content-Type: application/json" -d "{\"judul\":\"X\",\"penulis\":\"Y\",\"stok\":1}"
curl -i -X DELETE http://localhost:3000/buku/B009        (-i menampilkan status code)
```

#dipakai[bagian `PEMANGGILAN` dan fungsi `nyalakan` di starter (sudah ditulis).]

== Membaca Pesan Error (tambahan TS-7)

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Pesan atau gejala*], [*Penyebab umum*],
  [`501 {"pesan":"belum dibuat"}`], [Route masih berisi kode starter.],
  [`404` dengan isi HTML `Cannot GET /...`], [Jalur atau method tidak didaftarkan, atau salah ketik jalur.],
  [`Error: Cannot set headers after they are sent to the client`], [Membalas dua kali. Biasanya lupa `return` setelah balasan gagal.],
  [Data berubah padahal balasannya `404`], [Lupa `return`, lalu baris yang mengubah data tetap berjalan dengan index `-1`.],
  [`Invalid input: expected object, received undefined`], [`req.body` kosong: lupa `express.json()` atau header `Content-Type`.],
  [`EADDRINUSE`], [Port sudah dipakai program lain, misalnya server yang belum dimatikan.],
)

#dipakai[seluruh soal.]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-ts7.ts` (sudah tersedia di starter).

  ```ts
  const app = express();
  app.use(express.json());
  app.get("/halo/:nama", (req: Request<{ nama: string }>, res: Response) => {
    res.json({ sapa: `halo ${req.params.nama}`, tipe: typeof req.params.nama });
  });
  app.post("/gema", (req: Request, res: Response) => {
    res.status(201).json(req.body);
  });

  const { dasar, matikan } = await nyalakan(app);
  let res = await fetch(dasar + "/halo/123");
  console.log(res.status, await res.text());
  res = await fetch(dasar + "/tidak-ada");
  console.log(res.status);
  res = await fetch(dasar + "/gema", { method: "POST", headers: { "Content-Type": "application/json" }, body: '{"a":1}' });
  console.log(res.status, await res.text());
  res = await fetch(dasar + "/gema", { method: "POST", body: '{"a":1}' });
  console.log(res.status, JSON.stringify(await res.text()));
  await matikan();
  ```

  1. Tulis tebakan output setiap baris `console.log` sebelum menjalankan `node Jawaban/soal-ts7.ts coba`. Tebakan mana yang salah, dan mengapa?
  2. Mengapa `tipe` berisi `"string"`, padahal alamatnya `/halo/123`?
  3. Kamu tidak menulis route `/tidak-ada`. Dari mana status code pada baris kedua berasal?
  4. Permintaan `/gema` yang terakhir mengirim isi yang sama, tetapi balasannya berbeda. Apa bedanya permintaan itu, dan apa isi `req.body` di handler?

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
