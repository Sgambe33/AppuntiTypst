#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()
= Dispositivi I/O
Mentre l'elaborazione è uno dei due compiti principali di un computer, spesso è l'*I/O (Input/Output)* a rappresentare il compito predominante, con l'elaborazione che diventa meramente incidentale, ad esempio, quando un utente consulta una pagina web o modifica un file. Il *ruolo del Sistema Operativo (SO)* nell'I/O del calcolatore è quello di *gestire e controllare le operazioni e i dispositivi di I/O*. Il codice per l'I/O costituisce una parte significativa del SO ed è fondamentale per integrare la vasta gamma di dispositivi esistenti nei calcolatori e nei SO moderni.

== Hardware di I/O

I computer gestiscono un'enorme varietà di periferiche di I/O, che possono essere classificati in diverse categorie:
- *Dispositivi di archiviazione*: come dischi e nastri.
- *Dispositivi di trasmissione*: come connessioni di rete e Bluetooth.
- *Dispositivi di interfaccia persona-macchina*: inclusi schermi, tastiere, mouse, ingressi e uscite audio.
- *Dispositivi specializzati*: ad esempio, quelli coinvolti nella guida di un jet.

I dispositivi di I/O possono differire notevolmente per vari aspetti:
- *Numero e tipo di funzioni* che possono svolgere.
- *Quantità di errori e malfunzionamenti* che possono generare.
- *Sorgente o destinazione dei dati*: operatore umano, altre apparecchiature (sensori, attuatori, dischi), apparecchiature o utenti remoti.
- *Modalità d'accesso*: sequenziale (ordine fisso) o diretto/casuale (accesso a qualsiasi locazione disponibile).
- *Condivisione*: dedicati a un processo per volta o condivisi tra più processi/thread.
- *Direzione dell'I/O*: input e output, solo input, solo output.
- *Modalità di I/O*: sincrono o asincrono.
- *Velocità di trasmissione dei dati*: da pochi byte al secondo a diversi gigabyte al secondo.
- *Organizzazione/trasferimento dei dati*: a blocchi di byte o a caratteri (un byte alla volta).

#figure(image("images/2025-08-18-15-22-17.png", width: 75%))

=== Organizzazione e trasferimento dei dati

I dispositivi di I/O possono essere organizzati per il trasferimento dei dati in base a:

#index[Dispositivi a blocchi]
- *Dispositivi a blocchi*: memorizzano i dati in blocchi di dimensione fissa (tipicamente tra 512 byte e 4KB), ciascuno con un proprio indirizzo (settore), leggibile e scrivibile indipendentemente. I comandi tipici includono `read`, `write`, `seek` (se ad accesso casuale). Sono solitamente utilizzati tramite un file system. Esempi includono memorie di massa come dischi e nastri.

#index[Dispositivi a caratteri]
- *Dispositivi a caratteri*: accettano o inviano flussi di caratteri senza poterli strutturare o indirizzare internamente. I comandi includono `get` e `put`, senza comandi di posizionamento. Librerie software sono costruite sopra questa interfaccia per permettere l'accesso a intere sequenze di caratteri. Esempi sono tastiere, mouse, stampanti e interfacce di rete.

#index[Dispositivi a speciali]
- *Dispositivi speciali*: non rientrano nelle categorie precedenti, come i *Timer* (temporizzatori programmabili che generano interruzioni) e i *Touch screen* (dispositivi sia di input che output, formati dall'unione di uno schermo e un digitalizzatore).

=== Componenti dell'hardware di I/O

Nonostante l'enorme varietà, l'hardware di I/O è costituito da tre componenti principali:
- *Dispositivi di ingresso/uscita*
- *Controllori dei dispositivi*
- *Componenti di connessione*: come i *bus* (insieme di linee di connessione condivise) e le *porte* (punti di connessione).

#figure(image("images/2025-08-18-15-23-29.png"))

==== Controllori dei dispositivi
#index[Controllore di dispositivi]
Un *controllore* è un circuito elettronico che collega periferiche e CPU tramite il bus. I suoi compiti principali sono:
- Controllare il funzionamento del dispositivo inviando e ricevendo segnali tramite un protocollo specifico.
- Fornire alla CPU un insieme di *registri indirizzabili* per le operazioni di I/O.

Molti controllori possono gestire più dispositivi dello stesso tipo, e l'interfaccia tra controllore e dispositivo è spesso standardizzata (es. SATA, SCSI, USB), permettendo alle industrie di produrre dispositivi e controllori compatibili. L'interfaccia è solitamente di basso livello.

#example(
  "Controllore di disco",
)[
  Un controllore di disco trasforma un flusso seriale di bit da un settore letto in preambolo, byte di dati e codice di correzione degli errori (ECC), poi copia i dati in un buffer e infine nella memoria principale.
]

#example(
  "Controllore LCD",
)[
  Un controllore di monitor LCD, analogamente, legge i caratteri dalla memoria e genera segnali per modulare i pixel. Senza il controllore, il SO dovrebbe programmare ogni singolo pixel.
]

Il seguente schema semplificato mostra l'interazione:
#figure(image("images/2025-08-18-15-24-14.png", width: 60%))

==== Registri del Controllore

La CPU agisce sul controllore tramite comandi di I/O che indirizzano i registri di cui esso dispone. I principali registri sono:
- *Registro di controllo*: consente alla CPU di controllare il funzionamento del dispositivo. È a *sola scrittura* per la CPU, che vi inserisce valori per richiedere operazioni. Esempi di bit includono `bit di start` (attiva il dispositivo) e `bit di abilitazione delle interruzioni` (per inviare un segnale di interruzione alla CPU al termine dell'operazione). Altri bit selezionano l'operazione richiesta.
- *Registro di stato*: consente al dispositivo di mantenere aggiornato il proprio stato. È a *sola lettura* per la CPU. Contiene un `bit di flag` (indica la fine dell'operazione, potenzialmente lanciando un'interruzione) e `bit di errore` (segnala eventi anomali).
- *Registro dati (in/out)*: funge da buffer del controllore per i dati da trasferire.
#figure(image("images/2025-08-18-15-25-54.png", width: 65%))

==== Metodi di accesso ai registri di un controllore

#figure(image("images/2025-08-18-15-26-29.png", width: 60%))
Esistono tre metodi per la comunicazione tra CPU e controllore:
#index[Port-mapped I/O]

1. *I/O Separato in Memoria (o port-mapped I/O)*:
  - A ogni registro di controllo è assegnato un *numero di porta di I/O* (es. un intero a 16 bit), e l'insieme di tutte le porte forma lo *spazio delle porte di I/O*.
  - La protezione dai programmi utente è garantita da *istruzioni speciali di I/O* (es. `IN R0,4`) che specificano numeri di porte dedicati e che solo il SO può eseguire. Questo rende evidente, anche a chi legge un programma assembly, che si tratta di un'operazione di I/O.
  - Il vantaggio principale è che *tutto lo spazio di indirizzi può essere usato per la memoria*, utile per CPU con limitate capacità di indirizzamento.
  #figure(image("images/2025-08-18-15-29-19.png", width: 80%))

#index[Memory-mapped I/O]
2. *I/O Mappato in Memoria (o memory-mapped I/O)*:
  - I registri di controllo dei dispositivi sono *mappati in un sottoinsieme dello spazio degli indirizzi di memoria* generati dalla CPU.
  - Ogni controllore di dispositivo monitora il bus degli indirizzi della CPU e risponde quando un indirizzo assegnato al suo dispositivo viene generato.
  - È *efficiente e flessibile* perché *non servono istruzioni speciali per l'I/O*: ogni istruzione che può accedere alla memoria può anche accedere ai registri dei controllori. Questo riduce la logica interna della CPU, rendendola più economica, veloce e facile da costruire, principio alla base delle architetture *RISC*.
  - Per la protezione, lo spazio di indirizzamento di I/O è allocato al di fuori dello spazio utente.

#index[Hybrid I/O]
3. *Schema Ibrido*:
  - Utilizzato con alcuni dispositivi, combina i due metodi.
  - Un esempio è il *controllore della grafica nel Pentium*: i registri di controllo e stato usano I/O separato in memoria, mentre il registro dati usa I/O mappato in memoria. Le scritture avvengono tramite la *memoria grafica*, una regione dedicata a mantenere i contenuti dello schermo, che il controllore utilizza per generare l'immagine. Questo rende veloce la visualizzazione su schermo, evitando milioni di istruzioni di I/O.

== Interazione tra Gestore Software e Controllore Hardware

Esistono tre modalità diverse di interazione tra il *driver* di un dispositivo e il relativo controllore hardware:
1. *I/O Programmato*.
2. *I/O Guidato dalle Interruzioni*.
3. *Accesso Diretto in Memoria (DMA)*.
#figure(image("images/2025-08-18-15-30-08.png", width: 70%))

=== I/O Programmato: Processo Esterno (Hardware) e Interno (Software)

Un dispositivo con il suo controllore può essere considerato un *processore dedicato* che esegue una sequenza di azioni fisse, chiamata *processo esterno (HW)*.
Il processo esterno attende un comando tramite il registro di controllo (con il `bit di start = 1`), esegue il comando e segnala la fine tramite il registro di stato (`bit di flag = 1`).

#figure(image("images/2025-08-18-15-30-57.png", width: 60%))

Il *processo interno (SW)* è solitamente il *driver del dispositivo*. Prepara un comando, lo invia (impostando `bit di start = 1`), e poi *attende attivamente* (`busy waiting`) la fine del comando controllando ripetutamente il `bit di flag` nel registro di stato del controllore (`polling`).
Un'istruzione di alto livello per un dispositivo di I/O può corrispondere a una sequenza di comandi di basso livello per il controllore.
#figure(image("images/2025-08-18-15-31-07.png", width: 60%))

*Valutazione*: L'I/O programmato *delega tutto il lavoro alla CPU*, che controlla direttamente la terminazione di ogni operazione. Il problema principale è l'*attesa attiva (busy waiting)*, che è inefficiente, specialmente se le interrogazioni trovano raramente un dispositivo pronto. Sebbene sia ragionevole in sistemi embedded dove la CPU non ha altro da fare, non è adatto a sistemi multiprogrammati, dove è necessario sospendere un processo in attesa di I/O per utilizzare al meglio la CPU.

=== I/O Guidato dalle Interruzioni

Per rendere più efficiente la gestione, si associa al dispositivo un *semaforo di sospensione S* (inizializzato a 0). Nel processo interno, il ciclo di attesa attiva viene sostituito da una `wait(S)`, che può sospendere il processo.
Al completamento dell'operazione, il controllore del dispositivo lancia un *segnale di interruzione*. La CPU, dopo ogni istruzione, controlla la presenza di interruzioni, salva lo stato corrente e passa all'esecuzione della *routine di gestione dell'interruzione*. Questa routine attiva una funzione di risposta che esegue una `signal(S)`, sbloccando il processo interno.
#figure(image("images/2025-08-18-15-32-05.png", width: 70%))

*Miglioramento*: Se un processo deve trasferire `n` blocchi di dati, per `n-1` volte viene sospeso e riattiviato inutilmente in quando deve subito (ri)sospendersi. Se  è disponibile una funzione che accetta come argomento il numero `n` dei blocchi di dati da trasferire e l'indirizzo di memoria dove memorizzarli o da dove leggerli, si può bloccare il processo interno fino al trasferimento dell'ultimo blocco, riattivandolo solo allora.
#figure(image("images/2025-08-18-15-32-17.png", width: 70%))

Per ottenere questo comportamento la routine di gestione dell'interruzione deve poter distinguere le interruzioni intermedie da quella finale in corrispondenza della quale il processo interno va riattivato. Ciò è realizzabile grazie al descrittore di dispositivo.

==== Descrittore di Dispositivo

#index[Descrittore di dispositivo]
È una *struttura dati in memoria* che rappresenta il dispositivo, accessibile sia dal processo interno che dalla routine di gestione dell'interruzione. Ha un duplice scopo:
- Racchiude informazioni associate al dispositivo.
- Consente la *comunicazione* tra processo interno e controllore (quantità di dati da trasferire, indirizzo del buffer) e viceversa (esito del trasferimento).

I campi tipici di un descrittore di dispositivo includono:
#figure(image("images/2025-08-18-15-36-08.png", width: 50%))

==== Gestore di un Dispositivo (Device Driver)

#index[Driver]
Il gestore di un dispositivo è un *componente software* formato da:
- Il descrittore di dispositivo.
- Funzioni di accesso al dispositivo (lettura, scrittura, ecc.).
- Funzioni di risposta alle interruzioni.
#figure(image("images/2025-08-18-15-36-43.png", width: 50%))

Il funzionamento tipico di un driver include:
1. Inizializzazione del dispositivo.
2. Accettazione e controllo delle richieste di operazione.
3. Gestione delle code delle richieste non servibili subito.
4. Scelta della prossima richiesta da servire e traduzione in comandi di basso livello per il controllore.
5. Trasmissione dei comandi al controllore, uno alla volta, eventualmente bloccandosi in attesa del completamento.
6. Controllo dell'esito di ciascun comando e gestione degli errori.
7. Al completamento della richiesta, invio dell'esito e dei dati al processo richiedente.

==== Gestione di un Timer

I timer sono utilizzati per lanciare interruzioni cadenzate nel tempo (non per trasferire dati), ad esempio per la gestione della data di sistema, lo scheduling della CPU in sistemi time-sharing, attese programmate e segnali di time-out. Il driver di un timer è costituito da:
- La primitiva `delay()`, che i processi possono invocare passandogli la durata dell'attesa.
- Un *descrittore* che, oltre agli indirizzi dei registri di controllo e stato, ha campi specifici: `fine_attesa[]` (array di semafori per sospendere processi che hanno invocato `delay()`), `ritardo[]` (array di interi per le unità di tempo rimanenti) e `contatore` (un registro in cui la CPU può scrivere un intero; il timer lo decrementa periodicamente, quando si azzera lancia un'interruzione e reimposta contatore con il valore più piccolo contenuto nell'array `ritardo[]`).
#figure(image("images/2025-08-18-15-38-44.png", width: 60%), caption: "Descrittore di un timer")

=== Accesso Diretto in Memoria (DMA)

#index[DMA]
Il *DMA* (Direct Memory Access) si usa per *trasferimenti di grandi quantità di dati* e richiede hardware apposito: un *controllore (o canale) DMA*. Consente di trasferire i dati direttamente tra il registro dati del controllore del dispositivo e la memoria centrale (e viceversa) tramite lo stesso bus usato dalla CPU, ma *senza intervento della CPU*.
Il controllore DMA può essere integrato nel controllore di un dispositivo o essere separato (a volte sulla scheda madre). Contiene due registri, `puntatore` e `contatore`, simili a quelli del descrittore di dispositivo ma gestiti via hardware. Ha anche registri di controllo in cui la CPU inserisce i comandi.

==== Lettura in DMA da un Disco: Operazioni

1. La *CPU programma il controllore DMA*, impostando i registri `puntatore` (indirizzo di memoria di destinazione) e `contatore` (numero di byte da trasferire), e gli delega il compito di gestire il trasferimento.
2. La CPU invia un comando al *controllore del disco* per leggere i dati (es. un settore) nel suo buffer interno e verificarne l'ECC.
3. Quando il buffer del controllore del disco ha dati validi e pronti, invia un segnale al controllore DMA.
4. Il *controllore DMA* intercetta il segnale e inizia il trasferimento (es. una parola per volta), inviando sul bus una richiesta al controllore del disco con un indirizzo di memoria.
5. Una volta eseguito il trasferimento, il controllore del disco invia un segnale di conferma al controllore DMA.
6. Il controllore DMA decrementa il `contatore` e incrementa il `puntatore`. Infine, *invia un'interruzione alla CPU* (se il contatore si è azzerato, indicando la fine dell'intero trasferimento) o rilancia una nuova richiesta al controllore del disco (se il contatore non è ancora azzerato).
#figure(
  image("images/2025-08-18-15-40-27.png", width: 80%),
  caption: "Controllore DMA separato dal controllore del disco",
)

*Vantaggi del DMA*:
- *Riduce il tempo* per trasferire un insieme di blocchi di dati.
- *Elimina la necessità* per la CPU di eseguire la funzione di gestione delle interruzioni per ciascun blocco, generando una *sola interruzione alla fine dell'intero trasferimento*.

*Inconvenienti del DMA*:
- Il controllore DMA è in generale *molto più lento della CPU*.
- Se il controllore DMA non riesce a condurre un dispositivo alla velocità massima, o se la CPU non ha altro da fare in attesa dell'interruzione finale, per motivi economici (specialmente nei sistemi embedded), potrebbe essere più conveniente usare I/O guidato dalle interruzioni o I/O programmato.

== Sottosistema di I/O

Il *sottosistema di I/O* è formato dai metodi utilizzati dal kernel del SO per la gestione dei dispositivi. Ha il compito di *separare il resto del kernel dalla complessità* di gestione dei dispositivi, dovuta alla loro grande varietà. Offre un insieme di servizi per assicurare ai processi un supporto adeguato alle operazioni di I/O, fornendo un'*interfaccia uniforme* che garantisce accesso efficiente, gestisce malfunzionamenti e *nasconde i dettagli hardware* dei singoli dispositivi. Questo evita che un programma debba cambiare comandi a seconda del dispositivo (es. leggere un file da un HDD, SSD, DVD o USB).

=== Organizzazione Logica del Sottosistema di I/O

Il sottosistema di I/O è logicamente suddiviso in due componenti:
1. *Componente indipendente dai dispositivi*:
  - *Omogeneizza le funzioni di accesso* ai vari dispositivi e fornisce un'*interfaccia uniforme* al software a livello utente.
  - Fornisce un' *API per l'I/O*: un insieme di funzioni che incapsulano il comportamento delle periferiche in poche classi generiche e invocano le funzioni dei driver.
  Un problema importante in un SO è rendere tutti i dispositivi e driver di I/O simili nell'interfaccia. Se ogni driver ha un'interfaccia diversa al SO, l'introduzione di un nuovo dispositivo richiede un notevole sforzo di programmazione. Un'*interfaccia standard per i driver* evita questo problema.

2. *Componente dipendente dai dispositivi*:
  - *Nasconde le caratteristiche* dei dispositivi e dei loro controllori al resto del SO. È costituita dai *driver dei dispositivi* che si interfacciano direttamente con i corrispondenti controllori hardware tramite i loro registri e ne controllano il comportamento.

#figure(
  image("images/2025-08-18-15-42-09.png", width: 75%),
  caption: "Diagramma dell'Organizzazione logica del sottosistema di I/O.",
)

=== Interfacciamento uniforme dei driver

Per ciascuna classe di dispositivi, come dischi e stampanti, il SO stabilisce un insieme di funzioni che il driver deve supportare. Così facendo è semplice aggiungere nuovi dispositivi al sistema.
#figure(image("images/2025-08-18-15-44-36.png", width: 75%))

=== Servizi della Componente Indipendente dai Dispositivi

Questa componente offre servizi che rendono più semplice, sicuro ed efficiente l'uso dei dispositivi e del calcolatore. In alcuni sistemi, questi servizi coincidono con quelli offerti dal file system. I principali servizi sono:

- *Buffering dei dati*:
  Memorizzazione temporanea e trasparente dei dati in *buffer di sistema* durante il trasferimento. Un buffer è un'area di memoria che memorizza i dati durante il trasferimento tra due dispositivi o tra un dispositivo e un'applicazione. I motivi principali per ricorrere ai buffer:
  - *Gestire la differenza di velocità* tra produttore e consumatore di un flusso di dati, disaccoppiandone il funzionamento (es. modem vs. disco, dispositivi a carattere vs. CPU).
  - *Gestire dispositivi che trasferiscono dati in blocchi di dimensioni diverse*.
  - *Supportare la "semantica della copia"* nelle operazioni di I/O delle applicazioni, ovvero garantire che i dati copiati su disco siano quelli presenti nel buffer al momento della `write()`, indipendentemente da modifiche successive.

- *Caching dei dati*:
  Una *cache* è una regione di *memoria veloce* che mantiene copie di dati, rendendo l'accesso alla copia più rapido dell'accesso ai dati originali. Ad esempio, le istruzioni del processo in esecuzione sono memorizzate su disco, copiate in memoria principale (cache del disco) e ulteriormente copiate nella cache primaria e secondaria della CPU. La differenza tra un buffer e una cache è che un buffer può contenere dati di cui non esiste altra copia, mentre una cache, per definizione, conserva una copia di dati memorizzati altrove. Sebbene distinte, a volte una stessa regione di memoria può essere usata per entrambi gli scopi, come il *buffer cache* nella gestione della memoria secondaria.

- *Gestione degli errori*:
  I dispositivi e i trasferimenti di I/O possono fallire in vari modi, temporaneamente (es. sovraccarico di rete) o permanentemente (es. controllore difettoso). I SO sono spesso capaci di compensare efficacemente i guasti temporanei (es. ritentando una `read()`, o usando `resend()` nei protocolli di rete). È difficile compensare errori dovuti a guasti permanenti di componenti importanti. Una system call di I/O restituisce un bit di stato sull'esito. In UNIX, una variabile aggiuntiva `errno` restituisce un codice di errore generico (es. puntatore non valido, file non aperto).

- *Protezione dell'I/O*:
  Le istruzioni di I/O sono *privilegiate* per impedire agli utenti di eseguirle direttamente. Per eseguirle, un programma utente invoca una *system call*, e il SO, in modalità kernel, verifica la validità della richiesta ed esegue l'I/O, restituendo poi il controllo all'utente in modalità utente. Il sistema di protezione della memoria protegge tutti gli indirizzi mappati in memoria e gli indirizzi delle porte I/O dall'accesso degli utenti. Tuttavia, il kernel non può semplicemente negare ogni tentativo di accesso. Ad esempio, i videogiochi e i software di montaggio video necessitano spesso di accesso diretto alla memoria del controllore grafico (gestita in I/O mappato in memoria) per ottimizzare le prestazioni. In questi casi, il kernel può fornire un meccanismo di *lock* per assegnare a un solo processo alla volta la sezione di memoria grafica che rappresenta una finestra sullo schermo.
  #figure(image("images/2025-08-18-15-45-11.png", width: 50%))

- *Prenotazione dei dispositivi*:
  Alcuni dispositivi (unità nastro, stampanti) che non possono accettare flussi di dati intercalati da richieste concorrenti, possono essere *allocati dinamicamente a un solo processo per volta*. Alcuni SO permettono ai processi di richiedere l'uso esclusivo di un dispositivo e di rilasciarlo dopo l'uso, tramite system call `open`/`close` sul file speciale corrispondente al dispositivo, con il vincolo di una sola `open` alla volta. Le richieste non accettate bloccano il processo, che viene inserito in una coda di attesa. I rilasci provocano l'assegnazione del dispositivo al processo con maggiori diritti in coda e il suo sblocco.

- *Sistema di spooling*:
  #index[Spooling]
  Lo *spooling* è una tecnica usata per gestire dispositivi che non possono   ricevere dati da più programmi contemporaneamente, come le stampanti.
  Il sistema operativo prende i dati inviati da un'applicazione e li salva in un  file temporaneo sul disco, chiamato *file di spool*. Quando l'applicazione ha finito di inviare i dati, questo file viene messo in   una coda di stampa. La stampante poi prende i file dalla coda e li stampa uno alla volta,   nell'ordine. In questo modo, invece di avere tante richieste dirette alla stampante, c'è   una lista organizzata di file pronti da stampare. Lo spooling *è gestito da un programma in background *(daemon) o da un thread   del sistema operativo, che permette anche di controllare la coda (per esempio   eliminare file, mettere in pausa la stampa, ecc.).

- *Scheduling delle richieste di I/O*:
  Consiste nel determinare un *ordine conveniente* per servire le richieste di I/O in una coda, poiché l'ordine di generazione raramente è il migliore. Viene realizzato mantenendo una coda di richieste per ciascun dispositivo. Quando un'applicazione richiede I/O, la richiesta è inserita nella coda del dispositivo. In caso di I/O asincrono, una *tabella di stato dei dispositivi* tiene traccia delle richieste attive, indicando tipo, stato (in attesa, occupato) e coda delle richieste pendenti per ogni dispositivo. Lo *scheduler dell'I/O* riorganizza l'ordine delle richieste per *migliorare le prestazioni complessive*, distribuire equamente gli accessi e ridurre il tempo di attesa medio.

== Trasformazione delle Richieste di I/O in Operazioni Hardware

=== Traduzione dei Nomi

Il processo di trasformazione delle richieste di I/O permette di *associare i nomi simbolici dei file* usati dalle applicazioni ai dispositivi hardware corrispondenti. Questo processo passa attraverso diversi stadi: dalla stringa di caratteri del nome logico a un driver specifico, all'indirizzo di un dispositivo, fino all'indirizzo fisico delle porte di I/O o all'indirizzo mappato in memoria del controllore del dispositivo.

Il file system serve per collegare i nomi dei file alla posizione reale dei dati sul disco, usando la struttura delle directory.

- Nel file system FAT:
  Il nome del file è collegato a un numero che punta a una voce nella tabella di  allocazione dei file (FAT).
  Da lì si risale ai blocchi del disco dove si trovano i dati.
  I dispositivi hanno uno spazio di nomi separato da quello dei file, e vengono   indicati con i due punti, ad esempio C: per il disco principale.

- In UNIX:
  I nomi dei dispositivi non compaiono direttamente.
  UNIX usa una tabella di montaggio, che associa un prefisso di percorso  (pathname) al dispositivo corrispondente.
  Ogni dispositivo è identificato da una coppia di numeri `<principale, secondario>`:
  + il numero principale indica il driver da usare
  + il numero secondario serve al driver per capire l'indirizzo fisico del dispositivo o del controllore.

I SO moderni ottengono notevole flessibilità grazie all'uso di diverse tabelle di ricerca a vari livelli, permettendo di *introdurre nuovi dispositivi e driver senza ricompilare il kernel*. Alcuni SO sono in grado di caricare i driver su richiesta: all'avvio controllano i bus HW per determinare i dispositivi presenti e caricano i driver necessari immediatamente o quando servono. Dopo l'avvio, i dispositivi aggiunti possono essere rilevati da un errore dovuto a un'interruzione senza gestore associato, che richiede al kernel di ispezionare il dispositivo e caricare dinamicamente un driver appropriato.

#example("Esecuzione della richiesta read(fd,bytes,&buffer)")[
  Il processo di esecuzione di una richiesta di I/O dal momento in cui l'utente invoca una system call fino al completamento dell'operazione sull'hardware è complesso e coinvolge diversi livelli:

  1. Un processo utente invoca una system call `read()` bloccante su un file descriptor restituito precedentemente da una `open()`.
  2. Il codice della system call nel kernel controlla la correttezza dei parametri.
  3. Il *livello "File system logico"* verifica i diritti di accesso del processo al file.
  4. Se i dati sono già disponibili nel *buffer cache*, vengono restituiti al processo e la system call termina.
  5. Altrimenti, è necessaria un'operazione di I/O dal disco:
    - Il processo richiedente viene posto in stato "waiting" e il suo PCB (Process Control Block) inserito nella coda di attesa sul dispositivo.
    - Il *livello "Modulo di organizzazione dei file"* calcola il record logico o i record logici del file da leggere e il corrispondente blocco del disco usando la tabella dei file aperti.
    - Il *livello "File system di base"* invia una richiesta di lettura al driver del dispositivo (tramite chiamata di procedura o messaggio interno al kernel).
  6. Il *driver del dispositivo* inserisce la richiesta nella lista delle richieste in attesa.
  7. Al momento di servire la richiesta, il driver alloca un buffer nel kernel, trasforma la richiesta in comandi di basso livello per il *controllore del dispositivo*, e programma i registri del controllore.
  8. Il controllore individua l'indirizzo `<cilindro,faccia,settore>` del blocco del disco, effettua la lettura dei dati e *genera un'interruzione* quando l'operazione termina.
  9. Tramite il vettore delle interruzioni, viene attivato il *gestore corrispondente*, che memorizza i dati, invia un acknowledgment (ACK) al driver e termina.
  10. Il driver riceve l'ACK, determina quale richiesta è stata completata e il suo stato, e lo segnala al sottosistema di I/O del kernel.
  11. Il kernel trasferisce i dati e/o i codici di ritorno nello spazio di memoria dell'invocante, cambia lo stato del processo in "ready" e sposta il suo PCB dalla coda di attesa alla coda dei processi pronti.
  12. Quando lo scheduler riassegnerà la CPU, il processo invocante potrà riprendere la sua esecuzione.
  #figure(image("images/2025-08-18-15-47-03.png", height: 30%))
]
== Memoria Secondaria

=== Memoria di massa

La *memoria di massa* è il sistema di *memorizzazione non volatile* di un computer. La sua disponibilità è essenziale per molte componenti dei SO, come il supporto alla *memoria virtuale dei processi (swap area)* e la *memorizzazione dei file (file system)*.

La memoria di massa comprende:
- *Memoria secondaria*: solitamente dischi rigidi (HDD) e altri dispositivi di memoria non volatile (NVM).
- *Memoria terziaria*: non sempre presente, più lenta e più grande, costituita da nastri magnetici, dischi ottici, o spazio di memorizzazione su cloud.

==== Dispositivi di Memoria Secondaria

La memoria secondaria si classifica in due tipologie distinte:
- *Meccanica*: dischi rigidi o magnetici (HDD), dischi ottici, nastri magnetici.
- *Elettrica*: memorie flash, dischi a stato solido (SSD), FRAM, NRAM.

La memoria meccanica è generalmente più grande e meno costosa per byte, ma più lenta della memoria elettrica. I dispositivi più comuni e importanti nei moderni sistemi di elaborazione sono i dischi rigidi e i dispositivi NVM.

=== Caratteristiche dei Dischi Rigidi

==== Struttura Fisica dei Dischi Rigidi
Un disco rigido è composto da uno o più *piatti* rotondi (di plastica, vinile o metallo), ricoperti da uno strato di ossido metallico magnetizzabile. Una *testina di lettura/scrittura*, sorretta da un *braccio*, modifica o rileva lo stato di magnetizzazione.
#figure(image("images/2025-08-18-15-48-51.png", width: 50%))

La testina è sospesa su un cuscino d'aria sottilissimo (altezza di volo, dell'ordine dei micron), con il pericolo di urto e danneggiamento irreparabile (crollo della testina).
#figure(image("images/2025-08-18-15-49-28.png", width: 60%))

==== Formattazione di Basso Livello
Un disco nuovo deve essere suddiviso in *settori* leggibili o scrivibili dal controllore; tutte le operazioni di I/O sono eseguite alla granularità di settori interi. La *formattazione di basso livello* (o fisica), eseguita dal produttore, divide il disco in *tracce concentriche*, a loro volta suddivise in settori (dimensione tra 512 byte e 4KB), separati da minuscoli spazi (gap). Un insieme di tracce su più superfici equamente distanti dal centro forma un *cilindro*.
#figure(image("images/2025-08-18-15-49-58.png", width: 50%))

==== Settore

#figure(image("images/2025-08-18-15-50-15.png", width: 50%))
Un settore è una speciale struttura dati composta da un *preambolo* (o intestazione), un'*area dati* e una *coda*. Preambolo e coda contengono dati per il controllore. Il preambolo inizia con uno schema di bit per riconoscere l'inizio del settore e contiene informazioni come numero di traccia e settore. La coda contiene un *codice per la correzione degli errori (ECC)*, usato per ripristinare errori di lettura.

==== Capacità di un Disco
La tecnologia dei dischi evolve rapidamente, con capacità che si incrementano più velocemente della legge di Moore. Un'unità a disco può avere migliaia di cilindri e centinaia di settori per traccia.
#example()[
  Un disco rigido con 2 piatti (4 superfici), 16.384 cilindri (16.384 tracce per superficie) e 16 settori da 4KB ciascuno ha una capacità di *4 GB* (4 x 16.384 x 16 x 4.096 byte). Oggi sono comuni unità con capacità dell'ordine dei Terabyte.
]

==== Movimenti in un Disco
Durante il funzionamento, per posizionarsi sul settore da leggere o scrivere, la testina si muove in *direzione radiale*, e il disco ruota sotto di essa (solitamente tra 60 e 250 giri al secondo, espressi in *RPM*: 5.400, 7.200, 10.000 o 15.000 RPM).
#figure(image("images/2025-08-18-15-50-29.png", width: 40%))

==== Tipologie di Dischi
- *Fissi* (hard disk) e *rimovibili* (floppy disk).
- *Testine*: mobili (una testina si muove radialmente) o fisse (tante testine quante le tracce di una superficie).
- *Velocità di rotazione*: velocità angolare costante (CAV) o velocità lineare costante (CLV).
- *Connessione al calcolatore*: tramite bus di sistema o di I/O (ATA, SATA, SCSI, USB, Firewire) o tramite rete.

==== Geometria Virtuale e Reale di un Disco
Nei sistemi moderni, il driver (e il SO) vede il disco con una *geometria virtuale*: un *grande vettore unidimensionale di blocchi logici*, dove il blocco logico è l'unità di trasferimento dei dati. La *geometria reale*, invece, è stabilita dalla formattazione di basso livello in termini di cilindri, tracce e settori.

Ogni blocco logico può essere associato a un settore fisico del disco, con una mappatura sequenziale (blocco 0 sul primo settore della prima traccia del cilindro più esterno, poi si procede sulla traccia, poi sul cilindro, e infine sui cilindri dall'esterno all'interno).

#figure(
  image("images/2025-08-18-15-50-53.png"),
  caption: "Rappresentazione dell'array lineare di blocchi e della loro mappatura.",
)

Un indirizzo di blocco logico è più agevole da usare rispetto a un indirizzo fisico `<cilindro,traccia, settore>`. Tuttavia, la traduzione è difficile per il SO perché:
- Su alcuni dischi, il numero di settori per traccia non è costante.
- Quasi tutti i dischi hanno *settori difettosi* che la mappatura nasconde, sostituendoli con settori di riserva.
- I produttori gestiscono la mappatura internamente, stabilendo la corrispondenza tra blocchi logici e settori correttamente funzionanti al momento della formattazione.
Nonostante ciò, gli algoritmi di gestione degli HDD presumono che i blocchi logici siano correlati ai settori fisici, cosicché a blocchi vicini corrispondano settori vicini.

==== Blocchi e Record Logici
L'unità di trasferimento dei dati nelle operazioni di I/O tra memoria centrale e disco è il *blocco (logico) del disco*, che è anche l'unità di allocazione dei file. I processi, d'altra parte, vedono ogni file come una sequenza di *record logici*, che sono l'unità di trasferimento nelle operazioni di accesso al file. Di solito, la dimensione del blocco è maggiore della dimensione del record logico, quindi ogni blocco contiene diversi record logici contigui.
#figure(image("images/2025-08-18-15-51-22.png", width: 60%))

==== Dimensione dei Blocchi: Considerazioni
- Una *grande dimensione del blocco* comporta che anche un file di un solo byte impegna (almeno) un intero blocco, sprecando spazio del disco per file piccoli.
- Una *ridotta dimensione del blocco* significa distribuire la maggior parte dei file su molti blocchi, comportando tempi di ricerca più lunghi e maggiori ritardi di rotazione per leggerli, a scapito delle prestazioni.
La scelta della dimensione del blocco ideale richiede informazioni sulla distribuzione statistica delle dimensioni dei file nel sistema.

=== Gestione dei Dischi Rigidi

==== Raw Disk (Disco di Basso Livello)
Alcuni SO permettono a certi programmi di vedere un disco, o una sua partizione, a un livello di astrazione più basso, ovvero come un *vettore monodimensionale di blocchi logici* senza alcuna struttura dati del file system. Questo è chiamato *disco di basso livello (raw disk)*, e l'I/O relativo si chiama *I/O di basso livello*.
Viene usato per l'*area di swap dei processi* o per la gestione di *basi di dati*, poiché fornisce più controllo sulla posizione dei record logici nel disco. L'I/O di basso livello elude tutti i servizi del file system e può essere usato dalle applicazioni per implementare servizi di memorizzazione specializzati.

==== File System
Tipicamente, file e directory sono salvati in dispositivi di memorizzazione ad accesso diretto. I dischi sono adatti per questo scopo grazie a due caratteristiche importanti:
- È possibile *accedere direttamente a qualsiasi blocco* del disco, semplificando l'accesso a qualsiasi file (sequenziale o diretto).
- I blocchi si possono *riscrivere localmente*: un blocco può essere letto, modificato e riscritto nella stessa posizione.

Per memorizzare i file, il SO deve prima registrare le proprie strutture dati sul disco, attraverso 3 passi:
1. *Partizionamento*: Suddivide il disco in uno o più gruppi di cilindri, detti *partizioni*, che poi vengono montate. Una o più partizioni possono essere d'avviamento per il SO; quella d'avvio è anche usata per stabilire la root del file system.
2. *Creazione e gestione del volume*: Un volume può coincidere con una partizione o raggruppare più partizioni (anche di dispositivi diversi) in un'unica struttura logica.
3. *Formattazione ad alto livello (o logica)*: Creazione vera e propria del file system all'interno di un volume, con la scrittura delle strutture dati iniziali (directory, mappe spazio libero, FCB, ecc.).
#figure(image("images/2025-08-18-15-52-13.png", width: 65%))

Il partizionamento è utile per limitare la dimensione dei singoli file system, ospitare tipi diversi di file system sullo stesso disco, o destinare parti del disco a usi diversi (es. raw partition per swap area). Ogni partizione/volume può contenere un solo file system. Ogni volume con file system contiene anche un *indice o directory del volume* che registra informazioni sui file presenti.

#figure(image("images/2025-08-18-15-52-28.png", width: 60%))

Il *settore/blocco 0* (o primary boot sector) del disco contiene il *Master Boot Record (MBR)*, costituito dalla tabella delle partizioni e dal *boot manager* (sequenza di istruzioni per identificare e avviare una partizione attiva). Recentemente, l'MBR è stato rimpiazzato dal *GPT (GUID Partition Table)*, uno standard parte di UEFI.
Il primo settore/blocco (o secondary boot sector, o boot block) di una partizione attiva contiene il *boot loader* (codice di avviamento) del SO. Il boot manager può interpretare diversi file system e avviare diversi SO; un dispositivo può avere più partizioni attive, ognuna con un SO diverso.
Durante l'avvio del SO, la partizione utilizzata per l'avvio diventa la *partizione radice (root)* del file system. Altre partizioni possono essere 'montate' automaticamente all'avvio o manualmente.

=== Scheduling dei Dischi Rigidi

==== Prestazioni di un Disco Rigido
Le prestazioni di un disco sono caratterizzate da due fattori principali:
- *TA (tempo di posizionamento o di accesso casuale)*: Tempo necessario per posizionare la testina sul settore desiderato. Nel caso di un disco a testine mobili si ha: TA = ST + RL.
  - *ST (seek time)*: Tempo per spostare radialmente il braccio sulla traccia/cilindro desiderato. Dipende dalla velocità del braccio e dalla distanza (2-10ms).
  - *RL (rotational latency)*: Tempo per il settore desiderato di ruotare sotto la testina (mediamente, mezzo giro). È di circa 4ms a 7.500 RPM, 3ms a 10.000 RPM.
- *TT (tempo di trasferimento)*: Tempo per il trasferimento effettivo dei dati di un singolo settore. Si approssima con il quoziente tra il tempo per compiere un giro e il numero di settori per traccia. Dipende dalla velocità di rotazione, densità del disco e interfaccia. È solitamente dell'ordine dei microsecondi.

La formattazione a basso livello influisce sulla densità e quindi sul tempo di trasferimento.
#example("Dipendenza delle prestazioni dalla densità")[
  Un disco da 10.000 RPM impiega 6ms ad effettuare una rotazione
  - Se ci sono 300 blocchi per traccia di 512 byte ciascuno, ci sono allora 153.600 byte = 150 KB in una traccia, che verranno letti in 6ms
  - Quindi procede a una velocità di 24,4MB/s (= 153.600 byte / 6 ms =
  25.600 byte/s), a prescindere dall'interfaccia (anche con SCSI a  640MB/s)
  - Il tempo di trasferimento di 1 blocco è 512 byte / (150 KB / 6 ms) = 6 / 300 ms = 1 / 50 ms = 0,02 ms (o, alternativamente, 1 / (300 / 6 ms))
]

*Le prestazioni dipendono principalmente dal tempo di ricerca (ST) e dalla latenza di rotazione (RL)*, poiché il tempo di trasferimento è molto minore. Le prestazioni influenzano anche il tempo che un processo resta in attesa nella coda del dispositivo.

==== Migliorare le Prestazioni
Le prestazioni possono essere migliorate tramite:
- *Criteri di memorizzazione dei dati su disco*:
  - *Allocazione contigua* dei blocchi di un file genera richieste raggruppate, limitando lo spostamento del braccio, il che è vantaggioso per l'accesso sequenziale.

  - *Allocazione concatenata o indicizzata* potrebbe sparpagliare i blocchi, richiedendo maggiori spostamenti del braccio.
  - Anche la posizione delle tabelle di directory e dei FCB (File Control Block) è importante.
- *Criteri di schedulazione delle richieste di accesso al disco*.

==== Schedulazione degli Accessi al Disco
Le richieste di I/O sui dispositivi di memoria secondaria sono generate sia dal file system che dal sistema di memoria virtuale. Una richiesta contiene informazioni come tipo di operazione, indirizzo del disco (blocchi logici), indirizzo di memoria e numero di blocchi da trasferire. Se il dispositivo è disponibile, la richiesta è servita immediatamente; altrimenti, viene aggiunta alla coda delle richieste pendenti. Il driver del dispositivo migliora le prestazioni ordinando le richieste in coda.

==== Algoritmi di Schedulazione
Sono stati proposti vari algoritmi per determinare in che ordine servire le richieste di I/O verso un disco rigido che sono in attesa su una coda.
Per confrontare gli algoritmi, si usa la *distanza totale* (in termini di numero di cilindri visitati) coperta dalla testina per servire tutte le richieste in coda.

*Esempio di scenario*: Disco con 200 cilindri (0-199). Coda di richieste: `98, 183, 37, 122, 14, 124, 65, 67`. Testina inizialmente sul cilindro `53`.

1. *FCFS (First Come, First Served)*:
  - Serve le richieste nell'ordine in cui sono accodate.
  - È intrinsecamente *equo* e *evita starvation*.
  - *Non garantisce la massima velocità* del servizio, non corrisponde a criteri di ottimalità.
  #figure(image("images/2025-08-18-15-56-38.png"), caption: "Distanza totale: 640")

2. *SSTF (Shortest Seek Time First)*:
  - Serve per prima la richiesta che fa riferimento alla *traccia più vicina* a quella corrente. È una forma di schedulazione SJF (Shortest Job First).
  - *Minimizza il tempo di ricerca locale*, ma non globale.
  - *Può causare starvation* di alcune richieste.
  #figure(image("images/2025-08-18-15-57-26.png"), caption: "Distanza totale: 236")
  - *Osservazione*: Non sempre scegliere il minimo tempo di ricerca locale porta al minimo tempo complessivo. Ad esempio, scegliendo prima `37` anziché `65`, la distanza totale potrebbe essere `208` invece di `236`.
  #figure(image("images/2025-08-18-15-57-52.png", width: 70%))

3. *SCAN (o algoritmo dell'ascensore)*:
  - Il braccio del disco si muove da una estremità all'altra del disco, *servendo le richieste man mano che raggiunge ogni traccia*; quando arriva all'estremità, *inverte la marcia*.
  - *Inconveniente*: Se una richiesta arriva per una traccia adiacente alla posizione corrente ma dalla parte opposta al movimento della testina, deve attendere che la testina raggiunga l'estremità, inverta la marcia e serva tutte le richieste che la precedono.
  #figure(image("images/2025-08-18-15-59-49.png", width: 70%), caption: "E' 216 non 236. FIX ME")

4. *C-SCAN (Circular SCAN)*:
  - Variante di SCAN progettata per un *tempo di attesa più uniforme*.
  - Il braccio si muove da un'estremità all'altra del disco, servendo le richieste lungo il percorso. Quando raggiunge un'estremità, *ritorna direttamente all'altra estremità, senza servire richieste durante il ritorno* trattando i cilindri come una lista circolare.
  #figure(image("images/2025-08-18-16-00-45.png", width: 70%))

5. *LOOK e C-LOOK*:
  - Sono varianti rispettivamente di SCAN e C-SCAN.
  - In *LOOK*, il braccio arriva *fino alla richiesta finale* rispetto alla direzione di movimento, e non fino all'estremità fisica del disco. Lì inverte immediatamente la propria direzione.
  - In *C-LOOK*, quando il braccio arriva alla richiesta finale in una direzione, si porta direttamente sulla richiesta più vicina all'estremità opposta, senza servire richieste durante il ritorno.
  #figure(image("images/2025-08-18-16-00-57.png", width: 70%), caption: "C-LOOK")

==== Considerazioni sugli Algoritmi di Schedulazione
Questi algoritmi assumono implicitamente che la *geometria reale del disco sia la stessa di quella virtuale*. Se ciò non si verifica, i criteri su cui si basano perdono senso, poiché il SO non può essere certo della reale distribuzione dei settori e delle loro relazioni di vicinanza. Tuttavia, se il controllore del disco può accettare più richieste in attesa, può usare internamente questi algoritmi, che rimangono validi a un livello più basso (quello del controllore).

==== Considerazioni sulle Prestazioni (Dischi Moderni)
Nei dischi rigidi moderni, il tempo di ricerca e la latenza di rotazione sono così predominanti che la lettura di uno o due settori alla volta è molto inefficiente. Perciò, molti controllori leggono e gestiscono la memorizzazione temporanea di più settori (caching), anche se ne è richiesto solo uno. Qualunque richiesta di lettura causa la lettura di quel settore e di buona parte della traccia su cui si trova, a seconda della cache disponibile nel controllore.
