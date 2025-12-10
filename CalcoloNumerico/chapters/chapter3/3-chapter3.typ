#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/algo:0.3.6": algo
= Radici di un'equazione

Data $f:[a,b] subset.eq RR -> RR$ vogliamo determinare $x^* in [a,b]$ tale che $f(x^*)=0$. In questo caso, diremo che $x^*$ è una *radice* (o uno *zero*) di $f(x)$. In generale, $x^*$:
+ Può esistere ed essere unica.
+ Può esistere ma non essere unica (e.g. $f(x)=sin(x)$).
+ Non esiste (e.g. $f(x)=e^x$).

Pertanto, i metodi che esamineremo forniranno, se esiste, l'approssimazione di una sola radice. Una caratteristica comune a tutti questi metodi è quello di essere metodi di tipo iterativo. Questo significa che, a partire da un'approssimazione iniziale $x_0$, sarà prodotta una successione di approssimazioni, ${x_n}_(n gt.eq 0)$ che, se il metodo è *convergente*, converge alla radice $x^*$:
$
  lim_(n -> infinity) x_n = x^*
$
Ciò premesso, andiamo ad introdurre il primo metodo, il *metodo di bisezione*.

== Metodo di bisezione

Assumiamo che:
+ $f(x)$ sia continua in $[a,b]$ (limitato).
+ $f(a)f(b)<0$

#figure(image("images/2025-10-14-14-20-39.png", width: 60%), caption: "Radice di una funzione")

In queste ipotesi, dal teorema degli zeri di funzioni continue, sappiamo che $exists x^* in [a,b]: f(x^*)=0$. Chiaramente, non conoscendo dove si trovi $x^*$, la sua migliore approssimazione sarà il punto medio:
$
  x_1 = (a+b)/2
$
A questo punto, ho 3 casi possibili:
+ $f(x_1)=0 => x^*=x_1$, ho finito;
+ $f(a)f(x_1)<0 =>$ ripeto la procedura in $[a,x_1]$;
+ ripeto la procedura in $[x_1,b].$

La denominazione del metodo deriva dal fatto che, ad ogni iterazione, l0ampiezza dell'intervallo di confidenza si dimezza.


```matlab
fa = feval(f,a); 
fb = feval(f,b);

x = (a+b)/2;

fx = feval(f,x);

while fx˜=0
  if fa*fx<0
    b = x;
    fb = fx;
  else
    a =x; 
    fa = fx;
  end
  x = (a+b)/2;
  fx = feval(f,x);
end
```

Ad esempio, la funzione `poly` restituisce i coefficienti del polinomio le cui radici sono in argomento alla funzione:
$
  p(x) = (x-1.1)^20 (x-pi) \
  a = "poly"([1.1 * "ones"(1,20),pi])\
  "polyval"(a, pi) approx -t dot 10^(-5)
$

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