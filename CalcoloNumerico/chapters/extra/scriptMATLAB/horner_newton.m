function p = horner_newton(f,xx,x)
    % function p = horner_newton(f,xx,x)
    % Funzione che valuta un polinomio interpolante in forma di Newton
    % nei punti all'interno di xx.
    % INPUT:
    % f - vettore delle differenze divise (diagonale della tabella)
    % xx - vettore di ascisse in cui valutare il polinomio
    % x - vettore delle ascisse di interpolazione
    % OUTPUT
    % p - vettore delle valutazioni del polinomio in ogni ascissa.
    % Rel.                          11.05.2026

    if nargin < 3, error("Parametri insufficienti"), end
    n = length(x)-1;
    if length(f) ~= n+1, error("Differenze divise insufficienti"), end

    p= a(n+1) * ones(size(xx)); % Inizializzazione alla diff. div. f[x0,x1,...,xn]
    for i = n: -1 : 1
        p = p .* (xx - x(i)) + f(i);
    end
end