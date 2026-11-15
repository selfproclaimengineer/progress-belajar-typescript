#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "Modul 7", judul: "Async")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menjelaskan mengapa sebagian pekerjaan (jaringan, timer) berjalan _asinkron_
- Membaca dan menulis callback dengan error di argumen pertama
- Membuat Promise dengan `new Promise`, dan memakainya dengan `then`, `catch`, `finally`
- Menulis `async`/`await` dengan `try...catch`, dan mengenali `await` yang terlupa
- Menebak urutan output dengan memahami _event loop_
- Memanggil server dengan `fetch` dan membaca `Response`
- Memilih antara berurutan (`for...of` + `await`) dan bersamaan (`Promise.all`), dan memberi batas waktu dengan `Promise.race`

= Dasar Teori

== Sinkron dan Asinkron

*Untuk apa:* sampai JS-6, setiap baris selesai sebelum baris berikutnya dimulai. Ini disebut _sinkron_. Sebagian pekerjaan butuh waktu lama dan hasilnya datang dari luar program: meminta data ke server, membaca file, menunggu timer. Jika program diam menunggu, aplikasi terasa macet. JavaScript memilih cara lain: pekerjaan itu *dimulai*, program lanjut ke baris berikutnya, dan hasilnya diurus nanti saat sudah datang. Ini disebut _asinkron_.

#listing("setTimeout tidak membuat program menunggu")[```js
console.log("pesan kopi");
setTimeout(() => console.log("kopi jadi"), 1000);   // jalankan fungsi ini 1000 ms lagi
console.log("duduk");
// pesan kopi
// duduk
// kopi jadi      (1 detik kemudian)
```]

*Cara kerja:* `setTimeout(fungsi, ms)` hanya *mendaftarkan* fungsi untuk dijalankan nanti, lalu langsung selesai. Fungsi yang didaftarkan untuk dipanggil nanti disebut _callback_. Kamu sudah memakai callback di JS-3 (`map`, `filter`), bedanya callback di sana dipanggil saat itu juga.

Analogi kafe: kasir menerima pesanan, memberi nomor antrean, lalu melayani pembeli berikutnya. Kasir tidak berdiri menunggu kopi selesai dibuat. Analogi SQL: query ke server database juga butuh waktu. Aplikasi mengirim query, lalu menunggu hasilnya datang lewat jaringan.

#dipakai[seluruh soal. Setiap permintaan ke server palsu di `api.js` butuh waktu sekitar 50 ms.]

== Callback dengan Error di Argumen Pertama

*Untuk apa:* cara lama (sebelum Promise) memberi tahu hasil pekerjaan asinkron. Banyak pustaka lama masih memakainya.

#listing("callback gaya lama")[```js
const daftarMenu = { "nasi goreng": 300, "es teh": 100 };   // nama menu: lama memasak (ms)

function masakCallback(menu, callback) {
  setTimeout(() => {
    if (!(menu in daftarMenu)) callback(new Error(`menu ${menu} habis`));
    else callback(null, `${menu} siap`);
  }, daftarMenu[menu] ?? 50);
}

masakCallback("es teh", (err, hasil) => {
  if (err) console.log("gagal:", err.message);
  else console.log(hasil);
});
masakCallback("soto", (err, hasil) => {
  if (err) console.log("gagal:", err.message);
  else console.log(hasil);
});
// gagal: menu soto habis     (50 ms, lebih dulu)
// es teh siap                (100 ms)
```]

*Cara kerja:* aturannya, argumen pertama callback adalah error. Jika berhasil, argumen pertama `null` dan hasilnya ada di argumen kedua. Perhatikan urutan output: soto dipesan *setelah* es teh, tetapi selesai lebih dulu karena waktunya lebih pendek. Urutan hasil asinkron mengikuti kapan pekerjaannya selesai, bukan urutan baris kode.

*Masalahnya:* jika pekerjaan kedua bergantung pada hasil pekerjaan pertama, callback harus ditulis di dalam callback. Tiga atau empat langkah membuat kode menjorok jauh ke kanan, dan pemeriksaan `err` harus ditulis di setiap tingkat. Pola ini dijuluki _callback hell_. Promise dibuat untuk mengatasinya.

#dipakai[Beginner 2, untuk membaca `cekSaldoCallback` di `api.js`.]

== Promise

*Untuk apa:* Promise adalah object yang mewakili hasil yang *belum* ada. Seperti nomor antrean di kafe: belum berisi kopi, tetapi suatu saat akan berisi kopi, atau berisi kabar bahwa menunya habis.

Promise selalu berada di salah satu dari tiga keadaan:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Keadaan*], [*Arti*], [*Dicetak `console.log`*],
  [_pending_], [pekerjaan belum selesai], [`Promise { <pending> }`],
  [_fulfilled_], [berhasil, berisi nilai], [`Promise { 'es teh siap' }`],
  [_rejected_], [gagal, berisi error], [`Promise { <rejected> Error: ... }`],
)

Keadaan hanya berubah sekali: dari _pending_ menjadi _fulfilled_ atau _rejected_, lalu tetap.

=== Membuat Promise dengan new Promise

#listing("membungkus setTimeout menjadi Promise")[```js
function masak(menu) {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (!(menu in daftarMenu)) reject(new Error(`menu ${menu} habis`));
      else resolve(`${menu} siap`);
    }, daftarMenu[menu] ?? 50);
  });
}

const p = masak("es teh");
console.log(p);          // Promise { <pending> }
// ... 150 ms kemudian:
console.log(p);          // Promise { 'es teh siap' }
```]

*Cara kerja:* `new Promise` menerima satu fungsi dengan dua parameter, `resolve` dan `reject`. Fungsi itu langsung dijalankan. Di dalamnya, mulai pekerjaan asinkron, lalu panggil `resolve(nilai)` jika berhasil atau `reject(error)` jika gagal. Pola yang sama dipakai untuk membungkus fungsi callback gaya lama: panggil fungsi lama di dalam `new Promise`, lalu di callback-nya, ubah `err` menjadi `reject` dan hasil menjadi `resolve`.

*Kesalahan umum:* lupa `return` di depan `new Promise`. Fungsi mengembalikan `undefined`, dan pemanggilnya tidak bisa menunggu apa pun.

=== then, catch, finally

#listing("rangkaian then")[```js
masak("nasi goreng")
  .then((m) => {
    console.log(m);
    return masak("es teh");        // Promise dikembalikan: then berikutnya menunggunya
  })
  .then((m) => console.log(m))
  .catch((e) => console.log("gagal:", e.message))
  .finally(() => console.log("dapur tutup"));
// nasi goreng siap
// es teh siap
// dapur tutup
```]

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Method*], [*Dijalankan saat*],
  [`.then(fn)`], [Promise sebelumnya berhasil. `fn` menerima nilainya. Nilai yang di-`return` `fn` menjadi isi Promise berikutnya.],
  [`.catch(fn)`], [ada yang gagal di mana pun sebelumnya. `then` di antaranya dilewati. `fn` menerima error-nya.],
  [`.finally(fn)`], [selalu, berhasil atau gagal. Cocok untuk membereskan sesuatu.],
)

`then`, `catch`, dan `finally` masing-masing mengembalikan Promise *baru*. Karena itu bisa dirangkai. Rangkaian ini datar, tidak menjorok seperti callback hell, dan cukup satu `catch` untuk semua langkah.

#dipakai[Beginner 1 (`tunda`), Beginner 2 (`cekSaldo`), dan `.catch` di baris `PEMANGGILAN`.]

== async dan await

*Untuk apa:* menulis kode asinkron yang *terlihat* seperti kode sinkron biasa. Ini cara yang paling banyak dipakai sekarang.

#listing("async, await, dan try...catch")[```js
async function pesan() {
  try {
    const a = await masak("nasi goreng");   // tunggu sampai berhasil, ambil nilainya
    const b = await masak("soto");          // gagal: langsung lompat ke catch
    return [a, b];
  } catch (e) {
    return `gagal: ${e.message}`;
  } finally {
    console.log("dapur tutup");
  }
}

console.log(await pesan());
// dapur tutup
// gagal: menu soto habis
```]

*Cara kerja:*
- `await promise` menghentikan *fungsi ini saja* sampai Promise selesai. Jika berhasil, hasilnya nilai di dalam Promise. Jika gagal, `await` melempar error-nya, sehingga bisa ditangkap `try...catch` biasa (JS-6).
- Selama fungsi itu berhenti, program lain tetap berjalan. Yang berhenti hanya fungsi yang sedang `await`.
- Fungsi `async` *selalu* mengembalikan Promise. `return nilai` di dalamnya menjadi Promise yang berisi `nilai`. `throw` di dalamnya menjadi Promise yang gagal.
- `finally` berjalan sebelum fungsi benar-benar selesai, jadi `dapur tutup` tercetak lebih dulu.

#listing("fungsi async selalu mengembalikan Promise")[```js
async function lima() {
  return 5;
}
console.log(lima());          // Promise { 5 }
console.log(await lima());    // 5
```]

`await` hanya boleh ditulis di dalam fungsi `async`, atau di tingkat paling luar sebuah *modul* (file yang memakai `import`/`export`, atau proyek dengan `"type": "module"` di `package.json`, seperti repo ini). Di dalam fungsi biasa, `node` menolak sebelum program jalan:

```text
function f() { await masak("es teh"); }
SyntaxError: Unexpected reserved word
```

*Kesalahan umum:*
- Lupa `await`. Hasilnya Promise, bukan nilainya. Jika Promise itu digabung dengan teks atau dijumlahkan, hasilnya `[object Promise]`.
- Lupa `async` pada fungsi yang memakai `await`: `SyntaxError` di atas.
- Memanggil fungsi `async` yang bisa gagal tanpa `await` di dalam `try`. Error-nya tidak tertangkap `catch`, karena `try` sudah selesai sebelum Promise gagal.

Perbandingan dua gaya:

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*then/catch*], [*async/await*],
  [`masak(m).then((x) => ...)`], [`const x = await masak(m);`],
  [`.catch((e) => ...)`], [`try { ... } catch (e) { ... }`],
  [`.finally(() => ...)`], [`finally { ... }`],
)

Keduanya bekerja dengan Promise yang sama, dan boleh dicampur. Contohnya `await cekSaldo("9999").catch((e) => e.message)` di soal: `catch` mengubah Promise gagal menjadi Promise berhasil berisi pesan, lalu `await` mengambil pesan itu.

#dipakai[Beginner 3 (`await` yang terlupa), Intermediate 1 (`ambilRekening` dan `infoRekening`), dan seluruh `PEMANGGILAN`.]

== Event Loop: Siapa Jalan Duluan

*Untuk apa:* menebak urutan output kode asinkron, dan memahami mengapa callback tidak pernah memotong kode yang sedang berjalan.

*Cara kerja:* JavaScript hanya menjalankan *satu* hal pada satu waktu. Ada tiga tempat yang perlu diingat:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Tempat*], [*Isi*],
  [kode yang sedang berjalan], [baris demi baris, sampai selesai. Tidak bisa disela.],
  [antrean _microtask_], [lanjutan Promise: callback `then`/`catch`/`finally`, dan lanjutan setelah `await`.],
  [antrean _task_], [callback `setTimeout` yang waktunya sudah tiba, dan kejadian dari luar.],
)

Aturannya: jalankan kode sampai selesai, lalu habiskan *semua* microtask, lalu ambil *satu* task, lalu habiskan microtask lagi, dan seterusnya. Putaran ini disebut _event loop_.

#listing("menebak urutan")[```js
console.log("1");
setTimeout(() => console.log("2"), 0);
Promise.resolve().then(() => console.log("3"));
console.log("4");
// 1  4  3  2
```]

#table(
  columns: (auto, 1fr, auto, auto),
  inset: 6pt,
  [*Langkah*], [*Kejadian*], [*Microtask*], [*Task*],
  [1], [cetak `1`], [], [],
  [2], [`setTimeout` mendaftarkan callback `2`], [], [`2`],
  [3], [`then` mendaftarkan callback `3`], [`3`], [`2`],
  [4], [cetak `4`. Kode selesai.], [`3`], [`2`],
  [5], [habiskan microtask: cetak `3`], [], [`2`],
  [6], [ambil satu task: cetak `2`], [], [],
)

`setTimeout(fn, 0)` artinya "paling cepat 0 ms lagi, dan *setelah* kode yang sedang berjalan serta semua microtask selesai". Bukan "sekarang juga".

#dipakai[Coba Sendiri. Pemahaman ini juga menjelaskan Intermediate 3: mengapa `return` di fungsi temanmu berjalan sebelum `push`.]

== fetch dan Response

*Untuk apa:* meminta data ke server lewat HTTP. `fetch` tersedia di browser dan di Node 18 ke atas tanpa perlu diinstal.

#listing("fetch ke server sungguhan (bentuknya saja)")[```js
const res = await fetch("https://api.contoh.com/produk/7");
if (!res.ok) throw new Error(`${res.status}`);
const produk = await res.json();

const res2 = await fetch("https://api.contoh.com/pesanan", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ produk: 7, qty: 2 }),
});
```]

`fetchBank` di soal dipakai persis sama. Bedanya, alamatnya diawali `/` dan servernya palsu:

#listing("membaca Response")[```js
const res = await fetchBank("/rekening/1009");
console.log(res.ok, res.status);       // false 404

const isiJanji = res.json();           // lupa await
console.log(isiJanji);                 // Promise { <pending> }
console.log(await isiJanji);           // { pesan: 'rekening tidak ditemukan' }

await res.json();                      // dibaca kedua kali
// TypeError: Body is unusable: Body has already been read

const res2 = await fetchBank("/rekening/1001");
console.log(res2.ok, res2.status, await res2.json());
// true 200 { nomor: '1001', nama: 'Ani', saldo: 500000 }
```]

*Cara kerja:* ada *dua* kali menunggu. Pertama `fetch` sampai kepala balasan (status) datang, hasilnya object `Response`. Kedua `res.json()` sampai seluruh isi balasan selesai dibaca dan diubah dari teks JSON (JS-4) menjadi object.

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Bagian `Response`*], [*Arti*],
  [`res.status`], [kode status HTTP: `200` berhasil, `400` permintaan salah, `404` tidak ditemukan, `500` server error],
  [`res.ok`], [`true` jika status 200 sampai 299],
  [`res.json()`], [Promise berisi isi balasan sebagai object. Hanya boleh dibaca sekali.],
)

*Kesalahan umum:* mengira `fetch` gagal (_reject_) saat status `404` atau `400`. `fetch` hanya gagal jika server sama sekali tidak bisa dihubungi. Balasan `404` tetap balasan yang sah, jadi `res.ok` harus diperiksa sendiri, lalu `throw` jika perlu.

Analogi SQL: status seperti kode hasil query (berhasil, atau error constraint), dan isi balasan seperti baris-baris hasilnya.

#dipakai[Intermediate 1 (`ambilRekening`), dan Advanced 1 (`POST /transfer`).]

== Berurutan atau Bersamaan

*Untuk apa:* beberapa permintaan yang *tidak saling bergantung* sebaiknya dikirim bersamaan supaya cepat. Permintaan yang bergantung pada hasil sebelumnya harus berurutan.

#listing("berurutan vs Promise.all")[```js
for (const m of ["nasi goreng", "es teh"]) await masak(m);
// berurutan: 300 + 100 = sekitar 400 ms

const hasil = await Promise.all([masak("nasi goreng"), masak("es teh")]);
console.log(hasil);    // [ 'nasi goreng siap', 'es teh siap' ]
// bersamaan: sekitar 300 ms, yaitu waktu yang paling lama

console.log(await Promise.all(["nasi goreng", "es teh"].map(masak)));
// [ 'nasi goreng siap', 'es teh siap' ]    (pola map lalu Promise.all)
```]

*Cara kerja:* `masak(...)` langsung *memulai* pekerjaan saat dipanggil. Di `for...of`, pekerjaan kedua baru dimulai setelah `await` pertama selesai. Dengan `map`, semua pekerjaan dimulai hampir bersamaan, lalu `Promise.all` menunggu semuanya.

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Fungsi*], [*Hasil*],
  [`Promise.all(daftar)`], [array nilai, *urutannya sama dengan `daftar`*, bukan urutan selesai. Gagal begitu ada *satu* yang gagal, dengan error dari yang gagal itu.],
  [`Promise.allSettled(daftar)`], [tidak pernah gagal. Array berisi `{ status: "fulfilled", value }` atau `{ status: "rejected", reason }` untuk setiap Promise.],
  [`Promise.race(daftar)`], [ikut Promise yang *pertama selesai*, berhasil atau gagal. Sisanya diabaikan, tetapi tetap berjalan sampai selesai.],
)

```js
console.log(await Promise.all([masak("nasi goreng"), masak("soto")]).catch((e) => e.message));
// menu soto habis
console.log(await Promise.race([masak("nasi goreng"), masak("es teh")]));
// es teh siap     (100 ms, lebih cepat dari nasi goreng)
```

=== Pola batas waktu dengan Promise.race

Balap pekerjaan dengan Promise yang *gagal* setelah sekian milidetik. Jika pekerjaan selesai lebih dulu, `race` ikut hasilnya. Jika timer lebih dulu, `race` gagal.

```js
const habis = new Promise((_, reject) => setTimeout(() => reject(new Error("terlalu lama")), 150));
console.log(await Promise.race([masak("nasi goreng"), habis]).catch((e) => e.message));
// terlalu lama     (nasi goreng butuh 300 ms)
```

`_` adalah nama parameter yang sengaja tidak dipakai. Promise ini tidak pernah memanggil `resolve`.

Kapan memakai yang mana:

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Situasi*], [*Pakai*],
  [langkah berikutnya butuh hasil langkah sebelumnya, atau urutan mengubah data (saldo)], [`for...of` dengan `await`],
  [beberapa permintaan bebas, semuanya wajib berhasil], [`map` lalu `Promise.all`],
  [beberapa permintaan bebas, sebagian boleh gagal], [`Promise.allSettled`],
  [membatasi waktu tunggu], [`Promise.race` dengan timer],
)

Analogi SQL: dua `SELECT` dari tabel berbeda boleh dijalankan bersamaan. Dua `UPDATE` saldo di rekening yang sama harus berurutan, seperti di dalam satu transaksi.

#dipakai[Intermediate 2 (`totalSaldo`), Intermediate 3 (urutan nama), dan Advanced 1 (antrean berurutan dan `denganBatasWaktu`).]

== Jebakan forEach dengan async

*Untuk apa:* mengenali bug yang sangat sering muncul di kode asinkron.

#listing("forEach tidak menunggu")[```js
async function semua(daftar) {
  const hasil = [];
  daftar.forEach(async (m) => hasil.push(await masak(m)));
  return hasil;
}
console.log(await semua(["nasi goreng", "es teh"]));    // []
```]

*Cara kerja:* `forEach` memanggil callback untuk setiap elemen dan *tidak peduli* nilai kembaliannya. Callback `async` mengembalikan Promise, dan Promise itu dibuang. Jadi `forEach` selesai seketika, `return hasil` berjalan saat array masih kosong, dan `push` baru terjadi ratusan milidetik kemudian, saat tidak ada yang melihat lagi.

Perbaikannya, pilih sesuai kebutuhan:

```js
for (const m of daftar) hasil.push(await masak(m));   // berurutan
const hasil = await Promise.all(daftar.map(masak));   // bersamaan, urutan tetap
```

Ini sambungan dari JS-3 (`for` vs `forEach`): `forEach` tidak bisa dihentikan dengan `break`, dan juga tidak bisa ditunggu.

#dipakai[Intermediate 3 (kode temanmu).]

== Membaca Pesan Error (tambahan JS-7)

#table(
  columns: (auto, 1fr),
  inset: 6pt,
  [*Pesan atau gejala*], [*Penyebab umum*],
  [`[object Promise]` atau `Promise { <pending> }` di output], [Lupa `await`.],
  [`SyntaxError: Unexpected reserved word`], [`await` di dalam fungsi yang bukan `async`.],
  [`TypeError: Body is unusable: Body has already been read`], [`res.json()` dipanggil dua kali pada `Response` yang sama.],
  [Program berhenti dengan error dan baris `Node.js v...`, padahal ada `try...catch`], [Promise gagal yang tidak di-`await` atau tidak diberi `.catch`. Error-nya tidak tertangkap (_unhandled rejection_).],
  [Array atau teks kosong dari fungsi yang memakai `forEach(async ...)`], [`forEach` tidak menunggu callback `async`.],
)

#dipakai[seluruh soal.]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-js7.js` (sudah tersedia di starter).

  ```js
  console.log("A");
  setTimeout(() => console.log("B"), 0);
  Promise.resolve().then(() => console.log("C"));
  console.log("D");
  await new Promise((resolve) => setTimeout(resolve, 10));

  const angka = await Promise.all([1, Promise.resolve(2), new Promise((resolve) => setTimeout(() => resolve(3), 5))]);
  console.log(angka);

  try {
    await Promise.reject(new Error("gagal"));
  } catch (e) {
    console.log(e.message);
  } finally {
    console.log("selesai");
  }
  ```

  1. Tulis tebakan output setiap baris `console.log` sebelum menjalankan `node Jawaban/soal-js7.js coba`. Tebakan mana yang salah, dan mengapa?
  2. Mengapa `C` tercetak sebelum `B`, padahal `setTimeout` ditulis lebih dulu dan waktunya 0 ms?
  3. `Promise.all` di atas menerima `1`, yang bukan Promise. Apa yang terjadi padanya? Lalu hapus `await` di depan `Promise.reject` dan jalankan lagi. Apa yang tercetak, apakah `catch` menangkap error-nya, dan mengapa? Kembalikan `await` setelah selesai.
  4. Ganti `Promise.all` menjadi `Promise.race` dengan isi yang sama. Apa yang tercetak, dan mengapa?

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
