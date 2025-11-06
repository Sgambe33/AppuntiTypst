#import "../../../dvd.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

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


#observation(
  )[
  - $(a_(i 1),...,a_(i n)) in RR^(1 times n)$, è la i-esima riga di A; (lo stesso per la colonna j-esima in $RR^m$)
  - $a_(i j)$ è l'elemento che si trova nell'intersezione della riga i-esima con la colonna j-esima.
]

Assumeremo, inoltre, che la matrice $A$ abbia rango massimo, ovvero uguale a $n$. Questo significa che le colonne di $A$ sono vettori linearmente indipendenti tra loro.
Distingueremo due casi significativi che sono il caso in cui:
+ $m=n <=> A$ è una matrice quadrata
+ $m>n <=> A$ è rango massimo.

== Il caso quadrato
Se $A in RR^(n times m)$, e rank($A$)$=n$, segue che $A$ è una matrice *non singolare*. Questo significa che $exists A^(-1)$, la matrice inversa di $A$, tale che 
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
In questo caso $A underline(x) = underline(b)$ diviene, semplicemente
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

=== $A$ triangolare
In questo caso, gli elementi significativi di $A$ si trovano in una porzione _triangolare_ della matrice. Si distinguono due casi:
- $A$ triangolare *inferiore*, in cui $a_(i j) = 0 " se " j>i$
- $A$ triangolare *superiore*, in cui $a_(i j) = 0 " se " i>j$

Nel caso in cui la matrice A sia triangolare inferiore, il sistema lineare assume la forma:
$
    &a_(1 1)x_1                                                                                 &&= b_1, \
    &a_(2 1)x_1 + a_(2 2)x_2                                                                    &&= b_2, \
    &a_(3 1)x_1 + a_(3 2)x_2 + a_(3 3)x_3                                                       &&= b_3, \
    &dots.v quad quad quad quad dots.v quad quad quad quad dots.down quad quad quad quad dots.v &&\
    &a_(n 1 )x_1 + a_(n 2)x_2 + ...+a_(n n)x_n                                                  &&= b_n.
$

e quindi gli elementi della soluzione possono essere ottenuti mediante sostituzioni successive in avanti
$
    &x_1 = b_1 \/ a_(1 1)\
    &x_2 = (b_2 - a_(2 1)x_1) \/ a_(2 2)\
    &x_3 = (b_3 - a_(3 1)x_1 - a_(3 2)x_2)\/a_(3 3) quad quad quad quad (3)\
    & quad space space dots.v\
    & x_n = (b_n - Sigma_(j=1)^(n-1) a_(n j)x_j) \/ a_(n n)
$
Osseriaviamo che, essendo $A$ non singolare, deve valere $a_(i i) eq.not 0, i =1,...,n$. Pertanto le operazioni in (3) risultano ben definite. Riguardo al costo computazionale, è evidente che solo la porzione triangolare della matrice $A$ deve essere necessariamente memorizzata, per un totale di:
$
  Sigma_(i=1)^n i = frac(n(n+1), 2) approx frac(n^2, 2)
$
posizioni di memoria. Per il numero di operazioni richieste, da (3) si evince che sono necessari: 1 `flop` per calcolare $x_1$, 3 `flop` per calcolare $x_2$, 5 `flop` per calcolare $x_3$, ..., $2n — 1$ `flop` per calcolare $x_n$, per un totale di
$
  Sigma_(i=1)^n (2i-1) = n^2 "flop"
$
L'Algoritmo 3.1 implementa (3), con la matrice $A$ contenente gli elementi della matrice $A$ ed il vettore $x$ contenente, inizialmente, il vettore dei termini noti $b$ e, successivamente, riscritto con il vettore soluzione $x$.

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 3.1* Sistema triangolare inferiore],
)
```matlab
for i=1:n
  for j=1:i-1
    x(i)=x(i)-A(i,j)*x(j);
  end
  x(i)=x(i)/A(i,i);
end
```
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 3.2* Sistema triangolare inferiore V2],
)
```matlab
for j=1:n
  x(j) = x(j)/A(j,j);
  for i=j+1:n
    x(i)=x(i)-A(i,j)*x(j);
  end
end
```
//29.10.2025

Osserviamo che è possibile definire un metodo di risoluzione alternativo a (3). I passi sono i seguenti: una volta calcolata $x_1$, possiamo utilizzarla per aggiornare le componenti del vettore dei termini noti, dalla seconda alla n-esima; calcolata quindi $x_2$ possiamo aggiornare le componenti $3 div n$ del vettore dei termini noti e così via come descritto nell'Algoritmo 3.2. 
La differenza sostanziale tra gli Algoritmi 3.1 e 3.2 è nella modalità di accesso agli elementi della matrice $A$: nel primo algoritmo vi si accede per riga, mentre nel secondo vi si accede per colonna. Pertanto, la scelta tra i due sarà determinata dal tipo di memorizzazione delle matrici prevista dal linguaggio utilizzato. 

Nel caso in cui la matrice $A$ sia triangolare superiore. Il sistema lineare (1) assume la forma:
$
  a_(1 1)x_1 + a_(1 2)x_2 + ... + a_(1 n) x_n = b_1                &\
  a_(2 2)x_2 + ... + a_(2 n)x_n = b_2                              &\
  dots.down quad quad dots.v quad quad dots.v quad quad dots.v quad&\
  a_(n n )x_2 = b_n                                                &
$

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 3.3* Sistema triangolare superiore],
)
```matlab
for j=n:-1:1
  for j=i+1:n
    x(i)=x(i)-A(i,j)*x(j);
  end
  x(i)=x(i)/A(i,i);
end
```
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 3.4* Sistema triangolare superiore V2],
)
```matlab
for j=n:-1:1
  x(j) = x(j)/A(j,j);
  for i=1:j-1
    x(i)=x(i)-A(i,j)*x(j);
  end
end
```
e quindi gli elementi della soluzione possono essere ottenuti mediante sostituzioni successive all'indietro. 
$
  x_(n-i) = frac(b_(n-i)-limits(Sigma)_(j=n-i+1)^n a_(n-i,j)x_j, a_(n-i,n-i)), quad i=0,...,n-1
$

Considerazioni, del tutto analoghe a quelle fatte per il caso triangolare inferiore. valgono riguardo alla ben definizione delle operazioni richieste ed al costo computazionale, sia in termini di `flop` che di occupazione di memoria. Il metodo di risoluzione è illustrato negli Algoritmi 3.3 e 3.4. Per questi ultimi, valgono le stesse considerazioni fatte rispettivamente per gli Algoritmi 3.1 e 3.2, riguardo alle modalità di accesso ai dati.

//04.11.2025

#observation(
  )[
Ove possibile, utilizzare in Matlab la notazione vettoriale. Ad esempio, l'algoritmo 3.4 può essere riscritto come segue:
#codly(languages: codly-languages, zebra-fill: none, breakable: false, header: [*Algoritmo 3.5* Notazione vettoriale])
```matlab
for j=n:-1:1
  x(j) = x(j)/A(j,j);
  x(1:j-1) = x(1:j-1) - a(1:j-1,j)*x(j)
end
```
Quest'ultima scrittura è sostanzialmente più efficiente (oltre che più compatta) della precedente.
]

#[
  #set heading(numbering: none, outlined: false)
  === Proprietà matrici triangolari
]
- Se $A=(a_(i j)), B=(b_(i j))$ sono matrici triangolari inferiori (rispettivamente superiori), allora anche $C=(c_(i j))$, con
  $
    (1) quad C=A+B quad "o" quad C=A dot B quad (2)
  $
  sono triangolari inferiori (rispettivamente superiori). Inoltre, nel caso:
  - (1) $C_(i i) = a_( i i) + b_(i i )$
  - (2) $C_(i i) = a_(i i ) dot b_(i i)$

  #proof(
    )[
    Che $C=A+B$ sia triangolare dello stesso tipo di $A$ e $B$, discende dal fatto che $forall i,j: c_(i j)=a_(i j) +b_(i j)$.

    Supponiamo che $A$ e $B$ siano triangolari inferiori $<=>$ $a_(i j) = b_(i j) = 0, "se " j>i =>$
    + $c_(i j)=0, j>i$
    + $c_(i i) = a_(i i) dot b_( i i)$
    Infatti, se $e_i, e_j in RR^n$ sono i versori $i$ e $j$:
    $
      c_(i j) = e_i^T C e_j = e_i^T A dot B e_j = a_(1 1) a_(1 2)...a_(i,i) overbrace(0...0, n-i) mat(0;dots.v;0;b_(j j);dots.v;b_(n j)) = cases(i=j: a_(i i) dot b_(i i), i<j: 0)
    $
  ]

- Se A e B sono triangolari inferiori (rispettivamente superiori) a diagonale unitaria, allora anche $C=A dot B$ è una matrice triangolare inferiore (rispettivamente superiore) a diagonale unitaria.\
  #proof()[TODO]

- Se $A=(a_(i j))$ è triangolare inferiore (rispettivamente superiore) e non singolare, allora $A^(-1)$ è triangolare inferiore (rispettivamente superiore) e $(A^(-1))_(i i) = a_(i i)^(-1), forall i=1,...,n$.\
  #proof()[TODO]

- Se A è triangolare inferiore (rispettivamente superiore) a diagonale unitaria, allora anche $A^(-1)$ è triangolare inferiore (rispettivamente superiore) a diagonale unitaria.\
  #proof()[TODO]

=== $A$ ortogonale

#definition(
  )[
  Diremo che una matrice $A in RR^(n times n)$ è ortogonale se $A^T A = A A^T = I$. Questo significa che $A$ ortogonale $=> A^(-1)=A^T$.
]
In questo caso, la soluzione del sistema lineare (1) è $underline(x) = A^(-1)underline(b) equiv A^T underline(b)$. Si ottiene con un prodotto matrice vettore, il cui costo è $2n^2$ `flops`.

L'analisi di questi casi semplici ci permette ora di affrontare il caso generale in cui $A$ è una generica matrice non singolare.

== Il caso generale
$
  A underline(x) = underline(b), quad A in RR^(n times n), quad "det"(A) eq.not 0 quad quad quad (1)
$
I metodi che andremo ad esaminare sono i cosidetti *metodi di fattorizzazione* di $A$ del tipo:
$
  A=F_1 dot F_2 dot ... dot F_k quad quad quad ("k è piccolo") quad quad quad (2)
$
dove i fattori $F_i$ sono matrici di tipo semplice. Pertanto $F_i$ sarà o diagonale, o triangolare (inferiore o superiore) o ortogonale. Di conseguenza, i sistemi lineari con tali matrici sono facilmente risolvibili.

#example(
  )[
  Con $k=2$ si ha $A=F_1 dot F_2 $. Quindi se dobbiamo risolvere $A underline(x) = underline(b)$, questo equivale a risolvere:
  $
    F_1 dot F_2 underline(x) = underline(b) => F_1underbracket((F_2 underline(x)), underline(y)) = underline(b)
  $
  quindi possiamo risolvere, nell'ordine, i sistemi lineari:
  $
    F_1 underline(y) = underline(b) quad quad "e" quad quad F_2 underline(x) = underline(y)
  $
]
Nel caso generale (2), risolvere (1) equivale a risolvere:
$
  F_1 dot F_2 dot ... dot F_k underline(x) = underline(b)
$
Se inizializziamo $underline(x_0) <- underline(b)$, allora, risolviamo i sistemi lineari:
$
  F_i x_i = x_(i-1), space i=1,...,k
$
e $underline(x_k)$ sarà il vettore soluzione $underline(x)$.

#observation(
  )[
  In pratica:
  + non sarà in genere necessario memorizzare esplicitamente i $k$ fattori $F_i, space i=1,...,n$. Infatti potremo sempre sovrascrivere gli elementi della matrice $A$ con l'informazione relativa ai suoi fattori;
  + non sarà necessario memorizzare le soluzioni intermedie $x_i, space i=0,...,k$. Infatti, lo stesso vetto potrà essere utilizzato per contenere il termine noto e poi sovrascritto con le soluzioni intermedie.
]
In definitiva, un generico metodo di risoluzione si caratterizzerà per la specifica fattorizzazione (2).

//MANCA ROBA

#definition(
  "Fattorizzazione LU di una matrice",
)[
  Diremo che $A in RR^(n times n)$, non singolare, è *fattorizzabile LU* se $exists L in R^(n times n)$ matrice triangolare inferiore a *diagonale unitaria*, e $U in RR^(n times n)$ triangolare superiore, tali che $A = L dot U$.
]

#observation(
  )[
Se $A=L U$, allora risolvo $A underline(x) = underline(b)$ risolvendo, nell'ordine, $L underline(y) = underline(b) and U underline(x) = underline(y)$, che sono sistemi di tipo semplice, con un costo di $2n^2$ `flops`.
]

//POSSIBILE DOMANDA ESONERO
#theorem()[
  Se $A$ è fattorizzabile LU, allora la fottorizzazione è *unica*.
]
#proof(
  )[
  Supponiamo che $A=L U$ e $A=L_1 U_1$ siano due fattorizzazioni LU di $A$. Dobbiamo dimostrare che $L=L_1 and U=U_1$. Preliminarmente ricordiamo che, poiché $L$ e $L_1$ hanno diagonale unitaria, det($L$) = det($L_1$)$=1$. Da questo segue :
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
]

//05.11.2025
Per dimostrare costruttivamente l'esistenza della fattorizzazione e le condizioni sotto le quali essa è definita, vediamo come risolvere il seguente problema. Supponiamo di aver assegnato un vettore
$
  underline(v) = mat(v_1;dots.v;v_k;dots.v;v_n) in RR^n
$
di cui vogliamo azzerare le componenti dalla $(k+1)$-esima in poi mediante moltiplicazione per una matrice $L$ triangolare inferiore e a diagonale unitaria (non singolare). Ovvero, definire $L$ tale che:
$
  L underline(v) = 
  mat(v_1;dots.v;v_k;0;dots.v;0)
  #stack(dir: ttb, spacing: 1em, [\ \ $ lr(}, size: #320%) n-k $])
$

Se $v_k eq.not 0$, allora possiamo definire il *vettore elementare di Gauss*:
$
  underline(g)_k = 1/(v_k) (overparen(0\,...\,0, k), v_(k+1),..., v_n)^T in RR^n
$
e sia
$
  e_k = mat(0;dots.v;1;dots.v;0) in RR^n
$
il k-esimo versore di $RR^n$, definiamo la corrispondente *matrice elementare di Gauss*:
#figure(image("images/2025-11-05-19-07-34.png"))
$L$ è una matrice triangolare inferiore con diagonale unitaria. Inoltre:
$
  L underline(v) =(I - underline(g)_k underline(e)_k^T) underline(v) = underline(v) - underline(g)_k (underline(e)_k^T underline(v)) = underline(v) - underline(g)_k v_k = mat(v_1;dots.v;v_k;v_(k+1);dots.v;v_n) - mat(0;dots.v;0;v_(k+1);dots.v;v_n) #stack(dir: ttb, spacing: 1em, [$ lr(}, size: #300%) k $ \ \ ])
  = mat(v_1;dots.v;v_k;0;dots.v;0)
$
Ricapitolando, $v_k eq.not 0 <=> exists underline(g)_k <=> L= I - underline(g)_k dot underline(e)_k^T : L underline(v) = mat(v_1;dots.v;v_k;0;dots.v;0) $ 

#observation(
  )[
  $
    L^(-1) = (I #strong[-] underline(g)_k dot underline(e)_k^T)^(-1) = I #strong[+] underline(g)_k dot underline(e)_k^T
  $
  Infatti:
  $
    L^(-1) L = (I + underline(g)_k dot underline(e)_k^T) (I - underline(g)_k dot underline(e)_k^T) = I - underline(g)_k dot underline(e)_k^T + underline(g)_k dot underline(e)_k^T - underline(g)_k dot underline(e)_k^T dot underline(g)_k dot underline(e)_k^T=\
    =I - cancel(underline(g)_k dot underline(e)_k^T) + cancel(underline(g)_k dot underline(e)_k^T) - underline(g)_k dot overparen((underline(e)_k^T dot underline(g)_k), =0) dot underline(e)_k^T= I
  $
]
A questo putno, andiamo a definire il *metodo di eliminazione di Gauss*.
- si tratta di un metodo costruttivo;
- le condizioni che garantiscono la sua esecuzione saranno le condizioni che garantiscono l'esistenza della fattorizzazione $L U$;
- è un metodo semi-iterativo, che consiste in $n-1$ passi se $A in RR^(n times n)$: al passo j-esimo l'obiettivo sarà quello di trasformare la j-esima colonna della matrice corrente in quella di una matrice triangolare superiore, ovvero, azzerare gli elementi al di sotto di quello diagonale ($(j,j)$).

A questo fine, se $A=(a_(i j)) equiv (a_(i j)^1) = A^1$ è la matrice da fattorizzare. Inoltre, $a_(i j)^k$ sta a denotare l'ultimo passo della procedura (il k-esimo) in cui l'elemento $(i,j)$ è stato modificato.

$
  A= mat(
    a_(11)^1, a_(12)^1, a_(13)^1, dots, dots, a_(1n)^1;a_(21)^1, a_(22)^1, a_(23)^1, dots, dots, a_(2n)^1;a_(31)^1, a_(32)^1, a_(33)^1, dots, dots, a_(3n)^1;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;a_(n 1)^1, a_(n 2)^1, a_(n 3)^1, dots, dots, a_(n n)^1
  ) equiv A^1
$

Se $a_(11)^1 eq.not 0$, allora possiamo definire:
- il primo vettore elementare di Gauss: $underline(g)_1 = 1/a_(11)^1 (0, a_(21)^1, ..., a_(n 1)^1)^T$
- la prima matrice elementare di Gauss: $L_1 = I - underline(g)_1 underline(e)_1^T$ 
tali che:

$
  L_1 A= mat(
    a_(11)^1, a_(12)^1, a_(13)^1, dots, dots, a_(1n)^1;0, a_(22)^2, a_(23)^2, dots, dots, a_(2n)^2;0, a_(32)^2, a_(33)^2, dots, dots, a_(3n)^2;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;0, a_(n 2)^2, a_(n 3)^2, dots, dots, a_(n n)^2
  ) equiv A^2
$

#observation()[
  $L_1A^1 = A^2$
]
Al secondo passo di eleiminazione, se $a_(22)^2 eq.not 0$, allora possiamo definire:
- il secondo vettore elementare di Gauss $underline(g)_2 = 1/(a_(22)^2) (0...0 a_(32)^2 ... a_(n 2)^2)^T$
- la seconda matrice elementare di Gauss $L_2 = I - underline(g)_2 = underline(e)_2^T$, 
tali che:

$
  L_1 A= mat(
    a_(11)^1, a_(12)^1, a_(13)^1, dots, dots, a_(1n)^1;0, a_(22)^2, a_(23)^2, dots, dots, a_(2n)^2;0, 0, a_(33)^3, dots, dots, a_(3n)^3;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;0, 0, a_(n 3)^3, dots, dots, a_(n n)^3
  ) equiv A^3
$

#observation()[
  $L_2 A^2 = A^2$
]
Procedendo in maniera analoga, al passo j-esimo, se $a_(j j)^j eq.not 0$, potremo definire:
- il j-esimo vettore di Gauss: $underline(g)_j = 1/(a_(j j)^j) (0...0 a_(j+1,j)^j ... a_(n j)^j)^T$
- la j-esima matrice elementare di Gauss $L_j = I - underline(g)_j = underline(e)_j^T$ tale che:

$
  L_j dot ... dot L_1 A = mat(
    a_(11)^1, a_(12)^1, a_(13)^1, dots, dots, a_(1n)^1;0, a_(22)^1, a_(23)^1, dots, dots, a_(2n)^1;0, 0, a_(33)^1, dots, dots, a_(3n)^1;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;0, 0, 0, dots, a_(n,j+1)^(j+1), a_(n n)^(j+1)
  ) = A^(j+1)
$

#observation()[
  $L_j A^j = A^(j+1)$
]
Se questo è possibile, $forall j =1 ,...,n-1$, si ottiene che:
$
  L_(n-1) dot L_(n-2) dot ... dot L_1 A = mat(
    a_(11)^1, a_(12)^1, a_(13)^1, dots, dots, a_(1n)^1;0, a_(22)^2, a_(23)^2, dots, dots, a_(2n)^2;0, 0, a_(33)^3, dots, dots, a_(3n)^3;dots.v, dots.v, dots.down, dots.down, , dots.v;dots.v, dots.v, , dots.down, dots.down, dots.v;0, 0, 0, dots, 0, a_(n n)^n
  ) = A^n equiv U
$
Possiamo quindi concludere che questa procedura è definita se e solo se $a_(j j)^j eq.not 0, forall j=1,...,n <=> U$ è non singolare. Inoltre, dall'uguaglianza $
  underbrace(L_(n-1) dot L_(n-2) dot ... dot L_1, L^(-1)) A=U
$ 
si osserva che:
+ $L_i$ è triangolare inferiore a diagonale unitaria.
+ $L_i^(-1)$ è triangolare inferiore a diagonale unitaria.
+ Il prodotto di matrici triangolari inferiori a diagonale unitaria è una matrice triangolare inferiore a diagonale unitaria.
Si ottiene che possiamo porre $L_(n-1) dot L_(n-2) dot ... dot L_1 = L^(-1)$ con $L$ triangolare inferiore a diagonale unitaria. Di conseguenza:
$
  L^(-1)A=U => A=L U
$
che è la fattorizzazione richiesta.