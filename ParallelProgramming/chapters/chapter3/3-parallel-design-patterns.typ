#import "../../../dvd.typ": *

= Design Patterns per la Programmazione Parallela

Diversi modelli strutturano l'espressione algoritmica del parallelismo.

=== Parallelismo di Controllo e Task
- *Superscalar sequence:* I task sono ordinati solo in base alle dipendenze dai dati e possono essere eseguiti non appena i dati di input sono pronti.
- *Loop Level Parallelism:* Assegna le iterazioni di un costrutto iterativo (loop) a unità di esecuzione. Particolarmente utile quando il codice non può essere ristrutturato massicciamente.
- *Task Parallelism:* Si concentra sulla distribuzione dei task (eseguiti da processi o thread) su diversi nodi paralleli. I thread possono eseguire codice uguale o diverso e comunicano scambiando dati.
- *Fork-Join Parallelism:* Un processo/thread principale (parent) crea (fork) altri processi/thread e attende (join) che tutti completino la loro porzione di lavoro prima di continuare . Un child non può fare join con il parent finché non ha fatto join con tutti i suoi children .
- *SPMD (Single Program, Multiple Data):* Tutte le unità di esecuzione eseguono lo stesso programma in parallelo, ma ciascuna ha il proprio set di dati . Tipicamente usato in sistemi a memoria distribuita .
- *Master-Worker (Master-Slave):* Un processo master crea un pool di worker e una borsa di task (spesso gestita con una coda) . I worker rimuovono i task e richiedono nuovo lavoro quando finiscono, bilanciando automaticamente il carico . È appropriato per problemi imbarazzantemente paralleli .
- *Client-Server:* Simile al modello MPMD (Multiple Program, Multiple Data) e originariamente derivante dal calcolo distribuito . Il parallelismo si ottiene elaborando richieste da diversi client concorrentemente o utilizzando più thread per elaborare una singola richiesta complessa .
- *Task Pool:* Struttura dati che memorizza i task da eseguire . Un numero fisso di thread, creati all'avvio del programma, accede a questa struttura comune per recuperare i task . L'accesso al task pool deve essere sincronizzato per evitare race conditions .
- *Producer-Consumer:* Thread produttori generano dati che vengono usati come input dai thread consumatori, tipicamente tramite una struttura dati comune come un buffer a lunghezza fissa . Richiede sincronizzazione per la coordinazione corretta . Una *Work Queue* (coda FIFO, LIFO, o prioritaria) è spesso usata in questo paradigma . Per ridurre la contesa, si possono usare più code, permettendo ai processi di eseguire work stealing .
- *Pipeline:* Utilizza una sequenza di stadi che trasformano un flusso di dati . Può essere visto come una forma speciale di scomposizione funzionale o parallelismo producer-consumer . L'esecuzione parallela si ottiene suddividendo i dati in uno stream che scorre attraverso gli stadi .

#heading(outlined: false, "Parallelismo di Dati", depth: 2)

- *Map:* Esegue una funzione (elemental function) su ogni elemento di una collezione . Replicando un pattern di iterazione seriale dove ogni iterazione è indipendente, il map può essere eseguito completamente in parallelo .
- *Reduction (Riduzione):* Combina ogni elemento in una collezione usando una *funzione combinatrice associativa* (es. somma, moltiplicazione, massimo, minimo, AND/OR/XOR booleano) . L'associatività permette diversi ordinamenti di riduzione per il parallelismo .
- *Combinazione Map e Reduce:* È possibile "fondere" i due pattern, ad esempio nel prodotto scalare di due vettori (Map per la moltiplicazione componente per componente e poi Reduce per la somma) .
- *Scan:* Calcola tutte le riduzioni parziali di una collezione . L'operatore deve essere almeno associativo per la parallelizzazione . Una scan parallela richiede più operazioni di una versione seriale .
- *Stencil:* È una generalizzazione di Map, dove la funzione elementare accede a un set di "vicini" (neighbors) . Spesso combinato con l'iterazione per risolutori iterativi . I dati sono divisi in regioni non sovrapposte e di dimensioni uguali per evitare conflitti di scrittura e migliorare il bilanciamento del carico .
- *Recurrence (Ricorrenza):* Risulta da loop nests con dipendenze di input e output tra le iterazioni . Può essere risolta per ricorrenze multidimensionali utilizzando il *Hyperplane Sweep* (Teorema di separazione dell'iperpiano di Leslie Lamport) .

== Scambio di Informazioni

Lo scambio di informazioni controlla il coordinamento delle parti di un programma parallelo .

=== Shared Memory (Memoria Condivisa)
Ogni thread può accedere ai dati condivisi nella memoria globale . Per coordinare l'accesso, è necessario un meccanismo di sequenzializzazione .
- *Race Condition:* Descrive l'effetto per cui il risultato di un'esecuzione parallela dipende dall'ordine non deterministico in cui le istruzioni vengono eseguite .
- *Mutua Esclusione:* Necessaria per l'esecuzione di sezioni critiche di codice che accedono a variabili condivise, tipicamente implementata con meccanismi di lock .

=== Distributed Memory (Memoria Distribuita)
Lo scambio di dati avviene tramite operazioni di comunicazione chiamate esplicitamente dai processori partecipanti, realizzate attraverso il trasferimento di messaggi (message-passing) .

==== Operazioni di Comunicazione (Distributed Memory)
Possono essere point-to-point o globali :
- *Single Transfer (Trasferimento Singolo):* Un processore mittente invia un messaggio a un processore destinatario. Richiede una corrispondente operazione di ricezione per evitare deadlock .
- *Single-Broadcast:* Un processore specifico (radice $P_i$) invia lo stesso blocco di dati a tutti gli altri processori .
- *Single-Accumulation:* Ogni processore fornisce un blocco di dati e una data operazione di riduzione viene applicata elemento per elemento, raccogliendo il risultato presso un processore radice $P_i$ .
- *Gather (Raccogliere):* Ogni processore fornisce un blocco di dati, e tutti i blocchi vengono raccolti in un processore radice $P_i$, senza applicare operazioni di riduzione .
- *Scatter (Disperdere):* Un processore radice $P_i$ fornisce un blocco di dati separato per ogni altro processore .
- *Multi-broadcast:* L'effetto di diverse operazioni single-broadcast, con ogni processore che riceve un blocco di dati da ogni altro .
- *Total Exchange (Scambio Totale):* Ogni processore fornisce per ogni altro processore un blocco di dati potenzialmente diverso (ogni processore esegue una operazione scatter) .

== Regole Fondamentali per la Progettazione di Applicazioni Parallele

+ *Identificare i Calcoli Veramente Indipendenti*: Le operazioni eseguite concorrentemente devono essere indipendenti l'una dall'altra . Funzioni o procedure che contengono uno stato non possono essere eseguite in modo concorrente . È cruciale controllare le dipendenze :
  - *Recurrences (Ricorrenze):* Le relazioni all'interno dei loop che portano informazioni da un'iterazione alla successiva .
  - *Induction Variables (Variabili di Induzione):* Variabili incrementate ad ogni iterazione di un loop, senza relazione uno-a-uno con l'iteratore del loop .
  - *Reduction (Riduzione):* Trasforma una collezione in un singolo scalare. Se l'operazione è associativa e commutativa, può essere parallelizzata calcolando risultati parziali locali e poi combinandoli con sincronizzazione .
  - *Loop-Carried Dependance (Dipendenza Portata dal Loop):* Si verifica quando i risultati di un'iterazione precedente vengono utilizzati nell'iterazione corrente (la ricorrenza ne è un caso speciale) . La divisione di tali iterazioni in task richiede sincronizzazione aggiuntiva .

+ *Implementare la Concorrenza al Livello Più Alto Possibile*: Identificare gli hotspot del codice e parallelizzare al livello gerarchico più alto. Questo consente di parallelizzare con una granularità maggiore .

+ Pianificare per la Scalabilità: La progettazione basata sulla *scomposizione dei dati* tende a offrire soluzioni più scalabili rispetto alla scomposizione dei task, poiché il numero di funzioni indipendenti è spesso limitato e fisso .

+ Utilizzare Librerie Thread-Safe e Modelli di Threading Corretti: È essenziale verificare che le librerie utilizzate siano thread-safe per evitare data races . Inoltre, utilizzare il modello di threading corretto (es. Pthreads, C++11 threads, OpenMP, Intel TBB, Cilk++) senza reinventare la ruota se non necessario .

+ Ottenere il Bilanciamento del Carico (Load Balance): Distribuire approssimativamente quantità uguali di lavoro tra i task per mantenere tutti i task occupati . Se tutti i task sono soggetti a un punto di sincronizzazione (barrier), il task più lento determina la prestazione complessiva .

+ Non Assumere Mai un Particolare Ordine di Esecuzione: L'ordine di esecuzione dei thread è non deterministico e controllato dallo scheduler del sistema operativo . Le data races sono un risultato diretto di questo non determinismo . La sincronizzazione deve essere implementata solo quando è assolutamente necessaria .

+ Usare la Memoria Locale al Thread: La sincronizzazione è overhead . Utilizzare variabili di lavoro temporanee allocate localmente a ciascun thread o API di thread-local storage (TLS) per rendere persistenti i dati locali ai thread. Se non è possibile, si usano dati condivisi e sincronizzati .

+ Osare Cambiare l'Algoritmo: Un algoritmo con complessità teorica superiore potrebbe essere più parallelizzabile di uno con complessità inferiore (es. moltiplicazione di matrici $O(n^3)$ semplice rispetto agli algoritmi ottimizzati come Strassen) .

== Metodologia di Progettazione

- *Top-Down:* Prende l'intero sistema software, lo scompone gerarchicamente in sottosistemi e componenti sempre più specifici. Adatto quando la soluzione software deve essere progettata da zero e i dettagli specifici sono sconosciuti .
- *Bottom-Up:* Inizia dai componenti più specifici e di base e procede componendo livelli di componenti superiori fino a far evolvere il sistema desiderato come un singolo componente. Adatto quando un sistema deve essere creato a partire da sistemi esistenti .

In pratica, si usa una buona combinazione di entrambi gli approcci . La progettazione parallela si muove in spazi di design che includono l'espressione algoritmica (Finding Concurrency, Algorithm structure) e la costruzione del software (Supporting Structures, Implementation Mechanisms) .
