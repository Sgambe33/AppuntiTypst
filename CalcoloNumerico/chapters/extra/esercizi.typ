#import "../../../dvd.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#pagebreak()

= Esercizi

*Esercizio 1.* Verificare che $frac(3y(t)-4y(t-h)+y(t-2h), 2h) = y'(t)+o(h^2)$.

Sviluppiamo i vari membri utilizzando Taylor
- $3y(t)=3y(t)$
- $-4 y(t-h)=(y(t)-h dot(y)(t)+h^2/2 dot.double(y)(t)+o(h^3))(-4)$
- $y(t-2h)=y(t)-2h dot(y)(t)+2h^2 dot.double(y)(t)+o(h^3)$
Andiamo a sommare tutti gli sviluppi e otteniamo:
$
  y(t)-4y(t-h)+y(t-2h)=0 dot y(t)+2h dot(y)+0 dot dot.double(y)(t)+o(h^3)
$
Dividendo membro a membro per $2h$ si ottiene infine:
$
  frac(y(t)-4y(t-h)+y(t-2h), 2h)=frac(2h dot(y)+o(h^3), 2h) = dot(y)(t)+o(h^2)
$
#h(1fr)
$square$

*Esercizio 2.* Quale è la precisione di macchina di un'aritmetica finita che utilizza la base 4 e, per la rappresentazione della mantissa, 5 cifre con arrotondamento?

E' noto che la precisione di macchina in base $b$ e arrotondamento alla m-esima cifra della mantissa è data da: $u=1/2 b^(1-m)$. Nel nostro caso:
$
  b=4, m=5 => u=1/2 4^(1-5) = 1/2 4^(-4) = 2^(-9) = 1/512
$
#h(1fr)
$square$

*Esercizio 3.* Quanto vale la doppia precisione dello standard IEEE? Argomentare la risposta.

La doppia precisione IEEE utilizza la base 2, con arrotondamento alla $53^a$ cifra della mantissa (di questa, si memorizza solo la parte frazionaria, in quanto la parte intera è nota essendo uguale a 1). Pertanto:
$
  u=1/2 2^(1-53) = 2^(-53) approx 10^-16
$
#h(1fr)
$square$

*Esercizio 4.* Derivare il metodo di Newton per la ricerca degli zeri di una funzione. Dimostrarne la convergenza quadratica a radici semplici.

Il metodo di Newton è un metodo iterativo per determinare uno zero, $overline(x)$, di $f(x)=0$. A partire da un'approssimazione iniziale $x_0$, le successive si ottengono come le radici della retta tangente al grafico della funzione $f(x)$, nel punto $(x_i, f(x_i))$. Pertanto, essendo $y-f(x_i) = f'(x_i)(x-x_i)$ l'equazione della retta tangente?, $x_(i+1)$ si ottiene imponendo $y=0$. Quindi:
$
  -f(x_i)=f'(x_i)(x_(i+1)-x_i) => x_(i+1) = x_i - frac(f(x_i), f'(x_i)), space i=0,1,...
$

Un metodo si dice convergere quadraticamente se, detto $e_i = overline(x)-x_i$ l'errore al passo i-esimo, vale che il limite
$
  lim_(i-> infinity) frac(abs(e_(i+1)), abs(e_i)^2) = c < infinity
$
Inoltre, la radice $overline(x)$ è semplice se $f(overline(x))=0$ e $f'(overline(x))eq.not 0$. Questo implica che, se la funzione è sufficientemente regolare, la derivata prima è diversa da 0 in un intorno di $overline(x)$ e, pertanto, il metodo di Newton è definito. Si ottiene:
$
  0 = f(overline(x)) &= f(x_i) + (overline(x)-x_i) f'(x_i) + 1/2 (overline(x)-x_i)^2 f''(epsilon_i) quad epsilon_i in I(x_i, overline(x))\
  &=f'(x_i)[frac(f(x_i), f'(x_i)) + overline(x)-x_i] + 1/2 (overline(x)-x_i)^2 f''(epsilon_i)\
  &= f'(x_i) underbrace((overline(x)-x_(i+1)), =e_(i+1)) + 1/2 underbrace((overline(x)-x_i), =e_i^2) f''(epsilon_i)\
  &=> frac(abs(e_(i+1)), abs(e_i)^2) = 1/2 abs(frac(f''(epsilon_i), f'(x_i))) -->_(i->infinity\ x_i-> overline(x)) 1/2 abs(frac(f''(overline(x)), f'(overline(x))))
$
#h(1fr)
$square$

*Esercizio 5.* Qual'è la molteplicità della radice nulla della funzione $f(x)=x^2 sin(2x)$? Scrivere la corrispondente iterazione del metodo di Newton modificato.

$overline(x)$ è radice di molteplicità $m$ per $f(x)$ se $f(overline(x))=f'(overline(x))=dots=f^(m-1)(overline(x))=0$ e $f^((m))(overline(x))eq.not 0$.
- $f(0)=0$
- $f'(x)=2x sin(2x) + 2x^2 cos(2x) bar_(x=0) = 0$
- $f''(x) = 2 sin(2x)+ 8 cos(2x) -4x^2 sin(2x) bar_(x=0) = 0$
- $f'''(x) = 4 cos(2x) + 8 cos(2x) - 16x sin(2x) - 8x sin(2x) - 8x^2 cos(2x) bar_(x=0) = 12 eq.not 0$
La molteplicità è quindi $m=3$. Ricordiamo che l'iterazione del metodo di Newton modificato è:
$
  x_(i+1)=x_i - m dot frac(f(x_i), f'(x_i))
$
che nel nostro caso diventa:
$
  x_(i+1) = x_i - 3 dot frac(x_i^2 sin(2 x_i), 2x_i sin(2x_i) + 2x_i^2 cos(2x_i)) quad i=0,1,...
$
#h(1fr)
$square$

*Esercizio 6.* Definire il numero di condizione di una matrice e spiegarne il significato.

Data una matrice non singolare $A$, il suo numero di condizione è definito da:
$
  k(A) = norm(A) dot norm(A^(-1))
$
essendo $norm(dot)$ una generica norma su matrice indotta da una corrispondente norma su vettore. La usa importanza discende dal fatto che, risolvendo invece del sistema lineare $A uu(x)= uu(x)$, il sistema perturbato:
$
  (A + Delta A) (uu(x) + Delta uu(x)) = uu(b) + Delta uu(b)
$
allora:
$
  frac(norm(Delta A), norm(uu(x))) lt.eq k(A)(frac(norm(Delta uu(b)), norm(b))+frac(norm(Delta A), norm(A)))
$
#h(1fr)
$square$

*Esercizio 7.* Definire la fattorizzazione LU di una matrice non singolare. Dimostrare che, se esiste, la fattorizzazione è unica.

Sia $A in RR^(n times n), det(A) eq.not 0$. Diremo che $A$ è fattorizzabile LU se:
+ $exists L in RR^(n times n)$, triangolare inferiore a diagonale unitaria
+ $exists U in RR^(n times n)$, triangolare superiore
tali che
$
  A=L U quad quad (1)
$
Dimostriamo la (1). Supponiamo che $A=L U$ e $A=L_1 U_1$ siano due fattorizzazioni LU di $A$. Dobbiamo dimostrare che $L=L_1 " e " U=U_1$. Preliminarmente ricordiamo che, poiché $L$ e $L_1$ hanno diagonale unitaria, det($L$) = det($L_1$)$=1$. Da questo segue :
$
  0 eq.not "det"(A) = "det"(L U) = overbracket("det"(L), =1) dot "det"(U) = "det"(U)
$
pertanto $U$ è non singolare. Anche $U_1$ è non singolare, con gli stessi argomenti. Segue che, se:
$
  overbracket(L U, A) = overbracket(L_1 U_1, A)
$
moltiplicando, membro a membro a sinistra per $L_1^(-1)$, otteniamo:
$
  L_1^(-1) L U = overbracket(L_1^(-1) L_1, =I) U_1 = U_1
$
Moltiplicando, membro a membro da destra per $U^(-1)$, otteniamo:
$
  L_1^(-1) L underbracket(U U^(-1), =I), = U_1 U^(-1)
$
ovvero
$
  underbracket(L_1^(-1)L, "triang. inf") =underbracket(U_1 U^(-1), "triang. sup") = I quad ("perché " L_1^(-1)L " ha diagonale unitaria")
$
Quindi:
$
  L_1^(-1)L = I => L=L_1\
  U_1 U^(-1)= U => U_1 = U
$
Ovvero la fattorizzazione è *unica*.
#h(1fr)
$square$


*Esercizio 8.*

+ $P A = L U$, con $P$ opportuna matrice di permutazione, esiste, se e solo se

#h(1fr)
$square$

*Esercizio 9.* Definire una matrice a diagonale dominante. Dimostrare che essa è fattorizzabile $L U$.

Sia $A =(a_(i j)) in RR^(n times n)$. Diremo che $A$ è diagonale dominante (d.d.):
+ Per righe se $forall i=1,...,n: abs(a_(i i)) > sum_(j eq.not i\ j=1)^n abs(a_(i j))$
+ Per colonne se $forall j=1,...,n: abs(a_(j j)) > sum_(i eq.not j\ i=1)^n abs(a_(i j))$
#h(1fr)
$square$

*Esercizio 14.* Come si definisce la soluzione ai minimi quadrati di un sistema lineare sovradeterminato?

Si tratta di definire la "soluzione" del sistema lineare $A uu(x) = uu(b) space (1)$, dove $A in RR^(m times n), space m>n="rank"(A)$ e $uu(x) in RR^n, space uu(b) in RR^m$. Poiché $A uu(b) in "span"(A) and dim("span"(A)) = "rank"(A)=n<m$, allora una soluzione in senso classico in generale non esiste. Per ovviare a ciò, dato $uu(x) in RR^n$, si definisce vettore residuo, il vettore: $uu(r) = A uu(x)- uu(b)$. Pertanto, diremo che $uu(x)^* in RR^n$ è soluzione ai minimi quadrati di (1) se:
$
  norm(A uu(x)^*-uu(b))_2^2 = min_(uu(x) in RR^n) norm(A uu(x) - uu(b))_2^2
$
#h(1fr)
$square$

*Esercizio 16.* Definire il vettore di Householder relativo al vettore
$
  x = mat(-1; -2; 3; -sqrt(2))
$
Detta $H$ la corrispondente matrice elementare di Householder, quanto vale il prodotto $H x$?

E' noto che il vettore di Householder $uu(v) = uu(x)-alpha uu(e)_1$ con $uu(e)_1 in RR^(4)$ il primo versore e $alpha = plus.minus norm(uu(x))_2 = plus.minus sqrt(1+4+9+2) = plus.minus sqrt(16)= plus.minus 4$. Inoltre, il segno è scelto in modo che l'operazione $x_1 - alpha = -1 - alpha$ sia ben condizionata. Pertanto, $-1$ e $-alpha$ devono essere concordi e quindi $alpha = 4$.
Infine, è noto che $H uu(x) = alpha uu(e)_1$, quindi:
$
  H uu(x) = mat(4; 0; 0; 0)
$
#h(1fr)
$square$

*Esercizio 17.* Calcolare la norma 1 e la norma $infinity$ delle seguenti matrici:
$
  A = mat(1, -1; -2, 2; 3, -3) quad quad B = mat(1, 3, 4; 2, 4, 3)
$
Calcolare la norma 2 della matrice
$
  C = mat(1, 1; 1, -1)
$

- $norm(A)_1 = max{6,6}=6$
- $norm(A)_infinity = max{2,4,6}=6$
#observation()[
  $norm(A)_2 lt.eq sqrt(norm(A)_1 dot norm(A)_infinity) = 6$
]
- $norm(B)_1 = max{3,7,7}=7$
- $norm(B)_infinity=max{8,9}=9$
- $C^T C = mat(2, 0; 0, 2) = 2I quad norm(C)_2 = sqrt(delta(C^T C)) = sqrt(2)$ (gli autovettori? di $I$ sono 1 e 1). Controllare l'ortogonalità della matrice.
#h(1fr)
$square$

*Esercizio 18.* Qual'è la matrice di permutazione che permuta i primi 5 numeri interi in {3,2,5,1,7}? Qual'è la matrice che ripristina l'ordinamento iniziale?

Vogliamo determinare $P$ tale che:
$
  P dot mat(1; 2; 3; 4; 5) = mat(3; 2; 5; 1; 4) => P = mat(0, 0, 1, 0, 0; 0, 1, 0, 0, 0; 0, 0, 0, 0, 1; 1, 0, 0, 0, 0; 0, 0, 0, 1, 0)
$
E' noto che $P$ è ortogonale, ovvero $P^(-1) = P^T$, che è la matrice che ripristina l'ordine iniziale.
#h(1fr)
$square$

*Esercizio 19.* La matrice $A$ è fattorizzabile come
$
  A = L D L^T quad quad L = mat(1, 0; 2, 1) quad quad D= mat(2, 0; 0, 4)
$
Calcolare $A^(-1)$.
$
  A = L D L^T => A^(-1) = (L^(-1))^T D^(-1) L^(-1)\
  D^(-1) = mat(1/2, 0; 0, 1/4) quad quad L^(-1) = mat(1, 0; -2, 1)\
  A^(-1) = mat(1, -2; 0, 1) dot mat(1/2, 0; 0, 1/4) dot mat(1, 0; -2, 1) = mat(3/2, -1/2; -1/2, 1/4)
$
#h(1fr)
$square$

*Esercizio 20.* Calcolare la matrice Jacobiana della funzione
$
  mat(x_1 x_2^2; cos(pi x_1 x_2); x_1 x_2 e^(x_3^2)) equiv mat(f_1(x_1,x_2,x_3); f_2(x_1,x_2,x_3); f_3(x_1,x_2,x_3))
$

Si ottiene che:
$
  J(x_1,x_2,x_3) = mat(
    frac(partial f_1, partial x_1), frac(partial f_1, partial x_2), frac(partial f_1, partial x_3);
    frac(partial f_2, partial x_1), frac(partial f_2, partial x_2), frac(partial f_2, partial x_3);
    frac(partial f_3, partial x_1), frac(partial f_3, partial x_2), frac(partial f_3, partial x_3)
  ) = mat(x_2^2, 2 x_1 x_2, 0; - pi sin(pi x_1 x_2) x_2, - pi sin(pi x_1 x_2) x_1, 0; x_2 e^(x_3^2), x_1 e^(x_3^2), 2 x_1 x_2 x_3 e^(x_3^2))
$
#h(1fr)
$square$
