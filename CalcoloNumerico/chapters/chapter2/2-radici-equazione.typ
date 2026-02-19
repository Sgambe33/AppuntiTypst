#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/algo:0.3.6": algo
#import "@preview/in-dexter:0.7.2": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#pagebreak()

#show math.equation: set block(breakable: true)
= Radici di un'equazione

Data una funzione $f:[a,b] subset.eq RR -> RR$ vogliamo determinare $x^* in [a,b]$ tale che $f(x^*)=0$. In questo caso, diremo che $x^*$ è una #index("Radice di funzione")*radice* (o uno *zero*) di $f(x)$. In generale, $x^*$:
+ la radice può esistere ed essere unica.
+ può esistere ma non essere unica (es. $f(x)=sin x$).
+ oppure non esiste (es. $f(x)=e^x$).

I metodi che esamineremo forniscono — se esiste — l'approssimazione di una sola radice. Una caratteristica comune a tutti questi metodi è quella di essere metodi di tipo iterativo. Questo significa che, a partire da un'approssimazione iniziale $x_0$, sarà prodotta una successione di approssimazioni, ${x_n}_(n gt.eq 0)$ che, se il metodo è *convergente*, converge alla radice $x^*$:
$
  lim_(n -> infinity) x_n = x^*
$
Di seguito introduciamo il primo metodo: il metodo di bisezione.

== Metodo di bisezione
#index("Metodo di bisezione")
Assumiamo che:
+ $f(x)$ sia continua su $[a,b]$;
+ $f(a)f(b)<0$.

#figure(
  canvas({
    import draw: content
    plot.plot(
      size: (15, 8),
      x-tick-step: .1,
      y-tick-step: .1,
      y-min: -0.3,
      y-max: 0.4,
      plot-style: (stroke: black),
      min: -.1,
      legend: "inner-north-east",
      {
        let func = x => calc.pow(calc.exp(1), -x) - 0.588
        plot.add(func, domain: (0, +1), label: $f(x)$, style: (stroke: blue))
        plot.add-hline(0, style: (stroke: black))
        plot.add-vline(.05, .25, .36, .45, .475, .56, .59, .6, .7, .705, .95, min: -0.01, max: 0.01)
        plot.annotate({
          content((.55, .025), $x^*$)
        })
      },
    )
  }),
  caption: "Radice di una funzione",
)

Per il teorema degli zeri di funzioni continue, sappiamo che $exists x^* in [a,b]: f(x^*)=0$. Non conoscendo la posizione precisa della radice, una prima approssimazione naturale è il punto medio:
$
  x_1 = (a+b)/2
$
Valutando $f(x_1)$ si hanno tre casi:
+ $f(x_1)=0$ allora $x^*=x_1$ e abbiamo finito;
+ se $f(a)f(x_1)<0$ allora la radice è in $[a,x_1]$ e si ripete la procedura su quell'intervallo;
+ altrimenti la radice è in $[x_1,b]$ e si ripete su quest'ultimo intervallo.

Il nome del metodo deriva dal fatto che, ad ogni iterazione, l'ampiezza dell'intervallo di incertezza si dimezza.

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
)
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

Il criterio di arresto sopra commentato rende l'intera implementazione _naive_ e poco efficiente:
- non sempre è richiesto un calcolo *esatto* della radice ma solo quello di una sua approssimazione entro una tolleranza `tol`;
- la condizione `f1 == 0` potrebbe non essere mai soddisfatta a causa dell'aritmetica finita.
  #example()[Consideriamo il polinomio
    $
      p(x) = (x-1.1)^20 (x-pi)
    $
    Dal punto di vista matematico è ovvio che ha radice esatta in $x=pi$. Se proviamo a calcolare $p(pi)$ utilizzando Matlab, si ottiene:
    $
      p = "poly"([1.1 * "ones"(1,20),pi])\
      "polyval"(p, pi) approx -5,5213 dot 10^(-5)
    $
    La funzione `poly` restituisce i coefficienti del polinomio le cui radici sono in argomento alla funzione. Nel nostro caso calcola i coefficienti svolgendo il prodotto:
    $
      underbrace((x-1.1) dot (x-1.1) dot ..., 20) dot (x-pi)
    $
    La funzione `polyval` prende i coefficienti appena calcolati e valuta il polinomio in $pi$. Durante il calcolo dei coefficienti però, il calcolatore ha subito diversi errori di arrotondamento portando ad un valore finale non esatto.
  ]

== Criteri di arresto e condizionamento

Vediamo come migliorare la precedente computazione _naive_. Se inizializziamo $a_1=a$ e $b_1=b$ (l'ampiezza del primo intervallo di confidenza) allora al passo i-esimo:
$
  x_i = (a_i+b_i)/2
$
che è il punto medio dell'intervallo di confidenza $[a_i, b_i]$ al passo corrente. Pertanto $x^* in [a_i, b_i]$ e:
$
  abs(x^*-x_i) lt.eq (b_i-a_i)/2 = (b_(i-1)-a_(i-1))/2^2 = (b_(i-2)-a_(i-2))/2^3 = ... = (b_1-a_1)/2^i = (b-a)/2^i
$

Da questo argomento, deduciamo che, se desideriamo un'approssimazione della soluzione con accuratezza `tol` la potremo conseguire in un numero di iterazioni, `imax`, dato da:
$
  (b-a)/2^i lt.eq "tol" => (b-a)/"tol" lt.eq 2^i => i gt.eq log_2(b-a)/"tol"
$
Pertanto, imponendo
$
  "imax"=ceil log_2(b-a)-log_2("tol") ceil.r
$
questo è il numero massimo di iterazioni di cui avremo bisogno. Questo ci permette di riformulare il ciclo precedente come:

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: false,
)
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

#figure(canvas({
  import draw: content, rect
  plot.plot(
    axis-style: "school-book",
    size: (15, 8),
    x-tick-step: none,
    y-tick-step: none,
    y-min: -1.25,
    y-max: 1.25,
    x-min: calc.pi - 1,
    x-max: 2 * calc.pi + 1,
    plot-style: (stroke: black),
    legend: "inner-north-east",
    {
      let func = x => calc.cos(x)
      plot.add(func, domain: (calc.pi, 2 * calc.pi), label: $f(x)$, style: (stroke: colors.at(10)))
      plot.add-hline(0.0, style: (stroke: black))
      plot.add-hline(-0.1, min: calc.pi - 1.05, max: 1.5 * calc.pi - .15, style: (stroke: colors.at(8)))
      plot.add-hline(0.1, min: calc.pi - 1.05, max: 1.5 * calc.pi + .15, style: (stroke: colors.at(8)))
      plot.add-vline(1.5 * calc.pi - .15, min: -0.1, max: 0.03, style: (stroke: colors.at(8)))
      plot.add-vline(1.5 * calc.pi + .15, min: -0.03, max: 0.1, style: (stroke: colors.at(8)))
      plot.add-vline(1.5 * calc.pi, min: -0.03, max: 0.03, style: (stroke: red))

      plot.annotate({
        content((1.5 * calc.pi, -.1), colmath(1, $x^*$))
      })
      plot.annotate({
        rect((calc.pi - 1.04, -0.1), (calc.pi - 0.94, 0.1), fill: rgb("#eaff0075"), stroke: none)
        content((calc.pi - 1.075, 0.075), "o")
      })
      plot.annotate({
        rect((1.5 * calc.pi - .15, -.05), (1.5 * calc.pi + .15, +.05), fill: rgb("#eaff0075"), stroke: none)
      })
    },
  )
}))

Dobbiamo fare attenzione alla distanza verticale ($abs(f(x))$) e orizzontale ($abs(x-x^*)$). Se la funzione è molto "piatta" vicino alla radice, $f(x)$ può essere un valore piccolissimo anche se $x$ è lontano da $x^*$. Al contrario, se la funzione è "ripida", $f(x)$ può essere grande anche se siamo molto vicini a $x^*$.

Per collegare l'errore orizzontale a quello verticale, usiamo lo sviluppo di Taylor al primo ordine centrato nella radice $x^*$.
$
  f(x) = overparen(f(x^*), =0) + f'(x^*)(x-x^*) + o(abs(x-x^*)^2) approx f'(x^*)(x-x^*)
$
Questa formula ci dice che la funzione $f(x)$ (altezza) è approssimativamente uguale alla pendenza della retta tangente ($f'$) moltiplicata per la distanza della radice $(x-x^*)$.
$
  abs(x-x^*) approx frac(abs(f(x)), abs(f'(x^*))) quad quad
$
Si vuole che  l'errore sulla $x$ sia minore della tolleranza `tol`:
$
  abs(x-x^*) <= "tol"
$
Sostituiamo l'approssimazione trovata:
$
  (abs(f(x)))/(abs(f'(x^*))) lt.eq "tol"
$
Moltiplichiamo entrambi i lati per la derivata prima e otteniamo che
$
  abs(f(x)) lt.eq "tol" dot abs(f'(x^*))
$
è quanto dobbiamo richiedere alla $f(x)$. Non basta chiedere che $f(x)$ sia piccolo quanto `tol`. Dobbiamo chiedere che sia piccolo quanto `tol` scalato dalla pendenza della funzione.
- Se la funzione è molto ripida ($f'$ grande, es. 1000), allora `tol` $dot 1000$ è grande. Possiamo accettare un $f(x)$ più grande.
- Se la funzione è molto piatta ($f'$ quasi zero, es. 0.001), allora `tol` $dot 0.001$ è minuscolo. Dobbiamo richiedere un $f(x)$ piccolissimo per essere sicuri di essere vicini alla radice.

Per poter applicare la relazione appena trovata, dovremmo calcolarci $f'(x^*)$, cosa impossibile dato che non conosciamo $x^*$. Nell'iterazione del metodo di bisezione, al passo i-esimo, noi abbiamo calcolato $f(x_i)$, e, inoltre, conosciamo $f(a_i)$ e $f(b_i)$:

#figure(
  canvas({
    import draw: content
    plot.plot(
      x-grid: true,
      y-grid: true,
      size: (14, 8),
      x-tick-step: 1,
      y-tick-step: 1,
      y-min: -5,
      y-max: 5,
      plot-style: (stroke: black),
      legend: "inner-north-east",
      {
        let func = x => -12 + 180 / (x + 11)
        let secante = x => -3 / 4 * x + 15 / 4
        let tangente = x => -4 / 5 * x + 16 / 5
        let func2 = x => 6 // Solo per allargare il grafico!
        plot.add(func2, domain: (0, 10))
        plot.add(func, domain: (1, 9), label: $f(x)$, style: (stroke: blue))
        plot.add(secante, domain: (1, 9), style: (stroke: yellow))
        plot.add(tangente, domain: (1.5, 7.5), style: (stroke: black))

        plot.add-hline(0, style: (stroke: black))
        plot.add-vline(1, 4, 5, 9, min: -0.1, max: 0.1)
        plot.annotate({
          content((1, -.4), $a_i$)
          content((4, -.4), $x^*$)
          content((5, .4), $x_i$)
          content((9, -.4), $b_i$)
          content((1, 3.5), $f(a_i)$)
          content((9, -3.5), $f(b_i)$)
        })
        plot.add(
          ((1, 3), (9, -3)),
          style: (stroke: none),
          mark: "o",
        )
      },
    )
  }),
)

Questo significa che possiamo approssimare $f'(x^*)$ come segue:
$
  f'(x^*) approx (f(b_i)-f(a_i))/(b_i-a_i)
$
senza valutazioni di funzione aggiuntive.


Questo ci permette di ottenere questa versione ottimizzata del metodo di bisezione in cui sono solo omessi i controlli di consistenza sui parametri di ingresso.

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
)
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

Definiamo l'errore assoluto al passo $i$-esimo come la distanza tra la radice vera $x^*$ e la nostra approssimazione $x_i$:
$
  e_i = x^* - x_i
$
Per come è costruito il metodo di bisezione (che dimezza l'intervallo ad ogni passo), sappiamo che l'errore è sempre limitato dalla semi-ampiezza dell'intervallo corrente:
$
  abs(e_i) lt.eq epsilon_i = (b-a)/2^i
$
Vogliamo vedere come decresce questa limitazione dell'errore passando dal passo $i$ al passo successivo $i+1$. Calcoliamo il rapporto tra le due limitazioni:
$
  epsilon_(i+1)/epsilon_i = frac(frac(b-a, 2^(i+1)), frac(b-a, 2^i)) = frac(b-a, 2^(i+1)) dot frac(2^i, b-a) = frac(2^i, 2^(i+1)) = frac(2^i, 2^i dot 2) = 1/2
$
il che implica che:
$
  lim_(i-> infinity) epsilon_(i+1)/epsilon_i =1/2
$
#observation()[
  Questo dimostra che, nel metodo di bisezione, la stima del massimo errore possibile si dimezza esattamente ad ogni iterazione.
]

#definition()[
  Generalizzando, un qualsiasi metodo iterativo si dice #index("Convergente")*convergente* se l'errore tende a zero man mano che si procede con le iterazioni:
  $
    lim_(i -> infinity) e_i = 0
  $
]

#observation()[
  Il metodo di bisezione, se applicabile, è *sempre* convergente.
  $
    lim_(i->infinity) frac(b-a, 2^i) = 0
  $
]

Per classificare l'efficienza dei metodi di approssimazione, dobbiamo introdurre il concetto di #index("Ordine di convergenza") *ordine di convergenza*.
#definition()[
  Si dice che un metodo ha ordine $p$ se $p$ è il più grande numero reale positivo tale che esista un limite finito non nullo:
  $
    lim_(i -> infinity) abs(e_(i+1))/abs(e_i)^p = c < infinity space space space (1)
  $
  Dove $c$ è detta *costante asintotica dell'errore*.
]
Cerchiamo di dare un significato alla definizione di ordine descritto dalla (1). Per $i>>1$, possiamo scrivere che:
$
  abs(e_(i+1)) approx c dot abs(e_i)^p space space space (2)
$
Questa relazione ci dice come l'errore futuro dipende dall'errore attuale. Analizziamo i casi in base a $p$:
+ Se $p<1$: il metodo non converge in quanto l'errore tenderebbe ad aumentare. Affinché si abbia convergenza, bisogna avere $p gt.eq 1$.
  #observation()[
    In particolare, se $p=1$, si parlerà di *convergenza lineare*, se $p=2$, si parlerà di *convergenza quadratica* e così via.
  ]

+ Se $p=1$: per $i>>1$:
  $
    & abs(e_(i+1)) approx c dot abs(e_i) \
    & abs(e_(i+2)) approx abs(e_(i+1)) approx c^2 dot abs(e_i) \
    & quad quad quad quad quad dots.v \
    & abs(e_(i+k)) approx c^k dot abs(e_i)
  $
  Affinché l'errore vada a zero ($e_(i+k) -> 0 "per" k->infinity$) è necessario che $c<1$. Pertanto un metodo di ordine 1 è *convergente* se e solo se la sua *costante asintotica* dell'errore è minore di 1.

  #observation()[
    Il metodo di bisezione ha ordine 1, con costante asintotica dell'errore pari a $1/2$.
  ]

+ Se $p > 1$ (es. Convergenza Quadratica $p=2$): l'errore al passo successivo è proporzionale a una potenza dell'errore corrente. Se l'errore è piccolo (es. $10^(-3)$), elevarlo a potenza (es. al quadrato) lo rende minuscolo ($10^(-6)$).
  #example()[
    Supponiamo di avere 2 metodi, uno di ordine $p=1$ e l'altro di ordine $p=2$. Supponiamo anche che, per entrambi, la costante asintotica dell'errore sia $c=0.1$ e che l'errore da cui partiamo sia, sempre per entrambi, $abs(e_0) = 0.1$. Otteniamo, premesso che la (2) valga a partire da $i=0$:

    #align(center, table(
      align: center,
      columns: 3,
      rows: 6,
      [$i$], [$e_i space (p=1)$], [$e_i space (p=2)$],
      [0], [$10^(-1)$], [$10^(-1)$],
      [1], [$10^(-2)$], [$10^(-3)$],
      [2], [$10^(-3)$], [$10^(-7)$],
      [3], [$10^(-4)$], [$10^(-15)$],
      [$dots.v$], [$dots.v$], [$dots.v$],
    ))
    Da questo semplice esempio si comprende che è bene ricercare metodi di ordine più elevato.
  ]

Preliminarmente, discutiamo il *condizionamento del problema*. Il nostro obiettivo è cercare $x^*$ tale che $f(x^*)=0$, che è la soluzione del problema che ci prefiggiamo di risolvere. Se, invece di $x^*$, abbiamo una soluzione perturbata $tilde(x)$, tale che $f(tilde(x)) approx 0$ (non è sol. esatta ma rende la funzione quasi zero), allora siamo interessati a capire quanto la differenza
$
  f(tilde(x)) - overbrace(f(x^*), =0) = f(tilde(x))
$
che rappresenta l'errore sull'asse Y,
si ripercuote sull'errore $tilde(x) - x^*$ (asse X). Sviluppando $f(tilde(x))$ con Taylor centrato nella radice vera $x^*$:
$
  f(tilde(x)) = overbrace(f(x^*), =0) + f'(x^*)(tilde(x)-x^*)+o((tilde(x)-x^*)^2) approx f'(x^*)(tilde(x)-x^*)
$
Isolando l'errore sull'asse $X$ otteniamo:
$
  abs(tilde(x) - x^*) approx abs(f(tilde(x)))/abs(f'(x^*))
$
In questa relazione:
+ $abs(f(tilde(x)))$ è la perturbazione del valore $emptyset$ che dovremmo avere;
+ $abs(tilde(x)-x^*)$ è l'errore determinato da tale perturbazione;
+ $k=1/abs(f'(x^*))$ è il *numero di condizionamento* del problema.

- *Problema ben condizionato* ($abs(f'(x^*))>>1$): se la derivata è grande (la funzione è "ripida"), allora $k$ è piccolo.
- *Problema mal condizionato* ($abs(f'(x^*))approx 0$): se la derivata è quasi zero (la funzione è "piatta"), allora $k$ è molto grande e l'errore si amplifica.

#definition()[
  Una radice $x^*$ ha *molteplicità* $m gt.eq 1$ se la funzione e le sue prime $m-1$ derivate si annullano in quel punto, ma la derivata $m$-esima no:
  $
    f(x^*) = f'(x^*) = dots = f^(m-1)(x^*) = 0 quad "e" quad f^(m)(x^*) eq.not 0
  $
  Distinguiamo due casi:
  - *Radice Semplice* ($m=1$): vale $f(x^*) = 0$ ma $f'(x^*) eq.not 0$.
  - *Radice Multipla* ($m gt.eq 2$): vale $f(x^*) = 0$ e necessariamente $f'(x^*) = 0$.
]

#observation()[
  Poiché per una radice multipla la derivata prima è nulla ($f'(x^*) = 0$), il numero di condizionamento $k = 1/abs(f'(x))$ tende all'infinito. Di conseguenza possiamo affermare che l'approssimazione di una radice *multipla* dà origine ad un problema *sempre malcondizionato*.

]

== Metodo di Newton
#figure(
  canvas({
    import draw: content
    plot.plot(
      x-grid: true,
      y-grid: true,
      size: (14, 8),
      x-tick-step: 1,
      y-tick-step: 1,
      y-min: -2,
      y-max: 6,
      plot-style: (stroke: black),
      legend: "inner-north-east",
      {
        let func = x => -4 - 36 / (x - 12)
        let tangente = x => 9 / 4 * x - 13
        let tangente2 = x => 0.9299 * x - 3.587
        plot.add(func, domain: (-1, 9), label: $f(x)$, style: (stroke: blue))
        plot.add(tangente, domain: (-1, 9), style: (stroke: red))
        plot.add(tangente2, domain: (-1, 9), style: (stroke: green))


        plot.add-hline(0, style: (stroke: black))
        plot.add-vline(3, 3.587 / 0.9299, 5.7778, 8, min: -0.1, max: 0.1)
        plot.annotate({
          content((3, -.4), $x^*$)
          content((8, -.4), $x_0$)
          content((5.9, -.4), $x_1$)
          content((3.587 / 0.9299, -.4), $x_2$)
        })
        plot.add(
          ((52 / 9, 1.7857143), (8, 5)),
          style: (stroke: none),
          mark: "o",
        )
      },
    )
  }),
)

L'equazione della retta tangente al grafico di $f(x)$ in $(x_0, f(x_0))$ è;
$
  cases(y-f(x_0) = f'(x_0)(x-x_0)", tangente", y=0", intersezione asse x")
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
#theorem()[
  Sia $f(x) in C^2$ in un intorno della radice $x^*$. Supponiamo che il metodo di Newton converga a $x^*$ e che $x^*$ sia semplice. Allora l'ordine di convergenza è (almeno) 2.
]
#proof()[
  Indichiamo con $x^*$ la radice verso cui l'iterazione sta convergendo. Scriviamo lo sviluppo di Taylor della funzione $f$ centrato nel punto corrente $x_i$ e valutato nel punto esatto $x^*$:
  $
    0 = f(x^*) & =f(x_i)+f'(x_i)(x^*-x_i)+1/2 f''(epsilon_i)(x^*-x_i)^2 \
               & = f'(x_i)(underbrace(f(x_i)/(f'(x_i)) - x_i, "passo i+1 Newton") + x^*) + 1/2 f''(epsilon_i)(x^*-x_i)^2 \
               & =^((3)) f'(x_i)underbrace((x^* - x_(i+1)), e_(i+1)) + 1/2 f''(epsilon_i)underbrace((x^*-x_i), e_i)^2
  $
  - Sappiamo che $f(x^*) = 0$ (perché $x^*$ è la radice).
  - $epsilon_i$ è un punto sconosciuto che si trova tra $x_i$ e $x^*$ (Resto di Lagrange).
  Tenendo conto della (3) e per la definizione di errore al passo i-esimo ($e_i =x^*-x_i$) si ottiene:
  $
    e_(i+1)/(e_i)^2 = -1/2 (f''(epsilon_i))/(f'(x_i))
  $
  che è ben definita in un intorno di $x^*$ essendo, per ipotesi, $f'(x^*) eq.not 0$. Se il metodo è convergente ($x_i -> x^*$), anche il punto intermedio $epsilon_i$ (compreso tra $x_i$ e $x^*$) tende a $x^*$:
  $
    lim_(i -> infinity) abs(e_(i+1))/abs(e_i)^2 = lim_(i -> infinity) 1/2 abs(f''(epsilon_i))/abs(f'(x_i))
    = 1/2 abs(f''(x^*))/abs(f'(x^*))
  $
  da cui deduciamo che il metodo ha *convergenza quadratica* ovvero $p=2$.
]

Nel caso di una radice multipla, con molteplicità $m>1$, si può dimostrare che:
$
  lim_(i-> infinity) e_(i+1)/e_i
  = (m-1)/m
$
ovvero, l'ordine di convergenza del metodo di Newton diventa *lineare*, come conseguenza del mal condizionamento del problema e quindi il teorema non vale più.

//21.10.2025
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

#example()[
  Ad esempio, se consideriamo
  $
    f(x) = x^3 -5x = x(x^2-5)
  $
  che ha 3 radici, $0$, $plus.minus sqrt(5)$, tutte semplici. Se consideriamo $x_0=1$, allora generiamo la successione di approssimazioni
  $
    1,-1,1,-1,...
  $
  che, evidentemente, non converge.
  #figure(
    canvas({
      import draw: content
      plot.plot(
        x-grid: true,
        y-grid: true,
        size: (14, 8),
        x-tick-step: .5,
        y-tick-step: 1,
        y-min: -5,
        y-max: 5,
        plot-style: (stroke: black),
        legend: "inner-north-east",
        {
          let func = x => calc.pow(x, 3) - 5 * x
          let func2 = x => -2 * x + 2
          let func3 = x => -2 * x - 2
          plot.add(func, domain: (-2.5, 2.5), label: $f(x)=x^3-5x$, style: (stroke: blue))
          plot.add(func2, domain: (-1, 1), style: (stroke: fuchsia))
          plot.add(func3, domain: (-1, 1), style: (stroke: fuchsia))

          plot.add-hline(0, style: (stroke: black))
          plot.add-vline(-1, max: 4, min: 0, style: (stroke: (dash: "dashed")))
          plot.add-vline(1, max: 0, min: -4, style: (stroke: (dash: "dashed")))
          plot.annotate({
            content((-1, -.4), $-1$)
            content((1, .4), $1$)
          })
          plot.add(
            ((1, -4), (-1, 4)),
            style: (stroke: none),
            mark: "o",
          )
        },
      )
    }),
  )
]

La conclusione di questo esempio è che la convergenza ad una radice è garantita, per il metodo di Newton, solo in un opportuno intorno della radice. Si parla in questo caso, di #index("Convergenza locale")*convergenza di tipo locale* mentre, per il metodo di bisezione, la #index("Convergenza globale")*convergenza è globale*, ovvero, avviene sempre, se il metodo è applicabile.

Cerchiamo di formalizzare questo concetto, per un generico metodo iterativo che denoteremo con
$
  x_(i+1) = Phi(x_i), space i=0,1,... space space space (1)\
  x_0 -> x_1 = Phi(x_0) -> x_2 = Phi(x_1) -> ...
$
in cui $Phi(x)$ è detta *funzione di iterazione*. Ad esempio, per il metodo di Newton
$
  Phi(x) = x-f(x)/(f'(x))
$
Se il metodo iterativo (1) serve per determinare la radice $x^*$ di $f(x)$, allora $Phi(x)$ deve soddisfare la #index("Proprietà di consistenza")*proprietà di consistenza*:
$
  x^* = Phi(x^*) space space space (2)
$
che garantisce che, se raggiungiamo la radice, ci fermiamo. Questo significa che il problema di determinare lo zero di $f(x)$ equivale a trovare un *punto fisso* della funzione di iterazione $Phi(x)$. Pertanto, vogliamo vedere sotto quali condizioni per $Phi(x)$, partendo da un intorno del suo punto fisso (2), la successione di approssimazioni (1) converge a $x^*$. Vale il seguente risultato.

#theorem()[
  Sia $x^*$ un punto fisso della funzione di iterazione $Phi(x)$ (ovvero $x^* = Phi(x^*)$). Supponiamo che esista un intorno circolare $I = [x^* - delta, x^* + delta]$ con $delta > 0$ tale che $Phi$ sia *Lipschitziana* in $I$ con costante $L < 1$. Ovvero:
  $
    |Phi(x) - Phi(y)| lt.eq L dot |x - y| quad forall x, y in I
  $
  Se le ipotesi sono verificate, allora valgono le seguenti proprietà:
  + $x^*$ è l'unico punto fisso di $Phi(x)$ all'interno dell'intervallo $I$.
  + Se il punto iniziale $x_0$ appartiene a $I$ ($x_0 in I$), allora tutta la successione generata $x_i$ rimarrà contenuta in $I$ per ogni $i gt.eq 0$.
  + La successione converge alla soluzione:
    $
      lim_(i-> infinity) x_i = x^*
    $
]
#proof()[
  $
    x_i in I(x^*) <=> abs(x^* - x_i) lt.eq delta
  $
  Ragionando per induzione, se $x_0 in I(x^*)$, allora $abs(x^* - x_0) lt.eq delta$. Di conseguenza:
  $
    abs(x^* - x_1) = abs(Phi(x^*)-Phi(x_0)) lt.eq L abs(x^* - x_0) lt delta => x_1 in I(x_*)
  $
  Vogliamo dimostrare che la distanza tra la nostra stima corrente $x_i$ e la soluzione vera $x^*$ diventa sempre più piccola man mano che andiamo avanti con le iterazioni ($i -> infinity$).
  $
    abs(x^* - x_i) & = abs(Phi(x^*)-Phi(x_(i-1))) \
    abs(x^* - x_i) & lt.eq L abs(x^* - x_(i-1))
  $
  Ma sappiamo che anche $|x^* - x_(i-1)| lt.eq L dot |x^* - x_(i-2)|$. Allora, sostituendo e ripetendo i passaggi:
  $
    |x^* - x_i| & lt.eq L dot underbrace((L dot |x^* - x_(i-2)|), "sostituzione") = L^2 dot |x^* - x_(i-2)| \
    |x^* - x_i| & lt.eq L dot L dot (L dot |x^* - x_(i-3)|) = L^3 dot |x^* - x_(i-3)| \
                & dots.v \
    |x^* - x_i| & lt.eq L^i abs(x^* - x_0)
  $
  Analizziamo il termine $L^i$ per $i -> infinity$: poiché per ipotesi $0 lt.eq L < 1$, una potenza di un numero minore di 1 tende a zero quando l'esponente cresce. Di conseguenza, anche l'errore deve tendere a zero:
  $
    lim_(i -> infinity) L^i abs(x^* - x_0) = 0 => lim_(i -> infinity) |x^* - x_i| = 0 => lim_(i -> infinity) x_i = x^*
  $
]

#corollary()[
  Se $exists delta > 0 : forall x in overbrace([x^*-delta, x^*+delta], =I(x^*))$, $abs(Phi'(x)) lt.eq L<1$, allora $x_(i+1)=Phi(x_i)$ converge a $x^*$, per $i-> infinity$.
]
#proof()[
  $forall x,y in I(x^*)$ e per lo sviluppo di Taylor centrato in $x$ ma calcolato in $y$ con resto al primo ordine segue dunque:
  $
    abs(Phi(x)-Phi(y)) = abs(cancel(Phi(x)) - cancel(Phi(x)) - Phi'(epsilon)(x-y)) = abs(Phi'(epsilon)) dot abs(x-y) < L abs(x-y), space "con " L<1
  $
  Pertanto vale il precedente teorema.
]

Vediamo come si applica questo risultato al metodo di Newton:
$
  Phi(x) = x-f(x)/(f'(x)) quad quad
  Phi(x^*) = x^*-overparen(f(x^*), = 0)/(f'(x^*)) = x^*
$
Se $x^*$ è una radice semplice, allora $f'(x^*) eq.not 0$ e
$
  Phi'(x^*) = [ 1-(f'(x)^2 - f''(x)f(x))/(f'(x)^2) ] lr(bar, size: #300%)_(x=x^*) = [ (f''(x)overparen(f(x), =0))/(f'(x)^2) ] lr(bar, size: #300%)_(x=x^*) = (f''(x^*)overparen(f(x^*), =0))/(f'(x^*)^2) = 0
$
//TODO: migliorare questo grafico
#figure(canvas({
  import draw: content, rect
  plot.plot(
    axis-style: "school-book",
    size: (15, 8),
    x-tick-step: none,
    y-tick-step: none,
    y-min: -1,
    y-max: 1,
    x-min: calc.pi - 1,
    x-max: 2 * calc.pi + 1,
    plot-style: (stroke: black),
    legend: "inner-north-east",
    {
      let func = x => calc.cos(x) * 0.5
      plot.add(func, domain: (calc.pi, 2 * calc.pi), label: $Phi'(x)$, style: (stroke: colors.at(10)))
      plot.add-hline(0.0, style: (stroke: black))
      plot.add-hline(-0.1, min: calc.pi - 1.05, max: 1.5 * calc.pi - .15, style: (stroke: colors.at(8)))
      plot.add-hline(0.1, min: calc.pi - 1.05, max: 1.5 * calc.pi + .15, style: (stroke: colors.at(8)))
      plot.add-vline(1.5 * calc.pi - .15, min: -0.1, max: 0.03, style: (stroke: colors.at(8)))
      plot.add-vline(1.5 * calc.pi + .15, min: -0.03, max: 0.1, style: (stroke: colors.at(8)))
      plot.add-vline(1.5 * calc.pi, min: -0.03, max: 0.03, style: (stroke: red))

      plot.annotate({
        content((1.5 * calc.pi, -.1), colmath(1, $x^*$))
        content((.62 * calc.pi, .1), colmath(1, $L$))
        content((.6 * calc.pi, -.1), colmath(1, $-L$))
      })
      plot.annotate({
        rect((1.5 * calc.pi - .15, -.05), (1.5 * calc.pi + .15, +.05), fill: rgb("#eaff0075"), stroke: none)
      })
    },
  )
}))
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
per determinare uno zero di $f(x)$, cerchiamo un criterio di arresto idoneo per l'iterazione. Esaminiamo, in particolare, il metodo di Newton. Come discusso per il metodo di bisezione, un controllo basato esclusivamente su $f(x_i)$ è insufficiente se non rapportato alla derivata prima della funzione nel punto. La condizione di arresto ideale è:
$
  abs(f(x_i))/abs(f'(x_i)) lt.eq "tol"
$
Nel caso specifico del metodo di Newton si ha che:
$
  x_(i+1) = x_i - frac(f(x_i), f'(x_i)) => x_(i+1) - x_i = - frac(f(x_i), f'(x_i)) => abs(x_(i+1) - x_i) = abs(frac(f(x_i), f'(x_i)))
$
Ovvero il rapporto tra $f(x_i)$ e derivata coincide esattamente con l'ampiezza del passo d'iterazione. Per arrestare l'algoritmo basandosi sulla quantità $abs(x_(i+1) - x_i)$, si possono adottare due metodi, ognuno con i propri limiti:
+ *Criterio errore assoluto*:
  $
    abs(x_(i+1) - x_i) lt.eq "tol"
  $
  Attenzione, se la radice $x^*$ è molto grande in modulo, una `tol` troppo piccola potrebbe risultare irraggiungibile a causa della precisione finita di macchina.

+ *Criterio errore relativo*:
  $
    frac(abs(x_(i+1) - x_i), abs(x_i)) lt.eq "tol"
  $
  Attenzione, questo metodo è instabile quando la successione di approssimazioni si avvicina allo zero. Se $x_i -> 0$ si causerà una divisione per zero.

Per ovviare ai problemi dei due criteri precedenti e ottenerne uno adatto ad ogni scenario, adottiamo un criterio ibrido. Esso è:
$
  abs(x_(i+1)-x_i)/(1+abs(x_i)) lt.eq "tol"
$
- Nel caso di radici nulle o piccole ($x_i approx 0$), il termine $1+abs(x_i) approx 1$. Pertanto il criterio si comporta come un controllo sull'errore assoluto evitando divisioni per zero.

- Nel caso di radici grandi ($abs(x_i) >> 1$), il termine $1+abs(x_i)approx abs(x_i)$. Pertanto il criterio si comporta come un controllo sull'errore relativo.

#observation(multiple: true)[
  - Questo criterio di arresto si autoscala in base alla radice a cui si sta convergendo.
  - Questo criterio *_deve_* essere usato negli elaborati finali.
]

//22.10.2025
== Il caso di radici multiple
Vediamo come ovviare al degrado dell'ordine di convergenza del metodo di Newton verso radici multiple (è un problema mal condizionato). Si distinguono, a riguardo, i seguenti due casi significativi:
- Molteplicità radice nota.
- Molteplicità radice incognita.

=== Metodo di Newton modificato
Se $f(x)$ ha una radice $x^*$ di molteplicità $m>1$, ciò significa che $f(x^*)=f'(x^*)=...=f^(m-1)(x^*)=0$ e $f^m (x^*)eq.not 0$. In questo caso si può vedere che :
$
  f(x) = (x-x^*)^m g(x)
$
con $g(x)$ una funzione tale che $g(x^*)eq.not 0$. Nel caso più semplice, $g(x)=c$ costante, vediamo cosa succede se applichiamo il metodo di Newton a $f(x)=c dot (x-x^*)^m$:
$
  x_(i+1) = x_i - overparen(c dot (x_i-x^*)^m, =f(x_i))/underparen(m dot c dot (x_i - x^*)^(m-1), =f'(x_i)) = x_i - (x_i - x^*)/m
$
Invece, se utilizzassimo l'iterazione:
$
  x_(i+1)=x_i - m dot (f(x_i))/(f'(x_i)) =x_i - m dot (x_i - x^*)/m = x^*
$
Nel caso generale, si dimostra che l'iterazione (primi due passaggi del blocco precedente) ripristina la convergenza quadratica del metodo di Newton. Essa è quella del *metodo di Newton modificato*. Osserviamo che il costo di iterazione rimane lo stesso di quello del metodo di Newton (ovvero 1 valutazione di $f(x)$ + 1 di $f'(x)$).

=== Metodo di accelerazione di Aitken
Supponiamo di voler calcolare la radice $x^*$ di una funzione $f$, ma di non conoscere la molteplicità della radice. Indichiamo con $e_i=x^*-x_i$ l'errore al passo i-esimo. Sappiamo che, se la radice ha molteplicità $m$, allora per il metodo di Newton vale:
$
  lim_(i->infinity) (e_(i+1))/e_i = (m-1)/m " con" m "molteplicità incognita di "x^*
$
cioè la convergenza è *lineare* e non quadratica.

Anche se $m$ non è nota, per $i>>1$ sappiamo che:
$
  (e_(i+1))/e_i approx c
$
ovvero che $e_(i+1) approx c dot e_i$ e $e_i approx c dot e_(i-1)$, da cui otteniamo, dividendo membro a membro, che:
$
  (e_(i+1))/e_i approx (e_i)/e_(i-1) => e_(i+1) dot e_(i-1) approx e_i^2
$
A questo punto, definiamo $x_i^*$ tale che:
$
  (x^*_i - x_(i+1))(x^*_i -x_(i-1)) = (x^*_i - x_i)^2
$
Sviluppando entrambi i membri e semplificando, si ottiene un'equazione di secondo grado dalla quale si ricava:
$
  cancel((x^*:i)^2) -(x_(i+1)+x_(i-1)) x^*_i + x_(i+1) x_(i-1) & = cancel((x^*_i)^2) - 2x_i x^*_i + x_i^2 \
                                    -(x_(i+1)+x_(i-1)+2x_i)x^*_i & = -x_(i+1)x_(i-1)+x_i^2 \
                                                           x^*_i & = frac(x_(i+1)x_(i-1)-x_i^2, x_(i+1)+x_(i-1)+2x_i)
$
Questa quantità fornisce una *stima migliorata della radice vera*.
Il metodo può essere interpretato nel seguente modo:
+ Si applicano due passi del metodo di Newton, ottenendo $x_(i-1), x_i, x_(i+1)$.
+ Usando questi tre valori, si costruisce una nuova approssimazione $x_i^*$ tramite la formula precedente.
+ Il processo può essere ripetuto utilizzando di nuovo il metodo di Newton.
#index("Metodo di Aitken")Questa procedura definisce il *metodo di accelerazione di Aitken*.

#observation()[
  Il costo per iterazione è doppio rispetto al metodo di Newton _standard_. Il vantaggio è che si può dimostrare che la successione ${x_i^*}$ converge quadraticamente a $x^*$ (anche se la convergenza rimane di tipo locale).
]

#example()[
  Esempio di come Newton modificato e Aitken portino ad ottenere il valore della radice più velocemente del metodo di Newton standard.
  #figure(
    table(
      columns: 4,
      rows: 9,
      table.cell($f(x)=(x-1)^(10) dot e^x$, colspan: 4),
      [it], [Newton], [Newton modificato], [Aitken],
      [0], [0], [0], [0],
      [1], [1.111111111111111e-01], [1.111111111111111e+00], [9.111111111111099e-01],
      [2], [2.086720867208672e-01], [1.001221001221001e+00], [9.992895975197171e-01],
      [3], [2.946049884277536e-01], [1.000000149066197e+00], [9.999999545628913e-01],
      [4], [3.704979405704750e-01], [1.000000000000002e+00], [1.000000244342852e-00],
      [5], [4.376770876576362e-01], [1.000000000000000e+00], [1.000000090874212e+00],
      [6], [4.972598543829098e-01], [1.000000000000000e+00], [1.000000000000000e+00],
    ),
  )
]

== Metodi quasi Newton
Ricordiamo il metodo di Newton $x_(i+1) = x_i - (f(x_i))/(f'(x_i))$ con un costo di valutazione pari a 2. Questo risultato può essere migliorato lavorando sulla derivata prima al denominatore.
#figure(
  canvas({
    import draw: content
    plot.plot(
      x-grid: true,
      y-grid: true,
      size: (14, 8),
      x-tick-step: 1,
      y-tick-step: 1,
      y-min: -2,
      y-max: 6,
      plot-style: (stroke: black),
      legend: "inner-north-east",
      {
        let func = x => -4 - 36 / (x - 12)
        let tangente2 = x => 0.9299 * x - 3.587
        plot.add(func, domain: (-1, 9), label: $f(x)$, style: (stroke: blue))
        plot.add(tangente2, domain: (-1, 9), style: (stroke: green))


        plot.add-hline(0, style: (stroke: black))
        plot.add-vline(3, 3.587 / 0.9299, 5.7778, min: -0.1, max: 0.1)
        plot.annotate({
          content((3, -.4), $x^*$)
          content((5.9, -.4), $x_i$)
          content((3.587 / 0.9299, -.4), $x_(i+1)$)
        })
        plot.add(
          ((52 / 9, 1.7857143),),
          style: (stroke: none),
          mark: "o",
        )
      },
    )
  }),
)
Ricordiamo la definizione di derivata prima:
$
  f'(x_i) = lim_(h->infinity) frac(f(x_i+h)-f(x_i), h)
$
Se approssimiamo $f'(x_i)$ con $frac(f(x_i+h)-f(x_i), h)$ con $h$ fissato, otterremo un'approssimazione del metodo di Newton: si parla, in questo caso, di un metodo *"quasi" Newton*. Nello specifico, otterremmo un metodo "quasi" Newton che ha un costo di 2 valutazioni funzionali per iterazione. Per migliorare questo approccio, procediamo come segue.

=== Metodo delle secanti

#index("Metodo delle secanti")
#figure(
  canvas({
    import draw: content
    plot.plot(
      x-grid: true,
      y-grid: true,
      size: (14, 8),
      x-tick-step: .5,
      y-tick-step: 1,
      y-min: -1,
      y-max: 7,
      plot-style: (stroke: black),
      legend: "inner-north-east",
      {
        let func = x => calc.pow(calc.e, x) - 1
        let secante = x => 4.87 * x - 3.35
        let secante2 = x => 2.452 * x - .694
        plot.add(func, domain: (-0.5, 2.5), label: $f(x)$, style: (stroke: blue))
        plot.add(secante, domain: (-0.5, 2.5), style: (stroke: red))
        plot.add(secante2, domain: (-0.5, 2.5), style: (stroke: green))

        plot.add-hline(0, style: (stroke: black))
        plot.add-vline(0, 2, calc.ln(3), .6876, .283, min: -0.1, max: 0.1)
        plot.annotate({
          content((0, -.4), $x^*$)
          content((2, -.4), $x_(i-1)$)
          content((calc.ln(3), -.4), $x_i$)
          content((.6876, -.4), $x_(i+1)$)
          content((.283, -.4), $x_(i+2)$)
        })
        plot.add(
          ((2, calc.pow(calc.e, 2) - 1), (calc.ln(3), 2), (.6876, calc.pow(calc.e, .6876) - 1)),
          style: (stroke: none),
          mark: "o",
        )
      },
    )
  }),
)
Consideriamo la retta secante il grafico di $f(x)$ nei due punti $(x_i, f(x_i))$ e $(x_(i-1), f(x_(i-1)))$, il cui coefficiente angolare è dato dal seguente rapporto incrementale:
$
  frac(f(x_i)-f(x_(i-1)), x_i - x_(i-1)) approx f'(x_i)
$
Questa approssimazione della derivata prima definisce il *metodo delle secanti*:
$
  x_(i+1) = x_i - frac(f(x_i), f(x_i)-f(x_(i+1))) (x_i - x_(i+1)), space i=1,2,...
$

#observation(multiple: true)[
  + Il metodo richiede due approssimazioni iniziali per essere innescato (metodo a due passi).
  + Il costo per iterazione è di 1 valutazione funzionale eccetto la valutazione iniziale in cui ne facciamo 2.
  + L'ordine di convergenza verso radici semplici è:
    $
      p=frac(sqrt(5)+1, 2) approx 1,618
    $
    La convergenza verso radici multiple è, al pari del metodo di Newton, *solo lineare*. Trattandosi di un approssimazione del metodo di Newton, la sua convergenza è, generalmente, locale.
]

=== Metodo delle corde
#index("Metodo delle corde")
#figure(
  canvas({
    import draw: content
    plot.plot(
      x-grid: true,
      y-grid: true,
      size: (14, 8),
      x-tick-step: .5,
      y-tick-step: 1,
      y-min: -1,
      y-max: 7,
      plot-style: (stroke: black),
      legend: "inner-north-east",
      {
        let func = x => calc.pow(calc.e, x) - 1
        let corda = x => calc.pow(calc.e, 2) * x + (calc.pow(calc.e, 2) - 1) - calc.pow(calc.e, 2) * 2
        let corda2 = x => calc.pow(calc.e, 2) * x + (calc.pow(calc.e, 1.1353) - 1) - calc.pow(calc.e, 2) * 1.1353
        let corda3 = x => calc.pow(calc.e, 2) * x + (calc.pow(calc.e, .8495) - 1) - calc.pow(calc.e, 2) * .8495
        plot.add(func, domain: (-0.5, 2.5), label: $f(x)$, style: (stroke: blue))
        plot.add(corda, domain: (-0.5, 2.5), style: (stroke: red))
        plot.add(corda2, domain: (-0.5, 2.5), style: (stroke: green))
        plot.add(corda3, domain: (-0.5, 2.5), style: (stroke: purple))

        plot.add-hline(0, style: (stroke: black))
        plot.add-vline(0, 2, 1.1353, .8495, .6684, min: -0.1, max: 0.1)
        plot.annotate({
          content((0, -.4), $x^*$)
          content((2, -.4), $x_0$)
          content((1.1353, -.4), $x_1$)
          content((.8495, -.4), $x_2$)
          content((.6684, -.4), $x_3$)
        })
        plot.add(
          (
            (2, calc.pow(calc.e, 2) - 1),
            (1.1353, calc.pow(calc.e, 1.1353) - 1),
            (.8495, calc.pow(calc.e, .8495) - 1),
          ),
          style: (stroke: none),
          mark: "o",
        )
      },
    )
  }),
)
Per i passi successivi si utilizza l'approssimazione $f'(x_i) approx f'(x_0)$, ovvero, più semplicemente, calcoliamo la derivata prima soltanto all'inizio e la riutilizziamo per tutti i passi. L'espressione del metodo delle corde è pertanto:
$
  x_(i+1) = x_i - frac(f(x_i), f'(x_0)) space i=1,2,...
$
e richiede una valutazione per iterazione. La sua convergenza è ovviamente locale e l'ordine di convergenza si vede essere 1 (convergenza lineare). E' spesso utilizzato in problemi per cui è nota un'approssimazione iniziale $x_0$ molto vicina alla soluzione $x^*$.
