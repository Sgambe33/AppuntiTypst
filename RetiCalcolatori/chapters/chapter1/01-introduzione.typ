#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

= Introduzione

== Topologia

Una rete è un'infrastruttura di nodi che connettono altri nodi. La topologia di una rete può essere rappresentata come un grafo (orientato o non orientato). Un vertice rappresenta un elemento passivo o attivo della rete mentre un arco rappresenta qualcosa che connette due vertici.

La struttura di una rete può essere analizzata sotto diversi punti di vista:

- *Topologia fisica*#index[Topologia fisica]: come sono connessi fisicamente i dispositivi (cavi, fibra, collegamenti radio). Riguarda l'hardware. In questo caso i cavi rappresentano gli archi e le estremità dei cavi i vertici.
- *Topologia IP (Logica)*#index[Topologia IP (Logica)]: come fluiscono i dati attraverso la rete basandosi sull'indirizzamento IP e le decisioni di routing. Non sempre rispecchia la topologia fisica. In questo cavo ogni dispositivo con un indirizzo IP è un nodo.
- *Topologia application-level*#index[Topologia application-level]: come comunicano le applicazioni (es. reti Overlay, P2P, CDN). Ogni applicazione è un vertice.

== Commutazione (Switching)
Prima di analizzare Internet, è necessario chiarire *come* i dati attraversano una rete di nodi intermedi. Esistono tre paradigmi storici di commutazione:

- *Circuit Switching*#index[Circuit Switching]: prima di scambiare dati viene stabilito un percorso fisico dedicato tra sorgente e destinazione, che resta riservato per l'intera durata della comunicazione. È il modello della telefonia tradizionale. Garantisce banda e latenza costanti, ma è inefficiente: le risorse restano allocate anche quando non si trasmette nulla (silenzi, pause) e serve una fase di setup iniziale prima di poter comunicare.

- *Message Switching*#index[Message Switching]: non esiste un circuito dedicato. L'intero messaggio viene inviato a un nodo intermedio, che lo memorizza per intero e lo inoltra al nodo successivo quando il collegamento è libero (approccio *store-and-forward*#index[store-and-forward]). Elimina lo spreco del circuito riservato, ma obbliga ogni nodo a bufferizzare messaggi potenzialmente enormi e introduce ritardi elevati: un messaggio molto grande può monopolizzare un collegamento bloccando tutti gli altri. È il progenitore concettuale del packet switching (la stessa logica store-and-forward la si ritrova, ad esempio, nell'architettura storica dell'email e delle BBS).

- *Packet Switching*#index[Packet Switching]: il messaggio viene suddiviso in unità più piccole (i *pacchetti*), ciascuna dotata di un header con le informazioni di instradamento e inoltrata in modo *indipendente*. I pacchetti condividono i collegamenti con quelli di altre comunicazioni, possono seguire percorsi diversi e vengono riassemblati a destinazione. È il modello su cui si basa Internet: massimizza l'utilizzo della banda, non richiede un circuito dedicato ed è estremamente resiliente (se un nodo cade, i pacchetti successivi vengono instradati altrove).

== Internet 101
Le idee alla base di Internet si diffusero intorno agli anni sessanta. Non è stato creato dal nulla, ma costruito passo dopo passo. Sebbene finanziato inizialmente dal Dipartimento della Difesa USA (progetto ARPANET), il suo sviluppo è stato guidato principalmente dai centri di ricerca nazionali e universitari.

Nonostante l'ambizione del progetto, il successo è dovuto a una combinazione di fattori chiave:

- *Economico*: basato su standard aperti e gratuiti. Non c'era bisogno di pagare royalties per implementare i protocolli (a differenza di tecnologie proprietarie dell'epoca).
- *Tecnico*:
  - *Packet Switching*#index[Packet Switching]: maggiore resilienza e utilizzo efficiente della banda rispetto alla commutazione di circuito.
  - *Principio End-to-End*#index[Principio End-to-End]: la rete è "stupida" (si occupa solo di spostare pacchetti) e l'intelligenza è ai bordi (negli host).
  - *Best Effort*#index[Best Effort]: la rete tenta di consegnare i pacchetti, ma non garantisce affidabilità assoluta (gestita dai livelli superiori, es. TCP).
- *Facilità d'uso (per l'epoca)*: pensato "da sviluppatori per sviluppatori", permettendo una rapida innovazione.
- *Politico*: le compagnie di telecomunicazioni tradizionali (es. SIP in Italia, AT&T in USA) negli anni '60-'70 si concentrarono sulla telefonia vocale (commutazione di circuito), sottovalutando la trasmissione dati e lasciando campo libero alla ricerca accademica.

#definition("Internet")[
  Internet *non* è una singola rete fisica. È l'*inter-connessione* logica di un enorme numero di reti eterogenee.
]

=== Cenni storici
Le prime idee risalgono agli anni '60, quando pionieri come Leonard Kleinrock e J.C.R. Licklider (con l'idea delle *Galactic Networks*) teorizzarono una rete di comunicazione universale, in un'epoca in cui il packet switching era considerato un'eresia rispetto al circuit switching e i calcolatori usavano reti rigorosamente proprietarie e isolate (DECnet, reti Novell), capaci di collegare al massimo pochi uffici o edifici vicini.

Il progetto fu finanziato dal Dipartimento della Difesa statunitense (DARPA), non perché fosse una "rete militare" in senso stretto, ma perché all'epoca gran parte dei fondi federali per la ricerca transitava dai dipartimenti (la National Science Foundation non esisteva ancora). L'interesse strategico risiedeva nella prospettiva di una rete decentralizzata, priva di un singolo nodo critico (*single point of failure*#index[single point of failure]) e capace di sopravvivere anche al collasso di una parte dell'infrastruttura.

Un fattore tecnico decisivo per la diffusione furono le *Berkeley Sockets*#index[Berkeley Sockets] (BSD Sockets): prima della loro introduzione, inviare un pacchetto in rete richiedeva codice complesso e la lettura di manuali sterminati; con le socket bastavano poche chiamate di sistema. Sul piano puramente teorico esistevano protocolli più raffinati del TCP/IP, come l'*ATM*#index[ATM] (Asynchronous Transfer Mode), dotato di una netta separazione tra dati utente, controllo e management. L'ATM non si affermò per un motivo essenzialmente storico: arrivò sul mercato quando il TCP/IP era già ampiamente adottato. Il TCP/IP non ha quindi vinto perché tecnicamente perfetto, ma perché è arrivato prima.

=== Caratteristiche fondamentali
- *Stack TCP/IP*#index[Stack TCP/IP]: internet si basa su questa suite di protocolli. Attenzione: non è composta *solo* da TCP e IP, ma include molti altri protocolli essenziali come UDP, ICMP (diagnostica), ARP (risoluzione indirizzi), OSPF/BGP (routing).
- *Standardizzazione (IETF & RFC)*:
  - La standardizzazione è gestita dalla *IETF*#index[IETF] (Internet Engineering Task Force).
  - I protocolli sono definiti nei documenti *RFC*#index[RFC] (Request For Comments). Se un protocollo diventa standard, la sua RFC diventa la specifica di riferimento. L'iter odierno è molto rigoroso, con gruppi di lavoro, round di revisione e la necessità di implementazioni di test funzionanti, per evitare di rompere la rete.
- *Indipendenza dal mezzo fisico*: il TCP/IP è *agnostico* rispetto alla tecnologia sottostante. Funziona indifferentemente su WiFi, Ethernet, fibra ottica, collegamenti satellitari, ecc.
- *Decentralizzazione*: e' un insieme di *Sistemi Autonomi* (AS) interconnessi senza un'autorità centrale che controlli tutto il traffico.

#figure(image("images/2026-06-18-22-44-22.png", width: 60%))

Le connessioni tra i sistemi autonomi possono sembrare disorganizzate ("a ragnatela") perché frutto di accordi privati tra le parti. Ogni collegamento rappresenta un *peering agreement*#index[peering agreement] (scambio traffico alla pari) o un *transit agreement*#index[transit agreement] (scambio a pagamento).

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

Un Autonomous System è un concetto *amministrativo*, non di routing: è un blocco di reti gestite da un unico operatore che dichiara al resto della rete le proprie policy di instradamento. Non esiste un'autorità centrale su Internet: il sistema funziona grazie ad accordi bilaterali (*peering*) tra AS, che decidono se e come scambiarsi il traffico o farlo transitare per conto di terzi. All'interno del proprio AS l'operatore è sovrano (può bloccare protocolli, adottare algoritmi di routing interni inefficienti, ecc.) e non è nemmeno obbligato a implementare l'intero stack TCP/IP. Il vincolo che tiene insieme questa architettura è il protocollo di routing inter-AS, il *BGP*#index[BGP] (Border Gateway Protocol), trattato nella sezione sul Routing.

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
Come sempre, per semplificare i problemi, si è deciso di suddividere il problema principale in problemi più piccoli. In questo caso si parla di *layer* della rete. Ogni layer offre i propri servizi al layer soprastante e fa uso dei servizi del layer sottostante. I layer interagiscono tra loro mediante *SAP* (Service Access Point), l'equivalente delle *API*#index[API] (Application Programming Interface).
#figure(image("images/2026-06-18-23-14-33.png", width: 50%))
Ogni layer aggiunge i propri dati in un *header* e opzionalmente in un *trailer*. Ciò permette di realizzare l'*incapsulamento*#index[incapsulamento].
#figure(image("images/2026-06-18-23-19-10.png", width: 50%))

== Stack ISO/OSI
#grid(
  columns: 2,
  [#figure(image("images/2026-06-18-23-21-56.png", height: 20%))],
  [Il modello ISO/OSI è formato da 7 livelli. E' bene conoscerlo ma di fatto non è usato. Applica alcuni concetti fondamentali come:
    - *Separazione della responsabilità*: le funzionalità non sono duplicate.
    - *Information hiding*#index[Information hiding]: l'implementazione effettiva viene nascosta, viene esposta solo l'interfaccia.

    I layer L1-L3 sono detti *Media Layers* mentre i L4-L7 sono detti *Host Layers*.],
)


#figure(image("images/2026-06-18-23-22-23.png", width: 80%))

I dati vengono scambiati tra nodi adiacenti e i nodi intermedi non dovrebbero processare le informazioni finali (a meno che non si tratti di Proxy o Gateways).

Il modello OSI prevede una rigida separazione: ogni livello dovrebbe leggere solo il proprio header ignorando il payload (*information hiding*). Questo mantiene l'architettura pulita ma genera header voluminosi e inefficienze pesanti. Il TCP/IP viola sistematicamente l'information hiding per ottimizzare le prestazioni: è anche per questo che i livelli superiori dell'OSI (Sessione, Presentazione) non sono mai stati realmente implementati su larga scala, e oggi i numeri dei livelli OSI (Layer 2, Layer 3, Layer 4) sopravvivono solo come vaga convenzione per capirsi.

== Stack TCP/IP
Lo stack TPC/IP è molto più semplice dell'ISO/OSI.
#figure(image("images/2026-06-18-23-25-56.png", width: 30%))
- L5 Livello Application: composto dai protocolli applicativi come FTP, SMTP, HTTP, etc...
- L4 Livello Transport: composto dai protocolli per il trasferimento dei dati end-to-end come TCP, UDP, QUICK, etc...
- L3 Livello Network: composto dai protocolli per il routing sorgente-destinazione come IP, ICMP, ARP, RARP, etc...
- L2 Livello Data Link: composto dai protocolli per le comunicazioni locali come PPP, ethernet, etc...

== Indirizzi
Verranno trattate tre tipologie di indirizzi. Per ciascuna è importante capirne lo *scope* (ambito di validità):

- *Indirizzi MAC (Livello 2)*: servono per comunicare all'interno di una rete locale (Ethernet, Wi-Fi). Il loro scope termina appena si incontra un router. Devono essere univoci all'interno dello stesso segmento di rete, altrimenti si generano conflitti. Una scheda di rete ha di norma un solo indirizzo MAC, ma a livello software può riceverne e gestirne molti.
- *Indirizzi numerici (IP, Livello 3)*: necessari per il routing end-to-end, da sorgente a destinazione. Una scheda di rete può avere un numero arbitrario di indirizzi IP: con IPv4 se ne assegna spesso uno solo per un problema di scarsità, ma in IPv6 averne multipli è la norma.
- *Indirizzi alfanumerici (DNS, Livello 5)*: nomi come `www.unifi.it`. Non servono solo a facilitare la memorizzazione, ma soprattutto a creare un livello di *astrazione*: se un server cambia provider (e quindi indirizzo IP), il DNS permette agli utenti di continuare a raggiungerlo con lo stesso nome. Un dominio può puntare a un numero arbitrario di IP, e uno stesso IP può ospitare un numero arbitrario di domini.

#observation()[
  #figure(image("images/2026-06-18-23-30-30.png"))
]

=== Dalle classi al CIDR
Agli albori di Internet, gli indirizzi IP erano divisi rigidamente in *classi* predefinite (A, B, C), spezzando l'indirizzo in due blocchi fissi: `Net_Id` (identificativo della rete) e `Host_Id` (identificativo del dispositivo). Se due computer avevano lo stesso `Net_Id`, sapevano di essere nella stessa sottorete e potevano comunicare direttamente senza passare dal router. Il problema delle classi era la rigidità: se un'azienda aveva bisogno di 500 indirizzi non le bastava una Classe C (254 indirizzi), quindi l'ente assegnatore era costretto a sprecare un'intera Classe B (circa 65.000 indirizzi). Inoltre questa rigidità impediva di compattare le tabelle di routing, rendendole gigantesche e la ricerca del percorso molto lenta.

#figure(image("images/2026-06-19-10-40-55.png", width: 60%))

La soluzione definitiva è stata l'introduzione del *CIDR*#index[CIDR] (Classless Inter-Domain Routing). Il CIDR elimina le vecchie classi e introduce una notazione flessibile basata su una barra (es. `150.217.8.0/24`), in cui la lunghezza della parte di rete non è più fissa. Questo permette di allocare lo spazio in modo fluido e, soprattutto, di accorpare (compattare) più reti contigue in un'unica riga della tabella di routing, ottimizzando drasticamente la gestione degli indirizzi. Per questo motivo, in un contesto moderno, non ha più senso ragionare in termini di Classe A, B o C.

=== Tabella di routing e Longest Prefix Match
Per capire dove inviare un pacchetto, i sistemi consultano una *Tabella di Routing*#index[Tabella di Routing] che mappa le destinazioni attraverso gateway (Next Hop) e interfacce di uscita specifiche.

#figure(image("images/2026-06-19-10-41-09.png", width: 60%))

Per trovare la rotta corretta, il sistema applica un'operazione logica per verificare se l'IP di destinazione combacia con le reti conosciute: verifica che `DestIP && SubNetMask == RTDestIP`. Poiché un pacchetto potrebbe teoricamente soddisfare più regole contemporaneamente (ad esempio una rotta generica e una specifica), il sistema applica la regola del *Maximum Matching Entry* (o Longest Prefix Match): tra tutte le rotte compatibili, vince quella con il maggior numero di bit a 1 nella sua maschera di sottorete (Genmask). In parole povere, il pacchetto viene sempre instradato seguendo il percorso in assoluto più specifico che il router conosce.

Il problema è che questa ricerca non si può eseguire con una semplice bisezione o con alberi di ricerca standard, perché non si può escludere a priori che più in fondo alla tabella ci sia una regola più specifica: ogni pacchetto costringe quindi il router a scandagliare gran parte della tabella. Come si fa a farlo velocemente nei router di fascia alta? Si usa la *Memoria Ternaria* (TCAM). Mentre la memoria classica ragiona in bit (0 e 1), la memoria ternaria aggiunge un terzo stato: "Non importa" (*Don't Care*). Questo permette all'hardware di confrontare l'indirizzo di destinazione con l'intera tabella di routing in un singolo ciclo di clock. È una tecnologia potentissima ed essenziale per i router di dorsale, ma estremamente costosa: è questo il motivo per cui un router domestico costa poche decine di euro e un router professionale può costarne decine di migliaia.

