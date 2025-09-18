#import "../../../dvd.typ": *


= Il File System: Concetti, Interfaccia e Realizzazione

== Cos'è il File System?

Il *File System* (FS) è una componente fondamentale del Sistema Operativo (SO) il cui scopo principale è permettere agli utenti e ai processi di accedere e gestire grandi quantità di dati persistenti, ovvero dati che rimangono disponibili anche dopo la terminazione dei processi che li hanno creati o in assenza di alimentazione elettrica. A livello hardware, questo richiede l'uso di periferiche di memoria secondaria come dischi e CD. A livello software, il FS fornisce astrazioni e meccanismi per la rappresentazione, l'archiviazione e l'accesso ai dati, evitando che gli utenti debbano interagire con i dispositivi a un "basso livello", vedendoli come semplici sequenze di blocchi di dati.

In sostanza, il file system organizza e gestisce i blocchi dei dispositivi di memoria sottostanti per offrire queste astrazioni e meccanismi. Utenti e processi interagiscono con la memoria secondaria tramite la struttura astratta fornita dal FS. Esso realizza concetti astratti chiave:
- *File*: l'unità logica di memorizzazione persistente dei dati.
- *Directory*: un raggruppamento gerarchico di file e, a sua volta, di altre directory.
- *Partizione/Volume*: un raggruppamento gerarchico di file e directory associato a un dispositivo fisico (come un disco) o a una sua porzione.

Una caratteristica importante è che le proprietà di file, directory e partizioni/volumi sono *del tutto indipendenti dalla natura e dal tipo di dispositivo fisico* utilizzato. Il concetto di file astrae la memoria secondaria, proprio come il concetto di processo/thread astrae il processore e lo spazio di indirizzi astrae la memoria principale.

Il file system può essere osservato da due prospettive principali:
- *Punto di vista dell'utente (interfaccia del file system)*: Riguarda le *system call* che consentono l'utilizzo della memoria secondaria da parte di processi e utenti. Gli utenti si interessano principalmente a come file e directory sono identificati, quali operazioni possono essere eseguite su di essi e come sono organizzate le directory.
- *Punto di vista dell'implementatore (realizzazione del file system)*: Si concentra sulle *strutture dati* e gli *algoritmi* che il SO utilizza per gestire la memoria secondaria. Gli implementatori sono interessati a come file e directory sono memorizzati, come viene gestito lo spazio su disco e come garantire efficienza e affidabilità.

=== Tipi di File System

Esistono numerosi tipi di file system e la maggior parte dei SO ne supporta più di uno, anche contemporaneamente. Alcuni esempi notevoli includono:
- *UNIX*: Utilizza lo UNIX File System (UFS), basato sul Berkeley Fast File System (FFS).
- *Windows*: Supporta i file system FAT, FAT32 e NTFS (Windows NT File System).
- *Linux*: Sebbene supporti oltre 40 file system diversi, lo standard è il file system esteso, con versioni più recenti come ext3 ed ext4.
- *File System Distribuiti*: Consentono a un file system su un server di essere "montato" da uno o più client tramite una rete, come il Network File System (NFS).
- *Dischi Rimuovibili*: Hanno spesso file system specifici, ad esempio, molti CD-ROM utilizzano lo standard ISO 9660. della directory.

Le componenti principali dell'interfaccia del file system sono:
- File
- Metodi di accesso
- File mappati in memoria
- Directory
- Protezione
- Condivisione

== Il File

Un *file* è un contenitore nominato per un insieme di informazioni correlate, registrate in memoria secondaria. Esso astrae dalle caratteristiche fisiche delle unità di memoria del sistema.
- *Dal punto di vista del SO*: un file è un'unità di memoria logica formata da informazioni correlate, che il SO associa a dispositivi fisici non volatili e su cui permette operazioni online.
- *Dal punto di vista dell'utente*: è la più piccola porzione logica di memoria secondaria, in cui i dati possono essere scritti.

I file sono utili per:
- Memorizzare grandi quantità di dati.
- Creare dati permanenti che sopravvivono ai processi.
- Fornire uno strumento semplice per la condivisione di informazioni e/o la comunicazione tra più processi (es. pipe).

=== Struttura di un File

Un file è una *sequenza di record logici* (bit, byte, righe, ecc.) il cui significato è definito dal creatore/utente. Questi record logici sono "impaccatta+ti"- in *blocchi fisici*, tutti della stessa dimensione, che sono l'unità di trattamento da parte dell'I/O sul dispositivo di memoria secondaria. La struttura di un file dipende dal suo tipo e deve corrispondere alle aspettative del programma che lo manipolerà.
Alcuni esempi di tipi di file e la loro struttura:
- *Testo*: sequenza di caratteri organizzati in righe e pagine.
- *Programma sorgente*: sequenza di procedure e funzioni.
- *Eseguibile*: sequenza di sezioni di codice che il caricatore può trasferire in memoria principale.

=== Attributi di un File (Metadati)

Ogni file ha degli attributi, o metadati, che ne descrivono le proprietà:
- *Nome*: il nome simbolico utilizzato per riferire il file.
- *Identificatore*: un'etichetta unica che identifica il file all'interno del file system (il nome interno usato dal sistema).
- *Tipo*: necessario per i sistemi che gestiscono tipi diversi di file. Può essere identificato tramite:
  - *Meccanismo delle estensioni* (es. `.exe`, `.txt` in Windows).
  - *Attributo associato al file* (es. programma creatore in macOS).
  - *Magic number* (in UNIX, una sequenza di bit all'inizio del file che ne definisce il formato).
- *Dimensione*: la dimensione corrente del file (in byte, parole o blocchi).
- *Protezione*: informazioni per il controllo delle operazioni sul file (es. lettura, scrittura, esecuzione).
- *Ora, data*: relative a creazione, ultima modifica o ultimo uso, utili per protezione e controllo dell'utilizzo.
- *Proprietario*: in un SO multiutente, indica l'utente proprietario.

#table(
  columns: 3,
  stroke: 0.5pt,
  align: (left, left, left),
  table.header([*Tipo di file*], [*Estensione usuale*], [*Funzione*]),

  [Eseguibile], [exe, com, bin, o nessuna], [Programma, in linguaggio di macchina, eseguibile],

  [Oggetto], [obj, o], [Compilato, in linguaggio di macchina, non collegato],

  [Codice sorgente], [c, cc, java, pas, asm, a], [Codice sorgente in vari linguaggi di programmazione],

  [Batch], [bat, sh], [Comandi all'interprete dei comandi],

  [Testo], [txt, doc], [Testi, documenti],

  [Elaboratore di testi], [wp, tex, rtf, doc], [Vari formati per elaboratori di testi],

  [Libreria], [lib, a, so, dll], [Librerie di procedure per programmatori],

  [Documenti], [ps, pdf, jpeg], [File ASCII o binari in formato per stampa o visione],

  [Archivio],
  [arc, zip, tar],
  [File contenenti più file tra loro correlati, talvolta compressi, per archiviazione o memorizzazione],

  [Multimediali], [mpeg, mov, rm, mp3], [File binari contenenti informazioni audio o A/V],
)

I valori di questi attributi sono immagazzinati in una struttura dati del SO chiamata *descrittore di file* o *FCB (File Control Block)*. In UNIX, i FCB sono chiamati *inode*. Come il file, anche il suo descrittore deve essere persistente e quindi è mantenuto in memoria secondaria. I descrittori dei file appartenenti a una directory sono organizzati tramite la struttura della directory, che risiede sullo stesso dispositivo dei file.

=== Operazioni sui File

I file system tipicamente offrono almeno sei operazioni di base:
- *Creazione*: Il FS reperisce spazio fisico per il file e crea il suo elemento nella directory.
- *Scrittura*: Dato il nome del file e le informazioni da scrivere, il FS ricerca la posizione del file, scrive le informazioni e aggiorna un puntatore alla locazione interna per la successiva operazione.
- *Lettura*: Simile alla scrittura, il FS legge le informazioni dal file e le colloca in memoria.
- *Riposizionamento (seek)*: Il FS cerca l'elemento del file nella directory e assegna un nuovo valore al puntatore interno.
- *Cancellazione*: Il FS ricerca ed elimina l'elemento del file nella directory e rilascia lo spazio fisico occupato.
- *Troncamento*: Il FS azzera la lunghezza del file, rilasciando lo spazio fisico occupato.

Altre operazioni (come copia o ridenominazione) possono essere ottenute combinando quelle di base.Sono inoltre necessarie operazioni per leggere e impostare gli attributi di un file.
Per migliorare l'efficienza, il SO mantiene in memoria principale una *tabella generale dei file aperti* in cui vengono inserite informazioni relative a file che sono attualmente in uso.
Per predisporre la struttura dati precedentemente citata, la maggior parte dei SO richiede che il programmatore apra esplicitamente un file tramite la system call *`open()`* prima di usarlo e lo chiuda con *`close()`* dopo l'uso. Alcuni SO, invece, aprono i file implicitamente al primo riferimento e li chiudono automaticamente alla terminazione del programma.

Le informazioni nelle tabelle dei file aperti sono gestite così:
- *`open()`*: Eseguita prima di ogni operazione sul file. Inserisce nelle tabelle dei file aperti le informazioni sui file su cui il processo invocante vuole operare prelevandole dalla struttura della directory
-*`close()`*: Eseguita come ultima operazione sul file, elimina dalle tabelle dei file aperti le informazioni sui file su cui il processo invocante ha terminato di operare copiando i metadati aggiornati del file nella struttura della directory.

Alcuni SO invece usano *file speciali* che corrispondono a dispositivi di I/O. Sono inclusi nella gerarchia delle directory come qualsiasi altro file, quindi permettono di fare riferimento ad un dispositivo come se fosse un file. Possono essere:
- A *blocchi* (usati per modellare i dischi).
- A *caratteri* (usati per modellare dispositivi di I/O seriali, quali terminali, stampanti, reti).
#figure(image("images/2025-08-17-18-27-08.png"))

== Metodi di accesso

I metodi di accesso stabiliscono le modalità con cui i processi possono accedere ai file. A questo livello di astrazione, i file sono visti come sequenze di record logici (unità di scrittura/lettura) numerati consecutivamente. Sono indipendenti dal tipo di dispositivo e dalla tecnica di allocazione dei blocchi di memoria secondaria. I più diffusi sono:

=== Accesso Sequenziale

I record del file vengono acceduti sequenzialmente, uno dopo l'altro. Il puntatore interno al file è gestito automaticamente dalle operazioni di lettura/scrittura (es. `readnext()`, `writenext()`), ma può essere modificato tramite `seek()`. Questo modello fa riferimento a dispositivi come nastri magnetici e CD-ROM ed è il metodo di accesso più comune, utilizzato da editor di testo e compilatori.
#figure(image("images/2025-08-17-18-36-37.png"))

=== Accesso Diretto

I record logici di cui è composto il file sono numerati tramite un numero relativo rispetto all'inizio del file e sono accessibili indipendentemente e in qualsiasi ordine. Le operazioni sono `readd(f,n,&V)` e `writed(f,n,V)`. Non è necessario mantenere un puntatore interno al file, poiché gli accessi sono indipendenti. Questo modello fa riferimento ai dischi.
Non tutti i SO gestiscono entrambi i tipi di accesso; alcuni richiedono di definire il tipo di accesso al momento della creazione del file.
È facilmente possibile *simulare l'accesso sequenziale su un file ad accesso diretto* mantenendo una variabile `cp` (posizione corrente) che viene incrementata dopo ogni lettura o scrittura, come mostrato nell'esempio:
```
Accesso sequenziale      Realizzazione tramite Accesso diretto
seek(init)               cp = 0
readnext(f,&V)           readd(f,cp,&V); cp = cp+1;
writenext(f,V)           writed(f,cp,V); cp = cp+1;
```
Al contrario, simulare l'accesso diretto su un file sequenziale è piuttosto macchinoso.

=== Accesso tramite Indice

Ogni record logico del file ha una *chiave d'accesso*. Al file è associato un *file indice* che contiene associazioni tra chiavi e puntatori a record logici. Per accedere a un record, si effettua una ricerca nel file indice usando la chiave. Anche qui, non è necessario un puntatore interno al file. Le operazioni sono `readk(f,key,&V)` e `writek(f,key,V)`.
Il vantaggio principale è che la ricerca nel file indice può essere molto più veloce che nel file stesso, poiché il file può essere molto più grande del suo indice, richiedendo molte operazioni di I/O. L'indice, inoltre, può essere mantenuto in memoria principale (o indicizzato a sua volta se troppo grande).
*Esempio di uso di indice*:
#example("Uso di indice")[
  #figure(image("images/2025-08-17-18-53-50.png"))
  Un file indice può mappare un "cognome" a un "numero logico del record", che a sua volta punta al record completo nel file relativo, come illustrato in figura.
]

== File Mappati in Memoria

Un metodo molto utilizzato per accedere ai file sfrutta le tecniche di memoria virtuale per trattare l'I/O dei file dal disco come un normale accesso alla memoria centrale. Normalmente, un accesso a un file richiede l'invocazione di una system call (es. `read()`, `write()`), l'uso di un buffer intermedio e un accesso al disco.

*Mappare un file in memoria* (spesso tramite la system call `mmap()`) significa creare un'associazione tra il file (o una sua porzione) e una sezione dello spazio di indirizzamento virtuale del processo, definita "memoria mappata su file". Questa associazione indica al sistema di memoria virtuale che la copia su disco delle pagine virtuali su cui è mappato il file sono i corrispondenti blocchi del file su disco e non l'area di swap del processo.
Se il SO implementa la memoria virtuale paginata:
1. L'accesso iniziale al file genera un'interruzione di *page-fault*.
2. Una porzione del file delle dimensioni di una pagina viene copiata dal disco in una pagina fisica in memoria centrale.
3. Le successive letture e scritture sul file sono gestite come accessi ordinari alla memoria principale.
Il sistema di memoria virtuale si occuperà di riportare sul file nel disco tutte le modifiche effettuate agli indirizzi di memoria virtuale associati al file, anche se gli aggiornamenti in memoria non si traducono necessariamente in scritture immediate su disco.

=== Vantaggi dei File Mappati in Memoria

I file mappati in memoria offrono diversi vantaggi:
- *Maggiore efficienza delle operazioni di I/O*: È possibile caricare in memoria solo le parti del file effettivamente utilizzate.
- *Notevole semplificazione delle operazioni di I/O*: I dati da trasferire possono essere acceduti direttamente nella sezione di memoria mappata, eliminando la necessità di buffer intermedi.
- *Possibilità di condivisione*: I processi possono mappare lo stesso file in modo concorrente per condividere dati e comunicare. Le scritture di un processo modificano i dati nella memoria virtuale e fisica, rendendoli visibili a tutti gli altri processi che mappano la stessa sezione del file. Può essere supportata anche la funzionalità di *copiatura su scrittura (copy-on-write)*, permettendo ai processi di condividere un file in sola lettura ma di ottenere una propria copia dei dati non appena li modificano.

#figure(image("images/2025-08-17-18-56-32.png"), caption: "Condivisione di file tramite file mappato in memoria")
L'immagine illustra come più processi possano accedere e condividere lo stesso file attraverso la memoria mappata, semplificando la collaborazione.

== La Directory

Una *directory* (o cartella) è un'astrazione che consente di raggruppare più file, paragonabile a un classificatore di documenti. Essa può contenere sia file che altre directory. Anche alle directory, come ai file, è associato un descrittore che ne mantiene gli attributi. Concettualmente, una directory può essere vista come una *tabella di simboli* che traduce nomi di file/directory nei corrispondenti elementi.

=== Operazioni sulle Directory

Dal punto di vista logico, la struttura della directory, indipendentemente dalla sua organizzazione, deve permettere alcune operazioni fondamentali per la gestione del file system:
- *Ricerca di un file*: Scorrere la directory per trovare l'elemento associato a un file specifico.
- *Creazione di un file*: Aggiungere nuovi elementi alla directory.
- *Cancellazione di un file*: Rimuovere elementi dalla directory.
- *Elencazione di una directory*: Elencare i file e il contenuto degli elementi della directory associati a ciascun file.
- *Ridenominazione di un file*.
- *Attraversamento del file system*: Navigare attraverso la struttura logica per accedere a directory o file specifici.

Gli scopi dell'organizzazione logica di una directory includono:
- Efficienza nella ricerca dei file.
- Flessibilità del meccanismo di naming dei file (es. se utenti diversi possono avere file con lo stesso nome, o se un file può avere nomi diversi).
- Possibilità di raggruppare logicamente i file (es. documenti, programmi, giochi).

=== Organizzazione Logica della Directory: Strutture

Esistono diverse strutture logiche per le directory, ciascuna con i propri pro e contro:

==== Directory a Singolo Livello

L'approccio più semplice prevede una *singola directory per tutti i file di tutti gli utenti*.
- *Vantaggi*: Ricerca efficiente se il numero di file è limitato.
- *Svantaggi*: Tutti i file devono avere nomi diversi (problema di naming), non è possibile raggruppare i file logicamente, e presenta limiti notevoli all'aumentare del numero di file o nei sistemi multiutente.
#figure(image("images/2025-08-17-19-01-11.png"))

==== Directory a Due Livelli

Ogni utente ha una *directory separata*.
- *Vantaggi*: Ricerca efficiente, utenti diversi possono avere file con lo stesso nome.
- *Svantaggi*: Nessuna capacità di raggruppamento se non a livello di utente. È necessaria la specifica di un *pathname* per individuare un file.
#figure(image("images/2025-08-17-19-01-27.png"))

==== Directory con Struttura ad Albero

Questa è una struttura più complessa in cui ogni utente ha una directory di lavoro corrente (PWD, *present working directory*) da cui viene fatta la ricerca dei file.
- *Vantaggi*: Ricerca efficiente, *ottime capacità di raggruppamento*.
- *Naming*: Il nome di un file/directory è il suo pathname, che può essere:
  - *Assoluto*: Dalla radice (es. `/usr/ast/mailbox`).
  - *Relativo*: Dalla PWD (es. `mailbox` se la PWD è `/usr/ast`).
  Il comando UNIX `cp /usr/ast/mailbox /usr/ast/mailbox.bak` e `cp mailbox mailbox.bak` hanno lo stesso effetto se la PWD è `/usr/ast`.
#figure(image("images/2025-08-17-19-03-22.png"))
Le operazioni come la creazione di un nuovo file vengono eseguite relativamente alla directory corrente (`rm <nome-file>`, `mkdir <dir-name>`).

==== Directory con struttura a grafo aciclico (DAG)
Rispetto alla struttura ad albero, può essere utile permettere l'aggiunta di “archi” per dare la possibilità di “vedere” lo stesso file da due o più directory diverse (cioè, dare più nomi ad uno stesso file).
- *Vantaggi*: Permette la *condivisione di sottodirectory e file*. Si possono avere due o più pathname assoluti (alias) per uno stesso file, ma non ci possono essere due file con lo stesso pathname.
- *Differenze Albero vs. DAG*:
  - *Albero*: ogni file è contenuto in un'unica directory.
  - *DAG*: un file può essere contenuto in una o più directory (es. `count`). Esiste un'unica copia del file, quindi ogni modifica è visibile in tutte le directory che lo contengono.
#figure(image("images/2025-08-17-19-05-26.png"))

=== Condivisione e Collegamenti/Link

La condivisione di file e sottodirectory può essere realizzata in vari modi. Un metodo comune è la creazione di un nuovo tipo di elemento di directory chiamato *collegamento* (in Windows) o *link simbolico* (in UNIX). È in pratica un puntatore indiretto a un file o sottodirectory e può essere realizzato come nome di percorso assoluto o relativo.
Quando si fa riferimento a un file, il SO ricerca nella directory. Se l'elemento individuato è un collegamento, il nome del file reale è incluso nell'elemento stesso e viene usato per localizzare il file (questa procedura è detta "risolvere il collegamento").
Durante l'esplorazione di un file system, non si dovrebbe considerare più volte la stessa porzione condivisa (per motivi di correttezza, efficienza, statistica). Una soluzione è che il SO ignori i collegamenti durante l'attraversamento delle directory.

==== Problemi di Cancellazione con Alias

Quando si cancella un file che ha degli alias, si pone il problema di quando recuperare la memoria assegnata al file:
- Se lo si fa subito, si rischia di lasciare collegamenti "pendenti" (puntatori a risorse inesistenti).
- *Soluzioni*:
  - Elencare i collegamenti per cancellarli tutti (inconveniente: l'elenco può richiedere molto spazio).
  - Usare un *contatore dei riferimenti*: la memoria viene recuperata solo quando il contatore è azzerato.
  - Per evitare problemi, alcuni sistemi semplicemente non consentono la condivisione di directory o l'uso di collegamenti.

==== DAG: Problemi Legati all'Aliasing (Cicli)

Se in una directory con struttura a DAG si aggiungono collegamenti, per evitare la creazione di cicli (e mantenere il grafo un DAG), si dovrebbe:
- Consentire solo collegamenti a file e non a sottodirectory, oppure
- Utilizzare preventivamente un algoritmo di controllo dei cicli, che è computazionalmente oneroso, soprattutto quando il grafo si trova in memoria secondaria.
Per la massima flessibilità, si può consentire la presenza di cicli, ma poi bisogna gestirne i problemi.

==== Directory con Struttura a Grafo Generico

Se in una directory ad albero si aggiungono collegamenti in modo arbitrario, la struttura si trasforma in un grafo generico, che può contenere cicli.
#figure(image("images/2025-08-17-19-12-34.png"))
- La *ricerca di un file/directory è complicata*: Bisogna implementare l'algoritmo di ricerca in modo da evitare di esplorare ciclicamente la stessa porzione (es. limitando arbitrariamente il numero di directory da accedere).
- Un algoritmo più semplice prevede di *non percorrere mai i collegamenti* durante l'attraversamento delle directory (come nei DAG), evitando così cicli nell'esplorazione senza costi computazionali aggiuntivi.

==== Cancellazione e Garbage Collection in Grafi Generici

La "cancellazione di un file e recupero della memoria assegnata" può richiedere l'applicazione di un algoritmo di *garbage collection (ripulitura)* per stabilire quando l'ultimo riferimento a un file è stato eliminato. Questo perché il contatore dei riferimenti a un file potrebbe non essere nullo pur non essendo più possibile accedere al file, a causa di anomalie come cicli o autoreferenzialità nella struttura delle directory.
La garbage collection richiede due attraversamenti del file system:
1. Un primo attraversamento per contrassegnare tutto ciò che è accessibile.
2. Un secondo attraversamento per raccogliere in un elenco di blocchi liberi tutto ciò che non è contrassegnato.
La garbage collection per un file system basato su disco richiede molto tempo e viene quindi effettuata di rado.

== Protezione dei File

La *protezione* riguarda l'uso illegale o le interferenze operate da utenti/programmi sotto il controllo del SO (cioè autenticati). I meccanismi di protezione svolgono un duplice ruolo:
- *Rappresentazione delle politiche*: Realizzazione delle strutture dati che contengono la specifica dei vincoli di accesso alle risorse.
- *Controllo degli accessi*: Verifica che ogni accesso a una risorsa da parte di un processo sia conforme alla politica di protezione specificata.
Il proprietario/creatore di un file dovrebbe essere in grado di controllare "cosa può essere fatto" e "chi può farlo". L'accesso a un file/directory dovrebbe essere permesso o negato sulla base dell'*identificativo dell'utente (autenticazione)* e del *tipo di accesso (autorizzazione)*.

=== Autenticazione

L'*autenticazione* ha l'obiettivo di verificare la veridicità dell'identità degli utenti o dei processi. Normalmente, un utente si identifica presentando una credenziale (es. ID utente), e l'autenticazione è la procedura con cui il sistema ne stabilisce la validità.
Si basa tipicamente su uno o più dei seguenti metodi:
- *Qualcosa che l'individuo conosce*: password, PIN, risposte a domande.
- *Qualcosa (token) che l'individuo possiede*: smartcard, chiave elettronica.
- *Qualcosa che l'individuo è (biometria statica)*: impronta digitale, retina, viso.
- *Qualcosa che l'individuo fa (biometria dinamica)*: schema vocale, grafia, ritmo di battitura.
Una volta completata l'autenticazione, l'identità dell'utente deve essere protetta, poiché altre parti del sistema si baseranno su di essa. Dopo il login, l'ID utente è associato a ogni processo eseguito con quel login, memorizzato nel PCB e ereditato dai processi figli.

=== Autorizzazione

L'*autorizzazione* ha l'obiettivo di determinare quali utenti possono eseguire quali operazioni su quali risorse.
I tipi di operazioni di base sono:
- Lettura
- Scrittura
- Esecuzione
- Cancellazione
- Elencazione (degli attributi)
Operazioni di livello superiore come copia o ridenominazione sono realizzate componendo le operazioni di base, quindi è sufficiente garantire la protezione a livello delle operazioni di base.

=== 9.3. Matrice di Protezione

La *matrice di protezione* specifica le politiche di protezione dei file/directory e, in generale, delle risorse. Concettualmente, ogni riga corrisponde a un *dominio di protezione (utente)*, e ogni colonna rappresenta una *risorsa del sistema*. Le celle contengono i diritti di accesso.

L'uso della matrice di protezione è solo concettuale, poiché in pratica comporterebbe costi elevati per lo spreco di memoria, essendo solitamente enorme e sparsa. I due approcci più comuni per rappresentare concretamente le politiche di protezione sono le *Liste di Capability (C-list)* e le *Liste di Controllo degli Accessi (ACL)*.

=== Liste di Capability (C-list)

Ad ogni processo (P) il sistema associa una *lista di capability*, cioè una lista di file/directory (o risorse in generale) insieme con le operazioni permesse su quelle risorse. Questa lista rappresenta una riga della matrice di protezione.
#figure(image("images/2025-08-17-23-49-05.png"))

Una risorsa è tipicamente rappresentata dal suo nome fisico o indirizzo.
Le capability agiscono anche come nomi per le risorse: un utente/processo non può nemmeno nominare una risorsa che non è riferita da una capability nella sua C-list. Per eseguire un'operazione su una risorsa, il processo invoca l'operazione specificando la capability per la risorsa come parametro, e il semplice possesso della capability indica che l'operazione è autorizzata.
Le C-list offrono una *maggiore efficienza nel controllo degli accessi* rispetto alle ACL, poiché la ricerca dei diritti è effettuata localmente al processo. Tuttavia, operazioni come la revoca di tutti i diritti di accesso associati a una risorsa sono costose, richiedendo la ricerca e l'aggiornamento di tutte le C-list.
Sono un meccanismo flessibile, ma è problematico gestire liste di utenti non note o che cambiano dinamicamente. Inoltre, il descrittore di file/directory deve essere di dimensione variabile, a meno di soluzioni particolari come quella di UNIX.

=== Liste di Controllo degli Accessi (ACL)

Ad ogni file/directory (o risorsa in generale) il sistema associa una *ACL*, la quale, per ogni utente, specifica le operazioni che quell'utente è autorizzato a compiere sul file/directory. Questa lista rappresenta una colonna della matrice di protezione e può contenere anche un insieme di operazioni autorizzate di default.
#figure(image("images/2025-08-17-23-49-47.png"))

Molti sistemi usano una versione condensata delle ACL, come *UNIX*, che distingue *3 classi di utenti* e *3 modalità di accesso*:
- *Classi di utenti*:
  - *Proprietario*: l'utente che ha creato il file.
  - *Gruppo*: un gruppo di utenti che condividono il file e necessitano di accesso simile.
  - *Universo*: tutti gli altri utenti del sistema.
- *Modalità di accesso*:
  - Lettura (r)
  - Scrittura (w)
  - Esecuzione (x)
L'amministratore di sistema può creare utenti e gruppi e cambiare il proprietario (`chown`). Il proprietario può cambiare i diritti dei file (`chmod 761 file`) per sé, per il gruppo e per gli altri utenti, e può cambiare il gruppo di un file (`chgrp`). I diritti sono codificati tramite 3 cifre ottali, ad esempio, `761` significa `rwx` per il proprietario (7 = 111 binario), `rw-` per gli utenti del gruppo (6 = 110 binario), e `--x` per tutti gli altri (1 = 001 binario).

=== Protezione delle Operazioni sulle Directory

In una struttura della directory a più livelli è necessario proteggere non solo i singoli file ma anche gruppi di file nelle sottodirectory. Se un nome di percorso fa riferimento a un file in una directory, è necessario consentire all'utente di accedere sia alla directory che al file.
Le operazioni sulle directory che devono essere protette sono diverse dalle operazioni sui file:
- Elencare il contenuto di una directory (utile per controllare se un utente può determinare l'esistenza di un file).
- Creare e cancellare file in una directory.
- Attraversare una directory per accedere ai file e alle sottodirectory in essa contenute.
Nei sistemi in cui i file possono avere numerosi nomi di percorso (come DAG e grafi generici), un utente può disporre di diritti di accesso diversi a un determinato file, a seconda del nome di percorso utilizzato.

In UNIX, la protezione delle directory è gestita in maniera simile alla protezione dei file, con proprietario, gruppo e universo, ciascuno con i tre bit `rwx`:
- L'impostazione del bit `r` permette a un utente di elencare il contenuto di una directory (e degli attributi dei file).
- L'impostazione del bit `w` permette a un utente di creare e cancellare file e altre sottodirectory in una directory. *Non sono i permessi su un file a determinare se esso può essere cancellato, ma sono i permessi sulla directory che lo contiene a farlo*.
- L'impostazione del bit `x` permette a un utente di attraversare una directory per accedere ai file e alle sottodirectory in esse contenute (ma non elencarne il contenuto, per il quale serve il bit `r`).

=== ACL vs. Liste di Capability

La maggior parte dei sistemi usa una *combinazione di ACL e liste di capability*.
- Quando un processo tenta per la prima volta di accedere a una risorsa, il SO controlla l'autorizzazione nella corrispondente ACL.
  - Se l'accesso è negato, solleva un'eccezione.
  - Altrimenti, crea una capability e la collega al processo.
- Quando arrivano richieste successive di operazioni sul file, il SO usa la capability per verificare rapidamente se l'accesso è permesso.
- Dopo l'ultimo accesso, il SO rimuove la capability.

Un esempio di questa strategia è la *protezione dei file in UNIX*:
- Ogni file ha una ACL associata.
- Quando un processo apre un file, il SO cerca il file nella directory, controlla i permessi e, se l'accesso è permesso, alloca i buffer per l'I/O.
- Queste informazioni sono registrate in un nuovo elemento nella tabella dei file associata al processo, e l'operazione restituisce un indice a questa tabella per il file appena aperto.
- Tutte le successive operazioni sul file avvengono specificando tale indice, che punta al file e ai suoi buffer.
- Quando un processo chiude un file, l'elemento della tabella dei file viene cancellato.
La protezione è assicurata poiché il diritto di accesso viene controllato *al momento dell'apertura di un file e ad ogni accesso successivo*. L'elemento della tabella dei file contiene una capability solo per le operazioni permesse. Se un file è aperto in sola lettura, una capability per l'accesso in lettura è posta nell'elemento della tabella dei file; un tentativo di scrittura sarà identificato come violazione. Inoltre, la tabella dei file è mantenuta dal SO, quindi i processi non possono alterarla accidentalmente e possono accedere solo ai file che sono stati aperti.

== Condivisione dei File

La condivisione dei file richiede meccanismi di protezione (come il controllo degli accessi) e l'uso di specifici attributi dei file/directory. La maggior parte dei sistemi si basa sui concetti di *proprietario* e *gruppo*:
- *Proprietario*: l'utente che ha il massimo controllo sul file, può modificarne gli attributi e definire le operazioni consentite agli altri utenti.
- *Gruppo*: un sottoinsieme di utenti autorizzati a condividere l'accesso al file.
Gli ID del proprietario e del gruppo di un file/directory sono memorizzati insieme agli altri attributi. Quando un utente richiede un'operazione, il suo ID viene confrontato con gli attributi di proprietario o gruppo per determinare i permessi applicabili.

Nei sistemi con più file system locali, la verifica degli ID e dei permessi è semplice una volta che i file system sono "montati". Nel caso di un disco portatile spostato tra sistemi diversi, è necessario assicurarsi che gli ID corrispondano o che la proprietà dei file venga resettata (es. creando un nuovo ID utente e impostando la proprietà di tutti i file a quell'ID).
Nei sistemi distribuiti, i file possono essere condivisi tramite la rete di comunicazione sottostante. Un esempio è il *Network File System (NFS)*, un protocollo di rete sviluppato da Sun Microsystems (1984) che permette ai computer di accedere a dischi remoti come se fossero locali. Sebbene associato principalmente ai sistemi Unix, NFS è usato anche su macchine Windows. Il termine "network file system" è ora usato genericamente per indicare un file system in grado di gestire dispositivi di memorizzazione remoti.

//TODO: suddividere in Interfaccia del File System e in Realizzazione del file system
== Realizzazione del File System

Come qualsiasi software complesso, il file system deve essere strutturato opportunamente per facilitarne lo sviluppo, la manutenzione e il riuso. È solitamente organizzato in *livelli*, con ogni livello che si serve delle funzioni dei livelli inferiori per crearne di nuove impiegate ai livelli superiori. Questo approccio è utile per separare i livelli dipendenti dall'hardware da quelli indipendenti, e per ridurre la complessità e la ridondanza del codice, sebbene possa aggiungere overhead al SO e causare un decadimento delle prestazioni.

=== Livelli di Astrazione

I quattro livelli tipici del file system sono (dall'alto verso il basso):
- *Applicazioni*
- *File system logico*
- *Modulo di organizzazione dei file*
- *File system di base*
- *Controllo dell'I/O*
- *Hardware: memoria secondaria*

Dettagli su ciascun livello:
- *Controllo dell'I/O*: Costituito dai driver dei dispositivi e dai gestori delle interruzioni. Si occupa del trasferimento delle informazioni tra memoria centrale e memoria secondaria, un blocco per volta. Si appoggia direttamente sull'hardware e presenta una vista astratta del dispositivo come un vettore lineare di blocchi fisici di uguale dimensione (es. blocco su disco magnetico identificato da indirizzo numerico). Il driver trasforma comandi di alto livello (es. "Recupera blocco X") in istruzioni di basso livello dipendenti dall'hardware per il controllore del dispositivo.
- *File system di base*: Invia comandi al driver di dispositivo per leggere e scrivere blocchi fisici. Gestisce i buffer di memoria per il trasferimento dei dati e le cache per i metadati del file system usati più di frequente, per migliorare le prestazioni.
- *Modulo di organizzazione dei file*: Conosce il metodo di allocazione dei file e la locazione dei file nei blocchi fisici del disco. Traduce gli indirizzi dei record logici in indirizzi di blocchi fisici, che poi il file system di base si occupa di far trasferire. Gestisce anche la lista dei blocchi fisici liberi.
- *File system logico*: Fornisce ai processi e agli utenti una visione astratta delle informazioni su disco (basata su file, directory, partizioni, volumi), che prescinde dalle caratteristiche del dispositivo e dalle tecniche di allocazione e accesso. Realizza le operazioni di gestione di file e directory (creazione, cancellazione, spostamento) rendendole disponibili tramite system call. Gestisce tutte le strutture dati per l'implementazione del file system (directory, FCB), ma non il contenuto dei file. È responsabile del controllo degli accessi (meccanismi di protezione).

=== Operazioni del File System

La realizzazione delle operazioni del file system richiede diverse strutture dati, memorizzate sia sui dischi che in memoria principale. Normalmente, le strutture dati si trovano su disco, ma alcune informazioni vengono portate in memoria principale per la gestione del file system e per migliorare le prestazioni. Vengono caricate in memoria al montaggio del file system o all'apertura/creazione di file/directory, aggiornate durante le operazioni e rimosse allo smontaggio o alla chiusura/cancellazione.

==== Strutture Dati su Disco

- *Secondary boot sector (Boot control block)*: Primo blocco di una partizione, contiene informazioni su come avviare un SO.
- *Partition/volume control block (volume index, device directory, superblocco)*: Contiene informazioni sulla partizione/volume, come numero e dimensione dei blocchi, posizione dei blocchi liberi e dei FCB liberi.
- *Struttura della directory*: Tabella i cui elementi associano nomi di file/sottodirectory a FCB. Una per file system.
- *FCB (File control block o inode UNIX)*: Mantengono i valori degli attributi dei singoli file e informazioni sull'allocazione dei blocchi su disco.
#figure(image("images/2025-08-18-00-02-33.png"), caption: "Tipico File Control Block")

==== Strutture Dati in Memoria

- *Tabella di montaggio*: Contiene informazioni su ciascuna partizione/volume montata.
- *Cache della struttura della directory*: Contiene informazioni su file/directory acceduti più di recente.
- *Tabella generale dei file aperti*: Contiene copie dei FCB dei file aperti e informazioni sui processi che accedono a ciascun file.
- *Tabelle dei file aperti per ciascun processo*: Per ciascun file aperto dal processo, contiene un puntatore all'elemento corrispondente della tabella generale e altre info specifiche del processo (es. capability).
- *Vari buffer*: Conservano i blocchi letti/scritti di recente.

Le tabelle dei file aperti di ciascun zprocesso memorizzano informazioni sull'utilizzo dei file da parte del processo, come il valore corrente del puntatore interno al file e i diritti di accesso. Ogni elemento in questa tabella punta a sua volta alla tabella dei file aperti del sistema, che contiene informazioni indipendenti dal processo (posizione dei file su disco, dimensioni, date di accesso) e un *contatore delle aperture*, che tiene traccia del numero di processi che hanno invocato `open()` senza ancora `close()`.

#example("Creazione di un Nuovo File")[
  Per creare un nuovo file (o directory), un processo si rivolge al file system logico. Questo, conoscendo il formato della struttura della directory, crea e alloca un nuovo FCB (o ne alloca uno libero se tutti i FCB sono creati all'avvio del file system). Il sistema carica in memoria la directory appropriata, la aggiorna con il nome del nuovo file e il FCB associato, e la riscrive sul disco.
]

#example("System Call `open()`")[
  Vediamo come vengono utilizzate le strutture dati quando viene invocata una `open(pathname, oflags)`:
  - `pathname` è il nome del file.
  - `oflags` indica la modalità di accesso (es. `create`, `read-only`, `read-write`). Questa modalità viene controllata rispetto alle autorizzazioni sul file. Il file viene aperto solo se la modalità è consentita.
  Il SO controlla la tabella generale dei file aperti per vedere se il file è già in uso.
  - Se sì: incrementa il contatore delle aperture associato al file e aggiunge alla tabella dei file aperti del processo richiedente un elemento che punta al corrispondente elemento della tabella generale.
  - Se no: cerca il nome del file nella struttura della directory. Una volta trovato, copia il relativo FCB in un nuovo elemento della tabella generale dei file aperti (con contatore delle aperture a 1). Aggiunge un elemento alla tabella dei file aperti del processo che punta ad esso (includendo un puntatore alla posizione corrente nel file e la modalità di accesso).
  Alla fine, restituisce un *indice* (file descriptor `fd`) alla tabella dei file aperti del processo, cosicché tutte le successive operazioni sul file avverranno tramite tale indice.
  #figure(image("images/2025-08-18-00-08-54.png"))
  L'immagine illustra il percorso di un'operazione `open()`, mostrando come il file descriptor `fd` punti attraverso le tabelle in memoria al descrittore del file e alla sua allocazione su disco.
]

#example("System Call `close()`")[
  La system call `close()` esegue i seguenti passi:
  - Rimuove l'elemento dalla tabella dei file aperti del processo il cui indice è l'argomento della `close()`.
  - Decrementa il contatore delle aperture dell'elemento riferito nella tabella generale dei file aperti.
  - Se il contatore delle aperture si azzera (file non più in uso):
    - Copia tutti i metadati aggiornati del file nella struttura della directory sul disco.
    - Elimina l'elemento corrispondente nella tabella generale dei file aperti.
  - Se necessario, copia il contenuto aggiornato del file in memoria secondaria.
]


In generale, una system call sui file attraversa i diversi livelli del file system, partendo dal livello logico fino al driver, che si occupa di far svolgere al controllore del disco le operazioni necessarie a soddisfare la richiesta.

== Realizzazione delle Directory

La funzione principale della struttura della directory è mappare il nome ASCII di un file nelle informazioni necessarie per localizzare i dati. Ogni directory necessita di un collegamento con i descrittori dei file che contiene, e il problema è dove memorizzare questi descrittori.
Alcuni SO (es. Windows) realizzano le directory come file speciali con contenuto strutturato: una tabella i cui elementi contengono nome, attributi e informazioni sull'allocazione dei blocchi del file su disco.
#figure(table(
  columns: (auto, auto, auto),

  [#strong("Nome")], [#strong("Attributi")], [#strong("Allocazione file su disco")],
  [d1], [...], [inizio = Blocco 30],
  [d2], [...], [inizio = Blocco 43],
  [f1], [...], [inizio = Blocco 110],
  [...], [...], [...],
  stroke: 1pt,
  inset: 5pt,
  align: center,
))
Tuttavia, memorizzare direttamente i descrittori (FCB) negli elementi della directory crea problemi per l'implementazione dei link e la condivisione dei file.

Per implementare più convenientemente i link, è preferibile tenere attributi e informazioni sull'allocazione in una struttura separata (es. *inode UNIX*). In questo modello, ogni elemento di directory punta all'inode (unico) del file/sottodirectory. L'uso di un *contatore (inserito nell'inode)* facilita la cancellazione di un file con più pathname: la cancellazione effettiva avviene solo quando il contatore si azzera; altrimenti, viene solo eliminato il pathname e decrementato il contatore.

#figure(image("images/2025-08-18-00-12-59.png"))
L'immagine illustra questo concetto, mostrando due nomi di file (`f2`, `f2bis`) che puntano allo stesso inode (`inode 15`), che contiene gli attributi, l'allocazione su disco e un `*Contatore link*` che in questo caso è `2`.

#example("Ricerca del file `/usr/ast/mbox` in UNIX")[
  #figure(image("images/2025-08-18-00-14-09.png"))
  L'immagine mostra i passi per la ricerca di un file con pathname assoluto in un file system UNIX, che utilizza gli inode:
  1. Si parte dalla *root directory `/`* e si cerca l'indice dell'inode corrispondente a `usr`, si trova il valore `6`.
  2. Si accede l'*inode `6`* e si trova che la tabella di directory corrispondente a `/usr` si trova nel *blocco dati `132`*.
  3. Si accede il *blocco `132`* che contiene la tabella di directory e si trova l'indice `26` dell'inode corrispondente a `ast`.
  4. Si accede l'*inode `26`* e si trova che la tabella di directory corrispondente a `/ast` si trova nel *blocco dati `406`*.
  5. Si accede il *blocco `406`* che contiene la tabella di directory e si trova l'indice `60` dell'inode corrispondente a `mbox`.
  6. Infine, si accede l'*inode `60`* che corrisponde al file `/usr/ast/mbox`.
  Questo processo dimostra come gli inode e i blocchi dati delle directory siano collegati per permettere la navigazione del file system.
]

=== Organizzazione delle Tabelle delle Directory

Le tabelle delle directory possono essere organizzate in due schemi principali:
- *Lista lineare di elementi*: Semplice da programmare, ma l'efficienza delle operazioni può essere bassa (creazione e cancellazione richiedono ricerche esaustive con costo lineare). Se la lista è mantenuta ordinata, si riduce il tempo di ricerca ma si allunga quello di creazione/cancellazione.
- *Tabella hash*: Il nome del file è usato per calcolare un valore hash. Gli elementi della directory con lo stesso valore hash sono mantenuti in una lista lineare. Si usano tabelle con un numero fisso di elementi. Questo velocizza la ricerca e semplifica creazione/cancellazione, ma l'amministrazione è più complessa (indicato per directory con centinaia o migliaia di file).

== Montaggio di un File System (Mounting)

Così come bisogna aprire un file prima di usarlo, un file system deve essere *montato* prima di poter essere reso accessibile ai processi e agli utenti di un sistema. Questa operazione è necessaria per costruire la struttura della directory, specialmente perché un file system può essere composto da file system che risiedono su volumi differenti. Un volume è un dispositivo virtuale che corrisponde a una partizione o a un gruppo di partizioni, anche di dispositivi fisici diversi. Questi volumi devono essere montati (raggruppati in un'unica struttura gerarchica) per essere disponibili nello spazio dei nomi del file system.

Almeno un file system, il *root file system* (tipicamente associato a un disco rigido permanente), deve essere presente all'avvio del SO per permettere il montaggio degli altri file system.
L'operazione di montaggio richiede di specificare:
- Il nome del volume da montare.
- Il *punto di montaggio (mount point)*, ovvero la locazione che occuperà nel file system esistente.
- Il tipo di file system contenuto nel volume (alcuni SO lo ricavano automaticamente).
Il SO verifica che il volume contenga un file system valido leggendo la directory di dispositivo (o indice del volume) tramite il driver e controllando il formato. Infine, il SO annota nella sua struttura della directory che un certo file system è montato nel punto specificato, consentendo di attraversare la struttura della directory passando anche tra file system di tipo diverso.
Il montaggio può essere effettuato automaticamente dal SO (es. Windows, macOS) o esplicitamente dall'utente (es. UNIX, Linux).

=== Montaggio in macOS e Windows

- *macOS*: Quando rileva un disco per la prima volta (all'avvio o in esecuzione), cerca un file system, lo monta automaticamente nella directory `/Volumes` e aggiunge un'icona sul desktop etichettata con il nome del file system.
- *Windows*: I sistemi Windows rilevano e montano automaticamente tutti i file system all'avvio. Mantengono una struttura della directory a due livelli estesa, associando una lettera di unità a dispositivi e volumi. Il percorso completo di un file è `lettera_di_unità:\percorso\file`. Le versioni recenti consentono anche di montare un file system in qualsiasi punto dell'albero delle directory, come UNIX.

=== Montaggio in UNIX

In SO come UNIX, i comandi di montaggio sono espliciti. Un file di configurazione del sistema contiene un elenco di dispositivi e punti di montaggio per il montaggio automatico all'avvio, ma altri montaggi possono essere eseguiti manualmente. In UNIX, il montaggio può avvenire in qualsiasi directory.
Viene implementato impostando un flag nella copia in memoria dell'inode della directory di montaggio, indicando che è un punto di montaggio. Un campo dell'inode punta a un elemento della tabella di montaggio, che contiene un puntatore al superblocco del file system montato.

#figure(image("images/2025-08-18-00-17-15.png"))
L'immagine illustra come un volume contenente le home directory degli utenti (b) possa essere montato nella directory `/users` del file system esistente (a), rendendo accessibile una struttura come `/users/gianna`.
#figure(image("images/2025-08-18-00-17-40.png"))

=== Smontaggio di un File System (Unmounting)

Lo smontaggio è l'operazione opposta al montaggio: stacca un file system dal suo punto di montaggio, riversando eventualmente il contenuto dei buffer del kernel sul volume. È cruciale smontare un dispositivo prima di estrarlo fisicamente, poiché le scritture su un file system sono spesso eseguite in blocco al momento più favorevole (buffering). Estrarre un dispositivo senza smontarlo può causare la corruzione dei dati.

== Metodi di Allocazione dei File

L'hardware e il driver del disco forniscono accesso al disco visto come un vettore lineare di blocchi di dimensione fissa. I *metodi di allocazione dei file* scelgono i blocchi del disco da utilizzare per ciascun file, li collegano assieme per formare una struttura unica e stabiliscono una corrispondenza tra i record logici contenuti nei file e i blocchi del disco.
Gli obiettivi sono l'uso efficiente dello spazio su disco e un rapido accesso ai file. I metodi più diffusi sono:
- Allocazione contigua
- Allocazione concatenata
- Allocazione indicizzata

Indicheremo con `Nb` il numero di record logici contenuti in un blocco. Il record logico `i` di un file si trova nel blocco (logico) `⌊i/Nb⌋` del file.

=== Allocazione Contigua

Ogni file occupa un certo numero di *blocchi contigui su disco*. La porzione allocata a un file è definita dall'indirizzo `B` del blocco iniziale e dal numero di blocchi, informazioni mantenute nel FCB. L'indirizzo del blocco in cui si trova il record logico `i` è `B + ⌊i/Nb⌋`.

#figure(image("images/2025-08-18-12-58-17.png"))

- *Vantaggi*: Basso costo della ricerca di un blocco, accesso sequenziale e diretto efficienti, alte prestazioni (basta la ricerca del primo blocco per leggere l'intero file).
- *Svantaggi*:
  - *Frammentazione esterna*: Man mano che il disco si riempie, rimangono zone contigue sempre più piccole, a volte inutilizzabili, richiedendo compattazione o deframmentazione.
  - Necessità di specificare la dimensione finale di un file al momento della sua creazione.
  - Costo elevato della ricerca dello spazio libero per l'allocazione di un nuovo file (possono essere usati algoritmi di allocazione dinamica della memoria principale come best-fit, first-fit, worst-fit).
  - Limiti sulle dimensioni dei file.

#figure(image("images/2025-08-18-12-58-36.png"))
L'*immagine (a)* mostra l'allocazione contigua dello spazio del disco per sette file.
L'*immagine (b)* illustra lo stato del disco dopo la cancellazione dei file D e F, evidenziando la frammentazione esterna.

Moderni SO utilizzano spesso uno schema di allocazione contigua modificato chiamato *estensione (extents)*. Quando un file viene creato, gli viene inizialmente allocata una porzione contigua; se non è sufficiente, viene allocata un'altra porzione contigua (un'estensione). In generale, un file è allocato in una o più estensioni.

=== Allocazione Concatenata

I blocchi di un file sono organizzati in una *lista concatenata*. Ogni blocco contiene al suo interno (tipicamente in posizione iniziale) un puntatore al blocco successivo. Le informazioni da mantenere nel FCB sono il puntatore al primo blocco e il numero di blocchi (o il puntatore all'ultimo blocco). Per determinare l'indirizzo del blocco `⌊i/Nb⌋` in cui si trova il record logico `i`, è necessario scorrere tutti i blocchi che lo precedono a partire da quello iniziale del file.
#figure(image("images/2025-08-18-13-00-31.png"))

- *Vantaggi*: Accesso sequenziale o in modalità 'append' efficienti. Non c'è frammentazione esterna, i blocchi possono essere sparsi. Non è necessario dichiarare preventivamente le dimensioni dei file. Basso costo di ricerca dello spazio libero per nuova allocazione o espansione.
- *Svantaggi*: Accesso diretto e ricerca di un blocco richiedono molte operazioni di I/O. Bassa efficienza (il puntatore occupa spazio nel blocco, riducendo la quantità di dati). Spazio richiesto dai puntatori (alcuni sistemi allocano cluster di blocchi consecutivi per risparmiare spazio).
  - *Scarsa robustezza*: Se un link viene danneggiato, non è più possibile accedere ai blocchi successivi. Soluzioni includono liste a doppi puntatori o l'uso di una Tabella di Allocazione dei File (FAT).

#figure(image("images/2025-08-18-13-00-55.png"))
L'immagine illustra come un file possa essere memorizzato come una lista concatenata di blocchi disco.

==== Tabella di Allocazione dei File (FAT)

Il metodo *FAT (File Allocation Table)*, usato inizialmente da MS-DOS e poi da OS/2 e Windows, è una struttura dati tabellare che descrive la mappa di allocazione di tutti i blocchi. Contiene un elemento per ogni blocco del volume, il cui valore indica se il blocco è libero oppure, se occupato, contiene l'indice dell'elemento della tabella corrispondente al blocco successivo (o un valore speciale per indicare che è l'ultimo blocco di un file).
La FAT è memorizzata in un'area predefinita del volume (a volte in duplice copia) e memorizza le informazioni sulla lista concatenata in un'unica area di memoria contigua, permettendo ai blocchi dati dei file di non contenere puntatori.

#figure(image("images/2025-08-18-13-01-49.png"))

- *FAT16*: MS/DOS usava indirizzi a 16 bit, limitando il volume a 2^16 blocchi. Con blocchi di 32 KB, il volume massimo era di 2 GB. Per volumi più grandi, si doveva aumentare la dimensione dei blocchi, aumentando la frammentazione interna.
- *FAT32*: Ha risolto il problema con indirizzi a 32 bit, permettendo volumi fino a 8 TB (con blocchi da 32 KB, sebbene il numero massimo di blocchi sia 2^28). La dimensione massima dei file è circa 4 GB (limitata dal campo "lunghezza file" nel FCB, di 4 byte).

- *Vantaggi FAT*: Aumenta la robustezza (rispetto alla linked list semplice), i blocchi dati sono interamente dedicati ai dati, può velocizzare l'accesso ai file tramite copia in memoria principale (l'accesso diretto a un blocco `n` costa `n-1` accessi in memoria e 1 su disco).
- *Svantaggi FAT*: L'intera tabella deve essere mantenuta in memoria principale, rendendola inefficiente per dischi di grandi dimensioni. Ad esempio, un disco da 1 TB con blocchi da 1 KB richiederebbe una FAT di almeno 4 GB in memoria principale.

=== Allocazione Indicizzata

A ogni file è associata una *tabella indice*, di dimensione prestabilita, in cui sono contenuti gli indirizzi dei blocchi del file. Tutti gli indici dei blocchi sono raggruppati in una sola locazione. L'indirizzo del blocco `⌊i/Nb⌋` (in cui si trova il record logico `i`) è contenuto nell'elemento `⌊i/Nb⌋`-esimo della tabella indice. L'elemento della directory relativo a un file contiene l'indirizzo del blocco contenente la tabella indice del file.

#figure(image("images/2025-08-18-13-02-28.png"))

- *Vantaggi*: Gli stessi dell'allocazione a lista concatenata, più la possibilità di accesso diretto e maggiore velocità di accesso.
- *Svantaggi*: Richiede memoria per il blocco indice, scarso utilizzo dei blocchi indice per file di piccole dimensioni, overhead per l'accesso al blocco indice, e le dimensioni del blocco indice limitano le dimensioni del file.

==== Mappatura

Il limite di dimensione del blocco indice può limitare le dimensioni dei file (es. con un blocco di 512 parole, si possono indirizzare 512 blocchi, per un max file di 1 MB). Per ovviare a questa restrizione, i SO usano vari metodi:
- *Liste concatenate di blocchi indice*: Un indirizzo nel blocco indice punta a un blocco indice successivo.
- *Più livelli di indice (gerarchie ad albero)*: Se i blocchi sono di 4096 byte, un singolo blocco può memorizzare 1024 puntatori. Un solo livello di indice supporta file fino a 4 MB. Un doppio livello di indice può arrivare a 4 GB.
  #figure(image("images/2025-08-18-13-03-14.png"))
  La Figura illustra questa struttura gerarchica, con un indice esterno che punta a tabelle indice del file.
- *Schema combinato (inode UNIX)*: Utilizza un metodo basato su 3 livelli di indirezione.
  #figure(image("images/2025-08-18-13-03-55.png"))
  La *Figura* mostra la struttura di un inode UNIX, che include:
  - *12 blocchi diretti*: puntano direttamente ai blocchi dati del file.
  - *Indirizzo 13*: punta a un blocco che contiene indirizzi di blocchi dati del file (singola indirezione).
  - *Indirizzo 14*: doppia indirezione.
  - *Indirizzo 15*: tripla indirezione.
Questo schema gestisce efficientemente i file piccoli penalizzando gradualmente l'accesso a file grandi. La dimensione massima dei file dipende dalla dimensione dei blocchi e dei loro indirizzi (es. con blocchi da 1024 byte e indirizzi da 4 byte, un file può raggiungere circa 8 GB). L'occupazione di memoria è contenuta poiché un inode deve essere in memoria solo quando il file corrispondente è aperto, rendendo questo approccio molto meno dispendioso in termini di RAM rispetto alla FAT per volumi grandi.

=== Riepilogo Metodi di Allocazione

In sintesi, gli obiettivi dei metodi di allocazione sono l'uso efficiente dello spazio su disco e un rapido accesso ai file. Alcuni SO adottano più metodi di allocazione a seconda delle caratteristiche del file:
- *Contigua*: se l'accesso è diretto o il file è relativamente piccolo.
- *Concatenata*: se il file è di grandi dimensioni e l'accesso è sequenziale.
- *Indicizzata*: se il file è di grandi dimensioni e l'accesso è diretto.

== Gestione dello Spazio Libero

Il SO mantiene una *lista dei blocchi liberi* allocabili per i dati dei file. Questa lista è normalmente mantenuta in memoria secondaria per evitare che vada persa a seguito di arresti anomali del sistema. Ci sono due metodi principali per gestirla:

=== Vettore di Bit (Bitmap)

Si usa un *vettore di bit* con tanti elementi quanti sono i blocchi del disco. Un bit `bit[i] = 1` indica che il `blocco[i]` è libero, mentre `0` indica che è occupato.

#figure(image("images/2025-08-18-13-05-36.png"))

- *Vantaggi*: Semplicità nel determinare il primo blocco libero o `n` blocchi liberi consecutivi. Alcuni processori forniscono istruzioni specifiche per queste ricerche.
- *Svantaggi*: Efficiente solo se il vettore di bit è caricato in memoria centrale. Richiede spazio extra (es. 1 TB di disco con blocchi da 4KB richiede un vettore di bit di 32 MB). È un'organizzazione ragionevole per dischi di dimensioni non elevate.

=== Lista Concatenata di Blocchi del Disco

I blocchi liberi sono collegati l'uno all'altro. È sufficiente memorizzare il puntatore al primo blocco. Tuttavia, è difficile trovare blocchi liberi contigui, a meno che la lista non sia mantenuta ordinata.

#figure(image("images/2025-08-18-13-06-11.png"))

==== Varianti della Lista Concatenata

- *Conteggio*: Ogni blocco mantiene il numero di blocchi liberi consecutivi che lo seguono e l'indirizzo del primo blocco libero successivo a questi.
- *Raggruppamento*: Il primo blocco libero memorizza gli indirizzi di altri `n` blocchi liberi. I primi `n-1` blocchi sono effettivamente liberi, e l'`n`-esimo blocco contiene gli indirizzi di altri `n` blocchi liberi, e così via. Questo permette di trovare rapidamente gli indirizzi di un certo numero di blocchi liberi.

#figure(image("images/2025-08-18-13-06-41.png"), caption: "Raggruppamento vs. Bitmap")

==== Considerazioni su Raggruppamento & Bitmap

- *Raggruppamento*: È sufficiente tenere in memoria solo un blocco di puntatori. Conviene che tale blocco sia "mezzo" pieno per gestire efficientemente (senza bisogno di accedere al disco) sia le richieste di blocchi liberi (per creazione/espansione di file) sia la liberazione di blocchi (in seguito alla cancellazione).
- *Bitmap*: È semplice reperire un certo numero di blocchi liberi contigui. Date le dimensioni, anche la bitmap va suddivisa in blocchi. È sufficiente tenere in memoria solo un blocco della bitmap e accedere al disco per leggerne un altro quando quello in memoria non è sufficiente.

== Efficienza e Prestazioni del File System

I dischi tendono ad essere il *principale collo di bottiglia* per le prestazioni di un sistema di elaborazione, essendo i più lenti tra i componenti rilevanti. Ad esempio, leggere una parola di 32 bit dalla memoria principale richiede circa 10ns, mentre una lettura da un disco fisso può avvenire a 100 MB/s, ma a questo si aggiunge il tempo di ricerca della traccia (5-10 ms) e l'attesa che il settore desiderato si posizioni. Se la richiesta è di una singola parola, l'accesso alla memoria è dell'ordine di un milione di volte più veloce dell'accesso al disco.

Vari fattori influenzano l'uso efficiente del disco:
1. Algoritmi per l'allocazione dei blocchi e la gestione dei blocchi liberi.
2. Tipo di informazioni in un elemento di directory o in un FCB.
3. Pianificazione degli effetti provocati dal cambiamento della tecnologia.

=== Algoritmi per Allocazione e Gestione Spazio Libero

Gli algoritmi per l'allocazione e la gestione dei blocchi liberi possono ottimizzare le prestazioni. Ad esempio, per ridurre il tempo di ricerca della traccia su cui sono posizionati i blocchi dati, UNIX cerca di mantenere i blocchi con i dati di un file vicini al blocco che ne contiene l'inode.
#figure(image("images/2025-08-18-13-08-05.png"))
La Figura mostra che posizionare gli inode vicini ai blocchi dati dei relativi file dimezza il tempo medio di ricerca rispetto al caso in cui gli inode siano tutti all'inizio del disco.

=== Informazioni in Elementi di Directory o FCB

Il tipo di informazioni mantenute nei metadati può influenzare l'efficienza. Ad esempio, mantenere aggiornate le date di ultima scrittura o ultimo accesso di un file richiede la lettura del blocco dei metadati in memoria, la modifica e la riscrittura su disco ogni volta che il file viene scritto/letto. Questo può essere inefficiente per file cui si accede frequentemente. Quindi, nella progettazione del file system, è cruciale considerare l'influenza di ogni informazione associata ai file sull'efficienza e sulle prestazioni.

La scelta della dimensione dei puntatori è un compromesso tra la lunghezza massima dei file e lo spazio richiesto per memorizzare i puntatori. Puntatori a 16 o 32 bit limitano la lunghezza dei file (64 KB o 4 GB). Puntatori a 64 bit richiedono più spazio, aumentando l'overhead dei metodi di allocazione e gestione dello spazio libero. Il file system ZFS di Sun adotta puntatori di 128 bit, che in teoria non dovrebbero mai necessitare di un'estensione.

=== Effetti del Cambiamento della Tecnologia

I file system devono adattarsi ai cambiamenti tecnologici. Ad esempio, il file system di MS-DOS, originariamente limitato a 32 MB, ha dovuto evolversi da FAT16 a FAT32 per gestire dischi più grandi.
Un altro esempio è Solaris di Sun Microsystems: inizialmente molte strutture dati del kernel (come le tabelle dei processi e dei file aperti) avevano lunghezza fissa e venivano assegnate all'avvio del sistema. Una volta riempite, non si potevano creare nuovi processi o aprire nuovi file senza ricompilare il kernel e riavviare. Da Solaris 2 in poi, quasi tutte le strutture dati del kernel sono assegnate e rilasciate dinamicamente, eliminando questi limiti artificiali, ma con il costo di algoritmi più complessi e un SO potenzialmente più lento.

=== Ottimizzazioni per le Prestazioni

Per migliorare le prestazioni, molti file system sono stati progettati con diverse ottimizzazioni:
- Uso di memorie cache (cache del controllore, buffer/disk/block cache).
- Scritture sincrone/asincrone.
- Accesso e allocazione dei file.
- Riduzione del movimento del braccio del disco.
- Deframmentazione dei dischi.

==== Cache del Controllore e Buffer Cache

- *Cache del controllore*: Alcuni controllori di unità disco contengono una memoria locale sufficiente a memorizzare intere tracce. Qualunque richiesta di lettura di un blocco causa la lettura di quel blocco e di buona parte della traccia su cui si trova. Questa cache è indipendente dalla cache del SO.
- *Buffer cache (o disk/block cache)*: È una sezione della memoria centrale del kernel, gestita come una cache hardware ma dal SO. È la tecnica più usata per ridurre i tempi di accesso al disco. Contiene i blocchi del disco che il SO si aspetta verranno riutilizzati a breve. Un blocco dati viene letto dal disco solo la prima volta e poi mantenuto nel buffer cache. Le successive letture sono velocizzate.
  Quando un processo utente invia una richiesta di lettura, il SO cerca i dati nelbuffer cache. Se li trova, la richiesta è soddisfatta senza accedere aldispositivo fisico, il che è probabile perché il SO copia intere sequenze diblocchi di dati dal disco. Il SO esegue anche *read-ahead* di blocchi, leggendodati successivi a quelli richiesti, basandosi sul presupposto che la maggiorparte dei file sono acceduti sequenzialmente, rendendo i successivi accessi moltopiù rapidi dalla cache.

==== Scrittura di un Blocco nella Cache

Inserire nel buffer cache i dati da scrivere su disco è vantaggioso:
- I dati scritti vengono spesso riletti (es. un programma sorgente viene salvato e poi letto dal compilatore).
- Consente di effettuare più aggiornamenti in memoria piuttosto che accedere al disco ogni volta.
- Eseguendo le operazioni di scrittura su disco in background, l'esecuzione del programma corrente non viene rallentata.
Tipicamente, circa l'85% dell'I/O dal disco può essere evitato usando un buffer cache.

#figure(image("images/2025-08-18-13-10-28.png"))
La *Figura* mostra le strutture dati del buffer cache, con una tabella hash per una ricerca veloce basata su dispositivo e indirizzo del blocco, e una lista bidirezionale (LRU/MRU) per la gestione dei blocchi.

==== Sostituzione di Blocchi nella Cache

In caso di riempimento della cache, si possono impiegare gli stessi algoritmi di sostituzione usati dalla gestione della memoria virtuale per la sostituzione delle pagine (es. LRU - Least Recently Used). Dato che i tempi di accesso al disco sono più lunghi, è possibile implementare l'algoritmo LRU in modo esatto. Tuttavia, LRU non è sempre il metodo migliore; ad esempio, le pagine relative a un file acceduto sequenzialmente non dovrebbero essere sostituite in ordine LRU, poiché la pagina usata più di recente sarà acceduta nuovamente per ultima.

==== Scritture Sincrone/Asincrone

Quando un blocco nella cache viene modificato, la scrittura su disco può avvenire in due modi:
- *Scrittura sincrona*: La modifica viene immediatamente riportata su disco. Le scritture avvengono nell'ordine necessario. È *sicura*, i dati non andranno persi in caso di crash. Le scritture dei metadati (tabelle di directory, descrittori di file) dovrebbero essere sincrone. È *lenta*, i processi devono attendere il completamento delle operazioni di I/O. Potrebbe essere non necessaria per piccole modifiche o file temporanei.
- *Scrittura asincrona*: Le modifiche non sono riportate immediatamente su disco. Il sistema attende (es. 30 secondi) nel caso ci siano ulteriori modifiche o il blocco venga cancellato. È *veloce*, le scritture restituiscono il controllo immediatamente al processo invocante. È *pericolosa*, può causare perdita di dati in caso di crash o estrazione del disco prima che i dati siano scritti permanentemente. Se si tratta di metadati, il file system può rimanere in uno stato inconsistente.

=== Accesso e Allocazione dei File

Il metodo di accesso ai file può influenzare le prestazioni:
- L'accesso sequenziale può essere ottimizzato con tecniche come *Read-ahead* (legge e inserisce nella cache il blocco richiesto e alcuni successivi) e *Free-behind* (rimuove un blocco del file non appena viene richiesto il successivo).
Anche il metodo usato per allocare i blocchi dei file influenza le prestazioni:
- Un programma che legge un file allocato in modo contiguo genererà richieste raggruppate, con limitato spostamento del braccio del disco.
- Un file con allocazione concatenata o indicizzata, invece, potrebbe avere blocchi sparsi, richiedendo un maggiore spostamento del braccio.

=== Riduzione del Movimento del Braccio del Disco

Per grandi quantità di dati, la scrittura su disco tramite il file system è spesso più veloce della lettura. Quando i dati devono essere scritti, i blocchi sono memorizzati nella cache come buffer, e il driver ordina la lista delle operazioni in base all'indirizzo sul disco. Questo minimizza gli spostamenti del braccio del disco e ottimizza i tempi di rotazione. Quindi, a meno di scritture sincrone, un processo scrive nella cache, e il sistema trasferisce i dati sul disco in modo asincrono, facendo percepire le scritture come rapidissime. Nelle letture, la read-ahead aiuta, ma le scritture traggono maggiore beneficio dalla modalità asincrona.

==== Dischi a Stato Solido (SSD)

I movimenti del braccio del disco e il tempo di rotazione sono critici per i dischi magnetici, ma non per i *dischi a stato solido (SSD)*, che non hanno parti in movimento. Costruiti con tecnologia flash, gli SSD hanno accesso diretto rapido come quello sequenziale e tempi di lettura/scrittura notevolmente inferiori ai dischi tradizionali. Molti dei problemi legati ai dischi tradizionali spariscono, ma gli SSD soffrono dell'inconveniente che ciascun blocco può essere scritto solo un certo numero di volte; il SO deve quindi prestare attenzione per garantire un "consumo" uniforme del disco.

=== Deframmentazione dei Dischi

Un miglioramento delle prestazioni si ottiene anche spostando i file su disco per far sì che occupino blocchi contigui e mettendo la maggior parte dello spazio libero in una o più grandi zone (operazione di *deframmentazione*). Gli SSD non soffrono di problemi di frammentazione; anzi, la deframmentazione ne ridurrebbe il ciclo di vita.
