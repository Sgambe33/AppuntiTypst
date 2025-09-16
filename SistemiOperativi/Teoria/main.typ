#import "../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#dvdtyp(
  title: "Appunti Sistemi Operativi",
  author: none,
  subtitle: "Teoria\nCorso 2024/2025",
  cover-image: image("cover.jpg", height: 100%, width: 100%),
  bottom-logo: image("../../background.png", width: 100%),
)[

  #outline(title: "Contenuti")

  #pagebreak()

  #include "chapters/chapter1/1-concettiintroduttivi.typ"

  #include "chapters/chapter2/2-processi-thread.typ"

  #include "chapters/chapter3/3-scheduling-cpu.typ"

  #include "chapters/chapter4/4-stallo.typ"

  #include "chapters/chapter5/5-gestione-memoria.typ"

  #include "chapters/chapter6/6-filesystem.typ"

  #include "chapters/chapter7/7-dispositivi-io.typ"

  #pagebreak()
  #columns(2)[
    #make-index(title: "Indice Analitico")
  ]
]
