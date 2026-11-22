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

    get namaBesar(){
      return this.nama.toUpperCase();
    }
  }

  const k = new Kucing("Oyen");
  console.log(k.suara()); //Oyen: meong
  console.log(typeof Kucing, k instanceof Kucing); // class true

  const objek = { nama: "Belang", suara() { return `${this.nama}: meong`; } };
  console.log(objek.suara()); // Belang: meong

  class Singa extends Kucing {
    suara() {
      return super.suara().replace("meong", "auum");
    }
  }
  console.log(new Singa("Leo").suara()); // Leo: auum
  console.log(JSON.stringify(k)); // {"nama":"Oyen","meong"}

  const lepas = k.suara;
  // Coba Sendiri 3: tambahkan console.log(lepas()); di baris berikut
  // console.log(lepas());

  console.log(k.namaBesar);
}

// JAWABAN Coba Sendiri 1:
// Salah belum paham kenapa jadi function padahal itu kan class.
// terus kenapa meong tidak terstringify ke JSON?
// di contoh soal soalnya kena privat jadi aku nebak sendiri

// tipe bukan class tetapi function karena class itu function
// yang spesifik

// method memang tidak terstringify ke JSON, hanya attribut
// objek saja
// JAWABAN Coba Sendiri 2:
// Pakai class jika akan ada banyak object atau perlu extends
// dan hubungan ke kelas lain. pakai object literal jika data
// hanya sedikit.
// JAWABAN Coba Sendiri 3:
//TypeError: Cannot read properties of undefined (reading 'nama')
//Erro karena di console malah jadi function
// isi this undefined
// console.log(lepas);
// JAWABAN Coba Sendiri 4:
  //k.namaBesar is not a function
  


if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== Beginner 1, 2, 3 =====
class Rekening {
  #saldo;

  // constructor(nomor: string, pemilik: string, saldoAwal: number = 0)
  constructor(nomor, pemilik, saldoAwal = 0) {
    this.#saldo = saldoAwal;
    this.nomor = nomor;
    this.pemilik = pemilik;
  }

  // get saldo(): number
  get saldo() {
    return this.#saldo;
  }

  // info(): string
  info() {
    // ≈ 3 baris
    return `${this.nomor} a.n. ${this.pemilik}: saldo ${this.saldo}`;
  }

  // setor(nominal: number): string
  setor(nominal) {
    // ≈ 3 baris
    if (nominal <=0){
      return `GAGAL: nominal harus lebih dari 0`;
    }
    else{
      this.#saldo = this.#saldo + nominal
      return `Setor ${nominal}, saldo ${this.#saldo}`;
    }
    
  }

  // tarik(nominal: number): string
  tarik(nominal) {
    
    // ≈ 6 baris
    if (nominal <=0){
      return `GAGAL: nominal harus lebih dari 0`;
    }
    else if (nominal > this.#saldo){
      return `GAGAL: saldo tidak cukup (sisa ${this.#saldo})`;
    }
    else{
      this.#saldo = this.#saldo - nominal
      return `Tarik ${nominal}, saldo ${this.#saldo}`;
    } 
  }
}

// ===== Beginner 4 (jelaskan) =====
// JAWABAN Beginner 4 (pesan error, mengapa saldo dilindungi):
//
// const r = new Rekening("9001", "Tes", 0);
// r.saldo = 1000000;
// errornya TypeError: Cannot set property saldo of #<Rekening> which has only a getter
// get saldo itu fungsi, sementara saldo itu dianggap sebagai
// attribute oleh r.saldo, padahal r.saldo itu memanggil
// getter alias fungsi membaca tanpa perlu properti tambahan
// di dalam fungsi. 

// jika ingin mengganti itu harusnya menggunakan setter, nah kalo
// yang itu baru bisa tambah misal r.def_saldo(100000) setelah
// define
// get def_saldo(nominal){
//                        this.#saldo = nominal
//                       }

// ===== Intermediate 1 dan 2 =====
class Tabungan extends Rekening {
  // constructor(nomor: string, pemilik: string, saldoAwal: number, bungaPersen: number)
  // #saldoBaru;
  #bunga;
  constructor(nomor, pemilik, saldoAwal, bungaPersen) {
    super(nomor,pemilik,saldoAwal);
    this.bungaPersen = bungaPersen;
  }

  // tambahBunga(): string
  tambahBunga() {
    this.#bunga = Math.floor(super.saldo * this.bungaPersen/100);
    super.setor(this.#bunga)
    return `Bunga ${this.bunga}, saldo ${this.saldo}`;
  }

  get bunga(){
    return this.#bunga
  }

  // TODO Intermediate 2: info(): string
  // ≈ 3 baris
  info(){
    return `${super.info()}, bunga ${this.bungaPersen}`
  }
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
// karena rek.setor itu belum mengandung informasi dari
// daftarNominalnya, alhasil repeatnya ngga ada faedahnya
// sementara itu setor butuh properties didalamnya
// setor(nominal);
// setorBanyak(rek: Rekening, daftarNominal: number[]): number
function setorBanyak(rek, daftarNominal) {
  daftarNominal.forEach((p)=>rek.setor(p));
  // rek.setor(50000);
  // rek.setor(20000);
  // rek.setor(30000);
  return rek.saldo;
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah per method,
// mengapa tarik dan setor, mengapa urutannya):
// 
class Bank {
  constructor() {
    this.daftar = [];
  }

  // buka(rek: Rekening): string
  buka(rek) {
    // TODO (opsional)
    this.daftar.push(rek);
    return `Rekening ${rek.nomor}`;
  }

  // cari(nomor: string): Rekening | undefined
  cari(nomor) {
    // TODO (opsional)
    // ≈ 3 baris
    return this.daftar.find((p)=>{
      if (nomor !== p.nomor) return undefined;
      else return p.nomor;
    })
    
  }

  // transfer(dariNomor: string, keNomor: string, nominal: number): string
  transfer(dariNomor, keNomor, nominal) {
    // TODO (opsional)
    // ≈ 10 baris
    const saldoDari = this.cari(dariNomor);
    const saldoKe = this.cari(keNomor);
    // console.log(saldoDari)
    if(saldoDari === undefined){
      return `GAGAL: rekening ${dariNomor} tidak ditemukan`;
    }
    if(saldoKe === undefined){
      return `GAGAL: rekening ${keNomor} tidak ditemukan`;
    }
    
    // console.log(saldoDari.saldo)
    
    if(nominal > saldoDari.saldo) return `GAGAL: saldo tidak cukup (sisa ${saldoDari.saldo})`
    else{
      saldoDari.tarik(nominal);
      saldoKe.setor(nominal);
      return `Transfer ${nominal} dari ${saldoDari.nomor} ke ${saldoKe.nomor} berhasil`;
    // console.log(saldoKe)
    }
    
  }

  // totalSaldo(): number
  totalSaldo() {
    // TODO (opsional)
    let total = this.daftar.map((p)=>p.saldo).reduce((acc,b)=>acc+b,0)
    // ≈ 3 baris
    return total;
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
