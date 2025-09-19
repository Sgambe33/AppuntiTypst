#import "../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#dvdtyp(
  title: "Appunti Basi di Dati",
  author: none,
  subtitle: "Corso 2024/2025",
  cover-image: image("cover.jpg", height: 100%, width: 100%),
  bottom-logo: image("../unifi.png", width: 100%),
)[

  #outline(title: "Contenuti")

  #pagebreak()

  #include "chapters/chapter1/1-modello-relazionale.typ"
  #include "chapters/chapter2/2-algebra-relazionale.typ"
  #include "chapters/chapter3/3-dipendenze-funzionali.typ"
  #include "chapters/chapter4/4-modello-er.typ"
  #include "chapters/chapter5/5-progettazione-concettuale.typ"
  #include "chapters/chapter6/6-progettazione-logica.typ"

  #pagebreak()
  #columns(2)[
    #make-index(title: "Indice Analitico")
  ]
]
