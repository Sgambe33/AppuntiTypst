#import "@preview/dvdtyp:1.0.1": *

= Concetti introduttivi
== Concetti Introduttivi e Obiettivi di un Sistema Operativo (SO)
Un #strong[Sistema Operativo (SO)] è un insieme di programmi che agisce come intermediario tra gli utenti e l'hardware di un sistema di elaborazione. Non esiste una definizione universalmente accettata, ma è possibile identificarne diversi ruoli:

- #strong[Intermediario] tra utenti e hardware.
- #strong[Virtualizzatore di risorse];, che permette di utilizzare il sistema di elaborazione come se si avesse a disposizione una macchina funzionalmente estesa.
- #strong[Allocatore di risorse];, gestendo e allocando risorse fisiche e logiche (come tempo di CPU, memoria, dispositivi di I/O) e risolvendo conflitti di accesso.
- #strong[Programma di controllo];, che supervisiona l'esecuzione dei programmi utente per prevenire errori nell'uso del computer e dei dispositivi.
- Il #strong[Kernel] è l'unico programma che è sempre in funzione nel calcolatore.

#figure(
  image("images/image.png"),
  caption: [
    image.png
  ],
)

Gli #strong[obiettivi principali] di un SO sono:

+ Fornire metodi #strong[convenienti] per utilizzare il sistema di elaborazione, creando un ambiente che faciliti l'esecuzione dei programmi utente e la soluzione di problemi computazionali. Questo include rendere il software applicativo indipendente dall'hardware (trasparenza) e facilitare la portabilità dei programmi.

+ Assicurare un #strong[uso efficiente] delle risorse del sistema di elaborazione, monitorando l'utilizzo delle risorse, evitando conflitti di accesso e massimizzando l'uso delle risorse. Il SO stesso consuma risorse (overhead).

+ #strong[Prevenire interferenze] nelle attività degli utenti, allocando risorse ad uso esclusivo e impedendo accessi illegali tramite meccanismi di autenticazione e autorizzazione.

== Organizzazione di un Sistema di Elaborazione 

#figure(
  image("images/image 1.png"),
  caption: [
    image.png
  ],
)

Un moderno calcolatore general-purpose è composto da una o più #strong[CPU] e da diversi #strong[controllori di dispositivi];, tutti connessi tramite un #strong[bus] che consente l'accesso alla memoria condivisa. CPU e controllori possono operare in parallelo.

=== CPU (Central Processing Unit) 
Contiene #strong[registri interni] (programmabili, di stato e controllo). Esegue le istruzioni dei programmi attraverso il #strong[ciclo prelievo-decodifica-esecuzione] (Fetch, Decode & Execute).

I sistemi moderni utilizzano #strong[architetture multiprocessore] (più processori che condividono memoria e clock) o #strong[multicore] (processori con più nuclei di elaborazione sullo stesso chip), che permettono una #strong[concorrenza reale] (più programmi in esecuzione simultanea) e offrono vantaggi come elevata capacità di elaborazione, basso costo e maggiore affidabilità.

#figure(
  image("images/image 2.png"),
  caption: [
    #strong[Architettura multiprocessore con 2 CPU]
  ],
)

#strong[Architettura multiprocessore con 2 CPU]

#figure(
  image("images/image 3.png"),
  caption: [
    #strong[Architettura dual-core con due core sullo stesso chip]
  ],
)

#strong[Architettura dual-core con due core sullo stesso chip]

=== Controllori dei dispositivi 

Ciascun controllore è responsabile di un tipo specifico di dispositivo e ha un #strong[buffer locale] e registri per comunicare con la CPU. L'I/O avviene tra il dispositivo e il buffer locale del controllore. Quando un'operazione è completata, il controllore informa la CPU tramite un #strong[segnale di interruzione];.

=== Meccanismo delle interruzioni
Una combinazione di comportamenti hardware e software che interrompe l'esecuzione del processo corrente, assegna la CPU a una #strong[funzione di gestione dell'interruzione] e poi riprende il processo sospeso.

#figure(
  image("images/image 4.png"),
  caption: [
    #strong[Diagramma temporale delle interruzioni: singolo processo che invia dati in output]
  ],
)

#strong[Diagramma temporale delle interruzioni: singolo processo che invia dati in output]

Le interruzioni possono essere causate da eventi esterni (es. completamento I/O), fallimenti hardware, trap (es. divisione per 0) o interruzioni software (system call).

La gestione delle interruzioni è guidata da un #strong[vettore delle interruzioni] (una tabella con gli indirizzi delle funzioni di gestione) e da un #strong[bit di abilitazione] nel registro PS (Program Status Word). Se posto a 1, dopo il ciclo FDE, la CPU controlla se ci sono interruzioni in attesa.

Le interruzioni possono avere #strong[priorità];, con quelle a priorità più alta che possono sospendere la gestione di quelle a priorità più bassa (necessitando un #strong[kernel prelazionabile];). Alcune interruzioni sono #strong[mascherabili] (disattivabili) e altre no.

#strong[Kernel non prelazionabile];: Disabilita la gestione delle interruzioni durante l'esecuzione dell'handler, semplificando il design ma potendo ritardare interruzioni ad alta priorità.

#figure(
  image("images/image 5.png"),
  caption: [
    image.png
  ],
)

#strong[Kernel prelazionabile];: Permette la gestione di interruzioni più critiche anche mentre un'interruzione è già in corso, tipicamente con uno schema a priorità. Richiede schemi di sincronizzazione per evitare problemi di consistenza dei dati.

#figure(
  image("images/image 6.png"),
  caption: [
    image.png
  ],
)

=== #strong[I/O sincrono e asincrono];: <io-sincrono-e-asincrono>
#strong[I/O sincrono];: Il controllo ritorna al processo utente solo al completamento dell'I/O. La CPU resta inattiva (istruzione `wait`). In un dato istante, al massimo una richiesta di I/O è in sospeso.

#figure(
  image("images/image 7.png"),
  caption: [
    image.png
  ],
)

#strong[I/O asincrono];: Il controllo ritorna al processo utente immediatamente, senza attendere il completamento. Se necessario, si usa una system call bloccante per permettere al processo utente di attendere il completamento dell'I/O. Per tenere traccia delle richieste I/O si usa una #strong[tabella di stato dei dispositivi];.

#figure(
  image("images/image 8.png"),
  caption: [
    image.png
  ],
)

#figure(
  image("images/image 9.png"),
  caption: [
    image.png
  ],
)

=== #strong[Accesso diretto alla memoria (DMA)];: 
#definition[
  Un canale DMA è un circuito che collega un dispositivo di I/O al bus di sistema, permettendo l'accesso diretto alla memoria senza intervento della CPU.
]


Contiene registri per l'indirizzo di memoria e la quantità di dati da trasferire. È usato per dispositivi I/O ad alta velocità, trasferendo interi blocchi di dati e generando una sola interruzione per blocco, riducendo l'overhead.

#figure(
  image(
    "images/image 10.png",
  ),
  caption: [
    Diagramma DMA
  ],
)

Diagramma DMA

=== #strong[Struttura della memoria];: <struttura-della-memoria>
La memoria è un vettore di parole con indirizzi propri. Per ovviare ai costi, si usa una #strong[gerarchia di memorie] (cache, RAM, memoria secondaria, memoria non volatile) con diverse velocità e capacità. La CPU accede direttamente solo alla memoria più veloce.

#figure(
  image(
    "images/image 11.png",
  ),
  caption: [
    image.png
  ],
)

#figure(
  image(
    "images/image 12.png",
  ),
  caption: [
    image.png
  ],
)

La gestione della memoria centrale e trasferiemento dei blocchi tra disco e memoria centrale sono gestiti dal SW (SO). La gestione della cache e trasferimento dei blocchi tra memoria centrale e cache sono gestiti da HW. Le memorie cache (L1, L2, L3) sono usate per ridurre il tempo di accesso effettivo, con L1 ed eventualmente L2 montate sul chip della CPU.

#figure(
  image(
    "images/image 13.png",
  ),
  caption: [
    image.png
  ],
)

I computer moderni differiscono per le gerarchie di memorie cache e per la disposizione della #strong[MMU] (Memory Management Unit) che traduce indirizzi logici in fisici.

#figure(
  image(
    "images/image 14.png",
  ),
  caption: [
    image.png
  ],
)

Fa eccezione la cache L1 alla quale viene inviato direttamente un indirizzo logico invece che fisico per velocizzare la ricerca in L1 (si evita traduzione). Inoltre permette di avviare, in parallelo, una traduzione in indirizzo fisico qualora si verifichi una MISS.

Le unità di misura per la memoria (KB, MB, GB) sono basate su potenze di 2 (es. 1KB = 1024 byte), mentre le velocità di comunicazione (Kbps, Mbps) sono basate su potenze di 10 (es. 1Kbps = 1.000 bit/s).

#figure(
  image(
    "images/image 15.png",
  ),
  caption: [
    image.png
  ],
)

#figure(
  image(
    "images/image 16.png",
  ),
  caption: [
    image.png
  ],
)

=== #strong[Meccanismi di Protezione];: <meccanismi-di-protezione>
Necessari per garantire che un programma malfunzionante non influenzi altri programmi, per proteggere il SO e per salvaguardare i dati degli utenti da accessi errati o dolosi. Si basano su meccanismi hardware e software. I seguenti sono meccanismi hardware.

- #strong[Duplice modalità di funzionamento del processore]

  - #strong[Modalità utente];: Per l'esecuzione normale dei programmi, con limitazioni di accesso alle risorse e istruzioni privilegiate non eseguibili.
  - #strong[Modalità monitor (o kernel/supervisore/sistema)];: Per l'esecuzione dei servizi del SO, senza limiti alle operazioni attraverso system call.


  Attenzione, per garantire una gestione delle risorse corretta da parte del SO è necessario garantire che un processo utente non possa mai ottenere il controllo del calcolatore quando esso si trova in modalità monitor.

  Un #strong[bit di modalità] nel registro PS indica la modalità corrente. Il sistema passa alla modalità monitor durante le interruzioni e torna alla modalità utente prima di restituire il controllo a un processo utente.

  #figure(
    image(
      "images/image 17.png",
    ),
    caption: [
      image.png
    ],
  )

  Le system call generano una interruzione (che modifica la modalità di funzionamento della CPU e invoca la funzione corrispondente)

  #figure(
    image(
      "images/image 18.png",
    ),
    caption: [
      image.png
    ],
  )

- #strong[Protezione dell' I/O]

  Le istruzioni di I/O sono privilegiate; i programmi utente devono invocare una #strong[system call] affinché il SO le esegua per loro conto in modalità kernel.

  #figure(
    image(
      "images/image 19.png",
    ),
    caption: [
      image.png
    ],
  )

- #strong[Protezione della memoria]

  Impedisce accessi non autorizzati alla memoria.

  💡

  Si pensi, ad esempio, ad un programma utente che memorizza un nuovo indirizzo nel vettore delle interruzioni: al momento in cui una interruzione si verifica, potrebbe far richiamare se stesso ottenendo così il controllo del sistema in modalità monitor

  Si usano:

  - #strong[registri base:] contiene il più piccolo indirizzo della memoria fisica destinata al processo.
  - #strong[registri limite:] contiene la lunghezza dell'area di memoria riservata al processo.

  Per definire l'intervallo di indirizzi legali per un processo. Solo il SO può modificare questi registri tramite istruzioni privilegiate.

  #figure(
    image(
      "images/image 20.png",
    ),
    caption: [
      image.png
    ],
  )

  Ogni indirizzo generato dalla CPU è confrontato con il valore del registro base ed il valore ottenuto dalla soma dei due registri.

- #strong[Protezione della memoria cache]

  Alla cache L1 si accede solo con indirizzi logici (vedi MMU). Diversi processi possono usare gli stessi indirizzi logici quindi il controllo basato su indirizzi non è utilizzabile.

  - Approccio semplice: flush (cancellazione) della cache quando cambia il processo in esecuzione (context switch).
  - Approccio sosfisticato: in ogni blocco della cache si memorizza l'id del processo a cui appartengono i dati / istruzioni.

- #strong[Protezione della CPU]

  Si usa un #strong[timer] per interrompere un processo dopo un periodo prefissato, impedendo cicli infiniti. L'impostazione del timer è un'istruzione privilegiata.

== Gestione delle Risorse <gestione-delle-risorse>
I moderni SO supportano la condivisione delle risorse in due modalità: #strong[condivisione nel tempo] (risorse usate a turno, es. CPU) e #strong[condivisione nello spazio] (risorse divise, es. memoria). Utilizzano #strong[multiprogrammazione] e #strong[time-sharing];.

- #strong[Multiprogrammazione];: Il SO mantiene più processi contemporaneamente in memoria centrale per mantenere la CPU in attività. Quando un processo attende un evento (es. I/O), il SO passa a un altro (#strong[context switch];). Richiede scheduling dei processi, gestione della memoria e scheduling della CPU.

  #figure(
    image(
      "images/image 21.png",
    ),
    caption: [
      image.png
    ],
  )

  #figure(
    image(
      "images/image 22.png",
    ),
    caption: [
      image.png
    ],
  )

- #strong[Time-sharing (o Multitasking)];: Estensione logica della multiprogrammazione per minimizzare i tempi di risposta e permettere un uso interattivo. I processi si alternano nell'uso della CPU per brevi quanti di tempo (time slice), dando l'illusione all'utente di avere il sistema a disposizione.

  #figure(
    image(
      "images/image 23.png",
    ),
    caption: [
      image.png
    ],
  )

=== #strong[Funzioni principali di gestione delle risorse svolte dal SO];: <funzioni-principali-di-gestione-delle-risorse-svolte-dal-so>
- #strong[Gestione dei processi];: Un processo è un programma in esecuzione che necessita di risorse. Il SO è responsabile della creazione/eliminazione, sospensione/ripresa (scheduling sulla CPU), sincronizzazione, comunicazione e gestione dei deadlock.
- #strong[Gestione della CPU];: Lo scheduler decide quale processo assegnare alla CPU, e le politiche di scheduling influenzano l'efficienza e la qualità del servizio.
- #strong[Gestione della memoria principale];: La memoria è un vettore di parole/byte. Il SO tiene traccia dell'uso della memoria, decide quali processi caricare, alloca/dealloca spazio e protegge gli accessi.
- #strong[Gestione dei file];: Un file è un insieme di informazioni correlate. Il SO gestisce creazione/cancellazione di file e directory, supporta primitive di manipolazione, associa file ai dispositivi di memoria secondaria, esegue backup e controlla gli accessi.
- #strong[Gestione della memoria secondaria];: Dischi (magnetici o a stato solido) fungono da backup della memoria principale. Il SO gestisce partizionamento, montaggio/smontaggio, spazio libero, allocazione, scheduling delle richieste e protezione.
- #strong[Gestione dei dispositivi di I/O];: Effettuata dal sistema di I/O (interfaccia generale per driver e driver specifici). Il SO maschera la diversità dei dispositivi, gestisce la competizione e l'I/O (buffering, caching, spooling).

== Virtualizzazione delle Risorse <virtualizzazione-delle-risorse>
La #strong[virtualizzazione] si basa sul concetto di #strong[risorsa virtuale];, una risorsa fittizia che è un'astrazione di una risorsa reale, gestita dal SO in modo trasparente. Una singola risorsa reale può supportare molteplici risorse virtuali.

- #strong[Vantaggi];: Le risorse virtuali sono più semplici da usare o appaiono in numero maggiore rispetto alle reali, e la loro molteplicità rimuove i vincoli di uso esclusivo, favorendo l'esecuzione concorrente di più applicazioni.
- #strong[Esempio: server di stampa];: La stampante reale è la risorsa, il server di stampa è la risorsa virtuale. Quando un programma stampa, il file viene copiato in una "coda di stampa", e il programma può continuare. Il server stampa i file in coda quando la stampante è disponibile, semplificando l'accesso e rimuovendo apparentemente il vincolo di uso esclusivo.

La virtualizzazione può essere applicata a vari livelli e tipi di risorse:

- #strong[CPU];: Multiprogrammazione per la condivisione.
- #strong[Memoria];: Memoria virtuale per superare i limiti fisici.
- #strong[I/O];: Accesso semplificato e rimozione del vincolo di uso esclusivo.
- #strong[Computer];: #strong[Macchine virtuali] che evitano interferenze tra utenti, consentono SO diversi simultaneamente o l'esecuzione di un SO all'interno di un altro.

== Sicurezza e Protezione <sicurezza-e-protezione>
La #strong[sicurezza] si occupa di preservare le risorse del computer da accessi non autorizzati, modifiche dannose e incoerenze. Si basa sull'#strong[autenticazione] (verifica dell'identità di utenti/applicazioni).

La #strong[protezione] è l'insieme dei meccanismi che controllano l'accesso di processi e utenti alle risorse. Si basa sull'#strong[autorizzazione] (verifica di cosa gli utenti autenticati possono fare).

#figure(
  image(
    "images/image 24.png",
  ),
  caption: [
    image.png
  ],
)

Il SO è responsabile dell'#strong[autenticazione degli utenti] (tramite user ID e group ID) e dell'#strong[autorizzazione] all'uso delle risorse.

== Servizi di un SO <servizi-di-un-so>
L'accesso ai servizi del SO avviene tramite interfacce utente e #strong[chiamate di sistema (system call)];.

#figure(
  image(
    "images/image 25.png",
  ),
  caption: [
    image.png
  ],
)

Alcune classi di servizi comuni includono:

- #strong[Servizi per l'utente];: Esecuzione di programmi, operazioni di I/O, gestione del file system, comunicazione, rilevamento di errori.
- #strong[Servizi per l'efficienza del sistema];: Allocazione delle risorse, logging (tracciare l'uso delle risorse), protezione e sicurezza.

== Interfacce Utente <interfacce-utente>
I livelli di un sistema di elaborazione (hardware, SO, software applicativo) si collegano tramite interfacce che offrono funzionalità sempre più astratte.

#figure(
  image(
    "images/image 26.png",
  ),
  caption: [
    image.png
  ],
)

- Gli #strong[utenti finali] usano il sistema tramite il software applicativo o il software di sistema (interpreti, compilatori).
- I #strong[programmatori di applicazioni] si interfacciano tramite system call e API.
- I #strong[programmatori di sistema] usano funzionalità del SO e direttamente dell'hardware.
- I #strong[progettisti del SO] si interfacciano direttamente con l'hardware.
- L'#strong[Interprete di comandi] (o shell) è il software di sistema più importante, leggendo e interpretando i comandi del SO. Può essere a #strong[riga di comando (CLI)];, #strong[grafica (GUI)] o #strong[touch-screen];. Ad esempo #strong[Shell Bash è un interprete di comandi utilizzato in Linux.]

== System Call e API <system-call-e-api>
Le #strong[System Call] sono richieste che un programma rivolge al kernel del SO tramite #strong[interruzioni software];, e costituiscono l'interfaccia tra il programma in esecuzione e i servizi del SO.

#strong[Tipi di System Call];:

- Controllo dei processi (creazione, terminazione, scheduling)
- gestione dei file (creazione, lettura, scrittura)
- gestione dei dispositivi
- gestione delle informazioni di sistema (data/ora, info HW/SW
- comunicazioni
- protezione (permessi).

#strong[Implementazione delle System Call];: Ogni system call ha un numero intero associato, che è l'indice in una tabella contenente le informazioni per l'implementazione. L'invocante non ha bisogno di conoscere i dettagli dell'implementazione.

#figure(
  image(
    "images/image 27.png",
  ),
  caption: [
    (Diagramma che mostra un'applicazione utente che chiama la funzione `open()` della libreria, che a sua volta invoca una system call `open()` nel kernel, il kernel esegue l'operazione e restituisce il risultato alla libreria, che lo restituisce all'applicazione)
  ],
)

(Diagramma che mostra un'applicazione utente che chiama la funzione `open()` della libreria, che a sua volta invoca una system call `open()` nel kernel, il kernel esegue l'operazione e restituisce il risultato alla libreria, che lo restituisce all'applicazione)

Le system call sono spesso scritte in linguaggio assembler, ma più comunemente accedute tramite #strong[Application Programming Interface (API)];, un'interfaccia di più alto livello.

- Esempi comuni di API sono #strong[POSIX API] (per UNIX, Linux, Mac OS X), #strong[Win32 API] (per Windows) e #strong[Java API] (per JVM).

- La #strong[libreria C standard (glibc)] fornisce parte dell'interfaccia per le system call in UNIX e Linux.

  #figure(
    image(
      "images/image 28.png",
    ),
    caption: [
      (Diagramma che mostra il flusso di controllo da un programma C che chiama `printf()`, che passa alla libreria C standard, che invoca la system call `write()` nel kernel, e il risultato viene restituito all'indietro)
    ],
  )

  (Diagramma che mostra il flusso di controllo da un programma C che chiama `printf()`, che passa alla libreria C standard, che invoca la system call `write()` nel kernel, e il risultato viene restituito all'indietro)

- Lo #strong[standard POSIX] (IEEE 1003) specifica un insieme di procedure che un sistema compatibile deve fornire, garantendo la #strong[portabilità delle applicazioni];. Include chiamate per gestione processi (`fork`, `execve`), gestione file (`open`, `read`, `write`), gestione del file system (`mkdir`, `mount`), e varie (`kill`, `time`).

  #figure(
    image(
      "images/image 29.png",
    ),
    caption: [
      image.png
    ],
  )

  #figure(
    image(
      "images/image 30.png",
    ),
    caption: [
      image.png
    ],
  )

  #figure(
    image(
      "images/image 31.png",
    ),
    caption: [
      image.png
    ],
  )

- La #strong[Win32 API] è la libreria di Windows per accedere alle system call.

  #figure(
    image(
      "images/image 32.png",
    ),
    caption: [
      image.png
    ],
  )

#strong[Vantaggi delle API];: #strong[Portabilità] delle applicazioni (un programma che usa una certa API girerà su qualsiasi sistema che la supporti) e #strong[facilità d'uso] (sono di più alto livello rispetto alle system call dirette).

Le applicazioni dipendono dal SO perché ogni SO fornisce un insieme univoco di chiamate di sistema. Per la compatibilità tra SO, le applicazioni possono essere scritte in linguaggi interpretati, usare macchine virtuali o API standard.

== Servizi di Sistema (Programmi di Sistema o Utilità) <servizi-di-sistema-programmi-di-sistema-o-utilità>
I #strong[servizi di sistema] sono programmi associati al SO ma non fanno necessariamente parte del kernel. Forniscono un ambiente per lo sviluppo e l'esecuzione dei programmi utente e si trovano a un livello più astratto rispetto alle system call e alle API.

- #strong[Categorie];: Gestione file e directory, informazioni sullo stato del sistema, editor, supporto per linguaggi di programmazione (compilatori, interpreti, debugger), caricamento ed esecuzione di programmi (loader, linker), supporto alle comunicazioni.
- Alcuni programmi di sistema, detti #strong[daemon] o #strong[server] (es. server di stampa), vengono lanciati all'avvio del sistema e restano in esecuzione.

== Progetto e Implementazione di un SO <progetto-e-implementazione-di-un-so>
Gli scopi del progetto di un SO possono essere visti da un punto di vista #strong[utente] (conveniente, facile, affidabile, sicuro, veloce) e da un punto di vista del #strong[sistema di elaborazione] (facile da progettare/manutenere, affidabile, corretto, efficiente, flessibile, portabile, espandibile).

- #strong[Flessibilità: Politiche & Meccanismi];: Un principio di progettazione chiave è separare le #strong[politiche] (cosa fare) dai #strong[meccanismi] (come farlo). Questo permette la massima flessibilità per modificare le politiche o aggiungere nuove componenti hardware/software.
- #strong[Portabilità ed espandibilità];:
  - La #strong[portabilità] è la facilità con cui il software può essere adattato per l'utilizzo su un altro computer, facilitata da codice dipendente dall'hardware ridotto e separato.
  - L'#strong[espandibilità] è la facilità con cui nuove funzionalità possono essere aggiunte, ad esempio per incorporare nuovo hardware o rispondere a nuove aspettative degli utenti. I SO moderni utilizzano funzionalità #strong[plug-and-play] per aggiungere hardware anche durante l'esecuzione.
- #strong[Implementazione];: I SO moderni sono scritti in gran parte in linguaggi di alto livello (es. C) con piccole porzioni in assembler. I linguaggi di alto livello offrono vantaggi come scrittura più rapida, codice più compatto, maggiore comprensione e manutenibilità, e facilità di porting.

== Struttura di un SO <struttura-di-un-so>
Un SO è un software complesso che deve essere strutturato. I principali modelli strutturali sono:

- #strong[Sistemi monolitici];: Tutte le funzionalità del kernel sono collocate in un unico file binario statico eseguito in un unico spazio di indirizzi. L'interazione avviene tramite chiamate a procedura. Esempi includono MS-DOS e i primi sistemi UNIX/Linux.

  #figure(
    image(
      "images/image 33.png",
    ),
    caption: [
      (Diagramma che mostra i livelli di un sistema UNIX originario: Hardware, Kernel (controllo HW, gestione memoria, gestione processi, file system), Interfaccia System Call, e sopra di essa la Shell e i Programmi Utente/Compilatori)
    ],
  )

  (Diagramma che mostra i livelli di un sistema UNIX originario: Hardware, Kernel (controllo HW, gestione memoria, gestione processi, file system), Interfaccia System Call, e sopra di essa la Shell e i Programmi Utente/Compilatori)

  Nonostante la complessità di implementazione ed estensione, i kernel monolitici offrono #strong[vantaggi in termini di prestazioni] grazie a un overhead ridotto nelle system call e a comunicazioni interne veloci. Linux, pur essendo monolitico, ha un design modulare che consente modifiche runtime.

- #strong[Sistemi modulari];: Il kernel ha componenti principali e può collegarsi a servizi aggiuntivi tramite #strong[moduli];, sia all'avvio che durante l'esecuzione (collegamento dinamico). Questo è comune in implementazioni moderne di UNIX, Linux (Loadable Kernel Modules - LKM), macOS e Windows.

- #strong[Sistemi a livelli (o strati)];: Le funzionalità del SO sono organizzate in livelli gerarchici, dove ogni livello usa solo funzionalità dei livelli sottostanti. Ogni livello definisce una nuova "macchina astratta".

  #figure(
    image(
      "images/image 34.png",
    ),
    caption: [
      (Diagramma a strati che mostra la Macchina hardware alla base, seguita da moduli di livello 1, interfaccia macchina virtuale di livello 1, e così via fino a moduli di livello N, con l'interfaccia System Call/API sopra)
    ],
  )

  (Diagramma a strati che mostra la Macchina hardware alla base, seguita da moduli di livello 1, interfaccia macchina virtuale di livello 1, e così via fino a moduli di livello N, con l'interfaccia System Call/API sopra)

  Sono complessi da progettare a causa della difficoltà nel stratificare le funzionalità e possono avere prestazioni scarse a causa dell'overhead per attraversare i livelli. Tuttavia, una certa stratificazione è ancora comune nei SO moderni.

- #strong[Sistemi a microkernel];: Estremizzano la separazione tra politiche (implementate come processi di sistema in modalità utente) e meccanismi (kernel minimale in modalità privilegiata). Il microkernel include solo meccanismi per comunicazione tra processi (IPC), gestione minima di memoria/processi/CPU e gestione hardware di basso livello.

  #figure(
    image(
      "images/image 35.png",
    ),
    caption: [
      image.png
    ],
  )

  - Tutto il resto è gestito da #strong[server] (processi di sistema che non terminano mai).
  - Le applicazioni interagiscono con i server tramite #strong[IPC];, il che comporta un overhead dovuto alla copia di messaggi e alla commutazione di contesto.
  - #strong[Microkernel: funzionamento di base];: (Diagramma che mostra un microkernel al livello più basso, con vari server (file server, terminal server, printer server, ecc.) e applicazioni utente che interagiscono con il microkernel e i server tramite messaggi IPC)
  - Nonostante l'efficienza ridotta, offrono grande #strong[flessibilità] (migliore espandibilità e portabilità) e sono più #strong[affidabili e sicuri] poiché meno codice è eseguito in modalità protetta. Sono adatti per ambienti di rete ed embedded.

- #strong[Sistemi ibridi];: Nella pratica, i SO combinano diverse strutture per ottenere un equilibrio tra prestazioni, sicurezza e flessibilità. Ad esempio, Linux è monolitico ma modulare, mentre Windows è in gran parte monolitico ma incorpora aspetti dei microkernel e moduli caricabili dinamicamente. Anche macOS X, iOS e Android sono ibridi.
