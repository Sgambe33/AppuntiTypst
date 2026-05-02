function I = simpson_adattiva(fun, a, b, tol, fa, fb)
    % function I = simpson_adattiva(fun, a, b, tol, fa, fb)
    % Approssimazione integrale con formula di Simpson adattiva (ricorsiva).
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

    m   = (a + b) / 2;
    fm  = fun(m);

    h = (b - a) / 6;
    S1 = h * (fa + 4*fm + fb);

    m_sx = (a + m) / 2;
    m_dx = (m + b) / 2;
    f_msx = fun(m_sx);
    f_mdx = fun(m_dx);

    S_sx = ((m - a) / 6) * (fa + 4*f_msx + fm);
    S_dx   = ((b - m) / 6) * (fm + 4*f_mdx + fb);

    S2 = S_sx + S_dx;

    err = abs(S2 - S1) / 15;

    if err > tol
        I = simpson_adattiva(fun, a, m, tol/2, fa, fm) + simpson_adattiva(fun, m, b, tol/2, fm, fb);
    else
        I = S2;
    end
end