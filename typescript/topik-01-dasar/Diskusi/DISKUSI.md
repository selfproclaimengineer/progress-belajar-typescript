# Diskusi TS-1

### 2026-11-23 — Coba Sendiri (cara mengerjakan)
**Pertanyaan:** Tidak paham cara mengerjakan Coba Sendiri TS-1, output hanya `10 qris [ 1, 2, 3 ] undefined x`.
**Level hint:** 2
**Jawaban asisten:** Output itu memang normal: tipe TypeScript dihapus saat dijalankan, jadi `node` mencetak nilai, bukan tipe. Coba Sendiri ini melatih membaca tipe, bukan output. Langkah: (1) arahkan kursor ke nama variabel di VS Code untuk melihat tipe hasil tebakan TS, bandingkan dengan tebakan; (2) buka satu baris Bagian 2, jalankan `npx tsc --noEmit` dari folder topik, catat nomor dan pesan error, tutup lagi; (3) buka `e.toFixed(2)` lalu jalankan `node ... coba`; (4) ubah `d + 1`. Hint tebakan: `c` lebih spesifik dari "array" (array berisi apa), `d` adalah hasil `find` (bisa tidak ketemu), `e` diberi anotasi eksplisit.

### 2026-11-23 — Coba Sendiri Bagian 2 (error muncul juga di tempat lain)
**Pertanyaan:** Saat menjalankan `tsc` untuk Bagian 2, error muncul tidak hanya di Coba Sendiri tetapi juga di bagian lain.
**Level hint:** 1
**Jawaban asisten:** Normal. `tsc` memeriksa seluruh file, dan starter sengaja berisi 10 error `TS7006` (parameter soal belum diberi tipe) yang hilang saat soal dikerjakan. Error Coba Sendiri dikenali dari nomor barisnya (baris 25–28, `soal-ts1.ts(25,...)`) atau disaring: PowerShell `npx tsc --noEmit | Select-String -NotMatch TS7006`, Git Bash `npx tsc --noEmit | grep -v TS7006`. Alternatif: garis merah dan panel Problems di VS Code.

### 2026-11-23 — Cek Coba Sendiri
**Pertanyaan:** Minta cek Coba Sendiri TS-1.
**Level hint:** 2
**Jawaban asisten:** Tebakan tipe akhir benar (`number`, `"qris"`, `number[]`, `number | undefined`, `any`) dan tiga pesan error Bagian 2 benar. Catatan: (1) nomor 1 menanyakan tebakan awal mana yang salah dan mengapa, misalnya `b` bertipe literal `"qris"` karena `const`, `d` bisa `undefined` karena `find` bisa tidak menemukan apa pun, `e` mengikuti anotasi; (2) nomor error (`TS2322`, `TS2345`, `TS18048`) belum ditulis; (3) alasan nomor 3 salah konsep: `tsc` diam karena `e` bertipe `any`, yang mematikan pengecekan, bukan karena "sudah dicek di awal", dan hasil runtime `TypeError: e.toFixed is not a function` karena isi `e` string; (4) nomor 4 mengubah baris deklarasi `d` (kode Bagian 1), bukan baris `console.log(d + 1)`. Diuji: `console.log(d + 1)` tetap `TS18048`, karena `tsc` tidak menyimpulkan bahwa dua panggilan `find` menghasilkan nilai yang sama. Diarahkan ke HO "null, undefined, dan strictNullChecks" Cara 2.

### 2026-11-24 — Intermediate 1 (pakai Map atau tidak)
**Pertanyaan:** Intermediate 1 memakai Map atau tidak?
**Level hint:** 2
**Jawaban asisten:** Ya, tetapi Map-nya sudah ada: `daftarHarga` dibuat di starter, jadi tidak perlu `new Map` lagi (beda dengan `buatIndex` JS-6, yang membangun Map). Tugasnya hanya membaca dengan `daftarHarga.get(kode)`, lalu memeriksa `undefined` sebelum memakai hasilnya. `const m:new Map` juga salah sintaks: setelah `:` ditulis tipe, nilai ditulis setelah `=`. Tipe kembalian sebaiknya kembali ke `string`, karena fungsi selalu mengembalikan teks (`tidak terdaftar` juga string).
