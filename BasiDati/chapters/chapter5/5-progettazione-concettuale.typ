#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()

= Progettazione concettuale <progettazione-concettuale> #index-main("Progettazione", "Concettuale")

#figure(image("images/image.png", width: 60%))

La progettazione concettuale comprende al suo interno le seguenti attività:

- acquisizione dei requisiti#index-main("Requisiti", "Acquisizione") (in linguaggio naturale);
- analisi dei requisiti#index-main("Requisiti", "Analisi");
- costruzione dello schema concettuale;
- costruzione del glossario.

L'acquisizione dei requisiti è un'attività difficile e non sempre standardizzabile. Essi provengono da fonti come:

- utenti e committenti;
- documentazione esistente;
- modulistica.

Quando si produce la documentazione dei requisiti si deve evitare di usare termini troppo generici o troppo specifici.

Inoltre è bene costruire un *glossario dei termini*#index-main("Glossario dei termini"): esso contiene una breve descrizione di ogni termine e dei suoi sinonimi.

#figure(
  caption: [Glossario dei termini],
  table(
    columns: (1.2fr, 2.6fr, 1.1fr, 1.2fr),
    fill: (col, row) => if row == 0 { rgb("#00bcd4").lighten(40%) } else if calc.even(row) { rgb("#f8f9fa") } else { white },
    stroke: 0.5pt + luma(120),
    align: (col, row) => if row == 0 { center + horizon } else { left + horizon },
    table.header(
      [*Termine*], [*Descrizione*], [*Sinonimi*], [*Collegamenti*],
    ),
    [Partecipante], [Persona che partecipa ai corsi], [Studente], [Corso, Società],
    [Docente], [Docente dei corsi. Può essere esterno.], [Insegnante], [Corso],
    [Corso], [Corso organizzato dalla società. Può avere più edizioni], [Seminario], [Docente],
    [Società], [Ente presso cui i partecipanti lavorano o hanno lavorato.], [Posti], [Partecipante],
  ),
)

Bisogna anche strutturare i requisiti in *gruppi di frasi omogenee*:

#example("Esempio di specifica dei requisiti")[
  - *Frasi di carattere generale*: si vuole realizzare una base di dati per una società che eroga corsi, di cui vogliamo rappresentare i dati dei partecipanti ai corsi e dei docenti.

  - *Frasi relative ai partecipanti*: per i #underline[partecipanti] (circa 5000), identificati da un codice, rappresentiamo il codice fiscale, il cognome, l'età, il sesso, la #underline[città] di nascita, i nomi dei loro attuali datori di lavoro e #underline[di quelli precedenti] (#underline[insieme alle date di inizio e fine rapporto]), le #underline[edizioni dei corsi] che stanno attualmente frequentando e quelli che hanno frequentato nel passato, con la relativa votazione finale in decimi.

  - *Frasi relative ai datori di lavoro*: relativamente ai datori di lavoro presenti e passati dei partecipanti, rappresentiamo il nome, l'indirizzo e il numero di telefono.

  - *Frasi relative ai corsi*: per i corsi (circa 200), rappresentiamo il titolo e il codice, le varie edizioni con date di inizio e fine e, per ogni edizione, rappresentiamo il numero di partecipanti e il #underline[giorno della settimana], le aule e le ore dove sono tenute le lezioni.

  - *Frasi relative a tipi specifici di partecipanti*: per i partecipanti che sono liberi professionisti, rappresentiamo l'area di interesse e, se lo possiedono, il #underline[titolo professionale]. Per i partecipanti che sono dipendenti, rappresentiamo invece il loro livello e la posizione ricoperta.

  - *Frasi relative ai docenti*: per i docenti (circa 300), rappresentiamo il cognome, l'età, la città di nascita, tutti i #underline[numeri di telefono], il #underline[titolo del corso] che insegnano, di quelli che hanno insegnato nel passato e di quelli che possono insegnare. I docenti possono essere dipendenti interni della società di formazione o collaboratori esterni.
]

== Dai requisiti allo schema concettuale

Come si sceglie il costrutto del modello ER che va utilizzato per rappresentare un concetto nelle specifiche?

- *Entità*: ha proprietà significative e descrive oggetti con esistenza autonoma.
- *Attributo*: è semplice e non ha proprietà.
- *Relazione o relationship*: correla due o più concetti.
- *Generalizzazione*: è un caso particolare di un altro concetto.

Esistono alcuni pattern nella progettazione concettuale#index-main("Pattern di progettazione concettuale") che è comodo conoscere:

#figure(
  image("images/image 5.png", width: 60%),
  caption: [Reificazione di attributo di identità #index("Pattern di progettazione concettuale", "Reificazione")],
)

#figure(
  image("images/image 6.png", width: 60%),
  caption: [Part of #index("Pattern di progettazione concettuale", "Part of")],
)

#figure(
  image("images/image 7.png", width: 60%),
  caption: [Instance of #index("Pattern di progettazione concettuale", "Instance of")],
)

eccetera.

== Strategie di progetto #index-main("Strategie di progettazione")

- *Strategia top-down*#index("Strategie di progettazione", "Top-down"): raffinamenti successivi di uno schema iniziale che descrive tutte le specifiche con pochi concetti molto astratti. Via via si aumenta il dettaglio dei concetti.
- *Strategia bottom-up*#index("Strategie di progettazione", "Bottom-up"): le specifiche iniziali sono suddivise in componenti via via sempre più piccole, rappresentate da semplici schemi concettuali che vengono infine integrati.

In pratica, si procede con una strategia mista#index("Strategie di progettazione", "Mista"): si individuano i concetti principali e si realizza uno schema scheletro; sulla base di questo si può decomporre, poi raffinare, espandere e integrare.

#figure(image("images/image 8.png", width: 60%))

#figure(image("images/image 9.png", width: 60%))

#figure(image("images/image 10.png", width: 60%))

#figure(image("images/image 11.png", width: 60%))

#figure(image("images/image 12.png", width: 60%))

#figure(image("images/image 13.png", width: 60%))

#figure(image("images/image 14.png", width: 90%))
