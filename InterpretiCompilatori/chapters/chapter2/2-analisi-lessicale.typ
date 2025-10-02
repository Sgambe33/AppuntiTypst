#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw

#pagebreak()
= Analisi Lessicale

== Espressioni regolari
#definition()[
  Le espressioni regolari sono una notazione sintetica oer i linguaggi regolari ed operano sui simboli dell'alfabeto.
  - Un simbolo $t$ rappresenta il linguaggio composto dal simbolo stesso: ${t}$;
  - $epsilon$ rappresenta ${epsilon}$;
  - $emptyset$ rappresennta $emptyset$;
]

Se $x$ e $y$ sono due espressioni regolari e $L_x$ e $L_y$ i linguaggi corrispondenti, gli operatori applicabili in ordine di priorità decrescente sono:

#set math.cases(reverse: true)
$display(
  cases(
    "1. chiusura di " x\, x^*\, "indica" (L_x)^*,
    "2. chiusura di " x\, x^+\, "indica" (L_x)^+
  )
)
x^+=x x^* =x^* x$

#set math.cases(reverse: false)

3. concatenazione di x e y, $x y$, indica $L_x L_y$
+ unione di x e y, $x + y$ oppure $x | y$, indica $L_x union L_y$
+ opzionalità di x, $[x]$ oppure $x?$, indica $L_x union {epsilon} ==> x? = x | epsilon$

=== Proprietà

- #text(red)[Unione]:
  + Commutativa: $x | y = y | x$;
  + Associativa: $x | (y | z) = (x | y) | z$.
- #text(red)[Concatenazione]:
  + Distributiva rispetto all'unione: $x(y | z) = x y | x z$;
  + Associativa: $x (y z) = (x y) z$;
  + Elemento neutro: $epsilon x = x epsilon = x$;
- #text(red)[Chiusura]:
  + $epsilon in x^* quad x^*=(x | epsilon)^*$
  + Idempotenza: $(x^*)^* = x^*$
#example()[
  + $(a a)^*$: corrisponde a una stringa con $n space a$, dove $n>=0$ è pari\
  + $(a a)^+$: uguale alla precedente, però stavolta niente stringa vuota. $(n>0)$
  + $(a | b)^*$: una qualsiasi sequenza di $a$, $b$ o stringa vuota
  + $(b | a b)^*$: non ci sono $a$ consecutive
  + $((a | b)(a | b))^* => (a(a | b) | b(a | b))^* => (a a | a b | b a | b b)^*$: tutte stringhe di lunghezza pari
]

#example()[
  + ${a, b}$, contengono $a b a quad ==> (a bar b)^* a b a (a bar b)^*$
  + ${a, b}$, non contengono $a b a quad ==> (b bar a^+ b b)^*(epsilon bar a^+ | a^+ b)$
  + ${a, b}$, ogni $a$ è preceuta o seguita ad $b quad ==> (b bar a b | b a)^* => ((epsilon bar a)b bar (epsilon | a) b a)^* =$$=> ((epsilon bar a) (b bar b a))^*$
  + ${a, b}$, in cui il terzultimo carattere è $b quad ==> (a bar b)^*b bar (a bar b)(a bar b)$
  + ${a, b}$, con numero pari di $a$ e un numero pari di $b$\
  $
    (a a | b b | (a b | b a) (a a | b b)(a b | b a))^*
  $
  6. ${a, b}$, con numero pari di $a$ o un numero dispari di $b$
  $
    b^*(a b^* a b^*)^* | a^* b a^* (b a^* b a^*)^*
  $
  7. ${a, b}$, stringhe di lunghezza dispari che contengono esattamenet 2 $b$
  $
    a(a a)^* b a(a a)^* b (a a)^* | (a a)^* b a(a a)^* b (a a)^* | (a a)^* b (a a)^* b a(a a) | a(a a)^* b (a a)^* b a(a a)^*
  $
  8. ${a, b}$, stringhe dove $a a$ occorre una sola volta
  $
    (b | a b)^* a a (b | b a)^*
  $
]

=== Definizioni regolari

#definition()[
  Una *definizione regolare* è una sequenza finita di definizioni come segue:
  $
    d_1 -> r_1 \
    d_2 -> r_2 \
    dots.v \
    d_8 -> r_8 \
    d_9 -> r_9 \
    dots.v \
    d_n -> r_n \
  $
  dove $d_i$ è un simbolo nuovo rispetto a $Sigma (d_i in.not Sigma)$ e ogni $r_i$ è un'espressione regolare su $Sigma union {d_1, dots, d_(i-1)}$ con $i = 1,dots,n$
]

Sia $Sigma={A,B,dots,Z,a,b,dots,z,0,1,dots,9,\_}$ l'alfabeto di tutti i caratteri che possono essere contenuti in un identificatore di variabile. L'espressione regolare necessaria per verificare la correttezza di un identificatore è la seguente.
$
  (A|B|dots|Z|a|b|dots|z|0|1|dots|9|\_)(A|B|dots|Z|a|b|dots|z|\_|0|1|dots|9)^*
$

Usando le definizioni regolari si può ottimizzare:
- letter $=> A|B|dots|Z|a|b|dots|z|\_$
- digit  $=> 0|1|dots|9$
- $id =>$ $"letter"("letter"|"digit")^*$

#example()[
  Per validare le *costanti numeriche senza segno* possiamo usare:\
  $Sigma={0|1|dots|9|.|+|-|"E"}$\
  $"digit" -> 0|1|dots|9$\
  $"digits" -> cancel("digit digit"^*) space space "digit"^+$\
  $"optionalFraction" -> epsilon | ."digits"$\
  $"optionalExponent" -> epsilon | "E"(epsilon,+,-)"digits"$\
  $"number" -> "digits optionalFraction optionalExponent"$
]

=== Estensioni delle espressioni regolari

Dopo l'introduzione delle espressione regolari sono state proposte ed introdotte estensioni utili a migliorare la capacità espressiva delle espressioni regolari.
Alcune delle estensioni introdotte da alcuni programmi UNIX sono:
+ *Una o più occorrenze*: l'operatore unitario post-fisso '+' indica la chiusura positiva di un'espressione regolare e del linguaggio ad essa associato $(r: "espressione regolare", r^+ " denota "L(r)^+)$. Si può anche vedere com'è legata alla chiusura di Kleene dalle leggi algebriche:
  - $r^* = r^+ | epsilon$
  - $r^+=r r^* = r^* r$
  L'operatore '$+$' ha la stessa precedenza e associatività dell'operatore '$*$';

  #observation()[
    $r^+=r r^* = r^* r$ è una propietà importante delle espressioni regolari che può essere dimostrata.

    #proof()[
      Ricordando le definizioni di chiusura di Kleene e chiusura positiva:
      $
        r^* = {epsilon} union r union r r union r r r union ...= union.big_(n gt.eq 0) r^n \
        r^+ = r union r r union r r r union ...= union.big_(n gt 0) r^n
      $
      + $r r^* = r dot union.big_(n gt.eq 0) r^n = union.big_(n gt.eq 0) r dot r^n = union.big_(n gt.eq 0) r^(n+1) = union.big_(m gt 0) r^m = r^+$
      + $r^*r = (union.big_(n gt.eq 0) r^n) r= union.big_(n gt.eq 0) r^n dot r = union.big_(n gt.eq 0) r^(n+1) = union.big_(m gt 0) r^m = r^+$
    ]
  ]


+ *Zero o una occorrenza*: l'operatore unitario post-fisso '?' indica l'opzionale presenza dell'operando a cui viene applicato (Quindi: $r? " equivale a " r|epsilon " oppure " L(r)?=L(r) union L(epsilon)$). Come il precedente, ha la stesa precedenza e associatività dell'operatore '$*$';
+ *Classi di caratteri*: un'espressione regolare come $a_1 bar a_2 bar ... bar a_n$ in cui i simboli $a_i$ appratengono all'alfabeto $Sigma$ può essere sostituita dalla forma compatta $[a_1, a_2, ..., a_n]$. Inoltre, quando i simboli formano una sequenza logica, per esempio lettere maiuscole, lettere minuscole o cifre, si può ulteriormente sintetizzare l'espressione scrivendola come $a_1 - a_n$.

#example()[
  $
    [a b c] "sta per" a|b|c
  $
  Se i caratteri formano una sequenza logica:
  $
    "allora: "[A-Z] "sta per" A|B|dots|Z\
    "es." [0-9] "sta per" [0 1 2 dots 9] "che sta per" 0|1|dots|9\
    "es." [a-z] "sta per" [a b c dots z] "che sta per" a|b|dots|z
  $
]

Adesso possiamo allora ridefinire digit, digits e number:
$
  "digit" => [0-9]\
  "digits" => "digit"^+\
  "number" => "digits"(."digits")?(E[+-]?"digits")?
$
#pagebreak()
== Definizione della grammatica

#definition()[
  $G=(V,Sigma,P,S)$ grammatica *context free*:
  - $Sigma$, alfabeto dei simboli terminali
  - $V$, l'insieme dei simboli non terminali ($V inter Sigma=nothing$)
  - $P$,  l'insieme delle regole (produzioni) di tipo:
    $A --> alpha$ dove $A in V$ e $alpha in (V union Sigma)^*$
  - $S in V$, simbolo iniziale
]

Una grammatica ha quattro componenti ($G (V,Sigma,P,S)$):
+ Un insieme di *simboli terminali* ($Sigma$): Questo corrisponde quindi all'alfabeto usato dalla grammatic per definire un lingaggio. I simboli terminali vengono anche definiti *token*;
+ Un insieme di *simboli non-terminali* ($V$): o "variabili sintattiche".
+ Un insieme di *produzioni* ($P$): o regole. L'obiettivo di base di una produzione
+ Un *simbolo iniziale* ($S$): scelto tra i non-terminali della grammatica

#observation()[
  La parte sinistra di una produzione è sempre un singolo *non* terminale, da cui il nome *context-free*: la sostituzione non dipende dal contesto circostante.
]

#observation()[
  Se ho più produzioni/regole, le posso scrivere in forma compatta:
  $
    display(
      cases(
        reverse: #true,
        A->alpha_1,
        A->alpha_2,
        dots->dots,
        A->alpha_n
      )
    )
    A-->alpha_1|alpha_2|dots|alpha_n
  $
]


=== Derivazione

#example()[
  $A-->alpha$

  $beta A gamma ==> beta alpha gamma$

  $A in V quad quad alpha, beta, gamma in (Sigma union V)^*$
]

$alpha => beta_1 =>beta_2=>dots=>beta_n=gamma$\
$alpha ==>^+gamma$\
$alpha ==>^*gamma$

#observation("Transitività derivazione")[
  L'operazione di derivazione gode della proprietà transitiva:
  - $underline("Base"): alpha=>^*alpha$
  - $underline("Induzione"): alpha =>^* beta " e " beta => gamma$ allora $alpha =>^* gamma$
]

#definition()[
  Una *forma di frase* è una qualsiasi stringa di simboli (cioè una sequenza di terminali e/o non terminali) che si può ottenere a partire dal simbolo iniziale $S$ applicando zero o più regole di produzione. Data $G$ grammatica:
  $
    beta "è una forma di frase di" G <==> S=>^* beta " e " beta in (V union Sigma)^*
  $
]

#definition()[
  Una *frase* è una forma di frase che contiene solo terminali.
  $
    W "è una di frase di" G <==> S=>^* W " e " W in Sigma^* "OPPURE " Sigma^+ "?????"
  $
]

#definition()[
  Il linguaggio generato da $G$ è l'insieme di tutte le frasi (stringhe di soli terminali) derivabili da $S$:
  $
    L("G")={W in Sigma^* bar S =>^+ W} "BOOOOH RIGUARDA SIMBOLI"
  $
]

==== Derivazione destra/sinistra
#definition()[
  $S=>^*beta$ è una *derivazione destra/sinistra* se ad ogni passo viene applicata una regola alla variabile più a destra/sinistra:
  $
    S=>^*w in Sigma^+
  $
]

#example()[
  $
          & V                 && Sigma \
    G=({E & , I}, {+, *, (, ) && , a, b, 0, 1}, E, P) quad quad space space
  $
  $
    "Produzioni":cases(
      reverse: #true,
      & E->I | && E+E | E*E | (E) \
      & I->a | && b | I a | I b | I 0 | I 1
    ) "Costruzione di espressioni"
  $
  Ad esempio possiamo risalire alla sequenza di derivazioni per ottenere la seguente espressione:
  $
    & underbracket("ab")* && underbracket(("b01"+ "ab")) \
    & E                   && quad space space space E
  $
  $
    #let end = "ab*b01+ab"; & E = E*E => I*E => I"b" * E => "ab"*E => "ab" * (E) => "ab"*(E+E) => \
                         => & "ab"*(I+E) =>"ab"*(I"1"+E) =>"ab"*(I"01"+E) => "ab"*("b01"+E) => \
                         => & "ab"*("b01"+I) => "ab"*("b01"+I"b") => "ab"*"b01"+"ab"
  $

  //TODO: manca l'albero di parsing
]

#definition("Completezza")[
  Sia $w in L$ (palindromo), allora $w in L(G)$, cioè esiste $S=>^*w$
]

#proof()[
  Induzione su $|w|$
  - *#underline("Base")*: se $|w|=0, |w|=1, quad$allora $w=epsilon, w=0, w=1$
  - *#underline("Ipotesi induttiva")*: Supponiamo che se $|w| <= n$, allora esiste $S=>^+w (n>1)$\
    $|w|=n+1$\
    $w=0 x 0,$oppure $w=1 x 1$, con $x$ che è palindromo ($in L; |x| = |w| - 2$)
    $S=> 0 S 0 =>^+ 0 x 0 = w$
    Esiste quindi la derivazione da $S$ a $w$.
]

#definition("Correttezza")[
  MANCANTE
]

#proof()[
  Per induzione sul numero di passi della derivazione
  - *#underline("Base")*: Se $|"deriv"|=1$ allora otteno $epsilon, 0, 1 in L$
  - *#underline("Ipotesi induttiva")*: Se $|"deriv"|=n$ allora $S=+w, space w in L$\

    $S=>0 S 0=>^+ 0 "x" 0$
]


#example()[
  + Stringhe su ${a,b}$ che *iniziano con $a$* e hanno *lunghezza pari*\
    $S->"ab"|"aa"|S"aa"|S"ab"|S"ba"|"Sbb"$\
    aa, ab $in L$\
    se $u in L$, allora uaa, uab, uba, ubb $in L$
  + Ogni *$b$* è *preceduta da $a$*\
    $Sigma in L quad quad quad quad quad quad u in L$ allora ua, uab $in L$\
    $S -> epsilon | "Sa" | "Sab"$

  + Stringhe su {a,b} di lunghezze dispari in cui il primo carattere e quello centrale sono uguale:
    $
      & L = {w in {"a,b"}^* |w = "axay"  && or w="bxby con" |y|=|x|+1} \
      & S->"aA | bB " quad quad "oppure" && S-> "aAX" | "bBX" \
      & A-> "XAX" | "aX"                 && A-> "XAX" | "a" \
      & A-> "XBX" | "bX"                 && B-> "XBX" | "b" \
      & X-> "a | b"                      && X-> "a | b"
    $
]

== Buffering dell'ingresso

Siccome il codice sorgente di ogni programma risiede in memoria secondaria, e di conseguenza anche tutti i suoi simboli/token, risulta costoso accervi per l'analisi. Per questo motivo si usano dei buffer nella RAM.

Uno dei sistemi più utilizzati si basa su due buffer di dimensione $N$, dove $N$ di solito ha la stessa dimensione di un blocco del disco, per esempio 4096 byte. Con una singola operazione di lettura è possibile leggere un intero blocco di $N$ caratteri (molto meglio di $N$ letture di singoli caratteri). Quando meno di $N$ caratteri rimangono nel file, il carattere *eof* segnala la fine del file.

Per la gestione del buffer si usano due puntatori:
- _*lexemeBegin*_: indica l'indirizzo del lessema corrente, la cui lunghezza deve essere determinata.
- _*forward*_: si sposta in avanti finché non si riconosce un lessema corrispondente a un pattern.0-9

Una volta individuato il lessema, si sposta il puntatore _forward_ sul carattere immediatamente alla destra del lessema stesso. Quindi, dopo che tale lessema è stato memorizzato come attributo di token, il puntatore _lexemeBegin_ viene spostato immediatamente dopo il lessema appena trovato.

//TODO: Aggiungere frecce o copiare immagini da libro
$
  #let elements = ("A", none, none, none, "E", none, "=", none, "M", $"*"$, "C", $"*"$, $"*"$, "2", "eof", none, none, none, none, none)
  #cetz.canvas(length: 25pt, {
    import draw: content, line, rect
    draw.rect((-0.5, 0.5), (19.5, 1.5))
    for i in range(1, elements.len()) {
      if (i != 10) { draw.line((i - 0.5, 0.5), (i - 0.5, 1.5), stroke: (dash: "dotted")) } else {
        draw.line((i - 0.5, 0.5), (i - 0.5, 1.5))
      }
    }

    for i in range(0, elements.len()) { content((i, 1), elements.at(i)) }
  })
  #linebreak()
  #let elements = ("A", none, none, none, "E", none, "=", none, "M", $"*"$, "eof", "C", $"*"$, $"*"$, "2", "eof", none, none, none, none, none, "eof")
  #cetz.canvas(length: 25pt, {
    import draw: content, line, rect
    draw.rect((-0.5, 0.5), (21.5, 1.5))
    for i in range(1, elements.len()) {
      if (i != 11) { draw.line((i - 0.5, 0.5), (i - 0.5, 1.5), stroke: (dash: "dotted")) } else {
        draw.line((i - 0.5, 0.5), (i - 0.5, 1.5))
      }
    }

    for i in range(0, elements.len()) { content((i, 1), elements.at(i)) }
  })
$

Per poter spostare avanti il puntatore _forward_ è necessario prima verificare se si è raggiunta la fine di uno dei due buffer. In questo caso si deve ricaricare l'altro buffer con i caratteri letti dal file sorgente e spostare _forward_ all'inizio del buffer appena riempito. Affinché ciò avvenga senza problemi è necessario che la lunghezza di un lessema più il numero di caratteri letti in anticipo non superi la dimensione $N$ di ogni buffer, in caso contrario si sovrascriverebbe l'inizio di un lessema prima di avere finito di riconoscerlo.




=== Sentinelle

Se utilizzassimo il sistema precedentemente descritto, ogni volta che spostiamo _forward_ in avanti dovremmo verificare che non vada oltre la fine di uno dei due buffer. Quindi per ogni carattere dobbiamo effettuare due controlli: il primo per verificare se il puntatore ha raggiunto la fine del buffer e il secondo per verificare quale carattere è stato letto. Possiamo combinare i due test estendendo il buffer in modo da contenere un carattere che non può main comparire come parte di un programma sorgente: *eof* è perfetto.

```c
  switch(*forward++){
    case eof:
      if(forward è alla fine del primo buffer){
        ricarica il secondo buffer
        forward = inizio del secondo buffer;
      }else if (forward è alla fine del secondo buffer) {
        ricarica il primo buffer;
        forward = inizio del primo buffer;
      }
      else { /* eof nel mezzo di un buffer indica la fine del file */
        termina l analisi;
      }
      break;
    /* casi per gli altri caratteri */
  }
```


= Grammatiche regolari

Così chiamate perché i linguaggi generati sono rappresentabili tramite espressioni regolari. La differenza con le grammatiche context-free è il come sono definite le produzioni. Qui possono avere la seguente forma:
$
  & X --> a Y                       && (X->Y a) \
  & X --> a \
  & X --> epsilon \
  & "con "X,Y in V " e " a in Sigma
$

Le forme di frase saranno del tipo:
$
  S=>^*w X quad "con" quad w in Sigma^*, space X in V
$
ovvero con quanti terminali voglio (anche zero) e poi una variabile.

#example(multiple: true)[
  + Stringhe su {a,b} di lunghezza pari. Se io volessi usare una grammatica regolare:
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
  2. Stringhe su {a,b} che contengono tre *$a$* consecutive:
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
  3. Stringhe su {a,b} che non contengono tre *$a$* consecutive:
  4. Stringhe su {a,b} che non cominciano con "aaa":
  5. Stringhe su {a,b} che non contengono "aba" usando una grammatica regolare:
  6. Stringhe su {a,b} in cui ogni $a$ è preceduta o seguita da $b$:
  7. Stringhe su {a,b} con un numero pari di $a$ e $b$:
  8. Stringhe su {a,b} con un numero pari di $a$ o un numero dispari di $b$:
  9. Stringhe su {a,b} di lunghezza dispari che contengono esattamente due $b$:
  10. Stringhe su {a,b} in cui "aa" occorre esattamente una volta:
  11. Stringhe su {a,b} in cui "aa" occorre almeno due volte:
]

= Gerarchie di Chomsky (classificazione delle grammatiche)

0. *Grammatiche senza restrizioni (a struttura di frase)*
+ *Grammatiche contestuali*
+ *Grammatiche non contestuali (context-free)*
+ *Grammatiche regolari*

#align(center, [Le grammatiche si differenziano in base alla forma delle loro produzioni.])

== Grammatiche senza restrizioni (a struttura di frase)

In questo tipo di grammatica, le produzioni hanno la seguente forma:
$
  alpha -> beta, quad alpha in (V union Sigma)^+ space " e " space beta in (V union Sigma)^*
$
Ovvero $alpha$ non può essere una stringa nulla. Ha senso chiedere che $alpha$ abbia almeno un non terminale:
$
  & alpha in (Sigma union V)^+ ?V (union?, "concatenato????")? (Sigma union V)^* \
  & alpha, beta, gamma, S in (Sigma union V)^*, quad quad alpha in.not Sigma \
  & gamma alpha S --> gamma beta S
$

== Grammatiche contestuali
Hanno due possibili definizioni:
+ $alpha -> beta, quad alpha, beta in (Sigma union V)^+ space space (alpha in (Sigma union V)^* #text(stroke: .75pt)[?V?] (Sigma union V)^*) space " e " space |alpha|<=|beta|$
+ $alpha_1A alpha_2 --> alpha_1 beta alpha_2, quad quad "con " A in V, alpha_1,alpha_2,beta in (Sigma union V)^* space " e " space beta eq.not epsilon$

== Grammatiche non contestuali e regolari
Queste due sono state già precedentemente definite.
#observation()[
  Ogni grammatica di tipo $i$ è anche grammatica di tipo $i-1$.
]

