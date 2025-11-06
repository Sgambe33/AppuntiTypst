#import "../../../dvd.typ": *
#pagebreak()
= Design models

== Decomposizione in task

#definition(
  )[
  In questo approccio ci si concentra sulla computazione che deve essere eseguita piuttosto che sui dati che vengono manipolati. Il problema viene diviso in parti (o task), ognuna da eseguita in modo separato, riducendo il carico. Ognuna di questa task, per essere eseguita, viene assegnata ad un thread.
]

#align(center, image("images/2025-09-29-21-22-44.png", height: 20%))

Le task vengono assegnate ai thread in due modi:
- *Static scheduling*: la divisione delle task è saputa fin dall'inizio e non cambia la durata della computazione. Le task sono assegnate all'inizio.
- *Dynamic scheduling*: l'assegnazione delle task ai thread viene effettuata durante la computazione del problema, cercando di bilanciare il carico in modo equo. Risulta utile quando il tempo di esecuzione è sconosciuto.

#heading("Criteri di decomposizione", outlined: false, depth: 3)

I programmi si decompongono in task quasi per "natura". Due decomposizioni naturali comuni sono:
- Chiamate di funzione
- Iterazioni distinte dei cicli

Di norma ci dovrebbero essere almeno tante task quanti saranno i thread che le dovranno eseguire per evitare l'inattività dei thread durante l'esecuzione. Il numero di computazioni che ogni task deve eseguire (*granularità*) deve essere grande abbastanza da sorpassare l'*overhead* dovuto alla creazione dei thread e alla loro sincronizzazione. Tutto ciò per evitare che il programma parallelo abbia prestazioni peggiori della sua versione sequenziale.

#align(center, image("images/2025-09-29-21-23-15.png", width: 60%))

== Decomposizione dei dati

Durante l'analisi di un programma sequenziale potremmo notare che la sua esecuzione è formata principalmente da una sequenza di operazioni su tutti gli elementi di una o più strutture dati. Se quest'ultime sono indipendenti possiamo dividere i dati (in _chunks_) e assegnarne porzioni a task diverse.

#align(center, image("images/2025-09-29-21-27-06.png"))

Bisogna fare attenzione a come si suddividono i dati, come si assegnano ai thread e se ogni task potrà accedere ai dati richiesti dalla sua parte di computazione.

La decomposizione dei dati è da preferirsi quando la computazione principale è incentrata sulla manipolazione di grandi quantità di dati strutturati.

#heading("Forma dei chunk", outlined: false, depth: 3)

La forma di un chunk influisce direttamente sia sull'individuazione dei chunk vicini, sia sul modo in cui avviene lo scambio di dati durante le varie fasi di calcolo.

Se si riduce la dimensione complessiva del bordo di un chunk, diminuisce anche la quantità di dati da scambiare per aggiornare correttamente gli elementi locali. Allo stesso modo, se si riduce il numero di chunk che condividono un confine con quello considerato, l'operazione di scambio diventa meno complessa, sia da programmare che da eseguire.

In generale, una buona regola pratica consiste nel cercare di massimizzare il rapporto tra volume e superficie: il volume rappresenta la quantità di dati e quindi il livello di granularità delle computazioni, mentre la superficie corrisponde al bordo del chunk, cioè la parte che richiede comunicazione e scambio di dati con i vicini. Un rapporto elevato implica quindi più calcolo locale e meno comunicazione, rendendo il processo più efficiente.

#align(center, image("images/2025-09-29-21-48-12.png"))

#example(
  "Distribuzione dei dati per gli array",
)[
  Si consideri un insieme di processi $P={P_1,...,P_p}$ e un array monodimensionale. Si hanno a disposizione tre metodi per suddividere l'array:
  + Distribuzione *blockwise*: si suddivide l'array di $n$ elementi in $p$ blocchi con $ceil n/p ceil.r$ elementi consecutivi ciascuno.
  + Distribuzione *cyclic*: si assegnano gli elementi ai processi seguendo il _Round Robin_ così che $v_i$ è assegnato a $P_((i-1)mod p+1)$.
  + Distribuzione *block-cyclic*: combinazione dei due precedenti.

  #align(center, image("images/2025-09-29-22-04-13.png"))

  Il primo favorisce la *località spaziale* mentre il secondo la *località temporale*.
]

Per gli array bidimensionali si utilizzano combinazioni blockwise e cyclic in una o entrambe le dimensioni. La *distribuzione Blockwise Columnwise (o Rowwise)* crea $p$ blocchi di colonne (o righe) contigue. La distribuzione in entrambe le dimensioni può utilizzare *distribuzioni a scacchiera (*checkerboard*)*, dove i processori sono disposti in una mesh virtuale $p_1 dot p_2 = p$.

#figure(image("images/2025-10-07-16-55-28.png"))

#figure(image("images/2025-10-07-16-55-57.png"))

== Layout dei Dati e Prestazioni

L'efficienza della cache domina le prestazioni dei calcoli intensivi. Il costo di un cache miss è dell'ordine di 100-400 cicli, durante i quali si perdono centinaia di flop. È fondamentale usare strutture dati cache-friendly che sfruttino la località spaziale e temporale.

#example("Allocazione matrici")[
  //TODO: Aggiungere e spiegare codice
]

=== Tipi di Cache Misses
Ci sono tre tipi di cache misses:
1. *Compulsory*: Miss necessari per portare i dati nella cache quando vengono incontrati per la prima volta.
2. *Capacity*: Causati dalla dimensione limitata della cache, che espelle i dati per fare spazio a nuove linee.
3. *Conflict*: Si verificano quando i dati vengono caricati nella stessa posizione della cache. Se due o più elementi di dati necessari sono mappati sulla stessa linea di cache, devono essere caricati ripetutamente (fenomeno noto come cache thrashing, che porta a scarse prestazioni).

=== Data Layout: AoS vs. SoA vs. AoSoA

Due layout comuni sono Array of Structures (AoS) e Structure of Arrays (SoA).

- AoS: può causare problemi di allineamento nella cache sebbene i campi siano vicini tra loro ma è anche difficile da vettorizzare.
  #figure(image("images/2025-10-07-17-00-55.png"))
  #example("RGB")[
    Let us consider a graphics
    application that operates on RGB
    values. It has to read the three
    color channels at once.
    • The AoS works well on a CPU, but
    if we had to read only one of the
    values we’d reduce cache usage
    and code wouldn’t be vectorized
    • We may suffer from padding
    added by the compiler for
    memory alignment of the
    structure
    #figure(image("images/2025-10-07-17-27-47.png"))
    #figure(image("images/2025-10-07-17-28-28.png"))
  ]

- SoA: si allinea facilmente alla cache ed è vettorizzabile.
  #figure(image("images/2025-10-07-17-01-05.png"))
  #example("RGB")[
    Considering RGB values
    now Rs are contiguous,
    like G and B but all these
    may be in different parts
    of the heap.
    • If we need to operate on
    all the three channels at
    the same time and rows
    are long then it may be a
    problem for CPU caches
    (but not for GPUs)
    #figure(image("images/2025-10-07-17-28-43.png"))
    #figure(image("images/2025-10-07-17-28-50.png"))
  ]

#figure(image("images/2025-10-07-17-00-45.png"))

- AoSoA: 
  Array of Structures (AoS): 
Each element is a full particle (all fields together). 
Memory: [x y z id][x y z id][x y z id]... 
• Structure of Arrays (SoA): 
Each attribute has its own contiguous array. 
Memory: [xxx...][yyy...][zzz...][ididid...] 
• Array of Structures of Arrays (AoSoA): 
Data is grouped into blocks (tiles), and inside each block, data is 
stored as SoA. 
Memory: [(xxx...)(yyy...)(zzz...)] [(xxx...)(yyy...)(zzz...)] ... 
• SoA inside each tile, AoS across tiles. 
• Tries to combine the cache efficiency of AoS (near fields) with the 
vectorization advantages of SoA

//TODO: MANCANO IMMAGINI ED ESEMPI
// | Caratteristica | Array of Structures (AoS) | Structure of Arrays (SoA) |
// | :--- | :--- | :--- |
// | *Allineamento Cache* | Può causare problemi di allineamento, ma i campi sono vicini (buono per la cache se toccati insieme). | Facilmente allineabile ai confini della cache. |
// | *Vectorizzazione* | Più difficile da vettorizzare. | Vettorizzabile. |
// | *Esempio RGB* | Funziona bene se tutti e tre i canali RGB vengono letti contemporaneamente (es. grafica). Potrebbe esserci padding inserito dal compilatore. | I valori R, G e B sono contigui separatamente, ma possono essere in diverse parti dell'heap. Se si opera su un solo canale, è più efficiente in termini di cache. |
// | *Prestazioni Generali* | Generalmente offre prestazioni migliori sulle CPU (se tutti i campi vengono toccati). | Generalmente offre prestazioni migliori sulle GPU. |
// | *Esempio Hash Table* | Causa spreco di spazio nelle linee di cache durante la ricerca (si legge anche il valore prima di trovare la chiave). | Permette una ricerca più veloce, poiché le chiavi sono contigue. |

Il layout ottimale dipende interamente dai modelli di accesso ai dati.

=== Array of Structures of Arrays (AoSoA)
L'AoSoA è un layout ibrido che cerca di combinare l'efficienza della cache di AoS con i vantaggi di vettorizzazione di SoA. I dati sono raggruppati in blocchi, e all'interno di ciascun blocco, i dati sono memorizzati come SoA. Si può usare una notazione come $A["len"V]S[3]A[V]$, dove $V$ è la lunghezza degli elementi di dati (la lunghezza del vettore hardware). Variando $V$ per adattarsi alla lunghezza del vettore hardware o alla dimensione del gruppo di lavoro della GPU, si crea un'astrazione dei dati portatile. Se $V=1$ o $V="len"$, si recuperano rispettivamente le strutture AoS e SoA.

=== Data-Oriented Design
Questo stile di programmazione si concentra sul miglior layout dei dati per la CPU e la cache. Alcuni principi includono:
- Operare su array, non su singoli elementi, per evitare l'overhead di chiamata e i miss della cache.
- Preferire gli array rispetto alle strutture per un migliore utilizzo della cache.
- Utilizzare liste collegate basate su array contigui per evitare la scarsa località dei dati delle implementazioni standard di liste collegate.
- Evitare la riallocazione non diretta della memoria.

=== Array Multidimensionali e Allocazione Contigua
Le matrici in C sono memorizzate in ordine row major (la riga è contigua in memoria), mentre in Fortran sono column major (la colonna è contigua) [21, 43-45]. I programmatori devono ricordare quale indice deve essere nel ciclo interno per sfruttare la memoria contigua in ogni situazione.

In C, l'allocazione dinamica convenzionale di un array 2D utilizza $1 + j_{max}$ allocazioni, che possono provenire da diverse posizioni nell'heap, portando a una mancanza di località spaziale. L'uso di array non contigui è limitato (ad esempio, è impossibile passarli a Fortran o a una GPU in blocco).

Esiste un modo per allocare un blocco contiguo di memoria per array C, combinando le allocazioni in una singola chiamata. Questo può migliorare l'allocazione della memoria e l'efficienza della cache. Un'alternativa è linearizzare semplicemente le coordinate 2D a 1D, saltando l'allocazione del puntatore di riga.

== Comunicazioni

La necessità di comunicazione tra task dipende dal problema. Problemi che possono essere eseguiti in parallelo con virtualmente nessuna necessità di condivisione dati sono chiamati *imbarazzantemente paralleli* (embarrassingly parallel). La maggior parte delle applicazioni parallele, tuttavia, richiede la condivisione di dati.

=== Overhead di Comunicazione
La comunicazione inter-task comporta quasi sempre overhead, utilizzando cicli macchina e risorse che potrebbero essere impiegate per il calcolo. Spesso richiede sincronizzazione, che può risultare in task che passano tempo ad aspettare.

=== Latenza vs. Larghezza di Banda
- *Latenza (Latency)* è il tempo necessario per inviare un messaggio minimo (0 byte) da A a B.
- *Larghezza di banda (Bandwidth)* è la quantità di dati che può essere comunicata per unità di tempo.

L'invio di molti piccoli messaggi può far sì che la latenza domini l'overhead di comunicazione; spesso è più efficiente accorpare messaggi piccoli in uno più grande.

=== Comunicazioni Sincrone vs. Asincrone
- *Comunicazioni Sincrone (Blocking):* Richiedono una sorta di handshaking tra i task e spesso sono definite blocking, poiché altro lavoro deve attendere il completamento della comunicazione.
- *Comunicazioni Asincrone (Non-blocking):* Permettono ai task di trasferire dati indipendentemente l'uno dall'altro. Il beneficio maggiore è la possibilità di intercalare calcolo e comunicazione.

== Safety e Liveness

La correttezza dei programmi paralleli è più complessa di quella dei programmi sequenziali, data la natura asincrona dei computer moderni.

- *Proprietà di Sicurezza (Safety Properties):* "Niente di male accade mai".
  - Esempio: *Mutua Esclusione* (due processi non usano mai una risorsa comune nello stesso momento).
- *Proprietà di Vivacità (Liveness Properties):* "Qualcosa di buono accade eventualmente".
  - Esempio: *No Deadlock* (se uno o entrambi i processi vogliono la risorsa, uno la ottiene).
  - *Starvation Freedom (Assenza di Inedia):* Se un processo vuole la risorsa, la otterrà eventualmente.
  - *Fault-tolerance:* Cosa succede se un processo in attesa non riesce a ottenere la risorsa perché il processo che la controlla fallisce (problema di attesa implicito nella mutua esclusione).

#heading("Proprietà di Comunicazione (per la Correttezza", outlined: false, depth: 3)
La comunicazione può essere:
- *Transient (Transitoria):* Richiede la partecipazione simultanea di entrambe le parti (sincrona, come parlare).
- *Persistent (Persistente):* Permette al mittente e al destinatario di partecipare in momenti diversi (asincrona, come scrivere). Un protocollo capace di mutua esclusione richiede comunicazione persistente.

== Proprietà degli Algoritmi Paralleli
Proprietà importanti per gli algoritmi paralleli sono:
- *Locality (Località):*
  - Per la cache: Mantiene i valori che verranno usati insieme vicini.
  - Per le operazioni: Evita di operare su tutti i dati quando non sono necessari.
- *Asynchronous (Asincronicità):* Evita il coordinamento tra thread che può causare sincronizzazione.
- *Fewer conditionals (Meno condizionali):* Evita i problemi di thread divergence su alcune architetture (es. GPU).
- *Reproducibility (Riproducibilità):* Spesso tecniche altamente parallele violano la mancanza di associatività dell'aritmetica a precisione finita.
- *Higher arithmetic intensity (Maggiore intensità aritmetica):* Algoritmi che aumentano l'intensità aritmetica sfruttano meglio il parallelismo, come le operazioni vettoriali.