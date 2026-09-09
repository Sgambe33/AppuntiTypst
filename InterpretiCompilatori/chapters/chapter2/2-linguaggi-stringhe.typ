#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw
#import "@preview/pinit:0.2.2": *

#pagebreak()
= Sulle stringhe e sui linguaggi

== Alfabeti e Stringhe

Un *alfabeto* è un insieme finito di *simboli* non vuoto. Ogni simbolo è un'entità indivisibile. Un alfabeto si indica con $Sigma$:
$
  Sigma = {a,b,c} space "oppure" space Sigma = {"if", "else", "then"}
$
Una *stringa* di un dato alfabeto è definita come una sequenza di simboli presi da quell'alfabeto:
$
  w = s_1 s_2 ... s_n space "con" space s_i in Sigma, n<infinity
$
Una stringa vuota, che non contiene simboli, si indica con $epsilon$. Il numero dei simboli che compongono una stringa rappresenta la sua *lunghezza* e si indica con $abs(w)$, di conseguenza vale che $abs(epsilon)=0$.

L'insieme di tutte le stringhe di lunghezza $k$ con $k gt.eq 0$ si indica con $Sigma^k$. $Sigma^0 = {epsilon}$.

L'insieme di tutte le stringhe di qualsiasi lunghezza è $Sigma^*$ che per definizione può essere riscritto come:
$
  Sigma^* = Sigma^0 union Sigma^1 union Sigma^2 union ...
$
Si può anche indicare l'insieme delle stringhe di lunghezza almeno 1:
$
  Sigma^+ = Sigma^1 union Sigma^2 union ...
$

#definition()[
  Due stringhe sono *uguali* ($u$ = $v$) se:
  $abs(u) = abs(v)$ e $x_i = y_i$ per $i=1,2,3,...,n$.
]

#definition("Sottostringa")[
  Una stringa $k$ è detta *sottostringa* di $u$ se:
  $u= w k z$, dove $w$ e $z$ sono stringhe, eventualmente vuote.
]

#definition("Suffisso e Prefisso")[
  - $k$ è *prefisso* di $u$ se $u = k z$
  - $k$ è *suffisso* di $u$ se $u=w k$
]


=== Operazioni su stringhe

Date due stringhe $u$ e $v$ definite come:
$
  u = x_1 x_2 ... x_n space space v = y_1 y_2 ... y_k
$
Sulle stringhe si possono effettuare alcune operazioni come:
- Concatenazione
- Potenza
- Reverse

==== Concatenazione
La concatenazione di $u$ e $v$ restituisce una nuova stringa #mtext("uv") definita come:
$
  mtext("uv") = x_1 x_2 ... x_n y_1 y_2 ... y_k
$
La stringa vuota ($epsilon$) è l'elemento neutro rispetto all'operazione di concatenamento, cioè
$
  epsilon s = s epsilon = s
$
per qualsiasi stringa $s$. Gode solo della proprietà associativa. Ovviamente la concatenazione può essere applicata a più di due stringhe.

==== Potenza

La potenza $u^n$ con $n gt 0$ indica la concatenazione della stringa con se stessa $n$ volte.
$
  u^0 = epsilon space space space abs(u^n) = n times abs(u)
$

==== Reverse

L'operazione di _reverse_ consiste nell'invertire l'ordine dei simboli nella stringa:
$
  u = x_1 x_2 dots x_n => u^R = x_n dots x_2 x_1
$

== Linguaggi

Un linguaggio $L$ è un insieme numerabile di stringhe di un dato alfabeto $Sigma$:
$
  L subset.eq Sigma^*
$

Essendo i linguaggi degli insiemi a tutti gli effetti, è possibile applicare le classiche operazioni insiemistiche su di essi:
- Concatenazione
- Unione
- Intersezione
- Differenza

=== Concatenazione

Dati due linguaggi $L_x$ e $L_y$, la loro concatenazione $L_x L_y$ è definita come:
$
  L_x L_y = {x y bar x in L_x and y in L_y }
$

=== Unione

Dati due linguaggi $L_x$ e $L_y$, la loro unione $L_x union L_y$ è definita come l'insieme delle stringhe che appartengono ad almeno uno dei due:
$
  L_x union L_y = {z in Sigma^* bar z in L_x or z in L_y }
$

=== Intersezione

Dati due linguaggi $L_x$ e $L_y$, la loro intersezione $L_x inter L_y$ è definita come:
$
  L_x inter L_y = {z in Sigma^* bar z in L_x and z in L_y }
$

=== Differenza

Dati due linguaggi $L_x$ e $L_y$, la loro differenza $L_x - L_y$ è definita come l'insieme delle stringhe che appartengono al primo ma non al secondo:
$
  L_x - L_y = {z in Sigma^* bar z in L_x and z in.not L_y }
$

=== Chiusura di un linguaggio
==== Chiusura di Kleene ($L^*$)
È l'insieme delle stringhe ottenute concatenando $L$ con se stesso zero o più volte. Include sempre la stringa vuota $epsilon$ (poiché $L^0 = \{epsilon\}$).
$
  L^* = union.big_(i gt.eq 0) L^i
$

==== Chiusura Positiva ($L^+$)
Coincide con la chiusura di Kleene a meno del termine $L^0$. Questo significa che la stringa vuota $epsilon$ non appartiene a $L^+$, a meno che essa non appartenga già a $L$ stesso.
$
  L^+ = union.big_(i gt 0) L^i
$

#observation()[
  - $L^+ = L L^* = L^* L$ (stringa vuota è elemento neutro rispetto alla concatenazione)
  - $L^+ = L union L L^+$
]

Si definiscono inoltre:
- $Sigma^*$ (*linguaggio universale*): l'insieme di tutte le possibili stringhe sull'alfabeto $Sigma$;
- $Sigma^+$ (*linguaggio universale positivo*): l'insieme di tutte le stringhe di $Sigma^*$ ad eccezione della stringa vuota $epsilon$ (quindi $Sigma^+ = Sigma^* - {epsilon}$);
- $overline(L) = Sigma^* - L$ (*linguaggio complementare*): l'insieme delle stringhe di $Sigma^*$ che non appartengono a $L$.

=== Definizione ricorsiva di linguaggio

I linguaggi formali possono essere definiti in modo ricorsivo tramite tre componenti essenziali:
- #underline("Base"): fornisce un insieme finito di stringhe iniziali che appartengono sicuramente a $L$.
- #underline("Passo ricorsivo"): regole di produzione che indicano come generare nuove stringhe partendo da stringhe già note in $L$ (es: se $v_1, dots, v_j "in" L$, allora $f(v_1, dots, v_j) "in" L$)
- #underline("Chiusura"): una stringa $w$ appartiene a $L$ solo se può essere ottenuta dagli elementi di base con un numero finito di applicazioni del passo ricorsivo.


#example(multiple: true)[
  + Stringhe su {a,b} che iniziano con a e hanno lunghezza pari.
    $
      L= {w in {a,b}^* bar w = a u, abs(w) = 2n "con" n > 0}
    $

    - #underline("Base"): aa, ab $in L$
    - #underline("Passo ricorsivo"): se u $in L ==> mtext("uaa, uab, uba, ubb") in L$

  + Stringhe su {a,b} in cui ogni occorrenza di b è preceduta da a.
    - $underline(text("Base")): epsilon in L$
    - $underline(text("Passo ricorsivo")): text("se") u in L ==> u a, u a b in L$
    - $underline(text("Passo ricorsivo")): text("se") u in L ==> a u, a b u in L$

  + Espressioni con $n$, +, -, \*, ), (, /
    - $underline(text("Base")): n in L$
    - $underline(text("Passo ricorsivo")):$ se $u,v in L ==> (u),u+v,u-v,u*v,u\/v in L$

  + Linguaggio $L={a^n b^(2n) bar n > 0}$
    - $underline(text("Base")): a b b in L$
    - $underline(text("Passo ricorsivo")):$ se $u in L ==> a u b b in L$

  + Linguaggio $L={a^n b^n bar n>=0}$
    - $underline(text("Base")): epsilon in L$
    - $underline(text("Passo ricorsivo")):$ se $u in L ==> a u b in L$

  + Stringhe su {a,b} che contengono lo stesso numero di $a$ e di $b$.\
    $
      L={w in {a,b}^* bar |w|_a = |w|_b}
    $
    - $underline(text("Base")): epsilon in L$
    - $underline(text("Passo ricorsivo")):$ se $u, v in L ==> a u b v, b u a v in L$
    Passi ricorsivi errati:
    - $underline(text("Passo ricorsivo")):$ se $u in L ==> u a b in L$ (genera solo stringhe nella forma #mtext("ababab..."))
    - $underline(text("Passo ricorsivo")):$ se $u in L ==> b u a, a u b in L$ (genera solo stringhe con lettere diverse agli estremi)

  + Linguaggio $L={a^i b^j bar 0 < i < j}$
    - $underline(text("Base")): a b b in L$
    - $underline(text("Passo ricorsivo")):$ se $u in L ==> u b, a u b in L$
    Supponiamo di voler ottenere $a^5 b^8$. Diventa: abb $=>$ aabbb $=>$ aaabbbb $=>$ aaaabbbbb $=>$ aaaaabbbbbb $=>$ aaaaabbbbbbbb

  + Linguaggio $L'={a^i b^j bar i > j > 0}$
    - $underline(text("Base")): a a b in L'$
    - $underline(text("Passo ricorsivo")):$ se $u in L' ==> a u, a u b in L'$

  + Linguaggio $L''={a^i b^j bar i != j; quad i, j > 0}$\
    $L'' = L union L'$
    - $underline(text("Base")): a a b, a b b in L$
    - #underline("Passo ricorsivo"): se $u in L ==> a u b in L$ attenzione, questo genera un linguaggio incompleto!
]

=== Linguaggi regolari

I linguaggi regolari su un alfabeto $Sigma$ sono definiti ricorsivamente a partire dagli elementi di base usando le operazioni di unione, concatenazione e chiusura.

- #underline("Base"): i seguenti insiemi elementari sono regolari
  - L'insieme vuoto $emptyset$
  - L'insieme contenente solo la stringa vuota ${epsilon}$
  - L'insieme contenente un singolo simbolo dell'alfabeto ${t}, forall t in Sigma$
- #underline("Passo ricorsivo"): se $x$ e $y$ sono insiemi regolari, allora anche $x union y, x y, x^*, x^+$ sono regolari.
- #underline("Chiusura"): un insieme è regolare se e solo se può essere ottenuto dagli elementi di base tramite un numero finito di applicazioni del passo ricorsivo.

#example()[
  $L$ su $Sigma = {a,b}$ in cui ogni occorrenza di b è preceduta da a.
  + ${a}$ è regolare
  + ${b}$ è regolare
  + ${a}{b}$ è regolare
  + ${a} union {a}{b}$ è regolare
  + $({a} union {a}{b})^*$ è regolare
]

== Espressioni regolari
#definition()[
  Le espressioni regolari sono una notazione sintetica per i linguaggi regolari ed operano sui simboli dell'alfabeto.
  - Un simbolo $t$ rappresenta il linguaggio composto dal simbolo stesso: ${t}$;
  - $epsilon$ rappresenta ${epsilon}$;
  - $emptyset$ rappresenta $emptyset$;
]

Se $x$ e $y$ sono due espressioni regolari e $L_x$ e $L_y$ i linguaggi regolari corrispondenti, gli operatori applicabili in ordine di priorità decrescente sono:

#set math.cases(reverse: true)
$display(
  cases(
    "1. chiusura di " x\, x^*\, "indica" (L_x)^*,
    "2. chiusura di " x\, x^+\, "indica" (L_x)^+
  )
)
x^+=x x^* =x^* x$
#set math.cases(reverse: false)

3. concatenazione di $x$ e $y$, $x y$, indica $L_x L_y$
4. unione di $x$ e $y$, $x + y$ oppure $x | y$, indica $L_x union L_y$
5. opzionalità di $x$, $[x]$ oppure $x?$, indica $L_x union {epsilon} ==> x? = x | epsilon$

=== Proprietà

- *Unione*:
  + Commutativa: $x | y = y | x$;
  + Associativa: $x | (y | z) = (x | y) | z$.
- *Concatenazione*:
  + Distributiva rispetto all'unione: $x(y | z) = x y | x z$;
  + Associativa: $x (y z) = (x y) z$;
  + Elemento neutro: $epsilon x = x epsilon = x$;
- *Chiusura*:
  + $epsilon in x^* quad x^*=(x | epsilon)^*$
  + Idempotenza: $(x^*)^* = x^*$

#example(multiple: true)[
  + $(a a)^*$: corrisponde a una stringa con $n space a$, dove $n>=0$ è pari\
  + $(a a)^+$: uguale alla precedente, però stavolta niente stringa vuota. $(n>0)$
  + $(a | b)^*$: una qualsiasi sequenza di $a$, $b$ o stringa vuota
  + $(b | a b)^* (a | epsilon)$: non ci sono $a$ consecutive
  + $((a | b)(a | b))^* => (a a | a b | b a | b b)^*$: tutte stringhe di lunghezza pari
]

#example(multiple: true)[
  + ${a, b}$, contengono $a b a ==> (a bar b)^* a b a (a bar b)^*$
  + ${a, b}$, non contengono $a b a ==> (b bar a^+ b b)^*(epsilon bar a^+ | a^+ b)$
  + ${a, b}$, ogni $a$ è preceduta o seguita da $b$
    $
      (b bar a b | b a)^* => ((epsilon bar a)b bar (epsilon | a) b a)^* ==> ((epsilon bar a) (b bar b a))^*
    $
  + ${a, b}$, in cui il terzultimo carattere è $b ==> (a bar b)^*b bar (a bar b)(a bar b)$
  + ${a, b}$, con numero pari di $a$ e un numero pari di $b$\
  $
    (a a | b b | (a b | b a) (a a | b b)^* (a b | b a))^*
  $
  6. ${a, b}$, con numero pari di $a$ o un numero dispari di $b$
  $
    b^*(a b^* a b^*)^* | a^* b a^* (b a^* b a^*)^*
  $
  7. ${a, b}$, stringhe di lunghezza dispari che contengono esattamente 2 $b$
  $
    underbrace(a(a a)^* b a(a a)^* b a(a a)^*, text("3 slot dispari")) |
    underbrace(a(a a)^* b (a a)^* b (a a)^*, text("1° dispari")) |
    underbrace((a a)^* b a(a a)^* b (a a)^*, text("2° dispari")) |
    underbrace((a a)^* b (a a)^* b a(a a)^*, text("3° dispari"))
  $
  8. ${a, b}$, stringhe dove $a a$ occorre una sola volta
  $
    (b | a b)^* a a (b | b a)^*
  $
]

=== Definizioni regolari

#definition()[
  Una *definizione regolare* è una sequenza finita di definizioni della forma:
  $
    d_1 & -> r_1 \
    d_2 & -> r_2 \
        & space dots.v \
    d_n & -> r_n
  $
  dove ogni $d_i$ è un simbolo nuovo rispetto all'alfabeto di base $Sigma$ ($d_i in.not Sigma$) e ogni $r_i$ è un'espressione regolare sull'alfabeto $Sigma union {d_1, dots, d_(i-1)}$ per $i = 1,dots,n$.
]

Sia $Sigma={A,B,dots,Z,a,b,dots,z,0,1,dots,9,\_}$ l'alfabeto di tutti i caratteri che possono essere contenuti in un identificatore di variabile. L'espressione regolare estesa per verificare la correttezza di un identificatore è la seguente.
$
  (A|B|dots|Z|a|b|dots|z|\_)(A|B|dots|Z|a|b|dots|z|\_|0|1|dots|9)^*
$

Usando le definizioni regolari, la scrittura si ottimizza enormemente diventando modulare:
- $mtext("letter") -> A|B|dots|Z|a|b|dots|z|\_$
- $mtext("digit") -> 0|1|dots|9$
- $mtext("id") -> mtext("letter") (mtext("letter") | mtext("digit"))^*$

#example()[
  Per validare le *costanti numeriche senza segno* (es. interi, decimali e notazione scientifica) possiamo usare:\
  $
    Sigma = {0, 1, dots, 9, ., +, -, E}
  $
  $
               mtext("digit") & -> 0|1|dots|9 \
              mtext("digits") & -> mtext("digit")^+ \
    mtext("optionalFraction") & -> epsilon | . mtext("digits") \
    mtext("optionalExponent") & -> epsilon | E (epsilon | + | -) mtext("digits") \
              mtext("number") & -> mtext("digits") space mtext("optionalFraction") space mtext("optionalExponent")
  $
]

=== Estensioni delle espressioni regolari

Dopo l'introduzione delle espressioni regolari di base, sono state proposte delle estensioni utili a migliorarne la leggibilità e la capacità espressiva.
Alcune delle estensioni più comuni introdotte da programmi UNIX sono:

+ *Una o più occorrenze*: l'operatore unario postfisso '$+$' indica la chiusura positiva di un'espressione regolare e del linguaggio ad essa associato ($r$: espressione regolare, $r^+$ denota $L(r)^+$). Si può notare come sia legata alla chiusura di Kleene dalle seguenti leggi algebriche:
  - $r^* = r^+ | epsilon$
  - $r^+ = r r^* = r^* r$
  L'operatore '$+$' ha la stessa precedenza e associatività dell'operatore '$*$';

  #observation()[
    L'identità $r^+ = r r^* = r^* r$ è una proprietà fondamentale delle espressioni regolari che può essere dimostrata formalmente.

    #proof()[
      Ricordando le definizioni di chiusura di Kleene e chiusura positiva:
      $
        r^* & = {epsilon} union r union r r union r r r union ... = union.big_(n >= 0) r^n \
        r^+ & = r union r r union r r r union ... = union.big_(n > 0) r^n
      $
      Applicando le proprietà della concatenazione sull'unione infinita:
      1. $r r^* = r (union.big_(n >= 0) r^n) = union.big_(n >= 0) (r dot r^n) = union.big_(n >= 0) r^(n+1) = union.big_(m > 0) r^m = r^+$

      2. $r^* r = (union.big_(n >= 0) r^n) r = union.big_(n >= 0) (r^n dot r) = union.big_(n >= 0) r^(n+1) = union.big_(m > 0) r^m = r^+$
    ]
  ]


+ *Zero o una occorrenza*: l'operatore unario postfisso '$?$' indica l'opzionale presenza dell'operando a cui viene applicato. Quindi $r?$ equivale a $r | epsilon$ (in termini di linguaggi: $L(r?) = L(r) union {epsilon}$). Come il precedente, ha la stessa precedenza e associatività dell'operatore '$*$'.

+ *Classi di caratteri*: un'espressione regolare formata da un'unione di singoli caratteri come $a_1 | a_2 | ... | a_n$, in cui i simboli $a_i$ appartengono all'alfabeto $Sigma$, può essere sostituita dalla forma compatta $[a_1 a_2 ... a_n]$. Inoltre, quando i simboli formano una sequenza logica (per esempio lettere maiuscole, lettere minuscole o cifre in base alla codifica ASCII), si può ulteriormente sintetizzare l'espressione indicando il range: $[a_1 - a_n]$.

#example()[
  $
    [a b c] "sta per" a|b|c
  $
  Se i caratteri formano una sequenza logica:
  $
    "es. " [A-Z] & "sta per" [A B dots Z] && "che equivale a" A|B|dots|Z \
    "es. " [0-9] & "sta per" [0 1 2 dots 9] && "che equivale a" 0|1|dots|9 \
    "es. " [a-z] & "sta per" [a b c dots z] && "che equivale a" a|b|dots|z
  $
]

Sfruttando queste estensioni, possiamo ridefinire le definizioni regolari per validare i numeri in notazione scientifica in modo molto compatto:
$
   "digit" & -> [0-9] \
  "digits" & -> "digit"^+ \
  "number" & -> "digits" ("." "digits")? ("E" [+-]? "digits")?
$

== Buffering dell'ingresso

Siccome il codice sorgente di ogni programma risiede in memoria secondaria, e di conseguenza anche tutti i suoi simboli/token, risulta costoso accedervi per l'analisi. Per questo motivo si usano dei buffer nella RAM.

Uno dei sistemi più utilizzati si basa su due buffer di dimensione $N$, dove $N$ di solito ha la stessa dimensione di un blocco del disco, per esempio 4096 byte. Con una singola operazione di lettura è possibile leggere un intero blocco di $N$ caratteri (molto meglio di $N$ letture di singoli caratteri). Quando meno di $N$ caratteri rimangono nel file, il carattere *eof* segnala la fine del file.

Per la gestione del buffer si usano due puntatori:
- _*lexemeBegin*_: indica l'indirizzo del lessema corrente, la cui lunghezza deve essere determinata.
- _*forward*_: si sposta in avanti finché non si riconosce un lessema corrispondente a un pattern.

Una volta individuato il lessema, si sposta il puntatore _forward_ sul carattere immediatamente alla destra del lessema stesso. Quindi, dopo che tale lessema è stato memorizzato come attributo di token, il puntatore _lexemeBegin_ viene spostato immediatamente dopo il lessema appena trovato.

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
