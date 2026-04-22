function x = metodo_newton_modificato(f,f1,x0, tol, maxit, molt)
% function x = metodo_newton_modificato(f,f1,x0, tol, maxit, molt)
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