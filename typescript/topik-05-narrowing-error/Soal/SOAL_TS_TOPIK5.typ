#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal TypeScript Modul 5", judul: "Narrowing dan Error Handling")

= Tugas

Koperasi Simpan Pinjam Maju Bersama melayani setoran, penarikan, dan transfer antar-anggota. Aplikasi lamanya punya dua masalah. Pertama, setiap kegagalan hanya menampilkan tulisan `Error`, sehingga petugas tidak tahu apakah saldo anggota kurang, rekeningnya dibekukan, atau ada salah ketik. Kedua, balasan dari layanan transfer bank lain pernah terbaca salah, dan struk mencetak `Transfer berhasil, id undefined` untuk transfer yang sebenarnya gagal.

Pengurus koperasi ingin setiap jenis kegagalan punya pesan yang jelas, dan setiap data yang bentuknya bisa bermacam-macam diperiksa dulu sebelum dipakai. Kamu diminta menulis fungsi saldo dan transfer yang menangani semua kemungkinan itu.

#figure(
  table(
    columns: 4,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*nomor*], [*pemilik*], [*saldo*], [*status*],
    [1001], [Ani], [500000], [aktif],
    [1002], [Budi], [75000], [aktif],
    [1003], [Citra], [1200000], [beku],
  ),
  caption: [Data `daftarRekening` bertipe `Rekening[]`. Saldo berubah setiap kali tugas di bawah berhasil menarik atau mentransfer.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan koperasi dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Kerjakan di `Jawaban/soal-ts5.ts`. File itu sudah disiapkan dari `Soal/starter.ts`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah bagian `TIPE`, `DATA`, dan `PEMANGGILAN`.
  3. *Cek tipe dulu* dengan `npx tsc --noEmit`, lalu *jalankan* dengan `node Jawaban/soal-ts5.ts`. Keduanya dijalankan dari folder topik ini.
  4. Jawaban dianggap selesai jika `npx tsc --noEmit` tidak menampilkan error *dan* output `node` sama persis dengan kotak *Output dari*.
  5. Pemanggilan berjalan berurutan dan memakai `daftarRekening` yang sama, jadi saldo di satu tugas terbawa ke tugas berikutnya.
  6. Jangan memakai `any`, `as`, dan tanda `!` di kodemu sendiri. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Nominal dari dua sumber.* #est(6)
  #kebutuhan[
    Nominal transaksi datang dari dua tempat. Mesin setor mengirim angka, misalnya `15000`. Form di loket mengirim teks yang diketik petugas, sering dengan titik ribuan, misalnya `"25.000"`. Kadang petugas mengetik huruf. Koperasi ingin keduanya ditampilkan dalam format Rupiah, dan teks yang bukan angka diberi pesan.

    *Dalam kode:* `formatNominal` menerima `number | string`. `typeof` memisahkan kedua kemungkinan, dan di setiap cabang TypeScript tahu tipe pastinya.
  ]
  - `formatNominal(x)`. Input: `x` number atau string. Output: string.
    1. `x` number: kembalikan formatnya dengan `rupiah`.
    2. `x` string: buang semua titik, lalu ubah menjadi number.
    3. Hasil ubahan bukan angka (`NaN`): kembalikan `nominal tidak valid`.
    4. Selain itu: kembalikan formatnya dengan `rupiah`.
  - Contoh: `formatNominal("25.000")`: titik dibuang menjadi `"25000"`, diubah menjadi `25000`, hasilnya `"Rp25.000"`. `formatNominal("dua puluh")` menghasilkan `"nominal tidak valid"`.

  #keluaran[`console.log(formatNominal(15000))`][```txt
  Rp15.000
  ```]
  #keluaran[`console.log(formatNominal("25.000"))`][```txt
  Rp25.000
  ```]
  #keluaran[`console.log(formatNominal("dua puluh"))`][```txt
  nominal tidak valid
  ```]

+ *Keterangan mutasi.* #est(14)
  #kebutuhan[
    Buku tabungan anggota mencetak satu baris keterangan untuk setiap mutasi: setor, tarik, atau transfer. Hanya transfer yang punya rekening tujuan. Koperasi berencana menambah jenis mutasi baru tahun depan, dan tidak mau ada jenis yang lupa diberi keterangan.

    *Dalam kode:* `Transaksi` (sudah ada di starter) adalah discriminated union dengan field penanda `jenis`. `keterangan` memakai `switch` pada `jenis`. Cabang `default` berisi pemeriksaan `never`, supaya `tsc` protes jika ada jenis yang belum ditangani.
  ]
  - `keterangan(t)`. Input: `t` `Transaksi`. Output: string.
    - `"setor"`: `Setor <nominalRupiah>`.
    - `"tarik"`: `Tarik <nominalRupiah>`.
    - `"transfer"`: `Transfer <nominalRupiah> ke <tujuan>`.
  - Tulis cabang `default` dengan pemeriksaan `never` seperti di HO.
  - Contoh: `keterangan({ jenis: "transfer", nominal: 50000, tujuan: "1002" })` menghasilkan `"Transfer Rp50.000 ke 1002"`. Di cabang `"setor"`, menulis `t.tujuan` ditolak `tsc`.

  #keluaran[`console.log(keterangan({ jenis: "setor", nominal: 200000 }))`][```txt
  Setor Rp200.000
  ```]
  #keluaran[`console.log(keterangan({ jenis: "transfer", nominal: 50000, tujuan: "1002" }))`][```txt
  Transfer Rp50.000 ke 1002
  ```]

+ *(jelaskan)* Tahun depan koperasi menambah jenis mutasi bayar tagihan. Tambahkan baris ini *sementara* sebagai anggota keempat `type Transaksi`:
  ```ts
  | { jenis: "bayar"; nominal: number; tagihan: string }
  ```
  Jalankan `npx tsc --noEmit` *tanpa* mengubah `keterangan`, lalu hapus lagi baris itu.
  - Tulis pesan error `tsc`-nya dan baris mana yang ditunjuk.
  - Mengapa error itu justru membantu? Apa yang terjadi jika cabang `default` dengan `never` tidak ditulis?

#level("Intermediate", "0.3")

+ *Error khusus.* #est(22)
  #kebutuhan[
    Penarikan bisa gagal karena dua hal yang penanganannya berbeda. Jika saldo kurang, petugas perlu tahu *berapa* kekurangannya supaya bisa menawarkan jumlah lain. Jika rekening dibekukan, petugas perlu tahu *nomor* rekeningnya untuk diteruskan ke bagian CS. Pesan teks biasa tidak cukup, karena angka kekurangan dan nomor rekening harus bisa dibaca program.

    *Dalam kode:* dua class error turunan `Error`, masing-masing membawa field datanya sendiri. `tarik` melempar error yang sesuai.
  ]
  - `class SaldoKurangError extends Error`:
    - `constructor(kekurangan)`. Pesan error: `saldo kurang <kekuranganRupiah>`.
    - Field `kekurangan` number `readonly`. Field `name` berisi `"SaldoKurangError"`.
  - `class RekeningBekuError extends Error`:
    - `constructor(nomor)`. Pesan error: `rekening <nomor> dibekukan`.
    - Field `nomor` string `readonly`. Field `name` berisi `"RekeningBekuError"`.
  - `tarik(r, nominal)`. Input: `r` `Rekening`, `nominal` number. Output: number, saldo baru. Pemeriksaan berurutan:
    1. `status` `"beku"`: lempar `RekeningBekuError`.
    2. `nominal` lebih besar dari `saldo`: lempar `SaldoKurangError` dengan kekurangan = `nominal - saldo`.
    3. Selain itu: kurangi `saldo`, kembalikan saldo baru.
  - Contoh: `tarik` dari rekening 1001 (saldo `500000`) sebesar `100000` mengembalikan `400000`, dan saldo 1001 menjadi `400000`.

  #keluaran[`const contohError = new SaldoKurangError(25000);` lalu `console.log(contohError.message, contohError.kekurangan, contohError instanceof Error)`][```txt
  saldo kurang Rp25.000 25000 true
  ```]
  #keluaran[`console.log(contohError.name)`][```txt
  SaldoKurangError
  ```]
  #keluaran[`console.log(tarik(daftarRekening[0], 100000))`][```txt
  400000
  ```]

+ *Tarik dengan pesan jelas.* #est(11)
  #kebutuhan[
    Layar petugas tidak boleh menampilkan error mentah. Setiap jenis kegagalan diterjemahkan menjadi pesan yang bisa dibacakan ke anggota. Kegagalan yang tidak dikenal tetap ditampilkan, tetapi diberi tanda bahwa itu error tak terduga.

    *Dalam kode:* `cobaTarik` memanggil `tarik` di dalam `try`. Di `catch`, error bertipe `unknown`. `instanceof` memisahkan setiap jenis error, dan setelah itu field khususnya (`kekurangan`, `nomor`) bisa dibaca.
  ]
  - `cobaTarik(r, nominal)`. Input: `r` `Rekening`, `nominal` number. Output: string.
    - Berhasil: `Berhasil, saldo <nomor> <saldoRupiah>`.
    - `SaldoKurangError`: `Ditolak: kurang <kekuranganRupiah>`.
    - `RekeningBekuError`: `Ditolak: rekening <nomor> dibekukan, hubungi CS`.
    - `Error` lain: `Error: <pesan>`. Bukan `Error` sama sekali: `Error tidak dikenal`.
  - Contoh: rekening 1002 (saldo `75000`) menarik `100000`: kekurangannya `25000`, jadi hasilnya `"Ditolak: kurang Rp25.000"`.

  #keluaran[`console.log(cobaTarik(daftarRekening[0], 50000))` (saldo 1001 sebelumnya `400000`)][```txt
  Berhasil, saldo 1001 Rp350.000
  ```]
  #keluaran[`console.log(cobaTarik(daftarRekening[1], 100000))`][```txt
  Ditolak: kurang Rp25.000
  ```]
  #keluaran[`console.log(cobaTarik(daftarRekening[2], 10000))`][```txt
  Ditolak: rekening 1003 dibekukan, hubungi CS
  ```]

+ *Kode temanmu: `ringkasRespon(r)`.* #est(4)
  #kebutuhan[
    Transfer ke bank lain dikirim lewat layanan pihak ketiga. Jika berhasil, layanan itu membalas id transaksi dan biaya. Jika gagal, layanan membalas alasan kegagalannya. Kedua balasan tidak punya field penanda yang sama. Temanmu menulis fungsi ringkasan, dan `tsc` tidak protes. Tetapi untuk transfer gagal, struk mencetak `Transfer berhasil, id undefined, biaya RpNaN`.

    *Dalam kode:* `ResponTransfer` (sudah ada) adalah union dua bentuk object. Bentuk mana yang diterima harus diperiksa saat program jalan, bukan dipaksakan.
  ]
  - Output yang benar: string.
    - Balasan berhasil: `Transfer berhasil, id <idTransaksi>, biaya <biayaRupiah>`.
    - Balasan gagal: `Transfer gagal: <alasan>`.
  - Hapus `as` dari kode temanmu. Kedua bentuk tidak punya field penanda yang sama, jadi pakai operator `in`.
  - *(jelaskan)* Mengapa `tsc` tidak menolak kode temanmu? Apa yang sebenarnya dilakukan `as`, dan mengapa itu berbahaya?

  #keluaran[`console.log(ringkasRespon({ idTransaksi: "TRX-77", biaya: 2500 }))`][```txt
  Transfer berhasil, id TRX-77, biaya Rp2.500
  ```]
  #keluaran[`console.log(ringkasRespon({ alasan: "rekening tujuan tidak ada" }))`][```txt
  Transfer gagal: rekening tujuan tidak ada
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Transfer antar-anggota.* #est(18)
  #kebutuhan[
    Anggota bisa mentransfer saldo ke anggota lain. Transfer ditolak jika nominalnya tidak masuk akal, salah satu rekening tidak ada, rekening tujuan sama dengan pengirim, salah satu rekening dibekukan, atau saldo pengirim kurang. Kegagalan seperti ini *biasa terjadi* setiap hari, jadi koperasi tidak mau memakai `throw` untuk kasus ini. Fungsi transfer cukup mengembalikan hasil yang menyatakan berhasil atau gagal beserta alasannya.

    *Dalam kode:* `transfer` mengembalikan `Hasil<...>` (sudah ada di starter): `{ ok: true, nilai }` atau `{ ok: false, error }`. `cetakHasil` (sudah ada) memeriksa `ok` sebelum membaca `nilai`.
  ]
  - `transfer(dari, ke, nominal, daftar)`. Input: `dari` dan `ke` nomor rekening (string), `nominal` number, `daftar` array `Rekening`. Output: `Hasil<{ saldoPengirim: number; saldoPenerima: number }>`.
  - Pemeriksaan berurutan. Pemeriksaan pertama yang gagal langsung menentukan `error`:
    1. `nominal` 0 atau kurang: `nominal harus lebih dari 0`.
    2. Rekening `dari` tidak ada: `rekening <dari> tidak ada`.
    3. Rekening `ke` tidak ada: `rekening <ke> tidak ada`.
    4. `dari` dan `ke` rekening yang sama: `rekening tujuan sama dengan pengirim`.
    5. Salah satu rekening berstatus `"beku"`: `salah satu rekening dibekukan`.
    6. `nominal` lebih besar dari saldo pengirim: `saldo <dari> kurang`.
  - Jika semua lolos: kurangi saldo pengirim, tambah saldo penerima, kembalikan kedua saldo baru.
  - Contoh: sebelum Advanced, saldo 1001 `350000` dan 1002 `75000`. Transfer `150000` dari 1001 ke 1002 membuat saldo 1001 `200000` dan 1002 `225000`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`: langkah-langkahnya, *tipe data* di setiap langkah (termasuk hasil `find`), dan mengapa urutan pemeriksaan di atas penting. Contohnya, apa yang terjadi jika pemeriksaan saldo ditulis sebelum memastikan rekening ada? Jelaskan juga: mengapa koperasi memilih `Hasil` daripada `throw` untuk kasus ini, padahal `tarik` di Intermediate 1 memakai `throw`?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(cetakHasil(transfer("1001", "1002", 150000, daftarRekening)))`][```txt
  OK: sisa pengirim Rp200.000, saldo penerima Rp225.000
  ```]
  #keluaran[`console.log(cetakHasil(transfer("1002", "1009", 10000, daftarRekening)))`][```txt
  GAGAL: rekening 1009 tidak ada
  ```]
  #keluaran[`console.log(cetakHasil(transfer("1002", "1001", 300000, daftarRekening)))`][```txt
  GAGAL: saldo 1002 kurang
  ```]
  #keluaran[`console.log(cetakHasil(transfer("1001", "1003", 10000, daftarRekening)))`][```txt
  GAGAL: salah satu rekening dibekukan
  ```]
  #keluaran[`console.log(cetakHasil(transfer("1001", "1001", 10000, daftarRekening)))`][```txt
  GAGAL: rekening tujuan sama dengan pengirim
  ```]
  #keluaran[`console.log(cetakHasil(transfer("1001", "1002", 0, daftarRekening)))`][```txt
  GAGAL: nominal harus lebih dari 0
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-ts5.ts`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-ts5.ts coba`.
  - Pastikan `npx tsc --noEmit` bersih, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
