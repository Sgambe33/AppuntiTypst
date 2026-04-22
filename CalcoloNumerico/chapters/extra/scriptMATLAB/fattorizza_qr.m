function A = fattorizza_qr(A)
% function A = qr_householder(A)
% Calcola la fattorizzazione QR di una matrice A (m x n).
% La matrice A viene sovrascritta: la parte triangolare superiore contiene R,
% la parte strettamente inferiore contiene i vettori v che definiscono Q.
% Input:
%   A - matrice m x n (con m >= n);
% Output:
%   A - matrice sovrascritta con i fattori Q (H) (inferiore) e R (superiore);
%                                     Rel. 02.01.2026
[m, n] = size(A);
if m < n, error('sistema non sovradeterminato'), end
for i = 1:n
    % Calcolo della norma della colonna corrente (sotto la diagonale)
    alfa = norm(A(i:m, i));
    if alfa == 0, error('A non ha rango max'), end
    % Scelta del segno per evitare cancellazione numerica
    if A(i,i) >= 0, alfa = -alfa; end
    % Calcolo della prima componente del vettore di Householder
    v1 = A(i,i) - alfa;
    A(i,i) = alfa;
    A(i+1:m, i) = A(i+1:m, i) / v1;
    beta = -v1 / alfa;
    v = [1; A(i+1:m,i)]; % A_new=H*A_old=I-beta*v*(v'A_old)
    A(i:m, i+1:n) = A(i:m, i+1:n) - (beta * v) * (v' * A(i:m, i+1:n));
end
return