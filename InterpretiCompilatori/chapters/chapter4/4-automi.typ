#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: ellipse

#pagebreak()
= Automi

== Automi a stati finiti

#definition()[
  Un automa a stati finiti deterministico (DFA) è una quintupla $A=(Q, Sigma, delta, q_0, F)$.
  - $Q$ insieme finito degli stati.
  - $F subset Q$: stati finali o accettanti.
  - $delta$ è funzione di transizione (mi dice dove andare letto un simbolo):
    - $delta:(Q times Sigma) -> Q quad quad$ (stato, simbolo)$->$stato
    - $delta(q_i, a)=q_j$
  - $q_0 in Q$, stato iniziale
]

Un linguaggio è accettato da un automa A se $L(A)={w in Sigma^* bar w " è accettato da A"}$. $L(A)$ può essere definito in maniera equivalente come:
$
  L(A)={w in Sigma^* bar [q_0, w] der(*) [q, epsilon], q in F}
$

#example()[
  Stringhe su {0,1} che contengono due 1 consecutivi.
]

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
      diagram(node-stroke: .1em, spacing: 2em, node((0, 0), radius: 1em, extrude: (-2.5, 0)), node((1, 0), radius: 1em)),
    )
]
Per adesso considereremo solo automi in cui $delta$ è *totale* ovvero ad ogni simbolo in input è associato uno stato.

#pagebreak()

#example(
  )[
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

  #observation(
    )[
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

#theorem(
  )[
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

  + Stringhe su {a,b} che non iniziano "aba":
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
    #grid(columns: (.5fr, 1fr),
      align(center)[
        #table(
          columns: (auto, auto, auto),
          align: center,

          [], [$abs(w)_a$], [$abs(w)_b$],
          table.cell(fill: rgb("#68e86680"), "S"), [*_pari_*], [*_pari_*],
          [A], [_dispari_], [_pari_],
          [B], [_pari_], [_dispari_],
          [C], [_dispari_], [_dispari_],
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
          edge((-3.7,0), <s>, "-|>"),
          edge(<s>, <a>, "-|>", [a], bend: 15deg),
          edge(<s>, <b>, "-|>", [b], bend: 15deg),
          edge(<a>, <s>, "-|>", [a], bend: 15deg),
          edge(<a>, <c>, "-|>", [b], bend: 15deg),
          edge(<b>, <s>, "-|>", [b], bend: 15deg),
          edge(<b>, <c>, "-|>", [a], bend: 15deg),
          edge(<c>, <a>, "-|>", [b], bend: 15deg),
          edge(<c>, <b>, "-|>", [a], bend: 15deg),
        )
      ]
    )
    
  + Stringhe su {a,b} di lunghezza dispari che contengono esattamente due "b":
    #grid(columns: (.5fr, 1fr),
      align(center)[
        #table(
          columns: (auto, auto, auto),
          align: center,

          [], [$abs(w)$], [$abs(w)_b$],
          [S], [_pari_], [0],
          [A], [_dispari_], [0],
          [B], [_dispari_], [1],
          [C], [_pari_], [1],
          [D], [_pari_], [2],
          table.cell(fill: rgb("#68e86680"), "E"), [*_dispari_*], [*2*],
          [F], [_pari,#linebreak()dispari_], [>2],
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
          edge((-3.7,0), <s>, "-|>"),
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
      ]
    )
  #colbreak()

  6. Stringhe su {a,b} in cui "aa" occorre solo una volta:
    #grid(columns: (.5fr, 1fr),
      align(center)[
        #table(
          columns: (auto, auto, auto),
          align: center,

          [], [_aa_], [u.c.],
          [S], [0], [$b(epsilon)$],
          [A], [0], [_a_],
          table.cell(fill: rgb("#68e86680"), "B"), [*1*], [_a_],
          table.cell(fill: rgb("#68e86680"), "C"), [*1*], [_b_],
          [D], [$>=2$], [_a,b_],
        )
      ],
      align(center)[
        #diagram(
          node-stroke: 0.9pt,
          cell-size: 5mm,
          spacing: 3mm,
          node((-3, 0), [S], extrude: (-2, 0), name: <s>),
          node((-1, 0), [A], name: <a>),
          node((1, 0), [B], name: <b>),
          node((3, 0), [C], name: <c>),
          node((1, 2), [D], name: <d>),
          edge((-4.2,0), <s>, "-|>"),
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
      ]
    )
]

In alcuni casi la *non appartenenza* di una stringa al linguaggio di un automa piò essere determinata anche prima di terminare la scansione della stringa, ad esempio quando si chiede che le stringhe non contengano una particolare sottostringa e questa viene indidividuata. In questi automi mancano alcune combinazioni di stato-simbolo perché corrispondono all'arresto.

== Automi a stati finiti non deterministici (NFA)

#definition(
  )[
  Un automa a stati finiti non deterministico (NFA) è una quintupla $A=(Q, Sigma, delta, q_0, F)$.
  - $Q$ insieme finito degli stati.
  - $Sigma$ insieme dei simboli in ingresso.
  - $F subset Q$: stati finali o accettanti.
  - $delta$ è funzione di transizione (mi dice dove andare letto un simbolo) che associa ad ogni stato per ogni simbolo in $Sigma union {epsilon}$ un insieme di prossimi stati.
  - $q_0 in Q$, stato iniziale
]

Gli automi a stati finiti non deterministici NFA sono più flessibili e spesso più semplici da progettare. La funzione di transizione associa ad ogni coppia stato, simbolo un sottoinsieme di Q:
$
  delta : Q times Sigma -> 2^Q
$
Se $delta(q, a)={q_1,q_2,...,q_k}$, allora quando l'automa si trova nella configurazione $[q,a w]$ può passare ad uno qualsiasi degli stati $q_1,q_2,...,q_k$.

Siccome un NFA è una rappresentazione astratta di un algoritmo per riconoscere una stringa, bisogna usare i DFA che invece sono concreti ed implementabili. Ogni espressione regolare e ogni NFA può essere convertito in un DFA che accetta lo stesso linguaggio.


L'algoritmo di simulazione DFA permette di applicare un DFA ad una stringa specifica. Esso richiede in input una stringa $x$, un DFA con stato iniziale $s_0$, l'insieme F di stati accettanti e una funzione di transizione $m o v e$.
#figure(```c
s = so; 
c = nextChar(); 
while ( c != eof ) { 
  s = move(s, c) ; 
  c = nextChar(); //Restituisce il prossimo carattere in x
} 
if ( s is in F ) return "yes "; 
else return "no"; 
```)

=== Da espressione regolare a NFA

Ogni espressione regolare può essere convertita in un NFA che definisce lo stesso linguaggio. L'algoritmo che permette di farlo, detto algoritmo di Thompson, si basa sull'induzione e sulla suddivisione dell'espressione base in sottoespressioni più semplici.

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

Dove $i$ e $f$ sono nuovi stati, rispettivamente lo stato iniziale e lo stato accettante. Per ogni sottoespressione $a in Sigma$ si costruisce il NFA seguente:

#figure(diagram(
  node-stroke: 0.9pt,
  cell-size: 5mm,
  spacing: 3mm,
  edge((-1, 0), (0, 0), "-|>"),
  node((0, 0), [$i$], radius: 1em),
  edge((0, 0), (2, 0), "-|>", [$a$]),
  node((2, 0), [$f$], radius: 1em, extrude: (-2.5, 0)),
))

#observation(
  )[
  Notare che in entrambe le costruzioni base si costruisce un NFA distinto, con nuovi stati, per ogni occorrenza di $epsilon$ o di una qualsiasi sottoespressione $a$.
]

#underline("Induzione:") supponiamo che $N(s)$ e $N(t)$ siano NFA per le espressioni regolari $s$ e $t$, rispettivamente.
+ Sia $r=s bar t$. Allora $N(r)$ è costruito come segue ($epsilon$ rappresenta una $epsilon$-transizione):
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

+ Sia $r=s t$. Allora $N(r)$ è costruito come segue:
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

#example(
  )[
Applichiamo l'algoritmo appena visto sull'espressione regolare `(a|b)*abb`. Per prima cosa dobbiamo costruire gli NFA dei vari simboli:

#figure(grid(columns: 2, column-gutter: 50pt, [#diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    edge((-1, 0), (0, 0), "-|>"),
    node((0, 0), [2], radius: 1em),
    edge((0, 0), (2, 0), "-|>", [$a$]),
    node((2, 0), [3], radius: 1em, extrude: (-2.5, 0)),
  )], [#diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    edge((-1, 0), (0, 0), "-|>"),
    node((0, 0), [4], radius: 1em),
    edge((0, 0), (2, 0), "-|>", [$b$]),
    node((2, 0), [5], radius: 1em, extrude: (-2.5, 0)),
  )]))
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
  node((3.5, 0.0), [7]),
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
]

=== Da NFA a DFA

Per poter convertire un NFA in un DFA esiste un algoritmo specifico che però necessita dell'uso di alcune operazioni specifiche definite come segue:

#table(
  columns: 2,
  rows: 4,
  inset: 8pt,
  [Operazione],
  [Descrizione],
  [$epsilon$-closure($s$)],
  [Insieme degli stati del NFA raggiungibili dallo stato $s$ unicamente mediante $epsilon$-transizioni. Ogni stato, letto $epsilon$, può rimanere anche su se stesso.],
  [$epsilon$-closure($T$)],
  [Insieme degli stati del NFA raggiungibili da un qualsiasi stato $s$ nell'insieme T unicamente mediante $epsilon$-transizioni, cioè $epsilon"-closure"(T)$ = $union.big_(s in T) epsilon"-closure"(s)$.],
  [$m o v e(T,a)$],
  [Insieme degli stati del NFA verso cui vi è una transizione con simbolo d'ingresso $a$, da un qualsiasi stato $s$ in $T$.],
)

Se ripredendiamo l'esempio di conversione da espressione regolare a NFA, possiamo vedere a che cosa corrispondono le operazioni appena introdotte:
- $epsilon"-cl(6)"={6,7,1,2,4}$
- $epsilon"-cl(8)"={8}$
- _move_$({2,3},a)={3}$

#example(
  )[
Continuiamo la conversione da espressione regolare a DFA, ricordando `(a|b)*abb`. Lo stato iniziale $A$ del DFA equivalente si ottiene con $epsilon$-closure(0), cioè $A={0,1,2,3,4,7}$ poiché questi sono tutti e soli gli stati raggiungibili dallo stato 0 seguende un percorso formato unicamente da archi etichettati con $epsilon$.
#figure(diagram(
  node-stroke: 0.9pt,
  cell-size: 5mm,
  spacing: 3mm,
  node((-4.0, 0), [0]), // start state (0)
  node((-2.0, 0), [1]),
  node((-0.5, 1.0), [2]),
  node((1.0, 1.0), [3]),
  node((2.0, 0.0), [6]),
  node((1.0, -1.0), [5]),
  node((-0.5, -1.0), [4]),
  node((3.5, 0.0), [7]),
  node((5.0, 0.0), [8]),
  node((6.5, 0.0), [9]),
  // final state: use `extrude` to create a double-stroke (double circle)
  node((8.5, 0.0), [10], extrude: (-2, 0)),
  // Edges (labels in square brackets). `bend` controls curvature.
  edge((-5.2, 0.0), (-4.0, 0.0), "-|>", [start]), // external incoming "start" arrow
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
Cominciamo costruendo delle tabelle di transizione:
$
  "Dtran"[A,a]=epsilon"-cl(move("A,a"))"=epsilon"-cl("{3,8}")"={3,6,7,1,2,4,8} = B quad quad (B eq.not A) \
  "Dtran"[A,b]=epsilon"-cl("{5}")"={1,2,4,5,6,7} = C quad quad (C eq.not A,B) \
  "Dtran"[B,a]=epsilon"-cl(move("B,a"))"=epsilon"-cl("{3,8}")"={3,6,7,1,2,4,8} = B
$
Alla fine, continuando così, si ottengono cinque stati:
#table(
  columns: 4,
  rows: 6,
  align: center,
  [Stato NFA],
  [Stato DFA],
  [$a$],
  [$b$],
  [${0,1,2,4,7}$],
  [$A$],
  [$B$],
  [$C$],
  [${1,2,3,4,6,7,8}$],
  [$B$],
  [$B$],
  [$D$],
  [${1,2,4,5,6,7}$],
  [$C$],
  [$B$],
  [$C$],
  [${1,2,4,5,6,7,9}$],
  [$D$],
  [$B$],
  [$E$],
  [${1,2,4,5,6,7,10}$],
  [$E$],
  [$B$],
  [$C$],
)
Gli stati finali del DFA sono quelli che contengono gli stati finali del NFA: in questo caso solo $E$ (contiene infatti 10). Attenzione, c'è sempre uno stato finale, altrimenti vi è un errore. Il DFA finale è quindi:
#figure(image("images/2025-10-09-09-28-35.png"))
]

//TODO: Aggiungere esempio extra da foto
#figure(image("images/2025-10-09-09-29-31.png"))