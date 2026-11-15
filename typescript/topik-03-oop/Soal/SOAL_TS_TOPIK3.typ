#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal TypeScript Modul 3", judul: "OOP di TypeScript")

= Tugas

Minimarket Serba Ada menerima banyak cara bayar: tunai, dompet digital milik minimarket, kartu debit, kartu kredit, voucher, dan poin member. Aplikasi kasir lamanya punya satu fungsi `bayar(metode, nominal)` berisi `if` panjang untuk setiap metode. Setiap kali ada metode baru, fungsi itu diubah, dan bulan lalu seseorang lupa mengurangi saldo dompet di salah satu cabang `if`. Pelanggan bisa belanja berkali-kali dengan saldo yang sama.

Pemilik minimarket ingin setiap cara bayar menjadi bagiannya sendiri, dengan satu aturan bersama: semua cara bayar punya nama dan bisa diminta membayar sejumlah uang. Kasir cukup memanggil `bayar` tanpa peduli cara bayarnya apa. Saldo dan limit juga harus terlindung dari perubahan langsung. Kamu diminta menulis class-class cara bayar dan fungsi kasir yang memakainya.

#figure(
  image("uml.svg", width: 100%),
  caption: [UML class diagram cara bayar. Semua class memenuhi interface `MetodeBayar`.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan minimarket dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Salin `Soal/starter.ts` ke `Jawaban/soal-ts3.ts`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah bagian `INTERFACE`, `DATA`, `PEMANGGILAN`, dan class `Kartu`.
  3. *Cek tipe dulu* dengan `npx tsc --noEmit`, lalu *jalankan* dengan `node Jawaban/soal-ts3.ts`.
  4. Saat baru disalin, `tsc` sudah menampilkan beberapa error, misalnya `Property 'nama' is missing in type 'Tunai'`. Itu disengaja. Error itu hilang setelah class-class di bawah lengkap.
  5. Jawaban dianggap selesai jika `npx tsc --noEmit` tidak menampilkan error *dan* output `node` sama persis dengan kotak *Output dari*.
  6. Jangan memakai `any`. Jangan menulis field di parameter constructor seperti `constructor(private saldo: number)`, karena pengaturan praktikum ini menolaknya (lihat HO).
]

#level("Beginner", "0.3")

+ *Bayar tunai.*
  #kebutuhan[
    Cara bayar paling sederhana adalah tunai. Uang selalu diterima, dan kasir mencetak struk pendek berisi nominalnya. Tunai harus memenuhi aturan bersama semua cara bayar, supaya nanti kasir bisa memperlakukannya sama dengan cara bayar lain.

    *Dalam kode:* class `Tunai` memenuhi interface `MetodeBayar` dengan `implements`. Field `nama` berisi `"Tunai"` dan tidak bisa diubah.
  ]
  - Class `Tunai implements MetodeBayar`:
    - Field `nama`, `readonly`, berisi `"Tunai"`.
    - `bayar(nominal)`. Input: `nominal` number. Output: string `Tunai: dibayar <nominalRupiah>`.
  - Contoh: `new Tunai().bayar(25000)` menghasilkan `"Tunai: dibayar Rp25.000"`.

  #keluaran[`const tunai = new Tunai();` lalu `console.log(tunai.bayar(25000))`][```txt
  Tunai: dibayar Rp25.000
  ```]

+ *Dompet digital.*
  #kebutuhan[
    Pelanggan bisa mengisi saldo dompet digital milik minimarket, lalu memakainya untuk belanja. Jika saldo tidak cukup, pembayaran ditolak dan saldo tidak berubah. Kasir boleh *melihat* sisa saldo, tetapi saldo hanya boleh berubah lewat isi saldo dan pembayaran, bukan diketik langsung.

    *Dalam kode:* class `Dompet` menyimpan saldo di field `private`. Getter `sisa` membuka saldo untuk dibaca. `isiSaldo` dan `bayar` adalah satu-satunya jalan untuk mengubah saldo.
  ]
  - Class `Dompet implements MetodeBayar`:
    - `constructor(nama, saldoAwal)`. Input: `nama` string, `saldoAwal` number.
    - Field `nama` string `readonly`, field `saldo` number `private`.
    - `get sisa()`. Output: number, isi `saldo`.
    - `isiSaldo(nominal)`. Input: `nominal` number. Menambah saldo, tidak mengembalikan apa pun (`void`).
    - `bayar(nominal)`. Output: string.
      1. `nominal` lebih besar dari saldo: kembalikan `GAGAL: saldo <nama> kurang`. Saldo tidak berubah.
      2. Selain itu: kurangi saldo, kembalikan `<nama>: dibayar <nominalRupiah>, sisa <saldoRupiah>`.
  - Contoh (saldo `DompetKu` awalnya `50000`): `bayar(30000)` menghasilkan `"DompetKu: dibayar Rp30.000, sisa Rp20.000"`. `bayar(30000)` berikutnya menghasilkan `"GAGAL: saldo DompetKu kurang"` karena sisa tinggal `20000`.

  #keluaran[`const dompetku = new Dompet("DompetKu", 50000);` lalu `console.log(dompetku.bayar(30000))`][```txt
  DompetKu: dibayar Rp30.000, sisa Rp20.000
  ```]
  #keluaran[`console.log(dompetku.bayar(30000))`][```txt
  GAGAL: saldo DompetKu kurang
  ```]
  #keluaran[`dompetku.isiSaldo(100000);` lalu `console.log(dompetku.sisa)`][```txt
  120000
  ```]

+ *(jelaskan)* Seorang kasir mencoba "membantu" pelanggan dengan menulis baris ini:
  ```ts
  dompetku.saldo = 1000000;
  console.log(dompetku.sisa);
  ```
  Tempel kedua baris itu sementara di akhir file, jalankan `npx tsc --noEmit` *dan* `node Jawaban/soal-ts3.ts`, lalu hapus lagi.
  - Tulis pesan error `tsc` dan output `node` untuk baris itu.
  - Mengapa `node` tetap mengubah saldo? Apa beda `private saldo` dengan `#saldo` dari JS-5 saat program berjalan?
  - Jika saldo benar-benar tidak boleh diubah dari luar, bahkan oleh kode yang tidak diperiksa `tsc`, mana yang kamu pilih?

#level("Intermediate", "0.3")

+ *Kartu debit dan kredit.*
  #kebutuhan[
    Minimarket menerima dua jenis kartu. Keduanya punya limit pemakaian, dan pembayaran ditolak jika limit terlampaui. Bedanya hanya di biaya: kartu debit kena biaya tetap Rp2.500 per transaksi, kartu kredit kena 2% dari nominal, dibulatkan ke atas. Bagian keuangan juga ingin tahu sisa limit kartu kredit. Aturan limit sudah ditulis sekali di class `Kartu`, jadi setiap jenis kartu cukup menentukan biayanya sendiri.

    *Dalam kode:* `Kartu` adalah abstract class (sudah ada di starter). Method `biaya` ditandai `abstract`, artinya setiap turunan wajib menulisnya. `KartuDebit` dan `KartuKredit` meng-`extends` `Kartu`.
  ]
  - `KartuDebit extends Kartu`: `biaya(nominal)` mengembalikan `2500`.
  - `KartuKredit extends Kartu`:
    - `biaya(nominal)`: 2% dari `nominal`, dibulatkan ke atas.
    - `sisaLimit()`. Output: number, `limit` dikurangi `terpakai`. Kedua field itu `protected` di `Kartu`, jadi bisa dibaca dari turunannya.
  - `bayar` sudah ditulis di `Kartu`: ia memanggil `biaya` milik turunannya, menjumlah nominal dan biaya, lalu memeriksa limit.
  - Contoh (limit `Kredit` `200000`):
    - `kredit.bayar(150000)`: biaya `3000`, total `153000`, masih di bawah limit.
    - `kredit.bayar(50000)`: biaya `1000`, total `51000`. `153000 + 51000` = `204000`, melebihi limit, jadi ditolak.
    - `kredit.sisaLimit()`: `200000 - 153000` = `47000`.

  #keluaran[`console.log(debit.bayar(100000))`][```txt
  Debit: dibayar Rp102.500 (biaya Rp2.500)
  ```]
  #keluaran[`console.log(kredit.bayar(150000))`][```txt
  Kredit: dibayar Rp153.000 (biaya Rp3.000)
  ```]
  #keluaran[`console.log(kredit.bayar(50000))`][```txt
  GAGAL: limit Kredit tidak cukup
  ```]
  #keluaran[`console.log(kredit.sisaLimit())`][```txt
  47000
  ```]

+ *Bayar bertahap.*
  #kebutuhan[
    Pelanggan sering membawa beberapa cara bayar. Kasir ingin mencoba cara bayar satu per satu sesuai urutan pilihan pelanggan, dan berhenti di cara bayar pertama yang berhasil. Jika semuanya gagal, kasir melihat satu pesan gagal. Fungsi ini tidak boleh peduli jenis cara bayarnya, termasuk cara bayar baru yang belum dibuat hari ini.

    *Dalam kode:* `bayarBertahap` menerima array `MetodeBayar`. Isinya boleh campuran `Dompet`, `KartuKredit`, `Tunai`, atau object biasa seperti `poinMember`, karena semuanya memenuhi interface yang sama.
  ]
  - `bayarBertahap(total, daftar)`. Input: `total` number, `daftar` array `MetodeBayar`. Output: string.
    1. Panggil `bayar(total)` pada setiap metode, berurutan.
    2. Hasil pertama yang *tidak* diawali `GAGAL` langsung dikembalikan. Metode sesudahnya tidak dipanggil.
    3. Semua gagal, atau array kosong: kembalikan `GAGAL: semua metode ditolak`.
  - Contoh: `bayarBertahap(80000, [dompet Saku saldo 50000, KartuKredit limit 100000, Tunai])`: Saku gagal karena saldonya kurang. Kartu kredit berhasil dengan biaya `1600`, jadi hasilnya dari kartu kredit, dan `Tunai` tidak pernah dipanggil.

  #keluaran[`console.log(bayarBertahap(80000, [new Dompet("Saku", 50000), new KartuKredit("Kredit Cadangan", 100000), new Tunai()]))`][```txt
  Kredit Cadangan: dibayar Rp81.600 (biaya Rp1.600)
  ```]
  #keluaran[`console.log(bayarBertahap(80000, [new Dompet("Saku", 50000)]))`][```txt
  GAGAL: semua metode ditolak
  ```]
  #keluaran[`console.log(bayarBertahap(5000, [poinMember]))`][```txt
  Poin Member: dibayar Rp5.000
  ```]

+ *Kode temanmu: class `Voucher`.*
  #kebutuhan[
    Minimarket membagikan voucher belanja bernilai tertentu. Voucher bisa dipakai beberapa kali sampai nilainya habis, tetapi tidak boleh minus. Temanmu sudah menulis class-nya. Saat dicoba, struk mencetak angka `-10000`, bukan pesan, dan voucher yang sudah habis tetap bisa dipakai.

    *Dalam kode:* `Voucher` menyatakan `implements MetodeBayar`. `tsc` membandingkan isi class itu dengan interface dan menemukan ketidakcocokan.
  ]
  - Output yang benar dari `bayar(nominal)`: string.
    1. `nominal` lebih besar dari `sisa`: kembalikan `GAGAL: sisa voucher <sisaRupiah>`. Sisa tidak berubah.
    2. Selain itu: kurangi sisa, kembalikan `Voucher: dibayar <nominalRupiah>, sisa <sisaRupiah>`.
  - Contoh (voucher `20000`): `bayar(15000)` menyisakan `5000`. `bayar(15000)` berikutnya ditolak karena sisa `5000`.
  - *(jelaskan)* Tulis pesan error `tsc` untuk kode temanmu. Bagian mana dari interface yang dilanggar? Apa yang akan terjadi jika `Voucher` tidak menulis `implements MetodeBayar` dan langsung dipakai di `bayarBertahap`?

  #keluaran[`const voucher = new Voucher(20000);` lalu `console.log(voucher.bayar(15000))`][```txt
  Voucher: dibayar Rp15.000, sisa Rp5.000
  ```]
  #keluaran[`console.log(voucher.bayar(15000))`][```txt
  GAGAL: sisa voucher Rp5.000
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Rekap kasir harian.*
  #kebutuhan[
    Di akhir hari, kasir memproses semua transaksi yang tercatat dan mencetak rekap: satu baris hasil untuk setiap transaksi, lalu satu baris ringkasan berisi jumlah transaksi berhasil, jumlah yang gagal, dan uang yang masuk. Uang masuk dihitung dari total belanja transaksi yang berhasil, tanpa biaya kartu. Dalam satu hari, dompet atau kartu yang sama bisa dipakai beberapa kali, jadi saldo dan limitnya terus berkurang.

    *Dalam kode:* `rekapKasir` menerima array `Transaksi` (interface sudah ada di starter). Setiap transaksi membawa cara bayarnya sendiri.
  ]
  - `rekapKasir(daftar)`. Input: `daftar` array `Transaksi`. Output: string beberapa baris, dipisah `"\n"`:
    ```text
    <id> <hasilBayar>
    ...
    Berhasil <jumlahBerhasil>, gagal <jumlahGagal>, uang masuk <uangMasukRupiah>
    ```
  - Transaksi gagal jika hasil `bayar` diawali `GAGAL`.
  - Contoh: `T02` dan `T03` memakai `dompetRina` (saldo awal `60000`). `T02` membayar `40000`, jadi sisa `20000`. `T03` membayar `30000` dan gagal.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`: langkah-langkahnya, dan bentuk data di setiap langkah. Lalu jelaskan desain di soal ini. Untuk `MetodeBayar`, `Kartu`, `Dompet`, dan `poinMember`: mana yang interface, mana abstract class, mana class biasa, mana object literal, dan *mengapa* masing-masing dipilih begitu?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(rekapKasir(transaksiHariIni))`][```txt
  T01 Tunai: dibayar Rp45.000
  T02 Dompet Rina: dibayar Rp40.000, sisa Rp20.000
  T03 GAGAL: saldo Dompet Rina kurang
  T04 Kredit Budi: dibayar Rp91.800 (biaya Rp1.800)
  T05 GAGAL: limit Kredit Budi tidak cukup
  T06 Poin Member: dibayar Rp5.000
  Berhasil 4, gagal 2, uang masuk Rp180.000
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-ts3.ts`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-ts3.ts coba`.
  - Pastikan `npx tsc --noEmit` bersih, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
