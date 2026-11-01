# Progress Belajar TypeScript

Praktikum mandiri JavaScript dan TypeScript untuk persiapan live coding. Formatnya meniru praktikum kuliah: setiap topik punya handout (HO), soal bertingkat (Beginner, Intermediate, Advanced), jawaban di kode, dan catatan diskusi.

- Jadwal dan daftar topik: [SILABUS.md](SILABUS.md)
- Progres harian dan nilai: [PROGRESS.md](PROGRESS.md)

## Struktur

```
javascript/topik-XX-nama/
  HO/        handout (PDF + sumber Typst)
  Soal/      soal (PDF + sumber Typst) dan file starter
  Jawaban/   cobaN.js dan soal-jsN.js (jawaban penjelasan ditulis sebagai komentar)
  Diskusi/   log tanya jawab dengan asisten dan feedback
typescript/  pola yang sama
tugas-rancang/
```

## Menjalankan kode

Butuh Node.js 24 atau lebih baru.

```
node javascript/topik-01-variabel-kondisi/Jawaban/soal1.js
```

## VS Code

Buka folder repo ini (File > Open Folder). Pengaturan workspace di `.vscode/settings.json` mematikan fitur AI dan saran kode inline, karena live coding menuntut logika ditulis sendiri.

- **Menjalankan file:** `node <file>` di terminal (Ctrl+\`), atau Ctrl+Alt+N (Code Runner).
- **Melihat isi variabel saat program berjalan:** klik di kiri nomor baris untuk memasang breakpoint (titik merah). Buka Command Palette (Ctrl+Shift+P), pilih "JavaScript Debug Terminal", lalu jalankan `node <file>` di terminal itu. Program berhenti di breakpoint. Panel kiri menampilkan nilai setiap variabel, dan F10 menjalankan satu baris berikutnya. Cara ini paling cepat untuk memahami perulangan dan `reduce`.
- **Akhir sesi:** `npm run selesai -- --durasi "2 jam" --macet "..."`.
