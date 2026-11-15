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
