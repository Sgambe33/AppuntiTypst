#import "@preview/dvdtyp:1.0.1": *

= Gestione della Memoria Principale e Virtuale

== Analogie e Differenze con la Gestione della CPU

=== Analogie
La gestione della memoria presenta similitudini con quella della CPU. In genere, i programmi in attesa di essere eseguiti risiedono su disco come *file eseguibili*, formando la cosiddetta coda d'ingresso. Per eseguire un programma, è necessario caricarlo in memoria principale e attivare un processo che si occupi della sua esecuzione. Analogamente a quanto accade con la CPU, il processo non deve richiedere l'assegnazione della memoria principale, poiché ciò implicherebbe che sia già in esecuzione e, quindi, che il programma sia già in memoria.

=== Differenze
Tuttavia, esistono importanti differenze. A differenza della CPU, diverse regioni della memoria principale possono essere *allocate contemporaneamente a processi diversi*, un concetto noto come "condivisione nello spazio" (mentre la CPU è un esempio di "condivisione nel tempo", usata a turno). Questa permette l'opportunità di *condivisione di codice e dati* tra processi. È inoltre necessaria l'implementazione di *meccanismi di protezione* per impedire accessi non voluti a regioni di memoria del sistema operativo (SO) o di altri processi.

#definition("Risorsa virtuale")[
  Una risorsa virtuale è solitamente una struttura dati che rappresenta lo stato della risorsa fisica quando questa non è assegnata al processo cui è associata la risorsa virtuale.
]
Ad esempio una CPU virtuale è una struttura dati che contiene i valori dei registri della CPU ed è allocata in memoria principale (fa parte del PCB).

Per la *memoria virtuale* non vale la stessa cosa, infatti essa può essere allocata anche in una memoria diversa, come l'area di swap del disco.

== Hardware di Base
La gestione della memoria si basa su un hardware specifico, che include la memoria principale, i registri della CPU per istruzioni e dati, la cache e i registri della CPU per la protezione della memoria.

=== Memoria centrale
La *memoria principale* è un vasto insieme di celle, ciascuna con il proprio indirizzo, che contengono parole (dati o istruzioni). Il suo contenuto non è intrinsecamente riconoscibile; la memoria interpreta solo parole e indirizzi. La dimensione di una cella, o parola, è tipicamente un multiplo del byte (es. 8, 16, 32 bit). Lo spazio di indirizzamento massimo è dato da $2^a$, dove 'a' è la lunghezza in bit degli indirizzi.

#figure(
  image("images/2025-08-14-17-10-33.png", height: 30%),
  caption: "a è la lunghezza in bit degli indirizzi, d è l'ampiezza della cella e quindi della parola di memoria",
)

=== Registri della CPU
I *registri della CPU* e la *memoria centrale* sono le uniche aree di memorizzazione a cui la CPU può accedere direttamente. Pertanto, istruzioni e dati devono risiedere in esse per essere elaborati. I registri sono accessibili in genere entro un ciclo di clock della CPU, mentre l'accesso alla memoria principale richiede molti cicli di clock tramite il bus di memoria, causando potenziali stalli del processore dato che non dispone dei dati necessari a completare l'istruzione corrente.

=== Memoria Cache
Per ovviare a questi stalli, si interpone una *memoria cache* tra la CPU e la memoria principale. La cache è solitamente integrata nel chip della CPU per un accesso più rapido ed è gestita direttamente dall'hardware, senza intervento del SO. Se i dati non sono nella cache, lo stallo è inevitabile. Alcuni hardware moderni implementano *core multithread* che possono scambiare thread in stallo con altri per mantenere l'attività.

=== Registri CPU a protezione della memoria
La *protezione della memoria* è cruciale per isolare la memoria di processi diversi, proteggendo l'area del SO dagli utenti e le aree dei processi utente tra loro. Questa protezione deve essere implementata a livello hardware (es. tramite *registro base e registro limite*) per questioni di prestazioni, poiché il SO di solito non interviene direttamente negli accessi alla memoria della CPU.

== Associazione degli Indirizzi
La preparazione di un programma utente per l'esecuzione passa attraverso diverse fasi che associano istruzioni e dati agli indirizzi di memoria fisica.
- Il *compilatore* trasforma i file sorgenti in file oggetto *rilocabili*, che possono essere caricati in qualsiasi posizione della memoria fisica.
- Il *linker* combina questi file oggetto rilocabili in un singolo *file binario eseguibile*, includendo eventualmente librerie.
- Il *loader* carica infine il file binario eseguibile in memoria. Quando si digita il nome di un programma in ambienti UNIX, la shell crea un nuovo processo con `fork()` e poi richiama il loader con `exec()`, che carica il file nello spazio degli indirizzi del nuovo processo.

#figure(image("images/2025-08-14-17-21-12.png", height: 30%))

L'associazione degli indirizzi può in una qualsiasi delle seguenti fasi:
- *Compilazione [SW]:* Se la posizione di caricamento in memoria è nota a priori, il compilatore può generare *codice statico (o assoluto)*. Questo è inefficiente se la posizione cambia, richiedendo una ricompilazione. Si parla di *associazione statica degli indirizzi*.
- *Caricamento [SW]:* Se la posizione non è nota al momento della compilazione, il compilatore genera *codice rilocabile*. Il caricatore tradurrà gli indirizzi rilocabili in assoluti al momento del caricamento. Anche questa è *associazione statica degli indirizzi*.
- *Esecuzione (o dinamica) [HW]:* Se un processo può essere spostato in memoria durante l'esecuzione, l'associazione degli indirizzi deve essere ritardata fino a quel momento. Questo richiede un *supporto hardware dedicato (MMU)* per evitare inefficienze dovute alla traduzione software. In questo caso, gli indirizzi nascono relativi e rimangono tali anche dopo il caricamento; la trasformazione in assoluti avviene *durante l'esecuzione dell'istruzione* che usa l'indirizzo. Si parla di *associazione dinamica degli indirizzi*. Questa è la fase più usata.

#figure(image("images/2025-08-14-17-23-31.png", height: 30%))

== Spazi degli Indirizzi Logici e Fisici
L'*associazione dinamica degli indirizzi* introduce due tipologie di indirizzi:
- Un *indirizzo logico (o virtuale)* è quello generato dalla CPU. L'*insieme di tutti gli indirizzi logici* generati da un programma è detto *spazio degli indirizzi logici (o virtuale)*.
- Un *indirizzo fisico* è quello visto dall'unità di memoria, cioè caricato nel registro dell'indirizzo di memoria (MemoryAddressRegister). L'*insieme di tutti gli indirizzi fisici* disponibili dall'architettura hardware è detto *spazio degli indirizzi fisici*.

In caso di *rilocazione statica*, gli indirizzi logici e fisici sono identici e i loro spazi coincidono. Il SO risiede nella parte alta della memoria (indirizzi grandi), mentre il primo processo utente è allocato dall'indirizzo 0 e gli altri seguono sequenzialmente. Quando un processo è caricato in una posizione diversa da 0, il SO lo riloca modificando gli indirizzi riferiti dal processo, sommando il valore del registro base.

#figure(
  image("images/2025-08-14-17-38-07.png", height: 30%),
  caption: "L'immagine mostra come un indirizzo logico di 28 (riferimento a JMP) diventi un indirizzo fisico di 16412 con una rilocazione di 16384 (28 + 16384 = 16412).",
)

Con la *rilocazione dinamica*, gli indirizzi logici e fisici sono diversi e i loro spazi differiscono. Per rilocare i processi dinamicamente, si utilizza una *MMU (Memory Management Unit)*, un hardware specifico che modifica gli indirizzi ad ogni riferimento in memoria. La MMU implementa una funzione $y = f(x)$ (funzione di rilocazione) che calcola l'indirizzo fisico $y$ corrispondente a un indirizzo logico $x$.

#figure(
  image("images/2025-08-14-17-41-39.png", height: 30%),
  caption: "
Ad esempio, un valore nel *registro di rilocazione* viene sommato all'indirizzo logico generato dal programma (es. 346 + 14000 = 14346) prima di essere inviato all'unità di memoria.",
)

== Memoria Virtuale
La *memoria virtuale* si basa sulla separazione tra spazio di indirizzi logico (ciò che il programma vede) e spazio di indirizzi fisico (l'effettiva allocazione della memoria reale). Questo permette al SO di offrire ai processi una memoria virtuale svincolata dalla memoria fisica.

=== Vantaggi della Memoria Virtuale
1. *Maggiore spazio disponibile:* Fornisce ai processi uno spazio di memoria (indirizzi virtuali) per istruzioni e dati che può essere maggiore di quello fisicamente presente. Generalmente, solo la porzione dello spazio virtuale attualmente in uso è allocata in memoria principale; il resto (o una copia) è in memoria secondaria (es. area di swap). La memoria virtuale è concettualmente la somma di memoria fisica e memoria ausiliaria.

#figure(
  image("images/2025-08-14-18-24-31.png", height: 30%),
  caption: "Il SO si occupa di trasferire porzioni della memoria virtuale di ogni processo tra memoria fisica e ausiliaria, sulla base delle necessità del processo. *memoria virtuale = memoria fisica + memoria ausiliaria*",
)

2. *Facilita la programmazione:* Il programmatore non deve preoccuparsi della quantità di memoria fisica disponibile, potendosi concentrare sul problema da risolvere. Il SO gestisce il trasferimento dinamico delle porzioni necessarie in modo trasparente al processo.
3. *Aumenta il grado di multiprogrammazione:* Il SO può attivare processi concorrenti le cui esigenze totali di memoria superano la capacità della memoria fisica (sovrallocazione).
4. *Permette la condivisione:* Consente la condivisione di file e memoria fisica tra due o più processi.

=== Organizzazione della Memoria Virtuale di un Processo
La memoria virtuale di un processo è generalmente suddivisa in sezioni:
- *Testo* (codice eseguibile),
- *Dati* (variabili globali),
- *Heap* (memoria allocata dinamicamente durante l'esecuzione) e
- *Stack* (memoria temporanea per chiamate di funzioni).

#figure(image("images/2025-08-14-18-26-40.png", height: 30%))

C'è uno spazio vuoto tra heap e stack per consentire la loro crescita dinamica e facilitare la condivisione di codice e dati. Uno spazio virtuale con "buchi" è detto *sparso*.
La memoria virtuale consente la condivisione di librerie: anche se ogni processo le vede come parte del proprio spazio virtuale, le pagine fisiche che le ospitano sono condivise.

#figure(image("images/2025-08-14-18-27-39.png", height: 30%))

=== Tecniche Associate alla Memoria Virtuale
La memoria virtuale abilita diverse tecniche, tra cui la condivisione delle pagine fisiche, la segmentazione/paginazione a domanda e la copiatura su scrittura (COW). È anche strettamente legata alla gestione della memoria secondaria, in particolare allo *swapping*.

== Avvicendamento dei Processi (Swapping)
Lo *swapping* è il meccanismo per cui un processo, o una sua parte, può essere temporaneamente trasferito dalla memoria principale a una *memoria ausiliaria (backing store o swap area)*, e poi riportato in memoria principale. La memoria ausiliaria è solitamente un disco ad accesso veloce con spazio sufficiente per le copie delle immagini di memoria di tutti i processi.

#figure(
  image("images/2025-08-14-18-31-01.png", height: 30%),
  caption: "2 stati corrispondono a processi pronti o in attesa il cui spazio virtuale si trova nella swap area del disco",
)

=== Avvicendamento Standard (o Swapping di Processi Interi)
#figure(image("images/2025-08-14-18-31-31.png", height: 30%))
Riguarda lo spostamento di processi interi. Quando un processo è spostato, tutte le sue strutture dati (e quelle dei thread, se multithread) devono essere scritte in memoria ausiliaria. Il SO deve conservare i metadati per il ripristino.
- *Vantaggio:* Permette di *sovrallocare la memoria fisica*, aumentando il grado di multiprogrammazione.
- *Svantaggi:* Se la rilocazione non è dinamica, il processo deve essere ricaricato nello stesso spazio di memoria, poiché gli indirizzi interni sono assoluti. Il tempo necessario per spostare interi processi è proibitivo, rendendo questa variante poco usata nei SO moderni.

=== Swapping con Paginazione (o Paginazione su Richiesta)
#figure(image("images/2025-08-14-18-34-20.png", height: 30%))
È una variante in cui è possibile spostare solo alcune pagine di un processo anziché l'intero processo. Un'operazione di *page out* sposta una pagina dalla memoria principale all'ausiliaria, mentre *page in* è l'operazione inversa.
- *Vantaggi:* Consente la sovrallocazione della memoria fisica, ma evita il costo dello spostamento di processi interi, dato che solo poche pagine sono coinvolte. Si integra bene con la gestione della memoria virtuale ed è utilizzato dalla maggior parte dei SO moderni, inclusi Linux e Windows.

=== Avvicendamento nei Sistemi Mobili
I sistemi mobili generalmente non supportano alcuna forma di swapping. Questo è principalmente dovuto all'uso della *memoria flash* per la memorizzazione non volatile, che ha meno capacità rispetto ai dischi rigidi, tollera un numero limitato di scritture e ha una bassa velocità di trasferimento con la memoria principale.

== Aspetti Caratterizzanti la Gestione della Memoria
Le tecniche di gestione della memoria sono caratterizzate da quattro parametri principali che dipendono dall'architettura hardware e dalle scelte di progetto del SO:
#figure(image("images/2025-08-14-18-35-23.png", height: 30%))

Come si assegnano le aree di memoria ai processi?

=== Rilocazione Statica e Dinamica
- Nella *rilocazione statica*, gli indirizzi logici e fisici coincidono a run-time, e la CPU genera direttamente indirizzi fisici (assoluti). Il caricatore rilocante modifica gli indirizzi logici del modulo in indirizzi fisici.
#figure(
  image("images/2025-08-14-18-36-28.png", height: 30%),
  caption: "PC e SP vengono inizializzati con indirizzi fisici. I processi generano indirizzi fisici.",
)
Gli svantaggi includono l'impossibilità di ricaricare un processo in un'area di memoria diversa (es. dopo swap out/in) perché le sue informazioni fanno riferimento a indirizzi fisici originali.

- Nella *rilocazione dinamica*, gli spazi degli indirizzi logici e fisici differiscono. La CPU genera indirizzi logici, e una *MMU* hardware li converte in indirizzi fisici a run-time.
#figure(
  image("images/2025-08-14-18-39-14.png", height: 30%),
  caption: "PC e SP vengono inizializzati con indirizzi logici. I processi generano indirizzi logici, l'architettura HW del sistema, tramite la MMU, converte gli indirizzi logici in indirizzi fisici a run-time.",
)
Questa soluzione ritarda la fase di rilocazione degli indirizzi, risolvendo i problemi della rilocazione statica.

=== Allocazione della Memoria Fisica
- L'allocazione deve essere *contigua* se la rilocazione è statica: indirizzi logici contigui devono corrispondere a indirizzi fisici contigui. Questo perché il PC contiene indirizzi fisici, e la CPU preleva l'istruzione successiva dall'indirizzo fisico successivo.
- L'allocazione può essere *non contigua* se la rilocazione è dinamica: il PC contiene indirizzi logici, e la CPU preleva l'istruzione successiva dall'indirizzo logico successivo, ma l'indirizzo fisico corrispondente può essere non contiguo grazie alla funzione di rilocazione della MMU.

=== Organizzazione dello Spazio di Memoria Virtuale
- *Spazio unico:* Il linker alloca tutti i moduli di un programma (codice, dati, stack, heap, librerie) in indirizzi virtuali contigui.
- *Spazio segmentato:* I moduli non sono necessariamente contigui. Un programma è suddiviso in un numero arbitrario di *segmenti*, ciascuno con un indirizzo iniziale 0 (es. un segmento per il codice, uno per i dati, ecc.). Ogni segmento può essere rilocato in memoria fisica indipendentemente dagli altri. Un indirizzo virtuale è una coppia `<numero_segmento, locazione_nel_segmento>`. Con rilocazione statica, un compilatore/caricatore usa una tabella di indirizzi fisici iniziali; con rilocazione dinamica, la MMU usa valori base e limite da una tabella.
#figure(
  image("images/2025-08-14-18-43-26.png", height: 30%),
  caption: "L'immagine `b) spazio virtuale segmentato` mostra come un unico spazio virtuale sia diviso in segmenti separati. ",
)
Distinguere tra segmenti di dati e testo è utile per la *sicurezza*. Molti SO moderni cercano di fare in modo che i segmenti di dati siano scrivibili ma non eseguibili e che quelli di testo siano eseguibili ma non scrivibili.

=== Caricamento dello Spazio Virtuale in Memoria Fisica
- *Caricamento unico (o statico):* Il programma e i dati di un processo sono interamente e costantemente caricati in memoria. La dimensione della memoria virtuale deve essere minore o uguale a quella fisica disponibile. Le assegnazioni e i rilasci di memoria avvengono solo alla creazione e terminazione del processo. Permette la rilocazione statica degli indirizzi.
#figure(
  image("images/2025-08-14-18-46-17.png", height: 30%),
  caption: "L'immagine mostra come compilatore, linker e loader operano per caricare tutto il programma in memoria.",
)

- *Caricamento a domanda (o su richiesta, o dinamico):* Il programma e i dati non sono necessariamente caricati per intero. Richiede la rilocazione dinamica degli indirizzi. La memoria fisica assegnata a un processo varia nel tempo, e le sue dimensioni virtuali possono essere maggiori di quelle fisiche. Il programma principale viene eseguito, e le procedure ausiliarie sono caricate su disco in formato rilocabile. Quando una procedura è invocata e non è in memoria, il linking loader la carica e aggiorna le tabelle degli indirizzi. Questo ottimizza l'uso della memoria (caricando solo ciò che serve), consente l'esecuzione di processi con spazi virtuali maggiori della memoria fisica totale, e presuppone l'esistenza di un'area di swap.
#figure(
  image("images/2025-08-14-18-47-02.png", height: 30%),
  caption: "L'immagine illustra questo processo.",
)

==== Collegamento (Linking) Statico e Dinamico
Il caricamento a domanda è legato al concetto di collegamento dinamico.

#figure(image("images/2025-08-14-18-50-20.png", height: 30%))

- Con il *collegamento statico*, le librerie di sistema sono combinate dal loader nell'immagine binaria del programma, aumentando la dimensione del file eseguibile e potenzialmente sprecando spazio in memoria. L'immagine `SENZA COLLEGAMENTO DINAMICO (COLLEGAMENTO STATICO)` mostra la ripetizione del codice di libreria per ogni chiamata.

- Con il *collegamento dinamico*, il collegamento di una libreria è differito fino al momento dell'esecuzione. Il linker inserisce informazioni di rilocazione che consentono alla libreria di essere collegata e caricata in memoria solo se richiesta. Si usa soprattutto per librerie di sistema condivise (es. Dynamic-Link Library in Windows).
#figure(
  image("images/2025-08-14-18-49-05.png", height: 30%),
  caption: "La libreria sarà collegata dinamicamente e caricata in memoria quando il programma è già caricato.",
)
Il *run-time loader* è comune a tutto il sistema. L'immagine `CON COLLEGAMENTO DINAMICO` evidenzia la singola copia della libreria. Questo porta a un *risparmio significativo di memoria* (evita di caricare librerie non usate, consente una singola copia condivisa) e permette aggiornamenti automatici delle librerie. Richiede assistenza del SO per controllare la presenza della procedura in memoria e gestire l'accesso a indirizzi condivisi.

=== Combinazioni di Caratteristiche
Alcune combinazioni dei quattro parametri non sono significative:
- Con *rilocazione statica*, l'allocazione della memoria fisica è sempre contigua e il caricamento dello spazio virtuale è unico.
- Con *rilocazione dinamica*:
  - Se l'allocazione della memoria fisica è contigua, lo spazio virtuale è segmentato (per agevolare la condivisione).
  - Se l'allocazione della memoria fisica è non contigua e lo spazio virtuale è segmentato, il caricamento è a domanda.

#figure(image("images/2025-08-14-18-51-59.png", height: 30%))

== Memoria Partizionata
Nella gestione della memoria partizionata, la memoria fisica è divisa in due parti: una per il SO residente e l'altra per i processi utente. La rilocazione degli indirizzi è statica, senza supporti hardware come la MMU.

=== Partizioni Fisse o Variabili (Spazio Virtuale Unico)
#figure(image("images/2025-08-14-19-30-54.png", height: 15%))
#figure(image("images/2025-08-14-19-31-29.png", height: 30%))
Il SO cerca un'area contigua di memoria sufficiente a contenere l'immagine del processo. L'area rimane assegnata fino alla terminazione del processo. Se il processo viene scambiato, deve essere ricaricato nella stessa area a causa della rilocazione statica. Si hanno due schemi di gestione:

- *Partizioni Fisse:* La memoria utente è divisa in un numero fisso di partizioni di dimensioni predefinite. Il SO mantiene una tabella delle partizioni. Un processo occupa una partizione fino alla sua terminazione o swap-out. Possono esserci code di processi per ogni partizione.
#figure(
  image("images/2025-08-14-19-33-21.png", height: 30%),
  caption: "L'immagine `Partizioni fisse: esempio` mostra una memoria divisa in partizioni D0-D5, con processi P1-P5 che le occupano, lasciando memoria inutilizzata. Questa tecnica è inefficiente. ",
)
Il principale svantaggio è la *frammentazione interna*, dove la memoria allocata è maggiore di quella utilizzata all'interno di una partizione. Inoltre, vi è una mancanza di flessibilità, poiché numero e dimensioni sono fissi, limitando il grado di multiprogrammazione e la dimensione massima dei processi.

- *Partizioni Variabili:* Generalizza lo schema precedente, con caratteristiche delle partizioni definite dinamicamente in base alle esigenze dei processi. Inizialmente, tutta la memoria utente è una singola partizione che viene dinamicamente suddivisa.
  - *Compiti del SO:* Quando un processo richiede memoria, il SO cerca una partizione disponibile sufficientemente grande. Se la trova, assegna la memoria necessaria e trasforma la parte restante in una nuova partizione disponibile. Se non c'è spazio, il SO può attendere o cercare altri processi. Quando un processo termina, la sua partizione diventa disponibile e viene accorpata a partizioni adiacenti libere, e il SO controlla se può caricare processi dalla coda d'ingresso.
  #figure(
    image("images/2025-08-14-20-21-35.png", height: 30%),
    caption: "L'immagine illustra l'evoluzione delle partizioni nel tempo con l'allocazione e il rilascio di processi.",
  )
  - *Algoritmi di assegnazione della memoria (per partizioni variabili):* Quando più partizioni possono soddisfare una richiesta:
    - *First-fit:* Alloca la prima partizione disponibile sufficientemente grande.
    - *Best-fit:* Alloca la più piccola tra le partizioni disponibili sufficientemente grandi. Richiede l'esame di tutte le partizioni (o che siano ordinate per dimensione). Produce le partizioni inutilizzate più piccole.
    - *Worst-fit:* Alloca la più grande tra le partizioni disponibili sufficientemente grandi. Richiede l'esame di tutte le partizioni (o che siano ordinate in modo decrescente). Produce le partizioni inutilizzate più grandi.
    - Simulazioni mostrano che first-fit è più veloce di best-fit con un utilizzo di memoria simile, e entrambi sono migliori di worst-fit.
  - *Strutture dati del SO:* Il gestore della memoria mantiene una lista delle partizioni disponibili (indirizzo iniziale, dimensione). La lista può essere ordinata per dimensioni crescenti (facilita best-fit) o per indirizzi crescenti (facilita l'accorpamento di partizioni adiacenti).
  - *Protezione e condivisione:* La protezione tra processi si ottiene con supporto hardware (registri base e limite). Ogni processo ha un'area privata. Il SO può accedere a tutta la memoria. Non è possibile la condivisione, dato che lo spazio virtuale è unico e richiede allocazione contigua.
  - *Vantaggi:* Flessibilità ed eliminazione della frammentazione interna rispetto alle partizioni fisse.
  - *Problema:* *Frammentazione esterna*, dove la somma delle partizioni libere è sufficiente, ma nessuna singola partizione è abbastanza grande per una richiesta. La "regola del 50%" indica che un terzo della memoria potrebbe essere inutilizzabile per frammentazione esterna con first-fit.
  - *Soluzioni:* *Compattazione* (riordinare la memoria per riunire i blocchi liberi), ma richiede rilocazione dinamica. Oppure, rinunciare all'allocazione contigua tramite *partizioni multiple* o *paginazione*.

=== Partizioni Multiple (Spazio Virtuale Segmentato)
#figure(image("images/2025-08-14-20-24-18.png", height: 10%))
#figure(image("images/2025-08-14-20-24-31.png", height: 30%))
Per ridurre la frammentazione esterna e consentire la condivisione, lo spazio virtuale può essere segmentato (es. in codice, dati, stack, heap). Questa tecnica ha rilocazione statica, allocazione contigua, spazio virtuale segmentato e caricamento unico. Ogni segmento virtuale è allocato in locazioni fisiche contigue, ma *indipendentemente dagli altri segmenti* del programma.
- *Vantaggi:* Condivisione di codice e dati. Riduzione degli effetti negativi della frammentazione esterna, facilitando l'allocazione dei processi tramite un numero maggiore di partizioni più piccole.
- *Svantaggi:* Maggiore complessità del linker che deve gestire più segmenti.

== Segmentazione
#figure(image("images/2025-08-14-20-30-25.png", height: 10%))
#figure(image("images/2025-08-14-20-30-44.png", height: 30%))
La tecnica della *segmentazione* si ottiene dalle partizioni multiple permettendo la *rilocazione dinamica* delle partizioni. Ha rilocazione dinamica, allocazione contigua, spazio virtuale segmentato e caricamento unico. Consente la *compattazione* della memoria per riunire i blocchi liberi.

=== Spazio Virtuale e Programma
Uno spazio virtuale segmentato non è vincolato a essere suddiviso solo in codice, dati, stack e heap. La sua struttura può riflettere la vista logica del programma percepita dal programmatore (procedure, funzioni, variabili, ecc.).
#figure(
  image("images/2025-08-14-23-55-39.png", height: 30%),
  caption: "A sinistra il programma dal punto di vista del programmatore. Unendo sinistra e destra si ottiene la vista logica della segmentazione.",
)
La memoria virtuale diventa *multidimensionale*, suddivisa in segmenti, ciascuno con una sequenza lineare di indirizzi da 0 a un massimo. Un indirizzo logico `x` è una coppia `<sg, of>`, dove `sg` è il numero di segmento e `of` è lo scostamento dall'inizio del segmento.

=== Traduzione degli Indirizzi
Per tradurre a run-time gli indirizzi logici in fisici, si usa una *tabella dei segmenti* (allocata nella memoria fisica del processo).
#figure(image("images/2025-08-14-23-58-14.png", height: 30%))
Ogni elemento (descrittore di segmento) contiene l'indirizzo fisico iniziale (*base*) e la dimensione (*limite*) del segmento. Due registri della CPU, *STBR (Segment Table Base Register)* e *STLR (Segment Table Limit Register)*, contengono l'indirizzo della tabella e il numero di segmenti del processo.
La traduzione avviene così: l'indirizzo logico `<sg, of>` viene usato per indicizzare la tabella dei segmenti. Se `of` è minore della dimensione del segmento, l'indirizzo fisico è `base + of`.

#figure(image("images/2025-08-15-00-00-10.png", height: 30%))

Il principale inconveniente della traduzione è la *perdita di efficienza* dovuta a due accessi alla memoria per ogni indirizzo generato dalla CPU: uno per la tabella dei segmenti e uno per l'informazione voluta. La soluzione è l'uso di un *TLB (Translation Lookaside Buffer)*.

==== Traduzione con TLB (Translation Lookaside Buffer)
Il TLB è una piccola *cache hardware* che contiene informazioni sulle traduzioni più recenti. Ogni registro del TLB memorizza un numero di segmento e i corrispondenti valori base e limite. Quando la CPU genera un riferimento, l'hardware cerca prima nel TLB. Se la ricerca ha successo (TLB hit), la traduzione procede rapidamente. Altrimenti (TLB miss), la ricerca avviene nella tabella dei segmenti in memoria, e le informazioni ottenute vengono inserite nel TLB.
#figure(image("images/2025-08-15-00-01-38.png", height: 30%))

- L'*hit rate* tipico di un TLB è superiore al 99%, e il suo tempo di accesso è solitamente inferiore al 10% del tempo di accesso alla memoria principale.
- *Complicazioni:* Il *context switch* richiede l'invalidazione del TLB (TLB flush) poiché le informazioni non sono valide per il nuovo processo. Alcuni sistemi usano un *Address-Space Identifier (ASID)* per mantenere nel TLB informazioni relative a processi diversi, evitando il flush completo. Anche lo spostamento di un segmento richiede l'invalidazione di registri TLB.
- Il *Tempo Effettivo di Accesso alla Memoria (EMAT)* con TLB si calcola come:
Sia p, con 0<=p<=1, la probabilità che la ricerca in TLB abbia successo.
1-p è la probabilità che ci sia un TLB miss.
$"EMAT" = p times ("Tempoaccesso TLB" + "Tempo accesso memoria") + (1 - p) times (2 times "Tempo accesso memoria" [+ "Tempo accesso TLB"])$. Il secondo tempo di accesso al TLB è omesso se l'architettura permette la ricerca in parallelo nel TLB e nalla memoria.

Le informazioni relative alla gestione della memoria, come l'indirizzo e il numero di segmenti della tabella, sono contenute nel *PCB (Process Control Block)* di ogni processo e usate per inizializzare i registri STBR e STLR durante il context switch.

=== Vantaggi della Segmentazione

- *Protezione:* La traduzione degli indirizzi include controlli su `sg < STLR`, `of < dimensione_segmento`, e sui *diritti di accesso* (R, W, X bit nel descrittore di segmento).

- *Condivisione:* Processi diversi possono condividere segmenti, a patto che abbiano lo stesso indice nei rispettivi spazi logici e quindi occupino le stesse posizioni.
#figure(image("images/2025-08-15-00-08-33.png", height: 30%))

- *Eliminazione della frammentazione esterna:* I segmenti possono essere spostati per *compattare* la memoria.
#figure(image("images/2025-08-15-00-08-53.png", height: 20%))

=== Segmentazione a Domanda
#figure(image("images/2025-08-15-23-38-04.png"))
#figure(image("images/2025-08-15-23-38-15.png"))
Questa tecnica ha rilocazione dinamica, allocazione contigua, spazio virtuale segmentato e *caricamento a domanda*. Permette che lo spazio virtuale di un processo sia *parzialmente caricato* in memoria fisica. Questo significa che lo spazio logico di un processo può essere più grande della memoria fisica. Lo swapping riguarda singoli segmenti, non l'intero processo. Un processo può essere schedulato anche se nessuno dei suoi segmenti è in memoria fisica.
La rilocazione degli indirizzi diventa più complessa, poiché il SO deve gestire i riferimenti a segmenti non ancora caricati. Ogni descrittore di segmento include un *bit di presenza (P)*: 1 se il segmento è in memoria, 0 altrimenti (in questo caso si genera un'interruzione di *segment fault*). La routine di gestione del segment fault carica il segmento necessario.
In caso di esaurimento dello spazio, il SO deve scaricare segmenti esistenti usando *algoritmi di sostituzione*. Due bit aggiuntivi, *M (modifica/dirty bit)*  messo a 1 se il segmento è stato modificato dopo essere stato caricato in memoria (se è a zero quando si esegue lo swap-out, non c'è bisogno di aggiornare la cpopia su disco) e *U (uso/riferimento bit)* messo a 1 se il segmento è stato riferito di recente.

#figure(
  image("images/2025-08-15-23-42-34.png"),
  caption: "Nell'immagine R,W,X sono i diritti di accesso in lettura, scrittura ed esecuzione (usati per la protezione della memoria). M,U bit di modifica e di uso. P bit di presenza (se P=0 si ha seg-fault).",
)

== Paginazione
#figure(image("images/2025-08-15-23-44-19.png"))
#figure(image("images/2025-08-15-23-44-35.png"))
La *paginazione* è una tecnica di gestione della memoria che mira a eliminare alla radice il problema della frammentazione, permettendo l'allocazione di informazioni con indirizzi virtuali contigui in locazioni fisiche non necessariamente contigue. Richiede rilocazione dinamica, allocazione non contigua, spazio virtuale unico e caricamento unico.

=== Concetti di Paginazione
Lo spazio virtuale è suddiviso in blocchi di locazioni contigue, chiamate *pagine (virtuali)*, di dimensioni fisse (solitamente una potenza di 2). Lo spazio fisico è diviso in blocchi di indirizzi fisici chiamati *frame (o pagine fisiche)*, con le stesse dimensioni delle pagine. Ogni pagina è allocata in un frame, e pagine consecutive possono essere allocate in frame non consecutivi.
La corrispondenza tra pagine e frame è registrata in una *tabella delle pagine*, ogni processo in memoria principale ne possiede una. Ogni elemento della tabella è un *descrittore di pagina*.
#figure(image("images/2025-08-15-23-47-11.png"))

=== Traduzione degli Indirizzi
Per individuare la tabella delle pagine di un processo (contenuta in memoria principale), si usano due registri:
- *PTPR (Page Table Pointer Register)* che contiene l'indirizzo iniziale della tabella.
- *PTLR (Page Table Length Register)* che contiene il numero di pagine del processo.
Alternativamente, quando PTLR non è disponibile e quindi le tabelle delle pagine hanno tutte la stessa lunghezza, si ha un *bit di validità* in ogni elemento della tabella indica se la pagina è *legale* (1), ovvero è nello spazio degli indirizzi logici del processo o *non valida* (0).
#figure(image("images/2025-08-15-23-50-27.png"))

Un indirizzo logico `x` viene scomposto in due componenti: *`pg` (numero di pagina)* e *`of` (scostamento dall'inizio della pagina)*. Se la dimensione delle pagine `d` è una potenza di 2 (`2^y`), `of` è il *resto* della divisione di `x` per `d` e `pg` è il *quoziente* delle divisione di `x` per `d`.
La traduzione (`x = pg • of`) avviene usando `pg` come indice nella tabella delle pagine per selezionare il descrittore che contiene l'indice del frame `fr` che ospita la pagina. L'indirizzo fisico corrispondente `y` è ottenuto concatenando l'indice del frame `fr` con lo scostamento `of` (`fr • of` ovvero *concatenazione*). A differenza della segmentazione, non sono necessari confronti o somme esplicite per ottenere l'indirizzo fisico.
#figure(image("images/2025-08-15-23-54-20.png"))
#figure(image("images/2025-08-15-23-54-35.png"))

Analogamente alla segmentazione, la traduzione richiede *due accessi alla memoria* per ogni indirizzo generato dalla CPU. La soluzione è l'uso del *TLB*.
#figure(image("images/2025-08-15-23-55-19.png"))
#figure(image("images/2025-08-15-23-55-43.png"))
Le CPU moderne possono avere più livelli di TLB, rendendo il calcolo dell'EMAT più complesso. Il design del SO deve essere ottimizzato per l'architettura dei TLB.
Le informazioni relative all'indirizzo e al numero di pagine della tabella sono memorizzate nel PCB del processo e utilizzate per inizializzare i registri PTPR e PTLR durante il context switch.

=== Tabella dei Frame
Il gestore della memoria fisica mantiene una *tabella dei frame* che elenca i frame disponibili. Ogni elemento indica se il frame è libero o, se occupato, il processo e l'indice della pagina virtuale che ospita. Quando un processo è caricato, gli vengono assegnati tanti frame (non necessariamente consecutivi) quante sono le sue pagine. Se non ci sono abbastanza frame, altri processi possono essere scambiati per liberare lo spazio necessario.
#figure(image("images/2025-08-15-23-57-53.png"))

=== Considerazioni sulle Tabelle delle Pagine
La *dimensione delle pagine* è un parametro importante, tipicamente tra 4KB e 8KB, ma può arrivare a 2MB.
- *Pagine più piccole:* Aumentano il numero delle pagine e quindi la dimensione della tabella delle pagine. Tuttavia, riducono la *frammentazione interna* (l'ultima pagina di ogni processo è mediamente utilizzata solo a metà). Si adattano meglio alla località del programma, portando in memoria solo lo stretto necessario.
- *Pagine più grandi:* Diminuiscono la dimensione della tabella delle pagine e il numero di page fault. Aumentano la portata del TLB e il tempo complessivo di I/O (trasferendo meno pagine ma più grandi). La tendenza nei sistemi moderni è verso l'incremento della dimensione delle pagine.

La maggior parte dei processi è piccola o utilizza il proprio spazio di indirizzi in modo sparso, lasciando molte voci inutilizzate nelle tabelle delle pagine. Le tabelle delle pagine possono essere enormi nelle architetture moderne, rendendo necessaria una loro strutturazione.

=== Vantaggi della Paginazione
- *Allocazione semplificata:* È sufficiente individuare frame liberi ovunque risiedano.
- *Swapping semplificato:* Tutte le pagine e i frame hanno le stesse dimensioni.
- *Protezione:* Ogni elemento della tabella delle pagine può contenere bit di protezione (es. R, W, X).
- *Condivisione:* Possibile, ma problematico in quanto le pagine condivise devono avere gli stessi indici negli spazi virtuali.
#figure(
  image("images/2025-08-15-23-59-32.png"),
  caption: "L'immagine mostra come le pagine fisiche di una libreria possono essere condivise pur apparendo in spazi virtuali diversi.",
)

=== Paginazione a Domanda
#figure(image("images/2025-08-16-00-00-23.png"))
#figure(image("images/2025-08-16-00-02-15.png"))
La *paginazione a domanda* ha rilocazione dinamica, allocazione non contigua, spazio virtuale unico e *caricamento a domanda*. Il suo spazio virtuale può essere parzialmente caricato in memoria fisica.
Vengono utilizzati gli stessi bit di controllo della segmentazione a domanda: *P (presenza), M (modifica), U (uso)*. Alla creazione di un processo, il suo spazio virtuale è interamente nell'area di swap, e la tabella delle pagine ha tutti i bit P a 0. Il processo può essere schedulato anche senza pagine in memoria.
Quando l'esecuzione inizia, solo una pagina è caricata inizialmente; le altre vengono caricate a seguito di *page fault*. Un page fault è un'interruzione generata dall'hardware di traduzione degli indirizzi quando la CPU cerca una pagina non in memoria (P=0). La routine di gestione del page fault carica la pagina dalla swap area, eventualmente dopo aver richiamato un algoritmo di sostituzione, e l'istruzione che ha causato il fault viene rieseguita.
#figure(image("images/2025-08-16-00-04-43.png"), caption: "Descrittore di pagina")
#figure(
  image("images/2025-08-16-00-05-12.png"),
  caption: "Esempio di tabella delle pagine in cui alcuna pagine non sono in memoria principale",
)
#figure(image("images/2025-08-16-00-06-12.png"), caption: "Traduzione di un indirizzo")
#figure(image("images/2025-08-16-00-07-25.png"), caption: "Schema di traduzione degli indirizzi con TLB e page fault.")
#figure(image("images/2025-08-16-00-07-31.png"), caption: "Traduzione di un indirizzo con page fault.")
#figure(image("images/2025-08-16-00-07-42.png"), caption: "Sostituzione di pagine.")

==== Sostituzione di Pagine
Quando non ci sono frame liberi per caricare una pagina in seguito a un page fault, è necessaria la *sostituzione di pagine*.
La procedura di gestione di un page fault è la seguente:
1. Il SO verifica la validità del riferimento alla memoria virtuale.
2. Se non valido, il processo termina; altrimenti, si determina la locazione su disco della pagina desiderata.
3. Si individua un frame libero; se non c'è, si invoca un *algoritmo di sostituzione* per selezionare una pagina "vittima" da scrivere su disco.
4. La pagina desiderata viene caricata nel frame libero.
5. Le tabelle interne del SO, la tabella delle pagine del processo e la tabella dei frame vengono aggiornate.
6. Il processo viene rimesso nella coda dei pronti, riprendendo dall'istruzione che ha causato il page fault.

La sostituzione è più semplice che nella segmentazione perché pagine e frame hanno dimensioni fisse. La pagina vittima non deve essere scritta su disco se non è stata modificata (M=0). Alcune pagine (es. buffer I/O con DMA) non possono essere selezionate come vittime e vengono bloccate in memoria tramite un *bit di lock* nella tabella dei frame. La scelta della pagina da rimpiazzare è critica per l'efficienza complessiva del sistema, e un numero eccessivo di page fault può portare al *thrashing*.

#definition("Thrashing")[
  Stato in cui l'attività della CPU è principalmente dedicata a trasferire pagine avanti e indietro dalla swap-area e alla gestione di page-fault.
]

==== Posizionamento sul Disco delle Pagine Scaricate
Le pagine scaricate possono risiedere in una partizione dedicata per lo swapping (come in UNIX) o in uno o più file speciali all'interno del file system normale (come in Windows). Lo spazio su disco può essere assegnato staticamente e contiguamente (semplice ma rigido) o dinamicamente al verificarsi dello swap out di ogni pagina (più complesso, richiede una tabella di indirizzi di pagine su disco).

==== Tempo Effettivo di Accesso in Memoria con Page Fault (EMATpf)
L'EMATpf tiene conto della probabilità `p` che una pagina manchi (page fault):
`EMATpf = (1 - p) * tempo_accesso_memoria + p * tempo_gestione_page_fault`.
Il tempo di accesso alla memoria è dell'ordine dei nanosecondi, mentre la gestione di un page fault richiede centinaia di microsecondi o millisecondi (a causa delle istruzioni di gestione e dell'I/O su disco).
#example("Esempito EMATpf")[
  Ad esempio, con un accesso alla memoria di 200 nanosecondi e un tempo di gestione del page fault di 8 millisecondi, l'EMATpf è dominato dal costo del page fault. Per tollerare un rallentamento del 10%, `p` deve essere estremamente basso (es. al più una pagina mancante ogni 400.000 accessi).
  #figure(image("images/2025-08-16-00-15-23.png"))
]


==== Gestione Software del TLB
Mentre si è assunto che il TLB sia gestito dall'hardware, molte macchine RISC moderne (SPARC, MIPS) non hanno un TLB hardware, e la gestione è svolta dal SO via software. Questo deve avvenire molto rapidamente, poiché i TLB miss sono più frequenti dei page fault.

== Segmentazione con Paginazione
#figure(image("images/2025-08-16-00-16-23.png"))
#figure(image("images/2025-08-16-00-16-35.png"))
Questa tecnica combina la strutturazione dello spazio virtuale in segmenti con l'allocazione della memoria a ogni segmento tramite paginazione. Ha rilocazione dinamica, allocazione non contigua, spazio virtuale segmentato e caricamento a domanda. È usata quando i segmenti sono grandi e non è conveniente mantenerli per intero in memoria principale.
- *Vantaggi:* Preserva i vantaggi di concepire lo spazio virtuale organizzato in unità logiche (segmenti, per modularità, protezione e condivisione) e di allocare la memoria fisica in maniera non contigua (pagine di uguali dimensioni, riduce la frammentazione).
- *Traduzione degli Indirizzi:* Gli elementi della tabella dei segmenti non contengono l'indirizzo base di un segmento, ma l'*indirizzo base della tabella delle pagine* per quel segmento. L'indirizzo virtuale è della forma `<sg, sc>`, dove `sc` è a sua volta strutturato come `<pg, of>`.
#figure(
  image("images/2025-08-16-00-17-39.png"),
  caption: "L'immagine `Schema di traduzione degli indirizzi` mostra un doppio livello di traduzione: prima la tabella dei segmenti, poi la tabella delle pagine del segmento specifico.",
)
- La traduzione può generare *segment fault* (se la tabella delle pagine del segmento non è in memoria) o *page fault* (se la pagina riferita non è in memoria).
- *Intel x86:* I processori Intel x86-32 supportavano entrambi i meccanismi (segmentazione e paginazione), simile a MULTICS. Tuttavia, a partire dall'x86-64, la segmentazione è stata considerata obsoleta e non è più supportata (se non in modalità legacy), principalmente perché gli sviluppatori di sistemi UNIX o Windows non la utilizzavano per questioni di portabilità.

== Copiatura su Scrittura (Copy-on-Write, COW)
Nella paginazione a domanda, un processo può essere schedulato anche senza pagine in memoria principale, caricandole via via tramite page fault. La generazione di processi tramite la system call `fork()` può migliorare le prestazioni usando la condivisione della memoria e una tecnica nota come *copiatura su scrittura (COW)*.
- *Funzionamento:* Prevede la *condivisione iniziale delle pagine* tra processo genitore e figlio. Una *copia della pagina* viene creata solo nel momento in cui uno dei processi (genitore o figlio) tenta di scrivere nella pagina condivisa. In questo modo, si copiano solo le pagine effettivamente modificate, mentre le altre rimangono condivise.
#figure(
  image("images/2025-08-16-00-20-38.png"),
  caption: "L'immagine illustra il passaggio da una pagina condivisa a due pagine separate dopo una modifica da parte di un processo.",
);

== Algoritmi di Sostituzione delle Pagine
In caso di page fault e memoria principale non disponibile, gli algoritmi di sostituzione delle pagine scelgono una pagina logica "vittima" da rimpiazzare. La loro qualità è cruciale per le prestazioni del SO dato che un page fault ritarda i tempi di esecuzione di un processo. Le prestazioni sono misurate dal numero di page fault risultanti per una data quantità di frame e una sequenza di riferimenti. Negli esempi successivi, gli algoritmi verranno valutati effettuandone l'eseguzione sulla seguente successione dei riferimenti alla memoria: `7, 0, 1, 2, 0, 3, 0, 4, 2, 3, 0, 3, 2, 1, 2, 0, 1, 7, 0, 1` con 3 frame disponibili messi a disposizione dalla memoria fisica. In generale, all'aumentare dei frame, ci si aspetta che il numero di page fault diminuisca.
#figure(image("images/2025-08-17-15-35-32.png"))

=== Algoritmo Ottimo
Sceglie come pagina da rimpiazzare quella che *sicuramente non sarà più riferita in futuro o che sarà riferita più tardi nel tempo*.
#figure(image("images/2025-08-17-15-37-34.png"))
- *Considerazioni:* È un algoritmo ideale e non realizzabile nella pratica perché richiede la conoscenza del futuro. Tuttavia, è utile come punto di riferimento per misurare la qualità degli altri algoritmi.

=== Algoritmo FIFO (First-In, First-Out)
Associa a ogni pagina l'istante di tempo in cui è stata caricata in memoria e sceglie come vittima la pagina caricata per prima in ordine di tempo.
#figure(image("images/2025-08-17-15-39-14.png"))
- *Considerazioni:* È semplice da realizzare, mantenendo una coda FIFO degli elementi della tabella dei frame. L'inconveniente è che la pagina più vecchia potrebbe essere ancora necessaria. Questo può portare all'*anomalia di Belady*, dove l'aumento del numero di frame disponibili può paradossalmente aumentare il numero di page fault.

#figure(image("images/2025-08-17-15-40-37.png"))
#figure(
  image("images/2025-08-17-15-40-52.png"),
  caption: "Con alcuni algoritmi di sostituzione delle pagine, quali FIFO, il tasso di page fault può aumentare con il numero dei frame assegnati ai processi",
)

==== Località dei Riferimenti alla Memoria e Working Set
Si usano allora informazioni relative ad accessi nell'immediato passato.
- La *località* di un processo è l'insieme delle sue pagine virtuali che sta attivamente usando. Un processo attraversa diverse località durante l'esecuzione. Il *principio di località spaziale* afferma che un processo si sposta di località in località gradualmente. Ad esempio quando si richiama una funzione.
Idealmente, ad un dato istante, ad ogni processo bisognerebbe assegnare i frame sufficienti ad ospitare tutte le pagine virtuali che fanno parte della sua località. La località di un processo può essere approssimata tramite
il concetto di *working set* (o insieme di lavoro): l'insieme delle sue pagine virtuali riferite nei più recenti $Delta$ riferimenti (o nelle $Delta$ più recenti unità di tempo).
- Se una pagina è in uso attivo si trova nel working set
- Se non è più usata esce dal working set $Delta$ riferimenti dopo il suo ultimo riferimento
#figure(image("images/2025-08-17-15-52-39.png"))

Il *principio di località temporale* afferma che la probabilità di accedere ad una pagina utilizzata di recente è maggiore della probabilità di accedere ad una
pagina utilizzata nel lontano passato. Ad esempio nei cicli for, while...
La precisione con cui è calcolato il WS dipende da $Delta$:
- Se $Delta$ è troppo piccolo, non include l'intera località
- Se $Delta$ è troppo grande, può ricomprendere più località
- Al limite, se $Delta$ è infinito, il working set coincide con l'insieme di tutte le pagine riferite dal processo durante la sua esecuzione.
Per velocizzare la traduzione degli indirizzi, i descrittori delle pagine del working set del processo in esecuzione dovrebbero essere nel TLB.

=== Algoritmo LRU (Least Recently Used)
Associa a ogni pagina l'istante di tempo in cui è stata acceduta per l'ultima volta e sceglie come vittima la pagina che *non è stata acceduta da più tempo*. Con l'esempio, produce 12 assenze di pagina.

#figure(image("images/2025-08-17-15-59-16.png"))
#figure(
  image("images/2025-08-17-15-59-40.png"),
  caption: "
L'immagine compara Ottimo (6 fault), FIFO (10 fault) e LRU (8 fault) per una sequenza di riferimento diversa, mostrando che LRU si avvicina all'ottimo.",
)

==== Implementazione di LRU
La difficoltà principale è gestire la memorizzazione dell'istante dell'ultimo accesso.
- *Con contatori:* La CPU ha un registro contatore. Ogni elemento della tabella delle pagine ha un campo "momento di utilizzo" che viene aggiornato con il valore del contatore quando la pagina è acceduta. La pagina LRU è quella con il valore minore.
- *Con stack:* Si mantiene uno stack di numeri di pagina (lista a doppio collegamento). Quando una pagina è riferita, il suo numero è spostato in cima allo stack. La pagina LRU è quella in fondo allo stack.
#figure(image("images/2025-08-17-16-07-33.png"))
- *Considerazioni:* LRU non soffre dell'anomalia di Belady, appartenendo alla classe degli *stack algorithms*. Sperimentalmente, le sue prestazioni si avvicinano di più a quelle dell'algoritmo ottimo. Tuttavia, la sua realizzazione è costosa in termini di tempo di esecuzione (ricerca/scrittura per contatori, aggiornamento puntatori per stack) e richiede un supporto hardware per evitare rallentamenti significativi.

==== Algoritmi di Approssimazione di LRU (con Bit di Riferimento)
Implementare l'LRU esatto è costoso. Molte architetture offrono un *bit di riferimento (o di uso)* per ogni pagina. Questo bit è impostato a 0 dal SO e a 1 dall'HW quando la pagina viene riferita. Periodicamente, il SO lo reimposta a 0. Questo permette di sapere quali pagine sono state accedute di recente, *non è conosciuto l'ordine*, fornendo una stima del working set.
- *Algoritmo con bit supplementari di riferimento (Aging):* Campiona periodicamente i bit di riferimento e ne salva lo stato in un contatore (es. un byte) per ogni pagina. A intervalli regolari, il SO legge il bit di riferimento, lo sposta come bit più significativo del contatore dopo uno shift a destra (scartando il bit meno significativo), e azzera il bit di riferimento. I contatori contengono la storia dell'utilizzo delle pagine. La pagina con il valore di contatore più piccolo è la LRU.
#figure(image("images/2025-08-17-16-15-21.png"))

- *Algoritmo con seconda chance:* Mantiene le pagine in una lista FIFO. Quando invocato, controlla il bit di riferimento della pagina in testa alla lista. Se R=0, la seleziona come vittima. Se R=1, pone R=0, sposta la pagina in fondo alla lista (dandole una "seconda chance") e ripete. È una variante di FIFO che sceglie la pagina più vecchia non riferita di recente.Nel caso più sfavorevole (tutte le pagine hanno R = 1), l'algoritmo seleziona la pagina da cui è iniziata la ricerca e a cui aveva dato una seconda chance. Usa solo il bit di riferimento R, senza bit supplementari, quindi l'ordine esatto con cui le pagine sono state usate non
è noto.
- *Algoritmo dell'orologio:* Implementazione efficiente della seconda chance, dove le pagine sono gestite come una lista circolare e un puntatore `vittima` indica la prossima pagina da esaminare. Funziona in modo simile alla seconda chance ma con operazioni di incremento modulare più semplici.
Quando viene invocato, l'algoritmo:
1. Considera la pagina il cui indice è in vittima
2. Controlla il bit di riferimento di tale pagina
  - Se R = 0: seleziona la pagina, incrementa la variabile vittima e termina.
  - Se R = 1: pone R = 0, incrementa la variabile vittima e torna al punto 1.
La pagina selezionata viene sostituita da una nuova pagina che viene inserita nella lista circolare nella posizione corrispondente (con R = 1).
#figure(image("images/2025-08-17-16-21-37.png"))

- *Algoritmo con seconda chance migliorato:* Utilizza sia il bit di riferimento (R) che il *bit di modifica (M, dirty bit)*. Il bit M è 0 se la pagina non è stata modificata dal suo ultimo salvataggio su disco (quindi non necessita di scrittura su swap-area), e 1 altrimenti. Le pagine non modificate sono vittime ideali perché la loro sostituzione è più veloce. Le pagine sono classificate in 4 categorie (R, M):
- (0,0) (migliore per sostituzione)
- (0,1) (modificata ma non usata di recente)
- (1,0) (usata di recente ma pulita)
- (1,1) (usata di recente e modificata).
L'algoritmo cerca prima (0,0), poi (0,1) azzerando i bit R, e poi ripete.

Quando viene invocato, l’algoritmo
a) Scorre la lista a partire da vittima alla ricerca di una pagina
etichettata (0,0); se ne trova una, la utilizza e termina
dopo aver incrementato vittima
b) Altrimenti, scorre (nuovamente) la lista a partire da
vittima, impostando a 0 il bit di riferimento per tutte le
pagine incontrate, alla ricerca di una pagina etichettata
(0,1); se ne trova una, la utilizza e termina dopo aver
incrementato vittima
c) Altrimenti, (tutti i bit di riferimento sono ora impostati a
0) ripete i passi a) e, eventualmente, b) (ciò permetterà
sicuramente di trovare una pagina da sostituire)
Per selezionare la nuova vittima la lista delle pagine viene
scandita più volte (fino a 4)

- *Algoritmi basati su conteggio:*
  - *LFU (Least Frequently Used):* Sostituisce la pagina con il valore minore del contatore (pagine meno usate).
  - *MFU (Most Frequently Used):* Sostituisce la pagina con il valore maggiore del contatore (pagine più usate di recente).
  Questi algoritmi non sono molto comuni perché costosi e non approssimano bene l'algoritmo ottimo.

=== Tecniche Software di Ottimizzazione
Per migliorare le prestazioni degli algoritmi di sostituzione:
- *Riserva (pool) di frame liberi:* Il SO gestisce un pool di frame liberi per soddisfare immediatamente le richieste di memoria. Le richieste vengono esaudite dal pool. L'algoritmo di sostituzione si attiva con bassa priorità quando il pool scende sotto una soglia. Questo velocizza le richieste di frame e permette trasferimenti concorrenti. Il SO può tenere traccia delle pagine nel pool per gestire page fault "soft".
- *Trasferimento spontaneo delle pagine modificate:* Il SO scandisce periodicamente le tabelle delle pagine e avvia il trasferimento delle pagine modificate (dirty) in memoria secondaria, resettando il bit M. Ciò aumenta la probabilità di trovare vittime pulite (che non devono essere scritte) quando un frame è richiesto.

== Algoritmi di Allocazione dei Frame
Gli algoritmi di allocazione dei frame controllano l'assegnazione della memoria fisica (frame) ai processi. La memoria fisica disponibile per un processo può essere inferiore alla sua memoria virtuale (sovrallocazione).
- Si può usare una *lista di frame liberi* che vengono utilizzati man mano che si generano page fault. Quando la lista si esaurisce, si usa un algoritmo di sostituzione delle pagine.
- Con la paginazione a domanda, inizialmente solo una pagina è caricata. Per prevenire un alto numero di page fault all'avvio (dovuti al caricamento della località iniziale), si può usare la *prepaginazione*, caricando l'intero working set del processo.

=== Numero di Frame Allocati
Le strategie di allocazione dei frame ai singoli processi
sono soggette a vari vincoli, quali ad esempio
1. Non si possono assegnare più frame di quelli disponibili
2. È necessario allocare almeno un numero minimo di frame

- Il numero massimo dipende dalla memoria fisica disponibile.
- Il numero minimo dipende dall'architettura del calcolatore (sufficiente a contenere tutte le pagine riferite da un'istruzione).
Minore è il numero di frame allocati, maggiore è il tasso di page fault e minori le prestazioni.

=== Algoritmi di Allocazione
- *Allocazione uniforme:* Tutti i processi ricevono lo stesso numero di frame.
- *Allocazione proporzionale:* Il numero di frame è proporzionale alla dimensione della memoria virtuale o alla priorità del processo, con un limite minimo.

=== Politiche di Sostituzione delle Pagine
- *Locale:* La pagina vittima viene scelta solo tra quelle allocate al processo che ha generato il page fault. L'insieme dei frame di un processo dipende solo dal suo comportamento.
- *Globale:* La pagina vittima viene scelta indipendentemente dal processo a cui è allocata. L'insieme dei frame di un processo dipende anche dal comportamento di paginazione di altri processi. È la politica più usata perché permette una maggiore produttività.
La politica globale si basa sulla strategia di garantire che ci sia sempre sufficiente memoria libera per soddisfare nuove richieste.
#example("Implementazione di una politica globale")[
  #figure(image("images/2025-08-17-16-31-41.png"))
  Il kernel del SO attiva e sospende tempestivamente l'attività di recupero di
  pagine (che usa l'algoritmo di sostituzione, qualsiasi esso sia) facendo in modo che la lunghezza della lista dei frame liberi si mantenga costantemente tra un minimo ed un massimo
]

== Thrashing
#definition("Thrashing")[
  Il *thrashing (o paginazione degenere)* è uno stato in cui l'attività della CPU è principalmente dedicata al trasferimento di pagine da e verso l'area di swap e alla gestione dei page fault. Questo causa notevoli problemi di prestazioni, poiché il sistema dedica più tempo alla paginazione che all'esecuzione dei processi applicativi.
]

=== Scenari di Thrashing
- *Scenario I (con politica di sostituzione locale):* Se un processo non ha abbastanza frame per il suo working set, incorrerà in page fault frequenti. Se la politica di sostituzione è locale, si sostituirà una pagina del working set, che sarà presto necessaria, portando a molti page fault e a un crollo della produttività.
- *Scenario II (con politica di sostituzione globale e monitoraggio CPU):* Il SO regola il grado di multiprogrammazione in base all'uso della CPU. Se un processo ha bisogno di più frame, genera page fault che sottraggono frame ad altri processi. Questi, a loro volta, generano page fault, saturando il dispositivo di paginazione. Mentre i processi sono in attesa dell'I/O, la coda dei pronti si svuota e l'utilizzo della CPU diminuisce. Il SO, vedendo la CPU inattiva, aumenta ulteriormente il grado di multiprogrammazione, causando ancora più page fault e prolungando le code. Alla fine, tutti i processi sono bloccati in attesa di I/O, e la CPU esegue solo l'algoritmo di sostituzione delle pagine.

=== Cause e Soluzioni del Thrashing
Il thrashing si verifica perché la somma delle dimensioni delle località (working set) dei processi attivi supera la dimensione totale della memoria fisica.
Per controllare il thrashing, oltre a usare algoritmi di sostituzione più efficienti, si possono usare due approcci:
1. *Valutazione approssimata tramite il working set:* Idealmente, a ogni processo dovrebbero essere assegnati frame sufficienti per ospitare tutte le pagine del suo working set. Se si assegnano meno frame, il processo degenera. Il SO controlla il working set di ogni processo e assegna i frame necessari. Se la somma dei working set supera i frame disponibili, il SO sospende un processo (swap out delle pagine e riallocazione dei frame), riavviandolo in seguito. Questa strategia previene il thrashing mantenendo il più alto grado di multiprogrammazione possibile e ottimizzando l'utilizzo della CPU. La difficoltà risiede nel mantenere aggiornate le informazioni sui working set.
2. *Frequenza accettabile di mancanze di pagina:* La frequenza dei page fault di un processo varia con il numero di frame assegnati. Se la frequenza è troppo bassa, il processo ha troppi frame; se è troppo alta, ne ha bisogno di più.

#figure(
  image("images/2025-08-17-16-35-15.png"),
  caption: "L'immagine mostra come l'utilizzo della CPU aumenti con il grado di multiprogrammazione fino a un massimo, per poi crollare bruscamente a causa del thrashing.",
)

Nei sistemi moderni (PC), il thrashing è meno problematico poiché gli utenti possono gestirlo manualmente (controllando i processi attivi) o, più comunemente, acquistando più memoria. La memoria è diventata così economica che non ha senso affrontare una memoria continuamente sovrallocata.

== Organizzazione delle Tabelle delle Pagine
Un problema critico nei sistemi moderni è la *dimensione enorme delle tabelle delle pagine*. Ad esempio, un sistema con indirizzi virtuali a 32 bit e pagine da 4KB avrebbe bisogno di 2^20 pagine, il che si traduce in una tabella delle pagine da 4MB (1024 frame contigui). Per risolvere questo, le tabelle delle pagine sono strutturate.

=== Tabelle delle Pagine Gerarchiche (Multilivello)
Una tecnica comune è la *paginazione gerarchica a 2 livelli*, usata ad esempio nei microprocessori Intel a 32 bit.
- La tabella delle pagine è suddivisa in porzioni consecutive (es. 2^10 porzioni, ciascuna di 4KB), che costituiscono le *tabelle delle pagine di 2° livello*. Queste possono essere allocate in memoria fisica in modo non contiguo e solo se necessario.
- Una *tabella di 1° livello (page directory)*, con un elemento per ogni porzione, è mantenuta in memoria fisica quando il processo è in esecuzione. L'indirizzo della page directory è nel registro *PDAR (Page Directory Address Register)*.
- L'indirizzo di pagina `pg` (di 20 bit nell'esempio) è suddiviso in un indice di pagina `dr` (10 bit per la page directory) e uno scostamento di pagina `stp` (10 bit per la tabella di 2° livello).

#figure(image("images/2025-08-17-16-39-56.png"), caption: "Organizzazione di un indirizzo a 32bit")
#figure(image("images/2025-08-17-16-40-16.png"), caption: "Schema di una tabella delle pagine a 2 livelli")
#figure(image("images/2025-08-17-16-40-44.png"), caption: "Schema di traduzione con tabella delle pagine a 2 livelli")
L'immagine `Schema di traduzione con tabella delle pagine a 2 livelli` mostra questo processo: prima si accede alla page directory per trovare l'indirizzo della tabella di 2° livello, poi si usa `stp` per trovare il frame. Questo metodo è noto come *tabella delle pagine ad associazione diretta (forward-mapped page table)*.
- *Vantaggio:* Mantenere in memoria solo le tabelle delle pagine necessarie.
#figure(image("images/2025-08-17-16-41-21.png"), caption: "Schema di traduzione degli indirizzi")

==== Paginazione a Livelli e Indirizzi Virtuali a 64 Bit
Con spazi di indirizzi virtuali a 64 bit (anche se spesso solo 48 bit sono effettivamente usati, come in Intel x86-64), una singola tabella delle pagine con pagine da 4KB sarebbe enorme. Con descrittori di pagina a 8 byte avremmo che la tabella delle pagine di ogni processo occuperebbe 8×252 byte = 255 byte = 32PB!
- Sono necessari schemi di paginazione a *più di due livelli*. L'architettura Intel x86-64 usa *4 livelli di tabelle delle pagine*, ciascuno indicizzato con 9 bit dell'indirizzo virtuale.
#figure(image("images/2025-08-17-16-46-52.png"))
#figure(image("images/2025-08-17-16-48-13.png"), caption: "Traduzione degli indirizzi in x86-64")
L'immagine `Traduzione degli indirizzi in x86-64` mostra i 4 livelli (PML4, PML3, PML2, Page Table) che portano all'offset del frame. Questo significa che sono necessari *4 accessi alla memoria* per tradurre un indirizzo logico in fisico (senza TLB).
#figure(image("images/2025-08-17-16-51-11.png"))


- Il *TLB è fondamentale* per ridurre l'impatto degli accessi multipli. Tuttavia, per architetture a 64 bit "vere" (es. UltraSPARC con 7 livelli di paginazione), le tabelle multilivello sono considerate inappropriate a causa del numero proibitivo di accessi alla memoria.

=== Tabelle delle Pagine di Tipo Hash
Questa organizzazione è spesso usata per gestire spazi di indirizzi maggiori di 32 bit.
- Ogni voce della tabella hash contiene una *lista concatenata di elementi* che hanno lo stesso valore della funzione hash.
- Ciascun elemento della lista contiene: il numero della pagina virtuale (o descrittore), l'indice del frame che ospita la pagina, e un puntatore all'elemento successivo.
- Quando un indirizzo virtuale è generato, il suo numero di pagina è passato a una *funzione hash*, il cui output è usato come indice nella tabella hash. La lista associata a quell'indice viene scandita per trovare l'elemento corrispondente alla pagina virtuale, e da lì si estrae l'indice del frame.
#figure(image("images/2025-08-17-16-52-27.png"), caption: "Schema di traduzione degli indirizzi")
- Una variante per spazi a 64 bit è la *tabella delle pagine a gruppi (clustered page table)*, dove ogni elemento della lista non è un singolo descrittore ma un gruppo (cluster) di descrittori di pagine virtuali contigue. È utile per spazi di indirizzi sparsi.
#figure(image("images/2025-08-17-16-57-30.png"), caption: "Schema di traduzione degli indirizzi")

=== Tabella delle Pagine Invertita
Si usa una *sola tabella delle pagine per tutto il sistema*, non una per processo.
- La tabella ha un elemento per ogni pagina fisica della memoria. Ciascun elemento contiene: l'*identificativo dello spazio virtuale (ASID)* del processo a cui la pagina virtuale ospitata appartiene, e l'*indirizzo virtuale* della pagina logica memorizzata in quella posizione fisica.
- Usata su diversi RISC a 64 bit (UltraSPARC, PowerPC) dove le tabelle delle pagine per processo sarebbero enormi (es. petabyte).
- L'indirizzo logico include il *pid del processo*, il numero di pagina `p` e uno scostamento `d`. La coppia `(pid, p)` è usata per cercare nella tabella invertita, e l'indirizzo fisico è ottenuto concatenando l'indice `i` dell'elemento trovato con lo scostamento `d`.
#figure(image("images/2025-08-17-17-05-42.png"))
- *Vantaggio:* Diminuisce la quantità di memoria principale necessaria per le tabelle delle pagine.
- *Svantaggi:* Non contiene le informazioni necessarie per i page fault (richiede una tabella separata del SO per le locazioni su disco). La *condivisione della memoria è più costosa*: ogni pagina fisica è mappata a una sola pagina virtuale alla volta, quindi un riferimento da un altro processo che condivide la memoria causerà un page fault. La *traduzione è più difficile e lenta* perché la ricerca avviene per indirizzo virtuale in una tabella ordinata per indirizzi fisici. L'uso di un *TLB* o di una *tabella hash* (unica per il sistema) può mitigare questo problema.
#figure(image("images/2025-08-17-17-06-09.png"))

== Considerazioni Generali
Diversi fattori influenzano la gestione della memoria virtuale:

=== Rilocazione Dinamica degli Indirizzi
La rilocazione dinamica rende il *context switch più costoso* perché richiede la commutazione delle informazioni nella MMU e l'invalidazione dei registri TLB. Impone anche vincoli alla condivisione delle informazioni.
#figure(image("images/2025-08-17-17-11-32.png"))
Molti sistemi operativi moderni mappano il *kernel nello spazio degli indirizzi di ogni processo*. Questo significa che quando si invoca una system call, il kernel viene eseguito nello spazio degli indirizzi del processo chiamante.
- *Vantaggio:* Non è necessario commutare lo stato di esecuzione e cambiare la funzione di rilocazione degli indirizzi, migliorando l'efficienza. Linux è un esempio di tale SO.
- *Inconveniente:* Aumenta enormemente la dimensione della tabella delle pagine e della tabella dei segmenti. 
#figure(image("images/2025-08-17-17-11-53.png"))
L'immagine `SO nello spazio di indirizzi del processo utente` mostra il kernel residente nella parte superiore dello spazio di indirizzi di ogni processo.

=== Portata del TLB
La *portata del TLB* esprime la quantità di memoria virtuale che può essere acceduta direttamente tramite il TLB senza accedere alla tabella delle pagine in memoria. Si calcola come `= elementi del TLB * dimensione pagine`. Idealmente, il TLB dovrebbe contenere i metadati relativi al working set del processo in esecuzione. Per aumentare la portata, si può aumentare il numero di elementi del TLB (costoso) o la dimensione delle pagine.

=== Dimensione delle Pagine
La dimensione delle pagine è un compromesso.
- *Fattori a favore delle piccole dimensioni:* Meno frammentazione interna (l'ultima pagina è mediamente sprecata solo per metà). Le pagine piccole si adattano meglio alla località del programma, portando in memoria solo ciò che è necessario.
- *Fattori a favore delle grandi dimensioni:* Diminuzione della dimensione della tabella delle pagine, minor numero di page fault, maggiore portata del TLB, e tempo complessivo di I/O ridotto (è più efficiente trasferire meno pagine ma più grandi).
La tendenza nei sistemi moderni è verso l'*incremento della dimensione delle pagine* (es. "huge pages" in Linux fino a 2MB).

=== Interazione tra Memoria Virtuale e I/O
Un problema sorge quando una pagina che ospita un buffer per operazioni di I/O (es. lettura da file) viene selezionata come vittima da un algoritmo di sostituzione globale. Se un dispositivo I/O sta eseguendo un trasferimento in DMA (Direct Memory Access) su quella pagina, la sua rimozione potrebbe causare la scrittura parziale dei dati in posizioni errate.
#figure(image("images/2025-08-17-17-12-57.png"))
- *Soluzioni:* Eseguire tutto l'I/O in appositi buffer del kernel del SO e poi copiare i dati nelle pagine dei processi utente. Oppure, *bloccare (pinning)* in memoria le pagine che ospitano un buffer di I/O, impedendone la rimozione tramite l'impostazione di un *bit di lock* nel descrittore di pagina.
