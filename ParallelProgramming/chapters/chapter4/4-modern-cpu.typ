#import "../../../dvd.typ": *

#pagebreak()
= L'Architettura delle CPU Moderne

== Tendenze Storiche e Limiti Fisici

#figure(image("images/2026-02-27-12-20-25.png"))

=== L'Evoluzione della Legge di Moore
Per decenni, il progresso dei microprocessori è stato guidato dalla *Moore’s Law*, che prevedeva il raddoppio del numero di transistor su un circuito integrato circa ogni due anni. Sebbene questa legge sia ancora valida per quanto riguarda la densità dei transistor, non si traduce più automaticamente in un aumento della frequenza di clock. Dagli anni 2000, infatti, la performance dei singoli *threads* ha subito un rallentamento a causa di limiti termici e di consumo energetico.

=== Era Multi-core
L'aumento della frequenza di clock comporta una crescita insostenibile della potenza dissipata. Per ovviare a questo problema, l'industria si è spostata verso l'era *multi-core*: invece di rendere un singolo core estremamente complesso e veloce, si preferisce utilizzare l'aumentato numero di transistor per integrare più core all'interno dello stesso chip. Un esempio estremo di questa filosofia è stato il *Xeon Phi*, un processore con ben 72 core progettato per competere con le *GPUs* nel calcolo parallelo.

== La Gerarchia di Memoria e le Performance

#definition()[
  La latenza di memoria è la quantità di tempo necessaria affinché una richiesta di accesso alla memoria da parte del processore sia soddisfatta.
]

#definition()[
  La larghezza di banda della memoria è la velocità con cui il sistema di memoria può fornire dati al processore.
]

Il divario di prestazioni tra processore e memoria è uno dei principali colli di bottiglia del calcolo moderno. Mentre una CPU può eseguire operazioni in frazioni di nanosecondo, l'accesso alla *RAM* può richiedere centinaia di cicli di clock (circa 100ns), causando *processor stalls* dove l'unità di calcolo rimane inattiva in attesa dei dati.

Per mitigare la latenza, si utilizzano diversi livelli di *cache* (*L1, L2, L3*). Un accesso alla *L1 cache* richiede circa 4 cicli, contro i 400 della memoria principale. Inoltre, le CPU moderne implementano il *prefetching*: il processore è in grado di prevedere quali dati saranno necessari in un ciclo di lettura contiguo e li carica preventivamente nelle cache.

Ecco una trattazione approfondita sul calcolo della potenza di calcolo massima teorica, strutturata come un capitolo tecnico basato sulle fonti fornite.

Per valutare il potenziale di una CPU moderna, si utilizza la metrica dei *FLOPS* teorici ($F_T$), che rappresenta il numero massimo di operazioni in virgola mobile eseguibili al secondo in condizioni ideali. Questa misura è fondamentale per definire il "tetto" prestazionale (il limite superiore nel *roofline plot*) di un sistema.

La performance massima teorica viene calcolata moltiplicando tre fattori chiave che riflettono l'architettura del processore:
$
  F_T = C_v times f_c times I_c
$

dove:
- *$C_v$ (Virtual Cores):* Il numero di core logici disponibili.
- *$f_c$ (Clock Rate):* La frequenza di clock, solitamente riferita al valore di *turbo boost* quando tutti i processori sono attivi.
- *$I_c$ (Flops/Cycle):* Il numero di operazioni in virgola mobile che ogni core può eseguire in un singolo ciclo di clock.

=== Parallelismo Hardware: Cores e Hyperthreading
Il numero di *Virtual Cores* ($C_v$) non coincide necessariamente con i core fisici. Grazie a tecnologie come l'*Hyper-threading (HT)* di Intel (una forma di *simultaneous multithreading*), ogni core fisico ($C_h$) può apparire al sistema operativo come due o più core logici.
- *Esempio:* Un processore con 4 core fisici e *Hyper-threading* attivo avrà $C_v = 4 times 2 = 8$ core virtuali.

L'obiettivo dell'*Hyper-threading* è saturare le unità di esecuzione: se un *thread* è in attesa di dati dalla memoria, l'altro può utilizzare le risorse di calcolo rimaste inattive.

=== Capacità di Calcolo per Ciclo ($I_c$)
Il fattore $I_c$ è quello che ha subito l'incremento maggiore nelle architetture recenti grazie alla vettorizzazione e a istruzioni specializzate. Per determinarlo, si considerano due elementi:
1. *Vectorization:* La capacità della *Vector Unit* di operare su più dati contemporaneamente. Si calcola dividendo la *Vector Width* (es. 256 bit per AVX2 o 512 bit per AVX-512) per la dimensione della parola dati (*Word Size*) in bit.
2. *Fused Operations (Fops):* L'inclusione di istruzioni come la *Fused Multiply-Add (FMA)*, che esegue una moltiplicazione e un'addizione in un unico passaggio, contando come due operazioni per ciclo.

#example()[
  Consideriamo un sistema standard con le seguenti specifiche:
  - 4 Core fisici con *Hyper-threading* ($C_v = 8$).
  - Frequenza di clock di *3.7 GHz* ($f_c$).
  - Supporto *AVX2* e *FMA* ($I_c = 8$).

  Il calcolo della performance sarà:
  $
    F_T = 8 text("Virtual Cores") times 3.7 text("GHz") times 8 text("Flops/Cycle") = 236.8 text("GFlops/s").
  $

  Questo valore rappresenta il picco massimo; nella pratica, le prestazioni reali possono essere limitate dalla *memory bandwidth* (se l'algoritmo ha una bassa *arithmetic intensity*) o dalla capacità del compilatore di generare codice che utilizzi effettivamente le unità *SIMD*.
]

== Esecuzione Avanzata e Concorrenza

=== Out of Order Execution (OoOE)
I chip x86 moderni non eseguono le istruzioni in modo puramente sequenziale. Grazie alla *speculative execution* e al riordinamento delle operazioni (*re-ordering*), la CPU può eseguire compiti in anticipo per evitare blocchi dovuti a risorse momentaneamente indisponibili. Tuttavia, il sistema deve garantire che lo stato finale visibile (registri e memoria) sia coerente con un'esecuzione in ordine.

A causa del riordinamento dei carichi e degli scarichi di memoria (*loads* e *stores*), alcuni algoritmi classici di mutua esclusione, come il *Dekker’s algorithm*, possono fallire sui sistemi moderni. In un sistema multi-core, se due *threads* leggono variabili prima che le rispettive operazioni di scrittura siano state propagate, entrambi potrebbero entrare nella *critical section* simultaneamente.

Per risolvere questi problemi di consistenza, si utilizzano le *Memory Fences* (o *fences*), istruzioni che forzano un ordine specifico negli accessi alla memoria. In molti casi, l'uso di meccanismi di *locking* è preferibile, poiché nelle CPU x86 moderne il *locking* è spesso più efficiente delle sole barriere di memoria, garantendo atomicità e ordine globale delle transazioni.


== Architetture di Sistema: UMA vs NUMA

Nei sistemi a memoria condivisa, si distinguono due architetture:
1. *Uniform Memory Access (UMA):* Tutti i processori condividono la memoria tramite un unico controller. È semplice ma poco scalabile.
2. *Non-Uniform Memory Access (NUMA):* La memoria è fisicamente vicina a specifiche CPU (*local memory*). Accedere alla memoria di un altro socket (*remote memory*) è possibile ma comporta una latenza maggiore e un consumo di banda sull'interconnessione di sistema (come *Intel QuickPath*). Per massimizzare le prestazioni, il sistema operativo e il programmatore devono assicurarsi che i *threads* girino sui core più vicini ai dati che devono elaborare.

== Parallelismo e Coerenza

=== SIMD e Vettorizzazione
Il modello *SIMD* (*Single Instruction, Multiple Data*) permette di eseguire la stessa operazione su più dati simultaneamente utilizzando registri vettoriali (come *SSE* a 128-bit o *AVX* a 256/512-bit).

#example()[Invece di sommare singolarmente quattro numeri *float*, un'istruzione SSE come `addps` può sommarli tutti in un unico ciclo di clock, migliorando drasticamente il *throughput*.
  #figure(image("images/2026-02-27-12-37-02.png"))
]

=== Coerenza della Cache e False Sharing
In sistemi multi-core, mantenere una vista coerente della memoria è complesso. I protocolli di *Cache Coherence* (come lo *Snooping* o i sistemi basati su *Directory*) assicurano che, se un core modifica un dato, le copie vecchie nelle altre cache vengano invalidate. Un problema comune è il *false sharing*, che si verifica quando due core modificano variabili diverse ma residenti sulla stessa *cache line* (tipicamente 64 byte), causando un inutile traffico di coerenza e rallentando il sistema.

=== Hyper-Threading (HT)
L'*Hyper-Threading* è una forma di *simultaneous multithreading* dove un singolo core fisico appare come due core logici (*logical processors*). L'obiettivo è saturare le unità di esecuzione: se un *thread* è fermo in attesa di dati, l'altro può utilizzare le risorse di calcolo rimaste inattive.


== Fondamenti di SIMD e Vettorizzazione

Nel panorama dell'architettura dei calcolatori, il termine *SIMD* (*Single Instruction, Multiple Data*) descrive uno scenario in cui una singola istruzione viene eseguita contemporaneamente su più flussi di dati. In termini pratici, una singola istruzione di "vector add" può sostituire otto istruzioni individuali di "scalar add" all'interno della *instruction queue*. Questo approccio riduce drasticamente la pressione sulla coda delle istruzioni e sulla *cache*.

Uno dei maggiori vantaggi della vettorizzazione risiede nel consumo energetico: eseguire otto addizioni in una *vector unit* richiede approssimativamente la stessa potenza necessaria per una singola addizione scalare. Mentre un'operazione scalare processa un singolo valore in *double-precision* per ciclo, una *vector unit* a 512-bit può processare tutti gli otto valori contenuti in una *cache line* da 64 byte in un unico ciclo di clock.

=== Evoluzione Hardware e Set di Istruzioni

L'integrazione di hardware vettoriale nei processori commerciali è iniziata nel 1997 e ha visto una crescita costante sia in termini di ampiezza dei registri che di operazioni supportate.
- *MMX:* Il primo set di istruzioni *SIMD* di Intel.
- *SSE (Streaming SIMD Extensions):* Introdusse il supporto per operazioni in virgola mobile a precisione singola.
- *SSE2:* Estese il supporto alla precisione doppia.
- *AVX (Advanced Vector Extensions):* Raddoppiò la lunghezza dei vettori; AMD introdusse qui l'istruzione *FMA* (*Fused Multiply-Add*), raddoppiando le performance in alcuni cicli.
- *AVX2 e AVX-512:* Intel aggiunse il supporto *FMA* e aumentò ulteriormente la dimensione dei vettori (fino a 512 bit).

Per sfruttare queste capacità, le istruzioni vettoriali devono essere generate dal compilatore o specificate manualmente tramite *intrinsics* o codice *assembler*. È essenziale utilizzare compilatori recenti e CPU moderne (prodotte negli ultimi 5-7 anni), tenendo presente che l'hardware nuovo solitamente supporta le vecchie istruzioni, ma non viceversa.

== Metodologie di Vettorizzazione

Esistono diversi approcci per vettorizzare il codice, con livelli di sforzo di programmazione variabili.

=== Librerie Ottimizzate
L'approccio più semplice consiste nell'utilizzare librerie di basso livello già testate e ottimizzate. Tra le più note figurano:
- *BLAS* e *LAPACK:* Fondamentali per l'algebra lineare ad alte prestazioni.
- *Intel Math Kernel Library (MKL):* Versioni ottimizzate di risolutori e funzioni matematiche specifiche per processori Intel.
- *SIMD JSON:* Per il parsing efficiente di file JSON.

=== Auto-vettorizzazione e Flag del Compilatore
L'*auto-vectorization* è il processo in cui il compilatore vettorizza automaticamente il codice sorgente C, C++ o Fortran. Sebbene richieda il minimo sforzo, il programmatore deve spesso aiutare il compilatore tramite *compiler flags* o suggerimenti nel codice.
Ad esempio, il flag `-march=native` indica al compilatore di utilizzare l'intero set di istruzioni *SIMD* della CPU locale. In GCC, la vettorizzazione è solitamente attiva al livello `-O3`. È inoltre fondamentale consultare i *vectorization reports* (utilizzando flag come `-fopt-info-vec-optimized` per GCC o `-qopt-report` per Intel) per verificare quali parti del codice siano state effettivamente trasformate.

== Pointer Aliasing

Il *Pointer aliasing* si verifica quando due o più puntatori puntano a regioni di memoria sovrapposte. In questa situazione, il compilatore non può garantire la sicurezza delle ottimizzazioni e potrebbe astenersi dal generare codice vettoriale.

#example()[
  Consideriamo un ciclo che opera su array statici definiti globalmente: in questo caso, il compilatore comprende perfettamente la struttura dei dati e vettorizza facilmente. Tuttavia, se le operazioni avvengono all'interno di una funzione i cui argomenti sono puntatori (es. `void stream_triad(double* a, double* b, ...)`), il compilatore non può sapere se i dati si sovrappongono.
  #grid(
    rows: 1,
    columns: 2,
    [#figure(image("images/2026-02-27-12-50-06.png"))], [#figure(image("images/2026-02-27-12-49-58.png"))],
  )


  Per risolvere il problema:
  - *In C99:* Si usa l'attributo `restrict` negli argomenti della funzione.
  - *In C++:* Si utilizzano estensioni specifiche come `__restrict`.
  Utilizzando queste parole chiave, il programmatore "promette" al compilatore che non esiste *aliasing*, permettendo una generazione di codice più aggressiva.
]

== Hints to compiler
Un *pragma* è un'istruzione che aiuta il compilatore a interpretare correttamente il codice sorgente. Possiamo usarli per suggerire la vettorizzazione di cicli che il compilatore non riesce a gestire autonomamente.
Sebbene esistano soluzioni specifiche (come `#pragma clang loop` o `#pragma simd` di Intel), l'opzione più portabile è l'uso di *OpenMP*, specificamente `#pragma omp simd`.

#observation()[
  In un ciclo dove la prima istruzione presenta una *carried dependence* (una dipendenza dall'iterazione precedente), il parallelismo totale è impossibile, ma le istruzioni successive all'interno del corpo del ciclo potrebbero comunque essere vettorizzate grazie ai suggerimenti forniti tramite *pragma*.
]


Per massimizzare l'efficacia della vettorizzazione, è consigliabile:
- Utilizzare il tipo di dato più piccolo necessario (es. `short` invece di `int`).
- Preferire la struttura *Structure of Arrays (SoA)* rispetto a *Array of Structures (AoS)*.
- Garantire accessi alla memoria contigui ed evitare, quando possibile, operazioni di *gather/scatter*.
- Utilizzare strutture dati allineate in memoria (*memory-aligned*).

I cicli dovrebbero essere semplici, senza condizioni di uscita particolari. È bene definire le variabili locali all'interno del ciclo per chiarire che non vengono trasportate alle iterazioni successive. Inoltre, è preferibile evitare chiamate a funzioni esterne nel corpo del ciclo, optando per l'*inline* (manuale o gestito dal compilatore) per non interrompere il flusso vettoriale. Infine, le condizioni all'interno dei cicli dovrebbero essere limitate a forme semplici che il compilatore possa gestire tramite *masking*.
