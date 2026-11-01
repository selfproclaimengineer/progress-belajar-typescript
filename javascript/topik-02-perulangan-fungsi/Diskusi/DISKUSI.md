# Diskusi JS-2

Log tanya jawab dengan asisten. Format per entri: tanggal, butir soal, pertanyaan, level hint, ringkasan jawaban.

### 2026-11-02 — Soal Beginner 2
**Pertanyaan:** Bagaimana membawa 3 nilai dari dalam `for` ke luar, apakah bisa dengan `return`?
**Level hint:** 1
**Jawaban asisten:** Pola Dion sudah benar: variabel dideklarasikan di luar perulangan, diperbarui di dalam, lalu satu `return` setelah perulangan. `return` di dalam perulangan langsung keluar dari fungsi. Diarahkan ke tiga hal: apa isi variabel `for...of` (cetak dengan `console.log`), apakah "jumlah" berarti banyaknya atau total nominal, dan tanda mana yang berarti masuk.

### 2026-11-02 — Soal Intermediate 1
**Pertanyaan:** Bunga diberikan per bulan atau per tahun? Apakah compounding?
**Level hint:** - (klarifikasi spesifikasi soal, bukan hint)
**Jawaban asisten:** Persen tahunan dibagi 12, dihitung dan ditambahkan setiap bulan, jadi majemuk bulanan. Urutan per bulan: setoran dulu, lalu bunga dari saldo baru, dibulatkan ke bawah tiap bulan. Kalimat soal diperjelas dan PDF di-compile ulang.

### 2026-11-02 — Soal Intermediate 1
**Pertanyaan:** Setoran masuk sebelum atau sesudah bunga? Apakah setoran bulan itu ikut berbunga?
**Level hint:** - (klarifikasi spesifikasi soal)
**Jawaban asisten:** Setoran di awal bulan, bunga di akhir bulan, jadi setoran bulan itu ikut berbunga. Kalimat soal diperjelas.

### 2026-11-02 — Soal Advanced 2
**Pertanyaan:** Bagaimana cara memasukkan fungsi ke dalam parameter?
**Level hint:** - (sintaks umum, dijawab langsung dengan contoh di luar soal)
**Jawaban asisten:** Saat mengirim, tulis nama fungsi tanpa `()` (sudah benar di baris pemanggilan). Di dalam fungsi penerima, parameter itu dipanggil seperti fungsi biasa dengan `()` dan argumen. Ditunjukkan bahwa `aturanBiaya*-1` mengalikan fungsi dengan angka, jadi hasilnya `NaN`. Contoh umum memakai `sapa(nama)` dan `jalankan(fn, x)`.

### 2026-11-02 — Penjelasan setelah dinilai (Intermediate 2, Intermediate 3, Advanced 1)
**Pertanyaan:** Dion meminta asisten menjelaskan sisa catatan yang dianggap minor.
**Level hint:** - (penjelasan setelah penilaian, nilai bagian ini tidak berubah)
**Jawaban asisten:**
- Intermediate 2: dua kesalahan, `i = 1` melewatkan `biaya[0]` dan `i <= biaya.length` membaca `biaya[3]`. Index di luar array menghasilkan `undefined`, bukan error. `angka + undefined` menghasilkan `NaN`. `for...of` aman karena tidak memakai index, jadi tidak ada angka awal atau batas akhir yang bisa salah.
- Intermediate 3: `for...of` juga bisa berhenti dengan `return` atau `break`. Masalahnya, `for...of` hanya memberi value, padahal soal meminta posisi, jadi harus membuat penghitung sendiri.
- Advanced 1: saat cicilan sama dengan sisa, `bayar > sisa` bernilai false, sisa menjadi 0, lalu `while (sisa >= 0)` tetap jalan satu putaran lagi. Keuntungan kedua `return` array: pemanggil bebas memilih tampilan (console, file, HTML, response API), dan hasilnya mudah dites.
- Beginner 2 tetap dikerjakan Dion. Hint level 3: `i` sudah berisi nominal, pakai langsung; positif masuk; keluar dijumlahkan sebagai angka positif.
