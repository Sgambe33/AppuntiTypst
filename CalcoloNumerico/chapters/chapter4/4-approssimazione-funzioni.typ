#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
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
Date $n+1$ ascisse distinte nell'intervallo $[a,b], quad a lt.eq x_0 < x_1 < ... < x_n lt.eq b$ in cui è noto il valore della funzione $f(x)$: ovvero sono assegnate $n+1$ coppie di dati $(x_i, f_i), space i=0,...,n$, dove abbiamo denotato $f_i equiv f(x_i), space i =0,...,n$.

Dal punto di vista geometrico:
#figure(
  canvas({
    import draw: content
    plot.plot(
      size: (15, 8),
      x-tick-step: 1,
      y-tick-step: 1,
      y-min: 0,
      y-max: 10,
      plot-style: (stroke: black),
      min: 0,
      {
        let func = x => 2 * calc.sqrt(x) + 2
        plot.add(func, domain: (0, 10), label: $f(x)$, style: (stroke: blue))
        plot.add-hline(0, style: (stroke: black))
        plot.add-vline(1, 3, 5, 10, min: -0.01, max: 0.01)
        plot.annotate({
          content((.55, .025), $x^*$)
        })
      },
    )
  }),
)
Obiettivo: costruire una funzione "semplice" che interpola i dati $(x_i, f_i), i=0,1,...,n$. A riguardo, considereremo, tra le varie possibilità, *funzioni interpolanti* che sono polinomi.

#definition()[
  #index("Polinomio interpolante")
  Diremo che $p(x) in Pi$ è un *polinomio interpolante* le coppie di dati  $(x_i, f_i)$, se:
  $
    p(x_i) = f_i, quad i=0,1,...,n
  $
]

Vale a riguardo il seguente risultato.

#theorem()[
  Date le $n+1$ coppie di dati $(x_i, f_i) i=0,...,n$, con $x_i eq.not x_j$ se $i eq.not j$ (ascisse distinte), allora *esiste ed è unico* $p(x) in Pi_n$ (insieme dei polinomi di grado $n$):
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
  che è un sistema di equazioni lineari nelle $n+1$ incognite $a_0,...,a_n$. Pertanto la sue soluzione esisterà e sarà unica se solo se la matrice dei coefficienti è non singolare.
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
    det(V) = product_(i>j) (x_i - x_j) eq.not 0
  $
  poiché le ascisse sono, per ipotesi, tra loro distinte. Pertanto la soluzione del sistema (4.2) esiste ed è unica, ovvero esiste ed è unico il polinomio $p(x) in Pi_n$, interpolante le coppie di dati.
]

Osserviamo che, tuttavia, il calcolo del polinomio interpolante mediante la risoluzione del sistema lineare (4.2) non è una buona prassi computazionale. Questo è dovuto al fatto che il numero di condizionamento della matrice $V$ cresce assai rapidamente con il crescere di $n$.

#example("Mal condizionamento di Vandermonde")[
  Nel caso $[a,b]=[0,1]$ e $x_i=i/n, i=0,1,...,n$, il condizionamento produce:
  #align(center, table(
    align: center,
    rows: 2,
    columns: 8,
    [$n$], [2], [3], [5], [$...$], [10], [15], [20],
    [$k_2(V)$], [1.5], [9.9], [$4.9 dot 10^3$], [$...$], [$1.2 dot 10^8$], [$3.1 dot 10^12$], [$9.1 dot 10^16$],
  ))
]

Per ovviare al precedente problema, occorrerà utilizzare una differente base polinomiale per rappresentare $p(x)$.

#observation()[
  Anche se cambiamo base per rappresentare $p(x)$, il polinomio rimane lo stesso, perché esso è unico.
]

== Forma di Lagrange e forma di Newton
La base polinomiale che andiamo a considerare è quella di Lagrange:
$
  L_(i n)(x) = product_(j=0 \ j eq.not i)^n frac(x-x_j, x_i-x_j), space i=0,...,n
$
#observation(multiple: true)[
  1. Si tratta di $n+1$ polinomi, ben definiti se le ascisse sono *distinte*.
  2. Si tratta di polinomi tutti di grado $n$. $L_(i n)(x) in Pi_n, space i=0,...,n$.
  3. $
      L_(i n)(x_k) = cases(1 "se" k=i, 0 "se" k eq.not i)
    $
    #index("Delta di Kroenecker")
    Introducendo il *delta di Kroenecker*
    $
      S_(i k) = cases(1 "se" k=i, 0 "se" k eq.not i)
    $
    abbiamo quindi che
    $
      L_(i n)(x_k) = S_(i k)
    $
]

#lemma()[
  I polinomi ${L_(i n)(x)}_(i=0,...,n)$ sono linearmente indipendenti. Pertanto essi costituiscono una base per $Pi_n$.
]
#proof()[
  TODO: vedi appunti prof.
]

#lemma()[
  #index("Forma di Lagrange")
  Il polinomio $p(x) in Pi_n$ tale che $p(x_i)=f_i, space i=0,...,n$ si può rappresentare come:
  $
    p(x) = sum_(i=0)^n f_i L_(i n)(x) quad quad (4.3)
  $
]
#proof()[
  Infatti:
  $
    p(x_k) & = sum_(i=0)^n f_i L_(i n)(x_k) \
           & = sum_(i=0)^n f_i S_(i k) = f_k S_(k k) = f_k quad forall k=0,...,n.
  $
]

#definition()[
  La (4.3) definisce la *forma di Lagrange* del polinomio interpolante.
]

//26.02.2026
Calcoliamo il suo coefficiente principale: osservando che al denominatore abbiamo $(x-x_0)dot dots dot (x-x_(i-1)) dot (x-x_(i+1))dot dots dot (x-x_n) = x^n+ dots$ che è un *polinomio monico* (con coefficiente principale uguale a 1). Si conclude che il coefficiente principale di $L_(i n)(x)$ è dato da:
$
  L_(i n)(x) = product_(j=0 \ j eq.not i)^n frac(x-x_j, x_i-x_j) = frac(product_(j=0\ j eq.not i)^n (x-x_j), product_(j=0\ j eq.not i)^n (x_i-x_j)) = frac(1, product_(j=0\ j eq.not i)^n x_i-x_j) = c_(i n) quad quad (4.4)
$
Da questo si deduce che il coefficiente principale di $p_n(x)$ sarà dato da:
$
  sum_(i=0)^n c_(i n) f_i = sum_(i=0)^n frac(f_i, product_(j=0\ j eq.not i)^n x_i-x_j) quad quad (4.5)
$

A questo punto, ci poniamo la seguente domanda: se definiamo $p_r(x) in Pi_r$ il polinomio interpolante $f(x)$ sulle ascisse $underbrace(x_0\, dots\, x_r, r+1)$, è possibile definire definire in modo incrementale $p_r(x)$ a partire da $p_(r-1)(x)$, che è il polinomio interpolante $f(x)$, di grado al più $r-1$, sulle ascisse $underbrace(x_0\, dots\, x_(r-1), r)$?

A questo fine, osserviamo che la base di Lagrange si presta male a questo scopo. Infatti:
$
  p_r(x) = sum_(i=0)^r f_i L_(i r)(x), quad L_(i r)(x) =product_(j=0\ j eq.not i)^r frac(x-x_j, x_i-x_j) space i=0,...,r quad quad (4.6)
$
mentre
$
  p_(r-1)(x) = sum_(i=0)^(r-1) f_i L_(i,r-1)(x), quad L_(i, r-1)(x) =product_(j=0\ j eq.not i)^(r-1) frac(x-x_j, x_i-x_j) space i=0,...,r-1
$
Di conseguenza, vogliamo invece cercare di esprimere $p_r(x)$ in forma incrementale, come:
$
  p_r(x) = p_(r-1)(x) + overbracket(<\->, "polinomio" \ "di grado" r)
$
Con $r=1,...,n$, $p_n (x)$ sarà il polinomio che interpola $f(x)$ su tutte le ascisse.

Per ottenere questo obiettivo, dobbiamo ricorrere ad un'ulteriore base di rappresentazione: la base di Newton. Essa è una base di polinomi nomici ed è definita nel seguente modo:
<4.7>
$
  (4.7) quad quad cases(omega_0(x) equiv 1, omega_i(x) = omega_(i-1)(x)(x-x_(i-1))\, space i=1\,2\,dots)
$
#observation(multiple: true)[
  1. Per induzione, otteniamo che $omega_i(x)=product_(j=0)^(i-1) (x-x_j), space i gt.eq 1$, ovvero, $omega_i(x)$ è un polinomio monico di grado esatto $i$, le cui radici sono $underbrace(x_0\,dots\,x_(i-1), i)$.
  2. $forall i=1,dots,n : space omega_i(x_j)=0, space forall j < i$.
  4. Avendo $omega_i(x)$ grado esatto $i, space forall i=0, dots, n$, abbiamo che i polinomi sono linearmente indipendenti e costituiscono una base di $Pi_n$. Appunto, la base di *Newton*.
]
A questo punto, assegnate le ascisse $x_0,...,x_n$ (distinte tra loro), è possibile costruire in forma incrementale la famiglia di polinomi interpolanti ${p_r (x)}_(r=??)$ tali che, $p_r (x) in Pi_r$ e:
$
  forall r = 0,...,n: space p_r (x_i) = f_i space i=0,dots,r
$
come segue:
$
  (4.8) quad quad cases(
    p_0(x) equiv f_0,
    p_r (x) = underbrace(p_(r-1)(x), in Pi_(r-1)) + f[x_0,...,x_r]underbrace(omega_r(x), in Pi_r) space r=1\,...\,n
  )
$
con il coefficiente:
<4.9>
$
  f[x_0, dots, x_r] = sum_(i=0)^r frac(f_i, product_(j=0\j eq.not i)(x_i-x_j)) quad quad (4.9)
$
Andiamo a dimostrare che, se
$
  p_(r-1)(x_i) = f_i, space i=0,dots,r-1 quad quad (4.10)
$
allora è possibile determinare univocamente $f[x_0, dots, x_r]$ nella (4.8), in modo tale che
$
  p_r (x_i) = f_i, space i=0, dots,r quad quad (4.11)
$
Successivamente dimostreremo che $f[x_0, dots, x_r]$ è riscrivibile nella forma #link(<4.9>)[(4.9)].

#proof()[
  Procedendo per induzione, abbiamo che $p_0(x) in product_0$ e $p_0(x_0) = f_0$. Assunto vero (4.10), andiamo a verificare che è possibile determinare $f[x_0, dots, x_r]$, in modo che sia soddisfacibile la (4.11).
  $
    p_r(x_i) = p_(r-1)(x_i) + f[x_0,dots,x_r]omega_r(x_i) = cases(
      i<r: quad f_i+f[x_0,dots,x_r]overbrace(omega_r (x_i), 0)=f_i,
      i=r: quad p_(r-1)(x_r)+f[x_0,dots,x_r]omega_r (x_r)=f_r
    )
  $
  Da cui otteniamo, considerato che le ascisse sono distinte e, pertanto, $omega_r(x_r)eq.not 0$, che possiamo soddisfare la condizione di interpolazione imponendo:
  $
    f[x_0,dots,x_r]=frac(f_r - p_(r-1)(x_r), omega_r(x_r))
  $
  Facciamo ora vedere che $f[x_0, dots, x_r]$ si può esprimere nella forma #link(<4.9>)[(4.9)].
  #observation(multiple: true)[
    1. $f[x_0,dots,x_r]$ è il coefficiente principale di $p_r(x)$.
    2. Dalla (4.5), con $n=r$, otteniamo che il secondo mebro della #link(<4.9>)[(4.9)] altri non è che il coefficiente principale di $p_r(x)$ scritto in forma di Lagrange. Pertanto essi devono coincidere.
  ]
  Concludiamo che l'espressione #link(<4.9>)[(4.9)] deve valere.
]

#definition()[
  #index("Differenza divisa")
  $f[x_0,dots,x_r], space r=0,1,dots$, come definita nella #link(<4.9>)[(4.9)], è detta *differenza divisa* di $f(x)$ sulle ascisse $x_0,dots,x_r$.
]
#observation()[
  Dalla (4.8) si ottiene che:
  <4.12>
  $
    p_n(x) = sum_(r=0)^n f[x_0,dots,x_r]omega_r(x) quad quad (4.12)
  $
]

#definition()[
  #index("Forma di Newton")
  La #link(<4.12>)[(4.12)] definisce la forma di Newton del polinomio interpolante .
]

#observation()[
  Il  polinomio $p_n(x)$, ricordiamo è *unico*. Pertanto:
  $
    p_n (x) = sum_(i=0)^n f_i L_(i n)(x) = sum_(i=0)^n f[x_0, dots, x_i] omega_i (x)
  $
  ovvero, la forma di Lagrange e quella di Newton del polinomio interpolante sono *algebricamente equivalenti*. _Attenzione: ciò non significa che sono equivalenti dal punto di vista dell'aritmetica finita_
]

//04.03.2026
#theorem("Proprietà delle differenze divise")[
  Valgono le seguenti proprietà delle differenze divise:
  1.
  2. se $(i_0,dots,i_r)$ è una permutazione di $(0,dots,r)$, allora:
    $
      f[x_(i_0),dots,x_(i_r)] = f[x_0,dots,x_r] quad quad ("simmetria rispetto agli argomenti")
    $
  3. sia $f(x)$ un polinomio di grado $k$: $f(x) = sum_(i=0)^k a_i x^i$. Sia $p(x)=sum_(i=0)^n f[x_0,dots,x_i]omega_i(x)$ il suo polinomio interpolante di grado $n$, allora:
    $
      f[x_0,dots,x_n]=cases(a_k\, space "se" k=n, 0\, space "se" k<n)
    $
  4. se $f(x) in C^(r+1) [a,b]$, allora:
    $
      f[x_0, dots, x_r] = frac(f^((r))(xi), r!) quad xi in [min_i x_i, max_i x_i]
    $
  5. $
      f overbrace([x_0, dots, x_r], r+1) = frac(f overbrace([x_1, dots, x_r], r)-f overbrace([x_0, dots, x_(r-1)], r), x_r - x_0)
    $
]

#observation()[
  Nella 3., se $k=n$, per l'unicità del polinomio interpolante, avremo che $f(x)equiv p(x)$. Pertanto, i coefficienti principali, rispettivamente $a_n$ e $f[x_0,dots,x_n]$, devono coincidere:
  $
    f[x_0,dots,x_n] = a_n quad quad (n=k)
  $
  Tuttavia, se $n>k$, anche ora $p(x) equiv f(x)$. Quest'ultimo può essere riscritto come:
  $
    f(x)= sum_(i=0)^k a_i x^i + 0 dot x^(k+1) + dots + 0 dot x^n
  $
  //Polinomio interpolante di grado 25 di una parabola --> in realtà è un polinomio di grado 2?
  _Ricordare che $forall n >= k$, il polinomio di grado $n$ che interpola un polinomio di grado $k$ *coincide con quest'ultimo per l'unicità del polinomio interpolante*._
]

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
    omega_r(x) = product_(i=0)^(r-1) (x-x_i) = (x-x_0)^r
  $
  Pertanto se $x_0=x_1=dots=x_n$, otteniamo che:
  $
    p(x)=sum_(r=0)^n f[x_0,dots,x_0] omega_r(x) = sum_(r=0)^n frac(f^((r))(x_0), r!)(x-x_0)^r
  $
  che è il polinomio di Taylor di grado $n$ di $f(x)$, centrato in $x_0$.
]


#observation()[
  Nella 5., tenendo conto  $f[x_i] =f_i, space i=0,dots,n$ questa proprietà ci consente di calcolare in modo incrementale le differenze divise richieste per il calcolo del polinomio interpolante in forma di Newton
]

#heading(numbering: none, depth: 3, "Proprietà 1.")
Se $alpha, beta in RR$ e $f(x), g(x)$ sono funzioni di una variabile reale, allora:
$
  (alpha dot f + beta dot g)[x_0,dots,x_i]=alpha dot f[x_0,dots,x_i] + beta dot g[x_0,dots,x_i] quad quad ("linearità")
$
#proof()[
  $
    frac(1, x_r-x_0)(f[x_1,dots,x_r]-f[x_1,dots,x_(r-1)]) = frac(1, x_r-x_0) (sum_(k=1)^r frac(f_k, product_(j=1\ j eq.not k)^r (x_k-x_j)) - sum_(k=0)^(r-1) frac(f_k, product_(j=0\ j eq.not k)^(r-1) (x_k-x_j)))\
    = frac(1, x_r-x_0) [frac(f_r, product_(j=1\ j eq.not r)^r (x_r-x_j)) - frac(f_0, product_(j=0\ j eq.not 0)^(r-1) (x_0-x_j)) + sum_(k=1)^(r-1)frac(f_k, product_(j=1\ j eq.not k)^(r-1)(x_k-x_j))(frac(1, x_k-x_r)-frac(1, x_k-x_0))]=(*)\
    frac(1, x_r-x_0) dot frac(f_r, product_(j=1 \ j eq.not r)^r (x_r-x_j)) = frac(f_r, product_(j=0 \ j eq.not r)^r(x_r-x_j)) quad quad ("giallo")\
    frac(-1, x_r-x_0) dot frac(f_0, product_(j=0 \ j eq.not 0)^(r-1) (x_0-x_j)) = frac(1, x_0-x_r) dot frac(f_0, product_(j=0 \ j eq.not 0)^(r-1) (x_0-x_j)) = frac(f_0, product_(j=0 \ j eq.not 0)^r (x_0-x_j)) quad quad ("verde")\
    frac(1, x_r-x_0) dot sum_(k=1)^(r-1) frac(f_k, product_(j=1\ j eq.not k)^(r-1) (x_k-x_j)) dot frac(x_k - x_0 - x_k +x_r, (x_k-x_r)(x_k-x_0)) = sum_(k=1)^(r-1) frac(f_k, product_(j=0\ j eq.not k)^r (x_k-x_j)) quad quad ("blu")\
    => (*) = sum_(k=0)^r frac(f_k, product_(j=0\ j eq.not k)^r (x_k-x_j)) = f[x_0,dots, x_r]
  $
]

Questa proprietà ci consente di calcolare in modo efficiente le differenze divise necessarie per il calcolo del polinomio interpolante in forma di Newton.

#table(
  columns: 7,
  align: center + horizon,
  stroke: none,
  table.hline(y: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  table.vline(x: 1, stroke: (dash: "solid", thickness: 0.4pt)),
  [], [0], [1], [2], [$dots.c$], [$n-1$], [$n$],
  [$x_0$], [$f[x_0]$], [], [], [], [], [],
  [$x_1$], [$f[x_1]$], [$f[x_0,x_1]$], [], [], [], [],
  [$x_2$], [$f[x_2]$], [$f[x_1,x_2]$], [$f[x_0,x_1,x_2]$], [], [], [],
  [$dots.v$], [$dots.v$], [$dots.v$], [], [], [], [],
  [$x_(n-1)$], [$f[x_(n-1)]$], [$dots.v$], [], [], [$f[x_0,dots,x_(n-1)]$], [],
  [$x_n$], [$f[x_n]$], [$f[x_(n-1),x_n]$], [$f[x_(n-2),x_(n-1),x_n]$], [], [$f[x_1,dots,x_n]$], [$f[x_0,dots,x_n]$],
)
Quelle sulla diagonale sono le differenze divise necessarie per il calcolo del polinomio in forma di Newton.
#observation()[
  Se calcoliamo le colonne di questa matrice triangolare dal basso verso l'alto, possiamo sovrascrivere i risultati negli elementi adiacenti a sinistra. Pertanto sarà sufficiente un vettore di $n+1$ elementi (in realtà 2, uno anche per le ascisse).
]

//05.03.2026
Esaminiamo, in dettaglio, il caso $n=2$, prima di derivare una procedura generale per il calcolo delle differenze divise nel caso di $n$ generico.

#table(
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
)
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
  #observation()[
    $
      sum_(j=0)^n j^k approx integral_0^n x^k d x = frac(n^(k+1), k+1)
    $
  ]

Vediamo adesso come calcolare efficientemente il polinomio $p(x)$. Consideriamo preliminarmente un problema più semplice, ovvero il calcolo di un polinomio di grado $n$ rispetto alla base delle potenze:
$
  p(x) = sum_(i=0)^n a_i x^i
$
#example()[
  Con $n=2$ avremo:
  $
    p(x)=a_0 + a_1 x + a_2 x^2
  $
  - $p=a_2$
  - $p <-- p dot x + a_1 => p=a_2 x + a_1$
  - $p <-- p dot x + a_0 => p=a_0+a_1 x +a_2 x^2$
]
Questo algoritmo si chiama *algoritmo di Horner*. La sua complessità è $2n$ `flops`. //Possibile domanda parziale

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 4.2* Algoritmo di Horner],
)
```matlab
p=a(n+1);
for i=n:-1:1
  p=p*x+a(i);
end
```
#observation()[
  Se volessimo calcolare il polinomio in un vettore di punti, è sufficiente sostituire l'operazione nel ciclo con `p=p .* x+a(i);` (moltiplicazione elemento per elemento)
]
Questo algoritmo può essere generalizzato al caso del polinomio interpolante
#link(<4.12>, "(4.12)"), utilizzando la definizione incrementale #link(<4.7>, "(4.7)") della base di Newton. In Matlab, se $x$ e $f$ sono i vettori con le ascisse e le differenze divise, mentre $x x$ è il vettore dei punti in cui calcolare il polinomio, allora otteniamo:
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: none,
)
```matlab
p=f(n+1);
for i=n:-1:1
  p=p.*(x-x(i))+f(i);
end
```
dove $.*$ è stato utilizzato per calcolare il polinomio interpolante in un vettore, $x x$, di ascisse. Pertanto, con un costo di $3n$ `flops` per ogni punto in cui viene calcolato il polinomio interpolante.

#figure(image("images/2026-03-05-11-44-54.png"))

$p(x)$ è il polinomio interpolante $f(x)$ nelle ascisse assegnate. Se definiamo $e(x)=f(x)-p(x)$, (funzione dell'errore), da cui, ricordando che $p(x_i)=f(x_i)$, otteniamo che:
$
  e(x_i) = 0, space i=0,dots,n
$


// 11.03.2026
== Errore di interpolazione
$
  e(x) = f(x) - p(x), space x in [a,b]
$
#observation()[
  Nelle ascisse di interpolazione si ha:
  $
    e(x_i)=f(x_i)-p(x_i) = 0, space i=0,dots,n
  $
  Cosa accade per $x in.not {x_0, dots,x_n}$?
]

#theorem()[
  L'errore di interpolazione si può esprimere come:
  <4.13>
  $
    e(x)=f[x_0,dots,x_n,x]omega_(n+1) (x) quad quad (4.13)
  $
  con $omega_(n+1) (x) = product_(j=0)^n (x-x_j)$, è il polinomio monico le cui radici sono le ascisse di interpolazione.
]
#proof()[
  Se $x=x_i => e(x_i)=0$, perché $omega_(n+1) (x_i)=0 space forall i=0,dots,n.$ Quindi la #link(<4.13>, [4.13]) è verificata. Se $x=hat(x) in.not {x_0,dots,x_n}$, allora, sfruttando la costruzione incrementale del polinomio interpolante di Newton, possiamo definire $hat(p)(x) in Pi_(n+1)$ che interpola $f(x)$ in $x_0, x_1, dots,x_n$ e $hat(x)$ come:
  <4.14>
  $
    hat(p)(x)=p(x)+f[x_0,dots,x_n,hat(x)] omega_(n+1) (x) quad quad (4.14)
  $
  Pertanto: $hat(p)(x_i)=f(x_i), space i=0,...,n$ e $hat(p)(hat(x))=f(hat(x))$, ovvero, tenendo conto della #link(<4.14>, [4.14]):
  $
    p(hat(x)) + f[x_0,dots,x_n,hat(x)] omega_(n+1)(hat(x))=f(hat(x))
  $
  Da questo otteniamo che:
  $
    f[x_0,dots,x_n,hat(x)] omega_(n+1) (hat(x))= f(hat(x))-p(hat(x)) equiv e(hat(x))
  $
  Osservando che $hat(x)$ è generico, si ottiene, infine:
  $
    e(x)=f[x_0,dots,x_n,x]omega_(n+1) (x)
  $
  ovvero la #link(<4.13>, [4.13]).
]

#corollary()[
  Se $f in C^((n+1))$ su un intervallo che contiene le ascisse di interpolazione ed il punto $x$ considerato, allora:
  <4.15>
  $
    e(x) = frac(f^((n+1))(xi_x), (n+1)!) omega_(n+1) (x), space xi_x in I(x_0, dots, x_n, x) quad quad (4.15)
  $
  avendo denotato con $I(x_0, dots, x_n, x)$ il più piccolo intervallo che contiene le *ascisse in argomento*.
]
#proof()[
  Infatti, #link(<4.15>, [4.15]) deriva dalla #link(<4.13>, [4.13]) considerando che, nelle ipotesi fatte:
  $
    f[x_0,dots,x_n,x] = frac(f^((n+1))(xi_x), (n+1)!), "con" xi_x "opportuno."
  $
]

#observation()[
  1. Se $f(x) in Pi_n => f^((n+1))equiv 0 => e(x)=f(x)-p(x)equiv 0$, ovvero, $f(x) equiv p(x)$ per l'unicità del polinomio interpolante, come avevamo già osservato.
  2. Dalla #link(<4.15>, [4.15]) otteniamo che l'errore  $e(x)$ è dato dal prodotto di due termini:
    - $frac(f^((n+1))(xi_x), (n+1)!)$: questo dipende da quanto è "buona" la funzione $f(x)$. Ovvero quanto velocemente le derivate diventano piccole al crescere dell'ordine.
    - $omega_(n+1)(x)=product_(i=0)^n (x-x_i)$: questo dipende esclusivamente dalla scelta delle ascisse di interpolazione. Tuttavia, se $x >> max_i {x_i}$ o $x >> min_i {x_i}$, allora $omega_(n+1)(x) approx x^(n+1)$. Pertanto $p(x)$ è un'approssimazione "spendibile" di $f(x)$ solo se $x$ è prossima (meglio se all'interno) dell' intervallo che contiene le ascisse di interpolazione.
]


// GRAFICO BRUTTO DA RIFARE
#figure(image("images/2026-03-11-12-02-55.png"))

== Interpolazione di Hermite
Supponiamo in questo caso, di ricercare il polinomio interpolante, di grado $2n+1$ su $2n+2$ ascisse distinte, che numeriamo come:
$
  x_0 < x_(1/2) < x_1 < x_(1+1/2) < dots < x_n < x_(n+1/2)
$
Sia $f(x)$ la funzione interpolanda su tali ascisse. Pertanto, sappiamo che $exists p(x) in Pi_(2n+1)$, tale che:
<4.16>
$
  (4.16) quad quad cases(p(x_i)=f(x_i), p(x_(i+1/2))=f(x_(i+1/2))) quad i=0,dots,n
$

Domanda: cosa succede a $p(x)$ se $forall i = 0,dots, space x_(i+1/2) -> x_i$?

Per rispondere in maniera corrette a questa domanda, riscriviamo la #link(<4.16>, [4.16]), equivalentemente, come:
<4.17>
$
  (4.17) quad quad
  cases(
    p(x_i)=f(x_i)\,,
    frac(p(x_(i+1/2)) - p(x_i), x_(i+1/2)-x_i) = frac(f(x_(i+1/2))-f(x_i), x_(i+1/2)-x_i)\, quad i=0\,dots\,n
  )
$
A questo punto, se facciamo il limite per $x_(i+1/2)-->x_i$, nella seconda espressione delle #link(<4.17>, [4.17]), abbiamo dimostrato che $exists p(x) in Pi_(2n+1)$:
<4.18>
$
  (4.18) quad quad cases(p(x_i)=f(x_i), p'(x_i)=f'(x_i)) quad i=0,dots,n
$

#definition()[
  Il polinomio $p(x) in Pi_(2n+1)$ che soddisfa le condizioni di interpolazione (6) è detto polinomio interpolante di Hermite.
]
#observation()[
  In altri termini, il polinomio interpolante di Hermite interpola, nelle ascisse di interpolazione, sia la funzione $f(x)$ che la sua derivata prima. 
  Pertanto ha la stessa retta tangente nelle ascisse di interpolazione.
  #figure(image("images/2026-03-11-17-23-24.png", width: 50%))
]
#example()[
  #figure(image("images/2026-03-11-17-23-53.png", width: 50%))
  Se $f(x)=sin(x)$ e $x_i=i pi, space i=0,1,2$, allora il polinomio interpolante su tali ascisse è $p(x)=0$. Questo non è vero per il polinomio interpolante di Hermite.
]
