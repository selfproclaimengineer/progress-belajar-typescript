# Diskusi JS-5

### 2026-11-15 — Coba Sendiri 1–4 (pemeriksaan)
**Pertanyaan:** Dion minta Coba Sendiri diperiksa. Bingung kenapa `typeof Kucing` mencetak `function`, kenapa `suara` tidak ikut di JSON, isi `this` di `lepas()`, dan error di nomor 4.
**Level hint:** 1–2 (pemeriksaan dan penjelasan konsep)
**Jawaban asisten:** Tebakan baris 2 (`class true`) dan baris 5 (`{"nama":"Oyen","meong"}`) salah. Class di JS adalah function khusus, jadi `typeof` mencetak `function`. Method tersimpan di prototype (bersama untuk semua object), bukan di object; `JSON.stringify` hanya menyalin field milik object sendiri, dan function tidak pernah ikut. Nomor 3: error benar, tetapi `this` saat `lepas()` adalah `undefined`, bukan Oyen, karena tidak ada object di depan titik. Nomor 4: `console.log(k.namaBesar)` ditaruh di luar `cobaSendiri()`, jadi `ReferenceError: k is not defined` (scope), bukan error yang sama dengan nomor 3; dipindah ke dalam fungsi mencetak `OYEN`. Pertanyaan "mengapa tanpa ()" belum dijawab, diberi hint level 1.

### 2026-11-15 — Coba Sendiri 1–4 (pemeriksaan revisi)
**Pertanyaan:** Dion merevisi jawaban Coba Sendiri dan minta dicek lagi.
**Level hint:** 1
**Jawaban asisten:** Nomor 1 dan 2 sudah benar. Nomor 3: isi `this` sudah benar (`undefined`), alasannya belum ditulis (tidak ada object di depan titik saat `lepas()` dipanggil). Nomor 4: pesan error `k.namaBesar is not a function` benar, alasannya belum; hint: `k.namaBesar` sudah menghasilkan apa, lalu `()` mencoba memanggil apa.

### 2026-11-22 — Ringkasan topik 5 (pengantar)
**Pertanyaan:** Dion minta ringkasan JS-5 sebagai jembatan dari JS-1 sampai JS-4 dan menanyakan status pengerjaan.
**Level hint:** - (ringkasan materi, tanpa jawaban soal)
**Jawaban asisten:** Status: Coba Sendiri 1–4 sudah dijawab (nomor 3 dan 4 belum ada alasan), soal belum dikerjakan. Benang merah: guard clause JS-1 untuk `setor`/`tarik`, fungsi JS-2 menjadi method, `find`/`reduce` JS-3 untuk `Bank`, object literal JS-4 menjadi cetakan class. Enam konsep sesuai urutan HO (class/constructor/new, `this` dan jebakan callback, `#privat` dan getter, `extends`/`super`, override, class yang menyimpan object lain) dengan analogi SQL. Peta tugas ke konsep beserta estimasi baris, dan urutan kerja yang disarankan.

### 2026-11-22 — Beginner 1 (cara berpikir class)
**Pertanyaan:** Pertama kali memakai OOP di JS, kagok karena contoh langsung memakai constructor. Minta thought process untuk mengerjakan Beginner 1.
**Level hint:** 4 (contoh lengkap dengan data bukan soal, atas permintaan penjelasan dari nol)
**Jawaban asisten:** Contoh `Baterai`, dibangun bertahap: object literal (JS-4), fungsi pabrik (JS-2), class dengan `constructor` dan langkah kerja `new`, lalu field privat `#persen`, getter, dan method `info()`. Analogi C: `constructor` = fungsi init, `this` = pointer `self`, `new` = malloc lalu init, `#field` = struct opaque. Tabel cara menerjemahkan setiap poin spesifikasi menjadi potongan kode. Aturan: di dalam class semua data object dibaca lewat `this.`. Status Beginner 1 saat itu: `#saldo` sudah benar, `nomor`/`pemilik` belum disimpan, getter dan `info()` belum.

### 2026-11-22 — Beginner 1 (pemeriksaan, kenapa masih error)
**Pertanyaan:** Beginner 1 sudah dikerjakan tetapi masih error. Apakah file jawaban tertimpa, karena estimasi baris tidak terlihat di kode?
**Level hint:** 1
**Jawaban asisten:** Constructor dan `get saldo()` sudah benar (output `500000` keluar). `info()` masih `TODO` atau belum di-save, jadi baris pertama kosong. Error `Must call super constructor in derived class...` berasal dari constructor `Tabungan` (Intermediate 1) yang masih kosong, bukan dari Beginner 1, dan akan hilang saat Intermediate 1 dikerjakan. File tidak tertimpa: `git diff` hanya berisi perubahan Dion, dan estimasi baris saat itu hanya ada di PDF soal.

### 2026-11-22 — Estimasi baris di kode (permintaan)
**Pertanyaan:** Minta estimasi baris ditaruh di bawah setiap `TODO` supaya tidak perlu membuka soal.
**Level hint:** - (perubahan starter)
**Jawaban asisten:** Baris `// ≈ N baris` ditambahkan di bawah setiap `TODO` di starter dan `Jawaban/` JS-5 sampai JS-8 dan TS-1 sampai TS-7, dihitung dari kunci dengan aturan yang sama seperti di soal (dari judul fungsi sampai `}`). Kode Dion tidak diubah.

### 2026-11-22 — Checkpoint Beginner 1–4 (pemeriksaan)
**Pertanyaan:** Dion minta Beginner 1–4 diperiksa.
**Level hint:** 1
**Jawaban asisten:** Beginner 1 benar. Logika `setor` dan `tarik` benar (urutan cek, saldo berubah hanya saat lolos), tetapi format string belum persis: ada spasi sebelum koma (`Setor 250000 , saldo`, `Tarik 100000 , saldo`) dan pesan saldo kurang tertulis `Saldo tidak cukup(sisa ...)`, padahal soal meminta `saldo` huruf kecil dan spasi sebelum `(`. Format ini penting karena `Bank.transfer` di Advanced meneruskan pesan `tarik` apa adanya. Beginner 4: pesan error benar. Alasan "karena typenya private" kurang tepat: `r.saldo` menunjuk ke getter `saldo` yang publik tetapi tidak punya setter, bukan ke `#saldo`. Bagian "apa yang terjadi jika publik" sudah mengarah benar (semua kode luar bisa mengubah), tetapi masih umum ("rentan vulnerabilitas"); hint: aturan apa di `setor`/`tarik` yang dilewati jika saldo bisa ditulis langsung. Coba Sendiri 3 dan 4 masih belum ada alasan.

### 2026-11-22 — Checkpoint Beginner (pemeriksaan revisi)
**Pertanyaan:** Dion memperbaiki format dan alasan Beginner 4, minta dicek lagi.
**Level hint:** 2
**Jawaban asisten:** Spasi sebelum koma di `setor`/`tarik` sudah benar. Pesan saldo kurang masih beda: `Saldo` masih huruf besar dan tanda `(` sekarang hilang. Beginner 4: tambahan "r.saldo memanggil getter" sudah benar, tetapi kalimat "karena typenya private" masih ada dan bertentangan; kunci yang belum ditulis adalah getter tanpa setter (diberi petunjuk: kata kunci `set`, lihat HO bagian Getter dan Field Privat). Bagian "jika saldo publik" belum direvisi; diberi pertanyaan: apa yang terjadi pada saldo jika ditulis `r.saldo = -500000`, dan cek apa di `setor`/`tarik` yang dilewati. Coba Sendiri 3 dan 4 masih tanpa alasan.

### 2026-11-22 — Checkpoint Beginner (pemeriksaan revisi 2)
**Pertanyaan:** Dion memperbaiki pesan saldo kurang dan Beginner 4, minta dicek lagi.
**Level hint:** 2–4 (format pesan ditunjukkan per karakter; sintaks setter dengan contoh bukan soal)
**Jawaban asisten:** Huruf kecil `saldo` sudah benar, tetapi kurung masih salah tempat (`sisa (650000)`, seharusnya `(sisa 650000)`). Beginner 4: konsep "harus memakai setter" sudah benar. Contoh setter yang ditulis keliru: memakai kata kunci `get` dan dipanggil seperti method `r.def_saldo(100000)`; setter memakai `set` dan dijalankan lewat assignment `obj.x = nilai`, diberi contoh `Baterai`. Bagian kedua soal (apa yang terjadi jika saldo publik) sekarang terhapus dan perlu ditulis lagi, dikaitkan dengan cek di `setor`/`tarik`.

### 2026-11-22 — Intermediate 1 (kenapa NaN)
**Pertanyaan:** `tambahBunga()` memakai `this.bungaPersen` tetapi hasilnya `NaN`.
**Level hint:** 2
**Jawaban asisten:** `this.bungaPersen` sudah benar (bernilai 2). `NaN` berasal dari `super.saldoAwal`: `saldoAwal` hanya parameter constructor yang hilang setelah constructor selesai, bukan field, sehingga bernilai `undefined`, dan `undefined * 2` adalah `NaN`. Saldo saat ini dibaca lewat getter warisan `this.saldo`. Hint lanjutan: `bungaPersen` 2 berarti 2 persen (perlu dibagi 100 dan dibulatkan ke bawah, HO JS-6 `Math`); `#saldoBaru` adalah field baru milik `Tabungan`, bukan saldo asli, terbukti `tarik(20000)` menghasilkan 980000; bunga harus masuk lewat method warisan yang menambah saldo. `super(...)` di constructor sudah benar.

### 2026-11-22 — Intermediate 1 (bunga 20000 lalu 20400)
**Pertanyaan:** `this.bunga` dibaca dua kali, pertama 20000, kedua 20400. Kenapa beda?
**Level hint:** 2 (penjelasan konsep getter dan tabel urutan baca)
**Jawaban asisten:** `bunga` adalah getter, jadi dihitung ulang setiap kali dibaca, bukan nilai yang tersimpan. Bacaan pertama sebelum `setor` memakai saldo 1000000 (20000). Bacaan kedua di template string terjadi setelah `setor`, saat saldo sudah 1020000 (20400). Hint: hitung bunga sekali, simpan di variabel lokal, lalu pakai variabel itu untuk `setor` dan string. Pembulatan ke bawah belum ada; `#bunga` tidak terpakai.

### 2026-11-22 — Intermediate 1 (pemeriksaan)
**Pertanyaan:** Dion minta `Tabungan` diperiksa setelah memperbaiki bunga.
**Level hint:** 1–2
**Jawaban asisten:** Output Intermediate 1 sudah sama dengan soal. Masih kurang pembulatan ke bawah (`Math.floor`), yang akan terlihat jika saldo menghasilkan pecahan. Bunga disimpan di field `#bunga` plus getter `bunga`: hasilnya benar, tetapi menambah state yang tidak diminta soal (`Tabungan` hanya menambah `bungaPersen`); variabel lokal sudah cukup. Masih terbuka: pesan saldo kurang di Beginner 3 (`sisa (650000)`), Beginner 4 bagian kedua dan contoh setter, Coba Sendiri 3–4.

### 2026-11-22 — Intermediate 3 (forEach pada daftarNominal)
**Pertanyaan:** `daftarNominal` berisi array, kok bisa pakai `forEach`?
**Level hint:** 2
**Jawaban asisten:** Justru karena `daftarNominal` adalah array, `forEach` tersedia: `forEach` adalah method milik array (JS-3), yang memanggil callback sekali per elemen dengan argumen `(elemen, index, array)`. Diberi padanan `for...of` dan tabel putaran untuk `[50000, 20000, 30000]`. Padanan itu memperlihatkan bahwa `forEach(rek.setor)` sama dengan `const f = rek.setor; f(50000)`, yaitu kasus `lepas()` di Coba Sendiri 3: tidak ada object di kiri titik, jadi `this` undefined. Pertanyaan pancingan untuk perbaikan: di dalam callback, bagaimana `setor` dipanggil supaya ada object di kiri titik.

### 2026-11-22 — Intermediate 3 (cara memakai arrow function sebagai callback)
**Pertanyaan:** Bagaimana cara memakai arrow function untuk memperbaiki `forEach`?
**Level hint:** 4 (contoh lengkap dengan data bukan soal)
**Jawaban asisten:** Contoh `Termos` dengan method `isi(ml)`: `forEach(t.isi)` gagal karena hanya fungsinya yang diserahkan, sedangkan `forEach((ml) => t.isi(ml))` berhasil karena arrow function itu sendiri yang memanggil `t.isi(ml)` dengan `t` di kiri titik. Disertai tabel putaran dan pengingat bentuk arrow function dari JS-3 (`x => x * 2` di `map`). Tabel padanan contoh ke soal: `t` ke `rek`, `isi` ke `setor`, `[100, 250]` ke `daftarNominal`.

### 2026-11-22 — Intermediate 3 (pemeriksaan kode)
**Pertanyaan:** `forEach((p) => rek.setor(p))` menghasilkan 100000, apakah sudah benar?
**Level hint:** 1
**Jawaban asisten:** Kode benar: output 100000 sesuai soal, dan perbaikannya tepat karena arrow function memanggil `setor` dengan `rek` di kiri titik. Bagian *(jelaskan)* belum dijawab: `// JAWABAN Intermediate 3` masih berisi `console.log(rek.setor(50000))`. Diminta menulis alasan error versi lama dan alasan versi baru berhasil. Komentar `rek.setor(...)` sisa coba-coba boleh dihapus.

### 2026-11-22 — Advanced 1 (hubungan Bank dengan class sebelumnya)
**Pertanyaan:** Apakah kode Advanced nyambung dengan sebelumnya? Bagian tanpa TODO tidak perlu ditambah? `Bank` independen, tanpa `extends`?
**Level hint:** 1
**Jawaban asisten:** Benar, `Bank` tidak memakai `extends`, karena Bank bukan sejenis rekening; Bank *menyimpan* banyak rekening (belah ketupat di UML, relasi satu-ke-banyak, bukan segitiga). Tetapi tetap nyambung: `daftar` berisi object `ani` (Rekening) dan `budi` (Tabungan) yang sama dari tugas sebelumnya, saldo terbawa (650000 dan 1000000), dan method `Bank` memakai `nomor`, `saldo`, `tarik`, `setor` milik object itu. `Tabungan` bisa masuk karena turunan `Rekening`. Constructor tanpa TODO memang sudah lengkap. Yang wajib hanya bagian (a), pendekatan di komentar; kode opsional. Ditemukan `` `Rekening ${}` `` di `buka` yang membuat seluruh file SyntaxError.

### 2026-11-22 — Advanced 1 (transfer: menentukan object dari nomor)
**Pertanyaan:** Nyangkut di `transfer`. Apakah konsepnya seperti foreign key, dan bagaimana menentukan bahwa object yang diubah adalah rekening 1001 dan 2001?
**Level hint:** 4 (contoh lengkap bukan soal: `Perpustakaan` dengan `cari` memakai `find` dan method yang mencari dua object lewat kunci)
**Jawaban asisten:** Ya, mirip: `nomor` adalah primary key, `dariNomor`/`keNomor` adalah nilai kunci yang dicari, dan `cari(nomor)` adalah `SELECT ... WHERE nomor = ?` lewat `this.daftar.find(...)` (pola JS-3). `transfer` tidak mencari sendiri, tetapi memanggil `this.cari(...)` dua kali. Kesalahan di kode: `buka` menyimpan `rek.pemilik` (string) padahal harus object-nya, dan output kurang kata `dibuka`; `cari` memakai `rek` yang tidak ada di scope `cari` dan mengembalikan nomor, bukan object; di `transfer`, `this` adalah object bank sehingga `this.rek` undefined, dan pengurangan langsung tidak mengubah `#saldo` (harus lewat `tarik`/`setor`).

### 2026-11-22 — Advanced 1 (cari selalu undefined)
**Pertanyaan:** Kenapa `cari` selalu mengembalikan `undefined`?
**Level hint:** 2–3
**Jawaban asisten:** Di dalam method `Bank`, `this` adalah object bank, yang hanya punya `daftar`, jadi `this.nomor` undefined dan `"1001" !== undefined` selalu true. `cari` harus memeriksa setiap rekening di `this.daftar` (pola `find` seperti contoh `Perpustakaan`). Akar kedua: `buka` masih menyimpan `rek.pemilik`, sehingga `daftar` berisi `["Ani", "Budi"]` dan `find` dengan `r.nomor` tetap tidak menemukan apa pun; diberi cara cek `console.log(this.daftar)`. Catatan `transfer`: `saldoDari.saldo = ...` akan kena error getter seperti Beginner 4, pengirim seharusnya `tarik` bukan `setor`, dan baris `this.rek...` perlu dihapus.

### 2026-11-22 — Advanced 1 (proteksi tarik tidak terbawa ke transfer?)
**Pertanyaan:** `tarik` sudah punya proteksi, kenapa tidak terbawa ke `transfer`? Apakah harus menulis ulang ceknya?
**Level hint:** 2
**Jawaban asisten:** Proteksi tetap jalan: `tarik` menolak dan saldo tidak berubah. Tetapi `tarik` tidak menghentikan pemanggilnya; ia hanya mengembalikan string `GAGAL: ...`, dan `transfer` mengabaikan nilai kembalian itu lalu tetap lanjut. Cek tidak perlu ditulis ulang, cukup simpan dan periksa hasil `tarik` (hint method string `startsWith`). Ditemukan juga peran tertukar: pengirim di-`setor` dan penerima di-`tarik`; output membuktikan uang tercipta (ani 1799999 padahal transfer 999999 seharusnya gagal). Urutan `tarik` sebelum `setor` dibiarkan untuk dijawab di 1a. `buka` masih kurang kata `dibuka`, `totalSaldo` belum.

### 2026-11-22 — Advanced 1 (kenapa tarik gagal tidak memunculkan error)
**Pertanyaan:** `saldoKe.tarik(nominal)` tetap lewat dan tidak ada error yang muncul.
**Level hint:** 2
**Jawaban asisten:** `GAGAL: ...` adalah string yang di-`return`, bukan error yang di-`throw` (dibandingkan dengan `throw`/`try...catch` di HO JS-6). Bagi JS, mengembalikan string gagal sama normalnya dengan mengembalikan string sukses, jadi tidak ada pesan merah dan program lanjut. Kode saat itu: `tarik` dipanggil dua kali (dua kali penarikan saat berhasil), `!== undefined` selalu true karena `tarik` selalu mengembalikan string, peran pengirim/penerima masih tertukar, dan ada `console.log(saldoKe)` debug. Hint: panggil `tarik` sekali, simpan hasilnya, periksa awalan `GAGAL` dengan `startsWith`.

### 2026-11-22 — Advanced 1 (hasil transfer terbawa ke pemanggilan berikutnya)
**Pertanyaan:** Hasil transfer berbeda dari soal, seolah hasil soal sebelumnya masuk ke soal berikutnya.
**Level hint:** 2 (tabel jalannya per pemanggilan)
**Jawaban asisten:** Terbawanya saldo memang disengaja (perhatian poin 5 di soal): angka `sisa 500000` di transfer ketiga bergantung pada transfer pertama yang sudah memindahkan 150000. Masalahnya, transfer pertama di kode Dion tidak memindahkan apa pun: uang ditarik dari `saldoDari` lalu disetor kembali ke `saldoDari`, bukan ke `saldoKe`, jadi ani tetap 650000 dan budi tetap 1000000. Cek saldo ditulis ulang setelah `tarik`, bukan membaca hasil `tarik`; hint `startsWith` diulang. `cari` jalan tetapi callback `find` sebaiknya mengembalikan boolean. `totalSaldo` benar. Sisa: `buka` kurang `dibuka`, Intermediate 2 kurang `%`, `console.log` debug di `transfer`.

### 2026-11-22 — Advanced 1 (bantahan: "ada yang nambah 150000")
**Pertanyaan:** Dion melihat ada saldo yang bertambah 150000 dan total sama, jadi merasa transfer sudah benar.
**Level hint:** 2 (bukti dengan salinan kode yang diberi log saldo, file Dion tidak diubah)
**Jawaban asisten:** Ditunjukkan log saldo per langkah: awal ani 650000 budi 1000000, setelah `tarik` ani 500000, setelah `setor` ani kembali 650000, budi tetap 1000000. Yang bertambah 150000 adalah ani sendiri, karena `setor` dipanggil pada `saldoDari`. Total sama karena uang kembali ke pemiliknya, jadi total tidak bisa dipakai untuk membuktikan transfer benar. Pembuktian yang tepat adalah `budi.saldo` setelah transfer (soal: 1150000).
