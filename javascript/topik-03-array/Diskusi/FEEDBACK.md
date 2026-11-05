# Feedback JS-3

Diperiksa 2026-11-05. Kode dijalankan dengan `node Jawaban/soal-js3.js` dan `node Jawaban/soal-js3.js coba`, lalu dicocokkan dengan Contoh Output dan kunci asisten.

Ringkasan: semua baris output dari Beginner 1 sampai Advanced 1 cocok. Advanced 2 dilewati atas kesepakatan dan tidak dinilai. Program masih berhenti di Advanced 2 dengan `TypeError`, dan mencetak `[]` di baris pertama (lihat Beginner 4).

## Coba Sendiri (tidak dinilai)

- Penjelasan `sort` tanpa pembanding (urut sebagai string) dan `map` vs `filter` (array boolean vs array yang tersaring) sudah tepat.
- Tebakan baris `angka` yang kedua juga meleset: `sort` mengubah array asli, jadi `angka` ikut menjadi `[1, 100, 25, 5]`.
- Nomor 4 benar di kode (`Budi, Joko`), tetapi komentar jawabannya kosong.

## Beginner — 75/100

**1. Benar.** Chaining `filter` lalu `map` sudah tepat.

**2. Benar.** `reduce` dengan nilai awal `0`.

**3. Sebagian.** Output benar, tetapi pertanyaan "adakah?" dan "apakah semua?" dijawab dengan `map` lalu `for` manual. Pertanyaan seperti ini sudah punya method sendiri, yaitu `some` dan `every`, masing-masing satu baris. Lihat tabel "Memilih Method" di HO.

**4. Sebagian.** Pesan error benar.
- Penyebabnya kurang tepat. `contains` bukan tidak ada di JavaScript, tetapi tidak ada di *array*. Pertanyaan ketiga, "di mana `contains()` ada", belum dijawab.
- Versi benarnya keliru. `kategoriAktif` berisi string, sehingga `p.kategori` bernilai `undefined` dan hasilnya `[]`. Method yang tepat adalah `includes("Minuman")`, yang menghasilkan `true`.
- Baris `console.log` itu berada di luar fungsi, sehingga `[]` tercetak di awal output. Pindahkan ke komentar atau hapus.

## Intermediate — 82/100

**1. Benar.** Pola JOIN `map` + `find` sudah tepat.

**2. Sebagian.** Perbaikan kodenya benar. Penjelasannya baru menyebut perbaikan, belum menjawab *mengapa* hasilnya string aneh. Tanpa nilai awal, akumulator putaran pertama adalah *object* produk pertama. Akibatnya `object + number` berubah menjadi penyambungan string `"[object Object]410..."`, bukan penjumlahan.

**3. Benar.** Penjelasan mutasi `sort` dan bahayanya tepat. `produk.map((p) => p)` memang membuat salinan. Cara yang lebih umum ditulis adalah `[...produk]`.

**4. Sebagian.**
- 4a kurang tepat. `return` di dalam callback hanya keluar dari callback putaran itu, bukan dari `cariProdukHabis`. Karena itu `forEach` tetap berjalan sampai akhir, dan `hasil` ditimpa oleh produk habis yang *terakhir*.
- 4b sudah menyebut penyebabnya (data diurutkan oleh nomor 3), tetapi belum menjelaskan kaitannya. Setelah urut berdasarkan harga, produk habis yang terakhir kebetulan adalah Minyak Goreng.
- 4c benar memakai `find`. `.map((p) => p)` sebelum `find` tidak perlu, karena `find` tidak mengubah array.

## Advanced — 90/100

**1. Benar.** Output cocok. Pola daftar kategori unik, lalu `map` + `filter`, sudah tepat. Catatan kecil: parameter `p` di `jenisKategori.map((p) => ...)` berisi string kategori, jadi nama `k` lebih jelas. Variabel `let hasil = null` juga tidak perlu.

**2. Tidak dinilai** (dilewati atas kesepakatan). Struktur yang benar sudah dibahas di `DISKUSI.md`: cek gagal di awal, lalu subtotal sekali di luar perulangan, lalu satu `return`.

## Pertanyaan diskusi

Di Beginner 3, versimu memakai `map` lalu `for`. Jika produk pertama sudah cocok dengan kategori yang dicari, berapa kali perbandingan kategori dijalankan oleh versimu, dan berapa kali oleh `some`? Mengapa berbeda?

Total: 83
