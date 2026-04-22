#import "../../../dvd.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#pagebreak()
#show math.equation: set block(breakable: true)
//15.04.2026
= Formule di quadratura
Il problema affrontato in questo capitolo è il calcolo (approssimato) di un integrale definito:
$
  I(f) = integral_a^b f(x) d x, quad f:[a,b]-->RR
$
Assumiamo un intervallo limitato, con $- infinity < a < b < + infinity$, e una funzione $f in C[a,b]$, garantendo l'esistenza dell'integrale in senso classico.

Quando la primitiva di $f(x)$ non è nota o risulta complessa da calcolare, si ricorre all'analisi numerica approssimando l'integrale come segue:
$
  I(f) approx integral_a^b phi(x) d x
$
dove $phi(x) approx f(x)$ appartiene a una classe di funzioni facilmente integrabili, tipicamente i polinomi.

== Formule di Newton-Cotes
Le *formule di Newton-Cotes* applicano questo principio sostituendo la funzione integranda con il polinomio di grado $n$ che interpola $f(x)$ su $n+1$ ascisse equidistanti:
<5.1>
$
  p(x_i) = f(x_i) equiv f_i, & quad quad space i=0,dots,n, \
                x_i = a+ i h & ,quad quad h=(b-a)/n quad quad (5.1)
$

Denotando con $I_n (f)$ l'integrale approssimato ed esprimendo $p(x) in Pi_n$ nella sua forma di Lagrange, si ottiene:
$
  I_n (f) = integral_a^b p(x) d x = integral_a^b sum_(i=0)^n f_i L_(i n) (x) d x = sum_(i=0)^n f_i integral_a^b L_(i n) (x) d x = (*)
$

Per risolvere l'integrale della base di Lagrange $L_(i n) (x)$, applichiamo il cambio di variabile $x = a + t h$, con $t in [0,n]$ e $d x = h d t$:
$
  integral_a^b L_(i n) (x) d x &= integral_a^b product_(j=0\ j != i)^n frac(x-x_j, x_i-x_j) d x \
  &= h integral_0^n product_(j=0\ j != i)^n frac(cancel(a) + t h - (cancel(a) + j h), cancel(a) + i h - (cancel(a) + j h)) d t \
  &= h integral_0^n product_(j=0\ j != i)^n frac(t - j, i - j) d t equiv h dot c_(i n), quad i=0,dots,n
$

Sostituendo questo risultato in $(*)$, arriviamo all'espressione finale per la formula di Newton-Cotes di grado $n$:
<5.2>
$
  I_n (f) = underbrace((b-a)/n, =h) sum_(i=0)^n c_(i n) f_i quad quad (5.2)
$

#observation(multiple: true)[
  + $I(f) = I_n (f), quad forall f in Pi_n$.
  + Applicando la proprietà precedente alla funzione costante $f(x)=1$, otteniamo $I(1) = I_n (1)$ per ogni $n >= 1$. Di conseguenza:
    $
      I(1) = integral_a^b 1 d x = b-a = (b-a)/n sum_(i=0)^n c_(i n) = I_n (1)
    $
    da cui deriva la condizione di normalizzazione per i pesi:
    <5.3>
    $
      1/n sum_(i=0)^n c_(i n) = 1 quad quad (5.3)
    $
  + Data la distribuzione simmetrica delle ascisse di interpolazione in $[a,b]$, i pesi risultano a loro volta simmetrici:
    <5.4>
    $
      c_(i n) = c_(n-i, n), quad i=0,dots,n quad quad (5.4)
    $
]

#[
  #set heading(outlined: false, numbering: none)
  == Esempi
]
*Caso $n=1$ (Metodo dei trapezi)* \
Sfruttando la proprietà di simmetria #link(<5.4>, "(5.4)") deduciamo che $c_(01) = c_(11)$, mentre dalla condizione di normalizzazione #link(<5.3>, "(5.3)") sappiamo che $c_(01) + c_(11) = 1$. Di conseguenza, si ricava banalmente che $c_(01) = c_(11) = 1/2$.

La formula di Newton-Cotes di grado 1 è quindi data da:
$
  I_1 (f) = underbrace(b-a, =h) frac(f(a)+f(b), 2)
$
Geometricamente, stiamo approssimando l'area sottesa dal grafico di $f(x)$ con l'area del trapezio rettangolo individuato dai vertici $(a,0), (b,0), (b,f(b))$ e $(a,f(a))$. Per questo motivo, la formula prende il nome di *metodo dei trapezi*.


#figure(
  canvas({
    import draw: *
    plot.plot(
      size: (10, 5),
      x-tick-step: 1,
      y-tick-step: 1,
      y-min: -2,
      x-min: 0,
      x-max: 14,
      y-max: 8,
      plot-style: (stroke: black),
      min: 0,
      {
        let func = x => 4 + 1 / 2 * (x - 2) - 9 / 221 * (x - 2) * (x - 4) + 139 / 13260 * (x - 2) * (x - 4) * (x - 10.5)
        let func2 = x => 0.3 * x + 3.4
        plot.add(
          func,
          domain: (2, 12),
          label: $f(x)$,
          style: (stroke: green, fill: yellow.transparentize(80%)),
          fill: true,
          fill-type: "axis",
        )
        plot.add(func2, domain: (2, 12), style: (stroke: orange))

        let nodes = ((2, 4), (12, 7))
        plot.add(nodes, style: (stroke: none), mark: "o")

        plot.add-hline(0, min: 0, max: 14, style: (stroke: black))


        plot.add-vline(2, min: 0, max: 3.8, style: (stroke: blue))
        plot.add-vline(12, min: 0, max: 6.8, style: (stroke: blue))

        plot.add-hline(4, min: 0, max: 1.8, style: (stroke: red))
        plot.add-hline(7, min: 0, max: 11.8, style: (stroke: red))
        plot.annotate({
          content((2, -0.5), $a$)
          content((12, -0.5), $b$)
        })
      },
    )
  }),
)

*Caso $n=2$ (Metodo di Simpson)* \
Imponendo nuovamente la #link(<5.4>, "(5.4)") otteniamo $c_(02) = c_(22)$ e, dalla #link(<5.3>, "(5.3)"), ricaviamo la condizione $c_(02) + c_(12) + c_(22) = 2$. È sufficiente calcolare esplicitamente un solo peso, ad esempio $c_(22)$, per poter determinare tutti gli altri:
$
  c_(22) & = integral_0^2 frac(t-0, 2-0) dot frac(t-1, 2-1) d t = integral_0^2 t/2 (t-1) d t \
         & = integral_0^2 t^2/2 d t - integral_0^2 t/2 d t = 4/3 - 1 = 1/3
$
Sostituendo a ritroso, otteniamo $c_(02) = c_(22) = 1/3$ e, per differenza, $c_(12) = 2 - 2/3 = 4/3$. Ricordando che le ascisse di interpolazione sono $x_0 = a$, $x_1 = (a+b)/2$, e $x_2 = b$, possiamo scrivere la formula che definisce il *metodo di Simpson*:
$
  I_2 (f) & = (b-a)/2 (1/3 f(a) + 4/3 f((a+b)/2) + 1/3 f(b)) \
          & = (b-a)/6 (f(a) + 4 f((a+b)/2) + f(b))
$

== Analisi di condizionamento
#[
  #set heading(outlined: false, numbering: none)
  === Problema continuo
]
Consideriamo una perturbazione $tilde(f)(x)$ del dato in ingresso $f(x)$. Per valutare il condizionamento, ricerchiamo una corrispondente maggiorazione per l'errore sul risultato finale:
$
  abs(I(f)-I(tilde(f))) & = abs(integral_a^b f(x) d x - integral_a^b tilde(f)(x) d x) \
                        & <= integral_a^b abs(f(x)-tilde(f)(x)) d x \
                        & <= integral_a^b d x dot norm(f-tilde(f))_infinity = (b-a) norm(f-tilde(f))_infinity
$
Considerato che:
- $abs(I(f) - I(tilde(f)))$ è la misura dell'errore sul risultato finale;
- $norm(f - tilde(f))$ è la misura dell'errore sul dato in ingresso;
si deduce che il *numero di condizionamento* del problema continuo è:
<5.5>
$
  K = b-a quad quad (5.5)
$

#[
  #set heading(outlined: false, numbering: none)
  === Problema discreto
]
Eseguiamo la medesima analisi per l'integrale approssimato $I_n(f)$, definito dalla #link(<5.2>, "(5.2)"):
$
  abs(I_n (f) - I_n (tilde(f))) &= (b-a)/n abs(sum_(i=0)^n c_(i n) f_i - sum_(i=0)^n c_(i n) tilde(f)_i) = (b-a)/n abs(sum_(i=0)^n c_(i n) (f_i - tilde(f)_i)) \
  &<= (b-a)/n sum_(i=0)^n abs(c_(i n)) dot abs(f_i - tilde(f)_i) \
  &<= underbrace(((b-a)/n sum_(i=0)^n abs(c_(i n))), =K_n) norm(f - tilde(f))_infinity
$
Analogamente a quanto fatto nel continuo, identifichiamo il *numero di condizionamento* della formula di Newton-Cotes di grado $n$:
<5.6>
$
  K_n = (b-a)/n sum_(i=0)^n abs(c_(i n)) quad quad (5.6)
$
Per valutare la stabilità del metodo numerico, osserviamo il rapporto tra i condizionamenti:
$
  (K_n)/K = 1/n sum_(i=0)^n abs(c_(i n))
$
Ricordando la condizione di normalizzazione #link(<5.3>, "(5.3)"), si deduce che il metodo è perfettamente condizionato se i pesi non sono negativi:
<5.7>
$
  (K_n)/K = 1 quad "se" quad c_(i n) >= 0, quad forall i=0,dots,n quad quad (5.7)
$
In presenza di pesi negativi, invece, risulta $(K_n)/K > 1$. È noto in letteratura che la condizione #link(<5.7>, "(5.7)") è verificata esclusivamente per i seguenti gradi:
<5.8>
$
  n in {1, dots, 7, 9} quad quad (5.8)
$
Per i restanti valori (ovvero $n=8$ e $n >= 10$), la presenza di pesi negativi fa crescere il rapporto $(K_n)/K$ in modo estremamente rapido. Di conseguenza, per evitare grave instabilità numerica ed errori di cancellazione, nella pratica le formule di Newton-Cotes si utilizzano *solo* per i valori di $n$ indicati nella #link(<5.8>, "(5.8)").
#figure(
  canvas({
    let raw-data = (
      (1, 1),
      (2, 1),
      (3, 1),
      (4, 1),
      (5, 1),
      (6, 1),
      (7, 1),
      (8, 1.45),
      (9, 1),
      (10, 3.1),
      (11, 1.6),
      (12, 7.5),
      (13, 3.2),
      (14, 20),
      (15, 8.5),
      (16, 60),
      (17, 24),
      (18, 180),
      (19, 65),
      (20, 500),
    )

    let plot-data = raw-data.map(pt => (pt.at(0), calc.log(pt.at(1), base: 10)))
    import draw: *
    plot.plot(
      size: (12, 9),
      x-label: [$n$],
      y-label: [$K_n / K$],
      x-min: 1,
      x-max: 20,
      x-tick-step: 2,
      y-min: 0, // corrisponde a 10^0
      y-max: 3, // corrisponde a 10^3
      y-tick-step: none,
      y-ticks: (
        (0, [$10^0$]),
        (1, [$10^1$]),
        (2, [$10^2$]),
        (3, [$10^3$]),
      ),
      {
        plot.add(
          plot-data,
        )
      },
    )
  }),
)


//16.04.2026
Per passare all'implementazione pratica del metodo, riprendiamo l'espressione analitica dei pesi di Newton-Cotes derivata dalla base di Lagrange:
<5.9>
$
  c_(i n) = integral_0^n product_(j=0\ j!=i)^n frac(t-j, i-j) d t quad quad (5.9)
$

#observation()[
  I coefficienti $c_(i n)$ definiti nella #link(<5.9>, "(5.9)") sono sempre *numeri razionali*. Possiamo infatti separarli nel rapporto di due numeri interi, $c_(i n) = (alpha_(i n)) / d_(i n)$, dove:
  $
    d_(i n) = product_(j=0 \ j != i)^n (i - j), quad quad alpha_(i n) = integral_0^n product_(j=0\ j!= i)^n (t-j) d t
  $
]

Questa scomposizione è la chiave per calcolare i pesi in modo esatto al calcolatore. In Matlab, possiamo sfruttare l'algebra dei polinomi per ricavare $alpha_(i n)$ e $d_(i n)$. Fissato il grado $n$ e un generico indice $i$, la procedura vettorizzata è la seguente:

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
)
```matlab
% 1. Vettore delle radici (escluso l'indice i)
ind = [0:i-1, i+1:n];

% 2. Calcolo del denominatore (prodotto degli scarti)
din = prod(i - ind);

% 3. Calcolo del numeratore tramite integrazione polinomiale
a = poly(ind);             % coefficienti del polinomio con radici in 'ind'
q = [a ./ (n+1:-1:1), 0];  % calcolo dei coefficienti della primitiva
alfain = polyval(q, n);    % valutazione della primitiva tra 0 e n

% 4. Calcolo del peso finale
cin = alfain / din;
```
La logica matematica dietro le istruzioni per il numeratore merita una precisazione. La funzione `poly(ind)` restituisce il vettore dei coefficienti $a_k$ del polinomio monico con le radici in argomento, ordinati per potenze decrescenti. Se il polinomio ha grado $n$, esso è definito come:
$
  q(t) = sum_(k=1)^(n+1) a_k t^(n+1-k)
$
Integrando $q(t)$ rispetto a $t$, otteniamo la famiglia di primitive:
$
  integral q(t) d t = sum_(k=1)^(n+1) a_k frac(t^(n+2-k), n+2-k) + C
$
L'istruzione Matlab `q = [a ./ (n+1:-1:1), 0]` esegue esattamente questa operazione: divide ogni coefficiente $a_k$ per il suo nuovo esponente e aggiunge uno $0$ finale per imporre la costante di integrazione $C=0$. Infine, la primitiva viene valutata nell'estremo superiore di integrazione $t=n$ tramite `polyval(q, n)` (la valutazione in $0$ è ovviamente nulla), ottenendo così l'esatto valore dell'integrale $alpha_(i n)$.

== Errore e formule composite
Poiché in generale $I(f) != I_n(f)$, vogliamo quantificare l'errore di integrazione $E_n(f) = I(f) - I_n(f)$. Utilizzando l'espressione dell'errore di interpolazione, possiamo scrivere:
$
  E_n (f) = I(f) - I_n (f) & = integral_a^b f(x) d x - integral_a^b p(x) d x \
                           & = integral_a^b (f(x)-p(x)) d x \
                           & = integral_a^b f[x_0, x_1, dots, x_n,x] omega_(n+1) (x) d x
$
Più rigorosamente, vale il seguente teorema sull'errore di quadratura:
#theorem()[
  Sia $f(x) in C^(n+mu)[a,b]$ con:
  $
    mu = cases(
      1 & "se" n "è dispari",
      2 & "se" n "è pari"
    )
  $
  allora l'errore per la formula di Newton-Cotes di grado $n$ è dato da:
  <5.10>
  $
    E_n (f) = nu_n f^((n+mu))(xi) (frac(b-a, n))^(n+mu+1) quad quad (5.10)
  $
  dove $xi in [a,b]$ e $nu_n$ è un coefficiente costante che dipende esclusivamente dal grado $n$.
]
#observation()[
  Dalla #link(<5.10>, "(5.10)") si evince che per annullare l'errore ($E_n (f) -> 0$), occorrerebbe far tendere $n -> infinity$. Questo requisito entra in diretto conflitto con i limiti di stabilità visti nell'analisi di condizionamento, che impongono di usare solo $n in {1,dots,7,9}$.
]
Per superare questo paradosso, si introducono le formule di *Newton-Cotes composite*, che consistono nel suddividere l'intervallo di integrazione in sottointervalli per poi applicare una formula di basso grado su ciascuno di essi.
#[
  #set heading(outlined: false, numbering: none)
  === Formula composita dei trapezi
]
Per illustrare il concetto, applichiamo iterativamente la formula dei trapezi.
#figure(image("images/2026-04-20-12-00-59.png"))

L'integrale complessivo viene approssimato come somma delle aree dei singoli trapezi:
$
  I(f) = integral_a^b f(x) d x & = sum_(i=1)^n integral_(x_(i-1))^x_i f(x) d x \
                               & approx sum_(i=1)^n underbrace((b-a)/n, =h) (frac(f_(i-1)+f_i, 2)) \
                               & = (b-a)/(2n) sum_(i=1)^n (f_(i-1) + f_i) equiv I_1^((n))(f)
$
Analizziamo ora l'errore $E_1^((n))(f)$. Applicando la #link(<5.10>, "(5.10)") su ogni sottointervallo $[x_(i-1), x_i]$ e sfruttando il teorema dei valori intermedi per le funzioni continue, otteniamo:
$
  E_1^((n))(f) =I(f) - I_1^((n))(f) & = sum_(i=1)^n (integral_(x_(i-1))^x_i f(x) d x - h frac(f_(i-1)+f_i, 2)) \
                                    & = sum_(i=1)^n nu_1 f^((2))(xi_i) ((b-a)/n)^3, quad quad xi_i in [x_(i-1), x_i] \
                                    & = nu_1 ((b-a)/n)^3 sum_(i=1)^n f^((2)) (xi_i) \
                                    & = nu_1 ((b-a)/n)^3 n dot f^((2))(xi), quad quad xi in [a,b] \
                                    & = nu_1 (b-a) f^((2)) (xi) ((b-a)/n)^2
$
Si nota immediatamente che per $n -> infinity$, l'errore $E_1^((n))(f) -> 0$, garantendo la convergenza senza incorrere nell'instabilità numerica dei gradi elevati.
#[
  #set heading(outlined: false, numbering: none)
  === Formule composite di grado $k$
]
Generalizzando, scegliamo un grado base $k in {1,dots,7,9}$ e un numero totale di ascisse $n = k ell$ (con $ell$ indicante il numero di sottointervalli macroscopici). La formula composita di grado $k$ si ottiene applicandola $ell$ volte per ricoprire l'intero dominio:
\ >GEMINI
$
  [x_0, x_k] union [x_k, x_(2k)] union dots union [x_(k(ell-1)), x_(k ell)] = [a,b]
$
\ >PROF
$
  [x_0, x_k] union [x_(k+1), x_(2k)] union dots union [x_(k(ell-1)), x_(k ell)] = [a,b]
$

Sostituendo $ell = (b-a)/(k h)$, il corrispondente errore globale risulta essere:
<5.11>
$
  E_k^((n)) (f) & = I(f) - I_k^((n))(f) \
                & = nu_k f^((k+mu)) (xi) ell h^(k+mu+1) quad quad xi in[a,b] \
                & = nu_k f^((k+mu)) (xi) ell ((b-a)/n)^(k+mu+1) quad quad (n= k ell) \
                & = nu_k (b-a)/k f^((k+mu)) (xi) ((b-a)/n)^(k+mu) quad quad (5.11)
$
Anche per il caso generale, per $n -> infinity$ l'errore decade a $0$.

#example("Formula composita dei trapezi")[
  Nel caso $k=1$, l'intervallo è suddiviso in $n$ sottointervalli. Raggruppando i termini condivisi, si ottiene:
  $
    I_1^((n)) (f) & = (b-a)/n (f_0/2 + f_1/2 + f_1/2 + f_2/2 + dots + f_(n-1)/2 + f_n/2) \
                  & = (b-a)/n (f_0/2 + sum_(i=1)^(n-1) f_i + f_n/2)
  $
  #observation()[
    Se la funzione $f$ è periodica in $[a,b]$, si ha $f_0=f_n$. La formula si semplifica quindi in:
    $
      I_1^((n))(f) = (b-a)/n sum_(i=0)^(n-1) f_i
    $
    Questa proprietà è di fondamentale importanza, ad esempio, nell'elaborazione numerica dei segnali.
  ]
]

#example("Formula composita di Simpson")[
  Per $k=2$, il numero totale di intervalli $n$ deve essere necessariamente pari ($n=2 ell$). Sommando i contributi dei vari sottointervalli, si ottiene:
  $
    I_2^((n))(f) &= (b-a)/n [frac(f_0+4f_1+f_2, 3) + frac(f_2+4f_3+f_4, 3) + dots + frac(f_(n-2)+4f_(n-1)+f_n, 3)] \
    &= frac(b-a, 3n) [4 underbrace(sum_(i=1)^(n/2) f_(2i-1), "nodi dispari") + 2 underbrace(sum_(i=0)^(n/2) f_(2i), "nodi pari") - f_0 - f_n]
  $
]

Da un punto di vista algoritmico, è cruciale *evitare valutazioni funzionali ridondanti* nei punti di intersezione tra i sottointervalli (come i nodi interni $x_1, x_2, dots$ che compaiono in più termini prima della semplificazione).
In Matlab, tutti i valori necessari possono essere precalcolati simultaneamente in modo vettoriale. Supponendo che `fun` sia la function che implementa la funzione integranda:

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
)
```matlab
x = linspace(a, b, n+1); % Generazione degli n+1 nodi equidistanti
f = fun(x);              % Valutazione vettoriale
```
Il vettore `f` restituisce esattamente tutti i valori $f_i$ richiesti per implementare le sommatorie delle formule composite appena viste.

#example()[
  Consideriamo come test l'approssimazione del seguente integrale esatto:
  $
    I(f) = integral_0^pi sin(x) d x = 2
  $
  #show figure: set block(breakable: true)
  #figure(
    kind: table,
    {
      // 1. Inizializzazione variabili e funzione
      let a = 0.0
      let b = calc.pi
      let exact = 2.0
      let f(x) = calc.sin(x)

      // Valori di n (devono essere pari per Simpson)
      let n_values = (2, 4, 8, 10, 12, 14, 16, 18, 20)

      // Versione 1: Restituisce una stringa in formato testuale (es. "1.234e-5")
      let fmt_exp_str(x, digits: 4) = {
        if x == 0 { return "0" }

        let abs_x = calc.abs(x)

        // Estrazione matematica di esponente e mantissa
        let exponent = calc.floor(calc.ln(abs_x) / calc.ln(10))
        let mantissa = x / calc.pow(10, exponent)

        // Arrotondamento della mantissa
        let m_rounded = calc.round(mantissa, digits: digits)

        // Gestione del caso limite in cui l'arrotondamento fa scattare la decina
        // (es. 9.9999 arrotondato a 4 cifre diventa 10.0)
        if calc.abs(m_rounded) >= 10 {
          m_rounded = m_rounded / 10
          exponent += 1
        }

        return str(m_rounded) + "e" + str(exponent)
      }

      // 2. Generazione dinamica delle celle
      let cells = n_values
        .map(n => {
          let h = (b - a) / n

          // --- Calcolo Formula composita dei Trapezi (I1) ---
          let sum_trap = 0.0
          for i in range(1, n) { sum_trap += f(a + i * h) }
          let I1 = (h / 2.0) * (f(a) + 2.0 * sum_trap + f(b))
          let E1 = calc.abs(exact - I1)

          // --- Calcolo Formula composita di Simpson (I2) ---
          let sum_simp = 0.0
          for i in range(1, n) {
            if calc.rem(i, 2) == 0 {
              sum_simp += 2.0 * f(a + i * h) // nodi pari
            } else {
              sum_simp += 4.0 * f(a + i * h) // nodi dispari
            }
          }
          let I2 = (h / 3.0) * (f(a) + sum_simp + f(b))
          let E2 = exact - I2

          // Helper per stampare arrotondando a 8 cifre decimali
          let fmt(x) = str(calc.round(x, digits: 4))

          // Restituisce la riga della tabella
          return (str(n), fmt(I1), fmt_exp_str(E1), fmt(I2), fmt_exp_str(E2))
        })
        .flatten() // flatten trasforma l'array di array in un array monodimensionale

      table(
        columns: 5,
        align: (center, center, center, center, center),
        stroke: 0.5pt,
        [*$n$*], [*$I_1^((n))$*], [*$E_1^((n))$*], [*$I_2^((n))$*], [*$E_2^((n))$*],
        ..cells,
      )
    },
  )
]


//22.04.2026
Vediamo come, partendo dalla #link(<5.11>, "(5.11)"), si possa ottenere una stima dell'errore di quadratura a costo quasi nullo. Se supponiamo che $n$ sia un *multiplo pari del grado $k$* (ovvero $n = 2 k ell$), possiamo applicare la formula composita in due modi: sia utilizzando tutti gli $n+1$ nodi, sia scartando i nodi dispari e utilizzando solo la metà dei sottointervalli.

#example("Formula di Simpson")[
  Con $k=2$, prendiamo ad esempio $n=4$.
  Abbiamo a disposizione i nodi: $x_0, x_1, x_2, x_3, x_4$. Possiamo applicare la formula di Simpson in due varianti:
  1. Su tutti i nodi, coprendo l'intero dominio $x_0 -- x_4$.
  2. Su un numero dimezzato di sottointervalli (passo doppio), applicandola prima ai punti $x_0, x_1, x_2$ e poi a $x_2, x_3, x_4$.
]

Valutando l'errore sull'intervallo con passo doppio ($n/2$ sottointervalli), dalla #link(<5.11>, "(5.11)") otteniamo che, per un opportuno $hat(xi) in [a,b]$ (in generale $hat(xi) != xi$):
<5.12>
$
  I(f) - I_k^((n/2))(f) = nu_k (b-a)/k f^((k+mu)) (hat(xi)) ((b-a)/(n/2))^(k+mu) quad quad (5.12)
$
Assumendo per continuità che $hat(xi) approx xi$ (valido per $h$ sufficientemente piccolo), sottraiamo la #link(<5.11>, "(5.11)") dalla #link(<5.12>, "(5.12)") membro a membro:
$
  I_k^((n))(f) - I_k^((n/2))(f) approx nu_k (b-a)/k f^((k+mu)) (xi) ((b-a)/n)^(k+mu) (2^(k + mu)-1)
$
Dividendo tutto per la costante $2^(k + mu) - 1$, isoliamo il termine dell'errore asintotico, definendo così lo *stimatore a posteriori dell'errore*:
$
  hat(E)_k^((n)) (f) = frac(I_k^((n))(f) - I_k^((n/2))(f), 2^(k + mu)-1) &approx nu_k (b-a)/k f^((k+mu)) (xi) ((b-a)/n)^(k+mu) \
  &= I(f) - I_k^((n))(f) = E_k^((n)) (f)
$
Così facendo, otteniamo una stima computazionale dell'errore (detta estrapolazione di Richardson) senza conoscere la soluzione esatta. La stima diventa sempre più accurata al crescere di $n$.

#example("Verifica delle stime")[
  Riconsideriamo l'integrale $I(f) = integral_0^pi sin(x) d x = 2$.
  Utilizzando le formule composite dei trapezi ($k=1, mu=1 =>$ diviso 3) e di Simpson ($k=2, mu=2 =>$ diviso 15), otteniamo la seguente tabella degli errori reali $E$ e stimati $hat(E)$:

  #show figure: set block(breakable: true)
  #figure(
    kind: table,
    {
      let a = 0.0
      let b = calc.pi
      let exact = 2.0
      let f(x) = calc.sin(x)

      let n_values = (2, 4, 8, 10, 12, 14, 16, 18, 20)

      let fmt_exp_str(x, digits: 4) = {
        if x == 0 { return "0" }
        let abs_x = calc.abs(x)
        let exponent = calc.floor(calc.ln(abs_x) / calc.ln(10))
        let mantissa = x / calc.pow(10, exponent)
        let m_rounded = calc.round(mantissa, digits: digits)
        if calc.abs(m_rounded) >= 10 {
          m_rounded = m_rounded / 10
          exponent += 1
        }
        return str(m_rounded) + "e" + str(exponent)
      }

      let fmt(x) = str(calc.round(x, digits: 4))

      let cells = n_values
        .map(n => {
          let h = (b - a) / n
          let n_half = int(n / 2)
          let h_half = (b - a) / n_half

          // --- Calcolo I1 (Trapezi n) ---
          let sum_trap = 0.0
          for i in range(1, n) { sum_trap += f(a + i * h) }
          let I1 = (h / 2.0) * (f(a) + 2.0 * sum_trap + f(b))
          let E1 = calc.abs(exact - I1)

          // --- Calcolo I1_half (Trapezi n/2) ---
          let sum_trap_half = 0.0
          for i in range(1, n_half) { sum_trap_half += f(a + i * h_half) }
          let I1_half = (h_half / 2.0) * (f(a) + 2.0 * sum_trap_half + f(b))

          // Stima errore Trapezi
          let hat_E1 = calc.abs(I1 - I1_half) / 3.0

          // --- Calcolo I2 (Simpson n) ---
          let sum_simp = 0.0
          for i in range(1, n) {
            if calc.rem(i, 2) == 0 { sum_simp += 2.0 * f(a + i * h) } else { sum_simp += 4.0 * f(a + i * h) }
          }
          let I2 = (h / 3.0) * (f(a) + sum_simp + f(b))
          let E2 = (exact - I2)

          // --- Calcolo I2_half e Stima Simpson (solo se n/2 è pari) ---
          let hat_E2_str = "-"
          if calc.rem(n_half, 2) == 0 {
            let sum_simp_half = 0.0
            for i in range(1, n_half) {
              if calc.rem(i, 2) == 0 { sum_simp_half += 2.0 * f(a + i * h_half) } else {
                sum_simp_half += 4.0 * f(a + i * h_half)
              }
            }
            let I2_half = (h_half / 3.0) * (f(a) + sum_simp_half + f(b))
            let hat_E2 = (I2 - I2_half) / 15.0
            hat_E2_str = fmt_exp_str(hat_E2)
          }

          return (str(n), fmt(I1), fmt_exp_str(E1), fmt_exp_str(hat_E1), fmt(I2), fmt_exp_str(E2), hat_E2_str)
        })
        .flatten()

      table(
        columns: 7,
        align: center,
        stroke: 0.5pt,
        table.header(
          [*$n$*],
          [*$I_1^((n))$*],
          [*$E_1^((n))$*],
          [*$hat(E)_1^((n))$*],
          [*$I_2^((n))$*],
          [*$E_2^((n))$*],
          [*$hat(E)_2^((n))$*],
        ),
        ..cells,
      )
    },
  )
]

== Formule adattive
Possiamo specializzare ulteriormente questo stimatore per ottenere delle *formule di quadratura di tipo adattivo*. 
Talora si presentano integrali definiti da una funzione che varia in modo drastico solo in un piccolo sottointervallo del dominio. In questi casi, utilizzare una griglia di nodi uniforme è computazionalmente inefficiente. Conviene invece utilizzare punti distribuiti in modo non uniforme, "addensandoli" localmente solo dove il comportamento della funzione $f(x)$ lo richiede, al fine di soddisfare un prescritto criterio di accuratezza con il minor numero di valutazioni possibili.

#example("Necessità dell'adattività")[
  Consideriamo il calcolo del seguente integrale:
  $
    integral_(1/2)^100 -2x^(-3) cos(x^(-2)) d x equiv sin(10^(-4)) - sin(4)
  $
  #figure(image("images/2026-04-22-16-45-45.png"))
  Come si evince dal grafico, questa funzione oscilla violentemente vicino a $x=1/2$ (a causa del termine $x^(-2)$ che diverge), per poi appiattirsi quasi istantaneamente procedendo verso $x=100$. Un metodo a passo fisso costringerebbe a usare un $h$ minuscolo su tutto il dominio $[1/2, 100]$ solo per catturare le oscillazioni iniziali, sprecando milioni di valutazioni inutili nella zona piatta.
]

Illustriamo il concetto di adattamento automatico del passo con la formula dei trapezi, sebbene la logica si estenda facilmente a formule di grado superiore.

#problem()[
  Calcolare $I(f)$ su un intervallo globale con una tolleranza `tol` prescritta in input.
]
Applicando la formula dei trapezi sull'intero intervallo $[a,b]$ (un solo trapezio) e poi la formula composita con $n=2$ (due trapezi), otteniamo:
$
  I_1 &= (b-a)/2 (f(a) + f(b)) \
  I_2 &= (b-a)/4 (f(a) + 2f(x_1) + f(b)), quad quad "con" x_1 = (a+b)/2
$
Come dimostrato precedentemente, la stima dell'errore su questo specifico passo è ottenibile come:
$
  E_(12) = abs(I_2 - I_1)/3
$
A questo punto si imposta un controllo algoritmico:
+ Se $E_(12) <= "tol"$, l'accuratezza è soddisfatta: l'algoritmo si ferma e restituisce $I_2$.
+ Altrimenti, l'intervallo viene diviso a metà. Si riapplica ricorsivamente l'intera procedura sui due sottointervalli $[a, x_1]$ e $[x_1, b]$, ma richiedendo a ciascuno una tolleranza dimezzata pari a $"tol"/2$.

L'accortezza fondamentale nell'implementare questa procedura è *evitare valutazioni funzionali ridondanti*. Nel calcolo di $I_2$, i valori $f(a)$, $f(x_1)$ e $f(b)$ sono già stati determinati e devono essere passati alle chiamate ricorsive successive per non ricalcolarli inutilmente.

Ad esempio, impostando `tol` = $10^(-3)$, un'implementazione Matlab posizionerà automaticamente i nodi in questo modo (notare l'addensamento a sinistra):
#figure(image("images/2026-04-22-16-48-09.png"))

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
)
```matlab
function I2 = trapead(fun, a, b, tol, fa, fb)
    % Approssimazione integrale con formula dei trapezi adattiva
    % Input:
    %   fun - function handle dell'integranda
    %   a, b - estremi di integrazione
    %   tol - tolleranza richiesta
    %   fa, fb - (opzionali) valori della funzione già precalcolati
    
    if nargin == 4
        fa = fun(a);
        fb = fun(b);
    end
    
    % Punto medio e nuova valutazione funzionale (l'unica necessaria)
    x1 = (a + b) / 2;
    f1 = fun(x1);
    
    % Calcolo delle due approssimazioni (h è la metà dell'intervallo)
    h = (b - a) / 2;
    I1 = h * (fa + fb);
    I2 = (h / 2) * (fa + 2*f1 + fb);
    
    % Stima dell'errore di Richardson
    err = abs(I2 - I1) / 3;
    
    if err > tol
        % Criterio fallito: divisione e chiamate ricorsive (tolleranza dimezzata)
        % Passiamo i valori di fa, f1 e fb per evitare di ricalcolarli
        I2 = trapead(fun, a, x1, tol/2, fa, f1) + trapead(fun, x1, b, tol/2, f1, fb);
    end
return
```
