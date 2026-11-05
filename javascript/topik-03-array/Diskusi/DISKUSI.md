# Diskusi JS-3

Log tanya jawab dengan asisten. Format per entri: tanggal, butir soal, pertanyaan, level hint, ringkasan jawaban.

### 2026-11-02 — Coba Sendiri 4
**Pertanyaan:** Cara memakai `join`? `p.nama.join(", ")` error, apakah `.join(p)`?
**Level hint:** - (sintaks umum, dijawab dengan contoh di luar soal)
**Jawaban asisten:** `join` adalah method array. Di dalam `map`, `p.nama` adalah string, jadi `p.nama.join` tidak ada (`TypeError: p.nama.join is not a function`). Argumen `join` adalah pemisah, bukan data. `join` dipanggil sekali pada array hasil `map`, sebagai langkah terakhir chaining. Contoh memakai array `buah`.

### 2026-11-02 — Cek Coba Sendiri
**Pertanyaan:** Dion minta Coba Sendiri diperiksa.
**Level hint:** 1
**Jawaban asisten:** Jawaban 1 (sort tanpa pembanding mengurutkan sebagai string) dan 3 (reduce perlu nilai awal) benar. Diarahkan dengan pertanyaan: mengapa output baris 1 dan 2 sama persis. Dikoreksi: `map` tidak mengubah array asli, tetapi membuat array baru dengan panjang sama. Jawaban 4 belum memakai `join`, outputnya masih array. Nama file diminta diganti menjadi `Jawaban/soal-js3.js` agar terbaca `npm run selesai`.

### 2026-11-02 — Umum (analogi SQL)
**Pertanyaan:** Apakah chaining method array mirip query database (SELECT, WHERE, GROUP BY, ORDER BY, LIMIT)? Apa padanannya di JS?
**Level hint:** - (konsep umum, dijawab langsung dengan contoh di luar soal)
**Jawaban asisten:** Ya, analoginya tepat. WHERE = `filter`, SELECT = `map`, ORDER BY = `sort`, LIMIT = `slice(0, n)`, COUNT = `length`, SUM = `reduce`, EXISTS = `some`, LIMIT 1 = `find`. Bedanya: urutan chaining di JS adalah urutan eksekusi, jadi `filter` sebelum `map`. GROUP BY tidak dijelaskan karena itu inti Advanced 1. Perbedaan `sort` dengan ORDER BY dikembalikan ke pertanyaan Coba Sendiri baris 2.

### 2026-11-02 — Soal Beginner 1
**Pertanyaan:** Jawaban ditaruh di mana, kok di bagian pemanggilan sudah ada `join`? Muncul `TypeError: namaProdukTersedia(...).join is not a function`.
**Level hint:** 1
**Jawaban asisten:** Jawaban tetap di dalam fungsi. Fungsi harus mengembalikan array string (sesuai komentar tipe `string[]`), lalu bagian pemanggilan yang menggabungkannya dengan `join`. Kode Dion sudah memanggil `join` di dalam fungsi, sehingga fungsi mengembalikan string, dan `join` kedua dipanggil pada string. Dijelaskan juga alasannya: fungsi yang mengembalikan data mentah bisa dipakai ulang untuk tampilan lain.

### 2026-11-02 — Soal Beginner 2–4
**Pertanyaan:** Cek Beginner. Mengapa hasilnya jadi array yang banyak sekali?
**Level hint:** 1–2
**Jawaban asisten:** Beginner 2 benar. Beginner 3: `map` selalu menghasilkan array sepanjang data asli (8 boolean), padahal output harus satu boolean. Diarahkan ke tabel analogi SQL (EXISTS dan "semua baris memenuhi syarat"), plus kata "minimal" yang berarti `>=`. Beginner 4: pesan error benar. Diarahkan bahwa `kategoriAktif` berisi string, sehingga `p.kategori` bernilai `undefined` dan hasilnya `[]`. Disarankan mencari method array di MDN yang namanya mirip `contains`. Pertanyaan "di mana `contains()` ada" belum dijawab.

### 2026-11-02 — Soal Intermediate 1
**Pertanyaan:** Apakah Intermediate sudah memakai konsep foreign key dan primary key?
**Level hint:** 1
**Jawaban asisten:** Ya. `produk.id` berperan sebagai primary key dan `keranjang[].idProduk` sebagai foreign key, sehingga `rincianCheckout` setara dengan JOIN. Bedanya, JS tidak punya JOIN otomatis: untuk setiap item keranjang, produk dicari sendiri lewat id. Diarahkan ke baris "LIMIT 1 dengan WHERE" di tabel analogi SQL. JS juga tidak menjaga referential integrity, jadi id yang tidak ada di data menghasilkan `undefined` (dibahas di Advanced 2).

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Bagaimana menampilkan dua data (nama dan qty)? Apakah cukup satu `map`? Di Beginner 1 terasa ada dua data yang muncul.
**Level hint:** 1–2
**Jawaban asisten:** Di Beginner 1 hanya satu data yang tampil (`nama`). `stok` dipakai `filter` untuk menyaring, tidak ditampilkan. Satu `map` cukup: callback boleh berisi beberapa baris (cari produk, hitung subtotal), lalu mengembalikan satu template literal yang menggabungkan beberapa nilai. Contoh umum memakai data mahasiswa. Kode Dion saat ini: `map` berjalan di `produk` padahal output satu per item keranjang, dan `keranjang.idProduk` bernilai `undefined` karena `keranjang` adalah array.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Di database cukup `WHERE p.id = keranjang.idProduk`. Bagaimana bentuknya di JS?
**Level hint:** 3
**Jawaban asisten:** Di SQL, `keranjang.idProduk` otomatis berarti baris yang sedang diproses. Di JS, `keranjang` adalah seluruh array, jadi "baris saat ini" adalah parameter callback `map` pada keranjang. Kondisi WHERE pindah ke callback `find` (link MDN). Pseudocode: map tiap item keranjang, cari satu produk yang `id`-nya sama dengan `idProduk` item itu, hitung subtotal, kembalikan string format.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Masih muncul `TypeError: Cannot read properties of undefined (reading 'map')`. Kenapa?
**Level hint:** 4
**Jawaban asisten:** `keranjang.idProduk` bernilai `undefined` karena `keranjang` adalah array, sehingga `find` tidak menemukan apa-apa dan mengembalikan `undefined`. `.map` lalu dipanggil pada `undefined`. Walaupun `find` berhasil, hasilnya satu object, bukan array, jadi tidak punya `map`. Baris berikutnya memakai `p` yang tidak didefinisikan. Rangka `for` milik Dion sudah tepat: pindahkan `find` ke dalam perulangan dan pakai `keranjang[i].idProduk`. Diberi potongan satu baris `find` di dalam perulangan. HO JS-3 ditulis ulang lebih rinci atas permintaan Dion.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Apakah chaining punya hierarki urutan seperti SQL, misalnya `find` tidak boleh sebelum `map`?
**Level hint:** umum (pertanyaan sintaks, dijawab langsung dengan contoh non-soal)
**Jawaban asisten:** Tidak ada urutan klausa yang tetap seperti SQL. Aturannya satu: method berikutnya dipanggil pada hasil method sebelumnya, jadi hasil itu harus punya method tersebut. `map`, `filter`, `slice`, `sort` mengembalikan array, sehingga chaining bisa lanjut. `find` mengembalikan satu elemen atau `undefined`, `some`/`every`/`includes` mengembalikan boolean, `join` mengembalikan string, `reduce` mengembalikan nilai akhir, sehingga chaining array berhenti di situ. `find` setelah `map` sah, `map` setelah `find` error (`a.find(...).map is not a function`). `find` di dalam callback `map` sah karena bersarang, bukan chaining. Urutan tetap memengaruhi hasil: `slice` lalu `sort` berbeda dengan `sort` lalu `slice`, dan `filter` sebaiknya sebelum `map` supaya field yang dibutuhkan masih ada.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Versi satu item (`keranjang[0]`) dicek. Apakah konsepnya sudah benar sebelum lanjut ke perulangan?
**Level hint:** 1–2
**Jawaban asisten:** Konsep JOIN sudah benar: kondisi memakai satu elemen keranjang (`keranjang[0].idProduk`), bukan seluruh array, dan subtotal `harga * qty`. Tiga masalah: `barang1` tanpa `const`/`let` menimbulkan `ReferenceError: barang1 is not defined` karena file berjalan sebagai ES module (strict mode); `filter` mengembalikan array sehingga `barang1.nama` bernilai `undefined`, pakai `find`; format output tanpa spasi setelah `x`. Perulangan belum diberi, Dion mencoba sendiri.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Versi satu item dicek lagi.
**Level hint:** 1
**Jawaban asisten:** Baris pertama sudah keluar persis `Beras Premium 5kg x1 = 78000`: `find` dipakai dengan benar, satu object produk, format cocok. Baris komentar `produk.map((p)=>p.harga).find((p)=> p.id===...)` keliru konsep: setelah `map` ke `harga`, elemennya number dan tidak punya `id`, jadi hasilnya `undefined`. Langkah berikutnya: perulangan atas semua item keranjang, dicoba sendiri oleh Dion.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Versi perulangan dicek. Apakah ada cara yang lebih baik?
**Level hint:** 3
**Jawaban asisten:** Output salah: keempat baris memakai "Beras Premium 5kg" karena `find` dijalankan sekali di luar perulangan dengan `keranjang[0]`. `qty` sudah berganti tiap putaran, produknya tidak. Pindahkan `find` ke dalam perulangan dengan `keranjang[i]`. `for...in` memberi indeks sebagai string dan ditujukan untuk key object, untuk array pakai `for...of` atau `for` indeks. Cara yang lebih baik: `keranjang.map` dengan callback yang mencari produk lalu mengembalikan string (pseudocode, tanpa kode jadi). `totalCheckout` memakai pola yang sama dengan `reduce`.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Minta sintaks langsung, karena solusi perulangan sudah ditemukan walau belum optimal.
**Level hint:** 4
**Jawaban asisten:** Perbaikan versi Dion: pindahkan baris `find` ke dalam perulangan dan ganti `keranjang[0]` dengan item putaran itu. Sintaks `map` dan `reduce` untuk JOIN diberikan lengkap memakai contoh non-soal (buku dan peminjaman, denda = dendaPerHari × telat), sudah dijalankan di Node. Dion tinggal memetakan nama field ke data soal.

### 2026-11-03 — Soal Intermediate 1
**Pertanyaan:** Versi `map` masih error `TypeError: rincianCheckout is not a function or its return value is not iterable`. Kenapa?
**Level hint:** 1–2
**Jawaban asisten:** Isi `map` sudah benar (`find` di dalam callback). Dua masalah: (1) hasil `map` disimpan di `const rincian` tetapi fungsi tidak mengembalikannya, sehingga `rincianCheckout` mengembalikan `undefined` dan `for...of` tidak bisa mengulang `undefined`; (2) callback mengembalikan string yang dibungkus `[ ]`, sehingga hasilnya array of array, bukan array of string. Perbaikan dikerjakan Dion.

### 2026-11-04 — Soal Intermediate 4
**Pertanyaan:** Apakah jawaban 4a, 4b, dan perbaikan kode sudah benar secara konsep?
**Level hint:** 1–2
**Jawaban asisten:** 4a belum tepat: masalahnya bukan forEach tidak mengembalikan nilai, tetapi `return` hanya keluar dari callback untuk elemen itu, forEach tetap lanjut, dan `hasil` ditimpa produk stok 0 berikutnya (Susu). 4b arahnya benar tetapi belum menjelaskan mekanisme: setelah sort harga naik, Susu (18900) berada sebelum Minyak (36000), jadi yang terakhir menimpa `hasil` adalah Minyak. 4c pemilihan `find` sudah tepat, tetapi `map` ke `nama` dijalankan lebih dulu sehingga elemen berupa string tanpa `stok` dan `find` selalu gagal (output `null null`). Urutan dibalik: cari object dulu, baru ambil nama. Pakai `===`.

### 2026-11-04 — Soal Intermediate 1
**Pertanyaan:** Apakah konsepnya sudah benar? Minta penjelasan rinci struktur sintaks callback, termasuk arti `(p)`.
**Level hint:** umum (pertanyaan sintaks, dijawab langsung dengan contoh non-soal `tagihan`)
**Jawaban asisten:** `rincianCheckout` dan `totalCheckout` sudah menghasilkan output yang cocok. `reduce` di `totalCheckout` belum punya nilai awal `0`, jadi keranjang kosong akan error `Reduce of empty array with no initial value`. Dijelaskan anatomi `tagihan.map((t) => { ... })`: `map` menerima fungsi sebagai argumen, `(t)` adalah parameter yang diisi `map` dengan satu elemen per putaran (mirip alias baris `FROM tagihan t`), `=>` memisahkan parameter dan isi, `{}` butuh `return`, nilai `return` dikumpulkan menjadi array baru. Ditunjukkan versi fungsi bernama `tagihan.map(hitung)`, tabel per putaran, parameter kedua index, dan `find` di dalam `map` sebagai correlated subquery yang memakai variabel luar `k`.

### 2026-11-04 — Soal Advanced 1
**Pertanyaan:** Apakah `map` sama dengan `for`, sehingga `for` tidak perlu ditulis lagi? Bagaimana dengan Advanced 1?
**Level hint:** 3
**Jawaban asisten:** `map` adalah satu pola perulangan khusus (satu elemen masuk, satu nilai keluar, panjang sama). Method lain juga pola khusus. `for` tetap dibutuhkan untuk perulangan yang bukan atas array (misalnya simulasi cicilan JS-2), perulangan dengan kondisi berhenti yang bukan "ketemu elemen", dan kasus yang lebih jelas ditulis manual. Kode Advanced 1 Dion: `map` berjalan di `produk` sehingga hasilnya 8 baris, bukan 3; `hasil` dipakai di dalam definisinya sendiri saat masih `null` sehingga error `Cannot read properties of null (reading 'kategori')`; urutan teks `stok` terbalik. Ide agregasi (`map` lalu `reduce`) sudah benar. JS tidak punya GROUP BY: langkah 1 kumpulkan kategori unik (SELECT DISTINCT, boleh `for...of` + `includes` + `push`), langkah 2 `map` atas daftar kategori, di dalamnya `filter` produk per kategori lalu hitung jumlah, total stok, dan omzet. Diberi pseudocode.

### 2026-11-04 — Soal Intermediate 1
**Pertanyaan:** Mengapa callback `map` berisi `{}` dan `const data = ...` sehingga terasa bertumpuk? Apakah ada cara lain, atau itu hanya deklarasi tambahan supaya baris tidak terlalu panjang?
**Level hint:** umum (pertanyaan sintaks, contoh non-soal buku dan peminjaman)
**Jawaban asisten:** `{}` diperlukan karena callback berisi lebih dari satu pernyataan. `const data` adalah variabel lokal yang dibuat ulang setiap putaran. Variabel ini dipakai karena produk yang sama dibutuhkan dua kali (nama dan harga). Tanpa variabel, `find` harus ditulis dan dijalankan dua kali dalam satu baris panjang. Alternatif tanpa tumpukan: pindahkan callback atau pencarian ke fungsi bernama, lalu `map(baris)`. Jadi alasan Dion benar: deklarasi itu untuk keterbacaan, sekaligus menghindari pencarian ganda. Dicatat juga bahwa panah ditulis `=>`, bukan `==>`.

### 2026-11-04 — Soal Advanced 1
**Pertanyaan:** Di mana letak errornya? Apakah `p.terjual*p.harga` tidak boleh, karena muncul TypeError?
**Level hint:** 2
**Jawaban asisten:** `p.terjual*p.harga` tidak salah. Error `Cannot read properties of null (reading 'kategori')` menunjuk `hasil.kategori` (tanda `^` di kolom 21, properti yang dibaca `kategori`). Sisi kanan `hasil = produk.map(...)` dijalankan dulu sampai selesai, baru hasilnya disimpan, jadi selama callback berjalan `hasil` masih `null`. Variabel tidak bisa dipakai di dalam perhitungan nilainya sendiri. Diingatkan lagi masalah struktur: `map` atas `produk` memberi 8 baris; ikuti pseudocode dua langkah (kategori unik, lalu `map` per kategori dengan `filter`).

### 2026-11-04 — Soal Advanced 1
**Pertanyaan:** Apakah ini seperti GROUP BY? Di JS pakai apa?
**Level hint:** 2
**Jawaban asisten:** Ya, Advanced 1 setara `GROUP BY kategori` dengan COUNT dan SUM. Method array klasik tidak punya GROUP BY, jadi dikerjakan dua langkah: kumpulkan kategori unik (SELECT DISTINCT), lalu `map` per kategori dengan `filter` (WHERE) dan `length`/`reduce` (COUNT/SUM). JS modern (ES2024, Node 21+) punya `Object.groupBy(array, callback)` yang mengembalikan object berisi array per grup, dibaca dengan `Object.entries`. Contoh non-soal data nilai per kelas. Disarankan mengerjakan versi dua langkah dulu karena itu konsep yang dilatih, `Object.groupBy` boleh sebagai versi kedua.

### 2026-11-04 — Soal Advanced 1
**Pertanyaan:** Apakah SELECT DISTINCT perlu? Apakah `for...of` membuat satu array per kategori? Apakah ini seperti foreign key ke dirinya sendiri? Dion mentok karena hint setengah-setengah.
**Level hint:** 4
**Jawaban asisten:** Bukan foreign key, karena hanya ada satu array dan tidak ada relasi. Ini murni pengelompokan. `for...of` hanya membuat satu array berisi nama kategori unik (`["B", "A"]`), bukan satu array per kategori. Array per kategori dibuat belakangan dengan `filter` di dalam `map`. Daftar unik perlu karena jumlah baris output sama dengan jumlah kategori, dan `map` menghasilkan satu nilai per elemen. Diberi kode lengkap versi non-soal (nilai siswa per kelas) beserta tabel jalannya, sudah dijalankan di Node.

### 2026-11-04 — Soal Advanced 1
**Pertanyaan:** Masih error `reading 'kategori'`.
**Level hint:** 4
**Jawaban asisten:** Langkah 1 (`jenisKategori` lewat `for...of` + `includes`) sudah benar. Baris `const isi = ...` masih dikomentari, dan `return` masih memakai `hasil` (bernilai `null`) di tiga tempat. Perbaikan: aktifkan baris `isi`, ganti `hasil.kategori` dengan `p` (string nama kategori), ganti `hasil.length` dan `hasil.map` dengan `isi`. Disarankan mengganti nama parameter luar `p` menjadi `k`, karena isinya string kategori dan bertabrakan dengan `p` di callback dalam. Diverifikasi pada salinan file: output Advanced 1 cocok.

### 2026-11-04 — Soal Advanced 1
**Pertanyaan:** Apa arti `p`? Bagaimana `produk.filter(... === p)` bisa mengelompokkan? Apakah pemahaman "loop per kategori, lalu di dalamnya hitung panjang, stok, omzet" sudah benar? Apakah kebingungan ini karena HO?
**Level hint:** umum (penjelasan konsep setelah soal selesai)
**Jawaban asisten:** `p` berisi satu string kategori per putaran `map`. `map` tidak mengelompokkan, ia hanya menyerahkan string satu per satu. Yang mengelompokkan adalah `filter`, yang membandingkan `kategori` setiap produk dengan string putaran itu, seperti menjalankan `WHERE kategori = '...'` tiga kali dengan nilai berbeda. Ringkasan Dion benar. Diakui bahwa HO JS-3 tidak memuat pola pengelompokan sama sekali (tidak ada bagian GROUP BY), dan hint sebelumnya setengah-setengah. Ditawarkan bagian HO baru "Mengelompokkan Data".

### 2026-11-04 — Soal Advanced 1
**Pertanyaan:** Minta bagian GROUP BY ditambahkan ke HO.
**Level hint:** -
**Jawaban asisten:** Ditambahkan bagian "Mengelompokkan Data (GROUP BY)" di HO JS-3 (setelah bagian JOIN): untuk apa, versi SQL, dua langkah (daftar unik lalu `map` + `filter`), tabel jalannya kedua langkah, peran `k`/`map`/`filter`, versi `for`, kesalahan umum, dan catatan `Object.groupBy`. Tabel pemilihan method diberi catatan bahwa JOIN dan GROUP BY disusun dari method lain. Contoh diverifikasi di Node.

### 2026-11-04 — Soal Advanced 2
**Pertanyaan:** Mengapa semua output Advanced 2 `undefined`?
**Level hint:** 3
**Jawaban asisten:** Penyebab langsung: `checkout` tidak punya `return`. Hasil `map` disimpan di `list` lalu dibuang, dan fungsi tanpa `return` mengembalikan `undefined`. Masalah struktur: `map` menghasilkan satu string per item, padahal `checkout` harus mengembalikan satu string untuk seluruh keranjang. Pengecekan item harus berhenti di kegagalan pertama, dan subtotal adalah jumlah semua item. Cek keranjang kosong belum ada. `kodePromo===null || "HEMAT10" || "GRATIS-ONGKIR"` selalu truthy karena string tidak kosong bernilai truthy, jadi bandingkan `kodePromo` di setiap sisi atau pakai `includes`. Cabang HEMAT10 dan GRATIS-ONGKIR tidak punya `return`. Diberi pseudocode urutan cek sesuai soal.

### 2026-11-04 — Soal Advanced 2
**Pertanyaan:** Bagaimana menggabungkan semua item keranjang? Seharusnya dijumlah dulu, baru diskon dan ongkir, baru total.
**Level hint:** 4
**Jawaban asisten:** Urutan pikir Dion benar. Masalahnya, semua perhitungan masih di dalam callback `map`, sehingga dijalankan per item. Di dalam `map` hanya ada satu item, jadi tidak bisa menjumlah semua. `k.harga` bernilai `undefined` karena harga ada di produk, bukan item keranjang, sehingga muncul `Cannot read properties of undefined (reading 'reduce')`. `total` juga dipakai sebelum dideklarasikan. Struktur yang benar: cek gagal (kosong, `for...of` per item, kode promo), lalu subtotal sekali di luar perulangan lewat `totalCheckout`, lalu diskon, ongkir, total, dan satu `return`. Diberi contoh lengkap non-soal (pembayaran kafe dengan voucher dan biaya layanan), diverifikasi di Node.
