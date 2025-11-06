#import "../../../dvd.typ": *
= Algebra relazionale

E' un insieme di operatori logici su relazioni che producono a loro volta relazioni e che possono essere composti:

- Unione, intersezione, differenza
- Ridenominazione
- Selezione
- Proiezione
- Join (naturale, prodotto cartesiano, theta-join)

Ricordando che le relazioni sono insiemi, anche i risultati di queste operazioni devono sempre essere relazioni. Le op. di unione, intersezione e differenza possono essere applicate solo ad relazioni su gli stessi attributi.

#figure(image("images/image.png"), caption: "Esempio intersezione")
#figure(image("images/image 1.png"), caption: "Esempio differenza")
#figure(image("images/image 2.png"), caption: "Esempio unione")
#figure(image("images/image 3.png"), caption: "Esempio di unione impossibile")

== Ridenominazione

E' un operatore monadico (un solo argomento). Modifica lo schema lasciando inalterata l'istanza dell'operando. (semplicemente modifico il nome degli attributi)

#definition(
  )[
  Data $r$ di schema $R(A_1,...,A_k)$ e un insieme di attributi $B_1, ..., B_k$ l'operatore di ridenominazione:

  $
    rho_(B_1 ... B_k <- A_1 ... A_k) (r) space "oppure" space "REN"_(B_1...B_k <- A_1...A_k(r))
  $

  Produce una relazione di schema $R(B_1,...,B_k)$ che contiene una tupla $t'$ per ogni tupla $t$ contenuta nella relazione originaria in modo tale che $t'[B_i]=t[A_i] space forall i$
]

#figure(image("images/image 4.png"))
#figure(image("images/image 6.png"))
#figure(image("images/image 5.png"))

== Selezione

Ovvero una *decomposizione orizzontale*. Permette di effettuare un taglio sulla tabella in base ad una condizione specificata. Produce un risultato che ha lo stesso schema dell'operando. Contiene un sottoinsieme delle ennuple dell'operando, ovvero quelle che soddisfano una condizione.

#definition()[
  Formula proposizionale per schema $R(A_1,...,A_k)$:

  - $A_i theta A_j$ con $theta in {=,eq.not, >, <, gt.eq, lt.eq}$ è una formula
  - $A_i theta c$ con $c in "dom"(A_i)$ è una formula
  - Se $F_1$ e $F_2$ sono formule allora anche $F_1 and F_2$, $F_1 or F_2$ e $not F_1$ sono formule

  Data $r$ di schema $R(A_1,...,A_k)$ e $F$ formula proposizionale, l'operatore di selezione

  $
    sigma_F(r) space "oppure" space "SEL"_F(r)
  $

  produce una relazione sugli attributi di $R$ che contiene le tuple di $r$ su cui $F$ è vera.
]

#figure(image("images/image 7.png"))
#figure(image("images/image 8.png"))

== Proiezione

Ovvero una *decomposizione verticale*. E' un operatore monadico che produce un risultato che ha parte degli attributi dell'operando. Praticamente mostra l'intera tabella ma senza le colonne che non vogliamo vedere. Contiene ennuple cui contribuiscono tutte le ennuple dell'operando.

#definition(
  )[
  Dato l'insieme di attributi $X = {A_1, ... ,A_k}$, la relazione $r$ di schema $R(X)$ e un sottoinsieme $Y subset X$ l'operatore di proiezione

  $
    pi Y(r) space "oppure" space "PROJ"_(Y(r))
  $

  produce una relazione su $Y$ ottenuta dalla tuple di $r$ considerando solo i valori su $Y$.
]

#figure(image("images/image 9.png"))
#figure(image("images/image 10.png"))

Una proiezione contiene al più tante ennuple quante l'operando ma può contenerne di meno. Se $X$ è una superchiave (insieme di attributi che include una chiave) di $R$, allora $pi_X (R)$ contiene esattamente tante ennuple quante $R$.

Selezione e proiezione possono essere combinati insieme per estrarre informazioni da una sola relazione.

#figure(image("images/image 11.png"))

#observation(
  )[
L'operazione di selezione nell'algebra relazionale corrisponde al WHERE in SQL mentre la proiezione all'istruzione SELECT “nome attributo”. Nell'esempio precedente sarebbe:

```sql
SELECT Matricola, Cognome FROM impiegati WHERE Stipendio>50;
```
]

== Join

Permette di congiungere dati in relazioni/tabelle diverse. E' un operatore binario generalizzabile ovvero che normalmente lavora su due argomenti ma volendo può lavorare su di più.

Produce un risultato sull'unione degli attributi degli operandi, con ennuple costruite ciascuna a partire da una ennupla di ognuno degli operandi.

#definition(
  )[
  Dati $R_1(X_1)$ e $R_2(X_2)$ il join naturale $R_1 join R_2$ oppure $R_1$JOIN $R_2$ è una relazione sull'unione $X_1 union X_2$:

  $
    R_1 join R_2 = {t in X_1 union X_2 | exists t_1 in R_1 space e space t_2 in R_2 space t.c. space
    t[X_1] = t_1 space e space t[X_2] = t_2}
  $
]



Le tuple del risultato di un join naturale sono ottenute combinando tuple degli operandi con valori uguali sugli attributi.

- Se X1 e X2 hanno attributi in comune si ha la definizione tradizionale di join naturale.
- Se X1 e X2 sono disgiunti si ha la definizione di prodotto cartesiano.
- Se X1 e X2 coincidono si ha la definizione dell'intersezione.

#figure(image("images/image 12.png"))

Date $r, s$ definite su insiemi di attributi non disgiunti: $R(A_1,...,A_k,...,A_n)$ e $S(A_1,...,A_k,B_1,...,B_m)$ il risultato di
$r join s$ è una relazione definita su $A_1,...,A_n,B_1,...,B_m$:

$
  Z(A_1,...,A_n,B_1,...,B_m)
$

che contiene il seguente insieme di tuple ${t | t[A_1,...,A_n] in r and t[A_1,...,A_k ,B_1,_,B_m] in s}$

#figure(image("images/image 12.png"), caption: "Join completo")


Join completo

#figure(image("images/image 14.png"), caption: "Join non completo")

Join non completo

#figure(image("images/image 15.png"), caption: "Join vuoto")

Join vuoto

=== Cardinalità del join

Il join di R1 e R2 contiene un numero di ennuple compreso fra zero e il prodotto di $|R_1|$ e $|R_2|$:

- Se il join coinvolge una chiave di $R_2$, allora il numero di ennuple è compreso fra zero e $|R_1|$;
- Se il join coinvolge una chiave di R2 e un vincolo di integrità referenziale, allora il numero di ennuple è pari a |R1|.

  Date $R_1(A,B)$, $R_2(B,C)$ in generale si ha:

  - $0 lt.eq |R_1 join R_2| lt.eq |R_1| times |R_2|$

  Se $B$ è chiave in $R_2$

  - $0 lt.eq |R_1 join R_2| lt.eq |R_1|$

  Se $B$ è chiave in $R_2$ ed esiste vincolo di integrità referenziale fra $B$ (in $R_1$) e $R_2$:

  - $|R_1 join R_2| = |R_1|$

  #figure(image("images/image 16.png"))

  #figure(image("images/image 17.png"))


=== Join esterno

#figure(image("images/image 18.png"))

Il join esterno estende, con valori nulli, le ennuple che verrebbero tagliate fuori da un join (interno). Esiste in tre versioni:

- sinistro: mantiene tutte le ennuple del primo operando, estendendole con valori nulli, se necessario;

  #figure(image("images/image 19.png"))


- destro: . . . del secondo operando . . .

  #figure(image("images/image 20.png"))


- completo: . . . di entrambi gli operandi . . .

  #figure(image("images/image 21.png"))



#definition(
  )[
  Date $r$, $s$ deﬁnite su insiemi di attributi non disgiunti $R(A_1, ..., A_k , ... , A_n)$ e $S(A_1, ... , A_k , B_1, ... , B_m)$ il risultato di $r join_{"FULL"} s$ è una relazione deﬁnita su $A_1, ... , A_n, B_1, ... , B_m$:

  $
    Z (A_1, ... , A_n, B_1, ... , B_m)
  $

  deﬁnita come segue:

  $
    r join_{"FULL"} s = r join s space union (r - π_{A_1,··· ,A_n} (r join s)) times {B_1 = "null", ... , B_m = "null"} union \ union {A_(k+1) = "null", ... , A_n = "null"} times (s - π A_1,··· ,A_k ,B_1,··· ,B_m (r join s))
  $

  Le tuple che non contribuiscono al join naturale vengono unite con tuple nulle.
]

=== Prodotto cartesiano

#definition(
  )[
  Date $r$, $s$ con schemi di relazione $R(A_1,...,A_n)$ e $S(B_1,...,B_m)$ il risultato di $r times s$ è una relazione definita su $A_1,...,A_n,B_1,...,B_m$:
  $
    Z(A_1,...,A_n,B_1,...,B_m)
  $
  le cui tuple sono ottenute concatenando ogni tupla di $r$ con tutte le tuple di $s$ ottenendo l'insieme:
  $
    {t | t = u v space "con" space u in r and v in s}
  $
]

#observation(
  )[
  Il prodotto è un operatore primitivo, insieme a ridenominazione, unione, differenza, selezione e proiezione. Invece, per l'intersezione si ha $r inter s = r - (r - s)$. Inoltre un join naturale su relazioni senza attributi in comune, coincide con il loro prodotto.
]
#figure(image("images/image 22.png"))

=== $theta$ -join

Il prodotto cartesiano in pratica ha senso solo se eseguita da selezione:

$
  sigma_{"Condizione"}(R_1 times R_2)
$

L'operazione viene chiamata theta-join e indicata con:

$
  R_1 join_{"Condizione"} R_2
$

La condizione è spesso una congiunzione (AND) di atomi di confronto $A_1 theta A_2$ dove $theta$ è uno degli operatori di confronto($=, >, <, "ge", "le"$). Se l'operatore di confronto nel theta join è sempre l'uguaglianza (=) si parla di equi-join

#definition(
  )[
  Date $r$, $s$ con schemi $R(A_1, dots,A_n)$ e $S(B_1,dots,B_m)$, $A_i eq.not B_j$ il risultato di $r join_{A_i theta B_j}$ $s$ è una relazione definita su $A_1, dots ,A_n,B_1, dots ,B_m$:

  $
    Z(A_1, dots, A_n, B_1, dots, B_m)
  $

  che contiene il seguente insieme di tuple

  $
    {t | t = u v space "con" space u in r, v in s, u[A_i
    ] space theta space v[B_j]}
  $

  Si ha $r join_{A_i theta B_j} s = sigma A_i theta B_j (r times s)$
]

#figure(image("images/image 23.png"))
#figure(image("images/image 24.png"))
#figure(image("images/image 25.png"))
#figure(image("images/image 26.png"))

== Equivalenze

Due espressioni sono equivalenti se producono lo stesso risultato qualunque sia l'istanza attuale della base di dati. L'equivalenza è importante in pratica perché i DBMS cercano di eseguire espressioni equivalenti a quelle date, ma meno costose.

#figure(image("images/image 27.png"))


== Viste - relazioni derivate

- Relazioni di base: contenuto autonomo.
- Relazioni derivate: relazioni il cui contenuto è funzione del contenuto di altre relazioni (definito per mezzo di interrogazioni). Le relazioni derivate possono essere definite su altre derivate.
  - *Viste materializzate*: relazioni derivate memorizzate nella base di dati. Immediatamente disponibili per le interrogazioni ma ridondanti, appesantiscono gli aggiornamenti, sono raramente supportate dai DBMS.
  - *Relazioni virtuali (o viste)*: sono supportate dai DBMS (tutti) e una interrogazione su una vista viene eseguita ricalcolando la vista.

== Limiti dell'algebra

Ci sono interrogazioni interessanti non esprimibili con l'algebra:

- Calcolo di valori derivati: possiamo solo estrarre valori, non calcolarne di nuovi.
- Calcoli di interesse: a livello di ennupla o di singolo valore (conversioni, somme, differenze, etc.)
su insiemi di ennuple (somme, medie, etc.)
- Interrogazioni inerentemente ricorsive, come la chiusura transitiva.

#definition(
  )[
  Data $r$ di schema $R(X,Y )$, la chiusura transitiva $r^*$ di $r$ è la relazione che si ottiene aggiungendo, fino a quando è possibile, alle tuple in $r$ la coppia $(a, b)$ se esiste un valore $c$ tale che le coppie $(a, c)$ e $(c, b)$ sono in $r$ o sono state aggiunte precedentemente.
]

#example(
  "Chiusura transitiva",
)[
  Per ogni impiegato, trovare tutti i superiori (cioè il capo, il capo del capo e così via).

  #figure(
    image("images/image 28.png"),
    caption: "In questo esempio, basta il join della relazione con se stessa, previa opportuna ridenominazione",
  )


  In questo esempio, basta il join della relazione con se stessa, previa opportuna ridenominazione

  #figure(image("images/image 29.png"))


  Non esiste in algebra la possibilità di esprimere l'interrogazione che, per ogni relazione binaria, ne calcoli la chiusura transitiva. Per ciascuna relazione, è possibile calcolare la chiusura transitiva, ma con un'espressione ogni volta diversa. Quanti join servono? Non c'è limite!
]