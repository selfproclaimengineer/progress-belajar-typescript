# Feedback JS-5

Diperiksa 2026-11-22. Kode dijalankan dengan `node Jawaban/soal-js5.js` dan `node Jawaban/soal-js5.js coba`, lalu dicocokkan dengan kotak output di soal. Kasus tepi Advanced diuji terpisah di salinan kode.

Ringkasan: semua output Beginner 1 sampai Intermediate 3 cocok. Di Advanced hanya dua baris `buka` yang beda. Dua jawaban *(jelaskan)* belum tepat: Beginner 4 kehilangan bagian kedua, dan penjelasan Intermediate 3 salah konsep. Advanced dikerjakan lewat bagian (b), kode, sesuai aturan baru (pilih salah satu dari (a) atau (b)).

Catatan konteks: soal dikerjakan dengan banyak hint, termasuk dua contoh lengkap bukan soal (`Termos` untuk Intermediate 3 dan `Perpustakaan` untuk Advanced). Lihat `DISKUSI.md`.

## Coba Sendiri (tidak dinilai)

- Nomor 1 dan 2 benar.
- Nomor 3: isi `this` benar (`undefined`), tetapi alasan "karena di console malah jadi function" kurang tepat. Alasannya: `lepas()` dipanggil tanpa object di kiri titik, jadi `this` tidak menunjuk ke `k`. Ini konsep yang sama dengan Intermediate 3.
- Nomor 4: pesan error benar, tetapi alasannya belum ditulis. `k.namaBesar` sudah menjalankan getter dan menghasilkan string `"OYEN"`. Tanda `()` sesudahnya lalu mencoba memanggil string itu sebagai fungsi.

## Beginner — 86/100

**1. Benar.** Field privat `#saldo`, getter, dan `info()` lewat `this` sudah tepat.

**2. Benar.** Guard clause untuk nominal 0 atau negatif, dan saldo hanya berubah jika lolos cek.

**3. Benar.** Urutan cek sudah sesuai. Format pesan sudah persis setelah beberapa revisi.

**4. Sebagian.**
- Pesan error benar: `TypeError: Cannot set property saldo of #<Rekening> which has only a getter`.
- Bagian pertama mengarah benar. `r.saldo` memanggil getter, dan untuk mengubahnya dibutuhkan setter. Contoh setter-mu masih keliru. Setter ditulis dengan kata kunci `set` (bukan `get`) dan dijalankan oleh assignment `r.saldo = 100000`, bukan dipanggil dengan `()`.
- Bagian kedua, "apa yang terjadi di aplikasi bank jika `saldo` publik", sekarang hilang. Yang perlu ditulis: siapa pun bisa menulis saldo apa saja, termasuk angka negatif atau uang yang tidak pernah disetor. Cek di `setor`/`tarik` terlewati, dan tidak ada jejak transaksi. Ini persis masalah "saldo dicoret lalu ditulis ulang" di cerita klien.

## Intermediate — 83/100

**1. Benar.** `super(...)` di constructor, bunga masuk lewat `setor` warisan, dan sudah dibulatkan dengan `Math.floor` (diuji dengan saldo 1234567: bunga 24691). Catatan desain: field `#bunga` dan getter `bunga` tidak diperlukan. Variabel lokal di dalam `tambahBunga()` sudah cukup. Spesifikasi hanya menambah `bungaPersen`, dan sekarang `budi.bunga` terbuka ke luar.

**2. Benar.** `super.info()` dipanggil, isi `info()` induk tidak disalin.

**3. Sebagian.** Perbaikan kode benar: `forEach((p) => rek.setor(p))`, output `100000`. Penjelasannya salah konsep. `forEach` sudah memberikan setiap nominal ke callback, jadi masalahnya bukan "`rek.setor` belum mengandung informasi dari `daftarNominal`". Masalahnya: `forEach(rek.setor)` hanya menyerahkan fungsi `setor` tanpa `rek`. Saat `forEach` memanggilnya, tidak ada object di kiri titik, jadi `this` bernilai `undefined` dan `this.#saldo` error. Arrow function memperbaikinya karena di dalamnya `setor` dipanggil sebagai `rek.setor(p)`.

## Advanced — 75/100

Dikerjakan lewat bagian (b), kode.

**1. Sebagian.**
- `buka`: menyimpan object `rek` sudah benar, tetapi output kurang kata `dibuka` (`Rekening 1001`, seharusnya `Rekening 1001 dibuka`).
- `cari`: jalan, tetapi callback `find` mengembalikan `p.nomor` atau `undefined`. Hasilnya benar karena `find` hanya butuh nilai truthy. Cukup tulis perbandingannya: `(p) => p.nomor === nomor`.
- `transfer`: semua output di soal cocok, termasuk saldo akhir `500000 1150000 1650000`. Ada dua masalah yang tidak terlihat di output:
  - Cek saldo cukup ditulis ulang (`nominal > saldoDari.saldo`), padahal spesifikasi meminta pesan `GAGAL` dari `tarik` dikembalikan apa adanya. Jika aturan `tarik` berubah, `transfer` tertinggal.
  - Akibatnya, cek nominal di `tarik` ikut terlewat. `transfer("1", "2", -5)` dan `transfer("1", "2", 0)` menghasilkan `Transfer -5 dari 1 ke 2 berhasil`, padahal tidak ada uang yang berpindah. `tarik` sebenarnya menolak, tetapi hasilnya tidak dibaca. Perbaikan: simpan hasil `tarik`, lalu jika diawali `"GAGAL"` (`startsWith`), kembalikan hasil itu.
- `totalSaldo`: benar. `map` lalu `reduce` boleh. `reduce` saja juga cukup.

## Pertanyaan diskusi

Di `transfer`, kamu memanggil `tarik` dulu, baru `setor`. Misalkan urutannya dibalik: `setor` ke tujuan dulu, lalu `tarik` dari pengirim, dan `tarik` ternyata gagal. Apa yang terjadi pada total uang di bank? Kaitkan dengan kebutuhan klien bahwa tidak boleh ada uang yang hilang atau tercipta.

Total: 80
