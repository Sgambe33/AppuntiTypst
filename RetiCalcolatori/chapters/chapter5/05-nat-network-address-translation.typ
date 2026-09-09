#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

#pagebreak()

= NAT (Network Address Translation)

Il Network Address Translation (NAT) è stato introdotto negli anni '90 come soluzione transitoria per arginare l'esaurimento degli indirizzi IPv4, in attesa dell'implementazione su larga scala dello standard IPv6. L'approccio si basa sulla definizione di blocchi di indirizzi IP "privati":


#definition("Indirizzi Privati (RFC 1918)")[
  L'Internet Engineering Task Force (IETF) ha riservato tre blocchi di indirizzi IP per l'uso all'interno di reti private: `10.0.0.0/8`, `172.16.0.0/12` e `192.168.0.0/16`. Questi indirizzi non sono univoci a livello globale e non possono essere instradati nella rete Internet pubblica.
]

Il NAT, posizionato tipicamente sul router di confine, agisce traducendo gli indirizzi IP privati dei dispositivi della rete interna in uno o più indirizzi IP pubblici, consentendo così l'accesso a Internet. Ne esistono tre varianti principali:

+ *NAT Statico*#index[NAT Statico]: prevede un'associazione univoca (rapporto 1:1) tra un indirizzo IP privato e un indirizzo IP pubblico. Questa configurazione è utilizzata prevalentemente per esporre server o servizi interni affinché siano sempre raggiungibili dall'esterno tramite un IP fisso. Essendo una mappatura uno-a-uno, non contribuisce in alcun modo a mitigare la scarsità di indirizzi IPv4.
  #figure(image("images/2026-06-22-20-05-55.png", width: 60%))

+ *NAT Dinamico*#index[NAT Dinamico]: associa dinamicamente un IP pubblico, prelevato da un pool predefinito, a un IP privato nel momento in cui questo genera traffico in uscita. L'indirizzo pubblico viene poi rilasciato al termine della sessione di comunicazione. Tale meccanismo opera secondo una logica "first-come, first-served" e presenta forti limitazioni: l'esaurimento temporaneo degli IP nel pool preclude l'accesso a Internet per tutti gli altri dispositivi della rete locale.
  #figure(image("images/2026-06-23-12-13-29.png", width: 70%))

+ *NAPT / PAT *: consente a molteplici dispositivi di una rete privata di accedere a Internet utilizzando un singolo indirizzo IPv4 pubblico (rapporto N:1 tra indirizzi privati e indirizzo pubblico). Il PAT sfrutta i numeri di porta di livello di trasporto per tracciare le diverse sessioni di comunicazione, alterando la porta sorgente durante la traslazione e potendo gestire teoricamente fino a $2^{16}$ (65.536) connessioni simultanee. Il NAPT fa uso di una NAT Translation Table. Un binding, all'interno di quest'ultima, è identificato da `{IP, Proto, Port}(interni) <=> {IP, Proto, Port}(esterni)`.
  - Pacchetto in uscita (Interfaccia Interna): quando un host interno invia un datagramma verso l'esterno, il NAT cerca un binding (una regola di traslazione) esistente. Se non esiste, crea un nuovo binding assegnando una nuova porta sorgente, sostituisce l'indirizzo IP privato con quello pubblico del router, ricalcola i checksum e inoltra il pacchetto.
  - Pacchetto in ingresso (Interfaccia Esterna): quando un pacchetto arriva dalla rete pubblica, il NAT consulta la tabella usando l'IP e la porta di destinazione. Se trova un binding, riscrive l'IP e la porta per inoltrarlo all'host locale.
  #observation()[
    Se un pacchetto arriva sull'interfaccia esterna e non esiste un binding corrispondente nella tabella, il NAT non sa a chi inoltrarlo e scarta (drop) il pacchetto.
  ]

// Questa tecnica introduce però alcune problematiche:
// - *Violazione dell'astrazione dei livelli*: costringe un apparato di livello 3 (il router) a ispezionare i pacchetti fino al livello 4 (TCP/UDP). L'eventuale adozione di futuri protocolli privi del concetto di "porta" renderebbe il NAPT inefficace, venendo a mancare l'elemento chiave per la traslazione.
// - *Incompatibilità con i protocolli di sicurezza*: il NAT altera l'intestazione IP originale, compromettendo l'integrità richiesta da protocolli di sicurezza come IPsec in modalità AH (Authentication Header). Il ricevente, rilevando una discrepanza tra l'header modificato e la firma crittografica, scarterà il pacchetto. Le contromisure necessarie (come il *NAT Traversal*#index[NAT Traversal] tramite l'incapsulamento del traffico crittografato all'interno di ulteriori datagrammi UDP) introducono *overhead*#index[overhead] aggiuntivo, sprecano larghezza di banda e generano gravi interferenze tra i meccanismi di controllo della congestione a causa di tunnel annidati (es. TCP-over-TCP).

== Gestione degli stati

L'utilizzo del NAT introduce un comportamento non deterministico nelle comunicazioni. Nel caso del protocollo *connection-oriented*#index[connection-oriented] TCP, la gestione dello stato è lineare: l'apertura (flag SYN) e la chiusura (flag FIN o RST) della connessione dettano chiaramente al NAT quando creare e distruggere il relativo binding.

Per il protocollo UDP (*connectionless*#index[connectionless]), l'assenza di meccanismi espliciti di instaurazione e terminazione della sessione rende la gestione complessa. Il NAT deve creare un *binding* temporaneo al passaggio del primo pacchetto, basandosi su timer di inattività (es. Timer Refresh di tipo Bidirectional, Outbound o Inbound) per rimuoverlo. Un timeout eccessivamente breve provoca disconnessioni casuali (critiche nel gaming o nello streaming), mentre uno troppo lungo comporta un inutile spreco di risorse sul router. Di conseguenza, le applicazioni moderne (come software VoIP o messaggistica) sono obbligate a implementare meccanismi di *keep-alive*, inviando periodici pacchetti fittizi al solo scopo di impedire la chiusura della porta da parte del NAT.

#definition("Tipologie di timers")[
  + Bidirectional: il timer viene aggiornato da pacchetti sia in entrata che in uscita.
  + Outbound: solo i pacchetti in uscita aggiornano il timer.
  + Inbound: solo i pacchetti in entrata aggiornano il timer.
]

#observation()[
  Per l'UDP, il comportamento del NAT è governato da filtri che determinano l'accettazione dei pacchetti in ingresso. Questi filtri classificano i NAT in quattro tipologie: *Symmetric*, *Full Cone*, *Restricted Cone* e *Port Restricted Cone*.
]

=== Comportamenti NAT UDP
+ *Full Cone NAT (Endpoint Independent)*#index[Full Cone NAT]\
  #figure(image("images/2026-07-13-13-24-00.png", width: 60%))
  - Funzionamento: è la modalità più permissiva. Quando un host interno invia un pacchetto UDP all'esterno, il NAT alloca una porta pubblica e crea un binding. Da quel momento in poi, la porta pubblica del router rimane aperta e qualsiasi host esterno (da qualunque indirizzo IP e qualunque porta) può inviare pacchetti a quella porta; il NAT li inoltrerà tutti all'host interno.
  - Criticità: questa modalità garantisce il funzionamento di quasi tutte le applicazioni UDP, ma presenta gravissimi problemi di sicurezza (chiunque può fare network scanning o inviare traffico arbitrario verso la porta aperta) ed è inefficiente perché "brucia" una porta pubblica per ogni applicazione.

+ *Restricted Cone NAT (Endpoint Address Dependent)*#index[Restricted Cone NAT]\
  #figure(image("images/2026-07-13-13-24-11.png", width: 60%))
  - Funzionamento: il filtro di accettazione si basa esclusivamente sull'indirizzo IP. Il NAT inoltra un pacchetto in ingresso verso l'host interno solo e soltanto se l'host interno aveva precedentemente inviato un pacchetto verso quello specifico indirizzo IP esterno.
  - Caratteristica: la porta sorgente utilizzata dall'host esterno per rispondere non ha importanza, il NAT verifica solo che l'IP mittente sia tra quelli già contattati

+ *Port Restricted Cone NAT (Endpoint Port Dependent)*#index[Port Restricted Cone NAT]\
  #figure(image("images/2026-07-13-13-24-26.png", width: 60%))

  - Funzionamento: è una variazione della precedente. Il filtro in ingresso valuta  la porta. L'host esterno può raggiungere l'host interno solo se l'host locale aveva precedentemente inviato un pacchetto verso quella specifica porta. Ogni traffico proveniente da porte esterne diverse viene silenziosamente scartato.

+ *Symmetric NAT (Endpoint Address and Port Dependent)*#index[Symmetric NAT]\
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
In applicazioni Peer-to-Peer, VoIP (es. protocollo SIP/VoLTE) e gaming, un host contatta un server di segnalazione dichiarando il proprio indirizzo IP e porta per farsi chiamare da un altro peer (*Referral Handover*#index[Referral Handover]). Sotto NAT, l'indirizzo privato dell'host è inutile per l'esterno. Il protocollo *STUN*#index[STUN] (Simple Traversal of UDP Through NATs, RFC 3489) fu creato per permettere alle applicazioni di scoprire il proprio indirizzo pubblico e il tipo di NAT.
#observation()[Lo STUN è oggi considerato deprecato e inaffidabile. Questo perché i NAT sono non-deterministici (possono cambiare mappatura a seconda del carico o della destinazione) e perché nel percorso di rete si trovano frequentemente NAT in cascata, rendendo impossibile ottenere una risposta utile.]

=== Carrier-Grade NAT (NAT in Cascata) e Port Multiplexing
Gli ISP moderni, avendo esaurito anche loro gli IP pubblici, applicano spesso un secondo livello di NAT all'interno della loro infrastruttura (CGNAT). Ciò crea scenari paradossali in cui un utente esce con un IP pubblico per raggiungere una destinazione (es. Tokyo) e con un altro IP pubblico per un'altra destinazione (es. Los Angeles). Inoltre, le tecniche dei router per gestire l'esaurimento delle porte generano comportamenti anomali:
- *Port Preservation*#index[Port Preservation]: il NAT cerca di non cambiare il numero di porta interno. Se due host interni richiedono la stessa porta, il primo vince e al secondo viene cambiata. Se il secondo insiste, il router potrebbe far scadere il binding del primo, causando malfunzionamenti casuali.
- *Port Multiplexing*#index[Port Multiplexing]: Il NAT cerca di far uscire più host interni usando la stessa porta esterna, discriminando in base alla destinazione. Funziona a basso carico, ma genera fallimenti ("mutando forma") in condizioni di alto traffico.

=== Sicurezza e UPnP (Universal Plug and Play)
Il protocollo IGD (Internet Gateway Device) via UPnP permette ai dispositivi interni (es. console, NAS) di chiedere al NAT di aprire automaticamente delle porte in ingresso per abilitare connessioni entranti. Questo meccanismo agisce all'insaputa dell'utente e del firewall, creando gravissimi buchi di sicurezza (Security Issues), lasciando porte permanenti aperte e causando conflitti se due dispositivi interni richiedono la stessa porta.
