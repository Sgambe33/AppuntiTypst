#import "@preview/ctheorems:1.1.3": *
#import "@preview/showybox:2.0.4": showybox

#let colors = (
  rgb("#9E9E9E"),
  rgb("#F44336"),
  rgb("#E91E63"),
  rgb("#9C27B0"),
  rgb("#673AB7"),
  rgb("#3F51B5"),
  rgb("#2196F3"),
  rgb("#03A9F4"),
  rgb("#00BCD4"),
  rgb("#009688"),
  rgb("#4CAF50"),
  rgb("#8BC34A"),
  rgb("#CDDC39"),
  rgb("#FFEB3B"),
  rgb("#FFC107"),
  rgb("#FF9800"),
  rgb("#FF5722"),
  rgb("#795548"),
  rgb("#9E9E9E"),
)

#let dvdtyp(
  title: "",
  subtitle: "",
  author: "",
  abstract: none,
  cover-image: none,
  bottom-logo: none,
  accent: colors.at(6),
  body,
) = {
  set document(title: title, date: auto)

  show: thmrules

  set page(paper: "a4", header: none, footer: none, margin: (top: 0pt, bottom: 0pt, left: 0pt, right: 0pt))
  cover-image

  set heading(numbering: "1.")
  show heading: it => {
    set text(font: "New Computer Modern Sans")
    set par(first-line-indent: 0em)

    if it.numbering != none {
      text(accent, weight: 500)[#sym.section]
      text(accent)[#counter(heading).display() ]
    }
    it.body
  }

  set text(font: "New Computer Modern", lang: "en")
  show math.equation: set text(weight: 400)

  // Title content over the cover image
  if cover-image != none {
    // Full page cover with overlay text
    place(center + horizon)[
      #align(center)[
        #set text(font: "New Computer Modern Sans", fill: white)
        #block(
          fill: rgb(0, 0, 0, 150), // Semi-transparent black background
          inset: 2em,
          radius: 0.5em,
          text(weight: 700, 32pt, title),
        )
        #v(0.4em, weak: true)
        #if subtitle != none [
          #block(fill: rgb(0, 0, 0, 150), inset: 1em, radius: 0.3em, text(20pt, weight: 500)[#subtitle])
        ]
        #v(0.3em, weak: true)
        #if author != none [
          #block(fill: rgb(0, 0, 0, 150), inset: 1em, radius: 0.3em, text(16pt)[by #author])
        ]
      ]
    ]

    place(bottom)[
      #align(center)[
        #bottom-logo
      ]
    ]
  } else {
    // Regular title page without cover image
    set page(margin: auto) // Restore normal margins
    align(center)[
      #set text(font: "New Computer Modern Sans")
      #block(text(weight: 700, 25pt, title))
      #v(0.4em, weak: true)
      #if subtitle != none [#text(18pt, weight: 500)[#subtitle]]
      #v(0.3em, weak: true)
      #if author != none [#text(14pt)[by #author]]
    ]
  }

  if abstract != none [
    #v(2em)
    #align(center)[
      #block(
        fill: if cover-image != none { rgb(255, 255, 255, 200) } else { none },
        inset: if cover-image != none { 1.5em } else { 0em },
        radius: if cover-image != none { 0.5em } else { 0em },
        width: 80%,
        text(fill: if cover-image != none { black } else { auto })[#abstract],
      )
    ]
  ]

  // Move to new page and reset page settings
  pagebreak()

  // Reset page settings for content pages
  set page(background: none, margin: auto, number-align: center, numbering: "1", header: context {
    if here().page() == 1 {
      return none
    }
    box(stroke: (bottom: 0.7pt), inset: 0.4em)[
      #text(font: "New Computer Modern Sans")[#h(1fr)#title]
    ]
  }, footer: none)

  set outline(indent: 1em)
  show outline: set heading(numbering: none)
  show outline: set par(first-line-indent: 0em)

  show outline.entry.where(level: 1): it => {
    text(font: "New Computer Modern Sans", accent)[#strong[#it]]
  }
  show outline.entry: it => {
    text(font: "New Computer Modern Sans", accent)[#it]
  }

  // Main body
  set par(justify: true, first-line-indent: 0em)
  body
}

#let thmtitle(t, color: rgb("#000000")) = {
  text(font: "New Computer Modern Sans", weight: "semibold", fill: color)[#t]
}
#let thmname(t, color: rgb("#000000")) = {
  text(font: "New Computer Modern Sans", fill: color)[(#t)]
}

#let thmtext(t, color: rgb("#000000")) = {
  let a = t.children
  if (a.at(0) == [ ]) {
    a.remove(0)
  }
  t = a.join()

  text(font: "New Computer Modern", fill: color)[#t]
}

#let thmbase(
  identifier,
  head,
  ..blockargs,
  supplement: auto,
  padding: (top: 0em, bottom: 0em),
  namefmt: x => [(#x)],
  titlefmt: strong,
  bodyfmt: x => x,
  separator: [#h(0.1em).#h(0.2em) \ ],
  base: "heading",
  base-level: none,
) = {
  if supplement == auto {
    supplement = head
  }
  let boxfmt(name, number, body, title: auto, ..blockargs_individual) = {
    if not name == none {
      name = [ #namefmt(name) ]
    } else {
      name = []
    }
    if title == auto {
      title = head
    }
    if not number == none {
      title += " " + number
    }
    title = titlefmt(title)
    body = bodyfmt(body)
    pad(..padding, showybox(
      width: 100%,
      radius: 0.3em,
      breakable: true,
      padding: (top: 0em, bottom: 0em),
      ..blockargs.named(),
      ..blockargs_individual.named(),
      [#title#name#titlefmt(separator)#body],
    ))
  }

  let auxthmenv = thmenv(identifier, base, base-level, boxfmt).with(supplement: supplement)

  return auxthmenv.with(numbering: "1.1")
}

#let styled-thmbase = thmbase.with(titlefmt: thmtitle, namefmt: thmname, bodyfmt: thmtext)

#let builder-thmbox(color: rgb("#000000"), ..builderargs) = styled-thmbase.with(
  titlefmt: thmtitle.with(color: color.darken(30%)),
  bodyfmt: thmtext.with(color: color.darken(70%)),
  namefmt: thmname.with(color: color.darken(30%)),
  frame: (body-color: color.lighten(92%), border-color: color.darken(10%), thickness: 1.5pt, inset: 1.2em, radius: 0.3em),
  ..builderargs,
)

#let builder-thmline(color: rgb("#000000"), ..builderargs) = styled-thmbase.with(
  titlefmt: thmtitle.with(color: color.darken(30%)),
  bodyfmt: thmtext.with(color: color.darken(70%)),
  namefmt: thmname.with(color: color.darken(30%)),
  frame: (
    body-color: color.lighten(92%),
    border-color: color.darken(10%),
    thickness: (left: 2pt),
    inset: 1.2em,
    radius: 0em,
  ),
  ..builderargs,
)

#let problem-style = builder-thmbox(color: colors.at(16), shadow: (offset: (x: 2pt, y: 2pt), color: luma(70%)))

#let problem = problem-style("problem", "Problem")

#let theorem-style = builder-thmbox(color: colors.at(6), shadow: (offset: (x: 3pt, y: 3pt), color: luma(70%)))

#let theorem = theorem-style("theorem", "Theorem")

#let lemma = theorem-style("lemma", "Lemma")
#let corollary = theorem-style("corollary", "Corollary")

#let definition-style = builder-thmline(color: colors.at(8))

#let definition = definition-style("definition", "Definizione")
#let proposition = definition-style("proposition", "Proposizione")
#let remark = definition-style("remark", "Nota")
#let observation = definition-style("observation", "Osservazione")

#let example-style = builder-thmline(color: colors.at(16))

#let example = example-style("example", "Example").with(numbering: none)

#let proof(body, name: none) = {
  thmtitle[Dimostrazione]
  if name != none {
    [ #thmname[#name] ]
  }
  thmtitle[.]
  body
  h(1fr)
  $square$
}