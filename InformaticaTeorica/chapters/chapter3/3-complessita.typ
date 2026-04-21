#import "../../../dvd.typ": *

//30.03.2026
= Complessità computazionale

Si suppone adesso di avere dei problemi decidibili, cioè dei problemi per cui abbiamo trovato una soluzione. Quello che ci chiediamo è: quante risorse di tempo e di spazio richiede questa soluzione? Qual è la sua complessità computazionale?

== Complessità temporale
#definition()[
  Data una MdT M standard, la complessità in tempo di M è determinata dalla funzione time complexity $t c_M$. Tale funzione calcola quanto ci mette M a terminare su una stringa w in input ed è definita nel seguente modo:
  $
    t c_M : NN -> NN\
    t c_M (n) = "# transazioni eseguite da M su una stringa di lunghezza n nel caso peggiore."
  $
]

#definition()[
  Siano $f,g : NN ->NN$. Allora $f in O(g)$, quando scegliendo un $n$ molto grande, il rapporto tra queste due funzioni tende a rimanere limitato, non sorpassa mai un certo valore costante. Si può scrivere così:
  $
    exists C > 0, exists n_0 in NN, forall n gt.eq n_0 : frac(f(n), g(n)) lt.eq C "oppure" f(n) lt.eq C dot g(n)
  $
]

#definition()[
  Siano $f,g : NN ->NN$. Allora $f in Omega(g)$, quando il rapporto tra queste due funzioni sta sempre sopra ad un certo valore costante. Si può scrivere così:
  $
    exists D > 0, exists n_0 in NN, forall n gt.eq n_0 : frac(f(n), g(n)) gt.eq D "oppure" f(n) gt.eq D dot g(n)
  $
]

#definition()[
  Siano $f,g : NN ->NN$. Allora $f in Theta(g)$, quando $f in O(g)$ e $f in Omega(g)$, cioè quando il rapporto tra queste due funzioni rimane compreso tra un valore minimo e un valore massimo. Si può scrivere così:
  $
    exists C,D > 0, exists n_0 in NN, forall n gt.eq n_0 : C lt.eq frac(f(n), g(n)) lt.eq D
  $
]

#definition()[
  Siano $f,g : NN ->NN$. Allora $f in o(g)$, quando $f$ è di un ordine di grandezza strettamente inferiore a $g$, va all'infinito molto più lentamente rispetto a $g$. Si può scrivere come:
  $
    lim_(n->infinity) f(n)/g(n) = 0
  $
]

#observation()[
  $f=o(g) => f=O(g)$
]

#definition()[
  Siano $f,g : NN ->NN$. Allora $f tilde g$, ($f$ asintotica $g$) quando le due funzioni all'infinito tendono ad attaccarsi. Si può scrivere come:
  $
    lim_(n->infinity) f(n)/g(n) = 1
  $
]

#observation()[
  $f tilde g => f = Theta(g)$
]
#example()[
  Sia M una MdT che accetta il linguaggio $L$ delle stringhe palindrome binarie sull'alfabeto $Sigma = {a,b}$. Mostriamo come M procede per controllare se la stringa in input sia palindroma o no:
  1. Legge il primo simbolo della stringa e lo cancella
  2. Va in fondo alla stringa
  3. Se trova lo stesso simbolo, lo cancella e torna a inizio stringa (ripete dal punto 1), finché la stringa non finisce.
  4. Altrimenti termina.
  #figure(image("images/2026-03-30-12-20-44.png"))
  In questo caso, il caso peggiore (ovvero il massimo numero di transizioni) si ha quando la stringa viene accettata. Distinguiamo due casi:
  - La lunghezza $n=2k$ della stringa è un numero pari:
    $
      [1+2 + (2k-1)] + [1+2 + (2k-2)] + [1+2 + (2k-3)] + dots+ [1+2 + 2] + [1+2 + 1] \ = sum_(i=0)^(2k-1) (3+i) = 2 + sum_(i=0)^(2k-1)(3) + sum_(i=0)^(2k-1)(i) = 2+3 dot 2k + frac(2k(2k-1), 2) = frac(n(n-1), 2)+3n+2
    $
  - La lunghezza $n=2k-1$ della stringa è un numero dispari:
    $
      [1+2 + (2k-2)] + [1+2 + (2k-3)] + [1+2 + (2k-4)] + dots+ [1+2 + 2] + [1+2 + 1] \ = 4+ sum_(i=0)^(2k-2) (3+i) = 4 + 3 dot (2k-1) + sum_(i=1)^(2k-2) i = 4+3(2k-1) + frac((2k-2)(2k-2), 2) = frac(n(n-1), 2)+3n+4
    $
  Quindi, in conclusione, abbiamo che la complessità è di tipo polinomiale, più precisamente è quadratica. ($Theta(n^2)$)
]

=== Complessità nelle MDT multitraccia
#proposition()[
  Sia M una MdT multitraccia che accetta $L$, avente complessità in tempo $t c_M (n)=f(n) =>$ esiste una MdT M' standard (equivalente a M) che accetta $L$ tale che $t c_M' (n) = f(n)$. Ovvero hanno la stessa complessità.
]

=== Complessità nelle MDT multinastro
#proposition()[
  Sia M una MdT a $k$ nastri ($k>1$) che accetta $L$ con complessità $t c_M (n)=f(n)=>$ esiste una MdT M' standard equivalente che accetta $L$ e tale che $t c_M' (n) = O(f(n)^2)$
]
#proof()[
  Consideriamo una MdT M a $k$ nastri e prendiamo la MdT M' a $2k+1$ tracce che è equivalente a M già descritta nella prima parte del corso. Sia $w$ una stringa di lunghezza $n$ su cui eseguiamo M e supponiamo che M su $w$ esegua $f(n)$ transizioni. Vediamo quante transizioni di M' sono necessarie per simulare la t-esima transizione di M su $w$.
  - Momento della raccolta delle informazioni (la testina di M' si   sposta sulle tracce in corrispondenza della posizione delle testine  dei nastri per leggere i simboli e salvarli nello stato):  La testina si sposta al massimo per t volte (perché stiamo   analizzando la t-esima transizione), legge il simbolo e torna   indietro, per cui fa t passi avanti, $t$ passi indietro per tutti i $k$ nastri di M: $2t dot k + 2 t dot k = 4 t k$
  $
    sum_(t=1)^(f(n)) 4 t k ("stima limite sup. del num. di trans. nel caso peggiore" ) =4k dot sum_(t=1)^(f(n)) t = 4k dot frac(f(n) dot (f(n)+1), 2) = Theta(f(n)^2) //DA RIVEDERE CON Appunti
  $
]

#figure(image("images/2026-03-30-13-14-10.png"))

#definition()[
  Data una MdT _M_ non deterministica, la *complessità in tempo* di _M_ è determinata dalla funzione:
  $
    t c_M = &\# "transizioni eseguite da una computeazione di M su una stringa di lunghezza "n\
    &"nel caso perggiore".
  $
]

#proposition()[
  Sia _M_ MdT non deterministica che accetta il linguaggio _L_:
  $
    &t c_M(n) = f(n)=> exists M' "MdT deterministica che accetta "L space t.c.\
    &t c_M'(n)=Omicron(f(n) dot cal(S)^f(n))
  $
]

#proof()[
  _M'_ MdT che deterministica equivalente a _M_

  #grid(
        columns: (0.05fr, 0.1fr, 0.3fr, 0.3fr, 0.3fr, 0.05fr),
        rows: 3,
        row-gutter: 5pt,
        stroke: none,
        [], [3], [Computazioni di M], [$(m_1, m_2, dots, m_f(n))$], [$1 <= m_1, dots, m_f(n) <= cal(S)$], [],
        [], [2], [Simulazione di M], [], [], [],
        [], [1], [INPUT], [], [], [],
  )

  - Numero di computazioni di M di lunghezza $f(n)$ su input di lunghezza $n <= cal(S)^f(n)$
  - Numero di transizioni eseguite da M su una stringha di lunghezza $n <= f(n)$

  Quindi: $t c_M'=Omicron(f(n) dot cal(S)^f(n))$
]

#pagebreak()
#example()[
  #image("images/2026-04-01-11-50-50.png")
  // TODO: CORREGGERE L'ESEMPIO, CASO PEGGIORE: NON ACCETTA LA STRINGA
  #image("images/2026-04-01-11-55-00.png")

  Caso peggiore: rifiuto, precisamente la commputazione in cui copio tutta la stringa sul secondo nastro.
  #block($
           t c_M(n)= 1 + 2n
         $)
]

#definition()[
  $bold(P)={L "linguaggio" | exists M "MdT det. che accetta "L space t.c. t c_M(n)=Omicron(n^r), exists r in NN}$
]
#definition()[
  $bold(N P)={L "linguaggio" | exists M "MdT non det. che accetta "L space t.c. t c_M(n)=Omicron(n^r), exists r in NN}$
]

#observation()[
  $P subset N P$, perché le MdT deterministiche sono un caso particlare di MdT non deterministiche.
]

#problem()[
  Il problema aperto attualmente più importante in informatica teorica è:
  $
    P limits(=)^? N P
  $
]

=== Problema del circuito hamiltonian

Dato un grafo orientato $G=(V, E)$, con:
- _V_ = insieme dei vertici,
- _E_ = insieme degli archi
- $|V|=n=$ cardinalità dell'insieme dei vertici


#definition()[
  Dato un grafo orientato $G=(V, E)$, un *circuito hamiltoniano* in _G_ è una sequenza $(x_1,x_2, dots, x_(n-1), x_n, x_1)$ di vertici t.c.
  $
    forall i (x_i, x_(i+1)) in E quad quad ((x_n, x_1) in E) "e" V={x_1, dots, x_n}
  $

  In parole povere, un *circuito hamiltoniano* è un  ciclo che passa una e una sola volta da tutti i vertici di un grafo.
]

Codifica di $G=(V,E), V={1, 2, dots, n}$:

- Codifica dei vertici: uso la codifica binaria;
- Codifica degli archi: $(x_i, x_j) arrow.squiggly x_1\#x_j$;
- Codifica del grafo: Codifica della lista degli archi $+ n$. Per separare gli archi nella codifica si usa \#\# e per separare *$n$* si usa \#\#\#.

$
  dots space x_i\#x_j\#\#x_(i+1)\#x_(j+1)\#\# space dots space \#\#\#n
$

Per fare ciò si usa una MdT a 4 nastri:
+ Contiene la rappresentazione del grafo in input;
+ Contiene le sequenze dei nodi generati (che iniziano e terminano con il nodo *1*);
+ È quello di lavoro, cioè quello che si usa per vedere se la sequenza è hamiltoniana: ci si scrive tutti i nodi che passano il controllo;
+ È il nastro di fine computazione, serve per indicare quando devo smettere di generare sequenze perché contiene l'ultima sequenza da controllare;

Si può fare anche con 3 nastri confrontando il contenuto del nastro 2 con la n nel nastro 1

- Scrivo sul nastro 4 la stringa da generare ($1 **$)
- Sul nastro 2 genero una dopo l'altra, in ordine lessicografico, le stringhe di lunghezza $n+1$ di vertici di V che iniziano e finiscono con _1_ (il nodo)
- Confronto la stringa generata sul nastro 2 col contenuto del nastro 4: se sono uguali, RIFIUTO
- Scorro la sequenza sul nastro 2 e $forall j$:
  - controllo che $i_j$ non compaia tra gli elementi $i_k$, con $k < j$
  - controllo che $(i_(j-1), i_j) in E$
- Se entrambi i controlli sono passati, scrivo $i_j$ sul nastro 3, ALTRIMENTI produco la prossima sequenza al passo 1 (si torna al passo 1)