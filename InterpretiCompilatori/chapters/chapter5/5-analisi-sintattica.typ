#import "../../../dvd.typ": *
#pagebreak()

= Analisi Sintattica


// Paragrafo 4.4
// Esempio 4.14
// Paragrafo 4.5 (solo evidenziato) + Figura 4.23 [accenno ad argomento futuro]
// Inciso sulla classificazione dei parser

//             Parser
//       top-down              bottom-up
// backtracking     no-backtracking
// discesa ricorsiva    discesa ricorsiva
//             tabellari
//             LL(k)
 
// Paragrafo 4.4.1 + FIgura(4.12)

La seguente tabella è necessaria per applicare l'algoritmo che seguirà: ci permette di rispondere al passo 2, ovvero scegliere una produzione adatta. La sua costruzione è complessa e verrà vista più avanti.
#figure(table(
  columns: 7,
  stroke: 1pt,
  align: center,
  table.cell(rowspan: 2)[*Non\ terminale*],
  table.cell(colspan: 6)[*Simbolo d'ingresso*],
  [id],
  [+],
  [\*],
  [(],
  [)],
  [\$],
  [$E$],
  [$E->T E'$],
  [$$],
  [$$],
  [$E->T E'$],
  [$$],
  [$$],
  [$E'$],
  [$$],
  [$E'->+T E'$],
  [$$],
  [$$],
  [$E'->epsilon$],
  [$E'->epsilon$],
  [$T$],
  [$T->F T'$],
  [$$],
  [$$],
  [$T->F T'$],
  [$$],
  [$$],
  [$T'$],
  [$$],
  [$T'->epsilon$],
  [$T'->*F T'$],
  [$$],
  [$T'->epsilon$],
  [$T'->epsilon$],
  [$F$],
  [$F->"id"$],
  [$$],
  [$$],
  [$F->(E)$],
  [$$],
  [$$],
))

#figure(image("images/2025-10-20-22-34-05.png"))

#example()[
  Esempio applicazione 1 TODO
]

#example()[
  Consideriamo la grammatica seguente:
  $
      &S -> c A d\
      &A-> a b bar a
  $
  E la stringa in ingresso $c a d$.
  #block($
      & S -> &&limits(a)_1 limits(A)_2 limits(d)_3\
      &      && k=1 => &&&& "match(); forward++;"\
      &      && k=2 => &&&& A->limits(a)_1 limits(b)_2\
      &      &&        &&&& k=1 => "match(); forward++;"\
      &      &&        &&&& k=2 => "backtracking per evitare errore; forward--;"\
      &      && k=2 => &&&& A->limits(a)_1\
      &      &&        &&&& k=1 => "match(); forward++;"\
      &      &&        &&&& ...
  $)
]

Vediamo un esempio più complesso e spieghiamolo passo passo.

$
  italic("stmt")    &--> &&bold("expr");\
                    & |  &&bold("if ( expr )") italic("stmt")\
                    & |  &&bold("for (") italic("optexpr") ";" italic("optexpr") ";" italic("optexpr")")"\
                    & |  &&bold("other") \
  \
  italic("optexpr") &--> && epsilon;\
                    & |  &&bold("expr")\
$
//TODO: magari spiegare meglio

Come stringa in ingresso consideriamo: `for(;expr;expr) other`
#figure(image("images/2025-10-20-22-37-15.png"))

//TODO: Suddividere in sezioni e alternare spiegazione a diagrammi
#figure(image("images/2025-10-20-22-37-37.png"))

Lo scopo è quello di costruire il resto dell'albero 
di parsing in modo che la stringa da questo generata coincida con la stringa d'ingresso. 
Affinché ci sia una corrispondenza, il non-terminale stmt nella Figura 2.18(a) deve 
poter generare una stringa che inizia con il simbolo di lookahead for. Nella gram- 
matica della Figura 2.16 c'è un'unica produzione per stmt che permette di derivare 
una tale stringa: quindi la selezioniamo e costruiamo i nuovi nodi, figli della radice, 
etichettandoli con i simboli nel corpo della produzione. Questa espansione dell'albero 
di parsing è mostrata nella Figura 2.18(b). 

Una volta costruiti i figli di un dato nodo, si passa al figlio pil a sinistra. Nella 
Figura 2.18(b) i figli sono stati appena aggiunti alla radice e si sta considerando il 
nodo etichettato con for. 

Nella Figura 2.18(c) la freccia nell'albero di parsing si spostata sul secondo figlio 
e la freccia nella stringa d'ingresso si spostata sul terminale successivo, cio® (. Il 
successivo passo porta la freccia nell'albero sul nodo etichettato con optexpr e quella 
nella stringa d'ingresso sul terminale ;. 

Considerando il nodo relativo al non-terminale opteapr, ripetiamo la ricerca e la 
selezione di una produzione per quel simbolo. Le produzioni aventi € come corpo 
(dette €-produzioni o produzioni nulle) richiedono un trattamento speciale. Per il 
momento le consideriamo come scelta di default quando nessun'altra produzione pud 
essere utilizzata; ritorneremo su questo aspetto nel Paragrafo 4.9.3. Con optexpr come 
nodo corrente e ; come simbolo di lookahead è@ necessario selezionare la ¢-produzione 
poiché il terminale ; non permette di utilizzare l'altra produzione per opteapr che ha 
il terminale expr come corpo. 

#observation(
  )[
  Il backtracking non è sempre necessario. Data una tabella di parsing costruita bene (una sola produzione in una cella) allora non ci sarà mai bisogno di backtracking. Grammatiche di questo tipo si dicono LL(1).
]

== Ricorsione sinistra
#definition(
  )[
  Una grammatica è detta *ricorsiva a sinistra* se ha un non-terminale $A$ per cui esiste una derivazione $A der(+) A alpha$ della stringa $alpha$.
]

#definition(
  )[
  Una grammatica è detta *ricorsiva immediata a sinistra* se esiste una produzione del tipo $A -> A alpha$ dove $A$ è un non terminale e $alpha$ è una sequenza (eventualmente vuota) di simboli terminali e/o non terminali.
]

I parser top-down non possono gestire grammatiche con ricorsione sinistra, per cui si rende necessario un metodo di trasformazione mirato a eliminare tale ricorsione. La coppia di produzioni $A -> A alpha bar beta$ con ricorsione sinistra può essere sostituita dalle produzioni non ricorsive a sinistra: 
$
    & A-> beta A'\ 
    & A'-> alpha A' bar epsilon
$ 
senza modificare l'insieme di stringhe derivabile da $A$. Questa singola regola è sufficiente per molte grammatiche. Vediamo ora il caso generale. La ricorsione sinistra immediata può essere eliminata mediante la seguente tecnica applicabile a un numero arbitrario di produzioni per $A$. Per prima cosa si raggruppano tutte le produzioni come
$
  A->A alpha_1 bar A alpha_2 bar ... bar A alpha_m bar beta_1 bar beta_2 bar ... bar beta_n
$
in cui nessuno dei $beta_i$ inizia con $A$. Quindi si sostituiscono le produzioni per $A$ con:
$
    & A -> beta_1 A' bar beta_2 A' bar ... bar beta_n A'\
    & A-> alpha_1 A' bar alpha_2 A' bar ... bar alpha_m A' bar epsilon
$
Il non-terminale $A$ genera le stesse stringhe di prima, ma non presenta pià ricorsione a sinistra. Questo metodo elimina la ricorsione sinistra da tutte le produzioni per $A$ e $A'$ (a patto che nessuno degli $alpha_i$ coincida con $epsilon$), ma non è in grado di eliminarla nel caso di derivazionei che richiedono due più passi.

#example()[
  TODO E->E+T ...
]

=== Algoritmo di eliminazione della ricorsione sinistra
*INPUT*: Una grammatica $G$ priva di cicli e produzioni-$epsilon$. \
*OUTPUT*: Una grammatica equivalente a $G$ ma priva di ricorsione sinistra. \
*METODO*:
//TODO: trovare modo di convertire algoritmo bene
#figure(image("images/2025-10-21-18-32-58.png"))
#example(
  )[
  Applichiamo l'algoritmo appena visto alla grammatica seguente:
  $
      & S -> A a bar b \
      & A -> A c bar S d bar epsilon
  $
  Tecnicamente, non è garantito che l'algoritmo funzioni a causa dela presenza di una produzione-$epsilon$. Tuttavia, in questo caso, essa è innocua. Per prima cosa fissiamo l'ordine dei non-terminali: $S,A$. Non vi è ricorsione sinistra immediata tra le produzioni per $S$, per cui nella prima iterazione, con $i=1$, del ciclo più esterno non succede nulla. Per $i=2$, sostituiamo $S$ nella produzione $A-> S d$, ottenendo le seguenti produzioni per $A$:
  $
    A -> A c bar A a d bar b d bar epsilon
  $
  Eliminando ora la ricorsione sinistra immediata da tali produzioni, si ottiene:
  $
      & S-> A a bar b\
      & A -> b d A' bar A' \
      & A' -> c A' bar a d A' bar epsilon
  $
  Questa nuova grammatica è priva di ricorsione sinistra.
]

== Fattorizzazione sinistra
#definition(
  )[
  La *fattorizzazione sinistra* è una trasformazione utile per ottenere una grammatica più adatta per il parsing top-down.
]
Quando la scelta tra due produzioni alternative per un non-terminale $A$ non è chiara, possiamo riscriverle in modo da differire tale scelta finché non avremo letto abbastanza simboli d'ingresso da poter prendere la decisione corretta. Consideriamo per sempio le due produzioni:
#align(center, [
  _stmt_ $->$ *if* _expr_ *then* _stmt_ *else* _stmt_\
  $bar$ *if* _expr_ *then* _stmt_
])
Leggendo il token *if* non siamo in grado di decidere immediatamente quale delle due produzioni utilizzare per espandere _stmt_. In generale, se $A -> alpha beta_1 bar alpha beta_2$ sonon due produzioni per $A$ e la sequenza d'ingresso inizia con una stringa non vuota derivata da $alpha$, non sappiamo se espandere $A$ come $alpha beta_1$ oppure come $alpha beta_2$. Tuttavia, possiamo rimandare la decisione espandendo $A$ in $alpha A'$. Quindi, dopo aver letto la stringa derivata $alpha$, possiamo espandere $A'$ in $beta_1$ o $beta_2$. Le produzioni originali, una volta fattorizzate a sinistra diventano:
$
    & A-> alpha A'\
    & A' -> beta_1 bar beta_2
$
=== Algoritmo di fattorizzazione sinistra

*INPUT*: Una grammatica $G$.\
*OUTPUT*: Una grammatica equivalente ma fattorizzata a sinistra.\
*METODO*: Per ogni non-terminale $A$ si trovi il prefisso $alpha$ più lungo e comune a duo o più alternative. Se $alpha eq.not epsilon$ si sostituiscano tutte le produzioni $A-> alpha beta_1 bar alpha beta_2 bar ... bar alpha beta_n bar gamma$, in cui $gamma$ rappresenta tutte le alternative che non iniziano con $alpha$, con
$
    & A -> alpha A' bar gamma\
    & A' -> beta_1 bar beta_2 bar ... bar beta_n
$
in cui $A'$ è un nuovo non-terminale. Si ripeta questo procedimento finché non esistono più produzioni alternative per uno stesso non-terminale aventi un prefisso comune.

#example()[
  Data la produzione:
  $
    A-> a b c d bar a b c e bar a b f
  $
  Possiamo applicare l'algoritmo e ottenere:
  #figure(grid(
    align: left,
    rows: 3,
    columns: 3,
    row-gutter: 8pt,
    [$A-> a b c A' bar a b f$],
    [],
    [$ A-> a b A''$],
    [$A'-> d bar c$],
    [$quad => quad$],
    [$A''-> c A' bar f$],
    [],
    [],
    [$A'-> d bar e$],
  ))


]