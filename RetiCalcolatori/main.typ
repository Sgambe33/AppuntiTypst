#import "@preview/in-dexter:0.7.2": *
#import "../dvd.typ": *

#dvdtyp(
  title: "Appunti Reti di Calcolatori",
  author: none,
  subtitle: "Teoria\nCorso 2025/2026",
  cover-image: image("cover.jpg", height: 100%, width: 100%)
)[
  #outline(title: "Contenuti")

  #pagebreak()

  #include "chapters/chapter1/1-introduzione.typ"

  #pagebreak()

  #columns(2)[
    #make-index(title: [Indice Analitico], outlined: true, use-page-counter: true)
  ]
]