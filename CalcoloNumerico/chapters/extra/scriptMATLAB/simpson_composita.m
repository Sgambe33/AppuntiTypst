function I2 = simpson_composita(f, a, b, n)
    % function I2 = simpson_composita(f, a, b, n)
    % Approssima l'integrale definito di f sull'intervallo [a,b]
    % applicando la formula di Simpson composita su n intervalli.
    % INPUT:
    % f - handle della funzione da integrare
    % a, b - estremi dell'intervallo di integrazione
    % n - numero di sottointervalli da utilizzare (deve essere pari per Simpon)
    % OUTPUT:
    % I2 - approssimazione dell'integrale definito
    %                                                      Rel. 02.05.2026

    if nargin < 4, error("Numero di argomenti non sufficiente"), end

    if mod(n, 2) ~= 0, error("Numero di sottointervalli non pari"), end
    if a >= b, error("Intervallo di integrazione non valido"), end

    h = (b-a)/(6*n);
    x = linspace(a,b, n+1);

    I2=0;
    f1 = f(x(1));
    for i=2:n+1
        xm = (x(i-1)+x(i))/2;
        fm = f(xm);
        f2 = f(x(i));

        I2 = I2 + f1 + (4*fm) + f2;
        f1 = f2;
    end

    I2 = I2 * h;
end
