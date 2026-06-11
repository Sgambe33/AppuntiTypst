#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *
#import "@preview/cetz:0.5.2"

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
    t c_M = & \# "transizioni eseguite da una computazione di M su una stringa di lunghezza "n \
            & "nel caso peggiore".
  $
]

#proposition()[
  Sia _M_ MdT non deterministica che accetta il linguaggio _L_:
  $
    & t c_M(n) = f(n)=> exists M' "MdT deterministica che accetta "L space t.c. \
    & t c_M'(n)=Omicron(f(n) dot cal(S)^f(n))
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

  Caso peggiore: rifiuto, precisamente la computazione in cui copio tutta la stringa sul secondo nastro.
  #block(
    $
      t c_M(n)= 1 + 2n
    $,
  )
]

#definition()[
  $bold(P)={L "linguaggio" | exists M "MdT det. che accetta "L space t.c. t c_M(n)=Omicron(n^r), exists r in NN}$
]
#definition()[
  $bold(N P)={L "linguaggio" | exists M "MdT non det. che accetta "L space t.c. t c_M(n)=Omicron(n^r), exists r in NN}$
]

#observation()[
  $P subset "NP"$, perché le MdT deterministiche sono un caso particlare di MdT non deterministiche.
]

#problem()[
  Il problema aperto attualmente più importante in informatica teorica è:
  $
    P limits(=)^? N P
  $
]

=== Problema del circuito hamiltoniano

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
- Se entrambi i controlli sono passati, scrivo $i_j$ sul nastro x3, ALTRIMENTI produco la prossima sequenza al passo 1 (si torna al passo 1)

//TODO: mancano osservazioni su complessità O(logn....)


HAM $in$ P? No, non possiamo dirlo, bisognerebbe dimostrare che *nessuna* macchina risolva il problema in tempo polinomiale.

//09.04.2026
#definition()[
  Dati 2 linguaggi $L_1$, $L_2$ con $L_1 subset.eq Sigma_1^*$ e $L_2 subset.eq Sigma_2^*$. Si dice che $L_1$ è *polinomialmente riducibile* a $L_2$ quando:
  - $L_1$ è riducibile a $L_2$, cioè $exists f: Sigma_1^* -> Sigma_2^*$ tale che:
    - $forall w in Sigma_1^*, space w in L_1 <=> f(w) in L_2$
    - $f$ è computabile
  - $f$ è computabile in tempo polinomiale (usando una MDT)
]
#proposition()[
  Sia $f$ una riduzione polinomiale da $L_1$ a $L_2$ e $L_2 in P => L_1 in P$.
]
#proof()[
  Dobbiamo costruire una MDT deterministica, che chiameremo $N$, che decida il linguaggio $L_1$ in tempo polinomiale su un input $w in Sigma_1^*$.

  Dalle ipotesi del teorema sappiamo che:
  - Esiste una riduzione polinomiale $f: Sigma_1^* -> Sigma_2^*$ da $L_1$ a $L_2$.
  - Sia $F$ la MDT che calcola $f$ in tempo $T_F (n) in O(n^r)$, dove $n = |w|$.
  - Poiché $L_2 in P$, sia $M$ la MDT deterministica che decide $L_2$ in tempo $T_M (k) in O(k^s)$, dove $k$ è la lunghezza del suo input.

  Costruiamo la macchina $N$ applicando la seguente strategia sull'input $w$:
  1. Calcoliamo $f(w)$ usando la macchina $F$.
  2. Eseguiamo la macchina $M$ sull'input $f(w)$ per decidere se $f(w) in L_2$.
  3. $N$ accetta $w$ se e solo se $M$ accetta $f(w)$.

  Analisi della complessità temporale di $N$: la lunghezza della stringa output $f(w)$ non può superare il numero di passi compiuti da $F$ per generarla. Pertanto, la lunghezza dell'input che passiamo a $M$ è limitata da $|f(w)| <= T_F (n) in O(n^r)$.

  Il tempo totale impiegato da $N$ è la somma del tempo di $F$ e del tempo di $M$:
  $
    t c_N (n) & = t c_F (n) + t c_M (|f(w)|) \
              & = O(n^r) + O((n^r)^s) \
              & = O(n^r) + O(n^(r s)) = O(n^(r s))
  $

  Poiché $r$ ed $s$ sono costanti, $r s$ è a sua volta una costante. Il tempo di esecuzione di $N$ è limitato da un polinomio, dimostrando quindi che $L_1 in P$. La composizione di due polinomi è ancora un polinomio (la proprietà di composizione è chiusa rispetto alla classe dei polinomi).
]

#definition()[
  Un linguaggio $L$ si dice *NP-DIFFICILE* quando $forall Q in "NP"$, $exists f$ riduzione polinomiale da $Q$ a $L$.
]

#definition()[
  Un linguaggio $L$ si dice *NP-COMPLETO* quando:
  - $L$ è *NP-DIFFICILE*
  - $L in "NP"$
]

#observation()[
  La classe dei linguaggi *"NP-completi"* (indicata con $"NPC"$) è l'insieme dei linguaggi che appartengono a $"NP"$ e che sono contemporaneamente *"NP-difficili"*. Essa costituisce quindi una sottoclasse di $"NP"$. $"NPC" = { L | L in "NP" " e " L " è NP-difficile" }$

  Di conseguenza, vale banalmente la relazione:
  $"NPC" subset.eq "NP"$
]

#proposition()[
  Se esiste un linguaggio $L$ tale che $L in "NPC"$ e $L in "P"$, allora $"P" = "NP"$.
]
#proof()[
  Per definizione, sappiamo già che $"P" subset.eq "NP"$. Per dimostrare l'uguaglianza $"P" = "NP"$, è quindi sufficiente dimostrare l'inclusione opposta: $"NP" subset.eq "P"$.

  Sia $Q in "NP"$ un linguaggio arbitrario.
  Poiché $L in "NPC"$, per definizione $L$ è *"NP-difficile"*. Di conseguenza, esiste una riduzione polinomiale $f$ da $Q$ a $L$ ($Q <=_p L$).
  Inoltre, per ipotesi $L in "P"$, quindi esiste una Macchina di Turing Deterministica (MDT) $M$ che decide $L$ in tempo polinomiale.

  Costruiamo una MDT deterministica, che chiameremo $M'$, per decidere $Q$ su un generico input $w in Sigma^*$:
  1. Calcoliamo $f(w)$. Poiché $f$ è una riduzione polinomiale, questo passo richiede un tempo polinomiale rispetto a $|w|$.
  2. Eseguiamo la macchina $M$ sull'input $f(w)$ per decidere se $f(w) in L$. Poiché $M$ opera in tempo polinomiale e la dimensione di $f(w)$ è limitata da un polinomio, anche questo passo richiede tempo polinomiale.
  3. $M'$ accetta l'input se e solo se $M$ accetta $f(w)$.

  La macchina $M'$ è deterministica e decide $Q$ terminando in un tempo totale polinomiale. Ne consegue che $Q in "P"$.
  Data l'arbitrarietà di $Q$, abbiamo dimostrato che ogni problema in $"NP"$ è anche in $"P"$, ovvero $"NP" subset.eq "P"$. Dunque, $"P" = "NP"$.
]

//15.04.2026
== Istanze di un problema

$
  "rep"_1 : {p_1, p_2,...,P_i} --> Sigma_1^* quad quad "(codifica 1)"
$
$
  "rep"_1 : {p_1, p_2,...,P_i} --> Sigma_1^* quad quad "(codifica 1)"
$
#definition()[
  $"rep"_1$ è *polinomialmente trasformabile* in $"rep"_2$ quando $exists t : Sigma_1^* --> Sigma_2^*$ tale che:
  + $forall i, t("rep"_1 (p_i)) = "rep"_2 (p_i)$
  + $forall w in Sigma_1^*$, cioè $w in.not "Im"("rep"_1) => t(w) in.not "Im"("rep"_2)$. Con "Im" ci si riferisce all'immagine.
  + $t$ è computabile in tempo polinomiale (quindi efficiente)
]

Se $"rep"_1$ è polinomialmente trasformabile in $"rep"_2$, allora la lunghezza di $"rep"_2 (p_i) (= t("rep"_1 (p_i)))$ è al più polinomiale nella lunghezza di $"rep"_1 (p_i)$. Pertanto se un problema sta nella classe P usando $"rep"_2$, allora il problema sta in P anche usando $"rep"_1$.
//DA RIVEDERE con GEMINI
#observation()[
  Attenzione al caso delle rappresentazioni binaria e unaria di un numero naturale ($n$ in binario è $log_c (n)$, la conversione richiede un numero di transizioni esponenziale). La trasformazione da binario a unario non è polinomiale! Può accadere che un problema stia in P con la rappresentazione unaria ma non stia in P con la rappresentazione binaria.
]

#definition()[
  $x_1, x_2, dots, x_n$ indeterminate. Un *polinomio booleano* in $x_1, x_2, dots, x_n$ è elemento dell'insieme PB$(x_1,dots,x_n)$ dei polinomi booleani in $x_1,dots,x_n$ e si ha che:

  - $0,1 in "PB"(x_1,dots,x_n)$

  - $forall i <= n, space x_i in "PB"(x_1,dots,x_n)$

  - $p,q in "PB"(x_1,dots,x_n) => p or q, p and q, p' in "PB"(x_1,dots,x_n)$

  - Nient'altro è un polinomio booleano.
]

#example()[
  $0, y, x or y, (x and z)' or (x or y)' in "PB"(x,y,z)$
]

#observation()[
  $x or y != y or x$ come polinomi, poi però se gli assegno dei valori, il risultato è lo stesso!
]

#definition()[
  $p, q$ polinomi booleani si dicono *equivalenti* ($p equiv q$) quando $forall t$ assegnamento di valore booleano alle variabili, $t(p)=t(q)$.
]

#definition()[
  $"PB"(x_1,dots,x_n)$:
  - *Letterale* è una variabile o la negazione di una variabile ($x_i, x_i '$).
  - *Clausola* è una disgiunzione di letterali ($x_2 or x_4 ' or x_7 or x_8$).
  - Polinomio booleano in *Forma Normale Congiuntiva (CNF)* è un polinomio scritto come congiunzione di clausole $(x_1 or x_3 ') and (x_2 or x_3 or x_3 ') or x_1 '$.
]

#definition()[
  $p$ polinomio booleano si dice *soddisfacibile* quando $exists t$ assegnamento tale che $t(p)=1$ (cioè che lo soddisfa).
  $
    {x_1, dots, x_n} "assegnamento" t:{x_1, dots, x_n}->{0,1} quad t(x_i)=0 or 1
  $
]

== Problema SAT
#problem()[
  Dato un polinomio booleano $p$ in CNF, determinare se $p$ è soddisfacibile (esiste un assegnamento che lo soddisfa).
]
Vogliamo scrivere una MdT non deterministica per risolvere questo problema.

Sia ${x_1, dots, x_n}$ un insieme di variabili. Ciascuna variabile è codificata utilizzando il suo indice scritto in binario.

- Variabili $x_i arrow.r.squiggly uu(i)$ (codifica binaria di i)

- Letterali:
  - $x_i arrow.r.squiggly uu(i) \# 1$ (non negato)
  - $x_i arrow.r.squiggly uu(i) \# 0$ (negato)

#example()[
  Date le variabili ${x_1,x_2,x_3}$ codificate con i numeri ${1,10,11}$, il polinomio $p= (x_1 or x_2 ')and (x_1 ' or x_3)$ viene codificato nel seguente modo:
  $
    1\#1 or 10\#0 and 1\#0 or 11\#1
  $
]

Nella MdT questa codifica andrà un po' arricchita. La codifica finale è composta dalla codifica del polinomio preceduta da una lista di interi da $1$ a $n$ in binario che indicano le variabili presenti nel polinomio:
$
  underbrace(\#10\#11, "cod. variabili")\#\# underbrace(\#1 or 10\#0 and 1\#0 or 11\#1, "polinomio")
$
Quindi l'alfabeto per il problema SAT è $Sigma_"SAT" = {0, 1, \#, and , or}$.

#proposition()[
  Il problema SAT è NP.
]
#proof()[
  Costruiamo una MdT non deterministica che risolve SAT in tempo polinomiale. L'idea alla base è quella di generare non deterministicamente un assegnamento e controllare se esso soddisfa il polinomio in esame.

  DIAGRAMMA MDT A 2 NASTRI : generazione e input!!!

  - Per prima cosa bisogna controllare che la stringa di input sia sintatticamente corretta (se non lo è, si rifiuta e si termina subito).
  - Altrimenti si usa il nastro di lavoro 2. Infatti, si genera su di esso (non deterministicamente) un assegnamento alle variabili nella forma seguente:
    $
      x_1 \# t(x_1) \#\# x_2 \# t(x_2) \#\# dots \#\# x_n \# t(x_n)
    $
    Dove $x_i$ è la rappresentazione binaria dell'indice della variabile $x_i$ e $t(x_i)$ indica l'assegnamento del valore della variabile $x_i$, che può essere 0 o 1.
  - Esamino il polinomio di input da sinistra verso destra, fino a incontrare un letterale $v$, quindi confronto $v \# t(v)$ sul nastro 1 con $x_i \# t(x_i)$ sul nastro 2:
    - *Se sono uguali*: il letterale $v$ è soddisfatto e quindi la clausola in cui compare è soddisfatta (poiché è fatta da operatori OR ($or$), basta che un solo letterale sia soddisfatto affinché tutta la clausola lo sia); posso quindi passare a esaminare la clausola successiva. Se la clausola appena esaminata era l'ultima, accetto e termino.
    - *Se non sono uguali*: il letterale $v$ non è soddisfatto, quindi passo a esaminare il letterale successivo. Se il letterale appena esaminato era l'ultimo della clausola, allora termino e rifiuto il polinomio, poiché la clausola in cui compariva tale letterale non è soddisfatta (il polinomio è una congiunzione di clausole, per cui devono essere tutte vere perché il polinomio sia soddisfatto). Si dice in questo caso che il polinomio non è soddisfacibile.
]

*Caso peggiore* \
Nel caso peggiore dell'accettazione (quando tutte le clausole sono soddisfatte), considerando:
- $n$ variabili
- $k$ letterali

Possiamo stimare la lunghezza dell'input in questo modo:
$
  overbrace(n log n, "bit per codificare le variabili") + k log n = (n+k) log n quad ("stima lunghezza input")
$

Stima del numero di transizioni:
$
  n log n + k n log n <= n^2 + k n^2 <= ((n+k)log n)^2 + ((n+k)log n)^3
$
Tale espressione è un polinomio nella lunghezza dell'input $(n+k) log n$. Di conseguenza, la MdT costruita opera effettivamente in tempo polinomiale.

#observation()[
  per una MdT deterministica il numero di assegnamenti da generare e verificare sarebbe invece esponenziale, poiché si dovrebbero generare e testare tutte le possibili combinazioni.
]


//16.04.2026
#theorem("Teorema di Cook")[
  SAT è NP-difficile.
  #observation()[
    Vista la complessità della dimostrazione, all'orale viene spesso chiesto solo qualche passaggio.
  ]
]
#proof()[
  Vogliamo dimostrare che $forall L in "NP"$, esiste una riduzione polinomiale da $L$ a $S A T$. Dire che $L in "NP"$ equivale a considerare una $M d T$ $M$ non deterministica polinomiale che accetta $L$. Sia $p(n) = t_(C M)(n)$ (cioè $p(n)$ è la complessità della macchina di Turing $M$). Per semplicità, supponiamo che $forall$ stringa $w$ di lunghezza $n$, il numero di transizioni di $M$ su $w$ sia esattamente $p(n)$ e che $M$ sia una $M d T$ standard limitata a sinistra con le celle numerate.

  Voglio trovare una funzione $Phi$ che associa ad una stringa $w$ un polinomio booleano $Phi(w)$ tale che, data una stringa $w$, $M$ accetta $w$ se e solo se $Phi(w)$ è un polinomio booleano in forma $C N F$ soddisfacibile.
  Gli stati di $M$ sono ${q_1, dots, q_s}$, quelli finali sono indicati con $F$, mentre l'alfabeto di $M$ è ${a_1, dots, a_r}$.

  Le variabili di $Phi(w)$ (con $w$ lungo $n$) sono di tre tipi:
  - $S(u, t) arrow$ assegnare valore 1 significa che all'istante $t$ la $M d T$ si trova nello stato $q_u$;
  - $C(i, j, t) arrow$ assegnare valore 1 significa che all'istante $t$, nella cella $i$ della $M d T$ c'è il simbolo $a_j$;
  - $L(i, t) arrow$ assegnare valore 1 significa che all'istante $t$ la testina si trova nella cella $i$;

  Con $t in {0, 1, 2, dots, p(n)}$, $u in {1, dots, s}$, $i in {0, 1, dots, p(n) + 1}$ e $j in {1, dots, r}$.

  Descriviamo ora le proprietà che caratterizzano una computazione accettante di $M$ su $w$:

  1. $forall t, exists! u$ t. c. $S(u, t) = 1$
  In un certo istante $t$, $M$ si troverà in esattamente uno solo stato.

  2. $forall t, forall i, exists! j$ t. c. $C(i, j, t) = 1$
  In un certo istante $t$, In ogni cella è presente esattamente un solo letterale.

  3. $forall t, exists! i$ t. c. $L(i, t) = 1$
  In un certo istante $t$, la testina indicherà una sola cella $i$.

  4. $t= 0 arrow$ configurazione iniziale
  All'inizio della computazione, la testina è posizionata sulla prima cella del nastro; tale cella è vuota e quelle a seguire contengono il polinomio in input; $M$ si trova in uno stato iniziale.

  5. $exists S(u, p(n))$ t. c. $q_u in F$ e $S(u, p(n)) = 1$
  Nell'istante $t= p(n)$ , cioè a fine computazione (poiché le computazioni transizioni sono al massimo esattamente $p(n)$), $M$ si troverà in uno stato finale, quindi alla variabile $S$ si assegna il valore 1.

  6. $forall t, forall i, L(i, t) = 0 => C(i, j, t) = C(i, j, t+ 1), forall j$
  Se la testina non è posizionata sulla cella $i$ all'istante $t$, allora nell'istante successivo $t+ 1$ il simbolo $a_j$ contenuto in tale cella $i$ non varia.

  7. $forall t, forall i, L(i, t) = 1 => S(u, t+ 1), C(i, j, t+ 1), L(i, t+ 1)$ devono assumere opportuni valori.
  Se la testina è posizionata sulla cella $i$ all'istante $t$, allora nell'istante successivo $t+ 1$ occorre assegnare valori opportuni alle variabili per descrivere il comportamento di $M$ in base alla transizione da eseguire.

  Adesso bisogna scrivere un polinomio booleano per ogni proprietà elencata e alla fine si metteranno tutti insieme (nel senso che se ne considererà la congiunzione) a formare un unico polinomio in forma $C N F$.

  Definiamo un polinomio booleano con variabili ${y_1, dots, y_k}$ nel modo seguente:
  $ U(y_1, dots, y_k) = (y_1 or dots or y_k) and.big_(i < j) (y'_i or y'_j) $
  E vale: $U(y_1, dots, y_k) = 1 <=> exists! i : y_i = 1$
  ovvero $U$ è un polinomio che vale 1 se esattamente una variabile ha valore 1 (se ha più variabili con valore 1 il polinomio non è soddisfatto).

  Scriviamo i polinomi booleani per le 7 proprietà:
  1) $and.big_(t=0)^(p(n)) U(S(1, t), S(2, t), dots, S(s, t))$

  2) $and.big_(t,i) U(C(i, 1, t), C(i, 2, t), dots, C(i, r, t))$

  3) $and.big_t U(L(0, t), L(1, t), dots, L(p(n) + 1, t))$

  4) $S(1,0) and L(1,0) and (and.big_(i=2)^(n+1) C(i, w_(i-1), 0)) and C(1,*, 0) and (and.big_(i=n+1)^(p(n)+1) C(i,*, 0))$

  5) $or.big_(q_u in F) S(u, p(n))$

  6) $A_(i,t) = L(i, t) or (and.big_j P(C(i, j, t), C(i, j, t+ 1)))$
  con
  $ P(x, y) = (x' or y) and (x or y'), quad P(x, y) = 1 <=> cases(x= y= 1 "oppure", x= y= 0) $
  Il polinomio finale della proprietà 6 è $and.big A_(i,t)$.

  7) $B_(t,i,u,j) = S(u, t)' or L(i, t)' or C(i, j, t)' or (S(overline(u), t+ 1) and and.big C(i, overline(j), t+ 1) and L(overline(i), t+ 1))$ (questo polinomio non è scritto correttamente)
  Il polinomio finale della proprietà 7 è $and.big_(t,i,u,j) B_(t,i,u,j)$.

  Il polinomio totale è composto dalla congiunzione di tutti questi polinomi. Osserviamo che tutti i polinomi sopra sono in CNF, tranne quello relativo alla proprietà 7, che però può essere trasformato in CNF in tempo polinomiale.
]

#align(center, cetz.canvas(length: 0.8cm, {
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
    content((0, 2.3), text(weight: "bold", size: 1.5em)[NP-C])
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

    // Curva per isolare la piccola porzione superiore dei linguaggi banali
    bezier((-1.4, 2.5), (1.4, 2.5), (0, 3.2))

    // Etichetta interna
    content((0, 0), text(weight: "bold", size: 1.5em)[NP-C])
  })
}))

I due diagrammi illustrano in modo visivo le due possibili soluzioni al problema aperto dell'informatica teorica, *P vs NP*. Il diagramma di sinistra mostra lo scenario più accreditato ($"P" != "NP"$), in cui l'insieme dei problemi verificabili in tempo polinomiale (NP) è rigidamente diviso tra problemi facilmente risolvibili (P), i problemi più complessi in assoluto a cui tutti gli altri sono riconducibili (NP-Completi) e una fascia di mezzo (NP-Intermedi) che non ricade in nessuna delle due. Il diagramma a destra, al contrario, rappresenta lo scenario catastrofico: se venisse dimostrato che $"P" = "NP"$, l'intera struttura collasserebbe e, dato che ogni problema verificabile diventerebbe automaticamente anche facile da risolvere, quasi tutti i problemi in NP coinciderebbero per definizione con la classe degli NP-Completi.


#proposition()[
  Supponiamo che $"P" = "NP"$.\
  Sia $L in "NP"$, con $L eq.not emptyset, overline(L) eq.not emptyset$, allora $L in "NP-C"$

  Per ipotesi: $exists alpha in L$ e $exists beta in.not L$.
]
#proof()[
  $L in "NP"$. Facciamo vedere che $L$ è NP-difficile. \
  Sia $Q in "NP" (equiv "P")$. Descriviamo una riduzione polinomiale da $Q$ a $L$:
  $
    f: w --> cases(alpha "se" w in Q, beta "se" w eq.not Q)
  $
]

#observation()[
  - $emptyset$ non è NP-difficile. Dato $Q in "NP"$, esiste una riduzione polinomiale da $Q$ a $emptyset$? No, in quanto non ci possono essere funzioni che mandano stringhe di $Q$ nel vuoto.
  - $Sigma^*$ non è NP-difficile (motivo analogo). $Q arrow.squiggly.long Sigma^*$
]

#proposition()[
  Se L è NP-difficile e $f$ è una riduzione polinomiale da L a Q $=>$ Q è NP-difficile.
]
#proof()[
  Dato $R in "NP"$, descriviamo una riduzione polinomiale da R a Q
  - Poiché L è NP-difficile e R $in$ NP, $exists g$ riduzione polinomiale da R a L:
  $
    g: Sigma^*_R arrow.long Sigma^*_L quad quad w in R <=> g(w) in L
  $
  - Sappiamo che L è polinomialmente ridotto a Q:
  $
    f: Sigma^*_L arrow.long Sigma^*_Q quad quad w in L <=> f(w) in Q
  $

  Osserivamo che:
  $
    f compose g: Sigma^*_R arrow.long Sigma^*_Q quad quad w in R <=> f(g(w)) in Q
  $
  Inoltre è calcolabile in tempo polinomiale
]

== Problema 3-SAT
#problem("3-SAT")[
  Dato un polinomio booleano $p$ in 3-CNF\*, determinare se $p$ è soddisfacibile.\
  (\*) Ogni clausola contiene esattamente 3 letterali
]
#observation()[
  3-SAT $in$ NP.
]

Facciamo vedere che 3-SAT è NP-difficile. Per fare ciò cercheremo una riduzione polinomiale da SAT a 3-SAT.

Dato $p$ polinomio booleano in CNF ($p = u_1 and u_2 and dots and u_m$ ($u_i$ clausole)) vogliamo costruire un polinomio $tilde(p)$ in 3-CNF.

Le clausole di $p$ possono essere:
- $u = v$ (_v_ letterale; $x,y$ variabili nuove)\
  $tilde(u)= (v or x or y) and (v or x' or y) and (v or x or y') and (v or x' or y')$
  $
    u "soddisfacibile" <=> tilde(u) "soddisfacibile"
  $
- $u = v_1 or v_2 quad quad (x "variabile nuova")$\
  $tilde(u)=(v_1 or v_2 or x) and (v_1 or v_2 or x')$
  $
    u "soddisfacibile" <=> tilde(u) "soddisfacibile"
  $
- $u = v_1 or v_2 or v_3 -> tilde(u) = u$
- $u = v_1 or v_2 or dots or v_n quad quad (n >= 4; y_1, dots, y_(n-3) "variabili nuove")$\
  $tilde(u) = (v_1 or v_2 or y_1) and (v_3 or y_1^' or y_2) and dots and (v_j or y_(j-2)^' or y_(j-1)) and dots and (v_(n-2) or y_(n-4)^' or y_(n-3)) and (v_(n-1) or v_n or y_(n-3)^')$

+ u soddisfacibile $=> tilde(u)$ soddisfacibile
  V variabili di $p$\
  sia $t: V --> {0, 1} quad t.c. quad t(u) = 1$\
  sia $v_j$ il primo letterale di u t.c. $t(v_j) = 1$\
  sia $accent(t, tilde): V union {y_1, dots, y_(n-3)} --> {0, 1}$ come segue:
  $
    accent(t, tilde)(x) = cases(t(x) quad quad&"se" x in V, 1 &"se" x = y_1\, dots\, y_(j-2), 0 &"se" x=y_(j-1)\, dots\, y_(n-3))
  $
+ $tilde(u) "soddisfacibile" => u "soddisfacibile"$\
  sia $accent(t, tilde): V union {y_1, dots, y_(n-3)} -->{0, 1} quad quad t.c. quad accent(t, tilde) (tilde(u))=1$\
  sia $t = accent(t, tilde)_(|V)$\
  Si dimostra che $t(u) = 1$

== Problema del Vertex Cover (VC)

#definition()[
  Dato $G=(V, E)$ grafo non orientato, un *vertex cover* di G è un sottoinsieme $c subset.eq V$ t.c. $forall{x,y} in E, x in C "oppure" y in C$
]
#problem()[
  Dato G grafo non orientato e $k in NN$, esiste un VC $C "di" G$ con $abs(C) = k?$
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
    & p=(u_(1,1) or u_(1,2) or u_(1,3)) and (u_(2,1) or u_(2,2) or u_(2,3)) and dots and (u_(m,1) or u_(m,2) or u_(m,3)) \
    & p=(x_1 or x'_2 or x_3) and (x'_1 or x_2 or x'_4)
  $

  $V = {x_1, dots, x_n}$ insieme delle variabili di $p$, $|V| = n$ e $m =$ numero di clausole di $p$.

  Costruiamo un grafo non orientato $G(p)$ nel seguente modo:
  - Scriviamo un nodo per ogni variabile del polinomio e un nodo per ogni negazione di variabile;
  - Colleghiamo ogni coppia variabile-variabile negata con un lato;
  - Scriviamo un nodo per ogni letterale di ogni clausola;
  - Colleghiamo con 3 lati i 3 letterali di ogni clausola;
  - Aggiungiamo lati tra i due insiemi di nodi, collegando le variabili o variabili negate ai letterali delle clausole corrispondenti.

  #example()[
    $
      p = (x_1 or x'_2 or x_3) and (x'_1 or x_2 or x'_4)
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

  In un vertex cover di $G(p)$ ci devono essere almeno $n+2m$ vertici.
  // TODO: ricontrolla cardinalità
  Facciamo vedere che $p$ è soddisfacibile $<=> G(p)$ ha un vertex cover di cardinalità $n+2m = k(p)$

  $==>)$ Sia $t$ assegnamento t.c. $t(p) = 1$

  - $forall i = 1, dots, n$ scegliamo $cases(x_i &"se" t(x_i) = 1, x'_i &"se" t(x'_i) = 0)$

  - Per ogni clausola, individuiamo un letterale che soddisfa la clausola e scegliamo i rimanenti 2 (quindi in tutto scelgo 2 nodi su 3 per ogni clausola $=> 2m$).

  #example()[
    Riprendiamo l'esempio di prima e diamo i seguenti valori alle variabili: $x_1 -> 1, x_2 -> 0, x_3 -> 1, x_4 -> 0$. Allora:
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
  Allora l'insieme di vertici così definito (di cardinalità $n+2m$) è un vertex cover di $G(p)$.

  $<==)$ $G(p)$ ha un V C di cardinalità $n+ 2m$, allora voglio definire $t: {x_1, dots, x_n} -> {0,1}$ che soddisfi $p$:
  $
    t(x_i) = cases(
      1 & "se" x_i "sta nel" V C,
      0 & "se" x'_i "sta nel" V C
    )
  $
  Con questo assegnamento, ogni clausola è soddisfatta dal letterale corrispondente al nodo $in.not V C$ di ogni "triangolo" (insieme di tre letterali $u_(i,0), u_(i,1), u_(i,2)$).
]



== Problema di Clique

#problem("Clique")[
  Dato un grafo non orientato $G$ e un intero $k$, determinare se esiste un sottografo completo di $G$ avente $k$ vertici.
]

#proposition()[
  Il problema Clique $in$ NP.
]

#proposition()[
  Il problema Clique è NP-difficile
]

#proof()[
  Troviamo una riduzione polinomiale da 3-SAT a Clique. Sia $p$ un polinomio booleano in 3-CNF con $k$ clausole:
  $
    & p = u_1 and u_2 and dots and u_k quad quad quad quad quad quad && | (x_1 or x_2^' or x_3) and (x_1^' or x_2 or x_4^') \
    & u_i = (u_(i, 2) or u_(i, 2) or u_(i, 3))                       && |
  $

  Costruiamo un grafo $G(p) = (V, E)$  in cui c'è un vertice per ogni letterale di $p$ e tale che:
  - Non ci siano lati tra letterali della stessa clausola;
  - Non ci sia un lato tra due letterali opposti ($x_i$ e $x'_i$);
  - C'è un lato fra ogni altra coppia di vertici.

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


  $p$ è soddisfacibile $<=> G(p)$ ha un sottografo completo di cardinalità $k$.

  $==>$) Sia $t$ un assegnamento di valori alle variabili che soddisfa $p$.
  Quindi, $forall i <= k$ (cioè per ogni clausola), $t(u_i) = 1$.
  Dunque $forall i <= k, exists j in {1, 2, 3} : t(u_(i,j)) = 1$.

  Nel grafo $G(p)$, $forall i <= k$ scelgo $u_(i,j)$ letterale soddisfatto (cioè in tutto scelgo $k$ vertici su $k$ clausole, ovvero uno in ogni clausola). $forall$ coppia di vertici scelti $x$ e $y$, c'è il lato ${x, y}$ perché $t(x) = t(y) = 1$, dunque $x eq.not y'$ (e, naturalmente, i due vertici $x$ e $y$ rappresentano letterali appartenenti a due clausole diverse).
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

  $<==)$ Sia ${v_1, dots, v_k}$ sottografo completo di $G(p)$. $forall i=1,dots,k$, sia $u^((i))$ il letterale associato a $v_i$; Definiamo un assegnamento $t$ t.c. $t(u^((i))) = 1$.
  - $t$ è ben definito;
  - $t$ soddisfa $p$.

  $G(p)$ ha un sottografo completo di cardinalità $k$:
  (Scelgo sempre 1 vertice per ogni clausola, poiché due vertici appartenenti alla stessa clausola non possono essere collegati).
  Dobbiamo definire $t$ che soddisfi $p$. Per ogni vertice scelto $x$, poniamo $t(x) = 1$. Poiché i vertici selezionati determinano un sottografo completo, non ho coppie del tipo $x, x'$, e dunque l'assegnamento $t$ è ben definito.

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
]

== Problema HAM

#proposition()[
  Il problema del circuito hamiltoniano è NP-difficile ($("HAM") in "NP"$)
]

#proof()[
  Descriviamo una riduzione da 3-SAT a HAM. Sia $p$ un polinomio booleano in 3-CNF:
  $
    p = u_1 and u_2 and dots and u_m, quad u_i = (u_(i,1) or u_(i,2) or u_(i,3))
  $
  Con $V = {x_1, dots, x_n}$ variabili di $p$, $x_i$ variabile di $p$. Si introducono quattro categorie di nodi: _t_ (true), _f_ (false), $e_i$ (entrata), $o_i$ (output). Per ogni variabile $x_i$ si crea un grafo formato nel seguente modo:
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
    grid.cell(rowspan: 2, [
      - Esiste un arco tra un vertice $t_(i,j)$ e un vertice $f_(i, j+1)$ e un arco tra un vertice $f_(i,j)$ e un vertice $t_(i,j+1)$;
    ]),
    grid.cell(rowspan: 2, [- Esiste un arco da $t_(i,j)$ a $f_(i,j)$ e viceversa;]),
    grid.cell(rowspan: 2, [- con $r_i$ = massimo fra le occorrenze di $x_i "e" x_i^'$ in _p_.]),
  )

  I pezzi di grafo così costruiti si connettono aggiungendo un lato da $o_i "a" c_(i+1)$, per ogni $i$, infine si aggiunge un lato da $o_n "a" e_1$.
  Essendo che ogni variabile ha 2 camini hamiltoniani da $e_j "a" o_j$:
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

  Per cui si hanno in totale $2^n$ circuiti hamiltoniani nel grafo rappresentato sotto.

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

  Si ha quindi $u_j=(u_(j, 1) or u_(j, 2) or u_(j, 3))$, si inseriscono i nodi $i n_(i, j)$ e $o u t_(i, j)$

  #grid(
    columns: (0.5fr, 0.5fr),
    align: (center, center + horizon),

    [#align(center, cetz.canvas(length: 25pt, {
      import cetz.draw: *
      set-style(mark: (fill: black, scale: 1))
      set-style(content: (padding: 0.2))
      set-style(line: (padding: 0.2))
      let dx = 3 // Distanza orizzontale tra i nodi
      let y-in = 2.5 // Altezza della riga "in"
      let y-out = 0 // Altezza della riga "out"

      // Riga superiore (in)
      content((0, y-in), text(size: 1.4em, $"in"_(j,1)$), name: "in1")
      content((dx, y-in), text(size: 1.4em, $"in"_(j,2)$), name: "in2")
      content((2 * dx, y-in), text(size: 1.4em, $"in"_(j,3)$), name: "in3")

      // Riga inferiore (out)
      content((0, y-out), text(size: 1.4em, $"out"_(j,1)$), name: "out1")
      content((dx, y-out), text(size: 1.4em, $"out"_(j,2)$), name: "out2")
      content((2 * dx, y-out), text(size: 1.4em, $"out"_(j,3)$), name: "out3")

      // Frecce verticali in ingresso dall'alto
      line((0, y-in + 1.5), "in1", mark: (end: ">"))
      line((dx, y-in + 1.5), "in2", mark: (end: ">"))
      line((2 * dx, y-in + 1.5), "in3", mark: (end: ">"))

      // Frecce verticali in uscita verso il basso
      line("out1", (0, y-out - 1.5), mark: (end: ">"))
      line("out2", (dx, y-out - 1.5), mark: (end: ">"))
      line("out3", (2 * dx, y-out - 1.5), mark: (end: ">"))

      // Frecce verticali interne (da "in" a "out")
      line("in1", "out1", mark: (end: ">"))
      line("in2", "out2", mark: (end: ">"))
      line("in3", "out3", mark: (end: ">"))

      // Frecce orizzontali sulla riga superiore (verso destra)
      line("in1", "in2", mark: (end: ">"))
      line("in2", "in3", mark: (end: ">"))

      // Frecce orizzontali sulla riga inferiore (verso sinistra)
      line("out3", "out2", mark: (end: ">"))
      line("out2", "out1", mark: (end: ">"))

      let cut = 1

      // Freccia curva superiore (da in3 a in1, passa "sotto" i nodi)
      bezier("in3", "in1", (dx, y-in - 1.2), mark: (end: ">"), shorten-start: cut, shorten-end: cut)

      // Freccia curva inferiore (da out1 a out3, passa "sopra" i nodi)
      bezier("out1", "out3", (dx, y-out + 1.2), mark: (end: ">"), shorten-start: cut, shorten-end: cut)
    }))],
    //TODO: aggiustare sta merda
    [Ne serve uno per ogni clausola $u_j$],
  )
  #example()[
    Consideriamo:
    $
      p = (x_1 or x_2 or x_3^') and (x_1^' or x_2 or x_4^') and (x_1 or x_2^' or x_4) and (x_1^' or x_3 or x_4)
    $
    Devo sapere quanti nodi vanno scritti, sapere quindi quanto vale $r_i$ (massimo delle occorrenze di $x_i "e" x_i^' "in" p$). Esempio per $x_1$: $x_1$ appare 2 volte, $x_1^'$ appare 2 volte $==> r_i = 2 ==>$ sono 3 nodi $0, 1, 2$.
    #figure(image("/assets/image-17.png", width: 75%))
  ]
]

#align(center, cetz.canvas(length: 20pt, {
  import cetz.draw: *

  // Stile globale
  set-style(content: (padding: 0.2)) // Allontana le frecce dai testi
  set-style(mark: (fill: black, scale: .4))

  // ==========================================
  // 1. Macro per disegnare i gadget "Diamante"
  // ==========================================

  let draw-diamond(cx, cy-e, id, rows) = {
    let dx = 2.5 // Larghezza del diamante

    // Nodo iniziale e_i
    let name-e = "e" + id
    content((cx, cy-e), text(size: 1.4em, weight: "bold", $e_#id$), name: name-e)

    // Generazione delle righe (t e f)
    for k in range(rows + 1) {
      let y = cy-e - 1.5 - k * 1.5
      content((cx - dx, y), text(size: 1.3em, $t_{#id,#k}$), name: "t" + id + "_" + str(k))
      content((cx + dx, y), text(size: 1.3em, $f_{#id,#k}$), name: "f" + id + "_" + str(k))
    }

    // Nodo finale o_i
    let name-o = "o" + id
    let y-end = cy-e - 1.5 - (rows + 1) * 1.5
    content((cx, y-end), text(size: 1.4em, weight: "bold", $o_#id$), name: name-o)

    // --- Disegno degli spigoli ---
    line(name-e, "t" + id + "_0", mark: (end: ">"))
    line(name-e, "f" + id + "_0", mark: (end: ">"))

    let m = 0.6 // Margine per le doppie frecce orizzontali
    for k in range(rows + 1) {
      let y = cy-e - 1.5 - k * 1.5
      // Frecce orizzontali
      line((cx - dx + m, y + 0.1), (cx + dx - m, y + 0.1), mark: (end: ">"))
      line((cx + dx - m, y - 0.1), (cx - dx + m, y - 0.1), mark: (end: ">"))

      // Frecce incrociate
      if k < rows {
        line("t" + id + "_" + str(k), "f" + id + "_" + str(k + 1), mark: (end: ">"))
        line("f" + id + "_" + str(k), "t" + id + "_" + str(k + 1), mark: (end: ">"))
      }
    }

    line("t" + id + "_" + str(rows), name-o, mark: (end: ">"))
    line("f" + id + "_" + str(rows), name-o, mark: (end: ">"))
  }

  // ==========================================
  // 2. Posizionamento dei 4 Gadget Variabile
  // ==========================================

  // (Centro X, Altezza nodo e, ID, numero di righe)
  draw-diamond(0, 15, "1", 2) // x1 (Top-Left)
  draw-diamond(0, 6, "2", 2) // x2 (Bottom-Left)
  draw-diamond(16, 15, "3", 1) // x3 (Top-Right)
  draw-diamond(16, 6, "4", 2) // x4 (Bottom-Right)

  // // ==========================================
  // // 3. Disegno del Gadget Clausola (J=1)
  // // ==========================================

  let y-in = 8.5
  let y-out = 6.5

  content((5.5, y-in), text(size: 1.4em, weight: "bold", $"in"_{j,1}$), name: "in_1")
  content((8.0, y-in), text(size: 1.4em, weight: "bold", $"in"_{j,2}$), name: "in_2")
  content((10.5, y-in), text(size: 1.4em, weight: "bold", $"in"_{j,3}$), name: "in_3")

  content((5.5, y-out), text(size: 1.4em, weight: "bold", $"out"_{j,1}$), name: "out_1")
  content((8.0, y-out), text(size: 1.4em, weight: "bold", $"out"_{j,2}$), name: "out_2")
  content((10.5, y-out), text(size: 1.4em, weight: "bold", $"out"_{j,3}$), name: "out_3")

  // // Frecce verticali Clausola
  line("in_1", "out_1", mark: (end: ">"))
  line("in_2", "out_2", mark: (end: ">"))
  line("in_3", "out_3", mark: (end: ">"))

  // // Frecce orizzontali Clausola (con margine per non toccare il testo)
  let mc = 0.8
  line((5.5 + mc, y-in), (8.0 - mc, y-in), mark: (end: ">"))
  line((8.0 + mc, y-in), (10.5 - mc, y-in), mark: (end: ">"))

  line((10.5 - mc, y-out), (8.0 + mc, y-out), mark: (end: ">"))
  line((8.0 - mc, y-out), (5.5 + mc, y-out), mark: (end: ">"))

  // // Frecce Curve Clausola
  let cut = 0.5
  bezier("in_3", "in_1", (8.0, y-in - 1.2), mark: (end: ">"), shorten-start: cut, shorten-end: cut)
  bezier("out_1", "out_3", (8.0, y-out + 1.2), mark: (end: ">"), shorten-start: cut, shorten-end: cut)


  // // ==========================================
  // // 4. Collegamenti Main Spine (Lo scheletro)
  // // ==========================================

  line("o1", "e2", mark: (end: ">"))
  line("o3", "e4", mark: (end: ">"))

  // o2 -> e3 (passa in mezzo, x = 3.8)
  line("o2", (0, -1.5), (3.8, -1.5), (3.8, 16.0), (16, 16.0), "e3", mark: (end: ">"))

  // o4 -> e1 (back edge grande a sinistra, x = -7.0)
  line("o4", (16, -4.0), (-7.0, -4.0), (-7.0, 17.0), (0, 17.0), "e1", mark: (end: ">"))


  // // ==========================================
  // // 5. Routing Variabili <-> Clausola
  // // ==========================================

  // x1 <-> Clausola
  line("f1_0", (3.2, 13.5), (3.2, 9.5), (5.5, 9.5), "in_1", mark: (end: ">"))
  line("out_1", (5.5, 5.5), (4.8, 5.5), (4.8, 12.0), "f1_1", mark: (end: ">"))

  // // x2 <-> Clausola
  // line("t2_1", (-4.5, 3.0), (-4.5, 10.0), ("in_2.x", 10.0), "in_2", mark: (end: ">"))
  // line("out_2", ("out_2.x", 5.0), (-5.5, 5.0), (-5.5, 1.5), "t2_2", mark: (end: ">"))

  // // x3 <-> Clausola
  // line("f3_0", (20.0, 13.5), (20.0, 10.5), ("in_3.x", 10.5), "in_3", mark: (end: ">"))
  // line("out_3", ("out_3.x", 5.5), (12.0, 5.5), (12.0, 12.0), "f3_1", mark: (end: ">"))


  // // ==========================================
  // // 6. Testi e Annotazioni a mano
  // // ==========================================

  // content((-1.5, 16), text(size: 1.2em, style: "italic")[Scegli un percorso in\nbase ai valori di $x_i$])

  // content((-2.5, 15), text(size: 1.5em, weight: "bold")[$x_1: 0$])
  // content((-2.5, 6), text(size: 1.5em, weight: "bold")[$x_2: 0$])
  // content((13.5, 15), text(size: 1.5em, weight: "bold")[$x_3: 1$])
  // content((13.5, 6), text(size: 1.5em, weight: "bold")[$x_4:$])

  // content((11.5, 7.5), text(size: 1.4em, weight: "bold")[$J=1$])
  // content((17.5, 0), text(size: 1.4em, weight: "bold")[$=m$])
}))

== Problema 2-SAT
#problem()[
  Dato un polinomio booleano $p$ in CNF in cui ogni clausola contiene esattamente 2 letterali, esiste un assegnamento di valori delle variabili che soddisfa $p$?
]

#proposition()[
  Il problema 2-SAT $in$ P.
]
Vediamo come costruire il grafo associato a $p$. Sia $p = u_1 and u_2 and dots and u_s " con " u_i = u_(i, 1) or u_(i, 2)$ un polinomio booleano in 2-CNF. Costruiamo un grafo orientato $G(p)$ nel seguente modo:
- Vertici: $forall x$ variabile che compare in _p_, si scrivono i nodi $x "e" x'$ (2 vertici)
- Archi: $forall "clausola" u_i$, 2 archi: $cases(u_(i, 1)^' --> u_(i, 2), u_(i, 2)^' --> u_(i, 1))$

#example()[
  $
    p = (x'_1 or x_2) or (x_1 or x_3) and (x_2 or x'_3) "in" {x_1,x_2,x_3}
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
]

#lemma()[
  _p_ è soddisfacibile $<==> exists.not x "variabile di" p "ale che in" G(p) space x arrow.squiggly.long x' " e " x' arrow.squiggly.long x$
]

#proof()[\
  $==>)$ Sia _x_ t.c. $x arrow.squiggly.long x' " e " x' arrow.squiggly.long x$. Facciamo vedere che _p_ non è soddisfacibile. Sia _t_ assegnamento:
  - $t(x) = 1$, quindi

    $&x --> gamma_1 --> gamma_2 --> dots &&dots dots &&alpha --> &&beta space dots --> gamma_(n-1) --> gamma_n --> &&x'\
    &t(x)=1 &&t(alpha)&&=1 &&t(beta) = 0 &&t(x') = 0$\
    In _p_ c'è la clausola $alpha' or beta$ che non è soddisfatta da _t_

  $<==)$ Senza perdita di generalità, supponiamo che $exists alpha$ letterale t.c. in _p_ compaiono sia $alpha$ che $alpha'$ (altrimenti _p_ sarebbe banalmente soddisfacibile).
  Se, per assurdo, $forall alpha$ letterale t.c. $alpha, alpha'$ compaiono in _p_, $alpha arrow.long.squiggly alpha'$, allora, se $beta$ è uno di questi letterali, $cases(beta arrow.long.squiggly beta', beta' arrow.long.squiggly beta)$. Questo è assurdo perché contro l'HP.

  Pertanto $exists alpha$ letterale di _p_ t.c. $alpha'$ è anch'esso letterale di _p_ e $alpha cancel(arrow.long.squiggly) alpha'$

  Dato un letterale $alpha$, cominciamo a definire l'assegnamento _t_ ponendo:
  - $t(alpha) = 1$
  - $forall beta " t.c. " alpha arrow.long.squiggly beta, t(beta) = 1$
  Osserviamo che fin qui _t_ è ben definito, perché non può accadere che $t(beta') = 1$, in quanto $alpha cancel(arrow.long.squiggly) beta$, infatti, se per assurdo $alpha arrow.long.squiggly beta' ==> beta arrow.long.squiggly alpha'$
]

=== Algoritmo per il problema 2-SAT
+ Costruisco il grafo $G(p)$
+ $forall x$ variabile di _p_, controllo se c'è $x arrow.long.squiggly x' " e " x' arrow.long.squiggly x$:
  - Se sì, allora _p_ non è soddisfacibile;
  - Altrimenti _p_ è soddisfacibile

Tale algoritmo ha complessità in tempo polinomiale, in quanto consiste essenzialmente nell'esecuzione di un algoritmo di ricerca in ampiezza (opportunamente modificato).

== Linguaggi NP-intermedi

Se $"P" eq.not "NP":$
#definition()[
  I linguaggi NP-intermedi (o NP-I) sono linguaggi di NP che non stanno né in P né in NP-completi (o NP-C).

  $"NP-I" = "NP" \\ ("P" union "NP-C")$
]
#theorem("Ladner")[
  Se $"P" eq.not "NP, allora NP-I" eq.not emptyset$
]
P è chiuso rispetto alla complementazione.
#problem("Aperto")[
  NP è chiusa per complementazione?
  $ "co-NP = NP?" $
]
#definition()[
  co-NP $= {L "linguaggi" | L' in "NP"}$
]


#example()[
  #underline("UNSAT"): Dato un polinomio booleano _p_, determinare se _p_ *non*
  è soddisfacibile:
  $
    L_("UNSAT") in "co-NP"
  $
]

#proposition()[
  Se fosse dimostrato NP $eq.not$ co-NP $==>$ P $eq.not$ NP
]
#proof()[\
  $
    "P" eq.not "NP" <== cases("NP" eq.not "co-NP", "P" = "co-NP")
  $
]

#proposition()[
  Supponiamo che esista un linguaggio $L$ tale che $L in$ NP-C e $L in$ co-NP $==>$ NP $=$ co-NP.
]
#proof()[
  #rect($"co-NP" subset.eq "NP"$)
  $Q in "co-NP" ==> Q' in "NP"$

  Poiché $L in "NPC", exists f$ riduzione polinomiale da $Q' "a" L$, osserviamo che _f_ è anche riduzione polinomiale da $Q "a" L' in "NP"$

  Algoritmo polinomiale non deterministico per decidere $Q$: data $w$,
  - Calcolo $f(w)$
  - Decido se $f(w) in L'$
  Pertanto $Q in "NP"$


  #rect($"NP" subset.eq "co-NP"$)
  $Q in "NP" ==> Q' in "co-NP" ==> Q' in "NP" ==> Q in "co-NP"$
]

== Test di primalità
#proposition()[
  _n_ composto $==> exists d | n, " con " d in [2, sqrt(n)]$
]

#proof()[
  $n = m_1 dot m_2$\
  Se per assurdo $m_1, m_2 > sqrt(n)$ allora $n = m_1 dot m_2 > n$ ma $m_1 dot m_2 = n$ (assurdo)
]

=== Algoritmo deterministico

Dato $n in NN$, per ogni $d in [2, sqrt(n)]$ controllo se $d | n$:
- se sì: $n$ composto;
- altrimenti, $n$ primo

La complessità dell'algoritmo rispetto alla lunghezza _l_ è almeno la seguente:
$
  Omega(sqrt(n)) = Omega(2^(l/2))
$

=== Codifica binaria di $n$
$
    & log n =    && l-->"parametro per la complessità" \
    & " "arrow.t && arrow.t \
  n & = 2^l      && "Lunghezza della codifica binaria di "n
$

=== Piccolo teorema di Fermat
+ $ a^p equiv a quad (p) <== cases(delim: "[", p "primo", a in NN) $
+ $ a^(p-1) equiv 1 quad (p) <== cases(delim: "[", p "primo", a in NN, (a, p) = 1) $

=== Algoritmo non deterministico #underline("non corretto") polinomiale

Dato $n in NN$:
- genero non deterministicamente $a in NN "t.c. "(a, n) = 1$
- se $a^(n-1) equiv 1 quad (n)$, allora $n$ primo
- altrimenti, $n$ composto

Questo algoritmo applica il teorema di Fermat al contrario (ovviamente non vale) e pertanto non è corretto.

Esiste un algoritmo per calcolare le potenze modulari $a^n$ con complessità:
$ Omicron(log n^2) = Omicron(l^2) $

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
  Il numero dion congruenze da controllare è quindi inferiore.
]
Testare la condizione del piccolo teorema di Fermat per un certo numero di $a$. ?

#definition()[
  $n in NN$ si dice *numero di Carmichael* quando $forall a in NN, (a, n) = 1$, vale $a^(n-1) equiv 1 quad (n)$ e $n$ non è primo.
]

#example()[
  561 è un numero di carmichael. $561 = 3 dot 11 dot 17$
]

#theorem("Alford, Granville, Pomerance")[
  Esistono infiniti numeri di Carmichael.
]

#underline("Idea"): modifichiamo il piccolo teorema di Fermat.
#theorem("Agrawal")[
  Sia $n in NN, a in NN$ con $n>=2$ e $(a, n) = 1$:
  $
    n "primo" <==> (x + a)^n equiv x^n + a quad (n)
  $
]

#proof()[\
  $==> )$ $n$ primo (congruenze tutte modulo $n$):
  $
    (x + a)^n = sum_(k=0)^n binom(n, k)a^(n - k)x^k equiv x^n + a^n equiv x^n + a quad (n)\
    binom(n, k) = (n!)/(k!(n - k)!) = (n dot (n - 1) dot dots dot (n - k + 1))/(k!) quad quad 0 < k < n --> n bar binom(n, k)
  $
  $<== )$ $n$ composto. Facciamo vedere che $exists k "con" 0 < k <= n$,
  $
    n cancel(inverted: #true, bar) binom(n, k)
  $
  Sia $p | n, p "primo"$:
  $
    &p^alpha | n, "ma" p^(alpha + 1) cancel(inverted: #true, bar) quad quad quad quad binom(n, p) = (n dot (n - 1) dot dots dot (n - p + 1))/(p dot (p - 1) dot dots dot 2 dot 1)\
    &p^alpha "divide il numeratore", quad p^(alpha + 1) "non divide il numeratore"\
  $
  $
    p^alpha cancel(inverted: #true, bar) binom(n, p) ==> n cancel(inverted: #true, bar) binom(n, p)
  $
]

Le congruenze da testare sono circa $n = 2^l$.\
#underline("IDEA"): dividere i polinomi per $x^r - 1$, per opportuno $r$. #underline("Agrawal, Kayac, Saxena (2002)") hanno dimostrato che:
- Se _n_ è composto e si sceglie un _r_ "giusto", allora è sufficiente testare la seguente congruenza per "pochi" _a_:
$
  (x+a)^n equiv x^n + a quad (n, x^r - 1)
$
e ne trovo uno per cui non vale.

// SONO ESERCIZI SVOLTI A LEZIONE
// Volendo vedi appunti sgambe

== Classi di complessità

=== Linguaggi esponenziali

Si definiscono come:
$
  "Exp" = {L | exists M "MdT deterministica che accetta" L "t.c." t_C_M (n) = Omicron(2^n^k) "per qualche" k >= 1}
$

#observation(multiple: true)[
  - $L in "Exp" <==> exists M$ MdT deterministica che accetta $L$ t.c. $t_(C_M)(n) = Omicron(c^(p(n)))$, per opportuni $c > 1$ e $p(n)$ polinomio di grado $>= 1$ (sennò sarebbe costante).
  - $"P" subset.eq "Exp"$
]

#proposition()[
  $"NP" subset.eq "Exp"$
]
#proof()[
  $L in "NP"$, $M$ MdT non deterministica che accetta $L$ t.c. $t_(C_M)(n) = O(n^k)$ (è polinomiale). Sia $delta$ il grado di non determinismo di $M$ (ovvero il massimo numero di transizioni associate a una coppia stato-simbolo letto). Posso costruire una MdT $N$ deterministica che accetta $L$ eseguendo tutte le possibili computazioni di $M$ su una stringa $w$.

  Codifica delle computazioni di $M$ su $w$ di lunghezza $n$:
  $
    (m_1, m_2, dots, m_(n^k)) quad "dove" quad m_i in {1, dots, delta}
  $

  Il numero di transizioni di una singola computazione è $O(n^k)$, mentre il numero delle possibili computazioni è $delta^(n^k) => t_(C_N)(n) = O(n^k dot delta^(n^k))$ per cui $L in "Exp"$.
]

#problem("Aperto")[
  Ancora non si sa se le inclusioni sono strette o no:
  $
    "P" limits(subset.eq)^? "NP" limits(subset.eq)^? "Exp"
  $
]

#proposition()[
  $"P" subset "Exp"$
]

#proof()[
  Facciamo vedere che $exists L in "Exp", L in.not "P"$
  $
    & L = {(M)x | "se M su x termina in uno stato finale ciò avviene entro" 2^(2|x|) "passi"}
  $
  1. L $in$ Exp\
    N MdT su input $R(M)x$:
    - Esegue M su x
      - Se M termina in uno stato finale entro $2^(2|x|)$ transizioni, accetta;
      - Altrimenti, rifiuta
    N accetta L

    *Complessità in tempo di N*\
    $
      |underbracket(R(M), "corto")underbracket(x, "lungo")|
    $
    Per avere il caso peggiore, considero $|R(M)|$ corta rispetto a $|x|$, in modo tale che $|R(M)x|n space |x|$

    $
      T_C_N (n) = Omicron(2^(2n)) arrow.long.squiggly L in "Exp"
    $

    #observation()[
      $2^(2n) in.not Omicron(2^n)$ ?? TODO: completare
    ]

  + L $in.not$ P\
    Facciamo vedere che $exists.not$N MdT deterministica che accetta L t.c. $t_C_N (n) = Omicron(2^n)$

    #underline("Per assurdo"): sia MdT deterministica che accetta L per stati finali t.c. $t_C_N (n) = 2^n$\

    Sia D MdT definita come segue:\
    $quad$ Su input R(M):
    - Esegue N su R(M)R(M)
      - Se N termina in uno stato finale, D termina in uno stato non finale;
      - Se N termina in uno stato non finale, D termina in uno stato finale;

    Complessità in tempo di D:
    $
      |R(M)| = n\
      t_C_D (n) = t_C_N (2n) = 2^n
    $
    Eseguiamo D su R(D):
    + D su R(D) termina in uno stato finale $==>$ per definizione di D, N su R(D)R(D) termina in uno stat non finale $==>$ dato che N è una MdT che accetta L e R(D)R(D) non appartiene al linguaggio, D su R(D) non termina in unno stato finale entro $2^(2|R(D)|)$ transizioni $==>$ dato che $t_C_D (n) = 2^(2n)$, D su R(D) non termina in uno stato finale $==>$ *ASSURDO*\

    + D su R(D) termina in uno stato non finale $==>$ per definizione di D, N su R(D)R(D) termina in uno stato finale $==>$ dato che N è una MdT che accetta L, D su R(D) termina in uno stato finale entro $2^(2|R(D)|)$ transizioni $==>$ *ASSURDO*
]

Definisco un'altra classe di linguaggi esponenziali:
$
  "NExp" = { L "linguaggio" | exists"M MdT non deterministica che accetta "L "t.c." t_C_M (n) = Omicron(2^n^k), exists k >= 1}
$

#observation()[
  $ "Exp" subset.eq "NExp" $
]

#problem("Aperto")[
  $ "Exp" = "NExp" $
]

#proposition()[
  Se si dimostra che Exp $eq.not$ NExp, allora P $eq.not$ NP
]

#proof()[
  Facciamo vedere che $"P" = "NP" ==> "Exp" = "NExp"$.\
  Faremo vedere che NExp $subset.eq$ Exp\

  Sia $L in "Nexp"$ e M MdT non deterministica che accetta $L$ t.c. $t_C_M (n) = Omicron(2^n^k)$
  $
    accent(L, tilde) = {x & 1^2^(|x|^k) | x in L} quad quad quad (1 in.not "alfabeto di" L) \
                          & arrow.t \
                          & "Tanti 1 quanti la complessità di L"
  $
  Facciamo vedere che $accent(L, tilde) in "NP"$. Sia N MdT non deterministica che accetta $accent(L, tilde)$:
  - Dato y, controllo se $exists z "t.c." y = z 1^2^(|z|^k)$, altrimenti rifiuto;
  - Se il controllo è passato, eseguo M su z e, in più al $2^(|z|^k)$ passi, decido se  $z in L$ oppure no.

  La complessità in tempo di N è polinomiale in $|y|$ (lunghezza di _y_). Quindi $accent(L, tilde) in "NP"$\
  Poiché per ipotesi P $in$ NP $==> accent(L, tilde) in$ P.\
  Dunque $exists R$ MdT deterministica polinomiale che accetta $accent(L, tilde)$. MdT deterministiica per L:
  - Data x, costruisco la stringa $x 1^2^(|x|^k)$;
  - Uso R per stabilire se $y in accent(L, tilde)$.
  Complessivamente, l'algoritmo descritto sopra è esponenziale nella lunghezza di x.
]

== Complessità in spazio di M

#definition()[
  Sia M una MdT a $k+1$ nastri:
  - nastro 1 per l'input (mai modificato);
  - $k$ nastri di lavoro.

  La *complessità in spazio di M* è una funzione:
  $
    s_C_M: NN --> NN
  $
  in cui, $s_C_M (n)$, è il numero di celle sui nastri di lavoro a cui le testine hanno accesso durante una computazione di M su una stringa di lunghezza $n$, nel caso peggiore.
]

#observation(multiple: true)[
  + La definizione vale sia nel caso deterministico che in quello non deterministico;
  + Non è necessario che M termini su ogni input;
  + È possibile che $s_C_M (n) < n$ (a lezione: $s_C_M (n) > 0$)
]

#example()[
  Sial $L$ linguaggio delle palindrome binarie su ${a,b}$. Descriviamo il comportamento di una MdT M che accetta tale linguaggio.

  All'inizio scrivo 1 sul nastro 3, il nastro 2 è vuoto, sul nastro 2 c'è l'input le testine sono a inizio nastro.

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
  - Confronto *$w_i$* con *$w_(n-i)$*, se sono diversi, rifiuto; Altrimenti aggiorno il nastro 3 scrivendo $i+1$ e ricomincio.

  La complessità in spazio di M nel caso peggiore (accettazione) è:\
  Se scrivo i numeri naturali in binario devo scrivere $n+1$ sui nastri 2 e 3, quindi
  $
    s_C_M (n) = 2 dot (ceil(log(n+1))+2)
  $
]

#proposition()[
  Se M MdT a 2 nastri, allora:
  $
    t_C_M (n) = f(n) ==> s_C_M (n) <= f(n) + 1
  $
]
#proof()[
  Nel caso peggiore, M legge una nuova cella sul nastro di lavoro ad ogni transizione, aggiungendo la cella iniziale: $s_C_M (n) <= f(n) + 1$
]

#proposition()[
  Se M MdT a 2 nastri, $|Q| = m, |Sigma| = t$ (cardinalità di insieme degli stati e alfabeto):
  $
    s_C_M (n) = f(n) ==> t_C_M (n) <= m(n+2)f(n)t^f(n)
  $
]
#proof()[
  Poiché M termina su ogni input, essa non può transitare 2 volte per la stessa configurazione. Valutiamo il numero totale di possibili configurazioni di M su una stringa in input di lunghezza _n_, con il numero di stati $|Q| = n, "l'alfabeto di lavoro" |Sigma| = t$:
  $
    m dot (n+2) dot f(n) dot t^f(n)
  $
  Dove:
  - m è il numero di possibili stati;
  - $n+2$ è il numero di possibili posizione della testina sul nastro 1, su un simbolo della stringa, sulla prima cella vuota o sull'ultima;
  - $f(n)$ è il numero di possibili posizioni della testina sul nastro 2;
  - $t^f(n)$ è il numero di possibili simboli da scrivere nelle $f(n)$ celle lette sul nastro 2;

  Si conclude che:
  $
    t_C_M <= m(n+2)f(n)t^f(n)
  $
]

=== Classi di linguaggi con complessità spaziale

#definition()[
  $
    "PSpace" = {L "linguaggio" | & exists M "MdT deterministica che accetta" L "t.c." \
                                 & s_C_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#definition()[
  $
    "NPSpace" = {L "linguaggio" | & exists M "MdT non deterministica che accetta" L "t.c." \
                                  & s_C_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#observation(multiple: true)[
  + $"P" subset.eq "PSpace"$\
    $"P" limits(=)^? "PSpace"$
  + $"PSpace" subset.eq "Exp"$
    $"PSpace" limits(=)^? "Exp"$
  + $"NP" subset.eq "PSpace"$
    $L in "NP" ==> exists M "MdT non deterministica polinomiale che accetta" L$ poiché si può riutilizzare lo spazio.
  + $"PSpace" subset.eq "NPSpace"$
]

=== Teorema di Savitch

#theorem("Savitch - PDF è più dettagliato")[
  $"PSpace" = "NPSpace"$
]

#proof()[
  $"PSpace" subset.eq "NPSpace"$ (ovvio)\
  Vogliamo mostrare che $"NPSpace" subset.eq "PSpace"$:
  $L in "NPSpace"$, M MdT non deterministica, tale che $s_C_M (n) = s(n)$, che accetta _L_ in spazio polinomiale.

  Numero di possibili configurazioni di M in una sua computazione su input di lunghezza _m_:
  $
    Omicron(2^(c dot s(n))) quad quad "per un opportuno c"
  $
  Sia _x_ una stringha di lunghezza _m_ e $C_x$ la configurazione di M all'inizio della computazione di _x_. Allora, _x_ è accettata da M $<==> exists$ una computazione di M che, partendo da $C_x$, raggiunge $C^\*$ in al più $2^(c dot s(n))$ transizioni.
  $
    "Configurazione iniziale" <-- C_x arrow.long.squiggly C^* --> & "Configurazione accettante" \
                                                                  & "(supponiamo che sia unica)"
  $

  Sia *reachable($C, C^', k$)* con due configurazioni di M e un numero naturale. Esso è vero quando, partendo dalla prima configurazione si può raggiungere la seconda in al più $2^j$ transizioni.
]

// Lezione del 13-05-2026
#definition()[
  L linguaggio si dice *PSpace-difficile* quando $forall Q in "PSpace", exists f$ riduzione polinomiale in tempo da _Q_ a _L_.

  L si dice *PSpace-completo* quando L è PSpace-difficile e $L in "PSpace"$
]

#proposition()[
  + L PSpace-completo $quad quad ==> "P" = "PSpace"$\
    $"L" in "P"$
  + L PSpace-completo $quad quad ==> "NP" = "PSpace"$\
    $"L" in "NP"$
]

#proof()[
  + P $in$ PSpace (ovvio)\
    $Q in "PSpace"$; Poiché L è PSpace-completo, $exists f$ riduzione polinomiale in tempo da Q a L.\
    Algoritmo per decidere Q:
    - Dato _w_, calcolo $f(w) arrow.long.squiggly$ tempo polinomiale;
    - Decido se $f(w) in L arrow.long.squiggly$ tempo polinomiale (perché $L in "P"$);
    $quad quad quad quad quad quad space &arrow.b.double\ Q &in "P"$


  + P $in$ PSpace (ovvio)\
    $Q in "PSpace"$; Poiché L è PSpace-completo, $exists f$ riduzione polinomiale in tempo da Q a L.\
    Algoritmo per decidere Q:
    - Dato _w_, calcolo $f(w) arrow.long.squiggly$ tempo polinomiale;
    - Decido se $f(w) in L arrow.long.squiggly$ tempo polinomiale (perché $L in "NP"$);
    $quad quad quad quad quad quad space &arrow.b.double\ Q &in "NP"$

  La 2 da verificare
]

== Problemi di conteggio
I problemi di conteggio si occupano di stabilire quante possono essere le soluzioni di un problema (ovvero, data una MdT M e una stringa $w$, ci si chiede quante siano le configurazioni accettanti di M su $w$).
// $Sigma = {0, 1}, quad f: Sigma^* --> NN$

#definition()[
  Si chiama $cal(F)P$ la classe delle funzioni $f: Sigma^* -> NN$ per cui esiste una MdT deterministica che calcola _f_ in tempo polinomiale:
  $
    cal(F)P = {f: Sigma^* -> NN | exists M "MdT che calcola" f "t.c." t_C_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#definition()[
  Si chiama *\#_P_* (sharp P) la classe delle funzioni $f: Sigma^* -> NN$ per cui esiste una MdT non deterministica polinomiale tale che, per ogni stringa $w in Sigma^*$, le computazioni accet  tanti di M su _w_ sono $f(w)$:
  $
    \#P = {
    f: Sigma^* --> NN | & exists M "MdT non deterministica polinomiale t.c.", forall w in Sigma^* \
                        & f(w) "è il numero di computazioni accettanti di M su" w
                          }
  $
]

#proposition()[
  $cal(F)P subset.eq \#P$
]
// Diversa da quella del PDF, TOP
#proof()[
  $f in \#P$, sia M MdT deterministica polinomiale che calcola _f_.\
  Considero la seguente MdT non deterministica polinomiale:
  - Su input _w_, calcolo $f(w) = k$;
  - Genero _k_ computazioni (ciascuna delle quali stampa un intero _i_, con $1 <= i <= k$), e le considero tutte accettanti
  $
    arrow.b.double\
    f in \#P
  $
]

#problem("aperto")[
  $
    cal(F)P limits(=)^? \#P
  $
]

#proposition()[
  Se $cal(F)P = \#P ==> "P" = "NP"$
]
#proof()[
  Sia $L in "NP" ==> exists M$ MdT non deterministica polinomiale che accetta _L_.

  Sia $f: Sigma^* --> NN$ la funzione che conta le computazioni accettanti di M $==> f in \#P$, ma per ipotesi $cal(F)P = \#P$, quindi vale anche $f in cal(F)P$. Dunque $exists N "MdT"$ polinomiale deterministica che calcola _f_.

  Algoritmo per decidere _L_, dato $w in Sigma^*$:
  - Calcolo $f(w)$;
  - Se $f(w) = 0$, rifiuta (poiché $f(w)$ è anche il numero di computazioni accettanti);
  - Se $f(w) > 0$, accetta (almeno una computazione accettante).

  Dato che questo è un algoritmo polinomiale per _L_: $L in "P"$
]
#problem("aperto")[
  $
    "P" = "NP" limits(=)^? cal(F)P = \#P
  $
]

#proposition()[
  Se fosse vero che PSpace $=$ P $==> cal(F)P = \#P$
]
#proof()[
  Rimane da dimostrare: $\#P subset.eq cal(F)P$

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
    L_k = {w | "ci sono almeno" k "computazioni di M che accettano" w}
  $
  MdT per calcolare _f_, su input _w_:
  - Determino se  $w in L_(1/2 2^(q(n)))$ usando N e confrontando il numero di computazioni accettanti _k_ con $1/2 2^q(n)$.
    - Se $k < 1/2 2^q(n)$, rifaccio con $L_(1/4 2^(q(n)))$;
    - Se $k >= 1/2 2^q(n)$, rifaccio con $L_(3/4 2^(q(n)))$.

  Complessità in tempo:
  - $forall k, L_k in "PSpace" ==> L_k in "P"$;
  - Il numero di linguaggi da controllare non è $2^q(n)$, ma $Omicron(log(2^(q(n)))) = Omicron(q(n))$ (ricerca binaria)
] // Dimostrazione? BOH

#example(multiple: true)[
  + \#SAT: Dato un polinomio booleano, determinare quanti sono gli assegnamenti che lo soddisfano. (\#SAT $in$ \#P)
  + \#CYCLE: Dato un grafo orientato, determinare il numero di cicli semplici
]

#problem("CYCLE")[
  Dato un grafo orientato (diretto), esiste un ciclo semplice?
]

#observation()[
  Se fosse vero che \#SAT $in cal(F)P, "allora" ==> "#SAT" in "P" ==> "P" = "NP"$
]

#proposition()[
  Se fosse vero che \#CYCLE $in cal(F)P$, allora $"P" = "NP"$
]
#proof()[
  Facciamo vedere che HAM $in$ P (dato che HAM è un problema NP, se dimostriamo che è $in$ P, allora vale che $"P" = "NP"$).
  Sia G un grafo orientato:
  - Costruiamo un nuovo grafo orientato G';
  - Facciamo vedere che:
    - G ha un circuito hamiltoniano $<==>$ G' ha almeno $n^n^2$ cicli.

  Costruzioni di G', supponiamo che $(u, v)$ sia un lato di G.
  #image("/assets/image-9.png")
  Ogni lato di $(u, v)$ di G corrisponde a $2^m$ cammini semplici da _u_ a _v_ in G'. Pertanto, ogni ciclo semplice di lunghezza _l_ di G corrisponde a $(2^m)^l$ cicli semplici in G'.

  Scegliamo $m = n log_2(n)$ (per semplicità, supponiamo che _n_ sia una potenza di 2).

  $==>)$ G ha un circuito hamiltoniano . Il numero dei cicli di G' è $>= (2^m)^n$ ($n = l$) = $(2^(n log_2(n)))^n = (n^n)^n = n^n^2$.\
  $<==)$ G non ha un circuito hamiltoniano $==>$ il più lungo ciclo di G ha lunghezza al più $n - 1$. Il numero totale di cicli di G è al massimo $n^(n-1)$.

  Il numero di cicli di G' è $<= (2^m)^(n-1)$
]
