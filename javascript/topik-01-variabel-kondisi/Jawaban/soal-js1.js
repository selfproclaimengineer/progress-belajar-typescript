// Praktikum JS Modul 1 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js1.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan soal: node Jawaban/soal-js1.js
// 4. Bandingkan output dengan Contoh Output di PDF soal.

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js1.js coba
function cobaSendiri() {
  const keranjang = ["sabun"];
  keranjang.push("sikat gigi");
  console.log(keranjang.length);

  console.log("10" === 10, "10" == 10);
  console.log(null ?? "default", 0 ?? "default", "" || "default");
  console.log(Boolean("0"), Boolean(""), Boolean([]));
  console.log(Math.round(4.5), Math.floor(-4.5), Math.ceil(4.01));
  console.log(0.1 + 0.2 === 0.3);

  for (let i = 0; i < 3; i++) {}
  console.log(i);
}

// JAWABAN Coba Sendiri 1:
// 2
// false, true
// default, default, default
// false, undefined, false
// 5, -5, 5
// false
// 3
// salah di boolean dan 0. baca ho kurang teliti, untuk boolean baru tahu sekarang
// JAWABAN Coba Sendiri 2:
// karena yang tidak boleh diganti adalah mengisi ulang variabel array, bukan isi object itu sendiri
// JAWABAN Coba Sendiri 3:
// error i is not defined, karena i itu di declare di dalam loop for, jadi seharusnya dia variabel
// di dalam scope for itu, bukan di luarnya

if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== Beginner 1 =====
function kategoriTriase(skorNyeri, sadar) {
  // TODO
  if(!Number.isInteger(skorNyeri) || skorNyeri<0 || skorNyeri>10){
    return "INVALID";
  }
    else if(sadar == false){
      return "MERAH";
  } else if(skorNyeri <= 4){
      return "HIJAU";
  } else if(skorNyeri <= 7){
      return "KUNING"; 
  } else{
      return "MERAH";
  }
}

// ===== Beginner 2 (jelaskan) =====
// JAWABAN Beginner 2a:
// Antrean panjang
// Antrean panjang 
// karena pakai var tembus ke function, let scopenya block
// JAWABAN Beginner 2b:
// harusnya error pesan is not defined,
// lebih baik error yang langsung terlihat agar
// bisa langsung diperbaiki

// ===== Beginner 3 =====
function hitungDiskon(totalBelanja, isMember) {
  // TODO
  if(!isMember){
    // let diskon = 0;
    if(totalBelanja>=200000){
      let diskon = 0;
      diskon =  totalBelanja / 100 * 5;
      return Math.floor(diskon);
      
    } else return 0;
  } else if(totalBelanja>=100000){
      let diskon = 0;
      diskon = totalBelanja / 100 * 10
      return Math.floor(diskon);
      
  } else{
      let diskon = 0;
      diskon = totalBelanja / 100 * 5;
      return Math.floor(diskon);
      
    }
  
}

// ===== Intermediate 1 =====
// JAWABAN Intermediate 1b:
// karena pada kasus itu, kelas itu tipenya number
// harusnya string, maka dari itu dinormalisasi dulu
// datanya jadi 1 tipe yaitu dengan String(kelas)
// 3 itu number "3" itu baru string,

function hitungBiayaRawat(kelas, malam, punyaBPJS) {
  // TODO
  if(!Number.isInteger(malam) || malam < 1){
    return -1;
  }
  let tarif = 0;
  kelas = String(kelas);
  switch (kelas){
    case "VIP" :
      tarif = 1500000 * malam;
      break;
    case "1" :
      tarif = 800000 * malam;
      if (punyaBPJS==true){
        tarif = tarif * 25 / 100;
      }
      break;
    case "2" :
      tarif = 500000  * malam;
      if (punyaBPJS==true){
        tarif = tarif * 25 / 100;
      }
      break;
    case "3" :
      tarif = 250000 * malam;
      if (punyaBPJS==true){
        tarif = 0;
      }
      break;
    default :
      tarif = -1;
      break;
  }
  return tarif
}

// ===== Intermediate 2a (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2a:
// karena 0 itu dianggap false, jadi yang ditampilkan
// "tidak diketahui", fixnya dengan ?? agar 0 include
function infoStok(namaBarang, stok) {
  const tampil = stok ?? "tidak diketahui";
  return `${namaBarang}: ${tampil}`;
}

// ===== Intermediate 2b (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2b (termasuk dua cara perbaikan):
// ya karena kondisi awalnya sudah terpenuhi,
// harusnya dimulai dari yang terbesar dulu
// atau beri batasan kayak 18.5>=bmi<=25
function labelBMI(bmi) {
  if (bmi >= 30) {
    return "Obesitas";
  } else if (bmi >= 25) {
    return "Berat berlebih";
  } else if (bmi >= 18.5) {
    return "Normal";
  } else {
    return "Kurus";
  }
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1b:
// misal ada hacker/orang jahat nyoba
// pinnya ngaco, jadi pinBenar=false
// hacker bisa tahu kira-kira akun itu
// punya saldo jumlahnya berapa modal nyoba
// nominal saja. kalau menurutnya worth it
// ya dihajar sampai kebobolan.
// jadi lebih ke arah perlindungan data konsumen.
// kalo punyaku begitu pin salah yaudah infonya gagal pin aja


const LIMIT_HARIAN = 5000000;
const MINIMAL_TRANSFER = 10000;

function cekTransfer(saldo, nominal, pinBenar, sudahTransferHariIni) {
  // TODO
  if(!Number.isInteger(nominal) || nominal < 0){
    return "GAGAL: nominal tidak valid";
  }
  if (!pinBenar){
    return "GAGAL: PIN salah";
  }
  if(nominal < MINIMAL_TRANSFER){
    return `GAGAL: minimal transfer Rp ${MINIMAL_TRANSFER}`;
  }
  if(nominal > saldo){
    return "GAGAL: saldo tidak cukup";
  }
  if (nominal+sudahTransferHariIni > LIMIT_HARIAN){
    return `GAGAL: melebihi limit harian, sisa limit Rp ${LIMIT_HARIAN-sudahTransferHariIni}`;
  } else{
    saldo = saldo - nominal;
    return `BERHASIL: sisa saldo Rp ${saldo}`;
  }
}

// ===== Advanced 2 =====
// JAWABAN Advanced 2b (termasuk versi ternary):
// kasus A & B : tarif = isPremium = true ? tarif = 0 : tarif=tarif
// kasus C : tarif = isPremium = true ? tarif = tarif/2 : tarif=tarif
function hitungOngkir(beratGram, zona, isPremium) {
  // TODO
  if(typeof beratGram !== "number" || beratGram > 30000 || beratGram <=0){
    return -1;
  }
  let beratKg = Math.ceil(beratGram/1000);
  let tarif = 0;
  switch(zona){
    case "A" :
      tarif = beratKg * 9000;
      if(isPremium){
        tarif = 0;
      }
      break;
    case "B" :
      tarif = beratKg * 15000;
      if(isPremium){
        tarif = 0;
      }
      break;
    case "C" :
      tarif = beratKg * 25000;
      if(isPremium){
        tarif = tarif / 2;
      }
      break;
    default :
    return -1;
  }
  return tarif;
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(kategoriTriase(9, true));
console.log(kategoriTriase(6, true));
console.log(kategoriTriase(2, true));
console.log(kategoriTriase(2, false));
console.log(kategoriTriase(0, true));
console.log(kategoriTriase(11, true));
console.log(kategoriTriase("7", true));

console.log("== Beginner 3 ==");
console.log(hitungDiskon(150000, true));
console.log(hitungDiskon(80000, true));
console.log(hitungDiskon(100000, true));
console.log(hitungDiskon(55555, true));
console.log(hitungDiskon(250000, false));
console.log(hitungDiskon(199999, false));

console.log("== Intermediate 1 ==");
console.log(hitungBiayaRawat("VIP", 2, true));
console.log(hitungBiayaRawat("1", 3, true)); // harusnya udah bener ini
console.log(hitungBiayaRawat("2", 2, false));
console.log(hitungBiayaRawat("3", 5, true));
console.log(hitungBiayaRawat("4", 1, false));
console.log(hitungBiayaRawat("2", 0, true));
console.log(hitungBiayaRawat("1", 1.5, false));
console.log(hitungBiayaRawat(3, 2, false));

console.log("== Intermediate 2a ==");
console.log(infoStok("Beras 5kg", 12));
console.log(infoStok("Minyak 1L", 0));
console.log(infoStok("Gula 1kg", undefined));

console.log("== Intermediate 2b ==");
console.log(labelBMI(17));
console.log(labelBMI(22));
console.log(labelBMI(25));
console.log(labelBMI(27));
console.log(labelBMI(32));

console.log("== Advanced 1 ==");
console.log(cekTransfer(1000000, 250000, true, 0));
console.log(cekTransfer(1000000, 250000, false, 0));
console.log(cekTransfer(1000000, 5000, true, 0));
console.log(cekTransfer(100000, 250000, true, 0));
console.log(cekTransfer(9000000, 2000000, true, 4000000));
console.log(cekTransfer(9000000, 1000000, true, 4000000));
console.log(cekTransfer(1000000, -50000, true, 0));
console.log(cekTransfer(1000000, 10000.5, true, 0));

console.log("== Advanced 2 ==");
console.log(hitungOngkir(1200, "A", false));
console.log(hitungOngkir(1000, "B", false));
console.log(hitungOngkir(4500, "C", false));
console.log(hitungOngkir(4500, "C", true));
console.log(hitungOngkir(800, "B", true));
console.log(hitungOngkir(30001, "A", false));
console.log(hitungOngkir(500, "D", false));
console.log(hitungOngkir(0, "A", false));
