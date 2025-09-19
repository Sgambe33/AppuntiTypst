#import "../../../dvd.typ": *

= Modello relazionale

#definition("Modello relazionale")[
  Con il termine *basi di dati* si intente un insieme organizzato di dati che viene utilizzato come supporto ad attività.
]
#definition("DMBS")[
  Il *DBMS* (Database Management System) è un sistema per la gestione di basi di dati. (Access, Oracle, MySQL)
]

Gli obbiettivi di un DBMS sono:

- Accesso concorrente
- Privatezza dei dati (presenza di più utenti)
- Integrità dei dati (condizioni affinché un dato sia accettabile)
- Ripristino dei dati (backup, log, journal)

#definition("Modello")[
  Un *modello* è un insieme di concetti per organizzare i dati di interesse e descriverne la struttura.
]

Il modello ad oggi più usato è il modello relazionale e utilizza il concetto di relazione per organizzare i dati in insiemi di record a struttura fissa (tutti i record hanno la stessa struttura).

Esistono altre tipologie di modelli (meno diffusi):

- Gerarchico: fa uso di alberi
- Reticolare: fa uso di grafi
- NoSQL

#definition("Schema")[
  Lo *schema* è la descrizione della organizzazione dei dati di interesse in base al modello considerato. Nel caso di SQL è la descrizione della struttura delle tabelle.
]


#definition("Istanza")[
  Un'*istanza* è il contenuto effettivo delle tabelle.
]

== Livelli di astrazione

- *Livello logico*: modello dei dati, schema logico
- *Livello fisico*: schema fisico (rappresentazione dello schema logico per mezzo di strutture fisiche). Come sono organizzati in dati sul disco.
- *Livello esterno*: descrizione di parte della base di dati per mezzo di un modello logico. In poche parole è possibile mostrare solo una parte dei dati agli utenti anche in modo diverso rispetto a come sono realmente organizzati.

I livelli di astrazione permettono di ottenere:

- indipendenza fisica→uso di modello logico. E' possibile modificare la struttura fisica senza dover cambiare anche il programma di interrogazione.
- indipendenza logica→uso di viste. Se si fa uso di viste è possibile modificare la struttura logica (aggiungere tabelle, colonne) senza modificare l'applicazione.

== Linguaggi per basi di dati

- Data Definition Language (*DDL*):
  - definizione schema logico
  - definizione schema fisico
  - autorizzazione per accesso
- Data Manipulation Language (*DML*):
  - inserimento, modifica, cancellazione, interrogazioni

SQL possiede entrambe le funzionalità.

== Utenti della base di dati

- *Amministratore*: responsabile della progettazione, controllo, autorizzazioni e manutenzione.
- *Programmatori/applicazioni*.
- *Utenti finali*: interagiscono con la base tramite applicazioni
- *Utenti casuali*: eseguono query non prestabilite

== Modello relazionale

Al contrario dei modelli gerarchici e reticolari, esso non fa uso di puntatori tra i vari record ma è invece basato sull'uso dei valori. Anche le relazioni tra i record sono dei valori. Si basa sul concetto matematico di relazione ed essa ha una rappresentazione naturale per mezzo di tabelle.

La parola *relazione* può essere usata in diversi contesti:

- Relazione matematica: come nella teoria degli insiemi.
- Relazione: secondo il modello relazionale dei dati.
- Relazione (relationship): rappresenta una classe di fatti nel modello ER.

$
  D_1=\{a,b\} space space D_2=\{x,y,z\}
$

Ricordando la definizione di prodotto cartesiano $D_1 times D_2$, una relazione $r$  è un sottoinsieme di $D_1 times D_2$. Il prodotto cartesiano può essere fatto anche su più di 2 insiemi e può comunque esistere una relazione su esso. In ogni caso, gli insiemi che generano il prodotto cartesiano, vengono detti domini della relazione.

Una relazione è quindi un insieme di n-uple ordinate $(d_1, d_2, d_3)$ dove $d_1 in D_1 … d_n in D_n$.

- Non c'è ordinamento tra le n-uple
- Le n-uple sono distinte
- Ogni elemento di una n-upla appartiene ad un insieme diverso.

La struttura della relazione può essere posizionale oppure no:

- Posizionale: il dominio si distingue attraverso la posizione nella tupla.
- Non posizionale: a ciascun dominio si associa un nome unico nella tabella (detto attributo) che ne descrive il ruolo.

In una tabella, che rappresenta una relazione:

- L'ordine delle colonne non ha significato
- L'ordine delle righe non ha significato

Una tabella rappresenta una relazione se:

- Le righe sono diverse fra loro
- Le intestazioni delle colonne sono diverse fra loro
- I valori in ogni colonna devono essere omogenei (stesso tipo)

== Definizioni

#definition("Schema di relazione")[
  Un nome $R$ con un insieme di attributi $X=\{A_1,…,A_n\}$
  dove $n$  è il grado della relazione.

  $
    R(X) =R(A_1,...,A_n)
  $
]

#definition("Schema di base di dati")[
  Insieme di schemi di relazione.
  $
    R=\{R_1(X_1),...,R_k(X_k)\}
  $
]

Una ennupla su un insieme di attributi $X$ è una funzione che associa a ciascun attributo $A$ in $X$ un valore del dominio di $A$. $t[A]$  denota il valore della ennupla $t$ sull'attributo $A$

#definition()[
  Un'istanza di base di dati su uno schema $R=\{R_1(X_1),...,R_n(X_n)\}$ è insieme di relazioni $r=\{r_1,...,r_n\}$ (con $r_i$ relazione su $R_i$).
]

#definition()[
  Istanza di relazione su uno schema $R(X)$: insieme $r$ di ennuple su $X$; $|r|$ è la cardinalità dell'istanza di relazione.
]

Il modello relazionale impone ai dati una struttura rigida. Solo alcuni formati di ennuple sono ammessi, ovvero quelli che corrispondono agli schemi di relazione. Talvolta potrebbero essere presenti informazioni incomplete. Non conviene in questo caso far uso di valori del dominio (0, stringa nulla, valore massimo…). La soluzione è utilizzare il valore nullo.

Il valore nullo (*NULL*) denota l'assenza di un valore del dominio (attenzione, non vi appartiene). L'uso di NULL deve essere gestito correttamente. In alcuni casi gli attributi non possono contenere un valore nullo (pensa ad una chiave primaria)

== Vincoli di integrità

#definition()[
  Un *vincolo di integrità* è una proprietà che deve essere soddisfatta dalle istanze che rappresentano informazioni corrette per l'applicazione. E' una funzione booleana (*predicato*) che associa ad ogni istanza il valore vero o falso.
]

=== Tipologie di vincoli

- *Vincoli intrarelazionali*: il suo soddisfacimento è definito rispetto a singole relazioni della base di dati.
  - *Vincoli su valori*: impone una restrizione sul dominio dell'attributo (es. numero compreso tra 10 e 20).
  - *Vincoli su ennupla*: quando il vincolo può essere valutato su una singola tupla indipendentemente dalle altre.
  //TODO: trasformare in tabella
  #figure(image("images/image.png"))

- *Vincoli interrelazionali*: quando il vincolo coinvolge più relazioni (es. una chiave esterna deve esistere come primaria nella sua relazione).

=== Vincoli di chiave

#definition("Chiave")[
  Si definisce *chiave* un insieme di attributi utilizzato per identificare univocamente le tuple di una relazione.
]

#definition("Superchiave")[
  Un insieme $K$ di attributi si definisce *superchiave* per $r$ se $r$ non contiene due ennuple distinte $t_1$ e $t_2$ con $t_1[K]=t_2[K]$
]

$K$ è una *chiave* per $r$ se è una superchiave minimale per $r$ (cioè non contiene un'altra superchiave).

#example()[
  Matricola è una chiave: superchiave e minimale (contiene un solo attributo).
  `{matricola, corso}` è solo superchiave; esiste un suo sottoinsieme proprio `{matricola}`
  //TODO:Trasformare in tabella
  #image("images/image 1.png")
]

Una relazione non può contenere ennuple uguali ma distinte, questo permette ad ogni relazione di avere come superchiave l'insieme degli attributi su cui è definita.

=== Vincoli di integrità referenziale

#definition()[
  Un vincolo di integrità referenziale, *foreign key*, fra gli attributi $X$ di una relazione $R_1$ e un'altra $R_2$ impone ai valori su $X$ in $R_1$ di comparire come valori della chiave primaria di $R_2$.
]

Giocano un ruolo fondamentale nel concetto di modello basato su valori. Sono possibili azioni compensative a seguito di violazioni:

- Eliminazione in cascata.
- Introduzione di valori nulli.
// TODO: Trasformare in tabella
#figure(image("images/image 2.png"), caption: "Esempio di violazione.")
