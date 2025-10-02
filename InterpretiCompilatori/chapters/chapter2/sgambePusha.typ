#import "../../../dvd.typ": *

// Da spostare dove c'è la correttezza, dentro l'esempio già presente (aggiungere un #pagebreak(), se ancora necessario)
#example()[
  Stringhe su {a,b} di lunghezze dispari in cui il primo carattere e quello centrale sono uguale
  $
    &L = {w in {"a,b"}^* |w = "axay" &&" oppure" w="bxby con" |y|=|x|+1}\
    &S->"aA | bB " quad quad "oppure" && S-> "aAX" | "bBX"\
    &A-> "XAX" | "aX" && A-> "XAX" | "a"\
    &A-> "XBX" | "bX" && B-> "XBX" | "b"\
    &X-> "a | b"      && X-> "a | b"
  $
]
#pagebreak()
= Grammatiche regolari

La differenza con le grammatiche context-free è il come sono definite le produzioni.\
Qui possono avere la seguente forma:
$
  & X --> a Y &&(X->Y a)\
  & X --> a\
  & X --> epsilon\
  & "con "X,Y in V " e " a in Sigma
$

Le forme di frase saranno del tipo:
$
  S=>^*w X quad "con" quad w in Sigma^*, space x in V
$

#example()[
  + Stringhe su {a,b} di lunghezza pari
  $
    & S=>^* w X\
    & |w|= "pari": S quad quad quad && S->epsilon | a D | b D\
    & |w|= "dispari": D &&D->a S | b S
  $

  2. Stringhe su {a,b} che contengono tre *$a$* consecutive:
    $
      &S=>^*w X\
      &S->b S | a A\
      &A -> a B | b S\
      &B -> a C | b S\
      &C -> epsilon | a C | b C
    $

    - $w$ non contiene "aaa" e termina con b: $S$\
    - $w$ non contiene "aaa" e termina con ba: $A$\
    - $w$ non contiene "aaa" e termina con baa: $B$\
    - $w$ contiene "aaa": $C$
]

= Gerarchie di Chomsky (classificazione delle grammatiche)

0. *Grammatiche senza restrizioni (a struttura di frase)*
+  *Grammatiche contenstuali*
+  *Grammatiche non contestuali*
+  *Grammatiche regolari*

== Grammatiche senza restrizioni (a struttura di frase)

In questo tipo di grammatica, le produzioni hanno la seguente forma:
$
  alpha -> beta, quad alpha in (V union Sigma)^+ space " e " space beta in (V union Sigma)^*
$
Ovvero $alpha$ non può essere una stringa nulla. Ha senso chiedere che $alpha$ abbia almeno un non terminale:
$
  &alpha in (Sigma union V)^+ ?V (union?, "concatenato????")? (Sigma union V)^*\
  &alpha, beta, gamma, S in (Sigma union V)^*, quad quad alpha in.not Sigma\
  &gamma alpha S --> gamma beta S
$

== Grammatiche contestuali
+ $alpha -> beta, quad alpha, beta in (Sigma union V)^+ space space (alpha in (Sigma union V)^* #text(stroke: .75pt)[?V?] (Sigma union V)^*) quad quad "e" |alpha|<=|beta|$
+ $alpha_1A alpha_2 --> alpha_1 beta alpha_2, quad quad "con " A in V, alpha_1,alpha_2,beta in (Sigma union V)^* space " e " space beta eq.not epsilon$