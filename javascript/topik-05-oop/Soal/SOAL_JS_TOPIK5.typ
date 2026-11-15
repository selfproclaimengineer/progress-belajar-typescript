#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal Modul 5", judul: "Object-Oriented Programming")

= Tugas

Bank Sejahtera adalah bank kecil yang selama ini mencatat rekening nasabah di buku besar. Petugas teller sering salah hitung, dan pernah ada saldo yang dicoret lalu ditulis ulang tanpa bukti. Bank meminta kamu membuat aplikasi untuk teller. Aplikasi ini harus bisa mencatat rekening, menerima setoran dan penarikan, menghitung bunga tabungan, dan memindahkan uang antar-rekening. Semua itu dilakukan tanpa ada angka yang bisa diubah sembarangan.

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan bank dan mengapa. Baris *Dalam kode* di kotak itu menunjukkan bagian kode yang menjawab kebutuhan tersebut. Spesifikasi teknis (format output persis) ada di poin-poin setelahnya.

Aplikasi ini terdiri dari tiga class: `Rekening`, `Tabungan` (turunan `Rekening` yang punya bunga), dan `Bank` yang menyimpan banyak rekening.

#figure(
  image("uml.svg", width: 95%),
  caption: [UML class diagram. Tanda `+` berarti publik, `-` berarti privat. Panah segitiga berarti `extends`. Belah ketupat berarti `Bank` menyimpan nol atau banyak `Rekening`.],
)

#perhatian[
  1. Salin `Soal/starter.js` ke folder `Jawaban/`, misalnya `Jawaban/soal-js5.js`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah bagian `PEMANGGILAN`.
  3. Jalankan `node Jawaban/soal-js5.js`. Kotak *Output dari* `console.log(...)` di bawah setiap tugas menunjukkan baris `console.log` yang mencetaknya dan output yang harus keluar persis.
  4. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
  5. Pemanggilan berjalan berurutan dan memakai object yang sama, jadi saldo di satu tugas terbawa ke tugas berikutnya. Semua number adalah bilangan bulat.
]

#level("Beginner", "0.3")

+ *Class `Rekening`.*
  #kebutuhan[
    Setiap nasabah yang membuka rekening punya nomor rekening, nama pemilik, dan setoran awal. Setoran awal boleh nol. Saat nasabah bertanya "saldo saya berapa?", teller ingin melihat ringkasan rekening dalam satu baris. Bank juga tidak mau angka saldo bisa ditulis langsung oleh siapa pun, seperti coretan di buku besar dulu. Saldo boleh *dilihat*, tetapi hanya boleh *berubah* lewat transaksi resmi (setor dan tarik di tugas berikutnya).

    *Dalam kode:* `Rekening` adalah cetakan, dan setiap nasabah adalah satu object. Nomor dan nama menjadi field publik. Saldo menjadi field privat `#saldo` yang dibuka lewat getter `saldo`, jadi bisa dibaca tetapi tidak bisa ditulis. Ringkasan satu baris adalah method `info()`.
  ]
  - `constructor(nomor, pemilik, saldoAwal = 0)`. Input: `nomor` string, `pemilik` string, `saldoAwal` number.
  - `nomor` dan `pemilik` disimpan sebagai field publik. Saldo disimpan di field *privat* `#saldo`.
  - `get saldo()`. Output: number, isi `#saldo`. Saldo hanya bisa dibaca dari luar, tidak bisa diubah langsung.
  - `info()`. Output: string format `<nomor> a.n. <pemilik>: saldo <saldo>`.
  - Contoh:
    - `new Rekening("1001", "Ani", 500000)` menghasilkan object dengan `nomor = "1001"`, `pemilik = "Ani"`, dan `#saldo = 500000`.
    - `new Rekening("3001", "Cici")` tanpa argumen ketiga menghasilkan `#saldo = 0`.
    - Untuk object pertama, `info()` menghasilkan `"1001 a.n. Ani: saldo 500000"`, dan `saldo` bernilai `500000`.

  #keluaran[`const ani = new Rekening("1001", "Ani", 500000);` lalu `console.log(ani.info())`][```txt
  1001 a.n. Ani: saldo 500000
  ```]
  #keluaran[`console.log(ani.saldo)`][```txt
  500000
  ```]

+ *Method `setor(nominal)`.*
  #kebutuhan[
    Nasabah datang ke teller membawa uang tunai. Teller mengetik nominalnya, lalu aplikasi menambah saldo dan mencetak struk singkat berisi nominal dan saldo baru. Kadang teller salah ketik, misalnya `0` atau angka minus. Setoran seperti itu harus ditolak dengan pesan yang jelas, dan saldo tidak boleh berubah sedikit pun.

    *Dalam kode:* method `setor(nominal)` memeriksa nominal dulu. Jika tidak valid, method langsung mengembalikan pesan gagal. Jika valid, method menambah `#saldo` lalu mengembalikan teks struk.
  ]
  - Input: `nominal` number. Output: string.
  - Jika `nominal` 0 atau negatif: kembalikan `GAGAL: nominal harus lebih dari 0`, saldo tidak berubah.
  - Selain itu: tambahkan ke saldo, kembalikan `Setor <nominal>, saldo <saldoBaru>`.
  - Contoh (saldo `ani` sebelumnya `500000`):
    - `ani.setor(250000)` menghasilkan `"Setor 250000, saldo 750000"`. Saldo `ani` menjadi `750000`.
    - `ani.setor(0)` menghasilkan `"GAGAL: nominal harus lebih dari 0"`. Saldo tetap `750000`.

  #keluaran[`console.log(ani.setor(250000))`][```txt
  Setor 250000, saldo 750000
  ```]
  #keluaran[`console.log(ani.setor(0))`][```txt
  GAGAL: nominal harus lebih dari 0
  ```]

+ *Method `tarik(nominal)`.*
  #kebutuhan[
    Nasabah ingin mengambil uang tunai. Selain salah ketik seperti di setoran, ada aturan penting: nasabah tidak boleh mengambil lebih dari saldonya, karena bank tidak memberi utang. Jika saldo kurang, teller perlu tahu sisa saldo nasabah, supaya bisa menawarkan nominal yang lebih kecil.

    *Dalam kode:* method `tarik(nominal)` punya dua pemeriksaan berurutan sebelum `#saldo` dikurangi. Pesan gagal kedua menyebut sisa saldo.
  ]
  - Input: `nominal` number. Output: string.
  - Cek berurutan, kembalikan pesan pertama yang cocok:
    + `nominal` 0 atau negatif: `GAGAL: nominal harus lebih dari 0`
    + `nominal` lebih besar dari saldo: `GAGAL: saldo tidak cukup (sisa <saldo>)`
  - Jika lolos: kurangi saldo, kembalikan `Tarik <nominal>, saldo <saldoBaru>`.
  - Contoh (saldo `ani` sebelumnya `750000`, dari Beginner 2):
    - `ani.tarik(100000)` menghasilkan `"Tarik 100000, saldo 650000"`. Saldo `ani` menjadi `650000`.
    - `ani.tarik(900000)`: `900000` lebih besar dari `650000`, jadi hasilnya `"GAGAL: saldo tidak cukup (sisa 650000)"`. Saldo tetap.

  #keluaran[`console.log(ani.tarik(100000))`][```txt
  Tarik 100000, saldo 650000
  ```]
  #keluaran[`console.log(ani.tarik(900000))`][```txt
  GAGAL: saldo tidak cukup (sisa 650000)
  ```]
  #keluaran[`console.log(ani.tarik(-5))`][```txt
  GAGAL: nominal harus lebih dari 0
  ```]

+ *(jelaskan)* Temanmu sesama programmer sedang menguji aplikasi. Supaya cepat, dia ingin "mengisi saldo" rekening percobaan langsung, tanpa lewat setor. Dia menulis kode ini di luar class. Jalankan di `cobaSendiri()` atau file terpisah.
  ```js
  const r = new Rekening("9001", "Tes", 0);
  r.saldo = 1000000;
  ```
  - Tulis pesan error lengkapnya.
  - Mengapa saldo sengaja dibuat tidak bisa diubah langsung? Apa yang bisa terjadi di aplikasi bank jika `saldo` adalah field publik biasa?

#level("Intermediate", "0.3")

+ *Class `Tabungan`.*
  #kebutuhan[
    Bank meluncurkan produk baru bernama Tabungan. Tabungan sama persis dengan rekening biasa (punya saldo, bisa setor, bisa tarik), ditambah satu hal: setiap akhir bulan nasabah mendapat bunga sekian persen dari saldonya. Bank tidak mau aturan setor dan tarik ditulis dua kali. Jika suatu hari aturan tarik berubah, programmer cukup mengubah satu tempat. Bunga dibulatkan ke bawah, karena bank tidak membayar pecahan rupiah.

    *Dalam kode:* `Tabungan` diturunkan dari `Rekening` dengan `extends`, jadi `setor`, `tarik`, `saldo`, dan `info` otomatis ikut. `Tabungan` hanya menambah field `bungaPersen` dan method `tambahBunga()`.
  ]
  - `class Tabungan extends Rekening`.
  - `constructor(nomor, pemilik, saldoAwal, bungaPersen)`. Teruskan tiga parameter pertama ke `Rekening` dengan `super`. Simpan `bungaPersen` (number) sebagai field publik.
  - `tambahBunga()`. Output: string format `Bunga <bunga>, saldo <saldoBaru>`.
    - `<bunga>`: `bungaPersen` persen dari saldo, dibulatkan ke bawah.
    - Bunga masuk ke saldo. `#saldo` milik `Rekening` tidak bisa diakses dari `Tabungan`, jadi pakai method yang sudah ada.
  - Contoh:
    - `new Tabungan("2001", "Budi", 1000000, 2)` menghasilkan object dengan `nomor = "2001"`, `pemilik = "Budi"`, `#saldo = 1000000` (diisi lewat `super`), dan `bungaPersen = 2`.
    - `tambahBunga()`: 2% dari `1000000` adalah `20000`, jadi hasilnya `"Bunga 20000, saldo 1020000"`.
    - `budi.tarik(20000)` langsung jalan tanpa ditulis ulang di `Tabungan`, karena diwarisi dari `Rekening`.

  #keluaran[`const budi = new Tabungan("2001", "Budi", 1000000, 2);` lalu `console.log(budi.tambahBunga())`][```txt
  Bunga 20000, saldo 1020000
  ```]
  #keluaran[`console.log(budi.tarik(20000))`][```txt
  Tarik 20000, saldo 1000000
  ```]

+ *Menimpa `info()` di `Tabungan`.*
  #kebutuhan[
    Saat teller melihat ringkasan rekening Tabungan, teller juga ingin tahu besar bunganya, supaya bisa menjelaskan ke nasabah. Ringkasan rekening biasa harus tetap seperti semula.

    *Dalam kode:* `Tabungan` menulis `info()` versinya sendiri (menimpa). Isinya memakai hasil `info()` milik `Rekening`, lalu menambahkan keterangan bunga di belakangnya.
  ]
  - Output: string format `<infoRekening>, bunga <bungaPersen>%`. `<infoRekening>` adalah hasil `info()` milik `Rekening`.
  - Jangan menyalin isi `info()` milik `Rekening`. Panggil versi induknya.
  - `info()` milik `Rekening` sendiri tidak berubah.
  - Contoh (saldo `budi` sekarang `1000000`): `info()` induk menghasilkan `"2001 a.n. Budi: saldo 1000000"`. `info()` milik `Tabungan` menambahkan `", bunga 2%"` di belakangnya. `ani.info()` tetap memakai format lama.

  #keluaran[`console.log(budi.info())`][```txt
  2001 a.n. Budi: saldo 1000000, bunga 2%
  ```]
  #keluaran[`console.log(ani.info())`][```txt
  1001 a.n. Ani: saldo 650000
  ```]

+ *Kode temanmu: `setorBanyak(rek, daftarNominal)`.*
  #kebutuhan[
    Seorang pedagang pasar menyetor hasil jualan beberapa hari sekaligus. Teller mengetik daftar nominal per hari, dan aplikasi menyetor semuanya ke rekening pedagang itu, satu per satu, lalu menampilkan saldo akhir. Temanmu sudah menulis fiturnya, tetapi aplikasi error saat dijalankan.

    *Dalam kode:* fungsi `setorBanyak` menerima satu object rekening dan satu array nominal. Setiap nominal disetor lewat method `setor` milik rekening itu, lalu fungsi mengembalikan saldo akhir.
  ]
  - Output yang benar: number, saldo `rek` setelah semua nominal di `daftarNominal` disetor.
  - Contoh: `rek` adalah `new Rekening("3001", "Cici")` dengan saldo `0`, dan `daftarNominal` adalah `[50000, 20000, 30000]`. Ketiganya disetor satu per satu, jadi hasilnya `100000`.
  - Masalah: setelah `setor` di Beginner 2 selesai, fungsi ini melempar `TypeError: Cannot read properties of undefined (reading '#saldo')`.
  - *(jelaskan)* Method `setor` jalan normal jika dipanggil `rek.setor(50000)`. Mengapa error ketika `rek.setor` diberikan ke `forEach` sebagai callback? Lalu perbaiki.

  #keluaran[`console.log(setorBanyak(new Rekening("3001", "Cici"), [50000, 20000, 30000]))`][```txt
  100000
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Class `Bank`.*
  #kebutuhan[
    Bank ingin satu tempat untuk mengelola semua rekening. Ada empat fitur yang diminta:
    - membuka rekening baru dan mendaftarkannya ke bank,
    - mencari rekening lewat nomornya, seperti teller mengetik nomor rekening di layar,
    - mentransfer uang dari satu rekening ke rekening lain,
    - melihat total uang nasabah yang disimpan bank, untuk laporan harian.
    Transfer harus aman. Jika nomor rekening salah atau saldo pengirim kurang, tidak boleh ada uang yang berpindah, hilang, atau tercipta. Teller juga harus tahu alasan transfer gagal.

    *Dalam kode:* `Bank` adalah class yang menyimpan banyak object `Rekening` di field array `daftar`. Setiap fitur di atas menjadi satu method `Bank`.
  ]
  - `constructor()`: field `daftar` berisi array kosong.
  - `buka(rek)`: masukkan `rek` ke `daftar`. Output: `Rekening <nomor> dibuka`.
  - `cari(nomor)`: Output: `Rekening` yang `nomor`-nya sama, atau `undefined`.
  - `transfer(dariNomor, keNomor, nominal)`. Output: string. Cek berurutan:
    + rekening asal tidak ada: `GAGAL: rekening <dariNomor> tidak ditemukan`
    + rekening tujuan tidak ada: `GAGAL: rekening <keNomor> tidak ditemukan`
    + penarikan dari rekening asal gagal: kembalikan pesan `GAGAL` dari `tarik` apa adanya
    + jika lolos, setor ke tujuan dan kembalikan `Transfer <nominal> dari <dariNomor> ke <keNomor> berhasil`
  - `totalSaldo()`: Output: number, jumlah saldo semua rekening.
  - Contoh (sebelum transfer, saldo `ani` `650000` dan saldo `budi` `1000000`):
    - Setelah `bank.buka(ani)` dan `bank.buka(budi)`, `daftar` berisi `[ani, budi]`.
    - `bank.cari("1001")` mengembalikan object `ani`. `bank.cari("9999")` mengembalikan `undefined`.
    - `bank.transfer("1001", "2001", 150000)`: saldo `ani` menjadi `500000`, saldo `budi` menjadi `1150000`.
    - `bank.totalSaldo()`: `500000 + 1150000` adalah `1650000`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`. Untuk setiap method `Bank`, tulis langkahnya dan method array atau method `Rekening` yang dipakai. Jelaskan juga: mengapa `transfer` memanggil `tarik` dan `setor`, bukan mengubah saldo sendiri? Dan mengapa urutannya `tarik` dulu baru `setor`?
  + *(opsional)* Tulis kodenya.

  #keluaran[`const bank = new Bank();` lalu `console.log(bank.buka(ani))`][```txt
  Rekening 1001 dibuka
  ```]
  #keluaran[`console.log(bank.buka(budi))`][```txt
  Rekening 2001 dibuka
  ```]
  #keluaran[`console.log(bank.transfer("1001", "2001", 150000))`][```txt
  Transfer 150000 dari 1001 ke 2001 berhasil
  ```]
  #keluaran[`console.log(bank.transfer("1001", "9999", 1000))`][```txt
  GAGAL: rekening 9999 tidak ditemukan
  ```]
  #keluaran[`console.log(bank.transfer("1001", "2001", 999999))`][```txt
  GAGAL: saldo tidak cukup (sisa 500000)
  ```]
  #keluaran[`` console.log(`${ani.saldo} ${budi.saldo} ${bank.totalSaldo()}`) ``][```txt
  500000 1150000 1650000
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-js5.js`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-js5.js coba`.
  - Jalankan `npm run selesai -- --durasi "..." --macet "..."`, lalu minta asisten memeriksa.
]
