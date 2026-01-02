#import "../../../dvd.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#import "@preview/in-dexter:0.7.2": *
#show: codly-init.with()

#pagebreak()

#set math.equation(block: true)
#show math.equation: set block(breakable: true)

= Sistemi lineari e non lineari

In questo capitolo tratteremo la risoluzione di sistemi di equazioni lineari del tipo:
$
  (3.1) space space space cases(
    a_(11)x_1+a_(12)x_2+...+a_(1n)x_n=b_1,
    a_(21)x_1+a_(22)x_2+...+a_(2n)x_n=b_2,
    quad quad quad quad quad quad quad dots.v,
    a_(m 1)x_1+a_(m 2)x_2+...+a_(m n)x_n=b_m,
  )
$
in cui i coefficienti $a_(i j)$, per $i=1,...,m$ e $j=1,...,n$, sono assegnati, come lo sono anche i termini noti $b_1,...,b_m$. Le incognite da determinare sono $x_1,...,x_n$. Il sistema di equazioni (3.1), può essere riscritto in forma *vettoriale* introducendo la *matrice dei coefficienti*, *il vettore dei termini noti* e *il vettore delle incognite*, rispettivamente:
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
  A uu(x) = uu(b) space space space (3.2)
$

Nella nostra trattazione, assumeremo che $m gt.eq n$, ovvero che il numero di equazioni sia maggiore o uguale al numero di incognite. Pertanto il numero di colonne della matrice $A$ (incognite) è minore uguale del numero di righe (equazioni).


#observation(multiple: true)[
  - $(a_(i 1),...,a_(i n)) in RR^(1 times n)$, è la i-esima riga di A; (lo stesso per la colonna j-esima in $RR^m$)
  - $a_(i j)$ è l'elemento che si trova nell'intersezione della riga i-esima con la colonna j-esima.
]

Assumeremo, inoltre, che la matrice $A$ abbia *rango massimo*, ovvero uguale a $n$. Questo significa che le colonne di $A$ sono vettori linearmente indipendenti tra loro.
Distingueremo due casi significativi che sono il caso in cui:
+ $m=n <=> A$ è una matrice quadrata
+ $m>n <=> A$ è rango massimo.

#observation(multiple: true)[
  - Ricordiamo la definizione di *rango di matrice*: Il rango di una matrice $A$ è il massimo numero di colonne (o righe) linearmente indipendenti.

  - Ricordiamo la proprietà di una matrice *non singolare*:
    + Il determinante è diverso da zero.
    + E' invertibile.
    + Ha rango massimo.
    + Il sistema lineare ha soluzione unica.
    + Gli autovalori sono tutti non nulli.
]

== Sistemi lineari: casi semplici

=== Il caso quadrato
Se $A in RR^(n times m)$, e rank($A$)$=n$, segue che $A$ è una matrice *non singolare*. Questo significa che $exists A^(-1)$, la matrice inversa di $A$, tale che
$
  A^(-1) dot A = A dot A^(-1) = I = mat(1, 0, 0, 0; 0, dots.down, 0, 0; 0, 0, dots.down, 0; 0, 0, 0, 1;) in RR^(n times n)
$
con $I$ la matrice identità.

#observation()[
  In questo caso $x,b in RR^n$ e, evidentemente $I dot uu(x) = uu(x)$.
]
Pertanto, se dobbiamo risolvere il problema
$
  A uu(x) = uu(b)
$
allora, moltiplicando membro a membro per $A^(-1)$, otteniamo che $exists! uu(x) = A^(-1) dot uu(b)$ soluzione del problema. Tuttavia questa espressione della soluzione non è generalmente efficiente dal punto di vista computazionale, sarà utilizzata solo in casi molto particolari.
Ricordiamo che
$
  A "non singolare" <=> "det"(A)eq.not 0
$
Cosa che assumeremo nel seguito.
Cominciamo con l'esame di casi di sistemi lineari "semplici". Questi casi sono quelli in cui la matrice $A$ è:
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
  Se $a_(i j)$ è il generico elemento in riga $i$ e colonna $j$ di $A$, allora la differenza $j-i$
  - $=0$ per elementi sulla *diagonale principale*.
  - $=k>0$ per gli elementi sulla *k-esima sopradiagonale*.
  - $=k<0$ per gli elementi sulla *(-k)-esima sottodiagonale*.
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
e, considerato che $det(A)=product_(i=1)^n a_(i i) eq.not 0$, segue che $a_(i i) eq.not 0, forall i=1,...,n$. Pertanto la soluzione si ottiene con:
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
  & x_3 = (b_3 - a_(3 1)x_1 - a_(3 2)x_2)\/a_(3 3) quad quad quad quad (3.3) \
  & quad space space dots.v \
  & x_n = (b_n - sum_(j=1)^(n-1) a_(n j)x_j) \/ a_(n n)
$
Osserviamo che, essendo $A$ non singolare, deve valere $a_(i i) eq.not 0, i =1,...,n$. Pertanto le operazioni in (3.3) risultano ben definite. Riguardo al costo computazionale, è evidente che solo la porzione triangolare della matrice $A$ deve essere necessariamente memorizzata, per un totale di:
$
  sum_(i=1)^n i = frac(n(n+1), 2) approx frac(n^2, 2)
$
posizioni di memoria. Per il numero di operazioni richieste, da (3.3) si evince che sono necessari: 1 `flop` per calcolare $x_1$, 3 `flop` per calcolare $x_2$, 5 `flop` per calcolare $x_3$, ..., $2n — 1$ `flop` per calcolare $x_n$, per un totale di
$
  sum_(i=1)^n (2i-1) = n^2 "flop"
$
L'Algoritmo 3.1 implementa (3.3), con la matrice $A$ contenente gli elementi della matrice $A$ ed il vettore $x$ contenente, inizialmente, il vettore dei termini noti $b$ e, successivamente, riscritto con il vettore soluzione $x$.

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

Osserviamo che è possibile definire un metodo di risoluzione alternativo a (3.3). I passi sono i seguenti: una volta calcolata $x_1$, possiamo utilizzarla per aggiornare le componenti del vettore dei termini noti, dalla seconda alla n-esima; calcolata quindi $x_2$ possiamo aggiornare le componenti $3 : n$ del vettore dei termini noti e così via come descritto nell'Algoritmo 3.2.
La differenza sostanziale tra gli Algoritmi 3.1 e 3.2 è nella modalità di accesso agli elementi della matrice $A$: nel primo algoritmo vi si accede per riga, mentre nel secondo vi si accede per colonna. Pertanto, la scelta tra i due sarà determinata dal tipo di memorizzazione delle matrici prevista dal linguaggio utilizzato.

Nel caso in cui la matrice $A$ sia triangolare superiore. Il sistema lineare (3.1) assume la forma:
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
for j=n:-1:1 %initVal:step:endVal
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
for j=n:-1:1 %initVal:step:endVal
  x(j) = x(j)/A(j,j);
  for i=1:j-1
    x(i)=x(i)-A(i,j)*x(j);
  end
end
```
e quindi gli elementi della soluzione possono essere ottenuti mediante sostituzioni successive all'indietro.
$
  x_(n-i) = frac(b_(n-i)-limits(sum)_(j=n-i+1)^n a_(n-i,j)x_j, a_(n-i,n-i)), quad i=0,...,n-1
$

Considerazioni, del tutto analoghe a quelle fatte per il caso triangolare inferiore, valgono riguardo alla ben definizione delle operazioni richieste ed al costo computazionale, sia in termini di `flop` che di occupazione di memoria. Il metodo di risoluzione è illustrato negli Algoritmi 3.3 e 3.4. Per questi ultimi, valgono le stesse considerazioni fatte rispettivamente per gli Algoritmi 3.1 e 3.2, riguardo alle modalità di accesso ai dati.

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
#corollary()[
  Se $A=(a_(i j)), B=(b_(i j))$ sono matrici triangolari inferiori (rispettivamente superiori), allora anche $C=(c_(i j))$, con
  $
    (1) quad C=A+B quad "o" quad C=A dot B quad (2)
  $
  sono triangolari inferiori (rispettivamente superiori). Inoltre, nel caso:
  - (1) $c_(i i) = a_( i i) + b_(i i )$
  - (2) $c_(i i) = a_(i i ) dot b_(i i)$
]
#proof()[
  Che $C=A+B$ sia triangolare dello stesso tipo di $A$ e $B$, discende dal fatto che $forall i,j: c_(i j)=a_(i j) +b_(i j)$.

  Supponiamo che $A$ e $B$ siano triangolari inferiori $<=>$ $a_(i j) = b_(i j) = 0, "se " j>i =>$
  + $c_(i j)=0, j>i$
  + $c_(i i) = a_(i i) dot b_( i i)$
  Infatti, se $e_i, e_j in RR^n$ sono i versori $i$ e $j$:
  $
    c_(i j) = e_i^T C e_j = e_i^T A dot B e_j = mat(a_(1 1) a_(1 2)...a_(i,i) overbrace(0...0, n-i)) mat(0; dots.v; 0; b_(j j); dots.v; b_(n j)) = cases(i=j: a_(i i) dot b_(i i), i<j: 0)
  $
]

#corollary()[
  Se A e B sono triangolari inferiori (rispettivamente superiori) a diagonale unitaria, allora anche $C=A dot B$ è una matrice triangolare inferiore (rispettivamente superiore) a diagonale unitaria.
]
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
    - Caso $k > i$: poiché A è triangolare inferiore, tutti gli elementi $a_(i k)$ con $k>i$ (indice di colonna maggiore dell'indice di riga) sono zero. Quindi, $a_(i k) = 0$. L'intero termine $a_(i k) b_(k j)$ diventa $0 dot b_(k j) = 0$.
    - Caso $k lt.eq i$: poiché siamo partiti dall'ipotesi che $i < j$, se $k lt.eq i$, allora segue che $k < j$. Poiché B è triangolare inferiore, tutti gli elementi $b_(k j)$ con $k < j$ (indice di colonna maggiore dell'indice di riga) sono zero. Quindi, $b_(k j) = 0$. L'intero termine $a_(i k) b_(k j)$ diventa $a_(i k) dot 0 = 0$.
    In ogni possibile caso per $k$ (sia $k > i$ che $k lt.eq i$), il termine $a_(i k) b_(k j)$ è zero. Di conseguenza, la loro somma $c_(i j)$ è zero. Questo dimostra che C è triangolare inferiore.

  + C è a diagonale unitaria ($c_(i i) = 1$).
    Analizziamo ora gli elementi sulla diagonale, dove $i = j$.
    $
      c_(i i) = sum_(k=1)^(n) a_(i k) dot b_(k i)
    $
    Spezziamo la sommatoria in tre parti:
    - Termini per $k < i$: Poiché B è triangolare inferiore, $b_(k i) = 0$ (perché $k < i$). Questi termini sono tutti nulli.
    - Termini per $k > i$: Poiché A è triangolare inferiore, $a_(i k) = 0$ (perché $i < k$). Anche questi termini sono tutti nulli.
    - Termine per $k = i$: L'unico termine che sopravvive è quello dove $k = i$. Questo termine è $a_(i i) dot b_(i i)$.Per ipotesi, A e B sono a diagonale unitaria, quindi $a_(i i) = 1$ e $b_(i i) = 1$. Il termine vale $1 dot 1 = 1$. Sommando le tre parti (tutti zeri tranne un 1), otteniamo:$c_(i i) = 0 + 1 + 0 = 1$.
    Questo dimostra che C ha diagonale unitaria.
]

#corollary()[
  Se $A=(a_(i j))$ è triangolare inferiore (rispettivamente superiore) e non singolare, allora $A^(-1)$ è triangolare inferiore (rispettivamente superiore) e $(A^(-1))_(i i) = a_(i i)^(-1), forall i=1,...,n$.
]
#proof()[
  Dimostriamo la tesi per il caso in cui $A$ è triangolare inferiore. Il caso triangolare superiore è analogo (o segue trasponendo l'equazione). Procediamo per induzione sulla dimensione $n$ della matrice.

  *Passo base ($n=1$):* \
  Se $A = (a_(1 1))$, allora $A^(-1) = (1/a_(1 1))$. La matrice è banalmente triangolare inferiore e l'elemento è l'inverso dello scalare di partenza.

  *Passo induttivo:* \
  Supponiamo che la proprietà valga per matrici di dimensione $(n-1) times (n-1)$. Partizioniamo la matrice $A$ di dimensione $n times n$ a blocchi:
  $
    A = mat(A_(n-1), 0; v^T, a_(n n)) ("es." mat(
        #table(
          rows: 3,
          columns: 3,
          table.cell([1], stroke: (right: none, bottom: none)),
          table.cell([0], stroke: (left: none, bottom: none)),
          table.cell([0], stroke: (bottom: none)),

          table.cell([2], stroke: (right: none, top: none)),
          table.cell([3], stroke: (left: none, top: none)),
          table.cell([0], stroke: (top: none)),

          table.cell([4], stroke: (right: none)),
          table.cell([5], stroke: (left: none)),
          table.cell([6]),
        )
      )
    )
  $
  dove $A_(n-1)$ è triangolare inferiore e invertibile per ipotesi, $v$ è un vettore colonna e $0$ è il vettore nullo (poiché $A$ è triangolare inferiore).

  Cerchiamo l'inversa $B = A^(-1)$ partizionata nello stesso modo:
  $ B = mat(X, y; z^T, w) $
  Imponiamo la condizione $A B = I_n$:
  $ mat(A_(n-1), 0; v^T, a_(n n)) mat(X, y; z^T, w) = mat(I_(n-1), 0; 0, 1) $

  Svolgendo il prodotto righe per colonne a blocchi otteniamo il sistema:
  1. $A_(n-1) X + 0 z^T = I_(n-1) => A_(n-1) X = I_(n-1)$
  2. $A_(n-1) y + 0 w = 0 => A_(n-1) y = 0$
  3. $v^T y + a_(n n) w = 1$

  Analizziamo le equazioni risultanti:
  - Dalla (2), poiché $A_(n-1)$ è non singolare, l'unica soluzione è $y = 0$. Questo dimostra che l'ultima colonna di $A^(-1)$ ha tutti zeri sopra la diagonale.
  - Dalla (1), abbiamo $X = A_(n-1)^(-1)$. Per l'ipotesi induttiva, $X$ è triangolare inferiore e i suoi elementi diagonali sono i reciproci di quelli di $A_(n-1)$.
  - Dalla (3), sapendo che $y=0$, otteniamo $a_(n n) w = 1 => w = 1/a_(n n)$.

  Ricostruendo la matrice inversa:
  $ A^(-1) = mat(A_(n-1)^(-1), 0; z^T, 1/a_(n n)) $
  Poiché il blocco $A_(n-1)^(-1)$ è triangolare inferiore e il blocco sopra la diagonale ($y$) è nullo, l'intera matrice $A^(-1)$ è triangolare inferiore.
  Inoltre, gli elementi diagonali sono quelli di $A_(n-1)^(-1)$ (che sono $a_(i i)^(-1)$ per $i < n$) e l'ultimo elemento $a_(n n)^(-1)$. La tesi è dimostrata.
]

#corollary()[
  Se A è triangolare inferiore (rispettivamente superiore) a diagonale unitaria, allora anche $A^(-1)$ è triangolare inferiore (rispettivamente superiore) a diagonale unitaria.
]
#proof()[TODO]

=== $A$ ortogonale

#definition()[
  Diremo che una matrice $A in RR^(n times n)$ è ortogonale #index("Matrice", "Ortogonale") se $A^T A = A A^T = I$. Questo significa che $A$ ortogonale $=> A^(-1)=A^T$.
]
In questo caso, la soluzione del sistema lineare (1) è:
$
      A uu(x) & = uu(b) \
  A^T A uu(x) & = A^T uu(b) \
      I uu(x) & = A^T uu(b) \
        uu(x) & = A^T uu(b)
$
e si ottiene con un prodotto matrice-vettore, il cui costo è $2n^2$ `flops`.

L'analisi di questi casi semplici ci permette ora di affrontare il caso generale in cui $A$ è una generica matrice non singolare.

== Fattorizzazione LU di una matrice
$
  A uu(x) = uu(b), quad A in RR^(n times n), quad "det"(A) eq.not 0 quad quad quad (1)
$
I metodi che andremo ad esaminare sono i cosiddetti *metodi di fattorizzazione* di $A$ del tipo:
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
In definitiva, un generico metodo di risoluzione si caratterizzerà per la *specifica fattorizzazione* (2).

//TODO: MANCA ROBA

#definition(
  "Fattorizzazione LU di una matrice",
)[
  #index("Fattorizzazione", "LU")
  Diremo che $A in RR^(n times n)$, non singolare, è *fattorizzabile LU* se $exists L in R^(n times n)$ matrice triangolare inferiore a *diagonale unitaria*, e $U in RR^(n times n)$ triangolare superiore, tali che $A = L dot U$.
]

#observation()[
  Se $A=L U$, allora risolvo $A uu(x) = uu(b)$ risolvendo, nell'ordine, $L uu(y) = uu(b) "
  e " U uu(x) = uu(y)$, che sono sistemi di tipo semplice, con un costo di $2n^2$ `flops`.
]

//POSSIBILE DOMANDA ESONERO
#theorem()[
  Se $A$ è fattorizzabile LU, allora la fattorizzazione è *unica*.
]
#proof()[
  Supponiamo che $A=L U$ e $A=L_1 U_1$ siano due fattorizzazioni LU di $A$. Dobbiamo dimostrare che $L=L_1 " e " U=U_1$. Preliminarmente ricordiamo che, poiché $L$ e $L_1$ hanno diagonale unitaria, det($L$) = det($L_1$)$=1$. Da questo segue :
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
  Quand'è che una matrice è sia triangolare inferiore che superiore? Solo quando è una matrice diagonale.
  Quindi:
  $
    L_1^(-1)L = I => L=L_1\
    U_1 U^(-1)= U => U_1 = U
  $
  Ovvero la fattorizzazione è *unica*.
]

//05.11.2025
Per dimostrare costruttivamente l'esistenza della fattorizzazione e le condizioni sotto le quali essa è definita, vediamo come risolvere il seguente problema. Supponiamo di aver assegnato un vettore di cui vogliamo azzerare le componenti dalla $(k+1)$-esima in poi mediante moltiplicazione per una matrice $L$ triangolare inferiore e a diagonale unitaria (non singolare). Ovvero, definiamo $L$ tale che:
$
  uu(v) = mat(v_1; dots.v; v_k; dots.v; v_n) in RR^n quad quad L uu(v) =
  mat(v_1; dots.v; v_k; 0; dots.v; 0)
  #stack(dir: ttb, spacing: 1em, [\ \ $ lr(}, size: #320%) n-k $])
$
Se $v_k eq.not 0$, allora possiamo definire il *vettore elementare di Gauss* e il k-esimo versore di $RR^n$:
$
  uu(g)_k = 1/(v_k) (overparen(0\,...\,0, k), v_(k+1),..., v_n)^T in RR^n quad quad uu(e)_k = mat(0; dots.v; 1; dots.v; 0) in RR^n
$
Definiamo la corrispondente *matrice elementare di Gauss*:
$
  L = I - uu(g)_k uu(e)_k^T = I - 1/(v_k) mat(0; dots.v; 0; v_(k+1); dots.v; v_n)mat(0, dots.c, 1, dots.c, 0) = accent(mat(1, , , dots.v; , 1, , dots.v; , , dots.down, dots.v; dots, dots, dots, 1, dots, dots, dots; , , , -v_(k+1) / v_k, dots.down; , , , dots.v, , 1; , , , -v_n/v_k, , , 1;), k) k
$
$L$ è una matrice triangolare inferiore con diagonale unitaria. Inoltre:
$
  L uu(v) =(I - uu(g)_k uu(e)_k^T) uu(v) = uu(v) - uu(g)_k (uu(e)_k^T uu(v)) = uu(v) - uu(g)_k v_k = mat(v_1; dots.v; v_k; v_(k+1); dots.v; v_n) - mat(0; dots.v; 0; v_(k+1); dots.v; v_n) #stack(dir: ttb, spacing: 1em, [$ lr(}, size: #300%) k $ \ \ ])
  = mat(v_1; dots.v; v_k; 0; dots.v; 0)
$
Ricapitolando, il vettore $uu(g)_k$ e la matrice $L$, esistono se e solo se $v_k eq.not 0$.

#observation()[
  L'inversa della matrice $L$ si ottiene semplicemente come:
  $
    L^(-1) = (I #strong[-] uu(g)_k dot uu(e)_k^T)^(-1) = I #strong[+] uu(g)_k dot uu(e)_k^T
  $
  Infatti:
  $
    L^(-1) L = (I + uu(g)_k uu(e)_k^T) (I - uu(g)_k uu(e)_k^T) = I - uu(g)_k uu(e)_k^T + uu(g)_k uu(e)_k^T - uu(g)_k underbracket((uu(e)_k^T uu(g)_k), =0) uu(e)_k^T=I
  $
]
A questo punto, andiamo a definire il *metodo di eliminazione di Gauss*:
- si tratta di un metodo costruttivo;
- le condizioni che garantiscono la sua esecuzione saranno le condizioni che garantiscono l'esistenza della fattorizzazione $L U$;
- è un metodo semi-iterativo, che consiste in $n-1$ passi. Se $A in RR^(n times n)$: al passo j-esimo l'obiettivo sarà quello di trasformare la j-esima colonna della matrice corrente in quella di una matrice triangolare superiore, ovvero, azzerare gli elementi al di sotto di quello diagonale ($j,j$).

A questo fine, se $A=(a_(i j)) equiv (a_(i j)^((1))) = A^((1))$ è la matrice da fattorizzare e inoltre, $a_(i j)^((k))$ sta a denotare l'ultimo passo della procedura (il k-esimo) in cui l'elemento $(i,j)$ è stato modificato.

$
  A= mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); a_(21)^((1)), a_(22)^((1)), a_(23)^((1)), dots, dots, a_(2n)^((1)); a_(31)^((1)), a_(32)^((1)), a_(33)^((1)), dots, dots, a_(3n)^((1)); dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; a_(n 1)^((1)), a_(n 2)^((1)), a_(n 3)^((1)), dots, dots, a_(n n)^((1))
  ) equiv A^((1))
$

Se $a_(11)^((1)) eq.not 0$, allora possiamo definire:
- il primo vettore elementare di Gauss: $uu(g)_1 = 1/a_(11)^((1)) (0, a_(21)^((1)), dots.c, a_(n 1)^((1)))^T$
- la prima matrice elementare di Gauss: $L_1 = I - uu(g)_1 uu(e)_1^T$
tali che:

$
  L_1 A= mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); 0, a_(22)^((2)), a_(23)^((2)), dots, dots, a_(2n)^((2)); 0, a_(32)^((2)), a_(33)^((2)), dots, dots, a_(3n)^((2)); dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; 0, a_(n 2)^((2)), a_(n 3)^((2)), dots, dots, a_(n n)^((2))
  ) equiv A^((2))
$

#observation()[
  $L_1A^((1)) = A^((2))$
]
Al secondo passo di eliminazione, se $a_(22)^((2)) eq.not 0$, allora possiamo definire:
- il secondo vettore elementare di Gauss $uu(g)_2 = 1/(a_(22)^((2))) (0,0, a_(32)^((2)), dots.c, a_(n 2)^((2)))^T$
- la seconda matrice elementare di Gauss $L_2 = I - uu(g)_2 uu(e)_2^T$
tali che:

$
  L_1 L_2 A= mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1)); 0, a_(22)^((2)), a_(23)^((2)), dots, dots, a_(2n)^((2)); 0, 0, a_(33)^((3)), dots, dots, a_(3n)^((3)); dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; 0, 0, a_(n 3)^((3)), dots, dots, a_(n n)^((3))
  ) equiv A^((3))
$

#observation()[
  $L_2 A^((2)) = A^((3))$
]
Procedendo in maniera analoga, al passo j-esimo, se $a_(j j)^((j)) eq.not 0$, potremo definire:
- il j-esimo vettore di Gauss: $uu(g)_j = 1/(a_(j j)^((j))) (0,dots.c,0, a_(j+1,j)^((j)), dots.c, a_(n j)^((j)))^T$
- la j-esima matrice elementare di Gauss $L_j = I - uu(g)_j uu(e)_j^T$ tale che:

$
  L_j dot ... dot L_1 A = mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1));
    0, a_(22)^((2)), a_(23)^((2)), dots, dots, a_(2n)^((2));
    dots.v, 0, a_(33)^((3)), dots, dots, a_(3n)^((3));
    dots.v, dots.v, 0, dots.v, dots.v, dots.v;
    dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;
    0, 0, 0, dots, a_(n,j+1)^((j+1)), a_(n n)^((j+1))
  ) = A^((j+1))
$

#observation()[
  $L_j A^j = A^(j+1)$
]
Se questo è possibile, $forall j =1 ,...,n-1$, si ottiene che:
$
  L_(n-1) dot L_(n-2) dot ... dot L_1 A = mat(
    a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1n)^((1));
    0, a_(22)^((2)), a_(23)^((2)), dots, dots, a_(2n)^((2));
    0, 0, a_(33)^((3)), dots, dots, a_(3n)^((3));
    dots.v, dots.v, 0, dots.down, , dots.v;
    dots.v, dots.v, dots.v, dots.down, dots.down, dots.v;
    0, 0, 0, dots, 0, a_(n n)^((n))
  ) = A^((n)) equiv U
$
Possiamo quindi concludere che questa procedura è definita se e solo se $a_(j j)^((j)) eq.not 0, forall j=1,...,n$ ovvero *se e solo se* $U$ è non singolare. Inoltre, dall'uguaglianza $ underbrace(L_(n-1) dot L_(n-2) dot ... dot L_1, L^(-1)) A=U $
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

  + $L^(-1)=L_(n-1) L_(n-2) dot ... dot L_1 => L=(L_(n-1) dot ... dot L_1)^(-1)=L_1^(-1) dot ... dot L_(n-1)^(-1)$
  + $L_i = I - uu(g)_i uu(e)_i^T => L_i^(-1) = I + uu(g)_i uu(e)_i^T$
  + Le prime componenti di $uu(g)_i$ sono nulle.

  Pertanto
  $
    L=(I+uu(g)_1 uu(e)_1^T)(I+uu(g)_2 uu(e)_2^T) dot ... dot (I+uu(g)_(n-1) uu(e)_(n-1)^T)
  $

  Per *$n=3$*:

  $
    L & =(I+uu(g)_1 uu(e)_1^T)(I+uu(g)_2 uu(e)_2^T) \
      & =I+uu(g)_1 uu(e)_1^T + uu(g)_2 uu(e)_2^T + uu(g)_1 overbrace(uu(e)_1^T uu(g)_2, =0) uu(e)_2^T \
      & = I + sum_(i=1)^2 uu(g)_i uu(e)_i^T
  $

  Questa proprietà vale, in generale, per ogni $n$. Perciò otteniamo che:
  $
    L=I+ sum_(i=1)^(n-1) uu(g)_i uu(e)_i^T quad quad quad (3)
  $
  Dunque al passo i-esimo della fattorizzazione possiamo riscrivere gli $(n-i)$ elementi, al di sotto di quello diagonale in colonna $i$, con gli elementi significativi di $uu(g)_i$. Di conseguenza, alla fine dell'algoritmo, avremo riscritto gli elementi della porzione strettamente triangolare inferiore di $A$, con la porzione strettamente triangolare inferiore del secondo termine di (3). Evidentemente la diagonale di $L$, che sappiamo essere unitaria, non necessita di essere memorizzata esplicitamente. In conclusione, la matrice $A$ può essere sovrascritta con l'informazione dei suoi fattori $L$ e $U$.

- *Numero operazioni*

  Abbiamo visto che:
  #figure(image("images/2025-11-11-13-46-44.png"))
  equivale a:
  $
    (I-uu(g)_i uu(e)_i^T)A^((i)) = I A^((i))-uu(g)_i (uu(e)_i^T A^((i)))
  $
  se $a$ è una matrice $n times n$ che contiene gli elementi di $A$, allora:

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
A questo riguardo, se $A=(a_(i j)) in RR^(n times n)$, denotiamo con $A_k in RR^(k times k)$ la sottomatrice di $A$ ottenuta come intersezione delle sue prime $k$ righe e $k$ colonne:
$
  A_k = mat(a_(11), dots, dots, a_(1 k); dots.v, , , dots.v; dots.v, , , dots.v; a_(k 1), dots, dots, a_(k k))
$
#example()[
  Se $A= mat(1, 2, 3; 4, 5, 6; 7, 8, 9)$, allora: $A_1 = (1), A_2 = mat(1, 2; 4, 5), A_3 equiv A$.
]

#observation()[
  $
    A_k & = [I_k O_(k, n-k)] A mat(I_k; O_(n-k,k)) \
        & = ([I_k O_(k,n-k)] L)(U mat(I_k; O_(n-k,k))) \
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
  det(A_k) & = det(L_k U_k) \
           & = underbracket(det(L_k), 1) dot det(U_k) \
           & = product_(i=1)^k a_(i i)^((i)), forall k = 1,...,n
$
A questo punto osserviamo che:
$
  det(U) = product_(i=1)^n a_(i i)^((i)) eq.not 0
$
- $<=> forall k = 1,...,n : product_(i=1)^k a_(i i)^((i)) eq.not 0$
- $<=> forall k = 1,...,n : det(U_k) eq.not 0$
- $<=> forall k = 1,...,n : det(A_k) eq.not 0$

In altri termini, abbiamo dimostrato il seguente risultato.

#theorem(
  "Esistenza della fattorizzazione LU",
)[
  Data una matrice non singolare $A$, *$A$ è fattorizzabile LU se e solo se tutti i suoi minori principali sono non nulli*.
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
+ tutte le sottomatrici principali di $A$ godono della medesima proprietà.

Questo avviene, in particolare, per:
- *matrici a diagonale dominante*
- *matrici simmetriche e definite positive*

//12.11.2025

== Matrici a diagonale dominante

#definition()[
  #index("Matrice", "a diagonale dominante")
  Data una matrice $A=(a_(i j)) in RR^(n times n)$, si dice che essa è:
  - diagonale dominante per righe se:
  $
    abs(a_(i i)) > sum_(j=1\
    j eq.not i)^n abs(a_(i j)), space forall i =1,...n
  $
  Ovvero se il valore assoluto dell'elemento diagonale di ogni riga è maggiore della somma degli altri elementi della stessa riga.

  - diagonale dominante per colonne se:
  $
    abs(a_(j j)) > sum_(i=1\
    i eq.not j)^n abs(a_(i j)), space forall j =1,...n
  $
  Ovvero se il valore assoluto dell'elemento diagonale di ogni colonna è maggiore della somma degli altri elementi della stessa colonna.
]

#example(multiple: true)[
  #align(center, grid(
    columns: 2,
    column-gutter: 30pt,
    [$
        A=mat(-3, 2, 0; 4, -7, 1; 1, -5, 8) " è d.d per righe."
      $ $abs(-3) > abs(2)+abs(0)$\ $abs(-7) > abs(4)+abs(1)$ \ $abs(8) > abs(1) + abs(-5)$],
    [$
        A=mat(2, 8, 7; 1, -9, 0; 0, 0, 8) " è d.d per colonne."
      $ $abs(2) > abs(1)+abs(0)$\ $abs(-9) > abs(8)+abs(0)$ \ $abs(8) > abs(7) + abs(0)$],
  ))
]

Valgono le seguenti proprietà:
#lemma()[
  Se una matrice $A$ è diagonale dominante per righe (rispettivamente, per colonne), allora tali sono tutte le sue sottomatrici principali: $forall k=1,...,n: A_k$ è a diagonale dominante.
]

#lemma()[
  Una matrice A è diagonale dominante per righe (rispettivamente, per colonne) se e solo se $A^T$ è diagonale dominante per colonne (rispettivamente, per righe).
]

#lemma()[
  Se una matrice $A in RR^(n times n)$ è diagonale dominante per righe (rispettivamente, per colonne), allora è non singolare, ovvero $det(A) eq.not 0$.
]

#proof()[
  Dimostriamo il caso in cui la matrice è dominante per righe. Supponiamo per assurdo che una matrice $A$ sia singolare e che quindi $det(A)=0$. Segue che esiste un vettore $uu(x) in RR^n, uu(x) eq.not 0$ tale che
  $
    A uu(x) = uu(0) space space space (1)
  $
  Poiché un qualunque multiplo scalare di $uu(x)$ soddisfa ancora la (1), possiamo assumere che la sua componente di massimo modulo sia $x_k = 1$:
  $
    x_k = max_(i=1,...,n) abs(x_i) = 1 => forall j=1,...,n: abs(x_j) lt.eq 1
  $
  Se $uu(e)_k in RR^n$ è il k-esimo versore, segue che:
  $
    (uu(e)_k^T A)uu(x) = uu(e)_k^T uu(0) = 0
  $
  ovvero, la k-esima equazione del sistema (1) sarà:
  $
    (a_(k 1), ..., a_(k n)) mat(x_1; dots.v; dots.v; x_n) = sum_(j=1)^n a_(k j) x_j =0
  $
  Proseguendo:
  $
    a_(k k) overbrace(x_k, =1) = - sum_(j=1\ j eq.not k)^n a_(k j) x_(j)
  $
  da cui si ottiene finalmente:
  $
    abs(a_(k k)) = abs(a_(k k) x_k) = abs(- sum_(j=1\ j eq.not k)^n a_(k j) x_(j)) lt.eq sum_(j=1\ j eq.not k)^n abs(a_(k j) x_(j)) lt.eq sum_(j=1\ j eq.not k)^n abs(a_(k j))
  $
  che contraddice la definizione di d.d per righe di $A$ sulla riga k-esima. Deve quindi valere $det(A) eq.not 0$.
]

#lemma()[
  Dal lemma precedente segue che se $A$ è diagonale dominante, per righe o per colonne, allora è fattorizzabile LU.
]

== Matrici SDP: fattorizzazione $L D L^T$
#definition()[
  #index("Matrice", "sdp")
  Diremo che la matrice $A = (a_(i j)) in RR^(n times n)$ è *SDP* (simmetrica e definita positiva) se:
  + $A = A^T$ (simmetria rispetto alla diagonale, ovvero $forall i,j: a_(i j) = a_(j i)$)
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
  Sia $A in RR^(n times n)$ sdp e sia $A_k$ la sua sottomatrice principale di ordine $k$. E' evidente che se $A=A^T$, allora $A_k=A_k^T$. Rimane da dimostrare che è anche definita positiva, ovvero, $forall uu(y) in RR^k, uu(y)eq.not uu(0) : uu(y)^T A_k uu(y)>0$. Prendiamo un generico $uu(y) in RR^k, uu(y)eq.not 0$, e costruiamo
  $
    uu(x) = mat(uu(y); uu(0)) in RR^n => uu(x) eq.not uu(0)
  $
  Consideriamo la seguente partizione a blocchi di $A$:
  $
    A = mat(A_k, B^T; B, C; augment: #(hline: 1, vline: 1), delim: "[")
  $
  Di conseguenza
  $
    0<uu(x)^T A uu(x) = mat(uu(y)^T, uu(0)^T) mat(A_k, B^T; B, D; augment: #(hline: 1, vline: 1), delim: "[") mat(uu(y); uu(0)) = mat(uu(y)^T, A_k, uu(y)^T, C^T) mat(uu(y); uu(0)) = uu(y)^T A_k uu(y)
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
  Dai lemmi precedenti segue che, se $A$ è sdp, allora $A$ è fattorizzabile LU.
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
    a_(i i) = uu(e)_i^T A uu(e)_i >0
  $
  poiché $A$ è definita positiva.
]

#theorem()[
  #index("Fattorizzazione", "LDL")
  $A$ è SDP $<=>$ $A=L D L^T$
  con:
  - $L$ triangolare inferiore a diagonale unitaria.
  - $D$ matrice diagonale con elementi diagonali positivi.
]
#proof()[
  - $arrow.double.l$: $A=L D L^T$, con $L$ e $D$ come nelle ipotesi. Allora:
    + $A^T = (L D L^T)^T = (L^T)^T D^T L^T = L D L^T = A$ (simmetria).
    + $forall uu(x) eq.not uu(0): uu(x)^T A uu(x) >0$.
      Poiché $L$ è non singolare, allora:
      $
        forall uu(x) eq.not uu(0) quad exists uu(y) eq.not uu(0) : L^T uu(x) = uu(y) = mat(y_1; dots.v; y_n)
      $
      Pertanto:
      $
        uu(x)^T A uu(x) &= overbrace(uu(x)^T L, =uu(y)^T) D overbrace(L^T uu(x), =uu(y))\
        &= uu(y)^T D uu(y) = mat(y_1, dots, y_n) mat(d_1; , dots.down; , , d_n; delim: "[") mat(y_1; dots.v; y_n)\
        &= sum_(i=1)^n underbrace(d_i, >0) space underbrace(y_i^2, gt.eq 0) > 0
      $
  - $arrow.double$: $A$ sdp $=> A = L D L^T$, con $L$ e $D$ come nell'enunciato del teorema. Abbiamo visto che se $A$ sdp $=> A=L U$, con $L$ triangolare inferiore a diagonale unitaria e $U$ triangolare superiore (e non singolare). Osserviamo che, se $U = (u_(i j)) in RR^(n times n)$, allora:
    $
      U = D hat(U) "con" D = mat(u_(11); , dots.down; , , u_(n n); delim: "[")
    $
    Ne consegue che $hat(U)$ sarà triangolare superiore a diagonale unitaria.
    #example()[
      $
        U = mat(1, 2, 3; 0, 4, 5; 0, 0, 6; delim: "[") = underparen(mat(1; , 4; , , 6; delim: "["), D) = underparen(mat(1, 2, 3; , 1, 5/4; , , 1; delim: "["), hat(U))
      $
    ]
    Pertanto:
    $
      A = L U = L D hat(U) <=> A^T = (L D hat(U))^T = hat(U)^T (D L^T)
    $
    A questo punto osserviamo che:
    + $hat(U)^T$ è triangolare inferiore a diagonale unitaria;
    + $D L^T$ è triangolare superiore;
    + la fattorizzazione $L U$ è unica.
    Concludiamo che:
    $
      hat(U)^T = L and D L^T = U "e quindi" A=L D L^T
    $
    Rimane da dimostrare che gli elementi diagonali di $D$ sono positivi. A questo fine, osserviamo che, $forall i=1,...,n$: $exists uu(x) eq.not uu(0): L^T uu(x) = uu(e)_i$.
    Di conseguenza:
    $
      0 < uu(x)^T A uu(x) & = uu(x)^T L D L^T uu(x) \
                          & =(L^T uu(x))^T D (L^T uu(x)) \
                          & = uu(e)_i^T D uu(e)_i = d_i
    $
    Poiché $i$ è generico, l'asserto segue.

]

#observation()[
  Se $A$ è sdp, la matrice è fattorizzabile $L D L^T$. Quest'ultima fattorizzazione è molto più efficiente dal punto di vista computazionale della fattorizzazione LU, specialmente per il fatto che non risulta più necessario calcolare il fattore U.
]

Se $A$ è sdp, $A=A^T$ e quindi abbiamo necessità di specificare solo una sua porzione triangolare. Nel seguito, considereremo la parte triangolare inferiore di $A$. Ovvero, se $A=(a_(i j))in RR^(n times n)$, allora considereremo solo gli elementi $a_(i j)$ con $i gt.eq j$ (quindi della parte triangolare inferiore di $A$).

Per ottenere l'algoritmo di fattorizzazione, imponiamo che $forall j=1,...,n space i=i,...,n$, si abbia
$
  a_(i j) = (L D L^T)_(i j)
$

Se allora $A= (a_(i j))$ e siano
$
  L = mat(l_(1 1); dots.v, dots.down, ; l_(n 1), dots, , l_(n n); delim: "["), space l_(j j) = 1, j=1,...,n quad quad D=mat(d_1; , dots.down, ; , , d_n; delim: "[")
$
e ricordando che, se $uu(e)_i in RR^n$ è l'i-esimo versore, allora
$
  a_(i j) = uu(e)_i^T A uu(e)_j = uu(e)_i^T L D L^T uu(e)_j = (uu(e)_i^T L)D(uu(e)_j^T L)^T = (l_(i 1), l_(i 2), ... , l_(i i), overbrace(0...0, n-1)) mat(d_1; , d_2; , , dots.down; , , , d_n; delim: "[") mat(l_(j 1); dots.v; l_(j j); 0; dots.v; 0) =\
  = (l_(i 1)d_1, l_(i 2)d_2, ... , l_(i i)d_i, 0,...,0) mat(l_(j 1); dots.v; l_(j j); 0; dots.v; 0) = sum_(k=1)^(min{i,j}=j)l_(i k)d_k l_(j k) = sum_(k=1)^(j)l_(i k)d_k l_(j k)
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
    a_(11); a_(21), a_(22); dots.v, dots.v, dots.down; dots.v, dots.v, dots.v, dots.down; a_(n 1), a_(n 2), dots, a_(n, n-1), a_(n n); delim: "["
  ) -> mat(
    d_(1); l_(21), d_(2); l_(31), l_(32), d_3; dots.v, dots.v, dots.v, dots.down; l_(n 1), l_(n 2), dots, l_(n, n-1), d_(n); delim: "["
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
= mat(1; dots.v; k_1; dots.v; k_2; dots.v; n) in RR^n$
vogliamo definire una matrice $P in RR^(n times n)$ tale che $P uu(v) = mat(1; dots.v; k_2; dots.v; k_1; dots.v; n) in RR^n$ ovvero, gli elementi $k_1$ e $k_2$ di $uu(v)$ sono *permutati* tra loro.
$
  I = sum_(i=1)^n uu(e)_i uu(e)_i^T, " con " uu(e)_i = mat(0; dots.v; 1; dots.v; 0) in RR^n quad "l'i-esimo versore"\
  I uu(v) = sum_(i=1)^n uu(e)_i underbrace((uu(e)_i^T uu(v)), =i) = sum_(i=1)^n i dot uu(e)_i = mat(1; 2; dots.v; n)
$
Nel nostro caso, invece, vogliamo scambiare le componenti $k_1$ e $k_2$. Quindi se definiamo:
$
  P=(sum_(i=1\ i eq.not k_1 and k_2)^n uu(e)_i uu(e)_i^T) + uu(e)_(k_2) uu(e)_(k_1)^T + uu(e)_(k_1) uu(e)_(k_2)^T quad quad (3)
$
otteniamo che
$
  P uu(v) = sum_(i=1\ i eq.not k_1 and k_2)^n uu(e)_i underbrace((uu(e)_i^T uu(v)), = i) + uu(e)_(k_2) underbrace((uu(e)_(k_1)^T uu(v)), =k_1) + uu(e)_(k_1) underbrace((uu(e)_(k_2)^T uu(v)), =k_2)
$
quindi $P$ è proprio la matrice che ci serve.

#definition()[
  #index("Matrice", "di permutazione")
  $P$ definita come nella (3) si chiama *matrice di permutazione elementare*.
]
Esaminiamo la *struttura* di $P$:
$
  P = mat(
    1, , , dots.v, , , , dots.v, , , ; , dots.down, , dots.v, , , , dots.v, , , ; , , 1, dots.v, , , , dots.v, , , ; dots.c, dots.c, dots.c, 0, dots.c, dots.c, dots.c, 1, dots.c, dots.c, dots.c; , , , dots.v, 1, , , dots.v, , , ; , , , dots.v, , dots.down, , dots.v, , , ; , , , dots.v, , , 1, dots.v, , , ; dots.c, dots.c, dots.c, 1, dots.c, dots.c, dots.c, 0, dots.c, dots.c, dots.c; , , , dots.v, , , , dots.v, 1, , ; , , , dots.v, , , , dots.v, , dots.down, ; , , , dots.v, , , , dots.v, , , 1; delim: "["
  ) #stack(dir: ttb, spacing: 1em, [$k_1$\ \ \ \ $k_2$]) in RR^(n times n)\
  k_1 quad quad quad quad k_2 quad quad
$

Pertanto $P$ si ottiene dalla matrice identità scambiando le colonne (o righe) $k_1$ e $k_2$ tra loro. Inoltre:
+ $P = P^T$ (simmetria)
+ $P^(-1) = P = P^T$ (P ortogonale)
Supponiamo di avere $k$ matrici di permutazione elementari:
$
  P_1, P_2, ..., P_k
$
ciascuna che scambia due elementi di un vettore tra loro. Se ora moltiplichiamo:
$
  underbrace(P_k dot P_(k-1) dot ... dot P_1, P) dot mat(1; 2; dots.v; n) = mat(l_1; l_2; dots.v; l_n) equiv uu(p) quad quad (4)
$
con ${l_1,...,l_n}$ permutazione di ${1,...,n}$.
#observation(multiple: true)[
  + Se chiamiamo $P=P_k dot P_(k-1) dot ... dot P_1$ allora
    $
      P^(-1) & = (P_k dot P_(k-1) dot ... dot P_1)^T \
             & = P_1^T dot P_2^T dot ... dot P_k^T \
             & = P_1 dot P_2 dot ... dot P_k
    $
    pertanto $P$ è una matrice ortogonale (ma in generale non più simmetrica).
  + Per tenere conto di $P$ è sufficiente memorizzare il vettore $uu(p)$ in (4). Infatti, per esempio, in Matlab il prodotto $P dot uu(x)$ si realizza con $uu(x)(uu(p))$ (operazione di *"reordering"*).
]

#example()[
  $
    uu(x) = mat(3; 7; 8) "  e  " uu(p)=mat(3; 1; 2) ==> uu(x)(uu(p)) = mat(8; 3; 7)
  $
  - Leggo $uu(p)[1]=3 -> uu(x)(uu(p))[1] = x_3=8$
  - Leggo $uu(p)[2]=1 -> uu(x)(uu(p))[2] = x_1=3$
  - Leggo $uu(p)[3]=2 -> uu(x)(uu(p))[3] = x_2=7$
  Non bisogna quindi memorizzare matrici di permutazione!
]

== Pivoting
L'utilizzo di matrici di permutazione elementare ci permette di definire una variante della fattorizzazione LU di una matrice $A$ *che sia solo non singolare*. Preliminarmente ricordiamo (vedere appendice A1) che data una matrice a blocchi:
$
  A = mat(A_(11), A_(12); 0, A_(22); augment: #(hline: 1, vline: 1), delim: "[") in RR^(n times n)
$
con $A_(11) in RR^(k times k)$ e $A_(22) in RR^(n-k times n-k)$, per cui si ha $det(A) = det(A_(11)) dot det(A_(22))$. Pertanto se $A$ è non singolare, tali sono anche $A_11$ e $A_22$.

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
  abs(a_(k_1 1)^((1))) = max_(k gt.eq 1) abs(a_(k 1)^((1))) > 0
$
Maggiore di zero perché altrimenti $A^((1))$ e $A$ avrebbero determinante nullo e non sarebbero non singolari. Definiamo quindi la seguente matrice elementare di permutazione $P_1$ che scambia gli elementi 1 e $k_1 (k_1 gt.eq 1)$ di un vettore:
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
  uu(g)_1 = frac(1, a_(k_1 1)^((1))) (0, a_(21)^((1)), ..., a_(11)^((1)), ..., a_(n 1)^((1)))^T
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
    a_(k_1 1)^((1)), a_(k_1 2)^((1)), dots.c, dots.c, a_(k_1 n)^((1)); 0, a_(k_2 2)^((2)), dots.c, dots.c, a_(k_2 n)^((2)); dots.v, dots.v, , dots.v; dots.v, a_(22)^((2)), dots.c, dots.c, a_(2n)^((2)); dots.v, dots.v, , dots.v; 0, a_(n 2)^((2)), dots.c, dots.c, a_(n n)^((2)); delim: "["
  )
$
Pertanto è definito il secondo vettore elementare di Gauss: $ uu(g)_2 = frac(1, a_(k_2 2)^((2))) (0, a_(32)^((2)), ..., a_(22)^((2)), ..., a_(n 2)^((2)))^T $
e la corrispondente matrice elementare di Gauss:
$
  L_2 = I - uu(g)_2 uu(e)_2^T
$
tale che:
$
  L_2 P_2 L_1 P_1 A = mat(
    a_(k_1 1)^((1)), a_(k_1 2)^((1)), dots.c, dots.c, a_(k_1 n)^((1)); 0, a_(k_2 2)^((2)), dots.c, dots.c, a_(k_2 n)^((2)); dots.v, 0, a_(33)^((3)), dots.c, a_(3n)^((3)); dots.v, dots.v, , dots.v, dots.v; 0, 0, a_(n 3)^((3)), dots.c, a_(n n)^((3)); delim: "["
  ) equiv A^((3))
$
#[
  #set heading(numbering: none, outlined: false)
  === Passo i-esimo
]
La procedura prosegue in modo analogo, se $det(A) eq.not 0$, fino ad ottenere che:
$
  L_(n-1) P_(n-1) dots.c L_2 P_2 L_1 P_1 A = mat(
    a_(k_1 1)^((1)), a_(k_1 2)^((1)), dots.c, dots.c, a_(k_1 n)^((1)); 0, a_(k_2 2)^((2)), dots.c, dots.c, a_(k_2 n)^((2)); dots.v, dots.down, dots.down, dots.down, dots.v; dots.v, , dots.down, dots.down, dots.v; 0, dots.c, dots.c, 0, a_(k_n n)^((n)); delim: "["
  ) equiv A^((n)) equiv U quad quad (1)
$
dove, per $i=1,...,n-1$
$
  abs(a_(k_i i)^((i))) = max_(k gt.eq i) abs(a_(k i)^((i))) > 0 quad quad quad (A)
$
$P_i$ è la matrice di permutazione che permuta le righe $i$ e $k_i$ ($k_i gt.eq i$).

Il vettore elementare di Gauss corrispondente sarà:
$
  uu(g)_i = frac(1, a_(k_i i)^((i))) (0,...,0 a_(i+1, i)^((i)) ... a_(i i)^((i)) ... a_(n i)^((i)))^T
$
e la matrice elementare di Gauss:
$
  L_i = I - uu(g)_i uu(e)_i^T
$
//25.11.2025
#observation(multiple: true)[
  - Gli elementi di $uu(g)_i$ hanno tutti modulo $lt.eq 1$.
  - Ricordiamo che $P_i = P_i^T = P_i^(-1) => P_i dot P_i = I$. Ovvero le matrici di permutazione elementari sono simmetriche ed ortogonali e, se moltiplicate per un vettore, ne permutano le componenti $i$ e $k$ con $k_i gt.eq i$.
]
Cerchiamo di "leggere" meglio la (1). Considerando il caso $n=4$, si avrà che:
$
  L_3 P_3 L_2 P_2 L_1 P_1 A = U
$
Sfruttando le proprietà appena ricordate, possiamo riscrivere come:
$
  L_3 P_3 L_2 overbracket(P_3 P_3, I) P_2 L_1 overbracket(P_2 P_3 P_3 P_2, I)P_1 A &= U\
  underbrace(L_3, hat(L)_3) underbrace(P_3 L_2 P_3, hat(L)_2) underbrace(P_3 P_2 L_1 P_2 P_3, hat(L)_1) underbrace(P_3 P_2 P_1, P) A &= U
$
In definitiva, abbiamo ottenuto la fattorizzazione
$
  hat(L)_3 hat(L)_2 hat(L)_1 P A = U
$
In generale, per $n$ generico, la (1) si può riscrivere con gli stessi procedimenti come:
$
  hat(L)_(n-1) hat(L)_(n-2) dot dots dot hat(L)_(1) P A = U quad quad (2)
$
dove:
- $hat(L)_(n-1) = L_(n-1)$
- $hat(L)_(i) = P_(n-1) dot dots dot P_(i+1) L_i P_(i+1) dot dots dot P_(n-1) quad i=1,...,n-2$
- $P=P_(n-1)dot dots dot P_(1)$

#observation()[
  $hat(L)_(n-1) hat(L)_(n-2) dot dots dot hat(L)_(1)$ è equivalente a $L^(-1)$ se $hat(L)_i$ ha struttura analoga a $L_i$.
]

Vediamo la struttura di $hat(L)_i$:
$
  hat(L)_i &= (P_(n-1) dot dots dot P_(i+1))(I- uu(g)_i uu(e)_i^T)(P_(i+1)dot dots dot P_(n-1))\
  & = (P_(n-1) dot dots dot P_(i+1))I(P_(i+1)dot dots dot P_(n-1)) - (P_(n-1) dot dots dot P_(i+1))(uu(g)_i uu(e)_i^T)(P_(i+1)dot dots dot P_(n-1))\
  &= I -(P_(n-1) dot dots dot P_(i+1) uu(g)_i)+ (uu(e)_i^T P_(i+1) dot dots dot P_(n-1))\
  & = I -(P_(n-1) dot dots dot P_(i+1) uu(g)_i)+underbrace((uu(e)_i^T P_(i+1)), =uu(e)_i^T) dot (P_(i+2) dot dots dot P_(n-1)) = I - hat(uu(g))_i uu(e)_i^T
$
dove:
$
  hat(uu(g))_i & = P_(n-1) dot dots dot P_(i+1) uu(g)_i \
               & =(P_(n-1) dot dots dot P_(i+2)) P_(i+1) uu(g)_i \
               & =frac(1, a_(k_i i)^((i))) (underbrace(0 dots 0, i), *, *, dots *)^T
$
Pertanto, $L_i$ e $hat(L)_i$ hanno la medesima struttura di matrice elementare di Gauss (la i-esima per la precisione). In virtù di questo, possiamo formalmente riscrivere la (2) come:
$
  L^(-1) P A = U, quad "con" space & L^(-1) = hat(L)_(n-1) dot dots dot hat(L)_1 \
                                   & P=P_(n-1) dot dots dot P_1
$
Osservando che $P$ è una matrice di permutazione (quindi ortogonale), abbiamo di conseguenza dimostrato il seguente risultato.

#theorem()[
  Se $A in RR^(n times n)$, $det(A) eq.not 0$, allora $exists P in RR^(n times n)$, matrice di permutazione, tale che:
  $
    P A = L U quad (3)
  $
]
#definition()[
  #index("Fattorizzazione", "con pivoting")
  La (3) definisce la fattorizzazione LU con *pivoting* di $A$.
]

#observation()[
  Se dobbiamo risolvere il sistema lineare
  $
    A uu(x) = uu(b) quad quad (4)
  $
  e se (3) è la fattorizzazione LU con pivoting di $A$, allora, formalmente, (4) è equivalente al sistema lineare
  $
    P A uu(x) = P uu(b)
  $
  da cui otteniamo che, essendo $P A = L U$
  $
    L U uu(x) = P uu(b)
  $
  Allora risolviamo, in ordine, i sistemi triangolari
  $
    (5) quad quad L uu(y) = P uu(b) quad "e" quad U uu(x) = uu(y)
  $
  #observation()[
    Nella (5) il vettore $P uu(b)$ è un vettore contenente una permutazione degli elementi di $uu(b)$ e quindi sarà sufficiente memorizzare il vettore $uu(p)$ che corrisponde a tale permutazione. In altri termini:
    $
      P uu(b) <=> uu(b)(uu(p)) quad quad ("in Matlab")
    $
  ]
]

=== Costo computazionale della fattorizzazione
- *Occupazione di memoria*: come visto per la fattorizzazione LU, possiamo utilizzare gli elementi che si azzerano ai vari passi dell'algoritmo, per memorizzare gli elementi significativi dei vettori di Gauss. A quest'ultimi, vanno applicate le permutazioni definite nei passi successivi dell'algoritmo. Di conseguenza, alla fine, $A$ sarà sovrascritta, come nella LU, con gli elementi significativi dei fattori $L$ e $U$ (rispettivamente, la porzione strettamente triangolare inferiore e la porzione angolare superiore). Riguardo alla matrice di permutazione, si utilizza un vettore $p in RR^n$, se $n$ è la dimensione del problema, che è inizializzato con $(1, ..., n)^T$ e a cui si applicano le permutazioni elementari definite nell'algoritmo di fattorizzazione.
- *Operazioni algebriche elementari*: queste rimangono le stesse dell'algoritmo classico. A queste vanno aggiunte:
  $
    sum_(i=1)^(n-1) (k-i) = sum_(i=1)^(n-1) i = approx n^2 / 2 " confronti per il calcolo del pivot."
  $
  Tuttavia questi sono trascurabili rispetto alle $approx 2/3 n^3$ `flops` delle operazioni elementari.

  #observation()[
    Va considerato che, negli $n-1$ passi di fattorizzazione, al generico passo $i$, vanno scambiate le righe $i$ e $k_i$ della matrice. Questi scambi in memoria hanno ovviamente un costo.
  ]

Scriviamo uno pseudocodice Matlab che implementa la fattorizzazione. In esso $a$ è un array $n times n$ che contiene la matrice $A$.
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
  header: [*Algoritmo 3.?* Fattorizzazione con pivoting],
)
```matlab
n = size(a,1);
p = 1:n;
for i = 1:n-1
  % --- 1. RICERCA DEL PIVOT ---
  % mi=valore, ki=indice relativo
  [mi, ki] = max(abs(a(i:n,i)));
  if mi == 0
    error('matrice singolare');
  end
  % --- 2. AGGIORNAMENTO INDICI E SCAMBIO RIGHE ---
  % Lo convertiamo in indice assoluto della matrice (da i a n). Vedi nota.
  ki = ki + i - 1;
  % Se il pivot migliore non è già sulla diagonale facciamo lo scambio.
  if ki > i
      % Scambia le righe fisiche nella matrice A (parte numerica)
      % Scambia la riga corrente 'i' con la riga del pivot 'ki'. Vedi nota.
      a([i ki], :) = a([ki i], :);
      % Registra lo stesso scambio nel vettore p
      p([i ki]) = p([ki i]);
  end
  % --- 3. CALCOLO DEI MOLTIPLICATORI (Parte L) ---
  % Calcola i moltiplicatori di Gauss per la colonna corrente.
  a(i+1:n, i) = a(i+1:n, i) / a(i,i);
  % --- 4. AGGIORNAMENTO SOTTOMATRICE (Parte U) ---
  % Sottrae il prodotto colonna * riga: A_new = A_old - L * U
  a(i+1:n, i+1:n) = a(i+1:n, i+1:n) - a(i+1:n, i) * a(i, i+1:n);
end
if a(n,n) == 0
    error('matrice singolare');
end
```
#observation(multiple: true)[
  - La conversione in indice assoluta è necessaria perché `max(abs(a(i:n,i)))` restituisce l'indice all'interno di un vettore più piccolo. Se $i=3$ e $n=5$, allora `max` opera su un vettore di dimensione $5-3=2$.
  - Questa scrittura così compressa serve "semplicemente" per evitare di dichiarare una variabile di scambio. In questo modo è gestito tutto dal linguaggio. Stiamo chiedendo, in una sola riga, di fare ciò che richiederebbe 3 righe e una variabile aggiuntiva.
    ```matlab
    temp = a(i, :);      % Salva la riga i
    a(i, :) = a(ki, :);  % Copia la riga ki sulla riga i
    a(ki, :) = temp;     % Copia la temp sulla riga ki```
]

//26.11.2025
== Condizionamento del problema
Prima di cercare un algoritmo per risolvere un problema (come un sistema lineare $A uu(x)=uu(b)$), dobbiamo chiederci se il problema stesso è "ben posto". Il concetto di *condizionamento* misura la sensibilità della soluzione di un problema rispetto ai dati in ingresso.
In altre parole:"Se i dati del problema ($A$ o $b$) cambiano di pochissimo (a causa di errori di misurazione o di arrotondamento), la soluzione $x$ cambia di poco o cambia drasticamente?"
- *Problema Ben Condizionato*: piccole variazioni nei dati producono piccole variazioni nella soluzione. Il problema è stabile e "robusto".
- *Problema Mal Condizionato*: piccole variazioni nei dati possono provocare enormi variazioni nella soluzione. Il risultato diventa inaffidabile, indipendentemente da quanto sia preciso l'algoritmo usato.

L'esempio seguente mostra un caso patologico in cui la matrice ha una struttura tale da amplificare mostruosamente ogni minimo errore iniziale.
#example()[
  $
    A=mat(
      1, , , , , ;
      alpha, 1, , , , ;
      , alpha, dots.down, , , ;
      , , dots.down, dots.down, , ;
      , , , alpha, 1, ;
      , , , , alpha, 1;
    ) in RR^(10 times 10), quad uu(b) = beta mat(1; 1+alpha; 1+alpha; dots.v; dots.v; 1+alpha) in RR^10\
    => A uu(x) = uu(b) => uu(x) = mat(beta; dots.v; dots.v; beta) in RR^10
  $
  <esempio_mat>
  Scriviamo una funzione:
  #codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: false,
  )
  ```matlab
  function x=bidia(alfa, beta)
    x = beta * ones(10, 1); %x = vettore di 10 beta
    x(2:10)=x(2:10)+beta * alfa; % x_i = beta + beta * alfa = beta (1+alfa)
    for i=2:10
      x(i)=x(i)-alfa*x(i-1); % risoluzione per sostituzione in avanti
    end
    return
  ```
  Questa funzione è equivalente a risolvere il precedente sistema $A uu(x) = uu(b)$
  - Invocare `bidia(100,1)` restituisce tutti 1.
  - Invocare `bidia(100,2)` restituisce tutti 2.
  - Invocando la funzione con 1.1 o $pi$ restituisce numeri vicini al valore passato ma che si discostano sempre di più fino a quando non hanno più niente in comune.
  All'aumentare di $alpha$ ogni piccolo errore di arrotondamento introdotto nel passaggio precedente viene amplificato per $alpha$ nel passaggio successivo. L'ultimo elemento del vettore sarà molto diverso da $beta$.
]
Che cosa è successo? Il motivo di quanto osservato è spiegato dall'analisi del *condizionamento del problema*. Ovvero, se invece del problema esatto
$
  A uu(x) = uu(b), quad quad det(A)eq.not 0
$
risolviamo quello perturbato
$
  (A + Delta A) (uu(x) + Delta uu(x)) = uu(b) + Delta uu(b)
$
dove:
+ $A in RR^(n times n) => Delta A in RR^(n times n)$, contenente le perturbazioni degli elementi di $A$.
+ $uu(b) in RR^n => Delta uu(b) in RR^n$, contenente le perturbazioni degli elementi di $uu(b)$.
+ $uu(x) in RR^n => Delta uu(x) in RR^n$, contenente le perturbazioni degli elementi di $uu(x)$.

Vogliamo quantificare come $Delta A$ e $Delta uu(b)$ (che sono le perturbazioni sui dati in ingresso del problema) influenzano $Delta uu(x)$, che è la perturbazione del risultato.
Per questo motivo è necessario introdurre la nozione di *norma indotta su matrice*.

=== Norme indotte
#definition("Norma di un vettore")[
  #index("Norma", "di vettore")
  Sia $norm(dot) : V --> RR$, con $V$ spazio vettoriale. Diremo che $norm(dot)$ è una norma su $V$ se:
  + $forall uu(v) in V: norm(uu(v)) gt.eq 0 and norm(uu(v)) = 0 => uu(v) = uu(0) in V$
  + $forall uu(v) in V$ e $alpha in RR : norm(alpha dot uu(v)) = abs(alpha) dot norm(uu(v))$
  + $forall uu(x), uu(y) in V: norm(uu(x) + uu(y)) lt.eq norm(uu(x)) + norm(uu(y))$ (disuguaglianza triangolare)
]
Nel caso in cui $V = RR^n$, la classe di norme più utilizzata è:
$
  uu(v) = (v_1,..., v_n)^T, quad norm(uu(v))_p = root(p, sum_(i=1)^n abs(v_i)^p), quad p gt.eq 1
$
I valori di $p$ più utilizzati sono:
$
  #index("Norma", "Manhattan")
  p&=1: norm(uu(v))_1 = sum_(i=1)^n abs(v_i) quad "(norma Manhattan)"\
  #index("Norma", "Euclidea")
  p&=2: norm(uu(v))_2 = sqrt(sum_(i=1)^n abs(v_i)^2) = sqrt(uu(v)^T uu(v)) quad "(norma euclidea)"\
  #index("Norma", "del massimo")
  p&=infinity: norm(uu(v))_infinity = lim_(p -> infinity) norm(uu(v))_p equiv max_(i=1,..,n) abs(v_i) quad "(norma del massimo)"
$

#example()[
  Dato il vettore $uu(v)$ definito come $uu(v) = mat(-7, 2, 4)$ si ha che:
  $
           norm(uu(v))_1 & = 7+2+4 = 14 \
           norm(uu(v))_2 & = sqrt(49 + 4 +16) = sqrt(69) \
    norm(uu(v))_infinity & = 7
  $
]
#observation()[
  La function `norm` di Matlab implementa una generica norma $p$:
  - `norm(v)` è la norma Euclidea (default);
  - `norm(v, 1)` è la norma 1;
  - `norm(v, inf)` è la norma $infinity$;
]

Nel caso in cui $V = RR^(m times n)$, possiamo definire *norme su matrici* , *indotte dalle corrispondenti norme su vettore*.

#definition("Norme su matrici")[
  #index("Norma", "su matrice")
  Se $A in RR^(m times n)$ definiamo:
  $
    norm(A)_p = sup_(uu(x) in RR^n\ uu(x)eq.not uu(0)) frac(overbracket(norm(A uu(x))_p, "norma" p "in" RR^m), underbracket(norm(uu(x))_p, "norma" p "in" RR^n))
  $
  come la norma $p$ su matrice, indotta dalla corrispondente norma $p$ su vettore.
]
Vediamo delle formulazioni equivalenti alla precedente. In particolare, osserviamo che il vettore:
$
  uu(v) = frac(uu(x), norm(uu(x))_p)\
  norm(uu(v))_p = norm(frac(uu(x), norm(uu(x))))_p = frac(1, norm(uu(x))_p) dot norm(uu(x))_p = 1 quad quad ("seconda proprietà delle norme")
$
Pertanto:
$
  norm(A)_p & = sup_(norm(uu(x))_p > 0) frac(norm(A uu(x))_p, norm(uu(x)_p)) \
            & = sup_(norm(uu(x))_p > 0) norm(A dot frac(uu(x), norm(uu(x))_p))_p \
            & =sup_(norm(uu(v))_p = 1) norm(A dot uu(v))_p = max_(norm(uu(v))_p = 1) norm(A dot uu(v))_p
$

La trasformazione da $sup$ a $max$ deriva dal fatto che stiamo operando sull'insieme di tutti i vettori con norma 1 ovvero un insieme chiuso e limitato. In un insieme tale, l'operatore $sup$ coincide con l'operatore $max$.

#example()[
  Se $A=mat(
    a_(11), dots.c, a_(1 n);
    dots.v, , dots.v; a_(m 1), dots.c, a_(m n); delim: "["
  ) in RR^(m times n)$, allora:
  - $norm(A)_1 & = max_(j=1,...,n) sum_(i=1)^m abs(a_(i j))$: si sommano i valori assoluti di ogni colonna e si prende il massimo.

  - $norm(A)_infinity & = max_(i=1,...,m) sum_(i=1)^n abs(a_(i j))$: si sommando i valori assoluti di ogni riga e si prende il massimo.
]
#observation(multiple: true)[
  - $norm(A)_1 = norm(A^T)_infinity$
    #example()[
      $A=mat(1, -2, 3; -4, 5, 6) => cases(norm(A)_1 = 9, norm(A)_infinity = 15)$
    ]

  - In Matlab:
    - `norm(A, 1)` ritorna la norma 1 di $A$.
    - `norm(A, inf)` ritorna la norma $infinity$ di $A$.

  - Se $A in RR^(m times n)$, allora:
    - $A^T A in RR^(n times n)$
    - $A A^T in RR^(m times m)$
    sono quadrate.
]

Il calcolo della norma 2 di una matrice risulta essere il più complicato.
#set math.cases(gap: 2em)
$
  norm(A)_2 = sqrt(rho(A^T A)) = sqrt(rho(A A^T)) quad quad cases(rho(A^T A) = max_(lambda in sigma(A^T A)) abs(lambda) "raggio spettrale di" A^T A, rho(A A^T) = attach(max, b: mu in sigma(A A^T)) abs(mu) "raggio spettrale di" A A^T)
$
#set math.cases(gap: 0.2em)

Ricordiamo che con $sigma$ si indica l'insieme degli autovalori e che $rho$ (il raggio spettrale) rappresenta il massimo autovalore in modulo.


#observation(multiple: true)[
  + `norm(A)` ritorna la norma 2 di A.
  + Se $A in RR^(n times n)$, $A$ ortogonale, allora:
    $
      A^T A = A A^T = I space (A^(-1)=A^T)\
      norm(A)_2 = sqrt(rho(I)) = 1
    $
  + Si può dimostrare che , $forall A in RR^(m times n)$:
    $
      norm(A)_2 lt.eq sqrt(norm(A)_1 dot norm(A)_infinity)
    $
  *NB*: E' *necessario* conoscere le $norm(dot)_1, norm(dot)_2, norm(dot)_infinity$ su vettore e matrice.
]

=== Compatibilità tra norma indotta su matrice e corrisp. norma su vettore
Per brevità, in seguito, verrà omesso il pedice $p$ della norma, sottointendendo che sia sempre lo stesso.
Si ottiene che per $uu(x) eq.not uu(0)$:
$
  norm(A uu(x)) = norm(A frac(uu(x), norm(uu(x)))) dot norm(uu(x)) lt.eq (sup_(norm(uu(v))=1) norm(A uu(v))) dot norm(uu(x)) = norm(A) dot norm(uu(x))
$
Ovvero abbiamo concluso che:
$
  norm(A uu(x)) lt.eq norm(A) dot norm(uu(x)) quad ("compatibilità della norma")
$
In modo analogo si dimostra che, se $A in R^(m times n), B in RR^(n times k)$:
$
  norm(A dot B) lt.eq norm(A) dot norm(B)
$
//TODO: da dimostrare / finire A CASA (certo
#observation()[
  + Se $A in RR^(n times n), forall norm(dot)$ norma indotta su matrice, vale: $rho(A) lt.eq norm(A)$
  + $forall norm(dot)$ norma indotta su matrice, vale:
    $
      norm(I) = max_(norm(uu(v))=1) norm(I uu(v)) = max_(norm(uu(v))=1) norm(uu(v)) = 1
    $
  + Dalla 2. segue che, se $A in RR^(n times n)$, $det(A)eq.not 0$:
    $
      norm(A) dot norm(A^(-1)) gt.eq norm(A dot A^(-1)) = norm(I) =1
    $
]

Ritorniamo a discutere il problema perturbato (2). A questo fine, supponiamo che:
$
  Delta A = epsilon F, quad "con" epsilon in RR, F in RR^(n times n)
$
e, similmente supponiamo che:
$
  Delta uu(b)= epsilon uu(f), quad "con" uu(f) in RR^n
$
Definiamo quindi:
$
      A(epsilon) & = A + epsilon F => A(0) = A \
  uu(b)(epsilon) & =uu(b) + epsilon uu(f) => uu(b)(0) = uu(b)
$
e, inoltre, indichiamo con $uu(x)(epsilon)$ la soluzione del sistema lineare:
$
  A(epsilon) = uu(x)(epsilon) = uu(b)(epsilon) <=> (2) quad quad (3)
$
Inoltre, da questo segue che:
+ $uu(x)(0) = uu(x)$, soluzione di (1);
+ Per $epsilon approx 0$:
  $
    uu(x)(epsilon) = uu(x)(0) + epsilon accent(uu(x), dot)(0) + O(epsilon^2) approx uu(x) + underbracket(epsilon accent(uu(x), dot)(0)) \
    epsilon uu(x)(0) => Delta uu(x) = uu(x)(epsilon) - uu(x) approx epsilon dot accent(uu(x), dot)(0)
  $

Andiamo ad ottenere $accent(uu(x), dot)(0)$. Poiché la (3) vale identicamente in un intorno di $epsilon=0$, questo significa che anche le derivate prime dei 2 membri devono essere uguali:
$
  underbrace(accent(A, dot)(epsilon), F) uu(x)(epsilon) + A(epsilon) accent(uu(x), dot)(epsilon) = underbrace(accent(uu(b), dot)(epsilon), uu(f))
$
e, calcolando in $epsilon=0$, otteniamo:
$
  F underbrace(uu(x)(0), uu(x)) + underbrace(A(0), A) accent(uu(x), dot)(0) = uu(f)
$
da cui:
$
  F uu(x) + A accent(uu(x), dot)(0) = uu(f)
$
e moltiplicando membro a membro per $epsilon$:
$
  underbrace(epsilon F, =Delta A) uu(x) + A underbrace((epsilon accent(uu(x), dot)(0)), =Delta uu(x)) = underbrace((epsilon uu(f)), = Delta uu(b))
$
ovvero:
$
  Delta A uu(x) + A Delta uu(x) = Delta uu(b)
$
Da questo vogliamo ricavare una misura scalare (alias un numero) che quantifica ciascuna perturbazione, al fine di ottenere una relazione più compatta tra loro. Dalla (3) otteniamo che:
$
  Delta uu(x) = A^(-1) ( Delta b - Delta A dot uu(x))
$
Passando alle norme ($norm(dot)$ rappresenta una qualsiasi norma su vettore e la corrispondente norma indotta su matrice), otteniamo che:
$
  norm(Delta uu(x)) & = norm(A^(-1) (Delta uu(b) - Delta A dot uu(x))) \
  & lt.eq norm(A^(-1)) dot norm(Delta uu(b) - Delta A dot uu(x)) space space "(vedi prop. norme)" \
  & lt.eq norm(A^(-1)) dot (norm(Delta uu(b)) + norm(Delta A dot uu(x)))\
  & lt.eq norm(A^(-1)) dot (norm(Delta uu(b)) + norm(Delta A) dot norm(uu(x))) \
  & = norm(A) dot norm(A^(-1)) dot (frac(norm(Delta uu(b)), norm(A)) + frac(norm(Delta A), norm(A)) dot norm(uu(x)))
$
Dividendo per $norm(uu(x))$ si ha:
$
  frac(norm(Delta uu(x)), norm(uu(x))) lt.eq norm(A) dot norm(A^(-1)) (frac(norm(Delta uu(b)), norm(A)dot norm(uu(x))) + frac(norm(Delta A), norm(A)))
$
A questo punto, osserviamo che :
$
  uu(b) = A uu(x) => norm(uu(b)) = norm(A uu(x)) lt.eq norm(A) dot norm(uu(x)) => frac(1, norm(uu(b))) gt.eq frac(1, norm(A) dot norm(uu(x)))
$
Pertanto, possiamo maggiorare:
$
  frac(norm(Delta uu(b)), norm(A)dot norm(uu(x)))lt.eq frac(norm(Delta uu(b)), norm(uu(b)))
$
In conclusione, otteniamo quindi che:
$
  frac(norm(Delta uu(x)), norm(uu(x))) lt.eq norm(A) dot norm(A^(-1)) (frac(norm(Delta uu(b)), norm(uu(b))) + frac(norm(Delta A), norm(A))) quad quad (4)
$
In questa diseguaglianza:
- $frac(norm(Delta uu(x)), norm(uu(x)))$: può essere assimilato ad una sorta di *errore relativo* sul risultato.

- $frac(norm(Delta uu(b)), norm(uu(b)))$: può essere assimilato ad un "errore relativo" sul termine noto.

- $frac(norm(Delta A), norm(A))$: è una sorta di "errore relativo" sulla matrice dei coefficienti.

Da quanto esposto, la quantità:
$
  k(A) = norm(A) dot norm(A^(-1))
$
definisce il numero di condizione del problema.
#definition()[
  #index("Matrice", "Numero di condizione")
  $k(A)$ si dice *numero di condizione* della matrice A. Se:
  - $k(A) >> 1$: diremo che $A$ è *mal condizionata*.
  - $k(A) =O(1)$ (costante di moderata entità): diremo che $A$ è *ben condizionata*.
]
#observation(multiple: true)[
  + $k(A)=norm(A) dot norm(A^(-1)) gt.eq norm(A dot A^(-1)) = norm(I) = 1$, per ogni norma indotta su matrice.
  + Se $A$ è ortogonale, allora:
    $
      A^T = A^(-1) quad and quad norm(A)_2 = 1
    $
    Pertanto:
    $
      k_2(A) = norm(A)_2 dot norm(A^(-1))_2 = norm(A)_2 dot norm(A^T)_2 = 1
    $
    Una matrice ortogonale è sempre *ben condizionata*.
]
Alla luce di questa analisi, rivediamo gli esempi precedenti.
Nell'esempio all'inizio di questo capitolo si vede facilmente che utilizzando $norm(dot)_1 " o " norm(dot)_infinity$ si ha che $k(A)approx 10^20$.
Osserviamo che, se utilizziamo un'aritmetica finita con precisione di macchina $u$, allora:
$
  frac(norm(Delta uu(b)), norm(uu(b))), frac(norm(Delta A), norm(A)) gt.eq u
$
Se $k(A)approx u^(-1)$ allora il secondo membro di (4) può arrivare a 1, il che significa che abbiamo una totale perdita di informazione.
#observation()[
  Nel caso di sistemi molto mal condizionati, la soluzione del sistema lineare va ricercata in altre forme.
]

Vediamo come utilizzare le norme su matrice per ottenere una implementazione più efficiente della fattorizzazione LU con pivoting. Ricordiamo che , se $a in RR^(n times n)$ allora possiamo scrivere uno pseudocodice, che la implementa, come segue:
```matlab
p=1:n;
for i=1:n
  [mi, ki]=max(abs(a(i:n,i)));
  if mi==0, error('a singolare'), end
  ki = ki + i-1;
  if ki > i
    p([i,ki]) = p([ki, i]);
    a([i,ki], :) = a([ki,i],:);
  end
  a(i+1:n, i)=a(i+1:n, i) / a(i,i);
  a(i+1:n,i+1:n) = a(i+1:n,i+1:n) - a(i+1:n,i) * a(i,i+1:n);
end
```
Fermo restando il resto, vogliamo implementare un controllo più rubusto, per diagnosticare la "singolarità" della matrice, rispetto al controllo `if mi==0` che è decisamente "ingenuo". Un primo rimedio, potrebbe essere un controllo del tipo `if mi <= tol` con `tol` tolleranza da specificare. Per capire come scegliere `tol`, consideriamo il seguente esempio:
$
  mat(10, 1; 1, 10) mat(x_1; x_2) = mat(1, 1; 1, 1) quad quad (5)
$
in cui:
+ la matrice è diagonale dominante e quindi fattorizzabile LU.
+ la soluzione è $x_1=x_2=1$.
Se `eps` è la precisione di macchina, sembrerebbe ragionevole il controllo `if mi <= eps,...`. Tuttavia, se moltiplichiamo membro a membro, la (5) per `eps/10^4`, otteniamo che la matrice viene diagnosticata come singolare ma, non di meno, la matrice dei coefficienti rimane sempre diagonale dominante e la soluzione $x_1=x_2=1$. Pertanto la soluzione corretta al problema può essere quella di scegliere
#align(center, [`tol = 100*eps*norm(a,1)`])
- 100 è un multiplo scalare della precisione di macchina (può dipendere anche dalla dimensione $n$ del problema).
- usare una norma poco costosa come $1$ o $infinity$ *non* $norm(dot)_2$.

//03.12.2025
#observation()[
  In Matlab la function `cond` calcola il numero di condizione di una matrice.
  - `cond(A)` $-> k(A)$ in norma 2.
  - `cond(A,1)` $-> k(A)$ in norma 1
]

== Sistemi lineari sovradeterminati
Il problema è risolvere
$
  A uu(x) = uu(b) quad quad (1)
$
con $A in RR^(m times n)$,  $m>n="rank"(A) => uu(b) in RR^m, uu(x) in RR^n$, ovvero ci sono più equazioni che incognite.
#observation()[
  Nella (1) $A$ e $uu(b)$ sono i dati del problema, mentre $uu(x)$ è la soluzione da determinare. Tuttavia nelle applicazioni del deep-learning, i ruoli si capovolgono. Ad esempio, in una rete del tipo
  //TODO: rifare diagramma rete
  #figure(image("images/2025-12-03-13-15-10.png"))
  tipicamente, se $x_1 in RR^(n_1)$ è il vettore degli input e $x_N in RR^(n_N)$ è il vettore con gli output, allora la rete si può formalizzare come:
  $
    x_(i+1) = sigma(A_i x_i + b_i), space i=1,...,N
  $
  dove $A_i in RR^(n_(i+1) times n_i), space b_i in RR^(n_(i+1))$ e $sigma$ la funzione di attivazione. "Allenare" una rete consiste nel determinare le matrici $A_i$ ed i vettori $b_i$.
]
Dobbiamo, innanzitutto, capire cosa si intenda per soluzione del problema. Infatti $A uu(x)$ denota, al variare di $uu(x)$, vettori che si possono ottenere come combinazione lineare delle colonne di $A$, ovvero quelli appartenenti al `range(A)`. La dimensione di questo spazio vettoriale è, in questo caso, $n$. Invece $uu(b) in RR^m$ e nel nostro caso $m>n$.
//TODO: ^^ qui va spiegato meglio ^^
#example()[
  Se
  $
    A=mat(1, 0; 1, 1; 1, 0; delim: "[") ==> "range"(A) = mat(x_1; x_1+x_2; x_1; delim: "["), space x_1, x_2 in RR
  $
  ma, per esempio, $uu(b) = mat(1; 2; 3; delim: "[") in.not "range"(A)$.
]
La conclusione di questo argomento è che una soluzione, nel senso classico, generalmente non esiste. L'idea è la seguente: dato $uu(x) in RR^n$ posso definire il *vettore residuo* #index("Vettore residuo")
$
  uu(r) = A uu(x) - uu(b)
$
Chiaramente, se fosse $uu(r) = uu(0) in RR^m$, allora questo significa che
$
  uu(0) = A uu(x) - uu(b) ==> A uu(x) = uu(b)
$
Quindi, se $uu(r) = uu(0) <=> uu(x)$ è soluzione classica del problema. Viceversa, se non possiamo ottenere $uu(r) = uu(0)$, allora ricerchiamo $uu(x)$:
$
  norm(uu(r))_2^2 = norm(A uu(x)-uu(b))_2^2 = min! quad quad (2)
$
#observation()[
  $
    uu(r) = mat(r_1; r_2; dots.v; r_m) => norm(uu(r))_2^2 = sum_(i=1)^m r_i^2 = uu(r)^T uu(r)
  $
]
Per questo motivo la soluzione $uu(x)$ che soddisfa la (2), prende il nome di *soluzione ai minimi quadrati* del sistema lineare $A uu(x) = uu(b)$.

Prima di procedere con la determinazione di $uu(x)$, osserviamo che se $Q in RR^(m times m)$ è una matrice ortogonale ($Q^T Q = Q Q^T = I in RR^(m times m)$), allora:
$
  norm(Q uu(r))_2^2 = (Q uu(r))^T (Q uu(r)) = uu(r)^T underbracket(Q^T Q, I) uu(r) = uu(r)^T uu(r) = norm(uu(r))_2^2
$
Di conseguenza, la norma euclidea di un vettore è invariata per sua moltiplicazione per una matrice ortogonale.

Vale, inoltre, il seguente risultato.
#theorem("Fattorizzazione QR di A")[
  #index("Fattorizzazione", "QR")
  Se $A in RR^(m times n), m>n="rank"(A)$, allora esistono:
  + $Q in RR^(m times m)$, ortogonale;
  + $hat(R) in RR^(n times n)$, triangolare superiore e non singolare;
  tali che:
  $
    A = Q R, space "con" R=mat(hat(R); 0; delim: "[") = mat(
      r_(11), r_(12), dots.c, r_(1n);
      0, r_(22), dots.c, r_(2n);
      dots.v, dots.v, dots.down, dots.v;
      0, 0, dots.c, r_(n n);
      0, 0, dots.c, 0;
      dots.v, dots.v, dots.c, dots.v;
      0, 0, dots.c, 0; augment: #(hline: 4), delim: "["
    ) in RR^(m times n)
  $
]
Utilizzando questo risultato, possiamo dimostrare il seguente corollario.

//Possibile domanda esonero
#corollary()[
  Se $A in RR^(m times n), m>n="rank"(A)$, allora la soluzione ai minimi quadrati del sistema lineare $A uu(x) = uu(b)$, esiste ed è unica.
]
#proof()[
  Vogliamo determinare $uu(x)$ in modo da minimizzare:
  $
    norm(uu(r))_2^2 & = norm(A uu(x)-uu(b))_2^2 \
    & = norm(Q R uu(x) - uu(b))_2^2 \
    & = norm(Q(R uu(x)-Q^T uu(b)))_2^2 \
    & = norm(R uu(x) - Q^T uu(b))_2^2 quad ("definiamo" uu(g) = Q^T uu(b)) quad (a) \
    & = norm(R uu(x) - uu(g))_2^2 \
    & = norm(mat(hat(R); 0; delim: "[") uu(x) - mat(uu(g)_1; uu(g)_2; delim: "["))_2^2 \
    & = norm(mat(hat(R) uu(x) -uu(g)_1; - uu(g)_2; delim: "["))_2^2\
    & = mat(hat(R) uu(x) -uu(g)_1; - uu(g)_2; delim: "[")^T mat(hat(R) uu(x) -uu(g)_1; - uu(g)_2; delim: "[")\
    & = (hat(R) uu(x) -uu(g)_1)^T (hat(R) uu(x) - uu(g)_1) + uu(g)_2^T uu(g)_2 \
    &= norm(hat(R) uu(x) - uu(g)_1)_2^2 + norm(uu(g)_2)_2^2\
    & =norm(uu(g)_2)_2^2 = min! quad quad (b)
  $
  se $hat(R) uu(x) - uu(g)_1 = uu(0)$, ovvero, se $uu(x)$ è soluzione del sistema lineare $hat(R) uu(x) = uu(g)_1 quad (c)$.

  Poiché $hat(R)$ è triangolare superiore e non singolare, allora la soluzione di questo sistema lineare esiste ed è unica. Inoltre, si calcola facilmente essendo superiore triangolare.
]
#observation(multiple: true)[
  + Per calcolare $uu(x)$, è sufficiente conoscere il fattore $hat(R)$ e poter fare il prodotto $Q^T uu(b)$, per calcolare $uu(g)$ ((a)).
  + Una volta calcolato $uu(x)$ dalla (c), per calcolare la norma di
    $
      uu(r) = A uu(x) - uu(b)
    $
    non è necessario calcolare il residuo stesso. Infatti, abbiamo visto che
    $
      norm(uu(r))_2 = norm(uu(g)_2)_2
    $
    e il vettore $uu(g)$ (e quindi anche $uu(g)_2$) lo abbiamo già calcolato per ottenere $uu(x)$.
]
=== Esistenza della fattorizzazione QR
Prima di vedere la dimostrazione del teorema precedente, consideriamo il seguente problema: dato un vettore $uu(x) in RR^n, uu(x)eq.not uu(0),$ vogliamo determinare una matrice ortogonale $H in RR^(n times n)$, detta *matrice di Householder*, tale che:
$
  (4) quad H uu(x) = alpha uu(e)_1, quad "dove" alpha in RR space "e" space uu(e)_1 in RR^n "è il primo versore"
$
Osserviamo che, per l'ortogonalità di $H$ si ha:
$
  norm(H uu(x))_2^2 = norm(uu(x))_2^2 = norm(alpha uu(e)_1)_2^2 = alpha^2 uu(e)_1^T uu(e)_1 = alpha^2
$
segue che:
$
  alpha = plus.minus norm(uu(x))_2
$
Consideriamo adesso una matrice $H$ nella seguente forma:
$
  H = I - frac(2, uu(v)^T uu(v)) uu(v) uu(v)^T quad "con" uu(v) in RR^n "da determinare"
$
Osserviamo che:
+ La matrice $H$ è simmetrica per costruzione.
+ La matrice $H$ è ortogonale:
  $
    H^T H = overbrace(H dot H, "simmetria") = (I-frac(2, uu(v)^T uu(v)) uu(v) uu(v)^T)(I-frac(2, uu(v)^T uu(v)) uu(v) uu(v)^T) = I - frac(4, uu(v)^T uu(v)) uu(v) uu(v)^T + frac(4, (uu(v)^T uu(v))^cancel(2)) uu(v) cancel((uu(v)^T uu(v))) uu(v)^T = I
  $
  Quindi, qualunque sia la scelta di $uu(v)$, la matrice $H$ è simmetrica e ortogonale. Il problema è scegliere $uu(v)$ in modo che la (4) sia soddisfatta.

Verifichiamo che questo è vero se scegliamo il *vettore di Householder* come:
$
  uu(v) = uu(x) - alpha uu(e)_1 quad quad (5)
$
Infatti
$
  H uu(x) &= (I-frac(2, uu(v)^T uu(v)) uu(v) uu(v)^T) uu(x) = uu(x) frac(2, uu(v)^T uu(v)) uu(v)^T uu(x) uu(v)\
  &= uu(x) frac(2, uu(v)^T uu(v)) uu(v)^T uu(x) (uu(x)-alpha uu(e)_1)\
  &= (1- frac(2, uu(v)^T uu(v)) uu(v)^T uu(x))uu(x) + alpha(frac(2, uu(v)^T uu(v)) uu(v)^T uu(x))uu(e)_1 = alpha uu(e)_1
$
se $frac(2, uu(v)^T uu(v)) uu(v)^T uu(x)=1$ ovvero, se $2 uu(v)^T uu(x) = uu(v)^T uu(v)$. Infatti:
$
  2uu(v)^T uu(x) & = 2(uu(x)-alpha uu(e)_1)^T uu(x) \
                 & = 2 uu(x)^T uu(x) - 2 alpha (uu(e)_1^T uu(x)) \
                 & = 2 norm(uu(x))_2^2 - 2 alpha underbrace(x_1, 1^a "comp di" uu(x)) = 2 alpha^2 -2 alpha x_1 \
   uu(v)^T uu(v) & =(uu(x)-alpha uu(e)_1)^T (uu(x)-alpha uu(e)_1) \
                 & = underbrace(uu(x)^T uu(x), =alpha^2) + alpha^2 - 2 alpha underbrace(uu(e)_1^T uu(x), =alpha) \
                 & = 2 alpha^2 - 2 alpha x_1
$
Riguardo al segno di $alpha$ (attenzione), osserviamo che:
$
  uu(v) = uu(x) - alpha uu(e)_1 = mat(x_1-alpha; x_2; dots.v; x_n)
$

//09.12.2025
Quindi $alpha$ viene sottratto a $x_1$. Per ottenere un'operazione ben condizionata, $x_1$ e $-alpha$ devono essere concordi e quindi il segno di $alpha$ è opposto a quello di $x_1$. Questa scelta del segno ha anche la conseguenza di ottenere che la prima componente del vettore $uu(v)$ sia sempre diversa da zero. In effetti otteniamo che $uu(v)_1 = x_1 - alpha$ è la componente di massimo modulo del vettore $uu(v)$.

//TODO: dimostrazione per esercizio^^^

Ciò permette di ottimizzare lo spazio di memoria per memorizzare $uu(v)$. Per capire meglio, vediamo qual'è la matrice di Householder definita dal vettore $beta dot uu(v)$, con $beta eq.not 0$ e un qualunque scalare. Se definiamo $hat(uu(v))=beta dot uu(v)$, avremo:
$
  I - frac(2, hat(uu(v))^T hat(uu(v))) hat(uu(v)) hat(uu(v))^T = I- frac(2, beta^2 uu(v)^T uu(v)) beta^2 uu(v) uu(v)^T equiv H
$
Possiamo quindi concludere che:
+ l'informazione per ottenere $H$ si riduce all'informazione relativa a $uu(v)$;
+ l'informazione relativa a $uu(v)$ è la stessa che il vettore $hat(uu(v)) = frac(uu(v), v_1)$, la cui prima componente è 1 e, pertanto, può non essere memorizzata esplicitamente. Quindi, l'informazione di $H in RR^(n times n)$, si riduce ad un vettore di lunghezza $n-1$, ovvero le componenti di $uu(hat(v))$ dalla seconda in poi.

Possiamo dimostrare che la fattorizzazione $Q R$ esiste. La dimostrazione è costruttiva e definisce il corrispondente algoritmo di fattorizzazione (*algoritmo di Householder*). Analogamente a quanto visto per la fattorizzazione $L U$, si tratta di un metodo semi-iterativo che, in $n$ passi, ottiene la fattorizzazione (ovvero diagnostica che $A$ non ha rango massimo). La matrice al passo $k$ sarà denotata da:
$
  A^((k)) = (a_(i j)^((l))) in RR^(m times n), quad 0 lt.eq l lt.eq k
$
con l'indice superiore di ogni elemento che denota qual'è stato l'ultimo passo dell'algoritmo in cui esso è stato modificato.

#proof()[
  Si parte con la matrice:
  $
    (1) quad quad A= mat(
      a_(11)^((0)), a_(12)^((0)), a_(13)^((0)), dots, dots, a_(1)^((0));
      a_(21)^((0)), a_(22)^((0)), a_(23)^((0)), dots, dots, a_(2n)^((0));
      a_(31)^((0)), a_(32)^((0)), a_(33)^((0)), dots, dots, a_(3n)^((0));
      dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;
      a_(m 1)^((0)), a_(m 2)^((0)), a_(m 3)^((0)), dots, dots, a_(m n)^((0))
    ) equiv A^((0))
  $
  Il procedimento si articola in $n$ passi elementari: all'i-esimo passo, $i=1,...,n$, la colonna i-esima della matrice corrente viene trasformata nella i-esima colonna di una matrice triangolare superiore. Questo, utilizzando opportune varianti delle matrici elementari di Householder. Al passo 1, possiamo definire una matrice elementare di Householder, $H_1 in RR^(m times m)$, tale che:
  $
    H_1 dot mat(a_(11)^((0)); a_(21)^((0)); dots.v; dots.v; a_(m 1)^((0)); delim: "[") = mat(a_(11)^((1)); 0; dots.v; dots.v; 0; delim: "[")
  $
  con $a_(11)^((1)) eq.not 0$, se la prima colonna è non nulla (infatti, a meno del segno, $a_(11)^((1))$ ne è la norma euclidea). Pertanto dalla (1) si ottiene:
  $
    (2) quad quad H_1 A= mat(
      a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1)^((1));
      0, a_(22)^((1)), a_(23)^((1)), dots, dots, a_(2n)^((1));
      0, a_(32)^((1)), a_(33)^((1)), dots, dots, a_(3n)^((1));
      dots.v, dots.v, dots.v, dots.v, dots.v, dots.v; dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;
      0, a_(m 2)^((1)), a_(m 3)^((1)), dots, dots, a_(m n)^((1))
    ) equiv A^((1))
  $
  #observation()[
    Le $m-1$ componenti in colonna $1$ che sono state azzerate, possono essere utilizzate per memorizzare le ultime $m-1$ componenti del vettore di Householder, normalizzato in modo da avere prima componente uguale a $1$.
  ]
  Reiteriamo la procedura sulla sottomatrice $(m-1) times (n-1)$, data dalla porzione di $A^((1))$ dalla riga $2$ alla $m$ e colonne dalla $2$ alla $n$.
  A questo punto, possiamo definire la matrice elementare di Householder, $H^((2)) in RR^(m-1 times ,m-1)$, tale che:
  $
    H^((2)) dot mat(a_(22)^((1)); a_(32)^((1)); dots.v; dots.v; a_(m 2)^((1)); delim: "[")
    = mat(a_(22)^((2)); 0; dots.v; dots.v; 0; delim: "[")
  $
  #observation()[
    $a_(22)^((2)) eq.not 0$, altrimenti $A$ non ha rango massimo.
  ]
  Definiamo adesso:
  $
    H_2 = mat(
      #table(
        stroke: none,
        align: center + horizon,
        columns: (2.5em, 2.5em),
        table.cell([$1$]),
        table.cell([$emptyset$], stroke: (left: 1pt, bottom: 1pt)),
        table.cell([$emptyset$], stroke: (right: 1pt, top: 1pt)),
        table.cell([$H^((2))$]),
      ), delim: "["
    ) in RR^(m times m)
  $
  #observation()[
    Osserviamo che:
    + $H_2 = H_2^T$
    + $H_2^T H_2 = H_2^2 = I in RR^(m times m)$, ovvero, $H_2$ è, al pari di $H^((2))$, *simmetrica e ortogonale*.
  ]
  Dalla (2) otteniamo che:
  $
    H_2 H_1 A= mat(
      a_(11)^((1)), a_(12)^((1)), a_(13)^((1)), dots, dots, a_(1)^((1));
      0, a_(22)^((2)), a_(23)^((2)), dots, dots, a_(2n)^((2));
      0, 0, dots.v, dots.v, dots.v, dots.v;
      dots.v, dots.v, dots.v, dots.v, dots.v, dots.v;
      0, 0, a_(m 3)^((2)), dots, dots, a_(m n)^((2))
    ) equiv A^((2))
  $
  #observation()[
    Anche adesso, la porzione di elementi azzerati in colonna 2 ($m-2$) possono essere utilizzati per memorizzare gli elementi significativi del vettore di Householder normalizzato che definisce $H^((2))$.
  ]
  Procedendo in modo analogo, sarà possibile definire matrici come:

  $
    H_i = mat(
      #table(
        stroke: none,
        align: center + horizon,
        columns: (2.5em, 2.5em),
        table.cell([$I_(i-1)$]),
        table.cell([$emptyset$], stroke: (left: 1pt, bottom: 1pt)),
        table.cell([$emptyset$], stroke: (right: 1pt, top: 1pt)),
        table.cell([$H^((i))$]),
      ), delim: "["
    ) quad i=1,...,n
  $
  con $I_(i-1) in RR^(i-1 times i-1)$ matrice identità e $H^((i))$ matrice elementare di Householder, $H^((i)) in RR^(m-i+1 times m-i+1)$, tale che, in colonna $i$, al passo i-esimo:
  $
    H^((i)) dot mat(a_(i i)^((i-1)); dots.v; dots.v; a_(m i)^((i-1)); delim: "[")
    = mat(a_(i i)^((i)); 0; dots.v; dots.v; 0; delim: "[") in RR^(m-i+1)
  $
  ottenendo, infine:
  $
    //TODO: rifare meglio la matrice in modo che sia tutto allineato se possibile
    underbrace(H_n dot H_(n-1) dot ... dot H_1, equiv Q^T) A = mat(
      a_(11)^((1)), dots, dots, dots, a_(1n)^((1));
      0, a_(22)^((2)), dots, dots, a_(2n)^((2));
      dots.v, 0, a_(33)^((3)), , dots.v, ;
      dots.v, dots.v, 0, dots.down, dots.v;
      dots.v, dots.v, dots.v, dots.down, a_(n n)^((n));
      dots.v, dots.v, dots.v, dots.v, 0;
      dots.v, dots.v, dots.v, dots.v, dots.v;
      0, dots.c, dots.c, dots.c, 0;
    ) equiv A^((n)) equiv R
  $
  Nella parte sottostante alla diagonale degli elementi $a_(i i)$ possiamo memorizzare gli elementi significativi dei vettori di Householder normalizzati. Da quest'ultimo passo si ottiene, formalmente, che $A=Q R$.

]
#observation(multiple: true)[
  + La procedura si vede essere definita se e solo se $a_(i i)^((i)) eq.not 0, space forall i=1,...,n$. Se qualcuno di questi fosse nullo, allora $A$ non avrebbe rango massimo.
  + Non è richiesto assemblare la matrice $Q$, ma solo di calcolare, per ottenere la soluzione ai minimi quadrati, il prodotto $Q^T uu(b)$.
]
L'ultima osservazione si ottiene andando ad inizializzare
$
  uu(x) <-- uu(b)
$
e, successivamente:
$
  uu(x) <-- H_i uu(x), space i=1,...,n quad quad (3)
$
Infatti, questo è equivalente a:
$
  H_n dot H_(n-1) dot ... dot H_2 dot H_1 dot uu(x)
$
senza assemblare il prodotto indipendentemente:
$
  H_n dot ... dot H_1 "(DA NON FARE)"
$
Inoltre, nella (3), osserviamo che:
- $
    H_i uu(x) = mat(
      #table(
        stroke: none,
        align: center + horizon,
        columns: (2.5em, 2.5em),
        table.cell([$I_(i-1)$]),
        table.cell([$emptyset$], stroke: (left: 1pt, bottom: 1pt)),
        table.cell([$emptyset$], stroke: (right: 1pt, top: 1pt)),
        table.cell([$H^((i))$]),
      ), delim: "["
    ) mat(
      #table(
        stroke: none,
        align: center + horizon,
        columns: 2.5em,
        table.cell([$x_1$]),
        table.cell([$x_2$], stroke: (top: 1pt)),
      ), delim: "["
    ) =
    mat(
      #table(
        stroke: none,
        align: center + horizon,
        columns: 2.5em,
        table.cell([$x_1$]),
        table.cell([$H^((i))x_2$], stroke: (top: 1pt)),
      ), delim: "["
    ), " con " x_1 in RR^(i-1), space x_2 in RR^(m-i+1)
  $
- Se $H^((i)) = I_(m-i+1) - overbrace(frac(2, hat(uu(v)_i)^T hat(uu(v)_i)), = beta_i) hat(uu(v)_i) hat(uu(v)_i)^T$ con $hat(uu(v))_i$ il vettore di Householder normalizzato, allora:
  $
    H^((i)) uu(x)_2 & = (I_(m-i+1) - beta_i hat(uu(v))_i hat(uu(v))_i^T) uu(x_2) \
                    & = x_2 - beta_i hat(uu(v))_i (hat(uu(v))_i^T uu(x)_2) \
                    & = x_2 - hat(uu(v))_i ( beta_i dot (hat(uu(v))_i^T uu(x_2)))
  $
  con un costo *lineare* invece che *quadratico*.

=== Il metodo di Householder
Tutto questo, può essere riassunto nel seguente pseudocodice che sovrascrive $A in RR^(m times n)$ con l'informazione dei fattori $Q$ e $R$ (porzione significativa dei vettori di Householder normalizzati e porzione triangolare di $R$).

//TODO: rivedere e testare questo codice (sul libro è diverso dalle dispense)
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
  header: [*Algoritmo 3.8* Fattorizzazione QR di Householder],
)
```matlab
for i=1:n
  alfa = norm(A(i:m,i));
  if alfa==0, error('A non ha rango max'), end
  if A(i,i)>=0, alfa = -alfa; end
  v1=A(i,i)=-alfa;
  A(i,i)=alfa;
  A(i+1:m,i)=A(i+1:m,i)/v1;
  beta = -v1/alfa;
  A(i:m, i+1:n) = A(i:m, i+1:n) - (beta * [1; A(i+1:m,i)]) * ([1; A(i+1:m,i)'] * A(i:m, i+1:n));
```

//10.12.2025
Se:
$
  hat(uu(v)) = frac(uu(v), v_1) = frac(uu(x)-alpha uu(e)_1, underbrace(x_1-alpha, =v_1)) quad quad alpha^2 = norm(uu(x))_2^2 = uu(x)^T uu(x)
$
allora:
$
  beta &= frac(2, hat(uu(v))^T hat(uu(v))) = frac(2 v_1^2, uu(v)^T uu(v)) = frac(2(x_1-alpha)^2, (uu(x)-alpha uu(e)_1)^T (uu(x) - alpha uu(e)_1)) \
  &= frac(2(x_1-alpha)^2, underbrace(uu(x)^T uu(x), =alpha^2) - underbrace(2 alpha x_1, =uu(e)_1^T uu(x)) + alpha^2) = frac(2(x_1-alpha)^2, 2 alpha^2 - 2 alpha x_1) \
  &= frac(cancel(2)(x_1-alpha)^2, cancel(2) alpha (alpha-x_1)) = - frac((x_1 - alpha)^cancel(2), cancel((x_1 - alpha))alpha) = -frac(x_1-alpha, alpha) equiv -frac(v_1, alpha)
$
come vediamo nella riga 8 dell'Algoritmo 3.8.
//TODO: ci sono altri passaggi nelle dispense da ricontrollare
Questi accorgimenti consentono di ottenere un costo, in termini di operazionni algebriche elementari, di $2/3 n^2 (3m-n)$ `flops`.
#observation()[
  Si potrebbe utilizzare la fattorizzazione $Q R$ anche nel caso $A in RR^(n times n)$, che sarebbe definita sotto l'ipotesi che $A$ sia non singolare, ovvero nel caso $m=n$. Tuttavia, in questo caso, il costo per ottenere la fattorizzazione sarebbe $4/3 n^3$ `flops` cioè circa il doppio rispetto alla fattorizzazione $L U$. Pertanto quest'ultima è in generale da preferirsi.
]

== Cenni sulla risoluzione di sistemi non lineari

#definition()[
  Un sistema di equazioni *non lineari* è un insieme di due o più equazioni in cui le incognite non compaiono tutte come termini di primo grado (lineari). Affinché un sistema sia definito *"non lineare"*, basta che anche una sola delle equazioni contenga termini non lineari.
]
#example()[
  Il sistema seguente non è lineare:
  $
    cases(x^2+y^2=25, x+y=7)
  $
  Dal punto di vista geometrico, esso coincide con il problema di trovare le intersezioni tra una circonferenza e una retta (0,1 o 2 soluzioni).
]


Ricordiamo che, nel caso scalare, $f(x)=0$, con $f: RR -->RR$, abbiamo esaminato, tra gli altri, il metodo di Newton:
$
  x_(i+1) = x_i - frac(f(x_i), f'(x_i)), space i=0,1,... quad quad (1)
$
ed il metodo delle corde:
$
  x_(i+1) = x_i - frac(f(x_i), f'(x_0)), space i=0,1,... quad quad (2)
$
entrambi con convergenza locale e con ordine di convergenza, verso *radici semplici*, pari a:
- 2 per il metodo (1).
- 1 per il metodo (2).
#observation()[
  Se $x^*$ è radice semplice di $f(x)$, allora $f(x^*)=0$ e $f'(x^*) eq.not 0$.
]
Per generalizzare il metodo di Newton al caso di sistemi, riscriviamo formalmente (1) come:
$
  x_(i+1) = x_i - f'(x_i)^(-1) f(x_i), space i=0,1,... quad quad (3)
$
Questo perché la divisione non è applicabile alle matrici ma esistono le matrici inverse. Supponiamo ora di voler risolvere il sistema di $n$ equazioni non lineari nelle $n$ incognite
$
  uu(x) = mat(x_1; dots.v; x_n) in RR^n quad F(uu(x))=uu(0) in RR^n quad quad (4)
$
dove $F: RR^n --> RR^n$ (_campi vettoriali_). In questo caso, definendo le *funzioni componenti* di $F(uu(x))$:
$
  f_i : RR^n --> RR
$
allora possiamo riscrivere (4) come:
$
  cases(f_1(uu(x))=0, f_2(uu(x))=0, quad space space dots.v, f_n(uu(x))=0) quad quad (5)
$
#observation()[
  Se $uu(e)_i in RR^n$ è l'i-esimo versore, allora $f_i (uu(x))=uu(e)_i^T F(uu(x)), space i=1,...,n$.
]
Gli apici adesso verrano usati al posto dei pedici per evitare confusione nei passaggi. Anche ora, dato $uu(x)^0 in RR^n$, possiamo considerare un'approssimazione lineare al primo ordine di $F(uu(x))$ in un intorno di $uu(x)^0$ tramite Taylor:
$
  F(uu(x)) approx F(uu(x)^0) + F'(uu(x)^0)(uu(x)-uu(x)^0) quad quad (6)
$
dove $F'(uu(x)^0)$ è la *matrice Jacobiana* di $F(uu(x))$ calcolata in $uu(x)^0$. Questa è così definita: $F'(uu(x)) in RR^(n times n)$, il cui elemento $(i, j)$ è dato dalla derivata parziale di $f_i (uu(x))$ rispetto alla componente $x_j$ del vettore. Questa è a sua volta definita se $uu(e)_j in RR^n$ è il j-esimo versore, allora:
$
  frac(partial, partial x_j) f_i (uu(x)) quad quad frac(partial, partial x_j) f_i (uu(x)) = lim_(epsilon->0) frac(f_i (uu(x) + epsilon uu(e)_j) - f(uu(x)), epsilon)
$
Piuttosto che risolvere il sistema complesso $F(uu(x)^0)=0$, cerchiamo di determinare quando si azzera l'approssimazione appena trovata imponendola pari a zero:
$
       F(uu(x)^0) + F'(uu(x)^0)(uu(x)-uu(x)^0) & = uu(0) \
                    F'(uu(x)^0)(uu(x)-uu(x)^0) & = - F(uu(x)^0) \
  (F'(uu(x)^0))^(-1)F'(uu(x)^0)(uu(x)-uu(x)^0) & = - (F'(uu(x)^0))^(-1)F(uu(x)^0) \
                                         uu(x) & = uu(x)^0 - (F'(uu(x)^0))^(-1) F(uu(x)^0)
$
Reiterando il procedimento, si ottiene il metodo di Newton:
$
  uu(x)^(i+1) = uu(x)^i - (F'(uu(x)^i))^(-1) F(uu(x)^i), space i=0,1,... quad quad (7)
$

#example()[
  Se $F: RR^2 --> RR^2$ è definita come:
  $
    F(uu(x)) = cases(cos(x_1)+e^(x_2), sin(x_1)+7 x_2^2) quad uu(x) = mat(x_1; x_2)
  $
  allora:
  $
    F'(uu(x)) = J = mat(
      #table(
        stroke: none,
        align: horizon + center,
        columns: (5em, 5em),
        table.cell([$-sin(x_1)$], stroke: (right: 1pt, bottom: 1pt)),
        table.cell([$e^(x_2)$]),
        table.cell([$cos(x_1)$]),
        table.cell([$14x_2$], stroke: (left: 1pt, top: 1pt)),
      )
    )
  $
]
Invece che calcolare l'inversa della matrice Jacobiana (operazione costosissima), l'iterazione (7) può essere equivalentemente formulata come:
$
       uu(x)^(i+1) -uu(x)^i & = - (F'(uu(x)^i))^(-1) F(uu(x)^i) \
              Delta uu(x)^i & = - (F'(uu(x)^i))^(-1) F(uu(x)^i) \
  F'(uu(x)^i) Delta uu(x)^i & = F'(uu(x)^i) [- (F'(uu(x)^i))^(-1) F(uu(x)^i)] \
  F'(uu(x)^i) Delta uu(x)^i & = -I F(uu(x)^i) \
  F'(uu(x)^i) Delta uu(x)^i & = -F(uu(x)^i) ==> uu(x)^(i+1)=uu(x)^i+Delta uu(x)^i
$
Il costo computazionale per iterazione, consisterà in:
+ Calcolo di $F(uu(x)^i)$ e $F'(uu(x)^i)$, la seconda è più costosta.
+ Fattorizzazione di $F'(uu(x)^i)$ ($approx 2/3 n^3$ `flops`).
+ Risoluzione del sistema lineare ($approx 2 n^2$ `flops`).
+ Aggiornamento approssimazione ($n$ `flops`).

Al fine di ridurre il costo relativo al calcolo e alla fattorizzazione della Jacobiana, è possibile utilizzare la versione vettoriale del metodo delle corde, in cui:
- Risolvi: $F'(uu(x)^0) Delta uu(x)^i=-F(uu(x)^i)$
- Aggiorna: $uu(x)^(i+1)=uu(x)^i+ Delta uu(x)^i, space i=0,1,...$

Pertanto la matrice Jacobiana si *calcola* e si *fattorizza solo una volta*. Per questo motivo, sebbene questa iterazione converga più lentamente di quella di Newton, ha un costo globale generalmente inferiore.

#[
  #set heading(numbering: none, outlined: false)
  === Criterio di arresto
]
Come ogni procedimento iterativo, sia il metodo di Newton, che quello delle corde, o Newton semplificato, necessita di un idoneo criterio di arresto. Nel precedente caso, un criterio molto utilizzato è il seguente:
$
  norm(Delta uu(x) .\/ (1+abs(uu(x))))_infinity
$
dove:
- `./` rappresenta, in Matlab, l'operazione di divisione elemento per elemento sulla destra.
- $abs(uu(x))$ rappresenta il vettore con i valori assoluti dell'approssimazione corrente.