#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/suiji:0.5.1": *
#import "@preview/in-dexter:0.7.2": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()
#set math.equation(block: true)
#show math.equation: set block(breakable: true)

#pagebreak()
//25.02.2026
= Approssimazione di funzioni
In molte applicazioni, è spesso richiesto di determinare una conveniente approssimazione di una funzione
$
  f:[a,b]subset RR --> RR
$
Questo per diversi motivi, come ad esempio:
- la forma funzionale di $f(x)$ potrebbe essere troppo complessa;
- la forma funzionale di $f(x)$ potrebbe essere non nota, sebbene si conoscano i valori assunti su un insieme di ascisse tra loro distinte:
  $
    a lt.eq x_0 < x_1 < ... < x_n lt.eq b
  $
In generale si ricerca l'approssimazione di $f(x)$ in una classe di funzioni abbastanza semplici da manipolare, come ad esempio quella dei polinomi.
== Interpolazione polinomiale
Date $n+1$ ascisse distinte nell'intervallo $[a,b]$ ordinate in modo tale che
$
  a lt.eq x_0 < x_1 < ... < x_n lt.eq b
$
In corrispondenza di tali punti assumiamo di conoscere i valori di una funzione $f(x)$. In altre parole, ci sono assegnate $n+1$ coppie di dati $(x_i, f_i), space i=0,...,n$, dove poniamo per comodità $f_i equiv f(x_i), space i =0,...,n$.

Dal punto di vista geometrico:
#figure(
  canvas({
    import draw: *
    plot.plot(
      size: (10, 4),
      x-tick-step: 1,
      y-tick-step: 1,
      y-min: 0,
      y-max: 9,
      x-min: 0,
      x-max: 10,
      plot-style: (stroke: black),
      legend: "inner-north-east",
      {
        let func = x => -0.05 * calc.pow(x, 3) + 0.55 * calc.pow(x, 2) - 1.3 * x + 5
        let poly = x => -0.2 * calc.pow(x, 2) + 2 * x + 1

        plot.add(func, domain: (0, 10), label: $f(x)$, style: (stroke: blue))
        plot.add(poly, domain: (0.5, 9.5), label: $p_n (x)$, style: (stroke: red))

        plot.add-hline(0, style: (stroke: black))

        let nodes = ((2, 4.2), (5, 6), (8, 4.2))
        plot.add(nodes, style: (stroke: none), mark: "o")


        plot.add-vline(2, 5, 8, min: 0, max: 0.2, style: (stroke: black))
        plot.annotate({
          content((2, 0.8), $x_0$)
          content((5, 0.8), $x_1$)
          content((8, 0.8), $x_2$)
        })
      },
    )
  }),
)
Obiettivo: costruire una funzione "semplice" che interpola i dati $(x_i, f_i), i=0,1,...,n$. A riguardo, considereremo, tra le varie possibilità, *funzioni interpolanti* che sono polinomi.

#definition()[
  #index("Polinomio interpolante")
  Diremo che $p(x) in Pi_n$ è un *polinomio interpolante* le coppie di dati  $(x_i, f_i)$, se:
  $
    p(x_i) = f_i, quad i=0,1,...,n
  $
]

Vale a riguardo il seguente risultato:
<unicità-polinomio-interpolante>
#theorem("Unicità del polinomio interpolante")[
  Date le $n+1$ coppie di dati $(x_i, f_i), space i=0,...,n$, con $x_i eq.not x_j$ se $i eq.not j$ (ascisse distinte), allora *esiste ed è unico* $p(x) in Pi_n$ (insieme dei polinomi di grado $n$):
  $
    p(x_i) = f_i, space i=0,...,n
  $
]
#proof()[
  Se $p(x) in Pi_n$, allora sarà della forma
  $
    p(x)=sum_(k=0)^n a_k x^k
  $
  dove $a_0, ..., a_n$ sono i coefficienti (per il momento incogniti) della rappresentazione di $p(x)$ rispetto alla base delle potenze $(x^0, x^1, ..., x^n)$. I coefficienti $a_0, ..., a_n$ si otterranno imponendo le condizioni di interpolazione:
  $
    p(x_i) = sum_(k=0)^n a_k x_i^k = f_i, space i=0,...,n
  $
  ovvero:
  $
    cases(
      x_0^0 a_0 + x_0^1 a_1 + ... + x_0^n a_n = f_0,
      x_1^0 a_0 + x_1^1 a_1 + ... + x_1^n a_n = f_1,
      quad dots.v quad quad quad quad quad quad quad quad dots.v,
      x_n^0 a_0 + x_n^1 a_1 + ... + x_n^n a_n = f_n,
    ) quad quad (4.1)
  $
  che è un sistema di equazioni lineari nelle $n+1$ incognite $a_0,...,a_n$. Pertanto la sua soluzione esisterà e sarà unica se solo se la matrice dei coefficienti è non singolare.
  Se definiamo il vettore delle incognite e quello dei termini noti:
  $
    uu(a) = mat(a_0; a_1; dots.v; a_n) in RR^(n+1) quad quad quad uu(b) = mat(f_0; f_1; dots.v; f_n) in RR^(n+1)
  $
  allora il sistema lineare (4.1) si può scrivere in forma vettoriale come:
  $
    (4.2) quad V uu(a) = uu(b) quad "con" quad
    V = mat(
      x_0^0, x_0^1, ..., x_0^n;
      x_1^0, x_1^1, ..., x_1^n;
      , , dots.v, ;
      x_n^0, x_n^1, ..., x_n^n;
      delim: "["
    ) in RR^(n+1 times n+1)
  $
  V è la trasposta di una matrice di *Vandermonde*, che è una matrice molto nota in Analisi Numerica. Di essa sono note molte proprietà, tra cui anche l'espressione del suo determinante:
  $
    det(V) = product_(i>j) (x_i - x_j) eq.not 0 quad quad ("con" x_i "e" x_j "ascisse")
  $
  poiché le ascisse sono, per ipotesi, tra loro distinte, la soluzione del sistema (4.2) esiste ed è unica, ovvero esiste ed è unico il polinomio $p(x) in Pi_n$, interpolante le coppie di dati.
]

Osserviamo che, tuttavia, il calcolo del polinomio interpolante mediante la risoluzione del sistema lineare (4.2) non è una buona prassi computazionale. Questo è dovuto al fatto che il numero di condizionamento della matrice $V$ cresce assai rapidamente con il crescere di $n$.

#example("Mal condizionamento di Vandermonde")[
  Nel caso $[a,b]=[0,1]$ e $x_i=i/n, i=0,1,...,n$, il condizionamento produce:
  #align(center, table(
    align: center,
    rows: 2,
    columns: 8,
    [$n$], [2], [3], [5], [$...$], [10], [15], [20],
    [$K_2(V)$], [1.5], [9.9], [$4.9 dot 10^3$], [$...$], [$1.2 dot 10^8$], [$3.1 dot 10^12$], [$9.1 dot 10^16$],
  ))
]

Per ovviare al precedente problema, occorrerà utilizzare una differente base polinomiale per rappresentare $p(x)$.

#observation()[
  Anche se cambiamo base per rappresentare $p(x)$, il polinomio rimane lo stesso, perché esso è unico.
]

== Forma di Lagrange e forma di Newton
La base polinomiale che andiamo a considerare è quella di Lagrange:
$
  L_("in")(x) = product_(j=0 \ j eq.not i)^n frac(x-x_j, x_i-x_j), space i=0,...,n
$
#observation(multiple: true)[
  1. Si tratta di $n+1$ polinomi, ben definiti se le ascisse sono *distinte*.
  2. Si tratta di polinomi tutti di grado $n$: $L_("in")(x) in Pi_n, space i=0,...,n$.
  3. $
      L_("in")(x_k) = cases(1 "se" k=i, 0 "se" k eq.not i)
    $
    #index("Delta di Kroenecker")
    Introducendo il *delta di Kroenecker*
    $
      delta_(i k) = cases(1 "se" k=i, 0 "se" k eq.not i)
    $
    abbiamo quindi che
    $
      L_("in")(x_k) = delta_(i k)
    $
]

#lemma()[
  I polinomi ${L_("in")(x)}_(i=0,...,n)$ sono linearmente indipendenti. Pertanto essi costituiscono una base per $Pi_n$.
]

#lemma()[
  #index("Forma di Lagrange")
  Il polinomio $p(x) in Pi_n$ tale che $p(x_i)=f_i$ per $i=0,...,n$ si può rappresentare in modo esplicito come:
  <4.3>
  $
    p(x) = sum_(i=0)^n f_i L_("in")(x) quad quad (4.3)
  $
]
#proof()[
  La dimostrazione è immediata se si sfrutta la proprietà della delta di Kronecker intrinseca ai polinomi di base di Lagrange. Valutando $p(x)$ in un generico nodo $x_k$ otteniamo:
  $
    p(x_k) = sum_(i=0)^n f_i L_("in")(x_k) = sum_(i=0)^n f_i delta_(i k) = f_k delta_(k k) = f_k quad forall k=0,...,n.
  $
]

#definition()[
  L'espressione data dalla #link(<4.3>)[(4.3)] definisce la *forma di Lagrange* del polinomio interpolante.
]

//26.02.2026
Vogliamo ora calcolare il coefficiente principale (ovvero il coefficiente del monomio di grado massimo $x^n$) del polinomio $p(x)$.
Analizziamo il singolo polinomio di base $L_("in")(x)$. Il suo *numeratore* è il prodotto di $n$ binomi del tipo $(x-x_j)$:
$
  (x-x_0) dots (x-x_(i-1)) (x-x_(i+1)) dots (x-x_n) = x^n + dots
$
Sviluppando i prodotti, si ottiene chiaramente #index("Polinomio monico") un *polinomio monico* (cioè con coefficiente principale uguale a $1$).
Il denominatore di $L_("in")(x)$ non è altro che una costante. Di conseguenza, il coefficiente principale dell'intero polinomio $L_("in")(x)$ è dato dall'inverso di questa costante:
<4.4>
$
  c_(i n) = frac(1, product_(j=0\ j != i)^n (x_i-x_j)) quad quad (4.4)
$
Poiché il polinomio interpolante globale $p(x)$ è una combinazione lineare dei polinomi di base pesata con i valori $f_i$, il suo coefficiente principale totale sarà semplicemente la combinazione lineare dei singoli coefficienti principali. Lo indichiamo come:
<4.5>
$
  c_n = sum_(i=0)^n c_(i n) f_i = sum_(i=0)^n frac(f_i, product_(j=0\ j != i)^n (x_i-x_j)) quad quad (4.5)
$
Questo risultato ci tornerà utile in seguito per definire un'altra base di polinomi.

A questo punto, ci poniamo la seguente domanda: se definiamo $p_r (x) in Pi_r$ il polinomio interpolante $f(x)$ sulle ascisse $underbrace(x_0\, dots\, x_r, r+1)$, è possibile definire definire in modo incrementale $p_r (x)$ a partire da $p_(r-1)(x)$, che è il polinomio interpolante $f(x)$, di grado al più $r-1$, sulle ascisse $underbrace(x_0\, dots\, x_(r-1), r)$?

Osserviamo subito che la *base di Lagrange si presta malissimo* a questo scopo. Infatti, il nuovo polinomio sarebbe:
<4.6>
$
  p_r (x) = sum_(i=0)^r f_i L_(i r)(x), quad "con" quad L_(i r)(x) = product_(j=0\ j != i)^r frac(x-x_j, x_i-x_j) quad (i=0,...,r) quad quad (4.6)
$
mentre al passo precedente avevamo:
$
  p_(r-1)(x) = sum_(i=0)^(r-1) f_i L_(i, r-1)(x), quad "con" quad L_(i, r-1)(x) = product_(j=0\ j != i)^(r-1) frac(x-x_j, x_i-x_j) quad (i=0,...,r-1)
$
Come si nota confrontando i prodotti, $L_(i r)(x) != L_(i, r-1)(x)$. L'aggiunta del singolo nodo $x_r$ altera tutti i denominatori e i numeratori della base preesistente. Questo ci impedisce di riutilizzare i calcoli precedenti: ogni volta che si aggiunge un punto, l'intera formula di Lagrange va ricalcolata da zero.

Di conseguenza, il nostro obiettivo è trovare un modo per esprimere $p_r (x)$ nella forma incrementale:
$
  p_r (x) = p_(r-1)(x) + overbracket(q_r(x), "polinomio" \ "di grado" r)
$
Iterando questo procedimento per $r=1,...,n$, il polinomio $p_n (x)$ finale sarà l'interpolante globale su tutte le ascisse.

Per ottenere questo comportamento incrementale, dobbiamo ricorrere ad un'ulteriore base di rappresentazione: #index("Base di Newton") la *base di Newton*. Essa è una famiglia di polinomi *monici* (cioè il coefficiente del termine di grado massimo è $1$) ed è definita per ricorrenza nel seguente modo:
<4.7>
$
  cases(
    omega_0 (x) equiv 1,
    omega_i (x) = omega_(i-1)(x)(x-x_(i-1)) = product_(j=0)^(i-1) (x-x_j) quad i=1\,2\,dots
  ) quad quad (4.7)
$
#observation(multiple: true)[
  + Per induzione, otteniamo che $omega_i (x)=product_(j=0)^(i-1) (x-x_j)$ per $i >= 1$. Ovvero, $omega_i (x)$ è un polinomio monico di grado esatto $i$, le cui radici sono gli $i$ nodi $underbrace(x_0\, dots\, x_(i-1), i "radici")$.
  + $forall i=1,dots,n : space omega_i (x_j)=0, space forall j < i$.
  + Avendo $omega_i (x)$ grado esatto $i, space forall i=0, dots, n$, abbiamo che i polinomi sono linearmente indipendenti e costituiscono una base dello spazio $Pi_n$.
]
A questo punto, assegnate le ascisse $x_0,...,x_n$ (distinte tra loro), è possibile costruire in forma incrementale la famiglia di polinomi interpolanti ${p_r (x)}_(r=0,dots,n)$ tali che $p_r (x) in Pi_r$ e:
$
  forall r = 0,...,n: space p_r (x_i) = f_i, space i=0,dots,r
$
La costruzione avviene ricorsivamente come segue:
<4.8>
$
  cases(
    p_0(x) equiv f_0,
    p_r (x) = underbrace(p_(r-1)(x), in Pi_(r-1)) + f[x_0,...,x_r] underbrace(omega_r (x), in Pi_r) quad r=1\,...\,n
  ) quad quad (4.8)
$
con il coefficiente definito come:
<4.9>
$
  f[x_0, dots, x_r] = sum_(i=0)^r frac(f_i, product_(j=0 \ j != i)^r (x_i-x_j)) quad quad (4.9)
$

Andiamo a dimostrare che, se:
$
  p_(r-1)(x_i) = f_i, space i=0,dots,r-1 quad quad (4.10)
$
allora è possibile determinare univocamente $f[x_0, dots, x_r]$ nella (4.8), in modo tale che valga:
$
  p_r (x_i) = f_i, space i=0, dots,r quad quad (4.11)
$
Successivamente dimostreremo che $f[x_0, dots, x_r]$ è effettivamente riscrivibile nella forma #link(<4.9>)[(4.9)]..

#proof()[
  Procedendo per induzione, abbiamo che $p_0(x) in Pi_0$ e $p_0(x_0) = f_0$. Assunta vera la (4.10), andiamo a verificare che è possibile determinare $f[x_0, dots, x_r]$ in modo che sia soddisfatta la (4.11):
  $
    p_r (x_i) = p_(r-1)(x_i) + f[x_0,dots,x_r]omega_r(x_i) = cases(
      i<r: quad f_i + f[x_0,dots,x_r] overbrace(omega_r (x_i), = 0) = f_i,
      i=r: quad p_(r-1)(x_r) + f[x_0,dots,x_r]omega_r (x_r) = f_r
    )
  $
  Considerato che le ascisse sono distinte e che, pertanto, $omega_r (x_r) != 0$, possiamo soddisfare la condizione di interpolazione per l'ultimo nodo ($i=r$) ricavando direttamente il coefficiente:
  $
    f[x_0,dots,x_r] = frac(f_r - p_(r-1)(x_r), omega_r (x_r))
  $
  Facciamo ora vedere che $f[x_0, dots, x_r]$ si può esprimere esplicitamente nella forma #link(<4.9>)[(4.9)].

  Il ragionamento si basa sul #link(<unicità-polinomio-interpolante>)[*teorema di unicità del polinomio interpolante*]: poiché esiste un unico polinomio $p_r (x)$ di grado al più $r$ che interpola i dati assegnati, le sue diverse rappresentazioni (forma di Newton e forma di Lagrange) devono descrivere la stessa identica funzione. Di conseguenza, il coefficiente del termine di grado massimo (il *coefficiente principale* associato a $x^r$) deve essere lo stesso in entrambe le formulazioni.

  + *Nella forma di Newton (incrementale):*\
    Dalla #link(<4.8>)[(4.8)] abbiamo $p_r (x) = p_(r-1)(x) + f[x_0, dots, x_r] omega_r (x)$. Poiché $p_(r-1)(x)$ ha grado al più $r-1$, esso non contribuisce al termine in $x^r$. Il polinomio base $omega_r (x) = product_(j=0)^(r-1) (x-x_j)$ è un polinomio monico di grado $r$ (ossia inizia con $1 dot x^r$). Di conseguenza, l'unico termine in $x^r$ di tutta l'equazione è generato dal prodotto $f[x_0, dots, x_r] dot x^r$. Ne deduciamo che il coefficiente principale di $p_r (x)$ è esattamente la differenza divisa $f[x_0, dots, x_r]$.

  + *Nella forma di Lagrange:*\
    Come abbiamo già dimostrato nella (4.5), calcolando $p_r (x)$ (ossia ponendo $n=r$), il coefficiente principale del polinomio interpolante espresso nella base di Lagrange è dato dalla sommatoria:
    $ sum_(i=0)^r frac(f_i, product_(j=0\ j != i)^r (x_i - x_j)) $

  Essendo $p_r (x)$ lo stesso polinomio in entrambi i casi, i due coefficienti principali appena calcolati devono necessariamente coincidere. Uguagliandoli, si ottiene esattamente l'espressione #link(<4.9>)[(4.9)], che risulta così dimostrata.
]

#definition()[
  #index("Differenza divisa")
  $f[x_0,dots,x_r], space r=0,1,dots$, come definita nella #link(<4.9>)[(4.9)], è detta *differenza divisa* di $f(x)$ sulle ascisse $x_0,dots,x_r$.
]

#definition()[
  #index("Forma di Newton")
  Il polinomio interpolante nella forma di Newton è quindi definito come:
  <4.12>
  $
    p_n (x) = sum_(r=0)^n f[x_0,dots,x_r]omega_r (x) quad quad (4.12)
  $
]

#observation()[
  Il  polinomio $p_n (x)$, ricordiamo è *unico*. Pertanto:
  $
    p_n (x) = sum_(i=0)^n f_i L_("in")(x) = sum_(i=0)^n f[x_0, dots, x_i] omega_i (x)
  $
  ovvero, la forma di Lagrange e quella di Newton del polinomio interpolante sono *algebricamente equivalenti*. _Attenzione: ciò non significa che sono equivalenti dal punto di vista dell'aritmetica finita_
]

//04.03.2026
Valgono le seguenti proprietà delle differenze divise:

#heading(numbering: none, depth: 3, "Proprietà 1", outlined: false)
Se $alpha, beta in RR$ e $f(x), g(x)$ sono funzioni di una variabile reale, allora:
$
  (alpha dot f + beta dot g)[x_0,dots,x_i]=alpha dot f[x_0,dots,x_i] + beta dot g[x_0,dots,x_i] quad quad ("linearità")
$

#heading(numbering: none, depth: 3, "Proprietà 2", outlined: false)
Se $(i_0,dots,i_r)$ è una permutazione di $(0,dots,r)$, allora:
$
  f[x_(i_0),dots,x_(i_r)] = f[x_0,dots,x_r] quad quad ("simmetria rispetto agli argomenti")
$

#heading(numbering: none, depth: 3, "Proprietà 3", outlined: false)
Siano $f(x)$ un polinomio di grado $k$ e $p(x)$ il suo polinomio interpolante di grado $n$, allora:
$
  f(x) = sum_(i=0)^k a_i x^i quad quad p(x)=sum_(i=0)^n f[x_0,dots,x_i]omega_i (x)\
  f[x_0,dots,x_n]=cases(a_k\, space "se" k=n, 0\, space "se" k<n)
$
#observation()[
  Dalla 3., se $k=n$, per l'unicità del polinomio interpolante, avremo che $f(x)equiv p(x)$. Pertanto, i coefficienti principali, rispettivamente $a_n$ e $f[x_0,dots,x_n]$, devono coincidere:
  $
    f[x_0,dots,x_n] = a_n quad quad (n=k)
  $
  Tuttavia, se $n>k$, anche ora $p(x) equiv f(x)$. Quest'ultimo può essere riscritto come:
  $
    f(x)= sum_(i=0)^k a_i x^i + 0 dot x^(k+1) + dots + 0 dot x^n
  $
  _Ricordare che $forall n >= k$, il polinomio di grado $n$ che interpola un polinomio di grado $k$ *coincide con quest'ultimo per l'unicità del polinomio interpolante*._ Se ad esempio vogliamo calcolare il polinomio interpolante di grado 25 di una parabola (polinomio di grado 2), vedremo che il risultato sarà anch'esso un polinomio di grado 2!
]

#heading(numbering: none, depth: 3, "Proprietà 4", outlined: false)
Se $f(x) in C^((r+1)) [a,b]$, allora:
$
  f[x_0, dots, x_r] = frac(f^((r))(xi), r!) quad xi in [min_i x_i, max_i x_i]
$
#observation()[
  La proprietà 4. continua a valere anche nel caso di ascisse coincidenti. Ad esempio:
  $
    f[x_0, x_0] = lim_(x_1 ->x_0) f[x_0, x_1] = lim_(x_1 ->x_0) frac(f(x_1)-f(x_0), x_1-x_0) = f'(x_0)
  $
  ovvero utilizzando un procedimento al limite.

  Se tutte le ascisse $x_i -> x_0, space i=1,dots,n$, allora:
  $
    f underbrace([x_0,dots,x_0], r+1) = frac(f^((r))(x_0), r!)
  $
  inoltre:
  $
    omega_r (x) = product_(i=0)^(r-1) (x-x_i) = (x-x_0)^r
  $
  Pertanto se $x_0=x_1=dots=x_n$, otteniamo che:
  $
    p(x)=sum_(r=0)^n f[x_0,dots,x_0] omega_r (x) = sum_(r=0)^n frac(f^((r))(x_0), r!)(x-x_0)^r
  $
  che è il polinomio di Taylor di grado $n$ di $f(x)$, centrato in $x_0$.
]

#heading(numbering: none, depth: 3, "Proprietà 5", outlined: false)
$
  f overbrace([x_0, dots, x_r], r+1) = frac(f overbrace([x_1, dots, x_r], r)-f overbrace([x_0, dots, x_(r-1)], r), x_r - x_0)
$
#proof()[
  #let colfuchsia(x) = text(fill: fuchsia, $#x$)
  #let colgreen(x) = text(fill: green, $#x$)
  #let colblue(x) = text(fill: blue, $#x$)
  $
    frac(1, x_r-x_0)(f[x_1,dots,x_r]-f[x_0,dots,x_(r-1)]) = frac(1, x_r-x_0) (sum_(k=1)^r frac(f_k, product_(j=1\ j eq.not k)^r (x_k-x_j)) - sum_(k=0)^(r-1) frac(f_k, product_(j=0\ j eq.not k)^(r-1) (x_k-x_j)))\
    = frac(1, x_r-x_0) [colfuchsia(frac(f_r, product_(j=1\ j eq.not r)^r (x_r-x_j))) colgreen(- frac(f_0, product_(j=0\ j eq.not 0)^(r-1) (x_0-x_j))) + colblue(sum_(k=1)^(r-1)frac(f_k, product_(j=1\ j eq.not k)^(r-1)(x_k-x_j))(frac(1, x_k-x_r)-frac(1, x_k-x_0)))]=(*)\
    colfuchsia(frac(1, x_r-x_0) dot frac(f_r, product_(j=1 \ j eq.not r)^r (x_r-x_j)) = frac(f_r, product_(j=0 \ j eq.not r)^r (x_r-x_j)))\
    colgreen(frac(-1, x_r-x_0) dot frac(f_0, product_(j=0 \ j eq.not 0)^(r-1) (x_0-x_j)) = frac(1, x_0-x_r) dot frac(f_0, product_(j=0 \ j eq.not 0)^(r-1) (x_0-x_j)) = frac(f_0, product_(j=0 \ j eq.not 0)^r (x_0-x_j)))\
    colblue(frac(1, x_r-x_0) dot sum_(k=1)^(r-1) frac(f_k, product_(j=1\ j eq.not k)^(r-1) (x_k-x_j)) dot frac(x_k - x_0 - x_k +x_r, (x_k-x_r)(x_k-x_0)) = sum_(k=1)^(r-1) frac(f_k, product_(j=0\ j eq.not k)^r (x_k-x_j)))\
    => (*) = sum_(k=0)^r frac(f_k, product_(j=0\ j eq.not k)^r (x_k-x_j)) = f[x_0,dots, x_r]
  $
]


#observation()[
  Questa proprietà è fondamentale dal punto di vista computazionale. Sapendo che le differenze divise di ordine 0 coincidono semplicemente con i valori della funzione ($f[x_i] = f_i$ per $i=0,dots,n$), questa formula ci consente di calcolare *in modo incrementale* tutte le differenze divise richieste per costruire il polinomio di Newton, senza dover mai calcolare l'onerosa sommatoria della definizione esplicita.
]

La proprietà 5. ci consente di calcolare in modo efficiente le differenze divise necessarie per il calcolo del polinomio interpolante in forma di Newton.
#align(center, figure(table(
  columns: 7,
  align: center + horizon,
  stroke: none,
  table.hline(y: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  table.vline(x: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  [], [0], [1], [2], [$dots.c$], [$n-1$], [$n$],
  [$x_0$], [$f[x_0]$], [], [], [], [], [],
  [$x_1$], [$f[x_1]$], [$f[x_0,x_1]$], [], [], [], [],
  [$x_2$], [$f[x_2]$], [$f[x_1,x_2]$], [$f[x_0,x_1,x_2]$], [], [], [],
  [$dots.v$], [$dots.v$], [$dots.v$], [$dots.v$], [$dots.down$], [], [],
  [$x_(n-1)$], [$f[x_(n-1)]$], [$dots.v$], [$dots.v$], [$dots$], [$f[x_0,dots,x_(n-1)]$], [],
  [$x_n$],
  [$f[x_n]$],
  [$f[x_(n-1),x_n]$],
  [$f[x_(n-2),x_(n-1),x_n]$],
  [$dots$],
  [$f[x_1,dots,x_n]$],
  [$f[x_0,dots,x_n]$],
)))
Quelle sulla diagonale sono le differenze divise necessarie per il calcolo del polinomio in forma di Newton.
#observation()[
  Se calcoliamo le colonne di questa matrice triangolare dal basso verso l'alto, possiamo sovrascrivere i risultati negli elementi adiacenti a sinistra. Pertanto sarà sufficiente un vettore di $n+1$ elementi (in realtà 2, uno anche per le ascisse).
]

//05.03.2026
Esaminiamo, in dettaglio, il caso $n=2$, prima di derivare una procedura generale per il calcolo delle differenze divise nel caso di $n$ generico.

#align(center, table(
  columns: 4,
  align: center + horizon,
  stroke: none,
  table.hline(y: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  table.vline(x: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  [], [0], [1], [2],
  [$x_0$], [$f[x_0]equiv f_0$], [], [],
  [$x_1$], [$f[x_1] equiv f_1$], [$f[x_0,x_1]=frac(f[x_1]-f[x_0], x_1-x_0)$], [],
  [$x_2$],
  [$f[x_2] equiv f_2$],
  [$f[x_1,x_2]=frac(f[x_2]-f[x_1], x_2-x_1)$],
  [$f[x_0,x_1,x_2]=frac(f[x_1\,x_2]-f[x_0\,x_1], x_2-x_0)$],
))
Scriviamo ora un codice Matlab che implementa questo algoritmo nel caso generale. Poiché i vettori hanno indicizzazione a partire da 1, i vettori in ingresso saranno $x$ e $f$ di lunghezza $n+1$ (prima e seconda colonna della tabella precedente):
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 4.1* Calcolo delle differenze divise],
)
```matlab
for j=1:n
  for i=n+1:-1:j+1
    f(i)=(f(i)-f(i-1))/(x(i)-x(i-j));
  end
end
```
#observation()[
  Questo algoritmo è, evidentemente, funzionante in modo corretto se e solo se il vettore $x$ contiene elementi tra loro *distinti*. Questo controllo va effettuato prima di eseguire le precedenti istruzioni.
]

- *Occupazione di memoria*: 2 vettori di lunghezza $n+1$ ($x$ e $f$). Pertanto la complessità è *lineare* in $n$.
- *Numero di operazioni*: abbiamo 3 operazioni elementari nel ciclo più interno. Per questo motivo otteniamo:
  $
    3 dot sum_(j=1)^n (n-j+1) = 3 dot sum_(j=1)^n j = 3 dot frac(n(n+1), 2) = O(n^2)
  $

Vediamo adesso come calcolare efficientemente il polinomio $p(x)$. Consideriamo preliminarmente un problema più semplice, ovvero il calcolo di un polinomio di grado $n$ espresso nella base canonica delle potenze:
$
  p(x) = sum_(i=0)^n a_i x^i
$
#example()[
  Con $n=2$, il polinomio è $p(x) = a_0 + a_1 x + a_2 x^2$. Raccogliendo a cascata la variabile $x$, possiamo riscriverlo in modo annidato come:
  $
    p(x) = a_0 + x (a_1 + x (a_2))
  $
  I passi per valutarlo partendo dal termine più interno verso l'esterno sono:
  - $p = a_2$
  - $p <-- p dot x + a_1 => p = a_2 x + a_1$
  - $p <-- p dot x + a_0 => p = a_0 + a_1 x + a_2 x^2$
]
Questo procedimento prende il nome di *algoritmo di Horner*. La sua complessità computazionale è di soli $2n$ `flops` ($n$ moltiplicazioni e $n$ addizioni), che rappresenta il minimo numero di operazioni teoricamente necessarie per valutare un polinomio di grado $n$. // Possibile domanda parziale
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 4.2* Algoritmo di Horner],
)
```matlab
n = length(a)-1;
p= a(n+1);
for i = n: -1 : 1
    p = p * x + a(i);
end
```
#observation()[
  Se volessimo calcolare il polinomio simultaneamente in un vettore di punti `x`, è sufficiente sfruttare la vettorializzazione di Matlab, sostituendo l'operazione nel ciclo con `p = p .* x + a(i);` (moltiplicazione elemento per elemento).
]
Questo algoritmo può essere generalizzato al caso del polinomio interpolante #link(<4.12>)[(4.12)], utilizzando la definizione incrementale #link(<4.7>)[(4.7)] della base di Newton. Matematicamente, equivale a raccogliere i binomi $(x - x_i)$ anziché la singola $x$:
$
  p(x) = f_0 + (x-x_0)(f_1 + (x-x_1)(f_2 + dots (x-x_(n-1))f_n) dots )
$
In Matlab, supponendo che `x` sia il vettore contenente le ascisse dei nodi, `f` il vettore contenente le differenze divise, ed `xx` il vettore dei punti in cui vogliamo calcolare il polinomio, otteniamo la seguente generalizzazione:
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: none,
)
```matlab
p= a(n+1) * ones(size(xx));
for i = n: -1 : 1
    p = p .* (xx - x(i)) + f(i);
end
```
Come si evince dal ciclo interno, ad ogni iterazione vengono eseguite 3 operazioni vettoriali: una sottrazione `(xx - x(i))`, una moltiplicazione `.*`, e un'addizione `+ f(i)`. Pertanto, il costo computazionale sale a $3n$ `flops` per ogni singolo punto in cui viene calcolato il polinomio interpolante.

*Domanda:* Cosa succede se $x in.not \{x_0, dots, x_n\}$?

// 11.03.2026
== Errore di interpolazione
$p(x)$ è il polinomio interpolante $f(x)$ nelle ascisse assegnate. Se definiamo:
$
  e(x)=f(x)-p(x) quad quad "(funzione dell'errore)"
$
da cui, ricordando che $p(x_i)=f(x_i)$, otteniamo che:
$
  e(x_i) = 0, space i=0,dots,n
$
$
  e(x) = f(x) - p(x), space x in [a,b]
$
Cosa accade per $x in.not {x_0, dots,x_n}$?

#theorem()[
  L'errore di interpolazione $e(x) = f(x) - p(x)$ si può esprimere in modo esatto come:
  <4.13>
  $
    e(x) = f[x_0, dots, x_n, x] omega_(n+1) (x) quad quad (4.13)
  $
  dove $omega_(n+1) (x) = product_(j=0)^n (x-x_j)$ è il polinomio monico di grado $n+1$ le cui radici sono esattamente le ascisse di interpolazione.
]
#proof()[
  Analizziamo due casi possibili per il punto $x$ in cui vogliamo valutare l'errore:
  + Se $x = x_i$ per un certo $i in {0, dots, n}$, sappiamo che l'errore deve essere nullo, ovvero $e(x_i) = 0$. La formula #link(<4.13>)[(4.13)] rispetta perfettamente questa condizione poiché, in corrispondenza dei nodi, il polinomio si annulla: $omega_(n+1) (x_i) = 0$.

  + Sia $x = hat(x) in.not {x_0, dots, x_n}$ un generico punto del dominio. Il "trucco" della dimostrazione consiste nell'aggiungere temporaneamente questo punto ai nostri dati, immaginando di costruire un *nuovo* polinomio interpolante $hat(p)(x) in Pi_(n+1)$ che interpola la funzione $f$ sia sulle $n+1$ ascisse originali, sia nella nuova ascisse $hat(x)$.

    Sfruttando la costruzione incrementale della base di Newton, possiamo esprimere questo nuovo polinomio $hat(p)(x)$ aggiungendo un singolo termine di aggiornamento al nostro vecchio polinomio $p(x)$:
    <4.14>
    $
      hat(p)(x) = p(x) + f[x_0, dots, x_n, hat(x)] omega_(n+1) (x) quad quad (4.14)
    $
    Per definizione stessa di polinomio interpolante, $hat(p)(x)$ deve intersecare perfettamente la funzione $f(x)$ in tutti i nodi scelti, incluso l'ascissa appena aggiunta $hat(x)$. Deve quindi valere l'uguaglianza $hat(p)(hat(x)) = f(hat(x))$.

    Valutiamo allora l'equazione #link(<4.14>)[(4.14)] nel punto fittizio $hat(x)$:
    $
      hat(p)(hat(x)) = p(hat(x)) + f[x_0, dots, x_n, hat(x)] omega_(n+1)(hat(x)) = f(hat(x))
    $

    Ora possiamo isolare la differenza $f(hat(x)) - p(hat(x))$ (che altro non è se non la definizione del nostro errore di interpolazione in $hat(x)$):
    $
      e(hat(x)) equiv f(hat(x)) - p(hat(x)) = f[x_0, dots, x_n, hat(x)] omega_(n +1) (hat(x))
    $

    Poiché $hat(x)$ era un punto completamente arbitrario (l'unico vincolo era  che non coincidesse con un nodo già noto), possiamo generalizzare il   risultato rinominandolo semplicemente $x$. Otteniamo così la tesi finale:
    $
      e(x) = f[x_0, dots, x_n, x] omega_(n+1) (x)
    $
]

#corollary()[
  Se la funzione $f(x)$ è sufficientemente regolare, ovvero $f in C^((n+1))$ su un intervallo che contiene sia i nodi di interpolazione che il punto $x$ da valutare, allora l'errore può essere espresso come:
  <4.15>
  $
    e(x) = frac(f^((n+1))(xi_x), (n+1)!) omega_(n+1) (x) quad quad (4.15)
  $
  dove $xi_x$ è un opportuno punto incognito appartenente a $I(x_0, dots, x_n, x)$, denotando con quest'ultimo il più piccolo intervallo chiuso che contiene tutti i nodi assegnati e il punto $x$ in argomento.
]
#proof()[
  La dimostrazione è immediata e deriva direttamente dalla formula esatta dell'errore #link(<4.13>)[(4.13)]. Nelle ipotesi di regolarità fatte:
  $
    f[x_0, dots, x_n, x] = frac(f^((n+1))(xi_x), (n+1)!)
  $
  per un opportuno punto $xi_x in I(x_0, dots, x_n, x)$. Sostituendo questa identità nella (4.13), si ottiene direttamente la tesi.
]

#observation(multiple: true)[
  + *Interpolazione esatta di polinomi:* se $f(x) in Pi_n$, la sua derivata di ordine $(n+1)$ è identicamente nulla su tutto il dominio ($f^((n+1)) equiv 0$). Di conseguenza la formula restituisce $e(x) equiv 0$, ovvero $f(x) equiv p(x)$. Il polinomio interpolante ricostruisce esattamente i polinomi di grado $<= n$, come già sapevamo per il teorema di unicità.

  + *Separazione delle cause di errore:* dalla #link(<4.15>)[(4.15)] evinciamo che l'errore $e(x)$ è generato dal prodotto di due contributi di natura diversa:
    - Il termine $frac(f^((n+1))(xi_x), (n+1)!)$, che dipende esclusivamente da quanto è "buona" e regolare la funzione $f(x)$ (ovvero da quanto velocemente le sue derivate diventano piccole al crescere dell'ordine di derivazione).
    - Il polinomio $omega_(n+1)(x) = product_(i=0)^n (x-x_i)$, che dipende esclusivamente dalla *scelta e dalla distribuzione delle ascisse* di interpolazione.

  + *Pericolosità dell'estrapolazione:* se cerchiamo di valutare il polinomio molto al di fuori del range delle ascisse (cioè per $x >> max_i {x_i}$ oppure $x << min_i {x_i}$), le distanze $(x-x_i)$ diventano grandi e il polinomio cresce in modo esplosivo con andamento asintotico $omega_(n+1)(x) approx x^(n+1)$. Pertanto, $p(x)$ è un'approssimazione "spendibile" e affidabile *solo se* il punto $x$ si trova all'interno (o nelle immediate vicinanze) dell'intervallo che contiene le ascisse.
]

#example()[
  #figure(
    canvas({
      import draw: *
      let p(x) = {
        let l0 = (x - 3) * (x - 5) * (x - 7) / (-48.0)
        let l1 = (x - 1) * (x - 5) * (x - 7) / 16.0
        let l2 = (x - 1) * (x - 3) * (x - 7) / (-16.0)
        let l3 = (x - 1) * (x - 3) * (x - 5) / 48.0
        return 2.0 * l0 + 5.0 * l1 + 6.0 * l2 + 1.0 * l3
      }

      let f(x) = p(x) + 0.05 * (x - 1) * (x - 3) * (x - 5) * (x - 7)

      let data-f = range(0, 86).map(i => {
        let x = i / 10.0
        (x, f(x))
      })

      let data-p = range(0, 86).map(i => {
        let x = i / 10.0
        (x, p(x))
      })

      let nodi = ((1, 2), (3, 5), (5, 6), (7, 1))

      plot.plot(
        size: (10, 4),
        x-min: 0,
        x-max: 8,
        y-min: -4,
        y-max: 8,
        x-tick-step: 1,
        y-tick-step: 2,
        legend: "inner-south-west",
        {
          plot.add(data-f, style: (stroke: rgb("FF8C00") + 1.5pt), label: [$f(x)$])
          plot.add(data-p, style: (stroke: rgb("008060") + 1.5pt), label: [$p(x)$])
          plot.add(nodi, mark: "o", style: (stroke: none))
        },
      )
    }),
  )

  Dal grafico possiamo evincere tre fatti fondamentali:
  1. *Coincidenza sui nodi:* in corrispondenza dei nodi di interpolazione la curva verde "aggancia" perfettamente la curva arancione. In questi punti l'errore è strettamente nullo ($e(x_i) = 0$).
  2. *L'errore:* negli spazi tra un nodo e l'altro, le due curve si discostano. La distanza verticale tra la curva verde e la curva arancione in un generico punto $x$ rappresenta geometricamente l'errore di interpolazione $e(x) = f(x) - p(x)$.
  3. *Estrapolazione:* il polinomio interpolante è tracciato e ha senso solo all'interno dell'intervallo $[x_0, x_n]$. Come avevamo osservato, se provassimo a estrapolare il dato all'esterno di questo intervallo, il polinomio (che diverge all'infinito per $x -> oo$) si allontanerebbe drasticamente dalla curva arancione, rendendo l'approssimazione del tutto inaffidabile.
]

== Interpolazione di Hermite
Supponiamo in questo caso, di ricercare il polinomio interpolante, di grado $2n+1$ su $2n+2$ ascisse distinte, che numeriamo come:
$
  x_0 < x_(1/2) < x_1 < x_(1+1/2) < dots < x_n < x_(n+1/2)
$
Sia $f(x)$ la funzione interpolanda su tali ascisse. Pertanto, sappiamo che $exists p(x) in Pi_(2n+1)$ tale che:
<4.16>
$
  (4.16) quad quad cases(p(x_i)=f(x_i), p(x_(i+1/2))=f(x_(i+1/2))) quad i=0,dots,n
$

*Domanda*: cosa succede a $p(x)$ se $forall i = 0,dots, space x_(i+1/2) -> x_i$?

Per rispondere in maniera corretta a questa domanda, riscriviamo la #link(<4.16>, [(4.16)]), equivalentemente, come:
<4.17>
$
  (4.17) quad quad
  cases(
    p(x_i)=f(x_i)\,,
    frac(p(x_(i+1/2)) - p(x_i), x_(i+1/2)-x_i) = frac(f(x_(i+1/2))-f(x_i), x_(i+1/2)-x_i)\, quad i=0\,dots\,n
  )
$
A questo punto, l'operazione di far "collassare" i due punti ($x_(i+1/2) -> x_i$) equivale ad applicare l'operatore limite a entrambi i membri della seconda equazione. Per la definizione stessa di derivata, i rapporti incrementali si trasformano nelle derivate prime valutate nel nodo $x_i$.

Abbiamo così dimostrato che, al limite, le condizioni originali definiscono un nuovo tipo di polinomio interpolante. Esiste ed è unico un polinomio $p_H (x) in Pi_(2n+1)$, detto *polinomio di Hermite*, che soddisfa il seguente sistema: #index("Polinomio di Hermite")
<4.18>
$
  cases(
    p_H (x_i) = f(x_i),
    p'_H (x_i) = f'(x_i)
  ) quad quad i=0,dots,n quad quad (4.18)
$

#definition()[
  Il polinomio $p_H (x) in Pi_(2n+1)$ che soddisfa le condizioni di interpolazione (4.18) è detto polinomio interpolante di Hermite.
]
#observation()[
  In altri termini, il polinomio interpolante di Hermite interpola, nelle ascisse assegnate, sia i valori della funzione $f(x)$ che i valori della sua derivata prima $f'(x)$.

  Geometricamente, questo significa che il polinomio $p_H (x)$ e la funzione originaria $f(x)$ condividono la *stessa retta tangente* in tutti i nodi di interpolazione.
]
#example()[
  #figure(
    canvas({
      import draw: *
      plot.plot(
        size: (8, 4),
        y-min: -1,
        y-max: 1,
        plot-style: (stroke: black),
        {
          let func = x => calc.sin(x)
          plot.add(
            func,
            domain: (0, 2 * calc.pi),
            style: (stroke: blue),
          )

          // I tre nodi di interpolazione
          plot.add(
            ((0, 0), (3.14, 0), (6.28, 0)),
            style: (stroke: none),
            mark: "o",
          )
        },
      )
    }),
  )
  Se $f(x)=sin(x)$ e $x_i=i pi, space i=0,1,2$, allora il polinomio interpolante su tali ascisse è $p(x)=0$, ovvero la retta passante per i tre punti: l'informazione sulle "onde" della funzione andrebbe persa. Questo non è vero per il polinomio interpolante di Hermite, il quale prenderà in considerazione la pendenza della funzione in ogni punto.
]

//12.03.2026
=== Forma di Newton del polinomio interpolante di Hermite
Per derivare la *forma di Newton* di questo polinomio, facciamo un passo indietro considerando, formalmente, le $2n+2$ ascisse:
$
  a lt.eq x_0 < x_(1/2) < x_1 < x_(1+1/2) < dots < x_n < x_(n+1/2) lt.eq b
$
Se fissiamo, ad esempio, il caso $n=2$, abbiamo che il relativo polinomio interpolante è dato da:
$
  p(x)= & f[x_0] \
      + & f[x_0, x_(1/2)](x-x_0) \
      + & f[x_0, x_(1/2), x_1](x-x_0)(x-x_(1/2)) \
      + & f[x_0, x_(1/2), x_1, x_(3/2)](x-x_0)(x-x_(1/2))(x-x_1) \
      + & f[x_0, x_(1/2), x_1, x_(3/2),x_2](x-x_0)(x-x_(1/2))(x-x_1)(x-x_(3/2)) \
      + & f[x_0, x_(1/2), x_1, x_(3/2),x_2,x_(5/2)](x-x_0)(x-x_(1/2))(x-x_1)(x-x_(3/2))(x-x_2)
$
Se adesso poniamo $x_(1/2)=x_0, x_(3/2)=x_1, x_(5/2)=x_2$, otteniamo la forma di Newton del polinomio di Hermite:
$
  p_H (x)= & f[x_0] \
         + & f[x_0, x_0](x-x_0) \
         + & f[x_0, x_0, x_1](x-x_0)(x-x_0) \
         + & f[x_0, x_0, x_1, x_1](x-x_0)(x-x_0)(x-x_1) \
         + & f[x_0, x_0, x_1, x_1,x_2](x-x_0)(x-x_0)(x-x_1)(x-x_1) \
         + & f[x_0, x_0, x_1, x_1,x_2,x_2](x-x_0)(x-x_0)(x-x_1)(x-x_1)(x-x_2)
$

#observation(multiple: true)[
  + Il calcolo del polinomio, note le differenze divise, si può fare agevolmente mediante l'algoritmo di Horner generalizzato, semplicemente duplicando le ascisse di interpolazione.
  + Il calcolo delle differenze divise, visto che ci sono ascisse ripetute in argomento, richiede invece qualche modifica dell'algoritmo classico visto per il polinomio interpolante.
]
A questo fine, costruiamo la tabella per il calcolo delle differenze divise. Per semplicità, consideriamo il caso $n=1$ ($2 n + 2 = 4$ ascisse e $2 n + 1 = 3°$ grado):
#align(center, table(
  columns: 5,
  align: center + horizon,
  stroke: none,
  table.hline(y: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  table.vline(x: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  [], [0], [1], [2], [3],
  [$x_0$], [$f[x_0]$], [], [], [],
  [$x_0$], [$f[x_0]$], [$f[x_0,x_0]$], [], [],
  [$x_1$], [$f[x_1]$], [$f[x_0,x_1]$], [$f[x_0,x_0,x_1]$], [],
  [$x_1$], [$f[x_1]$], [$f[x_1,x_1]$], [$f[x_0,x_1,x_1]$], [$f[x_0,x_0,x_1,x_1]$],
))

Partendo dall'ultima colonna, abbiamo che:
$
  f[x_0,x_0,x_1,x_1] = frac(f[x_0,x_1,x_1]-f[x_0,x_0,x_1], x_1-x_0)
$
Passando alla penultima colonna:
$
  & f[x_0,x_0,x_1] = frac(f[x_0,x_1]-f[x_0,x_0], x_1-x_0) \
  & f[x_0,x_1,x_1] = frac(f[x_1,x_1]-f[x_0,x_1], x_1-x_0)
$
Infine, nella seconda colonna:
$
  & f[x_0,x_0] = ? \
  & f[x_0,x_1] = frac(f[x_1]-f[x_0], x_1-x_0) \
  & f[x_1,x_1] = ?
$
In conclusione, qualunque sia il numero di nodi considerato, facendo collassare i punti si genera un problema nel calcolo delle differenze divise: la valutazione del termine $f[x_i, x_i]$ per $i=0,dots,n$.

Tuttavia, per definizione stessa di differenza divisa (che è un rapporto incrementale), quando i due nodi tendono a coincidere, il limite corrisponde esattamente alla derivata prima della funzione:
$
  f[x_i,x_i] = lim_(h->0) f[x_i+h, x_i] = lim_(h->0) frac(f[x_i+h, x_i]-f[x_i], h) = lim_(h->0) frac(f(x_i+h)-f(x_i), h) = f'(x_i)
$
E poiché stiamo parlando di interpolazione di Hermite, $f'(x_i)$ è un dato che ci viene fornito dal problema.
A questo punto, possiamo formulare un algoritmo modificato per calcolare la tabella delle differenze divise e costruire la forma di Newton del polinomio di Hermite. Necessitiamo di due vettori di lunghezza $2n+2$, strutturati in modo da "raddoppiare" i nodi:
$
  x & = [x_0, x_0, x_1, x_1, dots, x_n, x_n] quad quad f & = [f_0, f'_0, f_1, f'_1, dots, f_n, f'_n]
$
Ricordiamo che, operando in place sul vettore $f$, la prima colonna delle differenze divise non va calcolata sulle posizioni pari (che contengono già le derivate $f'_i$, ossia i termini $f[x_i, x_i]$), altrimenti si sprecherebbero valutazioni funzionali e si dividerebbe per zero. L'algoritmo calcola solo i termini "incrociati" tra nodi distinti.

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: none,
)
```matlab
% Colonna 1: Calcola f[x_i, x_{i-1}] saltando le derivate
for i = 2*n+1:-2:3
  f(i) = (f(i) - f(i-2)) / (x(i) - x(i-1));
end

% Colonne successive: Calcolo standard della tabella
for j = 2:2*n+1
  for i = 2*n+2:-1:j+1
    f(i) = (f(i) - f(i-1)) / (x(i) - x(i-j));
  end
end
```

Vediamo ora come valutare in modo efficiente il polinomio $p(x)$ e la sua derivata prima $p'(x)$ una volta che abbiamo i coefficienti nella base di Newton.
Chiameremo `p` l'accumulatore per il polinomio e `p1` l'accumulatore per la derivata:
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: none,
)
```matlab
p1 = 0;
p = a(n+1);
for i = n:-1:1
    p1 = p1 * (x - xi(i)) + p;
    p  = p  * (x - xi(i)) + a(i);
end
```
Alla fine dell'esecuzione, la variabile `p` conterrà il valore esatto di $p(x)$, mentre `p1` conterrà il valore esatto della sua derivata prima $p'(x)$, il tutto al costo di pochissime operazioni aggiuntive.

=== Forma di Lagrange del polinomio interpolante di Hermite
Consideriamo un insieme di ascisse nell'intervallo $[a,b]$:
$
  a <= x_0 < x_1 < dots < x_n <= b
$
Siano assegnati i valori della funzione $f_i = f(x_i)$ e delle sue derivate prime $f'_i = f'(x_i)$ per $i=0,dots,n$.
Come abbiamo visto, il nostro obiettivo è trovare l'unico polinomio $p_H (x) in Pi_(2n+1)$ tale che:
$
  cases(
    p_H (x_i) = f_i,
    p'_H (x_i) = f'_i
  ) quad quad i=0,dots,n
$
Vediamo come costruire questo polinomio in modo esplicito utilizzando un approccio analogo a quello di Lagrange. A tal fine, richiamiamo i classici polinomi di base di Lagrange di grado $n$:
$
  L_("in") (x) = product_(j=0\ j != i)^n frac(x-x_j, x_i-x_j) quad quad i=0,dots,n
$
che godono della proprietà del delta di Kronecker:
$
  L_("in") (x_k) = delta_(i k) = cases(1\, i=k, 0\, i eq.not k)
$
Per soddisfare contemporaneamente le condizioni sui valori e sulle derivate, dobbiamo costruire una "doppia base" di polinomi di grado $2n+1$. Definiamo quindi due nuove famiglie di polinomi:
<4.19>
$
  cases(
    Phi_(i n) (x) = L_("in")^2 (x) [1 - 2(x-x_i) L'_("in") (x_i)],
    Psi_(i n) (x) = (x-x_i) L_("in")^2 (x)
  ) quad quad i=0,dots,n quad quad (4.19)
$

Valgono le seguenti proprietà:
#theorem()[
  I polinomi definiti nella #link(<4.19>)[(4.19)] separano l'influenza dei valori della funzione da quella delle derivate, godendo delle seguenti proprietà per ogni generico nodo $x_j$:
  $
    cases(
      Phi_(i n) (x_j) = delta_(i j)\,,
      Phi'_("in") (x_j) = 0
    ) quad quad "e" quad quad
    cases(
      Psi_(i n) (x_j) = 0\,,
      Psi'_("in") (x_j) = delta_(i j)
    )
  $
]
Grazie a queste proprietà, possiamo scrivere il polinomio interpolante di Hermite come combinazione lineare di questa doppia base, pesata rispettivamente con i valori $f_i$ e le derivate $f'_i$:
<4.20>
$
  p_H (x) = sum_(i=0)^n [ f_i Phi_(i n) (x) + f'_i Psi_(i n) (x) ] quad quad (4.20)
$
Per verificare che la (4.20) sia effettivamente il polinomio cercato, è sufficiente valutarla in un nodo $x_j$.

+ *Valutazione della funzione:*
  $
    p_H (x_j) = sum_(i=0)^n [f_i Phi_(i n) (x_j) + f'_i Psi_(i n) (x_j)]
  $
  Per il teorema precedente, in $x_j$ tutti i termini $Psi$ si annullano ($Psi_(i n) (x_j)=0$). Tra i termini $Phi$, l'unico a non annullarsi è quello con $i=j$ (dove   vale $1$). Pertanto, l'intera sommatoria collassa al solo termine $j$-esimo:
  $ p_H (x_j) = f_j $

+ *Valutazione della derivata:*
  Derivando la (4.20) membro a membro e valutandola in $x_j$ otteniamo:
  $
    p'_H (x_j) = sum_(i=0)^n [f_i Phi'_("in") (x_j) + f'_i Psi'_("in") (x_j)]
  $
  Stavolta, sono i termini $Phi'$ ad annullarsi identicamente in corrispondenza del   nodo ($Phi'_("in")(x_j)=0$). Tra i termini $Psi'$, l'unico che sopravvive è quello  con $i=j$ (dove vale $1$). La sommatoria collassa a:
  $ p'_H (x_j) = f'_j $

Entrambe le condizioni del sistema di partenza sono state verificate. L'equazione (4.20) rappresenta, in modo costruttivo, la forma di Lagrange del polinomio interpolante di Hermite.


//18.03.2026
== Condizionamento del problema
Se $f$ ha derivate uniformemente limitate ($exists M > 0: abs(f^((n+1))(x)) lt.eq M, space forall x in [a,b])$, allora $forall x in [a,b]$:
$
  abs(e(x)) lt.eq M frac(abs(omega_(n+1) (x)), (n+1)!) lt.eq M frac((b-a)^(n+1), (n+1)!) --> 0 " per " n --> infinity
$
Pertanto, in questo caso, ci aspettiamo che al crescere del numero delle ascisse di interpolazione, la famiglia di polinomi interpolanti $f(x)$ su tali ascisse, converga uniformemente alla funzione interpolanda.
Se però andiamo ad approssimare $f(x)$ "buona" sul calcolatore, possiamo avere qualche sorpresa.

#example()[
  Consideriamo la seguente funzione, nota come *funzione di Runge*:
  $
    f(x) = frac(1, 1+x^2), space x in [-5,5]
  $
  - $f(x)=f(-x) gt.eq 0$ ovvero simmetrica rispetto all'asse $x=0$.
  - $f(x) -> 0, space x->plus.minus infinity$
  - $f(0)=1 equiv max_(x in RR) f(x)$

  #figure(
    canvas({
      import draw: content
      plot.plot(
        size: (10, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: 0,
        y-max: 1.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    }),
  )
  Per approssimarla, consideriamo $n+1$ ascisse equidistanti in $[-5,5]$, $n$ pari, in modo che 0 sia una delle ascisse di interpolazione:
  $
    x_i = -5 + i/n 10, space i=0,dots,n
  $
  #observation()[
    Se avessimo un generico intervallo $[a,b]$, avremmo:
    $
      x_i = a + (b-a)/n
    $
  ]

  #align(center, grid(
    align: (col, row) => center + horizon,
    rows: 2,
    columns: 2,
    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: 0,
        y-max: 1.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_2 = (
            (-5, 0.0384615),
            (0, 1),
            (5, 0.0384615),
          )
          let poly_2 = x => (
            -0.0384615 * calc.pow(x, 2) + 1
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_2, domain: (-6, 6), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_2, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),
    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: -.25,
        y-max: 1.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_5 = (
            (-5, 0.0384615),
            (-3, 0.1),
            (-1, 0.5),
            (1, 0.5),
            (3, 0.1),
            (5, 0.0384615),
          )
          let poly_5 = x => (
            0.00192308 * calc.pow(x, 4) - 0.0692308 * calc.pow(x, 2) + 0.567308
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_5, domain: (-6, 6), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_5, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),

    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: -1.25,
        y-max: 3.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_10 = (
            (-5, 0.0384615),
            (-4, 0.0588235),
            (-3, 0.1),
            (-2, 0.2),
            (-1, 0.5),
            (0, 1),
            (1, 0.5),
            (2, 0.2),
            (3, 0.1),
            (4, 0.0588235),
            (5, 0.0384615),
          )
          let poly_10 = x => (
            -0.0000226244 * calc.pow(x, 10)
              + 0.00126697 * calc.pow(x, 8)
              - 0.0244118 * calc.pow(x, 6)
              + 0.197376 * calc.pow(x, 4)
              - 0.674208 * calc.pow(x, 2)
              + 1
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_10, domain: (-6, 6), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_10, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),
    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: -1.25,
        y-max: 5.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_18 = (
            (-5, 0.0384615),
            (-4.44444, 0.0481856),
            (-3.88889, 0.0620214),
            (-3.33333, 0.0825688),
            (-2.77778, 0.114731),
            (-2.22222, 0.168399),
            (-1.66667, 0.264706),
            (-1.11111, 0.447514),
            (-0.555556, 0.764151),
            (0, 1),
            (0.555556, 0.764151),
            (1.11111, 0.447514),
            (1.66667, 0.264706),
            (2.22222, 0.168399),
            (2.77778, 0.114731),
            (3.33333, 0.0825688),
            (3.88889, 0.0620214),
            (4.44444, 0.0481856),
            (5, 0.0384615),
          )
          let poly_18 = x => (
            -1.65986e-08 * calc.pow(x, 18)
              + 1.47666e-06 * calc.pow(x, 16)
              - 5.35702e-05 * calc.pow(x, 14)
              + 0.0010293 * calc.pow(x, 12)
              - 0.0114138 * calc.pow(x, 10)
              + 0.0749912 * calc.pow(x, 8)
              - 0.291487 * calc.pow(x, 6)
              + 0.667313 * calc.pow(x, 4)
              - 0.944449 * calc.pow(x, 2)
              + 1
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_18, domain: (-6, 6), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_18, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),
  ))

  Si osserva come all'aumentare di $n$, agli estremi della funzione, la funzione interpolante oscilla assumendo valori molto distanti da quelli della funzione interpolata.
]

Quanto osservato è legato al *condizionamento del problema*.

Assegnate le ascisse di interpolazione $x_0, x_1, dots, x_n$, vogliamo valutare la sensibilità del risultato alle variazioni dei dati. Posto che:
+ $p(x)$ è il polinomio che interpola la funzione esatta $f(x)$ su tali ascisse;
+ $tilde(p)(x)$ è il polinomio che interpola una funzione $tilde(f)(x)$ sulle stesse ascisse, dove $tilde(f)(x)$ rappresenta una perturbazione della funzione originaria $f(x)$;
vogliamo scoprire come la differenza sui dati iniziali, $f(x) - tilde(f)(x)$, influisca sulla differenza finale tra i polinomi, $p(x) - tilde(p)(x)$.

Per misurare rigorosamente queste differenze (ovvero la "distanza" tra due funzioni), introduciamo la norma del massimo nello spazio vettoriale $C[a,b]$ delle funzioni continue sull'intervallo chiuso e limitato $[a,b]$:
<4.21>
$
  forall g in C[a,b]: quad norm(g)_oo = max_(a <= x <= b) abs(g(x)) quad quad (4.21)
$
#observation(multiple: true)[
  + La definizione #link(<4.21>)[(4.21)] è ben posta. Infatti, se $g in C[a,b]$, allora anche il suo valore assoluto $|g|$ appartiene a $C[a,b]$ (è una funzione continua). Per il teorema di Weierstrass, una funzione continua definita su un intervallo compatto ammette sempre un massimo assoluto; pertanto l'estremo superiore è un massimo effettivo e l'operatore $max$ ha senso.
  + L'operatore #link(<4.21>)[(4.21)] definisce effettivamente una norma nello spazio $C[a,b]$, poiché ne rispetta tutti e tre gli assiomi fondamentali:
    - $norm(g)_oo >= 0$, e $norm(g)_oo = 0 <=> g(x) equiv 0$;
    - $forall alpha in RR, quad norm(alpha g)_oo = abs(alpha) dot norm(g)_oo$;
    - $forall f, g in C[a,b], quad norm(f+g)_oo <= norm(f)_oo + norm(g)_oo$.
]
Ricordiamo che lo studio del condizionamento di un problema si fa in aritmetica esatta. Di conseguenza, potremo considerare una qualunque forma del polinomio interpolante poiché tra loro algebricamente equivalenti. Risulta conveniente, ai fini di questa analisi, l'utilizzo della forma di Lagrange di $p(x)$ e $tilde(p)(x)$. Quindi:
<4.22>

$
  & p(x) = sum_(i=0)^n f(x_i) L_("in")(x) quad quad (4.22) \
  & tilde(p)(x) = sum_(i=0)^n tilde(f)(x_i) L_("in")(x) quad quad (4.23)
$
<4.23>

dove, ricordiamo, $L_("in")(x) = product_(j=0\ j eq.not i)^n frac(x-x_j, x_i - x_j), space i = 0,dots,n$.

Infatti, nelle #link(<4.22>)[(4.22)] e #link(<4.23>)[(4.23)] il ruolo di $f(x)$ e $tilde(f)(x)$ è facilmente identificabile. Sottraendo, membro a membro la #link(<4.23>)[(4.23)] dalla #link(<4.22>)[(4.22)], otteniamo:
$
  p(x) - tilde(p)(x) = sum_(i=0)^n (f(x_i)-tilde(f)(x_i)) L_("in") (x)
$
Passando ai valori assoluti:
$
  abs(p(x) - tilde(p)(x)) & = abs(sum_(i=0)^n (f(x_i)-tilde(f)(x_i)) L_("in")(x)) \
                          & lt.eq sum_(i=0)^n abs(L_("in")(x)) dot abs(f(x_i)-tilde(f)(x_i)) \
                          & lt.eq norm(f-tilde(f)) dot sum_(i=0)^n abs(L_("in")(x)) \
                          & equiv norm(f-tilde(f)) dot lambda_n (x)
$
dove $lambda_n (x)$ è detta *funzione di Lebesgue* (ləbɛɡ).

#observation()[
  $lambda_n gt.eq 0, forall x in [a,b]$ e dipende solo dalla scelta delle ascisse di interpolazione.
]

Ricapitolando, abbiamo ottenuto che:
$
  forall x in [a,b] : abs(p(x)-tilde(p)(x)) lt.eq lambda_n (x) dot norm(f -tilde(f))
$

Se consideriamo, infine, il massimo, per $x in [a,b]$, di ciascun membro della diseguaglianza:
$
  max_(x in [a,b]) [p(x)-tilde(p)(x)] lt.eq max_(x in [a,b]) [lambda_n (x)] dot max_(x in [a,b]) [f -tilde(f)] \
  norm(p-tilde(p)) lt.eq Lambda_n dot norm(f-tilde(f))
$
con $Lambda_n$ detta *costante di Lebesgue*. La conclusione della nostra analisi è quindi che:
<4.24>
$
  norm(p-tilde(p)) lt.eq Lambda_n dot norm(f-tilde(f)) quad quad (4.24)
$

#observation()[
  Nella (4.24):
  - $norm(f-tilde(f))$ è una misura della perturbazione del dato in ingresso;
  - $norm(p-tilde(p))$ è una misura della perturbazione sul risultato finale;
  - $Lambda_n$ è il fattore che misura di quanto l'errore sui dati in ingresso si può amplificare sul risultato finale;
]

La costante di Lebesgue $Lambda_n$ definisce il numero di condizionamento del problema dell'interpolazione polinomiale. Esaminiamo le sue proprietà fondamentali:

+ La costante è definita come $Lambda_n = norm(lambda_n (x))$. La funzione di Lebesgue $lambda_n (x)$ dipende solo ed esclusivamente dalla scelta e dalla distribuzione delle ascisse di interpolazione $x_0, dots, x_n$, e non dalla funzione che si sta interpolando.

+ La costante dipende dalla *distribuzione* delle ascisse in $[a,b]$, ma non dallo specifico intervallo in sé.
  Possiamo dimostrarlo mappando l'intervallo $[a,b]$ sull'intervallo standard $[0,1]$. Qualsiasi punto $x in [a,b]$ può essere scritto come $x = a + c(b-a)$ con $c in [0,1]$.
  Di conseguenza, le ascisse diventano $x_i = a + c_i (b-a)$ per $i = 0, dots, n$.
  Sapendo che $lambda_n (x) = sum_(i=0)^n abs(L_("in")(x))$, calcoliamo il polinomio base di Lagrange:

  $
    L_("in")(x) & = L_("in")(a+c(b-a)) \
                & = product_(j=0, j eq.not i)^n frac([a+c(b-a)] - [a+c_j (b-a)], [a+c_i (b-a)] - [a+c_j (b-a)]) \
                & = product_(j=0, j eq.not i)^n frac((c-c_j)(b-a), (c_i-c_j)(b-a)) \
                & = product_(j=0, j eq.not i)^n frac(c-c_j, c_i-c_j) equiv hat(L)_("in")(c)
  $

  Come si nota, i termini $(b-a)$ si semplificano, dimostrando che la dipendenza dagli estremi $a$ e $b$ si annulla.

+ Per qualsiasi scelta possibile delle ascisse, la costante di Lebesgue ha un limite inferiore di crescita. Per $n arrow oo$:
  $ Lambda_n gt.eq O(ln(n)) $
  Le distribuzioni di ascisse ottimali (come le ascisse di Chebyshev) si avvicinano a questo andamento logaritmico, garantendo la massima stabilità possibile.

+ Se si sceglie di utilizzare ascisse perfettamente equidistanti, la stabilità crolla. Per $n gt.eq 1$, l'andamento diventa:
  $ Lambda_n approx 2^n $
  Questa rapida crescita esponenziale, anziché logaritmica, amplifica enormemente l'errore sui dati ed è la causa dei risultati ottenuti nell'esempio della funzione di Runge.

//19.03.2026
== Ascisse di Chebyshev
Poiché l'intervallo $[a,b]$ non è influente, fissiamo, in questo caso, l'intervallo $[-1,1]$. Dalla #link(<4.15>)[(4.15)] otteniamo la limitazione dell'errore:
<4.25>
$
  norm(e) lt.eq frac(norm(f^((n+1))), (n+1)!) norm(omega_(n+1)) quad quad (4.25)
$
Nella #link(<4.25>)[(4.25)] osserviamo che l'unica quantità che dipende dalla scelta delle ascisse di interpolazione è $norm(omega_(n+1))$. Pertanto, è lecito ricercare le ascisse di interpolazione (che per definizione sono le radici del polinomio $omega_(n+1)(x)$) che minimizzano tale norma. In altri termini, ricerchiamo le ascisse $-1 lt.eq x_0 < x_1 < dots < x_n lt.eq 1$ che sono soluzione del seguente problema di min-max:
<4.26>
$
  min_(-1 lt.eq x_0 < x_1 < dots < x_n lt.eq 1) space max_(-1 lt.eq x lt.eq 1) abs(omega_(n+1)(x)) quad quad (4.26)
$

Ricordiamo che:
$
  omega_(n+1)(x) = product_(i=0)^n (x-x_i) in Pi'_(n+1) = {"insieme dei polinomi monici di grado" n+1}
$

Per risolvere il problema di minimizzazione #link(<4.26>)[(4.26)], introduciamo la famiglia dei *polinomi di Chebyshev di prima specie*, definiti tramite la seguente relazione di ricorrenza:
<4.27>
$
  (4.27) quad quad cases(
    T_0 (x) equiv 1,
    T_1 (x) = x,
    T_(k+1) (x) = 2x T_k (x) - T_(k-1)(x)\, quad "per" k gt.eq 1
  )
$
#example()[
  Calcoliamo i primi polinomi successivi:
  $
    T_2 (x) & = 2x T_1 (x) - T_0 (x) = 2x(x) - 1 = 2x^2 - 1 \
    T_3 (x) & = 2x T_2 (x) - T_1 (x) = 2x(2x^2 - 1) - x = 4x^3 - 2x - x = 4x^3 - 3x
  $
]
Esaminiamo alcune proprietà salienti dei polinomi $T_k (x)$ per $k gt.eq 0$:

#heading(numbering: none, depth: 3, "Proprietà 1.", outlined: false)
$T_k (x)$ è un polinomio di grado esatto $k$, per ogni $k gt.eq 0$. (Si dimostra facilmente per induzione).

#heading(numbering: none, depth: 3, "Proprietà 2.", outlined: false)
Il coefficiente principale di $T_k (x)$ è:
$
  cases(
    1 & "se" k = 0,
    2^(k-1) & "se" k gt.eq 1
  )
$
(Anche questa proprietà si dimostra per induzione).

#heading(numbering: none, depth: 3, "Proprietà 3.", outlined: false)
Dalle due proprietà precedenti discende che la famiglia di polinomi:
$
  hat(T)_k (x) = cases(
    T_0 (x) & "se" k = 0,
    2^(1-k) T_k (x) & "se" k gt.eq 1
  )
$
è una famiglia di polinomi *monici* di grado $k$, per ogni $k gt.eq 0$.

#observation()[
  Per ogni $k gt.eq 1$, i polinomi $T_k (x)$ e $hat(T)_k (x)$ hanno esattamente le stesse radici, poiché differiscono solo per una costante moltiplicativa non nulla: $hat(T)_k (x) = 2^(1-k) T_k (x)$.
]

#heading(numbering: none, depth: 3, "Proprietà 4.", outlined: false)
Poiché stiamo lavorando in $x in [-1, 1]$, possiamo operare la sostituzione $x = cos(theta)$ con $theta in [0, pi]$. In questo caso, si ottiene che:
<4.28>
$
  (4.28) quad quad T_k (x) = T_k (cos(theta)) = cos(k theta), space forall k gt.eq 0
$
#proof()[
  Dimostriamo per induzione:
  - *Caso base ($k=0$)*: $T_0(x) equiv 1 = cos(0 dot theta)$.
  - *Caso base ($k=1$)*: $T_1(x) = x = cos(theta)$

  Supponiamo ora vera la tesi fino a $k$ e dimostriamola per $k+1$:
  $
    T_(k+1)(x) & = T_(k+1)(cos(theta)) \
               & = 2x T_k (x) - T_(k-1)(x) \
               & = 2 cos(theta) cos(k theta) - cos((k-1) theta) \
               & = 2 cos(theta) cos(k theta) - [cos(k theta) cos(theta) + sin(k theta) sin(theta)] \
               & = cos(k theta) cos(theta) - sin(k theta) sin(theta) \
               & = cos((k+1) theta)
  $
]

Dalla #link(<4.28>)[(4.28)] discendono immediatamente le seguenti due proprietà:

#heading(numbering: none, depth: 3, "Proprietà 5.", outlined: false)
$
  norm(T_k) = max_(-1 lt.eq x lt.eq 1) abs(T_k (x)) = max_(0 lt.eq theta lt.eq pi) abs(cos(k theta)) = 1, space forall k gt.eq 0
$

#heading(numbering: none, depth: 3, "Proprietà 6.", outlined: false)
Per ogni $k gt.eq 1$, la norma del polinomio monico associato è:
$ norm(hat(T)_k) = norm(2^(1-k) T_k) = 2^(1-k) norm(T_k) = 2^(1-k) $
Inoltre:
<4.29>
$
  (4.29) quad quad norm(hat(T)_k) = 2^(1-k) = min_(p in Pi'_k) max_(-1 lt.eq x lt.eq 1) abs(p(x))
$
Ovvero, $hat(T)_k (x)$ è il polinomio monico di grado $k$ che possiede la minima norma sull'intervallo $[-1, 1]$.

#observation()[
  Dalla #link(<4.29>)[(4.29)] discende un fatto cruciale: se scegliamo come ascisse di interpolazione le radici reali e distinte di $T_(n+1)(x)$, allora il nostro polinomio diventerà esattamente $omega_(n+1)(x) := hat(T)_(n+1)(x)$. Questa scelta è la soluzione ottimale del problema di min-max #link(<4.26>)[(4.26)].
]
Quest'ultimo requisito è dato dalla seguente proprietà.

#heading(numbering: none, depth: 3, "Proprietà 7.", outlined: false)
Le radici di $T_(n+1)(x)$ sono $n+1$ radici reali e distinte in $[-1,1]$, date da:
<4.30>
$
  x_(n-i) = cos(frac(2i+1, 2n+2) pi), space i=0,dots,n quad quad (4.30)
$
#proof()[
  Infatti, imponendo l'annullamento del polinomio:
  $
    & T_(n+1)(x) = 0 \
    & <=> T_(n+1)(cos(theta)) = 0 \
    & <=> cos((n+1)theta) = 0 \
    & => (n+1)theta = pi/2 + i pi \
    & => theta_i = frac(2i+1, n+1) pi/2 = frac(2i+1, 2n+2) pi, quad i=0, dots, n
  $
  Poiché richiediamo $theta in [0, pi]$ e ricordando la sostituzione $x = cos(theta)$, otteniamo esattamente le radici cercate nella #link(<4.30>)[(4.30)].
]

//Cosa da sapere per l'esonero e orale!
#definition()[
  Le ascisse #link(<4.30>)[(4.30)] sono dette *ascisse di Chebyshev*.
]
#observation()[
  Le ascisse #link(<4.30>)[(4.30)] sono $n+1$ e servono a definire il polinomio interpolante di grado $n$ su tali ascisse.
]

In conclusione, se utilizziamo le #link(<4.30>)[(4.30)] come ascisse di interpolazione, il polinomio $omega$ coincide con il polinomio monico di Chebyshev: $omega_(n+1)(x) equiv hat(T)_(n+1)(x)$.
Dalla limitazione dell'errore #link(<4.23>)[(4.23)], ricordando che $norm(omega_(n+1)) = 2^(-n)$, segue che:
$
  norm(e) lt.eq frac(norm(f^((n+1))), (n+1)!) dot norm(omega_(n+1)) => norm(e) lt.eq frac(norm(f^((n+1))), (n+1)! dot 2^n)
$
Inoltre, con questa specifica scelta delle ascisse, si può dimostrare che la costante di Lebesgue cresce con andamento:
$ Lambda_n approx 2/pi log(n) $
garantendo così una stabilità (condizionamento) praticamente ottimale per il problema dell'interpolazione.

#observation()[
  Se invece di operare sull'intervallo $[-1,1]$, abbiamo necessità di interpolare su un generico intervallo $[a,b]$, osservando che la trasformazione:
  $
    x = frac(a+b, 2) + frac(b-a, 2) xi, space xi in [-1,1]
  $
  trasforma $[-1, 1]$ in $[a,b]$, otteniamo che le ascisse #link(<4.30>)[(4.30)] si trasformano in:
  <4.31>
  $
    (4.31) quad quad x_(n-i) = (a+b)/2 + (b-a)/2 dot cos(frac(2i+1, 2n+2) pi), space i=0,dots,n
  $
]

#example()[
  Se consideriamo nuovamente la funzione di Runge:
  $
    f(x) = 1/(1+x^2), space x in [-5,5]
  $
  ora le cose vanno bene, scegliendo le ascisse come in (4.30).
  #align(center, grid(
    rows: 2,
    columns: 2,
    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: -0.25,
        y-max: 1.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_2 = (
            (-4.33013, 0.0506329),
            (3.06162e-16, 1),
            (4.33013, 0.0506329),
          )
          let poly_2 = x => (
            -0.0506329 * calc.pow(x, 2) + 1
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_2, domain: (-5, 5), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_2, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),
    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: -0.25,
        y-max: 1.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_5 = (
            (-4.82963, 0.0411094),
            (-3.53553, 0.0740741),
            (-1.2941, 0.373876),
            (1.2941, 0.373876),
            (3.53553, 0.0740741),
            (4.82963, 0.0411094),
          )
          let poly_5 = x => (
            0.00113851 * calc.pow(x, 4) - 0.0438325 * calc.pow(x, 2) + 0.444089
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_5, domain: (-5, 5), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_5, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),

    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: -0.25,
        y-max: 1.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_10 = (
            (-4.94911, 0.0392254),
            (-4.54816, 0.0461132),
            (-3.77875, 0.0654496),
            (-2.7032, 0.120376),
            (-1.40866, 0.335083),
            (1.41638e-15, 1),
            (1.40866, 0.335083),
            (2.7032, 0.120376),
            (3.77875, 0.0654496),
            (4.54816, 0.0461132),
            (4.94911, 0.0392254),
          )
          let poly_10 = x => (
            -4.77521e-06 * calc.pow(x, 10)
              + 0.000333071 * calc.pow(x, 8)
              - 0.00854046 * calc.pow(x, 6)
              + 0.0983088 * calc.pow(x, 4)
              - 0.49906 * calc.pow(x, 2)
              + 1
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_10, domain: (-5, 5), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_10, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),
    figure(canvas({
      import draw: content
      plot.plot(
        size: (5, 5),
        x-tick-step: 1,
        y-tick-step: 1,
        y-min: -0.25,
        y-max: 1.25,
        plot-style: (stroke: black),
        min: 0,
        {
          let func = x => 1 / (1 + calc.pow(x, 2))
          let nodes_18 = (
            (-4.98292, 0.0387154),
            (-4.847, 0.0408273),
            (-4.57887, 0.0455249),
            (-4.18583, 0.0539922),
            (-3.67862, 0.0688125),
            (-3.07106, 0.0958641),
            (-2.37974, 0.150079),
            (-1.6235, 0.275047),
            (-0.822973, 0.596202),
            (3.06162e-16, 1),
            (0.822973, 0.596202),
            (1.6235, 0.275047),
            (2.37974, 0.150079),
            (3.07106, 0.0958641),
            (3.67862, 0.0688125),
            (4.18583, 0.0539922),
            (4.57887, 0.0455249),
            (4.847, 0.0408273),
            (4.98292, 0.0387154),
          )
          let poly_18 = x => (
            -6.30751e-10 * calc.pow(x, 18)
              + 7.55324e-08 * calc.pow(x, 16)
              - 3.82062e-06 * calc.pow(x, 14)
              + 0.000106225 * calc.pow(x, 12)
              - 0.0017703 * calc.pow(x, 10)
              + 0.0181139 * calc.pow(x, 8)
              - 0.112404 * calc.pow(x, 6)
              + 0.40706 * calc.pow(x, 4)
              - 0.825606 * calc.pow(x, 2)
              + 1
          )

          plot.add(func, domain: (-5, 5), style: (stroke: blue), samples: 100)
          plot.add(poly_18, domain: (-5, 5), style: (stroke: (paint: red, dash: "dashed")), samples: 100)

          plot.add(nodes_18, style: (stroke: none), mark: "o")

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-6, -5, -3, -1, 1, 3, 5, 6, min: -0.01, max: 0.01)
        },
      )
    })),
  ))
]

//25.03.2026
Ricapitolando:
$
  Lambda_n = norm(lambda_n (x)), quad lambda_n (x) = sum_(i=0)^n abs(L_("in") (x))
$

- $Lambda_n gt.eq O(log(n))$
- $Lambda_n gt.eq 2^n$ (ascisse equidistanti)
- $Lambda_n gt.eq 2/pi log(n)$ (ascisse di Chebyshev)

Se andiamo ad utilizzare queste ascisse per approssimare la funzione di Runge, allora possiamo valutare quale delle due forme del polinomio interpolante dia un migliore "performance" quando utilizziamo la doppia precisione IEEE di Matlab. Per stimare l'errore di approssimazione, al crescere di $n$ ($n$ pari) calcoliamo:
$
  norm(e_n) = norm(f-p_n) approx max_(i=0,dots,10^4) abs(f(xi_i) - p(xi_i))
$
con $xi_i = -5 + frac(i dot 10, 10^4) = -5 + frac(i, 10^3), i=0,dots,10^4$.

Se grafichiamo $norm(e_n)$ rispetto al grado $n$ del polinomio interpolante, otteniamo quanto segue:

#align(center)[
  #canvas({
    import draw: *

    // 1. Setup Canvas Dimensions
    let width = 10
    let height = 6

    // 2. Draw the outer bounding box
    rect((0, 0), (width, height), stroke: black + 0.5pt)

    // Helper functions to map data to canvas space
    // X goes from 0 to 200
    // Y (log10) goes from -16 to 1 (17 decades)
    let map-x(x) = (x / 200) * width
    let map-y(y) = ((y + 16) / 17) * height

    // 3. X-axis ticks & labels
    for i in range(11) {
      let x = i * 20
      let cx = map-x(x)
      line((cx, 0), (cx, 0.15), stroke: black + 0.5pt)
      line((cx, height), (cx, height - 0.15), stroke: black + 0.5pt)
      content((cx, -0.4), text(size: 8pt)[#str(x)])
    }

    // 4. Y-axis Major Ticks (every 2 decades)
    for i in range(9) {
      let y = -16 + i * 2
      let cy = map-y(y)
      line((0, cy), (0.15, cy), stroke: black + 0.5pt)
      line((width, cy), (width - 0.15, cy), stroke: black + 0.5pt)
      content((-0.6, cy), text(size: 8pt)[$10^#y$])
    }

    // 5. Y-axis Minor Ticks (Logarithmic spacing)
    for decade in range(-16, 1) {
      for j in range(2, 10) {
        let y = decade + calc.log(j, base: 10)
        if y <= 1 {
          let cy = map-y(y)
          line((0, cy), (0.07, cy), stroke: black + 0.3pt)
          line((width, cy), (width - 0.07, cy), stroke: black + 0.3pt)
        }
      }
    }

    // 6. Axis Titles
    content((width / 2, -0.9), [$n$])
    content((-1.4, height / 2), [$||e_n||$], angle: 90deg)

    // 7. Generate Data
    let lagrange-pts = ()
    let newton-pts = ()

    // Colors matching default MATLAB styles
    let blue-color = rgb("#0072BD")
    let orange-color = rgb("#D95319")

    for i in range(100) {
      let n = i * 2

      // Lagrange curve: linear descent in log-space until it hits the floor
      let log-l = calc.max(-0.08125 * n, -14.3)

      // Simulate machine precision noise floor
      if log-l <= -14.3 {
        log-l = -14.3 + 0.08 * calc.sin(n * 50deg) + 0.04 * calc.cos(n * 130deg)
      }
      lagrange-pts.push((map-x(n), map-y(log-l)))

      // Newton curve: follows Lagrange initially, then diverges exponentially
      let log-n = log-l
      if n > 44 {
        log-n = -0.08125 * 44 + 0.25 * (n - 44)
      }

      // Only plot points that fit within the bounding box
      if log-n <= 0.9 {
        newton-pts.push((map-x(n), map-y(log-n)))
      }
    }

    // 8. Draw Line Strips
    line(..lagrange-pts, stroke: blue-color + 0.7pt)
    line(..newton-pts, stroke: orange-color + 0.7pt)

    // 9. Draw Circular Markers (with white fill to overlap lines)
    for pt in lagrange-pts {
      circle(pt, radius: 0.06, fill: white, stroke: blue-color + 0.7pt)
    }
    for pt in newton-pts {
      circle(pt, radius: 0.06, fill: white, stroke: orange-color + 0.7pt)
    }

    // 10. Draw Legend
    let leg-x = width - 2.5
    let leg-y = height - 0.2
    let leg-w = 2.3
    let leg-h = 0.9

    rect((leg-x, leg-y), (leg-x + leg-w, leg-y - leg-h), stroke: black + 0.3pt, fill: white)

    // Legend entry: Lagrange
    line((leg-x + 0.2, leg-y - 0.35), (leg-x + 0.7, leg-y - 0.35), stroke: blue-color + 0.7pt)
    circle((leg-x + 0.45, leg-y - 0.35), radius: 0.06, fill: white, stroke: blue-color + 0.7pt)
    content((leg-x + 1.4, leg-y - 0.35), text(size: 8pt)[Lagrange])

    // Legend entry: Newton
    line((leg-x + 0.2, leg-y - 0.65), (leg-x + 0.7, leg-y - 0.65), stroke: orange-color + 0.7pt)
    circle((leg-x + 0.45, leg-y - 0.65), radius: 0.06, fill: white, stroke: orange-color + 0.7pt)
    content((leg-x + 1.35, leg-y - 0.65), text(size: 8pt)[Newton])
  })
]

Pertanto, possiamo concludere che se sono necessari polinomi di grado elevato, per approssimare una funzione, è necessario, in primis, utilizzare ascisse che diano una crescita ottimale del condizionamento del problema (ad esempio, le ascisse di Chebyshev). In secondo luogo, si osserva che la forma di Lagrange ha un andamento più favorevole, riguardo alla propagazione degli errori di round-off, ovvero legati all'utilizzo dell'aritmetica finita.

#observation()[
  Supponiamo di scegliere le ascisse di interpolazione in modo opportuno (ovvero in modo che $Lambda_n$ cresca in modo ottimale, ad esempio usando le ascisse di Chebyshev). In generale, l'errore di interpolazione può essere espresso in modo esatto tramite le differenze divise:
  $ e_n (x) = f[x_0, dots, x_n, x] overbrace(omega_(n+1)(x), product_(i=0)^n (x-x_i)) $
  Se la funzione è sufficientemente regolare, ovvero se $f in C^((n+1))[a,b]$, questa espressione coincide con la forma classica basata sulla derivata:
  $ e_n (x) = frac(f^((n+1))(xi_x), (n+1)!) omega_(n+1)(x) $
]

#observation()[
  Se $f$ non ha una regolarità molto elevata (ad esempio, le sue derivate di ordine superiore non esistono o presentano discontinuità), non possiamo usare la stima basata su $f^((n+1))$. Dobbiamo quindi limitarci a maggiorare l'espressione con le differenze divise:
  $
    norm(e_n) & lt.eq norm(f[x_0, dots, x_n, dot]) dot norm(omega_(n+1)) \
              & lt.eq norm(f[x_0, dots, x_n, dot]) dot (b-a)^(n+1)
  $
  L'ultimo passaggio è giustificato dal fatto che la distanza massima tra due punti qualsiasi in $[a,b]$ è proprio $(b-a)$, pertanto il prodotto di $n+1$ di questi termini non può superare $(b-a)^(n+1)$.
]

Dall'ultima disuguaglianza emerge un fatto cruciale: se vogliamo che l'errore decresca mantenendo il grado $n$ fissato (e possibilmente basso), l'unica strategia a nostra disposizione è diminuire l'ampiezza dell'intervallo $(b-a)$.

Questo approccio "locale", che consiste nel suddividere l'intervallo di base in tanti piccoli sotto-intervalli su cui applicare polinomi di grado basso, è esattamente l'idea alla base dell'interpolazione mediante *funzioni spline*.

== Interpolazione mediante funzioni spline

Assegnata una *partizione* dell'intervallo $[a,b]$:
<4.32>
$
  Delta = {a=x_0 < x_1 < x_2 < dots < x_n = b} quad quad (4.32)
$

#observation(multiple: true)[
  1. Poiché $Delta$ è una partizione di $[a,b]$, essa individua *$n$ sottointervalli*:
    $
      [x_(i-1), x_i], space i=1,dots,n
    $
    a due a due contigui.
  2. Il punto di contiguità tra $[x_(i-1), x_i]$ e $[x_i, x_(i+1)]$ è $x_i, space i=1,dots,n-1$.
]

Ciò premesso, diamo la seguente definizione.
#definition()[
  Diremo che $S_m (x)$ è una (funzione) *spline di grado $m$ sulla partizione $Delta$* (definita in #link(<4.32>)[(4.32)]), se soddisfa le seguenti due proprietà:
  + $S_m |_([x_(i-1), x_i]) (x) in Pi_m, quad forall i=1, dots, n$
  + $S_m (x) in C^((m-1))[a,b]$
]

#observation()[
  + $forall i=1,dots,n-1 space space forall j =0,dots,m-1: S_m^((j)) bar_[x_(i-1), x_i] (x_i) = S_m^((j)) bar_[x_i, x_(i+1)] (x_i)$. Ovvero, nei punti interni, le spline e le loro derivate, si raccordano perfettamente.
  + Un polinomio di grado $m$ è una spline di grado $m$. In generale, l'inverso non vale.
]

#definition()[
  Una spline di grado $m$ sulla partizione $Delta$ definita in #link(<4.32>, [(4.32)]), si dirà interpolante una funzione $f:[a,b]->RR$ se:
  <4.33>
  $
    S_m (x_i) = f(x_i), space i=0,dots,n quad quad (4.33)
  $
]

Il problema che ora ci poniamo è quello di stabilire se le $n+1$ condizioni di interpolazione #link(<4.33>, [(4.33)]) siano sufficienti ad individuare la spline interpolante di grado $m$ cercata. Per rispondere a questo, introduciamo l'insieme:
<4.34>
$
  cal(L)_m (Delta) = {S_m (x): "spline di grado" m "su" Delta} quad quad (4.34)
$
Osserviamo che:
$
  forall alpha, beta in RR, space forall S_m (x), hat(S)_m (x) in cal(L)_m (Delta)
$
abbiamo che:
$
  alpha dot S_m (x) + beta dot hat(S)_m (x) in cal(L)_m (Delta)
$
Pertanto, $cal(L)_m (Delta)$ *è uno spazio vettoriale*. A riguardo, si osserva il seguente risultato:

#theorem()[
  $cal(L)_m (Delta)$, definito come in (4.34), è uno spazio vettoriale di dimensione $m+n$.
]

#observation()[
  Una spline di grado 2 è detta *quadratica*, una di grado 3 è detta *cubica*, ecc.
]

#corollary()[
  Le $n+1$ condizioni di interpolazione #link(<4.33>, [(4.33)]) permettono di calcolare univocamente solo la spline interpolante di grado 1 (spline lineare).
]

#observation()[
  Se $S_m (x)$ è una spline di grado $m > 1$ sulla partizione $Delta$, allora $S'_m(x)$ è una spline di grado $m-1$ su $Delta$.

  #proof()[
    Dalla definizione di spline, sappiamo che:
    + $S_m (x)$ ristretta a ogni sotto-intervallo $[x_(i-1), x_i]$ è un polinomio di grado $m$. Derivando un polinomio di grado $m$, si ottiene banalmente un polinomio di grado $m-1$.
    + Globalmente, la spline richiede una regolarità $S_m (x) in C^((m-1))[a,b]$. Se deriviamo l'intera funzione, il grado di continuità "scala" di uno, ottenendo $S'_m (x) in C^((m-2))[a,b]$.
    Queste due condizioni soddisfano la definizione di una spline di grado $m-1$.
  ]

  #figure(canvas({
    import draw: *

    // 2. Axes (Blue)
    line((0, 0), (10, 0), mark: (end: ">"))
    line((0, 0), (0, 5), mark: (end: ">"))

    // 3. Define the data points
    let p0 = (1.0, 2.0)
    let p1 = (3.0, 4.0)
    let p2 = (5.5, 3.0)
    let p3 = (8.5, 4.0)

    // 4. Draw the linear spline connecting the points (Green)
    line(p0, p1, p2, p3, stroke: rgb("#008a5e") + 1.5pt)

    // 5. Draw the scatter points (Red)
    let r = 0.08
    circle(p0, radius: r, fill: red, stroke: none)
    circle(p1, radius: r, fill: red, stroke: none)
    circle(p2, radius: r, fill: red, stroke: none)
    circle(p3, radius: r, fill: red, stroke: none)

    // 6. X-axis tick marks and labels (Red)
    let tick-y = -0.15
    let label-y = -0.5

    line((p0.at(0), 0), (p0.at(0), tick-y))
    content((p0.at(0), label-y), [$x_0$])

    line((p1.at(0), 0), (p1.at(0), tick-y))
    content((p1.at(0), label-y), [$x_1$])

    line((p2.at(0), 0), (p2.at(0), tick-y))
    content((p2.at(0), label-y), [$x_2$])

    line((p3.at(0), 0), (p3.at(0), tick-y))
    content((p3.at(0), label-y), [$x_3$])

    // 7. Point coordinate labels (Black)
    content((p0.at(0) + 0.7, p0.at(1) - 0.5), [$(x_0, f_0)$])
    content((p1.at(0) + 0.6, p1.at(1) + 0.5), [$(x_1, f_1)$])
    content((p2.at(0) - 0.1, p2.at(1) - 0.6), [$(x_2, f_2)$])
    content((p3.at(0) + 0.8, p3.at(1) - 0.2), [$(x_3, f_3)$])

    // 8. Annotations
    // "n = 3" in the top right
    content((9.2, 5.5), text(fill: black, weight: "bold")[$n=3$])
  }))

  Da questi concetti si deduce che la spline lineare interpolante sui nodi $(x_i, f_i)$ per $i=0, dots, n$ non è altro che la *spezzata che unisce i punti consecutivi*.

  Essendo l'intervallo totale frammentato, possiamo scrivere l'espressione di $S_1(x)$ ristretta al generico sotto-intervallo $[x_(i-1), x_i]$ come la retta passante per due punti (di fatto, il polinomio interpolante di Lagrange di grado 1 su quel pezzetto):
  $
    S_1(x) = frac(f_i (x - x_(i-1)) + f_(i-1) (x_i - x), x_i - x_(i-1)), quad forall x in [x_(i-1), x_i], quad forall i=1, dots, n
  $
]

//26.03.2026
== Spline cubiche
Al fine di ottenere spline interpolanti che si raccordino in maniera "smooth" nei punti di interpolazione, occorre utilizzare spline di grado più elevato. Tra queste, le più utilizzate sono le *spline cubiche* ($m=3$). In questo caso, per individuare univocamente una spline cubica interpolante una data funzione su $Delta$, *occorrono $n+3$ condizioni*. Di queste condizioni, $n+1$ sono le condizioni di interpolazione:
<4.35>
$
  S_3 (x_i) = f_i, space i=0,dots,n quad quad (4.35)
$
Rimangono quindi da imporre 2 ulteriori condizioni: ciascuna scelta di queste condizioni, darà origine ad una spline cubica interpolante *diversa*. Vediamo le scelte più comuni.

=== Spline cubica naturale
In questo caso, le due ulteriori condizioni, sono :
<4.36>
$
  S''_3 (a)=0, space S''_3 (b) = 0, quad quad (a=x_0, b=x_n) quad quad (4.36)
$

=== Spline cubica completa
In questo caso, se sono note $f'(a)$ e $f'(b)$, le condizioni aggiuntive sono:
<4.37>
$
  S'_3 (a) = f'(a), space S'_3 (b)=f'(b) quad quad (4.37)
$

=== Spline cubica periodica
Questa particolare classe di spline ha senso nel momento in cui la funzione $f(x)$ da approssimare è una funzione periodica sull'intervallo $[a,b]$.

Generalizzando, se $f(x)$ è una generica funzione periodica in $[a,b]$ con regolarità $C^2[a,b]$, avremo in particolare che la funzione e le sue prime due derivate coincidono ai bordi dell'intervallo:
<4.38>
$
  f^((j)) (a) = f^((j)) (b), space j=0,1,2, quad quad (4.38)
$
Pertanto, la condizione:
$
  S_3 (a) = S_3(b)
$
deriva già dalle condizioni di interpolazione. Tuttavia, per determinare univocamente tutti i coefficienti della spline cubica, ci mancano ancora due equazioni. Per ottenere una spline periodica, attingiamo alla #link(<4.38>, [(4.38)]) e imponiamo che anche le derivate prima e seconda "si saldino" perfettamente agli estremi dell'intervallo. Le due condizioni aggiuntive diventano pertanto:
<4.39>
$
  S'_3 (a) = S'_3 (b) quad quad S''_3 (a) = S''_3 (b) quad quad (4.39)
$
#observation()[
  Una spline cubica periodica fornisce un'approssimazione qualitativa estremamente fedele della funzione originale perché ne preserva la natura ciclica.
]

=== Spline not-a-knot
La spline *not-a-knot* (implementazione di default in Matlab) è costruita in modo da non richiedere parametri aggiuntivi dall'esterno. Le due equazioni mancanti per risolvere il sistema vengono trovate tramite un trucco geometrico: si impone che i primi due sottointervalli siano descritti dallo *stesso identico polinomio*, e si fa lo stesso per gli ultimi due.

Matematicamente, il tratto della spline deve essere un unico polinomio cubico sulle unioni degli intervalli:
$
  [x_0, x_1] union [x_1, x_2] quad quad "e" quad quad [x_(n-2), x_(n-1)] union [x_(n-1), x_n]
$

Per definizione di spline cubica (regolarità $C^2$), sappiamo già che in qualsiasi nodo interno, la funzione e le sue prime due derivate coincidono. Nel nodo $x_1$ vale quindi:
<4.40>
$
  S_3^((j)) |_[x_0, x_1] (x_1) = S_3^((j)) |_[x_1, x_2] (x_1), quad quad "per" j=0,1,2 quad quad (4.40)
$

Affinché i due polinomi adiacenti diventino matematicamente *indistinguibili* (collassando in un'unica curva da $x_0$ a $x_2$), dobbiamo forzare l'uguaglianza anche della *derivata terza* nel punto di giunzione:
<4.41>
$
  S_3^((3)) |_[x_0, x_1] (x_1) = S_3^((3)) |_[x_1, x_2] (x_1) quad quad (4.41)
$

Poiché in una spline cubica la derivata terza è una costante su ogni singolo intervallo, possiamo calcolarla in modo esatto come il rapporto incrementale della derivata seconda (che è lineare). La condizione si traduce quindi nella seguente equazione:
<4.42>
$
  frac(S''_3 (x_1) - S''_3 (x_0), x_1 - x_0) = frac(S''_3 (x_2) - S''_3 (x_1), x_2 - x_1) quad quad (4.42)
$

Applicando esattamente lo stesso ragionamento per simmetria sull'altro estremo, forziamo la continuità della derivata terza nell'ascissa $x_(n-1)$. Otteniamo così la seconda equazione mancante:
<4.43>
$
  frac(S''_3 (x_(n-1)) - S''_3 (x_(n-2)), x_(n-1) - x_(n-2)) = frac(S''_3 (x_n) - S''_3 (x_(n-1)), x_n - x_(n-1)) quad quad (4.43)
$

== Calcolo di una spline cubica
Al fine di ottenere un algoritmo efficiente per il calcolo di un a spline cubica interpolante, dobbiamo esaminare un modo efficiente per risolvere un *sistema linare tri-diagonale*. Si tratta di risolvere il sistema lineare:
<4.44>
$
  A uu(x) = uu(z), quad uu(x) = mat(x_1; dots.v; x_n), quad uu(z) = mat(z_1; dots.v; z_n) quad quad (4.44)
$
che rappresentano rispettivamente il vettore delle incognite e quello dei termini noti, mentre la matrice dei coefficienti è tridiagonale:
<4.45>
$
  A = mat(
    a_1, c_1, , , ;
    b_2, a_2, c_2, , ;
    , b_3, a_3, c_3, ;
    , , dots.down, dots.down, dots.down;
    , , , b_(n-1), a_(n-1), c_(n-1);
    , , , , b_n, a_n; delim: "["
  ) in RR^(n times n) quad quad (4.45)
$
in cui $b_i, a_i, c_i$ sono rispettivamente gli elementi della sottodiagonale, diagonale principale e sopradiagonale sulla riga $i$-esima. Per memorizzare $A$ necessitiamo solo di 3 vettori che contengono gli elementi di queste 3 diagonali.

#observation()[
  $A$ è un esempio di matrice *sparsa*, ovvero una matrice in cui il numero di elementi non nulli è proporzionale a $n$ (la dimensione di $A$), invece che scalare come $n^2$ (il numero totale di elementi di una generica matrice densa $n times n$).
]

Nel seguito, supporremo che la matrice $A$ in #link(<4.45>, [(4.45)]) sia fattorizzabile $L U$ (ad esempio, perché è a diagonale strettamente dominante). In questo caso, cerchiamo la scomposizione $A = L U$ con:
$
  L=mat(
    1, , , ;
    l_2, 1, , ;
    , l_3, 1, ;
    , , dots.down, 1; delim: "["
  ) quad quad U = mat(
    d_1, c_1, , ;
    , d_2, c_2, ;
    , , dots.down, c_(n-1);
    , , , d_n; delim: "["
  )
$

Si tratta, dunque, di derivare l'espressione degli $l_i$ e dei $d_i$. Esaminiamo, per semplicità, il caso $n=3$:
$
  mat(1, 0, 0; l_2, 1, 0; 0, l_3, 1; delim: "[")mat(d_1, c_1, 0; 0, d_2, c_2; 0, 0, d_3; delim: "[") = mat(d_1, c_1, 0; l_2 d_1, d_2 + l_2 c_1, c_2; 0, l_3 d_2, l_3 c_2 + d_3; delim: "[", augment: #(vline: (1, 2), stroke: (dash: "dotted", thickness: 0.4pt))) equiv mat(a_1, c_1, 0; b_2, a_2, c_2; 0, b_3, a_3; delim: "[")
$
Uguagliando i termini omologhi, otteniamo le formule generali:
$
  cases(
    d_1 = a_1,
    l_i = b_i / d_(i-1)\, quad i=2\, 3\, dots \, n,
    d_i = a_i - l_i c_(i-1)\, quad i=2\, 3\, dots \, n
  )
$

#observation(multiple: true)[
  + A livello di implementazione, possiamo sovrascrivere i vettori $uu(b)$ e $uu(a)$ rispettivamente con $uu(l)$ e $uu(d)$ (mentre $uu(c)$ rimane invariato per risparmiare memoria).
  + Il costo computazionale della fattorizzazione è di $approx 3n$ `flops`.
]

Vediamo come risolvere i sistemi triangolari derivanti dalla fattorizzazione: $L uu(y) = uu(z)$ e $U uu(x) = uu(y)$.
$
  (a) quad cases(
    y_1 = z_1,
    y_i = z_i - l_i y_(i-1)\, quad i=2\, dots \, n
  ) quad quad
  (b) quad cases(
    x_n = y_n / d_n,
    x_i = (y_i - c_i dot x_(i+1)) / d_i \, quad i=n-1\, dots \, 1
  )
$

#observation(multiple: true)[
  + Nel sistema (a), il processo (forward substitution) richiede $2n$ `flops`. Inoltre, possiamo sovrascrivere $uu(z)$ con $uu(y)$.
  + Nel sistema (b), il processo (backward substitution) richiede $3n$ `flops`. Possiamo sovrascrivere $uu(y)$ con $uu(x)$.
]

In conclusione, per risolvere il sistema tridiagonale #link(<4.44>, [(4.44)])) occorrono quattro vettori di lunghezza $n$ e un totale di $8n$ `flops`. Pertanto, la complessità computazionale è *strettamente lineare* ($O(n)$).

//01.04.2026
Nel seguito occorrerà individuare i valori della derivata seconda di $S_3 (x)$ nei nodi della partizione $Delta$. Denotiamo tali valori incogniti con:
<4.46>
$
  m_i = S''_3 (x_i), space i=0,dots,n quad quad (4.46)
$
Per una *spline cubica naturale* avremo banalmente le condizioni ai bordi:
<4.47>
$
  m_0 = m_n = 0 quad quad (4.47)
$

Invece, per una *spline cubica not-a-knot*, imponendo la continuità della derivata terza $S'''_3(x)$ sui primi e ultimi due intervalli, avremo:
$
  cases(frac(m_1 - m_0, h_1) = frac(m_2 - m_1, h_2), frac(m_(n-1) - m_(n-2), h_(n-1)) = frac(m_(n) - m_(n-1), h_(n)))
$
che riorganizzato diventa:
<4.48>
$
  cases(
    m_1 (h_1 + h_2) = m_2 h_1 + m_0 h_2,
    m_(n-1)(h_(n-1) + h_(n)) = m_(n-2) h_n + m_n h_(n-1)
  ) quad quad (4.48)
$

Ricordiamo che se $S_3 (x)$ è una spline cubica su $Delta$, allora $S'_3 (x)$ è una spline quadratica su $Delta$ mentre $S''_3 (x)$ è una spline lineare su $Delta$. Pertanto possiamo esprimere quest'ultima sul generico sotto-intervallo come l'interpolante lineare dei valori $m_(i-1)$ ed $m_i$:
<4.49>
$
  (4.49) quad quad S''_3 (x) = frac(m_i (x - x_(i-1) ) + m_(i-1) (x_i - x), h_i), space x in [x_(i-1), x_i], space i=1,dots,n
$
Ovvero, $S''_3(x)$ è univocamente determinata una volta che i valori incogniti $m_i$ definiti in #link(<4.46>, [(4.46)]) siano noti.


Vediamo come ricavare la spline partendo da questa informazione. Integrando membro a membro la #link(<4.49>, [(4.49)]), otteniamo:
<4.50>
$
  (4.50) quad quad S'_3(x) = frac(m_i (x - x_(i-1))^2 - m_(i-1) (x_i - x)^2, 2 h_i) + q_i, space i=1,dots,n
$
essendo $q_i$ una costante di integrazione.

Se integriamo nuovamente, otteniamo l'equazione della spline cubica sul sotto-intervallo $[x_(i-1), x_i]$:
<4.51>
$
  (4.51) quad quad S_(3) = frac(m_i (x-x_(i-1))^3 - m_(i-1)(x_i - x)^3, 6 h_i) + q_i (x-x_(i-1)) + r_i, space i=1,dots,n
$
essendo $r_i$ una ulteriore costante di integrazione.

Imponendo le condizioni di interpolazione nei nodi $x_(i-1)$ e $x_i$, ricaviamo le costanti. Da $S_3(x_(i-1)) = f_(i-1)$ otteniamo:
$
  f_(i-1) = - m_(i-1) frac(h_i^2, 6) + r_i
$
Da cui:
<4.52>
$
  r_i = f_(i-1) + m_(i-1) frac(h_i^2, 6) quad quad (4.52)
$

Similmente, da $S_3(x_i) = f_i$:
$
  f_i = m_i frac(h_i^2, 6) + q_i h_i + r_i
$
Sostituendo $r_i$ e isolando $q_i$ otteniamo:
$
  q_i & = frac(f_i, h_i) - m_i frac(h_i, 6) - frac(r_i, h_i) \
      & = frac(f_i, h_i) - m_i frac(h_i, 6) - frac(f_(i-1), h_i) + m_(i-1) frac(h_i, 6) \
      & = frac(f_i - f_(i-1), h_i) - frac(h_i, 6) (m_i - m_(i-1))
$
Riconoscendo la differenza divisa $f[x_(i-1), x_i]$, si ha:
<4.53>
$
  q_i = f[x_(i-1), x_i] - frac(h_i, 6) (m_i - m_(i-1)), quad i=1, dots, n quad quad (4.53)
$

#observation(multiple: true)[
  + Dalle #link(<4.51>, [(4.51)])-#link(<4.53>, [(4.53)]) possiamo concludere che, se conoscessimo i valori dei ${m_0, dots, m_n}$, conosceremmo l'intera spline cubica interpolante.
  + Nell'intervallo $[x_(i-1), x_i]$ della partizione, si utilizza unicamente informazione *locale* per il calcolo di $S_3(x)$.
]

Per determinare gli $n+1$ valori incogniti $m_i$, sfruttiamo la proprietà di regolarità globale della spline: imponiamo che $S_3(x) in C^2[a,b]$. Poiché abbiamo già costruito i "rami" garantendo la continuità di $S_3$ e $S''_3$, ci basta imporre la continuità della derivata prima nei nodi interni:
<4.54>
$
  (4.54) quad quad S'_3 |_([x_(i-1), x_i]) (x_i) = S'_3 |_([x_i, x_(i+1)]) (x_i), quad i=1, dots, n-1
$
Queste $n-1$ condizioni, unite alle #link(<4.47>, [(4.47)]), permetteranno di ottenere la *spline cubica naturale*. Se invece delle #link(<4.47>, [(4.47)]) si considerano le #link(<4.48>, [(4.48)]), otterremo la *spline cubica not-a-knot*.

Riscriviamo le $n-1$ condizioni #link(<4.54>, [(4.54)]) tenendo conto della #link(<4.50>, [(4.50)]) e della #link(<4.53>, [(4.53)]):
$
  m_i frac(h_i, 2) + q_i = - m_i frac(h_(i+1), 2) + q_(i+1)
$
Sostituendo i valori di $q$:
$
  m_i frac(h_i, 2) + f[x_(i-1), x_i] - frac(h_i, 6) (m_i - m_(i-1)) = - m_i frac(h_(i+1), 2) + f[x_i, x_(i+1)] - frac(h_(i+1), 6) (m_(i+1) - m_i)\ space i=1,dots,n-1
$
Raggruppando i termini con le incognite $m$ a sinistra:
$
  m_(i-1) frac(h_i, 6) + m_i [frac(h_i, 2) - frac(h_i, 6) + frac(h_(i+1), 2) - frac(h_(i+1), 6)] + m_(i+1) frac(h_(i+1), 6) = f[x_i, x_(i+1)] - f[x_(i-1), x_i]
$
Semplificando il termine centrale per $m_i$:
$
  m_(i-1) frac(h_i, 6) + m_i frac(2(h_i + h_(i+1)), 6) + m_(i+1) frac(h_(i+1), 6) = f[x_i, x_(i+1)] - f[x_(i-1), x_i]
$
Moltiplicando tutto per 6 e dividendo per $(h_i + h_(i+1)) = x_(i+1) - x_(i-1)$, otteniamo la forma canonica:
$
  m_(i-1) underbracket(frac(h_i, h_i + h_(i+1)), phi_i) + 2 m_i + m_(i+1) underbracket(frac(h_(i+1), h_i + h_(i+1)), xi_i) = 6 frac(f[x_i, x_(i+1)] - f[x_(i-1), x_i], x_(i+1) - x_(i-1))
$
Ovvero, definendo appropriatamente i coefficienti $phi_i$ e $\xi_i$ e riconoscendo a destra la differenza divisa del secondo ordine:
<4.55>
$
  phi_i m_(i-1) + 2 m_i + xi_i m_(i+1) = 6 f[x_(i-1), x_i, x_(i+1)], quad i=1, dots, n-1 quad quad (4.55)
$

Le #link(<4.55>, [(4.55)]) sono la riformulazione algebrica delle #link(<4.54>, [(4.54)]), che costituiscono un sistema lineare di $n-1$ equazioni in $n+1$ incognite.


#heading(numbering: none, depth: 3, "Spline Cubica Naturale", outlined: false)
Ora, nel caso di una spline cubica naturale, $m_0 = m_n = 0$ e pertanto le incognite diventano $n-1$. Quindi le #link(<4.55>, [(4.55)]) individuano univocamente le rimanenti incognite $m_1, dots, m_(n-1)$, che riscriviamo in forma vettoriale come:
$
  mat(
    2, xi_1;
    phi_2, 2, xi_2;
    , phi_3, 2, xi_3;
    , , dots.down, dots.down, dots.down;
    , , , dots.down, dots.down, dots.down;
    , , , , dots.down, dots.down, dots.down;
    , , , , , phi_(n-2), 2, xi_(n-2);
    , , , , , , phi_(n-1), 2; delim: "[", augment: #(vline: (1, 2, 3, 4, 5, 6, 7), stroke: (dash: "dotted", thickness: 0.4pt))
  ) dot mat(m_1; m_2; m_3; dots.v; dots.v; dots.v; m_(n-2); m_(n-1)) = 6 dot mat(f[x_0,x_1,x_2]; f[x_1,x_2,x_3]; f[x_2,x_3,x_4]; dots.v; dots.v; dots.v; f[x_(n-3),x_(n-2),x_(n-1)]; f[x_(n-2),x_(n-1),x_n];)
$
Abbiamo quindi un sistema lineare tridiagonale di $n-1$ equazioni in $n-1$ incognite. Sulla riga i-esima, i coefficienti diversi da zero sono:
- $phi_i arrow$ sottodiagonale
- $2 arrow$ diagonale principale
- $xi_i arrow$ sopradiagonale
che ricordiamo essere definiti come:
$
  phi_i = frac(h_i, h_i + h_(i+1)) > 0\
  xi_i = frac(h_i, h_i + h_(i+1)) > 0 \
  phi_i + xi_i = 1
$
Poiché sulla diagonale principale abbiamo il valore 2, ed esso è strettamente maggiore della somma dei valori assoluti degli altri elementi sulla riga ($|phi_i| + |xi_i| = 1$), la matrice dei coefficienti è *strettamente diagonale dominante per righe*. Pertanto, essa ammette sempre fattorizzazione $L U$ senza pivoting con complessità computazionale lineare.

//09.04.2026
#heading(numbering: none, depth: 3, "Spline Cubica Not-A-Knot", outlined: false)
Nel caso di una *spline not-a-knot*, le equazioni si completano con le condizioni agli estremi viste in precedenza #link(<4.48>, [(4.48)]):
<4.56>
$
  (4.56) quad quad & m_0 xi_1 - m_1 + m_2 phi_1 = 0, \
                   & xi_(n-1) m_(m-2)-m_(n-1)+m_n phi_(n-1) = 0
$
Scriviamo in forma vettoriale #link(<4.55>, [(4.55)]) + #link(<4.47>, [(4.47)]):
$
  mat(
    xi_1, -1, phi_1;
    phi_1, 2, xi_1;
    , phi_2, 2, xi_2;
    , , dots.down, dots.down, dots.down;
    , , , dots.down, dots.down, dots.down;
    , , , , dots.down, dots.down, dots.down;
    , , , , , phi_(n-1), 2, xi_(n-1);
    , , , , , xi_(n-1), -1, phi_(n-1); delim: "[", augment: #(vline: (1, 2, 3, 4, 5, 6, 7), stroke: (dash: "dotted", thickness: 0.4pt))
  ) dot mat(m_0; m_1; m_2; dots.v; dots.v; dots.v; m_(n-1); m_n) = 6 dot mat(0; f[x_0,x_1,x_2]; f[x_1,x_2,x_3]; dots.v; dots.v; dots.v; f[x_(n-2),x_(n-1),x_(n)]; 0)
$
Per riportare anche questo problema alla risoluzione efficiente di un sistema tridiagonale $(n-1) times (n-1)$, si procede con delle manipolazioni riga/colonna.
Sostituendo la prima riga con la somma delle prime due, e l'ultima con la somma delle ultime due, si ottiene:
$
  mat(
    1, 1, 1;
    phi_1, 2, xi_1;
    , phi_2, 2, xi_2;
    , , dots.down, dots.down, dots.down;
    , , , dots.down, dots.down, dots.down;
    , , , , dots.down, dots.down, dots.down;
    , , , , , phi_(n-1), 2, xi_(n-1);
    , , , , , 1, 1, 1; delim: "[", augment: #(vline: (1, 2, 3, 4, 5, 6, 7), stroke: (dash: "dotted", thickness: 0.4pt))
  ) dot mat(m_0; m_1; m_2; dots.v; dots.v; dots.v; m_(n-1); m_(n)) = 6 dot mat(f[x_0,x_1,x_2]; f[x_0,x_1,x_2]; f[x_1,x_2,x_3]; dots.v; dots.v; dots.v; f[x_(n-2),x_(n-1),x_(n)]; f[x_(n-2),x_(n-1),x_(n)])
$
sistema lineare che indichiamo con:
<4.57>
$
  A uu(m) = uu(f) quad quad (4.57)
$
Sottraendo la prima colonna dalla seconda e dalla terza, si ottiene:
$
  mat(
    1, 1, 1;
    phi_1, 2, xi_1;
    , phi_2, 2, xi_2;
    , , dots.down, dots.down, dots.down;
    , , , dots.down, dots.down, dots.down;
    , , , , dots.down, dots.down, dots.down;
    , , , , , phi_(n-1), 2, xi_(n-1);
    , , , , , 1, 1, 1; delim: "[", augment: #(vline: (1, 2, 3, 4, 5, 6, 7), stroke: (dash: "dotted", thickness: 0.4pt))
  )
  -->
  mat(
    1, 0, 0;
    phi_1, (2-phi_1), (xi_1-phi_1);
    , phi_2, 2, xi_2;
    , , dots.down, dots.down, dots.down;
    , , , dots.down, dots.down, dots.down;
    , , , , dots.down, dots.down, dots.down;
    , , , , , phi_(n-1), 2, xi_(n-1);
    , , , , , 1, 1, 1; delim: "[", augment: #(vline: (1, 2, 3, 4, 5, 6, 7), stroke: (dash: "dotted", thickness: 0.4pt))
  )
$
Similmente, se sottraiamo l'ultima colonna dalla penultima e dalla terzultima, otteniamo:
$
  mat(
    1, 0, 0;
    phi_1, (2-phi_1), (xi_1-phi_1);
    , phi_2, 2, xi_2;
    , , dots.down, dots.down, dots.down;
    , , , dots.down, dots.down, dots.down;
    , , , , phi_(n-2), 2, xi_(n-2);
    , , , , , (phi_(n-1)-xi_(n-1)), (2-xi_(n-1)), xi_(n-1);
    , , , , , 0, 0, 1;
    delim: "[", augment: #(vline: (1, 2, 3, 4, 5, 6, 7), stroke: (dash: "dotted", thickness: 0.4pt))
  ) equiv B
$
Algebricamente, abbiamo che:
$
  B = A dot F equiv A dot mat(
    1, -1, -1;
    , 1, ;
    , , 1, ;
    , , , dots.down, ;
    , , , , dots.down, , ;
    , , , , , dots.down, , ;
    , , , , , , 1, ;
    , , , , , -1, -1, 1; delim: "["
  )
$
Pertanto abbiamo che #link(<4.57>, [(4.57)]) è equivalente a:
$
  overbrace(A dot \( F, =B) dot F^(-1)) uu(m) = f <=> B dot (F^(-1) uu(m)) = uu(f)
$
Su può verificare, ma non lo faremo, che:
$
  F^(-1) = mat(
    1, 1, 1;
    , 1, ;
    , , 1, ;
    , , , dots.down, ;
    , , , , dots.down, , ;
    , , , , , dots.down, , ;
    , , , , , , 1, ;
    , , , , , 1, 1, 1; delim: "["
  )
$
Pertanto:
$
  F^(-1) uu(m) = mat(
    m_0 + m_1 +m_2;
    m_1;
    dots.v;
    dots.v;
    m_(n-1);
    m_(n-2) + m_(n-1) + m_n
  )
$
In conclusione, il sistema lineare #link(<4.57>, [(4.57)]) si può riscrivere come:
$
  B dot (F^(-1) uu(m)) = uu(f)\
  mat(
    1, 0, 0, ;
    phi_1, (2-phi_1), (xi_1-phi_1);
    , phi_2, 2, xi_2;
    , , dots.down, dots.down, dots.down;
    , , , dots.down, dots.down, dots.down;
    , , , , phi_(n-2), 2, xi_(n-2);
    , , , , , (phi_(n-1)-xi_(n-1)), (2-xi_(n-1)), xi_(n-1);
    , , , , , 0, 0, 1;
    delim: "[", augment: #(vline: (1, 2, 3, 4, 5, 6, 7), stroke: (dash: "dotted", thickness: 0.4pt))
  ) dot mat(m_0 + m_1 + m_2; m_1; m_2; dots.v; dots.v; m_n; m_(n-2) + m_(n-1) + m_1) = 6 mat(f[x_0,x_1,x_2]; f[x_0,x_1,x_2]; dots.v; dots.v; f[x_(n-2), x_(n-1), x_n]; f[x_(n-2), x_(n-1), x_n])
$

Dalla prima e ultima equazione del nuovo sistema si ricavano direttamente i bordi:
<4.58>
$
  m_0 + m_1 + m_2 = 6 f[x_0, x_1, x_2] quad quad (4.58)\
  m_(n-2) + m_(n-1) + m_n = 6 f[x_(n-2), x_(n-1), x_n] quad quad (4.59)
$
<4.59>
Le altre componenti, si ottengono risolvendo il sistema lineare tridiagonale e a diagonale dominante per righe:
$
  mat(
    (2-phi_1), (xi_1-phi_1);
    phi_2, 2, xi_2;
    , dots.down, dots.down, dots.down;
    , , dots.down, dots.down, dots.down;
    , , , phi_(n-2), 2, xi_(n-2);
    , , , , (phi_(n-1)-xi_(n-1)), (2-xi_(n-1));
    delim: "[", augment: #(vline: (1, 2, 3, 4, 5), stroke: (dash: "dotted", thickness: 0.4pt))
  ) dot mat(m_1; m_2; dots.v; dots.v; dots.v; m_(n-1)) = 6 mat(xi_1 f[x_0,x_1,x_2]; f[x_1,x_2,x_3]; dots.v; dots.v; f[x_(n-3), x_(n-2), x_(n-1)]; phi_(n-1) f[x_(n-2), x_(n-1), x_n])
$
Risolto questo, $m_0$ e $m_n$ si ottengono per differenza della #link(<4.58>, [(4.58)]) e #link(<4.59>, [(4.59)]), rispettivamente.



== Approssimazione polinomiale ai minimi quadrati
#let ok_interpolation(width, height) = figure(
  canvas({
    import draw: *

    rect((0, 0), (width, height), stroke: black + 0.5pt)

    let map-x(x) = (x + 1) / 2 * width
    let map-y(y) = (y + 1) / 2 * height

    // 3. Draw ticks and labels
    for i in range(11) {
      let v = -1 + i * 0.2

      // X-axis ticks & labels
      let cx = map-x(v)
      line((cx, 0), (cx, 0.1), stroke: black + 0.5pt)
      line((cx, height), (cx, height - 0.1), stroke: black + 0.5pt)
      content((cx, -0.4), text(size: 8pt)[#str(calc.round(v, digits: 1))])

      // Y-axis ticks & labels
      let cy = map-y(v)
      line((0, cy), (0.1, cy), stroke: black + 0.5pt)
      line((width, cy), (width - 0.1, cy), stroke: black + 0.5pt)
      content((-0.5, cy), text(size: 8pt)[#str(calc.round(v, digits: 1))])
    }

    // 4. Axis Titles
    content((width / 2, -1), [*x*])
    content((-1.2, height / 2), [*y*], angle: 90deg)

    // 5. Generate and draw trend lines (Cubic function simulation)
    let pts-black = ()
    let pts-red = ()
    for i in range(101) {
      let x = -1 + i * 0.02
      let y-base = x * x * x * 0.8 - x * 0.1
      pts-black.push((map-x(x), map-y(y-base)))

      pts-red.push((map-x(x), map-y(y-base + 0.015 * calc.sin(x * 15))))
    }

    // Draw the generated line-strips
    line(..pts-black, stroke: black + 1pt)
    line(..pts-red, stroke: red + 1pt)

    let rng = gen-rng-f(42)
    let v = ()

    for i in range(700) {
      (rng, v) = uniform-f(rng, low: -1.0, high: 1.0, size: 2)

      let x = v.at(0)
      let noise = v.at(1) * 0.25
      let y = x * x * x * 0.8 - x * 0.1 + noise

      if y >= -1 and y <= 1 {
        circle((map-x(x), map-y(y)), radius: 0.02, fill: rgb("1f77b4"), stroke: none)
      }
    }
  }),
)

#let bad_interpolation(width, height) = figure(canvas({
  import draw: *

  // 2. Draw the outer bounding box
  rect((0, 0), (width, height), stroke: black + 0.5pt)

  // Helper functions to map data space [-1, 1] to canvas space
  let map-x(x) = (x + 1) / 2 * width
  let map-y(y) = (y + 1) / 2 * height

  // 3. Draw ticks and labels
  for i in range(11) {
    let v = -1 + i * 0.2

    // X-axis ticks & labels
    let cx = map-x(v)
    line((cx, 0), (cx, 0.1), stroke: black + 0.5pt)
    line((cx, height), (cx, height - 0.1), stroke: black + 0.5pt)
    content((cx, -0.4), text(size: 8pt)[#str(calc.round(v, digits: 1))])

    // Y-axis ticks & labels
    let cy = map-y(v)
    line((0, cy), (0.1, cy), stroke: black + 0.5pt)
    line((width, cy), (width - 0.1, cy), stroke: black + 0.5pt)
    content((-0.5, cy), text(size: 8pt)[#str(calc.round(v, digits: 1))])
  }

  // 4. Axis Titles
  content((width / 2, -1), [*x*])
  content((-1.2, height / 2), [*y*], angle: 90deg)

  // 5. Generate data points using suiji
  let rng = gen-rng-f(42)
  let v = ()
  let raw-pts = ()

  for i in range(700) {
    // Generate uniform random floats between -1.0 and 1.0
    (rng, v) = uniform-f(rng, low: -1.0, high: 1.0, size: 2)

    let x = v.at(0)
    let noise = v.at(1) * 0.25
    let y = x * x * x * 0.8 - x * 0.1 + noise

    // Clamp y to stay within bounds
    if y >= -1 and y <= 1 {
      raw-pts.push((x, y))
    }
  }

  // 6. Sort points by X-coordinate to draw the continuous jagged line correctly
  let sorted-pts = raw-pts.sorted(key: pt => pt.at(0))
  let mapped-pts = sorted-pts.map(pt => (map-x(pt.at(0)), map-y(pt.at(1))))

  // 7. Draw the jagged red line connecting all points
  line(..mapped-pts, stroke: red + 0.5pt)

  // 8. Draw the blue scatter points on top
  for pt in mapped-pts {
    circle(pt, radius: 0.025, fill: blue, stroke: none)
  }
}))

#grid(
  columns: (1fr, 1fr),
  gutter: 10pt,
  [#ok_interpolation(6, 4) Approssimazione ai minimi quadrati con $m << n$. Il polinomio di grado basso filtra il rumore e cattura il trend fisico.],
  [#bad_interpolation(6, 4) Se il grado $m$ è troppo alto ($m approx n$), il polinomio inizia a interpolare il rumore, generando oscillazioni instabili.],
)

Il problema è il seguente: supponiamo di avere $n+1$ coppie di dati $(x_i, y_i)$ per $i=0, dots, n$, che rappresentano misurazioni (rumorose) di un fenomeno fisico descritto da un polinomio $p(x) in Pi_m$, con $m << n$.

Il nostro obiettivo è calcolare il polinomio $p(x)$ che meglio approssima i dati assegnati.
Un modo rigoroso per definire $p(x)$ è quello di richiedere che esso minimizzi la quantità:
$
  r^2 := sum_(i=0)^n (y_i - p(x_i))^2
$
ovvero la somma dei quadrati delle differenze (chiamate *residui*) tra il dato misurato $y_i$ e il valore predetto dal modello polinomiale nel punto $x_i$. Per questo motivo, si parla di polinomio di *approssimazione ai minimi quadrati*.
#observation()[
  Il grado $m$ del polinomio è dettato dalla derivazione fisica del problema.
]
Nel seguito, assumeremo che almeno $m+1$ delle ascisse $x_i$ siano tra loro distinte. Sotto questa ipotesi fondamentale, è possibile dimostrare il seguente risultato:

#theorem()[
  Se almeno $m+1$ delle ascisse $x_i$ sono tra loro distinte, il polinomio di approssimazione di grado $m$ ai minimi quadrati esiste ed è unico.
]
#proof()[
  Se $p(x) in Pi_m$, allora può essere scritto come $p(x) = sum_(j=0)^m a_j x^j$, per opportuni coefficienti incogniti $a_j$.

  Definiamo il residuo $i$-esimo come la differenza tra il valore predetto dal polinomio e il valore effettivamente osservato nell'ascissa $x_i$:
  $
    r_i = y_i - p(x_i) = y_i - sum_(j=0)^m a_j x_i^j , quad quad "per" i=0, dots, n\
    r^2 = sum_(i=0)^n r_i^2 = sum_(i=0)^n (y_i - sum_(j=0)^m a_j x_i^j)^2
  $

  Riscriviamo la somma dei quadrati dei residui $r^2$ in forma matriciale, calcolando la norma 2 al quadrato del vettore dei residui:
  $
    r^2 = norm(
      mat(
        x_0^(0), x_0^(1), dots, x_0^(m);
        dots.v, , , dots.v;
        dots.v, , , dots.v;
        x_n^(0), x_n^(1), dots, x_n^(m);
        delim: "["
      )
      mat(a_0; a_1; dots.v; a_m) - mat(y_0; y_1; dots.v; y_n)
    )^2_2 = norm(V uu(a) - uu(y))^2_2
  $
  dove:
  - $V in RR^((n+1) times (m+1))$ è una matrice di tipo Vandermonde rettangolare;
  - $uu(a) in RR^(m+1)$ è il vettore colonna dei coefficienti incogniti;
  - $uu(y) in RR^(n+1)$ è il vettore colonna delle osservazioni.


  Pertanto, minimizzare $r^2$ equivale a cercare la soluzione del sistema lineare sovradeterminato:
  <4.60>
  $
    V uu(a) = uu(y) quad quad (4.60)
  $
  nel senso dei minimi quadrati.

  La tesi segue osservando che, per ipotesi, abbiamo almeno $m+1$ ascisse $x_i$ distinte. Le righe di $V$ corrispondenti a queste ascisse costituiscono una sottomatrice di Vandermonde quadrata di dimensione $(m+1) times (m+1)$ che è garantita essere non singolare.
  Di conseguenza, l'intera matrice $V$ ha rango massimo per colonne (rango pari a $m+1$). Questo ci assicura l'esistenza e l'unicità della soluzione, e ci permette di risolvere il sistema #link(<4.60>, [(4.60)]) in modo stabile, ad esempio mediante la *fattorizzazione QR* della matrice $V$.
]
#observation()[
  In Matlab, la function `polyfit(x, y, m)` implementa esattamente questo algoritmo: costruisce la matrice di Vandermonde e risolve il problema ai minimi quadrati per restituire i coefficienti del polinomio approssimante.
]
