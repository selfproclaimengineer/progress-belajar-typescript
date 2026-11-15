#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal Modul 6", judul: "Modules dan Standard Library")

= Tugas

Toko Makmur adalah supermarket kecil. Program mesin kasirnya ditulis programmer lama dalam satu file panjang. Akibatnya, setiap kali pemilik ingin mengubah satu aturan, misalnya cara membulatkan total, programmer harus mencari di ratusan baris. Pemilik juga berencana membuat aplikasi pesan-antar, dan ingin aplikasi itu memakai aturan harga yang sama dengan mesin kasir.

Kamu diminta memisahkan semua aturan perhitungan kasir ke satu modul, `kasir.js`. Mesin kasir (file utama `soal-js6.js`) meng-import fungsi dari modul itu, lalu memanggilnya. Nanti aplikasi pesan-antar cukup meng-import modul yang sama. Data `produk` ada di bagian `DATA` file utama.

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan toko dan mengapa. Baris *Dalam kode* di kotak itu menunjukkan bagian kode yang menjawab kebutuhan tersebut. Spesifikasi teknis (format output persis) ada di poin-poin setelahnya.

#figure(
  table(
    columns: 4,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*id*], [*nama*], [*kategori*], [*harga*],
    [K01], [Beras 5kg], [Sembako], [78000],
    [K02], [Telur 1kg], [Sembako], [28000],
    [K03], [Kopi Sachet], [Minuman], [1500],
    [K04], [Sabun Batang], [Perawatan], [4500],
    [K05], [Teh Botol], [Minuman], [5000],
  ),
  caption: [Data `produk`. Tipe: `id`, `nama`, `kategori` string; `harga` number.],
)

Pembagian kerja dua file:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*File*], [*Isi*],
  [`Jawaban/kasir.js`], [Semua fungsi yang di-`export`: Beginner 1–3, Intermediate 1–3, dan `buatStruk` (Advanced).],
  [`Jawaban/soal-js6.js`], [`import`, data, `cobaTambah` (Intermediate 2), `cetakStruk` (Advanced), jawaban *(jelaskan)*, dan `PEMANGGILAN`.],
)

#perhatian[
  1. Salin `Soal/starter.js` ke `Jawaban/soal-js6.js`, dan `Soal/kasir.js` ke `Jawaban/kasir.js`. Kedua file harus berada di folder yang sama.
  2. Lengkapi fungsi bertanda `TODO`. Jangan mengubah baris `import`, bagian `DATA`, dan `PEMANGGILAN`.
  3. Jalankan `node Jawaban/soal-js6.js`. Kotak *Output dari* `console.log(...)` di bawah setiap tugas menunjukkan baris `console.log` yang mencetaknya dan output yang harus keluar persis.
  4. Soal bertanda *(jelaskan)* dijawab sebagai komentar di `soal-js6.js`, di bawah baris `// JAWABAN ...`.
  5. Semua number adalah bilangan bulat, kecuali disebut lain.
]

#level("Beginner", "0.3")

+ *Format rupiah* (di `kasir.js`).
  #kebutuhan[
    Layar harga dan struk sekarang menampilkan angka mentah seperti `1250000`. Pembeli sulit membacanya, dan pernah ada pembeli yang mengira harganya seratus dua puluh lima ribu. Pemilik ingin semua harga tampil dalam format rupiah dengan pemisah ribuan titik, tanpa spasi setelah `Rp`, seperti di label rak.

    *Dalam kode:* satu fungsi `formatRupiah(n)` di `kasir.js` yang di-export, supaya layar, struk, dan aplikasi pesan-antar memakai format yang sama. Pemisah ribuan tidak ditulis sendiri, tetapi memakai format angka bawaan JavaScript untuk Indonesia.
  ]
  - Fungsi: `formatRupiah(n)`. Input: `n` number.
  - Output: string `Rp` disambung angka dengan pemisah ribuan titik, tanpa spasi.
  - Wajib memakai `Intl.NumberFormat` dengan locale `"id-ID"`.
  - Contoh: `formatRupiah(1250000)` menghasilkan `"Rp1.250.000"`. `formatRupiah(500)` menghasilkan `"Rp500"`, tanpa titik karena di bawah seribu.

  #keluaran[`console.log(formatRupiah(1250000))`][```txt
  Rp1.250.000
  ```]
  #keluaran[`console.log(formatRupiah(500))`][```txt
  Rp500
  ```]

+ *Pembulatan harga* (di `kasir.js`).
  #kebutuhan[
    Toko tidak menyediakan uang receh di bawah Rp500, jadi kasir sering tidak bisa memberi kembalian yang pas. Pemilik memutuskan total belanja dibulatkan *ke atas* ke kelipatan 500 terdekat. Total yang sudah pas kelipatan 500 tidak diubah. Pemilik juga ingin bisa mengganti kelipatannya, misalnya menjadi 100 atau 1000, tanpa meminta programmer mengubah kode.

    *Dalam kode:* fungsi `bulatkanKe(n, kelipatan)` di `kasir.js`. Kelipatan dibuat parameter, bukan angka 500 yang ditulis mati di dalam fungsi.
  ]
  - Fungsi: `bulatkanKe(n, kelipatan)`. Input: `n` number, `kelipatan` number lebih dari 0.
  - Output: number, kelipatan `kelipatan` terkecil yang tidak kurang dari `n`. Jika `n` sudah kelipatannya, kembalikan `n`.
  - Wajib memakai method `Math`.
  - Contoh:
    - `bulatkanKe(12340, 500)`: `12340` ada di antara `12000` dan `12500`, dan dibulatkan ke atas, jadi hasilnya `12500`.
    - `bulatkanKe(12500, 500)` menghasilkan `12500`, karena sudah kelipatan 500.
    - `bulatkanKe(120, 100)` menghasilkan `200`.

  #keluaran[`console.log(bulatkanKe(12340, 500))`][```txt
  12500
  ```]
  #keluaran[`console.log(bulatkanKe(12500, 500))`][```txt
  12500
  ```]

+ *Kategori unik* (di `kasir.js`).
  #kebutuhan[
    Layar kasir punya deretan tombol filter per kategori, misalnya "Sembako" dan "Minuman". Saat ini tombol itu ditulis manual, jadi setiap ada kategori baru, programmer harus mengubah kode. Pemilik ingin daftar tombol dibuat otomatis dari data produk. Setiap kategori muncul tepat sekali, dengan urutan sesuai produk pertama yang memakai kategori itu.

    *Dalam kode:* fungsi `kategoriUnik(produk)` mengembalikan array nama kategori tanpa duplikat.
  ]
  - Fungsi: `kategoriUnik(produk)`. Input: `produk` array `Produk`.
  - Output: array string, kategori tanpa duplikat, urut sesuai kemunculan pertama.
  - Wajib memakai `Set`, tanpa `for` dan tanpa `includes`.
  - Contoh: kolom kategori kelima produk adalah `Sembako`, `Sembako`, `Minuman`, `Perawatan`, `Minuman`. Hasilnya `["Sembako", "Minuman", "Perawatan"]`.

  #keluaran[`console.log(kategoriUnik(produk).join(", "))`][```txt
  Sembako, Minuman, Perawatan
  ```]

+ *(jelaskan)* Temanmu sedang menyambungkan mesin kasir ke modul `kasir.js`. Dia menulis baris ini di file utama, lalu menjalankannya. Coba di file terpisah dalam folder yang sama dengan `kasir.js`.
  ```js
  console.log("mulai");
  import { formatRp } from "./kasir.js";
  ```
  - Tulis pesan error lengkapnya.
  - Mengapa `mulai` tidak tercetak, padahal `console.log` ditulis sebelum `import`?
  - Tulis baris `import` yang benar.

#level("Intermediate", "0.3")

+ *Index produk* (di `kasir.js`).
  #kebutuhan[
    Kasir memindai barcode, dan setiap pindaian harus langsung menemukan produknya. Cabang yang lebih besar punya ribuan produk. Jika produk dicari satu per satu dari depan, layar terasa lambat saat antrean panjang. Pemilik ingin pencarian tetap cepat berapa pun jumlah produknya.

    *Dalam kode:* fungsi `buatIndex(produk)` dijalankan *sekali* saat mesin kasir menyala. Fungsi ini membuat `Map` dari id ke object produk. Setelah itu, setiap pindaian cukup memanggil `index.get(id)`.
  ]
  - Fungsi: `buatIndex(produk)`. Input: `produk` array `Produk`.
  - Output: `Map` dengan key `id` dan value object produknya.
  - Contoh:
    - `index.get("K03")` mengembalikan object `{ id: "K03", nama: "Kopi Sachet", kategori: "Minuman", harga: 1500 }`.
    - `index.get("X99")` mengembalikan `undefined`, seperti barcode yang tidak terdaftar.
    - `index.size` bernilai `5`, satu entri per produk.
  - *(jelaskan)* Di Modul 3, produk dicari dengan `produk.find(...)`. Jika data berisi 10.000 produk dan keranjang berisi 50 item, berapa kira-kira perbandingan id yang dilakukan `find`, dibandingkan dengan `index.get(...)`? Mengapa `Map` lebih cepat?

  #keluaran[`const index = buatIndex(produk);` lalu `console.log(index.size)`][```txt
  5
  ```]
  #keluaran[`console.log(index.get("K03").nama)`][```txt
  Kopi Sachet
  ```]
  #keluaran[`console.log(index.get("X99"))`][```txt
  undefined
  ```]

+ *Validasi jumlah barang.*
  #kebutuhan[
    Saat membeli banyak barang yang sama, kasir mengetik jumlahnya. Jumlah harus bilangan bulat positif. Tidak ada setengah batang sabun, dan `0` atau angka minus pasti salah ketik. Isian dari layar kadang terbaca sebagai teks, misalnya `"2"`, dan teks seperti itu juga ditolak supaya perhitungan selalu memakai number. Jika jumlah ditolak, kasir harus melihat pesan yang jelas, dan program tidak boleh berhenti.

    *Dalam kode:* `validasiQty` di `kasir.js` memeriksa jumlah dan melempar `Error` jika tidak valid. `cobaTambah` di file utama memanggilnya, menangkap error itu, dan mengubahnya menjadi teks `OK` atau `GAGAL` untuk layar.
  ]
  - Di `kasir.js`: `validasiQty(qty)`. Input: `qty` nilai apa saja. Jika `qty` bukan bilangan bulat atau 0 atau negatif, *lempar* `Error` dengan pesan `qty harus bilangan bulat positif`. Jika valid, kembalikan `qty`.
  - Di `soal-js6.js`: `cobaTambah(qty)`. Panggil `validasiQty` di dalam `try...catch`. Output: `OK: <qty>` jika valid, atau `GAGAL: <pesanError>` jika tertangkap.
  - String `"2"` termasuk tidak valid, karena bukan number.
  - Contoh:
    - `validasiQty(3)` mengembalikan `3`. `validasiQty(2.5)` melempar `Error`, jadi tidak mengembalikan apa pun.
    - `cobaTambah(3)` menghasilkan `"OK: 3"`. `cobaTambah(0)` menghasilkan `"GAGAL: qty harus bilangan bulat positif"`.

  #keluaran[`console.log([3, 0, 2.5, "2"].map(cobaTambah).join("\n"))`][```txt
  OK: 3
  GAGAL: qty harus bilangan bulat positif
  GAGAL: qty harus bilangan bulat positif
  GAGAL: qty harus bilangan bulat positif
  ```]

+ *Kode temanmu: `formatTanggal(tgl)`* (di `kasir.js`).
  #kebutuhan[
    Setiap struk mencetak tanggal transaksi dalam urutan Indonesia: hari, bulan, tahun. Hari dan bulan selalu dua digit, supaya kolom tanggal di laporan bulanan rata. Temanmu sudah menulis fiturnya, tetapi struk hari ini mencetak bulan yang salah dan tidak rata.

    *Dalam kode:* fungsi `formatTanggal(tgl)` menerima object `Date` dan mengembalikan string tanggal.
  ]
  - Output yang benar: string format `DD-MM-YYYY`. Hari dan bulan selalu 2 digit.
  - Contoh: 5 November 2026 dibuat dengan `new Date(2026, 10, 5)` dan harus tercetak `"05-11-2026"`. 31 Januari 2026 dibuat dengan `new Date(2026, 0, 31)` dan harus tercetak `"31-01-2026"`.
  - Masalah: `formatTanggal(new Date(2026, 10, 5))` menghasilkan `5-10-2026`.
  - *(jelaskan)* Mengapa bulannya `10`, padahal tanggal itu bulan November? Mengapa `new Date(2026, 10, 5)` ditulis dengan `10` untuk November? Lalu perbaiki.

  #keluaran[`console.log(formatTanggal(new Date(2026, 10, 5)))`][```txt
  05-11-2026
  ```]
  #keluaran[`console.log(formatTanggal(new Date(2026, 0, 31)))`][```txt
  31-01-2026
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Struk belanja.*
  #kebutuhan[
    Setelah semua barang dipindai, kasir menekan tombol bayar, dan struk tercetak. Struk berisi tanggal, satu baris per barang (nama, jumlah, subtotal), lalu total belanja. Jika ada barang yang tidak terdaftar atau jumlahnya salah, struk tidak boleh tercetak setengah jadi. Kasir cukup melihat satu pesan gagal yang menyebut masalahnya, lalu memperbaiki keranjang.

    *Dalam kode:* `buatStruk` di `kasir.js` menghasilkan teks struk. `cetakStruk` di file utama menampilkan struk itu, atau pesan gagal jika ada masalah.
  ]
  - Di `kasir.js`: `buatStruk(keranjang, index, tanggal)`.
    - Input: `keranjang` array `{ id: string, qty: number }`, `index` hasil `buatIndex`, `tanggal` object `Date`.
    - Untuk setiap item, sesuai urutan: jika produk tidak ada di `index`, lempar `Error` dengan pesan `produk <id> tidak ditemukan`. Lalu validasi `qty` dengan `validasiQty`.
    - Output jika semua valid: string beberapa baris, dipisah `"\n"`:
      ```text
      Struk <tanggalDD-MM-YYYY>
      <nama> x<qty> = <subtotalRupiah>      (satu baris per item)
      Total: <totalRupiah>
      ```
  - Di `soal-js6.js`: `cetakStruk(keranjang, index, tanggal)`. Panggil `buatStruk` di dalam `try...catch`. Jika tertangkap, kembalikan `GAGAL: <pesanError>`.
  - Contoh:
    - Item `{ id: "K02", qty: 2 }`: Telur 1kg seharga `28000`, dua buah, subtotal `56000`. Barisnya `Telur 1kg x2 = Rp56.000`.
    - Keranjang `[{ id: "K01", qty: 1 }, { id: "X99", qty: 1 }]`: `X99` tidak ada di `index`, jadi hasil `cetakStruk` hanya `"GAGAL: produk X99 tidak ditemukan"`. Baris untuk `K01` tidak ikut tercetak.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`. Tulis langkah-langkah `buatStruk`, fungsi dari Beginner dan Intermediate yang dipakai di setiap langkah, dan bentuk data di setiap langkah. Jelaskan juga: mengapa error *dilempar* di `kasir.js` tetapi *ditangkap* di `soal-js6.js`, bukan ditangkap di `kasir.js` sendiri?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(cetakStruk([{ id: "K01", qty: 1 }, { id: "K02", qty: 2 }, { id: "K03", qty: 10 }], index, tanggal))`][```txt
  Struk 05-11-2026
  Beras 5kg x1 = Rp78.000
  Telur 1kg x2 = Rp56.000
  Kopi Sachet x10 = Rp15.000
  Total: Rp149.000
  ```]
  #keluaran[`console.log(cetakStruk([{ id: "K01", qty: 1 }, { id: "X99", qty: 1 }], index, tanggal))`][```txt
  GAGAL: produk X99 tidak ditemukan
  ```]
  #keluaran[`console.log(cetakStruk([{ id: "K05", qty: 0 }], index, tanggal))`][```txt
  GAGAL: qty harus bilangan bulat positif
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-js6.js` dan `Jawaban/kasir.js`. Jawaban *(jelaskan)* ditulis sebagai komentar di `soal-js6.js`.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada `soal-js6.js`. Jalankan dengan `node Jawaban/soal-js6.js coba`.
  - Jalankan `npm run selesai -- --durasi "..." --macet "..."`, lalu minta asisten memeriksa.
]
