#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

#pagebreak()

= Il Routing
Il *routing* all'interno di una rete si divide principalmente in due paradigmi architetturali:
- *Centralizzato*: un controllore globale possiede una mappatura onnisciente della topologia di rete (similmente a un navigatore satellitare) e determina a priori i percorsi ottimali per tutti i nodi.
- *Distribuito*: ogni router deduce autonomamente il nodo successivo ("next hop") ideale basandosi su informazioni di stato locale e sullo scambio di dati con i nodi adiacenti.

Per garantire elevati standard di resilienza, l'infrastruttura di Internet adotta il routing distribuito: in caso di guasto hardware o indisponibilità di un nodo, i router limitrofi sono in grado di ricalcolare dinamicamente un percorso alternativo. Su scala globale, un sistema centralizzato introdurrebbe un *single point of failure*#index[single point of failure] critico, generando inoltre un overhead di comunicazioni di controllo incompatibile con le capacità della rete.
Esiste teoricamente il *Source Routing*, una tecnica in cui l'host mittente codifica all'interno del pacchetto l'elenco esatto dei nodi da attraversare. Tale approccio è oggi rigorosamente interdetto sull'Internet pubblica per gravissime implicazioni di sicurezza informatica, in quanto consentirebbe a un attaccante di offuscare l'origine reale del traffico forzandone il rimbalzo su nodi arbitrari.

I protocolli di routing distribuito si classificano ulteriormente in:
- *Proattivi*: il protocollo opera in *background* calcolando e aggiornando costantemente le tabelle di routing, indipendentemente dal traffico effettivo. Garantisce instradamenti immediati, ma consuma banda ininterrottamente.
- *Reattivi*: l'esplorazione del percorso viene innescata esclusivamente *on-demand*, ovvero nel momento in cui si presenta la necessità di trasmettere un pacchetto.
- *Flooding*#index[Flooding]: il pacchetto viene replicato e inoltrato su tutte le interfacce disponibili, nella probabilità statistica di raggiungere prima o poi il destinatario. Pur essendo dispendioso in termini di risorse, in contesti di assoluta emergenza (o per reti fortemente instabili) rappresenta la strategia d'inoltro più robusta, se opportunamente controllata.

La scelta del paradigma di routing dipende in larga misura dalla volatilità della topologia di rete. In uno scenario caratterizzato da instabilità dei link fisici (frequenti disconnessioni o variazioni), un protocollo proattivo inonderebbe la rete di messaggi di aggiornamento a ogni singola fluttuazione. In contesti dove il volume del traffico dati è contenuto ma la topologia è altamente dinamica, l'approccio reattivo si rivela di gran lunga più efficiente.
Tuttavia, qualora la mutevolezza della rete sia talmente elevata da rendere obsoleto il percorso reattivo ancor prima della sua completa instaurazione, la topologia collassa e l'unica strategia d'inoltro in grado di garantire il recapito del pacchetto rimane il *flooding*.

I protocolli sono inoltre classificati in base a come si scambiano informazioni:
- *Distance-Vector*#index[Distance-Vector]: ogni router può scambiare informazioni soltanto con i suoi router vicini. Ogni router contiene al suo interno una tabella "Vettore delle distanze" che associa ad un'interfaccia un costo in termini di hop. I router non conoscono l'intera topologia della rete.
- *Link-State*#index[Link-State]: ogni router invia informazioni a tutte le reti direttamente connesse in broadcast su ogni interfaccia tranne quella di origine. Sono algoritmi lenti a convergere e che richiedono molta memoria e potenza di calcolo.
#figure(image("images/2026-07-03-23-59-56.png"))

== La Complessità del Routing
Da un punto di vista puramente matematico, il routing è assimilabile alla ricerca del cammino minimo all'interno di un grafo pesato. Tuttavia, mentre la teoria dei grafi garantisce la calcolabilità dell'ottimo teorico, l'applicazione ingegneristica è vincolata ai limiti fisici, ai tempi di latenza e all'hardware degli apparati di rete. _I protocolli reali costituiscono dunque approssimazioni dell'ottimo matematico_.

Si considerino, ad esempio, approcci limite come l'*Hot Potato Routing*#index[Hot Potato Routing] (in cui un pacchetto viene immediatamente smistato a un vicino casuale pur di svuotare i buffer). Questo paradigma trova fondamento razionale nelle reti "Full Optical": in queste architetture, il tempo necessario per la conversione elettro-ottica (fondamentale per leggere l'header del pacchetto e interrogare la tabella di routing) risulta nettamente superiore al tempo di propagazione fisica. Di conseguenza, in una topologia fortemente magliata, l'inoltro cieco può paradossalmente garantire latenze inferiori rispetto a un'elaborazione del percorso ottimo. Ciò dimostra come la progettazione algoritmica debba sempre integrarsi con le specificità dello strato fisico.

== Metriche e Pesi di Instradamento
La modellazione algoritmica prevede l'assegnazione di "pesi" agli archi del grafo (i link di rete). A livello matematico, qualsiasi parametro di penalità imputabile a un nodo (es. probabilità di congestione) può essere formalmente traslato sui suoi archi incidenti.

La selezione della metrica ottimale è uno dei temi più critici. Una valutazione puramente teorica porterebbe a favorire concetti quali la larghezza di banda residua, ideale per l'instradamento di trasferimenti *Delay-Tolerant*#index[Delay-Tolerant]. Viceversa, per i flussi in tempo reale (*Real-Time flows* come lo streaming video o il gaming), la larghezza di banda assoluta perde rilevanza rispetto alla minimizzazione del *jitter*#index[jitter] (la varianza del ritardo di trasmissione). Un ritardo di rete costante può essere facilmente assorbito mediante un buffer di riproduzione, mentre fluttuazioni costanti generano disservizi inaccettabili.

Ciò nonostante, l'inclusione di metriche dinamiche (congestione, latenza o jitter) all'interno dei pesi algoritmici genera gravi esiti applicativi. Poiché i valori misurati su una rete in attività oscillano a frequenze altissime, i protocolli innescherebbero variazioni continue delle rotte (effetto di instabilità noto come *route flapping*#index[route flapping]), rincorrendo gradienti transitori privi di significato statistico a lungo termine.

A livello accademico è stata storicamente analizzata l'*Expected Transmission Count*#index[Expected Transmission Count] (ETX) per le reti wireless, che stima la qualità del link in base al numero di ritrasmissioni necessarie per recapitare un pacchetto. Il limite strutturale di questa metrica è la necessità pregressa di traffico per la validazione statistica: in assenza di traffico, il router non dispone di dati. L'introduzione della sua variante speculativa, denominata *Optimistic ETX*#index[Optimistic ETX] (che in assenza di trasmissioni recenti assume ottimisticamente il link come privo di errori), portò i router a convergere disastrosamente verso percorsi instabili o interrotti, causando gravi colli di bottiglia.

Di conseguenza, le soluzioni *enterprise* adottano quasi esclusivamente metriche statiche o semi-statiche: il conteggio dei salti (*hop count*#index[hop count]) o la capacità trasmissiva nominale dell'arco. L'unico parametro dinamico raccomandabile, prettamente in ambito wireless, è il Rapporto Segnale-Rumore (SNR), la cui varianza fisica è predicibile e non dipende direttamente dal carico di traffico istantaneo.

== RIP (Routing Information Protocol)
Tra i protocolli proattivi basati sui vettori di distanza, il *RIP*#index[RIP] rappresenta lo standard di riferimento per la sua semplicità architetturale. Il funzionamento prevede che ciascun router trasmetta la propria tabella di routing completa ai soli nodi adiacenti a intervalli regolari (tipicamente ogni 30 secondi), o in modalità *triggered update*#index[triggered update] a seguito di variazioni di stato.
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

La vulnerabilità principale degli algoritmi di routing *Distance-Vector*#index[Distance-Vector] (basati sui vettori di distanza) è il noto problema del *Count to Infinity*#index[Count to Infinity] (conteggio all'infinito). Quando un collegamento fisico cessa di funzionare, i router adiacenti potrebbero condividere tabelle di instradamento ormai obsolete prima che l'informazione sul guasto si sia propagata uniformemente. Questo ritardo di sincronizzazione innesca un loop di instradamento in cui i router continuano ad aggiornarsi a vicenda, incrementando artificialmente e all'infinito il costo per raggiungere una destinazione che, di fatto, è diventata irraggiungibile.

#example("Il problema del Count to Infinity")[
  #figure(image("images/2026-07-12-23-17-01.png"))
  Consideriamo una topologia in cui l'algoritmo di Bellman-Ford ha raggiunto la convergenza. In questa fase di stabilità, ogni router possiede le voci di instradamento corrette: il router B sa di poter raggiungere la rete C con un costo pari a 1, mentre il router A sa di poter raggiungere C passando per B con un costo totale pari a 2.

  #figure(image("images/2026-07-12-23-17-10.png"))
  Se il collegamento tra B e C si interrompe, B rileva il guasto e deduce di non poter più raggiungere C tramite quel link, rimuovendo la rotta dalla propria tabella. Tuttavia, prima che B riesca a inviare un aggiornamento per notificare il guasto, potrebbe ricevere un normale aggiornamento periodico da A. In questo messaggio, A continua ad annunciare (erroneamente) di poter raggiungere C con un costo di 2.
  Poiché B sa di poter raggiungere A con un costo di 1, accetta questa rotta ingannevole credendo che A disponga di un percorso alternativo. B aggiorna così la sua tabella, impostando una rotta verso C via A con un costo pari a 3 (1 + 2). Al ciclo successivo, A riceverà la nuova tabella di B (costo 3) e aggiornerà a sua volta il proprio costo a 4 (1 + 3). I due router continueranno a scambiarsi queste informazioni errate, incrementando la metrica verso l'infinito.
]

Per mitigare e risolvere questa problematica strutturale, i protocolli (come il RIP) implementano specifici accorgimenti algoritmici:

+ *Definizione dell'Infinito*: per impedire che il conteggio prosegua illimitatamente, la metrica massima viene limitata superiormente a un valore prefissato, tipicamente 16 (rappresentabile a livello di bit come lo 0 matematico in una logica binaria a 4 bit). Il raggiungimento di tale soglia sancisce l'immediata irraggiungibilità della rete (*unreachable*), spezzando così il ciclo iterativo.

+ *Split Horizon*#index[Split Horizon]: è una regola tassativa di prevenzione dei loop. Stabilisce che un router non deve mai annunciare l'esistenza di una determinata rotta sull'interfaccia di rete dalla quale quella stessa rotta è stata originariamente appresa (es. se A ha imparato da B come arrivare a C, A non dirà mai a B che sa come arrivare a C).
  #figure(image("images/2026-07-12-23-18-01.png"))

+ *Route Poisoning (e Poison Reverse)*#index[Route Poisoning (e Poison Reverse)]: si tratta di un'ottimizzazione aggressiva dello Split Horizon. Anziché omettere in silenzio la rotta, il router annuncia attivamente la rotta compromessa sull'interfaccia da cui l'ha appresa, ma le associa forzatamente e in modo artificiale una metrica infinita (16). In questo modo, la rotta viene istantaneamente ed esplicitamente invalidata per i nodi adiacenti, accelerando drasticamente il tempo di convergenza in caso di guasto.
  #figure(image("images/2026-07-12-23-17-54.png"))

== Il Protocollo OSPF (Open Shortest Path First) e Dijkstra
Contrapposto alla famiglia Distance-Vector, il protocollo OSPF si basa sull'algoritmo di routing Link-State di Dijkstra. Questo garantisce prestazioni teoriche eccellenti in termini di calcolo (la complessità dell'algoritmo è $E + V log V$), ma impone vincoli hardware stringenti: affinché l'albero dei cammini minimi possa essere risolto, ogni router deve prima acquisire e mantenere nella propria memoria l'intera topologia della rete, generata attraverso il costante inoltro incrociato di *Link-State Advertisements*#index[Link-State Advertisements] (LSA).

#figure(image("images/2026-07-03-23-55-56.png"))

Questa disseminazione capillare si traduce, in reti molto estese, in un duplice collo di bottiglia: il sovraccarico costante della banda per il traffico LSA e la saturazione dei processori. Ricevuto un aggiornamento topologico, ciascun router è costretto a reiterare l'algoritmo di Dijkstra ripartendo da zero; qualora la CPU non fosse sufficientemente prestante, il calcolo potrebbe essere interrotto dall'arrivo di una nuova notifica LSA, portando il nodo al collasso computazionale.

Di conseguenza, l'OSPF possiede limiti drastici di scalabilità lineare. Il design del protocollo mitiga tale problema compartimentando l'infrastruttura logica in "Aree" gerarchiche. All'interno dell'Area, i router condividono un set topologico unificato ed eleggono specifici router di transito (*Area Border Router*#index[Area Border Router]), i quali aggregano e inoltrano il routing unicamente verso la dorsale logica (*Backbone*#index[Backbone]). Quest'architettura abbatte il carico computazionale, cedendo come contropartita l'ottimalità globale del percorso: la forzatura dell'instradamento sui *Border Router* genera cammini inter-area basati su ottimi puramente locali.

#figure(image("images/2026-07-03-23-57-38.png", width: 60%))

== OSPF, Link-State e Software-Defined Networking (SDN)
Avendo piena visione della topologia di rete, i protocolli Link-State quali l'OSPF consentono l'adozione di metriche algoritmiche sofisticate, a patto di stabilire eque norme di sblocco (*tie-breaker*, come la selezione del router con l'indirizzo IP inferiore in caso di metriche speculari) essenziali per garantire il determinismo e facilitare il *troubleshooting* della rete in fase di analisi.

Tuttavia, configurando l'OSPF per basare le metriche di rotta esclusivamente sulla larghezza di banda nominale, emergono dei limiti di adattabilità dinamica: l'algoritmo instraderebbe il traffico verso percorsi in fibra ad alta capacità sebbene in potenziale stato di saturazione fisica, trascurando link più lenti ma completamente sgombri.

Questa rigidità algoritmica giustifica la migrazione dell'industria verso il paradigma *Software-Defined Networking*#index[Software-Defined Networking] (SDN). Nell'architettura SDN, le funzioni del "cervello" dei router (il Control Plane algoritmico come OSPF o RIP) sono delegate a un server di controllo centralizzato (*SDN Controller*#index[SDN Controller]), riducendo fisicamente i router a semplici elaboratori di commutazione dei pacchetti (*Data Plane*#index[Data Plane] o *Network Elements*).
Il Controller riceve dati di telemetria dalle infrastrutture, calcola metriche istantanee multi-parametro e sovrascrive le tabelle di inoltro dei vari interruttori sfruttando protocolli di configurazione (*OpenFlow*#index[OpenFlow]). A causa delle stringenti necessità di bassa latenza tra le comunicazioni di gestione, l'SDN non scala sull'Internet pubblica, ma rappresenta l'attuale standard progettuale intra-struttura nei Data Center e nelle topologie Cloud/Kubernetes.

== Reti Mesh e IoT
Laddove non via sia un'infrastruttura cablata (es. costellazioni di droni o sistemi di sensori estesi per ambito agricolo), si introducono le *Reti Mesh*#index[Reti Mesh] (o *Ad-Hoc Networks*#index[Ad-Hoc Networks]). In queste reti destrutturate, il router perde la sua accezione di entità fisica esclusiva, in quanto ogni dispositivo finale agisce simultaneamente da client e nodo di inoltro (multi-hop) basandosi sulla sovrapposizione delle limitate coperture dei moduli radioelettrici.

Il panorama dei protocolli operativi è frammentato: l'offerta include approcci reattivi come l'AODV (che invia query esplorative per tracciare percorsi on-demand), proattivi ottimizzati come l'OLSR, e varianti sperimentali di flooding condizionato come B.A.T.M.A.N. o Meshtastic.

Nel dominio dell'IoT domestico ed enterprise (Smart Home/Alexa), l'assenza di un vero standard universale ha spinto all'adozione del consorzio *Thread*#index[Thread]. Paradossalmente, all'interno della rete Thread, la base dei calcoli di instradamento è delegata ad un'architettura derivata dal RIP. Benché in netta contrapposizione alle classiche specifiche del wireless dinamico, la sua implementazione pratica risponde ai requisiti minimi fintantoché la topologia IoT rimane rigidamente stazionaria; a seguito di variazioni topologiche (come la rilocazione di un nodo), l'intera rete mesh si espone al collasso del framework di instradamento.

== Il BGP e il routing tra Autonomous System
I protocolli sinora discussi (RIP, OSPF, AODV) costituiscono *Interior Gateway Protocols*#index[Interior Gateway Protocols] (IGP). L'implementazione e i parametri di un IGP soggiacciono interamente all'entità amministratrice del singolo dominio logico di rete (*Autonomous System*#index[Autonomous System] o AS).

#figure(image("images/2026-07-03-23-59-56.png"))

La comunicazione infrastrutturale e di transito fra AS disgiunti richiede invece l'impiego di un *Exterior Gateway Protocol*#index[Exterior Gateway Protocol] (EGP). All'atto pratico, l'unico standard di fatto in operatività sull'infrastruttura Internet mondiale è il *Border Gateway Protocol*#index[Border Gateway Protocol] (BGP). L'insediamento monopolistico del BGP deriva non dall'assoluta eccellenza computazionale del protocollo, ma dall'impossibilità tecnica e infrastrutturale di coordinare una sostituzione sincronizzata dell'ecosistema internet.

#figure(image("images/2026-07-04-00-00-16.png"))

Lo scopo funzionale del BGP disattende l'individuazione di percorsi con metriche matematiche ottime. Il focus algoritmico consiste nel determinare rotte globalmente "fattibili" che aderiscano scrupolosamente agli accordi economici e alle restrizioni burocratico-politiche di *peering* vigenti fra i soggetti amministratori. A titolo esplicativo, un ISP italiano devierà deliberatamente il traffico in transito per il suolo francese via Corsica, malgrado una minore rapidità topologica, in ossequio all'economicità del contratto di interscambio rispetto all'operatore confinante nel Nord Italia.

A livello tecnico, il BGP risolve i propri alberi decisionali non per sommatorie di pesi continui, ma elaborando iterativamente attributi prioritari ordinati in gerarchia rigida (tra cui *Weight*#index[Weight], *Local Preference*#index[Local Preference], *AS Path*#index[AS Path], *MED*#index[MED] e *Community*#index[Community]). Il parametro maggiormente indicativo, l'*AS Path*#index[AS Path], computa il numero di sistemi autonomi indipendenti attraversati: un dato di elevata significatività logico-strutturale ma di marginale affinità con l'effettivo calcolo di latenza hardware in millisecondi.

Il BGP configura l'architettura di Internet. Benché lento nell'assimilazione dei ricalcoli di scala intercontinentale (i tempi di convergenza raggiungono ore), esso fornisce all'infrastruttura la stabilità cruciale per il corretto sostentamento globale. Criticamente, in caso di applicazione di configurazioni improprie (causa dei noti *Black Hole*#index[Black Hole] di routing) o restrizioni nazionali ostili, le tabelle decisionali del BGP costituiscono lo strumento cardine per applicare politiche di embargo logico internazionale (una *Splinternet*#index[Splinternet]).