#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *
#set text(lang: "it")

#pagebreak()

= Sicurezza delle Reti (Cybersecurity)

L'introduzione di nuovi protocolli impone una rigorosa analisi delle minacce (*Threat Analysis*#index[Threat Analysis]). La Cybersecurity non mira alla creazione di sistemi invulnerabili, ma alla riduzione del rischio a un livello operativamente ed economicamente accettabile. Un'analisi strutturata deve rispondere a tre quesiti:
+ *Cosa* si sta proteggendo (asset: dati, hardware, software).
+ *Da chi* e *da quali vettori* ci si protegge.
+ *Perché* lo si protegge (Requisiti normativi, business continuity, incolumità fisica).

L'aggiunta indiscriminata di layer di sicurezza (es. cifratura ovunque) aumenta esponenzialmente la complessità architetturale. Un sistema eccessivamente complesso è prono a difetti di configurazione (misconfigurations) e spesso spinge gli utenti ad aggirare le policy di sicurezza per preservare l'usabilità.

L'isolamento delle zone di sicurezza, storicamente gestito tramite indirizzi IP appositi (come i deprecati *site-local*), oggi viene implementato a livello di architettura di rete (VLAN) o tramite firewall avanzati e policy di *Zero Trust*#index[Zero Trust].

== Tipologie di Vulnerabilità

Le vulnerabilità dei protocolli di rete derivano tipicamente da tre categorie di errori:

+ *Vulnerabilità "By Design"*: compromessi architetturali accettati in fase di standardizzazione per privilegiare l'efficienza. Un esempio è l'ARP spoofing in IPv4 (o l'NDP spoofing in IPv6), che sfrutta l'assenza intrinseca di autenticazione nei messaggi di risoluzione degli indirizzi. La mitigazione di queste vulnerabilità è demandata all'applicazione di policy descritte nei manuali (es. *Dynamic ARP Inspection*#index[Dynamic ARP Inspection] sugli switch).

+ *Vulnerabilità "Bad Implementation" o "Bad Deployment"*: difetti introdotti durante lo sviluppo del codice sorgente o durante la configurazione dell'infrastruttura. Tali difetti sono il veicolo principale dei moderni *Supply Chain Attack*#index[Supply Chain Attack].

+ *Vulnerabilità "Bad Design"*: errori concettuali severi. Un esempio storico è il protocollo Wi-Fi *WEP*#index[WEP], compromesso in modo irrecuperabile a livello progettuale: l'unica soluzione è stata abbandonarlo in favore di WPA e dei suoi successori (WPA2, WPA3). Un altro esempio si riscontra nel *TCP Window Scaling*#index[TCP Window Scaling]. Il protocollo TCP chiude le sessioni anomale tramite pacchetti con flag `RST` validi solo se recanti il corretto `Sequence Number` (spazio a 32 bit). L'introduzione del Window Scaling (per massimizzare il throughput su reti veloci) ha allargato a dismisura la finestra dei pacchetti accettabili. Questo ha abbattuto lo spazio di entropia necessario a un attaccante per eseguire un attacco *TCP Reset Spoofing*#index[TCP Reset Spoofing] cieco: sono sufficienti pochissimi pacchetti per intercettare la finestra valida e abbattere la connessione. La mitigazione implementata successivamente ha imposto restrizioni rigide: un router deve accettare un flag `RST` solo se il Sequence Number è esatto, senza margini di tolleranza, rigettando i valori generici all'interno della finestra.
