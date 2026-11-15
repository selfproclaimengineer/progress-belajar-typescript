#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal TypeScript Modul 7 (opsional)", judul: "REST API dengan Express")

= Tugas

Perpustakaan Kampus Satya ingin aplikasi peminjaman buku di ponsel mahasiswa. Tim aplikasi ponsel sudah siap, tetapi mereka butuh _server_ yang menyimpan data buku dan menerima permintaan peminjaman lewat HTTP. Tim ponsel hanya akan mengirim permintaan dan membaca balasan JSON, jadi aturan seperti stok habis atau batas pinjam harus diperiksa di server.

Kamu diminta membuat REST API itu dengan Express dan TypeScript. Data disimpan di memori dulu, belum di database. Kepala perpustakaan menetapkan aturan: setiap anggota boleh meminjam paling banyak 2 buku, dan buku dengan stok 0 tidak bisa dipinjam.

#figure(
  table(
    columns: 4,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*id*], [*judul*], [*penulis*], [*stok*],
    [B001], [Laskar Pelangi], [Andrea Hirata], [2],
    [B002], [Bumi Manusia], [Pramoedya Ananta Toer], [1],
    [B003], [Filosofi Teras], [Henry Manampiring], [0],
  ),
  caption: [Data awal `daftarBuku` bertipe `Buku[]`. Data berubah setiap kali permintaan tambah, ubah, hapus, atau pinjam berhasil.],
)

Daftar route yang diminta tim ponsel:

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt,
  [*Method*], [*Jalur*], [*Kegunaan*],
  [`GET`], [`/buku`], [semua buku (Beginner 1)],
  [`GET`], [`/buku/:id`], [satu buku (Beginner 2)],
  [`POST`], [`/buku`], [menambah buku (Intermediate 1)],
  [`PATCH`], [`/buku/:id`], [mengubah sebagian data buku (Intermediate 2)],
  [`DELETE`], [`/buku/:id`], [menghapus buku (Intermediate 3, kode temanmu)],
  [`POST`], [`/pinjam`], [meminjam buku (Advanced 1)],
)

Setiap balasan gagal berbentuk `{ pesan }`. Setiap tugas di bawah diawali kotak *Kebutuhan klien*. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu.

#perhatian[
  1. Salin `Soal/starter.ts` ke `Jawaban/soal-ts7.ts`.
  2. Lengkapi route dan skema bertanda `TODO`. Jangan mengubah bagian `TIPE`, `DATA`, dan `PEMANGGILAN`.
  3. *Cek tipe dulu* dengan `npx tsc --noEmit`, lalu *jalankan* dengan `node Jawaban/soal-ts7.ts`. File itu menyalakan server, memanggil setiap route dengan `fetch`, mencetak `<status> <isi balasan>`, lalu mematikan server.
  4. Jawaban dianggap selesai jika `npx tsc --noEmit` tidak menampilkan error *dan* output `node` sama persis dengan kotak *Output dari*.
  5. Route yang belum dibuat membalas `501 {"pesan":"belum dibuat"}`. Pemanggilan berjalan berurutan pada server yang sama, jadi perubahan data terbawa ke tugas berikutnya.
  6. Jangan memakai `any`, `as`, dan tanda `!` di kodemu sendiri. Setiap balasan gagal harus diikuti `return`. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Daftar semua buku.*
  #kebutuhan[
    Halaman pertama aplikasi ponsel menampilkan semua buku beserta stoknya.

    *Dalam kode:* route `GET /buku` membalas `daftarBuku` sebagai JSON.
  ]
  - `GET /buku`. Balasan: status `200`, isi array semua buku.
  - Pakai `res.json(...)`. Status `200` adalah bawaan, tidak perlu ditulis.

  #keluaran[`console.log(await panggil("GET", "/buku"))`][```txt
  200 [{"id":"B001","judul":"Laskar Pelangi","penulis":"Andrea Hirata","stok":2},{"id":"B002","judul":"Bumi Manusia","penulis":"Pramoedya Ananta Toer","stok":1},{"id":"B003","judul":"Filosofi Teras","penulis":"Henry Manampiring","stok":0}]
  ```]

+ *Satu buku.*
  #kebutuhan[
    Saat mahasiswa membuka detail buku, aplikasi meminta satu buku berdasarkan id. Jika id-nya salah, aplikasi harus bisa membedakan "buku tidak ada" dari "server error", supaya pesan di layar tepat.

    *Dalam kode:* route `GET /buku/:id` membaca `req.params.id`, mencari dengan `find`, dan membalas `404` jika tidak ketemu.
  ]
  - `GET /buku/:id`.
    - Ketemu: status `200`, isi object buku.
    - Tidak ketemu: status `404`, isi `{ pesan: "buku tidak ditemukan" }`.
  - Contoh: `GET /buku/B002` membalas buku Bumi Manusia.

  #keluaran[`console.log(await panggil("GET", "/buku/B002"))`][```txt
  200 {"id":"B002","judul":"Bumi Manusia","penulis":"Pramoedya Ananta Toer","stok":1}
  ```]
  #keluaran[`console.log(await panggil("GET", "/buku/B009"))`][```txt
  404 {"pesan":"buku tidak ditemukan"}
  ```]

+ *(jelaskan)* Seorang anggota tim ponsel bertanya: "Kenapa tidak membalas `200` dengan isi `null` saja kalau bukunya tidak ada? Lebih sederhana."
  - Jawab dengan alasan dari sisi aplikasi yang memanggil (ingat `res.ok` di JS-7).
  - Di `GET /buku/:id`, apa tipe `req.params.id` jika alamatnya `/buku/123`? Mengapa?

#level("Intermediate", "0.3")

+ *Menambah buku.*
  #kebutuhan[
    Petugas menambah buku baru dari aplikasi. Isi permintaan dikirim aplikasi ponsel, jadi bisa salah: judul kosong, stok berupa teks, atau field yang hilang. Server harus menolak dengan pesan yang jelas dan tidak boleh menyimpan data yang salah. Id buku dibuat server, bukan dikirim aplikasi.

    *Dalam kode:* `SkemaBukuBaru` (zod, TS-6) memeriksa `req.body`. `pesanZod` (sudah ada) mengubah error pertama menjadi teks.
  ]
  - `SkemaBukuBaru`:

    #table(
      columns: (auto, 1fr, auto),
      inset: 5pt,
      stroke: 0.5pt + luma(170),
      [*Field*], [*Aturan*], [*Pesan jika gagal*],
      [`judul`], [string], [`judul harus teks`],
      [], [minimal 1 karakter], [`judul wajib diisi`],
      [`penulis`], [string], [`penulis harus teks`],
      [], [minimal 1 karakter], [`penulis wajib diisi`],
      [`stok`], [number], [`stok harus angka`],
      [], [bilangan bulat], [`stok harus bilangan bulat`],
      [], [minimal 0], [`stok tidak boleh negatif`],
    )
  - `POST /buku`:
    1. Periksa `req.body` dengan `safeParse`. Gagal: status `400`, isi `{ pesan: pesanZod(error) }`.
    2. Berhasil: tambah `nomorBuku` dengan 1, lalu buat id `B` diikuti nomor itu dengan 3 digit (pakai `padStart`, JS-4). Gabungkan id dengan data hasil `safeParse` menjadi `Buku`.
    3. Simpan ke `daftarBuku`. Balas status `201` (_Created_) dengan isi buku baru.
  - Contoh: buku pertama yang ditambahkan mendapat id `B004`.

  #keluaran[`console.log(await panggil("POST", "/buku", { judul: "Cantik Itu Luka", penulis: "Eka Kurniawan", stok: 3 }))`][```txt
  201 {"id":"B004","judul":"Cantik Itu Luka","penulis":"Eka Kurniawan","stok":3}
  ```]
  #keluaran[`console.log(await panggil("POST", "/buku", { judul: "", penulis: "Anonim", stok: 1 }))`][```txt
  400 {"pesan":"judul: judul wajib diisi"}
  ```]
  #keluaran[`console.log(await panggil("POST", "/buku", { judul: "Ronggeng Dukuh Paruk", penulis: "Ahmad Tohari", stok: "dua" }))`][```txt
  400 {"pesan":"stok: stok harus angka"}
  ```]

+ *Mengubah sebagian data buku.*
  #kebutuhan[
    Petugas sering hanya mengubah stok setelah buku baru datang, tanpa mengirim ulang judul dan penulis. Field yang dikirim tetap harus memenuhi aturan yang sama dengan buku baru.

    *Dalam kode:* `SkemaUbahBuku` diturunkan dari `SkemaBukuBaru` dengan `.partial()`, yang membuat semua field boleh tidak ada. Ini padanan `Partial<T>` dari TS-4.
  ]
  - `PATCH /buku/:id`. Pemeriksaan berurutan:
    1. Buku tidak ditemukan: status `404`, `{ pesan: "buku tidak ditemukan" }`.
    2. `req.body` tidak lolos `SkemaUbahBuku`: status `400`, `{ pesan: pesanZod(error) }`.
    3. Berhasil: salin field hasil `safeParse` ke buku itu (`Object.assign`), lalu balas `200` dengan buku yang sudah diubah.
  - Contoh: `PATCH /buku/B003` dengan isi `{ stok: 4 }` hanya mengubah stok Filosofi Teras.

  #keluaran[`console.log(await panggil("PATCH", "/buku/B003", { stok: 4 }))`][```txt
  200 {"id":"B003","judul":"Filosofi Teras","penulis":"Henry Manampiring","stok":4}
  ```]
  #keluaran[`console.log(await panggil("PATCH", "/buku/B001", { stok: -1 }))`][```txt
  400 {"pesan":"stok: stok tidak boleh negatif"}
  ```]
  #keluaran[`console.log(await panggil("PATCH", "/buku/B009", { stok: 1 }))`][```txt
  404 {"pesan":"buku tidak ditemukan"}
  ```]

+ *Kode temanmu: `DELETE /buku/:id`.*
  #kebutuhan[
    Petugas menghapus buku yang sudah tidak dimiliki perpustakaan. Temanmu sudah menulis route-nya, dan `tsc` tidak protes. Balasannya juga terlihat benar. Tetapi setelah petugas salah ketik id saat menghapus, buku lain hilang dari daftar.

    *Dalam kode:* route `DELETE /buku/:id` di starter.
  ]
  - Perilaku yang benar:
    - Buku tidak ditemukan: status `404`, `{ pesan: "buku tidak ditemukan" }`, dan *tidak ada* buku yang terhapus.
    - Ketemu: hapus dari `daftarBuku`, balas status `204` (_No Content_) tanpa isi.
  - Output kode temanmu saat ini (perhatikan baris terakhir):
    ```text
    404 {"pesan":"buku tidak ditemukan"}
    404 {"pesan":"buku tidak ditemukan"}
    200 [{"id":"B001",...},{"id":"B002",...}]
    ```
  - *(jelaskan)* Buku mana yang terhapus saat id `B009` dihapus, dan mengapa? Mengapa `res.status(404).json(...)` tidak menghentikan fungsi? Mengapa permintaan kedua (`B004`) juga membalas `404`?

  #keluaran[`console.log(await panggil("DELETE", "/buku/B009"))`][```txt
  404 {"pesan":"buku tidak ditemukan"}
  ```]
  #keluaran[`console.log(await panggil("DELETE", "/buku/B004"))`][```txt
  204 (kosong)
  ```]
  #keluaran[`console.log(await panggil("GET", "/buku"))`][```txt
  200 [{"id":"B001","judul":"Laskar Pelangi","penulis":"Andrea Hirata","stok":2},{"id":"B002","judul":"Bumi Manusia","penulis":"Pramoedya Ananta Toer","stok":1},{"id":"B003","judul":"Filosofi Teras","penulis":"Henry Manampiring","stok":4}]
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Meminjam buku.*
  #kebutuhan[
    Mahasiswa meminjam buku dari aplikasi. Peminjaman ditolak jika isi permintaan salah, bukunya tidak ada, stoknya habis, atau anggota itu sudah meminjam 2 buku. Aplikasi ponsel perlu tahu *jenis* penolakannya dari status code: isi permintaan salah, data tidak ada, atau ditolak aturan perpustakaan. Jika berhasil, stok berkurang dan aplikasi menerima nomor peminjaman.

    *Dalam kode:* `POST /pinjam` memakai skema `zod` untuk isi permintaan, lalu memeriksa aturan dengan data di `daftarBuku` dan `daftarPinjaman`.
  ]
  - Isi permintaan: `{ idBuku, idAnggota }`.
    - `idBuku` string, pesan `idBuku harus teks`.
    - `idAnggota` string, pesan `idAnggota harus teks`. Minimal 1 karakter, pesan `idAnggota wajib diisi`.
  - Pemeriksaan berurutan. Pemeriksaan pertama yang gagal langsung menentukan balasan:
    1. Isi tidak lolos skema: `400`, `{ pesan: pesanZod(error) }`.
    2. Buku tidak ada: `404`, `{ pesan: "buku tidak ditemukan" }`.
    3. Stok buku `0`: `409` (_Conflict_), `{ pesan: "stok habis" }`.
    4. Anggota sudah punya `BATAS_PINJAM` pinjaman di `daftarPinjaman`: `409`, `{ pesan: "batas pinjam tercapai" }`.
  - Berhasil: kurangi stok, simpan `{ idPinjam, idBuku, idAnggota }` ke `daftarPinjaman` dengan `idPinjam` = `P` diikuti urutan peminjaman (`P1`, `P2`, ...). Balas `201` dengan `{ idPinjam, sisaStok }`.
  - Contoh: A01 meminjam B002 (stok `1`): berhasil, `{ idPinjam: "P1", sisaStok: 0 }`. Lalu A02 meminjam B002: stoknya sudah `0`, jadi `409 stok habis`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`: urutan pemeriksaan dan alasannya (misalnya, apa yang terjadi jika stok diperiksa sebelum memastikan buku ada), mengapa status `400`, `404`, dan `409` dibedakan, dan mengapa aturan stok dan batas pinjam harus diperiksa di *server*, padahal aplikasi ponsel juga bisa memeriksanya sendiri.
  + *(opsional)* Tulis kodenya.

  #keluaran[enam `console.log(await panggil("POST", "/pinjam", ...))` berurutan, lalu `console.log(await panggil("GET", "/buku/B001"))`][```txt
  201 {"idPinjam":"P1","sisaStok":0}
  409 {"pesan":"stok habis"}
  201 {"idPinjam":"P2","sisaStok":1}
  409 {"pesan":"batas pinjam tercapai"}
  404 {"pesan":"buku tidak ditemukan"}
  400 {"pesan":"idAnggota: idAnggota harus teks"}
  200 {"id":"B001","judul":"Laskar Pelangi","penulis":"Andrea Hirata","stok":1}
  ```]

  Urutan permintaannya (lihat `PEMANGGILAN`): A01 pinjam B002, A02 pinjam B002, A01 pinjam B001, A01 pinjam B003, A02 pinjam B007, lalu isi tanpa `idAnggota`.

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-ts7.ts`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-ts7.ts coba`.
  - Pastikan `npx tsc --noEmit` bersih, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
