#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *

= Macchine di Turing

// TODO: metere caption con i credits per l'immagine: https://aturingmachine.com/
#figure(image("images/turing-machine.png", width: 80%))

Introducendo le funzioni $mu$-ricorsive abbiamo visto una proposta di definizione di algoritmo, che restituisce formalmente l'idea intuitiva di funzione computabile. In questo capitolo vediamo una proposta equivalente del concetto di algoritmo: la *Macchina di Turing* (MdT). Una MdT ha le seguenti caratteristiche:

- è composta da un *nastro unidimensionale* infinito, sia da destra che da sinistra.
- Il nastro è diviso in *celle* che possono contenere informazioni.
- Le informazioni che si possono scrivere sul nastro sono *simboli* da un *alfabeto finito $Sigma$* definito inizialmente. Questo alfabeto contiene sempre un *simbolo privilegiato (\*)* che serve per denotare una *cella vuota* ed è normalmente implicito e non scritto tra i simboli dell'alfabeto.
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

  1)  #block($ quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ")q_1\
  &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\ $)
Questa è una macchina "inutile", nel senso che fa un passo e termina subito perchè non ci sono transizioni definite per lo stato $q_1$.\

  2)#image("images/example2TM.png",width: 65%)
  #block($ quad space &q_0 && * && D space && q_0 text(": Se la cella corrente è vuota, la testina si sposta a destra e non cambia stato")\
  &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
  &q_1 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e non cambia stato") $)
Quando la macchina è in $q_1$ non ha una transizione che descrive cosa fare incontrando una cella vuota quindi la macchina termina nel momento in cui finisce di scandire la prima "stringa" (sequenza) di 1 consecutivi.\

  3)#image("images/example3TM.png",width: 65%)
  #block($ quad space &q_0 && * && 1 space && q_0 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
  &q_0 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
  &q_1 && * && 1 && q_1 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
  &q_1 && 1 && 1 && q_0 text(": Se la cella corrente è 1, riscrivo 1 e cambio lo stato a ")q_0 $)
Questa macchina non termina mai e riempie il nastro di simboli 1.

  4)#image("images/example4TM.png",width: 65%)
   #block($ quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a") q_1\
  &q_1 && 1 && D && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ")\
  &q_1 && * && 1 && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ")q_2\
  &q_2 && 1 && S && q_2 text(": Se la cella corrente è 1, la testina si sposta a sinistra e non cambia lo stato") $)
Questa MdT aggiunge un simbolo 1 alla fine della stringa di 1 consecutivi e poi torna all'inizio del nastro. Quindi, se la stringa rappresenta un numero naturale in codifica unaria, questa MdT calcola il suo sucessore.
]

#index[MdT che calcola una funzione]
#definition()[
  Una Macchina di Turing (MdT) _M_ calcola una funzione $f: Sigma^* -> Sigma^*$ quando, scritta una stringa $w in Sigma^*$ sul nastro e posta la testina di _M_ sulla prima cella vuota a sinistra di _w_, dopo l'esecuzione di _M_ su _w_, la testina si trova nella prima cella vuota a sinistra dell'output $f(w)$.
]

#example()[
  Creiamo una MdT che calcola la funzione somma tra due numeri naturali rappresentati in codifica unaria (con il simbolo $1$). I numeri scelti in questo esempio sono 3 e 2:
  #figure(image("images/EsempioMdTSomma.png", width: 60%))
  #block($ &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ") q_1 $)
  #block($ &q_1 && space 1 space && D space && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ") $)
  #block($ &q_1 && * && 1 space && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ") q_2 $)
  #block($ &q_2 && space 1 space && D space && q_2 text(": Se la cella corrente è 1, la testina si sposta a destra e non cambia lo stato") $)
  #block($ &q_2 && * && S space && q_3 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ") q_3 $)
  #block($ &q_3 && space 1 && * space && q_3 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato") $)
  #block($ &q_3 && * && S space && q_4 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ") q_4 $)
  #block($ &q_4 && space 1 && * space && q_4 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato") $)
  #block($ &q_4 && * && S space && q_5 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ") q_5 $)
  #block($ &q_5 && space 1 space && S space && q_5 text(": Finché legge 1, la testina si sposta a sinistra; si ferma sulla cella vuota")\ & && && && quad quad text("a inizio stringa") $)
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

      edge(<qs>, <qf>, "-|>", $x \/ alpha$),))
#pagebreak()
== Tesi di Church (per le funzioni $tau$-ricorsive)
#index[Funzione $tau$-ricorsiva]
#definition()[
  Una funzione $f: NN^k -> NN$ si dice *$tau$-ricorsiva* quando $exists M$ MdT che calcola $f$
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
Accettazione di una stringa per stati finali:
- $Q$: insieme degli stati di una MdT
- $F subset.eq Q$: insieme degli stati finali

#index[Accettazione per stati finali]
#definition()[
  _M_ accetta la stringa  _w_ *per stati finali* quando l'esecuzione di _M_ su input _w_ termina in uno stato finale.
]
#definition()[
  $L subset.eq Sigma^*$ si dice *accettato per stati finali* da una MdT _M_ quando $w in L$ sse _M_ accetta _w_ per stati finali (quindi si ha $L = L(M)$)
]
#index[Linguaggio ricorsivamente enumerabile]
#definition()[
  Se _L_ è t.c. $exists M$ MdT per cui $L = L(M)$, _L_ si dice *ricorsivamente enumerabile*
]
#index[Linguaggio ricorsivo]
#definition()[
    Se _M_ è una MDT che termina su ogni input, allora $L(M)$ si dice *ricorsivo*
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
    #grid(
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
      grid.cell(align: center + horizon, diagram(
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
      )),
    )
    L'importante è che ad ogni errore corrisponda uno stato, non che ogni stato preveda errori $->$ la macchina è costruita per andare avanti soltanto se tutto funziona
]

=== Accettazione per arresto
#index[Accettazione per arresto]
#definition()[
  Una MdT $M$ accetta per arresto quando $M$, eseguita su _w_, termina.
]
L'insieme delle stringhe accettate da $M$ per arresto è il *linguaggio* accettato da $M$ per arresto

#proposition()[
  Dato un linguaggio $L$:
  #grid(
    columns: (0.15fr, 100pt, 40pt, 100pt, 0.15fr),
    align: (right, right, center + horizon, left, left),
    [], [$exists$ MdT $M$ che accetta $L$ per stati finali], [$<==>$], [$exists$ MdT $M$ che accetta $L$ per arresto], [],
  )
]

#proof()[
  \ $<==)$ Sia $N$ MdT che accetta $L$ per arresto. La MdT ottenuta da $N$, designando ogni stato come finale, è una MdT che accetta $L$ per stati finali.
  \ $==>)$ M MdT che accetta $L$ per stati finali. Su input _w_ ci sono 3 casi:
  - M termina su uno stato finale (OK, anche per arresto)
  - M non termina (OK, non accettata in entrambi i modi)
  - M termina ma in uno stato non finale: costruiamo una MdT $N$ in questo modo. $N$ ha le stesse transizioni di $M$ più le seguenti: $forall q in Q \\ F, forall x in Sigma $ t.c. non ci sono transizioni di $M$ con configurazione $q x$, aggiungiamo le transizioni $q x x accent(q, ~)$, $accent(q, ~) x x accent(q, ~)$ (dove $accent(q, ~)$ è un nuovo stato).

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
+ $L$ è accettato per *unico stato finale* quando $exists M$ MdT con un solo stato finale che accetta $L$. Dimostrare $L$ accettato per stati finali se e solo se $L$ è accettato per unico stato finale. *Dimostrazione*:
    \ $<==)$ Ovvio,
    \ $==>)$ $M$ MdT che accetta $L$ per stati finali. Costruiamo $N$ aggiungendo un nuovo stato $accent(q, ~)$ che M raggiungerà ogni volta che termina in uno stato finale (inoltre $accent(q, ~)$ sarà l'unico stato finale di $N$) $ space square$

+ $M$ accetta _w_ *per ingresso* quando, durante l'esecuzione di $M$ su un input _w_, la MdT entra in uno stato finale. Un linguaggio $L$ è accettato da $M$ per ingresso quando $exists M$ MdT  che accetta tutte e sole le stringhe di $L$ per ingresso. Dimostrare che $L$ è accettato per stati finali se e solo se $L$ è accettato per ingresso. *Dimostrazione*:
  \ $==>$) $M$ MDT che accetta _$L$_ per stati finali.\
  $M$' che accetta per ingresso si costruisce a partire da $M$, aggiungendo un nuovo stato $tilde(q)$ (che sarà l'unico stato finale) e transizioni che portano in $tilde(q)$ da ogni stato finale in corrispondenza di caratteri per cui non ci sono transizioni uscenti in $M$.

  $<==$) $M$ MDT che accetta _L_ per ingresso.\
  $M$' MDT che accetta $L$ per stati finali si ottiene da $M$ eliminando tutte le transizioni uscenti dagli stati finali $ space square$
]

== MdT multitraccia

#index[MdT multitraccia]
#definition()[
  MDT multitraccia con:
  - $Sigma$ alfabeto
  - $Q$ insieme degli stati

  Possiamo definirla come una lista di transizioni della forma (con k = numero tracce):
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
#proof()[
  $<==)$ Sia $M'$ una MdT con nastro limitato a sinistra che accetta $L$. Per simulare una computazione di $M'$ usando una MdT classica $M$, possiamo scrivere sul nastro un particolare simbolo, per esempio \#, che indichi che tale cella è quella iniziale. Quando una computazione di questa MdT cerca di portare la testina a sinistra di tale simbolo, facciamo in modo che un'altra computazione faccia terminare la MdT rifiutando la stringa.
  #figure(image("images/2026-03-11-12-09-22.png"))

  $==>)$ Sia $M$ una MdT classica che accetta $L$. Consideriamo una MdT $M'$ con nastro limitato a sinistra che abbia due tracce. Per simulare una computazione di $M$ su $M'$, si considera il nastro di $M$ (che è infinito sia a destra che a sinistra) e si assegna alla prima cella vuota a sinistra della stringa in input la posizione 0. A sinistra di tale  posizione avremo una numerazione  negativa delle celle, mentre alla sua destra  le celle avranno una numerazione  crescente positiva.
  #figure(image("images/2026-03-11-12-11-42.png"))

  Possiamo sistemare il contenuto a destra della posizione 0 nella prima traccia della MdT $M'$, mentre nella seconda traccia ci sarà l'eventuale contenuto delle celle a sinistra della posizione 0.
  #figure(image("images/2026-03-11-12-12-01.png"))

  In questo modo, a una transizione di $M$ che fa spostare la testina a sinistra della posizione 0 corrisponde una transizione di $M'$ che fa spostare la testina sulla seconda traccia. Essendo le MdT multitraccia accettate da MdT standard e viceversa, vale che $L$ è accettato da questa MdT limitata a sinistra.
]

== MDT multinastro

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

  $<==)$ M MdT a $k$ nastri che accetta $L$, facciamo vedere che esiste una MdT $M'$ a $2k+1$ tracce che accetta $L$. Più precisamente facciamo vedere che ogni singola transizione di una computazione di $M$ può essere simulata da un gruppetto di transizioni di $M'$.

  Poniamo $k=2$. Vogliamo cercare di simulare una singola transizione della MdT $M$ a 2 nastri con un gruppetto di transizioni di una MdT $M'$ a 5 tracce (perché $5 = 2k + 1$ con $k = 2$).
  #figure(image("images/2026-03-11-12-41-50.png"))

  - Le tracce 1 e 3 rappresentano il contenuto dei nastri 1 e 2 di $M$ rispettivamente;
  - Le tracce 2 e 4 rappresentano rispettivamente la posizione della testina nei nastri 1 e 2 di $M$ (la cella corrispondente alla posizione della testina contiene un particolare simbolo, per es. x);
  - La traccia 5 contiene nella prima posizione il solo simbolo \#, che serve per riposizionare la testina a inizio nastro.

  I passi con cui $M'$ simula una transizione di $M$ sono i seguenti:

  1. Prima vengono raccolte tutte le informazioni, riguardanti le celle lette sui due nastri. Queste informazioni possono essere memorizzate, ad esempio, definendo opportunamente l'insieme degli stati: la macchina, ogni volta che incontra il marcatore della traccia $i$, legge il simbolo corrispondente e lo memorizza cambiando il proprio stato interno.  Tecnicamente, l'insieme degli stati di $M'$ viene quindi esteso a un prodotto cartesiano del tipo $Q times (Sigma union {*})^k$, dove le componenti aggiuntive fungono da buffer temporaneo. Alla fine della scansione, lo stato di $M'$ contiene tutte le informazioni necessarie per decidere la transizione della macchina multinastro originale;
  2. Cerca sulla traccia 2 il simbolo x, che corrisponde alla posizione della testina del nastro 1 di $M$;
  3. Legge sulla traccia 1 il simbolo nella cella la cui posizione è indicata dalla x sulla traccia 2 e compie l'operazione di scrittura, se deve, altrimenti compie l'operazione di spostamento della testina operando sulla traccia 2 e riscrivendo la x in corrispondenza della sua nuova posizione;
  4. Torna all'inizio del nastro sfruttando la traccia 5, ovvero quando legge il simbolo \# si ferma (perché tale simbolo indica l'inizio del nastro);
  5. Cerca sulla traccia 4 il simbolo x, che corrisponde alla posizione della testina del nastro 2 di $M$;
  6. Legge sulla traccia 3 il simbolo nella cella la cui posizione è indicata dalla x sulla traccia 4 e compie l'operazione di scrittura, se deve, altrimenti compie l'operazione di spostamento della testina operando sulla traccia 4 e riscrivendo la x in corrispondenza della sua nuova posizione;
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
  Le MdT deterministiche (o standard) *sono* MdT non deterministiche, ma il viceversa non è sempre vero.
]

#definition()[
  Data una stringa _w_ e una MdT non deterministica M, diciamo che M *accetta* _w_ quando esiste una computazione di M che accetta _w_.
]

#example()[
  Dato l'alfabeto $Sigma={a, b, c}$ e un linguaggio _L_ definito su tale alfabeto t.c. $L={w in Sigma^* | exists$ $"un'occorrenza di "c" immediatamente preceduta da "a b" oppure immediatamente"$$"seguita da" a b}$
  #image("/assets/image-1.png")
  Nell'immagine cambiare i passaggi da q3 a q4 in b/b e da q6 a q7 a a/a
]

#index[Grado di non determinismo]
#definition()[
  Consideriamo una MdT M non deterministica tutte le sue transizioni in cui i primi due simboli sono fissati e gli ultimi due variabili, ovvero:
  $
    {(accent(q, tilde), accent(x, tilde), alpha, q) | alpha in Sigma union {D, S}, q in Q}
  $
  Il grado di non determinismo di M corrisponde al valore:
  $
    delta = max abs({(accent(q, tilde), accent(x, tilde), alpha, q) | alpha in Sigma union {D, S}, q in Q})
  $
  Calcolato al variare di $accent(q, tilde) in Q, accent(x, tilde) in Sigma$
]
Questo significa che il grado di non determinismo corrisponde al numero massimo di svolte che la macchina M può prendere in un'unica transizione, leggendo lo stesso input.

Applichiamo il tutto all'esempio precedente. Dato $q in Q, x in Sigma$, codifichiamo le transizioni di M MdT non deterministica, aventi _qx_ come primi 2 elementi, utilizzando gli interi da 1 a $delta$, possibilmente codifichiamo la stessa transizione con più etichette:

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
- $(2 2 3 2 2) -->$ termina prematuramente, cioè l'ultima transizione non viene eseguita;

#proposition()[
  _L_ è accettato da una MdT standard $<==>$ _L_ è accettato da una MdT non deterministica
]
#proof()[
  \ $==>$) M MdT standard che accetta _L_ poiché ogni MdT deterministica è anche una MdT non deterministica, _L_ è accettato da una MdT non deterministica.
  \ $<==$) M MdT non deterministica che accetta _L_ per arresto, con grado di non determinismo uguale a $delta$. Descriviamo una MdT standard che accetta _L_ per arresto a 3 nastri. I nastri sono: // TODO: disegnare i nastri
  + Input
  + Simulazione delle computazioni di M  (contenuto per disegno: $*"copio l'input ed elenco"$$(m_1,dots,m_k)$)
  + Generazione delle computazioni di M  (contenuto per disegno: $(m_1, m_2, dots, m_k)$ con $1 <= m_i <= delta$ per ogni $i$)
]


#index[Funzione parziale]
#definition()[
  Dati due insiemi _A_ e _B_, una funzione $f$ si dice *funzione parziale* da _A_ a _B_ quando esiste un sottoinsieme di A $exists D subset.eq A$ tale che $f: D --> B$ è una funzione
]

#index[Funzione totale]
#definition()[
  Una funzione parziale $f$ da _A_ a _B_ si dice *funzione totale* quando $D = A$, cioè quando $f$ è definita su tutto _A_
]

#index[Funzione parziale computabile]
#definition()[
  Una funzione parziale $f: A --> B$ si dice *parziale computabile* quando $exists M$ algoritmo t.c. $forall x in A:$
  - Se $x in "Dom"(f)$, M eseguito su _x_ restituisce in output $f(x) --> f$ *converge* su _x_, in simboli: $f(x)arrow.b$
  - Se $x in.not "Dom"(f)$, M su _x_ non termina $--> f$ *diverge* su _x_, in simboli: $f(x)arrow.t$
]

Lavoriamo su $NN$ in codifica unaria
#index[Funzione parziale τ-ricorsiva]
#definition()[
  Una funzione parziale $f: NN^k --> NN$ si dice *parziale $tau$-ricorsiva* quando $exists M$ MdT che, $forall accent(x, arrow) in NN^k:$
  - Se $f(accent(x, arrow))arrow.b$, allora l'esecuzione di M su $accent(x, arrow)$ termina con $f(accent(x, arrow)) + 1$ "uni" (1) sul nastro.
  - Se $f(accent(x, arrow))arrow.t$, M non termina su $accent(x, arrow)$.
]

=== Tesi di Church per funzioni parziali $tau$-ricorsive
#index[Tesi di Church]
#proposition[La classe delle funzioni parziali computabili coincide con la classe delle funzioni parziali $tau$-ricorsive]
Questa è la *forma generalizzata* della tesi di Church, che inizialmente avevamo presentato solo per funzioni totali. Si evidenzia che il modello della MdT è in grado di descrivere il comportamento di qualunque algoritmo, inclusa la sua capacità (o incapacità) di terminare.
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

#index[Codifica delle MdT]#index[Enumerazione delle MdT]
#proposition()[
  L'insieme delle MdT è enumerabile.
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
    q_h a_i alpha q_k --> underbrace(11 dots 1, h+1) 0 underbrace(11 dots 1, i+1) 0 underbrace(11 dots 1, "cod"(alpha)) 0 underbrace(11 dots 1, k+1)
  $
  - Lo 0 è l’elemento separatore tra gli elementi della quadrupla:
    - 1 zero separa i simboli;
    - 2 zeri separano le transizioni;
    - 3 zeri inizio e fine della codifica della MdT.

  Definita la codifica, è possibile definire un algoritmo di enumerazione per le MdT: genera in ordine lessicografico e per lunghezza crescente tutte le stringhe binarie su ${0,1}$, per ognuna di esse effettua un controllo sintattico, se rappresenta una MdT, la scrivo.

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
#example("Codifica dell'intera MdT")[
  - $q_0 * D q_0$
  - $q_0 1 D q_1$
  - $q_1 1 D q_1$
  $
    q_0 <-> 1 space q_1 <-> 11 space 1<->1 space *<->11 space D<->111 space S<->1111
  $
  La MdT viene codificata come:
  $
    000 1011011101 00 1010111011 00 11010111011 000
  $
]

#index[Insieme K]
#theorem()[
  Sia $K= { a in NN | M_a (a)↓ }$, con $M_a$ che rappresenta la $a$-esima
  MdT prodotta dall'algoritmo di enumerazione precedente ($M_a (a)↓$
  equivale a dire che $f_a (a) ↓$ ).
  1. K è semidecidibile
  2. K non è decidibile.
]
#proof()[
  1. Dato $a in NN$, eseguo l'algoritmo di enumerazione delle MdT per ottenere $M_a$, quindi eseguo $M_a$ su $a$:
    - Se $M_a (a) arrow.b$, allora $a in K$;
    - Altrimenti, l'esecuzione di $M_a$ su $a$ non termina.

    Questo è un algoritmo di semidecisione per $K$.

  2. Supponiamo per assurdo che $K$ sia decidibile. Definiamo la funzione unaria $f: NN -> NN$ in questo modo:
  $
    f(n) = cases(
      f_n (n)+1 & "se" n in K,
      0 & "se" n in.not K
    )
  $
  Poiché sto supponendo che $K$ sia decidibile, allora $f$ è computabile (grazie all'algoritmo di decisione per $K$). Dunque $f$ deve comparire nella lista delle funzioni parziali computabili unarie, cioè $exists overline(n) in NN: f=f_(overline(n))$.\
  Calcolo $f(overline(n))$:
  - Se $overline(n) in K$, allora $f_(overline(n)) (overline(n)) arrow.b$ e vale $f(overline(n)) = f_(overline(n)) (overline(n)) + 1$; ma da $f = f_(overline(n))$ segue $f(overline(n)) = f_(overline(n)) (overline(n))$, dunque $f_(overline(n)) (overline(n)) = f_(overline(n)) (overline(n)) + 1$, che è assurdo.

  - Se $overline(n) in.not K$, allora $f(overline(n)) = 0$ per definizione di $f$; ma $overline(n) in.not K$ significa $f_(overline(n)) (overline(n)) arrow.t$ e, poiché $f = f_(overline(n))$, dovrebbe essere $f(overline(n)) arrow.t$, mentre invece converge a 0: un altro assurdo.
]

== Problema dell'arresto (Halting problem)
#index[Problema dell'arresto]
#definition("Problema dell'arresto")[
  Data una macchina di Turing M e un numero naturale $n$, determinare se M su input $n$ termina.
]

#theorem("Teorema dell'arresto V1")[
  (Il problema dell'arresto è indecidibile) L'insieme $R={(n,m) in NN^2 | M_n "termina su" m}$ è semidecidibile ma non è decidibile.
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
- Ogni stringa su un alfabeto può essere codificata da un numero naturale.
Questo risultato è dato da:
#index[Funzione di Gödelizzazione]
#definition("Funzione di Gödelizzazione")[
  Dato l'insieme dei numeri primi $P={2,3,5,7,dots}={p_1,p_2,p_3,dots}$ e l'alfabeto numerabile (infinito) $Sigma={a_1,a_2,a_3,dots}$, definisco *funzione di Gödelizzazione* la funzione $accent(g, dot.double): Sigma^* -> NN$ che associa a una stringa costituita dai simboli di $Sigma$ un numero:
  $
    a_(i_1) a_(i_2) dots a_(i_k) --> p_1^(i_1) p_2^(i_2) dots p_k^(i_k)
  $
  Allora possiamo dire che:
  1. $accent(g, dot.double)$ è computabile.
  2. $accent(g, dot.double)$ è iniettiva.
  3. Se $m in accent(g, dot.double)(Sigma^*)$, esiste un algoritmo per calcolare $w in Sigma^*$ tale che $accent(g, dot.double)(w)=m$
]

//TODO: disegno degli insiemi dei problemi:
// tutti i problemi -> semidecidibili -> decidibili (cerchio più interno)

#index[Linguaggio del problema dell'arresto]
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
  Supponiamo per assurdo che $cal(L)_("Halt")^c$ sia semidecidibile. Sappiamo dal teorema precedente che anche $cal(L)_("Halt")$ è semidecidibile. Ma un linguaggio è decidibile se e solo se esso e il suo complementare sono entrambi semidecidibili, per cui $cal(L)_("Halt")$ sarebbe decidibile: assurdo, perché abbiamo dimostrato che non lo è.
]

#index[MdT universale]
#definition()[
  Una *MdT universale* è una MdT che, su input $R(M)w$, simula l'esecuzione di M su _w_.
]
#proposition()[
  Esiste una MdT universale che calcola le funzioni parziali computabili unarie.
]

#index[Riduzione]
#definition()[
  $L_1, L_2$ linguaggi, $L_1 subset.eq Sigma_1^*, L_2 subset.eq Sigma_2^*$
  \ Diciamo che $L_1$ è *riducibile* a $L_2$ quando $exists f:Sigma_1^* --> Sigma_2^* t.c.$
  + $f$ è computabile
  + $forall w in Sigma_1^*, w in L_1 <==> f(w) in L_2$
]

#proposition()[
  + $f$ è una riduzione da $L_1$ a $L_2$ e $L_2$ è decidibile $=> L_1$ decidibile
    \ (vale anche se semidecidibile $=>$ semidecidibile)
  + $f$ è una riduzione da $L_1$ a $L_2$ e $L_1$ è indecidibile $=> L_2$ indecidibile
]

#proof()[
  + #grid(
      columns: (.1fr, .3fr, .49fr, .1fr),
      align: (left, left, left, left),
      rows: 2,
      row-gutter: 10pt,
      // TODO: aggiungere linea verticale separatrice
      [],
      [$F$ MdT che calcola $f$   ],
      grid.cell(rowspan: 2, [
        MdT che decide $L_1$ su $w in Sigma_1^*$:
        \ $dot$ uso _F_ per calcolare $f(w) in Sigma_2^*$;
        \ $dot$ uso $M_2$ per decidere se $f(w) in L_2$
      ]),
      [],
      [], [$M_2$ MdT che decide $L_2$], [], [],
    )
]

#pagebreak()
#example(multiple: true)[
  + $L_1 = {u u | u = a^i b^i c^i, i>=0} subset.eq {a,b,c}^*$
    \ $L_2 = {a^i b^i c^i, i>=0} subset.eq {a,b,c}^* quad quad$ (decidibile) $M_2$ MdT che decide $L_2$
    \ MdT che realizza (calcola) una riduzione da $L_1$ a $L_2$ su input $w in {a,b,c}^*$:
    - controlliamo se $w = u u$, per qualche $u in {a,b,c}^*$
    - se non è così, cancello _w_ e scrivo _a_
    - se $w = u u$, cancello la seconda metà di _w_, mantenendo solo _u_

  + $Sigma_1 = {x,y}, Sigma_2 = {a}$
    \ $L = {(x y^n) in Sigma_1^*| n >= 0}, Q={a^(2n) in Sigma_2^* | n >= 0}$
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      label-size: 7pt,

      node((0, 0), $q_0$, name: <0>),
      node((3, 0), $q_1$, name: <1>),
      node((6, 0), $q_2$, name: <2>),
      node((3, 3), $q_3$, name: <3>),
      node((9, -1), $q_4$, name: <4>),
      node((12, -1), $q_5$, name: <5>),
      node((12, 1), $q_6$, name: <6>),
      node((9, 3), $q_7$, name: <7>),
      node((12, 3), $q_8$, name: <8>),

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
      edge(<5>, <7>, "-|>", $*\/D$, bend: -30deg),
      edge(<6>, <5>, "-|>", $*\/S$, bend: -30deg),
      edge(<7>, <7>, "-|>", $*\/a$, bend: 130deg, loop-angle: -135deg),
      edge(<7>, <8>, "-|>", $a\/b$),
    ))
]

== Problema del nastro vuoto (Blank Tape Problem)
#index[Problema del nastro vuoto (BTP)]
#problem()[
  Data una MdT M, determinare se l'esecuzione di M termina su nastro vuoto.
]

#proposition()[
  BTP è indecidibile
]

#proof()[
  Descriviamo una riduzione dal problema dell'arresto al problema del nastro vuoto
  #block(
    $
      cal(L)_("HALT")={R(M)w | M "termina su" w}; cal(L)_("BTP") = {R(M) | M "termina su nastro vuoto"}
    $,
  )
  data _x_ stringa:
  - se _x_ *non* è della forma $R(M)w$, pongo $f(x)$ uguale a una stringa fissata che non codifica alcuna MdT (per esempio 1), così che $f(x) in.not cal(L)_("BTP")$;
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

#index[Proprietà banale]
#definition()[
  Indichiamo con $cal(P)$ una qualunque *proprietà di un linguaggio semidecidibile* e con $cal(L)_cal(P)$ l'insieme di linguaggi semidicidibile che soddisfano $cal(P)$, cioè
  $
    & cal(L)_cal(P)= { L "semidecidibile" | L "soddisfa" cal(P)} "o, equivalentemente," \
    & cal(L)_cal(P)={R(M) | L(M) "soddisfa" cal(P)}
  $

  Allora $cal(P)$ si dice *banale* quando:
  - $forall$ linguaggio $L$ semidecidibile, $L in cal(L)_cal(P)$(ovvero tutti i linguaggi semidecidibili hanno la proprietà $cal(P)$), oppure
  - $cal(L)_cal(P) = emptyset$ (ovvero nessun linguaggio semidecidibile ha la proprietà $cal(P)$)
]

#index[Teorema di Rice]
#theorem("di Rice")[
  $cal(P)$ proprietà non banale
  $
    cal(L)_cal(P)={R(M) | L(M) "soddisfa" cal(P)} ==> cal(L)_cal(P) "non è decidibile"
  $
]
#proof()[
  + $cal(P)$ proprietà non banale. Supponiamo che il linguaggio vuoto $emptyset$ non soddisfi la proprietà $cal(P)$ e sia _L_ un linguaggio semidecidibile che soddisfa $cal(P)$, con $L eq.not emptyset$. Sia $M_L$ la MdT che accetta _L_.\
    Descriviamo una riduzione da $cal(L)_"HALT"$ a $cal(L)_cal(P)$\
    $ R(M)w arrow.long.squiggly R(N) $
    Comportamento di _N_ su _y_:
    // TODO: disegnare nastro
    - scrivo _w_ a destra di _y_;
    - eseguo _M_ su _w_:
      + se _M_ termina su _w_, eseguo $M_L$ su _y_, cioè _N_ si comporta come $M_L$, quindi:\
        $L(N)=L(M_L)=L$, e _L_ soddisfa $cal(P)$\
        $R(M)w in cal(L)_"HALT" => R(N) in cal(L)_cal(P)$
      + se _M_ non termina su _w_, _N_ non accetta nessuna stringa _y_, quindi:\
        $L(N)=emptyset in.not cal(L)_cal(P)$\
        $R(M)w in.not cal(L)_"HALT" => R(N) in.not cal(L)_cal(P)$

  + $cal(P)$ proprietà non banale. Supponiamo che il linguaggio vuoto $emptyset$ soddisfi la proprietà $cal(P)$, allora  $emptyset$ non soddisfa $not cal(P)$ e, per la dimostrazione precedente, $cal(L)_(not cal(P))$ non è decidibile

    Per assurdo: $cal(L)_cal(P)$ è decidibile $=> cal(L)_(not cal(P)) union {"stringhe che non codificano MdT"} "decidibile" => cal(L)_(not cal(P)) "decidibile, assurdo"$
]
