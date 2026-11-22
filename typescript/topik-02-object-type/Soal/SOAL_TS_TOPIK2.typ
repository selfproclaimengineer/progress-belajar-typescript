#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal TypeScript Modul 2", judul: "Object Type")

= Tugas

Toko online Pasar Kita menjual pakaian, perabot rumah, dan alat tulis. Data produknya diisi oleh beberapa staf. Minggu lalu seorang staf menambah produk dengan field `hrga: 50000`, salah ketik dari `harga`. JavaScript menerimanya tanpa protes, dan halaman toko menampilkan harga `RpNaN` selama dua hari sampai ada pembeli yang bertanya.

Pemilik toko ingin bentuk setiap data ditulis jelas: field apa saja yang wajib ada, mana yang boleh kosong, dan mana yang tidak boleh diubah. Dengan begitu, salah ketik nama field atau field yang terlupa langsung ditolak `tsc` sebelum halaman toko diperbarui. Kamu diminta menulis tipe data toko dan beberapa fungsi yang memakainya.

#figure(
  table(
    columns: 6,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*id*], [*nama*], [*kategori*], [*harga*], [*stok*], [*diskonPersen*],
    [P01], [Kaos Polos], [pakaian], [50000], [10], [-],
    [P02], [Celana Chino], [pakaian], [150000], [3], [10],
    [P03], [Botol Minum], [rumah], [45000], [0], [-],
    [P04], [Lampu Meja], [rumah], [120000], [5], [25],
    [P05], [Buku Tulis], [alat tulis], [8000], [50], [-],
  ),
  caption: [Data `katalog`. Tanda `-` berarti field `diskonPersen` tidak ditulis sama sekali di object itu.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan toko dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Kerjakan di `Jawaban/soal-ts2.ts`. File itu sudah disiapkan dari `Soal/starter.ts`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah bagian `DATA` dan `PEMANGGILAN`.
  3. *Cek tipe dulu* dengan `npx tsc --noEmit`, lalu *jalankan* dengan `node Jawaban/soal-ts2.ts`. Keduanya dijalankan dari folder topik ini.
  4. Saat pertama dibuka, `tsc` sudah menampilkan error karena interface `Produk` masih kosong. Itu disengaja. Error itu hilang setelah semua tipe di bagian `TIPE` lengkap.
  5. Jawaban dianggap selesai jika `npx tsc --noEmit` tidak menampilkan error *dan* output `node` sama persis dengan kotak *Output dari*.
  6. Jangan memakai `any` dan tanda `!`. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Bentuk data produk.* #est(11)
  #kebutuhan[
    Setiap produk punya id, nama, kategori, harga, dan stok. Sebagian produk sedang diskon, sebagian tidak. Id dipakai di laporan penjualan dan di keranjang pembeli, jadi id yang sudah tercatat tidak boleh diubah oleh siapa pun. Halaman toko menampilkan harga akhir, yaitu harga setelah diskon.

    *Dalam kode:* `interface Produk` menjelaskan bentuk satu produk. `id` ditandai `readonly`, dan `diskonPersen` ditandai boleh tidak ada (`?`). `hargaAkhir` menghitung harga setelah diskon.
  ]
  - Lengkapi `interface Produk` di bagian `TIPE`:
    - `id` string, tidak boleh diubah setelah dibuat.
    - `nama` string, `kategori` string, `harga` number, `stok` number.
    - `diskonPersen` number, boleh tidak ada.
  - `hargaAkhir(p)`. Input: `p` `Produk`. Output: number.
    - Potongan = `harga` × `diskonPersen` / 100, dibulatkan ke bawah.
    - Produk tanpa `diskonPersen` dianggap diskon `0`.
  - Contoh: `hargaAkhir(katalog[1])`: potongan `150000 × 10 / 100` adalah `15000`, jadi hasilnya `135000`. `hargaAkhir(katalog[0])` menghasilkan `50000` karena tidak ada diskon.

  #keluaran[`console.log(hargaAkhir(katalog[0]), hargaAkhir(katalog[1]), hargaAkhir(katalog[3]))`][```txt
  50000 135000 90000
  ```]

+ *Baris keranjang.* #est(4)
  #kebutuhan[
    Keranjang pembeli disimpan sebagai daftar pasangan pendek: id produk dan jumlahnya, misalnya `["P01", 2]`. Bentuk pendek ini dipilih karena keranjang dikirim ke server setiap kali pembeli menekan tombol, dan pasangan dua nilai lebih hemat daripada object lengkap. Toko ingin ikon keranjang menampilkan jumlah barang di dalamnya.

    *Dalam kode:* `type BarisKeranjang` adalah tuple dua isi: string lalu number. `jumlahBarang` menjumlah bagian qty dari semua baris.
  ]
  - Lengkapi `type BarisKeranjang`: tuple `[id, qty]`, `id` string dan `qty` number.
  - `jumlahBarang(keranjang)`. Input: `keranjang` array `BarisKeranjang`. Output: number, jumlah semua `qty`. Keranjang kosong menghasilkan `0`.
  - Contoh: `keranjangA` berisi `[["P01", 2], ["P02", 1], ["P05", 3]]`, jadi hasilnya `2 + 1 + 3` = `6`.

  #keluaran[`console.log(jumlahBarang(keranjangA))`][```txt
  6
  ```]
  #keluaran[`console.log(jumlahBarang([]))`][```txt
  0
  ```]

+ *(jelaskan)* Seorang staf menambah produk baru seperti ini:
  ```ts
  const baru: Produk = { id: "P06", nama: "Topi", kategori: "pakaian", harga: 35000, stok: 4, warna: "hitam" };
  ```
  Tempel baris itu sementara di bawah bagian `DATA`, jalankan `npx tsc --noEmit`, lalu hapus lagi.
  - Tulis nomor dan pesan error `tsc`-nya.
  - JavaScript biasa menerima field tambahan tanpa protes. Mengapa TypeScript menolaknya? Hubungkan dengan cerita `hrga` di awal soal.
  - Jika toko memang ingin menyimpan warna, tetapi hanya untuk sebagian produk, apa yang diubah di `interface Produk`?

#level("Intermediate", "0.3")

+ *Stok per kategori.* #est(7)
  #kebutuhan[
    Bagian gudang ingin melihat total stok setiap kategori, misalnya semua pakaian digabung. Kategori bisa bertambah kapan saja, jadi daftar kategori tidak boleh ditulis tetap di kode.

    *Dalam kode:* `stokPerKategori` menghasilkan object dengan key nama kategori dan value total stok. Tipe object seperti itu ditulis `Record<string, number>`.
  ]
  - `stokPerKategori(daftar)`. Input: `daftar` array `Produk` (tidak diubah). Output: `Record<string, number>`.
  - Urutan key mengikuti urutan kategori pertama kali muncul di data.
  - Contoh: kategori `pakaian` berisi P01 (stok `10`) dan P02 (stok `3`), jadi key `pakaian` bernilai `13`.

  #keluaran[`console.log(JSON.stringify(stokPerKategori(katalog)))`][```txt
  {"pakaian":13,"rumah":5,"alat tulis":50}
  ```]

+ *Label pengiriman.* #est(9)
  #kebutuhan[
    Pembeli boleh mendaftar tanpa mengisi alamat, lalu melengkapinya saat checkout. Bagian pengiriman mencetak label berisi nama, kota, dan kode pos. Jika alamat belum diisi, label harus memberi tahu hal itu, bukan mencetak `undefined`.

    *Dalam kode:* `type Alamat` berisi kota dan kode pos. `interface Pembeli` berisi nama dan alamat yang boleh tidak ada. `labelPengiriman` memeriksa alamat sebelum memakainya.
  ]
  - Lengkapi `type Alamat`: `kota` string, `kodePos` string.
  - Lengkapi `interface Pembeli`: `nama` string, `alamat` bertipe `Alamat` dan boleh tidak ada.
  - `labelPengiriman(p)`. Input: `p` `Pembeli`. Output: string.
    - Ada alamat: `<nama> - <kota> <kodePos>`.
    - Tanpa alamat: `<nama> - alamat belum diisi`.
  - Contoh: `{ nama: "Joko" }` menghasilkan `"Joko - alamat belum diisi"`.

  #keluaran[`console.log(labelPengiriman(daftarPembeli[0]))`][```txt
  Rina - Salatiga 50711
  ```]
  #keluaran[`console.log(labelPengiriman(daftarPembeli[1]))`][```txt
  Joko - alamat belum diisi
  ```]

+ *Kode temanmu: `urutTermurah(daftar)`.* #est(3)
  #kebutuhan[
    Halaman toko punya tombol "urutkan dari termurah". Temanmu sudah menulis fiturnya, dan daftar yang tampil benar. Tetapi setelah tombol ditekan, produk pertama di `katalog` ikut berubah. Laporan stok yang dibuat setelahnya jadi tertukar urutannya. Pemilik ingin fungsi itu *tidak bisa* mengubah katalog asli, dan ingin `tsc` yang menjaga aturan itu.

    *Dalam kode:* parameter `daftar` diberi tipe array yang hanya bisa dibaca. `tsc` lalu menolak method yang mengubah array, dan kamu memperbaiki isi fungsinya.
  ]
  - Output yang benar: array string, nama produk urut dari `hargaAkhir` termurah. `katalog` tidak berubah, jadi `katalog[0].nama` tetap `Kaos Polos`.
  - Langkah: ubah tipe parameter dulu, jalankan `tsc` dan baca error-nya, baru perbaiki isi fungsi.
  - *(jelaskan)* Mengapa `tsc` tidak menolak kode temanmu yang asli? Error apa yang muncul setelah tipe parameter diubah, dan mengapa error itu justru membantu?

  #keluaran[`console.log(urutTermurah(katalog).join(", "))`][```txt
  Buku Tulis, Botol Minum, Kaos Polos, Lampu Meja, Celana Chino
  ```]
  #keluaran[`console.log(katalog[0].nama)`][```txt
  Kaos Polos
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Ringkasan pesanan.* #est(15)
  #kebutuhan[
    Sebelum pembeli membayar, toko menampilkan ringkasan: total yang harus dibayar, jumlah barang yang benar-benar bisa dikirim, dan daftar baris keranjang yang ditolak beserta alasannya. Baris ditolak jika produknya tidak ada di katalog, atau jumlah yang dipesan melebihi stok. Baris yang ditolak tidak ikut dihitung, tetapi baris lain tetap diproses.

    *Dalam kode:* `ringkasPesanan` menghasilkan object `Ringkasan` (sudah ada di starter). `cetakRingkasan` (sudah ada) mengubahnya menjadi tiga baris teks.
  ]
  - `ringkasPesanan(keranjang, daftar)`. Input: `keranjang` array `BarisKeranjang`, `daftar` array `Produk`. Output: `Ringkasan`.
  - Setiap baris keranjang diproses berurutan:
    1. Produk dengan id itu tidak ada: tambahkan `<id> tidak ada` ke `ditolak`.
    2. `qty` lebih besar dari `stok`: tambahkan `<nama> stok kurang` ke `ditolak`.
    3. Selain itu: tambahkan `hargaAkhir` × `qty` ke `totalBayar`, dan `qty` ke `jumlahBarang`.
  - Setiap baris dibandingkan dengan stok di katalog apa adanya. Stok tidak dikurangi oleh baris sebelumnya.
  - Contoh untuk `keranjangB` = `[["P03", 1], ["P04", 6], ["P99", 1], ["P04", 2]]`:
    - `["P03", 1]`: stok Botol Minum `0`, jadi ditolak.
    - `["P04", 6]`: stok Lampu Meja `5`, jadi ditolak.
    - `["P99", 1]`: tidak ada di katalog, jadi ditolak.
    - `["P04", 2]`: diterima, `90000 × 2` = `180000`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`. Tulis langkah-langkahnya, method yang dipakai di setiap langkah, dan *tipe data* di setiap langkah, termasuk tipe hasil pencarian produk. Jelaskan juga: mengapa `tsc` memaksamu menangani produk yang tidak ditemukan sebelum membaca `stok`-nya?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(cetakRingkasan(ringkasPesanan(keranjangA, katalog)))`][```txt
  Total bayar: Rp259.000
  Jumlah barang: 6
  Ditolak: -
  ```]
  #keluaran[`console.log(cetakRingkasan(ringkasPesanan(keranjangB, katalog)))`][```txt
  Total bayar: Rp180.000
  Jumlah barang: 2
  Ditolak: Botol Minum stok kurang, Lampu Meja stok kurang, P99 tidak ada
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-ts2.ts`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-ts2.ts coba`.
  - Pastikan `npx tsc --noEmit` bersih, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
