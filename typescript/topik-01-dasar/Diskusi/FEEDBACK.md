# Feedback TS-1

Diperiksa 2026-11-25. Kode diperiksa dengan `npx tsc --noEmit` dari folder topik, dijalankan dengan `node Jawaban/soal-ts1.ts` dan `node Jawaban/soal-ts1.ts coba`, lalu dicocokkan dengan kotak output di soal.

Ringkasan: `tsc` belum bersih (5 error, semuanya dari Intermediate 2). Beginner 1 dan 2 cocok. Intermediate 1 jalan, tetapi kedua baris output berbeda dari soal. Intermediate 3 jalan, tetapi belum memakai `unknown` dan penjelasannya kosong. Advanced dilewati atas kesepakatan (fokus konsep, lihat `DISKUSI.md` TS-2 2026-11-24), jadi tidak dinilai. Total dihitung dari Beginner dan Intermediate saja (bobot masing-masing 0.3, dibagi 0.6).

## Coba Sendiri (tidak dinilai)

Sudah dibahas di `DISKUSI.md` 2026-11-23. Dua catatan masih berlaku:
- Nomor 3: `tsc` diam karena `e` bertipe `any`, dan `any` mematikan pengecekan. Alasannya bukan "sudah dicek di awal".
- Nomor 4: yang diperbaiki seharusnya baris `console.log(d + 1)`, bukan deklarasi `d`.

## Beginner — 83/100

**1. Benar.** Anotasi tipe ditambahkan tanpa mengubah isi fungsi.

**2. Benar.** Literal union tiga nilai sudah tepat. `else throw` di akhir tidak salah, tetapi tidak perlu: `MetodeBayar` hanya punya tiga nilai, jadi `tsc` sudah menolak nilai lain sebelum program jalan.

**3. Sebagian.**
- Pesan error `TS2322` benar. Output `node` (`150001000`) belum ditulis.
- Alasan `node` tetap jalan sudah mendekati: `node` membuang anotasi tipe lalu menjalankan sisanya sebagai JavaScript, tanpa memeriksa tipenya.
- Kapan `tsc` dijalankan: salah konsep. `tsc` memeriksa *kode*, bukan aplikasi yang sedang dipakai, jadi tidak ada hubungannya dengan jam buka toko. `tsc` dijalankan saat kode ditulis atau diubah, sebelum kode itu dipakai kasir. Untungnya, bug ketahuan sebelum ada transaksi yang salah.
- File `Jawaban/coba-b3.ts` masih ada. Hapus sesuai perintah soal.

## Intermediate — 57/100

**1. Sebagian.** Pengecekan `undefined` sudah benar, tetapi dua baris output berbeda dari soal:
- `OB01: Rp12000` seharusnya `OB01: Rp12.000`. Soal meminta memakai `formatRupiah`.
- `tidak terdaftar` seharusnya `OB99: tidak terdaftar`.

Simpan hasil `get` ke variabel dulu, lalu periksa variabel itu. Jika `get` dipanggil dua kali, `tsc` tidak tahu hasil keduanya sama. Kasusnya sama dengan Coba Sendiri 4.

**2. Sebagian.** Kedua aturan dan perulangannya benar, dan output cocok. Tetapi `tsc` menampilkan 5 error, karena parameter ditulis `daftarAturan: number[]`. Tipe yang benar ada di komentar signature: `AturanDiskon[]`. Jawaban TS baru dianggap benar jika `tsc` bersih.

**3. Sebagian.** Pengecekan `typeof` dan pesan error sudah benar, dan output cocok. Dua bagian belum dikerjakan:
- Soal meminta perbaikan dengan `unknown`. Sekarang `tambahan` masih bertipe `any`, karena `any` adalah tipe kembalian `JSON.parse`.
- Penjelasan *(jelaskan)* masih kosong: mengapa `tsc` diam, dan apa tipe `tambahan`.

## Advanced — tidak dinilai

**1. Tidak dinilai** (dilewati atas kesepakatan).

## Pertanyaan diskusi

Di `hargaObat`, kamu memanggil `daftarHarga.get(kode)` dua kali. Jika hasil panggilan kedua dimasukkan ke `formatRupiah`, apakah `tsc` menerimanya? Mengapa menyimpan hasilnya ke variabel dulu mengubah jawaban `tsc`?

Total: 70
