# Diskusi JS-5

### 2026-11-15 — Coba Sendiri 1–4 (pemeriksaan)
**Pertanyaan:** Dion minta Coba Sendiri diperiksa. Bingung kenapa `typeof Kucing` mencetak `function`, kenapa `suara` tidak ikut di JSON, isi `this` di `lepas()`, dan error di nomor 4.
**Level hint:** 1–2 (pemeriksaan dan penjelasan konsep)
**Jawaban asisten:** Tebakan baris 2 (`class true`) dan baris 5 (`{"nama":"Oyen","meong"}`) salah. Class di JS adalah function khusus, jadi `typeof` mencetak `function`. Method tersimpan di prototype (bersama untuk semua object), bukan di object; `JSON.stringify` hanya menyalin field milik object sendiri, dan function tidak pernah ikut. Nomor 3: error benar, tetapi `this` saat `lepas()` adalah `undefined`, bukan Oyen, karena tidak ada object di depan titik. Nomor 4: `console.log(k.namaBesar)` ditaruh di luar `cobaSendiri()`, jadi `ReferenceError: k is not defined` (scope), bukan error yang sama dengan nomor 3; dipindah ke dalam fungsi mencetak `OYEN`. Pertanyaan "mengapa tanpa ()" belum dijawab, diberi hint level 1.

### 2026-11-15 — Coba Sendiri 1–4 (pemeriksaan revisi)
**Pertanyaan:** Dion merevisi jawaban Coba Sendiri dan minta dicek lagi.
**Level hint:** 1
**Jawaban asisten:** Nomor 1 dan 2 sudah benar. Nomor 3: isi `this` sudah benar (`undefined`), alasannya belum ditulis (tidak ada object di depan titik saat `lepas()` dipanggil). Nomor 4: pesan error `k.namaBesar is not a function` benar, alasannya belum; hint: `k.namaBesar` sudah menghasilkan apa, lalu `()` mencoba memanggil apa.
