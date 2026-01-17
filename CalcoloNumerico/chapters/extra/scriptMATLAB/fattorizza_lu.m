function LU = fattorizza_lu(A)
% function LU=fattorizza_lu(A)
% Function per la fattorizzazione LU di una matrice. La matrice A deve
% essere non singolare così come tutte le sue sottomatrici.
% Input:
%   A - matrice non singolare;
% Output:
%   LU - matrice con le componenti L nella parte triangolare inferiore e U
%       nella parte triangolare superiore.
%                                                      Rel. 13.01.2026
[m,n] = size(A);
if m~=n, error("matrice non quadrata"), end
LU = A;

for i=1:n-1
    if A(i,i)==0, error("non fattorizzabile"), end
    LU(i+1:n,i)=LU(i+1:n,i)/A(i,i); %Vett. el. Gauss
    LU(i+1:n,i+1:n)=LU(i+1:n,i+1:n)-LU(i+1:n,i)*LU(i,i+1:n);
end
if A(n,n)==0, error("A singolare"), end
return