#import "../../../dvd.typ": *
#pagebreak()
= Design models

== Decomposizione in task

#definition()[
  In questo approccio ci si concentra sulla computazione che deve essere eseguita piuttosto che sui dati che vengono manipolati. Il problema viene diviso in parti (o task), ognuna da eseguita in modo separato, riducendo il carico. Ognuna di questa task, per essere eseguita, viene assegnata ad un thread.
]

#align(center, image("images/2025-09-29-21-22-44.png", height: 20%))

Le task vengono assegnate ai thread in due modi:
- *Static scheduling*: la divisione delle task è saputa fin dall'inizio e non cambia la durata della computazione. Le task sono assegnate all'inizio.
- *Dynamic scheduling*: l'assegnazione delle task ai thread viene effettuata durante la computazione del problema, cercando di bilanciare il carico in modo equo. Risulta utile quando il tempo di esecuzione è sconosciuto.

=== Criteri di decomposizione

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

=== Forma dei chunk

La forma di un chunk influisce direttamente sia sull'individuazione dei chunk vicini, sia sul modo in cui avviene lo scambio di dati durante le varie fasi di calcolo.

Se si riduce la dimensione complessiva del bordo di un chunk, diminuisce anche la quantità di dati da scambiare per aggiornare correttamente gli elementi locali. Allo stesso modo, se si riduce il numero di chunk che condividono un confine con quello considerato, l'operazione di scambio diventa meno complessa, sia da programmare che da eseguire.

In generale, una buona regola pratica consiste nel cercare di massimizzare il rapporto tra volume e superficie: il volume rappresenta la quantità di dati e quindi il livello di granularità delle computazioni, mentre la superficie corrisponde al bordo del chunk, cioè la parte che richiede comunicazione e scambio di dati con i vicini. Un rapporto elevato implica quindi più calcolo locale e meno comunicazione, rendendo il processo più efficiente.

#align(center, image("images/2025-09-29-21-48-12.png"))

#example("Distribuzione dei dati per gli array")[
  Si consideri un insieme di processi $P={P_1,...,P_p}$ e un array monodimensionale. Si hanno a disposizione tre metodi per suddividere l'array:
  + Distribuzione *blockwise*: si suddivide l'array di $n$ elementi in $p$ blocchi con $ceil n/p ceil.r$ elementi consecutivi ciascuno.
  + Distribuzione *cyclic*: si assegnano gli elementi ai processi seguendo il _Round Robin_ così che $v_i$ è assegnato a $P_((i-1)mod p+1)$.
  + Distribuzione *block-cyclic*: combinazione dei due precedenti.

  #align(center, image("images/2025-09-29-22-04-13.png"))

  Il primo favorisce la *località spaziale* mentre il secondo la *località temporale*.
]
