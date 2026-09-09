#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()

= Modello ER <modello-er> #index-main("Modello ER")

== Modelli di dati

- *Modelli logici*: sono usati dai DBMS esistenti per l'organizzazione dei dati (relazionali, reticolari, a oggetti, ecc.).
- *Modelli concettuali*#index("Modello di dati", "Concettuale"): permettono di rappresentare i dati in modo indipendente da ogni sistema, descrivendo i concetti del mondo reale (Entity-Relationship).

I modelli concettuali ci permettono di rappresentare, anche graficamente, le classi di oggetti di interesse e le loro correlazioni.

#figure(image("images/image.png", width: 70%))

== Modello ER

I costrutti del modello ER sono i seguenti:

- *Entità*#index-main("Entità"): un'entità è una classe di oggetti (fatti, persone, cose) della realtà con proprietà. Un'istanza (o occorrenza) di entità#index("Occorrenza di entità") è un elemento della classe. Ogni entità possiede un nome (#strong[#emph[SINGOLARE]]) che la identifica univocamente nello schema.

  #figure(
    image("images/image 1.png", width: 40%),
    caption: "Rappresentazione grafica delle entità.",
  )

- *Relationship*#index-main("Relationship (associazione)"): è un legame logico fra due o più entità, rilevante nell'applicazione di interesse. Si chiama anche relazione, correlazione o associazione. Ogni relationship ha un nome che la identifica univocamente (#strong[#emph[SINGOLARE, SOSTANTIVI INVECE DI VERBI SE POSSIBILE]]).

  #figure(image("images/image 2.png", width: 40%))

  Una occorrenza di una relationship binaria#index("Relationship (associazione)", "Binaria") è una coppia di occorrenze di entità, una per ciascuna entità coinvolta. Per una relationship n-aria#index("Relationship (associazione)", "N-aria") è una n-upla di occorrenze di entità, una per ogni entità coinvolta. Non ci possono essere occorrenze ripetute: una relationship è un sottoinsieme del prodotto cartesiano.

- *Attributo*#index("Attributo", "nel modello ER"): proprietà elementare di un'entità o di una relationship. Associa a ogni occorrenza di entità o relationship un valore appartenente a un insieme detto dominio dell'attributo.

  #figure(image("images/image 3.png", width: 40%))

- *Cardinalità*#index-main("Cardinalità", "nel modello ER"): coppia di valori associati a ogni entità che partecipa a una relationship. Specifica il numero minimo e massimo di occorrenze della relationship a cui ciascuna occorrenza di un'entità può partecipare:
  - 0: partecipazione opzionale;
  - 1: partecipazione obbligatoria;
  - N: partecipazione massima senza limite.

  #figure(image("images/image 4.png", width: 40%))

  In base alla cardinalità massima, le relationship si dividono in:

  - uno a uno#index("Relationship (associazione)", "Uno a uno (1:1)");

    #figure(image("images/image 5.png", width: 40%))

  - uno a molti#index("Relationship (associazione)", "Uno a molti (1:N)");

    #figure(image("images/image 6.png", width: 40%))

  - molti a molti#index("Relationship (associazione)", "Molti a molti (N:N)").

    #figure(image("images/image 7.png", width: 40%))

  È possibile associare cardinalità anche agli attributi, con due scopi:

  - indicare opzionalità;
  - indicare attributi multivalore#index("Attributo", "Multivalore").

  #figure(image("images/image 8.png", width: 40%))

- *Identificatore*#index-main("Identificatore"): strumento per identificare univocamente le occorrenze di un'entità. È formato da:
  - attributi dell'entità, e in questo caso si parla di *identificatore interno*#index-main("Identificatore", "Interno");

    #figure(image("images/image 9.png", width: 40%))

  - attributi ed entità esterne attraverso relationship, e in questo caso si parla di *identificatore esterno*#index-main("Identificatore", "Esterno").

    #figure(image("images/image 10.png", width: 40%))

  #observation()[
    Ogni entità deve possedere almeno un identificatore, ma può possederne anche più di uno. Una identificazione esterna è possibile solo attraverso una relationship a cui l'entità da identificare partecipa con cardinalità $(1,1)$.
  ]

- *Generalizzazione*#index-main("Generalizzazione"): mette in relazione una o più entità $E_1, E_2, ..., E_n$ con un'entità $E$ che le comprende come casi particolari. $E$ si dice *generalizzazione* di $E_1, E_2, ..., E_n$, mentre queste ultime sono specializzazioni#index("Specializzazione") di $E$.

  #figure(image("images/image 11.png", width: 40%))

  *Ereditarietà*#index-main("Ereditarietà"): tutte le proprietà dell'entità genitore (attributi, relationship, generalizzazioni) vengono ereditate dalle entità figlie e non rappresentate esplicitamente.

  Le generalizzazioni possono essere di due tipi:

  - *Totale*#index("Generalizzazione", "Totale"): se ogni occorrenza dell'entità genitore è occorrenza di almeno una delle entità figlie; altrimenti è *parziale*#index("Generalizzazione", "Parziale").
  - *Esclusiva*#index("Generalizzazione", "Esclusiva"): se ogni occorrenza dell'entità genitore è occorrenza al più di una delle entità figlie; altrimenti è *sovrapposta*#index("Generalizzazione", "Sovrapposta").

#figure(
  image("images/image 12.png", width: 40%),
  caption: "Parziale e sovrapposta",
)

#figure(
  image("images/image 13.png", width: 40%),
  caption: "Parziale ed esclusiva",
)

#figure(
  image("images/image 14.png", width: 40%),
  caption: "Totale ed esclusiva",
)
