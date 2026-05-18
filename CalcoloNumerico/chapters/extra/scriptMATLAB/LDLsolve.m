function x = LDLsolve(LD, b)
% function x = LDLsolve(LD, b)
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
d=diag(LD);
if any(d<=0), error('D non positiva'), end
for i=2:n %fattore L
    x(i:n) = x(i:n)-LD(i:n, i-1)*x(i-1);
end
x=x./d; %fattore D
for i=n-1:-1:1
    x(i)=x(i)-LD(i+1:n, i+1)'*x(i+1:n);
end
return