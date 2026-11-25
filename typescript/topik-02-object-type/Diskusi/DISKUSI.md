# Diskusi TS-2

### 2026-11-24 — Cukup sampai topik berapa untuk live coding
**Pertanyaan:** Sudah sampai TS-2, Advanced dilewati dulu (fokus konsep). Untuk syarat interviewer, cukup sampai topik berapa? Perkiraan Dion: TS-2 cukup, TS-3 lebih dari cukup.
**Level hint:** - (perencanaan)
**Jawaban asisten:** Menurut pemetaan poin interviewer di `SILABUS.md`, batas minimum adalah TS-3, bukan TS-2. Poin "Object vs Class vs Interface" dipetakan ke JS-5 dan TS-3: TS-2 baru membahas bentuk object dengan `type`/`interface`, sedangkan TS-3 punya class bertipe, access modifier, `implements`, dan bagian "Object, Class, atau Interface?". Poin "sistem saldo, checkout supermarket" dipetakan ke Tugas Rancang, yang paling mirip format pair work. TS-4 sampai TS-6 adalah tambahan. Saran: TS-3 lalu Tugas Rancang. Melewati Advanced boleh untuk konsep, tetapi interviewer menilai cara berpikir saat menulis kode, jadi Tugas Rancang tetap penting.

### 2026-11-24 — Beda literal, object, type, interface, class
**Pertanyaan:** Apa beda literal, object, type, interface, dan class?
**Level hint:** - (konsep, contoh bukan soal: buku perpustakaan)
**Jawaban asisten:** Kuncinya dua dunia. Dunia nilai (ada saat `node` jalan): literal (nilai yang ditulis langsung, `"tunai"`, `5000`) dan object (kumpulan field, `{ judul: ..., stok: ... }`). Dunia tipe (hanya dibaca `tsc`, dibuang saat jalan): `type` dan `interface`, yang hanya menjelaskan bentuk dan tidak bisa membuat nilai. Literal juga bisa dipakai sebagai tipe (`"tunai" | "debit"`). `class` hidup di dua dunia: menjadi tipe sekaligus pabrik object (`new`) dengan method dan data privat. `type` vs `interface`: untuk bentuk object hampir sama; `type` juga bisa union dan literal, `interface` bisa di-`extends` dan di-`implements`. Analogi: interface/type = formulir kosong, object = formulir terisi, class = mesin pencetak formulir sekaligus aturan pengisiannya. Detail pemilihan ada di HO TS-2 "type atau interface?" dan HO TS-3 "Object, Class, atau Interface?".

### 2026-11-24 — Ada semacam scanf() untuk input manual?
**Pertanyaan:** Apakah ada yang seperti `scanf()` untuk menguji input secara manual?
**Level hint:** - (alat bantu, bukan soal)
**Jawaban asisten:** Ada, `readline/promises` bawaan Node: `await rl.question("...")`. Memakai `await` (JS-7, belum dipelajari), tetapi cukup dipakai sebagai pola. Hasilnya selalu string, seperti `scanf("%s")`, jadi angka harus diubah dengan `Number()`, dan di sinilah tipe membantu (`string` dari luar, ingat `"2"` di JS-6). Diuji di repo: input `21` menghasilkan `string 21 42`. Harus dijalankan di terminal (Code Runner sudah `runInTerminal: true`). Alternatif lebih ringan: `process.argv` (seperti mode `coba`), REPL `node`, atau menulis panggilan langsung di `cobaSendiri()`. Untuk soal, file jawaban tetap tanpa input manual karena output dicocokkan otomatis.

### 2026-11-24 — Coba Sendiri tidak ada error?
**Pertanyaan:** Apakah bagian Coba Sendiri TS-2 memang tidak ada error-nya?
**Level hint:** 1
**Jawaban asisten:** Bagian 1 memang lolos `tsc` (disengaja), termasuk `nilai["b"]` yang bertipe `number` padahal isinya `undefined`; itu justru bahan pertanyaan 3. Bagian 2: diuji satu per satu, keempat baris masing-masing memunculkan satu error `tsc` di baris 29–32 jika `//` dihapus. Jika tidak terlihat, kemungkinan baris belum dibuka atau tertutup oleh error lain. Saat ini `tsc` juga menampilkan dua `TS2339` di baris 126 dan 164 (`nama` tidak ada di `Produk`), dari kode soal, bukan Coba Sendiri.

### 2026-11-25 — Soal Beginner 1: method di dalam interface?
**Pertanyaan:** Apakah interface bisa ditambah method? Perhitungan potongan di `hargaAkhir` ditaruh di dalam atau di luar `interface Produk`?
**Level hint:** 1
**Jawaban asisten:** Interface hanya dibaca `tsc`, jadi boleh memuat *signature* method (nama, parameter, tipe kembalian) tetapi tidak boleh memuat isi `{ ... }`. Isi di dalam interface memunculkan `TS1005: ';' expected` (baris 74) dan `TS1128` (baris 77). Spesifikasi menyebut `hargaAkhir(p)` dengan input `p: Produk`, artinya fungsi biasa yang menerima produk, dan kerangkanya sudah ada di bagian `===== Beginner 1 =====`. Interface `Produk` cukup berisi 6 field. Logika potongan tidak diberikan; pertanyaan balik: field mana yang mungkin `undefined`, dan apa yang harus dipakai sebagai gantinya?

### 2026-11-25 — Soal Beginner 1: hargaAkhir dibuat baru atau diubah?
**Pertanyaan:** `hargaAkhir` dibuat baru atau mengubah yang ada? Dion mengira Beginner 1 hanya meminta interface.
**Level hint:** - (cara membaca soal, bukan logika)
**Jawaban asisten:** Beginner 1 punya dua bagian: (1) lengkapi `interface Produk`, (2) `hargaAkhir(p)`. Jangan membuat fungsi baru; isi fungsi yang sudah ada di bagian `===== Beginner 1 =====`, ganti `// TODO` dan `return 0`. Interface Dion sudah benar dan `tsc` bersih. Logika potongan tidak diberikan.

### 2026-11-25 — Beda type dan interface
**Pertanyaan:** Apa beda `type` dan `interface`?
**Level hint:** - (konsep umum, contoh bukan soal: perpustakaan)
**Jawaban asisten:** Untuk bentuk object keduanya setara. `type` juga bisa union, tuple, dan tipe fungsi; `interface` tidak bisa union/tuple. Memperluas: `interface` pakai `extends`, `type` pakai `&`. Nama sama dua kali: `interface` digabung, `type` error `TS2300: Duplicate identifier`. Aturan praktikum: benda di aplikasi pakai `interface`, union/tuple/pendukung pakai `type` (HO "type atau interface?"). Dion diminta meninjau ulang jawaban Coba Sendiri 4 sendiri, karena pertanyaannya meminta jawaban untuk `Titik` dan `Kota` masing-masing.

### 2026-11-25 — Soal Intermediate 3: kode teman tidak error di tsc
**Pertanyaan:** Kode teman di Intermediate 3 katanya error, tetapi `npx tsc` bersih, baik sebelum maupun sesudah diperbaiki.
**Level hint:** 1
**Jawaban asisten:** Soal tidak menyebut kode asli error di `tsc`; bersihnya `tsc` itu memang bahan pertanyaan *(jelaskan)*. Bug-nya terlihat saat dijalankan: `node` mencetak `katalog[0].nama` sebagai `Buku Tulis`, padahal harus `Kaos Polos`. Parameter Dion masih `Produk[]`, jadi langkah 1 soal (ubah tipe parameter ke array yang hanya bisa dibaca) belum dilakukan; pola tipenya sudah Dion pakai di `stokPerKategori`. Alasan `tsc` diam dan cara memperbaiki isi fungsi tidak diberikan.

### 2026-11-25 — Soal Intermediate 3: lanjutan
**Pertanyaan:** Dion paham: tadi `tsc` diam karena ada `.map` sebelum `.sort`; tanpa itu, `readonly` memunculkan error saat data diubah.
**Level hint:** - (konfirmasi)
**Jawaban asisten:** Dikonfirmasi: `.map((p) => p)` membuat array baru yang bukan `readonly`, jadi `.sort` mengurutkan salinan; `tsc` bersih dan output cocok (`katalog[0].nama` = `Kaos Polos`). Disebutkan cara salin yang lebih umum dibaca orang (`[...daftar]`, `daftar.slice()`) sebagai pilihan, tanpa wajib diganti. Jawaban *(jelaskan)* Intermediate 3 masih belum lengkap; diminta melengkapi tiga bagian pertanyaannya sendiri.
