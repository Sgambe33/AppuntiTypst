#import "../../../dvd.typ": *

= Progettazione concettuale
<progettazione-concettuale>

#figure(image("images/image.png"))

La progettazione concettuale comprende al suo interno le seguenti attività:

- acquisizione dei requisiti (in linguaggio naturale);
- analisi dei requisiti;
- costruzione dello schema concettuale;
- costruzione del glossario.

L'acquisizione dei requisiti è un'attività difficile e non sempre standardizzabile. Essi provengono da fonti come:

- utenti e committenti;
- documentazione esistente;
- modulistica.

Quando si produce la documentazione dei requisiti si deve evitare di usare termini troppo generici o troppo specifici.

Inoltre è bene costruire un *glossario dei termini*: esso contiene una breve descrizione di ogni termine e dei suoi sinonimi.

#figure(image("images/image 1.png"))

Bisogna anche strutturare i requisiti in *gruppi di frasi omogenee*.

#figure(image("images/image 2.png"))

#figure(image("images/image 3.png"))

#figure(image("images/image 4.png"))

== Dai requisiti allo schema concettuale

Come si sceglie il costrutto del modello ER che va utilizzato per rappresentare un concetto nelle specifiche?

- *Entità*: ha proprietà significative e descrive oggetti con esistenza autonoma.
- *Attributo*: è semplice e non ha proprietà.
- *Relazione o relationship*: correla due o più concetti.
- *Generalizzazione*: è un caso particolare di un altro concetto.

Esistono alcuni pattern nella progettazione concettuale che è comodo conoscere:

#figure(
  image("images/image 5.png"),
  caption: "Reificazione di attributo di identità",
)

#figure(
  image("images/image 6.png"),
  caption: "Part of",
)

#figure(
  image("images/image 7.png"),
  caption: "Instance of",
)

eccetera.

== Strategie di progetto

- *Strategia top-down*: raffinamenti successivi di uno schema iniziale che descrive tutte le specifiche con pochi concetti molto astratti. Via via si aumenta il dettaglio dei concetti.
- *Strategia bottom-up*: le specifiche iniziali sono suddivise in componenti via via sempre più piccole, rappresentate da semplici schemi concettuali che vengono infine integrati.

In pratica, si procede con una strategia mista: si individuano i concetti principali e si realizza uno schema scheletro; sulla base di questo si può decomporre, poi raffinare, espandere e integrare.

#figure(image("images/image 8.png"))

#figure(image("images/image 9.png"))

#figure(image("images/image 10.png"))

#figure(image("images/image 11.png"))

#figure(image("images/image 12.png"))

#figure(image("images/image 13.png"))

#figure(image("images/image 14.png"))
