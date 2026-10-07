#import "../../../dvd.typ": *
#import "@preview/algo:0.3.6": algo, code, comment, d, i
#import "@preview/fletcher:0.5.8": diagram, edge, node
#pagebreak()

= Traduzione guidata dalla sintassi
L'*idea di base* della traduzione guidata dalla sintassi è quella di *associare informazioni* a un costrutto di un linguaggio aggiungendo *attributi* ai simboli della grammatica che rappresentano tale costrutto. Una definizione guidata dalla sintassi specifica i valori assunti dagli attributi per mezzo di regole semantiche associate alle produzioni.

== Definizioni guidate dalla sintassi
#definition()[Una *definizione guidata dalla sintassi* o *SDD (Syntax-Directed Definition)* è una grammatica *context-free* alla quale vengono aggiunti *attributi* e *regole semantiche*.

  - *Attributi:* sono associati ai simboli della grammatica. Possono essere di qualunque tipo, come numeri, tipi, tabelle, riferimenti o stringhe (frammenti di codice). Dato un simbolo della grammatica $X$ e un suo attributo $a$, la notazione $X.a$ indica il valore di $a$ per un nodo dell'albero di parsing etichettato con $X$. Gli attributi possono essere di qualunque tipo: numeri, tipi, tabelle, riferimenti, stringhe (frammenti di codice)...

  - *Regole semantiche:* sono associate alle produzioni della grammatica e specificano come calcolare il valore degli attributi.
]

La tecnica generale della traduzione guidata dalla sintassi consiste nel consiste nel costruire un albero di parsing data la stringa di input e quindi calcolare i valori degli attributi associati ai nodi durante una visita dell'albero.

=== Attributi ereditati e sintetizzati
Per i simboli non-terminali ci sono due tipi di attributi:

+ *Attributi sintetizzati*: un attributo di una variabile $A$ relativo ad un nodo $N$ dell'albero di parsing è detto sintetizzato se è definito da una regola semantica associata alla produzione relativa al nodo $N$ (quindi una produzione con parte sinistra $A$). Un attributo sintetizzato relativo ad un nodo $N$ è calcolato unicamente in base ai valori degli attributi dei *figli* di $N$ e di $N$ stesso.

+ *Attributi ereditati*: un attributo di una variabile $B$ relativo ad un nodo $N$ dell'albero di parsing è detto ereditato se è definito dalla regola semantica associata alla produzione relativa al nodo *padre* di $N$. Tale produzione deve contenere $B$ nella parte destra. Un attributo ereditato relativo ad un nodo $N$ è definito unicamente in base agli attributi del padre di $N$, di $N$ stesso e dei *fratelli* di $N$.

#observation()[
  - Un attributo ereditato relativo al nodo $N$ non può essere definito in base ai valori degli attributi dei figli di $N$ (altrimenti si creerebbe un paradosso circolare di dipendenza).
  - Un attributo sintetizzato relativo al nodo $N$ può essere definito anche in base ai valori degli attributi ereditati relativi a $N$ stesso.
  I simboli terminali:
  - Possono avere solo attributi sintetizzati (es. `text("digit")."lexval"`, che rappresenta il valore intrinseco fornito direttamente dallo scanner lessicale).
  - *Non possono* avere attributi ereditati.
Non sono previste regole semantiche per il calcolo del valore degli attributi dei terminali. Questi valori vengono forniti dall'analizzatore lessicale.
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
  )
  Questa è la SDD di una semplice calcolatrice, che valuta le espressioni con $+$ e $*$ terminate da uno speciale marcatore di fine riga, che indichiamo con $bold(text("n"))$. Nella SDD ognuno dei non-terminali ha *un unico attributo sintetizzato* chiamato _val_. Supponiamo inoltre che il terminale $bold(text("digit"))$ abbia un attributo sintetizzato _lexval_ (il valore numerico intero restituito dall'analizzatore lessicale). Il pedice nei simboli (es. $E_1$) distingue l'occorrenza del simbolo nel corpo da quella nella testa della derivazione. 

  - La regola per la produzione 1, $L -> E text("n")$, assegna a $L.italic("val")$ il valore dell'intera espressione $E.italic("val")$.
  - La produzione 2, $E -> E_1 + T$, ha una regola che calcola il valore dell'attributo $italic("val")$ della testa della produzione $E$ come somma dei valori associati ai simboli del corpo, $E_1$ e $T$. A ogni nodo $N$ dell'albero di parsing con etichetta $E$ il valore dell'attributo _val_ associato a $E$ è la somma dei valori di _val_ associati ai nodi figli di $N$ etichettati con $E$ e $T$.
  - La produzione 3, $E -> T$, stabilisce semplicemente che il valore di $E.italic("val")$ è uguale al valore del nodo figlio $T.italic("val")$.
  - La produzione 4 ($T -> T_1 * F$) è analoga alla seconda, ma esegue il prodotto.
  - Le produzioni 5 e 6 copiano i valori associati al nodo figlio verso l'alto.
  - Infine, la produzione 7 assegna a $F.italic("val")$ il valore di una cifra (_lexval_), un valore numerico associato al token $bold(text("digit"))$ restituito dall'analizzatore lessicale.
]

=== Valutazione di una SDD ai nodi di un albero di parsing
Per visualizzare il processo di traduzione specificato mediante una SDD è molto utile ricorrere agli alberi di parsing (anche se, nella pratica, un traduttore ottimizzato non necessita della costruzione esplicita dell'albero in memoria). Immaginiamo quindi che le regole di una SDD siano utilizzate prima per costruire l'albero di parsing, e poi vengano utilizzate per calcolare il valore degli attributi associati ai nodi dell'albero. Un albero che mostra anche i valori calcolati degli attributi nei vari nodi è detto *albero di parsing annotato*.

Come costruiamo un albero di parsing annotato? In che ordine valutiamo gli attributi? Prima di poter valutare un attributo di un nodo, dobbiamo necessariamente aver prima valutato tutti gli attributi da cui esso dipende.

- Se in una SDD *tutti* gli attributi sono *sintetizzati* (come nell'esempio precedente), prima di poter calcolare l'attributo di un nodo padre dobbiamo calcolare gli attributi dei suoi figli. Possiamo quindi procedere tranquillamente dal basso verso l'alto (bottom-up), ad esempio effettuando una classica visita dell'albero in *post-ordine*.
- Nel caso di SDD che presentano attributi sia sintetizzati che ereditati, l'ordine di valutazione si complica, e in realtà non è possibile garantire sempre l'esistenza di un ordine di valutazione.
Vediamo esempi per tutti i casi.

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
  Questo è l'albero di parsing annotato per la stringa $3 * 5 + 4bold(text("n"))$, costruito utilizzando la grammatica e le regole viste in precedenza. Si suppone che i valori dell'attributo _lexval_ siano forniti dall'analizzatore lessicale. Ogni nodo relativo a una variabile ha un attributo _val_: questi sono calcolati in ordine bottom-up.
]

#example()[
  Gli *attributi ereditati* sono utili quando la struttura dell'albero di parsing non rispecchia direttamente le operazioni da eseguire. Consideriamo una versione ridotta della grammatica delle espressioni, che genera prodotti di cifre:
  $
    T &-> F | T * F \
    F &-> bold("digit")
  $
  Eliminando la ricorsione sinistra per consentire l'analisi top-down, otteniamo:
  $
    T &-> F T' \
    T' &-> * F T' | epsilon \
    F &-> bold("digit")
  $

  Consideriamo la stringa $3 * 5$. La produzione iniziale è $T -> F T'$: il primo $F$ genera la cifra $3$, mentre $T'$ genera il resto $* 5$. Quindi l'*operando sinistro* di $*$ si trova nel sottoalbero del fratello di $T'$, anziché in un suo sottoalbero. Per rendere disponibile questo valore a $T'$ utilizziamo un *attributo ereditato*.

  Associamo ai simboli i seguenti attributi:
  - I non-terminali $T$ e $F$ hanno un attributo *sintetizzato* _val_, che rappresenta il valore del termine o del fattore.
  - Il terminale *digit* ha un attributo *sintetizzato* _lexval_, fornito dall'analizzatore lessicale.
  - Il non-terminale $T'$ ha un attributo *ereditato* _inh_, che contiene il prodotto accumulato alla sua sinistra, e un attributo *sintetizzato* _syn_, che restituisce il risultato dopo aver considerato anche i fattori generati da $T'$.

  #figure(
    table(
      stroke: none,
      columns: (.05fr, .35fr, .6fr),
      align: left,
      table.hline(start: 0),
      table.header(
        [],
        [*Produzione*],
        [*Regole semantiche*],
      ),
      table.hline(start: 0),
      [1)], [$T -> F T'$],
      [$T'.i n h = F.v a l$],
      [], [],
      [$T.v a l = T'.s y n$],

      [2)], [$T' -> * F T'_1$],
      [$T'_1.i n h = T'.i n h times F.v a l$],
      [], [],
      [$T'.s y n = T'_1.s y n$],

      [3)], [$T' -> epsilon$],
      [$T'.s y n = T'.i n h$],

      [4)], [$F -> bold("digit")$],
      [$F.v a l = bold("digit").l e x v a l$],
      table.hline(start: 0),
    ),
  )

  Come detto in precedenza, il pedice in $T'_1$ serve per distinguere l'occorrenza nel corpo della produzione da quella nella testa: entrambe rappresentano lo stesso non-terminale $T'$.

  Le regole semantiche realizzano il calcolo nel seguente modo:

  - La produzione 1 *inizializza* l'attributo ereditato di $T'$ con il valore del primo fattore. Il risultato restituito da $T'$ viene poi assegnato a $T.v a l$.
  - La produzione 2 *accumula* un altro fattore: moltiplica il valore ereditato $T'.i n h$ per $F.v a l$ e passa il prodotto al figlio $T'_1$. Il risultato restituito da quest'ultimo viene copiato in $T'.s y n$.
  - La produzione 3 conclude il calcolo: non essendoci altri fattori, il risultato coincide con il valore accumulato, quindi $T'.s y n = T'.i n h$.
  - La produzione 4 assegna a $F.v a l$ il valore numerico della cifra fornito dall'analizzatore lessicale.

  Per esempio, nel termine $3 * 5 * 7$, il primo $T'$ eredita $3$, il successivo eredita $3 times 5 = 15$ e l'ultimo eredita $15 times 7 = 105$. Quando si applica la produzione $T' -> epsilon$, il valore $105$ viene copiato nell'attributo _syn_ e propagato verso l'alto fino a $T.v a l$.

  Per la stringa $3 * 5$ otteniamo il seguente *albero di parsing annotato*:
  #figure(diagram(
    node-stroke: none,
    cell-size: 5mm,
    spacing: 3mm,

    node((2, 0), [$T.v a l = 15$], name: <t>),
    node((0, 1), [$F.v a l = 3$], name: <f-left>),
    node((3, 1), [
      $T'.i n h = 3$ \
      $T'.s y n = 15$
    ], name: <tp>),

    node((0, 2), [
      $bold("digit").l e x v a l = 3$
    ], name: <digit-left>),
    node((1, 2), $*$, name: <mul>),
    node((2, 2), [$F.v a l = 5$], name: <f-right>),
    node((4, 2), [
      $T'_1.i n h = 15$ \
      $T'_1.s y n = 15$
    ], name: <tp-end>),

    node((2, 3), [
      $bold("digit").l e x v a l = 5$
    ], name: <digit-right>),
    node((4, 3), $epsilon$, name: <eps>),

    edge(<t>, <f-left>),
    edge(<t>, <tp>),
    edge(<f-left>, <digit-left>),
    edge(<tp>, <mul>),
    edge(<tp>, <f-right>),
    edge(<tp>, <tp-end>),
    edge(<f-right>, <digit-right>),
    edge(<tp-end>, <eps>),
  ))

  Un possibile ordine di valutazione è il seguente:

  + Dalla cifra $3$ si ottiene $F.v a l = 3$, che viene passato al fratello destro mediante la regola $T'.i n h = F.v a l = 3$.
  + Dalla cifra $5$ si ottiene $F.v a l = 5$. Si calcola quindi l'attributo ereditato del successivo $T'$:
    $
      T'_1.i n h = T'.i n h times F.v a l
      = 3 times 5 = 15.
    $
  + Il nodo $T'_1$ utilizza la produzione $T' -> epsilon$, per cui il valore accumulato diventa il risultato:
    $
      T'_1.s y n = T'_1.i n h = 15.
    $
  + Il risultato risale fino alla radice mediante gli attributi sintetizzati:
    $
      T'.s y n = T'_1.s y n = 15,
      quad T.v a l = T'.s y n = 15.
    $

  In questo esempio, quindi, gli attributi *ereditati* trasportano verso il basso il prodotto parziale, mentre gli attributi *sintetizzati* riportano verso l'alto il risultato finale.
]

== Ordine di valutazione delle SDD

I *grafi delle dipendenze* sono uno strumento utile per determinare un ordine di valutazione delle varie istanze degli attributi in un dato albero di parsing.
Mentre un albero di parsing mostra solo *quali* sono i valori degli attributi, un grafo delle dipendenze ci indica *come e in che ordine* tali valori devono essere calcolati: rappresenta il flusso di informazioni attraverso gli attributi di un particolare albero di parsing

=== Grafi delle dipendenze
Un arco diretto da un'istanza di un attributo a un'altra indica che il valore del primo attributo è richiesto per calcolare il valore del secondo. Gli archi esprimono fisicamente i vincoli implicati dalle regole semantiche. Più precisamente:

- Per ogni nodo dell'albero di parsing etichettato con un simbolo $X$, nel grafo delle dipendenze esiste un nodo per ogni attributo di $X$.

- Se una regola semantica associata a una produzione $A -> alpha X beta$ definisce il valore di un attributo sintetizzato $A.b$ in funzione di un attributo $X.c$ (ed eventualmente di altri), cioè $A.b = f(..., X.c,...)$, allora il grafo delle dipendenze contiene un arco orientato da $X.c$ a $A.b$.

- Consideriamo una regola semantica associata ad una regola del tipo $X -> alpha B beta$ oppure $Y -> alpha X beta B gamma$ che definisce un attributo ereditato $B.c$ in funzione di un attributo $X.a$ (ed eventualmente di altri), cioè $B.c = f(..., X.a,...)$, allora il grafo delle dipendenze contiene un arco orientato da $X.a$ a $B.c$. Per ogni nodo $N$ con etichetta $B$, corrispondente all'occorrenza di $B$ nella parte destra della regola $X -> alpha B beta$ o $Y -> alpha X beta B gamma$, si deve creare un arco orientato dall'attributo $a$ associato al nodo $M$ corrispondente all'istanza di $X$ verso l'attributo $c$ del nodo $N$ ($M$ può essere padre o fratello di $N$).

#example()[
  Si consideri la seguente produzione e la relativa regola semantica:
  $
    E->E_1 + T quad quad quad quad E.v a l = E_1.v a l + T.v a l
  $
  Per ogni nodo $N$ con etichetta $E$ (parte sinistra della regola), l'attributo sintetizzato _val_ è calcolato utilizzando i valori degli attributi _val_ corrispondenti ai due figli con etichette $E$ e $T$. La corrispondente porzione del grafo delle dipendenze di ogni albero di parsing in cui una tale produzione è utilizzata ha questa forma:
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
  Gli archi dell'albero di parsing sono illustrati con linee trattegiate, gli archi del grafo delle dipendenze con linee continue.
]

#example()[
  Vediamo un esempio di grafo delle dipendenze completo analizzando la grammatica per il prodotto tra $n$ fattori (che aveva sia attributi sintetizzati che ereditati) vista in un esempio precedente. I nodi del grafo delle dipendenze sono numerati da 1 a 9 e corrispondon agli attributi mostrati nell'albero di parsing dell'esempio precedente.
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
Il grafo delle dipendenze caratterizza ogni possibile ordine di
valutazione degli attributi associati ai nodi di un albero di parsing. Se c'è un arco da un nodo $M$ ad un nodo $N$, allora l'attributo
associato a $M$ deve essere valutato prima di quello associato a $N$.
#definition("Ordinamento topologico")[
  Gli unici ordinamenti validi per la valutazione sono costituiti da sequenze di nodi $N_1, N_2, dots, N_k$, tali che, se esiste un arco dal nodo $N_i$ al nodo $N_j$ nel grafo delle dipendenze, allora deve necessariamente essere $i < j$. Un ordinamento che rispetta questa proprietà è detto *ordinamento topologico*.
]

Se il grafo contiene un ciclo (una dipendenza circolare), allora *non esiste* alcun ordinamento topologico possibile, e quindi non c'è modo di valutare gli attributi della SDD di un dato albero di parsing. Viceversa, se il grafo non presenta cicli, allora esiste sempre almeno un ordinamento topologico valido per completare l'analisi semantica. 
Nell'esempio precedente, oltre a 1-9, anche 1, 3, 5, 2, 4, 6, 7, 8, 9 è un ordinamento valido.

=== Definizioni S-attribuite
Esistono classi specifiche di SDD per cui è garantito che i grafi delle dipendenze non conterranno *mai* cicli, indipendentemente dall'albero di parsing generato.

#definition()[
  Una SDD è detta *S-attribuita* se e solo se ogni suo attributo è sintetizzato. In una SDD S-attribuita ogni regola calcola un attributo associato alla variabile della parte *sinistra* della produzione a partire dagli attributi associati ai simboli della parte *destra*.
]

Per una SDD S-attribuita si possono valutare gli attributi secondo un qualsiasi ordinamento bottom-up dei nodi dell'albero di parsing, ad esempio visitando l'albero in postordine e valutando gli attributi associati ad un nodo quando questo viene visitato (quando viene lasciato per l'ultima volta). Ovvero si applica la seguente funzione a partire dalla radice dell'albero di parsing:
```c
postorder(N) {
  for ( ogni figlio C di N, da sinistra a destra )
    postorder(C);
  valuta gli attributi associati al nodo N;
}
```

Le definizioni S-attribuite sono estremamente efficienti perché possono essere implementate "al volo" durante il parsing bottom-up. Una visita in post-ordine, infatti, corrisponde esattamente all'ordine cronologico in cui un parser LR effettua le operazioni di _reduce_ (la riduzione della maniglia/parte destra di una regola  alla variabile della parte sinistra).

=== Definizioni L-attribuite

#definition()[
  Una SDD è detta *L-attribuita* se tra gli attributi associati al corpo di una produzione possono esistere archi del grafo delle dipendenze orientati solo da sinistra verso destra e non viceversa.
]

Più precisamente, in una SDD L-attribuita, ogni attributo può essere:

+ *Sintetizzato*, oppure
+ *Ereditato*, purché rispetti le regole seguenti:

  se $A -> X_1 X_2 dots X_n$ è una produzione a cui è associata una regola semantica che calcola il valore di un attributo ereditato $X_i.a$, allora tale regola può utilizzare *soltanto*:

  - attributi ereditati associati alla parte sinistra della regola, $A$ (informazioni provenienti dall'alto);
  - attributi ereditati e sintetizzati associati alle occorrenze dei simboli $X_1, X_2, dots, X_(i-1)$ che compaiono *a sinistra* di $X_i$ nel corpo della regola;
  - attributi ereditati e sintetizzati associati alla stessa occorrenza di $X_i$ in esame, purché non comportino cicli.

#example()[
  Il primo esempio di SDD che abbiamo visto nel capitolo è S-attribuita.
  
  La SDD per il calcolo dei prodotti è invece L-attribuita.
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
  Infatti:

  - La prima regola definisce l'attributo ereditato $T'.i n h$ usando solo l'attributo sintetizzato $F.v a l$. Poiché il simbolo $F$ si trova *a sinistra* di $T'$ nel corpo della regola ($T -> F T'$), la condizione è soddisfatta.

  - La seconda regola definisce l'attributo ereditato $T'_1.i n h$ utilizzando l'attributo ereditato della testa $T'.i n h$ (lecito, viene dall'alto) e l'attributo $F.v a l$, associato al simbolo $F$ che compare *a sinistra* di $T'_1$ nella parte destra della regola.
  In entrambi i casi le regole utilizzano informazioni provenienti da sopra o da sinistra, come richiesto dalle definizioni L-attribuite. Gli altri attributi sono sintetizzati quindi questa SDD è L-attribuita.
]

=== Regole semantiche con effetti collaterali controllati

Ogni traduzione reale comporta spesso effetti collaterali, ad esempio la stampa di un risultato (come in una calcolatrice) o l'aggiunta di informazioni nella tavola dei simboli (come in un compilatore). Le grammatiche ad attributi "pure" non hanno alcun effetto collaterale e gli attributi possono essere valutati secondo qualunque ordinamento topologico che rispetti il grafo delle dipendenze. Gli schemi di traduzione, invece, impongono una valutazione rigorosa da sinistra verso destra e consentono azioni semantiche costituite da porzioni di codice. Nelle SDD si possono controllare gli effetti collaterali in due modi:

+ *Permettere effetti collaterali incidentali* che non pongono vincoli rigorosi sulla valutazione degli attributi; qualsiasi ordine di valutazione coerente col grafo delle dipendenze produce una traduzione "corretta".

  #example()[
    Nella SDD per le espressioni (calcolatrice) possiamo sostituire la regola semantica $L.v a l = E.v a l$ associata alla produzione $L -> E bold(text("n"))$ con l'azione $"print"(E.v a l)$ in modo che venga stampato il risultato a schermo. La SDD modificata produce la stessa traduzione seguendo un qualsiasi ordine topologico, perché l'istruzione di stampa è eseguita sempre per ultima, dopo aver calcolato il valore di $E.v a l$. Regole semantiche di questo tipo equivalgono logicamente alla definizione di attributi sintetizzati fittizi associati alla parte sinistra della produzione.
  ]

+ *Vincolare gli ordini di valutazione* permessi, in modo che la traduzione per ogni ordinamento risulti sempre "corretta". I vincoli possono essere visti come archi impliciti aggiunti al grafo delle dipendenze.

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

    Questa SDD rappresenta una dichiarazione $D$ costituita da un tipo base $T$ (che può essere $bold("int")$ o $bold("float")$) seguito da una lista di identificatori $L$. Per ogni identificatore, il tipo viene aggiunto al corrispondente elemento della tavola dei simboli.

    - La variabile $T$ ha un attributo sintetizzato $T.t y p e$ che può assumere i valori $"integer"$ o $"float"$ e che rappresenta il tipo della dichiarazione.
    - $L$ ha un attributo ereditato $L.i n h$ che serve per far passare il tipo dichiarato attraverso tutta la lista di identificatori.
    - Nella produzione 1, il valore di $T.t y p e$ passa a $L.i n h$.
    - Nella produzione 4, il valore di $L.i n h$ viene passato da un nodo padre al nodo figlio $L_1$, verso il basso.

    Le produzioni 4 e 5 richiamano la funzione $italic("addType()")$ con due argomenti:
    - $bold(text("id")).e n t r y$: valore lessicale, che agisce da puntatore alla riga corretta nella tavola dei simboli.
    - $L.i n h$: attributo ereditato che indica il tipo da assegnare agli identificatori della lista.

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
      caption: "Grafo delle dipendenze per "+$bold("float")$ + ", " + $bold(i d)_1, bold(i d)_2, bold(i d)_3$,
    )

    I nodi 6, 8 e 10 sono gli attributi fittizi utilizzati per rappresentare le chiamate alla funzione $italic("addType()")$ relative a questi tre identificatori.
  ]

== Applicazioni della traduzione guidata dalla sintassi
Poiché molti compilatori usano gli *alberi sintattici* (o *Abstract Syntax Tree*, AST) come rappresentazione intermedia del codice, una forma comune di SDD ha come unico scopo quello di trasformare la stringa d'ingresso in un albero sintattico che ne rappresenti la struttura. Per completare la traduzione in codice intermedio, il compilatore visiterà poi questo albero seguendo un nuovo insieme di regole che, di fatto, costituiscono un SDD associato all'albero sintattico o all'albero di parsing. Gli alberi sintattici sono diversi dagli alberi di parsing, che rappresentano la derivazione di una stringa con una particolare grammatica.

=== Costruzione degli alberi sintattici

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
  caption: "Albero sintattico a sinistra e alberi di parsing a destra",
)

Ogni nodo di un albero sintattico rappresenta un costrutto e i figli di tale nodo rappresentano le parti significative che lo compongono. Un nodo che rappresenta un'espressione del tipo $E_1 + E_2$ ha come etichetta il simbolo $+$ e come figli due nodi che rappresentano le sotto-espressioni $E_1$ e $E_2$.
Ogni oggetto ha un campo `op` che costituisce l'etichetta del nodo.

- Se il nodo è una foglia, ha un campo aggiuntivo che contiene il valore lessicale associato. Viene creato con un costruttore del tipo `Leaf(op, val)`.
- Un nodo interno ha tanti campi aggiuntivi quanti sono i nodi figli nell'albero sintattico. Viene creato con un costruttore `Node(op, c1, c2, ..., ck)`.

#example()[

  Consideriamo una SSD S-attribuita che costruisce gli alberi sintattici relativi a una grammatica per le espressioni con gli operatori $+$ e $-$.
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
  Ogni volta che viene utilizzata la produzione $E -> E_1 + T$ (o $E -> E_1 - T$), la regola semantica crea un nuovo nodo in memoria con etichetta $+$ che punta ai nodi figli precedentemente calcolati $E_1.italic("node")$ e $T.italic("node")$.
  Nota bene: le regole associate a $E -> T$ e $T -> ( E )$ *non* creano nessun nuovo nodo, poiché $E.n o d e$ e $T.n o d e$ si riferiscono allo stesso nodo.

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

      // EDGES tratteggiati //
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

  Se, per la stringa `a - 4 + c`, queste regole vengono eseguite secondo un parsing bottom-up o nell'ordine definito tramite una visita in post-ordine dell'albero di parsing, si avrà la seguente sequenza di passi:

  ```c
  p1 = new Leaf(id, entry-a);
  p2 = new Leaf(num, 4);
  p3 = new Node('-', p1, p2);
  p4 = new Leaf(id, entry-c);
  p5 = new Node('+', p3, p4);
  ```
  Alla fine del processo, `p5` è il puntatore alla radice dell' albero sintattico.

]

#example()[
  SDD L-attribuita per espressioni con $+$ e $-$.
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
  Consideriamo il solito input $a - 4 + c$. Questa definizio L-attribuita produce la stessa traduzione dell'esempio precedente: si ottiene lo stesso albero sintattico anche se l'albero di parsing è molto diverso.

  L'attributo ereditato $E'.i n h$ rappresenta la porzione di albero sintattico costruita fino ad un certo punto, cioè la radice del sottoalbero corrispondente al prefisso della stringa d'ingresso relativa alla porzione di albero che si trova a sinistra di $E'$. Al nodo 5 del grafo delle dipendenze $E'.i n h$ rappresenta la radice del sottoalbero sintattico corrispondente all'identificatore $a$. Al nodo 6 $E'.i n h$ indica la radice del sottoalbero sintattico corrispondente alla stringa $a - 4$. Al nodo 9 $E'.i n h$ rappresenta l'albero sintattico corrispondente alla stringa $a - 4 + c$. Poiché la stringa in ingresso è terminata, $E'.i n h$ al nodo 9 punta alla radice dell'intero albero sintattico. L'attributo $s y n$ propaga tale valore fino all'attributo $E$.node.

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

      // EDGES frecce //
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
    caption: "Grafo delle dipendenze per "+$a - 4 + c$+" relativo alla SDD L-attribuita.",
  )
]

=== Struttura di un tipo

Gli *attributi ereditati* sono utili quando la struttura dell'albero di parsing differisce da quella dell'albero sintattico astratto relativo alla stringa d'ingresso. In questi casi consentono di trasportare informazioni tra punti diversi dell'albero di parsing, rendendole disponibili dove servono per costruire la rappresentazione desiderata.

Un esempio è la *costruzione della struttura di un tipo array*: nell'albero di parsing il tipo di base e la sequenza delle dimensioni si trovano in sottoalberi distinti, mentre nella rappresentazione del tipo devono essere combinati in una struttura annidata. Utilizziamo quindi un attributo ereditato per propagare il tipo di base lungo la sequenza delle dimensioni e un attributo sintetizzato per costruire il tipo completo risalendo l'albero.

Consideriamo, per esempio, il tipo `int[2][3]`: rappresenta un *array di 2 elementi, ciascuno dei quali è un array di 3 interi*. La corrispondente *espressione di tipo* è:
$
  italic("array")(2, italic("array")(3, italic("integer")))
$
Il costruttore $italic("array")(n, t)$ rappresenta un array di $n$ elementi di tipo $t$. Possiamo rappresentare questa espressione mediante un albero: ogni nodo _array_ ha due figli, che indicano rispettivamente il numero di elementi e il tipo di ciascun elemento.

La seguente SDD costruisce l'espressione di tipo a partire da un tipo di base seguito da zero o più dimensioni:
#figure(
  table(
    stroke: none,
    columns: (.4fr, .6fr),
    align: left,
    table.hline(start: 0),
    table.header(
      [*Produzione*],
      [*Regole semantiche*],
    ),
    table.hline(start: 0),

    [$T -> B C$],
    [$C.b = B.t$],
    [],
    [$T.t = C.t$],

    [$B -> bold("int")$],
    [$B.t = italic("integer")$],

    [$B -> bold("float")$],
    [$B.t = italic("float")$],

    [$C -> "[" bold("num") "]" C_1$],
    [$C_1.b = C.b$],
    [],
    [$C.t = italic("array")(bold("num").italic("val"), C_1.t)$],

    [$C -> epsilon$],
    [$C.t = C.b$],

    table.hline(start: 0),
  ),
)

Il non-terminale $B$ genera il *tipo di base*, mentre $C$ genera la sequenza delle dimensioni. Se $C$ deriva $epsilon$, il tipo generato da $T$ coincide semplicemente con quello di base.

Gli attributi hanno il seguente significato:
- $B.t$ e $T.t$ sono attributi *sintetizzati* che rappresentano, rispettivamente, il tipo di base e il tipo completo.
- $C.b$ è un attributo *ereditato* che trasporta il tipo di base lungo la catena dei nodi $C$.
- $C.t$ è un attributo *sintetizzato* che rappresenta il tipo costruito considerando le dimensioni generate da quel nodo.
- $bold("num").italic("val")$ è il valore della dimensione, fornito dall'analizzatore lessicale.

La costruzione avviene quindi in due passaggi: il tipo di base viene prima *propagato verso il basso* mediante l'attributo ereditato $b$; l'espressione di tipo viene poi *costruita risalendo l'albero* mediante l'attributo sintetizzato $t$.

#example()[
  Consideriamo il tipo `int[2][3]`, il cui *albero di parsing annotato* è riportato in figura. Il nodo $B$ genera il tipo di base, mentre la catena di nodi $C$ genera le dimensioni `[2][3]`.

  #figure(image("images/esempioStrutturaTipo.png", width: 80%), caption: "Traduzione guidata dalla sintassi relativi ai tipi array")

  Come si osserva nell'albero, il valore $B.t = italic("integer")$ viene passato al primo nodo $C$ e poi propagato verso il basso mediante l'attributo ereditato $b$. Tutti i nodi $C$ hanno quindi $C.b = italic("integer")$.

  Il tipo viene poi costruito risalendo la catena mediante l'attributo sintetizzato $t$:
  + Il nodo $C$ più in basso utilizza la produzione $C -> epsilon$: non essendoci altre dimensioni, restituisce il tipo di base mediante la regola $C.t = C.b = italic("integer")$.
  + Il nodo relativo alla dimensione $3$ costruisce il tipo $italic("array")(3, italic("integer"))$, usando il valore sintetizzato dal figlio.
  + Il nodo relativo alla dimensione $2$ aggiunge il livello più esterno, ottenendo $italic("array")(2, italic("array")(3, italic("integer")))$.
  + Infine, la regola $T.t = C.t$ assegna alla radice il tipo completo.

  La figura evidenzia quindi i due flussi di informazioni: l'attributo *ereditato* $b$ trasporta il tipo di base verso il basso senza modificarlo, mentre l'attributo *sintetizzato* $t$ costruisce progressivamente il tipo array verso l'alto.
]

== Schemi di traduzione guidati dalla sintassi
Gli schemi di traduzione guidati dalla sintassi sono una notazione complementare alle definizioni guidate dalla sintassi. Tutte le applicazioni delle SDD (per esempio la costruzione degli alberi sintattici) possono essere realizzate usando gli schemi di traduzione guidati dalla sintassi.

#definition()[
  Uno *schema di traduzione guidato dalla sintassi* o *SDT* (Syntax-Directed Translation scheme) è una grammatica context-free avente frammenti di programma contenuti in qualunque posizione nel corpo delle produzioni. Tali porzioni di programma sono dette *azioni semantiche*.
]
Per convenzione notazionale, le azioni semantiche sono racchiuse tra parentesi graffe `{ ... }`; qualora le parentesi graffe fossero simboli terminali appartenenti alla grammatica in esame, le si rappresenterebbero tra virgolette (es. `'{'`).

Qualsiasi schema di traduzione SDT può essere concettualmente realizzato costruendo in primo luogo un albero di parsing, e poi procedendo all'esecuzione delle azioni da sinistra a destra e in profondità, ossia durante una visita in preordine.\ Nella pratica, si cerca di evitare la costruzione dell'albero parsing in memoria, eseguendo le azioni "al volo" durante il parsing.

Consideriamo gli SDT necessari per realizzare le classi di SDD per cui:

+ la grammatica sottostante può essere riconosciuta da un parser LR (bottom-up) e la SDD è S-attribuita.
+ la grammatica sottostante può essere riconosciuta da un parser LL (top-down) e la SDD è L-attribuita.

Le regole semantiche di una SDD possono essere convertite in uno SDT le cui azioni sono eseguite esattamente al momento opportuno. Durante il parsing, un'azione semantica presente nel corpo di una produzione viene eseguita *non appena tutti i simboli alla sua sinistra sono stati consumati*.
Gli SDT che richiedono azioni intermedie possono essere implementati introducendo dei *non-terminali marcatori* (_marker non-terminals_). Al posto dell'azione, si inserisce un nuovo non-terminale fittizio $M$ associato a una singola produzione vuota $M -> epsilon$. Se la grammatica arricchita con i non-terminali marcatori può ancora essere trattata dal metodo di parsing scelto (ovvero non introduce nuovi conflitti Shift/Reduce), allora lo schema di traduzione corrispondente può essere implementato "al volo" durante il parsing.

=== Schemi di traduzione postfissi
Quando la grammatica può essere analizzata con una tecnica bottom-up (es. parser LR) e la SDD associata è S-attribuita, si può costruire uno SDT in cui tutte le azioni semantiche si trovano alla fine delle produzioni. In questo modo, le azioni vengono eseguite in modo naturale nel momento esatto in cui il parser effettua la riduzione utilizzando quella specifica regola.

#definition("SDT postfissi")[
  Gli SDT in cui tutte le azioni compaiono all'estremità destra del
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
  Questo è lo SDT postfisso che implementa la SDD della calcolatrice, con l'unica aggiunta dell'istruzione di stampa finale (prima produzione). Essendo la grammatica LR e la SDD S-attribuita, le azioni semantiche dello SDT possono essere eseguite contestualmente ai passi di riduzione del parser, eliminando la necessità di costruire l'albero di parsing in memoria.
]

==== Implementazione degli SDT basata sugli stack del parser

Gli SDT postfissi possono essere implementati durante il parsing LR eseguendo le azioni ogniqualvolta si effettua una riduzione. Gli attributi di ogni simbolo grammaticale possono essere memorizzati nello stack, in una posizione in cui si possa recuperarli durante una riduzione. La migliore strategia consiste nel porre nello stack gli attributi assieme ai simboli grammaticali (o agli stati LR che rappresentano i simboli), memorizzandoli nei campi di un record.

#example()[
  #figure(image("images/stackParserAttributi.png"))
  La figura mostra lo stack di un parser i cui elementi sono record aventi un campo per memorizzare il simbolo grammaticale (o lo stato del parser) e un secondo campo (mostrato in basso) per memorizzare un attributo. I tre simboli grammaticali $X$, $Y$ e $Z$ si trovano sulla cima dello stack e potrebbero essere pronti per essere ridotti mediante una produzione del tipo $A -> X Y Z$.
]

In generale possiamo permettere la presenza di più attributi per ogni simbolo sia definendo un record di maggiori dimensioni sia mettendo sullo stack i puntatori ai record piuttosto che i record stessi (quest'ultima soluzione è migliore se uno o più attributi hanno dimensioni rilevanti).\ 
Se tutti gli attributi sono sintetizzati e le azioni compaiono alla fine delle produzioni, possiamo calcolare il valore degli attributi associati alla parte sinistra di una produzione quando si fa una riduzione. Se, ad esempio, riduciamo con una regola $A -> X Y Z$, tutti gli attributi per $X$, $Y$ e $Z$ sono disponibili e si trovano in posizioni note nella pila; dopo la riduzione, $A$ e i suoi attributi si troveranno in cima allo stack.

#example()[
  Riscriviamo le azioni dello SDT della calcolatrice in modo che manipolino lo stack esplicitamente. Lo stack è realizzato con un array _stack_ e un indice _top_ che ne indica la cima. _stack_[_top_] si riferisce al record in testa alla pila, _stack_[_top_-1] al record sottostante. Supponiamo che ogni record abbia un campo _val_ che contiene il valore dell'attributo. Ad esempio se E si trova nella terza posizione dalla cima della pila, _stack_[_top_-2]._val_ corrisponde a $E.v a l$.
  #figure(image("images/SDTcalcolatriceStack.png", width: 85%))
  Le azioni vengono eseguite al momento della *riduzione*: i record dei simboli nel corpo della produzione sono in cima alla pila e vengono sostituiti da un unico record per la testa. Il risultato viene memorizzato nella posizione che questo record occuperà dopo la riduzione.

  - Nella produzione $E -> E_1 + T$, i tre record in cima alla pila corrispondono, dal basso verso l'alto, a $E_1$, $+$ e $T$. Quindi $E_1.italic("val")$ si trova in $italic("stack")[italic("top") - 2].italic("val")$, mentre $T.italic("val")$ si trova in $italic("stack")[italic("top")].italic("val")$. L'azione somma questi valori e memorizza il risultato in $italic("stack")[italic("top") - 2].italic("val")$, riutilizzando la posizione di $E_1$ per il nuovo record di $E$. Infine, $italic("top") = italic("top") - 2$ elimina dalla pila gli altri due record: tre simboli sono stati sostituiti da uno e il risultato si trova ora in cima. La produzione $T -> T_1 * F$ funziona allo stesso modo, eseguendo un prodotto.

  - Per le produzioni $E -> T$, $T -> F$ e $F -> bold("digit")$, non servono azioni esplicite sugli attributi: un solo simbolo viene sostituito da un altro, quindi la dimensione della pila non cambia e il valore già presente nel campo _val_ viene conservato. Per *digit* supponiamo che tale campo contenga il valore numerico fornito dall'analizzatore lessicale.

  - Nella produzione $F -> ( space E space )$, la riduzione sostituisce i tre simboli del corpo col solo simbolo $F$. il valore da conservare è quello di $E$, che si trova in $italic("stack")[italic("top") - 1].italic("val")$. Il record di $F$ occuperà però la posizione della parentesi aperta (si fa "pop" tre volte per i simboli nel corpo, qundi la nuova cima dello stack dove viene inserito $F$ sarà $italic("top")-2$): occorre quindi prima copiare il valore di $E$ in $italic("stack")[italic("top") - 2].italic("val")$ e poi diminuire _top_ di due (nuova cima).

  - Nella produzione $L -> E bold("n")$, il marcatore di fine riga è in cima alla pila, mentre il valore di $E$ si trova nella posizione immediatamente sottostante. L'azione stampa quindi $italic("stack")[italic("top") - 1].italic("val")$ e diminuisce _top_ di uno.

  In queste azioni sono omessi gli aggiornamenti del campo che identifica il simbolo grammaticale o lo stato del parser. Nel caso di un parser LR, lo stato da memorizzare dopo la riduzione viene determinato mediante la tabella di parsing.  
]

#example()[
  Si utilizza la tabella di parsing SLR già ricavata in precedenza per il parsing della stringa 3 \* ( 5 + 2 ). La figura seguente mostra le configurazioni successive della pila, i cui record hanno due campi: nella parte superiore sono riportati i *simboli grammaticali*, mentre nella parte inferiore compaiono i corrispondenti valori dell'attributo _val_. Il simbolo $d$ indica il token *digit*; i trattini indicano i campi senza un valore numerico significativo. Si assume che quando il parser impila un _digit_, il token $bold("d")$ viene posto nel primo campo e il suo attributo nel secondo.

  A ogni passo, il parser consulta la parte ACTION della tabella usando lo stato corrente e il prossimo token per decidere se effettuare uno shift o una riduzione. In caso di riduzione, esegue l'azione semantica associata e usa la parte GOTO per determinare il nuovo stato.

  - Il primo *digit*, con valore $3$, viene ridotto prima a $F$ e poi a $T$. Queste riduzioni conservano il valore nella stessa posizione della pila.
  - Dopo aver impilato $*$ e la parentesi aperta, il parser analizza $5 + 2$. Quando riduce $E + T$ a $E$, somma i valori $5$ e $2$ e li sostituisce con un unico record avente valore $7$.
  - Dopo aver impilato la parentesi chiusa, il parser riduce $( E )$ a $F$: il valore $7$ viene copiato nella posizione occupata dalla parentesi aperta e la pila si accorcia di due record.
  - A questo punto, in cima alla pila si trovano $T * F$, con valori $3$ e $7$. La riduzione a $T$ calcola il prodotto $3 times 7 = 21$. La successiva riduzione a $E$ conserva tale valore. Nello schema della calcolatrice illustrato in figura, il marcatore *n* permette infine di completare la produzione $L -> E bold("n")$ e stampare il risultato.

  Il valore dell'espressione viene quindi calcolato *durante le riduzioni*, senza costruire esplicitamente l'albero di parsing.

  #figure(image("images/stackSLRparsing.png", width: 85%))
]

=== Schemi di traduzione con azioni interne alle produzioni
Un'azione semantica può essere inserita in qualsiasi posizione all'interno del corpo di una produzione. Essa sarà eseguita non appena tutti i simboli grammaticali alla sua sinistra saranno stati consumati. Quindi, in una produzione del tipo $B -> X space {a} space Y$, l'azione ${a}$ sarà eseguita non appena avremo riconosciuto interamente $X$, se $X$ è un terminale, oppure tutti i terminali derivati da $X$, se $X$ è un non-terminale.

Più precisamente:

- Nel *parsing top-down*, si esegue l'azione $a$ immediatamente prima di tentare l'espansione di $Y$, se $Y$ è un non-terminale, oppure prima di cercare $Y$ in ingresso, se $Y$ è un terminale.
- Nel *parsing bottom-up*, si esegue l'azione $a$ non appena l'occorrenza in esame del simbolo $X$ appare sulla cima dello stack sintattico.

Gli SDT che possono essere implementati durante il parsing comprendono gli schemi di traduzione postifssi, come già visto, e un'altra classe di schemi che implementa le definizione L-attribuite di cui parleremo più avanti. Non tutti gli SDR possono essere implementati durante il parsing, come illustra l'esempio seguente.

#example()[
  Modifichiamo lo SDT della calcolatrice in modo che stampi la *forma prefissa* dell'espressione, anziché calcolarne il valore. Come mostrato in figura, le azioni che stampano gli operatori sono collocate *all'inizio* delle produzioni $E -> E_1 + T$ e $T -> T_1 * F$, mentre ogni cifra viene stampata dopo essere stata riconosciuta.

  #figure(image("images/SDTnonImplementabileParsing.png", width: 60%))

  Per esempio, la stringa $3 * 5 + 4$ deve produrre $+ space * space 3 space 5 space 4$: ogni operatore viene stampato prima dei propri operandi.

  Questo schema non può essere eseguito direttamente durante il parsing deterministico, né top-down né bottom-up. Il problema è che le azioni richiedono di stampare gli operatori *prima che il parser abbia informazioni sufficienti per sapere quali compariranno*. All'inizio, vedendo la cifra $3$, il parser non può ancora stabilire se debba stampare prima $+$, prima $*$ oppure direttamente la cifra: ciò dipende dal seguito dell'espressione.

  Nel parsing bottom-up, il problema emerge anche introducendo due non-terminali marcatori $M_2$ e $M_4$ per le azioni che stampano rispettivamente $+$ e $*$. Davanti alla prima cifra $3$, il parser shift-reduce si trova in conflitto: non può scegliere se ridurre mediante $M_2 -> epsilon$, ridurre mediante $M_4 -> epsilon$ oppure effettuare lo shift della cifra.
]

Anche quando uno SDT non può essere eseguito direttamente durante il parsing, è possibile implementarlo *costruendo prima l'albero di parsing* ed eseguendo successivamente le azioni. Il procedimento generale è il seguente:

+ *Costruzione dell'albero:* si analizza la stringa d'ingresso ignorando le azioni semantiche e si costruisce il relativo albero di parsing.

+ *Inserimento delle azioni:* per ogni nodo interno $N$, associato a una produzione $A -> alpha$, si aggiungono nuovi nodi figli che rappresentano le azioni presenti nella produzione. La loro posizione deve rispettare l'ordine del corpo: leggendo i figli di $N$ da sinistra verso destra, si devono incontrare i simboli e le azioni nello stesso ordine in cui compaiono nella produzione.

+ *Esecuzione delle azioni:* si visita l'albero così arricchito in *preordine*, procedendo tra i figli da sinistra verso destra. Ogni volta che si incontra un nodo corrispondente a un'azione, la si esegue.

La posizione delle azioni nell'albero ne determina quindi il momento di esecuzione: un'azione posta prima di un simbolo viene eseguita prima di visitarne il sottoalbero, mentre un'azione posta dopo viene eseguita quando la visita di quel sottoalbero è terminata.

#example()[
  Riprendiamo lo SDT che traduce le espressioni in forma prefissa e consideriamo la stringa $3 * 5 + 4$.

  #figure(image("images/albParsingArricchitoAzioniSemantiche.png", width: 70%))

  Nell'albero arricchito, l'azione che stampa $+$ precede il sottoalbero dell'operando sinistro $3 * 5$. All'interno di questo sottoalbero, l'azione che stampa $*$ precede a sua volta quelli dei due fattori.

  La visita in preordine esegue quindi le stampe nell'ordine $+$, $*$, $3$, $5$, $4$, producendo la forma prefissa $+ space * space 3 space 5 space 4$.

  A differenza dell'esecuzione durante il parsing, quando si visitano le azioni l'intero albero è già stato costruito: non occorre più anticipare una scelta sulla base di una porzione dell'input.
]

=== Eliminazione della ricorsione sinistra dagli SDT
Poiché nessuna grammatica che presenti ricorsione sinistra può essere analizzata deterministicamente mediante parsing top-down (es. LL(1)), abbiamo già visto tecniche sintattiche per eliminare tale tipo di ricorsione. Quando una grammatica ricorsiva a sinistra è parte di uno Schema di Traduzione (SDT), è necessario convertire non solo la sintassi, ma *anche* la posizione delle azioni e il flusso degli attributi.

==== SDT con effetti collaterali semplici
Consideriamo il caso semplice in cui l'unica questione riguarda l'ordine di esecuzione delle azioni (es. stampare una stringa). In questa situazione si applica il seguente principio:

_Nel processo di trasformazione della grammatica si trattano le azioni come ulteriori simboli terminali._

Questo principio si basa sul fatto che la rimozione della ricorsione sinistra preserva l'ordine dei terminali nella stringa generata. Le azioni, trattate come terminali, verranno quindi eseguite esattamente nello stesso ordine originale in qualsiasi visita da sinistra a destra di un qualsiasi metodo di parsing. La strategia per eliminare la ricorsione consiste nel considerare due produzioni $A -> A alpha bar beta$ che generano stringhe costituite da un occorenza di $beta$ seguita da un numero arbitrario di $alpha$ e sostituirle con nuove produzioni che generano le stesse righe utilizzando un nuovo non-terminale $R$ (che sta per "resto"), ovvero: $A -> beta R$, $R -> alpha R bar epsilon$.

#example()[
  Si considerino le seguenti produzioni relative a $E$ prese da uno SDT per la traduzione di espressioni dalla forma infissa alla forma postfissa:
  $
    E & -> E + T quad { text("print")('+'); } \
    E & -> T
  $
  Se applichiamo la trasformazione standard all'insieme delle produzioni, il "resto" della produzione ricorsiva inizia con $+ T { text("print")('+'); }$. Introducendo il non-terminale $R$, si ottiene l'insieme equivalente e privo di ricorsione sinistra:
  $
    E & -> T R \
    R & -> + T quad { text("print")('+'); } quad R \
    R & -> epsilon quad { }
  $
]

==== SDT che calcolano attributi (Trasformazione S $->$ L)
Quando le azioni di uno SDT calcolano attributi, preservare il solo ordine delle azioni non basta: la trasformazione modifica l'albero di parsing e bisogna adattare il modo in cui vengono trasmessi i valori.

Partendo da una SDD *S-attribuita*, possiamo eliminare la ricorsione sinistra e costruire uno SDT equivalente introducendo attributi ereditati per i risultati intermedi. Lo schema ottenuto implementa una definizione *L-attribuita*.

Consideriamo il caso di una sola produzione ricorsiva, una sola produzione non ricorsiva e un unico attributo sintetizzato $A.a$. I simboli $X$ e $Y$ hanno rispettivamente gli attributi sintetizzati $X.x$ e $Y.y$.

Si considerino le seguenti due produzioni, in cui l'attributo di $A$ viene sintetizzato dal basso:
#align(center)[
  #table(
    stroke: none,
    columns: (15em, 20em),
    align: left,
    table.hline(start: 0),
    table.header([*Produzione Originale*], [*Regole semantiche (S-attribuite)*]),
    table.hline(start: 0),
    [$A -> A_1 Y$], [{$A.a = g(A_1.a, Y.y)$}],
    [$A -> X$], [{$A.a = f(X.x)$}],
    table.hline(start: 0),
  )
]
Qui $g()$ e $f()$ sono due funzioni arbitrarie. Applicando l'eliminazione della ricorsione sinistra, la sintassi diventa $A -> X R$ e $R -> Y R | epsilon$.

Ma che fine fanno gli attributi?
Dal momento che $R$ produce un "resto" relativo alle occorrenze di $Y$, la sua traduzione dipende da ciò che è stato calcolato *alla sua sinistra*.

- Per $R$ utilizziamo un *attributo ereditato* $R.i$ allo scopo di accumulare i risultati intermedi delle successive applicazioni della funzione $g()$, partendo dal valore iniziale calcolato da $f()$.

- Il non-terminale $R$ ha inoltre un *attributo sintetizzato* $R.s$. Questo attributo viene finalizzato quando la ricorsione termina (produzione $R -> epsilon$) e viene poi semplicemente propagato verso l'alto dell'albero.

La trasformazione deve preservare anche l'*ordine di applicazione delle funzioni*. Per esempio, per una sequenza $X Y_1 Y_2$, lo schema originale calcola:
$
  A.a = g(g(f(X.x), Y_1.y), Y_2.y).
$
#figure(image("images/eliminazioneRicSxSDTpostfisso.png", width: 80%), caption: "Eliminazione della ricorsione sinistra da uno schema di traduzione postfisso")
La figura confronta i due alberi: in quello originale (a), i risultati intermedi vengono sintetizzati risalendo la catena di nodi $A$; in quello trasformato (b), gli stessi risultati vengono trasmessi verso il basso mediante l'attributo ereditato $R.i$. L'attributo sintetizzato $R.s$, non mostrato in figura, riporta poi il risultato finale verso la radice.\
Nel nuovo schema, l'attributo ereditato $R.i$ assume progressivamente i valori:
$
  f(X.x), quad
  g(f(X.x), Y_1.y), quad
  g(g(f(X.x), Y_1.y), Y_2.y).
$
Quando si raggiunge la produzione $R -> epsilon$, il valore accumulato viene assegnato a $R.s$ e riportato verso l'alto fino ad $A.a$. Quindi, pur cambiando la struttura dell'albero, il calcolo mantiene lo stesso ordine, senza richiedere che $g$ sia associativa.

Lo SDT trasformato è il seguente:
$
  A &-> X
    quad { R.i = f(X.x); }
    quad R
    quad { A.a = R.s; } \
  R &-> Y
    quad { R_1.i = g(R.i, Y.y); }
    quad R_1
    quad { R.s = R_1.s; } \
  R &-> epsilon
    quad { R.s = R.i; }
$

L'attributo ereditato di ogni occorrenza di $R$ viene calcolato *immediatamente prima* di tale occorrenza, quando i valori necessari sono già disponibili. Gli attributi sintetizzati $A.a$ e $R.s$ vengono invece calcolati *alla fine* delle rispettive produzioni.
=== Schemi di traduzione per definizioni L-attribuite <6.4.4>
Abbiamo visto il caso di conversione di una definizione S-attribuita in uno SDT postfisso in cui le azioni appaiono all'estrema destra delle produzioni. Consideriamo ora il caso più generale di una SDD L-attribuita (con grammatica LL). Assumeremo che la grammatica sottostante possa essere analizzata top-down, poiché in caso contrario accade spesso che sia impossibile effettuare la trasformazione appoggiandosi a un parser LL o LR.

Le regole fondamentali per trasformare una SDD L-attribuita in uno SDT funzionante sono due:

+ *Regola per gli attributi ereditati:* si aggiungano le azioni che calcolano gli attributi ereditati di un non-terminale $A$ *immediatamente prima* dell'occorrenza di $A$ nel corpo della produzione. Se tali attributi dipendono tra loro, si ordinano le azioni rispettando le dipendenze, in modo che ogni valore sia disponibile prima di essere utilizzato.

+ *Regola per gli attributi sintetizzati:* si aggiungano le azioni che calcolano un attributo sintetizzato relativo alla testa della produzione *alla fine* del corpo di quella produzione.

#example()[
  Prendiamo come riferimento la produzione del costrutto iterativo:
  $
    S -> bold(text("while")) ( C ) S_1
  $
  Useremo i seguenti attributi semantici per generare il codice intermedio richiesto:

  - $S.italic("next")$ (ereditato): indica l'etichetta relativa all'inizio del codice che deve essere eseguito immediatamente dopo che lo statement $S$ è terminato.
  - $S.italic("code")$ (sintetizzato): rappresenta la porzione di codice intermedio che implementa lo statement $S$, trasferendo il controllo a $S.italic("next")$ quando la sua esecuzione termina.
  - $C.italic("true")$ (ereditato): indica l'etichetta relativa all'inizio del codice da eseguire se la condizione $C$ risulta vera (il corpo del loop).
  - $C.italic("false")$ (ereditato): indica l'etichetta relativa all'inizio del codice da eseguire se la condizione $C$ risulta falsa (uscita dal loop).
  - $C.italic("code")$ (sintetizzato): rappresenta il codice intermedio che implementa la valutazione di $C$ e che salta a $C.italic("true")$ o $C.italic("false")$ a seconda del valore booleano dell'espressione.

  #figure(image("images/SDDwhile.png", width: 80%))

  Alcuni punti meritano un approfondimento:
  - La funzione $italic("new")()$ genera nuove etichette univoche durante la traduzione.
  - Le variabili locali $italic("L1")$ e $italic("L2")$ mantengono memorizzate le etichette di cui abbiamo bisogno. In particolare, $italic("L1")$ indica l'inizio del codice relativo alla valutazione della condizione del $bold("while")$; dobbiamo fare in modo che, dopo aver eseguito il corpo $S_1$, il controllo torni a valutare la condizione. Questo è il motivo per cui assegniamo il valore $italic("L1")$ a $S_1.italic("next")$.
  - $italic("L2")$ indica l'inizio del codice relativo al corpo dello statement ($S_1$) e deve essere assegnato a $C.italic("true")$, poiché è proprio lì che bisogna saltare quando la condizione $C$ è verificata.
  - Assegniamo a $C.italic("false")$ il valore di $S.italic("next")$; se la condizione risulta falsa, il controllo deve passare immediatamente al codice che segue l'intero blocco del $bold("while")$.
  - Usiamo il simbolo $||$ per indicare il concatenamento di frammenti di codice intermedio. Il valore di $S.italic("code")$ è formato dall'etichetta $italic("L1")$, dal codice della condizione, dall'etichetta $italic("L2")$ e dal codice del corpo $S_1$. Il salto di ritorno a $italic("L1")$ è già previsto in $S_1.italic("code")$, poiché abbiamo assegnato $S_1.italic("next") = italic("L1")$: non occorre quindi aggiungerlo esplicitamente alla concatenazione.

  Applicando le due regole di traduzione, collocando le azioni per gli attributi ereditati immediatamente prima dei rispettivi simboli e quelle per gli attributi sintetizzati della testa alla fine, si ottiene il seguente SDT:
  #figure(image("images/SDTwhile.png", width: 80%))

  La posizione delle azioni rispetta le due regole generali:

  - *Prima di $C$* si creano le etichette $italic("L1")$ e $italic("L2")$ e si assegnano gli attributi ereditati $C.italic("true")$ e $C.italic("false")$, necessari per costruire il codice della condizione.
  - *Prima di $S_1$* si assegna $S_1.italic("next") = italic("L1")$, affinché il codice del corpo preveda il ritorno alla condizione.
  - *Dopo $S_1$* si calcola l'attributo sintetizzato $S.italic("code")$, perché sono ormai disponibili sia $C.italic("code")$ sia $S_1.italic("code")$.

  Le etichette $italic("L1")$ e $italic("L2")$ sono variabili locali ausiliarie: vengono create durante la traduzione e, non dipendendo da altri attributi, possono essere inizializzate nella prima azione.
]

== Implementazione di SDD L-attribuite
Finora abbiamo visto come una SDD specifichi quali valori calcolare e da quali attributi dipendano, e come uno SDT stabilisca quando eseguire tali calcoli mediante la posizione delle azioni nelle produzioni. Per le definizioni S-attribuite abbiamo già visto un'implementazione basata sullo stack del parser bottom-up: gli attributi sintetizzati vengono calcolati durante le riduzioni, utilizzando i valori associati ai simboli del corpo.

Molte applicazioni della traduzione richiedono però di trasmettere anche informazioni dal contesto verso i costrutti da elaborare, come le etichette di salto nell'esempio del *while*. Le definizioni *L-attribuite*, che comprendono le S-attribuite come caso particolare, consentono di esprimere queste dipendenze mediante attributi ereditati, mantenendo un ordine di valutazione da sinistra verso destra. Vediamo quindi come *implementare concretamente* queste definizioni: dove memorizzare gli attributi, come trasmetterli tra le diverse parti del parser e quando eseguire le azioni semantiche. Considereremo sia metodi basati sulla costruzione dell'albero di parsing, sia metodi che integrano la traduzione direttamente nel parsing, sotto le opportune ipotesi sulla grammatica.\ Un primo gruppo di metodi realizza la traduzione *dopo* o *durante* la visita di un albero di parsing mantenuto in memoria:

+ *Costruzione di un albero di parsing annotato:* questo metodo generale (seppur dispendioso in memoria) funziona per qualsiasi SDD che garantisca l'assenza di cicli di dipendenza.
+ *Costruzione dell'albero di parsing, aggiunta delle azioni ed esecuzione in pre-ordine:* questa tecnica sfrutta la natura sinistra-destra e può essere applicata a qualsiasi definizione L-attribuita in modo molto naturale.

Tuttavia, per ottimizzare le prestazioni, verranno adesso introdotti altri quattro metodi per effettuare la traduzione direttamente *durante il parsing*, senza dover costruire l'intero albero in memoria:

+ *Utilizzo di un parser a discesa ricorsiva (top-down):* si definisce una funzione per ogni non-terminale; gli attributi ereditati diventano i parametri formali passati in input, mentre gli attributi sintetizzati diventano i valori di ritorno delle funzioni.
+ *Generazione del codice al volo:* l'emissione diretta del codice o del risultato tramite effetti collaterali (stampa) senza salvare stringhe intermedie.
+ *Implementazione di uno SDT insieme a un parser LL:* sfrutta una pila esplicita per gestire la traduzione durante un'analisi top-down non ricorsiva (es. LL(1) table-driven).
+ *Implementazione di uno SDT insieme a un parser LR:* come visto in precedenza, estende i parser bottom-up tramite la simulazione di attributi ereditati e l'uso di non-terminali marcatori.

=== Traduzione durante il parsing a discesa ricorsiva
Sappiamo che un parser a discesa ricorsiva prevede una funzione $A()$ per ogni non-terminale $A$ della grammatica. È possibile estendere un tale parser e trasformarlo in un traduttore facendo in modo che:

+ gli argomenti di $A()$ siano gli attributi ereditati del simbolo non-terminale $A$;
+ il valore restituito da $A()$ sia l'insieme degli attributi sintetizzati del simbolo $A$.

Il corpo della funzione $A()$ deve occuparsi sia del parsing, sia della gestione degli attributi; in particolare, la funzione deve:

+ decidere quale produzione utilizzare per espandere $A$;
+ verificare che ogni simbolo terminale appaia in ingresso quando è richiesto;
+ conservare in variabili locali i valori di tutti gli attributi necessari per il calcolo degli attributi ereditati relativi ai non-terminali nel corpo della produzione e/o degli attributi sintetizzati relativi al non-terminale alla testa della produzione;
+ chiamare le funzioni corrispondenti ai non-terminali nel corpo della produzione selezionata e passare a tali funzioni gli argomenti corretti;

#example()[
  Consideriamo la SDD e lo SDT relativi allo statement $bold("while")$. La seguente è un'implementazione di esso mediante un parser a discesa ricorsiva.
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
    }else {\
      \/\/altri tipi di statement\
    }#d\
    }
  ]
  La funzione $C(italic("false"), italic("true"))$ riceve, in quest'ordine, l'etichetta da raggiungere quando la condizione è falsa e quella da raggiungere quando è vera. Per questo viene chiamata come $C(italic("next"), italic("L2"))$. La chiamata $S(italic("L1"))$ costruisce invece il codice del corpo, prevedendo il ritorno alla condizione.
]

=== Generazione del codice al volo
La costruzione esplicita di lunghe stringhe di codice come valore degli attributi non è desiderabile per diverse ragioni, tra cui l'eccessivo tempo richiesto per copiare o spostare le stringhe. In molti casi comuni, tra cui l'esempio di generazione del codice del costrutto $bold("while")$, è possibile costruire incrementalmente porzioni di codice e memorizzarle in un array o in un file mediante opportune azioni dello SDT. Per fare ciò, le seguenti condizioni devono essere soddisfatte:

+ Per uno o più non-terminali esiste un attributo _principale_. Per semplicità assumeremo che gli attributi principali siano di tipo stringa. Nell'esempio precedente, $S.italic("code")$ e $C.italic("code")$ sono attributi principali.

+ Gli attributi principali sono sintetizzati.

+ Le regole per la valutazione degli attributi principali garantiscono che:

  - l'attributo principale è dato dal concatenamento degli attributi principali dei non-terminali che appaiono nel corpo della produzione più, eventualmente, altri elementi che non sono attributi principali, quali la stringa costante $bold("label")$ o i valori delle etichette $L 1$ e $L 2$;
  - gli attributi principali dei non-terminali appaiono nella regola nello stesso ordine in cui i non-terminali appaiono nel corpo della produzione.

Ogni funzione emette direttamente i frammenti aggiuntivi della propria produzione, mentre le chiamate ai non-terminali figli emettono ricorsivamente i rispettivi frammenti di codice. Poiché l'ordine di concatenamento coincide con quello dei simboli nel corpo, l'uscita viene costruita nell'ordine corretto senza memorizzare l'intera stringa nei singoli attributi.

#example()[
  Possiamo modificare la funzione _S_ precedentemente descritta in modo che emetta gli elementi dell'attributo principale _S.code_ invece di salvarli, per poi concatenarli nel valore di _S.code_ che verrò poi restituito.
  #figure(image("images/codiceAlVoloWhile.png", width: 80%))
  Le funzioni $S()$ e $C()$ non restituiscono alcun valore, poiché tutti i loro attributi sintetizzati sono prodotti mediante stampa. Inoltre, la posizione delle istruzioni di stampa nella funzione è importante. L'ordine in cui i vari elementi vengono stampati è il seguente: per prima cosa la stringa "label" $L 1$, quindi il codice relativo al non-terminale $C$ (che coincide con il valore della variabile _C.code_), la stringa "label" $L 2$, e infine il codice derivante dalla chiamata ricorsiva della funzione S (ovvero il valore della variabile _S.code_).
]
#example()[
  Possiamo fare lo stesso tipo di modifica direttamente sullo SDT sottostante sostituendo le azioni che costruiscono un attributo principale con azioni che emettono gli elementi che compongono tale attributo.
  #figure(image("images/2025-11-27-15-18-21.png"))
]

#pagebreak()

=== Implementazione di uno SDT con parser LL
Supponiamo che una SDD L-attribuita sia basata su una grammatica LL e che sia stata convertita in uno SDT in cui le azioni si trovano all'interno delle produzioni. In questo caso possiamo effettuare la traduzione durante il parsing LL a patto di estendere lo stack del parser in modo da poter contenere le azioni e alcuni dati necessari per la valutazione degli attributi. Tipicamente
tali dati sono copie degli attributi.

Oltre ai record che rappresentano i terminali e i non-terminali della grammatica, lo stack del parser conterrà _action-record_, cioè record relativi alle azioni che saranno eseguite (contengono puntatori al codice che deve essere eseguito) e _synthesize-record_, ovvero record destinati a salvare gli attributi sintetizzati dei non-terminali. Per gestire gli attributi sullo stack ci baseremo sui seguenti principi.

- Gli attributi ereditati di un non-terminale $A$ sono memorizzati sullo stack, nel record che rappresenta il non-terminale. Il codice necessario per la valutazione di tali attributi è in genere rappresentato mediante un _action-record_ memorizzato sullo stack, immediatamente al di sopra del record che rappresenta $A$. È infatti il meccanismo di conversione di una SDD L-attribuita in uno schema di traduzione guidato dalla sintassi ad assicurare che l'_action-record_ di $A$ sia immediatamente al di sopra del record di $A$.

- Gli attributi sintetizzati relativi al non-terminale $A$ sono memorizzati in un _synthesize-record_ separato e posizionato sullo stack immediatamente al di sotto del record relativo ad $A$.
Quando il parser espande un non-terminale $A$, il suo record viene rimosso e sostituito dai record relativi al corpo della produzione. Gli attributi ereditati di $A$ che serviranno successivamente devono quindi essere copiati nei record destinati a utilizzarli, prima che il record di $A$ venga eliminato.

Anche i _synthesize-record_ possono contenere azioni: quando raggiungono la cima dello stack, tali azioni tipicamente hanno lo scopo di copiare i valori sintetizzati in record sottostanti, prima che il record corrente venga rimosso. Il _synthesize-record_ di $A$ rimane invece sotto i record necessari per elaborare il suo corpo e conserva il risultato finale.

Le copie avvengono tra record predisposti durante la stessa espansione: la loro posizione relativa è nota, perciò le azioni possono accedervi mediante spostamenti prefissati rispetto alla cima dello stack.

#example()[
  
  Implementiamo mediante un parser LL lo SDT dell'ultimo esempio che genera *al volo* il codice del *while*. I frammenti vengono quindi emessi progressivamente, senza conservarli negli attributi $C.italic("code")$, $S_1.italic("code")$ e $S.italic("code")$.

  Nella figura 5.33(a), il record in cima alla pila rappresenta $S$ e contiene l'attributo ereditato $S.italic("next") = x$: $x$ è l'etichetta a cui trasferire il controllo quando il *while* termina. La figura (b) mostra la pila dopo l'espansione di $S$ mediante la produzione $S -> bold("while") space ( quad C quad ) space S_1$.

  #figure(image("images/implemSTDwhileAlVolo.png", width: 80%))

  Nella figura la *cima della pila è a sinistra*. Possiamo leggere i record come una sequenza di operazioni ancora da svolgere: riconoscere *while* e la parentesi aperta, eseguire la prima azione, elaborare $C$, riconoscere la parentesi chiusa, eseguire la seconda azione ed elaborare $S_1$.

  Durante l'espansione, il record originale di $S$ viene rimosso. Per non perdere il valore $x$, questo viene copiato nel campo $italic("snext")$ del primo _action-record_. A questo punto $C.italic("false")$ e $C.italic("true")$ sono ancora sconosciuti, perché la prima azione non è stata eseguita.

  Il parser procede nel seguente modo:

  + dopo aver riconosciuto *while* e $($, rimuove i relativi record: il primo _action-record_ raggiunge la cima della pila.
  + La prima azione crea le etichette $italic("L1")$ e $italic("L2")$, rispettivamente per l'inizio della condizione e del corpo. Assegna:
    $
      C.italic("false") = italic("snext") = x,
      quad C.italic("true") = italic("L2").
    $
    Copia inoltre le etichette nei campi $italic("al1")$ e $italic("al2")$ del secondo _action-record_, perché serviranno dopo che il primo sarà stato rimosso. Infine emette l'etichetta $italic("L1")$.
  + Il parser elabora $C$, emettendo il codice della condizione: questo trasferisce il controllo a $italic("L2")$ se la condizione è vera e a $x$ se è falsa.
  + Dopo aver riconosciuto $)$, il secondo _action-record_ raggiunge la cima. La sua azione assegna $S_1.italic("next") = italic("al1")$, cioè $italic("L1")$, ed emette l'etichetta conservata in $italic("al2")$, cioè $italic("L2")$.
  + Infine viene elaborato $S_1$, emettendo il codice del corpo con il ritorno alla condizione indicato da $S_1.italic("next")$.

  Gli accessi allo stack individuano i record destinatari delle assegnazioni. Per esempio, quando la prima azione è in cima, $italic("stack")[italic("top") - 1]$ è il record di $C$, mentre $italic("stack")[italic("top") - 3]$ è quello della seconda azione.

  L'uscita viene quindi prodotta nell'ordine: etichetta $italic("L1")$, codice della condizione, etichetta $italic("L2")$ e codice del corpo. Le copie nei record servono a conservare le informazioni fino al momento in cui verranno utilizzate.
]

#example()[

  Consideriamo ora lo stesso *while*, ma questa volta vogliamo costruire $S.italic("code")$ come *attributo sintetizzato*: i frammenti vengono conservati sotto forma di stringhe e concatenati quando sono tutti disponibili.

  Utilizziamo la seguente proprietà invariante:
  
  _Ogni non-terminale cui è associato del codice lascia tale codice memorizzato nel synthesize-record predisposto immediatamente al di sotto del proprio record nella pila._

  La figura 5.35(a) mostra la situazione prima dell'espansione di $S$: sotto il suo record si trova un _synthesize-record_ destinato a conservare $S.italic("code")$. La figura (b) mostra invece la situazione dopo l'espansione; anche qui la *cima è a sinistra*.

  #figure(image("images/implemWhileSTDsint.png", width: 80%))

  Il _synthesize-record_ di $S$ rimane nella pila mentre vengono elaborati i simboli del corpo della produzione. Vengono inoltre predisposti i _synthesize-record_ di $C$ e di $S_1$, che conserveranno i rispettivi frammenti di codice.

  Occorre fare una piccola correzione al libro: nella figura (b), $C.italic("false")$ va interpretato come *già inizializzato a $x$*. Il testo assume infatti che $S.italic("next")$ venga copiato direttamente nel record di $C$ durante l'espansione, eliminando il passaggio attraverso il campo $italic("snext")$ usato nell'esempio precedente. Il punto interrogativo rimasto nel disegno non riflette questa semplificazione.

  L'elaborazione procede così:

  + Dopo il riconoscimento di *while* e $($, l'_action-record_ raggiunge la cima. La sua azione crea $italic("L1")$ e $italic("L2")$, assegna $C.italic("true") = italic("L2")$ e $S_1.italic("next") = italic("L1")$, e conserva le due etichette nei campi $italic("l1")$ e $italic("l2")$ del _synthesize-record_ di $S_1$.
  + Il parser elabora $C$ e deposita il risultato $C.italic("code")$ nel suo _synthesize-record_.
  + Quando questo record raggiunge la cima, esegue un'azione che copia il risultato nel campo $italic("Ccode")$ del _synthesize-record_ di $S_1$. In questo modo il codice della condizione rimane disponibile anche dopo la rimozione del _synthesize-record_ di $C$.
  + Dopo aver riconosciuto $)$, il parser elabora $S_1$ e deposita il codice del corpo nel campo $italic("code")$ del relativo _synthesize-record_.
  + Il _synthesize-record_ di $S_1$ raggiunge quindi la cima. A questo punto contiene tutti i dati necessari: le etichette, il codice della condizione e quello del corpo. La sua azione li concatena nell'ordine corretto e salva il risultato nel campo $italic("code")$ del _synthesize-record_ di $S$, immediatamente sottostante.

  Il _synthesize-record_ di $S_1$ svolge quindi un *doppio ruolo*: conserva il codice del corpo e raccoglie i dati necessari per completare il codice dell'intero *while*. Il risultato finale rimane nel _synthesize-record_ di $S$, disponibile per la traduzione del costrutto che contiene questo statement.

  In questo esempio le azioni non emettono direttamente i frammenti: li conservano e li combinano. Le copie garantiscono che ogni valore sopravviva alla rimozione del record che lo ha prodotto, fino al momento del suo utilizzo.
]

=== Implementazione di uno SDT con parser LR

Una SDD *L-attribuita basata su una grammatica LL* può essere implementata anche mediante parsing bottom-up, adattando la grammatica con opportuni non-terminali marcatori. L'ipotesi che la grammatica di partenza sia LL è essenziale per questa costruzione: il risultato non si estende automaticamente a qualsiasi SDD L-attribuita basata su una grammatica LR.

Le regole per effettuare questa trasformazione sono le seguenti:

+ Si inizia da uno SDT costruito come descritto nella sezione #link(<6.4.4>)[6.4.4], e che prevede azioni all'interno del corpo prima di ogni non-terminale per calcolare gli attributi ereditati, e un'azione alla fine per calcolare gli attributi sintetizzati.

+ Si introduce nella grammatica un *marcatore* (Non-Terminale Marcatore, NTM) per ogni azione interna al corpo della produzione. Ogni azione richiede un marcatore distinto e ogni marcatore $M$ deve avere una produzione del tipo $M -> epsilon$.

+ Si modifica un'azione $a$ se il marcatore $M$ la sostituisce in qualche produzione del tipo $A -> alpha {a} beta$, e si associa alla produzione $M -> epsilon$ un'azione $a'$ che:

  - Copia, come attributi ereditati di $M$, tutti gli attributi di $A$ e dei simboli in $alpha$ di cui l'azione $a$ necessita;
  - Calcola gli attributi nello stesso modo di $a$, ma li rende *attributi sintetizzati* di $M$ (così che possano essere salvati sulla pila semantica e letti successivamente).

#observation()[
  Introducendo NTM in una grammatica LL, ciascuno di essi presente in un'unica posizione nei corpi delle produzioni e dotato della sola produzione $M -> epsilon$, si ottiene una grammatica della classe LR. La riduzione $M -> epsilon$ permette di eseguire l'azione nel punto richiesto, senza consumare simboli d'ingresso.
]

Vediamo come applicare queste regole su una grammatica LL:
#example()[
  Consideriamo una produzione $A -> B C$ e sia $B.i$ un attributo ereditato calcolato sulla base di un altro attributo ereditato $A.i$ mediante una generica relazione $B.i = f(A.i)$. Il frammento di SDT che rispecchia tale situazione è il seguente:
  $
    A -> { B.i = f(A.i); } space B space C
  $

  Introduciamo ora il marcatore $M$ dotato di un attributo ereditato $M.i$ e uno sintetizzato $M.s$. Il primo sarà una copia di $A.i$, mentre il secondo sarà il risultato $B.i$. Lo schema di traduzione diviene:
  $
    & A -> M B C \
    & M -> { M.i = A.i; space M.s = f(M.i); }
  $

  Si noti che, formalmente, $A.i$ non è direttamente disponibile per la regola relativa a $M$. Tuttavia, in un parser LR si può fare in modo che ogni attributo ereditato relativo a un non-terminale (come $A$) sia sempre posizionato sullo stack *immediatamente al di sotto* della posizione in cui avrà luogo, più tardi, la riduzione ad $A$.

  In questo modo, quando il parser effettuerà la riduzione $M -> epsilon$, troveremo $A.i$ in una posizione dello stack da cui può essere letto. Inoltre, il valore calcolato $M.s$ rimarrà sullo stack al posto di $M$ e si troverà, come ci si aspetta, esattamente al di sotto del punto in cui, più tardi, avverrà la riduzione a $B$.
]

#example()[
  
  Trasformiamo lo schema di traduzione del costrutto $bold("while")$ in un nuovo SDT che possa operare durante un parsing LR della grammatica adattata.

  L'SDT originale L-attribuito aveva azioni prima di $C$ e prima di $S_1$. Introducendo un marcatore $M$ prima di $C$ e un marcatore $N$ prima di $S_1$, la grammatica sottostante diviene:
  $
    & S -> bold(text("while")) ( M C ) N S_1 \
    & M -> epsilon \
    & N -> epsilon
  $

  Prima di trattare le azioni associate ai marcatori $M$ ed $N$, rivediamo l'ipotesi induttiva a proposito della posizione in cui il parser LR memorizzerà gli attributi sullo stack:

  - $S.n e x t$ si trova al di sotto del corpo della produzione (immediatamente sotto il token $bold("while")$).
  - $C.t r u e$ e $C.f a l s e$ si trovano immediatamente sotto il record per $C$. Il record di $M$ si troverà proprio lì e conterrà questi attributi "calcolati" come sintetizzati.
  - $S_1.n e x t$ si troverà nel record di $N$, immediatamente sotto il record di $S_1$.
  - $C.c o d e$ si troverà nel record di $C$.
  - $S_1.c o d e$ si troverà nel record di $S_1$.

  Seguiamo ora il riconoscimento del *while*. Supponiamo che il valore di $S.italic("next")$ sia già disponibile nel record immediatamente sottostante alla porzione di pila destinata al corpo della produzione.

  Dopo aver riconosciuto *while* e $($, il parser effettua la riduzione $M -> epsilon$. Questa non consuma simboli d'ingresso e introduce sulla pila il record del marcatore $M$, eseguendo l'azione associata. La figura 5.36 mostra la situazione dopo l'inserimento di $M$.

  #figure(image("images/2026-05-18-09-02-04.png"))

  L'azione crea le etichette $italic("L1")$ e $italic("L2")$ e le conserva nel record di $M$. Nello stesso record vengono memorizzati:

  - il valore destinato a $C.italic("true")$, uguale a $italic("L2")$, cioè l'etichetta del corpo.
  - Il valore destinato a $C.italic("false")$, uguale a $S.italic("next")$, cioè l'etichetta di uscita dal *while*.

  Con $M$ in cima, il record contenente $S.italic("next")$ si trova tre posizioni più in basso, sotto i record di $($ e *while*. Per questo l'azione lo recupera mediante $italic("stack")[italic("top") - 3].italic("next")$.

  Questi valori sono *sintetizzati dal marcatore $M$*, ma rappresentano gli *attributi ereditati di $C$*. Il record di $M$ li mantiene disponibili mentre il parser riconosce la condizione. Quando questa viene ridotta a $C$, il suo attributo sintetizzato $C.italic("code")$ viene memorizzato nel record di $C$, immediatamente sopra quello di $M$.

  Il parser riconosce poi $)$ ed effettua la riduzione $N -> epsilon$. Il nuovo record di $N$ deve contenere il valore destinato a $S_1.italic("next")$, affinché il corpo torni a valutare la condizione. L'azione recupera quindi $italic("L1")$ dal record di $M$:
  $
    S_1.italic("next") =
    italic("stack")[italic("top") - 3].italic("L1").
  $
  In questa assegnazione il valore viene memorizzato nel record di $N$. L'indice è riferito alla situazione in cui $N$ è già in cima: sotto di esso si trovano, nell'ordine, $)$, $C$ e $M$.

  Infine viene riconosciuto il corpo $S_1$. Il suo codice è costruito utilizzando il valore ereditato conservato in $N$ e viene memorizzato come attributo sintetizzato nel record di $S_1$.

  #figure(image("images/2026-05-18-09-02-15.png", width: 90%))

  La figura 5.37 mostra la pila quando l'intero corpo della produzione è stato riconosciuto:
  $
    S -> bold("while") space ( space M space C space ) space N space S_1.
  $
  Ora il parser può effettuare la riduzione a $S$. Con $S_1$ in cima:

  - il record di $M$, contenente le etichette, si trova in $italic("stack")[italic("top") - 4]$.
  - Il record di $C$, contenente il codice della condizione, si trova in $italic("stack")[italic("top") - 3]$.
  - Il record di $S_1$, contenente il codice del corpo, si trova in $italic("stack")[italic("top")]$.

  L'azione della riduzione finale concatena questi elementi e conserva temporaneamente il risultato prima di modificare la pila:
  $
    italic("tempCode") &=
      bold("label") ||
      italic("stack")[italic("top") - 4].italic("L1") \
    & quad ||
      italic("stack")[italic("top") - 3].italic("code") \
    & quad || bold("label") ||
      italic("stack")[italic("top") - 4].italic("L2") \
    & quad ||
      italic("stack")[italic("top")].italic("code"); \
    italic("top") &= italic("top") - 6; \
    italic("stack")[italic("top")].italic("code")
      &= italic("tempCode");
  $

  I *sette record* del corpo vengono sostituiti da un unico record per $S$, quindi la pila si accorcia di *sei posizioni*. Il nuovo record occupa la posizione precedentemente occupata da *while* e riceve il valore di $S.italic("code")$.

  Il salto di ritorno alla condizione è già previsto nel codice di $S_1$, grazie al valore $S_1.italic("next") = italic("L1")$, e non viene aggiunto nuovamente durante la concatenazione. Come negli esempi precedenti, sono omessi gli aggiornamenti degli stati del parser LR.
]
