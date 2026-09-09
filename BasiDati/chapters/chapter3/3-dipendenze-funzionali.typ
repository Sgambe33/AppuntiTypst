#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()

= Dipendenze funzionali e forme normali #index-main("Dipendenza funzionale") #index-main("Forme normali")
== Ridondanze e anomalie #index-main("Anomalie") #index-main("Ridondanza")
#figure(
  table(
    rows: 8,
    columns: 6,
    table.cell(fill: orange, [num]),
    table.cell(fill: orange, [fornitore]),
    table.cell(fill: orange, [indirizzo]),
    table.cell(fill: orange, [articolo]),
    table.cell(fill: orange, [data]),
    table.cell(fill: orange, [quantità]),
    [350], [Rossi], [Prato], [penna], [10/2/13], [50],
    [350], [Rossi], [Prato], [lapis], [10/2/13], [40],
    [350], [Rossi], [Prato], [gomma], [10/2/13], [45],
    [351], [Bianchi], [Empoli], [pennarelli], [10/2/13], [60],
    [360], [Verdi], [Empoli], [quaderni], [13/2/13], [100],
    [360], [Verdi], [Empoli], [penna], [13/2/13], [70],
    [362], [Rossi], [Prato], [penna], [13/2/13], [10],
  ),
  caption: "ORDINE(num, fornitore, indirizzo, articolo, data, quantita)",
)

- *Ridondanza*#index("Ridondanza"): il valore di indirizzo è ripetuto in tutte le tuple che riguardano un ordine e in tutti gli ordini dello stesso fornitore;
- *Anomalie di aggiornamento*#index-main("Anomalie", "Di aggiornamento"): se modiﬁchiamo l'indirizzo di un fornitore o la data di un ordine in una tupla, dobbiamo modiﬁcare contemporaneamente anche le altre;
- *Anomalie di inserzione*#index-main("Anomalie", "Di inserimento"): non possiamo inserire le caratteristiche di un nuovo fornitore senza che gli sia stato ordinato qualcosa;
- *Anomalia di cancellazione*#index-main("Anomalie", "Di cancellazione"): se cancelliamo le informazioni relative all'ordine 351, cancelliamo anche le informazioni che riguardano il fornitore Bianchi.

== Dipendenze funzionali #index-main("Dipendenza funzionale")
Una dipendenza funzionale è un vincolo di integrità che lega fra loro i valori degli attributi di una relazione. Prendendo l'esempio precedente: in una istanza di ORDINE, se abbiamo due valori uguali per l'attributo fornitore, quelle due tuple hanno valori uguali anche per l'attributo indirizzo.

Ad ogni schema di relazione sono in genere associate più dipendenze funzionali (individuabili solo considerando il significato degli attributi).
#definition()[
  Dati $R (A_1 , . . . , A_n)$ e $X subset.eq { A_1 , . . . , A_n }$ e $Y subset.eq { A_1 , . . . , A_n }$ si dice che #strong[X determina funzionalmente Y] o che Y dipende funzionalmente da X e si scrive X→Y se $forall$ istanza di $r$ di $R$, $forall$ coppia di tuple $t_1$ e $t_2$ in $r$:

  $
    t_1[X]=t_2[X] => t_1[Y]=t_2[Y]
  $
]

In ogni istanza non ci possono essere due tuple con valori uguali per X e valori diversi per Y.

- Se $Y subset.eq X$ la dipendenza è #strong[banale]#index-main("Dipendenza funzionale", "Banale").
- Se $Y = X$ la dipendenza #strong[banale] si dice anche #strong[identità.]
Dall'esempio precedente abbiamo che:
- num→fornitore
- num→data
- fornitore→indirizzo
- num, articolo→quantita

=== Osservazioni

+ Se $X$ è una superchiave allora $X -> Y space forall Y$ infatti per definizione di superchiave non possono esistere $t_1, t_2$ con $t_1[X]=t_2[X]$
+ Una dipendenza funzionale è una proprietà dello schema e non della singola istanza. Non si può dedurre la validità di una dipendenza funzionale da una istanza, si può verificare che una istanza non viola la dipendenza.
+ Una particolare tabella che verifica l'insieme dei vincoli associati allo schema (e quindi anche le dip. funz. associate) si dice corretta.


== Implicazione #index-main("Implicazione logica")

#definition()[
  Dato un insieme di dipendenze funzionali F

  $
    F space "implica" space X => Y
  $

  se ogni relazione $r$ che soddisfa F soddisfa anche X → Y. L'insieme $F^(+)$ delle dipendenze implicate da F viene detto #strong[chiusura di F]#index-main("Chiusura", [di dipendenze ($F^+$)])

  $
    F^+ = {X => Y | F space "implica" space X => Y }, space F subset.eq F^+
  $
]

Dall'esempio precedente:

ORDINE (num, fornitore, indirizzo, articolo, data, quantita) F ⊃ {num → fornitore, fornitore → indirizzo} si ha che
#strong[F implica num → indirizzo].

=== Assiomi di Armstrong #index-main("Assiomi di Armstrong")

#definition()[

  Dato F, la chiusura $F^(+)$ può essere calcolata applicando ripetutamente a $F$ le tre regole di inferenza dette *Assiomi di Armstrong*:

  - Riflessività#index("Assiomi di Armstrong", "Riflessività"):

    $
      "se" space Y subset.eq X space "allora" space X => Y
    $

  - Arricchimento#index("Assiomi di Armstrong", "Arricchimento"):

    $
      "se" space X => Y space "allora" space X Z => Y Z
    $

  - Transitività#index("Assiomi di Armstrong", "Transitività"):

    $
      "se" space X => Y space "e" space Y => Z space "allora" space X => Z
    $
]

Dagli assiomi di Armstrong derivano anche altre regole di inferenza:

- *Unione*#index("Assiomi di Armstrong", "Unione"): se $X => A_1, X=> A_2,...,X => A_K$ allora $X=> A_1,...,A_k$
- *Decomposizione*#index("Assiomi di Armstrong", "Decomposizione"): se $X=> A_1,...,A_k$ allora $X => A_1, X=> A_2,...,X => A_K$

- Esempio precedente

  IMPIEGATO(codimp, nome, stip, progetto, data ﬁnale) Riﬂessività: {stip, progetto} ⊆ {stip, progetto} quindi

  stip, progetto → stip, progetto

  {progetto} ⊆ {stip, progetto} quindi stip, progetto → progetto Arricchimento: se vale progetto → data ﬁnale allora

  progetto, stip → data ﬁnale, stip

  Transitività: se codimp → progetto e progetto → data ﬁnale allora codimp → data ﬁnale.

=== Problemi dell'implicazione <problemi-dellimplicazione>
Un problema frequente è quello di decidere se una dipendenza funzionale appartiene a $F^(+)$. Per risolverlo possiamo usare un algoritmo che applica ripetutamente gli assiomi di Armstrong ma che ha una complessità esponenziale. (se n è il numero di attributi, $F^(+)$ contiene almeno $2^n - 1$ dip. funz. banali.

Altrimenti possiamo usare un metodo con complessità minore: per decidere se $X => Y in F^+$ si può controllare se $Y subset.eq X_F^(+)$

== Chiusura di un insieme di attributi #index-main("Chiusura", [di attributi ($X^+$)])

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
#proof()[
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
  $R("stud", "corso", "prof", "ora", "aula", "crediti")$

  $F = {"corso" arrow "prof", "ora aula" arrow "corso", "ora prof" arrow "aula", "corso stud" arrow "crediti", "ora stud" arrow "aula"}$

  Calcolo di $X_F^+ = ("ora", "aula")_F^+$

  - $X^0 = {"ora", "aula"}$
  - $X^1 = {"ora", "aula", "corso"}$ per la seconda dipendenza
  - $X^2 = {"ora", "aula", "corso", "prof"}$ per la prima dipendenza
  - $X^3 = {"ora", "aula", "corso", "prof"} = X^2 = X_F^+$

  ---

  $R(A, B, C, D, E, G)$

  $F = {A B arrow C, D arrow E G, C arrow A, B E arrow C, B C arrow D, C G arrow B D, A C D arrow B, C E arrow A G}$

  Calcolo di $X_F^+ = (B D)_F^+$

  - $X^0 = {B, D}$
  - $X^1 = {B, D, E, G}$
  - $X^2 = {B, C, D, E, G}$
  - $X^3 = {A, B, C, D, E, G} = X_F^+$
]


== Definizione di chiave con dipendenze funzionali #index("Chiave", "Definizione formale")

- Dati $R(T)$ e $F, X subset.eq T$ è una chiave se:
  + $F$ implica $x->T$
  + per nessun $Y$ sottoinsieme proprio di $X$ si ha $F$ implica $Y->T$. (Sottoinsieme proprio vuol dire sottoinsieme non coincidente)
- Un insieme $X$ che verifica la proprietà 1 è detto *superchiave* (una chiave è anche una superchiave). Si può dire che una chiave è una superchiave non ridondante.
- La proprietà 1 può essere verifica controllando se $T=X_F^+$.
- Dati $R(T)$ e $F,T$ è sempre una superchiave (talvolta è anche l'unica chiave).

#example(multiple: true)[
  *ORDINE(num, fornitore, indirizzo, articolo, data, quantita)*

  $F = {"num" arrow "fornitore data", "fornitore" arrow "indirizzo", "num articolo" arrow "quantita"}$

  Chiave $K$: $("num", "articolo")$

  - $K^0 = {"num", "articolo"}$
  - $K^1 = {"num", "articolo", "fornitore", "data"}$ per la I dip.
  - $K^2 = {"num", "articolo", "fornitore", "data", "indirizzo"}$ per la II dip.
  - $K^3 = {"num", "articolo", "fornitore", "data", "indirizzo", "quantita"}$ per la III dip.

  Quindi la coppia (num, articolo) è una superchiave. Se ripetiamo il procedimento a partire solo da _num_ otteniamo ${"num", "fornitore", "data", "indirizzo"}$, quindi _num_ non è chiave. Se ripetiamo il procedimento a partire solo da _articolo_ otteniamo ${"articolo"}$, quindi _articolo_ non è chiave.

  ---

  *FREQ(cod_stud, nome, indirizzo, cod_corso, nome_corso, tipo, periodo)*

  $F = {"cod_stud" arrow "nome indirizzo", "cod_corso" arrow "nome_corso tipo periodo"}$

  Chiave $K$: $("cod_stud", "cod_corso")$

  - $K^0 = {"cod_stud", "cod_corso"}$
  - $K^1 = {"cod_stud", "cod_corso", "nome", "indirizzo"}$ per la I dip.
  - $K^2 = {"cod_stud", "cod_corso", "nome", "indirizzo", "nome_corso", "tipo", "periodo"}$ per la II dip.

  Quindi $("cod_stud", "cod_corso")$ è superchiave; inoltre è chiave perché non è ridondante: da _cod_stud_ si ottiene solo ${"cod_stud", "nome", "indirizzo"}$, da _cod_corso_ si ottiene solo ${"cod_corso", "nome_corso", "tipo", "periodo"}$.

  ---

  *INDIRIZZO(citta, strada, CAP)*

  $F = {"citta strada" arrow "CAP", "CAP" arrow "citta"}$

  - ad ogni coppia (citta, strada) corrisponde un solo CAP
  - ad ogni CAP corrisponde una sola citta

  Chiave $K_1$: $("citta", "strada")$

  - $K_1^0 = {"citta", "strada"}$
  - $K_1^+ = {"citta", "strada", "CAP"}$ per la I dipendenza
  - e la coppia (citta, strada) non è ridondante

  Chiave $K_2$: $("strada", "CAP")$

  - $K_2^0 = {"strada", "CAP"}$
  - $K_2^+ = {"strada", "CAP", "citta"}$ per la II dipendenza
  - e la coppia (strada, CAP) non è ridondante.
]

== Equivalenze #index-main("Equivalenza di dipendenze funzionali")
Per operare su insiemi di dipendenze fa comodo ridurli in forme minimali. Per fare ciò si introducono i concetti di *equivalenza* e *copertura*. L'equivalenza tra due schemi di relazione permette di determinare quando essi rappresentano gli stessi fatti.

#definition()[
  Gli insiemi di dipendenze funzionali $F$ e $G$ sono *equivalenti*, $F equiv G$, se
  - $F^+=G^+$ ovvero
  - $F subset.eq G^+$ e $G subset.eq F^+$ ovvero
  - $G$ implica ogni dipendenza in $F$ e viceversa
  Se $F equiv G$, $F$ è detto *copertura*#index-main("Copertura") di $G$ e viceversa.
]

#example()[
  $R("imp", "ind", "tel")$

  $F = {"imp" arrow "tel", "imp" arrow "ind"}$

  $G = {"imp ind" arrow "tel", "imp" arrow "ind"}$

  - $F subset.eq G^+$: infatti $"imp" arrow "tel" in.not G$ ma $G$ implica $"imp" arrow "tel"$ poiché $"tel" in "imp"_G^+$
  - $G subset.eq F^+$: infatti $"imp ind" arrow "tel" in.not F$ ma $F$ implica $"imp ind" arrow "tel"$ poiché $"tel" in ("imp ind")_F^+$
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
  *CORSO(codice, nome, CFU)*

  $F = {"codice" arrow "nome", "codice nome" arrow "CFU", "codice" arrow "CFU"}$

  $F$ è *ridondante*, infatti:
  - $F equiv F - {"codice" arrow "CFU"}$ ovvero
  - $(F - {"codice" arrow "CFU"})$ implica $"codice" arrow "CFU"$ ovvero
  - $"codice" arrow "CFU" in (F - {"codice" arrow "CFU"})^+$ ovvero
  - $"CFU" in "codice"^+_(F - {"codice" arrow "CFU"})$

  $F_1 = {"codice" arrow "nome", "codice nome" arrow "CFU"}$

  $F_1$ *non è ridotto*, infatti:
  - $(F_1 - {"codice nome" arrow "CFU"}) union {"codice" arrow "CFU"} equiv F_1$ ovvero
  - $F_1$ implica $"codice" arrow "CFU"$ ovvero
  - $"codice" arrow "CFU" in F_1^+$ ovvero
  - $"CFU" in "codice"^+_(F_1)$

  $F_2 = {"codice" arrow "nome", "codice" arrow "CFU"}$ è *ridotto*
]


=== Calcolo copertura ridotta #index-main("Copertura", "Minimale (ridotta)")

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
  *STUD(matr, nome, fascia_reddito, tasse, cdl, presidente, progetto, tutor)*

  $F = {"matr" arrow "fascia_reddito tasse cdl presidente", "fascia_reddito" arrow "tasse", "matr presidente" arrow "nome cdl", "cdl" arrow "presidente", "presidente" arrow "cdl", "matr progetto cdl" arrow "tutor matr"}$

  Una copertura ridotta è:

  $F = {"matr" arrow "fascia_reddito", "matr" arrow "cdl", "fascia_reddito" arrow "tasse", "matr" arrow "nome", "presidente" arrow "cdl", "cdl" arrow "presidente", "matr progetto" arrow "tutor"}$

  *Attenzione*: la verifica del passo 2) dell'algoritmo va fatta rispetto all'insieme $F$ che contiene la dipendenza sotto esame (si veda ad esempio la dipendenza $"matr presidente" arrow "nome"$ in cui _presidente_ risulta ridondante).

  ---

  Decomposizione di $F$ con un attributo per ogni dipendenza:

  + $"matr" arrow "fascia_reddito"$
  + $"matr" arrow "tasse"$
  + $"matr" arrow "cdl"$
  + $"matr" arrow "presidente"$
  + $"fascia_reddito" arrow "tasse"$
  + $"matr presidente" arrow "nome"$
  + $"matr presidente" arrow "cdl"$
  + $"cdl" arrow "presidente"$
  + $"presidente" arrow "cdl"$
  + $"matr progetto cdl" arrow "tutor"$
  + $"matr progetto cdl" arrow "matr"$ è una dipendenza ovvia

  ---

  Devono essere esaminate le dipendenze (6), (7) e (10):

  - (6) $"matr presidente" arrow "nome"$ diventa $"matr" arrow "nome"$
  - (7) $"matr presidente" arrow "cdl"$ diventa $"presidente" arrow "cdl"$
  - (10) $"matr progetto cdl" arrow "tutor"$ diventa $"matr progetto" arrow "tutor"$

  - In (6) l'attributo _matr_ non è ridondante dato che $"nome" in.not ("presidente")_F^+ = {"presidente", "cdl"}$ mentre _presidente_ è ridondante dato che $"nome" in ("matr")_F^+ = {"matr", "fascia_reddito", "tasse", "cdl", "presidente", "nome"}$
  - In (7) si elimina _matr_ dato che $"cdl" in ("presidente")_F^+$
  - In (10) si elimina _cdl_ dato che $"tutor" in ("matr", "progetto")_F^+ = {"matr", "progetto", "fascia_reddito", "tasse", "cdl", "presidente", "nome", "tutor"}$ e non si possono eliminare altri attributi.

  ---

  + $"matr" arrow "fascia_reddito"$
  + $"matr" arrow "tasse"$ *si elimina per (1) e (5)*
  + $"matr" arrow "cdl"$
  + $"matr" arrow "presidente"$ *si elimina per (3) e (8)*
  + $"fascia_reddito" arrow "tasse"$
  + $"matr" arrow "nome"$
  + $"presidente" arrow "cdl"$
  + $"cdl" arrow "presidente"$
  + $"presidente" arrow "cdl"$ *si elimina perché identica a (7)*
  + $"matr progetto" arrow "tutor"$
]


== Decomposizione di relazioni #index-main("Decomposizione")
Per eliminare anomalie da uno schema mal definito si cerca di decomporlo in schemi più piccoli che godono di particolari proprietà (forme normali) ma sono in qualche senso equivalenti allo schema originale. Si richiede in genere che lo schema soddisfi due condizioni indipendenti fra loro: preservi i dati e preservi le dipendenze.

#definition()[
  Data $r$ di schema $R(T)$, siano $T_1$ e $T_2$ due sottoinsiemi di $T$ tali che $T_1 union T_2 = T$.

  Una *decomposizione* $d$ di $r$ in due relazioni, secondo gli attributi $T_1$ e $T_2$, è la coppia di relazioni $r_1$ e $r_2$ che si ottengono effettuando la proiezione di $r$ su $T_1$ e $T_2$ rispettivamente:
  $ d = (r_1 = pi_(T_1)(r), r_2 = pi_(T_2)(r)) $

  In generale una decomposizione di $r$ secondo gli attributi $T_1, T_2, dots, T_k$ (con $T_1 union T_2 union dots union T_k = T$) può essere ottenuta applicando in modo iterativo una decomposizione in due.
]

=== Decomposizione senza perdita #index-main("Decomposizione", "Senza perdita")

#definition()[
  Data $r$ di schema $R(T)$, $T_1$ e $T_2$ tali che $T_1 union T_2 = T$, la decomposizione $d = (r_1 = pi_(T_1)(r), r_2 = pi_(T_2)(r))$ è *senza perdita* se:
  $ r_1 join r_2 = r $
]

Si dice anche che la decomposizione *mantiene i dati*. Quando si effettua una decomposizione senza perdita è quindi possibile ricostruire la relazione originaria.

Per avere una decomposizione senza perdita è necessario che $T_1$ e $T_2$ non siano disgiunti: $(T_1 inter T_2) eq.not emptyset$.

La condizione $(T_1 inter T_2) eq.not emptyset$ non assicura una decomposizione senza perdita. Se $(T_1 inter T_2) eq.not emptyset$ si ha $r subset.eq r_1 join r_2$.

- Esempio con perdita

  #example()[
    $R("forn", "ind", "articolo", "prezzo")$, \
    $F = {"forn" arrow "ind", "forn articolo" arrow "prezzo"}$ \
    $T_1 = {"forn", "ind", "articolo"}$, $T_2 = {"articolo", "prezzo"}$

    #figure(
      table(
        columns: 4,
        fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
        table.header([*forn*], [*ind*], [*articolo*], [*prezzo*]),
        [Rossi], [Prato], [libro], [3],
        [Verdi], [Prato], [penna], [2],
        [Rossi], [Prato], [penna], [2],
        [Verdi], [Prato], [libro], [1],
      ),
    )

    #figure(
      grid(
        columns: 2,
        gutter: 2em,
        table(
          columns: 3,
          fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
          table.header([*forn*], [*ind*], [*articolo*]),
          [Rossi], [Prato], [libro],
          [Verdi], [Prato], [penna],
          [Rossi], [Prato], [penna],
          [Verdi], [Prato], [libro],
        ),
        table(
          columns: 2,
          fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
          table.header([*articolo*], [*prezzo*]),
          [libro], [3],
          [penna], [2],
          [libro], [1],
        ),
      ),
    )
    $ r subset.eq r_1 join r_2 $

    ---

    $R("stud", "corso", "prof")$, $F = {"dipendenze banali"}$ \
    $T_1 = {"stud", "corso"}$, $T_2 = {"corso", "prof"}$

    Questa decomposizione non è senza perdita, infatti:
    $ "corso" = {"stud", "corso"} inter {"corso", "prof"} $
    $ "NOT"("corso" arrow "stud corso") $
    $ "NOT"("corso" arrow "corso prof") $

    #figure(
      table(
        columns: 3,
        fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
        table.header([*stud*], [*corso*], [*prof*]),
        [Rossi], [BDSI], [Cesarini],
        [Verdi], [BDSI], [Merlini],
      ),
    )
    $ r subset r_1 join r_2 $
  ]

#theorem()[
  Data $r$ di schema $R(T)$, $T_1$ e $T_2$ tali che $T_1 union T_2 = T$, sia $X = T_1 inter T_2$, la decomposizione $d = (r_1 = pi_(T_1)(r), r_2 = pi_(T_2)(r))$ è senza perdita se $r$ soddisfa $X arrow T_1$ oppure $X arrow T_2$.
]

#theorem()[
  Dati $R(T)$ e $F$, $T_1$ e $T_2$ tali che $T_1 union T_2 = T$, sia $X = T_1 inter T_2$, ogni $r$ che soddisfa $F$ può essere decomposta senza perdita secondo $T_1$ e $T_2$ se:
  $ X arrow T_1 in F^+ space "oppure" space X arrow T_2 in F^+ $
]

La condizione precedente è vera se $X$ è superchiave di $R_1(T_1)$ oppure di $R_2(T_2)$. Si può anche dire che in questo caso la decomposizione dello schema $R(T)$ nei due schemi $R_1(T_1)$ e $R_2(T_2)$ è senza perdita.

- Esempio senza perdita

  #example()[
    $R("forn", "ind", "articolo", "prezzo")$ \
    $F = {"forn" arrow "ind", "forn articolo" arrow "prezzo"}$ \
    $T_1 = {"forn", "ind"}$, $T_2 = {"forn", "articolo", "prezzo"}$, $T_1 inter T_2 arrow T_1 in F^+$

    #figure(
      table(
        columns: 4,
        fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
        table.header([*forn*], [*ind*], [*articolo*], [*prezzo*]),
        [Rossi], [Prato], [libro], [3],
        [Verdi], [Prato], [penna], [2],
        [Rossi], [Prato], [penna], [2],
        [Verdi], [Prato], [libro], [1],
      ),
    )

    #figure(
      grid(
        columns: 2,
        gutter: 2em,
        table(
          columns: 2,
          fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
          table.header([*forn*], [*ind*]),
          [Rossi], [Prato],
          [Verdi], [Prato],
        ),
        table(
          columns: 3,
          fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
          table.header([*forn*], [*articolo*], [*prezzo*]),
          [Rossi], [libro], [3],
          [Verdi], [penna], [2],
          [Rossi], [penna], [2],
          [Verdi], [libro], [1],
        ),
      ),
    )
    $ r = r_1 join r_2 $
  ]

== Proiezione delle dipendenze <proiezione-delle-dipendenze> #index-main("Proiezione delle dipendenze")

#definition()[
  Dati $R(T)$, $F$ e $T_1 subset.eq T$, la *proiezione* di $F$ su $T_1$ è l'insieme delle dipendenze appartenenti a $F^+$ che coinvolgono gli attributi di $T_1$:
  $ pi_(T_1)(F) = {X arrow Y in F^+ bar X subset.eq T_1, Y subset.eq T_1} $
]

- $"IMP"("codice", "qualifica", "stip")$,
  $F = {"codice" arrow "qualifica", "qualifica" arrow "stip"}$ \
  $pi_("codice stip")(F) = {"codice" arrow "stip"} union {"dipendenze ovvie"}$
- $R("forn", "ind", "articolo", "prezzo")$,
  $F = {"forn" arrow "ind", "forn articolo" arrow "prezzo"}$ \
  $pi_("forn ind")(F) = {"forn" arrow "ind"} union {"dipendenze ovvie"}$ \
  $pi_("forn ind articolo")(F) = {"forn" arrow "ind"} union {"dipendenze ovvie"}$ \
  $pi_("forn articolo")(F) = {"dipendenze ovvie"}$
- $"INDIRIZZO"("citta", "via", "CAP")$,
  $F = {"citta via" arrow "CAP", "CAP" arrow "citta"}$ \
  $pi_("via CAP")(F) = {"dipendenze ovvie"}$ \
  $pi_("citta CAP")(F) = {"CAP" arrow "citta"} union {"dipendenze ovvie"}$

== Conservazione delle dipendenze <conservazione-delle-dipendenze> #index-main("Conservazione delle dipendenze")

#definition()[
  Dati $R(T)$ e $F$, la decomposizione in $R_1(T_1)$ e $R_2(T_2)$ *conserva le dipendenze* se:
  $ F equiv pi_(T_1)(F) union pi_(T_2)(F) $
]

- Decomposizione che conserva le dipendenze: \
  $"IMP"("cod", "nome", "qualifica", "stip")$ \
  $F = {"cod" arrow "nome qualifica stip", "qualifica" arrow "stip"}$ \
  $"IMP"_1("cod", "nome", "qualifica")$, $pi_(T_1)(F) = {"cod" arrow "nome qualifica"}$ \
  $"IMP"_2("qualifica", "stip")$, $pi_(T_2)(F) = {"qualifica" arrow "stip"}$
- Decomposizione che non conserva le dipendenze: \
  $"IMP"("cod", "nome", "qualifica", "stip")$ \
  $F = {"cod" arrow "nome qualifica stip", "qualifica" arrow "stip"}$ \
  $"IMP"_1("cod", "nome", "qualifica")$, $pi_(T_1)(F) = {"cod" arrow "nome qualifica"}$ \
  $"IMP"_2("cod", "stip")$, $pi_(T_2)(F) = {"cod" arrow "stip"}$

- Esempi

  #example()[
    $"IMP"("cod", "nome", "progetto", "budget")$ \
    $F = {"cod" arrow "nome progetto budget", "progetto" arrow "budget"}$

    - $d = {R_1("cod", "nome", "progetto"), R_2("cod", "budget")}$
      - $d$ è senza perdita poiché $T_1 inter T_2 = "cod"$ è chiave di $R_1$ (e di $R_2$)
      - $pi_(T_1)(F) = {"cod" arrow "nome progetto"} union {"dip. ovvie"}$
      - $pi_(T_2)(F) = {"cod" arrow "budget"} union {"dip. ovvie"}$
      - $d$ *non conserva le dipendenze* poiché $("progetto" arrow "budget") in.not (union.big_i pi_(T_i)(F))^+$

    - $d = {R_1("cod", "nome", "progetto"), R_2("progetto", "budget")}$
      - $d$ è senza perdita poiché $T_1 inter T_2 = "progetto"$ è chiave di $R_2$
      - $d$ *conserva le dipendenze* poiché $F equiv (union.big_i pi_(T_i)(F))$

    ---

    $"INDIRIZZO"("citta", "via", "CAP")$ \
    $F = {"citta via" arrow "CAP", "CAP" arrow "citta"}$

    - $d = {R_1("citta", "CAP"), R_2("via", "CAP")}$
      - $d$ è senza perdita poiché $T_1 inter T_2 = "CAP"$ è chiave di $R_1$
      - $d$ non conserva le dipendenze poiché $(union.big_i pi_(T_i)(F)) = {"CAP" arrow "citta"} union {"dip. ovvie"}$
    - Si può verificare che $d$ è l'unica decomposizione di $"INDIRIZZO"$ senza perdita.
    - Non si può trovare una decomposizione di $"INDIRIZZO"$ che sia senza perdita e conservi le dipendenze.

    ---

    Esempio di decomposizione che conserva le dipendenze ma non è senza perdita: \
    $R("forn", "ind", "articolo", "colore")$ \
    $F = {"forn" arrow "ind", "articolo" arrow "colore"}$ \
    $d = {R_1("forn", "ind"), R_2("articolo", "colore")}$

    - $d$ non è senza perdita: $T_1 inter T_2 = emptyset$
    - $d$ conserva le dipendenze: $pi_("forn, ind")(F) union pi_("articolo, colore")(F) = {"forn" arrow "ind"} union {"articolo" arrow "colore"} = F$
  ]

= Forme normali <forme-normali> #index-main("Forme normali")
== Prima forma normale <prima-forma-normale> #index-main("Forme normali", "1NF (Prima forma normale)")

#definition()[
  Una relazione è in prima forma normale (1NF) se ogni attributo è definito su un dominio atomico.
]

Altri modelli per basi di dati (ad esempio il modello a oggetti o il modello relazionale a oggetti) consentono la definizione di attributi su domini non atomici quali vettori, insiemi, identificatori di oggetto.

#example()[
  $"DIPARTIMENTO"("id", "nome", "sedi")$

  #figure(
    table(
      columns: 3,
      fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
      table.header([*id*], [*nome*], [*sedi*]),
      [10], [Ricerca], [{Firenze, Roma, Napoli}],
      [20], [Amministrazione], [{Pisa}],
      [30], [Sede centrale], [{Roma}],
    ),
  )
  Non è in 1NF perché l'attributo _sedi_ non è atomico (è un insieme di valori).
]

== Seconda forma normale <seconda-forma-normale> #index-main("Forme normali", "2NF (Seconda forma normale)")

#definition()[Una relazione è in seconda forma normale (2NF) se non ci sono dipendenze parziali dalla chiave. Un attributo dipende parzialmente dalla chiave se dipende da un sottoinsieme proprio di essa. ]

Attualmente il concetto di seconda forma normale non è utilizzato nella progettazione di basi dati relazionali, mentre sono ampiamente utilizzati i concetti di terza forma normale e forma normale di Boyce Codd.

#example()[
  $R("forn", "ind", "articolo", "prezzo")$ \
  $F = {"forn" arrow "ind", "forn articolo" arrow "prezzo"}$, la chiave è $("forn articolo")$ e _ind_ dipende parzialmente da essa.

  #figure(
    table(
      columns: 4,
      fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
      table.header([*forn*], [*ind*], [*articolo*], [*prezzo*]),
      [10], [Pisa], [Lapis], [1],
      [10], [Pisa], [Penna], [2],
      [20], [Firenze], [Lapis], [2],
      [30], [Lucca], [Gomma], [1],
      [30], [Lucca], [Lapis], [1],
    ),
    caption: [Relazione non in 2NF],
  )
]

== Terza forma normale <terza-forma-normale> #index-main("Forme normali", "3NF (Terza forma normale)")

#definition()[
  Dati $R(T)$ e $F$, $R$ è in *terza forma normale (3NF)* se per ogni dipendenza funzionale $X arrow A$ non banale definita su di essa (ovvero $forall X arrow A$ tale che $X arrow A in F^+$ and $not (A subset.eq X)$) vale una delle seguenti condizioni:
  + $X$ è superchiave
  + $A$ è un attributo primo (ovvero un attributo appartenente a una chiave)
]

- La definizione fa riferimento a dipendenze con a destra un solo attributo perché ogni dipendenza $X arrow A_1 A_2 dots A_k$ può essere decomposta nell'insieme $\{X arrow A_1, X arrow A_2, dots, X arrow A_k\}$.
- Si può dimostrare che ogni relazione 3NF è anche 2NF.

- Esempi

  #example()[
    $"INDIRIZZO"("citta", "via", "CAP")$ \
    $F = {"citta via" arrow "CAP", "CAP" arrow "citta"}$ \
    $K_1 = "citta via"$, $K_2 = "CAP via"$ \
    $"INDIRIZZO"$ è in terza forma normale perché:
    - $"citta via" arrow "CAP"$ ha a sinistra una chiave
    - $"CAP" arrow "citta"$ ha a destra un attributo primo

    ---

    $"IMP"("codice", "nome", "ufficio", "capo_ufficio")$ \
    $F = {"codice" arrow "nome", "codice" arrow "ufficio", "ufficio" arrow "capo_ufficio"}$ \
    $K = "codice"$ \
    $"IMP"$ non è in 3NF perché la dipendenza $"ufficio" arrow "capo_ufficio"$ non verifica nessuna delle due condizioni.
  ]

=== Decomposizione in terza forma normale <decomposizione-in-terza-forma-normale>
Una relazione non in terza forma normale presenta ridondanze e anomalie. Consideriamo ad esempio la relazione IMP vista sopra, se ci sono 10 impiegati ufficio progettazione, il nome del capo ufficio viene ripetuto 10 volte. In realtà forme di ridondanza tollerate possono essere presenti anche in 3NF

Una relazione non in terza forma normale può sempre essere decomposta, senza perdita e conservando le dipendenze, in relazioni in terza forma normale. La decomposizione di cui sopra può essere ottenuta con l'algoritmo di sintesi.

=== Algoritmo di sintesi per 3NF <algoritmo-di-sintesi-per-3nf> #index-main("Algoritmo di sintesi (3NF)")

#definition("Algoritmo di sintesi per 3NF")[
  - *Input*: $R(T), F$
  - *Output*: decomposizione $R_1(T_1), dots, R_n(T_n)$ con $R_i(T_i)$ in 3NF, senza perdita e che mantiene le dipendenze.

  + Calcola una copertura ridotta $G$ di $F$.
  + Sostituisci ogni insieme di dipendenze $X arrow A_1, X arrow A_2, dots, X arrow A_k$ con la dipendenza $X arrow A_1 A_2 dots A_k$.
  + Per ogni dipendenza $X arrow Y$ costruisci uno schema di attributi $X Y$ a cui viene associata la dipendenza $X arrow Y$.
  + Se uno schema ha gli attributi che sono un sottoinsieme proprio degli attributi di un altro schema eliminalo (ovvero se $R_i(T_i)$ e $R_j(T_j)$ con $T_i subset T_j$, elimina $R_i(T_i)$ e aggiungi le dipendenze associate a $R_i(T_i)$ a quelle di $R_j(T_j)$).
  + Se nessun $T_i$ contiene una chiave dello schema $R(T)$, aggiungi alla decomposizione lo schema $R_w(W)$ con $W$ chiave di $R(T)$.
]

L'algoritmo ha complessità polinomiale, pari a quella per il calcolo della copertura ridotta. La decomposizione mantiene le dipendenze per come vengono costruiti gli schemi a partire dalle dipendenze stesse.

- Esempi

  #example()[
    $R("fornitore", "indirizzo", "tel", "articolo", "colore")$ \
    $F = {"fornitore" arrow "indirizzo tel", "articolo" arrow "colore"}$ \
    Chiave: $("fornitore articolo")$

    + $G = {"fornitore" arrow "indirizzo", "fornitore" arrow "tel", "articolo" arrow "colore"}$
    + $G = {"fornitore" arrow "indirizzo tel", "articolo" arrow "colore"}$
    + $R_1("fornitore", "indirizzo", "tel")$, $F_1 = {"fornitore" arrow "indirizzo tel"}$ \
      $R_2("articolo", "colore")$, $F_2 = {"articolo" arrow "colore"}$
    + La decomposizione rimane inalterata
    + Viene aggiunto alla decomposizione $R_3("fornitore", "articolo")$

    In assenza del passo 5 avremmo avuto due schemi disgiunti.

    ---

    $R(A, B, C, D)$ \
    $F = {A B arrow C, C arrow D, D arrow B}$ \
    Chiave: $(A B)$ \
    Lo schema non è in 3NF a causa della dipendenza $C arrow D$. L'algoritmo di sintesi produce la decomposizione:
    - $R_1(T_1) = R_1(A, B, C)$ con $F_1 = {A B arrow C}$
    - $R_2(T_2) = R_2(C, D)$ con $F_2 = {C arrow D}$
    - $R_3(T_3) = R_3(D, B)$ con $F_3 = {D arrow B}$

    Si osservi che $F_2 = pi_(T_2)(F)$, $F_3 = pi_(T_3)(F)$ mentre $F_1 eq.not pi_(T_1)(F) = {A B arrow C, C arrow B}$.
  ]

== Forma normale di Boyce Codd <forma-normale-di-boyce-codd> #index-main("Forme normali", "BCNF (Boyce-Codd)")

#definition()[
  Dati $R(T)$ e $F$, $R$ è in *forma normale di Boyce Codd (BCNF)* se per ogni dipendenza funzionale $X arrow Y$ non banale definita su di essa, $X$ è superchiave.
]

Ogni relazione non in forma normale di Boyce Codd può essere decomposta in relazioni BCNF senza perdita. Esistono relazioni non in forma normale di Boyce Codd che non è possibile decomporre in relazioni BCNF mantenendo le dipendenze.

- Ogni relazione in forma di Boyce Codd è anche in terza forma normale.
- Una relazione non BCNF presenta ridondanze e anomalie.

- Esempi

  #example()[
    $"ORDINE"("num", "fornitore", "indirizzo", "tel", "articolo", "data", "quantita")$ \
    $F = {"num" arrow "fornitore data", "fornitore" arrow "indirizzo tel", "num articolo" arrow "quantita"}$ \
    Chiave: $("num articolo")$ \
    $"ORDINE"$ non è in BCNF a causa della prima e della seconda dipendenza; presenta ridondanze e anomalie e non è neanche 3NF.

    ---

    $"IMPIEGATO"("codice", "nome", "indirizzo", "qualifica", "stipendio_base")$ \
    $F = {"codice" arrow "nome indirizzo qualifica", "qualifica" arrow "stipendio_base"}$ \
    Chiave: $("codice")$ \
    $"IMPIEGATO"$ non è BCNF (e neanche 3NF): ha ridondanze e anomalie (per tutti gli impiegati con la stessa qualifica viene ripetuto lo stipendio base).

    ---

    $"INDIRIZZO"("citta", "via", "CAP")$ \
    $F = {"citta via" arrow "CAP", "CAP" arrow "citta"}$ \
    $"INDIRIZZO"$ non è BCNF (è 3NF ma non BCNF perché $"CAP"$ non è superchiave).

    ---

    $"VISITE"("specializzazione", "medico", "data")$ \
    $F = {"specializzazione data" arrow "medico", "medico" arrow "specializzazione"}$ \
    $"VISITE"$ non è BCNF (si notino le ridondanze):

    #figure(
      table(
        columns: 3,
        fill: (x, y) => if y == 0 { rgb("#ff8c00") } else if calc.even(y) { white } else { rgb("#f0f0f0") },
        table.header([*specializzazione*], [*medico*], [*data*]),
        [oculista], [Neri], [10/12/13],
        [oculista], [Neri], [13/12/13],
        [oculista], [Neri], [14/12/13],
        [otorino], [Bianchi], [10/12/13],
        [oculista], [Verdi], [12/12/13],
        [dentista], [Rossi], [10/12/13],
      ),
    )
  ]

=== Algoritmo di analisi per BCNF <algoritmo-di-analisi-per-bcnf> #index-main("Algoritmo di analisi (BCNF)")

#definition("Algoritmo di analisi per BCNF")[
  - *Input*: $R(T_1, F_1)$ con $F_1$ in forma ridotta (in realtà è sufficiente che non si abbiano dipendenze ridondanti e che tutti i membri sinistri siano non ridondanti)
  - *Output*: $rho$, decomposizione di $R$ in BCNF che preserva i dati

  + $rho = {R(T_1, F_1)}$ e $k = 1$
  + *while* esiste $R_i(T_i, F_i) in rho$ non in BCNF per la dipendenza $X arrow Y$ *do*:
    - $k = k + 1$
    - $T_a = X^+$ e $F_a = pi_(T_a)(F_i)$
    - $T_b = T_i - T_a union X$ e $F_b = pi_(T_b)(F_i)$
    - $rho = rho - R_i(T_i, F_i) + {R_i(T_a, F_a), R_k(T_b, F_b)}$
    *end do*
]

L'algoritmo ha complessità esponenziale, a causa del calcolo delle proiezioni delle dipendenze funzionali.

#definition("Algoritmo calcolo delle proiezioni")[
  - *Input*: $R < T, F >$ e $T_i subset.eq T$
  - *Output*: una copertura della proiezione di $F$ su $T_i$
  - *begin* \
    *for each* $Y subset.eq T_i$ *do* \
    #h(1em) *begin* \
    #h(2em) $Z := Y_F^+$ \
    #h(2em) restituisci $Y arrow (Z inter T_i)$ \
    #h(1em) *end* \
    *end*
]

- Esempi

  #example()[
    $R(T) = R(A, B, C, D)$ \
    $F = {A B arrow C, C arrow D, D arrow B}$ \
    Chiave: $(A B)$ \
    Lo schema non è in BCNF per $C arrow D$ e $D arrow B$. Partendo dalla dipendenza $C arrow D$ si ha:
    - $T_1 = C_F^+ = {C, D, B}$ quindi $R_1(C, D, B)$ con $F_1 = pi_(T_1)(F) = {C arrow D, D arrow B}$ che non è BCNF per $D arrow B$
    - $T_2 = T - T_1 + C = {A, C}$ quindi $R_2(A, C)$ con $F_2 = {"dipendenze ovvie"}$
    - $T_11 = D_(F_1)^+ = {D, B}$ quindi $R_11(D, B)$ con $F_11 = pi_(T_11)(F_1) = {D arrow B}$
    - $T_12 = T_1 - T_11 + D = {C, D}$ quindi $R_12(C, D)$ con $F_12 = pi_(T_12)(F_1) = {C arrow D}$

    La decomposizione non preserva le dipendenze.

    ---

    $"IMPIEGATO"("codice", "nome", "ind", "qualifica", "stipendio_base")$ \
    $F = {"codice" arrow "nome ind qualifica", "qualifica" arrow "stipendio_base"}$
    - $"IMPIEGATO"$ non è BCNF a causa dell'ultima dipendenza
    - $R_1("qualifica", "stipendio_base")$, $F_1 = {"qualifica" arrow "stipendio_base"}$
    - $R_2("codice", "nome", "ind", "qualifica")$, $F_2 = {"codice" arrow "nome ind qualifica"}$
    - $R_2$ è BCNF quindi il procedimento termina.
    Si può verificare che questa decomposizione mantiene anche le dipendenze.

    ---

    $"ELENCO"("fornitore", "indirizzo", "tel", "articolo", "prezzo")$ \
    $F = {"fornitore" arrow "indirizzo tel", "fornitore articolo" arrow "prezzo"}$
    - $"ELENCO"$ non è BCNF a causa della prima dipendenza
    - $R_1("fornitore", "indirizzo", "tel")$, $F_1 = {"fornitore" arrow "indirizzo tel"}$
    - $R_2("fornitore", "articolo", "prezzo")$, $F_2 = {"fornitore articolo" arrow "prezzo"}$
    - $R_2$ è BCNF quindi il procedimento termina.
    Si può verificare che questa decomposizione mantiene anche le dipendenze.

    ---

    $"ORDINE"("num", "fornitore", "indirizzo", "tel", "articolo", "data", "quantita")$ \
    $F = {"num articolo" arrow "quantita", "fornitore" arrow "indirizzo telefono", "num" arrow "fornitore data"}$
    - $"ORDINE"$ non è BCNF a causa della seconda dipendenza
    - $R_1("fornitore", "indirizzo", "tel")$, $F_1 = {"fornitore" arrow "indirizzo tel"}$
    - $R_2("num", "fornitore", "articolo", "data", "quantita")$, $F_2 = {"num articolo" arrow "quantita", "num" arrow "fornitore data"}$
    - $R_2$ non è BCNF a causa della seconda dipendenza
    - $R_2'("num", "fornitore", "data")$, $F_2' = {"num" arrow "fornitore data"}$
    - $R_3("num", "articolo", "quantita")$, $F_3 = {"num articolo" arrow "quantita"}$

    $R_1("fornitore", "indirizzo", "tel")$, $F_1 = {"fornitore" arrow "indirizzo tel"}$ \
    $R_2("num", "fornitore", "data")$, $F_2 = {"num" arrow "fornitore data"}$ \
    $R_3("num", "articolo", "quantita")$, $F_3 = {"num articolo" arrow "quantita"}$ \
    Si può verificare che questa decomposizione mantiene anche le dipendenze.
  ]

=== NOTE <note>
La trasformazione in forma normale di Boyce e Codd preserva i dati ma non sempre garantisce la conservazione delle dipendenze. La trasformazione 3NF è meno forte della BCNF e quindi non offre le medesime garanzie di qualità per una relazione, accettando anche schemi con anomalie: ha però il vantaggio di essere sempre ottenibile e di mantenere sia i dati che le dipendenze. Una decomposizione tesa ad ottenere la 3NF produce in molti casi schemi BCNF.
