#import "../../../dvd.typ": *

= Introduzione

== Topologia
La struttura di una rete può essere analizzata sotto diversi punti di vista:

- *Topologia fisica*: Come sono connessi fisicamente i dispositivi (cavi, fibra, collegamenti radio). Riguarda l'hardware.
- *Topologia IP (Logica)*: Come fluiscono i dati attraverso la rete basandosi sull'indirizzamento IP e le decisioni di routing. Non sempre rispecchia la topologia fisica.
- *Topologia application-level*: Come comunicano le applicazioni (es. reti Overlay, P2P, CDN).

== Internet 101
Le idee alla base di Internet si diffusero intorno agli anni sessanta. Non è stato creato dal nulla, ma costruito passo dopo passo (approccio incrementale). Sebbene finanziato inizialmente dal Dipartimento della Difesa USA (progetto ARPANET), il suo sviluppo è stato guidato principalmente dai centri di ricerca nazionali e universitari.

Nonostante l'ambizione del progetto, il successo è dovuto a una combinazione di fattori chiave:

- *Economico*: Basato su standard aperti e gratuiti. Non c'era bisogno di pagare royalties per implementare i protocolli (a differenza di tecnologie proprietarie dell'epoca).
- *Tecnico*:
  - *Packet Switching*: Maggiore resilienza e utilizzo efficiente della banda rispetto alla commutazione di circuito.
  - *Principio End-to-End*: La rete è "stupida" (si occupa solo di spostare pacchetti) e l'intelligenza è ai bordi (negli host).
  - *Best Effort*: La rete tenta di consegnare i pacchetti, ma non garantisce affidabilità assoluta (gestita dai livelli superiori, es. TCP).
- *Facilità d'uso (per l'epoca)*: Pensato "da sviluppatori per sviluppatori", permettendo una rapida innovazione.
- *Politico*: Le compagnie di telecomunicazioni tradizionali (es. SIP in Italia, AT&T in USA) negli anni '60-'70 si concentrarono sulla telefonia vocale (commutazione di circuito), sottovalutando la trasmissione dati e lasciando campo libero alla ricerca accademica.

#definition("Internet")[
  Internet *non* è una singola rete fisica. È l'*inter-connessione* logica di un enorme numero di reti eterogenee.
]

=== Caratteristiche fondamentali
- *Stack TCP/IP*: Internet si basa su questa suite di protocolli. Attenzione: non è composta *solo* da TCP e IP, ma include molti altri protocolli essenziali come UDP, ICMP (diagnostica), ARP (risoluzione indirizzi), OSPF/BGP (routing).
- *Standardizzazione (IETF & RFC)*:
  - La standardizzazione è gestita dalla *IETF* (Internet Engineering Task Force).
  - I protocolli sono definiti nei documenti *RFC* (Request For Comments). Se un protocollo diventa standard, la sua RFC diventa la specifica di riferimento.
- *Indipendenza dal mezzo fisico*: Il TCP/IP è *agnostico* rispetto alla tecnologia sottostante. Funziona indifferentemente su WiFi, Ethernet, fibra ottica, collegamenti satellitari, ecc.
- *Decentralizzazione*: È un insieme di *Sistemi Autonomi* (AS) interconnessi senza un'autorità centrale che controlli tutto il traffico.

// MAPPA INTERNET: Visualizza la struttura decentralizzata


Le connessioni tra i sistemi autonomi possono sembrare disorganizzate ("a ragnatela") perché frutto di accordi privati tra le parti. Ogni collegamento rappresenta un *peering agreement* (scambio traffico alla pari) o un *transit agreement* (scambio a pagamento).

La struttura si divide generalmente in:
- *Edge systems*: Le reti periferiche (utenti, campus, aziende, ISP).
- *Core systems*: La spina dorsale (Backbone) che trasporta grandi moli di dati.

=== Gestione e Indirizzamento
Il mondo è suddiviso in zone geografiche gestite dai *RIR* (Regional Internet Registries, come RIPE per l'Europa), che si occupano dell'assegnazione dei blocchi di indirizzi IP e dei numeri di AS.

== Definizioni Chiave

#definition("Subnet")[
  Una sottorete (Subnet) è una suddivisione logica di una rete IP. Permette di segmentare il traffico per migliorare le prestazioni e la sicurezza, raggruppando host che condividono lo stesso prefisso di indirizzo IP.
]

#definition("Autonomous System (AS)")[
  Un insieme di reti e router sotto il controllo di una singola amministrazione (es. UNIFI, Telecom, Google) che gestisce una politica di routing comune verso Internet. Ogni AS è identificato da un numero univoco (ASN).
]

=== Tipi di Nodi
In una rete possiamo distinguere tre categorie principali di dispositivi:

1. *Host (L7)*: I dispositivi finali (End Systems) dove risiedono le applicazioni (client e server). Sono l'origine e la destinazione del traffico. Sono identificati univocamente da indirizzi IP.
2. *Router/Gateway (L3 o L7)*: Dispositivi intermedi, usati principalmente per indirizzare i pacchetti. Hanno bisogno di un'interfaccia IP per ogni subnet a cui sono connessi.

== Principi Fondamentali della Comunicazione
- *Primitive di Comunicazione:* Lo schema base si fonda su quattro primitive: *Request* (richiesta), *Indication* (indicazione), *Response* (risposta) e *Confirm* (conferma). Questa sequenza è seguita rigorosamente nei livelli 1 e 2, mentre diventa più sfumata nei livelli superiori.
- *PDU (Packet Data Unit) ed Incapsulamento:* Quando un livello riceve dati da quello superiore, questi sono chiamati PDU. Il livello ricevente deve aggiungere il proprio *Header* (e talvolta un *Trailer*) senza guardare il contenuto della PDU superiore.
- *Interoperabilità e Information Hiding:* È fondamentale la distinzione tra *interfaccia e implementazione*. Un livello non deve basare le proprie operazioni sul contenuto del livello superiore per garantire la manutenzione a lungo termine e l'interoperabilità; altrimenti, non si potrebbe cambiare un livello senza rompere l'intero sistema.

== Modelli Protocollari: ISO/OSI vs TCP/IP
- *Modello ISO/OSI:*
  - Si basa sui principi di *Separation of Concerns* (ogni livello ha un compito univoco) e *Information Hiding* (uso solo di interfacce pubbliche).
  - Prevede teoricamente 7 livelli, che diventano *8* poiché il *Data Link* è diviso in *MAC* (Medium Access Control) e *LLC* (Logical Link Control).
  - Livelli: Physical, Data Link (MAC/LLC), Network, Transport (primo livello end-to-end), Session, Presentation, Application.
  - È rimasto "lettera morta" nella pratica perché troppo farraginoso, ma resta un riferimento teorico importante.
- *Modello TCP/IP:*
  - Definito come un *"Frankenstein"* nato dal pragmatismo ("proviamo e aggiungiamo pezzi") piuttosto che da una progettazione a tavolino.
  - Ha eliminato i livelli Sessione e Presentazione (inglobandoli nel Transport o Application).
  - Si basa sull'ipotesi che i livelli sottostanti facciano del loro meglio (*best effort*), ma senza garanzie, rendendo necessari livelli intermedi di adattamento.

== Nodi Intermedi e Dispositivi
- *Repeater/Booster:* Operano solo a livello *Physical*; amplificano il segnale senza decodificarlo.
- *Bridge/Switch:* Operano fino al livello *Data Link*.
- *Router:* Operano fino al livello *Network*.
- *Gateway e Proxy:* Operano fino al livello *Application* (livello 7) e servono per modificare le informazioni in transito o fare caching.

== Indirizzamento e Routing
- *MAC Address:* Erroneamente chiamato indirizzo fisico, appartiene invece al livello *Data Link*. Una scheda può avere più indirizzi MAC (es. per privacy) o nessuno (es. in connessioni seriali punto-punto).
- *Indirizzi IP:* Necessari per il routing; non esiste una relazione algoritmica con il MAC address. La traduzione avviene tramite protocolli come *ARP*.
- *Indirizzi Alfanumerici:* Di livello applicativo, servono per mantenere l'identità anche se la macchina cambia IP muovendosi nella rete. Sono gestiti dal *DNS*.
- *Fine delle Classi:* Le classi di indirizzi (A, B, C) sono *obsolete dal 1981*. Oggi si usa esclusivamente il *CIDR* (notazione con la barra, es. `/24`) per definire la maschera di rete.
- *Tabelle di Routing:* Vanno interpretate con attenzione. Spesso il termine "Gateway" nelle tabelle indica semplicemente il router di prossimo salto (*next hop*).

== Livello Applicativo e Protocolli
- *Applicazione vs Protocollo:* Chrome è un'applicazione, *HTTP* è il protocollo di livello applicativo che essa implementa.
- *Componenti di un Protocollo:* Ogni protocollo richiede la definizione di *Sintassi* (formato dei messaggi), *Semantica* (significato dei messaggi) e *Temporizzazioni* (timing).
- *Macchine a Stati (FSM):* Un protocollo deve essere definito formalmente tramite macchine a stati. La ricezione di un messaggio deve triggerare un cambio di stato coerente.
- *Modelli di Scambio Messaggi:*
  - *Pub/Sub (Publish-Subscribe):* Prevede un broker terzo (es. MQTT, Kafka). Chi invia non deve conoscere il destinatario.
  - *REST (Request-Response):* Basato su richieste e risposte (es. HTTP). Il client invia una richiesta e il server risponde, eventualmente cambiando stato.

=== Il Paradosso del DNS e i Modelli a Livelli
Sebbene il *DNS (Domain Name System)* sia classificato come un protocollo di livello applicativo, esso presenta una natura ambivalente:
- *Posizionamento:* Poiché sfrutta i protocolli di trasporto (TCP o UDP), logicamente sta sopra di essi, nel livello applicativo.
- *Funzione:* A differenza di HTTP o dell'Email, il DNS non viene usato direttamente dall'utente finale, ma è un *servizio a supporto delle altre applicazioni*. Per questo motivo, potrebbe essere considerato quasi un "livello 7-".
- *Teoria vs Pratica:* La strutturazione rigida dei modelli ISO/OSI o TCP/IP è utile come schema teorico, ma nella realtà il sistema è spesso "caotico" (*Messi Code*). È fondamentale capire le relazioni tra le parti e le *sequenze temporali* (es. chi parte per primo in un dispositivo IoT) per evitare problemi come le *race conditions*.

Il DNS è descritto come il servizio più critico di Internet: se cade, la rete si blocca per la percezione comune, poiché gli utenti non ricordano gli indirizzi IP a memoria.
- *Database Distribuito:* Tecnicamente, il DNS è un *database distribuito, ridondato e ad alta disponibilità*.
- *Virtual Hosting:* Il DNS è indispensabile anche perché molti server moderni (e sistemi cloud come Amazon o Google) usano il *virtual hosting*. Se si usasse solo l'IP, il server non saprebbe quale sito web specifico mostrare tra i tanti ospitati sullo stesso indirizzo.

=== Protocollo HTTP e il Concetto di Risorsa
L'*HTTP (Hypertext Transfer Protocol)* è l'archetipo dei sistemi *REST (Representational State Transfer)*.
- *Struttura del messaggio:* Deriva dal concetto dell'email, composto da un *Header* (che dichiara cosa fare e cosa c'è nel corpo) e un *Body*.
- *URI (Uniform Resource Identifier):* È fondamentale distinguere tra un semplice file e una *risorsa*. Una risorsa può essere un file, ma anche la lettura di un sensore o uno streaming. L'URI specifica lo schema (protocollo), l'authority (il computer host) e il path (che spesso non corrisponde a un vero percorso nel file system).
- *Metodi HTTP:*
  - *GET:* Dovrebbe essere un metodo "const", ovvero non deve modificare lo stato del server, ma solo richiedere informazioni. I parametri sono visibili nell'URL.
  - *POST:* Si usa per modificare lo stato del server (es. aggiungere un record a un database) e i parametri sono nel body della richiesta.
- *Evoluzione:* L'HTTP 1.0 era *stateless* e apriva/chiudeva una connessione per ogni richiesta. L'1.1 ha introdotto le *connessioni persistenti* per migliorare le prestazioni nel caricamento di pagine complesse. L'HTTP3 rappresenta un cambiamento radicale poiché non usa più il TCP come trasporto, ma il protocollo *QUIC*.

=== Email e la Storia delle Comunicazioni
L'email è un servizio che precede il web e la sua architettura riflette la storia delle vecchie *BBS (Bulletin Board System)*.
- *Architettura:* Non è un sistema di messaggistica istantanea. Si basa su server che "tengono in pancia" i messaggi finché non vengono scaricati.
- *Protocolli:* Si usa l'*SMTP* per inviare la posta (sia dal client al server, sia tra server) e protocolli come *IMAP* o il vecchio POP per consultare la propria casella.
- *Sicurezza e PEC:* La posta elettronica non è nata per essere certificata; la sua sicurezza dipende dall'infrastruttura del server più che dalla comunicazione in sé.