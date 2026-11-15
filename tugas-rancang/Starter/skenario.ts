// Uji terima dari klien. JANGAN DIUBAH.
// Jalankan: node Jawaban/skenario.ts   lalu bandingkan dengan bagian "Output skenario" di KRITERIA.pdf.
import type { Hasil, Mutasi, Struk } from "./kontrak.ts";
import { memberAwal, produkAwal } from "./data.ts";
import { buatKasir } from "./kasir.ts";

const rupiah = (n: number): string => `Rp${new Intl.NumberFormat("id-ID").format(n)}`;

// Salinan dalam, supaya data awal tidak ikut berubah.
const kasir = buatKasir(structuredClone(produkAwal), structuredClone(memberAwal));

let nomor = 0;
function cek<T>(langkah: string, h: Hasil<T>, tampilkan: (nilai: T) => string): void {
  nomor++;
  const no = String(nomor).padStart(2, "0");
  console.log(h.ok ? `${no}. ${langkah} -> ${tampilkan(h.nilai)}` : `${no}. ${langkah} -> GAGAL: ${h.error}`);
}

function teksStruk(s: Struk): string {
  const baris = s.baris.map((b) => `${b.qty}x ${b.nama} ${rupiah(b.subtotal)}`).join(", ");
  const saldo = s.sisaSaldo === undefined ? "" : `, sisa saldo ${rupiah(s.sisaSaldo)}`;
  return `${s.idTransaksi} [${baris}] subtotal ${rupiah(s.subtotal)}, diskon ${rupiah(s.diskon)}, total ${rupiah(s.total)}, ${s.metode} ${rupiah(s.dibayar)}, kembalian ${rupiah(s.kembalian)}${saldo}`;
}

const teksRiwayat = (daftar: Mutasi[]): string =>
  daftar.length === 0 ? "(kosong)" : daftar.map((m) => `${m.jenis} ${rupiah(m.nominal)} (saldo ${rupiah(m.saldoSetelah)})`).join(", ");

const saldo = (n: number): string => `saldo ${rupiah(n)}`;
const total = (n: number): string => `total ${rupiah(n)}`;
const stok = (n: number): string => `stok ${n}`;

console.log("== Dompet ==");
cek("topUp M02 50000", kasir.topUp("M02", 50000), saldo);
cek("topUp M02 5000", kasir.topUp("M02", 5000), saldo);
cek("topUp M03 100000", kasir.topUp("M03", 100000), saldo);
cek("topUp M09 20000", kasir.topUp("M09", 20000), saldo);
cek("topUp M01 12500.5", kasir.topUp("M01", 12500.5), saldo);
cek("tarikTunai M01 70000", kasir.tarikTunai("M01", 70000), saldo);
cek("tarikTunai M02 100000", kasir.tarikTunai("M02", 100000), saldo);
cek("tarikTunai M01 50000", kasir.tarikTunai("M01", 50000), saldo);

console.log("== Keranjang ==");
cek("tambah P01 1", kasir.tambahKeKeranjang("P01", 1), total);
cek("tambah P04 3", kasir.tambahKeKeranjang("P04", 3), total);
cek("tambah P04 2", kasir.tambahKeKeranjang("P04", 2), total);
cek("tambah P04 1", kasir.tambahKeKeranjang("P04", 1), total);
cek("tambah P09 1", kasir.tambahKeKeranjang("P09", 1), total);
cek("tambah P05 0", kasir.tambahKeKeranjang("P05", 0), total);
cek("hapus P03", kasir.hapusDariKeranjang("P03"), total);

console.log("== Pembayaran ==");
cek("bayarSaldo M01", kasir.bayarSaldo("M01"), teksStruk);
cek("bayarTunai 100000", kasir.bayarTunai(100000), teksStruk);
cek("bayarTunai 150000", kasir.bayarTunai(150000), teksStruk);
cek("stok P04", kasir.stok("P04"), stok);
cek("bayarTunai 10000", kasir.bayarTunai(10000), teksStruk);
cek("tambah P02 2", kasir.tambahKeKeranjang("P02", 2), total);
cek("tambah P05 4", kasir.tambahKeKeranjang("P05", 4), total);
cek("tambah P03 1", kasir.tambahKeKeranjang("P03", 1), total);
cek("hapus P03", kasir.hapusDariKeranjang("P03"), total);
cek("bayarSaldo M02", kasir.bayarSaldo("M02"), teksStruk);
cek("tambah P01 2", kasir.tambahKeKeranjang("P01", 2), total);
cek("bayarSaldo M03", kasir.bayarSaldo("M03"), teksStruk);

console.log("== Laporan ==");
cek("riwayat M01", kasir.riwayat("M01"), teksRiwayat);
cek("riwayat M02", kasir.riwayat("M02"), teksRiwayat);
cek("riwayat M03", kasir.riwayat("M03"), teksRiwayat);
cek("stok P01", kasir.stok("P01"), stok);
cek("stok P05", kasir.stok("P05"), stok);
cek("stok P09", kasir.stok("P09"), stok);
