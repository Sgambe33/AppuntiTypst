function x = metodo_aitken(f,f1,x0,tol,itmax)
% function x = metodo_aitken(f,f1,x0,tol,itmax)
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