#import "../dvd.typ": *

#dvdtyp(
  title: "Appunti Reti di Calcolatori",
  author: none,
  subtitle: "Teoria\nCorso 2025/2026",
  cover-image: image("cover.jpg", height: 100%, width: 100%)
)[
  #outline(title: "Contenuti")

  #pagebreak()

  #include "chapters/chapter1/1-introduzione.typ"
]


// ## 1. Architettura di Rete e Modelli a Livelli OK
// Sia il testo scritto che le lezioni orali introducono lo studio delle reti attraverso la scomposizione in strati, confrontando i modelli teorici con quelli implementati nella realtà di Internet.

// *   **Network Edge e Network Core:** Definizione della struttura di Internet divisa in dispositivi periferici (host, client, server) e nucleo della rete (router e switch interconnessi).
// *   **Modello ISO/OSI vs TCP/IP:** Confronto tra il modello teorico a 7 livelli (Applicazione, Presentazione, Sessione, Trasporto, Rete, Data Link, Fisico) e lo stack TCP/IP a 4 livelli. Entrambe le fonti sottolineano come il modello OSI sia rimasto un riferimento teorico a causa della sua complessità e rigidità.
// *   **Incapsulamento e PDU:** Il processo mediante il quale i dati scendono nello stack protocollare, con ogni livello che aggiunge la propria intestazione (*header*) per formare Messaggi, Segmenti, Datagrammi e Frame.

// > **Definizione:** L'**Information Hiding** (occultamento dell'informazione) e la **Separation of Concerns** (separazione delle competenze) sono principi per cui un livello non deve conoscere i dettagli implementativi o il contenuto del livello superiore, ma basarsi solo sulle intestazioni e sulle interfacce (API/SAP).

// ⚠️ **Importante:** Entrambe le fonti, con particolare enfasi del professore, ribadiscono che la rigida separazione dei livelli spesso viene violata per motivi di ottimizzazione ed efficienza, rendendo lo stack TCP/IP un modello altamente "pragmatico".

// ## 2. Il Livello Applicativo
// Sia il PDF che gli audio dedicano ampio spazio ai protocolli che permettono ai processi di comunicare in rete, focalizzandosi su HTTP e DNS.

// *   **Paradigmi Architetturali:** Distinzione tra architetture *Client-Server* (dove il server è sempre attivo e in ascolto) e *Peer-to-Peer* (P2P).
// *   **Protocollo HTTP:** Studio dell'archetipo del modello REST. Entrambe le fonti analizzano l'uso dei metodi (`GET`, `POST`, `PUT`, `HEAD`), la struttura degli URI/URL e il formato human-readable dei messaggi di Request e Response.
// *   **Evoluzione dell'HTTP:** Analisi del passaggio da connessioni non persistenti (HTTP/1.0, che richiedono un RTT per ogni oggetto) a connessioni persistenti (HTTP/1.1), fino ad arrivare al multiplexing dei frame in HTTP/2 e all'uso di QUIC (su UDP) per HTTP/3.
// *   **Gestione dello Stato:** L'HTTP è nativamente un protocollo *stateless* (senza stato). Per tracciare la sessione utente si ricorre all'uso dei *Cookies*.

// ⚠️ **Oggetto d'esame:** Non bisogna mai confondere un'applicazione (es. il browser) con il protocollo applicativo che essa implementa (es. HTTP). Le applicazioni usano i protocolli per incapsulare i dati.

// *   **Domain Name System (DNS):** Il database distribuito e gerarchico (Root, TLD, Authoritative) necessario per risolvere i nomi alfanumerici (più adatti al livello applicativo) in indirizzi IP instradabili. Entrambe le fonti sottolineano i rischi di un *Single Point of Failure* se fosse centralizzato.

// ## 3. Livello di Trasporto e Socket Programming
// Il ruolo del Livello 4 è garantire la comunicazione logica tra i *processi* in esecuzione sugli host, distinguendosi dal livello di rete che connette gli host fisici.

// *   **Multiplexing e Demultiplexing:** L'uso dei numeri di Porta (Sorgente e Destinazione) per incanalare i dati verso la socket del processo corretto.
// *   **Protocollo UDP:** Trasporto *Connectionless* e *Stateless*. Header leggero (8 byte: porte, lunghezza, checksum). Viene preferito per applicazioni dove la velocità è prioritaria rispetto all'affidabilità (es. video streaming, DNS).
// *   **Protocollo TCP:** Trasporto *Connection-oriented* basato su un flusso continuo di byte (*byte stream*). Gestione rigorosa dello stato della connessione tramite *3-way Handshake* (SYN, SYN-ACK, ACK) e chiusura tramite *4-way Teardown* (FIN, ACK).

// > **Definizione:** Una **Socket** è l'interfaccia di programmazione (API) fornita dal sistema operativo che permette a un processo applicativo di accedere ai servizi della rete, inviando o ricevendo dati in forma bloccante o non bloccante.

// ## 4. Affidabilità e Controllo del Traffico (TCP)
// Entrambe le fonti approfondiscono i meccanismi per garantire una consegna affidabile su un canale inaffidabile, uniti al controllo delle risorse.

// *   **Principi di Ritrasmissione:** Utilizzo di Numeri di Sequenza (*Sequence Number*) e Conferme (*Acknowledgment - ACK*) per identificare i pacchetti e gestire lo scarto dei duplicati.
// *   **Pipelining (Go-Back-N e Selective Repeat):** Abbandono del paradigma inefficace *Stop-and-Wait* per permettere pacchetti multipli "in volo". Differenza tra l'ACK cumulativo del Go-Back-N (che ritrasmette tutta la finestra in caso di errore) e l'ACK individuale del *Selective Repeat* (implementato dal TCP moderno con SACK).
// *   **Controllo di Flusso:** Meccanismo per evitare che il mittente saturi il buffer di ricezione del destinatario, comunicato tramite la *Receive Window*.
// *   **Controllo di Congestione:** Meccanismo per evitare di saturare i buffer dei router intermedi della rete. Entrambe le fonti illustrano l'algoritmo **AIMD** (*Additive Increase Multiplicative Decrease*), le fasi di *Slow Start* e *Congestion Avoidance*, e le evoluzioni moderne come **TCP Cubic** (che ottimizza il recupero della velocità verso Wmax) e **BBR** (basato sul ritardo invece che sulla perdita dei pacchetti).

// ## 5. Il Livello di Rete: IPv4, Routing e NAT
// Il livello di rete è il nucleo operativo di Internet, incaricato di spostare i pacchetti dalla sorgente alla destinazione attraverso maglie di nodi intermedi.

// *   **Forwarding vs Routing:** Netta separazione tra il *Forwarding* (Data Plane: operazione hardware locale per spostare il pacchetto dalla porta di input a quella di output usando tabelle precompilate) e il *Routing* (Control Plane: l'intelligenza software globale che calcola i percorsi e compila le tabelle).
// *   **Longest Prefix Matching:** Algoritmo utilizzato all'interno dei router per selezionare l'interfaccia di uscita. La regola impone di scegliere la voce della tabella che ha il maggior numero di bit iniziali coincidenti con l'IP di destinazione.
// *   **Formato del Datagramma IPv4:** Struttura dell'header (20 byte base), gestione del Time To Live (TTL) e campi per la frammentazione (Identification, Flags, Offset).

// ⚠️ **Attenzione (Dimenticate le Classi):** Sia il professore che il testo impongono di abbandonare il concetto storico di classi A, B e C, ormai obsoleto. L'allocazione odierna si basa esclusivamente sul **CIDR** (*Classless Inter-Domain Routing*), utilizzando prefissi a lunghezza variabile (es. /24, /20) per compattare le tabelle e ottimizzare lo spazio di indirizzamento.

// *   **Sottoreti (Subnet) e DHCP:** Il ruolo della *Subnet Mask* per delimitare topologicamente una rete locale in IPv4. L'assegnazione degli indirizzi viene demandata al protocollo *Plug-and-Play* **DHCP** tramite la sequenza DORA (Discover, Offer, Request, Ack).
// *   **NAT (Network Address Translation):** Motivato dall'esaurimento degli indirizzi IPv4 pubblici. Il NAT altera gli header rimpiazzando IP e porte private (es. 192.168.x.x) con un IP pubblico. Entrambe le fonti evidenziano che il NAT rompe il paradigma *end-to-end* di Internet, ostacola le connessioni entranti asimmetriche (richiedendo *Hole Punching* o STUN), e distrugge le firme crittografiche del protocollo IPsec.

// ## 6. Il Protocollo IPv6
// Per ovviare ai limiti strutturali di IPv4, viene analizzato in dettaglio il design di IPv6, caratterizzato da uno spazio di indirizzamento vastissimo (128-bit).

// *   **Semplificazione dell'Header:** L'header IPv6 ha una lunghezza rigidamente fissa a 40 byte. Vengono rimossi il Checksum (per alleggerire il lavoro dei router) e i campi di frammentazione. I router intermedi non frammentano più i pacchetti; se troppo grandi, vengono scartati inviando un ICMPv6 "Packet Too Big" al mittente (Path MTU).
// *   **Tipologie e Scope degli Indirizzi:** Scompare il Broadcast a favore del **Multicast**. Vengono introdotti formalmente gli *Scope* di validità: indirizzi **Global Unicast** (instradabili su Internet), **Link-Local** (`fe80::/10`, validi solo fino al primo router), e **ULA** (Unique Local, analoghi agli IP privati).
// *   **Autoconfigurazione e SLAAC:** L'innovazione principale di IPv6 è la *Stateless Address Autoconfiguration*. Ogni dispositivo genera automaticamente un indirizzo Link-Local unendo il prefisso `fe80::` con un *Interface ID* (spesso derivato dal MAC address tramite la regola **EUI-64**). Tramite i messaggi *Router Solicitation* e *Router Advertisement*, l'host acquisisce poi il prefisso globale per autoconfigurare l'indirizzo pubblico senza l'uso del DHCP.
// *   **Neighbor Discovery Protocol (NDP):** Sostituisce il vecchio ARP (usato in IPv4). Si appoggia ai messaggi ICMPv6 e al Multicast per la risoluzione degli indirizzi MAC e per operare la fondamentale DAD (*Duplicate Address Detection*) prima di usare un nuovo indirizzo.

// > **Definizione:** Il **Duplicate Address Detection (DAD)** è il processo obbligatorio in IPv6 in cui un nodo, prima di assegnarsi definitivamente un indirizzo autoconfigurato, interroga la rete multicast per assicurarsi che quell'indirizzo non sia già in uso da un altro dispositivo.