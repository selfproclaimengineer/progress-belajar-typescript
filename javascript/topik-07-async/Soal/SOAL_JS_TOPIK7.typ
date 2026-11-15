#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal Modul 7", judul: "Async")

= Tugas

Bank Sejahtera sedang membuat aplikasi mobile banking. Data rekening tidak ada di ponsel, tetapi di server bank. Setiap kali aplikasi butuh saldo atau ingin mentransfer, aplikasi mengirim permintaan lewat jaringan dan harus *menunggu* balasan. Versi percobaan pertama sering salah: saldo tampil `[object Promise]`, daftar nama rekening tampil kosong, dan satu server cabang yang lambat membuat seluruh antrean transfer macet.

Kamu diminta menulis bagian aplikasi yang berbicara dengan server bank. Server bank yang asli belum boleh dipakai, jadi tim menyediakan server *palsu* di `api.js`. Server palsu itu bekerja seperti server asli: setiap permintaan butuh waktu sekitar 50 ms, dan balasannya berbentuk sama.

#figure(
  table(
    columns: 3,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*nomor*], [*nama*], [*saldo awal*],
    [1001], [Ani], [500000],
    [1002], [Budi], [75000],
    [1003], [Citra], [1200000],
    [1004], [Dodi], [300000],
  ),
  caption: [Rekening di server palsu. Server cabang rekening 1004 sedang lambat: permintaan data rekening 1004 butuh 400 ms. Saldo berubah setiap kali transfer berhasil.],
)

Isi `api.js` (sudah jadi, jangan diubah):

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Fungsi*], [*Kegunaan*],
  [`cekSaldoCallback(nomor, callback)`], [Gaya lama. Setelah 50 ms memanggil `callback(err, saldo)`. Jika rekening tidak ada, `err` berisi `Error` dengan pesan `rekening <nomor> tidak ada`. Jika ada, `err` berisi `null` dan `saldo` number.],
  [`fetchBank(url, opsi)`], [Gaya baru, dipakai persis seperti `fetch`. Mengembalikan Promise berisi `Response`.],
  [`GET /rekening/<nomor>`], [Status `200` dengan isi `{ nomor, nama, saldo }`, atau `404` dengan isi `{ pesan: "rekening tidak ditemukan" }`.],
  [`POST /transfer`], [`opsi`: `{ method: "POST", body: JSON.stringify({ dari, ke, nominal }) }`. Status `200` dengan isi `{ saldoDari, saldoKe }`. Gagal: `400` `nominal tidak valid`, `404` `rekening tidak ditemukan`, atau `400` `saldo tidak cukup`, selalu dalam bentuk `{ pesan }`.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan bank dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Salin `Soal/starter.js` ke `Jawaban/soal-js7.js`, dan `Soal/api.js` ke `Jawaban/api.js`. Kedua file harus berada di folder yang sama.
  2. Lengkapi fungsi bertanda `TODO`. Jangan mengubah `api.js`, baris `import`, dan bagian `PEMANGGILAN`.
  3. Jalankan `node Jawaban/soal-js7.js`. Output harus sama persis dengan kotak *Output dari*.
  4. `PEMANGGILAN` memakai `await` di luar fungsi. Ini boleh karena file ini adalah modul (lihat HO).
  5. Pemanggilan berjalan berurutan dan memakai server yang sama, jadi saldo yang berubah di satu tugas terbawa ke tugas berikutnya.
  6. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Menunggu sebentar.*
  #kebutuhan[
    Setelah transfer, aplikasi menampilkan animasi sukses selama beberapa saat sebelum kembali ke menu. Tim butuh fungsi kecil untuk "menunggu sekian milidetik, lalu lanjut", yang bisa dipakai dengan `await`.

    *Dalam kode:* `tunda` membuat Promise baru yang baru selesai setelah `setTimeout` berjalan.
  ]
  - `tunda(ms, nilai)`. Input: `ms` number (milidetik), `nilai` apa saja. Output: Promise yang selesai (_resolve_) dengan `nilai` setelah `ms` milidetik.
  - Wajib memakai `new Promise` dan `setTimeout`.
  - Contoh: `await tunda(100, "siap")` menunggu 100 ms, lalu menghasilkan `"siap"`.

  #keluaran[`console.log(await tunda(100, "siap"))`][```txt
  siap
  ```]
  #keluaran[`console.log(await tunda(10, 42) + 1)`][```txt
  43
  ```]

+ *Membungkus fungsi gaya lama.*
  #kebutuhan[
    Fitur cek saldo masih memakai pustaka lama yang hanya mengenal callback. Seluruh aplikasi baru memakai `await`, dan tim tidak mau mencampur dua gaya. Pustaka lama tidak boleh diubah, jadi fungsinya cukup dibungkus.

    *Dalam kode:* `cekSaldo` membungkus `cekSaldoCallback` dengan `new Promise`. Jika `err` ada, Promise gagal (_reject_). Jika tidak, Promise selesai dengan saldo.
  ]
  - `cekSaldo(nomor)`. Input: `nomor` string. Output: Promise berisi number (saldo).
  - Panggil `cekSaldoCallback` di dalam `new Promise`. Jika `err` bukan `null`: `reject(err)`. Jika `null`: `resolve(saldo)`.
  - Contoh: `await cekSaldo("1001")` menghasilkan `500000`. `cekSaldo("9999")` gagal dengan error berpesan `"rekening 9999 tidak ada"`.

  #keluaran[`console.log(await cekSaldo("1001"))`][```txt
  500000
  ```]
  #keluaran[`console.log(await cekSaldo("9999").catch((e) => e.message))`][```txt
  rekening 9999 tidak ada
  ```]

+ *(jelaskan)* Programmer sebelumnya menulis kode ini untuk menampilkan saldo, dan layar menampilkan hal aneh. Tulis *sementara* di akhir file, jalankan, lalu hapus lagi:
  ```js
  async function saldoAni() {
    return 500000;
  }
  const s = saldoAni();
  console.log(s, s + 1);
  ```
  - Apa yang dicetak? Mengapa `s` bukan `500000`, padahal fungsinya me-`return 500000`?
  - Perbaiki baris `const s = ...` supaya yang dicetak `500000 500001`. Mengapa perbaikan itu boleh ditulis di luar fungsi di file ini?

#level("Intermediate", "0.3")

+ *Data rekening dari server.*
  #kebutuhan[
    Halaman utama aplikasi menampilkan nama pemilik dan saldo. Jika nomor rekening salah, layar harus menampilkan alasan dari server, bukan error mentah atau `undefined`.

    *Dalam kode:* `ambilRekening` memanggil `fetchBank`, membaca isi balasan dengan `res.json()`, dan melempar `Error` jika status balasan bukan sukses. `infoRekening` memanggil `ambilRekening` di dalam `try...catch` dan mengubah hasilnya menjadi teks.
  ]
  - `ambilRekening(nomor)`. Input: `nomor` string. Output: Promise berisi object `{ nomor, nama, saldo }`.
    1. Panggil `fetchBank` dengan url `/rekening/<nomor>`, lalu `await` hasilnya.
    2. Baca isi balasan dengan `await res.json()`.
    3. Jika `res.ok` bernilai `false`: lempar `Error` dengan pesan `<status> <pesan>`, misalnya `404 rekening tidak ditemukan`.
    4. Jika tidak: kembalikan isi balasan.
  - `infoRekening(nomor)`. Input: `nomor` string. Output: Promise berisi string.
    - Berhasil: `<nama>: <saldoRupiah>`.
    - Gagal: `Gagal: <pesan error>`.
  - Contoh: `await infoRekening("1002")` menghasilkan `"Budi: Rp75.000"`.

  #keluaran[`console.log(await infoRekening("1002"))`][```txt
  Budi: Rp75.000
  ```]
  #keluaran[`console.log(await infoRekening("1009"))`][```txt
  Gagal: 404 rekening tidak ditemukan
  ```]

+ *Total saldo keluarga.*
  #kebutuhan[
    Nasabah bisa menautkan beberapa rekening keluarga dan melihat total saldonya. Setiap permintaan ke server butuh waktu, jadi rekening-rekening itu harus diminta *bersamaan*, bukan satu per satu. Jika salah satu rekening gagal diambil, total tidak boleh ditampilkan, karena angkanya pasti salah.

    *Dalam kode:* `totalSaldo` membuat satu Promise `ambilRekening` untuk setiap nomor dengan `map`, menunggu semuanya dengan `Promise.all`, lalu menjumlahkan saldonya.
  ]
  - `totalSaldo(daftarNomor)`. Input: `daftarNomor` array string. Output: Promise berisi number.
  - Wajib memakai `Promise.all`. Jangan menulis `await` di dalam perulangan.
  - Jika salah satu `ambilRekening` gagal, `totalSaldo` ikut gagal dengan error yang sama. Tidak perlu `try...catch` di dalam `totalSaldo`.
  - Contoh: saldo 1001, 1002, dan 1003 adalah `500000`, `75000`, dan `1200000`, jadi totalnya `1775000`.
  - *(jelaskan)* Jika ketiga rekening diambil satu per satu dengan `await` di dalam `for...of`, kira-kira berapa lama totalnya, dan berapa lama dengan `Promise.all`? Mengapa satu rekening gagal membuat seluruh `Promise.all` gagal?

  #keluaran[`console.log(rupiah(await totalSaldo(["1001", "1002", "1003"])))`][```txt
  Rp1.775.000
  ```]
  #keluaran[`console.log(await totalSaldo(["1001", "1009"]).catch((e) => "Gagal: " + e.message))`][```txt
  Gagal: 404 rekening tidak ditemukan
  ```]

+ *Kode temanmu: `daftarNama(daftarNomor)`.*
  #kebutuhan[
    Halaman rekening tertaut menampilkan nama semua pemilik, dipisah koma, sesuai urutan nomor yang diberikan. Temanmu menulis fungsinya dengan `forEach`. Tidak ada error, tetapi halaman itu selalu kosong.

    *Dalam kode:* fungsi temanmu memanggil `ambilRekening` di dalam callback `async` milik `forEach`.
  ]
  - Output yang benar: Promise berisi string, nama-nama dipisah `", "`, *sesuai urutan* `daftarNomor`.
  - Perbaiki dengan `Promise.all` dan `map`, seperti Intermediate 2.
  - *(jelaskan)* Mengapa hasil temanmu string kosong? Kapan sebenarnya `nama.push` dijalankan? Jika setiap rekening butuh waktu berbeda, mengapa `Promise.all` tetap menjaga urutan nama?

  #keluaran[`console.log(await daftarNama(["1003", "1001", "1002"]))`][```txt
  Citra, Ani, Budi
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Antrean transfer terjadwal.*
  #kebutuhan[
    Nasabah bisa menjadwalkan beberapa transfer sekaligus. Bank memproses antrean itu satu per satu, *berurutan*, karena saldo setelah satu transfer menentukan transfer berikutnya. Sebelum mentransfer, aplikasi mengambil data rekening tujuan untuk menampilkan nama penerima. Server cabang yang lambat tidak boleh membuat antrean macet: jika data rekening tujuan tidak datang dalam 200 ms, transfer itu dibatalkan dan antrean lanjut. Satu transfer yang gagal juga tidak boleh menghentikan transfer berikutnya.

    *Dalam kode:* `denganBatasWaktu` membalap sebuah Promise dengan Promise lain yang gagal setelah sekian milidetik (`Promise.race`). `prosesAntrian` memakai `for...of` dengan `await`, dan `try...catch` untuk setiap transfer.
  ]
  - `denganBatasWaktu(janji, ms)`. Input: `janji` Promise, `ms` number. Output: Promise yang hasilnya sama dengan `janji`, atau gagal dengan error berpesan `waktu habis` jika `janji` belum selesai setelah `ms` milidetik.
  - `prosesAntrian(daftar)`. Input: `daftar` array object `{ dari, ke, nominal }`. Output: Promise berisi string, baris-baris digabung dengan `"\n"`.
  - Untuk setiap transfer, berurutan. Langkah pertama yang gagal langsung menentukan barisnya:
    1. Ambil rekening `ke` dengan `ambilRekening`, dibatasi 200 ms dengan `denganBatasWaktu`. Gagal: `GAGAL: <pesan error>`.
    2. Kirim `POST /transfer` dengan `fetchBank`. Status bukan sukses: `GAGAL: <status> <pesan>`.
    3. Berhasil: `OK: <nominalRupiah> ke <nama tujuan>, sisa <saldoDariRupiah>`.
  - Baris terakhir: `berhasil <jumlah OK> dari <jumlah transfer>`.
  - Contoh: transfer pertama mengirim `100000` dari 1001 (saldo `500000`) ke 1002 (Budi). Barisnya `OK: Rp100.000 ke Budi, sisa Rp400.000`, dan saldo Budi menjadi `175000`. Transfer keempat menuju 1004, yang datanya butuh 400 ms, jadi barisnya `GAGAL: waktu habis`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`: langkah untuk setiap transfer, di mana `await` dan `try...catch` diletakkan, dan mengapa antrean ini *tidak boleh* memakai `Promise.all` seperti Intermediate 2. Jelaskan juga cara kerja `Promise.race` untuk batas waktu: Promise apa saja yang dibalap, dan apa yang terjadi pada permintaan ke server yang lambat setelah waktu habis?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(await prosesAntrian(antrian))`][```txt
  OK: Rp100.000 ke Budi, sisa Rp400.000
  GAGAL: 404 rekening tidak ditemukan
  GAGAL: 400 saldo tidak cukup
  GAGAL: waktu habis
  GAGAL: 400 nominal tidak valid
  OK: Rp175.000 ke Ani, sisa Rp0
  berhasil 2 dari 6
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-js7.js`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-js7.js coba`.
  - Jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
