#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw
#import "@preview/pinit:0.2.2": *

#pagebreak()
= Analisi Lessicale

== Espressioni regolari
#definition()[
  Le espressioni regolari sono una notazione sintetica per i linguaggi regolari ed operano sui simboli dell'alfabeto.
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

Siccome il codice sorgente di ogni programma risiede in memoria secondaria, e di conseguenza anche tutti i suoi simboli/token, risulta costoso accedervi per l'analisi. Per questo motivo si usano dei buffer nella RAM.

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
