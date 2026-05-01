function I = trapezi_adattiva(fun, a, b, tol, fa, fb)
    % function I = trapezi_adattiva(fun, a, b, tol, fa, fb)
    % Approssimazione integrale con formula dei trapezi adattiva (ricorsiva).
    % Suddivide l'intervallo finché la stima dell'errore è sotto la tolleranza.
    %
    % Input:
    %   fun - function handle dell'integranda
    %   a, b - estremi di integrazione
    %   tol  - tolleranza assoluta richiesta
    %   fa, fb - (opzionali) valori fun(a) e fun(b) già calcolati
    % Output:
    %   I - approssimazione dell'integrale su [a, b]
    
    if nargin == 4
        fa = fun(a);
        fb = fun(b);
    end
    
    I=0;
    % Punto medio e nuova valutazione funzionale (l'unica necessaria)
    m   = (a + b) / 2;
    fm  = fun(m);
    
    % Calcolo delle due approssimazioni (h è la metà dell'intervallo)
    h = (b - a) / 2;
    T1 = h * (fa + fb); % Formula trapezi
    T2 = (h / 2) * (fa + 2*fm + fb); % Formula trapezi composita
    
    % Stima dell'errore
    err = abs(T2 - T1) / 3;
    
    if err > tol
        I = trapezi_adattiva(fun, a, m, tol/2, fa, fm) + trapezi_adattiva(fun, m, b, tol/2, fm, fb);
    else
        I = T2;
    end
end