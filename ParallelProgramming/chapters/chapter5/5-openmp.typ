#import "../../../dvd.typ": *

#pagebreak()

= Programmazione Parallela con OpenMP

== Threading Implicito

=== Motivazioni e Filosofia di OpenMP
La programmazione concorrente può essere estremamente complessa se gestita interamente a basso livello. I framework di *implicit threading*, come OpenMP, nascono per nascondere i dettagli più minuziosi della creazione, gestione e sincronizzazione dei *threads*. L'obiettivo principale è permettere al programmatore di parallelizzare un codice sequenziale esistente senza doverlo ristrutturare radicalmente, utilizzando semplicemente delle direttive per il compilatore.

=== L'ecosistema OpenMP
OpenMP non è una semplice libreria, ma un'API completa che comprende tre componenti fondamentali:
- *Compiler Directives:* Istruzioni che guidano il compilatore nella parallelizzazione del codice.
- *Runtime Library Functions:* Funzioni utilizzate per controllare il numero di *threads* o verificare le risorse di sistema.
- *Environment Variables:* Variabili d'ambiente per alterare l'esecuzione dell'applicazione (ad esempio impostando il numero massimo di *threads*).

=== Supporto dei Compilatori
Essendo basato su direttive, OpenMP deve essere supportato dal compilatore. I moderni compilatori C/C++ come GCC, Clang, Intel C++ e Microsoft Visual Studio lo supportano ampiamente. È importante notare che OpenMP è uno standard attivo (la versione 6.0 è stata rilasciata nel novembre 2024) e l'uso di direttive avanzate come `task` o la vettorizzazione *SIMD* richiede versioni specifiche del compilatore.

== Il Modello di Esecuzione e la Coerenza della Memoria

=== Il Modello Fork-Join
OpenMP segue il modello *fork-join*. Il programma inizia come un singolo *main thread* che esegue la porzione seriale del codice. Quando incontra una regione parallela, vengono creati (*fork*) diversi *worker threads* che eseguono il codice simultaneamente. Al termine della regione, i thread attendono in una *implicit barrier* (*join*) e il controllo torna al solo *main thread*.

=== Modelli di Coerenza della Memoria
Il *memory consistency model* è un contratto tra il programmatore e il sistema che definisce come vengono elaborate le operazioni di memoria da più processori.
- *Sequential Consistency (SC):* Richiede che il risultato di un'esecuzione sia lo stesso di un ordine sequenziale delle operazioni di tutti i processori. È un modello semplice per ragionare, ma difficile da mantenere su hardware moderno perché impedisce molte ottimizzazioni del compilatore.
- *Relaxed (Weak) Consistency:* OpenMP adotta questo modello, dove le garanzie di ordine vengono rimosse per le normali letture/scritture e mantenute solo intorno ai punti di sincronizzazione. Gli aggiornamenti fatti da un *thread* non sono garantiti come visibili agli altri finché non viene raggiunto un punto di sincronizzazione come una *barrier* o un'operazione di *flush*.

== Analisi delle Dipendenze e Condizioni di Bernstein

=== Data Race e Dipendenze di Flusso
Il nostro obiettivo principale è scrivere programmi privi di *data races*. Una *race* si verifica quando due o più thread accedono alla stessa locazione di memoria e almeno uno di essi è in scrittura. Le *flow dependences* determinano lo schema di esecuzione: ogni operazione deve attendere che i propri operandi siano prodotti.
#figure(image("images/2026-02-27-13-13-20.png", height: 30%))

=== Le Condizioni di Bernstein
Per decidere se due processi $P_1$ e $P_2$ possono essere eseguiti in parallelo in sicurezza, si utilizzano le *Bernstein's Conditions*. Siano $I$ l'insieme delle locazioni lette e $O$ quelle alterate:
1. $I_1 inter O_2 = emptyset$
2. $I_2 inter O_1 = emptyset$
3. $O_1 inter O_2 = emptyset$
Se queste condizioni sono soddisfatte, la parallelizzazione è certamente sicura. Ad esempio, se $P_1$ calcola `A = x + y` e $P_2$ calcola `B = x + z`, i due sono indipendenti e parallelizzabili. Se invece $P_2$ usasse `A`, avremmo una dipendenza *RAW* (Read-After-Write) che impedirebbe il parallelismo diretto.
#figure(image("images/2026-02-27-13-14-26.png", width: 70%))

=== Parallelizzazione dei Cicli
Un ciclo può essere parallelizzato se ogni ordine di esecuzione del suo corpo produce lo stesso risultato. Ad esempio, un ciclo che esegue `A[i] = A[i-1]` presenta una dipendenza di flusso che ne impone l'esecuzione sequenziale. Al contrario, `A[i] = A[i+1]` può essere parallelizzato utilizzando un array temporaneo di supporto.

== Programmare con OpenMP in C/C++

=== Sintassi delle Direttive
Le direttive OpenMP utilizzano la sintassi `#pragma omp directive [clauses]`. Sono scritte su una singola riga e sono *case sensitive*. Per compilare programmi OpenMP con GCC o Clang, è necessario utilizzare lo switch `-fopenmp`.

#example()[
  Un classico esempio di codice OpenMP prevede l'inclusione di `<omp.h>` e l'uso di funzioni come `omp_get_thread_num()` per identificare il thread e `omp_get_num_threads()` per conoscere il totale del pool.

  ```c
  #pragma omp parallel private(nthreads, tid)
  {
      tid = omp_get_thread_num();
      printf("Hello World dal thread = %d\n", tid);
      if (tid == 0) {
          nthreads = omp_get_num_threads();
          printf("Numero di thread = %d\n", nthreads);
      }
  }
  ```
]


== Gestione dei Dati e Work-sharing

=== Visibilità delle Variabili
Di default, le variabili in OpenMP sono *shared* (condivise), tranne gli indici dei cicli paralleli e le variabili dichiarate all'interno della regione parallela. È possibile forzare la visibilità tramite le clausole `shared` e `private`. Una variabile `private` viene allocata in una copia locale per ogni thread, ma il suo valore iniziale non è definito.

=== Costrutti di Distribuzione del Lavoro
- *Parallel for:* Divide le iterazioni di un ciclo tra i thread. Supporta lo *scheduling static* (blocchi predefiniti) o *dynamic* (i blocchi vengono assegnati ai thread che finiscono prima).
- *Collapse:* Introdotta in OpenMP 3.0, permette di unire cicli annidati in un unico spazio di iterazione più grande per migliorare la scalabilità, a patto che i cicli siano perfettamente annidati e indipendenti.
- *Sections:* Permette di eseguire blocchi di codice diversi (*sections*) in parallelo tra i thread del pool.
- *Single e Masked:* Il costrutto `single` indica che il blocco deve essere eseguito da un solo thread qualsiasi, mentre `master` (rinominato `masked` dalla versione 5.1) riserva l'esecuzione esclusivamente al *main thread*.

== Sincronizzazione e Riduzione

=== Protezione delle Sezioni Critiche
- *Critical:* Garantisce la mutua esclusione; solo un thread alla volta può entrare nella regione protetta. Se le direttive hanno nomi diversi, possono essere eseguite simultaneamente.
- *Atomic:* Ideale per singoli aggiornamenti di variabili (es. incrementi), viene eseguita in modo indivisibile a livello hardware, risultando più efficiente di una sezione critica.

=== Barriere e Lock
Il costrutto `barrier` definisce un punto in cui ogni thread attende l'arrivo di tutti gli altri prima di proseguire, garantendo che tutto il codice precedente sia stato completato. Per un controllo ancora più fine, OpenMP offre funzioni per gestire i *Mutex locks* (come `omp_set_lock`).

=== Meccanismo di Reduction
La clausola `reduction` è fondamentale per calcolare risultati globali (come somme o prodotti) senza l'*overhead* di una sezione critica esplicita. OpenMP crea una variabile privata per ogni thread e, al termine del calcolo, combina i risultati in modo atomico nella variabile condivisa finale. Esempio: `#pragma omp parallel reduction(+:var)`.

== L'Architettura NUMA e la Politica del "First Touch"

I moderni calcolatori paralleli sono basati su architetture NUMA (Non-Uniform Memory Access) 1. In un sistema NUMA, la memoria principale � divisa e fisicamente associata a specifici processori o nodi (socket). Di conseguenza, il tempo di accesso alla memoria varia in base alla posizione fisica dei dati rispetto al core che ne fa richiesta: l'accesso alla memoria locale � significativamente pi� veloce rispetto all'accesso remoto a una memoria collegata a un altro nodo 1, 2.

Per visualizzare i dettagli di un sistema NUMA, inclusa la quantit� di memoria libera per nodo e i core associati, � possibile utilizzare il comando Linux `numactl -H` 1. Questo comando fornisce anche una tabella delle "distanze", che rappresenta le latenze relative per l'accesso incrociato tra i vari nodi 2.

In questo contesto hardware, il kernel del sistema operativo (come ad esempio in Linux) deve decidere dove allocare fisicamente la memoria richiesta da un programma 3. La tecnica pi� comune per gestire questa assegnazione � la cosiddetta politica del *first touch* (primo tocco) 3. Quando un programma dichiara o alloca un array, la memoria inizialmente esiste solo come voce in una tabella di memoria virtuale 3. La memoria fisica vera e propria viene creata e allocata solamente nel momento in cui l'array viene "toccato" per la prima volta, ovvero al suo primo accesso in lettura o scrittura 3. Il sistema operativo allocher� questa memoria nel nodo fisico pi� vicino al thread che ha generato questo primo tocco 3.

=== Il Problema dell'Inizializzazione Sequenziale

La politica del first touch ha implicazioni profonde per i programmi OpenMP. Se un singolo thread (tipicamente il master thread) si occupa di allocare e inizializzare tutta la memoria prima di una regione parallela, l'intera struttura dati verr� posizionata sul singolo nodo NUMA in cui risiede il thread master 2, 4. Quando gli altri thread, distribuiti su CPU diverse, cercheranno di accedere alle proprie porzioni di dati durante le fasi di calcolo, subiranno pesanti penalit� di latenza dovute all'accesso remoto 2, 4.

#example()[

  Per illustrare questo concetto, consideriamo un tipico esempio di *codice senza first touch parallelo*:

  ```cpp
  #define ARRAY\_SIZE 80000000
  static double a[ARRAY\_SIZE], b[ARRAY\_SIZE], c[ARRAY\_SIZE];
  // Inizializzazione sequenziale (eseguita solo dal master thread)
  for (int i=0; i<ARRAY\_SIZE; i++) {
    a[i] = 1.0;
    b[i] = 2.0;
  }

  #pragma omp parallel for
  for (int i=0; i < n; i++) {
    c[i] = a[i] + b[i];
  }
  ```

  Questo stile di implementazione produce prestazioni modeste, poich� tutta la memoria viene allocata vicino al thread principale, creando un collo di bottiglia 4-6.

  La soluzione consiste nel parallelizzare l'inizializzazione dei dati, imitando lo stesso pattern di distribuzione del carico di lavoro che verr� utilizzato successivamente. Ad esempio, introducendo una regione parallela per l'inizializzazione:

  ```cpp
  #pragma omp parallel for schedule(static)
  for (int i=0; i<ARRAY\_SIZE; i++) {
    a[i] = 1.0;
    b[i] = 2.0;
  }
  ```

  In questo modo, ogni thread "toccher�" per primo una specifica "fetta" dell'array a e b, allocandola nella memoria fisica locale del proprio nodo NUMA, garantendo un accesso rapido durante il successivo calcolo parallelo 5, 7. Questa singola accortezza pu� migliorare le prestazioni in modo drammatico, talvolta fino a un fattore 10x 8.
]

== Affinit� dei Thread (Thread Affinity)

Oltre ad allocare la memoria nel posto giusto, � altrettanto importante assicurarsi che il sistema operativo non sposti i thread su processori diversi durante l'esecuzione 9. Legare un thread a una specifica posizione hardware � noto come "thread affinity" e risulta cruciale per massimizzare l'uso della memoria cache e mantenere bassa la latenza e alta la larghezza di banda 9.

OpenMP offre due variabili d'ambiente per controllare questo comportamento 9:

- *`OMP_PLACES`*: Definisce i luoghi (places) in cui i thread possono essere eseguiti 9. I valori possibili includono:
  - sockets: I thread vengono distribuiti sui vari socket (processori fisici) 10.
  - cores: I thread vengono allocati sui singoli core fisici del processore 10.
  - threads: I thread vengono programmati sugli "strands" (i thread hardware generati dall'hyperthreading; ad esempio, un core CPU con hyperthreading ha due strand) 10, 11. In questo contesto, il termine "strand" serve a differenziare i thread software di OpenMP dai thread hardware della CPU 11.
  - Specifiche definite dall'utente, come id numerici degli strand (es. "{0},{8},{16}") 10.
- *`OMP_PROC_BIND`*: Definisce in che modo i thread devono essere mappati sui luoghi definiti da `OMP_PLACES` 9. A partire da OpenMP 4.0, i criteri includono 12:
  - master (rinominato primary in OpenMP 5.1): Schedula i thread nello stesso luogo in cui � in esecuzione il thread principale 12.
  - close: Mantiene i thread il pi� vicini possibile (in termini hardware) 12.
  - spread: Distribuisce i thread il pi� lontano possibile l'uno dall'altro 12.

Come regola pratica generale, l'hyperthreading spesso non apporta grandi benefici a kernel computazionali limitati dalla memoria (memory-bound), ma generalmente non peggiora le prestazioni 8. Al contrario, per funzioni fortemente dipendenti dalla larghezza di banda della memoria su sistemi a socket multipli, occupare attivamente tutti i socket (usando ad esempio `OMP_PROC_BIND=spread`) risulta estremamente vantaggioso 8.

== Ottimizzazione in Quattro Fasi

L'ottimizzazione del codice OpenMP ad alto livello prevede generalmente un processo iterativo diviso in quattro fasi principali 8:

1. *Riduzione dell'overhead di avvio dei thread*: L'avvio di una regione parallela comporta un costo (circa il 10-15% del tempo di esecuzione). � opportuno unire le direttive separate (ad esempio passando da multipli `#pragma omp parallel for` a una singola e pi� estesa regione `#pragma omp parallel` che contiene al suo interno direttive `#pragma omp for`) 8, 13.
2. *Riduzione della sincronizzazione*: I cicli for in OpenMP presentano una barriera implicita alla loro conclusione. Ove la sincronizzazione non sia strettamente necessaria per via dell'indipendenza dei dati, � consigliabile aggiungere la clausola `nowait` 8, 13. Per una rimozione spinta delle barriere, si pu� evitare del tutto il costrutto di work-sharing esplicito del ciclo for e assegnare manualmente le partizioni del ciclo ai thread sfruttando gli identificatori del thread (Thread ID) 8, 13. Questo partizionamento manuale riduce il "cache thrashing" e le race conditions, impedendo ai thread di sovrapporsi nelle medesime regioni di memoria 13.
3. *Ottimizzazione tramite Privatizzazione*: Rendere le variabili private a ciascun thread riduce i vincoli di sincronizzazione 8, 14. Questo aiuta enormemente il compilatore nelle sue ottimizzazioni intrinseche, in quanto non � costretto a considerare eventuali dipendenze complesse su ampi blocchi di codice 14.
4. *Verifica della Correttezza del Codice*: Dopo ogni modifica strutturale, specialmente a seguito della rimozione di barriere o dell'aggiunta di clausole `nowait`, � imperativo verificare l'insorgere di potenziali race conditions utilizzando strumenti dedicati, come ad esempio l'Intel Inspector 8.

== Lo Scope delle Variabili in OpenMP

Un aspetto cruciale, soprattutto nella fase di privatizzazione, riguarda la comprensione dello scope delle variabili. In un costrutto parallelo in C, in generale, le variabili automatiche dichiarate all'interno di un costrutto parallelo, oppure all'interno dello scope di una funzione richiamata dalla regione parallela, sono considerate private 15, 16. Queste variabili risiedono sullo *Stack* della memoria 14, 17, 18. Poich� ogni thread possiede il proprio stack pointer separato, le operazioni su queste variabili godono di grande isolamento e rapidit� d'accesso locale 18.

Al contrario, le variabili allocate dinamicamente (ad esempio con malloc), le variabili con scope a livello di file, o le variabili dichiarate con l'attributo static sono normalmente considerate *condivise* (Shared) 15, 16. Esse risiedono nell'area della memoria denominata *Heap*, la quale � condivisa tra tutti i thread 14, 17, 18. L'accesso a dati nello heap espone al rischio di condizioni di competizione (race conditions) se non viene accuratamente mediato da barriere di sincronizzazione 18, 19.

== Casi Studio sull'Ottimizzazione

=== Caso Studio 1: Ottimizzazione di un'Operazione di Stencil

Per illustrare questi concetti, consideriamo un esempio pratico riguardante un'operazione di stencil su matrici bidimensionali 20. Il calcolo dello stencil agisce su un elemento aggiornando il suo valore basandosi sui nodi adiacenti (sopra, sotto, destra, sinistra).

In un'implementazione avanzata volta a misurare fedelmente le performance e limitare l'overhead, si procede nel seguente modo:Innanzitutto, viene stabilita un'unica regione `#pragma omp parallel` 21. All'interno di essa, ciascun thread ricava il proprio identificativo (`omp_get_thread_num()`) e il numero totale di thread a disposizione 21, 22.Anzich� affidarsi alla direttiva `#pragma omp for`, i limiti del ciclo di lavoro (inizio e fine della fetta di array jltb e jutb) vengono calcolati manualmente mediante formule algebriche basate sul thread\_id 21, 22. Questo approccio assegna ad ogni thread una striscia orizzontale definita della matrice in input, mimando perfettamente il carico parallelo 21, 22.

Il calcolo manuale dei limiti sostituisce completamente le direttive esplicite, rimuovendo le barriere di sincronizzazione implicite che altrimenti rallenterebbero il calcolo ad ogni iterazione 22, 23. Tuttavia, siccome abbiamo rimosso le barriere implicite predefinite, diventa necessario reintrodurre dei blocchi espliciti `#pragma omp barrier` in punti strategici per assicurare che le dipendenze dei dati (le letture necessitino di scritture completate dai passi precedenti) siano rispettate, evitando le race conditions 23, 24.

In aggiunta a queste ottimizzazioni architetturali, OpenMP permette di accoppiare la parallelizzazione multi-threading con il parallelismo a livello di istruzione tramite vettore (SIMD). Introducendo direttive come `#pragma omp simd` all'interno dei cicli computazionali pi� intensivi del calcolo dello stencil, i moderni processori elaborano segmenti di array simultaneamente attraverso registri vettoriali, portando a incrementi prestazionali sostanziali 24.

=== Caso Studio 2: Stencil a Croce Separabile (Split Stencil)

Consideriamo ora un caso pi� complesso: un'operazione su un kernel a forma di croce (split stencil), simile a un kernel Gaussiano, che pu� essere separato e calcolato in due direzioni indipendenti: lungo l'asse X (faccia orizzontale) e lungo l'asse Y (faccia verticale) 25. In fine, i contributi separati di X e Y vengono sommati per formare il risultato definitivo 19.

Dal punto di vista della memoria, vi sono requisiti diametralmente opposti:
- *Accesso sull'asse X*: Se distribuiamo i dati lungo strisce orizzontali assegnate a thread differenti, i calcoli lungo l'asse X seguiranno nativamente questa distribuzione 25. Ogni thread richieder� l'accesso solamente a celle adiacenti lungo l'orizzontale 19. Di conseguenza, il thread pu� avvalersi quasi interamente di variabili private e memoria locale, incrementando esponenzialmente la data locality (vicinanza del dato al processore) 25, 26.
- *Accesso sull'asse Y*: Il calcolo verticale richiede inevitabilmente di attraversare le "strisce" orizzontali adiacenti 19. Per calcolare gli elementi ai bordi della propria partizione, un thread dovr� leggere dati elaborati da thread confinanti. Diventa perci� obbligatorio utilizzare dati in uno scope condiviso (shared) 19, 25.

Nel codice che definisce la funzione SplitStencil, l'allocazione della memoria rispecchia questa dicotomia logica 26, 27. Per le facce X (xface), il thread alloca la matrice nello stack, rendendola locale e privata; questa memoria sar� di dimensioni ridotte perch� contiene solo la striscia pertinente al singolo thread 28, 29. Per le facce Y (yface), viene allocata una matrice dichiarata con static (memoria Heap), condivisa tra tutti, la quale � invece sufficientemente ampia da ospitare l'intero dominio computazionale 18, 27-29. Essendo una variabile condivisa, il codice garantisce che un solo thread principale provveda ad allocarla (ad esempio controllando if (thread\_id == 0)) 27, 30.

Proprio per via della convivenza di questi due domini di memoria, la gestione delle barriere � della massima criticit� 19.L'allocazione condivisa deve essere immediatamente seguita da un `#pragma omp barrier`: altrimenti, altri thread potrebbero iniziare i calcoli cercando di scrivere su una memoria condivisa non ancora pronta o inesistente 27-29. Successivamente, i calcoli per l'asse X non richiedono sincronizzazione poich� confinati nello stack privato 29. Al contrario, un'altra barriera � assolutamente vitale dopo aver riempito la matrice yface 27, 28. Senza di essa, insorgerebbe una violenta race condition, dove thread limitrofi inizierebbero a calcolare la somma finale sfruttando dati dell'asse Y non ancora completamente aggiornati 19, 28, 29.

Come dimostra questo esempio avanzato, l'uso massiccio di memoria locale porta a vantaggi enormi, innescando talvolta un fenomeno definito come speedup super-lineare (grazie alla migliore interazione con l'architettura della memoria cache), a patto che i punti di contatto condivisi tra thread vengano mediati da barriere minimali, esplicite ed efficienti 28.

== Analisi e Debugging del Codice Concorrente

Lo sviluppo di applicazioni parallele in ambienti a memoria condivisa introduce sfide notevoli rispetto alla programmazione sequenziale tradizionale. Tra le problematiche pi� insidiose e complesse da individuare vi sono i difetti legati alla sincronizzazione dei thread, che possono portare a comportamenti imprevedibili e risultati errati. Questo capitolo esplora gli strumenti diagnostici avanzati a disposizione degli sviluppatori C/C++, con un'attenzione particolare al Thread Sanitizer e alle sue applicazioni in ambienti multi-threading e OpenMP.

=== La Sfida delle "Data Race"

Prima di addentrarci negli strumenti di debugging, � fondamentale definire con precisione l'errore pi� comune e pericoloso nella programmazione parallela: la **Data Race** (condizione di competizione sui dati) 1.

Una data race si verifica rigorosamente quando si presentano tre condizioni contemporaneamente:

1. Almeno due thread differenti accedono alla medesima variabile o porzione di memoria condivisa.
2. Almeno uno di questi thread sta effettuando un'operazione di scrittura (modifica della variabile).
3. Gli accessi avvengono in modo concorrente, ovvero senza l'utilizzo di un meccanismo di sincronizzazione adeguato (come mutex, semafori o barriere) 1, 2.

Le data race sono estremamente pericolose poich� introducono un comportamento **non deterministico** nel programma 2. A seconda di minime e impercettibili variazioni nelle tempistiche di esecuzione dettate dal sistema operativo, il programma pu� produrre risultati corretti in un'esecuzione e risultati completamente errati o persino corruzione della memoria in quella successiva 1. Di conseguenza, questi bug sono proverbialmente difficili da isolare utilizzando i classici debugger (come GDB), poich� il semplice rallentamento indotto dal debugger stesso spesso nasconde o altera le condizioni temporali che scatenano la data race.

== Thread Sanitizer (TSan): Uno Strumento Fondamentale

Per affrontare queste sfide strutturali, la comunit� di sviluppo si affida ai "sanitizer", strumenti diagnostici integrati direttamente nel compilatore. Il **Thread Sanitizer**, comunemente abbreviato in **TSan**, � un potente strumento basato sull'infrastruttura LLVM (ed � disponibile a partire dalla versione 5 di GCC), progettato specificamente per rilevare le data race a runtime (durante l'esecuzione) nei linguaggi C e C++ 1, 3. Le sue funzionalit�, inoltre, sono state estese per supportare anche linguaggi moderni come Go e Swift 2.

Oltre a individuare le accessi concorrenti non protetti, TSan � in grado di rilevare ulteriori anomalie legate alla gestione dei thread, come deadlock (situazioni di stallo in cui due o pi� thread si bloccano a vicenda in attesa di risorse), l'uso di mutex non inizializzati e i "thread leak", ovvero la mancata terminazione e pulizia dei thread allocati 1.

=== Il Funzionamento Interno di TSan

Ci� che rende TSan eccezionalmente efficace � la sua indipendenza dalle esatte tempistiche fisiche di esecuzione. TSan non si limita a osservare passivamente i thread, ma trasforma attivamente il codice durante la fase di compilazione 3.

Per illustrare questo concetto vitale, consideriamo la modifica strutturale che TSan applica a un semplice accesso in memoria. Se nel codice originale abbiamo un'istruzione di assegnazione:

// Codice originale (Prima)

\*address = ...;

Il compilatore inietter� automaticamente una chiamata a una speciale funzione di tracciamento prima di ogni operazione sulla memoria:

// Codice strumentato da TSan (Dopo)

RecordAndCheckWrite(address);

\*address = ...;

Inoltre, per implementare il controllo, ogni thread mantiene un proprio **timestamp** (marcatore temporale) locale, oltre a memorizzare i timestamp conosciuti degli altri thread con cui ha stabilito dei punti di sincronizzazione formali 3. Ogni volta che una variabile viene letta o scritta, il timestamp del thread corrente viene incrementato.

La funzione RecordAndCheckWrite confronta la storia degli accessi memorizzata per quell'indirizzo: se scopre che un thread ha letto o scritto il dato e, in assenza di regole di sincronizzazione intermedie, un altro thread sta tentando una scrittura in quel momento logico, segnala immediatamente la violazione. **Di conseguenza**, incrociando questi dati storici, TSan pu� rilevare una data race anche se, in quella specifica esecuzione del programma, l'errore non si � fisicamente manifestato in modo distruttivo 3, 5.

=== Utilizzo Pratico, Impatto sulle Prestazioni e Limitazioni

L'abilitazione di Thread Sanitizer avviene aggiungendo una specifica direttiva in fase di build. � essenziale sottolineare che il flag -fsanitize=thread deve essere passato contemporaneamente sia al **compilatore** (per trasformare il codice) sia al **linker** (per collegare la libreria di runtime dedicata di TSan) 6.

Per illustrare il processo, consideriamo questo comando tipico di compilazione:

clang++ -fsanitize=thread -std=c++11 -pthread -g -O1

In questo esempio, compiliamo un codice C++11 con supporto ai thread Posix (-pthread), richiedendo a TSan di analizzare il programma 7.

L'utilizzo di TSan, per via del massiccio tracciamento delle operazioni in memoria, comporta un **impatto prestazionale severo**. L'esecuzione del codice strumentato subisce tipicamente un rallentamento della CPU (slowdown) compreso tra 2x e 20x. Inoltre, a causa della necessit� di memorizzare la cronologia dei thread e i timestamp associati a ogni indirizzo, l'utilizzo della memoria RAM pu� gonfiarsi di un fattore variabile tra 5x e 10x 7, 8. Per mitigare in parte questo overhead su CPU e memoria, � caldamente consigliato abilitare un livello di ottimizzazione moderato, compilando con i flag -O1 o -O2 7.

=== Esecuzione e Analisi dei Risultati

Poich� TSan agisce a runtime, gli errori non vengono intercettati durante la compilazione, ma durante l'esecuzione del file binario generato (es. ./a.out) 6.

Un ostacolo tecnico peculiare che si presenta sui sistemi operativi Linux riguarda l'**ASLR** (Address Space Layout Randomization), una tecnica di sicurezza che randomizza la disposizione della memoria. Se questa funzionalit� � attiva, TSan fallir� inevitabilmente la sua esecuzione. Al fine di poter procedere al test, l'ASLR deve essere temporaneamente disabilitato invocando il programma in questo modo:setarch `$(uname -m) -R ./my-executableIl parametro -R` istruisce esplicitamente il sistema di disabilitare la randomizzazione per quello specifico eseguibile 7.

Quando TSan rileva un problema, arrester� il processo stampando a terminale un log dettagliato (detto *stack trace*). Ad esempio:

WARNING: ThreadSanitizer: data race (pid=19219)

Write of size 4 at 0x7fcf47b21bc0 by thread T1:

#0 Thread1 tiny\_race.c:4 ...

Previous write of size 4 at 0x7fcf47b21bc0 by main thread:

#0 main tiny\_race.c:10 ...

Questo log indica chiaramente allo sviluppatore dove � avvenuto l'errore (la scrittura da parte del "thread T1" alla riga 4 del file tiny\_race.c), e lo mette in correlazione logica con l'azione conflittuale precedente (effettuata dal "main thread" alla riga 10) e perfino con il momento esatto in cui il thread incriminato � stato creato 6, 9. Moderni ambienti di sviluppo integrati (IDE), come JetBrains CLion, sono ormai in grado di effettuare il parsing (lettura automatica) di questi output, mostrando visivamente gli errori direttamente nell'interfaccia grafica dell'editor del codice 3.

== Misurazione delle Prestazioni e Profilazione in Ambienti a Memoria Condivisa
Lo sviluppo di applicazioni parallele efficaci richiede non solo la corretta implementazione degli algoritmi, ma anche una rigorosa validazione delle prestazioni ottenute. Prima di poter ottimizzare un codice, � imperativo capire esattamente dove e in che modo il programma consuma il tempo di elaborazione. Questo capitolo affronta due pilastri fondamentali dell'ingegneria del software ad alte prestazioni: il **Timing** (la misurazione accurata del tempo di esecuzione) e il **Profiling** (l'identificazione dei segmenti di codice computazionalmente pi� onerosi), per poi concludere con un'analisi dei colli di bottiglia pi� comuni 1-3.
== La Misurazione del Tempo (Timing)
La prima necessit� che sorge quando si parallelizza un frammento di codice sequenziale � valutare l'effettivo guadagno prestazionale (speedup). Per farlo, occorre misurare il tempo impiegato da entrambe le versioni del codice. Tuttavia, la scelta dello strumento di misurazione � un passaggio critico e spesso foriero di errori metodologici 1.

In un tipico codice sorgente scritto in C, utilizzando la libreria standard , il primo approccio � spesso quello di utilizzare la funzione `clock()`. Questa funzione restituisce un'approssimazione del "tempo di processore" (CPU time) utilizzato dal processo a partire da un'epoca predefinita legata all'inizio dell'esecuzione del programma [1, 4]. Poich� il valore restituito non � assoluto, l'unico modo sensato per utilizzarlo � calcolare la differenza tra due chiamate alla funzione e dividere il risultato per la costante `CLOCKS\_PER\_SEC` per ottenere i secondi [4]. In un programma strettamente sequenziale, il tempo di processore coincide in modo ragionevole con il tempo di esecuzione effettivo del programma [5]. Tuttavia, l'uso di `clock()` in un programma parallelo multi-thread porta a misurazioni completamente fuorvianti [5]. Per illustrare questo concetto vitale, consideriamo un esempio pratico. Supponiamo di avere un codice sequenziale che impiega 1 secondo per terminare, e supponiamo di parallelizzarlo in modo ideale su quattro thread. Ciascun thread impiegher� $frac(1,4)$ del tempo originario (0.25 secondi) per concludere la propria frazione di lavoro. In questo scenario, la funzione `clock()` sommer� il tempo di CPU speso da \*tutti\* i thread concorrenti. Il calcolo sar� pertanto $4 times 0.25 = 1$. Il tempo restituito sar� identico a quello del programma sequenziale [5]. Peggiorando ulteriormente le cose, la creazione e la gestione dei thread introducono un \*\*overhead\*\* (costo operativo) inevitabile. Di conseguenza, il tempo effettivo di CPU misurato sar� addirittura superiore a quello impiegato dalla variante sequenziale [6]. \*\*Regola fondamentale:\*\* La funzione `clock()` non deve mai essere utilizzata per confrontare i tempi di esecuzione tra un codice sequenziale e uno parallelo [7].

=== Il Tempo Reale: Wall-Clock Time
La metrica corretta per valutare le prestazioni assolute di un programma parallelo � il tempo reale trascorso, comunemente definito come \*\*Wall-Clock Time\*\* (il "tempo dell'orologio appeso al muro") [7]. Questa metrica calcola esattamente quanto tempo fisico � passato dall'inizio alla fine di un blocco di istruzioni. Va notato che il "clock time" (tempo di CPU) e il "wall-clock time" procedono a velocit� differenti in base a come il sistema operativo (OS) distribuisce le risorse. Se la CPU � contesa tra molteplici processi di sistema, il tempo di CPU avanzer� pi� lentamente del wall-clock. Al contrario, se il nostro processo ha a disposizione molteplici core (come in un programma OpenMP), il tempo totale di CPU misurato avanzer� molto pi� rapidamente del tempo fisico [7].

=== Strumenti per la Misurazione del Wall-Clock Time
Per ottenere il wall-clock time, i programmatori hanno a disposizione diverse funzioni di sistema: 1. \*\*`gettimeofday()` e `time()`\*\*: Presenti nell'intestazione , queste chiamate di sistema (system call) ottengono l'ora dal sistema operativo. time() ha una risoluzione al secondo, mentre gettimeofday() arriva ai microsecondi. Tuttavia, la loro accuratezza � definita "non specificata" dallo standard 8, 9. 2. **clock\_gettime()**: Secondo i recenti standard POSIX, gettimeofday � da considerarsi obsoleto e dovrebbe essere sostituito da clock\_gettime, il quale garantisce una risoluzione al nanosecondo. Una best-practice � verificare la disponibilit� di questa funzione (ad esempio, su macOS � stata introdotta solo dalla versione 10.12) e usarla come scelta prioritaria, ripiegando su gettimeofday se non presente 8, 9. 3. **Alternative Moderne**: Utilizzando C++11, la libreria standard offre std::chrono::high\_resolution\_clock. Infine, per i programmi che sfruttano lo standard OpenMP, esiste la comodissima funzione omp\_get\_wtime(), la quale restituisce un valore di tipo double che rappresenta i secondi trascorsi da un determinato istante nel passato 2.
== Introduzione alla Profilazione del Codice
La misurazione del tempo totale indica *se* un programma � lento, ma non dice *dove* lo sia. Per questa finalit� interviene la **Profilazione** (Profiling), una tecnica che permette di identificare quali specifiche porzioni di un programma assorbono maggior tempo e risorse, evidenziando i candidati ideali per l'ottimizzazione e la parallelizzazione 2. I profiler operano tipicamente mediante **campionamento** (sampling): interrompono periodicamente l'esecuzione del programma (ad esempio, 100 volte al secondo), registrano quale funzione � attualmente in esecuzione (contando quante volte un'istruzione viene letta) e calcolano il tempo impiegato 2. Esistono numerosi strumenti specializzati in base al linguaggio: VisualVM per Java, Scalasca o VTune per OpenMP/MPI, NVProf per CUDA 10. Nel contesto della programmazione C/C++, due degli strumenti pi� adottati in ambiente Linux/Unix sono Google Perftools e Callgrind 11, 12.
=== Google Perftools (pprof)
Google Perftools (in particolare lo strumento pprof abbinato alla libreria libprofiler) � un profiler basato sul campionamento a bassissimo overhead 12. L'utilizzo classico richiede i seguenti passaggi: 1. Compilare e linkare l'eseguibile aggiungendo il flag -lprofiler. 2. Eseguire il programma impostando la variabile d'ambiente che definisce il file di output: CPUPROFILE=/tmp/prof.out ./mio\_eseguibile. � anche possibile variare la frequenza di campionamento (il default � 100Hz) usando la variabile CPUPROFILE\_FREQUENCY 12, 13. 3. Analizzare il report generato invocando il comando pprof --text ./mio\_eseguibile /tmp/prof.out 13. Per evitare di dover ricompilare il codice unicamente per linkare la libreria, � possibile caricare libprofiler dinamicamente a runtime impostando la variabile LD\_PRELOAD=/path/to/libprofiler.so.0 su Linux (o DYLD\_INSERT\_LIBRARIES su macOS) al momento dell'esecuzione 14, 15. L'analisi testuale prodotta da pprof si presenta in forma tabellare. Ad esempio 15-17: text Total: 311 samples 144 46.3% 46.3% 144 46.3% bar 95 30.5% 76.8% 95 30.5% foo 72 23.2% 100.0% 311 100.0% baz Le colonne, lette da sinistra a destra, indicano rispettivamente: i campionamenti rilevati esclusivamente dentro la funzione, la percentuale relativa al totale, la percentuale cumulativa delle funzioni elencate fino a quel momento, i campionamenti totali (includendo le sotto-funzioni chiamate da questa) e infine il nome della funzione (es. bar e foo) 17. *(Nota per utenti macOS: per visualizzare correttamente i nomi delle funzioni, il programma deve essere compilato disabilitando l'ASLR tramite il flag -Wl,-no\_pie)* 16. Oltre alla visione d'insieme, pprof supporta un'analisi granulare riga per riga tramite il parametro --list=nome\_funzione. Ad esempio, interrogando una funzione thread\_scan, il profiler restituir� il codice sorgente affiancato dal numero di campionamenti per ogni singola istruzione, permettendo di identificare con precisione chirurgica cicli o formule particolarmente lenti (come chiamate atomiche o accessi ripetuti alla memoria) 17, 18.
=== Analisi Dettagliata con Valgrind e Callgrind
Un'alternativa formidabile a pprof � **Callgrind**, un componente della suite Valgrind 19. A differenza di Google Perftools, Callgrind non sfrutta il campionamento, ma "strumenta" (innesca dinamicamente) l'eseguibile traducendo le istruzioni macchina al volo. Di conseguenza, pur essendo significativamente pi� lento in fase di esecuzione, fornisce una precisione assoluta sugli accessi e le letture delle istruzioni 19. Un enorme vantaggio � che non richiede alcuna ricompilazione del codice originale 19. Per utilizzarlo, si lancia il comando valgrind --tool=callgrind ./eseguibile, il quale produce un file di tracciamento callgrind.out. 19. Questo file pu� essere esplorato graficamente con interfacce come KCachegrind, oppure ispezionato da terminale con callgrind\_annotate --auto=yes per avere un'analisi riga per riga 19-21. Per illustrare l'accuratezza di Callgrind, si consideri l'output generato analizzando un algoritmo di ordinamento selection\_sort 21: c 2,005,000 for(int i = start+1; i <= stop; i++) 4,995,000 if (arr[i] < arr[min]) In questo esempio, Callgrind riporta esattamente che l'istruzione condizionale if � stata valutata quasi 5 milioni di volte durante il processo di ordinamento, fornendo dati inoppugnabili su dove il processore impegni i suoi cicli di lavoro 21.
=== Profilazione della Memoria Cache
I processori moderni traggono gran parte delle loro prestazioni dalla gerarchia di memoria Cache (L1, L2, L3). Callgrind permette di simulare il comportamento di queste cache passando il parametro --simulate-cache=yes 22. Questa simulazione modella un'architettura divisa per la cache L1 (Dati separati dalle Istruzioni) e unificata per la L2 23. Il report finale presenta metriche critiche sotto forma di acronimi 23: \* **Ir / Dr / Dw**: Letture Istruzioni (Instruction reads), Letture Dati (Data reads), Scritture Dati (Data writes). \* **I1mr / D1mr / D1mw**: "Miss" (mancati riscontri) nella cache L1 per Istruzioni (I) e Dati (D, lettura e scrittura). Se un dato non � in L1, deve essere recuperato dalla cache L2. \* **I2mr / D2mr / D2mw**: Miss nella cache L2. Questo � lo scenario peggiore: l'informazione non � n� in L1 n� in L2 e la CPU � costretta a recuperarla dalla lentissima memoria RAM principale 23. L'identificazione dei cosiddetti "L2 misses" � vitale. Tali eventi comportano un costo temporale enormemente superiore rispetto ai miss in L1. Un profiler pu� evidenziarli filtrando l'output di annotazione (es. callgrind\_annotate --show=D2mr --sort=D2mr), mettendo in luce le porzioni di codice affette da scarsa localit� spaziale o temporale 24. In ambito di strumenti complessi, si menziona anche **Intel VTune** (parte del toolkit oneAPI, disponibile gratuitamente), che unisce la profilazione computazionale e della memoria in un unico e potente ambiente grafico professionale 3, 24, 25.
=== Best Practices Operative per la Profilazione
1. **Ottimizzazione del Compilatore:** Al contrario delle sessioni di debugging, che richiedono l'assenza di ottimizzazioni, il profiling deve essere effettuato su eseguibili compilati in modalit� di rilascio con le dovute ottimizzazioni (es. flag -O2 o -O3). Solo cos� si individueranno i colli di bottiglia del codice finale 26. 2. **Limiti del campionamento CPU:** Strumenti come Callgrind e Perftools misurano cicli CPU. Se il collo di bottiglia del programma � la scrittura su un disco rigido o la lettura da un socket di rete, queste latenze non figureranno nel profilo CPU 26. 3. **Varianza dell'input:** Le performance di un algoritmo mutano drasticamente al variare delle dimensioni dell'input. � fondamentale testare scenari diversi per catturare il comportamento asintotico del sistema 26.
== Identificazione dei Bottlenecks
La parallelizzazione multi-thread di un programma � efficace unicamente se si agisce sui colli di bottiglia computazionali. L'aggiunta di thread indiscriminatamente porta quasi sempre a un degradamento delle prestazioni 3. I tre colli di bottiglia fondamentali sono:
=== Operazioni di Input/Output (I/O)
L'accesso a componenti hardware esterne (dischi rigidi, telecamere, moduli Bluetooth, connessioni di rete) obbliga il thread chiamante a entrare in uno stato di attesa inattiva ("wait") 3. L'hardware di I/O � decine di migliaia di volte pi� lento della CPU. Pertanto, suddividere il lavoro tra thread non comporter� alcun vantaggio in porzioni di codice limitate dall'I/O (I/O Bound), a meno che i thread non siano progettati in modo asincrono per poter svolgere calcoli indipendenti in background mentre attendono i dati 3.
=== Contesa della Memoria (Memory Contention)
Questo fenomeno si verifica quando pi� unit� di calcolo (core) tentano di accedere in modo simultaneo (in lettura e, soprattutto, in scrittura) alle medesime linee o bus di memoria. L'hardware sar� costretto a serializzare e intrecciare le richieste, ponendo di fatto i core in attesa e neutralizzando i benefici del parallelismo (efficienza ridotta a causa della sincronizzazione hardware implicita) 27.
=== L'Overhead di Gestione dei Thread
L'istanziazione (creazione) di un thread, il salvataggio dei suoi registri (context switch) e la sua distruzione hanno un preciso e misurabile costo computazionale imposto dal sistema operativo 27. Per illustrare questo concetto, consideriamo un ciclo for banale suddiviso su decine di thread: se il lavoro che ogni thread deve compiere richiede un milionesimo di secondo, ma il sistema operativo impiega un decimo di millisecondo per istanziare e terminare il thread, l'applicazione sar� enormemente rallentata. Il lavoro delegato al thread deve essere computazionalmente sostanzioso per giustificarne il ciclo vitale. Al fine di abbattere drasticamente questi costi, l'ingegneria del software ricorre alla struttura del **Thread Pool**: un pool (serbatoio) di thread viene creato una singola volta all'inizio dell'esecuzione del programma e mantenuto dormiente. Tali thread vengono di volta in volta risvegliati, riutilizzati per differenti cicli di lavoro e rimessi a riposo, evitando cos� i costi continui di istanziazione e distruzione 27.
