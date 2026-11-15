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
  let a = 10;
  const b = "qris";
  let c = [1, 2, 3];
  const d = c.find((x) => x > 5);
  let e: any = "x";
  console.log(a, b, c, d, e);

  // Bagian 2: hapus // di depan SATU baris di bawah, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // a = "sepuluh";
  // c.push("4");
  // console.log(d + 1);
  // console.log(e.toFixed(2));
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

// ===== DATA (JANGAN DIUBAH) =====
// key: kode obat, value: harga. Tipe hasil inferensi: Map<string, number>
const daftarHarga = new Map([
  ["OB01", 12000], // Paracetamol
  ["OB02", 35000], // Amoxicillin
  ["OB03", 8500], // Vitamin C
]);

// ===== Beginner 1 (kode lama, beri tipe tanpa mengubah isinya) =====
// subtotal(harga: number, qty: number): number
function subtotal(harga, qty) {
  return harga * qty;
}

// formatRupiah(n: number): string
function formatRupiah(n) {
  return `Rp${new Intl.NumberFormat("id-ID").format(n)}`;
}

// ===== Beginner 2 =====
// TODO: ganti string dengan literal union tiga metode bayar
type MetodeBayar = string;

// biayaAdmin(metode: MetodeBayar, total: number): number
function biayaAdmin(metode, total) {
  // TODO
  return 0;
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (output node, pesan error tsc, mengapa node tetap jalan, kapan tsc dijalankan):
//

// ===== Intermediate 1 =====
// hargaObat(kode: string): string
function hargaObat(kode) {
  // TODO
  return "";
}

// ===== Intermediate 2 =====
// TODO: tulis type AturanDiskon

// TODO: beri tipe AturanDiskon dan isi aturannya
const diskonMember = (total) => total;
const voucher10rb = (total) => total;

// terapkanDiskon(total: number, daftarAturan: AturanDiskon[]): number
function terapkanDiskon(total, daftarAturan) {
  // TODO
  return total;
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
// tambahStok(stok: number, teksInput: string): number
function tambahStok(stok: number, teksInput: string): number {
  const tambahan = JSON.parse(teksInput);
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
