// Praktikum TS Modul 5 — file starter
// 1. Salin file ini ke Jawaban/soal-ts5.ts.
// 2. Lengkapi bagian bertanda TODO dan perbaiki kode milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Cek tipe dulu: npx tsc --noEmit   (harus tanpa error di akhir)
// 4. Lalu jalankan: node Jawaban/soal-ts5.ts
// 5. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.

// ===== Coba Sendiri (dari HO) =====
// Bagian 1: tulis tebakan output sebagai komentar di ujung setiap baris console.log.
// Jalankan bagian ini saja: node Jawaban/soal-ts5.ts coba
function cobaSendiri() {
  function jelaskan(x: string | number | boolean): string {
    if (typeof x === "string") return `teks ${x.length} huruf`;
    if (typeof x === "number") return `angka ${x.toFixed(1)}`;
    return `boolean ${x}`;
  }
  console.log(jelaskan("abc"), jelaskan(2), jelaskan(false));

  const err = new RangeError("di luar batas");
  console.log(err instanceof RangeError, err instanceof Error, typeof err);
  console.log(typeof null, typeof [], Array.isArray([]));

  // Bagian 2: hapus // di depan SATU baris, jalankan npx tsc --noEmit,
  //           catat hasilnya, lalu pasang lagi // sebelum mencoba baris berikutnya.
  // const besar = (x: string | number) => x.toUpperCase();
  // const y = jelaskan(null);
  // let z: never = "a";
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

// ===== TIPE (JANGAN DIUBAH, kecuali sementara untuk Beginner 3) =====
interface Rekening {
  readonly nomor: string;
  pemilik: string;
  saldo: number;
  status: "aktif" | "beku";
}

type Transaksi =
  | { jenis: "setor"; nominal: number }
  | { jenis: "tarik"; nominal: number }
  | { jenis: "transfer"; nominal: number; tujuan: string };

// Respon dari layanan transfer bank lain. Bentuknya berbeda untuk berhasil dan gagal.
type ResponTransfer = { idTransaksi: string; biaya: number } | { alasan: string };

type Hasil<T> = { ok: true; nilai: T } | { ok: false; error: string };

// ===== DATA (JANGAN DIUBAH) =====
const daftarRekening: Rekening[] = [
  { nomor: "1001", pemilik: "Ani", saldo: 500000, status: "aktif" },
  { nomor: "1002", pemilik: "Budi", saldo: 75000, status: "aktif" },
  { nomor: "1003", pemilik: "Citra", saldo: 1200000, status: "beku" },
];

// ===== Beginner 1 =====
function formatNominal(x: number | string): string {
  // TODO
  // ≈ 6 baris
  return "";
}

// ===== Beginner 2 =====
function keterangan(t: Transaksi): string {
  // TODO: switch pada t.jenis, dengan cabang default berisi pemeriksaan never
  // ≈ 14 baris
  return "";
}

// ===== Beginner 3 (jelaskan) =====
// JAWABAN Beginner 3 (pesan error tsc, mengapa membantu, apa jadinya tanpa default never):
//

// ===== Intermediate 1 =====
// TODO: field kekurangan (number, readonly), name "SaldoKurangError", pesan "saldo kurang <rupiah>"
// ≈ 8 baris untuk seluruh class
class SaldoKurangError extends Error {
  constructor(kekurangan: number) {
    super("TODO");
  }
}

// TODO: field nomor (string, readonly), name "RekeningBekuError", pesan "rekening <nomor> dibekukan"
// ≈ 8 baris untuk seluruh class
class RekeningBekuError extends Error {
  constructor(nomor: string) {
    super("TODO");
  }
}

function tarik(r: Rekening, nominal: number): number {
  // TODO
  // ≈ 6 baris
  return r.saldo;
}

// ===== Intermediate 2 =====
function cobaTarik(r: Rekening, nominal: number): string {
  // TODO: panggil tarik di dalam try, bedakan error di catch dengan instanceof
  // ≈ 11 baris
  return "";
}

// ===== Intermediate 3 (kode temanmu, perbaiki) =====
// JAWABAN Intermediate 3:
//
function ringkasRespon(r: ResponTransfer): string {
  const sukses = r as { idTransaksi: string; biaya: number };
  return `Transfer berhasil, id ${sukses.idTransaksi}, biaya ${rupiah(sukses.biaya)}`;
}

// ===== Advanced 1 =====
// JAWABAN Advanced 1a (urutan pemeriksaan dan alasannya, bentuk data, mengapa Hasil bukan throw):
//
function transfer(
  dari: string,
  ke: string,
  nominal: number,
  daftar: Rekening[],
): Hasil<{ saldoPengirim: number; saldoPenerima: number }> {
  // TODO (opsional)
  // ≈ 18 baris
  return { ok: false, error: "belum dibuat" };
}

// Sudah jadi, jangan diubah.
function cetakHasil(h: Hasil<{ saldoPengirim: number; saldoPenerima: number }>): string {
  if (!h.ok) return `GAGAL: ${h.error}`;
  return `OK: sisa pengirim ${rupiah(h.nilai.saldoPengirim)}, saldo penerima ${rupiah(h.nilai.saldoPenerima)}`;
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
console.log("== Beginner 1 ==");
console.log(formatNominal(15000));
console.log(formatNominal("25.000"));
console.log(formatNominal("dua puluh"));

console.log("== Beginner 2 ==");
console.log(keterangan({ jenis: "setor", nominal: 200000 }));
console.log(keterangan({ jenis: "transfer", nominal: 50000, tujuan: "1002" }));

console.log("== Intermediate 1 ==");
const contohError = new SaldoKurangError(25000);
console.log(contohError.message, contohError.kekurangan, contohError instanceof Error);
console.log(contohError.name);
console.log(tarik(daftarRekening[0], 100000));

console.log("== Intermediate 2 ==");
console.log(cobaTarik(daftarRekening[0], 50000));
console.log(cobaTarik(daftarRekening[1], 100000));
console.log(cobaTarik(daftarRekening[2], 10000));

console.log("== Intermediate 3 ==");
console.log(ringkasRespon({ idTransaksi: "TRX-77", biaya: 2500 }));
console.log(ringkasRespon({ alasan: "rekening tujuan tidak ada" }));

console.log("== Advanced 1 ==");
console.log(cetakHasil(transfer("1001", "1002", 150000, daftarRekening)));
console.log(cetakHasil(transfer("1002", "1009", 10000, daftarRekening)));
console.log(cetakHasil(transfer("1002", "1001", 300000, daftarRekening)));
console.log(cetakHasil(transfer("1001", "1003", 10000, daftarRekening)));
console.log(cetakHasil(transfer("1001", "1001", 10000, daftarRekening)));
console.log(cetakHasil(transfer("1001", "1002", 0, daftarRekening)));
