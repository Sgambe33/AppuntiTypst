#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2" as cetz: canvas, draw
#import table: cell, header

#pagebreak()

= Grammatiche (4.2)

Le grammatiche sono una notazione utilizzata per specificare la sintassi di un linguaggio. Descrivono in maniera naturale la struttura gerarchica dei costrutti di molti linguaggi di programmazione.

#definition("par 4.2.1")[
  Formalmente una grammatica G è una quadrupla $(V, Sigma, P, S)$ dove:
  - *$V$* è l'insieme dei simboli non terminali
  - *$Sigma$* è l'insieme dei simboli terminali
  - *$P$* è l'insieme delle produzioni della grammatica
  - *$S in V$* è il simbolo iniziale della grammatica
]<defGrammar>

Prima di continuare bisogna chiarire cosa sono i simboli terminali e non terminali:
- *Simboli terminali*: corrispondono a tutti quei simboli che compongono le stringhe del linguaggio.
- *Simboli non terminali*: sono tutti quei simboli che *non* fanno parte del linguaggio, ma aiutano alla sua generazione.

Sapendo ciò si può capire che l'intersezione tra $Sigma$ e $V$ corrisponde ad un insieme vuoto:
$
  Sigma inter V = nothing
$

Ci sono vari tipi di grammatiche in base alla struttura delle regole $P$ ma per ora assumiamo di lavorare con grammatiche _* context-free*_.

== Produzioni delle grammatiche

Le produzioni delle grammatiche assumono la seguente forma:
$
  A -> alpha, quad quad quad "con " A in V " e " alpha in (V union Sigma)^*
$
- $A$ corrisponde alla parte *sinistra*, chiamata anche *testa*;
- $alpha$ corrisponde, invece, alla parte *destra*, chiamata anche *corpo*.

Questa notazione significa che se una stringa contiene il simbolo $A$, allora quel simbolo può essere sostituito con la stringa $alpha$.
In caso ci fossero più regole col simbolo non terminale $A$ come testa, allora si può usare una forma di scrittura più compatta:
$
  A & -> alpha_1 \
  A & -> alpha_2 \
    & dots.v quad quad quad ==> quad A -> alpha_1 | alpha_2 | dots | alpha_n \
  A & -> alpha_n
$

Oltre alle produzioni ci sono anche delle convenzioni specifiche per riconoscere a colpo d'occhio i simboli:
+ I seguenti simboli sono terminali\
  #set enum(numbering: "a)")
  + Le lettere minuscole all'inizio dell'alfabeto, come: $a, b, c$, ecc.;
  + I simboli degli operatori, come: $+$, $*$, ecc.;
  + I simboli di interpunzione, come: parentesi, virgola, ecc.;
  + Le cifre $0, 1, dots, 9$;
  + Le stringhe in grassetto, come *id* e *if*, ognuna delle quali rappresenta un unico simbolo terminale.
  #set enum(numbering: "1.")
+ I seguenti simboli sono non terminali:
  #set enum(numbering: "a)")
  + Le lettere maiuscole all'inizio dell'alfabeto, come: $A, B, C$, ecc.;
  + La lettera $S$ che, se presente, indica il simbolo iniziale;
  + I nomi in corsivo minuscolo, come _expr_ o _stmt_;
  + Le lettere maiuscole dell'alfabeto, quando usate per descrivere i costrutti della programmazione, possono indicare i non terminali del costrutto.
  #set enum(numbering: "1.")
+ Le lettere maiuscole alla fine dell'alfabeto (es. $X, Y, Z$) indicano i _simboli grammaticali_, quindi sia terminali che non terminali.
+ Le lettere minuscole alla fine dell'alfabeto (es. $u, v, w, x, y, z$) rappresentano _stringhe di terminali_, anche vuote.
+ Le lettere minuscole dell'alfabeto greco ($alpha, beta, gamma$) indicano stringhe di simboli della grammatica, anche vuote.
+ Quando non è specificato il simbolo iniziale, si considera la testa della prima produzione come tale.

== Derivazioni

#definition()[
  La *derivazione* è il meccanismo generativo centrale su cui si basano le grammatiche. Data una stringa, consente di ottenerne una nuova sostituendo un simbolo non terminale presente in essa con la parte destra di una delle sue produzioni.
]

Quando applichiamo una singola produzione, si dice che la stringa $w$ *produce direttamente* la stringa $z$ oppure, se letta la contrario, la stringa $z$ *deriva direttamente* dalla stringa $w$.

#example()[
  Data una regola di produzione $A -> alpha$ e una stringa iniziale $beta A gamma$, la sostituzione *produce direttamente* la stringa $beta alpha gamma$:
  $
    beta A gamma => beta alpha gamma quad quad "con " A in V, quad alpha, beta, gamma in (V union Sigma)^*
  $
]

Per descrivere derivazioni composte da più passaggi consecutivi, la notazione si può compattare per evitare di scrivere ogni singola regola applicata:
- Se abbiamo una sequenza $alpha => beta_1 => beta_2 => dots => beta_n = gamma$, possiamo condensare il tutto scrivendo:
  $
    alpha =>^+ gamma
  $
  Questo indica che $alpha$ deriva $gamma$ in *uno o più passaggi* (chiusura positiva).
- La notazione $alpha =>^* gamma$, invece, indica che $alpha$ deriva $gamma$ in *zero o più passaggi*. Questa espressione racchiude due casi:
  1. $alpha =>^+ gamma$ (produce $gamma$ con almeno 1 derivazione, identica alla forma precedente);
  2. $alpha = gamma$ (zero derivazioni, la stringa di arrivo è identica a quella di partenza).

La relazione di derivazione $der(*)$ può essere formalizzata anche tramite una definizione ricorsiva:
$
       mtext("Base"): & alpha der(*) alpha \
  mtext("Induzione"): & "se " alpha der(*) beta " e " beta => gamma, " allora " alpha der(*) gamma
$

Come si evince chiaramente dal passo induttivo, la relazione di derivazione gode della *proprietà transitiva*.

=== Linguaggio generato da una grammatica

#definition("Forma di frase")[
  Data una grammatica G, una stringa $beta$ si dice *forma di frase* di G se e solo se $beta$ è *derivabile dal simbolo iniziale S* di G, quindi:
  $
    S der(*) beta
  $
]

Una *frase* di G è una particolare forma di frase composta da soli simboli terminali. Quindi, una stringa $w$ è una frase di $G$ se e solo se:
$
  S der(+)w " e " w in Sigma^*
$

Sapendo tutto questo possiamo dire:

#definition()[
  Il *linguaggio generato da una grammatica $G$*, indicato con $L(G)$, corrisponde all'insieme formato da tutte le frasi di $G$:
  $
    L(G)={w | S der(+)w " e " w in Sigma^*}
  $
]

=== Derivazione sinistra e destra

Il processo di derivazione può procedere in due modi sistematici, scegliendo di espandere le variabili in un ordine preciso:

- *Derivazione sinistra*: una derivazione $S der(*) beta$ viene detta *sinistra* se, ad ogni passo, la regola di produzione viene applicata alla variabile (non terminale) *più a sinistra* presente nella forma di frase.

- *Derivazione destra*: analogamente, una derivazione $S der(*) beta$ viene detta *destra* se, ad ogni passo, la regola viene applicata alla variabile *più a destra* presente nella forma di frase.

Sapendo questo, si può estendere il concetto e *associare un linguaggio ad ogni singola variabile* $A in V$ della grammatica. Questo corrisponde all'insieme di tutte le stringhe di terminali che possono essere derivate partendo da quella specifica variabile come se fosse il simbolo iniziale:
$
  L(A)={w | A der(+)w " e " w in Sigma^*}
$

#example()[
  Sia data la grammatica seguente:
  $
    G = (V={E, I}, Sigma = {+, \*, (, ), a, b, 0, 1}, S=E, P)
  $
  Con le seguenti produzioni $P$:
  $
    E & -> I | E * E | E + E | (E) \
    I & -> a | b | I a | I b | I 0 | I 1
  $

  Possiamo notare che $E$ serve a produrre le espressioni con parentesi e operatori $+$ e $*$, mentre $I$ serve a produrre gli identificatori, che corrispondono al linguaggio definito dall'espressione regolare: $(a|b)(a|b|0|1)^*$

  Per l'esempio useremo la seguente stringa, che si può dividere concettualmente in due macro-blocchi grazie alla produzione iniziale di $E$:
  $
    underbracket(a b, I) * underbracket((b 0 1 + a b), E)
  $
  Mostriamo ora la *derivazione sinistra* passo-passo. Ad ogni passaggio, applichiamo una regola di produzione esclusivamente al non terminale più a sinistra:
  $
    E & => E * E \
      & => I * E \
      & => I b * E \
      & => a b * E \
      & => a b * (E) \
      & => a b * (E + E) \
      & => a b * (I + E) \
      & => a b * (I 1 + E) \
      & => a b * (I 0 1 + E) \
      & => a b * (b 0 1 + E) \
      & => a b * (b 0 1 + I) \
      & => a b * (b 0 1 + I b) \
      & => a b * (b 0 1 + a b)
  $
]

== Correttezza e completezza di una grammatica (par 4.2.6)

Supponiamo di dover dimostrare che un certo linguaggio $L$ coincida esattamente con il linguaggio generato da una grammatica $G$ (ovvero $L = L(G)$). Per fare ciò, bisogna dimostrare due proprietà fondamentali:
- *Correttezza ($L(G) subset.eq L$)*: ogni stringa generata da $G$ appartiene effettivamente ad $L$ (la grammatica non genera "spazzatura").
- *Completezza ($L subset.eq L(G)$)*: ogni stringa valida di $L$ può essere generata da $G$.
#example()[
  Sia data la grammatica $G$ definita dalle regole:
  $
    S -> epsilon | 0 | 1 | 0S 0 | 1S 1
  $
  L(G) è il linguaggio delle stringhe palindrome sull'alfabeto ${0,1}$. Un esempio di derivazione è:
  $
    S => 1 S 1 => 1 0 S 0 1 => 1 0 1 S 1 0 1 => 1 0 1 1 S 1 1 0 1 => 1 0 1 1 0 1 1 0 1
  $
  Iniziamo dimostrando la *completezza* ($L subset.eq L(G)$):\
  Supponiamo che una generica stringa $w$ sia palindroma e mostriamo per induzione sulla sua lunghezza $|w|$ che $w in L(G)$.
  - _Caso base_: se $|w|=0$ oppure $|w|=1$, allora $w$ può essere solo $epsilon$, $0$ o $1$. Utilizzando direttamente le regole base della grammatica:
    $
      S -> epsilon quad quad quad quad
      S -> 0 quad quad quad quad
      S -> 1
    $
    Abbiamo banalmente che $S der(+) w$
  - _Passo induttivo_: se $|w| > 1$, essendo palindroma, $w$ deve iniziare e finire con lo stesso simbolo. Quindi $w = 0 x 0$ oppure $w = 1 x 1$, dove $x$ è a sua volta una stringa palindroma con $|x| = |w| - 2$.\
    Per l'ipotesi induttiva sappiamo che $S der(+) x$:
  - se $w = 0 x 0$, allora la grammatica può derivarla così: $S => 0 S 0 =>^+ 0 x 0 = w$
  - se $w = 1 x 1$, allora la grammatica può derivarla così: $S => 1 S 1 =>^+ 1 x 1 = w$

    #line(length: 100%, stroke: .25pt)

    Ora passiamo a dimostrare la *correttezza* ($L(G) subset.eq L$):\
    Iniziamo supponendo che $S =>^+ w$ (ovvero $w$ è generata da $G$) e mostriamo per induzione sul numero di passi della derivazione che $w$ è necessariamente palindroma.

    - _Caso base_: Se la derivazione utilizza un solo passo, può usare solo 3 delle regole terminali:
    $
      S -> epsilon quad quad quad
      S -> 0 quad quad quad
      S -> 1
    $
    Queste regole generano stringhe che sono sicuramente palindrome (essendo di lunghezza $0$ o $1$).
    - _Passo induttivo_: Supponiamo l'enunciato vero per tutte le derivazioni in $n$ passi, e consideriamo una derivazione che usa $n+1$ passi. La stringa generata sarà espansa all'inizio tramite una delle regole ricorsive:
    $
      S => 0 S 0 =>^+ 0 x 0 = w quad "oppure" quad S => 1 S 1 =>^+ 1 x 1 = w
    $
    Poiché la porzione $S =>^+ x$ impiega esattamente $n$ passi, per l'ipotesi induttiva $x$ è palindroma. Di conseguenza, circondare un palindromo con due simboli identici agli estremi (ottenendo $0 x 0$ o $1 x 1$) genera stringhe che restano palindrome.
]

#example(multiple: true)[
  + Stringhe su ${a,b}$ che *iniziano con $a$* e hanno *lunghezza pari*\
    $S->"ab"|"aa"|S"aa"|S"ab"|S"ba"|"Sbb"$\
    - #underline("Base"): $a a, a b in L$\
    - #underline("Passo"): se $u in L$, allora $u a a, u a b, u b a, u b b in L$
  + Stringhe su {a,b} in cui ogni *$b$* è *preceduta da $a$*\
    - #underline("Base"): $epsilon in L$\
    - #underline("Passo"): se $u in L$, allora $u a, u a b in L$\
    $S -> epsilon | S a | S a b$
  + Stringhe su {a,b} di lunghezze dispari in cui il primo carattere e quello centrale sono uguali:
    $
      & L = {w in {"a,b"}^* |w = "axay"  && or w="bxby con" |y|=|x|+1} \
      & S->"aA | bB " quad quad "oppure" && S-> "aAX" | "bBX" \
      & A-> "XAX" | "aX"                 && A-> "XAX" | "a" \
      & A-> "XBX" | "bX"                 && B-> "XBX" | "b" \
      & X-> "a | b"                      && X-> "a | b"
    $
]

== Grammatiche regolari (par 4.2.7)

Così chiamate perché i linguaggi generati sono esattamente quelli rappresentabili tramite espressioni regolari. La differenza con le generiche grammatiche context-free risiede nei vincoli imposti alle produzioni. Nelle grammatiche regolari, esse possono avere solo la seguente forma:
$
  & "Destre" quad quad quad quad && "Sinistre" \
  & X -> a Y                     && X -> Y a \
  & X -> a                       && X -> a \
  & X -> epsilon                 && X -> epsilon \
$
$ "con " X,Y in V " e " a in Sigma $

A seconda della tipologia, le *forme di frase* (le stringhe intermedie prodotte durante la derivazione) avranno una struttura speculare:
$
  & "Destre":   & S =>^* w X quad & "con " w in Sigma^*, space X in V \
  & "Sinistre": & S =>^* X w quad & "con " w in Sigma^*, space X in V
$
Ovvero:
- In una *grammatica regolare destra*, la forma di frase è composta da zero o più simboli terminali ($w$) seguiti da un singolo simbolo non terminale ($X$) posizionato in fondo a destra.
- In una *grammatica regolare sinistra*, la forma di frase inizia con un singolo simbolo non terminale ($X$) a sinistra, seguito da zero o più simboli terminali ($w$).

#observation()[Le grammatiche sono *esclusivamente* destre o sinistre, non ci sono forme ibride (mescolare regole destre e sinistre nella stessa grammatica può generare linguaggi non regolari).]

Guardando la forma delle produzioni, si può notare che c'è un solo modo per terminare la derivazione (e ottenere una stringa di soli terminali): applicare una regola della forma $X -> a$ oppure $X -> epsilon$, che elimina definitivamente l'ultimo non terminale.

Generalmente, negli esempi sottostanti useremo la grammatica regolare destra (che è la più naturale per costruire automi a stati finiti). Il non-terminale fine di una forma di frase può essere utilizzato per rappresentare delle informazioni sulla sequenza di terminali che lo precede.

#example(multiple: true)[
  + Stringhe su {a,b} di lunghezza pari. Se io volessi usare una grammatica regolare:\
    $
      & |w|= "pari": S \
      & |w|= "dispari": D
    $
    Assegno delle variabili alle due condizioni.
    - Se la derivazione produce $S$ abbiamo finito.
    - Se produce $D$, devo aggiungere $a$ o $b$.
    $
      & S->epsilon | a D | b D \
      & D->a S | b S
    $
  + Stringhe su {a,b} che contengono tre *$a$* consecutive:\
    - $w$ non contiene "aaa" e termina con b: $S$\
    - $w$ non contiene "aaa" e termina con a: $A$\
    - $w$ non contiene "aaa" e termina con baa: $B$\
    - $w$ contiene "aaa": $C$
    $
      & S->b S | a A \
      & A -> a B | b S \
      & B -> a C | b S \
      & C -> epsilon | a C | b C
    $

  3. Stringhe su {a,b} che non contengono tre *$a$* consecutive:\
    $
      (b+a b+a a b)^*(epsilon+a+a a)
    $
    #block(
      $
        & S -> a A|b S| epsilon quad quad quad quad quad quad && "se "S der(*)w S "allora" w = epsilon "oppure" w=u b \
        & A -> a B|b S| epsilon                               && "se "S der(*)w A "allora" w = a "oppure" w=u b a \
        & B-> b S| epsilon                                    && "se "S der(*)w B "allora" w = a a "oppure" w=u b a a
      $,
    )
    La differenza con l'esempio precedente è in $B$, non potendo più aggiungere una '$a$' (che formerebbe "aaa"), ma solo una '$b$' o terminare la derivazione.

  + Stringhe su {a,b} che non cominciano con "aaa":\
    $
      (b+a b+a a b)(a+b)^*+epsilon+a+a a
    $

    #block(
      $
        & S->a A | b C | epsilon \
        & A->a B | b C | epsilon quad quad quad quad quad && "se" S der(*)w A "allora" w=a \
        & B->b C | epsilon                                && "se" S der(*)w B "allora" w=a a \
        & C->a C | b C | epsilon                          && "se" S der(*)w c "allora" w "inizia con "b, a b" o "a a b
      $,
    )
  + Stringhe su {a,b} che non contengono la sottostringa "aba":
    $
      (b+a^+b b)^*(epsilon+a^++a^+b)
    $
    #block(
      $
        &S->a A | b S | epsilon quad quad quad quad quad quad quad quad quad &&"se" S der(*)w S "allora" w=epsilon, w=b "oppure" w=u b b\
        &A->a A | b B | epsilon &&"se" S der(*)w A "allora" w=u a\
        &B->b S |epsilon &&"se" S der(*)w B "allora" w=u a b
      $,
    )
  + Stringhe su {a,b} che NON contengono due $a$ consecutive:
    $
      (b + a b + b a + a b a)^*
    $
    #block(
      $
        & S->a A | b B | epsilon #h(3.5cm) && "se" S der(*)w S "allora" w = u b a "oppure" w = epsilon \
        & A->b B                           && "se" S der(*)w A "allora" w=a "oppure" w=u b a a \
        & B->a S | b B | epsilon           && "se" S der(*)w B "allora" w=u b \
      $,
    )
  + Stringhe su {a,b} in cui il terzultimo carattere è $b$:
    $
      (a+b)^*b(a+b)(a+b)
    $
    #block(
      $
        & S->a S | b S | b A \
        & A->a B | b B #h(4cm) && "se" S der(*)w A "allora" w=u b \
        & B->a | b             && "se" S der(*)w B "allora" w = u b a "oppure" w = u b b
      $,
    )
  + Stringhe su {a,b} con un numero pari di $a$ o un numero dispari di $b$:
    $
      (a a+b b+(a b+b a)(a a+b b)^*(a b+b a))^*
    $
    #block(
      $
        & S->a A | b B | epsilon #h(4cm) && S der(*)w S "allora" abs(w)_a "e" abs(w)_b "sono pari" \
        & A->a S | b C                   && S der(*)w A "allora" abs(w)_a "è dispari e" abs(w)_b "è pari" \
        & B->a C | b S                   && S der(*)w B "allora" abs(w)_a "è pari e" abs(w)_b "è dispari" \
        & C->a B | b A                   && S der(*)w C "allora" abs(w)_a "e" abs(w)_b "sono dispari" \
      $,
    )
    #figure(
      table(
        columns: (auto, auto, auto),
        rows: (auto, auto, auto, auto, auto),

        [], [$abs(w)_a$], [$abs(w)_b$],
        table.cell(fill: rgb("#68e86680"), "S"), [*_pari_*], [*_dispari_*],
        align: center,
        [A], [_dispari_], [_pari_],
        [B], [_pari_], [_dispari_],
        [C], [_dispari_], [_dispari_],
      ),
    )
  + Stringhe su {a,b} di lunghezza dispari che contengono esattamente due $b$:
    $
      a(a a)^*b(a a)^*b(a a)^* + (a a)^*b a(a a)^*b(a a)^*+(a a)^*b(a a)^*b a(a a)^*+a(a a)^*b a(a a)^*b a(a a)
    $
    Ci sono 6 possibili situazioni per $S =>^* w X$:
    #figure(
      table(
        columns: (auto, auto, auto),

        [], [$abs(w)$], [$abs(w)_b$],
        [S], [_pari_], [0],
        [A], [_dispari_], [0],
        [B], [_dispari_], [1],
        [C], [_pari_], [1],
        [D], [_pari_], [2],
        table.cell(fill: rgb("#68e86680"), "E"), [*_dispari_*], [*2*],
        align: center,
      ),
    )
    #block(
      $
        & S->a A | b B #h(4cm) && "se" S der(*)w S "allora" abs(w) "è pari e" abs(w)_b = 0 \
        & A->a S | b C         && "se" S der(*)w A "allora" abs(w) "è dispari e" abs(w)_b = 0 \
        & B->a C | b D         && "se" S der(*)w B "allora" abs(w) "è dispari e" abs(w)_b = 1 \
        & C->a B | b E         && "se" S der(*)w C "allora" abs(w) "è pari e" abs(w)_b = 1 \
        & D->a E               && "se" S der(*)w D "allora" abs(w) "è pari e" abs(w)_b = 2 \
        & E->a D | epsilon     && "se" S der(*)w E "allora" abs(w) "è dispari e" abs(w)_b = 2
      $,
    )
  + Stringhe su {a,b} in cui "aa" occorre esattamente una volta:
    $
      (b+a b)^*a a(b+b a)^*
    $
    #block(
      $
        & S->a A | b S #h(4cm)   && "se" S der(*)w S "allora" w = epsilon "oppure" w = u b \
        & B->b C | epsilon       && "se" S der(*)w A "allora" w = a "oppure" w = u b a \
        & A->a B | b S           && "se" S der(*)w B "allora" w = u a" e "w "contiene" a a \
        & C->a B | b C | epsilon && "se" S der(*)w C "allora" w = u b" e "w "contiene" a a
      $,
    )
    #figure(
      table(
        columns: (auto, auto, auto),

        [], [contiene $a a$], [ultimo caratere],
        [S], [_no_], [_b($epsilon$)_],
        [A], [_no_], [_a_],
        table.cell(fill: rgb("#68e86680"), "B"), [*_sì_*], [_a_],
        table.cell(fill: rgb("#68e86680"), "C"), [*_sì_*], [_b_],
      ),
    )
  11. Stringhe su {a,b} in cui "aa" occorre almeno due volte:
    $
      (a+b)^*(a a(a+b)^*a a+a a a)(a+b)^*
    $
    #block(
      $
        & S->a A | b S #h(3.5cm) && "se" S der(*)w S "allora" w = epsilon "oppure" w = u b \
        & A->a B | b S           && "se" S der(*)w A "allora" w = a "oppure" w = u b a \
        & B->a D | b C           && "se" S der(*)w B "allora" w = u a "e w contiene" a a \
        & C->a B | b C           && "se" S der(*)w C "allora" w = u b" e "w" contiene "a a \
        & D->a D | b D | epsilon && "se" S der(*)w D "allora" w "contiene 2 volte" a a
      $,
    )
    #figure(
      table(
        columns: (auto, auto, auto),

        [], [numero $a a$], [ultimo simbolo],
        [S], [0], [_b($epsilon$)_],
        [A], [0], [_a_],
        [B], [1], [_a_],
        [C], [1], [_b_],
        table.cell(fill: rgb("#68e86680"), "D"), [$>=$2], [_a,b_],
      ),
    )
]

== Gerarchie di Chomsky

Ci sono 4 classi di grammatiche, distinte tra di loro per la struttura delle loro regole di produzione. I tipi partono da 0 e, ad ogni incremento, aumenta il numero di restrizioni fino al tipo 3.

0. *#link(<gramNoRes>)[Grammatiche senza restrizioni (a struttura di frase)]*
+ *#link(<gramCont>)[Grammatiche contestuali (Context-sensitive)]*
+ *#link(<gramNoCont>)[Grammatiche non contestuali (Context-free)]*
+ *#link(<gramReg>)[Grammatiche regolari]*

Ovviamente hanno sempre in comune la definizione base di grammatica (#ref(<defGrammar>)). Le grammatiche non contestuali (context-free) e regolari, anche se già spiegate, verranno rispiegate molto brevemente.

=== Grammatiche senza restrizioni (a struttura di frase) <gramNoRes>

In questo tipo di grammatica (Tipo 0), le produzioni hanno la seguente forma:
$
  alpha -> beta, quad "con " alpha in (V union Sigma)^+ " e " beta in (V union Sigma)^*
$
Ovvero $alpha$ non può essere una stringa nulla. Inoltre, affinché la derivazione abbia senso, è necessario imporre che $alpha$ contenga *almeno un simbolo non terminale*:
$
  alpha in (V union Sigma)^* V (V union Sigma)^* \
$

I concetti di derivazione diretta e indiretta e tutte le nozioni introdotte per le grammatiche context-free rimangono validi, ma applicati a stringhe più complesse a sinistra della freccia.

Quindi, siano $alpha, beta, gamma, delta in (V union Sigma)^*$ con $alpha != epsilon$. Se abbiamo una stringa $gamma alpha delta$ e applichiamo la regola di produzione $alpha -> beta$, la sottostringa $alpha$ viene sostituita da $beta$, ottenendo la stringa $gamma beta delta$. Questo passaggio (derivazione diretta) si indica con:
$
  gamma alpha delta => gamma beta delta quad quad ("la stessa notazione si estende a " =>^* " e " =>^+)
$

Anche la definizione del linguaggio generato rimane formalmente identica, corrispondendo all'insieme delle stringhe composte da soli terminali derivabili dal simbolo iniziale $S$:
$
  L(G) = {w in Sigma^* | S der(+) w}
$

=== Grammatiche contestuali (Context-sensitive) <gramCont>

Queste grammatiche hanno due definizioni formali che, seppur diverse nella sintassi, si dimostrano essere matematicamente equivalenti (generano la stessa classe di linguaggi):
#definition()[
  $alpha -> beta$ dove $alpha, beta in (V union Sigma)^+ quad quad$ (o più precisamente $alpha in (V union Sigma)^* V (V union Sigma)^*$)\
  e, inoltre, vale il vincolo sulla lunghezza: $|alpha| <= |beta| quad ("quindi " beta != epsilon)$
]

#definition("2")[
  $alpha_1 A alpha_2 -> alpha_1 beta alpha_2 quad$ con $A in V, space alpha_1, alpha_2, beta in (V union Sigma)^* " e " beta != epsilon$
]

Queste due definizioni sono, come detto, equivalenti, ma la seconda spiega molto meglio l'origine del termine *contestuale* (o dipendente dal contesto): la sostituzione del non terminale $A$ con la stringa $beta$ non è libera, ma può essere effettuata *soltanto nel contesto* delle stringhe $alpha_1$ e $alpha_2$.

In altre parole, la regola scatta solo quando $A$ è strettamente preceduta dal prefisso $alpha_1$ e seguita dal suffisso $alpha_2$. Se ci fosse un contesto diverso (es. un $alpha_3 != alpha_1$ prima di $A$), non potremmo applicare questa specifica regola di produzione.

=== Grammatiche non contestuali (Context-free) <gramNoCont>
In questo tipo di grammatica, la forma delle regole di produzione è la seguente:
$
  A -> beta quad "con " A in V " e " beta in (V union Sigma)^*
$
Il significato è implicito nel nome stesso: a prescindere dal contesto (dai caratteri che lo precedono o lo seguono), un singolo non terminale $A$ può sempre essere espanso e sostituito con la stringa $beta$.

=== Grammatiche regolari <gramReg>

Le regole di produzione delle grammatiche regolari sono le più restrittive e possono avere esclusivamente una delle seguenti forme:
$
  & "Destre" quad quad quad quad && "Sinistre" \
  & X -> a Y                     && X -> Y a \
  & X -> a                       && X -> a \
  & X -> epsilon                 && X -> epsilon \
$
$ "con " X,Y in V " e " a in Sigma $

=== Considerazioni sulla gerarchia
- Ogni grammatica di tipo $i > 0$ è anche di tipo $i - 1$ (tenendo conto che, per i linguaggi contestuali di tipo 1, non sono ammesse regole del tipo $X -> epsilon$). Inoltre, si dice che un linguaggio è *strettamente* di tipo $i$ se è generato da una grammatica di tipo $i$, ma non esiste alcuna grammatica di tipo $i+1$ in grado di generarlo.

- Data una grammatica $G = (V, Sigma, P, S)$ che genera il linguaggio $L(G)$, esiste sempre una grammatica equivalente $G_1$ che genera $L(G) - {epsilon}$ senza usare regole del tipo $X -> epsilon$. Esiste, di conseguenza, anche una grammatica $G_2$ tale che $L(G) = L(G_2)$ e che contiene al massimo un'unica regola che produce $epsilon$ (nella forma $S' -> epsilon$, a patto che il nuovo simbolo iniziale $S'$ non compaia mai nella parte destra di nessuna produzione).

- Le *grammatiche non contestuali* (Tipo 2) sono usate per definire la sintassi dei linguaggi di programmazione e costituiscono il cuore della fase di *analisi sintattica* (Parsing) nei compilatori.

- Le *grammatiche regolari* (Tipo 3) sono usate nella fase di *analisi lessicale* (Lexing/Tokenization) dei compilatori, per riconoscere le parole chiave e i simboli base.

- Ad ogni classe di grammatiche corrisponde in modo biunivoco la classe dei linguaggi generati:
  - Grammatiche senza restrizioni $space <--> space$ Linguaggi ricorsivamente enumerabili
  - Grammatiche contestuali $space <--> space$ Linguaggi contestuali
  - Grammatiche non contestuali $space <--> space$ Linguaggi non contestuali
  - Grammatiche regolari $space <--> space$ Linguaggi regolari

Ad ogni classe corrisponde inoltre uno specifico modello matematico (macchina astratta) in grado di riconoscere se una stringa appartiene o meno a quel dato linguaggio:
#table(
  columns: (auto, auto, 1fr, 1fr),
  align: (center, left, left, left),
  header([*Tipo*], [*Grammatiche*], [*Linguaggi*], [*Macchine*]),
  [0], [Senza Restrizioni], [Ricorsivamente enumerabili], [Macchine di Turing],
  [1], [Contestuali], [Contestuali], [Automi limitati superiormente],
  [2], [Non contestuali], [Non contestuali], [Automi a pila],
  [3], [Regolari], [Regolari], [Automi a stati finiti],
)

#align(center)[
  #cetz.canvas({
    import cetz.draw: content, rect

    // Tipo 0
    rect((0, 0), (11, 6), radius: 5pt, stroke: 1.5pt + black)
    content((5.5, 5.5), [*Linguaggi ricorsivamente enumerabili*])

    // Tipo 1
    rect((0.5, 0.5), (10.5, 5), radius: 5pt, stroke: 1.5pt + blue)
    content((5.5, 4.5), [*Linguaggi contestuali*])

    // Tipo 2
    rect((1, 1), (10, 4), radius: 5pt, stroke: 1.5pt + red)
    content((5.5, 3.5), [*Linguaggi non contestuali*])

    // Tipo 3
    rect((1.5, 1.5), (9.5, 3), radius: 5pt, stroke: 1.5pt + green.darken(20%))
    content((5.5, 2.5), [*Linguaggi regolari*])
  })
]

#example(multiple: true, "Grammatiche non contestuali")[
  - ${a^n b^n | n >= 0}$\
    $S -> a S b | epsilon$

  - ${w in {a,b}^* | abs(w)_a = abs(w)_b}$\
    $S -> a S b S | b S a S | epsilon$

  - ${w in {0,1}^* | w = w^R}$\
    $S -> epsilon | 0 | 1 | 0 S 0 | 1 S 1$

  - ${a^n b^n c^k | n,k >= 0}$\
    $S -> A B$\
    $A -> a A b | epsilon$\
    $B -> c B | epsilon$

  - ${a^n b^n c^k d^k | n,k >= 0}$\
    $S -> A B$\
    $A -> a A b | epsilon$\
    $B -> c B d | epsilon$

  - ${a^n b^k c^k d^n | n,k > 0}$\
    $S -> a S d | a A d$\
    $A -> b A c | b c$

  - ${a^n b^k c^(2n+k) | n,k > 0}$\
    $S -> a S c c | a B c c$\
    $B -> b B c | b c$

  #line(length: 100%, stroke: 0.25pt)
  Non tutti i linguaggi possono essere generati da una grammatica non contestuale:
  - ${a^n b^n c^n | n > 0}$
  - ${a^n b^k c^n d^k | n,k > 0}$
  - ${w w | w in {a,b}^*}$
]


#example(multiple: true, "Grammatiche contestuali")[
  - ${a^n b^n c^n | n > 0}$\
    $S &-> a b c | a X b c$\
    $X &-> a X b C | a b C$\
    $C b &-> b C$\
    $C c &-> c c$

    *Derivazione per $n=3$:*\
    $S => a underline(X) b c => a bold(a underline(X) b C) b c => a a bold(a b C) underline(C b) c => a a a b bold(b C) C c => a a a b b C underline(C c) => a a a b b underline(C bold(c c)) => a a a b b b c c c$

    Più in generale si può scrivere la forma contratta:
    $
      S => a X b c =>^+ a^n (b C)^(n-1) b c =>^+ a^n b^n C^(n-1) c =>^+ a^n b^n c^n
    $

  - ${a^n b^k c^n d^k | n,k > 0}$\
    $S &-> A B$\
    $A &-> a A C | a C$\
    $B &-> b B d | b d$\
    $C b &-> b C$\
    $C d &-> c d$\
    $C c &-> c c$

    *Derivazione generale:*\
    $
      S => A B =>^+ a^n C^n B =>^+ a^n C^n b^k d^k =>^+ a^n b^k C^n d^k => a^n b^k C^(n-1) c d^k =>^+ a^n b^k c^n d^k
    $

  - ${w w | w in {a,b}^*}$
    #line(length: 100%, stroke: .25pt)
    #block(
      $
        & S -> a A S | b B S | X a | Y b quad quad quad S =>^+ a A union b B)^* (X a union Y b)) \
        & A a -> a A quad quad A b -> b A \
        & B a -> a B quad quad B b -> b B \
        & "dove i non terminali" A "e" B "scivolano verso destra superando i terminali."
      $,
    )
    #line(length: 100%, stroke: .25pt)
    #block(
      $
        & A X -> X a quad quad A Y -> Y a quad quad && "Quando " A " o " B " incontrano il centro (" X " o " Y ")," \
        & B X -> X b quad quad B Y -> Y b quad quad && "lo attraversano e si trasformano nel terminale definitivo."
      $,
    )
    #line(length: 100%, stroke: .25pt)
    #block(
      $
        & X -> a quad quad quad quad quad quad quad quad quad quad quad && "Alla fine, il marcatore centrale svanisce" \
        & Y -> b quad quad quad quad quad quad quad quad quad quad quad && "diventando l'ultimo carattere della prima metà."
      $,
    )
    Esempio di derivazione per $w = a b b a$ (stringa finale $w w = a b b a a b b a$):
    #block(
      $
        S & => a A S => a A b B S => a A b B b B S => bold(a A b B b B X a) \
          & => a b A b B B X a => a b b A B B X a => bold(a b b A B X b a) \
          & => a b b A X b b a => bold(a b b X a b b a) => bold(a b b a a b b a)
      $,
    )
]
