#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *

= Macchine di Turing

// TODO: Fare il disegno del nastro
La macchina di Turing è un modello di calcolo che serve a descrivere il concetto di algoritmo. Ha le seguenti caratteristiche:
- È composta da un *nastro unidimensionale* infinito, sia da destra che da sinistra.
- Il nastro è diviso in *celle* che possono contenere informazioni.
- Le informazioni che si possono scrivere sul nastro sono *simboli* da un *alfabeto finito $Sigma$* definito inizialmente. Questo alfabeto contiene sempre un *simbolo privilegiato (\*)* che serve per denotare una *cella vuota* ed è normalmente implicito e non scritto tra i simboli dell'alfabeto.
- C'è una *testina* che si occupa della *lettura/scrittura*, spostandosi a destra e a sinistra, indicando una cella ad ogni spostamento. Ogni spostamento della testina è definito *passo di calcolo* o *transizione*.
- La macchina ha un insieme di stati di memoria _Q_ = {$q_0, q_1, dots, q_n$}. Lo stato $q_0$ è chiamato stato iniziale e in seguito a una *transizione*, la macchina può cambiare stato.

Una transizione è una quadrupla i cui primi due elementi determinano una *configurazione*. Una tipica transizione in *MdT* è la seguente:
$
  Q times Sigma times (Sigma union {D, S}) times Q in.rev & (overbracket(q\, x, "configurazione"), alpha, accent(q, ~)) \
                                                   "Con:" & q in Q, x in Sigma, alpha in Sigma, accent(q, ~) in Q \
                                   "Funzionale nei primi" & " 2 argomenti"
$

#definition()[
  Una *macchina di Turing* è un sottoinsieme dell'insieme: $ Q times Sigma times (Sigma union {D, S}) times Q $
  cioè è una lista di transizioni (cioè una lista di quadruple funzionali nei primi 2 argomenti).
]

#example(multiple: true)[
  // TODO: AGGIUNGERE DISEGNI ESEMPI DEI NASTRI
  1)  #block($ quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ")q_1\
  &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\ $)

  2) #block($ quad space &q_0 && * && D space && q_0 text(": Se la cella corrente è vuota, la testina si sposta a destra e non cambia stato")\
  &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
  &q_1 && 1 && D && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra, scrivo 1 e non")\ & && && && quad quad text("cambia stato")\ $)

  3) #block($ quad space &q_0 && * && 1 space && q_0 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
  &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
  &q_1 && * && 1 && q_1 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
  &q_1 && 1 && 1 && q_0 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_0 $)

  4) #block($ quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a") q_1\
  &q_1 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ")\
  &q_1 && * && 1 && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ")q_2\
  &q_2 && 1 && S && q_2 text(": Se la cella corrente è 1, la testina si sposta a sinistra e non cambia lo stato") $)
]

#definition()[
  Una Macchina di Turing (MdT) _M_ calcola una funzione $f: Sigma^* -> Sigma^*$ quando, scritta una stringa $w in Sigma^*$ sul nastro e posta la testina di _M_ sulla prima cella vuota a sinistra di _w_, dopo l'esecuzione di _M_ su _w_, la testina si trova nella prima cella vuota a sinistra di $f(w)$.
]

#example()[
  Creiamo una MdT che calcola la somma di due numeri naturali scritti in codifica unaria (con il simbolo $1$). I numeri scelti nell'esempio sono 2 e 3:
  #figure(image("./images/image-2.png", width: 50%))

  // TODO: rifare l'immagine
  #block(
    $
      quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ") q_1\
      &q_1 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ")\
      &q_1 && * && 1 && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ")q_2\
      &q_2 && 1 && D && q_2 text(": Se la cella corrente è 1, la testina si sposta a destra e non cambia lo stato")\
      &q_2 && * && S && q_3 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ")q_3\
      &q_3 && 1 && * && q_3 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato")\
      &q_3 && * && S && q_4 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ")q_4\
      &q_4 && 1 && * && q_4 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato")\
      &q_4 && * && S && q_5 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a "q_5)
    $,
  )
]

// TODO: Rifare
- Caso di #underline("una singola stringa in input:")
#image("./images/image.png")
- Caso di #underline("input composto da più stringhe:")
#image("./images/image-1.png")

#definition()[
  Una funzione $f: NN^k -> NN$ si dice *$tau$-ricorsiva* quando $exists M$ MdT che calcola $f$
]

== Tesi di church (per le funzioni $tau$-ricorsive)
La classe delle funzioni computabili coincide con la classe delle funzioni $tau$-ricorsive.

// TODO:AGGIUNGERE IMMAGINI
#example(multiple: true)[
  + MDT che, data una stringa su {a, b}, scambia le 'a' con le 'b'. Rappresentazione grafica di una MDT: \
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,

      node((0, 0), $q$, name: <qs>),
      node((3, 0), $accent(q, ~)$, name: <qf>),
      node((-1, 0), [*$q x alpha accent(q, ~)$*], stroke: 0pt),

      edge(<qs>, <qf>, "-|>", $x \/ alpha$),


      node((0, 2), $q_0$, name: <0>),
      node((3, 2), $q_1$, name: <1>),
      node((6, 2), $q_2$, name: <2>),

      edge(<0>, <1>, "-|>", $* \/ D$),
      edge(<1>, <2>, "-|>", $b \/ a \ a \/ b$, bend: 30deg),
      edge(<2>, <1>, "-|>", $a, b \/ D$, bend: 30deg),
    ))
  + MDT che scrive la copia di una stringa unaria. Simbolo aggiuntivo (di lavoro): X
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,

      node((-3, 0), $q_0$, name: <0>),
      node((0, 0), $q_1$, name: <1>),
      node((2, 2), $q_2$, name: <2>),
      node((0, 4), $q_3$, name: <3>),
      node((-2, 2), $q_4$, name: <4>),
      node((3, 0), $q_5$, name: <5>),

      edge(<0>, <1>, "-|>", $* \/ D$),
      edge(<1>, <2>, "-|>", $1 \/ X$),
      edge(<2>, <2>, "-|>", $X, 1 \/ D$, bend: 130deg, loop-angle: 0deg),
      edge(<2>, <3>, "-|>", $* \/ D$, label-anchor: "north-west"),
      edge(<3>, <3>, "-|>", $1 \/ D$, bend: 130deg, loop-angle: -90deg),
      edge(<3>, <4>, "-|>", $* \/ 1$, label-anchor: "north-east"),
      edge(<4>, <4>, "-|>", $1, * \/ S$, bend: 130deg, loop-angle: 180deg),
      edge(<4>, <1>, "-|>", $X \/ D$),
      edge(<1>, <5>, "-|>", $* \/ S$),
    ))
]

----------------------------

// Esercizio esame della lezione prima
#block()[$
  & f: NN -> NN, R subset.eq NN^k "rp" \
  & "Definisco " S subset.eq NN^k "ponendo" arrow(x) in S " quando " (f(x_1), dots, f(x_k)) in R \
  & "Dimostra che S rp": \
  & cal(chi)_S (arrow(x))=cal(chi)_R compose (f compose epsilon_1^(k), dots, f compose epsilon_k^(k))(arrow(x))
$]

== MDT come accettatori di linguaggi
=== Accettazione per stati finali
Accettazione di una stringa per stati finali:
- $Q$: insieme degli stati di una MDT
- $F subset.eq Q$: insieme degli stati finali

#definition()[
  _M_ accetta la stringa  _w_ *per stati finali* quando l'esecuzione di _M_ su input _w_ termina in uno stato finale.
]
#definition()[
  $L subset.eq Sigma^*$ si dice *accettato per stati finali* da una MDT _M_ quando $w in L$ sse _M_ accetta _w_ per stati finali $--> L = L(M)$
]
#definition()[
  Se _L_ è t.c. $exists M$ MDT per cui $L = L(M)$ (_L_ è il linguaggio delle M), _L_ si dice *ricorsivamente enumerabile*
]

#observation()[
  Se _M_ è una MDT che termina su ogni input, allora $L(M)$ si dice *ricorsivo*

  #block(
    $
      #underline("Via tesi di church"): & bold("ric. enum." <--> "semidecidibile") \
                                        & bold("ricorsivo" <--> "decidibile")
    $,
  )
]


#example(multiple: true)[
  + MDT che accetta il linguaggio $(a|b)^* a a(a|b)^*$
    $
      #grid(
        columns: 14,
        rows: 1,
        stroke: .5pt,
        inset: 5pt,
        [\*],
        [b],
        [b],
        [b],
        [a],
        [b],
        [b],
        [a],
        [
          #place(top + center, dy: -20pt)[
            #set text(size: 8pt)
            #stack(dir: ttb, spacing: 2pt, $q_3$, sym.triangle.b.small)
          ]
          a
        ],
        [b],
        [a],
        [a],
        [a],
        [b],
      )\
      #grid(
        columns: (0.025fr, 0.6fr, 0.3fr, 0.075fr),
        rows: 2,
        stroke: none,
        [],
        grid.cell(rowspan: 2, diagram(
          node-stroke: 0.9pt,
          cell-size: 5mm,
          spacing: 3mm,

          node((0, 0), $q_0$, name: <0>),
          node((2, 0), $q_1$, name: <1>),
          node((4, 0), $q_2$, name: <2>),
          node((6, 0), $q_3$, name: <3>, extrude: (-2, 0)),

          edge(<0>, <1>, "-|>", $*\/D$),
          edge(<1>, <1>, "<|-", bend: 130deg, $b\/D$, loop-angle: 70deg, label-anchor: "south-east", label-pos: 60%),
          edge(<1>, <2>, "-|>", bend: 30deg, $a\/D$),
          edge(<2>, <1>, "-|>", bend: 30deg, $b\/D$),
          edge(<2>, <3>, "-|>", $a\/a$),
        )),
        grid.cell(rowspan: 2, align: (left + horizon), $ & Q = {q_0, q_1, q_2, q_3} \
        \
        & F = {q_3} $),
      )
    $
  //#image("/assets/image.png")
  + MdT che accetta il linguaggio ${a^i b^i c^i | i >= 0} subset.eq {a, b, c}^*$
    #grid(
      rows: 4,
      columns: (8pt, .4fr, .6fr),
      [],
      grid.cell([
        #grid(
          columns: 10,
          stroke: .5pt,
          inset: 5pt,
          [\*], [a], [a], [a], [b], [b], [b], [c], [c], [c],
        )
      ]),
      grid.cell(rowspan: 4, align: center + horizon, diagram(
        node-stroke: 0.9pt,
        cell-size: 1mm,
        node-inset: 4pt,
        spacing: 3mm,
        label-size: 7.5pt,

        node((2, 0), $q_0$, name: <0>),
        node((4, 0), $q_1$, name: <1>),
        node((6, 0), $q_2$, name: <2>),
        node((8, 0), $q_3$, name: <3>),
        node((8, 3), $q_4$, name: <4>),
        node((6, 3), $q_5$, name: <5>),
        node((4, 3), $q_6$, name: <6>),
        node((1, 3), $q_7$, name: <7>),
        node((1, 6), $q_8$, name: <8>, extrude: (-2, 0)),

        edge(<0>, <1>, "-|>", $*\/D$, bend: 30deg),
        edge(<1>, <1>, "-|>", $a\/x$, bend: 130deg),
        edge(<1>, <2>, "-|>", $x\/D$, label-side: right),
        edge(<1>, <7>, "-|>", $y\/D$, bend: -15deg, label-pos: 65%),
        edge(<1>, <8>, "-|>", $*\/*$, bend: -20deg, label-side: left, label-pos: 65%),
        edge(<2>, <2>, "-|>", $x\/D$, bend: 130deg),
        edge(<2>, <3>, "-|>", $b\/y$, label-side: right),
        edge(<3>, <4>, "-|>", $y\/D$, label-side: left),
        edge(<4>, <4>, "-|>", $b\/D$, bend: -130deg, loop-angle: 135deg),
        edge(<4>, <5>, "-|>", $c\/z$),
        edge(<5>, <6>, "-|>", $z\/S$),
        edge(<6>, <6>, "-|>", $a, b, y, z\/S$, bend: -130deg),
        edge(<6>, <1>, "-|>", $x\/D$, label-side: left),
        edge(<7>, <7>, "-|>", $y, z\/D$, bend: 130deg, loop-angle: 180deg),
        edge(<7>, <8>, "-|>", $*\/*$),
      )),
      [$$], [],
      [],
      grid.cell([
        #grid(
          columns: 10,
          stroke: .5pt,
          inset: 5pt,
          [\*], [x], [x], [x], [y], [y], [y], [z], [z], [z],
        )
      ]),
      // TODO: chiedere a Lorenzi se è errore o altro
      [$$],
      grid.cell(
        align: bottom + left,
        [L'importante è che ad ogni errore corrisponda uno stato, non che ogni stato preveda errori $->$ la macchina è costruita per andare avanti soltanto se tutto funziona],
      ),
    )
]

=== Accettazione per arresto
#definition()[
  Una MdT M accetta per arresto quando M, eseguita su _w_, termina.
]
L'insieme delle stringhe accettate da M per arresto è il *linguaggio* accettato da M per arresto

#proposition()[
  Dato un linguaggio L:
  #grid(
    columns: (0.15fr, 100pt, 40pt, 100pt, 0.15fr),
    align: (right, right, center + horizon, left, left),
    [], [$exists$ MdT M che accetta L per stati finali], [$<==>$], [$exists$ MdT M che accetta L per arresto], [],
  )
]

#proof()[
  \ $<==)$ Sia N MdT che accetta L per arresto. La MdT ottenuta da N, designando ogni stato come finale, è una MdT che accetta L per stati finali.
  \ $==>)$ M MdT che accetta L per stati finali. Su input _w_ ci sono 3 casi:
  - M termina su uno stato finale (OK, anche per arresto)
  - M non termina (OK, non accettata in entrambi i modi)
  - M termina ma in uno stato non finale: costruiamo una MdT N in questo modo. N ha le stesse transizioni di M più le seguenti:
    + $forall q in Q \\ F, forall x in Sigma t.c.$ non ci sono transizioni di M con $underbrace("configurazione", "coppia(stato, simbolo)")$ $q x$, aggiungiamo le transizioni $q x x accent(q, ~)$, $accent(q, ~) x x accent(q, ~)$ (dove $accent(q, ~)$ è un nuovo stato).

  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    label-size: 10pt,

    node((0, 0), $q$, name: <0>),
    node((3, 0), $accent(q, ~)$, name: <1>),

    edge(<0>, <1>, "-|>", $x\/x$),
    edge(<1>, <1>, "-|>", $x\/x$, bend: 130deg, loop-angle: 0deg),
  ))
]

#example(multiple: true, "Esercizi esame")[
  + L è accetato per *unico stato finale* quando $exists M$ MdT con un solo stato finale che accetta L. Dimostrare L accettato per stati finali *sse* L è accettato pre unico stato finale.
    \ Risposta:
    \ $<==)$ Ovvio,
    \ $==>)$ M MdT che accetta L per stati finali. Costruiamo N aggiugendo un nuovo stato $accent(q, ~)$ che M raggiungerà ogni volta che termina in uno stato finale (insoltr $accent(q, ~)$ sarà l'unico stato finale di N).

  + M accetta _w_ *per ingresso* quando, durante l'esecuzione di M su un input _w_, la MdT centra in uno stato finale. Un linguaggio L è accettato da M per ingresso quando $exists$ M MdT  che accetta tutte e sole le stringhe di L per ingresso.
    \ DIM che L è accettato per stati finali sse L è accettato per ingresso.
]

// Lezione 11/03/26
#definition()[
  _L_ accettato per stati finali $<==>$ L accettato per ingresso
]
#proof()[
  \ $==>$ M MDT che accetta _L_ per stati finali.\
  M'  che accetta per ingresso si costruisce a partire da M, aggiungendo un nuovo stato $tilde(q)$ (che sarà l'unico stato finale) e transizioni che portano in $tilde(q)$ da ogni stato finale in corrispondenza a caratteri per cui non ci sono transizioni uscenti in M.

  $<==$ M MDT che accetta _L_ per ingresso.\
  M' MDT che accetta L per stai finali is ottiene da M eliminando tutte le transizioni uscenti dagli stati finali.
]

== MDT multitraccia

#definition()[
  MDT multitraccia con:
  - $Sigma$ alfabeto
  - $Q$ insieme degli stati

  Possiamo definirla come una lista di transizioni della forma (con k = numero tracce):
  $
    underbrace(q, Q), underbrace((x_1, dots, x_n), Sigma^k), underbrace(alpha, (Sigma^k union {D, S})), underbrace(accent(q, ~), Q)
  $
]

#proposition()[
  Fissato un $k in NN$, un linguaggio L è accettato da una MdT multitraccia $<==>$ L è accettato da una MdT a k-tracce
]
#proof()[
  \ $<==)$ Ovvio. Posso simulare una MdT con una tracia usando una MdT con k-tracce in cui ignoro (cioè lascio vuoto) il contenuto di tutte le tracce tranne la prima).
  \ $==>)$ M MdT a k-tracce che accetta L, posso ottenere una MdT M' che accetta L a una traccia semplicemente sostituendo l'alfabeto $Sigma$ di M con $Sigma^k$, eseguendo  le medesime transizioni (Se in M si legge, dal basso verso l'alto, a, b, a, \*, a in 5 celle diverse, in M' si leggerà la quintupla (a, b, a, \*, a) in una sola cella)
]

== MDT limitata a sinistra

#definition()[
  MdT *limitata a sinistra*
  #figure(image("images/2026-03-11-12-08-24.png"))
  possiamo usare MdT limitate a sinistra per accettare stringhe nello stesso modo di quelle classiche, con l'accortezza che un'operazione di spostamento a sinistra a partire dalla prima cella causa il rifiuto della stringa. *Da ora in poi, quando si parla di MdT standard si fa riferimento a questo tipo di MdT.*
]

#proposition()[
  Un linguaggio $L$ è accettato da una _MdT_ classica $<==>$ $L$ è accettato da una _MdT_ con nastro limitato a sinistra.
]
#proof()[
  $<==)$ Sia $M'$ una _MdT_ con nastro limitato a sinistra. Per simulare una computazione di $M'$ usando una _MdT_ classica, possiamo scrivere sul nastro un particolare simbolo, per esempio \#, che indichi che tale cella è quella iniziale. Quando una computazione di questa _MdT_ cerca di portare la testina a sinistra di tale simbolo, facciamo in modo che un'altra computazione faccia terminare la _MdT_ rifiutando la stringa.
  #figure(image("images/2026-03-11-12-09-22.png"))

  $==>)$ Sia $M'$ una _MdT_ standard. Consideriamo una _MdT_ $M'$ con nastro  limitato a sinistra che abbia due tracce. Per  simulare una computazione di $M'$ u $M'$,  si considera il nastro di $M'$ (che è infinito  sia a destra che a sinistra) e si assegna alla prima cella vuota a sinistra della stringa in  input la posizione 0. A sinistra di tale  posizione avremo una numerazione  negativa delle celle, mentre alla sua destra  le celle avranno una numerazione  crescente positiva.
  #figure(image("images/2026-03-11-12-11-42.png"))

  Possiamo sistemare il  contenuto a destra della posizione 0 nella prima traccia della _MdT_ $M'$,  mentre nella seconda traccia ci sarà l'eventuale contenuto delle celle a  sinistra della posizione 0.
  #figure(image("images/2026-03-11-12-12-01.png"))

  In questo modo, a una transizione di $M'$ che  fa spostare la testina a sinistra della posizione 0 corrisponde una  transizione di $M'$ che fa spostare la testina sulla seconda traccia. Spostamenti verso sinistra sono quindi convertiti in spostamenti verso destra e viceversa.
]

== MDT multinastro

#definition()[
  Una Macchina di Turing multinastro è una _MdT_ che opera su più nastri di lettura/scrittura indipendenti tra di loro, con una testina per ogni nastro.
  #figure(image("images/2026-03-11-12-29-21.png"))

  La tipica transizione di una _MdT_ multinastro è:
  $
    q_i (x_1, … , x_k) (alpha_1, … , alpha_k) q_j --> cases("con" alpha_i in Sigma "operazione di scrittura, oppure", alpha_i in {D,S} "operazione di spostamento")
  $
  E quindi $Q times Sigma^k times (Sigma union {D,S})^k times Q$
]

#proposition()[
  Un linguaggio $L$ è accettato da una _MdT_ standard $<==>$ $L$ è accettato da una _MdT_ multinastro con $k$ nastri.
]
#proof()[

  $==>)$ Ovvio, basta ignorare i nastri in eccesso.

  $<==)$ M MdT a $k$ nastri che accetta L, facciamo vedere che esiste una MdT M' a $2k+1$ tracce che accetta L. Più precisamente facciamo vedere che ogni singola transizione di una computazione di M può essere simulata da un gruppetto di transizioni di M'.

  Poniamo $k=2$. Vogliamo cercare di simulare una singola transizione di _MdT_ $M'$ a 2 nastri con un gruppetto di transizioni di una _MdT_ $M'$ a 5 tracce (perché 5 = 2k + 1 con k = 2).
  #figure(image("images/2026-03-11-12-41-50.png"))

  - Le tracce 1 e 3 rappresentano il contenuto dei nastri 1 e 2 di $M'$ rispettivamente;
  - Le tracce 2 e 4 rappresentano la posizione della testina nei nastri 1 e 2 di $M'$, rispettivamente (la cella corrispondente alla posizione della testina contiene un particolare simbolo, per es. x);
  - La traccia 5 contiene nella prima posizione il solo simbolo \#, che serve per riposizionare la testina a inizio nastro.

  1. Prima vengono raccolte tutte le informazioni, riguardanti le celle lette sui due nastri (e memorizzate, ad esempio, utilizzando un opportuno insieme di stati)
  2. Cerca sul nastro 2 il simbolo x, che corrisponde alla posizione della testina del nastro 1; o
  3. Legge sul nastro 1 il simbolo nella cella la cui posizione è indicata dalla x sul nastro 2 e compie l'operazione di scrittura, se deve, altrimenti compie l'operazione di spostamento della testina operando sul nastro 2 e riscrivendo la x in della sua nuova posizione;
  4. Torna all'inizio dei nastri sfruttando il nastro 5, ovvero quando legge il simbolo \# si ferma (perché tale simbolo indica l'inizio dei nastri);
  5. Cerca sul nastro 4 il simbolo x, che corrisponde alla posizione della testina del nastro 3;
  6. Legge sul nastro 3 il simbolo nella cella la cui posizione è indicata dalla x sul nastro 4 e compie l'operazione di scrittura, se deve, altrimenti compie l'operazione di spostamento della testina operando sul nastro 4 e riscrivendo la x in corrispondenza della sua nuova posizione;
  7. Torna all'inizio dei nastri
]

#example()[
  //TODO: sto esempio è da rivedere
  L'insieme ${a^k | k " è un quadrato perfetto"}$ è un linguaggio ricorsivamente enumerabile. Viene presentato il progetto di una macchina a tre nastri che accetta questo linguaggio. Il nastro 1 contiene la stringa di input. L'input viene confrontato con una stringa di $X$ sul nastro 2 la cui lunghezza è un quadrato perfetto. Il nastro 3 contiene una stringa la cui lunghezza è la radice quadrata della stringa sul nastro 2. La configurazione iniziale per una computazione con input $a a a a a$ è:

  #figure(image("images/2026-03-11-16-11-57.png", width: 50%))

  I valori di $k$ e $k^2$ vengono incrementati finché la lunghezza della stringa sul nastro 2 è maggiore o uguale alla lunghezza dell'input. Una macchina per eseguire questi confronti consiste nelle seguenti azioni:

  + Se l'input è la stringa vuota, la computazione si ferma in uno stato di accettazione. Altrimenti, i nastri 2 e 3 vengono inizializzati scrivendo $X$ in posizione uno. Le tre testine dei nastri vengono poi spostate in posizione uno.

  + Il nastro 3 ora contiene una sequenza di $k$ simboli $X$ e il nastro 2 contiene $k^2$ simboli $X$. Contemporaneamente, le testine sui nastri 1 e 2 si spostano verso destra mentre entrambe scansionano celle non vuote. La testina che legge il nastro 3 rimane in posizione uno.
    a) Se entrambe le testine leggono contemporaneamente un simbolo vuoto, la computazione si ferma e la stringa viene accettata.
    b) Se la testina del nastro 1 legge un simbolo vuoto e la testina del nastro 2 una $X$, la computazione si ferma e la stringa viene rifiutata.

  + Se non si verifica nessuna delle condizioni di arresto, i nastri vengono riconfigurati per il confronto con il quadrato perfetto successivo.\
    a) Una $X$ viene aggiunta all'estremità destra della stringa di $X$ sul nastro 2.\
    b) Due copie della stringa sul nastro 3 vengono aggiunte all'estremità destra della stringa sul nastro 2. Questo costruisce una sequenza di $(k + 1)^2$ simboli $X$ sul nastro 2.\
    c) Una $X$ viene aggiunta all'estremità destra della stringa di $X$ sul nastro 3. Questo costruisce una sequenza di $k + 1$ simboli $X$ sul nastro 3.\
    d) Le testine dei nastri vengono quindi riposizionate in posizione uno dei rispettivi nastri.

  + La computazione continua dal passo 2.

  Tracciando la computazione per la stringa di input $a a a a a$, il passo 1 produce la configurazione:

  #figure(image("images/2026-03-11-16-14-24.png", width: 50%))

  Il movimento simultaneo da sinistra a destra delle testine dei nastri 1 e 2 si ferma quando la testina del nastro 2 scansiona il simbolo vuoto in posizione due.

  #figure(image("images/2026-03-11-16-14-33.png", width: 50%))
  La parte (c) del passo 3 riformatta i nastri 2 e 3 in modo che la stringa di input possa essere confrontata con il successivo quadrato perfetto.

  #figure(image("images/2026-03-11-16-14-40.png", width: 50%))
  Un'altra iterazione del passo 2 si ferma e rifiuta l'input.

  #figure(image("images/2026-03-11-16-14-51.png", width: 50%))

  //TODO Rifare il grafico
  #figure(image("images/2026-03-11-16-18-25.png"))
]

== MdT non deterministiche

#definition()[
  Una MdT si dice *non deterministica* quando le transizionoi non sono necessariamente funzionali nei primi due argomenti.
]
#observation()[
  Le MdT deterministichee (o standard) *sono* MdT non deterministiche, ma il viceversa non è sempre vero.
]

#definition()[
  Data una stringa _w_ e una MdT non deterministica M, diciamo che M *accetta* _w_ quando esiste una computazione di M che accetta _w_.
]

#example()[
  Dato l'alfabeto $Sigma={a, b, c}$ e un linguaggio _L_ definito su tale alfabeto ($L={w in Sigma^* | exists$ $"un'occorrenza di "c"immediatamente preceduta da "a b" oppure immediatamente"$$"seguita da " a b}$)
  #image("/assets/image-1.png")
  Nell'immagine cambiare i passaggi da q3 a q4 in b/b e da q6 a q7 a a/a
]

#definition()[
  Consideriamo una MdT M non deterministicae tutte le sue transizioni in cui i primi due simboli sono fissati e gli ultimi due variabili, ovvero:
  $
    {accent(q, tilde), accent(x, tilde), alpha, q | alpha in Sigma union {D, S}, q in Q}
  $
  Il grado di non determinismo di M corrisponde al valore:
  $
    delta = max({accent(q, tilde), accent(x, tilde), alpha, q | alpha in Sigma union {D, S}, q in Q})
  $
  Calcolato al variare di $accent(q, tilde) in Q, accent(x, tilde) in Sigma$
]
Questo significa che il grado di non determinismo corrisponde al numero massimo di svolte che la macchina M può prendere in un unica transizione, leggendo lo stesso input.

Applichiamo il tutto all'esempio precedente. \
Dato $q in Q, x in Sigma$, codifichiamo le transizioni di M MdT non deterministica, aventi _qx_ come primi 2 elementi, utilizzando gli interi da 1 a $delta$, possibilmente codifichiamo la stessa transizione con più etichette:

#grid(
  columns: (.30fr, 0.20fr, 0.20fr, 0.3fr),
  row-gutter: 5pt,
  align: (left, left, left, left),
  stroke: none,

  [$$], [$1: q_1 c D q_1$], [$1, 2, 3: q_1 a D q_1$], [$$],
  [$$], [$2: q_1 c D q_2$], [$1, 2, 3: q_0 * D q_1$], [$$],
  [$$], [$3: q_1 c S q_5$], [$$], [$$],
)

Di seguito alcuni esempi di possibili computazioni sulla stringa $w = a c a b$:
- $(1 1 1 1 1) -->$ termina in uno stato non finale;
- $(1 1 2 1 1) -->$ termina in uno stato finale e dice che _w_ è accettata;
- $(2 2 3 2 2) -->$ termina prematuramente, cioè che l'ultima transazione non viene eseguita;

#proposition()[
  _L_ è accettato da una MdT standard $<==>$ _L_ è accettato da una MdT non deterministica
]
#proof()[
  \ $==>$) M MdT standard che accetta _L_ poiché ogni MdT deterministica è anche una MdT non deterministica, _L_ è accettato da una MdT non deterministica.
  \ $<==$) M MdT non deterministica che accetta _L_ per arresto, con grado di non determinismo uguale a $delta$. Descriviamo una MdT standard che accetta _L_ per arresto a 3 nastri. I nastri sono: // TODO: disegnare i nastri
  + Input
  + Simulazione delle computazioni di M  (contenuto per disegno: $*"copio l'input ed elenco"$$(m_1,dots,m_k)$)
  + Generazione delle computazioni di M  (contenuto per disegno: $m_1*m_2*dots*m_k$ con $1 <= m_1*m_2*dots*m_k <= delta$)
]


#definition()[
  Dati due insiemi _A_ e _B_, una funzione $f$ si dice *funzione parziale* da _A_ a _B_ quando esiste un sottoinsieme di A $exists D subset.eq A$ tale che $f: D --> B$ è una funzione
]

#definition()[
  Dati due insiem _A_ e _B_, una funzione $f$ si dice *funzione totale* da _A_ a _B_ quando $forall x in A, forall y in B, f(x) = y ==> D = A$
]

#definition()[
  Una funzione parziale $f: A --> B$ si dice *parziale computabile* quando $exists M$ algoritmo t.c. $forall x in A:$
  - Se $x in D o m(f)$, M eseguito su _x_ restituisce in output $f(x) --> x in D o m(f):f "converge su "x, f(x)arrow.b$
  - Se $x in.not D o m(f)$, M su _x_ non termina $--> x in.not D o m(f):f "diverge su "x, f(x)arrow.t$
]

Lavoriamo su $NN$ in codifica unaria
#definition()[
  Una funzione parziale $f: NN^k --> NN$ si dice *parziale $tau$-ricorsiva* quando $exists M$ MdT che, $forall accent(x, arrow) in NN^k:$
  - Se $f(accent(x, arrow))arrow.b$, allora l'esecuzione di M su $accent(x, arrow)$ termina con $f(accent(x, arrow)) + 1$ "uni" (1) sul nastro.
  - Se $f(accent(x, arrow))arrow.t$, M non termina su $accent(x, arrow)$.
]

=== Tesi di Church per funzioni parziali $tau$-ricorsive
La classe delle funzioni parziali computabili coincide con la classe delle funzioni parziali $tau$-ricorsive

#proposition()[
  $forall M$ MdT standard, $forall k in NN$\
  $exists!$ funzione parziale computabile $f$ t.c. M calcola $f: NN^k --> NN$
]
#proof()[
  Definisco $f$ funzione parziale da $NN^k$ in $NN$ come segue:\
  $forall accent(x, arrow) in NN^k$, eseguo M su $accent(x, arrow)$:
  - Se M termina, $f(accent(x, arrow))$ è dato in unario dal numero di "uni" che si trovano sul nastro al termine dell'esecuzione.
  - Se M non termina, $f(accent(x, arrow))arrow.t$
]

#proposition()[
  L'insieme delle MdT è *enumerabile*.
]
#proof()[
  La strategia che si utilizza è quella di trovare una codifica binaria per le MdT in questo modo:
  - *Codifica degli stati*: ogni stato viene codificato con il suo indice scritto in unario.
  $
    Q = {q_0, q_1, dots} arrow.squiggly q_i --> underbrace(11 dots 1, i+1)
  $
  - *Codifica dei simboli dell’alfabeto*: ogni simbolo viene codificato con il suo indice scritto in unario.
  $
    Sigma = {a_0, a_1, a_2, dots, a_n} arrow.squiggly a_i --> underbrace(11 dots 1, i+1)
  $
  - *Codifica di ${D, S}$*:
  $
    D --> underbrace(11 dots 1, n+2) quad S --> underbrace(11 dots 1, n+3)
  $
  - *Codifica di una transizione*:
  $
    q_h a_i alpha q_k --> underbrace(11 dots 1, h+1) 0 underbrace(11 dots 1, i+1) 0 underbrace(11 dots 1, ?) 0 underbrace(11 dots 1, k+1)
  $
  - Lo 0 è l’elemento separatore tra gli elementi della quadrupla:
    - 1 zero separa i simboli;
    - 2 zeri separano le transizioni;
    - 3 zeri inizio e fine della codifica della MdT.

  Definita la codifica, è possibile definire un algoritmo di enumerazione per le MdT: genera in ordine lessicografico e per lunghezza crescente tutte le stringhe binarie su ${0,1}$, per ognuna di esse effettua un controllo sintattico, se rappresenta una MdT, la scrivo.

  #observation()[
    Questo algoritmo può essere visto come un algoritmo per enumerare le funzioni unari parziali computabili ($tau$-ricorsive):
    $
      &M_1, &&M_2, &&&M_3, &&&&dots, &&&&&M_n, dots\
      &#rotate(90deg, [$<-->$])
      &&#rotate(90deg, [$<-->$])
      &&&#rotate(90deg, [$<-->$])
      &&&&
      &&&&&#rotate(90deg, [$<-->$])\
      &f_1
      &&f_2
      &&&f_3
      &&&&
      &&&&&f_n
    $
  ]
]
#example("Codifica dell'intera MdT")[
  - $q_0 * D q_0$
  - $q_0 1 D q_0$
  - $q_1 1 D q_1$
  $
    q_0 <-> 1 space q_1 <-> 11 space 1<->1 space *<->11 space D<->111 space S<->1111
  $
  La MdT viene codificata come:
  $
    000 1011011101 00 1010111011 00 11010111011 000
  $
]

#theorem()[
  Sia $K= { a in NN | M_a (a)↓ }$, con $M_a$ che rappresenta la $a$-esima
  MdT prodotta dall'algoritmo di enumerazione precedente ($M_a (a)↓$
  equivale a dire che $f_a (a) ↓$ ).
  1. K è semidecidibile
  2. K non è decidibile.
]
#proof()[
  1. Dato $a in NN$, eseguo l'algoritmo di enumerazione delle MdT per ottenere $M_a$, quindi eseguo $M_a$ su $a$:
    - Se 𝑀𝑎(𝑎) ↓, allora 𝑎 ∈ 𝑘 𝐾 ;
    - Altrimenti, l’esecuzione di 𝑀𝑎 su 𝑎 non termina.
    Questo è un algoritmo di semidecisione per 𝐾.

  2. Supponiamo per assurdo che 𝐾 sia decidibile. Definiamo la funzione unaria f: ℕ → ℕ in questo modo:
  $
    f(n) = cases(
      f_n (n)+1 & "se" n in K,
      0 & "se" n in.not K
    )
  $
  Poiché sto supponendo che 𝐾 sia decidibile, allora $f$ è computabile (grazie all'algoritmo di decisione per $K$). Dunque $f$ deve comparire nella lista delle funzioni parziali computabili unarie, cioè $exists overline(n) in NN: f=f_(overline(n))$.\
  Calcolo $f(overline(n))$:
  - $overline(n) in K: f_(overline(n)) (overline(n)) + 1 = f(overline(n)) = f_(overline(n))$ che è assurdo.

  - $overline(n) in.not K: f(overline(n))=0$ (usando la definizione di $f$) ma abbiamo anche visto che $f=f_(overline(n))$ e quindi  $f(overline(n)) =f_(overline(n))$ che è un altro assurdo.
]

== Problema dell'arresto
#definition("Problema dell'arresto")[
  Data una macchina di Turing M e un numero naturale $n$, determinare se M su input $n$ termina.
]

#theorem("Teorema dell'arresto V1")[
  (Il problema dell'arresto è indecidibile) L'insieme $R={(n,m) in NN^2 | M_n "termina su" m}$ è semidecidibile ma non è decidibile.
]
#proof()[\
  Se per assurdo $R$ fosse decidibile, allora potrei decidere, in particolare, se $(n,n) in RR space (forall n in NN)$. Ma tale "sottoproblema" è equivalente al problema di decisione per $K$, che abbiamo dimostrato essere indecidibile.
]

Un'alternativa definizione del problema dell'arresto è:
#definition()[
  Data una Macchina di Turing 𝑀 e una stringa 𝑤, determinare se 𝑀 su
input 𝑤 termina.
]
Tale definizione è equivalente perché:
- Ogni numero naturale si può codificare come stringa di un opportuno alfabeto,
- Ogni stringa su un alfabeto può essere codificata da un numero naturale.
Questo risultato è dato da:
#definition("Funzione di Gödelizzazione")[
  Dato l'insieme dei numeri primi $P={2,3,5,7,dots}={p_1,p_2,p_3,dots}$ e l'alfabeto numerabile (finito) $Sigma={a_1,a_2,a_3,dots}$, definisco *funzione di Gödelizzazione* la funzione $accent(g, dot.double): Sigma^* -> NN$ che associa a una stringa costituita dai simboli di $Sigma$ un numero:
  $
    a_i_1 a_i_2 dots a_i_k --> p_1^i_1 p_2^i_2 dots p_k^i_k
  $
  Allora possiamo dire che:
  1. $accent(g, dot.double)$ è computabile.
  2. $accent(g, dot.double)$ è iniettiva.
  3. Se $m in accent(g, dot.double)(Sigma^*)$, esiste un algoritmo per calcolare $w in Sigma^*$ tale che $accent(g, dot.double)(w)=m$ 
]

//TODO: disegno degli insiemi dei problemi:
// tutti i problemi -> semidecidibili -> decidibili (cerchio più interno)

#definition()[
  Sia $cal(L)_("Halt")$ il *linguaggio del problema dell'arresto* definito nel seguente modo:
  $
    cal(L)_("Halt") = {(underbrace(R(M), "codifica di M")w)|M "termina su" w}
  $
]
#observation()[
  Il problema dell'arresto è il problema di decisione per $cal(L)_("Halt")$.
]

#theorem("Teorema dell'arresto V2")[
  $cal(L)_("Halt")$ è semidecidibile ma non decidibile.
]

#proposition()[
  $cal(L)_("Halt")^c$ (complementare di $cal(L)_("Halt")$) non è semidecidibile
]
#proof()[
  Supponiamo per assurdo che $cal(L)_("Halt")^c$ sia decidibile. Noi sappiamo che $cal(L)_("Halt")$ è decidibile. Dalle prime definizioni/proposizioni sappiamo anche che se un linguaggio e il suo complementare sono decidibili, allora il linguaggio stesso è decidibile che è un assurdo.
]

#definition()[
  Una *MdT universale* è una MdT che, su input $R(m)w$, simula l'esecuzione di M su _w_.
]
#proposition()[
  Esiste una MdT universale che calcola le funzioni parziali computabili unarie.
]

#definition()[
  $L_1, L_2$ linguaggi, $L_1 subset.eq Sigma_1^*, L_2 subset.eq Sigma_2^*$
  \ Diciamo che $L_1$ è *riducibile* a $L_2$ quando $exists f:Sigma_1^* --> Sigma_2^* t.c.$
  + $f$ è computabile
  + $forall w in Sigma_1^*, w in L_1 <==> f(w) in L_2$
]

#proposition()[
  + $f$ è una riduzione da $L_1$ a $L_2$ e $L_2$ è decidibile $=> L_1$ decidibile
    \ (vale anche se semidecidibile $=>$ semidecidibile)
  + $f$ è una riduzione da $L_1$ a $L_2$ e $K_1$ è indecidibile $=> L_2$ indecidibile
]

#proof()[
  + #grid(
    columns: (.1fr, .3fr, .49fr, .1fr),
    align: (left, left, left, left),
    rows: 2,
    row-gutter: 10pt,
    // TODO: aggiungere linea verticale separatrice
    [], [$F$ MdT che calcola $f$   ], grid.cell(rowspan: 2, [
      MdT che decide $L_1$ su $w in Sigma_1^*$:
        \ $dot$ uso _F_ per calcolare $f(w) in Sigma_2^*$;
        \ $dot$ uso $M_2$ per decidere se $f(w) in L_2$
    ]), [],
    [], [$M_2$ MdT che decide $L_2$], [], [],
  )
]

#pagebreak()
#example(multiple: true)[
  +   $L_1 = {u u | u = a^i b^i c^i, i>=0} subset.eq {a,b,c}^*$
    \ $L_2 = {a^i b^i c^i, i>=0} subset.eq {a,b,c}^* quad quad$ (decidible) $M_2$ MdT che decide $L_1$
    \ MdT che realizza (calcola) una riduzione da $L_1$ a $L_2$ su input $w in {a,b,c}^*$:
    - controlliamo se $w = u u$, per qualche $u in {a,b,c}^*$
    - se non è così, cancello _w_ e scrivo _a_
    - se $w = u u$, cancello la seconda metà di _w_, mantenendo solo _u_
  
  +   $Sigma_1 = {x,y}, Sigma_2 = {a}$
    \ $L = {(x y^n) in Sigma_1^*| n >= 0}, Q={a^(2n) in Sigma_2^* | n >= 0}$
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      label-size: 7pt,

      node((0 ,  0), $q_0$, name: <0>),
      node((3 ,  0), $q_1$, name: <1>),
      node((6 ,  0), $q_2$, name: <2>),
      node((3 ,  3), $q_3$, name: <3>),
      node((9 , -1), $q_4$, name: <4>),
      node((12, -1), $q_5$, name: <5>),
      node((12,  1), $q_6$, name: <6>),
      node((9 ,  3), $q_7$, name: <7>),
      node((12,  3), $q_8$, name: <8>),

      edge(<0>, <1>, "-|>", $*\/D$),
      edge(<1>, <2>, "-|>", $x\/D$, bend: 30deg),
      edge(<2>, <1>, "-|>", $y\/D$, bend: 30deg),
      edge(<1>, <3>, "-|>", $*\/S$),
      edge(<3>, <3>, "-|>", $x,y\/a\ a\/S$, bend: 130deg, loop-angle: 180deg),

      edge(<1>, <4>, "-|>", $x\/D$, bend: -75deg),
      edge(<2>, <4>, "-|>", $*\/D$, bend: -30deg),
      edge(<2>, <4>, "-|>", $y\/D$),

      edge(<4>, <4>, "-|>", $x,y\/D$, bend: 130deg),
      edge(<4>, <5>, "-|>", $*\/S$),
      edge(<5>, <6>, "-|>", $x,y\/*$, bend: -30deg),
      edge(<5>, <7>, "-|>", $*\/D$  , bend: -30deg),
      edge(<6>, <5>, "-|>", $*\/S$  , bend: -30deg),
      edge(<7>, <7>, "-|>", $*\/a$  , bend: 130deg, loop-angle: -135deg),
      edge(<7>, <8>, "-|>", $a\/b$),
    ))
]

== Problema del nastro vuoto (BTP)
#problem()[
  Data una MdT M, determinare se l'esecuzione di M termina su nastro vuoto.
]

#proposition()[
  BTP è indecidibile
]

#proof()[
  Descriviamo una riduzione dal problema dell'arresto al problema del nastro vuoto
  #block($
    cal(L)_("HALT")={R(M)w | M "termina su" w}; cal(L)_("BTP") = {R(M) | M "termina su nastro vuoto"}
  $)
  data _x_ stringa:
  - se _x_ *non* è della forma $R(M)w$, restituisco 0 (slide dice $f(x) = 1$))
  - altrimenti, se $x = R(M)w$, costruisco la stringa $R(N)$, con $N$ MdT, t.c. N opera come segue, su input _y_:
    - se $y != epsilon$, N si comporta come M
    - se $y = epsilon$, scrivo _w_ sul nastro ed eseguo M su _w_ 

    Osserviamo che:
    - se M termina su _w_ $==>$ N termina su $epsilon$
    - se M non termina su _w_ $==>$ N non termina su $epsilon$
    $ R(M)w in cal(L)_("HALT") <==> R(N) in cal(L)_("BTP") $
]

Restringiamo la classe dei linguaggi semidecidibili:
- La stringa vuota appartiene al linguaggio?\ 
  $cal(L)_epsilon={R(M) | epsilon in L(M)}$
- Il linguaggio è vuoto?\ 
  $cal(L)_emptyset={R(M) | L(M) = emptyset}$
- Il linguaggio è $Sigma^*$?\ 
  $cal(L)_(Sigma^*)={R(M) | L(M) = Sigma^*}$
- Il linguaggio è regolare?\ 
  $cal(L)_"REG" = {R(M) | L(M) "è regolare"}$

#proposition()[
  $cal(L)_(Sigma^*)$ non è decidibile
]
#proof()[
  Descriviamo una riduzione da $cal(L)_"HALT"$ a $cal(L)_(Sigma^*)$\ 
  $
    R(M)w arrow.long.squiggly R(N)
  $
  Comportamento di _N_ su _y_:
  - cancello _y_;
  - scrivo _w_;
  - eseguo _M_ su _w_;
]
#observation(multiple: true)[
  + $R(M)w in cal(L)_"HALT" (M "termina su" w)$\
    $N "termina su" y, forall y => R(N) in cal(L)_(Sigma^*)$
  + $R(M)w in.not cal(L)_"HALT" (M "non termina su" w)$\
    $N "non termina su" y, forall y => R(N) in.not cal(L)_(Sigma^*)$
]

#definition()[
  Indichiamo con $cal(P)$ una qualunque *proprietà di un linguaggio semidecidibile* e con $cal(L)_cal(P)$ l'insieme di linguaggi semidicidibile che soffisfano $cal(P)$, cioé
  $
    &cal(L)_cal(P)= { L "semidecidibile" | L "soddisfa" cal(P)} "o, equivalentemente"\
    &cal(L)_cal(P)={R(M) | L(M) "soddisfa" cal(P)}
  $

  Allora $cal(P)$ si dice *banale* quando:
  - $forall$ linguaggio $L$ semidecidibile, $L in cal(L)_cal(P)$(ovvero tutti i linguaggi semidecidibili hanno la proprietà $cal(P)$), oppure
  - $cal(L)_cal(P) = emptyset$ (ovvero nessun linguaggio semidecidibile ha la proprietà $cal(P)$)
]

#theorem("di Rice")[
  $cal(P)$ proprietà non banale
  $
    cal(L)_cal(P)={R(M) | L(M) "soddisfa" cal(P)} ==> cal(L)_cal(P) "non è decidibile"
  $
]
#proof()[
  + $cal(P)$ proprietà non banale. Supponiamo che il linguaggio vuoto $emptyset$ non soddisfa la proprietà $cal(P)$ e sia _L_ linguaggio semidecidibile che soddisfa $cal(P)$, con $L eq.not emptyset$ Sia $M_L$ MdT che accetta L.\ 
    Descriviamo una riduzione da $cal(L)_"HALT"$ a $cal(L)_cal(P)$\
    $ R(M)w arrow.long.squiggly R(N) $
    Comportamento di _N_ su _y_:
    // TODO: disegnare nastro
    - scrivo _w_ a destra di _y_;
    - eseguo _M_ su _w_:
      + se _M_ termina su _w_, eseguo _N_ su _y_ e si comporta come $M_L$, quindi:\ 
        $L(N)=L(M_L)=L$, e _L_ soddisfa $cal(P)$\
        $R(M)w in cal(L)_"HALT" => R(N) in cal(L)_cal(P)$
      + se _M_ non termina su _w_, _N_ non accetta nessuna stringa _y_, quindi:\ 
        $L(N)=emptyset in.not cal(L)_cal(P)$\
        $R(M)w in.not cal(L)_"HALT" => R(N) in.not cal(L)_cal(P)$

  + $cal(P)$ proprietà non banale\
    Supponiamo che il linguaggio vuoto $emptyset$ soddisfi la proprietà $cal(P)$, allora  $emptyset$ non soddisfa $not cal(P)$ e, per la dimostrazione precedente, $cal(L)_(not cal(P))$ non è decidibile

    Per assurdo: $cal(L)_cal(P)$ è decidibile $=> cal(L)_(not cal(P)) union {"stringhe che non codificano MdT"} "decidibile" => cal(L)_(not cal(P)) "decidibile, assurdo"$
]