#import "../../../dvd.typ": *

= Analisi Lessicale

=== Espressioni regolari
Notazione sintetica per i linguaggi regolari che operano sui singoli dell'alfabeto.
- Un imbolo $t$ rappresenta il linguaggio composto dal simbolo stesso: ${t}$;
- $epsilon$ rappresenta ${epsilon}$
- $emptyset$ rappresennta $emptyset$

se $x$ e $y$ sono due espressioni regolari e $L_x$ e $L_y$ i linguaggi corrispondenti, gli operatori applicabili in ordine di priorità decrescente sono:\
\
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
#pagebreak()
#example()[
  + $(a a)^*$: corrisponde a una stringa con $n space a$, dove $n>=0$ è pari\
  + $(a a)^+$: uguale alla precedente, però stavolta niente stringa vuota. $(n>0)$
  + $(a | b)^*$: una qualsiasi sequenza di $a$, $b$ o stringa vuota
  + $(b | a b)^*$: non ci sono $a$ consecutive
  + $((a | b)(a | b))^* => (a(a | b) | b(a | b))^* => (a a | a b | b a | b b)^*$: tutte stringhe di lunghezza pari
]

#line(length: 100%)

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

==== Espressioni regolari per gli identificatori di variabili

$Sigma={A,B,dots,Z,a,b,dots,z,,0,1,dots,9,\_}$\
$(A|B|dots|Z|a|b|dots|z|0|1|dots|9|\_)(A|B|dots|Z|a|b|dots|z|\_|0|1|dots|9)^*$

#definition()[
  Una *definizione regolare* è una sequenza finita di definizioni come segue:
  $
    d_1 -> r_1 \
    d_2 -> r_2 \
    dots -> dots \
    d_8 -> r_8 \
    d_9 -> r_9 \
    dots -> dots \
    d_n -> r_n \
  $
  dove $d_i$ è un simbolo nuovo rispetto a $overline(Z) (d_i in.not overline(Z))$ e ogni $r_i$ è un'espressione regolare su $overline(Z) union {d_1, dots, d_(i-1)}$ con $i = 1,dots,n$
]

Tornando all'esempio precedente, si può fare:
- letter $=> A|B|dots|Z|a|b|dots|z|\_$
- digit  $=> 0|1|dots|9$
- $id =>$ $"letter"("letter"|"digit")^*$

#example()[
  *Costanti numeriche senza segno*\
  $Sigma={0|1|dots|9|.|+|-|"E"}$\
  $"digit" -> 0|1|dots|9$\
  $"digits" -> cancel("digit digit"^*) space space "digit"^+$\
  $"optionalFraction" -> epsilon | ."digits"$\
  $"optionalExponent" -> epsilon | "E"(epsilon,+,-)"digits"$\
  $"number" -> "digits optionalFraction optionalExponent"$
]
===== Convenzioni su definizioni regolari

$
  [a b c] "sta per" a|b|c
$
Se i caratteri formano una sequenza logica:
$
  "allora: "[A-Z] "sta per" A|B|dots|Z\
  "es." [0-9] "sta per" [0 1 2 dots 9] "che sta per" 0|1|dots|9\
  "es." [a-z] "sta per" [a b c dots z] "che sta per" a|b|dots|z
$
Adesso possiamo allora ridefinire digit, digits e number
$
  "digit" => [0-9]\
  "digits" => "digit"^+\
  "number" => "digits"(."digits")?(E[+-]?"digits")?
$
#pagebreak()
== Definizione della grammatica

#definition()[
  G - grammatica\
  $(V,Sigma,P,S)$
  - $Sigma$, alfabeto dei simboli terminali
  - $V$, l'insieme dei simboli non terminali ($V inter Sigma=nothing$)
  - $P$,  l'insieme delle regole (produzioni)
  - $S in V$, simbolo iniziale
]

#set math.cases(reverse: true)
$
  display(
    cases(
      A->alpha_1,
      A->alpha_2,
      dots->dots,
      A->alpha_n
    )
  )
  A-->alpha_1|alpha_2|dots|alpha_n
$
#set math.cases(reverse: false)

=== Derivazione

#example()[
  $A-->alpha$

  $beta A gamma ==> beta alpha gamma$

  $A in V quad quad alpha, beta, gamma in (Sigma union V)^*$
]

$alpha => beta_1 =>beta_2=>dots=>beta_n=gamma$\
$alpha ==>^+gamma$\
$alpha ==>^*gamma$

#example()[
  - $underline("Base"): alpha=>^*alpha$
  - $underline("Induzione"): alpha =>^* beta quad "e" beta => gamma$
  allora $alpha =>^* gamma$
]
#line(length: 100%)
G grammatica\
$beta$ è una #underline("forma di frases") di G se e solo se:
$
  S =>^* beta quad quad quad quad (beta in (Sigma union V)^*)
$
W è una frase di G se:
$
  S =>^* W quad "e" quad W in Sigma^+\
  L("G")={W in Sigma^* bar S =>^+ W}
$
