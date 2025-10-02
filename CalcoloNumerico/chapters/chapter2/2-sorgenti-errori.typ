#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2" as cetz: canvas, draw

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

// Lezione del 30/09/2025
= Standard IEEE-754

Base binaria (b = 2).\
Viene utilizzata una rappresentazione con arrotondamento "#text(red)[*round to even*]", ovvero, l'ultima cifra della mantissa rappresentata dalla funzione $f l$ è 0. Tuttavia, la maggiorazione dell'errore relativo di rappresentazione continua a valere.\
Viene implementato un *gradual underflow*.\
Pertanto, essendo la base binaria, la mantissa di un numero *normalizzato* sarà del tipo:
$
  1.bold(f), quad quad "con " f " la parte frazionaria"
$
Similmente, la mantissa di un numero *denormalizzato* sarà del tipo:
$
  0.bold(f), quad quad "con " f " la parte frazionaria"
$
Questi argomenti ci dicono che, sapendo se il numero è normalizzato o meno, non ne abbiamo bisogno di memorizzare la sua parte intera, ma è sufficiente memorizzare la sola *frazione $f$*, risparmiando quindi 1 bit.
Lo standard prevede due tipi di numeri reali:
- Singola precisione: 32 bit
- Doppia precisione: 64 bit

== Singola precisione

In questo caso vengono allocati un totale di 4 byte (o 32 bit ripartiti nel seguente modo):
- 1 bit per il segno dell mantissa;
- 8 bit per l'esponente (s = 8);
- 23 bit per la frazione $f$ (m = 24).
$
  #let colors = (yellow, gray, black, green)
  #let tiles
  #for value in (1, 8, 23) {
    //rect(width: 3.125% * value, height: 20pt, fill: colors.at(calc.rem-euclid(value, 4)).transparentize(75%), stroke: black)
    //rect(width: 3.125% * value, height: 20pt, fill: tiling(size: auto)[
    //#place(line(start: (3.125% * value, 0pt), end: (3.125% * value, 20pt)))
    //], stroke: black)
  }
$
Da questo segue che la precisione di macchina (singola precisione IEEE-754) vale:
$
  u=1/2b^(1-m)=1/2 dot 2^(1-24)= 2^(-23) approx 10^(-7.5)
$
Il che vuole dire che lavoriamo con circa 7 cifre decimali significative.\
Vediamo riguardo all'esponente. Con 8 cifre binarie, si possono rappresentare tutti gl interi in ${0, 1, dots, 255}$. Pertanto, $0 <= e <= 255$. In particolare, se:

- Se $0 < e < 255$, allora il numero è *normalizzato* e lo *shift* vale $nu=123$;
- Se $e=f=0$, allora abbiamo la rappresentazione dello *0*;
- Se $e=0 and f eq.not 0$, allora il numero è *denormalizzato* e lo *shift* vale $nu=122$.

#pagebreak()

#observation()[
  La variazione di shift, quando is denormalizza, si spiega osservando che il più piccolo numero denormalizzato (positivo) è:
  $
    1.0dots 0 dot 2^(1-123)=2^(-122)
  $
  Invece, il più grande numero denormalizzato (positivo) è:
  $
    1.1dots 1 dot 2^(1-123)=2^(-122)
  $
  Pertanto, i due numeri sono *contigui*.
]

Se $e=255$ e $f=0$, allora abbiamo:
$
  + space infinity, "se " alpha_0=0\
  - space infinity, "se " alpha_0=1
$
Se $e=255$ e $f eq.not 0$, allora abbiamo: NaN (Not a Number).\
Questo è, ad esempio, originato da forme indeterminate del tipo:
- $infinity - infinity$
- $0 dot infinity$
- $infinity / infinity$
- $0/0$

== Doppia precisione

In quesoto caso vengono utilizzati 8 byte (64 bit) per rappresentare un numero in doppia precisione. Questi sono così ripartiti:
- 1 bit per il segno della mantissa $space space$ (grigio);
- 11 bit per l'esponente (2 = 11 ------ giallo);
- 52 bit per la frazione $f$ (m = 53 --- verde).

$
  #let colors = (green, gray, black, yellow)
  #for value in (1, 11, 52) {
    rect(width: 1.5625% * value, height: 20pt, fill: colors.at(calc.rem-euclid(value, 4)).transparentize(75%), stroke: black)
  }
$

#observation()[
  In questo caso la precisione di macchina vale: $u=1/2b^(1-m)=1/2 dot 2^(1-53) = 2^(-53) approx 10^(-16)$\
  Il che vuole dire che lavoriamo con circa 16 cifre decimali significative.\
  Da quanto esposto, $e in {0, 1, dots, 2047}$.
]

In modo sostanzialmente analogoal caso della singola precisione, si ha che:
- Se $0< e < 2047$, allora il numero è normalizzto e lo shift vale $nu=1023$.
- Se $e=f=0$, allora abbiamo la rappresentazione dello *0*;
- Se $e=0 and f eq.not 0$, allora il numero è *denormalizzato* e lo *shift* vale $nu=1022$.

Se $e=2047$ e $f=0$, allora abbiamo:
$
  + space infinity, "se " alpha_0=0\
  - space infinity, "se " alpha_0=1
$
Se $e=2047$ e $f eq.not 0$, allora abbiamo: NaN (Not a Number).\

#pagebreak()

= Aritmetica finita

Se esguiamo operazioni algebrice $(+, -, *, \/) in.rev plus.circle$, allora:
$
  forall x, y in RR: quad x plus.circle y quad = quad f l(f l (x) plus.circle f l(y))
$
Questo implica che, di norma, le proprietà algebriche delle operazioni (associatività, distributività, etc...) non valgono più.

= Conversione fra tipi diversi

Siano $x$, $pi$ (3.141592653) e $y$ variabili rispettivamente in doppia precisione, in doppia precisione e in singola precisione:
$
  cases(
    x=pi,
    y=x
  )
$
allora $y$ conterrà $pi$ con la massima accuratezza consentita alla singola precisione.
Viceversa:
$
  cases(
    y=pi,
    x=y
  )
$
allora $x$ conterrà $pi$ con l'accuratezza della singola precisione.
Inoltre:
- $x=1"E "308, quad quad quad x "dà " 9.99dots 9E space 308$
- $y=1"E "308, quad quad quad y "dà " infinity$

Talora è necessario convertire anche tra numeri di tipo reale e tipo intero.\
La conversione intero $-->$ reale, in genere, è innocua, a parte il fatto che in genere non si ha più un intero. Questo è dovuta dal fatto che il range di rappresentazione dei numeri interi è più ristretto di quello dei numeri reali ($cal(I)$).\
Il *viceversa non è vero*, perché $cal(I)$ è generalmente molto più ampio dell'insieme di rappresentabilità del tipo intero.\
Nel caso del filmato di Ariane V, il problema è stato originato dalla assegnazione di una variabile in doppia precisionee, legata alla componente tangenziale della velocità, ad una variabile intera di 2 byte. Quindi, se il numero è maggiore di 32767, si ha un errore.

= Condizionamento di un problema

Supponiamo di voler calcolare la soluzione di un problema che, formalmente, poniamo essere descritto da:
$
  y=f(x)
$
dove:
- $x$ contiene i dati in ingresso;
- $y$ contiene il risultato atteso;
- $f$ contiene la descrizione formale del problema

Assumiamo inoltre che $x,y in RR " e " f:RR ->RR$.

//TODO: Finire grafico
$
  #canvas({
    import draw: arc, circle, content
    let dark-blue = rgb("#4040d9")
    let arrow-style = (
      mark: (end: "stealth", fill: dark-blue, scale: .5),
      stroke: (paint: dark-blue, thickness: 0.75pt),
    )

    content((-1.75, 1.5), $X$)
    circle((0, 0), radius: 2)
    circle((8, 0), radius: 2)
    content((9.75, 1.5), $Y$)
    content((0, 0.5), $x$, name: "x")
    content((0, -0.5), $tilde(x)$, name: "xt")
    content((8.0, 0.5), $y$, name: "y")
    content((8.0, -0.5), $tilde(y)$, name: "yt")

    arc((rel: (1, 0.2), to: "x"), radius: 0.85 * 4, start: 145deg, stop: 40deg, ..arrow-style, name: "momentum-arrow")
    content("momentum-arrow.mid", text(fill: dark-blue)[$f$], anchor: "south")
  })
$

In generale, al posto di *x*, avremo un dato perturbato *$tilde(x)$* e, se usiamo un calcolatore, per via dell'utilizzo dell'aritmetica finita, avremo una funzione perturbata, *$tilde(f)$*, invece di *f*. Questo fornirà un risultato perturbato:
$
  tilde(y)=tilde(f)(tilde(x))
$

#observation()[
  Tuttavia, analizzare la differenza tra il risultato fornito dalla precedente, rispetto alla iniziale, è in generale complesso. Pertanto, ci limiteremo a studiare il problema, assai più semplice, $tilde(y)=f(tilde(x))$
]
Ovvero, studiamo le amplificazioni di perturbazionisui dati in ingresso, utilizzando un'*aritmetica esatta*. Lo studio della differenza tra il risultato fornito da (3), invece che dalla (1), costituisce l'*analisi del conzionamento del problema* (1). Se $y eq.not 0$, l'analisi è più efficace se fatta rispetto agli errori relativi.\
Pertanto, porremo
$
  tilde(y)=y(1+epsilon_y), quad "con "epsilon_y "l'errore relativo sul risultato"\
  tilde(x)=x(1+epsilon_x), quad "con "epsilon_x "l'errore relativo sul dato in ingresso"
$
e, supponendo *$epsilon_x approx 0$*, vogliamo stabilire in che modo *$epsilon_x$ si propaga su $epsilon_y$*.

Sostituendo le (4) nella (3), otteniamo che:
$
                      tilde(y)=underbracket((1+epsilon_y)) & =f(tilde(x))=f(x(1+epsilon_x)) \
                                     cancel(y)+y epsilon_x & = cancel(f(x))+f'(x)x epsilon_x+ O(epsilon_x^2) \
                                                           & =>epsilon_y approx f'(x)x/y epsilon_x \
  =>|epsilon_y| <=K dot |epsilon_x|, quad quad "con "K=bar & (f'(x))/y x bar "detto nunmero di condizione del problema"
$
Diremo, pertanto, che il problema (1) è:
- *ben condizionato*, se $K approx 1$;
- *mal condizionato*, se $K >> 1$;

#observation()[
  Se utilizziamo un'aritmetica finita con precisione di macchina $u$, allora avremo che $|epsilon_x|>=u ==> K approx u^(-1)$, allora non ho speranza id ottenere risultati con una qualche accuratezza, poiché $|epsilon_y| approx 1$
]

== Condizionamento delle operazioni algebriche elementari

=== Moltiplicazione
$
     & quad quad quad space y      && = x_1 dot x_2 quad quad "esatta, mentre perturbando" \
     & y(1+epsilon_y)              && =x_1(1+epsilon_1) dot x_2(1+epsilon_2) \
     & space space y+y epsilon_y   && =x_1 dot x_2(1+epsilon_1+epsilon_2+epsilon_1 dot epsilon_2) \
     &                             && approx x_1 dot x_2(1+epsilon_1 + epsilon_2) \
  => & quad space 1 + epsilon_y    && approx 1+epsilon_1+epsilon_2 \
  => & quad quad space |epsilon_y| && <= 2 max{|epsilon_1|, |epsilon_2|}
$
Concludiamo che la moltiplicazione è sempre *ben condizionato*, poiché il numero di conizionamento è 2.

=== Divisione
#observation()[
  Se $|gamma|<1 => Sigma_(i>=0) gamma^i = 1/(1-gamma)$\
  Pertanto $gamma -> - epsilon => 1/(1+epsilon)=Sigma_(i>=0) (-epsilon)^i = 1 - epsilon+O(epsilon^2)$
]

$
     & y              && = x_1/x_2 quad quad "e la perturbazione" \
     & y(1+epsilon_y) && = (x_1(1+epsilon_1))/(x_2(1+epsilon_2)) = x_1/x_2 (1+epsilon_1)(1-epsilon_2 + O(epsilon_2^2)) \
     &                && approx x_1/x_2(1+epsilon_1-epsilon_2) \
  => & 1+epsilon_y    && approx 1+epsilon_1-epsilon_2=>|epsilon_y|<=2 max{|epsilon_1|, |epsilon_2|}
$
Anche la divisione è *ben condizionata* (quindi è al pari della moltiplicazione), avendo numero di condizione 2.

=== Somma algebrica

$
  & y                                && = x_1+x_2 quad quad "che, perturbato, dà" \
  & y(1+epsilon_y)                   && =x_1(1+epsilon_1)+x_2(1+epsilon_2) \
  & cancel(y)+y epsilon_y            && =cancel(x_1+x_2)+x_1epsilon_1+x_2epsilon_2 \
  & "Divideno membro a membro per "y && =x_1+x_2 "otteniamo:" \
  & epsilon_y                        && = (x_1epsilon_1x_2epsilon_2)/(x_1+x_2) \
  & "da cui:" \
  & |epsilon_y|                      && <= (|x_1|+|x_2|)/(|x_1+x_2|) dot max{|epsilon_1|,|epsilon_2|}
$
Pertanto, il numero di condizione del problema è
$
  k=(|x_1|+|x_2|)/(|x_1+x_2|)
$
#pagebreak()
Quindi:
- se *$x_1 dot x_2 >0$ (addendi concordi)* => $|x_1+x_2|=|x_1|+|x_2| =>k=1$\ da cui si conclude che la *somma di numeri concordi* è *sempre ben condizionata*;
- se *$x_1 dot x_2 <0$ (addendi discordi)* => in questo caso il denominatore di k non è limitato superiormente e, quando $x_2 approx -x_1$, k può essere arbitrariamente grande. La somma di numeri discordi è, perciò, *mal condizionata*. Questo malcondizionamento si conretizza nel fenomeno della cosidetta *cancellazione numerica*, in cui anche avendo addendi completamente accurati, il risultato può essere del tutto inaccurato.

#example("Cancellazione numerica")[
  Come esempio di cancellazione numerica:
  $
    f'(x)=(f(x+epsilon)-f(x))/epsilon + & overbrace((epsilon), "err. di troncamento")
  $
  Ad esempio:
  $
    f(x)=x^10, quad quad x=1 => f'(1)=10
    //TODO: finire l'esempio quando carica il suo poema di pertanto (tabella con eps)
  $
]

