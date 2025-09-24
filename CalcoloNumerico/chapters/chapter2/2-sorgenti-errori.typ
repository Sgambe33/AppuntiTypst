#import "../../../dvd.typ": *

= Sorgenti di errore

Definiamo, in primis, opportune misure dell'errore. Supponiamo che $x in RR$ sia il dato esatto che approssimiamo con $limits(x)^tilde$. Definiamo l'*errore assoluto* ($Delta x$) la differenza:
$
  Delta x = limits(x)^tilde -x
$
Da cui segue che $limits(x)^tilde = x + Delta x$.

Questa misura non è completamente esaustiva perché per $Delta x = 10^(-6)$ non potremmo dire se è grande o piccolo se non rapportandolo a $x$. Per questo motivo, se $x eq.not 0$, definiamo l'*errore relativo*:
$$
Da questo segue che:
$
  limits(x)^tilde = x (1+ epsilon_x) space " e " space limits(x)^tilde/x = 1 + epsilon_x
$
da cui segue che $epsilon_x$ va confrontato con 1. Pertanto, se $abs(epsilon_x)=10^(-6)$, ciò significherebbe che il nostro errore è 1 parte su 1 milione. Pertanto l'informazione fornita dall'*errore relativo è più completa*.

Se $limits(x)^tilde$ è il risultato fornito da un metodo numerico definito per approssimare il dato esatto $x$ , l'errore commesso è determinato da più cause (sorgenti d'errore) intercalate tra loro. Ma, almeno concettualmente, queste sorgenti d'errore hanno origini distinte:
+ *Errori di troncamento*
+ *Errori di iterazione*
+ *Errori di round-off*

== Errori di troncamento

Se, ad esempio, il problema da risolvere è il calcolo della derivata di una funzione $f(x)$ in un punto $x$ assegnato. A questo fine sappiamo che:
$
  f'(x) = lim_(h arrow 0) frac(f(x+h)-f(x), h) approx frac(f(x+overline(h))-f(x), overline(h)) "   dove " overline(h) > 0 " è fisso"
$
In questo caso $f'(x) - frac(f(x+overline(h))-f(x), overline(h))$ è l'errore di troncamento connesso. Osserviamo che (usando gli sviluppi di Taylor):
$
  f(x+overline(h)) = f(x) + frac(overline(h), overline(h))f'(x) + frac(overline(h)^2, 2overline(h)) f''(x) + ... arrow.double frac(f(x+overline(h))-f(x), overline(h)) = o(h)
$

#observation()[L'errore di troncamento è determinato dalla sostituzione di un problema continuo con uno discreto che lo approssima.]

== Errori di iterazione

Determinati metodi numerici sono di *tipo iterativo*. Questo significa che sono definiti da una *funzione di iterazione*, $Phi(x)$, tale che, a partire da un'approssimazione iniziale $x_0 approx x$, viene prodotta una successione di approssimazioni mediante l'iterazione:
$
  x_(n+1) = Phi(x_n) space "con " n=0,1,2,...
$

#definition("Convergente")[
  Diremo che il metodo è *convergente* se:
  $
    lim_(n arrow infinity) x_n = x*
  $
]

Se il metodo è convergente, ad utilizziamo $x_n$, per un opportuno indice $n > 0$, come approssimazione di $x*$, la differenza $x*-x_n$ è l'*errore di iterazione*.

#observation()[
  L'errore di iterazione è legato all'utilizzo del metodo di base ($Phi(x)$)
]
#observation()[
  Praticamente sempre, l'indice $n$ a cui interrompiamo l'iterazione è determinato dinamicamente mediante un opportuno criterio di arresto.
]

#example("Metodo di Newton")[
  //TODO: Trascrivere esempio
]

== Errori di round-off

Questi errori sono dovuti all'utilizzo dell'*aritmetica finita* di un calcolatore. In particolare ci preoccuperemo degli errori di rappresentazione, che sono dovuti al fatto che i numeri non sono rappresentabili esattamente in macchina. In particolare considereremo i seguenti tipi di dati numerici:

- *Interi*
- *Reali*

=== Interi

Fissata un'opportuna bas di rappresentazione $b in NN$ (pari e spesso 2), un intero è rappresentato nella memoria di un calcolatore da una stringa del tipo:
$
  alpha_0 alpha_1 alpha_2 ... alpha_n "con " n " fissato" \
  alpha_0 in {+,-} \
  alpha_1 alpha_2 ... alpha_n in {0, 1, ..., b-1}
$

A questa stringa corrisponde l'intero:
$
  sum_(i=1)^n alpha_i b^(n-i), "  se" alpha_0 = + \
  sum_(i=1)^n alpha_i b^(n-i) - b^n, "  se" alpha_0 = -
$

=== Reali

Un numero "reale" è rappresentato in memoria da una stringa del tipo:
$
  alpha_0 alpha_1 ... alpha_m beta_1 ... beta_s space space space (1)
$
Fissata una base di rappresentazione $b in NN$, le cifre della stringa sono così definite:
$
  alpha_0 in {+,-} space space alpha_i, beta_i in {0,1...,b-1}, space i=1,...,m space j=1,...,s space "con" space alpha_1 eq.not 0\
  (2)
$
Con questa string si rappresenta il numero in notazione scientifica:
$
  r = plus.minus (sum_(i=1)^m alpha_i b^(1-i)) b^(e-nu) space space space (3)
$
$nu$ rappresenta lo "*shift*" che è fissato inizialmente e scelto in modo da poter rappresentare all'incirca lo stesso numero di esponenti positivi e negativi.
La stringa può essere suddivisa in due parti: la *mantissa* ($rho$) e l'*esponente*.
$
  rho = sum_(i=1)^m alpha_i b^(1-i) space space space e = sum_(j=1)^s beta_j b^(s-j) space space space (4)
$

Pertanto, poiché:
$
  0 lt.eq e lt.eq (b-1) sum_(j=1)^s b^(s-j) = b^(s-j)
$
(NON SICURO ^^^)
Ne consegue che, essendo $b^s >> 1$, allora $rho approx frac(b^s, 2) space (5)$.
Riguardo alla mantissa abbiamo che:
$
  1 lt.eq rho lt.eq (b-1) times overbrace((b-1) ... (b-1), m-1) = b(1-b^n) < b space space space (6)
$
#observation()[
  I numeri della forma (1-6) sono in numero finito.
]

#definition("umeri di macchina normalizzati")[
  I numeri della forma (1-6) costituiscono, assime allo $emptyset$, l'insieme dei *numeri di macchina normalizzati* $cal(M)$.
]

#observation()[
  Dalla scelta dello shift $nu$ (5), segue che $cal(M)$ contiene (segno a parte) praticamente lo stesso numero di numeri di macchina in [0,1] e (1, $+infinity$)
]

#observation()[
  Il più piccolo numero di macchina positivo è:
  $
    r_1 = b^(-nu)
  $
  Similmente, il più grande numero di macchina si ottiene quando ?????? con $i = 1,...,m$ e $beta_j = (b-1)$ con $j=1,...,s$. Così facendo si ottiene:
  $
    r_2 =(1-b^(-m)) b^(b^s - nu) approx b^(b^s -nu)
  $
]

Possiamo quindi concludere che:
$
  cal(M) subset [-r_2, -r_1] union {0} union [r_1, r_2] equiv cal(I)
$
L'insieme $cal(I)$ rappresenta il sottoinsieme dei numeri reali che possiamo sperare di rappresentare in macchina. E' necessario definire una funzione, che chiameremo *floating*:
$
  f l (x) : x in cal(I) -> limits(x)^tilde in cal(M)
$
Dove $limits(x)^tilde = f l(x)$ è il floating di $x$, che individua il numero di macchina che assiciamo a $x$.

#definition("Errore di rappresentazione")[
  Chiamiamo *errore di rappresentazione* la quantità $f l (x) - x$.
]

Vediamo come si implementa la fuzione $f l$. Per costruzione vale:
- $f l (0) = 0$. Più in generale se $x in cal(M)$, allora $f l (x) = x$.
- $x>0$ allora $f l(-x) = -f l(x)$
Pertanto è sufficiente dettagliare l'implementazione di $f l (x)$ quando $x>0$. Per questo esposto, se $x in cal(I)$, allora $x$ sarà della forma:
$
  x = (alpha_1 alpha_2 ... alpha_n alpha_(n+1) ... ) b^(e-nu)
$

A questo punto esistono 2 modi di implementare la funzione floating:
- *Troncamento* alla m-esima cifra:
#align(center, [
  $
    f l (x) = (alpha_1 alpha_2 ... alpha_m) b^(e-nu)
  $
])
- *Arrotondamento* alla m-esima cifra:
#align(center, [
  $
    f l (x) = (alpha_1 alpha_2 ... alpha_(m-1) limits(alpha_m)^tilde) b^(e-nu) \
    "dove " limits(alpha_m)^tilde = cases(
      alpha_m ", se " alpha_(m+1) < b/2,
      alpha_m + 1 ", se " alpha_(m+1) gt.eq b/2
    )
  $
])

Riguardo all'errore di rappresentazione vale i seguente risultato:
#theorem()[
  Per i numeri di $cal(I)$ positivi vale che l'errore relativo di rappresentazione:
  $
    epsilon_x = frac(abs(f l(x) - x), x) lt.eq u = cases(b^(1-m) ", troncamento", 1/2 b^(1-m) ", arrotondamento")
  $
]
#definition()[
  $u$ è detta *precisione di macchina dell'aritmetica finita*. _E' la maggiorazione uniforme dell'errore relativo di rappresentazione_.
]
#proof()[

  Per brevità. riportiamo la dimostrazione nel solo caso della rappresentazione con troncamento. Simili argomenti si applicano al caso della rappresentazione con arrotondamento. Siano:
  $
    x = (alpha_1 alpha_2 ... alpha_m alpha_(m+1) alpha_(m+2) ...) b^(e-nu) \
    f l (x) = (alpha_1 alpha_2 ... alpha_m) b^(e-nu)
  $
  Allora:
  $
    epsilon_x = frac(x- f l(x), x) = frac((alpha_1 alpha_2 ... alpha_m alpha_(m+1) alpha_(m+2) ... - alpha_1 alpha_2 ... alpha_m)b^(e-nu), (alpha_1 alpha_2 ...)b^(e-nu)) lt.eq \ lt.eq frac(0 overbrace(0 ... 0, m-1) alpha_(m+1) ..., 1) = (alpha_(m+1) alpha_(m+2) ...)b^(-m) lt.eq b^(1-m)
  $
]

#observation()[
  Pertanto concludiamo che la precisione di macchina di un'aritmetica finita è una maggiorazione uniforme dell'errore relativo di rappresentazione.
]
=== Overflow & Underflow

Che succede se $x>0$ ma $x>r_2$ oppure $0<x<r_1$?

Se $x>r_2$ sostanzialmente $f l (x) = +infinity$. Questo è "gestibile" entro certi limiti (es. $1/infinity = 0$). La condizione $x>r_2$ (o $x< -r_2$) è denominata *overflow*. La condizione $0<x<r_1$ è denominata *underflow*.
Per quest'ultimo sono previste 2 recovery:
- Store $emptyset$ in cui $f l(x) = 0$.
- Gradual underflow: in questo caso il numero di macchina viene *denormalizzato* permettendo ad $alpha_1$ si essere nullo. Chiaramente va a discapito dell'accuratezza di rappresentazione e il teorema precedente non vale più.

In conclusione, per la funzione $f l (x)$ vale che:
$
  f l (x) = cases(
    x ", se" x "è numero di macchina",
    -f l(x) ", se" x<0,
    "underflow, se" 0<abs(x)<r_1,
    "overflow, se" abs(x) > r_2
  )
$
