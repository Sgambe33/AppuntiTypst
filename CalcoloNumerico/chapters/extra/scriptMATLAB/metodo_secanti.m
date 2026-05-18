function x = metodo_secanti(f, x0, x1, tol, maxit)
% function x = metodo_secanti(f, x0, x1, tol, maxit)
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