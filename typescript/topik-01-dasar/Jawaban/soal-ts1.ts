// Praktikum TS Modul 1 — file starter
// 1. Salin file ini ke Jawaban/soal-ts1.ts.
// 2. Lengkapi bagian bertanda TODO dan perbaiki kode milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Cek tipe dulu: npx tsc --noEmit   (harus tanpa error di akhir)
//    Saat baru disalin, tsc sudah menampilkan beberapa error TS7006. Itu disengaja:
//    error itu hilang satu per satu saat kamu memberi tipe.
// 4. Lalu jalankan: node Jawaban/soal-ts1.ts
// 5. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.

// ===== Coba Sendiri (dari HO) =====
// Bagian 1: tulis tebakan tipe a, b, c, d, e sebagai komentar di ujung barisnya,
//           lalu cek dengan mengarahkan kursor ke nama variabel di VS Code.
// Jalankan bagian ini saja: node Jawaban/soal-ts1.ts coba
function cobaSendiri() {
  let a = 10; // number
  const b = "qris"; // "qris"
  let c = [1, 2, 3]; // array of number
  const d = c.find((x) => x > 5) ? c.find((x) => x > 5) : 1; // number or undefined
  let e: any = "x"; // any (isi bebas semua tipe)
  console.log(a, b, c, d, e);

  // Bagian 2: hapus // di depan SATU baris di bawah, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // a = "sepuluh";
  // c.push("4");
  // console.log(d + 1);
  // console.log(e.toFixed(2));
}

// JAWABAN Coba Sendiri 1:
// aman semua
// JAWABAN Coba Sendiri 2:
// a : Type 'string' is not assignable to type 'number'.
// c : Argument of type 'string' is not assignable to parameter of type 'number'.
// d+1 : 'd' is possibly 'undefined'.
// e.toFixed(2) : TypeError: e.toFixed is not a function
// JAWABAN Coba Sendiri 3:
// tsc tidak memperingatkan karena e sudah dicek di awal, sehingga pada saat
// console dicek, itu sudah pure javascript.
// JAWABAN Coba Sendiri 4:
// sudah diperbaiki dengan bantuan ternary untuk menghilangkan nilai undefined
// dan menggantinya dengan 1

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== DATA (JANGAN DIUBAH) =====
// key: kode obat, value: harga. Tipe hasil inferensi: Map<string, number>
const daftarHarga = new Map([
  ["OB01", 12000], // Paracetamol
  ["OB02", 35000], // Amoxicillin
  ["OB03", 8500], // Vitamin C
]);

// ===== Beginner 1 (kode lama, beri tipe tanpa mengubah isinya) =====
// subtotal(harga: number, qty: number): number
function subtotal(harga: number, qty: number): number {
  return harga * qty;
}

// formatRupiah(n: number): string
function formatRupiah(n: number):string {
  return `Rp${new Intl.NumberFormat("id-ID").format(n)}`;
}

// ===== Beginner 2 =====

// ≈ 1 baris
type MetodeBayar = "tunai" | "debit" | "qris";

// biayaAdmin(metode: MetodeBayar, total: number): number
function biayaAdmin(metode: MetodeBayar, total: number): number {
  
  // ≈ 5 baris
  if(metode === "debit") return 2500;
  if(metode === "qris") return Math.ceil(total*0.7/100);
  if(metode === "tunai") return 0;
  else throw Error("Invalid metode bayar");
}


// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (output node, pesan error tsc, mengapa node tetap jalan, kapan tsc dijalankan):
// coba-b3.ts:1:7 - error TS2322: Type 'string' is not assignable to type 'number'.
// 1 const harga: number = "15000";
// Karena jika memakai node, maka kode typescript akan langsung
// dijalankan sebagai javascript, tidak dicompile dulu
// seperti dengan npx tsc

// tsc harus dijalankan ketika toko sudah tutup sehingga
// tidak mengganggu operasional toko
// jika harus menunggu komplain pembeli, sudah jelas
// pembeli tidak suka serta jika celahnya justru
// bisa dieksploitasi malah bisa bikin rugi owner

// ===== Intermediate 1 =====
// hargaObat(kode: string): string
function hargaObat(kode: string): string{
  // ≈ 5 baris
  if (daftarHarga.get(kode) === undefined){
    return "tidak terdaftar"
  } else return `${kode}: Rp${daftarHarga.get(kode)}`;
}

// ===== Intermediate 2 =====
type AturanDiskon = (total:number)=>number;
// ≈ 1 baris

// TODO: beri tipe AturanDiskon dan isi aturannya
// ≈ 2 baris
const diskonMember : AturanDiskon = (total) => Math.floor(total * 95/100);
  const voucher10rb : AturanDiskon = (total) => total>=100000 ? total-10000 : total;

// terapkanDiskon(total: number, daftarAturan: AturanDiskon[]): number
function terapkanDiskon(total : number, daftarAturan : number[]): number {
  // TODO
  // ≈ 3 baris

  // daftarAturan = [diskonMember,voucher10rb];

  for (const diskon of daftarAturan){
    total = diskon(total);
  }
  return total;
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
// 
// tambahStok(stok: number, teksInput: string): number
function tambahStok(stok: number, teksInput: string): number {
  const tambahan = JSON.parse(teksInput);
  if(typeof tambahan !=="number"){
    throw new Error("input stok harus angka");
  }
  //  catch(err){
  //   console.log("GAGAL: ", err.message)
  // }
  return stok + tambahan;
  
}

// Sudah jadi, jangan diubah. e bertipe unknown, jadi dicek dulu dengan instanceof (dibahas di TS-5).
function cobaStok(stok: number, teksInput: string): string {
  try {
    return `Stok baru: ${tambahStok(stok, teksInput)}`;
  } catch (e) {
    return `GAGAL: ${e instanceof Error ? e.message : String(e)}`;
  }
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (langkah, fungsi yang dipakai, tipe data per langkah, di mana tsc memaksa menangani obat tidak terdaftar):
//
function buatTagihan(keranjang: Map<string, number>, metode: MetodeBayar): string {
  // TODO (opsional)
  // ≈ 16 baris
  return "";
}

// Sudah jadi, jangan diubah.
function cetakTagihan(keranjang: Map<string, number>, metode: MetodeBayar): string {
  try {
    return buatTagihan(keranjang, metode);
  } catch (e) {
    return `GAGAL: ${e instanceof Error ? e.message : String(e)}`;
  }
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(subtotal(12000, 3));
console.log(formatRupiah(subtotal(12000, 3)));

console.log("== Beginner 2 ==");
console.log(biayaAdmin("tunai", 50000), biayaAdmin("debit", 50000), biayaAdmin("qris", 50000));
console.log(biayaAdmin("qris", 12345));

console.log("== Intermediate 1 ==");
console.log(hargaObat("OB01"));
console.log(hargaObat("OB99"));

console.log("== Intermediate 2 ==");
console.log(terapkanDiskon(120000, [diskonMember, voucher10rb]));
console.log(terapkanDiskon(120000, [voucher10rb, diskonMember]));
console.log(terapkanDiskon(50000, []));

console.log("== Intermediate 3 ==");
console.log(cobaStok(10, "5"));
console.log(cobaStok(10, '"5"'));

console.log("== Advanced 1 ==");
console.log(cetakTagihan(new Map([["OB01", 3], ["OB02", 2]]), "qris"));
console.log(cetakTagihan(new Map([["OB03", 2], ["OB99", 1]]), "tunai"));
