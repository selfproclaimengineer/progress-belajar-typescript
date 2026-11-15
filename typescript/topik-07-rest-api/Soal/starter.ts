// Praktikum TS Modul 7 (opsional) — file starter
// 1. Salin file ini ke Jawaban/soal-ts7.ts.
// 2. Lengkapi route bertanda TODO dan perbaiki kode milik "temanmu".
//    Jawaban soal (jelaskan) ditulis sebagai komentar di bawah baris "// JAWABAN ...".
// 3. Cek tipe dulu: npx tsc --noEmit   (harus tanpa error di akhir)
// 4. Lalu jalankan: node Jawaban/soal-ts7.ts
//    File ini menyalakan server di port acak, memanggil setiap route dengan fetch, mencetak hasilnya,
//    lalu mematikan server lagi.
// 5. Bandingkan output dengan kotak "Output dari console.log(...)" di bawah setiap tugas di PDF soal.
// Library express dan zod sudah terpasang di repo.
import express from "express";
import type { Request, Response } from "express";
import { z } from "zod";

// Sudah jadi: menyalakan app di port acak, mengembalikan alamat dasarnya dan fungsi untuk mematikan.
async function nyalakan(app: express.Express) {
  const server = app.listen(0);
  await new Promise<void>((resolve) => server.once("listening", () => resolve()));
  const alamat = server.address();
  if (alamat === null || typeof alamat === "string") throw new Error("server gagal jalan");
  const matikan = () =>
    new Promise<void>((resolve) => {
      server.close(() => resolve());
      server.closeAllConnections();
    });
  return { dasar: `http://127.0.0.1:${alamat.port}`, matikan };
}

// ===== Coba Sendiri (dari HO) =====
// Tulis tebakan output sebagai komentar di ujung setiap baris console.log.
// Jalankan bagian ini saja: node Jawaban/soal-ts7.ts coba
async function cobaSendiri() {
  const app = express();
  app.use(express.json());
  app.get("/halo/:nama", (req: Request<{ nama: string }>, res: Response) => {
    res.json({ sapa: `halo ${req.params.nama}`, tipe: typeof req.params.nama });
  });
  app.post("/gema", (req: Request, res: Response) => {
    res.status(201).json(req.body);
  });

  const { dasar, matikan } = await nyalakan(app);
  let res = await fetch(dasar + "/halo/123");
  console.log(res.status, await res.text());
  res = await fetch(dasar + "/tidak-ada");
  console.log(res.status);
  res = await fetch(dasar + "/gema", { method: "POST", headers: { "Content-Type": "application/json" }, body: '{"a":1}' });
  console.log(res.status, await res.text());
  res = await fetch(dasar + "/gema", { method: "POST", body: '{"a":1}' });
  console.log(res.status, JSON.stringify(await res.text()));
  await matikan();
}

// JAWABAN Coba Sendiri 1:
//
// JAWABAN Coba Sendiri 2:
//
// JAWABAN Coba Sendiri 3:
//
// JAWABAN Coba Sendiri 4:
//

// ===== TIPE (JANGAN DIUBAH) =====
interface Buku {
  id: string;
  judul: string;
  penulis: string;
  stok: number;
}

interface Pinjaman {
  idPinjam: string;
  idBuku: string;
  idAnggota: string;
}

const BATAS_PINJAM = 2;

// ===== Skema =====
// TODO (Intermediate 1): skema buku baru, lengkap dengan pesan error seperti di soal
const SkemaBukuBaru = z.object({});

// TODO (Intermediate 2): skema perubahan buku, diturunkan dari SkemaBukuBaru

// TODO (Advanced 1, opsional): skema peminjaman

// Sudah jadi (dari TS-6): ubah error zod pertama menjadi "<path>: <pesan>".
function pesanZod(error: z.ZodError): string {
  const m = error.issues[0];
  const lokasi = m.path.join(".");
  return lokasi === "" ? m.message : `${lokasi}: ${m.message}`;
}

function buatApp() {
  // ===== DATA (JANGAN DIUBAH) =====
  // Disimpan di memori: hilang setiap kali server dimatikan.
  const daftarBuku: Buku[] = [
    { id: "B001", judul: "Laskar Pelangi", penulis: "Andrea Hirata", stok: 2 },
    { id: "B002", judul: "Bumi Manusia", penulis: "Pramoedya Ananta Toer", stok: 1 },
    { id: "B003", judul: "Filosofi Teras", penulis: "Henry Manampiring", stok: 0 },
  ];
  const daftarPinjaman: Pinjaman[] = [];
  let nomorBuku = 3;

  const app = express();
  app.use(express.json());

  // ===== Beginner 1 =====
  app.get("/buku", (req: Request, res: Response) => {
    // TODO
    res.status(501).json({ pesan: "belum dibuat" });
  });

  // ===== Beginner 2 =====
  app.get("/buku/:id", (req: Request<{ id: string }>, res: Response) => {
    // TODO
    res.status(501).json({ pesan: "belum dibuat" });
  });

  // ===== Beginner 3 (jelaskan) =====
  // JAWABAN Beginner 3:
  //

  // ===== Intermediate 1 =====
  app.post("/buku", (req: Request, res: Response) => {
    // TODO
    res.status(501).json({ pesan: "belum dibuat" });
  });

  // ===== Intermediate 2 =====
  app.patch("/buku/:id", (req: Request<{ id: string }>, res: Response) => {
    // TODO
    res.status(501).json({ pesan: "belum dibuat" });
  });

  // ===== Intermediate 3 (kode temanmu, perbaiki) =====
  // JAWABAN Intermediate 3:
  //
  app.delete("/buku/:id", (req: Request<{ id: string }>, res: Response) => {
    const i = daftarBuku.findIndex((b) => b.id === req.params.id);
    if (i === -1) {
      res.status(404).json({ pesan: "buku tidak ditemukan" });
    }
    daftarBuku.splice(i, 1);
    res.status(204).end();
  });

  // ===== Advanced 1 =====
  // JAWABAN Advanced 1a (urutan pemeriksaan, pilihan status code, mengapa validasi di server):
  //
  app.post("/pinjam", (req: Request, res: Response) => {
    // TODO (opsional)
    res.status(501).json({ pesan: "belum dibuat" });
  });

  return app;
}

// ===== PEMANGGILAN (JANGAN DIUBAH) =====
async function pemanggilan() {
  const { dasar, matikan } = await nyalakan(buatApp());

  // Kirim satu permintaan, kembalikan "<status> <isi balasan>".
  async function panggil(metode: string, jalur: string, isi?: unknown): Promise<string> {
    const res = await fetch(dasar + jalur, {
      method: metode,
      headers: { "Content-Type": "application/json" },
      body: isi === undefined ? undefined : JSON.stringify(isi),
    });
    const teks = await res.text();
    return `${res.status} ${teks === "" ? "(kosong)" : teks}`;
  }

  console.log("== Beginner 1 ==");
  console.log(await panggil("GET", "/buku"));

  console.log("== Beginner 2 ==");
  console.log(await panggil("GET", "/buku/B002"));
  console.log(await panggil("GET", "/buku/B009"));

  console.log("== Intermediate 1 ==");
  console.log(await panggil("POST", "/buku", { judul: "Cantik Itu Luka", penulis: "Eka Kurniawan", stok: 3 }));
  console.log(await panggil("POST", "/buku", { judul: "", penulis: "Anonim", stok: 1 }));
  console.log(await panggil("POST", "/buku", { judul: "Ronggeng Dukuh Paruk", penulis: "Ahmad Tohari", stok: "dua" }));

  console.log("== Intermediate 2 ==");
  console.log(await panggil("PATCH", "/buku/B003", { stok: 4 }));
  console.log(await panggil("PATCH", "/buku/B001", { stok: -1 }));
  console.log(await panggil("PATCH", "/buku/B009", { stok: 1 }));

  console.log("== Intermediate 3 ==");
  console.log(await panggil("DELETE", "/buku/B009"));
  console.log(await panggil("DELETE", "/buku/B004"));
  console.log(await panggil("GET", "/buku"));

  console.log("== Advanced 1 ==");
  console.log(await panggil("POST", "/pinjam", { idBuku: "B002", idAnggota: "A01" }));
  console.log(await panggil("POST", "/pinjam", { idBuku: "B002", idAnggota: "A02" }));
  console.log(await panggil("POST", "/pinjam", { idBuku: "B001", idAnggota: "A01" }));
  console.log(await panggil("POST", "/pinjam", { idBuku: "B003", idAnggota: "A01" }));
  console.log(await panggil("POST", "/pinjam", { idBuku: "B007", idAnggota: "A02" }));
  console.log(await panggil("POST", "/pinjam", { idBuku: "B001" }));
  console.log(await panggil("GET", "/buku/B001"));

  await matikan();
}

// node Jawaban/soal-ts7.ts coba  -> Coba Sendiri saja. Tanpa argumen -> soal.
if (process.argv[2] === "coba") await cobaSendiri();
else await pemanggilan();
