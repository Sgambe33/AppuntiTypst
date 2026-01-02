#import "../../../dvd.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#pagebreak()

= Algoritmi
== Metodo di Newton modificato
#let metodo-newton-modificato = [#codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: true,
    header: [Metodo di Newton modificato],
  )
  ```matlab
  function x = newton(f,f1,x0, tol, maxit, molt)
  % function x = newton(f,f1,x0, tol, maxit, molt)
  % Metodo di Newton (modificato) per gli zeri di una funzione
  % Input:
  %   f,f1 - function che implementano la funzione e la sua derivata;
  %   x0 - punto iniziale;
  %   tol - tolleranza di arresto (default = 1e-12);
  %   maxit - numero massimo di iterazioni (default = 1000);
  %   molt - molteplicità delle radici (default = 1);
  % Output:
  %   x- approssimazione della radice;
  %                                                             Rel. 17.12.2025
  if nargin < 3, error('parametri insufficienti'), end;
  if nargin < 6, molt = 1; end
  if nargin < 5, maxit = 1000; end
  if nargin < 4, tol = 1e-12; end
  % Se molt è negativa o non è un numero intero -> errore (fix() restituisce la parte intera troncata di molt)
  if molt < 1 || molt ~= fix(molt), error('molteplicità non corretta'), end
  if maxit < 1, error('numero max iterazioni non corretto'); end
  if tol <= 0, error('tolleranza non corretta'); end
  x=x0;
  flag=1;
  for i=1:maxit
    x0 = x;
    fx = feval(f, x);
    f1x = feval(f1, x);
    if fx == 0, flag=0; break, end
    if f1x == 0, error('derivata nulla'), end
    x = x0 - molt * fx/f1x;
    if abs(x-x0) <= tol * (1+abs(x))
      flag=0;
      break;
    end
  end
  if flag, warning('accuratezza non raggiunta'), end
  return
  ```
]

#metodo-newton-modificato
#pagebreak()

== Metodo di Aitken
#let metodo-aitken = [#codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: true,
    header: [Metodo di Aitken],
  )
  ```matlab
  function x = aitken(f,f1,x0,tol,itmax)
  % function x = aitken(f,f1,x0,tol,itmax)
  % Metodo di accelerazione di Aitken per gli zeri di funzione.
  % Input:
  %   f, f1  - function handle rappresentanti la funzione e la sua derivata;
  %   x0     - punto iniziale;
  %   tol    - tolleranza di arresto (default 1e-12);
  %   itmax  - numero massimo di iterazioni (default 1000).
  % Output:
  %   x      - approssimazione della radice.
  if nargin < 3, error('parametri insufficienti'),end
  if nargin < 5, itmax = 1000; end
  if nargin < 4, tol = 1e-12; end
  i = 0;
  x = x0;
  flag = 1;
  for i=1:itmax
      x0 = x;
      fx  = feval(f,x0);
      f1x = feval(f1,x0);
      if f1x == 0, error('derivata nulla'), end
      x1 = x0 - fx/f1x;
      fx  = feval(f,x1);
      f1x = feval(f1,x1);
      if f1x == 0, error('derivata nulla'), end
      x = x1 - fx/f1x;
      x = (x*x0 - x1^2)/(x - 2*x1 + x0);
      if abs(x - x0) > tol*(1 + abs(x))
        flag=0;
      end
  end
  if flag
    warning('accuratezza non raggiunta')
  end
  return
  ```
]

#metodo-aitken

#pagebreak()

== Metodo delle secanti
#let metodo-secanti = [#codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: true,
    header: [Metodo delle secanti],
  )
  ```matlab
  function x = secanti(f, x0, x1, tol, maxit)
  % function x = secanti(f, x0, x1, tol, maxit)
  % Metodo delle secanti per gli zeri di una funzione
  % Input:
  %   f - function che implementa la funzione (handle o stringa);
  %   x0, x1 - punti iniziali;
  %   tol - tolleranza di arresto (default = 1e-12);
  %   maxit - numero massimo di iterazioni (default = 1000);
  % Output:
  %   x - approssimazione della radice;
  %                                                           Rel. 29.12.2025
  if nargin < 3, error('parametri insufficienti'), end
  if nargin < 5, maxit = 1000; end
  if nargin < 4, tol = 1e-12; end
  if x0 == x1, error('punti di innesco errati: devono essere distinti'), end
  if maxit < 1, error('numero max iterazioni non corretto'), end
  if tol <= 0, error('tolleranza non corretta'), end
  flag = 1;

  f0 = feval(f, x0);
  f1 = feval(f, x1);

  for i = 1:maxit
      if f1 == 0, flag=0; break, end
      df = (f1 - f0) / (x1 - x0);
      if df == 0, error('approssimazione derivata nulla'), end
      x = x1 - f1 / df;
      if abs(x - x1) <= tol * (1 + abs(x))
          flag = 0;
          break;
      end
      x0 = x1;
      f0 = f1;
      x1 = x;
      f1 = feval(f, x1);
  end
  if flag
      warning('Accuratezza non raggiunta nel numero massimo di iterazioni');
  end
  return
  end
  ```
]

#metodo-secanti

#pagebreak()

== Metodo delle corde
#let metodo-corde = [#codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: true,
    header: [Metodo delle secanti],
  )
  ```matlab
  function x = corde(f, f1, x0, tol, maxit)
  % function x = corde(f, f1, x0, tol, maxit)
  % Metodo delle corde per gli zeri di una funzione
  % Input:
  %   f, f1 - function che implementano la funzione e la sua derivata prima;
  %   x0 - punto iniziale;
  %   tol - tolleranza di arresto (default = 1e-12);
  %   maxit - numero massimo di iterazioni (default = 1000);
  % Output:
  %   x - approssimazione della radice;
  %                                                           Rel. 29.12.2025
  if nargin < 3, error('parametri insufficienti'), end
  if nargin < 5, maxit = 1000; end
  if nargin < 4, tol = 1e-12; end
  if maxit < 1, error('numero max iterazioni non corretto'), end
  if tol <= 0, error('tolleranza non corretta'), end
  flag = 1;

  f0x = feval(f1, x0);
  if f0x == 0, error('approssimazione derivata nulla'), end

  for i = 1:maxit
      f1x = feval(f, x0);
      if f1x == 0, flag=0; break, end
      x = x0 - f1x / f0x;
      if abs(x - x0) <= tol * (1 + abs(x))
          flag = 0;
          break;
      end
      x0=x;
  end
  if flag
      warning('Accuratezza non raggiunta nel numero massimo di iterazioni');
  end
  return
  end
  ```
]

#metodo-corde


#pagebreak()

== Sistema triangolare
#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
  header: [Risoluzione sistema triangolare],
)
```matlab
function x = trisolve(A, b, flag)
% function x = trisolve(A, b, flag)
% Risolve un sistema triangolare
% Input:
%   A - matrice dei coefficienti;
%   b - vettore dei termini noti;
%   flag - vale 1 se il sistema è triangolare inferiore, triangolare superiore altrimenti;
% Output:
%   x - vettore soluzione;
%                                       Rel. 17.12.2025
if nargin < 3, error('parametri insufficienti'); end
[m,n] = size(A);
if m~=n || n~=length(b)
  error('dati non compatibili');
end
x = b(:); %?
if flag == 1
  for i=1:n
    if A(i,i)==0, error('matrice singolare'); end
    x(i)=x(i)/A(i,i);
    x(i+1:n)=x(i+1:n)-A(i+1:n,i)*x(i);
  end
else
  for i=n:-1:i
    if A(i,i)==0, error('matrice singolare'); end
    x(i)=x(i)/A(i,i);
    x(1:i-1)=x(1:i-1)-A(1:i-1,i)*x(i);
  end
end
return
```

#pagebreak()

== LU Solver
#let lu-solve = [#codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: true,
    header: [Risoluzione sistema con matrice LU],
  )
  ```matlab
  function x = LUsolve(LU, b)
  % x = LUsolve(LU, b)
  % Risolve un sistema lineare Ax=b usando la fattorizzazione LU.
  % Calcola la soluzione del sistema lineare Ax = b,
  % assumendo che la matrice A sia stata fattorizzata in A = L * U
  % e memorizzata in formato compatto.
  % Input:
  %   LU - matrice con i fattori L ed u;
  %   b - termine noto;
  % Output:
  %   x - soluzione
  %                                                   Rel. 2025-12-18
  if nargin < 2, error('dati insufficienti'), end
  [m,n] = size(LU);
  if m ~= n || n ~= length(b)
      error('dimensione dati inconsistenti')
  end
  x=b(:);

  for i=2:n    %fattore L
      x(i:n) = x(i:n) - LU(i:n, i-1) * x(i-1);
  end
  for i=n:-1:1   %fattore U
      if LU(i,i) == 0
          error('fattore U singolare')
      end
      x(i) = x(i) / LU(i,i);
      x(1:i-1) = x(1:i-1)-LU(1:i-1, i) * x(i);
  end
  return
  ```
]

#lu-solve

#pagebreak()

== $L D L^T$ Solver
#let ldl-solve = [#codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: true,
    header: [Risoluzione sistema con matrice LDL],
  )
  ```matlab
  function x = LDsolve(LD, b)
  % x = LDsolve(LD, b)
  % Risolve un sistema lineare Ax=b usando la fattorizzazione LDL.
  % Calcola la soluzione del sistema lineare Ax = b,
  % dove la matrice dei coefficienti A è stata precedentemente fattorizzata
  % nella forma A = L * D * L^T
  % Input:
  %   LD - matrice con l'informazione dei fattori L e D;
  %   b - termine noto;
  % Output:
  %   x - soluzione
  %                                                   Rel. 2025-12-18
  if nargin < 2, error('dati insufficienti'), end
  [m,n] = size(LD);
  if m ~= n || n ~= length(b)
      error('dati non compatibili')
  end
  x=b(:);
  d=diag(D); %estrae vettore contenente elementi della diagonale di D
  if any(d<=0), error('D non positiva'), end
  for i=2:n  %fattore L
      x(i:n) = x(i:n)-LD(i:n, i-1)*x(i-1),
  end
  x=x./d; %fattore D (divisione el. per el. a destra)
  for i=n-1:-1:1
      x(i)=x(i)-LD(i+1:n, i+1)'*x(i+1:n);
  end
  return
  ```
]

#ldl-solve

#pagebreak()
== Fattorizzazione QR (Householder)
#let qr-householder = [#codly(
    languages: codly-languages,
    zebra-fill: none,
    breakable: true,
    header: [Fattorizzazione QR (metodo Householder)],
  )
  ```matlab
  function A = qr_householder(A)
  % function A = qr_householder(A)
  % Calcola la fattorizzazione QR di una matrice A (m x n).
  % La matrice A viene sovrascritta: la parte triangolare superiore contiene R,
  % la parte strettamente inferiore contiene i vettori v che definiscono Q.
  % Input:
  %   A - matrice m x n (con m >= n);
  % Output:
  %   A - matrice sovrascritta con i fattori Q (H) (inferiore) e R (superiore);
  %                                     Rel. 02.01.2026
  [m, n] = size(A);
  if m < n, error('sistema non sovradeterminato'), end
  for i = 1:n
      % Calcolo della norma della colonna corrente (sotto la diagonale)
      alfa = norm(A(i:m, i));
      if alfa == 0, error('A non ha rango max'), end
      % Scelta del segno per evitare cancellazione numerica
      if A(i,i) >= 0, alfa = -alfa; end
      % Calcolo della prima componente del vettore di Householder
      v1 = A(i,i) - alfa;
      A(i,i) = alfa;
      A(i+1:m, i) = A(i+1:m, i) / v1;
      beta = -v1 / alfa;
      v = [1; A(i+1:m,i)]; %solo per leggibilità
      A(i:m, i+1:n) = A(i:m, i+1:n) - (beta * v) * (v' * A(i:m, i+1:n));
  end
  return
  ```
]

#qr-householder
