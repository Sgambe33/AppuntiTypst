function I2 = simpson_composita(f, a, b, n)
    % function I2 = simpson_composita(f, a, b, n)
    % Approssima l'integrale definito di f sull'intervallo [a,b]
    % applicando la formula di Simpson composita su n intervalli.
    % INPUT:
    % f - handle della funzione da integrare
    % a, b - estremi dell'intervallo di integrazione
    % n - numero di sottointervalli da utilizzare (deve essere pari per Simpson)
    % OUTPUT:
    % I2 - approssimazione dell'integrale definito
    %                                                      Rel. 02.05.2026

    if nargin < 4, error("Numero di argomenti non sufficiente"), end

    if mod(n, 2) ~= 0, error("Numero di sottointervalli non pari"), end
    if a >= b, error("Intervallo di integrazione non valido"), end

    h = (b-a)/n;
    x = linspace(a,b, n+1);
    y = f(x);
    %I = (h/3)[ f(x0) + 4f(x1) + 2f(x2) + 4f(x3) + 2f(x4) + 4f(x5) + f(x6)]
    I2 = y(1) + y(end) + 4 * sum(y(2:2:n)) + 2 * sum(y(3:2:n-1));
    I2 = I2 * (h / 3);
end
f0 4fm f1 / 3 + f1 4fm2 f2 / 3 