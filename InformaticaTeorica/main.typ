#import "../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#dvdtyp(
  title: "Appunti Informatica Teorica",
  subtitle: "a.a. 2025-2026",
  cover-image: image("cover.jpg", height: 100%, width: 100%),
)[

  #align(center, "Appunti basati su note prese a lezione, sul libro di Sudkamp e sugli appunti di Elena Simionato.")
  #outline(title: "Contenuti")

  #pagebreak()

  #include "chapters/chapter1/1-introduzione.typ"
  #include "chapters/chapter2/2-turing.typ"
  #include "chapters/chapter3/3-complessita.typ"

  #pagebreak()
  #columns(2)[
    #make-index(title: "Indice Analitico")
  ]
]
