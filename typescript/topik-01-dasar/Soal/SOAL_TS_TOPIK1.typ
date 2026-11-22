#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal TypeScript Modul 1", judul: "Dasar TypeScript")

= Tugas

Apotek Sehat Selalu memakai aplikasi kasir yang ditulis dengan JavaScript. Bulan lalu, aplikasi itu menagih seorang pembeli Rp150.001.000 untuk obat seharga Rp15.000. Penyebabnya, harga dari form terbaca sebagai teks `"15000"`, sehingga `"15000" + 1000` disambung menjadi `"150001000"`, bukan dijumlah. Tidak ada yang tahu sampai pembeli itu komplain.

Pemilik apotek ingin aplikasi kasir berikutnya ditulis dengan TypeScript, supaya kesalahan seperti itu ketahuan *sebelum* aplikasi dipakai melayani pembeli. Kamu diminta memindahkan beberapa fungsi kasir ke TypeScript dan menambah fitur baru.

#figure(
  table(
    columns: 3,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*kode*], [*nama obat*], [*harga*],
    [OB01], [Paracetamol], [12000],
    [OB02], [Amoxicillin], [35000],
    [OB03], [Vitamin C], [8500],
  ),
  caption: [Data `daftarHarga`. Disimpan sebagai `Map` dengan key kode obat dan value harga.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan apotek dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Kerjakan di `Jawaban/soal-ts1.ts`. File itu sudah disiapkan dari `Soal/starter.ts`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah bagian `DATA` dan `PEMANGGILAN`.
  3. *Cek tipe dulu* dengan `npx tsc --noEmit`, lalu *jalankan* dengan `node Jawaban/soal-ts1.ts`. Keduanya dijalankan dari folder topik ini.
  4. Saat pertama dibuka, `tsc` sudah menampilkan sepuluh error `TS7006`. Itu disengaja. Error itu hilang satu per satu saat kamu memberi tipe.
  5. Jawaban dianggap selesai jika `npx tsc --noEmit` tidak menampilkan error *dan* output `node` sama persis dengan kotak *Output dari*.
  6. Jangan memakai `any` di kodemu sendiri. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Beri tipe fungsi lama.* #est(6)
  #kebutuhan[
    Programmer lama menulis `subtotal` dan `formatRupiah` dengan JavaScript. Kedua fungsi itu menerima apa saja, termasuk harga berupa teks, lalu diam-diam menghasilkan angka yang salah. Pemilik ingin kedua fungsi itu *menolak* data bertipe salah, tetapi cara hitungnya tidak boleh berubah karena sudah dipakai di banyak tempat.

    *Dalam kode:* tambahkan anotasi tipe pada parameter dan nilai kembalian kedua fungsi. Isi fungsinya tidak diubah sama sekali.
  ]
  - `subtotal(harga, qty)`. Input: `harga` number, `qty` number. Output: number.
  - `formatRupiah(n)`. Input: `n` number. Output: string.
  - Hanya tambahkan anotasi tipe. Isi kedua fungsi tidak diubah.
  - Setelah diberi tipe, `tsc` tidak lagi menampilkan `TS7006` untuk kedua fungsi ini. Panggilan `subtotal("12000", 3)` juga harus ditolak `tsc`. Coba di `cobaSendiri()`, lalu hapus lagi.
  - Contoh: `subtotal(12000, 3)` menghasilkan `36000`. `formatRupiah(36000)` menghasilkan `"Rp36.000"`.

  #keluaran[`console.log(subtotal(12000, 3))`][```txt
  36000
  ```]
  #keluaran[`console.log(formatRupiah(subtotal(12000, 3)))`][```txt
  Rp36.000
  ```]

+ *Metode bayar dan biaya admin.* #est(6)
  #kebutuhan[
    Apotek menerima tiga cara bayar: tunai, kartu debit, dan QRIS. Biaya admin bank ditanggung pembeli. Debit dikenai Rp2.500 per transaksi, QRIS dikenai 0,7% dari total dibulatkan ke atas, dan tunai gratis. Dulu kasir pernah mengetik `"qriss"`, dan aplikasi lama diam-diam menganggapnya tunai, sehingga biaya admin tidak tertagih. Pemilik ingin salah ketik nama metode langsung ketahuan sebelum aplikasi dijalankan.

    *Dalam kode:* type `MetodeBayar` berisi tepat tiga pilihan teks. `biayaAdmin` hanya menerima salah satu dari tiga pilihan itu, jadi teks lain ditolak `tsc`.
  ]
  - Ganti `type MetodeBayar = string;` di starter dengan literal union tiga nilai: `"tunai"`, `"debit"`, dan `"qris"`.
  - `biayaAdmin(metode, total)`. Input: `metode` `MetodeBayar`, `total` number. Output: number.
    - `"debit"`: `2500`.
    - `"qris"`: 0,7% dari `total`, dibulatkan ke atas.
    - `"tunai"`: `0`.
  - `biayaAdmin("kartu", 50000)` dan `biayaAdmin("qriss", 50000)` harus ditolak `tsc`.
  - Contoh: `biayaAdmin("qris", 12345)`: 0,7% dari `12345` adalah `86.415`, dibulatkan ke atas menjadi `87`. `biayaAdmin("debit", 50000)` menghasilkan `2500`.

  #keluaran[`console.log(biayaAdmin("tunai", 50000), biayaAdmin("debit", 50000), biayaAdmin("qris", 50000))`][```txt
  0 2500 350
  ```]
  #keluaran[`console.log(biayaAdmin("qris", 12345))`][```txt
  87
  ```]

+ *(jelaskan)* Pemilik ingin tahu apakah TypeScript benar-benar mencegah bug Rp150.001.000. Simpan kode berikut di file baru `Jawaban/coba-b3.ts`.
  ```ts
  const harga: number = "15000";
  console.log(harga + 1000);
  ```
  Jalankan `node Jawaban/coba-b3.ts`, lalu `npx tsc --noEmit`. Setelah selesai, hapus file `coba-b3.ts`, supaya `tsc` kembali bersih.
  - Tulis output `node` dan pesan error `tsc`-nya.
  - Mengapa `node` tetap menjalankan kode itu dan mencetak `150001000`, padahal ada anotasi `number`?
  - Di alur kerja apotek, kapan `tsc` harus dijalankan, dan apa untungnya dibanding menunggu komplain pembeli?

#level("Intermediate", "0.3")

+ *Cek harga obat.* #est(5)
  #kebutuhan[
    Kasir mengetik kode obat untuk melihat harganya. Kadang kode salah ketik, atau obatnya belum terdaftar. Aplikasi lama menampilkan `OB99: RpNaN`, dan kasir bingung. Pemilik ingin kasir melihat pesan `tidak terdaftar`.

    *Dalam kode:* `hargaObat(kode)` mencari harga di `daftarHarga`. TypeScript tahu hasil pencarian bisa kosong (`undefined`), dan tidak mengizinkan hasil itu dipakai sebelum diperiksa.
  ]
  - `hargaObat(kode)`. Input: `kode` string. Output: string `<kode>: <hargaRupiah>`, atau `<kode>: tidak terdaftar`.
  - Pakai `daftarHarga.get(...)` dan `formatRupiah` dari Beginner 1.
  - Contoh: `daftarHarga.get("OB01")` menghasilkan `12000`, jadi hasilnya `"OB01: Rp12.000"`. `daftarHarga.get("OB99")` menghasilkan `undefined`, jadi hasilnya `"OB99: tidak terdaftar"`.

  #keluaran[`console.log(hargaObat("OB01"))`][```txt
  OB01: Rp12.000
  ```]
  #keluaran[`console.log(hargaObat("OB99"))`][```txt
  OB99: tidak terdaftar
  ```]

+ *Aturan promo.* #est(6)
  #kebutuhan[
    Apotek punya dua promo. Member mendapat diskon 5%, dengan potongan dibulatkan ke bawah. Belanja minimal Rp100.000 mendapat voucher potongan Rp10.000. Promo bisa bertambah setiap bulan, dan pemilik bisa mengganti urutan penerapannya. Pemilik ingin setiap promo menjadi satu aturan terpisah, lalu satu fungsi menerapkan daftar aturan itu berurutan.

    *Dalam kode:* type `AturanDiskon` menggambarkan bentuk semua aturan: menerima total, mengembalikan total baru. Setiap promo adalah fungsi bertipe `AturanDiskon`. `terapkanDiskon` menerima array aturan dan menjalankannya satu per satu.
  ]
  - Tulis `type AturanDiskon`: fungsi dengan satu parameter `total` number yang mengembalikan number.
  - `diskonMember`, bertipe `AturanDiskon`: kurangi total dengan 5% dari total. Potongannya dibulatkan ke bawah.
  - `voucher10rb`, bertipe `AturanDiskon`: jika total minimal `100000`, kurangi `10000`. Selain itu, total tetap.
  - `terapkanDiskon(total, daftarAturan)`. Input: `total` number, `daftarAturan` array `AturanDiskon`. Output: number. Aturan diterapkan berurutan, dan hasil satu aturan menjadi input aturan berikutnya. Array kosong mengembalikan `total` apa adanya.
  - Contoh:
    - `terapkanDiskon(120000, [diskonMember, voucher10rb])`: member mengubah `120000` menjadi `114000`, lalu voucher mengubahnya menjadi `104000`.
    - Urutan dibalik, `[voucher10rb, diskonMember]`: voucher mengubah `120000` menjadi `110000`, lalu member mengubahnya menjadi `104500`.

  #keluaran[`console.log(terapkanDiskon(120000, [diskonMember, voucher10rb]))`][```txt
  104000
  ```]
  #keluaran[`console.log(terapkanDiskon(120000, [voucher10rb, diskonMember]))`][```txt
  104500
  ```]
  #keluaran[`console.log(terapkanDiskon(50000, []))`][```txt
  50000
  ```]

+ *Kode temanmu: `tambahStok(stok, teksInput)`.* #est(7)
  #kebutuhan[
    Petugas gudang menambah stok obat lewat pemindai. Pemindai mengirim jumlahnya sebagai teks JSON, misalnya `5`. Kadang pemindai salah setelan dan mengirim `"5"`, yaitu teks di dalam tanda kutip. Temanmu sudah menulis fiturnya, dan `tsc` tidak menampilkan error apa pun. Tetapi stok `10` ditambah `"5"` malah menjadi `105`. Pemilik ingin input yang bukan angka ditolak dengan pesan yang jelas.

    *Dalam kode:* `tambahStok` membaca teks dengan `JSON.parse`, memeriksa bahwa hasilnya benar-benar number, lalu menjumlah. `cobaStok` (sudah ada di starter) menampilkan hasilnya atau pesan gagal.
  ]
  - Output yang benar: number, stok baru. Jika hasil `JSON.parse` bukan number, lempar `Error` dengan pesan `input stok harus angka`.
  - Contoh: `JSON.parse("5")` menghasilkan number `5`, jadi `tambahStok(10, "5")` menghasilkan `15`. `JSON.parse('"5"')` menghasilkan string `"5"`, jadi `tambahStok(10, '"5"')` harus melempar error, dan `cobaStok` menampilkan `"GAGAL: input stok harus angka"`.
  - *(jelaskan)* Fungsi temanmu dideklarasikan mengembalikan `number`, tetapi `tambahStok(10, '"5"')` mengembalikan string `"105"`, dan `tsc` diam saja. Mengapa? Apa tipe variabel `tambahan`? Lalu perbaiki dengan `unknown`.

  #keluaran[`console.log(cobaStok(10, "5"))`][```txt
  Stok baru: 15
  ```]
  #keluaran[`console.log(cobaStok(10, '"5"'))`][```txt
  GAGAL: input stok harus angka
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Tagihan pembeli.* #est(16)
  #kebutuhan[
    Saat pembeli selesai memilih obat, kasir mencetak tagihan berisi subtotal, total setelah promo, biaya admin sesuai cara bayar, dan total yang harus dibayar. Keranjang berisi pasangan kode obat dan jumlahnya. Jika ada kode yang tidak terdaftar, tagihan tidak boleh tercetak. Kasir cukup melihat satu pesan gagal.

    *Dalam kode:* `buatTagihan` menghasilkan teks tagihan. `cetakTagihan` (sudah ada di starter) menampilkan tagihan itu, atau pesan gagal jika ada masalah.
  ]
  - `buatTagihan(keranjang, metode)`. Input: `keranjang` `Map<string, number>` (key kode obat, value jumlah), `metode` `MetodeBayar`. Signature-nya sudah ada di starter.
  - Untuk setiap item: jika kode tidak ada di `daftarHarga`, lempar `Error` dengan pesan `obat <kode> tidak terdaftar`.
  - Promo diterapkan pada subtotal dengan `terapkanDiskon` dan aturan `[diskonMember, voucher10rb]`. Biaya admin dihitung dari total setelah promo.
  - Output: string empat baris, dipisah `"\n"`:
    ```text
    Subtotal: <subtotalRupiah>
    Setelah diskon: <setelahDiskonRupiah>
    Biaya admin: <adminRupiah>
    Total bayar: <totalBayarRupiah>
    ```
  - Contoh: keranjang `new Map([["OB01", 3], ["OB02", 2]])` dibayar dengan QRIS.
    - Subtotal: `3 × 12000 + 2 × 35000` adalah `106000`.
    - Promo: member menjadi `100700`, lalu voucher menjadi `90700`.
    - Biaya admin QRIS: 0,7% dari `90700` adalah `634.9`, dibulatkan ke atas menjadi `635`.
    - Total bayar: `90700 + 635` adalah `91335`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`. Tulis langkah-langkah `buatTagihan`, fungsi dari tugas sebelumnya yang dipakai di setiap langkah, dan *tipe data* di setiap langkah. Jelaskan juga: di langkah mana `tsc` memaksamu menangani obat yang tidak terdaftar, dan apa yang terjadi di JavaScript biasa jika kasus itu tidak ditangani?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(cetakTagihan(new Map([["OB01", 3], ["OB02", 2]]), "qris"))`][```txt
  Subtotal: Rp106.000
  Setelah diskon: Rp90.700
  Biaya admin: Rp635
  Total bayar: Rp91.335
  ```]
  #keluaran[`console.log(cetakTagihan(new Map([["OB03", 2], ["OB99", 1]]), "tunai"))`][```txt
  GAGAL: obat OB99 tidak terdaftar
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-ts1.ts`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-ts1.ts coba`.
  - Pastikan `npx tsc --noEmit` bersih, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
