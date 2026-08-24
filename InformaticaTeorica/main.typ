#import "../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#dvdtyp(
  title: "Appunti Informatica Teorica",
  subtitle: "a.a. 2025-2026",
  cover-image: image("cover.jpg", height: 100%, width: 100%),
)[
  #align(center)[
    Appunti basati sulle lezioni del prof. Ferrari (UniFi), 
    sul libro di Sudkamp (#emph("Languages and Machines"), Addison-Wesley, terza edizione) 
    e sugli appunti di Elena Simionato.
  ]
  #align(center)[ Per contribuire: https://github.com/Sgambe33/AppuntiTypst]
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
