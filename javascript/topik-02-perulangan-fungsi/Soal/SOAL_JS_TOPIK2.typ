#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "Soal Modul 2", judul: "Perulangan dan Fungsi")

= Tugas

Kamu membantu tim IT sebuah bank digital dan sebuah rumah sakit. Data mutasi rekening sudah tersedia di bagian `PEMANGGILAN` pada starter. Angka positif berarti uang masuk, angka negatif berarti uang keluar.

#perhatian[
  1. Salin `Soal/starter.js` ke folder `Jawaban/`, misalnya `Jawaban/soal-js2.js`.
  2. Lengkapi fungsi bertanda `TODO`. Jangan mengubah bagian `PEMANGGILAN`.
  3. Jalankan `node Jawaban/soal-js2.js`. Output harus sama persis dengan Contoh Output.
  4. Soal bertanda *(jelaskan)* dijawab sebagai komentar di file jawaban, di bawah baris `// JAWABAN ...`.
  5. Method array selain `push` dan `length` (misalnya `map`, `reduce`, `forEach`) belum boleh dipakai. Semua perulangan ditulis manual.
  6. Setiap fungsi punya baris Input dan Output. Semua number adalah bilangan bulat, kecuali disebut desimal. Tipe parameter juga ditulis di komentar atas setiap fungsi di starter.
]

#level("Beginner", "0.3")

+ *Saldo akhir.*
  - Fungsi: `saldoAkhir(saldoAwal, mutasi)`.
  - Input: `saldoAwal` number. `mutasi` array number (positif masuk, negatif keluar).
  - Output: number, saldo setelah semua mutasi ditambahkan.
  - Wajib memakai `for` klasik.

+ *Ringkasan mutasi.*
  - Fungsi: `ringkasMutasi(mutasi)`.
  - Input: `mutasi` array number.
  - Output: string persis `Masuk: X, Keluar: Y, Transaksi: Z`.
    - `X`: jumlah semua mutasi positif.
    - `Y`: jumlah semua mutasi negatif, ditulis sebagai angka positif.
    - `Z`: banyaknya mutasi.
  - Wajib memakai `for...of`.

+ *Kode temanmu: `hitungPPN(harga)`.*
  - Input: `harga` number. Output yang benar: number, 11% dari `harga`.
  - Masalah: fungsi selalu mengembalikan `undefined`.
  + *(jelaskan)* Mengapa?
  + Perbaiki dengan *dua* cara berbeda. Pakai satu cara di kode, tulis cara lainnya di komentar.

#level("Intermediate", "0.3")

+ *Target tabungan.*
  - Fungsi: `bulanMencapaiTarget(saldoAwal, setoranBulanan, bungaPersenTahunan, target)`.
  - Input: semua number bulat, tidak negatif. `bungaPersenTahunan` bernilai `6` berarti 6% per tahun, dibagi 12 untuk setiap bulan.
  - Output: number, jumlah bulan sampai saldo *minimal* sama dengan `target`.
  - Cek sebelum perulangan:
    + `saldoAwal` sudah minimal `target`: kembalikan `0`.
    + Target tidak akan pernah tercapai: kembalikan `-1`.
  - Setiap bulan, berurutan:
    + Tambahkan `setoranBulanan` ke saldo.
    + Hitung `bunga = Math.floor(saldo * bungaPersenTahunan / 100 / 12)`, lalu tambahkan ke saldo.
    Setoran masuk di awal bulan, bunga di akhir bulan, jadi setoran bulan itu ikut berbunga. Bunga majemuk bulanan: bunga bulan depan ikut dihitung dari bunga bulan ini.
  - *(jelaskan)* Kondisi apa yang membuat target tidak pernah tercapai? Apa yang terjadi pada program jika kondisi itu tidak dicek?

+ *Kode temanmu: `totalTagihan(biaya)`.*
  - Input: `biaya` array number. Output yang benar: number, jumlah semua biaya. Array kosong menghasilkan `0`.
  - Masalah: hasilnya `NaN`.
  + *(jelaskan)* Ada *dua* kesalahan di perulangannya. Sebutkan keduanya. Mengapa hasilnya `NaN`, bukan error?
  + Tulis ulang fungsi memakai `for...of`. *(jelaskan)* Mengapa versi `for...of` tidak bisa terkena kesalahan yang sama?

+ *Antrean poli.*
  - Fungsi: `posisiPertama(antrean, kodePoli)`.
  - Input: `antrean` array string berisi kode poli satu huruf, misalnya `"A"`. `kodePoli` string.
  - Output: number, posisi pertama pasien dengan kode itu (mulai dari 1). Jika tidak ada, `-1`.
  - Perulangan harus berhenti begitu data ditemukan.
  - *(jelaskan)* Mengapa `for...of` kurang cocok untuk soal ini dibandingkan `for` klasik?

#level("Advanced", "0.4")

+ *Jadwal cicilan pinjaman.*
  + Lengkapi `jadwalCicilan(pokok, bungaPersenPerBulan, cicilanPerBulan)`.
    - Input: semua number bulat lebih dari 0.
    - Output: array string, satu string per bulan, format persis `Bulan N: bunga B, bayar P, sisa S`.
    - Sisa awal sama dengan `pokok`. Setiap bulan, berurutan:
      + Hitung `bunga = Math.floor(sisa * bungaPersenPerBulan / 100)`, lalu tambahkan ke sisa.
      + Bayar sebesar `cicilanPerBulan`. Jika sisa lebih kecil dari cicilan, bayar sebesar sisa.
      + Kurangi sisa dengan pembayaran.
      + Ulangi sampai sisa 0.
    - Jika `cicilanPerBulan` tidak lebih besar dari bunga bulan pertama, kembalikan `["TIDAK AKAN LUNAS"]`.
  + *(jelaskan)* Mengapa fungsi ini mengembalikan array string, bukan langsung `console.log` di dalam fungsi? Sebutkan minimal dua keuntungannya.

+ *Biaya admin penarikan.*
  + Lengkapi `biayaBertingkat(nominal)`.
    - Input: `nominal` number positif.
    - Output: number.
      - Sampai Rp 100.000: `0`
      - Sampai Rp 1.000.000: `2500`
      - Di atas Rp 1.000.000: `5000`
  + Lengkapi `totalBiayaAdmin(mutasi, aturanBiaya)`.
    - Input: `mutasi` array number. `aturanBiaya` fungsi yang menerima nominal positif dan mengembalikan biayanya. Contohnya `biayaFlat`, `biayaPersen`, `biayaBertingkat` di starter.
    - Output: number, jumlah biaya admin.
    - Hanya mutasi *keluar* (negatif) yang dikenai biaya.
    - Kirim nominal ke `aturanBiaya` sebagai angka positif.
  + *(jelaskan)* Temanmu mengusulkan `totalBiayaAdmin(mutasi, jenis)` dengan `jenis` berupa string `"flat"`, `"persen"`, atau `"bertingkat"`, lalu memakai `if` di dalam fungsi. Bank menambah aturan baru "gratis untuk nasabah prioritas". Bandingkan berapa banyak kode yang harus diubah pada versimu dan versi temanmu.

= Contoh Output

#output[
```
== Beginner 1 ==
1305000
0
== Beginner 2 ==
Masuk: 1575000, Keluar: 520000, Transaksi: 6
Masuk: 0, Keluar: 0, Transaksi: 0
== Beginner 3 ==
11000
2750
== Intermediate 1 ==
6
4
0
-1
== Intermediate 2 ==
525000
0
== Intermediate 3 ==
2
3
-1
```
]

#output[
```
== Advanced 1 ==
Bulan 1: bunga 20000, bayar 300000, sisa 720000
Bulan 2: bunga 14400, bayar 300000, sisa 434400
Bulan 3: bunga 8688, bayar 300000, sisa 143088
Bulan 4: bunga 2861, bayar 145949, sisa 0
TIDAK AKAN LUNAS
== Advanced 2 ==
7500
2600
5000
0
```
]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-js2.js`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-js2.js coba`.
  - Jalankan `npm run selesai -- --durasi "..." --macet "..."`, lalu minta asisten memeriksa.
]
