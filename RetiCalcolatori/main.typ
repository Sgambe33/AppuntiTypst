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

  #include "chapters/chapter1/01-introduzione.typ"
  #include "chapters/chapter2/02-livello-applicativo.typ"
  #include "chapters/chapter3/03-livello-trasporto.typ"
  #include "chapters/chapter4/04-tcp.typ"
  #include "chapters/chapter5/05-nat-network-address-translation.typ"
  #include "chapters/chapter6/06-ipv6.typ"
  #include "chapters/chapter7/07-sicurezza-delle-reti-cybersecurity.typ"
  #include "chapters/chapter8/08-il-routing.typ"

  #pagebreak()

  #columns(2)[
    #make-index(title: [Indice Analitico], outlined: true, use-page-counter: true)
  ]
]
