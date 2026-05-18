#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: ellipse

#pagebreak()
= Automi

== Automi a stati finiti

#definition()[
  Un automa a stati finiti deterministico (DFA) è una quintupla $A=(Q, Sigma, delta, q_0, F)$.
  - $Q$ insieme finito degli stati.
  - $Sigma$ insieme dei simboli in ingresso.
  - $F subset Q$: stati finali o accettanti.
  - $delta$ è funzione di transizione (mi dice dove andare letto un simbolo):
    - $delta:(Q times Sigma) -> Q quad quad$ (stato, simbolo)$->$stato
    - $delta(q_i, a)=q_j$
  - $q_0 in Q$, stato iniziale
]

Un linguaggio è accettato da un automa A se $L(A)={w in Sigma^* bar w " è accettata da A"}$. $L(A)$ può essere definito in maniera equivalente come:
$
  L(A)={w in Sigma^* bar [q_0, w] der(*) [q, epsilon], q in F}
$

=== Diagrammi di transizione

#definition(
  "Diagramma di transizione",
)[
  Il diagramma di transizione di un automa $A = (Q, Sigma, delta, q_0 F)$ è un grafo G definito come segue:
  + Per ogni stato in $Q$ c'è un nodo nel grafo.

  + Per ogni stato $q in Q$ e ogni simbolo $a in Sigma$ se $delta(q, a) =p$, allora in $G$ c'è un arco etichettato $a$ dal nodo $q$ al nodo $p$. Se ci sono più simboli di input che determinano una transizione da $q$ a $p$, il grafo può avere un unico arco dal nodo $q$ al nodo $p$ etichettato con la lista di tali simboli.

  + C'è una freccia che arriva allo stato iniziale $q_0$ e non proviene da nessuno stato:
    #figure(diagram(
      node-stroke: .1em,
      spacing: 2em,
      edge((-1, 0), "r", "-|>", label-pos: 0, label-side: center),
      node((0, 0), radius: 1em),
    ))

  + I nodi corrispondenti agli stati accettanti sono indicati da due cerchi concentrici, gli altri da un cerchio semplice:
    #figure(
      diagram(node-stroke: .1em, spacing: 2em, node((0, 0), radius: 1em, extrude: (-2.5, 0)), node(
        (1, 0),
        radius: 1em,
      )),
    )
]
Per adesso considereremo solo automi in cui $delta$ è *totale* ovvero ad ogni simbolo in input è associato uno stato.

#example()[
  Data l'espressione regolare $"(a|b)*aaa(a|b)*"$ si ottiene il seguente automa:
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    node((-4, 0), [S]),
    node((-2, 0), [A]),
    node((0, 0), [B]),
    node((2, 0), [C], extrude: (-2, 0)),
    edge((-5.2, 0), (-4.0, 0), "-|>", []),
    edge((-4, 0), (-2, 0), "-|>", [a]),
    edge((-2, 0), (0, 0), "-|>", [a]),
    edge((0, 0), (2, 0), "-|>", [a]),
    edge((-4, 0), (-4, 0), "-|>", [b], bend: 130deg),
    edge((-2, 0), (-4, 0), "-|>", [b], bend: 50deg),
    edge((0, 0), (-4.3, 0), "-|>", [b], bend: 60deg),
    edge((2, 0), (2, 0), "-|>", [a,b], bend: 130deg),
  ))

  #observation()[
    E' possibile ottenere l'automa complementare (ovvero quello che accetta tutte le stringhe che non hanno tre "a" consecutive) trasformando tutti gli stati non accettanti in accettanti e viceversa.
  ]

  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    node((-4, 0), [S], extrude: (-2, 0)),
    node((-2, 0), [A], extrude: (-2, 0)),
    node((0, 0), [B], extrude: (-2, 0)),
    node((2, 0), [C]),
    edge((-5.2, 0), (-4.0, 0), "-|>", []),
    edge((-4, 0), (-2, 0), "-|>", [a]),
    edge((-2, 0), (0, 0), "-|>", [a]),
    edge((0, 0), (2, 0), "-|>", [a]),
    edge((-4, 0), (-4, 0), "-|>", [b], bend: 130deg),
    edge((-2, 0), (-4, 0), "-|>", [b], bend: 50deg),
    edge((0, 0), (-4.3, 0), "-|>", [b], bend: 60deg),
    edge((2, 0), (2, 0), "-|>", [a,b], bend: 130deg),
  ))
]

#theorem()[
  Sia $A=(Q, Sigma, delta, q_0, F)$ un DFA. Allora $A'=(Q, Sigma, delta, q_0, Q-F)$ è un DFA con $L(A')=Sigma^*-L(A)$.
]

#example(multiple: true)[
  + Stringhe su {a,b} che non iniziano con "aaa":
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      node((-4, -2), [S], extrude: (-2, 0)),
      node((-2, -2), [A], extrude: (-2, 0)),
      node((-2, 0), [B], extrude: (-2, 0)),
      node((-4, 0), [C], extrude: (-2, 0)),
      node((0, 0), [D]),
      edge((-5.2, -2), (-4.0, -2), "-|>", []), //Start
      edge((-4, -2), (-2, -2), "-|>", [a]), //S->A
      edge((-4, -2), (-4, 0), "-|>", [b]), //S->C
      edge((-2, -2), (-2, 0), "-|>", [a], label-sep: -15pt), //A->B
      edge((-2, -2), (-4, 0), "-|>", [b]), //A->C
      edge((-2, 0), (-4, 0), "-|>", [b], label-sep: -15pt), //B->C
      edge((-2, 0), (0, 0), "-|>", [a], label-sep: -15pt), //B->D
      edge((-4, 0), (-4, 0), "-|>", [a,b], bend: -130deg), //C->C
      edge((0, 0), (0, 0), "-|>", [a,b], bend: 130deg), //D->D
    ))

  + Stringhe su {a,b} che non contengono la sottostringa "aba":
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      node((-4, 0), [S], extrude: (-2, 0), name: <s>),
      node((-2, 0), [A], extrude: (-2, 0), name: <a>),
      node((0, 0), [B], extrude: (-2, 0), name: <b>),
      node((2, 0), [C], name: <c>),
      edge((-5.2, 0), (-4.0, 0), "-|>", []),
      edge(<s>, <s>, "-|>", [b], bend: 130deg),
      edge(<s>, <a>, "-|>", [a]),
      edge(<a>, <a>, "-|>", [a], bend: 130deg),
      edge(<a>, <b>, "-|>", [b]),
      edge(<b>, <s>, "-|>", [b], bend: 45deg),
      edge(<b>, <c>, "-|>", [a]),
      edge(<c>, <c>, "-|>", [a,b], bend: 130deg),
    ))
  + Stringhe su {a,b} in cui ogni "a" è preceduta o seguita da "b":
    #figure(diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      node((-2, 0), [S], extrude: (-2, 0), name: <s>),
      node((0, 0), [A], name: <a>),
      node((-2, 2), [B], extrude: (-2, 0), name: <b>),
      node((2, 0), [C], name: <c>),
      edge((-3.2, 0), (-2.0, 0), "-|>"),
      edge(<s>, <a>, "-|>", [a]),
      edge(<s>, <b>, "-|>", [b]),
      edge(<a>, <c>, "-|>", [a]),
      edge(<a>, <b>, "-|>", [b]),
      edge(<b>, <b>, "-|>", [b], bend: -130deg),
      edge(<b>, <s>, "-|>", [a], bend: 60deg),
      edge(<c>, <c>, "-|>", [a,b], bend: 130deg),
    ))
  + Stringhe su {a,b} dove $abs(w)_a$ e $abs(w)_b$ sono pari:
    #grid(
      columns: (.5fr, 1fr),
      align(center)[
        #table(
          columns: (auto, auto, auto),
          align: center,
          [],
          [$abs(w)_a$],
          [$abs(w)_b$],
          table.cell(fill: rgb("#68e86680"), "S"),
          [*_pari_*],
          [*_pari_*],
          [A],
          [_dispari_],
          [_pari_],
          [B],
          [_pari_],
          [_dispari_],
          [C],
          [_dispari_],
          [_dispari_],
        )
      ],
      align(center)[
        #diagram(
          node-stroke: 0.9pt,
          cell-size: 5mm,
          spacing: 3mm,
          node((-2.5, 0), [S], extrude: (-2, 0), name: <s>),
          node((0, 0), [A], name: <a>),
          node((-2.5, 2.5), [B], name: <b>),
          node((0, 2.5), [C], name: <c>),
          edge((-3.7, 0), <s>, "-|>"),
          edge(<s>, <a>, "-|>", [a], bend: 15deg),
          edge(<s>, <b>, "-|>", [b], bend: 15deg),
          edge(<a>, <s>, "-|>", [a], bend: 15deg),
          edge(<a>, <c>, "-|>", [b], bend: 15deg),
          edge(<b>, <s>, "-|>", [b], bend: 15deg),
          edge(<b>, <c>, "-|>", [a], bend: 15deg),
          edge(<c>, <a>, "-|>", [b], bend: 15deg),
          edge(<c>, <b>, "-|>", [a], bend: 15deg),
        )
      ],
    )

  + Stringhe su {a,b} di lunghezza dispari che contengono esattamente due "b":
    #grid(
      columns: (.5fr, 1fr),
      align(center)[
        #table(
          columns: (auto, auto, auto),
          align: center,
          [],
          [$abs(w)$],
          [$abs(w)_b$],
          [S],
          [_pari_],
          [0],
          [A],
          [_dispari_],
          [0],
          [B],
          [_dispari_],
          [1],
          [C],
          [_pari_],
          [1],
          [D],
          [_pari_],
          [2],
          table.cell(fill: rgb("#68e86680"), "E"),
          [*_dispari_*],
          [*2*],
          [F],
          [_pari,#linebreak()dispari_],
          [>2],
        )
      ],
      align(center)[
        #diagram(
          node-stroke: 0.9pt,
          cell-size: 5mm,
          spacing: 3mm,
          node((-2.5, 0), [S], name: <s>),
          node((0, 0), [A], name: <a>),
          node((-2.5, 2), [B], name: <b>),
          node((0, 2), [C], name: <c>),
          node((-2.5, 4), [D], name: <d>),
          node((0, 4), [E], extrude: (-2, 0), name: <e>),
          node((-1.25, 6), [F], name: <f>),
          edge((-3.7, 0), <s>, "-|>"),
          edge(<s>, <a>, "-|>", [a], bend: 15deg),
          edge(<s>, <b>, "-|>", [b]),
          edge(<a>, <s>, "-|>", [a], bend: 15deg),
          edge(<a>, <c>, "-|>", [b]),
          edge(<b>, <d>, "-|>", [b]),
          edge(<b>, <c>, "-|>", [a], bend: 15deg),
          edge(<c>, <e>, "-|>", [b]),
          edge(<c>, <b>, "-|>", [a], bend: 15deg),
          edge(<d>, <f>, "-|>", [b], label-sep: -15pt),
          edge(<d>, <e>, "-|>", [a], bend: 15deg),
          edge(<e>, <f>, "-|>", [b], label-sep: -15pt),
          edge(<e>, <d>, "-|>", [a], bend: 15deg),
          edge(<f>, <f>, "-|>", [a,b], label-pos: 80%, bend: -130deg),
        )
      ],
    )
  #colbreak()

  6. Stringhe su {a,b} in cui "aa" occorre solo una volta:
    #grid(
      columns: (.5fr, 1fr),
      align(center)[
        #table(
          columns: (auto, auto, auto),
          align: center,
          [],
          [_aa_],
          [u.c.],
          [S],
          [0],
          [$b(epsilon)$],
          [A],
          [0],
          [_a_],
          table.cell(fill: rgb("#68e86680"), "B"),
          [*1*],
          [_a_],
          table.cell(fill: rgb("#68e86680"), "C"),
          [*1*],
          [_b_],
          [D],
          [$>=2$],
          [_a,b_],
        )
      ],
      align(center)[
        #diagram(
          node-stroke: 0.9pt,
          cell-size: 5mm,
          spacing: 3mm,
          node((-3, 0), [S], name: <s>),
          node((-1, 0), [A], name: <a>),
          node((1, 0), [B], extrude: (-2, 0), name: <b>),
          node((3, 0), [C], extrude: (-2, 0), name: <c>),
          node((1, 2), [D], name: <d>),
          edge((-4.2, 0), <s>, "-|>"),
          edge(<s>, <a>, "-|>", [a], bend: 15deg),
          edge(<s>, <s>, "-|>", [b], bend: 130deg),
          edge(<a>, <b>, "-|>", [a], bend: 15deg),
          edge(<a>, <s>, "-|>", [b], bend: 15deg),
          edge(<b>, <d>, "-|>", [a], bend: 15deg),
          edge(<b>, <c>, "-|>", [b], bend: 15deg),
          edge(<c>, <b>, "-|>", [a], bend: 15deg),
          edge(<c>, <c>, "-|>", [b], bend: 130deg),
          edge(<d>, <d>, "-|>", [a,b], label-pos: 80%, bend: -130deg),
        )
      ],
    )
]

=== Automi incompleti
In alcuni casi la *non appartenenza* di una stringa al linguaggio di un automa può essere determinata anche prima di terminare la scansione della stringa, ad esempio quando si chiede che le stringhe non contengano una particolare sottostringa e questa viene individuata. In questi automi mancano alcune combinazioni di stato-simbolo perché corrispondono all'arresto.

Si possono definire automi con $δ$ funzione parziale cioè non definita per tutte le coppie stato, simbolo. Se l’automa è nella configurazione $[q, a w]$ e $δ(q, a)$ non è definita, allora si arresta e rifiuta. Un automa di questo tipo si dice *incompleto*.

#example()[
  Stringhe che non contengono $a a$:
  #figure(image("images/2026-05-16-16-43-45.png"))
  Dallo stato $q_1$ non si può scandire una $a$ perché $δ(q_1, a)$ non è definita, quindi se l’automa è nella configurazione $[q_1, a w]$ si arresta rifiutando la stringa senza completare la scansione.
]

== Automi a stati finiti non deterministici (NFA)

#definition()[
  Un automa a stati finiti *non deterministico* (NFA) è una quintupla $A=(Q, Sigma, delta, q_0, F)$.
  - $Q$ insieme finito degli stati.
  - $Sigma$ insieme dei simboli in ingresso.
  - $F subset Q$: stati finali o accettanti.
  - $delta$ è funzione di transizione che associa ad ogni stato per ogni simbolo in $Sigma union {epsilon}$ un insieme di prossimi stati.
  - $q_0 in Q$, stato iniziale
]

Gli automi a stati finiti non deterministici NFA sono più flessibili e spesso più semplici da progettare. La funzione di transizione associa ad ogni coppia stato/simbolo un sottoinsieme di Q:
$
  delta : Q times Sigma -> 2^Q
$
Se $delta(q, a) = {q_1, q_2, ..., q_k}$, significa che quando l'automa si trova nella configurazione $[q, a w]$ può "diramarsi" in percorsi paralleli e passare a uno qualsiasi degli stati $q_1, q_2, ..., q_k$.

Siccome un NFA è una rappresentazione astratta di un algoritmo per riconoscere una stringa, per la programmazione reale bisogna usare i DFA, che invece sono concreti, univoci e direttamente implementabili.


L'algoritmo di simulazione DFA permette di applicare un DFA ad una stringa specifica. Esso richiede in input una stringa $x$, un DFA con stato iniziale $s_0$, l'insieme F di stati accettanti e una funzione di transizione $m o v e$.
#figure(```c
s = s0;
c = nextChar();
while ( c != eof ) {
  s = move(s, c) ;
  c = nextChar(); //Restituisce il prossimo carattere in x
}
if ( s in F ) return "yes ";
else return "no";
```)

=== Da espressione regolare a NFA

Ogni espressione regolare può essere convertita in un NFA che definisce lo stesso linguaggio. L'algoritmo che permette di farlo, noto come *Algoritmo di Thompson* (o Costruzione di Thompson), si basa sull'induzione strutturale e sulla suddivisione dell'espressione base in sottoespressioni più semplici.

#underline("Base:") per l'espressione $epsilon$ si costruisce il NFA seguente:

#figure(diagram(
  node-stroke: 0.9pt,
  cell-size: 5mm,
  spacing: 3mm,
  edge((-1, 0), (0, 0), "-|>"),
  node((0, 0), [$i$], radius: 1em),
  edge((0, 0), (2, 0), "-|>", [$epsilon$]),
  node((2, 0), [$f$], radius: 1em, extrude: (-2.5, 0)),
))

Dove $i$ e $f$ sono nuovi stati, creati appositamente per essere rispettivamente lo stato iniziale e lo stato accettante. Analogamente, per ogni espressione composta da un singolo carattere terminale $a in Sigma$, si costruisce il seguente NFA:

#figure(diagram(
  node-stroke: 0.9pt,
  cell-size: 5mm,
  spacing: 3mm,
  edge((-1, 0), (0, 0), "-|>"),
  node((0, 0), [$i$], radius: 1em),
  edge((0, 0), (2, 0), "-|>", [$a$]),
  node((2, 0), [$f$], radius: 1em, extrude: (-2.5, 0)),
))

#observation()[
  Notare che in entrambe le costruzioni base si costruisce un NFA distinto per *ogni* singola occorrenza di $epsilon$ o di una qualsiasi sottoespressione $a$ all'interno dell'espressione regolare globale.
]

#underline("Induzione:") supponiamo che $N(s)$ e $N(t)$ siano NFA per le espressioni regolari $s$ e $t$.
+ Sia $r=s bar t$ (Unione). Allora $N(r)$ è costruito come segue ($epsilon$ rappresenta una $epsilon$-transizione):
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 2mm,
    edge((-1, 0), (0, 0), "-|>"),
    node((0, 0), [$i$], radius: 1em), //Stato iniziale
    //--
    edge((0, 0), (1, 1), "-|>", [$epsilon$]),
    node((1, 1), [], radius: 1em),
    node((3, 1), [], radius: 1em),
    node((2, 1), [$N(t)$], radius: 1em, stroke: none),
    node(enclose: ((1, 1), (3, 1)), shape: ellipse, radius: 25pt, snap: false),
    edge((3, 1), (4, 0), "-|>", [$epsilon$]),
    //--
    edge((0, 0), (1, -1), "-|>", [$epsilon$]),
    node((1, -1), [], radius: 1em),
    node((3, -1), [], radius: 1em),
    node((2, -1), [$N(s)$], radius: 1em, stroke: none),
    node(enclose: ((1, -1), (3, -1)), shape: ellipse, radius: 25pt, snap: false),
    edge((3, -1), (4, 0), "-|>", [$epsilon$]),
    //--
    node((4, 0), [$f$], radius: 1em, extrude: (-2.5, 0)),
  ))

+ Sia $r=s t$ (Concatenazione). Allora $N(r)$ è costruito come segue:
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    edge((-1.5, 0), (0, 0), "-|>"),
    node((0, 0), [$i$], radius: 1em), //Stato iniziale
    //--
    node((2, 0), [], radius: 1em),
    node((1, 0), [$N(s)$], radius: 1em, stroke: none),
    node(enclose: ((0, 0), (2, 0)), radius: 25pt, shape: ellipse),
    //--
    node((3, 0), [$N(t)$], radius: 1em, stroke: none),
    node(enclose: ((2, 0), (4, 0)), radius: 25pt, snap: false, shape: ellipse),
    //--
    node((4, 0), [$f$], radius: 1em, extrude: (-2.5, 0)),
  ))

+ Sia $r=s^*$. Allora $N(r)$ è costruito come segue:
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    edge((-2, 0), (-1, 0), "-|>"),
    node((-1, 0), [$i$], radius: 1em), //Stato iniziale
    //--
    edge((-1, 0), (1, 0), [$epsilon$], "-|>"),
    node((1, 0), [], radius: 1em),
    node((2, 0), [$N(s)$], radius: 1em, stroke: none),
    node((3, 0), [], radius: 1em),
    edge((3, 0), (1, 0), bend: -70deg, [$epsilon$], "-|>"),
    node(enclose: ((1, 0), (3, 0)), radius: 25pt, shape: ellipse, snap: false),
    edge((-1, 0), (5, 0), bend: -50deg, [$epsilon$], "-|>"),
    //--
    node((5, 0), [$f$], radius: 1em, extrude: (-2.5, 0)),
    edge((3, 0), (5, 0), [$epsilon$], "-|>"),
  ))

#let grafo1 = figure(diagram(
  node-stroke: 0.9pt,
  cell-size: 5mm,
  spacing: 3mm,
  node((-4.0, 0), [0]), // start state (0)
  node((-2.0, 0), [1]),
  node((-0.5, -1.0), [2]),
  node((1.0, -1.0), [3]),
  node((2.0, 0.0), [6]),
  node((1.0, 1.0), [5]),
  node((-0.5, 1.0), [4]),
  node((3.5, 0.0), [7]),
  node((5.0, 0.0), [8]),
  node((6.5, 0.0), [9]),
  // final state: use `extrude` to create a double-stroke (double circle)
  node((8.5, 0.0), [10], extrude: (-2, 0)),
  // Edges (labels in square brackets). `bend` controls curvature.
  edge((-5.2, 0.0), (-4.0, 0.0), "-|>"), // external incoming "start" arrow
  edge((-4.0, 0.0), (-2.0, 0.0), "-|>", [ε]), // 0 -> 1
  edge((-2.0, 0.0), (-0.5, 1.0), "-|>", [ε]), // 1 -> 2 (upper)
  edge((-0.5, 1.0), (1.0, 1.0), "-|>", [a]), // 2 -> 3 (a)
  edge((1.0, 1.0), (2.0, 0.0), "-|>", [ε]), // 3 -> 6
  edge((-2.0, 0.0), (-0.5, -1.0), "-|>", [ε]), // 1 -> 4 (lower)
  edge((-0.5, -1.0), (1.0, -1.0), "-|>", [b]), // 4 -> 5 (b)
  edge((1.0, -1.0), (2.0, 0.0), "-|>", [ε], label-sep: 1pt), // 5 -> 6
  // loop from 6 back to 1 (top arc)
  edge((2.0, 0.0), (-2.0, 0.0), "-|>", [ε], bend: -90deg, label-pos: 0.4),
  // small ε-edge from 6 to 7
  edge((2.0, 0.0), (3.5, 0.0), "-|>", [ε]),
  // linear path to final
  edge((3.5, 0.0), (5.0, 0.0), "-|>", [a]),
  edge((5.0, 0.0), (6.5, 0.0), "-|>", [b]),
  edge((6.5, 0.0), (8.5, 0.0), "-|>", [b]),
  // long outer ε-arc from state 0 sweeping under into state 7 (like in the picture)
  edge((-4.0, 0.0), (3.5, 0.0), "-|>", [ε], bend: -60deg, label-pos: 0.5),
))

#example()[
  Applichiamo l'algoritmo appena visto sull'espressione regolare `(a|b)*abb`. Per prima cosa dobbiamo costruire gli NFA dei vari simboli:

  #figure(grid(
    columns: 2,
    column-gutter: 50pt,
    [#diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      edge((-1, 0), (0, 0), "-|>"),
      node((0, 0), [2], radius: 1em),
      edge((0, 0), (2, 0), "-|>", [$a$]),
      node((2, 0), [3], radius: 1em, extrude: (-2.5, 0)),
    )],
    [#diagram(
      node-stroke: 0.9pt,
      cell-size: 5mm,
      spacing: 3mm,
      edge((-1, 0), (0, 0), "-|>"),
      node((0, 0), [4], radius: 1em),
      edge((0, 0), (2, 0), "-|>", [$b$]),
      node((2, 0), [5], radius: 1em, extrude: (-2.5, 0)),
    )],
  ))
  I numeri assegnati ai nuovi stati avranno senso una volta ottenuto il NFA finale. Combiniamo $N(a)$ e $N(b)$ per ottenere il NFA del costrutto $a bar b$, $N(a bar b)$:
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 2mm,
    edge((-1, 0), (0, 0), "-|>"),
    node((0, 0), [1], radius: 1em), //Stato iniziale
    //--
    edge((0, 0), (1, 1), "-|>", [$epsilon$]),
    node((1, 1), [4], radius: 1em),
    edge((1, 1), (3, 1), "-|>", [$b$]),
    node((3, 1), [5], radius: 1em),
    edge((3, 1), (4, 0), "-|>", [$epsilon$]),
    //--
    edge((0, 0), (1, -1), "-|>", [$epsilon$]),
    node((1, -1), [2], radius: 1em),
    edge((1, -1), (3, -1), "-|>", [$a$]),
    node((3, -1), [3], radius: 1em),
    edge((3, -1), (4, 0), "-|>", [$epsilon$]),
    //--
    node((4, 0), [6], radius: 1em, extrude: (-2.5, 0)),
  ))
  Le parentesi tonde non modificano il NFA, pertanto rimane invariato. Passando a $N((a bar b)^*)$:
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    node((-4.0, 0), [0]), // start state (0)
    node((-2.0, 0), [1]),
    node((-0.5, -1.0), [2]),
    node((1.0, -1.0), [3]),
    node((2.0, 0.0), [6]),
    node((1.0, 1.0), [5]),
    node((-0.5, 1.0), [4]),
    node((3.5, 0.0), extrude: (-2, 0), [7]),
    // Edges (labels in square brackets). `bend` controls curvature.
    edge((-5.2, 0.0), (-4.0, 0.0), "-|>"), // external incoming "start" arrow
    edge((-4.0, 0.0), (-2.0, 0.0), "-|>", [ε]), // 0 -> 1
    edge((-2.0, 0.0), (-0.5, 1.0), "-|>", [ε]), // 1 -> 2 (upper)
    edge((-0.5, 1.0), (1.0, 1.0), "-|>", [a]), // 2 -> 3 (a)
    edge((1.0, 1.0), (2.0, 0.0), "-|>", [ε]), // 3 -> 6
    edge((-2.0, 0.0), (-0.5, -1.0), "-|>", [ε]), // 1 -> 4 (lower)
    edge((-0.5, -1.0), (1.0, -1.0), "-|>", [b]), // 4 -> 5 (b)
    edge((1.0, -1.0), (2.0, 0.0), "-|>", [ε], label-sep: 1pt), // 5 -> 6
    // loop from 6 back to 1 (top arc)
    edge((2.0, 0.0), (-2.0, 0.0), "-|>", [ε], bend: -90deg, label-pos: 0.4),
    // small ε-edge from 6 to 7
    edge((2.0, 0.0), (3.5, 0.0), "-|>", [ε]),
    // long outer ε-arc from state 0 sweeping under into state 7 (like in the picture)
    edge((-4.0, 0.0), (3.5, 0.0), "-|>", [ε], bend: -60deg, label-pos: 0.5),
  ))
  Le ultime tre concatenazioni di "a", "b" e ancora "b" sono intuitive e permettono di ottenere il risultato finale:

  #grafo1
]

=== Da NFA a DFA

Per poter convertire un NFA in un DFA esiste un algoritmo specifico che però necessita dell'uso di alcune operazioni specifiche definite come segue:

#table(
  columns: 2,
  rows: 4,
  inset: 8pt,
  [Operazione], [Descrizione],
  [$epsilon$-closure($s$)],
  [Insieme degli stati del NFA raggiungibili dallo stato $s$ unicamente mediante $epsilon$-transizioni. Ogni stato, letto $epsilon$, può rimanere anche su se stesso.],

  [$epsilon$-closure($T$)],
  [Insieme degli stati del NFA raggiungibili da un qualsiasi stato $s$ nell'insieme T unicamente mediante $epsilon$-transizioni, cioè $epsilon"-closure"(T)$ = $union.big_(s in T) epsilon"-closure"(s)$.],

  [$m o v e(T,a)$],
  [Insieme degli stati del NFA verso cui vi è una transizione con simbolo d'ingresso $a$, da un qualsiasi stato $s$ in $T$.],
)

Se riprendiamo l'esempio di conversione da espressione regolare a NFA, possiamo vedere a che cosa corrispondono le operazioni appena introdotte:
- $epsilon"-cl(6)"={6,7,1,2,4}$
- $epsilon"-cl(8)"={8}$
- _move_$({2,3},b)={3}$

Continuiamo la conversione da espressione regolare a DFA, ricordando l'espressione `(a|b)*abb`. Lo stato iniziale $A$ del DFA equivalente si ottiene calcolando l'$epsilon$-closure(0), cioè $A = {0,1,2,4,7}$, poiché questi sono tutti e soli gli stati raggiungibili dallo stato 0 seguendo un percorso formato unicamente da archi etichettati con $epsilon$.

#grafo1

Cominciamo costruendo delle tabelle di transizione:
$
  text("Dtran")[A,a] &= epsilon text("-closure")(text("move")(A,a)) = epsilon text("-closure")({3,8}) = {1,2,3,4,6,7,8} = B quad && (B != A) \
  text("Dtran")[A,b] &= epsilon text("-closure")(text("move")(A,b)) = epsilon text("-closure")({5}) = {1,2,4,5,6,7} = C quad && (C != A, B) \
  text("Dtran")[B,a] &= epsilon text("-closure")(text("move")(B,a)) = epsilon text("-closure")({3,8}) = {1,2,3,4,6,7,8} = B
$
Alla fine, continuando ad applicare questa logica per ogni nuovo stato generato e ogni carattere dell'alfabeto, si ottengono esattamente cinque stati distinti:
#align(center)[
  #table(
    columns: 4,
    rows: 6,
    align: center,
    fill: (col, row) => if row == 0 { luma(230) } else { none },
    [*Stato NFA*], [*Stato DFA*], [*$a$*], [*$b$*],
    [${0,1,2,4,7}$], [$A$], [$B$], [$C$],
    [${1,2,3,4,6,7,8}$], [$B$], [$B$], [$D$],
    [${1,2,4,5,6,7}$], [$C$], [$B$], [$C$],
    [${1,2,4,5,6,7,9}$], [$D$], [$B$], [$E$],
    [${1,2,4,5,6,7,10}$], [$E$], [$B$], [$C$],
  )
]
Gli stati finali del DFA sono tutti quelli che contengono al loro interno almeno uno stato finale del NFA originale. In questo caso, lo stato finale originale era il $10$, che è presente solo nell'insieme $E$.
_Attenzione:_ in una conversione corretta che descrive un linguaggio valido, deve sempre esserci almeno uno stato finale, altrimenti vi è un errore nel calcolo.

Il DFA finale, compatto e deterministico, è quindi:
#figure(diagram(
  node-stroke: 0.9pt,
  cell-size: 2mm,
  spacing: 3mm,
  node((-4.0, 0), [A]),
  node((0.0, 0), [B]),
  node((0, -4.0), [C]),
  node((4.0, 0.0), [D]),
  node((8, 0.0), [E], extrude: (-2, 0)),
  // EDGES //
  edge((-6, 0.0), (-4.0, 0), "-|>", [start]),
  edge((-4.0, 0.0), (0.0, 0.0), "-|>", [a]),
  edge((-4.0, 0.0), (0.0, -4.0), "-|>", [b]),
  edge((0.0, 0.0), (0.0, 0.0), "<|-", [a], bend: -130deg),
  edge((0.0, 0.0), (4.0, 0.0), "-|>", [b]),
  edge((0.0, -4.0), (0.0, 0.0), "-|>", [a]),
  edge((0.0, -4.0), (0.0, -4.0), "<|-", [b], bend: 130deg),
  edge((4.0, 0.0), (0.0, 0.0), "-|>", [a], bend: 20deg, label-sep: -2pt),
  edge((4.0, 0.0), (8.0, 0.0), "-|>", [b]),
  edge((8.0, 0.0), (0.0, 0.0), "-|>", [a], bend: 35deg),
  edge((8.0, 0.0), (0.0, -4.0), "-|>", [b]),
))


#example("NFA a DFA")[
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 2mm,
    spacing: 3mm,
    // NODES //
    node((-3, 0), [0], name: <0>),
    node((-1, 0), [1], name: <1>),
    node((1, 0), [2], name: <2>),
    node((3, 0), [3], name: <3>, extrude: (-2, 0)),
    // EDGES //
    edge((-5, 0), <0>, [start], "-|>", label-pos: 0.1),
    edge(<0>, <0>, [a], "<|-", bend: 130deg),
    edge(<0>, <0>, [b], "<|-", bend: -130deg),
    edge(<0>, <1>, [a], "-|>"),
    edge(<1>, <2>, [b], "-|>"),
    edge(<2>, <3>, [b], "-|>"),
  ))

  $
    epsilon text("-cl")(0) & = {0} = A \
       text("Dtran")[A, a] & = epsilon text("-cl")(text("move")(A, a)) = epsilon text("-cl")({0,1}) = {0,1} = B \
       text("Dtran")[A, b] & = epsilon text("-cl")(text("move")(A, b)) = epsilon text("-cl")({0}) = {0} = A \
       text("Dtran")[B, a] & = epsilon text("-cl")(text("move")(B, a)) = epsilon text("-cl")({0,1}) = {0,1} = B \
       text("Dtran")[B, b] & = epsilon text("-cl")(text("move")(B, b)) = epsilon text("-cl")({0,2}) = {0,2} = C \
       text("Dtran")[C, a] & = epsilon text("-cl")(text("move")(C, a)) = epsilon text("-cl")({0,1}) = {0,1} = B \
       text("Dtran")[C, b] & = epsilon text("-cl")(text("move")(C, b)) = epsilon text("-cl")({0,3}) = {0,3} = D \
       text("Dtran")[D, a] & = epsilon text("-cl")(text("move")(D, a)) = epsilon text("-cl")({0,1}) = {0,1} = B \
       text("Dtran")[D, b] & = epsilon text("-cl")(text("move")(D, b)) = epsilon text("-cl")({0}) = {0} = A \
  $

  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 2mm,
    spacing: 3mm,
    // NODES //
    node((-3, 0.5), [A], name: <A>),
    node((-1, 0.0), [B], name: <B>),
    node((1, 0.5), [C], name: <C>),
    node((3, 1.0), [D], name: <D>, extrude: (-2, 0)),
    // EDGES //
    edge((-5, 0), <A>, [start], "-|>", label-pos: 0.1),
    edge(<A>, <A>, [b], "-|>", bend: 130deg, loop-angle: 270deg),
    edge(<A>, <B>, [a], "-|>"),
    edge(<B>, <B>, [a], "-|>", bend: 130deg, loop-angle: 120deg),
    edge(<B>, <C>, [b], "-|>", bend: -15deg),
    edge(<C>, <B>, [a], "-|>", bend: -15deg),
    edge(<C>, <D>, [b], "-|>"),
    edge(<D>, <A>, [b], "-|>", bend: 30deg),
    edge(<D>, <B>, [a], "-|>", bend: -60deg),
  ))
]

=== Simulazione di un NFA

Una strategia utilizzata, per esempio, in molti programmi di elaborazione di testo consiste nel costruire un NFA a partire da un'espressione regolare e quindi procedere alla sua simulazione effettuando la *costruzione per sottoinsiemi al momento* (on-the-fly), calcolando solo le transizioni necessarie passo dopo passo.

L'algoritmo riceve in input una stringa, un NFA con stato iniziale $s_0$, l'insieme degli stati di accettazione $F$ e la funzione di transizione $mtext("move")()$.

Durante l'esecuzione, viene mantenuto un insieme di stati correnti $S$, costituito da tutti gli stati raggiungibili a partire da $s_0$ seguendo i percorsi etichettati con i simboli d'ingresso letti finora. Se $c$ è il prossimo carattere restituito dalla funzione $mtext("nextChar")()$, l'algoritmo per prima cosa calcola $mtext("move")(S, c)$, e successivamente ne espande i risultati calcolando la chiusura mediante la funzione $epsilon text("-closure")()$.

#align(center)[
  #figure(
    ```c
    S = ε_closure({s0});
    c = nextChar();

    while (c != EOF) {
        S = ε_closure(move(S, c));
        c = nextChar();
    }

    // Se l'intersezione tra gli stati finali raggiunti
    // e gli stati di accettazione dell'NFA non è vuota
    if (S ∩ F != ∅) {
        return "yes";
    } else {
        return "no";
    }
    ```,
  )
]

== Minimizzazione di un DFA

Possono esistere molti automi deterministici che riconoscono lo stesso linguaggio. Tali automi non solo hanno stati con nomi diversi, ma addirittura possono avere un numero diverso di stati. Se implementiamo un analizzatore lessicale basandoci su un DFA, preferiremo un DFA con il minimo numero possibile di stati, poiché ogni stato richiede elementi aggiuntivi nella tabella che descrive l'analizzatore lessicale stesso (costando più memoria).

Il problema del nome degli stati si risolve facilmente. Diremo infatti che due automi sono *uguali a meno dei nomi* (isomorfi) se uno può essere trasformato nell'altro modificando solamente i nomi degli stati.

Si può dimostrare che per ogni linguaggio regolare esiste un DFA con un numero di stati minimo e tale DFA è unico a meno dei nomi. Inoltre, tale DFA minimo può essere costruito a partire da un qualsiasi DFA equivalente, raggruppando insiemi di stati "equivalenti".

#definition(
  "Stati distinguibili",
)[
  Diciamo che una stringa $x$ *distingue* (o *rende distinguibile*) lo stato $s$ dallo stato $t$ se esattamente uno degli stati raggiungibili da $s$ e da $t$ mediante un percorso etichettato con la stringa $x$ è uno stato di accettazione. Si dice inoltre che lo stato $s$ è *distinguibile da* $t$ se esiste almeno una stringa che li distingue. Se non esiste alcuna stringa del genere, i due stati sono *indistinguibili* (o equivalenti) e possono essere fusi.
]

L'algoritmo di minimizzazione degli stati si basa sul partizionamento degli stati del DFA in gruppi di stati non distinguibili. Ogni gruppo verrà infine fuso in un unico stato del nuovo DFA minimo. L'algoritmo modifica progressivamente una partizione i cui gruppi sono insiemi di stati non ancora identificati come distinguibili; due stati qualsiasi, appartenenti a insiemi diversi della partizione, sono invece già stati identificati come distinguibili. Quando la partizione non può essere ulteriormente modificata spezzando un gruppo in gruppi più piccoli, allora essa rappresenta gli stati del DFA minimo.

Inizialmente la partizione contiene due macrogruppi di stati: stati d'accettazione e di non accettazione. Il procedimento fondamentale consiste nel considerare un generico gruppo $A={s_1, s_2, ..., s_k}$ della partizione corrente e un generico simbolo d'ingresso $a$, per poi verificare se il simbolo $a$ può essere utilizzato per distinguere alcuni degli stati del gruppo $A$. A tale scopo si esaminano le transizioni da ognuno degli stati $s_1, s_2, ..., s_k$ relative al simbolo d'ingresso $a$; se gli stati raggiunti da tali transizioni ricadono in due o più gruppi differenti della partizione corrente, si suddivide $A$ in un insieme di sottogruppi, in modo tale che due stati $s_i$ e $s_j$ rimangano nello stesso gruppo se e solo se le loro transizioni con $a$ portano a stati di uno stesso gruppo. Si ripete quindi questo procedimento finché nessun gruppo possa essere ulteriormente suddiviso per nessun simbolo d'ingresso.

#example()[
  Consideriamo ancora il seguente DFA:
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 2mm,
    spacing: 3mm,
    node((-4.0, 0), [A]),
    node((0.0, 0), [B]),
    node((0, -4.0), [C]),
    node((4.0, 0.0), [D]),
    node((8, 0.0), [E], extrude: (-2, 0)),
    // EDGES //
    edge((-6, 0.0), (-4.0, 0), "-|>", [start]),
    edge((-4.0, 0.0), (0.0, 0.0), "-|>", [a]),
    edge((-4.0, 0.0), (0.0, -4.0), "-|>", [b]),
    edge((0.0, 0.0), (0.0, 0.0), "<|-", [a], bend: -130deg),
    edge((0.0, 0.0), (4.0, 0.0), "-|>", [b]),
    edge((0.0, -4.0), (0.0, 0.0), "-|>", [a]),
    edge((0.0, -4.0), (0.0, -4.0), "<|-", [b], bend: 130deg),
    edge((4.0, 0.0), (0.0, 0.0), "-|>", [a], bend: 20deg),
    edge((4.0, 0.0), (8.0, 0.0), "-|>", [b]),
    edge((8.0, 0.0), (0.0, 0.0), "-|>", [a], bend: 35deg),
    edge((8.0, 0.0), (0.0, -4.0), "-|>", [b]),
  ))
  La partizione iniziale consiste in due gruppi: ${A,B,C,D}$ e ${E}$, che contengono rispettivamente gli stati di non accettazione e quello di accettazione. Ora:
  - ${E}$ è composto da un solo elemento, non può essere spezzato ulteriormente e rimane invariato.
  - ${A,B,C,D}$ può essere potenzialmente spezzato. Per farlo dobbiamo considerare l'effetto di ogni simbolo d'ingresso.

  *Analizziamo "a"*: ognuno degli stati del gruppo, in corrispondenza del simbolo $a$, prevede una transizione verso lo stato $B$ (che è dentro il gruppo stesso). Quindi tramite "a" non si possono distinguere gli stati.

  *Analizziamo "b"*: con ingresso $b$ dagli stati $A, B, C$ si passa a stati che si trovano in ${A,B,C,D}$ (rispettivamente $C, D, C$). Ma dallo stato $D$ con "b" si passa allo stato $E$, che *non* appartiene al gruppo, bensì al gruppo degli stati di accettazione! Pertanto $D$ è distinguibile dagli altri tre e viene isolato in un nuovo gruppo:
  $
    {A,B,C} quad {D} quad {E}
  $
  Ripetiamo iterativamente sul gruppo che può essere ancora spezzato (${A,B,C}$):

  *Analizziamo "a"*: portano tutti in $B$.

  *Analizziamo "b"*: $A$ va in $C$ (stesso gruppo), $C$ va in $C$ (stesso gruppo), ma $B$ va in $D$ (che ora è in un gruppo a sé stante!). Quindi $B$ è distinguibile da $A$ e $C$, e viene separato:
  $
    {A,C} quad {B} quad {D} quad {E}
  $

  Da questa situazione non possiamo andare avanti in quanto, per gli unici stati rimasti assieme (${A,C}$), ogni transizione fa rimanere in gruppi identici ($a -> B$, $b -> {A,C}$). I due stati sono indistinguibili!

  L'automa DFA minimo equivalente sarà quindi composto da quattro stati, uno per ogni gruppo rimasto, fondendo $A$ e $C$ nello stato unificato $A C$. Il suo stato iniziale sarà $A C$ (poiché contiene il vecchio start $A$) e il finale sarà $E$:
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    node((0.0, 0), [AC], shape: "circle"),
    node((3.0, 0), [B]),
    node((3.0, 3.0), [D]),
    node((0, 3.0), [E], extrude: (-2, 0)),
    // EDGES //
    edge((-1.5, 0.0), (0.0, 0), "-|>", [start]),
    edge((0.0, 0.0), (3.0, 0.0), "-|>", [a]),
    edge((0.0, 0.0), (0.0, 0.0), "<|-", [b], bend: 130deg),
    edge((3.0, 0.0), (3.0, 0.0), "<|-", [a], bend: 130deg),
    edge((3.0, 0.0), (3.0, 3.0), "-|>", [b]),
    edge((3.0, 3.0), (3.0, 0.0), "-|>", [a], bend: -30deg),
    edge((3.0, 3.0), (0.0, 3.0), "-|>", [b]),
    edge((0.0, 3.0), (3.0, 0.0), "-|>", [a]),
    edge((0.0, 3.0), (0.0, 0.0), "-|>", [b]),
  ))
]


== Costruzione di un analizzatore lessicale
L'obiettivo dell'analizzatore lessicale (Lexer) è leggere una sequenza di caratteri (il codice sorgente), raggrupparli in "parole" dotate di significato chiamate *lessemi*, e classificarli come *token* pronti per essere passati al parser.
=== Riconoscimento dei token
Abbiamo visto precedentemente come esprimere un pattern utilizzando le
espressioni regolari. A questo punto procediamo nello studio di come costruire una
porzione di codice in grado di esaminare la sequenza di caratteri in ingresso e di individuare un prefisso corrispondente a un lessema descritto da un particolare pattern. Consideriamo la grammatica che descrive la forma di due costrutti di salto e delle relative espressioni condizionali.

$
  #emph[stmt] & -> && bold("if") " " #emph[expr] " " bold("then") " " #emph[stmt] \
              & |  && bold("if") " " #emph[expr] " " bold("then") " " #emph[stmt] " " bold("else") " " #emph[stmt] \
              & |  && epsilon \
  #emph[expr] & -> && #emph[term] " " bold("relop") " " #emph[term] \
              & |  && #emph[term] \
  #emph[term] & -> && bold("id") \
              & |  && bold("number")
$

I terminali della grammatica, cioè *if*, *then*, *else*, *relop*, *id* e *number*, ai fini dell'analizzatore sintattico sono nomi di token. I pattern di tali token sono descritti dalle definizioni regolari riportate di seguito.

$
   mtext("digit") quad & -> quad [0-9] \
  mtext("digits") quad & -> quad mtext("digit")^+ \
  mtext("number") quad & -> quad mtext("digits (. digits)?") ("E" [+-]"?" mtext("digits"))? \
  mtext("letter") quad & -> quad [A - Z a - z] \
      mtext("id") quad & -> quad mtext("letter (letter | digit)")^* \
      mtext("if") quad & -> quad bold("if") \
    mtext("then") quad & -> quad bold("then") \
    mtext("else") quad & -> quad bold("else") \
   mtext("relop") quad & -> quad < | > | <\= | >\= | = | <> \
$

L'analizzatore lessicale di questo linguaggio deve riconoscere le parole chiave *if*, *then* e *else*, nonché i lessemi corrispondenti ai pattern *relop*, *id* e *number*.

L'obiettivo dell'analizzatore lessicale che vogliamo costruire è riassunto nella tabella seguente che mostra, per ogni lessema o gruppo di lessemi, quale nome di token e valore di attributo debba essere restituito al parser.

#align(center)[
  #figure(
    table(
      columns: (auto, auto, auto),
      align: (center, center, left),
      fill: (col, row) => if row == 0 { luma(230) } else { none },
      [*Lessema*], [*Nome del token*], [*Valore dell'attributo*],
      [Qualsiasi `ws`], [-], [-],
      [`if`], [`if`], [-],
      [`then`], [`then`], [-],
      [`else`], [`else`], [-],
      [Qualsiasi `id`], [`id`], [Puntatore alla tabella dei simboli],
      [Qualsiasi `number`], [`number`], [Puntatore alla tabella dei simboli],
      [`<`], [`relop`], [`LT`],
      [`<=`], [`relop`], [`LE`],
      [`=`], [`relop`], [`EQ`],
      [`<>`], [`relop`], [`NE`],
      [`>`], [`relop`], [`GT`],
      [`>=`], [`relop`], [`GE`],
    ),
  )
]

=== Diagrammi di transizione
Il riconoscimento dei token è quindi il processo attraverso il quale l'analizzatore lessicale esamina la sequenza di caratteri in ingresso per trovare il prefisso più lungo che corrisponda al pattern di un token. A tale scopo, le espressioni regolari vengono convertite in *diagrammi di transizione*.

#definition()[Un *diagramma di transizione* è essenzialmente un grafo composto da stati (nodi, rappresentati da cerchi) che riflettono le condizioni possibili durante l'analisi dell'input. Gli stati sono collegati da archi orientati etichettati con simboli (o insiemi di simboli).
]

Valgono alcune convenzioni come per i DFA e NFA:
1. Lo stato iniziale (o di partenza) è indicato da un arco entrante non proveniente da altri stati.
2. Gli stati finali (o di accettazione) sono indicati con un doppio cerchio e associati a un'azione, tipicamente la restituzione di un token e del suo attributo al parser.
3. Se il carattere che ha portato allo stato finale non fa parte del lessema riconosciuto, lo stato finale è annotato con un asterisco (\*), che indica la necessità di arretrare (_retract_) di una posizione il puntatore _forward_ d'ingresso.

#example()[
  Il seguente diagramma di transizione riconosce i lessemi relativi al token *relop*:

  #figure(diagram(
    node-stroke: 0.9pt,
    label-size: 3mm,
    label-sep: 0.1em,
    cell-size: 2mm,
    spacing: 3mm,
    // NODES //
    node((0, 0), [0], name: <a>),
    node((6, 0), [1], name: <b>),
    node((9, 0), [2], extrude: (-3, 0), name: <c>),
    node((9, 1), [3], extrude: (-3, 0), name: <d>),
    node((9, 2), [4], extrude: (-3, 0), name: <e>),
    node((6, 3), [5], extrude: (-3, 0), name: <f>),
    node((6, 4), [6], name: <g>),
    node((9, 4), [7], extrude: (-3, 0), name: <h>),
    node((9, 5), [8], extrude: (-3, 0), name: <i>),
    // TEXT NODES //
    node((10, 0), [*return*(*relop*, LE)], stroke: none),
    node((10, 1), [*return*(*relop*, NE)], stroke: none),
    node((10, 2), [*return*(*relop*, LT)], stroke: none),
    node((7, 3), [*return*(*relop*, EQ)], stroke: none, inset: 0pt, width: 95pt),
    node((10, 4), [*return*(*relop*, GE)], stroke: none),
    node((10, 5), [*return*(*relop*, GT)], stroke: none),
    node((9.175, 1.65), [*\**], stroke: none, inset: 0pt),
    node((9.175, 4.65), [*\**], stroke: none, inset: 0pt),
    // EDGES //
    edge((-1.2, 0), <a>, "-|>", [start], label-pos: 0),
    edge(<a>, <b>, "-|>", $<$),
    edge(<b>, <c>, "-|>", $=$),
    edge(<b>, <d>, "-|>", $>$, bend: -15deg),
    edge(<b>, <e>, "-|>", [*other*], bend: -30deg),
    edge(<a>, <f>, "-|>", $=$, bend: -15deg),
    edge(<a>, <g>, "-|>", $>$, bend: -30deg),
    edge(<g>, <h>, "-|>", $=$),
    edge(<g>, <i>, "-|>", [*other*], bend: -15deg),
  ))
  Se l'analisi inizia nello stato 0 e legge <, si passa allo stato 1.
  - Dallo stato 1, se si legge `=` si riconosce `<=` e si passa allo stato finale 2 (restituendo relop, LE).
  - Dallo stato 1, se si legge `>` si riconosce `<>` e si passa allo stato 3 (restituendo relop, NE).
  - Dallo stato 1, se si legge qualsiasi altro carattere (other), si riconosce `<` e si passa allo stato 4, che richiede un arretramento (\*) poiché il carattere letto non fa parte del lessema.
]

L'analizzatore lessicale deve anche gestire l'eliminazione degli *spazi bianchi* (token _ws_), definiti da caratteri come spazi, tabulazioni e ritorni a capo. Quando il token _ws_ viene riconosciuto, non viene restituito al parser; l'analizzatore *ricomincia* immediatamente l'analisi a partire dal carattere successivo.

#[
  #set heading(numbering: none, outlined: false)
  === Riconoscimento di identificatori e parole chiave
]

#figure(
  diagram(
    node-stroke: 0.9pt,
    label-size: 3mm,
    label-sep: 0.1em,
    cell-size: 2mm,
    spacing: 3mm,
    // NODES //
    node((0, 0), [9], name: <a>),
    node((4, 0), [10], name: <b>),
    node((8, 0), [11], extrude: (-3, 0), name: <c>),
    // TEXT NODES //
    node((9, 0), [*return*(getToken(), installID())], stroke: none),
    node((8.175, -0.65), [*\**], stroke: none, inset: 0pt),
    // EDGES //
    edge((-1.2, 0), <a>, "-|>", [start], label-pos: 0),
    edge(<a>, <b>, "-|>", [*letter*]),
    edge(<b>, <b>, "<|-", [*letter* o *digit*], bend: 130deg),
    edge(<b>, <c>, "-|>", [*other*]),
  ),
  caption: [Diagramma di transizione per gli identificatori.],
)
Il diagramma di transizione per gli identificatori qui sopra riconosce i lessemi delle *parole chiave* (come *if*, *then*, *else*) se queste hanno una struttura simile agli identificatori. Il diagramma per gli identificatori inizia leggendo una lettera (stato 9) e procede nello stato 10, dove accetta qualsiasi sequenza di lettere o cifre. Quando incontra un simbolo che non fa parte del lessema, passa allo stato 11, accetta, e arretra il puntatore.
Due metodi principali sono usati per gestire il conflitto tra identificatori e parole chiave riservate:

+ *Installazione Preventiva nella Tabella dei Simboli*: le parole chiave sono pre-caricate nella tabella dei simboli con un'indicazione del token che rappresentano. Quando il diagramma riconosce un lessema (stato 11), la funzione `getToken()` consulta la tabella dei simboli: se il lessema è una parola chiave, restituisce il token specifico (es. *if*); altrimenti, restituisce il token ID.

+ *Diagrammi Separati e Priorità*: si possono usare diagrammi specifici per ogni parola chiave (come quello ipotetico per *then* qui sotto). Questo approccio richiede di imporre una priorità in modo che, se un lessema corrisponde sia a una parola chiave sia a un *id*, venga data la precedenza alla parola chiave.
#figure(diagram(
  node-stroke: 0.9pt,
  label-size: 3mm,
  label-sep: 0.1em,
  cell-size: 3mm,
  spacing: 3mm,
  // NODES //
  node((0, 0), radius: 3mm, name: <a>),
  node((4, 0), radius: 3mm, name: <b>),
  node((8, 0), radius: 3mm, name: <c>),
  node((12, 0), radius: 3mm, name: <d>),
  node((16, 0), radius: 3mm, name: <e>),
  node((20, 0), radius: 3mm, extrude: (-3, 0), name: <f>),
  // TEXT NODES //
  node((20.5, -0.65), [*\**], stroke: none, inset: 0pt),
  // EDGES //
  edge((-1.5, 0), <a>, "-|>", [start], label-pos: 0),
  edge(<a>, <b>, "-|>", [t]),
  edge(<b>, <c>, "-|>", [h]),
  edge(<c>, <d>, "-|>", [e]),
  edge(<d>, <e>, "-|>", [n]),
  edge(<e>, <f>, "-|>", [*nonlet/dig*]),
))

#[
  #set heading(numbering: none, outlined: false)
  === Riconoscimento di token number
]
#figure(
  diagram(
    node-stroke: 0.9pt,
    label-size: 3mm,
    label-sep: 0.1em,
    cell-size: 6mm,
    spacing: 3mm,
    // NODES //
    node((0, 0), [12], name: <12>),
    node((2, 0), [13], name: <13>),
    node((4, 0), [14], name: <14>),
    node((6, 0), [15], name: <15>),
    node((8, 0), [16], name: <16>),
    node((10, 0), [17], name: <17>),
    node((12, 0), [18], name: <18>),
    node((14, 0), [19], extrude: (-3, 0), name: <19>),
    node((4, 2), [20], extrude: (-3, 0), name: <20>),
    node((8, 2), [21], extrude: (-3, 0), name: <21>),
    // TEXT NODES //
    node((4.5, 1.65), [*\**], stroke: none, inset: 0pt),
    node((8.5, 1.65), [*\**], stroke: none, inset: 0pt),
    node((14.5, -0.325), [*\**], stroke: none, inset: 0pt),
    // EDGES //
    edge((-1.5, 0), <12>, "-|>", [start], label-pos: 0),
    edge(<12>, <13>, "-|>", [*digit*]),
    edge(<13>, <13>, "<|-", [*digit*], bend: 130deg),
    edge(<13>, <14>, "-|>", [.]),
    edge(<13>, <16>, "-|>", [E], bend: -30deg),
    edge(<13>, <20>, "-|>", [*other*], bend: -30deg),
    edge(<14>, <15>, "-|>", [*digit*]),
    edge(<15>, <15>, "<|-", [*digit*], bend: 130deg),
    edge(<15>, <16>, "-|>", [E]),
    edge(<15>, <21>, "-|>", [*other*], bend: -30deg),
    edge(<16>, <17>, "-|>", [$+$ o $-$]),
    edge(<16>, <18>, "-|>", [*digit*], bend: -30deg),
    edge(<17>, <18>, "-|>", [*digit*]),
    edge(<18>, <18>, "<|-", [*digit*], bend: 130deg),
    edge(<18>, <19>, "-|>", [*other*]),
  ),
  caption: [Diagramma di transizione per token _number_.],
)
Il diagramma per il token _number_ è più complesso, gestendo interi, parti frazionarie (opzionali, introdotte da un punto) ed esponenti (opzionali, introdotti da E). L'identificazione di un numero intero avviene uscendo dallo stato 13 nello stato 20, mentre il riconoscimento di un numero con parte frazionaria senza esponente termina nello stato 21.

#[
  #set heading(numbering: none, outlined: false)
  === Riconoscimento degli spazi bianchi
]
#figure(
  diagram(
    node-stroke: 0.9pt,
    label-size: 3mm,
    label-sep: 0.1em,
    cell-size: 10mm,
    spacing: 3mm,
    // NODES //
    node((0, 0), [22], name: <22>),
    node((2, 0), [23], name: <23>),
    node((4, 0), [24], extrude: (-3, 0), name: <24>),
    // TEXT NODES //
    node((4.45, -0.325), [*\**], stroke: none, inset: 0pt),
    // EDGES //
    edge((-1.5, 0), <22>, "-|>", [start], label-pos: 0),
    edge(<22>, <23>, "-|>", [*delim*]),
    edge(<23>, <23>, "<|-", [*delim*], bend: 130deg),
    edge(<23>, <24>, "-|>", [*other*]),
  ),
  caption: [Diagramma di transizione degli spazi.],
)
Il diagramma degli spazi riconosce caratteri delimitatori (*delim*). Lo stato finale 24 accetta il lessema di separazione e arretra il puntatore (\*), ma l'azione associata non restituisce un token al parser, bensì induce l'analizzatore lessicale a ricominciare l'analisi dall'input successivo.

=== Architettura di un analizzatore lessicale basato su diagrammi di transizione
L'implementazione di un analizzatore lessicale basato su diagrammi si traduce in codice in cui ogni stato corrisponde a una porzione di logica, spesso gestita tramite un costrutto di scelta multipla (switch) sulla variabile `state`.

#example()[
  ```cpp
  TOKEN getRelop()
  {
    TOKEN retToken = new(RELOP);
    while(1) {/*repeat character processing until a return or failure occurs*/
      switch(state) {
        case 0:
          c = nextChar();
          if (c == '<') state = 1;
          else if (c == '=') state = 5;
          else if (c == '>') state = 6;
          else fail(); /*lexeme is not a relop*/
          break;
        case 1:
        ...
        case 8:
          retract();
          retToken.attribute = GT;
          return(retToken);
      }
    }
  }
  ```
  La funzione schematica `getRelop()` simula il diagramma per gli operatori relazionali. Lo `switch(state)` gestisce le transizioni. Se un carattere non atteso viene letto, viene chiamata la funzione `fail()`, che ripristina il puntatore `forward` a `lexemeBegin` e passa il controllo a un nuovo diagramma di transizione o avvia la procedura di recupero dagli errori. Gli stati finali con arretramento (come lo stato 8) invocano la funzione `retract()` prima di restituire il token.
]
Per gestire tutti i token, si possono usare diversi approcci:
+ *Sequenziale*: provare i diagrammi uno dopo l'altro.
+ *In Parallelo*: eseguire tutti i diagrammi contemporaneamente, scegliendo il lessema più lungo riconosciuto.
+ *Diagramma Unico*: combinare tutti i diagrammi in uno solo. Il diagramma combinato legge l'input finché non può più progredire, e poi sceglie il lessema più lungo accettato. Nel caso in cui il primo carattere identifichi univocamente il token (come nell'esempio), gli stati iniziali dei singoli diagrammi vengono semplicemente uniti in un unico stato iniziale.

=== Il generatore di analizzatori lessicali Lex
*Lex (o Flex)* è uno strumento che automatizza la creazione di analizzatori lessicali. Il programmatore fornisce una specifica ad alto livello (i pattern in espressioni regolari) e *Lex* genera il codice sorgente (in C, salvato in lex.yy.c) che simula il diagramma di transizione combinato.

#figure(diagram(
  label-size: 3mm,
  label-sep: 0.1em,
  cell-size: (3mm, 6mm),
  spacing: 3mm,
  edge-stroke: 1pt,
  // NODES //
  node((0, 0), align($"    Programma sorgente Lex" \ $ + `lex.l`, right), width: 6cm, name: <cls>),
  node((0, 2), align(`lex.yy.c`, right), width: 6cm, name: <ccs>),
  node((0, 4), align("Sequenza d'ingresso", right), width: 6cm, name: <gs>),
  node((4, 0), [Compilatore lex], width: 3cm, stroke: 0.3mm, name: <clc>),
  node((4, 2), [Compilatore C], width: 3cm, stroke: 0.3mm, name: <ccc>),
  node((4, 4), `a.out`, width: 3cm, stroke: 0.3mm, name: <gc>),
  node((8, 0), align(`lex.yy.c`, left), width: 6cm, name: <cld>),
  node((8, 2), align(`a.out`, left), width: 6cm, name: <ccd>),
  node((8, 4), align("Sequenza di token", left), width: 6cm, name: <gd>),
  // EDGES //
  edge(<cls>, <clc>, "-|>"),
  edge(<clc>, <cld>, "-|>"),
  edge(<ccs>, <ccc>, "-|>"),
  edge(<ccc>, <ccd>, "-|>"),
  edge(<gs>, <gc>, "-|>"),
  edge(<gc>, <gd>, "-|>"),
))

Il file `lex.l` (programma sorgente Lex) viene elaborato dal compilatore Lex per produrre `lex.yy.c`. Questo file viene poi compilato per ottenere un eseguibile (spesso a.out), che funge da analizzatore lessicale. L'analizzatore generato è tipicamente richiamato come subroutine dal parser, restituendo il nome del token (un intero) e utilizzando la variabile globale `yylval` per passare eventuali attributi.

#observation()[
  Un *programma Lex* è diviso in tre sezioni principali:
  + *Dichiarazioni*: contiene definizioni di variabili, costanti simboliche per i nomi dei token, e definizioni regolari (nomi simbolici che abbreviano espressioni regolari complesse, come {delim} o {ws}). Le sezioni racchiuse tra `%{` e `%}` vengono copiate direttamente nel file `lex.yy.c`.
  + *Regole di traduzione*: hanno la forma `Pattern { Action }`, dove `Pattern` è un'espressione regolare e `Action` è un frammento di codice C.
  + *Funzioni ausiliarie*: codice C per funzioni come `installID()` o `installNum()`.
]
#figure(
  ```lex
  %{
      /* definitions of manifest constants
      LT, LE, EQ, NE, GT, GE,
      IF, THEN, ELSE, ID, NUMBER, RELOP */
  %}

  /* regular definitions */
  delim    [ \t\n]
  ws       {delim}+
  letter   [A-Za-z]
  digit    [0-9]
  id       {letter}({letter}|{digit})*
  number   {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

  %%

  {ws}       {/* no action and no return */}
  if         {return(IF);}
  then       {return(THEN);}
  else       {return(ELSE);}
  {id}       {yylval = (int) installID(); return(ID);}
  {number}   {yylval = (int) installNum(); return(NUMBER);}
  "<"        {yylval = LT; return(RELOP);}
  "<="       {yylval = LE; return(RELOP);}
  "="        {yylval = EQ; return(RELOP);}
  "<>"       {yylval = NE; return(RELOP);}
  ">"        {yylval = GT; return(RELOP);}
  ">="       {yylval = GE; return(RELOP);}

  %%

  int installID() {/* function to install the lexeme, whose
                      first character is pointed to by yytext,
                      and whose length is yyleng, into the
                      symbol table and return a pointer
                      thereto */
  }

  int installNum() {/* similar to installID, but puts numer-
                       ical constants into a separate table */
  }

  ```,
  caption: [Esempio di programma Lex],
)


== Progettazione di un generatore di analizzatori lessicali
Un generatore come Lex opera *trasformando le espressioni regolari in automi finiti*. L'architettura dell'analizzatore lessicale generato consiste in una *parte fissa di simulazione* dell'automa e *componenti generati* come la tabella di transizione e le azioni (frammenti di codice C).

#figure(image("images/2026-05-15-19-01-03.png"))

Per costruire l'automa, Lex per prima cosa prende *ogni espressione regolare* del programma e la trasforma mediante l'algoritmo apposito in un NFA $N_i$. Dato che si vuole ottenere un singolo automa che riconosca lessemi corrispondenti a un qualsiasi pattern del programma, Lex combina gli NFA così costruiti in un unico automa non-deterministico aggiungendo un nuovo stato iniziale con transizioni $epsilon$ verso ognuno degli stati iniziali degli automi $N_i$ relativi ai pattern $p_i$.

#figure(
  diagram(
    node-stroke: 0.9pt,
    label-sep: 0.1em,
    label-size: 4mm,
    cell-size: 3mm,
    spacing: 3mm,
    // NODES //
    node((-2, 3), $s_0$, name: <s0>),
    node((1, 0), radius: 4mm, name: <1>),
    node((1, 2), radius: 4mm, name: <2>),
    node((1.5, 4), align(top, text(size: 15pt, "...")), stroke: none),
    node((1, 6), radius: 4mm, name: <n>),
    // ELLISSI //
    node((1.5, 0), $N(p_1)$, shape: ellipse, width: 4.5cm, height: 1.25cm, stroke: 1pt),
    node((1.5, 2), $N(p_2)$, shape: ellipse, width: 4.5cm, height: 1.25cm, stroke: 1pt),

    node((1.5, 6), $N(p_n)$, shape: ellipse, width: 4.5cm, height: 1.25cm, stroke: 1pt),
    // CERCHI CONCENTRICI //
    node((2, 0), radius: 4mm, extrude: (-5, 0)),
    node((2, 2), radius: 4mm, extrude: (-5, 0)),

    node((2, 6), radius: 4mm, extrude: (-5, 0)),
    // EDGES //
    edge(<s0>, <1>, $epsilon$, "-|>"),
    edge(<s0>, <2>, $epsilon$, "-|>"),

    edge(<s0>, <n>, $epsilon$, "-|>"),
  ),
  caption: [NFA costruito da un programma Lex],
)


=== Riconoscimento dei pattern basato su NFA
Se l'analizzatore lessicale simula il comportamento di un NFA combinato, la sua simulazione segue l'input, mantenendo traccia dell'insieme di stati raggiungibili in ogni momento. Quando l'analisi non può più proseguire, l'analizzatore lessicale torna indietro nella sequenza degli insiemi di stati per trovare l'insieme contenente uno stato di accettazione (NFA) che corrisponde al prefisso più lungo. In caso di conflitti tra pattern, viene applicata la regola di priorità (scegliendo il pattern elencato per primo nel programma Lex).

//TODO: ci sarebbe esempio???

=== Riconoscimento dei pattern basato su DFA
L'approccio implementato da Lex si basa sulla conversione dell'NFA combinato in un DFA equivalente tramite l'algoritmo dei sottoinsiemi. Ogni stato del DFA corrisponde a un insieme di stati NFA. Se uno stato DFA include più stati di accettazione NFA, viene etichettato con il pattern avente la massima priorità (cioè quello elencato per primo nelle regole di Lex).

#example()[
  #figure(diagram(
    node-stroke: 0.9pt,
    node-shape: circle,
    label-size: 3mm,
    label-sep: 0.1em,
    cell-size: 3mm,
    spacing: 3mm,
    edge-stroke: .75pt,
    // NODES //
    node((0, 0), [0137], width: 1cm, name: <0>),
    node((6, 0), [247], width: 1cm, extrude: (-2, 0), name: <1>),
    node((6, 4), [58], width: 1cm, extrude: (-2, 0), name: <5>),
    node((3, 4), [68], width: 1cm, extrude: (-2, 0), name: <6>),
    node((3, 2), [7], width: 0.75cm, name: <7>),
    node((0, 4), [8], width: 1cm, extrude: (-2, 0), name: <8>),
    node((0, 5), $a^*b^+$, stroke: none),
    node((3, 5), $a b b$, stroke: none),
    node((6, 5), $a^*b^+$, stroke: none),
    // EDGES //
    edge((-2.2, 0), <0>, [start], "-|>", label-pos: 0.1),
    edge(<0>, <1>, $a$, "-|>"),
    edge(<0>, <8>, $b$, "-|>"),
    edge(<1>, <5>, $b$, "-|>"),
    edge(<1>, <7>, $a$, "-|>"),
    edge(<5>, <6>, $a$, "-|>"),
    edge(<6>, <8>, $b$, "-|>"),
    edge(<7>, <7>, $a$, "<|-", bend: 130deg, loop-angle: 135deg),
    edge(<7>, <8>, $b$, "-|>"),
    edge(<8>, <8>, $b$, "-|>", bend: 130deg, loop-angle: 180deg),
  ))
  Ad esempio, il DFA per i pattern $a$, $a b b$ e $a^* b^+$ combina i possibili stati di accettazione, garantendo la regola del prefisso più lungo e della priorità.
  La simulazione del DFA prosegue fino a raggiungere uno stato pozzo (dead state, $emptyset$) o quando non vi sono più transizioni possibili. A quel punto, si arretra fino all'ultimo stato DFA di accettazione visitato per determinare il lessema riconosciuto.
]
=== Operatore di lookahead
Lex legge automaticamente un carattere in più rispetto a quelli che formano il lessema selezionato e arretra il puntatore d'ingresso di una posizione in modo che solo i caratteri che formano il lessema siano effettivamente consumati. In alcuni casi, tuttavia, vogliamo che un dato pattern sia soddisfatto solo quando è seguito da uno o più altri caratteri specifici.

In tal caso si ricorre all'operatore slash (`/`) per indicare la fine della parte di pattern corrispondente al lessema. Ciò che segue lo slash è un'ulteriore parte di pattern che deve essere riconosciuta prima di poter decidere che il token in esame lo sia stato, ma che *non è parte del lessema stesso*.

L'operatore di lookahead (`/`) nei DFA richiede un'attenzione particolare: la fine del lessema è identificata dalla posizione nell'input in cui si entrava nello stato NFA precedente la $epsilon$-transizione associata all'operatore `/`, massimizzando la lunghezza della parte $r$ (supponendo un pattern della forma $r\/s$). In altre parole, l'automa deve "ricordare" lo stato in cui ha terminato di leggere il vero e proprio lessema $r$, procedendo a leggere $s$ solo per confermare la validità del contesto.
