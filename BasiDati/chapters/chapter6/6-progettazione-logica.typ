#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()

= Progettazione logica <progettazione-logica> #index-main("Progettazione", "Logica")

Lo scopo della progettazione logica è tradurre lo schema concettuale in uno schema logico che rappresenti gli stessi dati in maniera corretta ed efficiente.

#figure(image("images/image.png", width: 60%))

La ristrutturazione dello schema ER#index-main("Ristrutturazione dello schema ER") è necessaria per semplificare la traduzione e ottimizzare le prestazioni. Gli *indicatori* delle prestazioni#index-main("Indicatori di prestazione") sono:

- *Spazio*#index("Indicatori di prestazione", "Spazio"): numero di occorrenze previste per le entità e le relazioni.
- *Tempo*#index("Indicatori di prestazione", "Tempo"): numero di occorrenze visitate durante un'operazione.

== Fasi della ristrutturazione

1. *Analisi delle ridondanze*#index-main("Analisi delle ridondanze")

  Sono informazioni significative ma ricavabili da altre già presenti:

  1. Attributi derivabili#index("Ridondanza", "Attributi derivabili")

    #figure(image("images/image 1.png", width: 60%))

    #figure(image("images/image 2.png", width: 60%))

  2. Relationship derivabili#index("Ridondanza", "Relationship derivabili")

    #figure(image("images/image 3.png", width: 60%))

2. *Eliminazione delle generalizzazioni*#index-main("Eliminazione delle generalizzazioni")

  Il modello relazionale non può rappresentare direttamente le generalizzazioni, che quindi devono essere trasformate in entità e relationship.

  #figure(image("images/image 4.png", width: 60%))

  #figure(
    image("images/image 5.png", width: 60%),
    caption: [Accorpamento figlie -> genitore#index("Eliminazione delle generalizzazioni", "Accorpamento verso genitore"). L'attributo tipo serve a distinguere il tipo di occorrenza di E0.],
  )

  #figure(
    image("images/image 6.png", width: 60%),
    caption: [Accorpamento genitore -> figlie#index("Eliminazione delle generalizzazioni", "Accorpamento verso figlie"). Conviene se gli accessi alle figlie sono distinti e la generalizzazione è totale.],
  )

  #figure(
    image("images/image 7.png", width: 60%),
    caption: [Generalizzazione con associazioni#index("Eliminazione delle generalizzazioni", "Con relazioni"). Devono essere aggiunti vincoli: ogni occorrenza di E0 appartiene a un'occorrenza di RG1 o di RG2. Conviene quando gli accessi alle figlie sono separati dagli accessi al padre.],
  )

  Esistono anche soluzioni ibride.

3. *Partizionamento/accorpamento di entità e relationship*#index-main("Partizionamento")

  Sono effettuati per rendere più efficienti le operazioni. Si possono ridurre gli accessi:

  1. separando gli attributi di un concetto che vengono acceduti separatamente;
  2. raggruppando attributi di concetti diversi acceduti insieme.

  Ecco alcuni esempi:

  #figure(
    image("images/image 8.png", width: 40%),
    caption: [Partizionamento verticale di entità#index("Partizionamento", "Verticale")],
  )

  #figure(
    image("images/image 9.png", width: 40%),
    caption: [Eliminazione attributi multivalore#index("Eliminazione attributi multivalore")],
  )

  #figure(
    image("images/image 10.png", width: 40%),
    caption: [Accorpamento entità#index("Accorpamento di entità")],
  )

  #figure(
    image("images/image 11.png", width: 40%),
    caption: [Partizionamento associazione],
  )

  #figure(
    image("images/image 12.png", width: 40%),
    caption: [Partizionamento verticale di entità],
  )

  #figure(
    image("images/image 13.png", width: 40%),
    caption: [Eliminazione attributi multivalore],
  )

  #figure(
    image("images/image 14.png", width: 40%),
    caption: [Accorpamento entità],
  )

  #figure(
    image("images/image 15.png", width: 40%),
    caption: [Partizionamento associazione],
  )

4. *Scelta degli identificatori primari*#index-main("Scelta del codice primario")

  Operazione indispensabile per la traduzione nel modello relazionale. I criteri principali sono:

  - assenza di opzionalità: vanno esclusi attributi con valori nulli;
  - semplicità: questo garantisce che gli indici siano di dimensioni ridotte;
  - utilizzo nelle operazioni più frequenti o importanti.

  Se nessuno degli identificatori soddisfa questi requisiti, si introducono nuovi attributi (codici) contenenti valori speciali generati appositamente per questo scopo, come gli autoincrement.

  #figure(image("images/image 16.png"))

  #figure(image("images/image 17.png"))

  #figure(image("images/image 18.png"))

#example()[
  #figure(image("images/image 19.png"))
]

