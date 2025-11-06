= Modello ER
<modello-er>
\=== Modelli di dati

- Modelli logici: sono usati dai DBMS esistenti per l'organizzazione dei
  dati (relazionali, reticolare, a oggetti etc)
- Modelli concettuali: permettono di rappresentare i dati in modo
  indipendente da ogni sistema descrivendo i concetti del mondo reale
  (Entity-Relationship).

I m. concettuali ci permettono di rappresentare le classi di oggetti di
interesse e loro correlazioni anche graficamente.

#figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image.png"),
  caption: [
    image.png
  ]
)

\=== Modello ER

I costrutti del modello ER sono i seguenti:

- Entità:

  Un'entità è una classe di oggetti (fatti persone cose) della realtà
  con proprietà. Un'istanza (o occorrenza) di entità è un elemento della
  classe (il fatto, la persona, la cosa). Ogni entità possiede un nome
  (#strong[#emph[SINGOLARE]]) che la identifica univocamente dello
  schema.

  #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 1.png"),
    caption: [
      Rappresentazione grafica delle entità.
    ]
  )

  Rappresentazione grafica delle entità.

- Relationship: E' un legame logico fra due o più entità, rilevante
  nell'applicazione di interesse. Si chiama anche relazione,
  correlazione o associazione. Ogni relationship ha un nome che la
  identifica univocamente (#strong[#emph[SINGOLARE, SOSTANTIVI INVECE DI
  VERBI SE POSSIBILE]])

  #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 2.png"),
    caption: [
      image.png
    ]
  )

  Una occorrenza di una relationship binaria è una coppia di occorrenze
  di entità, una per ciascuna entità coinvolta. Per una relationship
  n-aria è una n-upla di occorrenze di entità, una per ogni entità
  coinvolta. Non ci possono essere occorrenze ripetute (è sottoinsieme
  del prodotto cartesiano).

- Attributo: Proprietà elementari di un'entità o di una relationship.
  Associa ad ogni occorrenza di ent. o rel. un valore appartenente a un
  insieme detto dominio dell'attributo.

  #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 3.png"),
    caption: [
      image.png
    ]
  )

- Cardinalità

  - Di relationship: coppia di valori associati ad ogni entità in
    partecipazione alla relation. Specificano il numero min e max di
    occorrenze delle relationship cui ciascuna occorrenza di una entità
    può partecipare:

    - 0: partecipazione opzionale
    - 1: partecipazione obbligatoria
    - N: partecipazione massima/senza limite

    #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 4.png"),
      caption: [
        image.png
      ]
    )

    In base alla cardinalità massima delle relation., esse si dividono
    in:

    - uno a uno

      #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 5.png"),
        caption: [
          image.png
        ]
      )

    - uno a molti

      #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 6.png"),
        caption: [
          image.png
        ]
      )

    - molti a molti

      #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 7.png"),
        caption: [
          image.png
        ]
      )

  - Di attributo: è possibile associare delle cardinalità anche agli
    attributi con due scopi:

    - indicare opzionalità
    - indicare attributi multivalore

    #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 8.png"),
      caption: [
        image.png
      ]
    )

- Identificatore Strumento per identificare univocamente le occorrenze
  di un'entità. E' formato da

  - attributi dell'entità → #strong[IDENTIFICATORE INTERNO]

    #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 9.png"),
      caption: [
        image.png
      ]
    )

  - (attributi +) entità esterne attraverso relationship →
    #strong[IDENTIFICATOR ESTERNO]

    #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 10.png"),
      caption: [
        image.png
      ]
    )

  💡

  Ogni entità deve possedere almeno un identificatore, ma anche più. Una
  identificazione esterna è possibile solo attraverso una relationship a
  cui l'entità da identificare partecipa con cardinalità (1,1).

- Generalizzazione Mette in relazione una o più entità
  $E_1 \, E_2 \, . . . \, E_n$ con una entità $E$ che cle comprende come
  casi particolari. $E$ si dice #strong[GENERALIZZAZIONE] di
  $E_1 \, E_2 \, . . . \, E_n$ mentre quest'ultime sono specializzazioni
  di $E$.

  #figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 11.png"),
    caption: [
      image.png
    ]
  )

  #strong[EREDITARIETA']: tutte le proprietà dell'entità genitore
  (attributi, relation., generalizzazioni) vengono ereditate dalle
  entità figlie e non rappresentate esplicitamente.

  Le generalizzazioni possono essere di due tipi:

  - #strong[TOTALE:] se ogni occorrenza dell'entità genitore è
    occorrenza di almeno una delle entità figlie, altrimenti è
    #strong[PARZIALE]
  - #strong[ESCLUSIVA:] se ogni occorrenza dell'entità genitore è
    occorrenza al più di una delle entità figlie, altrimenti è
    #strong[SOVRAPPOSTA]

#figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 12.png"),
  caption: [
    Parziale e sovrapposta
  ]
)

Parziale e sovrapposta

#figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 13.png"),
  caption: [
    Parziale ed esclusiva
  ]
)

Parziale ed esclusiva

#figure(image("Modello ER 17efd949e1178013ab83fd8b56ebb58c/image 14.png"),
  caption: [
    Totale ed esclusiva
  ]
)

Totale ed esclusiva
