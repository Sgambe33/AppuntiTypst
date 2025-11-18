#import "../../../dvd.typ": *
#pagebreak()

= Analisi Sintattica
I *parser* vengono classificati come segue:
- Top-down
  - Con backtracking
    + A discesa ricorsiva
  - Senza backtracking
    + A discesa ricorsiva
    + Tabellari
    + LL(K)
- Bottom-up
  - ...

== Parsing top-down
Il parsing top-down può essere visto come il problema della costruzione di un albero di parsing corrispondente a una stringa d'ingresso partendo dalla radice dell'albero. A ogni passo del parsing top-down, il problema cruciale sta nel determinare la produzione corretta da applicare a un determinato non-terminale $A$. Una volta scelta una produzione per $A$, il resto del processo consiste nel verificare la corrispondenza tra i simboli terminali nle corpo della produzione e la stringa d'ingresso.

Una forma generale di parsing top-down, detta anche parsing a discesa ricorsiva, può richiedere _backtracking_ per trovare la produzione corretta da applicare per un non-terminale.

#observation(
  )[La seguente tabella è necessaria per applicare più facilmente (risponde immediatamente al passo 2) l'algoritmo che seguirà: ci permette di rispondere al passo 2, ovvero scegliere una produzione adatta. La sua costruzione è complessa e verrà vista più avanti.
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
  ))]

Il seguente algoritmo pemette di esaminare una stringa in ingresso applicando la discesa ricorsiva.
#figure(image("images/2025-10-20-22-34-05.png"))

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

Vediamo un esempio più complesso e spieghiamolo passo passo. Data questa grammatica:

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
Affinché ci sia una corrispondenza, il non-terminale _stmt_ nella Figura 2.18(a) deve poter generare una stringa che inizia con il simbolo di lookahead *for*. Nella grammatica precedentemente descritta, c'è un'unica produzione per _stmt_ che permette di derivare una tale stringa: quindi la selezioniamo e costruiamo i nuovi nodi, figli della radice, etichettandoli con i simboli nel corpo della produzione. Questa espansione dell'albero di parsing è mostrata nella Figura 2.18(b). 
Una volta costruiti i figli di un dato nodo, si passa al figlio più a sinistra. Nella Figura 2.18(b) i figli sono stati appena aggiunti alla radice e si sta considerando il nodo etichettato con *for*. 
Nella Figura 2.18(c) la freccia nell'albero di parsing si spostata sul secondo figlio e la freccia nella stringa d'ingresso si spostata sul terminale successivo, cioè *(*. Il successivo passo porta la freccia nell'albero sul nodo etichettato con _optexpr_ e quella nella stringa d'ingresso sul terminale *;*. 
Considerando il nodo relativo al non-terminale _optexpr_, ripetiamo la ricerca e la 
selezione di una produzione per quel simbolo. Le produzioni aventi $epsilon$ come corpo (dette $epsilon$-produzioni o produzioni nulle) richiedono un trattamento speciale. Per il momento le consideriamo come scelta di default quando nessun'altra produzione può essere utilizzata. Con _optexpr_ come nodo corrente e *;* come simbolo di lookahead è necessario selezionare la $epsilon$-produzione poiché il terminale *;* non permette di utilizzare l'altra produzione per _optexpr_ che ha 
il terminale _expr_ come corpo. 

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
Il non-terminale $A$ genera le stesse stringhe di prima, ma non presenta pià ricorsione a sinistra. Questo metodo elimina la ricorsione sinistra da tutte le produzioni per $A$ e $A'$ (a patto che nessuno degli $alpha_i$ coincida con $epsilon$), ma non è in grado di eliminarla nel caso di derivazionei che richiedono due o più passi.

#example()[
  Consideriamo questa grammatica:
  $
      &E-> E+T bar E-T bar T space "(due ricorsioni)"\
      &T-> T*F bar F space "(una ricorsione)"\
      &F->(E) bar "id"
  $
  Applicando il metodo appena visto si ottiene quest'altra grammatica equivalente:
  $
      &E->T E'\
      &E'->+T E' bar - T E' bar epsilon\
      &T-> F T'\
      &T'-> * F T' bar epsilon\
      &F->(E) bar "id"
  $
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

//TODO: mancano due esempi qui ma non si comprende la grafia, cercare altre fonti.

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

#example(
  )[
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

  Rivediamolo ma con una piccola variazione:
  $
    A-> A b c d bar A b c e bar a b f
  $
  Adesso la grammatica è affetta sia da ricorsione che da fattorizzazione. Per ottenerne una equivalente semplificata possiamo agire prima sulla fattorizzazione o sulla ricorsione. L'ordine con cui si agisce sui due problemi non ha importanza.

  #figure(grid(
    align: left,
    rows: 4,
    columns: 3,
    row-gutter: 8pt,
    [1) Fattorizzo:],
    [],
    [2) Rimuovo la ricorsione:],
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

== Funzioni FIRST e FOLLOW

La costruzione dei parser bottom-up e top-down utilizza due funzioni, *FIRST* e *FOLLOW*, associate a una grammatica G. In particolare, nel parsing top-down queste funzioni ci permettono di scegliere quale produzione applicare basandoci sul simbolo d'ingresso successivo. 

#[
  #set heading(numbering: none, outlined: false)
  === FIRST
]
#definition()[
  Data G grammatica e $alpha$ forma di frase, si definisce FIRST($alpha$) come:
  $
    "FIRST("alpha")"= {a in Sigma bar alpha der(*) a beta} union {epsilon}
  $
  Ovvero l'insieme dei terminali che costituiscono l'inizio delle stringhe derivabili da $a$.
]

Per calcolare *FIRST* si seguono queste indicazioni:
- Se $x$ è un terminale:
  $
    "FIRST("x")"= {x}
  $
- Se $X$ è una variabile. Se esiste in G una regola $X->Y_1 Y_2 ... Y_k$ con $k gt.eq 1$.
  + Se $Y_1 Y_2 ... Y_(i-1) der(*) epsilon$ e $Y_1 der(*) epsilon$, allora:
    $
      "FIRST("X")" #box(scale(x: -100%, [$subset.eq$])) union.big_(j=1)^k "FIRST("Y_j")" \\ {epsilon}
    $
  + Se $Y_1 Y_2 ... Y_k der(*) epsilon$, allora:
    $
      "FIRST("X")" #box(scale(x: -100%, [$subset.eq$])) union.big_(j=1)^k "FIRST("Y_j")"
    $
- Se $X-> epsilon$:
  $
    epsilon in "FIRST("X")"
  $

Allo stesso modo, se si vuole calcolare FIRST su un insieme di variabili:
+ Se $X_1 X_2 ... X_(i-1) der(*) epsilon$ e $X_i cancel(der(*)) epsilon$, allora:
  $
    "FIRST("X_1 X_2 ... X_n")" = union.big_(j=1)^k "FIRST("X_j")" \\ {epsilon}
  $
+ Se $X_1 X_2 ... X_n der(*) epsilon$, allora:
  $
    "FIRST("X_1 X_2 ... X_n")" = union.big_(j=1)^k "FIRST("X_j")"
  $

#example(
  )[
  $
      &A-> B C a\
      &B-> b bar epsilon\
      &C-> c bar epsilon
  $
  FIRST($A$) = FIRST($B$) $union$ FIRST($C$) $union$ FIRST($a$) = ${b} union {c} union {a} = {a b c}$
  #observation()[
    Attenzione, $epsilon$ non è presente perché $A$ non può dare origine ad una stringa vuota (c'è per forza "a").
  ]
]

#example(
  )[
  $
      &S->A x bar y B quad quad quad && "FIRST("S")"=overshell({y,x,z,a}, "Non c'è" epsilon \ "perché non"\ "generabile")\
      & B-> epsilon bar z B          && "FIRST("B")" = {epsilon, z}\
      & A-> epsilon bar B a S        && "FIRST("A")" = {epsilon, z, a}
  $
]

#[
  #set heading(numbering: none, outlined: false)
  === FOLLOW
]

#definition(
  )[
  Data G grammatica e $A in V$, si definisce FOLLOW($A$) come:
  $
    "FOLLOW("A")"= {a in Sigma bar S der(*) alpha A a beta}
  $
  Ovvero l'insieme dei simboli terminali che possono apparire immediatamente alla destra di $A$ in una qualche forma sentenziale.
  #observation(
    )[
    Se $A$ appare come simbolo più a destra
    di una qualche forma sentenziale, allora \$ appartiene all'insieme FOLLOW($A$). Ricordiamo che il simbolo \$ è uno speciale “marcatore di fine” e non appartenente ad alcuna grammatica.
  ]
]

Per calcolare FOLLOW($A$) per tutti i non-terminali $A$ si proceda applicando le regole seguenti finché non sia più possibile aggiungere nulla all'insieme FOLLOW. 
+ Si aggiunga \$ a FOLLOW($S$), ricordando che $S$ è il simbolo iniziale e \$ è il marcatore di fine della stringa d'ingresso. 
+ Se esiste una produzione del tipo $A -> a B beta$, allora si aggiunga a FOLLOW($B$) ogni elemento di FIRST($beta$) eccetto $epsilon$. 
+ Se esiste una produzione del tipo $A -> alpha B$ oppure del tipo $A -> alpha B beta$ per cui FIRST($beta$) contiene $epsilon$, allora tutti i simboli in FOLLOW($A$) appartengono anche a FOLLOW($B$). 

#example(
  )[
  $
      & S-> A C B bar C b b bar B a quad quad quad && "FOLLOW("S")"={\$}\
      & A-> d a bar B C                            && "FOLLOW("A")" #box(scale(x: -100%, [$subset.eq$])) "FIRST("C B")" \\ {epsilon}\
      & B-> g bar epsilon\
      & C-> h bar epsilon
  $
  //TODO: manca altro in sto esempio?
]

/// 23 Ottobre 2025: Definizione di grammatica LL(1) (paragrafo 4.4.3 e dispensa "Sulle grammatiche LL(1))". Costruzione della tabella di parsing predittivo (paragrafo 4.4.3 e dispensa "Tabelle di parsing predittivo"). Parsing predittivo non ricorsivo (paragrafo 4.4.4 e dispensa "Tabelle di parsing predittivo"). 

== Grammatiche LL(1)

E' sempre possibile costruire un parser predittivo - cioè un parser a discesa ricorsiva senza backtracking - a partire da una grammatica della classe LL(1). La prima “L” indica che la sequenza d'ingresso viene analizzata da sinistra (left, appunto) verso destra, la seconda “L” specifica che si costruisce una derivazione sinistra e infine l'“1” fra parentesi indica che le decisioni durante il parsing vengono prese analizzando un solo simbolo di lookahead cioè guardando il prossimo simbolo della stringa in ingresso. La classe LL(1) è sufficientemente ricca da coprire la maggior parte dei linguaggi di programmazione. 
- Una grammatica che presenta *ricorsione sinistra non è LL(1)*. 
- Una grammatica in cui *le produzioni per una variabile hanno
  prefissi comuni non è LL(1)*.

#definition(
  )[
  Una grammatica $G$ è LL(1) se e solo se soddisga le seguenti condizioni per ogni variabile $A$.
  Se $A -> alpha_1 bar alpha_2 bar ... bar alpha_k$ sono le produzioni per $A$, allora
  - FIRST($alpha_i$) $inter$ FIRST($alpha_j$) $= emptyset quad forall i eq.not j$
  - se $exists i$ tale che $alpha_i der(*) epsilon$ allora
    - $alpha_j cancel(der(*)) epsilon quad forall j eq.not i$ e
    - FOLLOW($A$) $inter$ FIRST($A$) $= emptyset$
  Per ogni variabile:
  - gli insiemi FIRST relativi alle parti destre delle produzioni sono due a due disgiunti
  - esiste al più una parte destra che può derivare $epsilon$ in questo caso l'insieme FOLLOW della variabile deve essere disgiunto dagli insiemi FIRST di tutte le parti destre, cioè dal FIRST della variabile.
]

=== Parsing a discesa ricorsiva per grammatiche LL(1)
Se le regole per la variabile $A$ sono $A-> alpha_1 bar alpha_2 bar ... bar alpha_k$ allora:
#grid(
  columns: 2,
  figure(image("images/2025-10-30-19-22-15.png", width: 63%)),
  figure(image("images/2025-10-30-19-22-26.png", width: 50%)),
)
//TODO: manca esempio da slide "Sulle LL(1).pptx"

== Tabelle di parsing predittivo
Le informazioni fornite dagli insiemi FIRST e FOLLOW possono essere raccolte in una tabella di parsing predittivo, $M$, in cui le righe corrispondono alle variabili e le colonne ai terminali e al marcatore di fine stringa \$. Il contenuto di $M[A, a]$ indica la regola da utilizzare per espandere la variabile $A$ quando il prossimo simbolo in ingresso è $a$.

La costruzione della tabella si basa sul fatto che la regola $A-> alpha$ viene scelta soltanto se il simbolo in ingresso $a in$ FIRST($alpha$), oppure $alpha der(*) epsilon$ e $a in$ FOLLOW($A$) (in questo caso può essere $a = \$$).

=== Costruzione di una tabella di parsing predittivo
Per ogni produzione $A-> alpha$ della grammatica $G$:
+ per ogni terminale $a in$ FIRST($alpha$) si aggiunge $A-> alpha$ a $M[A,a]$
+ se $epsilon in$ FIRST($alpha$), allora per ogni simbolo $b in$ FOLLOW($A$) (incluso eventualmente \$) si aggiunge $A-> alpha$ a $M[A,b]$

Se in $M[A, a]$ non c'è nessuna regola si ha una condizione di errore: il simbolo a non può essere ottenuto applicando nessuna delle regole per $A$.
Se $M[A, a]$ contiene più di una regola allora la grammatica non è LL(1) perché a appartiene agli insiemi FIRST di due regole distinte oppure $A der(*) epsilon$ e $a$ appartiene al FOLLOW($A$) e al FIRST di una regola per $A$.

#example()[
  #figure(image("images/2025-11-01-12-53-32.png"))
  #figure(image("images/2025-11-01-12-53-46.png"))
  //TODO: convertire immagini
]

== Parsing predittivo non ricorsivo
Un parser predittivo non ricorsivo può essere costruito gestendo uno stack esplicitamente, piuttosto che facendo affidamento sullo stack (implicito) dovuto alle chiamate ricorsive. Il parser riproduce il processo di derivazione sinistra. Se $w$ è la porzione dell'ingresso riconosciuta a un certo momento, allora lo stack contiene una sequenza di simboli grammaticali a tali che 
$
  S der(*) w alpha
$
Il parser è dotato di
- un buffer di ingresso (contiene la stringa in esame seguita da \$)
- uno stack contenente simboli in $V union Sigma union {\$}$
- una tabella di parsing
- uno stream di uscita

Inizialmente lo stack contiene il simbolo \$ (in fondo) e il simbolo distinto della grammatica. Ad ogni passo, il parser considera il simbolo $X$ in cima allo stack e il simbolo d'ingresso corrente $a$.
- Se $X$ è una variabile, il parser esamina l'elemento $M[X, a]$
  - se contiene una regola $X -> alpha$ allora, nello stack, $X$ viene sostituito da $alpha$ (il primo simbolo in testa), ed eventualmente costruiti i nodi corrispondenti nell'albero di parsing;
  - se è vuoto si ha una situazione di errore che può essere segnalata.
- Se $X$ è un terminale, viene confrontato col simbolo in ingresso a
  - se sono uguali $X$ viene rimosso dallo stack e si avanza al prossimo simbolo in ingresso
  - se sono diversi si ha una situazione di errore.

Se lo stack contiene \$ e il prossimo simbolo in ingresso è \$, cioè la stringa in esame è stata scandita completamente, la stringa viene accettata. Il comportamento del parser è descritto dalle sue configurazioni che sono costituite dal contenuto dello stack e dalla parte di input ancora da esaminare.

#figure(image("images/2025-11-01-15-44-17.png"))

Inizialmente $w\$$ nel buffer $S\$$ nello stack ($S$ in cima), _ip_ punta al primo simbolo $a$ di $w$.

Assegna a $X$ il simbolo in cima allo stack $PP(X="pop"(PP))$
#figure(image("images/2025-11-01-15-45-45.png"))
#figure(image("images/2025-11-01-15-45-52.png"))
#figure(image("images/2025-11-01-15-45-58.png"))
#figure(image("images/2025-11-01-15-46-02.png"))

/// 27 Ottobre 2025: Parsing bottom-up. Riduzioni, metodo di potatura nel parsing shift - reduce, il concetto di handle e sue proprietà (paragrafi 4.5, 4.5.1, 4.5.2, 4.5.3, 4.5.4  e dispensa "Analisi bottom-up").

== Parsing bottom-up
Il parsing bottom-up procede alla costruzione di un albero di parsing per una data stringa d'ingresso cominciando dalle foglie (bottom) e procedendo verso I'alto (up) fino alla radice. 

#example(multiple: true)[
  #figure(image("images/2025-11-01-15-55-43.png"))
  #figure(image("images/2025-11-01-15-55-49.png"))
]

=== Riduzioni

Gli analizzatori bottom-up partono da una stringa w e procedono a ritroso, effettuando una progressiva riduzione, fino ad ottenere il simbolo distinto S.

I parser bottom-up si basano sul meccanismo di riduzione che consiste nel sostituire la parte destra di una regola con la parte sinistra.

Per definizione, una riduzione é l'esatto opposto di un passo di derivazione (si ricordi che in una derivazione un non-terminale in una forma sentenziale viene sostituito dal corpo di una delle sue produzioni). Lo scopo del parsing bottom-up è quindi quello di costruire una derivazione al rovescio.

Per gli esempi precedenti, considerando le radici dei sottoalberi, si hanno le sequenze di stringhe:
id \* id, F \* id, T \* id, T \* F, T, E e
id + id, F + id, T + id, E + id, E + F, E + T, E
che corrispondono alle derivazioni destre
E ⇒ T ⇒ T \* F ⇒ T \* id ⇒ F \* id ⇒ id \* id e
E ⇒ E + T ⇒ E + F ⇒ E + id ⇒ T + id ⇒ F + id ⇒ id + id

Ad ogni passo dell'analisi, i parser bottom-up effettuano una riduzione oppure scandiscono un simbolo in ingresso. Per questo sono detti anche parser shift-reduce, impila-riduci, sposta-riduci.
Le decisioni fondamentali ad ogni passo sono se effettuare una riduzione e quale regola utilizzare.

=== Potatura?

Il parsing bottom-up della sequenza da sinistra a destra dei simboli di una stringa d'ingresso costruisce una derivazione destra al contrario.

#definition(
  )[
  Una *maniglia* o *handle* è una sottostringa corrispondente alla parte dx di una regola e la cui riduzione rappresenta un passo nella derivazione destra a ritroso.
]


//TODO: scegliere tra le immagini
#figure(image("images/2025-11-01-15-58-18.png"))
#figure(image("images/2025-11-01-16-12-02.png"))

Nel primo esempio nella stringa T \* id, T non viene ridotta
anche se è parte dx della regola E → T .
Nel secondo esempio, invece, nella stringa T + id, T viene
ridotta con la regola E → T .
Una sottostringa sinistra corrispondente alla parte dx di una
regola non è necessariamente un handle.

oppure

Per esempio, aggiungendo i pedici ai token per chiarezza, gli handle durante il 
parsing di id; \*idz secondo la grammatica 4.1 sono riportati nella Figura 4.24. Benché 
T sia il corpo della produzione E — T, il simbolo T non é\@ un handle per la forma 
sentenziale T' \*idg. Se infatti T fosse sostituito da E otterremmo la forma FE \* id, che 
non puo essere derivata dal simbolo iniziale E. Pertanto si conclude che la sottostringa 
sinistra corrispondente al corpo di una qualche produzione non deve necessariamente 
essere un handle.



Formalmente, se $S der(*) alpha A w => alpha beta w$ la produzione $A -> beta$ nella posizione che segue $alpha$ è un handle di $alpha beta w$.
#figure(
  image("images/2025-11-01-15-58-57.png", width: 30%),
  caption: [Un handle $A->beta$ nell'albero di parsing relativo alla stringa $alpha beta w$],
)

Alternativamente, un handle per una 
forma sentenziale destra y é costituito dalla produzione A — f e da una posizione 
in 7 in cui si trova la stringa £ tale che la sostituzione di tale occorrenza di 8 con A 
produce la forma sentenziale destra precedente in una derivazione destra di 7. 
Si noti che la stringa w a destra dell'handle deve contenere solo simboli terminali. 
Per semplicita parlando di handle ci riferiremo al corpo 7 di una produzione A — B 
piuttosto che alla produzione stessa. Se una grammatica è non ambigua, allora ogni orma 
sentenziale destra della grammatica ammette uno e un solo handle. 


Una derivazione destra a rovescio può essere ottenuta mediante un processo noto 
come _potatura_. Si comincia dalla stringa $w$ costituita dai simboli terminali da analizzare.
$
  S=gamma_0 => gamma_1 => gamma_2 => ... => gamma_(n-1) => gamma_n = w
$
Per ricostruire questa derivazione in ordine inverso, si individua l'handle $beta_n$ in $gamma_n$ e si sostituisce con la parte sinistra della regola $A_n -> beta_n$, in modo da ottenere la forma di frase destra precedente $gamma_(n-1)$.
Poi si individua l'handle $beta_(n-1)$ in $gamma_(n-1)$ e si sostituisce con la parte sinistra della regola $A_(n-1)->beta_(n-1)$, in modo da ottenere la forma di frase destra precedente $gamma_(n-1)$. Se, procedendo in questo modo, otteniamo una forma di frase destra costituita unicamente dal simbolo iniziale $S$ della grammatica significa che il parsing è stato completato con successo.

=== Parsing shift-reduce
Nel parsing _impila-riduci_ o _shift-reduce_ si usa uno stack che mantiene i simboli grammaticali, oltre al marcatore di fine stringa \$ e un buffer di ingresso che contiene la parte di input ancora da analizzare.
Un handle, subito prima di essere individuato come tale, si trova
sempre in cima allo stack.
Il simbolo \$ viene utilizzato come marcatore di fine stringa e per
indicare il fondo dello stack. Inizialmente lo stack contiene \$ e in
ingresso si ha $w\$$.


La stringa in ingresso viene scandita da sinistra a destra. Il parser inserisce nello stack (shift) zero o più simboli finché in cima non si trova un handle $beta$. A questo punto viene effettuata una riduzione (reduce) sostituendo $beta$ con la parte sinistra della regola opportuna. Il parser ripete questo procedimento finché non rileva un errore oppure lo stack contiene $\$S$ e in ingresso è rimasto solo \$.

Benché le operazioni principalei siano shift e reduce, vi sono in realtà quattro azione che uno parser shift-reduce può compiere:
+ Shift. Inserisce il prossimo simbolo in ingresso in cima allo stack.
+ Reduce. Il simbolo più a destra della stringa da ridurre si trova in cima allo stack. Si effettua una riduzione sostituendo la parte dx della regola con la parte sx.
+ Accept. Indica il corretto completamento dell'analisi.
+ Error. Si è verificata una situazione di errore.

Negli esempi lo stack viene rappresentato con l'elemento di testa
a destra (così contenuto dello stack e input da scandire, letti di
seguito, corrispondono alle fdf dx.

#figure(image("images/2025-11-01-16-00-47.png"))
#figure(image("images/2025-11-01-16-00-52.png"))
#figure(image("images/2025-11-01-16-00-57.png"))

//TODO: le problematiche le ha fatte? (4.5.4)

== Parser LR
Il tipo pi comune di parsing oggi adottato si basa su un concetto noto come parsing LR(k); la “L” significa che la stringa di input viene scorsa da sinistra a destra, la “R” indica che si costruisce una derivazione destra in ordine inverso e infine la k indica il numero di simboli di lookahead utilizzati per prendere le decisioni durante il parsing.

I parser LR, come i parser LL non-ricorsivi visti prima, si basano sull'utilizzo di tabelle. Una grammatica per la quale si può costruire una tabella di parsing (con i metodi che seguiranno) viene detta grammatica LR. Perché una grammatica sia LR è sufficiente che un parser shift-reduce sia in grado di riconoscere gli handle delle fdf dx quando compaiono in cima allo stack.

Il parsing LR è importante per le seguenti ragioni:
- È idoneo per riconoscere i costrutti dei linguaggi di programmazione descritti da grammatiche context-free
- È il metodo più generale di parsing shift-reduce senza backtracking
- Individua errori sintattici appena possibile
- La classe delle grammatiche riconosciute da un parser LR è un sovrainsieme proprio di quelle riconosciute dai parser LL.

Un parser LR prende le decisioni shift/reduce mantenendo memorizzate informa- 
zioni di stato che gli permettono di tenere traccia di dove si trova durante l'analisi. 
Gli stati rappresentano insiemi di “item”. Un item LR(0), 0 pit brevemente un item, 
di una grammatica G è una produzione di G con un punto in una qualche posizione 
del corpo. Un item indica quale prefisso di una regola abbiamo già analizzato
ad un certo punto durante il parsing.

#example(
  multiple: true,
)[
  Per esempio, la produzione $A -> X Y Z$ ammette quattro item:
  $
      &A-> dot X Y Z\
      &A-> X dot Y Z\
      &A-> X Y dot Z\
      &A-> X Y Z dot
  $
  - L'item $A-> dot X Y Z$ indica che ci aspettiamo in ingresso una stringa derivabile da $X Y Z$.
  - L'item $A-> X dot Y Z$ indica che abbiamo appena riconosciuto una stringa derivabile da X e ci aspettiamo in ingresso una stringa derivabile da $Y Z$.
  - L'item $A-> X Y Z dot$ indica che abbiamo appena riconosciuto una stringa derivabile da $X Y Z$ e che si potrebbe fare una riduzione con questa regola (sostituire $X Y Z$ con $A$).

  La produzione $A -> epsilon$, invece, genera il solo item $A -> dot$ .
]

#definition()[
  La collezione canonica LR(0) è una collezione di insiemi di item
  LR(0) che permette di costruire un automa a stati finiti
  deterministico (incompleto), detto automa LR(0), utilizzabile per
  prendere le decisioni durante il parsing.
  Ogni stato dell'automa LR(0) rappresenta un insieme di item della
  collezione canonica LR(0).
]

Per costruire la collezione canonica LR(0) per una grammatica $G$
(con simbolo iniziale $S$) consideriamo la grammatica aumentata $G'$,
ottenuta da $G$ aggiungendo un nuovo simbolo iniziale $S'$ e la regola
$S' → S$. Questa serve per l'accettazione che avviene solo quando il
parser può effettuare la riduzione con la regola $S' → S$. Introduciamo anche due nuove funzioni: CLOSURE e GOTO.

=== Chiusura degli insiemi di item
Se $I$ è un insieme di item di G, CLOSURE($I$) è un insieme di item costruito a partire da $I$ seguendo queste regole:
+ $I$nizialmente CLOSURE($I$) contiene tutti gli item di $I$
+ Se $A -> alpha dot B beta$ appartiene a CLOSURE($I$) e $B -> gamma$ è una produzione in $G$, allora si aggiunge $B -> dot gamma$ a CLOSURE($I$), se non è già presente. Si ripete questa regola finché non è più possibile aggiungere nuovi item a CLOSURE($I$).

Se $A -> alpha dot B beta$ appartiene a CLOSURE($I$), a un certo punto durante il parsing, ci si aspetta di riconoscere una stringa prodotta da $B beta$. Questa avrà un prefisso derivabile da $B$ applicando una delle regole per $B$. Si aggiungono quindi tutti gli item relativi alle regole per $B$, cioè se $B ->gamma$ è una regola in $G$, aggiungiamo $B -> dot gamma$ a CLOSURE($I$).

#example()[
  #figure(image("images/2025-11-01-17-10-16.png"))
]

Per calcolare la chiusura di un insieme di item si può definire una
funzione:

SetOfItems *CLOSURE*($I$) {\
#h(0.5cm)J = I\
#h(0.5cm)*repeat*\
#h(1.5cm)*for* ( ogni item A → α⋅Bβ in J )\
#h(1.5cm)*for* ( ogni regola B → γ in G )\
#h(2cm)*if* (B → ⋅γ non appartiene già a J )\
#h(2.5cm)aggiungi B → ⋅γ a J;\
#h(0.5cm)*until* nessun nuovo item è aggiunto a J;\
#h(0.5cm)*return* J;\
}\

=== Funzione GOTO

#definition(
  )[
  GOTO($I, X$), con $I$ insieme di item e $X$ simbolo della grammatica, è definita come chiusura dell'insieme di tutti gli item [$A -> alpha X dot beta$] tali che [$A -> alpha dot X beta$] appartiene ad $I$.
  $
    "GOTO("I, X")" = "CLOSURE("{[A -> alpha X dot beta] | [A → alpha dot X beta] in I }")"
  $
]

Viene usata per definire le transizioni dell'automa LR(0). Gli stati dell'automa corrispondono a insiemi di item e GOTO($I$, X)definisce la transizione dallo stato $I$ col simbolo $X$.

#example()[
  Se $I = {[E' -> E dot], [E -> E dot + T ]}$ allora:
  $
    "GOTO"(I, +) = "CLOSURE"({[E → E + dot T ]}) =\
    = {[E → E + dot T ], [T → dot T \* F], [T → dot F], [F → dot (E)], [F → dot id] }
  $
]

Per calcolare la collezione canonica degli insiemi di item LR(0) si può definire una funzione:

void *items*($G'$) {\
#h(0.5cm)C = CLOSURE(${[S' → dot S ]}$);\
#h(0.5cm)*repeat*\
#h(1cm)*for* ( ogni insieme di item $I$ in $C$ )\
#h(1.5cm)*for* ( ogni simbolo $X$ in $G$ )\
#h(2cm)*if* (GOTO($I, X$) non è vuoto e non appartiene a $C$ )\
#h(2.5cm)aggiungi GOTO($I, X$) a $C$;\
#h(0.5cm)*until* nessun nuovo insieme di item è aggiunto a $C$;\
}\

//TODO: manca immagine 4.29? vedi esempio 4.28

=== Automa LR(0)
Il parsing LR semplice o SLR si basa sulla costruzione dell'automa LR(0) a partire da una grammatica.
- gli stati dell'automa sono gli insiemi di item della collezione canonica, indichiamo con stato j lo stato corrispondente all'insieme di item Ij,
- lo stato iniziale è CLOSURE(${[S' → dot S ]}$) dove $S'$ è il simbolo iniziale della grammatica aumentata,
- tutti gli stati sono finali,
- la funzione di transizione è data dalla funzione GOTO.

L'automa LR(0) fornisce un supporto per le decisioni durante il parsing. Per l'analisi si utilizza uno schema in cui si trova una colonna che simula una pila contenente gli stati che si incontrano durante l'analisi, una colonna per che simula una pila contenente i simboli grammaticali, una colonna che visualizza l'input via via che viene analizzato e una colonna dove si indicano le azioni da fare (Shift o Reduce).
Supponiamo che con la stringa $gamma$, nell'automa si passi dallo stato iniziale 0 ad uno stato j:
- se dallo stato j c'è una transizione etichettata con il prossimo simbolo in ingresso a, allora si sceglie di impilare a, altrimenti
- si effettua una riduzione utilizzando la produzione indicata dagli item nello stato j.
L'algoritmo di parsing utilizza lo stack per tenere traccia degli stati
e dei simboli grammaticali. 

Se scegliamo di impilare il simbolo di ingresso, si impila anche lo stato verso cui avviene lo shift.
Quando si applica una riduzione A - > X1 X2 … Xn (e questo può avvenire se lo stato in cui siamo contiene l'item A - > X1 X2 … Xn . , allora dalla pila degli dobbiamo togliere n stati e dallo stato j che rimane in cima alla pila guardare l'automa LR(0) per vedere qual è lo stato in cui j va con simbolo A. Ciò è coerente con il significato di item. 

#figure(image("images/2025-11-01-17-33-24.png"))
#figure(image("images/2025-11-01-17-33-38.png"))

Nell'esempio precedente relativo alla stringa di ingresso id*id, nella riga 4 della tabella è stata fatta la scelta Shift 7, in accordo con quanto si trova scritto nello stato 2 con prossimo simbolo d'ingresso \*. Notare che se ci troviamo nello stato 2, per la presenza dell'item E -> T. , c'è la possibilità di applicare la riduzione con la produzione E -> T. Nell'esempio è stata fatta la scelta corretta per far terminare l'analisi con l'accettazione della stringa. Se venisse fatta l'altra scelta (la riduzione), si arriverebbe ad una situazione di errore. A questo livello ancora non sappiamo scegliere fra le due possibilità