// Praktikum TS Modul 3 — file starter
// 1. Salin file ini ke Jawaban/soal-ts3.ts.
// 2. Lengkapi bagian bertanda TODO dan perbaiki kode milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Cek tipe dulu: npx tsc --noEmit   (harus tanpa error di akhir)
// 4. Lalu jalankan: node Jawaban/soal-ts3.ts
// 5. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.
// Struktur class ada di UML class diagram pada PDF soal.

// ===== Coba Sendiri (dari HO) =====
// Bagian 1: tulis tebakan output sebagai komentar di ujung baris console.log.
// Jalankan bagian ini saja: node Jawaban/soal-ts3.ts coba
function cobaSendiri() {
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

  // Bagian 2: hapus // di depan SATU baris, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // console.log(k.nama);
  // const h = new Hewan();
  // class Anjing implements Bersuara {}
}

// JAWABAN Coba Sendiri 1:
//
// JAWABAN Coba Sendiri 2:
//
// JAWABAN Coba Sendiri 3:
//
// JAWABAN Coba Sendiri 4:
//

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// Sudah jadi: format Rupiah dari TS-1.
const rupiah = (n: number): string => `Rp${new Intl.NumberFormat("id-ID").format(n)}`;

// ===== INTERFACE (JANGAN DIUBAH) =====
interface MetodeBayar {
  readonly nama: string;
  bayar(nominal: number): string;
}

interface Transaksi {
  readonly id: string;
  total: number;
  metode: MetodeBayar;
}

// ===== Beginner 1 =====
// TODO: class ini harus memenuhi MetodeBayar. Tambahkan implements dan field nama.
// ≈ 6 baris untuk seluruh class
class Tunai {
  bayar(nominal: number): string {
    // TODO
    // ≈ 3 baris
    return "";
  }
}

// ===== Beginner 2 =====
// TODO: implements MetodeBayar, field nama, field saldo yang private.
// ≈ 19 baris untuk seluruh class
class Dompet {
  constructor(nama: string, saldoAwal: number) {
    // TODO
    // ≈ 4 baris
  }
  get sisa(): number {
    // TODO
    // ≈ 3 baris
    return 0;
  }
  isiSaldo(nominal: number): void {
    // TODO
    // ≈ 3 baris
  }
  bayar(nominal: number): string {
    // TODO
    // ≈ 5 baris
    return "";
  }
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (pesan error tsc, hasil node, private vs #, mana yang dipilih untuk saldo):
//

// ===== Intermediate 1 =====
// Sudah jadi, jangan diubah.
abstract class Kartu implements MetodeBayar {
  readonly nama: string;
  protected readonly limit: number;
  protected terpakai = 0;
  constructor(nama: string, limit: number) {
    this.nama = nama;
    this.limit = limit;
  }
  abstract biaya(nominal: number): number;
  bayar(nominal: number): string {
    const biaya = this.biaya(nominal);
    const total = nominal + biaya;
    if (this.terpakai + total > this.limit) return `GAGAL: limit ${this.nama} tidak cukup`;
    this.terpakai += total;
    return `${this.nama}: dibayar ${rupiah(total)} (biaya ${rupiah(biaya)})`;
  }
}

class KartuDebit extends Kartu {
  biaya(nominal: number): number {
    // TODO
    // ≈ 3 baris
    return 0;
  }
}

class KartuKredit extends Kartu {
  biaya(nominal: number): number {
    // TODO
    // ≈ 3 baris
    return 0;
  }
  sisaLimit(): number {
    // TODO
    // ≈ 3 baris
    return 0;
  }
}

// ===== DATA (JANGAN DIUBAH) =====
// Metode bayar tanpa class: cukup object yang bentuknya sesuai MetodeBayar.
const poinMember: MetodeBayar = {
  nama: "Poin Member",
  bayar: (nominal: number) => `Poin Member: dibayar ${rupiah(nominal)}`,
};

// ===== Intermediate 2 =====
function bayarBertahap(total: number, daftar: MetodeBayar[]): string {
  // TODO
  // ≈ 7 baris
  return "";
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
class Voucher implements MetodeBayar {
  readonly nama = "Voucher";
  sisa: number;
  constructor(nilai: number) {
    this.sisa = nilai;
  }
  bayar(nominal: number): number {
    this.sisa = this.sisa - nominal;
    return this.sisa;
  }
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah, bentuk data per langkah, mana interface/class/object literal dan alasannya):
//
function rekapKasir(daftar: Transaksi[]): string {
  // TODO (opsional)
  // ≈ 15 baris
  return "";
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
const tunai = new Tunai();
console.log(tunai.bayar(25000));

console.log("== Beginner 2 ==");
const dompetku = new Dompet("DompetKu", 50000);
console.log(dompetku.bayar(30000));
console.log(dompetku.bayar(30000));
dompetku.isiSaldo(100000);
console.log(dompetku.sisa);

console.log("== Intermediate 1 ==");
const debit = new KartuDebit("Debit", 1000000);
const kredit = new KartuKredit("Kredit", 200000);
console.log(debit.bayar(100000));
console.log(kredit.bayar(150000));
console.log(kredit.bayar(50000));
console.log(kredit.sisaLimit());

console.log("== Intermediate 2 ==");
console.log(bayarBertahap(80000, [new Dompet("Saku", 50000), new KartuKredit("Kredit Cadangan", 100000), new Tunai()]));
console.log(bayarBertahap(80000, [new Dompet("Saku", 50000)]));
console.log(bayarBertahap(5000, [poinMember]));

console.log("== Intermediate 3 ==");
const voucher = new Voucher(20000);
console.log(voucher.bayar(15000));
console.log(voucher.bayar(15000));

console.log("== Advanced 1 ==");
const dompetRina = new Dompet("Dompet Rina", 60000);
const kreditBudi = new KartuKredit("Kredit Budi", 100000);
const transaksiHariIni: Transaksi[] = [
  { id: "T01", total: 45000, metode: new Tunai() },
  { id: "T02", total: 40000, metode: dompetRina },
  { id: "T03", total: 30000, metode: dompetRina },
  { id: "T04", total: 90000, metode: kreditBudi },
  { id: "T05", total: 10000, metode: kreditBudi },
  { id: "T06", total: 5000, metode: poinMember },
];
console.log(rekapKasir(transaksiHariIni));
