// Mesin kasir Swalayan Sumber Rejeki. File ini milikmu.
// Wajib: export buatKasir yang memenuhi kontrak di kontrak.ts.
// Bebas: class, interface, fungsi bantu, dan file tambahan di folder Jawaban (misalnya dompet.ts, keranjang.ts).
import type { BuatKasir, Hasil } from "./kontrak.ts";

const belum: Hasil<never> = { ok: false, error: "belum dibuat" };

// TODO: ganti seluruh isi ini dengan rancanganmu.
export const buatKasir: BuatKasir = (produk, member) => ({
  topUp: () => belum,
  tarikTunai: () => belum,
  riwayat: () => belum,
  tambahKeKeranjang: () => belum,
  hapusDariKeranjang: () => belum,
  bayarTunai: () => belum,
  bayarSaldo: () => belum,
  stok: () => belum,
});
