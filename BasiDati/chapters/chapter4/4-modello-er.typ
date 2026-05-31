#import "../../../dvd.typ": *

= Modello ER
<modello-er>

== Modelli di dati

- *Modelli logici*: sono usati dai DBMS esistenti per l'organizzazione dei dati (relazionali, reticolari, a oggetti, ecc.).
- *Modelli concettuali*: permettono di rappresentare i dati in modo indipendente da ogni sistema, descrivendo i concetti del mondo reale (Entity-Relationship).

I modelli concettuali ci permettono di rappresentare, anche graficamente, le classi di oggetti di interesse e le loro correlazioni.

#figure(image("images/image.png"))

== Modello ER

I costrutti del modello ER sono i seguenti:

- *Entità*: un'entità è una classe di oggetti (fatti, persone, cose) della realtà con proprietà. Un'istanza (o occorrenza) di entità è un elemento della classe. Ogni entità possiede un nome (#strong[#emph[SINGOLARE]]) che la identifica univocamente nello schema.

  #figure(
    image("images/image 1.png"),
    caption: "Rappresentazione grafica delle entità.",
  )

- *Relationship*: è un legame logico fra due o più entità, rilevante nell'applicazione di interesse. Si chiama anche relazione, correlazione o associazione. Ogni relationship ha un nome che la identifica univocamente (#strong[#emph[SINGOLARE, SOSTANTIVI INVECE DI VERBI SE POSSIBILE]]).

  #figure(image("images/image 2.png"))

  Una occorrenza di una relationship binaria è una coppia di occorrenze di entità, una per ciascuna entità coinvolta. Per una relationship n-aria è una n-upla di occorrenze di entità, una per ogni entità coinvolta. Non ci possono essere occorrenze ripetute: una relationship è un sottoinsieme del prodotto cartesiano.

- *Attributo*: proprietà elementare di un'entità o di una relationship. Associa a ogni occorrenza di entità o relationship un valore appartenente a un insieme detto dominio dell'attributo.

  #figure(image("images/image 3.png"))

- *Cardinalità*: coppia di valori associati a ogni entità che partecipa a una relationship. Specifica il numero minimo e massimo di occorrenze della relationship a cui ciascuna occorrenza di un'entità può partecipare:
  - 0: partecipazione opzionale;
  - 1: partecipazione obbligatoria;
  - N: partecipazione massima senza limite.

  #figure(image("images/image 4.png"))

  In base alla cardinalità massima, le relationship si dividono in:

  - uno a uno;

    #figure(image("images/image 5.png"))

  - uno a molti;

    #figure(image("images/image 6.png"))

  - molti a molti.

    #figure(image("images/image 7.png"))

  È possibile associare cardinalità anche agli attributi, con due scopi:

  - indicare opzionalità;
  - indicare attributi multivalore.

  #figure(image("images/image 8.png"))

- *Identificatore*: strumento per identificare univocamente le occorrenze di un'entità. È formato da:
  - attributi dell'entità, e in questo caso si parla di *identificatore interno*;

    #figure(image("images/image 9.png"))

  - attributi ed entità esterne attraverso relationship, e in questo caso si parla di *identificatore esterno*.

    #figure(image("images/image 10.png"))

  #observation()[
    Ogni entità deve possedere almeno un identificatore, ma può possederne anche più di uno. Una identificazione esterna è possibile solo attraverso una relationship a cui l'entità da identificare partecipa con cardinalità $(1,1)$.
  ]

- *Generalizzazione*: mette in relazione una o più entità $E_1, E_2, ..., E_n$ con un'entità $E$ che le comprende come casi particolari. $E$ si dice *generalizzazione* di $E_1, E_2, ..., E_n$, mentre queste ultime sono specializzazioni di $E$.

  #figure(image("images/image 11.png"))

  *Ereditarietà*: tutte le proprietà dell'entità genitore (attributi, relationship, generalizzazioni) vengono ereditate dalle entità figlie e non rappresentate esplicitamente.

  Le generalizzazioni possono essere di due tipi:

  - *Totale*: se ogni occorrenza dell'entità genitore è occorrenza di almeno una delle entità figlie; altrimenti è *parziale*.
  - *Esclusiva*: se ogni occorrenza dell'entità genitore è occorrenza al più di una delle entità figlie; altrimenti è *sovrapposta*.

#figure(
  image("images/image 12.png"),
  caption: "Parziale e sovrapposta",
)

#figure(
  image("images/image 13.png"),
  caption: "Parziale ed esclusiva",
)

#figure(
  image("images/image 14.png"),
  caption: "Totale ed esclusiva",
)
