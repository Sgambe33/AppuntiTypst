#import "../dvd.typ": *

#dvdtyp(
  title: "Appunti Interpreti e Compilatori",
  author: none,
  subtitle: "Teoria\nCorso 2025/2026",
  cover-image: image("cover.jpg", height: 100%, width: 100%),
  bottom-logo: image("../unifi.png", width: 100%),
)[
  #outline(title: "Contenuti")

  #pagebreak()

  #include "chapters/chapter1/1-introduzione.typ"
  #include "chapters/chapter2/2-analisi-lessicale.typ"
]
