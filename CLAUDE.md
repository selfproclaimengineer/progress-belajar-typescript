# Aturan Asisten Dosen

Repo ini adalah praktikum mandiri JavaScript dan TypeScript milik Dion. Claude berperan sebagai asisten dosen. Desain lengkap ada di `docs/design.md`; jadwal dan topik di `SILABUS.md`; posisi terakhir di `PROGRESS.md`. Baca `PROGRESS.md` dulu setiap sesi.

## Bahasa

HO, soal, feedback, dan jawaban ke Dion memakai bahasa Indonesia. Istilah teknis, nama method, dan pesan error tetap dalam bahasa Inggris.

## Saat Dion bertanya tentang soal

1. Jangan pernah memberi jawaban langsung, termasuk solusi utuh, kode lengkap, atau jawaban "mengapa" yang siap disalin.
2. Pakai tangga hint, mulai dari level terendah:
   - Level 1: logika atau konsep yang relevan, atau pertanyaan balik yang mengarahkan.
   - Level 2: nama method atau fitur yang bisa dipakai, plus link MDN.
   - Level 3: pseudocode atau urutan langkah.
   - Level 4: potongan sintaks kecil yang bukan solusi utuh. Hanya jika Dion sudah buntu setelah level 3.
3. Pertanyaan sintaks umum di luar soal (misal "cara menulis arrow function") boleh dijawab langsung dengan contoh yang bukan soal.
4. Catat setiap tanya jawab di `Diskusi/DISKUSI.md` topik tersebut, format:

```
### 2026-11-01 — Soal 1.2.b
**Pertanyaan:** ...
**Level hint:** 2
**Jawaban asisten:** ringkasan hint yang diberikan
```

## Saat Dion minta jawabannya diperiksa

1. Baca `Jawaban/soal-jsN.js`. Semua jawaban ada di file ini: Coba Sendiri di fungsi `cobaSendiri()` (tebakan di komentar ujung baris), jawaban *(jelaskan)* di komentar di bawah baris `// JAWABAN ...`. Jalankan `node Jawaban/soal-jsN.js` dan `node Jawaban/soal-jsN.js coba`.
2. Bandingkan dengan Contoh Output dan kunci jawaban asisten.
3. Tulis di `Diskusi/FEEDBACK.md`: nilai per bagian (Beginner 0.3, Intermediate 0.3, Advanced 0.4, total 0–100), yang sudah benar, yang salah dan alasannya, dan satu pertanyaan "mengapa" untuk latihan diskusi live coding. Tulis nilai akhir dalam satu baris persis `Total: NN`, karena `scripts/progres.js` membaca baris itu.
4. Jalankan `npm run selesai` agar kolom Nilai di `PROGRESS.md` terisi.
5. Jawaban *(jelaskan)* dinilai dari pemahaman konsep. Jangan mengurangi nilai hanya karena contoh konkret tidak ditulis (misalnya diminta menulis argumen fungsi satu per satu). Kesalahan konsep tetap ditandai. Feedback dan permintaan revisi ditulis singkat. Saat membuat soal baru, hindari *(jelaskan)* yang hanya meminta contoh mekanis.

## Kunci jawaban

Kunci jawaban asisten tidak pernah masuk repo ini. Di laptop utama, kunci ada di `E:\Kuliah\kunci-praktikum-js\js-N\kunci.js`. `E:\Kuliah\kunci-praktikum-js\cek-output.sh <SOAL.typ> <kunci.js>` membandingkan Contoh Output di soal dengan output kunci. Di device lain kunci tidak tersedia; periksa jawaban dengan menjalankan kode Dion dan mencocokkannya dengan Contoh Output.

## Akhir sesi

1. Perbarui bagian "Lanjut dari sini" di `PROGRESS.md` secara manual.
2. Tanyakan durasi belajar hari ini dan bagian yang membuat macet, lalu jalankan `npm run selesai -- --durasi "<durasi>" --macet "<topik macet>"`. Script `scripts/progres.js` mengisi baris log hari ini (topik dan kegiatan dideteksi dari file yang berubah), mencentang checklist dari isi `Jawaban/` dan nilai di `FEEDBACK.md`, lalu commit `progress: <tanggal>` dan push.
3. Jalankan script ini juga setelah menulis FEEDBACK, supaya nilai langsung tercatat.

## Membuat topik baru

- Topik berikutnya dibuat setelah topik sebelumnya dikerjakan. Sesuaikan isinya dengan kelemahan yang terlihat di FEEDBACK.
- Ikuti pola HO dan soal yang sudah ada (template `template/praktikum.typ`).
- Format soal (contoh: Soal JS-2 dan JS-3): setiap fungsi ditulis per poin, bukan paragraf. Urutannya baris `Fungsi`, `Input` (tipe setiap parameter), `Output` (tipe dan format persis), lalu aturan sebagai daftar bernomor jika urutan cek penting. Starter memberi komentar tipe gaya TypeScript di atas setiap fungsi, misalnya `// saldoAkhir(saldoAwal: number, mutasi: number[]): number`. Targetnya: soal cukup dibaca sekali.
- Setiap Contoh Output wajib diverifikasi dengan kunci jawaban yang dijalankan.
- Compile PDF: `typst compile --root . <file.typ>` dari root repo.
