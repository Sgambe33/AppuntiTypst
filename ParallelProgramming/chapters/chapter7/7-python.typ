#import "../../../dvd.typ": *
= Programmazione Concorrente e Asincrona in Python


== Il Modello di Esecuzione di Python e le sue Limitazioni

Per comprendere a fondo la concorrenza in Python, è necessario analizzare come l'interprete gestisce la memoria. Le restrizioni sulla concorrenza nell'interprete CPython derivano dal suo approccio alla *garbage collection* (raccolta dei rifiuti), il quale si basa sul conteggio dei riferimenti (reference counting) per determinare quando un oggetto non è più in uso ed eliminabile .

Il conteggio dei riferimenti tiene traccia di quante entità necessitano attualmente dell'accesso a un determinato oggetto Python. In un programma multi-thread, queste operazioni di conteggio devono rigorosamente essere eseguite in modo "thread-safe" per evitare la corruzione dei conteggi, la quale porterebbe a perdite di memoria o alla distruzione prematura di oggetti in uso. Di conseguenza, per evitare tali corruzioni, l'architettura impone che un solo thread alla volta possa essere in esecuzione all'interno dell'interprete (ovvero, eseguire effettivamente codice Python).

=== Il Global Interpreter Lock (GIL)

Questa restrizione si materializza nel *Global Interpreter Lock (GIL)*. Il GIL impedisce a qualsiasi processo Python di eseguire più di un'istruzione bytecode alla volta. Pertanto, anche se eseguiamo il nostro codice su una macchina dotata di processori multi-core, il GIL assicura che un solo thread Python sia attivo in un dato istante logico.

E' importante notare che il GIL è una peculiarità dell'interprete originale basato su C, noto come *CPython*. Esistono interpreti alternativi come IronPython (scritto in C\#) e Jython (scritto in Java) che non possiedono il GIL, appoggiandosi alle architetture di memoria dei rispettivi linguaggi ospite.

== Concorrenza vs Parallelismo: Thread e Processi

A causa del GIL, il modulo `threading` di Python può essere utilizzato unicamente per ottenere la *concorrenza* (l'illusione di eseguire più compiti contemporaneamente alternandoli), ma non il *parallelismo* puro (l'esecuzione simultanea fisica) sulle operazioni di calcolo.

#figure(image("images/2026-03-05-14-50-21.png"))

Questa limitazione, tuttavia, non si applica a tutte le situazioni. Si definiscono operazioni *CPU-bound* quelle attività che impiegano intensamente il processore per calcoli matematici ed elaborazione dati. Al contrario, le operazioni *I/O-bound* trascorrono la maggior parte del loro tempo in attesa di risposte da dispositivi esterni, come dischi rigidi, database o connessioni di rete.

Il GIL viene fortunatamente rilasciato dall'interprete durante le operazioni di I/O. Poiché le chiamate di sistema a basso livello necessarie per l'I/O risiedono al di fuori del runtime di Python e non interagiscono direttamente con i suoi oggetti, il lucchetto globale non è necessario.

#example()[
  Per illustrare questo concetto, consideriamo un caso studio in cui si effettuano richieste di rete multiple. Se avviamo due thread separati (ad esempio `thread_1` e `thread_2`) che eseguono una funzione incaricata di scaricare una pagina web tramite la libreria `requests.get('https://www.example.com')`, il GIL verrà rilasciato non appena inizia l'attesa per la risposta del server. A livello di sistema operativo, queste due operazioni di I/O verranno eseguite parallelamente. Il GIL verrà riacquisito dal thread specifico solo nel momento in cui i dati ricevuti dovranno essere tradotti nuovamente in un oggetto Python. Grazie a questo meccanismo di condivisione del blocco durante le fasi di attesa, i programmi multi-thread orientati all'I/O possono ottenere significativi incrementi prestazionali.
]

Per le operazioni CPU-bound, l'alternativa obbligata per scavalcare il GIL è il *Multiprocessing*. Questa tecnica avvia processi di sistema completamente separati, ognuno dotato del proprio spazio di memoria indipendente e, soprattutto, del proprio GIL personale. Sebbene i processi non condividano la memoria nativamente, offrono strumenti per lo scambio di messaggi e la condivisione esplicita dei dati. Infine, librerie esterne ad alte prestazioni come Numpy, PyTorch o TensorFlow scritte in C/C++ (o moduli scritti in Cython) possono aggirare il GIL rilasciandolo esplicitamente durante l'esecuzione del loro codice compilato, a patto che non manipolino oggetti Python durante tali routine.

== Profilazione del Codice

Prima di avventurarsi nell'ottimizzazione tramite parallelismo, è doveroso misurare dove il programma impieghi effettivamente il suo tempo. Questa pratica, denominata *Profilazione*, permette di identificare i colli di bottiglia.

Python offre due profiler nativi integrati: `profile` (scritto in puro Python, ma più lento) e `cProfile` (basato su un'estensione in C, decisamente più rapido e consigliato). E' possibile lanciare `cProfile` direttamente da riga di comando per analizzare uno script e salvare l'output delle chiamate a funzione.

Tuttavia, per un'analisi più granulare, si utilizza il *Line Profiler*. Questo strumento permette di esaminare il tempo trascorso su ogni singola riga di codice all'interno di una specifica funzione, che viene marcata appositamente con il decoratore `@profile`.

== Asyncio

Per gestire l'I/O in modo efficiente senza i costi di sistema associati alla creazione e distruzione di molteplici thread o processi, Python 3.4 ha introdotto la libreria *asyncio*. La programmazione asincrona implica che un compito (task) a lunga esecuzione possa essere processato in background, separatamente dal flusso principale dell'applicazione. Asyncio non elude il GIL, ma ne sfrutta intelligentemente i tempi morti: quando un'operazione di I/O sospende il programma, asyncio preleva il controllo e lo assegna a un altro frammento di codice in attesa di essere eseguito.

Il cuore pulsante di ogni applicazione asyncio è l'*Event Loop*. L'Event Loop mantiene una coda dei compiti da svolgere. Quando un task in esecuzione incontra un'operazione di I/O bloccante, esso mette in pausa la propria esecuzione, restituendo il controllo all'Event Loop. Quest'ultimo, a ogni sua iterazione, verificherà lo stato delle attese ed eseguirà altri task rimasti nella coda, elaborandoli uno alla volta finché non colpiranno a loro volta un blocco I/O. Non appena le operazioni hardware di I/O originarie terminano (ad esempio la ricezione di un file via rete), i task in attesa vengono "risvegliati" e inseriti nuovamente nella coda di esecuzione.Questo meccanismo di overlapping of waiting permette la concorrenza asincrona: mentre l'esecuzione del codice sulla CPU rimane strettamente sequenziale a causa del GIL, l'attesa per l'I/O avviene parallelamente per molteplici operazioni.
#figure(image("images/2026-03-05-14-58-43.png"))

=== Coroutine e Multitasking Cooperativo

L'unità fondamentale del paradigma asincrono è la *Coroutine*. Una coroutine è una funzione progettata esplicitamente per poter sospendere la propria esecuzione e poterla riprendere in un secondo momento. Questo approccio si definisce *multitasking cooperativo*, in quanto è la funzione stessa a cedere volontariamente il controllo al sistema.

A livello sintattico, si definisce una coroutine precedendo la dichiarazione della funzione con la parola chiave `async def`. All'interno di essa, si utilizza la parola chiave `await` per contrassegnare il punto in cui avviene l'operazione prolungata (come una chiamata di rete). `await` mette in pausa la coroutine contenitore fino a quando il risultato dell'operazione attesa non viene restituito, permettendo nel frattempo al sistema di risvegliare e gestire altre coroutine.

E' fondamentale comprendere che invocare direttamente una coroutine nel codice non comporta la sua esecuzione immediata, ma restituisce semplicemente un oggetto `coroutine`. Per eseguirla fisicamente, l'oggetto deve essere inserito in un Event Loop, un'operazione tipicamente facilitata, a partire da Python 3.7, dalla funzione ad alto livello `asyncio.run()`.

=== Gestione dell'Esecuzione: Task, Future e l'Event Loop

Per gestire la concorrenza, le coroutine grezze vengono solitamente avvolte all'interno di oggetti chiamati *Task*. Un task agisce da wrapper che pianifica l'esecuzione della coroutine nell'Event Loop il prima possibile. La funzione `asyncio.create_task()` genera e avvia il task in modo non bloccante: una volta istanziato, il programma può procedere con l'istruzione successiva mentre il task inizia a girare in background.

L'ecosistema dei Task fornisce metodi di controllo avanzati. Possiamo verificare se un task ha completato il suo lavoro invocando il metodo `done()`, ed estrarne il risultato tramite `result()`. Inoltre, i task supportano la *Cancellazione*. L'invocazione del metodo `cancel()` arresta il task sollevando un'eccezione interna `CancelledError` nel momento in cui il codice tenta di attenderlo (`await`). Qualora sia necessario imporre un limite temporale, la funzione `asyncio.wait_for(task, timeout)` arresta la coroutine e solleva l'eccezione `TimeoutError` allo scadere dei secondi stabiliti. Al contrario, per immunizzare un task vitale dalle richieste di cancellazione, lo si può racchiudere all'interno della funzione protettiva `asyncio.shield()`.

Sotto il cofano di Task e Coroutine opera spesso un costrutto ancor più primitivo: il *Future* (Futuro). Mutuato dai modelli di programmazione parallela di C++11 e Java, un Future è un oggetto Python "awaitable" che funge da segnaposto per un singolo valore non ancora disponibile, ma che ci si aspetta di ottenere nel futuro. Un Future transita nello stato di completamento nel momento in cui un processo sottostante vi inietta il valore definitivo richiamando il metodo `set_result()`.

Per scenari di sviluppo complessi, i programmatori possono scavalcare l'automazione di `asyncio.run()` per accedere al *Controllo Esplicito dell'Event Loop*. Invocando `asyncio.new_event_loop()`, si istanzia manualmente il motore asincrono, potendo avviare i task tramite il metodo `run_until_complete()` e gestire operazioni di schedulazione a bassissimo livello, ricordandosi infine di liberare le risorse di sistema richiamando `close()` all'interno di un blocco finally per garantire la corretta chiusura anche in caso di crash dell'applicazione.

== Pattern di Esecuzione Concorrente in Asyncio

Quando si gestiscono decine di task, il lancio manuale di ciascuno diventa inefficiente. Un approccio di base prevede la generazione dei task tramite "List Comprehension" (una sintassi compatta per la generazione di liste in Python), seguita da un ciclo asincrono per l'attesa dei risultati. E' tuttavia un errore logico fondere i due passaggi: scrivere `[await asyncio.create_task(foo()) for param in params]` forza l'interprete ad attendere la fine del primo task prima di istanziare il secondo, annullando totalmente la concorrenza e degradando il codice a un'esecuzione puramente sequenziale.

Per risolvere elegantemente questo problema e garantire un'orchestrazione parallela formale, asyncio offre un trittico di primitive fondamentali: `gather`, `as_completed` e `wait`.

=== La Funzione gather

`asyncio.gather(*tasks`) accetta una sequenza di elementi attendibili (se si passano coroutine, verranno automaticamente trasformate in task in esecuzione) e permette di eseguirle simultaneamente su una singola riga di codice. Questa funzione restituisce un elenco strutturato dei risultati. Un pregio fondamentale di gather è che l'ordine dei risultati restituiti nell'elenco coinciderà sempre e rigorosamente con l'ordine di invocazione dei task passati come parametri, indipendentemente dal reale ordine temporale di completamento dei medesimi. Per quanto concerne le eccezioni, il parametro opzionale `return_exceptions` riveste un ruolo cruciale: se impostato a `True`, gli eventuali errori generati da singoli task difettosi non fermeranno l'esecuzione globale, ma verranno silenziosamente restituiti nella lista dei risultati (sotto forma di oggetti `Exception`) accanto ai dati validi prodotti dai task andati a buon fine, permettendo al programmatore di analizzarli e filtrarli a posteriori.

=== La Funzione as_completed

Mentre `gather` forza l'utente ad attendere la risoluzione dell'ultimo task più lento per restituire l'intero blocco dei risultati, `asyncio.as_completed(tasks)` è progettato per gestire scenari operativi dinamici in cui i dati devono essere processati istantaneamente appena resi disponibili. Questa funzione agisce come un iteratore: restituisce i risultati scaglionati nel tempo man mano che i task terminano, in un ordine non deterministico dettato dalla mera velocità di esecuzione. Supporta nativamente anche la gestione dei timeout, ma introduce una grave complessità diagnostica: a causa del disordine cronologico di riconsegna, risulta estremamente arduo associare il risultato ricevuto a quale specifico task iniziale lo abbia effettivamente generato o isolare con precisione i processi rimasti bloccati in background dopo la scadenza del timeout.

=== La Funzione wait

A fronte delle rigidità nel tracciamento e nella cancellazione riscontrate in `gather` e `as_completed`, la primitiva `asyncio.wait(tasks)` offre il massimo grado di controllo granulare. Tramite l'impiego del parametro `return_when`, essa permette al programmatore di dettare precise condizioni logiche di ritorno (ad esempio, bloccare l'attesa appena il "primo" task viene completato, oppure solo in caso di fallimento di uno di essi), restituendo distintamente due liste separate: una contenente i task giunti a destinazione e un'altra con i task rimasti in sospeso.

=== Generatori Asincroni

Nel panorama dello streaming di dati massivi, si impiegano i *Generatori Asincroni*. Riprendendo il *design pattern* dell'Iteratore, i generatori "sincroni" convenzionali utilizzano l'istruzione `yield` al posto di return per produrre ("yield", appunto) elementi singoli on-demand risparmiando memoria centrale. Nel mondo asincrono, è possibile impiegare la sintassi `async` for per iterare su queste fonti. Sebbene non vi sia alcuna parallelizzazione intrinseca nel prelevamento degli elementi (il prelievo rimane un'estrazione sequenziale), questa tecnica è irrinunciabile quando la sorgente dei dati ha natura asincrona (come lo stream di rete TCP, la ricezione continua di messaggi tramite websocket o i cursori iterativi di driver asincroni di database), in quanto permette all'Event Loop di gestire altre operazioni in background durante l'attesa del dato successivo.

=== Pitfalls (Trappole), Debugging e Timing
Lo sviluppo in asyncio nasconde dei pitfalls. Poiché asyncio ha un modello a thread singolo, inserire chiamate API convenzionalmente bloccanti (come `requests.get` originaria o `time.sleep`) all'interno di una coroutine è un errore catastrofico: l'intero Event Loop congelerà all'istante, bloccando del tutto tutti gli altri task e coroutine parallele. La soluzione impone l'adozione esclusiva di librerie native asincrone (come `aiohttp`).

= Gestione degli Ambienti in Python: Isolamento, Dipendenze e Riproducibilit�

Nello sviluppo di software moderno con Python, la corretta gestione delle dipendenze e degli spazi di lavoro rappresenta una competenza fondamentale per garantire la stabilit� e la riproducibilit� del codice. Questo capitolo esplora in dettaglio la teoria e gli strumenti alla base della gestione degli ambienti Python, analizzando le motivazioni architetturali che spingono verso l'isolamento e confrontando le soluzioni pi� diffuse, dagli strumenti nativi fino alle moderne catene di compilazione ad alte prestazioni.

== La Necessit� dell'Isolamento: Il Problema delle Dipendenze

La gestione degli ambienti Python (Python environments) ha lo scopo primario di isolare le dipendenze richieste da progetti differenti 1. In un sistema operativo standard, il gestore dei pacchetti globale installa le librerie in una directory condivisa. Tuttavia, questo approccio centralizzato genera rapidamente conflitti quando si sviluppano applicazioni molteplici.

Per illustrare questo concetto, consideriamo uno scenario operativo comune: il "Progetto A" necessita della libreria matematica Numpy nella versione specifica 1.15, mentre il "Progetto B" richiede l'utilizzo delle nuove funzionalit� presenti in Numpy 2.x 2. Se entrambe le versioni venissero installate globalmente nel sistema, una sovrascriverebbe inevitabilmente l'altra, rendendo uno dei due progetti inutilizzabile. Inoltre, l'isolamento risulta indispensabile quando si desidera testare il medesimo codice sorgente su interpreti Python differenti (ad esempio, per confrontare le prestazioni tra Python 3.8 e 3.12, o per sperimentare la versione 3.14 priva del Global Interpreter Lock - GIL) 2.Di conseguenza, i benefici chiave della gestione degli ambienti includono la prevenzione dei conflitti, la garanzia che colleghi o server di produzione possano riprodurre esattamente il medesimo setup di sviluppo, e la salvaguardia dell'integrit� dell'ambiente Python di sistema 1, 2. � infatti una regola aurea dell'ingegneria del software non modificare mai direttamente le installazioni di sistema (System-wide installations); gli utenti dovrebbero sempre avvalersi di ambienti isolati o, in alternativa, di installazioni a livello utente (ad esempio, tramite il comando pip install --user nome\_pacchetto) per evitare di corrompere l'infrastruttura del sistema operativo 3.

== Lo Standard di Libreria: venv e virtualenv

Il concetto fondamentale per risolvere i conflitti appena citati � l'*Ambiente Virtuale* (Virtual Environment). Un ambiente virtuale � un'installazione Python logicamente e fisicamente isolata dal resto del sistema: esso possiede il proprio interprete Python dedicato e una propria directory in cui vengono scaricati e installati i pacchetti, risultando del tutto separato dal Python globale 4.

A partire dalla versione 3.3, la libreria standard di Python include nativamente il modulo venv, mentre virtualenv rappresenta un pacchetto separato che offre funzionalit� estese e compatibilit� retroattiva 4.Quando si inizializza un nuovo ambiente (ad esempio, eseguendo da rerminale python -m venv myenv), il sistema genera una cartella dedicata (solitamente denominata venv o .venv). All'interno di questa cartella, si instanziano componenti strutturali critici: una sottocartella bin/ (su sistemi Linux/macOS) o Scripts/ (su Windows) contenente l'eseguibile dell'interprete e il gestore di pacchetti pip, una cartella lib/ (o Lib/) destinata a ospitare le librerie che verranno installate, e un file di configurazione pyvenv.cfg che mantiene il tracciamento del Python di base da cui l'ambiente � stato clonato 5.

Per operare all'interno di questo spazio isolato, l'ambiente deve essere "attivato" invocando lo script corrispondente (es. source myenv/bin/activate su sistemi Unix), modificando cos� le variabili d'ambiente del terminale corrente 4. Una volta attivato, le installazioni non intaccheranno il sistema globale. Al termine dei lavori, il comando deactivate ripristiner� lo stato originale del terminale 4.

La condivisione delle dipendenze in questi ambienti classici avviene tramite i file dei requisiti (Requirements Files). Utilizzando il comando pip freeze > requirements.txt, si genera un file di testo che mappa ogni pacchetto alla sua esatta versione installata 5. Un altro sviluppatore potr� ricostruire identicamente l'ambiente clonando il progetto ed eseguendo pip install -r requirements.txt 5. Questo strumento � l'ideale per progetti di piccole dimensioni 6.

== Conda: Gestione Pacchetti e Ambienti Agnostica

Mentre venv eccelle per la sua semplicit�, nel mondo del calcolo scientifico e dell'analisi dati (Data Science) emerge la necessit� di gestire non solo pacchetti scritti in puro Python, ma anche complesse dipendenze scritte in C/C++ o Fortran 7. In questo contesto domina *Conda*, un'applicazione di gestione pacchetti e ambienti inclusa nelle distribuzioni Anaconda e Miniconda 8.

A differenza di venv, Conda � uno strumento "language-agnostic" (indipendente dal linguaggio) che installa pacchetti binari precompilati. Questo offre due immensi vantaggi: in primo luogo, l'installazione di librerie scientifiche e delle relative dipendenze sottostanti (come librerie di sistema) risulta facile, veloce e priva di intoppi (smooth) 9. In secondo luogo, Conda funge anche da gestore delle versioni di Python stesso. Non vi � necessit� di pre-installare l'interprete sul sistema operativo: si pu� delegare a Conda la creazione di un ambiente contenente una specifica versione del linguaggio invocando il comando conda create --name myenv python=3.9 9, 10.

Per illustrare l'approccio dichiarativo di Conda, consideriamo l'esportazione degli ambienti. Invece del classico file di testo, Conda predilige i file YAML (environment.yml), generabili con conda env export > environment.yml 11. Questo file specifica non solo le dipendenze, ma anche i canali (channels) da cui attingere i binari:

name: myenv

channels:

- defaults

- conda-forge

dependencies:

- python=3.9

- numpy=1.23

- pip:

- tensorflow==2.9.0

Come si evince dall'esempio, Conda permette un livello di flessibilit� estremo, consentendo persino l'uso del gestore pip all'interno della definizione YAML per recuperare pacchetti non disponibili nei propri canali binari 11.

== Strumenti di Gestione Moderna: Pipenv e Poetry

L'ecosistema Python si � evoluto per incorporare concetti avanzati di ingegneria del software mutati da altri linguaggi, introducendo strumenti come Pipenv e Poetry 12.

*Pipenv* mira a unificare pip e virtualenv in un unico flusso di lavoro, sostituendo il frammentato requirements.txt con un Pipfile 12. Questo strumento � particolarmente indicato per progetti di medie dimensioni 6.

Per progetti pi� vasti e complessi emerge *Poetry*, un gestore moderno per le dipendenze e il packaging (la pacchettizzazione) 6, 13. L'innovazione principale introdotta da Poetry � l'adozione strutturale del *Lockfile* (es. poetry.lock). Un lockfile registra non solo le versioni esatte delle librerie richieste dallo sviluppatore, ma anche tutte le dipendenze transitive (le librerie richieste dalle librerie stesse) e i relativi hash crittografici 14. La stesura del codice si basa su un file centrale chiamato pyproject.toml, il quale funge da vera e propria orchestrazione del progetto, contenendo i metadati dell'autore, la versione del progetto e le restrizioni sulle librerie 15, 16.Ad esempio, quando si aggiunge una dipendenza con poetry add numpy, Poetry risolve dinamicamente l'albero delle versioni compatibili, aggiorna il file pyproject.toml e calcola i pacchetti esatti bloccandoli nel poetry.lock 13, 15. Committando entrambi i file nei sistemi di controllo versione (come Git), si garantisce che l'installazione sia rigorosamente deterministica e identica su ogni macchina 13, 14.

== Gestione degli Interpreti: Pyenv

� fondamentale distinguere tra la gestione degli *ambienti* e la gestione della *versione dell'interprete*. Mentre strumenti come Poetry utilizzano l'interprete Python gi� presente sul sistema per costruire l'isolamento 13, *pyenv* � uno strumento dedicato esclusivamente all'installazione e alla commutazione (switching) tra svariate versioni di Python (es. 3.8.10, 3.9.7) 16. Tramite comandi come pyenv global o pyenv local, lo sviluppatore pu� istruire dinamicamente una specifica directory a utilizzare una versione predeterminata del linguaggio, risultando indispensabile per le fasi di test della compatibilit� del codice (testing) 6, 17.

== L'Evoluzione delle Prestazioni: L'Ecosistema UV

La complessit� del panorama appena descritto (pip, virtualenv, pipenv, poetry) si scontra spesso con limiti architetturali legati alla velocit�, essendo molti di questi strumenti scritti in Python stesso 18. Per ovviare a ci�, � stato recentemente sviluppato *UV*, una moderna catena di strumenti (toolchain) open-source creata da Astral, interamente scritta nel linguaggio di programmazione Rust 17.

UV si posiziona come un rimpiazzo universale "drop-in" per pip, in grado di sostituire anche virtualenv e parti di poetry per la gestione di pacchetti e progetti 19. Al contrario degli strumenti tradizionali che si appoggiano ad algoritmi lenti, UV offre incrementi prestazionali sbalorditivi, risultando dalle 10 alle 100 volte pi� veloce rispetto a pip 18, 19. Queste prestazioni derivano dall'architettura in Rust, da una gestione intelligente della cache (che evita di rifare lavori ridondanti) e dal supporto nativo per il download parallelo simultaneo di molteplici pacchetti 20.Ad esempio, l'installazione di una libreria complessa come scipy risulta fino a 3 volte pi� veloce, mentre l'installazione di un intero blocco di librerie da un file requirements.txt pu� concludersi 5-10 volte pi� rapidamente 21.

Per illustrare il flusso di lavoro di un progetto basato su UV, consideriamo la configurazione di un ambiente per l'installazione di Numpy. Inizialmente, lo sviluppatore crea la cartella e assicura la presenza dell'interprete desiderato invocando uv python install 3.12 20. Successivamente, genera e attiva il proprio ambiente con uv venv --python 3.12 seguito da source .venv/bin/activate 20. L'installazione della libreria avviene rapidissimamente tramite uv pip install numpy, al termine della quale i requisiti vengono congelati in un lockfile ad alta sicurezza (uv.lock o requirements.lock) impartendo uv pip freeze > requirements.lock 20, 22, 23. Questo approccio unisce la robustezza deterministica di un lockfile stile Poetry alla massima espressione della velocit� di compilazione e risoluzione delle dipendenze 13.

== Isolamento Totale tramite Container: Docker

Quando l'isolamento offerto dagli ambienti virtuali Python non � sufficiente (ad esempio, quando l'applicazione dipende strettamente da specifici driver di sistema operativo o pacchetti base non legati a Python), l'approccio definitivo � l'uso di *Docker* 2. Docker isola l'intera applicazione all'interno di un *Container*, portando a un isolamento totale dal sistema dell'utente (Complete isolation) 6, 24. Questo paradigma risulta impareggiabile per il dispiegamento in produzione (Deployment) e lo sviluppo in ambienti rigorosamente controllati in cui occorra inglobare librerie di sistema specifiche, sebbene comporti un maggiore overhead prestazionale rispetto ai semplici virtual environments 6, 25.

== Best Practices per l'Ingegneria del Software in Python

Indipendentemente dallo strumento selezionato tra quelli esposti, la comunit� di sviluppo Python concorda su una serie di pratiche raccomandate (Best Practices) per governare i progetti 25:

1. *Un ambiente per progetto*: Mai condividere un ambiente virtuale tra codici differenti; mantenere le dipendenze rigorosamente isolate.
2. *Pinning delle versioni*: Specificare sempre le versioni esatte (Version pin) nei file di configurazione per garantire la riproducibilit� totale a distanza di tempo.
3. *Documentazione del setup*: Includere sempre le istruzioni esatte per l'avvio e il ripristino dell'ambiente nel file README del progetto.
4. *Esclusione dai repository*: Le cartelle degli ambienti virtuali (es. .venv/) generano decine di migliaia di file e binari dipendenti dal sistema operativo. Pertanto, non devono mai essere incluse nel sistema di controllo versione, ma vanno rigorosamente scartate tramite il file .gitignore.
5. *Minimizzazione e aggiornamento*: Installare strettamente e unicamente i pacchetti necessari, aggiornandoli regolarmente ma accoppiando sempre ogni modifica a un rigoroso ciclo di test.

= Programmazione Parallela e Concorrente in Python: Dai Processi a Joblib

L'evoluzione delle architetture hardware verso sistemi multi-core ha reso la programmazione parallela un requisito fondamentale per lo sviluppo di software ad alte prestazioni. Tuttavia, l'ecosistema Python presenta delle peculiarit� architetturali uniche che influenzano profondamente il modo in cui il codice viene eseguito simultaneamente. Questo capitolo esplora in dettaglio le limitazioni strutturali di Python e le metodologie avanzate per superarle, partendo dall'uso nativo del modulo multiprocessing fino ad arrivare a librerie ad alto livello come Joblib.

== Il Limite del GIL e il Paradigma Multiprocessing

Il cuore dell'interprete standard di Python � governato dal *Global Interpreter Lock (GIL)* 1. Il GIL � un meccanismo di sincronizzazione che impedisce rigorosamente a pi� di un'istruzione di bytecode Python di essere eseguita in modo concorrente 1. Di conseguenza, l'utilizzo del classico multithreading in Python non fornisce alcun reale beneficio prestazionale per le operazioni di calcolo intensivo (CPU-bound), a differenza di quanto accade in linguaggi come C++, Java o tramite librerie come OpenMP 1. Il multithreading in Python rimane utile quasi esclusivamente per i compiti limitati dall'I/O (I/O bound) 1.

Per ottenere un vero parallelismo scavalcando le limitazioni del GIL, la libreria standard offre il modulo multiprocessing. Questo modulo implementa il paradigma della programmazione a memoria condivisa permettendoci di generare (spawn) nuovi processi indipendenti al posto dei thread 1, 2. Ciascuno di questi sotto-processi (subprocesses) disporr� del proprio interprete Python isolato e, soprattutto, del proprio GIL personale, potendo cos� essere allocato dal sistema operativo su core fisici differenti 2.

� importante notare che, storicamente, il multiprocessing � stato la via obbligata per il parallelismo CPU-bound. Tuttavia, a partire dalla versione 3.13 di Python, sono state introdotte delle build sperimentali definite "free-threaded" (prive di GIL), le quali permettono finalmente ai thread di scalare direttamente sui vari core 3. Nonostante questa innovazione, il multiprocessing mantiene un'importanza vitale, in quanto garantisce l'isolamento della memoria, la robustezza e la tolleranza ai guasti. Come regola generale per l'ingegneria del software in Python: si utilizzino i thread (in ambienti no-GIL) per la pura velocit� su memoria condivisa, e i processi per l'isolamento e l'affidabilit� 3.

== Creazione e Gestione dei Processi

La generazione di un nuovo processo avviene attraverso l'istanziamento della classe Process 4. Durante la creazione, � necessario fornire un target, ovvero il nome della funzione che desideriamo eseguire, e l'argomento args, una tupla contenente i parametri da passare a tale funzione 4.Una volta costruito l'oggetto, il processo non parte automaticamente; � tassativo invocare il metodo start(), il quale avvia l'attivit� in modo asincrono restituendo istantaneamente il controllo al programma principale 4, 5. Successivamente, per evitare che il programma genitore (parent process) termini prematuramente uccidendo i suoi figli, � obbligatorio invocare il metodo join() 4, 5. Questo comando blocca l'esecuzione del processo genitore finch� il sotto-processo non ha completato il proprio lavoro 4, 5.

Per illustrare questo concetto e garantire la sicurezza del codice, specialmente su sistemi operativi Windows (ma considerato una buona pratica anche su Linux), la creazione dei processi deve essere rigorosamente protetta all'interno del blocco condizionale principale. Ad esempio, si scriver�: if \_\_name\_\_ == "\_\_main\_\_":, seguito dall'istanziamento di Process, dal suo start() e dal suo join() 5. A differenza dei thread, una funzione eseguita tramite Process non pu� restituire direttamente un valore di ritorno al programma principale 4. L'esito dell'esecuzione pu� essere verificato interrogando l'attributo exitcode, dove un valore pari a 0 indica un successo, un valore maggiore di 0 segnala un errore, e un valore negativo indica che il processo � stato interrotto forzatamente 4.

=== Processi Demone e Sottoclassamento

Esistono scenari in cui � necessario eseguire compiti onerosi in background senza che questi blocchino la chiusura dell'applicazione. A questo scopo si utilizzano i *Processi Demone (Daemon processes)* 6. Impostando l'attributo daemon a True prima di avviare il processo, si istruisce il sistema a terminare automaticamente tale processo non appena il programma principale si conclude, evitando la creazione di fastidiosi processi orfani 6. � fondamentale chiarire che, in questo contesto, un processo demone non ha nulla a che vedere con i demoni di sistema (come i server web o i servizi in background del sistema operativo) 6.

Un'alternativa architetturale elegante per la creazione di processi complessi prevede il sottoclassamento (Subclassing) della classe base Process 6. Per implementare questa struttura, si definisce una nuova classe che eredita da Process. Successivamente, si sovrascrive (override) il costruttore \_\_init\_\_(self, [args]) per inizializzare eventuali variabili di stato, e si sovrascrive il metodo run(self, [args]) inserendovi la logica computazionale 6. Quando si istanzier� questa nuova classe e si chiamer� il metodo start(), il sistema invocher� automaticamente e in modo parallelo il metodo run() 6.

== Comunicazione Inter-Processo (IPC)

Poich� i processi dispongono di spazi di memoria rigidamente isolati, lo scambio di dati richiede canali di comunicazione strutturati. Il modulo multiprocessing ne offre due principali: le code (Queues) e i tubi (Pipes) 7.

Una *Queue* (Coda) restituisce una struttura dati di tipo FIFO (First-In, First-Out) condivisa, sicura per l'utilizzo concorrente sia tra thread che tra processi (thread and process safe), e capace di gestire molteplici produttori e consumatori simultaneamente 7. Qualsiasi oggetto Python serializzabile (picklable) pu� essere inserito ed estratto da essa. Tipicamente, la coda viene istanziata nel blocco \_\_main\_\_ e passata come argomento ai processi costruttori 7.Per applicazioni che richiedono il tracciamento formale dei compiti, si utilizza la sottoclasse *JoinableQueue* 8. Essa introduce due metodi fondamentali: task\_done(), che deve essere invocato dal processo consumatore per segnalare di aver concluso l'elaborazione di un elemento estratto, e join(), che blocca il processo chiamante finch� tutti gli elementi inseriti nella coda non sono stati non solo estratti, ma anche formalmente dichiarati conclusi 8.

Al contrario, un *Pipe* fornisce un canale di comunicazione diretto e bidirezionale tra due soli punti, restituendo una coppia di oggetti connessi dotati di metodi send() e receive() 8.

== Memoria Condivisa e Sincronizzazione

Nonostante l'isolamento nativo, in ambiti ad alte prestazioni � talvolta obbligatorio condividere fisicamente porzioni di memoria. Il modulo offre gli oggetti Value e Array per immagazzinare dati in una mappa di memoria condivisa, richiedendo per� di specificare esplicitamente il tipo di dato in formato C (ad esempio, 'd' per i numeri in virgola mobile a doppia precisione e 'i' per gli interi con segno) 9. In alternativa, un oggetto Manager pu� istanziare un processo server dedicato che permette ad altri processi di manipolare complessi oggetti Python tramite proxy 9.

A partire da Python 3.8, � stato introdotto il modulo multiprocessing.shared\_memory, che fornisce blocchi di memoria condivisa a bassissimo livello 9. Questo approccio � rivoluzionario in quanto evita completamente i lenti processi di serializzazione (pickling) e copia degli oggetti 9. Il processo genitore crea un segmento SharedMemory assegnandogli un nome stringa; i processi figli "si agganciano" (attach) a questo blocco tramite il nome, modificano i byte sul posto (in-place) e rilasciano la risorsa 9, 10. Al termine, il genitore deve rigorosamente invocare close() e unlink() per deallocare la memoria e prevenire memory leak 10.Tuttavia, vi sono delle accortezze (caveats): questa libreria fornisce solo blocchi di byte grezzi, ignorando totalmente i tipi di dato nativi di Python 11. Sebbene esista la classe ShareableList per condividere liste limitate di interi o stringhe, l'utilizzo principe e pi� efficiente della shared\_memory si realizza lavorando in sinergia con i grandi array della libreria *NumPy* 11.

La condivisione di risorse impone l'uso di primitive di sincronizzazione per evitare condizioni di competizione (race conditions) 9. Python fornisce Lock() (un mutex esclusivo) e Semaphore() (che limita l'accesso a un numero definito di attori simultanei) 12.Per illustrare questo concetto, si analizzi la gestione sicura di un lock. Anzich� invocare manualmente some\_lock.acquire(), eseguire le operazioni in un blocco try e rilasciare la risorsa nel blocco finally con some\_lock.release(), � caldamente consigliato l'uso dei context manager (gestori di contesto) 13. Il codice si riduce alla forma elegante e sicura:

with some\_lock:

= esecuzione della sezione critica

Questo costrutto garantisce che l'acquisizione avvenga all'ingresso del blocco e il rilascio all'uscita, anche in caso di eccezioni fatali 12, 13.

== Gestione Avanzata tramite Process Pools e Futures

Quando il parallelismo richiede l'esecuzione di una moltitudine di task indipendenti, la creazione manuale di centinaia di processi risulta inefficiente per il sistema operativo. La classe *Pool* risolve questo problema gestendo un serbatoio di processi "operai" (workers) dal numero fisso, ai quali il lavoro viene distribuito in modo trasparente 13. I valori di ritorno vengono raccolti automaticamente e restituiti in forma di lista 13.

I metodi principali di Pool si dividono in sincroni e asincroni:

* apply(): esegue una funzione bloccando il programma finch� il risultato non � pronto 14.
* apply\_async(): variante non bloccante che restituisce un oggetto AsyncResult e supporta l'uso di funzioni di callback per elaborare il risultato appena disponibile 14.
* map(): equivalente parallelo della funzione nativa, accetta un iterabile, lo suddivide in blocchi (chunks) e li distribuisce al pool, bloccando fino al termine 14.
* map\_async(): variante asincrona di map, anch'essa dotata di supporto per le callback, le quali devono essere eseguite istantaneamente per non bloccare i thread di gestione 14.Al termine dell'utilizzo, un Pool deve essere chiuso tramite close() (che attende la fine dei task in corso) o terminate() (che forza la chiusura inviando segnali SIGKILL ai worker), seguiti sempre da join() 14, 15.

Un limite tecnico dei Pool riguarda il passaggio di dati condivisi. Gli argomenti passati ai task nel Pool vengono serializzati (pickled) e accodati 16. Poich� oggetti come Value e Array non sono serializzabili, non possono essere passati direttamente come argomenti 16. La soluzione ingegneristica richiede di definire tali variabili come globali e di sfruttare gli "initializer" del pool (funzioni speciali eseguite all'avvio di ogni worker) per permettere ai figli di creare riferimenti locali alla memoria del genitore 16.

In architetture software moderne, si preferisce astrarre i pool utilizzando il modulo concurrent.futures, il quale fornisce la classe *ProcessPoolExecutor* 17. Questo esecutore standardizza l'interfaccia fornendo il metodo submit(), che incapsula le chiamate asincrone restituendo un oggetto *Future* (un'astrazione che rappresenta un risultato non ancora disponibile) 17, 18.ProcessPoolExecutor differisce dal classico Pool offrendo capacit� avanzate: permette di cancellare (tramite il metodo cancel()) i task accodati che non hanno ancora iniziato l'esecuzione, e consente un accesso diretto alle eccezioni verificatesi durante il calcolo interrogando il metodo exception() dell'oggetto Future 15.

== Integrazione tra Multiprocessing e Asyncio

Nello sviluppo di applicazioni di rete o ad alto I/O che necessitano occasionalmente di elaborazioni pesanti (CPU-bound), nasce l'esigenza di far coesistere il modulo asincrono asyncio con il multiprocessing 15.Questo ponte architetturale � fornito dal metodo dell'Event Loop denominato run\_in\_executor 19. Tale metodo accetta un callable (una funzione) e un Executor (come il ProcessPoolExecutor). Esso esegue la funzione all'interno del pool di processi (garantendo il vero parallelismo rispetto al GIL) e restituisce al mondo asincrono un oggetto "awaitable" 19. Questo oggetto pu� essere comodamente atteso con la keyword await o passato a funzioni di raggruppamento come asyncio.gather 19.

Esiste tuttavia un ostacolo logico: run\_in\_executor accetta solo il nome della funzione e non permette di passargli direttamente gli argomenti 19, 20. Per superare questo limite, si ricorre alla tecnica della *Valutazione Parziale (Partial Application)* fornita dal modulo functools 20.Per illustrare questo concetto, consideriamo una funzione foo(some\_arg) che deve essere parallelizzata. L'applicazione parziale "congela" gli argomenti all'interno della funzione stessa, trasformandola in una nuova funzione che non ne richiede. La sintassi sar�: foo\_some\_args = functools.partial(foo, some\_args) 20.Il flusso di lavoro corretto prevede quindi: la creazione dell'esecutore di pool, l'estrazione dell'Event Loop, la creazione delle funzioni parziali, l'invocazione di run\_in\_executor per ciascuna di esse conservandone i Future restituiti, e infine l'attesa simultanea dei risultati tramite gather o as\_completed 20, 21.

== L'Ecosistema Joblib: Parallelizzazione e Caching ad Alte Prestazioni

Nel panorama del calcolo scientifico e dell'apprendimento automatico (in particolare come motore sottostante della libreria Scikit-learn), la libreria di alto livello *Joblib* rappresenta lo standard per l'orchestrazione del parallelismo 21. Essa astrae enormemente le complessit� del multiprocessing, fornendo parallelizzazione semplificata, ottimizzazione dell'uso della memoria e sistemi di persistenza dei dati estremamente efficienti 21.

Il cuore dell'esecuzione parallela in Joblib � governato dai *Backend*. Joblib supporta differenti motori per svolgere il lavoro:

- *loky*: � il backend predefinito nei sistemi moderni 22. � estremamente robusto, utilizza processi worker separati basati su semantiche "fork+exec" e previene numerosi bug intrinseci al multiprocessing classico 22.
- *threading*: Condivide la memoria e risulta ottimale unicamente quando si richiamano librerie scritte in C (come estensioni compilate) in grado di rilasciare autonomamente il GIL di Python 21, 22.
- *multiprocessing*: Il backend storico (legacy) basato su multiprocessing.Pool, oggi considerato meno robusto rispetto a loky 22, 23.

Un'altra funzionalit� distintiva di Joblib � la *Memoization* (Memoizzazione), una tecnica di ottimizzazione che salva su disco rigido i risultati delle chiamate a funzioni computazionalmente costose 22, 24. A differenza del decoratore memoized presente nella libreria standard di Python (che satura la memoria RAM), Joblib genera dump compressi su filesystem, capaci di gestire enormi array NumPy 24. Questa funzione, applicabile tramite decoratori, agisce come una cache: se la funzione viene richiamata con i medesimi input, il ricalcolo viene saltato e il risultato viene immediatamente caricato dal disco 22. La memoria � progettata esclusivamente per funzioni "pure" (il cui output dipende unicamente dall'input) e il suo contenuto pu� essere cancellato permanentemente invocando il metodo clear() 25.

Per quanto concerne la parallelizzazione dei cicli iterativi, Joblib fornisce la classe helper Parallel. L'uso idiomatico prevede l'impiego del decoratore delayed.Per illustrare questo concetto vitale, consideriamo la stesura di un ciclo for parallelo. Senza la funzione delayed, un'istruzione in stile list-comprehension calcolerebbe immediatamente i risultati in modo sequenziale prima ancora di passarli all'oggetto Parallel 26. Il decoratore delayed cattura invece la funzione e i suoi argomenti, congelandoli in una tupla senza eseguirla 26. L'esecuzione viene rimandata al momento in cui l'intero blocco di task viene iniettato nel motore di parallelizzazione, abilitando il vero parallelismo 26.

Nelle iterazioni complesse che richiedono il riuso del parallelismo (magari intervallato da elaborazioni intermedie), invocare Parallel pi� volte in un ciclo istanzierebbe e distruggerebbe continuamente i processi worker, causando un overhead disastroso 27. La tecnica corretta prevede l'uso dell'API dei Context Manager (with Parallel(...) as ...:), in modo concettualmente simile alla direttiva =pragma omp parallel in OpenMP, la quale mantiene in vita il pool di worker riutilizzandolo per successive ondate di calcolo 27.

=== Gestione Ottimizzata della Memoria: Memmap e Carico di Lavoro

Il problema pi� grave nel parallelismo a processi indipendenti � l'uso della memoria: passare enormi matrici di dati (come i dataset di machine learning) a ogni singolo worker comporta la clonazione serializzata (tramite il protocollo pickle) degli stessi, portando al collasso la RAM del sistema 28, 29.Joblib risolve genialmente questo problema utilizzando internamente le sottoclassi numpy.memmap per gli oggetti numpy.ndarray 28. Un file memory-mapped � un file residente sul disco rigido che il sistema operativo mappa direttamente nella memoria virtuale 30. Questo permette ai vari processi separati (come i worker del backend loky) di osservare simultaneamente la medesima sequenza di byte senza dover compiere alcuna copia dei dati 30. L'utilizzo di memmap (attivabile tramite la direttiva mmap\_mode='r' per la sola lettura) � ottimale per matrici gigantesche lette in concorrenza, specialmente su moderni dischi a stato solido (SSD) 31. Risulta invece controproducente su array di piccole dimensioni, dove l'overhead di mappatura supera il beneficio, o in scenari ad altissimo tasso di scrittura, che saturerebbero la banda del disco 31.

Infine, l'ingegnere del software deve prestare attenzione al bilanciamento del carico. Per mitigare la pressione sulla memoria, Joblib offre l'argomento pre\_dispatch, che controlla quante code di task inviare ai worker preventivamente, evitando di inondarli di richieste istantanee 29. Parallelamente, per ridurre i tempi morti di schedulazione di task estremamente brevi, l'argomento batch\_size permette di raggruppare molteplici piccoli task obbligando il singolo worker a processarli consecutivamente all'interno di un unico blocco logico 29. A completamento del suo ecosistema orientato ai Big Data, le funzioni joblib.dump() e joblib.load() sostituiscono il modulo standard pickle, garantendo una persistenza estremamente pi� rapida e supportando algoritmi di compressione avanzati (come zlib, lzma, lz4) con un livello raccomandato di 3 su 10, ideali per congelare su disco colossali array NumPy al termine dell'elaborazione 31, 32.

= Programmazione Parallela in Python: Oltre il GIL e le Nuove Frontiere del Multithreading

L'evoluzione dell'ecosistema Python sta attraversando una delle trasformazioni architetturali pi� radicali della sua storia. Per decenni, l'esecuzione concorrente nel linguaggio � stata pesantemente limitata da vincoli strutturali interni. Questo capitolo esplora la teoria della programmazione parallela in Python, analizzando il superamento dei limiti storici, il confronto tra thread e processi nel nuovo paradigma "free-threaded" e l'utilizzo pratico delle librerie standard per l'orchestrazione dei flussi di esecuzione.

== Il Paradigma Storico: CPU-bound, I/O-bound e il Limite del GIL

Prima di addentrarci nelle architetture parallele, � imperativo categorizzare i carichi di lavoro computazionali 1. Un'operazione si definisce *CPU-bound* (limitata dalla CPU) quando il suo tempo di esecuzione � dominato da intensi calcoli matematici 1. In questi scenari, disporre di un processore pi� veloce si traduce direttamente in un programma pi� veloce; esempi classici includono i kernel numerici, gli algoritmi di crittografia e l'elaborazione di immagini 1. Al contrario, un'operazione *I/O-bound* (limitata dall'Input/Output) trascorre la maggior parte del suo tempo in attesa di accessi al disco fisso, comunicazioni di rete o interrogazioni a database 1. In questo caso, le prestazioni migliorano unicamente ottimizzando la velocit� del disco o della rete 1.

Storicamente, l'interprete standard CPython ha gestito la memoria utilizzando un meccanismo di sincronizzazione noto come *Global Interpreter Lock (GIL)* 2. Il GIL assicura rigorosamente che un solo thread alla volta possa eseguire il bytecode di Python 2. Di conseguenza, prima delle recenti innovazioni, il multithreading in Python era utile quasi esclusivamente per i compiti I/O-bound (spesso gestiti tramite librerie come Asyncio), poich� il GIL veniva rilasciato durante le attese di rete o disco 1. Per ottenere un vero parallelismo nei compiti CPU-bound, gli ingegneri del software erano costretti ad abbandonare i thread e ad affidarsi al modulo multiprocessing, creando processi separati e pesanti 1.

== La Rivoluzione "Free-Threaded" (Python 3.13 e 3.14)

L'ostacolo rappresentato dal GIL � stato affrontato formalmente con la proposta PEP 703, la quale ha introdotto una versione (build) opzionale di Python definita *free-threaded*, in cui il GIL � completamente disabilitato 2. Mentre in Python 3.13 questa architettura � stata rilasciata in fase sperimentale, con l'avvento di Python 3.14 la versione free-threaded � pienamente supportata e notevolmente pi� veloce, grazie alla riattivazione di meccanismi di specializzazione dell'interprete 2.

Per installare e testare questo nuovo ambiente, lo standard moderno prevede l'utilizzo del gestore di pacchetti uv 2. La sintassi generica per l'installazione richiede il comando uv python install 3.14+freethreaded (oppure 3.13t per la versione precedente) 3. All'interno di un progetto specifico, � possibile istanziare un ambiente virtuale dedicato invocando uv venv -p 3.14+freethreaded e attivandolo successivamente con i classici comandi di sistema, come source .venv/bin/activate su ambienti Unix o .venv\Scripts\activate su Windows 3.

Tuttavia, l'installazione dell'interprete free-threaded non garantisce automaticamente l'assenza del GIL. Anche in questa versione, alcune estensioni scritte in linguaggio C, qualora non ancora aggiornate per la sicurezza multi-thread, potrebbero riabilitare il GIL in automatico per prevenire la corruzione della memoria 3. Per forzare lo spegnimento del GIL a tempo di esecuzione (runtime), lo sviluppatore deve intervenire esplicitamente impostando la variabile d'ambiente export PYTHON\_GIL=0, oppure avviando lo script con il parametro (switch) da riga di comando python -X gil=0 your\_script.py 3. Se si utilizza l'esecutore di uv, la sintassi completa sar� uv run -p 3.14+freethreaded python -X gil=0 your\_script.py 3.

== Thread contro Processi: Un Nuovo Equilibrio Architetturale

La disabilitazione del GIL altera profondamente le best-practices della progettazione software in Python. In un mondo senza GIL, i *Thread* (eseguiti all'interno di un singolo processo) offrono un parallelismo CPU reale e puro, comportandosi in modo simile a quanto avviene nei linguaggi C o Java 4. I thread risultano estremamente economici (cheap) da creare in termini di risorse di sistema e condividono nativamente lo stesso spazio di memoria, rendendoli eccellenti per il parallelismo a grana fine (fine-grained) 4. Inoltre, l'utilizzo dei thread in Python free-threaded comporta un ingombro di memoria (memory footprint) drasticamente inferiore e un overhead quasi nullo per l'invio di argomenti e la ricezione di risultati, poich� non vi � necessit� di serializzare (pickling) gli oggetti 5, 6.

Al contrario, i *Processi* sono entit� "pesanti" (heavyweight) 4. Ogni processo possiede il proprio spazio di indirizzamento separato e un proprio interprete Python isolato 4. La comunicazione tra processi richiede la serializzazione degli argomenti e dei risultati, introducendo un overhead significativo dovuto all'avvio del processo e alle operazioni di pickling 5, 7.Nonostante ci�, il multiprocessing mantiene la propria utilit� strategica in scenari specifici 6. Esso risulta vincente quando � richiesto un forte isolamento: se un processo "operaio" (worker) va in crash (ad esempio per un errore di segmentazione in una libreria C), il programma principale genitore non viene terminato 6. Inoltre, rimane l'unico approccio valido sull'interprete CPython classico (con GIL attivo) per compiti CPU-bound, o quando si utilizzano librerie di terze parti non ancora compatibili con il modello free-threaded 6. Infine, l'astrazione a processi rappresenta il naturale mattone costruttivo (building block) per scalare le architetture su sistemi distribuiti e multi-macchina 6.

Dal punto di vista delle prestazioni attese, in un ambiente CPython classico, l'uso dei thread per operazioni CPU-bound offre una velocit� identica all'esecuzione sequenziale di base, mentre il multiprocessing fornisce un reale incremento di velocit� (speed-up) pagando il prezzo dell'overhead di sistema 7. Al contrario, nell'ambiente free-threaded (Python 3.14), sia i thread semplici che i pool di thread garantiscono un reale speed-up multi-core, superando spesso il multiprocessing grazie all'assenza di latenze di serializzazione 7.

Per implementare questi paradigmi, la libreria standard offre tre moduli fondamentali 8:

1. threading: Fornisce il controllo manuale dei thread e le primitive di sincronizzazione a basso livello. � ideale quando si necessita di pochi thread a vita lunga e di architetture software personalizzate 8.
2. concurrent.futures: Offre un'API (Interfaccia di Programmazione) ad alto livello tramite l'oggetto ThreadPoolExecutor e l'astrazione dei Future. Risulta la scelta ottimale per applicare la stessa operazione a molti compiti simili 8.
3. multiprocessing: Gestisce pool basati su processi per il parallelismo classico, l'isolamento della memoria e l'aggiramento del GIL sui vecchi interpreti 8.

== Gestione Manuale dei Thread: Il Modulo threading

Il ciclo di vita di un thread gestito manualmente tramite il modulo threading � rigoroso 9. Si istanzia l'oggetto invocando threading.Thread(target=..., args=...), dove target � la funzione da eseguire e args la tupla dei parametri 9. Successivamente, si avvia fisicamente il thread richiamando il metodo .start(), e ci si assicura che il programma principale ne attenda la conclusione invocando il metodo .join() 9. Il pattern progettuale pi� comune prevede la costruzione di una lista di thread, l'avvio iterativo di tutti gli elementi e, in un secondo ciclo separato, l'invocazione di join su ciascuno di essi 9.

=== Caso Studio 1: Threading con Funzioni Pure

Il primo approccio per l'implementazione del multithreading prevede l'utilizzo di funzioni libere (free functions) 10. L'idea di base � che ogni thread chiami la medesima funzione passandole argomenti differenti 10. Poich� una funzione eseguita in un thread non pu� restituire il suo valore tramite un semplice return al programma principale, si utilizza un piccolo "involucro" (wrapper) logico per salvare i risultati in una struttura dati condivisa, tipicamente un dizionario o una lista 10. Le funzioni pure, minimizzando l'uso di variabili condivise, sono particolarmente adatte a questo scenario 11.

Per illustrare questo concetto, consideriamo un programma progettato per sommare grandi intervalli numerici 12. Definiamo innanzitutto la funzione computazionale:

import threading

def count\_in\_range(name: str, start: int, end: int) -> int:

total = 0

for x in range(start, end):

total += x

print(f"{name}: done")

return total

All'interno della funzione main(), istanziamo un dizionario vuoto results = {} e definiamo una funzione worker nidificata che si occuper� di incapsulare il calcolo e registrare il valore finale nel dizionario globale 12:

def main():

results = {}

def worker(name: str, s: int, e: int):

results[name] = count\_in\_range(name, s, e)

threads: list[threading.Thread] = []

for i in range(4):

s = i \* 1\_000

e = (i + 1) \* 1\_000

t = threading.Thread(target=worker, args=(f"t{i}", s, e))

threads.append(t)

t.start()

for t in threads:

t.join()

print("Total:", sum(results.values()))

In questo esempio, vengono avviati simultaneamente quattro thread indipendenti (t0, t1, t2, t3), ognuno responsabile del calcolo della somma matematica su una porzione discreta dell'intervallo totale 11-13. Al termine di tutti i calcoli, garantiti dalle chiamate a join(), il programma somma i risultati parziali raccolti nel dizionario condiviso 11, 13.

=== Caso Studio 2: Threading Orientato agli Oggetti

Un'alternativa architetturale pi� robusta e scalabile prevede l'impiego delle classi per incapsulare lo stato e il comportamento 14. In questo paradigma, ogni istanza della classe detiene la propria configurazione interna e un campo (field) dedicato per immagazzinare il risultato 14. Questa strategia riduce drasticamente l'ammontare dei dati condivisi globalmente, in quanto lo stato (come i limiti di calcolo e il risultato parziale) risiede in modo sicuro all'interno della singola istanza 15. Inoltre, l'utilizzo di una classe facilita l'estensione futura del codice, permettendo di aggiungere agilmente logiche di registrazione degli eventi (logging) o di gestione degli errori 14, 15.

Per illustrare questo pattern, riscriviamo il calcolo precedente definendo una classe RangeCounter 14, 16:

import threading

class RangeCounter:

def \_\_init\_\_(self, name: str, start: int, end: int):

self.name = name

self.start = start

self.end = end

self.result = 0

def run(self) -> None:

total = 0

for x in range(self.start, self.end):

total += x

self.result = total

print(f"{self.name}: done")

Nella funzione di avvio, non sar� pi� necessario un dizionario condiviso o una funzione wrapper 16. Creeremo una lista di oggetti istanziati (i nostri "lavoratori") e passeremo al costruttore del Thread il metodo "legato" (bound method) run della specifica istanza 16, 17:

def main():

workers = [

RangeCounter("t0", 0, 1\_000),

RangeCounter("t1", 1\_000, 2\_000),

]

threads = [

threading.Thread(target=w.run) = Metodo legato come target

for w in workers

]

for t in threads:

t.start()

for t in threads:

t.join()

total = sum(w.result for w in workers)

print("Total:", total)

Al termine dell'esecuzione dei thread, i risultati vengono semplicemente recuperati interrogando l'attributo result di ciascun oggetto presente nella lista workers 15, 16.

== Astrazione ad Alto Livello: concurrent.futures e i Pool di Thread

Quando il problema ingegneristico richiede di applicare la medesima funzione a un vasto numero di input (operazione di "parallel map"), la gestione manuale del ciclo di vita dei thread diventa eccessivamente verbosa (boilerplate) e prono a inefficienze di sistema. In questi scenari, si adotta la libreria concurrent.futures, la quale fornisce l'oggetto ThreadPoolExecutor 15, 18, 19. Un "esecutore" gestisce in totale autonomia un serbatoio (pool) di thread pre-inizializzati, occupandosi della loro creazione, della schedulazione dei task e del riutilizzo dei thread al termine di un calcolo 15, 19.

Il metodo pi� immediato per utilizzare il pool � la funzione map(fn, iterable), la quale simula perfettamente la funzione map nativa di Python, ma esegue l'applicazione della funzione fn su ogni elemento dell'iterabile in modo parallelo 15, 19. Il pool di thread risulta eccezionale per codice puramente Python orientato alla CPU in ambienti free-threaded, e garantisce bassissimi overhead, specialmente se le librerie esterne impiegate sono thread-safe 5.

=== Caso Studio 3: Parallelismo Map-Style con ThreadPoolExecutor

Per illustrare l'eleganza di questo approccio, consideriamo il problema del conteggio dei numeri primi. Immaginiamo di possedere una funzione esterna count\_primes(start, end) 20.Definiamo innanzitutto una piccola funzione "involucro" (task) per scompattare la tupla degli argomenti 20:

from concurrent.futures import ThreadPoolExecutor

from primes import count\_primes

def task(args: tuple[int, int]) -> int:

start, end = args

return count\_primes(start, end)

La distribuzione del lavoro avviene in una singola riga logica all'interno di un gestore di contesto (with), il quale si occuper� automaticamente di avviare il pool e attendere la chiusura di tutti i calcoli 20:

def main():

ranges = [(1, 75\_000), (75\_000, 150\_000), (150\_000, 225\_000), (225\_000, 300\_000)]

with ThreadPoolExecutor(max\_workers=4) as ex:

results = list(ex.map(task, ranges))

print("Total primes:", sum(results))

L'esecutore, istanziato con un tetto massimo di 4 thread attivi, preleva dinamicamente i pacchetti di lavoro (chunks) dalla lista ranges, li elabora e restituisce una lista ordinata di risultati, nascondendo completamente allo sviluppatore la complessit� della sincronizzazione hardware 18, 20.

=== Il Concetto di Future e la Funzione as\_completed

Un livello di controllo ancora pi� profondo si ottiene utilizzando il metodo submit(fn, \*args), il quale pianifica un singolo lavoro nel pool e restituisce immediatamente un oggetto *Future* (futuro) 15, 19. Un Future � un "manico" (handle) che rappresenta il risultato di un'operazione non ancora calcolata e disponibile 18. Tramite il Future, il programmatore pu� verificare se il task � terminato invocando .done(), allegare funzioni di ritorno con .add\_done\_callback(cb), o estrarre fisicamente il valore (o sollevare l'eccezione catturata durante l'esecuzione nel thread) richiamando .result() o .exception() 18.

L'accoppiamento del metodo submit con l'iteratore as\_completed consente di processare i risultati dinamicamente e reattivamente, non appena ciascun singolo task si conclude, senza dover attendere il termine del task temporalmente pi� lungo 19, 21.

=== Caso Studio 4: Gestione Asincrona e Tolleranza agli Errori tramite Futures

Per illustrare questa metodica avanzata di controllo, rivisitiamo l'esempio dei numeri primi. Costruiamo un dizionario che mappa ogni oggetto Future appena creato (tramite submit) agli argomenti specifici che gli sono stati assegnati 22, 23:

from concurrent.futures import ThreadPoolExecutor, as\_completed

from primes import count\_primes

def main():

ranges = [(1, 75\_000), (75\_000, 150\_000), (150\_000, 225\_000), (225\_000, 300\_000)]

with ThreadPoolExecutor(max\_workers=4) as ex:

futures = {

ex.submit(count\_primes, start, end): (start, end)

for (start, end) in ranges

}

total = 0

for fut in as\_completed(futures):

start, end = futures[fut]

try:

n\_primes = fut.result()

print(f"{start}-{end}: {n\_primes}")

total += n\_primes

except Exception as e:

print(f"Error in range {start}-{end}: {e}")

print("Total primes:", total)

In questo schema, il ciclo for fut in as\_completed(futures) funge da ricevitore dinamico. Non appena un thread conclude il suo calcolo, il Future corrispondente viene restituito dall'iteratore 21, 22. � all'interno del blocco try...except che la robustezza del sistema si manifesta: invocando fut.result(), eventuali eccezioni fatali verificatesi in modo asincrono all'interno del thread worker vengono intercettate in sicurezza sul thread principale, evitando il crash dell'intera applicazione e permettendo un tracciamento puntuale degli errori per quel specifico intervallo di dati 19, 21, 22.

== Sincronizzazione, Race Conditions e Misurazione delle Prestazioni

L'abbandono del Global Interpreter Lock espone nativamente il codice Python a vulnerabilit� di sistema precedentemente ignote, note come *Race Conditions* (Condizioni di Competizione sui dati) 24. In un ambiente free-threaded, le strutture di dati mutabili condivise rischiano corruzioni gravissime. Ad esempio, operazioni apparentemente innocue e unitarie come l'aggiornamento non protetto di un contatore (counter += 1) possono facilmente comportare la perdita di incrementi logici qualora due thread vi accedano in perfetta simultaneit� 24.

Pertanto, per garantire la correttezza algoritmica, l'impiego del lock threading.Lock() a protezione delle "sezioni critiche" (critical sections) del codice diventa un obbligo tassativo 9, 24. Le best practices prescrivono di governare l'acquisizione (acquire()) e il rilascio (release()) del lucchetto attraverso l'uso della direttiva with lock:, la quale assicura una gestione immune dalle eccezioni procedurali (exception safety) 9. Qualora la logica dell'applicazione lo richieda, il modulo offre anche l'oggetto RLock (un lock rientrante per acquisizioni ricorsive dello stesso thread), i Semaphore per limitare il numero totale di thread simultanei, gli Event per gestire bandiere logiche d'attesa, e costrutti di coordinamento di gruppo come Condition e Barrier 10.

Infine, l'ingegneria del software richiede una rigorosa validazione dei benefici ottenuti dalla parallelizzazione. La misurazione delle prestazioni (profilazione) deve essere affrontata utilizzando il timer time.perf\_counter(), il quale garantisce la massima risoluzione cronologica per il tempo reale trascorso (wall-clock timing) 24. Per ottenere misurazioni affidabili, ogni scenario architetturale deve essere eseguito molteplici volte, considerando il valore della mediana per filtrare picchi anomali causati dal sistema operativo sottostante 24. Durante le fasi di benchmarking per task orientati alla potenza di calcolo (CPU-bound), � altres� cruciale evitare di introdurre inquinamenti prestazionali mescolando tali calcoli con pesanti operazioni I/O (come la scrittura su disco dei risultati parziali) 24. Per analisi pi� microscopiche e profonde, l'ecosistema Python mette a disposizione l'operatore timeit, il profilatore nativo cProfile, i line profilers (che analizzano il tempo di stazionamento su ogni singola riga di codice) e gli strumenti diagnostici integrati negli ambienti di sviluppo avanzati (IDE tools) 24.

L'approccio free-threaded inaugurato ufficialmente in Python 3.14 abilita un vero multithreading computazionale pur conservando la potenza espressiva di API familiari come threading e concurrent.futures 25. Sebbene il multiprocessing resti insostituibile per l'isolamento dei task e i setup preesistenti (legacy), il medesimo codice pu� ora produrre accelerazioni prestazionali differenziate, spostando definitivamente il linguaggio verso un'elaborazione ad alte prestazioni tipica dei linguaggi di sistema tradizionali 25 (per ulteriori approfondimenti formali, si rimanda a testi d'avanguardia quali il *Python Parallel Programming Cookbook* di G. Zaccone, Capitolo 2, e *The Python 3 Standard Library by Example* di D. Hellmann, Capitolo 10 25).

= Calcolo Parallelo su GPU in Python: L'Ecosistema CUDA, PyCUDA e Numba

Nel panorama contemporaneo del calcolo ad alte prestazioni e dell'Intelligenza Artificiale, il linguaggio Python si � affermato come lo standard *de facto* per lo sviluppo di algoritmi. Tuttavia, data la natura intrinsecamente sequenziale e i limiti strutturali del suo interprete (come il Global Interpreter Lock, o GIL), l'esecuzione nativa in Python risulta inadeguata per carichi di lavoro computazionalmente intensivi. Per superare questo ostacolo, l'industria ha sviluppato sofisticate interfacce (bindings) e compilatori che permettono a Python di delegare le operazioni pi� gravose alle Unit� di Elaborazione Grafica (GPU) tramite l'architettura CUDA di NVIDIA 1. Questo capitolo esplora la teoria, le librerie e i paradigmi di programmazione necessari per sfruttare appieno l'accelerazione hardware direttamente dal codice Python.

== L'Ecosistema delle Librerie CUDA per Python: RAPIDS e DALI

L'approccio pi� immediato per ottenere l'accelerazione GPU in Python non richiede la scrittura di codice parallelo a basso livello, bens� l'adozione di librerie pre-compilate e altamente ottimizzate. NVIDIA fornisce un vasto ecosistema di librerie abilitate per CUDA, racchiuse principalmente nel progetto open-source *RAPIDS.ai* 1. L'obiettivo di RAPIDS � permettere l'esecuzione di intere pipeline di *Data Science* direttamente sulla GPU.

Tra i componenti fondamentali di questo ecosistema troviamo:

- *cuDF:* Una libreria progettata come sostituto diretto (drop-in replacement) della celebre libreria Pandas. Essa permette la manipolazione di DataFrame, ma esegue tutte le operazioni di filtraggio, aggregazione e unione sfruttando il parallelismo massivo della GPU 1.
- *cuML:* Fornisce versioni accelerate su GPU dei pi� popolari algoritmi di Machine Learning tradizionale. Mantenendo un'interfaccia di programmazione identica a quella di *scikit-learn*, cuML permette di eseguire algoritmi complessi come XGBoost con incrementi prestazionali drastici senza dover riscrivere la logica dell'applicazione 1.
- *cuVS:* Una libreria specializzata negli algoritmi per la ricerca dei vicini pi� prossimi approssimati (approximate nearest neighbors) e per il clustering su GPU 1.

Inoltre, nel contesto dell'addestramento di reti neurali profonde, il caricamento e la pre-elaborazione dei dati (come immagini o video) dal disco rigido alla memoria rappresentano spesso un grave collo di bottiglia. Per mitigare questo problema � stata introdotta la *NVIDIA Data Loading Library (DALI)* 2. DALI � una libreria accelerata via GPU che fornisce blocchi costruttivi altamente ottimizzati per caricare, decodificare e pre-processare dati multimediali. Essa esegue operazioni come le *augmentations* (ad esempio rotazioni o ritagli di immagini) direttamente sull'hardware grafico, e si integra in modo trasparente e portabile con i data loader (caricatori di dati) nativi dei pi� diffusi framework di Deep Learning, quali PyTorch, TensorFlow, JAX e PaddlePaddle 2.

== Paradigmi di Programmazione Custom: PyCUDA contro Numba

Quando le librerie pre-confezionate non sono sufficienti per esprimere la logica di un algoritmo personalizzato, il programmatore deve scrivere direttamente i propri *kernel* (le funzioni eseguite parallelamente sulla GPU). In Python, questo paradigma si divide in due filosofie principali: l'astrazione a basso livello fornita da *PyCUDA* e la compilazione "al volo" ad alto livello offerta da *Numba* 3.

=== PyCUDA: Il Controllo a Basso Livello

*PyCUDA* fornisce un'interfaccia diretta alle API di CUDA 3. Utilizzando questa libreria, lo sviluppatore mantiene un controllo a grana fine (fine-grained) sull'hardware, gestendo esplicitamente l'allocazione della memoria e il trasferimento dei dati tra l'Host (la CPU) e il Device (la GPU) 3, 4.

La particolarit� di PyCUDA risiede nel fatto che il codice del kernel non viene scritto in Python, bens� in linguaggio *CUDA C* 3, 4. Questo codice C viene inserito all'interno dello script Python sotto forma di stringhe di testo, le quali vengono poi compilate a tempo di esecuzione dal modulo pycuda.compiler.SourceModule 5.Da un lato, questo approccio garantisce la massima flessibilit�, permettendo l'uso di funzionalit� avanzate come gli stream, gli eventi e l'allocazione dinamica della memoria, oltre a tradurre automaticamente gli errori generati dall'hardware CUDA in normali eccezioni Python 3, 4. Dall'altro lato, richiede allo sviluppatore una profonda conoscenza della sintassi C e dell'architettura hardware sottostante 4, 6.

La gestione della memoria in PyCUDA � rigorosamente manuale. Per allocare spazio sulla GPU si utilizza la funzione cuda.mem\_alloc(size). Per spostare i dati si impiegano copie esplicite: cuda.memcpy\_htod(dst, src) per il trasferimento "Host to Device" (dalla RAM di sistema alla memoria video) e cuda.memcpy\_dtoh(dst, src) per il percorso inverso "Device to Host" 7.

=== Numba: La Compilazione JIT e l'Astrazione Pythonica

Al contrario dell'approccio manuale di PyCUDA, *Numba* � un compilatore *JIT (Just-In-Time)* progettato specificamente per il codice Python orientato al calcolo numerico. Numba intercetta le normali funzioni Python e, al momento della loro prima invocazione, le traduce automaticamente in codice macchina nativo (sia per CPU che per GPU) garantendo prestazioni massime 3, 7. (Il supporto specifico per CUDA � oggi fornito dal pacchetto separato numba-cuda 8).

L'enorme vantaggio di Numba � che permette di scrivere kernel GPU utilizzando esclusivamente la sintassi standard di Python, eliminando la necessit� di scrivere codice C (boilerplate code) 4, 6, 8. Numba offre un'integrazione eccellente con gli array della libreria NumPy 4. Il suo impiego di base prevede l'uso di decoratori, come `@jit(nopython=True)`, il quale istruisce il compilatore a generare codice macchina per CPU privo delle inefficienze dell'interprete Python globale (arrivando persino a rilasciare il GIL) 7.Per l'accelerazione su GPU, si utilizza il decoratore `@cuda.jit`, che converte la funzione Python in un vero e proprio kernel CUDA 4, 7. Inoltre, Numba supporta la vettorizzazione automatica: utilizzando il decoratore `@vectorize` con l'argomento target='cuda', Numba trasforma una funzione Python progettata per operare su singoli scalari in una *Universal Function* (ufunc) in grado di operare parallelamente ed elemento per elemento su interi array NumPy 3, 7.

== Caso Studio: L'Algoritmo SAXPY in PyCUDA e Numba

Per illustrare concretamente la profonda differenza tra questi due paradigmi, consideriamo l'implementazione dell'algoritmo *SAXPY* (Single-Precision A\*X Plus Y). Questa operazione, fondamentale nell'algebra lineare (BLAS), richiede di moltiplicare un vettore $X$ per uno scalare $A$, e di sommare al risultato un vettore $Y$ ($A times X + Y$).

=== Implementazione in PyCUDA

Nell'approccio PyCUDA, il programmatore deve orchestrare interamente il flusso logico e fisico dell'applicazione 5, 9, 10:

1. *Definizione del Kernel C:* Il codice macchina viene definito in una stringa di testo. Il singolo thread identifica la propria posizione con la classica formula blockIdx.x \* blockDim.x + threadIdx.x e, se l'indice ricade nei limiti del vettore, esegue l'operazione matematica. Il modulo SourceModule viene invocato per compilare questa stringa.
2. *Inizializzazione Dati:* Si generano array NumPy per i vettori x e y.
3. *Gestione della Memoria:* Si alloca lo spazio esatto sulla GPU richiamando cuda.mem\_alloc(x.nbytes) e si trasferiscono i dati invocando cuda.memcpy\_htod() 9.
4. *Configurazione di Esecuzione:* Lo sviluppatore deve calcolare analiticamente le dimensioni della griglia e dei blocchi. Ad esempio, definendo un blocco 1D da 256 thread (block\_dim = (256, 1, 1)), la dimensione della griglia viene calcolata per eccesso per coprire l'intera dimensione dell'array x 9.
5. *Lancio e Recupero:* Il kernel viene lanciato passando esplicitamente le dimensioni definite e i puntatori alla memoria del dispositivo (d\_x, d\_y). Infine, � necessaria una chiamata a cuda.memcpy\_dtoh() per riportare il risultato sulla RAM della CPU 9, 10.

=== Implementazione in Numba

La controparte scritta con Numba risulta immensamente pi� compatta e astratta 10:

import numpy as np

from numba import vectorize, float32

= Definizione della ufunc accelerata via GPU

```python
@vectorize([float32(float32, float32, float32)], target='cuda')

def saxpy(a, x, y):

return a \* x + y
```

= Inizializzazione dati Host

a = 3.141

x = np.random.rand(1024, 2048).astype(np.float32)

y = np.random.rand(1024, 2048).astype(np.float32)

= Esecuzione trasparente

result = saxpy(a, x, y)

In questo esempio, il decoratore `@vectorize` compie tutto il lavoro pesante. La funzione saxpy � scritta come se dovesse operare su singoli numeri decimali (float32). Numba genera automaticamente il ciclo parallelo (il kernel CUDA) in background. Inoltre, quando invochiamo result = saxpy(a, x, y) passando interi array NumPy, Numba si occupa *automaticamente* dell'allocazione della memoria sulla GPU, del trasferimento dei dati verso il dispositivo, del lancio del kernel e del successivo trasferimento del risultato verso la CPU 10.

Tuttavia, questo enorme livello di automazione cela delle insidie prestazionali. Numba adotta un approccio conservativo: quando trasferisce automaticamente gli array, esso presuppone che possano essere stati alterati e, alla fine del kernel, *ritrasferisce sempre l'intera memoria del dispositivo indietro verso l'host* 11. Per array di grandi dimensioni che vengono utilizzati in sola lettura (read-only arrays), questo trasferimento di ritorno inutile distrugge le prestazioni consumando la banda del bus PCIe. Di conseguenza, per scenari ottimizzati, anche in Numba � raccomandato l'uso delle API di memoria esplicite, come cuda.to\_device() per l'invio e il metodo .copy\_to\_host() invocato puntualmente sugli array del dispositivo (device arrays) solo quando strettamente necessario 6, 11.

== Funzionalit� Avanzate e Debugging nell'Ambiente Numba

Nonostante la sua astrazione ad alto livello e la sua interfaccia tipicamente "Pythonica", Numba non � un giocattolo accademico, bens� uno strumento ingegneristico completo. Numba espone infatti l'accesso a funzionalit� di livello microscopico dell'architettura NVIDIA, supportando nativamente l'uso di *Operazioni Atomiche (Atomics)*, la gestione esplicita della *Memoria Condivisa (Shared Memory)* tra i thread di un blocco, e l'orchestrazione parallela avanzata tramite gli *Stream* 11. Come in PyCUDA, il programmatore pu� accedere alle variabili di sistema hardware per definire indici custom utilizzando numba.cuda.blockIdx, threadIdx, blockDim e gridDim 6.

Infine, lo sviluppo di codice altamente parallelo introduce la complessa problematica del *Debugging* (la ricerca e risoluzione degli errori algoritmici). Dato l'ambiente asincrono e frammentato della GPU, l'uso delle classiche stampe a schermo (print statements) risulta spesso caotico o impossibile.Per ovviare a questo problema, Numba include uno strumento vitale: il *CUDA Simulator* 11. Questo simulatore implementa la semantica di CUDA Python utilizzando interamente l'interprete Python della CPU principale 11.Impostando la variabile d'ambiente del sistema operativo NUMBA\_ENABLE\_CUDASIM=1 *prima* di importare Numba all'interno del proprio script, il codice progettato per la GPU verr� invece eseguito in un ambiente sequenziale o multithread simulato. Ci� permette agli sviluppatori di testare la logica algoritmica potendo utilizzare i normali debugger Python (come pdb), consentendo di fermare l'esecuzione ed esaminare l'avanzamento e lo stato della memoria passo-passo (step-through) per ogni singolo thread virtuale, isolando elegantemente gli errori logici prima di dispiegare il codice sull'hardware video reale 11, 12.

