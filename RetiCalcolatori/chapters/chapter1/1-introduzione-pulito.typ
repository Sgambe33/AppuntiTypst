#import "../../../dvd.typ": *
#set text(lang: "it")

= Introduzione

== Topologia

Una rete è un'infrastruttura di nodi che connettono altri nodi. La topologia di una rete può essere rappresentata come un grafo (orientato o non orientato). Un vertice rappresenta un elemento passivo o attivo della rete mentre un arco rappresenta qualcosa che connette due vertici.

La struttura di una rete può essere analizzata sotto diversi punti di vista:

- *Topologia fisica*: come sono connessi fisicamente i dispositivi (cavi, fibra, collegamenti radio). Riguarda l'hardware. In questo caso i cavi rappresentano gli archi e le estremità dei cavi i vertici.
- *Topologia IP (Logica)*: come fluiscono i dati attraverso la rete basandosi sull'indirizzamento IP e le decisioni di routing. Non sempre rispecchia la topologia fisica. In questo cavo ogni dispositivo con un indirizzo IP è un nodo.
- *Topologia application-level*: come comunicano le applicazioni (es. reti Overlay, P2P, CDN). Ogni applicazione è un vertice.

== Commutazione (Switching)
Prima di analizzare Internet, è necessario chiarire *come* i dati attraversano una rete di nodi intermedi. Esistono tre paradigmi storici di commutazione:

- *Circuit Switching*: prima di scambiare dati viene stabilito un percorso fisico dedicato tra sorgente e destinazione, che resta riservato per l'intera durata della comunicazione. È il modello della telefonia tradizionale. Garantisce banda e latenza costanti, ma è inefficiente: le risorse restano allocate anche quando non si trasmette nulla (silenzi, pause) e serve una fase di setup iniziale prima di poter comunicare.

- *Message Switching*: non esiste un circuito dedicato. L'intero messaggio viene inviato a un nodo intermedio, che lo memorizza per intero e lo inoltra al nodo successivo quando il collegamento è libero (approccio *store-and-forward*). Elimina lo spreco del circuito riservato, ma obbliga ogni nodo a bufferizzare messaggi potenzialmente enormi e introduce ritardi elevati: un messaggio molto grande può monopolizzare un collegamento bloccando tutti gli altri. È il progenitore concettuale del packet switching (la stessa logica store-and-forward la si ritrova, ad esempio, nell'architettura storica dell'email e delle BBS).

- *Packet Switching*: il messaggio viene suddiviso in unità più piccole (i *pacchetti*), ciascuna dotata di un header con le informazioni di instradamento e inoltrata in modo *indipendente*. I pacchetti condividono i collegamenti con quelli di altre comunicazioni, possono seguire percorsi diversi e vengono riassemblati a destinazione. È il modello su cui si basa Internet: massimizza l'utilizzo della banda, non richiede un circuito dedicato ed è estremamente resiliente (se un nodo cade, i pacchetti successivi vengono instradati altrove).

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

=== Cenni storici
Le prime idee risalgono agli anni '60, quando pionieri come Leonard Kleinrock e J.C.R. Licklider (con l'idea delle *Galactic Networks*) teorizzarono una rete di comunicazione universale, in un'epoca in cui il packet switching era considerato un'eresia rispetto al circuit switching e i calcolatori usavano reti rigorosamente proprietarie e isolate (DECnet, reti Novell), capaci di collegare al massimo pochi uffici o edifici vicini.

Il progetto fu finanziato dal Dipartimento della Difesa statunitense (DARPA), non perché fosse una "rete militare" in senso stretto, ma perché all'epoca gran parte dei fondi federali per la ricerca transitava dai dipartimenti (la National Science Foundation non esisteva ancora). L'interesse strategico risiedeva nella prospettiva di una rete decentralizzata, priva di un singolo nodo critico (*single point of failure*) e capace di sopravvivere anche al collasso di una parte dell'infrastruttura.

Un fattore tecnico decisivo per la diffusione furono le *Berkeley Sockets* (BSD Sockets): prima della loro introduzione, inviare un pacchetto in rete richiedeva codice complesso e la lettura di manuali sterminati; con le socket bastavano poche chiamate di sistema. Sul piano puramente teorico esistevano protocolli più raffinati del TCP/IP, come l'*ATM* (Asynchronous Transfer Mode), dotato di una netta separazione tra dati utente, controllo e management. L'ATM non si affermò per un motivo essenzialmente storico: arrivò sul mercato quando il TCP/IP era già ampiamente adottato. Il TCP/IP non ha quindi vinto perché tecnicamente perfetto, ma perché è arrivato prima.

=== Caratteristiche fondamentali
- *Stack TCP/IP*: internet si basa su questa suite di protocolli. Attenzione: non è composta *solo* da TCP e IP, ma include molti altri protocolli essenziali come UDP, ICMP (diagnostica), ARP (risoluzione indirizzi), OSPF/BGP (routing).
- *Standardizzazione (IETF & RFC)*:
  - La standardizzazione è gestita dalla *IETF* (Internet Engineering Task Force).
  - I protocolli sono definiti nei documenti *RFC* (Request For Comments). Se un protocollo diventa standard, la sua RFC diventa la specifica di riferimento. L'iter odierno è molto rigoroso, con gruppi di lavoro, round di revisione e la necessità di implementazioni di test funzionanti, per evitare di rompere la rete.
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

Un Autonomous System è un concetto *amministrativo*, non di routing: è un blocco di reti gestite da un unico operatore che dichiara al resto della rete le proprie policy di instradamento. Non esiste un'autorità centrale su Internet: il sistema funziona grazie ad accordi bilaterali (*peering*) tra AS, che decidono se e come scambiarsi il traffico o farlo transitare per conto di terzi. All'interno del proprio AS l'operatore è sovrano (può bloccare protocolli, adottare algoritmi di routing interni inefficienti, ecc.) e non è nemmeno obbligato a implementare l'intero stack TCP/IP. Il vincolo che tiene insieme questa architettura è il protocollo di routing inter-AS, il *BGP* (Border Gateway Protocol), trattato nella sezione sul Routing.

In una rete possiamo distinguere tre categorie principali di dispositivi:

1. *Host L7*: I dispositivi finali (End Systems) dove risiedono le applicazioni (client e server). Sono l'origine e la destinazione del traffico. Sono identificati univocamente da indirizzi IP.
2. *Router L3*: dispositivi intermedi, usati principalmente per indirizzare i pacchetti. Hanno bisogno di un'interfaccia IP per ogni subnet a cui sono connessi. Instradano il traffico a livello 3 (IP) senza modificarlo.
3. *Gateway/Proxy L7*: dispositivi intermedi che operano fino al livello 7 (Applicativo) agendo sul contenuto della sessione.

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
#figure(image("images/2026-06-18-23-14-33.png", width: 50%))
Ogni layer aggiunge i propri dati in un *header* e opzionalmente in un *trailer*. Ciò permette di realizzare l'*incapsulamento*.
#figure(image("images/2026-06-18-23-19-10.png", width: 50%))

== Stack ISO/OSI
#grid(
  columns: 2,
  [#figure(image("images/2026-06-18-23-21-56.png", height: 20%))],
  [Il modello ISO/OSI è formato da 7 livelli. E' bene conoscerlo ma di fatto non è usato. Applica alcuni concetti fondamentali come:
    - *Separazione della responsabilità*: le funzionalità non sono duplicate.
    - *Information hiding*: l'implementazione effettiva viene nascosta, viene esposta solo l'interfaccia.

    I layer L1-L3 sono detti *Media Layers* mentre i L4-L7 sono detti *Host Layers*.],
)


#figure(image("images/2026-06-18-23-22-23.png", width: 80%))

I dati vengono scambiati tra nodi adiacenti e i nodi intermedi non dovrebbero processare le informazioni finali (a meno che non si tratti di Proxy o Gateways).

Il modello OSI prevede una rigida separazione: ogni livello dovrebbe leggere solo il proprio header ignorando il payload (*information hiding*). Questo mantiene l'architettura pulita ma genera header voluminosi e inefficienze pesanti. Il TCP/IP viola sistematicamente l'information hiding per ottimizzare le prestazioni: è anche per questo che i livelli superiori dell'OSI (Sessione, Presentazione) non sono mai stati realmente implementati su larga scala, e oggi i numeri dei livelli OSI (Layer 2, Layer 3, Layer 4) sopravvivono solo come vaga convenzione per capirsi.

== Stack TCP/IP
Lo stack TPC/IP è molto più semplice dell'ISO/OSI.
#figure(image("images/2026-06-18-23-25-56.png", width: 30%))
- L7 Livello Application: composto dai protocolli applicativi come ftp, smtp, http, etc...
- L4 Livello Transport: composto dai protocolli per il trasferimento dei dati end-to-end come TCP, UDP, QUICK, etc...
- L3 Livello Network: composto dai protocolli per il routing sorgente-destinazione come IP, ICMP, ARP, RARP, etc...
- L2 Livello Data Link: composto dai protocolli per le comunicazioni locali come PPP, ethernet, etc...

== Indirizzi
Verranno trattate tre tipologie di indirizzi. Per ciascuna è importante capirne lo *scope* (ambito di validità):

- *Indirizzi MAC (Livello 2)*: servono per comunicare all'interno di una rete locale (Ethernet, Wi-Fi). Il loro scope termina appena si incontra un router. Devono essere univoci all'interno dello stesso segmento di rete, altrimenti si generano conflitti. Una scheda di rete ha di norma un solo indirizzo MAC, ma a livello software può riceverne e gestirne molti.
- *Indirizzi numerici (IP, Livello 3)*: necessari per il routing end-to-end, da sorgente a destinazione. Una scheda di rete può avere un numero arbitrario di indirizzi IP: con IPv4 se ne assegna spesso uno solo per un problema di scarsità, ma in IPv6 averne multipli è la norma.
- *Indirizzi alfanumerici (DNS, Livello 7)*: nomi come `www.unifi.it`. Non servono solo a facilitare la memorizzazione, ma soprattutto a creare un livello di *astrazione*: se un server cambia provider (e quindi indirizzo IP), il DNS permette agli utenti di continuare a raggiungerlo con lo stesso nome. Un dominio può puntare a un numero arbitrario di IP, e uno stesso IP può ospitare un numero arbitrario di domini.

#observation()[
  #figure(image("images/2026-06-18-23-30-30.png"))
]

=== Dalle classi al CIDR
Agli albori di Internet, gli indirizzi IP erano divisi rigidamente in *classi* predefinite (A, B, C), spezzando l'indirizzo in due blocchi fissi: `Net_Id` (identificativo della rete) e `Host_Id` (identificativo del dispositivo). Se due computer avevano lo stesso `Net_Id`, sapevano di essere nella stessa sottorete e potevano comunicare direttamente senza passare dal router. Il problema delle classi era la rigidità: se un'azienda aveva bisogno di 500 indirizzi non le bastava una Classe C (254 indirizzi), quindi l'ente assegnatore era costretto a sprecare un'intera Classe B (circa 65.000 indirizzi). Inoltre questa rigidità impediva di compattare le tabelle di routing, rendendole gigantesche e la ricerca del percorso molto lenta.

#figure(image("images/2026-06-19-10-40-55.png", width: 60%))

La soluzione definitiva è stata l'introduzione del *CIDR* (Classless Inter-Domain Routing). Il CIDR elimina le vecchie classi e introduce una notazione flessibile basata su una barra (es. `150.217.8.0/24`), in cui la lunghezza della parte di rete non è più fissa. Questo permette di allocare lo spazio in modo fluido e, soprattutto, di accorpare (compattare) più reti contigue in un'unica riga della tabella di routing, ottimizzando drasticamente la gestione degli indirizzi. Per questo motivo, in un contesto moderno, non ha più senso ragionare in termini di Classe A, B o C.

=== Tabella di routing e Longest Prefix Match
Per capire dove inviare un pacchetto, i sistemi consultano una *Tabella di Routing* che mappa le destinazioni attraverso gateway (Next Hop) e interfacce di uscita specifiche.

#figure(image("images/2026-06-19-10-41-09.png", width: 60%))

Per trovare la rotta corretta, il sistema applica un'operazione logica per verificare se l'IP di destinazione combacia con le reti conosciute: verifica che `DestIP && RTMask == RTDestIP`. Poiché un pacchetto potrebbe teoricamente soddisfare più regole contemporaneamente (ad esempio una rotta generica e una specifica), il sistema applica la regola del *Maximum Matching Entry* (o Longest Prefix Match): tra tutte le rotte compatibili, vince quella con il maggior numero di bit a 1 nella sua maschera di sottorete (Genmask). In parole povere, il pacchetto viene sempre instradato seguendo il percorso in assoluto più specifico che il router conosce.

Il problema è che questa ricerca non si può eseguire con una semplice bisezione o con alberi di ricerca standard, perché non si può escludere a priori che più in fondo alla tabella ci sia una regola più specifica: ogni pacchetto costringe quindi il router a scandagliare gran parte della tabella. Come si fa a farlo velocemente nei router di fascia alta? Si usa la *Memoria Ternaria* (TCAM). Mentre la memoria classica ragiona in bit (0 e 1), la memoria ternaria aggiunge un terzo stato: "Non importa" (*Don't Care*). Questo permette all'hardware di confrontare l'indirizzo di destinazione con l'intera tabella di routing in un singolo ciclo di clock. È una tecnologia potentissima ed essenziale per i router di dorsale, ma estremamente costosa: è questo il motivo per cui un router domestico costa poche decine di euro e un router professionale può costarne decine di migliaia.
#pagebreak()

= Livello Applicativo
#observation()[
  Il protocollo DNS, se osserviamo lo stack TCP/IP o il modello ISO/OSI, risiede sopra il livello di trasporto, quindi è un livello applicativo. Ma attenzione non viene utilizzato come il protocollo HTTP o SMTP, il DNS è al servizio di altre applicazioni, pertanto è un protocollo livello 7 anomalo. Questo riconferma che i due modelli sono utili solo dal punto di vista teorico in quanto nella realtà è tutta un'altra storia.
]


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

#figure(image("images/2026-07-02-17-51-39.png", width: 60%))

#observation("PEC")[
  Il protocollo email standard non è nato per garantire consegne o integrità. La PEC cerca di risolvere questo problema, ma la sicurezza si basa sull'affidabilità dell'infrastruttura dei server che ospitano le caselle, non solo sulla crittografia della comunicazione.
]

== DNS
Il DNS è un protocollo alla base del web moderno, senza di esso si fermerebbe internet.
#definition()[
  Il DNS è semplicemente un database distribuito, ridondato e ad alta disponibilità. Se un server non sa rispondere ad una richiesta, tramite gerarchie, deleghe e cache sarà in grado di recuperare la risposta.
]
Non serve, attenzione, soltanto per comodità, ovvero per evitare di memorizzare gli indirizzi IP dei vari siti piuttosto che il loro nome (google.com invece di 142.250.184.195). Serve per il *Virtual Hosting* e per il *Cloud/Load Balancing*. Oggi, su un singolo indirizzo IP possono essere ospitati migliaia di siti web diversi. Quando viene effettuata una richiesta HTTP, inserite il nome del sito nell'header. Se il DNS non esistesse e usaste solo l'IP, il server di destinazione non saprebbe quale dei migliaia di siti (virtual host) si vuole visitare.

Il processo di risoluzione degli indirizzi avviene per gradi: quando un utente inserisce un indirizzo (come `wikiflix.toolforge.org`), il computer controlla prima la propria cache locale (il local resolver). Se non trova la risposta, invia la richiesta a un server DNS dedicato, chiamato recursive resolver (spesso fornito dall'ISP). Ci sono 3 classi di server DNS organizzati in una gerarchia:

1. *Root*: forniscono l'IP dei server TLD.
2. *Top-level domain (TLD)*: forniscono l'IP dei server Authoritative.
3. *Authoritative*: forniscono i record DNS di una specifica organizzazione.

Questo resolver procede suddividendo il nome di dominio nelle sue componenti gerarchiche, partendo dall'elemento più a destra. Innanzitutto, interroga i server Root, i quali forniscono l'indirizzo dei server responsabili per i domini di primo livello (Top-Level Domain, come `.org`). Successivamente, il resolver interroga il server `.org`, che a sua volta indica il server autorevole per il dominio di secondo livello, `toolforge.org`. Infine, interrogando il server di `toolforge.org`, il resolver ottiene l'indirizzo IP definitivo associato a `wikiflix.toolforge.org`. In ogni fase di questo percorso, i server possono sfruttare sistemi di caching per restituire le risposte precedentemente memorizzate, velocizzando notevolmente il processo per le richieste successive.

#figure(image("images/2026-07-05-22-10-52.png", width: 70%), caption: "Gerarchia server DNS")

Le query ai server DNS possono essere di tipo *ricorsivo* o *iterativo*:

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
Il *DNS* è particolarmente critico dal punto di vista della sicurezza per vari motivi:

- non è autenticato: l'informazione richiesta potrebbe arrivare non dal DNS Server corretto ma da un'altra macchina;
- è molto lento, quindi è possibile che qualcuno intercetti la richiesta destinata a un DNS Server e risponda al suo posto (spoofing);
- il protocollo non offre meccanismi per proteggere l'integrità delle informazioni distribuite (basti pensare all'associazione tra hostname e indirizzo IP).
- DNS cache poisoning: attacchi volti a manomettere le informazioni contenute nei DNS Server, compromettendo la coerenza e l'integrità dei suoi dati.

Un DNS Server mantiene in una memoria cache anche informazioni relative a domini non di sua competenza. Una risposta fornita sulla base di questi dati è detta *non authoritative* e il valore del campo TTL indica sia attendibile (più è alto il TTL più è alta la probabilità che il dato sia corretto). Un attacco di tipo *cache poisoning* a un DNS Server comporta la modifica dei dati della sua cache, inserendovi un valore di TTL molto alto, così da rendere attendibile l'informazione modificata.

Tipicamente, l'intervento consiste nell'associare a un nome l'indirizzo IP di un server malevolo. Per esempio, un utente scrive nel browser l'URL di un sito web ma viene poi direzionato, a sua insaputa, verso un sito clone costruito per effettuare furti di identità o di dati bancari (phishing). Questo succede perché nella cache del DNS Server l'indirizzo IP originale, associato a quel nome, è stato sostituito con quello del web server malevolo.

=== DNSSEC

Per rimediare alle mancanze del protocollo originario in termini di sicurezza, è stato creato un gruppo di lavoro che ha definito un'estensione al DNS denominata DNSSEC (Domain Name System Security Extensions). Il compito di DNSSEC è di garantire all'utente che il sito web che sta visitando è quello originale e non una copia creata per scopi fraudolenti. A tal scopo si usano delle chiavi crittografiche per *autenticare* i dati nel DNS, a partire dalla root. Le chiavi per la root sono gestite da ICANN, l'ente responsabile dei Domain Name di primo livello (generici e nazionali).

=== DoT e DoH
Il DNSSEC, garantisce l'autenticità dei dati mitigando il rischio di DNS poisoning, ma non offre confidenzialità: le richieste (es. il dominio che si vuole visitare) viaggiano in chiaro. Ciò consente agli Internet Service Provider (ISP) o a chiunque intercetti il traffico di tracciare l'attività dell'utente. Per ovviare a questo problema di privacy, sono nati *DoT (DNS over TLS)* e *DoH (DNS over HTTPS)*.

Entrambi abbandonano il trasporto UDP in favore del TCP e cifrano il traffico: DoT utilizza un canale TLS dedicato, mentre DoH incapsula le query DNS all'interno del normale traffico web HTTPS. Nonostante queste soluzioni crittografino la comunicazione in transito, presentano alcune criticità: non sono sempre supportate di default dai sistemi operativi, richiedono la conoscenza preventiva dell'indirizzo IP del resolver (che deve essere raggiunto senza l'ausilio di un DNS classico) e, soprattutto, non anonimizzano l'utente agli occhi del resolver stesso. Questo significa che la confidenzialità è garantita lungo il tragitto, ma i dati di navigazione vengono comunque consegnati ai grandi provider che gestiscono i server DoT/DoH (come Google o Cloudflare), spostando semplicemente il problema del tracciamento dall'ISP a questi colossi tecnologici.

=== ODoH
Per risolvere il paradosso della privacy intrinseco in DoH e DoT — dove il resolver conosce sia chi fa la richiesta sia cosa viene richiesto — è stato introdotto *ODoH (Oblivious DNS over HTTPS)*. L'obiettivo di ODoH è separare la conoscenza dell'identità dell'utente dalla conoscenza del contenuto della sua query, introducendo un intermediario chiamato Proxy.

#figure(image("images/2026-07-02-23-15-12.png"))

Il funzionamento prevede che il client crittografi la propria richiesta DNS (utilizzando la chiave pubblica del resolver finale, detto Target, tramite HPKE) e la invii prima al Proxy via HTTPS. Il Proxy non possiede la chiave per decifrare il contenuto, quindi non sa cosa stia cercando l'utente, ma conoscendone l'indirizzo IP, funge da tramite inoltrando la richiesta cifrata al Target per conto del client. Il Target, a sua volta, decifra la query e prepara la risposta (che può essere firmata via DNSSEC), ma la invia al Proxy senza conoscere l'indirizzo IP del client originale. In questo modo, il Proxy conosce l'identità del client ma non il contenuto della richiesta, mentre il Target conosce il contenuto ma ignora l'identità dell'utente, garantendo un livello di privacy (oblivion) nettamente superiore.

== Socket
Nella storia di Internet, l'introduzione delle socket ha rappresentato una vera e propria rivoluzione. Sono state inventate a Berkeley, in concomitanza con lo sviluppo dei sistemi UNIX. Il parallelismo alla base delle socket era legato all'hardware dell'epoca (negli anni '70 non c'erano i dischi rigidi moderni, ma si usavano molto i nastri magnetici). Per scrivere su un nastro si usava una `write` sequenziale, e per leggere si usava una `read` sequenziale. Le socket usano esattamente la stessa semantica: per trasmettere dati usi una `send` (o una scrittura sequenziale), e per riceverli usi una `receive` (una lettura che va a riempire un blocco di memoria).

=== Blocking vs Non-Blocking
La prima grande complicazione nello sviluppo di reti riguarda il comportamento del programma quando tenta di leggere o scrivere dati. Esistono due tipi principali di socket:

- *Socket Bloccanti*: come suggerisce il nome, inviando o richiedendo la lettura di dati, il programma si "blocca" su quell'istruzione e non passa alla successiva finché i dati non sono stati scritti tutti, non sono stati ricevuti a sufficienza, o non scade un timeout. Sono più semplici da usare: basta controllare il codice di errore o il numero di byte restituiti.

- *Socket Non Bloccanti*: i dati da inviare sono passati al sistema operativo e il programma continua immediatamente la sua esecuzione. In fase di lettura, la socket restituisce subito i dati se sono già disponibili; altrimenti, istruisce il sistema operativo a mandare una notifica (callback) quando i dati arriveranno.

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

Questa funzione restituisce un numero intero. Se l'intero è negativo, significa che c'è stato un errore (es. dominio non supportato, permessi mancanti). Se l'intero è positivo, rappresenta l'ID della socket. Il kernel dei sistemi operativi Unix/Linux è scritto in C, che è un linguaggio procedurale. Ecco perché la funzione non restituisce un "oggetto socket", ma un semplice numero identificativo (un *file descriptor*), che verrà usato come fosse il riferimento a quell'oggetto per tutte le operazioni successive.
#pagebreak()

= Livello trasporto
A livello di trasporto abbiamo protocolli *connection-oriented* e *protocolli connectionless*. I protocolli di livello 4 sono definiti "end-to-end", ovvero vanno dalla sorgente alla destinazione e i nodi intermedi della rete teoricamente se ne dovrebbero disinteressare. Se volessimo fare un paragone con il modello OSI - cosa sconsigliata di fare all'esame - diremmo che il livello Trasporto del TCP/IP fa cose che non gli competono, sobbarcandosi anche funzioni che l'OSI relegherebbe al livello di sessione. Il suo scopo primario è fare *multiplexing* e *demultiplexing*, fornire degli indirizzi di livello 4 ed eventualmente occuparsi del controllo di congestione e di flusso.

Il multiplexing, nelle reti, significa prendere i dati generati da più processi (ad esempio, un'applicazione che usa una socket TCP e un'altra che usa UDP) e infilarli insieme su un unico canale fisico di trasmissione. Il demultiplexing è l'esatto opposto in fase di ricezione. Per poter fare questo smistamento, ogni livello della pila protocollare deve avere nell'header un'informazione che identifichi a chi è destinato il payload: nel frame Ethernet c'è il campo EtherType, nell'IP c'è il campo Protocol, e a livello di trasporto sono usate le Porte.

#figure(image("images/2026-07-05-22-26-35.png", width: 60%))

== UDP vs TCP
Nel modello connection-oriented, come il TCP, il livello 4 esegue una fase di setup iniziale. Una volta stabilita la connessione, si ha la certezza che i dati arriveranno e si potrà comunicare in modo efficiente. I grandi svantaggi sono che permette solo comunicazioni uno-a-uno e, soprattutto, richiede il mantenimento continuo di uno "stato" della connessione. Poiché il livello IP sottostante è inaffidabile e invia i pacchetti ognuno per i fatti suoi, tutto l'enorme carico di mantenere in piedi la connessione e verificarne l'affidabilità ricade sul TCP.

L'UDP, al contrario, è connectionless ed è molto più affine all'IP: prende un pacchetto, lo manda e spera che arrivi. È una comunicazione monodirezionale, non ha fasi di setup e permette di inviare dati a un destinatario specifico, in multicast a molti o in broadcast a tutti. Il lato negativo è che si perde completamente la garanzia di consegna. L'UDP non dà alcun feedback sull'arrivo dei dati; se serve sapere se un pacchetto è giunto a destinazione, sarà necessario programmare un sistema di conferma a livello applicativo. Questo, però, lo rende un protocollo estremamente leggero e veloce, non essendoci alcuno stato da mantenere in memoria.

Il modo migliore per capire come funziona l'UDP è guardare il suo header, che è lungo appena 8 byte.
#figure(image("images/2026-06-20-17-37-16.png", width: 80%), caption: "UDP a sx, UDP-Lite a dx")

Contiene solo quattro campi: la porta sorgente, la porta destinazione, la lunghezza e un checksum per il controllo degli errori. La lunghezza è essenziale perché permette al sistema ricevente di sapere esattamente quanta memoria allocare in modo dinamico prima ancora di finire di leggere l'intero pacchetto. Non essendoci numeri di sequenza o acknowledgement, si tratta di un protocollo sostanzialmente vuoto.

Il calcolo del checksum è facoltativo su IPv4, obbligatorio su IPv6 mentre su UDP-Lite è opzionale e potrebbe non coprire l'intero header. C'è un'unica vera anomalia: per calcolare il checksum, l'UDP utilizza un cosiddetto "pseudo-header" IP. In pratica, il livello UDP ha bisogno di conoscere l'indirizzo IP sorgente, l'indirizzo destinazione e il protocollo, compiendo una violazione del principio di isolamento dei livelli (information hiding). Questo crea una complicazione in fase di invio, poiché l'UDP deve chiedere al livello IP quale indirizzo sorgente verrebbe usato per raggiungere quella determinata destinazione, in modo da poter calcolare correttamente il checksum prima di passargli il pacchetto. Esiste anche una variante meno comune, l'UDP-Lite, pensata per i flussi multimediali, che permette di applicare il checksum solo a una porzione del pacchetto in modo da tollerare lievi errori sui frame video senza scartare l'intera immagine.

== Porte e Socket
Le porte sono i punti logici in cui avviene il multiplexing dei servizi. Usiamo delle porte standard predeterminate, come la 80 per l'HTTP, per evitare che un client debba interrogare ogni volta il server per sapere su quale porta sia in ascolto un determinato servizio; un meccanismo del genere intaserebbe la rete e offrirebbe il fianco a innumerevoli problemi di sicurezza.

Le porte si dividono in categorie: le porte *well-known* (da 1 a 1023), le porte *registrate* (da 1024 a 49151, dove troviamo di tutto, persino la porta 666 assegnata al multiplayer di Doom) e le porte *effimere* assegnate dinamicamente. L'unica vera differenza pratica tra queste categorie è un retaggio storico: per aprire un servizio in ascolto su una well-known port è necessario avere i privilegi di amministratore (root), mentre per le altre basta un utente normale.

Quando il programma apre una socket, le viene assegnata una porta locale. E' possibile vincolare (bind) questa socket a uno specifico indirizzo IP della macchina, a una specifica interfaccia di rete (come il Wi-Fi o il cavo Ethernet) oppure lasciarla in ascolto su tutte le interfacce disponibili. Attenzione a un dettaglio fondamentale: poiché l'UDP è senza connessione, una volta aperta una socket su una determinata porta, questa riceverà indiscriminatamente pacchetti da chiunque li invii. Spetterà interamente all'applicazione fare il "demultiplexing applicativo", ovvero controllare l'indirizzo IP e la porta sorgente di ogni singolo pacchetto in ingresso per capire con chi si sta parlando e gestire correttamente le risposte. Le socket UDP di basso livello non fanno alcun filtro.

#pagebreak()

= TCP
L'header del TCP è molto più complicato di quello dell'UDP e, a differenza di quest'ultimo, non ha una dimensione fissa.

#figure(image("images/2026-06-20-17-41-09.png"))

- *Punti in comune con l'UDP:* anche il TCP possiede uno pseudo-header (identico a quello usato dall'UDP per IPv4/IPv6, essenziale per il calcolo del checksum). Inoltre, i primi due campi dell'header TCP sono la *Porta Sorgente* e la *Porta Destinazione* (entrambe da 16 bit), che si trovano nella stessa posizione e hanno la stessa semantica dell'UDP. Esse vengono utilizzate dal TCP stesso per effettuare il multiplexing. Questa somiglianza non è una regola fissa per tutti i protocolli di livello 4 (esiste ad esempio l'SCTP, usato nelle reti mobili, che funziona in modo diverso), ma è dovuta al fatto che TCP e UDP sono stati progettati nello stesso periodo, spesso dalle stesse persone, all'interno della suite TCP/IP.
- *Numeri di sequenza (Sequence e Acknowledgement Number):* subito dopo le porte, troviamo due campi da 32 bit fondamentali:
  - *Sequence Number*
  - *Acknowledgement Number*
  Questi sono il cuore del meccanismo di affidabilità del TCP.
- *La dimensione variabile (Data Offset):* a differenza dell'UDP che ha un header di 8 byte fissi, l'header TCP ha una dimensione base di 20 byte (5 word da 32 bit), ma può essere più lungo a causa del campo *Options*. Per capire dove finisce l'header e dove inizia il payload, il TCP utilizza il campo *Data Offset* (lungo 4 bit), che indica la lunghezza dell'header in word da 32 bit. È cruciale leggere questo valore: ignorare le opzioni porta a calcolare male il checksum e a invalidare i pacchetti.
- *Altri campi:* troviamo la *Window* (finestra di ricezione), il *Checksum* (che qui è obbligatorio e copre pseudo-header, header e payload), l'*Urgent Pointer* e una serie di flag di controllo:
  - *CWR + ECE* : Explicit Congestion Notification
  - *URG*: Urgent data
  - *ACK*: l'Acknowledgement Number è valido e reale
  - *RST*: reset della connessione (hard termination)
  - *SYN*: sincronizzazione numero di sequenza (connection start)
  - *FIN*: assenza di ulteriori dati da trasmettere (soft termination)

== TCP demultiplexing

C'è una differenza fondamentale nel modo in cui l'applicazione gestisce la ricezione dei pacchetti rispetto all'UDP.

- *UDP (Connectionless):* l'UDP invia e riceve datagrams senza stato. Usando una socket UDP, l'applicazione deve usare una funzione come `recvfrom()` per estrarre manualmente dall'header l'indirizzo IP e la porta sorgente del mittente. Spetta all'applicazione (demultiplexing applicativo) capire chi le sta parlando.
- *TCP (Connection-Oriented):* nel TCP, il canale è dedicato tra due endpoint precisi. Se un pacchetto arriva a una socket TCP attiva, il sistema sa già che proviene dall'unico mittente autorizzato per quella connessione. Il demultiplexing è gestito a livello TCP, e l'applicazione può usare una semplice funzione `recv()`, disinteressandosi dell'identità del mittente, che è già implicita nello stato della socket.

== Affidabilità

L'UDP è connectionless e privo di riscontri (*stateless*). Il TCP, essendo connection-oriented (*stateful*), garantisce che i dati arrivino (reliable) e vengano riordinati correttamente. Per farlo, deve gestire perdite, duplicati e pacchetti fuori ordine.

Il *Sequence Number* non conta i pacchetti inviati (pacchetto 1, 2, 3...), ma conta l'*offset in byte* dei dati trasmessi. Se il primo pacchetto invia 100 byte iniziando, per semplicità, dal numero di sequenza 1, il pacchetto successivo non avrà sequenza 2, ma sequenza 101.

L'*Acknowledgment Number* è la controparte esatta del Sequence Number, ed è il meccanismo con cui il TCP garantisce che i dati siano arrivati correttamente a destinazione. Così come il Sequence Number conta i byte inviati, l'Acknowledgment Number serve per indicare al mittente quali byte sono stati ricevuti con successo.

#observation()[
  Originariamente il TCP usava ACK cumulativi (confermando tutto fino a un certo punto), il che lo rendeva simile a un Go-Back-N. Oggi, nelle reti ad altissima velocità dove il Round Trip Time permette di avere migliaia di pacchetti "in volo", si usano i Selective Acknowledgement (SACK). Attenzione però: le opzioni come SACK devono essere negoziate all'apertura della connessione e allungano l'header TCP, riducendo lo spazio per i dati reali.
]

== Flag di controllo

I flag TCP servono a gestire lo stato della connessione:

- *ACK*: indica che il campo *Acknowledgement Number* contiene un valore valido. Poiché la comunicazione è bidirezionale, un pacchetto potrebbe contenere solo dati senza dover confermare nulla di nuovo. Se questo flag è a 0, il destinatario sa di dover ignorare il campo ACK, evitando di interpretarlo erroneamente come una conferma duplicata (Duplicate ACK), che innescherebbe meccanismi di reazione alla congestione.
- *SYN*: inizia una connessione.
- *FIN*: termina una connessione in modo controllato.
- *RST*: termina la connessione in modo drastico, utile per situazioni di emergenza (es. connessione caduta da un lato).

== Three-way Handshake

Per stabilire una connessione bidirezionale affidabile, il TCP usa il *Three-way Handshake*:

1. *SYN:* il client invia un pacchetto con flag SYN a 1, indicando le opzioni TCP e, soprattutto, il suo Sequence Number iniziale (che viene generato casualmente, non parte da 1).
2. *SYN-ACK:* il server riceve il SYN e risponde con un pacchetto avente i flag SYN e ACK a 1. Conferma di aver ricevuto il sequence number del client (incrementato) e invia il *proprio* Sequence Number iniziale.
3. *ACK:* il client riceve il SYN-ACK e manda un ultimo pacchetto (ACK = 1) per confermare la ricezione del sequence number del server. A questo punto, la connessione è *Established* ed è possibile lo scambio bidirezionale di dati.

#figure(image("images/2026-06-20-17-48-10.png"))


#observation()[
  Il protocollo TCP prevede (come requisito "MUST") la gestione dell'apertura simultanea, ovvero il caso legale ma raro in cui due host inviino un pacchetto SYN nello stesso identico momento.
]

== Four-way Teardown
Supponiamo sia presente una connessione TCP attiva tra Alice e Bob. La chiusura di una connessione è indipendente per le due direzioni e richiede quattro passaggi:

1. *FIN:* Alice invia un pacchetto FIN a Bob, indicando che non ha più dati da trasmettere.
2. *ACK:* Bob conferma la ricezione del FIN. In questo momento, la connessione è "Half-Open": Alice non trasmetterà più, ma Bob può ancora inviare dati (situazione tipica di quando un client HTTP invia una richiesta breve e il server risponde con un file molto grosso).
3. *FIN:* quando anche Bob ha terminato, invia il suo pacchetto FIN.
4. *ACK:* Alice conferma il FIN di Bob, e la connessione si chiude. (I passaggi 2 e 3 possono essere collassati in un unico pacchetto FIN-ACK).

== Il TCB

Il TCP è una complessa macchina a stati finiti (FSM). Lo stato di questa macchina per una singola connessione viene memorizzato in una struttura dati chiamata *TCB (Transmission Control Block)*. Il TCB contiene lo stato della connessione, i timer e i buffer per gestire i dati in ingresso e in uscita e per riordinare i pacchetti. Mantenere queste strutture occupa molta memoria RAM.

Il TCP identifica due ruoli all'interno della connessione: il *server* che apre una porta ed aspetta connessioni (la sua porta deve essere conosciuta dal client) e il *client* che avvia la connessione verso il server (la sua porta può essere effimera).

Quando un server mette in ascolto una socket TCP (stato *LISTEN*), non conosce ancora chi si connetterà. Quando arriva un pacchetto SYN da un client, il server crea un nuovo TCB parziale (per evitare attacchi di tipo *SYN Flood*, che esaurirebbero la memoria). Una volta completato l'handshake (stato *ESTABLISHED*), il processo del server esegue tipicamente una `fork()`: il processo padre continua ad ascoltare sulla socket originale (che rimane in *LISTEN*). Il processo figlio eredita una *nuova* socket dedicata a quella specifica connessione, dotata di un TCB completo contenente la *quintupla* identificativa `{src/dst IP, src/dst port, protocol}`.

#observation()[
  Un attacco di tipo SYN flood consiste nell'inviare ripetutamente richieste di connessione iniziale (SYN) in modo tale da esaurire e sopraffare tutte le porte disponibili di un server. Quest'ultimo, di conseguenza, sarà obbligato a rispondere lentamente, o direttamente ignorare, al traffico legittimo.
]

== Introduzione alla congestione

Il TCP originario (RFC 793) non prevedeva algoritmi per gestire la congestione; sono stati aggiunti in seguito per evitare che le reti collassassero.

Il fenomeno si spiega tramite la teoria dei Sistemi a Coda. Si immagini un router (il servente) che riceve pacchetti a un rate di ingresso ($lambda$) e li inoltra a un rate di uscita ($mu$). La stabilità del sistema dipende dal fatto che la capacità di smaltimento del router sia superiore al traffico in ingresso.
#figure(image("images/2026-06-20-17-50-54.png"))

Se il rate di uscita ($mu$) è di 1 Gigabit e l'ingresso ($lambda$) è di 10 Megabit, la coda non si riempirà mai. Se avviene il contrario (es. una dorsale veloce che entra in un router domestico lento), si crea un collo di bottiglia.

I pacchetti in eccesso finiscono nella coda del router. Poiché la memoria del router (la dimensione della coda) è limitata, quando la coda si riempie, i nuovi pacchetti vengono semplicemente scartati (*dropped*). Il controllo di congestione del TCP serve proprio ad accorgersi di queste perdite e a rallentare l'invio dei dati per evitare di riempire la coda.

Nella realtà di Internet, la dimensione dei pacchetti segue una distribuzione quasi binomiale: ci sono pacchetti molto grandi e pacchetti molto piccoli, con una distribuzione del tempo di inter-arrivo estremamente variabile e fastidiosa da calcolare. Ma perché ci interessa parlarne? Perché ci porta a identificare l'elemento critico dentro ai dispositivi di rete: la coda. E attenzione, non c'è *una* sola coda. Analizzando un sistema di trasmissione, è possibile trovare code ovunque. C'è la coda dei messaggi dell'applicazione, la coda del TCP o dell'UDP in attesa di essere passati all'IP e infine la coda hardware della scheda di rete, che spesso è limitatissima (es. solo tre o sei pacchetti).

=== Controllo di congestione

L'obiettivo primario del controllo di congestione è prevenire la saturazione delle code nei router intermedi. Idealmente, il tasso di immissione dei dati nella rete ($lambda$) dovrebbe mantenersi sempre marginalmente inferiore al tasso di smaltimento o servizio ($mu$) dei router. Tuttavia, poiché il traffico confluisce in modo imprevedibile da innumerevoli sorgenti, sorge un problema: come fa un singolo nodo mittente a calcolare la velocità di trasmissione ottimale senza sovraccaricare l'infrastruttura?

Poiché la rete Internet è un sistema distribuito, non possiamo interrogare direttamente ogni singolo router per conoscere lo stato di riempimento delle sue code. Il mittente è di fatto "cieco" rispetto allo stato interno della rete. Per risolvere questo problema, si utilizza un meccanismo fondamentale della teoria dei sistemi: il *feedback loop* (o ciclo di retroazione).

#definition()[Un feedback loop è un sistema dinamico in cui l'uscita (il risultato) di un processo viene misurata e reintrodotta nel sistema stesso come nuovo segnale di ingresso, al fine di correggerne il comportamento futuro.
]
Nel networking parliamo di un *feedback loop*, ovvero un meccanismo di auto-regolazione che cerca di mantenere la stabilità contrastando le deviazioni:
1. *Azione (Input):* il mittente invia pacchetti a una certa velocità nella rete.
2. *Sistema:* i pacchetti attraversano i router. Se il volume di traffico è troppo alto, le code dei router iniziano a riempirsi.
3. *Riscontro (Feedback):* il ricevente invia dei messaggi di conferma (ACK) al mittente. Se un router è congestionato, la sua coda si saturerà e i pacchetti in eccesso verranno scartati (*packet drop*).
4. *Reazione:* il mittente non riceve gli ACK previsti. Interpreta questa "mancanza di segnale" come un feedback diretto di congestione e, in risposta, riduce immediatamente la propria velocità di trasmissione per riportare il sistema in equilibrio.

Il problema è che questo feedback arriva con un ritardo. Vogliamo che la coda sia non solo stabile, ma il più piccola possibile. Perché? Perché anche se non si perdono pacchetti, una coda lunga introduce un ritardo enorme. In una trasmissione dati, il ritardo end-to-end è la somma del ritardo di propagazione (spesso trascurabile), del tempo di trasmissione sulla linea (la "velocità" in Gigabit) e del tempo passato in coda. Il tempo in coda è ciò che deve essere minimizzato.

=== Gestione delle Perdite
Ma se i pacchetti si perdono, come vengono gestiti? Il TCP gestisce anche questo scenario, abbastanza comune, in diversi modi:
- *Stop-and-Wait*: si invia un pacchetto e si aspetta l'acknowledgement (ACK) prima di mandare il successivo. Facilissimo da implementare, ma super inefficiente a causa del tempo morto (il Round Trip Time, o RTT).
- *Go-Back-N*: si trasmettono pacchetti a raffica e, se si scopre di aver perso il pacchetto numero due, si butta via tutto quello che è arrivato dopo e si ritrasmette dal due in poi. È più efficiente, ma in una rete Internet dove i pacchetti arrivano fuori ordine o duplicati, diventa problematico.
- *Selective Repeat*: il ricevitore comunica esattamente quale pacchetto manca. Contrariamente agli altri, richiede il riordino dei pacchetti.

#figure(image("images/2026-06-20-17-56-01.png"))

=== Controllo del flusso e della congestione
Non si deve confondere il controllo di congestione nei nodi intermedi con il controllo di flusso al ricevitore. Se si trasmette a una velocità elevata ma il computer ricevente è un dispositivo IoT poco potente, la sua memoria si saturerà. Il controllo di flusso serve proprio a sincronizzare la velocità del trasmettitore con le risorse di chi riceve, per evitare che i pacchetti vengano scartati alla fine del viaggio.

#observation("Controllo del flusso")[
  È un servizio di adattamento della velocità (speed-matching service) che serve a sincronizzare la velocità del trasmettitore con le capacità di ricezione ed elaborazione del destinatario. Il suo scopo principale è evitare che il mittente saturi il buffer del ricevitore inviando troppi dati troppo velocemente. Nel protocollo TCP, questo viene gestito facendo sì che il ricevitore comunichi costantemente al mittente la dimensione della sua *receive window* (finestra di ricezione), informandolo in modo dinamico su quanto spazio libero è rimasto nel proprio buffer.
]

#example("Controllo del flusso")[
  Il protocollo TCP implementa il controllo di flusso per evitare che il mittente saturi il buffer del destinatario, utilizzando una variabile dinamica chiamata finestra di ricezione (receive window - `rwnd`). Poiché il TCP è full-duplex, entrambi i lati della connessione mantengono una propria `rwnd` distinta.
  Si supponga un trasferimento di un file dall'Host A all'Host B:

  + *Lato ricevitore (Host B)*: l'Host B alloca per la connessione un buffer di ricezione di dimensione fissa denominato `RcvBuffer`. Il livello di occupazione temporanea di questo buffer dipende da due variabili:
    - `LastByteRcvd`: l'ultimo byte arrivato dalla rete e memorizzato nel buffer.
    - `LastByteRead`: l'ultimo byte effettivamente letto e prelevato dal buffer dall'applicazione.
    Per evitare l'overflow, la quantità di dati momentaneamente parcheggiati nel buffer (`LastByteRcvd - LastByteRead`) non deve superare la dimensione del buffer stesso. Lo spazio libero rimanente, ovvero la finestra di ricezione dinamica, viene calcolato con la formula:
    #align(center, [`rwnd = RcvBuffer - [LastByteRcvd - LastByteRead]`])
    L'Host B comunica costantemente questo spazio disponibile inserendo il valore di `rwnd` nell'apposito campo dell'header di ogni segmento TCP che invia all'Host A.

  + *Lato mittente (Host A)*: l'Host A deve assicurarsi di non iniettare nella rete più dati di quanti B possa accettarne. Per farlo, traccia a sua volta due variabili:
    - `LastByteSent`: l'ultimo byte trasmesso.
    - `LastByteAcked`: l'ultimo byte di cui ha ricevuto riscontro (ACK).
    La differenza tra queste due variabili, ovvero `LastByteSent - LastByteAcked`, rappresenta la quantità di dati "in volo" (trasmessi ma non ancora confermati).
    Per garantire che il buffer di B non vada mai in overflow, per tutta la durata della connessione l'Host A autolimita le sue trasmissioni assicurandosi che i dati in volo siano sempre minori o uguali all'ultimo valore di `rwnd` ricevuto:
    #align(center, [`LastByteSent - LastByteAcked ≤ rwnd`])

  #figure(image("images/2026-07-05-22-43-52.png"))
]

#observation("Controllo della congestione")[
  È un servizio pensato per il benessere dell'infrastruttura di Internet nel suo insieme. Interviene quando troppi nodi tentano di trasmettere dati a velocità eccessive per la rete. Il suo scopo è evitare che le connessioni inondino di traffico i collegamenti e i router intermedi, impedendo così che i buffer (le code) dei router si riempiano provocando perdite di pacchetti e latenze elevate. Nel TCP, il mittente regola la propria velocità di trasmissione manipolando una variabile interna chiamata congestion window in risposta agli eventi di congestione (come la perdita di pacchetti).
]

Come fa praticamente il TCP a regolare la velocità? Usa una *congestion window*. Più è grande questa finestra, più dati trasmetto in un RTT. La teoria classica si basa sull'algoritmo *AIMD* (Additive Increase, Multiplicative Decrease): ogni volta che ricevo un ACK, aumento la finestra linearmente di 1; se rilevo una perdita, presumo ci sia congestione e dimezzo drasticamente la finestra. Questo approccio crea il classico grafico a dente di sega e garantisce stabilità e *fairness* (equità) tra i vari utenti che si contendono la banda.
#figure(image("images/2026-07-05-22-48-05.png", width: 50%), caption: "Grafico AIMD.")

Oggi però l'AIMD puro è superato. I sistemi operativi moderni usano diversi "flavors" (varianti) del TCP. Linux usa spesso il *Cubic*, mentre Google spinge per algoritmi basati sui ritardi come il *BBR*. Ognuno reagisce in modo diverso alla congestione.

#observation()[
  Ricordiamo che una perdita di pacchetti non significa sempre congestione; in una rete Wi-Fi o satellitare le perdite possono avvenire per interferenze radio, e dimezzare la velocità per un'interferenza è un errore grave.
]

Uno dei metodi più recenti è l'*AQM* (Active Queue Management). Piuttosto che aspettare che la coda di un router si riempia del tutto e provochi un disastro, l'AQM fa una cosa molto intelligente: inizia a scartare intenzionalmente *qualche* pacchetto in anticipo.  Questo segnale "sveglia" il controllo di congestione del TCP prima che sia troppo tardi. Senza algoritmi come RED, CoDel o FQ-CoDel nei router intermedi, la latenza su Internet sarebbe insopportabile e non potremmo fare, ad esempio, videochiamate.
#pagebreak()

= NAT (Network Address Translation)

Il Network Address Translation (NAT) è stato introdotto negli anni '90 come soluzione transitoria per arginare l'esaurimento degli indirizzi IPv4, in attesa dell'implementazione su larga scala dello standard IPv6. L'approccio si basa sulla definizione di blocchi di indirizzi IP "privati":


#definition("Indirizzi Privati (RFC 1918)")[
  L'Internet Engineering Task Force (IETF) ha riservato tre blocchi di indirizzi IP per l'uso all'interno di reti private: `10.0.0.0/8`, `172.16.0.0/12` e `192.168.0.0/16`. Questi indirizzi non sono univoci a livello globale e non possono essere instradati nella rete Internet pubblica.
]

Il NAT, posizionato tipicamente sul router di confine, agisce traducendo gli indirizzi IP privati dei dispositivi della rete interna in uno o più indirizzi IP pubblici, consentendo così l'accesso a Internet. Ne esistono tre varianti principali:

+ *NAT Statico*: prevede un'associazione univoca (rapporto 1:1) tra un indirizzo IP privato e un indirizzo IP pubblico. Questa configurazione è utilizzata prevalentemente per esporre server o servizi interni affinché siano sempre raggiungibili dall'esterno tramite un IP fisso. Essendo una mappatura uno-a-uno, non contribuisce in alcun modo a mitigare la scarsità di indirizzi IPv4.
  #figure(image("images/2026-06-22-20-05-55.png", width: 60%))

+ *NAT Dinamico*: associa dinamicamente un IP pubblico, prelevato da un pool predefinito, a un IP privato nel momento in cui questo genera traffico in uscita. L'indirizzo pubblico viene poi rilasciato al termine della sessione di comunicazione. Tale meccanismo opera secondo una logica "first-come, first-served" e presenta forti limitazioni: l'esaurimento temporaneo degli IP nel pool preclude l'accesso a Internet per tutti gli altri dispositivi della rete locale.
  #figure(image("images/2026-06-23-12-13-29.png", width: 70%))

+ *NAPT / PAT *: consente a molteplici dispositivi di una rete privata di accedere a Internet utilizzando un singolo indirizzo IPv4 pubblico (rapporto N:1 tra indirizzi privati e indirizzo pubblico). Il PAT sfrutta i numeri di porta di livello di trasporto per tracciare le diverse sessioni di comunicazione, alterando la porta sorgente durante la traslazione e potendo gestire teoricamente fino a $2^{16}$ (65.536) connessioni simultanee. Il NAPT fa uso di una NAT Translation Table:
  - Pacchetto in uscita (Interfaccia Interna): Quando un host interno invia un datagramma verso l'esterno, il NAT cerca un binding (una regola di traslazione) esistente. Se non esiste, crea un nuovo binding assegnando una nuova porta sorgente, sostituisce l'indirizzo IP privato con quello pubblico del router, ricalcola i checksum e inoltra il pacchetto.
  - Pacchetto in ingresso (Interfaccia Esterna): Quando un pacchetto arriva dalla rete pubblica, il NAT consulta la tabella usando l'IP e la porta di destinazione. Se trova un binding, riscrive l'IP e la porta per inoltrarlo all'host locale.
  #observation()[
    Se un pacchetto arriva sull'interfaccia esterna e non esiste un binding corrispondente nella tabella, il NAT non sa a chi inoltrarlo e scarta (drop) il pacchetto.
  ]






// Questa tecnica introduce però alcune problematiche:
// - *Violazione dell'astrazione dei livelli*: costringe un apparato di livello 3 (il router) a ispezionare i pacchetti fino al livello 4 (TCP/UDP). L'eventuale adozione di futuri protocolli privi del concetto di "porta" renderebbe il NAPT inefficace, venendo a mancare l'elemento chiave per la traslazione.
// - *Incompatibilità con i protocolli di sicurezza*: il NAT altera l'intestazione IP originale, compromettendo l'integrità richiesta da protocolli di sicurezza come IPsec in modalità AH (Authentication Header). Il ricevente, rilevando una discrepanza tra l'header modificato e la firma crittografica, scarterà il pacchetto. Le contromisure necessarie (come il *NAT Traversal* tramite l'incapsulamento del traffico crittografato all'interno di ulteriori datagrammi UDP) introducono *overhead* aggiuntivo, sprecano larghezza di banda e generano gravi interferenze tra i meccanismi di controllo della congestione a causa di tunnel annidati (es. TCP-over-TCP).

== Gestione degli stati

L'utilizzo del NAT introduce un comportamento non deterministico nelle comunicazioni. Nel caso del protocollo *connection-oriented* TCP, la gestione dello stato è lineare: l'apertura (flag SYN) e la chiusura (flag FIN o RST) della connessione dettano chiaramente al NAT quando creare e distruggere il relativo binding.

Per il protocollo UDP (*connectionless*), l'assenza di meccanismi espliciti di instaurazione e terminazione della sessione rende la gestione complessa. Il NAT deve creare un *binding* temporaneo al passaggio del primo pacchetto, basandosi su timer di inattività (es. Timer Refresh di tipo Bidirectional, Outbound o Inbound) per rimuoverlo. Un timeout eccessivamente breve provoca disconnessioni casuali (critiche nel gaming o nello streaming), mentre uno troppo lungo comporta un inutile spreco di risorse sul router. Di conseguenza, le applicazioni moderne (come software VoIP o messaggistica) sono obbligate a implementare meccanismi di *keep-alive*, inviando periodici pacchetti fittizi al solo scopo di impedire la chiusura della porta da parte del NAT.

#definition("Tipologie di timers")[
  + Bidirectional: il timer viene aggiornato da pacchetti sia in entrata che in uscita.
  + Outbound: solo i pacchetti in uscita aggiornano il timer.
  + Inbound: solo i pacchetti in entrata aggiornano il timer.
]

#observation()[
  Per l'UDP, il comportamento del NAT è governato da filtri che determinano l'accettazione dei pacchetti in ingresso. Questi filtri classificano i NAT in quattro tipologie: *Symmetric*, *Full Cone*, *Restricted Cone* e *Port Restricted Cone*.
]

=== Comportamenti NAT UDP
+ *Full Cone NAT (Endpoint Independent)*\
  #figure(image("images/2026-07-13-13-24-00.png", width: 60%))
  - Funzionamento: è la modalità più permissiva. Quando un host interno invia un pacchetto UDP all'esterno, il NAT alloca una porta pubblica e crea un binding. Da quel momento in poi, la porta pubblica del router rimane aperta e qualsiasi host esterno (da qualunque indirizzo IP e qualunque porta) può inviare pacchetti a quella porta; il NAT li inoltrerà tutti all'host interno.
  - Criticità: questa modalità garantisce il funzionamento di quasi tutte le applicazioni UDP, ma presenta gravissimi problemi di sicurezza (chiunque può fare network scanning o inviare traffico arbitrario verso la porta aperta) ed è inefficiente perché "brucia" una porta pubblica per ogni applicazione.

+ *Restricted Cone NAT (Endpoint Address Dependent)*\
  #figure(image("images/2026-07-13-13-24-11.png", width: 60%))
  - Funzionamento: il filtro di accettazione si basa esclusivamente sull'indirizzo IP. Il NAT inoltra un pacchetto in ingresso verso l'host interno solo e soltanto se l'host interno aveva precedentemente inviato un pacchetto verso quello specifico indirizzo IP esterno.
  - Caratteristica: la porta sorgente utilizzata dall'host esterno per rispondere non ha importanza, il NAT verifica solo che l'IP mittente sia tra quelli già contattati

+ *Port Restricted Cone NAT (Endpoint Port Dependent)*\
  #figure(image("images/2026-07-13-13-24-26.png", width: 60%))

  - Funzionamento: è una variazione più rigida della precedente. Il filtro in ingresso valuta sia l'indirizzo IP che la porta. L'host esterno può raggiungere l'host interno solo se l'host locale aveva precedentemente inviato un pacchetto verso quello specifico IP esterno e verso quella specifica porta. Ogni traffico proveniente da porte esterne diverse viene silenziosamente scartato.

+ *Symmetric NAT (Endpoint Address and Port Dependent)*\
  #figure(image("images/2026-07-13-13-24-46.png", width: 60%))
  - Funzionamento: è la modalità che si comporta in modo più simile alla rigorosa gestione del TCP. Non solo il filtro in ingresso è strettissimo (solo l'host e la porta specificamente contattati per primi possono rispondere usando quel varco), ma il comportamento di binding muta a seconda della destinazione. Se un host interno contatta la destinazione A, il NAT gli assegna la porta pubblica X. Se lo stesso host interno, usando la stessa porta sorgente locale, contatta la destinazione B, il Symmetric NAT gli assegnerà una porta pubblica Y completamente diversa.
  - Criticità nel Referral Handover: questa modalità distrugge le comunicazioni Peer-to-Peer. Se l'host interno contatta un server di signaling (come un server STUN o SIP) per farsi conoscere, il server vedrà la porta pubblica X. Quando l'host proverà a contattare direttamente il suo "Peer" finale, il Symmetric NAT cambierà la porta esterna in Y. Il Peer tenterà inutilmente di rispondere alla porta X, rendendo impossibile la comunicazione diretta senza passare per server intermedi.

== Criticità del NAT
Di seguito le principali criticità introdotte dal NAT:

=== Incompatibilità con Protocolli senza Porte
Il NAPT si basa sull'esistenza delle porte per effettuare il multiplexing. Protocolli di livello superiore che non utilizzano porte, come l'ICMP o l'SCTP (Stream Control Transmission Protocol), vengono rotti dal NAT, a meno che il router non venga specificamente programmato per decodificarne le strutture, violando l'information hiding.

=== Distruzione della Sicurezza (IPsec e VPN)
Il NAT e la crittografia di livello di rete spesso si escludono a vicenda.
Se si utilizza il protocollo IPsec in modalità AH (Authentication Header), la firma crittografica include l'indirizzo IP e le porte originali. Quando il NAT modifica questi campi, il destinatario rileva una firma non valida e scarta il pacchetto.

Per aggirare il problema, le VPN incapsulano il traffico IPsec all'interno di payload UDP (NAT Traversal). Questo non solo introduce un overhead (es. 28 byte aggiuntivi), ma porta a conflitti nel Controllo di Congestione. Annidando un protocollo TCP all'interno di un altro tunnel TCP/UDP, in caso di perdita di pacchetti i due algoritmi di multiplicative decrease si attivano simultaneamente, facendo crollare drammaticamente la larghezza di banda e causando oscillazioni incontrollabili.

=== Il Problema del Referral Handover e STUN
In applicazioni Peer-to-Peer, VoIP (es. protocollo SIP/VoLTE) e gaming, un host contatta un server di segnalazione dichiarando il proprio indirizzo IP e porta per farsi chiamare da un altro peer (*Referral Handover*). Sotto NAT, l'indirizzo privato dell'host è inutile per l'esterno. Il protocollo *STUN* (Simple Traversal of UDP Through NATs, RFC 3489) fu creato per permettere alle applicazioni di scoprire il proprio indirizzo pubblico e il tipo di NAT.
#observation()[Lo STUN è oggi considerato deprecato e inaffidabile. Questo perché i NAT sono non-deterministici (possono cambiare mappatura a seconda del carico o della destinazione) e perché nel percorso di rete si trovano frequentemente NAT in cascata, rendendo impossibile ottenere una risposta utile.]

=== Carrier-Grade NAT (NAT in Cascata) e Port Multiplexing
Gli ISP moderni, avendo esaurito anche loro gli IP pubblici, applicano spesso un secondo livello di NAT all'interno della loro infrastruttura (CGNAT). Ciò crea scenari paradossali in cui un utente esce con un IP pubblico per raggiungere una destinazione (es. Tokyo) e con un altro IP pubblico per un'altra destinazione (es. Los Angeles). Inoltre, le tecniche dei router per gestire l'esaurimento delle porte generano comportamenti anomali:
- *Port Preservation*: il NAT cerca di non cambiare il numero di porta interno. Se due host interni richiedono la stessa porta, il primo vince e al secondo viene cambiata. Se il secondo insiste, il router potrebbe far scadere il binding del primo, causando malfunzionamenti casuali.
- *Port Multiplexing*: Il NAT cerca di far uscire più host interni usando la stessa porta esterna, discriminando in base alla destinazione. Funziona a basso carico, ma genera fallimenti ("mutando forma") in condizioni di alto traffico.

=== Sicurezza e UPnP (Universal Plug and Play)
Il protocollo IGD (Internet Gateway Device) via UPnP permette ai dispositivi interni (es. console, NAS) di chiedere al NAT di aprire automaticamente delle porte in ingresso per abilitare connessioni entranti. Questo meccanismo agisce all'insaputa dell'utente e del firewall, creando gravissimi buchi di sicurezza (Security Issues), lasciando porte permanenti aperte e causando conflitti se due dispositivi interni richiedono la stessa porta.
#pagebreak()

= IPv6

L'evoluzione delle infrastrutture di rete ha reso obsoleti molti dei paradigmi legati allo standard IPv4. Attualmente, l'IPv6 non costituisce un protocollo sperimentale o futuro, bensì lo standard *de facto* su cui transita la maggioranza del traffico Internet globale. Comprendere l'IPv6 è un requisito fondamentale per lo sviluppo e l'amministrazione delle reti moderne.

== Motivazioni della Transizione a IPv6

La nascita dell'IPv6 è motivata principalmente dal progressivo esaurimento dello spazio di indirizzamento IPv4 (poco più di 4 miliardi di indirizzi). Tale esaurimento è stato causato dalle politiche iniziali di allocazione inefficiente da parte dei Regional Internet Registry (RIR). L'IPv6 è stato progettato basandosi su quattro pilastri architetturali:
+ *Spazio di indirizzamento esteso*: fornisce un numero di indirizzi teorico pari a $2^128$, consentendo un'allocazione capillare e logica.
+ *Superamento del NAT*: ripristina il paradigma *end-to-end* originario di Internet, in cui ogni host possiede un indirizzo IP globalmente univoco, eliminando le violazioni del principio di *information hiding* introdotte dal Network Address Translation.
+ *Semplificazione dell'Header*: ottimizza l'elaborazione dei pacchetti da parte dei router di transito.
+ *Autoconfigurazione nativa (SLAAC)*: permette ai dispositivi di acquisire autonomamente i parametri di rete senza necessitare di server DHCPv6, sebbene con implicazioni di sicurezza da valutare.

Sul piano storico, l'IPv6 è stato standardizzato nella seconda metà degli anni '90 e l'esaurimento dei pool di indirizzi IPv4 gestiti dalla IANA si è concretizzato tra il 2011 e il 2012. Ciononostante, l'adozione è stata lenta e disomogenea, poiché dipende dai grandi ISP e non dai singoli utenti finali.

Nonostante l'enorme spesa operativa (OPEX) richiesta agli Internet Service Provider (ISP) per il mantenimento di infrastrutture *Dual Stack*, la transizione è oggi accelerata dai costi insostenibili dei Carrier-Grade NAT (CG-NAT) per l'IPv4 e dai requisiti architetturali delle Core Network 5G Standalone (SA), le quali operano esclusivamente su IPv6.

== Semplificazione dell'Header e Prestazioni

Una delle maggiori inefficienze dell'IPv4 è l'header a dimensione variabile (da 20 a 60 byte) e la presenza del campo Checksum, che costringe ogni router a ricalcolare l'integrità del pacchetto a ogni salto (*hop*). Ogni singolo router su Internet, per ogni pacchetto, deve:
- Leggere un campo per calcolare la lunghezza dell'header.
- Allocare memoria di conseguenza.
- Ricalcolare l'intero Checksum, altrimenti il pacchetto viene scartato.

In IPv6, l'header principale è stato fissato a una dimensione costante di *40 byte* e il Checksum è stato eliminato (delegando il controllo di integrità ai livelli datalink e di trasporto, data l'alta affidabilità dei mezzi trasmissivi odierni come la fibra ottica). Le opzioni aggiuntive sono state delegate a strutture separate denominate *Extension Headers*. Un router *intermedio* analizza esclusivamente l'header fisso; se il campo `Next Header` indica un protocollo di livello superiore (TCP, UDP...) o un'estensione non pertinente al routing nodo-a-nodo, il router inoltra il pacchetto sfruttando percorsi di commutazione accelerati via hardware (*Fast Path*), ovvero ignora gli header successivi e inoltra. Se invece vale zero, significa che subito dopo c'è un Hop-by-Hop Extension Header che deve essere analizzato da ogni router sul percorso.

#figure(image("images/2026-07-11-12-45-02.png", width: 70%), caption: "Differenze tra header IPv4 e IPv6.")

== Classificazione degli Indirizzi IPv6

La notazione degli indirizzi IPv6 utilizza una rappresentazione esadecimale a gruppi separati da due punti (es. `2001:0db8:85a3::8a2e:0370:7334`), in cui la doppia coppia di due punti (`::`) abbrevia una sequenza contigua di zeri (e può comparire *una sola volta* per indirizzo, altrimenti risulterebbe ambigua). Negli URL l'indirizzo va racchiuso tra parentesi quadre (es. `http://[2001:db8::1]`). Il prefisso `2001:db8::/32` è riservato alla documentazione e non è instradabile in produzione. La struttura tipologica è altamente razionalizzata.

Rientrano tra i tipi di indirizzo *Unicast* (comunicazione uno a uno):

- *Global Unicast (`2000::/3`)*: indirizzi pubblici, instradabili a livello globale. Garantiscono l'univocità dell'host su Internet. Al fine di mitigare i rischi di tracciamento (privacy), i sistemi operativi moderni generano ciclicamente indirizzi Global Unicast temporanei per la navigazione.

- *Link-Local Unicast (`fe80::/10`)*: indirizzi generati automaticamente da ogni interfaccia di rete. Hanno validità strettamente confinata al segmento di rete locale e non vengono mai inoltrati dai router. Utili per permettere la comunicazione senza un indirizzo globale.

- *Unique Local (ULA) (`fc00::/7`)*: analoghi agli indirizzi IP privati dell'IPv4, pensati per reti isolate (l'uso combinato con il NAT66 (IPv6-to-IPv6 NAT) è fortemente sconsigliato).

Esistono poi degli *indirizzi speciali*, che non rappresentano una normale destinazione unicast:

- *Unspecified (`::/128`)*: indirizzo composto da soli zeri, che indica l'*assenza di un indirizzo*. Non è assegnabile a un'interfaccia ed è impiegato esclusivamente in contesti di inizializzazione (es. come indirizzo sorgente durante il DAD).

- *Loopback (`::1/128`)*: equivalente all'indirizzo localhost `127.0.0.1` dell'IPv4.

Altre tipologie di indirizzi sono:
- *Multicast (`ff00::/8`)*: l'IPv6 abbandona completamente il concetto di Broadcast a favore del Multicast, in questo modo è possibile inviare pacchetti a più destinatari simultaneamente. La struttura di un indirizzo Multicast è `1111 1111` (il primo byte, `ff`) seguito da 4 bit di *Flag* e 4 bit di *Scope*: è quest'ultimo campo (il nibble basso del secondo byte) a definire l'ambito di validità, ovvero quanto lontano può arrivare il pacchetto (es. `ff02` per il link-local). Gruppi multicast, identificati dall'ultimo pezzo, notevoli includono l'*All-nodes* (`ff02::1`) e l'*All-routers* (`ff02::2`).
  #observation(multiple: true)[
    + Perché si usa quasi solo l'`ff02`? Perché fare routing Multicast a livello globale (usando protocolli come il *PIM Sparse Mode*) è un incubo ingegneristico. Il Multicast locale, invece, è comodo, sicuro e non appesantisce i router.
    + I driver delle schede di rete possono filtrare i pacchetti a livello hardware, evitando di interrompere la CPU per il traffico non di competenza. Questo permette di filtrare efficientemente i pacchetti in base al loro scope. A livello datalink, un indirizzo Multicast IPv6 viene tradotto in un indirizzo MAC che unisce il prefisso fisso `33:33` agli ultimi 32 bit (4 byte) dell'indirizzo Multicast, così che la scheda di rete possa decidere in hardware se il pacchetto la riguarda.
  ]

- *Anycast*: indirizzi sintatticamente indistinguibili dai Global Unicast, ma assegnati a interfacce appartenenti a nodi differenti. La rete instrada i pacchetti verso il nodo Anycast topologicamente più prossimo al mittente.

== Autoconfigurazione, NDP e Superamento delle Subnet

L'IPv6 introduce il concetto di *scope*, ovvero per quanta distanza, in termini di hop, l'indirizzo continua ad avere _senso_. La crittografia è solo uno strumento. Una delle basi della sicurezza di rete è la definizione delle cosiddette "zone di sicurezza": aree della rete in cui i dispositivi condividono le stesse esigenze e regole. Ad esempio, la rete a disposizione degli studenti universitari non può avere gli stessi privilegi della rete della segreteria amministrativa. Se uno studente fa danni, non possiamo licenziarlo; se lo fa un dipendente, sì. Di solito, per separare queste zone si usano i firewall (oltre a tecniche più moderne come lo Zero Trust). Ma c'è un metodo ancora più basilare e drastico per isolare due zone: usare indirizzi con uno scope incompatibile. Se la zona A e la zona B usano entrambe solo indirizzi link local, e in mezzo c'è un router, le due zone non potranno mai comunicare. Il router semplicemente non instraderà i pacchetti. Originariamente, l'idea degli indirizzi site local o organization local serviva proprio a questo: creare isolamento a livello di protocollo. Alla fine, però, questi indirizzi sono stati abbandonati perché gli amministratori di rete trovavano molto più logico, flessibile e naturale assegnare indirizzi globali a tutti e usare i firewall per gestire chi potesse parlare con chi.

Dopo l'avvio della scheda di rete, si avvia la configurazione dello stack IPv6. Come prima cosa, viene creato un indirizzo link local `fe80::/10`.

#figure(image("images/2026-07-09-11-32-01.png", width: 70%), caption: "Struttura indirizzo Link-Local")
L'*interface ID* può essere costruito in diversi modi:
- usando indirizzi MAC a 64 bit
- usando indirizzi MAC a 48 bit ed espandendoli nel formato EUI-64 a 64 bit
- via DHCP
- manualmente
- randomicamente
- con crittografia (CGA)

Il metodo più comune è quello di utilizzare l'indirizzo MAC. Nel caso di un indirizzo a 48 bit, lo si trasforma in un Extended Unique Identifier a 64 bit nel seguente modo:
#figure(image("images/2026-06-23-22-04-53.png", width: 60%), caption: "MAC sopra, IPv6 sotto")
#example()[
  L'indirizzo MAC `00:1f:5b:39:67:3c` viene convertito in `021f:5bff:fe39:673c`.
]

Ogni interfaccia di rete possiede *almeno* tre indirizzi IPv6 ma potenzialmente anche di più:
- Indirizzo di loobpack (`::1/128`)
- Indirizzo Link Local (`FE80::xx:yy:zz:kk` dove `xx:yy:zz:kk` proviene dal MAC)
- Indirizzo Global Unicast
- Indirizzo All-Nodes Multicast (`FF02::1`)
- Indirizzo All-Routers Multicast (`FF02::2`) se è un router
- Indirizzo Solicited-Node Multicast (`FF02::1:FF00:0000/104`) se in autoconfigurazione

L'IPv6 rivoluziona la gestione delle reti locali. Il concetto di *Subnet Mask* (Netmask) utilizzato in IPv4 per dedurre se un destinatario risiede sulla medesima rete fisica viene eliminato.

=== SLAAC
#figure(image("images/2026-06-24-17-08-26.png", width: 50%))

Lo *SLAAC* (Stateless Address Auto Configuration) è il meccanismo di autoconfigurazione di IPv6. Permette a due o più host, connessi anche da solo un cavo tra loro, che utilizzano IPv6 di ottenere automaticamente un indirizzo IP senza la presenza di un router. L'intero processo è basato sul protocollo *NDP* (Neighbor Discovery Protocol) che a sua volta incapsulata pacchetti ICMPv6. Il NDP sostituisce il protocollo ARP dell'IPv4, permettendo quindi di risolvere anche gli indirizzi MAC. Il NDP definisce cinque (ma ne vedremo quattro) tipologie di messaggi:

+ *Router Solicitation (RS)*: un host che fa uso di SLAAC, invierà automaticamente sulla rete dei pacchetti RS. Questi pacchetti servono per "sollecitare" eventuali router nella rete a presentarsi con il proprio IP in modo tale che l'host conosca il loro indirizzo. Nell'immagine sottostante si può notare come il PC1 invia un pacchetto RS contenente il proprio indirizzo IP (link-local autogenerato da MAC) e specificando come indirizzo di destinazione l'indirizzo *All-Routers Multicast*. In questo modo, soltanto i router considereranno questo pacchetto. Il tipo per RS è 133.
  #figure(image("images/2026-06-24-17-31-14.png", width: 50%))

+ *Router Advertisement (RA)*: i router rispondono a pacchetti RS oppure inviano periodicamente pacchetti RA per annunciare la loro presenza. All'interno è possibile trovare l'indirizzo IPv6 del router, il prefisso che viene utilizzato su quel segmento di rete così come la lunghezza del prefisso e altri parametri utili come l'MTU (Maximum Transfer Unit) o il Router Lifetime (per quanto le informazioni inviate sono da supporre valide). Attraverso il blocco *Prefix Information Option (PIO)*, contenuto nel campo Options... nei messaggi RA, il router utilizza il *Flag L (On-Link)* per comunicare agli host se un determinato prefisso risiede sulla stessa rete fisica. Questo disaccoppiamento logico permette topologie dinamiche e la coesistenza di prefissi multipli sullo stesso dominio di collisione.
  #figure(image("images/2026-06-24-17-37-24.png", width: 50%))
  #figure(image("images/2026-06-23-19-23-29.png", width: 50%), caption: "Pacchetto RA")
  #figure(image("images/2026-06-23-21-23-48.png", width: 50%), caption: "Pacchetto Prefix Information")

  #observation()[
    La specifica originale dei Router Advertisement non prevedeva l'annuncio dei server DNS, aggiunto solo in un secondo momento tramite l'opzione *RDNSS*. Con dispositivi datati o mal implementati è quindi possibile ottenere un indirizzo IPv6 valido ma nessun server DNS, restando di fatto impossibilitati a navigare.
  ]

+ *Neighbor Solicitation (NS)*: i messaggi NS sono simili al protocollo ARP in IPv4. Vengono utilizzati per controllare la disponibilità di un host e anche per il *DAD* (Duplicate Address Detection). L'indirizzo sorgente può essere link-local oppure non specificato (`::/128`) se si sta eseguendo il DAD. L'indirizzo di destinazione è invece il *Solicited-Node Multicast*. Il tipo è 135.
  #figure(image("images/2026-06-24-17-52-57.png", width: 50%))

+ *Neighbor Advertisement (NA)*: i messaggi NA vengono inviati in risposta ai NS oppure per comunicare che un indirizzo è cambiato. L'indirizzo sorgente è quello dell'host che invia il messaggio. L'indirizzo di destinazione può essere link-local (se sta rispondendo ad un NS) oppure *All-Nodes Multicast* se si vuole comunicare un cambio di indirizzo. Il tipo è 136.
  #figure(image("images/2026-06-24-17-53-12.png", width: 50%))

=== Duplicate Address Detection (DAD)

Al momento dell'autoconfigurazione dell'Interface ID (generato ad esempio tramite EUI-64 o meccanismi randomizzati), il dispositivo deve validarne l'univocità tramite il *DAD*. Questo processo invia una *Neighbor Solicitation* per l'indirizzo appena calcolato e attende una replica. Poiché il DAD si basa su un approccio "silenzio-assenso" (se scade il timer senza risposte, l'IP viene assunto libero), in reti wireless affollate o rumorose eventuali pacchetti persi possono portare a collisioni di IP, causando disservizi complessi e non facilmente rilevabili dagli switch di Livello 2.

=== No more subnets
L'IPv4 ha abituato al concetto di Subnet (sottorete) e di Netmask. In IPv4, per capire se un altro dispositivo è sulla stessa rete locale (e quindi se è possibile parlargli direttamente senza passare dal router), si esegue una semplice operazione di AND logico tra il proprio IP, l'IP di destinazione e la Netmask. Se i risultati coincidono, i due dispositivi si trovano nella stessa subnet. Questo meccanismo, però, si rompe in modo catastrofico se due computer hanno Netmask configurate in modo diverso (es. uno ha /24 e l'altro /16).

In IPv6, la Netmask non esiste più. La lunghezza del prefisso (es. /64) non è una Netmask. E allora, come si fa a sapere se un indirizzo IPv6 è nella propria rete locale (on-link) o se bisogna passare dal router (off-link)?
Semplice: non si fa. La risposta deve essere fornita esplicitamente dal router.

Quando un router IPv6 invia un Router Advertisement, all'interno del pacchetto c'è un blocco chiamato PIO (Prefix Information Object). Questo PIO contiene il prefisso (es. `2001:db8::/64`) e una serie di bit (flag). Uno di questi è il bit `L` (On-Link).

- Se il bit `L` è a 1, il router comunica che tutti gli host che usano questo prefisso sono collegati fisicamente alla stessa rete locale dell'host, che può quindi contattarli direttamente.

- Se il bit `L` è a 0, il router comunica che, anche se questi host hanno lo stesso prefisso, non si trovano nella rete locale dell'host: i pacchetti devono essere inviati al router, che si occuperà di instradarli.

- Se non è stato ricevuto nessun Router Advertisement, di default qualsiasi indirizzo (tranne i Link-Local) è considerato off-link. Tutto il traffico verrà inviato al Default Gateway.

Ma cosa succede se un pacchetto viene inviato al router per un dispositivo che in realtà è fisicamente connesso allo stesso switch? Il router IPv6 lo inoltrerà al dispositivo corretto, ma subito dopo manderà indietro un messaggio ICMPv6 chiamato Redirect. Con questo messaggio, il router comunica che il mittente e quel destinatario specifico sono on-link e che dovrebbero parlarsi direttamente la prossima volta. In questo modo, il concetto di "rete locale" diventa dinamico e non è più vincolato rigidamente ai blocchi IP.

Questa flessibilità permette configurazioni che in IPv4 sarebbero state assurde. Due computer possono essere collegati allo stesso switch pur avendo prefissi IP completamente diversi, e il router potrebbe dire a entrambi che sono on-link per certi indirizzi e off-link per altri.

#example()[
  Un esempio pratico: l'Internet delle Cose (IoT). Si supponga di avere in casa una rete Wi-Fi/Ethernet e un gateway Zigbee/Thread per dispositivi IoT (lampadine, sensori). I dispositivi Zigbee non hanno il MAC address a 48 bit del Wi-Fi, quindi non è possibile fare un bridge diretto tra le due reti. Il gateway deve per forza fare da router.
  In IPv6, invece di impazzire creando sottoreti complesse, è possibile assegnare a tutta la casa e a tutta la rete IoT lo stesso identico prefisso /64. Per farlo funzionare, si configura il router principale in modo che dichiari quel prefisso come off-link (bit `L=0`). A quel punto, i computer Wi-Fi della casa invieranno i pacchetti destinati all'IoT al router principale; quest'ultimo, sapendo dove si trova il gateway Zigbee, instraderà i pacchetti a lui. È complicato all'inizio, ma sul lungo periodo scala infinitamente meglio rispetto all'uso disordinato di IP locali.
]


== DHCPv6

E il DHCP in tutto questo? In IPv6 il suo ruolo cambia. Viene usato solo se il router lo impone. Nel Router Advertisement ci sono altri due flag importanti:

- Il bit `M` (Managed): se è a 1, il router indica di usare il server DHCPv6 per ottenere l'indirizzo IPv6.

- Il bit `O` (Other): se è a 1, il router indica di usare l'autoconfigurazione per generare l'indirizzo IP, ma di richiedere al server DHCPv6 le altre configurazioni accessorie (es. i server DNS, il dominio di ricerca).

Inoltre, il DHCPv6 non identifica i client tramite il MAC address. Dato che oggi i dispositivi cambiano MAC address di continuo per ragioni di privacy (MAC randomization), usare il MAC manderebbe in tilt il server DHCP. Invece, si usa il *DUID* (DHCP Unique Identifier). Il DUID viene generato dal sistema operativo, di solito fondendo il MAC address originario e altri parametri, e rimane fisso e costante nel tempo, garantendo al server DHCP di riconoscere sempre lo stesso client.

== Frammentazione e Path MTU Discovery
Ogni rete fisica ha una dimensione massima per i pacchetti (es. 1500 byte per Ethernet). In IPv4, se un pacchetto arriva a un router intermedio e la rete successiva ha una MTU più piccola (es. 1492 byte per via di incapsulamenti PPPoE come nelle vecchie ADSL), il router "taglia" il pacchetto in due frammenti usando i campi di frammentazione dell'header IPv4. Questo crea un sovraccarico di lavoro (overhead) enorme per il router, che deve ricalcolare il Checksum e gestire la suddivisione.

In IPv6, la regola è drastica: i router intermedi non frammentano mai i pacchetti.
Se un router IPv6 riceve un pacchetto troppo grande per la rete successiva, lo scarta e manda indietro un messaggio ICMPv6 di errore chiamato *Packet Too Big*. Questo messaggio contiene la dimensione dell'MTU consentita. Il nodo sorgente riceve l'errore e aggiorna il suo Path MTU (PMTU) per quella specifica destinazione. Da quel momento in poi, sarà il nodo sorgente (e solo lui) a generare pacchetti più piccoli, inserendo un Extension Header di frammentazione se necessario.

Questo sistema è infinitamente più efficiente per i router di dorsale, ma ha un punto debole mortale: gli amministratori di rete incompetenti. Spesso chi configura i firewall blocca totalmente il traffico ICMP, credendo di aumentare la sicurezza ("così non mi pingano!"). In IPv6, se si blocca l'ICMP, si bloccano anche i messaggi Packet Too Big. Il nodo sorgente non saprà mai perché i suoi pacchetti vengono scartati e la connessione andrà in stallo senza spiegazioni (i famosi "buchi neri" di rete).

Infine, una salvaguardia imposta dall'IPv6: lo standard vieta l'esistenza di link con MTU inferiore a 1280 byte. Mentre in IPv4 potevano esistere reti con payload piccolissimi (ignorando il consiglio teorico dei 576 byte), in IPv6 il limite di 1280 byte è legge.
E cosa succede con reti come il Bluetooth, LoRa o Zigbee (IEEE 802.15.4), che hanno MTU a livello fisico minuscole (spesso inferiori ai 100 byte)? Semplice: devono usare un Adaptation Layer (uno strato software intermedio, come 6LoWPAN) che si occupa di comprimere l'header IPv6 e gestire una frammentazione invisibile al livello IP superiore, garantendo all'IPv6 di vedere sempre e comunque i suoi 1280 byte garantiti.
#pagebreak()

= Sicurezza delle Reti (Cybersecurity)

L'introduzione di nuovi protocolli impone una rigorosa analisi delle minacce (*Threat Analysis*). La Cybersecurity non mira alla creazione di sistemi invulnerabili, ma alla riduzione del rischio a un livello operativamente ed economicamente accettabile. Un'analisi strutturata deve rispondere a tre quesiti:
+ *Cosa* si sta proteggendo (asset: dati, hardware, software).
+ *Da chi* e *da quali vettori* ci si protegge.
+ *Perché* lo si protegge (Requisiti normativi, business continuity, incolumità fisica).

L'aggiunta indiscriminata di layer di sicurezza (es. cifratura ovunque) aumenta esponenzialmente la complessità architetturale. Un sistema eccessivamente complesso è prono a difetti di configurazione (misconfigurations) e spesso spinge gli utenti ad aggirare le policy di sicurezza per preservare l'usabilità.

L'isolamento delle zone di sicurezza, storicamente gestito tramite indirizzi IP appositi (come i deprecati *site-local*), oggi viene implementato a livello di architettura di rete (VLAN) o tramite firewall avanzati e policy di *Zero Trust*.

== Tipologie di Vulnerabilità

Le vulnerabilità dei protocolli di rete derivano tipicamente da tre categorie di errori:

+ *Vulnerabilità "By Design"*: compromessi architetturali accettati in fase di standardizzazione per privilegiare l'efficienza. Un esempio è l'ARP spoofing in IPv4 (o l'NDP spoofing in IPv6), che sfrutta l'assenza intrinseca di autenticazione nei messaggi di risoluzione degli indirizzi. La mitigazione di queste vulnerabilità è demandata all'applicazione di policy descritte nei manuali (es. *Dynamic ARP Inspection* sugli switch).

+ *Vulnerabilità "Bad Implementation" o "Bad Deployment"*: difetti introdotti durante lo sviluppo del codice sorgente o durante la configurazione dell'infrastruttura. Tali difetti sono il veicolo principale dei moderni *Supply Chain Attack*.

+ *Vulnerabilità "Bad Design"*: errori concettuali severi. Un esempio storico è il protocollo Wi-Fi *WEP*, compromesso in modo irrecuperabile a livello progettuale: l'unica soluzione è stata abbandonarlo in favore di WPA e dei suoi successori (WPA2, WPA3). Un altro esempio si riscontra nel *TCP Window Scaling*. Il protocollo TCP chiude le sessioni anomale tramite pacchetti con flag `RST` validi solo se recanti il corretto `Sequence Number` (spazio a 32 bit). L'introduzione del Window Scaling (per massimizzare il throughput su reti veloci) ha allargato a dismisura la finestra dei pacchetti accettabili. Questo ha abbattuto lo spazio di entropia necessario a un attaccante per eseguire un attacco *TCP Reset Spoofing* cieco: sono sufficienti pochissimi pacchetti per intercettare la finestra valida e abbattere la connessione. La mitigazione implementata successivamente ha imposto restrizioni rigide: un router deve accettare un flag `RST` solo se il Sequence Number è esatto, senza margini di tolleranza, rigettando i valori generici all'interno della finestra.

#pagebreak()

= Il Routing
Il *routing* all'interno di una rete si divide principalmente in due paradigmi architetturali:
- *Centralizzato*: un controllore globale possiede una mappatura onnisciente della topologia di rete (similmente a un navigatore satellitare) e determina a priori i percorsi ottimali per tutti i nodi.
- *Distribuito*: ogni router deduce autonomamente il nodo successivo ("next hop") ideale basandosi su informazioni di stato locale e sullo scambio di dati con i nodi adiacenti.

Per garantire elevati standard di resilienza, l'infrastruttura di Internet adotta il routing distribuito: in caso di guasto hardware o indisponibilità di un nodo, i router limitrofi sono in grado di ricalcolare dinamicamente un percorso alternativo. Su scala globale, un sistema centralizzato introdurrebbe un *single point of failure* critico, generando inoltre un overhead di comunicazioni di controllo incompatibile con le capacità della rete.
Esiste teoricamente il *Source Routing*, una tecnica in cui l'host mittente codifica all'interno del pacchetto l'elenco esatto dei nodi da attraversare. Tale approccio è oggi rigorosamente interdetto sull'Internet pubblica per gravissime implicazioni di sicurezza informatica, in quanto consentirebbe a un attaccante di offuscare l'origine reale del traffico forzandone il rimbalzo su nodi arbitrari.

I protocolli di routing distribuito si classificano ulteriormente in:
- *Proattivi*: il protocollo opera in *background* calcolando e aggiornando costantemente le tabelle di routing, indipendentemente dal traffico effettivo. Garantisce instradamenti immediati, ma consuma banda ininterrottamente.
- *Reattivi*: l'esplorazione del percorso viene innescata esclusivamente *on-demand*, ovvero nel momento in cui si presenta la necessità di trasmettere un pacchetto.
- *Flooding*: il pacchetto viene replicato e inoltrato su tutte le interfacce disponibili, nella probabilità statistica di raggiungere prima o poi il destinatario. Pur essendo dispendioso in termini di risorse, in contesti di assoluta emergenza (o per reti fortemente instabili) rappresenta la strategia d'inoltro più robusta, se opportunamente controllata.

La scelta del paradigma di routing dipende in larga misura dalla volatilità della topologia di rete. In uno scenario caratterizzato da instabilità dei link fisici (frequenti disconnessioni o variazioni), un protocollo proattivo inonderebbe la rete di messaggi di aggiornamento a ogni singola fluttuazione. In contesti dove il volume del traffico dati è contenuto ma la topologia è altamente dinamica, l'approccio reattivo si rivela di gran lunga più efficiente.
Tuttavia, qualora la mutevolezza della rete sia talmente elevata da rendere obsoleto il percorso reattivo ancor prima della sua completa instaurazione, la topologia collassa e l'unica strategia d'inoltro in grado di garantire il recapito del pacchetto rimane il *flooding*.

I protocolli sono inoltre classificati in base a come si scambiano informazioni:
- *Distance-Vector*: ogni router può scambiare informazioni soltanto con i suoi router vicini. Ogni router contiene al suo interno una tabella "Vettore delle distanze" che associa ad un'interfaccia un costo in termini di hop. I router non conoscono l'intera topologia della rete.
- *Link-State*: ogni router invia informazioni a tutte le reti direttamente connesse in broadcast su ogni interfaccia tranne quella di origine. Sono algoritmi lenti a convergere e che richiedono molta memoria e potenza di calcolo.
#figure(image("images/2026-07-03-23-59-56.png"))

== La Complessità del Routing
Da un punto di vista puramente matematico, il routing è assimilabile alla ricerca del cammino minimo all'interno di un grafo pesato. Tuttavia, mentre la teoria dei grafi garantisce la calcolabilità dell'ottimo teorico, l'applicazione ingegneristica è vincolata ai limiti fisici, ai tempi di latenza e all'hardware degli apparati di rete. _I protocolli reali costituiscono dunque approssimazioni dell'ottimo matematico_.

Si considerino, ad esempio, approcci limite come l'*Hot Potato Routing* (in cui un pacchetto viene immediatamente smistato a un vicino casuale pur di svuotare i buffer). Questo paradigma trova fondamento razionale nelle reti "Full Optical": in queste architetture, il tempo necessario per la conversione elettro-ottica (fondamentale per leggere l'header del pacchetto e interrogare la tabella di routing) risulta nettamente superiore al tempo di propagazione fisica. Di conseguenza, in una topologia fortemente magliata, l'inoltro cieco può paradossalmente garantire latenze inferiori rispetto a un'elaborazione del percorso ottimo. Ciò dimostra come la progettazione algoritmica debba sempre integrarsi con le specificità dello strato fisico.

== Metriche e Pesi di Instradamento
La modellazione algoritmica prevede l'assegnazione di "pesi" agli archi del grafo (i link di rete). A livello matematico, qualsiasi parametro di penalità imputabile a un nodo (es. probabilità di congestione) può essere formalmente traslato sui suoi archi incidenti.

La selezione della metrica ottimale è uno dei temi più critici. Una valutazione puramente teorica porterebbe a favorire concetti quali la larghezza di banda residua, ideale per l'instradamento di trasferimenti *Delay-Tolerant*. Viceversa, per i flussi in tempo reale (*Real-Time flows* come lo streaming video o il gaming), la larghezza di banda assoluta perde rilevanza rispetto alla minimizzazione del *jitter* (la varianza del ritardo di trasmissione). Un ritardo di rete costante può essere facilmente assorbito mediante un buffer di riproduzione, mentre fluttuazioni costanti generano disservizi inaccettabili.

Ciò nonostante, l'inclusione di metriche dinamiche (congestione, latenza o jitter) all'interno dei pesi algoritmici genera gravi esiti applicativi. Poiché i valori misurati su una rete in attività oscillano a frequenze altissime, i protocolli innescherebbero variazioni continue delle rotte (effetto di instabilità noto come *route flapping*), rincorrendo gradienti transitori privi di significato statistico a lungo termine.

A livello accademico è stata storicamente analizzata l'*Expected Transmission Count* (ETX) per le reti wireless, che stima la qualità del link in base al numero di ritrasmissioni necessarie per recapitare un pacchetto. Il limite strutturale di questa metrica è la necessità pregressa di traffico per la validazione statistica: in assenza di traffico, il router non dispone di dati. L'introduzione della sua variante speculativa, denominata *Optimistic ETX* (che in assenza di trasmissioni recenti assume ottimisticamente il link come privo di errori), portò i router a convergere disastrosamente verso percorsi instabili o interrotti, causando gravi colli di bottiglia.

Di conseguenza, le soluzioni *enterprise* adottano quasi esclusivamente metriche statiche o semi-statiche: il conteggio dei salti (*hop count*) o la capacità trasmissiva nominale dell'arco. L'unico parametro dinamico raccomandabile, prettamente in ambito wireless, è il Rapporto Segnale-Rumore (SNR), la cui varianza fisica è predicibile e non dipende direttamente dal carico di traffico istantaneo.

== RIP (Routing Information Protocol)
Tra i protocolli proattivi basati sui vettori di distanza, il *RIP* rappresenta lo standard di riferimento per la sua semplicità architetturale. Il funzionamento prevede che ciascun router trasmetta la propria tabella di routing completa ai soli nodi adiacenti a intervalli regolari (tipicamente ogni 30 secondi), o in modalità *triggered update* a seguito di variazioni di stato.
Alla ricezione di una tabella, il router ricevente incrementa le metriche (quantificate in numero di *hop*) di un'unità. Se l'elaborazione evidenzia un costo cumulativo inferiore per una destinazione nota, il router aggiorna la propria tabella eleggendo il mittente come nuovo "Next Hop".

- Dopo che il router si è avviato correttamente, applica la configurazione salvata e rileva inizialmente le proprie reti connesse direttamente. Quindi aggiunge gli indirizzi IP dell'interfaccia collegata direttamente alla sua tabella di instradamento.
  #figure(image("images/2026-07-03-23-48-16.png", width: 60%))

- Se viene configurato un protocollo di routing, il router scambia gli aggiornamenti di routing per conoscere eventuali percorsi remoti. Il router invia un pacchetto di aggiornamento con le informazioni sulla tabella di routing su tutte le interfacce. Il router riceve anche gli aggiornamenti dai router connessi direttamente e aggiunge nuove informazioni alla sua tabella di routing.
  #figure(image("images/2026-07-03-23-48-24.png", width: 50%))

- I router si scambiano le informazioni attraverso aggiornamenti periodici. I protocolli di routing Distance Vector utilizzano la tecnica Split horizon per evitare loop. Split horizon impedisce che le informazioni vengano inviate dalla stessa interfaccia da cui sono state ricevute.
  #figure(image("images/2026-07-03-23-48-32.png", width: 50%))

- Quando tutti i router dispongono di informazioni complete e accurate sull'intera rete, allora l’algoritmo di rete arriva alla convergenza, cioè le tabelle di routing sono stabili. Si dice tempo di convergenza il tempo impiegato dai router per condividere le informazioni, calcolare i percorsi migliori e aggiornare le tabelle di instradamento. Più veloce è il tempo di convergenza, migliore è il protocollo di routing.
  #figure(image("images/2026-07-03-23-48-39.png", width: 50%))

A livello distribuito, il RIP implementa l'algoritmo di Bellman-Ford. Pur consentendo l'identificazione del percorso minimo, l'algoritmo presenta una complessità computazionale asintotica pari a $V times E$ (dove $V$ indica il numero di vertici ed $E$ il numero di archi). Ne consegue che il tempo globale di convergenza dell'intera rete risulta teoricamente elevato. Nella realtà ingegneristica, la priorità ricade sul tempo minimo necessario per stabilire un instradamento valido end-to-end, il quale risulta direttamente proporzionale al diametro massimo del grafo di rete, rendendo il protocollo pienamente operativo in pochi minuti.

La sopravvivenza del RIP a scapito di algoritmi più efficienti (come Dijkstra) risiede nei costi computazionali: l'impronta in memoria è quasi nulla (ogni nodo manipola unicamente le metriche relative senza allocare l'intera topologia) e l'aumento della cardinalità dei nodi non satura proporzionalmente i cicli di CPU, garantendo un'altissima scalabilità in termini di risorse hardware.

=== Count to Infinity e Split Horizon

La vulnerabilità principale degli algoritmi di routing *Distance-Vector* (basati sui vettori di distanza) è il noto problema del *Count to Infinity* (conteggio all'infinito). Quando un collegamento fisico cessa di funzionare, i router adiacenti potrebbero condividere tabelle di instradamento ormai obsolete prima che l'informazione sul guasto si sia propagata uniformemente. Questo ritardo di sincronizzazione innesca un loop di instradamento in cui i router continuano ad aggiornarsi a vicenda, incrementando artificialmente e all'infinito il costo per raggiungere una destinazione che, di fatto, è diventata irraggiungibile.

#example("Il problema del Count to Infinity")[
  #figure(image("images/2026-07-12-23-17-01.png"))
  Consideriamo una topologia in cui l'algoritmo di Bellman-Ford ha raggiunto la convergenza. In questa fase di stabilità, ogni router possiede le voci di instradamento corrette: il router B sa di poter raggiungere la rete C con un costo pari a 1, mentre il router A sa di poter raggiungere C passando per B con un costo totale pari a 2.

  #figure(image("images/2026-07-12-23-17-10.png"))
  Se il collegamento tra B e C si interrompe, B rileva il guasto e deduce di non poter più raggiungere C tramite quel link, rimuovendo la rotta dalla propria tabella. Tuttavia, prima che B riesca a inviare un aggiornamento per notificare il guasto, potrebbe ricevere un normale aggiornamento periodico da A. In questo messaggio, A continua ad annunciare (erroneamente) di poter raggiungere C con un costo di 2.
  Poiché B sa di poter raggiungere A con un costo di 1, accetta questa rotta ingannevole credendo che A disponga di un percorso alternativo. B aggiorna così la sua tabella, impostando una rotta verso C via A con un costo pari a 3 (1 + 2). Al ciclo successivo, A riceverà la nuova tabella di B (costo 3) e aggiornerà a sua volta il proprio costo a 4 (1 + 3). I due router continueranno a scambiarsi queste informazioni errate, incrementando la metrica verso l'infinito.
]

Per mitigare e risolvere questa problematica strutturale, i protocolli (come il RIP) implementano specifici accorgimenti algoritmici:

+ *Definizione dell'Infinito*: per impedire che il conteggio prosegua illimitatamente, la metrica massima viene limitata superiormente a un valore prefissato, tipicamente 16 (rappresentabile a livello di bit come lo 0 matematico in una logica binaria a 4 bit). Il raggiungimento di tale soglia sancisce l'immediata irraggiungibilità della rete (*unreachable*), spezzando così il ciclo iterativo.

+ *Split Horizon*: è una regola tassativa di prevenzione dei loop. Stabilisce che un router non deve mai annunciare l'esistenza di una determinata rotta sull'interfaccia di rete dalla quale quella stessa rotta è stata originariamente appresa (es. se A ha imparato da B come arrivare a C, A non dirà mai a B che sa come arrivare a C).
  #figure(image("images/2026-07-12-23-18-01.png"))

+ *Route Poisoning (e Poison Reverse)*: si tratta di un'ottimizzazione aggressiva dello Split Horizon. Anziché omettere in silenzio la rotta, il router annuncia attivamente la rotta compromessa sull'interfaccia da cui l'ha appresa, ma le associa forzatamente e in modo artificiale una metrica infinita (16). In questo modo, la rotta viene istantaneamente ed esplicitamente invalidata per i nodi adiacenti, accelerando drasticamente il tempo di convergenza in caso di guasto.
  #figure(image("images/2026-07-12-23-17-54.png"))

== Il Protocollo OSPF (Open Shortest Path First) e Dijkstra
Contrapposto alla famiglia Distance-Vector, il protocollo OSPF si basa sull'algoritmo di routing Link-State di Dijkstra. Questo garantisce prestazioni teoriche eccellenti in termini di calcolo (la complessità dell'algoritmo è $E + V log V$), ma impone vincoli hardware stringenti: affinché l'albero dei cammini minimi possa essere risolto, ogni router deve prima acquisire e mantenere nella propria memoria l'intera topologia della rete, generata attraverso il costante inoltro incrociato di *Link-State Advertisements* (LSA).

#figure(image("images/2026-07-03-23-55-56.png"))

Questa disseminazione capillare si traduce, in reti molto estese, in un duplice collo di bottiglia: il sovraccarico costante della banda per il traffico LSA e la saturazione dei processori. Ricevuto un aggiornamento topologico, ciascun router è costretto a reiterare l'algoritmo di Dijkstra ripartendo da zero; qualora la CPU non fosse sufficientemente prestante, il calcolo potrebbe essere interrotto dall'arrivo di una nuova notifica LSA, portando il nodo al collasso computazionale.

Di conseguenza, l'OSPF possiede limiti drastici di scalabilità lineare. Il design del protocollo mitiga tale problema compartimentando l'infrastruttura logica in "Aree" gerarchiche. All'interno dell'Area, i router condividono un set topologico unificato ed eleggono specifici router di transito (*Area Border Router*), i quali aggregano e inoltrano il routing unicamente verso la dorsale logica (*Backbone*). Quest'architettura abbatte il carico computazionale, cedendo come contropartita l'ottimalità globale del percorso: la forzatura dell'instradamento sui *Border Router* genera cammini inter-area basati su ottimi puramente locali.

#figure(image("images/2026-07-03-23-57-38.png", width: 60%))

== OSPF, Link-State e Software-Defined Networking (SDN)
Avendo piena visione della topologia di rete, i protocolli Link-State quali l'OSPF consentono l'adozione di metriche algoritmiche sofisticate, a patto di stabilire eque norme di sblocco (*tie-breaker*, come la selezione del router con l'indirizzo IP inferiore in caso di metriche speculari) essenziali per garantire il determinismo e facilitare il *troubleshooting* della rete in fase di analisi.

Tuttavia, configurando l'OSPF per basare le metriche di rotta esclusivamente sulla larghezza di banda nominale, emergono dei limiti di adattabilità dinamica: l'algoritmo instraderebbe il traffico verso percorsi in fibra ad alta capacità sebbene in potenziale stato di saturazione fisica, trascurando link più lenti ma completamente sgombri.

Questa rigidità algoritmica giustifica la migrazione dell'industria verso il paradigma *Software-Defined Networking* (SDN). Nell'architettura SDN, le funzioni del "cervello" dei router (il Control Plane algoritmico come OSPF o RIP) sono delegate a un server di controllo centralizzato (*SDN Controller*), riducendo fisicamente i router a semplici elaboratori di commutazione dei pacchetti (*Data Plane* o *Network Elements*).
Il Controller riceve dati di telemetria dalle infrastrutture, calcola metriche istantanee multi-parametro e sovrascrive le tabelle di inoltro dei vari interruttori sfruttando protocolli di configurazione (*OpenFlow*). A causa delle stringenti necessità di bassa latenza tra le comunicazioni di gestione, l'SDN non scala sull'Internet pubblica, ma rappresenta l'attuale standard progettuale intra-struttura nei Data Center e nelle topologie Cloud/Kubernetes.

== Reti Mesh e IoT
Laddove non via sia un'infrastruttura cablata (es. costellazioni di droni o sistemi di sensori estesi per ambito agricolo), si introducono le *Reti Mesh* (o *Ad-Hoc Networks*). In queste reti destrutturate, il router perde la sua accezione di entità fisica esclusiva, in quanto ogni dispositivo finale agisce simultaneamente da client e nodo di inoltro (multi-hop) basandosi sulla sovrapposizione delle limitate coperture dei moduli radioelettrici.

Il panorama dei protocolli operativi è frammentato: l'offerta include approcci reattivi come l'AODV (che invia query esplorative per tracciare percorsi on-demand), proattivi ottimizzati come l'OLSR, e varianti sperimentali di flooding condizionato come B.A.T.M.A.N. o Meshtastic.

Nel dominio dell'IoT domestico ed enterprise (Smart Home/Alexa), l'assenza di un vero standard universale ha spinto all'adozione del consorzio *Thread*. Paradossalmente, all'interno della rete Thread, la base dei calcoli di instradamento è delegata ad un'architettura derivata dal RIP. Benché in netta contrapposizione alle classiche specifiche del wireless dinamico, la sua implementazione pratica risponde ai requisiti minimi fintantoché la topologia IoT rimane rigidamente stazionaria; a seguito di variazioni topologiche (come la rilocazione di un nodo), l'intera rete mesh si espone al collasso del framework di instradamento.

== Il BGP e il routing tra Autonomous System
I protocolli sinora discussi (RIP, OSPF, AODV) costituiscono *Interior Gateway Protocols* (IGP). L'implementazione e i parametri di un IGP soggiacciono interamente all'entità amministratrice del singolo dominio logico di rete (*Autonomous System* o AS).

#figure(image("images/2026-07-03-23-59-56.png"))

La comunicazione infrastrutturale e di transito fra AS disgiunti richiede invece l'impiego di un *Exterior Gateway Protocol* (EGP). All'atto pratico, l'unico standard di fatto in operatività sull'infrastruttura Internet mondiale è il *Border Gateway Protocol* (BGP). L'insediamento monopolistico del BGP deriva non dall'assoluta eccellenza computazionale del protocollo, ma dall'impossibilità tecnica e infrastrutturale di coordinare una sostituzione sincronizzata dell'ecosistema internet.

#figure(image("images/2026-07-04-00-00-16.png"))

Lo scopo funzionale del BGP disattende l'individuazione di percorsi con metriche matematiche ottime. Il focus algoritmico consiste nel determinare rotte globalmente "fattibili" che aderiscano scrupolosamente agli accordi economici e alle restrizioni burocratico-politiche di *peering* vigenti fra i soggetti amministratori. A titolo esplicativo, un ISP italiano devierà deliberatamente il traffico in transito per il suolo francese via Corsica, malgrado una minore rapidità topologica, in ossequio all'economicità del contratto di interscambio rispetto all'operatore confinante nel Nord Italia.

A livello tecnico, il BGP risolve i propri alberi decisionali non per sommatorie di pesi continui, ma elaborando iterativamente attributi prioritari ordinati in gerarchia rigida (tra cui *Weight*, *Local Preference*, *AS Path*, *MED* e *Community*). Il parametro maggiormente indicativo, l'*AS Path*, computa il numero di sistemi autonomi indipendenti attraversati: un dato di elevata significatività logico-strutturale ma di marginale affinità con l'effettivo calcolo di latenza hardware in millisecondi.

Il BGP configura l'architettura di Internet. Benché lento nell'assimilazione dei ricalcoli di scala intercontinentale (i tempi di convergenza raggiungono ore), esso fornisce all'infrastruttura la stabilità cruciale per il corretto sostentamento globale. Criticamente, in caso di applicazione di configurazioni improprie (causa dei noti *Black Hole* di routing) o restrizioni nazionali ostili, le tabelle decisionali del BGP costituiscono lo strumento cardine per applicare politiche di embargo logico internazionale (una *Splinternet*).
#pagebreak()

= Simulatore
== La Simulazione di Rete
L'altra volta ci siamo lasciati con il problema del routing e oggi chiudiamo il discorso parlando di come si studiano e si validano effettivamente le reti e i protocolli, perché la teoria sui libri è fondamentale, ma l'informatica e le telecomunicazioni richiedono la pratica. Se vi trovate a dover dimostrare che una vostra idea per una tesi funziona, o che una rete aziendale regge il carico, dovete passare all'atto pratico.

Quali sono le vostre scelte?
- Matematica: Usate la teoria delle code, modelli statistici e fate i calcoli. È rigoroso, ma spesso si scontra con limiti di calcolo quando la rete diventa complessa.
- Simulazione: Scrivete del codice che imita il comportamento della rete. In una simulazione il tempo è slegato dalla realtà: il vostro computer potrebbe metterci 5 minuti per simulare 10 secondi di traffico reale, o viceversa, simulare due anni in 5 minuti.
- Emulazione e Hardware in the Loop (Testbed): Qui lavorate in tempo reale (Real-Time). Il software è interfacciato con dispositivi fisici reali, inviando e ricevendo dati come se fosse in produzione.
- Test sul campo (Field Test): Mettete letteralmente le antenne sul tetto, date i dispositivi in mano agli utenti e vedete cosa succede nel mondo reale.

Nessuno di questi approcci è intrinsecamente migliore degli altri: ognuno ha il suo scopo. Il disastro avviene quando si usa lo strumento sbagliato senza averne consapevolezza.

=== Il "Durable Nonsense" e le false assunzioni
Questo ci porta a un concetto fondamentale teorizzato nel 1969 e ancora oggi attualissimo, il "Durable Nonsense". Il Durable Nonsense si verifica quando si produce una ricerca estremamente rigorosa e matematicamente ineccepibile, ma basata su presupposti totalmente fuori dalla realtà. Il risultato è una sciocchezza monumentale ("nonsense") che però, proprio per la sua patina di rigore scientifico, dura nel tempo ("durable") e viene citata per anni. Ad esempio, se studiate in modo impeccabile come avviene il passaggio di connessione Wi-Fi (handover) tra due antenne in un corridoio con pareti di metallo massiccio, la ricerca è formalmente perfetta. Peccato che non esista alcun corridoio in metallo massiccio nella realtà (a parte un rifugio antiatomico). I risultati che otterrete saranno matematicamente veri, ma totalmente inapplicabili. Nel 2001, una famosa ricercatrice di nome Sally Floyd smontò una fetta enorme della ricerca accademica sulle reti dimostrando proprio questo. Fino a quel momento, i simulatori e i modelli matematici assumevano che il traffico Internet (generato dai server web o dalle applicazioni) avesse una distribuzione statistica predicibile e governabile dal Teorema del Limite Centrale (ad esempio, traffico poissoniano o a bitrate costante). Sally Floyd dimostrò, dati reali alla mano, che il traffico Internet ha una natura "frattale" (Self-Similar o a invarianza di scala), con distribuzioni a coda lunga (come Pareto o Weibull) che non possiedono una varianza finita. Se il traffico non rispetta il Teorema del Limite Centrale, significa che aggregando migliaia di utenti, il traffico non si "spiana" su una comoda curva Gaussiana, ma mantiene picchi (spike) spaventosi e imprevedibili. Se progettate la memoria (i buffer) di un router o la banda di una rete usando un modello statistico sbagliato, state creando del Durable Nonsense: la matematica torna, ma il router nella realtà andrà in congestione in cinque minuti.

== Da Matlab ai Discrete-Event Simulators
Come evitiamo di produrre spazzatura? Usando gli strumenti adatti per ogni livello dello stack. Se volete studiare il Livello Fisico (come i segnali elettrici o radio si propagano nell'aria, le modulazioni o le probabilità di errore per bit), usare un simulatore di rete è inutile. Lì la matematica governa suprema: si usano software come Matlab o librerie Python avanzate per processare il segnale. Quando però si sale dal Livello 2 (MAC) fino al Livello 4 (Trasporto) o Applicativo, la matematica pura esplode. Lì servono i Simulatori di Rete a Eventi Discreti (Discrete-Event Simulators), come NS-3.

Cos'è una simulazione a eventi discreti? A differenza dei modelli continui (dove lo stato del sistema viene ricalcolato ogni nanosecondo), in un simulatore a eventi discreti il tempo avanza solo quando "succede qualcosa". Se il nodo A inizia a trasmettere un pacchetto al nodo B al tempo $T_0$, sappiamo che il pacchetto finirà di essere trasmesso al tempo $T_1$ (calcolabile in base alla lunghezza del pacchetto e alla banda). Nel lasso di tempo tra $T_0$ e $T_1$, lo stato del sistema (il cavo o il canale radio) non cambia: è semplicemente "Occupato". Il simulatore quindi non fa nessun calcolo intermedio; inserisce l'evento di "Fine Trasmissione" in una coda cronologica (Scheduler) e "salta" direttamente al momento $T_1$, eseguendo la funzione associata. Questo rende i calcoli computazionalmente leggeri e permette di simulare reti immense. Ovviamente, quanto in dettaglio volete spingervi dipende da voi: volete simulare il tempo preciso di inizio e fine pacchetto per intercettare eventuali collisioni simultanee sul canale, o vi basta simulare che un messaggio astratto è partito ed è arrivato? Più dettagli inserite (come l'ARP, il Neighbor Discovery, o le collisioni a livello fisico), più la simulazione sarà lenta e complessa, ma anche più aderente alla realtà. La vera abilità del ricercatore sta nel capire quali "rumori di fondo" scartare per alleggerire la simulazione, senza alterare la validità dei risultati.

== Simulazione Monte Carlo, Topologie e Affidabilità
Se fate una singola simulazione e funziona, avete dimostrato ben poco. Una simulazione genera solo una istanza di un sistema complesso, vincolata ai semi (seed) del generatore di numeri pseudocasuali che avete impostato. Per avere una vera validità scientifica dovete applicare il Metodo Monte Carlo: ripetere la stessa simulazione decine o centinaia di volte, variando leggermente le condizioni iniziali (i seed, la posizione geografica dei nodi, l'orario di generazione del traffico, i tassi di errore). E non basta variare i numeri: dovreste anche variare, in modo programmato, la topologia della rete. Non potete simulare un protocollo per edifici scolastici mappando alla perfezione l'edificio in cui ci troviamo ora. Quella dimostrerebbe che il protocollo funziona in questo plesso, non in un plesso generico. Dal Metodo Monte Carlo otterrete una nuvola di risultati, da cui dovrete estrarre medie, mediane, varianze e, soprattutto, gli Intervalli di Confidenza. Nel 2026, presentare un grafico senza intervalli di confidenza (o, ancora meglio, senza un "Violin Plot" che mostri chiaramente l'intera distribuzione e l'eventuale multimodalità dei dati) significa farsi deridere dalla comunità scientifica. Se il risultato di un simulatore combacia esattamente al millimetro con il modello teorico matematico, significa semplicemente che nel simulatore avete replicato alla lettera le stesse assunzioni iper-semplificate che avevate fatto sulla carta, rendendo la simulazione un puro e inutile esercizio di stile. La simulazione serve proprio per scoprire come il sistema reagisce quando la teoria pura incontra le imperfezioni e i ritardi (le "code") del mondo reale.

== Come simulare
Quando costruite un simulatore, a livello base (MAC/Livello 2) dovete scrivere codice C++ (o simili) per simulare l'accesso al mezzo (tempi di ritardo, re-trasmissioni CSMA/CD, ecc.), perché è hardware-specifico. Ma quando salite a livello Trasporto, vi trovate davanti a un bivio. Se dovete simulare l'algoritmo QUIC o il TCP:
- Ve lo riscrivete da zero: Ci perdete 6 mesi, commettete errori, ma avete il controllo totale per modificare ogni singola virgola dell'algoritmo per i vostri esperimenti.
- Usate una libreria reale (es. PicoQUIC o l'implementazione del TCP di Linux): La integrate direttamente nel simulatore tramite wrapper. Funzionerà perfettamente, ma se dovete "bucare" la logica interna della libreria per testare una variante del protocollo, sarà molto più ostico.

La scelta dipende dalle vostre capacità ingegneristiche e dall'obiettivo della vostra ricerca. In ogni caso, i simulatori di rete moderni sono giganteschi capolavori di ingegneria del software (Spesso Open Source) basati su pattern e architetture scalabili. Anche se non farete mai ricerca accademica, approcciarsi allo sviluppo o alla modifica di un simulatore come NS-3 è una scuola di programmazione di livello assoluto.
