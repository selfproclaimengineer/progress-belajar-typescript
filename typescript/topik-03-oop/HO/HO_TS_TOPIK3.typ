#import "/template/praktikum.typ": *
#show: praktikum.with(modul: "TypeScript Modul 3", judul: "OOP di TypeScript")

= Tujuan Praktikum

Setelah mengikuti praktikum ini, peserta mampu:
- Menulis class dengan tipe field, dan membaca error field yang belum dideklarasikan atau belum diisi
- Memakai access modifier `public`, `private`, `protected`, dan membedakan `private` dengan `#private`
- Membuat class yang memenuhi interface dengan `implements`
- Memakai abstract class untuk aturan bersama yang sebagian isinya ditentukan turunan
- Memperlakukan object dari class berbeda secara seragam lewat interface
- Memilih antara object literal, class, dan interface, lalu menjelaskan alasannya

= Dasar Teori

== Class dari JS-5, Sekarang dengan Tipe

*Untuk apa:* class di TypeScript sama dengan class JS-5 (`constructor`, method, getter, `extends`, `super`). Yang baru: setiap field harus *dideklarasikan* beserta tipenya di badan class sebelum dipakai.

#listing("class JS-5 dan versi TypeScript-nya")[```ts
// JavaScript (JS-5): field langsung dibuat di constructor
class RekeningJs {
  constructor(pemilik, saldoAwal) {
    this.pemilik = pemilik;
    this.saldo = saldoAwal;
  }
}

// TypeScript: field dideklarasikan dulu di badan class
class Rekening {
  pemilik: string;
  saldo: number;
  constructor(pemilik: string, saldoAwal: number) {
    this.pemilik = pemilik;
    this.saldo = saldoAwal;
  }
  setor(nominal: number): void {
    this.saldo += nominal;
  }
}
```]

Field bisa langsung diberi nilai awal di deklarasinya, misalnya `terpakai = 0;`. Tipenya ditebak dari nilai itu (_inference_, TS-1).

*Kesalahan umum* dan pesannya:

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Kode*], [*Pesan `tsc`*],
  [`this.umur = 3;` di constructor, tanpa deklarasi `umur`], [`TS2339: Property 'umur' does not exist on type 'A'.`],
  [`saldo: number;` dideklarasikan tetapi tidak pernah diisi di constructor], [`TS2564: Property 'saldo' has no initializer and is not definitely assigned in the constructor.`],
)

`TS2564` mencegah object lahir dengan field `undefined`. Isi field itu di constructor, atau beri nilai awal di deklarasinya.

#perhatian[
  Di banyak tutorial TypeScript ada bentuk singkat `constructor(private saldo: number) {}` yang sekaligus membuat field. Pengaturan praktikum ini (`erasableSyntaxOnly`, supaya `node` bisa menjalankan file `.ts` langsung) menolak bentuk itu: `TS1294: This syntax is not allowed when 'erasableSyntaxOnly' is enabled.` Hal yang sama berlaku untuk `enum`. Tulis field di badan class seperti listing di atas, dan pakai literal union (TS-1) sebagai pengganti `enum`.
]

#dipakai[Beginner 2, untuk mendeklarasikan field `nama` dan `saldo` di class `Dompet`, lalu mengisinya di constructor.]

== Access Modifier

*Untuk apa:* mengatur siapa yang boleh membaca dan mengubah sebuah field atau method. Saldo dompet boleh dibaca kasir, tetapi tidak boleh diubah langsung.

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Modifier*], [*Bisa diakses dari*], [*Simbol UML*],
  [`public` (bawaan)], [mana saja], [`+`],
  [`private`], [hanya di dalam class itu sendiri], [`-`],
  [`protected`], [di dalam class itu dan class turunannya], [`#`],
  [`readonly`], [boleh dibaca, tidak boleh diubah setelah constructor], [`{readonly}`],
)

#listing("private dan getter")[```ts
class Dompet {
  readonly nama: string;
  private saldo: number;
  constructor(nama: string, saldoAwal: number) {
    this.nama = nama;
    this.saldo = saldoAwal;
  }
  get sisa(): number {             // jalan resmi untuk membaca
    return this.saldo;
  }
  isiSaldo(nominal: number): void { // jalan resmi untuk mengubah
    this.saldo += nominal;
  }
}

const d = new Dompet("Saku", 50000);
console.log(d.sisa);   // 50000
d.saldo = 1000000;     // TS2341: Property 'saldo' is private and only accessible within class 'Dompet'.
d.nama = "Lain";       // TS2540: Cannot assign to 'nama' because it is a read-only property.
```]

=== `private` atau `#private`?

Keduanya menyembunyikan field, tetapi di waktu yang berbeda.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [], [*`private saldo`*], [*`#saldo` (JS-5)*],
  [Diperiksa oleh], [`tsc`, sebelum program jalan], [JavaScript, saat program jalan],
  [Jika dijalankan `node` tanpa `tsc`], [`d.saldo = 1000000` tetap mengubah saldo], [`d.#saldo` adalah syntax error, tidak bisa diakses sama sekali],
  [Ikut di `JSON.stringify`], [ya], [tidak],
  [Pesan `tsc` jika diakses dari luar], [`TS2341: Property 'saldo' is private ...`], [`TS18013: Property '#saldo' is not accessible outside class 'Rekening' because it has a private identifier.`],
)

Seperti `readonly` di TS-2, `private` adalah perjanjian yang dijaga `tsc`. Setelah keterangan tipe dibuang, field itu menjadi field biasa. `#private` benar-benar terkunci saat program jalan.

Analogi database: `private` seperti aturan "jangan ubah kolom ini" yang ditulis di dokumentasi tim dan dicek saat code review. `#private` seperti hak akses kolom yang dicabut di database, sehingga `UPDATE` langsung ditolak server.

#dipakai[
  - Beginner 2, untuk field `saldo` yang `private` dan getter `sisa`.
  - Beginner 3, untuk menjelaskan mengapa `dompetku.saldo = 1000000` ditolak `tsc` tetapi tetap mengubah saldo saat dijalankan `node`.
  - Intermediate 1, untuk field `limit` dan `terpakai` yang `protected` dan dibaca `sisaLimit` di `KartuKredit`.
]

== implements: Class yang Memenuhi Interface

*Untuk apa:* menyatakan bahwa sebuah class mengikuti bentuk sebuah interface. `tsc` lalu memeriksa bahwa class itu benar-benar punya semua field dan method dengan tipe yang cocok.

*Cara kerja:* tulis `class Nama implements NamaInterface`. Interface hanya berisi *bentuk*: nama field, tipe, dan signature method, tanpa isi. Class yang menulis isinya.

#listing("satu interface, dua class")[```ts
interface MetodeBayar {
  readonly nama: string;
  bayar(nominal: number): string;
}

class Tunai implements MetodeBayar {
  readonly nama = "Tunai";
  bayar(nominal: number): string {
    return `Tunai: ${nominal}`;
  }
}

class Transfer implements MetodeBayar {
  readonly nama = "Transfer";
  bayar(nominal: number): string {
    return `Transfer: ${nominal + 6500}`;   // biaya transfer
  }
}
```]

Analogi: interface seperti kontrak kerja yang menyebut tugas-tugasnya. Class adalah karyawan yang menandatangani kontrak itu dan mengerjakan tugasnya dengan caranya sendiri.

*Kesalahan umum* dan pesannya:

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Kode*], [*Pesan `tsc`*],
  [method `bayar` tidak ditulis], [`TS2420: Class 'Anjing' incorrectly implements interface 'Bersuara'.` disertai `Property 'suara' is missing in type 'Anjing' but required in type 'Bersuara'.`],
  [`bayar(nominal: number): number` (tipe kembalian beda)], [`TS2416: Property 'bayar' in type 'Voucher' is not assignable to the same property in base type 'MetodeBayar'.` disertai `Type '(nominal: number) => number' is not assignable to type '(nominal: number) => string'.`],
)

Satu class boleh memenuhi beberapa interface sekaligus: `class A implements X, Y`.

#dipakai[
  - Beginner 1 dan 2, untuk `Tunai implements MetodeBayar` dan `Dompet implements MetodeBayar`.
  - Intermediate 3, untuk membaca error `TS2416` pada class `Voucher` milik temanmu.
]

== Bentuk Lebih Penting daripada Nama

*Untuk apa:* memahami bahwa TypeScript memeriksa *bentuk*, bukan asal-usul. Object apa pun yang punya field dan method yang dibutuhkan dianggap memenuhi interface, walaupun tidak dibuat dari class dan tidak menulis `implements`.

#listing("object literal yang memenuhi interface")[```ts
const poin: MetodeBayar = {
  nama: "Poin Member",
  bayar: (nominal: number) => `Poin: ${nominal}`,
};

function cetak(m: MetodeBayar): string {
  return m.bayar(10000);
}

cetak(new Tunai());   // boleh: class yang implements MetodeBayar
cetak(poin);          // boleh: object biasa yang bentuknya cocok
```]

Lalu untuk apa menulis `implements`? Tanpa `implements`, kesalahan di class baru ketahuan di tempat class itu *dipakai*, misalnya saat dikirim ke `cetak`. Dengan `implements`, kesalahan ketahuan di class itu sendiri, dengan pesan yang langsung menunjuk method yang salah.

#dipakai[
  - Intermediate 2, untuk `poinMember` (object literal) yang dicampur dengan object dari class di array `MetodeBayar[]`.
  - Intermediate 3 *(jelaskan)*, tentang apa yang terjadi jika `Voucher` tidak menulis `implements`.
  - Advanced 1 *(jelaskan)*, tentang mengapa `poinMember` cukup ditulis sebagai object literal.
]

== Abstract Class

*Untuk apa:* menulis aturan bersama sekali di class induk, sementara sebagian langkahnya wajib ditulis oleh setiap turunan. Contohnya aturan limit kartu sama untuk semua kartu, tetapi biaya berbeda untuk setiap jenis kartu.

*Cara kerja:*
- `abstract class` tidak bisa dibuat langsung dengan `new`. Ia hanya untuk diturunkan.
- Method bertanda `abstract` tidak punya isi. Setiap turunan *wajib* menulisnya.
- Method biasa di abstract class boleh memanggil method abstract. Saat program jalan, yang terpanggil adalah versi milik turunannya.

#listing("abstract class dan dua turunan")[```ts
abstract class Ongkir {
  protected readonly beratKg: number;
  constructor(beratKg: number) {
    this.beratKg = beratKg;
  }
  abstract tarifPerKg(): number;          // wajib ditulis turunan
  total(): number {                       // aturan bersama
    return Math.ceil(this.beratKg) * this.tarifPerKg();
  }
}

class Reguler extends Ongkir {
  tarifPerKg(): number { return 9000; }
}
class Kilat extends Ongkir {
  tarifPerKg(): number { return 15000; }
}

console.log(new Reguler(2.3).total());   // 27000  (3 kg x 9000)
console.log(new Kilat(2.3).total());     // 45000  (3 kg x 15000)
```]

Jalannya `new Kilat(2.3).total()`:

#table(
  columns: (auto, 1fr, auto),
  inset: 6pt,
  [*Langkah*], [*Yang terjadi*], [*Nilai*],
  [1], [`total()` milik `Ongkir` dipanggil], [],
  [2], [`Math.ceil(this.beratKg)`], [`3`],
  [3], [`this.tarifPerKg()`: object-nya `Kilat`, jadi versi `Kilat` yang jalan], [`15000`],
  [4], [hasil perkalian], [`45000`],
)

*Kesalahan umum* dan pesannya:

#table(
  columns: (1fr, 1fr),
  inset: 6pt,
  [*Kode*], [*Pesan `tsc`*],
  [`new Ongkir(2)`], [`TS2511: Cannot create an instance of an abstract class.`],
  [`class Ekonomi extends Ongkir {}` tanpa `tarifPerKg`], [`TS2515: Non-abstract class 'Ekonomi' does not implement inherited abstract member tarifPerKg from class 'Ongkir'.`],
  [`new Reguler(2).beratKg` dari luar class], [`TS2445: Property 'beratKg' is protected and only accessible within class 'Ongkir' and its subclasses.`],
)

=== Abstract class atau interface?

#table(
  columns: (1fr, 1fr, 1fr),
  inset: 6pt,
  [], [*interface*], [*abstract class*],
  [Berisi kode (isi method)], [tidak, hanya bentuk], [boleh, sebagian atau semua],
  [Field dengan nilai awal], [tidak], [boleh],
  [Dipakai dengan], [`implements`, boleh banyak], [`extends`, hanya satu],
  [Ada saat program jalan], [tidak, hilang setelah tipe dibuang], [ya, menjadi class biasa],
  [Cocok untuk], [aturan bersama yang isinya berbeda total], [aturan bersama yang sebagian kodenya sama],
)

#dipakai[Intermediate 1, untuk `KartuDebit` dan `KartuKredit` yang meng-`extends` abstract class `Kartu` dan menulis method `biaya`.]

== Satu Panggilan, Banyak Perilaku

*Untuk apa:* kode kasir cukup tahu interface-nya. Ia tidak perlu tahu jenis object yang sebenarnya. Menambah cara bayar baru tidak mengubah kode kasir sama sekali. Konsep ini disebut _polymorphism_.

#listing("tanpa interface: if panjang yang terus bertambah")[```ts
function bayarLama(metode: string, nominal: number, saldo: number): string {
  if (metode === "tunai") return `Tunai: ${nominal}`;
  else if (metode === "dompet") { /* lupa mengurangi saldo */ return `Dompet: ${nominal}`; }
  else if (metode === "transfer") return `Transfer: ${nominal + 6500}`;
  // setiap metode baru menambah cabang di sini
  return "metode tidak dikenal";
}
```]

#listing("dengan interface: kasir tidak berubah")[```ts
function bayarSemua(nominal: number, daftar: MetodeBayar[]): string[] {
  return daftar.map((m) => m.bayar(nominal));   // setiap object menjalankan bayar miliknya
}

bayarSemua(10000, [new Tunai(), new Transfer(), poin]);
// ["Tunai: 10000", "Transfer: 16500", "Poin: 10000"]
```]

Untuk berhenti di hasil pertama yang berhasil, pakai `for...of` dengan `return` di dalamnya (JS-2), bukan `map` atau `forEach`. `forEach` tidak bisa dihentikan di tengah jalan.

#dipakai[
  - Intermediate 2, untuk `bayarBertahap` yang mencoba setiap `MetodeBayar` berurutan dan berhenti di yang pertama berhasil.
  - Advanced 1, untuk `rekapKasir` yang memanggil `t.metode.bayar(...)` tanpa peduli jenis cara bayarnya.
]

== Object, Class, atau Interface?

Ini salah satu pertanyaan yang disebut interviewer. Ketiganya berbeda jenis: interface adalah *bentuk*, sedangkan object literal dan class adalah cara *membuat* object.

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Pilihan*], [*Pakai jika*], [*Contoh di soal*],
  [Interface], [Perlu menjelaskan bentuk yang harus dipenuhi beberapa jenis object, atau bentuk data biasa], [`MetodeBayar`, `Transaksi`],
  [Object literal], [Hanya satu object, tanpa data yang perlu dilindungi, tanpa perlu dibuat berulang], [`poinMember`],
  [Class], [Banyak object dengan bentuk dan perilaku sama, ada data yang harus dijaga (`private`), atau perlu `extends`], [`Dompet`, `Tunai`],
  [Abstract class], [Beberapa class berbagi sebagian kode, tetapi setiap turunan wajib melengkapi bagian tertentu], [`Kartu`],
)

Pertanyaan yang membantu memilih:
+ Apakah ini hanya bentuk data atau aturan bersama? Pakai interface.
+ Apakah object seperti ini dibuat lebih dari satu kali, atau punya data yang harus dijaga? Pakai class.
+ Apakah beberapa class menulis kode yang sama? Pindahkan kode itu ke abstract class.
+ Selain itu, cukup object literal.

#catatan[
  Saat live coding sistem saldo atau checkout, desain yang mudah dijelaskan: interface untuk bentuk (`MetodeBayar`, `Item`), class untuk benda yang punya data terlindung (`Dompet` dengan `private saldo`), dan fungsi biasa untuk proses yang tidak menyimpan data (`hitungTotal`). Jika ditanya "mengapa tidak class semua?", jawab: data seperti item keranjang tidak punya perilaku dan tidak perlu dijaga, jadi interface dan object literal sudah cukup dan lebih sederhana.
]

#dipakai[Advanced 1 *(jelaskan)*, untuk menjelaskan mengapa `MetodeBayar`, `Kartu`, `Dompet`, dan `poinMember` masing-masing ditulis sebagai interface, abstract class, class, dan object literal.]

== Membaca Pesan Error tsc (tambahan TS-3)

#table(
  columns: (auto, 1fr, 1fr),
  inset: 6pt,
  [*Nomor*], [*Pesan*], [*Penyebab umum*],
  [`TS2564`], [`Property 'x' has no initializer and is not definitely assigned in the constructor.`], [Field dideklarasikan tetapi tidak diisi.],
  [`TS2341`], [`Property 'x' is private and only accessible within class 'Y'.`], [Field `private` diakses dari luar class.],
  [`TS2445`], [`Property 'x' is protected and only accessible within class 'Y' and its subclasses.`], [Field `protected` diakses dari luar.],
  [`TS2420`], [`Class 'X' incorrectly implements interface 'Y'.`], [Class kurang field atau method dari interface.],
  [`TS2416`], [`Property 'x' in type 'X' is not assignable to the same property in base type 'Y'.`], [Tipe method di class berbeda dengan interface atau induknya.],
  [`TS2511`], [`Cannot create an instance of an abstract class.`], [`new` pada abstract class.],
  [`TS2515`], [`Non-abstract class 'X' does not implement inherited abstract member ...`], [Turunan belum menulis method `abstract`.],
  [`TS1294`], [`This syntax is not allowed when 'erasableSyntaxOnly' is enabled.`], [Field di parameter constructor, atau `enum`.],
)

#dipakai[seluruh soal. Saat `tsc` menampilkan error, cari nomornya di tabel ini, TS-2, dan TS-1.]

#coba-sendiri[
  Kerjakan di fungsi `cobaSendiri()` pada file soal `Jawaban/soal-ts3.ts` (sudah tersedia di starter).

  ```ts
  interface Bersuara {
    suara(): string;
  }

  abstract class Hewan implements Bersuara {
    abstract suara(): string;
  }

  class Kucing extends Hewan {
    private nama: string;
    constructor(nama: string) {
      super();
      this.nama = nama;
    }
    suara(): string {
      return `${this.nama}: meong`;
    }
  }

  const k = new Kucing("Oyen");
  const robot: Bersuara = { suara: () => "bip" };
  console.log(k.suara(), robot.suara(), JSON.stringify(k));

  // Bagian 2: buka satu baris, jalankan npx tsc --noEmit, lalu tutup lagi.
  // console.log(k.nama);
  // const h = new Hewan();
  // class Anjing implements Bersuara {}
  ```

  1. Tulis tebakan output baris `console.log` sebelum menjalankan `node Jawaban/soal-ts3.ts coba`. Tebakan mana yang salah, dan mengapa?
  2. Bagian 2: untuk setiap baris, tulis nomor dan pesan error `tsc`-nya.
  3. `nama` bersifat `private`, tetapi ikut tercetak di `JSON.stringify(k)`. Mengapa? Apa yang berubah jika ditulis `#nama`?
  4. `robot` bukan object dari class mana pun dan tidak menulis `implements`, tetapi diterima sebagai `Bersuara`. Mengapa?

  Jawab pertanyaan di atas di bawah baris `// JAWABAN Coba Sendiri N` pada file soal.
]
