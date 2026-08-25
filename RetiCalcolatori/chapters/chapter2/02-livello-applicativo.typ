#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

#pagebreak()

= Livello Applicativo
#observation()[
  Il protocollo DNS, se osserviamo lo stack TCP/IP o il modello ISO/OSI, risiede sopra il livello di trasporto, quindi è un livello applicativo. Ma attenzione non viene utilizzato come il protocollo HTTP o SMTP, il DNS è al servizio di altre applicazioni, pertanto è un protocollo livello 7 anomalo. Questo riconferma che i due modelli sono utili solo dal punto di vista teorico in quanto nella realtà è tutta un'altra storia.
]


== HTTP
Il protocollo *HTTP*#index[HTTP] (HyperText Transfer Protocol) è l'archetipo dei sistemi REST (Representational State Transfer). Nasce per il web e utilizza messaggi divisi, similmente alle email, in Header (che dichiara cosa c'è nel messaggio e cosa farne) e Body (il contenuto).

Per capire l'HTTP, bisogna prima fare un passo indietro all'FTP (File Transfer Protocol). L'FTP (che oggi è insicuro) partiva dal presupposto che si stesse trasferendo un file da un file system. Ma un computer non deve per forza avere un file system logico-gerarchico. Se si interroga un sensore IoT per sapere la temperatura, non si sta leggendo un "file", si sta accedendo a una risorsa.

=== URI
Ecco perché si usano gli *URI*#index[URI] (Uniform Resource Identifier). Un URI identifica una risorsa, indipendentemente da come è memorizzata fisicamente. La struttura tipica di un URI è:

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
- *HTTP 1.0*#index[HTTP 1.0]: era stateless e connectionless. Si apriva la connessione, si mandava la richiesta, si riceveva la pagina HTML e la connessione si chiudeva. Quando le pagine web hanno iniziato a riempirsi di immagini, questo sistema è diventato lentissimo: bisognava aprire e chiudere una connessione per ogni singolo asset.

- *HTTP 1.1*#index[HTTP 1.1]: introduce le connessioni persistenti. Si apre la connessione, si riceve la pagina, si mantiene la connessione aperta per scaricare subito gli altri asset (immagini, script) dallo stesso server e poi si chiude.

- *HTTP/2*#index[HTTP/2]: migliora ulteriormente la gestione delle richieste parallele (multiplexing).

- *HTTP/3*#index[HTTP/3]: fino all'HTTP/2, il livello di trasporto sottostante era il TCP (eventualmente con uno strato TLS per l'HTTPS). L'HTTP/3 abbandona il TCP e utilizza QUIC (basato su UDP), cambiando radicalmente l'infrastruttura di trasporto sottostante per abbattere i tempi di latenza.

#observation()[
  L'HTTP nativamente non ha memoria delle sessioni. Per non dover rifare il login a ogni click, sono stati introdotti i Cookies, che mantengono lo stato della sessione ma, al contempo, permettono il tracciamento inter-dominio degli utenti per scopi di privacy/pubblicità.
]

== Email
L'email nasce prima ancora del web. La sua architettura deriva dalle vecchie BBS (Bulletin Board Systems) degli anni '70/'80, a cui ci si collegava tramite modem telefonici. Se l'utente A (su BBS-1) doveva scrivere all'utente B (su BBS-2), il messaggio veniva messo in coda. Di notte, la BBS-1 telefonava alla BBS-2 per scaricare e consegnare i messaggi.

Ciò ha influenzato pesantemente i protocolli oggi utilizzati:
- *SMTP*#index[SMTP] (Simple Mail Transfer Protocol): usato per inviare la posta in uscita (push). Lo usa il client per mandare l'email al server, e lo usano i server per passarsela tra loro.

- *IMAP*#index[IMAP] o *POP3*#index[POP3]: usato dal destinatario per leggere la posta (pull). Visto che il destinatario non è sempre connesso, deve essere lui a interrogare il proprio server per chiedere se sono presenti nuovi messaggi.

#figure(image("images/2026-07-02-17-51-39.png", width: 60%))

#observation("PEC")[
  Il protocollo email standard non è nato per garantire consegne o integrità. La PEC cerca di risolvere questo problema, ma la sicurezza si basa sull'affidabilità dell'infrastruttura dei server che ospitano le caselle, non solo sulla crittografia della comunicazione.
]

== DNS
Il DNS è un protocollo alla base del web moderno, senza di esso si fermerebbe internet.
#definition()[
  Il DNS è semplicemente un database distribuito, ridondato e ad alta disponibilità. Se un server non sa rispondere ad una richiesta, tramite gerarchie, deleghe e cache sarà in grado di recuperare la risposta.
]
Non serve, attenzione, soltanto per comodità, ovvero per evitare di memorizzare gli indirizzi IP dei vari siti piuttosto che il loro nome (google.com invece di 142.250.184.195). Serve per il *Virtual Hosting*#index[Virtual Hosting] e per il *Cloud/Load Balancing*. Oggi, su un singolo indirizzo IP possono essere ospitati migliaia di siti web diversi. Quando viene effettuata una richiesta HTTP, inserite il nome del sito nell'header. Se il DNS non esistesse e usaste solo l'IP, il server di destinazione non saprebbe quale dei migliaia di siti (virtual host) si vuole visitare.

Il processo di risoluzione degli indirizzi avviene per gradi: quando un utente inserisce un indirizzo (come `wikiflix.toolforge.org`), il computer controlla prima la propria cache locale (il local resolver). Se non trova la risposta, invia la richiesta a un server DNS dedicato, chiamato recursive resolver (spesso fornito dall'ISP). Ci sono 3 classi di server DNS organizzati in una gerarchia:

1. *Root*#index[Root]: forniscono l'IP dei server TLD.
2. *Top-level domain (TLD)*#index[Top-level domain (TLD)]: forniscono l'IP dei server Authoritative.
3. *Authoritative*#index[Authoritative]: forniscono i record DNS di una specifica organizzazione.

Questo resolver procede suddividendo il nome di dominio nelle sue componenti gerarchiche, partendo dall'elemento più a destra. Innanzitutto, interroga i server Root, i quali forniscono l'indirizzo dei server responsabili per i domini di primo livello (Top-Level Domain, come `.org`). Successivamente, il resolver interroga il server `.org`, che a sua volta indica il server autorevole per il dominio di secondo livello, `toolforge.org`. Infine, interrogando il server di `toolforge.org`, il resolver ottiene l'indirizzo IP definitivo associato a `wikiflix.toolforge.org`. In ogni fase di questo percorso, i server possono sfruttare sistemi di caching per restituire le risposte precedentemente memorizzate, velocizzando notevolmente il processo per le richieste successive.

#figure(image("images/2026-07-05-22-10-52.png", width: 70%), caption: "Gerarchia server DNS")

Le query ai server DNS possono essere di tipo *ricorsivo*#index[ricorsivo] o *iterativo*#index[iterativo]:

#grid(
  columns: 2,
  [#figure(
    image("images/2026-07-05-22-16-37.png", height: 30%),
    caption: "Esempio query iterativa: il server contattato risponde con il nome del server da contattare.",
  )],
  [#figure(
    image("images/2026-07-05-22-16-22.png", height: 30%),
    caption: "Esempio query ricorsiva: affida il compito di tradurre il nome al server DNS contattato.",
  )],
)

#figure(image("images/2026-07-05-22-20-00.png", width: 70%), caption: "Esempio pacchetto richiesta DNS")
#figure(
  image("images/2026-07-05-22-20-21.png", width: 70%),
  caption: "Esempio pacchetto richiesta DNS con risposte multiple",
)
=== Vulnerabilità
Il *DNS*#index[DNS] è particolarmente critico dal punto di vista della sicurezza per vari motivi:

- non è autenticato: l'informazione richiesta potrebbe arrivare non dal DNS Server corretto ma da un'altra macchina;
- è molto lento, quindi è possibile che qualcuno intercetti la richiesta destinata a un DNS Server e risponda al suo posto (spoofing);
- il protocollo non offre meccanismi per proteggere l'integrità delle informazioni distribuite (basti pensare all'associazione tra hostname e indirizzo IP).
- DNS cache poisoning: attacchi volti a manomettere le informazioni contenute nei DNS Server, compromettendo la coerenza e l'integrità dei suoi dati.

Un DNS Server mantiene in una memoria cache anche informazioni relative a domini non di sua competenza. Una risposta fornita sulla base di questi dati è detta *non authoritative* e il valore del campo TTL (Time To Live) indica da quanto tempo tale record si trova in cache: più è alto il TTL più è alta la probabilità che il dato sia corretto perché recente. Un attacco di tipo *cache poisoning*#index[cache poisoning] a un DNS Server comporta la modifica dei dati della sua cache, inserendovi un valore di TTL molto alto, così da rendere _attendibile_ l'informazione modificata.

Tipicamente, l'intervento consiste nell'associare a un nome l'indirizzo IP di un server malevolo. Per esempio, un utente scrive nel browser l'URL di un sito web ma viene poi direzionato, a sua insaputa, verso un sito clone costruito per effettuare furti di identità o di dati bancari (phishing). Questo succede perché nella cache del DNS Server l'indirizzo IP originale, associato a quel nome, è stato sostituito con quello del web server malevolo.

=== DNSSEC

Per rimediare alle mancanze del protocollo originario in termini di sicurezza, è stato creato un gruppo di lavoro che ha definito un'estensione al DNS denominata DNSSEC (Domain Name System Security Extensions). Il compito di DNSSEC è di garantire all'utente che il sito web che sta visitando è quello originale e non una copia creata per scopi fraudolenti. A tal scopo si usano delle chiavi crittografiche per *autenticare* i dati nel DNS, a partire dalla root. Le chiavi per la root sono gestite da ICANN, l'ente responsabile dei Domain Name di primo livello (generici e nazionali).

=== DoT e DoH
Il DNSSEC, garantisce l'autenticità dei dati mitigando il rischio di DNS poisoning, ma non offre confidenzialità: le richieste (es. il dominio che si vuole visitare) viaggiano in chiaro. Ciò consente agli Internet Service Provider (ISP) o a chiunque intercetti il traffico di tracciare l'attività dell'utente. Per ovviare a questo problema di privacy, sono nati *DoT (DNS over TLS)*#index[DoT (DNS over TLS)] e *DoH (DNS over HTTPS)*#index[DoH (DNS over HTTPS)].

Entrambi abbandonano il trasporto UDP in favore del TCP e cifrano il traffico: DoT utilizza un canale TLS dedicato, mentre DoH incapsula le query DNS all'interno del normale traffico web HTTPS. Nonostante queste soluzioni crittografino la comunicazione in transito, presentano alcune criticità: non sono sempre supportate di default dai sistemi operativi, richiedono la conoscenza preventiva dell'indirizzo IP del resolver (che deve essere raggiunto senza l'ausilio di un DNS classico) e, soprattutto, non anonimizzano l'utente agli occhi del resolver stesso. Questo significa che la confidenzialità è garantita lungo il tragitto, ma i dati di navigazione vengono comunque consegnati ai grandi provider che gestiscono i server DoT/DoH (come Google o Cloudflare), spostando semplicemente il problema del tracciamento dall'ISP a questi colossi tecnologici.

=== ODoH
Per risolvere il paradosso della privacy intrinseco in DoH e DoT — dove il resolver conosce sia chi fa la richiesta sia cosa viene richiesto — è stato introdotto *ODoH (Oblivious DNS over HTTPS)*#index[ODoH (Oblivious DNS over HTTPS)]. L'obiettivo di ODoH è separare la conoscenza dell'identità dell'utente dalla conoscenza del contenuto della sua query, introducendo un intermediario chiamato Proxy.

#figure(image("images/2026-07-02-23-15-12.png"))

Il funzionamento prevede che il client crittografi la propria richiesta DNS (utilizzando la chiave pubblica del resolver finale, detto Target, tramite HPKE) e la invii prima al Proxy via HTTPS. Il Proxy non possiede la chiave per decifrare il contenuto, quindi non sa cosa stia cercando l'utente, ma conoscendone l'indirizzo IP, funge da tramite inoltrando la richiesta cifrata al Target per conto del client. Il Target, a sua volta, decifra la query e prepara la risposta (che può essere firmata via DNSSEC), ma la invia al Proxy senza conoscere l'indirizzo IP del client originale. In questo modo, il Proxy conosce l'identità del client ma non il contenuto della richiesta, mentre il Target conosce il contenuto ma ignora l'identità dell'utente, garantendo un livello di privacy (oblivion) nettamente superiore.

== Socket
Nella storia di Internet, l'introduzione delle socket ha rappresentato una vera e propria rivoluzione. Sono state inventate a Berkeley, in concomitanza con lo sviluppo dei sistemi UNIX. Il parallelismo alla base delle socket era legato all'hardware dell'epoca (negli anni '70 non c'erano i dischi rigidi moderni, ma si usavano molto i nastri magnetici). Per scrivere su un nastro si usava una `write` sequenziale, e per leggere si usava una `read` sequenziale. Le socket usano esattamente la stessa semantica: per trasmettere dati usi una `send` (o una scrittura sequenziale), e per riceverli usi una `receive` (una lettura che va a riempire un blocco di memoria).

=== Blocking vs Non-Blocking
La prima grande complicazione nello sviluppo di reti riguarda il comportamento del programma quando tenta di leggere o scrivere dati. Esistono due tipi principali di socket:

- *Socket Bloccanti*#index[Socket Bloccanti]: come suggerisce il nome, inviando o richiedendo la lettura di dati, il programma si "blocca" su quell'istruzione e non passa alla successiva finché i dati non sono stati scritti tutti, non sono stati ricevuti a sufficienza, o non scade un timeout. Sono più semplici da usare: basta controllare il codice di errore o il numero di byte restituiti.

- *Socket Non Bloccanti*#index[Socket Non Bloccanti]: i dati da inviare sono passati al sistema operativo e il programma continua immediatamente la sua esecuzione. In fase di lettura, la socket restituisce subito i dati se sono già disponibili; altrimenti, istruisce il sistema operativo a mandare una notifica (callback) quando i dati arriveranno.

=== Struttura

Aprendo il terminale (su Linux/Mac) e digitando `man socket`, è possibile  trovare la documentazione per creare una socket in C (ma i concetti si applicano a Python, Java, Rust, ecc.). La funzione principale richiede tre parametri:

#align(center, `int socket(int domain, int type, int protocol);`)

+ *Domain*: indica la famiglia di protocolli. I più comuni sono:

  - `AF_INET` per IPv4.

  - `AF_INET6` per IPv6.

  - `AF_UNIX` (o `AF_LOCAL`) per le comunicazioni interne allo stesso computer, senza usare lo stack di rete.

  #observation()[
    Il fatto che un'applicazione debba scegliere esplicitamente tra IPv4 e IPv6 è tecnicamente una violazione del principio di "information hiding", ma attualmente è così che funziona
  ]

+ *Type*: indica la modalità di comunicazione. I due tipi principali sono:

  - `SOCK_STREAM`: garantisce un flusso continuo di byte. Sotto il cofano si mappa tipicamente sul protocollo TCP. Si possono scrivere o leggere i byte un po' alla volta (1 byte, 10 byte o un giga). Sarà l'applicazione a dover capire dove inizia e finisce logicamente un messaggio.

  - `SOCK_DGRAM` (Datagram): orientato ai messaggi. Sotto il cofano si mappa tipicamente sull'UDP. Se si manda un pacchetto di 10 byte, il ricevente deve leggerli tutti e 10 insieme; se ne legge di meno, gli altri vanno persi.

  Ci sono anche tipi speciali come `SOCK_RAW`, che permette di bypassare i livelli alti e creare pacchetti a mano (packet injection), utile per la cybersecurity o lo sviluppo di basso livello.

+ *Protocol*: generalmente si imposta a `0`, delegando al *sistema operativo* la scelta del protocollo di default per quel dominio e quel tipo. Lo si specifica solo se si vogliono forzare protocolli particolari.

Questa funzione restituisce un numero intero. Se l'intero è negativo, significa che c'è stato un errore (es. dominio non supportato, permessi mancanti). Se l'intero è positivo, rappresenta l'ID della socket. Il kernel dei sistemi operativi Unix/Linux è scritto in C, che è un linguaggio procedurale. Ecco perché la funzione non restituisce un "oggetto socket", ma un semplice numero identificativo (un *file descriptor*#index[file descriptor]), che verrà usato come fosse il riferimento a quell'oggetto per tutte le operazioni successive.

