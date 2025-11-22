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
    a_(11), a_(12), ..., a_(1n); a_(21), a_(22), ..., a_(2n); dots.v, dots.v, dots.v, dots.v; a_(m 1), a_(m 2), ..., a_(m n);
  )
  quad quad
  uu(b)=mat(b_1; b_2; dots.v; b_m) in RR^m
  quad quad
  uu(x)=mat(x_1; x_2; dots.v; x_n) in RR^m
$
come segue:
$
  A uu(x) = uu(b) space space space (2)
$

Nella nostra trattazione, assumeremo che $m gt.eq n$, ovvero che il numero delle equazioni non sia minore del numero delle incognite. Pertanto il numero di colonne della matrice $A$ è minore uguale del numero di righe.


#observation()[
  - $(a_(i 1),...,a_(i n)) in RR^(1 times n)$, è la i-esima riga di A; (lo stesso per la colonna j-esima in $RR^m$)
  - $a_(i j)$ è l'elemento che si trova nell'intersezione della riga i-esima con la colonna j-esima.
]

Assumeremo, inoltre, che la matrice $A$ abbia rango massimo, ovvero uguale a $n$. Questo significa che le colonne di $A$ sono vettori linearmente indipendenti tra loro.
Distingueremo due casi significativi che sono il caso in cui:
+ $m=n <=> A$ è una matrice quadrata
+ $m>n <=> A$ è rango massimo.
== Sistemi lineari: casi semplici

=== Il caso quadrato
Se $A in RR^(n times m)$, e rank($A$)$=n$, segue che $A$ è una matrice *non singolare*. Questo significa che $exists A^(-1)$, la matrice inversa di $A$, tale che
$
  A^(-1) dot A = A dot A^(-1) = I = mat(1, , , ; , dots.down, , , ; , , dots.down, , ; , , , 1;) in RR^(n times n)
$
con $I$ la matrice identità.

#observation()[
  In questo caso $x,b in RR^n$ e, evidentemente $I dot uu(x) = uu(x)$.
]
Pertanto, se dobbiamo risolvere il problema
$
  A uu(x) = uu(b)
$
allora, moltiplicando membro a membro per $A^(-1)$, otteniamo che $exists! uu(x) = A^(-1) dot uu(b)$ soluzione del problema. Tuttavia questa espressione della soluzione non è generalmente efficiente dal punto di vista computazionale. Pertanto sarà utilizzata solo in casi molto particolari.
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
In questo caso $a_(i j ) = 0$ con $i eq.not j$ ovvero solamente i valori della diagonale principale possono essere diversi da 0:
$
  A = mat(
    a_(11), a_(12), ..., a_(1n); a_(21), a_(22), ..., a_(2n); dots.v, dots.v, dots.down, dots.v; a_(m 1), a_(m 2), ..., a_(m n);
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
  A=mat(a_(11); , a_(22); , , dots.down; , , , dots.down, ; , , , , a_(n n ))
$
ovvero è sufficiente un vettore di lunghezza $n$ per memorizzare gli elementi significativi di $A$. $A$ è un caso particolare di *matrice sparsa*, ovvero una matrice i cui elementi non nulli sono $O(n)$ invece che $n^2$.
In questo caso $A uu(x) = uu(b)$ diviene, semplicemente
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
In conclusione, sono sufficienti 2 vettori di lunghezza $n$ (uno per al diagonale di $A$ e l'altro per il termine noto, che possiamo riscrivere con $uu(x)$) ed $n$ operazioni algebriche elementari.

=== $A$ triangolare
In questo caso, gli elementi significativi di $A$ si trovano in una porzione _triangolare_ della matrice. Si distinguono due casi:
- $A$ triangolare *inferiore*, in cui $a_(i j) = 0 " se " j>i$
- $A$ triangolare *superiore*, in cui $a_(i j) = 0 " se " i>j$

Nel caso in cui la matrice A sia triangolare inferiore, il sistema lineare assume la forma:
$
  & a_(1 1)x_1                                                                                 && = b_1, \
  & a_(2 1)x_1 + a_(2 2)x_2                                                                    && = b_2, \
  & a_(3 1)x_1 + a_(3 2)x_2 + a_(3 3)x_3                                                       && = b_3, \
  & dots.v quad quad quad quad dots.v quad quad quad quad dots.down quad quad quad quad dots.v && \
  & a_(n 1 )x_1 + a_(n 2)x_2 + ...+a_(n n)x_n                                                  && = b_n.
$

e quindi gli elementi della soluzione possono essere ottenuti mediante sostituzioni successive in avanti
$
  & x_1 = b_1 \/ a_(1 1) \
  & x_2 = (b_2 - a_(2 1)x_1) \/ a_(2 2) \
  & x_3 = (b_3 - a_(3 1)x_1 - a_(3 2)x_2)\/a_(3 3) quad quad quad quad (3) \
  & quad space space dots.v \
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

Osserviamo che è possibile definire un metodo di risoluzione alternativo a (3). I passi sono i seguenti: una volta calcolata $x_1$, possiamo utilizzarla per aggiornare le componenti del vettore dei termini noti, dalla seconda alla n-esima; calcolata quindi $x_2$ possiamo aggiornare le componenti $3 : n$ del vettore dei termini noti e così via come descritto nell'Algoritmo 3.2.
La differenza sostanziale tra gli Algoritmi 3.1 e 3.2 è nella modalità di accesso agli elementi della matrice $A$: nel primo algoritmo vi si accede per riga, mentre nel secondo vi si accede per colonna. Pertanto, la scelta tra i due sarà determinata dal tipo di memorizzazione delle matrici prevista dal linguaggio utilizzato.

Nel caso in cui la matrice $A$ sia triangolare superiore. Il sistema lineare (1) assume la forma:
$
                  a_(1 1)x_1 + a_(1 2)x_2 + ... + a_(1 n) x_n = b_1 & \
                                a_(2 2)x_2 + ... + a_(2 n)x_n = b_2 & \
  dots.down quad quad dots.v quad quad dots.v quad quad dots.v quad & \
                                                  a_(n n )x_2 = b_n &
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

#observation()[
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

  #proof()[
    Che $C=A+B$ sia triangolare dello stesso tipo di $A$ e $B$, discende dal fatto che $forall i,j: c_(i j)=a_(i j) +b_(i j)$.

    Supponiamo che $A$ e $B$ siano triangolari inferiori $<=>$ $a_(i j) = b_(i j) = 0, "se " j>i =>$
    + $c_(i j)=0, j>i$
    + $c_(i i) = a_(i i) dot b_( i i)$
    Infatti, se $e_i, e_j in RR^n$ sono i versori $i$ e $j$:
    $
      c_(i j) = e_i^T C e_j = e_i^T A dot B e_j = a_(1 1) a_(1 2)...a_(i,i) overbrace(0...0, n-i) mat(0; dots.v; 0; b_(j j); dots.v; b_(n j)) = cases(i=j: a_(i i) dot b_(i i), i<j: 0)
    $
  ]

- Se A e B sono triangolari inferiori (rispettivamente superiori) a diagonale unitaria, allora anche $C=A dot B$ è una matrice triangolare inferiore (rispettivamente superiore) a diagonale unitaria.\
  #proof()[
    Siano A e B due matrici $n times n$ triangolari inferiori a diagonale unitaria. Per definizione, questo significa:
    - Per A: $a_(i j) = 0$ se $i < j$ (elementi sopra la diagonale) e $a_(i i) = 1$ (diagonale unitaria).
    - Per B: $b_(i j) = 0$ se $i < j$ (elementi sopra la diagonale) e $b_(i i) = 1$ (diagonale unitaria).
    Vogliamo dimostrare che $C = A dot B$ ha le stesse proprietà. L'elemento generico $c_(i j)$ di C è dato da:
    $
      c_(i j) = sum_(k=1)^(n) a_(i k) dot b_(k j)
    $
    Dobbiamo dimostrare due cose:
    + C è triangolare inferiore: $c_(i j) = 0$ per $i < j$.
      Analizziamo la sommatoria $c_(i j) = sum_(k=1)^(n) a_(i k) b_(k j)$ nel caso in cui $i < j$. Esaminiamo ogni singolo termine $a_(i k) b_(k j)$ della somma:
      - Caso $k > i$: poiché A è triangolare inferiore, tutti gli elementi $a_(i k)$ con $i < k$ (indice di colonna maggiore dell'indice di riga) sono zero. Quindi, $a_(i k) = 0$. L'intero termine $a_(i k) b_(k j)$ diventa $0 dot b_(k j) = 0$.
      - Caso $k lt.eq i$: poiché siamo partiti dall'ipotesi che $i < j$, se $k lt.eq i$, allora segue che $k < j$. Poiché B è triangolare inferiore, tutti gli elementi $b_(k j)$ con $k < j$ (indice di colonna maggiore dell'indice di riga) sono zero. Quindi, $b_(k j) = 0$. L'intero termine $a_(i k) b_(k j)$ diventa $a_(i k) dot 0 = 0$.
      In ogni possibile caso per $k$ (sia $k > i$ che $k lt.eq i$), il termine $a_(i k) b_(k j)$ è zero. Di conseguenza, la loro somma $c_(i j)$ è zero. Questo dimostra che C è triangolare inferiore.

    + C è a diagonale unitaria ($c_(i i) = 1$).
      Analizziamo ora gli elementi sulla diagonale, dove $i = j$.
      $
        c_(i i) = sum_(k=1)^(n) a_(i k) dot b_(k i)
      $
      Spezziamo la sommatoria in tre parti:
      - Termini per $k < i$:Poiché B è triangolare inferiore, $b_(k i) = 0$ (perché $k < i$). Questi termini sono tutti nulli.
      - Termini per $k > i$:Poiché A è triangolare inferiore, $a_(i k) = 0$ (perché $i < k$). Anche questi termini sono tutti nulli.
      - Termine per $k = i$:L'unico termine che sopravvive è quello dove $k = i$. Questo termine è $a_(i i) dot b_(i i)$.Per ipotesi, A e B sono a diagonale unitaria, quindi $a_(i i) = 1$ e $b_(i i) = 1$. Il termine vale $1 dot 1 = 1$. Sommando le tre parti (tutti zeri tranne un 1), otteniamo:$c_(i i) = 0 + 1 + 0 = 1$.
      Questo dimostra che C ha diagonale unitaria.
  ]

- Se $A=(a_(i j))$ è triangolare inferiore (rispettivamente superiore) e non singolare, allora $A^(-1)$ è triangolare inferiore (rispettivamente superiore) e $(A^(-1))_(i i) = a_(i i)^(-1), forall i=1,...,n$.\
  #proof()[TODO]

- Se A è triangolare inferiore (rispettivamente superiore) a diagonale unitaria, allora anche $A^(-1)$ è triangolare inferiore (rispettivamente superiore) a diagonale unitaria.\
  #proof()[TODO]

=== $A$ ortogonale

#definition()[
  Diremo che una matrice $A in RR^(n times n)$ è ortogonale se $A^T A = A A^T = I$. Questo significa che $A$ ortogonale $=> A^(-1)=A^T$.
]
In questo caso, la soluzione del sistema lineare (1) è $uu(x) = A^(-1)uu(b) equiv A^T uu(b)$. Si ottiene con un prodotto matrice vettore, il cui costo è $2n^2$ `flops`.

L'analisi di questi casi semplici ci permette ora di affrontare il caso generale in cui $A$ è una generica matrice non singolare.

== Fattorizzazione LU di una matrice
$
  A uu(x) = uu(b), quad A in RR^(n times n), quad "det"(A) eq.not 0 quad quad quad (1)
$
I metodi che andremo ad esaminare sono i cosidetti *metodi di fattorizzazione* di $A$ del tipo:
$
  A=F_1 dot F_2 dot ... dot F_k quad quad quad ("k è piccolo") quad quad quad (2)
$
dove i fattori $F_i$ sono matrici di tipo semplice. Pertanto $F_i$ sarà o diagonale, o triangolare (inferiore o superiore) o ortogonale. Di conseguenza, i sistemi lineari con tali matrici sono facilmente risolvibili.

#example()[
  Con $k=2$ si ha $A=F_1 dot F_2$. Quindi se dobbiamo risolvere $A uu(x) = uu(b)$, questo equivale a risolvere:
  $
    F_1 dot F_2 uu(x) = uu(b) => F_1underbracket((F_2 uu(x)), uu(y)) = uu(b)
  $
  quindi possiamo risolvere, nell'ordine, i sistemi lineari:
  $
    F_1 uu(y) = uu(b) quad quad "e" quad quad F_2 uu(x) = uu(y)
  $
]
Nel caso generale (2), risolvere (1) equivale a risolvere:
$
  F_1 dot F_2 dot ... dot F_k uu(x) = uu(b)
$
Se inizializziamo $uu(x_0) <- uu(b)$, allora, risolviamo i sistemi lineari:
$
  F_i x_i = x_(i-1), space i=1,...,k
$
e $uu(x_k)$ sarà il vettore soluzione $uu(x)$.

#observation()[
  In pratica:
  + non sarà in genere necessario memorizzare esplicitamente i $k$ fattori $F_i, space i=1,...,n$. Infatti potremo sempre sovrascrivere gli elementi della matrice $A$ con l'informazione relativa ai suoi fattori;
  + non sarà necessario memorizzare le soluzioni intermedie $x_i, space i=0,...,k$. Infatti, lo stesso vettore potrà essere utilizzato per contenere il termine noto e poi sovrascritto con le soluzioni intermedie.
]
In definitiva, un generico metodo di risoluzione si caratterizzerà per la specifica fattorizzazione (2).

//MANCA ROBA

#definition(
  "Fattorizzazione LU di una matrice",
)[
  Diremo che $A in RR^(n times n)$, non singolare, è *fattorizzabile LU* se $exists L in R^(n times n)$ matrice triangolare inferiore a *diagonale unitaria*, e $U in RR^(n times n)$ triangolare superiore, tali che $A = L dot U$.
]

#observation()[
  Se $A=L U$, allora risolvo $A uu(x) = uu(b)$ risolvendo, nell'ordine, $L uu(y) = uu(b) and U uu(x) = uu(y)$, che sono sistemi di tipo semplice, con un costo di $2n^2$ `flops`.
]

//POSSIBILE DOMANDA ESONERO
#theorem()[
  Se $A$ è fattorizzabile LU, allora la fottorizzazione è *unica*.
]
#proof()[
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
  uu(v) = mat(v_1; dots.v; v_k; dots.v; v_n) in RR^n
$
di cui vogliamo azzerare le componenti dalla $(k+1)$-esima in poi mediante moltiplicazione per una matrice $L$ triangolare inferiore e a diagonale unitaria (non singolare). Ovvero, definiamo $L$ tale che:
$
  L uu(v) =
  mat(v_1; dots.v; v_k; 0; dots.v; 0)
  #stack(dir: ttb, spacing: 1em, [\ \ $ lr(}, size: #320%) n-k $])
$

Se $v_k eq.not 0$, allora possiamo definire il *vettore elementare di Gauss*:
$
  uu(g)_k = 1/(v_k) (overparen(0\,...\,0, k), v_(k+1),..., v_n)^T in RR^n
$
e sia
$
  e_k = mat(0; dots.v; 1; dots.v; 0) in RR^n
$
il k-esimo versore di $RR^n$, definiamo la corrispondente *matrice elementare di Gauss*:
#figure(image("images/2025-11-05-19-07-34.png"))
$L$ è una matrice triangolare inferiore con diagonale unitaria. Inoltre:
$
  L uu(v) =(I - uu(g)_k uu(e)_k^T) uu(v) = uu(v) - uu(g)_k (uu(e)_k^T uu(v)) = uu(v) - uu(g)_k v_k = mat(v_1; dots.v; v_k; v_(k+1); dots.v; v_n) - mat(0; dots.v; 0; v_(k+1); dots.v; v_n) #stack(dir: ttb, spacing: 1em, [$ lr(}, size: #300%) k $ \ \ ])
  = mat(v_1; dots.v; v_k; 0; dots.v; 0)
$
Ricapitolando, $v_k eq.not 0 <=> exists uu(g)_k <=> L= I - uu(g)_k dot uu(e)_k^T : L uu(v) = mat(v_1; dots.v; v_k; 0; dots.v; 0)$

#observation()[
  $
    L^(-1) = (I #strong[-] uu(g)_k dot uu(e)_k^T)^(-1) = I #strong[+] uu(g)_k dot uu(e)_k^T
  $
  Infatti:
  $
    L^(-1) L = (I + uu(g)_k dot uu(e)_k^T) (I - uu(g)_k dot uu(e)_k^T) = I - uu(g)_k dot uu(e)_k^T + uu(g)_k dot uu(e)_k^T - uu(g)_k dot uu(e)_k^T dot uu(g)_k dot uu(e)_k^T=\
    =I - cancel(uu(g)_k dot uu(e)_k^T) + cancel(uu(g)_k dot uu(e)_k^T) - uu(g)_k dot overparen((uu(e)_k^T dot uu(g)_k), =0) dot uu(e)_k^T= I
  $
]
A questo punto, andiamo a definire il *metodo di eliminazione di Gauss*.
- si tratta di un metodo costruttivo;
- le condizioni che garantiscono la sua esecuzione saranno le condizioni che garantiscono l'esistenza della fattorizzazione $L U$;
- è un metodo semi-iterativo, che consiste in $n-1$ passi se $A in RR^(n times n)$: al passo j-esimo l'obiettivo sarà quello di trasformare la j-esima colonna della matrice corrente in quella di una matrice triangolare superiore, ovvero, azzerare gli elementi al di sotto di quello diagonale ($j,j$).

A questo fine, se $A=(a_(i j)) equiv (a_(i j)^((1))) = A^((1))$ è la matrice da fattorizzare. Inoltre, $a_(i j)^((k))$ sta a denotare l'ultimo passo della procedura (il k-esimo) in cui l'elemento $(i,j)$ è stato modificato.

$
  A= mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); a_(21)^((1)), a_(22)^((1)), a_(23)^((1)), dots, dots, a_(2n)^((1)); a_(31)^((1)), a_(32)^((1)), a_(33)^((1)), dots, dots, a_(3n)^((1)); dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; a_(n 1)^((1)), a_(n 2)^((1)), a_(n 3)^((1)), dots, dots, a_(n n)^((1))
  ) equiv A^((1))
$

Se $a_(11)^((1)) eq.not 0$, allora possiamo definire:
- il primo vettore elementare di Gauss: $uu(g)_1 = 1/a_(11)^((1)) (0, a_(21)^((1)), ..., a_(n 1)^((1)))^T$
- la prima matrice elementare di Gauss: $L_1 = I - uu(g)_1 uu(e)_1^T$
tali che:

$
  L_1 A= mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); 0, a_(22)^2, a_(23)^2, dots, dots, a_(2n)^2; 0, a_(32)^2, a_(33)^2, dots, dots, a_(3n)^2; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; 0, a_(n 2)^2, a_(n 3)^2, dots, dots, a_(n n)^2
  ) equiv A^2
$

#observation()[
  $L_1A^((1)) = A^2$
]
Al secondo passo di eleiminazione, se $a_(22)^2 eq.not 0$, allora possiamo definire:
- il secondo vettore elementare di Gauss $uu(g)_2 = 1/(a_(22)^2) (0...0 a_(32)^2 ... a_(n 2)^2)^T$
- la seconda matrice elementare di Gauss $L_2 = I - uu(g)_2 = uu(e)_2^T$,
tali che:

$
  L_1 A= mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); 0, a_(22)^2, a_(23)^2, dots, dots, a_(2n)^2; 0, 0, a_(33)^3, dots, dots, a_(3n)^3; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; 0, 0, a_(n 3)^3, dots, dots, a_(n n)^3
  ) equiv A^3
$

#observation()[
  $L_2 A^2 = A^2$
]
Procedendo in maniera analoga, al passo j-esimo, se $a_(j j)^j eq.not 0$, potremo definire:
- il j-esimo vettore di Gauss: $uu(g)_j = 1/(a_(j j)^j) (0...0 a_(j+1,j)^j ... a_(n j)^j)^T$
- la j-esima matrice elementare di Gauss $L_j = I - uu(g)_j = uu(e)_j^T$ tale che:

$
  L_j dot ... dot L_1 A = mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); 0, a_(22)^((1)), a_(23)^((1)), dots, dots, a_(2n)^((1)); 0, 0, a_(33)^((1)), dots, dots, a_(3n)^((1)); dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; 0, 0, 0, dots, a_(n,j+1)^(j+1), a_(n n)^(j+1)
  ) = A^(j+1)
$

#observation()[
  $L_j A^j = A^(j+1)$
]
Se questo è possibile, $forall j =1 ,...,n-1$, si ottiene che:
$
  L_(n-1) dot L_(n-2) dot ... dot L_1 A = mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); 0, a_(22)^2, a_(23)^2, dots, dots, a_(2n)^2; 0, 0, a_(33)^3, dots, dots, a_(3n)^3; dots.v, dots.v, dots.down, dots.down, , dots.v; dots.v, dots.v, , dots.down, dots.down, dots.v; 0, 0, 0, dots, 0, a_(n n)^n
  ) = A^n equiv U
$
Possiamo quindi concludere che questa procedura è definita se e solo se $a_(j j)^j eq.not 0, forall j=1,...,n <=> U$ è non singolare. Inoltre, dall'uguaglianza $ underbrace(L_(n-1) dot L_(n-2) dot ... dot L_1, L^(-1)) A=U $
si osserva che:
+ $L_i$ è triangolare inferiore a diagonale unitaria.
+ $L_i^(-1)$ è triangolare inferiore a diagonale unitaria.
+ Il prodotto di matrici triangolari inferiori a diagonale unitaria è una matrice triangolare inferiore a diagonale unitaria.
Si ottiene che possiamo porre $L_(n-1) dot L_(n-2) dot ... dot L_1 = L^(-1)$ con $L$ triangolare inferiore a diagonale unitaria. Di conseguenza:
$
  L^(-1)A=U => A=L U
$
che è la fattorizzazione richiesta.

== Costo computazionale
Esaminiamo gli aspetti del costo computazionale supponendo che la fattorizzazione esista.
- *Memoria*: l'idea è quella di sovrascrivere la matrice $A$ con l'informazione dei suoi fattori $L$ e $U$. Chiaramente la porzione triangolare superiore di $U$ può essere sovrascritta sulla porzione triangolare superiore di $A$. Riguardo al fattore $L$, ricordiamo che:

  + $L^(-1)=L_(n-1) L_(n-2) dot ... dot L_1$
    $L=(L_(n-1) dot ... dot L_1)^(-1)=L_1^(-1) dot ... dot L_(n-1)^-1$
  + $L_i = I - uu(g)_i uu(e)_i^T => L_i^(-1) = I + uu(g)_i uu(e)_i^T$
  + Le prime componenti di $uu(g)_i$ sono nulle.

  Pertanto
  $
    L=(I+uu(g)_1 uu(e)_1^T)(I+uu(g)_2 uu(e)_2^T) dot ... dot (I+uu(g)_(n-1) uu(e)_(n-1)^T)
  $

  #uu[n=3]

  $
    L & =(I+uu(g)_1 uu(e)_1^T)(I+uu(g)_2 uu(e)_2^T)= \
      & =I+uu(g)_1 uu(e)_1^T + uu(g)_2 uu(e)_2^T + uu(g)_1 overbrace(uu(e)_1^T uu(g)_2, =0) uu(e)_2^T = \
      & = I + sum_(i=1)^2 uu(g)_i uu(e)_i^T
  $

  Questa proprietà vale, in generale, per ogni $n$. Perciò otteniamo che:
  $
    L=I+ sum_(i=1)^(n-1) uu(g)_i uu(e)_i^T quad quad quad (3)
  $
  Dunque al passo i-esimo della fattorizzazione possiamo riscrivere gli $(n-i)$ elementi, al di sotto di quello diagonale in colonna $i$, con gli elementi significativi di $uu(g)_i$. Di conseguenza, alla fine dell'algoritmo, avremo riscritto gli elementi della porzione strettamente triangolare inferiore di $A$, con la porzione strettamente triangolare inferiore del secondo termine di (3). Evidentemente la diagonale di $L$, che sappiamo essere unitaria, non necessita di essere memorizzata esplicitamente. In conclusione, la matrice $A$ può eesere sovrascritta con l'infornazione dei suoi fattori $L$ e $U$.

- *Numero operazioni*

  Abbiamo visto che:
  #figure(image("images/2025-11-11-13-46-44.png"))
  equivale a:
  $
    (I-uu(g)_i uu(e)_i^T)A^((i)) = A^((i))-uu(g)_i (uu(e)_i^T A^((i)))
  $
  se $a$ è un array $n times n$ che contiene gli elementi di $A$, allora:

  ```matlab
  for i=1:n-1     %passi di eliminazione
    if a(i,i)==0
      error('non fattorizzabile');
    end
    a(i+1:n,i)=a(i+1:n,i)/a(i,i);
    a(i+1:n, i+1:n) = a(i+1:n, i+1:n) - a(i+1:n, i) * a(i, i+1:n);
  end
  ```
  Operazioni all'iterazione $i$:
  - $(n-1)$ divisioni (per $uu(g)_i$)
  - $2(n-1)^2$ `flops` ($(n-1)^2$ somme $+(n-1)^2*$)
  per un totale di:
  $
    2 sum_(i=1)^(n-1) (n-1)(n-i+ 1/2) = 2 sum_(i=1)^(n-1) i (i+1/2) approx 2 sum_(i-1)^(n-1) i^2 approx 2 n^3/3 "flops"
  $
  #observation()[
    $sum_(i=1)^n i^k approx integral_1^n i^k "di" approx frac(n^(k+1), k+1)$
  ]

=== Esistenza Fattorizzazione $L U$

$
  A = L U <=> a_(i i)^((i)) eq.not 0, space forall i=1,...,n <=> "det"(U) eq.not 0
$
A questo riguardo, se $A=(a_(i j)) in RR^(n times n)$, denotiamo con $A_k in RR^(k times k)$, la sottomatrice di $A$ ottenuta come intersezione delle sue prime $k$ righe e $k$ colonne:
$
  A_k = mat(a_(11), dots, dots, a_(1 k); dots.v, , , dots.v; dots.v, , , dots.v; a_(k 1), dots, dots, a_(k k))
$
#example()[
  Se $A= mat(1, 2, 3; 4, 5, 6; 7, 8, 9)$, allora: $A_1 = (1), A_2 = mat(1, 2; 4, 5), A_3 equiv A$.
]

#observation()[
  $
    A_k & = [I_k O_(k, n-k)] A mat(I_k; O_(n-k,k))= \
        & = ([I_k O_(k,n-k)] L)(U mat(I_k; O_(n-k,k)))= \
        & = [L_k O_(k,n-k)] mat(U_k; O_(n-k,k)) = L_k U_k
  $
]
#definition()[
  Si definisce *minore principale di ordine k* di una matrice, il determinante della sottomatrice principale di ordine $k$.
]
Pertanto, dall'uguaglianza:
$
  A_k = L_k U_k
$
Segue che:
$
  det(A_k) & = det(L_k U_k) = \
           & = underbracket(det(L_k), 1) dot det(U_k) = \
           & = Pi_(i=1)^k a_(i i)^((i)), forall k = 1,...,n
$
A questo punto osserviamo che:
$
  det(U) = Pi_(i=1)^n a_(i i)^((i)) eq.not 0
$
- $<=> forall k = 1,...,n : Pi_(i=1)^k a_(i i)^((i)) eq.not 0$
- $<=> forall k = 1,...,n : det(U_k) eq.not 0$
- $<=> forall k = 1,...,n : det(A_k) eq.not 0$

In altri termini, abbiamo dimostrato il seguente risultato.

#theorem(
  "Esistenza della fattorizzazione LU",
)[
  Data una matrice non-singolare $A$, *$A$ è fattorizzabile LU se e solo se tutti i suoi minori principali sono non nulli*.
]
#observation()[
  Affinché il sistema lineare
  $
    A uu(x) = uu(b), A in RR^(n times n)
  $
  abbia soluzione (unica), è necessario e sufficiente che $det(A) = det(A_n) eq.not 0$. Tuttavia, se vogliamo fattorizzare $A=L U$, per risolverlo, allora si richiede che:
  $
    det(A_k) eq.not 0, forall k=1,...,n
  $
  condizione generalmente molto più restrittiva che non richiede solo che $det(A) eq.not 0$.
]
Tuttavia, esistono importanti classi di matrici per cui:
+ la non singolarità di $A$ deriva da una proprietà algebrica della matrice;
+ tutte le sottomatrici principali di $A$, godo della medisima proprietà.

Questo avviene, in particolare, per:
- *matrici a diagonale dominante*
- *matrici simmetriche e definite positive*

//12.11.2025

== Matrici a diagonale dominante

#definition()[
  Data una matrice $A=(a_(i j)) in RR^(n times n)$, si dice che essa è:
  - diagonale dominante per righe se:
  $
    abs(a_(i i)) > sum_(j=1\
    j eq.not i)^n abs(a_(i j)), space forall i =1,...n
  $

  - diagonale dominante per colonne se:
  $
    abs(a_(j j)) > sum_(i=1\
    i eq.not j)^n abs(a_(i j)), space forall j =1,...n
  $
]

#example(multiple: true)[
  #align(center, grid(
    columns: 2,
    column-gutter: 30pt,
    $
      A=mat(-3, 2, 0; 4, -7, 1; 1, -5, 8) " è d.d per righe."
    $,
    $
      A=mat(2, 8, 7; 1, -9, 0; 0, 0, 8) " è d.d per colonne."
    $,
  ))
]

Valgono le seguenti proprietà:
#lemma()[
  Se una matrice $A$ è diagonale dominante pei righe (rispettivamente, per colonne), allora tali sono tutte le sue sottomatrici principali: $forall k=1,...,n: A_k$ è a d.d.
]

#lemma()[
  Una matrice A è diagonale dominante per righe (rispettivamente, per colonne) se e solo se $A^T$ è diagonale dominante per colonne (rispettivamente, per righe).
]

#lemma()[
  Se una matrice $A in RR^(n times n)$ è diagonale dominante per righe (rispettivamente, per colonne), allora è non singolare, ovvero $det(A) eq.not 0$.
]

#proof()[
  Dimostriamo il caso in cui la matrice è dominante per righe. Supponiamo per assurdo che una matrice $A$ sia singolare e quindi $det(A)=0$. Segue che esiste un vettore $uu(x) in RR^n, uu(x) eq.not 0$ tale che
  $
    A uu(x) = uu(0) space space space (1)
  $
  Poiché un qualunque multiplo scalare di $x$ soddisfa ancora la (1), possiamo assumere che la sua componente di massimo modulo sia $x_k = 1$.
  Se $uu(e)_k in RR^n$ è il k-esimo versore, segue che:
  $
    (uu(e)_k^T A)uu(x) = uu(e)_k^T uu(0) = 0
  $
  ovvero, la k-esima equazione del sistema (1) sarà:
  $
    (a_(k 1), ..., a_(k n)) mat(x_1; dots.v; dots.v; x_n) = sum_(j=1)^n a_(k j) x_j ) =0
  $
  Proseguendo:
  $
    a_(k k) overbrace(x_k, =1) = - sum_(j=1\ j eq.not k)^n a_(k j) x_(j)
  $
  da cui si ottiene finalmente:
  $
    abs(a_(k k)) = abs(a_(k k) x_k) = abs(- sum_(j eq.not k) a_(k j) x_(j)) lt.eq sum_(j eq.not k) abs(a_(k j) x_(j)) lt.eq sum_(j eq.not k) abs(a_(k j))
  $
  che contraddice la d.d per righe di $A$ sulla riga k-esima. Deve quindi valere $det(A) eq.not 0$.
]

#lemma()[
  Dal lemma precedente segue che se $A$ è d.d, per righe o per colonne, allora è fattorizzabile LU.
]

== Matrici SDP: fattorizzazione $L D L^T$
#definition()[
  Diremo che $A = (a_(i j)) in RR^(n times n)$ è *sdp* (simmetrica e definita positiva) se:
  + $A = A^T$ (simmetria, ovvero $forall i,j: a_(i j) = a_(j i)$)
  + $forall uu(x) in RR^n, uu(x)eq.not uu(0): uu(x)^T A uu(x) > 0$ (definita positività)
]

Valgono le seguenti proprietà:

#lemma()[
  Tutte le sottomatrici principali di una matrice sdp sono sdp:
  $
    A " sdp " => forall k=1,...,n: A_k " è sdp"
  $
]
#proof()[
  Per un generico $k in {1,...,n}$, si consideri la partizione a blocchi di $A$

  $
    A = mat(A_k, B; C, D; augment: #(hline: 1, vline: 1), delim: "[") quad quad A^T= mat(A_k^T, B^T; C^T, D^T; augment: #(hline: 1, vline: 1), delim: "[")
  $
  con $A_k in RR^(k times k), D in RR^(n-k times n-k), B in RR^(k times n-k), C in RR^(n-k times k)$. Pertanto, uguagliando i blocchi omologhi, otteniamo che:
  $
    A_k = A_k^T quad B=C^T (<=> B^T=C) quad D=D^T
  $
  Concludiamo che $A_k$ *è simmetrica*. Rimane da dimostrare che è anche definita positiva, ovvero, $forall uu(y) in RR^k, uu(y)eq.not uu(0) : uu(y)^T A_k uu(y)>0$. Consideriamo un generico $uu(y) in RR^k, uu(y)eq.not 0$, e costruiamo
  $
    uu(x) = mat(uu(y); uu(0); delim: "[") in RR^n => uu(x) eq.not uu(0) in RR^n
  $
  Di conseguenza
  $
    0<uu(x)^T A uu(x) = (uu(y)^T uu(0)^T) mat(A_k, C^T; C, D; augment: #(hline: 1, vline: 1), delim: "[") mat(uu(y); uu(0); delim: "[") = (uu(y)^T A_k uu(y)^T C^T) mat(uu(y); uu(0); delim: "[") = uu(y)^T A_k uu(y)
  $
]

#lemma()[
  Una matrice sdp è non singolare:
  $
    det(A_k) eq.not 0
  $
]
#proof()[
  Supponiamo, per assurdo, che $det(A) =0$. Questo implica che:
  $
    exists uu(x) in RR^n, uu(x)eq.not uu(0) : A uu(x) = uu(0) => uu(x)^T A uu(x) = uu(x)^T uu(0)=0
  $
  Il che contraddice l'ipotesi che $A$ sia definita positiva. Di conseguenza, $det(A) eq.not 0$
]

#lemma()[
  Dai lemmi precedenti segue che se $A$ è sdp, allora $A$ è fattorizzabile LU.
]

#theorem()[
  Gli elementi diagonali di una matrice $A$ sdp sono positivi:
  $
    forall i = 1,...,n: a_(i i) > 0
  $
]
#proof()[
  //TODO: ricontrollare su libro se c'è
  Infatti, $forall i=1,...,n$, detto $uu(e)_i in RR^n$ l'i-esimo versore, avremo che:
  $
    uu(e)_i eq.not uu(0) and a_(i i) = uu(e)_i^T A uu(e)_i >0
  $
  poiché $A$ è definita positiva.
]

#theorem()[
  $A$ è sdp se solo se $A=L D L^T$
  con:
  - $L$ triangolare inferiore a diagonale unitaria
  - $D$ matrice con diagonale unitaria
]
#proof()[
  TODO
]

#observation()[
  Se $A$ è sdp, la matrice è fattorizzabile LDL. Quest'ultima fattorizzazione è molto più efficiente dal punto di vista computazionale della fattorizzazione LU, specialmente per il fatto che non risulta più necessario calcolare il fattore U.
]

Se $A$ è sdp, $A=A^T$ e quindi abbiamo necessità di specificare solo una sua porzione triangolare. Nel seguito, considereremo la parte triangolare inferiore di $A$. Ovvero, se $A=(a_(i j))in RR^(n times n)$, allora considereremo solo gli elementi $a_(i j)$ con $i gt.eq j$ (quindi della parte triangolare inferiore di $A$).

Per ottenere l'algoritmo di fattorizzazione, imponiamo che $forall j=1,...,n space i=i,...,n$, si abbia
$
  a_(i j) = (L D L^T)_(i j)
$

Se allora $A= (a_(i j))$ e
$
  L = mat(l_(1 1); dots.v, dots.down, ; l_(n 1), dots, , l_(n n)), space l_(j j) = 1, j=1,...,n quad D=mat(d_1; , dots.down, ; , , d_n)
$
e ricordando che, se $uu(e)_i in RR^n$ è l'i-esimo versore, allora
$
  a_(i j) = uu(e)_i^T A uu(e)_j = uu(e)_i^T L D L^T uu(e)_j = (uu(e)_i^T L)D(uu(e)_j^T L)^T = (l_(i 1), l_(i 2), ... , l_(i i), overbrace(0...0, n-1)) mat(d_1; , d_2; , , dots.down; , , , d_n) mat(l_(j 1); dots.v; l_(j j); 0; dots.v; 0) =\
  = (l_(i 1)d_1, l_(i 2)d_2, ... , l_(i i)d_i, 0,...,0)) mat(l_(j 1); dots.v; l_(j j); 0; dots.v; 0) = sum_(k=1)^(min{i,j}=j)l_(i k)d_k l_(j k) = sum_(k=1)^(j)l_(i k)d_k l_(j k)
$

Abbiamo concluso che:
$
  a_(i j) & = sum_(k=1)^j l_(i k)d_k l_(j k), quad quad j=1,...,n, space i gt.eq j \
          & =sum_(k=1)^(j-1) l_(i k)d_k l_(j j) + l_(i j)d_j l_(j j)
$

Distinguendo due casi, si ottengono le seguenti espressioni valide per $j=1,...,n$:
$
  & i=j quad quad d_j = a_(j j)- sum_(k=1)^(j-1) l_(j k)^2 d_k \
  & i>j quad quad l_(i j) = (a_(i j) - sum_(k=1)^(j-1) l_(i k) l_(j k) d_k)/ d_j, space space i=j+1,...,n
$

Utilizzando un vettore di appoggio $uu(r)$ di dimensione al più $n-1$, le operazioni richieste si verificano essere $approx 1/3 n^3$. Per quanto riguarda l'occupazione di memoria, abbiamo che gli elementi della porzione triangolare inferiore di $A$ possono essere sovrascritti con gli elementi significativi dei fattori $L$ e $D$
$
  A = mat(
    a_(11); a_(21), a_(22); dots.v, dots.v, dots.down; dots.v, dots.v, dots.v, dots.down; a_(n 1), a_(n 2), dots, a_(n, n-1), a_(n n)
  ) -> mat(
    d_(1); l_(21), d_(2); l_(31), l_(32), d_3; dots.v, dots.v, dots.v, dots.down; l_(n 1), l_(n 2), dots, l_(n, n-1), d_(n)
  )
$

//19.11.2025
//TODO: ci sarebbe un mega esempio negli appunti.
#[
  #set heading(numbering: none, outlined: false)
  === Matrici di permutazioni
]
Dato
$uu(v)
= mat(1; dots.v; k_1; dots.v; k_2; dots.v; n; delim: "[") in RR^n$
vogliamo definire una matrice $P in RR^(n times n)$ tale che $P uu(v) = mat(1; dots.v; k_2; dots.v; k_1; dots.v; n; delim: "[") in RR^n$ ovvero, gli elementi $k_1$ e $k_2$ di $uu(v)$ sono *permutati* tra loro.
$
  I = sum_(i=1)^n uu(e)_i uu(e)_i^T, " con " uu(e)_i = mat(1; dots.v; k_2; dots.v; k_1; dots.v; n; delim: "[") in RR^n quad "l'i-esimo versore"\
  I uu(v) = sum_(i=1)^n uu(e)_i underbrace((uu(e)i^T uu(v)), =i) = sum_(i=1) i dot uu(e)_i = mat(1; dots.v; n; delim: "[")
$
Nel nostro caso, invece, vogliamo scambiare le componenti $k_1$ e $k_2$. Quindi se definiamo:
$
  P=sum_(i=1\ i eq.not k_1 and K_2)^n uu(e)_i uu(e)_i^T + uu(e)_(k_2) uu(e)_(k_1)^T + uu(e)_(k_1) uu(e)_(k_2)^T quad quad (3)
$
otteniamo che
$
  P uu(v) = sum_(i=1\ i eq.not k_1 and K_2)^n uu(e)_i underbrace((uu(e)_i^T uu(v)), = i) + uu(e)_(k_2) underbrace((uu(e)_(k_1)^T uu(v)), =k_1) + uu(e)_(k_1) underbrace((uu(e)_(k_2)^T uu(v)), =k_2)
$
quindi $P$ è proprio la matrice che ci serve.

#definition()[
  $P$ definita come nella (3) si chiama *matrice di permutazione elementare*.
]
Esaminiamo la *struttura* di $P$:
$
  P = mat(
    1, , , dots.v, , , , dots.v, , , ; , dots.down, , dots.v, , , , dots.v, , , ; , , 1, dots.v, , , , dots.v, , , ; dots.c, dots.c, dots.c, 0, dots.c, dots.c, dots.c, 1, dots.c, dots.c, dots.c; , , , dots.v, 1, , , dots.v, , , ; , , , dots.v, , dots.down, , dots.v, , , ; , , , dots.v, , , 1, dots.v, , , ; dots.c, dots.c, dots.c, 1, dots.c, dots.c, dots.c, 0, dots.c, dots.c, dots.c; , , , dots.v, , , , dots.v, 1, , ; , , , dots.v, , , , dots.v, , dots.down, ; , , , dots.v, , , , dots.v, , , 1; delim: "["
  ) #stack(dir: ttb, spacing: 1em, [$k_1$\ \ \ \ $k_2$]) in RR^(n times n)\
  k_1 quad quad quad quad k_2 quad quad
$
#observation()[
  Il verde è dato dal primo membro della (3).
]

Pertanto $P$ si ottiene dalla matrice identità scambiando le colonne (o righe) $k_1$ e $k_2$ tra loro. Inoltre:
+ $P = P^T$ (simmetria)
+ $P^(-1) = P = P^T$ (P ortogonale)
Supponiamo di avere $k$ matrici di permutazione elementari:
$
  P_1, P_2, ..., P_k
$
ciascuna che scambia due elementi di un vettore tra loro. Se ora moltiplichiamo:
$
  P_k dot P_(k-1) dot ... dot P_1 dot uu(v)= mat(l_1; l_2; dots.v; l_n; delim: "[") equiv uu(p) quad quad (4)
$
con ${l_1,...,l_n}$ permutazione di ${1,...,n}$.
#observation()[
  + Se chiamiamo $P=P_k dot P_(k-1) dot ... dot P_1$ allora
    $
      P^(-1) & = (P_k dot P_(k-1) dot ... dot P_1)^T \
             & = P_1^T dot P_2^T dot ... dot P_k^T \
             & = P_1 dot P_2 dot ... dot P_k
    $
    pertanto $P$ è una matrice ortogonale (ma in generale non più simmetrica).
  + Per tenere conto di $P$ è sufficiente memorizzare il vettore $uu(p)$ in (4). Infatti, per esempio, in Matlab il prodotto $P dot uu(x)$ si realizza con $uu(x)(uu(p))$
]

#example()[
  $
    uu(x) = mat(3; 7; 8) "  e  " uu(p)=mat(3; 1; 2) ==> uu(x)(uu(p)) = mat(8; 3; 7)
  $
  Non bisogna quindi memorizzare matrici di permutazione!
]

== Pivoting
L'utilizzo di matrici di permutazione elementare ci permette di definire una variante della fattorizzazione LU di una matrice $A$ che sia solo non singolare. Preliminarmente ricordiamo (vedere appendice A1), data una matrice a blocchi
$
  A = mat(A_(11), A_(12); 0, A_(22); augment: #(hline: 1, vline: 1), delim: "[") in RR^(n times n)
$
con $A_(11) in RR^(k times k)$ e $A_(22) in RR^(n.k times n-k)$, che allora
$
  det(A) = det(A_(11)) dot det(A_(22))
$
Pertanto se $A$ è non singolare, tali sono anche $A_11$ e $A_22$.

#observation()[
  In ciò che segue verrà usata la stessa notazione introdotta per definire il metodo di eliminazione di Gauss:
  $
    A= mat(
      a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); a_(21)^((1)), a_(22)^((1)), a_(23)^((1)), dots, dots, a_(2n)^((1)); a_(31)^((1)), a_(32)^((1)), a_(33)^((1)), dots, dots, a_(3n)^((1)); dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; a_(n 1)^((1)), a_(n 2)^((1)), a_(n 3)^((1)), dots, dots, a_(n n)^((1))
    ) equiv A^((1))
  $
]

Sia $k_1$ l'indice di riga, in colonna 1, tale che:
$
  abs(a_(k_1 1)^((1))) = max_(k gt.eq 1) abs(a_(k 1)^((1))) > 0 " (altrimenti" A^((1)) "e quindi A, sarebbe singolare)"
$
Definiamo quindi la seguente matrice elementare di permutazione $P_1$ che scambia gli elementi 1 e $k_1 (k_1 gt.eq 1)$ di un vettore:
$
  P_1 A = mat(
    a_(k_1 1)^((1)), dots.c, dots.c, a_(k_1 n)^((1)); dots.v, , , dots.v; a_(11)^((1)), dots.c, dots.c, a_(1 n)^((n)); dots.v, , , dots.v; delim: "["
  ) #stack(dir: ttb, spacing: 0em, [$<-"riga 1"$\ \ $<-"riga "k_1$ \ \ ])
$

#[
  #set heading(numbering: none, outlined: false)
  === Passo 1
]
Possiamo adesso definire anche il primo vettore elementare di Gauss
$
  uu(g)_1 = frac(1, a_(k_1 1)^((1))) (0 a_(21)^((1)) ... a_(11)^((1)) ... a_(n 1)^((1)))^T
$
Osserviamo che gli elementi di
$uu(g)_1$ hanno modulo $lt.eq 1$.
E' quindi possibile definire la prima matrice elementare di Gauss:
$
  L_1 = I - uu(g)_1 uu(e)_1^T
$
che consente di ottenere
$
  L_1 P_1 A = mat(
    a_(k_1 1)^((1)), dots.c, dots.c, a_(k_1 n)^((1)); 0, a_(22)^((2)), dots.c, a_(2n)^((1)); dots.v, dots.v, , dots.v; 0, a_(n 2)^((2)), dots.c, a_(n n)^(22); delim: "["
  ) equiv A^((2))
$

#[
  #set heading(numbering: none, outlined: false)
  === Passo 2
]
Procedendo come prima, definiamo
$k_2$: $ abs(a_(k_2 2)^((2))) = max_(k gt.eq 2) abs(a_(k 2)^((2))) > 0 " (altrimenti" A^((2)) "e quindi A, sarebbe singolare)" $
Quindi, definendo la matrice di permutazione elementare
$P_2$ che permuta l'elemento 2 con il $k_2$ ($k_2 gt.eq 2$) di un vettore, otteniamo che:
$
  P_2 L_1 P_1 A = mat(
    a_(k_1 1)^((1)), a_(k_1 2)^((1)), dots.c, a_(k_1 n)^((1)); 0, a_(k_2 2)^((2)), dots.c, a_(k_2 n)^((2)); dots.v, dots.v, , dots.v; dots.v, a_(22)^((22)), dots.c, a_(2n)^((2)); dots.v, dots.v, , dots.v; 0, a_(n 2)^((2)), dots.c, a_(n n)^(22); delim: "["
  )
$
Pertanto è definito il secondo vettore elementare di Gauss: $ uu(g)_2 = frac(1, a_(k_2 2)^((2))) (0 0 a_(32)^((2)) ... a_(22)^((2)) ... a_(n 2)^((2)))^T $
e la corrispondente matrice elementare di Gauss:
$
  L_2 = I - uu(g)_2 uu(e)_2^T
$
tale che:
$
  L_2 P_2 L_1 P_1 A = mat(
    a_(k_1 1)^((1)), a_(k_1 2)^((1)), dots.c, dots.c, a_(k_1 n)^((1)); 0, a_(k_2 2)^((2)), dots.c, dots.c, a_(k_2 n)^((2)); dots.v, 0, a_(33)^((3)), dots.c, a_(3n)^((3)); dots.v, dots.v, , dots.v, dots.v; 0, 0, a_(n 3)^((3)), dots.c, a_(n n)^(3); delim: "["
  ) equiv A^((3))
$
#[
  #set heading(numbering: none, outlined: false)
  === Passo i-esimo
]
La procedura prosegue in modo analogo , se
$det(A) eq.not 0$, fino ad ottenere che:
$
  L_(n-1) P_(n-1) dots.c L_2 P_2 L_1 P_1 A = mat(
    a_(k_1 1)^((1)), a_(k_1 2)^((1)), dots.c, dots.c, a_(k_1 n)^((1)); 0, a_(k_2 2)^((2)), dots.c, dots.c, a_(k_2 n)^((2)); dots.v, dots.down, dots.down, dots.down, dots.v; dots.v, , dots.down, dots.down, dots.v; 0, dots.c, dots.c, 0, a_(k_n n)^(n); delim: "["
  ) equiv A^((n)) equiv U
$
dove, per $i=1,...,n-1$ $ abs(a_(k_i i)^((i))) = max_(k gt.eq i) abs(a_(k i)^((i))) > 0 $ $P_i$ è la matrice di permutazione che permuta le righe $i$ e $k_i$ ($k_i gt.eq i$). Il vettore di Guass corrispondente sarà: $ uu(g)_i = frac(1, a_(k_i i)^((i))) (0,...,0 a_(i+1, i)^((i)) ... a_(i i)^((i)) ... a_(n i)^((i)))^T $
e la matrice di Gauss:
$
  L_i = I - uu(g)_i uu(e)_i^T
$
== Sistemi lineari sovradeterminati
=== Esistenza della fattorizzazione QR
=== Il metodo di Householder
== Cenni sulla risoluzione di sistemi nonlineari
