#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2" as cetz: canvas, draw
#import table: cell, header

= Grammatiche (4.2)


#definition("par 4.2.1")[
  Le *grammatiche* si basano su un meccanismo generativo che *permette di produrre stringhe che appartengono al linguaggio desiderato*. \
  Formalmente una grammatica G è una quadrupla $(V, Sigma, P, S)$ dove:
  - *$Sigma$* è l'insieme dei simboli terminali
  - *$V$* è l'insieme dei simboli non terminali
  - *$P$* è l'insieme delle regole della grammatica
  - *$S in V$* è il simbolo iniziale della grammatica
]<defGrammar>

Prima di continuare bisogna chiarire cosa sono i simboli terminali e non terminali:
- *Simboli terminali*: corrispondono a tutti quei simboli che compongono le stringhe del linguaggio.
- *Simboli non terminali*: al contrario dei terminali, sono tutti quei simboli che *non* fanno parte del linguaggio, ma aiutano alla loro generazione.

Sapendo ciò si può capire che l'interesezione tra $Sigma$ e $V$ corrisponde ad un insieme vuoto: $Sigma inter V = nothing$

Ci sono vari tipi di grammatiche in base alla strutture delle regole ma per ora si rimane nelle grammatiche _* context-free*_.

== Regole delle grammatiche (par 4.2.1 - 4.2.2)

Le regole delle grammatiche assumono la seguente forma:
$
  A-> alpha, quad quad quad "con " A in V " e " alpha in (V union Sigma)^*
$
Come si può anche  vedere:
- $A$ corrispondere alla parte *sinistra*, chiamata anche *testa*
- $alpha$ corrispondere, invece, alla parte *destra*, chiamata anche *corpo*

Questa notazione significa che se una stringa contiene il simbolo *$A$*, allora quel simbolo può essere sostituito con la stringa *$A$*.\
In caso ci fossero più regole col simbolo non terminale *$A$* come testa, allora si può usare una forma di scrittura più compatta:
$
  A &-> alpha_1\
  A &-> alpha_2\
  dots.v " " &-> " " dots.v  quad quad ==> quad quad A -> alpha_1 | alpha_2 | dots | alpha_(n-1) | alpha_n\
  A &-> alpha_(n-1)\
  A &-> alpha_n
$

Oltre alle regole ci sono anche delle convenzioni:
+ I seguenti simboli sono terminali\
  #set enum(numbering: "a)")
  + Le lettere minuscole all'inizio dell'alfabeto, come: a, b, c, etc...;
  + I simboli degli operatori, come: +, \*, etc...;
  + I simboli di interpunzione, come: parentesi, virgola, etc...;
  + Le cifre 0, 1, $dots$, 9;
  + Le stringhe in grassetto, come *id* e *if*, ognunga delle quali rappresenta un unico simbolo terminale.
+ I seguenti simboli sono non terminali:
  #set enum(numbering: "a)")
  + Le lettere maiuscole all'inizio dell'alfabeto, come: A, B, C, etc...;
  + La lettera S che, se presente, indica il simbolo iniziale;
  + I nomi in corsivo minuscolo, come _expr_ o _stmt_
  + Le lettere maiuscole dell'alfabeto, quando usate per descrivere i costrutti della programmazione, possono indicare i non-terminali del costrutto.
+ Le lettere maiuscole alla fine dell'alfabeto indicano i _simboli grammaticali_, quindi sia terminali che non.
+ Le lettere minuscole alla fine dell'alfabeto rappresentano _stringhe di terminali_, anche vuote
+ Le lettere minuscole dell'alfabeto greco ($alpha, beta, gamma $) indicando stringhe di simboli della grammatica, anche vuote.
+ Quando non specificato il simbolo iniziale, si considera la testa della prima produzione come tale.

== Derivazioni (par 4.2.3 - 4.2.5)

#definition()[
  La *derivazione* è il meccanismo generativo su cui si basano le grammatiche.\
  Data una stringa iniziale, consente di ottenere una nuova stringa sostituendo al simbolo non-terminale presente, la parte destra di una delle sue regole.
]

Questo passaggio si dice che la stringa $w$ produce direttamente la stringa $z$ oppure, se letta la contrario, la stringa $z$ deriva direttamente dalla stringa $w$.

#example()[
  Data una regola $A -> alpha$ e la stringa iniziale $beta A gamma$, si può dire che la stringa $beta A gamma$ produce direttamente la stringa $beta alpha gamma$:
  $
    beta A gamma ==> beta alpha gamma, quad quad quad "con "A in V, quad alpha, beta, gamma in (V union Sigma)^*
  $
]

Anche in questo caso, la notazione della derivazione si può scrivere in altri modi più compatti, se necessario:
- Se abbiamo $alpha => beta_1 => beta_2 => dots => beta_n = gamma$, allora questo si può riscrivere nel seguente modo:
  $
    alpha der(+) gamma
  $
- Se, invece, abbiamo $alpha der(*) gamma$ ci sono due casi:
  + $alpha$ produce $gamma$, quindi almeno 1 derivazione, identica alla forma precedente
  + $alpha = gamma$, quindi nessuna derivazione

Quindi, a parole, corrispondono rispettivamente al *derivare una o più volte* e *derivare zero  o più volte*.

La definizione di derivazione si può scrivere anche ricorsivamente:
$
  &#text(font: "Libertinus Serif", style: "italic")[Base]: alpha der(*) alpha\
  &#text(font: "Libertinus Serif", style: "italic")[Induzione]: alpha der(*) beta " e " beta der() gamma, quad " allora " quad alpha der(*) gamma
$

Il passo induttivo ci mostra anche che la derivazione gode della proprietà transitiva

=== Linguaggio generato da una grammatica

Prima di continuare bisogna capire cos'è una forma di frase.

#definition("Forma di frase")[
  Data una grammatica G, una stringa $beta$ si dice *forma di frase* di G se e solo se $beta$ è *derivabile dal simbolo iniziale S* di G, quindi:
  $
    S der(+) beta
  $
]

Una *frase* di G è una particolare forma di frase composta da soli simboli terminali, quindi $w$ è una frase di G se e solo se: 
$
  S der(+)w " e " w in Sigma^*
$

Sapendo tutto questo possiamo dire:

#definition()[
  Il *linguaggio generato da una grammatica G*, L(G), corrisponde all'insieme formato da tutte le frasi di G:
  $
    L(G)={w | S der(+)w " e " w in Sigma^*}
  $
]

=== Derivazione sinistra e destra

La derivazione può essere fatta in due modi, derivando da sinistra verso destra o da destra verso sinistra:

- *Derivazione sinistra*: $S der(*) beta$ viene detta #text(font: "Libertinus Serif", style: "italic")[derivazione sinistra] se, ad ogni passo, viene applicata una regola alla variabile più a sinistra della forma di frase.
- *Derivazione destra*: analogamente, $S der(*) beta$ viene detta #text(font: "Libertinus Serif", style: "italic")[derivazione destra] se, ad ogni passo, viene applicata una regola alla variabile più a destra della forma di frase.

Si può anche dimostrare che una derivazione $S der(*) beta$ esiste se e solo se esiste una derivazione sinistra o destra.\

Sapendo tutto questo si può *associare un linguaggio ad ogni variabile $A in V$*, che corrisponde all'insieme di stringhe di terminali derivabili dalla variabile stessa:
$
  L(A)={w | A der(+)w " e " w in Sigma^*}
$ 

#example()[
  G = ({E, I}, {+, \*, (, ), a, b, 0, 1}, E, P)\
  In questo esempio il primo insieme {E,I} corrisponde a $V$ e il secondo insieme {+, \*, (, ), a, b, 0, 1} corrisponde a $Sigma$.
  $
    cases(reverse: #true,
      "Produzioni": & E &&-> I | E*E | E+E | (E),
         & I &&-> a | b | I a | I b | I 0 | I 1
    ) "Costruttori di espressioni"
  $

  Possiamo notare che E serve a produrre le espressioni con parentesi e operatori + e \*, mentre I serve a produrre gli identificatori rappresentati dall'espressione regolare $(a+b)(a+b+1+0)^*$

  Per l'esempio useremo la seguente stringa che si può dividere in due parti grazie ad E (solo primo passaggio, viene ulteriormente divisa per il + dentro le parentesi). In questo caso useremo la derivazione sinistra.
  $
    & underbracket("ab")* && underbracket(("b01"+ "ab")) \
    & E                   && quad space space space E
  $
  $
    & E = E*E => I*E => I"b" * E => "ab"*E => "ab" * (E) => "ab"*(E+E) => \
 => & "ab"*(I+E) =>"ab"*(I"1"+E) =>"ab"*(I"01"+E) => "ab"*("b01"+E) => \
 => & "ab"*("b01"+I) => "ab"*("b01"+I"b") => "ab"*("b01"+"ab")
  $
]


== Correttezza e completezza di una grammatica (par 4.2.6)

Supponiamo di dover dimostrare che un certo linguaggio $L$ è generato da una grammatica $G$, per fare ciò bisogna dimostrare due cose:

- *Correttezza*: ogni stringa di L può essere generata da G, quindi è in L(G)
- *Completezza*: ogni stringa generata da G appartiene ad L

#example()[
  Grammatica G definita dalle regole:
  $S -> epsilon | 0 | 1 | 0S 0 | 1S 1$\
  L(G) è il linguaggio delle stringhe palindrome ${0,1}^*$\
  Un esempio di ciò è:
  $
    S => 1S 1 => 10S 01 => 101S 101 => 1011S 1101 => 101101101
  $ 
  Iniziamo con la *completezza*:\
  Supponiamo che la stringa $w$ sia palindroma e mostriamo per induzione su $|w|$ che $w in L(G)$\

  - _Caso base_: se $|w|=0 " oppure " |w|=1$, allora $w$ = epsilon, 0 o 1 e, utilizzando le regole:
    $
      S -> epsilon quad quad quad quad
      S -> 0 quad quad quad quad
      S -> 1
    $
    Abbiamo che $S der(+) w$
  - _Induzione_: se $|w|$ > 1, allora $w$ deve iniziare con e finire con lo stesso simbolo, quindi $w=0x 0 " oppure " w=1x 1$, con $x$ palindroma e $|x| = |w| - 2$.\
  Per l'ipotesi induttiva $S der(+) x$:
  - se $w = 0 x 0$ allora $S => 0 S 0 der(+) 0 x 0 = w$
  - se $w = 1 x 1$ allora $S => 1 S 1 der(+) 1 x 1 = w$
  #line(length: 100%, stroke: .25pt)
  Ora passiamo alla *correttezza*:\
  Iniziamo supponendo $S der(+) w$ e mostriamo per induzione sul numero di passi della derivazione che $w$ è palindroma.

  - _Caso base_: Se la derivazione utilizza un solo passo allora può usare solo 3 delle regole:
    $
      S -> epsilon quad quad quad quad
      S -> 0 quad quad quad quad
      S -> 1
    $
    Queste regole generano una stringa che è sicuramente palindroma, essendo $|w| = 1 "oppure" |w| = 0$
  - _Induzione_: Se, invece, supponendo l'enunciato per tutte le derivazioni in n passi, la derivazione usa $n+1$ passi, allora la stringa generata sarà nella forma:
    $
      S => 0 S 0 der(+) 0 x 0 = w quad "oppure" quad S => 1 S 1 der(+) 1 x 1 = w
    $
    Poiché $S der(+) x$ in $n$ passi, $x$ è palindroma e quindi anche $0 x 0$ e $1 x 1$ sono palindrome
]


== Esempi

#example(multiple: true)[
  + Stringhe su ${a,b}$ che *iniziano con $a$* e hanno *lunghezza pari*\
    $S->"ab"|"aa"|S"aa"|S"ab"|S"ba"|"Sbb"$\
    aa, ab $in L$\
    se $u in L$, allora uaa, uab, uba, ubb $in L$
  + Stringhe su {a,b} in cui ogni *$b$* è *preceduta da $a$*\
    $Sigma in L quad quad quad quad quad quad u in L$ allora ua, uab $in L$\
    $S -> epsilon | "Sa" | "Sab"$

  + Stringhe su {a,b} di lunghezze dispari in cui il primo carattere e quello centrale sono uguali:
    $
      & L = {w in {"a,b"}^* |w = "axay"  && or w="bxby con" |y|=|x|+1} \
      & S->"aA | bB " quad quad "oppure" && S-> "aAX" | "bBX" \
      & A-> "XAX" | "aX"                 && A-> "XAX" | "a" \
      & A-> "XBX" | "bX"                 && B-> "XBX" | "b" \
      & X-> "a | b"                      && X-> "a | b"
    $
]
// TODO: Aggiungere gli altri esempi del PDF

== Grammatiche regolari (par 4.2.7)

Così chiamate perché i linguaggi generati sono rappresentabili tramite espressioni regolari. La differenza con le grammatiche context-free è il come sono definite le produzioni. Qui possono avere la seguente forma:
$
  & "destre"                        && "sinistre"\
  & X --> a Y                       && X->Y a \
  & X --> a                         && X->a \
  & X --> epsilon                   && X->epsilon \
  & "con "X,Y in V " e " a in Sigma
$

Nel caso delle grammiche regolari sinistre avremmo la seguente forma di frase:
$
  &"Sinistre": S der(*) w X quad "con" quad w in Sigma^*, space X in V\
  &"Destre": S der(*) X w quad "con" quad w in Sigma^*, space X in V
$
ovvero:
- Se è una *grammatica regolare destra*, a destra troveremo zero o più simboli terminali seguiti da un simbolo non terminale.
- Se è una *grammatica regolare sinistra*, a destra troveremo un simbolo termianle seguito da zero o più simboli terminali.

Quindi in quella *destra* si ha come ultimo simbolo il solo simbolo non terminale, mentre in quella *sinistra* si avrà il contrario, il primo simbolo è l'unico simbolo non terminale. (DEL CORPO).

N.B.: Le grammatiche sono *esclusivamente* destre o sinistre, non ci sono forme ibride.

Si può quindi notare che c'è un solo modo per terminare la derivazione, applicando una delle regole della forma $X --> a$ oppure $X --> epsilon$.

Generalmente useremo la grammatica regolare sinistra negli esempi sottostanti.

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

  #colbreak()
  3. Stringhe su {a,b} che non contengono tre *$a$* consecutive:\
    $
      (b+a b+a a b)^*(epsilon+a+a a)
    $
    #block($
             &S -> a A|b S| epsilon quad quad quad quad quad quad quad quad quad && "se "S der(*)w S "allora" w = epsilon "oppure" w=u b\
             &A -> a B|b S| epsilon && "se "S der(*)w A "allora" w = a "oppure" w=u b a\
             &B-> b S| epsilon && "se "S der(*)w B "allora" w = a a "oppure" w=u b a a
    $)
    
    La differenza con l'esempio precedente è in B, essendo che non può più aggiungere una 'a' ma solo una 'b' o terminare la derivazione
  + Stringhe su {a,b} che non cominciano con "aaa":\
    $
      (b+a b+a a b)(a+b)^*+epsilon+a+a a
    $
    
    #block($
      &S->a A | b C | epsilon\
      &A->a B | b C | epsilon quad quad quad quad quad quad quad quad quad quad && "se" S der(*)w A "allora" w=a\
      &B->b C | epsilon &&"se" S der(*)w B "allora" w=a a\
      &C->a C | b C | epsilon &&"se" S der(*)w c "allora" w="inizia con "b, a b" o "a a b
    $)
  + Stringhe su {a,b} che non contengono la sottostringa "aba":
    $
      (b+a^+b b)^*(epsilon+a^++a^+b)
    $
    #block($
      &S->a A | b S | epsilon quad quad quad quad quad quad quad quad quad &&"se" S der(*)w S "allora" w=epsilon, w=b "oppure" w=u b b\
      &A->a A | b B | epsilon &&"se" S der(*)w A "allora" w=u a\
      &B->b S |epsilon     &&"se" S der(*)w B "allora" w=u a b
    $)
  + Stringhe su {a,b} in cui ogni $a$ è preceduta o seguita da $b$:
    $
      (b + a b + b a + a b a)^*
    $
    #block($
             &S->a A | b B | epsilon #h(4cm) &&"se" S der(*)w S "allora" w = u b a "oppure" w = epsilon\
             &A->b B && "se" S der(*)w A "allora" w=a "oppure" w=u b a a\
             &B->a S | b B | epsilon && "se" S der(*)w B "allora" w=u b\
           $)
  + Stringhe su {a,b} con un numero pari di $a$ e $b$:
    $
      (a+b)^*b(a+b)(a+b)
    $
    #block($
             &S->a S | b S | b A\
             &A->a B | b B #h(4cm) && "se" S der(*)w A "allora" w=u b\
             &B->a | b && "se" S der(*)w B "allora" w = u b a "oppure" w = u b b
           $)
  + Stringhe su {a,b} con un numero pari di $a$ o un numero dispari di $b$:
    $
      (a a+b b+(a b+b a)(a a+b b)^*(a b+b a))^*
    $
    #block($
             &S->a A | b B | epsilon #h(4cm) && S der(*)w S "allora" abs(w)_a "e" abs(w)_b "sono pari"\
             &A->a S | b C && S der(*)w A "allora" abs(w)_a "è dispari e" abs(w)_b "è pari"\
             &B->a C | b S && S der(*)w B "allora" abs(w)_a "è pari e" abs(w)_b "è dispari"\
             &C->a B | b A && S der(*)w C "allora" abs(w)_a "e" abs(w)_b "sono dispari"\
           $)
    #figure(
      table(
        columns: (auto, auto, auto),
        rows: (auto, auto, auto, auto, auto),

        [], [$abs(w)_a$], [$abs(w)_b$],
        table.cell(fill: rgb("#68e86680"), "S"), [*_pari_*], [*_dispari_*],
        align: center,
        [A], [_dispari_], [_pari_],
        [B], [_pari_], [_dispari_],
        [C], [_dispari_], [_dispari_]
      )
    )
  + Stringhe su {a,b} di lunghezza dispari che contengono esattamente due $b$:
    $
      a(a a)^*b(a a)^*b(a a)^* + (a a)^*b a(a a)^*b(a a)^*+(a a)^*b(a a)^*b a(a a)^*+a(a a)^*b a(a a)^*b a(a a)
    $
    6 possibili situazioni per $S der(*)w X$
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
      )
    )
    #block($
            &S->a A | b B #h(4cm) && "se" S der(*)w S "allora" abs(w) "è pari e" abs(w)_b = 0\
            &A->a S | b C         && "se" S der(*)w A "allora" abs(w) "è dispari e" abs(w)_b = 0\
            &B->a C | b D         && "se" S der(*)w B "allora" abs(w) "è dispari e" abs(w)_b = 1\
            &C->a B | b E         && "se" S der(*)w C "allora" abs(w) "è pari e" abs(w)_b = 1\
            &D->a E               && "se" S der(*)w D "allora" abs(w) "è pari e" abs(w)_b = 2\
            &E->a D | epsilon     && "se" S der(*)w E "allora" abs(w) "è dispari e" abs(w)_b = 2
          $)
  + Stringhe su {a,b} in cui "aa" occorre esattamente una volta:
    $
      (b+a b)^*a a(b+b a)^*
    $
    #block($
             &S->a A | b S #h(4cm)    && "se" S der(*)w S "allora" w = epsilon "oppure" w = u b\
             &B->b C | epsilon        && "se" S der(*)w A "allora" w = a "oppure" w = u b a\
             &A->a B | b S            && "se" S der(*)w B "allora" w = u a" e "w "contiene" a a\
             &C->a B | b C | epsilon  && "se" S der(*)w C "allora" w = u b" e "w "contiene" a a
           $)
    #figure(
      table(
        columns: (auto, auto, auto),

        [], [contiene $a a$], [ultimo caratere],
        [S], [_no_], [_b($epsilon$)_],
        [A], [_no_], [_a_],
        table.cell(fill: rgb("#68e86680"), "B"), [*_sì_*], [_a_],
        table.cell(fill: rgb("#68e86680"), "C"), [*_sì_*], [_b_]
      )
    )
  #colbreak()
  11. Stringhe su {a,b} in cui "aa" occorre almeno due volte:
    $
      (a+b)^*(a a(a+b)^*a a+a a a)(a+b)^*
    $
    #block($
             &S->a A | b S #h(3.5cm) && "se" S der(*)w S "allora" w = epsilon "oppure" w = u b\
             &A->a B | b S && "se" S der(*)w A "allora" w = a "oppure" w = u b a\
             &B->a D | b C && "se" S der(*)w B "allora" w = u a "e w contiene" a a\
             &C->a B | b C && "se" S der(*)w C "allora" w = u b" e "w" contiene "a a\
             &D->a D | b D | epsilon && "se" S der(*)w D "allora" w "contiene 2 volte" a a
           $)
    #figure(
      table(
        columns: (auto, auto, auto),

        [], [numero $a a$], [ultimo simbolo],
        [S], [0], [_b($epsilon$)_],
        [A], [0], [_a_],
        [B], [1], [_a_],
        [C], [1], [_b_],
        table.cell(fill: rgb("#68e86680"), "D"), [$>=$2], [_a,b_]
      )
    )
]

== Gerarchie di Chomsky (classificazione delle grammatiche) 

Ci sono 4 classi di grammatiche, distinte tra di loro per la strutture delle loro regole. I tipi partono da 0 e, ad ogni incremento, aumenta il numero di restrizioni fino al 3.

0. *#link(<gramNoRes>)[Grammatiche senza restrizioni (a struttura di frase)]*
+ *#link(<gramCont>)[Grammatiche contestuali]*
+ *#link(<gramNoCont>)[Grammatiche non contestuali]*
+ *#link(<gramReg>)[Grammatiche regolari]*

Ovviamente hanno sempre in comune la definizione della grammatica (#ref(<defGrammar>))\
Le grammatiche non contestuali (context-free) e regolari, anche se già spiegate, verrano rispiegate molto brevemente

=== Grammatiche senza restrizioni (a struttura di frase) <gramNoRes>

In questo tipo di grammatica, le produzioni hanno la seguente forma:
$
  alpha -> beta, quad alpha in (V union Sigma)^+ space " e " space beta in (V union Sigma)^*
$
Ovvero $alpha$ non può essere una stringa nulla. Ha senso chiedere che $alpha$ abbia almeno un non terminale:
$
  alpha in (V union Sigma)^* V (V union Sigma)^* \
$
I concetti di derivazione diretta e indiretta e tutte le nozioni introdotte nella grammatica context-free sono sempre validi.

Quindi, siano $alpha, beta, gamma, delta in (V union Sigma)^*$ con $alpha eq.not epsilon$, se abbiamo una stringa $gamma alpha delta$ e applichiamo la regola $alpha -> beta$, otteniamo la stringa $gamma beta delta$, indicato sempre con:
$
  gamma alpha delta => gamma alpha delta quad quad ("stesso uso anche per "der(*)" e "der(+))
$
Anche per il linguaggio rimane uguale, quindi corrisponde all'insieme di stringhe derivabili da S:
$
  L(G) = {w | S der(+) w " e " w in Sigma^*}
$

=== Grammatiche contestuali <gramCont>

Questa grammatiche ha due definizioni che sono equivalenti:
#definition("1")[
  $alpha -> beta$ dove $alpha, beta in (V union Sigma)^+ quad quad$ (oppure $alpha in (V union Sigma)^* V (V union Sigma)^*$)\
  e, inoltre, $|alpha| <= |beta| quad ("quindi " beta eq.not epsilon)$
]
#pagebreak()
#definition("2")[
  $alpha_1A alpha_2 -> alpha_1beta alpha_2 quad$ con $A in V, space alpha_1, alpha_2, beta in (V union Sigma)^* " e " beta eq.not epsilon$
]

Queste due definizioni sono, come detto, equivalenti, ma la seconda spiega meglio il termine *contestuale*: la sostituzione di $A$ con $beta$ può essere effettuata soltanto nel contesto delle stringhe $alpha_1, alpha_2$, quindi quando A è preceduta $alpha_1$ e seguita da $alpha_2$. Se ci fosse un $alpha_3 eq.not alpha_1, alpha_2$ al posto di una delle due non potremmo applicare la stessa regola.

=== Grammatiche non contestuali <gramNoCont>
La forma delle regole è la seguente:
$
  A -> beta quad "con" A in V " e " beta in (V union Sigma)^*
$
Quindi, a prescindere dal contesto in cui si trova, un simbolo A può essere sostituito col simbolo $beta$.

=== Grammatiche regolari <gramReg>

Le regole delle grammatiche regolari hanno la seguente forma:
$
  & "(destre)" quad && quad quad quad  && ("sinistre") \ 
  & X -> a Y        &&                 && X -> Y a     \ 
  & X -> a          &&                 && X -> a       \
  & X -> epsilon    &&                 && X -> epsilon \
  & "con" X,Y       && in V " e "      && a in Sigma
$

=== Parte extra sulla gerarchia
- Ogni grammatica di tipo $i > 0$ è anche di tipo $i - 1$ (precisando che, però, nei linguaggi contestuali non sono ammesse le regole del tipo $X -> epsilon$). In più, un linguaggio è di tipo i se generato da una grammatica di tipo i, ma non di una tipo i+1
- Supponiamo $G = (V, Sigma, P, S)$ grammatica che genera $L(G)$, esiste, allora, una grammatica $G_1$ che genera $L(G) - {epsilon}$ che non contiene regole del tipo $X -> epsilon$. Esiste, quindi, anche una grammatica $G_2$ tale che L(G) = L(G_2) e che contiene un'unica regola che produce $epsilon$.
- Le *grammatiche non contestuali* sono usate per definire la sintassi dei linguaggi di programmazione e sono usate nella fase di *analisi sintattica*.
- Le *grammatiche regolari* sono usate nella fase di *analisi lessicale*
- Ad ogni classe di grammatiche corrisponde la classe dei linguaggi generati:
  - $"grammatiche senza restrizioni  "   <--> "  linguaggi ricorsivamente enumerabili"$
  - $"grammatiche contestuali         "  <--> "  linguaggi contestuali"$
  - $"grammatiche non contestuali   "    <--> "  linguaggi non contestuali"$
  - $"grammatiche regolari             " <--> "  linguaggi regolari"$
- Ad ogni classe di grammatiche corrisponde inoltre un tipo di macchine astratte utilizzabili per stabilire se una stringa appartiene ad un dato linguaggio
#pagebreak()
#table(
    columns: (auto, auto, 1fr, 1fr),
    align: (center, left, left, left),
    header(
      [*Tipo*], [*Grammatiche*], [*Linguaggi*], [*Macchine*]
    ),
    [0], [Senza Restrizioni], [Ricorsivamente enumerabili], [Macchine di Turing],
    [1], [Contestuali], [Contestuali], [Automi limitati superiormente],
    [2], [Non contestuali], [Non contestuali], [Automi a pila],
    [3], [Regolari], [Regolari], [Automi a stati finiti]
  )

$
  #cetz.canvas({
    import draw: rect, content,

    rect((0, 0), (11, 6), radius: 5pt)
    content((5.5,5.5), "Linguaggi ricorsivamente enumerabili")
    rect((0.5, 0.5), (10.5, 5), radius: 5pt)
    content((5.5, 4.5), "Linguaggi contestuali")
    rect((1, 1), (10, 4), radius: 5pt)
    content((5.5,3.5), "Linguaggi non contestuali")
    rect((1.5, 1.5), (9.5, 3), radius: 5pt)
    content((5.5,2.5), "Linguaggi regolari")
  })
$

#example(multiple: true, "Linguaggi non contestuali")[
  - ${a^n b^n | n >= 0}$\
    $S -> a S b | epsilon$
  
  - ${w in {a,b}^* | abs(w)_a=abs(w)_b}$\
    $S -> a S b S | b S a S | epsilon$
  
  - ${w in {0,1}^* | w = w^R}$\
    $S -> epsilon|0|1|0S 0|1S 1$

  - ${a^n b^n c^k | n,k>=0}$\
    $S->A B$\
    $A -> a A b -> epsilon$\
    $B -> c B | epsilon$
  
  - ${a^n b^n c^k d^k | n,k>=0}$\
    $S->A B$\
    $A -> a A b -> epsilon$\
    $B -> c B d | epsilon$

  - ${a^n b^k c^k d^n | n,k>0}$\
    $S-> a S d | a A d$\
    $A -> b A c -> b c$

  - ${a^n b^k c^(2n+k) | n,k>0}$\
    $S-> a S c c | a B c c$\
    $A -> b B c | b c$
  Non tutti i linguaggi possono essere generati da una grammatica non contestuale:
  - ${a^n b^n c^n | n > 0}$
  - ${a^n b^k c^n d^k | n,k>0}$
  - ${w w | w in {a,b}^*}$
]


#example(multiple: true, "Linguaggi constetuali")[
  - ${a^n b^n c^n | n > 0}$\
    $S -> a b c | a X b c$\
    $X -> a X b C | a b C$\
    $C b -> b C$\
    $C c -> c c$

    $S => a underline(X) b C => a bold(a underline(X) b C) b C => a a bold(a b) underline(bold(C) b) C b C => a a a b bold(b C) underline(C b) b c => a a a b b underline(C bold(b)) bold(C) c => a a a b b bold(b C) underline(C c) => a a a b b b underline(C bold(c)) bold(c) => a a a b b b bold(c c) c$

    Più in generale si può scrivere: $ => a X b c der(+) a^n (b C)^(n-1)b c der(+) a^n b^n C^(n-1)c der(+) a^n b^n c^n$
  
  - ${a^n b^k c^n d^k | n,k > 0}$\
    $S -> A B$\
    $A -> a A C | a C$\
    $B -> b B d | b d$\
    $C b -> b C$\
    $C d -> c d$\
    $C c -> c c$

    $S => A B der(+) a^n C^n B der(+) a^n C^n b^k d^k der(+) a^n b^k C^n d^k => a^n b^k C(n-1)c d^k der(+) a^n b^k c^n d^k$
  
  - ${w w | w in {a,b}^*}$

    #line(length: 100%, stroke: .25pt)
    #block($
      &S -> a A S | b B S | X a | Y b quad quad quad quad &&quad quad quad quad quad quad quad quad  S &&&&der(+) #colmath(7, $bold((a A union b B)^*(X a union Y b))$)\
      &A a -> a A && &&&&der(*) #colmath(10, $bold(w a X a)$) " oppure " #colmath(10, $bold(w a Y b)$)\
      &A b -> b A && quad quad quad quad quad "   con" w&&&&=x_1 x_2 dots x_k in {a,b}^k\
      &B a -> a B && quad quad quad quad quad quad quad quad alpha&&&&=X_1X_2dots X_k in {A,B}^k\
      &B b -> b B && "  dove" X_i=A "se" x_i &&&&=a "se" X_i=B "se" x_i=b
    $)
    #line(length: 100%, stroke: .25pt)
    #block($
      &A X -> X A \
      &A X -> X A quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad space der(+) #colmath(16, $bold(w X w a)$) " oppure " #colmath(16, $bold(w Y w b)$)\
      &B Y -> Y B \
      &B Y -> Y B 
    $)
    #line(length: 100%, stroke: .25pt)
    #block($
      &X -> a quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad " " der(+) #colmath(3, $bold(w a w a)$) " oppure " #colmath(3, $bold(w b w b)$)\
      &Y -> b 
    $)
    #block($
      S &=> a A S => a A b B S =>a A b B b B S => #colmath(7, $bold(a A b B b B X a)$) => a A b b B B X a => a b A b B B X a\
      &=> #colmath(10, $bold(a b b A B B X a)$) => a b b A B X b a => a b b A X b b a => #colmath(16, $bold(a b b X a b b a)$) => #colmath(3, $bold(a b b a a b b a)$)
    $)
    // TODO?: Non so se ne mancano altri da scrivere o meno
]