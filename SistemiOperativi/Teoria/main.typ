#import "@preview/dvdtyp:1.0.1": dvdtyp

#show: dvdtyp.with(
  title: "Appunti Sistemi Operativi",
  author: "Cosimo Sgambelluri"
)

#outline(title: "Contenuti")

#include "chapters/chapter1/1-concettiintroduttivi.typ"

#include "chapters/chapter2/2-processi-thread.typ"

#include "chapters/chapter3/3-scheduling-cpu.typ"

#include "chapters/chapter4/4-stallo.typ"

#include "chapters/chapter5/5-gestione-memoria.typ"

#include "chapters/chapter6/6-filesystem.typ"

#include "chapters/chapter7/7-dispositivi-io.typ"