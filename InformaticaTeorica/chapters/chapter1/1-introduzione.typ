#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

= Introduzione

Lo studio dell'informatica teorica affronta due importanti argomenti:
- La teoria della computabilità;
- La teoria della complessità computazionale.
La teoria della computabilità si prefigge lo scopo di trovare delle definizioni formali che si
avvicinino il più possibile al concetto di algoritmo, dato che l'algoritmo è un concetto primitivo
e non esiste una sua definizione formale.
La teoria della complessità computazionale si occupa, dato un problema, di determinare la
quantità minima di risorse (usualmente tempo e spazio) necessaria ad un algoritmo per risolvere
tale problema. determi

= Teoria della computabilità

== Definizioni preliminari

Consideriamo:
- Σ un alfabeto finito o infinito numerabile (infinito);
- Σ∗ l'insieme delle parole su Σ;
- 𝐿 un linguaggio definito sull'alfabeto Σ, con 𝐿 ⊆ Σ∗.
Diamo ora alcune definizioni:

#definition()[
  Un linguaggio 𝐿 si dice decidibile quando esiste un algoritmo 𝑀 tale
  che, fatto partire con input 𝑤 ∈ Σ∗, 𝑀 termina su 𝑤 dicendo se 𝑤 ∈ 𝐿
  o se 𝑤 ∉ 𝐿.
]

#definition()[
  Un linguaggio 𝐿 si dice enumerabile quando esiste un algoritmo 𝑀 che,
  fatto partire su input vuoto, produce tutte le stringhe del linguaggio. In altre parole, esiste un algoritmo 𝑀 tale che, se 𝑤 ∈ Σ∗ L, 𝑀 scrive 𝑤 in
  tempo finito.
]

#definition()[
  Sia f: Σ∗ → Σ∗ una funzione. Allora, f si dice computabile quando
  esiste un algoritmo 𝑀 tale che, ∀𝑤 ∈ Σ∗, 𝑀 calcola f(𝑤) in tempo
  finito.
]

#definition()[
  Sia f: NN → 𝐿 una funzione che associa a ogni numero naturale una parola del linguaggio. Allora, f si dice enumerazione di 𝐿 quando
  essa è suriettiva e computabile.
]

Vediamo la una procedura per scrivere tutte le stringhe di lunghezza k di un linguaggio.
- Se Σ è un alfabeto finito, composto da Σ = {𝑎1, 𝑎2, ... , 𝑎𝑛}, possiamo scrivere tutte le stringhe di lunghezza 𝑘 in ordine lessicografico, ∀ 𝑘 ∈ NN.

- Se Σ è un alfabeto infinito, composto da Σ = {𝑎1, 𝑎2, ... , 𝑎𝑛, ... }, dobbiamo
usare un metodo particolare chiamato diagonalizzazione o procedimento diagonale di Cantor. Questo metodo consiste nel disporre gli elementi dell'alfabeto in verticale e in orizzontale a formare una tabella e poi a visitarla in maniera diagonale. Questa procedura vale per tutte le stringhe di lunghezza 𝑘 (segue un esempio di stringhe di lunghezza 2).

#figure(image("images/2026-03-03-17-57-48.png"))

#observation()[
  In verità, il modo in cui il
  procedimento è illustrato è quello per le stringhe di lunghezza 2. Per passare a stringhe di lunghezza k
  occorre un ragionamento induttivo; supponendo che le stringhe di lunghezza k-1 siano state già tutte
  enumerate, si fa la procedura descritta sopra mettendo sulle colonne le stringhe di lunghezza k-1, elencate
  secondo l'enumerazione che abbiamo per induzione, e sulle righe le lettere dell'alfabeto
]

#proposition()[
  𝐿 è decidibile ⟹ 𝐿 enumerabile.
]
#proof()[
  Sia 𝑀 un algoritmo di decisione per 𝐿. Un algoritmo di enumerazione per 𝐿 è il seguente:
  - Sia 𝑤𝑖 la i-esima stringa di Σ∗;
  - Eseguo 𝑀 su 𝑤𝑖;
    - Se 𝑤𝑖 ∈ 𝐿, la scrivo;
    - Altrimenti no.
]

#proposition()[
  𝐿 è decidibile ⇔ 𝐿 è enumerabile e $𝐿^𝑐$ è enumerabile.
]
#proof()[
  (⇒) 𝐿 è decidibile ⟹ 𝐿 è enumerabile è già stato dimostrato nella
  precedente proposizione.
  Per dimostrare che 𝐿 decidibile ⟹ 𝐿𝑐 enumerabile possiamo usare
  l'algoritmo di enumerazione per 𝐿 della proposizione precedente
  modificando le operazioni finali:
  - Sia 𝑤𝑖 la i-esima stringa di Σ∗;
  - Eseguo 𝑀 su 𝑤𝑖;
    - Se 𝑤𝑖 ∉ 𝐿, la scrivo;
    - Altrimenti no.
  (⇐) Sia 𝑀 un algoritmo di enumerazione per 𝐿 e 𝑀𝑐 un algoritmo di
  enumerazione per 𝐿𝑐. 𝑀 elenca tutti gli elementi di 𝐿: 𝑤1, 𝑤2, ... , 𝑤𝑛 e
  𝑀𝑐 elenca gli elementi di 𝐿𝑐: 𝑣1, 𝑣2, ... , 𝑣𝑛. Dobbiamo cercare un algo-
  ritmo di decisione per 𝐿.
  Data 𝑤 ∈ Σ∗, faccio partire 𝑀 finché non mi produce 𝑤1, a questo
  punto confronto 𝑤 con 𝑤1, se 𝑤 = 𝑤1 allora so che 𝑤 ∈ 𝐿, altrimenti
  interrompo l'esecuzione dell'algoritmo 𝑀 e faccio partire 𝑀𝑐 finché
  non mi produce 𝑣1 ; se 𝑤 = 𝑣1 termino e concludo che 𝑤 ∉ 𝐿 ,
  altrimenti riprendo l'esecuzione di 𝑀 e confronto 𝑤 con la nuova
  stringa prodotta, e così via. In generale, questi due algoritmi prima o poi
  trovano una stringa che coincide con 𝑤, per cui riescono a determinare
  se 𝑤 ∈ 𝐿 o no, perché 𝑤 sarà nella lista delle stringhe prodotta da 𝑀 o
  in quella prodotta da $𝑀^𝑐$.
]

#definition()[
  Sia 𝐿 un linguaggio. La funzione caratteristica di 𝐿 è definita come:
  $
    𝜒_𝐿: Σ∗ → {0,1}\
    𝜒_𝐿: 𝑤 → cases(
      0 "se" 𝑤 ∉ 𝐿,
      1 "se" 𝑤 ∈ 𝐿
    )
  $
  cioè, data una stringa 𝑤, la funzione caratteristica restituisce il valore 0
  se la stringa non appartiene al linguaggio, oppure il valore 1 se essa vi
  appartiene
]

#proposition()[
  𝐿 è decidibile ⇔ 𝜒𝐿 è una funzione computabile.
]
#proof()[
  (⇒) Data una stringa 𝑤 ∈ Σ∗, eseguo su 𝑤 l'algoritmo di decisione per
  𝐿 (che ho per ipotesi perché 𝐿 è decidibile). Se 𝑤 ∈ 𝐿 , scrivo 1 ,
  altrimenti 0.
  (⇐) Data una stringa 𝑤 ∈ Σ∗ , calcolo 𝜒𝐿(𝑤) (cosa che posso fare
  perché 𝜒𝐿 è una funzione computabile). Se 𝜒𝐿(𝑤) = 1, allora 𝑤 ∈ 𝐿,
  altrimenti 𝑤 ∉ 𝐿.
]

#definition()[
  Un linguaggio 𝐿 è semidecidibile quando esiste un algoritmo 𝑀 che,
  data una stringa 𝑤 ∈ Σ∗, 𝑀 termina su 𝑤 se 𝑤 ∈ 𝐿, altrimenti 𝑀 non
  termina.
]

#observation()[
  𝐿 è semidecidibile ⇔ esiste un algoritmo 𝑀 che, ∀𝑤 ∈ Σ∗, se 𝑤 ∈ 𝐿
  allora 𝑀 termina su 𝑤. Non specifico niente per il caso in cui 𝑤 ∉ 𝐿: 𝑀
  può terminare oppure non terminare.
]

//04.03.2026
#proposition()[
  L'insieme delle funzioni *_rp_* è enumerabile. Esiste, ovvero, un algoritmo che genera sistematicamente tutte le funzioni appartenenti a questo insieme.
]
#proof()[
  Sia $f$ una generica funzione *_rp_* e sia $f_1,f_2,dots,f_n=f$ la sua derivazione ricorsiva primitiva (drp). È possibile codificare $f$ descrivendola in modo univoco utilizzando unicamente le funzioni iniziali e le operazioni (composizione e ricorsione primitiva) da cui è composta.

  Per effettuare questa codifica, definiamo una sintassi specifica per le funzioni di base:
  - Funzione costante $C_0^((n))$: si codifica come $c n$ (es. $C_0^((27))$ diventa $c 27$)
  - Funzione successore $S$: si codifica semplicemente con il simbolo $S$
  - Funzione di proiezione $epsilon_k^((n))$: si codifica come $epsilon n,k$ (es. $epsilon_7^((14))$ diventa $epsilon 14,7$)

  Introduciamo inoltre dei simboli per codificare le operazioni:
  - Composizione: $f compose (g_1,dots,g_n)$ è rappresentata dal simbolo $compose$
  - Ricorsione Primitiva: $f$ definita per RP da $g$ e $h$ è rappresentata come $R(g,h)$
  Per evitare ambiguità sintattiche, utilizziamo le parentesi tonde per racchiudere gli argomenti e le parentesi angolari $<>$ per delimitare l'inizio e la fine della codifica di ogni singola sotto-funzione.

  L'alfabeto finito di simboli necessario per la nostra codifica è quindi il seguente:
  $
    Sigma={c,0,1,dots,9,S,epsilon,,,compose,(,),R,<,>}
  $
  #example()[
    Consideriamo la funzione $S$ definita per ricorsione primitiva come:
    $
      S=R(epsilon_1^((1)),S compose epsilon_3^((3)))
    $
    Applicando le regole definite, essa viene codificata con la seguente stringa:
    $
      <R(<epsilon 1,1>,< <S>compose(<epsilon 3, 3>)>)>
    $
  ]
  Abbiamo quindi dimostrato che è possibile tradurre qualsiasi funzione *_rp_* in una stringa di lunghezza finita formata da caratteri estratti da un alfabeto finito $Sigma$. Poiché l'insieme di tutte le stringhe finite generabili da un alfabeto finito è enumerabile (è sufficiente elencarle in ordine lessicografico, ovvero per lunghezza e poi in ordine alfabetico), ne consegue che l'insieme delle funzioni *_rp_*, corrispondendo a un sottoinsieme di queste stringhe (quelle sintatticamente corrette), deve necessariamente essere enumerabile.
]

#proposition()[Esiste almeno una funzione computabile unaria che non è ricorsiva primitiva (*_rp_*).]
#proof()[
  Procediamo per assurdo supponendo che ogni funzione computabile unaria sia *_rp_*. Per quanto stabilito nella proposizione precedente, l'insieme delle funzioni unarie *_rp_* è enumerabile. Di conseguenza, esiste un algoritmo in grado di generare la lista completa di tali funzioni:
  $
    f_1, f_2, f_3, dots, f_x, dots
  $
  Definiamo ora una nuova funzione $g$ : $g(x) = f_x(x) + 1$

  Possiamo fare due osservazioni chiave su $g$:
  - $g$ è computabile: dato un input $x$, è possibile costruire un algoritmo che trovi la funzione $f_x$ nell'enumerazione, ne calcoli il valore per l'argomento $x$ e vi sommi $1$.
  - Esiste un indice $n$ tale per cui $g = f_n$: per la nostra ipotesi di partenza, essendo $g$ computabile, essa deve essere anche rp. Pertanto, deve necessariamente comparire all'interno dell'enumerazione.

  Se valutiamo la funzione per l'input $n$, per definizione otteniamo:
  $
    g(n) = f_n (n) + 1
  $
  Tuttavia, sapendo che $g = f_n$, deve valere anche l'identità:
  $
    g(n) = f_n (n)
  $
  Confrontando le due espressioni arriviamo alla conclusione:
  $ f_n (n) = f_n (n) + 1 $
  Questo genera un palese assurdo, poiché implicherebbe che un numero naturale sia uguale al proprio successore. Ne consegue che l'ipotesi iniziale è falsa.
]

=== Funzione di Ackermann
#definition()[
  La funzione di Ackermann è una funzione $A: NN^2 -> NN$ così definita:
  $
    cases(
      A(0,y)=y+1,
      A(x+1,0)=A(x,1),
      A(x+1,y+1)=A(x,A(x+1,y))
    )
  $
]

#example(multiple: true)[
  1. $A(1,1)=A(0,A(1,0))=1+A(1,0) = 1+A(0,1)=1+2=3$
  2. $A(2,3) = A(1, A(2,2)) = A (1, A(1, A(2,1))) = A (1, A (1, A(1, A(2,0)))) = ⋯$
]
La convergenza di questa funzione è molto lenta. È una funzione computabile (anche se con difficoltà) e non è ricorsiva primitiva. Più il primo argomento è grande, più la $A$ cresce velocemente:

- A(0, y) = y + 1
- A(1, y) = y + 2\
  Si dimostra per induzione su y:
  - Caso base: y = 0. Allora, A(1,0) = A(0,1) = 2 (cioè y + 2 = 0 + 2 = 2);
  - Passo induttivo: A(1, y + 1) = A(0, A(1, y)) = A(1, y) + 1 = y + 2 + 1 = y + 3 (cioè (y + 1) + 2 = y + 3).

- $A(2, y) = 2y + 3$
- $A(3, y) = 2^(y+3) - 3$
- $A(4, y) = 2^2^2^2^(...) - 3$ (𝑐𝑜𝑛 𝑖 2 𝑟𝑖𝑝𝑒𝑡𝑢𝑡𝑖 3 + y 𝑣𝑜𝑙𝑡𝑒)

#heading(depth: 3, numbering: none, "Proprietà di A")
1. $A(x,y) >= y+1$
2. $A(x,y)<A(x,y+1)$\
  Si dimostra per induzione su x:
  - Caso base: $x = 0$. Allora, $A(0, y) = y + 1 < y + 2 = A(0, y + 1)$
  - Passo induttivo: supponiamo che $A(x, y) < A(x, y + 1)$.\
    $A(x + 1, y) < A(x + 1, y) + 1 <= A(x, A(x + 1, y)) = A(x + 1, y + 1)$\
    $quad quad quad quad quad quad quad quad quad$ ↳ $y$ $quad quad$ ↳ prima proprietà $A(x, y) >= y + 1$

3. $A(x, y + 1) <= A(x + 1, y)$
4. $A(x, y) < A(x + 1, y)$
5. $A(x_1, y) + A(x_2, y) < A(max(x_1, x_2) + 4, y)$
6. $A(x, y) + y < A(x + 4, y)$

#proposition()[
  $forall g: NN^k -> NN$ funzione *_rp_*, $exists c in NN$ tale che $forall limits(x)^arrow in NN^k$, $g(limits(x)^arrow) < A(c, sum_(i=1)^k x_i)$

  Ovvero, per qualunque funzione *_rp_* del tipo $g: NN^k -> NN$, esiste una  costante (un numero naturale) per cui, data una qualsiasi k-upla, la funzione calcolata su tale k-upla è strettamente minore della funzione di Ackermann con primo argomento la costante e secondo argomento la sommatoria della k-upla.
]
#proof()[
  Si dimostra per induzione strutturale, sulla costruzione dell'insieme delle
  funzioni *_rp_*:
  - Caso base: funzioni iniziali
    - $C_0^k (limits(x)^arrow) = 0 < 1+ sum_(i=1)^k x_i = A(0, sum_(i=1)^k x_i) => c=0$
    - $S(x) = x+1 < x+2 = A(0, x+1) <= (3) A(1,x) => c=1$
    - $epsilon_j^k (limits(x)^arrow) = x_j < 1 + sum_(i=1)^k x_i = A(0, sum_(i=1)^k x_i) => c=0$
  - Passo induttivo: supponiamo che la funzione $g$ sia ottenuta per composizione dalle funzioni $h,f_1,dots,f_m$ che sono *_rp_* (con $h: NN^m -> NN$ e $f_1, ... , f_m: NN^k -> NN$), cioè $g = h compose (f_1, ... , f_𝑚)$.
    Supponiamo che il lemma valga per $h, f_1, ... , f_m$, ossia:
    - $h(x_1,dots,x_m) < A(D, sum_(i=1)^m x_i) quad (exists D)$
    - $f_j(x_1,dots,x_k) < A(C_j, sum_(i=1)^k x_i) quad (exists C_j, forall j=1,dots,m)$

  Facciamo vedere che il lemma vale per $g$:
  $
    g(limits(x)^arrow) = h(f_1 (limits(x)^arrow), ... , f_𝑚 (limits(x)^arrow)) < A(D, sum_(j=1)^m f_j (limits(x)^arrow))\
    < A(𝐷, sum_(j=1)^m A(C_j, sum_(i=1)^k x_i)) < (5) A(D,A(tilde(C), sum_(i=1)^k x_i)) quad quad E=max(D, tilde(C))\
    <= A(E, A(E+1, sum_(i=1)^k x_i)) = (3?) A(E+1, sum_(i=1)^k x_i+1) <= A(E+2, sum_(i=1)^k x_i+1)
  $
  Quindi anche $g$ soddisfa il lemma. Infine, per completare il passo induttivo, occorrerebbe trattare il caso di una funzione ottenuta per RP, ma la dimostrazione di quest'ultimo caso viene omessa.
]


#proposition()[
  La funzione di Ackermann non è *_rp_*.
]
#proof()[
  Supponiamo per assurdo che A sia *_rp_*.

  Allora, anche la funzione $B(x) = A(x, x)$ è *_rp_* ($B = A compose (epsilon^1_1, epsilon^1_1)$). Posso applicare il lemma  precedente, quindi $exists c in NN$ tale che $forall x in NN, B(x) < A(c, x)$.

  Ma allora  se scelgo $x = c$ ottengo $B(c) < A(c, c) = B(c)$ per definizione,  cioè $B(c)$ strettamente minore di $B(c)$, il che è assurdo. Per cui, A non  è *_rp_*.
]

#definition()[
  Sia 𝑔 una funzione, con 𝑔: $NN^(k+1)$ → $NN$. Essa si dice regolare quando
  $
    forall(x_1, dots, x_k) in NN^k, exists y in NN quad t.c. quad g(arrow(x), y) = 0 
  $
]
#definition()[
  Una funzione 𝑓: $NN^k$ → $NN$ si dice ottenuta per minimalizzazione da 𝑔: $NN^(k+1)$ → $NN$ regolare quando
  $ f(arrow(x)) = min{y in NN | g(arrow(x), y) = 0} $
]

#definition()[
  Una *derivazione $mu$-ricorsiva* è una sequenza di funzioni  $f_1, f_2, dots, f_n$ t.c. $forall i=1,dots,n$:
  - $f_i$ è una funzione inizialie, oppure
  - $f_i$ è ottenuta per composizione da funzioni precedenti, oppure
  - $f_i$ è ottenuta per RP da 2 funzioni precedenti, oppure
  - $f_i$ è ottenuta da $f_j$ regolare per minimalizzazione (con $j < i$)
\
  Una funzione si dice *$mu$-ricorsiva* quando compare in coda ad una derivazione $mu$-ricorsiva.
]

#proposition()[
  $g$ computabile $==>$ $f$ computabile
]
#proof()[
  \ $G$ algoritmo di calcolo per $g$ \
  Algoritmo di calcolo per $f$, data $arrow(x) in NN^k$:\
  mentre $y >= 0$,\
  $"  "$  calcolo $g(arrow(x), y)$ (usando _G_)\
  $"  "$  se ottengo 0, restituisco $y$
]

=== Tesi di Church (per le funzioni $mu$-ricorsive)

La classe delle *funzioni computabili* coincide con la classe delle *funzioni $mu$-ricorsive*

=== Macchine di Turing

// TODO: Fare il disegno del nastro
La macchina di Turing è un modello di calcolo che serve a descrivere il concetto di algortimo. Ha le seguenti caratteristiche:
- È composta da un *nastro unidimensionale* infinito, sia da destra che da sinistra.
- Il nastro è diviso in *celle* che possono contenere informazioni.
- Le informazioni che si possono scrivere sul nastro sono *simboli* da un *alfabeto finito $Sigma$* definito inizialmente. Questo alfabeto contiene sempre un *simbolo privilegiato (\*)* che serve per denotare una *cella vuota* ed è normalmente implicito e non scritto tra i simboli dell'alfabeto.
- C'è una *testina* che si occupa della *lettura/scrittura*, spostandosi a destra e a sinistra, indicando una cella ad ogni spostamento. Ogni spostamento della testina è definito *passo di calcolo* o *transizione*.
- La macchina ha un insieme di stati di memoria _Q_ = {$q_0, q_1, dots, q_n$}. Lo stato $q_0$ è chiamato stato iniziale e in seguito a una *transizione*, la macchina può cambiare stato. 

Una transizione è una quartupla i cui primi due elementi determinano una *configurazione*. Una tipica transizione in *MdT* è la seguente:
$
  Q times Sigma times (Sigma union {D, S}) times Q in.rev& (overbracket(q\, x, "configurazione"), alpha, accent(q, ~))\
  "Con:" & q in Q, x in Sigma, alpha in Sigma, accent(q, ~) in Q\

  "Funzionale nei primi"&" 2 argomenti"
$

#definition()[
  Una *macchina di Turing* è un sottoinsieme dell'insieme: $ Q times Sigma times (Sigma union {D, S}) times Q $
  cioé è una lista di transizioni (cioé una lista di quartuple funzionali nei primi 2 argomenti).
]

#example(multiple: true)[
  // TODO: AGGIUNGERE DISEGNI ESEMPI DEI NASTRI
  1)  #block($
  quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ")q_1\
             &q_0 && 1 && D       && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
       $)
  
  2) #block($
  quad space &q_0 && * && D space && q_0 text(": Se la cella corrente è vuota, la testina si sposta a destra e non cambia stato")\
             &q_0 && 1 && D       && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
             &q_1 && 1 && D       && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra, scrivo 1 e non")\ & && && && quad quad   text("cambia stato")\
       $)

  3) #block($
  quad space &q_0 && * && 1 space && q_0 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
             &q_0 && 1 && D       && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_1\
             &q_1 && * && 1       && q_1 text(": Se la cella corrente è vuota, scrivo 1 e non cambia stato")\
             &q_1 && 1 && 1       && q_0 text(": Se la cella corrente è 1, la testina si sposta a destra e cambia lo stato a ")q_0
       $)

  4) #block($
  quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a") q_1\
             &q_1 && 1 && D       && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ")\
             &q_1 && * && 1       && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ")q_2\
             &q_2 && 1 && S       && q_2 text(": Se la cella corrente è 1, la testina si sposta a sinistra e non cambia lo stato")
       $)
]

#definition()[
  Una Macchina di Turing (MdT) _M_ calcola una funzione $f: Sigma^* -> Sigma^*$ quando, scritta una stringa $w in Sigma^*$ sul nastro e posta la testina di _M_ sulla prima cella vuota a sinistra di _w_, dopo l'esecuzione di _M_ su _w_, la testina si trova nella prima cella vuota a sinistra di $f(w)$.
]

#example()[
  Creiamo una MdT che calcola la somma di due numeri naturali scritti in codifica unaria (con il simbolo $1$). I numeri scelti nell'esempio sono 2 e 3:
  #image("./images/image-2.png")

  // TODO: rifare l'immamgine
  #block($
  quad space &q_0 && * && D space && q_1 text(": Se la cella corrente è vuota, la testina si sposta a destra e cambia lo stato a ") q_1\
             &q_1 && 1 && D       && q_1 text(": Se la cella corrente è 1, la testina si sposta a destra non cambia stato ")\
             &q_1 && * && 1       && q_2 text(": Se la cella corrente è vuota, scrivo 1 e cambia lo stato a ")q_2\
             &q_2 && 1 && D       && q_2 text(": Se la cella corrente è 1, la testina si sposta a destra e non cambia lo stato")\
             &q_2 && * && S       && q_3 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ")q_3\
             &q_3 && 1 && *       && q_3 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato")\
             &q_3 && * && S       && q_4 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a ")q_4\
             &q_4 && 1 && *       && q_4 text(": Se la cella corrente è 1, scrivo * e non cambia lo stato")\
             &q_4 && * && S       && q_5 text(": Se la cella corrente è vuota, la testina si sposta a sinistra e cambia lo stato a "q_5)
       $)
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
      node(( 0, 0), $q_1$, name: <1>),
      node(( 2, 2), $q_2$, name: <2>),
      node(( 0, 4), $q_3$, name: <3>),
      node((-2, 2), $q_4$, name: <4>),
      node(( 3, 0), $q_5$, name: <5>),

      edge(<0>, <1>, "-|>", $* \/ D$),
      edge(<1>, <2>, "-|>", $1 \/ X$),
      edge(<2>, <2>, "-|>", $X, 1 \/ D$, bend: 130deg, loop-angle: 0deg),
      edge(<2>, <3>, "-|>", $* \/ D$, label-anchor: "north-west"),
      edge(<3>, <3>, "-|>", $1 \/ D$   , bend: 130deg, loop-angle: -90deg),
      edge(<3>, <4>, "-|>", $* \/ 1$, label-anchor: "north-east"),
      edge(<4>, <4>, "-|>", $1, * \/ S$, bend: 130deg, loop-angle: 180deg),
      edge(<4>, <1>, "-|>", $X \/ D$),
      edge(<1>, <5>, "-|>", $* \/ S$),
    ))
]

----------------------------

// Esercizio esame della lezione prima
#block()[$
           &f: NN -> NN, R subset.eq NN^k  "rp"\
           &"Definisco " S subset.eq NN^k "ponendo" arrow(x) in S " quando " (f(x_1), dots, f(x_k)) in R\
           &"Dimostra che S rp":\
           &cal(chi)_S (arrow(x))=cal(chi)_R compose (f compose epsilon_1^(k), dots, f compose epsilon_k^(k))(arrow(x))
         $]

==== MDT come accettatori di linguaggi
Accettazione di una stringa per stati finali: 
- $Q$: insieme degli stati di una MDT
- $F subset.eq Q$: insieme degli stati finali

#definition()[
  _M_ accetta la stringa  _w_ *per stati finali* quando l'esecuione di _M_ su input _w_ termina in uno stato finale.
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
  _L_ accettato per stati finali $<==>$ L acettato per ingresso
]
#proof()[
  \ $==>$ M MDT che accetta _L_ per stati finali.\
  M'  che accetta per ingreso si costruisce a partire da M, aggiungendo un nuovo stato $accent(q, ~)$ (che sarà l'unico stato finale) e transizioni che portano in $accent(q, ~)$ da ogni stato finale in corrispondenza a caratteri per cui non ci sono transizioni uscenti in M.
  
  $<==$ M MDT che accetta _L_ per ingresso.\
  M' MDT che accetta L per stai finali is ottiene da M eliminando tutte le transizioni uscenti dagli stati finali.
]

#definition()[
  MDT multitraccia con:
  - $Sigma $ alfabeto
  - $Q $ insieme degli stati

  Possiamo definirla come una lista di transizioni della forma (con k = numero tracce):
  $
    underbrace(q, Q), underbrace((x_1, dots, x_n), Sigma^k), underbrace(alpha, (Sigma^k union {D, S})), underbrace(accent(q, ~), Q) 
  $
]

#proposition()[
  Fissato un $k in NN$, un linguaggio L è accettato da una MdT multitraccia $<==>$ L è accettato da una MdT a k-tracce
]
#proof()[
  \ $<==) $ Ovvio. Posso simulare una MdT con una tracia usando una MdT con k-tracce in cui ignoro (cioé lascio vuoto) il contenuto di tutte le tracce tranne la prima).
  \ $==>) $ M MdT a k-tracce che accetta L, posso ottenere una MdT M' che accetta L a una traccia semplicemente sostituendo l'alfabeto $Sigma$ di M con $Sigma^k$, eseguendo  le medesime transizioni (Se in M si legge, dal basso verso l'alto, a, b, a, \*, a in 5 celle diverse, in M' si leggerà la quintupla (a, b, a, \*, a) in una sola cella)
]

==== 

#definition()[
  MdT *limitata a sinistra*
  // TODO: Immagine
  possiamo usare MdT limitate a sinistra per accettare stringhe nello stesso modo di quelle classiche, con l'accortezza che un'operazione di spostamento a sinistra a partire dalla prima cella causa il rifiuto della stringa
]