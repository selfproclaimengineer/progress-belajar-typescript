# Desain: Praktikum Mandiri JavaScript & TypeScript

Tanggal: 2026-11-01. Status: disetujui Dion (2026-11-01).

## 1. Tujuan dan alasan

Dion menyiapkan live coding TypeScript bersama interviewer dalam 2 minggu (maksimal 3 minggu). Format live coding adalah pair work. Dion menulis kode, interviewer bertanya mengapa pendekatannya begitu dan bisa mengarahkan. Kelulusan dinilai dari kemampuan diskusi dan mengikuti arahan, bukan dari problem yang selesai.

Dion sudah menonton materi sintaks JavaScript dasar di YouTube, tetapi belum pernah memakai sintaks untuk memecahkan masalah nyata. Format belajar yang paling cocok baginya adalah praktikum kuliah: handout (HO), soal bertingkat, dan laporan. Contoh terbaik adalah praktikum Database System (CE 613) topik 5.

Sukses berarti:
- Dion bisa menulis solusi kasus nyata (saldo, checkout) dalam TypeScript tanpa contekan.
- Dion bisa menjelaskan alasan setiap pilihan (`const` vs `let`, `for` vs `forEach`, class vs interface).
- Repo private `progress-belajar-typescript` menunjukkan progres harian kepada interviewer.

## 2. Goal, non-goal, anti-goal

Goal:
- 8 topik JavaScript, 7 topik TypeScript (TS-7 opsional), dan 1 Tugas Rancang.
- Setiap topik selesai dalam 1,5 sampai 3 jam.
- Semua poin dari interviewer tercakup (lihat bagian 5).

Non-goal (ditunda sampai JS dan TS dipahami): Jest, database, React, Remix, DSA lanjut.

Anti-goal:
- HO panjang berisi sejarah dan teori tanpa latihan, seperti HO Webprog topik 4.
- Soal yang bisa diselesaikan dengan menempel sintaks tanpa berpikir.
- Asisten memberi jawaban langsung.

## 3. Jadwal

Hari kerja 1 topik per hari (sekitar 2 jam). Akhir pekan 3 topik per hari.

| Tanggal | Hari | Isi |
|---|---|---|
| 1 Nov | Minggu | JS-1, JS-2, JS-3 |
| 2–6 Nov | Senin–Jumat | JS-4 sampai JS-8 |
| 7 Nov | Sabtu | TS-1, TS-2, TS-3 |
| 8 Nov | Minggu | TS-4, TS-5, TS-6 |
| 9 Nov | Senin | TS-7 REST API (opsional) |
| 10–11 Nov | Selasa–Rabu | Tugas Rancang (6 jam, dibagi 2 hari) |

Cadangan: 12–15 Nov. Jika satu topik molor, jadwal bergeser; topik tidak dilewati.

## 4. Daftar topik

JavaScript:
1. Variabel dan kondisi: `const`/`let`/`var`, tipe data, operator, `===` vs `==`, truthy/falsy, `if`/`else`, `switch`, ternary.
2. Perulangan dan fungsi: `for`, `while`, `for...of`, function declaration vs arrow function, parameter default, scope, return.
3. Array: `forEach`, `map`, `filter`, `reduce`, `find`, `some`, `every`, `includes`, `sort`. `for` vs `forEach` (kapan perlu `break`).
4. String dan object: method string, string sebagai "mirip array", object literal, destructuring, spread, salinan dangkal vs dalam, JSON.
5. OOP: `class`, constructor, method, getter, field `#private`, `extends`/`super`, object literal vs class.
6. Modules dan standard library: `import`/`export` (ESM), `Math`, `Date`, `Map`, `Set`, `Intl.NumberFormat` (format Rupiah), `throw`/`try`/`catch`.
7. Async: callback, Promise, `async`/`await`, `fetch`, error handling async.
8. DOM: `querySelector`, event listener, render daftar dari array, form input, mini halaman checkout.

TypeScript:
1. Dasar: setup (`tsc`, Node menjalankan `.ts`), type annotation, inference, union dan literal type, function type, `any` vs `unknown`, `strictNullChecks`.
2. Object type: `type` vs `interface`, optional, `readonly`, array, tuple, `Record`.
3. OOP: access modifier, `implements`, abstract class. Object vs Class vs Interface dan kapan memakai masing-masing.
4. Generics: fungsi generik, constraint (`extends`), generic class/interface, utility type (`Partial`, `Pick`, `Omit`).
5. Narrowing dan error handling: `typeof`, `in`, `instanceof`, discriminated union, custom `Error`, pola Result.
6. Validation: data dari luar bertipe `unknown`, type guard buatan sendiri, lalu library `zod`.
7. REST API (opsional): Express + TypeScript, CRUD in-memory, status code, validasi request memakai TS-6.

Tugas Rancang: aplikasi kasir supermarket dengan dompet saldo (deposit, withdraw, bayar memakai saldo) dalam TypeScript. Asisten berperan sebagai klien dan menulis dokumen kriteria. Skala 6 jam.

## 5. Pemetaan poin interviewer

| Poin interviewer | Topik |
|---|---|
| `const`, `var`, `let` | JS-1, diulang TS-1 |
| Kondisi `if` | JS-1 |
| `for` vs `forEach` | JS-2, JS-3 |
| Array: `map`, `includes`, `reduce`, `forEach`, "contains" | JS-3 |
| String manipulation | JS-4 |
| Strongly typed variable dan function | TS-1 |
| Object vs Class vs Interface | JS-5, TS-3 |
| Sistem saldo, checkout supermarket | soal di banyak topik, Tugas Rancang |

Dua poin interviewer perlu diluruskan secara sopan. Keduanya masuk ke kotak "Perhatian" dan menjadi bahan diskusi:
- Array JS tidak punya `contains()`. Yang benar `includes()`. `contains()` ada di Java/C# dan di DOM (`classList.contains`).
- String punya index, `length`, dan `includes`, tetapi tidak punya `map`/`filter`/`reduce`, dan bersifat immutable. Ubah dulu dengan `[...str]` atau `split('')`.

## 6. Format dokumen (meniru Database CE 613)

HO (PDF, dibuat dengan Typst):
1. Tujuan Praktikum (daftar kemampuan).
2. Dasar Teori singkat, banyak contoh kode bernomor ("Listing n").
3. Kotak "Catatan" (info tambahan) dan "Perhatian" (jebakan umum, sering dengan contoh salah vs benar).
4. "Coba Sendiri" di dalam HO: latihan kecil yang dikerjakan di `Jawaban/cobaN.js`.
5. Panjang 5–8 halaman.

Soal (PDF, Typst):
- Beginner (0.3), Intermediate (0.3), Advanced (0.4).
- Data awal sudah tersedia di file starter (misal `data.js` berisi daftar barang atau transaksi). Dion menulis logikanya, mirip soal Database yang datanya sudah ada.
- Jenis butir soal: tulis fungsi dengan "Contoh Output"; "kode temanmu berjalan tanpa error tetapi salah, jelaskan dan perbaiki"; "mengapa hasilnya begini"; "tulis ulang dengan cara lain dengan hasil sama".
- Bobot setara Database topik 5: sekitar 10–14 butir.

Tampilan: meniru modul Praktikum Database System CE 613 (permintaan Dion, 2026-11-01): Arial untuk teks, Consolas untuk kode, judul besar di tengah, kotak Catatan biru, Perhatian merah, Coba Sendiri hijau dengan header berwarna, caption "Listing n" di tengah, footer bergaris dengan nomor halaman.

Jawaban (diubah Dion pada 2026-11-01, menggantikan laporan PDF): kode di `Jawaban/soal-jsN.js`; jawaban *(jelaskan)* sebagai komentar di bawah baris `// JAWABAN ...` yang sudah disiapkan di starter; Coba Sendiri di `Jawaban/cobaN.js` dengan tebakan sebagai komentar. File kode jawaban juga di-commit agar asisten bisa menjalankannya.

## 7. Struktur repo

```
progress-belajar-typescript/
  README.md          ringkasan untuk interviewer: tujuan, jadwal, status
  PROGRESS.md        checklist topik + log harian
  SILABUS.md         daftar topik dan jadwal (isi bagian 3–4)
  CLAUDE.md          aturan asisten dosen (bagian 8)
  template/          template Typst bersama
  javascript/
    topik-01-variabel-kondisi/
      HO/            HO_JS_TOPIK1.typ + .pdf
      Soal/          SOAL_JS_TOPIK1.typ + .pdf + file starter
      Jawaban/       cobaN.js + soal-jsN.js (jawaban penjelasan di komentar)
      Diskusi/       DISKUSI.md (log tanya jawab) + FEEDBACK.md
    ...
  typescript/
    topik-01-dasar/ ...
  tugas-rancang/
    KRITERIA.pdf, Jawaban/, Diskusi/
  docs/design.md     dokumen ini
```

## 8. Peran asisten dosen

- Tidak pernah memberi jawaban langsung untuk soal atau Coba Sendiri.
- Tangga hint: (1) logika atau konsep yang relevan, (2) nama method atau fitur yang bisa dipakai, (3) pseudocode atau langkah, (4) potongan sintaks kecil yang bukan solusi utuh. Level 4 hanya jika Dion sudah buntu setelah level 3.
- Setiap pertanyaan dan jawaban dicatat di `Diskusi/DISKUSI.md` topik itu: tanggal, butir soal, pertanyaan, level hint, ringkasan jawaban.
- Saat jawaban siap diperiksa: jalankan kode Dion, cek terhadap Contoh Output, beri nilai per bagian (Beginner/Intermediate/Advanced) dan feedback di `Diskusi/FEEDBACK.md`. Feedback memuat yang sudah benar, yang salah, dan satu pertanyaan "mengapa" untuk latihan diskusi.
- Setiap akhir sesi: perbarui log harian di `PROGRESS.md` (tanggal, topik, durasi, macet di mana), lalu commit dan push.
- Topik berikutnya dibuat setelah topik sebelumnya dikerjakan, supaya isi bisa disesuaikan dengan kelemahan yang terlihat. Untuk akhir pekan, tiga topik dibuat sekaligus di awal hari.

## 9. Lingkungan teknis

- Node 24 (sudah terpasang). JS dijalankan dengan `node file.js`. TS dijalankan langsung dengan `node file.ts` (type stripping bawaan Node 24); pengecekan tipe dengan `npx tsc --noEmit`.
- DOM: file HTML biasa dibuka di browser, tanpa bundler.
- Dependency: `typescript` (mulai TS-1), `zod` (TS-6), `express` (TS-7). Tidak ada yang lain.
- Typst dipasang untuk membuat PDF (belum terpasang).
- GitHub: repo private `progress-belajar-typescript`. `gh` belum terpasang; GitHub Desktop sudah ada. Login GitHub dilakukan Dion sendiri. Interviewer ditambahkan sebagai collaborator jika Dion mau.

## 10. Keputusan asisten (boleh dikoreksi)

- Struktur folder per topik dengan subfolder HO/Soal/Jawaban/Diskusi.
- Urutan topik dan isi tiap topik di bagian 4, termasuk JS-7 Async yang tidak diminta tetapi dibutuhkan DOM dan REST.
- Domain kasus (disetujui Dion): kasir supermarket, dompet/bank, sistem rumah sakit, dan marketplace.
- Salinan Markdown HO tidak dibuat; sumber `.typ` sudah teks biasa yang bisa dibaca asisten.
- Folder lama `E:\Kuliah\Otodidak` tidak disentuh.
- Lokasi repo: `E:\Kuliah\progress-belajar-typescript`.
- Bahasa HO dan soal: Indonesia saja, istilah teknis tetap Inggris. Live coding memakai bahasa Indonesia, jadi format bilingual dari kurikulum lama tidak dipakai.
