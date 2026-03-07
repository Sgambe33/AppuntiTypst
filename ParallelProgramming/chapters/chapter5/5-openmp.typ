#import "../../../dvd.typ": *

#pagebreak()


= Programmazione parallela con OpenMP

Nel panorama del calcolo ad alte prestazioni, lo sviluppo di applicazioni concorrenti impone spesso agli ingegneri del software la gestione di dettagli a basso livello, quali la creazione, l'orchestrazione e la sincronizzazione manuale dei *thread*. I framework di *implicit threading*, come OpenMP (Open Multi-Processing), nascono per nascondere questi dettagli implementativi, delegando al compilatore e al sistema a tempo di esecuzione (*runtime*) l'onere della parallelizzazione.

OpenMP si afferma come l'interfaccia di programmazione (API) di riferimento per lo sviluppo su architetture a memoria condivisa nei linguaggi C, C++ e Fortran. L'aspetto rivoluzionario di OpenMP risiede nella sua natura non intrusiva: l'obiettivo principale è permettere al programmatore di parallelizzare un codice sequenziale esistente senza doverlo ristrutturare radicalmente.

L'ecosistema OpenMP non è una semplice libreria, ma un'API completa formata da:
- *Compiler Directives (Direttive di compilazione):* Istruzioni (`#pragma`) che guidano il compilatore nella parallelizzazione del codice. Se il compilatore non supporta OpenMP (o se le direttive vengono ignorate), il programma manterrà la sua struttura originaria e verrà eseguito in modo puramente sequenziale.
- *Runtime Library Functions:* Funzioni chiamabili dal codice per controllare l'ambiente (es. identificare il thread o verificare il numero di processori).
- *Environment Variables:* Variabili d'ambiente esterne per alterare l'esecuzione dell'applicazione (es. impostare il numero massimo di thread attivi).

Essendo basato su direttive, OpenMP deve essere supportato dal compilatore (come GCC, Clang, Intel C++ e Microsoft Visual Studio). L'uso di direttive avanzate richiede versioni specifiche dello standard (attualmente attivo e in continuo aggiornamento).

== Il modello di esecuzione e la coerenza della memoria

=== Il modello Fork-Join
L'architettura logica di OpenMP si fonda sul modello di esecuzione *Fork-Join*.
All'avvio dell'applicazione, vi è un unico thread in esecuzione, denominato *Master thread* (o *main thread*), che esegue la porzione seriale del codice.
Nel momento in cui questo incontra una direttiva che definisce una regione parallela, avviene l'operazione di *Fork*: il master crea (o risveglia da un *pool*) un gruppo di *worker threads*. Il carico di lavoro viene suddiviso e i thread eseguono il codice simultaneamente.
Al termine della regione, si innesca l'operazione di *Join*: i thread raggiungono una barriera implicita di sincronizzazione (*implicit barrier*), si ricongiungono, e il controllo torna esclusivamente al *Master thread*, che riprende l'esecuzione seriale.


=== Modelli di coerenza della memoria
Il *memory consistency model* è un contratto tra il programmatore e il sistema che definisce come vengono elaborate le operazioni di memoria da più processori.
- *Sequential Consistency (SC):* Richiede che il risultato di un'esecuzione sia lo stesso di un ordine sequenziale delle operazioni di tutti i processori. È semplice a livello logico, ma penalizza le prestazioni impedendo l'uso efficiente delle cache.
- *Relaxed (Weak) Consistency:* OpenMP adotta questo modello. Le operazioni di scrittura effettuate da un thread su una variabile condivisa potrebbero risiedere temporaneamente nei registri o nelle cache ultra-veloci, non risultando immediatamente visibili agli altri. Le garanzie di ordine vengono mantenute solo intorno ai punti di sincronizzazione.

Qualora si renda necessario forzare la CPU a scaricare fisicamente i dati nella memoria principale, si utilizza la direttiva `#pragma omp flush(variabile)`. Tuttavia, l'invocazione esplicita è sconsigliata per il rischio di bug; OpenMP innesca automaticamente un "flush implicito" in corrispondenza di barriere e sezioni protette.

== Analisi delle dipendenze e condizioni di Bernstein

=== Data race e dipendenze di Flusso
L'esecuzione concorrente introduce il rischio delle *Data Races* (Condizioni di Competizione), ovvero collisioni che si verificano quando due o più thread accedono alla stessa locazione di memoria e almeno uno di essi è in scrittura. Il nostro obiettivo è scrivere programmi privi di *data races*.

Le *flow dependences* determinano lo schema di esecuzione: ogni operazione deve attendere che i propri operandi siano prodotti.
#figure(image("images/2026-02-27-13-13-20.png", height: 30%))

=== Le condizioni di Bernstein
Per decidere se due processi o istruzioni possono essere eseguiti in parallelo in sicurezza, si utilizzano le *condizioni di Bernstein*. Siano $I$ l'insieme delle locazioni lette (*Input*) e $O$ quelle alterate (*Output*):
1. $I_1 inter O_2 = emptyset$
2. $I_2 inter O_1 = emptyset$
3. $O_1 inter O_2 = emptyset$

Se queste condizioni sono soddisfatte, la parallelizzazione è certamente sicura.

#example()[
  Se $P_1$ calcola `A = x + y` e $P_2$ calcola `B = x + z`, i due processi sono indipendenti e parallelizzabili. Se invece $P_2$ usasse la variabile `A`, avremmo una dipendenza *RAW* (Read-After-Write) che violerebbe le condizioni, impedendo il parallelismo diretto.
  #figure(image("images/2026-02-27-13-14-26.png", width: 70%))
]

=== Parallelizzazione dei cicli
Un ciclo può essere parallelizzato se ogni ordine di esecuzione del suo corpo produce lo stesso risultato. Ad esempio, un ciclo che esegue `A[i] = A[i-1]` presenta una dipendenza di flusso che ne impone l'esecuzione sequenziale. Al contrario, `A[i] = A[i+1]` può essere parallelizzato utilizzando un array temporaneo di supporto.

== Sintassi e gestione dei dati

=== Sintassi delle direttive e regioni parallele
Le direttive OpenMP utilizzano le direttive del preprocessore. Sono scritte su una singola riga (o spezzate con `\`) e sono *case sensitive*. Per compilare con GCC o Clang, è necessario utilizzare lo switch `-fopenmp`.
La sintassi generale è: `#pragma omp directive [clauses]`.

La direttiva fondamentale è `#pragma omp parallel`, che definisce il blocco strutturato in cui avviene il *Fork* dei thread.

#example()[
  Esempio di "Hello World". Include `<omp.h>` e usa funzioni di *runtime* come `omp_get_thread_num()`:

  ```c
  #include <omp.h>
  #include <stdio.h>

  int main() {
      int nthreads, tid;

      #pragma omp parallel private(nthreads, tid)
      {
          tid = omp_get_thread_num();
          printf("Hello World dal thread = %d\n", tid);

          if (tid == 0) { // Solo il Master thread
              nthreads = omp_get_num_threads();
              printf("Numero totale di thread = %d\n", nthreads);
          }
      }
      return 0;
  }
  ```
]

=== Visibilità delle variabili
Poiché OpenMP opera su una memoria condivisa, è imperativo definire lo "scope" di ogni variabile referenziata nel blocco parallelo tramite specifiche clausole:

- *shared:* I thread del team accedono e modificano la medesima variabile originale allocata nella memoria condivisa. (È il comportamento di default per le variabili dichiarate fuori dal blocco).
- *private:* Viene creata una nuova istanza locale, non inizializzata, per ogni singolo thread.
- *firstprivate:* Inizializza la copia privata con il valore che la variabile globale possedeva prima di entrare nel blocco parallelo.
- *lastprivate:* Sovrascrive la variabile globale originaria con il valore calcolato dall'ultimo thread che ha eseguito l'iterazione finale.
- *default(none):* Annulla le regole predefinite, costringendo il programmatore a dichiarare esplicitamente lo scope di ogni singola variabile. È considerata un'ottima pratica di ingegneria del software.


== Work-sharing

Mentre la direttiva `parallel` replica l'esecuzione dell'intero blocco su tutti i thread, i costrutti di *work-sharing* dividono il carico computazionale.

=== Parallel for e schedulazione
Il costrutto `#pragma omp for` (spesso fuso in `#pragma omp parallel for`) suddivide le iterazioni di un ciclo. La distribuzione è governata dalla clausola `schedule`:

- *schedule(static):* Lo spazio delle iterazioni viene diviso in blocchi (chunks) predefiniti e assegnati a priori ai thread (logica round-robin). Ottimale se ogni iterazione impiega lo stesso tempo di calcolo.
- *schedule(dynamic):* I thread richiedono l'assegnazione dei blocchi a tempo di esecuzione. Indispensabile per bilanciare dinamicamente i carichi di lavoro eterogenei o sbilanciati.

=== La clausola collapse
In presenza di cicli annidati (es. calcolo su matrici quadrate), OpenMP parallelizza di default solo il ciclo esterno. Se i cicli sono perfettamente annidati, la clausola `collapse(n)` fonde $n$ indici in un unico grande spazio iterativo. Ciò riduce la granularità del calcolo per il singolo thread, aumentando drasticamente la scalabilità.

=== Sections, single e master

- *sections:* Permette di eseguire procedure diverse e indipendenti concorrentemente. Il blocco è diviso da sottomarcatori `#pragma omp section`.
- *single:* Indica che il blocco di codice deve essere eseguito da *un solo thread qualsiasi* (es. operazioni di I/O). Gli altri thread attendono alla barriera implicita finale.
- *master (o masked):* Riserva l'esecuzione esclusivamente al *Master thread* (id 0), senza inserire alcuna barriera di attesa per gli altri thread.


== Il modello a Task per problemi irregolari

I costrutti basati su `for` richiedono di conoscere a priori il numero totale di iterazioni. Per i "problemi irregolari" (attraversamento di liste concatenate, algoritmi ricorsivi, cicli `while`), OpenMP ha introdotto i *Task*.

Un Task (`#pragma omp task`) è un'unità indipendente di lavoro. Quando un thread incontra questa direttiva, impacchetta l'istruzione e i dati e li accoda; il *runtime* deciderà quando e quale thread eseguirà il task.
La direttiva `#pragma omp taskwait` costringe il thread chiamante a fermarsi finché tutti i task figli da lui generati non sono conclusi.

#example()[
  *Caso d'uso: Pointer Chasing.* Un singolo thread usa un `while` per scorrere una lista. Per ogni nodo visitato, genera un nuovo task:

  ```c
  #pragma omp single
  {
      while (my_pointer != NULL) {
          #pragma omp task firstprivate(my_pointer)
          process_node(my_pointer);

          my_pointer = my_pointer->next;
      }
  }
  ```

  L'uso di `firstprivate` assicura che ogni task riceva il puntatore corretto prima che il thread generatore lo modifichi per passare al nodo successivo.
]

== Sincronizzazione, mutua esclusione e riduzione

=== Barriere
Il costrutto `#pragma omp barrier` definisce un punto logico in cui tutti i thread devono obbligatoriamente fermarsi e attendere l'arrivo degli altri prima di procedere. Molti costrutti (come `for` o `single`) possiedono barriere implicite alla loro chiusura, disabilitabili aggiungendo la clausola `nowait`.
#figure(image("images/2026-03-06-12-30-01.png", width: 40%))

=== Protezione delle sezioni critiche (Critical e Atomic)
Per proteggere porzioni di codice soggette a Data Races, si implementa la mutua esclusione:

- *critical:* Garantisce che il codice racchiuso sia eseguito da un solo thread per volta. È possibile assegnare nomi (`#pragma omp critical [nome]`) per avere sezioni critiche indipendenti processabili simultaneamente. Un annidamento errato può però causare *Deadlock*.
#figure(image("images/2026-03-06-12-30-59.png", width: 50%))
- *atomic:* Ideale per singoli aggiornamenti aritmetici (es. `x++`). Viene tradotta in istruzioni hardware native indivisibili, risultando enormemente più efficiente di una sezione critica generica.
#figure(image("images/2026-03-06-12-31-23.png", width: 50%))

=== Meccanismo di reduction
Per aggregare un risultato globale (es. la somma progressiva di un vettore), l'uso di `critical` o `atomic` in un ciclo creerebbe un collo di bottiglia.
La clausola `reduction(operatore:variabile)` risolve il problema: il *runtime* istanzia una copia privata della variabile per ogni thread (inizializzata all'elemento neutro, es. 0 per l'addizione). I thread calcolano i sub-totali nei propri registri privati senza alcun lock. Al termine della regione, OpenMP combina automaticamente e in modo atomico i sub-totali nella variabile condivisa globale.
#figure(image("images/2026-03-06-12-18-15.png", width: 60%))

=== Caso studio: modello produttore-consumatore e lock espliciti
In pattern complessi di comunicazione, come il modello "Produttore-Consumatore" tramite code di messaggi indipendenti, i costrutti standard risultano troppo restrittivi. L'uso di un singolo blocco `critical` per inserimento/estrazione paralizzerebbe l'intero sistema bloccando thread che comunicano con code diverse.

La soluzione ingegneristica richiede l'adozione dei *Lock Espliciti*. OpenMP fornisce un'API basata sul tipo `omp_lock_t`:

1. Si ingloba una variabile lock all'interno della singola struttura dati della coda.
2. La si inizializza con `omp_init_lock()`.
3. Per accedere in modo esclusivo a una specifica coda, il thread invoca `omp_set_lock(&q_p->lock)`.
4. A operazione conclusa, rilascia la risorsa con `omp_unset_lock(&q_p->lock)`.

#figure(image("images/2026-03-06-12-31-44.png", width: 40%))

Questo approccio abilita un parallelismo a grana fine (*fine-grained*) e ad altissime prestazioni, immune dai colli di bottiglia globali generati dalle normali direttive di blocco.

== L'architettura NUMA e la politica del "First Touch"
#figure(image("images/2026-03-06-15-08-54.png"))

I moderni calcolatori paralleli sono basati su architetture NUMA (Non-Uniform Memory Access). In un sistema NUMA, la memoria principale è divisa e fisicamente associata a specifici processori o nodi (socket). Di conseguenza, il tempo di accesso alla memoria varia in base alla posizione fisica dei dati rispetto al core che ne fa richiesta: l'accesso alla memoria locale è significativamente più veloce rispetto all'accesso remoto a una memoria collegata a un altro nodo.

#figure(image("images/2026-03-06-15-10-14.png"))

Per visualizzare i dettagli di un sistema NUMA, inclusa la quantità di memoria libera per nodo e i core associati, è possibile utilizzare il comando Linux `numactl -H`. Questo comando fornisce anche una tabella delle "distanze", che rappresenta le latenze relative per l'accesso incrociato tra i vari nodi.

In questo contesto hardware, il kernel del sistema operativo (come ad esempio in Linux) deve decidere dove allocare fisicamente la memoria richiesta da un programma. La tecnica più comune per gestire questa assegnazione è la cosiddetta politica del *first touch* (primo tocco). Quando un programma dichiara o alloca un array, la memoria inizialmente esiste solo come voce in una tabella di memoria virtuale. La memoria fisica vera e propria viene creata e allocata solamente nel momento in cui l'array viene "toccato" per la prima volta, ovvero al suo primo accesso in lettura o scrittura. Il sistema operativo allocherà questa memoria nel nodo fisico più vicino al thread che ha generato questo primo tocco.

=== Il problema dell'inizializzazione sequenziale

La politica del first touch ha implicazioni profonde per i programmi OpenMP. Se un singolo thread (tipicamente il master thread) si occupa di allocare e inizializzare tutta la memoria prima di una regione parallela, l'intera struttura dati verrà posizionata sul singolo nodo NUMA in cui risiede il thread master. Quando gli altri thread, distribuiti su CPU diverse, cercheranno di accedere alle proprie porzioni di dati durante le fasi di calcolo, subiranno pesanti penalità di latenza dovute all'accesso remoto.

#example()[

  Per illustrare questo concetto, consideriamo un tipico esempio di *codice senza first touch parallelo*:

  ```cpp
  #define ARRAY_SIZE 80000000
  static double a[ARRAY_SIZE], b[ARRAY\_SIZE], c[ARRAY\_SIZE];
  // Inizializzazione sequenziale (eseguita solo dal master thread)
  for (int i=0; i<ARRAY_SIZE; i++) {
    a[i] = 1.0;
    b[i] = 2.0;
  }

  #pragma omp parallel for
  for (int i=0; i < n; i++) {
    c[i] = a[i] + b[i];
  }
  ```

  Questo stile di implementazione produce prestazioni modeste, poiché tutta la memoria viene allocata vicino al thread principale, creando un collo di bottiglia.

  La soluzione consiste nel parallelizzare l'inizializzazione dei dati, imitando lo stesso pattern di distribuzione del carico di lavoro che verrà utilizzato successivamente. Ad esempio, introducendo una regione parallela per l'inizializzazione:

  ```cpp
  #pragma omp parallel for schedule(static)
  for (int i=0; i<ARRAY_SIZE; i++) {
    a[i] = 1.0;
    b[i] = 2.0;
  }
  ```

  In questo modo, ogni thread "toccherà" per primo una specifica "fetta" dell'array `a` e `b`, allocandola nella memoria fisica locale del proprio nodo NUMA, garantendo un accesso rapido durante il successivo calcolo parallelo. Questa singola accortezza può migliorare le prestazioni in modo drammatico, talvolta fino a un fattore `10x`.
]

== Affinità dei thread

Oltre ad allocare la memoria nel posto giusto, è altrettanto importante assicurarsi che il sistema operativo non sposti i thread su processori diversi durante l'esecuzione. Legare un thread a una specifica posizione hardware è noto come "thread affinity" e risulta cruciale per massimizzare l'uso della memoria cache e mantenere bassa la latenza e alta la larghezza di banda.

OpenMP offre due variabili d'ambiente per controllare questo comportamento:

- *`OMP_PLACES`*: Definisce i luoghi (places) in cui i thread possono essere eseguiti. I valori possibili includono:
  - *sockets*: I thread vengono distribuiti sui vari socket (processori fisici).
  - *cores*: I thread vengono allocati sui singoli core fisici del processore.
  - *threads*: I thread vengono programmati sugli "strands" (i thread hardware generati dall'hyperthreading; ad esempio, un core CPU con hyperthreading ha due strand). In questo contesto, il termine "strand" serve a differenziare i thread software di OpenMP dai thread hardware della CPU.
  - Specifiche definite dall'utente, come id numerici degli strand (es. "{0},{8},{16}").
- *`OMP_PROC_BIND`*: Definisce in che modo i thread devono essere mappati sui luoghi definiti da `OMP_PLACES`. A partire da OpenMP 4.0, i criteri includono:
  - *master* (rinominato primary in OpenMP 5.1): Schedula i thread nello stesso luogo in cui è in esecuzione il thread principale.
  - *close*: Mantiene i thread il più vicini possibile (in termini hardware).
  - *spread*: Distribuisce i thread il più lontano possibile l'uno dall'altro.

Come regola pratica generale, l'hyperthreading spesso non apporta grandi benefici a kernel computazionali limitati dalla memoria (memory-bound), ma generalmente non peggiora le prestazioni. Al contrario, per funzioni fortemente dipendenti dalla larghezza di banda della memoria su sistemi a socket multipli, occupare attivamente tutti i socket (usando ad esempio `OMP_PROC_BIND=spread`) risulta estremamente vantaggioso.

== Ottimizzazione del codice OpenMP

L'ottimizzazione del codice OpenMP ad alto livello prevede generalmente un processo iterativo diviso in quattro fasi principali:

1. *Riduzione dell'overhead di avvio dei thread*: L'avvio di una regione parallela comporta un costo (circa il 10-15% del tempo di esecuzione). E' opportuno unire le direttive separate (ad esempio passando da multipli `#pragma omp parallel for` a una singola e più estesa regione `#pragma omp parallel` che contiene al suo interno direttive `#pragma omp for`).
2. *Riduzione della sincronizzazione*: I cicli for in OpenMP presentano una barriera implicita alla loro conclusione. Ove la sincronizzazione non sia strettamente necessaria per via dell'indipendenza dei dati, è consigliabile aggiungere la clausola `nowait`. Per una rimozione spinta delle barriere, si può evitare del tutto il costrutto di work-sharing esplicito del ciclo for e assegnare manualmente le partizioni del ciclo ai thread sfruttando gli identificatori del thread (Thread ID). Questo partizionamento manuale riduce il "cache thrashing" e le race conditions, impedendo ai thread di sovrapporsi nelle medesime regioni di memoria.
3. *Ottimizzazione tramite privatizzazione*: Rendere le variabili private a ciascun thread riduce i vincoli di sincronizzazione. Questo aiuta enormemente il compilatore nelle sue ottimizzazioni intrinseche, in quanto non è costretto a considerare eventuali dipendenze complesse su ampi blocchi di codice.
4. *Verifica della correttezza del codice*: Dopo ogni modifica strutturale, specialmente a seguito della rimozione di barriere o dell'aggiunta di clausole `nowait`, è imperativo verificare l'insorgere di potenziali race conditions utilizzando strumenti dedicati, come ad esempio l'Intel Inspector.

=== Lo scope delle variabili in OpenMP

Un aspetto cruciale, soprattutto nella fase di privatizzazione, riguarda la comprensione dello scope delle variabili. In un costrutto parallelo in C, in generale, le variabili automatiche dichiarate all'interno di un costrutto parallelo, oppure all'interno dello scope di una funzione richiamata dalla regione parallela, sono considerate private. Queste variabili risiedono sullo *Stack* della memoria. Poiché ogni thread possiede il proprio stack pointer separato, le operazioni su queste variabili godono di grande isolamento e rapidità d'accesso locale.

Al contrario, le variabili allocate dinamicamente (ad esempio con `malloc`), le variabili con scope a livello di file, o le variabili dichiarate con l'attributo `static` sono normalmente considerate *condivise* (Shared). Esse risiedono nell'area della memoria denominata *Heap*, la quale è condivisa tra tutti i thread. L'accesso a dati nello heap espone al rischio di condizioni di competizione (race conditions) se non viene accuratamente mediato da barriere di sincronizzazione.

== Analisi e debugging del codice concorrente

Lo sviluppo di applicazioni parallele in ambienti a memoria condivisa introduce sfide notevoli rispetto alla programmazione sequenziale tradizionale. Tra le problematiche più insidiose e complesse da individuare vi sono i difetti legati alla sincronizzazione dei thread, che possono portare a comportamenti imprevedibili e risultati errati. Questo capitolo esplora gli strumenti diagnostici avanzati a disposizione degli sviluppatori C/C++, con un'attenzione particolare al Thread Sanitizer e alle sue applicazioni in ambienti multi-threading e OpenMP.

=== La Sfida delle "Data Race"

Prima di addentrarci negli strumenti di debugging, è fondamentale definire con precisione l'errore più comune e pericoloso nella programmazione parallela: la *Data Race* (condizione di competizione sui dati).

Una data race si verifica rigorosamente quando si presentano tre condizioni contemporaneamente:

1. Almeno due thread differenti accedono alla medesima variabile o porzione di memoria condivisa.
2. Almeno uno di questi thread sta effettuando un'operazione di scrittura (modifica della variabile).
3. Gli accessi avvengono in modo concorrente, ovvero senza l'utilizzo di un meccanismo di sincronizzazione adeguato (come mutex, semafori o barriere).

Le data race sono estremamente pericolose poiché introducono un comportamento *non deterministico* nel programma. A seconda di minime e impercettibili variazioni nelle tempistiche di esecuzione dettate dal sistema operativo, il programma può produrre risultati corretti in un'esecuzione e risultati completamente errati o persino corruzione della memoria in quella successiva. Di conseguenza, questi bug sono proverbialmente difficili da isolare utilizzando i classici debugger (come GDB), poiché il semplice rallentamento indotto dal debugger stesso spesso nasconde o altera le condizioni temporali che scatenano la data race.

== Thread Sanitizer (TSan)

Per affrontare queste sfide strutturali, la comunità di sviluppo si affida ai "sanitizer", strumenti diagnostici integrati direttamente nel compilatore. Il *Thread Sanitizer*, comunemente abbreviato in *TSan*, è un potente strumento basato sull'infrastruttura LLVM (ed è disponibile a partire dalla versione 5 di GCC), progettato specificamente per rilevare le data race a runtime (durante l'esecuzione) nei linguaggi C e C++. Le sue funzionalità, inoltre, sono state estese per supportare anche linguaggi moderni come Go e Swift.

Oltre a individuare gli accessi concorrenti non protetti, TSan è in grado di rilevare ulteriori anomalie legate alla gestione dei thread, come deadlock (situazioni di stallo in cui due o più thread si bloccano a vicenda in attesa di risorse), l'uso di mutex non inizializzati e i "thread leak", ovvero la mancata terminazione e pulizia dei thread allocati.

=== Il funzionamento di TSan

Ciò che rende TSan eccezionalmente efficace è la sua indipendenza dalle esatte tempistiche fisiche di esecuzione. TSan non si limita a osservare passivamente i thread, ma trasforma attivamente il codice durante la fase di compilazione.

Per illustrare questo concetto vitale, consideriamo la modifica strutturale che TSan applica a un semplice accesso in memoria. Se nel codice originale abbiamo un'istruzione di assegnazione:
```cpp
// Codice originale (Prima)

*address = ...; // or: ... = *address;
```
Il compilatore inietterà automaticamente una chiamata a una speciale funzione di tracciamento prima di ogni operazione sulla memoria:
```cpp
// Codice strumentato da TSan (Dopo)

RecordAndCheckWrite(address);

*address = ...; // or: ... = *address;;
```
Inoltre, per implementare il controllo, ogni thread mantiene un proprio *timestamp* locale, oltre a memorizzare i timestamp conosciuti degli altri thread con cui ha stabilito dei punti di sincronizzazione formali. Ogni volta che una variabile viene letta o scritta, il timestamp del thread corrente viene incrementato.

La funzione `RecordAndCheckWrite` confronta la storia degli accessi memorizzata per quell'indirizzo: se scopre che un thread ha letto o scritto il dato e, in assenza di regole di sincronizzazione intermedie, un altro thread sta tentando una scrittura in quel momento logico, segnala immediatamente la violazione. *Di conseguenza*, incrociando questi dati storici, TSan può rilevare una data race anche se, in quella specifica esecuzione del programma, l'errore non si è fisicamente manifestato in modo distruttivo.

=== Utilizzo pratico, impatto sulle prestazioni e limitazioni

L'abilitazione di Thread Sanitizer avviene aggiungendo una specifica direttiva in fase di build. E' essenziale sottolineare che il flag `-fsanitize=thread` deve essere passato contemporaneamente sia al *compilatore* (per trasformare il codice) sia al *linker* (per collegare la libreria di runtime dedicata di TSan).

Per illustrare il processo, consideriamo questo comando tipico di compilazione:

`clang++ -fsanitize=thread -std=c++11 -pthread -g -O1`

In questo esempio, compiliamo un codice C++11 con supporto ai thread Posix (`-pthread`), richiedendo a TSan di analizzare il programma.

L'utilizzo di TSan, per via del massiccio tracciamento delle operazioni in memoria, comporta un *impatto prestazionale severo*. L'esecuzione del codice strumentato subisce tipicamente un rallentamento della CPU (slowdown) compreso tra 2x e 20x. Inoltre, a causa della necessità di memorizzare la cronologia dei thread e i timestamp associati a ogni indirizzo, l'utilizzo della memoria RAM può gonfiarsi di un fattore variabile tra 5x e 10x. Per mitigare in parte questo overhead su CPU e memoria, è caldamente consigliato abilitare un livello di ottimizzazione moderato, compilando con i flag `-O1` o `-O2`.

=== Esecuzione e analisi dei risultati

Poiché TSan agisce a runtime, gli errori non vengono intercettati durante la compilazione, ma durante l'esecuzione del file binario generato (es. ./a.out).

Un ostacolo tecnico peculiare che si presenta sui sistemi operativi Linux riguarda l'*ASLR* (Address Space Layout Randomization), una tecnica di sicurezza che randomizza la disposizione della memoria. Se questa funzionalità è attiva, TSan fallirà inevitabilmente la sua esecuzione. Al fine di poter procedere al test, l'ASLR deve essere temporaneamente disabilitato invocando il programma in questo modo: `setarch $(uname -m) -R ./my-executableIl parametro -R` istruisce esplicitamente il sistema di disabilitare la randomizzazione per quello specifico eseguibile.

Quando TSan rileva un problema, arresterà il processo stampando a terminale un log dettagliato (detto *stack trace*). Ad esempio:
```
WARNING: ThreadSanitizer: data race (pid=19219)

Write of size 4 at 0x7fcf47b21bc0 by thread T1:

#0 Thread1 tiny\_race.c:4 ...

Previous write of size 4 at 0x7fcf47b21bc0 by main thread:

#0 main tiny\_race.c:10 ...
```
Questo log indica chiaramente allo sviluppatore dove è avvenuto l'errore (la scrittura da parte del "thread T1" alla riga 4 del file `tiny_race.c`), e lo mette in correlazione logica con l'azione conflittuale precedente (effettuata dal "main thread" alla riga 10) e perfino con il momento esatto in cui il thread incriminato è stato creato. Moderni ambienti di sviluppo integrati (IDE), come JetBrains CLion, sono ormai in grado di effettuare il parsing (lettura automatica) di questi output, mostrando visivamente gli errori direttamente nell'interfaccia grafica dell'editor del codice.

== Misurazione delle prestazioni e profilazione
Lo sviluppo di applicazioni parallele efficaci richiede non solo la corretta implementazione degli algoritmi, ma anche una rigorosa validazione delle prestazioni ottenute. Prima di poter ottimizzare un codice, è imperativo capire esattamente dove e in che modo il programma consuma il tempo di elaborazione.

La prima necessità che sorge quando si parallelizza un frammento di codice sequenziale è valutare l'effettivo guadagno prestazionale (speedup). Per farlo, occorre misurare il tempo impiegato da entrambe le versioni del codice. Tuttavia, la scelta dello strumento di misurazione è un passaggio critico.

In un tipico codice sorgente scritto in C, utilizzando la libreria standard , il primo approccio è spesso quello di utilizzare la funzione `clock()`. Questa funzione restituisce un'approssimazione del "tempo di processore" (CPU time) utilizzato dal processo a partire da un'epoca predefinita legata all'inizio dell'esecuzione del programma. Poiché il valore restituito non è assoluto, l'unico modo sensato per utilizzarlo è calcolare la differenza tra due chiamate alla funzione e dividere il risultato per la costante `CLOCKS_PER_SEC` per ottenere i secondi. In un programma strettamente sequenziale, il tempo di processore coincide in modo ragionevole con il tempo di esecuzione effettivo del programma. Tuttavia, l'uso di `clock()` in un programma parallelo multi-thread porta a misurazioni completamente fuorvianti.

Per illustrare questo concetto vitale, consideriamo un esempio pratico. Supponiamo di avere un codice sequenziale che impiega 1 secondo per terminare, e supponiamo di parallelizzarlo in modo ideale su quattro thread. Ciascun thread impiegherà $frac(1, 4)$ del tempo originario (0.25 secondi) per concludere la propria frazione di lavoro. In questo scenario, la funzione `clock()` sommerà il tempo di CPU speso da *tutti* i thread concorrenti. Il calcolo sarà pertanto $4 times 0.25 = 1$. Il tempo restituito sarà identico a quello del programma sequenziale. Peggiorando ulteriormente le cose, la creazione e la gestione dei thread introducono un *overhead* (costo operativo) inevitabile. Di conseguenza, il tempo effettivo di CPU misurato sarà addirittura superiore a quello impiegato dalla variante sequenziale. *Regola fondamentale:* la funzione `clock()` non deve mai essere utilizzata per confrontare i tempi di esecuzione tra un codice sequenziale e uno parallelo.

=== Il tempo reale: Wall-Clock Time
La metrica corretta per valutare le prestazioni assolute di un programma parallelo è il tempo reale trascorso, comunemente definito come *Wall-Clock Time*. Questa metrica calcola esattamente quanto tempo fisico è passato dall'inizio alla fine di un blocco di istruzioni. Va notato che il "clock time" (tempo di CPU) e il "wall-clock time" procedono a velocità differenti in base a come il sistema operativo (OS) distribuisce le risorse. Se la CPU è contesa tra molteplici processi di sistema, il tempo di CPU avanzerà più lentamente del wall-clock. Al contrario, se il nostro processo ha a disposizione molteplici core (come in un programma OpenMP), il tempo totale di CPU misurato avanzerà molto più rapidamente del tempo fisico.

=== Strumenti per la misurazione del Wall-Clock Time
Per ottenere il wall-clock time, i programmatori hanno a disposizione diverse funzioni di sistema:
1. *`gettimeofday()` e `time()`*: Presenti nell'intestazione , queste chiamate di sistema (system call) ottengono l'ora dal sistema operativo. `time()` ha una risoluzione al secondo, mentre `gettimeofday()` arriva ai microsecondi. Tuttavia, la loro accuratezza è definita "non specificata" dallo standard.
2. *`clock_gettime(`)*: Secondo i recenti standard POSIX, `gettimeofday()` è da considerarsi obsoleto e dovrebbe essere sostituito da `clock_gettime()`, il quale garantisce una risoluzione al nanosecondo. Una best-practice è verificare la disponibilità di questa funzione (ad esempio, su macOS è stata introdotta solo dalla versione 10.12) e usarla come scelta prioritaria, ripiegando su `gettimeofday` se non presente.
3. *Alternative Moderne*: Utilizzando C++11, la libreria standard offre `std::chrono::high_resolution_clock`. Infine, per i programmi che sfruttano lo standard OpenMP, esiste la comodissima funzione `omp_get_wtime()`, la quale restituisce un valore di tipo double che rappresenta i secondi trascorsi da un determinato istante nel passato.

== Introduzione alla profilazione
La misurazione del tempo totale indica *se* un programma è lento, ma non dice *dove* lo sia. Per questa finalità interviene la *profilazione* (Profiling), una tecnica che permette di identificare quali specifiche porzioni di un programma assorbono maggior tempo e risorse, evidenziando i candidati ideali per l'ottimizzazione e la parallelizzazione. I profiler operano tipicamente mediante *campionamento* (sampling): interrompono periodicamente l'esecuzione del programma (ad esempio, 100 volte al secondo), registrano quale funzione è attualmente in esecuzione (contando quante volte un'istruzione viene letta) e calcolano il tempo impiegato. Esistono numerosi strumenti specializzati in base al linguaggio: VisualVM per Java, Scalasca o VTune per OpenMP/MPI, NVProf per CUDA. Nel contesto della programmazione C/C++, due degli strumenti più adottati in ambiente Linux/Unix sono Google Perftools e Callgrind.
=== Google Perftools (pprof)
Google Perftools (in particolare lo strumento pprof abbinato alla libreria libprofiler) è un profiler basato sul campionamento a bassissimo overhead.

L'utilizzo classico richiede i seguenti passaggi:
1. Compilare e linkare l'eseguibile aggiungendo il flag `-lprofiler`.
2. Eseguire il programma impostando la variabile d'ambiente che definisce il file di output: `CPUPROFILE=/tmp/prof.out ./mio_eseguibile`. E' anche possibile variare la frequenza di campionamento (il default è 100Hz) usando la variabile `CPUPROFILE_FREQUENCY`.
3. Analizzare il report generato invocando il comando `pprof --text ./mio_eseguibile /tmp/prof.out`.

=== Analisi dettagliata con Valgrind e Callgrind
Un'alternativa a pprof è *Callgrind*, un componente della suite Valgrind. A differenza di Google Perftools, Callgrind non sfrutta il campionamento, ma "strumenta" (innesca dinamicamente) l'eseguibile traducendo le istruzioni macchina al volo. Di conseguenza, pur essendo significativamente più lento in fase di esecuzione, fornisce una precisione assoluta sugli accessi e le letture delle istruzioni. Un enorme vantaggio è che non richiede alcuna ricompilazione del codice originale. Per utilizzarlo, si lancia il comando valgrind `--tool=callgrind ./eseguibile`, il quale produce un file di tracciamento `callgrind.out`. Questo file può essere esplorato graficamente con interfacce come KCachegrind, oppure ispezionato da terminale con `callgrind_annotate --auto=yes` per avere un'analisi riga per riga.

=== Profilazione della memoria cache
I processori moderni traggono gran parte delle loro prestazioni dalla gerarchia di memoria Cache (L1, L2, L3). Callgrind permette di simulare il comportamento di queste cache passando il parametro `--simulate-cache=yes`. Questa simulazione modella un'architettura divisa per la cache L1 (Dati separati dalle Istruzioni) e unificata per la L2 23. Il report finale presenta metriche critiche sotto forma di acronimi:
- *Ir / Dr / Dw*: Letture Istruzioni (Instruction reads), Letture Dati (Data reads), Scritture Dati (Data writes).
- *I1mr / D1mr / D1mw*: "Miss" (mancati riscontri) nella cache L1 per Istruzioni (I) e Dati (D, lettura e scrittura). Se un dato non è in L1, deve essere recuperato dalla cache L2.
- *I2mr / D2mr / D2mw*: Miss nella cache L2. Questo è lo scenario peggiore: l'informazione non è né in L1 né in L2 e la CPU è costretta a recuperarla dalla memoria RAM. L'identificazione dei cosiddetti "L2 misses" è vitale. Tali eventi comportano un costo temporale enormemente superiore rispetto ai miss in L1. Un profiler può evidenziarli filtrando l'output, mettendo in luce le porzioni di codice affette da scarsa località spaziale o temporale.

=== Best practices per la profilazione
1. *Ottimizzazione del Compilatore:* Al contrario delle sessioni di debugging, che richiedono l'assenza di ottimizzazioni, il profiling deve essere effettuato su eseguibili compilati in modalità di rilascio con le dovute ottimizzazioni (es. flag `-O2` o `-O3`). Solo così si individueranno i colli di bottiglia del codice finale.
2. *Limiti del campionamento CPU:* Strumenti come Callgrind e Perftools misurano cicli CPU. Se il collo di bottiglia del programma è la scrittura su un disco rigido o la lettura da un socket di rete, queste latenze non figureranno nel profilo CPU.  
3. *Varianza dell'input:* Le performance di un algoritmo mutano drasticamente al variare delle dimensioni dell'input. E' fondamentale testare scenari diversi per catturare il comportamento asintotico del sistema.
== Identificazione dei bottlenecks
La parallelizzazione multi-thread di un programma è efficace unicamente se si agisce sui colli di bottiglia computazionali. L'aggiunta di thread indiscriminatamente porta quasi sempre a un degradamento delle prestazioni. I tre colli di bottiglia fondamentali sono:
=== Operazioni di Input/Output (I/O)
L'accesso a componenti hardware esterne (dischi rigidi, telecamere, moduli Bluetooth, connessioni di rete) obbliga il thread chiamante a entrare in uno stato di attesa inattiva ("wait"). L'hardware di I/O è decine di migliaia di volte più lento della CPU. Pertanto, suddividere il lavoro tra thread non comporterà alcun vantaggio in porzioni di codice limitate dall'I/O (I/O Bound), a meno che i thread non siano progettati in modo asincrono per poter svolgere calcoli indipendenti in background mentre attendono i dati.
=== Memory contention
Questo fenomeno si verifica quando più unità di calcolo (core) tentano di accedere in modo simultaneo (in lettura e, soprattutto, in scrittura) alle medesime linee o bus di memoria. L'hardware sarà costretto a serializzare e intrecciare le richieste, ponendo di fatto i core in attesa e neutralizzando i benefici del parallelismo (efficienza ridotta a causa della sincronizzazione hardware implicita).
=== L'overhead di gestione dei thread
L'istanziazione di un thread, il salvataggio dei suoi registri (context switch) e la sua distruzione hanno un preciso e misurabile costo computazionale imposto dal sistema operativo. Per illustrare questo concetto, consideriamo un ciclo for banale suddiviso su decine di thread: se il lavoro che ogni thread deve compiere richiede un milionesimo di secondo, ma il sistema operativo impiega un decimo di millisecondo per istanziare e terminare il thread, l'applicazione sarà enormemente rallentata. Il lavoro delegato al thread deve essere computazionalmente sostanzioso per giustificarne il ciclo vitale. Al fine di abbattere drasticamente questi costi, si ricorre al *Thread Pool*: un pool di thread viene creato una singola volta all'inizio dell'esecuzione del programma e mantenuto dormiente. Tali thread vengono di volta in volta risvegliati, riutilizzati per differenti cicli di lavoro e rimessi a riposo, evitando così i costi continui di istanziazione e distruzione.
