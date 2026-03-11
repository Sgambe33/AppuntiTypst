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

==== Tesi di church (per le funzioni $tau$-ricorsive)
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

==== MDT come accettatori di linguaggi
Accettazione di una stringa per stati finali:
- $Q$: insieme degli stati di una MDT
- $F subset.eq Q$: insieme degli stati finali

#definition()[
  _M_ accetta la stringa  _w_ *per stati finali* quando l'esecuzione di _M_ su input _w_ termina in uno stato finale.
]
#definition()[
  $L subset.eq Sigma^*$ si dice *accettato per stati finali* da una MDT _M_ quando $w in L$ sse _M_ accetta _w_ per stati finali $--> L = L(M)$
]

#observation()[
  - Se _L_ è t.c. $exists M$ MDT per cui $L = L(M))$, _L_ si dice *ricorsivamente enumerabile*
  - Se _M_ è una MDT che termina su ogni input, allora $L(M)$ si dice *ricorsivo*

  #underline("Via tesi di church"): *ric. enum. $<-->$ semidecidibile *e* ricorsivo $<-->$ decidibile*
]


#example(multiple: true)[
  +) MDT che accetta il linguaggio $(a|b)^* a a(a|b)^*$
  #image("/assets/image.png")
]

//TODO: AGGIUNGERE ULTIMA LEZIONE E SISTEMARE TUTTA LA PARTE NUOVA

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

==== MDT multitraccia

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

==== MDT limitata a sinistra

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

==== MDT multinastro

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
