function x = metodo_bisezione(f, a, b, tol)
% function x = metodo_bisezione(f, a, b, tol)
% Metodo di bisezione per gli zeri di una funzione
% Input:
%   f - funzione di cui determinare la radice;
%   a,b - estremi dell'intervallo in cui ricercare la radice>;
%   tol - tolleranza desiderata (default = 1e-12);
% Output:
%   x - approssimazione della radice;
%                                                              Rel. 13.01.2026
if nargin < 3, error("Parametri insufficienti"), end
if nargin < 4, tol=1e-12; end
if a==b, error("Intervallo invalido"), end
fa = feval(f,a);
fb = feval(f,b);
flag=1;
if fa * fb > 0, error("Bisezione non applicabile"), end

itmax = ceil(log2(b-a)-log2(tol));
for i=1:itmax
    x=(a+b)/2;
    fx = feval(f,x);
    if abs(fx) <= tol * abs((fb-fa)/(b-a))
        flag=0;
        break
    end
    if fa*fx>0
        b=x;
        fb=fx;
    else
        a=x;
        fa=fx;
    end
end
if flag, warning("Tolleranza non raggiunta"), end
return