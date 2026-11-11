# Feedback JS-4

Diperiksa 2026-11-12. Kode dijalankan dengan `node Jawaban/soal-js4.js` dan `node Jawaban/soal-js4.js coba`, lalu dicocokkan dengan kotak output di soal.

Ringkasan: semua baris output dari Beginner 1 sampai Intermediate 3 cocok. Dua jawaban *(jelaskan)* belum lengkap: Beginner 4 belum dijalankan, dan penjelasan Intermediate 3 masih kosong. Advanced 1 dijelaskan asisten atas kesepakatan, jadi tidak dinilai. Total dihitung dari Beginner dan Intermediate saja (bobot masing-masing 0.3, dibagi 0.6).

Catatan konteks: soal dikerjakan dengan kotak "Langkah Mengerjakan" dan contoh lengkap bukan soal untuk Intermediate 1 sampai 3 (lihat `DISKUSI.md`).

## Coba Sendiri (tidak dinilai)

- Tebakan yang meleset: `kata.toUpperCase(), kata` tercetak `HALO Halo` (bukan `halo`), `a.dalam.m` menjadi `9`, `{ x: 1 } === { x: 1 }` bernilai `false`, dan `JSON.stringify` membuang key `umur` yang bernilai `undefined`.
- Nomor 2 dan 3 dijawab "tidak tahu". Penjelasannya sama dengan Intermediate 3: variabel object menyimpan *alamat*. Spread hanya membuat object luar yang baru, sehingga `b.dalam` dan `a.dalam` menunjuk object yang sama. Dua object literal `{ x: 1 }` adalah dua object di dua alamat berbeda, jadi `===` bernilai `false`.
- Nomor 4: `Object.keys` ditulis dengan huruf `O` kapital, dan barisnya perlu ditulis di kode, misalnya `console.log(Object.keys(a).join(", "))`.

## Beginner — 84/100

**1. Benar.** Rantai `trim`, `split`, `filter`, `map`, `join` sudah tepat. `toLowerCase()` di awal tidak salah, tetapi tidak perlu karena `map` sudah mengecilkan sisa huruf.

**2. Benar.** `slice(-4).padStart(telepon.length, "*")` lebih ringkas daripada `repeat`. Cara yang bagus.

**3. Benar.** `slice(-3)` tidak perlu, karena `nomor` paling besar 999.

**4. Sebagian.**
- Pesan error belum ditulis karena kode tidak dijalankan. Pesannya: `TypeError: Cannot assign to read only property '0' of string 'budi'`.
- Penyebabnya sudah menyebut *immutable*, dan itu kata kuncinya. Tetapi alasannya bukan "method mengembalikan string baru". Alasannya: string tidak bisa diubah sama sekali, termasuk lewat index. Array bisa diubah, string tidak.
- Versi benar belum jalan. `map` hanya ada di array, dan `UpperCase` seharusnya `toUpperCase()`. Versi yang benar: `const baru = nama[0].toUpperCase() + nama.slice(1);`.

## Intermediate — 87/100

**1. Benar.** Destructuring dengan default `alergi = []`, lalu ternary untuk `"-"`. Rapi.

**2. Benar.** Pola object penghitung dengan bracket notation sudah tepat.

**3. Sebagian.** Perbaikan kode benar, yaitu spread di dua tingkat, dan outputnya `false false`. Penjelasan *(jelaskan)* masih kosong. Yang perlu ditulis: variabel object menyimpan alamat, `{ ...p }` hanya menyalin satu tingkat sehingga `kontak` tetap dipakai bersama, dan solusinya membuat object `kontak` baru.

## Advanced — tidak dinilai

**1. Tidak dinilai** (dijelaskan asisten atas kesepakatan). Pendekatan yang benar: `split("\n")`, lalu `map` per baris, `split(";")`, destructuring array, `Number(umur)`, dan `split("|")` kecuali kolom alergi kosong, karena `"".split("|")` menghasilkan `[""]`, bukan `[]`.

## Pertanyaan diskusi

Di Intermediate 3, versimu menulis `kontak: { ...p.kontak, alamat: alamatBaru }`. Jika `kontak` punya object lagi di dalamnya, misalnya `kontak.darurat = { nama, telepon }`, apakah `pasienBaru.kontak.darurat === pasien[0].kontak.darurat`? Mengapa?

Total: 86
