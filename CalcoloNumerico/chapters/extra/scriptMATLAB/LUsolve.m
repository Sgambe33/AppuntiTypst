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
%   x - soluzione;
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