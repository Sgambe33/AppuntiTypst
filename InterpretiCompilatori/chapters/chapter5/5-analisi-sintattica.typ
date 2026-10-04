#import "../../../dvd.typ": *
#import "@preview/algo:0.3.6": algo, code, comment, d, i
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#pagebreak()

= Analisi sintattica

== Parser e classificazione
Secondo il nostro modello di compilatore, il *parser* riceve una sequenza di token dall'analizzatore lessicale (_lexer_) e verifica se tale sequenza può essere generata dalla grammatica del linguaggio sorgente.
#figure(image("images/introParser.png", width: 80%))
Ci aspettiamo che il parser sia in grado di segnalare in una forma chiara e intelligibile gli eventuali errori e, dopo aver rilevato quelli più comuni, sia in grado di riprendere l'analisi della parte restante del programma (tramite tecniche di *error recovery*).

Concettualmente, per i programmi ben formati (cioè sintatticamente corretti), il parser costruisce un albero di parsing e lo passa alla parte restante del compilatore per una successiva elaborazione. Di fatto, *non è necessario costruire* esplicitamente l'*intero albero in memoria*: molto spesso le fasi successive (analisi semantica e generazione del codice intermedio) vengono eseguite "al volo" durante l'analisi sintattica stessa, eseguendo le azioni semantiche man mano che il parser riconosce i vari costrutti (nella cosiddetta *traduzione guidata dalla sintassi*).

I parser vengono classificati come segue:

- Top-down (dall'alto verso il basso)
  - Con backtracking
    - A discesa ricorsiva
  - Senza backtracking
    + A discesa ricorsiva predittiva
    + Tabellari
    + LL($k$)

- Bottom-up (dal basso verso l'alto)
  - Shift-Reduce (tecnica generale basata su stack e input)
  - LR (Left-to-right, Rightmost derivation in reverse)
    + LR(0) (Senza lookahead, automa a stati finiti base)
    + SLR(1) (Simple LR, usa gli insiemi FOLLOW per risolvere i conflitti)
    + LR(1) (Canonical LR, il più potente ma genera tabelle enormi)

I metodi top-down e bottom-up più efficienti si applicano solamente a opportune sottoclassi di grammatiche, molte delle quali tuttavia (come le grammatiche LL e LR) sono sufficientemente espressive da descrivere la maggior parte dei costrutti sintattici tipici dei moderni linguaggi di programmazione.

== Trasformazione delle grammatiche
Affinché i parser top-down possano gestire correttamente le grammatiche, esse devono soddisfare determinate proprietà. Se non le soddisfano, è possibile applicare degli algoritmi per trasformarle.

=== Ricorsione sinistra
#definition()[
  Una grammatica è detta *ricorsiva a sinistra* se ha un non-terminale $A$ per cui esiste una derivazione $A der(+) A alpha$ della stringa $alpha$.
]
Si parla di ricorsione perché il non-terminale $A$ appare nuovamente nella derivazione di se stesso, in particolare come simbolo più a sinistra del lato destro. Nella definizione sopra la derivazione è in più passi, ma può essere anche immediata:
#definition()[
  Una grammatica è detta *ricorsiva immediata a sinistra* se esiste una produzione del tipo $A -> A alpha$ dove $A$ è un non terminale e $alpha$ è una sequenza (eventualmente vuota) di simboli terminali e/o non terminali.
]

I parser top-down non possono gestire grammatiche con ricorsione sinistra, per cui si rende necessario un metodo di trasformazione mirato a eliminare tale ricorsione.

La coppia di produzioni $A -> A alpha bar beta$ con ricorsione sinistra può essere eliminata mediante riscrittura sostituendola con le seguenti produzioni non ricorsive a sinistra:
$
  & A-> beta A' \
  & A'-> alpha A' bar epsilon
$
in questo modo non viene modificato l'insieme di stringhe derivabile da $A$. Questa singola regola è sufficiente per molte grammatiche, ma vediamo ora il caso generale.

La ricorsione sinistra immediata può essere eliminata mediante la seguente tecnica, applicabile a un numero arbitrario di produzioni per $A$. Per prima cosa si raggruppano tutte le produzioni come:
$
  A->A alpha_1 bar A alpha_2 bar ... bar A alpha_m bar beta_1 bar beta_2 bar ... bar beta_n
$
in cui nessuno dei $beta_i$ inizia con $A$. Quindi si sostituiscono le produzioni per $A$ con:
$
  & A -> beta_1 A' bar beta_2 A' bar ... bar beta_n A' \
  & A' -> alpha_1 A' bar alpha_2 A' bar ... bar alpha_m A' bar epsilon
$
Il non-terminale $A$ genera le stesse stringhe di prima, ma non presenta più ricorsione a sinistra.
#example()[
  Consideriamo questa grammatica:
  $
    & E-> E+T bar E-T bar T space && "(due produzioni ricorsive a sx)" \
    & T-> T*F bar F space         && "(una produzione ricorsiva a sx)" \
    & F->(E) bar "id"
  $
  Applicando il metodo appena visto si ottiene quest'altra grammatica equivalente, pronta per un parser top-down:
  $
    & E->T E' \
    & E'->+T E' bar - T E' bar epsilon \
    & T-> F T' \
    & T'-> * F T' bar epsilon \
    & F->(E) bar "id"
  $
]

Questo metodo elimina la ricorsione sinistra da tutte le produzioni per $A$ e $A'$ (a patto che nessuno degli $alpha_i$ coincida con $epsilon$), ma non è in grado di eliminarla nel caso di derivazioni che richiedono due o più passi (quando la ricorsione sinistra non è immediata). Vediamo un algoritmo che elimina sistematicamente la ricorsione sinistra, anche quando non è immediata.
#[
  #set heading(numbering: none, outlined: false)
  === Algoritmo di eliminazione della ricorsione sinistra
]
*INPUT*: Una grammatica $G$ priva di cicli e produzioni-$epsilon$. \
*OUTPUT*: Una grammatica equivalente a $G$ ma priva di ricorsione sinistra. \
*METODO*:
#figure(
  algo(
    title: "Eliminazione ricorsione sinistra",
  )[
    ordina arbitrariamente i non-terminali come $A_1, A_2, dots, A_n$.\
    for ( ogni $i$ da 1 fino a $n$ ) {#i\
    for ( ogni $j$ da 1 fino a $i - 1$ ) {#i\
    sostituisci ogni produzione nella forma $A_i --> A_j gamma$ \
    con le produzioni $A_i --> delta_1 gamma | delta_2 gamma | dots | delta_k gamma$, \
    in cui $A_j --> delta_1 | delta_2 | dots | delta_k$ sono tutte le\
    produzioni per il non-terminale $A_j$ in esame.#d\
    }\
    elimina la ricorsione sinistra immediata dalle produzioni per $A_i$#d usando il metodo noto\
    }
  ],
)

#example()[
  Applichiamo l'algoritmo appena visto alla grammatica seguente:
  $
    & S -> A a bar b \
    & A -> A c bar S d bar epsilon
  $
  Tecnicamente, non è garantito che l'algoritmo funzioni a causa della presenza di una produzione-$epsilon$ ($A -> epsilon$). Tuttavia, in questo caso, essa è innocua. Per prima cosa fissiamo l'ordine dei non-terminali: $S,A$. Non vi è ricorsione sinistra immediata tra le produzioni per $S$, per cui nella prima iterazione, con $i=1$, del ciclo più esterno non succede nulla. Per $i=2$, sostituiamo $S$ nella produzione $A-> S d$, ottenendo le seguenti produzioni per $A$:
  $
    A -> A c bar A a d bar b d bar epsilon
  $
  Eliminando ora la ricorsione sinistra immediata da tali produzioni, si ottiene:
  $
    & S-> A a bar b \
    & A -> b d A' bar A' \
    & A' -> c A' bar a d A' bar epsilon
  $
  Questa nuova grammatica è priva di ricorsione sinistra.
]

=== Fattorizzazione sinistra
#definition()[
  La *fattorizzazione sinistra* è una trasformazione utile per ottenere una grammatica più adatta per il parsing _predittivo_ (top-down).
]
Quando la scelta tra due produzioni alternative per un non-terminale $A$ non è chiara, possiamo riscriverle in modo da differire tale scelta finché non avremo letto abbastanza simboli d'ingresso da poter prendere la decisione corretta. Consideriamo per esempio le due produzioni:
//TODO: fix bar sotto ->
// $
//   italic("stmt") & -->     && bold("expr"); \
//                  & space | && bold("if expr ") italic("stmt") \
// $
#align(center, [
  _stmt_ $->$ *if* _expr_ *then* _stmt_ *else* _stmt_\
  $bar$ *if* _expr_ *then* _stmt_
])
Leggendo il token *if* non siamo in grado di decidere immediatamente quale delle due produzioni utilizzare per espandere _stmt_. In generale, se $A -> alpha beta_1 bar alpha beta_2$ sono due produzioni per $A$ e la sequenza d'ingresso inizia con una stringa non vuota derivata da $alpha$, non sappiamo se espandere $A$ come $alpha beta_1$ oppure come $alpha beta_2$. Tuttavia, possiamo rimandare la decisione espandendo $A$ in $alpha A'$. Quindi, dopo aver letto la stringa derivata da $alpha$, possiamo espandere $A'$ in $beta_1$ o $beta_2$. Le produzioni originali, una volta fattorizzate a sinistra diventano:
$
  & A-> alpha A' \
  & A' -> beta_1 bar beta_2
$

#[
  #set heading(numbering: none, outlined: false)
  === Algoritmo di fattorizzazione sinistra
]
*INPUT*: Una grammatica $G$.\
*OUTPUT*: Una grammatica equivalente ma fattorizzata a sinistra.\
*METODO*: Per ogni non-terminale $A$ si trovi il prefisso $alpha$ più lungo e comune a due o più alternative. Se $alpha eq.not epsilon$ si sostituiscano tutte le produzioni $A-> alpha beta_1 bar alpha beta_2 bar ... bar alpha beta_n bar gamma$, in cui $gamma$ rappresenta tutte le alternative che non iniziano con $alpha$, con
$
  & A -> alpha A' bar gamma \
  & A' -> beta_1 bar beta_2 bar ... bar beta_n
$
in cui $A'$ è un nuovo non-terminale. Si ripeta questo procedimento finché non esistono più produzioni alternative per uno stesso non-terminale aventi un prefisso comune.

#example()[
  Data la produzione:
  $
    A -> a b c d | a b c e | a b f
  $
  Possiamo applicare l'algoritmo di fattorizzazione sinistra per estrarre i prefissi comuni e ottenere:
  #figure(grid(
    align: left,
    rows: 3,
    columns: 3,
    row-gutter: 8pt,
    [$A -> a b c A' | a b f$], [$quad => quad$], [$A -> a b A''$],
    [$A' -> d | e$], [], [$A'' -> c A' | f$],
    [], [], [$A' -> d | e$],
  ))

  Rivediamolo con una piccola variazione (introduzione della ricorsione):
  $
    A -> A b c d | A b c e | a b f
  $
  Adesso la grammatica è affetta sia da ricorsione che da necessità di fattorizzazione. Per ottenerne una equivalente e semplificata possiamo agire prima sulla fattorizzazione o sulla ricorsione. L'ordine con cui si agisce sui due problemi non altera il linguaggio riconosciuto, ma produce grammatiche strutturalmente diverse.

  Se decidiamo di applicare prima la fattorizzazione e poi rimuovere la ricorsione:
  #figure(grid(
    align: left,
    rows: 4,
    columns: 3,
    row-gutter: 8pt,
    [*1) Fattorizzo il prefisso* $A b c$*:*], [], [*2) Rimuovo la ricorsione da* $A$*:*],
    [$A -> A b c A' | a b f$], [$quad => quad$], [$A -> a b f A''$],
    [$A' -> d | e$], [], [$A'' -> b c A' A'' | epsilon$],
    [], [], [$A' -> d | e$],
  ))
]

== Parsing Top-Down
Il parsing top-down può essere visto come il problema della costruzione di un albero di parsing corrispondente a una stringa d'ingresso, partendo dalla radice dell'albero e creando nodi in preordine. In modo equivalente, può essere visto come il problema di trovare una derivazione sinistra per una stringa d'ingresso.
La seguente grammatica genera un sottoinsieme degli statement di C e di Java.
$
     italic("stmt") & --> && bold("expr"); \
                    & |   && bold("if ( expr )") italic("stmt") \
                    & |   && bold("for (") italic("optexpr") ";" italic("optexpr") ";" italic("optexpr")")" \
                    & |   && bold("other") \
                    \
  italic("optexpr") & --> && epsilon; \
                    & |   && bold("expr") \
$
#figure(
  diagram(
    cell-size: 5mm,
    spacing: 3mm,

    // NODES //
    node((4, 0), $s t m t$, name: <top>),

    node((0, 1), [*for*], name: <for>),
    node((1, 1), $($, name: <parO>),
    node((2, 1), $o p t e x p r$, name: <opt1>),
    node((3, 1), $;$, name: <semC1>),
    node((4, 1), $o p t e x p r$, name: <opt2>),
    node((5, 1), $;$, name: <semC2>),
    node((6, 1), $o p t e x p r$, name: <opt3>),
    node((7, 1), $)$, name: <parC>),
    node((8, 1), $s t m t$, name: <stmt>),

    node((2, 2), $epsilon$, name: <eps>),
    node((4, 2), [*expr*], name: <expr1>),
    node((6, 2), [*expr*], name: <expr2>),
    node((8, 2), [*other*], name: <other>),

    // EDGES //
    edge(<top>, <for>, bend: -7.5deg),
    edge(<top>, <parO>, bend: -5deg),
    edge(<top>, <opt1>, bend: -2.5deg),
    edge(<top>, <semC1>),
    edge(<top>, <opt2>),
    edge(<top>, <semC2>),
    edge(<top>, <opt3>, bend: 2.5deg),
    edge(<top>, <parC>, bend: 5deg),
    edge(<top>, <stmt>, bend: 7.5deg),

    edge(<opt1>, <eps>),
    edge(<opt2>, <expr1>),
    edge(<opt3>, <expr2>),
    edge(<stmt>, <other>),
  ),
  caption: "Un esempio di albero di parsing",
)
La costruzione di un albero di parsing come quello sopra, avviene partendo dalla radice, etichettata dal non-terminale iniziale _stmt_ e ripetendo iterativamente i due passi:
+ Al nodo $N$, etichettato dal non-terminale $A$, si sceglie una delle produzioni per $A$ e si costruiscono i figli di $N$ in base ai simboli presenti nel corpo della produzione.

+ Si cerca il prossimo nodo per cui è necessario costruire un sottoalbero, in genere il non-terminale non ancora elaborato più a sinistra nell'albero.

Il terminale in esame durante la scansione viene detto *simbolo di lookahead*: questo inizialmente è il primo terminale, cioè il più a sinistra nella stringa di ingresso. Vediamo la costruzione dell'albero di parsing relativo alla stringa di ingresso `for(;expr;expr) other`.

Inizialmente il terminale *for* è il simbolo di lookahead; la radice etichettata dell'albero è il non-terminale iniziale _stmt_.

#figure(diagram(
  cell-size: 5mm,
  spacing: 3mm,

  // NODES //
  node((1, 0), $bold(#text(8pt)[Albero]) \ bold(#text(8pt)[di parsing])$),
  node((6.5, 0), $s t m t$, name: <top>),

  node((0.25, 1), $(a)$),

  node((1, 2), $bold(#text(8pt)[Input])$),
  node((3, 2), [*for*], name: <for>),
  node((4, 2), [*(*], name: <parO>),
  node((5, 2), [*;*], name: <semC1>),
  node((6, 2), [*expr*], name: <opt2>),
  node((7, 2), [*;*], name: <semC2>),
  node((8, 2), [*expr*], name: <opt3>),
  node((9, 2), [*)*], name: <parC>),

  // EDGES //
  edge((.5, 1), (10.75, 1)),
  edge((6.5, 0.6), <top>, "-|>", mark-scale: .75),
  edge((3, 2.7), <for>, "-|>", mark-scale: .75),

  // BORDI //
  edge((0, -1), (11, -1), "="),
  edge((0, 3), (11, 3), "="),
))

Lo scopo è quello di costruire il resto dell'albero in modo che la stringa da questo generata coincida con la stringa d'ingresso. Affinché ci sia una corrispondenza, _stmt_ deve poter generare una stringa che inizia col simbolo di lookahead *for*. Nella grammatica precedentemente illustrata, c'è solo una produzione per _stmt_ che deriva tale stringa; la selezioniamo e costruiamo i nuovi nodi, figli della radice,
etichettandoli con i simboli nel corpo della produzione.

#figure(diagram(
  cell-size: 5mm,
  spacing: 3mm,

  // NODES //
  node((1, 0), $bold(#text(8pt)[Albero]) \ bold(#text(8pt)[di parsing])$),
  node((6, 0), $s t m t$, name: <top>),

  node((0.25, 2), $(b)$),

  node((1, 3), $bold(#text(8pt)[Input])$),
  node((3, 3), [*for*], name: <startG>),
  node((4, 3), [*(*]),
  node((5, 3), [*;*]),
  node((6, 3), [*expr*]),
  node((7, 3), [*;*]),
  node((8, 3), [*expr*]),
  node((9, 3), [*)*]),

  node((2, 1), [*for*], name: <for>),
  node((3, 1), $($, name: <parO>),
  node((4, 1), $o p t e x p r$, name: <opt1>),
  node((5, 1), $;$, name: <semC1>),
  node((6, 1), $o p t e x p r$, name: <opt2>),
  node((7, 1), $;$, name: <semC2>),
  node((8, 1), $o p t e x p r$, name: <opt3>),
  node((9, 1), $)$, name: <parC>),
  node((10, 1), $s t m t$, name: <stmt>),

  // EDGES //
  edge(<top>, <for>, bend: -7.5deg),
  edge(<top>, <parO>, bend: -5deg),
  edge(<top>, <opt1>, bend: -2.5deg),
  edge(<top>, <semC1>),
  edge(<top>, <opt2>),
  edge(<top>, <semC2>),
  edge(<top>, <opt3>, bend: 2.5deg),
  edge(<top>, <parC>, bend: 5deg),
  edge(<top>, <stmt>, bend: 7.5deg),

  edge((.5, 2), (11.75, 2)),
  edge((2, 1.7), <for>, "-|>", mark-scale: .75),
  edge((3, 3.7), <startG>, "-|>", mark-scale: .75),

  // BORDI //
  edge((0, -1), (12, -1), "="),
  edge((0, 4), (12, 4), "="),
))

Quando il nodo che si sta considerando nell'albero di parsing corrisponde a un terminale e tale terminale corrisponde al simbolo di lookahead corrente, allora si passa al figlio successivo nell'albero e al terminale successivo nella stringa d'ingresso.

#figure(
  diagram(
    cell-size: 5mm,
    spacing: 3mm,

    // NODES //
    node((1, 0), $bold(#text(8pt)[Albero]) \ bold(#text(8pt)[di parsing])$),
    node((6, 0), $s t m t$, name: <top>),

    node((0.25, 2), $(c)$),

    node((1, 3), $bold(#text(8pt)[Input])$),
    node((3, 3), [*for*]),
    node((4, 3), [*(*], name: <startG>),
    node((5, 3), [*;*]),
    node((6, 3), [*expr*]),
    node((7, 3), [*;*]),
    node((8, 3), [*expr*]),
    node((9, 3), [*)*]),

    node((2, 1), [*for*], name: <for>),
    node((3, 1), $($, name: <parO>),
    node((4, 1), $o p t e x p r$, name: <opt1>),
    node((5, 1), $;$, name: <semC1>),
    node((6, 1), $o p t e x p r$, name: <opt2>),
    node((7, 1), $;$, name: <semC2>),
    node((8, 1), $o p t e x p r$, name: <opt3>),
    node((9, 1), $)$, name: <parC>),
    node((10, 1), $s t m t$, name: <stmt>),

    // EDGES //
    edge(<top>, <for>, bend: -7.5deg),
    edge(<top>, <parO>, bend: -5deg),
    edge(<top>, <opt1>, bend: -2.5deg),
    edge(<top>, <semC1>),
    edge(<top>, <opt2>),
    edge(<top>, <semC2>),
    edge(<top>, <opt3>, bend: 2.5deg),
    edge(<top>, <parC>, bend: 5deg),
    edge(<top>, <stmt>, bend: 7.5deg),

    edge((.5, 2), (11.75, 2)),
    edge((3, 1.7), <parO>, "-|>", mark-scale: .75),
    edge((4, 3.7), <startG>, "-|>", mark-scale: .75),

    // BORDI //
    edge((0, -1), (12, -1), "="),
    edge((0, 4), (12, 4), "="),
  ),
)

Nel passo $(c)$ la freccia nell'albero di parsing si è spostata sul secondo figlio e la freccia nella stringa di ingresso 
si è spostata sul terminale successivo, cioè *(*. Il successivo passo porta la freccia nell'albero sul nodo $o p t e x p r$ e 
quella nell'input sul terminale *;*. Considerando il nodo relativo al non-terminale $o p t e x p r$ si ripete la ricerca e la selezione di una produzione per quel simbolo. In questo caso scegliamo la $epsilon$-produzione perchè il terminale *;* non consente di scegliere l'altra produzione che ha *expr* come corpo; tuttavia, le produzioni nulle meriterebbero un trattamento speciale che per ora ignoriamo, le trattiamo semplicemente come scelta di default quando tutte le altre produzioni non possono essere scelte.

In generale, la scelta di una produzione per un dato non-terminale richiede più tentativi. In altre parole, è necessario 
scegliere una certa produzione ed eventualmente ritornare indietro rileggendo più di una volta parte della stringa di ingresso (*backtracking*) qualora tale produzione si rivelasse non adatta. Una produzione si rivela non adatta qualora la sua scelta rendesse impossibile completare l'albero di parsing per la stringa d'ingresso. Il problema cruciale ad ogni passo del parsing top-down è determinare quale produzione applicare per un certo non-terminale $A$.

In particolare la tipologia di parsing top-down che può richiedere backtracking si dice *a discesa ricorsiva*. Esiste anche un caso particolare di parsing a discesa ricorsiva che non richiede backtracking, detto *parsing predittivo*.

=== Parsing a discesa ricorsiva
Un programma per il parsing a discesa ricorsiva consiste in un insieme di procedure, una per ogni non-terminale. L'esecuzione inizia dalla procedura relativa al simbolo iniziale, che termina con successo se il suo corpo scandisce correttamente tutta la stringa d'ingresso. Come detto poc'anzi, questa tipologia di parsing può richiedere backtracking, anche se è raro che sia necessario con i costrutti dei tipici linguaggi di programmazione.

Una procedura per un tipico non-terminale è la seguente:
#figure(
  block(
    width: auto,
    algo()[
      void A() {#i\
      Scegli, per $A$, una produzione $A --> X_1X_2 dots X_k;$\
      for ($i$ da 1 fino a $k$)#i\
      if ($X_i$ è un non-terminale)#i\
      richiama la procedura $X_i ()$;#d\
      else if ($X_i$ è uguale al simbolo d'ingresso corrente $a$)#i\
      procedi al simbolo successivo nella sequenza d'ingresso;#d\
      else \/\* si è verificato un errore \*\/;#d\
      }#d\
      }
    ]
  ),
  caption: "Procedura tipica per un non-terminale in un parser top-down",
)
Si noti che questo pseudocodice è non-deterministico poiché inizia con la scelta di una produzione per A senza indicare come effettuare tale scelta: in realta alla riga 2 si vuole dire che è necessario provare una produzione, eventualmente "fallire" alla riga 8 e quindi riprovare con una nuova produzione. Quando non vi sono più produzioni da provare allora si segnala la presenza di un errore nella stringa di ingresso.
#example("Parsing a discesa ricorsiva con backtracking")[
  Consideriamo la grammatica seguente e la stringa in ingresso $c a d$:
  $
    S & -> c A d \
    A & -> a b | a
  $

  Traccia dell'esecuzione, con forward puntatore che indica il simbolo d'ingresso corrente e $k$ che indica la posizione del simbolo del corpo della produzione (parte destra) attualmente in corso di esame:
  #block(
    $
      & S -> && limits(c)_1 limits(A)_2 limits(d)_3 \
      & && k=1 => &&&& text("match(c); forward++;") && quad text("(input rimanente: ad)") \
      & && k=2 => &&&& A -> limits(a)_1 limits(b)_2 && quad text("(prova prima produzione)") \
      & && &&&& k=1 => text("match(a); forward++;") && quad text("(input rimanente: d)") \
      & && &&&& k=2 => text("errore (b != d); BTK! forward--;") && quad text("(input ripristinato: ad)") \
      & && k=2 => &&&& A -> limits(a)_1 && quad text("(prova seconda produzione)") \
      & && &&&& k=1 => text("match(a); forward++;") && quad text("(input rimanente: d)") \
      & && k=3 => &&&& text("match(d); forward++;") && quad text("(input rimanente: vuoto)") \
      & && &&&& text("Successo!") &&
    $,
  )
  Alberi di parsing relativi alle scelte delle produzioni per $A$ (secondo l'ordine di esecuzione sopra):
  #import "@preview/cetz:0.5.0"

  #align(center)[
    #cetz.canvas({
      import cetz.draw: *

      // Impostiamo un po' di padding in modo che le linee
      // si fermino a una distanza elegante dai caratteri
      set-style(content: (padding: 0.1))

      // --- ALBERO (a) ---
      group(name: "tree_a", {
        content((0, 0), $S$, name: "S")
        content((-1, -1.2), $c$, name: "c")
        content((0, -1.2), $A$, name: "A")
        content((1, -1.2), $d$, name: "d")

        // Cetz calcola automaticamente l'intersezione ai bordi del contenuto
        line("S", "c")
        line("S", "A")
        line("S", "d")
      })

      // --- ALBERO (b) ---
      group(name: "tree_b", {
        // Trasliamo l'intero albero verso destra
        translate(x: 4.5)

        content((0, 0), $S$, name: "S")
        content((-1, -1.2), $c$, name: "c")
        content((0, -1.2), $A$, name: "A")
        content((1, -1.2), $d$, name: "d")

        // Figli del nodo A (più vicini tra loro rispetto a c e d)
        content((-0.6, -2.4), $a$, name: "a_child")
        content((0.6, -2.4), $b$, name: "b_child")

        line("S", "c")
        line("S", "A")
        line("S", "d")

        line("A", "a_child")
        line("A", "b_child")
      })

      // --- ALBERO (c) ---
      group(name: "tree_c", {
        // Trasliamo ulteriormente verso destra
        translate(x: 9)

        content((0, 0), $S$, name: "S")
        content((-1, -1.2), $c$, name: "c")
        content((0, -1.2), $A$, name: "A")
        content((1, -1.2), $d$, name: "d")

        // Singolo figlio centrato
        content((0, -2.4), $a$, name: "a_child")

        line("S", "c")
        line("S", "A")
        line("S", "d")

        line("A", "a_child")
      })
    })
  ]
]

Può accadere che un parser a discesa ricorsiva entri in un ciclo infinito. Un tale problema si presenta a causa di produzioni ricorsive sinistre, come
$
  mtext("expr") -> mtext("expr") + mtext("term")
$
Infatti potremmo trovarci nella situazione di espandere il non terminale _expr_ in _expr + term_, e poi espandere nuovamente _expr_ in _expr + term_, e così via, senza mai riuscire a consumare alcun simbolo della stringa d'ingresso. Per questo è necessario riformulare la grammatica in modo da eliminare la ricorsione sinistra.

=== Insiemi FIRST e FOLLOW

La costruzione dei parser bottom-up e top-down utilizza due funzioni, *FIRST* e *FOLLOW*, associate a una grammatica $G$. In particolare, nel parsing top-down *predittivo*, queste funzioni ci permettono di scegliere quale produzione applicare basandoci esclusivamente sul simbolo d'ingresso successivo.

#[
  #set heading(numbering: none, outlined: false)
  === FIRST
]
#definition()[
  Data $G$ grammatica e $alpha$ forma di frase (stringa di terminali e non-terminali), si definisce FIRST($alpha$) come:
  $
    "FIRST"(alpha) = {a in Sigma | alpha =>^* a beta} union { epsilon }bar_(alpha =>^* epsilon)
  $
  Ovvero, l'insieme dei simboli terminali che costituiscono l'inizio delle stringhe derivabili da $alpha$. Se $alpha$ può derivare la stringa vuota, allora $epsilon$ appartiene a FIRST($alpha$).
]

Per calcolare *FIRST* si seguono questi passaggi:

- Se $X$ è un terminale, allora $"FIRST("X")"= {X}$

- Se $X-> epsilon$ è una regola di $G$, allora $epsilon in "FIRST("X")"$

- Se $X$ è una variabile ed esiste in $G$ una produzione $X->Y_1 Y_2 ... Y_k$ con $k gt.eq 1$:

    + Se $Y_1 Y_2 ... Y_(i-1) der(*) epsilon$ e $Y_i cancel(der(*)) epsilon$, allora
      $
        "FIRST("X")" #box(scale(x: -100%, [$subset.eq$])) union.big_(j=1)^i "FIRST("Y_j")" without {epsilon}
      $
    + Se $Y_1 Y_2 ... Y_k der(*) epsilon$, allora
      $
        "FIRST("X")" #box(scale(x: -100%, [$subset.eq$])) union.big_(j=1)^k "FIRST("Y_j")"
      $

Allo stesso modo, se si vuole calcolare FIRST su un insieme di variabili:

+ Se $X_1 X_2 ... X_(i-1) der(*) epsilon$ e $X_i cancel(der(*)) epsilon$, allora
  $
    "FIRST("X_1 X_2 ... X_n")" = union.big_(j=1)^i "FIRST("X_j")" without {epsilon}
  $
+ Se $X_1 X_2 ... X_n der(*) epsilon$, allora
  $
    "FIRST("X_1 X_2 ... X_n")" = union.big_(j=1)^k "FIRST("X_j")" union {epsilon}
  $

#example()[

  Sia $G$ la grammatica
  $
    & A-> B C a \
    & B-> b bar epsilon \
    & C-> c bar epsilon
  $
  FIRST($A$) = FIRST($B$) $union$ FIRST($C$) $union$ FIRST($a$) = ${b} union {c} union {a} = {a b c}$

  Attenzione: in questo caso $epsilon$ *non* appartiene a FIRST($A$) perché $A$ non può dare origine a una stringa vuota (c'è per forza il terminale "a" in fondo).
]

#example()[

Sia $G$ la grammatica
$
  S &-> A x | y B \
  B &-> epsilon | z B \
  A &-> epsilon | B a S .
$

Si ha:

$"FIRST"(S) supset.eq "FIRST"(A) union "FIRST"(x) backslash { epsilon } = "FIRST"(A) union { x } backslash { epsilon }$ (nella prima produzione di $S$ il terminale $x$ funge da $Y_i$ con $i = 2$);

$"FIRST"(S) supset.eq "FIRST"(y) = { y }$ (nella seconda produzione di $S$ il teminale $y$ funge da $Y_i$ con $i = 1$);

$"FIRST"(A) in.rev epsilon$ (ciò è dovuto alla prima produzione di $A$);

$"FIRST"(A) supset.eq "FIRST"(B) union "FIRST"(a) backslash { epsilon }$ (nella seconda produzione di $A$ il terminale $a$ funge da $Y_i$ con $i = 2$);

$"FIRST"(B) in.rev epsilon$ (ciò è dovuto alla prima produzione di $B$);

$"FIRST"(B) supset.eq "FIRST"(z) = { z }$ (nella seconda produzione di $B$ il terminale $z$ funge da $Y_i$ con $i = 1$);

Pertanto:

$"FIRST"(B) = { z, epsilon };$

$"FIRST"(A) = { epsilon, z, a };$

$"FIRST"(S) = { y, x, z, a }.$

Di norma si comincia il calcolo di FIRST dalle produzioni che contengono terminali o $epsilon$ (tipo $B$ in questo caso) e si procede a ritroso fino a calcolare FIRST di tutte le variabili.
]

#observation()[
  Il FIRST di una variabile risponde alla domanda: _"Se espando questa variabile, quali sono i primissimi caratteri terminali che posso leggere?"_

  + *Se inizia con un terminale (es. $A -> c B$):* facile, Il FIRST è `{c}`.
  + *Se inizia con un non-terminale (es. $A -> B c$):* il FIRST di $A$ "ruba" il FIRST di $B$.
  + *L'effetto domino dell'$epsilon$:* se $A -> B C$ e sai che $B$ può scomparire (cioè ha $epsilon$ nel suo FIRST), allora devi guardare anche cosa c'è dopo. Quindi il FIRST di $A$ prenderà il FIRST di $B$ *più* il FIRST di $C$. Se anche $C$ può scomparire, continui a guardare a destra. Questo procedimento di "guardare a desatra" continua finché non si trova un terminale o una variabile che non può scomparire (non può produrre $epsilon$).
  + *Quando metto $epsilon$ nel FIRST?* Solo se *tutta* la produzione può svanire nel nulla.
]

#[
  #set heading(numbering: none, outlined: false)
  === FOLLOW
]

#definition()[
  Data $G$ grammatica e $A$ un non-terminale, si definisce FOLLOW($A$) come:
  $
    "FOLLOW("A")"= {a in Sigma bar S der(*) alpha A a beta}
  $
  Ovvero l'insieme dei simboli terminali che possono apparire *immediatamente alla destra* di $A$ in una qualche forma sentenziale derivata dal simbolo iniziale $S$.
  #observation()[
    Se $A$ può apparire come simbolo più a destra di una qualche forma sentenziale, allora il marcatore di fine input \$ appartiene a FOLLOW($A$). Ricordiamo che il simbolo \$ è uno speciale “marcatore di fine” e non appartenente ad alcuna grammatica.
  ]
]

Per calcolare il FOLLOW di tutte le variabili di una grammatica $G$ si procede applicando le regole seguenti finché non è più possibile aggiungere nulla all'insieme FOLLOW, supponendo che ogni stringa sia seguita dal marcatore \$ di fine stringa:

+ $ \$ in "FOLLOW"(S)$, $S$ simbolo iniziale.
+ Se esiste una produzione del tipo $A -> alpha B beta$, allora $"FOLLOW"(B) supset.eq "FIRST"(beta) without epsilon$.
+ Se esiste una produzione del tipo $A -> alpha B$ oppure del tipo $A -> alpha B beta$ dove $beta der(*) epsilon$ (cioè FIRST($beta$) contiene $epsilon$), allora $"FOLLOW"(B) supset.eq "FOLLOW"(A)$.

#example()[
  Sia $G$ la grammatica

  $
    & S -> A C B bar C b b bar B a \
    & A -> d a bar B C \
    & B -> g bar epsilon \
    & C -> h bar epsilon.
  $

  Si ha:

 #grid(
  columns: (1.1fr, 1.4fr),
  column-gutter: 0.8em,
  row-gutter: 1em,

  [$"FOLLOW"(S) = { \$ }$],
  [poiché $S$ è il simbolo iniziale e non compare in nessun'altra produzione;],

  [$"FOLLOW"(A) supset.eq "FIRST"(C B) without {epsilon}$],
  [poiché esiste $S -> A C B$;],

  [$"FOLLOW"(A) supset.eq "FOLLOW"(S)$],
  [poiché esiste $S -> A C B$ e $C B =>^* epsilon$;],

  [$"FOLLOW"(B) supset.eq "FIRST"(a) without {epsilon}$],
  [poiché esiste $S -> B a$;],

  [$"FOLLOW"(B) supset.eq "FOLLOW"(S)$],
  [poiché esiste $S -> A C B$;],

  [$"FOLLOW"(B) supset.eq "FIRST"(C) without {epsilon}$],
  [poiché esiste $A -> B C$;],

  [$"FOLLOW"(B) supset.eq "FOLLOW"(A)$],
  [poiché esiste $A -> B C$ e $C -> epsilon$;],

  [$"FOLLOW"(C) supset.eq "FIRST"(b b) without {epsilon}$],
  [poiché esiste $S -> C b b$;],

  [$"FOLLOW"(C) supset.eq "FIRST"(B) without {epsilon}$],
  [poiché esiste $S -> A C B$;],

  [$"FOLLOW"(C) supset.eq "FOLLOW"(S)$],
  [poiché esiste $S -> A C B$ e $B -> epsilon$;],

  [$"FOLLOW"(C) supset.eq "FOLLOW"(A)$],
  [poiché esiste $A -> B C$.],
)

  Poiché $"FIRST"(C B) = "FIRST"(B) union "FIRST"(C) = {h, g, epsilon}$ si ha:
  $
    & "FOLLOW"(A) = {h, g, \$}; \
    & "FOLLOW"(B) = {a, \$, h, g}; \
    & "FOLLOW"(C) = {b, \$, g, h}.
  $
]

#observation()[
  Il FOLLOW di $A$ risponde alla domanda: _"Nelle regole degli altri, chi c'è seduto immediatamente a destra di $A$?"_.
  *Attenzione:* Per calcolare il FOLLOW di $A$, non devi *mai* guardare le regole che iniziano con $A -> ...$, ma devi cercare dove $A$ compare a destra della freccia (nel corpo delle produzioni).

  + *La partenza:* metti sempre il simbolo di fine stringa $\$$ nel FOLLOW del simbolo iniziale (es. $S$).
  + *Chi c'è a destra?*: se a destra c'è un terminale $B$, es. $X -> alpha A B$, il FOLLOW di $A$ "ruba" il *FIRST* di $B$ escluso l'$epsilon$. In particolare, se a destra c'è un non terminale $b$, allora si ha che $"FIRST"(b) = {b}$ e quindi $b in "FOLLOW"(A)$.
  + *L'effetto "fine riga" (es. $X -> alpha A$)*: se $A$ è in fondo alla regola, non ha nessuno a destra. In questo caso, chiunque segua $X$, seguirà anche $A$. Quindi il FOLLOW di $A$ "ruba" il *FOLLOW* di $X$ (NB: questo vale anche se $X -> alpha A B$ ma $B$ può svanire diventando $epsilon$).
]

=== Grammatiche LL(1) e parsing predittivo

Per le grammatiche della classe LL(1) è sempre possibile costruire un parser top-down predittivo (deterministico), cioè un parser a discesa ricorsiva senza backtracking. La prima "L" indica che le stringhe in ingresso sono scandite da sinistra (_Left_, appunto) verso destra, la seconda "L" specifica che si costruisce una derivazione sinistra (_Leftmost derivation_) e infine l'"1" fra parentesi indica che le decisioni durante il parsing vengono prese analizzando un solo simbolo di lookahead, cioè guardando il prossimo simbolo della stringa in ingresso. La classe LL(1) è sufficientemente ricca da coprire la maggior parte dei linguaggi di programmazione.

- Una grammatica che presenta *ricorsione sinistra non è LL(1)*.
- Una grammatica in cui *le produzioni per una variabile hanno
  prefissi comuni non è LL(1)* (in genere richiede fattorizzazione a sinistra).

#definition("Grammatica LL(1)")[
  Una grammatica $G$ è *LL(1)* se e solo se soddisfa le seguenti condizioni $forall$ variabile $A$.

  Se $A -> alpha_1 bar alpha_2 bar ... bar alpha_k$ sono le produzioni per $A$, allora:

  - FIRST($alpha_i$) $inter$ FIRST($alpha_j$) $= emptyset quad forall i eq.not j$

  - se $exists space i$ tale che $alpha_i der(*) epsilon$ allora

    - $alpha_j cancel(der(*)) epsilon quad forall j eq.not i quad$ e
    - FOLLOW($A$) $inter$ FIRST($A$) $= emptyset$
  
  Ovvero, per ogni variabile:

  - gli insiemi FIRST relativi alle parti destre delle produzioni sono due a due disgiunti.

  - Esiste al più una parte destra che può derivare $epsilon$ e in questo caso l'insieme FOLLOW della variabile deve essere disgiunto dagli insiemi FIRST di tutte le parti destre, cioè dal FIRST della variabile.
]

Se le regole per la variabile $A$ sono $A-> alpha_1 bar alpha_2 bar ... bar alpha_k$, allora:
#figure(grid(
  columns: 3,
  algo(
    title: [*void* A],
  )[
    if ($a in "FIRST"(alpha_1)$)#i\
    {codice per $alpha_1$;}#d\
    else if ($a in "FIRST"(alpha_2)$)#i\
    {codice per $alpha_2$;}\
    $quad quad space space dots.v$#d\
    else if ($a in "FIRST"(alpha_k)$)#i\
    {codice per $alpha_k$;}#d\
    else if ($A cancel(der(*)) epsilon$ *or* $a in.not "FOLLOW"(A)$)#i\
    {errore();}#d\
    }
  ],
  $
    quad
  $,
  algo(
    inset: 14.15pt,
    line-numbers: false,
  )[
    codice per $alpha_i=X_1X_2dots X_n$\
    \

    for ($i=1;i<=n;i$++) {#i\
    if ($X_i in V$)#i\
    $X_i ()$;#d\
    else if ($X_i=a$)#i\
    $a=$next.token;#d\
    else#i\
    errore();#d#d\
    }
  ],
))

Cioè, in una grammatica LL(1), la produzione da applicare a un non-terminale $A$ può essere scelta osservando un solo simbolo di ingresso. Supponiamo di aver costruito una derivazione
  $S =>^* u A beta$ e che la stringa in ingresso sia $u a v$.

  + Se $a in "FIRST"(alpha_i)$, si applica la produzione
    $A -> alpha_i$, ottenendo
    $S =>^* u A beta => u alpha_i beta$.

  + Se $A =>^* epsilon$ e $a in "FOLLOW"(A)$, $A$ può essere
    annullato, ottenendo
    $S =>^* u A beta => u beta$.

  La proprietà LL(1) garantisce che la scelta possa essere effettuata
  utilizzando un solo simbolo di lookahead.

I costrutti per il controllo del flusso, grazie alle loro specifiche parole chiave, generalmente soddisfano i vincoli della classe LL(1). Per esempio, date le produzioni:
$
  s t m t & -> bold("if") "(" e x p r ")" s t m t bold("else") s t m t \ & bar bold("while") "(" e x p r ")" s t m t \ & bar
  { s t m t"_"l i s t }
$
si ha
  $
    & "FIRST"(bold("if") "(" e x p r ")" s t m t bold("else") s t m t)
      = {bold("if")}, \
    & "FIRST"(bold("while") "(" e x p r ")" s t m t)
      = {bold("while")}, \
    & "FIRST"({s t m t"_"l i s t})
      = {{}}.
  $
Poiché questi insiemi sono disgiunti, il prossimo simbolo in ingresso determina *univocamente* quale produzione di $s t m t$ applicare: *if*, *while* oppure ${$.

L'esempio precedente mostra il caso in cui la produzione viene scelta
tramite gli insiemi $"FIRST"$. Se invece una delle alternative può derivare $epsilon$, entra in gioco anche il $"FOLLOW"$. Per esempio, data la produzione

$
  E' -> + T E' bar epsilon
$

si ha

$
  "FIRST"(+ T E') = {+}
  quad "e" quad
  "FOLLOW"(E') = {), \$}.
$

Quindi, se il simbolo di lookahead è $+$, si applica
$E' -> + T E'$; se invece il lookahead appartiene a
$"FOLLOW"(E')$, cioè è $)$ oppure $\$$, si sceglie
$E' -> epsilon$.

==== Tabelle di parsing predittivo
Le informazioni fornite dagli insiemi FIRST e FOLLOW possono essere raccolte in una tabella di parsing predittivo $M$, ovvero una matrice bidimensionale in cui le righe corrispondono alle variabili e le colonne ai terminali e al marcatore di fine stringa \$. Il contenuto di $M[A, a]$ indica la regola da utilizzare per espandere la variabile $A$ quando il prossimo simbolo in ingresso è $a$.

La costruzione della tabella si basa sul fatto che la regola $A-> alpha$ viene scelta soltanto se il simbolo in ingresso $a in$ FIRST($alpha$), oppure $alpha der(*) epsilon$ e $a in$ FOLLOW($A$) (in questo caso può essere $a = \$$).

Di seguito l'*algoritmo di costruzione* della tabella di parsing predittivo $M$ per una grammatica $G$:

*INPUT*: Una grammatica $G$.\
*OUTPUT*: Una tabella di parsing $M$.\
*METODO*: Per ogni produzione $A-> alpha$ della grammatica $G$:

+ per ogni terminale $a in$ FIRST($alpha$) si aggiunge $A-> alpha$ a $M[A,a]$
+ se $epsilon in$ FIRST($alpha$), allora per ogni simbolo $b in$ FOLLOW($A$) (incluso eventualmente \$) si aggiunge $A-> alpha$ a $M[A,b]$

Se in $M[A, a]$ non c'è nessuna regola si ha una condizione di errore: il simbolo $a$ non può essere ottenuto applicando nessuna delle regole per $A$.
Se $M[A, a]$ contiene più di una regola allora la grammatica non è LL(1) perché $a$ appartiene agli insiemi FIRST di due regole distinte oppure $A der(*) epsilon$ e $a$ appartiene al FOLLOW($A$) e al FIRST di una regola per $A$.

#example(multiple: true)[

  1)
  #grid(
    column-gutter: 12.5%,
    columns: 3,
    [$
      & E  && -> T E' \
      & E' && -> +T E' | epsilon \
      & T  && -> F T' \
      & T' && -> *F T' | epsilon \
      & F  && -> (E) | bold(id)
    $],
    [$
      & "FIRST"(T E')  && ={(, bold(id)} \
      & "FIRST"(+T E') && ={+} \
      & "FIRST"(F T')  && ={(, bold(id)} \
      & "FIRST"(*F T') && ={*} \
      & "FIRST"((E))   && ={(}
    $],
    [$
      & \
      & "FOLLOW"(E')       && ={(, \$} \
      & \
      & "FOLLOW"(T')       && ={+, ), \$} \
      & "FOLLOW"(bold(id)) && ={bold(id)} \
    $],
  )
  #figure(table(
    columns: (.33fr, .9fr, 1fr, 1fr, 1fr, .75fr, .75fr),
    rows: auto,
    table.header([], [*id*], [+], [\*], [(], [)], [\$]),
    [$E$], [$E -> T E'$], [                ], [             ], [$E -> T E'$], [               ], [               ],
    [$E'$], [            ], [$E' -> +T E'$], [             ], [           ], [$E' -> epsilon$], [$E' -> epsilon$],
    [$T$],
    [$T -> F T'$],
    [                ],
    [             ],
    [  $T -> F T'$         ],
    [               ],
    [               ],

    [$T'$], [            ], [$T' -> epsilon'$], [$T' -> *F T'$], [           ], [$T' -> epsilon$], [$T' -> epsilon$],
    [$F$], [$F ->$ *id*], [                ], [             ], [$F -> (E)$], [               ], [               ],
  ))
  Gli spazi vuoti nelle colonne di questa tabella indicano condizioni di errore, gli altri indicano quale produzione usare per espandere un non-terminale.\

  2)
  #block(
    $
      & S -> i E t S | i E t S e S | a \
      & E -> b
    $,
  )
  #grid(
    column-gutter: 5%,
    columns: 3,
    [$
      & S  && -> i E t S S' | a \
      & S' && -> e S | epsilon \
      & E  && -> b
    $],
    [$
      & "FIRST"(i E t S S') && ={i} \
      & "FIRST"(e S)        && ={e} \
      &
    $],
    [$
      & "FIRST"(a)         && = {a} \
      & \
      \
      & "FOLLOW"(bold(id)) && ="FOLLOW"(S) && ={e, \$}
    $],
  )
#figure(table(
  columns: (.33fr, .9fr, 1fr, 1fr, 1fr, .75fr, .75fr),
  rows: (1.75em, 1.75em, 3.5em, 1.75em),
  align: horizon,
  table.header([], [$a$], [$b$], [$e$], [$i$], [$t$], [\$]),
  [$S$], [$S -> a$], [ ], [ ], [$S -> i E t S S'$], [], [ ],
  [$S'$], [ ], [ ], text(fill: red)[$S' -> e S$ \ $S' -> epsilon$], [ ], [], [$S' -> epsilon$],
  [$E$], [ ], [$E -> b$], [ ], [ ], [], [ ],
))
  Questa non è quindi una grammatica LL(1).
]

==== Parsing predittivo non ricorsivo
Un parser predittivo non ricorsivo può essere costruito gestendo uno stack esplicitamente, piuttosto che facendo affidamento sullo stack (implicito) dovuto alle chiamate ricorsive. Il parser riproduce il processo di derivazione sinistra. Se $w$ è la porzione dell'input riconosciuta fino a un certo momento, allora lo stack contiene una sequenza di simboli $alpha$ tali che $S der(*) w alpha$.

Il parser è dotato di:
- un buffer di ingresso (contiene la stringa in esame seguita da \$)
- uno stack contenente simboli in $V union Sigma union {\$}$
- una tabella di parsing
- uno stream di uscita

Inizialmente lo stack contiene il simbolo \$ (in fondo) e il simbolo distinto della grammatica. Ad ogni passo, il parser considera il simbolo $X$ in cima allo stack e il simbolo d'ingresso corrente $a$.

- Se $X$ è una variabile, il parser esamina l'elemento $M[X, a]$
  - se contiene una regola $X -> alpha$ allora, nello stack, $X$ viene sostituito da $alpha$ (il primo simbolo in testa), ed eventualmente vengono costruiti i nodi corrispondenti nell'albero di parsing;
  - se è vuoto si ha una situazione di errore che può essere segnalata.
- Se $X$ è un terminale, viene confrontato col simbolo in ingresso a
  - se sono uguali $X$ viene rimosso dallo stack e si avanza al prossimo simbolo in ingresso
  - se sono diversi si ha una situazione di errore.

Se lo stack contiene \$ e il prossimo simbolo in ingresso è \$, cioè la stringa in esame è stata scandita completamente, la stringa viene accettata. Il comportamento del parser è descritto dalle sue *configurazioni* che sono costituite dal contenuto dello stack e dalla parte di input ancora da esaminare.


#figure(diagram(
  node-stroke: none,
  spacing: 3mm,

  node((0.5, 0), [Input]),
  node((1.865, 0), table(
    columns: 8,
    [⠀], [⠀], [⠀], [⠀], [$a$], [$+$], [$b$], [$s$],
  )),
  node((0, 2), "Stack"),
  node((1, 2.45), table(
    [$X$],
    [$Y$],
    [$Z$],
    [\$],
  )),
  node((2, 2), $\ "Programma "\ "di parsing" \ "predittivo"$, width: 90pt, shape: rect, stroke: 0.9pt, name: <center>),
  node((4, 2), "Output", name: <right>),
  node((2, 3.5), $\ "Tabella "\ "di parsing" \ "M"$, width: 90pt, shape: rect, stroke: 0.9pt, name: <bottom>),

  edge(<center>, (2, 0), "-|>"),
  edge(<center>, (0.7, 2), "-|>"),
  edge(<center>, <right>, "-|>"),
  edge(<center>, <bottom>, "-|>"),
),
  caption: "Modello di una parser predittivo guidato da una tabella.",
)

Di seguito un *algoritmo* di *parsing predittivo guidato* da una *tabella*:

*INPUT*: Una stringa $w$ e una tabella $M$ relativa ad una grammatica $G$.\
*OUTPUT*: Se $w in L(G)$, una derivazione sinistra di $w$, altrimenti un errore.\
*METODO*: Inizialmente $w\$$ nel buffer, il simbolo iniziale $S\$$ nello stack ($S$ in cima).
#figure(algo()[
  _ip_ punta al primo simbolo $a$ di $w$;\
  assegna a $X$ il simbolo in cima allo stack $PP space (X="pop"(PP))$;\
  while($X != \$$) {#i \/\* lo stack non è vuoto \*\/ \
  if ($X = a$) avanza il puntatore $i p$;\
  else if ($X in Sigma union {\$}$) errore();\
  else if ($M[X, a] = emptyset$) errore();\
  else if ($M[X, a] = X -> Y_1Y_2 dots Y_k$) {#i\
  produci come uscita $X -> Y_1Y_2 dots Y_k$;\
  inserisci $Y_k,Y_(k-1),dots,Y_1$ nello stack ($Y_1$ in cima)#d\
  }\
  assegna a $X$ il simbolo in cima allo stack ($X = p o p(PP)$)#d\
  }\
  if ($a = \$$) accetta altrimenti errore();
])

#figure(
  table(
    stroke: none,
    columns: (.5fr, .5fr, .4fr, 1fr),
    align: (start, end, end, start),
    table.hline(start: 0),
    table.header(
      table.cell(align: center, [Riconosciuta]),
      table.cell(align: horizon, [Stack]),
      table.cell(align: center, [Input]),
      table.cell(align: center, [Azione]),
    ),
    table.hline(start: 0),
    table.vline(start: 1, x: 3, stroke: (paint: gray, dash: "dotted")),
    table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dotted")),
    table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dotted")),
    [$$], [$E\$$], [$bold(id)+bold(id)*bold(id)\$$], [$$],
    [$$], [$T E'\$$], [$bold(id)+bold(id)*bold(id)\$$], [output  $E -> T E'$],
    [$$], [$F T'E'\$$], [$bold(id)+bold(id)*bold(id)\$$], [output  $T -> F T'$],
    [$$], [$bold(id)T'E'\$$], [$bold(id)+bold(id)*bold(id)\$$], [output  $F -> bold(id)$],
    [$bold(id)$], [$T'E'\$$], [$+bold(id)*bold(id)\$$], [consuma $bold(id)$],
    [$bold(id)$], [$E'\$$], [$+bold(id)*bold(id)\$$], [output  $T' -> epsilon$],
    [$bold(id)$], [$+T E'\$$], [$+bold(id)*bold(id)\$$], [output  $E' -> +T E'$],
    [$bold(id)+$], [$T E'\$$], [$bold(id)*bold(id)\$$], [consuma $+$],
    [$bold(id)+$], [$F T'E'\$$], [$bold(id)*bold(id)\$$], [output  $T -> F T'$],
    [$bold(id)+$], [$bold(id)T'E'\$$], [$bold(id)*bold(id)\$$], [output  $F -> bold(id)$],
    [$bold(id)+bold(id)$], [$T'E'\$$], [$*bold(id)\$$], [consuma $bold(id)$],
    [$bold(id)+bold(id)$], [$*F T'E'\$$], [$*bold(id)\$$], [output  $T' -> *F T'$],
    [$bold(id)+bold(id)*$], [$F T'E'\$$], [$bold(id)\$$], [consuma $*$],
    [$bold(id)+bold(id)*$], [$bold(id)T'E'\$$], [$bold(id)\$$], [output  $F -> bold(id)$],
    [$bold(id)+bold(id)*bold(id)$], [$T'E'\$$], [$\$$], [consuma $bold(id)$],
    [$bold(id)+bold(id)*bold(id)$], [$E'\$$], [$\$$], [output  $T' -> epsilon$],
    [$bold(id)+bold(id)*bold(id)$], [$\$$], [$\$$], [output  $E' -> epsilon$],

    table.hline(start: 0),
  ),
  caption: [Mosse di un parser predittivo durante l'analisi della stringa *id* + *id* \* *id* (grammatica dell'ultimo esempio)],
)

#figure(
  table(
    stroke: none,
    columns: (.5fr, .5fr, .4fr, 1fr),
    align: (start, end, end, start),
    table.hline(start: 0),
    table.header(
      table.cell(align: center, [Riconosciuta]),
      table.cell(align: horizon, [Stack]),
      table.cell(align: center, [Input]),
      table.cell(align: center, [Azione]),
    ),
    table.hline(start: 0),
    table.vline(start: 1, x: 3, stroke: (paint: gray, dash: "dotted")),
    table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dotted")),
    table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dotted")),
    [       ], [$E\$$], [$bold(id)*+bold(id)\$$], [                      ],
    [       ], [$T E'\$$], [$bold(id)*+bold(id)\$$], [output $E -> T E'$],
    [       ], [$F T'E'\$$], [$bold(id)*+bold(id)\$$], [output $T -> F T'$],
    [       ], [$bold(id)T'E'\$$], [$bold(id)*+bold(id)\$$], [output $F ->$ *id*    ],
    [*id*   ], [$T'E'\$$], [$*+bold(id)\$$], [consuma *id*          ],
    [*id*   ], [$*F T'E'\$$], [$*+bold(id)\$$], [output $T' -> *F T'$],
    [*id* \*], [$F T'E'\$$], [$+bold(id)\$$], [consuma $*$],
    [*id* \*], [$F T'E'\$$], [$+bold(id)\$$], [errore(): $M[F, +] = emptyset$],
  ),
  caption: [Blocco del parser dovuto alla stringa in input non valida *id*\* + *id*],
)

#figure(
  table(
    stroke: none,
    columns: (.5fr, .5fr, .4fr, 1fr),
    align: (start, end, end, start),
    table.hline(start: 0),
    table.header(
      table.cell(align: center, [Riconosciuta]),
      table.cell(align: horizon, [Stack]),
      table.cell(align: center, [Input]),
      table.cell(align: center, [Azione]),
    ),
    table.hline(start: 0),
    table.vline(start: 1, x: 3, stroke: (paint: gray, dash: "dotted")),
    table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dotted")),
    table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dotted")),
    [      ], [$E\$$], [(*id*\$], [                                           ],
    [      ], [$T E'\$$], [(*id*\$], [output  $E -> T E'$                        ],
    [      ], [$F T'E'\$$], [(*id*\$], [output  $T -> F T'$                        ],
    [      ], [$(E)T'E'\$$], [(*id*\$], [output  $F -> (E)$                         ],
    [(     ], [$E)T'E'\$$], [*id*\$ ], [consuma $($                                ],
    [(     ], [$T E')T'E'\$$], [*id*\$ ], [output  $E -> T E'$                        ],
    [(     ], [$F T'E')T'E'\$$], [*id*\$ ], [output  $T -> F T'$                        ],
    [(     ], [*id* $T'E')T'E'\$$], [*id*\$ ], [output  $F ->$ *id*                        ],
    [( *id*], [$T'E')T'E'\$$], [\$     ], [consuma *id*                               ],
    [( *id*], [$E')T'E'\$$], [\$     ], [output  $T' -> epsilon$                    ],
    [( *id*], [$)T'E'\$$], [\$     ], [output  $E' -> epsilon$                    ],
    [( *id*], [$)T'E'\$$], [\$     ], [errore(): ')' $!=$ \$],
  ),
  caption: [Blocco del parser dovuto alla stringa in input non valida (*id*. L'errore scatta all'*if* della riga 13 dell'algoritmo: l'input finisce ma ci si aspettava un altro ')'.],
)

== Parsing Bottom-Up

Il parsing bottom-up procede alla costruzione di un albero di parsing per una data stringa d'ingresso cominciando dalle foglie (bottom) e procedendo verso l'alto (up) fino alla radice.

#example(multiple: true)[
  #block(
    $
      & E -> T        && | E + T \
      & T -> F        && | T * F \
      & F -> bold(id) && | (E)
    $,
  )
  #figure(diagram(
    node-stroke: none,
    edge-corner-radius: 5pt,
    spacing: 1mm,
    node((0, 0), [*id*]),
    node((1, 0), [*\**]),
    node((2, 0), [*id*]),
    node((3, 0), [*$F$*]),
    node((4, 0), [*\**]),
    node((5, 0), [*id*]),
    node((6, 0), [*$T$*]),
    node((7, 0), [*\**]),
    node((8, 0), [*id*]),
    node((9, 0), [*$T$*]),
    node((10, 0), [*\**]),
    node((11, 0), [*$F$*]),
    node((13, 0), [*$T$*]),
    node((16, 0), [*$E$*]),


    node((3, 1), [*id*]),
    node((6, 1), [*$F$*]),
    node((9, 1), [*$F$*]),
    node((11, 1), [*id*]),
    node((12, 1), [*$T$*]),
    node((13, 1), [*$*$*]),
    node((14, 1), [*$F$*]),
    node((16, 1), [*$T$*]),

    node((6, 2), [*id*]),
    node((9, 2), [*id*]),
    node((12, 2), [*$F$*]),
    node((14, 2), [*id*]),
    node((15, 2), [*$T$*]),
    node((16, 2), [*$*$*]),
    node((17, 2), [*$F$*]),

    node((12, 3), [*id*]),
    node((15, 3), [*$F$*]),
    node((17, 3), [*id*]),

    node((15, 4), [*id*]),

    // EDGES //
    edge((-1, 2), (-1, -1), (18, -1), (18, 5), (-1, 5), (-1, 2)),
    edge((2.5, -1), (2.5, 5)),
    edge((5.5, -1), (5.5, 5)),
    edge((8.5, -1), (8.5, 5)),
    edge((11.5, -1), (11.5, 5)),
    edge((14.5, -1), (14.5, 5)),

    edge((3, 0), (3, 1)),
    edge((6, 0), (6, 1)),
    edge((9, 0), (9, 1)),
    edge((11, 0), (11, 1)),
    edge((13, 0), (12, 1)),
    edge((13, 0), (13, 1)),
    edge((13, 0), (14, 1)),
    edge((16, 0), (16, 1)),


    edge((6, 1), (6, 2)),
    edge((9, 1), (9, 2)),
    edge((12, 1), (12, 2)),
    edge((14, 1), (14, 2)),
    edge((16, 1), (15, 2)),
    edge((16, 1), (16, 2)),
    edge((16, 1), (17, 2)),

    edge((12, 2), (12, 3)),
    edge((15, 2), (15, 3)),
    edge((17, 2), (17, 3)),

    edge((15, 3), (15, 4)),
  ))
  #figure(diagram(
    node-stroke: none,
    edge-corner-radius: 5pt,
    spacing: 1mm,
    node-shape: rect,
    node((0, 0), [*id*], width: 18pt),
    node((1, 0), [*+*], width: 18pt),
    node((2, 0), [*id*], width: 18pt),
    node((3, 0), [*$F$*], width: 18pt),
    node((4, 0), [*+*], width: 18pt),
    node((5, 0), [*id*], width: 18pt),
    node((6, 0), [*$T$*], width: 18pt),
    node((7, 0), [*+*], width: 18pt),
    node((8, 0), [*id*], width: 18pt),
    node((9, 0), [*$E$*], width: 18pt),
    node((10, 0), [*+*], width: 18pt),
    node((11, 0), [*id*], width: 18pt),
    node((12, 0), [*$E$*], width: 18pt),
    node((13, 0), [*$+$*], width: 18pt),
    node((14, 0), [*$F$*], width: 18pt),
    node((15, 0), [*$E$*], width: 18pt),
    node((16, 0), [*$+$*], width: 18pt),
    node((17, 0), [*$T$*], width: 18pt),
    node((19, 0), [*$E$*], width: 18pt),

    node((3, 1), [*id*], width: 18pt),
    node((6, 1), [*$F$*], width: 18pt),
    node((9, 1), [*$T$*], width: 18pt),
    node((12, 1), [*$T$*], width: 18pt),
    node((14, 1), [*id*], width: 18pt),
    node((15, 1), [*$T$*], width: 18pt),
    node((17, 1), [*$F$*], width: 18pt),
    node((18, 1), [*$E$*], width: 18pt),
    node((19, 1), [*$+$*], width: 18pt),
    node((20, 1), [*$T$*], width: 18pt),

    node((6, 2), [*id*], width: 18pt),
    node((9, 2), [*$F$*], width: 18pt),
    node((12, 2), [*$F$*], width: 18pt),
    node((15, 2), [*$F$*], width: 18pt),
    node((17, 2), [*id*], width: 18pt),
    node((18, 2), [*$T$*], width: 18pt),
    node((20, 2), [*$F$*], width: 18pt),

    node((9, 3), [*id*], width: 18pt),
    node((12, 3), [*id*], width: 18pt),
    node((15, 3), [*id*], width: 18pt),
    node((18, 3), [*$F$*], width: 18pt),
    node((20, 3), [*id*], width: 18pt),

    node((18, 4), [*id*], width: 18pt),

    // EDGES //
    edge((-1, 2), (-1, -1), (21, -1), (21, 5), (-1, 5), (-1, 2)),
    edge((2.5, -1), (2.5, 5)),
    edge((5.5, -1), (5.5, 5)),
    edge((8.5, -1), (8.5, 5)),
    edge((11.5, -1), (11.5, 5)),
    edge((14.5, -1), (14.5, 5)),
    edge((17.5, -1), (17.5, 5)),

    edge((3, 0), (3, 1)),
    edge((6, 0), (6, 1)),
    edge((9, 0), (9, 1)),
    edge((12, 0), (12, 1)),
    edge((14, 0), (14, 1)),
    edge((15, 0), (15, 1)),
    edge((17, 0), (17, 1)),
    edge((19, 0), (18, 1)),
    edge((19, 0), (19, 1)),
    edge((19, 0), (20, 1)),


    edge((6, 1), (6, 2)),
    edge((9, 1), (9, 2)),
    edge((12, 1), (12, 2)),
    edge((15, 1), (15, 2)),
    edge((17, 1), (17, 2)),
    edge((18, 1), (18, 2)),
    edge((20, 1), (20, 2)),

    edge((9, 2), (9, 3)),
    edge((12, 2), (12, 3)),
    edge((15, 2), (15, 3)),
    edge((18, 2), (18, 3)),
    edge((20, 2), (20, 3)),

    edge((18, 3), (18, 4)),
  ))
]

=== Riduzioni, potatura e handle
Gli analizzatori bottom-up partono da una stringa $w$ e procedono a ritroso, effettuando una progressiva riduzione, fino ad ottenere il simbolo distinto $S$. I parser bottom-up si basano sul meccanismo di *riduzione* che consiste nel sostituire la parte destra di una regola con la parte sinistra.

Per definizione, una *riduzione* è l'esatto *opposto* di un passo di *derivazione* (si ricordi che in una derivazione un non-terminale in una forma sentenziale viene sostituito dal corpo di una delle sue produzioni). Lo scopo del parsing bottom-up è quindi quello di costruire una derivazione al rovescio.

Per gli esempi precedenti, considerando le radici dei sottoalberi, si hanno le sequenze di stringhe:
- $text("id") * text("id") quad -> quad F * text("id") quad -> quad T * text("id") quad -> quad T * F quad -> quad T quad -> quad E$
- $text("id") + text("id") quad -> quad F + text("id") quad -> quad T + text("id") quad -> quad E + text("id") quad -> quad E + F quad -> quad E + T quad -> quad E$
che corrispondono alle derivazioni *destre*:
- $E => T => T * F => T * text("id") => F * text("id") => text("id") * text("id")$
- $E => E + T => E + F => E + text("id") => T + text("id") => F + text("id") => text("id") + text("id")$

Ad ogni passo dell'analisi, i parser bottom-up effettuano una riduzione oppure scandiscono un simbolo in ingresso. Per questo sono detti anche parser shift-reduce, impila-riduci, sposta-riduci.
Le decisioni fondamentali ad ogni passo sono se effettuare una riduzione e quale regola utilizzare.

#definition()[
  Una *maniglia* (*handle*) è una sottostringa che corrisponde alla parte destra di una produzione (il corpo) e la cui riduzione verso la parte sinistra (la testa) rappresenta un singolo passo legittimo nella costruzione della *derivazione destra a ritroso*.
]


//TODO: scegliere tra le immagini
#figure(
  table(
    stroke: none,
    columns: (3cm, 3cm, 4cm),
    align: start,
    table.hline(start: 0),
    table.header(
      table.cell(align: center, [Fdf dx]),
      table.cell(align: horizon, [Handle]),
      table.cell(align: center, [Regola riduzione]),
    ),
    table.hline(start: 0),
    table.vline(start: 0, x: 2, stroke: (paint: gray, dash: "dotted")),
    table.vline(start: 0, x: 1, stroke: (paint: gray, dash: "dotted")),
    [*id* $*$ *id*], [*id*   ], [$F -->$ *id*],
    [$F *$ *id*   ], [$F$], [$T --> F$],
    [$T *$ *id*   ], [*id*   ], [$F -->$ *id*],
    [$T * F$], [$T * F$], [$T -->T * F$],
    [$T$], [$T$], [$E -> T$],
    [$E$], [$$], [$$],

    table.hline(start: 0),

    [*id* $+$ *id*], [*id*   ], [$F -->$ *id* ],
    [$F +$ *id*   ], [$F$], [$T --> F$],
    [$T +$ *id*   ], [$T$], [$E --> T$],
    [$E +$ *id*   ], [*id*   ], [$F -->$ *id* ],
    [$E + F$], [$F$], [$T --> F$],
    [$E + T$], [$E + T$], [$E --> E + T$],
    [$E$], [$$], [$$],
    table.hline(start: 0),
  ),
)

Nel primo esempio (nella stringa $T * text("id")$), il non-terminale $T$ *non* viene ridotto ad $E$ anche se è la parte destra della regola $E -> T$. Se lo facessimo, otterremmo $E * text("id")$, che è una via senza uscita (il parser andrebbe in errore). Nel secondo esempio, invece, nella stringa $T + text("id")$, $T$ *viene* ridotto con la regola $E -> T$.
Questo dimostra un concetto chiave: *una sottostringa che corrisponde alla parte destra di una regola non è necessariamente un handle in quel momento*. Dipende dal contesto e dalle precedenze.


Formalmente, se $S =>^* alpha A w => alpha beta w$, la produzione $A -> beta$ nella posizione che segue $alpha$ è un handle di $alpha beta w$.

#figure(
  diagram(
    node-stroke: none,
    edge-corner-radius: none,
    spacing: 1mm,

    node((3, 0), $S$, name: <s>),
    node((2.5, 4), $A$, name: <a>),
    node((-2, 7.75), $alpha$),
    node((2.5, 7.75), $beta$),
    node((8.5, 7.75), $omega$),

    edge(<s>, <a>, dash: "dashed"),
    edge(<s>, (15, 7), (3.75, 7)),
    edge(<s>, (-8, 7), (1.25, 7)),
    edge(<a>, (3.5, 7), (1.5, 7), <a>),
  ),
  caption: [Un handle $A -> beta$ nell'albero di parsing relativo alla stringa $alpha beta w$],
)

Alternativamente, un handle per una forma sentenziale destra $gamma$ è costituito dalla produzione $A -> beta$ e da una posizione in $gamma$ in cui si trova la stringa $beta$, tale che la sostituzione di tale occorrenza di $beta$ con $A$ produce la forma sentenziale destra precedente in una derivazione destra di $gamma$.
Si noti che la stringa $w$ a destra dell'handle deve contenere solo simboli terminali. Per semplicità, parlando di handle, ci riferiremo al corpo $beta$ di una produzione $A -> beta$ piuttosto che alla produzione stessa. Se una grammatica non è ambigua, allora ogni forma sentenziale destra della grammatica ammette uno e un solo handle.

Una derivazione destra a rovescio può essere ottenuta mediante un processo noto come *potatura* (*pruning*). Si comincia dalla stringa $w$ costituita dai simboli terminali da analizzare:
$
  S = gamma_0 => gamma_1 => gamma_2 => ... => gamma_(n-1) => gamma_n = w
$
Per ricostruire questa derivazione in ordine inverso, si individua l'handle $beta_n$ in $gamma_n$ e lo si sostituisce con la parte sinistra della regola $A_n -> beta_n$, in modo da ottenere la forma sentenziale destra precedente $gamma_(n-1)$.
Poi si individua l'handle $beta_(n-1)$ in $gamma_(n-1)$ e si sostituisce con $A_(n-1)$, e così via. Se, procedendo a ritroso in questo modo, otteniamo una forma sentenziale destra costituita unicamente dal simbolo iniziale $S$ della grammatica, significa che il parsing è stato completato con successo.

=== Il modello Shift-Reduce
Nel parsing *impila-riduci* (*shift-reduce*) si usa uno stack per mantenere i simboli grammaticali e un buffer di ingresso che contiene la parte di input ancora da analizzare. Il simbolo `$` viene utilizzato sia come marcatore di fine stringa sia per indicare il fondo dello stack. Inizialmente, lo stack contiene solo `$` e il buffer di ingresso contiene la stringa $w \$$.

Un aspetto fondamentale di questo approccio è che una *maniglia* (handle), subito prima di essere individuata e ridotta, si trova *sempre in cima allo stack*.


La stringa in ingresso viene scandita da sinistra a destra. Il parser inserisce nello stack (azione di *shift*) zero o più simboli finché in cima non si trova una maniglia $beta$. A questo punto viene effettuata una riduzione (azione di *reduce*), sostituendo $beta$ con il non-terminale posto alla sinistra della regola opportuna. Il parser ripete questo procedimento finché non rileva un errore oppure lo stack contiene $\$S$ e nell'ingresso è rimasto solo $\$$, segno che la stringa è stata accettata.

Un parser shift-reduce può compiere quattro azioni fondamentali:
+ *Shift*: inserisce il prossimo simbolo in ingresso in cima allo stack.
+ *Reduce*: il simbolo più a destra della stringa da ridurre si trova in cima allo stack. Si effettua una riduzione sostituendo la parte dx della regola con la parte sx.
+ *Accept*: indica il corretto completamento dell'analisi.
+ *Error*: si è verificata una situazione di errore.

#observation()[
  Nelle tabelle di tracciamento successive, lo stack viene rappresentato con l'elemento di testa a destra. In questo modo, il contenuto dello stack e l'input rimanente, letti di seguito, corrispondono esattamente alla forma sentenziale destra corrente.
]

#grid(
  columns: (.2fr, .7fr),
  column-gutter: 20pt,
  align: horizon,

  [#block(
    $
      S & -> a S b | space a A b \
      A & -> a A c | space a c \
        \
        \
        \
        \
      S & => a S b \
        & => a a A b b \
        & => a a a A c b b \
        & => a a a a c c b b
    $,
  )],
  grid.cell(
    table(
      stroke: none,
      columns: (.2fr, .3fr, .5fr),
      align: (left, right, left),
      table.header([Stack], [Input], [Azione]),
      table.hline(start: 0),
      table.vline(end: 1, x: 1, stroke: (paint: gray)),
      table.vline(end: 1, x: 2, stroke: (paint: gray)),
      table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dashed")),
      table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dashed")),
      [_\$_     ], [_aaaaccbb\$_], [_shift_              ],
      [_\$a_    ], [_ aaaccbb\$_], [_shift_              ],
      [_\$aa_   ], [_  aaccbb\$_], [_shift_              ],
      [_\$aaa_  ], [_   accbb\$_], [_shift_              ],
      [_\$aaaa_ ], [_    ccbb\$_], [_shift_              ],
      [_\$aaaac_], [_     cbb\$_], [_reduce_ $A ->$ _ac_],
      [_\$aaaA_ ], [_     cbb\$_], [_shift_              ],
      [_\$aaaAc_], [_      bb\$_], [_reduce_ $A ->$ _aAc_],
      [_\$aaA_  ], [_      bb\$_], [_shift_              ],
      [_\$aaAb_ ], [_       b\$_], [_reduce_ $S ->$ _aAb_],
      [_\$aS_   ], [_       b\$_], [_shift_              ],
      [_\$aSb_  ], [_        \$_], [_reduce_ $S ->$ _aSb_],
      [_\$S_    ], [_        \$_], [_accept_              ],
    ),
  ),
)

#figure(
  table(
    stroke: none,
    columns: (.2fr, .3fr, .5fr),
    align: (left, right, left),
    table.header([Stack], [Input], [Azione]),
    table.hline(start: 0),
    table.vline(end: 1, x: 1, stroke: (paint: gray)),
    table.vline(end: 1, x: 2, stroke: (paint: gray)),
    table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dashed")),
    table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dashed")),

    [_\$_          ], [_*id*\**id*\$_], [_shift_              ],
    [_\$_ *id*     ], [_    \**id*\$_], [_reduce_ $F ->$ *id* ],
    [_\$F_         ], [_    \**id*\$_], [_reduce_ $T -> F$],
    [_\$T_         ], [_    \**id*\$_], [_shift_              ],
    [_\$T \*_      ], [_      *id*\$_], [_shift_              ],
    [_\$T \*_ *id* ], [_          \$_], [_reduce_ $F ->$ *id* ],
    [_\$T \* F_    ], [_          \$_], [_reduce_ $T -> T * F$],
    [_\$T_         ], [_          \$_], [_reduce_ $E -> T$],
    [_\$E_         ], [_          \$_], [_accept_              ],
  ),
  caption: [Tracciamento Shift-Reduce per la stringa $text("id") * text("id")$],
)

#figure(
  table(
    stroke: none,
    columns: (.2fr, .3fr, .5fr),
    align: (left, right, left),
    table.header([Stack], [Input], [Azione]),
    table.hline(start: 0),
    table.vline(end: 1, x: 1, stroke: (paint: gray)),
    table.vline(end: 1, x: 2, stroke: (paint: gray)),
    table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dashed")),
    table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dashed")),

    [_\$_         ], [_*id* + *id*\$_], [_shift_              ],
    [_\$_   *id*  ], [_     + *id*\$_], [_reduce_ $F ->$ *id* ],
    [_\$F_        ], [_     + *id*\$_], [_reduce_ $T -> F$],
    [_\$T_        ], [_     + *id*\$_], [_reduce_ $E -> T$],
    [_\$E_        ], [_     + *id*\$_], [_shift_              ],
    [_\$E + _     ], [_       *id*\$_], [_shift_              ],
    [_\$E + _ *id*], [_           \$_], [_reduce_ $F ->$ *id* ],
    [_\$E + F_    ], [_           \$_], [_reduce_ $T -> F$],
    [_\$E + T_    ], [_           \$_], [_reduce_ $E -> E + T$],
    [_\$E_        ], [_           \$_], [_accept_             ],
  ),
  caption: [Tracciamento Shift-Reduce per la stringa $text("id") + text("id")$],
)

- Quando in cima allo stack c’è la parte destra di una regola, come si fa a sapere se è l’handle e si deve fare la riduzione oppure è necessario fare ancora spostamenti?
- In cima allo stack potrebbero esserci anche le parti destre di due diverse regole: quale si sceglie?


== Parser LR

Il parsing LR($k$) è il metodo di analisi shift-reduce bottom-up più diffuso: la "L" indica la scansione dell'input da sinistra a destra (*Left-to-right*), la "R" indica la costruzione di una derivazione destra in ordine inverso (*Rightmost derivation*), e $k$ rappresenta il numero di simboli di lookahead (se omesso, $k=1$).
I parser LR si basano sull'utilizzo di tabelle. Una grammatica per la quale si può costruire una tabella di parsing (con i metodi che seguiranno) viene detta grammatica LR. Perché una grammatica sia LR è sufficiente che un parser shift-reduce sia in grado di riconoscere gli handle delle forme di frase destre quando compaiono in cima allo stack.

Il parsing LR è importante per le seguenti ragioni:
- È idoneo per riconoscere i costrutti dei linguaggi di programmazione descritti da grammatiche context-free.
- È il metodo più generale di parsing shift-reduce senza backtracking.
- Individua errori sintattici appena possibile.
- La classe delle grammatiche riconosciute da un parser LR è un sovrainsieme proprio di quelle riconosciute dai parser LL.


=== Componenti e configurazione del parser
L'architettura del parser si compone di un buffer di input, un output (le riduzioni effettuate), uno stack esplicito e una tabella di parsing divisa in due sezioni: *ACTION* e *GOTO*.

A differenza di un generico parser shift-reduce, un parser LR memorizza nella pila una sequenza di *stati dell'automa* $s_0 s_1 dots s_m$ (con $s_m$ in cima), dove $s_0$ funge da marcatore di fondo. Da questi stati è sempre possibile risalire implicitamente ai simboli grammaticali associati.
#definition()[
  Una *configurazione* di un parser LR è una coppia che descrive lo stato esatto del sistema ad ogni istante:
  $ (s_0 s_1 dots s_m, a_i a_(i+1) dots a_n \$) $
  dove la prima componente rappresenta il contenuto della pila e la seconda la parte residua dell'input.
]

=== L'Algoritmo di Parsing
La mossa successiva del parser a partire dalla configurazione:
$
  (s_0 s_1 dots s_m, a_i a_(i+1) dots a_n \$)
$
è determinata dal simbolo d'ingresso corrente $a_i$ e dallo stato in cima allo stack $s_m$, consultando il valore della funzione ACTION[$s_m, a_i$]:

+ Se ACTION[$s_m, a_i$] = *shift $s$*, il parser inserisce lo stato $s$ in cima allo stack e avanza nella stringa in ingresso, quindi passa alla configurazione:
  $
    (s_0 s_1 dots s_m s, a_(i+1) dots a_n \$)
  $
+ Se ACTION[$s_m, a_i$] = *reduce $A -> beta$*, il parser esegue i seguenti passi in sequenza:
  1. *Output*: emette la produzione $A -> beta$ (permettendo la ricostruzione della derivazione destra invertita).
  2. *Aggiornamento simboli (se presenti)*: rimuove dallo stack dei simboli la stringa $beta$ e vi inserisce il non-terminale $A$.
  3. *Cambio di configurazione*: determina la lunghezza del corpo della regola $r = |beta|$. Rimuove dallo stack degli stati $r$ elementi, scoprendo il vecchio stato $s_(m-r)$. Consulta la tabella GOTO per calcolare il nuovo stato $s = text("GOTO")[s_(m-r), A]$ e lo inserisce in cima allo stack.

  La configurazione passa quindi da:
  $ (s_0 s_1 dots s_m, a_i a_(i+1) dots a_n \$) arrow.long (s_0 s_1 dots s_(m-r) s, a_i a_(i+1) dots a_n \$) $

  #observation()[
    Si noti che la stringa di input rimanente $(a_i a_(i+1) dots a_n \$)$ rimane del tutto invariata durante la riduzione. Inoltre, nei parser ottimizzati non è necessario mantenere fisicamente lo stack dei simboli, poiché dallo stato corrente si può sempre risalire al simbolo corrispondente.
  ]
+ Se ACTION[$s_m, a_i$] = *accept*, il parsing termina con successo.
+ Se ACTION[$s_m, a_i$] = *error*, è stata rilevata una situazione di errore.

Tutti i parser LR seguono esattamente questo stesso schema generale. L'unica differenza risiede nel modo in cui è costruita la tabella ACTION e GOTO.

#figure(
  image("images/2026-05-17-19-13-42.png", width: 60%),
  caption: [Algoritmo generale di esecuzione di un Parser LR],
)

== L'Automa LR(0)
Per calcolare gli stati da inserire nelle tabelle si ricorre alla *collezione canonica LR(0)*, un insieme di stati in cui ognuno racchiude una serie di *item*. Un item LR(0) non è altro che una produzione della grammatica contenente un punto ($dot.c$) nel corpo per indicare la porzione di regola già analizzata dal parser.

#example()[
  La produzione $A -> X Y Z$ genera quattro item separati:
  - $A -> dot X Y Z$: ci si aspetta di incontrare la stringa generata da $X Y Z$.
  - $A -> X dot Y Z$: è stata riconosciuta la componente $X$, ci si aspetta $Y Z$.
  - $A -> X Y Z dot$: l'intero corpo della regola è stato riconosciuto; l'item è completo ed è candidato ad una riduzione.
]

=== Funzione CLOSURE
Data una grammatica aumentata $G'$ (ottenuta aggiungendo la regola radice $S' -> S$ per gestire l'accettazione), la funzione `CLOSURE(I)` espande un insieme di item $I$ secondo il principio di aspettativa:
+ Inserisci tutti gli item di $I$ in `CLOSURE(I)`.

+ Se $A -> alpha dot B beta$ appartiene a `CLOSURE(I)` e $B -> gamma$ è una produzione in $G$, allora si aggiunge $B -> dot gamma$ a `CLOSURE(I)`, se non è già presente. Si ripete questa regola finché non è più possibile aggiungere nuovi item a `CLOSURE(I)`.

#example()[
  #block(
    $
      & E' && -> && E \
      & E  && -> && E + T     && | T \
      & T  && -> && T " * " F && | F \
      & F  && -> && (E)       && | bold(id)
    $,
  )

  Se $I = {[E' -> dot E]}$, allora `CLOSURE`($I$) contiene anche gli item:
  - $E -> dot E + T$ e $E -> dot T$ perché $dot$ precede _E_ in $E' -> dot E$
  - $T -> dot T * F$ e $T -> dot F space$ perché $dot$ precede _T_ in $E' -> dot T$
  - $F -> dot (E)$ e $F -> dot bold(id) quad$ perché $dot$ precede _E_ in $T' -> dot F$
]

=== Funzione GOTO
La funzione `GOTO(I, X)` definisce lo spostamento del punto in avanti a fronte della lettura di un simbolo $X$ (terminale o non-terminale):
$ text("GOTO")(I, X) = text("CLOSURE")({[A -> alpha X dot beta] | [A -> alpha dot X beta] in I}) $

Viene usata per definire le transizioni dell'automa LR(0). Gli stati dell'automa corrispondono a insiemi di item e GOTO($I$, X) definisce la transizione dallo stato $I$ col simbolo $X$.

#example()[
  Se $I = {[E' -> E dot], [E -> E dot + T ]}$ allora:
  $
    "GOTO"(I, +) & = "CLOSURE"({[E → E + dot T ]}) \
                 & = {[E → E + dot T ], [T → dot T \* F], [T → dot F], [F → dot (E)], [F → dot id] }
  $
]

Applicando iterativamente `CLOSURE` e `GOTO` a partire dall'item iniziale $[S' -> dot S]$, si mappa l'intero grafo degli stati dell'automa:

#figure(
  image("images/2026-05-17-18-22-20.png", width: 60%),
  caption: [Grafo delle transizioni dell'Automa LR(0) risultante],
)

== Costruzione delle tabelle
Una volta ricavata la collezione canonica degli stati $C = \{I_0, I_1, dots, I_n\}$, si può procedere alla compilazione delle tabelle.

=== Il metodo LR(0) puro e i suoi limiti
Le regole di riempimento standard per una tabella LR(0) prevedono che, per ogni stato $I_i$:
- Se $[A -> alpha dot a beta] in I_i$ (con $a$ terminale) e $text("GOTO")(I_i, a) = I_j$, allora `ACTION`[$i, a$] = shift $j$.
- Se $[A -> alpha dot] in I_i$ (item completo), allora `ACTION`[$i, a$] = reduce $A -> alpha$ *per qualsiasi carattere* $a$ dell'alfabeto e per il carattere di fine stringa $\$$.
- Se $[S' -> S dot] in I_i$, allora `ACTION`[$i, \$$] = accept.
- Se $text("GOTO")(I_i, B) = I_j$ (con $B$ non-terminale), allora `GOTO`[$i, B$] = $j$.

#example()[
  È possibile costruire tabelle di parsing a partire dall'automa LR(0). Se la tabella in ogni casella non contiene ambiguità, allora la grammatica è LR(0). Queste però sono di scarsa utilità pratica.
  Nella tabella, "shift j" si abbrevia con "sj", mentre "reduce ($A -> alpha$)" si abbrevia con "ri", dove $i$ è il numero della produzione associata ad $A$, dopo che tutte le regole della grammatica sono state numerate, come nel seguente esempio:
  + $E -> E + T$
  + $E -> T$
  + $T -> T * F$
  + $T -> F$
  + $F -> (E)$
  + $F -> text("id")$

  #figure(image("images/2026-05-17-19-16-54.png", width: 60%))
]

#observation("Il Conflitto Shift/Reduce")[
  Questo approccio soffre di forti limitazioni macroscopiche. Se uno stato contiene contemporaneamente un item incompleto pronto per uno shift (es. $E -> E dot + T$) e un item completo pronto per una riduzione (es. $E -> T dot$), la casella della tabella conterrà due azioni sovrapposte. L'automa non sa se avanzare o ridurre; questo errore strutturale prende il nome di *conflitto shift/reduce*.
]


=== La soluzione SLR(1)
Il metodo SLR risolve molti dei conflitti dell'LR(0) puro applicando un vincolo basato sui contesti semantici dei simboli. Una riduzione $A -> alpha$ ha senso posizionarla in una colonna $a$ *solo e soltanto se* quel simbolo terminale può legittimamente seguire la variabile $A$ all'interno di una frase valida del linguaggio.

La regola di generazione della tabella si modifica esclusivamente nel punto delle riduzioni:
- Se $[A -> alpha dot] in I_i$ (con $A eq.not S'$), si inserisce l'azione "reduce $A -> alpha$" *esclusivamente nelle colonne dei terminali $a$ tali che* $a in text("FOLLOW")(A)$.

Se, applicando la restrizione del `FOLLOW`, tutte le celle della tabella risultano libere da scelte multiple sovrapposte, la grammatica è definita ufficialmente una *grammatica SLR(1)*.

#example()[
  Come prima, numeriamo le regole della grammatica e calcoliamo i FOLLOW:
  + $E -> E + T quad "FOLLOW"(E) = {+, ), \$}$
  + $E -> T$
  + $T -> T * F quad "FOLLOW"(T) = {*, +, ), \$}$
  + $T -> F$
  + $F -> (E) quad "FOLLOW"(F) = {*, +, ), \$}$
  + $F -> text("id")$

  Nella tabella:
  1. $s_i$ significa "shift e impila lo stato $i$";
  2. $r_j$ significa "riduci con la regola numero $j$";
  3. "acc" significa accetta;
  4. Le caselle vuote indicano un errore sintattico.

  #figure(image("images/2026-05-17-19-22-23.png", width: 60%))
  #figure(image("images/2026-05-17-19-22-34.png", width: 60%))
  #figure(image("images/2026-05-17-19-22-44.png", width: 60%))
  #figure(image("images/2026-05-17-19-22-52.png", width: 60%))
]

// === Insiemi di item

// Un parser LR prende le decisioni shift/reduce mantenendo memorizzate informazioni di stato che gli permettono di tenere traccia di dove si trova durante l'analisi. Gli stati rappresentano insiemi di *“item”*. Un *item* LR(0), o più brevemente un item, di una grammatica G è una produzione di G con un punto in una qualche posizione del corpo. Un item indica quale prefisso di una regola abbiamo già analizzato ad un certo punto durante il parsing.

// #example(
//   multiple: true,
// )[
//   Per esempio, la produzione $A -> X Y Z$ ammette quattro item:
//   $
//     & A-> dot X Y Z \
//     & A-> X dot Y Z \
//     & A-> X Y dot Z \
//     & A-> X Y Z dot
//   $
//   - L'item $A-> dot X Y Z$ indica che ci aspettiamo in ingresso una stringa derivabile da $X Y Z$.
//   - L'item $A-> X dot Y Z$ indica che abbiamo appena riconosciuto una stringa derivabile da X e ci aspettiamo in ingresso una stringa derivabile da $Y Z$.
//   - L'item $A-> X Y Z dot$ indica che abbiamo appena riconosciuto una stringa derivabile da $X Y Z$ e che si potrebbe fare una riduzione con questa regola (sostituire $X Y Z$ con $A$).

//   La produzione $A -> epsilon$, invece, genera il solo item $A -> dot$ .
// ]

// #definition()[
//   La *collezione canonica LR(0)* è una collezione di insiemi di item LR(0) che permette di costruire un automa a stati finiti deterministico (incompleto), detto *automa LR(0)*, utilizzabile per prendere le decisioni durante il parsing. Ogni stato dell'automa LR(0) rappresenta un insieme di item della collezione canonica LR(0).
// ]

// Per costruire la collezione canonica LR(0) per una grammatica $G$ (con simbolo iniziale $S$) consideriamo la grammatica aumentata $G'$, ottenuta da $G$ aggiungendo un nuovo simbolo iniziale $S'$ e la regola $S' → S$. Questa serve per l'accettazione che avviene solo quando il parser può effettuare la riduzione con la regola $S' → S$. Introduciamo anche due nuove funzioni: *CLOSURE* e *GOTO*.

// ==== Funzione CLOSURE
// Se $I$ è un insieme di item di G, CLOSURE($I$) è un insieme di item costruito a partire da $I$ seguendo queste regole:
// + Inizialmente CLOSURE($I$) contiene tutti gli item di $I$
// + Se $A -> alpha dot B beta$ appartiene a CLOSURE($I$) e $B -> gamma$ è una produzione in $G$, allora si aggiunge $B -> dot gamma$ a CLOSURE($I$), se non è già presente. Si ripete questa regola finché non è più possibile aggiungere nuovi item a CLOSURE($I$).

// Se $A -> alpha dot B beta$ appartiene a CLOSURE($I$), a un certo punto durante il parsing, ci si aspetta di riconoscere una stringa prodotta da $B beta$. Questa avrà un prefisso derivabile da $B$ applicando una delle regole per $B$. Si aggiungono quindi tutti gli item relativi alle regole per $B$, cioè se $B ->gamma$ è una regola in $G$, aggiungiamo $B -> dot gamma$ a CLOSURE($I$).

// #example()[
//   #block(
//     $
//       & E' && -> && E \
//       & E  && -> && E + T     && | T \
//       & T  && -> && T " * " F && | F \
//       & F  && -> && (E)       && | bold(id)
//     $,
//   )

//   Se $I = {[E' -> dot E]}$, allora `CLOSURE`($I$) contiene anche gli item:
//   - $E -> dot E + T$ e $E -> dot T$ perché $dot$ precede _E_ in $E' -> dot E$
//   - $T -> dot T * F$ e $T -> dot F space$ perché $dot$ precede _T_ in $E' -> dot T$
//   - $F -> dot (E)$ e $F -> dot bold(id) quad$ perché $dot$ precede _E_ in $T' -> dot F$
// ]

// Per calcolare la chiusura di un insieme di item si può definire una funzione:

// #figure(algo(
//   title: [SetOfItems *CLOSURE*],
//   parameters: ([_I_],),
// )[
//   J = I\
//   repeat#i\
//   for ( ogni item $A -> alpha dot B beta$ in J )#i\
//   for ( ogni regola $B -> dot gamma$ in G )#i\
//   aggiungi $B -> dot gamma$ a J;#d#d#d\
//   until nessun nuovo item è aggiunto a J;\
//   return J;
// ])

// ==== Funzione GOTO

// #definition()[
//   GOTO($I, X$), con $I$ insieme di item e $X$ simbolo della grammatica, è definita come chiusura dell'insieme di tutti gli item [$A -> alpha X dot beta$] tali che [$A -> alpha dot X beta$] appartiene ad $I$.
//   $
//     "GOTO("I, X")" = "CLOSURE("{[A -> alpha X dot beta] | [A → alpha dot X beta] in I }")"
//   $
// ]

// Viene usata per definire le transizioni dell'automa LR(0). Gli stati dell'automa corrispondono a insiemi di item e GOTO($I$, X) definisce la transizione dallo stato $I$ col simbolo $X$.

// #example()[
//   Se $I = {[E' -> E dot], [E -> E dot + T ]}$ allora:
//   $
//     "GOTO"(I, +) & = "CLOSURE"({[E → E + dot T ]}) \
//                  & = {[E → E + dot T ], [T → dot T \* F], [T → dot F], [F → dot (E)], [F → dot id] }
//   $
// ]

// Per calcolare la collezione canonica degli insiemi di item LR(0) si può definire una funzione:

// #figure(algo(
//   title: [void *items*],
//   parameters: ($G'$,),
// )[
//   C = `CLOSURE`({[$S' -> dot S$]});\
//   repeat#i\
//   for ( ogni insieme di item $I$ in $C$ )#i\
//   for ( ogni simbolo $X$ in $G$ )#i\
//   if ( `GOTO`($I, X$) non è vuoto e non appartiene a $C$ )#i\
//   aggiungi `GOTO`($I, X$) a $C$;#d#d#d#d\
//   until nessun nuovo insieme di item è aggiunto a $C$;
// ])

// #figure(
//   image("images/2026-05-17-18-22-20.png"),
//   caption: [Automa LR(0) per la grammatica delle espressioni $E->E+T...$],
// )

// === Automa LR(0)
// Il parsing LR semplice o SLR si basa sulla costruzione dell'automa LR(0) a partire da una grammatica.
// - gli stati dell'automa sono gli insiemi di item della collezione canonica, indichiamo con stato $j$ lo stato corrispondente all'insieme di item $I_j$,
// - lo stato iniziale è CLOSURE(${[S' → dot S ]}$) dove $S'$ è il simbolo iniziale della grammatica aumentata,
// - tutti gli stati sono finali,
// - la funzione di transizione è data dalla funzione GOTO.

// L'automa LR(0) fornisce il supporto per le decisioni (Shift o Reduce) durante il parsing. L'algoritmo di analisi utilizza uno schema a colonne:
// + *Stack (Stati):* simula una pila contenente gli stati dell'automa LR(0) attraversati. Lo stato in cima guida le decisioni.
// + *Simboli:* simula una pila parallela contenente i simboli grammaticali (terminali e non-terminali).
// + *Input:* il buffer contenente i token ancora da leggere.
// + *Azione:* la decisione presa (Shift o Reduce).

// Supponiamo che l'automa si trovi nello stato $j$ (in cima allo stack):
// - *Shift:* se dallo stato $j$ c'è una transizione GOTO etichettata con il prossimo simbolo in ingresso $a$, allora si impila il simbolo $a$ *e si impila anche il nuovo stato di destinazione*.
// - *Reduce:* se lo stato $j$ contiene un item "completo" del tipo $A -> X_1 X_2 dots X_n dot$ (il punto è alla fine, indicando che abbiamo letto tutta la maniglia), si effettua una riduzione.
//   - Si estraggono $n$ elementi dalla pila dei simboli e $n$ elementi dalla pila degli stati.
//   - Si guarda il "vecchio" stato $k$ che ora è riemerso in cima alla pila degli stati.
//   - Si consulta l'automa per vedere in quale stato si va partendo da $k$ leggendo il non-terminale $A$, e si impila questo nuovo stato insieme al simbolo $A$.

// #figure(
//   table(
//     stroke: none,
//     columns: (.33fr, .33fr, .33fr, 1fr),
//     align: (left, left, right, left),
//     table.header([Stack], [Simboli], [Input], [Azione]),
//     table.hline(start: 0),
//     table.vline(end: 1, x: 1, stroke: (paint: gray)),
//     table.vline(end: 1, x: 2, stroke: (paint: gray)),
//     table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dashed")),
//     table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dashed")),

//     [0       ], [_\$_          ], [_*id* \* *id* \$_], [_shift_ 5            ],
//     [0 5     ], [_\$ *id*_     ], [_     \* *id* \$_], [_reduce_ $F ->$ *id* ],
//     [0 3     ], [_\$ F_        ], [_     \* *id* \$_], [_reduce_ $T -> F$    ],
//     [0 2     ], [_\$ T_        ], [_     \* *id* \$_], [_shift_ 7            ],
//     [0 2 7   ], [_\$ T \*_     ], [_        *id* \$_], [_shift_ 5            ],
//     [0 2 7 5 ], [_\$ T \* *id*_], [_             \$_], [_reduce_ $F ->$ *id* ],
//     [0 2 7 10], [_\$ T \* F_   ], [_             \$_], [_reduce_ $T -> T * F$],
//     [0 2     ], [_\$ T_        ], [_             \$_], [_reduce_ $E -> T$    ],
//     [0 1     ], [_\$ E_        ], [_             \$_], [_accept_             ],
//   ),
//   caption: [Parsing LR(0) per la stringa $text("id") * text("id")$],
// )

// #figure(
//   table(
//     stroke: none,
//     columns: (.33fr, .33fr, .33fr, 1fr),
//     align: (left, left, right, left),
//     table.header([Stack], [Simboli], [Input], [Azione]),
//     table.hline(start: 0),
//     table.vline(end: 1, x: 1, stroke: (paint: gray)),
//     table.vline(end: 1, x: 2, stroke: (paint: gray)),
//     table.vline(start: 1, x: 1, stroke: (paint: gray, dash: "dashed")),
//     table.vline(start: 1, x: 2, stroke: (paint: gray, dash: "dashed")),

//     [0      ], [_\$_         ], [_*id* + *id*\$_], [_shift_ 5           ],
//     [0 5    ], [_\$ *id*_    ], [_     + *id*\$_], [_reduce_ $F ->$ *id*],
//     [0 3    ], [_\$ F_       ], [_     + *id*\$_], [_reduce_ $T -> F$   ],
//     [0 2    ], [_\$ T_       ], [_     + *id*\$_], [_reduce_ $E -> T$   ],
//     [0 1    ], [_\$ E_       ], [_       *id*\$_], [_shift_ 6           ],
//     [0 1 6  ], [_\$ E +_     ], [_           \$_], [_shift_ 5           ],
//     [0 1 6 5], [_\$ E + *id*_], [_           \$_], [_reduce_ $F ->$ *id*],
//     [0 1 6 3], [_\$ E + F_   ], [_           \$_], [_reduce_ $T -> F$   ],
//     [0 1 6 9], [_\$ E + T_   ], [_           \$_], [_reduce_ $E -> E+ T$],
//     [0 1    ], [_\$ E_       ], [_           \$_], [_accept_            ],
//   ),
//   caption: [Parsing LR(0) per la stringa $text("id") + text("id")$],
// )

// #observation("Il limite dell'automa LR(0)")[
//   Nell'esempio relativo alla stringa $text("id") * text("id")$, nella riga 4 della tabella è stata fatta la scelta _Shift 7_, in accordo con la transizione in ingresso `*`. Tuttavia, lo stato 2 contiene anche l'item completo $E -> T dot$, che suggerirebbe un'azione di _Reduce_.

//   In questo caso specifico, si è fatta la scelta corretta per far terminare l'analisi con successo. Se avesse scelto la riduzione, si sarebbe arrivati a uno stato di errore. L'automa LR(0) "puro", non guardando mai il lookahead (il prossimo simbolo in input), non possiede gli strumenti per risolvere questa ambiguità (nota come *Conflitto Shift/Reduce*). Per questo motivo, si rende necessario un parser più potente, come l'SLR, che utilizza l'insieme FOLLOW per risolvere queste indecisioni.
// ]

// === Algoritmo di parsing LR
// #figure(image("images/2026-05-17-18-52-31.png"))

// Il parser consiste di un input, un output, uno stack, un programma e una tabella composta da due parti: ACTION e GOTO. Il programma è lo stesso per tutti i parser LR, cambia soltanto la tabella.

// Un parser LR legge in input un carattere alla volta e, a differenza di un generico parser shift-reduce, impila *stati* invece di simboli.
// Lo stack mantiene una sequenza di stati $s_0 s_1 dots s_m$ ($s_m$ in cima). Ogni stato è associato ad un simbolo grammaticale.

// === Tabelle di parsing LR(0)
// La tabella di parsing è composta da due parti: una funzione ACTION e una funzione GOTO.

// + La funzione ACTION prende come argomenti uno stato $i$ e un simbolo terminale $a$ (oppure il marcatore di fine input $\$$). Il valore ACTION[$i, a$] può assumere una delle quattro forme:
//   - *Shift $j$*: in cui $j$ è uno stato. L'azione svolta dal parser consiste in effetti nell'impilare il simbolo d'ingresso $a$ sullo stack, benché si utilizzi lo stato $j$ per rappresentare $a$.
//   - *Reduce $A -> beta$*: L'azione ha come effetto la sostituzione di $beta$ sulla cima dello stack con la testa della produzione $A$.
//   - *Accept*: Il parser segnala il corretto riconoscimento della stringa.
//   - *Error*: Il parser rileva un errore nell'ingresso e intraprende un'azione correttiva.
// + Estendiamo la funzione GOTO già definita agli stati: se GOTO[$I_i, A$] = $I_j$, la funzione mappa anche lo stato $i$ e il non-terminale $A$ nello stato $j$.

// ==== Configurazione del parser LR
// Per descrivere il comportamento di un parser descriviamo il suo stato per mezzo dello stack e della parte rimanente della stringa in ingresso.
// #definition()[
//   Una *configurazione* di un parser LR è una coppia:
//   $
//     (s_0 s_1 dots s_m, a_i a_(i+1) dots a_n \$)
//   $
//   in cui la prima componente è il contenuto dello stack (testa a destra) e la seconda la parte di input rimanente.
// ]

// Questa configurazione rappresenta la forma sentenziale destra:
// $
//   X_1 X_2 dots X_m a_i a_(i+1) dots a_n
// $
// dove $X_i$ è il simbolo corrispondente allo stato $s_i$. Lo stato $s_0$ non rappresenta nessun simbolo ma il marcatore di fondo stack.

// ==== Comportamento del parser LR
// La mossa successiva del parser a partire dalla configurazione:
// $
//   (s_0 s_1 dots s_m, a_i a_(i+1) dots a_n \$)
// $
// è determinata dal simbolo d'ingresso corrente $a_i$ e dallo stato in cima allo stack $s_m$, consultando il valore della funzione ACTION[$s_m, a_i$]:

// + Se ACTION[$s_m, a_i$] = *shift $s$*, il parser inserisce lo stato $s$ in cima allo stack e avanza nella stringa in ingresso, quindi passa alla configurazione:
//   $
//     (s_0 s_1 dots s_m s, a_(i+1) dots a_n \$)
//   $
//   #observation()[
//     Non è necessario mettere fisicamente i simboli nello stack, poiché dagli stati si può sempre risalire ai simboli corrispondenti, ma non viceversa.
//   ]
// + Se ACTION[$s_m, a_i$] = *reduce $A -> beta$*, il parser esegue una riduzione passando alla configurazione:
//   $
//     (s_0 s_1 dots s_(m-r) s, a_i a_(i+1) dots a_n \$)
//   $
//   in cui $r = |beta|$ (lunghezza del corpo della regola) e $s = text("GOTO")[s_(m-r), A]$. Il parser rimuove dallo stack $r$ stati, corrispondenti ai simboli $X_(m-r+1) dots X_m$ che costituiscono $beta$, lasciando $s_(m-r)$ in cima allo stack, e quindi inserisce il nuovo stato $s$.
// + Se ACTION[$s_m, a_i$] = *accept*, il parsing termina con successo.
// + Se ACTION[$s_m, a_i$] = *error*, è stata rilevata una situazione di errore.

// Tutti i parser LR seguono esattamente questo stesso schema generale. L'unica differenza risiede nel modo in cui è costruita la tabella ACTION e GOTO.

// #[
//   #set heading(numbering: none, outlined: false)
//   === Algoritmo di parsing LR
// ]
// *INPUT*: Una stringa d'ingresso $w$ e una tabella di parsing LR costituita dalle funzioni ACTION e GOTO relative a una grammatica $G$.\
// *OUTPUT*: Se $w in L(G)$, i passi di riduzione relativi a un parsing bottom-up di $w$, altrimenti una segnalazione di errore.\
// *METODO*: Inizialmente il parser ha lo stato di partenza $s_0$ sullo stack e la sequenza $w\$$ nel buffer di ingresso.
// #figure(image("images/2026-05-17-19-13-42.png"))

// #example()[
//   È possibile costruire tabelle di parsing a partire dall'automa LR(0). Se la tabella in ogni casella non contiene ambiguità, allora la grammatica è LR(0). Queste però sono di scarsa utilità pratica.
//   Nella tabella, "shift j" si abbrevia con "sj", mentre "reduce ($A -> alpha$)" si abbrevia con "ri", dove $i$ è il numero della produzione associata ad $A$, dopo che tutte le regole della grammatica sono state numerate, come nel seguente esempio:
//   + $E -> E + T$
//   + $E -> T$
//   + $T -> T * F$
//   + $T -> F$
//   + $F -> (E)$
//   + $F -> text("id")$

//   #figure(image("images/2026-05-17-19-16-54.png"))
// ]

// ==== Costruzione di una tabella di parsing LR(0)
// Dall'osservazione dell'automa LR(0), la costruzione della tabella tiene conto delle seguenti istruzioni:
// Per ogni stato $I$:
// - Se c'è un item $A -> alpha dot a beta$, con $a$ terminale, allora ACTION[$I, a$] = shift $j$, dove $j = text("GOTO")(I, a)$;
// - Se c'è un item $A -> alpha dot$, allora ACTION[$I, a$] = reduce ($A -> alpha$) *per ogni terminale* $a$ e per $\$$;
// - Se lo stato contiene l'item iniziale $S' -> S dot$, allora ACTION[$I, \$ $] = accept;
// - Per ogni non-terminale $B$, si pone GOTO[$I, B$] = $j$, dove $j = text("GOTO")(I, B)$.


// === Tabella di parsing SLR
// Per eliminare ambiguità (conflitti shift/reduce) come quelle che emergerebbero nella casella ACTION[$2, *$] della tabella precedente costruita con le regole LR(0), si osserva che ha senso applicare una riduzione $A -> alpha$ *solo se* il prossimo simbolo di ingresso appartiene a $"FOLLOW"(A)$.

// Il metodo SLR (Simple LR) per la costruzione di tabelle di parsing è il più semplice e si basa proprio su questa osservazione. Le tabelle ottenute vengono dette tabelle SLR e i parser che le usano parser SLR.

// Si utilizzano gli item LR(0) e l'automa LR(0).
// Data una grammatica $G$:
// - Si considera la grammatica aumentata $G'$ col nuovo simbolo iniziale $S'$.
// - Si costruiscono la collezione canonica $C$ e la funzione GOTO.
// - Si costruiscono gli elementi delle sezioni ACTION e GOTO.
// - È strettamente necessario calcolare e conoscere gli insiemi $"FOLLOW"(A)$ per ogni variabile.

// ==== Costruzione di una tabella di parsing SLR
// *INPUT*: Una grammatica aumentata $G'$.\
// *OUTPUT*: Le funzioni ACTION e GOTO della tabella di parsing SLR relativa alla grammatica aumentata $G'$.\
// *METODO*:

// 1. Si costruisce la collezione $C = {I_0, I_1, dots, I_n}$ degli insiemi di item LR(0) di $G'$.
// 2. Si analizza ogni stato $i$ a partire dall'insieme $I_i$ e si determinano le azioni del parsing per questo stato:
//    - Se $[A -> alpha dot a beta] in I_i$ e $text("GOTO")(I_i, a) = I_j$, si assegna ad ACTION[$i, a$] il valore "shift $j$".
//    - Se $[A -> alpha dot] in I_i$ e $A != S'$, si assegna ad ACTION[$i, a$] il valore "reduce $A -> alpha$" *per ogni* $a in "FOLLOW"(A)$.
//    - Se $[S' -> S dot] in I_i$, si assegna ad ACTION[$i, \$ $] il valore "accept".

//    #observation()[
//      Se l'applicazione delle regole precedenti porta a un conflitto (più di un'azione generata per la stessa casella ACTION[$i, a$]), significa che la grammatica *non* è SLR(1).
//    ]

// 3. Se $text("GOTO")(I_i, A) = I_j$ per un non-terminale $A$, allora si pone GOTO[$i, A$] = $j$.
// 4. A tutte le celle della tabella non definite dalle regole precedenti si assegna il valore "error".
// 5. Lo stato iniziale del parser è quello costruito a partire dall'insieme di item contenente $[S' -> dot S]$.

// La tabella costruita con questo metodo è detta tabella SLR(1) di $G$, il parser che la utilizza è il parser SLR(1) per $G$; una grammatica per cui esiste una tabella SLR(1) priva di conflitti è detta grammatica SLR(1).

// #example()[
//   Come prima, numeriamo le regole della grammatica e calcoliamo i FOLLOW:
//   + $E -> E + T quad "FOLLOW"(E) = {+, ), \$}$
//   + $E -> T$
//   + $T -> T * F quad "FOLLOW"(T) = {*, +, ), \$}$
//   + $T -> F$
//   + $F -> (E) quad "FOLLOW"(F) = {*, +, ), \$}$
//   + $F -> text("id")$

//   Nella tabella:
//   1. $s_i$ significa "shift e impila lo stato $i$";
//   2. $r_j$ significa "riduci con la regola numero $j$";
//   3. "acc" significa accetta;
//   4. Le caselle vuote indicano un errore sintattico.

//   #figure(image("images/2026-05-17-19-22-23.png"))
//   #figure(image("images/2026-05-17-19-22-34.png"))
//   #figure(image("images/2026-05-17-19-22-44.png"))
//   #figure(image("images/2026-05-17-19-22-52.png"))
// ]
