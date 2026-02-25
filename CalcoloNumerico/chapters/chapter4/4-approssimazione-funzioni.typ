#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot

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
