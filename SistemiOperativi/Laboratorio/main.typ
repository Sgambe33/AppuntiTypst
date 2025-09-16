#import "../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#dvdtyp(
  title: "Appunti Sistemi Operativi",
  author: none,
  subtitle: "Laboratorio\nCorso 2024/2025",
  cover-image: image("cover.jpg", height: 100%, width: 100%),
  bottom-logo: image("../../background.png", width: 100%),
)[

  #outline(title: "Contenuti")

  #pagebreak()

  #include "chapters/chapter1/1-shell.typ"


  #pagebreak()
  #columns(2)[
    #make-index(title: "Indice Analitico")
  ]
]
