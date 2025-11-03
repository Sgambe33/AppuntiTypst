#import "../../../dvd.typ": *

#pagebreak()
= Sistemi lineari e non lineari

In questo capitolo tratteremo la risoluzione di sistemi di equzioni lineari del tipo:
$
  (1) space space space cases(
    a_(11)x_1+a_(12)x_2+...+a_(1n)x_n=b_1,
    a_(21)x_1+a_(22)x_2+...+a_(2n)x_n=b_2,
    quad quad quad quad quad quad quad dots.v,
    a_(m 1)x_1+a_(m 2)x_2+...+a_(m n)x_n=b_m,

  )
$
in cui i coefficienti $a_(i j)$, per $i=1,...,m$ e $j=1,...,n$, sono assegnati, come lo sono anche i termini noti $b_1,...,b_m$. Le incognite da determinare sono $x_1,...,x_n$. Il sistema di equazioni (1), può essere riscritto in forma *vettoriale* introducendo la *matrice dei coefficienti*, *il vettore dei termini noti* e *il vettore delle incognite*, rispettivamente:
$
  A = mat(
    a_(11), a_(12), ..., a_(1n);a_(21), a_(22), ..., a_(2n);dots.v, dots.v, dots.v, dots.v;a_(m 1), a_(m 2), ..., a_(m n);
  )
  quad quad
  underline(b)=mat(b_1;b_2;dots.v;b_m) in RR^m
  quad quad
  underline(x)=mat(x_1;x_2;dots.v;x_n) in RR^m
$
come segue:
$
  A underline(x) = underline(b) space space space (2)
$

Nella nostra trattazione, assumeremo che $m gt.eq n$, ovvero che il numero delle equazioni non sia minore del numero delle incognite. Pertanto il numero di colonne della matrice $A$ è minore uguale del numero di righe.



memo -> $(a_(i 1),...,a_(i n)) in RR^(1 times n)$, è la i-esima riga di A;
(lo stesso per la colonna j-esima in RR^m)
$a_(i j)$ è l'elemento che si trova nell'intersezione della riga i-esima con la colonna j-esima.

Assumeremo, inoltre, che la matrice $A$ abbia rango massimo ovvero uguale a $n$. Questo significa che le colonne di $A$ sono vettori linearmente indipendenti tra loro.
Distingueremo due casi significativi che sono il caso in cui:
+ $m=n <=> A$ è una matrice quadrata
+ $m>n <=> A$ è rango massimo.

== Il caso quadrato
Se $A in RR^(n times m)$, e rank(A)=n, segue he $A$ è una matrice *non singolare*. Questo significa che $exists A^(-1)$, la matrice inversa di $A$, tale che 
$
  A^(-1) dot A = A dot A^(-1) = I = mat(1, , , ;, dots.down, , , ;, , dots.down, , ;, , , 1;) in RR^(n times n)
$
con $I$ la matrice identità.

#observation()[
  In questo caso $x,b in RR^n$ e, evidentemente $I dot underline(x) = underline(x)$.
]
Pertanto, se dobbiamo risolvere il problema 
$
  A underline(x) = underline(b)
$
allora, moltiplicando membro a membro per $A^(-1)$, otteniamo che $exists! underline(x) = A^(-1) dot underline(b)$ soluzione del problema. Tuttavia questa espressione della soluzione non è generalmente efficiente dal punto di vista computazionale. Pertanto sarà utilizzata solo in casi molto particolari.
Ricordiamo che
$
  A "non singolare" <=> "det"(A)eq.not 0
$
Cosa che assumeremo nel seguito.
Cominciamo con l'esame di casi di sitemi lineari "semplici". Questi casi sono quelli in cui la matrice $A$ è:
- diagonale
- triangolare
- ortogonale
La loro elencazione è fatta per complessità computazionale crescente. Quest'ultima è misurata in termini di occupazione di memoria e numero di operazioni algebriche richieste per la risoluzione del sistema.

=== $A$ diagonale
In questo caso $a_(i j ) = 0$ con $i eq.not j$
$
  A = mat(
    a_(11), a_(12), ..., a_(1n);a_(21), a_(22), ..., a_(2n);dots.v, dots.v, dots.down, dots.v;a_(m 1), a_(m 2), ..., a_(m n);
  )
$
#observation()[
  Se $a_(i j)$ è il generico elemento in riga $i$ e colonna $j$ di $A$, alora la differenza $j-i$
  - $=0$ per elementi sulla *diagonale principale*.
  - $=k>0$ per gli elementi sulla *k-esima sopradiagonale*.
  - $=r<0$ per gli elementi sulla *(-k)-esima sottodiagonale*.
]

Nel caso in cui $A$ è diagonale, si ottiene:
$
  A=mat(a_(11);, a_(22);, , dots.down;, , , dots.down, ;, , , , a_(n n ))
$
ovvero è sufficiente un vettore di lunghezza $n$ per memorizzare gli elementi significativi di $A$. $A$ è un caso particolare di *matrice sparsa*, ovvero una matrice i cui elementi non nulli sono $O(n)$ invece che $n^2$.
In questo caso $A  underline(x) = underline(b)$ diviene, semplicemente
$
  a_(1 1) x_1 = b_1 \
  a_( 2 2) x_2 = b_2 \
  dots.v \
  a_(n n) x_n = b_n
$
e, considerato che det(A)=$limits(Pi)_(i=1)^n a_(i i) eq.not 0$, segue che $a_(i i) eq.not 0, forall i=1,...,n$. Pertanto la soluzione si ottiene con:
$
  x_i = b_i/a_(i i), space i=1,...,n.
$
In conclusione, sono sufficienti 2 vettori di lunghezza $n$ (uno per al diagonale di $A$ e l'altro per il termine noto, che possiamo riscrivere con $underline(x)$) ed $n$ operazioni algebriche elementari.