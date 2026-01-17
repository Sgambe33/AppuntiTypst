function x = trisolve(A, b, flag)
% function x = trisolve(A, b, flag)
% Risolve un sistema triangolare
% Input:
%   A - matrice dei coefficienti;
%   b - vettore dei termini noti;
%   flag - vale 1 se il sistema è triangolare inferiore, triangolare superiore altrimenti;
% Output:
%   x - vettore soluzione;
%                                       Rel. 17.12.2025
if nargin < 3, error('parametri insufficienti'); end
[m,n] = size(A);
if m~=n || n~=length(b)
    error('dati non compatibili');
end
x = b(:); %copia vettore
if flag == 1
    for i=1:n
        if A(i,i)==0, error('matrice singolare'); end
        x(i)=x(i)/A(i,i);
        x(i+1:n)=x(i+1:n)-A(i+1:n,i)*x(i);
    end
else
    for i=n:-1:1
        if A(i,i)==0, error('matrice singolare'); end
        x(i)=x(i)/A(i,i);
        x(1:i-1)=x(1:i-1)-A(1:i-1,i)*x(i);
    end
end
return