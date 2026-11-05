// Praktikum JS Modul 5 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js5.js).
// 2. Lengkapi setiap bagian bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan soal: node Jawaban/soal-js5.js
// 4. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.
// Struktur class ada di UML class diagram pada PDF soal.

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js5.js coba
function cobaSendiri() {
  class Kucing {
    constructor(nama) {
      this.nama = nama;
    }
    suara() {
      return `${this.nama}: meong`;
    }
  }

  const k = new Kucing("Oyen");
  console.log(k.suara());
  console.log(typeof Kucing, k instanceof Kucing);

  const objek = { nama: "Belang", suara() { return `${this.nama}: meong`; } };
  console.log(objek.suara());

  class Singa extends Kucing {
    suara() {
      return super.suara().replace("meong", "auum");
    }
  }
  console.log(new Singa("Leo").suara());
  console.log(JSON.stringify(k));

  const lepas = k.suara;
  // Coba Sendiri 3: tambahkan console.log(lepas()); di baris berikut
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

// ===== Beginner 1, 2, 3 =====
class Rekening {
  // TODO: field privat #saldo

  // constructor(nomor: string, pemilik: string, saldoAwal: number = 0)
  constructor(nomor, pemilik, saldoAwal = 0) {
    // TODO
  }

  // get saldo(): number
  get saldo() {
    // TODO
    return 0;
  }

  // info(): string
  info() {
    // TODO
    return "";
  }

  // setor(nominal: number): string
  setor(nominal) {
    // TODO
    return "";
  }

  // tarik(nominal: number): string
  tarik(nominal) {
    // TODO
    return "";
  }
}

// ===== Beginner 4 (jelaskan) =====
// JAWABAN Beginner 4 (pesan error, mengapa saldo dilindungi):
//

// ===== Intermediate 1 dan 2 =====
class Tabungan extends Rekening {
  // constructor(nomor: string, pemilik: string, saldoAwal: number, bungaPersen: number)
  constructor(nomor, pemilik, saldoAwal, bungaPersen) {
    // TODO
  }

  // tambahBunga(): string
  tambahBunga() {
    // TODO
    return "";
  }

  // TODO Intermediate 2: info(): string
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
// setorBanyak(rek: Rekening, daftarNominal: number[]): number
function setorBanyak(rek, daftarNominal) {
  daftarNominal.forEach(rek.setor);
  return rek.saldo;
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah per method, mengapa tarik dan setor, mengapa urutannya):
//
class Bank {
  constructor() {
    this.daftar = [];
  }

  // buka(rek: Rekening): string
  buka(rek) {
    // TODO (opsional)
    return "";
  }

  // cari(nomor: string): Rekening | undefined
  cari(nomor) {
    // TODO (opsional)
    return undefined;
  }

  // transfer(dariNomor: string, keNomor: string, nominal: number): string
  transfer(dariNomor, keNomor, nominal) {
    // TODO (opsional)
    return "";
  }

  // totalSaldo(): number
  totalSaldo() {
    // TODO (opsional)
    return 0;
  }
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
const ani = new Rekening("1001", "Ani", 500000);
console.log(ani.info());
console.log(ani.saldo);

console.log("== Beginner 2 ==");
console.log(ani.setor(250000));
console.log(ani.setor(0));

console.log("== Beginner 3 ==");
console.log(ani.tarik(100000));
console.log(ani.tarik(900000));
console.log(ani.tarik(-5));

console.log("== Intermediate 1 ==");
const budi = new Tabungan("2001", "Budi", 1000000, 2);
console.log(budi.tambahBunga());
console.log(budi.tarik(20000));

console.log("== Intermediate 2 ==");
console.log(budi.info());
console.log(ani.info());

console.log("== Intermediate 3 ==");
console.log(setorBanyak(new Rekening("3001", "Cici"), [50000, 20000, 30000]));

console.log("== Advanced 1 ==");
const bank = new Bank();
console.log(bank.buka(ani));
console.log(bank.buka(budi));
console.log(bank.transfer("1001", "2001", 150000));
console.log(bank.transfer("1001", "9999", 1000));
console.log(bank.transfer("1001", "2001", 999999));
console.log(`${ani.saldo} ${budi.saldo} ${bank.totalSaldo()}`);
