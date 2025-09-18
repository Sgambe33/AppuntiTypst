#import "../../../dvd.typ": *
// B031290 B241 B340

= Introduzione

== Parallelismo vs Concorrenza

#definition()[
  I sistema si definisce *concorrente* se supporta l'esecuzione di due più azioni nello steosso momento

]

#definition()[
  Un sistema si definisce *parallelo* se esegue duo e più azioni nello stesso momneot
]

Concorrenza -> due thread in esecuzione ma alla fine nella CPU la loro esecuzione si alterna. (Parallelismo simulatos)
Parallelismo -> due thread sono in esecuzione contemporaneamente ma su core diversi. (Parallelismo vero)
Un programma concorrente diventa parallelo se ci sono abbastanza core per eseguire tutti i sui thread.
Concorrenza è relativa alla struttura del programma mentre il Parallelismo riguarda l'esecuzione.

Normalmente nel parallelismo non ci snono thread dedicati al controllo. Le operazioni avvengono indipendentemente.

== Algoritmi sequenziali

La maggior parte degli algoritmi sono sequenziali. Hanno funzionato fino ad ora perché le CPU miglioravano la propria velocità. Infatti molte strutture dati usati da linguaggi come c++ o java non sono fatte per essere usate in programmi parallelismo.


Per ottenere codice parallelizabile abbiamo bisogna prima di codice concorrente

Come nella concorrente c'è bisogno di sincronizzazione per eliminare le race conditions. Sono disponibili diversi strumenti come:
- Lock
- Semaphore
- Mutex

Questi sono strumenti che introduconon elevato overhead o sono costosi.
L'hardware moderno offre istruzioni "atomiche".
Oppure si usa dati read-only così che non si debba preoccuparci di race condition.
Oppure thread-local storage (copia dei su cui operare dati nei thread)

== motivazioni

Le motivazioni del parallelismo
- velocità: fare la stessa quantità di lavoro ma in meno tempo
- dimensione: fare più lavoro nella stessa quantità di tempo

#figure(image("images/2025-09-16-17-13-34.png"))

La velocità delle CPU non sta incrementando con le nuove generazioni.

#figure(image("images/2025-09-16-17-15-52.png"))

per utilizzare completamente il potenziale delle CPU moderne c'è bisogno di usare i core.

== Programmazione DIstribuita vs Parallela
Parallel computing: provide performance. 
• In terms of processing power or memory; 
• To solve a single problem; 
• Typically: frequent, reliable interaction, fine grained, low overhead, short execution time.  
Distributed computing: provide convenience. 
• In terms of availability, reliability and accessibility from many 
different locations;. Se un pezzo si rompe c'è ridondanza.
• Typically: interactions infrequent, with heavier weight and 
assumed to be unreliable, coarse grained, much overhead and 
long uptime.