#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *

#heading(numbering: none, [Introduzione])

Lo studio dell'informatica teorica affronta due importanti argomenti:
- La teoria della computabilità;
- La teoria della complessità computazionale.

La teoria della computabilità si prefigge di trovare delle definizioni formali che si avvicinino il più possibile al concetto di algoritmo, dato che l'algoritmo è un concetto primitivo e non esiste una sua definizione formale. Di conseguenza, si vuole anche indagare se un dato problema è calcolabile o meno da un algoritmo.

La teoria della complessità computazionale si occupa, dato un problema, di determinare la quantità minima di risorse (usualmente tempo e spazio) necessaria ad un algoritmo per risolvere tale problema.

= Teoria della computabilità

== Definizioni preliminari

Consideriamo:
- $Sigma$ un alfabeto finito o infinito numerabile;
- $Sigma^*$ l'insieme delle parole su $Sigma$;
- $L$ un linguaggio definito sull'alfabeto $Sigma$, con $L subset.eq Sigma^*$.

Diamo ora alcune definizioni:

#index[Linguaggio decidibile]
#definition()[
  Un linguaggio $L$ si dice *decidibile* quando esiste un algoritmo $M$ tale che, fatto partire con input $w in Sigma^*$, $M$ termina su $w$ dicendo se $w in L$ o se $w in.not L$.
]

#index[Linguaggio enumerabile]
#definition()[
  Un linguaggio $L$ si dice *enumerabile* quando esiste un algoritmo $M$ che, fatto partire su input vuoto, produce tutte le stringhe del linguaggio. In altre parole, esiste un algoritmo $M$ tale che, se $w in L$, $M$ scrive $w$ in tempo finito.
]

#index[Funzione computabile]
#definition()[
  Sia $f: Sigma^* -> Sigma^*$ una funzione. Allora, $f$ si dice *computabile* quando esiste un algoritmo $M$ tale che, $forall w in Sigma^*$, $M$ calcola $f(w)$ in tempo finito.
]

#index[Enumerazione]
#definition()[
  Sia $f: NN -> L$ una funzione che associa a ogni numero naturale una parola del linguaggio. Allora, $f$ si dice *enumerazione* di $L$ quando essa è suriettiva e computabile.
]

Vediamo una procedura per scrivere tutte le stringhe di lunghezza $k$ di un linguaggio.
- Se $Sigma$ è un alfabeto finito, con $Sigma = {a_1, a_2, dots, a_n}$, possiamo scrivere tutte le stringhe di lunghezza $k$ in ordine lessicografico, $forall k in NN$.

- Se $Sigma$ è un alfabeto infinito, con $Sigma = {a_1, a_2, dots, a_n, dots}$, dobbiamo usare un metodo particolare chiamato *diagonalizzazione* o *procedimento diagonale di Cantor*. Questo metodo consiste nel disporre gli elementi dell'alfabeto in verticale e in orizzontale a formare una tabella e poi a visitarla in maniera diagonale. Questa procedura vale per tutte le stringhe di lunghezza $k$ (segue un esempio di stringhe di lunghezza 2).

#figure(image("images/2026-03-03-17-57-48.png", width: 50%))

#observation()[
  Per passare a stringhe di lunghezza $k$ occorre un ragionamento induttivo; supponendo che le stringhe di lunghezza $k-1$ siano già state tutte enumerate, si fa la procedura descritta sopra mettendo sulle colonne le stringhe di lunghezza $k-1$, elencate secondo l'enumerazione che abbiamo per induzione, e sulle righe i simboli dell'alfabeto.
]
#observation()[
  $Sigma$ enumerabile $==> Sigma^*$ enumerabile.\ Infatti, possiamo enumerare tutte le stringhe di lunghezza 0, poi tutte le stringhe di lunghezza 1, poi tutte le stringhe di lunghezza 2, e così via.
]
#proposition()[
  $Sigma$ alfabeto, $L subset.eq Sigma^*$. $L$ è decidibile $==> L$ è enumerabile.
]

#proof()[
  Sia $M$ un algoritmo di decisione per $L$. Un algoritmo di enumerazione per $L$ è il seguente:
  #pseudocode-list[
    + Per $i = 1, 2, dots$:
      + Sia $w_i$ la $i$-esima stringa di $Sigma^*$;
      + Eseguo $M$ su $w_i$;
        + Se $w_i in L$, la scrivo;
        + Altrimenti no.
  ]

  Si noti che questo algoritmo richiede di saper elencare le stringhe di $Sigma^*$, cosa garantita dall'osservazione precedente.
]

#observation()[
  In generale, l'implicazione inversa *non* vale: $L$ enumerabile $arrow.r.double.not L$ decidibile. Questo perché se voglio capire se una stringa $x$ appartiene ad un linguaggio $L$ infinito con un algoritmo di enumerazione, potrei dover scorrere $L$ all'infinito senza mai trovare $x$. Vale però il risultato della proposizione seguente, dove $L^c = Sigma^* \\ L$.
]

#proposition()[
  $L$ è decidibile $<==> L$ è enumerabile e $L^c$ è enumerabile.
]
#proof()[
  ($==>$) $L$ è decidibile $==> L$ è enumerabile è già stato dimostrato nella precedente proposizione.

  Per dimostrare che $L$ decidibile $==> L^c$ enumerabile possiamo usare l'algoritmo di enumerazione per $L$ della proposizione precedente modificando le operazioni finali:
  #pseudocode-list[
    + Sia $w_i$ l'i-esima stringa di $Sigma^*$;
    + Eseguo $M$ su $w_i$;
      + Se $w_i in.not L$, la scrivo;
      + Altrimenti no.
  ]

  ($<==$) Sia $M$ un algoritmo di enumerazione per $L$ e $M^c$ un algoritmo di enumerazione per $L^c$. $M$ elenca tutti gli elementi di $L$: $w_1, w_2, dots$ e $M^c$ elenca gli elementi di $L^c$: $v_1, v_2, dots$. Dobbiamo cercare un algoritmo di decisione per $L$.

  Data $w in Sigma^*$, faccio partire $M$ finché non mi produce $w_1$, a questo punto confronto $w$ con $w_1$, se $w = w_1$ allora so che $w in L$, altrimenti interrompo l'esecuzione dell'algoritmo $M$ e faccio partire $M^c$ finché non mi produce $v_1$; se $w = v_1$ termino e concludo che $w in.not L$, altrimenti riprendo l'esecuzione di $M$ e confronto $w$ con la nuova stringa prodotta, e così via. In generale, questi due algoritmi prima o poi trovano una stringa che coincide con $w$, per cui riescono a determinare se $w in L$ o no, perché $w$ sarà nella lista delle stringhe prodotta da $M$ o in quella prodotta da $M^c$.
]

#index[Funzione caratteristica]
#definition()[
  Sia $L$ un linguaggio. La *funzione caratteristica* di $L$ è definita come:
  $
    chi_L: Sigma^* -> {0,1}\
    chi_L (w) = cases(
      0 & "se" w in.not L,
      1 & "se" w in L
    )
  $
  cioè, data una stringa $w$, la funzione caratteristica restituisce il valore 0 se la stringa non appartiene al linguaggio, oppure il valore 1 se essa vi appartiene.
]

#proposition()[
  $L$ è decidibile $<==> chi_L$ è una funzione computabile.
]
#proof()[
  ($==>$) Data una stringa $w in Sigma^*$, eseguo su $w$ l'algoritmo di decisione per $L$ (che ho per ipotesi perché $L$ è decidibile). Se $w in L$, scrivo 1, altrimenti 0.

  ($<==$) Data una stringa $w in Sigma^*$, calcolo $chi_L (w)$ (cosa che posso fare perché $chi_L$ è una funzione computabile). Se $chi_L (w) = 1$, allora $w in L$, altrimenti $w in.not L$.
]

#proposition()[
  Siano $L_1, L_2 subset.eq Sigma^*$ decidibili. Allora:
  + $L_1 union L_2$ è decidibile;
  + $L_1 inter L_2$ è decidibile;
  + $L_1^c$ è decidibile.
]
#proof()[
  Siano $M_1$ e $M_2$ algoritmi di decisione per $L_1$ e $L_2$ rispettivamente.
  + Algoritmo di decisione per $L_1 union L_2$, su input $w$: eseguo $M_1$; se $w in L_1$ termino e accetto, altrimenti eseguo $M_2$ e, se $w in L_2$, termino e accetto; altrimenti rifiuto.
  + Algoritmo di decisione per $L_1 inter L_2$, su input $w$: eseguo $M_1$; se $w in.not L_1$ rifiuto, altrimenti eseguo $M_2$: se $w in.not L_2$ rifiuto, se $w in L_2$ accetto.
  + Algoritmo di decisione per $L_1^c$, su input $w$: eseguo $M_1$ e scambio le sue risposte.
]

#index[Linguaggio semidecidibile]
#definition()[
  Un linguaggio $L subset.eq Sigma^*$ si dice *semidecidibile* quando esiste
  un algoritmo $M$ tale che, per ogni $w in Sigma^*$, se $w in L$, $M$ termina e accetta $w$.
]

#observation()[
  Ne segue che se $w in.not L$, $M$ non può terminare accettando $w$. La differenza rispetto alla decidibilità è che un algoritmo di decisione
  termina su ogni input: accetta se $w in L$ e rifiuta se $w in.not L$. Un
  algoritmo di semidecisione, invece, termina solo sugli input appartenenti
  a $L$; sugli input $w in.not L$ non termina (o comunque non accetta mai).
]

#proposition()[
  $L$ è enumerabile $<==> L$ è semidecidibile.
]
#proof()[
  ($==>$) Sia $M$ un algoritmo di enumerazione per $L$, che produce via via le stringhe $w_1, w_2, w_3, dots$ del linguaggio. Un algoritmo di semidecisione per $L$ è il seguente: data $w in Sigma^*$, faccio partire $M$ e confronto $w$ con le stringhe prodotte man mano. Se $w in L$, prima o poi $w$ compare tra le stringhe prodotte da $M$: l'algoritmo termina e accetta $w$. Se invece $w in.not L$, l'algoritmo non termina.

  ($<==$) Sia $M$ un algoritmo di semidecisione per $L$. Costruiamo una tabella che ha per righe le stringhe $w_1, w_2, dots$ di $Sigma^*$ e per colonne i passi di esecuzione di $M$, e la visitiamo con il procedimento diagonale di Cantor. Per ogni stringa $w_i$ ci sono due possibilità: o $M$ su $w_i$ esegue infiniti passi, oppure no. Se durante la visita in diagonale incontro una posizione vuota, significa che $M$ su quella stringa ha terminato dopo un numero finito di passi, e allora aggiungo tale stringa alla lista.

  Poiché la visita diagonale raggiunge ogni posizione della tabella in tempo finito, ogni stringa di $L$ prima o poi viene scritta: si ottiene così un algoritmo di enumerazione per $L$.
]

// 25.02.2026
== Funzioni iniziali

Il nostro obiettivo è quello di trovare una classe di funzioni che colgano nel modo più fedele possibile il concetto di funzione computabile. Le funzioni con cui avremo a che fare sono del tipo
$
  f: NN^k -> NN, quad (x_1, dots, x_k) |-> f(x_1, dots, x_k)
$
e, per convenzione, scriveremo $arrow(x) = (x_1, dots, x_k)$.

Le *funzioni iniziali* sono i mattoni con cui costruiremo funzioni più complesse.

#index[Funzioni iniziali]#index[Funzione costante]#index[Funzione successore]#index[Funzione proiezione]
#definition("Funzioni iniziali")[
  Si dicono *funzioni iniziali*:
  + *Funzione costante $k$-aria di valore 0*:
    $ C_0^((k)): NN^k -> NN, quad C_0^((k))(arrow(x)) = 0 $
  + *Funzione successore*:
    $ S: NN -> NN, quad S(x) = x + 1 $
  + *Funzione proiezione $j$-esima $k$-aria*:
    $ epsilon_j^((k)): NN^k -> NN, quad epsilon_j^((k))(arrow(x)) = x_j $
]

Prima di procedere, osserviamo che la scelta della rappresentazione dei numeri naturali non influisce sulla computabilità.

#index[Codifica]#index[Rappresentazione]#index[Funzione effettivamente invertibile]
#definition()[
  Siano $A$ un insieme e $Sigma$ un alfabeto. Una *codifica* di $A$ in $Sigma$ è una funzione $rho: A -> Sigma^*$. La funzione $rho$ si dice *rappresentazione* di $A$ in $Sigma$ quando:
  + $rho$ è computabile;
  + $rho$ è iniettiva;
  + $rho(A)$ è decidibile (cioè si può stabilire quali stringhe stanno nell'immagine della codifica) e $rho$ è *effettivamente invertibile*, cioè esiste un algoritmo che, $forall w in rho(A)$, restituisce l'unico elemento $a in A$ tale che $rho(a) = w$.
]

#proposition()[
  Sia $Sigma$ un alfabeto qualunque. Allora esiste una rappresentazione $rho: Sigma^* -> {0,1}^*$: le stringhe su $Sigma$ possono sempre essere codificate con stringhe binarie.
]
#proof()[
  Sia $Sigma = {a_1, a_2, dots, a_n, dots}$. Definiamo $rho: Sigma^* -> {0,1}^*$ ponendo
  $
    rho(a_(i_1) a_(i_2) dots a_(i_m)) = 0 underbrace(1 dots 1, i_1) space 0 underbrace(1 dots 1, i_2) space dots space 0 underbrace(1 dots 1, i_m)
  $
  cioè ogni lettera viene codificata da uno 0 (separatore) seguito da tanti 1 quanti ne indica il suo indice; per la stringa vuota si decide arbitrariamente di porre $rho(epsilon) = 0$. Poiché $Sigma^*$ è sempre composto da stringhe di lunghezza finita, valgono le tre proprietà richieste, per cui $rho$ è una rappresentazione di $Sigma^*$ in ${0,1}$.
]

#observation(multiple: true)[
  Nel seguito useremo due codifiche dei numeri naturali:
  + la *codifica binaria*;
  + la *codifica unaria*: si prende $Sigma = {1}$ e ogni $n in NN$ viene rappresentato da $n + 1$ simboli,
    $ n arrow.squiggly underbrace(1 1 dots 1, n+1) $
    così da poter rappresentare anche lo 0.
]

#observation()[
  Tutte le funzioni iniziali sono computabili. In codifica unaria, ad esempio:
  - $S(underbrace(1 dots 1, n+1)) = underbrace(1 dots 1, n+2)$, cioè basta aggiungere un simbolo in fondo alla stringa;

  - $C_0^((k))$ ritorna 0 a prescindere dalla codifica;

  - $epsilon_j^((k))$ codifica gli argomenti, scorre la lista degli argomenti e, arrivata al $j$-esimo, lo scrive.
]

== Composizione e ricorsione primitiva

Vediamo ora i due "costruttori" di funzioni, a partire dalle iniziali: la composizione generalizzata e la ricorsione primitiva.

#index[Composizione generalizzata]#index[Sostituzione]
#definition("Composizione generalizzata")[
  Siano $f: NN^m -> NN$ e $g_1, dots, g_m: NN^k -> NN$. La *composizione* (o *sostituzione*) *generalizzata* di $f$ con $(g_1, dots, g_m)$ è la funzione
  $
    f compose (g_1, dots, g_m): NN^k -> NN, quad (f compose (g_1, dots, g_m))(arrow(x)) = f(g_1(arrow(x)), dots, g_m (arrow(x)))
  $
]

#proposition()[
  $f, g_1, dots, g_m$ computabili $==> f compose (g_1, dots, g_m)$ è computabile.
]
#proof()[
  Siano $F, G_1, dots, G_m$ algoritmi di calcolo per $f, g_1, dots, g_m$. Un algoritmo di calcolo per $f compose (g_1, dots, g_m)$, data $arrow(x) in NN^k$, è il seguente:
  #pseudocode-list[
    + Uso $G_1, dots, G_m$ per calcolare $g_1(arrow(x)), dots, g_m (arrow(x))$;
    + Uso $F$ per calcolare $f(g_1(arrow(x)), dots, g_m (arrow(x)))$.
  ]
]

#index[Ricorsione primitiva (RP)]
#definition("Ricorsione primitiva")[
  Siano $g: NN^k -> NN$ e $phi: NN^(k+2) -> NN$. Diciamo che $f: NN^(k+1) -> NN$ è *definita per ricorsione primitiva* (RP) da $g$ e $phi$ quando
  $
    cases(
      f(arrow(x), 0) = g(arrow(x)),
      f(arrow(x), y+1) = phi(arrow(x), y, f(arrow(x), y))
    )
  $
  Ovvero: quando l'ultimo argomento è 0, calcolare $f$ equivale a calcolare $g$; quando l'ultimo argomento è $y + 1$, il calcolo di $f$ dipende dal valore che $f$ aveva quando l'ultimo argomento era $y$.
]

#proposition()[
  $g, phi$ computabili $==> f$ definita per RP da $g$ e $phi$ è computabile.
]
#proof()[
  Descriviamo un algoritmo per calcolare $f$ ragionando per induzione sull'ultimo parametro: in pratica, mostriamo che, fissato $arrow(x) in NN^k$, $forall y in NN$ si può calcolare $f(arrow(x), y)$.
  - *Caso base*: $y = 0$. Allora $f(arrow(x), 0) = g(arrow(x))$ e $g$ è computabile per ipotesi.
  - *Passo induttivo*: supponiamo di saper calcolare $f(arrow(x), y)$. Allora
    $
      f(arrow(x), y+1) = phi(arrow(x), y, underbrace(f(arrow(x), y), "computabile per ip. induttiva"))
    $
    e $phi$ è computabile per ipotesi. Quindi $f$ è computabile.
]

#index[Derivazione ricorsiva primitiva (drp)]
#definition()[
  Una *derivazione ricorsiva primitiva* (drp) è una sequenza di funzioni $f_1, f_2, dots, f_n$ t.c. $forall i = 1, dots, n$:
  - $f_i$ è una funzione iniziale, oppure
  - $f_i$ è ottenuta per RP da $f_j, f_k$ con $j, k < i$, oppure
  - $f_i$ è ottenuta per composizione generalizzata da funzioni precedenti.
]

#index[Funzione ricorsiva primitiva (rp)]
#definition()[
  Una funzione si dice *ricorsiva primitiva* (*_rp_*) quando compare in coda a una drp.
]

#observation(multiple: true)[
  + Ogni prefisso di una drp è una drp.
  + Come conseguenza della precedente, ogni funzione che compare in una drp è *_rp_*.

  Si noti la convenzione: *_rp_* minuscolo è riferito alla classe di funzioni, mentre RP maiuscolo si riferisce al fatto che una funzione è definita per ricorsione primitiva.
]

#proposition()[
  Ogni funzione *_rp_* è computabile.
]
#proof()[
  Si dimostra per induzione sulla lunghezza $n$ di una drp che termina con $f$.
  - *Caso base*: $n = 1$. L'unica possibilità è che $f$ sia una funzione iniziale, dunque $f$ è computabile.
  - *Passo induttivo*: supponiamo che tutte le funzioni che compaiono in coda a una drp di lunghezza strettamente minore di $n$ siano computabili, e sia $f_1, dots, f_n = f$ una drp. Allora $f$ è iniziale (e quindi computabile), oppure è ottenuta per composizione o per RP da funzioni $f_j, f_k$ con $j, k < n$, che sono computabili per ipotesi induttiva. Per le due proposizioni precedenti, anche $f$ è computabile.
]

// 26.02.2026
#proposition()[
  + $g: NN^k -> NN$ e $phi: NN^(k+2) -> NN$ *_rp_* $==>$ $f$ ottenuta per RP da $g$ e $phi$ è *_rp_*;
  + $f: NN^m -> NN$ e $g_1, dots, g_m: NN^k -> NN$ *_rp_* $==>$ $f compose (g_1, dots, g_m)$ è *_rp_*.
]
#proof()[
  + Per ipotesi $g_1, dots, g_r, g$ è una drp e $phi_1, dots, phi_s, phi$ è una drp. Allora
    $ g_1, dots, g_r, g, phi_1, dots, phi_s, phi, f $
    è a sua volta una drp, per cui $f$ è *_rp_*.
  + Analoga alla precedente: si concatenano le drp di $f, g_1, dots, g_m$ e si aggiunge in coda $f compose (g_1, dots, g_m)$.
]

== Esempi di funzioni ricorsive primitive

#observation()[
  Per verificare che una funzione è *_rp_* si dimostra che essa può essere scomposta in funzioni più semplici (eventualmente composte) che sono *_rp_*.
]

#example([Funzione costante $k$-aria di valore $m$])[
  $
    C_m^((k)): NN^k -> NN, quad C_m^((k))(x_1, dots, x_k) = m quad (m in NN)
  $
  Si dimostra per induzione su $m in NN$:
  - *Caso base*: $m = 0$. Allora $C_0^((k))$ è *_rp_* perché è una funzione iniziale;
  - *Passo induttivo*: supponiamo che $C_m^((k))$ sia *_rp_*. Allora
    $ C_(m+1)^((k))(arrow(x)) = m + 1 = (S compose C_m^((k)))(arrow(x)) $
    che è composizione di funzioni *_rp_*, dunque $C_(m+1)^((k))$ è *_rp_*.
]

#example("Funzione predecessore")[
  $
    nu: NN -> NN, quad nu(x) = cases(x - 1 & "se" x != 0, 0 & "se" x = 0)
  $
  È *_rp_* perché ammette il seguente schema di RP:
  $
    cases(
      nu(0) = 0,
      nu(x+1) = epsilon_1^((2))(x, nu(x)) = x
    )
  $
]

#example("Funzione somma")[
  $
    s: NN^2 -> NN, quad s(x, y) = x + y
  $
  $
    cases(
      s(x, 0) = x = epsilon_1^((1))(x),
      s(x, y+1) = x + y + 1 = (S compose epsilon_3^((3)))(x, y, s(x, y))
    )
  $
  Le funzioni successore e proiezione sono *_rp_*, dunque $s$ è *_rp_*.
]

#example("Funzione prodotto")[
  $
    p: NN^2 -> NN, quad p(x, y) = x dot y
  $
  $
    cases(
      p(x, 0) = C_0^((1))(x) = 0,
      p(x, y+1) = x y + x = (s compose (epsilon_3^((3)), epsilon_1^((3))))(x, y, p(x, y))
    )
  $
  La funzione somma $s$ è *_rp_*, dunque $p$ è *_rp_*.
]

#example("Funzione elevamento a potenza")[
  $
    pi: NN^2 -> NN, quad pi(x, y) = x^y
  $
  $
    cases(
      pi(x, 0) = C_1^((1))(x) = 1,
      pi(x, y+1) = x^(y+1) = (p compose (epsilon_3^((3)), epsilon_1^((3))))(x, y, pi(x, y))
    )
  $
]

#example("Funzione fattoriale")[
  $
    f: NN -> NN, quad f(x) = x!
  $
  $
    cases(
      f(0) = 1,
      f(x+1) = (x+1)! = (p compose (S compose epsilon_1^((2)), epsilon_2^((2))))(x, f(x))
    )
  $
]

#example("Funzione differenza troncata")[
  $
    minus.dot: NN^2 -> NN, quad x minus.dot y = cases(x - y & "se" x >= y, 0 & "se" x < y)
  $
  $
    cases(
      x minus.dot 0 = x = epsilon_1^((1))(x),
      x minus.dot (y+1) = nu(x minus.dot y) = (nu compose epsilon_3^((3)))(x, y, x minus.dot y)
    )
  $
]

#example("Funzione distanza")[
  $
    d: NN^2 -> NN, quad d(x, y) = |x - y|
  $
  Si ha che $d(x, y) = minus.dot(x, y) + (minus.dot(y, x))$: uno dei due addendi dà il risultato corretto a seconda che $x <= y$ oppure $x > y$, mentre l'altro vale 0:
  $
    d(x, y) = (x minus.dot y) + (y minus.dot x) = (s compose (minus.dot compose (epsilon_1^((2)), epsilon_2^((2))), minus.dot compose (epsilon_2^((2)), epsilon_1^((2)))))(x, y)
  $
  È dunque *_rp_* in quanto composizione di funzioni *_rp_*.
]

#example("Funzione segno")[
  $
    "sg": NN -> NN, quad "sg"(x) = cases(1 & "se" x > 0, 0 & "se" x = 0)
  $
  $
    cases(
      "sg"(0) = 0,
      "sg"(x+1) = C_1^((2))(x, "sg"(x)) = 1
    )
  $
]

#example(multiple: true, "Esercizi")[
  Le due funzioni seguenti sono lasciate da dimostrare per esercizio.
  + *Funzione segno opposto*:
    $
      overline("sg"): NN -> NN, quad overline("sg")(x) = cases(0 & "se" x != 0, 1 & "se" x = 0)
      quad quad
      cases(
        overline("sg")(0) = 1,
        overline("sg")(x+1) = C_0^((2))(x, overline("sg")(x)) = 0
      )
    $
  + *Funzione delta di Kronecker*:
    $
      delta: NN^2 -> NN, quad delta(x, y) = cases(1 & "se" x = y, 0 & "altrimenti")
    $
    È *_rp_* per composizione: $delta(x, y) = (overline("sg") compose d)(x, y)$.
]

== Somma e prodotto limitato

Vediamo il caso in cui vogliamo calcolare la somma di più argomenti, però il numero degli argomenti non è fissato, ma è anch'esso un parametro.

#index[Somma limitata]
#definition("Somma limitata")[
  Sia $f: NN^(k+1) -> NN$. Definiamo $g: NN^(k+1) -> NN$ ponendo
  $
    g(arrow(x), z) = sum_(y=0)^z f(arrow(x), y)
  $
  Diciamo che $g$ è ottenuta per *somma limitata* da $f$; la funzione che, data $f$, costruisce $g$ si dice *operatore di somma limitata*.
]

#proposition()[
  $f$ *_rp_* $==> g$ ottenuta per somma limitata da $f$ è *_rp_*.
]
#proof()[
  Cerchiamo uno schema di RP per $g$:
  $
    g(arrow(x), 0) &= sum_(y=0)^0 f(arrow(x), y) = f(arrow(x), 0) = (f compose (epsilon_1^((k+1)), dots, epsilon_k^((k+1)), C_0^((k+1))))(arrow(x), 0) \
    g(arrow(x), z+1) &= sum_(y=0)^(z+1) f(arrow(x), y) = sum_(y=0)^z f(arrow(x), y) + f(arrow(x), z+1) = \
    &= (s compose (epsilon_(k+2)^((k+2)), f compose (epsilon_1^((k+2)), dots, epsilon_k^((k+2)), S compose epsilon_(k+1)^((k+2)))))(arrow(x), z, g(arrow(x), z))
  $
  Entrambi i membri sono ottenuti per composizione di funzioni *_rp_*, dunque $g$ è *_rp_*.
]

#observation()[
  Si può dare una definizione alternativa di somma limitata, in cui $f: NN^(k+2) -> NN$ e
  $
    g(arrow(x), z) = sum_(y=0)^z f(arrow(x), y, z)
  $
  ma non cambia nulla in sostanza.
]

#index[Prodotto limitato]
#definition("Prodotto limitato")[
  Sia $f: NN^(k+1) -> NN$. Definiamo $g: NN^(k+1) -> NN$ ponendo
  $
    g(arrow(x), z) = product_(y=0)^z f(arrow(x), y)
  $
  Diciamo che $g$ è ottenuta per *prodotto limitato* da $f$.
]

#proposition()[
  $f$ *_rp_* $=> g$ ottenuta per prodotto limitato da $f$ è *_rp_*.
]

#example("Esercizio d'esame")[
  Sia $g: NN^2 -> NN$ una funzione *_rp_*. Verificare che le funzioni seguenti sono *_rp_*.
  + $f_1(x, y, z_1, dots, z_m) = g(x, y)$
    $
      f_1(x, y, z_1, dots, z_m) = g(x, y) = underbrace((g compose (epsilon_1^((m+2)), epsilon_2^((m+2)))), italic("rp"))(x, y, z_1, dots, z_m)
    $
  + $f_2(x, y) = g(y, x)$
    $
      f_2(x, y) = underbrace((g compose (epsilon_2^((2)), epsilon_1^((2)))), italic("rp"))(x, y)
    $
  + $f_3(x) = g(x, x)$
    $
      f_3(x) = underbrace((g compose (epsilon_1^((1)), epsilon_1^((1)))), italic("rp"))(x)
    $
]

// 27.02.2026
== Relazioni ricorsive primitive

#index[Relazione k-aria]#index[Funzione buona per una relazione]
#definition()[
  Sia $R subset.eq NN^k$ una *relazione $k$-aria* (cioè un sottoinsieme di $NN^k$). Una funzione $f: NN^k -> NN$ si dice *buona* per $R$ quando
  $
    forall arrow(x) in NN^k, quad f(arrow(x)) = 0 <==> arrow(x) in R
  $
  cioè quando $f$ riconosce se $arrow(x) in R$ oppure no.
]

#index[Relazione ricorsiva primitiva]
#definition()[
  Una relazione $k$-aria $R subset.eq NN^k$ si dice *ricorsiva primitiva* (*_rp_*) quando esiste una funzione $f: NN^k -> NN$ *_rp_* buona per $R$.
]

#observation()[
  $R subset.eq NN^k$ è *_rp_* $<==>$ la sua funzione caratteristica $chi_R$ è *_rp_*, dove
  $
    chi_R: NN^k -> NN, quad chi_R (arrow(x)) = cases(
      1 & "se" arrow(x) in R,
      0 & "se" arrow(x) in.not R
    )
  $
]
#proof()[
  ($==>$) $R$ è *_rp_*, quindi sia $f: NN^k -> NN$ *_rp_* buona per $R$. Allora
  $ chi_R (arrow(x)) = (overline("sg") compose f)(arrow(x)) $
  e, poiché $overline("sg")$ è *_rp_*, anche $chi_R$ è *_rp_*.

  ($<==$) $chi_R$ è *_rp_*. Osservo che $overline("sg") compose chi_R$ è una funzione *_rp_* buona per $R$, dunque $R$ è *_rp_*.
]

#proposition()[
  $R subset.eq NN^k$ *_rp_* $==> R^c = NN^k \\ R$ è *_rp_*.
]
#proof()[
  $R$ *_rp_* $==> chi_R$ è *_rp_* $==> chi_R$ è una funzione buona per $R^c$ (infatti $chi_R (arrow(x)) = 0$ esattamente quando $arrow(x) in R^c$) $==> R^c$ è *_rp_*.
]

#proposition()[
  $R, S subset.eq NN^k$ *_rp_* $==> R union S$ è *_rp_*.
]
#proof()[
  $chi_R$ e $chi_S$ sono *_rp_*, e vale
  $
    chi_(R union S)(arrow(x)) = ("sg" compose (chi_R + chi_S))(arrow(x)) = ("sg" compose (s compose (chi_R, chi_S)))(arrow(x))
  $
  che è *_rp_* in quanto composizione di funzioni *_rp_*, dunque $R union S$ è *_rp_*.
]

#proposition()[
  $R, S subset.eq NN^k$ *_rp_* $==> R inter S$ è *_rp_*.
]
#proof()[
  $chi_R$ e $chi_S$ sono *_rp_*, e vale
  $
    chi_(R inter S)(arrow(x)) = (chi_R dot chi_S)(arrow(x))
  $
  che è *_rp_*, dunque $R inter S$ è *_rp_*.
]

#index[Funzione definita per casi]
#definition("Funzione definita per casi")[
  Una funzione $f: NN^k -> NN$ si dice *definita per casi* a partire dalle funzioni $f_1, dots, f_m$ e dalle relazioni $R_1, dots, R_m$ (con $R_1, dots, R_m$ partizione di $NN^k$) quando
  $
    f(arrow(x)) = cases(
      f_1(arrow(x))\, & arrow(x) in R_1,
      f_2(arrow(x))\, & arrow(x) in R_2,
      dots.v,
      f_m (arrow(x))\, & arrow(x) in R_m
    )
  $
]

#proposition()[
  Sia $f: NN^k -> NN$ definita per casi da $f_1, dots, f_m$ e $R_1, dots, R_m$. Se $f_1, dots, f_m$ sono *_rp_* e $R_1, dots, R_m$ sono *_rp_*, allora $f$ è *_rp_*.
]
#proof()[
  Possiamo scrivere $f$ come
  $
    f(arrow(x)) = underbrace(f_1(arrow(x)), italic("rp")) dot underbrace(chi_(R_1)(arrow(x)), italic("rp")) + f_2(arrow(x)) dot chi_(R_2)(arrow(x)) + dots + f_m (arrow(x)) dot chi_(R_m)(arrow(x))
  $
  Ogni addendo è *_rp_* in quanto prodotto di funzioni *_rp_*, e si può dimostrare che una somma di un numero fissato di addendi *_rp_* è *_rp_*. Dunque $f$ è *_rp_*.
]

#corollary()[
  Sia
  $
    f(arrow(x)) = cases(
      f_1(arrow(x))\, & arrow(x) in R_1,
      dots.v,
      f_(m-1)(arrow(x))\, & arrow(x) in R_(m-1),
      f_m (arrow(x))\, & "altrimenti"
    )
  $
  con $f_1, dots, f_m$ *_rp_* e $R_1, dots, R_(m-1)$ *_rp_*. Allora $f$ è *_rp_*.
]
#proof()[
  Basta porre $R_m = NN^k \\ (R_1 union dots union R_(m-1))$, che è *_rp_* perché complementare di un'unione di relazioni *_rp_*.
]

#example()[
  Sia $R subset.eq NN^2$ definita ponendo $(x, y) in R$ quando $x <= y$. Dimostriamo che $R$ è *_rp_*.
  $
    chi_R (x, y) = cases(1\, & x <= y, 0\, & x > y)
  $
  Possiamo scriverla come
  $
    chi_R (x, y) = "sg"((y minus.dot x) + delta(x, y)) = ("sg" compose (s compose (minus.dot compose (epsilon_2^((2)), epsilon_1^((2))), delta)))(x, y)
  $
  dove la delta di Kronecker serve per il solo caso $y = x$. Poiché è ottenuta per composizione di funzioni *_rp_*, $chi_R$ è *_rp_* e dunque lo è anche $R$.
]

== Minimalizzazione

#index[Minimalizzazione]
#definition("Minimalizzazione")[
  Sia $R subset.eq NN^(k+1)$. La funzione $f: NN^k -> NN$ si dice ottenuta per *minimalizzazione* da $R$ quando
  $
    f(arrow(x)) = cases(
      min{z in NN | (arrow(x), z) in R}\, space & "se tale insieme è non vuoto",
      0\, & "altrimenti"
    )
  $
]

Questa funzione non sembra intuitivamente computabile, perché la ricerca del minimo potrebbe proseguire all'infinito. Per cui è necessario dare una limitazione al valore di $z$.

#index[Minimalizzazione limitata]
#definition("Minimalizzazione limitata")[
  Sia $R subset.eq NN^(k+1)$. La funzione $f: NN^(k+1) -> NN$ si dice ottenuta per *minimalizzazione limitata* da $R$ quando
  $
    f(arrow(x), y) = cases(
      min{z <= y | (arrow(x), z) in R}\, space & "se tale insieme è non vuoto",
      0\, & "altrimenti"
    )
  $
]

#proposition()[
  $R$ decidibile $==> f$ ottenuta per minimalizzazione limitata da $R$ è computabile.
]
#proof()[
  Sia $M$ un algoritmo di decisione per $R$. Un algoritmo di calcolo per $f$, su input $(arrow(x), y) in NN^(k+1)$, è il seguente ciclo `for`:
  #pseudocode-list[
    + Per $z$ da 0 a $y$:
      + Decido se $(arrow(x), z) in R$ usando $M$;
      + Se sì, restituisco $z$;
    + Restituisco 0.
  ]
]

#proposition()[
  $R$ *_rp_* $==> f$ ottenuta per minimalizzazione limitata da $R$ è *_rp_*.
]
#proof()[
  Vogliamo trovare uno schema di RP per $f$:
  $
    cases(
      f(arrow(x), 0) = g(arrow(x)),
      f(arrow(x), y+1) = phi(arrow(x), y, f(arrow(x), y))
    )
  $
  *Caso base*: è immediato, $f(arrow(x), 0) = 0 = C_0^((k))(arrow(x))$, che è *_rp_*.\
  *Passo induttivo*: supponiamo noto $t=f(arrow(x),y)$. Passando dal limite $y$ al limite $y+1$ si ha che
  $
    f(arrow(x), y+1) = cases(
      f(arrow(x), y)\, & " se " exists space 0 <= z <= y "t.c." (arrow(x), z) in R,
      y + 1\, & " se non siamo nel caso sopra e" (arrow(x), y+1) in R,
      0\, & " altrimenti"
    )
  $
  che possiamo scrivere come funzione definita per casi
  $
    phi(arrow(x), y, t) = cases(
      t\, & "se" (arrow(x), y, t) in R_1,
      y + 1\, & "se" (arrow(x), y, t) in R_2,
      0\, & "altrimenti"
    )
  $
  dove
  $
    R_1 & = {(arrow(x), y, t) | exists space z, 0 <= z <= y: (arrow(x), z) in R}, \
    R_2 & = {(arrow(x), y, t) | (arrow(x), y, t) in.not R_1 "e" (arrow(x), y+1) in R}.
  $
  Per costruzione $f(arrow(x), y+1) = phi(arrow(x), y, f(arrow(x), y))$. Resta da mostrare che $phi$ è *_rp_*.

  Le tre funzioni associate ai tre casi lo sono: $t = epsilon_(k+2)^((k+2))$, $y + 1 = S compose epsilon_(k+1)^((k+2))$ e $0 = C_0^((k+2))$. Mostriamo adesso che sono _*rp*_ anche le relazioni $R_1$, $R_2$. Ricordando che per ipotesi $R$ è *_rp_*, e dunque $chi_R$ è *_rp_*:

  - $R_1$ è *_rp_* perché
    $
      chi_(R_1)(arrow(x), y, t) = "sg" (underbrace(sum_(z=0)^y chi_R (arrow(x), z), "somma limitata di" chi_R))
    $
    ed è quindi ottenuta per composizione a partire dall'operatore di somma limitata applicato a $chi_R$, che è *_rp_* (a meno della composizione con le proiezioni necessaria per portare l'arietà a $k+2$);

  - poniamo $T = {(arrow(x), y, t) in NN^(k+2) | (arrow(x), y+1) in R}$, che soddisfa la seconda condizione di $R_2$. Vale
    $
      chi_T (arrow(x), y, t) = chi_R (arrow(x), y+1) = (chi_R compose (epsilon_1^((k+2)), dots, epsilon_k^((k+2)), S compose epsilon_(k+1)^((k+2))))(arrow(x), y, t)
    $
    dunque $chi_T$ è *_rp_* e quindi lo è $T$. Ne segue che
    $ R_2 = underbrace(R_1^c, italic("rp")) inter underbrace(T, italic("rp")) $
    è *_rp_*.
  Quindi $phi$ è *_rp_* e, di conseguenza, lo è anche $f$ (vedi Proposizione 1.6.4).
]

== Enumerabilità delle funzioni ricorsive primitive

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
  - Ricorsione Primitiva: $f$ definita per RP da $g$ e $phi$ è rappresentata come $R(g, phi)$

  Per evitare ambiguità sintattiche, utilizziamo le parentesi tonde per racchiudere gli argomenti e le parentesi angolari $< >$ per delimitare l'inizio e la fine della codifica di ogni singola sotto-funzione.

  L'alfabeto finito di simboli necessario per la nostra codifica è quindi il seguente:
  $
    Sigma = {c, 0, 1, dots, 9, S, epsilon, ",", compose, "(", ")", R, "<", ">"}
  $

  #example()[
    Consideriamo la funzione somma $s$, definita per ricorsione primitiva come:
    $
      s = R(epsilon_1^((1)), S compose epsilon_3^((3)))
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
  Definiamo ora una nuova funzione $g(x) = f_x (x) + 1$.

  Possiamo fare due osservazioni chiave su $g$:
  - $g$ è computabile: dato un input $x$, è possibile costruire un algoritmo che trovi la funzione $f_x$ nell'enumerazione, ne calcoli il valore per l'argomento $x$ e vi sommi $1$.
  - Esiste un indice $n$ tale che $g = f_n$: per la nostra ipotesi di partenza, essendo $g$ computabile, essa deve essere anche *_rp_*. Pertanto, deve necessariamente comparire all'interno dell'enumerazione.

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

== Funzione di Ackermann
#index[Funzione di Ackermann]
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

È una funzione computabile (anche se difficile da calcolare) e non è ricorsiva primitiva. Cresce enormemente, ma la convergenza del calcolo ricorsivo è lenta: occorrono moltissimi passi per arrivare al risultato. Più il primo argomento è grande, più $A$ cresce velocemente:

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

  Ovvero, per qualunque funzione *_rp_* del tipo $g: NN^k -> NN$, esiste una costante (un numero naturale) tale che, per ogni $k$-upla, il valore della funzione su tale $k$-upla è strettamente minore della funzione di Ackermann con primo argomento la costante e secondo argomento la sommatoria della $k$-upla.
]
#proof()[
  Si dimostra per induzione strutturale sulla costruzione dell'insieme delle funzioni *_rp_*:
  - Caso base: funzioni iniziali
    - $C_0^((k))(arrow(x)) = 0 < 1 + sum_(i=1)^k x_i = A(0, sum_(i=1)^k x_i) => c = 0$

    - $S(x) = x + 1 < x + 2 = A(0, x + 1) limits(<=)^"(3)" A(1, x) => c = 1$

    - $epsilon_j^((k))(arrow(x)) = x_j < 1 + sum_(i=1)^k x_i = A(0, sum_(i=1)^k x_i) => c = 0$

  - Passo induttivo: supponiamo che la funzione $g$ sia ottenuta per composizione dalle funzioni $h, f_1, dots, f_m$ che sono *_rp_* (con $h: NN^m -> NN$ e $f_1, dots, f_m: NN^k -> NN$), cioè $g = h compose (f_1, dots, f_m)$.
    Supponiamo che il lemma valga per $h, f_1, dots, f_m$, ossia:

    - $h(x_1, dots, x_m) < A(D, sum_(i=1)^m x_i) quad (exists D)$

    - $f_j (x_1, dots, x_k) < A(C_j, sum_(i=1)^k x_i) quad (exists C_j, forall j=1, dots, m)$

    Facciamo vedere che il lemma vale per $g$:
    $
      g(arrow(x)) &= h(f_1(arrow(x)), dots, f_m (arrow(x))) < A(D, sum_(j=1)^m f_j (arrow(x))) \
      &< A(D, sum_(j=1)^m A(C_j, sum_(i=1)^k x_i)) limits(<=)^"(5)" A(D, A(tilde(C), sum_(i=1)^k x_i)) <= quad quad E = max(D, tilde(C)), \
      &<= A(E, A(E+1, sum_(i=1)^k x_i)) limits(=)^"def." A(E+1, sum_(i=1)^k x_i + 1) limits(<=)^"(3)" A(E+2, sum_(i=1)^k x_i)
    $
    Quindi anche $g$ soddisfa il lemma (notare che $tilde(C) = max(C_j)+4(m-1)$). Infine, per completare il passo induttivo, occorrerebbe trattare il caso di una funzione ottenuta per RP, ma la dimostrazione di quest'ultimo caso viene omessa.
]

#proposition()[
  La funzione di Ackermann non è *_rp_*.
]
#proof()[
  Supponiamo per assurdo che $A$ sia *_rp_*.

  Allora, anche la funzione $B(x) = A(x, x)$ è *_rp_* ($B = A compose (epsilon_1^((1)), epsilon_1^((1)))$). Posso applicare la proposizione precedente, quindi $exists c in NN$ tale che $forall x in NN, B(x) < A(c, x)$.

  Ma allora se scelgo $x = c$ ottengo $B(c) < A(c, c) = B(c)$ per definizione, cioè $B(c)$ strettamente minore di $B(c)$, il che è assurdo. Quindi $A$ non è *_rp_*.
]

#index[Funzione regolare]
#definition()[
  Sia $g$ una funzione, con $g: NN^(k+1) -> NN$. Essa si dice *regolare* quando
  $
    forall arrow(x) in NN^k, exists y in NN quad "t.c." quad g(arrow(x), y) = 0
  $
]
#definition()[
  Una funzione $f: NN^k -> NN$ si dice *ottenuta per minimalizzazione* da $g: NN^(k+1) -> NN$ regolare quando
  $ f(arrow(x)) = min{y in NN | g(arrow(x), y) = 0} $
]

#index[Derivazione μ-ricorsiva]#index[Funzione μ-ricorsiva]
#definition()[
  Una *derivazione $mu$-ricorsiva* è una sequenza di funzioni $f_1, f_2, dots, f_n$ t.c. $forall i=1, dots, n$:
  - $f_i$ è una funzione iniziale, oppure
  - $f_i$ è ottenuta per composizione da funzioni precedenti, oppure
  - $f_i$ è ottenuta per RP da due funzioni precedenti, oppure
  - $f_i$ è ottenuta da $f_j$ regolare per minimalizzazione (con $j < i$)
  \
  Una *funzione* si dice *$mu$-ricorsiva* quando compare in coda ad una derivazione $mu$-ricorsiva.
]

#proposition()[
  Sia $g: NN^(k+1) -> NN$ regolare e computabile, e sia $f$ ottenuta da $g$ per minimalizzazione. Allora $f$ è computabile.
]
#proof()[
  Sia $G$ un algoritmo di calcolo per $g$. Un algoritmo di calcolo per $f$, data $arrow(x) in NN^k$, è il seguente:
  - per $y = 0, 1, 2, dots$:
    - calcolo $g(arrow(x), y)$ (usando $G$);
    - se ottengo 0, restituisco $y$.

  Il fatto che $g$ sia regolare garantisce che l'algoritmo termini.
]

#observation()[
  Si può dimostrare che la funzione di Ackermann è $mu$-ricorsiva.
]

== Tesi di Church (per le funzioni $mu$-ricorsive)
#index[Tesi di Church]
#proposition()[
  La classe delle *funzioni computabili* coincide con la classe delle *funzioni $mu$-ricorsive*.
]
#pagebreak()
