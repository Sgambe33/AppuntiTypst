= Dipendenze funzionali e forme normali <dipendenze-funzionali-e-forme-normali>
= Ridondanze e anomalie <ridondanze-e-anomalie>
#figure(image("images/image 33.png"), caption: [
  image.png
])

- Ridondanza: il valore di indirizzo \`e ripetuto in tutte le tuple che riguardano un ordine e in tutti gli ordini dello stesso fornitore;
- Anomalie di aggiornamento: se modiﬁchiamo l’indirizzo di un fornitore o la data di un ordine in una tupla, dobbiamo modiﬁcare contemporaneamente anche le altre;
- Anomalie di inserzione: non possiamo inserire le caratteristiche di un nuovo fornitore senza che gli sia stato ordinato qualcosa;
- Anomalia di cancellazione: se cancelliamo le informazioni relative all’ordine 351, cancelliamo anche le informazioni che riguardano il fornitore Bianchi.

= Dipendenze funzionali <dipendenze-funzionali>
Una dipendenza funzionale è un vincolo di integrità che lega fra loro i valori degli attributi di una relazione. Prendendo l’esempio precedente: in una istanza di ORDINE, se abbiamo due valori uguali per l’attributo fornitore, quelle due tuple hanno valori uguali anche per l’attributo indirizzo.

Ad ogni schema di relazione sono in genere associate più dipendenze funzionali (individuabili solo considerando il significato degli attributi).

💡

Dati $R (A_1 , . . . , A_n)$ e $X subset.eq { A_1 , . . . , A_n }$ e $Y subset.eq { A_1 , . . . , A_n }$ si dice che #strong[X determina funzionalmente Y] o che Y dipende funzionalmente da X e si scrive X→Y se $forall$ istanza di $r$ di $R$, $forall$ coppia di tuple $t_1$ e $t_2$ in $r$:

\$\$
t\_1\[X\]=t\_2\[X\]\\rArr t\_1\[Y\]=t\_2\[Y\]
\$\$

In ogni istanza non ci possono essere due tuple con valori uguali per X e valori diversi per Y.

- Se $Y subset.eq X$ la dipendenza è #strong[BANALE]
- Se $Y = X$ la dipendenza #strong[BANALE] si dice anche #strong[IDENTITA’]
- Esempio precedente
  - num→fornitore
  - fornitore→indirizzo
  - num→fornitore, indirizzo, data

=== Osservazioni <osservazioni>
#quote(
  block: true,
)[
  + Una dipendenza funzionale è un vincolo di integrità associato ad una relazione.
  + Ad ogni schema viene associato un insieme di dipendenze funzionali.
  + Ad ogni schema e sempre associato l’insieme delle dipendenze ovvie (anche se in genere si tralasciano perché prive di interesse pratico).
  + L’insieme delle dip. funzionali può essere determinato solo conoscendo il signiﬁcato degli attributi nel contesto che stiamo considerando
  + Una particolare tabella che verifica l’insieme dei vincoli associati allo schema (e quindi anche le dip. funz. associate) si dice corretta.
]

== Implicazione <implicazione>
💡

Dato un insieme di dipendenze funzionali F

\$\$
F \\space \\text{implica} \\space X \\rarr Y
\$\$

se ogni relazione $r$ che soddisfa F soddisfa anche X → Y. L’insieme $F^(+)$ delle dipendenze implicate da F viene detto #strong[chiusura di F]

\$\$
F^+ = \\{X \\rarr Y | F\\space \\text{implica} \\space X \\rarr Y \\}, \\space F\\subseteq F^+
\$\$

- Esempio precedente

  #emph[ORDINE (num, fornitore, indirizzo, articolo, data, quantita)] #emph[F ⊃ {num → fornitore, fornitore → indirizzo}]

  #strong[F implica num → indirizzo]

=== Assiomi di Armstrong <assiomi-di-armstrong>
💡

Dato F, la chiusura $F^(+)$ può essere calcolata applicando ripetutamente a $F$ le tre regole di inferenza dette #strong[Assiomi di Armstrong];:

- Riflessività:

  \$\$
  \\text{se} \\space Y\\subseteq X \\space \\text{allora} \\space X \\rarr Y
  \$\$

- Arricchimento:

  \$\$
  \\text{se} \\space X\\rarr Y \\space \\text{allora} \\space XZ \\rarr YZ
  \$\$

- Transitività:

  \$\$
  \\text{se} \\space X \\rarr Y \\space \\text{e} \\space Y\\rarr Z\\space \\text{allora} \\space X \\rarr Z
  \$\$

💡

Dagli assiomi di Armstrong derivano anche altre regole di inferenza:

- Unione: se \$X \\rarr A\_1, X\\rarr A\_2,...,X \\rarr A\_K\$ allora \$X\\rarr A\_1,...,A\_k\$
- Decomposizione: se \$X\\rarr A\_1,...,A\_k\$ allora \$X \\rarr A\_1, X\\rarr A\_2,...,X \\rarr A\_K\$

- Esempio precedente

  IMPIEGATO(codimp, nome, stip, progetto, data ﬁnale) Riﬂessivit\`a: {stip, progetto} ⊆ {stip, progetto} quindi

  stip, progetto → stip, progetto

  {progetto} ⊆ {stip, progetto} quindi stip, progetto → progetto Arricchimento: se vale progetto → data ﬁnale allora

  progetto, stip → data ﬁnale, stip

  Transitivit\`a: se codimp → progetto e progetto → data ﬁnale allora codimp → data ﬁnale.

=== Problemi dell’implicazione <problemi-dellimplicazione>
Un problema frequente è quello di decidere se una dipendenza funzionale appartiene a $F^(+)$. Per risolverlo possiamo usare un algoritmo che applica ripetutamente gli assiomi di Armstrong ma che ha una complessità esponenziale. (se n è il numero di attributi, $F^(+)$ contiene almeno $2^n - 1$ dip. funz. banali.

Altrimenti possiamo usare un metodo con complessità minore: per decidere se \$X \\rarr Y \\in F^+\$ si può controllare se $Y subset.eq X_F^(+)$

== Chiusura di un insieme di attributi <chiusura-di-un-insieme-di-attributi>
#figure(image("images/image 34.png"), caption: [
  image.png
])

#figure(image("images/image 35.png"), caption: [
  image.png
])

=== Calcolo di $X_F^(+)$ <calcolo-di-x_f>
#figure(image("images/image 36.png"), caption: [
  image.png
])

#figure(image("images/image 37.png"), caption: [
  image.png
])

#figure(image("images/image 38.png"), caption: [
  image.png
])

- Esempi

  #figure(image("images/image 39.png"), caption: [
    image.png
  ])

  #figure(image("images/image 40.png"), caption: [
    image.png
  ])

== Definizione di chiave con dip. funz. <definizione-di-chiave-con-dip.-funz.>
#figure(image("images/image 41.png"), caption: [
  Sottoinsieme proprio significa: sottoinsieme non coincidente
])

Sottoinsieme proprio significa: sottoinsieme non coincidente

- Esempi

  #figure(image("images/image 42.png"), caption: [
    image.png
  ])

  #figure(image("images/image 43.png"), caption: [
    image.png
  ])

  #figure(image("images/image 44.png"), caption: [
    image.png
  ])

== Equivalenze <equivalenze>
Per operare su insiemi di dipendenze fa comodo ridurli in forme minimali. Per fare ciò si introducono i concetti di equivalenza e copertura. L’equivalenza tra due schemi di relazione permette di determinare quando essi rappresentano gli stessi fatti.

#figure(image("images/image 45.png"), caption: [
  image.png
])

- Esempio

  #figure(image("images/image 46.png"), caption: [
    image.png
  ])

#figure(image("images/image 47.png"), caption: [
  image.png
])

- Esempio

  #figure(image("images/image 48.png"), caption: [
    image.png
  ])

=== Calcolo copertura ridotta <calcolo-copertura-ridotta>
#figure(image("images/image 49.png"), caption: [
  image.png
])

- Esempio

  #figure(image("images/image 50.png"), caption: [
    image.png
  ])

  #figure(image("images/image 51.png"), caption: [
    image.png
  ])

  #figure(image("images/image 52.png"), caption: [
    image.png
  ])

  #figure(image("images/image 53.png"), caption: [
    image.png
  ])

== Decomposizione di relazioni <decomposizione-di-relazioni>
Per eliminare anomalie da uno schema mal definito si cerca di decomporlo in schemi più piccoli che godono di particolari proprietà (forme normali) ma sono in qualche senso equivalenti allo schema originale. Si richiede in genere che lo schema soddisfi due condizioni indipendenti fra loro: preservi i dati e preservi le dipendenze.

#figure(image("images/image 54.png"), caption: [
  image.png
])

=== Decomposizione senza perdita <decomposizione-senza-perdita>
#figure(image("images/image 55.png"), caption: [
  image.png
])

- Esempio con perdita

  #figure(image("images/image 56.png"), caption: [
    image.png
  ])

  #figure(image("images/image 57.png"), caption: [
    image.png
  ])

#figure(image("images/image 58.png"), caption: [
  image.png
])

- Esempio senza perdita

  #figure(image("images/image 59.png"), caption: [
    image.png
  ])

== Proiezione delle dipendenze <proiezione-delle-dipendenze>
#figure(image("images/image 60.png"), caption: [
  image.png
])

== Conservazione delle dipendenze <conservazione-delle-dipendenze>
#figure(image("images/image 61.png"), caption: [
  image.png
])

- Esempi

  #figure(image("images/image 62.png"), caption: [
    image.png
  ])

  #figure(image("images/image 63.png"), caption: [
    image.png
  ])

  #figure(image("images/image 64.png"), caption: [
    image.png
  ])

= Forme normali <forme-normali>
== Prima forma normale <prima-forma-normale>
💡

Una relazione è in prima forma normale (1NF) se ogni attributo è definito su un dominio atomico.

Altri modelli per basi di dati (ad esempio il modello a oggetti o il modello relazionale a oggetti) consentono la definizione di attributi su domini non atomici quali vettori, insiemi, identificatori di oggetto.

#figure(image("images/image 65.png"), caption: [
  image.png
])

== Seconda forma normale <seconda-forma-normale>
💡

Una relazione è in seconda forma normale (2NF) se non ci sono dipendenze parziali dalla chiave.

Un attributo dipende parzialmente dalla chiave se dipende da un sottoinsieme proprio di essa. Attualmente il concetto di seconda forma normale non è utilizzato nella progettazione di basi dati relazionali, mentre sono ampiamente utilizzati i concetti di terza forma normale e forma normale di Boyce Codd.

#figure(image("images/image 66.png"), caption: [
  Relazione non in 2FN
])

Relazione non in 2FN

== Terza forma normale <terza-forma-normale>
#figure(image("images/image 67.png"), caption: [
  image.png
])

- Esempi

  #figure(image("images/image 68.png"), caption: [
    image.png
  ])

=== Decomposizione in terza forma normale <decomposizione-in-terza-forma-normale>
Una relazione non in terza forma normale presenta ridondanze e anomalie. Consideriamo ad esempio la relazione IMP vista sopra, se ci sono 10 impiegati ufficio progettazione, il nome del capo ufficio viene ripetuto 10 volte. In realtà forme di ridondanza tollerate possono essere presenti anche in 3NF

Una relazione non in terza forma normale può sempre essere decomposta, senza perdita e conservando le dipendenze, in relazioni in terza forma normale. La decomposizione di cui sopra può essere ottenuta con l’algoritmo di sintesi.

=== Algoritmo di sintesi per 3NF <algoritmo-di-sintesi-per-3nf>
#figure(image("images/image 69.png"), caption: [
  image.png
])

#figure(image("images/image 70.png"), caption: [
  image.png
])

- Esempi

  #figure(image("images/image 71.png"), caption: [
    image.png
  ])

  #figure(image("images/image 72.png"), caption: [
    image.png
  ])

== Forma normale di Boyce Codd <forma-normale-di-boyce-codd>
#figure(image("images/image 73.png"), caption: [
  image.png
])

Ogni relazione non in forma normale di Boyce Codd può essere decomposta in relazioni BCNF senza perdita. Esistono relazioni non in forma normale di Boyce Codd che non è possibile decomporre in relazioni BCNF mantenendo le dipendenze.

- Esempi

  #figure(image("images/image 74.png"), caption: [
    image.png
  ])

  #figure(image("images/image 75.png"), caption: [
    image.png
  ])

  #figure(image("images/image 76.png"), caption: [
    image.png
  ])

=== Algoritmo di analisi per BCNF <algoritmo-di-analisi-per-bcnf>
#figure(image("images/image 77.png"), caption: [
  image.png
])

#figure(image("images/image 78.png"), caption: [
  image.png
])

- Esempi

  #figure(image("images/image 79.png"), caption: [
    image.png
  ])

  #figure(image("images/image 80.png"), caption: [
    image.png
  ])

  #figure(image("images/image 81.png"), caption: [
    image.png
  ])

  #figure(image("images/image 82.png"), caption: [
    image.png
  ])

=== NOTE <note>
La trasformazione in forma normale di Boyce e Codd preserva i dati ma non sempre garantisce la conservazione delle dipendenze. La trasformazione 3NF è meno forte della BCNF e quindi non offre le medesime garanzie di qualità per una relazione, accettando anche schemi con anomalie: ha però il vantaggio di essere sempre ottenibile e di mantenere sia i dati che le dipendenze. Una decomposizione tesa ad ottenere la 3NF produce in molti casi schemi BCNF.
