#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/algo:0.3.6": algo

= Radici di un'equazione

Data una funzione $f:[a,b] subset.eq RR -> RR$ vogliamo determinare $x^* in [a,b]$ tale che $f(x^*)=0$. In questo caso, diremo che $x^*$ è una *radice* (o uno *zero*) di $f(x)$. In generale, $x^*$:
+ la radice può esistere ed essere unica.
+ può esistere ma non essere unica (es. $f(x)=sin x$).
+ oppure non esiste (es. $f(x)=e^x$).

I metodi che esamineremo forniscono — se esiste — l'approssimazione di una sola radice. Una caratteristica comune a tutti questi metodi è quella di essere metodi di tipo iterativo. Questo significa che, a partire da un'approssimazione iniziale $x_0$, sarà prodotta una successione di approssimazioni, ${x_n}_(n gt.eq 0)$ che, se il metodo è *convergente*, converge alla radice $x^*$:
$
  lim_(n -> infinity) x_n = x^*
$
Di seguito introduciamo il primo metodo: il metodo di bisezione.

== Metodo di bisezione

Assumiamo che:
+ $f(x)$ sia continua su $[a,b]$;
+ $f(a)f(b)<0$.

#figure(image("images/2025-10-14-14-20-39.png", width: 60%), caption: "Radice di una funzione")

Per il teorema degli zeri di funzioni continue, sappiamo che $exists x^* in [a,b]: f(x^*)=0$. Non conoscendo la posizione precisa della radice, una prima approssimazione naturale è il punto medio:
$
  x_1 = (a+b)/2
$
Valutando $f(x_1)$ si hanno tre casi:
+ $f(x_1)=0$ allora $x^*=x_1$ e abbiamo finito;
+ se $f(a)f(x_1)<0$ allora la radice è in $[a,x_1]$ e si ripete la procedura su quell'intervallo;
+ altrimenti la radice è in $[x_1,b]$ e si ripete su quest'ultimo intervallo.

Il nome del metodo deriva dal fatto che, ad ogni iterazione, l'ampiezza dell'intervallo di incertezza si dimezza.


```matlab
fa = f(a) 
fb = f(b)
...
while 1
  x1 = (a+b)/2
  f1 = f(x1)

  if f1 == 0, break %Questo criterio di arresto non è robusto
  else if fa*f1<0, b=x1
  else a=x1
  end
end
```

Il criterio di arresta sopra commentato rende l'intera implementazione _naive_ e poco efficiente:
- non sempre è richiesto un calcolo *esatto* della radice ma solo quello di una sua approssimazione entro una tolleranza `tol`;
- la condizione `fx == 0` potrebbe non essere mai soddisfatta a causa dell'aritmetica finita. 
  #example(
    )[Considerando il polinomio
  $
    p(x) = (x-1.1)^20 (x-pi)
  $
  che ha radi e in $x=pi$. Utilizzando Matlab per calcolare $p(pi)$, si ottiene:
  $
    p = "poly"([1.1 * "ones"(1,20),pi])\
    "polyval"(p, pi) approx -5,5213 dot 10^(-5)
  $
  La funzione `poly` restituisce i coefficienti del polinomio le cui radici sono in argomento alla funzione.
  ]

== Criteri di arresto e condizionamento

Vediamo come migliorare la precedente computazione "naive". Se inizializziamo $a_1=a$ e $b_1=b$, l'ampiezza del primo intervallo di confidenza, allora al passo i-esimo:
$
  x_i = (a_i+b_i)/2^i
$
che è il punto medio dell'intervallo di confidenza, $[a_i, b_i]$ al passo corrente. Pertanto $x^* in [a_i, b_i]$ e:
$
  abs(x^*-x_i) lt.eq (b_i-a_i)/2 = (b_(i-1)-a_(i-1))/2^2 = (b_(i-2)-a_(i-2))/2^3 = ... = (b_1-a_1)/2^i = (b-a)/2^i
$

Da questo argomento, deduciamo che, se desideriamo un'approssimazione della soluzione con accuratezza `tol` la potremo conseguire in un numero di iterazioni, imax, dato da:
$
  (b-a)/2^i lt.eq "tol" => (b-a)/"tol" lt.eq 2^i => i gt.eq log_2(b-a)/"tol"
$
Pertanto, imponendo
$
  "imax"=ceil log_2(b-a)-log_2("tol") ceil.r
$
questo è il numero massimo di iterazioni di cui avremo bisogno. Questo ci permette di riformulare il ciclo precedente come:

```matlab
fa = feval(f,a); 
fb = feval(f,b); 
x = (a+b)/2;
fx = feval(f,x);
imax = ceil( log2(b-a) - log2(tol) );
for i=2:imax
  if fx==0
    break
  elseif fa*fx<0
    b =x;
    fb = fx;
  else
    a =x;
    fa = fx;
  end
  x = (a+b)/2;
  fx = feval(f,x);
end
```


In questo caso, evidentemente non si va più in loop per errore. Tuttavia rimane da riformulare in modo più efficace la condizione di uscita. Vediamo geometricamente come interpretare questa cosa:

#figure(image("images/2025-10-14-14-59-18.png", width: 60%))

$
  f(x) = overparen(f(x^*), =0) + f'(x^*)(x-x^*) + o(abs(x-x^*)^2) approx f'(x^*)(x-x^*) => abs(x-x^*) lt.eq (abs(f(x)))/(abs(f'(x^*))) lt.eq "tol"
$
da questo ricaviamo che:
$
  abs(f(x)) lt.eq "tol" dot abs(f'(x^*))
$
è quanto dobbiamo richiedere alla $f(x)$. Nell'iterazione del metodo di bisezione, al passo i-esimo, noi abbiamo calcolato $f(x_i)$, e, inoltre, conosciamo $f(a_i)$ e $f(b_i)$:
#figure(image("images/2025-10-14-15-04-33.png", width: 60%))
Questo significa che possiamo approssimare:
$
  f'(x^*) approx (f(b_i)-f(a_i))/(b_i-a_i)
$
senza valutazioni di funzione aggiuntive.


Questo ci permette, in fine, di ottenere questa versione ottimizzata del metodo di bisezione in cui sono solo omessi i controlli di consistenza sui parametri di ingresso.

```matlab
fa = feval(f,a);
fb = feval(f,b);
x = (a+b)/2;
fx = feval(f,x);
imax = ceil( log2(b-a) -log2(tol) );

for i=2:imax
  fix = abs( (fb-fa)/(b-a) );
  if abs(fx)<=tol*fix
    break
  elseif fa*fx<0
    b = x;
    fb = fx;
  else
    a = x; 
    fa = fx;
  end
  x = (a+b)/2;
  fx = feval(f,x);
end
```

== Ordine di convergenza

Osserviamo che, definito:
$
  e_i = x^* - x_i
$
l'errore del passo i-esimo del metodo, allora, per costruzione, il metodo di bisezione soddisfa:
$
  abs(e_i) lt.eq epsilon_i = (b-a)/2^i
$
e inoltre:
$
  epsilon_(i+1)/epsilon_i = 1/2
$
il che implica che:
$
  lim_(i-> infinity) epsilon_(i+1)/epsilon_i =1/2
$
Più in generale, dato un generico metodo iterativo, per il quale l'errore al passo i-esimo, $e_i$, soddisfa:
$
  lim_(i -> infinity) e_i = 0
$
si dirà *convergente*.

#observation()[
  Il metodo di bisezione, se applicabile, è *sempre* convergente.
]

Inoltre, un metodo si dirà avere *ordine* (di convergenza) $p$, se $p$ è il più grande reale positivo per cui:
$
  lim_(i -> infinity) abs(e_(i+1))/abs(e_i)^p = c < infinity space space space (1)
$
In questo caso, $c$ si dice *costante asintotica dell'errore*. Cerchiamo di dare un significato alla definizione di ordine descritto dalla (1). In effetti, questo significa che, per $i>>1$, si ha che:
$
  abs(e_(i+1)) approx c dot abs(e_i)^p space space space (2)
$
da questo deduciamo che:
+ se $p<1$, allora il metodo non converge. Affinché si abbia convergenza, bisogna avere $p gt.eq 1$. In particolare, se $p=1$, si parlerà di convergenza lineare, se $p=2$, si parlerà di convergenza quadratica e così via.

+ se $p=1$, allora per $i>>1$:
  $
      &abs(e_(i+1)) approx c dot abs(e_i)\
      &abs(e_(i+2)) approx abs(e_(i+1)) approx c^2 dot abs(e_i)\
      & quad quad quad quad quad dots.v\
      &abs(e_(i+k)) approx c^k dot abs(e_i) --> 0, k-->infinity
  $
  se e solo se $c<1$.

  Pertanto un metodo di ordine 1 è *convergente* se e solo se la sua *costante asintotica* dell'errore è minore di 1.

  #observation()[
    Pertanto, il metodo di bisezione ha ordine 1, con costante asintotica dell'errore pari a $1/2$
  ]

+ Dalla (2) segue che metodi di ordine più elevato generalmente convergono più rapidamente di metodi di ordine più basso. Vediamo un esempio.
  #example(
    )[
    Supponiamo di avere 2 metodi, uno di ordine 1 e l'altro di ordine 2. Supponiamo anche che, per entrambi, la costante asintotica dell'errore sia $c=0,1$ e che l'errore da cui partiamo sia, sempre per entrambi, $abs(e_0) = 0,1$. Otteniamo, premesso che la (2) valga a partire da $i=0$:

    #align(center, table(
      align: center,
      columns: 3,
      rows: 6,
      [$i$],
      [$e_i space (p=1)$],
      [$e_i space (p=2)$],
      [0],
      [$10^(-1)$],
      [$10^(-1)$],
      [1],
      [$10^(-2)$],
      [$10^(-3)$],
      [2],
      [$10^(-3)$],
      [$10^(-7)$],
      [3],
      [$10^(-4)$],
      [$10^(-15)$],
      [$dots.v$],
      [$dots.v$],
      [$dots.v$],
    ))
    Da questo semplice esempio si comprende che è bene ricercare metodi di ordine più elevato.
  ]

Preliminarmente, discutiamo il *condizionamento del problema*. Noi cerchiamo $x^*$ talche che $f(x^*)=0$, che è la soluzione del problema che ci prefiggiamo di risolvere. Se, invece di $x^*$, abbiamo una soluzione perturbata $tilde(x)$, tale che $0 eq.not f(tilde(x)) approx 0$, allora siamo interessati a capire quanto la differenza
$
  f(tilde(x)) - overbrace(f(x^*), =0) = f(tilde(x))
$
si ripercuote sull'errore $tilde(x) - x^*$. Otteniamo che:
$
  f(tilde(x)) = overbrace(f(x^*), =0) + f'(x^*)(tilde(x)-x^*)+o((tilde(x)-x^*)^2) approx f'(x^*)(tilde(x)-x^*)
$
da cui otteniamo che:
$
  abs(tilde(x) - x^*) lt.approx abs(f(tilde(x)))/abs(f'(x^*))
$
In questa relazione:
+ $abs(tilde(x))$ è la perturbazione del valore $emptyset$ che dovremmo avere;
+ $abs(tilde(x)-x^*)$ è l'errore determinato da tale perturbazione;
+ $k=1/abs(f'(x^*))$ è il *numero di condizionamento* del problema.

Pertanto, il problema è *ben condizionato*, se $abs(f'(x^*))>>1$. Viceversa, se $abs(f'(x^*))approx 0$, allora la radice è *mal condizionata*.

#definition()[
  Una radice si dice avere *molteplicità* $m gt.eq 1$ se:
  $
    0=f(x^*)=f'(x^*)=dots=f^(m-1)(x^*) and f^(m)(x^*) eq.not 0
  $
  Se $m=1$ la radice si dice *semplice* (allora $f'(x^*)=0$), viceversa, la radice si dice *multipla*.
]

#observation(
  )[
  Da quanto esposto, si deduce che l'approssimazione di una radice *multipla* dà origine ad un problema *sempre malcondizionato*.
]

== Metodo di Newton
#figure(image("images/2025-10-15-16-38-35.png"))

L'equazione della retta tangente al grafico di $f(x)$ in $(x_0, f(x_0))$ è;
$
  cases(y-f(x_0) = f'(x_0)(x-x_0)", tangente", y=0", asse x")
$
da cui si ricava che:
$
  x_1 = x_0 - f(x_0)/(f'(x_0))
$
è la nuova approssimazione. In generale avremo che:
$
  x_(i+1) = x_i - f(x_i)/(f'(x_i)), quad i=0,1,dots space space space (3)
$
definisce il *metodo di Newton*. Andiamo a fare alcune considerazioni:
+ La funzione $f(x)$ deve essere derivabile (è necessario che sia almeno di classe $C^2$ in un intorno della radice)
+ il costo per iterazione consiste in una valutazione di $f(x)$ e una valutazione di $f'(x)$ (moralmente doppio, rispetto al metodo di bisezione).

A fronte di questo costo per iterazione più elevato, vale il seguente risultato.
#theorem(
  )[
  Sia $f(x) in C^2$ in un interno della radice $x^*$. Supponiamo che il metodo di Newton converga a $x^*$ e che $x^*$ sia semplice. Allora l'ordine di convergenza è (almeno) 2.
]
#proof(
  )[
  Indichiamo con $x^*$ la radice verso cui l'iterazione sta convergendo. Si ottiene, per un opportuno $epsilon_i$ compreso tra $x^* " e " x_i$:
  $
    0 & = f(x^*)=f(x_i)+f'(x_i)(x^*-x_i)+1/2 f''(epsilon_i)(x^*-x_i)^2 \
      & = f'(x_i)(f(x_i)/(f'(x_i)) - x_i + x^*) + 1/2 f''(epsilon_i)(x^*-x_i)^2 \
      & =^((3)) f'(x_i)underbrace((x^* - x_(i+1)), e_(i+1)) + 1/2 f''(epsilon_i)underbrace((x^*-x_i), e_i)^2
  $
  Tenendo conto della (3) e per la definizione di errore al passo i-esimo si ottiene:
  $
    e_(i+1)/(e_i)^2 = -1/2 (f''(epsilon_i))/(f'(x_i))
  $
  che è ben definita in un intorno di $x^*$ essendo, per ipotesi, $f'(x^*) eq.not 0$. Se il metodo è convergente segue quindi che:
  $
    lim_(i -> infinity) abs(e_(i+1))/abs(e_i)^2 = lim_(i -> infinity) 1/2 abs(f''(epsilon_i))/abs(f'(x_i))
    = 1/2 abs(f''(x^*))/abs(f'(x^*))
  $
  da cui deduciamo che la *convergenza quadratica* ovvero $p=2$ (cubica se $f''(x^*)=0$).
]

Nel caso di una radice multipla, con molteplicità $m>1$, si può dimostrare che:
$
  lim_(i-> infinity) e_(i+1)/e_i
  = (m-1)/m
$
ovvero, l'ordine di convergenza del metodo di Newton diventa *lineare*, come conseguenza del malcondizionamento del problema.