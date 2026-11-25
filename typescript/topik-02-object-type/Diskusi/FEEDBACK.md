# Feedback TS-2

Diperiksa 2026-11-25. Kode diperiksa dengan `npx tsc --noEmit` dari folder topik, dijalankan dengan `node Jawaban/soal-ts2.ts` dan `node Jawaban/soal-ts2.ts coba`, lalu dicocokkan dengan kotak output di soal.

Ringkasan: `tsc` bersih, dan semua baris output dari Beginner 1 sampai Intermediate 3 cocok. Advanced dilewati atas kesepakatan (fokus konsep, lihat `DISKUSI.md` 2026-11-24), jadi tidak dinilai. Total dihitung dari Beginner dan Intermediate saja (bobot masing-masing 0.3, dibagi 0.6).

## Coba Sendiri (tidak dinilai)

- Nomor 3: alasannya belum tepat. `Record<string, number>` berarti "setiap key string punya value number", dan `tsc` percaya janji itu, termasuk untuk key yang tidak ada. Cara menjaga diri: anggap hasilnya bisa `undefined`, misalnya `nilai["b"] ?? 0` seperti di `stokPerKategori`.
- Nomor 4: jawabannya perlu dipisah untuk masing-masing tipe. Satu dari keduanya bisa ditukar, satu tidak. Lihat tabel "type atau interface?" di HO.

## Beginner — 97/100

**1. Benar.** `?? 0` untuk diskon yang tidak ada sudah tepat. `potongan` bisa memakai `const`, karena nilainya tidak diubah lagi.

**2. Benar.** Tuple dengan label (`[id: string, qty: number]`) dan destructuring di `for...of` rapi.

**3. Hampir benar.** Pesan error dan perbaikan `warna?: string` benar, dan hubungan dengan `hrga` sudah disebut. Nomor error belum ditulis: `TS2353`.

## Intermediate — 95/100

**1. Benar.** `readonly Produk[]` dan pola `?? 0` untuk menjumlah per key sudah tepat.

**2. Benar.** Setelah `if (p.alamat !== undefined)`, `tsc` sudah tahu `alamat` pasti ada, jadi `?.` di dalamnya tidak perlu.

**3. Hampir benar.** Perbaikan jalan: `.map((p) => p)` membuat salinan sebelum `sort`. `[...daftar]` atau `daftar.slice()` lebih jelas maksudnya. Error `TS2339` benar, dan alasan "error membantu menemukan logic error" tepat. Satu hal belum tepat: yang kurang `readonly` adalah tipe parameter `daftar`, bukan `Produk`. Penjelasan juga belum menyebut penyebab bug-nya: `sort` mengubah array asli, dan `daftar` menunjuk array yang sama dengan `katalog`.

## Advanced — tidak dinilai

**1. Tidak dinilai** (dilewati atas kesepakatan).

## Pertanyaan diskusi

Di `urutTermurah`, `readonly Produk[]` membuat `tsc` menolak `sort`. Apakah `readonly` itu juga menolak `daftar[0].harga = 0`? Mengapa?

Total: 96
