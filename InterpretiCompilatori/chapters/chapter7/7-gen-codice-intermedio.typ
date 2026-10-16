#import "../../../dvd.typ": *
#import "@preview/algo:0.3.6": algo, code, comment, d, i
#pagebreak()

= Generazione del codice intermedio
Questo capitolo tratta le *rappresentazioni intermedie*, il *controllo di tipo statico* (*static type checking*) e la *generazione del codice intermedio*.
#figure(image("images/strutturaFrontEnd.png"))
Per semplificare, assumeremo che il front-end del compilatore sia organizzato in modo che il parsing, il controllo statico e la generazione del codice intermedio siano eseguiti sequenzialmente; in alcuni compilatori ottimizzati, il controllo statico e la generazione del codice possono essere combinati e incorporati direttamente all'interno delle fasi di parsing (tramite le SDD).

Grazie alle tecniche viste nel capitolo precedente, molti degli schemi di traduzione possono essere implementati basandosi su parsing sia bottom-up sia top-down. In ogni caso, è sempre possibile realizzare un qualsiasi schema di traduzione costruendo prima l'albero sintattico (AST) in memoria e poi visitandolo opportunamente.

#definition()[
  I *controlli statici* (o *analisi semantica statica*) sono un insieme di controlli di consistenza effettuate al momento della compilazione allo scopo di:

  + garantire che un programma compili con *successo* e rispetti le regole di significato del linguaggio.

  + Individuare eventuali errori di programmazione prima dell'esecuzione vera e propria del programma.
]

Esistono due classi di controlli:

+ *Sintattici*: quali forme sentenziali che la grammatica consente di produrre sono effettivamente accettate dal linguaggio.
  #example()[
    - Identificatori di variabili dichiarati al più una volta in uno scope.
    - Un `break` deve essere dentro un `while`, un `for` o uno `switch`
    - Distinzione del significato degli identificatori a sinistra e destra di un assegnamento:
    $
      i=5, quad underbracket(i, "l-value") = underbracket(i+1, "r-value")
    $
  ]
+ *Di tipo (type checking)*: garantire che un operatore/funzione siano applicati ad un numero corretto di operandi e che il loro tipo sia adeguato.
  #example()[
    Conversioni di tipo come casting o coercizione (conversione implicita, fatta dal compilatore: con $x=4+5.1$, $x$ diventa un float).
  ]
Torneremo più avanti sull'analisi statica: vediamo prima le rappresentazioni intermedie.
== Varianti degli alberi sintattici
#figure(
  image("images/tanteRapprInter.png"),
  caption: "Una rappresentazione intermedia di alto livello è vicina al codice sorgente, una di basso livello è più vicina alla macchina target.",
)
La rappresentazione intermedia di alto livello fa quasi sempre uso di alberi sintattici (AST), o meglio, di una loro variante detta *DAG* (Directed Acyclic Graph, Grafo Diretto Aciclico). A basso livello, invece, l'AST/DAG verrà "appiattito" facendo uso di *codice a 3 indirizzi*.

#definition("DAG")[
  Un *grafo diretto aciclico* o *DAG* relativo a un'espressione identifica le sue sottoespressioni comuni, che appaiono cioè più di una volta.
]

I DAG possono essere costruiti "al volo" esattamente con le stesse tecniche viste per gli alberi sintattici.

=== Grafi diretti aciclici delle espressioni
Come un albero sintattico di un'espressione, in un DAG le foglie corrispondono agli operandi atomici (identificatori e numeri), mentre i nodi interni identificano gli operatori.\ La differenza sta nel fatto che, in un DAG, un nodo $N$ può avere *più di un genitore* se esso rappresenta una sotto-espressione comune. In un albero sintattico puro, invece, il sottoalbero corrispondente a una sotto-espressione comune verrebbe replicato tante volte quante la sotto-espressione appare nell'espressione complessiva. Un DAG, pertanto, non solo rappresenta le espressioni in modo molto più compatto in memoria, ma fornisce anche al compilatore indicazioni preziose per la generazione di codice ottimizzato ed efficiente.

#example()[
  Data l'espressione $a+a* (b-c) + (b-c) *d$, il relativo DAG associato è mostrato nella parte destra dell'immagine:
  <esempioDAG1>
  #figure(image("images/ASTvsDAG.png", width: 80%))
  Da notare come il nodo $a$ abbia due genitori in quanto appare due volte nell'espressione, e il nodo dell'operazione $-$ (che rappresenta $b - c$) sia puntato da ben due operatori di moltiplicazione diversi. Con un albero sintattico l'espressione sarebbe invece stata rappresentata come a sinistra: si replicano le sottoespressioni che appaiono più volte.
]

La seguente SDD può costruire sia alberi sintattici sia DAG, a patto di modificare le funzioni costruttrici `Leaf()` e `Node()` in modo che, prima di allocare un nuovo nodo in memoria, verifichino se ne esiste già uno identico. In tal caso, tale nodo viene riutilizzato e restituito.

#figure(image("images/SDDcostruzioneDAGeAST.png"))

Per esempio, prima di costruire un nuovo nodo `Node(op, left, right)`, la logica del compilatore deve scansionare una tabella hash per verificare se esiste già un nodo con etichetta `op` e con figli `left` e `right` (esattamente in quest'ordine). Se tale nodo esiste, la funzione `Node()` restituisce il puntatore a quel nodo; altrimenti, ne alloca uno nuovo.

#example()[
  La seguente sequenza di passi costruisce il DAG mostrato nell'esempio #link(<esempioDAG1>, [precedente]), a patto che le funzioni `Leaf()` e `Node()` ritornino un nodo gia esistente, secondo quanto appena discusso.
  #figure(image("images/passiCostruzioneDAG.png"))

  Assumiamo che `entry-a` sia un puntatore all'elemento della tabella dei simboli relativo ad $a$, e così per gli altri identificatori.
  Alla seconda invocazione di `Leaf(id, entry-a)` (linea 2), la funzione restituisce il puntatore al nodo precedentemente costruito, ovvero `p2 = p1`. Analogamente, i nodi restituiti ai passi 8 e 9 coincidono con quelli restituiti ai passi 3 e 4 (`p8 = p3` e `p9 = p4`).
  Di conseguenza, l'operazione - calcolata al passo 10 ha esattamente gli stessi operandi del passo 5: il nodo restituito sarà lo stesso (`p10 = p5`), chiudendo il ciclo di riutilizzo che forma il DAG.
]

=== Metodo del valore numerico per la costruzione di DAG
I nodi di un albero sintattico o di un DAG possono essere memorizzati in modo efficiente all'interno di un array di record. Ogni riga di questo array rappresenta un record e quindi un nodo.

In questa struttura:

- il primo campo contiene un codice operativo (`op`) che indica l'etichetta del nodo (l'operatore o il tipo di foglia).
- Se il nodo è una foglia, l'array memorizza un campo aggiuntivo contenente il valore lessicale (ad esempio, un puntatore a un elemento della tabella dei simboli `entry` o una costante numerica).
- Se il nodo è interno, l'array contiene due campi aggiuntivi che memorizzano gli indici delle righe corrispondenti al figlio sinistro e al figlio destro.

#figure(
  image("images/DAGarray.png"),
  caption: "Nel diagramma (b) le foglie hanno un campo aggiuntivo contenente il valore lessicale; i nodi interni hanno due campi aggiuntivi che rappresentano i figli sinistro e destro.",
)

In questo array ci si riferisce ai nodi e alle sottoespressioni semplicemente mediante l'indice del record corrispondente. Storicamente, tale indice è chiamato *valore numerico* del nodo o dell'espressione che esso rappresenta. Per esempio, nel diagramma precedente, il nodo con etichetta + ha valore numerico 3 e i suoi figli sinistro e destro hanno rispettivamente valore numerico 1 e 2. Benché in pratica si utilizzino spesso puntatori ai record o riferimenti agli oggetti, si continua a usare il termine “valore numerico” per indicare i riferimenti a un nodo. Se memorizzati in una opportuna struttura dati, i valori numerici permettono di costruire il DAG di un'espressione in modo molto efficiente attraverso un algoritmo.

Supponiamo che i nodi siano memorizzati in un array, e ci si riferisca a essi mediante il loro valore numerico. Chiamiamo *signature* o *firma* di un nodo interno la tripla <`op,l,r`>, in cui `op` è l'etichetta, `l` il valore numerico del figlio sinistro e `r` quello del figlio destro. Per un operatore unario possiamo assumere convenzionalmente che `r` = 0.

#[
  #set heading(numbering: none, outlined: false)
  === Metodo del valore numerico per la costruzione dei nodi di un DAG
]
*INPUT*: L'etichetta `op`, il nodo `l` e il nodo `r`. \
*OUTPUT*: Il valore numerico di un nodo nell'array con firma <`op,l,r`>. \
*METODO*: Si cerchi nell'array un nodo $M$ con etichetta `op`, figlio sinistro `l` e figlio destro `r`. Se un tale nodo esiste, si restituisca il valore numerico di $M$. Altrimenti si crei un nuovo nodo $N$ con etichetta `op`, figlio sinistro `l`, figlio destro `r` e si restituisca il suo valore numerico.

Benché questo algoritmo produca il risultato desiderato, effettuare una ricerca sull'intero array ogni volta che si deve localizzare un nodo è molto costoso, specialmente se l'array è molto grande (contiene tutte le espressioni di un programma). Un metodo più efficiente si basa sull'uso di una tabella di hash, grazie alla quale i nodi sono raccolti in “gruppi”, ognuno dei quali avrà tipicamente pochi elementi.
Per costruire una tabella di hash per i nodi di un DAG, abbiamo bisogno di una funzione di hash che calcola l'indice del gruppo data una firma <`op,l,r`> in maniera tale da distribuire il più uniformemente possibile le firme nei vari gruppi, cioè in modo che sia improbabile che un gruppo contenga molti più nodi degli altri. L'indice del gruppo $h$(`op,l,r`) è calcolato in modo deterministico a partire da `op`, `l` e `r`, in modo da ottenere sempre lo stesso gruppo a partire da uno stesso nodo. Ogni gruppo può poi essere implementato mediante una lista, come mostrato nel diagramma che segue.

#figure(image("images/hash.png", width: 70%))

Un array, indicizzato in base al valore della funzione di hash, contiene i puntatori alle teste delle varie liste. Ogni elemento di una tale lista contiene poi il valore numerico di un nodo che, secondo la funzione di hash, appartiene al gruppo. Quindi, dato un nodo d'ingresso descritto da `op`, `l` e `r`, calcoliamo dapprima l'indice del gruppo $h$(`op,l,r`), quindi effettuiamo una ricerca del nodo richiesto all'interno della lista corrispondente al gruppo trovato. Se si ha corrispondenza, restituiamo il valore numerico $v$. Se non troviamo invece un tale nodo, siamo sicuri che esso non può trovarsi in nessun altro gruppo, per cui creiamo un nuovo elemento, lo aggiungiamo alla lista relativa al gruppo con indice $h$(`op,l,r`) e restituiamo il valore numerico associato al nuovo elemento.

== Codice a tre indirizzi
Il codice a tre indirizzi prevede al più un operatore nel lato destro di una istruzione. In altre parole, le espressioni aritmetiche composte non sono permesse. Secondo questa definizione, un'espressione in linguaggio sorgente come per esempio `x+y*z` potrebbe essere tradotta nella seguente sequenza di istruzioni a tre indirizzi:

- `t1 = y * z`
- `t2 = x + t1`

in cui `t1` e `t2` sono nomi temporanei generati dal compilatore. Il ricorso a nomi temporanei per memorizzare i valori intermedi calcolati da un dato programma rende il codice a tre indirizzi particolarmente semplice da riorganizzare.

#example()[
  Il codice a tre indirizzi è una rappresentazione lineare di un albero sintattico o di un DAG, in cui i nomi temporanei espliciti corrispondono ai nodi interni del grafo.
  #figure(image("images/DAG3Indirizzi.png", width: 70%))
]

=== Indirizzi e istruzioni
Il codice a tre indirizzi si basa su due concetti fondamentali: gli *indirizzi* e le *istruzioni*. Un indirizzo può assumere una delle seguenti forme:

+ un  nome;
+ una costante;
+ un nome temporaneo generato dal compilatore;

Le istruzioni più comuni appaiono invece nelle seguenti forme:

+ Istruzioni di assegnamento del tipo `x = y op z` (`op` operatore logico binario `x`, `y`, `z` indirizzi).
+ Istruzioni di assegnamento del tipo `x = op z` (`op` operazione unaria, come negazione logica, meno unario, operatori di scorrimento e conversione...).
+ Istruzioni di copia del tipo `x = y`.
+ Istruzioni di salto incondizionato del tipo `goto L` (`L` etichetta simbolica).
+ Istruzioni di salto condizionato del tipo `if x goto L `oppure `ifFalse x goto L`
+ Istruzioni di salto condizionato del tipo `if x relop y goto L` (con `relop` $in {<, <=, ==, dots}$).
+ Chiamata di procedura e ritorno da procedura:
  $
    #raw("param") x_1\
    #raw("param") x_2\
    dots\
    #raw("param") x_n\
    #raw("call") p, n
  $
  sequenza generata in corrispondeza della chiamata di procedura $p(x_1, dots, x_n)$.
+ Istruzioni di copia indicizzata del tipo `x = y[i]` oppure `x[i] = y`.
+ Assegnamenti di puntatori e indirizzi del tipo `x = &y` (assegna a `x` l'indirizzo di `y`, ovvero assegna all'r-value di `x` l'l-value di `y`),` x = *y` (l'r-value di `x` assume il valore che si trova alla locazione di memoria rappresentata dall'r-value di `y`), oppure `*x = y`.

#example()[
  Consideriamo il seguente statement: `do i = i+1; while (a[i] < v);`. Si possono avere due possibili traduzioni: nella prima si associa un'etichetta simbolica alla prima istruzione, nella seconda si utilizzano i numeri delle posizioni delle istruzioni.
  #figure(image("images/etichetteCodice3indirizzi.png", width: 80%))

  La moltiplicazione è necessaria per il calcolo dell'indirizzo di offset, supponendo che ogni elemento dell'array `a` abbia dimensione pari a 8 unità.
]

=== Quadruple
La descrizione delle istruzioni a tre indirizzi specifica le varie componenti di ogni tipo di istruzione, ma non fornisce alcuna indicazione a proposito dell'implementazione dell'istruzione in un'opportuna struttura dati. In un compilatore reale le istruzioni possono essere implementate come oggetti o come record aventi opportuni campi per l'operatore e per gli operandi. Tre comuni rappresentazioni sono le “quadruple”, le “triple” e le “triple indirette”.

Una *quadrupla* o *quad* ha quattro campi che chiamiamo `op`, `arg1`, `arg2` e `result`. Il campo `op` contiene un codice interno che indica l'operatore. Per esempio, l'istruzione a tre indirizzi `x = y + z` è rappresentata assegnando `+` al campo `op`, `y` ad `arg1`, `z` ad `arg2`, e `x` a `result`.

Alcune eccezioni a questa regola generale sono:

+ le istruzioni con operatori unari come $x$` = minus`$y$ oppure istruzioni di copia come `x = y` non utilizzano `arg2`. Si noti inoltre che per le operazioni di copia `op` è l'operatore di assegnamento `=`, mentre per la maggior parte delle altre operazioni l'assegnamento è da considerarsi implicito.
+ Le istruzioni come `param` non usano né `arg2`, né `result`.
+ Le istruzioni di salto condizionato e incondizionato salvano l'etichetta in `result`.

#example()[
  Il codice a tre indirizzi dell'assegnamento `a = b*-c+ b*-c;` è mostrato nella figura che segue. L'operatore speciale `minus` è utilizzato per distinguere il meno unario, come in `-b`, dall'operatore binario di sottrazione, come in `b - c`. Si noti che le istruzioni relative al meno unario, così come l'istruzione di copia `a = t5`, utilizzano solamente due dei tre indirizzi.
  #figure(image("images/esQuadruple.png"))
]


=== Triple
Una *tripla* è un record avente solamente i tre campi `op`, `arg1` e `arg2`.
Come si nota dalla Figura 6.10(b), il campo `result` è utilizzato principalmente da variabili temporanee. E' possibile e conveniente riferirsi al risultato di un'operazione `z op y` non mediante un nome temporaneo esplicito, bensì in modo indiretto mediante la posizione dell'operazione nella sequenza di codice. Sempre con riferimento alla figura (b), una rappresentazione mediante triple non farebbe riferimento alla variabile `t1`, bensì alla posizione `(0)`. Secondo tale notazione, i numeri tra parentesi indicano puntatori alla struttura stessa di triple.

#example()[
  L'albero sintattico e le triple della figura che segue corrispondono alle quadruple e al codice a tre indirizzi mostrato nella Figura 6.10. Secondo la rappresentazione basata sulle triple della figura (b), l'istruzione di copia `a = t5` è codificata ponendo `a` nel campo `arg1` e il valore numerico `(4)` nel campo `arg2`.
  #figure(image("images/esTriple.png", width: 70%))
]

Uno dei vantaggi delle quadruple rispetto alle triple emerge considerando i compilatori ottimizzanti, in cui spesso le istruzioni vengono riorganizzate e spostate. Usando le quadruple, infatti, se spostiamo un'istruzione che calcola una variabile temporanea `t`, le istruzioni che utilizzano `t` non richiedono alcuna modifica. Usando le triple, invece, ci si riferisce al risultato di un'operazione mediante la sua posizione nel codice, perciò spostare un'istruzione richiede una modifica a tutte le triple che fanno riferimento al risultato che questa calcola. Tale problema, tuttavia, può essere risolto grazie alle triple indirette.


=== Triple indirette
Le *triple indirette* consistono in una lista di puntatori a triple, piuttosto che in una lista delle triple stesse. Possiamo per esempio usare un array _instruction_ per memorizzare i puntatori alle triple nell'ordine desiderato. In tal caso, le triple della Figura 6.11(b) potrebbero essere rappresentate come nella Figura 6.12.

#figure(image("images/es1tripleIndirette.png", width: 80%))
Le triple indirette consentono ai compilatori ottimizzati di spostare le istruzioni modificando solo l'ordine dei riferimenti nell'array _instruction_, senza cambiare le triple stesse.

#example()[
  #figure(image("images/es2tripleIndirette.png", width: 80%))
  Consideriamo l'assegnamento `z = (x + y) * (10 + w)`. Le prime due triple calcolano le somme, la terza ne moltiplica i risultati e l'ultima assegna il prodotto a `z`. Poiché le due somme sono indipendenti, possono essere eseguite in ordine inverso.

  La figura mostra che, scambiando direttamente le prime due triple, occorre aggiornare i riferimenti nella moltiplicazione da `(0), (1)` a `(1), (0)`. Con le *triple indirette*, invece, basta riordinare i puntatori nell'array _instruction_, passando dalla sequenza `(0), (1), (2), (3)` alla sequenza `(1), (0), (2), (3)`: le triple rimangono nelle posizioni originarie e i riferimenti ai loro risultati restano invariati.
]

== Tipi e dichiarazioni
L'uso dei tipi ha diversi obiettivi, raggruppabili in due classi.

- *Controllo di tipo* o *type checking*: analizzare staticamente quello che sarà il comportamento del programma. Analisi che garantisce che i tipi degli operandi siano adatti all'operazione.
- *Traduzione*: in base al tipo di un nome, il compilatore può determinare lo spazio di memoria necessario a run-time per l'oggetto (in senso generale, non in termini di _OOP_) a cui il nome si riferisce. Inoltre, le informazioni di tipo sono necessarie per calcolare l'indirizzo relativo a un elemento di un array, per realizzare opportune conversioni di tipo, per selezionare la versione corretta di ogni operatore aritmetico e molto altro ancora.

Vedremo i tipi e l'organizzazione della memoria per i nomi dichiarati all'interno di una procedura o di una classe.

=== Espressioni di tipo
I tipi hanno una struttura ben precisa che noi rappresenteremo mediante le *espressioni di tipo* o *type expression*. Una espressione di tipo può essere un tipo di base oppure può essere costruita applicando un operatore detto costruttore di tipo a un'espressione di tipo. Più precisamente:

- un tipo di base è un'espressione di tipo. I classici tipi di base per molti linguaggi sono _boolean_, _char_, _integer_, _float_ e _void_;

- Un nome di tipo è un'espressione di tipo.

- Un'espressione di tipo può essere costruita applicando il costruttore di tipo _array_ a un intero e a un'espressione di tipo.

- Un record è una struttura dati composta da campi aventi un nome (tipo le `struct` in C). Una espressione di tipo può essere in questo caso ottenuta applicando il costruttore di tipo _record_ ai nomi dei campi e ai loro tipi.

- Un'espressione può essere ottenuta applicando il costruttore di tipo $->$ relativo ai tipi delle funzioni. Scriviamo $s -> t$ per indicare una funzione dal tipo $s$ (tipo degli argomenti) al tipo $t$ (tipo del valore restituito).

- Se $s$ e $t$ sono espressioni di tipo, anche il loro prodotto cartesiano $s times t$ è un'espressione di tipo.

- Le espressioni di tipo possono contenere variabili i cui valori sono altre espressioni di tipo.

#example()[
  Il tipo array `int[2][3]` può essere interpretato come “array di 2 array, ognuno di tre interi” e descritto mediante l'espressione di tipo _array(2, array(3, integer))_. L'operatore array richiede due operandi: un numero intero e un tipo.
  #figure(image("images/exprTipoArray.png", width: 60%))
]

=== Equivalenza di tipo
Se rappresentate mediante grafi, due espressioni di tipo sono
*strutturalmente equivalenti* se e solo se ricorre uno dei seguenti casi:

+ sono lo stesso tipo di base;
+ sono ottenute applicando lo stesso costruttore di tipo a espressioni
  di tipo strutturalmente equivalenti a due a due;
+ una è un nome di tipo che indica l'altra.

Nell'*equivalenza per nome*, invece, i nomi di tipo vengono considerati
come tali, senza espanderne le definizioni. Due espressioni di tipo sono
equivalenti per nome se ricorre uno dei seguenti casi:

+ sono lo stesso tipo di base oppure lo stesso nome di tipo;
+ sono ottenute applicando lo stesso costruttore a espressioni di tipo
  equivalenti per nome a due a due.

Di conseguenza, due nomi di tipo distinti non sono equivalenti per nome
soltanto perché descrivono la stessa struttura.

=== Dichiarazioni
Studieremo i tipi e le dichiarazioni di tipo utilizzando una grammatica semplificata che dichiara un solo nome alla volta. La grammatica semplificata è
la seguente:
$
  D & -> T bold(upright("id")) ";" D "|" epsilon \
  T & -> B space C "|" bold(upright("record")) "{" D "}" \
  B & -> bold(upright("int")) "|" bold(upright("float")) \
  C & -> epsilon "|" "[" bold(upright("num")) "]" C
$
Il non-terminale $D$ genera una sequenza, eventualmente vuota, di dichiarazioni, ciascuna relativa a un solo identificatore. $T$ descrive il tipo, che può essere un tipo di base, un array o un record. In particolare, $B$ seleziona il tipo di base (`int` o `float`), mentre $C$ genera zero o più dimensioni nella forma `[num]`: se $C$ deriva $epsilon$, si ottiene un tipo di base; altrimenti, un array, anche multidimensionale. Infine, `record { D }` descrive un record i cui campi sono definiti dalle dichiarazioni racchiuse tra parentesi graffe.
=== Organizzazione della memoria per i nomi locali
Il tipo di un nome determina la quantità di memoria necessaria
a runtime per memorizzare un valore di quel tipo. Quando tale quantità
è nota durante la compilazione, il compilatore può utilizzarla per
assegnare al nome un indirizzo relativo, cioè uno spiazzamento (_offset_) rispetto
all'inizio della zona di memoria destinata ai dati considerati.
Il tipo e l'indirizzo relativo vengono memorizzati nella corrispondente
voce della tabella dei simboli.

Con _larghezza_ di un tipo si fa riferimento al numero di byte necessari per un oggetto di quel tipo:

- i tipi di base richiedono un numero intero di byte.
- Per semplificare l'accesso, l'organizzazione della memoria relativa ai tipi aggregati prevede un'allocazione continua in un unico blocco.

L'SDT seguente viene utilizzato per calcolare il tipo e la relativa larghezza per i tipi di base e gli array.
$
  T &-> B
  && #h(2em) \{ t = B.italic("type"); w = B.italic("width"); \} \
  & quad C
  && #h(2em) \{ T.italic("type") = C.italic("type"); T.italic("width") = C.italic("width"); \} \
  B &-> bold(upright("int"))
  && #h(2em) \{ B.italic("type") = upright("integer"); B.italic("width") = 4; \} \
  B &-> bold(upright("float"))
  && #h(2em) \{ B.italic("type") = upright("float"); B.italic("width") = 8; \} \
  C &-> epsilon
  && #h(2em) \{ C.italic("type") = t; C.italic("width") = w; \} \
  C &-> "[" bold(upright("num")) "]" C_1
  && #h(2em) \{ C.italic("type") = upright("array")(bold(upright("num")).italic("value"), C_1.italic("type")); \
  & && #h(2em) quad C.italic("width") = bold(upright("num")).italic("value") times C_1.italic("width"); \}
$
$B$ riconosce il tipo di base, assumendo 4 byte per $bold("int")$ e 8 per $bold("float")$; le variabili $t$ e $w$ ne conservano tipo e larghezza durante l'elaborazione di $C$. Quando $C$ deriva $epsilon$, restituisce il tipo di base e la sua larghezza. Per ogni dimensione $bold("[ num ]")$, invece, costruisce un tipo array avente $bold("num").v a l u e$ elementi del tipo calcolato da $C_1$, moltiplicandone la larghezza per il numero di elementi. Infine, $T$ riceve gli attributi calcolati da $C$. Per esempio, `int[2][3]` produce il tipo `array(2, array(3, integer))` e occupa $2 times 3 times 4 = 24$ byte.
#example()[
  Le linee tratteggiate della Figura 6.16 mostrano l'albero di parsing relativo al tipo `int[2][3]`. Le linee continue, invece, mostrano come le informazioni di tipo e larghezza siano propagate dapprima da $B$ alla sequenza discendente di $C$, attraverso le variabili $t$ e $w$, e poi, all'indietro, risalendo la sequenza di $C'$ attraverso gli attributi sintetizzati _type_ e _width_.
  #figure(image("images/SDTtipiArray.png", width: 75%))
]

=== Sequenze di dichiarazioni
Nei linguaggi come C o Java, le dichiarazioni all'interno di una procedura (o blocco) vengono analizzate sequenzialmente. Questo permette al compilatore di assegnare facilmente un indirizzo di memoria relativo a ogni variabile, utilizzando una singola variabile di stato chiamata `offset` ("spiazzamento"). La variabile `offset` tiene traccia della prossima locazione di memoria disponibile all'interno del blocco. Parte da 0 e, ogni volta che nel parsing viene individuato un nuvo nome, tale nome è inserito nella tabella dei simboli, ponendo il suo indirizzo relativo al valore di `offset` corrente; dopodiché, l'`offset` viene incrementato della dimensione (larghezza) del tipo appena dichiarato.

Lo schema di traduzione seguente gestisce una sequenza di dichiarazioni del tipo `T id;`. L'oggetto `top` rappresenta la tabella dei simboli del blocco corrente.

$
  P & ->                           && #h(2em) \{ italic("offset") = 0; \} \
    & quad D \
  D & -> T bold(upright("id")) ";" && #h(2em) \{ italic("top").italic("put")(
                                        bold(upright("id")).italic("lexeme"),
                                        T.italic("type"), italic("offset")); \
    &                              && #h(2em) quad italic("offset") =
                                      italic("offset") + T.italic("width"); \} \
    & quad D_1 \
  D & -> epsilon
$

+ Prima di iniziare ad analizzare la lista di dichiarazioni $D$, l'azione associata al programma $P$ inizializza l'$italic("offset")$ a 0.
+ Per ogni dichiarazione trovata ($T bold(text("id")) ;$), l'identificatore ($bold(upright("id")).italic("lexeme")$) viene salvato nella tabella dei simboli tramite $italic("top").italic("put")$, associandogli il suo tipo ($T.italic("type")$) e il suo indirizzo di memoria relativo ($italic("offset")$).
+ L'$italic("offset")$ viene subito aggiornato sommandogli la dimensione in byte richiesta dal tipo appena dichiarato ($T.italic("width")$), preparandolo per la variabile successiva.

#observation()[
  Nello schema precedente, l'azione che inizializza
  $italic("offset")$ precede già $D$: la prima produzione va quindi
  letta come
  $
    P -> \{ italic("offset") = 0; \} space D.
  $
  La disposizione su righe e colonne diverse è soltanto grafica
  e non modifica il momento in cui l'azione deve essere eseguita.

  Per eseguire questa azione durante il parsing bottom-up, senza
  attendere la riduzione dell'intera produzione di $P$, possiamo
  introdurre un non-terminale marcatore $M$:
  $
    P &-> M space D \
    M &-> epsilon
      && #h(2em) \{ italic("offset") = 0; \}
  $

  L'inizializzazione viene così eseguita alla riduzione
  $M -> epsilon$, prima di elaborare $D$.

  Questa trasformazione riguarda soltanto l'azione iniziale.
  Per ottenere uno SDT interamente postfisso, occorrerebbe trattare
  in modo analogo anche l'azione posta tra
  $T bold(upright("id")) ";"$ e $D_1$, introducendo un ulteriore
  marcatore e rendendogli disponibili le informazioni necessarie.
]

=== Campi nei record e nelle classi

La traduzione delle sequenze di dichiarazioni appena vista ci porta naturalmente al problema della gestione dei campi all'interno dei record e delle classi. Il tipo _record_ può facilmente essere aggiunto alla grammatica di base grazie alla seguente nuova produzione:

$
  T -> bold(text("record")) '\{' space D space '\}'
$

I campi in una tale dichiarazione di record sono specificati dalla sequenza di dichiarazioni interne generate dal non-terminale $D$. L'approccio basato sulla variabile `offset` visto in precedenza può essere esteso per calcolare anche i tipi e gli indirizzi relativi dei campi interni, a patto che siano soddisfatte due condizioni:

- i nomi dei campi all'interno di uno stesso record devono essere tutti distinti (cioè ogni nome può apparire una sola volta nelle dichiarazioni generate da $D$).
- l'`offset`, cioè l'indirizzo relativo, è calcolato rispetto all'indirizzo di base dello specifico record.

#example()[
  L'uso di un nome `x` per indicare un campo interno di un record non entra in conflitto con altri usi dello stesso nome al di fuori del record (o in record diversi). I tre usi di `x` nelle seguenti dichiarazioni, quindi, sono logicamente distinti e non creano alcun conflitto nella tabella dei simboli:

  ```c
    float x;
    record { float x; float y; } p;
    record { int tag; float x; float y; } q;
  ```

  Un successivo assegnamento come `x = p.x + q.x;` assegna alla variabile `x` (globale) il risultato della somma tra i campi di nome `x` contenuti rispettivamente nei record `p` e `q`. Si noti inoltre che l'indirizzo relativo (l'offset in byte) del campo `x` nel record `p` differisce da quello di `x` nel record `q` (perché in `q` il campo `x` è preceduto da `tag`).
]

Per gestire correttamente i record, il compilatore deve sospendere temporaneamente l'ambiente globale, creare un "sotto-ambiente" ripartendo da offset = 0, e poi ripristinare tutto alla fine. Questo si realizza utilizzando due stack di supporto: uno per gli ambienti (_Env_) e uno per gli indirizzi (_Stack_).

#figure(
  image("images/gestioneNomiCampiRecord.png", width: 70%),
  caption: "Gestione dei nomi dei campi nei record",
) <fig16>

La @fig16 mostra come il compilatore costruisce il tipo di un record e calcola gli offset dei suoi campi. Ogni record possiede una propria *tabella dei simboli*: i nomi dei campi vengono inseriti in questa tabella e i loro offset sono calcolati rispetto all'inizio del record.

La produzione, da aggiungere a quelle relative a $T$ nello SDT per il calcolo del tipo e della larghezza di tipi base e array, è $T -> bold(upright("record")) "{" D "}"$, con due gruppi di azioni semantiche eseguiti in momenti diversi:

+ *Prima di elaborare i campi*, subito dopo `record {`:
  - $italic("Env").italic("push")(italic("top"))$ salva sullo stack la tabella dei simboli dell'ambiente esterno.
  - $italic("top") = bold(upright("new")) italic("Env")()$ crea una tabella vuota per i campi del record e la rende corrente.
  - $italic("Stack").italic("push")(italic("offset"))$ salva l'offset raggiunto nell'ambiente esterno.
  - $italic("offset") = 0$ fa iniziare da zero l'allocazione dei campi del record.

+ *Durante l'elaborazione di $D$*, ogni campo viene inserito nella nuova tabella con il proprio tipo e l'offset corrente. La variabile $italic("offset")$ viene incrementata della larghezza del campo, così da indicare la prima posizione disponibile per il successivo.

+ *Dopo aver elaborato i campi*, alla chiusura `}`:
  - $T.italic("type") = italic("record")(italic("top"))$ costruisce il tipo del record usando la tabella dei suoi campi.
  - $T.italic("width") = italic("offset")$ memorizza la larghezza complessiva del record.
  - $italic("top") = italic("Env").italic("pop")()$ e $italic("offset") = italic("Stack").italic("pop")()$ ripristinano la tabella e l'offset dell'ambiente esterno.

Per esempio, in `record { int x; float y; } r;`, assumendo larghezze di 4 e 8 byte e ignorando l'allineamento, $x$ ha offset 0, $y$ ha offset 4 e il record occupa 12 byte. Questi offset sono *interni al record*: dopo il ripristino dell'ambiente esterno, la dichiarazione di $r$ usa il valore esterno di $italic("offset")$ e lo incrementa di 12.\ I due stack, $italic("Env")$ e $italic("Stack")$, consentono di gestire anche *record annidati*, salvando e ripristinando il contesto a ogni livello. Sono strutture usate dal compilatore durante la traduzione.

== Traduzione delle espressioni
Vediamo ora la traduzione delle espressioni e delle istruzioni. Iniziamo qui con la traduzione delle espressioni in codice a tre indirizzi. Una espressione, come $a+b*c$, contenente più di un operatore, sarà tradotta in istruzioni a tre indirizzi, ognuna contenente un solo operatore. Un riferimento a un elemento di un array, come $A[i][j]$ sarà espanso in una sequenza di più istruzioni a tre indirizzi che calcolano l'indirizzo dell'elemento specificato.

=== Operazioni nelle espressioni
#figure(image("images/SDDcodice3indirizzi.png"))
La definizione guidata dalla sintassi mostrata sopra costruisce il codice a tre indirizzi di un'istruzione di assegnamento $S$ facendo ricorso all'attributo _code_ di $S$ e agli attributi _code_ e _addr_ dell'espressione denotata da $E$. Gli attributi $S.c o d e$ ed $E.c o d e$ indicano il codice a tre indirizzi relativo rispettivamente a $S$ ed $E$. L'attributo $E.a d d r$, invece, indica l'indirizzo della locazione di memoria che conterrà il valore di $E$. Si tenga presente che, come già visto, un indirizzo può essere un nome, una costante oppure una variabile temporanea generata dal compilatore.

Si consideri l'ultima produzione $E -> bold(text("id"))$ della SDD. Quando un'espressione coincide con un singolo identificatore $x$, $x$ stesso contiene il valore dell'espressione. Per questa ragione, la regola semantica associata a tale produzione assegna all'attributo $E.a d d r$ il puntatore all'elemento della tabella dei simboli che si riferisce alla specifica occorrenza di $bold("id")$. Se _top_ indica la tabella dei simboli corrente, la funzione _top.get()_ restituisce l'elemento della tabella dei simboli individuato in base alla stringa $bold("id").italic("lexeme")$ relativa all'istanza di $bold(id)$ in esame. All'attributo $E.c o d e$ viene invece assegnata la stringa vuota.\ Quando si considera la produzione $E -> ( E_1 )$, la traduzione di $E$ coincide con quella della sottoespressione $E_1$, pertanto $E.italic("addr")$ prende il valore di $E_1.italic("addr")$ ed $E.italic("code")$ prende il valore di $E_1.italic("code")$. I due operatori di somma ($+$) e di negazione (cioè il $-$ unario) sono rappresentativi della maggioranza degli operatori nei comuni linguaggi di programmazione. Le regole semantiche associate alla produzione $E -> E_1 + E_2$ generano il codice per calcolare il valore di $E$ a partire dai valori di $E_1$ e $E_2$. Il risultato è assegnato a una nuova variabile temporanea generata dal compilatore. Se i valori di $E_1$ ed $E_2$ si trovano agli indirizzi indicati rispettivamente da $E_1.italic("addr")$ ed $E_2.italic("addr")$, allora $E_1 + E_2$ viene tradotto come $t = E_1.italic("addr") + E_2.italic("addr")$, in cui $t$ è un nuovo nome temporaneo. L'attributo $E.italic("addr")$ contiene il nome $t$, che identifica la destinazione del risultato. Si noti che esecuzioni successive dell'istruzione $bold(upright("new")) italic("Temp")()$ producono una sequenza di nomi temporanei $t_1, t_2, dots$ tutti distinti.

Per comodità usiamo la notazione $italic("gen")(x upright("'='") y upright("'+'") z)$ per indicare l'istruzione a tre indirizzi $x = y + z$. Eventuali espressioni che dovessero apparire al posto delle variabili $x$, $y$ e $z$ sarebbero valutate prima di essere passate alla funzione $italic("gen")()$; le stringhe tra apici, invece, sono interpretate letteralmente.

Altre istruzioni a tre indirizzi sono costruite in modo simile, applicando la funzione $italic("gen")()$ a una combinazione di espressioni e stringhe costanti. Le regole di traduzione associate alla produzione $E -> E_1 + E_2$ costruiscono $E.italic("code")$ concatenando $E_1.italic("code")$, $E_2.italic("code")$ e un'istruzione che somma i valori di $E_1$ ed $E_2$. Tale istruzione assegna il risultato della somma a un nuovo nome temporaneo associato a $E$ e indicato da $E.italic("addr")$. La concatenazione di $E_1.italic("code")$ ed $E_2.italic("code")$ serve a calcolare prima i valori delle due sottoespressioni, rendendoli disponibili agli indirizzi $E_1.italic("addr")$ ed $E_2.italic("addr")$. La funzione $italic("gen")()$ genera soltanto l'istruzione finale che somma tali valori e memorizza il risultato nel temporaneo indicato da $E.italic("addr")$: essa *non esegue* la somma durante la compilazione, ma produce il codice che la eseguirà a runtime.

La traduzione della produzione $E -> - E_1$ è simile. Le regole semantiche creano un nuovo nome temporaneo per il risultato di $E$, quindi costruiscono $E.italic("code")$ concatenando il codice di $E_1$ e un'istruzione che ne calcola la negazione mediante l'operatore $bold(upright("minus"))$.

Infine, la produzione $S -> bold(upright("id")) = E ";"$ genera le istruzioni che assegnano il valore dell'espressione $E$ all'identificatore $bold(upright("id"))$. Le regole semantiche associate a questa produzione utilizzano la funzione $italic("top").italic("get")()$ per determinare l'indirizzo dell'identificatore rappresentato da $bold(upright("id"))$, esattamente come già visto per la produzione $E -> bold(upright("id"))$. Il valore dell'attributo $S.italic("code")$ consiste delle istruzioni per calcolare il valore di $E$ e memorizzarlo all'indirizzo indicato da $E.italic("addr")$, seguite da un assegnamento all'indirizzo restituito dalla funzione $italic("top").italic("get")(bold(upright("id")).italic("lexeme"))$ e relativo alla specifica istanza di $bold(upright("id"))$ in esame.

#example()[
  La definizione guidata dalla sintassi appena descritta traduce l'assegnamento `a = b + - c;` nella seguente sequenza di codice a tre indirizzi:
  #align(center, block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    [
      `t1 = minus c`\
      `t2 = b + t1`\
      `a = t2`
    ],
  ))
]

=== Traduzione incrementale
Come sappiamo, gli attributi che rappresentano codice possono essere stringhe di notevoli dimensioni. Per questa ragione, tali stringhe sono solitamente generate in modo incrementale. Quindi, invece di costruire $E.c o d e$ secondo le regole riportate nella SDD precedente, possiamo fare in modo di generare solamente le *nuove* istruzioni a tre indirizzi, secondo lo schema di traduzione (SDT) seguente.

#figure(image("images/SDTincrementale3indirizzi.png", width: 80%), caption: "") <fig6.20>

Secondo un approccio incrementale, la funzione $g e n()$ *cambia comportamento*: non solo costruisce una stringa contenente un'istruzione a tre indirizzi, ma *emette direttamente* tale istruzione, inserendola in coda al codice già prodotto. Le istruzioni generate dalle chiamate successive si accumulano quindi, nell'ordine di emissione, in un'unica sequenza: non è più necessario conservarle negli attributi $italic("code")$ e concatenarle esplicitamente. Questa sequenza può essere mantenuta in memoria per elaborazioni successive oppure scritta su un file man mano che viene generata.

Lo schema di traduzione appena visto genera esattamente lo stesso codice prodotto dalla definizione guidata dalla sintassi precedente. Seguendo l'approccio incrementale, l'attributo _code_ diventa *superfluo* poiché la sequenza di istruzioni generata da chiamate successive alla funzione $g e n()$ è unica. Per esempio, l'azione semantica relativa alla produzione $E -> E_1 + E_2$ richiama la funzione $g e n()$ per generare solamente l'istruzione di somma, poiché le istruzioni che calcolano $E_1$ (e assegnano il risultato a $E_1.a d d r$) e quelle che calcolano $E_2$ (e assegnano il risultato a $E_2.a d d r$) sono già state generate in precedenza.

L'approccio presentato può essere utilizzato anche per la costruzione di alberi sintattici. In tal caso, l'azione semantica relativa alle varie produzioni creerebbe un nuovo nodo utilizzando il costruttore $N o d e()$. Tali azioni avrebbero la forma seguente:

#align(center)[
  #table(
    stroke: none,
    columns: (10em, 24em),
    align: left,
    [$S -> bold(upright("id")) = E ";"$],
    [$\{ S.italic("addr") = bold(upright("new")) italic("Node")(upright("'='"), bold(upright("id")), E.italic("addr")); \}$],

    [$E -> E_1 + E_2$],
    [$\{ E.italic("addr") = bold(upright("new")) italic("Node")(upright("'+'"), E_1.italic("addr"), E_2.italic("addr")); \}$],

    [$E -> - E_1$],
    [$\{ E.italic("addr") = bold(upright("new")) italic("Node")("‘" bold(upright("minus")) "’", E_1.italic("addr")); \}$],
  )
]

in cui l'attributo $a d d r$ rappresenta l'indirizzo di un nodo in memoria e non quello di una variabile temporanea o di una costante.

=== Indirizzamento degli elementi di un array

È possibile accedere agli elementi di un array mediante il calcolo del loro indirizzo, assumendo che siano memorizzati in locazioni di memoria contigue. In un array di dimensione $n$, Numerando gli elementi da $0$ a $n - 1$ e indicando con $w$ la larghezza di ciascun elemento, l'indirizzo dell'elemento $A[i]$ è:

#math.equation(
  block: true,
  numbering: "(1)",
  supplement: [Equazione],
  $italic("base") + i times w$,
) <eq-array-monodimensionale>

Qui $italic("base")$ è l'indirizzo dell'inizio della zona di memoria riservata all'array, cioè l'indirizzo di $A[0]$.

L'@eq-array-monodimensionale può essere generalizzata agli array multidimensionali. Per un array bidimensionale organizzato per righe, $A[i_1][i_2]$ indica l'elemento di indice $i_2$ nella riga di indice $i_1$. Indicando con $w_1$ la larghezza di una riga e con $w_2$ quella di un singolo elemento, il suo indirizzo è:

#math.equation(
  block: true,
  numbering: "(1)",
  supplement: [Equazione],
  $italic("base") + i_1 times w_1 + i_2 times w_2$,
) <eq-array-bidimensionale>

In $k$ dimensioni la relazione diviene:

#math.equation(
  block: true,
  numbering: "(1)",
  supplement: [Equazione],
  $italic("base") + i_1 times w_1 + i_2 times w_2
    + dots + i_k times w_k$,
) <eq-array-larghezze>

Per ogni dimensione $j$, $w_j$ è la larghezza del sotto-array, o del singolo elemento, selezionato dopo aver specificato i primi $j$ indici. Il prodotto $i_j times w_j$ rappresenta quindi il contributo di quell'indice allo spiazzamento complessivo.

Indicando con $n_j$ il numero di elementi lungo la dimensione $j$ e con $w$ la larghezza di un elemento di base, lo stesso indirizzo può essere calcolato mediante:

#math.equation(
  block: true,
  numbering: "(1)",
  supplement: [Equazione],
  $italic("base")
    + ((dots ((i_1 times n_2 + i_2) times n_3 + i_3)
    dots) times n_k + i_k) times w$,
) <eq-array-dimensioni>

L'@eq-array-larghezze usa direttamente le larghezze dei sotto-array, mentre l'@eq-array-dimensioni combina gli indici mediante le dimensioni dell'array e moltiplica infine per la larghezza dell'elemento di base.

Nel caso monodimensionale, se il primo indice ammesso è $italic("low")$ anziché zero, l'indirizzo diventa $italic("base") + (i - italic("low")) times w$. L'espressione può essere riscritta come $i times w + c$, dove $c = italic("base") - italic("low") times w$ può essere precalcolato durante la compilazione quando la base, il limite inferiore e la larghezza sono noti. Se $italic("low") = 0$, risulta $c = italic("base")$.

I calcoli precedenti assumono un'organizzazione *per righe*. La @fig-array-disposizione confronta l'organizzazione per righe e quella per colonne per un array $A$ di dimensione $2 times 3$.

#figure(
  image("images/arrayRigheVsColonne.png"),
  caption: [Organizzazione di un array per righe e per colonne.],
) <fig-array-disposizione>


=== Traduzione dei riferimenti ad array

Il problema principale nella generazione del codice per i riferimenti agli elementi di un array consiste nel correlare i calcoli dell'indirizzo alla grammatica corrispondente. Sia $L$ un non-terminale che genera un nome di array seguito da una sequenza di espressioni per gli indici:

$
  L -> L "[" E "]" "|" bold(upright("id")) "[" E "]"
$

Assumiamo che l'indice del primo elemento sia 0 e calcoliamo gli indirizzi sulla base delle larghezze, secondo la @eq-array-larghezze, anziché mediante il numero di elementi, come nella @eq-array-dimensioni.

Lo schema di traduzione della @fig-sdt-array genera codice a tre indirizzi per espressioni contenenti riferimenti ad array. Esso estende lo SDT della @fig6.20 con le produzioni relative al non-terminale $L$ e con le azioni necessarie per leggere e scrivere gli elementi degli array.

#figure(
  image("images/SDTriferimentiArray.png", width: 70%),
  caption: [SDT per la traduzione dei riferimenti ad array.],
) <fig-sdt-array>

Il non-terminale $L$ ha tre attributi sintetizzati:

+ $L.italic("addr")$ indica una variabile temporanea utilizzata per il calcolo dello spiazzamento in byte del riferimento all'array, ottenuto sommando i contributi $i_j times w_j$ degli indici già analizzati.

+ $L.italic("array")$ è un puntatore all'elemento della tabella dei simboli relativo al nome dell'array. L'indirizzo di base, indicato da $L.italic("array").italic("base")$, viene combinato con lo spiazzamento per individuare la locazione di memoria corrispondente al riferimento.

+ $L.italic("type")$ è il tipo dell'elemento o del sotto-array individuato dagli indici già analizzati. Per un tipo $t$, l'attributo $t.italic("width")$ ne indica la larghezza; se $t$ è un tipo array, $t.italic("elem")$ indica il tipo dei suoi elementi. Si conserva il tipo, anziché soltanto la larghezza, perché questa informazione serve anche per il controllo dei tipi.

La produzione $S -> bold(upright("id")) = E ";"$ rappresenta un assegnamento a una variabile scalare ed è trattata come di consueto. L'azione semantica della produzione $S -> L = E ";"$ genera invece un'istruzione di copia indicizzata, che assegna il valore dell'espressione $E$ alla locazione individuata dal riferimento ad array $L$. Poiché $L.italic("array").italic("base")$ indica la base dell'array e $L.italic("addr")$ contiene lo spiazzamento, la locazione viene rappresentata nel codice a tre indirizzi mediante la notazione:

$
  L.italic("array").italic("base") "[" L.italic("addr") "]"
$

In questa notazione, il valore tra parentesi quadre è uno spiazzamento in byte, già calcolato, e non un indice da moltiplicare nuovamente per la larghezza degli elementi.

Le produzioni $E -> E_1 + E_2$ ed $E -> bold(upright("id"))$ sono quelle già studiate. L'azione semantica della nuova produzione $E -> L$ genera invece un'istruzione che legge il valore dalla locazione $L.italic("array").italic("base") "[" L.italic("addr") "]"$ e lo copia in una nuova variabile temporanea, indicata da $E.italic("addr")$.

#example()[
  Sia $a$ un array di interi di dimensione $2 times 3$ e siano $c$, $i$ e $j$ tre variabili intere. Il tipo di $a$ è `array(2, array(3, integer))` e la sua larghezza, assumendo 4 byte per un intero, è pari a 24 byte. Il tipo di $a[i]$ è `array(3, integer)` e la sua larghezza è $w_1 = 12$ byte. Il tipo di $a[i][j]$ è infine `integer`, con larghezza $w_2 = 4$ byte.

  La @fig-array-albero mostra l'albero di parsing annotato dell'espressione $c + a[i][j]$. Il codice a tre indirizzi corrispondente è riportato nella @fig-array-codice, usando i nomi dei simboli per riferirsi ai rispettivi elementi nella tabella dei simboli.

  #figure(
    image("images/esempioTradRifArray.png", width: 80%),
    caption: [Albero di parsing annotato per $c + a[i][j]$.],
  ) <fig-array-albero>

  #figure(
    block(
      fill: luma(240),
      inset: 10pt,
      radius: 4pt,
      [
        `t1 = i * 12`\
        `t2 = j * 4`\
        `t3 = t1 + t2`\
        `t4 = a [ t3 ]`\
        `t5 = c + t4`
      ],
    ),
    kind: image,
    caption: [Codice a tre indirizzi per $c + a[i][j]$.],
  ) <fig-array-codice>

  Le prime tre istruzioni calcolano lo spiazzamento $i times 12 + j times 4$. La quarta legge l'elemento dell'array a quello spiazzamento e la quinta ne somma il valore a $c$.
]

== Controllo dei tipi
Per effettuare il controllo dei tipi, il compiltaore assegna un'espressione di tipo a ogni componente del programma sorgente per  poi procedere a verificarne la conformità rispetto a un insieme di regole logiche, detto _type system_ del linguaggio. Il controllo dei tipi può portare all'individuazione eventuali errori nel programma.

Il controllo dei tipi può avvenire *dinamicamente*, durante l'esecuzione (a _run-time_), oppure *staticamente*, durante la compilazione (a _compile-time_). Nel primo caso, il codice generato deve mantenere le informazioni sui tipi necessarie a verificare la correttezza delle operazioni sui valori. Nel secondo, un _type system_ solido permette di anticipare queste verifiche alla compilazione, evitando che gli errori di tipo si manifestino durante l'esecuzione. Un'implementazione di un linguaggio si dice *fortemente tipizzata* se il compilatore garantisce che i programmi accettati vengano eseguiti senza errori di tipo.

=== Regole per il controllo dei tipi

Il controllo dei tipi può assumere due forme: *sintesi* e *inferenza*. La *sintesi dei tipi* prevede la costruzione di un tipo di un'espressione a partire dal tipo delle sue sotto-espressioni. Tale approccio richiede che tutti i nomi siano dichiarati prima di poter essere utilizzati. Il tipo di un'espressione come $E_1 + E_2$ è definito in base al tipo di $E_1$ e a quello di $E_2$. Una tipica regola che si incontra nella sintesi dei tipi ha la forma:

#algo()[
  *if* $f$ è di tipo $s -> t$ *and* $x$ è di tipo $s$, \
  *then* l'espressione $f(x)$ è di tipo $t$
]

In questa regola, che si riferisce a funzioni con un solo argomento, $f$ e $x$ indicano espressioni e la scrittura $s -> t$ indica una funzione da $s$ a $t$.

L'*inferenza di tipo* determina il tipo di un costrutto del linguaggio in base al modo in cui esso è utilizzato. Sia $n u l l()$ una funzione che verifica se una lista è vuota. In tal caso, in base a un suo utilizzo nella forma $n u l l(x)$ possiamo concludere che $x$ deve essere una lista. Il tipo degli elementi della lista, tuttavia, non è noto; al momento si può soltanto stabilire che $x$ è una lista di elementi di tipo ignoto.

#observation()[
  Useremo le lettere greche $alpha, beta$ e così via, per indicare variabili di tipo nelle espressioni di tipo.
]

Una tipica regola per l'inferenza di tipo ha la forma seguente:

#algo()[
  *if* $f(x)$ è una funzione, \
  *then* per qualche $alpha$ e $beta$, $f$ è di tipo $alpha -> beta$ *and* $x$ è di tipo $alpha$
]

Considereremo il controllo dei tipi delle espressioni, ma le regole per il controllo degli statement sono simili. Per esempio, interpreteremo il costrutto $bold("if")( E ) space S;$ come se si trattasse dell'applicazione di una funzione $i f()$ agli operandi $E$ ed $S$. Indichiamo inoltre con il tipo speciale _void_ l'assenza di un valore. In conclusione, quindi, possiamo dire che lo statement condizionale $bold("if")$ può essere visto come una funzione $i f()$ che richiede un argomento di tipo _boolean_ e uno di tipo _void_ e restituisce il tipo _void_.

=== Conversioni di tipo

Consideriamo l'espressione $x + i$ in cui $x$ è di tipo floating-point mentre $i$ è di tipo intero. Dato che la rappresentazione di valori interi e valori floating-point è diversa e che le operazioni su interi o su valori floating-point richiedono istruzioni macchina diverse, un compilatore dovrà provvedere alla conversione di uno dei due operandi dell'operatore $+$ in modo da assicurare che essi abbiano lo stesso tipo quando la somma avviene effettivamente. Supponiamo che i valori interi siano convertiti in valori floating-point. Nel codice dell'espressione $2 * 3.14$, per esempio, il valore intero $2$ viene convertito in virgola mobile:

#align(center, block(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  [
    `t1 = (float) 2` \
    `t2 = t1 * 3.14`
  ],
))

Illustreremo la sintesi dei tipi estendendo lo schema di traduzione relativo alle espressioni. A tale scopo aggiungiamo il nuovo attributo $E.t y p e$, il cui valore può essere $i n t e g e r$ oppure $f l o a t$. La regola associata alla produzione $E -> E_1 + E_2$ richiede l'aggiunta dello pseudocodice:

#algo()[
  *if* ($E_1.italic("type") == italic("integer")$ *and* $E_2.italic("type") == italic("integer")$) $E.italic("type") = italic("integer")$, \
  *else if* ($E_1.italic("type") == italic("float")$ *and* $E_2.italic("type") == italic("integer")$) $dots$ \
  $dots$
]

All'aumentare del numero dei tipi, il numero dei casi da considerare cresce molto rapidamente.

#figure(image("images/conversioniPrimitiviJava.png", width: 70%), caption: "") <fig6.25>

Le regole di conversione di tipo variano da linguaggio a linguaggio. Le regole di conversione per il linguaggio Java riportate nella @fig6.25 distinguono due casi:

- *Conversioni con ampliamento* o promozioni (*widening*), che hanno lo scopo di preservare l'informazione intatta (@fig6.25(a): ogni tipo può essere promosso a un tipo più in alto nella gerarchia).
- *Conversioni con restrizione* o demozioni (*narrowing*), che possono portare invece a una perdita di informazione.

Una conversione è *implicita*, o *coercizione*, quando viene effettuata automaticamente dal compilatore secondo le regole del linguaggio. È invece *esplicita* quando viene richiesta dal programmatore mediante un *cast*, come in `(float) i`. In molti linguaggi le conversioni implicite sono limitate alle promozioni, mentre le conversioni che possono perdere informazione richiedono un cast esplicito.

Per gestire le conversioni nella produzione $E -> E_1 + E_2$ si utilizzano due funzioni. La funzione $italic("max")(t_1, t_2)$ determina il tipo comune da usare per l'operazione, scegliendo il maggiore secondo la gerarchia di promozione: nel caso di $italic("integer")$ e $italic("float")$, restituisce $italic("float")$. Se i tipi non sono compatibili con le conversioni previste, viene segnalato un errore di tipo.

La funzione $italic("widen")(a, t, w)$ riceve l'indirizzo $a$ di un valore di tipo $t$ e il tipo di destinazione $w$. Se $t = w$, restituisce direttamente $a$, senza generare istruzioni. Altrimenti, se la promozione è ammessa, genera un'istruzione che converte il valore e lo salva in una nuova variabile temporanea, restituendone l'indirizzo. Per esempio, passando da $italic("integer")$ a $italic("float")$, genera un'istruzione della forma `temp = (float) a`. Una conversione non ammessa produce un errore.

L'azione semantica che segue, relativa alla produzione $E -> E_1 + E_2$, determina quindi il tipo del risultato, adeguando entrambi gli operandi a tale tipo e infine generando l'istruzione di somma:

$
  E.italic("type") &= italic("max")(E_1.italic("type"), E_2.italic("type")); \
  a_1 &= italic("widen")(E_1.italic("addr"), E_1.italic("type"), E.italic("type")); \
  a_2 &= italic("widen")(E_2.italic("addr"), E_2.italic("type"), E.italic("type")); \
  E.italic("addr") &= bold(upright("new")) italic("Temp")(); \
  &italic("gen")(E.italic("addr") upright("'='") a_1 upright("'+'") a_2);
$

Gli indirizzi $a_1$ e $a_2$ identificano gli operandi pronti per la somma: coincidono con quelli originali se non occorre alcuna conversione, oppure con i temporanei che contengono i valori convertiti.

=== Sovraccaricamento di funzioni e operatori
Un simbolo *sovraccaricato* (*overloaded*) ha diversi significati a seconda del contesto in cui si trova. Si dice che il sovraccaricamento viene _risolto_ quando si assegna un significato univoco a ogni occorrenza di un nome.
#example(multiple: true)[
  1. In Java l'operatore $+$ indica sia l'operazione di somma che il concatenamento di stringhe, a seconda del tipo degli operandi.
  
  2. Anche le funzioni definite dal programmatore possono essere sovraccaricate, per esempio:
    #align(center, block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    [
      `void err() { ... }` \
      `void err(String s) { ... }`
    ],
  ))In questo caso per capire a quale funzione si riferisce l'uso del simbolo `err` è sufficiente analizzare gli argomenti.
]
Una possibile regola per la sintesi del tipo di funzioni sovraccaricate è la seguente:
#algo()[
  *if* $f$ può essere di tipo $s_i->t_i$, per $1 lt.eq i lt.eq n$, con $s_i eq.not s_j$ per $i eq.not j$\
  *and* $x$ è di tipo $s_k$, per qualche valore di $k$ tale che $1 lt.eq k lt.eq n$ \
  *then* l'espressione $f(x)$ è di tipo $t_k$
]
Il metodo del valore numerico può essere applicato a espressioni di tipo per risolvere efficientemente il problema del sovraccaricamento sulla base del tipo degli argomenti. In un DAG che rappresenta un'espressione di tipo assegnamo un indice intero (valore numerico) a ogni nodo. Mediante l'algoritmo noto, possiamo costruire la firma di un nodo, formata dalla sua etichetta e dai valori numerici dei figli (presi da sinistra a destra). La firma di una funzione consiste del nome della funzione e del tipo dei suoi argomenti.\ L'ipotesi di poter risolvere il sovraccaricamento di una funzione sulla base del tipo dei soli argomenti equivale all'ipotesi di poter risolvere il sovraccaricamento in base alla firma delle funzioni. Non sempre, tuttavia, l'analisi del tipo dei soli argomenti è sufficiente a risolvere il sovraccaricamento di una funzione.

=== Inferenza del tipo e funzioni polimorfiche
In alcuni linguaggi (come ML, sebbene sia fortemente tipizzato) non è sempre necessario dichiarare esplicitamente il tipo delle variabili prima del loro uso. È il compilatore stesso a occuparsi dell'*inferenza del tipo*, analizzando il codice per dedurre i tipi in gioco e assicurarsi che vengano usati in modo coerente.
Questo meccanismo si sposa perfettamente con il concetto di *polimorfismo parametrico*, ovvero la capacità di scrivere un frammento di codice (come una funzione) in grado di operare su argomenti di tipi diversi, rappresentati astrattamente tramite "variabili di tipo" (spesso indicate con lettere greche). Ecco un esempio con una funzione in linguaggio ML:

#align(center, [
  ```ML
  fun length(x) = if null(x) then 0 else length(tl(x)) + 1;
  ```
])
La funzione `length()` calcola la lunghezza di una lista $x$, cioè il numero di elementi in $x$. Tutti gli elementi di una lista devono avere lo stesso tipo, ma la funzione in esame può essere applicata a liste di elementi di un tipo qualsiasi. La funzione predefinita `null()` verifica se una lista è vuota, mentre la funzione predefinita `tl()` (che sta per _tail_) restituisce ciò che rimane di una lista dopo aver rimosso il primo elemento. Nell'espressione che segue la funzione `length()` è applicata a due tipi diversi di liste (gli elementi di una lista sono racchiusi tra parentesi quadre):
#align(center, [
  `length`([`"sun", "mon", "tue"`]) + `length`([10, 9, 8, 7])
])
La lista di stringhe ha lunghezza pari a 3, quella di interi ha lunghezza pari a 4, quindi l'espressione assume valore 7.

Per rappresentare formalmente il tipo di una funzione polimorfica, si ricorre al quantificatore universale $forall$ (per ogni). Il tipo della funzione `length` si scrive così:
$
  forall alpha . text("list")(alpha) -> italic("integer")
$
Questo si legge: "per ogni tipo $alpha$, la funzione mappa una lista di elementi di tipo $alpha$ in un intero". Quando in un'espressione di tipo compare il simbolo $forall$, ci troviamo di fronte a un *tipo polimorfico*. La variabile a cui $forall$ è applicato si dice *legata* a tale quantificatore, e una variabile legata può essere rinominata liberamente a patto di rinominare tutte le sue occorrenze.

#example()[
  Il compilatore deduce il tipo polimorfico analizzando i nodi dell'albero sintattico astratto seguente, che rappresenta la definizione della funzione `length` vista in precedenza.
  #figure(image("images/esempioInferenzaTipoPolimorfico.png", width: 80%))
  Possiamo inferire il tipo della funzione analizzando il suo corpo (i figli del nodo `if` presi da sinistra a destra):

  1. la funzione predefinita `null` richiede, per definizione, una lista come argomento e restituisce un booleano. Poiché nell'albero compare la chiamata `null(x)`, deduciamo che $x$ deve essere una lista. Il tipo dei suoi elementi, invece, non è ancora determinato: lo rappresentiamo con una variabile di tipo $alpha$, ottenendo per $x$ il tipo $italic("list")(alpha)$.
  2. Se `null(x)` è vera, la funzione ritorna `0` (che è un intero).
  3. Dai punti precedenti segue che l'intera funzione `length` deve prendere in ingresso una $italic("list")(alpha)$ e restituire un _integer_.
]

Quando le espressioni di tipo contengono variabili, come $alpha$, due tipi apparentemente diversi possono diventare equivalenti assegnando opportuni tipi a tali variabili. Perciò, se una funzione richiede un parametro di tipo $s$ e viene applicata a un argomento di tipo $t$, non basta confrontare direttamente le due espressioni: occorre verificare se possono essere *unificate*.

L'*unificazione* consiste nel cercare una sostituzione delle variabili di tipo che renda $s$ e $t$ strutturalmente equivalenti. La sostituzione deve essere coerente: ogni occorrenza della stessa variabile va sostituita con la stessa espressione di tipo. Per esempio, $italic("list")(alpha)$ e $italic("list")(italic("integer"))$ si unificano sostituendo $alpha$ con $italic("integer")$. Le espressioni sostituite possono contenere a loro volta variabili: non devono necessariamente essere tipi completamente determinati. Per capire questo processo, definiamo formalmente i seguenti concetti:

- *Sostituzione* ($S$): è una funzione che associa variabili di tipo a espressioni di tipo.
- *Istanza* ($S(t)$): è il risultato dell'applicazione di una sostituzione a un'espressione. Se applichiamo la sostituzione $S$ all'espressione di tipo $t$, otteniamo l'istanza $S(t)$.
  - _Esempio:_ `list(integer)` è un'istanza di `list(`$alpha$`)` (ottenuta sostituendo $alpha$ con `integer`).
  - _Controesempio:_ il tipo `integer` $->$ `float` *non* è un'istanza di $alpha -> alpha$, perché una sostituzione esige che tutte le occorrenze della stessa variabile ($alpha$) vengano rimpiazzate con la stessa identica espressione di tipo.
- *Unificatore:* una sostituzione $S$ è un unificatore di due espressioni di tipo $t_1$ e $t_2$ se vale $S(t_1) = S(t_2)$.
- *Unificatore più generale:* $S$ è l'unificatore più generale di $t_1$ e $t_2$ se per qualsiasi altro unificatore $S'$ di $t_1$ e $t_2$ e per qualsiasi espressione di tipo $t$ si ha che $S'(t)$ è un'istanza di $S(t)$ (cioè $S'$ è più specifico e restrittivo di $S$).

#[
  #set heading(numbering: none, outlined: false)
  === Algoritmo di inferenza di tipo per le funzioni polimorfiche
]

*INPUT*: un programma consistente in una sequenza di definizioni di funzione seguita da un'espressione da valutare. Tale espressione è costituita da applicazioni delle funzioni e nomi che possono avere tipi polimorfici predefiniti. \
*OUTPUT*: tipi inferiti dei nomi che appaiono nel programma.

*METODO*: per semplicità tratteremo solo fuzioni unarie. L'idea di base dell'algoritmo consiste nello scorrere le definizioni di funzione e l'espressione nel programma d'ingresso e utilizzare il tipo già inferito di una funzione ogniqualvolta questo appare in un'espressione successiva.

- Per una definizione di funzione della forma $bold("fun") bold("id")_1(bold("id")_2) = E$, si creano due nuove variabili di tipo $alpha$ e $beta$. Quindi si associa alla funzione $bold("id")_1$ il tipo $alpha -> beta$ e al parametro $bold("id")_2$ il tipo $alpha$. Quindi si inferisce un'espressione di tipo per $E$. Supponiamo che, dopo l'inferenza, $alpha$ denoti il tipo $s$ e $beta$ il tipo $t$. Ne risulta che il tipo inferito per la funzione $text("id")_1$ è $s -> t$. Ciò fatto, si legano mediante il quantificatore $forall$ tutte le variabili rimaste non vincolate.

- Per l'applicazione di una funzione $E_1(E_2)$, si inferiscono i tipi di $E_1$ ed $E_2$. Dato che $E_1$ è utilizzato come funzione, il suo tipo deve avere la forma $s -> s'$. Tecnicamente diremmo che il tipo di $E_1$ deve essere unificato con $beta -> gamma$ in cui $beta$ e $gamma$ sono variabili di tipo. Sia $t$ il tipo inferito di $E_2$. Si cerca di unificare $beta$ e $t$: se il tentativo fallisce si ha un errore di tipo, altrimenti il tipo inferito di $E_1(E_2)$ è $gamma$.

- Per ogni occorrenza di una funzione polimorfica, si sostituisce ogni variabile legata dal quantificatore $forall$ con una nuova variabile e si rimuove il quantificatore. Il tipo risultante è il tipo inferito della funzione polimorfica.

- Per un nome che si incontra per la prima volta, si introduce una nuova variabile di tipo.

#example()[
  La Figura 6.30 mostra l'inferenza del tipo per la funzione $italic("length")()$.
  La radice dell'albero della Figura 6.29 (esempio precedente) corrisponde alla definizione di una funzione, quindi introduciamo due variabili $beta$ e $gamma$, associamo il tipo $beta -> gamma$ alla funzione $italic("length")()$ e il tipo $beta$ alla variabile $x$ (Figura 6.30, linee 1-2).

  Il figlio destro della radice può essere visto come l'applicazione della funzione polimorfica *if* a una tripla costituita da un valore booleano e due espressioni che rappresentano il ramo *then* e il ramo *else*. Il tipo di questa funzione è quindi:
  $ forall alpha . italic("boolean") times alpha times alpha -> alpha $

  Ogni applicazione di una funzione polimorfica può riferirsi a un tipo diverso, quindi creiamo una nuova variabile di tipo $alpha_i$ (in cui $i$ sta per "if") e rimuoviamo il quantificatore $forall$ (Figura 6.30, linea 3). Il tipo del figlio sinistro di *if* deve essere unificato con il tipo $italic("boolean")$, mentre il tipo dei suoi due altri figli deve essere unificato con $alpha_i$.

  #figure(image("images/esempioInferenzaTipoFunzione.png", width: 80%))

  La funzione predefinita $italic("null")()$ ha tipo $forall alpha . italic("list")(alpha) -> italic("boolean")$; utilizziamo la nuova variabile $alpha_n$ (in cui $n$ sta per "null") per sostituire $alpha$ rimuovendo il quantificatore (Figura 6.30, linea 4). Dall'applicazione di $italic("null")()$ a $x$ inferiamo che il tipo $beta$ di $x$ deve corrispondere a $italic("list")(alpha_n)$ (linea 5).

  Considerando il primo figlio del nodo *if*, si nota che il tipo $italic("boolean")$ dell'espressione $italic("null")(x)$ corrisponde al tipo che la funzione polimorfica *if* si aspetta. Considerando invece il secondo figlio, il tipo $alpha_i$ è unificato al tipo $italic("integer")$ (linea 6).

  Consideriamo ora la sottoespressione $italic("length")(italic("tl")(x)) + 1$. Per prima cosa creiamo una nuova variabile $alpha_t$ (in cui $t$ sta per "tail") per la variabile legata $alpha$ nell'espressione di tipo relativa alla funzione $italic("tl")()$ (linea 8). Dall'applicazione di $italic("tl")()$ a $x$ possiamo inferire $italic("list")(alpha_t) = beta = italic("list")(alpha_n)$ (linea 9).

  Dato che $italic("length")(italic("tl")(x))$ è un operando dell'operatore $+$, il suo tipo deve essere unificato con $italic("integer")$ (linea 10). Ne segue che il tipo di $italic("length")()$ è $italic("list")(alpha_n) -> italic("integer")$.

  Dopo aver concluso il controllo del tipo della definizione della funzione $italic("length")()$, la variabile $alpha_n$ rimane nella sua espressione di tipo. Dato che durante la verifica non si è fatta alcuna assunzione sulla variabile di tipo $alpha_n$, un tipo qualsiasi può essere utilizzato al suo posto al momento dell'uso della funzione. Trasformando quindi $alpha_n$ in una variabile legata otteniamo la nuova espressione:
  $ forall alpha_n . italic("list")(alpha_n) -> italic("integer") $
  che rappresenta il tipo di $italic("length")()$.
]

=== Algoritmo di unificazione

Definita informalmente, l'unificazione è il problema di determinare se due espressioni $s$ e $t$ possono essere rese identiche sostituendo alle variabili presenti in $s$ e $t$ delle nuove espressioni. La verifica dell'uguaglianza tra espressioni è un caso speciale di unificazione. Se due espressioni $s$ e $t$ contengono solo costanti e nessuna variabile, esse sono unificabili se e solo se sono identiche. L'algoritmo presentato in questa sezione può essere esteso ai grafi non aciclici e pertanto può essere utilizzato anche per la verifica dell'equivalenza strutturale tra tipi circolari.

Implementeremo una formulazione dell'unificazione basata sulla teoria dei grafi, secondo cui ogni tipo è rappresentato da un grafo. Le variabili di tipo sono rappresentate dalle foglie, mentre i costruttori di tipo dai nodi interni. I nodi sono raggruppati in classi di equivalenza: se due nodi appartengono alla stessa classe, allora le espressioni di tipo che essi rappresentano devono essere unificabili. Ne consegue che tutti i nodi interni appartenenti a una stessa classe di equivalenza devono corrispondere allo stesso costruttore di tipo e i rispettivi figli devono essere equivalenti.

#example()[
  Consideriamo le due espressioni di tipo:
  $
    & ((alpha_1 -> alpha_2) times italic("list")(alpha_3)) -> italic("list")(alpha_2) \
    & ((alpha_3 -> alpha_4) times italic("list")(alpha_3)) -> alpha_5
  $

  Per unificarle confrontiamo le parti corrispondenti, procedendo dall'esterno verso l'interno. Entrambe rappresentano una funzione il cui parametro è una coppia, formata a sua volta da una funzione e da una lista.

  Il confronto impone i seguenti vincoli:
  + Le funzioni $alpha_1 -> alpha_2$ e $alpha_3 -> alpha_4$ devono avere tipi equivalenti per il parametro e per il risultato: quindi $alpha_1 = alpha_3$ e $alpha_2 = alpha_4$.
  + Le liste nella seconda componente delle coppie hanno già lo stesso tipo $italic("list")(alpha_3)$, quindi non introducono nuovi vincoli.
  + I risultati delle funzioni esterne devono essere equivalenti: quindi $alpha_5 = italic("list")(alpha_2)$.

  Scegliendo di conservare i nomi $alpha_1$ e $alpha_2$, otteniamo la sostituzione $S$:

  #align(center)[
    #table(
      stroke: none,
      columns: (4em, 8em),
      align: center,
      table.hline(),
      table.header([$x$], [$S(x)$]),
      table.hline(),
      [$alpha_1$], [$alpha_1$],
      [$alpha_2$], [$alpha_2$],
      [$alpha_3$], [$alpha_1$],
      [$alpha_4$], [$alpha_2$],
      [$alpha_5$], [$italic("list")(alpha_2)$],
      table.hline(),
    )
  ]

  Applicando $S$ a entrambe le espressioni otteniamo lo stesso tipo:
  $
    ((alpha_1 -> alpha_2) times italic("list")(alpha_1)) -> italic("list")(alpha_2)
  $

  La sostituzione è un *unificatore più generale* perché impone soltanto i vincoli necessari, lasciando $alpha_1$ e $alpha_2$ libere. Assegnare loro tipi concreti produrrebbe un unificatore più specifico. È convenzionale soltanto la scelta dei nomi da conservare: si potrebbe, per esempio, sostituire $alpha_1$ con $alpha_3$ anziché viceversa, ottenendo un risultato equivalente a meno dei nomi delle variabili.

  La @fig-grafo-unificazione rappresenta graficamente questi vincoli. Ogni nodo indica una variabile o un costruttore di tipo: $->$ collega il tipo del parametro a quello del risultato, $times$ raggruppa i tipi delle due componenti di una coppia e $italic("list")$ ha come figlio il tipo dei suoi elementi. Una stessa variabile può essere condivisa da più parti del grafo; gli incroci tra linee non rappresentano ulteriori nodi.

  #figure(
    image("images/esempioGrafoUnificazione.png", width: 80%),
    caption: [Classi di equivalenza dopo l'unificazione.],
  ) <fig-grafo-unificazione>

  I numeri dopo i due punti identificano le *classi di equivalenza dopo l'unificazione*: nodi con lo stesso numero rappresentano tipi che devono diventare equivalenti. In particolare:
  - La classe 1 contiene le due radici, cioè le espressioni complete da unificare.
  - Le classi 2 e 3 raggruppano rispettivamente i prodotti e le funzioni interne corrispondenti.
  - La classe 4 contiene $alpha_1$ e $alpha_3$; la classe 5 contiene $alpha_2$ e $alpha_4$.
  - La classe 6 contiene i nodi che rappresentano le liste nella seconda componente delle coppie.
  - La classe 8 contiene il nodo del tipo risultato $italic("list")(alpha_2)$ e la variabile $alpha_5$, che deve assumere quel tipo.

  Questi numeri sono semplici identificatori delle classi, non indicano l'ordine delle operazioni. La figura mostra quindi il risultato dell'unificazione: quali nodi vengono riconosciuti come equivalenti.
]

#figure(image("images/algoritmoUnificazione.png", width: 80%))

*INPUT*: un grafo che rappresenta un tipo e una coppia di nodi $m$ e $n$ da unificare.\
*OUTPUT*: il valore booleano `true` se le espressioni di tipo rappresentate dai nodi $m$ e $n$ sono unificabili, altrimenti il valore booleano `false`.

*METODO*: un nodo è rappresentato mediante un record dotato di un campo per un operatore binario e due campi per i puntatori ai figli sinistro e destro. Gli insiemi di nodi equivalenti vengono gestiti mediante il campo `set`. Uno dei nodi di ogni classe di equivalenza viene scelto come rappresentativo della classe e ciò è indicato dal fatto che il puntatore `set` assume valore nullo. Per tutti gli altri nodi il campo `set` punta (eventualmente in modo indiretto) al nodo rappresentativo della classe. Inizialmente ogni nodo $n$ costituisce una classe di equivalenza a sé stante ed è il nodo rappresentativo della classe.

L'algoritmo di unificazione mostrato nella Figura 6.32 usa le due operazioni sui nodi descritte di seguito.

- `find(n)` restituisce il nodo rappresentativo della classe di equivalenza contenente il nodo $n$.
- `union(m, n)` fonde le classi di equivalenza contenenti i nodi $m$ e $n$. Se uno dei nodi rappresentativi delle classi di equivalenza di $m$ e $n$ non è associato a una variabile, la funzione `merge()` rende tale nodo rappresentativo della classe ottenuta dalla fusione; in caso contrario la funzione sceglie uno dei due nodi rappresentativi di $m$ e $n$ come rappresentativo dell'unione. Questa asimmetria nella specifica della funzione di unione è importante in quanto un nodo associato a una variabile di tipo non può essere scelto come nodo rappresentativo di una classe di equivalenza relativa a un'espressione che contiene un costruttore di tipo o un tipo di base. In caso contrario, infatti, due espressioni non equivalenti potrebbero essere unificate per mezzo di quella variabile.

L'operazione di unione tra due classi è implementata semplicemente assegnando al campo `set` del nodo rappresentativo di una classe il puntatore al nodo rappresentativo dell'altra. La funzione `find()`, invece, trova la classe cui un nodo appartiene seguendo la catena di puntatori memorizzati nel campo `set` finché non trova il nodo rappresentativo, cioè quello per cui il campo `set` ha valore nullo.

Si noti che l'algoritmo della Figura 6.32 utilizza $s = italic("find")(m)$ e
$t = italic("find")(n)$ anziché direttamente $m$ e $n$: il confronto
avviene quindi tra i rappresentanti delle rispettive classi.
Se questi coincidono, oppure rappresentano lo stesso tipo di base,
la funzione restituisce *true*.

Se invece $s$ e $t$ sono nodi interni, si deve prima verificare che
rappresentino *lo stesso costruttore di tipo*, con lo stesso numero
di operandi. Nel caso binario considerato dalla figura, si uniscono
quindi le due classi e si confrontano ricorsivamente i figli
corrispondenti. Se i costruttori sono diversi, l'unificazione fallisce,
anche quando i rispettivi figli sono equivalenti: per esempio,
$italic("integer") times italic("integer")$ e
$italic("integer") -> italic("integer")$ rappresentano tipi diversi.

Il confronto tra i costruttori, lasciato implicito nello pseudocodice
della figura, è dunque una condizione necessaria per procedere
all'unificazione dei figli. L'unione delle classi prima delle chiamate
ricorsive riduce il numero di classi distinte e permette di riconoscere
confronti già avviati, garantendo la terminazione dell'algoritmo.

La sostituzione di un'espressione al posto di una variabile è implementata aggiungendo la foglia corrispondente alla variabile alla classe di equivalenza contenente il nodo corrispondente all'espressione. Supponiamo che uno dei due nodi $m$ o $n$ sia una foglia corrispondente a una variabile e che tale foglia sia stata assegnata a una classe di equivalenza contenente un nodo relativo a un'espressione avente al suo interno un costruttore di tipo oppure a un tipo di base. In questo caso la funzione `find()` restituirà un nodo rappresentativo corrispondente a quello specifico costruttore di tipo o tipo di base, in modo che una variabile non possa mai essere unificata con due espressioni differenti.

#example()[
  Riprendiamo le due espressioni di tipo dell'esempio precedente. Nel grafo iniziale mostrato di seguito, ogni nodo appartiene a una classe di equivalenza distinta ed è il rappresentante della propria classe.

  #figure(image("images/esAlgoUnificazione.png", width: 80%), caption: "Grafo iniziale con ogni nodo in una classe di equivalenza a sé stante")

  L'unificazione parte dalla chiamata $italic("unify")(1, 9)$ sui nodi radice e procede confrontando ricorsivamente le parti corrispondenti:

  + I nodi 1 e 9 rappresentano entrambi il costruttore $->$: le loro classi vengono unite, poi si eseguono $italic("unify")(2, 10)$ sui tipi dei parametri e $italic("unify")(8, 14)$ sui tipi dei risultati.

  + I nodi 2 e 10 rappresentano entrambi il prodotto $times$: si uniscono le loro classi e si confrontano le due componenti. L'unificazione dei nodi 3 e 11, entrambi associati a $->$, porta a unire i nodi 4 e 7, cioè $alpha_1$ e $alpha_3$, e i nodi 5 e 12, cioè $alpha_2$ e $alpha_4$. Si uniscono inoltre i nodi 6 e 13, che rappresentano liste con lo stesso tipo degli elementi, $alpha_3$.

  + Infine, il nodo 8 rappresenta $italic("list")(alpha_2)$, mentre il nodo 14 rappresenta la variabile $alpha_5$. Le due classi vengono unite scegliendo il nodo 8 come rappresentante, perché contiene un costruttore di tipo. Questo realizza la sostituzione di $alpha_5$ con $italic("list")(alpha_2)$.

  Tutti i confronti hanno successo: $italic("unify")(1, 9)$ restituisce quindi `true`. Scegliendo i rappresentanti come nell'esempio precedente, si ottengono le classi mostrate nella @fig-grafo-unificazione.
]

Se l'algoritmo restituisce `true`, le classi di equivalenza ottenute permettono di *ricostruire una sostituzione unificante*. Per ogni variabile di tipo $alpha$, si individua il rappresentante della sua classe mediante $italic("find")(alpha)$ e si assume come $S(alpha)$ l'espressione di tipo rappresentata da quel nodo, tenendo conto anche delle equivalenze tra i suoi discendenti.

Nell'esempio, il rappresentante di $alpha_3$ è il nodo 4, associato ad $alpha_1$, mentre quello di $alpha_5$ è il nodo 8, che rappresenta $italic("list")(alpha_2)$. Si ricava così la sostituzione già vista:
$
  S(alpha_3) &= alpha_1, \
  S(alpha_4) &= alpha_2, \
  S(alpha_5) &= italic("list")(alpha_2).
$
Le variabili $alpha_1$ e $alpha_2$ rimangono invariate e libere. L'algoritmo realizza dunque l'unificazione attraverso le fusioni delle classi, senza dover riscrivere esplicitamente le espressioni di tipo a ogni sostituzione.

== Flusso di controllo

La traduzione di costrutti come `if-then-else` e `while` è strettamente legata alla gestione delle *espressioni booleane*. Il ruolo di queste espressioni cambia a seconda del contesto sintattico in cui si trovano all'interno del codice.

Quando seguono parole chiave come `if` o `while`, le espressioni booleane servono a *modificare il flusso di controllo*. In questi casi, il loro valore di verità non viene memorizzato, ma è definito implicitamente dal percorso di esecuzione: nel costrutto $bold("if") (E) space S$, il semplice fatto che il programma raggiunga ed esegua lo statement $S$ implica logicamente che $E$ sia vera.

Altrimenti, un'espressione booleana può avere lo scopo rappresentare o *calcolare un valore logico* esplicito (`true` o `false`), per esempio quando si trova nel lato destro di un'istruzione di assegnamento. In questa situazione, l'espressione viene valutata e tradotta in istruzioni a tre indirizzi in modo analogo alle normali espressioni aritmetiche.

=== Espressioni booleane

Le espressioni booleane sono composte da operatori booleani AND, OR e NOT (che, seguendo le convenzioni del linguaggio C, indichiamo rispettivamente con i simboli $\&\&$, $\|\|$ e $!$) applicati a operandi che possono essere variabili booleane o espressioni relazionali.

Le espressioni relazionali hanno la forma $E_1 bold("rel") E_2$, in cui $E_1$ ed $E_2$ sono espressioni aritmetiche. In questo paragrafo considereremo espressioni booleane generate dalla grammatica:

$
  B space -> space B \|\| B | B \&\& B | ! B | ( B ) | E bold("rel") E | bold("true") | bold("false")
$

Useremo l'attributo $bold("rel").o p$ per specificare quale dei sei operatori relazionali `<`, `<=`, `=`, `!=`, `>` o `>=` indichi il terminale $bold("rel")$. Assumiamo che gli operatori logici descritti siano associativi a sinistra e che l'ordine di precedenza crescente sia $\|\|$, $\&\&$, $!$. Inoltre, data l'espressione $B_1 \|\| B_2$, se determiniamo che $B_1$ è vera, possiamo subito concludere che l'intera espressione sia vera. Allo stesso modo, $B_1 \&\& B_2$ è falsa se è falsa $B_1$.\ La definizione della semantica di un linguaggio chiarisce se sia o meno richiesta la valutazione di tutte le parti di un'espressione booleana. Se la semantica stabilisce che è ammesso (o richiesto) che alcune parti di un'espressione booleana non siano valutate, il compilatore può ottimizzarne la valutazione calcolando solamente la porzione minima necessaria a stabilire se l'espressione complessiva sia vera o falsa. Pertanto, in un'espressione come $B_1 \|\| B_2$, né $B_1$ né $B_2$ sono necessariamente valutate completamente. Ciò significa che se $B_1$ o $B_2$ sono espressioni aventi effetti collaterali (per esempio, se contengono chiamate di funzione che modificano una variabile globale) è possibile ottenere risultati inattesi.

=== Traduzione con corto circuito

Secondo lo schema di traduzione con *corto circuito* (_short-circuit_), gli operatori $\&\&$, $\|\|$ e $!$ sono tradotti mediante istruzioni di salto. In questo caso gli operatori non appaiono esplicitamente nel codice, in quanto il valore di un'espressione booleana è rappresentato implicitamente dalle diverse posizioni nel codice.

#example()[
  L'istruzione:

  #align(center)[
    `if ( x < 100 || x > 200 && x != y ) x = 0;`
  ]

  potrebbe essere tradotta nel codice che segue
  #figure(
    grid(
      columns: (auto, auto),
      column-gutter: 1em,
      row-gutter: 0.6em,
      align: (right + horizon, left + horizon),
      [], [#raw("if x < 100 goto") $L_2$],
      [], [#raw("ifFalse x > 200 goto") $L_1$],
      [], [#raw("ifFalse x != y goto") $L_1$],
      [$L_2$:], [#raw("x = 0")],
      [$L_1$:], [],
      []
    ),
    caption: [Traduzione mediante salti.],
  )
  Secondo tale traduzione il valore dell'espressione booleana è vero se l'esecuzione raggiunge l'etichetta $L_2$. Se invece l'espressione risulta falsa, il controllo raggiunge immediatamente l'etichetta $L_1$, saltando oltre $L_2$ senza eseguire l'assegnamento $x = 0$.
]

=== Istruzioni per la gestione del flusso di controllo

Consideriamo ora la traduzione delle espressioni booleane in codice a tre indirizzi nel contesto di istruzioni di controllo come quelle generate dalla seguente grammatica:

$
  S & -> bold("if") ( space B space  ) space S_1 \
  S & -> bold("if") ( space B space  ) space S_1 bold("else") S_2 \
  S & -> bold("while") ( space B space  ) space S_1
$

In queste produzioni il non-terminale $B$ rappresenta un'espressione booleana e il non-terminale $S$ rappresenta un generico statement. Questa grammatica è una generalizzazione di quella dello statemente while che avevamo già visto in un capitolo precedente, e come in quel caso $S$ e $B$ hanno un attributo sintetizzato $c o d e$ che fornisce la traduzione in istruzioni a tre indirizzi (combinate mediante concatenazione). Per semplicità costruiamo le traduzioni $B.c o d e$ e $S.c o d e$ sotto forma di stringhe, mediante opportune definizioni guidate dalla sintassi (SDD).

La traduzione del costrutto $bold(upright("if")) "(" B ")" space S_1$ consiste del codice $B.italic("code")$ seguito dal codice $S_1.italic("code")$, come illustrato nella @fig-schema-flusso(a). Nel codice $B.italic("code")$ compaiono istruzioni di salto che dipendono dal valore di $B$: se è vera, il controllo passa alla prima istruzione di $S_1.italic("code")$; se è falsa, passa alla prima istruzione successiva al codice di $S_1$.

Le etichette dei salti sono gestite mediante attributi ereditati. A ogni espressione booleana $B$ associamo due etichette, $B.italic("true")$ e $B.italic("false")$, che indicano i punti raggiunti dal controllo quando $B$ è rispettivamente vera o falsa. A ogni statement $S$ associamo invece $S.italic("next")$, che indica l'etichetta a cui proseguire al termine dello statement. Se subito dopo $S.italic("code")$ compare un salto a un'etichetta $L$, possiamo assegnare direttamente $L$ a $S.italic("next")$: eventuali salti interni a $S$ raggiungono così la destinazione finale, evitando un salto intermedio.

#figure(
  image("images/cod3indiriziPerControlloFlusso.png"),
  caption: [Codice a tre indirizzi per if, if-else e while.],
) <fig-schema-flusso>


La definizione guidata dalla sintassi della @fig-sdd-controllo, insieme alle regole per le espressioni booleane della @fig-sdd-salti-booleani, costruisce il codice dei costrutti considerati. La funzione $italic("newlabel")()$ crea una nuova etichetta a ogni chiamata, mentre $italic("label")(L)$ colloca l'etichetta $L$ davanti all'istruzione successiva. Il simbolo $\|\|$ indica la concatenazione delle porzioni di codice.

Un programma è rappresentato dalla produzione $P -> S$. Le regole associate creano una nuova etichetta per $S.italic("next")$ e costruiscono $P.italic("code")$ concatenando $S.italic("code")$ con la definizione di tale etichetta. Nella produzione $S -> bold(upright("assign"))$, invece, $bold(upright("assign"))$ è un segnaposto per un assegnamento già tradotto: il suo attributo $bold(upright("assign")).italic("code")$ viene semplicemente copiato in $S.italic("code")$.

Per la produzione $S -> bold(upright("if")) "(" B ")" space S_1$, si crea una nuova etichetta $B.italic("true")$ all'inizio del codice di $S_1$. Si pone inoltre $B.italic("false") = S_1.italic("next") = S.italic("next")$: se $B$ è falsa, il controllo salta il corpo; al termine di $S_1$, prosegue oltre l'intero costrutto.

Nel caso $S -> bold(upright("if")) "(" B ")" space S_1 space bold(upright("else")) space S_2$, le etichette $B.italic("true")$ e $B.italic("false")$ individuano rispettivamente l'inizio di $S_1$ e di $S_2$. Entrambi i rami hanno come destinazione successiva $S.italic("next")$. Dopo il codice di $S_1$ occorre inserire un salto esplicito a questa etichetta, per evitare di eseguire anche $S_2$; dopo il codice di $S_2$, invece, basta proseguire sequenzialmente.

Per la produzione $S -> bold(upright("while")) "(" B ")" space S_1$, si introduce una variabile locale $italic("begin")$ che contiene l'etichetta posta all'inizio di $B.italic("code")$. Se $B$ è vera, il controllo raggiunge $B.italic("true")$, all'inizio del corpo; se è falsa, raggiunge $B.italic("false") = S.italic("next")$ ed esce dal ciclo. Dopo $S_1.italic("code")$ si inserisce un salto a $italic("begin")$ per rivalutare la condizione. Si assegna inoltre $S_1.italic("next") = italic("begin")$, affinché anche eventuali salti interni al corpo possano raggiungere direttamente l'inizio del test senza passare dall'istruzione `goto begin` (per esempio, se il corpo del while è fatto da solo un `if` e la sua condizione è falsa, si salta direttamente a $b e g i n$).

#figure(
  image("images/SDDcostruttiControlloFlusso.png", width: 70%),
  caption: [Definizione guidata dalla sintassi dei costrutti di controllo del flusso.],
) <fig-sdd-controllo>

Infine, il codice relativo alla produzione $S -> S_1 space S_2$ consiste semplicemente del codice di $S_1$ seguito dal codice di $S_2$. L'etichetta $S_1.italic("next")$ viene posta all'inizio di $S_2.italic("code")$, mentre $S_2.italic("next") = S.italic("next")$.

#figure(
  image("images/genCodice3indirizziExprBool.png", width: 70%),
  caption: [Generazione del codice a tre indirizzi per le espressioni booleane.],
) <fig-sdd-salti-booleani>

=== Traduzione di espressioni booleane mediante costrutti per il controllo del flusso

Le regole semantiche per le espressioni booleane riportate nella @fig-sdd-salti-booleani complementano le regole per gli statement riportate nella @fig-sdd-controllo. Secondo l'organizzazione del codice presentata nella @fig-schema-flusso, un'espressione booleana $B$ può essere tradotta in istruzioni a tre indirizzi che ne calcolano il valore mediante salti condizionati e incondizionati all'etichetta $B.t r u e$ se $B$ risulta vera e a $B.f a l s e$ in caso contrario.

La quarta produzione della @fig-sdd-salti-booleani, cioè $B -> E_1 bold("rel") E_2$, viene tradotta direttamente da un'istruzione di confronto a tre indirizzi con i salti alle etichette appropriate. Per esempio un'espressione del tipo $a < b$ viene tradotta come:

#align(center, block(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  align(left)[
    `if a < b goto B.true` \
    `goto B.false`
  ],
))

Le rimanenti produzioni del non-terminale $B$ sono tradotte come segue:

1. Supponiamo che $B$ abbia la forma $B_1 \|\| B_2$. Se $B_1$ è vera sappiamo immediatamente che anche $B$ è vera, per cui $B_1.t r u e$ coincide con $B.t r u e$. Se $B_1$, invece, è falsa è necessario valutare $B_2$ per cui assegniamo a $B_1.f a l s e$ l'etichetta associata alla prima istruzione del codice relativo a $B_2$. Infine, le etichette di uscita di $B_2$ coincidono con quelle di $B$.
2. La traduzione di $B_1 space \&\& space B_2$ segue uno schema simile.
3. La traduzione di un'espressione del tipo $! B_1$ non richiede alcun codice: è sufficiente scambiare le etichette di uscita di $B$ (cioè $B.t r u e$ e $B.f a l s e$) per ottenere le etichette di uscita di $B_1$.
4. Le costanti $bold("true")$ e $bold("false")$ vengono tradotte con salti incondizionati rispettivamente alle etichette $B.t r u e$ e $B.f a l s e$.

#example()[
  Consideriamo ancora lo statement:

  #align(center)[`if (x < 100 || x > 200 && x != y) x = 0;`]

  Usando le definizioni guidate dalla sintassi delle @fig-sdd-controllo e @fig-sdd-salti-booleani, questo statement costituisce un programma generato dalla produzione $P -> S$ e otterremmo quindi il codice a tre indirizzi mostrato di seguito.

  #figure(image("images/esempioTraduzioneFlussoControllo.png"))
]


=== Evitare istruzioni goto ridondanti

La traduzione descritta finora può generare salti ridondanti. Per esempio, il confronto $x > 200$ nell'esempio precedente viene tradotto nella forma:

#align(center)[
  ```text
      if x > 200 goto L4
      goto L1
  L4: ...
  ```
]

Lo stesso comportamento può essere ottenuto con:

#align(center)[
  ```text
      ifFalse x > 200 goto L1
  L4: ...
  ```
]

Se la condizione è vera, il controllo raggiunge $L_4$ semplicemente proseguendo con l'istruzione successiva; se è falsa, salta a $L_1$. Si sfrutta così il flusso sequenziale, detto anche esecuzione *a cascata* (_fall-through_), risparmiando un'istruzione di salto.

Per esprimere questa possibilità nelle regole semantiche introduciamo l'etichetta speciale $italic("fall")$, che indica di *non generare un salto per quella destinazione*, lasciando proseguire il controllo con il codice immediatamente successivo. Non si tratta quindi di un'etichetta effettiva da inserire nel codice.

Nel costrutto $S -> bold(upright("if")) "(" B ")" space S_1$, il codice di $S_1$ segue quello di $B$: quando la condizione è vera, possiamo raggiungere il corpo per prosecuzione sequenziale. Le regole diventano pertanto:

$
  B.italic("true") &= italic("fall") \
  B.italic("false") &= S_1.italic("next") = S.italic("next") \
  S.italic("code") &= B.italic("code") "||" S_1.italic("code")
$

Lo stesso principio permette di assegnare $italic("fall")$ a $B.italic("true")$ anche nei costrutti $bold("if-else")$ e $bold("while")$, nei quali il ramo vero o il corpo del ciclo segue immediatamente il codice della condizione.

Occorre quindi adattare le regole delle espressioni booleane. Per la produzione $B -> E_1 space bold(upright("rel")) space E_2$, dopo il codice necessario a calcolare gli operandi, si generano le istruzioni di salto in funzione delle destinazioni:

+ Se $B.italic("true")$ e $B.italic("false")$ indicano entrambi etichette effettive, ossia nessuno dei due fa riferimento all'etichetta speciale $f a l l$, si generano un salto condizionato alla prima e un salto incondizionato alla seconda, come nella traduzione precedente.

+ Se soltanto $B.italic("false") = italic("fall")$, si genera un'istruzione $bold("if")$ che salta a $B.italic("true")$ quando il confronto è vero; quando è falso, il controllo prosegue sequenzialmente.

+ Se soltanto $B.italic("true") = italic("fall")$, si genera un'istruzione $bold("ifFalse")$ che salta a $B.italic("false")$ quando il confronto è falso; quando è vero, il controllo prosegue sequenzialmente.

+ Se entrambe le destinazioni sono $italic("fall")$, non si genera alcuna istruzione di salto.

In tutti i casi si conserva il codice delle sottoespressioni $E_1$ ed $E_2$: la loro valutazione può infatti produrre effetti collaterali, per esempio se contiene assegnamenti.

Per la produzione $B -> B_1 "||" B_2$, bisogna distinguere il significato di $italic("fall")$ per l'intera espressione da quello che avrebbe per il primo operando. Proseguire dopo $B_1$ significa entrare nel codice di $B_2$; proseguire dopo $B$, invece, significa aver terminato la valutazione dell'intera disgiunzione.

Se $B_1$ è falsa, occorre valutare $B_2$: si assegna quindi $B_1.italic("false") = italic("fall")$. Se $B_1$ è vera, invece, bisogna saltare il codice di $B_2$, rispettando il cortocircuito. La destinazione $B_1.italic("true")$ deve perciò essere un'etichetta effettiva:

- Se $B.italic("true")$ è già un'etichetta effettiva, si usa la stessa.
- Se $B.italic("true") = italic("fall")$, si crea una nuova etichetta e la si colloca subito dopo il codice di $B_2$.

Le destinazioni del secondo operando coincidono invece con quelle dell'intera espressione:
$
  B_2.italic("true") = B.italic("true"), quad
  B_2.italic("false") = B.italic("false").
$

Le regole per $B -> B_1 "&&" B_2$ sono analoghe: se $B_1$ è vera si prosegue nella valutazione di $B_2$, mentre se è falsa si deve saltare il secondo operando. Si pone quindi $B_1.italic("true") = italic("fall")$ e si usa per $B_1.italic("false")$ una destinazione effettiva, creandola dopo il codice di $B_2$ quando $B.italic("false") = italic("fall")$.

#example()[
  Consideriamo nuovamente lo statement:

  #align(center)[
    `if (x < 100 || x > 200 && x != y) x = 0;`
  ]

  Le nuove regole producono il seguente codice:

  #align(center)[
    ```text
        if x < 100 goto L2
        ifFalse x > 200 goto L1
        ifFalse x != y goto L1
    L2: x = 0
    L1:
    ```
  ]

  Per l'intera condizione si ha $B.italic("true") = italic("fall")$, perché il ramo vero è l'assegnamento immediatamente successivo, e $B.italic("false") = L_1$, che permette di saltarlo.

  Il primo operando dell'OR è $x < 100$. Se è vero, occorre raggiungere subito l'assegnamento senza valutare il resto della condizione: viene quindi creata l'etichetta $L_2$, posta dopo il codice del secondo operando. Se è falso, il controllo prosegue con il confronto $x > 200$.

  I due confronti dell'AND usano $bold("ifFalse")$: se uno è falso si raggiunge $L_1$; se entrambi sono veri, il controllo arriva sequenzialmente all'assegnamento. Rispetto alla traduzione precedente vengono così eliminate le tre istruzioni di salto incondizionato, conservando la valutazione con cortocircuito.
]

=== Valori booleani e codice di salto

Finora abbiamo considerato le espressioni booleane per modificare il flusso di controllo. Un'espressione booleana può però essere valutata anche per ottenerne il valore, come negli assegnamenti `x = true;` oppure `x = a < b;`.

Per trattare entrambi gli usi possiamo costruire prima l'albero sintattico, seguendo uno dei due approcci:

+ *Due passate.* Si costruisce l'intero albero sintattico del programma; successivamente, lo si visita in profondità e si genera il codice secondo le regole semantiche.

+ *Una passata per le istruzioni, due per le espressioni.* Gli statement vengono tradotti durante l'analisi, mentre per ogni espressione si costruisce prima il relativo albero e poi lo si visita per generare il codice. Per esempio, in $bold(upright("while")) "(" E ")" space S_1$, si completa la traduzione di $E$ prima di iniziare a elaborare $S_1$.

Possiamo quindi usare un unico non-terminale $E$ per le espressioni, secondo la grammatica:

$
  S &-> bold(upright("id")) "=" E ";"
    "|" bold(upright("if")) "(" E ")" S
    "|" bold(upright("while")) "(" E ")" S
    "|" S S \
  E &-> E "&&" E
    "|" E space bold(upright("rel")) space E
    "|" E "+" E
    "|" "(" E ")"
    "|" bold(upright("id"))
    "|" bold(upright("true"))
    "|" bold(upright("false"))
$

Il ruolo di $E$ dipende dal contesto: nella produzione $S -> bold(upright("while")) "(" E ")" space S_1$ determina il flusso di controllo, mentre in $S -> bold(upright("id")) "=" E ";"$ deve fornire un valore da assegnare.

Supponiamo che $E.n$ indichi il nodo dell'albero sintattico relativo a $E$. Associamo ai nodi due metodi distinti:

- $italic("jump")(t, f)$ genera il codice che trasferisce il controllo all'etichetta $t$ quando l'espressione è vera e all'etichetta $f$ quando è falsa, applicando le regole del codice di salto.
- $italic("rvalue")()$ genera il codice necessario a ottenere il valore dell'espressione e restituisce l'indirizzo in cui tale valore è disponibile, eventualmente usando una variabile temporanea.

Nel caso del *while*, si invoca $E.n.italic("jump")(t, f)$, dove $t$ identifica l'inizio del corpo e $f$ coincide con $S.italic("next")$. Nel caso di un assegnamento si invoca invece $E.n.italic("rvalue")()$.

Per un'espressione aritmetica, $italic("rvalue")()$ opera come già visto nella traduzione delle espressioni. Per un'espressione booleana composta, come $E_1 "&&" E_2$, può invece utilizzare il codice di salto e trasformarne l'esito in un valore esplicito: nei due punti di uscita si assegna rispettivamente $bold("true")$ o $bold("false")$ a una variabile temporanea. Si conserva così anche la valutazione con cortocircuito.

#example()[
  L'assegnamento `x = a < b && c < d;` può essere tradotto nel seguente codice:

  #align(center)[
    $
      & bold(upright("ifFalse")) space a < b space bold(upright("goto")) space L_1 \
      & bold(upright("ifFalse")) space c < d space bold(upright("goto")) space L_1 \
      & t = bold(upright("true")) \
      & bold(upright("goto")) space L_2 \
      L_1: & t = bold(upright("false")) \
      L_2: & x = t
    $
  ]

  Se il primo confronto è falso, il controllo raggiunge subito $L_1$, senza valutare il secondo. Se il primo è vero, si valuta il secondo confronto: anche in questo caso, un esito falso conduce a $L_1$.

  Solo quando entrambi i confronti sono veri si assegna *true* a $t$, saltando poi a $L_2$ per evitare l'assegnamento di *false*. In entrambi i percorsi, l'ultima istruzione copia in $x$ il valore booleano memorizzato in $t$.
]

== Backpatching

Un problema cruciale nella generazione del codice per le espressioni booleane e per le istruzioni di controllo del flusso è quello di accoppiare un'istruzione di salto con l'etichetta di destinazione del salto stesso. Per esempio, la traduzione dell'espressione booleana $B$ nell'istruzione $bold(upright("if")) "(" B ")" S$ nel caso in cui $B$ risulti falsa, contiene un salto alla prima istruzione che segue il codice di $S$. In uno schema di traduzione a una sola passata, $B$ deve essere tradotta prima che il non-terminale $S$ venga analizzato. Qual è quindi l'etichetta dell'istruzione `goto` che salta oltre il codice di $S$?

Precedentemente abbiamo risolto questo problema propagando le etichette mediante attributi ereditati fino al punto in cui esse sono richieste per la generazione delle relative istruzioni di salto. In questo modo, tuttavia, è necessaria una seconda passata per associare alle etichette gli indirizzi effettivi.

In questo paragrafo vedremo un approccio complementare, chiamato *backpatching*, secondo cui opportuni attributi sintetizzati vengono utilizzati per propagare liste di salti. Più precisamente, quando viene generato un salto se ne lascia temporaneamente non specificata la destinazione. Ogni salto di questo tipo viene poi aggiunto a una lista che raccoglie tutti i salti le cui etichette di destinazione dovranno essere specificate in un secondo momento, cioè quando sarà possibile determinarle esattamente. Le liste saranno costruite in modo che tutti i salti in una stessa lista facciano riferimento alla stessa etichetta.

=== Generazione del codice in una passata mediante backpatching

La tecnica di backpatching può essere utilizzata per generare il codice di espressioni booleane e di istruzioni di controllo del flusso in una sola passata.

In questo paragrafo useremo gli attributi sintetizzati _truelist_ e _falselist_ di un non-terminale $B$ per gestire le etichette del codice di salto nella traduzione delle espressioni booleane. In particolare $B.t r u e l i s t$ è una lista di tutte le istruzioni di salto -- condizionato e incondizionato -- in cui dovremo inserire l'etichetta a cui saltare se $B$ risulta vera. La lista $B.f a l s e l i s t$ svolge lo stesso ruolo per i salti nel caso in cui $B$ risulti falsa. Mentre viene generato il codice di $B$, i salti ai punti di uscita vero e falso vengono lasciati incompleti (non si specifica un valore per il campo che contiene l'etichetta), e vengono inseriti nelle liste $B.t r u e l i s t$ o $B.f a l s e l i s t$ a seconda dei casi. In modo analogo il non-terminale $S$ relativo ad uno statement ha un attributo sintetizzato $S.n e x t l i s t$ che raccoglie i salti all'istruzione successiva al codice di $S$.\ Per semplicità supponiamo di memorizzare le istruzioni generate in un array e di utilizzare l'indice di un'istruzione come sua etichetta. Per manipolare le liste di salti utilizzeremo le tre seguenti funzioni:

+ _makelist(i)_ crea una nuova lista contenente solamente l'indice $i$ di un elemento di un'istruzione dell'array e restituisce un puntatore alla lista appena creata.

+ _merge_$(p_1, p_2)$ concatena le liste puntate da $p_1$ e $p_2$ e restituisce un puntatore alla lista risultante.

+ _backpatch(p, i)_ inserisce $i$ come etichetta di destinazione in ognuna delle istruzioni nella lista puntata da $p$.

=== Backpatching delle espressioni booleane

Costruiamo uno schema di traduzione per generare il codice delle espressioni booleane durante il parsing bottom-up. La grammatica introduce un non-terminale marcatore $M$, che permette di memorizzare l'indice della prossima istruzione nel momento in cui inizia la traduzione del secondo operando:

$
  B &-> B_1 "||" M B_2
    "|" B_1 "&&" M B_2
    "|" "!" B_1
    "|" "(" B_1 ")" \
    & quad "|" E_1 space bold(upright("rel")) space E_2
    "|" bold(upright("true"))
    "|" bold(upright("false")) \
  M &-> epsilon
$

Alla produzione $M -> epsilon$ è associata l'azione:

$
  \{ M.italic("instr") = italic("nextinstr"); \}
$

La variabile $italic("nextinstr")$ contiene l'indice della prossima istruzione che sarà generata. La riduzione del marcatore memorizza questo valore in $M.italic("instr")$, senza generare codice né modificare $italic("nextinstr")$. Il valore salvato potrà così essere usato dopo aver analizzato il secondo operando.

#figure(
  image("images/schemaTradBooleanNMT.png", width: 80%),
  caption: [Schema di traduzione delle espressioni booleane.],
) <trad-expr-bool>

Le azioni semantiche della @trad-expr-bool operano come segue:

- *(1) OR.* Se $B_1$ è vera, anche $B$ è vera: i salti contenuti in $B_1.italic("truelist")$ diventano quindi parte di $B.italic("truelist")$. Se invece $B_1$ è falsa, occorre valutare $B_2$: la destinazione dei salti in $B_1.italic("falselist")$ deve essere l'inizio del codice di $B_2$.
  Questo indice viene memorizzato dal non-terminale marcatore $M$, posto immediatamente prima di $B_2$. Alla produzione $M -> epsilon$ è associata l'azione semantica:
  $
    \{ M.italic("instr") = italic("nextinstr"); \}
  $
  La variabile $italic("nextinstr")$ contiene l'indice della prossima istruzione che sarà generata. Quando viene ridotto il marcatore, il codice di $B_1$ è già stato generato e quello di $B_2$ deve ancora iniziare: il valore salvato in $M.italic("instr")$ identifica quindi la prima istruzione del secondo operando. Dopo aver analizzato anche $B_2$, l'azione associata all'OR esegue $italic("backpatch")(B_1.italic("falselist"), M.italic("instr"))$, completando i salti che devono trasferire il controllo da $B_1$ a $B_2$. Infine, riunisce le uscite vere dei due operandi in $B.italic("truelist")$ e assegna a $B.italic("falselist")$ la lista $B_2.italic("falselist")$: l'OR risulta falso soltanto quando, dopo aver raggiunto il secondo operando, anche questo risulta falso.

- *(2) AND.* Questa azione è simile alla (1). Si valuta $B_2$ soltanto se $B_1$ è vera, quindi si completa $B_1.italic("truelist")$ con la destinazione $M.italic("instr")$. La lista $B.italic("truelist")$ coincide con $B_2.italic("truelist")$, mentre le uscite false dei due operandi vengono riunite in $B.italic("falselist")$.

- *(3) Negazione.* Si scambiano le liste delle uscite vere e false di $B_1$, senza generare nuove istruzioni.

- *(4) Parentesi.* Si copiano in $B$ le liste di $B_1$, senza modificarle e senza generare nuove istruzioni.

- *(5) Confronto.* Si generano un salto condizionato e uno incondizionato, entrambi con destinazione non ancora specificata. I loro indici vengono inseriti rispettivamente in $B.italic("truelist")$ e $B.italic("falselist")$. Le liste contengono quindi gli *indici delle istruzioni da completare*, non le loro destinazioni.

- *(6) Costante true.* Si genera un salto incondizionato incompleto, il cui indice viene inserito in $B.italic("truelist")$; la lista $B.italic("falselist")$ è vuota.

- *(7) Costante false.* Si genera un salto incondizionato incompleto, il cui indice viene inserito in $B.italic("falselist")$; la lista $B.italic("truelist")$ è vuota.

- *(8) Marcatore.* Si salva il valore corrente di $italic("nextinstr")$ in $M.italic("instr")$, senza generare codice né modificare $italic("nextinstr")$.

#example()[
  Consideriamo l'espressione:

  $
    x < 100 "||" x > 200 "&&" x != y
  $

  Poiché l'AND ha precedenza sull'OR, il secondo operando dell'OR è l'intera sottoespressione $x > 200 "&&" x != y$.

  #figure(
    image("images/albeParsingEsempioExprBool.png", width: 80%),
    caption: [Albero di parsing annotato dell'espressione booleana.],
  ) <fig-albero-backpatching>

  Nella @fig-albero-backpatching, gli attributi $italic("truelist")$, $italic("falselist")$ e $italic("instr")$ sono abbreviati rispettivamente con $t$, $f$ e $i$.

  Le azioni vengono eseguite alle riduzioni del parsing bottom-up, secondo l'ordine rappresentato dalla visita in profondità dell'albero. Non è necessario costruire prima l'intero albero: tutte le azioni si trovano alla fine delle produzioni e possono essere eseguite durante il parsing.

  Supponiamo che la numerazione delle istruzioni inizi da 100. Indichiamo con $M_1$ e $M_2$ le due occorrenze del marcatore, rispettivamente dopo l'OR e dopo l'AND (come da @trad-expr-bool).

  + La riduzione di $x < 100$ a $B$ genera le istruzioni 100 e 101 (vedere @fig-passi-backpatching), entrambe con destinazione incompleta. Le liste delle uscite vere e false sono rispettivamente $\{100\}$ e $\{101\}$.

  + La riduzione $M_1 -> epsilon$ salva $M_1.italic("instr") = 102$, cioè l'inizio del codice del secondo operando dell'OR.

  + La riduzione di $x > 200$ a $B$ genera le istruzioni 102 e 103. Le sue liste delle uscite vere e false sono rispettivamente $\{102\}$ e $\{103\}$. La sottoespressione $x > 200$ corrisponde a $B_1$ in $B -> B_1 space \&\& space M space B_2$.

  + La riduzione $M_2 -> epsilon$ salva $M_2.italic("instr") = 104$, cioè l'inizio del codice del secondo operando dell'AND.

  + La riduzione di $x != y$ a $B$ genera le istruzioni 104 e 105. Le sue liste delle uscite vere e false sono rispettivamente $\{104\}$ e $\{105\}$.

  + Alla riduzione dell'AND (mediante $B -> B_1 space \&\& space M space B_2$, dopo che il parser ha riconosciuto l'intera espressione di AND logico) si esegue:
    $
      italic("backpatch")(\{102\}, 104).
    $
    La destinazione del salto nell'istruzione 102 diventa quindi 104: se $x > 200$ è vero, si valuta $x != y$. L'AND risultante ha lista delle uscite vere $\{104\}$ e lista delle uscite false $\{103, 105\}$. Il codice ottenuto è mostrato nella parte (a) della @fig-passi-backpatching.

  + Alla riduzione dell'OR si esegue:
    $
      italic("backpatch")(\{101\}, 102).
    $
    La destinazione del salto nell'istruzione 101 diventa 102: se $x < 100$ è falso, si valuta l'AND. Le liste finali sono:
    $
      B.italic("truelist") &= \{100, 104\}; \
      B.italic("falselist") &= \{103, 105\}.
    $Queste liste derivano dalle riduzioni precedenti: la riduzione dell'AND produce le liste $\{104\}$ e $\{103, 105\}$; la successiva riduzione dell'OR unisce le uscite vere dei suoi operandi, ottenendo $\{100, 104\}$, e conserva le uscite false dell'AND, $\{103, 105\}$.\ L'intera espressione risulta vera quando viene effettuato il salto condizionato dell'istruzione 100 oppure quello dell'istruzione 104; risulta falsa quando viene eseguito uno dei salti incondizionati 103 o 105. Il codice risultante è mostrato nella parte (b).
  #figure(
    [
      #align(center)[
        ```text
        100: if x < 100 goto _
        101: goto _
        102: if x > 200 goto 104
        103: goto _
        104: if x != y goto _
        105: goto _
        ```

        (a) Dopo il backpatching della destinazione 104 nell'istruzione 102.
      ]

      #v(1em)

      #align(center)[
        ```text
        100: if x < 100 goto _
        101: goto 102
        102: if x > 200 goto 104
        103: goto _
        104: if x != y goto _
        105: goto _
        ```

        (b) Dopo il backpatching della destinazione 102 nell'istruzione 101.
      ]
    ],
    kind: image,
    caption: [Passi del processo di backpatching.],
  ) <fig-passi-backpatching>

  I salti 101 e 102 sono stati completati perché collegano parti interne dell'espressione. Restano invece incomplete le destinazioni dei salti che ne determinano l'esito complessivo: 100 e 104 per il caso vero, 103 e 105 per il caso falso.

  Queste destinazioni saranno assegnate quando il costrutto che contiene l'espressione, per esempio un *if* o un *while*, stabilirà dove proseguire nei due casi di verità/falsità dell'espressione. In particolare, il salto condizionato 100 conduce all'uscita vera soltanto se il confronto $x < 100$ ha esito vero: il semplice raggiungimento dell'istruzione non basta.
]

=== Statement per il controllo del flusso

Usiamo ora il backpatching per tradurre gli statement per il controllo del flusso in una sola passata. Come punto di partenza consideriamo la grammatica:

$
  S &-> bold(upright("if")) "(" B ")" space S
    "|" bold(upright("if")) "(" B ")" space S space bold(upright("else")) space S \
    & quad "|" bold(upright("while")) "(" B ")" space S
    "|" "{" L "}"
    "|" A ";" \
  L &-> L space S "|" S
$

Il non-terminale $S$ rappresenta uno statement, $L$ una lista di statement, $A$ un assegnamento e $B$ un'espressione booleana. La grammatica è volutamente incompleta: omette, per esempio, le produzioni degli assegnamenti, già trattate in precedenza.

L'organizzazione del codice per $bold("if")$, $bold("if-else")$ e $bold("while")$ rimane quella già vista. Supponiamo che le istruzioni siano memorizzate nell'ordine in cui devono essere eseguite: in assenza di salti, il controllo prosegue quindi con l'istruzione successiva.

Le espressioni booleane conservano gli attributi $B.italic("truelist")$ e $B.italic("falselist")$. Agli statement associamo invece l'attributo sintetizzato $S.italic("nextlist")$, che contiene gli indici dei salti incompleti diretti all'istruzione che, nell'ordine di esecuzione, deve seguire $S$. L'attributo $L.italic("nextlist")$ svolge lo stesso ruolo per una lista di statement.

A differenza di $S.italic("next")$, che indicava una destinazione già nota, $S.italic("nextlist")$ raccoglie dunque i *salti la cui destinazione deve ancora essere specificata*. Non rappresenta la prosecuzione sequenziale: se uno statement termina senza salti, il controllo passa naturalmente all'istruzione successiva e non occorre inserire nulla nella lista.

Lo schema di traduzione completo è riportato nella @trad-statement-backpatching; nel seguito richiamiamo le azioni semantiche mediante i numeri indicati nella figura. Consideriamo dapprima l'azione *(3)*, relativa al *while*. Le due occorrenze del marcatore $M$ memorizzano l'inizio del codice della condizione e quello del corpo:
$
  M_1.italic("instr") = "inizio del codice di " B; \
  M_2.italic("instr") = "inizio del codice di " S_1.
$
Come nell'azione *(6)*, ogni marcatore viene ridotto mediante $M -> epsilon$ e salva il valore corrente di $italic("nextinstr")$, senza generare istruzioni.

Alla riduzione dell'intero *while*, si completa $S_1.italic("nextlist")$ con la destinazione $M_1.italic("instr")$: i salti interni che concludono l'esecuzione del corpo devono tornare direttamente alla valutazione della condizione. Per esempio, se il corpo consiste soltanto in un *if* senza *else*, il salto corrispondente alla condizione falsa dell'*if* deve raggiungere il test del *while*. Se invece il controllo raggiunge sequenzialmente la fine del corpo, il ritorno al test è assicurato dal salto esplicito aggiunto dopo il suo codice ($italic("gen")(upright("'goto'") M_1.italic("instr"))$). Si completa inoltre $B.italic("truelist")$ con la destinazione $M_2.italic("instr")$, così che una condizione vera trasferisca il controllo all'inizio del corpo. Infine, si pone:
$
  S.italic("nextlist") = B.italic("falselist").
$
I salti corrispondenti alla condizione falsa rappresentano infatti le uscite dal ciclo e saranno completati quando sarà nota la destinazione successiva al *while*.

Nell'azione *(2)*, relativa all'*if-else*, $M_1.italic("instr")$ e $M_2.italic("instr")$ memorizzano rispettivamente l'inizio dei rami $S_1$ e $S_2$. Le liste $B.italic("truelist")$ e $B.italic("falselist")$ vengono completate con questi due indici.

Occorre però impedire che, raggiunta sequenzialmente la fine di $S_1$, il controllo prosegua nel ramo $S_2$. A questo scopo viene inserito, dopo $S_1$, un secondo tipo di marcatore, $N$. Alla riduzione $N -> epsilon$, l'azione *(7)* genera un salto incondizionato con destinazione ancora sconosciuta e ne salva l'indice in $N.italic("nextlist")$:
$
  N.italic("nextlist") = italic("makelist")(italic("nextinstr")); \
  italic("gen")(upright("'goto _'")).
$

L'azione dell'*if-else* costruisce quindi $S.italic("nextlist")$ riunendo $S_1.italic("nextlist")$, $N.italic("nextlist")$ e $S_2.italic("nextlist")$: tutti questi salti devono proseguire oltre l'intero condizionale. La variabile locale $italic("temp")$ serve soltanto a conservare il risultato intermedio della fusione delle liste.

#figure(
  image("images/traduzioneStatementControlloFlusso.png", width: 80%),
  caption: [Schema di traduzione degli statement mediante backpatching.],
) <trad-statement-backpatching>

Nell'azione *(1)*, relativa all'*if* senza *else*, si completa $B.italic("truelist")$ con l'inizio del corpo, memorizzato in $M.italic("instr")$. La lista $S.italic("nextlist")$ riunisce invece $B.italic("falselist")$ e $S_1.italic("nextlist")$: sia il caso in cui la condizione è falsa, sia gli eventuali salti in uscita dal corpo devono proseguire dopo il condizionale.

Le azioni *(8)* e *(9)* gestiscono le sequenze di statement. Nell'azione *(8)*, il codice dello statement $S$ segue quello della lista $L_1$: si completa quindi $L_1.italic("nextlist")$ con $M.italic("instr")$, che indica l'inizio di $S$. Le uscite ancora da completare dell'intera sequenza sono quelle dell'ultimo statement, perciò $L.italic("nextlist") = S.italic("nextlist")$. Nell'azione *(9)*, la lista contiene un solo statement e ne eredita direttamente la lista dei salti.

L'azione *(4)* propaga al blocco la lista delle uscite della sequenza racchiusa tra parentesi graffe. Nell'azione *(5)*, invece, un semplice assegnamento non introduce salti da completare: $S.italic("nextlist")$ è quindi vuota, rappresentata nella figura dal valore *null*.

Tra le azioni della figura, soltanto *(3)* e *(7)* generano nuove istruzioni: rispettivamente il salto di ritorno al test del *while* e quello che permette di saltare il ramo *else*. Il resto del codice è prodotto dalla traduzione degli assegnamenti e delle espressioni; le altre azioni collegano queste porzioni mediante il backpatching e la propagazione delle liste.

=== Gli statement break, continue, goto

Lo statement più semplice per modificare il flusso di esecuzione in un programma è l'istruzione `goto`. In C, per esempio, lo statement `goto L` forza il flusso di esecuzione verso l'etichetta `L`, che deve essere associata a un'unica istruzione nello scope corrente. Le istruzioni `goto` possono essere implementate mantenendo una lista di istruzioni di salto incomplete per ogni etichetta; quindi, appena possibile, si deve eseguire il backpatching risolvendo tali salti.

Il frammento di codice seguente, preso da un analizzatore lessicale, illustra un semplice uso degli statement `break` e `continue`:

```c
1) for ( ; ; readch() ) {
2)   if ( peek == ' ' || peek == '\t' ) continue;
3)   else if ( peek == '\n' ) line = line + 1;
4)   else break;
5) }
```
Nel caso dell'istruzione `break` alla linea 4 il controllo passa alla prima istruzione successiva al ciclo `for`. L'istruzione `continue` alla linea 2, invece, fa sì che il controllo passi all'inizio del codice che valuta la funzione `readch()`, quindi al codice dell'istruzione `if` alla linea 2.

Se $S$ è il costrutto che contiene lo statement `break`, allora tale statement è di fatto un salto incondizionato alla prima istruzione successiva al codice di $S$. Possiamo generare il codice dell'istruzione `break` in tre passi:

+ teniamo traccia dello statement contenitore $S$.
+ Generiamo una istruzione incompleta di salto per lo statement `break`.
+ Inseriamo tale istruzione di salto nella lista $S.n e x t l i s t$.

In un front-end a due passate per la costruzione di alberi sintattici, $S.n e x t l i s t$ potrebbe essere implementato come un campo del nodo relativo a $S$. Potremmo tenere traccia di $S$ mediante la tabella dei simboli associando il nodo dello statement $S$ a uno speciale identificatore $bold("break")$. Questa tecnica permette anche di gestire gli statement `break` con etichetta previsti dal linguaggio Java. La tabella dei simboli, infatti, può essere utilizzata per mappare le etichette ai nodi dell'albero sintattico relativi ai costrutti contenitori.

In alternativa, invece di usare la tabella dei simboli per accedere al nodo $S$, possiamo inserire nella tabella dei simboli un puntatore a $S.n e x t l i s t$. In questo modo, non appena incontriamo uno statement `break` generiamo un salto incompleto, cerchiamo `nextlist` nella tabella dei simboli e aggiungiamo il salto a tale lista; seguendo quanto discusso in una sezione precedente eseguiremo quindi il backpatching di tale salto.

Gli statement `continue` possono essere gestiti in modo simile. La principale differenza tra gli statement `continue` e `break` è che l'etichetta destinazione dei salti generati è differente.

== Traduzione costrutto switch

Il costrutto `switch` o `case` è previsto in molti linguaggi. Si ha un'espressione di selezione $E$, che deve essere valutata, seguita da $n$ valori costanti $V_1, V_2, dots, V_n$ che l'espressione $E$ può assumere, tra cui eventualmente un valore di `default` che convenzionalmente corrisponde all'espressione se essa non assume alcuno dei valori esplicitamente specificati.

#figure(
$
  & bold(upright("switch")) "(" E ")" "{" \
  & quad bold(upright("case")) space V_1 ":" space S_1 \
  & quad bold(upright("case")) space V_2 ":" space S_2 \
  & quad dots \
  & quad bold(upright("case")) space V_(n-1) ":" space S_(n-1) \
  & quad bold(upright("default")) ":" space S_n \
  & "}"
$, caption: "Sintassi dello statement switch.") <fig-switch>

Il comportamento previsto della traduzione dello statement `switch` è il seguente:

+ Valutazione dell'espressione $E$.
+ Ricerca, nell'elenco dei possibili casi, del valore $V_j$ uguale al risultato della valutazione di $E$. Si ricordi che il valore di `default` soddisfa la ricerca se nessuno dei casi espliciti corrisponde al valore di $E$.
+ Esecuzione dello statement $S_j$ associato al valore $V_j$ trovato.

Il passo 2 è un salto a $n$ vie che può essere implementato in diversi modi. Se il numero di casi è basso, indicativamente inferiore a 10, è ragionevole utilizzare una sequenza di salti condizionati ognuno dei quali esegue il confronto con uno specifico valore e trasferisce il controllo al codice degli statement corrispondenti.

Un modo compatto di implementare la sequenza di salti consiste nel creare una tabella di coppie, ognuna formata da un valore e dall'etichetta del codice dello statement corrispondente. Il valore effettivo dell'espressione stessa, accoppiato all'etichetta dello statement di `default`, viene poi aggiunto alla fine della tabella al momento dell'esecuzione.

C'è inoltre un caso speciale — abbastanza comune — che può essere implementato in modo più efficiente di un salto a $n$ vie. Se tutti i valori dei vari casi appartengono a un intervallo limitato tra `min` e `max` e tali casi coprono buona parte dei valori tra `min` e `max`, si può costruire un array di $text("max") - text("min") + 1$ elementi tali che l'elemento con indice $j - text("min")$ contenga l'etichetta dello statement relativo al valore $j$. Agli elementi corrispondenti ai casi non esplicitamente specificati viene inoltre assegnata l'etichetta corrispondente al caso di `default`.

Per eseguire la selezione si valuta l'espressione ottenendo un certo valore $j$, si verifica che $j$ appartenga all'intervallo tra `min` e `max`, quindi si trasferisce il controllo in modo indiretto all'etichetta memorizzata nell'elemento dell'array con indice $j - text("min")$. Se, per esempio, l'espressione è di tipo carattere, si può ricorrere a una tabella con 128 elementi (il numero degli elementi dipende dallo specifico insieme di caratteri) per trasferire il controllo allo statement corretto senza effettuare alcuna verifica sull'intervallo.
#figure(image("images/traduzioneSwitch.png", width: 80%))

=== Traduzione guidata dalla sintassi degli statement switch

Il codice intermedio mostrato nella Figura 6.48(a) è un esempio di traduzione adatta allo statement `switch` della @fig-switch. Tutti i test sono posizionati alla fine, cosicché un semplice generatore di codice possa riconoscere il costrutto di selezione a più vie e generare del codice efficiente seguendo la strategia più appropriata tra quelle suggerite nel paragrafo precedente.

Il codice più semplice mostrato nella Figura 6.48(b) richiederebbe un'analisi più complessa e ampia da parte del compilatore per scegliere l'implementazione più efficiente. Si noti che in un compilatore a singola passata non è conveniente posizionare le istruzioni di salto all'inizio, poiché in questo caso il compilatore non potrebbe emettere il codice dei vari statement $S_i$ nel momento in cui li incontra.

Per realizzare la traduzione nella forma suggerita dalla Figura 6.48(a) si procede come segue:

- Non appena si incontra la parola chiave $bold("switch")$ si generano due nuove etichette `test` e `next` e una nuova variabile temporanea $t$.
- Durante il parsing dell'espressione $E$ si genera il codice per la sua valutazione, in modo da lasciare il risultato nella variabile temporanea $t$. Dopo aver elaborato $E$, si genera l'istruzione di salto `goto test`.
- Non appena si incontra una parola chiave `case` si crea una nuova etichetta $L_i$ e la si inserisce nella tabella dei simboli. Si aggiunge inoltre in una coda — utilizzata solamente per memorizzare i vari casi — una coppia formata dal valore costante $V_i$ associato allo specifico caso e dalla corrispondente etichetta $L_i$ (o dal puntatore all'elemento della tabella dei simboli corrispondente a $L_i$).
- Si elabora quindi ogni statement `case ` $V_i : S_i$ emettendo l'etichetta $L_i$ e il codice dello statement corrispondente $S_i$, seguito dall'istruzione di salto `goto next`.

Quando si riconosce la fine dello statement `switch`, si può procedere alla generazione del codice del salto a più vie. Leggendo la coda delle coppie valore-etichetta precedentemente costruita si può generare la sequenza di istruzioni a tre indirizzi nella forma mostrata dalla Figura 6.49, in cui $t$ è la variabile temporanea che contiene il valore dell'espressione di selezione $E$, e $L_n$ è l'etichetta relativa allo statement del caso di `default`.

#figure(image("images/caseSwitch3indirizzi.png", width: 80%))

L'istruzione a tre indirizzi `case t ` $V_i$ $L_i$ svolge la stessa funzione dell'istruzione `if t = ` $V_i$ ` goto ` $L_i$ usata nella Figura 6.48(a). Il ricorso a tale specifica istruzione semplifica il compito del generatore di codice finale nel riconoscere potenziali candidati per un trattamento speciale. Durante la generazione del codice finale, infatti, sequenze di istruzioni `case` di questo tipo possono essere tradotte nell'implementazione più efficiente a seconda di quanti casi si hanno e dell'intervallo in cui ricadono i valori.


== Codice intermedio delle procedure

Le produzioni della Figura 6.50 specificano la sintassi della definizione e della chiamata di funzioni. I non terminali $D$ ed $T$ generano rispettivamente dichiarazioni e tipi. $F$ genera zero o più parametri formali. I non terminali $E$ ed $S$ generano rispettivamente, come già visto, espressioni e statement, ma la produzione relativa a $S$ aggiunge uno statement che restituisce il valore di un'espressione, mentre $E$ aggiunge la chiamata di funzione i cui parametri attuali sono generati dal non-terminale $A$ (e secondo questa grammatica, un parametro attuale è un'espressione seguita da una virgola). Si noti che questa grammatica genera, con i non-terminali $F$ ed $A$, una virgola indesiderata dopo l'ultimo parametro formale/attuale, ma è tuttavia adeguata allo scopo di illustrare il processo di traduzione in esame.

#figure(image("images/grammaticaFunzioni.png", width: 60%))

Sia la definizione di funzioni, sia la loro chiamata possono essere tradotte ricorrendo a concetti già trattati in questo capitolo.

- *Tipo delle funzioni.* Il tipo di una funzione deve codificare sia il tipo del valore restituito, sia il tipo dei vari parametri formali. Sia inoltre $italic("void")$ un tipo speciale utilizzato col significato di “nessun parametro” o “nessun valore di ritorno”. Per esempio, il tipo della funzione $italic("pop")()$ che restituisce un intero è "funzione da $italic("void")$ a $italic("integer")$". I tipi delle funzioni possono essere rappresentati ricorrendo al costruttore di tipo $italic("fun")()$ applicato al tipo di ritorno e alla lista ordinata dei tipi dei parametri.

- *Tabelle dei simboli.* Sia $s$ la tabella dei simboli in uso al momento in cui si raggiunge la definizione della funzione. Il nome della funzione dovrà essere aggiunto alla tabella $s$ per un successivo uso nel resto del programma. I parametri formali di una funzione possono essere trattati in modo analogo ai nomi dei campi di un record (@fig16). Nella produzione relativa a $D$, dopo aver riconosciuto in ingresso la parola chiave $bold(upright("define"))$, si impila $s$ sullo stack e si crea una nuova tabella dei simboli:

  $
    italic("Env").italic("push")(italic("top"));
    quad italic("top") = bold(upright("new")) italic("Env")(italic("top"));
  $

  Sia $t$ la nuova tabella dei simboli. Si noti che $italic("top")$ viene passato come argomento nell'espressione $bold(upright("new")) italic("Env")(italic("top"))$: in questo modo la nuova tabella $t$ può essere collegata alla precedente tabella $s$. La nuova tabella $t$ viene utilizzata per la traduzione del corpo della funzione. Solo alla fine di tale traduzione si ripristina la vecchia tabella $s$.

- *Controllo dei tipi.* In un'espressione una funzione viene trattata esattamente come ogni altro operatore. La trattazione del controllo dei tipi, compresi gli aspetti riguardanti le conversioni di tipo, si estende quindi anche alle funzioni. Per esempio, se $f$ è una funzione con un parametro di tipo $italic("real")$, nella chiamata $f(2)$ il valore intero $2$ viene convertito da $italic("integer")$ a $italic("real")$ automaticamente.

- *Chiamate di funzione.* Per generare il codice a tre indirizzi di una chiamata nella forma $bold(upright("id")) "(" E, E, dots, E ")"$, è sufficiente generare il codice per valutare ogni argomento $E$ riducendolo a un indirizzo e facendo seguire il codice generato da un'istruzione $bold(upright("param"))$. Volendo evitare di mischiare il codice relativo alla valutazione degli argomenti con le istruzioni $bold(upright("param"))$, è sufficiente salvare l'attributo $E.italic("addr")$ di ogni espressione $E$ in un'opportuna struttura dati, per esempio una coda. Una volta generato il codice per tutte le espressioni, si può procedere alla generazione delle istruzioni $bold(upright("param"))$ mentre la coda viene svuotata.

#example()[
  Supponiamo che `a` sia un array di interi e che `f` sia una funzione da interi a interi. In questo caso la traduzione dell'assegnamento
  #align(center)[`n = f(a[i]);`]
  in codice a tre indirizzi potrebbe essere la seguente:

  #align(center, block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    [
      #align(left)[
        `1) t1 = i * 4` \
        `2) t2 = a [ t1 ]` \
        `3) param t2` \
        `4) t3 = call f, 1` \
        `5) n = t3`
      ]
    ],
  ))

  Le prime due istruzioni calcolano il valore dell'espressione `a[i]` e lo salvano nella variabile temporanea `t2`, secondo quanto visto nella sezione sulla traduzione delle espressioni. La linea 3 specifica che `t2` è un parametro attuale della chiamata della funzione `f` alla linea 4, in cui si indica che il numero di parametri è appunto 1. La linea 4, inoltre, assegna il valore restituito dalla funzione alla variabile temporanea `t3`. Infine, la linea 5 copia il valore restituito nella variabile `n`.
]
