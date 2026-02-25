#import "../../../dvd.typ": *
#import "@preview/algo:0.3.6": algo, code, comment, d, i
#import "@preview/fletcher:0.5.8": diagram, node, edge
#pagebreak()

= Traduzione guidata dalla sintassi
L'*idea di base* della traduzione guidata dalla sintassi è quella di *associare informazioni* a un costrutto di un linguaggio aggiungendo *attributi* ai simboli della grammatica che rappresentano tale costrutto. Una definizione guidata dalla sintassi specifica i valori assunti dagli attributi per mezzo di regole semantiche associate alle produzioni.

== Definizioni guidate dalla sintassi
#definition()[Una *Definizione Guidata dalla Sintassi* o *SDD (Syntax-Directed Definition)* è una grammatica *context-free* alla quale vengono aggiunti *attributi* e *regole semantiche*.
  - *Attributi:* sono associati ai simboli della grammatica. Possono essere di qualunque tipo, come numeri, tipi, tabelle, riferimenti o stringhe (frammenti di codice).
  - *Regole Semantiche:* sono associate alle produzioni della grammatica e specificano come calcolare il valore degli attributi.
]

La tecnica generale consiste nel costruire un albero di parsing (parse tree) per una stringa di input e poi usare le regole semantiche per calcolare i valori degli attributi in ogni nodo dell'albero. Un albero che mostra anche i valori calcolati degli attributi è detto albero di parsing annotato.

Dato un simbolo della grammatica $X$ e un suo attributo $a$, la notazione *$X.a$* indica il valore di $a$ per un nodo dell'albero di parsing etichettato con $X$.

=== Attributi ereditati e sintetizzati
Per i simboli non-terminali ci sono due tipi di attributi:

+ *Attributi sintetizzati* ⬆️:
  - Flusso: Bottom-Up (dal basso verso l'alto).
  - Associazione: Associati al non-terminale in testa alla produzione (il "genitore", es. A in $A -> alpha$).
  - Definizione: Calcolati tramite una regola semantica associata alla produzione stessa.
  - Dipendenze: Definiti unicamente in base agli attributi dei figli (simboli nel corpo $alpha$) e/o del nodo stesso.

  #example()[
    In un'espressione aritmetica come $E -> E_1 + T$, l'attributo $E$.val (il valore del genitore) è sintetizzato calcolando $E_1$. val + $T$.val (i valori dei figli).
  ]

+ *Attributi ereditati* ⬇️➡️:
  - Flusso: Top-Down (dall'alto verso il basso) o Laterale (tra fratelli).
  - Associazione: Associati a un non-terminale nel corpo della produzione (un "figlio", es. B in $A \-> alpha B beta$).
  - Definizione: Calcolati tramite una regola semantica associata alla produzione del padre.
  - Dipendenze: Definiti in base agli attributi del padre (A), dei fratelli (simboli in $alpha$ o $beta$), e/o del nodo stesso (B).

#observation()[
  - Restrizione (Ereditati): Un attributo ereditato (al nodo N) non può dipendere dagli attributi dei figli di N.
  - Inter-dipendenza: Un attributo sintetizzato (al nodo N) può dipendere da attributi ereditati dello stesso nodo N.
  Terminali:
  - Possono avere attributi sintetizzati (es. digit.lexval, fornito dal lexer).
  - Non possono avere attributi ereditati.
]

#example()[
  #figure(
  table(
    stroke: none,
    columns: (.01fr, .04fr, .45fr, .5fr),
    align: left,
    table.hline(start:0),
    table.header(
      table.cell([]),
      table.cell([]),
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*])
    ),
    table.hline(start: 0),
    [ ], [1)], [$L -> E $ *n*     ], [$L.v a l = E.v a l                  $],
    [ ], [2)], [$E -> E_1 + T$    ], [$E.v a l = E_1.v a l + T.v a l      $],
    [ ], [3)], [$E -> T$          ], [$E.v a l = T.v a l                  $],
    [ ], [4)], [$T -> T_1 * F$    ], [$T.v a l = T_1.v a l times F.v a l  $],
    [ ], [5)], [$T -> F$          ], [$T.v a l = F.v a l                  $],
    [ ], [6)], [$F ->$ ( _E_ )    ], [$F.v a l = E.v a l                  $],
    [ ], [7)], [$F ->$ *digit*    ], [$F.v a l = bold("digit").l e x v a l$],
    table.hline(start: 0)
  ), caption: "Definizione guidata dalla sintassi di una semplice calcolatrice da tavolo")
  La SDD della figura valuta le espressioni terminate da uno speciale marcatore di fine che indichiamo con $n$. Nella SDD ognuno dei non-terminali ha un unico attributo sintetizzato chiamato *val*. Supponiamo inoltre che il terminale *digit* abbia un attributo sintetizzato *lexval* dato dal valore intero restituito dall'analizzatore lessicale.
  - La regola per la produzione 1, $L -> E n$ assegna a L.val il valore dell'intera espressione E.val.
  - La produzione 2, $E -> E_1 + T$ ha una regola che calcola il valore dell'attributo val della testa della produzione E come somma dei valori associati a $E_1$ e a $T$. A ogni nodo N con etichetta E il valore dell'attributo val associato a E è la somma del valori di val associati ai nodi figli di N etichettati con E e T.
  - La produzione 3, $E -> T$, ha una sola regola che stabilisce che il valore di val associato a E è uguale al valore di val relativo al nodo figlio con etichetta T.
  - La produzione 4 è simile alla seconda: invece di calcolarne la somma, la sua regola esegue il prodotto tra i valori degli attributi associati ai figli.
  - Le regole per le produzioni 5 e 6 copiano semplicemente i valori associati ad un nodo figlio, come gia visto per la produzione 3.
  - Infine, la produzione 7 assegna a F.val il valore di una cifra, cioè il valore numerico associato al token digit restituito dall'analizzatore lessicale.
]

#definition()[
  Una SDD che contiene solo attributi sintetizzati è detta *S-attribuita* (come l'esempio precedente). In una SDD S-attribuita ogni regola calcola un attributo associato alla variabile della parte *sinistra* della produzione a partire dagli attributi associati ai simboli della parte *destra*.
]

=== Valutazione di una SDD ai nodi di un albero di parsing
Per visualizzare il processo di traduzione specificato mediante una SDD è utile ricorrere agli alberi di parsing anche se un traduttore non necessita della costruzione esplicita dell'albero. Immaginiamo quindi che le regole di un SDD siano utilizzate costruendo per prima cosa l'albero di parsing, quindi siano valutate per calcolare il valore degli attributi in corrispondenza di ogni nodo dell'albero di parsing.

Per poter valutare un attributo di un nodo dobbiamo valutare prima tutti gli attributi da cui dipende.
- Se tutti gli attributi sono sintetizzati, prima di poter calcolare un attributo associato a un nodo, dobbiamo calcolare gli attributi associati ai figli. Possiamo procedere in qualsiasi ordine bottom-up, ad esempio visitando l'albero in postordine.
- Nel caso di SDD con attributi sia sintetizzati che ereditati non è possibile garantire sempre l'esistenza di un ordine di valutazione.

#example()[
  Si considerino, per esempio, i non-terminali $A$ e $B$ con attributi $A.s$ e $B.i$, rispettivamente sintetizzato ed ereditato, e la produzione con le corrispondenti regole semantiche:
  #figure(grid(
    columns: (15em, 15em),
    align: center,
    [#block($
       &"PRODUZIONE" \ 
       &quad A -> B
    $)],
    [#block($
       &"REGOLE SEMANTICHE" \
       &quad A.s = B.i; \
       &quad B.i = A.s + 1; 
    $)]
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
  Queste regole sono circolari. E' impossibile valutare l'attributo $A.s$ per un nodo N oppure l'attributo $B.i$ per un figlio del nodo N senza prima valutare l'altro.
]

#pagebreak()

#example()[
  #table(
    stroke: none,
    columns: (10em, 15em),
    align: left,
    table.hline(start:0),
    table.header(
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*])
    ),
    table.hline(start: 0),
    [$L -> E $ *n*     ], [$L.v a l = E.v a l                  $],
    [$E -> E_1 + T$    ], [$E.v a l = E_1.v a l + T.v a l      $],
    [$E -> T$          ], [$E.v a l = T.v a l                  $],
    [$T -> T_1 * F$    ], [$T.v a l = T_1.v a l times F.v a l  $],
    [$T -> F$          ], [$T.v a l = F.v a l                  $],
    [$F ->$ ( _E_ )    ], [$F.v a l = E.v a l                  $],
    [$F ->$ *digit*    ], [$F.v a l = bold("digit").l e x v a l$],
    table.hline(start: 0)
  )
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

//TODO: aggiungere esempio 5.3 da libro

== Ordine di valutazione delle SDD
I *grafi delle dipendenze* sono uno strumento utile per determinare un ordine di valutazione delle varie istanze degli attributi in un dato albero di parsing. Mentre un albero di parsing mostra i valori degli attributi, un grafo delle dipendenze ci indica come tali valori devono essere calcolati.

=== Grafi delle dipendenze
Un grafo delle dipendenze rappresenta il flusso di informazioni attraverso gli attributi di un particolare albero di parsing. Un arco diretto da una istanza di un attributo a un'altra indica che il valore del primo attributo è richiesto per il calcolo del valore del secondo. Gli archi quindi esprimono i vincoli implicati dalle regole semantiche. Più precisamente, valgono le seguenti proprietà.

- Per ogni nodo dell'albero di parsing etichettato con un simbolo $X$, nel grafo delle dipendenze esiste un nodo per ogni attributo di $X$.

- Se una regola semantica associata a una produzione $A -> alpha X beta$ definisce il valore di un attributo sintetizzato $A.b$ in funzione di un attributo $X.c$ (ed eventualmente di altri), cioè $A.b = f(..., X.c,...)$, allora il grafo delle dipendenze contiene un arco orientato da $X.c$ a $A.b$. In generale, per ogni nodo N con etichetta $A$ a cui si applica la produzione $A -> alpha X beta$ si deve creare un arco orientato dall'attributo $c$ associato al figlio di N corrispondente all'istanza di $X$ verso l'attributo $b$ del nodo N.

- Consideriamo una regola semantica associata ad una regola del tipo $X -> alpha B beta$ oppure $Y -> alpha X beta B gamma$ che definisce un attributo ereditato $B.c$ in funzione di un attributo $X.a$ (ed eventualmente di altri), cioè $B.c = f(..., X.a,...)$, allora il grafo delle dipendenze contiene un arco orientato da $X.a$ a $B.c$. Per ogni nodo N con etichetta $B$, corrispondente all'occorrenza di $B$ nella parte destra della regola $X -> alpha B beta$ o $Y -> alpha X beta B gamma$, si deve creare un arco orientato dall'attributo a associato al nodo M corrispondente all'istanza di $X$ verso l'attributo $c$ del nodo N (M può essere padre o fratello di N).

#example()[
  Si consideri la seguente produzione e la relativa regola semantica:
  $
    E->E_1 + T quad quad quad quad "E.val" = E_1."val" + "T.val"
  $
  Per ogni nodo N con etichetta E (corrispondente alla parte sx della regola) l'attributo sintetizzato val è calcolato utilizzando i valori degli attributi val corrispondenti ai due figli con etichette E e T. La porzione del grafo delle dipendenze corrispondente è:

  #figure(diagram(
    node-stroke: none,
    cell-size: 5mm,
    spacing: 3mm,

    node((2, 0), [_E_]  , name: <E>),
    node((0, 2), $E_1$  , name: <E1>),
    node((2, 2), $+$    , name: <p>),
    node((4, 2), [_T_]  , name: <T>),
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

#pagebreak()

#example()[
  //TODO: rifare in typst
  Altro esempio di grafo delle dipendenze ma più complesso:
  #align(right)[
      #table(
      stroke: none,
      columns: (10em, 15em),
      align: left,
      table.hline(start:0),
      table.header(
        table.cell([*Produzione*]),
        table.cell([*Regole semantiche*])
      ),
      table.hline(start: 0),
      [1) $T -> F T'$    ], [$T'.i n h = F.v a l                 $],
      [               ], [$T.v a l = T'.s y n                 $],
      [2) $T' -> *F T'_1$], [$T'_1.i n h = T'.i n h times F.v a l$],
      [               ], [$T'.s y n = T'_1.s y n              $],
      [3) $T' -> epsilon$], [$T'.s y n = T'.i n h                $],
      [4) $F ->$ *digit* ], [$F.v a l = bold("digit").l e x v a l$],
      table.hline(start: 0)
    )
  ]

  #figure(diagram(
    node-stroke: none,
    cell-size: 5mm,
    spacing: 3mm,

    // NODES + EDGES: principali //

    node((3, 0), [_T_]    , name: <T>),
    node((0, 2), [_F_]    , name: <F1>),
    node((0, 4), [*digit*], name: <digit1>),
    node((6, 2), [_T'_]   , name: <T-1>),
    node((3, 4), $*$      , name: <ast>),
    node((5, 4), [_F_]    , name: <F2>),
    node((5, 6), [*digit*], name: <digit2>),
    node((9, 4), [_T'_]   , name: <T-2>),
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
    node((0.5 , 2), [3], name: <3>),
    node((5.5 , 2), [5], name: <5>),
    node((6.5 , 2), [8], name: <8>),
    node((0.5 , 4), [1], name: <1>),
    node((5.5 , 4), [4], name: <4>),
    node((8.5 , 4), [6], name: <6>),
    node((9.5 , 4), [7], name: <7>),
    node((5.5 , 6), [2], name: <2>),

    edge(<1>, <3>, "-|>"),
    edge(<3>, <5>, "-|>", bend: 30deg),
    edge(<5>, <6>, "-|>"),
    edge(<2>, <4>, "-|>"),
    edge(<4>, <6>, "-|>", bend: 30deg),
    edge(<6>, <7>, "-|>", bend: -45deg),
    edge(<7>, <8>, "-|>"),
    edge(<8>, <9>, "-|>"),

    node((4.5, 0), [_val_]   ),
    node((1   , 2), [_val_]   ),
    node((5   , 2), [_inh_]   ),
    node((7.5 , 2), [_syn_]   ),
    node((1.25, 4), [_lexval_]),
    node((6   , 4), [_val_]   ),
    node((8   , 4), [_inh_]   ),
    node((10  , 4), [_syn_]   ),
    node((6.25, 6), [_lexval_]),
  ))
]

=== Ordine di valutazione degli attributi
Il grafo delle dipendenze caratterizza ogni possibile ordine di valutazione degli attributi associati ai nodi di un albero di parsing. Se c'è un arco da un nodo M ad un nodo N, allora l'attributo associato a M deve essere valutato prima di quello associato a N.
#definition()[
  Gli ordinamenti validi sono costituiti da sequenze $N_1, N_2, ..., N_k$, tali che, se esiste un arco dal nodo $N_i$ al nodo $N_j$ nel grafo delle dipendenze allora deve essere $i < j$. Un ordinamento con questa proprietà è un *ordinamento topologico*.
]

Se il grafo contiene un ciclo allora non esiste un ordinamento
topologico, al contrario, se non ci sono cicli, esiste almeno un ordinamento topologico.

=== Definizioni S-attribuite
Per poter valutare gli attributi è necessario che il grafo delle dipendenze di un albero di parsing non contenga cicli. Per alcune classi di SDD i grafi delle dipendenze non contengono cicli per nessun albero di parsing.
#definition()[
  Una definizione guidata dalla sintassi è detta *S-attribuita* se e solo se ogni suo attributo è sintetizzato.
]
In questo caso non ci sono sicuramente cicli nei grafi delle dipendenze. Per una SDD S-attribuita si possono valutare gli attributi secondo un qualsiasi ordinamento bottom-up dei nodi dell'albero di parsing, ad esempio visitando l'albero in postordine e valutando gli attributi associati ad un nodo quando questo viene visitato (quando viene lasciato per l'ultima volta). Ovvero si applica la seguente funzione a partire dalla radice dell'albero di parsing:

postorder(N) {
for ( ogni figlio C di N, da sinistra a destra )
postorder(C);
valuta gli attributi associati al nodo N;
}

Le definizioni S-attribuite possono essere implementate durante il parsing bottom-up che corrisponde a una vista in postordine. Una vista in postordine corrisponde all'ordine in cui un parser LR effettua la riduzione della parte destra di una regola alla variabile della parte sinistra.

=== Definizioni L-attribuite

#definition()[
  Una definizione guidata dalla sintassi è detta *L-attribuita* se tra gli attributi associati al corpo di una produzione possono esistere archi del grafo delle dipendenze orientati solo da sinistra verso destra e non viceversa.
]

Più precisamente, ogni attributo può essere:
+ sintetizzato
+ ereditato, con le regole seguenti:\
  se $A-> X_1 X_2 ... X_n$ è una produzione a cui è associata una regola semantica che calcola il valore di un attributo ereditato $X_i.a$, allora tale regola può utilizzare soltanto:
  - attributi ereditati associati alla parte sinistra $A$;
  - attributi ereditati e sintetizzati assoaciati alle occorrenze dei simboli $X_1 X_2 ... X_(i-1)$ che compaiono a sinistra di $X_i$;
  - attributi ereditati e sintetizzati associati alla stessa occorrenza di $X_i$ in esame purché non comportino cicli.

#example()[
  La seguente SDD è L-attribuita:
  #table(
    stroke: none,
    columns: (10em, 15em),
    align: left,
    table.hline(start:0),
    table.header(
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*])
    ),
    table.hline(start: 0),
    [1) $T -> F T'$    ], [$T'.i n h = F.v a l                 $],
    [               ], [$T.v a l = T'.s y n                 $],
    [2) $T' -> *F T'_1$], [$T'_1.i n h = T'.i n h times F.v a l$],
    [               ], [$T'.s y n = T'_1.s y n              $],
    [3) $T' -> epsilon$], [$T'.s y n = T'.i n h                $],
    [4) $F ->$ *digit* ], [$F.v a l = bold("digit").l e x v a l$],
    table.hline(start: 0)
  )
  - La prima regola definisce l'attributo ereditato T′.inh usando solo l'attributo F.val, e F si trova a sx di T′, come richiesto.
  - La seconda regola definisce l'attributo T′1.inh usando l'attributo ereditato T′.inh associato alla parte sx della regola e F.val associato ad F che compare a sx di T′1 nella parte dx della regola.

  In entrambi i casi le regole utilizzano informazioni provenienti da sopra o da sinistra, come richiesto dalle definizioni L-attribuite. Gli altri attributi sono sintetizzati quindi questa SDD è L-attribuita.
]

=== Regole semantiche con effetti collaterali controllati

Ogni traduzione comporta effetti collaterali, ad esempio stampa di un risultato (calcolatrice), aggiunta di informazioni nella tavola dei simboli (compilatore). Le grammatiche ad attributi non hanno nessun effetto collaterale e gli attributi possono essere valutati secondo qualunque ordinamento che rispetti il grafo delle dipendenze. Gli schemi di traduzione impongono una valutazione da sx a dx e consentono azioni semantiche costituite da porzioni di codice. Nelle SDD si possono controllare gli effetti collaterali in due modi:

- permettere effetti collaterali incidentali che non pongono vincoli sulla valutazione degli attributi, qualsiasi ordine di valutazione coerente col grafo delle dipendenze produce una traduzione corretta;

#example()[
  Nella SDD per le espressioni (calcolatrice) possiamo sostituire la regola semantica $L."val" = E."val"$ associata alla produzione $L -> E n$ con $"print"(E."val")$ in modo che venga stampato il risultato. La SDD modificata produce la stessa traduzione seguendo un qualsiasi ordine topologico perché l'istruzione di stampa è eseguita per ultima dopo aver calcolato il valore di E.val. Regole semantiche di questo tipo equivalgono a definizioni di attributi sintetizzati fittizi associati alla parte sx della produzione.
]

- vincolare gli ordini di valutazione permessi in modo che la traduzione per ogni ordinamento sia comunque corretta. I vincoli possono essere visti come archi impliciti aggiunti al grafo delle dipendenze.

#example()[
  #table(
    stroke: none,
    columns: (10em, 15em),
    align: left,
    table.hline(start:0),
    table.header(
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*])
    ),
    table.hline(start: 0),
    [1) $D -> T L$      ], [_L.inh_ = _T.type_],
    [2) $T ->$ *int*    ], [_T.type_ = integer],
    [3) $T ->$ *float*  ], [_T.type_ = float],
    [4) $F -> L_1,$ *id*], [$L_1$_.type_ = _L.inh_],
    [                   ], [_addType_(*id*_.id_entry, L.inh_)],
    [5) $L ->$ *id*     ], [_addType_(*id*_.id_entry, L.inh_)],
    table.hline(start: 0)
  )
  Questa SDD rappresenta la dichiarazione D costituita da un tipo base T (che può essere int o float) seguito da una lista di identificatori L. Per ogni identificatore il tipo viene aggiunto al corrispondente elemento della tavola dei simboli. La variabile T ha un attributo T.type sintetizzato che può assumere i valori integer o float e che rappresenta il tipo della dichiarazione. L ha un attributo ereditato L.inh che serve per far passare il tipo dichiarato attraverso la lista di identificatori. Nella produzione 1 il valore di T.type passa a L.inh. Nella produzione 4 il valore di L.inh viene passato da un nodo padre al nodo figlio, verso il basso.
  Le produzioni 4 e 5 richiamano la funzione addType() con due argomenti
  + id.entry, valore lessicale, puntatore alla tavola dei simboli
  + L.inh , attributo che indica il tipo degli identificatori della lista
  
  #figure(diagram(
    node-stroke: none,
    cell-size: 5mm,
    spacing: 3mm,

    node(( 0, 0), [_D_]       , name: <d>    ),
    node((-3, 2), [_T_]       , name: <t>    ),
    node(( 3, 2), [_L_]       , name: <l1>   ),
    node(( 0, 4), [_L_]       , name: <l2>   ),
    node(( 3, 4), [*,*]       , name: <c1>   ),
    node(( 6, 4), $bold(id)_3$, name: <id1>  ),
    node((-3, 6), [_L_]       , name: <l3>   ),
    node(( 0, 6), [*,*]       , name: <c2>   ),
    node(( 3, 6), $bold(id)_2$, name: <id2>  ),
    node((-3, 4), [*float*]   , name: <float>),
    node((-3, 8), $bold(id)_1$, name: <id3>  ),

    edge(<d> , <t>    , dash: "dotted"),
    edge(<d> , <l1>   , dash: "dotted"),
    edge(<t> , <float>, dash: "dotted"),
    edge(<l1>, <l2>   , dash: "dotted"),
    edge(<l1>, <c1>   , dash: "dotted"),
    edge(<l1>, <id1>  , dash: "dotted"),
    edge(<l2>, <l3>   , dash: "dotted"),
    edge(<l2>, <c2>   , dash: "dotted"),
    edge(<l2>, <id2>  , dash: "dotted"),
    edge(<l3>, <id3>  , dash: "dotted"),

    node((-2.25, 2), $4$ , name: <4> ),
    node(( 2.25, 2), $5$ , name: <5> ),
    node(( 3.75, 2), $6$ , name: <6> ),
    node((-0.75, 4), $7$ , name: <7> ),
    node(( 0.75, 4), $8$ , name: <8> ),
    node(( 6.75, 4), $3$ , name: <3> ),
    node((-3.75, 6), $9$ , name: <9> ),
    node((-2.25, 6), $10$, name: <10>),
    node(( 3.75, 6), $2$ , name: <2> ),
    node((-2.25, 8), $1$ , name: <1> ),

    node((-1.50, 2), [_type_]),
    node(( 1.50, 2), [_inh_]),
    node(( 4.65, 2), [_entry_]),
    node((-1.50, 4), [_inh_]),
    node(( 1.50, 4), [_entry_]),
    node(( 7.50, 4), [_entry_]),
    node((-4.50, 6), [_inh_] ),
    node((-1.50, 6), [_entry_]),
    node(( 4.50, 6), [_entry_]),
    node((-1.50, 8), [_entry_]),

    edge(<4>, <5> , "-|>", bend: 30deg),
    edge(<5>, <6> , "-|>", bend: -45deg),
    edge(<5>, <7> , "-|>"),
    edge(<3>, <6> , "-|>"),
    edge(<7>, <8> , "-|>", bend: -45deg),
    edge(<7>, <9> , "-|>"),
    edge(<2>, <8> , "-|>"),
    edge(<9>, <10>, "-|>", bend: -45deg),
    edge(<1>, <10>, "-|>"),
  ), caption: "Grafo delle deipendenze per float " + $i d_1, i d_2, i d_3$)
  
  6, 8 e 10: attributi fittizi utilizzati per rappresentare le chiamate alla
  funzione addType().
]
== Applicazioni della traduzione guidata dalla sintassi
Poiché alcuni compilatori usano gli alberi sintattici come rappresentazione intermedia, una forma comune di SDD ha lo scopo di trasformare la stringa d'ingresso in un albero. Per completare la traduzione in codice intermedio, il compilatore quindi visita l'albero seguendo un nuovo insieme di regole che di fatto costituiscono un SDD associato all'albero sintattico o all'albero di parsing.

=== Costruzione degli alberi sintattici
È utile trasformare una stringa in ingresso in un albero che ne rappresenta la struttura e che può essere utilizzato come rappresentazione per la fase di traduzione. Questo albero viene detto *albero sintattico* ed è diverso dall'albero di parsing che rappresenta la derivazione di una stringa con una particolare grammatica.

#figure(grid(
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
), caption: "Albero sintattico a sx e alberi d parsing a dx")

Ogni nodo di un albero sintattico rappresenta un costrutto e i figli di tale nodo rappresentano le parti significative che lo compongono. Un nodo di un albero che rappresenta un'espressione del tipo $E_1 + E_2$ ha come etichetta il simbolo $+$ e come figli due nodi che rappresentano le sottoespressioni $E_1$ e $E_2$. I nodi di un albero sintattico possono essere implementati per mezzo di oggetti con un numero di campi variabile. Ogni oggetto ha un campo `op` che costituisce l'etichetta del nodo.
- Se il nodo è una foglia, ha un campo aggiuntivo che contiene il valore lessicale associato. Viene creato con un costruttore del tipo `Leaf(op, val)`.
- Un nodo interno ha tanti campi aggiuntivi quanti sono i nodi figli nell'albero sintattico. Viene creato con un costruttore `Node(op, c1, c2, ..., ck)`.

#example()[
  SDD S-attribuita per espressioni con $+$ e $-$ .
  #figure(
  table(
    stroke: none,
    columns: (.01fr, .04fr, .25fr, .7fr),
    align: left,
    table.hline(start:0),
    table.header(
      table.cell([]),
      table.cell([]),
      table.cell([*Produzione*]),
      table.cell([*Regole semantiche*])
    ),
    table.hline(start: 0),
    [ ], [1)], [$E -> E_1 + T $   ], [_E.node_ = *new*_ Node_('$+$', $E_1.$_node, T.node_)],
    [ ], [2)], [$E -> E_1 - T$    ], [_E.node_ = *new*_ Node_('$-$', $E_1.$_node, T.node_)],
    [ ], [3)], [$E -> T$          ], [_E.node_ = _T.node_],
    [ ], [4)], [$T -> (E)$        ], [_T.node_ = _E.node_],
    [ ], [5)], [$T ->$ *id*       ], [_T.node_ = *new* _Leaf_(*id*, *id*._entry_)],
    [ ], [6)], [$T ->$ *num*    ], [_T.node_ = *new* _Leaf_(*num*, *num*._val_)],
    table.hline(start: 0)
  ))
  Ogni volta che si usa la produzione $E -> E_1 + T$ (o $E -> E_1 - T$) la regola semantica crea un nodo con etichetta `op` = '+' (o '-') e i nodi figli $E_1$.node e $T$.node relativi alle due sottoespressioni. La regola associata a $E -> T$ (e a $T -> ( E )$ ) non crea nessun nodo perché $E$.node e $T$.node si riferiscono allo stesso nodo.

  #figure(diagram(
    node-stroke: none,
    cell-size: 0mm,
    spacing: 2mm,
    
    node((6, 0), [_E.node_], name: <l60>),
    
    node((2, 1), [_E.node_], name: <l21>),
    node((6, 1), [$+$]     , name: <l61>),
    node((8, 1), [_T.node_], name: <l81>),
    
    node((1, 2), [_E.node_], name: <l12>),
    node((2, 2), [$-$]     , name: <l22>),
    node((4, 2), [_T.node_], name: <l42>),
    node((8, 2), [*id*]    , name: <l82>),
    
    node((1, 3), [_T.node_], name: <l13>),
    node((4, 3), [*num*]   , name: <l43>),
    
    node((1, 4), [*id*]    , name: <l14>),
    node((4, 4), [$+$]     , name: <l44>),
    node((5, 4), [$"    "$], name: <l54>),
    node((6, 4), [$"    "$], name: <l64>),
    node(enclose: (<l44>, <l54>, <l64>), stroke: 0.5pt, inset: 1.5pt, name: <group1>),
    
    node((2, 8), [$+$]     , name: <l25>),
    node((3, 8), [$"    "$], name: <l35>),
    node((4, 8), [$"    "$], name: <l45>),
    node(enclose: (<l25>, <l35>, <l45>), stroke: 0.5pt, inset: 1.5pt, name: <group2>),
    node((8, 6), [*id*]    , name: <l85>),
    node((9, 6), [$"    "$], name: <l95>),
    node(enclose: (<l85>, <l95>), stroke: 0.5pt, inset: 1.5pt, name: <group3>),

    node((0, 10), [*id*]    , name: <l06>),
    node((1, 10), [$"    "$], name: <l16>),
    node(enclose: (<l06>, <l16>), stroke: 0.5pt, inset: 1.5pt, name: <group4>),
    node((6, 10), [*num*]   , name: <l66>),
    node((7, 10), [$4$]     , name: <l76>),
    node(enclose: (<l66>, <l76>), stroke: 0.5pt, inset: 1.5pt, name: <group5>),

    // GROUP SEPARATORS //
    edge((4.5, 3.55), (4.5, 4.8 ), dash: "dashed", stroke: gray, snap-to: none),
    edge((5.5, 3.55), (5.5, 4.8 ), dash: "dashed", stroke: gray, snap-to: none),
    edge((2.5, 7.3 ), (2.5, 8.7 ), dash: "dashed", stroke: gray, snap-to: none),
    edge((3.5, 7.3 ), (3.5, 8.7 ), dash: "dashed", stroke: gray, snap-to: none),
    edge((8.5, 5.3 ), (8.5, 6.7 ), dash: "dashed", stroke: gray, snap-to: none),
    edge((0.5, 9.3 ), (0.5, 10.7), dash: "dashed", stroke: gray, snap-to: none),
    edge((6.5, 9.3 ), (6.5, 10.7), dash: "dashed", stroke: gray, snap-to: none),
    
    // EDGE a puntini //
    edge(<l60>, <l21>, dash: "dotted"),
    edge(<l60>, <l61>, dash: "dotted"),
    edge(<l60>, <l81>, dash: "dotted"),

    edge(<l21>, <l12>, dash: "dotted"),
    edge(<l21>, <l22>, dash: "dotted"),
    edge(<l21>, <l42>, dash: "dotted"),
    
    edge(<l12>, <l13>, dash: "dotted"),
    edge(<l13>, <l14>, dash: "dotted"),
    
    edge(<l42>, <l43>, dash: "dotted"),
    
    edge(<l81>, <l82>, dash: "dotted"),

    // EDGES trattegiati //
    edge(<l21>, <2)
    edge(<l12>, <group4.north-west>, dash: "dashed", "-|>", bend: -30deg),
    edge(<l13>, (0.2, 10), dash: "dashed", "-|>", bend: -30deg, snap-to: (<l13>, <group4>)),
  ), caption: "Albero sintattico per a - 4 + c")
  #figure(image("images/2025-11-17-10-18-02.png"), caption: "Albero sintattico per a - 4 + c")
  Se le regole vengono eseguite nell'ordine definito da una visita in postordine dell'albero di parsing o secondo un parsing bottom-up si ha la sequenza di passi
  + `p1 = new Leaf(id, entry-a)`;
  + `p2 = new Leaf(num, 4)`;
  + `p3 = new Node('−', p1, p2)`;
  + `p4 = new Leaf(id, entry-c)`;
  + `p5 = new Node('+', p3, p4)`;
  e `p5` è un puntatore alla radice dell'albero sintattico.
]

#example()[
  SDD L-attribuita per espressioni con + e - per la stringa a - 4 + c.
  #figure(image("images/2025-11-17-10-20-07.png"))
  Questa grammatica, adatta per il parsing top-down, produce lo stesso risultato, con gli stessi passi. Si ottiene lo stesso albero sintattico anche se l'albero di parsing è molto diverso. La variabile $E'$ ha un attributo ereditato *inh* e un attributo sintetizzato *syn*. L'attributo ereditato $E'$.inh rappresenta la porzione di albero sintattico costruita fino ad un certo punto, cioè la radice del sottoalbero corrispondente al prefisso della stringa d'ingresso relativa alla porzione di albero che si trova a sinistra di $E'$. Al nodo 5 del grafo delle dipendenze $E'$.inh rappresenta la radice del sottoalbero sintattico corrispondente all'identificatore $a$. Al nodo 6 $E'$.inh indica la radice del sottoalbero sintattico corrispondente alla stringa $a - 4$. Al nodo 9 $E'$.inh rappresenta l'albero sintattico corrispondente alla stringa $a - 4 + c$. Poiché la stringa in ingresso è terminata, $E'$.inh al nodo 9 punta alla radice dell'intero albero sintattico. L'attributo syn propaga tale valore fino all'attributo $E$.node.

  #figure(image("images/2025-11-17-10-20-25.png"), caption: "Grafo delle dipendenze per a - 4 + c")
]


== Schemi di traduzione guidati dalla sintassi
Gli schemi di traduzione guidati dalla sintassi sono una notazione complementare alle definizioni guidate dalla sintassi.

#definition()[
  Uno *schema di traduzione guidato dalla sintassi o SDT* (Syntax-Directed Translation scheme) è una grammatica libera dal contesto avente frammenti di programma contenuti nel corpo delle produzioni. Tali porzioni di programma sono dette azioni semantiche e possono apparire in una qualsiasi posizione nel corpo di una produzione.
]
Per convenzione notazionale le azioni semantiche sono racchiuse tra parentesi graffe; qualora le parentesi graffe fossero simboli appartenenti alla grammatica in esame, le si rappresenterebbe tra virgolette. Qualsiasi schema di traduzione guidato dalla sintassi può essere realizzato costruendo in primo luogo un albero di parsing, quindi procedendo all'esecuzione delle azioni da sinistra a destra e in profondità (depth-first), ovvero durante una visita in preordine.

Consideriamo gli SDT necessari per realizzare le classi di SDD per
cui:
+ la grammatica sottostante può essere riconosciuta da un parser LR e la SDD è S-attribuita;
+ la grammatica sottostante può essere riconosciuta da un parser LL e la SDD è L-attribuita.
Le regole semantiche di una SDD possono essere convertite in uno SDT le cui azioni sono eseguite al momento opportuno. Durante il parsing, un'azione semantica presente nel corpo di una produzione viene eseguita appena tutti i simboli alla sua sinistra sono stati consumati.
Gli SDT che possono essere implementati durante il parsing possono essere caratterizzati introducendo dei *non-terminali marcatori* (con una sola produzione $M -> epsilon$) al posto di ogni azione
Se la grammatica arricchita con i non-terminali marcatori puo essere trattata da un dato metodo di parsing, allora lo schema di traduzione corrispondente pud essere implementato durante il parsing.

=== Schemi di traduzione postfissi
Quando la grammatica può essere analizzata con una tecnica bottom-up e la SDD è S-attribuita si può costruire uno SDT in cui tutte le azioni semantiche di trovano alla fine delle produzioni e vengono eseguite nel momento in cui si effettua una riduzione utilizzando la regola.

#definition()[
  Gli SDT in cui tutte le azioni compaiono *all'estremità destra* del
  corpo delle produzioni sono detti *SDT postfissi*.
]

#example()[
  #figure(image("images/2025-11-19-18-55-32.png"))
  //TODO: convertire
  #table(
    columns: 2,
    stroke: none,
    [Produzioni], [Azioni semantiche],
    [$L->E n$], [{print(E.val);}],
    [$E-> E_1 +T$], [{E.val = $E_1$.val + T.val}],
    [$E-> T$], [],
    [$T-> T_1 * F$], [],
    [$T->F$], [],
    [$F->(E)$], [],
    [$F->"digit"$], [],
  )
  Questo è il SDT postfisso che implementa la SDD della calcolatrice, con l'unica differenza di stampare un valore. La grammatica è LR e la SDD è S-attribuita, quindi le azioni semantiche dello SDT possono essere eseguite contestualmente alle riduzioni del parser.
]

=== Implementazione degli SDT basata sugli stack del parser

Gli SDT postfissi possono essere implementati durante il parsing LR eseguendo le azioni ogniqualvolta si effettua una riduzione. Gli attributi di ogni simbolo grammaticale possono essere messi sullo stack, in una posizione in siano recuperabili durante la riduzione. La migliore strategia consiste nel porre sullo stack gli attributi assieme ai simboli grammaticali (0 agli stati LR che rappresentano i simboli), memorizzandoli nei campi di un record.

#example()[
  #figure(image("images/2025-11-19-19-06-55.png"))
  La Figura 5.19 mostra lo stack di un parser i cui elementi sono record aventi un campo per memorizzare il simbolo grammaticale (0 lo stato del parser) e un secondo campo (mostrato in basso) per memorizzare un attributo. I tre simboli grammaticali X, Y e Z si trovano sulla cima dello stack e potrebbero essere pronti per essere ridotti mediante una produzione del tipo A + XYZ.
]

In generale possiamo permettere la presenza di più attributi per ogni simbolo sia definendo un record di maggiori dimensioni sia mettendo sullo stack i puntatori ai record piuttosto che i record stessi. Se tutti gli attributi sono sintetizzati e le azioni compaiono alla fine delle produzioni, possiamo calcolare il valore degli attributi associati alla parte sx di una produzione quando si fa una riduzione. Se, ad esempio, riduciamo con una regola A → XYZ, tutti gli attributi per X, Y e Z sono disponibili e si trovano in posizioni note nella pila; dopo la riduzione, A e i suoi attributi si troveranno in cima allo stack.

#example()[
  SDT per la stessa grammatica dell'esempio precedente in cui lo stack viene manipolato esplicitamente. Lo stack è realizzato con un array stack e un indice top che ne indica la cima. stack[top] si riferisce al record in testa alla pila, stack[top−1] alrecord sottostante. Supponiamo che ogni record abbia un campo val che contiene il valore dell'attributo. Ad esempio se E si trova nella terza posizione dalla cima della pila, stack[top−2].val corrisponde a E.val.
  #figure(image("images/2025-11-19-19-09-13.png"))
]

#example()[
  Si utilizza la tabella di parsing SRL (già vista) per il parsing della stringa 3 \* ( 5 + 2 ). I record nella pila sono costituiti da due campi: quello che contiene il simbolo grammaticale caratteristico dello stato dell'automa LR(0) e quello che contiene il valore dell'attributo. Si assume che quando il parser impila un digit, il token d viene posto nel primo campo e il suo attributo nel secondo.
  #figure(image("images/2025-11-19-19-09-50.png"))
]

=== Schemi di traduzione con azioni interne alle produzioni

=== Eliminazione della ricorsione sinistra dagli SDT

//20.11.2025
=== Schemi di traduzione per definizioni L-attribuite
Consideriamo ora il caso più generale di una SDD L-attribuita. Assumeremo che la grammatica sottostante possa essere analizzata top-down, poiché in caso contrario accade spesso che sia impossibile effettuare la trasformazione appoggiandosi a un parser LL o LR.

Le regole per trasformare una SDD L-attribuita in uno SDT sono le seguenti.

1. Si aggiungano le azioni che calcolano gli attributi ereditati di un non-terminale A immediatamente prima dell'occorrenza di A nel corpo della produzione.
2. Si aggiungano le azioni che calcolano un attributo sintetizzato relativo alla testa di una produzione alla fine del corpo di quella produzione.

#example()[
  $S —> "while" (C) S_1$\
  Useremo i seguenti attributi per generare il codice intermedio richiesto.

  1. L'attributo ereditato S.next indica l'etichetta relativa all'inizio del codice che deve essere eseguito dopo che S é terminato.

  2. L'attributo sintetizzato S.code é la porzione di codice intermedio che implementa uno statement S e termina con un salto a S.next.

  3. L'attributo ereditato C.true indica l'etichetta relativa all'inizio del codice chedeve essere eseguito se C risulta vera.

  4. L'attributo ereditato C.false indica l'etichetta relativa all'inizio del codice che deve essere eseguito se C risulta falsa.

  5. L'attributo sintetizzato C.code rappresenta la porzione di codice intermedio che implementa la condizione C e che salta a C.true oppure C.false a seconda del valore dell'espressione C.

  #figure(image("images/2025-11-20-10-56-43.png"), caption: "SDD")
  Alcuni punti meritano un approfondimento.
  - La funzione new() genera nuove etichette.
  - Le variabili L1 e L2 mantengono memorizzate le etichette di cui abbiamo bisogno nel codice. In particolare, L1 indica l'inizio del codice relativo allo statement while e dobbiamo fare in modo che il codice per $S_1$ alla fine salti a questa etichetta. Questo è il motivo per cui assegnamo il valore L1 a $S_1$.next. Inoltre, L2 indica l'inizio del codice relativo a $S_1$ e deve essere il valore di C.true, poiché è appunto lì che bisogna saltare quando l'espressione C risulta vera.
  - Assegnamo poi a C.false il valore di S.next; questo poiché quando la condizione risulta falsa dobbiamo eseguire il codice che segue quello relativo allo statement S in esame.
  - Usiamo il simbolo || per indicare il concatenamento di frammenti di codice intermedio. Il valore di S.code, quindi, inizia con l'etichetta L1, seguita dal codice relativo alla condizione C, seguito dall'altra etichetta L2 e terminato dal codice relativo a Sj.
  //TODO:vedi disegno su appunti
  Applicando le regole di traduzione, si ottiene la seguente SDT
  #figure(image("images/2025-11-20-11-08-42.png"))
]

== Implementazione di SDD L-attribuite
Poiché molte applicazioni legate alla traduzione possono essere sviluppate basandosi su definizioni L-attribuite, andiamo a vedere in cosa consiste la loro implementazione. Un primo gruppo di metodi realizza la traduzione durante la visita di un albero di parsing.
+ Costruzione di un albero di parsing annotato. Questo metodo funziona per qualsiasi SDD non circolare.
+ Costruzione dell'albero di parsing, aggiunta delle azioni e loro esecuzione in preordine. Questa tecnica pud essere applicata a qualsiasi definizione L-attribuita.

Verrano adesso introdotti altri quattro metodi per effettuare la traduzione durante il parsing:
+ Utilizzo di un parser a discesa ricorsiva con una funzione per ogni non-terminale.
+ Generazione del codice al volo.
+ Implementazione di uno SDT insieme a un parser LL.
+ Implementazione di uno SDT insieme a un parser LR.

=== Traduzione durante il parsing a discesa ricorsiva
E' possibile estendere un tale parser e trasformarlo in un traduttore facendo in modo che:
+ gli argomenti di A() siano gli attributi ereditati del simbolo non-terminale A;
+ il valore restituito da A() sia l'insieme degli attributi sintetizzati del simbolo A.
Il corpo della funzione A() deve occuparsi sia del parsing, sia della gestione degli
attributi; in particolare, la funzione deve:
+ decidere quale produzione utilizzare per espandere A;
+ verificare che ogni simbolo terminale appaia in ingresso quando é richiesto;
+ conservare in variabili locali i valori di tutti gli attributi necessari per il calcolo degli attributi ereditati relativi ai non-terminali nel corpo della produzione e/o degli attributi sintetizzati relativi al non-terminale alla testa della produzione;
+ chiamare le funzioni corrispondenti ai non-terminali nel corpo della produzioneselezionata e passare a tali funzioni gli argomenti corretti;

#example()[
  Consideriamo la SDD e lo SDT relativi allo statement while. Il seguente è un'implementazione di esso mediante un parser a discesa ricorsiva.
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
  //TODO: aggiungere altro?
]
//TODO: esempi da appunti?

=== Generazione del codice al volo
La costruzione esplicita di lunghe stringhe di codice come valore degli attributi — vedere esempio precedente — non è desiderabile per diverse ragioni, tra cui l'eccessivo tempo richiesto per copiare o spostare le stringhe. In molti casi comuni, tra cui l'esempio di generazione del codice del costrutto while, è possibile costruire incrementalmente porzioni di codice e memorizzarle in un array o in un file mediante opportune azioni dello SDT. Per fare ciò, le seguenti condizioni devono essere soddisfatte:

+ Per uno o più terminali esiste un attributo principale. Per semplicita assumeremo che gli attributi principali siano tutti di tipo stringa. Nell'esempio di prima, S.code e C.code sono attributi principali, mentre tutti gli altri non lo sono.

+ Gli attributi principali sono sintetizzati.

+ Le regole per la valutazione degli attributi principali garantiscono che:

  - L'attributo principale è dato dal concatenamento degli attributi principali dei non-terminali che appaiono nel corpo della produzione pit, eventualmente, altri elementi che non sono attributi principali, quali la stringa costante label o i valori delle etichette D1 e L2;
  - Gli attributi principali dei non-terminali appaiono nella regola nello stesso ordine in cui i non-terminali appaiono nel corpo della produzione.

Tali condizioni implicano che l'attributo principale pud essere costruito emettendo solamente gli elementi del concatenamento che non sono attributi principali.

#example()[
  Possiamo modificare la funzione _S_ precedentemente descritta in modo che emetta gli elementi dell'attributo principale S.code invece di salvarli per poi concatenarli nel valore di S.code che verra poi restituito.
  #figure(image("images/2025-11-27-15-16-21.png"))
  Le funzioni S() e C() non restituiscono alcun valore, poiché tutti i loro attributi sintetizzati sono prodotti mediante stampa. Inoltre, la posizione delle istruzioni di stampa nella funzione è importante. L'ordine in cui i vari elementi vengono stampati è il seguente: per prima cosa la stringa "label"L1, quindi il codice relativo al non-terminale C (che coincide con il valore della variabile Ccode), la stringa "label" L2, e infine il codice derivante dalla chiamata ricorsiva della funzione S) (ovvero il valore della variabile Scode).
]
#example()[
  Possiamo fare lo stesso tipo di modifica direttamente sullo SDT sottostante sostituendo le azioni che costruiscono un attributo principale in azioni che emettono gli elementi che compongono tale attributo.
  #figure(image("images/2025-11-27-15-18-21.png"))
]
=== Definizioni L-attribuite e parsing LL
Oltre ai record che rappresentano i terminali e i non-terminali della grammatica, lo stack del parser conterra action-record, cioé record relativi alle azioni, che saranno eseguiti e synthesize-record, ovvero record destinati a salvare gli attributi sintetizzati dei non-terminali. Per gestire gli attributi sullo stack ci baseremo sui seguenti principi.

- Gli attributi ereditati di un non-terminale A sono memorizzati sullo stack, nel record che rappresenta il non-terminale. Il codice necessario per la valutazione di tali attributi é in genere rappresentato mediante un action-record memorizzato sullo stack, immediatamente al di sopra del record che rappresenta A. E infatti il meccanismo di conversione di una SDD L-attribuita in uno schema di traduzione guidato dalla sintassi ad assicurare che l'action-record di A sia immediatamente al di sopra del record di A.
- Gli attributi sintetizzati relativi al non-terminale A sono memorizzati in un synthesize-record separato e posizionato sullo stack immediatamente al di sotto del record relativo ad A.
