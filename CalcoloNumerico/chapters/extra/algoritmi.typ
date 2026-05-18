#import "../../../dvd.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
)

#pagebreak()

= Algoritmi
== Metodo di bisezione
#let bisezione-data = read("scriptMATLAB/metodo_bisezione.m")
#let metodo-bisezione = [
  #codly(header: [Metodo di bisezione])
  #raw(block: true, lang: "matlab", bisezione-data)
]

#metodo-bisezione

#pagebreak()

== Metodo di Newton
#let newton-data = read("scriptMATLAB/metodo_newton.m")
#let metodo-newton = [
  #codly(header: [Metodo di Newton])
  #raw(block: true, lang: "matlab", newton-data)
]

#metodo-newton

#pagebreak()

== Metodo di Newton modificato
#let newton-modificato-data = read("scriptMATLAB/metodo_newton_modificato.m")
#let metodo-newton-modificato = [
  #codly(header: [Metodo di Newton modificato])
  #raw(block: true, lang: "matlab", newton-modificato-data)
]

#metodo-newton-modificato

#pagebreak()

== Metodo di Aitken
#let aitken-data = read("scriptMATLAB/metodo_aitken.m")
#let metodo-aitken = [
  #codly(header: [Metodo di Aitken])
  #raw(block: true, lang: "matlab", aitken-data)
]

#metodo-aitken

#pagebreak()

== Metodo delle secanti
#let secanti-data = read("scriptMATLAB/metodo_secanti.m")
#let metodo-secanti = [
  #codly(header: [Metodo delle secanti])
  #raw(block: true, lang: "matlab", secanti-data)
]

#metodo-secanti

#pagebreak()

== Metodo delle corde
#let corde-data = read("scriptMATLAB/metodo_corde.m")
#let metodo-corde = [
  #codly(header: [Metodo delle secanti])
  #raw(block: true, lang: "matlab", corde-data)
]

#metodo-corde

#pagebreak()

== Sistema triangolare
#let trisolve-data = read("scriptMATLAB/trisolve.m")
#let trisolve = [
  #codly(header: [Sistemi triangolari])
  #raw(block: true, lang: "matlab", trisolve-data)
]

#trisolve

#pagebreak()

== Fattorizzazione LU
#let fatt-lu-data = read("scriptMATLAB/fattorizza_lu.m")
#let fatt-lu = [
  #codly(header: [Fattorizzazione LU])
  #raw(block: true, lang: "matlab", fatt-lu-data)
]

#fatt-lu

#pagebreak()

== Fattorizzazione LU con pivoting parziale
#let fatt-plu-data = read("scriptMATLAB/fattorizza_plu.m")
#let fatt-plu = [
  #codly(header: [Fattorizzazione con pivoting parziale])
  #raw(block: true, lang: "matlab", fatt-plu-data)
]

#fatt-plu

#pagebreak()

== LU Solver
#let lusolve-data = read("scriptMATLAB/LUsolve.m")
#let lusolve = [
  #codly(header: [Risoluzione sistema con matrice LU])
  #raw(block: true, lang: "matlab", lusolve-data)
]

#lusolve

#pagebreak()

== $L D L^T$ Solver
#let ldl-solve-data = read("scriptMATLAB/LDLsolve.m")
#let ldl-solve = [
  #codly(header: [Risoluzione sistema con matrice LDL])
  #raw(block: true, lang: "matlab", ldl-solve-data)
]

#ldl-solve

#pagebreak()

== Fattorizzazione QR (Householder)
#let fatt-qr-data = read("scriptMATLAB/fattorizza_qr.m")
#let fatt-qr = [
  #codly(header: [Fattorizzazione QR (metodo Householder)])
  #raw(block: true, lang: "matlab", fatt-qr-data)
]

#fatt-qr
