#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *
#import "@preview/cetz:0.5.2"

//30.03.2026
= Complessità computazionale

Conclusa l'analisi sulla calcolabilità, ci concentriamo ora sulla classe dei problemi decidibili, ovvero quei problemi per i quali è garantita l'esistenza di un algoritmo risolutivo che termini in tempo finito per ogni input. Quello che ci chiediamo è: qual è la complessità computazionale di questi problemi? Ovvero, quante risorse in termini di tempo e spazio richiede la sua risoluzione?

== Complessità temporale
#index[Complessità in tempo]
#definition()[
  Data una MdT $M$ standard, la complessità in tempo di $M$ è determinata dalla funzione *time complexity* ($t c_M$). Tale funzione calcola quanto ci mette $M$ a terminare su una stringa $w$ in input ed è definita nel seguente modo:
  $
    t c_M : NN -> NN\
    t c_M (n) = "# transizioni eseguite da "M" su una stringa di lunghezza" n" nel caso peggiore."
  $
]
Adesso definiamo le notazioni asintotiche:
#index[Notazione O grande]
#definition("Notazione O grande")[
  Siano $f,g : NN ->NN$. Allora $f in O(g)$ quando
  $
    exists C > 0, exists n_0 in NN, forall n gt.eq n_0 : frac(f(n), g(n)) lt.eq C "ossia" f(n) lt.eq C dot g(n)
  $
  ovvero quando, scegliendo un $n$ molto grande, il rapporto tra queste due funzioni tende a rimanere limitato, non sorpassa mai un certo valore costante.
]

#index[Notazione Omega]
#definition("Notazione Omega")[
  Siano $f,g : NN ->NN$. Allora $f in Omega(g)$ quando
  $
    exists D > 0, exists n_0 in NN, forall n gt.eq n_0 : frac(f(n), g(n)) gt.eq D "oppure" f(n) gt.eq D dot g(n)
  $
  ovvero quando quando il rapporto tra queste due funzioni sta sempre sopra ad un certo valore costante.
]

#index[Notazione Theta]
#definition("Notazione Theta")[
  Siano $f,g : NN ->NN$. Allora $f in Theta(g)$, quando $f in O(g)$ e $f in Omega(g)$, cioè quando
  $
    exists C,D > 0, exists n_0 in NN, forall n gt.eq n_0 : C lt.eq frac(f(n), g(n)) lt.eq D
  $
  ovvero il rapporto tra queste due funzioni rimane compreso tra un valore minimo e un valore massimo.
]
#figure(image("images/notazioniAsintotiche.png", width: 70%))
#index[Notazione o piccolo]
#definition("Notazione o piccolo")[
  Siano $f,g : NN ->NN$. Allora $f in o(g)$, quando $f$ è di un ordine di grandezza strettamente inferiore a $g$, va all'infinito molto più lentamente rispetto a $g$. Cioè, formalmente:
  $
    lim_(n->infinity) f(n)/g(n) = 0
  $
]

#observation()[
  $f in o(g) => f in O(g)$
]

#index[Funzioni asintotiche]
#definition("Equivalenza asintotica")[
  Siano $f,g : NN ->NN$. Allora $f tilde g$, ($f$ asintotica $g$) quando le due funzioni all'infinito tendono ad attaccarsi. Si può scrivere come:
  $
    lim_(n->infinity) f(n)/g(n) = 1
  $
]

#observation()[
  $f tilde g => f in Theta(g)$
]
#example()[
  Sia $M$ una MdT che accetta il linguaggio $L$ delle stringhe palindrome binarie sull'alfabeto $Sigma = {a,b}$. Mostriamo come $M$ procede per controllare se la stringa in input sia palindroma o no:
  1. Legge il primo simbolo della stringa e lo cancella
  2. Va in fondo alla stringa
  3. Se trova lo stesso simbolo, lo cancella e torna a inizio stringa (ripete dal punto 1), finché la stringa non finisce.
  4. Altrimenti termina.
  #figure(image("images/2026-03-30-12-20-44.png", width: 60%))
  In questo caso, il caso peggiore (ovvero quello in cui si ha il massimo numero di transizioni) si ha quando la stringa viene accettata. Distinguiamo due casi:

  - La lunghezza della stringa è un numero pari $n=2k$:
    $
      [1+2 + (2k-1)] + [1+2 + (2k-2)] + [1+2 + (2k-3)] + dots+ [1+2 + 2] + [1+2 + 1] \ = 2 + sum_(i=0)^(2k-1) (3+i) = 2 + sum_(i=0)^(2k-1)(3) + sum_(i=0)^(2k-1)(i) = 2+3 dot 2k + frac(2k(2k-1), 2) = frac(n(n-1), 2)+3n+2
    $
  - La lunghezza della stringa è un numero dispari $n=2k-1$:
    $
      [1+2 + (2k-2)] + [1+2 + (2k-3)] + [1+2 + (2k-4)] + dots+ [1+2 + 2] + [1+2 + 1] \ = 4+ sum_(i=0)^(2k-2) (3+i) = 4+3(2k-1) + frac((2k-2)(2k-1), 2) = 4+3n + frac(n(n-1), 2)
    $
  Quindi, in conclusione, abbiamo che la complessità è di tipo polinomiale, più precisamente è quadratica. ($Theta(n^2)$)
]

=== Complessità nelle MdT multitraccia
#proposition()[
  $M$ MdT multitraccia che accetta $L$, avente complessità in tempo $t c_M (n)=f(n) =>$ esiste una MdT $M'$ standard che accetta $L$ tale che $t c_M' (n) = f(n)$. Ovvero hanno la stessa complessità temporale (compiono lo stesso numero di transizioni).
]

=== Complessità nelle MdT multinastro
#proposition()[
  $M$ MdT a $k$ nastri ($k>1$) che accetta $L$ con complessità $t c_M (n)=f(n)=>$ esiste una MdT $M'$ standard equivalente che accetta $L$ tale che $t c_M' (n) = O(f(n)^2)$.
]
#proof()[
  Consideriamo una MdT $M$ a $k$ nastri e prendiamo la MdT $M'$ a $2k+1$ tracce che è equivalente a $M$ già descritta nella prima parte del corso (Proposizione 2.5.1), ma ricordiamo com'è fatta per $k=2$:
  #figure(image("images/MdTmultitracciaPerSimulareMdTmultinastro.png", width: 60%))
  Sia $w$ una stringa di lunghezza $n$ su cui eseguiamo $M$ e supponiamo che $M$ su $w$ esegua $f(n)$ transizioni. Vediamo prima quante transizioni di $M'$ sono necessarie per simulare la $t$-esima transizione di $M$ su $w$: dapprima si ha il momento della raccolta delle informazioni, in cui la testina di $M'$ si   sposta sulle tracce in corrispondenza della posizione delle testine dei nastri per leggere i simboli e salvarli nello stato. La posizione di ciascuna testina simulata può trovarsi a distanza al massimo $t$ dalla posizione iniziale, perché alla $t$-esima transizione una testina può essersi spostata di al massimo di $t$ celle. Giunti alla cella, si legge il simbolo e si torna indietro: per cui vengono fatti al massimo $t$ passi avanti e $t$ passi indietro per tutti i $k$ nastri di $M$, dunque il costo di questa fase è $2t k$ (vedere la Proposizione 2.5.1 per i passaggi in dettaglio). Per simulare correttamente la transizione poi si deve eseguirla effettivamente, quindi tornare sulla posizione $k$ per effettuare scritture/spostamenti delle testine simulate, e anche in questo caso il costo è $2t k$. Quindi la stima del numero massimo di transizioni che $M'$ deve effettuare per simulare la $t$-esima transizione di $M$ è $2t k + 2t k = 4t k$.\ A questo punto possiamo stimare il limite superiore del numero di transizioni eseguite da $M'$ su input di lunghezza $n$ nel caso peggiore:
  $
    sum_(t=1)^(f(n)) 4 t k =
    4k dot sum_(t=1)^(f(n)) t = 4k dot frac(f(n) dot (f(n)+1), 2) = Omicron(f(n)^2)
  $
]
#example([
  Sia $L$ il linguaggio delle stringhe palindrome sull'alfabeto $Sigma = {a, b}$. Costruiamo una MdT $M$ a due nastri che accetti $L$. La strategia da seguire è la seguente:

  - Copiare la stringa in input (scritta sul primo nastro) sul secondo nastro;
  - Portare una delle due testine all'inizio del nastro e l'altra alla fine;
  - Confrontare le due stringhe muovendo le testine in direzioni opposte.

  La MdT $M$ in questione è la seguente:

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *

      let r = 0.45
      let dx = 3.5

      set-style(mark: (end: ">", fill: black))

      // Nodi / Stati
      circle((0, 0), radius: r, name: "q0")
      content("q0.center", $q_0$)

      circle((dx, 0), radius: r, name: "q1")
      content("q1.center", $q_1$)

      circle((dx * 2, 0), radius: r, name: "q2")
      content("q2.center", $q_2$)

      circle((dx * 3, 0), radius: r, name: "q3")
      content("q3.center", $q_3$)

      // Stato di accettazione (doppio cerchio)
      circle((dx * 4, 0), radius: r, name: "q4")
      circle("q4.center", radius: r - 0.1)
      content("q4.center", $q_4$)

      // Freccia iniziale
      line((-1.2, 0), (-0.45, 0), mark: (end: ">"))

      // Transizioni lineari
      line((r, 0), (dx - r, 0), mark: (end: ">"), name: "t01")
      content("t01.mid", [$(*,*) \/ (D,D)$], anchor: "south", padding: 0.1)

      line((dx + r, 0), (dx * 2 - r, 0), mark: (end: ">"), name: "t12")
      content("t12.mid", [$(*,*) \/ (*,S)$], anchor: "south", padding: 0.1)

      line((dx * 2 + r, 0), (dx * 3 - r, 0), mark: (end: ">"), name: "t23")
      content("t23.mid", [$(*,*) \/ (S,D)$], anchor: "south", padding: 0.1)

      line((dx * 3 + r, 0), (dx * 4 - r, 0), mark: (end: ">"), name: "t34")
      content("t34.mid", [$(*,*) \/ (*,*)$], anchor: "south", padding: 0.1)

      // Parametri per la curvatura dei loop
      let loop_x = 0.25
      let loop_y = 0.38
      let ctrl_x = 0.6
      let ctrl_y = 1.6

      // Loop superiore q1
      bezier(
        (dx - loop_x, loop_y),
        (dx + loop_x, loop_y),
        (dx - ctrl_x, ctrl_y),
        (dx + ctrl_x, ctrl_y),
        mark: (end: ">"),
        name: "q1_top",
      )
      content("q1_top.mid", anchor: "south", padding: 0.1, align(center)[$(b,*) \/ (b,b)$ \ $(a,*) \/ (a,a)$])

      // Loop inferiore q1
      bezier(
        (dx - loop_x, -loop_y),
        (dx + loop_x, -loop_y),
        (dx - ctrl_x, -ctrl_y),
        (dx + ctrl_x, -ctrl_y),
        mark: (end: ">"),
        name: "q1_bot",
      )
      content("q1_bot.mid", anchor: "north", padding: 0.1, align(center)[$(a,a) \/ (D,D)$ \ $(b,b) \/ (D,D)$])

      // Loop superiore q2
      bezier(
        (dx * 2 - loop_x, loop_y),
        (dx * 2 + loop_x, loop_y),
        (dx * 2 - ctrl_x, ctrl_y),
        (dx * 2 + ctrl_x, ctrl_y),
        mark: (end: ">"),
        name: "q2_top",
      )
      content("q2_top.mid", anchor: "south", padding: 0.1, align(center)[$(*,b) \/ (*,S)$ \ $(*,a) \/ (*,S)$])

      // Loop superiore q3
      bezier(
        (dx * 3 - loop_x, loop_y),
        (dx * 3 + loop_x, loop_y),
        (dx * 3 - ctrl_x, ctrl_y),
        (dx * 3 + ctrl_x, ctrl_y),
        mark: (end: ">"),
        name: "q3_top",
      )
      content("q3_top.mid", anchor: "south", padding: 0.1, align(center)[$(b,b) \/ (S,D)$ \ $(a,a) \/ (S,D)$])
    })
  ]

  Studiamo la complessità: in questo caso, il *caso peggiore* col massimo numero di transizioni si ha nel caso in cui la stringa viene *accettata*.
  $ t c_M (n) = 1 + 2n + 1 + n + 1 + n + 1 = 4n + 4 = Theta(n) $
  La complessità è *polinomiale*, è un polinomio di primo grado (*lineare*):
  - $1$ passo: posizionamento sul primo carattere ($q_0 arrow q_1$).
  - $2n$ passi: copia del nastro 1 sul nastro 2 ($q_1$).
  - $1$ passo: lettura del vuoto a fine stringa ($q_1 arrow q_2$).
  - $n$ passi: riavvolgimento del nastro 2 fino all'inizio ($q_2$).
  - $1$ passo: allineamento testine sui bordi opposti ($q_2 arrow q_3$).
  - $n$ passi: confronto incrociato dei caratteri ($q_3$).
  - $1$ passo: transizione allo stato di accettazione finale ($q_3 arrow q_4$).

  Nota sullo stile: non è necessario nelle transizioni tipo $(b, b)\/(S, D)$ scrivere parentesi e virgole, cioè si può scrivere $b b\/S D$.
])
=== Complessità nelle MdT non deterministiche
#definition()[
  Data una MdT _M_ non deterministica, la *complessità in tempo* di _M_ è determinata dalla funzione:
  $
    t c_M (n) = & \# "transizioni eseguite da una computazione di" M "su una stringa di lunghezza "n \
                & "nel caso peggiore".
  $
]

#proposition()[
  Sia _M_ MdT non deterministica che accetta il linguaggio _L_ e tale che $t c_M (n) = f(n)$. Allora $exists M' "MdT deterministica che accetta "L space "t.c." space t c_M'(n)=Omicron(f(n) dot delta^(f(n)))$, con $delta$ grado di non determinismo di $M$.
]

#proof()[
  Costruiamo una MdT deterministica $M'$ a tre nastri che simula
  sistematicamente tutte le possibili computazioni di $M$.
  La macchina $M'$ usa i tre nastri nel modo seguente:

  - sul nastro 1 mantiene l'input;
  - sul nastro 2 simula una computazione di $M$;
  - sul nastro 3 mantiene la sequenza $(m_1, dots, m_(f(n)))$ che determina le scelte non deterministiche della computazione da simulare.
  Poiché $M$ ha grado di non determinismo $delta$, a ogni passo della
  computazione può scegliere tra al più $delta$ transizioni. Una possibile
  computazione di lunghezza al più $f(n)$ può quindi essere descritta da
  una sequenza
  $
    (m_1, m_2, dots, m_(f(n))), quad 1 <= m_i <= delta,
  $
  dove $m_i$ indica quale delle possibili transizioni di $M$ viene scelta
  all'$i$-esimo passo. Il numero di possibili sequenze, e quindi di possibili computazioni da simulare, è al più $delta^(f(n))$: infatti, per ciascuno degli al più $f(n)$ passi vi sono al più $delta$
  possibili scelte.\
  Per ciascuna di queste computazioni, $M'$ deve simulare al più $f(n)$
  transizioni di $M$, poiché $t c_M(n)=f(n)$ (dove $n$ è la lunghezza dell'input). Pertanto, nel caso peggiore, $M'$ simula al più $delta^(f(n))$ computazioni, ciascuna di costo al più $f(n)$. Ne segue
  $
    t c_(M')(n)
    = O(f(n) dot delta^(f(n))).
  $
  Se almeno una delle computazioni simulate accetta, $M'$ accetta;
  se nessuna accetta, $M'$ rifiuta. Quindi $M'$ è equivalente a $M$.
]
#example()[
  #image("images/2026-04-01-11-50-50.png")
  #align(center)[
    #cetz.canvas({
      import cetz.draw: *

      let r = 0.5
      let dx = 4.0

      set-style(mark: (end: ">", fill: black))

      // Stati
      circle((0, 0), radius: r, name: "q0")
      content("q0.center", $q_0$)

      circle((dx, 0), radius: r, name: "q1")
      content("q1.center", $q_1$)

      circle((dx * 2, 0), radius: r, name: "q2")
      content("q2.center", $q_2$)

      circle((dx * 2.8, 0), radius: r, name: "q3")
      circle("q3.center", radius: r - 0.08)
      content("q3.center", $q_3$)

      // Freccia iniziale
      line((-1.2, 0), "q0.west", mark: (end: ">"))

      // q0 -> q1
      line("q0.east", "q1.west", name: "t01", mark: (end: ">"))
      content("t01.mid", anchor: "south", padding: 0.1, [
        $(*,*) \/ (D,D)$
      ])

      // q1 loops
      let loop_h = 1.6
      let loop_w = 0.6
      bezier("q1.north-west", "q1.north-east", (dx - loop_w, loop_h), (dx + loop_w, loop_h), name: "q1_top", mark: (
        end: ">",
      ))
      content("q1_top.mid", anchor: "south", padding: 0.1, align(center)[$(a,*) \/ (a,a)$ \ $(b,*) \/ (b,b)$])

      bezier("q1.south-west", "q1.south-east", (dx - loop_w, -loop_h), (dx + loop_w, -loop_h), name: "q1_bot", mark: (
        end: ">",
      ))
      content("q1_bot.mid", anchor: "north", padding: 0.1, align(center)[$(a,a) \/ (D,D)$ \ $(b,b) \/ (D,D)$])

      // q1 -> q2 (due frecce)
      bezier("q1.east", "q2.west", (dx + 1.2, 0.4), (dx * 2 - 1.2, 0.4), name: "t12_top", mark: (end: ">"))
      content("t12_top.mid", anchor: "south", padding: 0.1, align(center)[$(a,*) \/ (D,S)$ \ $(b,*) \/ (D,S)$])

      bezier("q1.east", "q2.west", (dx + 1.2, -0.4), (dx * 2 - 1.2, -0.4), name: "t12_bot", mark: (end: ">"))
      content("t12_bot.mid", anchor: "north", padding: 0.1, align(center)[$(a,*) \/ (a,S)$ \ $(b,*) \/ (b,S)$])

      // q2 loop
      bezier(
        "q2.north-west",
        "q2.north-east",
        (dx * 2 - loop_w, loop_h),
        (dx * 2 + loop_w, loop_h),
        name: "q2_top",
        mark: (end: ">"),
      )
      content("q2_top.mid", anchor: "south", padding: 0.1, align(center)[$(a,a) \/ (D,S)$ \ $(b,b) \/ (D,S)$])

      // q2 -> q3
      line("q2.east", "q3.west", name: "t23", mark: (end: ">"))
      content("t23.mid", anchor: "south", padding: 0.1, [$(*,*) \/ (*,*)$])
    })
  ]

  La prima transizione (dall'alto) che va da $q_1$ a $q_2$ gestisce il caso di stringhe di lunghezza dispari (si salta il simbolo centrale nel nastro 1 e poi si parte col confronto), l'altra quelle di lunghezza pari (la testina sul nastro 1 è già in posizione corretta, bisogna solo spostare quella del nastro 2). Il caso peggiore si ha quando la MdT rifiuta la stringa, più precisamente la computazione in cui copio tutta la stringa sul secondo nastro: la macchina sceglie nondeterministicamente se continuare a copiare o meno, quindi può darsi che scelga una computazione in cui tutta la stringa viene copiata e quindi $t c_M (n)= 1 + 2n$ (costo 1 per la transzione $q_0 -> q_1$, poi fa 2 operazioni (copia e spostamento) per $n$ simboli in $q_1$ e si arresta).
]
== Classi P e NP
Sebbene le complessità di alcuni algoritmi ($n^3, n^4, ...$) siano considerate elevate, noi saremo più permissivi e considereremo efficienti tutte le complessità polinomiali. Alla luce delle considerazioni fatte sulle varie tipologie di MdT, definiamo le seguenti classi di linguaggi (o "problemi", più in generale):
#index[Classe P]
#definition()[
  P $={L "linguaggio" | exists M "MdT deterministica che accetta "L "t.c." t c_M (n)=Omicron(n^r), exists r in NN}$

  I problemi in questa classe si considerano risolvibili in maniera efficiente (trattabili).
]
#index[Classe NP]
#definition()[
  NP = ${L "linguaggio" | exists M "MdT non determ. che accetta "L "t.c." t c_M (n)=Omicron(n^r), exists r in NN}$.\

  Un problema che è classificato NP è _verificabile_ in tempo polinomiale da una MdT deterministica (che equivale a dire, come da definizione, che esiste una MdT non deterministica che lo _risolve_ in tempo polinomiale). In altre parole, se ci viene fornita una possibile soluzione, possiamo controllare efficientemente che sia effettivamente una soluzione; ciò non implica però che siamo in grado di trovare deterministicamente, partendo dall'input del problema, tale soluzione in tempo polinomiale.
]

#observation()[
  P $subset.eq "NP"$, perché le MdT deterministiche sono un caso particolare di MdT non deterministiche. Vale anche l'inclusione nel verso opposto? Non si sa, è un problema aperto.
]

#problem("P vs NP")[
  Il problema aperto attualmente più importante in informatica teorica è:
  $
    P limits(=)^? N P
  $
]

== Problema del circuito hamiltoniano (HAM)

Sia $G=(V, E)$ un grafo orientato, con:
- _V_ insieme dei vertici,
- _E_ insieme degli archi (detti anche "lati")
- $|V|=n$ cardinalità dell'insieme dei vertici


#index[Circuito hamiltoniano]#index[Cammino hamiltoniano]
#definition()[
  Dato un grafo orientato $G=(V, E)$, con $V = {x_1, dots, x_n}$, un *circuito hamiltoniano* in _G_ è una sequenza $(x_1,x_2, dots, x_(n-1), x_n, x_1)$ di vertici t.c.
  $
    forall i, space (x_i, x_(i+1)) in E, " con" (x_n, x_1) in E
  $
  In parole povere, un circuito hamiltoniano è un ciclo che passa una e una sola volta da tutti i vertici di un grafo per poi ritornare al vertice di partenza.
]
#problem("HAM")[
  Dato un grafo orientato $G=(V,E)$, decidere se $G$ contiene un circuito hamiltoniano.
]
Affinché una MdT possa lavorare con i grafi è necessario codificare questi ultimi. Una codifica di $G=(V,E), V={1, 2, dots, n}$ può essere la seguente:

- Codifica dei vertici: uso la codifica binaria;
- Codifica degli archi: $(x_i, x_j) arrow.squiggly x_i\#x_j$;
- Codifica del grafo: codifica della lista degli archi $+ space n$ numero dei vertici. Per separare gli archi nella codifica si usa \#\# e per separare $n$ si usa \#\#\#.

$
  dots space x_i\#x_j\#\#x_(i+1)\#x_(j+1)\#\# space dots space \#\#\#n
$
=== MdT deterministica che risolve HAM
Un algoritmo _naive_ (perché prova tutti i cammini possibili) che risolve questa problema è dato da una MdT che fa uso di 4 nastri:

- Nastro 1: contiene la rappresentazione del grafo in input;
- Nastro 2: contiene la sequenza dei nodi attualmente in analisi (lunga $n+1$, inizia e termina con il nodo 1);
- Nastro 3: è quello di lavoro, cioè quello che si usa per vedere se la sequenza è hamiltoniana: ci si scrive tutti i nodi che passano il controllo;
- Nastro 4: serve per indicare quando fermare la generazione, contiene l'ultima sequenza possibile da controllare;
#figure(image("images/naiveHamNastri.png", width: 50%))
La MdT opera in questo modo:

+ Scrivo sul nastro 4 la sequenza massima generabile ($1, n, n, dots, n, 1$).
+ Sul nastro 2 genero (una dopo l'altra in ordine lessicografico) le stringhe di lunghezza $n+1$ composte da vertici di $V$, che iniziano e finiscono con 1.
+ Confronto la stringa generata sul nastro 2 col contenuto del nastro 4: se sono uguali e i controlli non sono passati, *RIFIUTO* (ho esaurito le possibilità).
+ Svuoto il nastro 3, poi scorro la sequenza sul nastro 2 e $forall j$ da 2 a $n+1$:
  - controllo che $i_j$ non compaia tra gli elementi già scritti sul nastro 3 (verifico l'assenza di vertici ripetuti, eccezion fatta per l'ultimo nodo che deve essere 1).
  - controllo che l'arco $(i_(j-1), i_j) in E$ (cercandolo sul nastro 1);
  - Se entrambi i controlli sono passati, scrivo $i_j$ sul nastro 3. *ALTRIMENTI*, la sequenza attuale non è un circuito hamiltoniano: interrompo il ciclo e torno al passo 2 per generare la prossima.
+ Se il ciclo al passo 4 termina con successo per tutti i nodi della sequenza, allora ho trovato un circuito hamiltoniano valido: *ACCETTO*.
Analizzando la complessità, il caso peggiore è quello della non accettazione, cioè il caso in cui $G$ non contenga alcun circuito hamiltoniano: in tal caso vengono generate tutte le sequenze possibili, della forma $(1, i_1, dots, i_(n-1), 1)$: il primo e l'ultimo vertice sono fissati, ma ci sono $n-1$ posizioni libere e ciascuna può assumere $n$ valori, quindi le sequenze sono in numero $n^(n-1)$, e di conseguenza questo algoritmo ha complessità esponenziale.\
Attenzione: nonostante ciò non possiamo dire che HAM $in.not$ P. Per poterlo dire, dovremmo dimostrare che *nessuna* macchina deterministica può risolvere il problema in tempo polinomiale (che equivarrebbe a dimostrare P $!=$ NP).
=== MdT non deterministica che risolve HAM
Vediamo un'altra MdT, stavolta non deterministica, che risolve il problema HAM. Sia dato un grafo $G = (V, E)$, con $|V| = n$ e $|E| = k$. La codifica del grafo è quella già vista. La MdT non deterministica fa uso di 3 nastri, che sono gli stessi del caso deterministico escluso il nastro 4. Il comportamento è il seguente:

1. verifico se $k < n$: in tal caso non può esserci circuito e quindi si termina rifiutando;
2. genero nondeterministicamente sul nastro 2 una sequenza di vertici "candidata" circuito hamiltoniano;
3. controllo col nastro 3 se la sequenza generato è un circuito hamiltoniano: scrivo i vertici via via su tale nastro e verifico se esiste un arco che collega il vertice attuale al successivo, senza duplicazioni. Se i controlli falliscono, termino rifiutando.

Dal punto di vista della complessità in tempo, che rappresentiamo in funzione di $k$ numero di archi, il caso peggiore è quello dell'accettazione. In tal caso si ha $k >= n$. I costi dei vari passi sono:

- Controllo che il grafo abbia almeno $n$ archi: scorro la lista del nastro 1 e mantengo un contatore. Ogni volta che trovo \#\#  incremento di 1 e infine faccio un confronto con $n$. Poichè ogni vertice $v_i$, $i = 1, dots, n$, è codificato in binario, occupa al più $O(log n)$ celle. Dunque se la codifica di un arco è $v_i \# v_j$, anche un arco occupa $O(log n)$ celle. Essendoci $k$ archi, il costo di questo passo è $O(k log n)$.
- Generazione della sequenza sul nastro 2: scrivo al più $n$ vertici, ciascuno che occupa al più $O(log n)$ celle, quindi il costo del passo è $O(n log n)$.
- Controllo della sequenza: per ogni iterazione del ciclo:
  - controllo che il nuovo vertice non sia già comparso: $O(n log n)$;
  - verifico che ci sia un arco dal vertice precedente al nuovo vertice: $O(k log n)$;
  - riposiziono  la testina del nastro 3: $O(n log n)$;
  - ci sono al più $n$ iterazioni, dunque la complessità è $O(k log n)$ per iterazione, ossia $O(n k log n)$ in totale.
Complessivamente si ha:
$
  O(k log n) + O(n log n) + O(n k log n) overbracket(<=, k >= n) \ <= O(k log k) + O(k log k) + O(k^2 log k) approx O(k^2 log k) <= O(k^3)
$
da questo deduciamo anche che HAM $in$ NP (in realtà andrebbe considerata la lunghezza dell'input per la funzione $t c_M$, ma con la codifica scelta la lunghezza dell'input è polinomialmente legata a $n$ e $k$, quindi il risultato resta polinomiale).
== Riducibilità polinomiale fra linguaggi
#index[Riduzione polinomiale]
#definition()[
  Dati $L_1$, $L_2$ linguaggi, $L_1 subset.eq Sigma_1^*$ e $L_2 subset.eq Sigma_2^*$, si dice che $L_1$ è *polinomialmente riducibile* a $L_2$ quando:
  - $L_1$ è riducibile a $L_2$, cioè $exists f: Sigma_1^* -> Sigma_2^*$ tale che:
    - $forall w in Sigma_1^*, space w in L_1 <=> f(w) in L_2$
    - $f$ è computabile
  - $f$ è computabile in tempo polinomiale
  In questo caso $f$ si dice *riduzione polinomiale* da $L_1$ a $L_2$ e se $F$ è la MdT che la calcola si ha che $t c_F (n) in O(n^r)$, $r in NN$
]
#proposition()[
  Sia $f$ una riduzione polinomiale da $L_1 subset.eq Sigma_1^*$ a $L_2 subset.eq Sigma_2^*$ e $L_2 in P$. Allora $L_1 in P$.
]
#proof()[
  Dobbiamo costruire una MdT deterministica, che chiameremo $N$, che decida il linguaggio $L_1$ in tempo polinomiale su un input $w in Sigma_1^*$.

  Dalle ipotesi del teorema sappiamo che:
  - Esiste una riduzione polinomiale $f: Sigma_1^* -> Sigma_2^*$ da $L_1$ a $L_2$.
  - Sia $F$ la MdT che calcola $f$ in tempo $t c_F (n) in O(n^r)$, dove $n = |w|$.
  - Poiché $L_2 in P$, sia $M$ la MdT deterministica che decide $L_2$ in tempo $t c_M (k) in O(k^s)$, dove $k$ è la lunghezza del suo input.

  Costruiamo la macchina $N$ applicando la seguente strategia sull'input $w$:
  1. Calcoliamo $f(w)$ usando la macchina $F$.
  2. Eseguiamo la macchina $M$ sull'input $f(w)$ per decidere se $f(w) in L_2$.
  3. $N$ accetta $w$ se e solo se $M$ accetta $f(w)$.

  Analisi della complessità temporale di $N$: la lunghezza della stringa output $f(w)$ non può superare il numero di passi compiuti da $F$ per generarla. Pertanto, la lunghezza dell'input che passiamo a $M$ è limitata da $|f(w)| <= t c_F (n) in O(n^r)$.

  Il tempo totale impiegato da $N$ è la somma del tempo di $F$ e del tempo di $M$:
  $
    t c_N (n) & = t c_F (n) + t c_M (n^r) = \
              & = O(n^r) + O((n^r)^s) = \
              & = O(n^r) + O(n^(r s)) = O(n^(r s))
  $
  Il tempo di esecuzione di $N$ è limitato da un polinomio, dimostrando quindi che $L_1 in P$.
]
=== Problemi NP-difficili e NP-completi
#index[NP-difficile]
#definition()[
  Un linguaggio $L$ si dice *NP-difficile* quando $forall Q in "NP"$, $Q$ è polinomialmente riducibile a $L$. \
  
  In altri termini: "$Q$ è difficile *al più* quanto $L$" o equivalentemente "$L$ è difficile *almeno* quanto $Q$". Quindi risolvere $L$ è sufficiente per risolvere $Q$.
]

#index[NP-completo]
#definition()[
  Un linguaggio $L$ si dice *NP-completo* quando:
  - $L$ è NP-difficile
  - $L in "NP"$
]

#observation()[
  La classe dei linguaggi NP-completi (indicata con NPC) è una sottoclasse di $"NP"$. $"NPC" = { L | L in "NP" " e " L " è NP-difficile" }$. Di conseguenza, vale  $"NPC" subset.eq "NP"$.
]

#proposition()[
  Se esiste un linguaggio $L$ tale che $L in "NPC"$ e $L in "P"$, allora $"P" = "NP"$.
]
#proof()[
  Per definizione, sappiamo che $"P" subset.eq "NP"$. Quindi è sufficiente dimostrare che $"NP" subset.eq "P"$.

  Sia $Q in "NP"$ un linguaggio arbitrario.
  Poiché $L in "NPC"$, allora $exists$ una riduzione polinomiale $f$ da $Q$ a $L$. Inoltre, $L in "P"$, quindi esiste una MdT $M$ che accetta $L$ in tempo polinomiale.

  Costruiamo una MdT deterministica $M'$ per decidere $Q$ su input $w$:
  1. Calcoliamo $f(w)$. Poiché $f$ è una riduzione polinomiale, questo passo richiede un tempo polinomiale.
  2. Usiamo la macchina $M$ sull'input $f(w)$ per decidere se $f(w) in L$. Poiché $M$ opera in tempo polinomiale e la dimensione di $f(w)$ è limitata da un polinomio, anche questo passo richiede tempo polinomiale.

  La macchina $M'$ è deterministica e decide $Q$ terminando in un tempo totale polinomiale. Ne consegue che $Q in "P"$. Data l'arbitrarietà di $Q$, abbiamo dimostrato che ogni problema in $"NP"$ è anche in $"P"$, ovvero $"NP" subset.eq "P"$. Dunque, $"P" = "NP"$.
]

#align(center, cetz.canvas(length: 0.6cm, {
  import cetz.draw: *

  // ==========================================
  // SCENARIO 1: P != NP
  // ==========================================
  group(name: "p-neq-np", {
    // Titolo
    content((0, 4.2), text(weight: "bold", size: 1.5em)[NP])

    // Ovale principale
    circle((0, 0), radius: (2, 3.5), name: "oval1")

    // Curva di separazione superiore (piega verso il basso)
    bezier((-1.81, 1.5), (1.81, 1.5), (0, 0.5))

    // Curva di separazione inferiore (piega verso l'alto)
    bezier((-1.81, -1.5), (1.81, -1.5), (0, -0.5))

    // Etichette interne
    content((0, 2.3), text(weight: "bold", size: 1.5em)[NPC])
    content((0, 0), text(weight: "bold", size: 1.5em)[NP-I])
    content((0, -2.3), text(weight: "bold", size: 1.5em)[P])
  })

  // ==========================================
  // SCENARIO 2: P = NP
  // ==========================================
  group(name: "p-eq-np", {
    // Sposto il secondo diagramma in basso
    translate(x: 5)

    // Titolo
    content((0, 4.2), text(weight: "bold", size: 1.5em)[NP=P])

    // Ovale principale
    circle((0, 0), radius: (2, 3.5), name: "oval2")

    // Etichetta interna
    content((0, 0), text(weight: "bold", size: 1.5em)[NPC])
  })
}))

I diagrammi sopra illustrano le due possibili soluzioni al più grande problema aperto dell'informatica teorica, *P vs NP*. Il diagramma di sinistra mostra lo scenario più accreditato, $"P" != "NP"$, in cui l'insieme dei problemi verificabili in tempo polinomiale (NP) è rigidamente diviso tra problemi facilmente risolvibili (P), i problemi più complessi in assoluto a cui tutti gli altri sono riconducibili (NP-Completi) e una fascia di mezzo (NP-Intermedi) che non ricade in nessuna delle due. Il diagramma a destra, al contrario, rappresenta lo scenario che avrebbe enormi conseguenze per l'informatica. Infatti, se venisse dimostrato che $"P" = "NP"$, l'intera struttura collasserebbe: NP-I sarebbe vuota e ogni linguaggio non banale di NP sarebbe NP-completo; in particolare, tutti i problemi NP-completi diventerebbero risolvibili in tempo polinomiale.


#proposition()[
  Supponiamo che $"P" = "NP"$. Sia $L in "NP"$, con $L eq.not emptyset$ e $overline(L) eq.not Sigma^*$. Allora $L in "NPC"$. \
]
#proof()[
Poiché $L in$ NP, per dimostrare che $L$ è NP-completo è sufficiente
mostrare che $L$ è NP-difficile.

Dalle ipotesi $L != emptyset$ e $L != Sigma^*$ esistono due stringhe fissate
$alpha$ e $beta$ tali che $alpha in L$ e $beta in.not L$. Sia ora $Q in$ NP un linguaggio arbitrario. Poiché per ipotesi P = NP,
si ha anche $Q in P$; esiste quindi un algoritmo deterministico che decide
in tempo polinomiale, per ogni stringa $w$, se $w in Q$.

Definiamo la funzione
$
  f(w) := cases(
    alpha & "se " w in Q,
    beta & "se " w in.not Q.
  )
$

Verifichiamo che $f$ è una riduzione polinomiale da $Q$ a $L$. Per costruzione:
- se $w in Q$, allora $f(w) = alpha in L$;
- se $w in.not Q$, allora $f(w) = beta in.not L$.

Pertanto $w in Q <==> f(w) in L.$ Resta da verificare che $f$ sia calcolabile in tempo polinomiale.
Su input $w$, l'algoritmo che calcola $f$ procede nel modo seguente:

1. decide se $w in Q$ usando l'algoritmo polinomiale per $Q$ (che esiste in quanto $Q in$ P);
2. se $w in Q$ restituisce $alpha$, altrimenti restituisce $beta$.

Il primo passo richiede tempo polinomiale in $|w|$ (lunghezza di $w$); il secondo richiede
tempo costante, poiché $alpha$ e $beta$ sono due stringhe fissate,
indipendenti da $w$. Dunque $f$ è calcolabile in tempo polinomiale.

Abbiamo quindi costruito, per un arbitrario $Q in$ NP, una riduzione
polinomiale da $Q$ a $L$. Ne segue che $L$ è NP-difficile, ed essendo anche in NP, $L$ è NP-completo.\
]

#observation()[
  - $emptyset$ non è NP-difficile. Dato $Q in "NP"$, esiste una riduzione polinomiale da $Q$ a $emptyset$? No, in quanto non ci possono essere funzioni che mandano stringhe di $Q$ nel vuoto.
  - $Sigma^*$ non è NP-difficile (motivo analogo, riduzione da $Q$ a $Sigma^*$).
]

#proposition()[
  Se $L$ è NP-difficile e $f$ è una riduzione polinomiale da $L$ a $Q$, allora $Q$ è NP-difficile.
]
#proof()[
  Dato $R in "NP"$, descriviamo una riduzione polinomiale da $R$ a $Q$.

  - Poiché $L$ è NP-difficile e $R$ $in$ NP, $exists g$ riduzione polinomiale da $R$ a $L$:
  $
    g: Sigma^*_R arrow.long Sigma^*_L quad quad w in R <=> g(w) in L
  $
  - Sappiamo che L è polinomialmente riducibile a Q:
  $
    f: Sigma^*_L arrow.long Sigma^*_Q quad quad w in L <=> f(w) in Q
  $

  Osserviamo che:
  $
    f compose g: Sigma^*_R arrow.long Sigma^*_Q quad quad w in R <=> f(g(w)) in Q
  $
  Inoltre è calcolabile in tempo polinomiale.\
]

== Rappresentazioni di problemi
La scelta di una certa codifica per un determinato problema può avere un impatto sulla sua complessità. Quello che facciamo quando cerchiamo una *rappresentazione* (o *codifica*), è cercare una funzione
$
  "rep" : overbracket({p_1, p_2, dots, p_i}, "istanze di un problema") --> Sigma^* quad quad
$
cioè una funzione che traduca ciascuna istanza di un problema (che sarebbero gli input, ad esempio un grafo $G$ nel caso del problema HAM) in una parola su un opportuno alfabeto $Sigma$, in modo da poterla fornire in input ad una MdT.
#index[Trasformazione polinomiale]
#definition()[
  Date $"rep"_1 : {p_1, p_2, dots, p_i} --> Sigma_1^*$ e $"rep"_2 : {p_1, p_2, dots, p_i} --> Sigma_2^*$, \ $"rep"_1$ è *polinomialmente trasformabile* in $"rep"_2$ quando $exists space t : Sigma_1^* --> Sigma_2^*$ tale che:

  + $forall i, space t("rep"_1 (p_i)) = "rep"_2 (p_i)$
  + $forall w in Sigma_1^*$ tale che $w in.not "Im"("rep"_1)$, vale $t(w) in.not "Im"("rep"_2)$ ("Im" è l'immagine);
  + $t$ è computabile in tempo polinomiale.
]

Se $"rep"_1$ è polinomialmente trasformabile in $"rep"_2$, allora la lunghezza di $"rep"_2 (p_i)$ ($= t("rep"_1 (p_i))$) è al più polinomiale nella lunghezza di $"rep"_1 (p_i)$. Pertanto se un problema sta nella classe P usando $"rep"_2$, allora il problema sta in P anche usando $"rep"_1$.
#observation()[
  Attenzione al caso delle rappresentazioni binaria e unaria di un numero naturale (la rappresentazione binaria di $n$ ha lunghezza $approx log_2 (n)$, per cui la conversione in unario richiede un numero di transizioni esponenziale nella lunghezza dell'input). La trasformazione da binario a unario non è polinomiale! Può accadere che un problema stia in P con la rappresentazione unaria ma non stia in P con la rappresentazione binaria (un problema prende in input una stringa unaria di lunghezza $n$ e compie $n$ transizioni, lo stesso problema con input stringa binaria di lunghezza $m = log_2 (n)$ in input ne compie $2^m$: il numero di transizioni svolte è lo stesso, ma nel primo caso la complessità è lineare rispetto alla lunghezza dell'input, nel secondo caso è esponenziale).
]
== Polinomi booleani
#index[Polinomio booleano]
#definition()[
  $x_1, x_2, dots, x_n$ indeterminate. Un *polinomio booleano* in $x_1, x_2, dots, x_n$ è elemento dell'insieme PB$(x_1,dots,x_n)$ dei polinomi booleani in $x_1,dots,x_n$ e si ha che:

  - $0,1 in "PB"(x_1,dots,x_n)$

  - $forall i <= n, space x_i in "PB"(x_1,dots,x_n)$

  - $p,q in "PB"(x_1,dots,x_n) => p or q, space p and q, space p' in "PB"(x_1,dots,x_n)$

  - Nient'altro è un polinomio booleano.
]

#example()[
  $0, space y, space x or y, space (x and z)' or (x or y)' in "PB"(x,y,z)$
]

#observation()[
  $x or y != y or x$ come polinomi, poi però se gli assegno dei valori, il risultato è lo stesso.
]

#index[Polinomi booleani equivalenti]
#definition()[
  $p, q$ polinomi booleani si dicono *equivalenti* ($p equiv q$) quando $forall t$ assegnamento di valori booleani alle variabili, $t(p)=t(q)$.
]

#index[Letterale]#index[Clausola]#index[Forma Normale Congiuntiva (CNF)]
#definition()[
  $"PB"(x_1,dots,x_n)$:

  - *Letterale* è una variabile o la negazione di una variabile ($x_i "o" x_i '$).
  - *Clausola* è una disgiunzione di letterali ($x_2 or x_4 ' or x_7 or x_8$).
  - Polinomio booleano in *Forma Normale Congiuntiva (CNF)* è un polinomio scritto come congiunzione di clausole, ad esempio $(x_1 or x_3 ') and (x_2 or x_3 or x_3 ') and x_1 '$.
]

#index[Polinomio soddisfacibile]
#definition()[
  $p$ polinomio booleano si dice *soddisfacibile* quando $exists space t$ assegnamento tale che $t(p)=1$ (cioè l'assegnamento soddisfa il polinomio).
  $
    {x_1, dots, x_n}, "assegnamento" t:{x_1, dots, x_n}->{0,1}, quad t(x_i)=0 or 1
  $
]

=== Problema SAT
#index[Problema SAT]
#problem()[
  Dato un polinomio booleano $p$ in CNF, determinare se $p$ è soddisfacibile (esiste un assegnamento che lo soddisfa).
]
Vogliamo scrivere una MdT non deterministica per risolvere questo problema. Iniziamo prima dalla codifica dell'istanza, ossia la codifica di un polinomio booleano in CNF nelle variabili ${x_1, dots, x_n}$. \
Ciascuna variabile è codificata utilizzando il suo indice scritto in binario:
- variabili $x_i arrow.r.squiggly uu(i)$ (codifica binaria di i)
I letterali in maniera simile:
- letterali:
  - $x_i arrow.r.squiggly uu(i) \# 1$ (non negato)
  - $x'_i arrow.r.squiggly uu(i) \# 0$ (negato)

#example()[
  Date le variabili ${x_1,x_2,x_3}$ codificate con i numeri ${1,10,11}$, il polinomio $p= (x_1 or x_2 ')and (x_1 ' or x_3)$ viene codificato nel seguente modo:
  $
    1\#1 or 10\#0 and 1\#0 or 11\#1
  $
]

Nella MdT questa codifica andrà un po' arricchita. La codifica finale è composta dalla codifica del polinomio preceduta (con separatore \#\#) da una lista di interi da $1$ a $n$ in binario che indicano le variabili presenti nel polinomio:
$
  underbrace(1\#10\#11, "lista variabili")\#\# underbrace(1\#1 or 10\#0 and 1\#0 or 11\#1, "codifica polinomio")
$
In questo polinomio abbiamo quindi 3 variabili ($x_1, x_2, x_3$) e 4 letterali ($x_1, x_1 ', x_2 ', x_3$). L'alfabeto per il problema SAT è $Sigma_"SAT" = {0, 1, \#, and , or}$.

#proposition()[
  Il problema SAT appartiene a NP.
]
#proof()[
  Costruiamo una MdT non deterministica a 2 nastri che risolve SAT in tempo polinomiale. L'idea alla base è quella di generare non deterministicamente un assegnamento e controllare se esso soddisfa il polinomio in esame.
  #figure(image("images/2026-08-10-17-26-35.png", width: 60%))
  - Per prima cosa bisogna controllare che la stringa di input sia sintatticamente corretta (se non lo è, si rifiuta e si termina subito).
  - Altrimenti si usa il nastro di lavoro 2. Infatti, si genera su di esso (non deterministicamente) un assegnamento alle variabili nella forma seguente:
    $
      x_1 \# t(x_1) \#\# x_2 \# t(x_2) \#\# dots \#\# x_n \# t(x_n)
    $
    Dove $x_i$ è la rappresentazione binaria dell'indice della variabile $x_i$ e $t(x_i)$ indica l'assegnamento del valore della variabile $x_i$, che può essere 0 o 1.
  - Esamino il polinomio di input da sinistra verso destra, fino a incontrare un letterale $v$, quindi confronto il valore binario che segue quel letterale (ovvero $t(v)$ in $v \# t(v))$ sul nastro 1 con quello che segue il letterale sul nastro 2 (ovvero, per esempio, $t(x_1)$ in $x_1\#t(x_1)$):
    - *Se sono uguali*: il letterale $v$ è soddisfatto e quindi la clausola in cui compare è soddisfatta (poiché è fatta da soli operatori $or$); posso quindi passare a esaminare la clausola successiva. Se la clausola appena esaminata era l'ultima, accetto e termino.
    - *Se non sono uguali*: il letterale $v$ non è soddisfatto, quindi passo a esaminare il letterale successivo. Se il letterale appena esaminato era l'ultimo della clausola, allora termino e rifiuto il polinomio, poiché la clausola in cui compariva tale letterale non è soddisfatta (il polinomio è una congiunzione di clausole, per cui devono essere tutte vere perché il polinomio sia soddisfatto). Si dice in questo caso che il polinomio non è soddisfacibile.

Analizziamo la complessità nel caso peggiore, ovvero il caso dell'accettazione (quando tutte le clausole sono soddisfatte), considerando $n$ variabili e $k$ letterali. Possiamo stimare la lunghezza dell'input in questo modo:
$
  overbrace(n log n, "n numeri binari per \n codificare la lista \n delle variabili") + overbrace(k log n, "k numeri binari per \n codificare i letterali \n (codifica polinomio)") = (n+k) log n quad
$
(il contributo di simboli come \#, $and$, $or$ e così via sarebbe costante quindi l'O-grande è comunque ciò che è scritto sopra). A questo punto stimiamo il numero di transizioni:
$
   overbrace(n log n, "genero assegnamento") + overbrace(k n log n, "percorro nastro") <= n^2 + k n^2 <= ((n+k)log n)^2 + ((n+k)log n)^3
$
Tale espressione è un polinomio nella lunghezza dell'input $(n+k) log n$. Di conseguenza, la MdT costruita opera effettivamente in tempo polinomiale.
]
#observation()[
  Per una MdT deterministica il numero di assegnamenti da generare e verificare sarebbe invece esponenziale, poiché si dovrebbero generare e verificare tutte le possibili combinazioni.
]

#index[Teorema di Cook]
#theorem("Teorema di Cook")[
  SAT è NP-difficile.
]
#observation()[
  Vista la complessità della dimostrazione, all'orale viene spesso chiesto solo qualche passaggio.
]
#proof()[
  Sia $L in$ NP. Vogliamo costruire una riduzione polinomiale da $L$ a SAT (o meglio, da $L$ al linguaggio di SAT). Sia $M$ MdT non deterministica polimomiale che accetta $L$ e sia $p(n) = t c_M (n)$. Per semplicità, supponiamo che $forall$ stringa $w$ di lunghezza $n$, il numero di transizioni di $M$ su $w$ sia esattamente $p(n)$ (non è restrittivo, basta allungare le computazioni "corte") e che $M$ sia una MdT standard limitata a sinistra con le celle numerate.

  Formalmente vogliamo quindi trovare una funzione $Phi : Sigma_L ^ * -> Sigma_("SAT")^*$ computabile in tempo polinomiale e t.c. $forall w in Sigma_L ^*$, $w in L "("<==> M "accetta" w")" <==> Phi(w)$ è un polinomio booleano in forma CNF soddisfacibile.\
  Gli stati di $M$ sono $Q={q_1, dots, q_s}$, con $|Q| = s$, mentre l'alfabeto di $M$ è $Sigma={a_1, dots, a_r}$, con $|Sigma| = r$. $F subset.eq Q$ insieme degli stati finali.

  Le variabili del polinomio $Phi(w)$ (con $w$ lunga $n$) sono di tre tipi:
  - se $S(u, t)=1$ significa che all'istante $t$ la MdT $M$ si trova nello stato $q_u$;
  - se $C(i, j, t)=1$ significa che all'istante $t$, nella cella $i$ della MdT $M$ c'è il simbolo $a_j$;
  - se $L(i, t)=1$ significa che all'istante $t$ la testina si trova sulla cella $i$;

  con $t in {0, 1, 2, dots, p(n)}$, $u in {1, dots, s}$, $i in {1, dots, p(n) + 1}$ e $j in {1, dots, r}$.

  Descriviamo ora le condizioni che caratterizzano una computazione accettante di $M$ su $w$:

  1. $forall t, exists! space u$ t.c. $S(u, t) = 1$\
    In un certo istante $t$, $M$ si troverà in esattamente uno stato.

  2. $forall t, forall i, exists! space j$ t.c. $C(i, j, t) = 1$\
    In un certo istante $t$, in ogni cella è presente esattamente un solo simbolo.

  3. $forall t, exists! space i$ t.c. $L(i, t) = 1$\
    In un certo istante $t$, la testina indicherà una sola cella $i$.

  4. $t= 0 arrow$ Configurazione iniziale: all'inizio della computazione, la testina è posizionata sulla cella 1 nastro; tale cella è vuota (contiene "\*") e quelle a seguire contengono la stringa $w$ in input; $M$ si trova nello stato iniziale.

  5. $exists space u$ t.c. $q_u in F$ e $S(u, p(n)) = 1$\
    Nell'istante $t= p(n)$ , cioè a fine computazione (le transizioni sono esattamente $p(n)$), $M$ si troverà in uno stato finale $q_u$.

  6. $forall t, forall i, L(i, t) = 0 => C(i, j, t) = C(i, j, t+ 1)$\
    Se la testina non è posizionata sulla cella $i$ all'istante $t$, allora nell'istante successivo $t+ 1$ il simbolo $a_j$ contenuto in tale cella $i$ non varia.

  7. $forall t, forall i, L(i, t) = 1 => S(u, t+ 1), C(i, j, t+ 1), L(i, t+ 1)$ devono assumere opportuni valori.\
    Se la testina è posizionata sulla cella $i$ all'istante $t$, allora nell'istante successivo $t+ 1$ occorre assegnare valori opportuni alle variabili per descrivere il comportamento di $M$ in base alla transizione da eseguire.

  Adesso bisogna scrivere un polinomio booleano per ogni condizione elencata e alla fine ne considereremo la congiunzione in modo da formare un unico polinomio in forma CNF che descrive una computazione accettante di $Phi(w)$.

  Definiamo un polinomio booleano con variabili ${y_1, dots, y_k}$ nel modo seguente:
  $ U(y_1, dots, y_k) = (y_1 or dots or y_k) and.big_(i < j) (y'_i or y'_j) $

  #example([$k$=3])[
    $U(y_1,y_2,y_3)=(y_1 or y_2 or y_3) and (y'_1 or y'_2) and (y'_2 or y'_3) and (y'_1 or y'_3)$
  ]
  E vale che $U(y_1, dots, y_k) = 1 <==> exists! space i : y_i = 1$
  ovvero $U$ è un polinomio che vale 1 quando esattamente una variabile ha valore 1 (se ha più variabili con valore 1 il polinomio non è soddisfatto).

  Scriviamo i polinomi booleani per le 7 condizioni:\

  1) $and.big_(t=0)^(p(n)) U(S(1, t), S(2, t), dots, S(s, t))=A$ (*CNF*)

  2) $and.big_(t=0)^(p(n)) and.big_(i=1)^(p(n)+1) U(C(i, 1, t), C(i, 2, t), dots, C(i, r, t))=B$ (*CNF*)

  3) $and.big_(t=0)^(p(n)) U(L(1, t), L(2, t), dots, L(p(n) + 1, t))=C$ (*CNF*)

  4) $S(1,0) and L(1,0) and C(1, *, 0) and (and.big_(i=1)^(n) C(i+1, w_i, 0)) and (and.big_(i=n+1)^(p(n)+1) C(i,*, 0))=D$ (*CNF*)\
  (l'input occupa le celle da 2 a $n+1$ e le restanti sono vuote)

  5) $or.big_(q_u in F) S(u, p(n))=E$ (*CNF*)

  6) $and.big_(t=0)^(p(n)-1) and.big_(i=1)^(p(n)+1) ( L(i, t) or (and.big_(j=1)^r C(i, j, t) "XNOR" C(i, j, t+ 1)))=F$ (che è quasi *CNF*)
  $ 
    "con" x "XNOR" y = (x' or y) and (x or y')
  $
  7) $
G_(u,t,i,j) =
      S(u,t)' or L(i,t)' or C(i,j,t)' or \
      or.big_((q_u', a_j', v) in delta(q_u, a_j))
      (
        S(u', t+1) and
        C(i, j', t+1) and
        L(i+v, t+1)
      )\
      "e poi" G = and.big_(u, t, i, j)G_(u, t, i, j)
    $

  Osserviamo che tutti i polinomi sopra sono in CNF tranne il 6, per cui basta applicare $L or (A and B) equiv (L or A) and (L or B)$, e il 7 che però può essere trasformato in CNF in tempo polinomiale.

  Il polinomio finale è quindi la congiunzione dei polinomi $A$ - $G$. Per costruzione, $Phi(w)$ è soddisfacibile (cioè appartiene a SAT) se e solo se esiste una computazione accettante di $M$ su $w$, cioè se e solo se $w in L$.
  Inoltre, poiché $p(n)$ è polinomiale e $M$ è fissata, $Phi(w)$ ha dimensione polinomiale in $n$ ed è costruibile in tempo polinomiale. Dunque $L$ è polinomialmente riducibile a SAT. Essendo $L in "NP"$ arbitrario, SAT è NP-difficile.
]
#observation()[
  SAT è NP $and$ SAT è NP-difficile $==>$ SAT è NP-completo
]
=== Problema 3-SAT
#index[Problema 3-SAT]
#problem("3-SAT")[
  Dato un polinomio booleano $p$ in 3-CNF (ogni clausola contiene esattamente 3 letterali), determinare se $p$ è soddisfacibile.
]
#observation()[
  3-SAT $in$ NP (si verifica con lo stesso procedimento visto per SAT).
]
Adesso mostriamo anche che 3-SAT è NP-difficile. Per fare ciò cercheremo una riduzione polinomiale da SAT, che sappiamo essere NP-difficile, a 3-SAT.
#proposition()[
  3-SAT è NP-difficile
]
#proof()[
  Dato $p$ polinomio booleano in CNF $p = u_1 and u_2 and dots and u_m$, $u_i$ clausole, vogliamo costruire un polinomio $tilde(p)$ in 3-CNF, dunque ogni $u_i$ dovrà diventare una clausola (o un insieme di clausole) $tilde(u)_i$ con esattamente 3 letterali. Le clausole di $p$ possono essere, a seconda dei casi:

  1. $u = v$, clausola che contiene un solo letterale: introduciamo due nuove variabili $x, y$ e poniamo
  $
    tilde(u) =
    (v or x or y)
    and (v or x' or y)
    and (v or x or y')
    and (v or x' or y').
  $
  Se $v=1$, tutte le clausole sono soddisfatte. Se invece $v=0$, per ogni assegnamento di $x$ e $y$ una delle quattro clausole risulta falsa. Quindi $u " soddisfacibile" <==> tilde(u) " soddisfacibile".$

  2. $u = v_1 or v_2$, clausola che contiene due letterali: introduciamo una nuova variabile $x$ e poniamo
  $
    tilde(u) =
    (v_1 or v_2 or x)
    and
    (v_1 or v_2 or x').
  $
  Se $v_1 or v_2=1$, entrambe le clausole sono soddisfatte indipendentemente dal valore di $x$; se invece $v_1=v_2=0$, le due clausole richiederebbero contemporaneamente $x=1$ e $x=0$. Dunque anche in questo caso $u " soddisfacibile" <==> tilde(u) " soddisfacibile".$
  
  3. $u = v_1 or v_2 or v_3$, che contiene già tre letterali, non occorre modificarla. Quindi $tilde(u)=u.$
  
  4. $u = v_1 or v_2 or dots or v_k$, clausola che contiene $k>3$ letterali: introduciamo $k-3$ nuove variabili $y_1, dots, y_(k-3)$ e poniamo
  $
    tilde(u) =
    (v_1 or v_2 or y_1)
    and
    (y_1 ' or v_3 or y_2)
    and
    (y_2 ' or v_4 or y_3)
    and dots \ dots and
    (y_(k-4) ' or v_(k-2) or y_(k-3))
    and
    (y_(k-3) ' or v_(k-1) or v_k).
  $
  
  Mostriamo che anche in questo caso $u$ è soddisfacibile $<==>$ $tilde(u)$ è soddisfacibile:
  
- $==>$) Supponiamo che $u$ sia soddisfacibile. Sia $V$ l'insieme delle variabili che compaiono in $p$ e sia $t : V -> {0,1}$ un assegnamento t.c. $t(u)=1$. Poiché $u$ è soddisfatta da $t$, esiste almeno un letterale di $u$ soddisfatto: sia $v_j$ il primo letterale t.c. $t(v_j)=1$. Estendiamo $t$ alle nuove variabili $y_1, dots, y_(k-3)$ definendo $tilde(t) : V union {y_1, dots, y_(k-3)} -> {0,1}$ come segue:
  $
    tilde(t)(x) =
    cases(
      t(x) & "se " x in V,
      1 & "se " x = y_1","dots","y_(j-2),
      0 & "se " x = y_(j-1)","dots","y_(n-3).
    )
  $
  
  Con questo assegnamento, le clausole che precedono quella contenente $v_j$ sono soddisfatte dalle variabili $y_1, dots, y_(j-2)$; le clausole successive sono soddisfatte dai letterali $y_(j-1) ', dots, y_(k-3) '$; la clausola contenente $v_j$ è soddisfatta proprio da $v_j$. Quindi $tilde(t)(tilde(u))=1$, e dunque $tilde(u)$ è soddisfacibile.
  
  - $<==$) Viceversa, supponiamo che $tilde(u)$ sia soddisfacibile e che, per assurdo, tutti i letterali $v_1, dots, v_k$ siano falsi. La prima clausola impone allora $y_1=1$. La seconda impone $y_2=1$ e, procedendo allo stesso modo lungo la catena, si ottiene $y_1 = y_2 = dots = y_(k-3) = 1$. L'ultima clausola diventa però $y_(k-3) ' or v_(k-1) or v_k = 0$, assurdo. Quindi almeno uno dei letterali $v_j$ deve essere vero e pertanto $u$ è soddisfatta.
  
  Infine si ottiene $tilde(p) = tilde(u)_1 and tilde(u)_2 and dots and tilde(u)_m$ e, per costruzione, $p " è soddisfacibile" <==> tilde(p) " è soddisfacibile"$.\
  Inoltre, una clausola di $k$ letterali viene sostituita da un numero $O(k)$ di clausole e variabili ausiliarie; la dimensione di $tilde(p)$ è quindi lineare, e in particolare polinomiale, nella dimensione di $p$. Anche la trasformazione può essere eseguita in tempo polinomiale. Abbiamo dunque costruito una riduzione polinomiale da SAT a 3-SAT, e poiché SAT è NP-difficile, segue che 3-SAT è NP-difficile.
]
#observation()[
  3-SAT è NP $and$ 3-SAT è NP-difficile $==>$ 3-SAT è NP-completo
]
== Altri problemi NP-completi
Vediamo una serie di problemi NP-completi: per quasi tutti useremo una riduzione da 3-SAT per dimostrare la NP-completezza.

=== Problema del Vertex Cover (VC)
#index[Vertex cover]
#definition()[
  Dato $G=(V, E)$ grafo non orientato, un *vertex cover* (VC) di $G$ è un sottoinsieme $C subset.eq V$ t.c. $forall{x,y} in E, space x in C "oppure" y in C$
]
#figure(image("images/2026-08-11-11-08-48.png", width: 60%), caption: "Vertex cover con C = {1,6,4,7,2,3}")

#index[Problema del Vertex Cover]
#problem("Vertex Cover")[
  Dato $G=(V,E)$ grafo non orientato e $k in NN$, determinare se $G$ possiede un VC di cardinalità $k$.
]

#proposition()[
  Il problema del vertex cover $in$ NP.
]
#proposition()[
  Il problema del vertex cover è NP-difficile.
]
#proof()[
  Costruiamo una riduzione polinomiale da 3-SAT a VC. Sia $p$ polinomio booleano in 3-CNF:

  $
    & p=(u_(1,1) or u_(1,2) or u_(1,3)) and (u_(2,1) or u_(2,2) or u_(2,3)) and dots and (u_(m,1) or u_(m,2) or u_(m,3))
  $

  $V = {x_1, dots, x_n}$ insieme delle variabili di $p$, $|V| = n$ e $m =$ numero di clausole di $p$.

  Costruiamo un grafo non orientato $G(p)$ nel seguente modo:
  
  - scriviamo un nodo per ogni variabile del polinomio e un nodo per ogni negazione di variabile;
  - colleghiamo ogni coppia variabile-variabile negata con un lato;
  - scriviamo un nodo per ogni letterale di ogni clausola;
  - colleghiamo con 3 lati i 3 letterali di ogni clausola;
  - aggiungiamo lati tra i due insiemi di nodi, collegando le variabili o variabili negate ai letterali delle clausole corrispondenti.

  #example()[
    $
      p = (x_1 or x'_2 or x_3) and (x'_1 or x_2 or x'_4) quad (*)
    $
    con $V = {x_1, x_2, x_3, x_4}$, $|V|=4$ e $m=2$.
    #align(center, cetz.canvas(length: 24pt, {
      import cetz.draw: *

      // Altezze dei livelli
      let y-var = 4 // Riga delle variabili
      let y-u-top = 1.5 // Base superiore dei triangoli delle clausole
      let y-u-bot = 0 // Vertice inferiore dei triangoli delle clausole

      // Nodi Variabili (x, x')
      let x1 = (0, y-var)
      let x1_ = (2, y-var)

      let x2 = (4.5, y-var)
      let x2_ = (6.5, y-var)

      let x3 = (9, y-var)
      let x3_ = (11, y-var)

      let x4 = (13.5, y-var)
      let x4_ = (15.5, y-var)

      // Nodi Clausola 1
      let u11 = (3, y-u-top)
      let u12 = (5.5, y-u-top)
      let u13 = (4.25, y-u-bot)

      // Nodi Clausola 2
      let u21 = (10, y-u-top)
      let u22 = (12.5, y-u-top)
      let u23 = (11.25, y-u-bot)

      // Collegamenti tra coppie di variabili (x_i, x'_i)
      line(x1, x1_)
      line(x2, x2_)
      line(x3, x3_)
      line(x4, x4_)

      // Triangolo Clausola 1
      line(u11, u12)
      line(u12, u13)
      line(u13, u11)

      // Triangolo Clausola 2
      line(u21, u22)
      line(u22, u23)
      line(u23, u21)

      // Collegamenti Variabile <-> Letterale della clausola
      // (Basato sull'esempio: p = (x1 ∨ x'2 ∨ x3) ∧ (x'1 ∨ x2 ∨ x'4))
      line(x1, u11) // x1  -> u1,1
      line(x2_, u12) // x'2 -> u1,2
      line(x3, u13) // x3  -> u1,3

      line(x1_, u21) // x'1 -> u2,1
      line(x2, u22) // x2  -> u2,2
      line(x4_, u23) // x'4 -> u2,3

      let r = 0.65 // Raggio dei nodi

      // Funzione di supporto per disegnare un nodo coprente con etichetta
      let draw-node(pos, label) = {
        circle(pos, radius: r, fill: white, stroke: 1pt)
        content(pos, text(size: 1.2em, weight: "bold", label))
      }

      // Disegno nodi variabili
      draw-node(x1, $x_1$)
      draw-node(x1_, $x'_1$)

      draw-node(x2, $x_2$)
      draw-node(x2_, $x'_2$)

      draw-node(x3, $x_3$)
      draw-node(x3_, $x'_3$)

      draw-node(x4, $x_4$)
      draw-node(x4_, $x'_4$)

      // Disegno nodi Clausola 1
      draw-node(u11, $u_(1,1)$)
      draw-node(u12, $u_(1,2)$)
      draw-node(u13, $u_(1,3)$)

      // Disegno nodi Clausola 2
      draw-node(u21, $u_(2,1)$)
      draw-node(u22, $u_(2,2)$)
      draw-node(u23, $u_(2,3)$)
    }))
  ]

  In un VC di $G(p)$ ci devono essere almeno $n+2m$ vertici: infatti basta scegliere uno solo dei due estremi per ciascuno degli $n$ lati che collegano $x_i$ a $x'_i$, mentre per coprire i tre archi di ciascuno degli $m$ triangoli associati alle clausole occorrono almeno due dei tre vertici.\
  Facciamo vedere che $p$ è soddisfacibile $<==> G(p)$ ha un vertex cover di cardinalità $n+2m = k(p)$.

  $==>)$ Sia $t$ assegnamento t.c. $t(p) = 1$

  - $forall i = 1, dots, n$ scegliamo
  $
    cases(
        x_i &"se" t(x_i) = 1,
        x'_i &"se" t(x_i) = 0
    )
  $
  - Per ogni clausola, individuiamo un letterale che soddisfa la clausola e scegliamo i rimanenti 2 (quindi in tutto scelgo 2 nodi su 3 per ogni clausola $=> 2m$).

  #example()[
    Considerando $(*)$, diamo i seguenti valori alle variabili: $x_1 -> 1, x_2 -> 0, x_3 -> 1, x_4 -> 0$. Allora (i vertici "scelti" sono dentro i quadrati):
    #align(center, cetz.canvas(length: 24pt, {
      import cetz.draw: *

      // Altezze dei livelli
      let y-var = 4 // Riga delle variabili
      let y-u-top = 1.5 // Base superiore dei triangoli delle clausole
      let y-u-bot = -0.5 // Vertice inferiore dei triangoli delle clausole

      // Nodi Variabili (x, x')
      let x1 = (0, y-var)
      let x1_ = (2, y-var)

      let x2 = (4.5, y-var)
      let x2_ = (6.5, y-var)

      let x3 = (9, y-var)
      let x3_ = (11, y-var)

      let x4 = (13.5, y-var)
      let x4_ = (15.5, y-var)

      // Nodi Clausola 1
      let u11 = (3, y-u-top)
      let u12 = (5.5, y-u-top)
      let u13 = (4.25, y-u-bot)

      // Nodi Clausola 2
      let u21 = (10, y-u-top)
      let u22 = (12.5, y-u-top)
      let u23 = (11.25, y-u-bot)

      // Collegamenti tra coppie di variabili (x_i, x'_i)
      line(x1, x1_)
      line(x2, x2_)
      line(x3, x3_)
      line(x4, x4_)

      // Triangolo Clausola 1
      line(u11, u12)
      line(u12, u13)
      line(u13, u11)

      // Triangolo Clausola 2
      line(u21, u22)
      line(u22, u23)
      line(u23, u21)

      // Collegamenti Variabile <-> Letterale della clausola
      line(x1, u11) // x1  -> u1,1
      line(x2_, u12) // x'2 -> u1,2
      line(x3, u13) // x3  -> u1,3

      line(x1_, u21) // x'1 -> u2,1
      line(x2, u22) // x2  -> u2,2
      line(x4_, u23) // x'4 -> u2,3

      // Helper per tracciare il quadrato di selezione
      let draw-box(pos) = {
        let (x, y) = pos
        let b = 0.65 // Dimensione del riquadro (offset dal centro)
        rect((x - b, y + b), (x + b, y - b), stroke: 1pt)
      }

      // Selezionati tra le variabili (i letterali VERI)
      draw-box(x1)
      draw-box(x2_)
      draw-box(x3)
      draw-box(x4_)

      // Selezionati tra le clausole (i 2 letterali rimanenti per ogni triangolo)
      draw-box(u12)
      draw-box(u13)
      draw-box(u21)
      draw-box(u22)

      let r = 0.6 // Raggio dei nodi

      // Helper per disegnare un nodo coprente con etichetta
      let draw-node(pos, label) = {
        circle(pos, radius: r, fill: white, stroke: 1pt)
        content(pos, text(size: 1.2em, weight: "bold", label))
      }

      // Disegno nodi variabili
      draw-node(x1, $x_1$)
      draw-node(x1_, $x'_1$)

      draw-node(x2, $x_2$)
      draw-node(x2_, $x'_2$)

      draw-node(x3, $x_3$)
      draw-node(x3_, $x'_3$)

      draw-node(x4, $x_4$)
      draw-node(x4_, $x'_4$)

      // Disegno nodi Clausola 1
      draw-node(u11, $u_(1,1)$)
      draw-node(u12, $u_(1,2)$)
      draw-node(u13, $u_(1,3)$)

      // Disegno nodi Clausola 2
      draw-node(u21, $u_(2,1)$)
      draw-node(u22, $u_(2,2)$)
      draw-node(u23, $u_(2,3)$)
    }))
  ]
  Allora l'insieme di vertici così definito ha cardinalità $n + 2m$ ed è un VC di $G(p)$.

  $<==)$ $G(p)$ ha un VC di cardinalità $n+ 2m$, allora definisco $t: {x_1, dots, x_n} -> {0,1}$ che soddisfa $p$ in questo modo:
  $
    t(x_i) = cases(
      1 & "se" x_i in V C,
      0 & "se" x'_i in.not V C
    )
  $
  Con questo assegnamento, ogni clausola è soddisfatta dal letterale corrispondente al nodo non appartenente al VC di ogni "triangolo" $u_(i,0), u_(i,1), u_(i,2)$.\ Dunque abbiamo ottenuto che $p in $ 3-SAT $<==> G(p) "ha un VC con cardinalità" k(p)$, e poiché la funzione che costruisce il grafo dal polinomio è computabile in tempo polinomiale 3-SAT è polinomialmente riducibile a VC: essendo 3-SAT NP-difficile, anche VC è NP-difficile.
]

=== Problema Clique
#index[Problema Clique]
#problem("Clique")[
  Dato un grafo non orientato $G$ e un intero $k$, determinare se esiste un sottografo completo di $G$ avente $k$ vertici.
]
#figure(image("images/esempioClique.png", width: 50%))
#proposition()[
  Il problema Clique $in$ NP.
]

#proposition()[
  Il problema Clique è NP-difficile
]

#proof()[
  Troviamo una riduzione polinomiale da 3-SAT a Clique. Sia $p$ un polinomio booleano in 3-CNF con $k$ clausole:
  $
    & p = u_1 and u_2 and dots and u_k \
    & u_i = (u_(i, 1) or u_(i, 2) or u_(i, 3))
  $
  Costruiamo un grafo $G(p) = (V, E)$  in cui: 

  - c'è un vertice per ciascun letterale di ogni clausola;
  - non ci sono lati tra letterali della stessa clausola;
  - non ci sono lati tra due letterali opposti ($x_i$ e $x'_i$);
  - c'è un lato fra ogni altra coppia di vertici.

  #example()[
    $
      p=(x_1 or x'_2 or x_3) and (x'_1 or x_2 or x'_4)
    $
    #align(center, cetz.canvas(length: 25pt, {
      import cetz.draw: *

      // Coordinate dei nodi (Clausola 1 a sinistra, Clausola 2 a destra)
      let l1 = (0, 1.5)
      let l2 = (0, 0)
      let l3 = (0, -1.5)

      let r1 = (5, 1.5)
      let r2 = (5, 0)
      let r3 = (5, -1.5)

      // 1. Disegno degli spigoli (Archi tra letterali compatibili)
      line(l1, r2)
      line(l1, r3)

      line(l2, r1)
      line(l2, r3)

      line(l3, r1)
      line(l3, r2)
      line(l3, r3)

      // 2. Disegno dei riquadri di selezione per i nodi scelti
      let b = 0.8 // Metà lato del quadrato
      rect((l1.at(0) - b, l1.at(1) + b), (l1.at(0) + b, l1.at(1) - b), stroke: 1pt)
      rect((r3.at(0) - b, r3.at(1) + b), (r3.at(0) + b, r3.at(1) - b), stroke: 1pt)

      // 3. Disegno dei nodi (con sfondo bianco per coprire le linee sottostanti)
      let r = 0.6
      let draw-node(pos, label) = {
        circle(pos, radius: r, fill: white, stroke: 1pt)
        content(pos, text(size: 1.3em, label))
      }

      draw-node(l1, $u_(1,1)$)
      draw-node(l2, $u_(1,2)$)
      draw-node(l3, $u_(1,3)$)

      draw-node(r1, $u_(2,1)$)
      draw-node(r2, $u_(2,2)$)
      draw-node(r3, $u_(2,3)$)
    }))
  ]


  Mostriamo che $p$ è soddisfacibile $<==> G(p)$ ha un sottografo completo di cardinalità $k$.

  $==>$) Sia $t$ un assegnamento di valori alle variabili che soddisfa $p$, ossia t.c. $t(p)=1$. Quindi $forall i <= k$ si ha $t(u_i) = 1$.
  Dunque $forall i <= k, exists j in {1, 2, 3} : t(u_(i,j)) = 1$.

  Nel grafo $G(p)$, $forall i <= k$ scelgo $u_(i,j)$ letterale soddisfatto (cioè in tutto scelgo $k$ vertici su $k$ clausole, ovvero uno in ogni clausola). Per ogni coppia di vertici scelti $x$ e $y$, c'è il lato ${x, y}$ perché $t(x) = t(y) = 1$, dunque $x eq.not y'$ (e, naturalmente, i due vertici $x$ e $y$ rappresentano letterali appartenenti a due clausole diverse).
  #align(center, cetz.canvas(length: 20pt, {
    import cetz.draw: *

    // Spaziatura orizzontale degli ovali
    let xs = (0, 3, 6, 9, 12)

    // Coordinate dei nodi selezionati che formano la cricca K5
    let selected = (
      (0, 0), // Ovale 1: Centrale
      (3, 1.2), // Ovale 2: Alto
      (6, -1.2), // Ovale 3: Basso
      (9, 1.2), // Ovale 4: Alto
      (12, 0), // Ovale 5: Centrale
    )

    // 1. Disegno degli spigoli (Archi della cricca)
    // Dal nodo 1
    line(selected.at(0), selected.at(1))
    line(selected.at(0), selected.at(2))
    line(selected.at(0), selected.at(3))
    line(selected.at(0), selected.at(4))

    // Dal nodo 2
    line(selected.at(1), selected.at(2))
    line(selected.at(1), selected.at(3))
    bezier(selected.at(1), selected.at(4), (7.5, 3.5)) // Curva alta

    // Dal nodo 3
    line(selected.at(2), selected.at(3))
    bezier(selected.at(2), selected.at(4), (9, -2.5)) // Curva bassa

    // Dal nodo 4
    bezier(selected.at(3), selected.at(4), (8.5, 1.5)) // Curva corta alta

    // 2. Disegno degli ovali (Le clausole)
    for x in xs {
      circle((x, 0), radius: (1, 2.5), fill: none, stroke: 1pt)
    }

    // 3. Disegno degli anelli esterni per i nodi selezionati
    for pt in selected {
      circle(pt, radius: 0.4, fill: none, stroke: 1pt)
    }

    // 4. Disegno di tutti i singoli nodi (Letterali)
    // Hanno uno sfondo bianco per coprire le linee che passano sotto
    for x in xs {
      for y in (1.2, 0, -1.2) {
        circle((x, y), radius: 0.08, fill: white, stroke: 1.5pt)
      }
    }
  }))
  $<==)$ Sia ${v_1, dots, v_k}$ un sottografo completo di $G(p)$. Si noti che si sceglie esattamente 1 vertice per ogni clausola, poiché due vertici appartenenti alla stessa clausola non sono collegati.
  Per ogni $i = 1, dots, k$ sia $u^((i))$ il letterale associato a $v_i$ e definiamo l'assegnamento $t$ t.c. $t(u^((i))) = 1$.
  - $t$ è ben definito: poiché i vertici selezionati determinano un sottografo completo, non compaiono coppie del tipo $x, x'$;
  - $t$ soddisfa $p$: in ogni clausola c'è un letterale posto a 1.
  #align(center, cetz.canvas(length: 20pt, {
    import cetz.draw: *

    // Coordinate x degli ovali
    let xs = (0, 3, 6, 9, 12)

    // Nodi selezionati (formano la cricca K5)
    // Formato: (x, y)
    let selected = (
      (0, 0), // Ovale 1: Centrale
      (3, 1.2), // Ovale 2: Alto
      (6, -1.2), // Ovale 3: Basso
      (9, 1.2), // Ovale 4: Alto
      (12, 0), // Ovale 5: Centrale
    )

    // 1. Disegno degli archi (spigoli)
    // Dal nodo 1
    line(selected.at(0), selected.at(1))
    line(selected.at(0), selected.at(2))
    line(selected.at(0), selected.at(3))
    bezier(selected.at(0), selected.at(4), (6, -1))

    // Dal nodo 2
    line(selected.at(1), selected.at(2))
    line(selected.at(1), selected.at(3))
    bezier(selected.at(1), selected.at(4), (7.5, 4)) // Curva lunga superiore

    // Dal nodo 3
    line(selected.at(2), selected.at(3))
    bezier(selected.at(2), selected.at(4), (8, -2.5)) // Curva lunga inferiore

    // Dal nodo 4
    bezier(selected.at(3), selected.at(4), (10.5, 1.5)) // Curva corta superiore

    // 2. Disegno degli ovali (insiemi/clausole)
    for x in xs {
      circle((x, 0), radius: (1, 2.5), fill: none, stroke: 1pt)
    }

    // 3. Disegno dei cerchi di selezione attorno ai nodi scelti
    for pt in selected {
      circle(pt, radius: 0.4, fill: none, stroke: 1pt)
    }

    // 4. Disegno di tutti i piccoli nodi interni
    for x in xs {
      // Sfondo bianco per "coprire" le linee che ci passano sotto
      circle((x, 1.2), radius: 0.08, fill: white, stroke: 1.5pt)
      circle((x, 0), radius: 0.08, fill: white, stroke: 1.5pt)
      circle((x, -1.2), radius: 0.08, fill: white, stroke: 1.5pt)
    }
  })) 
Dunque abbiamo che $p in "3-SAT" <==> G(p) " ha un sottografo completo di cardinalità" k$, con $k$ numero di clausole di $p$. Inoltre, $G(p)$ è costruibile in tempo polinomiale nella dimensione di $p$: contiene $3k$ vertici e gli archi si ottengono considerando le coppie di letterali appartenenti a clausole diverse e non opposti. Quindi 3-SAT è polinomialmente riducibile a Clique e poiché 3-SAT è NP-difficile, anche Clique è NP-difficile.
]

=== Problema HAM
#index[Problema HAM]
#proposition()[
  Il problema del circuito hamiltoniano HAM è NP-difficile.
]

#proof()[
  Descriviamo una riduzione da 3-SAT a HAM. Sia $p$ un polinomio booleano in 3-CNF:
  $
    p = u_1 and u_2 and dots and u_m, quad u_i = (u_(i,1) or u_(i,2) or u_(i,3))
  $
  Con $V = {x_1, dots, x_n}$ variabili di $p$, $x_i$ variabile di $p$. Si introducono quattro categorie di nodi: _t_ (true), _f_ (false), $e_i$ (entrata), $o_i$ (output). Per ogni variabile $x_i$ si crea un grafo ("gadget") formato nel seguente modo:
  #grid(
    columns: (0.5fr, 0.5fr),
    rows: (4em, 1em, 2em, 4em),

    align: (center, left),

    grid.cell(rowspan: 6, cetz.canvas(length: 25pt, {
      import cetz.draw: *
      let dx = 2.5 // Distanza dal centro (asse x)
      let y-e = 3.5 // Altezza nodo iniziale e_i
      let y0 = 2 // Altezza riga 0
      let y1 = 0 // Altezza riga 1
      let y-dots = -1.25 // Altezza punti di sospensione
      let yr = -2.5 // Altezza riga finale r_i
      let y-o = -4 // Altezza nodo finale o_i

      // Stile globale delle linee e delle frecce
      set-style(mark: (fill: black, scale: 0.5))
      content((0, y-e), text(size: 1.4em, $e_i$), name: "e")

      content((-dx, y0), text(size: 1.4em, $t_(i,0)$), name: "t0")
      content((dx, y0), text(size: 1.4em, $f_(i,0)$), name: "f0")

      content((-dx, y1), text(size: 1.4em, $t_(i,1)$), name: "t1")
      content((dx, y1), text(size: 1.4em, $f_(i,1)$), name: "f1")

      content((-dx, y-dots), text(size: 1.5em, $dots.v$))
      content((dx, y-dots), text(size: 1.5em, $dots.v$))

      content((-dx, yr), text(size: 1.4em, $t_(i,r_i)$), name: "tr")
      content((dx, yr), text(size: 1.4em, $f_(i,r_i)$), name: "fr")

      content((0, y-o), text(size: 1.4em, $o_i$), name: "o")

      // Da e_i alla prima riga
      line("e", "t0", mark: (end: ">"))
      line("e", "f0", mark: (end: ">"))

      // Funzione d'appoggio per le doppie frecce orizzontali
      // 'mw' è il margine laterale per evitare di sovrapporsi al testo
      let double-h-arrow(y, mw) = {
        let dy = 0.12 // Distanza dal centro
        // Freccia superiore (Verso destra)
        line((-dx + mw, y + dy), (dx - mw, y + dy), mark: (end: ">"))
        // Freccia inferiore (Verso sinistra)
        line((dx - mw, y - dy), (-dx + mw, y - dy), mark: (end: ">"))
      }

      // Chiamate per le frecce orizzontali
      double-h-arrow(y0, 0.6)
      double-h-arrow(y1, 0.6)
      double-h-arrow(yr, 0.8) // Margine più ampio per via del pedice più lungo

      // Frecce incrociate (Riga 0 -> Riga 1)
      line("t0", "f1", mark: (end: ">"))
      line("f0", "t1", mark: (end: ">"))

      // Frecce incrociate in uscita (verso i puntini)
      line("t1", (dx - 0.9, y1 - 1.1), mark: (end: ">"))
      line("f1", (-dx + 0.9, y1 - 1.1), mark: (end: ">"))

      // Frecce incrociate in entrata (dai puntini verso l'ultima riga)
      line((dx - 0.9, yr + 1.1), "tr", mark: (end: ">"))
      line((-dx + 0.9, yr + 1.1), "fr", mark: (end: ">"))

      // Frecce in uscita dall'ultima riga verso o_i
      line("tr", "o", mark: (end: ">"))
      line("fr", "o", mark: (end: ">"))
    })),
    grid.cell(rowspan: 2, [ \ \
      - esiste un arco tra un vertice $t_(i,j)$ e un vertice $f_(i, j+1)$ e un arco tra un vertice $f_(i,j)$ e un vertice $t_(i,j+1)$;
    ]),
    grid.cell(rowspan: 1, [\ \
    - esiste un arco da $t_(i,j)$ a $f_(i,j)$ e viceversa;]),
    grid.cell(rowspan: 2, [\ \
    con $r_i$ = massimo fra le occorrenze di $x_i "e" x_i^'$ in _p_.]),
  )
  I pezzi di grafo così costruiti si connettono aggiungendo un lato da $o_i "a" e_(i+1)$, per ogni $i$, infine si aggiunge un lato da $o_n "a" e_1$. Nel grafo sopra, ogni variabile ha 2 camini hamiltoniani da $e_j "a" o_j$:
  #grid(
    columns: (0.5fr, 0.5fr),
    align: center,

    [#cetz.canvas(length: 25pt, {
      import cetz.draw: *
      let dx = 2.5 // Distanza dal centro (asse x)
      let y-e = 3.5 // Altezza nodo iniziale e_i
      let y0 = 2 // Altezza riga 0
      let y1 = 0 // Altezza riga 1
      let y-dots = -1.25 // Altezza punti di sospensione
      let yr = -2.5 // Altezza riga finale r_i
      let y-o = -4 // Altezza nodo finale o_i

      // Stile globale delle linee e delle frecce
      set-style(mark: (fill: black, scale: 0.5))
      content((0, y-e), text(size: 1.4em, $e_i$), name: "e")

      content((-dx, y0), text(size: 1.4em, $t_(i,0)$), name: "t0")
      content((dx, y0), text(size: 1.4em, $f_(i,0)$), name: "f0")

      content((-dx, y1), text(size: 1.4em, $t_(i,1)$), name: "t1")
      content((dx, y1), text(size: 1.4em, $f_(i,1)$), name: "f1")

      content((-dx, y-dots), text(size: 1.5em, $dots.v$))
      content((dx, y-dots), text(size: 1.5em, $dots.v$))

      content((-dx, yr), text(size: 1.4em, $t_(i,r_i)$), name: "tr")
      content((dx, yr), text(size: 1.4em, $f_(i,r_i)$), name: "fr")

      content((0, y-o), text(size: 1.4em, $o_i$), name: "o")

      // Da e_i alla prima riga
      line("e", "t0", mark: (end: ">"), stroke: red + 1pt)
      line("e", "f0", mark: (end: ">"))

      // Funzione d'appoggio per le doppie frecce orizzontali
      // 'mw' è il margine laterale per evitare di sovrapporsi al testo
      let double-h-arrow(y, mw) = {
        let dy = 0.12 // Distanza dal centro
        // Freccia superiore (Verso destra)
        line((-dx + mw, y + dy), (dx - mw, y + dy), mark: (end: ">"), stroke: red + 1pt)
        // Freccia inferiore (Verso sinistra)
        line((dx - mw, y - dy), (-dx + mw, y - dy), mark: (end: ">"))
      }

      // Chiamate per le frecce orizzontali
      double-h-arrow(y0, 0.6)
      double-h-arrow(y1, 0.6)
      double-h-arrow(yr, 0.8) // Margine più ampio per via del pedice più lungo

      // Frecce incrociate (Riga 0 -> Riga 1)
      line("t0", "f1", mark: (end: ">"))
      line("f0", "t1", mark: (end: ">"), stroke: red + 1pt)

      // Frecce incrociate in uscita (verso i puntini)
      line("t1", (dx - 0.9, y1 - 1.1), mark: (end: ">"))
      line("f1", (-dx + 0.9, y1 - 1.1), mark: (end: ">"), stroke: red + 1pt)

      // Frecce incrociate in entrata (dai puntini verso l'ultima riga)
      line((dx - 0.9, yr + 1.1), "tr", mark: (end: ">"), stroke: red + 1pt)
      line((-dx + 0.9, yr + 1.1), "fr", mark: (end: ">"))

      // Frecce in uscita dall'ultima riga verso o_i
      line("tr", "o", mark: (end: ">"))
      line("fr", "o", mark: (end: ">"), stroke: red + 1pt)
    })],
    [#cetz.canvas(length: 25pt, {
      import cetz.draw: *
      let dx = 2.5 // Distanza dal centro (asse x)
      let y-e = 3.5 // Altezza nodo iniziale e_i
      let y0 = 2 // Altezza riga 0
      let y1 = 0 // Altezza riga 1
      let y-dots = -1.25 // Altezza punti di sospensione
      let yr = -2.5 // Altezza riga finale r_i
      let y-o = -4 // Altezza nodo finale o_i

      // Stile globale delle linee e delle frecce
      set-style(mark: (fill: black, scale: 0.5))
      content((0, y-e), text(size: 1.4em, $e_i$), name: "e")

      content((-dx, y0), text(size: 1.4em, $t_(i,0)$), name: "t0")
      content((dx, y0), text(size: 1.4em, $f_(i,0)$), name: "f0")

      content((-dx, y1), text(size: 1.4em, $t_(i,1)$), name: "t1")
      content((dx, y1), text(size: 1.4em, $f_(i,1)$), name: "f1")

      content((-dx, y-dots), text(size: 1.5em, $dots.v$))
      content((dx, y-dots), text(size: 1.5em, $dots.v$))

      content((-dx, yr), text(size: 1.4em, $t_(i,r_i)$), name: "tr")
      content((dx, yr), text(size: 1.4em, $f_(i,r_i)$), name: "fr")

      content((0, y-o), text(size: 1.4em, $o_i$), name: "o")

      // Da e_i alla prima riga
      line("e", "t0", mark: (end: ">"))
      line("e", "f0", mark: (end: ">"), stroke: green + 1pt)

      // Funzione d'appoggio per le doppie frecce orizzontali
      // 'mw' è il margine laterale per evitare di sovrapporsi al testo
      let double-h-arrow(y, mw) = {
        let dy = 0.12 // Distanza dal centro
        // Freccia superiore (Verso destra)
        line((-dx + mw, y + dy), (dx - mw, y + dy), mark: (end: ">"))
        // Freccia inferiore (Verso sinistra)
        line((dx - mw, y - dy), (-dx + mw, y - dy), mark: (end: ">"), stroke: green + 1pt)
      }

      // Chiamate per le frecce orizzontali
      double-h-arrow(y0, 0.6)
      double-h-arrow(y1, 0.6)
      double-h-arrow(yr, 0.8) // Margine più ampio per via del pedice più lungo

      // Frecce incrociate (Riga 0 -> Riga 1)
      line("t0", "f1", mark: (end: ">"), stroke: green + 1pt)
      line("f0", "t1", mark: (end: ">"))

      // Frecce incrociate in uscita (verso i puntini)
      line("t1", (dx - 0.9, y1 - 1.1), mark: (end: ">"), stroke: green + 1pt)
      line("f1", (-dx + 0.9, y1 - 1.1), mark: (end: ">"))

      // Frecce incrociate in entrata (dai puntini verso l'ultima riga)
      line((dx - 0.9, yr + 1.1), "tr", mark: (end: ">"))
      line((-dx + 0.9, yr + 1.1), "fr", mark: (end: ">"), stroke: green + 1pt)

      // Frecce in uscita dall'ultima riga verso o_i
      line("tr", "o", mark: (end: ">"), stroke: green + 1pt)
      line("fr", "o", mark: (end: ">"))
    })],
  )

  Per cui si hanno in totale $2^n$ circuiti hamiltoniani nel grafo rappresentato qui sotto:

  #align(center, cetz.canvas(length: 20pt, {
    import cetz.draw: *

    set-style(mark: (fill: black, scale: .75))

    let draw-gadget(cx, id, label-e, label-o, label-x) = {
      let name-e = "e" + id
      let name-o = "o" + id
      let name-x = "x" + id

      // Nodi di testo (e_i, x_i, o_i)
      content((cx - 2, 0), text(size: 1.4em, weight: "bold", label-e), name: name-e)
      content((cx + 2, 0), text(size: 1.4em, weight: "bold", label-o), name: name-o)
      content((cx, 0), text(size: 1.4em, weight: "bold", label-x), name: name-x)

      let h = 1.4
      let w = 1.
      line(name-e, (cx - w, h), (cx + w, h), name-o)
      line(name-e, (cx - w, -h), (cx + w, -h), name-o)
    }

    draw-gadget(0, "1", $e_1$, $o_1$, $x_1$)
    draw-gadget(6, "2", $e_2$, $o_2$, $x_2$)
    draw-gadget(14, "n", $e_n$, $o_n$, $x_n$)

    content((10, 0), text(size: 1.4em, weight: "bold", $dots$), name: "dots")
    line("o1", "e2", mark: (end: ">"))
    line("o2", "dots", mark: (end: ">"))
    line("dots", "en", mark: (end: ">"))
    line("on", (17.5, 0), (17.5, -2.5), (-2, -2.5), "e1", mark: (end: ">"))
  }))

  Dato quindi $u_j=(u_(j, 1) or u_(j, 2) or u_(j, 3))$, si inseriscono i nodi $i n_(i, j)$ e $o u t_(i, j)$: ne serve uno per ogni clausola $u_j$.

  #align(center)[
    #cetz.canvas(length: 25pt, {
      import cetz.draw: *

      set-style(mark: (fill: black, scale: 1))
      set-style(content: (padding: 0.2))
      set-style(line: (padding: 0.2))

      let dx = 3
      let y-in = 2.5
      let y-out = 0

      // Riga superiore (in)
      content((0, y-in), text(size: 1.4em, $"in"_(j,1)$), name: "in1")
      content((dx, y-in), text(size: 1.4em, $"in"_(j,2)$), name: "in2")
      content((2 * dx, y-in), text(size: 1.4em, $"in"_(j,3)$), name: "in3")

      // Riga inferiore (out)
      content((0, y-out), text(size: 1.4em, $"out"_(j,1)$), name: "out1")
      content((dx, y-out), text(size: 1.4em, $"out"_(j,2)$), name: "out2")
      content((2 * dx, y-out), text(size: 1.4em, $"out"_(j,3)$), name: "out3")


      // Frecce verticali in ingresso
      line((0, y-in + 1.5), "in1.north", mark: (end: ">"))
      line((dx, y-in + 1.5), "in2.north", mark: (end: ">"))
      line((2 * dx, y-in + 1.5), "in3.north", mark: (end: ">"))

      // Frecce verticali in uscita
      line("out1.south", (0, y-out - 1.5), mark: (end: ">"))
      line("out2.south", (dx, y-out - 1.5), mark: (end: ">"))
      line("out3.south", (2 * dx, y-out - 1.5), mark: (end: ">"))

      // Frecce verticali interne
      line("in1.south", "out1.north", mark: (end: ">"))
      line("in2.south", "out2.north", mark: (end: ">"))
      line("in3.south", "out3.north", mark: (end: ">"))

      // Frecce orizzontali superiori
      line("in1.east", "in2.west", mark: (end: ">"))
      line("in2.east", "in3.west", mark: (end: ">"))

      // Frecce orizzontali inferiori
      line("out3.west", "out2.east", mark: (end: ">"))
      line("out2.west", "out1.east", mark: (end: ">"))


      // Curva superiore: in3 -> in1, passando sotto
      bezier(
        "in3.south",
        "in1.south",
        (dx, y-in - 1.3),
        mark: (end: ">"),
        shorten-start: 0.15,
        shorten-end: 0.15,
      )

      // Curva inferiore: out1 -> out3, passando sopra
      bezier(
        "out1.north",
        "out3.north",
        (dx, y-out + 1.5),
        mark: (end: ">"),
        shorten-start: 0.15,
        shorten-end: 0.15,
      )
  })]
  #example()[
    Consideriamo:
    $
      p = (x_1 or x_2 or x_3^') and (x_1^' or x_2 or x_4^') and (x_1 or x_2^' or x_4) and (x_1^' or x_3 or x_4)
    $
    Devo sapere quanti nodi vanno scritti, sapere quindi quanto vale $r_i$ (massimo delle occorrenze di $x_i "e" x_i^' "in" p$). \
    Esempio per $x_1$: $x_1$ appare 2 volte, $x_1^'$ appare 2 volte $==> r_i = 2 ==>$ sono 3 nodi $0, 1, 2$.
    #figure(image("/assets/image-17.png", width: 75%))
  ]
#observation()[
  A lezione il prof si è fermato all'esempio qui sopra, non terminando la dimostrazione.
  L'idea della conclusione comunque è mostrare la correttezza della riduzione, provando che
  il polinomio $p$ è soddisfacibile $<==>$ il grafo costruito $G(p)$ possiede un circuito hamiltoniano.
  
  $==>$) Se $p$ è soddisfacibile, per ogni variabile scegliamo il cammino nel gadget
  ("lato true", o "lato false") coerente con l'assegnamento. Poiché ogni clausola è soddisfatta
  da almeno un letterale, il circuito può effettuare una "deviazione" dal cammino della variabile
  corrispondente per visitare i nodi della clausola e tornare subito nel gadget, riuscendo così
  a toccare tutti i nodi.
  
  $<==$) Se esiste un circuito hamiltoniano, la struttura a "catena" dei gadget impone che per ogni variabile venga scelto uno dei due possibili cammini, definendo così un assegnamento di verità. Il fatto che il circuito riesca a visitare anche i nodi delle clausole garantisce che ogni clausola abbia almeno un letterale vero.
  
  Poiché la costruzione del grafo richiede tempo polinomiale rispetto alla dimensione del
  polinomio, si ha che 3-SAT è polinomialmente riducibile a HAM ed essendo 3-SAT NP-completo, e quindi NP-difficile, ne consegue che HAM è NP-difficile.
]
]
=== Problema Independent Set (IS)
#definition()[
  Sia $G=(V,E)$ un grafo non orientato, $I subset.eq V$ si dice *indipendente* quando $forall x,y in I$, ${x,y} in.not E$.
]
#figure(image("images/esempioIS.png",  width: 35%), caption: "I nove vertici blu formano un insieme indipendente massimo per questo grafo")
#problem("IS")[
  Dato un grafo non orientato $G$ e un intero $k$, determinare se $G$ contiene un sottoinsieme indipendente di cardinalità $k$.
]
#proposition()[
  Il problema IS è NP-difficile.
]
#proof()[
  Cerchiamo una riduzione polinomiale dal problema Clique a IS (sebbene i concetti di grafo completo e insieme indipendente siano opposti).
  $
    underbrace((G, k), "ist. clique") arrow.long.squiggly underbrace((tilde(G), k), "ist. IS")
  $
  Con $tilde(G)=(tilde(V), tilde(E))$ tale che
  $
    tilde(V) = V, quad tilde(E) = binom(V, 2) \\ E
  $
  dove $binom(V, 2) = { {u,v} | u,v in V, u!=v}$, cioè $tilde(G)$ è il grafo complementare di $G$: stessi vertici, e un arco tra due vertici distinti se e solo se tale arco non era presente in $G$ (figura d'esempio a fine dimostrazione).

  La costruzione di $tilde(G)$ a partire da $G$ richiede di esaminare tutte le $binom(|V|, 2)$ coppie di vertici, quindi è calcolabile in tempo polinomiale. Resta da mostrare che la riduzione è corretta:
  $
    G "ha una clique di cardinalità" k <==> tilde(G) "ha un insieme indipendente di cardinalità" k.
  $
  Sia $I subset.eq V$ con $|I|=k$. Allora $I$ è una clique in $G$ $<==>$ $forall x,y in I, x!=y$, ${x,y} in E$ $<==>$ $forall x,y in I, x!=y$, ${x,y} in.not tilde(E)$ $<==>$ $I$ è un insieme indipendente in $tilde(G)$.

  Quindi $G$ ha una clique di cardinalità $k$ se e solo se $tilde(G)$ ha un insieme indipendente di cardinalità $k$, il che prova la correttezza della riduzione.
  #figure(image("images/esempioGrafoComplementare.png", width: 50%))
]
#observation()[
  Da questo problema si può osservare che si effettuano riduzioni polinomiali non solo a partire dal problema 3-SAT, ma anche da altri problemi NP-completi noti.
]
== Problema 2-SAT
#index[Problema 2-SAT]
#problem()[
  Dato un polinomio booleano $p$ in 2-CNF (ogni clausola contiene esattamente 2 letterali), esiste un assegnamento di valori delle variabili che soddisfa $p$?
]

#proposition()[
  Il problema 2-SAT $in$ P.
]
Vediamo innanzitutto come costruire il grafo associato a $p$. Sia $p = u_1 and u_2 and dots and u_s " con " u_i = u_(i, 1) or u_(i, 2)$ un polinomio booleano in 2-CNF. Costruiamo un grafo orientato $G(p)$ nel seguente modo:

- vertici: $forall x$ variabile che compare in _p_, si scrivono i vertici $x "e" x'$;
- archi: $forall "clausola" u_i$, 2 archi: 
$
  cases(u_(i, 1)^' --> u_(i, 2), u_(i, 2)^' --> u_(i, 1))
$

#example()[
  $
    p = (x'_1 or x_2) and (x_1 or x_3) and (x_2 or x'_3) "in" {x_1,x_2,x_3}
  $
  #align(center, cetz.canvas({
    import cetz.draw: *
    set-style(mark: (fill: black, scale: 1))
    let r = 0.65
    let draw-node(pos, name, label) = {
      circle(pos, radius: r, name: name + "-c", fill: white, stroke: 1pt)
      content(pos, text(size: 1.4em, weight: "bold", label), name: name)
    }
    draw-node((0, 4), "x1", $x_1$)
    draw-node((0, 2), "x2", $x_2$)
    draw-node((0, 0), "x3", $x_3$)

    draw-node((4.5, 4), "x1p", $x'_1$)
    draw-node((4.5, 2), "x2p", $x'_2$)
    draw-node((4.5, 0), "x3p", $x'_3$)
    let conn(from, to) = {
      line(from + "-c", to + "-c", mark: (end: ">"))
    }
    conn("x1", "x2")
    conn("x3", "x2")
    conn("x2p", "x1p")
    conn("x2p", "x3p")
    conn("x1p", "x3")
    conn("x3p", "x1")
    content((7, 3.5), anchor: "west", text(size: 1.1em)[
      1. $(x'_1)' -> (x_2) ==> x_1 -> x_2$\
      2. $(x_1)' -> (x_3) ==> x'_1 -> x_3$\
      3. $(x_2)' -> (x'_3) ==> x'_2 -> x'_3$
    ])
    content((7, 0.5), anchor: "west", text(size: 1.1em)[
      1'. $(x_2)' -> (x'_1) ==> x'_2 -> x'_1$\
      2'. $(x_3)' -> (x_1) ==> x'_3 -> x_1$\
      3'. $(x'_3)' -> (x_2) ==> x_3 -> x_2$
    ])
  }))
]

#observation()[
  Siano $alpha$ e $beta$ vertici di $G(p)$. Allora, $alpha arrow.squiggly.long beta$ significa che c'è un cammino diretto da $alpha$ a $beta$.

  Inoltre, vale che se $alpha arrow.squiggly.long beta$ allora $beta' arrow.squiggly.long alpha'$.
]

#proposition()[
  _p_ è soddisfacibile $<==> exists.not x "variabile di" p "tale che in" G(p) space x arrow.squiggly.long x' "e" x' arrow.squiggly.long x$
]

#proof()[\
  $==>)$ Usiamo la contronominale. Supponiamo che esista una variabile $x$ t.c. $x arrow.squiggly.long x'$ e $x' arrow.squiggly.long x$; mostriamo che $p$ non è soddisfacibile. Sia $t$ un qualunque assegnamento.
  - Se $t(x)=1$, considerando il cammino $x arrow.squiggly.long x'$, poiché $t(x')=0$ deve esistere lungo il cammino un arco $alpha --> beta$ in cui si passa per la prima volta dal valore $1$ al valore $0$: $ &x --> gamma_1 --> dots --> alpha --> beta --> dots --> gamma_n --> x' \ &t(x)=1 space space space space space space space space space space t(alpha)=1, space t(beta)=0 space space space space space space space space space t(x')=0 $ Ma l'arco $alpha --> beta$ deriva dalla clausola $alpha' or beta$ di $p$, che sotto $t$ vale $ t(alpha')=0, quad t(beta)=0, $ e quindi non è soddisfatta.

  - Se $t(x)=0$, allora $t(x')=1$ e si applica lo stesso ragionamento al cammino $x' arrow.squiggly.long x$, ottenendo nuovamente una clausola non soddisfatta.
  
  In entrambi i casi $t$ non soddisfa $p$; essendo $t$ arbitrario, $p$ non è soddisfacibile.
  
  $<==)$ Senza perdita di generalità, supponiamo che $exists alpha$ letterale t.c. in _p_ compaiono sia $alpha$ che $alpha'$ (altrimenti _p_ sarebbe banalmente soddisfacibile).
  Se, per assurdo, $forall alpha$ letterale t.c. $alpha, alpha'$ compaiono in _p_, $alpha arrow.long.squiggly alpha'$, allora, se $beta$ è uno di questi letterali si ha  $beta arrow.long.squiggly beta'$ e $beta' arrow.long.squiggly beta$ (per l'osservazione sopra). Questo è assurdo perché contraddice l'ipotesi.\
  Pertanto $exists alpha$ letterale di _p_ t.c. $alpha'$ è anch'esso letterale di _p_ e $alpha cancel(arrow.long.squiggly) alpha'$.
  Sia $alpha$ uno di tali letterali, definiamo l'assegnamento _t_ ponendo:
  - $t(alpha) = 1$
  - $forall beta "t.c." alpha arrow.long.squiggly beta, space t(beta) = 1$
  #observation()[
    Fin qui _t_ è ben definito, perché non può accadere che $t(beta') = 1$, in quanto $alpha cancel(arrow.long.squiggly) beta'$: infatti, se per assurdo fosse $alpha arrow.long.squiggly beta'$, allora si avrebbe $beta arrow.long.squiggly alpha'$ (per l'osservaizone di prima) e quindi $alpha arrow.long.squiggly alpha'$, in contraddizione a quanto appena stabilito.
  ]
  Eliminiamo ora da $p$ tutte le clausole soddisfatte da $t$. Le clausole rimanenti contengono soltanto letterali non ancora assegnati: infatti, se una clausola $beta' or gamma$ contenesse $beta'$ con $t(beta)=1$, avremmo l'arco $beta --> gamma$ e poiché $alpha arrow.long.squiggly beta$ avremmo anche $alpha arrow.long.squiggly gamma$, da cui $t(gamma)=1$; la clausola sarebbe dunque già stata eliminata. Ripetiamo il procedimento sul polinomio rimanente. A ogni passo viene eliminata almeno una clausola, quindi dopo un numero finito di passi otteniamo un assegnamento che soddisfa tutte le clausole di $p$. Pertanto $p$ è soddisfacibile.
]

=== Algoritmo per 2-SAT
Grazie alla propsizione precedente possiamo costruire questo algoritmo per 2-SAT:

+ Costruisco il grafo $G(p)$
+ $forall x$ variabile di _p_, controllo se c'è $x arrow.long.squiggly x' "e" x' arrow.long.squiggly x$:
  - Se sì, allora _p_ non è soddisfacibile;
  - Altrimenti _p_ è soddisfacibile

Tale algoritmo è deterministico polinomiale, in quanto consiste essenzialmente nell'esecuzione di un algoritmo di ricerca in ampiezza (opportunamente modificato). Dunque:
#observation()[
  2-SAT $in$ P
]

== Classi NP-I e co-NP

=== NP-intermedi
Abbiamo visto (Sottosezione 3.4.1) che se $"P" eq.not "NP"$, ci sono dei linguaggi in NP che non stanno né in P né in NPC:
#index[Linguaggi NP-intermedi]
#definition()[
  I linguaggi *NP-intermedi* (o NP-I) sono linguaggi di NP che non stanno né in P né in NP-completi (o NP-C).

  $"NP-I" = "NP" \\ ("P" union "NP-C")$
]
#index[Teorema di Ladner]
#theorem("Ladner")[
  Se $"P" eq.not "NP"$, allora $"NP-I" eq.not emptyset$
]
=== co-NP
La classi P ed NP sono chiuse rispetto ad unione e intersezione. Infatti, dati $L_1$, $L_2 in$ P, si ha che $L_1 union L_2 in$ P e $L_1 inter L_2 in$ P: basta eseguire i due algoritmi deterministici polinomiali e per l'unione si accetta se almeno uno accetta, per l'intersezione si accetta solo se entrambi accettano. Un ragionamento analogo si può fare per NP.\
P è anche chiusa rispetto alla complementazione (P = co-P): se un linguaggio $L$ è in P, esiste per definizione una MdT deterministica $M$ che lo decide in tempo polinomiale. Poiché $M$ termina sempre, per decidere il complementare $L^'$ (in questa sezione indichiamo con $'$ il complementare)  è sufficiente utilizzare la stessa macchina $M$ e scambiare gli stati finali di accettazione e rifiuto. Questa operazione non aggiunge transizioni, preservando la complessità polinomiale del calcolo. Ci chiediamo se anche NP è chiusa per complementazione.
#index[Classe co-NP]
#definition()[
  co-NP $= {L "linguaggio" | L^' in "NP"}$
]
#example()[
  Il problema UNSAT, che dato un polinomio booleano $p$ determina se *non* è soddisfaccibile, appartiene a co-NP.
]
#problem("Aperto")[
  NP è chiusa per complementazione?
  $ "co-NP" =^? "NP" $
]

#proposition()[
  Se fosse dimostrato NP $eq.not$ co-NP, allora P $eq.not$ NP
]
#proof()[
  Ragioniamo per contronominale: supponiamo $"P" = "NP"$. Poiché $"P"$ è chiusa per complementazione vale $"co-P" = "P"$, e dunque
  $
    "co-NP" = "co-P" = "P" = "NP"
  $
  cioè $"NP" = "co-NP"$. Di conseguenza, se $"NP" eq.not "co-NP"$ allora $"P" eq.not "NP"$.
]

#proposition()[
  Supponiamo che esista un linguaggio $L$ tale che $L in$ NPC e $L in$ co-NP. Allora NP $=$ co-NP.
]
#proof()[
  #rect($"co-NP" subset.eq "NP"$)
  $Q in "co-NP" ==> Q' in "NP"$. Poiché $L in "NPC", exists f$ riduzione polinomiale da $Q' "a" L$, e osserviamo che _f_ è anche riduzione polinomiale da $Q "a" L' in "NP"$ (la stessa funzione di riduzione riduce anche i complementari).

  Determiniamo un algoritmo polinomiale non deterministico per decidere $Q$ data $w$ in input:

  - calcolo $f(w)$;
  - decido se $f(w) in L'$.
  Pertanto $Q in "NP"$.


  #rect($"NP" subset.eq "co-NP"$)
  $Q in "NP" ==> Q' in "co-NP" overbrace(==>, "dim. sopra") Q' in "NP" ==> Q in "co-NP"$
]
#observation()[
  Se mostrassimo che UNSAT $in$ NP, allora co-NP = NP
]
#example(multiple: true, "esercizi d'esame")[

  1. Chiusura di co-NP rispetto all'intersezione: siano $L_1, L_2 in "co-NP"$. Vogliamo mostrare che $L_1 inter L_2 in "co-NP"$.\

    Per definizione di co-NP, $L'_1 in "NP e" L'_2 in "NP"$.
    Per le leggi di De Morgan, $L_1 inter L_2 = (L'_1 union L'_2)'$.
    Poiché NP è chiusa rispetto all'unione, $L'_1 union L'_2 in "NP"$,
    e quindi, per definizione, $L_1 inter L_2 in "co-NP".$

  2. Differenza tra un linguaggio in NP e un suo sottolinguaggio in co-NP: siano $L in "NP"$, $L_1 subset.eq L$ e $L_1 in "co-NP"$. Vogliamo mostrare che $L without L_1 in "NP"$.\
  
   Poiché $L_1 in "co-NP"$, per definizione $L'_1 in "NP"$. Inoltre, $L without L_1 = L inter L'_1$. Siccome $L in "NP"$ e $L'_1 in "NP"$ e NP è chiusa rispetto all'intersezione, segue che $L inter L'_1 in "NP"$. Pertanto $L without L_1 in "NP"$.
]
== Test di primalità
Vogliamo trovare un algoritmo che dato un numero $n in NN$ in input determina se tale numero è primo.
#index[Test di primalità]
#proposition()[
  _n_ composto $==> exists d | n, " con " d in [2, sqrt(n)]$
]

#proof()[
  $n = m_1 dot m_2$\
  Se per assurdo $m_1, m_2 > sqrt(n)$ allora $n = m_1 dot m_2 > n$ ma $m_1 dot m_2 = n$ (assurdo)
]

=== Algoritmo deterministico non polinomiale

Dato $n in NN$, per ogni $d in [2, sqrt(n)]$ controllo se $d | n$:

- se sì: $n$ composto;
- altrimenti, $n$ primo

Analizziamone la complessità:
$
    & log n =    && l-->"Lunghezza della codifica binaria di "n \
    & " "arrow.t && arrow.t \
  n & = 2^l      && "Lo usiamo come parametro per la complessità"
$
La complessità dell'algoritmo sopra rispetto alla lunghezza _l_ è la seguente:
$
  Omega(sqrt(n)) = Omega(2^(l/2))
$
esponenziale... è troppo, vediamo se si può fare di meglio.
=== Piccolo teorema di Fermat
#index[Piccolo teorema di Fermat]
+ $ a^p equiv a quad (p) <== cases(delim: "[", p "primo", a in NN) $
+ $ a^(p-1) equiv 1 quad (p) <== cases(delim: "[", p "primo", a in NN, (a, p) = 1) $

=== Algoritmo non deterministico polinomiale

Dato $n in NN$:
- genero non deterministicamente $a in NN "t.c. "(a, n) = 1$
- se $a^(n-1) equiv 1 quad (n)$, allora $n$ primo
- altrimenti, $n$ composto

Questo algoritmo è *sbagliato*: applica il punto 2 del teorema di Fermat nel verso opposto e pertanto non è corretto. Però è polinomiale, quindi vale la pena "aggiustarlo" per farlo funzionare: infatti da questo deriva un algoritmo per calcolare le potenze modulari $a^n$ con complessità $Omicron(log n^2) = Omicron(l^2)$:
#index[Teorema di Pratt]
#theorem("Pratt, 1975")[
  $n in NN$.\
  Se $exists a in NN$ tale che:
  - $(a, n) = 1$
  - $a^(n - 1) equiv 1 quad (n)$

  - $forall q | n - 1, space q "primo", a^((n-1)/q) equiv.not 1 quad (n)$
  Allora $n$ è primo
]
#observation()[
  Ogni numero naturale possiede meno fattori primi distinti che caratteri nella sua rappresentazione binaria.

  $
    n = p_1^(alpha_1) dot p_2^(alpha_2) dot dots dot p_r^(alpha_r)
  $
  Il caso peggiore è dato da  $alpha_1 = alpha_2 = dots = alpha_r = 1$:
  $
    n = p_1 dot p_2 dot dots dot p_r > 2^r
  $
  Il numero di congruenze da controllare è quindi inferiore.
]
L'algoritmo visto sopra rimane tuttavia non deterministico. Si può arrivare ad una procedura deterministica? Forse testando la condizione del piccolo teorema di Fermat per un certo numero di $a$? Non funziona, perché esistono i seguenti numeri:

#index[Numeri di Carmichael]
#definition()[
  $n in NN$ si dice *numero di Carmichael* quando $forall a in NN, (a, n) = 1$, vale $a^(n-1) equiv 1 quad (n)$ e $n$ non è primo.
]

#example()[
  561 è un numero di Carmichael. $561 = 3 dot 11 dot 17$
]

#theorem("Alford, Granville, Pomerance")[
  Esistono infiniti numeri di Carmichael.
]
=== Verso un algoritmo deterministico polinomiale
Altra idea: modifichiamo il piccolo teorema di Fermat.
#index[Teorema di Agrawal (AKS)]
#theorem("Agrawal")[
  Sia $n in NN, a in NN$ e $(a, n) = 1$:
  $
    n "primo" <==> (x + a)^n equiv x^n + a quad (n)
  $
]

#proof()[\
  $==> )$ $n$ primo (congruenze tutte modulo $n$):
  $
    (x + a)^n = sum_(k=0)^n binom(n, k)a^(n - k)x^k equiv x^n + a^n overbrace(equiv, "Fermat") x^n + a quad (n)\
    binom(n, k) = (n!)/(k!(n - k)!) = (n dot (n - 1) dot dots dot (n - k + 1))/(k!), quad quad 0 < k < n ==> n bar binom(n, k) "(poiché" n "primo)"
  $
  $<== )$ $n$ composto. Facciamo vedere che $exists k "con" 0 < k <= n$,
  $
    n cancel(inverted: #true, bar) binom(n, k)
  $
  Sia $p | n$, $p$ primo:
  $
    &p^alpha | n, "ma" p^(alpha + 1) cancel(inverted: #true, bar) n". Ricordo che "binom(n, p) = (n dot (n - 1) dot dots dot (n - p + 1))/(p dot (p - 1) dot dots dot 2 dot 1)\
    &p^alpha "divide il numeratore", quad p^(alpha + 1) "non divide il numeratore"\
  $
  $
    p^alpha cancel(inverted: #true, bar) binom(n, p) ==> n cancel(inverted: #true, bar) binom(n, p)
  $
]

Le congruenze da testare sono circa $n = 2^l$. #underline("Idea"): dividere i polinomi per $x^r - 1$, per un opportuno $r$. Agrawal, Kayac, Saxena (2002) hanno dimostrato che se _n_ è composto e si sceglie un _r_ "giusto", allora è sufficiente testare la seguente congruenza per "pochi" _a_:
$
  (x+a)^n equiv x^n + a quad (n, x^r - 1)
$
e ne trovo uno per cui non vale. Il "giusto" $r$ e i "pochi" $a$ si dimostra che sono polinomiali in $l$. Quindi siamo arrivati ad un algoritmo deterministico per determinare se un numero è primo con complessità polinomiale.

== Classi di linguaggi esponenziali (EXP e NEXP)
=== EXP
#index[Classe EXP]
Definiamo:
$
  "EXP" = {L | exists M "MdT deterministica che accetta" L "t.c." t c_M (n) = Omicron(2^n^k)"," exists k >= 1}
$

#observation(multiple: true)[
  - $L in "EXP" <==> exists M$ MdT deterministica che accetta $L$ t.c. $t c_M (n) = Omicron(c^(p(n)))$, per opportuni $c > 1$ e $p(n)$ polinomio di grado $>= 1$ (sennò sarebbe costante).
  - $"P" subset.eq "EXP"$
]

#proposition()[
  $"NP" subset.eq "EXP"$
]
#proof()[
  Si basa sulla costruzione di una MdT deterministica equivalente a una non deterministica.\
  $L in "NP"$, $M$ MdT non deterministica che accetta $L$ t.c. $t c_M (n) = O(n^k)$. Sia $delta$ il grado di non determinismo di $M$ (ovvero il massimo numero di transizioni associate a una coppia stato-simbolo letto). Posso costruire una MdT $N$ deterministica che accetta $L$ eseguendo tutte le possibili computazioni di $M$ su una stringa $w$.

  Codifica delle computazioni di $M$ su $w$ di lunghezza $n$:
  $
    (m_1, m_2, dots, m_(n^k)) quad "dove" quad m_i in {1, dots, delta}
  $

Il numero di transizioni di una singola computazione è $O(n^k)$, mentre,
poiché a ogni passo vi sono al più $delta$ possibili scelte, il numero delle
possibili computazioni è al più $delta^(n^k)$. Pertanto
$
  t c_N (n) = O(n^k dot delta^(n^k))
$
per cui $L in "EXP"$.
]

#problem("Aperto")[
  Ancora non si sa se le inclusioni sono strette o no:
  $
    "P" limits(subset.eq)^? "NP" limits(subset.eq)^? "EXP"
  $
]

#proposition()[
  $"P" subset "EXP"$
]

#proof()[
  Facciamo vedere che $exists L in "EXP", L in.not "P"$
  $
    & L = { R(M)x | M "su "x" termina in uno stato finale entro" 2^(2|x|) "transizioni"}
  $
  1. *$L$ $in$ EXP*\

    $N$ MdT su input $R(M)x$:
    - Esegue $M$ su $x$
      - Se $M$ termina in uno stato finale entro $2^(2|x|)$ transizioni, accetta;
      - Altrimenti, rifiuta
    $N$ accetta $L$.

    Analizziamo la complessità in tempo di $N$: data la lunghezza dell'input $n = |R(M) x|$, considero che la lunghezza di $R(M)$ sia trascurabile ("corta") rispetto a quella di $x$ (vale a dire, suppongo di fissare $|R(M)|$ e far crescere solo $|x|$). Allora la complessità in tempo di $N$ è
    $
      t c_N (n) = Omicron(2^(2n)) ==> L in "EXP".
    $
    #observation()[
      $2^(2n) in.not Omicron(2^n)$, perché $2^(2n)\/2^n = 2^n arrow.long infinity$
    ]

  + *$L in.not$ P*\
    Facciamo vedere che $exists.not N$ MdT deterministica che accetta $L$ t.c. $t c_N (n) = Omicron(2^n)$

    #underline("Per assurdo"): sia $N$ MdT deterministica che accetta $L$ per stati finali t.c. $t c_N (n) = 2^n$.\

    Sia $D$ MdT definita come segue su input $R(M)$ (l'input è una MdT):

    - Esegue N su $R(M)R(M)$
      - Se $N$ termina in uno stato finale, $D$ termina in uno stato non finale;
      - Se $N$ termina in uno stato non finale, $D$ termina in uno stato finale.

    Analizziamo la complessità in tempo di $D$, con $n = |R(M)|$:
    $
      t c_D (n) = t c_N (2n) = 2^(2n)
    $
    Eseguiamo $D$ su $R(D)$ (cioè eseguiamo la $D$ sulla propria codifica, ossia sulla macchina $D$ stessa):
    + *$D$ su $R(D)$ termina in uno stato finale* $==>$ per definizione di $D$, $N$ su $R(D)R(D)$ termina in uno stato non finale $==>$ dato che $N$ è una MdT che accetta $L$ e $R(D)R(D)$ non appartiene al linguaggio, $D$ su $R(D)$ non termina in uno stato finale entro $2^(2|R(D)|)$ transizioni $==>$ dato che $t c_D (n) = 2^(2n)$, *$D$ su $R(D)$ non termina in uno stato finale*: assurdo.

    + *$D$ su $R(D)$ termina in uno stato non finale* $==>$ per definizione di $D$, $N$ su $R(D)R(D)$ termina in uno stato finale $==>$ dato che $N$ è una MdT che accetta $L$, *$D$ su $R(D)$ termina in uno stato finale* entro $2^(2|R(D)|)$ transizioni: assurdo.

  Abbiamo quindi costruito un linguaggio $L in "EXP"$ tale che $L in.not "P"$. Poiché $"P" subset.eq "EXP"$, segue che $"P" subset "EXP".$
]

=== NEXP
#index[Classe NEXP]
Definiamo un'altra classe di linguaggi esponenziali:
$
  "NEXP" = { L "linguaggio" | exists M "MdT non deterministica che accetta "L \ "t.c." t c_M (n) = Omicron(2^n^k), exists k >= 1}
$

#observation()[
  $ "EXP" subset.eq "NEXP" $
]

#problem("Aperto")[
  $ "EXP" =^? "NEXP" $
]

#proposition()[
  Se fosse dimostrato EXP $eq.not$ NEXP, allora P $eq.not$ NP
]

#proof()[
  Usando la contronominale, facciamo vedere che $"P" = "NP" ==> "EXP" = "NEXP"$.  Faremo vedere che NEXP $subset.eq$ EXP (l'altra inclusione è banalmente vera).

  Sia $L in "NEXP"$ e $M$ MdT non deterministica che accetta $L$ t.c. $t c_M (n) = O(2^n^k)$. Definiamo il linguaggio:

  $
    tilde(L) = {x 1^2^(|x|^k) space | space x in L} quad quad (1 in.not "alfabeto di" L).
  $

  Notare che dopo $x$ si aggiunge un numero di "1" proporzionale al tempo esponenziale necessario a $M$.\
  
  *1*. Facciamo vedere che $accent(L, tilde) in "NP"$. 
  Sia $N$ MdT non deterministica che accetta $accent(L, tilde)$ su input $y$:

  - controllo se $exists z "t.c." y = z 1^2^(|z|^k)$, altrimenti rifiuto;
  - se il controllo è passato, eseguo $M$ su $z$ e, in al più $2^(|z|^k)$ passi, decido se  $z in L$.

  La complessità in tempo di $N$ è polinomiale in $|y|$ (lunghezza di _y_). Infatti se $y = z 1^2^(|z|^k)$, allora $|y| = |z| + 2^(|z|^k)$ e quindi $2^(|z|^k) = O(|y|).$ Quindi $accent(L, tilde) in "NP"$, e visto che per ipotesi P = NP allora $accent(L, tilde) in$ P. Dunque $exists R$ MdT deterministica polinomiale che accetta $accent(L, tilde)$.\

  *2*. Facciamo vedere che $L in$ EXP con la seguente MdT deterministica per $L$:

  - data $x$, costruisco la stringa $y = x 1^2^(|x|^k)$;
  - uso $R$ per stabilire se $y in accent(L, tilde)$.

  Complessivamente, l'algoritmo descritto sopra è esponenziale in $|x|$: poiché $|y| = O(2^(|x|^k))$, l'esecuzione di $R$ che ha complessita $O(n^h)$ richiede un tempo $O(|y|^h) = O(2^(h |x|^k))$ (ma anche costruire $y$ richiede tempo esponenziale).

  Dunque, se P = NP, il linguaggio arbitario $L$ appartiene non solo a NEXP ma anche ad EXP, ovvero NEXP $subset.eq$ EXP da cui EXP = NEXP. Per contronominale, questo equivale a $"EXP" eq.not "NEXP" ==> "P" eq.not "NP"$.
]

== Complessità in spazio

#index[Complessità in spazio]
#definition()[
  Sia $M$ una MdT a $k >= 2$ nastri, con nastro di input di sola lettura. La *complessità in spazio di $M$* è indicata dalla funzione _space complexity_
  $
    s c_M: NN --> NN
  $
  dove $s c_M (n)$, è il numero di celle sui nastri di lavoro a cui le testine hanno accesso durante una computazione di $M$ su una stringa di lunghezza $n$, nel caso peggiore.
]

#observation(multiple: true)[
  + La definizione vale sia nel caso deterministico che in quello non deterministico;
  + non è necessario che $M$ termini su ogni input;
  + $s c_M (n) > 0$ (la testina parte sempre dalla prima cella del nastro di lavoro).
]

#example()[
  Sia $L$ il linguaggio delle stringhe palindrome binarie su ${a,b}$. Descriviamo il comportamento di una MdT $M$ a 3 nastri che accetta tale linguaggio.

  All'inizio scrivo 1 sul nastro 3 (questo nastro tiene un contatore, in binario), il nastro 2 è vuoto, sul nastro 1 c'è l'input e le testine sono a inizio nastro.

  Quando sul nastro 3 c'è _*i*_:
  - Copio _*i*_ sul nastro 2;
  - Finché non arrivo a 0 sul nastro 2:
    - Sposto la testina a destra sul nastro 1;
    - Decremento il contatore sul nastro 2.
  - Se sul nastro 1 trovo \*, accetto;
  - Altrimenti, leggo il carattere sul nastro 1 (*$w_i$*) e lo "memorizzo";
  - Sposto la testina del nastro 1 sulla prima cella \* a destra dell'input;
  - Copio _*i*_ sul nastro 2;
  - Finché non arrivo a 0 sul nastro 2:
    - Sposto la testina a sinistra sul nastro 1;
    - Decremento il contatore sul nastro 2.
  - Confronto *$w_i$* con *$w_(n+1-i)$*, se sono diversi, rifiuto; altrimenti aggiorno il nastro 3 scrivendo $i+1$ e ricomincio.

  La complessità in spazio di $M$ nel caso peggiore si ha in caso di accettazione. Se scrivo i numeri naturali in binario, il numero di celle che mi serve per scrivere $n + 1$ per 2 volte (sui nastri 2 e 3 scrivo il contatore $i$) è
  $
    s c_M (n) = 2 dot (ceil(log(n+1))+2)
  $
]
Vediamo adesso che relazioni ci sono tra complessità spaziale e temporale: 
#proposition()[
  Se $M$ MdT a 2 nastri, allora:
  $
    t c_M (n) = f(n) ==> s c_M (n) <= f(n) + 1
  $
]
#proof()[
  Nel caso peggiore, $M$ legge una nuova cella sul nastro di lavoro ad ogni transizione, aggiungendo la cella iniziale: $s c_M (n) <= f(n) + 1$
]

#proposition()[
  Se $M$ MdT a 2 nastri, $|Q| = m, |Sigma| = t$ (cardinalità di insieme degli stati e alfabeto), allora:
  $
    s c_M (n) = f(n) ==> t c_M (n) <= m dot (n+2) dot f(n) dot t^f(n)
  $
]
#proof()[
  Poiché $M$ termina su ogni input, essa non può transitare 2 volte per la stessa configurazione. Valutiamo il numero totale di possibili configurazioni di $M$ su una stringa in input di lunghezza _n_, con il numero di stati $|Q| = m$, e cardinalità dell'alfabeto di lavoro $|Sigma| = t$:
  $
    m dot (n+2) dot f(n) dot t^f(n)
  $
  Dove:
  - $m$ è il numero di possibili stati;
  - $n+2$ è il numero di possibili posizioni della testina sul nastro 1, o su un simbolo della stringa, o sulla prima cella vuota o sull'ultima;
  - $f(n)$ è il numero di possibili posizioni della testina sul nastro 2;
  - $t^f(n)$ è il numero di possibili simboli da scrivere nelle $f(n)$ celle lette sul nastro 2;

  Si conclude che:
  $
    t c_M <= m(n+2)f(n)t^f(n)
  $
]

=== Classi PSACE e NPSPACE

#index[Classe PSPACE]
#definition()[
  $
    "PSPACE" = {L "linguaggio" | exists M "MdT det. che accetta" L "t.c." s c_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#index[Classe NPSPACE]
#definition()[
  $
    "NPSPACE" = {L "linguaggio" | exists M "MdT non det. che accetta" L \ "t.c." s c_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#observation(multiple: true)[
  + $"P" subset.eq "PSPACE"$ $-->$ $"P" limits(=)^? "PSPACE"$ (prob. aperto)
  + $"PSPACE" subset.eq "EXP"$ $-->$ $"PSPACE" limits(=)^? "EXP"$ (prob. aperto)
  + $"NP" subset.eq "PSPACE"$\
    $L in "NP" ==> exists M "MdT non deterministica polinomiale in tempo che accetta" L$ poiché si può riutilizzare lo spazio.
]

=== Teorema di Savitch

#index[Teorema di Savitch]
#theorem("Savitch")[
  $"PSPACE" = "NPSPACE"$
]
#proof()[
  $"PSPACE" subset.eq "NPSPACE"$ è ovvio. Vogliamo dimostrare che $"NPSPACE" subset.eq "PSPACE"$.

  Sia $L in "NPSPACE"$, $M$ MdT non deterministica che accetta $L$ in spazio polinomiale. Numero di possibili configurazioni di $M$ in una sua computazione su input di lunghezza $n$:
  $
    O(2^("sc"_M (n) dot c)) quad quad "per un opportuno valore" c.
  $

  Sia $x$ una stringa di lunghezza $n$ e $C_x arrow.squiggly.long C^*$ una computazione accettante di $M$ su $x$, dove $C_x$ è la configurazione iniziale e $C^*$ la configurazione accettante (supponiamo sia unica).

  Introduciamo questo predicato:
  $
    "reachable"(C, C', j)
  $
  con $C, C'$ configurazioni di $M$ e $j in NN$, reachable$(C,C',j)$ è vero quando, partendo da $C$, si può raggiungere $C'$ in al più $2^j$ transizioni.

  #observation()[
    $x in L <==> x$ è accettata da $M <==>$ reachable$(C_x, C^*, c dot "sc"_M (n))$ è vero.
  ]

  Scriviamo un algoritmo deterministico per valutare reachable$(C,C',j)$:

  - se $j=0$, facile (il predicato è vero se $C = C'$ o se si raggiunge $C'$ da $C$ con una sola transizione).
  - Altrimenti, per un generico $j > 0$, per ogni possibile configurazione $tilde(C)$ verifichiamo:
    $
      "reachable"(C, tilde(C), j-1) quad "e" quad "reachable"(tilde(C), C^', j-1).
    $
    Se esiste $tilde(C)$ tale che entrambi i predicati sono veri allora reachable$(C,C',j)$ è vero; altrimenti è falso.\

  Valutiamo la complessità in spazio per il calcolo di reachable: sia $f(j)$ lo spazio richiesto per calcolare reachable quando il terzo parametro è $j$. Poiché per valutare reachable$(C,C',j)$ basta tenere in memoria una configurazione $tilde(C)$ in più rispetto al calcolo ricorsivo di reachable con parametro $j-1$ (lo spazio della ricorsione si riusa: calcolo la prima chiamata ricorsiva, riuso quello spazio per la seconda e poi passo al successivo $tilde(C)$), si ha
  $
    f(j) = f(j-1) + O("sc"_M (n)) = f(j-2) + 2 dot O("sc"_M (n)) = \ = dots.c = f(j-k) + k dot O("sc"_M (n)) = dots.c = j dot O("sc"_M (n)).
  $

  Ponendo $j = c dot "sc"_M (n) = O(n^k)$ (perché $M$ è nondet. polinomiale), si ottiene che lo spazio totale richiesto è polinomiale in $n$. Dunque $L$ appartiene non solo a NPSPACE ma anche a PSPACE, e poiché $L$ è arbitrario vale NPSACE $subset.eq$ PSPACE che insieme all'inclusione opposta porta a PSPACE = NPSACE.
]

// Lezione del 13-05-2026
#index[PSPACE-difficile]
#definition()[
  L linguaggio si dice *PSPACE-difficile* quando $forall Q in "PSPACE", exists f$ riduzione polinomiale in tempo da _Q_ a _L_.

  L si dice *PSPACE-completo* quando L è PSPACE-difficile e $L in "PSPACE"$
]

#proposition()[
  Sia $L$ PSPACE-completo. Allora:

  + $L in "P" ==> "P" = "PSPACE"$
  + $L in "NP" ==> "NP" = "PSPACE"$
]

#proof()[
  + $"P" subset.eq "PSPACE"$ è ovvio. Sia $Q in "PSPACE"$. Poiché $L$ è PSPACE-completo, $exists f$ riduzione polinomiale in tempo da $Q$ a $L$.
  
    Algoritmo per decidere $Q$:
    - Dato _w_, calcolo $f(w) -->$ tempo polinomiale;
    - Decido se $f(w) in L -->$ tempo polinomiale (perché $L in "P"$),
    Dunque $Q in$ P e poiché $Q$ è arbitrario vale PSPACE $subset.eq$ P e quindi P = PSPACE.

  + $"NP" subset.eq "PSPACE"$ è ovvio. Sia $Q in "PSPACE"$. Poiché $L$ è PSPACE-completo, $exists f$ riduzione polinomiale in tempo da $Q$ a $L$.

    Algoritmo nondeterministico per decidere $Q$:
    - Dato _w_, calcolo $f(w) -->$ tempo polinomiale;
    - Decido se $f(w) in L -->$ tempo polinomiale non deterministico (perché $L in$ NP).
    
    Dunque $Q in$ NP e poiché $Q$ è arbitrario vale PSPACE $subset.eq$ NP e quindi NP = PSPACE.
]

== Problemi di conteggio
#index[Problemi di conteggio]
I problemi di conteggio si occupano di stabilire quante possono essere le soluzioni di un problema (ovvero, data una MdT $M$ e una stringa $w$, ci si chiede quante siano le configurazioni accettanti di $M$ su $w$). Di seguito considereremo $Sigma = {0, 1}$.

#index[Classe FP]
#definition()[
  Si chiama *FP* la classe delle funzioni $f: Sigma^* -> NN$ per cui esiste una MdT deterministica che calcola _f_ in tempo polinomiale:
  $
    "FP" = {f: Sigma^* -> NN | exists M "MdT che calcola" f "t.c." t c_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#index[Classe \#P]
#definition()[
  Si chiama *\#P* ("sharp P") la classe delle funzioni $f: Sigma^* -> NN$ per cui esiste una MdT non deterministica polinomiale tale che, per ogni stringa $w in Sigma^*$, le computazioni accettanti di $M$ su _w_ sono $f(w)$:
  $
    "#P" = {
      f: Sigma^* --> NN | exists M "MdT non deterministica polinomiale t.c.", forall w in Sigma^* \
      f(w) "è il numero di computazioni accettanti di "M" su" w
    }
  $
]
#proposition()[
  FP $subset.eq$ \#P
]
#proof()[
  Data $f in$ FP, sia $M$ MdT deterministica polinomiale che calcola _f_. Considero la seguente MdT non deterministica polinomiale su input $w$:

  - calcolo $f(w) = k$;
  - genero _k_ computazioni (ciascuna delle quali stampa un intero _i_, con $1 <= i <= k$), e le considero tutte accettanti.
  Segue che $f in$ \#P, da cui la tesi.
]

#problem("aperto")[
  $
    "FP" limits(=)^? "#P"
  $
]

#proposition()[
  Se valesse FP = \#P, allora P = NP
]
#proof()[
  Sia $L in "NP", " allora" exists M$ MdT non deterministica polinomiale che accetta _L_. Sia $f: Sigma^* --> NN$ la funzione che conta le computazioni accettanti di $M$, allora  $f in$ \#P, ma per ipotesi FP = \#P, quindi vale anche $f in$ FP. Dunque $exists N "MdT"$ deterministica polinomiale che calcola _f_.

  Algoritmo per decidere _L_ su input $w$:

  - Calcolo $f(w)$;
  - Se $f(w) = 0$, rifiuto $w$ (poiché $f(w)$ è anche il numero di computazioni accettanti);
  - Se $f(w) > 0$, accetto $w$ (almeno una computazione accettante).

  Dato che questo è un algoritmo polinomiale per _L_ vale $L in "P"$, da cui la tesi.
]
#problem("aperto")[
  $
    "P" = "NP" limits(==>)^? "FP" = "#P"
  $
]

#proposition()[
  Se fosse vero che PSPACE = P, allora FP = \#P
]
#proof()[
  Avendo già dimostrato FP $subset.eq$ \#P, rimane da dimostrare \#P $subset.eq$ FP.

  #grid(
    columns: 2,
    column-gutter: 10pt,
    grid.cell(
      [Sia $f in \#P$. Allora, $exists M$ MdT non deterministica polinomiale le cui computazioni accettanti sono contate da _f_.],
      inset: 5pt,
    ),
    [#rect(
      [Il numero totale di computazioni di _M_ su una stringa di lunghezza _n_ è al più $2^q(n)$, con $q(n)$ polinomio.],
    )],
  )

  Sia _N_ la MdT deterministica equivalente a _M_, a cui aggiungiamo un nastro per contare le computazioni accettanti.
  $
    L_k = {w | "ci sono almeno" k "computazioni di" M "che accettano" w}
  $
  MdT per calcolare _f_, su input _w_ (una sorta di ricerca binaria):

  - Determino se  $w in L_(1/2 2^(q(n)))$ usando $N$ e confrontando il numero di computazioni accettanti con $k = 1/2 2^q(n)$.

    - Se $k < 1/2 2^q(n)$, rifaccio con $L_(1/4 2^(q(n)))$;

    - Se $k >= 1/2 2^q(n)$, rifaccio con $L_(3/4 2^(q(n)))$.

  Complessità in tempo:

  - $forall k$, $L_k in "PSPACE" ==> L_k in "P"$;
  - Il numero di linguaggi da controllare non è $2^q(n)$, ma $Omicron(log(2^(q(n)))) = Omicron(q(n))$ (ricerca binaria)

  Dunque la complessità è polinomiale, perciò $f in$ FP ed essendo $f in$ \#P arbitraria vale la tesi.\ 
]
=== Esempi di problemi di conteggio
#index[Problema \#SAT]
#index[Problema CYCLE]
#index[Problema \#CYCLE]
#example(multiple: true)[
  + *\#SAT*: dato un polinomio booleano, determinare quanti sono gli assegnamenti che lo soddisfano. (\#SAT $in$ \#P).
  + Il problema CYCLE ($in$ P) vuole determinare se, dato un grafo orientato, questo contiene almeno un ciclo semplice. Invece, *\#CYCLE*, dato un grafo orientato, vuole determinare il numero di cicli semplici che contiene (\#CYCLE $in$ \#P)
]

#observation()[
  Se fosse vero che \#SAT $in "FP", " allora SAT" in "P" ==> "P" = "NP"$
]

#proposition()[
  Se fosse vero che \#CYCLE $in$ FP, allora $"P" = "NP"$
]
#proof()[
  Facciamo vedere che con questa ipotesi si ottiene che HAM $in$ P (dato che HAM è un problema NP, se dimostriamo che è $in$ P, allora vale che $"P" = "NP"$).

  Sia $G$ un grafo orientato con $n$ vertici. La strategia è:

  - costruiamo un nuovo grafo orientato $G'$ in tempo polinomiale;
  - facciamo vedere che:
    - $G$ ha un circuito hamiltoniano $<==>$ $G'$ ha almeno $n^n^2$ cicli.

  Costruzione di $G'$: al posto di ogni lato $(u, v)$ di G mettiamo questo gadget:
  #figure(image("/assets/image-9.png", width: 60%), caption: "Anche sopra ci sono m nuovi vertici")
  Ogni lato $(u, v)$ di $G$ corrisponde a $2^m$ cammini semplici da _u_ a _v_ in $G'$ (per ogni nodo intermedio aggiunto ho 2 strade per arrivare a $v$). Pertanto, ogni ciclo semplice di lunghezza _l_ di $G$ corrisponde a $(2^m)^l$ cicli semplici in $G'$.\
  Scegliamo $m = n log_2(n)$ (per semplicità, supponiamo che _n_ sia una potenza di 2). Mostriamo che $G$ ha un circuito hamiltoniano $<==>$ $G'$ ha almeno $n^n^2$ cicli:

  $==>)$ $G$ ha un circuito hamiltoniano. Il numero dei cicli di $G'$ è $>= (2^m)^n = (2^(n log_2(n)))^n = (n^n)^n = n^n^2$.\
  $<==)$ $G$ non ha un circuito hamiltoniano. Allora il più lungo ciclo di $G$ ha lunghezza al più $n - 1$, quindi il numero di cicli di $G$ è al massimo $n^(n-1)$. Il numero di cicli di $G'$ è quindi:
  $
    <= (2^m)^(n-1) dot n^(n-1) = (2^(n log_2 n))^(n-1) dot n^(n-1) = n^(n(n-1)) dot n^(n-1) = n^(n^2-n) dot n^(n-1) = n^(n^2-1) < n^(n^2)
  $
  Dunque $G$ ha un circuito hamiltoniano se e solo se $G'$ ha almeno $n^(n^2)$ cicli. Sotto l'ipotesi \#CYCLE $in$ FP possiamo contare in tempo polionmiale il numero di cicli di $G'$ e confrontarlo con $n^(n^2)$, che in binario ha lunghezza $log_2(n^(n^2)) = n^2log_2(n)$. Questo permetterebbe di decidere HAM in tempo polinomiale e quindi si avrebbe P = NP.\
]
