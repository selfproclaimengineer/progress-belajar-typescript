// Praktikum JS Modul 3 — file starter
// 1. Salin file ini ke folder Jawaban/ (contoh: Jawaban/soal-js3.js).
// 2. Lengkapi setiap fungsi bertanda TODO dan perbaiki fungsi milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Jalankan soal: node Jawaban/soal-js3.js
// 4. Bandingkan output dengan Contoh Output di PDF soal.
// Tipe parameter ditulis gaya TypeScript di komentar atas setiap fungsi:
//   number[] = array berisi number; string | null = string atau null.
//   Semua number adalah bilangan bulat, kecuali ditulis desimal.

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan sebagai komentar di ujung setiap baris console.log SEBELUM menjalankan.
// Jalankan bagian ini saja: node Jawaban/soal-js3.js coba
function cobaSendiri() {
  const pasien = [
    { nama: "Budi", umur: 40, poli: "Umum" },
    { nama: "Sari", umur: 7, poli: "Anak" },
    { nama: "Joko", umur: 65, poli: "Umum" },
  ];

  const angka = [5, 25, 100, 1];
  console.log(angka.sort()); // 1,5,25,100
  console.log(angka); //[5,25,100,1]
  console.log(pasien.map((p) => p.umur > 18)); // [40, 65]
  console.log(pasien.filter((p) => p.umur > 18).length); // 2
  console.log(pasien.find((p) => p.umur > 18).nama); // Budi
  console.log([].reduce((a, b) => a + b, 0)); // 0
  const hasil = pasien.forEach((p) => p.nama);
  console.log(hasil); // undefined

  const pasienUmum = pasien
  .filter((p)=> p.poli=="Umum")
  .map((p) => p.nama)
  .join(", ");
  console.log(pasienUmum);
}

// JAWABAN Coba Sendiri 1:
// Salah baris 2 dan 3, baris 2 baru lihat lagi kalo
// gaada (a,b) nya itu sort urut string
// baris 3 baru ngeh maksud keluarannya bakal jadi true/false
// karena perbandingan, malah kujadikan filter
// JAWABAN Coba Sendiri 2:
// map itu berarti buat copy array kemudian keluarnya callback true/false 
// jadi kayak contoh tadi
// ya langsung dicompare jadi true false true
// kalau filter itu baru mengumpulkan data sesuai kriteria.
// JAWABAN Coba Sendiri 3:
// no initial value error. harusnya ada nilai awal.
// JAWABAN Coba Sendiri 4:


if (process.argv[2] === "coba") {
  cobaSendiri();
  process.exit(0);
}

// ===== DATA (JANGAN DIUBAH) =====
// Produk = { id: string, nama: string, kategori: string, harga: number,
//            stok: number, rating: number desimal, terjual: number }
// Item   = { idProduk: string, qty: number }
const produk = [
  { id: "P01", nama: "Beras Premium 5kg", kategori: "Sembako", harga: 78000, stok: 25, rating: 4.7, terjual: 320 },
  { id: "P02", nama: "Minyak Goreng 2L", kategori: "Sembako", harga: 36000, stok: 0, rating: 4.5, terjual: 410 },
  { id: "P03", nama: "Kopi Bubuk 200g", kategori: "Minuman", harga: 24500, stok: 40, rating: 4.8, terjual: 150 },
  { id: "P04", nama: "Teh Celup 25s", kategori: "Minuman", harga: 9800, stok: 60, rating: 4.2, terjual: 95 },
  { id: "P05", nama: "Sabun Mandi Cair", kategori: "Perawatan", harga: 21000, stok: 12, rating: 4.4, terjual: 210 },
  { id: "P06", nama: "Pasta Gigi 190g", kategori: "Perawatan", harga: 15500, stok: 8, rating: 4.6, terjual: 180 },
  { id: "P07", nama: "Mi Instan Goreng", kategori: "Sembako", harga: 3100, stok: 200, rating: 4.9, terjual: 1500 },
  { id: "P08", nama: "Susu UHT 1L", kategori: "Minuman", harga: 18900, stok: 0, rating: 4.3, terjual: 260 },
];

const keranjang = [
  { idProduk: "P01", qty: 1 },
  { idProduk: "P07", qty: 10 },
  { idProduk: "P03", qty: 2 },
  { idProduk: "P06", qty: 1 },
];

// ===== Beginner 1 =====
// namaProdukTersedia(produk: Produk[]): string[]
function namaProdukTersedia(produk) {
  const tersedia = produk
  .filter((p)=>p.stok>0)
  .map((p)=>p.nama)
  // .join(", ");
  return tersedia;
}

// ===== Beginner 2 =====
// totalStok(produk: Produk[]): number
function totalStok(produk) {
  return produk
  .map((p)=> p.stok)
  .reduce((acc,p)=>acc + p, 0)
}

// ===== Beginner 3 =====
// adaKategori(produk: Produk[], kategori: string): boolean
function adaKategori(produk, kategori) {
  let adaTidak = produk.map((p)=> p.kategori == kategori)
  
  // console.log(adaTidak);
  for (let i =0 ; i< adaTidak.length ; i++){
    // console.log(i);
    if (adaTidak[i]==true){
      return true;
    }
  } return false;
}

// semuaRatingDiAtas(produk: Produk[], batas: number desimal): boolean
function semuaRatingDiAtas(produk, batas) {

  let rateCheck = produk.map((p)=>p.rating>=batas);
  let i = 0;
  for (let i =0 ; i< rateCheck.length ; i++){
    if (rateCheck[i] == false) return false
  }
  return true
}

// ===== Beginner 4 (jelaskan) =====
// JAWABAN Beginner 4 (pesan error, penyebab, versi benar):
// TypeError: kategoriAktif.contains is not a function
// penyebabnya karena ada .contains yang tidak ada di javascript
// versi benarnya di bawah ini
const kategoriAktif = ["Sembako", "Minuman"];
console.log(kategoriAktif.filter((p)=>p.kategori=="Minuman"));

// ===== Intermediate 1 =====
// rincianCheckout(keranjang: Item[], produk: Produk[]): string[]
function rincianCheckout(keranjang, produk) {
  // TODO: kembalikan array of string
  
  // let harga1 = produk.map((p)=>p.harga).find((p)=> p.id===keranjang[0].idProduk);
  // let hsl = [];
  // for (let i in keranjang){
  //   let barang1 = produk.find((p)=> p.id===keranjang[i].idProduk);
  //   hsl.push(`${barang1.nama} x${keranjang[i].qty} = ${barang1.harga*keranjang[i].qty}`)
  // }
  // return hsl
  
  const rincian = keranjang.map((k)=>{
    const data = produk.find((p)=>p.id===k.idProduk);
    return `${data.nama} x${k.qty} = ${data.harga*k.qty}`
  })
  return rincian;
}

// totalCheckout(keranjang: Item[], produk: Produk[]): number
function totalCheckout(keranjang, produk) {
  
  const rincian = keranjang.map((k)=>{
    const data = produk.find((p)=>p.id===k.idProduk);
    return data.harga*k.qty
  })
  return rincian.reduce((acc,r)=> acc + r, 0);
  
}

// ===== Intermediate 2 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 2:
// Karena gaada inisialisasinya di reduce, harusnya ada , 0
// totalTerjual(produk: Produk[]): number
function totalTerjual(produk) {
  return produk.reduce((acc, p) => acc + p.terjual, 0);
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
// karena sort mengubah data asli, jadi seharusnya data dicopy dulu dengan .map
// hal ini berbahaya karena jika data asli berubah, fungsi yang menggunakan urutan
// data asli bisa teracak dan kacau
// urutHargaTermurah(produk: Produk[]): Produk[]  (produk asli tidak boleh berubah)
function urutHargaTermurah(produk) {
  return produk.map((p)=>p).sort((a, b) => a.harga - b.harga);
}

// ===== Intermediate 4 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 4a:
// Karena for each tidak mengembalikan nilai, dia mengulangi semua method di semua data
// JAWABAN Intermediate 4b:
// Karena data awalnya diubah oleh sort pada nomor 3.
// cariProdukHabis(produk: Produk[]): string | null
function cariProdukHabis(produk) {
  let hasil = null;
  hasil = produk.map((p)=>p).find((p)=>p.stok==0)
  if (hasil!=undefined){
    return hasil.nama;
  } else return null;
  
}

// ===== Advanced 1 =====
// laporanKategori(produk: Produk[]): string[]
function laporanKategori(produk) {
  let hasil = null;
  let jenisKategori = []
  for (let i of produk){
      if (!jenisKategori.includes(i.kategori)) jenisKategori.push(i.kategori);
    }
  // console.log(jenisKategori)
  hasil = jenisKategori.map((p)=>{
    const isi = produk.filter((f)=>f.kategori===p);
    return `${p}: ${isi.length} produk, stok ${isi.map((p)=> p.stok).reduce((acc,b)=> acc + b, 0)}, omzet ${isi.map((p)=>p.terjual*p.harga).reduce((acc, b)=> acc + b, 0)}`;
  });
  return hasil;
}

// ===== Advanced 2 =====
// JAWABAN Advanced 2b:
// 
// checkout(keranjang: Item[], produk: Produk[], kodePromo: string | null): string
function checkout(keranjang, produk, kodePromo) {
  const list = keranjang.map((k)=>{
    const match = produk.find((pro)=>pro.id===k.idProduk);
    if (match==undefined){
      return `GAGAL: produk ${k.idProduk} tidak ditemukan`
    }
    if (k.qty>match.stok){
      return `GAGAL: stok ${match.nama} tidak cukup (sisa ${match.stok})`
    }
    let diskon = 1;
    let diskonRupiah = match.harga*k.qty*(1-diskon);
    
    let ongkir = 15000
    if(kodePromo==="HEMAT10"){
        diskon = 90/100;
    }
    if(kodePromo==="GRATIS-ONGKIR"){
        ongkir = 0;
    }
    if(kodePromo===null || kodePromo==="HEMAT10" || kodePromo==="GRATIS-ONGKIR"){
      const sub = k.harga.reduce((acc,b) => acc + b,0)
      let subtotal = total.harga*k.qty*diskon;
      if(subtotal>=100000){
        ongkir=0;
      }
      let total = subtotal + ongkir
        return `Subtotal: ${subtotal}, Diskon: ${diskonRupiah}, Ongkir: ${ongkir}, Total: ${total}`;
      } else{
        return `GAGAL: kode promo tidak valid`;
      }
    
  });
  return list;
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(namaProdukTersedia(produk).join(", "));

console.log("== Beginner 2 ==");
console.log(totalStok(produk));

console.log("== Beginner 3 ==");
console.log(adaKategori(produk, "Minuman"), adaKategori(produk, "Elektronik"));
console.log(semuaRatingDiAtas(produk, 4.0), semuaRatingDiAtas(produk, 4.5));

console.log("== Intermediate 1 ==");
for (const baris of rincianCheckout(keranjang, produk)) console.log(baris);
console.log(`Total: ${totalCheckout(keranjang, produk)}`);

console.log("== Intermediate 2 ==");
console.log(totalTerjual(produk));

console.log("== Intermediate 3 ==");
const termurah = urutHargaTermurah(produk);
console.log(termurah.slice(0, 3).map((p) => p.nama).join(", "));
console.log(`Produk pertama di data asli: ${produk[0].nama}`);

console.log("== Intermediate 4 ==");
console.log(cariProdukHabis(produk));
console.log(cariProdukHabis(produk.filter((p) => p.stok > 0)));

console.log("== Advanced 1 ==");
for (const baris of laporanKategori(produk)) console.log(baris);

console.log("== Advanced 2 ==");
console.log(checkout(keranjang, produk, null));
console.log(checkout(keranjang, produk, "HEMAT10"));
console.log(checkout([{ idProduk: "P03", qty: 1 }, { idProduk: "P04", qty: 2 }], produk, "GRATIS-ONGKIR"));
console.log(checkout([{ idProduk: "P03", qty: 1 }, { idProduk: "P04", qty: 2 }], produk, null));
console.log(checkout([{ idProduk: "P01", qty: 3 }], produk, "HEMAT10"));
console.log(checkout([{ idProduk: "P01", qty: 3 }, { idProduk: "P06", qty: 9 }], produk, null));
console.log(checkout([{ idProduk: "P02", qty: 1 }], produk, null));
console.log(checkout([{ idProduk: "P99", qty: 1 }], produk, null));
console.log(checkout(keranjang, produk, "DISKON50"));
console.log(checkout([], produk, null));
