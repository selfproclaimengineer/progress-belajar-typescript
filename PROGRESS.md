# Progress

## Lanjut dari sini

**Berikutnya: JS-6 Modules dan Stdlib.** Coba Sendiri JS-6 sudah dijawab sebagian di `Jawaban/soal-js6.js`. Starter dan file Jawaban punya `// ≈ N baris` di bawah setiap `TODO`. Advanced cukup dikerjakan salah satu, bagian (a) pendekatan atau bagian (b) kode.

JS-5 selesai dengan nilai 80. Sisa catatan ada di `javascript/topik-05-oop/Diskusi/FEEDBACK.md`: Beginner 4 bagian kedua hilang dan contoh setter keliru, penjelasan Intermediate 3 salah konsep (`this` hilang di callback), `buka` kurang `dibuka`, dan `transfer` tidak membaca hasil `tarik` sehingga nominal 0 atau negatif dilaporkan berhasil. Macet utama JS-5: membedakan object pengirim dan penerima di `transfer`, dan arti `this` di method `Bank`.

Semua topik sudah disiapkan lebih awal atas permintaan Dion (2026-11-15), karena Dion ingin membaca semua HO dulu. Revisi dilakukan langsung saat dibutuhkan. Yang tersedia: JS-5 sampai JS-8, TS-1 sampai TS-7, dan Tugas Rancang (`tugas-rancang/KRITERIA.pdf`). Urutan yang disarankan: JS-5, JS-6, TS-1, TS-2, TS-3, Tugas Rancang, lalu TS-4 sampai TS-6 jika waktu cukup. JS-7, JS-8, dan TS-7 boleh dilewati jika waktu mepet.

Catatan teknis topik baru:
- TS-6 dan TS-7 memakai `zod` dan `express`, sudah terpasang lewat `npm install`.
- JS-8 dibuka di browser lewat `npm run sajikan` (server lokal di `127.0.0.1:8080`), karena browser menolak module dari `file://`.
- Tugas Rancang: kode di `tugas-rancang/Jawaban/`, diperiksa dengan `npx tsc --noEmit` dari root repo. Uji terima: `node tugas-rancang/Jawaban/skenario.ts`.

Format soal sejak JS-5: dibuka cerita klien, setiap tugas punya kotak *Kebutuhan klien* dan baris `Contoh:`, setiap materi HO ditutup baris *Dipakai di:*, dan kode inline di soal diwarnai per tipe data (legenda di bawah judul).

JS-4 selesai dengan nilai 86. Advanced 1 dijelaskan asisten atas kesepakatan dan tidak dinilai. Sisa catatan ada di `javascript/topik-04-string-object/Diskusi/FEEDBACK.md`: Beginner 4 belum dijalankan dan versi benarnya keliru, penjelasan Intermediate 3 kosong, dan Coba Sendiri 2 dan 3 (alamat object) belum dijawab. Macet utama JS-4: tidak bisa membayangkan input dan output, serta tidak tahu materi HO mana yang dipakai di soal mana.

JS-3 selesai dengan nilai 83. Advanced 2 dilewati atas keputusan Dion dan tidak dinilai. Sisa catatan ada di `javascript/topik-03-array/Diskusi/FEEDBACK.md`: Beginner 3 belum memakai `some`/`every`, versi benar Beginner 4 dan `console.log` yang tercetak `[]`, serta penjelasan Intermediate 2 dan 4a.

JS-2 selesai dengan nilai 81. Sisa catatan ada di `javascript/topik-02-perulangan-fungsi/Diskusi/FEEDBACK.md` (Revisi 2): label Masuk/Keluar di Beginner 2 tertukar, `totalTagihan` belum diperbaiki, dan pertanyaan diskusi `bulanMencapaiTarget(0, 0, 6, 1000000)` belum dijawab. Penjelasan bagian lain ada di `DISKUSI.md`.

JS-1 selesai dengan nilai 86.

Alur setiap topik:
1. Buka `Jawaban/soal-jsN.js` (atau `soal-tsN.ts`). File jawaban sudah disiapkan dari starter, jadi tidak perlu menyalin. Topik TS: jalankan `npx tsc --noEmit` dari folder topik, supaya hanya error topik itu yang tampil.
2. Baca HO. Kerjakan Coba Sendiri di fungsi `cobaSendiri()` pada file itu, jalankan dengan `node Jawaban/soal-jsN.js coba`.
3. Kerjakan soal Beginner, Intermediate, Advanced di file yang sama. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...`.
4. Minta asisten memeriksa. Nilai dan feedback masuk `Diskusi/FEEDBACK.md`.
5. Akhiri sesi dengan `npm run selesai -- --durasi "2 jam" --macet "..."`. Log harian dan checklist terisi otomatis, lalu di-commit dan di-push.

## Checklist

| Topik | Coba Sendiri | Soal | Diperiksa | Nilai |
|---|---|---|---|---|
| JS-1 Variabel dan kondisi | [x] | [x] | [x] | 86 |
| JS-2 Perulangan dan fungsi | [x] | [x] | [x] | 81 |
| JS-3 Array | [x] | [ ] | [x] | 83 |
| JS-4 String dan object | [x] | [ ] | [x] | 86 |
| JS-5 OOP | [x] | [ ] | [x] | 80 |
| JS-6 Modules dan standard library | [x] | [ ] | [ ] | |
| JS-7 Async | [ ] | [ ] | [ ] | |
| JS-8 DOM | [ ] | [x] | [ ] | |
| TS-1 Dasar | [ ] | [ ] | [ ] | |
| TS-2 Object type | [ ] | [ ] | [ ] | |
| TS-3 OOP | [ ] | [ ] | [ ] | |
| TS-4 Generics | [ ] | [ ] | [ ] | |
| TS-5 Narrowing dan error handling | [ ] | [ ] | [ ] | |
| TS-6 Validation | [ ] | [ ] | [ ] | |
| TS-7 REST API (opsional) | [ ] | [ ] | [ ] | |
| Tugas Rancang | | [ ] | [ ] | |

## Log harian

| Tanggal | Topik | Durasi | Yang dikerjakan | Macet di |
|---|---|---|---|---|
| 2026-11-01 | JS-1 | 4 jam (disambi rapat) | JS-1: soal, tanya jawab, feedback | baca soal berulang |
| 2026-11-02 | JS-1, JS-2 | 4 jam | JS-1: soal; JS-2: soal, tanya jawab, feedback | begadang, kurang tidur |
| 2026-11-05 | JS-2, JS-3 | 7 jam | JS-2: feedback; JS-3: soal, tanya jawab, feedback | implementasi callback: urutan chaining, kapan memakai find untuk FK-PK, map, filter |
| 2026-11-12 | JS-4 | 2 jam | JS-4: soal, tanya jawab, feedback | membayangkan input dan output (console.log di bawah), tidak tahu materi HO mana dipakai di soal mana, energi minim karena belajar malam |
| 2026-11-22 | JS-5, JS-6 | 4 jam | JS-5: soal, tanya jawab, feedback; JS-6: soal | transfer di Advanced (tarik dan setor ke rekening sendiri), this di method Bank |
