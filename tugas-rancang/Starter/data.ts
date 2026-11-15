// Data awal swalayan. JANGAN DIUBAH. Salinannya diberikan ke buatKasir.
import type { Member, Produk } from "./kontrak.ts";

export const produkAwal: Produk[] = [
  { kode: "P01", nama: "Beras 5 kg", harga: 68000, stok: 10 },
  { kode: "P02", nama: "Minyak goreng 1 L", harga: 18000, stok: 5 },
  { kode: "P03", nama: "Gula 1 kg", harga: 16500, stok: 3 },
  { kode: "P04", nama: "Telur 1 kg", harga: 28000, stok: 2 },
  { kode: "P05", nama: "Kopi sachet", harga: 1500, stok: 50 },
];

export const memberAwal: Member[] = [
  { id: "M01", nama: "Ani", saldo: 150000 },
  { id: "M02", nama: "Budi", saldo: 0 },
  { id: "M03", nama: "Citra", saldo: 1950000 },
];
