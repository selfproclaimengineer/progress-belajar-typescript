#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "Soal Modul 4", judul: "String dan Object")

= Tugas

Kamu membantu bagian pendaftaran sebuah klinik. Data `pasien` sudah tersedia di bagian `DATA` pada starter. Data ini diketik petugas, jadi penulisan nama belum rapi.

#figure(
  table(
    columns: 6,
    inset: 5pt,
    stroke: 0.5pt + luma(170),
    [*id*], [*nama*], [*umur*], [*poli*], [*alergi*], [*kontak*],
    [P001], [`"budi santoso"`], [40], [Umum], [`["Penisilin", "Debu"]`], [`{ telepon, alamat }`],
    [P002], [`"  SARI   dewi "`], [7], [Anak], [_tidak ada properti_], [`{ telepon, alamat }`],
    [P003], [`"joko"`], [65], [Umum], [`[]`], [`{ telepon, alamat }`],
    [P004], [`"rina AYU lestari"`], [30], [Gigi], [`["Udang"]`], [`{ telepon, alamat }`],
  ),
  caption: [Data `pasien`],
)

Bentuk satu pasien, ditulis gaya TypeScript. Tanda `?` berarti properti itu boleh tidak ada.

```ts
Pasien = {
  id: string, nama: string, umur: number, poli: string,
  alergi?: string[],
  kontak: { telepon: string, alamat: string }
}
```

#perhatian[
  1. Salin `Soal/starter.js` ke folder `Jawaban/`, misalnya `Jawaban/soal-js4.js`.
  2. Lengkapi fungsi bertanda `TODO`. Jangan mengubah bagian `DATA` dan `PEMANGGILAN`.
  3. Jalankan `node Jawaban/soal-js4.js`. Setiap tugas punya kotak *Output dari* `console.log(...)`. Kotak itu menunjukkan baris `console.log` mana di bagian `PEMANGGILAN` yang mencetaknya, dan output yang harus keluar persis. Program juga mencetak judul seperti `== Beginner 1 ==` sebagai pemisah.
  4. Soal bertanda *(jelaskan)* dijawab sebagai komentar di file jawaban, di bawah baris `// JAWABAN ...`.
  5. Jangan mengubah array `pasien`. Semua number adalah bilangan bulat.
]

#level("Beginner", "0.3")

+ *Rapikan nama.*
  - Fungsi: `formatNama(nama)`.
  - Input: `nama` string.
  - Output: string. Spasi di awal dan akhir dibuang. Kata dipisah tepat satu spasi. Setiap kata diawali huruf kapital, sisanya huruf kecil.
  - Spasi ganda di tengah tidak boleh menghasilkan kata kosong.

  #keluaran[`console.log(pasien.map((p) => formatNama(p.nama)).join(", "))`][```txt
  Budi Santoso, Sari Dewi, Joko, Rina Ayu Lestari
  ```]

+ *Sensor nomor telepon.*
  - Fungsi: `sensorTelepon(telepon)`.
  - Input: `telepon` string berisi angka.
  - Output: string dengan panjang yang sama. Hanya 4 karakter terakhir yang terlihat, sisanya diganti `*`. Jika panjangnya 4 atau kurang, kembalikan apa adanya.

  #keluaran[`console.log(sensorTelepon(pasien[0].kontak.telepon))`][```txt
  ********7890
  ```]
  #keluaran[`console.log(sensorTelepon("1234"))`][```txt
  1234
  ```]

+ *Kode antrean.*
  - Fungsi: `kodeAntrean(poli, nomor)`.
  - Input: `poli` string, `nomor` number dari 1 sampai 999.
  - Output: string format `<kodePoli>-<nomor3digit>`.
    - `<kodePoli>`: 3 huruf pertama `poli`, huruf kapital semua.
    - `<nomor3digit>`: `nomor` dengan angka 0 di depan sampai panjangnya 3.

  #keluaran[`console.log(kodeAntrean("Umum", 7))`][```txt
  UMU-007
  ```]
  #keluaran[`console.log(kodeAntrean("gigi", 125))`][```txt
  GIG-125
  ```]

+ *(jelaskan)* Temanmu ingin mengubah huruf pertama nama menjadi kapital dan menulis kode berikut. Jalankan kode ini di `cobaSendiri()` atau file terpisah.
  ```js
  const nama = "budi";
  nama[0] = "B";
  console.log(nama);
  ```
  - Tulis pesan error lengkapnya.
  - Mengapa huruf di dalam string tidak bisa diganti lewat index, padahal huruf di array bisa?
  - Tulis versi yang benar sehingga tercetak `Budi`.

#level("Intermediate", "0.3")

+ *Ringkasan pasien.*
  - Fungsi: `ringkasPasien(p)`.
  - Input: `p` satu `Pasien`.
  - Output: string format `<nama> (<umur> th), poli <poli>, alergi: <daftarAlergi>`.
    - `<nama>`: nama yang sudah dirapikan dengan `formatNama` dari Beginner 1.
    - `<daftarAlergi>`: isi `alergi` digabung dengan `", "`. Jika `alergi` kosong atau tidak ada, tulis `-`.
  - Wajib memakai _destructuring_ untuk mengambil properti `p`, dengan nilai default untuk `alergi`.

  #keluaran[`console.log(pasien.map(ringkasPasien).join("\n"))`][```txt
  Budi Santoso (40 th), poli Umum, alergi: Penisilin, Debu
  Sari Dewi (7 th), poli Anak, alergi: -
  Joko (65 th), poli Umum, alergi: -
  Rina Ayu Lestari (30 th), poli Gigi, alergi: Udang
  ```]

+ *Jumlah pasien per poli.*
  - Fungsi: `hitungPerPoli(daftar)`.
  - Input: `daftar` array `Pasien`.
  - Output: object. Key-nya nama poli, value-nya banyak pasien di poli itu. Urutan key sesuai kemunculan pertama di data.
  - Wajib memakai object sebagai penghitung dengan _bracket notation_ (`hitung[...]`). Daftar poli tidak boleh ditulis langsung di kode.

  #keluaran[`console.log(JSON.stringify(hitungPerPoli(pasien)))`][```txt
  {"Umum":2,"Anak":1,"Gigi":1}
  ```]
  #keluaran[`console.log(JSON.stringify(hitungPerPoli([])))`][```txt
  {}
  ```]

+ *Kode temanmu: `gantiAlamat(p, alamatBaru)`.*
  - Output yang benar: object pasien *baru* dengan `kontak.alamat` diganti. Pasien asli tidak boleh berubah.
  - Masalah: temanmu sudah menyalin dengan spread `{ ...p }`, tetapi setelah dipanggil, alamat `pasien[0]` ikut berubah.
  - *(jelaskan)* Mengapa data asli ikut berubah padahal sudah disalin? Lalu perbaiki fungsinya.

  #keluaran[`console.log(pasienBaru.kontak.alamat)`][```txt
  Jl. Elang 9
  ```]
  #keluaran[`console.log(pasien[0].kontak.alamat)`][```txt
  Jl. Merpati 5
  ```]
  #keluaran[`console.log(pasienBaru === pasien[0], pasienBaru.kontak === pasien[0].kontak)`][```txt
  false false
  ```]

#level("Advanced", "0.4")

Advanced dinilai dari *pendekatannya*. Bagian (a) wajib dan menentukan nilai. Bagian (b) opsional, kerjakan jika ada waktu. Kode yang kosong tidak mengurangi nilai.

+ *Baca data pendaftaran dari teks.*
  - Fungsi: `parseDataPasien(teks)`.
  - Input: `teks` string berisi beberapa baris. Satu baris adalah satu pasien, dengan kolom dipisah `;` berurutan: `id;nama;umur;poli;alergi`. Beberapa alergi dipisah `|`. Kolom alergi boleh kosong.
    ```text
    P101;Dewi Anggraini;28;Umum;Debu|Udang
    P102;Hendra;51;Jantung;
    P103;Lina;9;Anak;Telur
    ```
  - Output: array object `{ id, nama, umur, poli, alergi }`. `umur` bertipe number. `alergi` berupa array string, dan kolom alergi kosong menjadi array kosong `[]`.

  + *(jelaskan, wajib)* Tulis pendekatanmu sebagai daftar langkah di komentar `// JAWABAN Advanced 1a`. Untuk setiap langkah, tulis bentuk datanya (string, array string, object, atau array object) dan method yang dipakai. Jelaskan juga apa yang terjadi pada baris `P102` jika kolom alergi yang kosong tidak ditangani khusus.
  + *(opsional)* Tulis kodenya.

  #keluaran[`console.log(parseDataPasien(teksPendaftaran).map((p) => JSON.stringify(p)).join("\n"))`][```txt
  {"id":"P101","nama":"Dewi Anggraini","umur":28,"poli":"Umum","alergi":["Debu","Udang"]}
  {"id":"P102","nama":"Hendra","umur":51,"poli":"Jantung","alergi":[]}
  {"id":"P103","nama":"Lina","umur":9,"poli":"Anak","alergi":["Telur"]}
  ```]

= Pengumpulan

#perhatian[
  - Kode soal: `Jawaban/soal-js4.js`. Jawaban *(jelaskan)* ditulis sebagai komentar di bawah baris `// JAWABAN ...` yang sesuai.
  - Coba Sendiri dari HO dikerjakan di fungsi `cobaSendiri()` pada file yang sama. Jalankan dengan `node Jawaban/soal-js4.js coba`.
  - Jalankan `npm run selesai -- --durasi "..." --macet "..."`, lalu minta asisten memeriksa.
]
