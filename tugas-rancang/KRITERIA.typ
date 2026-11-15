#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Tugas Rancang", judul: "Kasir Swalayan dengan Dompet Saldo")

= Dari Klien

Kami Swalayan Sumber Rejeki, swalayan keluarga di Salatiga dengan sekitar 800 pelanggan tetap. Sejak tahun lalu kami punya program member: pelanggan bisa menyimpan saldo di kasir, lalu belanja memakai saldo itu tanpa membawa uang tunai. Pencatatannya masih di buku dan di spreadsheet. Akibatnya beberapa kali terjadi masalah:

- Saldo member tercatat minus karena kasir lupa memeriksa saldo sebelum transaksi.
- Pembayaran gagal di tengah jalan, tetapi stok barang sudah dikurangi, sehingga stok di sistem tidak cocok dengan rak.
- Member meminta riwayat saldonya, dan kami tidak bisa menunjukkan kapan saldo bertambah atau berkurang.
- Kasir baru sering salah menghitung diskon member.

Kami ingin mesin kasir baru yang menangani dompet saldo member, keranjang belanja, dan pembayaran, dengan aturan yang selalu sama siapa pun kasirnya. Tampilan layar akan dibuat tim lain. Dari kamu, kami butuh *inti programnya* dalam TypeScript.

= Cara Kerja Sama

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Hal*], [*Kesepakatan*],
  [Waktu], [Sekitar 6 jam, dibagi dua hari kerja. Saran pembagian ada di bagian Jadwal.],
  [Kontrak], [`kontrak.ts` berisi tipe data dan `interface Kasir`. Tim layar akan memanggil mesin kasir lewat kontrak ini, jadi bentuknya *tidak boleh diubah*.],
  [Desain], [Bagian dalam mesin kasir *bebas* kamu rancang: class, interface, fungsi, dan pembagian file. Kami menilai alasan desainmu, bukan kecocokan dengan satu jawaban tertentu.],
  [Uji terima], [`skenario.ts` adalah uji dari kami. Mesin kasir diterima jika outputnya sama persis dengan bagian Output Skenario di dokumen ini.],
  [Pertanyaan], [Jika ada aturan yang kurang jelas, tanyakan ke klien (asisten). Pertanyaan dan jawabannya dicatat di `Diskusi/DISKUSI.md`. Jangan menebak aturan bisnis sendiri.],
)

#perhatian[
  1. Salin semua file di `Starter/` ke `Jawaban/`: `kontrak.ts`, `data.ts`, `skenario.ts`, dan `kasir.ts`.
  2. `kontrak.ts`, `data.ts`, dan `skenario.ts` *jangan diubah*. Kodemu dimulai dari `kasir.ts`, yang wajib meng-export `buatKasir`. File tambahan boleh dibuat di folder `Jawaban/`.
  3. Cek tipe dengan `npx tsc --noEmit` (folder `tugas-rancang/Jawaban/` sudah ikut diperiksa), lalu jalankan `node tugas-rancang/Jawaban/skenario.ts`.
  4. Starter sudah bisa dijalankan. Setiap langkah menampilkan `GAGAL: belum dibuat` sampai kamu menggantinya.
  5. Jangan memakai `any`, `as`, dan tanda `!`.
]

= Aturan Bisnis

Semua uang dalam rupiah bulat (number tanpa desimal). Setiap method mengembalikan `Hasil<T>` (pola dari TS-5): `{ ok: true, nilai }` atau `{ ok: false, error }`. Pesan `error` harus *persis* seperti tabel di bawah, karena tim layar menampilkannya langsung ke pelanggan. Jika beberapa aturan dilanggar sekaligus, yang dilaporkan adalah aturan *pertama* sesuai urutan nomor.

Di pesan, `<id>`, `<kode>`, dan `<nama>` diganti nilai sebenarnya. `<selisih>` ditulis dalam format rupiah, misalnya `Rp17.800`.

== Dompet Member

#kebutuhan[
  Member bisa menambah saldo (top up) di kasir dan menarik sebagian saldo sebagai uang tunai. Laci kasir hanya menyediakan pecahan Rp50.000 untuk tarik tunai. Demi keamanan, saldo satu member dibatasi.

  *Dalam kontrak:* `topUp`, `tarikTunai`, dan `riwayat`. Nilai kembalian `topUp` dan `tarikTunai` adalah saldo setelah berubah.
]

#table(
  columns: (auto, auto, 1fr, auto),
  inset: 5pt,
  [*Method*], [*No*], [*Aturan*], [*Pesan jika dilanggar*],
  [`topUp(idMember, nominal)`], [1], [member harus ada], [`member <id> tidak ditemukan`],
  [], [2], [nominal bilangan bulat lebih dari 0], [`nominal tidak valid`],
  [], [3], [nominal minimal `10000`], [`top up minimal Rp10.000`],
  [], [4], [saldo setelah top up maksimal `2000000`], [`saldo maksimal Rp2.000.000`],
  [`tarikTunai(idMember, nominal)`], [1], [member harus ada], [`member <id> tidak ditemukan`],
  [], [2], [nominal bilangan bulat lebih dari 0], [`nominal tidak valid`],
  [], [3], [nominal kelipatan `50000`], [`tarik tunai harus kelipatan Rp50.000`],
  [], [4], [nominal tidak lebih dari saldo], [`saldo tidak cukup`],
  [`riwayat(idMember)`], [1], [member harus ada], [`member <id> tidak ditemukan`],
)

- Setiap perubahan saldo yang berhasil (top up, tarik, bayar) dicatat sebagai satu `Mutasi`: `jenis`, `nominal`, dan `saldoSetelah`.
- `riwayat` mengembalikan semua mutasi member itu, dari yang paling lama. Member tanpa mutasi mendapat array kosong.
- Mengubah array hasil `riwayat` dari luar tidak boleh mengubah catatan di dalam mesin kasir.

== Keranjang

#kebutuhan[
  Mesin kasir melayani satu pembeli pada satu waktu, jadi hanya ada satu keranjang. Kasir memindai barang satu per satu. Barang yang sama boleh dipindai berkali-kali, dan jumlahnya digabung. Kasir tidak boleh memasukkan barang melebihi stok, termasuk jika dipindai bertahap.

  *Dalam kontrak:* `tambahKeKeranjang`, `hapusDariKeranjang`, dan `stok`. Nilai kembalian kedua method keranjang adalah total keranjang saat itu (harga × qty, *sebelum* diskon).
]

#table(
  columns: (auto, auto, 1fr, auto),
  inset: 5pt,
  [*Method*], [*No*], [*Aturan*], [*Pesan jika dilanggar*],
  [`tambahKeKeranjang(kode, qty)`], [1], [produk harus ada], [`produk <kode> tidak ditemukan`],
  [], [2], [qty bilangan bulat lebih dari 0], [`qty tidak valid`],
  [], [3], [qty di keranjang setelah ditambah tidak melebihi stok], [`stok <nama> tinggal <stok>`],
  [`hapusDariKeranjang(kode)`], [1], [produk itu ada di keranjang], [`<kode> tidak ada di keranjang`],
  [`stok(kode)`], [1], [produk harus ada], [`produk <kode> tidak ditemukan`],
)

- `hapusDariKeranjang` membuang seluruh qty produk itu dari keranjang.
- Memasukkan barang ke keranjang *belum* mengurangi stok. Stok baru berkurang saat pembayaran berhasil.
- Urutan baris di struk mengikuti urutan produk pertama kali masuk keranjang. Produk yang dihapus lalu ditambah lagi pindah ke urutan paling akhir.

== Pembayaran

#kebutuhan[
  Pembeli bisa membayar tunai atau memakai saldo member. Untuk mendorong pemakaian dompet, member yang membayar dengan saldo mendapat diskon 5% jika belanjanya minimal Rp100.000. Pembayaran tunai tidak mendapat diskon. Pembayaran yang gagal tidak boleh mengubah apa pun: stok, saldo, dan isi keranjang tetap seperti sebelum dicoba, sehingga kasir bisa mencoba cara bayar lain.

  *Dalam kontrak:* `bayarTunai` dan `bayarSaldo`, keduanya mengembalikan `Struk`.
]

#table(
  columns: (auto, auto, 1fr, auto),
  inset: 5pt,
  [*Method*], [*No*], [*Aturan*], [*Pesan jika dilanggar*],
  [`bayarTunai(uang)`], [1], [keranjang tidak kosong], [`keranjang kosong`],
  [], [2], [uang bilangan bulat lebih dari 0], [`nominal tidak valid`],
  [], [3], [uang tidak kurang dari total], [`uang kurang <selisih>`],
  [`bayarSaldo(idMember)`], [1], [keranjang tidak kosong], [`keranjang kosong`],
  [], [2], [member harus ada], [`member <id> tidak ditemukan`],
  [], [3], [saldo tidak kurang dari total setelah diskon], [`saldo tidak cukup, kurang <selisih>`],
)

Diskon dan total:
- `subtotal` = jumlah harga × qty semua baris keranjang.
- `bayarSaldo`: jika `subtotal` minimal `100000`, `diskon` = 5% dari `subtotal`, dibulatkan ke bawah ke rupiah. Jika tidak, `diskon` = `0`.
- `bayarTunai`: `diskon` selalu `0`.
- `total` = `subtotal - diskon`.

Jika pembayaran berhasil, semua ini terjadi *bersama*:
1. Stok setiap produk di keranjang berkurang sesuai qty.
2. Keranjang dikosongkan.
3. Untuk `bayarSaldo`: saldo berkurang sebesar `total`, dan tercatat mutasi `"bayar"`.
4. `Struk` dikembalikan dengan `idTransaksi` `TRX-001`, `TRX-002`, dan seterusnya (bertambah hanya untuk pembayaran yang berhasil).

Isi `Struk`:

#table(
  columns: (auto, 1fr),
  inset: 5pt,
  [*Field*], [*Isi*],
  [`baris`], [satu `BarisStruk` per produk: `kode`, `nama`, `qty`, `subtotal` (harga × qty)],
  [`subtotal`, `diskon`, `total`], [seperti di atas],
  [`metode`], [`"tunai"` atau `"saldo"`],
  [`dibayar`], [tunai: uang yang diberikan. Saldo: sama dengan `total`.],
  [`kembalian`], [tunai: `dibayar - total`. Saldo: `0`.],
  [`sisaSaldo`], [hanya untuk `bayarSaldo`: saldo setelah dipotong. Untuk tunai, field ini tidak ada.],
)

= Kebutuhan Teknis

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*No*], [*Kebutuhan*],
  [T1], [`npx tsc --noEmit` bersih, dengan pengaturan `strict` di repo. Tanpa `any`, `as`, dan `!`.],
  [T2], [`kontrak.ts`, `data.ts`, dan `skenario.ts` tidak diubah. `buatKasir` di-export dari `kasir.ts`.],
  [T3], [Data yang diterima `buatKasir` boleh dipakai, tetapi data di `data.ts` tidak boleh ikut berubah. `skenario.ts` sudah mengirim salinan dengan `structuredClone`.],
  [T4], [Saldo member dan stok produk tidak bisa diubah dari luar mesin kasir selain lewat method di kontrak.],
  [T5], [Pembayaran atau perubahan saldo yang gagal tidak meninggalkan perubahan sebagian.],
  [T6], [Angka aturan (minimal top up, saldo maksimal, kelipatan tarik, batas dan persen diskon) ditulis sekali sebagai konstanta bernama, bukan tersebar di banyak tempat.],
  [T7], [Kode dipisah per tanggung jawab. Kami tidak menentukan jumlah file, tetapi satu fungsi raksasa berisi semua aturan tidak kami terima.],
)

== Dokumen desain

Selain kode, tulis `Jawaban/DESAIN.md` (cukup 1 sampai 2 halaman) yang menjawab:

1. Diagram atau daftar class/tipe yang kamu buat, dan tanggung jawab masing-masing. Boleh berupa teks atau diagram Mermaid.
2. Mengapa kamu memilih class, object biasa, atau interface untuk setiap bagian (TS-3: Object vs Class vs Interface).
3. Di mana setiap aturan bisnis diperiksa, dan bagaimana kamu menjamin T4 dan T5.
4. Mengapa kegagalan di sini dikembalikan sebagai `Hasil`, bukan `throw` (TS-5).
5. Jika nanti data pindah ke database dan mesin kasir dipanggil lewat REST API (TS-7), bagian mana yang berubah dan mana yang tetap?

= Output Skenario

Output `node tugas-rancang/Jawaban/skenario.ts` harus persis seperti di bawah. Baris judul `== ... ==` juga dicetak, tetapi tidak ditulis di sini. Langkah 16 dan 17 sengaja gagal dulu, lalu langkah 18 membayar keranjang yang sama: ini menguji T5.

#keluaran[`== Dompet ==`][```txt
01. topUp M02 50000 -> saldo Rp50.000
02. topUp M02 5000 -> GAGAL: top up minimal Rp10.000
03. topUp M03 100000 -> GAGAL: saldo maksimal Rp2.000.000
04. topUp M09 20000 -> GAGAL: member M09 tidak ditemukan
05. topUp M01 12500.5 -> GAGAL: nominal tidak valid
06. tarikTunai M01 70000 -> GAGAL: tarik tunai harus kelipatan Rp50.000
07. tarikTunai M02 100000 -> GAGAL: saldo tidak cukup
08. tarikTunai M01 50000 -> saldo Rp100.000
```]

#keluaran[`== Keranjang ==`][```txt
09. tambah P01 1 -> total Rp68.000
10. tambah P04 3 -> GAGAL: stok Telur 1 kg tinggal 2
11. tambah P04 2 -> total Rp124.000
12. tambah P04 1 -> GAGAL: stok Telur 1 kg tinggal 2
13. tambah P09 1 -> GAGAL: produk P09 tidak ditemukan
14. tambah P05 0 -> GAGAL: qty tidak valid
15. hapus P03 -> GAGAL: P03 tidak ada di keranjang
```]

#keluaran[`== Pembayaran ==`][```txt
16. bayarSaldo M01 -> GAGAL: saldo tidak cukup, kurang Rp17.800
17. bayarTunai 100000 -> GAGAL: uang kurang Rp24.000
18. bayarTunai 150000 -> TRX-001 [1x Beras 5 kg Rp68.000, 2x Telur 1 kg Rp56.000] subtotal Rp124.000, diskon Rp0, total Rp124.000, tunai Rp150.000, kembalian Rp26.000
19. stok P04 -> stok 0
20. bayarTunai 10000 -> GAGAL: keranjang kosong
21. tambah P02 2 -> total Rp36.000
22. tambah P05 4 -> total Rp42.000
23. tambah P03 1 -> total Rp58.500
24. hapus P03 -> total Rp42.000
25. bayarSaldo M02 -> TRX-002 [2x Minyak goreng 1 L Rp36.000, 4x Kopi sachet Rp6.000] subtotal Rp42.000, diskon Rp0, total Rp42.000, saldo Rp42.000, kembalian Rp0, sisa saldo Rp8.000
26. tambah P01 2 -> total Rp136.000
27. bayarSaldo M03 -> TRX-003 [2x Beras 5 kg Rp136.000] subtotal Rp136.000, diskon Rp6.800, total Rp129.200, saldo Rp129.200, kembalian Rp0, sisa saldo Rp1.820.800
```]

#keluaran[`== Laporan ==`][```txt
28. riwayat M01 -> tarik Rp50.000 (saldo Rp100.000)
29. riwayat M02 -> topup Rp50.000 (saldo Rp50.000), bayar Rp42.000 (saldo Rp8.000)
30. riwayat M03 -> bayar Rp129.200 (saldo Rp1.820.800)
31. stok P01 -> stok 7
32. stok P05 -> stok 46
33. stok P09 -> GAGAL: produk P09 tidak ditemukan
```]

#catatan[
  Skenario tidak menguji semua aturan, misalnya batas saldo maksimal untuk member yang saldonya pas `2000000`, atau `riwayat` untuk member yang tidak ada. Lolos skenario adalah syarat minimum, bukan bukti semua aturan benar. Asisten akan menjalankan beberapa uji tambahan saat memeriksa.
]

= Jadwal

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt,
  [*Hari*], [*Waktu*], [*Saran isi*],
  [1], [30 menit], [Baca kontrak dan aturan. Tulis pertanyaan ke klien. Gambar rancangan class/tipe di `DESAIN.md` (draf).],
  [1], [2,5 jam], [Dompet dan stok: `topUp`, `tarikTunai`, `riwayat`, `stok`. Target: langkah 01–08 dan 33 lolos. Langkah lain bergantung pada pembayaran.],
  [2], [2,5 jam], [Keranjang dan pembayaran. Target: semua 33 langkah lolos dan `tsc` bersih.],
  [2], [30 menit], [Rapikan kode, lengkapi `DESAIN.md`, uji sendiri beberapa kasus yang tidak ada di skenario.],
)

= Penilaian

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Bagian*], [*Yang dinilai*], [*Bobot*],
  [Uji terima], [output skenario sama persis, dan uji tambahan asisten lolos], [35],
  [Tipe dan T1–T2], [`tsc` bersih tanpa `any`, `as`, `!`; tipe internal jelas dan tepat], [10],
  [Desain], [pembagian tanggung jawab, enkapsulasi saldo dan stok (T4), konstanta (T6), pemisahan file (T7)], [25],
  [Ketahanan], [urutan pemeriksaan sesuai tabel, tanpa perubahan sebagian (T5), data awal utuh (T3)], [15],
  [`DESAIN.md`], [kelima pertanyaan dijawab dengan alasan, bukan hanya deskripsi], [15],
)

= Pengumpulan

#perhatian[
  - Kode di `tugas-rancang/Jawaban/`, termasuk `DESAIN.md`.
  - Pertanyaan ke klien selama pengerjaan dicatat di `tugas-rancang/Diskusi/DISKUSI.md`.
  - Pastikan `npx tsc --noEmit` bersih dan skenario cocok, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
  - Saat diperiksa, siapkan diri menjelaskan desainmu secara lisan, seperti di sesi live coding: asisten akan meminta satu perubahan kecil (misalnya aturan baru) dan melihat bagaimana kamu menyesuaikan kodenya.
]
