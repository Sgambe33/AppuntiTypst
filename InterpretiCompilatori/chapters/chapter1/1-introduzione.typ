#import "../../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

= Introduzione

Tutti i software sono scritti con uno specifico linguaggio di programmazione. Prima di poter essere eseguiti, questi programmi devono essere trasformati/tradotti in un linguaggio che il computer può comprendere: il codice macchina.

Il software che si occupa di questa operazione si chiama *compilatore*. Oltre al compilatore esiste un altro software che esegue la stessa operazione ma in maniera diversa: piuttosto che tradurre immediatamente l'intero programma, esso interpreta e trasforma linea per linea del codice sorgente e si chiama *interprete*.

Per riassumere:
- Compilatori: *programma sorgente* $arrow.double$ *compilatore* $arrow.double$ *programma destinazione*.
  Successivamente al programma destinazione viene fornito un input su cui operare e restituisce un output.

- Interpreti: *prgogramma sorgente* + input $arrow.double$ *interprete* $arrow.double$ output

Sebbe i programmi compilati siano più veloci, gli interpreti sono più efficienti a individuare eventuali errori e a determinarne la causa/posizione nel sorgente.

#example("Java")[
  Il linguaggio Java utilizza una combinazione dei due meccanismi:
  - Il programma sorgente viene compilato in *bytecode*.
  - Il bytecode viene interpretato dalla *Java Virtual Machine*.

  #align(center, [Test.java $arrow.double$ Test.class])
]
== Compilatori

In realtà nella compilazione di un programma il compilatore è solo uno dei diversi software necessari ed utilizzati:

#diagram(
  spacing: 8pt,
  cell-size: (8mm, 10mm),
  edge-stroke: 1pt,
  edge-corner-radius: 5pt,
  mark-scale: 70%,
  node((0, 0), [sorgente], width: auto),
  node((1, 0), rect([Preprocessore], fill: teal.lighten(90%), stroke: teal), width: auto),
  node((2, 0), [sorgente\ modificato], width: auto),
  node((3, 0), rect([Compilatore], fill: teal.lighten(90%), stroke: teal), width: auto),
  node((4, 0), [programma\ assembly], width: auto),
  node((4, 1), rect([Assembler], fill: teal.lighten(90%), stroke: teal), width: auto),
  node((3, 1), [codice macchina \ rilocabile], width: auto),
  node((2, 1), rect([Linker \ Loader], fill: teal.lighten(90%), stroke: teal), width: auto),
  node((1, 1), [codice macchina \ assoluto], width: auto),
  edge((0, 0), (1, 0), "->"),
  edge((1, 0), (2, 0), "->"),
  edge((2, 0), (3, 0), "->"),
  edge((3, 0), (4, 0), "->"),
  edge((4, 0), (4, 1), "->"),
  edge((4, 1), (3, 1), "->"),
  edge((3, 1), (2, 1), "->"),
  edge((2, 1), (1, 1), "->"),
)

Il *compilatore* ha due funzioni:
- *Analisi*: suddivide il programma sorgente in elementi base e impone loro una struttura grammaticale. Successivamente utilizza questa struttura per generare una *rappresentazione intermedia* del programma sorgente. (*_Fase front end_*)

- *Sintesi*: data la rappresentazione intermedia, viene costruito il programma finale. (*_Fase back end_*)


La *fase di analisi* è a sua volta composta da 3 tipologie di analisi:
- *Analisi lessicale*: `printnf()`❌ - `printf()`✔
- *Analisi sintattica*: `x int = 18;`❌ - `int x = 18;`✔
- *Analisi semantica*: `int x = 18.2;`❌ - `int x = 18;`✔

=== Analisi lessicale

L'analisi lessicale (o scanning) ha lo scopo di controllare la correttezza lessicale (se le parole sono scritte correttamente) del codice sorgente. Richiede la conoscenza delle *espressioni regolari* del linguaggio utilizzato e restituisce una sequenza di *token* (corrispondenti ai _lessemi_ individuati).

I token sono classificati in 5 categorie:
- *identificatori*
- *costanti*
- *operatori*
- *parole chiave*
- *delimitatori*

Ogni token è rappresentato come `<nome, attributo>` e memorizzato nella *tabella dei simboli*.

=== Analisi sintattica

La sequenza di token viene ricevuta in input e viene restituito un albero sintattico. Questa fase richiede la conoscenza della *grammatica* del linguaggio.

=== Analisi semantica

Dato l'albero sintattico in input, si restituisce un altro albero sintattico a cui sono state aggiunte delle informazioni. Da qui viene poi generato un *codice sorgente intermedio*.

#example()[
  #align(center, image("images/2025-09-22-21-11-15.png"))
]

== Alfabeti e Stringhe

Un *alfabeto* è un insieme finito di *simboli* non vuoto. Ogni simbolo è un'entità indivisibile. Un alfabeto si indica con $Sigma$:
$
  Sigma = {a,b,c} space "oppure" space Sigma = {"if", "else", "then"}
$
Una *stringa* è invece una sequenza di simboli appartenenti ad un alfabeto $Sigma$:
$
  w = s_1, s_2, ..., s_n space "con" space s_i in Sigma, n<infinity
$
Una stringa vuota (non contiene simboli) si indica con $epsilon$?. Il numero dei simboli che compongono una stringa rappresenta la *lunghezza* e si indica con $abs(w)$, di conseguenza vale $abs(epsilon)=0$.

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
  Due stringhe sono uguali ($u$ = $v$) se:
  $n = k$ e $x_i = y_i$ per $i=1,2,3,...,n$.
]

#definition("Sottostringa")[
  Una stringa $v$ è detta *sottostringa* di $u$ se:
  $u= u v z$, dove $w$ e $z$ sono stringhe, eventualmente vuote.
]

#definition("Suffisso e Prefisso")[
  $v$ è prefisso di $u$ se $u = v z$

  $v$ è suffisso di $u$ se $u=w v$
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
La concatenazione di $u$ e $v$ restituisce una nuova stringa $"uv"$ definita come:
$
  "uv" = x_1 x_2 ... x_n y_1 y_2 ... y_k
$

- Non è commutativa
- E' associativa

Ovviamente la concatenazione può essere applicata a più di due stringhe.

==== Potenza

La potenza $u^n$ con $n gt 0$ indica la concatenazione della stringa con se stessa $n$ volte.
$
  u^0 = epsilon space space space abs(u^n) = n times abs(u)
$

==== Reverse

Semplicemente consiste nell'invertire l'ordine dei simboli nella stringa:
$
  u^R = x_n ... x_2 x_1
$

== Linguaggi

Un linguaggio $L$ è un insieme di stringhe su $Sigma$:
$
  L subset.eq Sigma^*
$
//TODO: Lunghezza di un linguaggio.... 

=== Operazioni sui linguaggi

//TODO

- Concatenazione
- Unione
- Intersezione
- Potenza

=== "chiusura di un linguaggio"

$L^*$ è la chiusura di un linguaggio L. E' definita come l'unione di tutte le potenze n-esime di L con n gt.eq 0 

$
  L^* = union_(i gt.eq 0) L^i
$
Non c'è stringa vuota


L^+ è la chiusura positiva
$
  L^+ = union_(i gt 0) L^i
$
Potrebbe esserci la stringa vuota

L^+ = LL^+ = L^+L

$Sigma^*$ =$ L(Sigma*)$ (linguaggio universale)

Sigma^+ = L(SImga+) (linguaggio universale positivo)

Linguaggio complementare:
L con barra sopra = $Sigma^*$ - L

I linguaggi possono essere definiti ricorsivamente.
- passo base:date k stringhe in L
- passo ricorsivo: se j stringhe stanno in L, allora f(v1,v2, ..., vj) in L

(chiusura?)
Una stringa w sta in L solo se può essere ottenuta dagli elementi di base con un numero finito di applicazioni del passo ricorsivo.

#example()[
  Stringhe su {a,b} che iniziano con a e hanno lunghezza pari.
  $L= w in {a,b}^* bar w = a u, abs(w) = 2n "con" n > 0$

  - aa, ab $in$ L
  - se u $in$ L allora uaa, uab, uba, ubb stanno $in$ L
]

#example()[
  Stringhe su {a,b} in cui ogni occorenza di b è precedente di a.\
  - $underline(text("Base")): epsilon in L$
  - $underline(text("Passo ricorsivo")): text("se") u in L, quad u a, u a b$
  - $underline(text("Passo ricorsivo")): text("se") u in L, quad a u, a b u $
]

#example()[
  Espressioni con $n$, +, -, \*, ), (, /
  - $underline(text("Base")): n in L$
  - $underline(text("Passo ricorsivo")): $ se $u,v in L ==> (u),u+v,u-v,u*v,u/v in L quad quad quad $5?
]

#example()[
  $L={a^n b^(2n) bar n > 0}$
  - $underline(text("Base")): a b b in L$ 
  - $underline(text("Passo ricorsivo")):$ se $u in L ==> a u b b in L$
]

#example()[
  $L={a^n b^n bar n>=0}$
  - $underline(text("Base")): epsilon in L$
  - $underline(text("Passo ricorsivo")):$ se $ u in L ==> a u b in L$
]

#example()[
  Stringhe su {a,b} che contengono lo stesso numero di $a$ e di $b$.\
  $L={w in {a,b}^* bar |w|_a = |w|_b}$
  - $underline(text("Base")): epsilon in L$ 
  - $underline(text("Passo ricorsivo")):$ se $u, v in L ==> a u b v, b u a v in L$
  Passi ricorsivi errati:
  - $underline(text("Passo ricorsivo")):$ se $u in L ==> u a b in L$
  - $underline(text("Passo ricorsivo")):$ se $u in L ==> b u a, a u b in L$
]

#example()[
  L={a^i b^j bar 0 < i < j}
  - $underline(text("Base")): a b b in L$
  - $underline(text("Passo ricorsivo")):$ se $u in L ==> u b, a u b in L$
  Supponiamo di voler ottenrere $a^5 b^8$\
  Diventa: abb $=>$ aabbb $=>$ aaabbbb $=>$ aaaabbbbb $=>$ aaaaabbbbbb\
  aaaaabbbbbbbb

  $L'={a^i b^j bar i > j > 0}$
  - $underline(text("Base")): a a b in L'$
  - $underline(text("Passo ricorsivo")):$ se $u in L' ==> a u, a u b in L'$


  $L''={a^i b^j bar i != j; quad i, j > 0}$\
  $L'' = L union L'$
  - $underline(text("Base")): a a b, a b b in L$
  NON ESISTE MA vv
  - #underline("Passo ricorsivo"): se $u in L ==> a u b in L$
]

=== Linguaggi (insiemi) regolari

I lingaggi regolari su un alfabeto $Sigma$ sono definiti ricorsivamente a partire dagli elementi di base usando le operazioni di unione, concatenazione e chiusura.

- #underline("Base"): $cases(emptyset "è un insieme regolare",
                            {epsilon} "è un insieme regolare",
                            forall t in Sigma\,space {t} "è un insieme regolare")$
- #underline("Passo ricorsivo"): se $x$ e $y$ sono insiemi regolari, allora $x union y, x y, x^*, x^+$ sono regolari.
- #underline("Chiusura"): un insieme è regolare se può essere ottenuto dagli elementi di base con appplicazioni del passo ricorsivo.

#example()[
  $L$ su ${a,b}$ in cui ogni b è preceduta da a.\
  + ${a}$ è regolare
  + ${b}$ è regolare
  + ${a}^+$ è regolare
  + ${a}^*$ è regolare
  + ${a}^+{b}$ è regolare
  + ${a}^+{b}{a}^*$ è regolare
  + $({a}^+{b}{a}^*)^*$ è regolare
]

=== Espressioni regolari
Notazione sintetica per i linguaggi regolari che operano sui singoli dell'alfabeto.
- Un imbolo $t$ rappresenta il linguaggio composto dal simbolo stesso: ${t}$;
- $epsilon$ rappresenta ${epsilon}$
- $emptyset$ rappresennta $emptyset$

se $x$ e $y$ sono due espressioni regolari e $L_x$ e $L_y$ i linguaggi corrispondenti, gli operatori applicabili in ordine di priorità decrescente sono:\
\
#set math.cases(reverse: true)
$display(cases("1. chiusura di " x\, x^*\, "indica" (L_x)^*,
       "2. chiusura di " x\, x^+\, "indica" (L_x)^+))
x^+=x x^* =x^* x$

#set math.cases(reverse: false)

3. concatenazione di x e y, $x y$, indica $L_x L_y$
+ unione di x e y, $x + y$ oppure $x | y$, indica $L_x union L_y$
+ opzionalità di x, $[x]$ oppure $x?$, indica $L_x union {epsilon} ==> x? = x | epsilon$

==== Proprietà

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
\
#example()[
  + $(a a)^*$: corrisponde a una stringa con $n space a$, dove $n>=0$ è pari\
  + $(a a)^+$: uguale alla precedente, però stavolta niente stringa vuota. $(n>0)$
  + $(a | b)^*$: una qualsiasi sequenza di $a$, $b$ o stringa vuota
  + $(b | a b)^*$: non ci sono $a$ consecutive
  + $((a | b)(a | b))^* => (a(a | b) | b(a | b))^* => (a a | a b | b a | b b)^*$: tutte stringhe di lunghezza pari 
]