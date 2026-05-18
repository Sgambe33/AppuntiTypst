#import "../../../dvd.typ": *
#import "@preview/algo:0.3.6": algo, code, comment, d, i
#pagebreak()

= Generazione codice intermedio
Questo capitolo tratta le *rappresentazioni intermedie*, il *controllo di tipo statico* (*static type checking*) e la *generazione di codice intermedio*.
#figure(image("images/2025-11-25-16-09-51.png"))
Per semplificare, assumeremo che il front-end del compilatore sia organizzato in modo che il parsing, il controllo statico e la generazione del codice intermedio siano eseguiti sequenzialmente; in alcuni compilatori ottimizzati, il controllo statico e la generazione del codice possono essere combinati e incorporati direttamente all'interno delle fasi di parsing (tramite le SDD).

Molti degli schemi di traduzione possono essere implementati basandosi su parsing sia bottom-up sia top-down. In ogni caso, è sempre possibile realizzare un qualsiasi schema di traduzione costruendo prima l'albero sintattico (AST) in memoria e poi visitandolo opportunamente.

#definition()[
  I *controlli statici* (o *analisi semantica statica*) sono un insieme di verifiche di consistenza effettuate al momento della compilazione allo scopo di:
  + Garantire che un programma compili con *successo* e rispetti le regole di significato del linguaggio.
  + Individuare eventuali errori di programmazione prima dell'esecuzione vera e propria del programma.
]

Esistono due classi di controlli:
+ *Sintattici*: quali forme sentenziali che la grammatica consente di produrre sono effettivamente accettate dal linguaggio.
  #example()[
    - Identificatori di variabili dichiarati al più una volta in uno scope
    - Un `break` deve essere dentro un `while`, un `for` o uno `switch`
    - Distinzione del significato degli identificatori a sinistra e destra di un assegnamento:
    $
      i=5, quad underbracket(i, "l-value") = underbracket(i+1, "r-value")
    $
  ]
+ *Di tipo (type checking)*: garantire che un operatore/funzione siano applicati ad un numero corretto di operandi e che il loro tipo sia adeguato.
  #example()[
    Conversioni di tipo come casting o coercizione (casting implicito). Con $x=4+5.1$, $x$ diventa un float.
  ]

== Varianti degli alberi sintattici
#figure(image("images/2025-11-27-15-32-47.png"))
La rappresentazione intermedia di alto livello fa quasi sempre uso di alberi sintattici (AST) o, per essere più precisi e ottimizzati, di una loro variante detta *DAG* (Directed Acyclic Graph, Grafo Diretto Aciclico). A basso livello, invece, l'AST/DAG verrà "appiattito" facendo uso di *codice a 3 indirizzi*.

#definition()[
  Un grafo diretto aciclico o DAG relativo a un'espressione identifica le sue sottoespressioni comuni, che appaiono cioè più di una volta.
]

I DAG possono essere costruiti "al volo" esattamente con le stesse tecniche viste per gli alberi sintattici.

=== Grafi diretti aciclici delle espressioni
Come in un albero sintattico di un'espressione, in un DAG le foglie corrispondono agli operandi atomici (identificatori e numeri), mentre i nodi interni identificano gli operatori.

La differenza fondamentale sta nel fatto che, in un DAG, un nodo $N$ può avere *più di un genitore* se esso rappresenta una sotto-espressione comune. In un albero sintattico puro, invece, il sottoalbero corrispondente a una sotto-espressione comune verrebbe replicato tante volte quante la sotto-espressione appare nell'espressione complessiva. Un DAG, pertanto, non solo rappresenta le espressioni in modo molto più compatto in memoria, ma fornisce anche al compilatore indicazioni preziose per la generazione di codice ottimizzato ed efficiente.

#example()[
  Data l'espressione $a+a* (b-c) + (b-c) *d$, il relativo DAG associato risulta essere:
  <esempioDAG1>
  #figure(image("images/2025-11-27-15-37-24.png"))
  Da notare come il nodo $a$ abbia due genitori in quanto appare due volte nell'espressione, e il nodo dell'operazione $-$ (che rappresenta $b - c$) sia puntato da ben due operatori di moltiplicazione diversi.
]

La seguente SDD può costruire sia alberi sintattici sia DAG, a patto di modificare le funzioni costruttrici `Leaf()` e `Node()` in modo che, prima di allocare un nuovo nodo in memoria, verifichino se ne esiste già uno identico. In tal caso, tale nodo viene riutilizzato e restituito.

#figure(image("images/2025-11-27-16-03-18.png"))

Per esempio, prima di costruire un nuovo nodo `Node(op, left, right)`, la logica del compilatore deve scansionare una tabella hash per verificare se esiste già un nodo con etichetta `op` e con figli `left` e `right` (esattamente in quest'ordine). Se tale nodo esiste, la funzione `Node()` restituisce il puntatore a quel nodo; altrimenti, ne alloca uno nuovo.

#example()[
  La seguente sequenza di passi costruisce il DAG mostrato nell'esempio #link(<esempioDAG1>, [*precedente*]), a patto che le funzioni Leaf () e Node() ritornino un nodo gia esistente, secondo quanto appena discusso, quando cid é possibile.
  #figure(image("images/2025-11-27-16-18-56.png"))

  Assumiamo che `entry-a` sia un puntatore all'elemento della tabella dei simboli relativo ad $a$, e così per gli altri identificatori.
  Alla seconda invocazione di `Leaf(id, entry-a)` (linea 2), la funzione restituisce il puntatore al nodo precedentemente costruito, ovvero `p2 = p1`. Analogamente, i nodi restituiti ai passi 8 e 9 coincidono con quelli restituiti ai passi 3 e 4 (`p8 = p3` e `p9 = p4`).
  Di conseguenza, l'operazione - calcolata al passo 10 ha esattamente gli stessi operandi del passo 5: il nodo restituito sarà lo stesso (`p10 = p5`), chiudendo il ciclo di riutilizzo che forma il DAG.
]

=== Metodo del valore numerico per la costruzione di DAG
I nodi di un albero sintattico o di un DAG possono essere memorizzati in modo estremamente efficiente all'interno di un array di record. Ogni riga di questo array rappresenta un record e identifica univocamente un nodo.

In questa struttura:
- Il primo campo contiene un codice operativo (`op`) che indica l'etichetta del nodo (l'operatore o il tipo di foglia).
- Se il nodo è una foglia, l'array memorizza un campo aggiuntivo contenente il valore lessicale (ad esempio, un puntatore a un elemento della tabella dei simboli `entry` o una costante numerica).
- Se il nodo è interno, l'array contiene due campi aggiuntivi che memorizzano gli indici delle righe corrispondenti al figlio sinistro e al figlio destro.

#figure(image("images/2025-11-27-17-58-19.png"))

Nel diagramma (b) le foglie hanno un campo aggiuntivo contenente il valore lessicale (nel caso in esame un puntatore a un elemento della tabella dei simboli oppure una costante); i nodi interni hanno due campi aggiuntivi che rappresentano i figli sinistro e destro.

In questo array ci si riferisce ai nodi e alle sottoespressioni semplicemente mediante l'indice del record corrispondente. Storicamente, tale indice è chiamato *valore numerico* del nodo o dell'espressione che esso rappresenta. Per esempio, nel diagramma precedente, il nodo con etichetta + ha valore numerico 3 e i suoi figli sinistro e destro hanno rispettivamente valore numerico 1 e 2. Benché in pratica si utilizzino spesso puntatori ai record o riferimenti agli oggetti, si continua a usare il termine “valore numerico” per indicare i riferimenti a un nodo. Se memorizzati in una opportuna struttura dati, i valori numerici permettono di costruire il DAG di un'espressione in modo molto efficiente attraverso un algoritmo.

Supponiamo che i nodi siano memorizzati in un array, e ci si riferisca a essi mediante il loro valore numerico. Chiamiamo *signature* o *firma di un nodo interno* la tripla (`op,l,r`), in cui `op` è l'etichetta, `l` il valore numerico del figlio sinistro e `r` quello del figlio destro. Per un operatore unario possiamo assumere convenzionalmente che `r` = 0.

#[
  #set heading(numbering: none, outlined: false)
  === Metodo del valore numerico per la costruzione dei nodi di un DAG
]
*INPUT*: L'etichetta `op`, il nodo `l` e il nodo `r`. \
*OUTPUT*: Il valore numerico di un nodo nell'array con firma (`op,l,r`). \
*METODO*: Si cerchi nell'array un nodo *M* con etichetta `op`, figlio sinistro `l` e figlio destro `r`. Se un tale nodo esiste, si restituisca il valore numerico di *M*. Altrimenti si crei un nuovo nodo *N* con etichetta `op`, figlio sinistro `l`, figlio destro `r` e si restituisca il suo valore numerico.

//TODO: completare con miglioramenti dell'hash
Benché questo algoritmo produca il risultato desiderato, effettuare una ricerca sull'intero array ogni volta che si deve localizzare un nodo è molto costoso, specialmente se un singolo array contiene tutte le espressioni di un programma. Un metodo più efficiente si basa sull'uso di una tabella di hash, grazie alla quale i nodi sono raccolti in “gruppi”, ognuno dei quali avrà tipicamente pochi elementi.
Per costruire una tabella di hash per i nodi di un DAG, abbiamo bisogno di una funzione di hash che calcola l'indice del gruppo data una firma (`op,l,r`) in maniera tale da distribuire il più uniformemente possibile le firme nei vari gruppi, cioè in modo che sia improbabile che un gruppo contenga molti più nodi degli altri. L'indice del gruppo $h$(`op,l,r`) è calcolato in modo deterministico a partire da `op`, `l` e `r`, in modo da ottenere sempre lo stesso gruppo a partire da uno stesso nodo. Ogni gruppo può poi essere implementato mediante una lista, come mostrato nel diagramma.

#figure(image("images/2025-11-28-11-28-58.png"))

Un array, indicizzato in base al valore della funzione di hash, contiene i puntatori alle teste delle varie liste. Ogni elemento di una tale lista contiene poi il valore numerico di un nodo che, secondo la funzione di hash, appartiene al gruppo. Quindi, dato un nodo d'ingresso descritto da `op`, `l` e `r`, calcoliamo dapprima l'indice del gruppo $h$(`op,l,r`), quindi effettuiamo una ricerca del nodo richiesto all'interno della lista corrispondente al gruppo trovato. Se si ha corrispondenza, restituiamo il valore numerico $v$. Se non troviamo invece un tale nodo, siamo sicuri che esso non può trovarsi in nessun altro gruppo, per cui creiamo un nuovo elemento, lo aggiungiamo alla lista relativa al gruppo con indice $h$(`op,l,r`) e restituiamo il valore numerico associato al nuovo elemento.

== Codice a tre indirizzi
Il codice a tre indirizzi prevede al più un operatore nel lato destro di una istruzione. In altre parole, le espressioni aritmetiche composte non sono permesse. Secondo questa definizione, un'espressione in linguaggio sorgente come per esempio `x+y*z` potrebbe essere tradotta nella seguente sequenza di istruzioni a tre indirizzi:

- `t1 = y * z`
- `t2 = x + t1`

in cui `t1`e `t2` sono nomi temporanei generati dal compilatore. Il ricorso a nomi temporanei per memorizzare i valori intermedi calcolati da un dato programma rende il codice a tre indirizzi particolarmente semplice da riorganizzare.

#example()[
  Il codice a tre indirizzi è una rappresentazione lineare di un albero sintattico o di un DAG, in cui i nomi temporanei espliciti corrispondono ai nodi interni del grafo.
  #figure(image("images/2026-05-18-09-36-20.png"))
]

=== Indirizzi e istruzioni
Il codice a tre indirizzi si basa su due concetti fondamentali: gli *indirizzi* e le *istruzioni*. Un indirizzo può assumere una delle seguenti forme:
+ Un  nome
+ Una costante
+ Un nome temporaneo generato dal compilatore
Le istruzioni più comuni appaiono invece nelle seguenti forme:
+ Istruzioni di assegnamento del tipo `x = y op z`
+ Istruzioni di assegnamento del tipo `x = op z`
+ Istruzioni di copia del tipo `x = y`
+ Istruzioni di salto incondizionato del tipo `goto L`
+ Istruzioni di salto condizionato del tipo `if x goto L `oppure `ifFalse x goto L`
+ Istruzioni di salto condizionato del tipo `if x relop y goto L`
+ Chiamata di procedura e ritorno da procedura
+ Istruzioni di copia indicizzata del tipo `x = y[i]` oppure `x[i] = y`
+ Assegnamenti di puntatori e indirizzi del tipo `x = &y`,` r= * y` oppure `*x = y`.

#example()[
  Consideriamo il seguente statement: `do i = i+1; while (a[i] < v);`. Si possono avere due possibili traduzioni: nella prima si associa un'etichetta simbolica alla prima istruzione, nella seconda si utilizzano i numeri delle posizioni delle istruzioni.
  #figure(image("images/2025-11-28-12-05-56.png"))
]

=== Quadruple
La descrizione delle istruzioni a tre indirizzi specifica le varie componenti di ogni tipo di istruzione, ma non fornisce alcuna indicazione a proposito dell'implementazione dell'istruzione in un'opportuna struttura dati. In un compilatore reale le istruzioni possono essere implementate come oggetti o come record aventi opportuni campi per l'operatore e per gli operandi. Tre comuni rappresentazioni sono le “quadruple”, le “triple” e le “triple indirette” .

Una *quadrupla* o *quad* ha quattro campi che chiamiamo `op`, `arg1`, `arg2` e `result`. Il campo `op` contiene un codice interno che indica l'operatore. Per esempio, l'istruzione a tre indirizzi `x = y + z` è rappresentata assegnando `+` al campo `op`, `y` ad `arg1`, `z` ad `arg2`, e `x` a `result`.

Alcune eccezioni a questa regola generale sono:
+ Le istruzioni con operatori unari come `x = minusy` oppure istruzioni di copia come `x = y` non utilizzano `arg2`. Si noti inoltre che per le operazioni di copia `op` è l'operatore di assegnamento `=`, mentre per la maggior parte delle altre operazioni l'assegnamento è da considerarsi implicito.
+ Le istruzioni come `param` non usano né `arg2`, né `result`.
+ Le istruzioni di salto condizionato e incondizionato salvano l'etichetta in `result`.

#example()[
  II codice a tre indirizzi dell'assegnamento `a = b*-c + b*-c;` è mostrato nella che segue. L'operatore speciale `minus` è utilizzato per distinguere   il meno unario, come in `-b`, dall'operatore binario di sottrazione, come in `b - c`. Si noti che le istruzioni relative al meno unario, così come l'istruzione di copia `a = t5`, utilizzano solamente due dei tre indirizzi.
  #figure(image("images/2026-05-18-09-42-44.png"))
]


=== Triple
Una *tripla* è un record avente solamente i tre campi `op`, `arg1` e `arg2`.
Come si nota dalla Figura 6.10(b), il campo `result` è utilizzato principalmente da variabili temporanee. E' possibile e conveniente riferirsi al risultato di un'operazione `z op y` non mediante un nome temporaneo esplicito, bensì in modo indiretto mediante la posizione dell'operazione nella sequenza di codice. Sempre con riferimento alla figura (b), una rappresentazione mediante triple non farebbe riferimento alla variabile `t1` bensì alla posizione `(0)`. Secondo tale notazione, i numeri tra parentesi indicano puntatori alla struttura stessa di triple.

#example()[
  #figure(image("images/2025-11-30-21-30-33.png"))
  L'albero sintattico e le triple della figura corrispondono alle quadruple e al codice a tre indirizzi mostrato nella figura ancora precedente. Secondo la rappresentazione basata sulle triple della figura (b), l'istruzione di copia `a= t5` è codificata ponendo `a` nel campo `arg1` il valore numerico `(4)` nel campo `arg2`.
]

Uno dei vantaggi delle quadruple rispetto alle triple emerge considerando i compilatori ottimizzanti, in cui spesso le istruzioni vengono riorganizzate e spostate. Usando le quadruple, infatti, se spostiamo un'istruzione che calcola una variabile temporanea `t`, le istruzioni che utilizzano `t` non richiedono alcuna modifica. Usando le triple, invece, ci si riferisce al risultato di un'operazione mediante la sua posizione nel codice, perciò spostare un istruzione richiede una modifica a tutte le triple che fanno riferimento al risultato che questa calcola. Tale problema, tuttavia, può essere risolto grazie alle triple indirette.

Le *triple indirette* consistono in una lista di puntatori a triple, piuttosto che in una lista delle triple stesse. Possiamo per esempio usare un array _instruction_ per memorizzare i puntatori alle triple nell'ordine desiderato. In tal caso, le triple della Figura 6.11(b) potrebbero essere rappresentate come nella Figura 6.12.

#figure(image("images/2025-11-30-21-33-49.png"))

#example()[
  #figure(image("images/2025-11-30-21-34-05.png"))
]


== Tipi e dichiarazioni
L'uso dei tipi ha diversi obiettivi, raggruppabili in due classi.
- *Controllo di tipo* o *type checking*: analizzare staticamente quello che sarà il comportamento del programma. Analisi che garantisce che i tipi degli operandi siano adatti all'operazione.
- *Traduzione*: in baso al tipo di un nome, il compilatore può determinare lo spazio di memoria necessario a run-time per l'oggetto a il cui nome si riferisce. Inoltre, le informazioni di tipo sono necessarie per calcolare l'indirizzo relativo a un elemento di un array, per realizzare opportune conversioni di tipo, per selezionare la versione corretta di ogni operatore aritmetico e molto altro ancora.

Vedremo i tipi e l'organizzazione della memoria per i nomi dichiarati all'interno di una procedura o di una classe.

=== Espressioni di tipo
I tipi hanno una struttura ben precisa che noi rappresenteremo mediante le *espressioni di tipo* o *type expression*. Una espressione di tipo può essere un tipo di base oppure può essere costruita applicando un operatore detto costruttore di tipo a un'espressione di tipo.

- Un tipo di base è un'espressione di tipo. I classici tipi di base per molti linguaggi sono boolean, char, integer, float e void;

- Un nome di tipo é un'espressione di tipo.

- Un'espressione di tipo pud essere costruita applicando il costruttore di tipo array a un intero e a un'espressione di tipo.

- Un record è una struttura dati composta da campi aventi un nome. Una espressione di tipo può essere in questo caso ottenuta applicando il costruttore di tipo record ai nomi dei campi e ai loro tipi.

- Un'espressione può essere ottenuta applicando il costruttore di tipo $->$ relativo ai tipi delle funzioni. Scriviamo $s -> t$ per indicare una funzione dal tipo $s$ (tipo degli argomenti) al tipo $t$ (tipo del valore restituito).

- Se $s$ e $t$ sono espressioni di tipo, anche il loro prodotto cartesiano $s times t$ è un'espressione di tipo.

- Le espressioni di tipo possono contenere variabili i cui valori sono altre espressioni di tipo.

#example()[
  Il tipo array `int[2][3]` può essere interpretato come “array di 2 array, ognuno di tre interi” e descritto mediante l'espressione di tipo _array(2, array(3, integer))_. L'operatore array richiede due operandi: un numero intero e un tipo.
  #figure(image("images/2026-05-18-09-55-48.png"))
]

=== Equivalenza di tipo
Se rappresentate mediante grafi, due espressioni di tipo sono strutturalmente equivalenti se e solo se sono soddisfatte le tre condizioni seguenti:
+ Sono lo stesso tipo di base.
+ Sono ottenute applicando lo stesso costruttore di tipi a espressioni di tipo strutturalmente equivalenti.
+ Una è un nome di tipo che indica l'altra.

Due espressioni di tipo sono equivalenti per *nome* se e solo se sono soddisfatte le seguenti due condizioni:
+ Sono lo stesso tipo di base.
+ Sono ottenute applicando lo stesso costruttore a espressioni equivalenti per nome a 2 a 2.

=== Dichiarazioni
Studieremo i tipi e le dichiarazioni di tipo utilizzando una grammatica semplificata che dichiara un solo nome alla volta. La grammatica semplificata è
la seguente:
#figure(image("images/2026-05-18-10-02-36.png"))

=== Organizzazione della memoria per i nomi locali
Il tipo di un nome determina la quantità di memoria necessaria a runtime per memorizzare valori associati a quel nome. Il compilatore usa il tipo per assegnare indirizzi relativi (nello heap risiedono oggetti memorizzati dinamicamente come liste o variabili locali nello stack).

Con _larghezza_ di un tipo si fa riferimento al numero di byte necessari per un oggetto di quel tipo:
- I tipi richiedono un numero intero di byte.
- Per semplificare l'accesso, l'organizzazione della memoria relativa ai tipi aggregati prevede un'allocazione continua in un unico blocco.

L'SDT seguente viene utilizzato per calcolare il tipo e la relativa larghezza per i tipi di base e gli array.
#figure(image("images/2026-05-18-10-38-58.png"))

#example()[
  Le linee tratteggiate della Figura 6.16 mostrano l'albero di parsing relativo al tipo `int[2][3]`. Le linee continue, invece, mostrano come le informazioni di tipo e larghezza siano propagate dapprima da B alla sequenza discendente di $C$, attraverso le variabili `t` e `w`, e poi, all'indietro, risalendo la sequenza di $C'$ attraverso gli attributi i sintetizzati _type_ e _width_.
  #figure(image("images/2026-05-18-10-39-19.png"))
]

=== Sequenze di dichiarazioni
Nei linguaggi come C o Java, le dichiarazioni all'interno di una procedura (o blocco) vengono analizzate sequenzialmente. Questo permette al compilatore di assegnare facilmente un indirizzo di memoria relativo a ogni variabile, utilizzando una singola variabile di stato chiamata `offset`. La variabile `offset` tiene traccia della prossima locazione di memoria disponibile all'interno del blocco. Parte da 0 e, ogni volta che viene dichiarata una nuova variabile, le viene assegnato l'`offset` corrente; dopodiché, l'`offset` viene incrementato della dimensione (larghezza) del tipo della variabile appena dichiarata.

Lo schema di traduzione seguente gestisce una sequenza di dichiarazioni del tipo `T id;`. L'oggetto `top` rappresenta la Tabella dei Simboli (Symbol Table) del blocco corrente.

#align(center)[
  #table(
    stroke: none,
    columns: (10em, 24em),
    align: left,
    table.hline(start: 0),
    table.header([*Produzione*], [*Azioni Semantiche (SDT)*]),
    table.hline(start: 0),
    [$P -> D$], [{ $text("offset") = 0;$ }],
    [$D -> T text("id") ;$],
    [
      { \
      $quad text("top.put")(text("id")."lexeme", T."type", text("offset"));$ \
      $quad text("offset") = text("offset") + T."width";$ \
      }
    ],
    [$D -> D_1$], [],
    table.hline(start: 0),
  )
]

+ Prima di iniziare ad analizzare la lista di dichiarazioni $D$, l'azione associata al programma $P$ inizializza l'`offset` a 0.
+ Per ogni dichiarazione trovata ($T text("id") ;$), l'identificatore (`id.lexeme`) viene salvato nella tabella dei simboli tramite `top.put()`, associandogli il suo tipo ($T."type"$) e il suo indirizzo di memoria relativo ($text("offset")$).
+ L'`offset` viene subito aggiornato sommandogli la dimensione in byte richiesta dal tipo appena dichiarato ($T."width"$), preparandolo per la variabile successiva.

#observation()[
  Come visto nei capitoli precedenti, posizionare l'azione di inizializzazione `{ offset = 0; }` prima dell'espansione di $D$ nella regola $P -> { text("offset") = 0; } D$ crea problemi ai parser LR, che eseguono le riduzioni solo alla fine della regola.

  Per trasformare questo schema in uno *SDT postfisso*, introduciamo un non-terminale marcatore $M$:

  $
    & P -> M D \
    & M -> epsilon quad { text("offset") = 0; }
  $

  In questo modo, il parser esegue l'inizializzazione in modo sicuro non appena riduce la produzione vuota $M -> epsilon$, mantenendo tutte le azioni rigorosamente alla fine dei corpi delle produzioni.
]

=== Campi nei record e nelle classi

La traduzione delle sequenze di dichiarazioni ci porta naturalmente al problema della gestione dei campi all'interno dei record e delle classi. Il tipo _record_ può facilmente essere aggiunto alla grammatica di base grazie alla seguente nuova produzione:

$
  T -> text("record") \{ D \}
$

I campi in una tale dichiarazione di record sono specificati dalla sequenza di dichiarazioni interne generate dal non-terminale $D$. L'approccio basato sulla variabile `offset` visto in precedenza può essere esteso per calcolare anche i tipi e gli indirizzi relativi dei campi interni, a patto che siano rigorosamente soddisfatte due condizioni:
- I nomi dei campi all'interno di uno stesso record devono essere tutti distinti (cioè ogni nome può apparire una sola volta nelle dichiarazioni generate da $D$).
- Lo *spiazzamento* (`offset`), cioè l'indirizzo relativo, è calcolato rispetto all'indirizzo di base dello specifico record (ovvero, l'offset riparte temporaneamente da 0 quando si entra nel record).

#example()[
  L'uso di un nome `x` per indicare un campo interno di un record non entra in conflitto con altri usi dello stesso nome al di fuori del record (o in record diversi). I tre usi di `x` nelle seguenti dichiarazioni, quindi, sono logicamente distinti e non creano alcun conflitto nella tabella dei simboli:

  ```c
    float x;
    record { float x; float y; } p;
    record { int tag; float x; float y; } q;
  ```

  Un successivo assegnamento come `x = p.x + q.x;` assegna alla variabile `x` (globale) il risultato della somma tra i campi di nome `x` contenuti rispettivamente nei record `p` e `q`. Si noti inoltre che l'indirizzo relativo (l'offset in byte) del campo `x` nel record `p` differisce da quello di `x` nel record `q` (poiché in `q` è preceduto da un `int`).
]

Per gestire correttamente i record, il compilatore deve sospendere temporaneamente l'ambiente globale, creare un "sotto-ambiente" ripartendo da offset = 0, e poi ripristinare tutto alla fine. Questo si realizza utilizzando due stack di supporto: uno per gli ambienti (`Env`) e uno per gli indirizzi (`Stack`).

#figure(image("images/2026-05-18-10-52-43.png"))

== Traduzione delle espressioni
Vediamo ora la traduzione delle espressioni e delle istruzioni. Iniziamo qui con la traduzione delle espressioni in codice a tre indirizzi. Una espressione, come `a+b*c`, contenente più di un operatore sarà tradotta in istruzioni a tre indirizzi, ognuna contenente un solo operatore. Un riferimento a un elemento di un array, come `A[i][j]` sarà espansa in una sequenza di più istruzioni a tre indirizzi che calcolano l'indirizzo dell'elemento specificato.

=== Operazioni nelle espressioni
#figure(image("images/2025-12-02-17-15-13.png"))
La definizione guidata dalla sintassi mostrata sopra costruisce il codice a tre indirizzi di un'istruzione di assegnamento $S$ facendo ricorso all'attributo `"code"` di $S$ e agli attributi `"code"` e `"addr"` dell'espressione denotata da $E$. Gli attributi $S."code"$ ed $E."code"$ indicano il codice a tre indirizzi relativo rispettivamente a $S$ ed $E$. L'attributo $E."addr"$, invece, indica l'indirizzo della locazione di memoria che conterrà il valore di $E$. Si tenga presente che, come già visto, un indirizzo può essere un nome, una costante oppure una variabile temporanea generata dal compilatore. Si consideri l'ultima produzione $E -> text("id")$ della SDD.

Quando un'espressione coincide con un singolo identificatore $x$, $x$ stesso contiene il valore dell'espressione. Per questa ragione, la regola semantica associata a tale produzione assegna all'attributo $E."addr"$ il puntatore all'elemento della tabella dei simboli che si riferisce alla specifica occorrenza di `id`. Se `top` indica la tabella dei simboli corrente, la funzione `top.get()` restituisce l'elemento della tabella dei simboli individuato in base alla stringa `id.lexeme` relativa all'istanza di `id` in esame. All'attributo $E."code"$ viene invece assegnata la stringa vuota.

Quando invece si considera la produzione $E -> ( E_1 )$, la traduzione di $E$ coincide con quella della sottoespressione $E_1$, pertanto $E."addr"$ prende il valore di $E_1."addr"$ ed $E."code"$ prende il valore di $E_1."code"$. I due operatori di somma ($+$) e di negazione (cioè il $-$ unario) sono rappresentativi della maggioranza degli operatori nei comuni linguaggi di programmazione. Le regole semantiche associate alla produzione $E -> E_1 + E_2$ generano il codice per calcolare il valore di $E$ a partire dai valori di $E_1$ e $E_2$. Il risultato è assegnato a una nuova variabile temporanea generata dal compilatore. Se il valore di $E_1$ è assegnato a $E_1."addr"$ ed $E_2$ a $E_2."addr"$, allora $E_1 + E_2$ viene tradotto come $t = E_1."addr" + E_2."addr"$, in cui $t$ è un nuovo nome temporaneo. Infine, il valore di $t$ viene assegnato a $E."addr"$. Si noti che esecuzioni successive dell'istruzione `new Temp()` producono una sequenza di nomi temporanei $t_1, t_2, dots$ tutti distinti.

Per comodità usiamo la notazione `gen(x '=' y '+' z)` per indicare l'istruzione a tre indirizzi $x = y + z$. Eventuali espressioni che dovessero apparire al posto delle variabili $x$, $y$ e $z$ sarebbero valutate prima di essere passate alla funzione `gen()`; le stringhe tra apici, invece, sono interpretate letteralmente.

Altre istruzioni a tre indirizzi sono costruite in modo simile, applicando la funzione `gen()` a una combinazione di espressioni e stringhe costanti. Le regole di traduzione associate alla produzione $E -> E_1 + E_2$ costruiscono $E."code"$ concatenando $E_1."code"$, $E_2."code"$ e un'istruzione che somma i valori di $E_1$ ed $E_2$. Tale istruzione assegna il risultato della somma a un nuovo nome temporaneo associato a $E$ e indicato da $E."addr"$. La traduzione della produzione $E -> - E_1$ è simile. Le regole semantiche dapprima creano un nuovo nome temporaneo per $E_1$, quindi generano un'istruzione che esegue l'operazione di negazione (meno unario). Infine, la produzione $S -> text("id") = E;$ genera le istruzioni che assegnano il valore dell'espressione $E$ all'identificatore `id`. Le regole semantiche associate a questa produzione utilizzano la funzione `top.get()` per determinare l'indirizzo dell'identificatore rappresentato da `id`, esattamente come già visto per la produzione $E -> text("id")$. Il valore dell'attributo $S."code"$ consiste delle istruzioni per calcolare il valore di $E$ e assegnarlo all'indirizzo indicato da $E."addr"$, seguite da un assegnamento all'indirizzo restituito dalla funzione `top.get(id.lexeme)` e relativo alla specifica istanza di `id` in esame.

#example()[
  La definizione guidata dalla sintassi traduce l'assegnamento `a = b + - c;` nella seguente sequenza di codice a tre indirizzi:
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
Come sappiamo, gli attributi che rappresentano codice possono essere stringhe di notevoli dimensioni. Per questa ragione, tali stringhe sono solitamente generate in modo incrementale. Quindi, invece di costruire $E."code"$ secondo le regole riportate nella SDD precedente, possiamo fare in modo di generare solamente le *nuove* istruzioni a tre indirizzi, secondo lo schema di traduzione (SDT) seguente.

#figure(image("images/2026-05-18-10-58-10.png"))

Secondo un approccio incrementale, la funzione `gen()` non solo costruisce un'istruzione a tre indirizzi, ma aggiunge anche tale istruzione alla sequenza di istruzioni generata fino a quel punto. La sequenza può essere sia mantenuta in memoria per una eventuale elaborazione successiva, sia stampata incrementalmente (come output su file).

Lo schema di traduzione appena visto genera esattamente lo stesso codice prodotto dalla definizione guidata dalla sintassi precedente. Seguendo l'approccio incrementale, *l'attributo `code` diventa superfluo* poiché la sequenza di istruzioni generata da chiamate successive alla funzione `gen()` è unica. Per esempio, l'azione semantica relativa alla produzione $E -> E_1 + E_2$ richiama la funzione `gen()` per generare solamente l'istruzione di somma, poiché le istruzioni che calcolano $E_1$ (e assegnano il risultato a $E_1."addr"$) e quelle che calcolano $E_2$ (e assegnano il risultato a $E_2."addr"$) sono già state generate in precedenza.

L'approccio presentato può essere utilizzato anche per la costruzione di alberi sintattici. In tal caso, l'azione semantica relativa alle varie produzioni creerebbe un nuovo nodo utilizzando il costruttore `Node()`. Tali azioni avrebbero la forma seguente:

#align(center)[
  #table(
    stroke: none,
    columns: (10em, 24em),
    align: left,
    [$S -> text("id") = E ;$], [{ $S."addr" = text("new Node")('=', text("id"), E."addr");$ }],
    [$E -> E_1 + E_2$], [{ $E."addr" = text("new Node")('+', E_1."addr", E_2."addr");$ }],
    [$E -> - E_1$], [{ $E."addr" = text("new Node")(text("'minus'"), E_1."addr");$ }],
  )
]

in cui l'attributo `"addr"` rappresenta l'indirizzo di un nodo in memoria e non quello di una variabile temporanea o di una costante.

=== Indirizzamento degli elementi di un array

È possibile accedere in modo semplice agli elementi di un array se questi sono memorizzati in un blocco di locazioni di memoria contigue. In C e in Java gli elementi di un array di dimensione $n$ sono numerati da $0$ a $n-1$. Se la larghezza di ogni elemento è pari a $w$, allora l'$i$-esimo elemento dell'array inizia alla locazione di memoria:

$
  text("base") + i times w quad quad (6.2)
$

in cui `base` è l'indirizzo relativo dell'inizio della zona di memoria riservata all'array. In altre parole, `base` coincide con l'indirizzo dell'elemento $A[0]$.

L'Equazione (6.2) può essere generalizzata al caso degli array multidimensionali. Per gli array a due dimensioni, in C e in Java indichiamo con $A[i_1][i_2]$ l'elemento in posizione $i_2$ nella riga $i_1$. Indicando con $w_1$ la larghezza di una riga e con $w_2$ quella di un elemento della riga, l'indirizzo relativo dell'elemento $A[i_1][i_2]$ è dato dalla relazione:

$
  text("base") + i_1 times w_1 + i_2 times w_2 quad quad (6.3)
$

In $k$ dimensioni la relazione diviene:

$
  text("base") + i_1 times w_1 + i_2 times w_2 + dots + i_k times w_k quad quad (6.4)
$

in cui $w_j$, per $1 <= j <= k$, è la generalizzazione delle dimensioni $w_1$ e $w_2$ dell'Equazione (6.3).

In $k$ dimensioni, la seguente formula produce come risultato lo stesso indirizzo calcolato dall'Equazione (6.4):

$
  text("base") + ((dots ((i_1 times n_2 + i_2) times n_3 + i_3) dots ) times n_k + i_k) times w quad quad (6.6)
$

Entrambe le espressioni (6.2) e (6.6) possono essere riscritte nella forma $i times w + c$, in cui la sottoespressione $c = text("base") - text("low") times w$ è costante e può essere precalcolata a compile-time. Si noti che quando $text("low") = 0$ risulta $c = text("base")$.

I calcoli degli indirizzi visti fino a questo punto assumono che gli array siano organizzati "per righe", come accade in C e in Java. Un array bidimensionale normalmente è memorizzato per righe oppure per colonne. La Figura 6.21 mostra l'organizzazione della memoria nel caso di un array $A$ di dimensione $2 times 3$ ordinato per righe e per colonne. L'organizzazione per colonne è comune nei linguaggi appartenenti alla famiglia del Fortran.

#figure(image("images/2025-12-02-17-17-25.png"))

=== Traduzione dei riferimenti ad array

Il problema principale nella generazione del codice per i riferimenti agli elementi di un array consiste nel correlare i calcoli dell'indirizzo visti nel Paragrafo 6.4.3 alla grammatica corrispondente. Sia $L$ un non-terminale che genera un nome di array seguito da una sequenza di espressioni per gli indici:

$
  L -> L [ E ] | text("id") [ E ]
$

Come per il C e per Java, assumiamo che l'indice del primo elemento di un array sia 0, e procediamo al calcolo degli indirizzi sulla base delle larghezze, cioè mediante l'Equazione (6.4), piuttosto che in base al numero di elementi come nell'Equazione (6.6). Lo schema di traduzione della Figura 6.22 genera codice a tre indirizzi per espressioni contenenti anche riferimenti ad array. Tale SDT consiste delle produzioni e azioni semantiche già introdotte nella Figura 6.20, più le nuove produzioni relative al non-terminale $L$.

Il non-terminale $L$ ha tre attributi sintetizzati:
+ $L."addr"$ indica un indirizzo temporaneo utilizzato per il calcolo dello spiazzamento del riferimento all'array che prevede la somma dei vari termini $i_j times w_j$.
+ $L."array"$ è un puntatore all'elemento della tabella dei simboli relativo al nome dell'array. L'indirizzo di base dell'array, indicato per esempio da $L."array"."base"$, è utilizzato per calcolare l'l-value effettivo di un riferimento ad array una volta che tutte le espressioni relative agli indici siano state analizzate.
+ $L."type"$ è il tipo del sotto-array generato da $L$. Per qualsiasi tipo $t$ assumiamo che $t."width"$ ne fornisca la larghezza. Utilizziamo i tipi e non le larghezze come attributi, poiché questi sono comunque richiesti per il controllo dei tipi. Supponiamo inoltre che $t."elem"$ indichi il tipo degli elementi dell'array $t$.

La produzione $S -> text("id") = E ;$ rappresenta un assegnamento a una variabile scalare (cioè non di tipo array) ed è trattata come di consueto. L'azione semantica relativa alla produzione $S -> L = E ;$ genera un'istruzione di copia indicizzata che assegna il valore indicato dell'espressione $E$ alla locazione di memoria denotata dal riferimento ad array $L$.

Si ricordi che l'attributo $L."array"$ indica l'elemento della tabella dei simboli relativo all'array e che l'indirizzo della base dell'array — cioè l'indirizzo dell'elemento con indice 0 — è dato da $L."array"."base"$. Dato che $L."addr"$ indica la variabile temporanea che contiene lo spiazzamento del riferimento all'array generato da $L$, la locazione di memoria dell'elemento in esame è data da $L."array"."base"[L."addr"]$.

#figure(image("images/2025-12-02-17-17-53.png"))

L'istruzione generata pertanto copia l'r-value dell'indirizzo $E."addr"$ nella locazione di memoria di $L$.

Le produzioni $E -> E_1 + E_2$ e $E -> text("id")$ sono le stesse già studiate. L'azione semantica relativa alla nuova produzione $E -> L$ genera il codice necessario per copiare il valore dalla locazione denotata da $L$ in una variabile temporanea. Tale locazione è $L."array"."base"[L."addr"]$, come appena visto per la produzione $S -> L = E ;$. Anche in questo caso $L."array"$ indica il nome dell'array, $L."array"."base"$ l'indirizzo della base e $L."addr"$ indica una variabile temporanea contenente lo spiazzamento dell'elemento in esame. Il codice a tre indirizzi generato copia l'r-value della locazione specificata da base e spiazzamento in una nuova variabile temporanea indicata da $E."addr"$.

#example()[
  Sia `a` un array di interi di dimensione $2 times 3$ e siano `c`, `i` e `j` tre variabili intere. Il tipo di `a` è dunque `array(2, array(3, integer))` e la sua larghezza, assumendo che la larghezza di un intero sia 4, è pari a 24. Il tipo di `a[i]` è `array(3, integer)` e la sua larghezza $w_i = 12$. Il tipo di `a[i][j]` è infine `integer`.

  La Figura 6.23 mostra un albero di parsing annotato relativo all'espressione `c + a[i][j]`. Tale espressione viene tradotta nel codice a tre indirizzi riportato nella Figura 6.24, in cui abbiamo utilizzato, come di consueto, i nomi dei simboli per riferirci ai corrispondenti elementi nella tabella dei simboli.

  #figure(image("images/2025-12-02-17-18-18.png"))
  #figure(image("images/2025-12-02-17-18-37.png"))

  #align(center, block(
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
  ))
]

//10.12.2025
== Controllo dei tipi

Per poter effettuare il controllo dei tipi un compilatore deve dapprima assegnare un'espressione di tipo a ogni componente del programma sorgente per poi procedere a verificare che tali espressioni siano conformi rispetto a un insieme di regole logiche comunemente detto _type system_ di un linguaggio.
Il controllo dei tipi può portare all'individuazione di errori nel programma. In linea di principio, tutti i controlli di tipo possono essere effettuati a run-time a patto che il codice generato conservi non solo il valore di ogni elemento, ma anche il suo tipo. Un type system solido elimina la necessità di effettuare controlli dinamici di errori di tipo poiché è in grado di stabilire a livello statico (compile-time) che quegli errori non si potranno verificare durante l'esecuzione. Si dice che l'implementazione di un linguaggio è *fortemente tipizzata* se il compilatore garantisce che i programmi che accetta potranno essere eseguiti senza che si verifichino errori di tipo.


=== Regole per il controllo dei tipi

Il controllo dei tipi può assumere due forme: *sintesi* e *inferenza*. La sintesi dei tipi prevede la costruzione di un tipo di un'espressione a partire dal tipo delle sue sotto-espressioni. Tale approccio richiede che tutti i nomi siano dichiarati prima di poter essere utilizzati. Il tipo di un'espressione come $E_1 + E_2$ è definito in base al tipo di $E_1$ e a quello di $E_2$. Una tipica regola che si incontra nella sintesi dei tipi ha la forma:

#algo()[
  *if* $f$ è di tipo $s -> t$ *and* $x$ è di tipo $s$, \
  *then* l'espressione $f(x)$ è di tipo $t$
]

In questa regola, che si riferisce a funzioni con un solo argomento, $f$ e $x$ indicano espressioni e la scrittura $s -> t$ indica una funzione da $s$ a $t$.

L'inferenza di tipo determina il tipo di un costrutto del linguaggio in base al modo in cui esso è utilizzato. Sia `null()` una funzione che verifica se una lista è vuota. In tal caso, in base a un suo utilizzo nella forma `null(x)` possiamo concludere che $x$ deve essere una lista. Il tipo degli elementi della lista, tuttavia, non è noto; al momento si può soltanto stabilire che $x$ è una lista di elementi di tipo ignoto.

#observation()[
  Useremo le lettere greche $alpha, beta$ e così via, per indicare variabili di tipo nelle espressioni di tipo.
]

Una tipica regola per l'inferenza di tipo ha la forma seguente:

#algo()[
  *if* $f(x)$ è un'espressione, \
  *then* per qualche $alpha$ e $beta$, $f$ è di tipo $alpha -> beta$ *and* $x$ è di tipo $alpha$
]

Considereremo il controllo dei tipi delle espressioni, ma le regole per il controllo degli statement sono simili. Per esempio, interpreteremo il costrutto `if (`$E$`)` $S;$ come se si trattasse dell'applicazione di una funzione `if()` agli operandi $E$ ed $S$. Indichiamo inoltre con il tipo speciale `void` l'assenza di un valore. In conclusione, quindi, possiamo dire che lo statement condizionale `if` può essere visto come una funzione `if()` che richiede un argomento di tipo `boolean` e uno di tipo `void` e restituisce il tipo `void`.

=== Conversioni di tipo

Consideriamo l'espressione $x + i$ in cui $x$ è di tipo floating-point mentre $i$ è di tipo intero. Dato che la rappresentazione di valori interi e valori floating-point è diversa e che le operazioni su interi o su valori floating-point richiedono istruzioni macchina diverse, un compilatore dovrà provvedere alla conversione di uno dei due operandi dell'operatore $+$ in modo da assicurare che essi abbiano lo stesso tipo quando la somma avviene effettivamente. Supponiamo che i valori interi siano convertiti in valori floating-point. Nel codice dell'espressione $2 * 3.14$, per esempio, il valore intero 2 viene convertito in virgola mobile:

#align(center, block(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  [
    `t1 = (float) 2` \
    `t2 = t1 * 3.14`
  ],
))

Illustreremo la sintesi dei tipi estendendo lo schema di traduzione relativo alle espressioni. A tale scopo aggiungiamo il nuovo attributo $E."type"$, il cui valore può essere `integer` oppure `float`. La regola associata alla produzione $E -> E_1 + E_2$ richiede l'aggiunta dello pseudocodice:

#algo()[
  *if* ($E_1."type" == text("integer")$ *and* $E_2."type" == text("integer")$) $E."type" = text("integer")$, \
  *else if* ($E_1."type" == text("float")$ *and* $E_2."type" == text("integer")$) $dots$ \
  $dots$
]

All'aumentare del numero dei tipi, il numero dei casi da considerare cresce molto rapidamente.

#figure(image("images/2025-12-10-17-43-38.png"))
[Image of type widening and narrowing conversions hierarchy diagram]

Le regole di conversione di tipo variano da linguaggio a linguaggio. Le regole di conversione per il linguaggio Java riportate nella Figura 6.25 distinguono due casi:
- *Conversioni con ampliamento* o promozioni (*widening*), che hanno lo scopo di preservare l'informazione intatta.
- *Conversioni con restrizione* o demozioni (*narrowing*), che possono portare invece a una perdita di informazione.

Le regole di promozione sono date dalla gerarchia della Figura 6.25(a): ogni tipo può essere promosso a un tipo più in alto nella gerarchia. Per

=== Sovraccaricamento di funzioni e operatori
Un simbolo *sovraccaricato* (*overloaded*) ha diversi significati a seconda del contesto in cui si trova. Si dice che il sovraccaricamento viene _risolto_ quando si assegna un significato univoco a ogni occorrenza di un nome.
Una possibile regola per la sintesi del tipo di funzioni sovraccaricate é la seguente:
#algo()[
  *if* $f$ può essere di tipo $s_i->t_i$, per $1 lt.eq i lt.eq n$, con $s_i eq.not s_j$ per $i eq.not j$\
  *and* $x$ è di tipo $s_k$, per qualche valore di $k$ tale che $1 lt.eq k lt.eq n$ \
  *then* l'espressione $f(x)$ è di tipo $t_k$
]
Il metodo del valore numerico può essere applicato a espressioni di tipo per risolvere efficientemente il problema del sovraccaricamento sulla base del tipo degli argomenti. L'ipotesi di poter risolvere il sovraccaricamento di una funzione sulla base del tipo dei soli argomenti equivale all'ipotesi di poter risolvere il sovraccaricamento in base alla firma delle funzioni. Non sempre, tuttavia, l'analisi del tipo dei soli argomenti è sufficiente a risolvere il sovraccaricamento di una funzione.

=== Inferenza del tipo e funzioni polimorfiche
L'inferenza del tipo è utile nel caso di linguaggi come ML, che pur essendo fortemente tipizzato, non richiede di dichiarare i nomi prima dell'uso. L'inferenza di tipo assicura che i nomi siano usati in modo consistente. Il termine *polimorfico* indica in generale un qualsiasi frammento di codice che possa essere eseguito con argomenti di diversi tipi. In questo paragrafo considereremo il polimorfismo parametrico, cioe quel tipo di polimorfismo caratterizzato da parametri o da variabili di tipo. A tale scopo ci riferiremo al programma in linguaggio ML che definisce la funzione _length_():
#align(center, [
  ```ML
  fun length() = if null(x) then 0 else length(tl(x)) + 1;
  ```
])
La funzione _length_() calcola la lunghezza di una lista $x$, cioè il numero di elementi in $x$. Tutti gli elementi di una lista devono avere lo stesso tipo, ma la funzione in esame può essere applicata a liste di elementi di un tipo qualsiasi. Nell'espressione che segue la funzione _length_() è applicata a due tipi diversi di liste (gli elementi di una lista sono racchiusi tra parentesi quadre):
#align(center, [
  _length_([`"sun", "mon", "tue"`]) + _length_([10, 9, 8, 7])
])
La lista di stringhe ha lunghezza pari a 3, quella di interi ha lunghezza pari a 4, quindi l'espressione assume valore 7.

Ricorrendo al simbolo $forall$ (per ogni) e al costruttore di tipo _list_, possiamo scrivere il tipo della funzione _length_() come:
$
  forall alpha".list"(alpha) -> "integer"
$
Il simbolo $forall$ è il quantificatore universale e la variabile alla quale è applicato si dice legata a esso. Una variabile legata può essere rinominata liberamente, a patto di rinominare tutte le sue occorrenze. Informalmente, quando in una espressione di tipo compare il simbolo $forall$, parleremo di "*tipo polimorfico*".

#example()[
  #figure(image("images/2025-12-10-18-28-22.png"))
  Questo albero sintattico astratto rappresenta la definizione della funzione _length()_ fornita precedentemente. La radice dell'albero con etichetta *fun* rappresenta la definizione della funzione. I rimanenti nodi interni possono essere visti come applicazioni di funzioni.  Possiamo inferire il tipo della funzione length() a partire dal suo corpo. Consideriamo i figli del nodo con etichetta *if*, presi da sinistra a destra. Dato che la funzione _null_() si aspetta di essere applicata a una lista, $x$ deve essere una lista. Indicando con la variabile $alpha$ il tipo degli elementi della lista, il tipo di $x$ è “lista di $alpha$”. Se _null_($x$) è vera allora _length_($x$) vale 0. Pertanto il tipo di _length_() deve essere “funzione da una lista di $alpha$ a un intero”. Tale valore per il tipo inferito della funzione è anche consistente con la parte di definizione.
]

//11.12.2025
Dato che nelle espressioni di tipo possono comparire variabili, è necessario prendere nuovamente in esame il concetto di equivalenza tra tipi.

Supponiamo di applicare $E_1$ di tipo $s -> s_2$ a $E_2$, di tipo $t$. Invece di determinare semplicemente l'uguaglianza tra $s$ e $t$, dobbiamo *unificarli*, cioè verificare se è possibile rendere i tipi $s$ e $t$ strutturalmente equivalenti sostituendo le variabili di tipo in $s$ e $t$ con espressioni di tipo.

Una *sostituzione* è un mapping tra variabili di tipo ed espressioni di tipo. La scrittura $S(t)$ indica il risultato dell'applicazione della sostituzione $S$ alle variabili dell'espressione di tipo $t$ (si veda il box “Sostituzioni, istanze e unificazione”).

Due espressioni di tipo $t_1$ e $t_2$ possono essere unificate se esiste una sostituzione $S$ tale che $S(t_1) = S(t_2)$. In pratica siamo interessati all'*unificatore più generale* possibile, ovvero vogliamo individuare la sostituzione che impone il minor numero di vincoli sulle variabili di tipo delle espressioni in questione.

#[
  #set heading(numbering: none, outlined: false)
  === Sostituzioni, istanze e unificazione
]

Se $t$ è un'espressione di tipo e $S$ una sostituzione (cioè un mapping tra variabili di tipo ed espressioni di tipo), la scrittura $S(t)$ indica il risultato che si ottiene sostituendo tutte le occorrenze di ogni variabile di tipo $alpha$ con $S(alpha)$. Chiamiamo $S(t)$ una *istanza* di $t$.

Per esempio, `list(integer)` è un'istanza di `list(`$alpha$`)` poiché è il risultato della sostituzione di $alpha$ con `integer` nell'espressione `list(`$alpha$`)`. Il tipo `integer` $->$ `float`, invece, non è un'istanza di $alpha -> alpha$ poiché una sostituzione prevede che ogni occorrenza di una data variabile di tipo sia rimpiazzata rigorosamente dalla *stessa* espressione di tipo.

Diciamo poi che la sostituzione $S$ è un *unificatore* delle espressioni di tipo $t_1$ e $t_2$ se risulta $S(t_1) = S(t_2)$.

Inoltre, diciamo che $S$ è l'*unificatore più generale* di $t_1$ e $t_2$ se per qualsiasi altro unificatore $S'$ di $t_1$ e $t_2$ e per qualsiasi espressione di tipo $t$, $S'(t)$ è un'istanza di $S(t)$. In altre parole, $S'$ impone su $t$ vincoli più stringenti di quanto non faccia $S$.

#[
  #set heading(numbering: none, outlined: false)
  === Algoritmo di inferenza di tipo per le funzioni polimorfiche
]

*INPUT*: Un programma consistente in una sequenza di definizioni di funzione seguita da un'espressione da valutare. Tale espressione è costituita da applicazioni delle funzioni e nomi che possono avere tipi polimorfici predefiniti. \
*OUTPUT*: Tipi inferiti dei nomi che appaiono nel programma.

L'idea di base dell'algoritmo consiste nello scorrere le definizioni di funzione e l'espressione nel programma d'ingresso e nell'utilizzare il tipo già inferito di una funzione ogniqualvolta questo appare in un'espressione successiva.

- Per una definizione di funzione della forma $text("fun") quad text("id")_1(text("id")_2) = E$, si creano due nuove variabili di tipo $alpha$ e $beta$. Quindi si associa alla funzione $text("id")_1$ il tipo $alpha -> beta$ e al parametro $text("id")_2$ il tipo $alpha$. Quindi si inferisce un'espressione di tipo per $E$. Supponiamo che, dopo l'inferenza, $alpha$ denoti il tipo $s$ e $beta$ il tipo $t$. Ne risulta che il tipo inferito per la funzione $text("id")_1$ è $s -> t$. Ciò fatto, si legano mediante il quantificatore $forall$ tutte le variabili rimaste non vincolate.

- Per l'applicazione di una funzione $E_1(E_2)$, si inferiscono i tipi di $E_1$ ed $E_2$. Dato che $E_1$ è utilizzato come funzione, il suo tipo deve avere la forma $s -> s'$. Tecnicamente diremmo che il tipo di $E_1$ deve essere unificato con $beta -> gamma$ in cui $beta$ e $gamma$ sono variabili di tipo. Sia $t$ il tipo inferito di $E_2$. Si cerca di unificare $beta$ e $t$: se il tentativo fallisce si ha un errore di tipo, altrimenti il tipo inferito di $E_1(E_2)$ è $gamma$.

- Per ogni occorrenza di una funzione polimorfica, si sostituisce ogni variabile legata dal quantificatore $forall$ con una nuova variabile e si rimuove il quantificatore. Il tipo risultante è il tipo inferito della funzione polimorfica.

- Per un nome che si incontra per la prima volta, si introduce una nuova variabile di tipo.

#example()[
  La Figura 6.30 mostra l'inferenza del tipo per la funzione `length()`.
  La radice dell'albero della Figura 6.29 corrisponde alla definizione di una funzione, quindi introduciamo due variabili $beta$ e $gamma$, associamo il tipo $beta -> gamma$ alla funzione `length()` e il tipo $beta$ alla variabile $x$ (Figura 6.30, linee 1-2).

  Il figlio destro della radice può essere visto come l'applicazione della funzione polimorfica `if` a una tripla costituita da un valore booleano e due espressioni che rappresentano il ramo `then` e il ramo `else`. Il tipo di questa funzione è quindi:
  $ forall alpha . text("boolean") times alpha times alpha -> alpha $

  Ogni applicazione di una funzione polimorfica può riferirsi a un tipo diverso, quindi creiamo una nuova variabile di tipo $alpha_i$ (in cui $i$ sta per "if") e rimuoviamo

  #figure(image("images/2026-05-18-11-12-24.png"))

  il quantificatore $forall$ (Figura 6.30, linea 3). Il tipo del figlio sinistro di `if` deve essere unificato con il tipo `boolean`, mentre il tipo dei suoi due altri figli deve essere unificato con $alpha_i$.

  La funzione predefinita `null()` ha tipo $forall alpha . text("list")(alpha) -> text("boolean")$; utilizziamo la nuova variabile $alpha_n$ (in cui $n$ sta per "null") per sostituire $alpha$ rimuovendo il quantificatore (Figura 6.30, linea 4). Dall'applicazione di `null()` a $x$ inferiamo che il tipo $beta$ di $x$ deve corrispondere a $text("list")(alpha_n)$ (linea 5).

  Considerando il primo figlio del nodo `if`, si nota che il tipo `boolean` dell'espressione `null(x)` corrisponde al tipo che la funzione polimorfica `if` si aspetta. Considerando invece il secondo figlio, il tipo $alpha_i$ è unificato al tipo `integer` (linea 6).

  Consideriamo ora la sottoespressione `length(tl(x)) + 1`. Per prima cosa creiamo una nuova variabile $alpha_t$ (in cui $t$ sta per "tail") per la variabile legata $alpha$ nell'espressione di tipo relativa alla funzione `tl()` (linea 8). Dall'applicazione di `tl()` a $x$ possiamo inferire $text("list")(alpha_t) = beta = text("list")(alpha_n)$ (linea 9).

  Dato che `length(tl(x))` è un operando dell'operatore $+$, il suo tipo deve essere unificato con `integer` (linea 10). Ne segue che il tipo di `length()` è $text("list")(alpha_n) -> text("integer")$.

  Dopo aver concluso il controllo del tipo della definizione della funzione `length()`, la variabile $alpha_n$ rimane nella sua espressione di tipo. Dato che durante la verifica non si è fatta alcuna assunzione sulla variabile di tipo $alpha_n$, un tipo qualsiasi può essere utilizzato al suo posto al momento dell'uso della funzione. Trasformando quindi $alpha_n$ in una variabile legata otteniamo la nuova espressione:
  $ forall alpha_n . text("list")(alpha_n) -> text("integer") $
  che rappresenta il tipo di `length()`.
]

=== Algoritmo di unificazione

Definita informalmente, l'unificazione è il problema di determinare se due espressioni $s$ e $t$ possono essere rese identiche sostituendo alle variabili presenti in $s$ e $t$ delle nuove espressioni. La verifica dell'uguaglianza tra espressioni è un caso speciale di unificazione. Se due espressioni $s$ e $t$ contengono solo costanti e nessuna variabile, esse sono unificabili se e solo se sono identiche. L'algoritmo presentato in questo paragrafo può essere esteso ai grafi non aciclici e pertanto può essere utilizzato anche per la verifica dell'equivalenza strutturale tra tipi circolari.

Implementeremo una formulazione dell'unificazione basata sulla teoria dei grafi, secondo cui ogni tipo è rappresentato da un grafo. Le variabili di tipo sono rappresentate dalle foglie, mentre i costruttori di tipo dai nodi interni. I nodi sono raggruppati in classi di equivalenza: se due nodi appartengono alla stessa classe, allora le espressioni di tipo che essi rappresentano devono essere unificabili. Ne consegue che tutti i nodi interni appartenenti a una stessa classe di equivalenza devono corrispondere allo stesso costruttore di tipo e i rispettivi figli devono essere equivalenti.

#example()[
  Consideriamo le due seguenti espressioni di tipo:
  $
    & ((alpha_1 -> alpha_2) times text("list")(alpha_3)) -> text("list")(alpha_2) \
    & ((alpha_3 -> alpha_4) times text("list")(alpha_3)) -> alpha_5
  $
  La sostituzione $S$ descritta di seguito è l'unificatore più generale di queste espressioni.

  #align(center)[
    #table(
      stroke: none,
      columns: (4em, 8em),
      align: center,
      table.hline(start: 0),
      table.header([$x$], [$S(x)$]),
      table.hline(start: 0),
      [$alpha_1$], [$alpha_1$],
      [$alpha_2$], [$alpha_2$],
      [$alpha_3$], [$alpha_1$],
      [$alpha_4$], [$alpha_2$],
      [$alpha_5$], [$text("list")(alpha_2)$],
      table.hline(start: 0),
    )
  ]

  Tale sostituzione mappa le due espressioni di tipo nell'espressione seguente:
  $
    ((alpha_1 -> alpha_2) times text("list")(alpha_1)) -> text("list")(alpha_2)
  $

  Le due espressioni sono rappresentate dai nodi con etichetta $->$ della Figura 6.31. I numeri interi che etichettano i nodi indicano la classe di equivalenza cui ogni nodo appartiene, dopo che i nodi con etichetta $1$ sono stati unificati.

  #figure(image("images/2026-05-18-11-14-39.png"))
]

*INPUT*: Un grafo che rappresenta un tipo e una coppia di nodi $m$ e $n$ da unificare.\
*OUTPUT*: Il valore booleano `true` se le espressioni di tipo rappresentate dai nodi $m$ e $n$ sono unificabili, altrimenti il valore booleano `false`.

*METODO*: Un nodo è rappresentato mediante un record dotato di un campo per un operatore binario e due campi per i puntatori ai figli sinistro e destro. Gli insiemi di nodi equivalenti vengono gestiti mediante il campo `set`. Uno dei nodi di ogni classe di equivalenza viene scelto come rappresentativo della classe e ciò è indicato dal fatto che il puntatore `set` assume valore nullo. Per tutti gli altri nodi il campo `set` punta (eventualmente in modo indiretto) al nodo rappresentativo della classe. Inizialmente ogni nodo $n$ costituisce una classe di equivalenza a sé stante ed è il nodo rappresentativo della classe.

L'algoritmo di unificazione mostrato nella Figura 6.32 usa le due operazioni sui nodi descritte di seguito.
- `find(n)` restituisce il nodo rappresentativo della classe di equivalenza contenente il nodo $n$.
- `union(m, n)` fonde le classi di equivalenza contenenti i nodi $m$ e $n$. Se uno dei nodi rappresentativi delle classi di equivalenza di $m$ e $n$ non è associato a una variabile, la funzione `merge()` rende tale nodo rappresentativo della classe ottenuta dalla fusione; in caso contrario la funzione sceglie uno dei due nodi rappresentativi di $m$ e $n$ come rappresentativo dell'unione. Questa asimmetria nella specifica della funzione di unione è importante in quanto un nodo associato a una variabile di tipo non può essere scelto come nodo rappresentativo di una classe di equivalenza relativa a un'espressione che contiene un costruttore di tipo o un tipo di base. In caso contrario, infatti, due espressioni non equivalenti potrebbero essere unificate per mezzo di quella variabile.

L'operazione di unione tra due classi è implementata semplicemente assegnando al campo `set` del nodo rappresentativo di una classe il puntatore al nodo rappresentativo dell'altra. La funzione `find()`, invece, trova la classe cui un nodo appartiene seguendo la catena di puntatori memorizzati nel campo `set` finché non trova il nodo rappresentativo, cioè quello per cui il campo `set` ha valore nullo.

Si noti che l'algoritmo della Figura 6.32 utilizza $s = text("find")(m)$ e $t = text("find")(n)$ piuttosto che $m$ e $n$. I nodi rappresentativi coincideranno se $m$ ed $n$ appartengono alla stessa classe. Se $s$ e $t$ rappresentano lo stesso tipo di base, la funzione `unify(m, n)` restituisce `true`. Se invece $s$ e $t$ sono nodi interni corrispondenti a un costruttore di tipo binario si procede alla fusione speculativa delle due classi di equivalenza e si verifica ricorsivamente l'equivalenza dei tipi dei rispettivi figli. Si noti che unendo

#figure(image("images/2026-05-18-11-15-35.png"))

classi di equivalenza prima di procedere alla verifica ricorsiva sui figli si diminuisce il numero di classi: in questo modo si garantisce che l'algoritmo abbia termine.

La sostituzione di un'espressione al posto di una variabile è implementata aggiungendo la foglia corrispondente alla variabile alla classe di equivalenza contenente il nodo corrispondente all'espressione. Supponiamo che uno dei due nodi $m$ o $n$ sia una foglia corrispondente a una variabile e che tale foglia sia stata assegnata a una classe di equivalenza contenente un nodo relativo a un'espressione avente al suo interno un costruttore di tipo oppure a un tipo di base. In questo caso la funzione `find()` restituirà un nodo rappresentativo corrispondente a quello specifico costruttore di tipo o tipo di base, in modo che una variabile non possa mai essere unificata con due espressioni differenti.

== Flusso di controllo

La traduzione dei costrutti per il controllo del flusso quali `if-then-else` e `while` è strettamente legata alla traduzione delle espressioni booleane. Nei linguaggi di programmazione, infatti, le espressioni booleane sono spesso usate per i seguenti scopi:

+ *Modificare il flusso di controllo.* Le espressioni booleane sono usate come espressioni condizionali negli statement che modificano il flusso di controllo. Il valore booleano di tali espressioni è implicitamente definito dalla posizione raggiunta dall'esecuzione del programma. Se consideriamo, per esempio, il costrutto `if (`$E$`)` $S$, il valore dell'espressione $E$ deve essere vero se l'esecuzione raggiunge lo statement $S$.

+ *Calcolare valori logici.* Un'espressione booleana può rappresentare i valori logici `true` o `false` e può essere valutata in modo analogo alle espressioni aritmetiche mediante istruzioni a tre indirizzi relative a operatori logici.

Lo specifico utilizzo di un'espressione booleana dipende dal contesto sintattico in cui essa appare. Per esempio, un'espressione booleana che segue la parola chiave `if` è utilizzata per modificare il flusso di controllo, mentre un'espressione che appare nel lato destro di un'istruzione di assegnamento è utilizzata per denotare un valore logico.



=== Espressioni booleane

Le espressioni booleane sono composte da operatori booleani AND, OR e NOT — che, seguendo le convenzioni del linguaggio C, indichiamo rispettivamente con i simboli `&&`, `||` e `!` — applicati a operandi che possono essere variabili booleane o espressioni relazionali.

Le espressioni relazionali hanno la forma $E_1 text("rel") E_2$, in cui $E_1$ ed $E_2$ sono espressioni aritmetiche. In questo paragrafo considereremo espressioni booleane generate dalla grammatica:

$
  B -> B || B | B && B | ! B | ( B ) | E text("rel") E | text("true") | text("false")
$

Useremo l'attributo $text("rel")."op"$ per specificare quale dei sei operatori relazionali `<`, `<=`, `=`, `!=`, `>` o `>=` indichi il terminale `rel`.

La definizione della semantica di un linguaggio chiarisce se sia o meno richiesta la valutazione di tutte le parti di un'espressione booleana. Se la semantica stabilisce che è ammesso (o richiesto) che alcune parti di un'espressione booleana non siano valutate, il compilatore può ottimizzarne la valutazione calcolando solamente la porzione minima necessaria a stabilire se l'espressione complessiva sia vera o falsa.

Pertanto, in un'espressione come $B_1 || B_2$, né $B_1$ né $B_2$ sono necessariamente valutate completamente. Ciò significa che se $B_1$ o $B_2$ sono espressioni aventi effetti collaterali (per esempio, se contengono chiamate di funzione che modificano una variabile globale) è possibile ottenere risultati inattesi.

=== Traduzione con corto circuito

Secondo lo schema di traduzione con corto circuito (*short-circuit*), gli operatori `&&`, `||` e `!` sono tradotti mediante istruzioni di salto. In questo caso gli operatori non appaiono esplicitamente nel codice, in quanto il valore di un'espressione booleana è rappresentato implicitamente dalle diverse posizioni nel codice.

#example()[
  L'istruzione:

  #align(center)[
    `if ( x < 100 || x > 200 && x != y ) x = 0;`
  ]

  potrebbe essere tradotta nel codice della Figura 6.34. Secondo tale traduzione il valore dell'espressione booleana è vero se l'esecuzione raggiunge l'etichetta $L_2$. Se invece l'espressione risulta falsa, il controllo raggiunge immediatamente l'etichetta $L_3$, saltando oltre $L_2$ senza eseguire l'assegnamento $x = 0$.
  #figure(image("images/2026-05-18-11-28-10.png"))
]

=== Istruzioni per la gestione del flusso di controllo

Consideriamo ora la traduzione delle espressioni booleane in codice a tre indirizzi nel contesto di istruzioni di controllo come quelle generate dalla seguente grammatica:

$
  S & -> text("if") ( B ) S_1 \
  S & -> text("if") ( B ) S_1 text("else") S_2 \
  S & -> text("while") ( B ) S_1
$

In queste produzioni il non-terminale $B$ rappresenta un'espressione booleana e il non-terminale $S$ rappresenta un generico statement.

Per semplicità costruiamo le traduzioni $B."code"$ e $S."code"$ sotto forma di stringhe, ricorrendo a opportune definizioni guidate dalla sintassi.

La traduzione del costrutto `if (`$B$`)` $S_1$ consiste del codice $B."code"$ seguito dal codice $S_1."code"$, come illustrato dalla Figura 6.35(a). Nel codice $B."code"$ vi sono istruzioni di salto che dipendono dal valore dell'espressione $B$. In particolare, se $B$ è vera, il controllo passa alla prima istruzione di $S_1."code"$, mentre se $B$ è falsa il controllo passa alla prima istruzione successiva al codice $S_1."code"$.

#figure(image("images/2026-05-18-11-30-47.png"))

Le etichette per i salti all'interno delle porzioni di codice $B."code"$ ed $S."code"$ sono gestite mediante attributi ereditati. A ogni espressione booleana $B$ associamo due etichette $B."true"$ e $B."false"$ che indicano i punti che il controllo raggiunge quando il valore di $B$ è rispettivamente vero oppure falso. A ogni statement $S$ associamo poi un attributo ereditato $S."next"$ che indica l'etichetta dell'istruzione immediatamente successiva al codice relativo a $S$. In alcuni casi l'istruzione immediatamente seguente il codice $S."code"$ è un salto a un'etichetta $L$. Un salto dal codice di $S$ a un'istruzione di salto a un'etichetta $L$ viene evitato ricorrendo a $S."next"$.

#figure(image("images/2026-05-18-11-31-02.png"))
#figure(image("images/2026-05-18-11-31-12.png"))

=== Traduzione di espressioni booleane mediante costrutti per il controllo del flusso

Le regole semantiche per le espressioni booleane riportate nella Figura 6.37 complementano le regole per gli statement riportate nella Figura 6.36. Secondo l'organizzazione del codice presentata nella Figura 6.35, un'espressione booleana $B$ può essere tradotta in istruzioni a tre indirizzi che ne calcolano il valore mediante salti condizionati e incondizionati all'etichetta $B."true"$ se $B$ risulta vera e a $B."false"$ in caso contrario.

La quarta produzione della Figura 6.37, cioè $B -> E_1 text("rel") E_2$, viene tradotta direttamente da un'istruzione di confronto a tre indirizzi con i salti alle etichette appropriate. Per esempio un'espressione del tipo `a < b` viene tradotta come:

#align(center, block(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  [
    `if a < b goto B.true` \
    `goto B.false`
  ],
))

Le rimanenti produzioni del non-terminale $B$ sono tradotte come segue:

1. Supponiamo che $B$ abbia la forma $B_1 || B_2$. Se $B_1$ è vera sappiamo immediatamente che anche $B$ è vera, per cui $B_1."true"$ coincide con $B."true"$. Se $B_1$, invece, è falsa è necessario valutare $B_2$ per cui assegniamo a $B_1."false"$ l'etichetta associata alla prima istruzione del codice relativo a $B_2$. Infine, le etichette di uscita di $B_2$ coincidono con quelle di $B$.
2. La traduzione di $B_1 && B_2$ segue uno schema simile.
3. La traduzione di un'espressione del tipo $! B_1$ non richiede alcun codice: è sufficiente scambiare le etichette di uscita di $B$ (cioè $B."true"$ e $B."false"$) per ottenere le etichette di uscita di $B_1$.
4. Le costanti `true` e `false` vengono tradotte con salti incondizionati rispettivamente alle etichette $B."true"$ e $B."false"$.

#example()[
  Consideriamo ancora lo statement:

  $ text("if") ( x < 100 || x > 200 && x != y ) quad x = 0; quad quad (6.13) $

  Usando le definizioni guidate dalla sintassi delle Figure 6.36 e 6.37 otterremmo il codice a tre indirizzi mostrato nella Figura 6.38.

  #figure(image("images/2026-05-18-11-33-19.png"))
]


=== Evitare istruzioni GOTO ridondanti
La traduzione standard delle espressioni booleane genera spesso salti inutili (es. un `goto` verso l'istruzione immediatamente successiva). Per ottimizzare il codice e sfruttare il naturale flusso sequenziale dell'esecuzione (il *fall-through* o "codice a cascata"), si introduce un'etichetta speciale chiamata `fall`.

Il significato di `fall` è: *"non generare alcun salto, lascia che il controllo passi naturalmente all'istruzione successiva"*.

==== Regole per le espressioni relazionali ($B -> E_1 text(" rel ") E_2$)

Quando si valuta una condizione, la generazione del codice dipende dal valore degli attributi ereditati $B."true"$ e $B."false"$:

- *Entrambe etichette esplicite:* Vengono generati due salti (es. `if a < b goto L1` seguito da `goto L2`).
- *Solo $B."false"$ è `fall`:* Serve un solo salto condizionato. Se è vero salta a $B."true"$, se è falso "cade" all'istruzione successiva:
  #align(center)[`if a < b goto B.true`]
- *Solo $B."true"$ è `fall`:* Si inverte la logica usando `ifFalse`. Se è falso salta a $B."false"$, se è vero "cade" all'istruzione successiva:
  #align(center)[`ifFalse a < b goto B.false`]
- *Entrambe sono `fall`:* Non viene generata nessuna istruzione di salto.

==== Regole per gli operatori logici (es. l'OR: $B -> B_1 || B_2$)

L'operatore `||` deve valutare $B_1$. Se $B_1$ è falso, bisogna valutare $B_2$. Questo si sposa perfettamente con la logica a cascata:

- Si impone che $B_1."false" = text("fall")$ (se $B_1$ è falso, cadi nel codice di $B_2$ per valutarlo).
- Tuttavia, se $B_1$ è vero, bisogna saltare interamente $B_2$ e andare alla fine. Quindi $B_1."true"$ non può mai essere `fall`: deve essere un'etichetta esplicita che salta oltre $B_2$.

#example()[
  Applicando la logica del `fall`, una condizione complessa come:
  #align(center)[`if (x < 100 || x > 200 && x != y) x = 0;`]

  Non genera più decine di etichette e salti ridondanti, ma viene elegantemente tradotta in sole tre istruzioni condizionali ottimizzate:

  ```text
        if x < 100 goto L2        // Se la prima è vera, salta l'AND e vai a L2
        ifFalse x > 200 goto L1   // Se è falsa, la condizione intera fallisce
        ifFalse x != y goto L1    // Se è falsa, la condizione intera fallisce
  L2:   x = 0                     // Corpo dell'if (raggiunto in cascata o tramite L2)
  L1:                             // Uscita
  ```
]


=== Valori booleani e codice di salto

Finora abbiamo rivolto l'attenzione all'uso delle espressioni booleane per alterare il flusso di controllo delle istruzioni. Un'espressione booleana, tuttavia, può anche essere valutata per ottenerne il valore, per esempio nelle istruzioni di assegnamento come `x = true;` o `x = a < b;`.

Un modo elegante per trattare entrambi gli usi delle espressioni booleane consiste nel costruire per prima cosa l'albero sintattico, secondo uno dei due seguenti approcci:

+ *Due passate.* Si costruisce dapprima l'intero albero sintattico del programma in ingresso, quindi, in una seconda passata, si visita l'albero in profondità e si calcola la traduzione specificata dalle regole semantiche.
+ *Una passata per le istruzioni, due per le espressioni.* Secondo questo approccio, per un costrutto come `while (`$E$`)` $S_1$ si tradurrebbe $E$ prima di iniziare a elaborare $S_1$. La traduzione di $E$, tuttavia, seguirebbe lo schema già visto che prevede quindi prima la costruzione dell'albero e poi una seconda passata per la traduzione.

Per esempio, l'assegnamento `x = a < b && c < d` può essere implementato dal codice della Figura 6.42.

#figure(image("images/2026-05-18-11-35-27.png"))


== Backpatching

Un problema cruciale nella generazione del codice per le espressioni booleane e per le istruzioni di controllo del flusso è quello di accoppiare un'istruzione di salto con l'etichetta di destinazione del salto stesso. Per esempio, la traduzione dell'espressione booleana $B$ nell'istruzione `if (`$B$`)` $S$ nel caso in cui $B$ risulti falsa, contiene un salto alla prima istruzione che segue il codice di $S$. In uno schema di traduzione a una sola passata, $B$ deve essere tradotta prima che il non-terminale $S$ venga analizzato. Qual è quindi l'etichetta dell'istruzione `goto` che salta oltre il codice di $S$?

Nel Paragrafo 6.6 abbiamo risolto questo problema propagando le etichette mediante attributi ereditati fino al punto in cui esse sono richieste per la generazione delle relative istruzioni di salto. In questo modo, tuttavia, è necessaria una seconda passata per associare alle etichette gli indirizzi effettivi.

In questo paragrafo vedremo un approccio complementare, chiamato *backpatching*, secondo cui opportuni attributi sintetizzati vengono utilizzati per propagare liste di salti. Più precisamente, quando viene generato un salto se ne lascia temporaneamente non specificata la destinazione. Ogni salto di questo tipo viene poi aggiunto a una lista che raccoglie tutti i salti le cui etichette di destinazione dovranno essere specificate in un secondo momento, cioè quando sarà possibile determinarle esattamente. Le liste saranno costruite in modo che tutti i salti in una stessa lista facciano riferimento alla stessa etichetta.

=== Generazione del codice in una passata mediante backpatching

La tecnica di backpatching può essere utilizzata per generare il codice di espressioni booleane e di istruzioni di controllo del flusso in una sola passata.

In questo paragrafo useremo gli attributi sintetizzati `"truelist"` e `"falselist"` di un non-terminale $B$ per gestire le etichette del codice di salto nella traduzione delle espressioni booleane. In particolare $B."truelist"$ è una lista di tutte le istruzioni di salto — condizionato e incondizionato — in cui dovremo inserire l'etichetta a cui saltare se $B$ risulta vera. La lista $B."falselist"$ svolge lo stesso ruolo per i salti nel caso in cui $B$ risulti falsa.

Per semplicità supponiamo di memorizzare le istruzioni generate in un array e di utilizzare l'indice di un'istruzione come sua etichetta. Per manipolare le liste di salti utilizzeremo le tre seguenti funzioni:

+ `makelist(i)` crea una nuova lista contenente solamente l'indice $i$ di un elemento di un'istruzione dell'array e restituisce un puntatore alla lista appena creata.
+ `merge(p_1, p_2)` concatena le liste puntate da $p_1$ e $p_2$ e restituisce un puntatore alla lista risultante.
+ `backpatch(p, i)` inserisce $i$ come etichetta di destinazione in ognuna delle istruzioni nella lista puntata da $p$.


=== Backpatching delle espressioni booleane

Costruiamo ora uno schema di traduzione adatto alla generazione del codice di espressioni booleane durante il parsing bottom-up. Il non-terminale marcatore $M$ permette a un'azione semantica di recuperare — al momento opportuno — l'indice della successiva istruzione che sarà generata. La grammatica è la seguente:

$
  B & -> B_1 || M B_2 | B_1 && M B_2 | ! B_1 | ( B_1 ) | E_1 text(" rel ") E_2 | text("true") | text("false") \
  M & -> epsilon
$

#figure(image("images/2026-05-18-11-41-04.png"))

*Sintesi delle azioni semantiche:*
- *(1) OR ($B -> B_1 || M B_2$)*: Se $B_1$ è vera, $B$ è vera. Se è falsa, è necessario valutare $B_2$. L'etichetta di destinazione dei salti in $B_1."falselist"$ diventa quindi l'inizio del codice di $B_2$ (ottenuta tramite $M."instr"$).
- *(2) AND ($B -> B_1 && M B_2$)*: Simile all'OR, ma si valuta $B_2$ solo se $B_1$ è vera. Si effettua il backpatch di $B_1."truelist"$ con $M."instr"$.
- *(3) NOT e (4) Parentesi*: Il NOT scambia semplicemente le liste `truelist` e `falselist`. Le parentesi vengono ignorate.
- *(5) Relazionale ($E_1 text(" rel ") E_2$)*: Genera due istruzioni (un salto condizionato e uno incondizionato) lasciando la destinazione temporaneamente non specificata (`_`). Le istruzioni vengono poi inserite nelle rispettive liste puntate da $B."truelist"$ e $B."falselist"$.

#example()[
  #figure(image("images/2026-05-18-11-42-05.png"))

  Consideriamo l'espressione: $x < 100 || x > 200 && x != y$

  L'albero di parsing annotato (Figura 6.44) viene visitato in profondità. Le azioni vengono eseguite contestualmente alle riduzioni bottom-up:

  1. *Riduzione di $x < 100$*: Genera due istruzioni incomplete.
    ```text
    100: if x < 100 goto _
    101: goto _
    ```
  2. *Marcatore $M$*: Salva la variabile `nextinstr` = 102.
  3. *Riduzione di $x > 200$*: Genera altre due istruzioni incomplete.
    ```text
    102: if x > 200 goto _
    103: goto _
    ```
  4. *Marcatore $M$*: Salva la variabile `nextinstr` = 104.
  5. *Riduzione di $x != y$*: Genera le ultime due istruzioni incomplete.
    ```text
    104: if x != y goto _
    105: goto _
    ```
  6. *Riduzione AND ($B_1 && M B_2$)*: Invoca `backpatch(B1.truelist, M.instr)` ovvero `backpatch({102}, 104)`. Questo assegna il valore 104 all'etichetta dell'istruzione 102.
  7. *Riduzione OR ($B_1 || M B_2$)*: Invoca `backpatch(B1.falselist, M.instr)` ovvero `backpatch({101}, 102)`. Questo assegna il valore 102 all'etichetta dell'istruzione 101.

  Il risultato delle istruzioni, dopo i passi di backpatching, è il seguente:

  #align(center, block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    [
      `100: if x < 100 goto _` \
      `101: goto 102` \
      `102: if x > 200 goto 104`  \
      `103: goto _` \
      `104: if x != y goto _` \
      `105: goto _`
    ],
  ))

  #figure(image("images/2026-05-18-11-42-22.png"))

  Le destinazioni rimaste vuote (`_`) appartengono alle liste `truelist` (100, 104) e `falselist` (103, 105) finali. L'etichetta di destinazione di queste istruzioni sarà assegnata più avanti nel processo di generazione, quando il costrutto padre (es. un `if` o `while`) deciderà dove saltare nei casi di vero e falso globale.
]

=== Statement per il controllo del flusso

Usiamo ora il backpatching per tradurre gli statement per il controllo del flusso in una sola passata. Come punto di partenza consideriamo la grammatica:

$
  S & -> text("if") ( B ) S | text("if") ( B ) S text("else") S | text("while") ( B ) S | \{ L \} | A ; \
  L & -> L S | S
$

#figure(image("images/2026-05-18-11-46-03.png"))

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
+ Teniamo traccia dello statement contenitore $S$.
+ Generiamo una istruzione incompleta di salto per lo statement `break`.
+ Inseriamo tale istruzione di salto nella lista $S."nextlist"$, il cui significato è quello discusso nel Paragrafo 6.7.3.

In un front-end a due passate per la costruzione di alberi sintattici, $S."nextlist"$ potrebbe essere implementato come un campo del nodo relativo a $S$. Potremmo tenere traccia di $S$ mediante la tabella dei simboli associando il nodo dello statement $S$ a uno speciale identificatore `break`. Questa tecnica permette anche di gestire gli statement `break` con etichetta previsti dal linguaggio Java. La tabella dei simboli, infatti, può essere utilizzata per mappare le etichette ai nodi dell'albero sintattico relativi ai costrutti contenitori.

In alternativa, invece di usare la tabella dei simboli per accedere al nodo $S$, possiamo inserire nella tabella dei simboli un puntatore a $S."nextlist"$. In questo modo, non appena incontriamo uno statement `break` generiamo un salto incompleto, cerchiamo `nextlist` nella tabella dei simboli e aggiungiamo il salto a tale lista; seguendo quanto discusso nel Paragrafo 6.7.3 eseguiremo quindi il backpatching di tale salto.

Gli statement `continue` possono essere gestiti in modo simile. La principale differenza tra gli statement `continue` e `break` è che l'etichetta destinazione dei salti generati è differente.

== Traduzione costrutto switch

Il costrutto `switch` o `case` è previsto in molti linguaggi. Si ha un'espressione di selezione $E$, che deve essere valutata, seguita da $n$ valori costanti $V_1, V_2, dots, V_n$ che l'espressione $E$ può assumere, tra cui eventualmente un valore di `default` che convenzionalmente corrisponde all'espressione se essa non assume alcuno dei valori esplicitamente specificati.

#figure(image("images/2026-05-18-11-48-17.png"))

Il comportamento previsto della traduzione dello statement `switch` è il seguente:
+ Valutazione dell'espressione $E$.
+ Ricerca, nell'elenco dei possibili casi, del valore $V_j$ uguale al risultato della valutazione di $E$. Si ricordi che il valore di `default` soddisfa la ricerca se nessuno dei casi espliciti corrisponde al valore di $E$.
+ Esecuzione dello statement $S_j$ associato al valore $V_j$ trovato.

Il passo (2) è un salto a $n$ via che può essere implementato in diversi modi. Se il numero di casi è basso, indicativamente inferiore a 10, è ragionevole utilizzare una sequenza di salti condizionati ognuno dei quali esegue il confronto con uno specifico valore e trasferisce il controllo al codice degli statement corrispondenti.

Un modo compatto di implementare la sequenza di salti consiste nel creare una tabella di coppie, ognuna formata da un valore e dall'etichetta del codice dello statement corrispondente. Il valore effettivo dell'espressione stessa, accoppiato all'etichetta dello statement di `default`, viene poi aggiunto alla fine della tabella al momento dell'esecuzione.

C'è inoltre un caso speciale — abbastanza comune — che può essere implementato in modo più efficiente di un salto a $n$ vie. Se tutti i valori dei vari casi appartengono a un intervallo limitato tra `min` e `max` e tali casi coprono buona parte dei valori tra `min` e `max`, si può costruire un array di $text("max") - text("min") + 1$ elementi tali che l'elemento con indice $j - text("min")$ contenga l'etichetta dello statement relativo al valore $j$. Agli elementi corrispondenti ai casi non esplicitamente specificati viene inoltre assegnata l'etichetta corrispondente al caso di `default`.

Per eseguire la selezione si valuta l'espressione otenendo un certo valore $j$, si verifica che $j$ appartenga all'intervallo tra `min` e `max`, quindi si trasferisce il controllo in modo indiretto all'etichetta memorizzata nell'elemento dell'array con indice $j - text("min")$. Se, per esempio, l'espressione è di tipo carattere, si può ricorrere a una tabella con 128 elementi (il numero degli elementi dipende dallo specifico insieme di caratteri) per trasferire il controllo allo statement corretto senza effettuare alcuna verifica sull'intervallo.

=== Traduzione guidata dalla sintassi degli statement switch

Il codice intermedio mostrato nella Figura 6.48(a) è un esempio di traduzione adatta allo statement `switch` della Figura 6.47. Tutti i test sono posizionati alla fine, cosicché un semplice generatore di codice possa riconoscere il costrutto di selezione a più vie e generare del codice efficiente seguendo la strategia più appropriata tra quelle suggerite nel paragrafo precedente.

Il codice più semplice mostrato nella Figura 6.48(b) richiederebbe un'analisi più complessa e ampia da parte del compilatore per scegliere l'implementazione più efficiente. Si noti che in un compilatore a singola passata non è conveniente posizionare le istruzioni di salto all'inizio, poiché in questo caso il compilatore non potrebbe emettere il codice dei vari statement $S_i$ nel momento in cui li incontra.

Per realizzare la traduzione nella forma suggerita dalla Figura 6.48(a) si procede come segue:
- Non appena si incontra la parola chiave `switch` si generano due nuove etichette `test` e `next` e una nuova variabile temporanea $t$.
- Durante il parsing dell'espressione $E$ si genera il codice per la sua valutazione, in modo da lasciare il risultato nella variabile temporanea $t$. Dopo aver elaborato $E$, si genera l'istruzione di salto `goto test`.
- Non appena si incontra una parola chiave `case` si crea una nuova etichetta $L_i$ e la si inserisce nella tabella dei simboli. Si aggiunge inoltre in una coda — utilizzata solamente per memorizzare i vari casi — una coppia formata dal valore costante $V_i$ associato allo specifico caso e dalla corrispondente etichetta $L_i$ (o dal puntatore all'elemento della tabella dei simboli corrispondente a $L_i$).
- Si elabora quindi ogni statement `case ` $V_i : S_i$ emettendo l'etichetta $L_i$ e il codice dello statement corrispondente $S_i$, seguito dall'istruzione di salto `goto next`.

Quando si riconosce la fine dello statement `switch`, si può procedere alla generazione del codice del salto a più vie. Leggendo la coda delle coppie valore-etichetta precedentemente costruita si può generare la sequenza di istruzioni a tre indirizzi nella forma mostrata dalla Figura 6.49, in cui $t$ è la variabile temporanea che contiene il valore dell'espressione di selezione $E$, e $L_n$ è l'etichetta relativa allo statement del caso di `default`.

L'istruzione a tre indirizzi `case t ` $V_i$ $L_i$ svolge la stessa funzione dell'istruzione `if t = ` $V_i$ ` goto ` $L_i$ usata nella Figura 6.48(a). Il ricorso a tale specifica istruzione semplifica il compito del generatore di codice finale nel riconoscere potenziali candidati per un trattamento speciale. Durante la generazione del codice finale, infatti, sequenze di istruzioni `case` di questo tipo possono essere tradotte nell'implementazione più efficiente a seconda di quanti casi si hanno e dell'intervallo in cui ricadono i valori.

#figure(image("images/2026-05-18-11-50-10.png"))
#figure(image("images/2026-05-18-11-50-16.png"))


=== Traduzione guidata dalla sintassi degli statement switch

Il codice intermedio mostrato nella Figura 6.48(a) è un esempio di traduzione adatta allo statement `switch` della Figura 6.47. Tutti i test sono posizionati alla fine, cosicché un semplice generatore di codice possa geograficamente? riconoscere il costrutto di selezione a più vie e generare del codice efficiente seguendo la strategia più appropriata tra quelle suggerite nel paragrafo precedente.

Il codice più semplice mostrato nella Figura 6.48(b) richiederebbe un'analisi più complessa e ampia da parte del compilatore per scegliere l'implementazione più efficiente. Si noti che in un compilatore a singola passata non è conveniente posizionare le istruzioni di salto all'inizio, poiché in questo caso il compilatore non potrebbe emettere il codice dei vari statement $S_i$ nel momento in cui li incontra.

Per realizzare la traduzione nella forma suggerita dalla Figura 6.48(a) si procede come segue:
1. Non appena si incontra la parola chiave `switch` si generano due nuove etichette `test` e `next` e una nuova variabile temporanea $t$.
2. Durante il parsing dell'espressione $E$ si genera il codice per la sua valutazione, in modo da lasciare il risultato nella variabile temporanea $t$. Dopo aver elaborato $E$, si genera l'istruzione di salto `goto test`.
3. Non appena si incontra una parola chiave `case` si crea una nuova etichetta $L_i$ e la si inserisce nella tabella dei simboli. Si aggiunge inoltre in una coda — utilizzata solamente per memorizzare i vari casi — una coppia formata dal valore costante $V_i$ associato allo specifico caso e dalla corrispondente etichetta $L_i$ (o dal puntatore all'elemento della tabella dei simboli corrispondente a $L_i$).
4. Si elabora quindi ogni statement `case ` $V_i : S_i$ emettendo l'etichetta $L_i$ e il codice dello statement corrispondente $S_i$, seguito dall'istruzione di salto `goto next`.

Quando si riconosce la fine dello statement `switch`, si può procedere alla generazione del codice del salto a più vie. Leggendo la coda delle coppie valore-etichetta precedentemente costruita si può generare la sequenza di istruzioni a tre indirizzi nella forma mostrata dalla Figura 6.49, in cui $t$ è la variabile temporanea che contiene il valore dell'espressione di selezione $E$, e $L_n$ è l'etichetta relativa allo statement del caso di `default`.

L'istruzione a tre indirizzi `case t ` $V_i$ $L_i$ svolge la stessa funzione dell'istruzione `if t = ` $V_i$ ` goto ` $L_i$ usata nella Figura 6.48(a). Il ricorso a tale specifica istruzione semplifica il compito del generatore di codice finale nel riconoscere potenziali candidati per un trattamento speciale. Durante la generazione del codice finale, infatti, sequenze di istruzioni `case` di questo tipo possono essere tradotte nell'implementazione più efficiente a seconda di quanti casi si hanno e dell'intervallo in cui ricadono i valori.

#figure(image("images/2026-05-18-11-50-10.png"))
#figure(image("images/2026-05-18-11-50-16.png"))




== Codice intermedio delle procedure

Le produzioni della Figura 6.50 specificano la sintassi della definizione e della chiamata di funzioni. Si noti che questa grammatica genera delle virgole indesiderate dopo l'ultimo parametro, ma è tuttavia adeguata allo scopo di illustrare il processo di traduzione in esame.

#figure(image("images/2026-05-18-11-51-24.png"))

Sia la definizione di funzioni, sia la loro chiamata possono essere tradotte ricorrendo a concetti già trattati in questo capitolo.

- *Tipo delle funzioni.* Il tipo di una funzione deve codificare sia il tipo del valore restituito, sia il tipo dei vari parametri formali. Sia inoltre `void` un tipo speciale utilizzato col significato di "nessun parametro" o "nessun valore di ritorno". Per esempio, il tipo della funzione `pop()` che restituisce un intero è "funzione da `void` a `integer`". I tipi delle funzioni possono essere rappresentati ricorrendo al costruttore di tipo `fun()` applicato al tipo di ritorno e alla lista ordinata dei tipi dei parametri.

- *Tabelle dei simboli.* Sia $s$ la tabella dei simboli in uso al momento in cui si raggiunge la definizione della funzione. Il nome della funzione dovrà essere aggiunto alla tabella $s$ per un successivo uso nel resto del programma. I parametri formali di una funzione possono essere trattati in modo analogo ai nomi dei campi di un record (Figura 6.18). Nella produzione relativa a $D$, dopo aver riconosciuto in ingresso la parola chiave `define`, si impila $s$ sullo stack e si crea una nuova tabella dei simboli:
  ```c
  Env.push(top); top = new Env(top);
  ```
Sia $t$ la nuova tabella dei simboli. Si noti che `top` viene passato come argomento nello pseudocodice `new Env(top)`: in questo modo la nuova tabella $t$ può essere collegata alla precedente tabella $s$. La nuova tabella $t$ viene utilizzata per la traduzione del corpo della funzione. Solo alla fine di tale traduzione si ripristina la vecchia tabella $s$.

- *Controllo dei tipi.* In un'espressione una funzione viene trattata esattamente come ogni altro operatore. La trattazione del controllo dei tipi vista nel Paragrafo 6.5.2, compresi gli aspetti riguardanti le conversioni di tipo, si estende quindi anche alle funzioni. Per esempio, se `f` è una funzione con un parametro di tipo `real`, nella chiamata `f(2)` il valore intero 2 viene convertito da `integer` a `real` automaticamente.

- *Chiamate di funzione.* Per generare il codice a tre indirizzi di una chiamata di funzione nella forma `id(E, E, ..., E)` è sufficiente generare il codice per valutare ogni parametro $E$ riducendolo a un indirizzo e facendo seguire il codice generato da un'istruzione `param`. Volendo evitare di mischiare il codice relativo alla valutazione dei parametri con le istruzioni `param` è sufficiente salvare l'attributo $E."addr"$ di ogni espressione $E$ in una opportuna struttura dati, per esempio una coda. Una volta generato il codice per tutte le espressioni si può procedere alla generazione delle istruzioni `param` mentre la coda viene svuotata.

#example()[
  Supponiamo che `a` sia un array di interi e che `f` sia una funzione da interi a interi. In questo caso la traduzione dell'assegnamento
  #align(center)[`n = f(a[i]);`]
  in codice a tre indirizzi potrebbe essere la seguente:

  #align(center, block(
    fill: luma(240),
    inset: 10pt,
    radius: 4pt,
    [
      `1) t1 = i * 4` \
      `2) t2 = a [ t1 ]` \
      `3) param t2` \
      `4) t3 = call f, 1` \
      `5) n = t3`
    ],
  ))

  Le prime due istruzioni calcolano il valore dell'espressione `a[i]` e lo salvano nella variabile temporanea `t2`, secondo quanto visto nel Paragrafo 6.4. La linea 3 specifica che `t2` è un parametro attuale della chiamata della funzione `f` alla linea 4, in cui si indica che il numero di parametri è appunto 1. La linea 4, inoltre, assegna il valore restituito dalla funzione alla variabile temporanea `t3`. Infine, la linea 5 copia il valore restituito nella variabile `n`.
]
