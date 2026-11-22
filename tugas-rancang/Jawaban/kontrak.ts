// Kontrak antara mesin kasir dan aplikasi lain di Swalayan Sumber Rejeki. JANGAN DIUBAH.
// Kode di kasir.ts harus memenuhi kontrak ini. Bagian dalamnya (class, file, fungsi bantu) bebas kamu rancang.

export type Hasil<T> = { ok: true; nilai: T } | { ok: false; error: string };

export interface Produk {
  kode: string;
  nama: string;
  harga: number;
  stok: number;
}

export interface Member {
  id: string;
  nama: string;
  saldo: number;
}

export interface Mutasi {
  jenis: "topup" | "tarik" | "bayar";
  nominal: number;
  saldoSetelah: number;
}

export interface BarisStruk {
  kode: string;
  nama: string;
  qty: number;
  subtotal: number;
}

export interface Struk {
  idTransaksi: string;
  baris: BarisStruk[];
  subtotal: number;
  diskon: number;
  total: number;
  metode: "tunai" | "saldo";
  dibayar: number;
  kembalian: number;
  sisaSaldo?: number;
}

export interface Kasir {
  topUp(idMember: string, nominal: number): Hasil<number>;
  tarikTunai(idMember: string, nominal: number): Hasil<number>;
  riwayat(idMember: string): Hasil<Mutasi[]>;
  tambahKeKeranjang(kode: string, qty: number): Hasil<number>;
  hapusDariKeranjang(kode: string): Hasil<number>;
  bayarTunai(uang: number): Hasil<Struk>;
  bayarSaldo(idMember: string): Hasil<Struk>;
  stok(kode: string): Hasil<number>;
}

export type BuatKasir = (produk: Produk[], member: Member[]) => Kasir;
