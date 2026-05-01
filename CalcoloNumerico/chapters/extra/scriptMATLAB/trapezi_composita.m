function I1 = trapezi_composita(f, a, b, n)
% function I1 = trapezi_composita(f, a, b, n)
% Approssima l'integrale definito di f sull'intervallo [a,b]
% applicando la formula dei trapezi composita su n intervalli.
% INPUT:
% f - handle della funzione da integrare
% a, b - estremi dell'intervallo di integrazione
% n - numero di sottointervalli da utilizzare
% OUTPUT:
% I1 - approssimazione dell'integrale definito

if nargin < 4, error("Numero di argomenti non sufficiente"), end

if a > b, error("Intervallo di integrazione non valido"), end

h = (b-a)/(2*n);
x = linspace(a,b, n+1);

I1=0;
f1 = f(x(1));
for i=2:n+1
    f2 = f(x(i));

    I1 = I1 + f1 + f2;
    f1 = f2;
end

I1 = I1 * h;
end
