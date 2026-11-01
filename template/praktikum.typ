// Template bersama HO dan Soal, meniru tampilan modul Praktikum Database System (CE 613).
// Font Arial + Consolas (bawaan Windows), ikon dari Segoe UI Symbol.

#let biru = rgb("#0969da")   // Catatan, link
#let merah = rgb("#cf222e")  // Perhatian
#let hijau = rgb("#1a7f37")  // Coba Sendiri
#let abu-kode = rgb("#f6f8fa")
#let garis-kode = rgb("#d0d7de")
#let abu-teks = rgb("#57606a")

#let ikon(c) = text(font: "Segoe UI Symbol", c)

#let praktikum(judul: "", modul: "", body) = {
  set document(title: modul + " - " + judul)
  set page(
    paper: "a4",
    margin: (x: 2cm, top: 2.2cm, bottom: 2.4cm),
    footer: context {
      line(length: 100%, stroke: 0.4pt + luma(200))
      v(-4pt)
      set text(size: 8pt, fill: abu-teks)
      grid(
        columns: (1fr, auto),
        [*JS & TS* --- Praktikum JavaScript & TypeScript \ Belajar Mandiri, November 2026],
        counter(page).display("1 / 1", both: true),
      )
    },
  )
  set text(font: "Arial", size: 10.5pt, lang: "id")
  set par(justify: true, leading: 0.55em, spacing: 0.9em)
  set heading(numbering: "1.1.")
  show heading: set text(fill: black)
  show heading.where(level: 1): set text(size: 15pt)
  show heading.where(level: 1): set block(above: 1.5em, below: 0.6em)
  show heading.where(level: 2): set text(size: 12pt)
  show heading.where(level: 2): set block(above: 1.2em, below: 0.6em)
  show heading.where(level: 3): set text(size: 10.5pt)
  show heading.where(level: 3): set block(above: 1.1em, below: 0.6em)

  show raw: set text(font: "Consolas", size: 8.5pt)
  show raw.where(block: false): it => box(
    fill: rgb("#eff2f6"), inset: (x: 3pt), outset: (y: 2.5pt), radius: 2pt, it,
  )
  show raw.where(block: true): it => block(
    width: 100%, fill: abu-kode, stroke: 0.5pt + garis-kode, radius: 4pt,
    inset: (x: 9pt, y: 8pt), it,
  )

  show figure.where(kind: raw): set figure(supplement: "Listing")
  show figure.where(kind: raw): set align(left)
  show figure.caption: it => align(center, text(size: 8.5pt)[
    #text(weight: "bold")[#it.supplement #context it.counter.display(it.numbering)]#it.separator#it.body
  ])
  set figure.caption(separator: ": ")
  show figure: set block(above: 1em, below: 1em)

  set list(marker: [•], indent: 0.2em, body-indent: 0.5em)
  set enum(numbering: "1.a.", indent: 0.2em, body-indent: 0.5em)
  set table(stroke: 0.5pt + luma(190), inset: 6pt, fill: (_, y) => if y == 0 { luma(242) })

  align(center)[
    #v(0.6em)
    #text(size: 22pt, weight: "bold")[Praktikum JavaScript & TypeScript]
    #v(0.5em)
    #text(size: 13pt)[#modul - #judul]
  ]
  v(1.4em)
  body
}

#let kotak(warna, simbol, label, isi) = block(
  width: 100%, stroke: 0.8pt + warna, radius: 4pt, clip: true, breakable: true,
  above: 1.1em, below: 1.1em,
)[
  #stack(
    block(
      width: 100%, fill: warna.lighten(88%), inset: (x: 9pt, y: 6pt),
      stroke: (bottom: 0.5pt + warna.lighten(40%)),
    )[#text(fill: warna, weight: "bold")[#ikon(simbol) #label]],
    block(width: 100%, inset: (x: 9pt, top: 7pt, bottom: 8pt))[#isi],
  )
]

#let catatan(isi) = kotak(biru, "✎", "Catatan", isi)
#let perhatian(isi) = kotak(merah, "⚠", "Perhatian", isi)
#let coba-sendiri(isi) = kotak(hijau, "💡", "Coba Sendiri", isi)

// Listing bernomor: #listing("contoh if")[```js ... ```]
#let listing(caption, kode) = figure(kode, caption: caption, kind: raw)

// Subbab level soal: #level("Beginner", "0.3") menjadi "1.1. Beginner (0.3)"
#let level(nama, bobot) = heading(level: 2)[#nama (#bobot)]

// Contoh Output: teks persis yang harus dicetak program
#let output(isi) = block(width: 100%, above: 1em, below: 1em)[
  #text(size: 8.5pt, weight: "bold", fill: abu-teks)[Contoh Output]
  #v(-0.5em)
  #isi
]
