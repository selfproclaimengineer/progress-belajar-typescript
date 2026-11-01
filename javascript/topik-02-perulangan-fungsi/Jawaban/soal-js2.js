// Praktikum JS Modul 2 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js2.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan soal: node Jawaban/soal-js2.js
// 4. Bandingkan output dengan Contoh Output di PDF soal.
// Tipe parameter ditulis gaya TypeScript di komentar atas setiap fungsi:
//   number[] = array berisi number; string | null = string atau null.
//   Semua number adalah bilangan bulat, kecuali ditulis desimal.

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js2.js coba
function cobaSendiri() {
  const nilai = [10, 20, 30];
  for (const i in nilai) console.log(i, typeof i); // 10 20 30
  for (const v of nilai) console.log(v, typeof v); // 10 20 30

  let jumlah = 0;
  for (let i = 0; i < nilai.length; i++) jumlah += nilai[i];
  console.log(jumlah); // 30

  const kali2 = (x) => {return  x * 2 };
  console.log(kali2(5)); // undefined

  // console.log(sapa("Dion")); // halo Dion
  // const sapa = (nama) => { return `Halo ${nama}`; } tak command biar ga muncul error 
}

// JAWABAN Coba Sendiri 1:
// baris 16 17 salah, baru ngeh maksud for nya itu beda ada for in dan of,
// in berarti value dari i nya, sementara of berarti value dari array di i.
// begitu juga tipe datanya lupa, malah kelewat. kalo NaN itu masih belum nangkep. tapi kalau dilihat sekilas,
// jumlahnya itu kan start dari i = 0 sampai io = 3, padahal array ke 3 itu kan undefined. jadi aslinya 10+20+30+undefined makanya NaN
// JAWABAN Coba Sendiri 2:
// sudah
// JAWABAN Coba Sendiri 3:
// error gabisa diakses karena fungsi const tidak boleh dipanggil sebelum deklarasinya, kalo ga reference error

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== Beginner 1 =====
// saldoAkhir(saldoAwal: number, mutasi: number[]): number
function saldoAkhir(saldoAwal, mutasi) {
  
  for(let i = 0; i < mutasi.length; i++){
    saldoAwal = saldoAwal + mutasi[i];
  }
  return saldoAwal;
}

// ===== Beginner 2 =====
// ringkasMutasi(mutasi: number[]): string
function ringkasMutasi(mutasi) {
  
  let X = 0;
  let Y = 0;
  let Z = 0;
  for(const i of mutasi){
    // console.log(i) 
    if (i<=0) X -= i;
    if (i>0)  Y += i;
    Z++;
  }
  return `Masuk: ${X}, Keluar: ${Y}, Transaksi: ${Z}`;
}

// ===== Beginner 3 (kode temanmu, perbaiki) =====
// JAWABAN Beginner 3a:
// karena kalo pake arrow pakai {} , harus ada fungsi return untuk pengembalian nilai
// JAWABAN Beginner 3b (cara perbaikan yang tidak dipakai di kode):
// const hitungPPN = (harga) => { return harga * 11 / 100 };
// hitungPPN(harga: number): number
const hitungPPN = (harga) =>  harga * 11 / 100 ;

// ===== Intermediate 1 =====
// JAWABAN Intermediate 1 (kondisi yang membuat target tidak tercapai):
// Ketika tidak ada setoran tiap bulan DAN tidak ada bunga persen tahunannya. progran akan ngeloop tanpa henti
// bulanMencapaiTarget(saldoAwal: number, setoranBulanan: number, bungaPersenTahunan: number, target: number): number
function bulanMencapaiTarget(saldoAwal, setoranBulanan, bungaPersenTahunan, target) {
  if(!Number.isInteger(saldoAwal) || !Number.isInteger(setoranBulanan) || !Number.isInteger(bungaPersenTahunan) || !Number.isInteger(target)){
    return `Ada data yang bukan bilangan bulat`;
  }
  if(setoranBulanan==0 && bungaPersenTahunan==0){
    return -1;
  }
  if(saldoAwal >=target) return 0;
  let bulan = 1;
  // let bunga = 0;
  while (saldoAwal <= target){
    saldoAwal += setoranBulanan;
    saldoAwal = Math.floor(saldoAwal + saldoAwal * bungaPersenTahunan / 100 / 12);
    if(saldoAwal >=target) return bulan
    bulan++;
  }
  return bulan;
  
}

// ===== Intermediate 2 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2a:
// karena length itu panjangnya, padahal array start dari 0, harusnya itu biaya.length-1,
// JAWABAN Intermediate 2b (mengapa for...of aman):
// let total=0;
// for (const i of biaya){
//     total+=i;
//   }
// return total;
// for of aman karena dia tahu batas arraynya.

// totalTagihan(biaya: number[]): number
function totalTagihan(biaya) {
  let total = 0;
  for (let i = 1; i < biaya.length; i++) total += biaya[i];
  return total;
}

// ===== Intermediate 3 =====
// JAWABAN Intermediate 3:
// Karena for of harus mengecek semua antrean, dan ini tidak efisien, jika antrian di depan udah ketemu, masih harus ngecek sampai ke belakang.
// posisiPertama(antrean: string[], kodePoli: string): number
function posisiPertama(antrean, kodePoli) {
  let found = false;
  for(let i =0; i<antrean.length;i++){
    if(antrean[i]==kodePoli){
      found = true;
      return i + 1;
    }
  }
  if (found==false){
    return -1;
  }
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1b:
// karena jika console log, maka data stringnya hanya bisa dilihat, sementara jika ada return valuenya, kita bisa pakai lagi di proses yang lainnya
// jadwalCicilan(pokok: number, bungaPersenPerBulan: number, cicilanPerBulan: number): string[]
function jadwalCicilan(pokok, bungaPersenPerBulan, cicilanPerBulan) {
  
  if(!Number.isInteger(pokok) ||!Number.isInteger(bungaPersenPerBulan) || !Number.isInteger(cicilanPerBulan)){
    return `ada data yang bukan angka bulat`;
  }
  let minimalCicil= bungaPersenPerBulan*pokok/100;
  if(cicilanPerBulan<=minimalCicil){
    return [`TIDAK AKAN LUNAS`];
  }
  let sisa = pokok;
  let N = 0;
  let bunga = 0;
  let bayar= cicilanPerBulan
  let detailCicilan = [];
  while(sisa>=0){
    N++;
    bunga = Math.floor(sisa * bungaPersenPerBulan / 100);
    sisa = sisa + bunga;
    // B += bunga
    if (bayar>sisa){
      bayar = sisa;
      sisa = 0;
      detailCicilan.push(`Bulan ${N}: bunga ${bunga}, bayar ${bayar}, sisa ${sisa}`);
      return detailCicilan
    }
    sisa = sisa - cicilanPerBulan;
    
    
    detailCicilan.push(`Bulan ${N}: bunga ${bunga}, bayar ${bayar}, sisa ${sisa}`);
  }
  // if(sisa<=0){
  //   S = sisa*-1;
  //   } else S = 0;
  return detailCicilan;
}

// ===== Advanced 2 =====
// JAWABAN Advanced 2c:
// untuk nasabah prioritas, tinggal isi prioritas(nominal) = 0; kalau temanku masih harus nambah if lagi yang endingnya jadi nested if yang ga rapi
const biayaFlat = (nominal) => 2500;
const biayaPersen = (nominal) => Math.ceil((nominal * 5) / 1000);

// biayaBertingkat(nominal: number): number
function biayaBertingkat(nominal) {
  if(!Number.isInteger(nominal)) return -1;
  if(nominal>1000000) return 5000;
  if(nominal>100000) return 2500;
  if(nominal>0) return 0;
  else return -1;
}

// totalBiayaAdmin(mutasi: number[], aturanBiaya: (nominal: number) => number): number
function totalBiayaAdmin(mutasi, aturanBiaya) {
  let totalAdmin = 0;
  for(const i in mutasi){
    if(mutasi[i]<0){
      totalAdmin += aturanBiaya(mutasi[i]*-1);
    }
  }
  return totalAdmin;
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
const mutasi = [500000, -150000, -20000, 1000000, -350000, 75000];

console.log("== Beginner 1 ==");
console.log(saldoAkhir(250000, mutasi));
console.log(saldoAkhir(0, []));

console.log("== Beginner 2 ==");
console.log(ringkasMutasi(mutasi));
console.log(ringkasMutasi([]));

console.log("== Beginner 3 ==");
console.log(hitungPPN(100000));
console.log(hitungPPN(25000));

console.log("== Intermediate 1 ==");
console.log(bulanMencapaiTarget(1000000, 500000, 6, 4000000));
console.log(bulanMencapaiTarget(0, 250000, 0, 1000000));
console.log(bulanMencapaiTarget(5000000, 500000, 6, 4000000));
console.log(bulanMencapaiTarget(100000, 0, 0, 200000));

console.log("== Intermediate 2 ==");
console.log(totalTagihan([150000, 75000, 300000]));
console.log(totalTagihan([]));

console.log("== Intermediate 3 ==");
const antrean = ["U", "A", "G", "A", "U"];
console.log(posisiPertama(antrean, "A"));
console.log(posisiPertama(antrean, "G"));
console.log(posisiPertama(antrean, "M"));

console.log("== Advanced 1 ==");
for (const baris of jadwalCicilan(1000000, 2, 300000)) console.log(baris);
for (const baris of jadwalCicilan(500000, 5, 25000)) console.log(baris);

console.log("== Advanced 2 ==");
console.log(totalBiayaAdmin(mutasi, biayaFlat));
console.log(totalBiayaAdmin(mutasi, biayaPersen));
console.log(totalBiayaAdmin(mutasi, biayaBertingkat));
console.log(totalBiayaAdmin([500000], biayaFlat));
