#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

= Modello relazionale #index-main("Modello relazionale")

#definition("Modello relazionale")[
  Con il termine *basi di dati*#index-main("Basi di dati") si intente un insieme organizzato di dati che viene utilizzato come supporto ad attività.
]
#definition("DMBS")[
  Il *DBMS*#index-main("DBMS") (Database Management System) è un sistema per la gestione di basi di dati. (Access, Oracle, MySQL)
]

Gli obbiettivi di un DBMS sono:

- Accesso concorrente
- Privatezza dei dati (presenza di più utenti)
- Integrità dei dati (condizioni affinché un dato sia accettabile)
- Ripristino dei dati (backup, log, journal)

#definition("Modello")[
  Un *modello*#index-main("Modello di dati") è un insieme di concetti per organizzare i dati di interesse e descriverne la struttura.
]

Il modello ad oggi più usato è il modello relazionale#index("Modello di dati", "Relazionale") e utilizza il concetto di relazione per organizzare i dati in insiemi di record a struttura fissa (tutti i record hanno la stessa struttura).

Esistono altre tipologie di modelli (meno diffusi):

- Gerarchico#index("Modello di dati", "Gerarchico"): fa uso di alberi
- Reticolare#index("Modello di dati", "Reticolare"): fa uso di grafi
- NoSQL#index("Modello di dati", "NoSQL")

#definition("Schema")[
  Lo *schema*#index-main("Schema", "Definizione") è la descrizione della organizzazione dei dati di interesse in base al modello considerato. Nel caso di SQL è la descrizione della struttura delle tabelle.
]


#definition("Istanza")[
  Un'*istanza*#index-main("Istanza", "Definizione") è il contenuto effettivo delle tabelle.
]

== Livelli di astrazione #index-main("Livelli di astrazione")

- *Livello logico*#index("Livelli di astrazione", "Logico"): modello dei dati, schema logico
- *Livello fisico*#index("Livelli di astrazione", "Fisico"): schema fisico (rappresentazione dello schema logico per mezzo di strutture fisiche). Come sono organizzati in dati sul disco.
- *Livello esterno*#index("Livelli di astrazione", "Esterno"): descrizione di parte della base di dati per mezzo di un modello logico. In poche parole è possibile mostrare solo una parte dei dati agli utenti anche in modo diverso rispetto a come sono realmente organizzati.

I livelli di astrazione permettono di ottenere:

- indipendenza fisica#index-main("Indipendenza dei dati", "Fisica")→uso di modello logico. E' possibile modificare la struttura fisica senza dover cambiare anche il programma di interrogazione.
- indipendenza logica#index-main("Indipendenza dei dati", "Logica")→uso di viste. Se si fa uso di viste è possibile modificare la struttura logica (aggiungere tabelle, colonne) senza modificare l'applicazione.

== Linguaggi per basi di dati #index-main("Linguaggi per basi di dati")

- Data Definition Language (*DDL*#index-main("DDL")):
  - definizione schema logico
  - definizione schema fisico
  - autorizzazione per accesso
- Data Manipulation Language (*DML*#index-main("DML")):
  - inserimento, modifica, cancellazione, interrogazioni

SQL#index("SQL") possiede entrambe le funzionalità.

== Utenti della base di dati

- *Amministratore*#index("DBA (Amministratore della base di dati)"): responsabile della progettazione, controllo, autorizzazioni e manutenzione.
- *Programmatori/applicazioni*.
- *Utenti finali*: interagiscono con la base tramite applicazioni
- *Utenti casuali*: eseguono query non prestabilite

== Modello relazionale

Al contrario dei modelli gerarchici e reticolari, esso non fa uso di puntatori tra i vari record ma è invece basato sull'uso dei valori. Anche le relazioni tra i record sono dei valori. Si basa sul concetto matematico di relazione ed essa ha una rappresentazione naturale per mezzo di tabelle.

La parola *relazione* può essere usata in diversi contesti:

- Relazione matematica#index("Relazione", "Matematica"): come nella teoria degli insiemi.
- Relazione: secondo il modello relazionale dei dati#index-main("Relazione", "nel modello relazionale").
- Relazione (relationship): rappresenta una classe di fatti nel modello ER#index("Relationship (associazione)").

$
  D_1=\{a,b\} space space D_2=\{x,y,z\}
$

Ricordando la definizione di prodotto cartesiano#index-main("Prodotto cartesiano") $D_1 times D_2$, una relazione $r$  è un sottoinsieme di $D_1 times D_2$. Il prodotto cartesiano può essere fatto anche su più di 2 insiemi e può comunque esistere una relazione su esso. In ogni caso, gli insiemi che generano il prodotto cartesiano, vengono detti domini#index-main("Dominio") della relazione.

Una relazione è quindi un insieme di n-uple#index-main("Tupla") ordinate $(d_1, d_2, d_3)$ dove $d_1 in D_1 … d_n in D_n$.

- Non c'è ordinamento tra le n-uple
- Le n-uple sono distinte
- Ogni elemento di una n-upla appartiene ad un insieme diverso.

La struttura della relazione può essere posizionale oppure no:

- Posizionale: il dominio si distingue attraverso la posizione nella tupla.
- Non posizionale: a ciascun dominio si associa un nome unico nella tabella (detto attributo#index-main("Attributo", "nel modello relazionale")) che ne descrive il ruolo.

In una tabella, che rappresenta una relazione:

- L'ordine delle colonne non ha significato
- L'ordine delle righe non ha significato

Una tabella rappresenta una relazione se:

- Le righe sono diverse fra loro
- Le intestazioni delle colonne sono diverse fra loro
- I valori in ogni colonna devono essere omogenei (stesso tipo)

== Definizioni

#definition("Schema di relazione")[#index-main("Schema", "di relazione")
  Un nome $R$ con un insieme di attributi $X=\{A_1,…,A_n\}$
  dove $n$  è il grado#index-main("Grado di una relazione") della relazione.

  $
    R(X) =R(A_1,...,A_n)
  $
]

#definition("Schema di base di dati")[#index-main("Schema", "di base di dati")
  Insieme di schemi di relazione.
  $
    R=\{R_1(X_1),...,R_k(X_k)\}
  $
]

Una ennupla su un insieme di attributi $X$ è una funzione che associa a ciascun attributo $A$ in $X$ un valore del dominio di $A$. $t[A]$  denota il valore della ennupla $t$ sull'attributo $A$

#definition()[#index-main("Istanza", "di base di dati")
  Un'istanza di base di dati su uno schema $R=\{R_1(X_1),...,R_n(X_n)\}$ è insieme di relazioni $r=\{r_1,...,r_n\}$ (con $r_i$ relazione su $R_i$).
]

#definition()[#index-main("Istanza", "di relazione")
  Istanza di relazione su uno schema $R(X)$: insieme $r$ di ennuple su $X$; $|r|$ è la cardinalità#index-main("Cardinalità", "di relazione") dell'istanza di relazione.
]

Il modello relazionale impone ai dati una struttura rigida. Solo alcuni formati di ennuple sono ammessi, ovvero quelli che corrispondono agli schemi di relazione. Talvolta potrebbero essere presenti informazioni incomplete. Non conviene in questo caso far uso di valori del dominio (0, stringa nulla, valore massimo…). La soluzione è utilizzare il valore nullo.

Il valore nullo (*NULL*#index-main("Valore nullo (NULL)")) denota l'assenza di un valore del dominio (attenzione, non vi appartiene). L'uso di NULL deve essere gestito correttamente. In alcuni casi gli attributi non possono contenere un valore nullo (pensa ad una chiave primaria)

== Vincoli di integrità #index-main("Vincoli di integrità")

#definition()[
  Un *vincolo di integrità* è una proprietà che deve essere soddisfatta dalle istanze che rappresentano informazioni corrette per l'applicazione. E' una funzione booleana (*predicato*) che associa ad ogni istanza il valore vero o falso.
]

=== Tipologie di vincoli

- *Vincoli intrarelazionali*#index("Vincoli di integrità", "Intrarelazionali"): il suo soddisfacimento è definito rispetto a singole relazioni della base di dati.
  - *Vincoli su valori*#index("Vincoli di integrità", "Su valori"): impone una restrizione sul dominio dell'attributo (es. numero compreso tra 10 e 20).
  - *Vincoli su ennupla*#index("Vincoli di integrità", "Su ennupla"): quando il vincolo può essere valutato su una singola tupla indipendentemente dalle altre.
  #figure(
    table(
      columns: 4,
      fill: (x, y) => if y == 0 { rgb("#aee4e4") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
      align: (x, y) => if x == 0 { left } else { right },
      table.header(
        table.cell(colspan: 4, align: center)[*STIPENDI*],
        [*Impiegato*], [*Lordo*], [*Ritenute*], [*Netto*],
      ),
      [Rossi], [55.000], [12.500], [42.500],
      [Neri], [45.000], [10.000], [35.000],
      [Bruni], [47.000], [11.000], [36.000],
    ),
    caption: [Esempio di vincolo su ennupla],
  )
  $ "Lordo" = ("Ritenute" + "Netto") $

- *Vincoli interrelazionali*#index("Vincoli di integrità", "Interrelazionali"): quando il vincolo coinvolge più relazioni (es. una chiave esterna deve esistere come primaria nella sua relazione).

=== Vincoli di chiave #index-main("Vincoli di integrità", "Di chiave")

#definition("Chiave")[#index-main("Chiave")
  Si definisce *chiave* un insieme di attributi utilizzato per identificare univocamente le tuple di una relazione.
]

#definition("Superchiave")[#index-main("Superchiave")
  Un insieme $K$ di attributi si definisce *superchiave* per $r$ se $r$ non contiene due ennuple distinte $t_1$ e $t_2$ con $t_1[K]=t_2[K]$
]

$K$ è una *chiave* per $r$ se è una superchiave minimale#index("Chiave", "Minimale") per $r$ (cioè non contiene un'altra superchiave).

#example()[
  Matricola è una chiave: superchiave e minimale (contiene un solo attributo).
  `{matricola, corso}` è solo superchiave; esiste un suo sottoinsieme proprio `{matricola}`
  #figure(
    table(
      columns: 5,
      fill: (x, y) => if y == 0 { rgb("#aee4e4") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
      table.header(
        table.cell(colspan: 5, align: center)[*STUDENTI*],
        [*Matricola*], [*Cognome*], [*Nome*], [*Corso*], [*Nascita*],
      ),
      [6554], [Rossi], [Mario], [Algoritmi], [05/12/1995],
      [7341], [Rossi], [Mario], [Analisi], [03/11/1994],
      [8765], [Neri], [Paolo], [Algoritmi], [03/11/1994],
      [8532], [Neri], [Mario], [Analisi], [05/12/1995],
      [3456], [Rossi], [Maria], [Fisica], [03/11/1994],
      [9283], [Verdi], [Luisa], [Algoritmi], [12/11/1995],
    ),
  )
]

Una relazione non può contenere ennuple uguali ma distinte, questo permette ad ogni relazione di avere come superchiave l'insieme degli attributi su cui è definita.

=== Vincoli di integrità referenziale #index-main("Integrità referenziale")

#definition()[#index-main("Foreign key")
  Un vincolo di integrità referenziale, *foreign key*, fra gli attributi $X$ di una relazione $R_1$ e un'altra $R_2$ impone ai valori su $X$ in $R_1$ di comparire come valori della chiave primaria di $R_2$.
]

Giocano un ruolo fondamentale nel concetto di modello basato su valori. Sono possibili azioni compensative a seguito di violazioni:

- Eliminazione in cascata#index("Eliminazione in cascata").
- Introduzione di valori nulli#index("Valore nullo (NULL)", "Come azione compensativa").
#let red-row = rgb("#ff4444")
#let teal-header = rgb("#aee4e4")
#let odd-row = rgb("#f0f0f0")

#figure(
  grid(
    columns: 1,
    gutter: 1em,
    table(
      columns: 6,
      fill: (x, y) => {
        if y == 0 { teal-header } else if y == 5 { red-row } // riga violazione (TO, 2F7643)
        else if calc.even(y) { white } else { odd-row }
      },
      align: (x, y) => if x == 0 { center } else { left },
      table.header(
        table.cell(colspan: 6, align: center)[*INFRAZIONI*],
        [*Codice*], [*Data*], [*Agente*], [*Articolo*], [*Prov*], [*Numero*],
      ),
      [1], [25/10/14], [567], [44], [FI], [4E5432],
      [2], [26/10/14], [456], [34], [FI], [4E5432],
      [3], [26/10/14], [638], [34], [FI], [2F7643],
      [4], [15/10/14], [456], [53], [MI], [2F7643],
      table.cell(fill: red-row)[5], table.cell(fill: red-row)[12/10/14],
      table.cell(fill: red-row)[567], table.cell(fill: red-row)[44],
      table.cell(fill: red-row)[*TO*], table.cell(fill: red-row)[*2F7643*],
    ),
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 { teal-header } else if y == 3 { red-row } // riga TO, 2F7643 (non esiste)
        else if calc.even(y) { white } else { odd-row }
      },
      table.header(
        table.cell(colspan: 4, align: center)[*AUTO*],
        [*Prov*], [*Numero*], [*Proprietario*], [*Indirizzo*],
      ),
      [FI], [2F7643], [Verdi Piero], [Via Tigli],
      [FI], [1A2396], [Verdi Piero], [Via Tigli],
      table.cell(fill: red-row)[*TO*], table.cell(fill: red-row)[4E5432],
      table.cell(fill: red-row)[Bini Luca], table.cell(fill: red-row)[Via Aceri],
      [MI], [2F7643], [Bianchi Gino], [Via Aceri],
    ),
  ),
  caption: "Esempio di violazione di integrità referenziale.",
)
