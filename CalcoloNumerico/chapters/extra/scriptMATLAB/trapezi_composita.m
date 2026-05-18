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
    %                                                      Rel. 02.05.2026

    if nargin < 4, error("Numero di argomenti non sufficiente"), end
    if a > b, error("Intervallo di integrazione non valido"), end

    h = (b - a) / n;
    x = linspace(a, b, n + 1);
    ff = f(x);

    % (h/2) * [f(x_1) + 2*f(x_2) + ... + 2*f(x_n) + f(x_{n+1})]
    I1 = (h / 2) * (ff(1) + 2 * sum(ff(2:end-1)) + ff(end));
end
