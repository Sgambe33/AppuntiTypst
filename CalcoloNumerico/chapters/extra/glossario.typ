#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()

= Glossario
#let my-section-title(letter, counter) = {
  set align(center + horizon)
  set text(weight: "bold")
  block(width: 100%, height: 1.5em, fill: blue.transparentize(50%), radius: 5pt, breakable: false)[
    #letter
  ]
}

#columns(2)[
  #make-index(
    use-bang-grouping: true,
    section-title: my-section-title,
    section-body: (letter, counter, body) => {
      block(inset: (left: .5em, right: .5em), body)
    },
  )
]
