// Template bersama HO dan Soal, meniru tampilan modul Praktikum Database System (CE 613).
// Font Arial + Consolas (bawaan Windows), ikon dari Segoe UI Symbol.

#let biru = rgb("#0969da")   // Catatan, link
#let merah = rgb("#cf222e")  // Perhatian
#let hijau = rgb("#1a7f37")  // Coba Sendiri
#let abu-kode = rgb("#f6f8fa")
#let garis-kode = rgb("#d0d7de")
#let abu-teks = rgb("#57606a")

#let ikon(c) = text(font: "Segoe UI Symbol", c)

// Warna tipe data untuk kode inline di soal, supaya tipe data cepat terlihat.
#let warna-tipe = (
  bulat: rgb("#1d4ed8"), desimal: rgb("#7e22ce"), teks: rgb("#15803d"), boolean: rgb("#c2410c"),
  kosong: rgb("#b91c1c"), array: rgb("#0f766e"), array2d: rgb("#be185d"), fungsi: rgb("#a16207"),
)
#let pola-token = regex(`"(?:[^"\\]|\\.)*"|'(?:[^'\\]|\\.)*'|(?:\[\])+|=>|[A-Za-z_$][\w$]*|\d[\d_]*(?:\.\d+)?|\s+|.`.text)
#let pola-nama = regex(`^[A-Za-z_$]`.text)
#let pola-angka = regex(`^\d`.text)
// Kata kunci yang diikuti "(" atau "[" tetapi bukan pemanggilan fungsi atau index.
#let kata-kunci = ("if", "for", "while", "switch", "catch", "return", "typeof", "of", "in", "case", "else", "await", "yield")
// Perintah terminal, path, dan komentar tidak diwarnai.
#let pola-lewati = regex(`^(node|npx|npm|git|typst)\s|^[\w.-]+/|^//`.text)

#let warnai-kode(s) = {
  let tok = s.matches(pola-token).map(m => m.text)
  let n = tok.len()
  // Pass 1: dimensi setiap kurung siku. 0 = index, 1 = array, 2 ke atas = array bertingkat.
  let dim = (0,) * n
  let pembuka = (none,) * n
  let tumpuk = () // (index pembuka, literal?, dimensi anak terbesar)
  let sebelum = none
  for i in range(n) {
    let t = tok.at(i)
    let setelah-nilai = sebelum != none and (
      (sebelum.match(pola-nama) != none and sebelum not in kata-kunci)
        or sebelum.match(pola-angka) != none or sebelum in (")", "]") or sebelum.starts-with("[]")
    )
    let d = none
    if t == "[" {
      tumpuk.push((i, not setelah-nilai, 0))
    } else if t == "]" and tumpuk.len() > 0 {
      let (o, literal, anak) = tumpuk.pop()
      pembuka.at(i) = o
      d = if literal { anak + 1 } else { anak }
      if literal { dim.at(o) = d }
    } else if t.starts-with("[]") {
      // number[][] = tipe array 2 dimensi; [] di posisi nilai = array kosong
      d = if setelah-nilai { calc.div-euclid(t.len(), 2) } else { 1 }
      dim.at(i) = d
    }
    if d != none and tumpuk.len() > 0 {
      let (po, pl, pa) = tumpuk.pop()
      tumpuk.push((po, pl, calc.max(pa, d)))
    }
    if t.trim() != "" { sebelum = t }
  }
  // Pass 2: beri warna setiap token.
  let hasil = ()
  for i in range(n) {
    let t = tok.at(i)
    let berikut = none
    for j in range(i + 1, n) {
      if tok.at(j).trim() != "" { berikut = tok.at(j); break }
    }
    let w = none
    let tebal = false
    if (t.starts-with("\"") or t.starts-with("'")) and t.len() >= 2 { w = warna-tipe.teks }
    else if t.match(pola-angka) != none { w = if t.contains(".") { warna-tipe.desimal } else { warna-tipe.bulat } }
    else if t in ("true", "false", "boolean") { w = warna-tipe.boolean }
    else if t in ("null", "undefined", "NaN") { w = warna-tipe.kosong }
    else if t == "number" { w = warna-tipe.bulat }
    else if t == "string" { w = warna-tipe.teks }
    else if t in ("=>", "function") { w = warna-tipe.fungsi; tebal = true }
    else if t.match(pola-nama) != none and berikut == "(" and t not in kata-kunci { w = warna-tipe.fungsi }
    else if t == "[" or t == "]" or t.starts-with("[]") {
      let d = if t == "]" { if pembuka.at(i) == none { 0 } else { dim.at(pembuka.at(i)) } } else { dim.at(i) }
      if d >= 2 { w = warna-tipe.array2d; tebal = true } else if d == 1 { w = warna-tipe.array; tebal = true }
    }
    else if t in ("{", "}") { tebal = true }
    // Spasi jadi non-breaking space supaya spasi ganda tidak dilebur.
    let isi = t.replace(" ", "\u{a0}")
    hasil.push(text(fill: if w == none { black } else { w }, weight: if tebal { "bold" } else { "regular" }, isi))
  }
  text(font: "Consolas", size: 8.5pt, hyphenate: false, hasil.join())
}

#let contoh-warna(isi, label) = box[#raw(isi) #text(fill: abu-teks, label)]
#let legenda-tipe = block(width: 100%, above: 0.4em, below: 1em, inset: (x: 9pt, y: 7pt),
  stroke: 0.5pt + garis-kode, radius: 3pt)[
  #set text(size: 8.5pt)
  #set par(justify: false)
  #text(weight: "bold")[Warna tipe data di kode:]
  #h(0.6em) #contoh-warna("12000", "bulat")
  #h(0.6em) #contoh-warna("0.007", "desimal")
  #h(0.6em) #contoh-warna("\"qris\"", "string")
  #h(0.6em) #contoh-warna("true", "boolean")
  #h(0.6em) #contoh-warna("undefined", "kosong")
  #h(0.6em) #contoh-warna("[3, \"a\"]", "array")
  #h(0.6em) #contoh-warna("[[1, 2], [3, 4]]", "array 2D")
  #h(0.6em) #contoh-warna("hitung(x)", "fungsi") \
  #text(fill: abu-teks)[Bulat dan desimal di JavaScript sama-sama bertipe `number`. Warnanya dibedakan hanya agar mudah dilihat.]
]

#let praktikum(judul: "", modul: "", warna-tipe-data: false, body) = {
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
    fill: rgb("#eff2f6"), inset: (x: 3pt), outset: (y: 2.5pt), radius: 2pt,
    if warna-tipe-data and it.lang == none and it.text.match(pola-lewati) == none { warnai-kode(it.text) } else { it },
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
  if warna-tipe-data { legenda-tipe }
  // Nama tipe di teks biasa (baris Input/Output): miring dan berwarna sesuai tipenya, tanpa tebal.
  // Show rule bersarang tidak bisa membatalkan regex ini di dalam kode, jadi kode ditandai lewat state.
  let dalam-kode = state("dalam-kode", false)
  show raw: it => if not warna-tipe-data { it } else { dalam-kode.update(true); it; dalam-kode.update(false) }
  show regex(`\b(number|string|boolean|array)\b`.text): it => if not warna-tipe-data { it } else {
    context if dalam-kode.get() { it } else {
      let w = (number: warna-tipe.bulat, string: warna-tipe.teks, boolean: warna-tipe.boolean, array: warna-tipe.array)
      text(fill: w.at(it.text), style: "italic", it)
    }
  }
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
#let langkah(isi) = kotak(biru, "➤", "Langkah Mengerjakan", isi)
// Cerita kebutuhan klien di awal setiap tugas soal, sebelum spesifikasi teknis.
#let kebutuhan(isi) = block(width: 100%, above: 0.7em, below: 0.9em, inset: (x: 9pt, y: 7pt),
  fill: luma(246), radius: 3pt)[#text(weight: "bold")[Kebutuhan klien.] #isi]

// Penutup setiap materi HO: tugas soal yang memakai materi itu dan kegunaannya.
#let dipakai(isi) = block(width: 100%, above: 0.9em, below: 1.1em, inset: (left: 8pt, y: 4pt),
  stroke: (left: 2.5pt + hijau))[#text(fill: hijau, weight: "bold")[Dipakai di:] #isi]

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

// Output per tugas, ditaruh langsung di bawah tugasnya.
// #keluaran[`console.log(f(x))`][```txt
// hasil
// ```]
// Blok ```txt dibaca cek-output.sh, jadi isinya harus persis output program.
#let keluaran(panggilan, hasil) = block(width: 100%, above: 0.9em, below: 0.9em, breakable: false)[
  #text(size: 8.5pt, weight: "bold", fill: abu-teks)[Output dari] #panggilan
  #v(-0.5em)
  #hasil
]
