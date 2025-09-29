#import "../../../dvd.typ": *
#pagebreak()
= Design models

== Decomposizione in task

#definition()[
  Con questo approccio il problema viene diviso in parti (o task), ognuna da fare in modo separato, riducendo il carico. Ognuna di questa task, per essere eseguita, viene assegnata ad un thread.
]

Si possono assegnare queste task ai thread in due modi:
- #text(red)[Static scheduling]: La divisione delle task è saputa fin dall'inizio e non cambia la durata della computazione
- #text(red)[Dynamic scheduling]: L'assegnazione delle task ai thread viene effettuata durante la computazione del problema, cercando di bilanciare il carico in modo equo.

== Criteri di decomposizione

?

Due decomposizioni comuni sono:
- Chiamate di funzione
- Iterazioni distinte dei cicli

E' più semplice partire con troppe task e unirle successivamente, che partire con troppe poche task e doverle divere ulteriormente dopo.
