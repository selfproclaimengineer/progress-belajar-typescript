#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "Soal Modul 1", judul: "Variabel, Tipe Data, dan Kondisi")

= Tugas

Kamu membantu tim IT sebuah rumah sakit dan sebuah marketplace. Semua fungsi ditulis di satu file.

#perhatian[
  1. Salin `Soal/starter.js` ke folder `Jawaban/`, misalnya `Jawaban/soal-js1.js`.
  2. Lengkapi fungsi bertanda `TODO`. Jangan mengubah bagian `PEMANGGILAN` di bawah file.
  3. Jalankan `node Jawaban/soal-js1.js`. Output harus sama persis dengan Contoh Output.
  4. Soal bertanda *(jelaskan)* dijawab sebagai komentar di file jawaban, di bawah baris `// JAWABAN ...`.
  5. Hanya pakai materi Modul 1. Array dan method array belum boleh dipakai.
]

#level("Beginner", "0.3")

+ *Triase IGD.* Lengkapi `kategoriTriase(skorNyeri, sadar)`. Fungsi mengembalikan string kategori dengan aturan berikut, dicek *berurutan*:
  - `skorNyeri` bukan bilangan bulat, atau di luar rentang 0–10: `"INVALID"`
  - pasien tidak sadar (`sadar` bernilai `false`): `"MERAH"`
  - skor 8–10: `"MERAH"`, skor 5–7: `"KUNING"`, skor 0–4: `"HIJAU"`

+ *(jelaskan)* Perhatikan kode berikut.
  ```js
  function cekAntrean(nomor) {
    if (nomor > 10) {
      var pesan = "Antrean panjang";
    }
    return pesan;
  }
  console.log(cekAntrean(15));
  console.log(cekAntrean(3));
  ```
  + Apa output kedua baris tersebut? Mengapa baris kedua tidak error, padahal `pesan` dibuat di dalam blok `if`?
  + Ganti `var` menjadi `let`. Apa yang terjadi? Menurutmu, mana yang lebih baik untuk programmer: hasil diam-diam yang salah, atau error yang langsung terlihat? Jelaskan.

+ *Diskon kasir supermarket.* Lengkapi `hitungDiskon(totalBelanja, isMember)` yang mengembalikan *nominal* diskon dalam Rupiah, dibulatkan ke bawah.
  - Member: belanja minimal Rp 100.000 mendapat 10%, di bawah itu 5%.
  - Bukan member: belanja minimal Rp 200.000 mendapat 5%, di bawah itu 0%.

#level("Intermediate", "0.3")

+ *Biaya rawat inap.*
  + Lengkapi `hitungBiayaRawat(kelas, malam, punyaBPJS)`. Tarif per malam: `"VIP"` Rp 1.500.000, `"1"` Rp 800.000, `"2"` Rp 500.000, `"3"` Rp 250.000. Kelas lain mengembalikan `-1`. Jumlah `malam` harus bilangan bulat minimal 1, selain itu `-1`. Aturan BPJS: kelas 3 gratis; kelas 1 dan 2 pasien membayar 25% dari total; VIP tidak ditanggung BPJS. Gunakan `switch` untuk menentukan tarif.
  + *(jelaskan)* Jika kamu menulis `case "3":` lalu memanggil `hitungBiayaRawat(3, 2, false)` (angka, bukan string), hasilnya `-1`. Jelaskan penyebabnya. Lalu perbaiki fungsimu agar kelas berupa angka juga diterima *tanpa* mengubah label `case`. Baris terakhir output Intermediate 1 harus `500000`.

+ *Kode temanmu.* Dua fungsi berikut sudah ada di starter. Keduanya berjalan tanpa error, tetapi hasilnya salah.
  + Fungsi `infoStok` menampilkan stok barang di halaman marketplace. Barang dengan stok `0` malah tampil "tidak diketahui". *(jelaskan)* letak kesalahannya, lalu perbaiki.
  + Fungsi `labelBMI` dipakai di poli gizi. Pasien dengan BMI 32 mendapat label "Normal". Batas yang benar: di bawah 18,5 "Kurus"; 18,5 sampai di bawah 25 "Normal"; 25 sampai di bawah 30 "Berat berlebih"; 30 ke atas "Obesitas". *(jelaskan)* mengapa BMI 32 mendapat "Normal". Tulis *dua* cara perbaikan yang berbeda di komentar, pilih satu untuk kode, dan jelaskan mana yang lebih mudah dirawat.

#level("Advanced", "0.4")

+ *Transfer saldo dompet digital.*
  + Lengkapi `cekTransfer(saldo, nominal, pinBenar, sudahTransferHariIni)`. Konstanta `LIMIT_HARIAN` dan `MINIMAL_TRANSFER` sudah ada di starter. Fungsi mengembalikan pesan pertama yang cocok dari urutan berikut:
    + `nominal` bukan bilangan bulat atau tidak lebih dari 0: `GAGAL: nominal tidak valid`
    + PIN salah: `GAGAL: PIN salah`
    + `nominal` di bawah minimal: `GAGAL: minimal transfer Rp 10000`
    + `nominal` lebih besar dari `saldo`: `GAGAL: saldo tidak cukup`
    + total transfer hari ini (termasuk transfer ini) melebihi limit: `GAGAL: melebihi limit harian, sisa limit Rp X`, dengan X sisa limit sebelum transfer ini
    + selain itu: `BERHASIL: sisa saldo Rp Y`
    Gunakan guard clause (early return), bukan `if` bersarang. Jangan menulis angka 5000000 atau 10000 langsung di fungsi; pakai konstantanya.
  + *(jelaskan)* Temanmu menukar urutan nomor 2 dan nomor 4: saldo dicek sebelum PIN. Beri satu contoh input yang menghasilkan pesan berbeda antara versimu dan versi temanmu. Lalu jelaskan mengapa urutan temanmu berbahaya dari sisi keamanan. Petunjuk: pikirkan apa yang bisa dipelajari orang yang *tidak tahu PIN*.

+ *Ongkos kirim marketplace.*
  + Lengkapi `hitungOngkir(beratGram, zona, isPremium)`. Berat dibulatkan *ke atas* per kilogram (1.200 gram dihitung 2 kg). Tarif per kg: zona `"A"` Rp 9.000, `"B"` Rp 15.000, `"C"` Rp 25.000. Member premium gratis ongkir untuk zona A dan B, dan mendapat potongan 50% untuk zona C. Kembalikan `-1` jika berat bukan angka, tidak lebih dari 0, atau lebih dari 30.000 gram, serta jika zona tidak dikenal.
  + *(jelaskan)* Tulis bagian potongan premium memakai ternary. Lalu beri contoh dari fungsi ini yang justru menjadi sulit dibaca jika dipaksa memakai ternary, dan jelaskan alasannya.

= Contoh Output

#output[
```
== Beginner 1 ==
MERAH
KUNING
HIJAU
MERAH
HIJAU
INVALID
INVALID
== Beginner 3 ==
15000
4000
10000
2777
12500
0
== Intermediate 1 ==
3000000
600000
1000000
0
-1
-1
-1
500000
== Intermediate 2a ==
Beras 5kg: 12
Minyak 1L: 0
Gula 1kg: tidak diketahui
== Intermediate 2b ==
Kurus
Normal
Berat berlebih
Berat berlebih
Obesitas
```
]

#output[
```
== Advanced 1 ==
BERHASIL: sisa saldo Rp 750000
GAGAL: PIN salah
GAGAL: minimal transfer Rp 10000
GAGAL: saldo tidak cukup
GAGAL: melebihi limit harian, sisa limit Rp 1000000
BERHASIL: sisa saldo Rp 8000000
GAGAL: nominal tidak valid
GAGAL: nominal tidak valid
== Advanced 2 ==
18000
15000
125000
62500
0
-1
-1
-1
```
]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-js1.js`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri: `Jawaban/coba1.js`. Tebakan ditulis sebagai komentar di ujung setiap baris, jawaban pertanyaan sebagai komentar di bawah file.
  - Jalankan `npm run selesai -- --durasi "..." --macet "..."`, lalu minta asisten memeriksa.
]
