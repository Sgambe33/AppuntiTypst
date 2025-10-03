#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw
#import "@preview/pinit:0.2.2": *

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

== Buffering dell'ingresso

Siccome il codice sorgente di ogni programma risiede in memoria secondaria, e di conseguenza anche tutti i suoi simboli/token, risulta costoso accervi per l'analisi. Per questo motivo si usano dei buffer nella RAM.

Uno dei sistemi più utilizzati si basa su due buffer di dimensione $N$, dove $N$ di solito ha la stessa dimensione di un blocco del disco, per esempio 4096 byte. Con una singola operazione di lettura è possibile leggere un intero blocco di $N$ caratteri (molto meglio di $N$ letture di singoli caratteri). Quando meno di $N$ caratteri rimangono nel file, il carattere *eof* segnala la fine del file.

Per la gestione del buffer si usano due puntatori:
- _*lexemeBegin*_: indica l'indirizzo del lessema corrente, la cui lunghezza deve essere determinata.
- _*forward*_: si sposta in avanti finché non si riconosce un lessema corrispondente a un pattern.0-9

Una volta individuato il lessema, si sposta il puntatore _forward_ sul carattere immediatamente alla destra del lessema stesso. Quindi, dopo che tale lessema è stato memorizzato come attributo di token, il puntatore _lexemeBegin_ viene spostato immediatamente dopo il lessema appena trovato.

//TODO: Aggiungere frecce o copiare immagini da libro
$
  #let elements = ("A", none, none, none, "E", none, "=", none, "M", $"*"$, "C", [$"*"$#pin(1)], $"*"$, [2#pin(2)], "eof", none, none, none, none, none)
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

  #pinit-point-from(1, pin-dx: -2pt, pin-dy: 12pt, body-dy: -10pt, offset-dx: -2pt, offset-dy: 50pt)[#text(font: "Libertinus Serif", style: "italic")[lexemeBegin]]
  #pinit-point-from(2, pin-dx: -2pt, pin-dy: 12pt, body-dy: -10pt, offset-dx: -2pt, offset-dy: 35pt)[#text(font: "Libertinus Serif", style: "italic")[forward]]

  #linebreak()
  #linebreak()
  #linebreak()
  #linebreak()
  #linebreak()
  #linebreak()
  
  #let elements = ("A", none, none, none, "E", none, "=", none, "M", $"*"$, "eof", "C", [$"*"$#pin(3)], $"*"$, [2#pin(4)], "eof", none, none, none, none, none, "eof")
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

  #pinit-point-from(3, pin-dx: -2pt, pin-dy: 12pt, body-dy: -10pt, offset-dx: -2pt, offset-dy: 50pt)[#text(font: "Libertinus Serif", style: "italic")[lexemeBegin]]
  #pinit-point-from(4, pin-dx: -2pt, pin-dy: 12pt, body-dy: -10pt, offset-dx: -2pt, offset-dy: 35pt)[#text(font: "Libertinus Serif", style: "italic")[forward]]

  
  #linebreak()
  #linebreak()
  #linebreak()
  #linebreak()
  #linebreak()
  #linebreak()

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
= Grammatiche

#definition()[
  Le *grammatiche* si basano su un meccanismo generativo che *permette di produrre stringhe che appartengono al linguaggio desiderato*. \
  Formalmente una grammatica G è una quadrupla $(V, Sigma, P, S)$ dove:
  - *$Sigma$* è l'insieme dei simboli terminali
  - *$V$* è l'insieme dei simboli non terminali
  - *$P$* è l'insieme delle regole della grammatica
  - *$S in V$* è il simbolo iniziale della grammatica
]

Prima di continuare bisogna chiarire cosa sono i simboli terminali e non terminali:
- *Simboli terminali*: corrispondono a tutti quei simboli che compongono le stringhe del linguaggio.
- *Simboli non terminali*: al contrario dei terminali, sono tutti quei simboli che *non* fanno parte del linguaggio, ma aiutano alla loro generazione.

Sapendo ciò si può capire che l'interesezione tra $Sigma$ e $V$ corrisponde ad un insieme vuoto: $Sigma inter V = nothing$

Ci sono vari tipi di grammatiche in base alla strutture delle regole ma per ora si rimane nelle grammatiche _* context-free*_.

== Regole delle grammatiche

Le regole delle grammatiche assumono la seguente forma:
$
  A-> alpha, quad quad quad "con " A in V " e " alpha in (Sigma union V)^*
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


== Derivazioni

#definition()[
  La *derivazione* è il meccanismo generativo su cui si basano le grammatiche.\
  Data una stringa iniziale, consente di ottenere una nuova stringa sostituendo al simbolo non-terminale presente, la parte destra di una delle sue regole.
]

Questo passaggio si dice che la stringa $w$ produce direttamente la stringa $z$ oppure, se letta la contrario, la stringa $z$ deriva direttamente dalla stringa $w$.

#example()[
  Data una regola $A -> alpha$ e la stringa iniziale $beta A gamma$, si può dire che la stringa $beta A gamma$ produce direttamente la stringa $beta alpha gamma$:
  $
    beta A gamma ==> beta alpha gamma, quad quad quad "con "A in V, quad alpha, beta, gamma in (Sigma union V)^*
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
  Il *linguaggio generato da una grammatiga G*, L(G), corrisponde all'insieme formato da tutte le frasi di G:
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


== Correttezza e completezza di una grammatica

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
  Iniziamo con la completezza:\
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
  Ora passiamo alla correttezza:\
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

#example()[
  + Stringhe su ${a,b}$ che *iniziano con $a$* e hanno *lunghezza pari*\
    $S->"ab"|"aa"|S"aa"|S"ab"|S"ba"|"Sbb"$\
    aa, ab $in L$\
    se $u in L$, allora uaa, uab, uba, ubb $in L$
  + Ogni *$b$* è *preceduta da $a$*\
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

