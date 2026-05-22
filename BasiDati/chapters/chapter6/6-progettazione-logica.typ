#import "../../../dvd.typ": *

= Progettazione logica
<progettazione-logica>

Lo scopo della progettazione logica è tradurre lo schema concettuale in uno schema logico che rappresenti gli stessi dati in maniera corretta ed efficiente.

#figure(image("images/image.png"))

La ristrutturazione dello schema ER è necessaria per semplificare la traduzione e ottimizzare le prestazioni. Gli *indicatori* delle prestazioni sono:

- *Spazio*: numero di occorrenze previste per le entità e le relazioni.
- *Tempo*: numero di occorrenze visitate durante un'operazione.

== Fasi della ristrutturazione

1. *Analisi delle ridondanze*

   Sono informazioni significative ma ricavabili da altre già presenti:

   1. Attributi derivabili

      #figure(image("images/image 1.png"))

      #figure(image("images/image 2.png"))

   2. Relationship derivabili

      #figure(image("images/image 3.png"))

2. *Eliminazione delle generalizzazioni*

   Il modello relazionale non può rappresentare direttamente le generalizzazioni, che quindi devono essere trasformate in entità e relationship.

   #figure(image("images/image 4.png"))

   #figure(
     image("images/image 5.png"),
     caption: "Accorpamento figlie -> genitore. L'attributo tipo serve a distinguere il tipo di occorrenza di E0.",
   )

   #figure(
     image("images/image 6.png"),
     caption: "Accorpamento genitore -> figlie. Conviene se gli accessi alle figlie sono distinti e la generalizzazione è totale.",
   )

   #figure(
     image("images/image 7.png"),
     caption: "Generalizzazione con associazioni. Devono essere aggiunti vincoli: ogni occorrenza di E0 appartiene a un'occorrenza di RG1 o di RG2. Conviene quando gli accessi alle figlie sono separati dagli accessi al padre.",
   )

   Esistono anche soluzioni ibride.

3. *Partizionamento/accorpamento di entità e relationship*

   Sono effettuati per rendere più efficienti le operazioni. Si possono ridurre gli accessi:

   1. separando gli attributi di un concetto che vengono acceduti separatamente;
   2. raggruppando attributi di concetti diversi acceduti insieme.

   Ecco alcuni esempi:

   #figure(
     image("images/image 8.png"),
     caption: "Partizionamento verticale di entità",
   )

   #figure(
     image("images/image 9.png"),
     caption: "Eliminazione attributi multivalore",
   )

   #figure(
     image("images/image 10.png"),
     caption: "Accorpamento entità",
   )

   #figure(
     image("images/image 11.png"),
     caption: "Partizionamento associazione",
   )

   #figure(
     image("images/image 12.png"),
     caption: "Partizionamento verticale di entità",
   )

   #figure(
     image("images/image 13.png"),
     caption: "Eliminazione attributi multivalore",
   )

   #figure(
     image("images/image 14.png"),
     caption: "Accorpamento entità",
   )

   #figure(
     image("images/image 15.png"),
     caption: "Partizionamento associazione",
   )

4. *Scelta degli identificatori primari*

   Operazione indispensabile per la traduzione nel modello relazionale. I criteri principali sono:

   - assenza di opzionalità: vanno esclusi attributi con valori nulli;
   - semplicità: questo garantisce che gli indici siano di dimensioni ridotte;
   - utilizzo nelle operazioni più frequenti o importanti.

   Se nessuno degli identificatori soddisfa questi requisiti, si introducono nuovi attributi (codici) contenenti valori speciali generati appositamente per questo scopo, come gli autoincrement.

   #figure(image("images/image 16.png"))

   #figure(image("images/image 17.png"))

   #figure(image("images/image 18.png"))

== Esempio

#figure(image("images/image 19.png"))
