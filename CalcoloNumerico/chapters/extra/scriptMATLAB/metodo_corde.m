function x = metodo_corde(f, f1, x0, tol, maxit)
% function x = metodo_corde(f, f1, x0, tol, maxit)
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
    warning('Accuratezza non raggiunta');
end
return