#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "Modul 8", judul: "DOM")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menjelaskan apa itu DOM dan mengapa `document` hanya ada di browser
- Mencari elemen dengan `querySelector` dan `querySelectorAll`
- Membuat, mengisi, dan menempelkan elemen dengan `createElement`, `textContent`, dan `append`
- Memilih `textContent` daripada `innerHTML` untuk teks
- Menangani klik dengan `addEventListener`, `event.target`, `closest`, dan `dataset`
- Membaca form dengan benar: `value` selalu string, dan `preventDefault` pada `submit`
- Menyusun halaman dengan pola state lalu render

= Dasar Teori

== DOM: Halaman sebagai Object

*Untuk apa:* JavaScript di browser bisa mengubah halaman yang sedang tampil: menambah baris, mengganti teks, menanggapi klik. Caranya lewat DOM (_Document Object Model_).

*Cara kerja:* saat browser membaca HTML, setiap tag diubah menjadi object yang tersusun seperti pohon. Object paling atas adalah `document`. Mengubah object itu langsung mengubah apa yang terlihat di layar.

#listing("HTML dan pohon DOM-nya")[```html
<body>
  <h1>Toko Roti Manis</h1>
  <ul id="daftar-produk">
    <li>Roti Tawar</li>
  </ul>
</body>
```]

```text
document
└── body
    ├── h1          "Toko Roti Manis"
    └── ul#daftar-produk
        └── li      "Roti Tawar"
```

`document` disediakan oleh *browser*, bukan oleh JavaScript. Di `node` tidak ada halaman, jadi `typeof document` di `node` adalah `"undefined"`. Karena itu soal memisahkan dua jenis kode:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*File*], [*Isi*], [*Dijalankan di*],
  [`toko.js`], [aturan toko: fungsi biasa yang menerima data dan mengembalikan data], [`node` dan browser],
  [`halaman.js`], [membaca dan mengubah halaman], [browser saja],
)

Pemisahan ini membuat aturan toko bisa diuji cepat dengan `node`, tanpa membuka browser dan mengklik satu per satu.

Analogi SQL: `toko.js` seperti query dan stored procedure, `halaman.js` seperti aplikasi yang menampilkan hasil query ke layar.

#dipakai[seluruh soal. Beginner 1–2 dan Intermediate 1–3 di `toko.js`. Beginner 3, Intermediate 4, dan Advanced di `halaman.js`.]

=== Menjalankan halaman

`halaman.js` memakai `import` (JS-6), jadi dimuat dengan `<script type="module">`. Browser menolak memuat module dari alamat `file://` (membuka file langsung dari folder) karena alasan keamanan. Console browser menampilkan error yang menyebut `blocked by CORS policy`. Karena itu halaman dibuka lewat server lokal:

```text
npm run sajikan
Server jalan. Buka http://localhost:8080/javascript/topik-08-dom/Jawaban/index.html
```

Error dari `halaman.js` tidak muncul di terminal. Buka Console browser dengan F12, tab Console. Setelah mengubah kode, muat ulang halaman (F5).

#dipakai[langkah 4 dan 5 di kotak Perhatian soal.]

== Mencari Elemen

*Untuk apa:* sebelum mengubah elemen, ambil dulu object-nya.

#listing("querySelector dan querySelectorAll")[```js
const judul = document.querySelector("h1");                    // elemen pertama yang cocok
const daftar = document.querySelector("#daftar-produk");        // berdasarkan id
const semuaLi = document.querySelectorAll("#daftar-produk li"); // semua yang cocok

console.log(document.querySelector("#tidak-ada"));   // null
console.log(semuaLi.length);                         // jumlah elemen
```]

*Cara kerja:* argumennya adalah _selector_ CSS, sama seperti di file CSS.

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Selector*], [*Cocok dengan*],
  [`"h1"`], [tag `<h1>`],
  [`"#total"`], [elemen dengan `id="total"`],
  [`".kosong"`], [elemen dengan `class="kosong"`],
  [`"#daftar-produk li"`], [`<li>` di dalam elemen ber-id `daftar-produk`],
  [`"button[data-id=\"R01\"]"`], [`<button>` dengan atribut `data-id="R01"`],
)

`querySelector` mengembalikan `null` jika tidak ada yang cocok. `querySelectorAll` mengembalikan `NodeList`. `NodeList` punya `length` dan `forEach`, tetapi bukan array, jadi tidak punya `map` atau `filter`. Ubah dulu dengan spread (`[...semuaLi]`) jika perlu.

*Kesalahan umum:* salah ketik id, atau lupa `#`. Hasilnya `null`, dan baris berikutnya gagal:

```text
TypeError: Cannot read properties of null (reading 'addEventListener')
```

Jika melihat pesan ini, periksa selector di baris `querySelector` yang bersangkutan, bukan baris `addEventListener`-nya.

#dipakai[bagian atas `halaman.js` (sudah ditulis di starter), dan Coba Sendiri.]

== Membuat dan Mengisi Elemen

*Untuk apa:* menampilkan data dari array (JS-3) sebagai baris-baris di halaman.

#listing("satu baris daftar dari satu object")[```js
const kue = [
  { id: "K1", nama: "Lapis Legit" },
  { id: "K2", nama: "Nastar" },
];
const ul = document.querySelector("#daftar-kue");

for (const k of kue) {
  const li = document.createElement("li");      // <li></li>, belum tampil
  const teks = document.createElement("span");
  teks.textContent = k.nama;                     // <span>Lapis Legit</span>
  const tombol = document.createElement("button");
  tombol.type = "button";
  tombol.textContent = "Pilih";
  tombol.dataset.id = k.id;                      // <button data-id="K1">
  li.append(teks, tombol);                       // <li><span>..</span><button>..</button></li>
  ul.append(li);                                 // baru tampil di layar
}
```]

*Cara kerja:*

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Bagian*], [*Arti*],
  [`document.createElement("li")`], [membuat elemen baru di memori. Belum terlihat.],
  [`el.textContent = "..."`], [mengisi teks. Tanda `<` dan `>` ditampilkan apa adanya.],
  [`el.dataset.id = "K1"`], [menyimpan data di atribut `data-id`. Nama `dataset.namaProduk` menjadi atribut `data-nama-produk`.],
  [`el.className = "kosong"`], [mengisi atribut `class`.],
  [`induk.append(a, b)`], [menempelkan elemen ke akhir induk. Baru setelah ini terlihat, jika induknya ada di halaman.],
  [`induk.replaceChildren()`], [membuang semua anak. Induknya tetap ada.],
)

Atribut `data-...` berguna untuk menitipkan id ke elemen. Nanti saat elemen itu diklik, id-nya dibaca kembali lewat `dataset`. Nilai di `dataset` selalu string.

#dipakai[Beginner 3 (`renderMenu`), dan Intermediate 4 (`renderKeranjang`).]

=== textContent atau innerHTML

#listing("perbedaan textContent dan innerHTML")[```js
const h = document.querySelector("h1");
h.textContent = "<i>Toko</i>";   // layar: <i>Toko</i>   (tanda kurung tampil sebagai teks)
h.innerHTML = "<i>Toko</i>";     // layar: Toko          (miring, karena dibaca sebagai HTML)
```]

`innerHTML` membaca teks sebagai HTML. Jika teks itu berasal dari luar program (nama produk dari database, komentar pembeli, isi form), orang lain bisa menyisipkan HTML atau bahkan kode JavaScript ke halamanmu. Serangan ini disebut XSS (_cross-site scripting_). `textContent` tidak punya masalah ini, karena isinya selalu dianggap teks biasa.

Aturan praktis: pakai `textContent` untuk teks. Pakai `createElement` dan `append` untuk membuat struktur. Hindari `innerHTML` untuk data.

*Kesalahan umum:* menambah baris dengan `ul.innerHTML += "<li>...</li>"`. Browser membuat ulang *semua* anak `ul` dari teks HTML-nya. Elemen lama diganti elemen baru, dan listener yang dipasang di elemen lama ikut hilang.

#dipakai[Beginner 3 (jelaskan), dan aturan nomor 6 di kotak Perhatian soal.]

== Event: Menanggapi Klik

*Untuk apa:* menjalankan kode saat pengguna melakukan sesuatu: mengklik, mengetik, mengirim form.

#listing("addEventListener")[```js
const tombol = document.querySelector("#tombol-sapa");
tombol.addEventListener("click", (event) => {
  console.log("diklik", event.target);
});
```]

*Cara kerja:* `addEventListener(jenis, fungsi)` mendaftarkan callback (JS-7) yang dipanggil browser setiap kali kejadian `jenis` terjadi. Callback menerima object `event`. `event.target` adalah elemen yang *paling dalam* yang diklik.

=== Event delegation: satu listener di induk

Klik pada sebuah tombol juga dilaporkan ke induknya, lalu induk dari induknya, sampai `document`. Ini disebut _bubbling_. Karena itu, cukup pasang *satu* listener di `<ul>`, lalu cari tombol mana yang diklik.

#listing("satu listener untuk banyak tombol")[```js
ul.addEventListener("click", (event) => {
  const tombol = event.target.closest("button");  // naik dari target sampai ketemu <button>
  if (tombol === null) return;                    // klik di luar tombol: abaikan
  console.log("dipilih", tombol.dataset.id);      // "K1" atau "K2"
});
```]

Jalannya klik pada tulisan di dalam tombol:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Langkah*], [*Kejadian*],
  [1], [pengguna mengklik teks di dalam `<button data-id="K2">`],
  [2], [`event.target` bisa elemen di dalam tombol (misalnya `<span>`), bukan tombolnya sendiri],
  [3], [klik naik (_bubbling_) sampai ke `<ul>`, dan listener di `<ul>` berjalan],
  [4], [`event.target.closest("button")` mencari ke atas dari target: menemukan tombol `K2`],
  [5], [`tombol.dataset.id` berisi `"K2"`],
)

`closest(selector)` memeriksa elemen itu sendiri, lalu induknya, terus ke atas. Jika tidak ada yang cocok, hasilnya `null`.

Keuntungan delegation: tombol yang dibuat *belakangan* (misalnya setelah daftar dibuat ulang) tetap tertangani, karena listener-nya ada di `<ul>` yang tidak pernah diganti.

#dipakai[Intermediate 4 (listener "Tambah" dan "Kurangi").]

== Form

*Untuk apa:* membaca isian pengguna.

#listing("membaca form tanpa memuat ulang halaman")[```js
const form = document.querySelector("#form-pesan");
const input = document.querySelector("#input-jumlah");

form.addEventListener("submit", (event) => {
  event.preventDefault();               // cegah browser mengirim form dan memuat ulang halaman
  const teks = input.value;             // selalu string, juga untuk <input type="number">
  console.log(typeof teks, teks);       // "string" "12"
  form.reset();                         // kosongkan semua isian
});
```]

*Cara kerja:*
- Event `"submit"` terjadi saat tombol `type="submit"` diklik *atau* Enter ditekan di kotak isian. Karena itu listener dipasang di form, bukan di tombol.
- Bawaan browser untuk `submit` adalah mengirim form ke server lalu memuat ulang halaman. Semua variabel JavaScript ikut hilang. `event.preventDefault()` membatalkan perilaku bawaan itu.
- `input.value` selalu string. Isian kosong adalah `""`.

=== Mengubah teks isian menjadi number

#table(
  columns: (auto, auto, 1fr),
  inset: 6pt,
  [*Ekspresi*], [*Hasil*], [*Catatan*],
  [`Number("12")`], [`12`], [],
  [`Number("  12 ")`], [`12`], [spasi di tepi diabaikan],
  [`Number("12rb")`], [`NaN`], [ada huruf: seluruhnya gagal],
  [`parseInt("12rb")`], [`12`], [berhenti di huruf pertama, jadi terlalu longgar untuk uang],
  [`Number("")`], [`0`], [jebakan: isian kosong dianggap nol],
  [`Number("  ")`], [`0`], [jebakan yang sama],
)

Karena isian kosong menjadi `0`, periksa dulu `teks.trim() === ""` *sebelum* mengubah dengan `Number`. Setelah itu baru periksa `Number.isNaN` (TS-5 dan JS-6) dan batas nilainya.

#dipakai[Intermediate 2 (`validasiBayar`), dan Advanced 1 (listener `submit`).]

== Pola State lalu Render

*Untuk apa:* menjaga tampilan selalu sesuai dengan data. Ini cara berpikir di balik React, Vue, dan framework sejenis.

*Cara kerja:* simpan data halaman di satu tempat, yaitu _state_ (di soal: variabel `keranjang`). Setiap kejadian *tidak* mengubah elemen secara langsung. Kejadian hanya mengganti state, lalu memanggil fungsi _render_ yang membuat ulang tampilan dari state.

#listing("alur satu klik")[```js
let pilihan = [];                       // state

function render() {
  ul.replaceChildren();                 // buang tampilan lama
  for (const id of pilihan) {           // buat ulang dari state
    const li = document.createElement("li");
    li.textContent = id;
    ul.append(li);
  }
}

tombolTambah.addEventListener("click", () => {
  pilihan = [...pilihan, "K1"];         // 1. ganti state dengan array baru
  render();                             // 2. render ulang
});

render();                               // tampilan awal
```]

```text
klik  ->  state baru  ->  render()  ->  layar sesuai state
```

Mengapa tidak mengubah elemen satu per satu, misalnya mengganti angka di sebuah `<span>`? Karena data yang sama tampil di beberapa tempat (baris keranjang, total, pesan). Jika setiap tempat diubah sendiri-sendiri, cepat atau lambat ada yang terlupa, dan layar menampilkan angka yang berbeda dari data. Dengan render ulang, hanya ada satu sumber kebenaran.

=== Fungsi yang tidak mengubah datanya

Fungsi yang mengubah state sebaiknya mengembalikan array *baru* dan tidak mengubah yang lama. Dengan begitu, keadaan lama bisa disimpan untuk fitur "Batalkan", dan fungsinya mudah diuji dengan `node`.

#listing("mengubah satu item tanpa menyentuh yang lama")[```js
const daftar = [{ id: "K1", jumlah: 1 }, { id: "K2", jumlah: 4 }];

const baru = daftar.map((x) => (x.id === "K2" ? { ...x, jumlah: x.jumlah + 1 } : x));
const tanpaK1 = daftar.filter((x) => x.id !== "K1");

console.log(JSON.stringify(daftar));   // [{"id":"K1","jumlah":1},{"id":"K2","jumlah":4}]   (tidak berubah)
console.log(JSON.stringify(baru));     // [{"id":"K1","jumlah":1},{"id":"K2","jumlah":5}]
```]

`map` membuat array baru, dan `{ ...x, jumlah: ... }` membuat object item baru. Keduanya perlu. Menyalin array dengan `[...daftar]` saja tidak cukup, karena isi array baru masih menunjuk ke object item yang sama (salinan dangkal, JS-4). Mengubah `item.jumlah++` pada salinan itu ikut mengubah aslinya.

#dipakai[Beginner 2 (`kurangiItem`), Intermediate 3 (`tambahItem` temanmu), Intermediate 4, dan Advanced 1 (jelaskan).]

== Membaca Pesan Error (tambahan JS-8)

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Pesan atau gejala*], [*Penyebab umum*],
  [`TypeError: Cannot read properties of null (reading '...')`], [`querySelector` tidak menemukan elemen. Periksa selector dan id di HTML.],
  [`ReferenceError: document is not defined`], [Kode DOM dijalankan dengan `node`. Pindahkan ke `halaman.js`.],
  [`... blocked by CORS policy` di Console], [Halaman dibuka dari `file://`. Pakai `npm run sajikan`.],
  [Halaman berkedip dan isian hilang setelah klik "Bayar"], [Lupa `event.preventDefault()` di listener `submit`.],
  [Klik tombol tidak terjadi apa-apa, tanpa error], [Listener dipasang di elemen yang kemudian diganti (misalnya lewat `innerHTML +=`), atau `closest` mencari selector yang salah.],
  [Total `NaN` atau angka aneh], [`input.value` (string) dipakai tanpa diubah menjadi number.],
)

#dipakai[seluruh soal.]

#coba-sendiri[
  Bagian 1 dikerjakan di fungsi `cobaSendiri()` pada `Jawaban/soal-js8.js` (sudah tersedia di starter). Bagian 2 diketik di Console browser saat halamanmu terbuka, setelah Beginner 3 selesai.

  ```js
  // Bagian 1: node Jawaban/soal-js8.js coba
  console.log(Number(""), Number("  12 "), Number("12rb"), parseInt("12rb"));
  console.log(typeof document);

  // Bagian 2: di Console browser
  document.querySelector("h1").textContent
  document.querySelectorAll("#daftar-produk li").length
  document.querySelector("#tidak-ada")
  typeof document.querySelector("#input-uang").value
  document.querySelector("h1").textContent = "<i>Toko</i>"
  document.querySelector("h1").innerHTML = "<i>Toko</i>"
  ```

  1. Tulis tebakan output Bagian 1 sebelum menjalankan. Tebakan mana yang salah, dan mengapa?
  2. Mengapa `typeof document` di `node` berbeda dengan di Console browser?
  3. Bagian 2: tulis hasil setiap baris. Mengapa `querySelectorAll` memberi angka itu, dan mengapa baris `#tidak-ada` tidak menimbulkan error?
  4. Apa beda tampilan judul setelah dua baris terakhir? Mana yang aman untuk menampilkan nama yang diketik pembeli, dan mengapa?

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada `soal-js8.js`.
]
