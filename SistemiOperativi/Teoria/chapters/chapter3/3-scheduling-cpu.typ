#import "../../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

= Scheduling della CPU

Nella maggior parte dei SO moderni, sono i thread a livello kernel e *non* i processi ad essere schedulati dal SO. Nei seguenti capitoli si parlerà di scheduling dei procesi quando ci si riferisce a concetti generali di scheduling e di scheduling dei thread quando vorremo fare riferimento allo scheduling dei thread.

== Concetti Fondamentali
#index[Multitasking]
L'obiettivo della *multiprogrammazione* è utilizzare al meglio la CPU mantenendo sempre un processo in esecuzione. Il *multitasking* (o time-sharing) mira a commutare la CPU tra i processi con una frequenza tale da permettere agli utenti di interagire con ciascun programma mentre è in esecuzione. Per raggiungere questi obiettivi, il sistema operativo mantiene un insieme di processi in memoria e uno scheduler a breve termine seleziona il processo pronto per l'esecuzione quando la CPU diventa disponibile.
#index("Burst", "CPU burst")
#index("Burst", "I/O burst")
Ogni processo alterna ciclicamente tra due fasi: l'*esecuzione di istruzioni (CPU burst)* e l'*attesa di eventi o operazioni esterne (I/O burst)*. La durata dei CPU burst, sebbene variabile, tende a seguire una curva di frequenza esponenziale o iperesponenziale, con molti burst brevi e pochi lunghi.

#image("images/2025-08-06-22-29-02.png")

Sebbene le durate dei burst (sequenza di istruzioni) variano molto da processo a processo e da computer a computer, esse tendono ad avere una curva di frequenza come la seguente:

#figure(
  image("images/Immagine.png"),
  caption: "La curva è generalmente caratterizzata come iperesponenziale, con un numero elevato di burst della CPU brevi e un numero ridotto di burst della CPU lunghi.",
)

#image("images/2025-08-06-22-35-05.png")

#index[CPU-bound]
#index[I/O-bound]
A seconda della prevalenza di queste fasi, i processi vengono classificati in:
- *Processi CPU-bound*: dedicano la maggior parte del tempo a computazioni, effettuano pochi I/O, e presentano generalmente pochi e lunghi CPU burst.
- *Processi I/O-bound*: effettuano poche computazioni ma molti I/O, usano la CPU per brevi intervalli, e presentano generalmente molti CPU burst di breve durata.
L'immagine illustra visivamente questa alternanza, mostrando un processo CPU-bound (a) che spende la maggior parte del tempo in computazione, e un processo I/O-bound (b) che trascorre più tempo in attesa di I/O.

=== Tecniche di multiprogrammazione

Il kernel dei sistemi operativi moderni gestisce tipicamente un mix di processi I/O-bound e CPU-bound assegnando priorità più alte ai processi I/O-bound. Ciò consente di allocare la CPU al processo con la priorità maggiore e di interrompere un processo in esecuzione se ne subentra uno a priorità più alta.

#image("images/2025-08-06-22-37-02.png")

- #strong("Aggiungere un programma CPU-bound:") se aggiungessimo un prog_3, esso avrebbe la priorità più bassa e dunque non influirebbe su prog_iob e proh_cb. Allo stesso tempo prog_3 aumenterebbe l'utilizzo di tempo di CPU perché permetterebbe di utilizzare tempo di CPU non utilizzato (t6-t7 e t8-t9).

- #strong("Aggiungere un programma IO-bound:") se aggiungessimo prog4, esso avrebbe una priorità compresa tra quella di prog_iob e prog_cb. La presenza di prog_4 aumenterebbe l'utilizzo dell'I/O. Non danneggerebbe il progresso di prog_iob poiché prog_iob ha la priorità più alta, mentre ridurrebbe il progresso di prog_cb solo marginalmente poiché prog_4, essendo I/O-bound, non utilizza una quantità significativa di tempo di CPU.

#index[Throughput]
#definition("Throughput")[
  Il numero di processi completati da un sistema in una unità di tempo.
]

Il *throughput* aumenta generalmente con il grado di multiprogrammazione quando si mantiene un mix appropriato di processi. Quando il grado di multiprogrammazione è 1 il throughput è determinato dal tempo trascorso dall'unico programma nel sistema.

#image("images/2025-08-06-22-43-18.png")

=== Scheduler della CPU

Lo *scheduler a breve termine* è la componente del SO che decide quale processo o thread otterrà la CPU tra quelli in competizione. La sua azione è determinata dalla *politica di scheduling*. Lo scheduler può intervenire in diverse situazioni, come quando un processo passa da stato di esecuzione a stato di attesa o pronto, o quando termina.

La politica di scheduling determina la gestione a breve termine
del processore così chiamata per distinguerla da:
- *Gestione a lungo termine* che sceglie tra i programmi in memoria secondaria quali caricare in memoria principale regolando così il grado di multiprogrammazione del sistema.
- *Gestione a medio termine (swapping)* che sceglie i processi parzialmente eseguiti da trasferire temporaneamente in memoria secondaria (e viceversa) con l'obiettivo di ridurre il grado di multiprogrammazione o migliorare il bilanciamento delle tipologie di processi.

#index("Scheduler", "senza prelazione")
#definition(
  "Scheduler senza prelazione",
)[Uno scheduler è *senza prelazione (non-preemptive)* se interviene solo quando un processo passa dallo stato di esecuzione allo stato di attesa o termina. In questo caso, un processo mantiene la CPU finché non la rilascia volontariamente.]

#index("Scheduler", "con prelazione")
#definition(
  "Scheduler con prelazione",
)[
  Uno scheduler è *con prelazione (preemptive)* se interviene anche negli altri casi, forzando l'interruzione di un processo in esecuzione. Questi scheduler hanno un overhead maggiore (intervengono spesso) ma possono fornire un servizio migliore e sono usati da tutti i SO moderni. Possono però causare *race condition* se i dati sono condivisi e un processo viene prelazionato lasciando i dati in uno stato inconsistente.
]

#index[Dispatcher]
#definition(
  "Dispatcher",
)[
  Il *dispatcher* è un modulo del SO che consegna il controllo della CPU al processo scelto dallo scheduler. Le sue funzioni includono il *context switching*, il passaggio alla modalità utente e il salto all'istruzione corretta per riprendere l'esecuzione.
]

La *latenza di dispatch* è il tempo necessario al dispatcher per fermare un processo e avviarne un altro, ed è fondamentale minimizzarla.

#figure(image("images/2025-08-06-22-49-40.png", height: 30%))

== Criteri di scheduling

Algoritmi di scheduling della CPU diversi hanno
proprietà diverse e la scelta di un particolare algoritmo
può favorire una classe di processi rispetto a un'altra

Alcune delle caratteristiche sono:
- Utilizzo della CPU
- Frequenza di completamento (throughput)
- Tempo di completamento (turnaround time): il tempo trascorso dall'ingresso di un processo nel sistema fino al completamento della sua esecuzione.
- Tempo di attesa: somma degli intervalli di tempo ch eun processo passa in attesa nella coda dei pronti.
- Tempo di risposta: tempor trascorso dall'invio al sistam di una richiesta da parte di un processo fino all'inizio della risposta.

#image("images/2025-08-07-16-46-28.png")

Gli algoritmi di scheduling operano in baso a vari criteri:

- Massimizzare l'utilizzo della CPU (di solito, l'utilizzo varia fra il 40% ed il 90%)
- Massimizzare la frequenza di completamento
- Minimizzare il tempo di completamento
- Minimizzare il tempo di attesa
- Minimizzare il tempo di risposta
- Minimizzare la varianza del tempo di risposta
- Ottimizzare il valore medio di una data caratteristica

Non esiste un algoritmo ottimo per tutti i criteri; spesso sono in conflitto tra loro. La scelta dipende dagli obiettivi specifici del sistema.

== Algoritmi di scheduling

Gli algoritmi possono essere classificati in base a tre aspetti:
- *Senza/con prelazione*: se un processo può essere forzato a rilasciare la CPU. Adatti alle elaborazioni con uso intensivo della CPU.
- *Senza/con priorità*: se i processi sono considerati equivalenti o se alcuni hanno maggiore urgenza. Si basano su strategie di ordinamento come First Come First Served e sono necessari nei sistemi interattivi.
- *(Se con priorità) statiche/dinamiche*: se i diritti di accesso alla CPU di un processo rimangono costanti o vengono modificati nel tempo. Penalizzano i processi a bassa priorità ma bilanciano CPU-bound e I/O-bound.

#index("Algoritmo scheduling", "FCFS")
=== Scheduling First-Come, First-Served (FCFS)
I processi ottengono la CPU nell'ordine in cui diventano pronti. È un algoritmo *senza prelazione e senza priorità*.

#image("images/2025-08-07-16-52-17.png")
#image("images/2025-08-07-16-52-27.png")


L'algoritmo soffre dell'*effetto convoglio*, dove processi brevi possono essere bloccati da processi lunghi, riducendo l'utilizzo delle risorse.

=== Scheduling Shortest-Job-First (SJF) & Shortest-Remaining-Time-First (SRTF)

#index("Algoritmo scheduling", "SJF")
- *SJF* (senza prelazione) assegna la CPU al processo con il burst di CPU più breve. Un processo, una volta ottenuta la CPU, non può essere interrotto. È l'algoritmo che fornisce il *minimo tempo di attesa medio* per un dato insieme di processi.

#index("Algoritmo scheduling", "SRTF")
- *SRTF* (con prelazione) è la versione preemptive di SJF. Se un nuovo processo con un burst di CPU più breve del tempo rimanente del processo in esecuzione diventa pronto, ottiene la CPU.

SJF/SRTF possono causare *inedia (starvation)* per processi con CPU burst lunghi.

#image("images/2025-08-07-17-01-21.png")

#image("images/2025-08-07-17-01-33.png")

#index("Media esponenziale")
Il problema di SJF/SRTF è che richiedono la conoscenza della lunghezza del prossimo CPU burst, che può solo essere stimata. Si usa la *media esponenziale* dei burst precedenti:

$ tau_(n+1) = alpha t_n + (1- alpha) tau_n $

Dove:
- $tau_(n+1)$ è il valore stimato per il successivo CPU burst
- $tau_n$ è la stima precedente
- $t_n$ è il valore misurato dell'n-esimo CPU burst
- $alpha$ è un numero reale compreso tra 0 ed 1 che regola il peso delle informazioni.

Se $alpha=0$:
$tau_(n+1)=tau_n$ ovvero le informazioni recenti (quindi $t_n$) non contano.
Se $alpha=1$:
$tau_(n+1)=t_n$ ovvero conta solo l'ultimo burst effettivo.

NORMALMENTE SI USA $alpha=0.5$ NELLA MEDIA.

#image("images/2025-08-07-17-12-31.png")

=== Scheduling Circolare (Round Robin, RR)

#index("Algoritmo scheduling", "RR")
A turno, ogni processo ottiene la CPU per un *quanto di tempo (time slice)*, tipicamente tra 10 e 100 millisecondi. Simile a FCFS ma con prelazione, è progettato per sistemi time-sharing.

#image("images/2025-08-07-17-13-57.png")

Il diagramma di Gantt mostra l'alternarsi dei processi in blocchi da 20ms (o meno se il burst è più corto) fino al completamento. Ad esempio, P1 esegue per 20ms, poi P2 per 17ms, P3 per 20ms, P4 per 20ms, poi P1 riprende per 20ms, e così via.


Il tempo di completamento è tipicamente più alto rispetto a SJF, ma il tempo di risposta è migliore (tempo di attesa = tempo completamento - tempo di burst). Le prestazioni dipendono dalla lunghezza del quanto di tempo:
- un `q` grande si avvicina a FCFS
- un `q` piccolo aumenta il parallelismo virtuale ma anche l'overhead di context switch.

#image("images/2025-08-07-17-15-57.png")

Anche il tempo di completamento dipende dalla lunghezza del quanto di tempo.

#image("images/2025-08-07-17-17-12.png")

=== Scheduling a Priorità

#index("Algoritmo scheduling", "Priorità")
Assegna la CPU al processo con la priorità più alta. Le priorità possono essere interne (misurate dal sistema, es. uso CPU, I/O) o esterne (es. importanza utente). Anche qui esistono schemi con e senza prelazione. Ad esempio SJF è uno scheduling a priorità e senza prelazione in cui la priorità è data dalla lunghezza del successivo tempo di burst di CPU.

#image("images/2025-08-07-17-20-48.png")

Il problema principale è l'*inedia (starvation)*, dove processi a bassa priorità potrebbero non essere mai eseguiti. La soluzione è l'*invecchiamento (aging)*, che aumenta gradualmente la priorità di un processo in attesa.

=== Scheduling a Code Multilivello

#index("Algoritmo scheduling", "Code multilivello")
Consiste nel suddividere la coda dei pronti in code separate, tipicamente per tipi di processi (es. foreground/I/O-bound e background/CPU-bound), ciascuna con il proprio algoritmo di scheduling (es. RR per foreground, FCFS per background). La gestione dello scheduling tra le code può essere a priorità fissa (con rischio di starvation) o tramite partizione di tempo (es. 80% del tempo a foreground, 20% a background).

#image("images/2025-08-07-17-23-37.png")

Si può sviluppare ulteriormente suddividendo i processo su più code separate per ciascuna priorità distinta.

#image("images/2025-08-07-17-25-13.png")

Rimane il problema di dover gestire lo scheduling fra le code:
- Scheduling con priorità fissa: prima tutti i processi nella coda con priorità più elevata (porta a starvation)
- Partizione di tempo: tipo %80 del tempo al foreground e 20% di tempo al background.

=== Scheduling a Code Multilivello con Retroazione (Feedback)
Consente ai processi di spostarsi tra le code, implementando l'invecchiamento. È il criterio di scheduling più generale ma anche il più complesso.
Esso dipende da diversi parametri:
- numero di code
- algoritmo di scheduling per ogni coda
- metodo usato per determinare quando spostare un processo in una coda a priorità maggiore
- metodo usato per determinare quando spostare un processo in una coda a priorità minore
- metodo usato per determinare in quale coda deve essere posto un processo nel momento in cui richiede un servizio

Ad esempio, un processo interrotto per scadenza del quanto può essere spostato in una coda a priorità minore, mentre un processo che si blocca prima della scadenza può essere spostato in una coda a priorità maggiore quando diventa di nuovo pronto. Questo favorisce i processi I/O-bound. Per mitigare la starvation dei processi CPU-bound, si può aumentare il loro quanto di tempo nelle code a priorità più bassa.

#example(
  "Un sistema con tre code RR (Q0 con 8ms, Q1 con 16ms, Q2 senza quanto",
)[
  #image("images/2025-08-07-17-30-27.png")
  - Lo scheduling interno sposta un processo da Q0 a Q1 se non termina in 8ms, e da Q1 a Q2 se non termina in 16ms.
  - Lo scheduling tra le code esegue prima Q0, poi Q1, poi Q2. Un nuovo processo va in Q0 e può prelazionare processi in Q1 o Q2. L'aging sposta processi che attendono troppo a lungo a priorità più alta.
]

== Scheduling dei Thread

#index[LWP-LightWeight Process]
Nella maggior parte dei SO moderni, sono i *thread a livello kernel*, e non i processi, a essere schedulati dal sistema operativo. I thread a livello utente sono gestiti da librerie di thread e necessitano di essere associati a un thread a livello kernel, spesso tramite una struttura dati intermedia chiamata *LightWeight Process (LWP)*.

Un LightWeight Process è una sorta di processore virtuale che permette la comunicazione tra il kernel e la libreria di thread a livello utente.

Il kernel fornisce a ogni applicazione uno o più LWP, ciascuno associato a un thread del kernel. Il SO esegue lo scheduling dei thread del kernel sui processori. L'applicazione esegue lo scheduling dei thread utente sui LWP disponibili. Se un thread del kernel si blocca, il LWP associato si blocca, così come il thread a livello utente associato. Tramite una procedura nota come upcall, il kernel informa l'applicazione del verificarsi di determinati eventi. Le upcall sono gestite dalla libreria di thread a livello utente mediante un apposito gestore eseguito su uno dei LWP assegnati all'applicazione.

#example(
  "Relazione thread utente, kernel e LWP",
)[
  #image("images/2025-08-07-17-46-45.png")
  L'immagine illustra la relazione tra thread utente, LWP e thread kernel. Il kernel schedula i thread kernel sui processori fisici, mentre l'applicazione schedula i thread utente sui LWP disponibili. Eventi importanti vengono comunicati dal kernel all'applicazione tramite *upcall*.
]

#index[SCS-System Contemption Scope]
Esistono due ambiti di contesa per lo scheduling dei thread:
- *Ambito della contesa allargato al sistema (System-Contention Scope, SCS)*: la competizione avviene tra tutti i thread nel sistema. È l'unica forma di scheduling dei thread in sistemi come Windows e Linux, che implementano un modello uno-a-uno. In questo caso il kernel sceglie, con una delle politiche precedenti, il thread a livello kernel, e quindi il LWP, a cui assengnare la CPU.
#index[PCS-Process Contention Scope]
- *Ambito della contesa ristretto al processo (Process-Contention Scope, PCS)*: la libreria di thread schedula i thread a livello utente per l'esecuzione su un LWP disponibile, e la competizione avviene tra thread dello stesso processo. Questo schema è usato nei modelli molti-a-uno e molti-a-molti. Lo scheduling PCS è generalmente a priorità e con prelazione, con priorità decise dal programmatore.

== Scheduling per Sistemi Multiprocessore

La presenza di più processori rende lo scheduling più complesso, ma permette il *bilanciamento del carico (load balancing)*. Il termine multiprocessore si applica a diverse architetture attuali, inclusi processori multicore, core multithread, sistemi NUMA (Accesso Non Uniforme alla Memoria) e sistemi multiprocessore eterogenei. Questi ultimi differiscono dagli altri perché qui ogni processore ha funzionalità diverse dagli altri processori.

#index("Multielaborazione", "Asimmetrica")
Gli approcci principali allo scheduling multiprocessore sono:
- *Multielaborazione asimmetrica*: un processore (master server) gestisce tutte le decisioni di scheduling e I/O, mentre gli altri processori eseguono solo programmi utente. Semplifica lo scheduling ma il master server può diventare un collo di bottiglia.

#index("Multielaborazione", "Simmetrica")
- *Multielaborazione simmetrica (SMP)*: ogni processore ha il proprio scheduler che esamina la coda dei pronti e sceglie il thread da eseguire. Questo è l'approccio standard nei SO moderni. Le strategie per organizzare i thread pronti includono una coda ready comune (che richiede sincronizzazione e può creare problemi di performance) o code ready private per ogni processore (che possono richiedere algoritmi di bilanciamento del carico ed è l'approccio più utilizzato).

#image("images/2025-08-08-17-16-31.png")

=== Processori Multicore e Core Multithread
#index[Multicore]
#definition(
  "Processori multicore",
)[I *processori multicore* contengono più core di elaborazione su un singolo chip. Ogni core mantiene il proprio stato architetturale e appare al SO come un processore separato.]

#index[Core multithread]
Per affrontare lo *stallo della memoria* (il tempo che un core trascorre in attesa dei dati dalla memoria), l'hardware recente implementa *core multithread*.

#image("images/2025-08-08-17-19-21.png")

Due o più thread hardware (HW) sono assegnati a ogni core, permettendo al core di eseguire un altro thread HW se uno si blocca.

#image("images/2025-08-08-17-19-30.png")

Dal punto di vista del SO, ogni thread HW è una *CPU logica* (nota come *Chip MultiThreading - CMT* o *hyperthreading* di Intel).

#image("images/2025-08-08-17-20-34.png")

*Un core multithread richiede due livelli di scheduling*: il livello 1 (thread SW) è responsabilità del SO, mentre il livello 2 (thread HW) è gestito dal core stesso (spesso con Round Robin o priorità). Le risorse del core sono condivise tra i suoi thread HW, quindi può eseguire solo un thread HW alla volta. Il SO può migliorare le prestazioni schedulando i thread SW su thread HW che non condividono risorse.

#image("images/2025-08-08-17-20-45.png")

Il *bilanciamento del carico* è cruciale nei sistemi multiprocessore per un uso efficiente. Nei sistemi con una coda ready comune, il bilanciamento del carico non è necessario, poiché quando un processore diventa inattivo, estrae immediatamente un thread eseguibile dalla coda pronta condivisa. Nei sistemi con code ready private, esistono due strategie:
- *Migrazione push*: un processore monitora i carichi e sposta i thread dai processori sovraccarichi.
- *Migrazione pull*: un processore inattivo "tira" un processo da un processore sovraccarico.
Queste strategie spesso convivono nello stesso sistema.

#index[Processor Affinity]
La *predilezione per il processore (processor affinity)* si riferisce al fatto che un thread tende a rimanere sul processore su cui è in esecuzione, a causa del costo di invalidare e ripopolare la cache su un altro processore. Può essere *debole (soft affinity)*, dove il SO cerca di mantenere il thread sullo stesso processore ma il load balancer può spostarlo, o *forte (hard affinity)*, dove il SO permette di specificare un sottoinsieme di processori utilizzabili. L'affinity può essere influenzata dalle architetture di memoria, come nei sistemi *NUMA (Non Uniform Memory Access)*, dove l'accesso di una CPU alla propria memoria locale è più veloce. L'immagine mostra un'architettura NUMA con due chip e memoria locale.

#image("images/2025-08-08-17-22-28.png")

#index[Multiprocessore eterogenei]
I *sistemi multiprocessore eterogenei (HMP)*, come l'architettura ARM big.LITTLE o i processori Intel ibridi (P-core e E-core), combinano core con diverse velocità e gestioni energetiche. L'obiettivo è gestire il consumo energetico, allocando task a lungo termine o a basso consumo sui core LITTLE/E-core, e task interattivi sui core big/P-core. Windows 10 supporta lo scheduling HMP permettendo ai thread di selezionare la politica di scheduling per le proprie esigenze energetiche.

== Valutazione degli Algoritmi di Scheduling

Per scegliere un algoritmo, è necessario fissare i criteri di valutazione e utilizzare un metodo.
I metodi di valutazione includono:

=== Modelli Deterministici
Analizzano le prestazioni di un algoritmo per un *carico di lavoro predeterminato*. Sono semplici e rapidi, utili a fini didattici, ma richiedono la conoscenza a priori del carico di lavoro, che non è sempre disponibile o costante.

#example("Esempio I")[
  #image("images/2025-08-08-17-28-23.png")
  #image("images/2025-08-08-17-29-04.png")
]

#example("Esempio II")[
  #image("images/2025-08-08-17-29-15.png")
]

#example("Esempio III")[
  #image("images/2025-08-08-17-29-26.png")
]

=== Modelli con Reti di Code
Modella il sistema come una rete di server con code (CPU con coda dei pronti, dispositivi con code di attesa). Utilizza distribuzioni di probabilità delle durate dei burst e degli arrivi per calcolare metriche come l'utilizzo dei server e il tempo di attesa. Lo svantaggio è la complessità dell'analisi e la necessità di semplificazioni.

=== Simulazioni
Si programma un modello del sistema con strutture dati che rappresentano le componenti e una variabile per il clock. I dati per la simulazione possono essere generati casualmente o basati su misurazioni empiriche (trace tape). Offre risultati precisi ma è computazionalmente oneroso e richiede sviluppo complesso.

=== Implementazione
Il modo più certo per valutare un algoritmo è programmarlo, inserirlo nel SO e osservarne il comportamento in uso reale. È però costoso in termini di codifica e modifiche al SO, e può causare disagi agli utenti.
