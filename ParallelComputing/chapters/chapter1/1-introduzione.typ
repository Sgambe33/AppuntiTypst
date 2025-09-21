#import "../../../dvd.typ": *
// B031290 B241 B340

= Introduzione

== Parallelismo vs. Concorrenza

Sebbene spesso usati in modo intercambiabile, parallelismo e concorrenza descrivono concetti distinti ma correlati.

#definition()[
  Un sistema è *concorrente* se può supportare due o più azioni *in corso* contemporaneamente. La concorrenza riguarda la *struttura* di un programma, organizzandolo in processi che possono essere eseguiti in modo indipendente. Un programma concorrente può avere più thread logici di controllo, che possono essere eseguiti o meno in parallelo. Un esempio è un sistema operativo che gestisce due thread su un singolo processore, alternandoli rapidamente (interleaving) per dare l'illusione di un'esecuzione simultanea.
]

#definition()[
  Un sistema è *parallelo* se può supportare due o più azioni *in esecuzione* simultaneamente. Il parallelismo riguarda l'*esecuzione* e la capacità dell'hardware di svolgere più operazioni nello stesso istante. Un'applicazione parallela esegue effettivamente più thread contemporaneamente, ad esempio assegnando ciascun thread a un core diverso di un processore multi-core.
]

In sintesi, *il parallelismo è un sottoinsieme della concorrenza*. Un programma progettato in modo concorrente diventa parallelo se l'hardware dispone di abbastanza core per eseguire simultaneamente i suoi molteplici thread.

== Algoritmi Sequenziali, Paralleli e Concorrenti

La maggior parte degli algoritmi tradizionali è *sequenziale*, specificando una serie di passaggi da eseguire uno dopo l'altro. Questo modello ha funzionato bene in passato grazie ai miglioramenti continui delle prestazioni delle CPU (aumento del clock, pipelining), ma adesso i produttori di chip non si concentrano più sull'aumento della velocità di clock. Infatti molte strutture dati usati da linguaggi come C++ o Java non sono fatte per essere usate in programmi paralleli.

Un *algoritmo parallelo* è progettato per eseguire più operazioni ad ogni singolo passo, sfruttando l'hardware disponibile come processori multi-core, unità funzionali multiple o sistemi di memoria pipeline per migliorare le prestazioni. La programmazione parallela consiste nell'identificare, esporre e implementare il parallelismo negli algoritmi, comprendendone costi e benefici.

Un *algoritmo concorrente* è invece strutturato in modo che i suoi passaggi possano essere eseguiti in modo indipendente, anche se non necessariamente in parallelo; può infatti essere eseguito anche in modo seriale. La coordinazione tra queste esecuzioni indipendenti richiede meccanismi di comunicazione.

Il corso si concentrerà sull'esecuzione parallela di codice concorrente.

== Dalla concorrenza al parallelismo

Per ottenere codice parallelizabile abbiamo bisogna prima di codice concorrente.

La *concorrenza* è una proprietà strutturale di un programma, ovvero un metodo di orgnaizzazione della soluzione in thread logici di controllo.

Al contrario, il *parallalelismo* è una proprietà di esecuzione che dipende dalla capacità dell'hardware sottostante di eseguire più operazioni contemporaneamente.

Come nella programmazione concorrente bisogna evitare *race conditions* coordinando correttemente i vari thread. Ogni linguaggio mette a disposizione diversi struementi come:
- Semafori
- Mutex
- Canali
Ognuno di essi con i propri vantaggi e svantaggi. Oggi si preferisce evitare direttamente la sincronizzazione tramite l'uso di:
- Immutable data: non c'è bisogno di sincronizzare dati che non cambiano.
- Thread-Local storage: ogni thread ha una memoria privata.
- Functional programming: funzioni senza effetti collaterali.

== Motivazioni

La parallelizzazione dei programmi offre due vantaggi principali:
1. *Fare le cose più velocemente*: eseguire la stessa quantità di lavoro in meno tempo.
2. *Fare cose più grandi*: eseguire più lavoro nella stessa quantità di tempo.

Sfruttare il parallelismo è diventato cruciale.
#example()[
  Configurazione hardware:
  - 16 core
  - 2 thread logici per core (hyperthreading) → 32 thread totali
  - Unità vettoriale da 256 bit

  Operazioni su double (64 bit):
  - 256 bit / 64 bit = *4 double* per operazione vettoriale

  Calcolo del parallelismo totale:

  $
    16 times 2 times 4 = 128
  $

  La CPU può eseguire fino a *128 operazioni double in parallelo*

  Osservazione:
  Se il programma usa solo un percorso *seriale* (1 operazione alla volta), allora si sfrutta solo $1/128 approx 0,8%$ della potenza di calcolo disponibile.
]



=== Evoluzione dell'Hardware

Il passaggio al parallelismo è stato guidato da limitazioni fisiche. L'aumento della velocità di clock delle CPU causa un surriscaldamento eccessivo. Tuttavia, la *Legge di Moore* (raddoppio della densità dei transistor ogni due anni) e il *Dennard Scaling* (densità di potenza costante al diminuire delle dimensioni dei transistor) hanno permesso di inserire sempre più processori nello stesso spazio, rendendo i multi-core onnipresenti.

Oltre alle CPU, il calcolo parallelo si estende ad altre architetture come:
- *Grid computing*: unione di risorse informatiche da più luoghi per un obiettivo comune.
- *Cluster computing*: computer connessi che lavorano come un unico sistema, solitamente tramite una LAN.
- *Cloud computing*: accesso a un pool condiviso di risorse computazionali configurabili.

È importante distinguere tra *calcolo parallelo*, focalizzato sulle *prestazioni* per risolvere un singolo problema con interazioni frequenti e a basso overhead, e *calcolo distribuito*, orientato alla *convenienza* (disponibilità, affidabilità) con interazioni più rare e ad alto overhead.

=== Limitazioni Fisiche e Consumo Energetico

Il consumo energetico è un fattore critico. La potenza di una CPU è proporzionale al cubo della frequenza (*P ∝ f³*), mentre l'energia necessaria per un calcolo è proporzionale al quadrato della frequenza (*E ∝ f²*). Il parallelismo può aiutare a conservare energia.

#align(center, image("images/2025-09-20-17-45-34.png"))

#example()[
  L'Intel Xeon E5-4660 a 16 core, ha un TDP (Thermal Design Power) di 120W. Supponendo di aver bisogno di 20 Xeon per 24h per un calcolo. L'energia consumata stimata sarà quindi:
  $
    P = (20 "Processors") times (120 W\/"Processors") times (24 "hours") = 57.60 "kWh"
  $
  Supponiamo adesso di eseguire la stessa applicazion su 4 GPU NVIDIA Tesla V100 sempre per 24h ma con un TDP di 300W. Il consumo stimato sarà:
  $
    P = (4 "GPUs") × (300 W\/"GPUs") × (24 "hours") = 28.80 "kWh"
  $

]



Altre limitazioni fisiche includono:
- *Velocità dei transistor*: sebbene diventino più piccoli, non diventano più veloci a causa di problemi come il "leakage" e l'aumento della costante di tempo RC dei fili di connessione. Per questo motivo è più conveniente aggiungere core piuttosto che aumentare la velocità.
- *Velocità della luce*: la distanza fisica tra CPU e memoria impone un limite alla velocità con cui i dati possono essere spostati. Un calcolo che richiede 3x10¹² spostamenti di memoria al secondo implicherebbe che la memoria debba essere compressa in uno spazio così piccolo che ogni cella di memoria avrebbe le dimensioni di un atomo, un'impossibilità fisica.

== Tipi e Modelli di Parallelismo

=== Livelli di Parallelismo

Il parallelismo può essere classificato in diversi livelli:

- *Bit-Level Parallelism*: basato sull'aumento della dimensione della parola del processore. Un computer a 32 bit può sommare due numeri a 32 bit in un unico passaggio, mentre uno a 8 bit richiederebbe più operazioni sequenziali.
- *Instruction-Level Parallelism (ILP)*: le moderne CPU eseguono istruzioni in parallelo usando tecniche come *pipelining* (sovrapposizione parziale dell'esecuzione di istruzioni), *out-of-order execution* (esecuzione di istruzioni in un ordine che non viola le dipendenze dei dati) e *speculative execution* (esecuzione di istruzioni prima di sapere se saranno necessarie).
- *Data Parallelism (Single Instruction Multiple Data)*: esecuzione della stessa operazione su grandi quantità di dati in parallelo. È tipico delle GPU e delle applicazioni multimediali.
- *Task-Level Parallelism*: suddivisione del lavoro in task distinti. Si basa su due modelli di memoria:
  - *Shared Memory*: tutti i processori accedono a un unico spazio di memoria. È più semplice da programmare ma ha una scalabilità limitata e può portare a race condition.
  #align(center, image("images/2025-09-20-18-05-23.png"))
  - *Distributed Memory*: ogni processore ha la propria memoria locale e la comunicazione avviene tramite messaggi di rete. È più difficile da programmare ma scala meglio ed è più facile da debuggare.
  #align(center, image("images/2025-09-20-18-05-40.png"))

Oggi sono comuni i *sistemi eterogenei*, che combinano CPU per la logica di controllo, GPU per l'elaborazione di dati massiva e chip specializzati (TPU, FPGA) per operazioni specifiche.
#align(center, image("images/2025-09-20-18-06-01.png"))

=== Tassonomia di Flynn

La tassonomia di Flynn classifica le architetture parallele in base ai flussi di istruzioni e dati:
//TODO:Rifare tabella?
#align(center, image("images/2025-09-20-18-06-26.png"))
- *SISD* (Single Instruction, Single Data): computer sequenziale tradizionale (es. Intel Pentium 4).
- *SIMD* (Single Instruction, Multiple Data): esegue la stessa istruzione su dati diversi (es. istruzioni SSE di x86).
- *MISD* (Multiple Instruction, Single Data): più istruzioni operano sugli stessi dati. Non esistono esempi reali, anche se gli array sistolici sono talvolta erroneamente classificati come tali.
- *MIMD* (Multiple Instruction, Multiple Data): più processori eseguono istruzioni diverse su dati diversi (es. Intel Xeon Phi).

Un'estensione comune è *SPMD* (Single Program, Multiple Data), in cui lo stesso programma viene eseguito simultaneamente su più processori con dati di input diversi. È un modello comune per i sistemi MIMD.

#align(center, image("images/2025-09-20-18-07-05.png"))

=== Modelli di Programmazione e Framework

Esistono diversi modelli per esprimere il parallelismo nel software:

- *Shared Memory*: (es. OpenMP, pthreads) Facile da usare ma con scalabilità limitata.
- *Message Passing*: (es. MPI) Altamente scalabile ma richiede comunicazione esplicita.
- *Data Parallel*: (es. CUDA, OpenCL) Parallelismo massivo ma specifico per l'hardware.

A un livello più alto, framework come *TensorFlow/PyTorch* (per il machine learning) e *Apache Spark* (per i big data) offrono astrazioni che nascondono la complessità del parallelismo.

==  Architetture Parallele e Memoria

=== Modelli Astratti di Macchina

- *RAM (Random Access Machine)*: modello astratto per un computer sequenziale con memoria illimitata e accesso in tempo unitario. Sebbene i computer moderni si discostino da questo modello, esso ne cattura il comportamento funzionale.
- *PRAM (Parallel Random Access Machine)*: estensione del RAM per computer paralleli, con più unità di esecuzione che accedono a una memoria globale condivisa. Questo modello è irrealistico perché non rappresenta correttamente il comportamento della memoria, portando a previsioni di performance errate.
- *CTA (Candidate Type Architecture)*: un modello più realistico che distingue esplicitamente tra riferimenti a memoria locale (economici) e non locale (costosi). Questo modello descrive correttamente sia le architetture a memoria condivisa che quelle a memoria distribuita.

=== 4.2 Gerarchia della Memoria e Latenza

La *latenza di memoria (λ)*, ovvero il ritardo per accedere a una memoria non locale, può essere da 2 a 5 ordini di grandezza superiore a quella della memoria locale. La gerarchia della memoria (L1, L2, L3 Cache, Main Memory, SSD) presenta velocità di accesso molto diverse.

Sfruttare i *principi di località* (temporale, spaziale, sequenziale) è fondamentale: una buona località può migliorare le prestazioni di 10-100 volte, indipendentemente dal parallelismo. La gestione corretta della gerarchia di memoria, come nel modello CUDA che distingue tra *global memory* (lenta) e *shared memory* (veloce), è essenziale per nascondere la latenza e ottenere speedup significativi.

== Capitolo 5: Metriche di Valutazione delle Prestazioni

=== 5.1 Metriche Fondamentali

Per valutare le prestazioni, si usano diverse metriche:

- *Latenza (Latency)*: tempo medio per elaborare un singolo elemento.
- *Tempo di servizio (Service time)*: intervallo medio tra l'inizio dell'elaborazione di due elementi consecutivi di un flusso.
- *Throughput (o Processing Bandwidth)*: numero medio di operazioni eseguite per unità di tempo, è l'inverso del tempo di servizio.
- *Tempo di completamento (Completion time)*: tempo totale per completare il calcolo su tutti gli elementi.

Mentre in un sistema sequenziale latenza e tempo di servizio coincidono, in un sistema parallelo possono differire: il tempo di servizio è la metrica più importante perché influenza direttamente il tempo di completamento.

=== 5.2 Speedup ed Efficienza

Lo *Speedup (SP)* misura il miglioramento delle prestazioni di un algoritmo parallelo rispetto alla sua versione sequenziale, calcolato come *SP = ts / tP*, dove *ts* è il tempo di esecuzione sequenziale e *tP* è il tempo di esecuzione parallelo con *P* processori.
- Uno speedup è *ideale o lineare* se *SP ≈ P*.
- Uno speedup può essere *superlineare* (*SP > P*) a causa di effetti della cache: la suddivisione dei dati tra più processori può far sì che i dati di ciascuno rientrino completamente nella cache, riducendo i cache miss.

L'*Efficienza (EP)* misura quanto bene vengono utilizzati i processori, calcolata come *EP = SP / P*. Un'efficienza del 100% (*EP = 1*) corrisponde a uno speedup ideale.

=== 5.3 Legge di Amdahl e Legge di Gustafson

La *Legge di Amdahl* (1967) afferma che lo speedup è limitato dalla frazione di codice che deve essere eseguita sequenzialmente (*f*). Lo speedup massimo ottenibile è *1/f*, indipendentemente dal numero di processori. Ad esempio, se il 95% di un programma è parallelizzabile (f=0.05), lo speedup non potrà mai superare 20 volte. Questa legge si applica quando la dimensione del problema è fissa (*strong scaling*).

La *Legge di Gustafson* osserva che, in pratica, all'aumentare delle risorse computazionali, si tende ad aumentare anche la dimensione del problema. In questo scenario (*weak scaling*), la frazione sequenziale del lavoro spesso diminuisce in proporzione, permettendo uno speedup quasi lineare.
La figura seguente mostra come lo speedup, secondo Gustafson, cambi in funzione della frazione parallelizzabile del codice.

![Grafico dello speedup secondo la legge di Gustafson](https://i.imgur.com/k2e4xLg.png)
*(Immagine basata sulla Figura 1.4 delle fonti)*

In sintesi, la legge di Amdahl è rilevante quando l'obiettivo è ridurre il tempo di esecuzione per un carico di lavoro fisso, mentre quella di Gustafson si applica quando si vuole risolvere un problema più grande nello stesso tempo.

=== 5.4 Scalabilità della Memoria

Oltre alla scalabilità del tempo di esecuzione, è cruciale la *scalabilità della memoria*. Se un'applicazione ha una parte dei dati che deve essere replicata su ogni processore, all'aumentare del numero di processori la memoria richiesta su ciascuno può crescere rapidamente fino a diventare un limite insormontabile. Una scalabilità della memoria limitata può impedire l'esecuzione di un programma, a differenza di una scalabilità del tempo di esecuzione limitata che lo rende solo più lento.
La figura sottostante illustra questo concetto, mostrando come gli array replicati (R) crescano con il numero di processori, a differenza di quelli distribuiti (D).

![Scalabilità della memoria con array distribuiti e replicati](https://i.imgur.com/gK9dY9N.png)
*(Immagine basata sulla Figura 1.6 delle fonti)*

== Capitolo 6: Creazione e Ottimizzazione di un Programma Parallelo

=== 6.1 Processo di Parallelizzazione

La creazione di un programma parallelo segue tipicamente tre passaggi:
1. *Decomposizione*: suddividere il problema in task che possono essere eseguiti in parallelo, identificando le dipendenze tra di essi.
2. *Assegnazione (Assignment)*: assegnare i task ai "lavoratori" (thread, processi) cercando di bilanciare il carico e ridurre la comunicazione.
3. *Orchestrazione*: gestire la comunicazione, la sincronizzazione, la schedulazione dei task e l'organizzazione delle strutture dati per ridurre i costi e preservare la località dei dati.

=== 6.2 Fonti di Perdita di Performance e Ottimizzazione

Le principali cause di perdita di performance in un programma parallelo sono:
- *Overhead*: costi aggiuntivi come la creazione e la distruzione di thread.
- *Comunicazione e Sincronizzazione*: costi legati allo scambio di dati e alla coordinazione tra i thread.
- *Contention*: competizione per risorse condivise.
- *Codice non parallelizzabile*: la parte sequenziale che limita lo speedup secondo la legge di Amdahl.
- *Scarsa località della memoria*: accessi non ottimizzati alla memoria che aumentano la latenza.

Per migliorare le prestazioni, è necessario:
- *Affrontare le dipendenze dei dati*: minimizzare la lunghezza del percorso critico (*span*), ovvero la catena più lunga di operazioni sequenziali.
- *Scegliere la giusta granularità*: trovare un equilibrio tra parallelismo a grana grossa (poche interazioni) e a grana fine (interazioni frequenti).
- *Identificare hotspot e bottleneck*: concentrare gli sforzi di parallelizzazione sulle parti del codice che eseguono la maggior parte del lavoro e ottimizzare le sezioni che rallentano il programma, come l'I/O.