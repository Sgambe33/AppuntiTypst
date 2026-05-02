function x = ascisse_chebyshev(a,b,n)
    % function x = ascisse_chebyshev(a,b,n)
    % Funzione che genera le n ascisse di Chebyshev sull'intervallo [a,b].
    % INPUT:
    % a,b - estremi dell'intervallo di generazione
    % n - numero di ascisse da generare
    % OUTPUT:
    % x - vettore di dimensione n contenente le ascisse generate
    %                                                      Rel. 02.05.2026

    if nargin < 3, error("Parametri non sufficienti"), end
    if a>=b, error("Intervallo non valido"), end
    if n ~= fix(n) || n<=0, error("Numero di ascisse non valido"), end

    k1 = (a+b)/2;
    k2 = (b-a)/2;
    denominat = (2*n) + 2;

    x = k1 + k2 * cos((((2*(n:-1:0)) + 1) / denominat) * pi);
end