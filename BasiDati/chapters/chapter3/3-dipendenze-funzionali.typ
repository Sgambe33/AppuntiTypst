#import "../../../dvd.typ": *

= Dipendenze funzionali e forme normali 
== Ridondanze e anomalie
//TODO: Trasformare in tabella

#figure(table(
  rows: 8,
  columns: 6,
  table.cell(fill: orange, [num]),
  table.cell(fill: orange, [fornitore]),
  table.cell(fill: orange, [indirizzo]),
  table.cell(fill: orange, [articolo]),
  table.cell(fill: orange, [data]),
  table.cell(fill: orange, [quantità]),
  [350],[Rossi],[Prato],[penna],[10/2/13],[50],
  [350],[Rossi],[Prato],[lapis],[10/2/13],[40],
  [350],[Rossi],[Prato],[gomma],[10/2/13],[45],
  [351],[Bianchi],[Empoli],[pennarelli],[10/2/13],[60],
  [360],[Verdi],[Empoli],[quaderni],[13/2/13],[100],
  [360],[Verdi],[Empoli],[penna],[13/2/13],[70],
  [362],[Rossi],[Prato],[penna],[13/2/13],[10],
), caption: "ORDINE(num, fornitore, indirizzo, articolo, data, quantita)")

- *Ridondanza*: il valore di indirizzo è ripetuto in tutte le tuple che riguardano un ordine e in tutti gli ordini dello stesso fornitore;
- *Anomalie di aggiornamento*: se modiﬁchiamo l'indirizzo di un fornitore o la data di un ordine in una tupla, dobbiamo modiﬁcare contemporaneamente anche le altre;
- *Anomalie di inserzione*: non possiamo inserire le caratteristiche di un nuovo fornitore senza che gli sia stato ordinato qualcosa;
- *Anomalia di cancellazione*: se cancelliamo le informazioni relative all'ordine 351, cancelliamo anche le informazioni che riguardano il fornitore Bianchi.

== Dipendenze funzionali
Una dipendenza funzionale è un vincolo di integrità che lega fra loro i valori degli attributi di una relazione. Prendendo l'esempio precedente: in una istanza di ORDINE, se abbiamo due valori uguali per l'attributo fornitore, quelle due tuple hanno valori uguali anche per l'attributo indirizzo. 

Ad ogni schema di relazione sono in genere associate più dipendenze funzionali (individuabili solo considerando il significato degli attributi).
#definition(
  )[
  Dati $R (A_1 , . . . , A_n)$ e $X subset.eq { A_1 , . . . , A_n }$ e $Y subset.eq { A_1 , . . . , A_n }$ si dice che #strong[X determina funzionalmente Y] o che Y dipende funzionalmente da X e si scrive X→Y se $forall$ istanza di $r$ di $R$, $forall$ coppia di tuple $t_1$ e $t_2$ in $r$:

  $
    t_1[X]=t_2[X] => t_1[Y]=t_2[Y]
  $
]

In ogni istanza non ci possono essere due tuple con valori uguali per X e valori diversi per Y.

- Se $Y subset.eq X$ la dipendenza è #strong[banale.]
- Se $Y = X$ la dipendenza #strong[banale] si dice anche #strong[identità.]
Dall'esempio precedente abbiamo che: 
  - num→fornitore
  - fornitore→indirizzo
  - num→fornitore, indirizzo, data

=== Osservazioni

+ Una dipendenza funzionale è un vincolo di integrità associato ad una relazione.
+ Ad ogni schema viene associato un insieme di dipendenze funzionali.
+ Ad ogni schema e sempre associato l'insieme delle dipendenze ovvie (anche se in genere si tralasciano perché prive di interesse pratico).
+ L'insieme delle dip. funzionali può essere determinato solo conoscendo il signiﬁcato degli attributi nel contesto che stiamo considerando
+ Una particolare tabella che verifica l'insieme dei vincoli associati allo schema (e quindi anche le dip. funz. associate) si dice corretta.


== Implicazione

#definition(
  )[
  Dato un insieme di dipendenze funzionali F

  $
    F space "implica" space X => Y
  $

  se ogni relazione $r$ che soddisfa F soddisfa anche X → Y. L'insieme $F^(+)$ delle dipendenze implicate da F viene detto #strong[chiusura di F]

  $
    F^+ = {X => Y | F space "implica" space X => Y }, space F subset.eq F^+
  $
]

Dall'esempio precedente:

ORDINE (num, fornitore, indirizzo, articolo, data, quantita) F ⊃ {num → fornitore, fornitore → indirizzo} si ha che 
  #strong[F implica num → indirizzo].

=== Assiomi di Armstrong

#definition(
  )[

  Dato F, la chiusura $F^(+)$ può essere calcolata applicando ripetutamente a $F$ le tre regole di inferenza dette *Assiomi di Armstrong*:

  - Riflessività:

    $
      "se" space Y subset.eq X space "allora" space X => Y
    $

  - Arricchimento:

    $
      "se" space X => Y space "allora" space X Z => Y Z
    $

  - Transitività:

    $
      "se" space X => Y space "e" space Y => Z space "allora" space X => Z
    $
]

Dagli assiomi di Armstrong derivano anche altre regole di inferenza:

- *Unione*: se $X => A_1, X=> A_2,...,X => A_K$ allora $X=> A_1,...,A_k$
- *Decomposizione*: se $X=> A_1,...,A_k$ allora $X => A_1, X=> A_2,...,X => A_K$

- Esempio precedente

  IMPIEGATO(codimp, nome, stip, progetto, data ﬁnale) Riﬂessività: {stip, progetto} ⊆ {stip, progetto} quindi

  stip, progetto → stip, progetto

  {progetto} ⊆ {stip, progetto} quindi stip, progetto → progetto Arricchimento: se vale progetto → data ﬁnale allora

  progetto, stip → data ﬁnale, stip

  Transitività: se codimp → progetto e progetto → data ﬁnale allora codimp → data ﬁnale.

=== Problemi dell'implicazione <problemi-dellimplicazione>
Un problema frequente è quello di decidere se una dipendenza funzionale appartiene a $F^(+)$. Per risolverlo possiamo usare un algoritmo che applica ripetutamente gli assiomi di Armstrong ma che ha una complessità esponenziale. (se n è il numero di attributi, $F^(+)$ contiene almeno $2^n - 1$ dip. funz. banali.

Altrimenti possiamo usare un metodo con complessità minore: per decidere se $X => Y in F^+$ si può controllare se $Y subset.eq X_F^(+)$

== Chiusura di un insieme di attributi

#definition()[
  Dati $R(T)$ e $F$ sia $X subset.eq T$
  $
    X_F^+ = {A in T bar X->A in F^+} space "ovvero" space X_F^+ = {A in T bar F space "implica" space X->A}
  $
  la chiusura di $X$ rispetto a $F$ è l'insieme degli attributi che dipendono da $X$ (direttamente o implicitamente).
]

#theorem()[
  F implica $X arrow Y$ se e solo se $Y subset.eq X_F^+$
]
#proof(
  )[
  - $arrow.r.double$:
    + Sia $Y = A_1,A_2 ... A_k$ quindi $X arrow A_1,A_2 ... A_k$
    + Per la regola di decomposizione si ha $X arrow A_i$, quindi $A_i in X_F^+$ per definizione di $X_F^+$ con $1 lt.eq i lt.eq k$
    + pertanto $Y subset.eq X_F^+$
  - $arrow.l.double$:
    + da $Y = A_1 A_2 ... A_k subset.eq X_F^+$ si ha $A_i in X_F^+$, $1<=i<=k$
    + quindi $X->A_i$ per definizione di $X_F^+$
    + per la regola di unione $X->A_1 A_2 ... A_k$
]

Questo teorema ci dà un metodo per verificare se una dipendenza è implicata da $F$ (appartiene a $F^+$). $X subset.eq X_F^+$

=== Calcolo di $X_F^(+)$

- Input: $R(T), F, X subset.eq T$
- Output: $X_F^+$ chiusura di $X$ rispetto a $F$
- Metodo: si calcola una sequenza di insiemi $X^0,X^1,...$ con i passi:
  + $X^0 <- X$
  + $X^(i+1) <- X^i union {A bar Y ->Z in F, Y subset.eq X^i, A in Z}$
- $X=X^0 subset.eq X^1 ... subset.eq X^i ... subset.eq T$ e $T$ è finito (l'algoritmo termina)
- Se $X^i = X^(i+1)$ allora $X^i = X^(i+1)=X^(i+2)=...$
- Si può dimostrare in tal caso $X^i = X_F^+$

Aggiungo gli attributi di una dipendenza alla volta.

- Input: $R(T), F, X subset.eq T$
- Output: un insieme di attributi _XPIU_
  + _XPIU_ $<- X$
  + Fino a che non ci sono più attributi da aggiungere a _XPIU_ eseguin il passo:
    - Esamina $F$, per ogni dipendenza $X->Y in F$ tale che $X subset.eq$_XPIU_ e _NOT_($Y subset.eq$_XPIU_) esegui _XPIU_ $<-$ _XPIU_ $union Y$ 

Aggiungo gli attributi di più di più dipendenze alla volta.

#observation()[
  $
    F space "implica" space X->Y <=> X->Y in F^+ <=> Y subset.eq X_F^+
  $
  Il calcolo della chiusura di un insieme di attributi può quindi essere usato per determinare se una certa dipendenza è o non è implicata da $F$.
]

#example(multiple: true)[
  #figure(image("images/image 39.png"))

  #figure(image("images/image 40.png"))
]


== Definizione di chiave con dipendenze funzionali

- Dati $R(T)$ e $F, X subset.eq T$ è una chiave se:
  + $F$ implica $x->T$
  + per nessun $Y$ sottoinsieme proprio di $X$ si ha $F$ implica $Y->T$. (Sottoinsieme proprio vuol dire sottoinsieme non coincidente)
- Un insieme $X$ che verifica la proprietà 1 è detto *superchiave* (una chiave è anche una superchiave). Si può dire che una chiave è una superchiave non ridondante.
- La proprietà 1 può essere verifica controllando se $T=X_F^+$.
- Dati $R(T)$ e $F,T$ è sempre una superchiave (talvolta è anche l'unica chiave).

#example(multiple: true)[
  #figure(image("images/image 42.png"))

  #figure(image("images/image 43.png"))

  #figure(image("images/image 44.png"))
]

== Equivalenze
Per operare su insiemi di dipendenze fa comodo ridurli in forme minimali. Per fare ciò si introducono i concetti di *equivalenza* e *copertura*. L'equivalenza tra due schemi di relazione permette di determinare quando essi rappresentano gli stessi fatti.

#definition()[
  Gli insiemi di dipendenze funzionali $F$ e $G$ sono *equivalenti*, $F equiv G$, se
  - $F^+=G^+$ ovvero
  - $F subset.eq G^+$ e $G subset.eq F^+$ ovvero
  - $G$ implica ogni dipendenza in $F$ e viceversa
  Se $F equiv G$, $F$ è detto *copertura* di $G$ e viceversa.
]

#example()[
  #figure(image("images/image 46.png"))
]

#definition()[
  Un insieme $F$ di dipendenze è *non ridondante* se non esiste $f in F$ tale che $F-{f}$ implica $f$ ovvero tale che $(F-{f}) equiv F$
]

#definition()[
  Un insieme $F$ di dipendenze è *ridotto* se e solo se:
  + Ogni dipendenza ha a destra un solo attributo.
  + E' non ridondante, cioè non ci sono dipendenze ridondanti.
  + Le dipendenze hanno parti sinistre non ridondanti, cioè per ogni $X->Y in F$ non esiste $A in X$ tale che:
    $
      F-{X->Y} union {(X-A)->Y} equiv F
    $
]

#example()[
  #figure(image("images/image 48.png"))
]


=== Calcolo copertura ridotta

+ Trasforma ogni dipendenza $X->Y$ con $bar Y bar > 1$ in dipendenze che hanno a destra un solo attributo (regola di decomposizione).
+ Indicato con $F$ l'insieme di dipendenze corrente, per ogni dipendenza $X->A in F$ con $bar X bar > 1$ controlla se $X$ contiene attributi ridondanti: se $B in X$ è ridondante (ovvero $A in (X-B)_F^+$) allora
  $
    F<-F-{X->A} union {(X-B)->A}
  $
+ Indicato con $F$ l'insieme di dipendenze corrente, per ogni dipendenza $X->A in F$ controlla se è ridondante: se $X->A$ è ridondante (ovvero $A in X_(F-{X->A})^+$) allora 
  $
    F<-F-{X->A}
  $
  
#example()[
  #figure(image("images/image 50.png"))

  #figure(image("images/image 51.png"))

  #figure(image("images/image 52.png"))

  #figure(image("images/image 53.png"))
]
 

== Decomposizione di relazioni
Per eliminare anomalie da uno schema mal definito si cerca di decomporlo in schemi più piccoli che godono di particolari proprietà (forme normali) ma sono in qualche senso equivalenti allo schema originale. Si richiede in genere che lo schema soddisfi due condizioni indipendenti fra loro: preservi i dati e preservi le dipendenze.

#figure(image("images/image 54.png"))

=== Decomposizione senza perdita
#figure(image("images/image 55.png"))

- Esempio con perdita

  #figure(image("images/image 56.png"))

  #figure(image("images/image 57.png"))

#figure(image("images/image 58.png"))

- Esempio senza perdita

  #figure(image("images/image 59.png"))

== Proiezione delle dipendenze <proiezione-delle-dipendenze>
#figure(image("images/image 60.png"))

== Conservazione delle dipendenze <conservazione-delle-dipendenze>
#figure(image("images/image 61.png"))

- Esempi

  #figure(image("images/image 62.png"))

  #figure(image("images/image 63.png"))

  #figure(image("images/image 64.png"))

= Forme normali <forme-normali>
== Prima forma normale <prima-forma-normale>
💡

Una relazione è in prima forma normale (1NF) se ogni attributo è definito su un dominio atomico.

Altri modelli per basi di dati (ad esempio il modello a oggetti o il modello relazionale a oggetti) consentono la definizione di attributi su domini non atomici quali vettori, insiemi, identificatori di oggetto.

#figure(image("images/image 65.png"))

== Seconda forma normale <seconda-forma-normale>
💡

Una relazione è in seconda forma normale (2NF) se non ci sono dipendenze parziali dalla chiave.

Un attributo dipende parzialmente dalla chiave se dipende da un sottoinsieme proprio di essa. Attualmente il concetto di seconda forma normale non è utilizzato nella progettazione di basi dati relazionali, mentre sono ampiamente utilizzati i concetti di terza forma normale e forma normale di Boyce Codd.

#figure(image("images/image 66.png"), caption: [
  Relazione non in 2FN
])

Relazione non in 2FN

== Terza forma normale <terza-forma-normale>
#figure(image("images/image 67.png"))

- Esempi

  #figure(image("images/image 68.png"))

=== Decomposizione in terza forma normale <decomposizione-in-terza-forma-normale>
Una relazione non in terza forma normale presenta ridondanze e anomalie. Consideriamo ad esempio la relazione IMP vista sopra, se ci sono 10 impiegati ufficio progettazione, il nome del capo ufficio viene ripetuto 10 volte. In realtà forme di ridondanza tollerate possono essere presenti anche in 3NF

Una relazione non in terza forma normale può sempre essere decomposta, senza perdita e conservando le dipendenze, in relazioni in terza forma normale. La decomposizione di cui sopra può essere ottenuta con l'algoritmo di sintesi.

=== Algoritmo di sintesi per 3NF <algoritmo-di-sintesi-per-3nf>
#figure(image("images/image 69.png"))

#figure(image("images/image 70.png"))

- Esempi

  #figure(image("images/image 71.png"))

  #figure(image("images/image 72.png"))

== Forma normale di Boyce Codd <forma-normale-di-boyce-codd>
#figure(image("images/image 73.png"))

Ogni relazione non in forma normale di Boyce Codd può essere decomposta in relazioni BCNF senza perdita. Esistono relazioni non in forma normale di Boyce Codd che non è possibile decomporre in relazioni BCNF mantenendo le dipendenze.

- Esempi

  #figure(image("images/image 74.png"))

  #figure(image("images/image 75.png"))

  #figure(image("images/image 76.png"))

=== Algoritmo di analisi per BCNF <algoritmo-di-analisi-per-bcnf>
#figure(image("images/image 77.png"))

#figure(image("images/image 78.png"))

- Esempi

  #figure(image("images/image 79.png"))

  #figure(image("images/image 80.png"))

  #figure(image("images/image 81.png"))

  #figure(image("images/image 82.png"))

=== NOTE <note>
La trasformazione in forma normale di Boyce e Codd preserva i dati ma non sempre garantisce la conservazione delle dipendenze. La trasformazione 3NF è meno forte della BCNF e quindi non offre le medesime garanzie di qualità per una relazione, accettando anche schemi con anomalie: ha però il vantaggio di essere sempre ottenibile e di mantenere sia i dati che le dipendenze. Una decomposizione tesa ad ottenere la 3NF produce in molti casi schemi BCNF.
