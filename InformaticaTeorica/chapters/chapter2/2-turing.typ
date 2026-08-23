#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *

= Macchine di Turing

#figure(image("images/turing-machine.png", width: 80%), caption: "presa da https://aturingmachine.com/")

Introducendo le funzioni $mu$-ricorsive abbiamo visto una proposta di definizione di algoritmo, che restituisce formalmente l'idea intuitiva di funzione computabile. In questo capitolo vediamo una proposta equivalente del concetto di algoritmo: la *Macchina di Turing* (MdT). Una MdT ha le seguenti caratteristiche:

- E' composta da un *nastro unidimensionale* infinito, sia da destra che da sinistra.
- Il nastro è diviso in *celle* che possono contenere informazioni.
- Le informazioni che si possono scrivere sul nastro sono *simboli* da un *alfabeto finito $Sigma$* definito inizialmente. Questo alfabeto contiene sempre un *simbolo privilegiato* (*\**) che serve per denotare una *cella vuota* ed è normalmente implicito e non scritto tra i simboli dell'alfabeto.
- C'è una *testina* che si occupa della *lettura/scrittura*, spostandosi a destra ($D$) e a sinistra ($S$), indicando una cella ad ogni spostamento. Ogni spostamento della testina è definito *passo di calcolo* o *transizione*.
- La macchina ha un insieme di stati di memoria _Q_ = {$q_0, q_1, dots, q_n$}. Lo stato $q_0$ è chiamato stato iniziale e in seguito a una *transizione*, la macchina può cambiare stato.

Una transizione è una quadrupla i cui primi due elementi, stato attuale e simbolo letto, determinano una *configurazione*. In particolare, la quadrupla è fatta così:
$
  (overbracket(q\, x, "configurazione"), overbracket(alpha, "azione svolta"), overbracket(accent(q, ~), "stato finale")) & in Q times Sigma times (Sigma union {D, S}) times Q
$
ed è funzionale nei primi 2 argomenti, cioè fissati uno stato e un simbolo ci sono al più 2 simboli azione-stato associabili alla configurazione (la transizione è unica). L'azione svolta $alpha$ può essere una lettura/scrittura di un simbolo o uno spostamento della testina a destra o a sinistra.
#index[Macchina di Turing]#index[Transizione]#index[Configurazione]
#definition()[
  Una *macchina di Turing* è un sottoinsieme dell'insieme: $ Q times Sigma times (Sigma union {D, S}) times Q $
  cioè è una lista finita di transizioni (ovvero una lista di quadruple funzionali nei primi 2 argomenti).
]

#example(multiple: true)[

  + #block(
      $
        quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ")q_1\
        &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
      $,
    )
    Questa è una macchina "inutile", nel senso che fa un passo e termina subito perché non ci sono transizioni definite per lo stato $q_1$.\

  + #image("images/example2TM.png", width: 65%)
    #block(
      $
        quad space &q_0 && * && D space && q_0 text(": Se la cella corrente è vuota, la testina si sposta a destra e non cambia stato")\
        &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
        &q_1 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e non cambia stato")
      $,
    )
    Quando la macchina è in $q_1$ non ha una transizione che descrive cosa fare incontrando una cella vuota quindi la macchina termina nel momento in cui finisce di scandire la prima "stringa" (sequenza) di 1 consecutivi.\

  + #image("images/example3TM.png", width: 65%)
    #block(
      $
        quad space &q_0 && * && 1 space && q_0 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
        &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
        &q_1 && * && 1 && q_1 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
        &q_1 && 1 && 1 && q_0 text(": Se la cella corrente è 1, riscrivo 1 e cambio lo stato a ")q_0
      $,
    )
    Questa macchina non termina mai e riempie il nastro di simboli 1.

  + #image("images/example4TM.png", width: 65%)
    #block(
      $
        quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a") q_1\
        &q_1 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ")\
        &q_1 && * && 1 && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ")q_2\
        &q_2 && 1 && S && q_2 text(": Se la cella corrente è 1, la testina si sposta a sinistra e non cambia lo stato")
      $,
    )
    Questa MdT aggiunge un simbolo 1 alla fine della stringa di 1 consecutivi e poi torna all'inizio del nastro. Quindi, se la stringa rappresenta un numero naturale in codifica unaria, questa MdT calcola il suo sucessore.
]

#index[MdT che calcola una funzione]
#definition()[
  Una Macchina di Turing (MdT) _M_ calcola una funzione $f: Sigma^* -> Sigma^*$ quando, scritta una stringa $w in Sigma^*$ sul nastro e posta la testina di _M_ sulla prima cella vuota a sinistra di _w_, dopo l'esecuzione di _M_ su _w_, la testina si trova nella prima cella vuota a sinistra dell'output $f(w)$.
]

#example()[
  Creiamo una MdT che calcola la funzione somma tra due numeri naturali rappresentati in codifica unaria (con il simbolo $1$). I numeri scelti in questo esempio sono 3 e 2:
  #figure(image("images/EsempioMdTSomma.png", width: 60%))
  #block(
    $
      &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ") q_1\
      &q_1 && space 1 space && D space && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ")\
      &q_1 && * && 1 space && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ") q_2\
      &q_2 && space 1 space && D space && q_2 text(": Se la cella corrente è 1, la testina si sposta a destra e non cambia lo stato")\
      &q_2 && * && S space && q_3 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ") q_3\
      & q_3 && space 1 && * space && q_3 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato")\
      &q_3 && * && S space && q_4 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ") q_4\
      & q_4 && space 1 && * space && q_4 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato")\
      &q_4 && * && S space && q_5 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ") q_5\
      &q_5 && space 1 space && S space && q_5 text(": Finché legge 1, la testina si sposta a sinistra; si ferma sulla cella vuota")\ & && && && quad quad text("a inizio stringa")
    $,
  )
]
- Caso di #underline("una singola stringa in input:")
#image("./images/image.png")
- Caso di #underline("input composto da più stringhe:")
#image("./images/image-1.png")
Per maggiore chiarezza, rappresenteremo graficamente le MdT in questo modo (simile a quanto visto per gli automi a stati finiti in altri corsi): \
#figure(diagram(
  node-stroke: 0.9pt,
  cell-size: 5mm,
  spacing: 3mm,

  node((0, 0), $q$, name: <qs>),
  node((3, 0), $accent(q, ~)$, name: <qf>),
  node((-1, 0), [la transizione *$q x alpha accent(q, ~)$* è:], stroke: 0pt),

  edge(<qs>, <qf>, "-|>", $x \/ alpha$),
))

#pagebreak()

== Tesi di Church (per le funzioni $tau$-ricorsive)
#index[Funzione $tau$-ricorsiva]
#definition()[
  Una funzione $f: NN^k -> NN$ si dice *$tau$-ricorsiva* quando $exists M$ MdT che calcola $f$.
]
#index[Tesi di Church]
#proposition[La classe delle funzioni computabili coincide con la classe delle funzioni $tau$-ricorsive.]
Vale quindi la stessa tesi vista per le funzioni $mu$-ricorsive, in questo senso sono proposte equivalenti.
#example(multiple: true)[
  + MdT che, data una stringa su {a, b}, scambia le 'a' con le 'b' (e poi riporta la testina all'inizio): \
    #figure(image("images/esempioMdTScambiaLettere.png", width: 70%))
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      node((0, 2), $q_0$, name: <0>),
      node((3, 2), $q_1$, name: <1>),
      node((6, 2), $q_2$, name: <2>),
      edge(<0>, <1>, "-|>", $* \/ D$, bend: 30deg),
      edge(<1>, <2>, "-|>", $b \/ a \ a \/ b$, bend: 30deg),
      edge(<2>, <1>, "-|>", $a, b \/ D$, bend: 30deg),
      edge(<1>, <0>, "-|>", $* \/ S$, bend: 30deg),
      edge(<0>, <0>, "-|>", $a,b \/ S$, bend: 130deg),
    ))
  + MdT che scrive la copia di una stringa unaria. Introduciamo un simbolo aggiuntivo "di lavoro" X per semplificare la strategia. Questo non fa parte dell'alfabeto e alla fine il nastro non dovrà contenere X.
  #figure(image("images/esempioMdTCopiaStringa.jpeg", width: 100%))
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
    edge(<5>, <5>, "-|>", $1 \/ S \ X \/ 1$, bend: 130deg, loop-angle: 0deg),
  ))
]
#pagebreak()
== MdT come accettatori di linguaggi
Dato un alfabeto $Sigma$ e un linguaggio $L subset.eq Sigma^*$, ci chiediamo se una stringa $w in Sigma^*$ appartiene a $L$. Per rispondere a questa domanda possiamo costruire una MdT $M$ che, data in input la stringa $w$, determina se $w in L$. In tal caso, si dice che $M$ *accetta* la stringa $w$. In generale, $M$ accetta il linguaggio $L$ se quest'ultimo è l'insieme di tutte e sole le stringhe che $M$ è in grado di accettare, ovvero $L = L(M)$ ("$L$ è il linguaggio accettato dalla MdT $M$"). Vediamo due modi in cui una MdT può accettare un linguaggio: per stati finali o per arresto.

=== Accettazione per stati finali
- $Q$: insieme degli stati di una MdT
- $F subset.eq Q$: insieme degli stati finali

#index[Accettazione per stati finali]
#definition()[
  _M_ accetta la stringa  _w_ *per stati finali* quando l'esecuzione di _M_ su input _w_ termina in uno stato finale.
]
#definition()[
  $L subset.eq Sigma^*$ si dice *accettato per stati finali* da una MdT _M_ quando $w in L$ se e solo se _M_ accetta _w_ per stati finali (quindi si ha $L = L(M)$).
]
#index[Linguaggio ricorsivamente enumerabile]
#definition()[
  Se _L_ è t.c. $exists M$ MdT per cui $L = L(M)$, _L_ si dice *ricorsivamente enumerabile*.
]
#index[Linguaggio ricorsivo]
#definition()[
  Se _M_ è una MdT che termina su ogni input, allora $L(M)$ si dice *ricorsivo*.
]
#observation()[
  #block(
    $
      #underline("Via tesi di church"): & bold("ric. enum." <--> "semidecidibile") \
                                        & bold("ricorsivo" <--> "decidibile")
    $,
  )
  Cioè, grazie alla tesi di Church abbiamo un'equivalenza tra i concetti intuitivi (che parlano genericamente di "algoritmi") di decidibile/semidecidbile e i concetti formali di ricorsività delle MdT: dire che un linguaggio è ricorsivo è equivalente a dire che è decidibile (esiste un algoritmo che risolve il problema in tempo finito per ogni input). Inoltre, dire che un linguaggio è ricorsivamente enumerabile è equivalente a dire che è semidecidibile (esiste un algoritmo che risolve il problema in tempo finito per ogni input appartenente al linguaggio, mentre per gli input non appartenenti al linguaggio l'algoritmo può non terminare mai).
]

#example(multiple: true)[
  + MdT che accetta il linguaggio $(a|b)^* a a(a|b)^*$ (deve essere rilevata una (sotto)stringa "aa"):
  \
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
  + MdT che accetta il linguaggio ${a^i b^i c^i | i >= 0} subset.eq {a, b, c}^*$
    #align(center, grid(
      align: center + horizon,
      rows: 3,
      columns: 1,
      grid.cell([
        #grid(
          columns: 10,
          stroke: .5pt,
          inset: 5pt,
          [\*], [a], [a], [a], [b], [b], [b], [c], [c], [c],
        )
      ]),
      grid.cell([
        #grid(
          columns: 10,
          stroke: .5pt,
          inset: 5pt,
          [\*], [x], [x], [x], [y], [y], [y], [z], [z], [z],
        )
      ]),
    ))
    #align(center, diagram(
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
      edge(<2>, <2>, "-|>", $a, y\/D$, bend: 130deg),
      edge(<2>, <3>, "-|>", $b\/y$, label-side: right),
      edge(<3>, <4>, "-|>", $y\/D$, label-side: left),
      edge(<4>, <4>, "-|>", $b, z\/D$, bend: -130deg, loop-angle: 135deg),
      edge(<4>, <5>, "-|>", $c\/z$),
      edge(<5>, <6>, "-|>", $z\/S$),
      edge(<6>, <6>, "-|>", $a, b, y, z\/S$, bend: -130deg),
      edge(<6>, <1>, "-|>", $x\/D$, label-side: left),
      edge(<7>, <7>, "-|>", $y, z\/D$, bend: 130deg, loop-angle: 180deg),
      edge(<7>, <8>, "-|>", $*\/*$),
    ))\
    L'importante è che ad ogni errore corrisponda uno stato, non che ogni stato preveda errori $->$ la macchina è costruita per andare avanti soltanto se tutto funziona
]

=== Accettazione per arresto
#index[Accettazione per arresto]
#definition()[
  Una MdT $M$ accetta per arresto quando $M$, eseguita su _w_, termina.
]
L'insieme delle stringhe accettate da $M$ per arresto è il *linguaggio* accettato da $M$ per arresto.

#proposition()[
  Dato un linguaggio $L$:
  #grid(
    columns: (0.45fr, 40pt, 0.45fr),
    align: (right, center + horizon, left),
    [$exists$ MdT $M$ che accetta $L$ per stati finali], [$<==>$], [$exists$ MdT $M$ che accetta $L$ per arresto],
  )
]

#proof()[
  \ $<==)$ Sia $N$ MdT che accetta $L$ per arresto. La MdT ottenuta da $N$, designando ogni stato come finale, è una MdT che accetta $L$ per stati finali.
  \ $==>)$ $M$ MdT che accetta $L$ per stati finali. Su input _w_ ci sono 3 casi:
  - $M$ termina su uno stato finale (OK, anche per arresto)
  - $M$ non termina (OK, non accettata in entrambi i modi)
  - $M$ termina ma in uno stato non finale: costruiamo una MdT $N$ in questo modo. $N$ ha le stesse transizioni di $M$ più le seguenti: $forall q in Q \\ F, forall x in Sigma$ t.c. non ci sono transizioni di $M$ con configurazione $q x$, aggiungiamo le transizioni $q x x accent(q, ~)$, $accent(q, ~) x x accent(q, ~)$ (dove $accent(q, ~)$ è un nuovo stato).

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
  Praticamente, quando $M$ termina in uno stato non finale, entra in un nuovo stato $accent(q, ~)$ in cui va in loop (non termina). Quindi $N$ termina solo se $M$ termina in uno stato finale.
]

#example(multiple: true, "Esercizi d'esame")[
  + $L$ è accettato per *unico stato finale* quando $exists M$ MdT con un solo stato finale che accetta $L$. Dimostrare $L$ accettato per stati finali se e solo se $L$ è accettato per unico stato finale.\
    #proof()[
      \ $<==)$ Ovvio.
      \ $==>)$ $M$ MdT che accetta $L$ per stati finali. Costruiamo $N$ aggiungendo un nuovo stato $accent(q, ~)$ che M raggiungerà ogni volta che termina in uno stato finale (inoltre $accent(q, ~)$ sarà l'unico stato finale di $N$).
    ]

  + $M$ accetta _w_ *per ingresso* quando, durante l'esecuzione di $M$ su un input _w_, la MdT entra in uno stato finale. Un linguaggio $L$ è accettato da $M$ per ingresso quando $exists M$ MdT  che accetta tutte e sole le stringhe di $L$ per ingresso. Dimostrare che $L$ è accettato per stati finali se e solo se $L$ è accettato per ingresso.\
    #proof()[
      \ $==>$) $M$ MdT che accetta _$L$_ per stati finali.\
      $M'$ che accetta per ingresso si costruisce a partire da $M$, aggiungendo un nuovo stato $tilde(q)$ (che sarà l'unico stato finale) e transizioni che portano in $tilde(q)$ da ogni stato finale in corrispondenza di caratteri per cui non ci sono transizioni uscenti in $M$.

      $<==$) $M$ MdT che accetta _L_ per ingresso.\
      $M'$ MdT che accetta $L$ per stati finali si ottiene da $M$ eliminando tutte le transizioni uscenti dagli stati finali.
    ]

]

== MdT multitraccia

#index[MdT multitraccia]
#definition()[
  MdT multitraccia con:
  - $Sigma$ alfabeto
  - $Q$ insieme degli stati

  Possiamo definirla come una lista di transizioni della forma (con $k$ = numero tracce):
  $
    (q, (x_1, dots, x_k), alpha, accent(q, ~)) in Q times Sigma^k times (Sigma^k union {D, S}) times Q
  $
]
#figure(image("images/MdTmultitraccia.png", width: 60%))
C'è una sola testina che legge/scrive sulle $k$ tracce simultaneamente.
#proposition()[
  Fissato un $k in NN$, un linguaggio $L$ è accettato da una MdT a $k$ tracce $<==>$ $L$ è accettato da una MdT standard (a una sola traccia)
]
#proof()[
  \ $<==)$ Ovvio. Posso simulare una MdT con una traccia usando una MdT a $k$ tracce in cui ignoro (cioè lascio vuoto) il contenuto di tutte le tracce tranne la prima.
  \ $==>)$ $M$ MdT a $k$ tracce che accetta $L$, posso ottenere una MdT $M'$ che accetta $L$ a una traccia semplicemente sostituendo l'alfabeto $Sigma$ di $M$ con $Sigma^k$, eseguendo  le medesime transizioni (se in $M$ si legge, dal basso verso l'alto, a, b, a, \*, a in $k=5$ celle diverse, in $M'$ si leggerà la quintupla (a, b, a, \*, a) in una sola cella).
]

== MdT limitata a sinistra

#index[MdT limitata a sinistra]
#definition()[
  Questa è una MdT *limitata a sinistra* (il nastro è infinito solo verso destra):
  #figure(image("images/2026-03-11-12-08-24.png"))
  possiamo usare MdT limitate a sinistra per accettare stringhe nello stesso modo di quelle classiche, con l'accortezza che un'operazione di spostamento a sinistra a partire dalla prima cella causa il rifiuto della stringa. *Da ora in poi, quando si parla di MdT standard si fa riferimento a questo tipo di MdT.*
]

#proposition()[
  Un linguaggio $L$ è accettato da una MdT classica $<==>$ $L$ è accettato da una MdT limitata a sinistra.
]
#proof()[\
  $<==)$ Sia $M'$ una MdT con nastro limitato a sinistra che accetta $L$. Per simulare una computazione di $M'$ usando una MdT classica $M$, possiamo scrivere sul nastro un particolare simbolo, per esempio \#, che indichi che tale cella è quella iniziale. Quando una computazione di questa MdT cerca di portare la testina a sinistra di tale simbolo, facciamo in modo che un'altra computazione faccia terminare la MdT rifiutando la stringa.
  #figure(image("images/2026-03-11-12-09-22.png"))

  $==>)$ Sia $M$ una MdT classica che accetta $L$. Consideriamo una MdT $M'$ con nastro limitato a sinistra che abbia due tracce. Per simulare una computazione di $M$ su $M'$, si considera il nastro di $M$ (che è infinito sia a destra che a sinistra) e si assegna alla prima cella vuota a sinistra della stringa in input la posizione 0. A sinistra di tale  posizione avremo una numerazione  negativa delle celle, mentre alla sua destra  le celle avranno una numerazione  crescente positiva.
  #figure(image("images/2026-03-11-12-11-42.png"))

  Possiamo sistemare il contenuto a destra della posizione 0 nella prima traccia della MdT $M'$, mentre nella seconda traccia ci sarà l'eventuale contenuto delle celle a sinistra della posizione 0.
  #figure(image("images/2026-03-11-12-12-01.png"))

  In questo modo, a una transizione di $M$ che fa spostare la testina a sinistra della posizione 0 corrisponde una transizione di $M'$ che fa spostare la testina sulla seconda traccia. Essendo le MdT multitraccia accettate da MdT standard e viceversa, vale che $L$ è accettato da questa MdT limitata a sinistra.
]

== MdT multinastro

#index[MdT multinastro]
#definition()[
  Una Macchina di Turing multinastro è una MdT che opera su più nastri di lettura/scrittura indipendenti tra di loro, con una testina per ogni nastro.
  #figure(image("images/2026-03-11-12-29-21.png"))

  La tipica transizione di una MdT multinastro è:
  $
    q_i (x_1, … , x_k) (alpha_1, … , alpha_k) q_j --> cases("con" alpha_i in Sigma "operazione di scrittura, oppure", alpha_i in {D,S} "operazione di spostamento")
  $
  E quindi le transizioni appartengono all'insieme $Q times Sigma^k times (Sigma union {D,S})^k times Q$
]

#proposition()[
  Un linguaggio $L$ è accettato da una MdT standard $<==>$ $L$ è accettato da una MdT multinastro con $k$ nastri.
]
#proof()[

  $==>)$ Ovvio, basta ignorare i nastri in eccesso.

  $<==)$ $M$ MdT a $k$ nastri che accetta $L$, facciamo vedere che esiste una MdT $M'$ a $2k+1$ tracce che accetta $L$. Più precisamente facciamo vedere che ogni singola transizione di una computazione di $M$ può essere simulata da un gruppetto di transizioni di $M'$.

  Poniamo $k=2$. Vogliamo cercare di simulare una singola transizione della MdT $M$ a 2 nastri con un gruppetto di transizioni di una MdT $M'$ a 5 tracce (perché $5 = 2k + 1$ con $k = 2$).
  #figure(image("images/2026-03-11-12-41-50.png"))

  - Le tracce 1 e 3 rappresentano il contenuto dei nastri 1 e 2 di $M$ rispettivamente;
  - Le tracce 2 e 4 rappresentano rispettivamente la posizione della testina nei nastri 1 e 2 di $M$ (la cella corrispondente alla posizione della testina contiene un particolare simbolo, per es. x);
  - La traccia 5 contiene nella prima posizione il solo simbolo \#, che serve per riposizionare la testina a inizio nastro.

  I passi con cui $M'$ simula una transizione di $M$ sono i seguenti:

  1. Prima vengono raccolte tutte le informazioni, riguardanti le celle lette sui due nastri. Queste informazioni possono essere memorizzate, ad esempio, definendo opportunamente l'insieme degli stati: la macchina, ogni volta che incontra il marcatore della traccia $i$, legge il simbolo corrispondente e lo memorizza cambiando il proprio stato interno.  Tecnicamente, l'insieme degli stati di $M'$ viene quindi esteso a un prodotto cartesiano del tipo $Q times (Sigma union {*})^k$, dove le componenti aggiuntive fungono da buffer temporaneo. Alla fine della scansione, lo stato di $M'$ contiene tutte le informazioni necessarie per decidere la transizione della macchina multinastro originale;
  2. Cerca sulla traccia 2 il simbolo $x$, che corrisponde alla posizione della testina del nastro 1 di $M$;
  3. Legge sulla traccia 1 il simbolo nella cella la cui posizione è indicata dalla $x$ sulla traccia 2 e compie l'operazione di scrittura, se deve, altrimenti compie l'operazione di spostamento della testina operando sulla traccia 2 e riscrivendo la $x$ in corrispondenza della sua nuova posizione;
  4. Torna all'inizio del nastro sfruttando la traccia 5, ovvero quando legge il simbolo \# si ferma (perché tale simbolo indica l'inizio del nastro);
  5. Cerca sulla traccia 4 il simbolo $x$, che corrisponde alla posizione della testina del nastro 2 di $M$;
  6. Legge sulla traccia 3 il simbolo nella cella la cui posizione è indicata dalla $x$ sulla traccia 4 e compie l'operazione di scrittura, se deve, altrimenti compie l'operazione di spostamento della testina operando sulla traccia 4 e riscrivendo la $x$ in corrispondenza della sua nuova posizione;
  7. Torna all'inizio del nastro.
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
    b) Due copie della stringa sul nastro 3 vengono aggiunte all'estremità destra della stringa sul nastro 2. Con i passi a) e b) si è costruita una sequenza di $(k + 1)^2 = k^2 + 2k + 1$ simboli $X$ sul nastro 2, ossia il successivo quadrato perfetto.\
    c) Una $X$ viene aggiunta all'estremità destra della stringa di $X$ sul nastro 3. Questo costruisce una sequenza di $k + 1$ simboli $X$ sul nastro 3.\
    d) Le testine dei nastri vengono quindi riposizionate in posizione uno dei rispettivi nastri.

  + La computazione riparte dal passo 2.

  Tracciando la computazione per la stringa di input $a a a a a$, il passo 1 produce la configurazione:

  #figure(image("images/2026-03-11-16-14-24.png", width: 50%))

  Il movimento simultaneo da sinistra a destra delle testine dei nastri 1 e 2 si ferma quando la testina del nastro 2 scansiona il simbolo vuoto in posizione due.

  #figure(image("images/2026-03-11-16-14-33.png", width: 50%))
  La parte (c) del passo 3 riformatta i nastri 2 e 3 in modo che la stringa di input possa essere confrontata con il successivo quadrato perfetto.

  #figure(image("images/2026-03-11-16-14-40.png", width: 50%))
  Un'altra iterazione del passo 2 si ferma e rifiuta l'input (la stringa di input è più corta del quadrato perfetto sul nastro 2).

  #figure(image("images/2026-03-11-16-14-51.png", width: 50%))

  Ecco la rappresentazione grafica dell'MdT multinastro che accetta questo linguaggio:
  #figure(image("images/2026-03-11-16-18-25.png"))
]

== MdT non deterministiche

#index[MdT non deterministica]
#definition()[
  Una MdT si dice *non deterministica* quando le transizioni non sono necessariamente funzionali nei primi due argomenti.
]
#observation()[
  Dalla definizione sopra, emerge che le MdT deterministiche (o standard) sono MdT non deterministiche, ma il viceversa non è sempre vero.
]

#definition()[
  Data una stringa _w_ e una MdT non deterministica $M$, diciamo che $M$ *accetta* _w_ quando esiste una computazione di $M$ che accetta _w_.
]

#example()[
  Dato l'alfabeto $Sigma={a, b, c}$ e un linguaggio _L_ definito su tale alfabeto t.c. $L={w in Sigma^* | exists "un'occorrenza di "c" immediatamente preceduta da "a b" oppure immediatamente"$$"seguita da" a b}$, scrivere la MdT che accetta $L$.
  \
  \
  #figure(grid(
    rows: 3,
    columns: 1,
    grid.cell([
      #grid(
        columns: 13,
        stroke: .5pt,
        inset: 5pt,
        [\*], [a], [b], [a], [a], [c], [b], [a], [b], [c], [a], [a], [b],
      )
    ]),
  ))
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 1mm,
    node-inset: 4pt,
    spacing: 3mm,
    label-size: 7.5pt,

    node((0, 0), $q_0$, name: <0>),
    node((4, 0), $q_1$, name: <1>),
    node((8, 0), $q_2$, name: <2>),
    node((12, 0), $q_3$, name: <3>),
    node((16, 0), $q_4$, name: <4>, extrude: (-2, 0)),
    node((4, 5), $q_5$, name: <5>),
    node((8, 5), $q_6$, name: <6>),
    node((12, 5), $q_7$, name: <7>, extrude: (-2, 0)),

    edge(<0>, <1>, "-|>", $*\/D$),
    edge(<1>, <1>, "-|>", $a, b, c\/D$, bend: 130deg, loop-angle: 90deg),
    edge(<1>, <2>, "-|>", $c\/D$),
    edge(<2>, <3>, "-|>", $a\/D$),
    edge(<3>, <4>, "-|>", $b\/b$),
    edge(<1>, <5>, "-|>", $c\/S$),
    edge(<5>, <6>, "-|>", $b\/S$),
    edge(<6>, <7>, "-|>", $a\/a$),
  ))
]

#index[Grado di non determinismo]
#definition()[
  Il *grado di non determinismo* di una MdT $M$ non deterministica corrisponde al valore
  $
    delta := max abs({(accent(q, tilde), accent(x, tilde), alpha, q) | alpha in Sigma union {D, S}, q in Q})
  $
  Calcolato al variare di $accent(q, tilde) in Q, accent(x, tilde) in Sigma$
]
Questo significa che il grado di non determinismo corrisponde al numero massimo di svolte che la macchina $M$ può prendere in un'unica transizione, leggendo lo stesso input.

Applichiamo il tutto all'esempio precedente. Dato $q in Q, x in Sigma$, codifichiamo le transizioni di $M$ MdT non deterministica, aventi _qx_ come primi 2 elementi, utilizzando gli interi da 1 a $delta = 3$, possibilmente codifichiamo la stessa transizione con più etichette:

#grid(
  columns: (.30fr, 0.20fr, 0.20fr, 0.3fr),
  row-gutter: 5pt,
  align: (left, left, left, left),
  stroke: none,

  [$$], [$1: q_1 c D q_1$], [$1, 2, 3: q_1 a D q_1$], [$$],
  [$$], [$2: q_1 c D q_2$], [$1, 2, 3: q_0 * D q_1$], [$$],
  [$$], [$3: q_1 c S q_5$], [$$], [$$],
)

Le $1,2,3$ indicano le transizioni per cui data quella coppia stato-simbolo la scelta è solo una a prescindere da quale etichetta si scelga nella computazione. Di seguito alcuni esempi di possibili computazioni *sulla stringa $w = a c a b$* (si parte sempre da un $*$ all'inizio della stringa):
- $(1 1 1 1 1) -->$ termina in uno stato non finale ($q_1$);
- $(1 1 2 1 1) -->$ termina in uno stato finale ($q_4$) e dice che _w_ è accettata;
- $(2 2 3 2 2) -->$ termina prematuramente, cioè l'ultima transizione non viene eseguita (rimane bloccata in $q_5$);

#proposition()[
  _L_ è accettato da una MdT standard $<==>$ _L_ è accettato da una MdT non deterministica
]
#proof()[
  \ $==>$) $M$ MdT standard che accetta _L_ poiché ogni MdT deterministica è anche una MdT non deterministica, _L_ è accettato da una MdT non deterministica.
  \ $<==$) $M$ MdT non deterministica che accetta _L_ per arresto, con grado di non determinismo $delta$. Descriviamo una MdT standard (deterministica) che accetta _L_ per arresto a 3 nastri:
  + nastro di input;
  + nastro per la simulazione delle computazioni di $M$;
  + nastro per la generazione delle computazioni di $M$.
  La MdT deterministica compie questi passi per simulare $M$:
  - genera sul nastro 3 una sequenza di interi $1 <= m_1, m_2, dots, m_k <= delta$;
  - la stringa di input sul nastro 1 viene copiata sul nastro 2;
  - la computazione di $M$ codificata sul nastro 3 viene eseguita sul nastro 2;
  - se la computazione termina, l'input è accettato;
  - altrimenti viene generata sul nastro 3 la successiva sequenza di interi da 1 a $delta$ e si ripetono i passi precedenti.
]

=== Tesi di Church generalizzata (per funzioni parziali $tau$-ricorsive)

#index[Funzione parziale]
#definition()[
  Dati due insiemi _A_ e _B_, una funzione $f$ si dice *funzione parziale* da _A_ a _B_ quando $exists D subset.eq A$ tale che $f: D --> B$ è una funzione.
  #figure(image("images/funzParz.png", width: 30%))
]

#index[Funzione totale]
#definition()[
  Una funzione parziale $f$ da _A_ a _B_ si dice *funzione totale* quando $D = A$, cioè quando $f$ è definita su tutto _A_, ossia $forall x in A space exists y in B | f(x) = y$ (una funzione totale è quindi una funzione nel senso comune del termine).
]

#index[Funzione parziale computabile]
#definition()[
  Una funzione parziale $f: A --> B$ si dice *parziale computabile* quando $exists M$ algoritmo t.c. $forall x in A:$
  - Se $x in "Dom"(f)$, $M$ eseguito su _x_ restituisce in output $f(x) --> f$ *converge* su _x_, in simboli: $f(x)arrow.b$
  - Se $x in.not "Dom"(f)$, $M$ su _x_ non termina $--> f$ *diverge* su _x_, in simboli: $f(x)arrow.t$
]

Lavoriamo su $NN$ in codifica unaria.
#index[Funzione parziale τ-ricorsiva]
#definition()[
  Una funzione parziale $f: NN^k --> NN$ si dice *parziale $tau$-ricorsiva* quando $exists M$ MdT che, $forall accent(x, arrow) in NN^k:$
  - Se $f(accent(x, arrow))arrow.b$, allora l'esecuzione di $M$ su $accent(x, arrow)$ termina con $f(accent(x, arrow)) + 1$ "uni" (1) sul nastro.
  - Se $f(accent(x, arrow))arrow.t$, $M$ non termina su $accent(x, arrow)$.
]

#index[Tesi di Church]
#proposition[La classe delle funzioni parziali computabili coincide con la classe delle funzioni parziali $tau$-ricorsive.]
Questa è la *forma generalizzata* della tesi di Church, che inizialmente avevamo presentato solo per funzioni totali. Si evidenzia che il modello della MdT è in grado di descrivere il comportamento di qualunque algoritmo, inclusa la sua capacità (o incapacità) di terminare.
#proposition()[
  $forall M$ MdT standard, $forall k in NN space exists!$ funzione parziale computabile $f: NN^k --> NN$ t.c. $M$ calcola $f$.
]
#proof()[\
  Definisco $f$ funzione parziale da $NN^k$ in $NN$ come segue:\
  $forall accent(x, arrow) in NN^k$, eseguo $M$ su $accent(x, arrow)$:
  - Se $M$ termina, $f(accent(x, arrow))$ è dato in unario dal numero di "uni" che si trovano sul nastro al termine dell'esecuzione.
  - Se $M$ non termina, $f(accent(x, arrow))arrow.t$.
]

#index[Codifica delle MdT]#index[Enumerazione delle MdT]
#proposition()[
  L'insieme delle MdT è enumerabile (ovvero, esiste un algoritmo che genera in ordine lessicografico e per lunghezza crescente tutte le MdT).
]
#proof()[\
  La strategia che si utilizza è quella di codificare ogni MdT con una stringa binaria.
  - *Codifica degli stati*: ogni stato viene codificato con il suo indice scritto in unario.
  $
    Q = {q_0, q_1, dots} arrow.squiggly q_i --> underbrace(11 dots 1, i+1)
  $
  - *Codifica dei simboli dell’alfabeto*: ogni simbolo viene codificato con il suo indice scritto in unario.
  $
    Sigma = {a_0, a_1, a_2, dots, a_n} arrow.squiggly a_i --> underbrace(11 dots 1, i+1)
  $
  - *Codifica di ${D, S}$*: codificati a partire da un $n$ arbitrario scritto in unario:
  $
    D --> underbrace(11 dots 1, n+2) quad S --> underbrace(11 dots 1, n+3)
  $
  - *Codifica di una transizione*:
  $
    q_h a_i alpha q_k --> underbrace(11 dots 1, h+1) 0 underbrace(11 dots 1, i+1) 0 underbrace(11 dots 1, "cod"(alpha)) 0 underbrace(11 dots 1, k+1)
  $
  - Lo 0 è l’elemento separatore tra gli elementi della quadrupla:
    - 1 zero separa i simboli;
    - 2 zeri separano le transizioni;
    - 3 zeri inizio e fine della codifica della MdT (utile nel caso in cui la MdT debba essere data in pasto ad un'altra MdT).
    - in questo modo si può definire una *lista delle transizioni*:
      #align(center, [000"TR1"00"TR2"00...00"TRn"000])

  #example("Codifica dell'intera MdT")[
    - $q_0 * D q_0$
    - $q_0 1 D q_1$
    - $q_1 1 D q_1$
    $
      & q_0 <-> 1    && q_1 <-> 11 \
      & 1<->1        && *<->11 \
      & D<->111 quad && S<->1111
    $
    La MdT viene codificata come:
    $
      000 1011011101 00 1010111011 00 11010111011 000
    $
  ]
  Definita la codifica, è possibile definire un algoritmo di enumerazione per le MdT: genera in ordine lessicografico e per lunghezza crescente tutte le stringhe binarie su ${0,1}$, per ognuna di esse effettua un controllo sintattico e, se rappresenta una MdT, la scrivo.

  #observation()[
    Questo algoritmo può essere visto come un algoritmo per enumerare le funzioni unarie parziali computabili ($tau$-ricorsive):
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

#index[Insieme K]
#theorem()[
  Sia $K= { a in NN | overbracket(M_a "termina quando la eseguo su a", f_a (a)↓)}$, con $M_a$ che rappresenta la $a$-esima
  MdT prodotta dall'algoritmo di enumerazione precedente.
  1. $K$ è semidecidibile
  2. $K$ non è decidibile.
]
#proof()[
  1. Dobbiamo definire un algoritmo di semidecisione per $K$: dato $a in NN$, eseguo l'algoritmo di enumerazione delle MdT per ottenere $M_a$, quindi eseguo $M_a$ su $a$:
    - Se $M_a (a)$ termina, allora $a in K$;
    - Altrimenti, l'esecuzione di $M_a$ su $a$ non termina.

  2. Supponiamo per assurdo che $K$ sia decidibile, cioè abbiamo un algoritmo di decisione per $K$. Definiamo la funzione unaria $f: NN -> NN$ in questo modo:
  $
    f(n) = cases(
      f_n (n)+1 & "se" n in K,
      0 & "se" n in.not K
    )
  $
  Poiché sto supponendo che $K$ abbia un algoritmo di decisione, allora $f$ è computabile, quindi dato $n in NN$ posso decidere se $n in K$ (se sì calcolo $f(n)+1$, altrimenti scrivo 0). Dunque $f$ deve comparire nella lista delle funzioni parziali computabili unarie, cioè $exists overline(n) in NN: f=f_(overline(n))$.\
  Calcolo $f(overline(n))$:
  - Se $overline(n) in K$, allora $f_(overline(n)) (overline(n)) arrow.b$ e vale $f(overline(n)) = f_(overline(n)) (overline(n)) + 1$; ma da $f = f_(overline(n))$ si ha $f_(overline(n)) (overline(n)) = f_(overline(n)) (overline(n)) + 1$, che è assurdo.

  - Se $overline(n) in.not K$, allora $f(overline(n)) = 0$ per definizione di $f$; ma $overline(n) in.not K$ significa $f_(overline(n)) (overline(n)) arrow.t$ e, poiché $f = f_(overline(n))$, si dovrebbe avere $f(overline(n)) arrow.t$, mentre invece converge a 0: assurdo.
  Quindi è assurdo che $K$ sia decidibile.
]

== Problema dell'arresto (Halting problem)
#index[Problema dell'arresto]
#definition("Problema dell'arresto")[
  Data una MdT $M$ e un numero naturale $n$, determinare se $M$ su input $n$ termina.
]

#theorem("Teorema dell'arresto V1")[
  L'insieme $R={(n,m) in NN^2 | M_n "termina su" m}$ è semidecidibile ma non è decidibile   (il problema dell'arresto è indecidibile).
]
#proof()[\
  Se per assurdo $R$ fosse decidibile, allora potrei decidere, in particolare, se $(n,n) in R space (forall n in NN)$. Ma tale "sottoproblema" è equivalente al problema di decisione per $K$, che abbiamo dimostrato essere indecidibile.
]

Una definizione alternativa del problema dell'arresto è:
#definition()[
  Data una MdT $M$ e una stringa $w$, determinare se $M$ su input $w$ termina.
]
Tale definizione è equivalente perché:
- Ogni numero naturale si può codificare come stringa di un opportuno alfabeto,
- Ogni stringa su un alfabeto può essere codificata da un numero naturale. Questo secondo punto (e quindi il fatto che le due definizioni siano equivalenti) è garantito in particolare dalla *funzione di Gödelizzazione*:
#index[Funzione di Gödelizzazione]
#definition("Funzione di Gödelizzazione")[
  Dato l'insieme dei numeri primi $P={2,3,5,7,dots}={p_1,p_2,p_3,dots}$ e l'alfabeto numerabile $Sigma={a_1,a_2,a_3,dots}$, definisco funzione di Gödelizzazione la funzione $accent(g, dot.double): Sigma^* -> NN$ che associa un numero a una stringa costituita dai simboli di $Sigma$:
  $
    a_(i_1) a_(i_2) dots a_(i_n) --> p_1^(i_1) p_2^(i_2) dots p_n^(i_n)
  $
  Allora possiamo dire che:
  1. $accent(g, dot.double)$ è computabile.
  2. $accent(g, dot.double)$ è iniettiva.
  3. $accent(g, dot.double)(Sigma^*)$ è decidibile.
  4. Se $m in accent(g, dot.double)(Sigma^*)$, esiste un algoritmo per calcolare $w in Sigma^*$ tale che $accent(g, dot.double)(w)=m$
]

#figure(image("images/diagrammaProblemi.png", width: 50%))
Vediamo quindi la formulazione alternativa del Teorema dell'arresto, dal punto di vista dei linguaggi formali.
#index[Linguaggio del problema dell'arresto]
#definition()[
  Sia $cal(L)_("Halt")$ il *linguaggio del problema dell'arresto* definito nel seguente modo:
  $
    cal(L)_("Halt") = {R(M)w | M "termina su" w}
  $
  con $R(M)$ codifica binaria di $M$.
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
  Supponiamo per assurdo che $cal(L)_("Halt")^c$ sia semidecidibile. Sappiamo dal teorema precedente che anche $cal(L)_("Halt")$ è semidecidibile. Ma un linguaggio è decidibile se e solo se esso e il suo complementare sono entrambi semidecidibili, per cui $cal(L)_("Halt")$ sarebbe decidibile: assurdo, perché abbiamo dimostrato che non lo è.
]
#index[MdT universale]
#definition()[
  Una *MdT universale* $M$ è una MdT che, su input $R(M)w$, simula l'esecuzione di $M$ su _w_.
]
#proposition()[
  Esiste una MdT universale che calcola le funzioni parziali computabili unarie.
]
#observation()[
  La MdT universale è un concetto fondamentale per la teoria della computabilità e per l'informatica tutta. Essa dimostra che esiste un'unica macchina in grado di simulare qualsiasi altra macchina, a condizione che le informazioni sulla macchina da simulare e il suo input siano fornite in un formato appropriato. In particolare introduce il concetto di "programma come dato", che troviamo in molti contesti informatici, tra cui:

  - *Interpreti:* se $R(M)$ è il codice sorgente, $w$ sono i dati di input passati al programma, allora la MdT universale $U$ è l'interprete che legge il codice riga per riga e ne simula il comportamento su _w_.

  - *Sistemi Operativi:* il SO è esso stesso un programma in esecuzione e agisce come una MdT universale. Tratta i file eseguibili come codifiche $R(M)$, li carica dal disco alla RAM e ne fa simulare/eseguire il comportamento dalla CPU.
  
  - *Architettura di Von Neumann:* l'impatto della MdT universale riguarda anche l'hardware. Proprio come una MdT universale $U$ accetta sul suo nastro sia la codifica $R(M)$ che i dati $w$, questa architettura memorizza indistintamente *istruzioni* e *dati* nella stessa Memoria Centrale (RAM). Questo permette a un'unica CPU (hardware fisso) di comportarsi come infinite macchine diverse (simularne il comportamento) semplicemente cambiando i dati in memoria, senza dover modificare l'hardware.
]

== Riducibilità fra linguaggi
Un tema centrale della teoria della computabilità è quello di stabilire se un problema è decidibile o meno. Uno strumento fondamentale per affrontare questo problema è la riducibilità fra linguaggi, che permette di confrontare la complessità di diversi problemi e di trasferire risultati di decidibilità da un linguaggio all'altro.
#index[Riduzione]
#definition()[
  $L_1, L_2$ linguaggi, $L_1 subset.eq Sigma_1^*, L_2 subset.eq Sigma_2^*$. Diciamo che $L_1$ è *riducibile* a $L_2$ quando $exists space f:Sigma_1^* --> Sigma_2^*$ t.c.

  + $f$ è computabile;
  + $forall w in Sigma_1^*, w in L_1 <==> f(w) in L_2$
  $f$ si dice (funzione di) *riduzione* da $L_1$ a $L_2$.
]

#proposition()[
  + $f$ è una riduzione da $L_1$ a $L_2$ e $L_2$ è decidibile $=> L_1$ decidibile
    \ (vale anche semidecidibile $=>$ semidecidibile)
  + $f$ è una riduzione da $L_1$ a $L_2$ e $L_1$ è indecidibile $=> L_2$ indecidibile
]

#proof()[
  (solo del punto 1)
  $F$ MdT che calcola $f$. $M_2$ MdT che decide $L_2$. MdT che decide $L_1$ su $w in Sigma_1^*$:
  - uso $F$ per calcolare $f(w) in Sigma_2^*$;
  - uso $M_2$ per decidere se $f(w) in L_2$
]
#example(multiple: true)[
  + $L_1 = {u u | u = a^i b^i c^i, i>=0} subset.eq {a,b,c}^*$
    \ $L_2 = {a^i b^i c^i, i>=0} subset.eq {a,b,c}^* -->$ decidibile, $M_2$ MdT che decide $L_2$
    \ MdT che realizza (calcola) una riduzione da $L_1$ a $L_2$ su input $w in {a,b,c}^*$:
    - controlliamo se $w = u u$, per qualche $u in {a,b,c}^*$
    - se non è così, cancello _w_ e scrivo _a_
    - se $w = u u$, cancello la seconda metà di _w_, mantenendo solo _u_

  + $Sigma_1 = {x,y}, Sigma_2 = {a}$. $L = {(x y^n) in Sigma_1^*| n >= 0}, Q={a^(2n) in Sigma_2^* | n >= 0}.$ Vogliamo trovare una riduzione da $L$ a $Q$, ossia una funzione $f: Sigma_1^* --> Sigma_2^*$ t.c. $w in L <==> f(w) in Q$. La strategia della MdT che calcola $f$ è la seguente:
    - se l'input $w$ è della forma corretta $x y^n$ la macchina produce in output la stringa vuota $epsilon$ (la più semplice accettata da $Q$);
    - altrimenti, la macchina produce in output una singola "a" (lunghezza dispari, non accettata da $Q$).
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 12mm,
    spacing: (1mm, 4mm),
    label-size: 10.5pt,

    // --- Flusso Input Valido (xy*) ---
    node((0, 0), $q_0$, name: <0>),
    node((3, 0), $q_1$, name: <1>),
    node((6, 0), $q_2$, name: <2>),
    node((9, 0), $q_3$, name: <3>),
    node((9, 2), $q_(3a)$, name: <3a>, shape: circle),

    // --- Flusso Errore ---
    node((6, 2), $q_4$, name: <4>),
    node((3, 2), $q_5$, name: <5>),
    node((3, 3.5), $q_(5a)$, name: <5a>, shape: circle),
    node((0, 2), $q_6$, name: <6>),
    node((0, 3.5), $q_7$, name: <7>),

    // --- TRANSIZIONI DI SUCCESSO ---
    edge(<0>, <1>, "-|>", $* \/ D$),
    edge(<1>, <2>, "-|>", $x \/ D$),
    edge(<2>, <2>, "-|>", $y \/ D$, bend: -130deg, loop-angle: -90deg),
    edge(<2>, <3>, "-|>", $* \/ S$),

    // cancellazione: Scrive * andando in q3a, poi si sposta a S tornando in q3
    edge(<3>, <3a>, "-|>", $x,y \/ *$, bend: -30deg),
    edge(<3a>, <3>, "-|>", $* \/ S$, bend: -30deg),

    // --- TRANSIZIONI DI ERRORE ---
    // Ingressi allo stato di scorrimento q4
    edge(<1>, <4>, "-|>", $y \/ D$),
    edge(<2>, <4>, "-|>", $x \/ D$),
    // Ingresso diretto a q5 per stringa vuota
    edge(<1>, <5>, "-|>", $* \/ S$),

    // Fase 1 Errore: Scorri a destra fino al blank (qui facciamo 1 sola azione: D)
    edge(<4>, <4>, "-|>", $x,y \/ D$, bend: -130deg, loop-angle: 90deg),
    edge(<4>, <5>, "-|>", $* \/ S$),

    // Fase 2 Errore:  cancellazione
    edge(<5>, <5a>, "-|>", $x,y \/ *$, bend: 30deg),
    edge(<5a>, <5>, "-|>", $* \/ S$, bend: 30deg),

    // Fase 3 Errore: Scrittura 'a' e termine
    edge(<5>, <6>, "-|>", $* \/ D$),
    edge(<6>, <7>, "-|>", $* \/ a$),
  ))
]
#pagebreak()
== Problema del nastro vuoto (Blank Tape Problem)
#index[Problema del nastro vuoto (BTP)]
#problem()[
  Data una MdT $M$, determinare se l'esecuzione di $M$ termina su nastro vuoto.
]

#proposition()[
  BTP è indecidibile.
]

#proof()[
  Descriviamo una riduzione dal problema dell'arresto al problema del nastro vuoto
  $
    cal(L)_("HALT")={R(M)w | M "termina su" w}; cal(L)_("BTP") = {R(M) | M "termina su nastro vuoto"}
  $
  data _x_ stringa:
  - se _x_ *non* è della forma $R(M)w$, pongo $f(x)$ uguale a una stringa fissata che non codifica alcuna MdT (per esempio 1), così che $f(x) in.not cal(L)_("BTP")$;
  - altrimenti, se $x = R(M)w$, costruisco la stringa $R(N)$, con $N$ MdT, t.c. N opera come segue, su input _y_:
    - se $y != epsilon$, N si comporta come M
    - se $y = epsilon$, scrivo _w_ sul nastro ed eseguo M su _w_

    dove $epsilon$ è la stringa vuota. Osserviamo che:
    - se M termina su _w_ $==>$ N termina su $epsilon$
    - se M non termina su _w_ $==>$ N non termina su $epsilon$
    $ R(M)w in cal(L)_("HALT") <==> R(N) in cal(L)_("BTP") $
]

== Teorema di Rice

Data una MdT $M$ e il linguaggio semidecidibile $L = L(M)$ associato ad $M$, possiamo chiederci se $L$ possiede certe proprietà:

- La stringa vuota appartiene al linguaggio?\
  $cal(L)_epsilon={R(M) | epsilon in L(M)}$
- Il linguaggio è vuoto?\
  $cal(L)_emptyset={R(M) | L(M) = emptyset}$
- Il linguaggio è $Sigma^*$? (la $M$ accetta tutte le possibili stringhe di $Sigma^*$)\
  $cal(L)_(Sigma^*)={R(M) | L(M) = Sigma^*}$
- Il linguaggio è regolare?)\
  $cal(L)_"REG" = {R(M) | L(M) "è regolare"}$

#proposition()[
  $cal(L)_(Sigma^*)$ non è decidibile
]
#proof()[
  Descriviamo una riduzione da $cal(L)_"HALT"$ a $cal(L)_(Sigma^*)$, costruendo una macchina $N$ a partire da una macchina $M$ e da una stringa _w_ in input:\
  $
    R(M)w arrow.long.squiggly R(N)
  $
  Comportamento di _N_ su input _y_:
  - cancello _y_;
  - scrivo _w_;
  - eseguo _M_ su _w_:

    + se $R(M)w in cal(L)_"HALT"$, ovvero _M_ termina su _w_, allora _N_ termina su ogni $y$, quindi $R(N) in cal(L)_(Sigma^*)$ (cioè $L(N) = Sigma^*$);

    + se $R(M)w in.not cal(L)_"HALT"$, ovvero _M_ non termina su _w_, allora _N_ non termina su nessun $y$, quindi $R(N) in.not cal(L)_(Sigma^*)$ (cioè $L(N) = emptyset$).
    Poiché non abbiamo un algoritmo per decidere $cal(L)_"HALT"$, non possiamo avere un algoritmo per decidere $cal(L)_(Sigma^*)$, che quindi è indecidibile.
]

Adesso generalizziamo questo concetto di proprietà di un linguaggio semidecidibile e sua decidibilità.
#index[Proprietà banale]
#definition()[
  Indichiamo con $cal(P)$ una qualunque *proprietà di un linguaggio semidecidibile* e con $cal(L)_cal(P)$ l'insieme di linguaggi semidicidibili che soddisfano $cal(P)$, cioè
  $
    & cal(L)_cal(P)= { L "semidecidibile" | L "soddisfa" cal(P)} "o, equivalentemente," \
    & cal(L)_cal(P)={R(M) | L(M) "soddisfa" cal(P)}
  $

  Allora $cal(P)$ si dice *banale* quando:
  - $forall$ linguaggio $L$ semidecidibile, $L in cal(L)_cal(P)$(ovvero tutti i linguaggi semidecidibili soddisfano $cal(P)$), oppure
  - $cal(L)_cal(P) = emptyset$ (ovvero nessun linguaggio semidecidibile soddisfa $cal(P)$)
]

#index[Teorema di Rice]
#theorem("di Rice")[
  $cal(P)$ proprietà non banale
  $
    cal(L)_cal(P)={R(M) | L(M) "soddisfa" cal(P)} ==> cal(L)_cal(P) "non è decidibile"
  $
]
#proof()[
  + $cal(P)$ proprietà non banale. Supponiamo che il linguaggio vuoto $emptyset$ non soddisfi la proprietà $cal(P)$ e sia _L_ un linguaggio semidecidibile che soddisfa $cal(P)$ ($L eq.not emptyset$). Sia $M_L$ la MdT che accetta _L_.\
    Descriviamo una riduzione da $cal(L)_"HALT"$ a $cal(L)_cal(P)$\
    $ R(M)w arrow.long.squiggly R(N) $
    Comportamento di _N_ su _y_:
    - scrivo _w_ a destra di _y_;
    - eseguo _M_ su _w_:
      + se _M_ termina su _w_ ($R(M)w in cal(L)_"HALT"$), eseguo $M_L$ su _y_, cioè _N_ si comporta come $M_L$, quindi: $L(N)=L(M_L)=L$, e _L_ soddisfa $cal(P) ==> R(N) in cal(L)_cal(P)$
      + se _M_ non termina su _w_ ($R(M)w in.not cal(L)_"HALT"$), _N_ non accetta nessuna stringa _y_, quindi: $L(N)=emptyset in.not cal(L)_cal(P) ==> R(N) in.not cal(L)_cal(P)$
    #figure(image("images/rice.png", width: 35%))
    Quindi, non avendo un algoritmo per decidere $cal(L)_"HALT"$, non possiamo avere un algoritmo per decidere $cal(L)_cal(P)$.
  + $cal(P)$ proprietà non banale. Supponiamo che il linguaggio vuoto $emptyset$ soddisfi la proprietà $cal(P)$: allora  $emptyset$ non soddisfa $not cal(P)$. Essendo $cal(P)$ non banale, lo è anche $not cal(P)$ e quindi per il punto 1 di questa dimostrazione $cal(L)_(not cal(P))$ non è decidibile.\ Supponiamo per assurdo che $cal(L)_cal(P)$ sia decidibile. Allora si ha che $cal(L_P)^c = cal(L)_(not cal(P)) union {"stringhe che non codificano MdT"}$ deve essere decidibile, e dunque anche  $cal(L)_(not cal(P))$: assurdo.

  #figure(image("images/rice2.png", width: 35%))
]
#example(multiple: true)[
  1. Data $M$ MdT, determinare se $L(M)$ ha la seguente proprietà: se $w = w_1, dots, w_n in L(M)$, allora $w^R = w_n, dots, w_1 in L(M)$ (chiusura rispetto alla stringa inversa).\

    Posso applicare il teorema di Rice, perché la proprietà è non banale: per esempio, il linguaggio che contiene solo la stringa "0" soddisfa la proprietà, ma il linguaggio che contiene solo "10" non la soddisfa. Quindi il problema è indecidibile.

  2. Data $M$ MdT, determinare se l'insieme degli stati di $M$ ha cardinalità maggiore di 50, nell'ipotesi che non ci siano stati inutili (ciò che si vuole è stabilire se questo problema è decidibile o meno).\

    Non posso applicare il teorema di Rice, perchè la proprietà è basata su un attributo "strutturale" della macchina (il numero di stati) e non su una proprietà del linguaggio. Cioè, per esempio, potrei avere una macchina $M_1$ con soli 2 stati che accetta un linguaggio $L$, e un'altra macchina $M_2$ con 100 stati che accetta lo stesso linguaggio $L$: si ha $L(M_1) = L(M_2)$, cioè entrambe le macchine accettano il linguaggio, ma la proprietà richiesta vale solo per $M_2$ per come è implementata la macchina.\ In questo caso il problema è decidibile, perché posso contare gli stati di $M$ scorrendo la codifica della MdT e verificare se sono più di 50.
]
#definition()[
  $M$ MdT è *riproducibile* quando $exists$ $M' != M$ t.c. $L(M) = L(M')$.
]
#observation()[
  Ogni MdT è riproducibile (basta aggiungere stati/transizioni inutili).
]
#example(multiple: true)[
  1. Dato un linguaggio semidecidibile $L$, determinare se esiste una MdT riproducibile $M$ che accetta $L$.\

    Questo è decidibile, in quanto  tutti i linguaggi hanno tale proprietà (vedi osservazione sopra).

  2. Dato un linguaggio semidecidibile $L$, determinare se $exists$ MdT riproducibile con meno di 10 stati che accetta $L$:\

    $cal(L) = {R(M) | L(M) "è accettato da una MdT riproducibile con meno di 10 stati"}$.\ Ci sono linguaggi che sono accettati da MdT con meno di 10 stati e ci sono linguaggi accettati da solo da MdT con più di 10 stati (per esempio un linguaggio fatto da stringhe lunghe più di 10 caratteri). La proprietà è non banale, quindi per il teorema di Rice $cal(L)$ non è decidibile.
]
Riprendiamo in mano la tesi di Church.
#proposition()[
  Ogni funzione $mu$-ricorsiva è $tau$-ricorsiva.
]
#proof()[
  (un'idea della dimostrazione). Per induzione strutturale sulla costruzione di una funzione $mu$-ricorsiva. Dobbiamo mostrare che ogni funzione che si trova in coda ad una derivazione $mu$-ricorsiva è calcolabile da una MdT (ovvero è $tau$-ricorsiva).

  1. *Caso base*: le funzioni iniziali $C_0^(k)$, $S$ e $epsilon_j^(k)$ sono $tau$-ricorsive: una MdT per il calcolo del successore l'abbiamo già vista, la funzione costante zero invece è calcolata da una MdT che cancella l'input e scrive un singolo "1" (zero in unario) e infine le proiezioni sono calcolate da MdT che scansionano il nastro e mantengono solo l'argomento $j$-esimo cancellando gli altri.
  2. *Passo induttivo*: supponiamo che le funzioni che compongono la derivazione $mu$-ricorsiva siano $tau$-ricorsive:
    - *Composizione generalizzata*:
      sia $f(arrow(x)) = h(g_1(arrow(x)), dots, g_m(arrow(x)))$. Per ipotesi induttiva, esistono le MdT $G_1, dots, G_m$ e $H$ che calcolano rispettivamente le funzioni $g_1, dots, g_m$ e $h$. La MdT che calcola $f$ opera nel seguente modo:
      - *Copia degli argomenti*: scrive sul nastro i parametri dell'input $arrow(x)$ (separati da una cella vuota) e ne crea una copia.
      - *Calcolo dei componenti*: utilizza la MdT $G_1$ per calcolare il primo argomento di $h$. Successivamente, effettua una nuova copia dei parametri $arrow(x)$ e usa la MdT $G_2$ per calcolare il secondo argomento, proseguendo così per tutti i $g_i$.
      - *Esecuzione della funzione esterna*: una volta ottenuti sul nastro tutti i valori $g_1(arrow(x)), dots, g_m (arrow(x))$, la macchina esegue la MdT $H$ su tali risultati per ottenere il valore finale $h(g_1, dots, g_m)$.
      - *Pulizia*: il nastro viene ripulito dai parametri iniziali e dai calcoli intermedi, scrivendo il risultato finale e sovrascrivendo i dati di partenza.

    - *Ricorsione primitiva (RP)*:
      sia $f$ definita per RP da $g$ e $h$. Per ipotesi induttiva, esistono le MdT $G$ e $H$ che calcolano tali funzioni. La MdT che calcola $f(arrow(x), y)$ implementa il seguente processo iterativo:
      - *Inizializzazione*: scrive sul nastro gli argomenti $arrow(x)$ (separati da una cella vuota) e il valore di $y$. Aggiunge in fondo un contatore $i$ (inizialmente $0$) e una copia dei parametri $arrow(x)$.
      - *Caso Base ($i=0$)*: la macchina usa la MdT $G$ per calcolare il valore iniziale $f(arrow(x), 0) = g(arrow(x))$. Se l'input $y$ era $0$, la computazione termina qui dopo la pulizia del nastro.
      - *Ciclo di aggiornamento*: se $y > i$, la macchina procede per passi successivi:
        - Incrementa il contatore di uno ($i -> i+1$).
        - Riscrive sul nastro gli argomenti $arrow(x)$, il contatore $i$ e il valore della funzione $f$ calcolato al passo precedente.
        - Esegue la MdT $H$ per ottenere il nuovo valore $f(arrow(x), i+1)$.
      - *Terminazione*: il ciclo si ripete finché il contatore raggiunge il valore desiderato ($i = y$). A quel punto, la macchina pulisce il nastro e restituisce il risultato finale $f(arrow(x), y)$.

    - *Minimalizzazione*:
      sia $g$ una funzione regolare e $f(arrow(x)) = min{y | g(arrow(x), y) = 0}$. Per ipotesi induttiva, esiste la MdT $G$ che calcola $g$. La MdT che calcola $f$ implementa un ciclo di ricerca:
      - *Preparazione*: scrive sul nastro i valori $arrow(x)$ separati da una cella vuota e un contatore $y$ inizializzato a $0$. Crea anche una copia di $arrow(x)$ e del contatore $y$.
      - *Verifica della condizione*: utilizza la MdT $G$ per calcolare il valore di $g(arrow(x), y)$.
      - *Controllo dello zero*:
        - se $g(arrow(x), y) = 0$, la ricerca è terminata: la macchina cancella i dati ausiliari e restituisce il valore attuale del contatore $y$.
        - se $g(arrow(x), y) != 0$, la macchina incrementa il contatore $y -> y+1$ e torna al passo di verifica per calcolare $g(arrow(x), y+1)$.
      - *Garanzia di arresto*: poiché $g$ è regolare per definizione, esiste certamente un valore di $y$ che annulla la funzione; questo garantisce che la MdT troverà il minimo in tempo finito e terminerà la computazione.
    Dato che tutti i costruttori delle funzioni $mu$-ricorsive possono essere simulati da una MdT, ogni funzione $mu$-ricorsiva è $tau$-ricorsiva
]
#pagebreak()
