#import "../../../dvd.typ": *
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
#figure(image("images/2026-04-20-10-12-17.png"))

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

A questo punto, osserviamo il rapporto:
$
  (K_n)/K = 1/n sum_(i=0)^n abs(c_(i n))
$
dalla proprietà (3) otteniamo che:

In presenza di pesi negativi, invece, risulta $(K_n)/K > 1$. È noto in letteratura che la condizione #link(<5.7>, "(5.7)") è verificata esclusivamente per i seguenti gradi:
<5.8>
$
  n in {1, dots, 7, 9} quad quad (5.8)
$
Per i restanti valori (ovvero $n=8$ e $n >= 10$), la presenza di pesi negativi fa crescere il rapporto $(K_n)/K$ in modo estremamente rapido. Di conseguenza, per evitare grave instabilità numerica ed errori di cancellazione, nella pratica le formule di Newton-Cotes si utilizzano *solo* per i valori di $n$ indicati nella #link(<5.8>, "(5.8)").
#figure(image("images/2026-04-20-11-15-59.png"))


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

== Formule adattive


