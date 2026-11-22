#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal Modul 8", judul: "DOM")

= Tugas

Toko Roti Manis ingin pembeli bisa memesan dari tablet di meja kasir. Pembeli memilih roti dari menu, roti masuk ke keranjang, lalu pembeli membayar. Desainer sudah membuat halaman HTML-nya (`index.html`), tetapi halaman itu masih kosong: menunya tidak muncul dan tombolnya belum bekerja.

Kamu diminta membuat halaman itu hidup. Pekerjaannya dibagi dua. Aturan toko (format menu, isi keranjang, total, pembayaran) ditulis sebagai fungsi biasa di `toko.js`, supaya bisa diperiksa dengan `node` tanpa browser. Kode yang menyentuh halaman ditulis di `halaman.js`, yang memakai fungsi dari `toko.js`.

#figure(
  table(
    columns: 3,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*id*], [*nama*], [*harga*],
    [R01], [Roti Tawar], [15000],
    [R02], [Donat Cokelat], [8000],
    [R03], [Croissant], [18000],
    [R04], [Bolu Pandan], [45000],
  ),
  caption: [Data `produk` di `toko.js`. Keranjang adalah array object `{ id, qty }`, misalnya `[{ id: "R01", qty: 2 }]`.],
)

Pembagian kerja empat file:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*File*], [*Isi*],
  [`Jawaban/toko.js`], [Fungsi logika yang di-`export`: Beginner 1–2, Intermediate 1–3. Tidak boleh memakai `document`.],
  [`Jawaban/halaman.js`], [Kode tampilan: Beginner 3, Intermediate 4, Advanced 1.],
  [`Jawaban/index.html`], [Halaman dari desainer. Jangan diubah.],
  [`Jawaban/soal-js8.js`], [`PEMANGGILAN` untuk diperiksa dengan `node`, Coba Sendiri, dan jawaban *(jelaskan)*.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan toko dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Kerjakan di folder `Jawaban/`. `soal-js8.js`, `toko.js`, `halaman.js`, dan `index.html` sudah disiapkan dari `Soal/`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah `index.html`, bagian `DATA`, dan `PEMANGGILAN`.
  3. Tugas *logika*: jalankan `node Jawaban/soal-js8.js`. Output harus sama persis dengan kotak *Output dari*.
  4. Tugas *tampilan*: jalankan `npm run sajikan`, lalu buka alamat yang dicetak di browser. Halaman harus terlihat dan bekerja seperti gambar *Tampilan yang diharapkan*. Membuka `index.html` langsung dari folder (alamat `file://`) tidak bisa, lihat HO.
  5. Di browser, tekan F12 dan buka tab Console. Error di `halaman.js` muncul di sana, bukan di terminal.
  6. Pakai `textContent` untuk menulis teks ke halaman, bukan `innerHTML`. Soal bertanda *(jelaskan)* dijawab sebagai komentar di `soal-js8.js`, di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Teks menu* (di `toko.js`). #est(3)
  #kebutuhan[
    Setiap baris menu menampilkan nama roti dan harganya dalam format rupiah, dipisah tanda hubung, supaya pembeli tidak perlu menebak harga.

    *Dalam kode:* `teksMenu` mengubah satu produk menjadi teks. Fungsi ini dipakai `renderMenu` di Beginner 3.
  ]
  - `teksMenu(p)`. Input: `p` object produk. Output: string `<nama> - <hargaRupiah>`.
  - Pakai `formatRupiah` yang sudah ada di `toko.js`.
  - Contoh: `teksMenu(produk[0])` menghasilkan `"Roti Tawar - Rp15.000"`.

  #keluaran[`console.log(teksMenu(produk[0]))`][```txt
  Roti Tawar - Rp15.000
  ```]
  #keluaran[`console.log(produk.map(teksMenu).join("\n"))`][```txt
  Roti Tawar - Rp15.000
  Donat Cokelat - Rp8.000
  Croissant - Rp18.000
  Bolu Pandan - Rp45.000
  ```]

+ *Mengurangi isi keranjang* (di `toko.js`). #est(3)
  #kebutuhan[
    Pembeli bisa mengurangi jumlah roti yang sudah masuk keranjang. Jika jumlahnya menjadi nol, roti itu hilang dari keranjang. Toko berencana menambah tombol "Batalkan" yang mengembalikan keranjang ke keadaan sebelumnya, jadi keranjang lama tidak boleh ikut berubah.

    *Dalam kode:* `kurangiItem` membuat keranjang *baru* dengan `map` dan `filter`. Keranjang yang diterima tidak diubah sama sekali.
  ]
  - `kurangiItem(keranjang, id)`. Input: `keranjang` array `{ id, qty }`, `id` string. Output: array keranjang baru.
    1. Item dengan `id` itu: `qty` berkurang 1, dalam object *baru* (pakai spread dari JS-4).
    2. Item lain: tetap.
    3. Item yang `qty`-nya menjadi `0` dibuang.
  - Contoh: `kurangiItem([{ id: "R01", qty: 2 }, { id: "R02", qty: 1 }], "R02")` menghasilkan `[{ id: "R01", qty: 2 }]`. Baris ketiga output membuktikan `keranjangA` tidak berubah.

  #keluaran[`console.log(JSON.stringify(kurangiItem(keranjangA, "R02")))`][```txt
  [{"id":"R01","qty":2}]
  ```]
  #keluaran[`console.log(JSON.stringify(kurangiItem(keranjangA, "R01")))`][```txt
  [{"id":"R01","qty":1},{"id":"R02","qty":1}]
  ```]
  #keluaran[`console.log(JSON.stringify(keranjangA))`][```txt
  [{"id":"R01","qty":2},{"id":"R02","qty":1}]
  ```]

+ *Menampilkan menu* (di `halaman.js`, tampilan). #est(13)
  #kebutuhan[
    Saat halaman dibuka, semua roti muncul di kotak Menu, masing-masing dengan tombol "Tambah". Tombol itu harus tahu roti mana yang diwakilinya, supaya nanti bisa dipakai di Intermediate 4.

    *Dalam kode:* `renderMenu` membuat elemen dengan `document.createElement`, mengisi teksnya dengan `textContent`, menyimpan id produk di `data-id` (lewat `dataset`), lalu menempelkannya ke `#daftar-produk`.
  ]
  - `renderMenu()`. Untuk setiap produk, buat satu `<li>` berisi:
    1. `<span>` dengan teks `teksMenu(p)`.
    2. `<button>` dengan teks `Tambah`, `type` `"button"`, dan `dataset.id` berisi id produk.
  - Tempelkan setiap `<li>` ke `daftarProduk`. Sudah dipanggil sekali di akhir `halaman.js`.
  - *(jelaskan)* Mengapa teks ditulis dengan `textContent`, bukan `innerHTML`? Apa yang terjadi jika nama produk suatu saat berisi `<b>Promo</b>`?

  #figure(
    image("tampilan-awal.png", width: 78%),
    caption: [Tampilan yang diharapkan setelah Beginner 3 dan Intermediate 4: menu tampil, keranjang kosong.],
  )

#level("Intermediate", "0.3")

+ *Total belanja* (di `toko.js`). #est(6)
  #kebutuhan[
    Kasir harus melihat total belanja yang selalu benar. Keranjang hanya menyimpan id dan jumlah, harga diambil dari data produk. Jika ada id yang tidak dikenal (misalnya produk sudah dihapus dari menu), item itu tidak dihitung.

    *Dalam kode:* `hitungTotal` memakai `reduce` dan `find` (JS-3).
  ]
  - `hitungTotal(keranjang, daftarProduk)`. Input: `keranjang` array `{ id, qty }`, `daftarProduk` array produk. Output: number.
  - Total = jumlah `harga × qty` untuk setiap item yang id-nya ada di `daftarProduk`.
  - Contoh: 2 Roti Tawar dan 1 Croissant: `15000 × 2 + 18000 × 1 = 48000`.

  #keluaran[`console.log(hitungTotal([{ id: "R01", qty: 2 }, { id: "R03", qty: 1 }], produk))`][```txt
  48000
  ```]
  #keluaran[`console.log(hitungTotal([{ id: "R04", qty: 1 }, { id: "X99", qty: 3 }], produk))`][```txt
  45000
  ```]
  #keluaran[`console.log(hitungTotal([], produk))`][```txt
  0
  ```]

+ *Memeriksa uang yang dibayar* (di `toko.js`). #est(8)
  #kebutuhan[
    Pembeli mengetik jumlah uang di kotak isian. Isinya bisa kosong, berisi spasi saja, berisi huruf, atau angka negatif karena salah ketik. Kasir ingin pesan yang jelas untuk setiap kesalahan, dan kembalian yang benar jika uangnya cukup.

    *Dalam kode:* `validasiBayar` menerima teks dari kotak isian (isi kotak isian *selalu* string) dan total belanja.
  ]
  - `validasiBayar(teksUang, total)`. Input: `teksUang` string, `total` number. Output: object `{ ok, pesan }`, dengan `ok` boolean dan `pesan` string.
  - Pemeriksaan berurutan. Pemeriksaan pertama yang gagal langsung menentukan hasil dengan `ok` `false`:
    1. `total` `0`: `keranjang masih kosong`.
    2. `teksUang` kosong atau hanya spasi: `isi jumlah uang`.
    3. Hasil `Number(teksUang)` adalah `NaN` atau kurang dari `0`: `jumlah uang tidak valid`.
    4. Uang kurang dari `total`: `uang kurang <selisihRupiah>`.
  - Jika semua lolos: `ok` `true`, `pesan` `kembalian <kembalianRupiah>`.
  - Contoh: total `48000`, uang `"40000"`: kurang `8000`, jadi `{ ok: false, pesan: "uang kurang Rp8.000" }`.
  - *(jelaskan)* Apa hasil `Number("  ")`? Apa yang terjadi pada pembeli jika langkah 2 dihapus dan isian kosong langsung diubah dengan `Number`?

  #keluaran[`console.log(validasiBayar("10000", 0))`][```txt
  { ok: false, pesan: 'keranjang masih kosong' }
  ```]
  #keluaran[`console.log(validasiBayar("  ", 48000))`][```txt
  { ok: false, pesan: 'isi jumlah uang' }
  ```]
  #keluaran[`console.log(validasiBayar("lima puluh", 48000))` dan `console.log(validasiBayar("-5000", 48000))`][```txt
  { ok: false, pesan: 'jumlah uang tidak valid' }
  { ok: false, pesan: 'jumlah uang tidak valid' }
  ```]
  #keluaran[`console.log(validasiBayar("40000", 48000))`][```txt
  { ok: false, pesan: 'uang kurang Rp8.000' }
  ```]
  #keluaran[`console.log(validasiBayar("50000", 48000))`][```txt
  { ok: true, pesan: 'kembalian Rp2.000' }
  ```]

+ *Kode temanmu: `tambahItem(keranjang, id)`* (di `toko.js`). #est(5)
  #kebutuhan[
    Saat tombol "Tambah" diklik, roti masuk ke keranjang dengan jumlah 1, atau jumlahnya bertambah 1 jika sudah ada. Temanmu menulis fungsinya dan sudah menyalin array dengan spread. Tetapi saat diuji, keranjang lama ikut berubah, dan rencana tombol "Batalkan" tidak bisa jalan.

    *Dalam kode:* setiap pemanggilan menyimpan hasilnya di variabel baru (`k1`, `k2`, `k3`), seperti riwayat keranjang.
  ]
  - Output yang benar: keranjang baru. Keranjang yang diterima, termasuk object item di dalamnya, tidak boleh berubah.
    - `id` belum ada: tambahkan `{ id, qty: 1 }` di akhir.
    - `id` sudah ada: item itu menjadi object baru dengan `qty` bertambah 1.
  - Output kode temanmu saat ini:
    ```text
    []
    [{"id":"R01","qty":2}]
    [{"id":"R01","qty":2}]
    [{"id":"R01","qty":2},{"id":"R02","qty":1}]
    ```
  - *(jelaskan)* Temanmu sudah menulis `[...keranjang]`. Mengapa `k1` tetap ikut berubah? Hubungkan dengan salinan dangkal di JS-4.

  #keluaran[`console.log(JSON.stringify(k0))` sampai `console.log(JSON.stringify(k3))`][```txt
  []
  [{"id":"R01","qty":1}]
  [{"id":"R01","qty":2}]
  [{"id":"R01","qty":2},{"id":"R02","qty":1}]
  ```]

+ *Keranjang yang hidup* (di `halaman.js`, tampilan). #est(35)
  #kebutuhan[
    Klik "Tambah" di menu memasukkan roti ke keranjang. Setiap baris keranjang punya tombol "Kurangi". Total di bawah keranjang selalu ikut berubah. Jika keranjang kosong, tampilkan tulisan "Keranjang kosong" supaya pembeli tidak mengira halamannya rusak.

    *Dalam kode:* variabel `keranjang` adalah _state_. Setiap klik mengganti `keranjang` dengan hasil `tambahItem` atau `kurangiItem`, lalu memanggil `renderKeranjang` yang membuat ulang isi `#daftar-keranjang` dari awal. Listener klik dipasang *sekali* di `<ul>`, bukan di setiap tombol.
  ]
  - `renderKeranjang()`:
    1. Kosongkan `daftarKeranjang` (pakai `replaceChildren()`).
    2. Keranjang kosong: satu `<li>` dengan `className` `"kosong"` dan teks `Keranjang kosong`.
    3. Untuk setiap item: satu `<li>` berisi `<span>` dengan teks `<nama> x<qty> = <subtotalRupiah>`, dan `<button>` `Kurangi` dengan `dataset.id`.
    4. Isi `elTotal` dengan total dalam format rupiah.
  - Listener `"click"` di `daftarProduk`: cari tombol yang diklik dengan `event.target.closest("button")`. Jika `null`, abaikan. Jika ada: `keranjang = tambahItem(keranjang, tombol.dataset.id)`, lalu `renderKeranjang()`.
  - Listener `"click"` di `daftarKeranjang`: sama, tetapi dengan `kurangiItem`.
  - *(jelaskan)* Tombol di keranjang dibuat ulang setiap kali `renderKeranjang` berjalan. Mengapa listener yang dipasang di `<ul>` tetap bekerja untuk tombol-tombol baru itu?

  #figure(
    image("tampilan-keranjang.png", width: 78%),
    caption: [Tampilan yang diharapkan setelah klik Tambah pada Roti Tawar dua kali, Croissant sekali, Donat Cokelat sekali, lalu Kurangi pada Donat Cokelat.],
  )

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Membayar* (di `halaman.js`, tampilan). #est(11)
  #kebutuhan[
    Pembeli mengetik jumlah uang lalu menekan "Bayar" (atau Enter). Halaman tidak boleh dimuat ulang, karena keranjang akan hilang. Pesan hasil pemeriksaan muncul di bawah form: hijau jika berhasil, merah jika gagal. Jika berhasil, keranjang dan kotak isian dikosongkan untuk pembeli berikutnya. Begitu pembeli menambah roti lagi, pesan lama hilang.

    *Dalam kode:* listener `"submit"` di `form` memanggil `event.preventDefault()`, membaca `inputUang.value`, memakai `validasiBayar` dan `hitungTotal`, lalu memperbarui `pesan` dan state.
  ]
  - Saat form di-submit:
    1. Cegah halaman dimuat ulang.
    2. Periksa dengan `validasiBayar(inputUang.value, total)`.
    3. Tulis `pesan` hasilnya ke `#pesan`. Beri `className` `"ok"` jika berhasil, `"gagal"` jika tidak. Warnanya sudah diatur di `index.html`.
    4. Jika berhasil: kosongkan `keranjang`, kosongkan form dengan `form.reset()`, lalu `renderKeranjang()`.
  - Di listener "Tambah" (Intermediate 4), tambahkan baris yang mengosongkan teks `#pesan`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`: urutan kejadian dari pembeli menekan "Bayar" sampai tampilan berubah, dan apa yang terjadi jika `event.preventDefault()` lupa ditulis. Jelaskan juga mengapa halaman ini memakai pola "ubah state, lalu render ulang", bukan mengubah elemen satu per satu (misalnya menambah `qty` langsung di teks `<span>`).
  + *(opsional)* Tulis kodenya.

  #grid(
    columns: 2,
    gutter: 10pt,
    figure(image("tampilan-gagal.png"), caption: [Keranjang Rp48.000, uang `40000`.]),
    figure(image("tampilan-berhasil.png"), caption: [Keranjang Rp48.000, uang `50000`.]),
  )

= Pengumpulan

#perhatian[
  - Kode: `Jawaban/toko.js`, `Jawaban/halaman.js`, dan `Jawaban/soal-js8.js`. Jawaban *(jelaskan)* ditulis sebagai komentar di `soal-js8.js`, di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO: Bagian 1 di fungsi `cobaSendiri()`, jalankan dengan `node Jawaban/soal-js8.js coba`. Bagian 2 diketik di Console browser.
  - Kirim juga satu tangkapan layar halamanmu setelah membayar, atau minta asisten membuka halamannya.
  - Jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
