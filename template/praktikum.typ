// Template bersama untuk HO dan Soal praktikum JS/TS.
// Satu font untuk semua teks (DejaVu Sans Mono dibundel Typst, jadi sama di semua device).

#let biru = rgb("#3d6a99")   // struktur: judul, heading, Coba Sendiri
#let hijau = rgb("#5f8a3a")  // Catatan
#let merah = rgb("#a8507a")  // Perhatian
#let abu = rgb("#f4f5f7")

#let praktikum(judul: "", modul: "", body) = {
  set document(title: modul + " - " + judul)
  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2.4cm, bottom: 2.2cm),
    header: context {
      if counter(page).get().first() > 1 [
        #set text(size: 12pt, fill: biru)
        Praktikum JavaScript & TypeScript #h(1fr) #modul
        #v(-6pt) #line(length: 100%, stroke: 0.5pt + biru)
      ]
    },
    footer: context [
      #set text(size: 12pt, fill: luma(90))
      Praktikum JavaScript & TypeScript #h(1fr)
      #counter(page).display("1/1", both: true)
    ],
  )
  set text(font: "DejaVu Sans Mono", size: 12pt, lang: "id")
  set par(justify: false, leading: 0.7em, spacing: 1.1em)
  set heading(numbering: "1.1.")
  show heading: set text(fill: biru, size: 13pt)
  show heading.where(level: 1): set block(above: 1.6em, below: 0.9em)
  show raw: set text(font: "DejaVu Sans Mono", size: 12pt)
  // font sama dengan prosa, jadi kode inline dibedakan lewat latar dan warna
  show raw.where(block: false): it => box(
    fill: abu, inset: (x: 2pt), outset: (y: 2.5pt), radius: 2pt,
    text(fill: rgb("#2b4f75"), it),
  )
  show raw.where(block: true): block.with(
    fill: abu, inset: 9pt, radius: 3pt, width: 100%,
  )
  show figure.where(kind: raw): set figure.caption(position: bottom)
  show figure.where(kind: raw): set align(left)
  show figure.caption: set text(size: 12pt, style: "italic", fill: luma(70))
  set list(indent: 0.6em)
  set enum(indent: 0.6em)

  align(center)[
    #text(size: 14pt, weight: "bold", fill: biru)[Praktikum JavaScript & TypeScript]
    #v(2pt)
    #text(size: 14pt, weight: "bold")[#modul -- #judul]
  ]
  v(0.8em)
  body
}

#let kotak(warna, label, isi) = block(
  width: 100%, inset: (left: 12pt, rest: 9pt), radius: 2pt,
  stroke: (left: 3pt + warna), fill: warna.lighten(92%),
  breakable: true,
)[
  #text(weight: "bold", fill: warna)[#label] \
  #isi
]

#let catatan(isi) = kotak(hijau, "Catatan", isi)
#let perhatian(isi) = kotak(merah, "Perhatian", isi)
#let coba-sendiri(isi) = kotak(biru, "Coba Sendiri", isi)

// Listing bernomor: #listing("contoh if")[```js ... ```]
#let listing(caption, kode) = figure(kode, caption: caption, supplement: "Listing", kind: raw)

// Judul level soal: #level("Beginner", "0.3")
#let level(nama, bobot) = block(above: 1.4em, below: 0.8em)[
  #text(weight: "bold", fill: biru, size: 13pt)[#nama (#bobot)]
]

// Contoh Output: teks persis yang harus dicetak program
#let output(isi) = block(
  width: 100%, inset: 9pt, radius: 3pt, stroke: 0.6pt + luma(150),
)[#text(size: 12pt, fill: luma(80))[Contoh Output] \ #isi]
