#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

#pagebreak()

= Livello trasporto
A livello di trasporto abbiamo protocolli *connection-oriented*#index[connection-oriented] e *protocolli connectionless*. I protocolli di livello 4 sono definiti "end-to-end", ovvero vanno dalla sorgente alla destinazione e i nodi intermedi della rete teoricamente se ne dovrebbero disinteressare. Se volessimo fare un paragone con il modello OSI - cosa sconsigliata di fare all'esame - diremmo che il livello Trasporto del TCP/IP fa cose che non gli competono, sobbarcandosi anche funzioni che l'OSI relegherebbe al livello di sessione. Il suo scopo primario è fare *multiplexing*#index[multiplexing] e *demultiplexing*#index[demultiplexing], fornire degli indirizzi di livello 4 ed eventualmente occuparsi del controllo di congestione e di flusso.

Il multiplexing, nelle reti, significa prendere i dati generati da più processi (ad esempio, un'applicazione che usa una socket TCP e un'altra che usa UDP) e infilarli insieme su un unico canale fisico di trasmissione. Il demultiplexing è l'esatto opposto in fase di ricezione. Per poter fare questo smistamento, ogni livello della pila protocollare deve avere nell'header un'informazione che identifichi a chi è destinato il payload: nel frame Ethernet c'è il campo EtherType, nell'IP c'è il campo Protocol, e a livello di trasporto sono usate le Porte.

#figure(image("images/2026-07-05-22-26-35.png", width: 60%))

== UDP vs TCP
Nel modello connection-oriented, come il TCP, il livello 4 esegue una fase di setup iniziale. Una volta stabilita la connessione, si ha la certezza che i dati arriveranno e si potrà comunicare in modo efficiente. I grandi svantaggi sono che permette solo comunicazioni uno-a-uno e, soprattutto, richiede il mantenimento continuo di uno "stato" della connessione. Poiché il livello IP sottostante è inaffidabile e invia i pacchetti ognuno per i fatti suoi, tutto l'enorme carico di mantenere in piedi la connessione e verificarne l'affidabilità ricade sul TCP.

L'UDP, al contrario, è connectionless ed è molto più affine all'IP: prende un pacchetto, lo manda e spera che arrivi. Non ha fasi di setup e permette di inviare dati a un destinatario specifico, in multicast a molti o in broadcast a tutti. Il lato negativo è che si perde completamente la garanzia di consegna. L'UDP non dà alcun feedback sull'arrivo dei dati; se serve sapere se un pacchetto è giunto a destinazione, sarà necessario programmare un sistema di conferma a livello applicativo. Questo, però, lo rende un protocollo estremamente leggero e veloce, non essendoci alcuno stato da mantenere in memoria.

Il modo migliore per capire come funziona l'UDP è guardare il suo header, che è lungo appena 8 byte.
#figure(image("images/2026-06-20-17-37-16.png", width: 80%), caption: "UDP a sx, UDP-Lite a dx")

Contiene solo quattro campi: la porta sorgente, la porta destinazione, la lunghezza e un checksum per il controllo degli errori. La lunghezza è essenziale perché permette al sistema ricevente di sapere esattamente quanta memoria allocare in modo dinamico prima ancora di finire di leggere l'intero pacchetto. Non essendoci numeri di sequenza o acknowledgement, si tratta di un protocollo sostanzialmente vuoto.

Il calcolo del checksum è facoltativo su IPv4, obbligatorio su IPv6 mentre su UDP-Lite è opzionale e potrebbe non coprire l'intero header. C'è un'unica vera anomalia: per calcolare il checksum, l'UDP utilizza un cosiddetto "pseudo-header" IP. In pratica, il livello UDP ha bisogno di conoscere l'indirizzo IP sorgente, l'indirizzo destinazione e il protocollo, compiendo una violazione del principio di isolamento dei livelli (information hiding). Questo crea una complicazione in fase di invio, poiché l'UDP deve chiedere al livello IP quale indirizzo sorgente verrebbe usato per raggiungere quella determinata destinazione, in modo da poter calcolare correttamente il checksum prima di passargli il pacchetto. Esiste anche una variante meno comune, l'UDP-Lite, pensata per i flussi multimediali, che permette di applicare il checksum solo a una porzione del pacchetto in modo da tollerare lievi errori sui frame video senza scartare l'intera immagine.

== Porte e Socket
Le porte sono i punti logici in cui avviene il multiplexing dei servizi. Usiamo delle porte standard predeterminate, come la 80 per l'HTTP, per evitare che un client debba interrogare ogni volta il server per sapere su quale porta sia in ascolto un determinato servizio; un meccanismo del genere intaserebbe la rete e offrirebbe il fianco a innumerevoli problemi di sicurezza.

Le porte si dividono in categorie: le porte *well-known* (da 1 a 1023), le porte *registrate* (da 1024 a 49151) e le porte *effimere* assegnate dinamicamente. L'unica vera differenza pratica tra queste categorie è un retaggio storico: per aprire un servizio in ascolto su una well-known port è necessario avere i privilegi di amministratore (root), mentre per le altre basta un utente normale.

Quando il programma apre una socket, le viene assegnata una porta locale. E' possibile vincolare (bind) questa socket a uno specifico indirizzo IP della macchina, a una specifica interfaccia di rete (come il Wi-Fi o il cavo Ethernet) oppure lasciarla in ascolto su tutte le interfacce disponibili. Attenzione a un dettaglio fondamentale: poiché l'UDP è senza connessione, una volta aperta una socket su una determinata porta, questa riceverà indiscriminatamente pacchetti da chiunque li invii. Spetterà interamente all'applicazione fare il "demultiplexing applicativo", ovvero controllare l'indirizzo IP e la porta sorgente di ogni singolo pacchetto in ingresso per capire con chi si sta parlando e gestire correttamente le risposte. Le socket UDP di basso livello non fanno alcun filtro.
