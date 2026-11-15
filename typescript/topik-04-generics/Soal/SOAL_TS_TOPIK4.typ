#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal TypeScript Modul 4", judul: "Generics")

= Tugas

Klinik Sehat Bersama punya tiga poli: umum, gigi, dan anak. Aplikasi pendaftarannya ditulis oleh beberapa programmer secara bergantian. Akibatnya ada tiga fungsi yang isinya hampir sama: `cariPasien`, `cariDokter`, dan `cariObat`. Saat bug di `cariPasien` diperbaiki, dua fungsi lainnya terlupa. Programmer berikutnya mencoba menggabungkan ketiganya menjadi satu fungsi bertipe `any`. Kodenya jadi pendek, tetapi `tsc` berhenti memeriksa. Jadwal dokter sempat menampilkan spesialis `undefined` karena salah ketik nama field yang tidak tertangkap.

Pemilik klinik ingin satu fungsi yang bisa dipakai untuk pasien, dokter, dan data lain, *tanpa* kehilangan pemeriksaan tipe. Kamu diminta menulis fungsi dan class serbaguna dengan generics.

#figure(
  table(
    columns: 5,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*id*], [*nama*], [*umur*], [*poli*], [*telepon*],
    [PS01], [Sari], [34], [umum], [081211110001],
    [PS02], [Budi], [52], [gigi], [081211110002],
    [PS03], [Wati], [8], [anak], [081211110003],
    [PS04], [Dodi], [41], [umum], [081211110004],
    [PS05], [Rina], [29], [gigi], [081211110005],
    [PS06], [Tono], [5], [anak], [081211110006],
    [PS07], [Lina], [63], [umum], [081211110007],
  ),
  caption: [Data `daftarPasien` bertipe `Pasien[]`.],
)

#figure(
  table(
    columns: 3,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*id*], [*nama*], [*spesialis*],
    [DR01], [dr. Andi], [umum],
    [DR02], [drg. Maya], [gigi],
    [DR03], [dr. Fajar], [anak],
  ),
  caption: [Data `daftarDokter` bertipe `Dokter[]`.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan klinik dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Salin `Soal/starter.ts` ke `Jawaban/soal-ts4.ts`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah bagian `TIPE`, `DATA`, dan `PEMANGGILAN`.
  3. *Cek tipe dulu* dengan `npx tsc --noEmit`, lalu *jalankan* dengan `node Jawaban/soal-ts4.ts`.
  4. Saat baru disalin, `tsc` sudah menampilkan error `TS7006` dan `TS2558`. Itu disengaja. Error itu hilang setelah fungsi dan class diberi tipe generik sesuai komentar di atasnya.
  5. Jawaban dianggap selesai jika `npx tsc --noEmit` tidak menampilkan error *dan* output `node` sama persis dengan kotak *Output dari*.
  6. Jangan memakai `any` di kodemu sendiri. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Fungsi serbaguna.*
  #kebutuhan[
    Petugas pendaftaran sering perlu dua hal sederhana: melihat data yang paling akhir masuk, dan menghitung berapa data yang memenuhi syarat tertentu, misalnya pasien berumur 40 tahun ke atas. Kebutuhan yang sama muncul untuk daftar angka, daftar nama, dan daftar pasien. Klinik tidak mau menulis fungsi terpisah untuk setiap jenis data.

    *Dalam kode:* `terakhir` dan `hitungJika` memakai parameter tipe `T`. TypeScript mengisi `T` sesuai array yang dikirim, jadi hasilnya tetap bertipe benar.
  ]
  - `terakhir(daftar)`. Input: `daftar` array `T`. Output: `T`, atau `undefined` jika array kosong. Signature: `terakhir<T>(daftar: readonly T[]): T | undefined`.
  - `hitungJika(daftar, syarat)`. Input: `daftar` array `T`, `syarat` fungsi yang menerima satu `T` dan mengembalikan boolean. Output: number, banyaknya isi yang memenuhi `syarat`.
  - Contoh: `terakhir([3, 1, 4])` menghasilkan `4` bertipe number. `terakhir(daftarPasien)` menghasilkan object Lina bertipe `Pasien | undefined`, jadi `?.nama` boleh ditulis. `hitungJika(daftarPasien, (p) => p.umur >= 40)` menghitung Budi, Dodi, dan Lina, jadi hasilnya `3`.

  #keluaran[`console.log(terakhir([3, 1, 4]))`][```txt
  4
  ```]
  #keluaran[`console.log(terakhir(daftarPasien)?.nama)`][```txt
  Lina
  ```]
  #keluaran[`console.log(terakhir([]))`][```txt
  undefined
  ```]
  #keluaran[`console.log(hitungJika(daftarPasien, (p) => p.umur >= 40), hitungJika(["a", "bb", "ccc"], (s) => s.length > 1))`][```txt
  3 2
  ```]

+ *Cari berdasarkan id.*
  #kebutuhan[
    Pasien dan dokter sama-sama dicari lewat id. Inilah fungsi yang dulu ditulis tiga kali. Klinik ingin satu fungsi untuk semua data yang punya field `id`, dan `tsc` harus menolak jika fungsi itu dipakai untuk data tanpa `id`.

    *Dalam kode:* `cariById` memakai `T extends { id: string }`, artinya `T` boleh tipe apa saja *asalkan* punya field `id` bertipe string.
  ]
  - `cariById(daftar, id)`. Input: `daftar` array `T`, `id` string. Output: `T` yang id-nya sama, atau `undefined`.
  - Signature: `cariById<T extends { id: string }>(daftar: readonly T[], id: string): T | undefined`.
  - Contoh: `cariById(daftarDokter, "DR03")` menghasilkan object dr. Fajar bertipe `Dokter | undefined`, jadi `?.spesialis` menghasilkan `"anak"`. `cariById([1, 2], "1")` ditolak `tsc` karena number tidak punya `id`.

  #keluaran[`console.log(cariById(daftarPasien, "PS02")?.nama)`][```txt
  Budi
  ```]
  #keluaran[`console.log(cariById(daftarDokter, "DR03")?.spesialis)`][```txt
  anak
  ```]
  #keluaran[`console.log(cariById(daftarDokter, "DR09"))`][```txt
  undefined
  ```]

+ *(jelaskan)* Ini versi `any` milik programmer sebelumnya, dibandingkan dengan `cariById` milikmu:
  ```ts
  function cariByIdAny(daftar: any[], id: string): any {
    return daftar.find((x) => x.id === id);
  }
  console.log(cariByIdAny(daftarDokter, "DR03").spesialisasi);
  console.log(cariById(daftarDokter, "DR03")?.spesialisasi);
  ```
  Tempel kode itu sementara di akhir file, jalankan `npx tsc --noEmit` dan `node Jawaban/soal-ts4.ts`, lalu hapus lagi.
  - Tulis hasil `tsc` untuk setiap baris `console.log`, dan output `node`-nya.
  - Mengapa salah ketik `spesialisasi` lolos di versi `any`, tetapi tertangkap di versi generik?
  - Apa beda `T` dengan `any`, padahal keduanya sama-sama "bisa tipe apa saja"?

#level("Intermediate", "0.3")

+ *Kelompokkan data.*
  #kebutuhan[
    Kepala klinik ingin melihat pasien dikelompokkan per poli. Bagian farmasi ingin hal serupa untuk obat, dikelompokkan per huruf awal. Cara mengelompokkannya sama, hanya "kunci" pengelompokannya yang berbeda.

    *Dalam kode:* `kelompokkan` menerima array `T` dan fungsi `kunci` yang menentukan kelompok setiap isi. Hasilnya `Record<string, T[]>`: key nama kelompok, value array isi kelompok itu.
  ]
  - `kelompokkan(daftar, kunci)`. Input: `daftar` array `T`, `kunci` fungsi dari `T` ke string. Output: `Record<string, T[]>`.
  - Urutan key mengikuti urutan kelompok pertama kali muncul. Urutan isi setiap kelompok mengikuti urutan data.
  - Contoh: `kelompokkan(["apel", "anggur", "jeruk"], (s) => s[0])`: `"apel"` dan `"anggur"` berkunci `"a"`, `"jeruk"` berkunci `"j"`.

  #keluaran[`const perPoli = kelompokkan(daftarPasien, (p) => p.poli);` lalu `console.log(Object.keys(perPoli).join(", "))`][```txt
  umum, gigi, anak
  ```]
  #keluaran[`console.log((perPoli["gigi"] ?? []).map((p) => p.nama).join(", "))`][```txt
  Budi, Rina
  ```]
  #keluaran[`console.log(JSON.stringify(kelompokkan(["apel", "anggur", "jeruk"], (s) => s[0])))`][```txt
  {"a":["apel","anggur"],"j":["jeruk"]}
  ```]

+ *Antrian.*
  #kebutuhan[
    Setiap poli punya antrian: yang datang lebih dulu dipanggil lebih dulu. Antrian poli umum berisi data pasien lengkap, sedangkan antrian loket berisi nomor karcis berupa teks. Klinik ingin satu class antrian untuk keduanya, dan antrian pasien tidak boleh kemasukan data yang bukan pasien.

    *Dalam kode:* `class Antrian<T>`. Jenis isi antrian ditentukan saat dibuat: `new Antrian<Pasien>()` atau `new Antrian<string>()`.
  ]
  - `class Antrian<T>`:
    - Field `isi`: array `T`, `private`, awalnya kosong.
    - `masuk(x)`. Input: `x` bertipe `T`. Menambah `x` di belakang antrian. Output: `void`.
    - `panggil()`. Output: `T` paling depan, sekaligus dikeluarkan dari antrian. Antrian kosong menghasilkan `undefined`.
    - `get jumlah()`. Output: number, banyaknya isi antrian.
    - `lihatSemua()`. Output: array `T` yang hanya bisa dibaca (`readonly T[]`).
  - Contoh: Sari, Dodi, dan Lina masuk berurutan. `panggil()` mengeluarkan Sari, sehingga tersisa Dodi dan Lina. `new Antrian<string>().masuk(5)` ditolak `tsc`.

  #keluaran[`console.log(antrianUmum.jumlah)` setelah tiga pasien masuk][```txt
  3
  ```]
  #keluaran[`console.log(antrianUmum.panggil()?.nama)`][```txt
  Sari
  ```]
  #keluaran[`console.log(antrianUmum.lihatSemua().map((p) => p.nama).join(", "))`][```txt
  Dodi, Lina
  ```]
  #keluaran[`antrianNomor.masuk("A-001");` lalu `console.log(antrianNomor.panggil(), antrianNomor.panggil())`][```txt
  A-001 undefined
  ```]

+ *Kode temanmu: `perbaruiPasien(p, perubahan)`.*
  #kebutuhan[
    Petugas bisa memperbarui sebagian data pasien, misalnya nomor telepon saja, atau telepon dan umur. Id pasien tidak boleh ikut diubah karena dipakai di rekam medis. Temanmu menulis fiturnya dengan `perubahan: any`. Akibatnya salah ketik seperti `{ umr: 53 }` diterima tanpa protes, id bisa diganti, dan data pasien di `daftarPasien` ikut berubah, padahal fungsi itu seharusnya mengembalikan *salinan* yang sudah diperbarui.

    *Dalam kode:* tipe `perubahan` dibentuk dari `Pasien` dengan utility type: tanpa field `id` (`Omit`), dan semua field boleh tidak ditulis (`Partial`). Isi fungsi membuat object baru, bukan mengubah `p`.
  ]
  - Output yang benar: `Pasien` baru berisi data `p` yang ditimpa isi `perubahan`. Object `p` tidak berubah.
  - `perubahan` boleh berisi sebagian field `Pasien`, kecuali `id`.
  - Setelah diperbaiki, coba panggil `perbaruiPasien(daftarPasien[1], { id: "PS99" })` dan `perbaruiPasien(daftarPasien[1], { umr: 53 })` di `cobaSendiri()`. Keduanya harus ditolak `tsc`. Hapus lagi setelah dicoba.
  - Contoh: `perbaruiPasien(Budi, { telepon: "081299990000", umur: 53 })` menghasilkan object Budi dengan telepon dan umur baru. `daftarPasien[1].umur` tetap `52`.
  - *(jelaskan)* Tulis tipe `perubahan` yang kamu pakai dan baca dari dalam ke luar: apa hasil `Omit` dulu, lalu apa yang dilakukan `Partial` terhadapnya? Mengapa kode temanmu mengubah `daftarPasien`?

  #keluaran[`console.log(JSON.stringify(perbaruiPasien(daftarPasien[1], { telepon: "081299990000", umur: 53 })))`][```txt
  {"id":"PS02","nama":"Budi","umur":53,"poli":"gigi","telepon":"081299990000"}
  ```]
  #keluaran[`console.log(daftarPasien[1].umur)`][```txt
  52
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Halaman data.*
  #kebutuhan[
    Daftar pasien di layar petugas terlalu panjang jika ditampilkan sekaligus. Klinik ingin daftar ditampilkan per halaman, dengan keterangan halaman ke berapa dari berapa, dan apakah masih ada halaman berikutnya. Fitur yang sama dipakai untuk daftar dokter. Halaman yang diminta di luar jangkauan menampilkan halaman kosong, bukan error.

    *Dalam kode:* `paginasi` menghasilkan object bertipe `Halaman<T>` (interface generik, sudah ada di starter). `cetakHalaman` (sudah ada) mengubahnya menjadi satu baris teks.
  ]
  - `paginasi(daftar, halaman, perHalaman)`. Input: `daftar` array `T`, `halaman` number (mulai dari `1`), `perHalaman` number. Output: `Halaman<T>`:
    - `isi`: isi `daftar` untuk halaman itu. Halaman di luar jangkauan berisi array kosong.
    - `halaman`: nomor halaman yang diminta.
    - `totalHalaman`: banyak data dibagi `perHalaman`, dibulatkan ke atas.
    - `adaBerikutnya`: `true` jika `halaman` lebih kecil dari `totalHalaman`.
  - Contoh: 7 pasien dengan `perHalaman` `3` menghasilkan `totalHalaman` `3`. Halaman `1` berisi pasien urutan 1 sampai 3. Halaman `3` hanya berisi Lina.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`: langkah-langkahnya, rumus indeks awal dan akhir isi halaman, method array yang dipakai, dan *tipe data* di setiap langkah. Jelaskan juga: mengapa `Halaman<T>` lebih baik daripada `Halaman` dengan `isi: any[]`? Apa yang hilang di baris `(p) => p.nama` jika memakai `any`?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(cetakHalaman(paginasi(daftarPasien, 1, 3), (p) => p.nama))`][```txt
  Halaman 1/3: Sari, Budi, Wati (berikutnya ada)
  ```]
  #keluaran[`console.log(cetakHalaman(paginasi(daftarPasien, 3, 3), (p) => p.nama))`][```txt
  Halaman 3/3: Lina
  ```]
  #keluaran[`console.log(cetakHalaman(paginasi(daftarDokter, 2, 2), (d) => d.nama))`][```txt
  Halaman 2/2: dr. Fajar
  ```]
  #keluaran[`console.log(cetakHalaman(paginasi(daftarPasien, 5, 3), (p) => p.nama))`][```txt
  Halaman 5/3: (kosong)
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-ts4.ts`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-ts4.ts coba`.
  - Pastikan `npx tsc --noEmit` bersih, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
