// Server statis kecil untuk membuka halaman praktikum DOM di browser.
// Browser menolak <script type="module"> dari file:// (alasan keamanan), jadi halaman harus dibuka lewat http.
// Pakai: npm run sajikan   lalu buka alamat yang dicetak.
import { createServer } from "node:http";
import { readFile } from "node:fs/promises";
import { extname, join, normalize } from "node:path";

const PORT = 8080;
const akar = process.cwd();
const jenis = { ".html": "text/html", ".js": "text/javascript", ".css": "text/css", ".png": "image/png", ".svg": "image/svg+xml" };

createServer(async (req, res) => {
  const jalur = normalize(decodeURIComponent(new URL(req.url, "http://x").pathname));
  const file = join(akar, jalur);
  if (!file.startsWith(akar)) {
    res.writeHead(403).end("dilarang");
    return;
  }
  try {
    const isi = await readFile(file);
    res.writeHead(200, { "Content-Type": `${jenis[extname(file)] ?? "application/octet-stream"}; charset=utf-8` }).end(isi);
  } catch {
    res.writeHead(404).end("tidak ditemukan");
  }
}).listen(PORT, "127.0.0.1", () => {
  console.log(`Server jalan. Buka http://localhost:${PORT}/javascript/topik-08-dom/Jawaban/index.html`);
  console.log("Hentikan dengan Ctrl+C.");
});
