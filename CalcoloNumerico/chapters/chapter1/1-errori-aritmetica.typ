#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2" as cetz: canvas, draw
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/in-dexter:0.7.2": *
#show math.equation: set block(breakable: true)

#[
  #set heading(numbering: none)
  = Introduzione
]

Molti problemi che derivano dalle applicazioni sono descritti, in modo formale, da un modello matematico.
Una volta che le equazioni del modello sono risolte, è possibile fare inferenza sul fenomeno studiato. Per risolvere queste equazioni si ricorre spesso all'utilizzo di *metodi numerici*. Questi sono delle tecniche di *approssimazione* che devono soddisfare i seguenti requisiti:
+ *Accuratezza*: la soluzione approssimata deve essere "vicina" alla soluzione del problema. Questa dipende dalle *specifiche* del problema.
+ *Facilità di implementazione*: in quanto da codificare usando un opportuno linguaggio di programmazione


= Errori ed aritmetica finita

Definiamo, in primis, opportune misure dell'errore. Supponiamo che $x in RR$ sia il dato esatto che approssimiamo con $limits(x)^tilde$.#index("Errore", "assoluto") Definiamo l'*errore assoluto* ($Delta x$) la differenza:
$
  Delta x = limits(x)^tilde -x
$
Da cui segue che $limits(x)^tilde = x + Delta x$.

Questa misura non è completamente esaustiva perché per $Delta x = 10^(-6)$ non potremmo dire se è grande o piccolo se non rapportandolo a $x$. Per questo motivo, se $x eq.not 0$, #index("Errore", "relativo")definiamo l'*errore relativo*:
$
  limits(x)^tilde = x (1+ epsilon_x) space " e " space limits(x)^tilde/x = 1 + epsilon_x
$
da cui segue che $epsilon_x$ va confrontato con 1. Pertanto, se $abs(epsilon_x)=10^(-6)$, ciò significherebbe che il nostro errore è 1 parte su 1 milione. Pertanto l'informazione fornita dall'*errore relativo è più completa*.

Se $limits(x)^tilde$ è il risultato fornito da un metodo numerico definito per approssimare il dato esatto $x$, l'errore commesso è determinato da più cause (sorgenti d'errore) intercalate tra loro. Ma, almeno concettualmente, queste sorgenti d'errore hanno origini distinte:
+ *Errori di troncamento*
+ *Errori di iterazione*
+ *Errori di round-off*

== Errori di troncamento o discretizzazione
#index("Errore", "di troncamento")
Questi tipi di errori sono legati alla definizione del metodo numerico. Nascono perché non possiamo calcolare limiti o serie infinite con un numero finito di operazioni. Se, ad esempio, il problema da risolvere è il calcolo della derivata di una funzione $f(x)$ in un punto $x$ assegnato. A questo fine sappiamo che la definizione esatta richiede un limite:
$
  f'(x) = lim_(h arrow 0) frac(f(x+h)-f(x), h) approx frac(f(x+overline(h))-f(x), overline(h)) "   dove " overline(h) > 0 " è fisso"
$
Numericamente, il calcolatore non può fare limiti ($h$ non può essere zero). Dobbiamo fermarci a un passo $h$ (o $overline(h)$) piccolo ma finito ($h > 0$). In questo caso $f'(x) - frac(f(x+overline(h))-f(x), overline(h))$ è l'errore di troncamento connesso.

Per capire quanto grande è l'errore che commettiamo usando questa approssimazione, utilizziamo lo sviluppo di Taylor di $f(x+overline(h))$ centrato in $x$:
$
  f(x+overline(h)) = f(x) + frac(overline(h), overline(h))f'(x) + frac(overline(h)^2, 2overline(h)) f''(x) + ... arrow.double frac(f(x+overline(h))-f(x), overline(h)) = O(h)
$
Quindi, l'approssimazione che stiamo usando differisce dalla derivata vera $f'(x)$ per una quantità proporzionale ad $h$ (che indichiamo con $O(h)$)

#observation()[
  - L'errore di discretizzazione è determinato dalla sostituzione di un problema *continuo*  (definito su infiniti punti) con uno *discreto* (definito su un numero finito di punti) che lo approssima (approssimazione derivata prima con $h$ fisso).
  - L'errore di troncamento nasce quando sostituiamo un processo *infinito* con uno *finito* (approssimazione tramite Taylor).
]

== Errori di iterazione o convergenza
#index("Errore", "di iterazione")
Determinati metodi numerici sono di *tipo iterativo*. Questo significa che sono definiti da una *funzione di iterazione*, $Phi(x)$, tale che, a partire da un'approssimazione iniziale $x_0 approx x$, viene prodotta una successione di approssimazioni mediante l'iterazione:
$
  x_(n+1) = Phi(x_n) space "con " n=0,1,2,...
$

#definition("Convergente")[
  #index("Convergente")
  Diremo che il metodo è *convergente* se:
  $
    lim_(n arrow infinity) x_n = x^*
  $
]

Se il metodo è convergente e, per un opportuno indice $n > 0$, utilizziamo $x_n$ come approssimazione di $x^*$, la differenza $x^*-x_n$ è l'*errore di iterazione*.

#observation(multiple: true)[
  - L'errore di iterazione è legato all'utilizzo del metodo di base $Phi(x)$.
  - Praticamente sempre, l'indice $n$ a cui interrompiamo l'iterazione è determinato dinamicamente mediante un opportuno criterio di arresto.
]

#example("Metodo di Newton")[
  Se $a>0$, la successione $x_(n+1) = 1/2 (x_n + a/(x_n))$, $n=0,1,2,dots$ con $x_0>0$ e $x_0 = a$, converge a $sqrt(a)$. Tabulazione considerando $a=2$:
  #let a = 2.0
  #let x = 2.0
  #let steps = 6

  #let cells1 = (
    [$n$],
    [$x_n$],
    [$sqrt(a) - x_n$],
  )

  #let cells2 = (
    [$n$],
    [$x_n$],
    [$sqrt(a) - x_n$],
  )

  #for n in range(0, 3) {
    let error = calc.sqrt(a) - x
    cells1.push([#n])
    cells1.push([#calc.round(x, digits: 8)])
    cells1.push([#calc.round(error, digits: 8)])
    x = 0.5 * (x + a / x)
  }

  #for n in range(3, 6) {
    let error = calc.sqrt(a) - x
    cells2.push([#n])
    cells2.push([#calc.round(x, digits: 8)])
    cells2.push([#calc.round(error, digits: 8)])
    x = 0.5 * (x + a / x)
  }

  #align(center, grid(
    columns: 2,
    column-gutter: 3pt,
    table(
      columns: 3,
      rows: 4,
      ..cells1
    ),
    table(
      columns: 3,
      rows: 4,
      ..cells2
    ),
  ))



]

== Errori di round-off
#index("Errore", "di round-off")
Questi errori sono dovuti all'utilizzo dell'*aritmetica finita* di un calcolatore. In particolare ci preoccuperemo degli errori di rappresentazione, che sono dovuti al fatto che i numeri non sono rappresentabili esattamente in macchina. Considereremo i seguenti tipi di dati numerici:

- *Interi*
- *Reali*

=== Interi

Fissata un'opportuna base di rappresentazione $b in NN$ (pari e spesso 2), un intero è rappresentato nella memoria di un calcolatore da una stringa del tipo:
$
  alpha_0 alpha_1 alpha_2 ... alpha_n "con " n " fissato" \
  alpha_0 in {+,-} \
  alpha_1 alpha_2 ... alpha_n in {0, 1, ..., b-1}
$

A questa stringa corrisponde l'intero:
$
  sum_(i=1)^n alpha_i b^(n-i), "  se" alpha_0 = + \
  sum_(i=1)^n (alpha_i b^(n-i)) - b^n, "  se" alpha_0 = -
$
ovvero si fa uso della codifica "Complemento alla base $b$".

=== Reali

Un numero "reale" è rappresentato in memoria da una stringa del tipo:
$
  alpha_0 alpha_1 ... alpha_m beta_1 ... beta_s space space space (1)
$
Fissata una base di rappresentazione $b in NN$, le cifre della stringa sono così definite:
$
  alpha_0 in {+,-} space space alpha_i, beta_j in {0,1...,b-1}, space i=1,...,m space j=1,...,s space "con" space alpha_1 eq.not 0 space space space (2)
$
Con questa stringa si rappresenta il numero in notazione scientifica:
$
  r = plus.minus (sum_(i=1)^m alpha_i b^(1-i)) b^(e-nu) space space space (3)
$
$nu$ rappresenta lo "*shift*" o "*bias*" che è fissato inizialmente e scelto in modo da poter rappresentare all'incirca lo stesso numero di esponenti positivi e negativi.
La stringa può essere suddivisa in due parti: la *mantissa* ($rho$) e l'*esponente* ($e$).
$
  rho = sum_(i=1)^m alpha_i b^(1-i) space space space e = sum_(j=1)^s beta_j b^(s-j) space space space (4)
$
Pertanto, poiché:
$
  0 lt.eq e lt.eq (b-1) sum_(i=1)^s b^(s-i) = (b-1) frac(b^s -1, b-1)=b^s -1
$
Ne consegue che, essendo $b^s >> 1$, allora $nu approx frac(b^s, 2) space (5)$.
Riguardo alla mantissa abbiamo che:
$
  1 lt.eq rho lt.eq (b-1) times overbrace((b-1) ... (b-1), m-1) = (b-b^(1-m)) < b space space space (6)
$
ovvero essa risulta essere *normalizzata* (semplicemente compresa tra 1 e $b$).

#definition(
  "Numeri di macchina normalizzati",
)[
  #index("Numeri macchina normalizzati")
  I numeri della forma (1-6) costituiscono, assieme allo $emptyset$, l'insieme dei *numeri di macchina normalizzati* $cal(M)$.
]

#observation(multiple: true)[
  - I numeri della forma (1-6) sono in numero finito.
  - Dalla scelta dello shift $nu$ (5), segue che $cal(M)$ contiene (segno a parte) praticamente lo stesso numero di numeri di macchina in [0,1] e (1, $+infinity$)
  - Il più piccolo numero di macchina *positivo* è:
    $
      r_1 = 1 dot b^(0 - nu) = b^(-nu)
    $
    Similmente, il più grande numero di macchina si ottiene quando  $alpha_i = (b-1)$ con $i = 1,...,m$ e $beta_j = (b-1)$ con  $j=1,...,s$. Così facendo si ottiene:
    $
      r_2 = b(1-b^(-m))b^(b^s-1-nu) approx b^(b^s -nu)
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
Dove $limits(x)^tilde = f l(x)$ è il floating di $x$, che individua il numero di macchina che associamo a $x$.

#definition("Errore di rappresentazione")[
  #index("Errore", "di rappresentazione")
  Chiamiamo *errore di rappresentazione* la quantità $f l (x) - x$.
]

Vediamo come si implementa la funzione $f l$. Per costruzione vale:
- $f l (0) = 0$. Più in generale se $x in cal(M)$, allora $f l (x) = x$.
- $x>0$ allora $f l(-x) = -f l(x)$
Pertanto è sufficiente dettagliare l'implementazione di $f l (x)$ quando $x>0$. Per questo motivo, se $x in cal(I)$, allora $x$ sarà della forma:
$
  x = (alpha_1 alpha_2 ... alpha_m alpha_(m+1) ... ) b^(e-nu)
$

A questo punto esistono 2 modi di implementare la funzione floating:
- *Troncamento* alla m-esima cifra:
#align(center, [
  $
    f l (x) = (alpha_1 alpha_2 ... alpha_m) b^(e-nu)
  $
])
- *Arrotondamento* alla m-esima cifra:
#align(
  center,
  [
    $
      f l (x) = (alpha_1 alpha_2 ... alpha_(m-1) limits(alpha_m)^tilde) b^(e-nu) \
      "dove " limits(alpha_m)^tilde = cases(alpha_m ", se " alpha_(m+1) < b/2, alpha_m + 1 ", se " alpha_(m+1) gt.eq b/2)
    $
  ],
)

Riguardo all'errore di rappresentazione vale il seguente risultato:
#theorem()[
  Per i numeri di $cal(I)$ positivi vale che l'errore relativo di rappresentazione:
  $
    f l(x) = tilde(x) = x (1+epsilon_x) quad abs(epsilon_x) lt.eq u
  $
  #index("Precisione di macchina")
  $u$ è detta *precisione di macchina dell'aritmetica finita*. _E' la maggiorazione uniforme dell'errore relativo di rappresentazione_.
  $
    u = cases(b^(1-m) ", troncamento", 1/2 b^(1-m) ", arrotondamento")
  $
]

#proof()[
  Per brevità, si riporta la dimostrazione nel solo caso della rappresentazione con troncamento. Simili argomenti si applicano al caso della rappresentazione con arrotondamento. Siano:
  $
    x = (alpha_1. alpha_2 ... alpha_(m-1)alpha_m alpha_(m+1) ...) b^(e-nu) \
    f l (x) = (alpha_1. alpha_2 ... alpha_m) b^(e-nu)
  $
  Allora:
  $
    abs(epsilon_x) &= frac(abs(x- f l(x)), abs(x)) = frac(
      abs((alpha_1 alpha_2 ... alpha_m alpha_(m+1) ...)b^(e-nu) - (alpha_1 alpha_2 ... alpha_m)b^(e-nu)),
      abs((alpha_1 alpha_2 ...)b^(e-nu)),
    ) \
    &lt.eq frac(0.overbracket(0 ... 0, m-1) alpha_(m+1) ..., 1) = (alpha_(m+1) alpha_(m+2) ...)b^(-m) lt.eq b^(1-m) equiv u
  $
  La cifra $alpha_(m+1)$ ha peso $b^(-m)$. Ma quindi, quanto può essere grande al massimo la parte frazionaria che abbiamo rimosso per via del troncamento? Basta pensare al fatto che se anche tutte le cifre dalla posizione $m+1$ in poi avessero valore massimo, esse sarebbero comunque più piccole del valore di una unità in posizione $m$ che vale $b^(1-m)$.
]

#observation(multiple: true)[
  - $abs(x - f l(x)) = abs(f l(x) - x) <=> abs(A-B) = abs(B-A)$
  - Concludiamo che la precisione di macchina di un'aritmetica finita è una maggiorazione uniforme dell'errore relativo di rappresentazione.
]
=== Overflow e Underflow

Che succede se $x>0$ ma $x>r_2$ oppure $0<x<r_1$?

Se $x>r_2$ sostanzialmente $f l (x) = +infinity$. Questo è "gestibile" entro certi limiti (es. $1/infinity = 0$).
- La condizione $x>r_2$ (o $x< -r_2$) è denominata *overflow*#index("Overflow").
- La condizione $0<x<r_1$ è denominata *underflow*#index("Underflow").

Per quest'ultimo sono previste 2 recovery:
- *Store $emptyset$* in cui $f l(x) = 0$.
- *Gradual underflow*: in questo caso il numero di macchina viene *denormalizzato* permettendo ad $alpha_1$ di essere nullo. Chiaramente va a discapito dell'accuratezza di rappresentazione e il teorema precedente non vale più.

In conclusione, per la funzione $f l (x)$ vale che:
$
  f l (x) = cases(
    x ", se" x "è numero di macchina",
    -f l(x) ", se" x<0,
    "underflow, se" 0<abs(x)<r_1,
    "overflow, se" abs(x) > r_2,
  )
$

// Lezione del 30/09/2025
=== Standard IEEE-754
#index("IEEE-754")
Base binaria (b = 2).\
Viene utilizzata una rappresentazione con arrotondamento "*round to even*", ovvero, l'ultima cifra della mantissa rappresentata dalla funzione $f l$ è 0. Tuttavia, la maggiorazione dell'errore relativo di rappresentazione continua a valere. Viene implementato un *gradual underflow*. Pertanto, essendo la base binaria, la mantissa di un numero *normalizzato* sarà del tipo:
$
  1.bold(f), quad quad "con " f " la parte frazionaria"
$
Similmente, la mantissa di un numero *denormalizzato* sarà del tipo:
$
  0.bold(f), quad quad "con " f " la parte frazionaria"
$
Questi argomenti ci dicono che, sapendo se il numero è normalizzato o meno, non abbiamo bisogno di memorizzare la sua parte intera, ma è sufficiente memorizzare la sola *frazione $f$*, risparmiando quindi 1 bit.
Lo standard prevede due tipi di numeri reali:
- Singola precisione: 32 bit
- Doppia precisione: 64 bit

#[#set heading(outlined: false, numbering: none)
  ==== Singola precisione]

In questo caso vengono allocati un totale di 4 byte (o 32 bit ripartiti nel seguente modo):
- 1 bit per il segno dell mantissa;
- 8 bit per l'esponente (s = 8);
- 23 bit per la frazione $f$ (m = 24, in quanto il primo bit è 1 per via della normalizzazione).
$
  #let cells = ()
  #for n in range(32) {
    if (n == 0) { cells.push(table.cell(fill: gray.transparentize(75%))[$$]) } else if (n in range(1, 8)) {
      cells.push(table.cell(fill: green.transparentize(75%), stroke: (right: (dash: "densely-dotted")))[$$])
    } else if (n == 8) { cells.push(table.cell(fill: green.transparentize(75%))[$$]) } else if (n in range(9, 31)) {
      cells.push(table.cell(fill: yellow.transparentize(75%), stroke: (right: (dash: "densely-dotted")))[$$])
    } else { cells.push(table.cell(fill: yellow.transparentize(75%))[$$]) }
  }
  #figure(table(
    columns: 32,
    rows: 1,

    ..cells
  ))
$
Da questo segue che la precisione di macchina (singola precisione IEEE-754) vale:
$
  u=1/2b^(1-m)=1/2 dot 2^(1-24)= 2^(-1) dot 2^(-23) = 2^(-24) approx 10^(-7.22)
$
Il che vuole dire che lavoriamo con circa 7 cifre decimali significative.\
Vediamo riguardo all'esponente. Con 8 cifre binarie, si possono rappresentare tutti gli interi in ${0, 1, dots, 255}$ quindi $0 <= e <= 255$. In particolare:

- Se $0 < e < 255$, allora il numero è *normalizzato* e lo *shift* vale $nu=127$;
- Se $e=f=0$, allora abbiamo la rappresentazione dello *0*;
- Se $e=0 and f eq.not 0$, allora il numero è *denormalizzato* e l'esponente effettivo è fissato a $e = 1-127=-126$.

#observation()[
  La variazione di shift, quando si denormalizza, si spiega osservando che il più piccolo numero normalizzato (positivo) è:
  $
    1.0 dot 2^(1-127)=2^(-126)
  $
  Invece, il più grande numero denormalizzato (positivo) è:
  $
    0.1 dots 1 dot 2^(1-127)=2^(-126)
  $
  Pertanto, i due numeri sono *contigui*. Ovvero lo spazio tra zero e il più piccolo numero normalizzato è riempito dai denormalizzati.
]

- Se $e=255$ e $f=0$, allora abbiamo:
$
  + space infinity, "se " alpha_0=0\
  - space infinity, "se " alpha_0=1
$
- Se $e=255$ e $f eq.not 0$, allora abbiamo: NaN (Not a Number). Questo è, ad esempio, originato da forme indeterminate del tipo: $infinity - infinity$, $0 dot infinity$, $infinity / infinity$ e $0/0$.

#[#set heading(outlined: false, numbering: none)
  ==== Doppia precisione]

In questo caso vengono utilizzati 8 byte (64 bit) per rappresentare un numero in doppia precisione. Questi sono così ripartiti:
- 1 bit per il segno della mantissa;
- 11 bit per l'esponente (s = 11);
- 52 bit per la frazione $f$ (m = 53 in quanto il primo bit è 1 per via della normalizzazione).

$
  #let cells = ()
  #for n in range(64) {
    if (n == 0) { cells.push(table.cell(fill: gray.transparentize(75%))[$$]) } else if (n in range(1, 11)) {
      cells.push(table.cell(fill: green.transparentize(75%), stroke: (right: (dash: "densely-dotted")))[$$])
    } else if (n == 11) { cells.push(table.cell(fill: green.transparentize(75%))[$$]) } else if (n in range(12, 63)) {
      cells.push(table.cell(fill: yellow.transparentize(75%), stroke: (right: (dash: "densely-dotted")))[$$])
    } else { cells.push(table.cell(fill: yellow.transparentize(75%))[$$]) }
  }
  #figure(table(
    columns: 64,
    rows: 1,

    ..cells
  ))
$

#observation()[
  In questo caso la precisione di macchina vale: $u=1/2b^(1-m)=1/2 dot 2^(1-53) = 2^(-53) approx 10^(-16)$\
  Il che vuole dire che lavoriamo con circa 16 cifre decimali significative.\
  Da quanto esposto, $e in {0, 1, dots, 2047}$.
]

In modo sostanzialmente analogo al caso della singola precisione, si ha che:
- Se $0< e < 2047$, allora il numero è normalizzato e lo shift vale $nu=1023$.
- Se $e=f=0$, allora abbiamo la rappresentazione dello *0*;
- Se $e=0 and f eq.not 0$, allora il numero è *denormalizzato* e l'esponente effettivo è fissato a $e = 1-1023=-1022$.
- Se $e=2047$ e $f=0$, allora abbiamo:
$
  + space infinity, "se " alpha_0=0\
  - space infinity, "se " alpha_0=1
$
- Se $e=2047$ e $f eq.not 0$, allora abbiamo: NaN (Not a Number).

=== Aritmetica finita

Se eseguiamo operazioni algebriche $(+, -, *, \/) in.rev plus.o$, allora:
$
  forall x, y in RR: quad x plus.o y quad = quad f l(f l (x) plus.o f l(y))
$
Questo implica che, di norma, le proprietà algebriche delle operazioni (associatività, distributività, etc...) non valgono più.

=== Conversione fra tipi diversi

Consideriamo le seguenti variabili:
- $pi approx 3.141592653dots$.
- $x$: variabile in doppia precisione (64 bit, $approx 16$ cifre significative).
- $y$: variabile in singola precisione (32 bit, $approx 7$ cifre significative).

Analizziamo cosa accade quando trasferiamo i dati tra le due variabili:
- Da Doppia a Singola (*Downcasting*):
  $
    cases(x = pi, y = x)
  $
  La variabile $y$ conterrà il valore di $pi$, ma troncato alla precisione della singola. Si ha una perdita di informazione irreversibile.
- Da Singola a Doppia (*Upcasting*):
  $
    cases(y = pi, x = y)
  $
  In questo caso, $pi$ viene prima troncato per entrare in $y$. Quando viene copiato in $x$, il valore rimane quello troncato. Le cifre aggiuntive non conterranno la vera espansione di $pi$, ma zeri.

La precisione non è l'unica differenza; cambia anche il range di valori rappresentabili.
- Singola precisione: arriva fino a circa $approx 3.4 times 10^38$.
- Doppia precisione: arriva fino a circa $approx 1.8 times 10^308$.
Pertanto, se proviamo ad assegnare un numero molto grande come $1 times 10^308$:
- $x = 1E 308 => x$ memorizza correttamente il numero (è dentro il range).
- $y = 1E 308 => y$ diventa $+infinity$, poiché il numero supera la capacità massima della singola precisione.

Quando si convertono numeri tra rappresentazione intera (discreta) e reale (floating-point), bisogna prestare attenzione ai domini di rappresentabilità.
- *Da Intero a Reale*: questa conversione è generalmente sicura per quanto riguarda il range (i reali coprono un intervallo molto più ampio degli interi). Tuttavia, si perde la natura "esatta" dell'intero: il numero viene trasformato in una coppia mantissa+esponente.(Nota: se l'intero è molto grande, potremmo perdere precisione se la mantissa del reale non ha abbastanza bit per rappresentare tutte le cifre dell'intero).
- *Da Reale a Intero*: questa operazione è pericolosa per due motivi:
  - Troncamento: si perde tutta la parte decimale.
  - Overflow: l'insieme dei numeri reali rappresentabili $cal(I)$ è molto più vasto del range degli interi. Se il numero reale supera il massimo intero rappresentabile, si verifica un errore di overflow.

Nel caso del filmato di Ariane V, il problema si è originato dall'assegnazione di una variabile in doppia precisione, legata alla componente tangenziale della velocità, ad una variabile intera di 2 byte. Quindi, se il numero è maggiore di 32767, si ha un errore.

== Condizionamento di un problema

Supponiamo di voler calcolare la soluzione di un problema che, formalmente, poniamo essere descritto da:
$
  y=f(x) space space space (1)
$
dove:
- $x$ contiene i dati in ingresso;
- $y$ contiene il risultato atteso;
- $f$ contiene la descrizione formale del problema

Assumiamo inoltre che $x,y in RR " e " f:RR ->RR$.
$
  #canvas({
    import draw: arc, circle, content
    let dark-blue = rgb("#4040d9")
    let arrow-style = (mark: (end: "stealth", fill: dark-blue, scale: .5), stroke: (paint: dark-blue, thickness: 0.75pt))

    content((-1.75, 1.5), $X$)
    circle((0, 0), radius: 2)
    circle((8, 0), radius: 2)
    content((9.75, 1.5), $Y$)
    content((0, 0.5), $x$, name: "x")
    content((0, -0.5), $tilde(x)$, name: "xt")
    content((8.0, 0.5), $y$, name: "y")
    content((8.0, -0.5), $tilde(y)$, name: "yt")

    arc((rel: (0, 0.2), to: "x"), radius: 1.2 * 4, start: 145deg, stop: 35deg, ..arrow-style, name: "momentum-arrow")
    content("momentum-arrow.mid", text(fill: dark-blue)[$f$], anchor: "south")

    arc((rel: (0, 0.2), to: "xt"), radius: 1.2 * 4, start: 145deg, stop: 35deg, ..arrow-style, name: "momentum-arrow")
    content("momentum-arrow.mid", text(fill: dark-blue)[$tilde(f)$], anchor: "south")
  })
$

In generale, al posto di $x$, avremo un dato perturbato $tilde(x)$ e, se usiamo un calcolatore, per via dell'utilizzo dell'aritmetica finita, avremo una funzione perturbata $tilde(f)$, invece di $f$. Questo fornirà un risultato perturbato:
$
  tilde(y)=tilde(f)(tilde(x)) space space space (2)
$

#observation()[
  Tuttavia, analizzare la differenza tra il risultato fornito dalla (2), rispetto alla (1), è in generale complesso. Ci limiteremo a studiare il problema, assai più semplice, $tilde(y)=f(tilde(x)) space space space (3)$
]
Ovvero, studiamo le amplificazioni di perturbazioni sui dati in ingresso, utilizzando un'*aritmetica esatta*. Lo studio della differenza tra il risultato fornito da (3), invece che dalla (1), costituisce l'*analisi del condizionamento del problema* (1). Se $y eq.not 0$, l'analisi è più efficace se fatta rispetto agli errori relativi.\
Pertanto, porremo:
$
  (4) quad
  cases(
    tilde(y)=y(1+epsilon_y)","quad "con "epsilon_y "l'errore relativo sul risultato",
    tilde(x)=x(1+epsilon_x)","quad "con "epsilon_x "l'errore relativo sul dato in ingresso",
  )
$
e, supponendo $epsilon_x approx 0$, vogliamo stabilire in che modo $epsilon_x$ *si propaga su* $epsilon_y$.

Sostituendo le (4) nella (3) e applicando lo sviluppo di Taylor al secondo termine, otteniamo che:
$
  tilde(y)=y(1+epsilon_y) & =f(x(1+epsilon_x)) = f(tilde(x)) \
  cancel(y)+y epsilon_x & = cancel(f(x))+f'(x)x epsilon_x+ O(epsilon_x^2) \
  & =>epsilon_y approx f'(x)x/y epsilon_x \
  =>|epsilon_y| <=K dot |epsilon_x|, quad "con "K=abs(& (f'(x))/y x) "detto" #strong[numero di condizione del problema].
$
#index("Numero di condizione del problema")
Diremo, pertanto, che il problema (1) è:
#index("Ben condizionato")
- *ben condizionato*, se $K approx 1$;
#index("Mal condizionato")
- *mal condizionato*, se $K >> 1$;

#observation()[
  Se lavoriamo in aritmetica finita con precisione di macchina $u$, l'errore relativo sui dati memorizzati soddisfa $|epsilon_x|>=u$. Ciò significa che, anche partendo da dati di ingresso esatti, la loro rappresentazione in memoria introduce inevitabilmente un errore di arrotondamento.

  Supponiamo ora di avere un problema estremamente mal condizionato, con numero di condizionamento $K$ molto grande, in particolare $K approx frac(1, u) = u^(-1)$:
  $
    |epsilon_y| approx K dot |epsilon_x| approx frac(1, u) dot u = 1
  $
  Ne segue che l'errore relativo sul risultato finale è dell'ordine dell'unità, rendendo l'output completamente inaffidabile e, di fatto, privo di significato numerico.
]

Segue l'analisi del condizionamento della operazioni algebriche elementari.

#set heading(outlined: false, numbering: none)
=== Somma algebrica
$
  & y                                 && = x_1+x_2 quad quad "che, perturbato, dà" \
  & y(1+epsilon_y)                    && =x_1(1+epsilon_1)+x_2(1+epsilon_2) \
  & cancel(y)+y epsilon_y             && =cancel(x_1+x_2)+x_1epsilon_1+x_2epsilon_2 \
  & "Dividendo membro a membro per "y && =x_1+x_2 "otteniamo:" \
  & epsilon_y                         && = (x_1epsilon_1x_2epsilon_2)/(x_1+x_2) \
  & "da cui:" \
  & |epsilon_y|                       && <= (|x_1|+|x_2|)/(|x_1+x_2|) dot max{|epsilon_1|,|epsilon_2|}
$
Pertanto, il numero di condizione del problema è
$
  K=(|x_1|+|x_2|)/(|x_1+x_2|)
$

Vi sono però dei casi particolari:
- se *$x_1 dot x_2 >0$ (addendi concordi)* $=>$ $|x_1+x_2|=|x_1|+|x_2| =>K=1$\ da cui si conclude che la *somma di numeri concordi* è *sempre ben condizionata*;
- se *$x_1 dot x_2 <0$ (addendi discordi)* $=>$ in questo caso il denominatore di $K$ non è limitato superiormente e, quando $x_2 approx -x_1$, $K$ può essere arbitrariamente grande. La somma di numeri discordi è quindi *mal condizionata*. Questo mal condizionamento si concretizza nel fenomeno della cosiddetta #index("Cancellazione numerica") *cancellazione numerica*, in cui anche avendo addendi completamente accurati, il risultato può essere del tutto inaccurato.

#example("Cancellazione numerica")[
  Consideriamo il problema di calcolare numericamente la derivata prima di una funzione $f(x)$ in un punto $x$ utilizzando il rapporto incrementale:
  $
    f'(x) approx (f(x+epsilon)-f(x))/epsilon
  $
  L'errore totale commesso è dato dalla somma di:
  - Errore di Troncamento: dovuto all'approssimazione del limite con un passo finito (diminuisce al diminuire di $epsilon$).
  - Errore di Arrotondamento (Cancellazione): dovuto alla sottrazione di due numeri molto vicini tra loro, $f(x+epsilon)$ e $f(x)$, al numeratore (aumenta al diminuire di $epsilon$).
  Ad esempio:
  $
    f(x)=x^10, quad quad x=1 => f'(1)=10
  $
  #align(center, grid(
    columns: 2,
    align: center,
    table(
      columns: 3,
      align: left,
      [$epsilon$], [$((1+epsilon)^10-1)\/epsilon$], [Err],
      [1.00e-01], [15.9374246010000], [$approx 5.93$],
      [1.00e-02], [10.4622125411204], [$approx 0.46$],
      [1.00e-03], [10.0451202102511], [$approx 0.04$],
      [1.00e-04], [10.0045012002092], [$approx 0.004$],
      [1.00e-05], [10.0004500120709], [$approx 0.00045$],
      [1.00e-06], [10.0000449994031], [$approx 0.00044$],
      [1.00e-07], [10.0000045066828], [$approx 0.0000045$],
      [1.00e-08], [10.0000003833145], [$approx 0.0000003$],
    ),
    table(
      columns: 3,
      align: left,
      [$epsilon$], [$((1+epsilon)^10-1)\/epsilon$], [Err],
      [1.00e-09], [10.0000008274037], [$approx 0.0000008$],
      [1.00e-10], [10.0000008274037], [$approx 0.0000008$],
      [1.00e-11], [10.0000008274037], [$approx 0.0000008$],
      [1.00e-12], [10.0008890058234], [$approx 0.0008$],
      [1.00e-13], [9.9920072216264], [$approx 0.008$],
      [1.00e-14], [9.9920072216264], [$approx 0.008$],
      [1.00e-15], [11.1022302462515], [$approx 1.102$],
      [1.00e-16], [0.0000000000000], [$approx 10$],
    ),
  ))
  Si vede come con $epsilon=1 times e^(-12)$ si perdono 3 cifre di accuratezza. Quando $epsilon$ diventa troppo piccolo, il computer non ha abbastanza bit per memorizzarlo e quindi viene approssimato a 0 portando il calcolo della derivata a diventare 0.
]

#[#set heading(outlined: false, numbering: none)
  === Moltiplicazione]
$
     & quad quad quad space y      && = x_1 dot x_2 quad quad "esatta, mentre perturbando" \
     & y(1+epsilon_y)              && =x_1(1+epsilon_1) dot x_2(1+epsilon_2) \
     & space space y+y epsilon_y   && =x_1 dot x_2(1+epsilon_1+epsilon_2+epsilon_1 dot epsilon_2) \
     &                             && approx x_1 dot x_2(1+epsilon_1 + epsilon_2) \
  => & quad space 1 + epsilon_y    && approx 1+epsilon_1+epsilon_2 \
  => & quad quad space |epsilon_y| && <= 2 max{|epsilon_1|, |epsilon_2|}
$
Concludiamo che la moltiplicazione è sempre *ben condizionato*, poiché il numero di condizionamento è 2.

#[#set heading(outlined: false, numbering: none)
  === Divisione]
#observation()[
  Ricordiamo da Analisi I che se $|gamma|<1$, allora:
  $
    sum_(i>=0)^infinity gamma^i = 1+ gamma + gamma^2 +... = 1/(1-gamma)
  $
  Pertanto, se $gamma = - epsilon$, si ha che $1/(1+epsilon)=sum_(i>=0) (-epsilon)^i = 1 - epsilon + epsilon^2 ... = 1-epsilon+O(epsilon^2)$
]

$
     & y              && = x_1/x_2 quad quad "e la perturbazione" \
     & y(1+epsilon_y) && = (x_1(1+epsilon_1))/(x_2(1+epsilon_2)) = x_1/x_2 (1+epsilon_1)(1-epsilon_2 + O(epsilon_2^2)) \
     &                && approx x_1/x_2(1+epsilon_1-epsilon_2) \
  => & 1+epsilon_y    && approx 1+epsilon_1-epsilon_2=>|epsilon_y|<=2 max{|epsilon_1|, |epsilon_2|}
$
Anche la divisione è *ben condizionata* (quindi è al pari della moltiplicazione), avendo numero di condizione 2.



