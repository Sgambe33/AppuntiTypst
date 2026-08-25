#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

#pagebreak()

= IPv6

L'evoluzione delle infrastrutture di rete ha reso obsoleti molti dei paradigmi legati allo standard IPv4. Attualmente, l'IPv6 non costituisce un protocollo sperimentale o futuro, bensì lo standard *de facto* su cui transita la maggioranza del traffico Internet globale. Comprendere l'IPv6 è un requisito fondamentale per lo sviluppo e l'amministrazione delle reti moderne.

== Motivazioni della Transizione a IPv6

La nascita dell'IPv6 è motivata principalmente dal progressivo esaurimento dello spazio di indirizzamento IPv4 (poco più di 4 miliardi di indirizzi). Tale esaurimento è stato causato dalle politiche iniziali di allocazione inefficiente da parte dei Regional Internet Registry (RIR). L'IPv6 è stato progettato basandosi su quattro pilastri architetturali:
+ *Spazio di indirizzamento esteso*: fornisce un numero di indirizzi teorico pari a $2^128$, consentendo un'allocazione capillare e logica.
+ *Superamento del NAT*: ripristina il paradigma *end-to-end* originario di Internet, in cui ogni host possiede un indirizzo IP globalmente univoco, eliminando le violazioni del principio di *information hiding* introdotte dal Network Address Translation.
+ *Semplificazione dell'Header*: ottimizza l'elaborazione dei pacchetti da parte dei router di transito.
+ *Autoconfigurazione nativa (SLAAC)*#index[Autoconfigurazione nativa (SLAAC)]: permette ai dispositivi di acquisire autonomamente i parametri di rete senza necessitare di server DHCPv6, sebbene con implicazioni di sicurezza da valutare.

Sul piano storico, l'IPv6 è stato standardizzato nella seconda metà degli anni '90 e l'esaurimento dei pool di indirizzi IPv4 gestiti dalla IANA si è concretizzato tra il 2011 e il 2012. Ciononostante, l'adozione è stata lenta e disomogenea, poiché dipende dai grandi ISP e non dai singoli utenti finali.

Nonostante l'enorme spesa operativa (OPEX) richiesta agli Internet Service Provider (ISP) per il mantenimento di infrastrutture *Dual Stack*#index[Dual Stack], la transizione è oggi accelerata dai costi insostenibili dei Carrier-Grade NAT (CG-NAT) per l'IPv4 e dai requisiti architetturali delle Core Network 5G Standalone (SA), le quali operano esclusivamente su IPv6.

== Semplificazione dell'Header e Prestazioni

Una delle maggiori inefficienze dell'IPv4 è l'header a dimensione variabile (da 20 a 60 byte) e la presenza del campo Checksum, che costringe ogni router a ricalcolare l'integrità del pacchetto a ogni salto (*hop*). Ogni singolo router su Internet, per ogni pacchetto, deve:
- Leggere un campo per calcolare la lunghezza dell'header.
- Allocare memoria di conseguenza.
- Ricalcolare l'intero Checksum, altrimenti il pacchetto viene scartato.

In IPv6, l'header principale è stato fissato a una dimensione costante di *40 byte* e il Checksum è stato eliminato (delegando il controllo di integrità ai livelli datalink e di trasporto, data l'alta affidabilità dei mezzi trasmissivi odierni come la fibra ottica). Le opzioni aggiuntive sono state delegate a strutture separate denominate *Extension Headers*#index[Extension Headers]. Un router *intermedio* analizza esclusivamente l'header fisso; se il campo `Next Header` indica un protocollo di livello superiore (TCP, UDP...) o un'estensione non pertinente al routing nodo-a-nodo, il router inoltra il pacchetto sfruttando percorsi di commutazione accelerati via hardware (*Fast Path*), ovvero ignora gli header successivi e inoltra. Se invece vale zero, significa che subito dopo c'è un Hop-by-Hop Extension Header che deve essere analizzato da ogni router sul percorso.

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
- *Multicast (`ff00::/8`)*: l'IPv6 abbandona completamente il concetto di Broadcast a favore del Multicast, in questo modo è possibile inviare pacchetti a più destinatari simultaneamente. La struttura di un indirizzo Multicast è `1111 1111` (il primo byte, `ff`) seguito da 4 bit di *Flag*#index[Flag] e 4 bit di *Scope*: è quest'ultimo campo (il nibble basso del secondo byte) a definire l'ambito di validità, ovvero quanto lontano può arrivare il pacchetto (es. `ff02` per il link-local). Gruppi multicast, identificati dall'ultimo pezzo, notevoli includono l'*All-nodes* (`ff02::1`) e l'*All-routers* (`ff02::2`).
  #observation(multiple: true)[
    + *Attenzione: gli indirizzi di tipo multicast non sono stati introdotti con IPv6, sono presenti anche in IPv4 anche se poco utilizzati.* Possono essere usati, per esempio, per inviare messaggi a tutti i router della rete che fanno uso di uno specifico protocollo di routing.
    + I driver delle schede di rete possono filtrare i pacchetti a livello hardware, evitando di interrompere la CPU per il traffico non di competenza. Questo permette di filtrare efficientemente i pacchetti in base al loro scope. A livello datalink, un indirizzo Multicast IPv6 viene tradotto in un indirizzo MAC che unisce il prefisso fisso `33:33` agli ultimi 32 bit (4 byte) dell'indirizzo Multicast, così che la scheda di rete possa decidere in hardware se il pacchetto la riguarda.
  ]

- *Anycast*#index[Anycast]: indirizzi sintatticamente indistinguibili dai Global Unicast, ma assegnati a interfacce appartenenti a nodi differenti. La rete instrada i pacchetti verso il nodo Anycast topologicamente più prossimo al mittente.

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
- Indirizzo di loopback (`::1/128`)
- Indirizzo Link Local (`FE80::xx:yy:zz:kk` dove `xx:yy:zz:kk` proviene dal MAC)
- Indirizzo Global Unicast
- Indirizzo All-Nodes Multicast (`FF02::1`)
- Indirizzo All-Routers Multicast (`FF02::2`) se è un router
- Indirizzo Solicited-Node Multicast (`FF02::1:FF00:0000/104`) se in autoconfigurazione

L'IPv6 rivoluziona la gestione delle reti locali. Il concetto di *Subnet Mask*#index[Subnet Mask] (Netmask) utilizzato in IPv4 per dedurre se un destinatario risiede sulla medesima rete fisica viene eliminato.

=== SLAAC
#figure(image("images/2026-06-24-17-08-26.png", width: 50%))

Lo *SLAAC*#index[SLAAC] (Stateless Address Auto Configuration) è il meccanismo di autoconfigurazione di IPv6. Permette a due o più host, connessi anche da solo un cavo tra loro, che utilizzano IPv6 di ottenere automaticamente un indirizzo IP senza la presenza di un router. L'intero processo è basato sul protocollo *NDP*#index[NDP] (Neighbor Discovery Protocol) che a sua volta incapsulata pacchetti ICMPv6. Il NDP sostituisce il protocollo ARP dell'IPv4, permettendo quindi di risolvere anche gli indirizzi MAC. Il NDP definisce cinque (ma ne vedremo quattro) tipologie di messaggi:

+ *Router Solicitation (RS)*#index[Router Solicitation (RS)]: un host che fa uso di SLAAC, invierà automaticamente sulla rete dei pacchetti RS. Questi pacchetti servono per "sollecitare" eventuali router nella rete a presentarsi con il proprio IP in modo tale che l'host conosca il loro indirizzo. Nell'immagine sottostante si può notare come il PC1 invia un pacchetto RS contenente il proprio indirizzo IP (link-local autogenerato da MAC) e specificando come indirizzo di destinazione l'indirizzo *All-Routers Multicast*#index[All-Routers Multicast]. In questo modo, soltanto i router considereranno questo pacchetto. Il tipo per RS è 133.
  #figure(image("images/2026-06-24-17-31-14.png", width: 50%))

+ *Router Advertisement (RA)*#index[Router Advertisement (RA)]: i router rispondono a pacchetti RS oppure inviano periodicamente pacchetti RA per annunciare la loro presenza. All'interno è possibile trovare l'indirizzo IPv6 del router, il prefisso che viene utilizzato su quel segmento di rete così come la lunghezza del prefisso e altri parametri utili come l'MTU (Maximum Transfer Unit) o il Router Lifetime (per quanto le informazioni inviate sono da supporre valide). Attraverso il blocco *Prefix Information Option (PIO)*#index[Prefix Information Option (PIO)], contenuto nel campo Options... nei messaggi RA, il router utilizza il *Flag L (On-Link)* per comunicare agli host se un determinato prefisso risiede sulla stessa rete fisica. Questo disaccoppiamento logico permette topologie dinamiche e la coesistenza di prefissi multipli sullo stesso dominio di collisione.
  #figure(image("images/2026-06-24-17-37-24.png", width: 50%))
  #figure(image("images/2026-06-23-19-23-29.png", width: 50%), caption: "Pacchetto RA")
  #figure(image("images/2026-06-23-21-23-48.png", width: 50%), caption: "Pacchetto Prefix Information")

  #observation()[
    La specifica originale dei Router Advertisement non prevedeva l'annuncio dei server DNS, aggiunto solo in un secondo momento tramite l'opzione *RDNSS*. Con dispositivi datati o mal implementati è quindi possibile ottenere un indirizzo IPv6 valido ma nessun server DNS, restando di fatto impossibilitati a navigare.
  ]

+ *Neighbor Solicitation (NS)*#index[Neighbor Solicitation (NS)]: i messaggi NS sono simili al protocollo ARP in IPv4. Vengono utilizzati per controllare la disponibilità di un host e anche per il *DAD*#index[DAD] (Duplicate Address Detection). L'indirizzo sorgente può essere link-local oppure non specificato (`::/128`) se si sta eseguendo il DAD. L'indirizzo di destinazione è invece il *Solicited-Node Multicast*#index[Solicited-Node Multicast]. Il tipo è 135.
  #figure(image("images/2026-06-24-17-52-57.png", width: 50%))

+ *Neighbor Advertisement (NA)*#index[Neighbor Advertisement (NA)]: i messaggi NA vengono inviati in risposta ai NS oppure per comunicare che un indirizzo è cambiato. L'indirizzo sorgente è quello dell'host che invia il messaggio. L'indirizzo di destinazione può essere link-local (se sta rispondendo ad un NS) oppure *All-Nodes Multicast*#index[All-Nodes Multicast] se si vuole comunicare un cambio di indirizzo. Il tipo è 136.
  #figure(image("images/2026-06-24-17-53-12.png", width: 50%))

=== Duplicate Address Detection (DAD)

Al momento dell'autoconfigurazione dell'Interface ID (generato ad esempio tramite EUI-64 o meccanismi randomizzati), il dispositivo deve validarne l'univocità tramite il *DAD*#index[DAD]. Questo processo invia una *Neighbor Solicitation* per l'indirizzo appena calcolato e attende una replica. Poiché il DAD si basa su un approccio "silenzio-assenso" (se scade il timer senza risposte, l'IP viene assunto libero), in reti wireless affollate o rumorose eventuali pacchetti persi possono portare a collisioni di IP, causando disservizi complessi e non facilmente rilevabili dagli switch di Livello 2.

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

Inoltre, il DHCPv6 non identifica i client tramite il MAC address. Dato che oggi i dispositivi cambiano MAC address di continuo per ragioni di privacy (MAC randomization), usare il MAC manderebbe in tilt il server DHCP. Invece, si usa il *DUID*#index[DUID] (DHCP Unique Identifier). Il DUID viene generato dal sistema operativo, di solito fondendo il MAC address originario e altri parametri, e rimane fisso e costante nel tempo, garantendo al server DHCP di riconoscere sempre lo stesso client.

== Frammentazione e Path MTU Discovery
Ogni rete fisica ha una dimensione massima per i pacchetti (es. 1500 byte per Ethernet). In IPv4, se un pacchetto arriva a un router intermedio e la rete successiva ha una MTU più piccola (es. 1492 byte per via di incapsulamenti PPPoE come nelle vecchie ADSL), il router "taglia" il pacchetto in due frammenti usando i campi di frammentazione dell'header IPv4. Questo crea un sovraccarico di lavoro (overhead) enorme per il router, che deve ricalcolare il Checksum e gestire la suddivisione.

In IPv6, la regola è drastica: i router intermedi non frammentano mai i pacchetti.
Se un router IPv6 riceve un pacchetto troppo grande per la rete successiva, lo scarta e manda indietro un messaggio ICMPv6 di errore chiamato *Packet Too Big*#index[Packet Too Big]. Questo messaggio contiene la dimensione dell'MTU consentita. Il nodo sorgente riceve l'errore e aggiorna il suo Path MTU (PMTU) per quella specifica destinazione. Da quel momento in poi, sarà il nodo sorgente (e solo lui) a generare pacchetti più piccoli, inserendo un Extension Header di frammentazione se necessario.

Questo sistema è infinitamente più efficiente per i router di dorsale, ma ha un punto debole mortale: gli amministratori di rete incompetenti. Spesso chi configura i firewall blocca totalmente il traffico ICMP, credendo di aumentare la sicurezza ("così non mi pingano!"). In IPv6, se si blocca l'ICMP, si bloccano anche i messaggi Packet Too Big. Il nodo sorgente non saprà mai perché i suoi pacchetti vengono scartati e la connessione andrà in stallo senza spiegazioni (i famosi "buchi neri" di rete).

Infine, una salvaguardia imposta dall'IPv6: lo standard vieta l'esistenza di link con MTU inferiore a 1280 byte. Mentre in IPv4 potevano esistere reti con payload piccolissimi (ignorando il consiglio teorico dei 576 byte), in IPv6 il limite di 1280 byte è legge.
E cosa succede con reti come il Bluetooth, LoRa o Zigbee (IEEE 802.15.4), che hanno MTU a livello fisico minuscole (spesso inferiori ai 100 byte)? Semplice: devono usare un Adaptation Layer (uno strato software intermedio, come 6LoWPAN) che si occupa di comprimere l'header IPv6 e gestire una frammentazione invisibile al livello IP superiore, garantendo all'IPv6 di vedere sempre e comunque i suoi 1280 byte garantiti.
#pagebreak()

