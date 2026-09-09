#import "../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

#pagebreak()

= Algebra relazionale #index-main("Algebra relazionale")

E' un insieme di operatori logici su relazioni che producono a loro volta relazioni e che possono essere composti:

- Unione#index-main("Operatori", "Unione"), intersezione#index-main("Operatori", "Intersezione"), differenza#index-main("Operatori", "Differenza")
- Ridenominazione#index("Operatori", "Ridenominazione")
- Selezione#index("Operatori", "Selezione")
- Proiezione#index("Operatori", "Proiezione")
- Join (naturale, prodotto cartesiano, theta-join)#index("Operatori", "Join")

Ricordando che le relazioni sono insiemi, anche i risultati di queste operazioni devono sempre essere relazioni. Le op. di unione, intersezione e differenza possono essere applicate solo ad relazioni su gli stessi attributi.

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 { rgb("#aee4e4") }
        else if y == 1 { rgb("#aee4e4") }
        else if (y == 2 or y == 3) { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*LAUREATI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [7274], [Rossi], [42],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 { rgb("#aee4e4") }
        else if y == 1 { rgb("#aee4e4") }
        else if (y == 2 or y == 3) { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*SPECIALISTI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [9297], [Neri], [33],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 { rgb("#aee4e4") }
        else if y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*LAUREATI $inter$ SPECIALISTI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
  ),
  caption: "Esempio intersezione",
)
#figure(
  grid(
    columns: 3,
    gutter: 1em,
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*LAUREATI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [7274], [Rossi], [42],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*SPECIALISTI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [9297], [Neri], [33],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 3 or y == 4 { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*LAUREATI $minus$ SPECIALISTI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [7274], [Rossi], [42],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
  ),
  caption: "Esempio differenza",
)
#figure(
  grid(
    columns: 3,
    gutter: 1em,
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*LAUREATI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [7274], [Rossi], [42],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*SPECIALISTI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [9297], [Neri], [33],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 2 or y == 3 or y == 4 { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*LAUREATI $union$ SPECIALISTI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [7274], [Rossi], [42],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
      [9297], [Neri], [33],
    ),
  ),
  caption: "Esempio unione",
)
#figure(
  grid(
    columns: 2,
    gutter: 2em,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*PATERNITA*],
        [*Padre*], [*Figlio*],
      ),
      [Adamo], [Abele],
      [Adamo], [Caino],
      [Adamo], [Isacco],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*MATERNITA*],
        [*Madre*], [*Figlio*],
      ),
      [Eva], [Abele],
      [Eva], [Set],
      [Sara], [Isacco],
    ),
  ),
  caption: "Esempio di unione impossibile",
)

_PATERNITA_ $union$ _MATERNITA_ #strong[??] (attributi diversi, unione impossibile)

== Ridenominazione #index-main("Operatori", "Ridenominazione")

E' un operatore monadico (un solo argomento). Modifica lo schema lasciando inalterata l'istanza dell'operando. (semplicemente modifico il nome degli attributi)

#definition(
  )[
  Data $r$ di schema $R(A_1,...,A_k)$ e un insieme di attributi $B_1, ..., B_k$ l'operatore di ridenominazione:

  $
    rho_(B_1 ... B_k <- A_1 ... A_k) (r) space "oppure" space "REN"_(B_1...B_k <- A_1...A_k(r))
  $

  Produce una relazione di schema $R(B_1,...,B_k)$ che contiene una tupla $t'$ per ogni tupla $t$ contenuta nella relazione originaria in modo tale che $t'[B_i]=t[A_i] space forall i$
]

#figure(
  grid(
    columns: (auto, auto, auto),
    gutter: 1.5em,
    align: horizon,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*PATERNITA*],
        [*Padre*], [*Figlio*],
      ),
      [Adamo], [Abele],
      [Adamo], [Caino],
      [Adamo], [Isacco],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[$ rho_("Genitore" <- "Padre")("PATERNITA") $],
        [*Genitore*], [*Figlio*],
      ),
      [Adamo], [Abele],
      [Adamo], [Caino],
      [Adamo], [Isacco],
    ),
  ),
)

#figure(
  grid(
    columns: 2,
    gutter: 2em,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*PATERNITA*],
        [*Padre*], [*Figlio*],
      ),
      [Adamo], [Abele],
      [Adamo], [Caino],
      [Adamo], [Isacco],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[$ rho_("Genitore" <- "Padre")("PATERNITA") $],
        [*Genitore*], [*Figlio*],
      ),
      [Adamo], [Abele],
      [Adamo], [Caino],
      [Adamo], [Isacco],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*MATERNITA*],
        [*Madre*], [*Figlio*],
      ),
      [Eva], [Abele],
      [Eva], [Set],
      [Sara], [Isacco],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[$ rho_("Genitore" <- "Madre")("MATERNITA") $],
        [*Genitore*], [*Figlio*],
      ),
      [Eva], [Abele],
      [Eva], [Set],
      [Sara], [Isacco],
    ),
  ),
)

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    align: horizon,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[$ rho_("Genitore" <- "Padre")("PATERNITA") $],
        [*Genitore*], [*Figlio*],
      ),
      [Adamo], [Abele],
      [Adamo], [Caino],
      [Adamo], [Isacco],
    ),
    $ union $,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[$ rho_("Genitore" <- "Madre")("MATERNITA") $],
        [*Genitore*], [*Figlio*],
      ),
      [Eva], [Abele],
      [Eva], [Set],
      [Sara], [Isacco],
    ),
  ),
)

#figure(
  table(
    columns: 2,
    fill: (x, y) => {
      if y == 0 or y == 1 { rgb("#aee4e4") }
      else if calc.even(y) { white }
      else { rgb("#f0f0f0") }
    },
    table.header(
      table.cell(colspan: 2, align: center)[*Genitore $union$ Figlio (risultato)*],
      [*Genitore*], [*Figlio*],
    ),
    [Adamo], [Abele],
    [Adamo], [Caino],
    [Adamo], [Isacco],
    [Eva], [Abele],
    [Eva], [Set],
    [Sara], [Isacco],
  ),
)

== Selezione #index-main("Operatori", "Selezione")

Ovvero una *decomposizione orizzontale*. Permette di effettuare un taglio sulla tabella in base ad una condizione specificata. Produce un risultato che ha lo stesso schema dell'operando. Contiene un sottoinsieme delle ennuple dell'operando, ovvero quelle che soddisfano una condizione.

#definition()[
  Formula proposizionale per schema $R(A_1,...,A_k)$:

  - $A_i theta A_j$ con $theta in {=,eq.not, >, <, gt.eq, lt.eq}$ è una formula
  - $A_i theta c$ con $c in "dom"(A_i)$ è una formula
  - Se $F_1$ e $F_2$ sono formule allora anche $F_1 and F_2$, $F_1 or F_2$ e $not F_1$ sono formule

  Data $r$ di schema $R(A_1,...,A_k)$ e $F$ formula proposizionale, l'operatore di selezione

  $
    sigma_F(r) space "oppure" space "SEL"_F(r)
  $

  produce una relazione sugli attributi di $R$ che contiene le tuple di $r$ su cui $F$ è vera.
]

#figure(
  grid(
    columns: (auto, auto, auto),
    gutter: 1.5em,
    align: horizon,
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[*IMPIEGATI*],
        [*Matricola*], [*Cognome*], [*Filiale*], [*Stipendio*],
      ),
      [7309], [Rossi], [Firenze], [55],
      [5998], [Neri], [Prato], [64],
      [9553], [Prato], [Prato], [44],
      [5698], [Neri], [Pisa], [64],
    ),
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[$ sigma_("Stipendio" > 50)("IMPIEGATI") $],
        [*Matricola*], [*Cognome*], [*Filiale*], [*Stipendio*],
      ),
      [7309], [Rossi], [Firenze], [55],
      [5998], [Neri], [Prato], [64],
      [5698], [Neri], [Pisa], [64],
    ),
  ),
)

#figure(
  grid(
    columns: (auto, auto, auto),
    gutter: 1.5em,
    align: horizon,
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[*IMPIEGATI*],
        [*Matricola*], [*Cognome*], [*Filiale*], [*Stipendio*],
      ),
      [7309], [Rossi], [Firenze], [55],
      [5998], [Neri], [Prato], [64],
      [9553], [Prato], [Prato], [44],
      [5698], [Neri], [Pisa], [64],
    ),
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[$ sigma_("Stipendio" > 50 and "Filiale" = "Prato")("IMPIEGATI") $],
        [*Matricola*], [*Cognome*], [*Filiale*], [*Stipendio*],
      ),
      [5998], [Neri], [Prato], [64],
    ),
  ),
)

== Proiezione #index-main("Operatori", "Proiezione")

Ovvero una *decomposizione verticale*. E' un operatore monadico che produce un risultato che ha parte degli attributi dell'operando. Praticamente mostra l'intera tabella ma senza le colonne che non vogliamo vedere. Contiene ennuple cui contribuiscono tutte le ennuple dell'operando.

#definition(
  )[
  Dato l'insieme di attributi $X = {A_1, ... ,A_k}$, la relazione $r$ di schema $R(X)$ e un sottoinsieme $Y subset X$ l'operatore di proiezione

  $
    pi Y(r) space "oppure" space "PROJ"_(Y(r))
  $

  produce una relazione su $Y$ ottenuta dalla tuple di $r$ considerando solo i valori su $Y$.
]

#figure(
  grid(
    columns: (auto, auto, auto),
    gutter: 1.5em,
    align: horizon,
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[*IMPIEGATI*],
        [*Matricola*], [*Cognome*], [*Filiale*], [*Stipendio*],
      ),
      [7309], [Neri], [Firenze], [55],
      [5998], [Neri], [Prato], [64],
      [9553], [Rossi], [Pisa], [44],
      [5698], [Rossi], [Pisa], [64],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[$ pi_("Matricola,Cognome")("IMPIEGATI") $],
        [*Matricola*], [*Cognome*],
      ),
      [7309], [Neri],
      [5998], [Neri],
      [9553], [Rossi],
      [5698], [Rossi],
    ),
  ),
)

#figure(
  grid(
    columns: (auto, auto, auto),
    gutter: 1.5em,
    align: horizon,
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[*IMPIEGATI*],
        [*Matricola*], [*Cognome*], [*Filiale*], [*Stipendio*],
      ),
      [7309], [Neri], [Firenze], [55],
      [5998], [Neri], [Prato], [64],
      [9553], [Rossi], [Pisa], [44],
      [5698], [Rossi], [Pisa], [64],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[$ pi_("Cognome,Filiale")("IMPIEGATI") $],
        [*Cognome*], [*Filiale*],
      ),
      [Neri], [Firenze],
      [Neri], [Prato],
      [Rossi], [Pisa],
      [Rossi], [Pisa],
    ),
  ),
)

Una proiezione contiene al più tante ennuple quante l'operando ma può contenerne di meno. Se $X$ è una superchiave (insieme di attributi che include una chiave) di $R$, allora $pi_X (R)$ contiene esattamente tante ennuple quante $R$.

Selezione e proiezione possono essere combinati insieme per estrarre informazioni da una sola relazione.

#figure(
  grid(
    columns: (auto, auto),
    gutter: 1.5em,
    align: horizon,
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[*IMPIEGATI*],
        [*Matricola*], [*Cognome*], [*Filiale*], [*Stipendio*],
      ),
      [7309], [Rossi], [Firenze], [55],
      [5998], [Neri], [Prato], [64],
      [5698], [Neri], [Pisa], [64],
    ),
    $ pi_("Matricola,Cognome")(sigma_("Stipendio" > 50)("IMPIEGATI")) $,
  ),
)

#observation(
  )[
L'operazione di selezione nell'algebra relazionale corrisponde al WHERE in SQL mentre la proiezione all'istruzione SELECT “nome attributo”. Nell'esempio precedente sarebbe:

```sql
SELECT Matricola, Cognome FROM impiegati WHERE Stipendio>50;
```
]

== Join #index-main("Operatori", "Join")

Permette di congiungere dati in relazioni/tabelle diverse. E' un operatore binario generalizzabile ovvero che normalmente lavora su due argomenti ma volendo può lavorare su di più.

Produce un risultato sull'unione degli attributi degli operandi, con ennuple costruite ciascuna a partire da una ennupla di ognuno degli operandi.

#definition(
  )[#index-main("Join", "Naturale")
  Dati $R_1(X_1)$ e $R_2(X_2)$ il join naturale $R_1 join R_2$ oppure $R_1$JOIN $R_2$ è una relazione sull'unione $X_1 union X_2$:

  $
    R_1 join R_2 = {t in X_1 union X_2 | exists t_1 in R_1 space e space t_2 in R_2 space t.c. space
    t[X_1] = t_1 space e space t[X_2] = t_2}
  $
]



Le tuple del risultato di un join naturale sono ottenute combinando tuple degli operandi con valori uguali sugli attributi.

- Se X1 e X2 hanno attributi in comune si ha la definizione tradizionale di join naturale.
- Se X1 e X2 sono disgiunti si ha la definizione di prodotto cartesiano.
- Se X1 e X2 coincidono si ha la definizione dell'intersezione.

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    align: horizon,
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*LAUREATI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [7274], [Rossi], [42],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
    $ join $,
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*SPECIALISTI*],
        [*Matricola*], [*Nome*], [*Età*],
      ),
      [9297], [Neri], [33],
      [7432], [Neri], [54],
      [9824], [Verdi], [45],
    ),
  ),
)

$ "LAUREATI" join "SPECIALISTI" = "LAUREATI" inter "SPECIALISTI" $

Date $r, s$ definite su insiemi di attributi non disgiunti: $R(A_1,...,A_k,...,A_n)$ e $S(A_1,...,A_k,B_1,...,B_m)$ il risultato di
$r join s$ è una relazione definita su $A_1,...,A_n,B_1,...,B_m$:

$
  Z(A_1,...,A_n,B_1,...,B_m)
$

che contiene il seguente insieme di tuple ${t | t[A_1,...,A_n] in r and t[A_1,...,A_k ,B_1,_,B_m] in s}$

#figure(
  table(
    columns: 3,
    fill: (x, y) => {
      if y == 0 or y == 1 { rgb("#aee4e4") }
      else if calc.even(y) { white }
      else { rgb("#f0f0f0") }
    },
    table.header(
      table.cell(colspan: 3, align: center)[*LAUREATI $join$ SPECIALISTI*],
      [*Matricola*], [*Nome*], [*Età*],
    ),
    [7432], [Neri], [54],
    [9824], [Verdi], [45],
  ),
  caption: "Join completo",
)

Join completo

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    align: horizon,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 2 { rgb("#ffd700") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*Impiegato*],
        [*Impiegato*], [*Reparto*],
      ),
      [Rossi], [A],
      [Neri], [B],
      [Bianchi], [B],
    ),
    $ join $,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 3 { rgb("#ffd700") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*Reparto*],
        [*Reparto*], [*Capo*],
      ),
      [B], [Mori],
      [C], [Bruni],
    ),
  ),
  caption: "Join non completo",
)

#figure(
  table(
    columns: 3,
    fill: (x, y) => {
      if y == 0 or y == 1 { rgb("#aee4e4") }
      else if calc.even(y) { white }
      else { rgb("#f0f0f0") }
    },
    table.header(
      table.cell(colspan: 3, align: center)[*Impiegato $join$ Reparto $join$ Capo*],
      [*Impiegato*], [*Reparto*], [*Capo*],
    ),
    [Neri], [B], [Mori],
    [Bianchi], [B], [Mori],
  ),
)

Join non completo

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    align: horizon,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*Impiegato*],
        [*Impiegato*], [*Reparto*],
      ),
      [Rossi], [A],
      [Neri], [B],
      [Bianchi], [B],
    ),
    $ join $,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*Reparto*],
        [*Reparto*], [*Capo*],
      ),
      [D], [Mori],
      [C], [Bruni],
    ),
  ),
  caption: "Join vuoto",
)

#figure(
  table(
    columns: 3,
    fill: (x, y) => {
      if y == 0 or y == 1 { rgb("#aee4e4") }
      else { white }
    },
    table.header(
      table.cell(colspan: 3, align: center)[*Impiegato $join$ Reparto $join$ Capo (vuoto)*],
      [*Impiegato*], [*Reparto*], [*Capo*],
    ),
  ),
)

Join vuoto

=== Cardinalità del join #index-main("Join", "Cardinalità")

Il join di R1 e R2 contiene un numero di ennuple compreso fra zero e il prodotto di $|R_1|$ e $|R_2|$:

- Se il join coinvolge una chiave di $R_2$, allora il numero di ennuple è compreso fra zero e $|R_1|$;
- Se il join coinvolge una chiave di R2 e un vincolo di integrità referenziale, allora il numero di ennuple è pari a |R1|.

  Date $R_1(A,B)$, $R_2(B,C)$ in generale si ha:

  - $0 lt.eq |R_1 join R_2| lt.eq |R_1| times |R_2|$

  Se $B$ è chiave in $R_2$

  - $0 lt.eq |R_1 join R_2| lt.eq |R_1|$

  Se $B$ è chiave in $R_2$ ed esiste vincolo di integrità referenziale fra $B$ (in $R_1$) e $R_2$:

  - $|R_1 join R_2| = |R_1|$

  #example()[
  #figure(
    grid(
      columns: 3,
      gutter: 1em,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*STUDENTI*],
          [*Matricola*], [*Corso*],
        ),
        [Rossi], [ASD],
        [Neri], [BDD],
        [Bruni], [BDD],
        [Verdi], [ASD],
      ),
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*DOCENTI*],
          [*Corso*], [*Docente*],
        ),
        [ASD], [Mori],
        [BDD], [Pucci],
        [ANALISI], [Galli],
      ),
      table(
        columns: 3,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 3, align: center)[*STUDENTI $join$ DOCENTI*],
          [*Matricola*], [*Corso*], [*Docente*],
        ),
        [Rossi], [ASD], [Mori],
        [Neri], [BDD], [Pucci],
        [Bruni], [BDD], [Pucci],
        [Verdi], [ASD], [Mori],
      ),
    ),
  )

  Poiché DOCENTI.Corso è chiave per DOCENTI e c'è vincolo di integrità referenziale su Corso fra STUDENTI e DOCENTI:

  $ |"STUDENTI" join "DOCENTI"| = |"STUDENTI"| $
]

#example()[
  #figure(
    grid(
      columns: 3,
      gutter: 1em,
      table(
        columns: 3,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 3, align: center)[*STUDENTI*],
          [*Matricola*], [*Corso*], [*Progetto*],
        ),
        [Rossi], [ASD], [A4],
        [Neri], [BDD], [B1],
        [Bruni], [BDD], [B2],
        [Verdi], [ASD], [A1],
      ),
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*ELABORATI*],
          [*Progetto*], [*Argomento*],
        ),
        [A1], [Puntatori],
        [B1], [Normalizzazione],
        [B2], [SQL],
      ),
      table(
        columns: 4,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 4, align: center)[*STUDENTI $join$ ELABORATI*],
          [*Matricola*], [*Corso*], [*Progetto*], [*Argomento*],
        ),
        [Neri], [BDD], [B1], [Normalizzazione],
        [Bruni], [BDD], [B2], [SQL],
        [Verdi], [ASD], [A1], [Puntatori],
      ),
    ),
  )

  Poiché ELABORATI.Progetto è chiave, ogni tupla di STUDENTI contribuisce al risultato al massimo una volta. La tupla [Rossi, ASD, A4] non contribuisce. $|"STUDENTI" join "ELABORATI"| lt.eq |"STUDENTI"|$
]
=== Join esterno #index-main("Join", "Esterno")

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    align: horizon,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 2 { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*IMPIEGATI*],
        [*Impiegato*], [*Reparto*],
      ),
      [Rossi], [A],
      [Neri], [B],
      [Bianchi], [B],
    ),
    $ join $,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 3 { rgb("#ffd700") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*REPARTI*],
        [*Reparto*], [*Capo*],
      ),
      [B], [Mori],
      [C], [Bruni],
    ),
  ),
)

#figure(
  table(
    columns: 3,
    fill: (x, y) => {
      if y == 0 or y == 1 { rgb("#aee4e4") }
      else if calc.even(y) { white }
      else { rgb("#f0f0f0") }
    },
    table.header(
      table.cell(colspan: 3, align: center)[*IMPIEGATI $join$ REPARTI*],
      [*Impiegato*], [*Reparto*], [*Capo*],
    ),
    [Neri], [B], [Mori],
    [Bianchi], [B], [Mori],
  ),
)

Il join esterno estende, con valori nulli, le ennuple che verrebbero tagliate fuori da un join (interno). Esiste in tre versioni:

- sinistro#index-main("Join", "Left join") (left outer join): mantiene tutte le ennuple del primo operando, estendendole con valori nulli, se necessario;

  #figure(
    grid(
      columns: 3,
      gutter: 1em,
      align: horizon,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if y == 2 { rgb("#00bcd4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*IMPIEGATI*],
          [*Impiegato*], [*Reparto*],
        ),
        [Rossi], [A],
        [Neri], [B],
        [Bianchi], [B],
      ),
      $ join_("LEFT") $,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if y == 3 { rgb("#ffd700") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*REPARTI*],
          [*Reparto*], [*Capo*],
        ),
        [B], [Mori],
        [C], [Bruni],
      ),
    ),
  )

  #figure(
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 4 { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*IMPIEGATI $join_("LEFT")$ REPARTI*],
        [*Impiegato*], [*Reparto*], [*Capo*],
      ),
      [Neri], [B], [Mori],
      [Bianchi], [B], [Mori],
      [Rossi], [A], [NULL],
    ),
  )


- destro#index-main("Join", "Right join") (right outer join): . . . del secondo operando . . .

  #figure(
    grid(
      columns: 3,
      gutter: 1em,
      align: horizon,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if y == 2 { rgb("#ffd700") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*IMPIEGATI*],
          [*Impiegato*], [*Reparto*],
        ),
        [Rossi], [A],
        [Neri], [B],
        [Bianchi], [B],
      ),
      $ join_("RIGHT") $,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if y == 3 { rgb("#00bcd4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*REPARTI*],
          [*Reparto*], [*Capo*],
        ),
        [B], [Mori],
        [C], [Bruni],
      ),
    ),
  )

  #figure(
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 4 { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*IMPIEGATI $join_("RIGHT")$ REPARTI*],
        [*Impiegato*], [*Reparto*], [*Capo*],
      ),
      [Neri], [B], [Mori],
      [Bianchi], [B], [Mori],
      [NULL], [C], [Bruni],
    ),
  )


- completo#index-main("Join", "Full join") (full outer join): . . . di entrambi gli operandi . . .

  #figure(
    grid(
      columns: 3,
      gutter: 1em,
      align: horizon,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if y == 2 { rgb("#00bcd4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*IMPIEGATI*],
          [*Impiegato*], [*Reparto*],
        ),
        [Rossi], [A],
        [Neri], [B],
        [Bianchi], [B],
      ),
      $ join_("FULL") $,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if y == 3 { rgb("#00bcd4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*REPARTI*],
          [*Reparto*], [*Capo*],
        ),
        [B], [Mori],
        [C], [Bruni],
      ),
    ),
  )

  #figure(
    table(
      columns: 3,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if y == 4 or y == 5 { rgb("#00bcd4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 3, align: center)[*IMPIEGATI $join_("FULL")$ REPARTI*],
        [*Impiegato*], [*Reparto*], [*Capo*],
      ),
      [Neri], [B], [Mori],
      [Bianchi], [B], [Mori],
      [Rossi], [A], [NULL],
      [NULL], [C], [Bruni],
    ),
  )



#definition(
  )[
  Date $r$, $s$ deﬁnite su insiemi di attributi non disgiunti $R(A_1, ..., A_k , ... , A_n)$ e $S(A_1, ... , A_k , B_1, ... , B_m)$ il risultato di $r join_{"FULL"} s$ è una relazione deﬁnita su $A_1, ... , A_n, B_1, ... , B_m$:

  $
    Z (A_1, ... , A_n, B_1, ... , B_m)
  $

  deﬁnita come segue:

  $
    r join_{"FULL"} s = r join s space union (r - π_{A_1,··· ,A_n} (r join s)) times {B_1 = "null", ... , B_m = "null"} union \ union {A_(k+1) = "null", ... , A_n = "null"} times (s - π A_1,··· ,A_k ,B_1,··· ,B_m (r join s))
  $

  Le tuple che non contribuiscono al join naturale vengono unite con tuple nulle.
]

=== Prodotto cartesiano #index-main("Operatori", "Prodotto cartesiano")

#definition(
  )[
  Date $r$, $s$ con schemi di relazione $R(A_1,...,A_n)$ e $S(B_1,...,B_m)$ il risultato di $r times s$ è una relazione definita su $A_1,...,A_n,B_1,...,B_m$:
  $
    Z(A_1,...,A_n,B_1,...,B_m)
  $
  le cui tuple sono ottenute concatenando ogni tupla di $r$ con tutte le tuple di $s$ ottenendo l'insieme:
  $
    {t | t = u v space "con" space u in r and v in s}
  $
]

#observation(
  )[
  Il prodotto è un operatore primitivo, insieme a ridenominazione, unione, differenza, selezione e proiezione. Invece, per l'intersezione si ha $r inter s = r - (r - s)$. Inoltre un join naturale su relazioni senza attributi in comune, coincide con il loro prodotto.
]
#figure(
  grid(
    columns: 3,
    gutter: 1em,
    align: horizon,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*IMPIEGATI*],
        [*Impiegato*], [*Reparto*],
      ),
      [Rossi], [A],
      [Neri], [B],
      [Bianchi], [B],
    ),
    $ times $,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*REPARTI*],
        [*Codice*], [*Capo*],
      ),
      [A], [Mori],
      [B], [Bruni],
    ),
  ),
)

#figure(
  table(
    columns: 4,
    fill: (x, y) => {
      if y == 0 or y == 1 { rgb("#aee4e4") }
      else if calc.even(y) { white }
      else { rgb("#f0f0f0") }
    },
    table.header(
      table.cell(colspan: 4, align: center)[*IMPIEGATI $times$ REPARTI*],
      [*Impiegato*], [*Reparto*], [*Codice*], [*Capo*],
    ),
    [Rossi], [A], [A], [Mori],
    [Rossi], [A], [B], [Bruni],
    [Neri], [B], [A], [Mori],
    [Neri], [B], [B], [Bruni],
    [Bianchi], [B], [A], [Mori],
    [Bianchi], [B], [B], [Bruni],
  ),
)

=== $theta$ -join #index-main("Join", "Theta-join")

Il prodotto cartesiano in pratica ha senso solo se eseguita da selezione:

$
  sigma_{"Condizione"}(R_1 times R_2)
$

L'operazione viene chiamata theta-join e indicata con:

$
  R_1 join_{"Condizione"} R_2
$

La condizione è spesso una congiunzione (AND) di atomi di confronto $A_1 theta A_2$ dove $theta$ è uno degli operatori di confronto($=, >, <, "ge", "le"$). Se l'operatore di confronto nel theta join è sempre l'uguaglianza (=) si parla di equi-join#index-main("Join", "Equi-join")

#definition(
  )[
  Date $r$, $s$ con schemi $R(A_1, dots,A_n)$ e $S(B_1,dots,B_m)$, $A_i eq.not B_j$ il risultato di $r join_{A_i theta B_j}$ $s$ è una relazione definita su $A_1, dots ,A_n,B_1, dots ,B_m$:

  $
    Z(A_1, dots, A_n, B_1, dots, B_m)
  $

  che contiene il seguente insieme di tuple

  $
    {t | t = u v space "con" space u in r, v in s, u[A_i
    ] space theta space v[B_j]}
  $

  Si ha $r join_{A_i theta B_j} s = sigma A_i theta B_j (r times s)$
]

#figure(
  grid(
    columns: 3,
    gutter: 1em,
    align: horizon,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*IMPIEGATI*],
        [*Impiegato*], [*Reparto*],
      ),
      [Rossi], [A],
      [Neri], [B],
      [Bianchi], [B],
    ),
    $ join_("Reparto=Codice") $,
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*REPARTI*],
        [*Codice*], [*Capo*],
      ),
      [A], [Mori],
      [B], [Bruni],
    ),
  ),
)

#figure(
  table(
    columns: 4,
    fill: (x, y) => {
      if y == 0 or y == 1 { rgb("#aee4e4") }
      else if calc.even(y) { white }
      else { rgb("#f0f0f0") }
    },
    table.header(
      table.cell(colspan: 4, align: center)[*IMPIEGATI $join_("Reparto=Codice")$ REPARTI*],
      [*Impiegato*], [*Reparto*], [*Codice*], [*Capo*],
    ),
    [Rossi], [A], [A], [Mori],
    [Neri], [B], [B], [Bruni],
    [Bianchi], [B], [B], [Bruni],
  ),
)

#figure(
  grid(
    columns: 2,
    gutter: 2em,
    table(
      columns: 4,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 4, align: center)[*IMPIEGATI*],
        [*Matricola*], [*Nome*], [*Eta*], [*Stipendio*],
      ),
      [7309], [Rossi], [34], [45],
      [5998], [Bianchi], [37], [38],
      [9553], [Neri], [42], [35],
      [5698], [Bruni], [43], [42],
      [4076], [Mori], [45], [50],
      [8123], [Lupi], [46], [60],
    ),
    table(
      columns: 2,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 2, align: center)[*SUPERVISIONE*],
        [*Impiegato*], [*Capo*],
      ),
      [7309], [5698],
      [5998], [5698],
      [9553], [4076],
      [5698], [4076],
      [4076], [8123],
    ),
  ),
)

Trovare le matricole dei capi i cui impiegati guadagnano *tutti* più di 40:

$ pi_("Capo")("Supervisione") - pi_("Capo")( "Supervisione" join_("Impiegato=Matricola") (sigma_("Stipendio" <= 40)("Impiegati")) ) $

#figure(
  grid(
    columns: 1,
    gutter: 1.5em,
    table(
      columns: 6,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 6, align: center)[*SUPERVISIONE $join_("Impiegato=Matricola") (sigma_("Stipendio" <= 40)("IMPIEGATI"))$*],
        [*Impiegato*], [*Capo*], [*Matricola*], [*Nome*], [*Eta*], [*Stipendio*],
      ),
      [5998], [5698], [5998], [Bianchi], [37], [38],
      [9553], [4076], [9553], [Neri], [42], [35],
    ),
    table(
      columns: 1,
      fill: (x, y) => {
        if y == 0 or y == 1 { rgb("#aee4e4") }
        else if calc.even(y) { white }
        else { rgb("#f0f0f0") }
      },
      table.header(
        table.cell(colspan: 1, align: center)[$pi_("Capo")("SUPERVISIONE")$],
        [*Capo*],
      ),
      [5698],
      [4076],
      [8123],
    ),
  ),
)

Per differenza si trova *8123*.

== Equivalenze #index-main("Equivalenze algebriche")

Due espressioni sono equivalenti se producono lo stesso risultato qualunque sia l'istanza attuale della base di dati. L'equivalenza è importante in pratica perché i DBMS cercano di eseguire espressioni equivalenti a quelle date, ma meno costose.

- Anticipazione della selezione sul join#index("Equivalenze algebriche", "Pushdown della selezione").
- Esempio (se $A$ è attributo di $R_2$):
  $ sigma_(A=10)(R_1 join R_2) = R_1 join sigma_(A=10)(R_2) $
- Riduce in modo significativo la dimensione del risultato intermedio (e quindi il costo dell'operazione).

== Viste - relazioni derivate #index-main("Viste")

- Relazioni di base: contenuto autonomo.
- Relazioni derivate: relazioni il cui contenuto è funzione del contenuto di altre relazioni (definito per mezzo di interrogazioni). Le relazioni derivate possono essere definite su altre derivate.
  - *Viste materializzate*#index("Viste", "Materializzate"): relazioni derivate memorizzate nella base di dati. Immediatamente disponibili per le interrogazioni ma ridondanti, appesantiscono gli aggiornamenti, sono raramente supportate dai DBMS.
  - *Relazioni virtuali (o viste)*#index("Viste", "Virtuali"): sono supportate dai DBMS (tutti) e una interrogazione su una vista viene eseguita ricalcolando la vista.

== Limiti dell'algebra #index-main("Limiti dell'algebra relazionale")

Ci sono interrogazioni interessanti non esprimibili con l'algebra:

- Calcolo di valori derivati: possiamo solo estrarre valori, non calcolarne di nuovi.
- Calcoli di interesse: a livello di ennupla o di singolo valore (conversioni, somme, differenze, etc.)
su insiemi di ennuple (somme, medie, etc.)
- Interrogazioni inerentemente ricorsive, come la chiusura transitiva#index-main("Chiusura", "Transitiva").

#definition(
  )[
  Data $r$ di schema $R(X,Y )$, la chiusura transitiva $r^*$ di $r$ è la relazione che si ottiene aggiungendo, fino a quando è possibile, alle tuple in $r$ la coppia $(a, b)$ se esiste un valore $c$ tale che le coppie $(a, c)$ e $(c, b)$ sono in $r$ o sono state aggiunte precedentemente.
]

#example(
  "Chiusura transitiva",
)[
  Per ogni impiegato, trovare tutti i superiori (cioè il capo, il capo del capo e così via).

  #figure(
    grid(
      columns: 2,
      gutter: 2em,
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*SUPERVISIONE*],
          [*Impiegato*], [*Capo*],
        ),
        [Rossi], table.cell(fill: rgb("#ffcccc"))[*Lupi*],
        [Neri], [Bruni],
        table.cell(fill: rgb("#ffcccc"))[*Lupi*], [Falchi],
      ),
      table(
        columns: 2,
        fill: (x, y) => {
          if y == 0 or y == 1 { rgb("#aee4e4") }
          else if calc.even(y) { white }
          else { rgb("#f0f0f0") }
        },
        table.header(
          table.cell(colspan: 2, align: center)[*SUPERVISIONE2*],
          [*Impiegato*], [*Superiore*],
        ),
        [Rossi], [Lupi],
        [Neri], [Bruni],
        [Lupi], [Falchi],
        table.cell(fill: rgb("#ffcccc"))[*Rossi*], table.cell(fill: rgb("#ffcccc"))[*Falchi*],
      ),
    ),
    caption: "In questo esempio, basta il join della relazione con se stessa, previa opportuna ridenominazione",
  )

  $
    "CopiaSupervisione" = rho_("ImpX,CapoX" <- "Impiegato,Capo")("Supervisione") \
    "SuperSuper" = pi_("Impiegato,CapoX")("Supervisione" join_("Capo=ImpX") "CopiaSupervisione") \
    "Supervisione2" = rho_("Superiore" <- "Capo")("Supervisione") union rho_("Superiore" <- "CapoX")("SuperSuper")
  $

  Non esiste in algebra la possibilità di esprimere l'interrogazione che, per ogni relazione binaria, ne calcoli la chiusura transitiva. Per ciascuna relazione, è possibile calcolare la chiusura transitiva, ma con un'espressione ogni volta diversa. Quanti join servono? Non c'è limite!
]