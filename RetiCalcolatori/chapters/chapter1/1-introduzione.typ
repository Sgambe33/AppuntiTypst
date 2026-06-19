#import "../../../dvd.typ": *

= Introduzione

== Topologia

Una rete è un'infrastruttura di nodi che connettono altri nodi. La topologia di una rete può essere rappresentata come un grafo (orientato o non orientato). Un vertice rappresenta un elemento passivo o attivo della rete mentre un arco rappresenta qualcosa che connette due vertici.

La struttura di una rete può essere analizzata sotto diversi punti di vista:

- *Topologia fisica*: come sono connessi fisicamente i dispositivi (cavi, fibra, collegamenti radio). Riguarda l'hardware. In questo caso i cavi rappresentano gli archi e le estremità dei cavi i vertici.
- *Topologia IP (Logica)*: come fluiscono i dati attraverso la rete basandosi sull'indirizzamento IP e le decisioni di routing. Non sempre rispecchia la topologia fisica. In questo cavo ogni dispositivo con un indirizzo IP è un nodo.
- *Topologia application-level*: come comunicano le applicazioni (es. reti Overlay, P2P, CDN). Ogni applicazione è un vertice.

// TODO: mancherebbe parte su circuit-switching, packet-switching!

== Internet 101
Le idee alla base di Internet si diffusero intorno agli anni sessanta. Non è stato creato dal nulla, ma costruito passo dopo passo. Sebbene finanziato inizialmente dal Dipartimento della Difesa USA (progetto ARPANET), il suo sviluppo è stato guidato principalmente dai centri di ricerca nazionali e universitari.

Nonostante l'ambizione del progetto, il successo è dovuto a una combinazione di fattori chiave:

- *Economico*: basato su standard aperti e gratuiti. Non c'era bisogno di pagare royalties per implementare i protocolli (a differenza di tecnologie proprietarie dell'epoca).
- *Tecnico*:
  - *Packet Switching*: maggiore resilienza e utilizzo efficiente della banda rispetto alla commutazione di circuito.
  - *Principio End-to-End*: la rete è "stupida" (si occupa solo di spostare pacchetti) e l'intelligenza è ai bordi (negli host).
  - *Best Effort*: la rete tenta di consegnare i pacchetti, ma non garantisce affidabilità assoluta (gestita dai livelli superiori, es. TCP).
- *Facilità d'uso (per l'epoca)*: pensato "da sviluppatori per sviluppatori", permettendo una rapida innovazione.
- *Politico*: le compagnie di telecomunicazioni tradizionali (es. SIP in Italia, AT&T in USA) negli anni '60-'70 si concentrarono sulla telefonia vocale (commutazione di circuito), sottovalutando la trasmissione dati e lasciando campo libero alla ricerca accademica.

#definition("Internet")[
  Internet *non* è una singola rete fisica. È l'*inter-connessione* logica di un enorme numero di reti eterogenee.
]

=== Caratteristiche fondamentali
- *Stack TCP/IP*: internet si basa su questa suite di protocolli. Attenzione: non è composta *solo* da TCP e IP, ma include molti altri protocolli essenziali come UDP, ICMP (diagnostica), ARP (risoluzione indirizzi), OSPF/BGP (routing).
- *Standardizzazione (IETF & RFC)*:
  - La standardizzazione è gestita dalla *IETF* (Internet Engineering Task Force).
  - I protocolli sono definiti nei documenti *RFC* (Request For Comments). Se un protocollo diventa standard, la sua RFC diventa la specifica di riferimento.
- *Indipendenza dal mezzo fisico*: il TCP/IP è *agnostico* rispetto alla tecnologia sottostante. Funziona indifferentemente su WiFi, Ethernet, fibra ottica, collegamenti satellitari, ecc.
- *Decentralizzazione*: e' un insieme di *Sistemi Autonomi* (AS) interconnessi senza un'autorità centrale che controlli tutto il traffico.

#figure(image("images/2026-06-18-22-44-22.png", width: 60%))

Le connessioni tra i sistemi autonomi possono sembrare disorganizzate ("a ragnatela") perché frutto di accordi privati tra le parti. Ogni collegamento rappresenta un *peering agreement* (scambio traffico alla pari) o un *transit agreement* (scambio a pagamento).

La struttura si divide generalmente in:
- *Edge systems*: le reti periferiche (utenti, campus, aziende, ISP).
- *Core systems*: la spina dorsale (Backbone) che trasporta grandi moli di dati.

=== Gestione e Indirizzamento
Il mondo è suddiviso in zone geografiche gestite dai *RIR* (Regional Internet Registries, come RIPE per l'Europa), che si occupano dell'assegnazione dei blocchi di indirizzi IP e dei numeri di AS.

== Definizioni e concetti chiave

#definition("Subnet")[
  Una sottorete (Subnet) è un segmento di una rete identificato dalla coppia {Network Address, Subnet Mask}. E' buona pratica che tra due subnet differenti sia presente un router.
]

#definition("Autonomous System (AS)")[
  An AS is a management concept.\ _Within the Internet, an autonomous system (AS) is a collection of connected Internet Protocol (IP) routing prefixes under the control of one or more network operators that presents a common, clearly defined routing policy to the Internet (cf. RFC 1930, Section 3)._
]

In una rete possiamo distinguere tre categorie principali di dispositivi:

1. *Host (L7)*: I dispositivi finali (End Systems) dove risiedono le applicazioni (client e server). Sono l'origine e la destinazione del traffico. Sono identificati univocamente da indirizzi IP.
2. *Router/Gateway (L3 o L7)*: Dispositivi intermedi, usati principalmente per indirizzare i pacchetti. Hanno bisogno di un'interfaccia IP per ogni subnet a cui sono connessi.

All'interno di una rete, un host sorgente, generalmente:
+ Crea un pacchetto indirizzato a un host destinatario.
+ Controlla se la destinazione è nella stessa subnet del mittente.
  - Se sì, usa il meccanismo specifico della subnet per raggiungere il destinatario.
  - Se no, invia il pacchetto ad un router appropriato nella sua subnet.
+ La rete sottostante fa il resto del lavoro.

Un *router* controlla l'indirizzo IP di destinazione e "indovina" la subnet di destinazione.
+ Se la destinazione è in una subnet connessa direttamente al router, il pacchetto viene inviato direttamente.
+ Altrimenti, cerca il prossimo router a cui inviare il pacchetto.

== Incapsulamento e layers
Come sempre, per semplificare i problemi, si è deciso di suddividere il problema principale in problemi più piccoli. In questo caso si parla di *layer* della rete. Ogni layer offre i propri servizi al layer soprastante e fa uso dei servizi del layer sottostante. I layer interagiscono tra loro mediante *SAP* (Service Access Point), l'equivalente delle *API* (Application Programming Interface).
#figure(image("images/2026-06-18-23-14-33.png"))
Ogni layer aggiunge i propri dati in un *header* e opzionalmente in un *trailer*. Ciò permette di realizzare l'*incapsulamento*.
#figure(image("images/2026-06-18-23-19-10.png"))

== Stack ISO/OSI
#figure(image("images/2026-06-18-23-21-56.png"))
// TODO: piazzare di lato
Il modello ISO/OSI è formato da 7 livelli. E' bene conoscerlo ma di fatto non è usato. Applica alcuni concetti fondamentali come:
- *Separazione della responsabilità*: le funzionalità non sono duplicate.
- *Information hiding*: l'implementazione effettiva viene nascosta, viene esposta solo l'interfaccia.

I layer L1-L3 sono detti *Media Layers* mentre i L4-L7 sono detti *Host Layers*.

#figure(image("images/2026-06-18-23-22-23.png"))

I dati vengono scambiati tra nodi adiacenti e i nodi intermedi non dovrebbero processare le informazioni finali (a meno che non si tratti di Proxy o Gateways)-

== Stack TCP/IP
Lo stack TPC/IP è molto più semplice dell'ISO/OSI.
#figure(image("images/2026-06-18-23-25-56.png"))
- L7 Livello Application: composto dai protocolli applicativi come ftp, smtp, http, etc...
- L7 Livello Transport: composto dai protocolli per il trasferimento dei dati end-to-end come TCP, UDP, QUICK, etc...
- L3 Livello Network: composto dai protocolli per il routing sorgente-destinazione come IP, ICMP, ARP, RARP, etc...
- L2 Livello Data Link: composto dai protocolli per le comunicazioni locali come PPP, ethernet, etc...

== Indirizzi
Verranno trattate tre tipologie di indirizzi:
- Indirizzi MAC
- Indirizzi numerici: necessari per il routing e seguono una struttura dettata dalla rete a cui si è connessi.
- Indirizzi alfanumerici: ad esempio quelli dei siti web.

#observation()[
  #figure(image("images/2026-06-18-23-30-30.png"))
]

Agli albori di Internet, gli indirizzi IP erano divisi rigidamente in *classi* predefinite (A, B, C), spezzando l'indirizzo in due blocchi fissi: `Net_Id` (identificativo della rete) e `Host_Id` (identificativo del dispositivo). Questo sistema gerarchico si è rivelato rapidamente inefficiente, portando alla creazione di tabelle di routing gigantesche.

#figure(image("images/2026-06-19-10-40-55.png"))

La soluzione definitiva è stata l'introduzione del *CIDR* (Classless Inter-Domain Routing). Il CIDR elimina le vecchie classi e introduce una notazione flessibile basata su una barra (es. `150.217.8.0/24`), permettendo di accorpare e unificare blocchi di indirizzi adiacenti. In questo modo non c'è più una rigida distinzione tra la rete e la sottorete (Subnet), ottimizzando drasticamente la gestione degli indirizzi.

Per capire dove inviare un pacchetto, i sistemi consultano una Tabella di Routing che mappa le destinazioni attraverso gateway e interfacce specifiche.

#figure(image("images/2026-06-19-10-41-09.png"))

Per trovare la rotta corretta, il sistema applica un'operazione logica per verificare se l'IP di destinazione combacia con le reti conosciute: verifica che `DestIP && RTMask == RTDestIP`. Poiché un pacchetto potrebbe teoricamente soddisfare più regole contemporaneamente (ad esempio una rotta generica e una specifica), il sistema applica la regola del *Maximum Matching Entry* (o Longest Prefix Match): tra tutte le rotte compatibili, vince quella con il maggior numero di bit a 1 nella sua maschera di sottorete (Genmask). In parole povere, il pacchetto viene sempre instradato seguendo il percorso in assoluto più specifico che il router conosce.

= Protocolli?
Il protocollo DNS, se osserviamo lo stack TCP/IP o il modello ISO/OSI, risiede sopra il livello di trasporto, quindi è un livello applicativo. Ma attenzione non viene utilizzato come il protocollo HTTP o SMTP, il DNS è al servizio di altre applicazioni, pertanto è un protocollo livello 7 anomalo. Questo riconferma che i due modelli sono utili solo dal punto di vista teorico in quanto nella realtà è tutta un'altra storia.

== HTTP
Il protocollo *HTTP* (HyperText Transfer Protocol) è l'archetipo dei sistemi REST (Representational State Transfer). Nasce per il web e utilizza messaggi divisi, similmente alle email, in Header (che dichiara cosa c'è nel messaggio e cosa farne) e Body (il contenuto).

Per capire l'HTTP, bisogna prima fare un passo indietro all'FTP (File Transfer Protocol). L'FTP (che oggi è insicuro) partiva dal presupposto che si stesse trasferendo un file da un file system. Ma un computer non deve per forza avere un file system logico-gerarchico. Se si interroga un sensore IoT per sapere la temperatura, non si sta leggendo un "file", si sta accedendo a una risorsa.

=== URI
Ecco perché si usano gli *URI* (Uniform Resource Identifier). Un URI identifica una risorsa, indipendentemente da come è memorizzata fisicamente. La struttura tipica di un URI è:

`Schema://Authority/Path?Query#Fragment`
- `Schema`: il protocollo (http, https, ftp, mailto...).
- `Authority`: il server/host a cui ci rivolgiamo.
- `Path`: il percorso logico della risorsa.
- `Query`/`Fragment`: parametri addizionali.

=== GET e POST
HTTP mette a disposizione due metodi principali, ne esistono altri, per interagire con un server: `POST` e `GET`. La differenza è importante:
- `GET`: serve per leggere o interrogare. Non dovrebbe mai modificare lo stato del server. I parametri passano nell'URI.
- `POST`: serve per inviare dati e modificare lo stato del server (es. aggiungere un record in un database o inviare un form). I parametri passano nel Body

=== Versioni
Esistono, ad oggi, 4 versioni del protocollo HTTP:
- *HTTP 1.0*: era stateless e connectionless. Si apriva la connessione, si mandava la richiesta, si riceveva la pagina HTML e la connessione si chiudeva. Quando le pagine web hanno iniziato a riempirsi di immagini, questo sistema è diventato lentissimo: bisognava aprire e chiudere una connessione per ogni singolo asset.

- *HTTP 1.1*: introduce le connessioni persistenti. Si apre la connessione, si riceve la pagina, si mantiene la connessione aperta per scaricare subito gli altri asset (immagini, script) dallo stesso server e poi si chiude.

- *HTTP/2*: migliora ulteriormente la gestione delle richieste parallele (multiplexing).

- *HTTP/3*: fino all'HTTP/2, il livello di trasporto sottostante era il TCP (eventualmente con uno strato TLS per l'HTTPS). L'HTTP/3 abbandona il TCP e utilizza QUIC (basato su UDP), cambiando radicalmente l'infrastruttura di trasporto sottostante per abbattere i tempi di latenza.

#observation()[
  L'HTTP nativamente non ha memoria delle sessioni. Per non dover rifare il login a ogni click, sono stati introdotti i Cookies, che mantengono lo stato della sessione ma, al contempo, permettono il tracciamento inter-dominio degli utenti per scopi di privacy/pubblicità.
]

== Email
L'email nasce prima ancora del web. La sua architettura deriva dalle vecchie BBS (Bulletin Board Systems) degli anni '70/'80, a cui ci si collegava tramite modem telefonici. Se l'utente A (su BBS-1) doveva scrivere all'utente B (su BBS-2), il messaggio veniva messo in coda. Di notte, la BBS-1 telefonava alla BBS-2 per scaricare e consegnare i messaggi.

Ciò ha influenzato pesantemente i protocolli oggi utilizzati:
- *SMTP* (Simple Mail Transfer Protocol): usato per inviare la posta in uscita (push). Lo usa il client per mandare l'email al server, e lo usano i server per passarsela tra loro.

- *IMAP* o *POP3*: usato dal destinatario per leggere la posta (pull). Visto che il destinatario non è sempre connesso, deve essere lui a interrogare il proprio server per chiedere se sono presenti nuovi messaggi.

#observation("PEC")[
  Il protocollo email standard non è nato per garantire consegne o integrità. La PEC cerca di risolvere questo problema, ma la sicurezza si basa sull'affidabilità dell'infrastruttura dei server che ospitano le caselle, non solo sulla crittografia della comunicazione.
]

== DNS
Il DNS è un protocollo alla base del web moderno, senza di esso si fermerebbe internet.
#definition()[
  Il DNS è semplicemente un database distribuito, ridondato e ad alta disponibilità. Se un server non sa rispondere ad una richiesta, tramite gerarchie, deleghe e cache sarà in grado di recuperare la risposta.
]
Non serve, attenzione, soltanto per comodità ovvero per evitare di memorizzare gli indirizzi IP dei vari siti piuttosto che il loro nome (google.com invece di 142.250.184.195). Serve per il *Virtual Hosting* e per il *Cloud/Load Balancing*. Oggi, su un singolo indirizzo IP possono essere ospitati migliaia di siti web diversi. Quando viene effettuata una richiesta HTTP, inserite il nome del sito nell'header. Se il DNS non esistesse e usaste solo l'IP, il server di destinazione non saprebbe quale dei migliaia di siti (virtual host) si vuole visitare.

= Socket
Nella storia di Internet, l'introduzione delle socket ha rappresentato una vera e propria rivoluzione culturale. Sono state inventate a Berkeley, in concomitanza con lo sviluppo dei sistemi UNIX. Il parallelismo geniale alla base delle socket era legato all'hardware dell'epoca (negli anni '70 non c'erano i dischi rigidi moderni, ma si usavano molto i nastri magnetici). Per scrivere su un nastro si usava una `write` sequenziale, e per leggere si usava una `read` sequenziale. Le socket usano esattamente la stessa semantica: per trasmettere dati usi una `send` (o una scrittura sequenziale), e per riceverli usi una `receive` (una lettura che va a riempire un blocco di memoria).

== Blocking vs Non-Blocking
La prima grande complicazione nello sviluppo di reti riguarda il comportamento del programma quando tenta di leggere o scrivere dati. Esistono due tipi principali di socket:

- Socket Bloccanti: come suggerisce il nome, inviando o richiedendo la lettura di dati, il programma si "blocca" su quell'istruzione e non passa alla successiva finché i dati non sono stati scritti tutti, non sono stati ricevuti a sufficienza, o non scade un timeout. Sono più semplici da usare: basta controllare il codice di errore o il numero di byte restituiti.

- Socket Non Bloccanti: i dati da inviare sono passati al sistema operativo e il programma continua immediatamente la sua esecuzione. In fase di lettura, la socket restituisce subito i dati se sono già disponibili; altrimenti, istruisce il sistema operativo a mandare una notifica (callback) quando i dati arriveranno.

== Struttura

Aprendo il terminale (su Linux/Mac) e digitando `man socket`, è possibile  trovare la documentazione per creare una socket in C (ma i concetti si applicano a Python, Java, Rust, ecc.). La funzione principale richiede tre parametri:

#align(center, `int socket(int domain, int type, int protocol);`)

+ Dominio (Domain): indica la famiglia di protocolli. I più comuni sono:

  - `AF_INET` per IPv4.

  - `AF_INET6` per IPv6.

  - `AF_UNIX` (o `AF_LOCAL`) per le comunicazioni interne allo stesso computer, senza usare lo stack di rete.

  #observation()[
    Il fatto che un'applicazione debba scegliere esplicitamente tra IPv4 e IPv6 è tecnicamente una violazione del principio di "information hiding", ma attualmente è così che funziona
  ]

+ Tipo (Type): indica la modalità di comunicazione. I due tipi principali sono:

  - `SOCK_STREAM`: garantisce un flusso continuo di byte. Sotto il cofano si mappa tipicamente sul protocollo TCP. Si possono scrivere o leggere i byte un po' alla volta (1 byte, 10 byte o un giga). Sarà l'applicazione a dover capire dove inizia e finisce logicamente un messaggio.

  - `SOCK_DGRAM` (Datagram): orientato ai messaggi. Sotto il cofano si mappa tipicamente sull'UDP. Se si manda un pacchetto di 10 byte, il ricevente deve leggerli tutti e 10 insieme; se ne legge di meno, gli altri vanno persi.

  Ci sono anche tipi speciali come `SOCK_RAW`, che permette di bypassare i livelli alti e creare pacchetti a mano (packet injection), utile per la cybersecurity o lo sviluppo di basso livello.

+ Protocollo (Protocol): generalmente si imposta a `0`, delegando al sistema operativo la scelta del protocollo di default per quel dominio e quel tipo. Lo si specifica solo se si vogliono forzare protocolli particolari.

Questa funzione restituisce un numero intero. Se l'intero è negativo, significa che c'è stato un errore (es. dominio non supportato, permessi mancanti). Se l'intero è positivo, rappresenta l'ID della socket. Il kernel dei sistemi operativi Unix/Linux è scritto in C, che è un linguaggio procedurale. Ecco perché la funzione non restituisce un "oggetto socket", ma un semplice numero identificativo (un file descriptor), che verrà usato come fosse il riferimento a quell'oggetto per tutte le operazioni successive.
