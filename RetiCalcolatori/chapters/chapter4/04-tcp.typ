#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

#pagebreak()

= TCP
L'header del TCP è molto più complicato di quello dell'UDP e, a differenza di quest'ultimo, non ha una dimensione fissa.

#figure(image("images/2026-06-20-17-41-09.png"))

- *Punti in comune con l'UDP:* anche il TCP possiede uno pseudo-header (identico a quello usato dall'UDP per IPv4/IPv6, essenziale per il calcolo del checksum). Inoltre, i primi due campi dell'header TCP sono la *Porta Sorgente* e la *Porta Destinazione* (entrambe da 16 bit), che si trovano nella stessa posizione e hanno la stessa semantica dell'UDP. Esse vengono utilizzate dal TCP stesso per effettuare il multiplexing. Questa somiglianza non è una regola fissa per tutti i protocolli di livello 4 (esiste ad esempio l'SCTP, usato nelle reti mobili, che funziona in modo diverso), ma è dovuta al fatto che TCP e UDP sono stati progettati nello stesso periodo, spesso dalle stesse persone, all'interno della suite TCP/IP.
- *Numeri di sequenza (Sequence e Acknowledgement Number):* subito dopo le porte, troviamo due campi da 32 bit fondamentali:
  - *Sequence Number*#index[Sequence Number]
  - *Acknowledgement Number*#index[Acknowledgement Number]
  Questi sono il cuore del meccanismo di affidabilità del TCP.
- *La dimensione variabile (Data Offset):* a differenza dell'UDP che ha un header di 8 byte fissi, l'header TCP ha una dimensione base di 20 byte (5 word da 32 bit), ma può essere più lungo a causa del campo *Options*. Per capire dove finisce l'header e dove inizia il payload, il TCP utilizza il campo *Data Offset*#index[Data Offset] (lungo 4 bit), che indica la lunghezza dell'header in word da 32 bit. È cruciale leggere questo valore: ignorare le opzioni porta a calcolare male il checksum e a invalidare i pacchetti.
- *Altri campi:* troviamo la *Window*#index[Window] (finestra di ricezione), il *Checksum*#index[Checksum] (che qui è obbligatorio e copre pseudo-header, header e payload), l'*Urgent Pointer*#index[Urgent Pointer] e una serie di flag di controllo:
  - *CWR + ECE* : Explicit Congestion Notification
  - *URG*#index[URG]: Urgent data
  - *ACK*#index[ACK]: l'Acknowledgement Number è valido e reale
  - *RST*#index[RST]: reset della connessione (hard termination)
  - *SYN*#index[SYN]: sincronizzazione numero di sequenza (connection start)
  - *FIN*#index[FIN]: assenza di ulteriori dati da trasmettere (soft termination)

== TCP demultiplexing

C'è una differenza fondamentale nel modo in cui l'applicazione gestisce la ricezione dei pacchetti rispetto all'UDP.

- *UDP (Connectionless):* l'UDP invia e riceve datagrams senza stato. Usando una socket UDP, l'applicazione deve usare una funzione come `recvfrom()` per estrarre manualmente dall'header l'indirizzo IP e la porta sorgente del mittente. Spetta all'applicazione (demultiplexing applicativo) capire chi le sta parlando.
- *TCP (Connection-Oriented):* nel TCP, il canale è dedicato tra due endpoint precisi. Se un pacchetto arriva a una socket TCP attiva, il sistema sa già che proviene dall'unico mittente autorizzato per quella connessione. Il demultiplexing è gestito a livello TCP, e l'applicazione può usare una semplice funzione `recv()`, disinteressandosi dell'identità del mittente, che è già implicita nello stato della socket.

== Affidabilità

L'UDP è connectionless e privo di riscontri (*stateless*). Il TCP, essendo connection-oriented (*stateful*), garantisce che i dati arrivino (reliable) e vengano riordinati correttamente. Per farlo, deve gestire perdite, duplicati e pacchetti fuori ordine.

Il *Sequence Number*#index[Sequence Number] rappresenta la posizione del primo byte dei dati che stanno venendo trasmessi in un segmento. Se il primo pacchetto invia 100 byte iniziando, per semplicità, dal numero di sequenza 1, il pacchetto successivo non avrà sequenza 2, ma sequenza 101.


L'*Acknowledgment Number*#index[Acknowledgment Number] è la controparte esatta del Sequence Number, ed è il meccanismo con cui il TCP garantisce che i dati siano arrivati correttamente a destinazione. Così come il Sequence Number conta i byte inviati, l'Acknowledgment Number serve per indicare al mittente quali byte sono stati ricevuti con successo.

== Flag di controllo

I flag TCP servono a gestire lo stato della connessione:

- *ACK*#index[ACK]: indica che il campo *Acknowledgement Number*#index[Acknowledgement Number] contiene un valore valido. Poiché la comunicazione è bidirezionale, un pacchetto potrebbe contenere solo dati senza dover confermare nulla di nuovo. Se questo flag è a 0, il destinatario sa di dover ignorare il campo ACK, evitando di interpretarlo erroneamente come una conferma duplicata (Duplicate ACK), che innescherebbe meccanismi di reazione alla congestione.
- *SYN*#index[SYN]: inizia una connessione.
- *FIN*#index[FIN]: termina una connessione in modo controllato.
- *RST*#index[RST]: termina la connessione in modo drastico, utile per situazioni di emergenza (es. connessione caduta da un lato).

== Three-way Handshake

Per stabilire una connessione bidirezionale affidabile, il TCP usa il *Three-way Handshake*#index[Three-way Handshake]:

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

Il TCP è una complessa macchina a stati finiti (FSM). Lo stato di questa macchina per una singola connessione viene memorizzato in una struttura dati chiamata *TCB (Transmission Control Block)*#index[TCB (Transmission Control Block)]. Il TCB contiene lo stato della connessione, i timer e i buffer per gestire i dati in ingresso e in uscita e per riordinare i pacchetti. Mantenere queste strutture occupa molta memoria RAM.

Il TCP identifica due ruoli all'interno della connessione: il *server* che apre una porta ed aspetta connessioni (la sua porta deve essere conosciuta dal client) e il *client* che avvia la connessione verso il server (la sua porta può essere effimera).

Quando un server mette in ascolto una socket TCP (stato *LISTEN*), non conosce ancora chi si connetterà. Quando arriva un pacchetto SYN da un client, il server crea un nuovo TCB parziale (per evitare attacchi di tipo *SYN Flood*#index[SYN Flood], che esaurirebbero la memoria). Una volta completato l'handshake (stato *ESTABLISHED*), il processo del server esegue tipicamente una `fork()`: il processo padre continua ad ascoltare sulla socket originale (che rimane in *LISTEN*). Il processo figlio eredita una *nuova* socket dedicata a quella specifica connessione, dotata di un TCB completo contenente la *quintupla* identificativa `{src/dst IP, src/dst port, protocol}`.

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
- *Stop-and-Wait*#index[Stop-and-Wait]: si invia un pacchetto e si aspetta l'acknowledgement (ACK) prima di mandare il successivo. Facilissimo da implementare, ma super inefficiente a causa del tempo morto (il Round Trip Time, o RTT).
- *Go-Back-N*#index[Go-Back-N]: si trasmettono pacchetti a raffica e, se si scopre di aver perso il pacchetto numero due, si butta via tutto quello che è arrivato dopo e si ritrasmette dal due in poi. È più efficiente, ma in una rete Internet dove i pacchetti arrivano fuori ordine o duplicati, diventa problematico.
- *Selective Repeat*#index[Selective Repeat]: il ricevitore comunica esattamente quale pacchetto manca. Contrariamente agli altri, richiede il riordino dei pacchetti.

#figure(image("images/2026-06-20-17-56-01.png"))

#observation()[
  Originariamente il TCP usava ACK cumulativi (confermando tutto fino a un certo punto), il che lo rendeva simile a un Go-Back-N. Oggi, nelle reti ad altissima velocità dove il Round Trip Time permette di avere migliaia di pacchetti "in volo", si usano i *Selective Acknowledgement*#index[Selective Acknowledgement] (SACK). *Attenzione però: le opzioni come SACK devono essere negoziate all'apertura della connessione e allungano l'header TCP, riducendo lo spazio per i dati reali*.
]


=== Controllo del flusso e della congestione
Non si deve confondere il controllo di congestione nei nodi intermedi con il controllo di flusso al ricevitore. Se si trasmette a una velocità elevata ma il computer ricevente è un dispositivo IoT poco potente, la sua memoria si saturerà. Il controllo di flusso serve proprio a sincronizzare la velocità del trasmettitore con le risorse di chi riceve, per evitare che i pacchetti vengano scartati alla fine del viaggio.

#observation("Controllo del flusso")[
  È un servizio di adattamento della velocità (speed-matching service) che serve a sincronizzare la velocità del trasmettitore con le capacità di ricezione ed elaborazione del destinatario. Il suo scopo principale è evitare che il mittente saturi il buffer del ricevitore inviando troppi dati troppo velocemente. Nel protocollo TCP, questo viene gestito facendo sì che il ricevitore comunichi costantemente al mittente la dimensione della sua *receive window*#index[receive window] (finestra di ricezione), informandolo in modo dinamico su quanto spazio libero è rimasto nel proprio buffer.
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

Come fa praticamente il TCP a regolare la velocità? Usa una *congestion window*#index[congestion window]. Più è grande questa finestra, più dati trasmetto in un RTT. La teoria classica si basa sull'algoritmo *AIMD*#index[AIMD] (Additive Increase, Multiplicative Decrease): ogni volta che ricevo un ACK, aumento la finestra linearmente di 1; se rilevo una perdita, presumo ci sia congestione e dimezzo drasticamente la finestra. Questo approccio crea il classico grafico a dente di sega e garantisce stabilità e *fairness*#index[fairness] (equità) tra i vari utenti che si contendono la banda.
#figure(image("images/2026-07-05-22-48-05.png", width: 50%), caption: "Grafico AIMD.")

Oggi però l'AIMD puro è superato. I sistemi operativi moderni usano diversi "flavors" (varianti) del TCP. Linux usa spesso il *Cubic*#index[Cubic], mentre Google spinge per algoritmi basati sui ritardi come il *BBR*#index[BBR]. Ognuno reagisce in modo diverso alla congestione.

#observation()[
  Ricordiamo che una perdita di pacchetti non significa sempre congestione; in una rete Wi-Fi o satellitare le perdite possono avvenire per interferenze radio, e dimezzare la velocità per un'interferenza è un errore grave.
]

Uno dei metodi più recenti è l'*AQM*#index[AQM] (Active Queue Management). Piuttosto che aspettare che la coda di un router si riempia del tutto e provochi un disastro, l'AQM fa una cosa molto intelligente: inizia a scartare intenzionalmente *qualche* pacchetto in anticipo.  Questo segnale "sveglia" il controllo di congestione del TCP prima che sia troppo tardi. Senza algoritmi come RED, CoDel o FQ-CoDel nei router intermedi, la latenza su Internet sarebbe insopportabile e non potremmo fare, ad esempio, videochiamate.
