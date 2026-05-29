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

]
