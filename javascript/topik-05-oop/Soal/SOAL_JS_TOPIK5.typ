#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "Soal Modul 5", judul: "Object-Oriented Programming")

= Tugas

Kamu membuat sistem rekening untuk sebuah bank kecil. Ada tiga class: `Rekening`, `Tabungan` (turunan `Rekening` yang punya bunga), dan `Bank` yang menyimpan banyak rekening.

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
  - `constructor(nomor, pemilik, saldoAwal = 0)`. Input: `nomor` string, `pemilik` string, `saldoAwal` number.
  - `nomor` dan `pemilik` disimpan sebagai field publik. Saldo disimpan di field *privat* `#saldo`.
  - `get saldo()`. Output: number, isi `#saldo`. Saldo hanya bisa dibaca dari luar, tidak bisa diubah langsung.
  - `info()`. Output: string format `<nomor> a.n. <pemilik>: saldo <saldo>`.

  #keluaran[`const ani = new Rekening("1001", "Ani", 500000);` lalu `console.log(ani.info())`][```txt
  1001 a.n. Ani: saldo 500000
  ```]
  #keluaran[`console.log(ani.saldo)`][```txt
  500000
  ```]

+ *Method `setor(nominal)`.*
  - Input: `nominal` number. Output: string.
  - Jika `nominal` 0 atau negatif: kembalikan `GAGAL: nominal harus lebih dari 0`, saldo tidak berubah.
  - Selain itu: tambahkan ke saldo, kembalikan `Setor <nominal>, saldo <saldoBaru>`.

  #keluaran[`console.log(ani.setor(250000))`][```txt
  Setor 250000, saldo 750000
  ```]
  #keluaran[`console.log(ani.setor(0))`][```txt
  GAGAL: nominal harus lebih dari 0
  ```]

+ *Method `tarik(nominal)`.*
  - Input: `nominal` number. Output: string.
  - Cek berurutan, kembalikan pesan pertama yang cocok:
    + `nominal` 0 atau negatif: `GAGAL: nominal harus lebih dari 0`
    + `nominal` lebih besar dari saldo: `GAGAL: saldo tidak cukup (sisa <saldo>)`
  - Jika lolos: kurangi saldo, kembalikan `Tarik <nominal>, saldo <saldoBaru>`.

  #keluaran[`console.log(ani.tarik(100000))`][```txt
  Tarik 100000, saldo 650000
  ```]
  #keluaran[`console.log(ani.tarik(900000))`][```txt
  GAGAL: saldo tidak cukup (sisa 650000)
  ```]
  #keluaran[`console.log(ani.tarik(-5))`][```txt
  GAGAL: nominal harus lebih dari 0
  ```]

+ *(jelaskan)* Temanmu ingin "mengisi saldo cepat" dan menulis kode ini di luar class. Jalankan di `cobaSendiri()` atau file terpisah.
  ```js
  const r = new Rekening("9001", "Tes", 0);
  r.saldo = 1000000;
  ```
  - Tulis pesan error lengkapnya.
  - Mengapa saldo sengaja dibuat tidak bisa diubah langsung? Apa yang bisa terjadi di aplikasi bank jika `saldo` adalah field publik biasa?

#level("Intermediate", "0.3")

+ *Class `Tabungan`.*
  - `class Tabungan extends Rekening`.
  - `constructor(nomor, pemilik, saldoAwal, bungaPersen)`. Teruskan tiga parameter pertama ke `Rekening` dengan `super`. Simpan `bungaPersen` (number) sebagai field publik.
  - `tambahBunga()`. Output: string format `Bunga <bunga>, saldo <saldoBaru>`.
    - `<bunga>`: `bungaPersen` persen dari saldo, dibulatkan ke bawah.
    - Bunga masuk ke saldo. `#saldo` milik `Rekening` tidak bisa diakses dari `Tabungan`, jadi pakai method yang sudah ada.

  #keluaran[`const budi = new Tabungan("2001", "Budi", 1000000, 2);` lalu `console.log(budi.tambahBunga())`][```txt
  Bunga 20000, saldo 1020000
  ```]
  #keluaran[`console.log(budi.tarik(20000))`][```txt
  Tarik 20000, saldo 1000000
  ```]

+ *Menimpa `info()` di `Tabungan`.*
  - Output: string format `<infoRekening>, bunga <bungaPersen>%`. `<infoRekening>` adalah hasil `info()` milik `Rekening`.
  - Jangan menyalin isi `info()` milik `Rekening`. Panggil versi induknya.
  - `info()` milik `Rekening` sendiri tidak berubah.

  #keluaran[`console.log(budi.info())`][```txt
  2001 a.n. Budi: saldo 1000000, bunga 2%
  ```]
  #keluaran[`console.log(ani.info())`][```txt
  1001 a.n. Ani: saldo 650000
  ```]

+ *Kode temanmu: `setorBanyak(rek, daftarNominal)`.*
  - Output yang benar: number, saldo `rek` setelah semua nominal di `daftarNominal` disetor.
  - Masalah: setelah `setor` di Beginner 2 selesai, fungsi ini melempar `TypeError: Cannot read properties of undefined (reading '#saldo')`.
  - *(jelaskan)* Method `setor` jalan normal jika dipanggil `rek.setor(50000)`. Mengapa error ketika `rek.setor` diberikan ke `forEach` sebagai callback? Lalu perbaiki.

  #keluaran[`console.log(setorBanyak(new Rekening("3001", "Cici"), [50000, 20000, 30000]))`][```txt
  100000
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Class `Bank`.*
  - `constructor()`: field `daftar` berisi array kosong.
  - `buka(rek)`: masukkan `rek` ke `daftar`. Output: `Rekening <nomor> dibuka`.
  - `cari(nomor)`: Output: `Rekening` yang `nomor`-nya sama, atau `undefined`.
  - `transfer(dariNomor, keNomor, nominal)`. Output: string. Cek berurutan:
    + rekening asal tidak ada: `GAGAL: rekening <dariNomor> tidak ditemukan`
    + rekening tujuan tidak ada: `GAGAL: rekening <keNomor> tidak ditemukan`
    + penarikan dari rekening asal gagal: kembalikan pesan `GAGAL` dari `tarik` apa adanya
    + jika lolos, setor ke tujuan dan kembalikan `Transfer <nominal> dari <dariNomor> ke <keNomor> berhasil`
  - `totalSaldo()`: Output: number, jumlah saldo semua rekening.

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
