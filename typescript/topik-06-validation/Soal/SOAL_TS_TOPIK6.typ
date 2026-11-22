#import "/template/praktikum.typ": *
#show: praktikum.with(warna-tipe-data: true, modul: "Soal TypeScript Modul 6", judul: "Validasi Data dari Luar")

= Tugas

Supermarket Segar Jaya menerima pesanan antar dari dua sumber: aplikasi pelanggan dan beberapa mitra toko yang mengirim pesanan dalam bentuk teks JSON. Program kasirnya sudah ditulis dengan TypeScript, dan `tsc` tidak menemukan error. Tetapi bulan lalu ada tiga kejadian. Satu pesanan bertuliskan jumlah `"3"` (teks, bukan angka), sehingga total belanjanya terhitung salah. Satu kiriman mitra terpotong di tengah jalan, dan seluruh program berhenti karena error. Satu lagi memesan kode barang yang tidak ada di katalog, dan struk mencetak `RpNaN`.

Pemilik supermarket ingin setiap data dari luar diperiksa dulu sebelum dipakai. Data yang salah ditolak dengan pesan yang jelas, dan satu data rusak tidak boleh menghentikan pemrosesan data lainnya. Kamu diminta menulis pemeriksaan itu, pertama secara manual, lalu dengan library `zod`.

#figure(
  table(
    columns: 3,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*kode*], [*barang*], [*harga*],
    [B01], [Beras 5 kg], [68000],
    [B02], [Minyak goreng 1 L], [18000],
    [B03], [Gula 1 kg], [16500],
    [B04], [Telur 1 kg], [28000],
  ),
  caption: [Data `katalog` bertipe `Map<string, number>`: key kode barang, value harga.],
)

Setiap tugas di bawah diawali kotak *Kebutuhan klien*: apa yang diinginkan supermarket dan mengapa. Baris *Dalam kode* menunjukkan bagian kode yang menjawab kebutuhan itu. Spesifikasi teknis ada di poin-poin setelahnya.

#perhatian[
  1. Kerjakan di `Jawaban/soal-ts6.ts`. File itu sudah disiapkan dari `Soal/starter.ts`.
  2. Lengkapi bagian bertanda `TODO`. Jangan mengubah bagian `TIPE`, `DATA`, dan `PEMANGGILAN`.
  3. *Cek tipe dulu* dengan `npx tsc --noEmit`, lalu *jalankan* dengan `node Jawaban/soal-ts6.ts`. Keduanya dijalankan dari folder topik ini.
  4. Jawaban dianggap selesai jika `npx tsc --noEmit` tidak menampilkan error *dan* output `node` sama persis dengan kotak *Output dari*.
  5. Selama `SkemaPesanan` masih kosong, `tsc` menampilkan `TS2345` di baris pemanggilan Intermediate 2. Error itu hilang setelah skemanya lengkap.
  6. Jangan memakai `any`, `as`, dan tanda `!` di kodemu sendiri. Soal bertanda *(jelaskan)* dijawab sebagai komentar di bawah baris `// JAWABAN ...`.
]

#level("Beginner", "0.3")

+ *Apakah ini object?* #est(3)
  #kebutuhan[
    Setiap pesanan dikirim sebagai object JSON. Kiriman yang rusak bisa berisi apa saja: `null`, array, teks, atau angka. Sebelum membaca field apa pun, program harus yakin datanya benar-benar object biasa.

    *Dalam kode:* `apakahObject` adalah _type guard_. Jika hasilnya `true`, TypeScript tahu `x` bertipe `Record<string, unknown>`, sehingga field-nya boleh dibaca (tipenya masih `unknown`).
  ]
  - `apakahObject(x)`. Input: `x` `unknown`. Output: boolean. Tipe kembalian sudah ditulis di starter: `x is Record<string, unknown>`.
  - Hasilnya `true` hanya jika `x` object, bukan `null`, dan bukan array.
  - Contoh: `apakahObject({ a: 1 })` menghasilkan `true`. `apakahObject([1])` menghasilkan `false`, padahal `typeof [1]` adalah `"object"`.

  #keluaran[`console.log(apakahObject({ a: 1 }), apakahObject(null), apakahObject([1]), apakahObject("x"))`][```txt
  true false false false
  ```]

+ *Satu baris pesanan.* #est(3)
  #kebutuhan[
    Satu baris pesanan berisi kode barang dan jumlahnya. Gudang hanya bisa mengambil barang dalam jumlah utuh, minimal satu. Jumlah yang ditulis sebagai teks, pecahan, atau nol harus ditolak.

    *Dalam kode:* `apakahItem` adalah type guard untuk `ItemPesanan`. Pakai `apakahObject` dari Beginner 1, lalu periksa setiap field dengan `typeof`.
  ]
  - `apakahItem(x)`. Input: `x` `unknown`. Output: boolean, dengan tipe kembalian `x is ItemPesanan`.
  - Hasilnya `true` hanya jika semua syarat ini terpenuhi:
    1. `x` object (pakai `apakahObject`).
    2. `kode` string.
    3. `qty` number, bilangan bulat, dan lebih dari `0`.
  - Contoh: `apakahItem({ kode: "B01", qty: "2" })` menghasilkan `false`, karena `qty` string. `apakahItem({ kode: "B01", qty: 1.5 })` juga `false`, karena `1.5` bukan bilangan bulat.

  #keluaran[`console.log(apakahItem({ kode: "B01", qty: 2 }), apakahItem({ kode: "B01", qty: "2" }), apakahItem({ kode: "B01", qty: 1.5 }), apakahItem({ qty: 2 }))`][```txt
  true false false false
  ```]

+ *(jelaskan)* Tulis dua baris ini *sementara* di akhir file, di bawah `PEMANGGILAN`:
  ```ts
  const p: ItemPesanan = JSON.parse('{"kode":"B01","qty":"2"}');
  console.log(p.qty + 1);
  ```
  Jalankan `npx tsc --noEmit` dan `node Jawaban/soal-ts6.ts`.
  - Apa hasil `tsc`, dan apa yang dicetak `node` di baris terakhir? Mengapa hasilnya begitu?
  - Mengapa `tsc` tidak protes, padahal `qty` di JSON itu jelas string?
  - Ganti tipe `p` menjadi `unknown`. Tulis pesan error `tsc` yang muncul. Lalu bungkus `console.log` dengan `if (apakahItem(p))`. Apa yang berubah pada `tsc` dan pada output `node`?
  - Hapus lagi kedua baris itu setelah selesai.

#level("Intermediate", "0.3")

+ *Validasi pesanan secara manual.* #est(16)
  #kebutuhan[
    Aplikasi pelanggan mengirim satu pesanan sebagai teks JSON. Petugas ingin tahu *alasan pertama* sebuah pesanan ditolak, supaya pelanggan bisa memperbaikinya. Catatan untuk kurir boleh tidak diisi, tetapi jika diisi harus berupa teks.

    *Dalam kode:* `validasiManual` menerima hasil `JSON.parse` sebagai `unknown`, memeriksanya langkah demi langkah dengan type guard, lalu mengembalikan `Hasil<Pesanan>` (pola dari TS-5). `cetakHasil` (sudah ada) mencetak hasilnya.
  ]
  - `validasiManual(x)`. Input: `x` `unknown`. Output: `Hasil<Pesanan>`.
  - Pemeriksaan berurutan. Pemeriksaan pertama yang gagal langsung menentukan `error`:
    1. `x` bukan object (pakai `apakahObject`): `data harus object`.
    2. `idPelanggan` bukan string, atau string kosong: `idPelanggan wajib diisi`.
    3. `items` bukan array, atau array kosong: `items minimal 1`.
    4. Ada item yang tidak lolos `apakahItem`: `item ke-<i> tidak valid`, dengan `<i>` mulai dari `1`.
    5. `catatan` ada tetapi bukan string: `catatan harus teks`.
  - Jika semua lolos: kembalikan `{ ok: true, nilai }` dengan `nilai` object `Pesanan` baru yang dibangun dari field yang sudah diperiksa.
  - `Array.isArray` mempersempit tipe menjadi `any[]`. Simpan dulu ke variabel bertipe `unknown[]` sebelum diperiksa satu per satu (lihat HO).
  - Contoh: pesanan kedua di `contoh` punya `qty` `"3"` (string) di item pertamanya, jadi hasilnya `GAGAL: item ke-1 tidak valid`.

  #keluaran[`for (const teks of contoh) console.log(cetakHasil(validasiManual(JSON.parse(teks))))`][```txt
  OK: C01, 2 item
  GAGAL: item ke-1 tidak valid
  GAGAL: idPelanggan wajib diisi
  GAGAL: data harus object
  GAGAL: catatan harus teks
  ```]

+ *Validasi pesanan dengan zod.* #est(22)
  #kebutuhan[
    Pemeriksaan manual di Intermediate 1 sudah benar, tetapi panjang, dan pesannya kurang rinci. Untuk item yang salah, petugas hanya tahu nomornya, tidak tahu field mana yang salah. Tim ingin memakai library `zod`: aturan bentuk data ditulis sekali sebagai _skema_, dan tipe TypeScript-nya diturunkan dari skema itu.

    *Dalam kode:* `SkemaPesanan` adalah skema `zod` untuk pesanan. `PesananZod` (sudah ada) diturunkan dengan `z.infer`. `validasiZod` memakai `safeParse` dan mengubah error pertama menjadi teks.
  ]
  - `SkemaPesanan`: object `zod` dengan aturan dan pesan error berikut.

    #table(
      columns: (auto, 1fr, auto),
      inset: 5pt,
      stroke: 0.5pt + luma(170),
      [*Field*], [*Aturan*], [*Pesan jika gagal*],
      [(seluruh data)], [object], [`data harus object`],
      [`idPelanggan`], [string], [`idPelanggan harus teks`],
      [], [minimal 1 karakter], [`idPelanggan wajib diisi`],
      [`items`], [array], [`items harus array`],
      [], [minimal 1 elemen], [`items minimal 1`],
      [`items[i].kode`], [string], [`kode harus teks`],
      [`items[i].qty`], [number], [`qty harus angka`],
      [], [bilangan bulat], [`qty harus bilangan bulat`],
      [], [lebih dari 0], [`qty harus lebih dari 0`],
      [`catatan`], [string, boleh tidak ada], [`catatan harus teks`],
    )
  - `validasiZod(x)`. Input: `x` `unknown`. Output: `Hasil<PesananZod>`.
    1. Panggil `SkemaPesanan.safeParse(x)`.
    2. Berhasil: kembalikan `{ ok: true, nilai }` dengan data hasil `safeParse`.
    3. Gagal: ambil masalah *pertama* di `issues`. Gabungkan `path`-nya dengan titik. Jika `path` kosong, `error` berisi pesannya saja. Jika tidak, `error` berisi `<path>: <pesan>`.
  - Contoh: untuk pesanan kedua di `contoh`, masalah pertamanya ada di `path` `["items", 0, "qty"]` dengan pesan `qty harus angka`, jadi `error` berisi `"items.0.qty: qty harus angka"`.
  - *(jelaskan)* Bandingkan output baris kedua di sini dengan Intermediate 1. Lalu: kamu tidak menulis `interface` untuk `PesananZod`. Dari mana `tsc` tahu bentuknya, dan apa untungnya dibanding menulis `interface` dan pemeriksaan manual secara terpisah?

  #keluaran[`for (const teks of contoh) console.log(cetakHasil(validasiZod(JSON.parse(teks))))`][```txt
  OK: C01, 2 item
  GAGAL: items.0.qty: qty harus angka
  GAGAL: idPelanggan: idPelanggan wajib diisi
  GAGAL: data harus object
  GAGAL: catatan: catatan harus teks
  ```]

+ *Kode temanmu: `totalKatalogMitra(teksJson)`.* #est(6)
  #kebutuhan[
    Mitra toko mengirim katalog barang titipannya sebagai teks JSON berisi array produk. Supermarket ingin menjumlahkan harga semua produk yang datanya lengkap. Produk yang datanya tidak lengkap atau salah tipe dilewati saja. Temanmu sudah menulis fungsinya, dan `tsc` tidak protes. Tetapi untuk katalog pertama, hasilnya `"1500012000undefined"`.

    *Dalam kode:* `apakahProduk` adalah type guard buatan temanmu, dipakai di `filter`.
  ]
  - Output yang benar: number, jumlah `harga` semua produk yang valid.
    - Produk valid jika object, `kode` string, `nama` string, dan `harga` number.
    - Jika isi JSON bukan array, kembalikan `0`.
  - Perbaiki `apakahProduk`. Simpan hasil `JSON.parse` sebagai `unknown`, bukan `any`. Setelah diperbaiki, tipe parameter di `reduce` tidak perlu ditulis manual.
  - *(jelaskan)* Mengapa hasil temanmu berupa teks `"1500012000undefined"`, bukan angka? Mengapa `tsc` tidak menolak kode temanmu? Sebutkan dua penyebabnya.

  #keluaran[`console.log(totalKatalogMitra('[{"kode":"X1","nama":"Kopi","harga":15000},{"kode":"X2","nama":"Teh","harga":"12000"},{"kode":"X3","nama":"Susu"}]'))`][```txt
  15000
  ```]
  #keluaran[`console.log(totalKatalogMitra('[{"kode":"Y1","nama":"Roti","harga":9000},{"kode":"Y2","nama":"Keju","harga":31000}]'))`][```txt
  40000
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional. Kode yang kosong tidak mengurangi nilai.

+ *Memproses kiriman mitra.* #est(32)
  #kebutuhan[
    Setiap malam mitra mengirim kumpulan pesanan, satu teks JSON per baris. Ada baris yang terpotong (JSON rusak), ada yang bentuknya salah, dan ada yang memesan kode barang yang tidak dijual. Supermarket ingin semua baris tetap diproses. Baris yang gagal dicatat alasannya, baris yang lolos dihitung totalnya, dan di akhir ada ringkasan berapa yang diterima.

    *Dalam kode:* `prosesKiriman` menggabungkan semua yang sudah kamu tulis: `try...catch` untuk `JSON.parse`, `validasiZod` untuk bentuk data, dan `katalog` untuk harga.
  ]
  - `prosesKiriman(daftarTeks, hargaPerKode)`. Input: `daftarTeks` array string, `hargaPerKode` `Map<string, number>`. Output: string, beberapa baris digabung dengan `"\n"`.
  - Untuk setiap teks, dengan `<n>` nomor baris mulai dari `1`. Pemeriksaan pertama yang gagal langsung menentukan baris output:
    1. `JSON.parse` melempar error: `baris <n>: JSON rusak`.
    2. `validasiZod` gagal: `baris <n>: <error>`.
    3. Ada item yang kodenya tidak ada di `hargaPerKode`: `baris <n>: kode <kode> tidak dikenal`, untuk kode pertama yang tidak dikenal.
    4. Semua lolos: `baris <n>: OK <idPelanggan> <totalRupiah>`, dengan total = jumlah `harga × qty` semua item.
  - Baris terakhir output: `diterima <jumlah OK> dari <jumlah teks>`.
  - Contoh: baris 1 memesan B01 sebanyak 1 dan B04 sebanyak 2. Totalnya `68000 × 1 + 28000 × 2 = 124000`, jadi barisnya `baris 1: OK C10 Rp124.000`.

  + *(jelaskan, wajib)* Tulis pendekatanmu di komentar `// JAWABAN Advanced 1a`: lapisan pemeriksaannya dan urutannya, *tipe data* di setiap langkah (teks mentah, hasil `JSON.parse`, hasil `validasiZod`, hasil `hargaPerKode.get`), dan mengapa urutan itu tidak bisa ditukar. Jelaskan juga: mengapa `try...catch` dipakai hanya di sekitar `JSON.parse`, sedangkan kegagalan lainnya cukup dicatat tanpa `throw`?
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(prosesKiriman(kirimanMitra, katalog))`][```txt
  baris 1: OK C10 Rp124.000
  baris 2: JSON rusak
  baris 3: kode B09 tidak dikenal
  baris 4: items.0.qty: qty harus lebih dari 0
  baris 5: OK C14 Rp87.000
  diterima 2 dari 5
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-ts6.ts`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-ts6.ts coba`.
  - Pastikan `npx tsc --noEmit` bersih, lalu jalankan `npm run selesai -- --durasi "..." --macet "..."` dan minta asisten memeriksa.
]
