#import "../../../dvd.typ": *
#import "@preview/algo:0.3.6": algo, code, comment, d, i
#import "@preview/fletcher:0.5.8": diagram, edge, node
#pagebreak()

= Traduzione guidata dalla sintassi
L'*idea di base* della traduzione guidata dalla sintassi è quella di *associare informazioni* a un costrutto di un linguaggio aggiungendo *attributi* ai simboli della grammatica che rappresentano tale costrutto. Una definizione guidata dalla sintassi specifica i valori assunti dagli attributi per mezzo di regole semantiche associate alle produzioni.

== Definizioni guidate dalla sintassi
#definition()[Una *definizione guidata dalla sintassi* o *SDD (Syntax-Directed Definition)* è una grammatica *context-free* alla quale vengono aggiunti *attributi* e *regole semantiche*.
  - *Attributi:* sono associati ai simboli della grammatica. Possono essere di qualunque tipo, come numeri, tipi, tabelle, riferimenti o stringhe (frammenti di codice). Dato un simbolo della grammatica $X$ e un suo attributo $a$, la notazione *$X.a$* indica il valore di $a$ per un nodo dell'albero di parsing etichettato con $X$.
  - *Regole semantiche:* sono associate alle produzioni della grammatica e specificano come calcolare il valore degli attributi.
]

La tecnica generale consiste nel costruire un albero di parsing per una stringa di input e poi usare le regole semantiche per calcolare i valori degli attributi in ogni nodo dell'albero. Un albero che mostra anche i valori calcolati degli attributi nei vari nodi è detto *albero di parsing annotato*.


=== Attributi ereditati e sintetizzati
Per i simboli non-terminali ci sono due tipi di attributi:

+ *Attributi sintetizzati* ⬆️: un attributo di una variabile $A$ relativo ad un nodo $N$ dell'albero di parsing è detto sintetizzato se è definito da una regola semantica associata alla produzione relativa al nodo $N$ (quindi una produzione con parte sinistra $A$). Un attributo sintetizzato relativo ad un nodo $N$ è calcolato unicamente in base ai valori degli attributi dei *figli* di $N$ e di $N$ stesso.

+ *Attributi ereditati* ⬇️➡️: un attributo di una variabile $B$ relativo ad un nodo $N$ dell'albero di parsing è detto ereditato se è definito dalla regola semantica associata alla produzione relativa al nodo *padre* di $N$. Tale produzione deve contenere $B$ nella parte destra. Un attributo ereditato relativo ad un nodo $N$ è definito unicamente in base agli attributi del padre di $N$, di $N$ stesso e dei *fratelli* di $N$.

#observation()[
  - Un attributo ereditato (al nodo $N$) *non può mai* dipendere dagli attributi dei figli di $N$ (altrimenti si creerebbe un paradosso circolare di dipendenza).
  - Un attributo sintetizzato (al nodo $N$) *può* dipendere da attributi ereditati dello stesso nodo $N$.
  I simboli terminali:
  - Possono avere solo attributi sintetizzati (es. `text("digit")."lexval"`, che rappresenta il valore intrinseco fornito direttamente dallo scanner lessicale).
  - *Non possono* avere attributi ereditati (essendo foglie dell'albero, non possono ricevere informazioni dall'alto che modifichino la loro natura).
]

#example()[
  #figure(
    table(
      stroke: none,
      columns: (.01fr, .04fr, .45fr, .5fr),
      align: left,
      table.hline(start: 0),
      table.header(
        table.cell([]),
        table.cell([]),
        table.cell([*Produzione*]),
        table.cell([*Regole semantiche*]),
      ),
      table.hline(start: 0),
      [ ], [1)], [$L -> E$ *n*     ], [$L.v a l = E.v a l$],
      [ ], [2)], [$E -> E_1 + T$    ], [$E.v a l = E_1.v a l + T.v a l$],
      [ ], [3)], [$E -> T$          ], [$E.v a l = T.v a l$],
      [ ], [4)], [$T -> T_1 * F$    ], [$T.v a l = T_1.v a l times F.v a l$],
      [ ], [5)], [$T -> F$          ], [$T.v a l = F.v a l$],
      [ ], [6)], [$F ->$ ( _E_ )    ], [$F.v a l = E.v a l$],
      [ ], [7)], [$F ->$ *digit*    ], [$F.v a l = bold("digit").l e x v a l$],
      table.hline(start: 0),
    ),
    caption: "Definizione guidata dalla sintassi di una semplice calcolatrice da tavolo",
  )
  La SDD della figura valuta le espressioni terminate da uno speciale marcatore di fine riga, che indichiamo con $text("n")$. In questa grammatica, ognuno dei non-terminali ha *un unico attributo sintetizzato* chiamato `val`. Supponiamo inoltre che il terminale `digit` abbia un attributo sintetizzato `lexval` (il valore numerico intero restituito dall'analizzatore lessicale).
  - La regola per la produzione 1, $L -> E text("n")$, assegna a $L."val"$ il valore dell'intera espressione $E."val"$.
  - La produzione 2, $E -> E_1 + T$, ha una regola che calcola il valore dell'attributo $E."val"$ nella testa della produzione come somma dei valori associati ai simboli del corpo $E_1$ e $T$. A ogni nodo $N$ con etichetta $E$, il valore è la somma dei valori `val` associati ai nodi figli.
  - La produzione 3, $E -> T$, stabilisce semplicemente che il valore di $E."val"$ è uguale al valore del nodo figlio $T."val"$.
  - La produzione 4 ($T -> T_1 * F$) è analoga alla seconda, ma esegue il prodotto.
  - Le produzioni 5 e 6 copiano i valori associati al nodo figlio verso l'alto.
  - Infine, la produzione 7 assegna a $F."val"$ il valore lessicale intrinseco (`lexval`) associato al token `digit`.
]

=== Valutazione di una SDD ai nodi di un albero di parsing
Per visualizzare il processo di traduzione specificato mediante una SDD è molto utile ricorrere agli alberi di parsing (anche se, nella pratica, un traduttore ottimizzato non necessita della costruzione esplicita dell'albero in memoria). Immaginiamo quindi che le regole di una SDD siano utilizzate prima per costruire la struttura dell'albero di parsing, e poi vengano valutate per calcolare il valore degli attributi in corrispondenza di ogni nodo.

Per poter valutare un attributo di un nodo, dobbiamo *obbligatoriamente* aver prima valutato tutti gli attributi da cui esso dipende.
- Se in una SDD tutti gli attributi sono *sintetizzati*, prima di poter calcolare l'attributo di un nodo padre dobbiamo calcolare gli attributi dei suoi figli. Possiamo quindi procedere tranquillamente dal basso verso l'alto (Bottom-Up), ad esempio effettuando una classica visita dell'albero in *post-ordine*.
- Nel caso di SDD che presentano attributi sia sintetizzati che ereditati, l'ordine di valutazione si complica. Le dipendenze viaggiano sia verso l'alto che verso il basso, e non è sempre possibile garantire a priori l'esistenza di un ordine valido di valutazione.

#example()[
  Si considerino, per esempio, i non-terminali $A$ e $B$ con attributi $A.s$ e $B.i$, rispettivamente sintetizzato ed ereditato, e la produzione con le corrispondenti regole semantiche:
  #figure(grid(
    columns: (15em, 15em),
    align: center,
    [#block(
      $
        & "PRODUZIONE" \
        & quad A -> B
      $,
    )],
    [#block(
      $
        & "REGOLE SEMANTICHE" \
        & quad A.s = B.i; \
        & quad B.i = A.s + 1;
      $,
    )],
  ))
  #figure(diagram(
    node-stroke: 0.9pt,
    cell-size: 5mm,
    spacing: 3mm,
    node((0, 2), $A$, name: <a>),
    node((0, 4), $B$, name: <b>),

    node((2, 2), $A.s$, name: <as>, stroke: none),
    node((2, 4), $B.i$, name: <bi>, stroke: none),

    edge((0, 0), <a>, dash: "dotted"),
    edge(<a>, <b>, dash: "dotted"),
    edge(<b>, (2, 6), (-2, 6), <b>),

    edge(<as>, <bi>, "-|>", bend: 45deg),
    edge(<bi>, <as>, "-|>", bend: 45deg),
  ))
  Queste regole sono circolari. È impossibile valutare l'attributo $A.s$ per il nodo padre senza prima conoscere il valore di $B.i$ del figlio. Ma al tempo stesso, è impossibile calcolare l'attributo ereditato $B.i$ del figlio senza prima conoscere il valore di $A.s$ del padre.
]

#example()[
  Riprendiamo la SDD della calcolatrice e vediamo un albero completamente valutato.
  #align(center, table(
    stroke: none,
    columns: (10em, 15em),
    align: left,
    table.hline(start: 0),
    table.header(
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*]),
    ),
    table.hline(start: 0),
    [$L -> E$ *n*     ], [$L.v a l = E.v a l$],
    [$E -> E_1 + T$    ], [$E.v a l = E_1.v a l + T.v a l$],
    [$E -> T$          ], [$E.v a l = T.v a l$],
    [$T -> T_1 * F$    ], [$T.v a l = T_1.v a l times F.v a l$],
    [$T -> F$          ], [$T.v a l = F.v a l$],
    [$F ->$ ( _E_ )    ], [$F.v a l = E.v a l$],
    [$F ->$ *digit*    ], [$F.v a l = bold("digit").l e x v a l$],
    table.hline(start: 0),
  ))
  #figure(diagram(
    node-stroke: none,
    cell-size: 5mm,
    spacing: 3mm,

    node((2, 0), [_L.val_ $= 19$        ], name: <20>),
    node((2, 1), [_E.val_ $= 19$        ], name: <21>),
    node((3, 1), [*n*                   ], name: <31>),
    node((1, 2), [_E.val_ $= 15$        ], name: <12>),
    node((2, 2), [$+$                   ], name: <22>),
    node((3, 2), [_T.val_ $= 4$         ], name: <32>),
    node((1, 3), [_T.val_ $= 15$        ], name: <13>),
    node((3, 3), [_F.val_ $= 4$         ], name: <33>),
    node((0, 4), [_T.val_ $= 3$         ], name: <04>),
    node((1, 4), [$*$                   ], name: <14>),
    node((2, 4), [_F.val_ $= 5$         ], name: <24>),
    node((3, 4), [*digit*_.lexval_ $= 4$], name: <34>),
    node((0, 5), [_F.val_ $= 3$         ], name: <05>),
    node((2, 5), [*digit*_.lexval_ $= 5$], name: <25>),
    node((0, 6), [*digit*_.lexval_ $= 3$], name: <06>),

    edge(<20>, <21>),
    edge(<20>, <31>),

    edge(<21>, <12>),
    edge(<21>, <22>),
    edge(<21>, <32>),

    edge(<12>, <13>),
    edge(<32>, <33>),

    edge(<13>, <04>),
    edge(<13>, <14>),
    edge(<13>, <24>),
    edge(<33>, <34>),

    edge(<04>, <05>),
    edge(<24>, <25>),

    edge(<05>, <06>),
  ))
  Albero di parsing annotato per la stringa $3 * 5 + 4 n$, costruito utilizzando la grammatica e le regole viste in precedenza. Si suppone che i valori dell'attributo *lexval* siano forniti dall'analizzatore lessicale. Ogni nodo relativo a una variabile ha un attributo *val*, questi sono calcolati in ordine bottom-up.
]

== Ordine di valutazione delle SDD
I *grafi delle dipendenze* sono uno strumento fondamentale per determinare un ordine di valutazione valido per le varie istanze degli attributi in un dato albero di parsing.
Mentre un albero di parsing mostra *quali* sono i valori degli attributi, un grafo delle dipendenze ci indica *come e in che ordine* tali valori devono essere calcolati.

=== Grafi delle dipendenze
Un grafo delle dipendenze rappresenta il flusso di informazioni attraverso gli attributi di un particolare albero di parsing. Un arco diretto da un'istanza di un attributo a un'altra indica che il valore del primo attributo è richiesto per calcolare il valore del secondo. Gli archi esprimono fisicamente i vincoli implicati dalle regole semantiche. Più precisamente:

- Per ogni nodo dell'albero di parsing etichettato con un simbolo $X$, nel grafo delle dipendenze esiste un nodo per ogni attributo di $X$.

- Se una regola semantica associata a una produzione $A -> alpha X beta$ definisce il valore di un attributo sintetizzato $A.b$ in funzione di un attributo $X.c$ (ed eventualmente di altri), cioè $A.b = f(..., X.c,...)$, allora il grafo delle dipendenze contiene un arco orientato da $X.c$ a $A.b$.

- Consideriamo una regola semantica associata ad una regola del tipo $X -> alpha B beta$ oppure $Y -> alpha X beta B gamma$ che definisce un attributo ereditato $B.c$ in funzione di un attributo $X.a$ (ed eventualmente di altri), cioè $B.c = f(..., X.a,...)$, allora il grafo delle dipendenze contiene un arco orientato da $X.a$ a $B.c$.

#example()[
  Si consideri la seguente produzione e la relativa regola semantica:
  $
    E->E_1 + T quad quad quad quad "E.val" = E_1."val" + "T.val"
  $
  Per ogni nodo con etichetta $E$ (testa della regola), l'attributo sintetizzato `"val"` è calcolato utilizzando i valori degli attributi `"val"` corrispondenti ai due figli $E_1$ e $T$. La porzione del grafo delle dipendenze è strettamente Bottom-Up:
  #figure(diagram(
    node-stroke: none,
    cell-size: 5mm,
    spacing: 3mm,

    node((2, 0), [_E_], name: <E>),
    node((0, 2), $E_1$, name: <E1>),
    node((2, 2), $+$, name: <p>),
    node((4, 2), [_T_], name: <T>),
    node((3, 0), [_val_], name: <val1>),
    node((1, 2), [_val_], name: <val2>),
    node((5, 2), [_val_], name: <val3>),

    edge(<E>, <E1>, dash: "dotted"),
    edge(<E>, <p>, dash: "dotted"),
    edge(<E>, <T>, dash: "dotted"),

    edge(<val2>, <val1>, "-|>"),
    edge(<val3>, <val1>, "-|>"),
  ))
]

#example()[
  Un esempio di grafo delle dipendenze più complesso si ottiene analizzando una grammatica a cui è stata rimossa la ricorsione sinistra (introducendo il non-terminale ausiliario $T'$). Per calcolare le espressioni da sinistra verso destra, è obbligatorio usare attributi ereditati (`"inh"`) come accumulatori parziali.
  #align(center)[
    #table(
      stroke: none,
      columns: (10em, 15em),
      align: left,
      table.hline(start: 0),
      table.header(
        table.cell([*Produzione*]),
        table.cell([*Regole semantiche*]),
      ),
      table.hline(start: 0),
      [1) $T -> F T'$    ], [$T'.i n h = F.v a l$],
      [               ], [$T.v a l = T'.s y n$],
      [2) $T' -> *F T'_1$], [$T'_1.i n h = T'.i n h times F.v a l$],
      [               ], [$T'.s y n = T'_1.s y n$],
      [3) $T' -> epsilon$], [$T'.s y n = T'.i n h$],
      [4) $F ->$ *digit* ], [$F.v a l = bold("digit").l e x v a l$],
      table.hline(start: 0),
    )
  ]

  #figure(
    diagram(
      node-stroke: none,
      cell-size: 5mm,
      spacing: 3mm,

      // NODES + EDGES: principali //

      node((3, 0), [_T_], name: <T>),
      node((0, 2), [_F_], name: <F1>),
      node((0, 4), [*digit*], name: <digit1>),
      node((6, 2), [_T'_], name: <T-1>),
      node((3, 4), $*$, name: <ast>),
      node((5, 4), [_F_], name: <F2>),
      node((5, 6), [*digit*], name: <digit2>),
      node((9, 4), [_T'_], name: <T-2>),
      node((9, 6), $epsilon$, name: <eps>),

      edge(<T>, <F1>, dash: "dotted"),
      edge(<T>, <T-1>, dash: "dotted"),
      edge(<F1>, <digit1>, dash: "dotted"),
      edge(<T-1>, <ast>, dash: "dotted"),
      edge(<T-1>, <F2>, dash: "dotted"),
      edge(<T-1>, <T-2>, dash: "dotted"),
      edge(<F2>, <digit2>, dash: "dotted"),
      edge(<T-2>, <eps>, dash: "dotted"),

      // NODES + EDGES: numerici //

      node((3.75, 0), [9], name: <9>),
      node((0.5, 2), [3], name: <3>),
      node((5.5, 2), [5], name: <5>),
      node((6.5, 2), [8], name: <8>),
      node((0.5, 4), [1], name: <1>),
      node((5.5, 4), [4], name: <4>),
      node((8.5, 4), [6], name: <6>),
      node((9.5, 4), [7], name: <7>),
      node((5.5, 6), [2], name: <2>),

      edge(<1>, <3>, "-|>"),
      edge(<3>, <5>, "-|>", bend: 30deg),
      edge(<5>, <6>, "-|>"),
      edge(<2>, <4>, "-|>"),
      edge(<4>, <6>, "-|>", bend: 30deg),
      edge(<6>, <7>, "-|>", bend: -45deg),
      edge(<7>, <8>, "-|>"),
      edge(<8>, <9>, "-|>"),

      node((4.5, 0), [_val_]),
      node((1, 2), [_val_]),
      node((5, 2), [_inh_]),
      node((7.5, 2), [_syn_]),
      node((1.25, 4), [_lexval_]),
      node((6, 4), [_val_]),
      node((8, 4), [_inh_]),
      node((10, 4), [_syn_]),
      node((6.25, 6), [_lexval_]),
    ),
    caption: [L'informazione ("val" di F) viaggia lateralmente per diventare "inh" di T', scende a destra accumulando le moltiplicazioni, passa a "syn" su epsilon, e infine risale fino alla radice ("val" di T).],
  )
]

=== Ordine di valutazione degli attributi
Il grafo delle dipendenze caratterizza ogni possibile ordine di valutazione degli attributi associati ai nodi di un albero di parsing. Se c'è un arco da un nodo attributo $M$ ad un nodo attributo $N$, significa che l'attributo associato a $M$ deve essere valutato *prima* di quello associato a $N$.

#definition()[
  Gli ordinamenti validi per la valutazione sono costituiti da sequenze di nodi $N_1, N_2, dots, N_k$, tali che, se esiste un arco dal nodo $N_i$ al nodo $N_j$ nel grafo delle dipendenze, allora deve necessariamente essere $i < j$. Un ordinamento che rispetta questa proprietà è detto *ordinamento topologico*.
]

Se il grafo contiene un ciclo (una dipendenza circolare), allora *non esiste* alcun ordinamento topologico possibile, e la SDD non può essere valutata per quell'albero. Viceversa, se il grafo non presenta cicli (è un grafo diretto aciclico o DAG), la teoria dei grafi garantisce che esista sempre almeno un ordinamento topologico valido per completare l'analisi semantica.

=== Definizioni S-attribuite
Per poter valutare gli attributi senza blocchi è strettamente necessario che il grafo delle dipendenze di un albero di parsing non contenga cicli. Esistono classi specifiche di SDD per cui è garantito che i grafi delle dipendenze non conterranno *mai* cicli, indipendentemente dall'albero di parsing generato.

#definition()[
  Una SDD che contiene solo attributi sintetizzati è detta *S-attribuita* (come l'esempio precedente). In una SDD S-attribuita ogni regola calcola un attributo associato alla variabile della parte *sinistra* della produzione a partire dagli attributi associati ai simboli della parte *destra*.
]

In questo caso non ci sono sicuramente cicli nei grafi delle dipendenze. Per una SDD S-attribuita si possono valutare gli attributi secondo un qualsiasi ordinamento bottom-up dei nodi dell'albero di parsing, ad esempio visitando l'albero in postordine e valutando gli attributi associati ad un nodo quando questo viene visitato (quando viene lasciato per l'ultima volta). Ovvero si applica la seguente funzione a partire dalla radice dell'albero di parsing:
```c
postorder(N) {
  for ( ogni figlio C di N, da sinistra a destra )
    postorder(C);
  valuta gli attributi associati al nodo N;
}
```

Le definizioni S-attribuite sono estremamente efficienti perché possono essere implementate "al volo" durante il parsing bottom-up. Una visita in post-ordine, infatti, corrisponde esattamente all'ordine cronologico in cui un parser LR effettua le operazioni di _Reduce_ (la riduzione della maniglia / parte destra alla variabile della parte sinistra).

=== Definizioni L-attribuite

#definition()[
  Una SDD è detta *L-attribuita* se tra gli attributi associati al corpo di una produzione possono esistere archi del grafo delle dipendenze orientati solo da sinistra verso destra e non viceversa.
]

Più precisamente, in una SDD L-attribuita, ogni attributo può essere:
+ *Sintetizzato*, oppure
+ *Ereditato*, purché rispetti le regole seguenti:\
  Se $A -> X_1 X_2 dots X_n$ è una produzione a cui è associata una regola semantica che calcola il valore di un attributo ereditato $X_i.a$, allora tale regola può utilizzare *soltanto*:
  - Attributi ereditati associati alla parte sinistra $A$ (informazioni provenienti dall'alto);
  - Attributi ereditati e sintetizzati associati alle occorrenze dei simboli $X_1, X_2, dots, X_(i-1)$ che compaiono rigorosamente *a sinistra* di $X_i$ nel corpo della regola;
  - Attributi ereditati e sintetizzati associati alla stessa occorrenza di $X_i$ in esame, purché non generino cicli di dipendenza.

#example()[
  La seguente SDD (che rimuove la ricorsione sinistra) è perfettamente L-attribuita:
  #table(
    stroke: none,
    columns: (10em, 15em),
    align: left,
    table.hline(start: 0),
    table.header(
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*]),
    ),
    table.hline(start: 0),
    [1) $T -> F T'$    ], [$T'.i n h = F.v a l$],
    [               ], [$T.v a l = T'.s y n$],
    [2) $T' -> *F T'_1$], [$T'_1.i n h = T'.i n h times F.v a l$],
    [               ], [$T'.s y n = T'_1.s y n$],
    [3) $T' -> epsilon$], [$T'.s y n = T'.i n h$],
    [4) $F ->$ *digit* ], [$F.v a l = bold("digit").l e x v a l$],
    table.hline(start: 0),
  )
  - La prima regola definisce l'attributo ereditato $T'."inh"$ usando solo l'attributo sintetizzato $F."val"$. Poiché il simbolo $F$ si trova *a sinistra* di $T'$ nel corpo della regola ($T -> F T'$), la condizione è soddisfatta.
  - La seconda regola definisce l'attributo ereditato $T'_1."inh"$ utilizzando l'attributo ereditato della testa $T'."inh"$ (lecito, viene dall'alto) e l'attributo $F."val"$, associato al simbolo $F$ che compare *a sinistra* di $T'_1$ nella parte destra della regola.
  In entrambi i casi le regole utilizzano informazioni provenienti da sopra o da sinistra, come richiesto dalle definizioni L-attribuite. Gli altri attributi sono sintetizzati quindi questa SDD è L-attribuita.
]

=== Regole semantiche con effetti collaterali controllati

Ogni traduzione reale comporta spesso effetti collaterali, ad esempio la stampa di un risultato (come in una calcolatrice) o l'aggiunta di informazioni nella tavola dei simboli (come in un compilatore). Le grammatiche ad attributi "pure" non hanno alcun effetto collaterale e gli attributi possono essere valutati secondo qualunque ordinamento topologico che rispetti il grafo delle dipendenze. Gli schemi di traduzione, invece, impongono una valutazione rigorosa da sinistra verso destra e consentono azioni semantiche costituite da reali porzioni di codice imperativo. Nelle SDD si possono controllare gli effetti collaterali in due modi:

+ *Permettere effetti collaterali incidentali:* non pongono vincoli rigorosi sulla valutazione degli attributi; qualsiasi ordine di valutazione coerente col grafo delle dipendenze produce una traduzione corretta.

#example()[
  Nella SDD per le espressioni (calcolatrice) possiamo sostituire la regola semantica $L."val" = E."val"$ associata alla produzione $L -> E text("n")$ con l'azione $"print"(E."val")$ in modo che venga stampato il risultato a schermo. La SDD modificata produce la stessa traduzione seguendo un qualsiasi ordine topologico, perché l'istruzione di stampa è eseguita sempre e comunque per ultima, dopo aver calcolato in modo puro il valore di $E."val"$. Regole semantiche di questo tipo equivalgono logicamente alla definizione di attributi sintetizzati fittizi associati alla parte sinistra della produzione.
]

+ *Vincolare gli ordini di valutazione:* si impongono vincoli rigidi in modo che la traduzione per ogni ordinamento sia comunque corretta e sequenziale. I vincoli possono essere visti come "archi impliciti" aggiunti al grafo delle dipendenze.

#example()[
  #table(
    stroke: none,
    columns: (10em, 15em),
    align: left,
    table.hline(start: 0),
    table.header(
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*]),
    ),
    table.hline(start: 0),
    [1) $D -> T L$      ], [_L.inh_ = _T.type_],
    [2) $T ->$ *int*    ], [_T.type_ = integer],
    [3) $T ->$ *float*  ], [_T.type_ = float],
    [4) $F -> L_1,$ *id*], [$L_1$_.type_ = _L.inh_],
    [                   ], [_addType_(*id*_.id_entry, L.inh_)],
    [5) $L ->$ *id*     ], [_addType_(*id*_.id_entry, L.inh_)],
    table.hline(start: 0),
  )

  Questa SDD rappresenta una dichiarazione $D$ costituita da un tipo base $T$ (che può essere `int` o `float`) seguito da una lista di identificatori $L$. Per ogni identificatore, il tipo viene aggiunto al corrispondente elemento della tavola dei simboli.
  - La variabile $T$ ha un attributo sintetizzato $T."type"$ che può assumere i valori `integer` o `float` e che rappresenta il tipo della dichiarazione.
  - $L$ ha un attributo ereditato $L."inh"$ che serve per far "scivolare" il tipo dichiarato attraverso tutta la lista di identificatori.
  - Nella produzione 1, il valore di $T."type"$ passa a $L."inh"$.
  - Nella produzione 4, il valore di $L."inh"$ viene passato da un nodo padre al nodo figlio $L_1$, verso il basso.

  Le produzioni 4 e 5 richiamano la funzione $"addType"()$ con due argomenti:
  - $text("id")."entry"$: valore lessicale, che agisce da puntatore alla riga corretta nella tavola dei simboli.
  - $L."inh"$: attributo ereditato che indica il tipo da assegnare agli identificatori della lista.

  #figure(
    diagram(
      node-stroke: none,
      cell-size: 5mm,
      spacing: 3mm,

      node((0, 0), [_D_], name: <d>),
      node((-3, 2), [_T_], name: <t>),
      node((3, 2), [_L_], name: <l1>),
      node((0, 4), [_L_], name: <l2>),
      node((3, 4), [*,*], name: <c1>),
      node((6, 4), $bold(id)_3$, name: <id1>),
      node((-3, 6), [_L_], name: <l3>),
      node((0, 6), [*,*], name: <c2>),
      node((3, 6), $bold(id)_2$, name: <id2>),
      node((-3, 4), [*float*], name: <float>),
      node((-3, 8), $bold(id)_1$, name: <id3>),

      edge(<d>, <t>, dash: "dotted"),
      edge(<d>, <l1>, dash: "dotted"),
      edge(<t>, <float>, dash: "dotted"),
      edge(<l1>, <l2>, dash: "dotted"),
      edge(<l1>, <c1>, dash: "dotted"),
      edge(<l1>, <id1>, dash: "dotted"),
      edge(<l2>, <l3>, dash: "dotted"),
      edge(<l2>, <c2>, dash: "dotted"),
      edge(<l2>, <id2>, dash: "dotted"),
      edge(<l3>, <id3>, dash: "dotted"),

      node((-2.25, 2), $4$, name: <4>),
      node((2.25, 2), $5$, name: <5>),
      node((3.75, 2), $6$, name: <6>),
      node((-0.75, 4), $7$, name: <7>),
      node((0.75, 4), $8$, name: <8>),
      node((6.75, 4), $3$, name: <3>),
      node((-3.75, 6), $9$, name: <9>),
      node((-2.25, 6), $10$, name: <10>),
      node((3.75, 6), $2$, name: <2>),
      node((-2.25, 8), $1$, name: <1>),

      node((-1.50, 2), [_type_]),
      node((1.50, 2), [_inh_]),
      node((4.65, 2), [_entry_]),
      node((-1.50, 4), [_inh_]),
      node((1.50, 4), [_entry_]),
      node((7.50, 4), [_entry_]),
      node((-4.50, 6), [_inh_]),
      node((-1.50, 6), [_entry_]),
      node((4.50, 6), [_entry_]),
      node((-1.50, 8), [_entry_]),

      edge(<4>, <5>, "-|>", bend: 30deg),
      edge(<5>, <6>, "-|>", bend: -45deg),
      edge(<5>, <7>, "-|>"),
      edge(<3>, <6>, "-|>"),
      edge(<7>, <8>, "-|>", bend: -45deg),
      edge(<7>, <9>, "-|>"),
      edge(<2>, <8>, "-|>"),
      edge(<9>, <10>, "-|>", bend: -45deg),
      edge(<1>, <10>, "-|>"),
    ),
    caption: "Grafo delle deipendenze per float " + $i d_1, i d_2, i d_3$,
  )

  6, 8 e 10: attributi fittizi utilizzati per rappresentare le chiamate alla
  funzione addType().
]

== Applicazioni della traduzione guidata dalla sintassi
Poiché molti compilatori usano gli alberi sintattici come rappresentazione intermedia del codice, una forma comune di SDD ha come unico scopo quello di trasformare la stringa d'ingresso in un albero. Per completare la traduzione in codice intermedio (o direttamente in linguaggio macchina), il compilatore visiterà poi questo albero seguendo un nuovo insieme di regole che, di fatto, costituiscono una seconda SDD associata all'albero sintattico anziché all'albero di parsing.

=== Costruzione degli alberi sintattici
È estremamente utile trasformare una stringa in ingresso in un albero che ne rappresenti la struttura logica pura e che possa essere utilizzato come rappresentazione primaria per la fase di traduzione. Questo albero viene detto *Albero Sintattico* (o *Abstract Syntax Tree*, AST) ed è profondamente diverso dall'albero di parsing, che invece rappresenta in modo rigido la derivazione di una stringa con una particolare grammatica.

#figure(
  grid(
    columns: (.3fr, .35fr, .35fr),
    [#diagram(
      node-stroke: 0.9pt,
      node-shape: circle,
      cell-size: 5mm,
      spacing: 3mm,

      node((1, 0), $+$, name: <P>),
      node((0, 1), $a$, name: <a>),
      node((2, 1), $*$, name: <A>),
      node((1, 2), $b$, name: <b>),
      node((3, 2), $c$, name: <c>),

      edge(<P>, <a>, "-|>"),
      edge(<P>, <A>, "-|>"),
      edge(<A>, <b>, "-|>"),
      edge(<A>, <c>, "-|>"),
    )],
    [#diagram(
      node-stroke: none,
      cell-size: 5mm,
      spacing: 3mm,

      node((1, 0), $E$, name: <l01>),
      node((0, 1), $E$, name: <l10>),
      node((1, 1), $+$, name: <l11>),
      node((2, 1), $E$, name: <l12>),
      node((0, 2), $a$, name: <l20>),
      node((1, 2), $E$, name: <l21>),
      node((2, 2), $*$, name: <l22>),
      node((3, 2), $E$, name: <l23>),
      node((1, 3), $b$, name: <l31>),
      node((3, 3), $c$, name: <l33>),

      edge(<l01>, <l10>),
      edge(<l01>, <l11>),
      edge(<l01>, <l12>),
      edge(<l10>, <l20>),
      edge(<l12>, <l21>),
      edge(<l12>, <l22>),
      edge(<l12>, <l23>),
      edge(<l21>, <l31>),
      edge(<l23>, <l33>),
    )],
    [#diagram(
      node-stroke: none,
      cell-size: 5mm,
      spacing: 3mm,

      node((1, 0), $E$, name: <l01>),
      node((0, 1), $E$, name: <l10>),
      node((1, 1), $+$, name: <l11>),
      node((2, 1), $T$, name: <l12>),
      node((0, 2), $T$, name: <l20>),
      node((1, 2), $T$, name: <l21>),
      node((2, 2), $*$, name: <l22>),
      node((3, 2), $F$, name: <l23>),
      node((0, 3), $F$, name: <l30>),
      node((1, 3), $F$, name: <l31>),
      node((3, 3), $c$, name: <l33>),
      node((0, 4), $a$, name: <l40>),
      node((1, 4), $b$, name: <l41>),

      edge(<l01>, <l10>),
      edge(<l01>, <l11>),
      edge(<l01>, <l12>),
      edge(<l10>, <l20>),
      edge(<l12>, <l21>),
      edge(<l12>, <l22>),
      edge(<l12>, <l23>),
      edge(<l20>, <l30>),
      edge(<l21>, <l31>),
      edge(<l23>, <l33>),
      edge(<l30>, <l40>),
      edge(<l31>, <l41>),
    )],
  ),
  caption: "Albero sintattico a sx e alberi d parsing a dx",
)

Ogni nodo di un albero sintattico rappresenta un costrutto logico e i figli di tale nodo rappresentano le parti significative che lo compongono. Un nodo che rappresenta un'espressione del tipo $E_1 + E_2$ ha come etichetta il simbolo logico dell'operatore `$+$` e come figli due nodi che rappresentano le sotto-espressioni $E_1$ e $E_2$.
Ogni oggetto ha un campo `op` che costituisce l'etichetta del nodo.
- Se il nodo è una foglia, ha un campo aggiuntivo che contiene il valore lessicale associato. Viene creato con un costruttore del tipo `Leaf(op, val)`.
- Un nodo interno ha tanti campi aggiuntivi quanti sono i nodi figli nell'albero sintattico. Viene creato con un costruttore `Node(op, c1, c2, ..., ck)`.

#example()[
  Consideriamo una grammatica per le espressioni con $+$ e $-$.
  #figure(
    table(
      stroke: none,
      columns: (.01fr, .04fr, .25fr, .7fr),
      align: left,
      table.hline(start: 0),
      table.header(
        table.cell([]),
        table.cell([]),
        table.cell([*Produzione*]),
        table.cell([*Regole semantiche*]),
      ),
      table.hline(start: 0),
      [ ], [1)], [$E -> E_1 + T$   ], [_E.node_ = *new*_ Node_('$+$', $E_1.$_node, T.node_)],
      [ ], [2)], [$E -> E_1 - T$    ], [_E.node_ = *new*_ Node_('$-$', $E_1.$_node, T.node_)],
      [ ], [3)], [$E -> T$          ], [_E.node_ = _T.node_],
      [ ], [4)], [$T -> (E)$        ], [_T.node_ = _E.node_],
      [ ], [5)], [$T ->$ *id*       ], [_T.node_ = *new* _Leaf_(*id*, *id*._entry_)],
      [ ], [6)], [$T ->$ *num*    ], [_T.node_ = *new* _Leaf_(*num*, *num*._val_)],
      table.hline(start: 0),
    ),
  )
  Ogni volta che il parser usa la produzione $E -> E_1 + T$, la regola semantica crea un nuovo nodo `Node` in memoria con etichetta `+` che punta ai nodi figli precedentemente calcolati $E_1."node"$ e $T."node"$.
  Nota bene: le regole associate a $E -> T$ e $T -> ( E )$ *non* creano nessun nuovo nodo. Esse si limitano a "passare il puntatore" ($E."node" = T."node"$), evitando di riempire la memoria con nodi intermedi inutili (cosa che l'albero di parsing invece farebbe). Questo è il motivo principale per cui l'AST è molto più compatto e pulito!

  #figure(
    diagram(
      node-stroke: none,
      cell-size: 0mm,
      spacing: 2mm,

      node((5, 0), [_E.node_], name: <l50>),

      node((2, 1), [_E.node_], name: <l21>),
      node((5, 1), [$+$], name: <l51>),
      node((8, 1), [_T.node_], name: <l81>),

      node((1, 2), [_E.node_], name: <l12>),
      node((2, 2), [$-$], name: <l22>),
      node((4, 2), [_T.node_], name: <l42>),
      node((8, 2), [*id*], name: <l82>),

      node((1, 3), [_T.node_], name: <l13>),
      node((4, 3), [*num*], name: <l43>),

      node((1, 4), [*id*], name: <l14>),
      node((4, 4), [$" "+$], name: <l44>),
      node((5, 4), [], name: <l54>),
      node((6, 4), [$"      "$], name: <l64>),
      node(enclose: (<l44>, <l54>, <l64>), stroke: 0.5pt, inset: 1.5pt, name: <group1>),

      node((2, 8), [$-$], name: <l25>),
      node((3, 8), [], name: <l35>),
      node((4, 8), [$"   "$], name: <l45>),
      node(enclose: (<l25>, <l35>, <l45>), stroke: 0.5pt, inset: 1.5pt, name: <group2>),
      node((8, 8), [*id*], name: <l85>),
      node((9, 8), [$"  "$], name: <l95>),
      node(enclose: (<l85>, <l95>), stroke: 0.5pt, inset: 1.5pt, name: <group3>),

      node((8.5, 10), [$"all'elemento per "c$], name: <elC>),

      node((0, 12), [*id*], name: <l06>),
      node((1, 12), [$"  "$], name: <l16>),
      node(enclose: (<l06>, <l16>), stroke: 0.5pt, inset: 1.5pt, name: <group4>),
      node((6, 12), [*num*], name: <l66>),
      node((7, 12), [$4" "$], name: <l76>),
      node(enclose: (<l66>, <l76>), stroke: 0.5pt, inset: 1.5pt, name: <group5>),

      node((0.5, 14), [$"all'elemento per "a$], name: <elA>),

      // GROUP SEPARATORS //
      edge((4.5, 3.55), (4.5, 4.8), dash: "dashed", stroke: gray, snap-to: none),
      edge((5.5, 3.55), (5.5, 4.8), dash: "dashed", stroke: gray, snap-to: none),
      edge((2.5, 7.3), (2.5, 8.7), dash: "dashed", stroke: gray, snap-to: none),
      edge((3.5, 7.3), (3.5, 8.7), dash: "dashed", stroke: gray, snap-to: none),
      edge((8.5, 7.3), (8.5, 8.7), dash: "dashed", stroke: gray, snap-to: none),
      edge((0.5, 11.3), (0.5, 12.7), dash: "dashed", stroke: gray, snap-to: none),
      edge((6.5, 11.3), (6.5, 12.7), dash: "dashed", stroke: gray, snap-to: none),

      // EDGE a puntini //
      edge(<l50>, <l21>, dash: "dotted"),
      edge(<l50>, <l51>, dash: "dotted"),
      edge(<l50>, <l81>, dash: "dotted"),

      edge(<l21>, <l12>, dash: "dotted"),
      edge(<l21>, <l22>, dash: "dotted"),
      edge(<l21>, <l42>, dash: "dotted"),

      edge(<l12>, <l13>, dash: "dotted"),
      edge(<l13>, <l14>, dash: "dotted"),

      edge(<l42>, <l43>, dash: "dotted"),

      edge(<l81>, <l82>, dash: "dotted"),

      // EDGES trattegiati //
      edge(<l50>, <l64>, dash: "dashed", "-|>", bend: 15deg),
      edge(<l21>, <l25.north>, dash: "dashed", "-|>", bend: -30deg),
      edge(<l81>, <l95>, dash: "dashed", "-|>", bend: 30deg),
      edge(<l21>, <l12>),
      edge(<l12>, <group4.north-west>, dash: "dashed", "-|>", bend: -30deg),
      edge(<l13>, <l06>, dash: "dashed", "-|>", bend: -25deg),
      // Loopty loop
      edge(<l42>, (4.0, 6), dash: "dashed", bend: -94deg),
      edge((4.0, 6), (5.5, 6), dash: "dashed", bend: 15deg),
      edge((5.5, 6), <l76>, dash: "dashed", "-|>", bend: 35deg),

      // EDGES normali //
      edge(<l54>, <group2.north>, "-|>"),
      edge(<l64.center>, <group3.north>, "-|>"),
      edge(<l35>, <group4.north>, "-|>"),
      edge(<l45.center>, <group5.north>, "-|>"),
      edge(<l16.west>, (0.8, 14), "-|>"),
      edge(<l95.west>, (8.8, 10), "-|>"),
    ),
    caption: "Albero sintattico per a - 4 + c",
  )

  Se queste regole vengono valutate durante un parsing Bottom-Up (o tramite una visita in post-ordine dell'albero di parsing) per la stringa `a - 4 + c`, si genererà la seguente sequenza di allocazioni in memoria:

  ```c
  p1 = new Leaf(id, entry-a);
  p2 = new Leaf(num, 4);
  p3 = new Node('-', p1, p2);
  p4 = new Leaf(id, entry-c);
  p5 = new Node('+', p3, p4);
  ```
  Alla fine del processo, `p5` è il puntatore alla radice dell'intero Albero Sintattico.

]

#example()[
  SDD L-attribuita per espressioni con + e - per la stringa a - 4 + c.
  #figure(
    table(
      stroke: none,
      columns: (.01fr, .04fr, .25fr, .7fr),
      align: left,
      table.hline(start: 0),
      table.header(
        table.cell([]),
        table.cell([]),
        table.cell([*Produzione*]),
        table.cell([*Regole semantiche*]),
      ),
      table.hline(start: 0),
      [ ], [1)], [$E -> T E'$   ], [_E.node_     = _$E'$.syn_                          ],
      [ ], [  ], [$$            ], [_$E'$.inh_   = _T.node_                            ],
      [ ], [2)], [$E'-> +T E'_1$], [_$E'_1$.inh_ = *new* _Node($'+'$, E\'.inh, T.node)_],
      [ ], [  ], [$$            ], [_E\'.syn_    = _$E'_1$.syn_                        ],
      [ ], [3)], [$E -> -T E'_1$], [_$E'_1$.inh_ = *new* _Node($'-'$, E\'.inh, T.node)_],
      [ ], [  ], [$$            ], [_E\'.syn_    = _$E'_1$.syn_                        ],
      [ ], [4)], [$E'-> epsilon$], [_E'.syn_     = _E'.inh_                            ],
      [ ], [5)], [$T -> (E)$    ], [_T.node_     = _E.node_                            ],
      [ ], [6)], [$T ->$ *id*   ], [_T.node_     = *new* _Leaf_(*id*, *id*._entry_)    ],
      [ ], [7)], [$T ->$ *num*  ], [_T.node_     = *new* _Leaf_(*num*, *num*._val_)    ],
      table.hline(start: 0),
    ),
  )
  Questa grammatica L-attribuita produce esattamente lo stesso identico Albero Sintattico in memoria dell'esempio precedente, pur partendo da un albero di parsing completamente diverso!

  L'attributo ereditato $E'$.inh rappresenta la porzione di albero sintattico costruita fino ad un certo punto, cioè la radice del sottoalbero corrispondente al prefisso della stringa d'ingresso relativa alla porzione di albero che si trova a sinistra di $E'$. Al nodo 5 del grafo delle dipendenze $E'$.inh rappresenta la radice del sottoalbero sintattico corrispondente all'identificatore $a$. Al nodo 6 $E'$.inh indica la radice del sottoalbero sintattico corrispondente alla stringa $a - 4$. Al nodo 9 $E'$.inh rappresenta l'albero sintattico corrispondente alla stringa $a - 4 + c$. Poiché la stringa in ingresso è terminata, $E'$.inh al nodo 9 punta alla radice dell'intero albero sintattico. L'attributo syn propaga tale valore fino all'attributo $E$.node.

  #figure(
    diagram(
      node-stroke: none,
      cell-size: 5mm,
      spacing: 3mm,

      node((3.00, 0), $E$, name: <E0>),
      node((3.50, 0), $13$, name: <N01>),
      node((4.25, 0), [_node_], name: <S01>),

      node((0.00, 2.00), $T$, name: <T1>),
      node((0.50, 2.00), $2$, name: <N11>),
      node((1.25, 2.00), [_node_], name: <S11>),
      node((4.50, 2.15), [_inh_], name: <S12>),
      node((5.00, 2.00), $5$, name: <N12>),
      node((5.75, 2.00), $E'$, name: <E1>),
      node((6.50, 2.00), $12$, name: <N13>),
      node((7.00, 1.85), [_syn_], name: <S13>),

      node((0.00, 4.00), [*id*], name: <S21>),
      node((0.50, 4.00), $1$, name: <N21>),
      node((1.25, 4.00), [_entry_], name: <S22>),
      node((3.25, 4.00), $-$, name: <S23>),
      node((4.25, 4.00), $T$, name: <T2>),
      node((5.00, 4.00), $4$, name: <N22>),
      node((5.75, 4.00), [_node_], name: <S24>),
      node((7.50, 4.15), [_inh_], name: <S25>),
      node((8.00, 4.00), $6$, name: <N23>),
      node((8.75, 4.00), $E'$, name: <E2>),
      node((9.50, 4.00), $11$, name: <N24>),
      node((10.0, 3.85), [_syn_], name: <S26>),

      node((4.250, 6.00), [*num*], name: <S31>),
      node((5.000, 6.00), $3$, name: <N31>),
      node((5.750, 6.00), [_val_], name: <S32>),
      node((6.750, 6.00), $+$, name: <S33>),
      node((7.500, 6.00), $T$, name: <T3>),
      node((8.000, 6.00), $8$, name: <N32>),
      node((8.750, 6.00), [_node_], name: <S34>),
      node((10.50, 6.15), [_inh_], name: <S35>),
      node((11.00, 6.00), $9$, name: <N33>),
      node((11.75, 6.00), $E'$, name: <E3>),
      node((12.50, 6.00), $10$, name: <N34>),
      node((13.00, 5.85), [_syn_], name: <S36>),

      node((7.500, 8), [*id*], name: <S41>),
      node((8.000, 8), $7$, name: <N41>),
      node((8.750, 8), [_entry_], name: <S42>),
      node((11.75, 8), $epsilon$, name: <S43>),

      // EDGES puntini //
      edge(<E0>, <T1>, dash: "loosely-dotted"),
      edge(<E0>, <E1>, dash: "loosely-dotted"),

      edge(<T1>, <S21>, dash: "loosely-dotted"),
      edge(<E1>, <S23>, dash: "loosely-dotted"),
      edge(<E1>, <T2>, dash: "loosely-dotted"),
      edge(<E1>, <E2>, dash: "loosely-dotted"),

      edge(<T2>, <S31>, dash: "loosely-dotted"),
      edge(<E2>, <S33>, dash: "loosely-dotted"),
      edge(<E2>, <T3>, dash: "loosely-dotted"),
      edge(<E2>, <E3>, dash: "loosely-dotted"),

      edge(<T3>, <S41>, dash: "loosely-dotted"),
      edge(<E3>, <S43>, dash: "loosely-dotted"),

      // EDGES freccie //
      edge(<N21>, <N11>, "-|>"),
      edge(<N11>, <N12>, "-|>", bend: 30deg),

      edge(<N12>, <N23>, "-|>"),
      edge(<N31>, <N22>, "-|>"),
      edge(<N22>, <N23>, bend: 30deg),

      edge(<N23>, <N33>, "-|>"),
      edge(<N41>, <N32>, "-|>"),
      edge(<N32>, <N33>, bend: 30deg),

      edge(<N33>, <N34>, "-|>", bend: -30deg),

      edge(<N34>, <N24>, "-|>"),
      edge(<N24>, <N13>, "-|>"),
      edge(<N13>, <N01>, "-|>"),
    ),
    caption: "Grafo delle dipendenze per a - 4 + c",
  )
]


== Schemi di traduzione guidati dalla sintassi
Gli schemi di traduzione guidati dalla sintassi sono una notazione operativa e complementare alle definizioni guidate dalla sintassi (SDD). Mentre una SDD si concentra sul *cosa* calcolare, uno SDT si concentra sul *quando* eseguirlo.

#definition()[
  Uno *schema di traduzione guidato dalla sintassi* o *SDT* (Syntax-Directed Translation scheme) è una grammatica libera dal contesto avente frammenti di programma integrati direttamente all'interno del corpo delle produzioni. Tali porzioni di programma sono dette *azioni semantiche* e possono apparire in una qualsiasi posizione nel corpo di una produzione.
]
Per convenzione notazionale, le azioni semantiche sono racchiuse tra parentesi graffe `{ ... }`; qualora le parentesi graffe fossero simboli terminali appartenenti alla grammatica in esame, le si rappresenterebbero tra apici o virgolette (es. `'{'`). Qualsiasi schema di traduzione SDT può essere concettualmente realizzato costruendo in primo luogo un albero di parsing, e procedendo poi all'esecuzione delle azioni in profondità da sinistra a destra (*depth-first*), ovvero durante una classica visita in pre-ordine.

Nella pratica, si cerca di evitare la costruzione dell'intero albero in memoria, eseguendo le azioni "al volo" durante l'analisi sintattica. Consideriamo gli SDT necessari per realizzare le classi di SDD per cui:
+ La grammatica sottostante può essere riconosciuta da un parser LR (Bottom-Up) e la SDD è S-attribuita.
+ La grammatica sottostante può essere riconosciuta da un parser LL (Top-Down) e la SDD è L-attribuita.

Le regole semantiche di una SDD possono essere convertite in uno SDT le cui azioni sono eseguite esattamente al momento opportuno. Durante il parsing, un'azione semantica presente nel corpo di una produzione viene eseguita *non appena tutti i simboli alla sua sinistra sono stati consumati e riconosciuti*.
Gli SDT che richiedono azioni intermedie possono essere implementati introducendo dei *non-terminali marcatori* (marker non-terminals). Al posto dell'azione, si inserisce un nuovo non-terminale fittizio $M$ associato a una singola produzione vuota $M -> epsilon$. L'azione semantica viene spostata e associata alla riduzione di questa nuova regola.
Se la grammatica arricchita con i non-terminali marcatori può ancora essere trattata dal metodo di parsing scelto (ovvero non introduce nuovi conflitti Shift/Reduce), allora lo schema di traduzione corrispondente può essere implementato "al volo" durante il parsing, forzando il parser a eseguire l'azione nel momento in cui riduce la $epsilon$-produzione di $M$.

=== Schemi di traduzione postfissi
Quando la grammatica può essere analizzata con una tecnica bottom-up (es. parser LR) e la SDD associata è rigorosamente S-attribuita, si può costruire uno SDT in cui tutte le azioni semantiche si trovano alla fine delle produzioni. In questo modo, le azioni vengono eseguite in modo naturale nel momento esatto in cui il parser effettua la riduzione utilizzando quella specifica regola.

#definition()[
  Gli SDT in cui tutte le azioni compaiono *all'estremità destra* del
  corpo delle produzioni sono detti *SDT postfissi*.
]

#example()[
  #figure(
    table(
      stroke: none,
      columns: (.4fr, .6fr),
      align: left,
      table.hline(start: 0),
      table.header(
        table.cell([*Produzione*]),
        table.cell([*Azioni semantiche*]),
      ),
      table.hline(start: 0),
      [$L->E$*n*    ], [{print(_E.val_);}                     ],
      [$E-> E_1 +T$ ], [{_E.val_ = _$E_1$.val + T.val_;}      ],
      [$E-> T$      ], [{_E.val_ = _T.val_;}                  ],
      [$T-> T_1 * F$], [{_T.val_ = _$T_1$.val $times$ F.val_:}],
      [$T->F$       ], [{_T.val_ = _F.val_;}                  ],
      [$F->(E)$     ], [{_F.val_ = _E.val_;}                  ],
      [$F->"digit"$ ], [{_F.val_ = *digit*._lexval_;}         ],
      table.hline(start: 0),
    ),
  )
  Questo è lo SDT postfisso che implementa la SDD della calcolatrice, con l'unica aggiunta dell'istruzione di stampa finale. Essendo la grammatica LR e la SDD S-attribuita, le azioni semantiche dello SDT possono essere eseguite contestualmente alle riduzioni del parser, eliminando la necessità di costruire l'albero di parsing in memoria.
]

=== Implementazione degli SDT basata sugli stack del parser

Gli SDT postfissi possono essere implementati durante il parsing LR eseguendo le azioni ogniqualvolta si effettua una riduzione. Gli attributi di ogni simbolo grammaticale possono essere messi sullo stack, in una posizione in siano recuperabili durante la riduzione. La migliore strategia consiste nel porre sullo stack gli attributi assieme ai simboli grammaticali (0 agli stati LR che rappresentano i simboli), memorizzandoli nei campi di un record.

#example()[
  #figure(image("images/2025-11-19-19-06-55.png"))
  La Figura 5.19 mostra lo stack di un parser i cui elementi sono record aventi un campo per memorizzare il simbolo grammaticale (0 lo stato del parser) e un secondo campo (mostrato in basso) per memorizzare un attributo. I tre simboli grammaticali X, Y e Z si trovano sulla cima dello stack e potrebbero essere pronti per essere ridotti mediante una produzione del tipo A + XYZ.
]

In generale possiamo permettere la presenza di più attributi per ogni simbolo sia definendo un record di maggiori dimensioni sia mettendo sullo stack i puntatori ai record piuttosto che i record stessi. Se tutti gli attributi sono sintetizzati e le azioni compaiono alla fine delle produzioni, possiamo calcolare il valore degli attributi associati alla parte sx di una produzione quando si fa una riduzione. Se, ad esempio, riduciamo con una regola A → XYZ, tutti gli attributi per X, Y e Z sono disponibili e si trovano in posizioni note nella pila; dopo la riduzione, A e i suoi attributi si troveranno in cima allo stack.

#example()[
  SDT per la stessa grammatica dell'esempio precedente in cui lo stack viene manipolato esplicitamente. Lo stack è realizzato con un array stack e un indice top che ne indica la cima. stack[top] si riferisce al record in testa alla pila, stack[top-1] al record sottostante. Supponiamo che ogni record abbia un campo val che contiene il valore dell'attributo. Ad esempio se E si trova nella terza posizione dalla cima della pila, stack[top-2].val corrisponde a E.val.
  #figure(image("images/2025-11-19-19-09-13.png"))
]

#example()[
  Si utilizza la tabella di parsing SRL (già vista) per il parsing della stringa 3 \* ( 5 + 2 ). I record nella pila sono costituiti da due campi: quello che contiene il simbolo grammaticale caratteristico dello stato dell'automa LR(0) e quello che contiene il valore dell'attributo. Si assume che quando il parser impila un digit, il token d viene posto nel primo campo e il suo attributo nel secondo.
  #figure(image("images/2025-11-19-19-09-50.png"))
]

=== Schemi di traduzione con azioni interne alle produzioni
Un'azione semantica può essere inserita in qualsiasi posizione all'interno del corpo di una produzione. Essa sarà eseguita non appena tutti i simboli grammaticali alla sua sinistra saranno stati consumati. Quindi, in una produzione del tipo $B -> X {a} Y$, l'azione ${a}$ sarà eseguita non appena avremo riconosciuto interamente $X$ (se $X$ è un terminale) oppure tutti i terminali derivati da $X$ (se $X$ è un non-terminale).

Più precisamente:
- Nel *parsing Top-Down*, si esegue l'azione $a$ immediatamente prima di tentare l'espansione di $Y$ (se $Y$ è un non-terminale), oppure prima di cercare $Y$ in ingresso (se $Y$ è un terminale).
- Nel *parsing Bottom-Up*, si esegue l'azione $a$ non appena l'occorrenza in esame del simbolo $X$ appare sulla cima dello stack sintattico.
//TODO: altro da aggiungere?

=== Eliminazione della ricorsione sinistra dagli SDT
Poiché nessuna grammatica che presenti ricorsione sinistra può essere analizzata deterministicamente mediante parsing Top-Down (es. LL(1)), abbiamo già visto tecniche sintattiche per eliminare tale tipo di ricorsione. Quando una grammatica ricorsiva a sinistra è parte di uno Schema di Traduzione (SDT), è necessario convertire non solo la sintassi, ma *anche* la posizione delle azioni e il flusso degli attributi.

==== SDT con effetti collaterali semplici
Consideriamo il caso semplice in cui l'unica questione riguarda l'ordine di esecuzione delle azioni (es. stampare una stringa). In questa situazione si applica il seguente principio:

_*Nel processo di trasformazione della grammatica, si trattino le azioni semantiche alla stregua di ulteriori simboli terminali.*_

Questo principio si basa sul fatto che la rimozione della ricorsione sinistra preserva l'ordine dei terminali nella stringa generata. Le azioni, trattate come terminali, verranno quindi eseguite esattamente nello stesso ordine originale in qualsiasi visita da sinistra a destra.

#example()[
  Si considerino le seguenti produzioni relative a $E$ prese da uno SDT per la traduzione di espressioni dalla forma infissa alla forma postfissa:
  $
    E & -> E_1 + T quad { text("print")('+'); } \
    E & -> T
  $
  Se applichiamo la trasformazione standard all'insieme delle produzioni, il "resto" della produzione ricorsiva inizia con $+ T { text("print")('+'); }$. Introducendo il non-terminale $R$ (resto), si ottiene l'insieme equivalente e privo di ricorsione sinistra:
  $
    E & -> T R \
    R & -> + T quad { text("print")('+'); } quad R_1 \
    R & -> epsilon
  $
]

==== SDT che calcolano attributi (Trasformazione S $->$ L)
Quando le azioni di uno SDT calcolano attributi invece che stampare semplicemente stringhe, dobbiamo prestare molta più attenzione. Se la SDD di partenza è S-attribuita, possiamo sempre costruire uno SDT equivalente, ma diventerà L-attribuito.

Si considerino le seguenti due produzioni, in cui l'attributo di $A$ viene sintetizzato dal basso:
#align(center)[
  #table(
    stroke: none,
    columns: (15em, 20em),
    align: left,
    table.hline(start: 0),
    table.header([*Produzione Originale*], [*Regole semantiche (S-attribuite)*]),
    table.hline(start: 0),
    [$A -> A_1 Y$], [{$A."a" = g(A_1."a", Y."y")$}],
    [$A -> X$], [{$A."a" = f(X."x")$}],
    table.hline(start: 0),
  )
]
Qui $g()$ e $f()$ sono due funzioni arbitrarie. Applicando l'eliminazione della ricorsione sinistra, la sintassi diventa $A -> X R$ e $R -> Y R | epsilon$.

Ma che fine fanno gli attributi?
Dal momento che $R$ produce un "resto" relativo alle occorrenze di $Y$, la sua traduzione dipende da ciò che è stato calcolato *alla sua sinistra*.
- Per $R$ utilizziamo un *attributo ereditato* $R."i"$ allo scopo di accumulare i risultati intermedi delle successive applicazioni della funzione $g()$, partendo dal valore iniziale calcolato da $f()$.
- Il non-terminale $R$ ha inoltre un *attributo sintetizzato* $R."s"$. Questo attributo viene finalizzato quando la ricorsione termina (produzione $R -> epsilon$) e viene poi semplicemente propagato verso l'alto dell'albero.

Lo SDT finale trasformato è il seguente:
#align(center)[
  #table(
    stroke: none,
    columns: (8em, 28em),
    align: left,
    table.hline(start: 0),
    table.header([*Nuova Prod.*], [*SDT Modificato (L-attribuito)*]),
    table.hline(start: 0),
    [$A -> X R$], [{$R."i" = f(X."x")$} $quad R quad$ {$A."a" = R."s"$}],
    [$R -> Y R_1$], [{$R_1."i" = g(R."i", Y."y")$} $quad R_1 quad$ {$R."s" = R_1."s"$}],
    [$R -> epsilon$], [{$R."s" = R."i"$}],
    table.hline(start: 0),
  )
]

Si noti il tempismo perfetto: l'attributo ereditato $R."i"$ viene calcolato *immediatamente prima* dell'uso di $R$ nel corpo, mentre gli attributi sintetizzati $A."a"$ e $R."s"$ sono sempre valutati alla fine delle produzioni.


//20.11.2025
=== Schemi di traduzione per definizioni L-attribuite
Consideriamo ora il caso più generale di una SDD L-attribuita. Assumeremo che la grammatica sottostante possa essere analizzata top-down, poiché in caso contrario accade spesso che sia impossibile effettuare la trasformazione appoggiandosi a un parser LL o LR.

Le regole fondamentali per trasformare una SDD L-attribuita in uno SDT funzionante sono due:
+ *Regola per gli attributi ereditati:* si aggiungano le azioni che calcolano gli attributi ereditati di un non-terminale $A$ *immediatamente prima* dell'occorrenza di $A$ nel corpo della produzione.

+ *Regola per gli attributi sintetizzati:* si aggiungano le azioni che calcolano un attributo sintetizzato relativo alla testa della produzione esclusivamente *alla fine* del corpo di quella produzione.

#example()[
  Prendiamo come riferimento la produzione del costrutto iterativo:
  $
    S -> text("while") ( C ) S_1
  $
  Useremo i seguenti attributi semantici per generare il codice intermedio richiesto:

  - $S."next"$ (ereditato): Indica l'etichetta di salto relativa all'inizio del codice che deve essere eseguito immediatamente dopo che lo statement $S$ è terminato.
  - $S."code"$ (sintetizzato): Rappresenta la porzione di codice intermedio che implementa l'intero statement $S$ e termina con un salto a $S."next"$.
  - $C."true"$ (ereditato): Indica l'etichetta relativa all'inizio del codice da eseguire se la condizione $C$ risulta vera (il corpo del loop).
  - $C."false"$ (ereditato): Indica l'etichetta relativa all'inizio del codice da eseguire se la condizione $C$ risulta falsa (uscita dal loop).
  - $C."code"$ (sintetizzato): Rappresenta il codice intermedio che implementa la valutazione di $C$ e che salta a $C."true"$ o $C."false"$ a seconda del valore booleano dell'espressione.

  #figure(image("images/2025-11-20-10-56-43.png"), caption: "SDD")

  Alcuni punti cruciali meritano un approfondimento:
  - La funzione `new()` genera dinamicamente nuove etichette univoche nel codice generato (es. `L1`, `L2`).
  - Le variabili locali `L1` e `L2` mantengono memorizzate le etichette di cui abbiamo bisogno. In particolare, `L1` indica l'inizio del codice relativo alla valutazione della condizione del `while`; dobbiamo fare in modo che il codice di $S_1$, dopo aver eseguito il corpo, esegua un loop ricorsivo tornando a questa etichetta. Questo è il motivo per cui assegniamo il valore `L1` a $S_1."next"$.
  - `L2` indica l'inizio del codice relativo al corpo dello statement ($S_1$) e deve essere assegnato a $C."true"$, poiché è proprio lì che bisogna saltare quando la condizione $C$ è verificata.
  - Assegniamo a $C."false"$ il valore di $S."next"$; se la condizione risulta falsa, il controllo deve passare immediatamente al codice che segue l'intero blocco del `while`.
  - Usiamo il simbolo $||$ per indicare l'operazione di concatenamento di frammenti di codice intermedio. Il valore finale di $S."code"$, quindi, inizia con l'emissione dell'etichetta `L1`, seguita dal codice della condizione $C$, dall'etichetta `L2`, dal codice del corpo $S_1$ e infine da un'istruzione di salto incondizionato `goto L1`.

  Applicando le due regole di traduzione per i vincoli L-attribuiti (spingendo le azioni ereditate a sinistra e le sintetizzate alla fine), si ottiene il seguente SDT:
  #figure(image("images/2025-11-20-11-08-42.png"))
]

== Implementazione di SDD L-attribuite
Poiché la stragrande maggioranza delle applicazioni reali legate alla traduzione può essere sviluppata basandosi su definizioni L-attribuite, andiamo a vedere in cosa consiste la loro implementazione pratica. Un primo gruppo di metodi realizza la traduzione *dopo* o *durante* la visita di un albero di parsing mantenuto in memoria:
+ *Costruzione di un albero di parsing annotato:* questo metodo generale (seppur dispendioso in memoria) funziona per qualsiasi SDD che garantisca l'assenza di cicli di dipendenza.
+ *Costruzione dell'albero di parsing, aggiunta delle azioni ed esecuzione in pre-ordine:* questa tecnica sfrutta la natura sinistra-destra e può essere applicata a qualsiasi definizione L-attribuita in modo molto naturale.

Tuttavia, per ottimizzare le prestazioni, verranno adesso introdotti altri quattro metodi per effettuare la traduzione direttamente *durante il parsing*, senza dover costruire l'intero albero in memoria:
+ *Utilizzo di un parser a discesa ricorsiva (Top-Down):* si definisce una funzione per ogni non-terminale; gli attributi ereditati diventano i parametri formali passati in input, mentre gli attributi sintetizzati diventano i valori di ritorno delle funzioni.
+ *Generazione del codice al volo:* l'emissione diretta del codice o del risultato tramite effetti collaterali (stampa) senza salvare stringhe intermedie.
+ *Implementazione di uno SDT insieme a un parser LL:* sfrutta una pila esplicita per gestire la traduzione durante un'analisi Top-Down non ricorsiva (es. LL(1) table-driven).
+ *Implementazione di uno SDT insieme a un parser LR:* come visto in precedenza, estende i parser Bottom-Up tramite la simulazione di attributi ereditati e l'uso di non-terminali marcatori.

=== Traduzione durante il parsing a discesa ricorsiva
E' possibile estendere un tale parser e trasformarlo in un traduttore facendo in modo che:
+ gli argomenti di $A()$ siano gli attributi ereditati del simbolo non-terminale $A$;
+ il valore restituito da $A()$ sia l'insieme degli attributi sintetizzati del simbolo $A$.

Il corpo della funzione $A()$ deve occuparsi sia del parsing, sia della gestione degli attributi; in particolare, la funzione deve:
+ decidere quale produzione utilizzare per espandere $A$;
+ verificare che ogni simbolo terminale appaia in ingresso quando è richiesto;
+ conservare in variabili locali i valori di tutti gli attributi necessari per il calcolo degli attributi ereditati relativi ai non-terminali nel corpo della produzione e/o degli attributi sintetizzati relativi al non-terminale alla testa della produzione;
+ chiamare le funzioni corrispondenti ai non-terminali nel corpo della produzione selezionata e passare a tali funzioni gli argomenti corretti;

#example()[
  Consideriamo la SDD e lo SDT relativi allo statement `while`. Il seguente è un'implementazione di esso mediante un parser a discesa ricorsiva.
  #algo(
    title: [*string* S],
    parameters: ([*label* _next_],),
  )[
    {#i\
    *string* _Scode_, _Ccode_;\
    *label* _L1_,_L2_;\
    if (il simbolo corrente è il token while){#i\
    avanza il puntatore d'ingresso;\
    verifica che '(' sia il prossimo simbolo, quindi avanza;\
    _L1_ = _new_();\
    _L2_ = _new_();\
    _Ccode = C(next, L2)_;\
    verifica che ')' sia il prossimo simbolo, quindi avanza;\
    _Scode = S(L1)_;\
    return("label" || _L1_ || _Ccode_ || "label" || _L2_ || _Scode_);#d\
    }else {\/\*altri tipi di statement\
    }#d\
    }
  ]
]

=== Generazione del codice al volo
La costruzione esplicita di lunghe stringhe di codice come valore degli attributi non è desiderabile per diverse ragioni, tra cui l'eccessivo tempo richiesto per copiare o spostare le stringhe. In molti casi comuni, tra cui l'esempio di generazione del codice del costrutto `while`, è possibile costruire incrementalmente porzioni di codice e memorizzarle in un array o in un file mediante opportune azioni dello SDT. Per fare ciò, le seguenti condizioni devono essere soddisfatte:

+ Per uno o più terminali esiste un attributo _principale_. Per semplicità assumeremo che gli attributi principali siano tutti di tipo stringa. Nell'esempio di prima, _S.code_ e _C.code_ sono attributi principali, mentre tutti gli altri non lo sono.

+ Gli attributi principali sono sintetizzati.

+ Le regole per la valutazione degli attributi principali garantiscono che:

  - L'attributo principale è dato dal concatenamento degli attributi principali dei non-terminali che appaiono nel corpo della produzione più, eventualmente, altri elementi che non sono attributi principali, quali la stringa costante `label` o i valori delle etichette `L1` e `L2`;
  - Gli attributi principali dei non-terminali appaiono nella regola nello stesso ordine in cui i non-terminali appaiono nel corpo della produzione.

Tali condizioni implicano che l'attributo principale può essere costruito emettendo solamente gli elementi del concatenamento che non sono attributi principali.

#example()[
  Possiamo modificare la funzione _S_ precedentemente descritta in modo che emetta gli elementi dell'attributo principale _S.code_ invece di salvarli per poi concatenarli nel valore di _S.code_ che verra poi restituito.
  #figure(image("images/2025-11-27-15-16-21.png"))
  Le funzioni `S()` e `C()` non restituiscono alcun valore, poiché tutti i loro attributi sintetizzati sono prodotti mediante stampa. Inoltre, la posizione delle istruzioni di stampa nella funzione è importante. L'ordine in cui i vari elementi vengono stampati è il seguente: per prima cosa la stringa "label" L1, quindi il codice relativo al non-terminale C (che coincide con il valore della variabile _C.code_), la stringa "label" L2, e infine il codice derivante dalla chiamata ricorsiva della funzione S) (ovvero il valore della variabile _S.code_).
]
#example()[
  Possiamo fare lo stesso tipo di modifica direttamente sullo SDT sottostante sostituendo le azioni che costruiscono un attributo principale in azioni che emettono gli elementi che compongono tale attributo.
  #figure(image("images/2025-11-27-15-18-21.png"))
]
=== Definizioni L-attribuite e parsing LL
Supponiamo che una SDD L-attribuita sia basata su una grammatica LL e
che sia stata convertita in uno SDT in cui le azioni si trovano all’interno delle produzioni. In questo caso possiamo effettuare la traduzione durante il parsing LL a patto di estendere lo stack del parser in modo da poter contenere le azioni e alcuni dati necessari per la valutazione degli attributi. Tipicamente
tali dati sono copie degli attributi.

Oltre ai record che rappresentano i terminali e i non-terminali della grammatica, lo stack del parser conterrà _action-record_, cioè record relativi alle azioni, che saranno eseguiti e _synthesize-record_, ovvero record destinati a salvare gli attributi sintetizzati dei non-terminali. Per gestire gli attributi sullo stack ci baseremo sui seguenti principi.

- Gli attributi ereditati di un non-terminale $A$ sono memorizzati sullo stack, nel record che rappresenta il non-terminale. Il codice necessario per la valutazione di tali attributi è in genere rappresentato mediante un _action-record_ memorizzato sullo stack, immediatamente al di sopra del record che rappresenta $A$. E' infatti il meccanismo di conversione di una SDD L-attribuita in uno schema di traduzione guidato dalla sintassi ad assicurare che l'_action-record_ di $A$ sia immediatamente al di sopra del record di $A$.
- Gli attributi sintetizzati relativi al non-terminale $A$ sono memorizzati in un _synthesize-record_ separato e posizionato sullo stack immediatamente al di sotto del record relativo ad $A$.

#example()[
  Questo esempio implementa lo schema di traduzione che genera al volo il codice intermedio dello statement `while`. Questo SDT non ha attributi sintetizzati, eccezion fatta per gli attributi fittizi che rappresentano le etichette. La Figura 5.33(a) mostra la situazione dello stack subito prima di applicare la produzione per espandere S. La Figura 5.33(b) mostra la situazione immediatamente dopo aver espanso S.
  #figure(image("images/2026-05-18-08-49-43.png"))
]

#example()[
  Consideriamo ora lo stesso statement while, ma questa volta ci occupiamo di uno schema di traduzione che produce l’uscita S.code come attributo sintetizzato e non codice generato al volo. Teniamo bene a mente la seguente ipotesi induttiva:

  _Ogni non-terminale cui è associato del codice lascia tale codice memorizzato sotto forma di stringa nel synthesize-record immediatamente al di sotto di esso nello stack._

  La Figura 5.35 mostra la situazione subito prima che S sia espanso mediante la produzione dello statement `while`.
  #figure(image("images/2026-05-18-08-51-00.png"))
]

=== Definizione LL-attribuite con parser LR
Ogni traduzione realizzabile in modo top-down può anche essere implementata secondo un approccio bottom-up. Più precisamente, data una definizione guidata dalla sintassi (SDD) L-attribuita, possiamo adattare la grammatica in modo da poter calcolare la stessa SDD durante un parsing LR.

Le regole per effettuare questa trasformazione sono le seguenti:

+ Si inizia da uno SDT che prevede azioni all'interno del corpo prima di ogni non-terminale per calcolare gli attributi ereditati, e un'azione alla fine per calcolare gli attributi sintetizzati.
+ Si introduce nella grammatica un *marcatore* (Non-Terminale Marcatore, NTM) per ogni azione interna al corpo della produzione. Ogni azione richiede un marcatore distinto e ogni marcatore $M$ deve avere una produzione del tipo $M -> epsilon$.
+ Si modifica un'azione $a$ se il marcatore $M$ la sostituisce in qualche produzione del tipo $A -> alpha {a} beta$, e si associa alla produzione $M -> epsilon$ un'azione $a'$ che:
  - Copia, come attributi ereditati di $M$, tutti gli attributi di $A$ e dei simboli in $alpha$ di cui l'azione $a$ necessita;
  - Calcola gli attributi nello stesso modo di $a$, ma li rende *attributi sintetizzati* di $M$ (così che possano essere salvati sulla pila semantica e letti successivamente).

#observation()[
  L'aggiunta di Non-Terminali Marcatori (NTM) in qualsiasi posizione del corpo delle produzioni di una grammatica LL produce quasi sempre come risultato una nuova grammatica trattabile dai parser bottom-up, permettendo al parser LR di fare una pausa, eseguire l'azione sulla regola $epsilon$, e poi riprendere lo shift dei token.
]

Vediamo come applicare queste regole su una grammatica generica:
#example()[
  Consideriamo una produzione $A -> B C$ e sia $B."i"$ un attributo ereditato calcolato sulla base di un altro attributo ereditato $A."i"$ mediante una generica relazione $B."i" = f(A."i")$. Il frammento di SDT che rispecchia tale situazione è il seguente:
  $
    A -> { B."i" = f(A."i"); } quad B quad C
  $

  Introduciamo ora il marcatore $M$ dotato di un attributo ereditato $M."i"$ e uno sintetizzato $M."s"$. Il primo sarà una copia di $A."i"$, mentre il secondo sarà il risultato $B."i"$. Lo schema di traduzione diviene:
  $
    & A -> M B C \
    & M -> epsilon quad { M."i" = A."i"; M."s" = f(M."i"); }
  $

  Si noti che, formalmente, $A."i"$ non è direttamente disponibile per la regola relativa a $M$. Tuttavia, in un parser LR si può fare in modo che ogni attributo ereditato relativo a un non-terminale (come $A$) sia sempre posizionato sullo stack *immediatamente al di sotto* della posizione in cui avrà luogo, più tardi, la riduzione ad $A$.

  In questo modo, quando il parser ridurrà il prefisso a $M$, troveremo $A."i"$ in una posizione dello stack da cui può essere letto. Inoltre, il valore calcolato $M."s"$ rimarrà sullo stack al posto di $M$ e si troverà, come ci si aspetta, esattamente al di sotto del punto in cui, più tardi, avverrà la riduzione a $B$.
]

#example()[
  Trasformiamo lo schema di traduzione del costrutto `while` in un nuovo SDT che possa operare durante un parsing LR della grammatica adattata.

  L'SDT originale L-attribuito aveva azioni prima di $C$ e prima di $S_1$. Introducendo un marcatore $M$ prima di $C$ e un marcatore $N$ prima di $S_1$, la grammatica sottostante diviene:
  $
    & S -> text("while") ( M C ) N S_1 \
    & M -> epsilon \
    & N -> epsilon
  $

  Prima di trattare le azioni associate ai marcatori $M$ ed $N$, rivediamo la posizione in cui il parser LR memorizzerà gli attributi sullo stack:
  - $S."next"$ si trova al di sotto del corpo della produzione (immediatamente sotto il token `while`).
  - $C."true"$ e $C."false"$ si trovano immediatamente sotto il record per $C$. Il record di $M$ si troverà proprio lì e conterrà questi attributi "calcolati" come sintetizzati.
  - $S_1."next"$ si troverà nel record di $N$, immediatamente sotto il record di $S_1$.
  - $C."code"$ si troverà nel record di $C$.
  - $S_1."code"$ si troverà nel record di $S_1$.

  #figure(image("images/2026-05-18-09-02-04.png"))
  #figure(image("images/2026-05-18-09-02-15.png"))
  #figure(image("images/2026-05-18-09-02-33.png"))
]
