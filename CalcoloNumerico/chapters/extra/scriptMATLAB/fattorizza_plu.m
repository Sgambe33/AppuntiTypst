function [LU, p] = fattorizza_plu(A)
% function [LU, p]=fattorizza_plu(A)
% Function per la fattorizzazione con pivoting parziale di una matrice.
% La matrice A deve solo essere non singolare.
% Input:
%   A - matrice non singolare;
% Output:
%   p - vettore delle permutazioni effettuate;
%   LU - matrice con le componenti L nella parte triangolare inferiore e U
%   nella parte triangolare superiore;
%                                                   Rel. 17.01.2026
n = size(A,1);
p = 1:n;
LU = A;
for i = 1:n-1
    % mi=valore, ki=indice relativo
    [mi, ki] = max(abs(a(i:n,i)));
    if mi == 0
        error('matrice singolare');
    end
    % Lo convertiamo in indice assoluto della matrice (da i a n).
    ki = ki + i - 1;
    % Se il pivot migliore non è già sulla diagonale facciamo lo scambio.
    if ki > i
        % Scambia le righe fisiche nella matrice A (parte numerica)
        % Scambia la riga corrente 'i' con la riga del pivot 'ki'. Vedi nota.
        LU([i ki], :) = LU([ki i], :);
        % Registra lo stesso scambio nel vettore p
        p([i ki]) = p([ki i]);
    end
    % Calcola i moltiplicatori di Gauss per la colonna corrente.
    LU(i+1:n, i) = LU(i+1:n, i) / LU(i,i);
    % Sottrae il prodotto colonna * riga: A_new = A_old - L * U
    LU(i+1:n, i+1:n) = LU(i+1:n, i+1:n) - LU(i+1:n, i) * LU(i, i+1:n);
end
if LU(n,n) == 0, error('matrice singolare'),end
return