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
  #example()[Considerando il polinomio
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


== Convergenza locale

Facciamo prima un riepilogo dei metodi appena visti per la ricerca degli zeri di una funzione. 
- Metodo di bisezione:
  - applicabile se $f in C[a,b] and f(a)f(b)<0$;
  - ordine di convergenza lineare;
  - numero massimo di iterazioni, per soddisfare un prescritto requisito di accuratezza, noto.

- Metodo di Newton:
  - $f(x)$ sia derivabile con continuità;
  - se $f in C^2$ in un intorno di una *radice semplice*, allora si ha, se convergente alla radice, *convergenza quadratica* (ordine 2);
  - se convergente ad una *radice multipla*, l'ordine diviene *lineare*, rispecchiando, così, il malcondizionamento del problema.

Tuttavia, al contrario del metodo di bisezione, per il metodo di Newton
$
  x_(i+1) = x_i - f(x_i)/(f'(x_i)), space i=0,1,...
$
non è in generale possibile garantire la convergenza da un generico punto iniziale $x_0$.

#example(
  )[
  Ad esempio, se consideriamo
  $
    f(x) = x^3 -5x = x(x^2-5)
  $
  che ha 3 radici, $0$, $plus.minus sqrt(5)$, tutte semplici. Se consideriamo $x_0=1$, allora generiamo la successione di approssimazioni
  $
    1,-1,1,-1,...
  $
  che, evidentemente, non converge.
  #figure(image("images/2025-10-21-16-37-32.png"))
]

La conclusione di questo esempio è che la convergenza ad una radice è garantita, per il metodo di Newton, solo in un opportuno intorno della radice. Si parla in questo caso, di *convergenza di tipo locale* mente, per il metodo di bisezione, la *convergenza è globale*, ovvero, avviene sempre, se il metodo è applicabile.

Cerchiamo di formalizzare questo concetto, per un generico metodo iterativo che denoteremo con
$
  x_(i+1) = Phi(x_i), space i=0,1,... space space space (1)\
  x_0 -> x_1 = Phi(x_0) -> x_2 = Phi(x_1) -> ...
$
in cui $Phi(x)$ è detta *funzione di iterazione*. Ad esempio, per il metodo di Newton
$
  Phi(x) = x-f(x)/(f'(x))
$
Se il metodo iterativo (1) serve per determinare la radice $x^*$ di $f(x)$, allora $Phi(x)$ deve soddisfare la *proprietà di consistenza*:
$
  x^* = Phi(x^*) space space space (2)
$
che garantisce che, se raggiungiamo la radice, ci fermiamo. Questo significa che il problema di determinare lo zero di $f(x)$ equivale a trovare un *punto fisso* della funzione di iterazione $Phi(x)$. Pertanto, vogliamo vedere sotto quali condizioni per $Phi(x)$, partendo da un intorno del suo punto fisso (2), la successione di approssimazioni (1) converge a $x^*$. Vale il seguente risultato.

#theorem(
  )[
  Se $exists delta > 0 : forall x,y in overbrace([x^*-delta, x^*+delta], =I(x^*))$ allora $Phi$ è *Lipschitziana* con costante $L<1$, cioè
  $
    abs(Phi(x)-Phi(y)) lt.eq L abs(x-y) space space forall x,y in I
  $
  Allora:
  - $x^*$ è l'unico punto fisso di $Phi(x)$ in $I$.
  - se $x_0 in I$, allora $x_i in I, space i=0,1,...$
  - $lim_(i->infinity) x_i = x^*$
]
#proof()[
  TODO
]

#corollary(
  )[
  Se $exists delta > 0 : forall x in overbrace([x^*-delta, x^*+delta], =I(x^*))$, $abs(Phi'(x)) lt.eq L<1$, allora $x_(i+1)=Phi(x_i)$ converge a $x^*$, per $i-> infinity$.
]
#proof(
  )[
  $forall x,y in I(x^*)$ e per lo sviluppo di Taylor con resto al primo ordine segue dunque:
  $
    abs(Phi(x)-Phi(y)) = abs(cancel(Phi(x)) - cancel(Phi(x)) - Phi'(epsilon)(x-y)) = abs(Phi'(epsilon)) dot abs(x-y) < L abs(x-y), space "con " L<1
  $
  Pertanto vale il precedente teorema.
]

Vediamo come si applica questo risultato al metodo di Newton:
$
  Phi(x) = x-f(x)/(f'(x))\
  Phi(x^*) = x^*-overparen(f(x^*), = 0)/(f'(x^*)) = x^*
$
Se $x^*$ è una radice semplice, allora $f'(x^*) eq.not 0 and $
$
  Phi'(x^*) = [ 1-(f'(x)^2 - f''(x)f(x))/(f'(x)^2) ] lr(bar, size: #300%)_(x=x^*) = [ (f''(x)overparen(f(x), =0))/(f'(x)^2) ] lr(bar, size: #300%)_(x=x^*) = (f''(x^*)overparen(f(x^*), =0))/(f'(x^*)^2) = 0
$
#figure(image("images/2025-10-21-17-07-50.png"))
Nel caso di una radice multipla di molteplicità $m$, si può dimostrare che
$
  Phi'(x^*) = (m-1)/m
$
che comunque, è ancora $<1$, sebbene la convergenza diventi meno favorevole.

== Ancora sul criterio d'arresto

Se abbiamo il metodo iterativo
$
  x_(i+1) = Phi(x_i), space i=0,1,...
$
per determinare uno zero di $f(x)$, cerchiamo un criterio di arresto idoneo per l'iterazione. Esaminiamo, in particolare, il metodo id Newton:
$ $
Come abbiamo precedentemente visto per il metodo di bisezione, il valore di $f(x)$ nell'approssimazione, è da considerarsi "piccolo" se
$
  abs(f(x_i)) lt.eq "tol" dot abs(f'(x^*)) approx "tol" dot abs(f'(x_i))
$
ovvero se
$
  abs(f(x_i))/abs(f'(x_i)) lt.eq "tol"
$
e quindi, per il metodo di Newton, questo equivale a richiedere che 
$
  abs(x_(i+1) - x_i) lt.eq "tol"
$
che è un controllo sull'errore assoluto. Tuttavia, se $x_i -> x^*$, con $abs(x^*) >> 1$, sarebbe più efficace effetuare un controllo sull'errore relativo, ovvero
$
  abs(x^*-x_i)/abs(x^*) lt.eq "tol"
$ 
Per rendere la scelta del criterio d'arresto "automatica", potremmo passare a un criterio del tipo:
$
  abs(x_(i+1) - x_i) lt.eq (1+abs(x_i)) dot "tol"
$
ovvero
$
  abs(x_(i+1)-x_i)/(1+abs(x_i)) lt.eq "tol"
$
Pertanto, si ottiene approssimativamente un criterio di arresto basato sull'errore assoluto, se $x_i approx 0$, ovvero, sull'errore relativo se $abs(x_i) >> 1$. Questo criterio di arresto, pertanto, si autoscala in base alla radice a cui si sta convergendo.

#observation()[
  Questo criterio _deve_ essere usato negli elaborati finali.
]

== Il caso di radici multiple
Vediamo come ovviare al degrado dell'ordine di convergenza del metodo di Newton verso radici multiple (è un problema malcondizionato). Si distinguono, a riguardo, i seguenti due casi significativi:
- Molteplicità radice nota.
- Molteplicità radice incognita.

#[
  #set heading(numbering: none, outlined: false)
  === La molteplicità della radice è nota
]
Se $f(x)$ ha una radice $x^*$ di molteplicità $m>1$, ciò significa che $f(x^*)=f'(x^*)=...=f^(m-1)(x^*)=0 and f^m (x^*)eq.not 0$. In questo caso si può vedere che :
$
  f(x) = (x-x^*)^m g(x)
$
con $g(x)$ una funzione tale che $g(x^*)eq.not 0$. Nel caso più semplice, $g(x)=c="costante"$, vediamo cosa succede se applichiamo il metodo di Newton a $f(x)=c dot (x-x^*)^m$:
$
  x_(i+1) = x_i - overparen(c dot (x_i-x^*)^m, =f(x_i))/underparen(m dot c dot (x_i - x^*)^(m-1), =f'(x_i)) = x_i - m dot (x_i - x^*)/m = x^*
$
Invece, se utilizzassimo l'iterazione:
$
  x_(i+1)=x_i - m dot (f(x_i))/(f'(x_i)) =x_i - m dot (x_i - x^*)/m = x^*
$
Nel caso generale, si dimostra che l'iterazione (primi due passaggi del blocco precedente) ripristina la convergenza quadratica del metodo di Newton. Essa è quella del *metodo di Newton modificato*. Osserviamo che il costo di iterazione rimane lo stesso di quello del metodo di Newton (ovvero 1 valutazione di $f(x)$ + 1 di $f'(x)$).

#[
  #set heading(numbering: none, outlined: false)
  === La molteplicità della radice è incognita
]
In questo caso, se definiamo l'errore al passo $i$, $e_i=x^*-x_i$, che
$
  lim_(i->infinity) (e_(i+1))/e_i = (m-1)/m " con " m " molteplicità (incognita di "x^*")"
$
Pertanto, anche se $m$ non è nota, sappiamo che per $i>>1$:
$
  (e_(i+1))/e_i approx c => e_(i+1) = c dot e_i " e " e_i = c dot e_(i-1)
$
da cui otteniamo, dividendo membro a membro, che:
$
  (e_(i+1))/e_i approx (e_i)/e_(i-1)
$
ovvero $e_(i+1) dot e_(i-1) approx e_i^2$ che significa che:
$
  (x_i^* - x_(i+1))(x_i^* -x_(i-1)) = (x_i^* - x_i)^2
$
da cui otteniamo:
$
  (x_i^*)^2 -(x_(i+1)+x_(i-1)) dot x_i^* + x_(i+1) dot x_(i-1) = (x_i^*)^2 - 2x_i x_i^* + x_i^2\

  x_i^*=frac(x_(i+1)-x_(i-1)-x_i^2, x_(i+1)-2x_i+x_(i-1))
$
Questa iterazione definisce una procedura a 2 livelli: 
$
  x_0 overshell(-->, "Newton") x_i overshell(-->, "Newton") x_i => x_1^* " da cui ripeto i due passi di Newton"
$
Quindi, il costo per iterazione è doppio rispetto al metodo di Newton _standard_. Il vantaggio è che si può dimostrare che la successione ${x_i^*}$ converge quadraticamente a $x^*$ (anche se la convergenza rimane di tipo locale). Questa procedura a 2 livelli definisce il *metodo di accelerazione di Aitken*.
#figure(
  table(
    columns: 4,
    rows: 9,
    table.cell($f(x)=(x-1)^(10) dot e^x$, colspan: 4),
    [it],[Newton],[Newton modificato],[Aitken],
    [0],[0],[0],[0],
    [1],[1.111111111111111e-01],[1.111111111111111e+00],[9.111111111111099e-01],
    [2],[2.086720867208672e-01],[1.001221001221001e+00],[9.992895975197171e-01],
    [3],[2.946049884277536e-01],[1.000000149066197e+00],[9.999999545628913e-01],
    [4],[3.704979405704750e-01],[1.000000000000002e+00],[1.000000244342852e-00],
    [5],[4.376770876576362e-01],[1.000000000000000e+00],[1.000000090874212e+00],
    [6],[4.972598543829098e-01],[1.000000000000000e+00],[1.000000000000000e+00],
  ),
  caption: "Esempio di come Newton modificato e Aitken portino ad ottenere il valore della radice più velocemente del metodo di Newton standard.",
)

== Metodi quasi Newton
Ricordiamo che nel metodo di Newton $x_(i+1) = x_i - (f(x_i))/(f'(x_i))$ con un costo di valutazione pari a 2. Questo risultato può essere migliorato lavorando sulla derivata prima al denominatore.
#figure(image("images/2025-10-22-16-34-46.png"))
Ricordiamo la definizione di derivata prima:
$
  f'(x_i) = lim_(h->infinity) frac(f(x_i+h)-f(x_i), h)
$
Se approssimiamo $f'(x_i)$ con frac(f(x_i+h)-f(x_i), h) con $h$ fissato, otterremo un'approssimazione del metodo di Newton: si parla, in questo caso, di un metodo *"quasi" Newton*. Nello specifico, otterremmo un metodo "quasi" Newton che ha un costo di 2 valutazioni funzionali per iterazione. Per migliorare questo approccio, procediamo come segue.
#[
  #set heading(numbering: none, outlined: false)
  === Metodo delle secanti
]
#figure(image("images/2025-10-22-16-37-49.png"))
Consideriamo la retta secante il grafico di $f(x)$ nei due punti $(x_i, f(x_i))$ e $(x_(i-1), f(x_(i-1)))$, il cui coefficiente angolare è dato dal seguente rapporto incrementale:
$
  frac(f(x_i)-f(x_(i-1)), x_i - x_(i-1)) approx f'(x_i)
$
Questa approssimazione della derivata prima definisce il *metodo delle secanti*:
$
  x_(i+1) = x_i - frac(f(x_i), f(x_i)-f(x_(i+1))) (x_i - x_(i+1)), space i=1,2,...
$

#observation(
  )[
  + Il metodo richiede due approssimazioni iniziali per essere innescato (metodo a due passi).
  + Il costo per iterazione è di 1 valutazione funzionale eccetto la valutazione iniziale in cui ne facciamo 2.
  + L'ordine di convergenza verso radici semplici è:
    $
      p=frac(sqrt(5)+1, 2) approx 1,618
    $
    La convergenza verso radici multiple è, al pari del metodo di Newton, *solo lineare*. Trattandosi di un approssimazione del metodo di Newton, la sua convergenza è, generalmente, locale.
]


#[
  #set heading(numbering: none, outlined: false)
  === Metodo delle corde
]
#figure(image("images/2025-10-22-16-43-55.png"))
Per i passi successivi si utilizza l'approssimazione $f'(x_i) approx f'(x_0)$. L'espressione del metodo delle corde è pertanto:
$
  x_(i+1) = x_i - frac(f(x_i), f'(x_i)) space i=1,2,...
$ 
e richiede una valutazione per iterazione. La sua convergenza è ovviamente locale e l'ordine di convergenza si vede essere 1 (convergenza lineare). E' spesso utilizzato in problemi per cui è nota un'approssimazione iniziale $x_0$ molto vicina alla soluzione $x^*$.
