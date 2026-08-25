function p = horner(a,x)
    % function p = horner(a,x)
    % Funzione che valuta un polinomio in un punto x dati i suoi
    % coefficienti.
    % INPUT:
    % a - vettore dei coefficienti (eg. a0,a1,a2...)
    % x - punto in cui valutare il polinomio
    % OUTPUT
    % p - valore della valutazione del polinomio in x.
    % Rel.                          11.05.2026

    if nargin < 2, error("Parametri insufficienti"), end
    
    n = length(a)-1;
    p= a(n+1); %Si presuppone che i coeff. siano crescenti nel vettore
    for i = n: -1 : 1
        p = p * x + a(i);
    end
end