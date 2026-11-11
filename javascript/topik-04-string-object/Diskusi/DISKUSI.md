# Diskusi JS-4

### 2026-11-10 — Arrow function di soal (Beginner 1, PEMANGGILAN)
**Pertanyaan:** Kenapa soal Topik 4 tiba-tiba langsung memakai `=>`? Konsepnya bagaimana?
**Level hint:** pertanyaan sintaks umum (dijawab langsung)
**Jawaban asisten:** `=>` adalah arrow function dari HO Topik 2. Ditunjukkan tiga bentuk (declaration, arrow dengan `{}`, implicit return), alasan ditulis langsung di dalam `map`, padanan `for` dan SQL dari baris `pasien.map((p) => formatNama(p.nama))`, serta destructuring `([buah, jumlah]) =>` di HO `Object.entries`.

### 2026-11-10 — Soal Beginner 1
**Pertanyaan:** Bagaimana langkah mengerjakan `formatNama`?
**Level hint:** 3
**Jawaban asisten:** Tabel bentuk data per langkah dengan `"  SARI   dewi "` (trim, split, filter, ubah setiap kata, join), petunjuk langkah ubah satu kata (`kata[0]`, `slice(1)`, `+`), dan contoh lengkap bukan soal `inisial(nama)`.

### 2026-11-11 — Semua soal
**Pertanyaan:** Minta langkah pengerjaan ditulis langsung di soal supaya tidak menebak-nebak, karena waktu menipis.
**Level hint:** 3 (Advanced: 2)
**Jawaban asisten:** Kotak "Langkah Mengerjakan" ditambahkan di setiap tugas pada SOAL_JS_TOPIK4.typ. Beginner dan Intermediate berisi urutan method dan hasil per langkah. Soal *(jelaskan)* hanya diarahkan ke bagian HO dan pertanyaan pemandu. Advanced hanya diberi daftar method dan cara mengecek P102, karena bagian (a) yang dinilai adalah daftar langkah itu sendiri.

### 2026-11-11 — Semua soal (lanjutan)
**Pertanyaan:** Minta setiap langkah di kotak hint juga menjelaskan apa yang dikerjakan method-nya, supaya tidak asal pakai.
**Level hint:** 3
**Jawaban asisten:** Setiap langkah di kotak "Langkah Mengerjakan" diberi penjelasan cara kerja method: tipe input dan output, cara memotong atau mengubah data, dan jebakannya (string kosong dari `split`, `padStart` hanya di string, `undefined + 1` menjadi `NaN`, bracket vs dot notation, aturan timpa key pada spread dengan contoh bukan soal).

### 2026-11-11 — Soal Intermediate 1
**Pertanyaan:** Buntu di destructuring. Destructuring mana yang dimaksud? (kode: `const { nama, umur, poli, alergi} = buku;`, error `ReferenceError: buku is not defined`)
**Level hint:** contoh lengkap bukan soal (Dion buntu)
**Jawaban asisten:** Kanan `=` harus object yang dibongkar, yaitu parameter `p`, bukan `buku` dari contoh HO. Default `alergi = []` belum ada, sehingga P002 akan error. Diberi contoh lengkap `labelBuku(b)` dengan default `tag = []` dan ternary, tabel jalannya, dan tabel padanan ke soal. Catatan tambahan Beginner 4: belum dijalankan, `map` tidak ada di string, `UpperCase` salah tulis.

### 2026-11-12 — Soal Intermediate 2
**Pertanyaan:** Buntu di `hitungPerPoli`. (Intermediate 1 sudah benar.)
**Level hint:** contoh lengkap bukan soal (Dion buntu)
**Jawaban asisten:** Konsep object sebagai lembar turus (padanan SQL `GROUP BY ... COUNT(*)`). Contoh lengkap `hitungPerGenre` dengan data buku, tabel jalannya per putaran, alasan bracket notation (bukan dot), alasan isi 0 dulu (`undefined + 1` = `NaN`), alasan array kosong menjadi `{}`, dan tabel padanan `b.genre` ke `p.poli`.

### 2026-11-12 — Soal Intermediate 3
**Pertanyaan:** Buntu di `gantiAlamat` (Dion sudah lelah, malam). Intermediate 2 sudah benar.
**Level hint:** contoh lengkap bukan soal (Dion buntu)
**Jawaban asisten:** Membaca output `false true` sebagai bukti `kontak` dipakai bersama. Konsep variabel object menyimpan alamat dan spread hanya menyalin satu tingkat (shallow copy), tanpa kalimat jawaban siap salin. Contoh lengkap `toko`/`pemilik` (versi salah dan benar), cara membaca spread bertingkat, dan tabel padanan `pemilik` ke `kontak`. Disarankan Advanced dilanjutkan besok.
