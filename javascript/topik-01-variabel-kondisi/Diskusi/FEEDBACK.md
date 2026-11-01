# Feedback JS-1

Diperiksa 2026-11-01. Kode dijalankan dengan `node Jawaban/soal-js1.js` dan `node Jawaban/soal-js1.js coba`, lalu dicocokkan dengan Contoh Output dan kunci asisten. Beberapa input tambahan di luar bagian PEMANGGILAN juga dicoba untuk mengecek aturan soal yang tidak muncul di Contoh Output.

Ringkasan: 30 dari 37 baris output sudah cocok. Semua soal Advanced cocok dengan Contoh Output. Kesalahan terbesar ada di Beginner 3 dan aturan BPJS.

## Coba Sendiri (tidak dinilai)

- Tebakan sudah ditulis dan kamu mencatat sendiri yang meleset (`??` pada `0`, `Boolean("0")`, `Boolean([])`). Bagus, kebiasaan ini yang dicari.
- Tebakan baris `Boolean` adalah `false, undefined, false`, sedangkan hasilnya `true false true`. `Boolean(...)` selalu mengembalikan `true` atau `false`, tidak pernah `undefined`. Hanya 6 nilai yang falsy: `false`, `0`, `""`, `null`, `undefined`, `NaN`. String `"0"` dan array kosong `[]` termasuk truthy.
- Jawaban 2 (`const` pada array) dan 3 (`i is not defined` karena scope blok `for`) benar.

## Beginner — 50/100

**1. Triase IGD.** Semua 7 baris output cocok. Namun aturan "bukan bilangan bulat" belum dicek. `kategoriTriase(7.5, true)` menghasilkan `MERAH`, seharusnya `INVALID`. Kamu sudah memakai cara yang tepat untuk ini di Intermediate 1, tinggal dipakai juga di sini.

**2a. Salah.** Output baris kedua bukan `Antrean panjang`. Jalankan kodenya dan lihat sendiri. Alasan "tembus ke variabel global" juga keliru: `var` tidak menjadi global di sini. Cari tahu apa scope `var` (petunjuk: bukan scope blok, bukan scope global) dan apa itu hoisting.

**2b. Benar.** Error `pesan is not defined` dan alasan memilih error yang langsung terlihat sudah tepat.

**3. Diskon kasir.** Hanya 1 dari 6 baris yang cocok (`12500`). Ada tiga masalah terpisah:
- Persentase member salah. Baca lagi aturan member di soal dan bandingkan dengan angka di kodemu.
- Hasil tidak dibulatkan ke bawah. Soal meminta nominal dibulatkan ke bawah, dan materinya ada di HO (lihat Coba Sendiri baris `Math`).
- `hitungDiskon(199999, false)` menghasilkan `undefined`. Telusuri jalur kode untuk input itu: `return` mana yang dijalankan? Fungsi yang selesai tanpa `return` selalu mengembalikan `undefined`.

## Intermediate — 70/100

**1a. Biaya rawat inap.** 7 dari 8 baris cocok. `Number.isInteger` dan `String(kelas)` sudah tepat. Masalahnya ada di aturan BPJS kelas 1 dan 2: soal menulis "pasien membayar 25%", sedangkan kodemu membuat pasien membayar 75%. `hitungBiayaRawat("1", 3, true)` menghasilkan `1800000`, seharusnya `600000`. Kelas 2 dengan BPJS punya bug yang sama, tetapi tidak muncul di Contoh Output.

**1b. Sebagian.** Perbaikan dengan `String(kelas)` sudah benar. Penyebabnya belum dijelaskan sampai ke akar: mengapa angka `3` tidak cocok dengan `case "3"`? Sebutkan jenis perbandingan yang dipakai `switch` (hubungkan dengan `"10" === 10` di Coba Sendiri).

**2a. Benar.** Penjelasan `0` falsy pada `||` dan perbaikan dengan `??` sudah tepat.

**2b. Sebagian.** Kode benar dan dua cara perbaikan sudah disebut. Cara kedua tertulis `18.5>=bmi?=25`, sehingga tidak jelas maksudnya. Tulis ulang sebagai kondisi JS yang valid. Bagian "mana yang lebih mudah dirawat" belum dijawab.

## Advanced — 72/100

**1a. Transfer saldo.** Semua 8 baris cocok, dan guard clause sudah dipakai dengan benar. Dua catatan:
- Aturan 1 berbunyi "tidak lebih dari 0". Kodemu memakai `nominal < 0`, sehingga `cekTransfer(1000000, 0, true, 0)` menghasilkan `GAGAL: minimal transfer Rp 10000`, seharusnya `GAGAL: nominal tidak valid`.
- Pesan `"GAGAL: minimal transfer Rp 10000"` masih menulis angka 10000 langsung, padahal soal melarangnya. Kamu sudah memakai template literal dengan konstanta untuk pesan limit harian. Lakukan hal yang sama di sini.

**1b. Sebagian.** Alasan keamanannya bagus: orang yang tidak tahu PIN bisa menebak besar saldo dengan mencoba berbagai nominal. Namun soal juga meminta satu contoh input konkret yang menghasilkan pesan berbeda antara versimu dan versi temanmu. Contoh itu belum ada.

**2a. Ongkos kirim.** Semua 8 baris cocok.

**2b. Sebagian.** Ternary tertulis `tarif = isPremium == true ? tarif = 0 : tarif=tarif`. Kode itu berjalan, tetapi ada assignment di dalam ternary. Ternary adalah ekspresi yang menghasilkan nilai, jadi cabangnya cukup berisi nilai. `== true` juga tidak perlu karena `isPremium` sudah boolean. Bagian kedua (contoh dari fungsi ini yang sulit dibaca jika dipaksa memakai ternary, beserta alasannya) belum dijawab.

## Revisi 1 — diperiksa ulang 2026-11-01

Nilai baru: Beginner 70, Intermediate 80, Advanced 78. Komentar penjelasan di file yang tersimpan masih sama dengan versi pertama, jadi nilai bagian *(jelaskan)* belum berubah.

Sudah diperbaiki:
- Beginner 1: `Number.isInteger`, sehingga `7.5` sekarang `INVALID`.
- Beginner 3: persentase member dan `Math.floor` benar, 5 dari 6 baris cocok.
- Intermediate 1a: aturan BPJS 25% benar, 8 dari 8 baris cocok.
- Advanced 1a: pesan minimal transfer sudah memakai `MINIMAL_TRANSFER`.

Masih salah:
- Beginner 3: `hitungDiskon(199999, false)` masih `undefined`. Untuk bukan member di bawah 200000, `if` dalam tidak terpenuhi dan tidak ada `return` setelahnya.
- Advanced 1a: `nominal < 0` masih meloloskan `0`.

## Revisi 2 — diperiksa ulang 2026-11-01

Nilai baru: Beginner 90, Intermediate 86, Advanced 82. Semua baris output cocok dengan Contoh Output. Mulai revisi ini, penjelasan dinilai dari konsepnya, bukan dari kelengkapan contoh.

Sudah benar: Beginner 3, alasan scope `var`/`let` di Beginner 2a, Intermediate 1b (number vs string), dan Advanced 1b (urutan PIN mencegah orang menebak saldo).

Sisa:
- Beginner 2a: output baris kedua masih tertulis `Antrean panjang`, padahal hasilnya `undefined`.
- Intermediate 2b: JS tidak mendukung perbandingan berantai. `18.5>=bmi<=25` dibaca `(18.5>=bmi)<=25`, sehingga hasilnya selalu `true`. Bagian "mana yang lebih mudah dirawat" belum ada.
- Advanced 1a: `nominal < 0` masih meloloskan `0`.
- Advanced 2b: `isPremium = true` memakai satu `=`, sehingga menjadi assignment, bukan perbandingan. Contoh ternary yang sulit dibaca belum ada.

## Pertanyaan diskusi live coding

Mengapa `cekAntrean(3)` pada Beginner 2 tidak error padahal `var pesan` dibuat di dalam blok `if` yang tidak pernah dijalankan? Apa yang sebenarnya dilakukan JavaScript terhadap `var pesan` sebelum baris pertama fungsi berjalan?

Total: 86
