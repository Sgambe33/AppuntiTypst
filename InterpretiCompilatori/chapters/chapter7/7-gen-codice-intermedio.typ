#import "../../../dvd.typ": *
#import "@preview/algo:0.3.6": algo, code, comment, d, i
#pagebreak()

= Generazione codice intermedio
Questo capitolo tratta le *rappresentazioni intermedie*, il *controllo di tipo statico*, o *static type checking*, e la *generazione di codice intermedio*.
#figure(image("images/2025-11-25-16-09-51.png"))
Per semplificare, assumeremo che il front-end del compilatore sia organizzato come mostrato nel diagramma, in cui il parsing, il controllo statico e la generazione del codice sono eseguiti sequenzialmente; in alcuni il controllo statico e la generazione del codice possono essere combinati e incorporati nel parsing.

Molti degli schemi di traduzione possono essere implementati basandosi su parsing sia bottom-up, sia top-down. In ogni caso è sempre possibile realizzare un qualsiasi schema di traduzione prima costruendo l'albero sintattico e poi visitandolo opportunamente.

#definition()[
  L'*analisi sintattica* è l'insieme di _controlli_ di consistenza effettuati al momento della compilazione allo scopo di:
  + garantire che un programma compili con *successo*
  + individuare eventuali errori di programmazione prima dell'esecuzione del programma
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
La rappresentazione intermedia di alto livello fa uso di alberi sintattici o, per essere più precisi, una loro variante detta *DAG* (Directed Acyclic Graph). A bass livello invece, si fa uso di *codice a 3 indirizzi*.

#definition()[
  Un grafo diretto aciclico o DAG relativo a un'espressione identifica le sue sottoespressioni comuni, che appaiono cioè più di una volta.
]

I DAG possono essere costruite con le stesse tecniche viste per gli alberi sintattici.

=== Grafi diretti aciclici delle espressioni
Come un albero sintattico di un'espressione, in un DAG le foglie corrispondono agli
operandi atomici, mentre i nodi interni identificano gli operatori. La differenza sta nel fatto che in un DAG un nodo N ha pit di un genitore se esso rappresenta una
sottoespressione comune; in un albero sintattico, invece, il sottoalbero corrispondente a una sottoespressione comune sarebbe replicato tante volte quante la sottoespressione appare nell'espressione complessiva. Un DAG, pertanto, non solo rappresenta le espressioni in modo più compatto, ma fornisce anche al compilatore indicazioni molto utili per la generazione di codice efficiente per la valutazione dell'espressione.

#example()[
  Data l'espressione $a+a* (b-c) + (b-c) *d$, il relativo DAG associato risulta essere:
  #figure(image("images/2025-11-27-15-37-24.png"))
  Da notare come il nodo $a$ ha due genitori in quento appare due volte nell'espressione.
]

La SDD seguente può costruire sia alberi sintattici sia DAG a patto di modificare le funzioni _Leaf()_ e _Node()_ in modo che, prima di costruire un nuovo nodo, verifichino se ne esiste già uno identico, nel qual caso tale nodo viene restituito.
#figure(image("images/2025-11-27-16-03-18.png"))
Per esempio, prima di costruire un nuovo nodo _Node(op, left, right)_, dobbiamo verificare se esiste un nodo con etichetta _op_ e con figli _left_ e _right_, in quest'ordine. Se tale nodo esiste la funzione _Node()_ lo restituisce, altrimenti ne crea uno nuovo.

#example()[
  La seguente sequenza di passi costruisce il DAG mostrato nella (METTERE COLLEGAMENTO A GRAFO ESEMPIO PRECEDENTE), a patto che le funzioni Leaf () e Node() ritornino un nodo gia esistente, secondo quanto appena discusso, quando cid é possibile.
  #figure(image("images/2025-11-27-16-18-56.png"))

  Assumiamo che entry-a sia un puntatore all'elemento della tabella dei simboli relativo ad a, e cosi per gli altri identificatori. Alla seconda invocazione di Leaf (id, entry-a), alla linea 2, la funzione restituisce il puntatore al nodo precedentemente costruito, ovvero p2 = p1. Analogamente, i nodi restituiti ai passi 8 e 9 coincidono con quelli restituiti ai passi 3 e 4 (cioè p8 = p3 e 9p = p4). Di conseguenza, il nodo restituito al passo 10 deve essere lo stesso restituito al passo 5, cioé p10 = p5.
]

=== Metodo del valore numerico per la costruzione di DAG
I nodi di un albero sintattico sono spesso memorizzati in un array di record come si vede nel diagramma (a). Ogni riga dell'array rappresenta un record e quindi un nodo. In ogni record, il primo campo é un codice operativo che indica l'etichetta del nodo.

#figure(image("images/2025-11-27-17-58-19.png"))

Nel diagramma (b) le foglie hanno un campo aggiuntivo contenente il valore lessicale (nel caso in esame un puntatore a un elemento della tabella dei simboli oppure una costante); i nodi interni hanno due campi aggiuntivi che rappresentano i figli sinistro e destro.

In questo array ci riferiamo ai nodi mediante l'indice del record corrispondente al nodo d'interesse. Storicamente, tale indice é stato chiamato valore numerico o value number del nodo o dell'espressione che esso rappresenta. Per esempio, nel diagramma precedente, il nodo con etichetta + ha valore numerico 3 e i suoi figli sinistro e destro hanno rispettivamente valore numerico 1 e 2. Benché in pratica si utilizzino spesso puntatori ai record o riferimenti agli oggetti, si continua a usare il termine “valore numerico” per indicare i riferimenti a un nodo. Se memorizzati in una opportuna struttura dati, i valori numerici permettono di costruire il DAG di un'espressione in modo molto efficiente attraverso un algoritmo.
Supponiamo che i nodi siano memorizzati in un array, e ci si riferisca a essi mediante il loro valore numerico. Chiamiamo *signature* o *firma di un nodo interno* la tripla (`op,l,r`), in cui `op` é l'etichetta, `l` il valore numerico del figlio sinistro e `r` quello del figlio destro. Per un operatore unario possiamo assumere convenzionalmente che `r` = 0.

#[
  #set heading(numbering: none, outlined: false)
  === Metodo del valore numerico per la costruzione dei nodi di un DAG
]
*INPUT*: L'etichetta `op`, il nodo `l` e il nodo `r`. \
*OUTPUT*: Il valore numerico di un nodo nell'array cone firma (`op,l,r`). \
*METODO*: Si cerchi nell'array un nodo *M* con etichetta `op`, figlio sinistro `l` e figlio destro `r`. Se un tale nodo esiste, si restituisca il valore numerico di *M*. Altrimenti si crei un nuovo nodo *N* con etichetta `op`, figlio sinistro `l`, figlio destro `r` e si restituisca il suo valore numerico.

//TODO: completare con miglioramenti dell'hash
Benché questo algoritmo produca il risultato desiderato, effettuare una ricerca sull'intero array ogni volta che si deve localizzare un nodo è molto costoso, specialmente se un singolo array contiene tutte le espressioni di un programma. Un metodo più efficiente si basa sull'uso di una tabella di hash, grazie alla quale i nodi sono raccolti in “gruppi”, ognuno dei quali avrà tipicamente pochi elementi.
Per costruire una tabella di hash per i nodi di un DAG, abbiamo bisogno di una funzione di hash che calcola l'indice del gruppo data una firma (`op,l,r`) in maniera tale da distribuire il più uniformemente possibile le firme nei vari gruppi, cioè in modo che sia improbabile che un gruppo contenga molti pid nodi degli altri. L'indice del gruppo $h$(`op,l,r`) è calcolato in modo deterministico a partire da `op`, `l` e `r`, in modo da ottenere sempre lo stesso gruppo a partire da uno stesso nodo. Ogni gruppo può poi essere implementato mediante una lista, come mostrato nel diagramma.

#figure(image("images/2025-11-28-11-28-58.png"))

Un array, indicizzato in base al valore della funzione di hash, contiene i puntatori alle teste delle varie liste. Ogni elemento di una tale lista contiene poi il valore numerico di un nodo che, secondo la funzione di hash, appartiene al gruppo. Quindi, dato un nodo d'ingresso descritto da `op`, `l` e `r`, calcoliamo dapprima l'indice del gruppo $A$(`op,l,r`), quindi effettuiamo una ricerca del nodo richiesto all'interno della lista corrispondente al gruppo trovato. Se si ha corrispondenza, restituiamo il valore numerico $v$. Se non troviamo invece un tale nodo, siamo sicuri che esso non può trovarsi in nessun altro gruppo, per cui creiamo un nuovo elemento, lo aggiungiamo alla lista relativa al gruppo con indice $h$(`op,l,r`) e restituiamo il valore numerico associato al nuovo elemento.

== Codice a tre indirizzi
Il codice a tre indirizzi prevede al più un operatore nel lato destro di una istruzione. In altre parole, le espressioni aritmetiche composte non sono permesse. Secondo questa definizione, un'espressione in linguaggio sorgente come per esempio `x+y*z` potrebbe essere tradotta nella seguente sequenza di istruzioni a tre indirizzi:

- `t1 = y * z`
- `t2 = x + t1`

in cui `t1`e `t2` sono nomi temporanei generati dal compilatore. Il ricorso a nomi temporanei per memorizzare i valori intermedi calcolati da un dato programma rende il codice a tre indirizzi particolarmente semplice da riorganizzare.

=== Indirizzi e istruzioni
Il codice a tre indirizzi si basa su due concetti fondamentali: gli indirizzi e le istruzioni. Un indirizzo può assumere una delle seguenti forme:
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
La descrizione delle istruzioni a tre indirizzi specifica le varie componenti di ogni tipo di istruzione, ma non fornisce alcuna indicazione a proposito dell'implementazione dell'istruzione in una opportuna struttura dati. In un compilatore reale le istruzioni possono essere implementate come oggetti o come record aventi opportuni campi per l'operatore e per gli operandi. Tre comuni rappresentazioni sono le “quadruple”, le “triple” e le “triple indirette” .

Una *quadrupla* o *quad* ha quattro campi che chiamiamo `op`, `arg1`, `arg2` e `result`. Il campo `op` contiene un codice interno che indica l'operatore. Per esempio, l'istruzione a tre indirizzi `x = y + z` è rappresentata assegnando `+` al campo `op`, `y` ad `arg1`, `z` ad `arg2`, e `x` a `result`.

Alcune eccezioni a questa regola generale sono:
+ Le istruzioni con operatori unari come `x = minusy` oppure istruzioni di copia come `x = y` non utilizzano `arg2`. Si noti inoltre che per le operazioni di copia `op` è l'operatore di assegnamento `=`, mentre per la maggior parte delle altre operazioni l'assegnamento è da considerarsi implicito.
+ Le istruzioni come `param` non usano né `arg2`, né `result`.
+ Le istruzioni di salto condizionato e incondizionato salvano l'etichetta in `result`.


=== Triple
Una *tripla* è un record avente solamente i tre campi `op`, `arg1` e `arg2`.
#figure(image("images/2025-11-30-21-27-07.png"))
Come si nota dalla figura (b), il campo `result` è utilizzato principalmente da variabili temporanee. E' possibile e conveniente riferirsi al risultato di un'operazione `z op y` non mediante un nome temporaneo esplicito, bensì in modo indiretto mediante la posizione dell'operazione nella sequenza di codice. Sempre con riferimento alla figura (b), una rappresentazione mediante triple non farebbe riferimento alla variabile `t1` bensì alla posizione `(0)`. Secondo tale notazione, i numeri tra parentesi indicano puntatori alla struttura stessa di triple.

#example()[
  #figure(image("images/2025-11-30-21-30-33.png"))
  L'albero sintattico e le triple della figura corrispondono alle quadruple e al codice a tre indirizzi mostrato nella figura ancora precedente. Secondo la rappresentazione basata sulle triple della figura (b), l'istruzione di copia `a= t5` è codificata ponendo `a` nel campo `arg1` il valore numerico `(4)` nel campo `arg2`.
]

Uno dei vantaggi delle quadruple rispetto alle triple emerge considerando i compilatori ottimizzanti, in cui spesso le istruzioni vengono riorganizzate e spostate. Usando le quadruple, infatti, se spostiamo un'istruzione che calcola una variabile temporanea t, le istruzioni che utilizzano t non richiedono alcuna modifica. Usando le triple, invece, ci si riferisce al risultato di un'operazione mediante la sua posizione nel codice, percid spostare un istruzione richiede una modifica a tutte le triple che fanno riferimento al risultato che questa calcola. Tale problema, tuttavia, pud essere risolto grazie alle triple indirette.

Le triple indirette consistono in una lista di puntatori a triple, piuttosto che in una lista delle triple stesse. Possiamo per esempio usare un array instruction per memorizzare i puntatori alle triple nell'ordine desiderato. In tal caso, le triple della Figura 6.11(b) potrebbero essere rappresentate come nella Figura 6.12.
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

=== Equivalenza di tipo

=== Dichiarazioni

=== Organizzazione della memoria per i nomi locali

=== Sequenze di dichiarazioni

=== Campi nei record e nelle classi

== Traduzione delle espressioni
Vediamo ora la traduzione delle espressioni e delle istruzioni. Iniziamo qui con la traduzione delle espressioni in codice a tre indirizzi. Una espressione, come `a+b*c`, contenente più di un operatore sarà tradotta in istruzioni a tre indirizzi, ognuna contenente un solo operatore. Un riferimento a un elemento di un array, come `A[i][j]` sarà espansa in una sequenza di più istruzioni a tre indirizzi che calcolano l'indirizzo dell'elemento specificato.

=== Operazioni nelle espressioni
#figure(image("images/2025-12-02-17-15-13.png"))
La definizione guidata dalla sintassi mostrata sopra, costruisce il codice a tre indirizzi di un'istruzione di assegnamento S facendo ricorso all'attributo _code_ di
S e agli attributi _code_ e _addr_ dell'espressione denotata da E. Gli attributi S._code_ ed E._code_ indicano il codice a tre indirizzi relativo rispettivamente a S ed E. L'attributo E._addr_, invece, indica l'indirizzo della locazione di memoria che conterrà il valore di E. Si tenga presente che, come già visto, un indirizzo può essere un nome, una costante oppure una variabile temporanea generata dal compilatore. Si consideri l'ultima produzione $E -> #strong("id")$ della SDD.
Quando un'espressione coincide con un singolo identificatore $x$, $x$ stesso contiene il valore dell'espressione. Per questa ragione la regola semantica associata a tale produzione assegna all'attributo E._addr_ il puntatore all'elemento della tabella dei simboli che si riferisce alla specifica occorrenza di *id*. Se `top` indica la tabella dei simboli corrente, la funzione _top.get()_ restituisce l'elemento della tabella dei simboli individuato in base alla stringa *id*._lexeme_ relativa all'istanza di *id* in esame. All'attributo E._code_ viene invece assegnata la stringa vuota.

Quando invece si considera la produzione $E -> ( E_1 )$, la traduzione di E coincide con quella della sottoespressione $E_1$, pertanto E._addr_ prende il valore di $E_1$._addr_ ed E._code_ prende il valore di $E_1$._code_. I due operatori di somma ($+$) e di negazione (cioé il $-$ unario) sono rappresentativi della maggioranza degli operatori nei comuni linguaggi di programmazione. Le regole semantiche associate alla produzione $E -> E_1+E_2$ generano il codice per calcolare il valore di E a partire dai valori di $E_1$ e $E_2$. Il risultato è assegnato a una nuova variabile temporanea generata dal compilatore. Se il valore di $E_1$ è assegnato a $E_1$._addr_ ed $E_2$ a $E_2$._addr_, allora $E_1 + E_2$ viene tradotto come $t = E_1$._addr_ $+$ $E_2$._addr_, in cui $t$ è un nuovo nome temporaneo. Infine, il valore di $t$ viene assegnato a $E$._addr_. Si noti che esecuzioni successive dell'istruzione *new* _Temp()_ producono una sequenza di nomi temporanei $t_1,t_2,...$ tutti distinti.

Per comodità usiamo la notazione _gen(x '=' y '+' z)_ per indicare l'istruzione a tre indirizzi $2 = y +z$. Eventuali espressioni che dovessero apparire al posto delle variabili $x$, $y$ e $z$ sarebbero valutate prima di essere passate alla funzione _gen()_; le stringhe tra apici, invece, sono interpretate letteralmente.
Altre istruzioni a tre indirizzi sono costruite in modo simile, applicando la funzione _gen()_ a una combinazione di espressioni e stringhe costanti. Le regole di traduzione associate alla produzione $E -> E_1 + E_2$ costruiscono E.code concatenando E.code, Ey.code e un'istruzione che somma i valori di FE, ed E2. Tale istruzione assegna il risultato della somma a un nuovo nome temporaneo associato a E e indicato da E.addr. La traduzione della produzione E — - E; é simile. Le regole semantiche dapprima creano un nuovo nome temporaneo per /, quindi generano un'istruzione che esegue l'operazione di negazione (meno unario). Infine, la produzione S — id=£; genera le istruzioni che assegnano il valore dell'espressione F all'identificatore id. Le regole semantiche associate a questa produzione utilizzano la funzione top.get() per determinare l'indirizzo dell'identificatore rappresentato da id, esattamente come gia visto per la produzione E — id. II valore dell'attributo S.code consiste delle istruzioni per calcolare il valore di E e assegnarlo all'indirizzo indicato da E.addr, seguite da un'assegnamento all'indirizzo restituito dalla funzione top.get(id.leceme) e relativo alla specifica istanza di id in esame.

#example()[
  La definizione guidata dalla sintassi della Figura 6.19 traduce l'assegnamento a = b+~-c; nella seguente sequenza di codice a tre indirizzi:
  #figure(image("images/2025-12-02-17-15-53.png"))
]

=== Traduzione incrementale
Come sappiamo gli attributi che rappresentano codice possono essere stringhe di notevoli dimensioni. Per questa ragione tali stringhe sono solitamente generate in modo incrementale, come visto nel Paragrafo 5.5.2. Quindi, invece di costruire E.code secondo le regole riportate nella Figura 6.19, possiamo fare in modo di generare solamente le nuove istruzioni a tre indirizzi, secondo lo schema di traduzione della Figura 6.20. Secondo un approccio incrementale, la funzione gen() non solo costruisce un'istruzione a tre indirizzi, ma aggiunge anche tale istruzione alla sequenza di istruzioni generata fino a quel punto. La sequenza pud essere sia mantenuta in memoria per una eventuale elaborazione successiva, sia stampata incrementalmente. Lo schema di traduzione della Figura 6.20 genera lo stesso codice prodotto dalla definizione guidata dalla sintassi della Figura 6.19. Seguendo l'approccio incrementale, attributo code diventa superfluo poiché la sequenza di istruzioni generata da chiamate successive alla funzione gen() @ unica. Per esempio, la regola semantica nella Figura 6.20 relativa alla produzione E — E+E richiama la funzione gen() per generare solamente l'istruzione di somma, poiché le istruzioni che calcolano E) e assegnano il risultato a E,.addr e quelle che calcolano E2 e assegnano il risultato a E».addr sono gia state generate. L'approccio presentato nella Figura 6.20 puod essere utilizzato anche per la costruzione di alberi sintattici. In tal caso, Pazione semantica relativa alla produzione E — E+E, creerebbe un nuovo nodo utilizzando il costruttore Node(). Tale azione avrebbe la forma seguente

S.addr = new Node('=', id, E.addr)
E > EB, +E, { E.addr = new Node('+', Ey.addr, Ey.addr); }
-E1 = new Node('minus', E1.addr)

in cui l'attributo addr rappresenta l'indirizzo di un nodo e non quello di una variabile o di una costante.

=== Indirizzamento degli elementi di un array
E possibile accedere in modo semplice agli elementi di un array se questi sono memorizzati in un blocco di locazioni di memoria contigue. In C e in Java gli elementi di un array di dimensione n sono numerati da 0 an—1. Se la larghezza di ogni elemento @ pari a w, allora l'i-esimo elemento dell'array inizia alla locazione di memoria base +i x w (6.2)

in cui base & l'indirizzo relativo dell'inizio della zona di memoria riservata all'array. In altre parole base coincide con Vindirizzo dell'elemento A[0}. a L'Equazione (6.2) pud essere generalizzata al caso degli array multidimensionali. Per gli array a due dimensioni, in C e in Java indichiamo con Ali:}[é2] Velemento in posizione ig nella riga i;. ndicando con w, la larghezza di una riga e con we quella di un elemento della riga, l'indirizzo relativo dell'elemento A[i;][i2] @ dato dalla relazione: base

+ i, X wy +12 X We (6.3)

In & dimensioni la relazione diviene

base + iy X wy tig X Wats + ip X WE (6.4)

in cui w;, per 1 < j < k, @ la generalizzazione delle dimensioni w, e we dell'Equazione 6.3.

In & dimensioni, la seguente formula produce come risultato lo stesso indirizzo calcolato dall'Equazione (6.4):

base + ((-+-((i1 X ng + tg) x ng + i3)---) x ne tin) x w (6.6)

Entrambe le espressioni (6.2) e (6.7) possono essere riscritte nella forma i x w + Cc, in cui la sottoespressione c = base — low x w & costante e puo essere precalcolata a
compile-time. Si noti che quando low = 0 risulta c = base.

I calcoli degli indirizzi visti fino a questo punto assumono che gli array siano organizzati “per righe” , come accade in C e in Java. Un array bidimensionale normalmente é memorizzato per righe oppure per colonne. La Figura 6.21 mostra l'organizzazione della memoria nel caso di un array A di dimensione 2 x 3 ordinato per righe e per colonne. L'organizzazione per colonne @ comune nei linguaggi appartenenti alla famiglia del Fortran.
#figure(image("images/2025-12-02-17-17-25.png"))

=== Traduzione dei riferimenti ad array
Il problema principale nella generazione del codice per i riferimenti agli elementi di un array consiste nel correlare i calcoli dell'indirizzo visti nel Paragrafo 6.4.3 alla grammatica corrispondente. Sia L un non-terminale che genera un nome di array seguito da una sequenza di espressioni per gli indici:

L > LUE)

| id CEI

Come per il C e per Java, assumiamo che |'indice del primo elemento di un array
sia 0, e procediamo al calcolo degli indirizzi sulla base delle larghezze, cioé mediante
V'Equazione (6.4), piuttosto che in base al numero di elementi come nell'Equazio-
ne (6.6). Lo schema di traduzione della Figura 6.22 genera codice a tre indirizzi per
espressioni contenenti anche riferimenti ad array. Tale SDT consiste delle produzioni
e azioni semantiche gia introdotte nella Figura 6.20, pit le nuove produzioni relative
al non-terminale L.
Il non-terminale L ha tre attributi sintetizzati.
1. L.addr indica un indirizzo temporaneo utilizzato per il calcolo dello spiaz-
zamento del riferimento all'array che prevede la somma dei vari termini
13 X Wj.

2. L.array ® un puntatore all'elemento della tabella dei simboli relativo al nome
dell'array. L'indirizzo di base dell'array, indicato per esempio da L.array. base,
& utilizzato per calcolare I'l-value effettivo di un riferimento ad array una volta
che tutte le espressioni relative agli indici siano state analizzate.
3. L.type & il tipo del sotto-array generato da L. Per qualsiasi tipo t assumia-
mo che t.width ne fornisca la larghezza. Utilizziamo i tipi e non le larghezze
come attributi, poiché questi sono comunque richiesti per il controllo dei tipi.
Supponiamo inoltre che t.elem indichi il tipo degli elementi dell'array ¢.

La produzione S — id=E; rappresenta un assegnamento a una variabile scalare
(cioé non di tipo array) ed é trattata come di consueto. L'azione semantica relativa
alla produzione § — L= EH; genera un'istruzione di copia indicizzata che assegna il
valore indicato dell'espressione E alla locazione di memoria denotata dal riferimento
ad array L. Siricordi che l'attributo L.array indica l'elemento della tabella dei simboli
relativo all'array e che l'indirizzo della base dell'array — cioé l'indirizzo dell'elemento
con indice 0 — @ dato da L.array.base. Dato che L.addr indica la variabile temporanea
#figure(image("images/2025-12-02-17-17-53.png"))
che contiene lo spiazzamento del riferimento all'array generato da L, la locazione di
memoria dell'elemento in esame é data da L.array.base[L.addr]. L'istruzione generata
pertanto copia l'r-value dell'indirizzo E.addr nella locazione di memoria di L.
Le produzioni FE — E,+E, e E — id sono le stesse gia studiate. L'azione
semantica relativa alla nuova produzione E — L genera il codice necessario per copiare il valore dalla locazione denotata da L in una variabile temporanea. Tale locazione
& L.array.base{[L.addr], come appena visto per la produzione S — L=£. Anche in
questo caso L.array indica il nome dell'array, L.array.base Vindirizzo della base e
L.addr indica una variabile temporanea contenente lo spiazzamento dell'elemento in
esame. II codice a tre indirizzi generato copia l'r-value della locazione specificata da
base e spiazzamento in una nuova variabile temporanea indicata da E.addr.

#example()[
  Esempio 6.12 Sia a un array di interi di dimensione 2 x3 e siano c, i e j tre variabili intere. Il tipo di a & dunque array(2, array(3, integer)) e la sua larghezza, assumendo che la larghezza di un intero sia 4, @ pari a 24. Il tipo di a[i] @ array(3, integer) e la sua larghezza  w; = 12. Il tipo di a[i] [j] é@ infine integer. La Figura 6.23 mostra un albero di parsing annotato relativo all'espressione c+a[il][j]. Tale espressione viene tradotta nel codice a tre indirizzi riportato nella Figura 6.24, in cui abbiamo utilizzato, come di consueto, i nomi dei simboli per riferirci ai corrispondenti elementi nella tabella dei simboli. Oo
  #figure(image("images/2025-12-02-17-18-18.png"))
  #figure(image("images/2025-12-02-17-18-37.png"))
]

//10.12.2025
== Controllo dei tipi

Per poter effettuare il controllo dei tipi un compilatore deve dapprima assegnare un'espressione di tipo a ogni componente del programma sorgente per poi procedere a verificare che tali espressioni siano conformi rispetto a un insieme di regole logiche comunemente detto _type system_ di un linguaggio.
Il controllo dei tipi può portare all’individuazione di errori nel programma. In linea di principio, tutti i controlli di tipo possono essere effettuati a run-time a patto che il codice generato conservi non solo il valore di ogni elemento, ma anche il suo tipo. Un type system solido elimina la necessità di effettuare controlli dinamici di errori di tipo poiché è in grado di stabilire a livello statico (compile-time) che quegli errori non si potranno verificare durante l’esecuzione. Si dice che l’implementazione di un linguaggio è *fortemente tipizzata* se il compilatore garantisce che i programmi che accetta potranno essere eseguiti senza che si verifichino errori di tipo.


=== Regole per il controllo dei tipi

Il controllo dei tipi pud assumere due forme: *sintesi* e *inferenza*. La sintesi dei tipi prevede la costruzione di un tipo di un’espressione a partire dal tipo delle sue sottoespressioni. Tale approccio richiede che tutti i nomi siano dichiarati prima di poter essere utilizzati. Il tipo di un’espressione come $E_1 + E_2$ è definito in base al tipo di $E_1$ e a quello di $E_2$. Una tipica regola che si incontra nella sintesi dei tipi ha la forma:
#align(center, [
  *if* $f$ è di tipo $s->t$ *and* $x$ è di tipo $s$,\
  *then* l’espressione $f(x)$ è di tipo $t$
])
In questa regola, che si riferisce a funzioni con un solo argomento, $f$ e $x$ indicano espressioni e la scrittura $s -> t$ indica una funzione da $s$ a $t$.

L'inferenza di tipo determina il tipo di un costrutto del linguaggio in base al modo in cui esso è utilizzato. Sia `null()` una funzione che verifica se una lista è vuota. In tal caso, in base a un suo utilizzo nelle forma `null(x)` possiamo concludere che $x$ deve essere una lista. Il tipo degli elementi della lista, tuttavia, non è noto; al momento si può soltanto stabilire che $x$ è una lista di elementi di tipo ignoto.

#observation()[
  Useremo le lettere greche $alpha, beta$ e così via, per indicare variabili di tipo nelle espressioni di tipo.
]

Una tipica regola per l’inferenza di tipo ha la forma seguente:
#align(center, [
  *if* $f(x)$ è un’espressione,\
  *then* per qualche $alpha$ e $beta$, $f$ è di tipo $alpha-> beta$ *and* $x$ è di tipo $alpha$
])

Considereremo il controllo dei tipi delle espressioni, ma le regole per il controllo degli statement sono simili. Per esempio, interpreteremo il costrutto *if*($E$) $S$; come se si trattasse dell’applicazione di una funzione _if()_ agli operandi $E$ ed $S$. Indichiamo inoltre con il tipo speciale _void_ l’assenza di un valore. In conclusione, quindi, possiamo dire che lo statement condizionale *if* può essere visto come una funzione _if()_ che richiede un argomento di tipo _boolean_ e uno di tipo _void_ e restituisce il tipo _void_.

=== Conversioni di tipo
Consideriamo l’espressione $x+i$ in cui $x$ è di tipo floating-point mentre $i$ è di tipo intero. Dato che la rappresentazione di valori interi e valori floating-point è diversa e che le operazioni su interi o su valori floating-point richiedono istruzioni macchina diverse, un compilatore dovrà provvedere alla conversione di uno dei due operandi dell’operatore $+$ in modo da assicurare che essi abbiano lo stesso tipo quando la somma avviene effettivamente. Supponiamo che i valori interi siano convertiti in valori floating-point. Nel codice dell’espressione $2 * 3.14$, per esempio, il valore intero 2 viene convertito in virgola mobile:
#align(center, [
  `t1 = (float) 2`\
  `t2 = t1 * 3.14`
])

Illustreremo la sintesi dei tipi estendendo lo schema di traduzione del Paragrafo 6.4.2 relativo alle espressioni. A tale scopo aggiungiamo il nuovo attributo _E.type_ il cui valore può essere _integer_ oppure _float_. La regola associata alla produzione $E->E_1+E_2$ richiede l'aggiunta dello pseudocodice:
#align(center, [
  *if* ($E_1$._type = integer_ *and* $E_2$._type = integer_) _E.type = integer_,\
  *else* *if* ($E_1$._type = float_ *and* $E_2$._type = integer_) $dots.c$\
  $dots.c$
])
All'aumentare del numero dei tipi, il numero dei casi da considerare cresce molto rapidamente.
#figure(image("images/2025-12-10-17-43-38.png"))
Le regole di conversione di tipo variano da linguaggio a linguaggio. Le regole di conversione per il linguaggio Java riportate nella Figura 6.25 distinguono due casi:
- conversioni con ampliamento o promozioni (widening), che hanno lo scopo di preservare l’informazione intatta
- conversioni con restrizione o demozioni (narrowing) che possono portare invece a una perdita di informazione.

Le regole di promozione sono date dalla gerarchia della Figura 6.25(a): ogni tipo può essere promosso a un tipo più in alto nella gerarchia. Per esempio, un char può essere promosso a integer o a float ma non a short. Le regole di demozione, invece, sono descritte dal grafo della Figura 6.25(b) secondo cui la demozione da un tipo s a un tipo ¢ è lecita se e solo se esiste un arco da s a t.

#definition()[
  Diciamo che la conversione da un tipo a un altro è implicita se è effettuata automaticamente dal compilatore. Le conversioni *implicite*, anche dette *coercizioni*, si limitano in molti linguaggi a promozioni che garantiscono la consistenza delle informazioni. Per contro, diciamo che una conversione è *esplicita* quando il programmatore deve scrivere apposite istruzioni affinché la conversione avvenga. Una conversione esplicita è comunemente chiamata *cast*.
]

L’azione semantica per il controllo di tipo della produzione $E->E_1+E_2$ utilizza le due funzioni seguenti:
+ $max(t_1, t_2)$ prende come argomenti due tipi $t_1$ e $t_2$ e restituisce il maggiore dei due secondo la gerarchia di promozione. Si verifica un errore qualora $t_1$ o $t_2$ non appartengano alla gerarchia, per esempio se sono array o puntatori.
+ $"widen"(a,t,w)$ genera la conversione di tipo necessaria per promuovere un indirizzo $a$ di tipo $t$ in un valore di tipo $w$. Se $t$ e $w$ rappresentano lo stesso tipo, la funzione restituisce $a$ stesso. Altrimenti genera un’istruzione che esegua la conversione e salvi il risultato in una variabile temporanea _temp_ e restituisce il nome temporaneo _temp_. Assumendo che gli unici tipi disponibili siano _integer_ e _float_, la funzione widen() assumerebbe la forma mostrata dallo pseudocodice seguente.
#figure(
  algo()[
    _Addr widen_(_Addr a, Type t, Type w_) {#i\
    if(_t=w_) return _a_; \
    else if ( _t = integer_ and _w = float_ ) {#i \
    _temp_ = new _Temp_(); \
    _gen_( _temp_ '=' '(*float*)' a ); \
    return _temp_;#d \
    } else *error*; #d\
    }
  ],
  caption: "Pseudocodice della funzione widen()",
)

#example()[
  L’azione semantica relativa alla produzione $E->E_1+E_2$, mostrata nella Figura 6.27, illustra come sia possibile aggiungere il supporto alle conversioni di tipo allo schema  di traduzione per le espressioni già visto. Nell’azione semantica riportata la variabile temporanea $a_1$ vale $E_1$._addr_ se il tipo di $E_1$, non deve essere  convertito al tipo di $E$, oppure assume il valore di una nuova variabile temporanea  restituita dalla funzione _widen()_ se la conversione al tipo di $E$ è necessaria. Lo stesso  ragionamento vale anche per $a_2$. Se i tipi di $E_1$ ed $E_2$ sono entrambi _integer_ o entrambi _float_ non è necessaria alcuna conversione. Può accadere, tuttavia, che unico modo  per sommare valori di due tipi diversi sia convertirli entrambi in un terzo tipo.
  #figure(image("images/2025-12-10-18-17-02.png"))
]

=== Sovraccaricamento di funziono e operatori
Un simbolo *sovraccaricato* (*overloaded*) ha diversi significati a seconda del contesto in cui si trova. Si dice che il sovraccaricamento viene _risolto_ quando si assegna un significato univoco a ogni occorrenza di un nome.
Una possibile regola per la sintesi del tipo di funzioni sovraccaricate é la seguente:
#align(center, [
  *if* $f$ può essere di tipo $s_i->t_i$, per $1 lt.eq i lt.eq n$, con $s_i eq.not s_j$ per $i eq.not j$\
  *and* $x$ è di tipo $s_k$, per qualche valore di $k$ tale che $1 lt.eq k lt.eq n$ \
  *then* l’espressione $f(x)$ è di tipo $t_k$
])

Il metodo del valore numerico descritto nel Paragrafo 6.1.2 può essere applicato a espressioni di tipo per risolvere efficientemente il problema del sovraccaricamento sulla base del tipo degli argomenti. L’ipotesi di poter risolvere il sovraccaricamento di una funzione sulla base del tipo dei soli argomenti equivale all’ipotesi di poter risolvere il sovraccaricamento in base
alla firma delle funzioni. Non sempre, tuttavia, l’analisi del tipo dei soli argomenti è sufficiente a risolvere il sovraccaricamento di una funzione.

=== Inferenza del tipo e funzioni polimorfiche
L’inferenza del tipo è utile nel caso di linguaggi come ML, che pur essendo fortemente tipizzato, non richiede di dichiarare i nomi prima dell’uso. L’inferenza di tipo assicura che i nomi siano usati in modo consistente. I] termine *polimorfico* indica in generale un qualsiasi frammento di codice che possa essere eseguito con argomenti di diversi tipi. In questo paragrafo considereremo il polimorfismo parametrico, cioe quel tipo di polimorfismo caratterizzato da parametri o da variabili di tipo. A tale scopo ci riferiremo al programma in linguaggio ML che definisce la funzione _length_():
#align(center, [
  ```ML
  fun length() = if null(x) then 0 else length(tl(x)) + 1;
  ```
])
La funzione _length_() calcola la lunghezza di una lista $x$, cioè il numero di elementi in $x$. Tutti gli elementi di una lista devono avere lo stesso tipo, ma la funzione in esame può essere applicata a liste di elementi di un tipo qualsiasi. Nell’espressione che segue la funzione _length_() è applicata a due tipi diversi di liste (gli elementi di una lista sono racchiusi tra parentesi quadre):
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
  Questo albero sintattico astratto rappresenta la definizione della funzione _length()_ fornita precedentemente. La radice dell'albero con etichetta *fun* rappresenta la definizione della funzione. I rimanenti nodi interni possono essere visti come applicazioni di funzioni.
  Possiamo inferire il tipo della funzione length() a partire dal suo corpo. Consideriamo i figli del nodo con etichetta *if*, presi da sinistra a destra. Dato che la funzione _null_() si aspetta di essere applicata a una lista, $x$ deve essere una lista. Indicando con la variabile $alpha$ il tipo degli elementi della lista, il tipo di $x$ è “lista di $alpha$”.
  Se _null_($x$) è vera allora _length_($x$) vale 0. Pertanto il tipo di _length_() deve essere “funzione da una lista di $alpha$ a un intero”. Tale valore per il tipo inferito della funzione è anche consistente con la parte di definizione.
]
