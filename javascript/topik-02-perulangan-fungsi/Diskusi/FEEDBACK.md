# Feedback JS-2

Diperiksa 2026-11-02. Kode dijalankan dengan `node Jawaban/soal-js2.js` dan `node Jawaban/soal-js2.js coba`, lalu dicocokkan dengan Contoh Output dan kunci asisten. Beberapa input tambahan juga dicoba.

Ringkasan: 21 dari 24 baris output cocok. Yang belum cocok: Beginner 2, Intermediate 1 (satu baris), dan Intermediate 2.

## Coba Sendiri (tidak dinilai)

- Kamu mencatat sendiri tebakan yang meleset. Penjelasan `NaN` (`nilai[3]` bernilai `undefined`) benar.
- `for...in` memberi *index* sebagai string (`"0"`, `"1"`), bukan value. `for...of` memberi value.
- Jawaban 3 benar: `const` tidak bisa dipakai sebelum baris deklarasinya (`ReferenceError`), sedangkan `function` biasa bisa karena hoisting.

## Beginner — 80/100

**1. Benar.** Output cocok.

**2. Salah.** Output `Masuk: 3, Keluar: 3`, seharusnya `Masuk: 1575000, Keluar: 520000`. Catatan dari sesi tanya jawab belum diterapkan: "jumlah" berarti total nominal, bukan banyaknya. Tanda masuk dan keluar juga masih tertukar. Ganti juga nama `X/Y/Z` dengan nama yang bermakna.

**3. Benar.** Penjelasan dan dua cara perbaikan sudah tepat.

## Intermediate — 62/100 (sebelum revisi)

**1. Sebagian.** 3 dari 4 baris cocok. `bulanMencapaiTarget(0, 250000, 0, 1000000)` menghasilkan `5`, seharusnya `4`. Saldo tepat `1000000` di bulan 4, tetapi perulangan tetap jalan. Periksa kondisi `while`, lalu baca lagi kata "minimal" di soal.
- Kondisi `-1` sudah benar. Bagian "apa yang terjadi jika tidak dicek" belum dijawab.
- Fungsi ini harus mengembalikan number. Mengembalikan string saat input bukan bilangan bulat melanggar tipe output.

**2. Sebagian.** Kode belum diperbaiki, jadi hasilnya masih `375000`.
- Kamu baru menemukan satu kesalahan (batas akhir). Kesalahan kedua ada di titik awal perulangan.
- Bagian "mengapa `NaN`, bukan error" belum dijawab.
- Versi `for...of` baru ada di komentar. Soal meminta fungsi ditulis ulang di kode.

**3. Sebagian.** Kode benar. Variabel `found` tidak perlu, karena `return -1` setelah perulangan sudah cukup. Penjelasannya keliru: `for...of` juga bisa berhenti di tengah dengan `return` atau `break`. Pikirkan lagi: informasi apa yang dibutuhkan soal ini tetapi tidak diberikan `for...of`?

## Advanced — 85/100

**1. Sebagian.** Output cocok. Namun ada bug saat cicilan tepat sama dengan sisa. `jadwalCicilan(98040, 2, 100000)` menghasilkan baris tambahan `Bulan 2: bunga 0, bayar 0, sisa 0`. Telusuri perbandingan `bayar > sisa` dan kondisi `while (sisa >= 0)`. Jawaban 1b baru menyebut satu keuntungan, padahal soal meminta minimal dua.

**2. Benar.** Output cocok. Jawaban 2c tepat: aturan baru cukup berupa fungsi baru, tanpa mengubah `totalBiayaAdmin`. Catatan kecil: pakai `for...of` untuk array, bukan `for...in`, sesuai Coba Sendiri.

Nilai awal 77.

## Pertanyaan diskusi

Apa yang terjadi jika memanggil `bulanMencapaiTarget(0, 0, 6, 1000000)` dengan kodemu? Mengapa cek `-1` yang sekarang tidak menangkap kasus ini?

## Revisi 1 (2026-11-02)

**Beginner 2. Masih salah.** Output sekarang `Masuk: NaN, Keluar: NaN`. Variabel `i` di `for...of` sudah berisi nominal, bukan index, jadi `mutasi[i]` sama dengan `mutasi[500000]`, yaitu `undefined`. Tanda masuk dan keluar juga masih tertukar. Nilai Beginner tetap 80.

**Intermediate 1. Benar.** Output 4 dari 4 cocok, dan jawaban "loop tanpa henti" tepat. Satu catatan: cek `-1` dijalankan sebelum cek `0`, padahal soal menulis urutan sebaliknya. Akibatnya `bulanMencapaiTarget(5000000, 0, 0, 4000000)` menghasilkan `-1`, seharusnya `0`.

Intermediate 2, Intermediate 3, dan Advanced 1 tidak direvisi. Atas permintaanmu, asisten menjelaskan jawabannya di DISKUSI.md. Nilai bagian itu tidak berubah.

Intermediate setelah revisi: 67/100 (1: 85, 2: 40, 3: 75).

Nilai setelah Revisi 1: 78.

## Revisi 2 (2026-11-02)

**Beginner 2. Sebagian.** Angkanya sudah benar dan `i` dipakai langsung. Namun labelnya tertukar: outputnya `Masuk: 520000, Keluar: 1575000`, seharusnya `Masuk: 1575000, Keluar: 520000`. Variabel `X` (yang dicetak sebagai Masuk) menjumlahkan mutasi negatif. Ini contoh langsung mengapa nama `X/Y/Z` berbahaya: dengan nama `masuk` dan `keluar`, kesalahan ini langsung terlihat.

Beginner setelah revisi: 90/100 (1: 100, 2: 70, 3: 100).

Total: 81
