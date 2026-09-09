function x = tridiag(b, a, c, z)
    % Funzione che risolve un sistema tridiagonale.
    % INPUT:
    % b - vettore elementi sottodiagonale (lunghezza n-1)
    % a - vettore elementi diagonale (lunghezza n)
    % c - vettore elementi sopradiagonale (lunghezza n-1)
    % z - vettore termini noti (lunghezza n)
    % OUTPUT:
    % x - vettore delle soluzioni
    %                                                      Rel. 02.05.2026

    n = length(a);
    if length(b) ~= n-1, error("Lunghezza sottodiagonale errata"), end
    if length(c) ~= n-1, error("Lunghezza sopradiagonale errata"), end

    % FATTORIZZAZIONE LU (sovrascrivo b con L, a con U) & risoluzione Ly=z
    y = z;
    for i = 2:n
        b(i-1) = b(i-1) / a(i-1);
        a(i) = a(i) - (b(i-1) * c(i-1));
        y(i) = z(i) - (b(i-1) * y(i-1));
    end

    % RISOLUZIONE Ux = y (Sostituzione all'indietro)
    x = zeros(size(z));

    x(n) = y(n) / a(n);

    for i = n-1:-1:1
        x(i) = (y(i) - c(i) * x(i+1)) / a(i);
    end
end