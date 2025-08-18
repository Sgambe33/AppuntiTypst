#import "@preview/dvdtyp:1.0.1": *
#import "@preview/numbly:0.1.0": numbly

#set enum(
  full: true,
  numbering: numbly("{1:1}.", "{2:a})"),
)
= Capitolo 4: Stallo
== Il problema del deadlock

#definition("Deadlock")[
  Il problema dello *stallo (o deadlock)* si verifica quando un insieme di processi si trova in una situazione in cui ciascun processo attende un evento che solo un altro processo dell'insieme può provocare. Questo può accadere a causa della sincronizzazione tra processi, della comunicazione tra processi o, più comunemente, della condivisione di risorse.]

Lo stallo sulle risorse è una problematica gestita dal Sistema Operativo (SO), mentre altre forme di stallo non lo sono. È cruciale evitare lo stallo, poiché impedisce l'avanzamento dei processi bloccati e sottrae definitivamente risorse al sistema, compromettendo la produttività e l'uso efficiente delle risorse.

#definition("Livelock")[
  Un concetto correlato, ma meno comune, è il *livelock (o stallo attivo)*. In un livelock, un processo tenta continuamente un'azione senza successo e, sebbene non sia bloccato, non fa progressi.
]

#example("Esempio di livelock")[
  Un esempio di livelock è quello delle reti Ethernet, dove i dispositivi attendono un periodo di tempo casuale prima di ritrasmettere un pacchetto dopo una collisione, per evitare di riprovare immediatamente e fallire di nuovo.
]

=== Esempi di Deadlock nella vita reale e in sistemi di elaborazione

Il concetto di deadlock può essere illustrato con diversi esempi:

- *Strettoia in senso unico alternato (ponte)*: Ogni lato del ponte è una risorsa. Per attraversare, un'auto deve "impossessarsi" di entrambi i lati. Si verifica un deadlock quando auto da lati opposti attendono indefinitamente che l'altra parte liberi la propria porzione del ponte. Il deadlock può essere rimosso facendo indietreggiare un'automobile (prelazione della risorsa), ma questo può causare *starvation*, dove le auto da una direzione non riescono mai ad attraversare.

#image("images/2025-08-10-15-58-22.png")

- *Problema dei filosofi a cena (Dijkstra)*: Questo è un classico problema di controllo della concorrenza. Cinque filosofi condividono una tavola rotonda con un piatto di spaghetti e cinque forchette. Per mangiare, un filosofo deve prendere la forchetta alla sua destra e quella alla sua sinistra, una per volta. Le forchette devono essere usate in mutua esclusione. L'attività di ogni filosofo è: pensa, prendi forchetta sinistra, prendi forchetta destra, mangia, rilascia entrambe le forchette. Se tutti i filosofi hanno fame contemporaneamente e prendono la forchetta di sinistra, tutte le forchette diventano non disponibili. Quando un filosofo tenta di prendere la forchetta di destra, rimane in attesa indefinitamente, creando un deadlock.

#figure(image("images/2025-08-10-15-59-20.png", height: 20%))

Diverse soluzioni sono state proposte, come ordinare le forchette e richiederle rispettando l'ordinamento, chiedere entrambe le forchette con un'unica richiesta, o ammettere solo 4 filosofi al tavolo. Un'altra idea è che un filosofo prenda le forchette in ordine inverso (prima destra, poi sinistra), ma questo non funziona in generale.

- *Deadlock con masterizzatori CD*: Un sistema ha due masterizzatori CD. Due processi, P1 e P2, necessitano di entrambi per copiare un CD, utilizzando semafori di mutua esclusione A e B. Se P1 acquisisce A e poi tenta di acquisire B, mentre P2 acquisisce B e poi tenta di acquisire A, si verifica un deadlock. Entrambi i processi possiedono un masterizzatore e attendono l'altro, che è posseduto dal processo concorrente.

#figure(image("images/2025-08-10-16-00-25.png", height: 20%))

Il deadlock è un *comportamento emergente* che può presentarsi in alcune esecuzioni a causa dello scheduling e dell'interleaving di processi concorrenti.

== Modello delle Risorse di un Sistema

In un sistema concorrente, le risorse sono entità hardware o software distribuite tra più processi che competono per il loro utilizzo. Le risorse possono essere *fisiche* (CPU, stampanti, memoria) o *logiche* (file, semafori). Sono suddivise in tipi, con più istanze omogenee per ogni tipo.

Le risorse hanno diverse proprietà:
- *Condivisibili*: Usate simultaneamente da più processi (es. file in sola lettura).
- *Non-condivisibili (seriali)*: Usate in mutua esclusione (es. ciclo di CPU).
- *Statiche*: Assegnate per l'intera vita del processo (es. PCB).
- *Dinamiche*: Assegnate durante l'esecuzione del processo (es. aree di memoria).
- *Riusabili*: Possono essere usate ripetutamente (es. CPU, stampanti).
- *Consumabili*: Usate una sola volta (es. messaggi, segnali).
- *Prelazionabili*: Il SO può sottrarle al processo assegnatario (es. CPU).
- *Non-prelazionabili*: Possono essere rilasciate solo volontariamente dal processo che le possiede (es. file descriptor).

Per utilizzare una risorsa, un processo segue un ciclo di operazioni: *richiesta, uso, rilascio*. Il SO gestisce le risorse tramite system call (es. `open()`, `close()`, `allocate()`, `free()`) e mantiene una tabella dello stato di ogni risorsa. Se una risorsa richiesta è già assegnata, il processo richiedente viene accodato in attesa. Un evento di rilascio di una risorsa può portare alla sua allocazione a un processo in attesa. La *starvation* si verifica se il rilascio di una risorsa viene ritardato indefinitamente.

Il SO prende decisioni di *allocazione* (a quali processi assegnare risorse) e *scheduling* (in quale ordine servire le richieste), con l'obiettivo di usare le risorse in modo efficiente ed evitare la starvation.

== Caratterizzazione del Deadlock

Una situazione di deadlock sulle risorse può verificarsi solo se si presentano simultaneamente *quattro condizioni necessarie*:
1. *Mutua esclusione*: Le risorse sono non-condivisibili e possono essere usate solo da un processo alla volta.
2. *Possesso e attesa*: I processi trattengono le risorse che già posseggono mentre ne richiedono di aggiuntive.
3. *Assenza di prelazione*: Le risorse assegnate non possono essere sottratte forzatamente ai processi; devono essere rilasciate volontariamente.
4. *Attesa circolare*: Esiste un insieme di processi ${P_0, dots, P_n}$ tali che $P_0$ attende una risorsa posseduta da $P_1$, $P_1$ da $P_2$, $dots$, $P_{n-1}$ da $P_n$, e $P_n$ attende una risorsa posseduta da $P_0$.


Le condizioni sono *necessarie* ma *non sufficienti* affinché lo stallo si verifichi.

Lo stato di allocazione delle risorse di un sistema può essere analizzato tramite *grafi di allocazione delle risorse (di Holt)*. Questo grafo (V, E) ha due tipi di nodi: processi (P) e tipi di risorsa (R), e due tipi di archi orientati:
- *Arco di allocazione*: $R_j arrow P_i$ (la risorsa $R_j$ è allocata al processo $P_i$).
- *Arco di richiesta*: $P_i arrow R_j$ (il processo $P_i$ richiede la risorsa $R_j$).


Gli archi vengono aggiunti o rimossi in base agli eventi di richiesta, allocazione e rilascio delle risorse. Le istanze delle risorse sono rappresentate da punti all'interno del nodo del tipo di risorsa.

#figure(image("images/2025-08-10-16-17-09.png", height: 20%))

Le proprietà del grafo di Holt e il deadlock sono le seguenti:
- Se il grafo non contiene cicli, non si verifica alcun deadlock.
- Se il grafo contiene *almeno* un ciclo:
  - Se ogni tipo di risorsa coinvolto nel ciclo ha una sola istanza, allora si verifica una situazione di deadlock.
  - Altrimenti (esiste un tipo di risorsa con più istanze), c'è la *possibilità* che si verifichi un deadlock, ma non è garantito.

#example("Grafo senza cicli non ha deadlock")[
  #figure(image("images/2025-08-10-16-19-47.png", height: 20%))
]

#example("Grafo risorse a singola istanza")[
  #figure(image("images/2025-08-10-16-20-23.png", height: 20%))
  Un grafo con cicli e risorse a singola istanza mostra un deadlock
]

#example("Grafo con cicli ma senza deadlock")[
  #figure(image("images/2025-08-10-16-20-54.png", height: 20%))
  C'è il ciclo $P_1 arrow R_1 arrow P_3 arrow R_2 arrow P_1$ però non si ha stallo: il processo $P_4$ può rilasciare la propria istanza del tipo di risorsa $R_2$, che si può assegnare al processo $P_3$, rompendo il ciclo.

]

== Metodi di Gestione dei Deadlock

Esistono quattro approcci principali per gestire i deadlock:
=== 1. Prevenire il deadlock
Impedire che le condizioni necessarie si verifichino simultaneamente.
La *prevenzione statica* dei deadlock impone vincoli sul comportamento dei processi al momento della scrittura del programma, per evitare che si verifichi almeno una delle quattro condizioni necessarie.

- *Mutua esclusione*: È inevitabile per risorse seriali. Impedirla è difficile in pratica, anche se la virtualizzazione può aiutare (es. stampante virtuale).
- *Possesso e attesa*: Per prevenirla, un processo non deve possedere risorse mentre ne richiede altre. Due strategie:
  - Richiedere tutte le risorse necessarie con un'unica richiesta all'inizio (allocazione globale).
  - Un processo può chiedere risorse solo se non ne possiede già altre (deve rilasciare quelle che ha prima di chiederne di nuove).
  Questi metodi hanno inconvenienti: scarso utilizzo delle risorse, ridotta multiprogrammazione, difficile prevedere tutte le risorse in anticipo e rischio di attesa indefinita.
- *Assenza di prelazione*: Si potrebbe imporre a un processo di rilasciare implicitamente tutte le risorse possedute se la sua richiesta corrente non può essere soddisfatta. Il processo riprenderà solo quando potrà ottenere tutte le risorse. La virtualizzazione delle risorse può aiutare (es. spooling della stampante sul disco). Tuttavia, non tutte le risorse possono essere virtualizzate (es. lock su database). Il pre-rilascio è complicato e adatto solo a risorse il cui stato può essere salvato e recuperato (es. CPU), non a quelle che generano stallo (es. lock mutex).
- *Attesa circolare*: Questo è il metodo di prevenzione più comunemente usato.
  Si definisce una relazione di ordinamento tra tutti i tipi di risorsa e si impone che ogni processo la rispetti nel richiederle.
  Assegnando un numero intero unico ad ogni tipo di risorsa ($F: R arrow NN$), un processo non può richiedere una risorsa di tipo $R_i$ se possiede già risorse di tipo $R_j$ con $F(R_i) < F(R_j)$.

  In un sistema che utilizza l'ordinamento delle risorse, l'assenza di circolarità nelle relazioni di attesa può essere dimostrata *per assurdo*:

  1. Supponiamo ci sia un'attesa circolare malgrado i processi rispettino la politica basata sull'ordinamento nell'effettuare richieste di risorse.
  2. Sia $\{P_0, P_1, dots, P_n\}$ l'insieme dei processi coinvolti nell'attesa circolare, dove il processo $P_i$ attende una risorsa di tipo $R_(f(i))$ posseduta dal processo $P_(i+1)$ (sugli indici si usa l'aritmetica modulare).
  3. Poiché il processo $P_(i+1)$ possiede una risorsa di tipo $R_(f(i))$ mentre richiede una risorsa di tipo $R_(f(i+1))$ (dato che a sua volta è in attesa del processo $P_(i+2)$), è necessario che per tutti gli indici $i$ valga la condizione:
    $
      F(R_(f(i))) < F(R_(f(i+1)))
    $
  4. Ciò implica:
    $
      F(R_(f(0))) < F(R_(f(1))) < dots < F(R_(f(n))) < F(R_(f(0)))
    $
  5. Per la proprietà transitiva dell'ordinamento risulta quindi che:
    $
      F(R_(f(0))) < F(R_(f(0)))
    $
    il che è impossibile.
  6. Quindi, non può esservi attesa circolare.

  L'inconveniente è che stabilire un ordinamento adatto a tutti i processi può essere difficile in sistemi complessi.


#figure(image("images/2025-08-10-17-06-18.png", height: 35%))

La prevenzione statica, sebbene impedisca il deadlock, può causare un scarso utilizzo delle risorse e ridotta produttività, e la responsabilità di implementare i vincoli ricade sui programmatori.

=== 2. Evitare il deadlock
Il SO alloca le risorse dinamicamente solo se il sistema rimane in uno stato "sicuro".
La *prevenzione dinamica* dei deadlock non impone vincoli sul comportamento dei processi, ma il SO usa algoritmi che esaminano lo stato di allocazione delle risorse per assicurarsi che la condizione di attesa circolare non possa mai verificarsi. Questi algoritmi richiedono informazioni a priori, come il numero massimo di risorse di ogni tipo di cui un processo può avere bisogno.

#definition("Stato sicuro")[
  Uno stato è *sicuro* se esiste una *sequenza ordinata* con cui il sistema può allocare le risorse a ogni processo (fino alle sue massime richieste) ed evitare deadlock. Se un sistema è in uno stato sicuro, non si presenterà alcun deadlock. Se è in uno stato non sicuro, c'è la possibilità di deadlock.
]
La strategia è che il SO accordi una richiesta solo se l'allocazione lascia il sistema in uno stato sicuro.

#figure(image("images/2025-08-10-17-07-44.png", height: 20%))

#align(center, strong[La proprietà stato sicuro è una invariante del sistema])

Algoritmi utilizzati:

==== Algoritmo basato sul grafo di allocazione delle risorse
Viene utilizzato per rilevare (e talvolta prevenire) deadlock tramite l'analisi del grafo di allocazione delle risorse.
Applicabile solo se ogni tipo di risorsa ha una sola istanza.
Si aggiungono *archi di prenotazione* (frecce tratteggiate $P_i ⇢ R_j$) che indicano che $P_i$ potrà richiedere $R_j$ in futuro.
Le risorse devono essere prenotate a priori. Quando un processo richiede una risorsa, se disponibile, l'arco di prenotazione è convertito in un arco di assegnazione ($R_j arrow P_i$); se ciò non crea un ciclo (stato sicuro), l'assegnazione ha successo. Altrimenti, il processo attende. Il costo è $O(n^2)$.
L'esempio mostra come la richiesta di $P_2$ per $R_2$ possa portare a uno stato non sicuro (con un ciclo $P_1 arrow R_1 arrow P_2 arrow R_2 arrow P_1$).


#example("Esempio applicazione")[

  Supponiamo che $P_2$ richieda $R_2$.
  Se si assegna $R_2$ al processo $P_2$,
  cioè se si trasforma
  l'arco di prenotazione $P_2 ⇢ R_2$
  nell'arco di assegnazione $R_2 \to P_2$.

  #figure(
    grid(
      columns: 2,
      gutter: 2mm,
      image("images/2025-08-10-17-29-49.png", height: 20%), image("images/2025-08-10-17-29-57.png", height: 20%),
    ),
  )

  Si ottiene il grafo che rappresenta uno stato non sicuro (infatti, contiene un ciclo).
]

==== Algoritmo del banchiere (Dijkstra, 1965)
L'algoritmo previene i deadlock perché ad ogni richiesta e ad ogni rilascio di una risorsa da parte di un processo, esso controlla se le assegnazioni delle risorse ad un processo lascia il sistema in uno stato sicuro. In caso positivo vengono assegnate altrimenti il processo attende.
Applicabile anche per tipi di risorse con istanze multiple.
Ogni processo deve dichiarare il numero massimo di istanze di ogni risorsa di cui avrà bisogno.
L'algoritmo è attivato ad ogni richiesta e rilascio.
Sia $n$ il numero dei processi e $m$ il numero di tipi di risorse.

*Strutture dati*:

- `Available`: vettore di lunghezza $m$; se `Available[j] = k`, ci sono $k$ istanze di risorse di tipo $R_j$ disponibili.

- `Max`: matrice $n times m$; se `Max[i, j] = k`, allora il processo $P_i$, durante la sua esecuzione, può richiedere al più $k$ istanze di risorse di tipo $R_j$.

- `Allocation`: matrice $n times m$; se `Allocation[i, j] = k`, allora al processo $P_i$ sono attualmente assegnate $k$ istanze di risorse del tipo $R_j$.

- `Need`: matrice $n times m$; se `Need[i, j] = k`, allora il processo $P_i$ può avere bisogno di altre $k$ istanze di risorse del tipo $R_j$ per completare la sua esecuzione.f
#align(center, strong[Vale l'invariante: `Need [i,j] = Max[i,j] - Allocation [i,j]`])

- *Algoritmo per verificare se uno stato è sicuro*:
  1. Siano `Work` e `Finish` vettori rispettivamente di lunghezza $m$ e $n$.
  *Inizializzazione*:
  + $"Work" = "Available"$
  + $"Finish"[i] = "false"$ per $i = 1, 2, dots, n$

  2. Cercare un indice $i$ tale che:
    + $"Finish"[i] ="false"$
    + $"Need"_i lt.eq "Work"$
    Se un tale $i$ non esiste, passare al punto 4

  3. Aggiornare:
    $
      "Work" = "Work" + "Allocation"_i
    $
    $
      "Finish"[i] = "true"
    $
    Tornare al punto 2.

  4. Se per ogni $i$, $"Finish"[i] = "true"$, allora lo stato è sicuro; altrimenti non lo è.

  *Costo*: $O(m times n^2)$ operazioni per trovare una sequenza sicura.

- *Algoritmo del banchiere (gestione richiesta)*:
  Sia Requesti il vettore (di lunghezza $m$) delle richieste di $P_i$
  1. Se
  $
    "Request"_i lt.eq "Need_"i
  $
  passare al punto 2.

  Altrimenti sollevare una condizione di errore, poichè la richiesta di $P_i$ ha ecceduto il numero massimo di risorse di cui $P_i$ ha dichiarato di aver bisogno per portare a termine la sua esecuzione
  2. Se
  $
    "Request"_i lt.eq "Available" ????
  $
  passare al punto 3.

  Altrimenti $P_i$ deve attendere poichè le risorse disponibili non sono sufficienti
  3. Il sistema assegna al processo $P_i$ le risorse richieste modificando momentaneamente lo stato nel modo seguente:
  $
    "Available" = "Available" - "Request"_i;
  $
  $
    "Allocation"_i = "Allocation"_i + "Request"_i;
  $
  $
    "Need"_i = "Need"_i - "Request"_i;
  $
  Viene quindi invocato l'algoritmo per verificare se uno stato è sicuro
  - Se lo stato ottenuto è sicuro ⇒ le risorse vengono realmente assegnate a $P_i$ e lo stato diventa effettivo.
  - Se lo stato ottenuto è non sicuro ⇒ $P_i$ deve aspettare e viene ristabilito il vecchio stato di allocazione delle risorse (cioè i precedenti valori di Available, Allocation e Need).

  #example("Esempio algoritmo banchiere")[
    #image("images/2025-08-12-18-24-54.png")
    #image("images/2025-08-12-18-29-09.png")
    #image("images/2025-08-12-18-29-18.png")
    #image("images/2025-08-12-18-29-29.png")
    #image("images/2025-08-12-18-29-46.png")
    #image("images/2025-08-12-18-29-55.png")
  ]

  L'algoritmo del banchiere è costoso in termini di overhead e non permette di utilizzare al massimo le risorse (basandosi sul caso peggiore), riducendo la produttività. Inoltre, spesso le esigenze massime dei processi non sono note a priori, i processi variano dinamicamente e le risorse possono improvvisamente non essere disponibili, rendendo l'algoritmo poco applicabile nella pratica. Anche se teoricamente risolve il problema, pochi sistemi lo usano, anche se euristiche simili (es. limitare il traffico di rete quando l'utilizzo del buffer supera una soglia) sono impiegate.

=== 3. Rilevare il deadlock e ripristinare il sistema
Rilevare i deadlock quando si verificano e recuperare il sistema. Nei sistemi che non prevengono o evitano i deadlock, è possibile fornire algoritmi per rilevarne la presenza e ripristinare il sistema.

- *Singola istanza per ogni tipo di risorsa*: Si può usare un *grafo di attesa*. I nodi rappresentano solo processi, e un arco $P_i arrow P_j$ esiste se $P_i$ attende che $P_j$ rilasci una risorsa. Nel grafo di attesa, un deadlock esiste se, e solo se, c'è almeno un ciclo. Il SO mantiene questo grafo e periodicamente invoca un algoritmo di ricerca di cicli (costo $O(n^2)$).

#figure(
  image("images/2025-08-10-17-39-30.png", height: 35%),
  caption: "La figura in mostra la corrispondenza tra grafo di allocazione e grafo di attesa.",
)


- *Tipi di risorsa con istanze multiple*: L'algoritmo di rilevamento cerca di costruire sequenze fattibili di eventi che permettano a tutti i processi di terminare. Si basa su un'ipotesi ottimistica che i processi non richiedano risorse aggiuntive oltre a quelle specificate nella loro richiesta corrente.

==== Algoritmo di rilevamento

*Strutture dati*:
Sia $n$ = num. dei processi e $m$ = num. di tipi di risorse. Lo stato del sistema è rappresentato dalle seguenti strutture dati:
- Available: vettore di lunghezza m che indica il numero di istanze disponibili per ciascun tipo di risorsa.
- Allocation: matrice n x m che indica il numero di risorse di ogni tipo correntemente allocate a ciascun processo.
- Request: matrice n x m che indica le richieste correnti di ogni processo. Se Request [i,j] == k, allora il processo Pi sta chiedendo k ulteriori istanze della risorsa di tipo Rj.

*Algoritmo di rilevamento*:
+ Siano Work e Finish vettori di lunghezza m and n rispettivamente.
  Inizializzazione:
  + Work = Available
  + Per i = 1,2, …, n, se Allocationi ≠0, allora Finish[i] = false; altrimenti, Finish[i] = true.
+ Trovare un indice i tale che valgano entrambe le seguenti condizioni:
  + $"Finish"[i] == "false"$
  + $"Request"_i ≤ "Work"$
  Se un tale i non esiste, passare al punto 4.
+ $
    "Work" = "Work" + "Allocation"_i
  $
  $
    "Finish"[i] = "true"
  $
  Tornare al punto 2.
4. Se $"Finish"[i] == "false"$, per qualche $i$, $1 ≤ i ≤ n$, allora il sistema è in stallo; inoltre, se $"Finish"[i] == "false"$, allora $P_i$ è in stallo. Altrimenti il sistema non è in stallo.

Simile all'algoritmo di verifica dello stato sicuro, ma lavora con le esigenze effettive (`Request`) anziché quelle massime. Il costo è $O(m times n^2)$. Un processo `i` è considerato "finito" (`Finish[i]=true`) se `Allocation[i]` è zero (non possiede risorse e quindi non può far parte di un ciclo di attesa). Se alla fine un `Finish[i]` è `false`, allora Pi è in stallo.

#example("Esempio algoritmo di rilevamento")[
  #image("images/2025-08-12-18-32-11.png")
  #image("images/2025-08-12-18-32-28.png")
]

L'algoritmo di rilevamento dovrebbe essere eseguito in base alla frequenza dei deadlock e al numero di processi coinvolti, idealmente quando le prestazioni degradano.

*Modalità di ripristino dal deadlock*:
- *Informare l'operatore del sistema*: Lascia la risoluzione all'amministratore.
- *Ripristino automatico a carico del SO*:
  - *Terminazione forzata di processi*: Può essere costoso se tutti i processi in deadlock vengono terminati. Alternativamente, si termina un processo alla volta fino a eliminare il ciclo, scegliendo il processo con il minor "costo" di riesecuzione (basato su priorità, tempo di esecuzione, risorse usate, I/O o CPU-bound, ecc.).
  - *Rilascio anticipato di risorse*: Alcune risorse vengono forzatamente pre-rilasciate (e poi riassegnate) per interrompere il ciclo, cercando di minimizzare il costo. Questo richiede il *rollback* del processo a cui è stata tolta la risorsa, riportandolo a uno stato precedente. Esiste un rischio di *starvation* se gli stessi processi vengono sempre scelti come vittime.

Gli inconvenienti della rilevazione e ripristino includono i costi per la memorizzazione delle informazioni, l'esecuzione dell'algoritmo di rilevamento e il ripristino dello stato del sistema, con possibili perdite di informazioni.

=== 4. Ignorare il deadlock
Questo approccio, noto anche come "algoritmo dello struzzo", è *il meno costoso in termini di overhead di gestione* ed è *frequente in molti sistemi operativi, inclusi Linux e Windows*. Il SO assume che i deadlock non si presentino mai o che siano rari. La gestione dello stallo è lasciata ai programmatori del kernel e delle applicazioni.

Tuttavia, con l'aumento del numero di risorse, processi/thread, e l'adozione di programmazione multithread e sistemi multicore, questa soluzione sta diventando sempre meno conveniente, poiché la probabilità di deadlock aumenta.

In pratica, gli sviluppatori combinano diversi approcci per risolvere lo spettro di problemi di allocazione delle risorse, scegliendo l'approccio migliore per ciascun tipo di risorsa nel sistema.
