#import "../../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()
= Processi & Thread
== Il Modello Concorrente e il Concetto di Processo

Un sistema di elaborazione moderno è in grado di eseguire un elevato numero di attività, sia di programmi utente che di sistema, che spesso si sovrappongono nel tempo. Questa sovrapposizione può avvenire tramite *interleaving*#index[Interleaving], dove le attività si alternano sull'unica CPU disponibile, o tramite *overlapping*#index[Overlapping], dove le attività vengono eseguite simultaneamente su CPU diverse.

#figure(image("images/image.png", height: 30%))

Per gestire e analizzare questa coesistenza di attività, è stato sviluppato il *modello concorrente*, che si basa sul concetto astratto di *processo*.

#index[Programma]
#index[Processo]
#definition(
  "Programma e Processo",
)[
  Un *programma* è definito come un'entità passiva e statica, come un file eseguibile contenente un algoritmo memorizzato su disco. Al contrario, un *processo* è un'entità attiva e dinamica che rappresenta l'esecuzione di un programma. Un programma si trasforma in un processo nel momento in cui il suo file eseguibile viene caricato in memoria principale.
]

Lo stato attuale di un processo è determinato dal valore del Program Counter e dal contenuto degli altri registri della CPU. I processi sono fondamentali per la *multiprogrammazione* e il *multitasking*, consentendo a un calcolatore di eseguire più programmi “contemporaneamente” attraverso la condivisione di una o più CPU.

== Struttura di un processo in memoria

Lo spazio di indirizzamento di un processo è suddiviso in diverse sezioni fondamentali:

- *Testo*: Contiene il codice eseguibile del programma. Le sue dimensioni sono fisse e non cambiano durante l'esecuzione.
- *Dati*: Contiene le variabili globali. Anche questa sezione ha dimensioni fisse.
#index[Heap]
- *Heap*: Un'area di memoria allocata dinamicamente durante l'esecuzione del programma, utilizzata ad esempio per strutture dati dinamiche. L'heap può crescere e ridursi dinamicamente, espandendosi quando la memoria viene allocata (ad esempio tramite la system call `malloc`) e riducendosi quando viene rilasciata.
#index[Stack]
- *Stack*: Un'area di memoria temporanea utilizzata durante le chiamate di funzione per memorizzare parametri, indirizzi di ritorno e variabili locali. Anche lo stack può espandersi e contrarsi dinamicamente. Quando una funzione viene chiamata, un record di attivazione (o stack frame) viene inserito sullo stack e rimosso al termine della funzione.

#figure(image("images/image 1.png", height: 20%))

Il sistema operativo ha il compito di garantire che le sezioni stack e heap, che crescono l'una verso l'altra, non si sovrappongano.

== Stati e Diagramma degli Stati di un Processo

Nel corso della sua vita, un processo attraversa diversi stati:

- *Nuovo (new)*: il processo viene inizialmente creato.
- *In esecuzione (running)*: le istruzioni del processo sono attivamente eseguite dalla CPU. Su una singola CPU o core, solo un processo può essere in questo stato in un dato momento.
- *In attesa (waiting)*: il processo è sospeso, in attesa che si verifichi un evento specifico, come il completamento di un'operazione di I/O.
- *Pronto (ready)*: il processo è stato caricato in memoria principale ed è in attesa di essere assegnato a un processore per l'esecuzione.
- *Terminato (terminated)*: l'esecuzione del processo è giunta al suo completamento.

#figure(image("images/image 2.png", height: 15%))

È comune che molti processi si trovino contemporaneamente negli stati "pronto" o "in attesa".

== Descrittore di Processo (Process Control Block - PCB)
#index[PCB - Process Control Block]
La gestione dei processi da parte del kernel del sistema operativo si avvale del *Process Control Block (PCB)*, una struttura dati unica associata a ogni processo. Il PCB contiene informazioni essenziali sia per l*'esecuzione del processo* (come privilegi, priorità, risorse assegnate) sia per *la sua gestione* *quando non è in esecuzione* (come il contenuto dei registri al momento della sospensione).

Quando un processo interrompe l'esecuzione o passa a uno stato di attesa, le sue informazioni vengono salvate nel PCB; viceversa, quando un processo è selezionato per l'esecuzione, le sue informazioni vengono caricate dal PCB. Tutti i PCB dei processi attivi nel sistema sono organizzati in una *tabella dei processi* #index[Tabella dei processi], residente in un'area di memoria principale accessibile solo al kernel.

Il PCB è una struttura complessa che include:

- Un puntatore al successivo PCB in una coda, per facilitare la gestione delle liste di processi.
- Lo stato corrente del processo (Process State).
- Un numero identificativo univoco (Process Number).
- Il contesto del processo, comprendente il Program Counter e altri registri della CPU (es. stack pointer, program status word).
- Informazioni sulla gestione della memoria (es. registri base e limite, tabelle delle pagine o dei segmenti).
- Informazioni sull'utilizzo delle risorse (es. file aperti, dispositivi I/O assegnati, tempo di utilizzo della CPU, PID del genitore e dei figli).
- Dettagli sulle modalità di servizio (es. FIFO, priorità).
- Informazioni sull'evento atteso, se il processo è bloccato.

#figure(image("images/image 3.png", height: 20%))

== Monoprogrammazione e Multiprogrammazione

#figure(image("images/image 4.png", height: 20%))
#index[Monoprogrammazione]
Storicamente, i primi sistemi operativi operavano in *monoprogrammazione*, eseguendo un solo programma utente alla volta in memoria, oltre al sistema operativo stesso. Questo approccio, esemplificato dal DOS, non sfruttava appieno le capacità della CPU.
#index[Multiprogrammazione]
Per ottimizzare l'uso della CPU, è stata introdotta la *multiprogrammazione*. L'idea fondamentale è che se un processo utilizza la CPU solo parzialmente, l'esecuzione simultanea di più processi può portare a un utilizzo più efficiente. La probabilità di utilizzo della CPU aumenta proporzionalmente al *grado di multiprogrammazione*#index[Grado multiprogrammazione], ovvero al numero di processi residenti in memoria centrale. Questo può portare a guadagni significativi nell'efficienza della CPU, come dimostrato dall'esempio che mostra un aumento dell'utilizzo della CPU aumentando il numero di processi in memoria.

#figure(image("images/image 5.png", height: 30%))

== Scheduling dei Processi
Gli obiettivi dello scheduling sono duplici: massimizzare l'utilizzo della CPU (multiprogrammazione) e garantire una rapida interazione utente (multitasking o time-sharing). Il sistema operativo mantiene un insieme di processi in memoria, e quando la CPU è disponibile, uno scheduler seleziona un processo pronto per l'esecuzione.

Per un'ottimale gestione, lo scheduler tiene conto del comportamento dei processi:
- Un *processo CPU-bound* esegue intense computazioni e raramente richiede I/O, utilizzando la CPU per lunghi periodi.
- Un *processo I/O-bound* effettua poche computazioni ma genera molte richieste di I/O, usando la CPU per brevi intervalli.

Le migliori prestazioni si ottengono con una combinazione equilibrata di questi tipi di processi.

Le strutture dati utilizzate per lo scheduling includono la tabella dei processi, il PCB del processo in esecuzione e diverse *code di processi* (come la coda dei processi pronti e le code specifiche per i dispositivi di I/O).

#figure(
  image("images/image 6.png", height: 20%),
  caption: "Il diagramma di accodamento illustra il flusso dei PCB tra queste code durante il ciclo di vita di un processo.",
)

Esistono tre tipologie principali di scheduling:
#index[Sched. breve termine]
- *Scheduling a breve termine (o della CPU)*: decide quale processo pronto deve essere assegnato alla CPU. Interviene frequentemente (nell'ordine dei millisecondi) ed è cruciale che sia molto veloce.
#index[Sched. medio termine]
- *Scheduling a medio termine (swapping)*: trasferisce temporaneamente processi parzialmente eseguiti tra la memoria principale e quella secondaria (swap-out/swap-in). Questo è utile quando la memoria principale è insufficiente e aiuta a controllare il grado di multiprogrammazione o a bilanciare i tipi di processi. Questo tipo di scheduler è comune nei sistemi time-sharing.
#index[Sched. lungo termine]
- *Scheduling a lungo termine*: seleziona quali programmi dalla memoria secondaria devono essere caricati in memoria principale. Controlla il grado di multiprogrammazione del sistema e la sua frequenza di esecuzione dipende da questo fattore.

Il diagramma degli stati di un processo può essere esteso per includere stati come “pronto swapped” e “attesa swapped”, che indicano processi la cui memoria si trova nella swap area del disco.

#figure(image("images/image 7.png", height: 20%), caption: "Diagramma degli stati esteso")

=== Context Switch (Commutazione di Contesto)
#index[Context Switch]
#definition(
  "Context Switch",
)[
  Il *context switch* è la procedura attraverso cui l'utilizzo della CPU viene trasferito da un processo all'altro. Implica il salvataggio dello stato di esecuzione del processo corrente e il ripristino del contesto del processo successivo da eseguire.
]

Le fasi che utilizzano il PCB sono:

1. Salvataggio del contesto del processo in esecuzione nel suo PCB.
2. Inserimento del PCB nelle code appropriate (di attesa o di pronti).
3. Caricamento dell'indirizzo del PCB del nuovo processo nel registro che punta al processo in esecuzione.
4. Caricamento del contesto del nuovo processo nei registri del processore.

#figure(image("images/image 8.png", height: 30%))

Il tempo dedicato al context switch è un *overhead* puro per la gestione del sistema, in quanto non produce lavoro utile. Questo processo può richiedere diversi microsecondi e la sua velocità può dipendere dal supporto hardware. La complessità crescente dei sistemi operativi può aumentare il lavoro durante un context switch, specialmente per tecniche avanzate di gestione della memoria.

== Operazioni sui Processi

Il kernel del sistema operativo fornisce meccanismi specifici, richiamabili tramite system call, per la gestione dei processi. Questi includono la *creazione*, la *terminazione* e l'*interazione tra processi (IPC)*.

=== Creazione di Processi

I processi possono essere creati staticamente (ad esempio, all'inizializzazione del sistema) o dinamicamente (tramite system call, richieste utente o lancio di programmi). Al momento della creazione di un processo, il SO esegue i seguenti compiti:

- Assegna un identificatore unico al processo (PID).
- Alloca la memoria principale necessaria (per codice, dati, stack, heap).
- Assegna altre risorse come tempo di CPU, dispositivi di I/O e file.
- Inizializza e collega il PCB con le altre strutture del SO.

I processi possono organizzarsi in una *struttura ad albero*, dove un processo “genitore” può creare processi “figli”, che a loro volta possono generare altri processi. In un sistema Linux, il processo `systemd` (PID 1) è il primo ad essere creato all'avvio e agisce come genitore per tutti i processi utente e i servizi di sistema. Il kernel definisce politiche per la condivisione delle risorse tra genitore e figlio (tutte, un sottoinsieme o nessuna), le modalità di esecuzione (concorrente o con attesa del genitore) e l'uso dello spazio di indirizzamento (figlio come clone o con programma diverso). Ad esempio, in UNIX, la system call `fork()` crea un nuovo processo, e `exec()` può essere usata per caricare un programma diverso nel processo figlio.

#image("images/image 9.png")

=== Terminazione di Processi

La terminazione di un processo può essere volontaria o involontaria.
#index[Terminazione volontaria]
- La *terminazione volontaria* si verifica quando il processo completa la sua esecuzione (tramite l'ultima istruzione o una `exit`). Tutte le risorse assegnate al processo vengono deallocate. Il genitore può ricevere il codice di terminazione del figlio attraverso la system call `wait`.
#index[Terminazione involontaria]
- La *terminazione involontaria* può essere causata da un errore fatale o dalla terminazione forzata da un altro processo (ad esempio, un genitore che interrompe un figlio per eccesso di risorse, o se il task del figlio non è più necessario, o in caso di terminazione a cascata del genitore).

In sistemi come UNIX/Linux, esistono specifici stati per i processi terminati:
#index[Processi Zombie]
- I *processi zombie* sono processi che hanno terminato l'esecuzione ma il cui PCB non è ancora stato rimosso in attesa che il processo genitore accetti il loro codice di terminazione.
#index[Processi Orfani]
- I *processi orfani* sono processi il cui genitore è terminato senza attenderli; vengono “adottati” dal processo `init` (o `systemd` nei sistemi recenti), che periodicamente invoca `wait` per liberare i loro PCB.

#image("images/image 10.png")

=== Comunicazione tra Processi (IPC)

I processi possono essere *indipendenti* (non influenzano altri processi e non condividono dati, con un comportamento deterministico e riproducibile) o *interagenti (o cooperanti)* (possono influenzarsi a vicenda, con un comportamento non deterministico e non sempre riproducibile). Le stesse funzioni del sistema operativo sono spesso realizzate da processi interagenti.
Esistono diversi motivi per consentire l'interazione tra processi:

- *Condivisione di informazioni*: permettere a diverse applicazioni di accedere agli stessi dati.

- *Prestazioni*: suddividere un'attività complessa in sotto-attività eseguibili in parallelo per accelerare l'esecuzione.

- *Modularità*: organizzare un'applicazione in componenti separati (processi o thread).

Per l'interazione tra processi è necessario un meccanismo di *Comunicazione Interprocesso (IPC)*. I due modelli fondamentali di IPC sono:
#index[Ambiente globale]
- *Ambiente globale (memoria condivisa)*: i processi condividono una parte dello spazio di indirizzamento, richiedendo meccanismi di mutua esclusione per evitare non-determinismo. Esempi di strumenti forniti dal SO includono semafori e monitor.
#index[Ambiente locale]
- *Ambiente locale (scambio di messaggi)*: gli spazi di indirizzamento dei processi sono separati. Gli strumenti includono operazioni di `send` e `receive` per lo scambio di messaggi.

#image("images/image 11.png")

Lo *scambio di messaggi* è più semplice per lo scambio di piccole quantità di dati e più facile da implementare in sistemi distribuiti. La *memoria condivisa*, invece, può essere più veloce perché, una volta stabilite le aree condivise, gli accessi ai dati non richiedono l'intervento del kernel, a differenza dello scambio di messaggi che spesso implica system call. Nei sistemi con memoria condivisa, i processi interagenti sono responsabili sia del tipo di dati scambiati sia della sincronizzazione per evitare conflitti.

Il meccanismo di *scambio di messaggi* richiede operazioni di `send(message)` e `receive(message)` e la creazione di un canale di comunicazione tra i processi. I messaggi possono avere dimensione fissa o variabile. I canali di comunicazione possono essere fisici (es. memoria condivisa, bus) o logici.

=== Forme di Comunicazione nello Scambio di Messaggi

La comunicazione tramite messaggi può essere distinta per vari aspetti:
- *Comunicazione diretta*:
  #index[Comunicazione diretta]
  - *Diretta simmetrica*: i processi si nominano esplicitamente (`send(P, message)`, `receive(Q, message)`). I canali sono stabiliti automaticamente, associati a una singola coppia di processi, unici e solitamente bidirezionali.

  - *Diretta asimmetrica*: solo il mittente nomina il ricevente (`send(P, message)`, `receive(id, message)`). Entrambi gli schemi diretti possono limitare la modularità nella definizione dei processi.
 
#index[Comunicazione indiretta]
- *Indiretta*: i messaggi vengono inviati o ricevuti tramite *porte* (o mailbox), ognuna con un identificatore unico (`send(A, message)`, `receive(A, message)`). Un canale si stabilisce quando i processi condividono una porta, che può essere associata a molti processi. Una coppia di processi può condividere diversi canali. Per evitare non-determinismo quando più processi possono ricevere da una porta, si possono adottare soluzioni come limitare la porta a due processi, consentire un solo ricevente per porta, o far scegliere arbitrariamente il sistema. Le porte possono appartenere a un processo (con unico ricevente) o essere gestite dal SO.

#index[Comunicazione sincrona]
#index[Comunicazione asincrona]
- *Comunicazione sincrona o asincrona*: Le operazioni `send` e `receive` possono essere *bloccanti (sincrone)* o *non-bloccanti (asincrone)*. Un invio bloccante ferma il mittente finché il messaggio non è ricevuto; una ricezione bloccante ferma il ricevente finché un messaggio non è disponibile. Un *rendezvous* si ha quando sia `send` che `receive` sono bloccanti. Con operazioni non-bloccanti, il mittente invia e prosegue, mentre il ricevente acquisisce un messaggio o un valore nullo e non si blocca.

- *Gestione del buffer associato al canale*: I messaggi sono memorizzati in code associate ai canali. Le code possono avere:

  + *Capacità 0*: Nessun messaggio nella coda, il mittente si blocca finché il destinatario non riceve (rendezvous, sistema senza buffering).
  + *Capacità limitata*: Coda di lunghezza finita, il mittente si blocca se la coda è piena.
  + *Capacità illimitata*: Coda di lunghezza infinita, il mittente non si blocca mai (sistema con buffering automatico).

Esempi di sistemi IPC includono le API POSIX per la memoria condivisa, Mach per lo scambio di messaggi e le pipe UNIX.

== Comunicazione nei Sistemi Client-Server

Nei sistemi client-server, oltre alla memoria condivisa e allo scambio di messaggi, si utilizzano due meccanismi di comunicazione aggiuntivi: *socket* e *Remote Procedure Call (RPC)*.

#index[Socket]
#definition(
  "Socket",
)[
Un *socket* è l'estremità di un canale di comunicazione, identificato da un indirizzo IP e un numero di porta (es. `161.25.19.8:1625` in UNIX). I server ascoltano su porte prestabilite per specifici servizi (es. HTTP sulla porta 80).
]

Una connessione di rete è stabilita tra una coppia di socket. La comunicazione tramite socket è considerata di basso livello perché scambia un flusso non strutturato di byte; è responsabilità delle applicazioni client/server imporre una struttura sui dati.

#image("images/2025-08-03-15-46-08.png")

#index[RPC-Remote Procedure Call]
#definition(
  "Remote Procedure Call RPC",
)[
  La *Remote Procedure Call (RPC)* offre un metodo di comunicazione di livello più alto, estendendo il meccanismo di chiamata di procedura a sistemi collegati in rete.
]

#index[Stub]
#definition("Stub")[
  Segmento di codice risiedente sul client che interagisce con l'effettiva procedura risiedente sul server.
]

#index[Marshalling]
#index[Unmarshalling]
Quando un client invoca una RPC, il sistema RPC chiama uno *stub* sul client. Lo stub del client localizza la porta del server, effettua il *marshalling* (strutturazione dei parametri per la trasmissione in rete) e l'*unmarshalling* dei risultati. Analogamente, lo stub del server riceve il messaggio, effettua l'unmarshalling dei parametri, invoca la procedura sul server e quindi esegue il marshalling dei risultati per inoltrarli al client. Per determinare la porta del server per una RPC specifica, il client prima comunica con un servizio `matchmaker` sul server, che risponde su una porta prestabilita e restituisce la porta della RPC effettiva; questo comporta due comunicazioni per ogni RPC.

#align(center, image("images/2025-08-03-15-46-33.png"))

== Processi vs Thread

Tradizionalmente, un *processo* è un'entità che comprende sia risorse (sezione di codice, dati, file aperti, gestori di segnali) sia un flusso di controllo dell'esecuzione (lo stato della CPU). #index[Thread]Un *thread*, o *processo leggero*, è definito come un elemento che rappresenta un flusso di controllo dell'esecuzione. Di conseguenza, un processo tradizionale può essere anche chiamato *processo pesante*.
La chiave del multithreading è la *separazione e gestione indipendente* di questi due aspetti, permettendo a un processo di contenere al suo interno più thread che condividono le risorse assegnate al processo stesso.

Con l'introduzione dei thread, lo stato di un processo viene logicamente diviso:
- Lo *stato delle risorse* è unico e associato all'intero processo.
- Lo *stato dell'esecuzione* (cioè lo stato della CPU) è replicato per ogni singolo thread.

Avere più thread eseguiti in parallelo all'interno di un processo è concettualmente simile ad avere più processi eseguiti su un calcolatore. La differenza fondamentale è che i thread all'interno dello stesso processo condividono lo spazio di indirizzamento e le risorse assegnate al processo dal sistema operativo, mentre i processi diversi condividono le risorse hardware come memoria fisica, dischi e stampanti.

L'adozione dei thread migliora le prestazioni del sistema, in particolare riducendo l'overhead del *context switch*. La commutazione tra thread dello stesso processo è più veloce rispetto a quella tra processi perché richiede solo la modifica dello stato dell'esecuzione (stato della CPU) e non dello stato delle risorse, che rimane comune. Analogamente, le operazioni di creazione e terminazione dei thread sono più rapide. Alcune CPU offrono anche supporto hardware diretto per il multithreading, accelerando ulteriormente il context switch a nanosecondi.

Inoltre, la separazione degli spazi di indirizzamento nei processi tradizionali rende complessa l'interazione basata sull'accesso a strutture di dati comuni. I thread, condividendo lo spazio di indirizzamento, semplificano l'implementazione di applicazioni che richiedono accesso a dati comuni, come i sistemi di controllo di impianti fisici o i programmi di elaborazione testi che eseguono attività concorrenti (es. ascolto tastiera, scrittura su video, salvataggio periodico, correzione ortografica) sugli stessi dati.

== Concetto di Thread

Un thread è caratterizzato da:
- Un identificatore.
- Uno stato di esecuzione (pronto, in attesa, in esecuzione).
- Uno spazio di memoria per le variabili locali.
- Un contesto, rappresentato dai valori del Program Counter e dei registri della CPU.
- Uno stack.
#index[TCB-Thread Control Block]
Se i thread sono gestiti dal SO, a ogni thread è associato un Thread Control Block (TCB).

#align(center, image("images/2025-08-03-15-55-30.png"))

#align(
  center,
  figure(
    image("images/2025-08-03-15-56-18.png"),
    caption: "Gli elementi nella colonna di sinistra sono condivisi da tutti i thread di uno stesso processo. Quelli della colonna di destra sono replicati per ogni thread.",
  ),
)

I *processi single-thread* operano in modo indipendente, con il proprio program counter, stack pointer, spazio di indirizzamento e set di file aperti, e sono adatti per task non correlati.

I *processi multithread*, grazie alla condivisione, utilizzano meno risorse (memoria, file aperti, scheduling della CPU) e sono più efficienti per task correlati. Entrambi i tipi possono coesistere nello stesso sistema.

Un esempio pratico è un *server web multithread* (, che può essere scomposto in un dispatcher (che riceve le richieste e le assegna) e un numero fisso di worker (che le elaborano). Se un worker si blocca (es. per un'operazione di I/O come la lettura da disco), un altro worker può essere eseguito, migliorando la reattività del server.

#align(center, image("images/2025-08-03-15-58-45.png"))


I *vantaggi principali dell'uso dei thread* includono:
- *Prontezza di risposta*: se un thread è bloccato, altri thread dello stesso processo possono continuare l'esecuzione.
- *Condivisione di risorse*: i thread condividono la memoria e le risorse del processo, facilitando la collaborazione su dati comuni.
- *Prestazioni (Economia)*: il context switch tra thread è più rapido rispetto a quello tra processi, così come le operazioni di creazione e terminazione.
- *Scalabilità*: in architetture multiprocessore/core, i thread possono essere eseguiti in parallelo su core distinti, sfruttando appieno la potenza di calcolo.

== Architetture Multicore e Programmazione Multicore
#index[Multicore]
L'evoluzione dei sistemi di elaborazione ha portato all'emergere di architetture *multicore*, dove più unità di elaborazione (core) sono integrate sullo stesso chip, e ciascun core è visto dal sistema operativo come una CPU separata.

La *programmazione multithread su sistemi multicore* offre l'opportunità di utilizzare in modo più efficiente questi core e di aumentare il grado di concorrenza. In un sistema multicore, l'esecuzione concorrente si traduce in *esecuzione parallela effettiva*, poiché diversi thread possono essere assegnati a core distinti e progredire simultaneamente, a differenza dei sistemi a singolo core dove si ha solo interleaving.

#align(center, image("images/2025-08-03-16-00-25.png"))

Esistono due tipi principali di parallelismo:
#index[Parallelismo dati]
- *Parallelismo dei dati*: Consiste nel distribuire sottoinsiemi di dati su più core, dove ogni core esegue la stessa attività (thread) su una porzione differente dei dati (es. la somma dei valori in un vettore).
#index[Parallelismo attività]
- *Parallelismo delle attività*: Implica la distribuzione di attività distinte su più core, dove ogni attività esegue un'operazione differente sugli stessi dati o su dati diversi (es. diverse operazioni sugli elementi di un vettore).

#align(center, image("images/2025-08-03-16-01-12.png"))

La programmazione multicore presenta tuttavia diverse *sfide*:
- *Identificazione dei task*: Suddividere l'applicazione in task concorrenti che possano essere eseguiti in parallelo.
- *Bilanciamento*: Distribuire il carico di lavoro in modo equilibrato tra i vari task e core.
- *Suddivisione dei dati*: Organizzare e distribuire i dati manipolati dai task per un uso efficiente su core distinti.
- *Individuazione delle dipendenze dei dati*: Sincronizzare l'esecuzione dei task per rispettare le dipendenze basate sui dati prodotti e consumati.
- *Test e debugging*: Risultano più complessi in ambienti con flussi di esecuzione multipli rispetto alla programmazione a singolo thread.

== Modelli di Multithreading

La gestione dei thread può essere implementata a *livello utente* (gestita da una libreria al di sopra del kernel) o a *livello kernel* (direttamente gestita dal sistema operativo). Questi due approcci influenzano significativamente l'overhead del context switch e il grado di concorrenza e parallelismo all'interno dei processi.

=== Thread a Livello Utente

In questo modello, la gestione dei thread è affidata a una *libreria di funzioni a livello utente*, che è collegata al codice di ogni processo e funge da sistema run-time per l'esecuzione dei thread. Le funzioni di questa libreria (per creazione, terminazione, sincronizzazione e scheduling dei thread) vengono eseguite in modalità utente, evitando l'invocazione di system call dirette.
Ogni processo mantiene una tabella dei thread nella propria memoria utente, contenente i Thread Control Block (TCB) che memorizzano lo stato dei singoli thread.
Il *kernel non è a conoscenza* dell'esistenza di questi thread e schedula solo i processi. Quando un thread utente esegue un'operazione che potrebbe causarne il blocco, invoca una funzione della libreria run-time che gestisce lo scheduling interno dei thread del processo.

I *vantaggi* dei thread a livello utente includono:
- *Efficienza*: lo scheduling e il salvataggio/ripristino dello stato dei thread sono molto rapidi, poiché avvengono senza l'overhead delle system call.
- *Flessibilità*: il programmatore può personalizzare la politica di scheduling dei thread per adattarla al processo.
- *Portabilità*: funzionano su qualsiasi sistema operativo, anche quelli che non supportano direttamente i thread, poiché il SO interagisce solo con i processi.

Tuttavia, presentano anche *svantaggi*:
- *Mancanza di prelazione*: se un thread inizia l'esecuzione, nessun altro thread del processo può essere eseguito finché il primo non rilascia volontariamente la CPU.
- *Blocco dell'intero processo*: l'invocazione di una system call bloccante da parte di un thread blocca tutti i thread del processo; per evitarlo, si usano routine di libreria che “avvolgono” (wrapping/jacketing) la system call e bloccano solo il thread invocante.
- *Accesso sequenziale al kernel*: poiché il kernel schedula i processi e la libreria schedula i thread al loro interno, l'accesso al kernel da parte dei thread dello stesso processo avviene sequenzialmente.
- *Non sfruttano i sistemi multiprocessore*: tutti i thread dello stesso processo devono risiedere sullo stesso processore.
- Meno utili per processi I/O bound.

#align(center, image("images/2025-08-03-16-05-23.png"))

=== Thread a Livello Kernel

In questo modello, la gestione dei thread è *direttamente effettuata dal kernel* del sistema operativo, con operazioni di creazione, terminazione e verifica dello stato eseguite tramite system call. Il kernel mantiene una propria tabella dei thread. Quando un thread si blocca, il kernel salva lo stato della CPU nel suo TCB e lo scheduler seleziona un altro thread per l'esecuzione.
Se il thread selezionato appartiene a un processo diverso, il dispatcher salva lo stato del processo corrente e carica quello del nuovo processo prima di avviare il thread. La commutazione tra thread appartenenti allo stesso processo è comunque più veloce rispetto alla commutazione tra processi.

I *vantaggi* dei thread a livello kernel includono:
- *Scheduling della CPU per thread*: se un thread esegue una system call bloccante, il kernel può passare a un altro thread dell'applicazione, evitando di bloccare l'intero processo.
- *Convenienza per il programmatore*: la programmazione con thread a livello kernel è simile a quella con processi, ma con meno stato da gestire.
- *Parallelismo all'interno di un processo*: in un sistema multicore, i thread di un processo possono essere eseguiti in overlapping su core diversi, sfruttando il parallelismo.
- Particolarmente utili per i processi I/O bound.

Gli *svantaggi* sono:
- *Flessibilità*: la politica di scheduling è predefinita dal kernel.
- *Efficienza*: le operazioni sui thread, essendo system call, comportano un overhead maggiore rispetto alla gestione a livello utente.
- *Portabilità*: può richiedere modifiche o riscritture di system call esistenti per supportare i thread.

#align(center, image("images/2025-08-03-16-05-35.png"))

=== Modelli di Corrispondenza (Mapping)
#index[Modello di corrispondenza]
Nei sistemi moderni, dove spesso coesistono thread a entrambi i livelli, è necessaria un'associazione tra i thread a livello utente e quelli a livello kernel, poiché solo questi ultimi vengono assegnati alla CPU dal kernel. Questi modelli influenzano flessibilità, efficienza, concorrenza e parallelismo.
I modelli comuni sono:
- *Molti-a-uno*: Molti thread a livello utente sono mappati su un singolo thread del kernel. È efficiente perché gestito a livello utente, ma un thread bloccato su una system call blocca l'intero processo e non sfrutta il parallelismo multicore. Questo modello è oggi poco utilizzato.
#align(center, image("images/2025-08-03-16-06-56.png"))
- *Uno-a-uno*: Ogni thread a livello utente è associato a un thread del kernel. Offre maggiore concorrenza (un thread può essere eseguito se un altro si blocca) e consente l'esecuzione in overlapping. La creazione di ogni thread utente implica la creazione di un thread kernel, il che può influire sulle prestazioni se il numero di thread è elevato. Questo modello è adottato dalla maggior parte dei SO moderni (come Linux e Windows).
#align(center, image("images/2025-08-03-16-07-05.png"))
- *Molti-a-molti*: Molti thread a livello utente sono associati a molti thread del kernel. Questo modello è flessibile, consentendo ai programmatori di creare un numero arbitrario di thread utente senza impattare direttamente sul numero di thread kernel. Offre elevata concorrenza e parallelismo, permettendo l'esecuzione in overlapping. La sua implementazione è complessa.
#align(center, image("images/2025-08-03-16-07-12.png"))
- *A due livelli*: Una variante del modello molti-a-molti che permette anche associazioni uno-a-uno.
#align(center, image("images/2025-08-03-16-07-20.png"))

== Librerie di Thread

Una *libreria di thread* fornisce un'API per la creazione e la gestione dei thread. Esistono due principali metodi di implementazione:
- *Interamente nello spazio utente*: Le strutture dati e il codice della libreria risiedono nello spazio utente. Invocare una funzione dell'API si traduce in una chiamata di funzione locale, senza una system call al kernel.
- *Supportata direttamente dal kernel del SO*: Le strutture dati e il codice della libreria sono nel kernel. Invocare una funzione dell'API generalmente comporta una system call.

Le tre librerie di thread più comunemente usate sono:
- *Windows*: Una libreria a livello kernel, specifica per i sistemi Windows.
- *Pthreads*: Un'estensione dello standard POSIX, può essere implementata sia a livello utente che a livello kernel, ed è disponibile per sistemi POSIX-compatibili come UNIX, Linux e macOS.
- *Threading Java*: I thread Java vengono eseguiti su qualsiasi sistema che supporta la JVM e sono solitamente implementati tramite la libreria di thread del sistema operativo ospitante.