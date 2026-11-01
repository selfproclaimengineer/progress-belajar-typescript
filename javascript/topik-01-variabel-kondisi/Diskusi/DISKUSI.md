# Diskusi JS-1

Log tanya jawab dengan asisten. Format per entri: tanggal, butir soal, pertanyaan, level hint, ringkasan jawaban.

### 2026-11-01 — Soal Intermediate 1a
**Pertanyaan:** Cara mengubah angka ke string (`toString(kelas)` tidak berefek) dan cara memastikan bilangan bulat, karena `typeof` hanya memberi `number`.
**Level hint:** 2 (dengan potongan sintaks level 4 untuk konversi)
**Jawaban asisten:** `toString(kelas)` memanggil `toString` global dan hasilnya dibuang; primitif tidak bisa diubah di tempat, jadi hasil konversi harus ditampung (`String(x)` lebih aman daripada `x.toString()` untuk `null`/`undefined`). Bilangan bulat dicek dengan `Number.isInteger` (contoh di luar soal). Diarahkan mengecek Contoh Output baris `hitungBiayaRawat(3, 2, false)` dan perbandingan `===` pada `switch` untuk Intermediate 1b.
