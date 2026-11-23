# Diskusi JS-6

### 2026-11-15 — Coba Sendiri (pemeriksaan pertama)
**Pertanyaan:** Dion minta Coba Sendiri JS-6 diperiksa.
**Level hint:** 1
**Jawaban asisten:**
- Tebakan: 2 dari 8 baris salah. `s.size` ditebak 3 (hasil 2), dan `"lolos"` ditebak tercetak (tidak tercetak, yang tercetak `SyntaxError` dari catch).
- CS1: alasan Set benar (duplikat dihitung sekali). Alasan `SyntaxError` belum ada. Hint: apakah `"{"` JSON yang sah?
- CS2: arahnya benar (satu argumen berupa array). Perlu dipertajam: hint coba `Number([3, 9, 4])` dan `Number([7])`, lalu hitung jumlah argumen `Math.max` di kedua versi.
- CS3: konsep keliru. `try` menjalankan baris secara normal; "lolos" terlewat karena baris sebelumnya melempar error. Hint: ganti `JSON.parse("{")` menjadi `JSON.parse("{}")` dan amati, lalu baca bagian "Menangkap error" dan peran `finally` di HO.
- CS4: kode di dalam `cobaSendiri()` benar dan mencetak `[ 1, 2, 3 ]`. Salinan di komentar JAWABAN berbeda (`["3,1,3,2,1"]` satu string, dan ada `]` berlebih). Soal meminta satu baris; dua baris diterima, tetapi bisa digabung.

### 2026-11-23 — Intermediate 1 (buatIndex error, perlu class?)
**Pertanyaan:** Intermediate 1 error `index.get is not a function`. Apakah tidak perlu membuat class?
**Level hint:** 2
**Jawaban asisten:** Tidak perlu class. `Map` adalah class bawaan JS (stdlib) yang sudah punya `get`, `set`, dan `size`; itu inti topik ini. Error terjadi karena `return index` mengembalikan class (cetakan) tanpa `new`, jadi `index.get` dan `index.size` tidak ada (konsep JS-5). Class buatan itu juga tidak akan benar meski dibuat dengan `new`: `get` tidak punya `return`, membandingkan object dengan string, dan tidak ada `size`. Diarahkan ke HO bagian "Map: Kamus dengan Pencarian Cepat" (contoh `indexNim`). Bagian *(jelaskan)* Intermediate 1 juga diingatkan.

### 2026-11-23 — Intermediate 1 (map() bukan Map)
**Pertanyaan:** Setelah diganti `produk.map((p) => p)`, tetap `index.get is not a function`.
**Level hint:** 3 (perbedaan `.map()` dan `Map`, contoh `indexNim` dari HO ditampilkan ulang dengan tabel padanan)
**Jawaban asisten:** `.map()` adalah method array (JS-3) yang menghasilkan array baru, jadi hasilnya tetap array tanpa `get` dan `size` (array punya `length`). `Map` adalah class bawaan yang dibuat dengan `new Map()`, lalu diisi dengan `set(key, value)`. Namanya mirip tetapi tidak berhubungan. Ditunjukkan tabel jalannya `indexNim.set` per putaran.

### 2026-11-23 — Intermediate 1 (Map sudah dipakai, masih undefined)
**Pertanyaan:** Sudah memakai `new Map()` tetapi masih `undefined`. Apakah cara menaruhnya salah?
**Level hint:** 3–4 (tabel isi Map dari kode Dion dibandingkan pola HO)
**Jawaban asisten:** `produk` adalah array, jadi `produk.id` bernilai `undefined`, dan `m.set(produk.id, produk)` hanya membuat satu entri: key `undefined`, value seluruh array. `set` harus dijalankan sekali per produk di dalam loop, dengan key `p.id` dan value `p`, lalu Map dikembalikan setelah loop selesai. Ditemukan juga baris `import { formatRupiah } from "./kasir.js"` yang aktif di bagian jawaban Beginner 4: nama itu sudah di-import di baris 8, jadi seluruh file gagal dengan `SyntaxError: Identifier 'formatRupiah' has already been declared`. Baris itu harus dijadikan komentar.

### 2026-11-23 — Intermediate 2 (error validasiQty menghentikan program)
**Pertanyaan:** Intermediate 2 masih error.
**Level hint:** 2
**Jawaban asisten:** Intermediate 1 sekarang benar (5, Kopi Sachet, undefined). Intermediate 2 punya tiga masalah: (1) `cobaTambah` belum memakai `try...catch`, jadi error yang dilempar `validasiQty` naik sampai program berhenti, padahal tugasnya justru menangkap error itu; (2) `qty !== Number.isInteger(qty)` membandingkan angka dengan boolean, selalu true, sehingga `3` pun ditolak (cek tabel nilai); (3) pesan error memuat awalan `GAGAL: `, padahal awalan itu ditambahkan `cobaTambah`, sehingga hasilnya akan dobel. Diarahkan ke HO bagian "throw, try, catch".

### 2026-11-23 — Jeda JS-6, lompat ke TypeScript
**Pertanyaan:** JS-6 disudahi dulu (Advanced nanti jika ada waktu). Bolehkah lompat ke TypeScript, melewati JS-7 dan JS-8?
**Level hint:** - (perencanaan)
**Jawaban asisten:** Boleh. TS-1 sampai TS-6 tidak memakai async maupun DOM (dicek di HO, soal, dan starter); hanya TS-7 (opsional) yang memakai `fetch`/async dari JS-7. Status JS-6 saat jeda: Beginner 1–3, Intermediate 1, dan Intermediate 3 jalan; Intermediate 2 hampir benar tetapi output `OK 3` kurang titik dua (`OK: 3`); *(jelaskan)* Beginner 4 dan Intermediate 1 belum lengkap; Advanced belum. JS-6 belum dinilai.
