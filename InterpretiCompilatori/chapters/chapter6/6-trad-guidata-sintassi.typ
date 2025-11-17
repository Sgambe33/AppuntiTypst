#import "../../../dvd.typ": *
#pagebreak()

= Traduzione guidata dalla sintassi
L'*idea di base* della traduzione guidata dalla sintassi è quella di *associare informazioni* a un costrutto di un linguaggio aggiungendo *attributi* ai simboli della grammatica che rappresentano tale costrutto. Una definizione guidata dalla sintassi specifica i valori assunti dagli attributi per mezzo di regole semantiche associate alle produzioni.

== Definizioni guidate dalla sintassi
#definition(
  )[Una *Definizione Guidata dalla Sintassi* o *SDD (Syntax-Directed Definition)* è una grammatica *context-free* alla quale vengono aggiunti *attributi* e *regole semantiche*.
  - *Attributi:* sono associati ai simboli della grammatica. Possono essere di qualunque tipo, come numeri, tipi, tabelle, riferimenti o stringhe (frammenti di codice).
  - *Regole Semantiche:* sono associate alle produzioni della grammatica e specificano come calcolare il valore degli attributi.
]

La tecnica generale consiste nel costruire un albero di parsing (parse tree) per una stringa di input e poi usare le regole semantiche per calcolare i valori degli attributi in ogni nodo dell'albero. Un albero che mostra anche i valori calcolati degli attributi è detto albero di parsing annotato.

Dato un simbolo della grammatica $X$ e un suo attributo $a$, la notazione *$X.a$* indica il valore di $a$ per un nodo dell'albero di parsing etichettato con $X$.

=== Attributi ereditati e sintetizzati
Per i simboli non-terminali ci sono due tipi di attributi:

+ *Attributi sintetizzati*: un attributo di un non-terminale A relativo a un nodo N dell'albero di parsing è detto sintetizzato se è definito da una regola semantica associata alla produzione relativa al nodo N. Si noti che una tale produzione deve avere A come testa. Un attributo sintetizzato relativo a un nodo N è definito unicamente in base ai figli di N e a N stesso. 
  #example(
    )[
    In un'espressione aritmetica come $E -> E_1 + T$, l'attributo $E$.val (il valore dell'espressione) è sintetizzato calcolando $E_1$.val + $T$.val (i valori dei figli).
  ]

+ *Attributi ereditati*: un attributo di un non-terminale B relativo a un nodo N dell'albero di parsing è detto ereditato se è definito dalla regola semantica associata alla produzione relativa al nodo padre di NV. Si noti che tale produzione avrà B tra i simboli del corpo. Un attributo ereditato è definito solamente in base al padre di N, a N stesso e ai fratelli di N. 

#observation(
  )[
  Mentre non permettiamo che un attributo ereditato al nodo N possa essere definito in base ai valori degli attributi dei figli di N, ammettiamo invece che un attributo sintetizzato relativo al nodo N possa essere definito anche in base ai valori di attributi ereditati relativi al nodo N stesso.

  I terminali possono avere attributi sintetizzati, ma non attributi ereditati.
]

#example(
  )[
  #figure(image("images/2025-11-12-17-51-19.png"))
  La SDD della figura valuta le espressioni terminate da uno speciale marcatore di fine che indichiamo con $n$. Nella SDD ognuno dei non-terminali ha un unico attributo sintetizzato chiamato *val*. Supponiamo inoltre che il terminale *digit* abbia un attributo sintetizzato *lexval* dato dal valore intero restituito dall'analizzatore lessicale.
  - La regola per la produzione 1, $L -> E n$ assegna a L.val il valore dell'intera espressione E.val.
  - La produzione 2, $ E -> E_1 + T$ ha una regola che calcola il valore dell'attributo val della testa della produzione E come somma dei valori associati a $E_1$ e a $T$. A ogni nodo N con etichetta E il valore dell'attributo val associato a E è la somma del valori di val associati ai nodi figli di N etichettati con E e T.
  - La produzione 3, $E -> T$, ha una sola regola che stabilisce che il valore di val associato a E è uguale al valore di val relativo al nodo figlio con etichetta T.
  - La produzione 4 è simile alla seconda: invece di calcolarne la somma, la sua regola esegue il prodotto tra i valori degli attributi associati ai figli.
  - Le regole per le produzioni 5 e 6 copiano semplicemente i valori associati ad un nodo figlio, come gia visto per la produzione 3.
  - Infine, la produzione 7 assegna a F.val il valore di una cifra, cioè il valore numerico associato al token digit restituito dall'analizzatore lessicale.
]

#definition(
  )[
  Una SDD che contiene solo attributi sintetizzati è detta *S-attribuita* (come l'esempio precedente). In una SDD S-attribuita ogni regola calcola un attributo associato alla variabile della parte *sinistra* della produzione a partire dagli attributi associati ai simboli della parte *destra*.
]

=== Valutazione di una SDD ai nodi di un albero di parsing
Per visualizzare il processo di traduzione specificato mediante una SDD è utile ricorrere agli alberi di parsing anche se un traduttore non necessita della costruzione esplicita dell'albero. Immaginiamo quindi che le regole di un SDD siano utilizzate costruendo per prima cosa l'albero di parsing, quindi siano valutate per calcolare il valore degli attributi in corrispondenza di ogni nodo dell'albero di parsing. 

Per poter valutare un attributo di un nodo dobbiamo valutare prima tutti gli attributi da cui dipende.
- Se tutti gli attributi sono sintetizzati, prima di poter calcolare un attributo associato a un nodo, dobbiamo calcolare gli attributi associati ai figli. Possiamo procedere in qualsiasi ordine bottom-up, ad esempio visitando l'albero in postordine.
- Nel caso di SDD con attributi sia sintetizzati che ereditati non è possibile garantire sempre l'esistenza di un ordine di valutazione. 

#example(
  )[
  Si considerino, per esempio, i non-terminali $A$ e $B$ con attributi $A.s$ e $B.i$, rispettivamente sintetizzato ed ereditato, e la produzione con le corrispondenti regole semantiche:
  #figure(image("images/2025-11-12-18-20-21.png"))
  #figure(image("images/2025-11-17-11-42-54.png", height: 10%))
  Queste regole sono circolari. E' impossibile valutare l'attributo $A.s$ per un nodo N oppure l'attributo $B.i$ per un figlio del nodo N senza prima valutare l'altro.
]

#example(
  )[
  #figure(image("images/2025-11-12-18-18-24.png"))
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

#example(
  )[
  Si consideri la seguente produzione e la relativa regola semantica:
  $
    E->E_1 + T quad quad quad quad "E.val" = E_1."val" + "T.val"
  $
  Per ogni nodo N con etichetta E (corrispondente alla parte sx della regola) l'attributo sintetizzato val è calcolato utilizzando i valori degli attributi val corrispondenti ai due figli con etichette E e T. La porzione del grafo delle dipendenze corrispondente è:
  #figure(image("images/2025-11-16-18-25-07.png", width: 50%))
]

#example()[
  //TODO: rifare in typst
  Altro esempio di grafo delle dipendenze ma più complesso:
  #figure(image("images/2025-11-16-18-31-29.png"))
]

=== Ordine di valutazione degli attributi
Il grafo delle dipendenze caratterizza ogni possibile ordine di valutazione degli attributi associati ai nodi di un albero di parsing. Se c'è un arco da un nodo M ad un nodo N, allora l'attributo associato a M deve essere valutato prima di quello associato a N. 
#definition(
  )[
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

#definition(
  )[
  Una definizione guidata dalla sintassi è detta *L-attribuita* se tra gli attributi associati al corpo di una produzione possono esistere archi del grafo delle dipendenze orientati solo da sinistra verso destra e non viceversa.
]

Più precisamente, ogni attributo può essere: 
+ sintetizzato
+ ereditato, con le regole seguenti:\
  se $A-> X_1 X_2 ... X_n$ è una produzione a cui è associata una regola semantica che calcola il valore di un attributo ereditato $X_i.a$, allora tale regola può utilizzare soltanto:
  - attributi ereditati associati alla parte sinistra $A$;
  - attributi ereditati e sintetizzati assoaciati alle occorrenze dei simboli $X_1 X_2 ... X_(i-1)$ che compaiono a sinistra di $X_i$;
  - attributi ereditati e sintetizzati associati alla stessa occorrenza di $X_i$ in esame purché non comportino cicli.

#example(
  )[
  La seguente SDD è L-attribuita:
  #figure(image("images/2025-11-16-20-06-31.png"))
  - La prima regola definisce l'attributo ereditato T′.inh usando solo l'attributo F.val, e F si trova a sx di T′, come richiesto.
  - La seconda regola definisce l'attributo T′1.inh usando l'attributo ereditato T′.inh associato alla parte sx della regola e F.val associato ad F che compare a sx di T′1 nella parte dx della regola.

  In entrambi i casi le regole utilizzano informazioni provenienti da sopra o da sinistra, come richiesto dalle definizioni L-attribuite. Gli altri attributi sono sintetizzati quindi questa SDD è L-attribuita.
]

=== Regole semantiche con effetti collaterali controllati

Ogni traduzione comporta effetti collaterali, ad esempio stampa di un risultato (calcolatrice), aggiunta di informazioni nella tavola dei simboli (compilatore). Le grammatiche ad attributi non hanno nessun effetto collaterale e gli attributi possono essere valutati secondo qualunque ordinamento che rispetti il grafo delle dipendenze. Gli schemi di traduzione impongono una valutazione da sx a dx e consentono azioni semantiche costituite da porzioni di codice. Nelle SDD si possono controllare gli effetti collaterali in due modi:

- permettere effetti collaterali incidentali che non pongono vincoli sulla valutazione degli attributi, qualsiasi ordine di valutazione coerente col grafo delle dipendenze produce una traduzione corretta;

#example(
  )[
  Nella SDD per le espressioni (calcolatrice) possiamo sostituire la regola semantica $L."val" = E."val"$ associata alla produzione $L -> E n$ con $"print"(E."val")$ in modo che venga stampato il risultato. La SDD modificata produce la stessa traduzione seguendo un qualsiasi ordine topologico perché l'istruzione di stampa è eseguita per ultima dopo aver calcolato il valore di E.val. Regole semantiche di questo tipo equivalgono a definizioni di attributi sintetizzati fittizi associati alla parte sx della produzione.
]

- vincolare gli ordini di valutazione permessi in modo che la traduzione per ogni ordinamento sia comunque corretta. I vincoli possono essere visti come archi impliciti aggiunti al grafo delle dipendenze.

#example(
  )[
  #figure(image("images/2025-11-17-10-07-53.png"))
  Questa SDD rappresenta la dichiarazione D costituita da un tipo base T (che può essere int o float) seguito da una lista di identificatori L. Per ogni identificatore il tipo viene aggiunto al corrispondente elemento della tavola dei simboli. La variabile T ha un attributo T.type sintetizzato che può assumere i valori integer o float e che rappresenta il tipo della dichiarazione. L ha un attributo ereditato L.inh che serve per far passare il tipo dichiarato attraverso la lista di identificatori. Nella produzione 1 il valore di T.type passa a L.inh. Nella produzione 4 il valore di L.inh viene passato da un nodo padre al nodo figlio, verso il basso.
  Le produzioni 4 e 5 richiamano la funzione addType() con due argomenti
  + id.entry, valore lessicale, puntatore alla tavola dei simboli
  + L.inh , attributo che indica il tipo degli identificatori della lista
  #figure(image("images/2025-11-17-10-08-37.png"), caption: "Grafo delle dipendenze per float id1, id2, id3
                  ")
  6, 8 e 10: attributi fittizi utilizzati per rappresentare le chiamate alla
  funzione addType().


]
== Applicazioni della traduzione guidata dalla sintassi
Poiché alcuni compilatori usano gli alberi sintattici come rappresentazione intermedia, una forma comune di SDD ha lo scopo di trasformare la stringa d'ingresso in un albero. Per completare la traduzione in codice intermedio, il compilatore quindi visita l'albero seguendo un nuovo insieme di regole che di fatto costituiscono un SDD associato all'albero sintattico o all'albero di parsing. 

=== Costruzione degli alberi sintattici
È utile trasformare una stringa in ingresso in un albero che ne rappresenta la struttura e che può essere utilizzato come rappresentazione per la fase di traduzione. Questo albero viene detto *albero sintattico* ed è diverso dall'albero di parsing che rappresenta la derivazione di una stringa con una particolare grammatica.

#figure(image("images/2025-11-17-10-16-31.png"), caption: "Albero sintattico a sx e alberi di parsing a dx")

Ogni nodo di un albero sintattico rappresenta un costrutto e i figli di tale nodo rappresentano le parti significative che lo compongono. Un nodo di un albero che rappresenta un'espressione del tipo $E_1 + E_2$ ha come etichetta il simbolo $+$ e come figli due nodi che rappresentano le sottoespressioni $E_1$ e $E_2$. I nodi di un albero sintattico possono essere implementati per mezzo di oggetti con un numero di campi variabile. Ogni oggetto ha un campo `op` che costituisce l'etichetta del nodo.
- Se il nodo è una foglia, ha un campo aggiuntivo che contiene il valore lessicale associato. Viene creato con un costruttore del tipo `Leaf(op, val)`.
- Un nodo interno ha tanti campi aggiuntivi quanti sono i nodi figli nell'albero sintattico. Viene creato con un costruttore `Node(op, c1, c2, ..., ck)`.

#example(
  )[
SDD S-attribuita per espressioni con $+$ e $-$ .
#figure(image("images/2025-11-17-10-18-06.png"))
Ogni volta che si usa la produzione $E -> E_1 + T$ (o $E -> E_1 - T$) la regola semantica crea un nodo con etichetta `op` = '+' (o '-') e i nodi figli $E_1$.node e $T$.node relativi alle due sottoespressioni. La regola associata a $E -> T$ (e a $T -> ( E )$ ) non crea nessun nodo perché $E$.node e $T$.node si riferiscono allo stesso nodo.

#figure(image("images/2025-11-17-10-18-02.png"), caption: "Albero sintattico per a - 4 + c")
Se le regole vengono eseguite nell'ordine definito da una visita in postordine dell'albero di parsing o secondo un parsing bottom-up si ha la sequenza di passi
+ `p1 = new Leaf(id, entry-a)`;
+ `p2 = new Leaf(num, 4)`;
+ `p3 = new Node('−', p1, p2)`;
+ `p4 = new Leaf(id, entry-c)`;
+ `p5 = new Node('+', p3, p4)`;
e `p5` è un puntatore alla radice dell'albero sintattico.
]

#example(
  )[
  SDD L-attribuita per espressioni con + e - per la stringa a - 4 + c.
  #figure(image("images/2025-11-17-10-20-07.png"))
  Questa grammatica, adatta per il parsing top-down, produce lo stesso risultato, con gli stessi passi. Si ottiene lo stesso albero sintattico anche se l'albero di parsing è molto diverso. La variabile $E'$ ha un attributo ereditato *inh* e un attributo sintetizzato *syn*. L'attributo ereditato $E'$.inh rappresenta la porzione di albero sintattico costruita fino ad un certo punto, cioè la radice del sottoalbero corrispondente al prefisso della stringa d'ingresso relativa alla porzione di albero che si trova a sinistra di $E'$. Al nodo 5 del grafo delle dipendenze $E'$.inh rappresenta la radice del sottoalbero sintattico corrispondente all'identificatore $a$. Al nodo 6 $E'$.inh indica la radice del sottoalbero sintattico corrispondente alla stringa $a - 4$. Al nodo 9 $E'$.inh rappresenta l'albero sintattico corrispondente alla stringa $a - 4 + c$. Poiché la stringa in ingresso è terminata, $E'$.inh al nodo 9 punta alla radice dell'intero albero sintattico. L'attributo syn propaga tale valore fino all'attributo $E$.node.

  #figure(image("images/2025-11-17-10-20-25.png"), caption: "Grafo delle dipendenze per a - 4 + c")
]


== Schemi di traduzione guidati dalla sintassi
=== Schemi di traduzione postfissi

=== Implementazione degli SDT basata sugli stack del parser

