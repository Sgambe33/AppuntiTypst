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

///////////////////////////////////////////////////////////////
#pagebreak()

== Algoritmo di Horner
#let horner-data = read("scriptMATLAB/horner.m")
#let horner = [
  #codly(header: [Algoritmo di Horner])
  #raw(block: true, lang: "matlab", horner-data)
]

#horner

///////////////////////////////////////////////////////////////
#pagebreak()

== Algoritmo di Horner-Newton
#let horner_newton-data = read("scriptMATLAB/horner_newton.m")
#let horner_newton = [
  #codly(header: [Algoritmo di Horner-Newton])
  #raw(block: true, lang: "matlab", horner_newton-data)
]

#horner_newton

///////////////////////////////////////////////////////////////
#pagebreak()

== Ascisse di Chebyshev
#let ascisse_chebyshev-data = read("scriptMATLAB/ascisse_chebyshev.m")
#let ascisse_chebyshev = [
  #codly(header: [Ascisse di Chebyshev ])
  #raw(block: true, lang: "matlab", ascisse_chebyshev-data)
]

#ascisse_chebyshev

///////////////////////////////////////////////////////////////
#pagebreak()

== Sistema tridiagonale
#let tridiag-data = read("scriptMATLAB/tridiag.m")
#let tridiag = [
  #codly(header: [Sistema tridiagonale])
  #raw(block: true, lang: "matlab", tridiag-data)
]

#tridiag

///////////////////////////////////////////////////////////////
#pagebreak()

== Formula trapezi composita
#let trapezi_composita-data = read("scriptMATLAB/trapezi_composita.m")
#let trapezi_composita = [
  #codly(header: [Formula trapezi composita])
  #raw(block: true, lang: "matlab", trapezi_composita-data)
]

#trapezi_composita

///////////////////////////////////////////////////////////////
#pagebreak()

== Formula trapezi adattiva
#let trapezi_adattiva-data = read("scriptMATLAB/trapezi_adattiva.m")
#let trapezi_adattiva = [
  #codly(header: [Formula trapezi adattiva])
  #raw(block: true, lang: "matlab", trapezi_adattiva-data)
]

#trapezi_adattiva

///////////////////////////////////////////////////////////////
#pagebreak()

== Formula Simpson composita
#let simpson_composita-data = read("scriptMATLAB/simpson_composita.m")
#let simpson_composita = [
  #codly(header: [Formula Simpson composita])
  #raw(block: true, lang: "matlab", simpson_composita-data)
]

#simpson_composita

///////////////////////////////////////////////////////////////
#pagebreak()

== Formula Simpson adattiva
#let simpson_adattiva-data = read("scriptMATLAB/simpson_adattiva.m")
#let simpson_adattiva = [
  #codly(header: [Formula Simpson adattiva])
  #raw(block: true, lang: "matlab", simpson_adattiva-data)
]

#simpson_adattiva

///////////////////////////////////////////////////////////////