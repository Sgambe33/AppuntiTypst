#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *

#heading(numbering: none, [Introduzione])

Lo studio dell'informatica teorica affronta due importanti argomenti:
- La teoria della computabilità;
- La teoria della complessità computazionale.

La teoria della computabilità si prefigge lo scopo di trovare delle definizioni formali che si avvicinino il più possibile al concetto di algoritmo, dato che l'algoritmo è un concetto primitivo e non esiste una sua definizione formale.

La teoria della complessità computazionale si occupa, dato un problema, di determinare la quantità minima di risorse (usualmente tempo e spazio) necessaria ad un algoritmo per risolvere tale problema.

= Teoria della computabilità

== Definizioni preliminari

Consideriamo:
- $Sigma$ un alfabeto finito o infinito numerabile (infinito);
- $Sigma^*$ l'insieme delle parole su $Sigma$;
- $L$ un linguaggio definito sull'alfabeto $Sigma$, con $L subset.eq Sigma^*$.

Diamo ora alcune definizioni:

#definition()[
  Un linguaggio $L$ si dice *decidibile* quando esiste un algoritmo $M$ tale che, fatto partire con input $w in Sigma^*$, $M$ termina su $w$ dicendo se $w in L$ o se $w in.not L$.
]

#definition()[
  Un linguaggio $L$ si dice *enumerabile* quando esiste un algoritmo $M$ che, fatto partire su input vuoto, produce tutte le stringhe del linguaggio. In altre parole, esiste un algoritmo $M$ tale che, se $w in L$, $M$ scrive $w$ in tempo finito.
]

#definition()[
  Sia $f: Sigma^* -> Sigma^*$ una funzione. Allora, $f$ si dice *computabile* quando esiste un algoritmo $M$ tale che, $forall w in Sigma^*$, $M$ calcola $f(w)$ in tempo finito.
]

#definition()[
  Sia $f: NN -> L$ una funzione che associa a ogni numero naturale una parola del linguaggio. Allora, $f$ si dice *enumerazione* di $L$ quando essa è suriettiva e computabile.
]

Vediamo una procedura per scrivere tutte le stringhe di lunghezza $k$ di un linguaggio.
- Se $Sigma$ è un alfabeto finito, composto da $Sigma = {a_1, a_2, dots, a_n}$, possiamo scrivere tutte le stringhe di lunghezza $k$ in ordine lessicografico, $forall k in NN$.

- Se $Sigma$ è un alfabeto infinito, composto da $Sigma = {a_1, a_2, dots, a_n, dots}$, dobbiamo usare un metodo particolare chiamato diagonalizzazione o procedimento diagonale di Cantor. Questo metodo consiste nel disporre gli elementi dell'alfabeto in verticale e in orizzontale a formare una tabella e poi a visitarla in maniera diagonale. Questa procedura vale per tutte le stringhe di lunghezza $k$ (segue un esempio di stringhe di lunghezza 2).

#figure(image("images/2026-03-03-17-57-48.png"))

#observation()[
  In verità, il modo in cui il procedimento è illustrato è quello per le stringhe di lunghezza 2. Per passare a stringhe di lunghezza $k$ occorre un ragionamento induttivo; supponendo che le stringhe di lunghezza $k-1$ siano state già tutte enumerate, si fa la procedura descritta sopra mettendo sulle colonne le stringhe di lunghezza $k-1$, elencate secondo l'enumerazione che abbiamo per induzione, e sulle righe le lettere dell'alfabeto.
]

#proposition()[
  $L$ è decidibile $=> L$ enumerabile.
]

#proof()[
  Sia $M$ un algoritmo di decisione per $L$. Un algoritmo di enumerazione per $L$ è il seguente:
  #pseudocode-list[
    + Sia $w_i$ la i-esima stringa di $Sigma^*$;
    + Eseguo $M$ su $w_i$;
      + Se $w_i in L$, la scrivo;
      + Altrimenti no.
  ]
]

#proposition()[
  $L$ è decidibile $<=> L$ è enumerabile e $L^c$ è enumerabile.
]
#proof()[
  ($=>$) $L$ è decidibile $=> L$ è enumerabile è già stato dimostrato nella precedente proposizione.

  Per dimostrare che $L$ decidibile $=> L^c$ enumerabile possiamo usare l'algoritmo di enumerazione per $L$ della proposizione precedente modificando le operazioni finali:
  - Sia $w_i$ la i-esima stringa di $Sigma^*$;
  - Eseguo $M$ su $w_i$;
    - Se $w_i in.not L$, la scrivo;
    - Altrimenti no.

  ($<=$) Sia $M$ un algoritmo di enumerazione per $L$ e $M^c$ un algoritmo di enumerazione per $L^c$. $M$ elenca tutti gli elementi di $L$: $w_1, w_2, dots, w_n$ e $M^c$ elenca gli elementi di $L^c$: $v_1, v_2, dots, v_n$. Dobbiamo cercare un algoritmo di decisione per $L$.

  Data $w in Sigma^*$, faccio partire $M$ finché non mi produce $w_1$, a questo punto confronto $w$ con $w_1$, se $w = w_1$ allora so che $w in L$, altrimenti interrompo l'esecuzione dell'algoritmo $M$ e faccio partire $M^c$ finché non mi produce $v_1$; se $w = v_1$ termino e concludo che $w in.not L$, altrimenti riprendo l'esecuzione di $M$ e confronto $w$ con la nuova stringa prodotta, e così via. In generale, questi due algoritmi prima o poi trovano una stringa che coincide con $w$, per cui riescono a determinare se $w in L$ o no, perché $w$ sarà nella lista delle stringhe prodotta da $M$ o in quella prodotta da $M^c$.
]

#definition()[
  Sia $L$ un linguaggio. La funzione caratteristica di $L$ è definita come:
  $
    chi_L: Sigma^* -> {0,1}\
    chi_L(w) = cases(
      0 & "se" w in.not L,
      1 & "se" w in L
    )
  $
  cioè, data una stringa $w$, la funzione caratteristica restituisce il valore 0 se la stringa non appartiene al linguaggio, oppure il valore 1 se essa vi appartiene.
]

#proposition()[
  $L$ è decidibile $<=> chi_L$ è una funzione computabile.
]
#proof()[
  ($=>$) Data una stringa $w in Sigma^*$, eseguo su $w$ l'algoritmo di decisione per $L$ (che ho per ipotesi perché $L$ è decidibile). Se $w in L$, scrivo 1, altrimenti 0.

  ($<=$) Data una stringa $w in Sigma^*$, calcolo $chi_L(w)$ (cosa che posso fare perché $chi_L$ è una funzione computabile). Se $chi_L(w) = 1$, allora $w in L$, altrimenti $w in.not L$.
]

#definition()[
  Un linguaggio $L$ è semidecidibile quando esiste un algoritmo $M$ che, data una stringa $w in Sigma^*$, $M$ termina su $w$ se $w in L$, altrimenti $M$ non termina.
]

#observation()[
  $L$ è semidecidibile $<=>$ esiste un algoritmo $M$ che, $forall w in Sigma^*$, se $w in L$ allora $M$ termina su $w$. Non specifico niente per il caso in cui $w in.not L$: $M$ può terminare oppure non terminare.
]

// 04.03.2026
#proposition()[
  L'insieme delle funzioni *_rp_* è enumerabile. Esiste, ovvero, un algoritmo che genera sistematicamente tutte le funzioni appartenenti a questo insieme.
]
#proof()[
  Sia $f$ una generica funzione *_rp_* e sia $f_1, f_2, dots, f_n = f$ la sua derivazione ricorsiva primitiva (drp). È possibile codificare $f$ descrivendola in modo univoco utilizzando unicamente le funzioni iniziali e le operazioni (composizione e ricorsione primitiva) da cui è composta.

  Per effettuare questa codifica, definiamo una sintassi specifica per le funzioni di base:
  - Funzione costante $C_0^((n))$: si codifica come $c n$ (es. $C_0^((27))$ diventa $c 27$)
  - Funzione successore $S$: si codifica semplicemente con il simbolo $S$
  - Funzione di proiezione $epsilon_k^((n))$: si codifica come $epsilon n, k$ (es. $epsilon_7^((14))$ diventa $epsilon 14, 7$)

  Introduciamo inoltre dei simboli per codificare le operazioni:
  - Composizione: $f compose (g_1, dots, g_n)$ è rappresentata dal simbolo $compose$
  - Ricorsione Primitiva: $f$ definita per RP da $g$ e $h$ è rappresentata come $R(g, h)$

  Per evitare ambiguità sintattiche, utilizziamo le parentesi tonde per racchiudere gli argomenti e le parentesi angolari $< >$ per delimitare l'inizio e la fine della codifica di ogni singola sotto-funzione.

  L'alfabeto finito di simboli necessario per la nostra codifica è quindi il seguente:
  $
    Sigma = {c, 0, 1, dots, 9, S, epsilon, ",", compose, "(", ")", R, "<", ">"}
  $

  #example()[
    Consideriamo la funzione $S$ definita per ricorsione primitiva come:
    $
      S = R(epsilon_1^((1)), S compose epsilon_3^((3)))
    $
    Applicando le regole definite, essa viene codificata con la seguente stringa:
    $
      <R(<epsilon 1, 1>, < <S> compose (<epsilon 3, 3>)>)>
    $
  ]

  Abbiamo quindi dimostrato che è possibile tradurre qualsiasi funzione *_rp_* in una stringa di lunghezza finita formata da caratteri estratti da un alfabeto finito $Sigma$. Poiché l'insieme di tutte le stringhe finite generabili da un alfabeto finito è enumerabile (è sufficiente elencarle in ordine lessicografico, ovvero per lunghezza e poi in ordine alfabetico), ne consegue che l'insieme delle funzioni *_rp_*, corrispondendo a un sottoinsieme di queste stringhe (quelle sintatticamente corrette), deve necessariamente essere enumerabile.
]

#proposition()[
  Esiste almeno una funzione computabile unaria che non è ricorsiva primitiva (*_rp_*).
]
#proof()[
  Procediamo per assurdo supponendo che ogni funzione computabile unaria sia *_rp_*. Per quanto stabilito nella proposizione precedente, l'insieme delle funzioni unarie *_rp_* è enumerabile. Di conseguenza, esiste un algoritmo in grado di generare la lista completa di tali funzioni:
  $
    f_1, f_2, f_3, dots, f_x, dots
  $
  Definiamo ora una nuova funzione $g(x) = f_x(x) + 1$.

  Possiamo fare due osservazioni chiave su $g$:
  - $g$ è computabile: dato un input $x$, è possibile costruire un algoritmo che trovi la funzione $f_x$ nell'enumerazione, ne calcoli il valore per l'argomento $x$ e vi sommi $1$.
  - Esiste un indice $n$ tale per cui $g = f_n$: per la nostra ipotesi di partenza, essendo $g$ computabile, essa deve essere anche rp. Pertanto, deve necessariamente comparire all'interno dell'enumerazione.

  Se valutiamo la funzione per l'input $n$, per definizione otteniamo:
  $
    g(n) = f_n(n) + 1
  $
  Tuttavia, sapendo che $g = f_n$, deve valere anche l'identità:
  $
    g(n) = f_n(n)
  $
  Confrontando le due espressioni arriviamo alla conclusione:
  $ f_n(n) = f_n(n) + 1 $
  Questo genera un palese assurdo, poiché implicherebbe che un numero naturale sia uguale al proprio successore. Ne consegue che l'ipotesi iniziale è falsa.
]

== Funzione di Ackermann
#definition()[
  La funzione di Ackermann è una funzione $A: NN^2 -> NN$ così definita:
  $
    cases(
      A(0, y) = y + 1,
      A(x+1, 0) = A(x, 1),
      A(x+1, y+1) = A(x, A(x+1, y))
    )
  $
]

#example(multiple: true)[
  1. $A(1, 1) = A(0, A(1, 0)) = 1 + A(1, 0) = 1 + A(0, 1) = 1 + 2 = 3$
  2. $A(2, 3) = A(1, A(2, 2)) = A(1, A(1, A(2, 1))) = A(1, A(1, A(1, A(2, 0)))) = dots$
]

La convergenza di questa funzione è molto lenta. È una funzione computabile (anche se con difficoltà) e non è ricorsiva primitiva. Più il primo argomento è grande, più la $A$ cresce velocemente:

- $A(0, y) = y + 1$
- $A(1, y) = y + 2$\
  Si dimostra per induzione su $y$:
  - Caso base: $y = 0$. Allora, $A(1, 0) = A(0, 1) = 2$ (cioè $y + 2 = 0 + 2 = 2$);
  - Passo induttivo: $A(1, y + 1) = A(0, A(1, y)) = A(1, y) + 1 = y + 2 + 1 = y + 3$ (cioè $(y + 1) + 2 = y + 3$).

- $A(2, y) = 2y + 3$
- $A(3, y) = 2^(y+3) - 3$
- $A(4, y) = 2^2^2^dots - 3$ (con i 2 ripetuti $3 + y$ volte)

#heading(depth: 3, numbering: none, outlined: false, "Proprietà di A")
1. $A(x, y) >= y + 1$
2. $A(x, y) < A(x, y + 1)$\
  Si dimostra per induzione su $x$:
  - Caso base: $x = 0$. Allora, $A(0, y) = y + 1 < y + 2 = A(0, y + 1)$
  - Passo induttivo: supponiamo che $A(x, y) < A(x, y + 1)$.\
    $A(x + 1, y) < A(x + 1, y) + 1 <= A(x, A(x + 1, y)) = A(x + 1, y + 1)$\
    $quad quad quad quad quad quad quad quad quad "↳" y quad quad "↳ prima proprietà" A(x, y) >= y + 1$

3. $A(x, y + 1) <= A(x + 1, y)$
4. $A(x, y) < A(x + 1, y)$
5. $A(x_1, y) + A(x_2, y) < A(max(x_1, x_2) + 4, y)$
6. $A(x, y) + y < A(x + 4, y)$

#proposition()[
  $forall g: NN^k -> NN$ funzione *_rp_*, $exists c in NN$ tale che $forall arrow(x) in NN^k$, $g(arrow(x)) < A(c, sum_(i=1)^k x_i)$

  Ovvero, per qualunque funzione *_rp_* del tipo $g: NN^k -> NN$, esiste una costante (un numero naturale) per cui, data una qualsiasi k-upla, la funzione calcolata su tale k-upla è strettamente minore della funzione di Ackermann con primo argomento la costante e secondo argomento la sommatoria della k-upla.
]
#proof()[
  Si dimostra per induzione strutturale, sulla costruzione dell'insieme delle funzioni *_rp_*:
  - Caso base: funzioni iniziali
    - $C_0^k(arrow(x)) = 0 < 1 + sum_(i=1)^k x_i = A(0, sum_(i=1)^k x_i) => c = 0$

    - $S(x) = x + 1 < x + 2 = A(0, x + 1) <= "(3)" A(1, x) => c = 1$

    - $epsilon_j^k(arrow(x)) = x_j < 1 + sum_(i=1)^k x_i = A(0, sum_(i=1)^k x_i) => c = 0$

  - Passo induttivo: supponiamo che la funzione $g$ sia ottenuta per composizione dalle funzioni $h, f_1, dots, f_m$ che sono *_rp_* (con $h: NN^m -> NN$ e $f_1, dots, f_m: NN^k -> NN$), cioè $g = h compose (f_1, dots, f_m)$.
    Supponiamo che il lemma valga per $h, f_1, dots, f_m$, ossia:

    - $h(x_1, dots, x_m) < A(D, sum_(i=1)^m x_i) quad (exists D)$

    - $f_j(x_1, dots, x_k) < A(C_j, sum_(i=1)^k x_i) quad (exists C_j, forall j=1, dots, m)$

    Facciamo vedere che il lemma vale per $g$:
    $
      g(arrow(x)) &= h(f_1(arrow(x)), dots, f_m(arrow(x))) < A(D, sum_(j=1)^m f_j(arrow(x))) \
      &< A(D, sum_(j=1)^m A(C_j, sum_(i=1)^k x_i)) < "(5)" A(D, A(tilde(C), sum_(i=1)^k x_i)) quad quad E = max(D, tilde(C)) \
      &<= A(E, A(E+1, sum_(i=1)^k x_i)) = "(3?)" A(E+1, sum_(i=1)^k x_i + 1) <= A(E+2, sum_(i=1)^k x_i + 1)
    $
    Quindi anche $g$ soddisfa il lemma. Infine, per completare il passo induttivo, occorrerebbe trattare il caso di una funzione ottenuta per RP, ma la dimostrazione di quest'ultimo caso viene omessa.
]

#proposition()[
  La funzione di Ackermann non è *_rp_*.
]
#proof()[
  Supponiamo per assurdo che $A$ sia *_rp_*.

  Allora, anche la funzione $B(x) = A(x, x)$ è *_rp_* ($B = A compose (epsilon^1_1, epsilon^1_1)$). Posso applicare il lemma precedente, quindi $exists c in NN$ tale che $forall x in NN, B(x) < A(c, x)$.

  Ma allora se scelgo $x = c$ ottengo $B(c) < A(c, c) = B(c)$ per definizione, cioè $B(c)$ strettamente minore di $B(c)$, il che è assurdo. Per cui, $A$ non è *_rp_*.
]

#definition()[
  Sia $g$ una funzione, con $g: NN^(k+1) -> NN$. Essa si dice regolare quando
  $
    forall (x_1, dots, x_k) in NN^k, exists y in NN quad "t.c." quad g(arrow(x), y) = 0
  $
]
#definition()[
  Una funzione $f: NN^k -> NN$ si dice ottenuta per minimalizzazione da $g: NN^(k+1) -> NN$ regolare quando
  $ f(arrow(x)) = min{y in NN | g(arrow(x), y) = 0} $
]

#definition()[
  Una *derivazione $mu$-ricorsiva* è una sequenza di funzioni $f_1, f_2, dots, f_n$ t.c. $forall i=1, dots, n$:
  - $f_i$ è una funzione iniziale, oppure
  - $f_i$ è ottenuta per composizione da funzioni precedenti, oppure
  - $f_i$ è ottenuta per RP da 2 funzioni precedenti, oppure
  - $f_i$ è ottenuta da $f_j$ regolare per minimalizzazione (con $j < i$)
  \
  Una funzione si dice *$mu$-ricorsiva* quando compare in coda ad una derivazione $mu$-ricorsiva.
]

#proposition()[
  $g$ computabile $=> f$ computabile
]
#proof()[
  $G$ algoritmo di calcolo per $g$ \
  Algoritmo di calcolo per $f$, data $arrow(x) in NN^k$:
  - mentre $y >= 0$,
    - calcolo $g(arrow(x), y)$ (usando $G$)
    - se ottengo 0, restituisco $y$
]

== Tesi di Church (per le funzioni $mu$-ricorsive)
#proposition()[
  La classe delle *funzioni computabili* coincide con la classe delle *funzioni $mu$-ricorsive*.
]
