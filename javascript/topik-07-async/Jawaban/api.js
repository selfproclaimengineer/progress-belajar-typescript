// Server bank PALSU untuk praktikum JS-7. JANGAN DIUBAH.
// Meniru layanan bank lewat jaringan: setiap permintaan butuh waktu (setTimeout),
// dan fetchBank bekerja seperti fetch asli: hasilnya Promise berisi Response.

const JEDA = 50; // ms untuk setiap permintaan
const JEDA_LAMBAT = 400; // server cabang rekening 1004 sedang lambat

const rekening = new Map([
  ["1001", { nama: "Ani", saldo: 500000 }],
  ["1002", { nama: "Budi", saldo: 75000 }],
  ["1003", { nama: "Citra", saldo: 1200000 }],
  ["1004", { nama: "Dodi", saldo: 300000 }],
]);

// Gaya lama (callback dengan error di argumen pertama).
// cekSaldoCallback(nomor: string, callback: (err: Error | null, saldo?: number) => void): void
export function cekSaldoCallback(nomor, callback) {
  setTimeout(() => {
    const r = rekening.get(nomor);
    if (r === undefined) callback(new Error(`rekening ${nomor} tidak ada`));
    else callback(null, r.saldo);
  }, JEDA);
}

function balas(status, isi, jeda = JEDA) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(new Response(JSON.stringify(isi), { status, headers: { "Content-Type": "application/json" } }));
    }, jeda);
  });
}

// Gaya baru, sama seperti fetch(url, opsi).
// GET  /rekening/<nomor>                      -> 200 { nomor, nama, saldo } | 404 { pesan }
// POST /transfer  body JSON { dari, ke, nominal } -> 200 { saldoDari, saldoKe } | 400/404 { pesan }
// fetchBank(url: string, opsi?: { method?: string, body?: string }): Promise<Response>
export function fetchBank(url, opsi = {}) {
  const method = opsi.method ?? "GET";
  const cocok = url.match(/^\/rekening\/(\w+)$/);
  if (method === "GET" && cocok) {
    const nomor = cocok[1];
    const r = rekening.get(nomor);
    const jeda = nomor === "1004" ? JEDA_LAMBAT : JEDA;
    if (r === undefined) return balas(404, { pesan: "rekening tidak ditemukan" }, jeda);
    return balas(200, { nomor, nama: r.nama, saldo: r.saldo }, jeda);
  }
  if (method === "POST" && url === "/transfer") {
    const { dari, ke, nominal } = JSON.parse(opsi.body ?? "{}");
    const a = rekening.get(dari);
    const b = rekening.get(ke);
    if (typeof nominal !== "number" || nominal <= 0) return balas(400, { pesan: "nominal tidak valid" });
    if (a === undefined || b === undefined) return balas(404, { pesan: "rekening tidak ditemukan" });
    if (a.saldo < nominal) return balas(400, { pesan: "saldo tidak cukup" });
    a.saldo -= nominal;
    b.saldo += nominal;
    return balas(200, { saldoDari: a.saldo, saldoKe: b.saldo });
  }
  return balas(404, { pesan: "alamat tidak ada" });
}
