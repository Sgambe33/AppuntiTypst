function I = trapezi_adattiva(fun, a, b, tol, fa, fb)
    % function I = trapezi_adattiva(fun, a, b, tol, fa, fb)
    % Approssimazione integrale con formula dei trapezi adattiva (ricorsiva).
    % Suddivide l'intervallo finché la stima dell'errore è sotto la tolleranza.
    % INPUT:
    %   fun - function handle dell'integranda
    %   a, b - estremi di integrazione
    %   tol  - tolleranza assoluta richiesta
    %   fa, fb - (opzionali) valori fun(a) e fun(b) già calcolati
    % OUTPUT:
    %   I - approssimazione dell'integrale su [a, b]
    %                                                      Rel. 02.05.2026

    if nargin < 4, error("Numero di argomenti non sufficiente"), end
    if a >= b, error("Intervallo di integrazione non valido"), end

    if nargin == 4
        fa = fun(a);
        fb = fun(b);
    end

    % Punto medio e nuova valutazione funzionale (l'unica necessaria)
    m   = (a + b) / 2;
    fm  = fun(m);

    % Calcolo delle due approssimazioni (h è la metà dell'intervallo)
    h = (b - a) / 2;
    T1 = h * (fa + fb); % Formula trapezi
    T2 = (h / 2) * (fa + 2*fm + fb); % Formula trapezi composita

    err = abs(T2 - T1) / 3;

    if err > tol
        I = trapezi_adattiva(fun, a, m, tol/2, fa, fm) + trapezi_adattiva(fun, m, b, tol/2, fm, fb);
    else
        I = T2;
    end
end