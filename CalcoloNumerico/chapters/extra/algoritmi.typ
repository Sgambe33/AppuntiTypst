#import "../../../dvd.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
)

#pagebreak()

= Algoritmi
== Metodo di bisezione
#let bisezione-data = read("scriptMATLAB/metodo_bisezione.m")
#let metodo-bisezione = [
  #codly(header: [Metodo di bisezione])
  #raw(block: true, lang: "matlab", bisezione-data)
]

#metodo-bisezione

#pagebreak()

== Metodo di Newton
#let newton-data = read("scriptMATLAB/metodo_newton.m")
#let metodo-newton = [
  #codly(header: [Metodo di Newton])
  #raw(block: true, lang: "matlab", newton-data)
]

#metodo-newton

#pagebreak()

== Metodo di Newton modificato
#let newton-modificato-data = read("scriptMATLAB/metodo_newton_modificato.m")
#let metodo-newton-modificato = [
  #codly(header: [Metodo di Newton modificato])
  #raw(block: true, lang: "matlab", newton-modificato-data)
]

#metodo-newton-modificato

#pagebreak()

== Metodo di Aitken
#let aitken-data = read("scriptMATLAB/metodo_aitken.m")
#let metodo-aitken = [
  #codly(header: [Metodo di Aitken])
  #raw(block: true, lang: "matlab", aitken-data)
]

#metodo-aitken

#pagebreak()

== Metodo delle secanti
#let secanti-data = read("scriptMATLAB/metodo_secanti.m")
#let metodo-secanti = [
  #codly(header: [Metodo delle secanti])
  #raw(block: true, lang: "matlab", secanti-data)
]

#metodo-secanti

#pagebreak()

== Metodo delle corde
#let corde-data = read("scriptMATLAB/metodo_corde.m")
#let metodo-corde = [
  #codly(header: [Metodo delle secanti])
  #raw(block: true, lang: "matlab", corde-data)
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

== Fattorizzazione LU con pivoting

#codly(
  languages: codly-languages,
  zebra-fill: none,
  breakable: true,
)
```matlab
n = size(a,1);
p = 1:n;
for i = 1:n-1
  % --- 1. RICERCA DEL PIVOT ---
  % mi=valore, ki=indice relativo
  [mi, ki] = max(abs(a(i:n,i)));
  if mi == 0
    error('matrice singolare');
  end
  % --- 2. AGGIORNAMENTO INDICI E SCAMBIO RIGHE ---
  % Lo convertiamo in indice assoluto della matrice (da i a n). Vedi nota.
  ki = ki + i - 1;
  % Se il pivot migliore non è già sulla diagonale facciamo lo scambio.
  if ki > i
      % Scambia le righe fisiche nella matrice A (parte numerica)
      % Scambia la riga corrente 'i' con la riga del pivot 'ki'. Vedi nota.
      a([i ki], :) = a([ki i], :);
      % Registra lo stesso scambio nel vettore p
      p([i ki]) = p([ki i]);
  end
  % --- 3. CALCOLO DEI MOLTIPLICATORI (Parte L) ---
  % Calcola i moltiplicatori di Gauss per la colonna corrente.
  a(i+1:n, i) = a(i+1:n, i) / a(i,i);
  % --- 4. AGGIORNAMENTO SOTTOMATRICE (Parte U) ---
  % Sottrae il prodotto colonna * riga: A_new = A_old - L * U
  a(i+1:n, i+1:n) = a(i+1:n, i+1:n) - a(i+1:n, i) * a(i, i+1:n);
end
if a(n,n) == 0
    error('matrice singolare');
end
```

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
  d=diag(LD); %estrae vettore contenente elementi della diagonale di LD
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
