#import "../../dvd.typ": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/lovelace:0.3.1": *

= BOH
#figure(image("/assets/image-2.png", height: 50%))

#proposition()[
  Supponiamo che $"P" = "NP"$.\ 
  Sia $L in "NP"$, con $L eq.not emptyset, overline(L) eq.not emptyset$, allora $L in "NP"cal(L)$

  HP. \
  - $exists alpha in L$
  - $exists beta in.not L$
]
#proof()[
  $L in "NP"$ facciamo vedere che $L$ è NP-difficile. \
  Sia $Q in "NP-completo"$. Descriviamo una riduzione polinomiale da $Q$ a $L$:
  $
    f: w mapsto cases(alpha "se" w in Q, beta "se" w eq.not Q)
  $
]

#observation()[
  - $emptyset$ non è NP-difficile. Dato $Q in "NP"$, esiste una riduzione polinomiale da $Q$ a $emptyset$? NO
  - $Sigma^*$ non è NP-difficile (motivo analogo). $Q arrow.squiggly.long Sigma^*$
]

#proposition()[
  L è NP-difficile e $f$ è una riduzione polinomiale da L a Q. Allora Q è NP-difficile.
]
#proof()[
  Dato $R in "NP"$, descriviamo una riduzione polinomiale da R a Q
  - Poiché L è NP-difficile e R $in$ NP, $exists g$ riduzione polinomiale da R a L:
  $
    g: Sigma^*_R arrow.long Sigma^*_L quad quad w in R <=> g(w) in L
  $
  - Sappiamo che L è polinomio ridotto a Q:
  $
    f: Sigma^*_L arrow.long Sigma^*_Q quad quad w in L <=> f(w) in Q
  $

  Osserivamo che:
  $
    f compose g: Sigma^*_R arrow.long Sigma^*_Q quad quad w in R <=> f(g(w)) in Q
  $
  Inoltre è calcolabile in tempo polinomiale
]

#problem("3-SAT")[
  Dato un polinomio booleano $p$ in 3-CNF\*, determinare se $p$ è soddisfacibile.\ 
  (\*) Ogni clausola contiene esattamente 3 letterali
]
#observation()[
  3-SAT $in$ NP.
]

Facciamo vedere che 3-SAT è NP-difficile.\ 
Per fare ciò cercheremo una riduzione polinomiale da SAT a 3-SAT.

$p$ polinomio booleano in CNF.\ 
$p = u_1 and u_2 and dots and u_m$ ($u_i$ clausole)\ 
$u$ clausola di $p$
- $u = v$ (_v_ letterale; $x,y$ variabili nuove)\ 
  $accent(a, tilde)= (v or x or y) and (v or x' or y) and (v or x or y') and (v or x' or y')$
  $
    u "soddisfacibile" <=> accent(u, tilde) "soddisfacibile"
  $
- $u = v_1 or v_2 quad quad (x "variabile nuova")$\
  $accent(u, tilde)=(v_1 or v_2 or x) and (v_1 or v_2 or x')$
  $
    u "soddisfacibile" <=> accent(u, tilde) "soddisfacibile"
  $
- $u = v_1 or v_2 or v_3 arrow.long accent(u, tilde) = u$
- $u = v_1 or v_2 or dots or v_n quad quad (n >= 4; y_1, dots, y_(n-3) "variabili nuove")$\ 
  $accent(u, tilde) = (v_1 or v_2 or y_1) and (v_3 or y_1^' or y_2) and dots and (v_j or y_(j-2)^' or y_(j-1)) and dots and (v_(n-2) or y_(n-4)^' or y_(n-3)) and (v_(n-1) or v_n or y_(n-3)^')$

#pagebreak()
+ u soddisfacibile $=> accent(u, tilde)$ soddisfacibile
  V variabili di $p$\
  sia $t: V --> {0, 1} quad t.c. quad t(u) = 1$\ 
  sia $v_j$ il primo letterale di u t.c. $t(v_j) = 1$\ 
  sia $accent(t, tilde): V union {y_1, dots, y_(n-3)} --> {0, 1}$ come segue:
  $
    accent(t, tilde)(x) = cases(t(x) quad quad&"se" x in V, 1 &"se" x = y_1\, dots\, y_(j-2), 0 &"se" x=y_(j-1)\, dots\, y_(n-3))
  $
+ $accent(u, tilde) "soddisfacibile" => u "soddisfacibile"$\
  sia $accent(t, tilde): V union {y_1, dots, y_(n-3)} -->{0, 1} quad quad t.c. quad accent(t, tilde) (accent(u, tilde))=1$\
  sia $t = accent(t, tilde)_(|V)$\
  Si dimostra che $t(u) = 1$

== Problema del Vertex Cover (VC)

#definition()[
  Dato $G=(V, E)$ grafo non orientato, un *vertex cover* di G è un sottoinsieme $c subset.eq V$ t.c. $forall{x,y} in E, x in C "oppure" y in C$
]
#problem()[
  Dato G grafo non orientatoe $k in NN$, esiste un VC $C "di" G$ con $abs(C) = k?$
]
#observation()[
  VC $in$ NP
]

Costruiamo una riduzione polinomiale da 3-SAT a VC.\
Sia _p_ polinomio booleano in 3-CNF\
$
  &p=(u_(1,1) or u_(1,2) or u_(1,3)) and (u_(2,1) or u_(2,2) or u_(2,3)) and dots and (u_(m,1) or u_(m,2) or u_(m,3))\
  &p=(x_1 or x_2^' or x_3) and (x_1^' or x_2 or x_4^') quad cases(m "clausole", n "variabili") quad {x_1, dots, x_n}
$
#image("/assets/image-3.png")
#observation()[
  In un VC di G(p) ci devono essere almeno $n+2m$ vertici
]
Facciamo vedere che _p_ è soddisfacibilee #underline("sse") G(p) ha un VC di cardinalità $2+2m = k(p)$

$==>)$ Sia t assegmanento t.c. $t(p) = 1$\
#box($
  quad quad &circle.filled.small) &&forall i = 1,dots, n "scegliamo" cases(x_i quad "se" t(x_i) = 1, x_i^' quad "se" t(x_i^') = 0)\ 
  quad quad &circle.filled.small) &&"per ogni clausola, individuiamo un letterale che soddisfa la clausola, e scegliamo i rima-"\
  & && space "nenti 2"
$)
L'insieme dei vertici scelti ha cardinalità $n + 2m$ ed è un VC.\ 
$<==)$ sia t t.c.:
$
  t(x_i) = cases(1 quad quad & "se" x_i in "VC", 0 quad quad & "se" x_i' in "VC")
$
t soddisfa p

== Problema di Clique

#problem("Clique")[
  Dato un grafo non orientato G e un intero k, determinare se esiste un sottografo completo di G avente k vertici.
]

#observation()[
  Il problema di Clique $in$ NP.
]

#proposition()[
  Clique è NP-difficile
]

#proof()[
  Descriviamo una riduzione polinomiale da 3-SAT a Clique.

  _p_ polinomio booleano in 3-CNF
  $
    &p = u_1 and u_2 and dots and u_k quad quad quad quad quad quad  &&| (x_1 or x_2^' or x_3) and (x_1^' or x_2 or x_4^')\
    &u_i = (u_(i, 2) or u_(i, 2) or u_(i, 3)) &&|
  $

  $G(p) = (V, E)$\
  V: un vertice per ciascun letterale di ogni clausola\
  E: un lato per ogni copia di vertici, tranne:
  - Vertici della stessa clausola
  - Vertici che rappresentano letterali opposti

  #figure(image("/assets/image-4.png", width: 50%))

  p è soddisfacibile $<==> G(p)$ ha un sottografo completo di cardinalità k.

  $==>)$ Sia _t_ assegnamento t.c. $t(p)=1$. Per ogni clausola di _p_, scegliamo un letterale soddisfatto da _t_, e consideriamo il sottografo di $G(p)$ formato dai vertici che rappresentano tali letterali aduhaw
  #figure(image("/assets/image-5.png"))
  \
  $<==)$ sia ${v_1, dots, v_k}$ sottografo completo di $G(p)$. $forall i=1,dots,k$, sia $u^((i))$ il letterale associato a $v_i$; Definiamo un assegnamento _t_ t.c. $t(u^((i))) = 1$.
  - _t_ è ben definito;
  - _t_ soddisfa _p_.

  #figure(image("/assets/image-6.png"))
]

== Problema HAM

#proposition()[
  Il problema del circuito hamiltoniano è NP-difficile ($("HAM") in "NP"$)
]

#proof()[
  Descriviamo una riduzione da 3-SAT a HAM.\
  $
    & p = u_1 and u_2 and dots and u_m, quad u_i = (u_(i,1) or u_(i,2) or u_(i,3))\
    & V = {x_1, dots, x_n}
  $
  Si introducono quattro categorie di nodi: _t_ (true), _f_ (false), $e_i$ (entrata), $o_i$ (output)\ 
  Per ogni variabile $x_i$ si crea un grafo formato nel seguente modo:
  #grid(
    columns: (0.5fr, 0.5fr),
    rows: (4em, 1em, 2em, 4em),

    align: (center, left),

    grid.cell(rowspan: 6, image("/assets/image-8.png")),
    grid.cell(rowspan: 3, [- Esiste un arco tra un vertice $t_(i,j)$ e un vertice $f_(i, j+1)$ e un arco tra un vertice $f_(i,j)$ e un vertice $t_(i,j+1)$;]),
    [- Esiste un arco da $t_(i,j)$ a $f_(i,j)$ e viceversa;],
    [- con $r_i$ = massimo fra le occorrenze di $x_i "e" x_i^'$ in _p_]
  )

  I pezzi di grafo così costruiti si connettono aggiungendo un lato da $o_i "a" c_(i+1)$, per ogni i, infine si aggiunge un lato da $o_n "a" e_1$.
  Essendo che ogni variabile ha 2 camini hamiltoniani da $e_j "a" o_j$:.
  #grid(
    columns: (0.5fr, 0.5fr),
    rows: 25em,
    align: center,

    [#image("/assets/image-12.png")],
    [#image("/assets/image-13.png")]
  )
  Per cui si hanno in totale $2^n$ circuiti hamiltoniani nel grafo rappresentato sotto.
  #figure(image("/assets/image-10.png"))

  Si ha quindi $u_j=(u_(j, 1) or u_(j, 2) or u_(j, 3))$, si inseriscono i nodi $i n_(i, j)$ e $o u t_(i, j)$

  #grid(
    columns: (0.5fr, 0.5fr),
    rows: 10em,
    align: (center, center+horizon),

    [#image("/assets/image-15.png")], [Ne serve uno per ogni clausola $u_j$]
  )

  Esempio:
  $
    p = (x_1 or x_2 or x_3^') and (x_1^' or x_2 or x_4^') and (x_1 or x_2^' or x_4) and (x_1^' or x_3 or x_4)
  $
  Devo sapere quanti nodi vanno scritti, sapere quindi quanto vale $r_i$ (massimo delle occorrenze di $x_i "e" x_i^' "in" p$). Esempio per $x_1$:

  $x_1$ appare 2 volte, $x_1^'$ appare 2 volte, $==> r_i = 2 ==>$ sono 3 nodi $0, 1, 2$.
  #figure(image("/assets/image-17.png", width: 75%))
]

#pagebreak()

== Problema 2-SAT
#problem()[
  Dato un polinomio booleano _p_ in 2-CNF, determinare se _p_ + soddisfacibile
]

#proposition()[
  Il problema 2-SAT $in$ P.
]

#proof()[
  Sia $p = u_1 and u_2 and dots and u_s " con " u_i = u_(i, 1) or u_(i, 2)$

  Costruiamo un grafo orientato $G(p)$ nel seguente modo:
  - Vertici: $forall x$ variabile che compare in _p_, si scrivono i nodi $x "e" x'$ (2 vertici)
  - Archi: $forall "clausola" u_i$, 2 archi: $cases(u_(i, 1)^' --> u_(i, 2), u_(i, 2)^' --> u_(i, 1))$

  #image("/assets/image-7.png") // no
]

#proposition()[
  _p_ è soddisfacibile $<==> exists.not x "variabile di" p "t.c. in" G(p) space x arrow.squiggly.long x' " e " x' arrow.squiggly.long x$
]

#proof()[\ 
  $==>)$ Sia _x_ t.c. $x arrow.squiggly.long x' " e " x' arrow.squiggly.long x$. Facciamo vedere che _p_ non è soddisfacibile. Sia _t_ assegnamento:
  - $t(x) = 1$, quindi

    $&x --> gamma_1 --> gamma_2 --> dots &&dots dots &&alpha --> &&beta space  dots --> gamma_(n-1) --> gamma_n --> &&x'\
    &t(x)=1 &&t(alpha)&&=1 &&t(beta) = 0 &&t(x') = 0$\
    In _p_ c'è la clausola $alpha' or beta$ che non è soddisfatta da _t_

  $<==)$ Senza perdita di generalità, supponiamo che $exists alpha$ letterale t.c. in _p_ compaiono sia $alpha$ che $alpha'$ (altrimenti _p_ sarebbe banalmente soddisfacibile).
    Se, per assurdo, $forall alpha$ letterale t.c. $alpha, alpha'$ compaiono in _p_, $alpha arrow.long.squiggly alpha'$, allora, se $beta$ è uno di questi letterali, $cases(beta arrow.long.squiggly beta', beta' arrow.long.squiggly beta)$. Questo è assurdo perché contro l'HP.

    Pertanto $exists alpha$ letterale di _p_ t.c. $alpha'$ è anch'esso letterale di _p_ e $alpha cancel(arrow.long.squiggly) alpha'$

    Dato un letterale $alpha$, cominciamo a definire l'assegnamento _t_ ponendo:
    - $t(alpha) = 1$
    - $forall beta " t.c. " alpha arrow.long.squiggly beta, t(beta) = 1$
    Osserviamo che fin qui _t_ è ben definito, perché non può accadere che $t(beta') = 1$, in quanto $alpha cancel(arrow.long.squiggly) beta$, infatti, se per assurdo $alpha arrow.long.squiggly beta' ==> beta arrow.long.squiggly alpha'$ 
]

=== Algoritmo per il problema 2-SAT
+ Costruisco il grafo $G(p)$
+ $forall x$ variabile di _p_, controllo se c'è $x arrow.long.squiggly x' " e " x' arrow.long.squiggly x$:
  - Se sì, allora _p_ non è soddisfacibile;
  - Altrimenti _p_ è soddisfacibile

== Linguaggi NP-intermedi
#grid(
  columns: (0.75fr, 0.25fr),

  [
    Se $"P" eq.not "NP":$
    #definition()[
      I linguaggi NP-intermedi (o NP-I) sono linguaggi di NP che non stanno nè in P nè in NP-completi (o NP-C).

      $"NP-I" = "NP" \\ ("P" union "NP-C")$
    ]
    #theorem("Ladner")[
      Se $"P" eq.not "NP, allora NP-I" eq.not emptyset$
    ]
    P è chiuso rispetto alla complementazione.
    #problem("Aperto")[
      NP è chiusa per complementazione?
      $ "co-NP = NP?" $
    ]
    #definition()[
      co-NP $= {L "linguaggi" | L' in "NP"}$
    ]
  ],
  [#figure(image("/assets/image-2.png", height: 50%))]
)

#example()[
  #underline("UNSAT"): Dato un polinomio booleano _p_, determinare se _p_ *non*
 è soddisfacibile:
 $
   L_("UNSAT") in "co-NP"
 $
]

#proposition()[
  NP $eq.not$ co-NP $==>$ P $eq.not$ NP
]
#proof()[\
  $
    "P" eq.not "NP" <== cases("NP" eq.not "co-NP", "P" = "co-NP")
  $
]

#proposition()[
  $
    "co-NP" = "NP" <== cases(L in "co-NP", L in "NPC")
  $
]
#proof()[
  #rect($"co-NP" subset.eq "NP"$)
  $Q in "co-NP" ==> Q' in "NP"$

  Poiché $L in "NPC", exists f$ riduzione polinomiale da $Q' "a" L$, osserviamo che _f_ è anche riduzione polinomiale da $Q "a" L' in "NP"$

  Algoritmo polinomiale non deterministico per decidere $Q$: data $w$,
  - Calcolo $f(w)$
  - Decido se $f(w) in L'$
  Pertanto $Q in "NP"$

  
  #rect($"NP" subset.eq "co-NP"$)
  $Q in "NP" ==> Q' in "co-NP" ==> Q' in "NP" ==> Q in "co-NP"$
]

== 06/05/2026
== Numeri primi
#proposition()[
  _n_ composto $==> exists d | n, " con " d in [2, sqrt(n)]$
]

#proof()[
  $n = m_1 dot m_2$\
  Per assurdo: $m_1, m_2 > sqrt(n) => n = m_1 dot m_2 > n, $ (assurdo)
]

=== Algoritmo deterministico

Dato $n in NN$, per ogni $d in [2, sqrt(n)]$ controllo se $d | n$:
- se sì: $n$ composto;
- altrimenti, $n$ primo

La complessità dell'algoritmo rispetto alla lunghezza _l_ è almeno la seguente:
$
  Omega(sqrt(n)) = Omega(2^(l/2))
$

=== Codifica binaria di $n$
$
    &log n = &&l-->"parametro per la complessità"\
    &" "arrow.t &&arrow.t\
  n &= 2^l && "Lunghezza della codifica binaria di "n
$

=== Piccolo teorema di Fermat
+ $ a^p equiv a(p) <== cases(delim: "[", p "primo", a in NN) $
+ $ a^(p-1) equiv 1(p) <== cases(delim: "[", p "primo", a in NN, (a, p) = 1) $

=== Algoritmo non deterministico #underline("non corretto") polinomiale

Dato $n in NN$:
- genero non deterministicamente $a in NN "t.c. "(a, n) = 1$
- se $a^(n-1) equiv (n)$, allora $n$ primo
- altrimenti, $n$ composto

Complessità: esiste un algoritmo per calcolare le potenze modulari $a^n$ con complessità:
$ Omicron(log n^2) = Omicron(l^2) $

#theorem("Pratt, 1975")[
  $ n in NN$.\
  Se $exists a in NN "t.c."$:
  - $(a, n) = 1$
  - $a^(n - 1) equiv 1 (n)$
  - $forall q | n - 1, q "primo", a^((n-1)/q) equiv.not 1 (n)$
  Allora $n$ è primo
]
#observation()[
  Ogni numero naturale possiede meno fattori primi distinti che caratteri nella sua rappresentazione binaria.

  $
    n = p_1^(alpha_1) dot p_2^(alpha_2) dot dots dot p_r^(alpha_r)
  $
  caso peggiore $alpha_1 = alpha_2 = dots = alpha_3 = 1$:
  $
    n = p_1 dot p_2 dot dots dot p_r > 2^r
  $
]
Testare la condizione del piccolo teorema di Fermat per un certo numero di $a$.

#definition()[
  $n in NN$ si dice *numero di Carmichael* quando $forall a in NN, (a, n) == 1$, vale $ a^(n-1) equiv 1 (n)$ e $n$ non è primo.
]

#example()[
  561 è un numero di carmichael. $561 = 3 dot 11 dot 17$
]

#theorem("Alford, Granville, Pomerance")[
  Esistono infiniti numeri di carmichael
]

#underline("Idea"): Modifica del piccolo teorema di Ferma
#theorem("Agrawal")[
  $2 <= n in NN, a in NN$\
  $(a, n) = 1 quad quad n "primo" <==> (x + a)^n equiv x^n + a (n)$
]

#proof()[\
  $==> )$ n primo (congruenze tutte modulo n):
    $
      (x + a)^n = sum_(k=0)^n binom(n, k)a^(n - k)x^k equiv x^n + a^n equiv x^n + a space (n)\
      binom(n, k) = (n!)/(k!(n - k)!) = (n dot (n - 1) dot dots dot (n - k + 1))/(k!) quad quad 0 < k < n --> n bar binom(n, k)
    $
  $<== )$ n composto. Facciamo vedere che $exists k "con" 0 < k <= n$,
  $
    n cancel(inverted: #true, bar) binom(n, k)
  $
  Sia $p | n, p "primo"$:
  $
    &p^alpha | n, "ma" p^(alpha + 1) cancel(inverted: #true, bar) quad quad quad quad binom(n, p) = (n dot (n - 1) dot dots dot (n - p + 1))/(p dot (p - 1) dot dots dot 2 dot 1)\
    &p^alpha "divide il numeratore", quad p^(alpha + 1) "non divide il numeratore"\
  $
  $
    p^alpha cancel(inverted: #true, bar) binom(n, p) ==> n cancel(inverted: #true, bar) binom(n, p)
  $
]

Le congruenze da testare sono circa "n = 2^l"\
#underline("IDEA"): dividere i polinomi per $x^r - 1$, per opportuno r
#underline("Agrawal, Kayac, Saxena (2002)")
- Se _n_ è composto, e si sceglie un _r_ "giusto", allora è sufficiente testare la seguente congruenza per "pochi" _a_:
$
  (x+a)^n equiv x^n + a quad (n, x^r - 1)
$
e ne trovo uno per cui non vale

// SONO ESERCIZI SVOLTI A LEZIONE
//#example(multiple: true)[
  
//]

== Lezione 07-05-2026

== Classi di complessità

=== Linguaggi esponenziali

Si definiscono come:
$
  "Exp" = {L | exists M "MdT deterministica che accetta" L "t.c." t_C_M (n) = Omicron(2^n^k), exists k >= 1}
$

#observation()[
  $L in "Exp" <==> exists M "MdT deterministica che accetta" L "t.c." Omicron(c^p(n)), exists c > 1, exists p "polinomio di grado" >=1", sennò sarebbe costante"$

]
- $"P" subset.eq "Exp"$

#proposition()[
  $"NP" subset.eq "Exp"$
]
#proof()[
  Si basa sulla costruzione di una MdT deterministica equivalente ad una non deterministica.
  $
    L in "NP" ==> exists M "MdT non deterministica "&"polinomial"&&"e che accetta" L "t.c." t_C_M (n)=p(n)\
    "grado di non determinismo di M" <-- S^p(n) &dot p(n) --> &&"complessità di una MdT"\
    & &&"deterministica equivalente a M"
  $
]

#problem("Aperto")[
  Ancora non si sa se le inclusioni sono strette o no:
  $
    "P" limits(subset.eq)^? "NP" limits(subset.eq)^? "Exp"
  $
]

#proposition()[
  $"P" subset "Exp"$
]

#proof()[
  Facciamo vedere che $exists L in "Exp", L in.not "P"$
  $
      &L = {(M)x | "se M su x termina in uno stato finale ciò avviene entro" 2^(2|x|) "passi"}
  $
  1. L $in$ Exp\
      N MdT su input $R(M)x$:
    - Esegue M su x
      - Se M termina in uno stato finale entro $2^(2|x|)$ transizioni, accetta;
      - Altrimenti, rifiuta
    N accetta L

    *Complessità in tempo di N*\
    $
      |underbracket(R(M), "corto")underbracket(x, "lungo")|
    $
    Per avere il caso peggiore, considero $|R(M)|$ corta rispetto a $|x|$, in modo tale che $|R(M)x|n space |x|$

    $
      T_C_N (n) = Omicron(2^(2n)) arrow.long.squiggly L in "Exp"
    $

    #observation()[
      $2^(2n) in.not Omicron(2^n)$ ?? TODO: completare
    ]

  + L $in.not$ P\
    Facciamo vedere che $exists.not$N MdT deterministica che accetta L t.c. $t_C_N (n) = Omicron(2^n)$

    #underline("Per assurdo"): sia MdT deterministica che accetta L per stati finali t.c. $t_C_N (n) = 2^n$\

    Sia D MdT definita come segue:\
    $quad$ Su input R(M):
    - Esegue N su R(M)R(M)
      - Se N termina in uno stato finale, D termina in uno stato non finale;
      - Se N termina in uno stato non finale, D termina in uno stato finale;

    Complessità in tempo di D:
    $
      |R(M)| = n\
      t_C_D (n) = t_C_N (2n) = 2^n 
    $ 
    Eseguiamo D su R(D):
    + D su R(D) termina in uno stato finale $==>$ per definizione di D, N su R(D)R(D) termina in uno stat non finale $==>$ dato che N è una MdT che accetta L e R(D)R(D) non appartiene al linguaggio, D su R(D) non termina in unno stato finale entro $2^(2|R(D)|)$ transizioni $==>$ dato che $t_C_D (n) = 2^(2n)$, D su R(D) non termina in uno stato finale $==>$ *ASSURDO*\

    + D su R(D) termina in uno stato non finale $==>$ per definizione di D, N su R(D)R(D) termina in uno stato finale $==>$ dato che N è una MdT che accetta L, D su R(D) termina in uno stato finale entro $2^(2|R(D)|)$ transizioni $==>$ *ASSURDO*
]

Definisco un'altra classe di linguaggi esponenziali:
$
  "NExp" = { L "linguaggio" | exists"M MdT non deterministica che accetta "L "t.c." t_C_M (n) = Omicron(2^n^k), exists k >= 1}
$

#observation()[
  $ "Exp" subset.eq "NExp" $
]

#problem("Aperto")[
  $ "Exp" = "NExp" $
]

#proposition()[
  Se si dimostra ch e Exp $eq.not$ NExp, allora P $eq.not$ NP
]

#proof()[
  Facciamo vedere che $"P" = "NP" ==> "Exp" = "NExp"$.\
  Faremo vedere che NExp $subset.eq$ Exp\

  Sia $L in "Nexp"$ e M MdT non deterministica che accetta $L$ t.c. $t_C_M (n) = Omicron(2^n^k)$
  $
    accent(L, tilde) = {x& 1^2^(|x|^k)  | x in L} quad quad quad (1 in.not "alfabeto di" L)\
    & arrow.t\
    & "Tanti 1 quanti la complessità di L"
  $
  Facciamo vedere che $accent(L, tilde) in "NP"$. Sia N MdT non deterministica che accetta $accent(L, tilde)$:
    - Dato y, controllo se $exists z "t.c." y = z 1^2^(|z|^k)$, altrimenti rifiuto;
    - Se il controllo è passato, eseguo M su z e, in più al $2^(|z|^k)$ passi, decido se  $z in L$ oppure no.
  
  La complessità in tempo di N è polinomiale in $|y|$ (lunghezza di _y_). Quindi $accent(L, tilde) in "NP"$\
  Poiché per ipotesi P $in$ NP $==> accent(L, tilde) in$ P.\
  Dunque $exists R$ MdT deterministica polinomiale che accetta $accent(L, tilde)$. MdT deterministiica per L:
    - Data x, costruisco la stringa $x 1^2^(|x|^k)$;
    - Uso R per stabilire se $y in accent(L, tilde)$.
  Complessivamente, l'algoritmo descritto sopra è esponenziale nella lunghezza di x.  
]

== Complessità in spazio di M

#definition()[
  Sia M una MdT a k+1 nastri:
  - nastro 1 per l'input (mai modificato);
  - k nastri di lavoro.

  La *complessità in spazio di M* è una funzione:
  $
    s_C_M: NN --> NN
  $ 
  in cui, $s_C_M (n)$, è il numero di celle sui nastri di lavoro a cui le testine hanno accesso durante una compuazione di M su una stringa di lunghezza n, nel caso peggiore.
]

#observation(multiple: true)[
  + La definizione vale sia nel caso deterministico che in quello non deterministico;
  + Non è necessario che M termini su ogni input;
  + È possibile che $s_C_M (n) < n$ (a lezione: $s_C_M (n) > 0$)
]

#example()[
  // TODO: aggiungere esempio fatto a lezione
]

== Lezione 11-05-2026

#example()[
  L linguaggio delle palindrome binarie su ${a,b}$. Descriviamo il comportamento di una MdT M che accetta tale linguaggio.

  All'inizio scrivo 1 sul nastro 3, il nastro 2 è vuoto, sul nastro 2 c'è l'input le testine sono a inizio nastro.

  Quando sul nastro 3 c'è _*i*_:
  - Copio _*i*_ sul nastro 2;
  - Finché non arrivo a 0 sul nastro 2:
    - Sposto la testina a destra sul nastro 1;
    - Decremento il contatore sul nastro 2.
  - Se sul nastro 1 trovo \*, accetto;
  - Altrimenti, leggo il carattere sul nastro 1 (*$w_i$*) e lo "memorizzo";
  - Sposto la testina del nastro 1 sulla prima cella \* a destra dell'input;
  - Copio _*i*_ sul nastro 2;
  - Finché non arrivo a 0 sul nastro 2:
    - Sposto la testina a sinistra sul nastro 1;
    - Decremento il contatore sul nastro 2.
  - Confronto *$w_i$* con *$w_(n-i)$*, se sono diversi, rifiuto; Altrimenti aggiorno il nastro 3 scrivendo $i+1$ e ricomincio.

  La complessità in spazio di M nel caso peggiore (accettazione) è:\
  Se scrivo i numeri naturali in binario devo scrivere $n+1$ sui nastri 2 e 3, quindi
  $
    s_C_M (n) = 2 dot (ceil(log(n+1))+2)
  $
]

#proposition()[
  M MdT a 2 nastri:
  $
    t_C_M (n) = f(n) ==> s_C_M (n) <= f(n) + 1
  $
]
#proof()[
  Nel caso peggiore, M legge una nuova cella sul nastro di lavoro ad ogni transizione, aggiungendo la cella iniziale: $s_C_M (n) <= f(n) + 1$
]

#proposition()[
  M MdT a 2 nastri, $|Q| = m, |Sigma| = t$ (cardinalità di insieme degli stati e alfabeto):
  $
    s_C_M (n) = f(n) ==> t_C_M (n) <= m(n+2)f(n)t^f(n)
  $
]
#proof()[
  Poiché M termina su ogni input, essa non può transitare 2 volte per la stessa configurazione. Valutiamo il numero totale di possibili configurazioni di M su una stringa in input di lunghezza _n_, con il numero di stati $|Q| = n, "l'alfabeto di lavoro" |Sigma| = t$:
  $
    m dot (n+2) dot f(n) dot t^f(n)
  $
  Dove:
  - m è il numero di possibili stati;
  - $n+2$ è il numero di possibili posizione della testina sul nastro 1, su un simbolo della stringa, sulla prima cella vuota o sull'ultima;
  - $f(n)$ è il nunmero di possibili posizioni della testina sul nastro 2;
  - $t^f(n)$ è il numero di possibili simboli da scrivere nelle $f(n)$ celle lette sul nastro 2;
  
  Si conclude che:
  $
    t_C_M <= m(n+2)f(n)t^f(n)
  $
]

=== Classi di linguaggi con complessità spaziale

#definition()[
  $
    "PSpace" = {L "linguaggio" | &exists M "MdT deterministica che accetta" L "t.c." \
                                 &s_C_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#observation(multiple: true)[
  + $"P" subset.eq "PSapce"$\
    $"P" limits(=)^? "PSpace"$
  + $"PSpace" subset.eq "Exp"$
    $"PSpace" limits(=)^? "Exp"$
  + $"NP" subset.eq "PSpace"$
    $L in "NP" ==> exists M "MdT non deterministica polinomiale che accetta" L$\
    Poiché si può riutilizzare lo spazio
]

#definition()[
  $
    "NPSpace" = {L "linguaggio" | &exists M "MdT non deterministica che accetta" L "t.c." \
                                 &s_C_M (n) = Omicron(n^k), exists k >= 1}
  $
]

#observation()[
  $"PSpace" subset.eq "NPSpace"$
]

#pagebreak()
=== Teorema di Savitch

#theorem("Savitch - PDF è più dettagliato")[
  $"PSpace" = "NPSpace"$
]

#proof()[
  $"PSpace" subset.eq "NPSpace"$ (ovvio)\
  Vogliamo mostrare che $"NPSpace" subset.eq "PSpace"$:
  $L in "NPSpace"$, M MdT non deterministica, tale che $s_C_M (n) = s(n)$, che accetta _L_ in spazio polinomiale.

  Numero di possibili configurazioni di M in una sua computazione su input di lunghezza _m_:
  $
    Omicron(2^(c dot s(n))) quad quad "per un opportuno c"
  $
  Sia _x_ una stringha di lunghezza _m_ e $C_x$ la configurazione di M all'inizio della computazione di _x_. Allora, _x_ è accettata da M $<==> exists $ una computazione di M che, partendo da $C_x$, raggiunge $C^\*$ in al più $2^(c dot s(n))$ transizioni.
  $
    "Configurazione iniziale" <-- C_x arrow.long.squiggly C^* --> &"Configurazione accettante"\ &"(supponiamo che sia unica)"
  $

  Sia *reachable($C, C^', k$)* con due configurazioni di M e un numero naturale. Esso è vero quando, partendo dalla prima configurazione si può raggiungere la seconda in al più $2^j$ transizioni.
]

// Lezione del 13-05-2026
#definition()[
  L linguaggio si dice *PSpace-difficile* quando $forall Q in "PSpace", exists f$ riduzione polinomiale in tempo da _Q_ a _L_.

  L si dice *PSpace-completop* quando L è PSpace-difficile e $L in "PSpace"$
]

#proposition()[
  + L PSpace-completo $quad quad ==> "P" = "PSpace"$\
    $"L" in "P"$
  + L PSpace-completo $quad quad ==> "NP" = "PSpace"$\
    $"L" in "NP"$
]

#proof()[
  + P $in$ PSpace (ovvio)\
    $Q in "PSpace"$; Poiché L è PSpace-completo, $exists f$ riduzione polinomiale in tempo da Q a L.\ 
    Algoritmo per decidere Q:
    - Dato _w_, calcolo $f(w) arrow.long.squiggly$ tempo polinomiale;
    - Decido se $f(w) in L arrow.long.squiggly$ tempo polinomiale (perché $L in "P"$);
    $quad quad quad quad quad quad space &arrow.b.double\ Q &in "P"$
  
  
  + P $in$ PSpace (ovvio)\
    $Q in "PSpace"$; Poiché L è PSpace-completo, $exists f$ riduzione polinomiale in tempo da Q a L.\ 
    Algoritmo per decidere Q:
    - Dato _w_, calcolo $f(w) arrow.long.squiggly$ tempo polinomiale;
    - Decido se $f(w) in L arrow.long.squiggly$ tempo polinomiale (perché $L in "NP"$);
    $quad quad quad quad quad quad space &arrow.b.double\ Q &in "NP"$

  La 2 da verificare
]

== Problemi di conteggio
$Sigma = {0, 1}, quad f: Sigma^* --> NN$

#definition()[
  Si chiama $cal(F)P$ la classe delle funzioni $f: Sigma^* --> NN$ per cui esiste una MdT deterministica che calcola _f_ in tempo polinomiale:
  $
    cal(F)P = {f: Sigma^* --> NN | exists M "MdT che calcola" f "t.c." t_C_M (n) = Omicron)n^k, exists k >= 1}
  $
]

#definition()[
  Si chiama *\#_P_* (sharp P) la classe delle funzioni $f: Sigma^* --> NN$ per cui esiste una MdT non deterministica polinomiale tale che, per ogni stringa $w in Sigma^*$, le computazioni accentanti di M su _w_ sono $f(w)$:
  $
    \#P = {
      f: Sigma^* --> NN | &exists M "MdT non deterministica polinomiale t.c.", forall w in Sigma^*\
      &f(w) "è il numero di computazioni accettanti di M su" w
    }
  $
]

#proposition()[
  $cal(F)P subset.eq \#P$
]
// Diversa da quella del PDF, TOP
#proof()[
  $f in \#P$, sia M MdT deterministica polinomiale che calcola _f_.\
  Considero la seguente MdT non deterministica polinomiale:
  - Su input _w_, calcoloo $f(w) = k$;
  - Genero _k_ computazioni (ciascuna delle quali stampa un intero _i_, con $1 <= i <= k$), e le considero tutte accettanti
  $
    arrow.b.double\
    f in \#P
  $
]

#problem("aperto")[
  $
    cal(F)P limits(=)^? \#P
  $
]

#proposition()[
  Se $cal(F)P = \#P ==> "P" = "NP"$
]
#proof()[
  Sia $L in "NP" ==> exists M$ MdT non deterministica polinomiale che accetta _L_.

  Sia $f: Sigma^* --> NN$ la funzione che conta le computazioni accettanti di M $==> f in \#P$, ma per ipotesi $cal(F)P = \#P$, quindi vale anche $f in cal(F)P$. Dunque $exists N "MdT"$ polinomiale deterministica che calcola _f_.
  
  Algoritmo per decidere _L_, dato $w in Sigma^*$:
  - Calcolo $f(w)$;
  - Se $f(w) = 0$, rifiuta (poiché $f(w)$ è anche il numero di computazioni accettanti);
  - Se $f(w) > 0$, accetta (almeno una computazione accettante).

  Dato che questo è un algoritmo polinomiale per _L_: $L in "P"$
]
#problem("aperto")[
  $
    "P" = "NP" limits(=)^? cal(F)P = \#P
  $
]

#proposition()[
  Se fosse vero che PSpace $=$ P $==> cal(F)P = \#P$
]
#proof()[
  Rimane da dimostrare: $\#P subset.eq cal(F)P$
  
  #grid(
    columns: 2,
    column-gutter: 10pt,
    grid.cell([Sia $f in \#P$. Allora, $exists M$ MdT non deterministica polinomiale le cui computazioni accettanti sono contate da _f_.], inset: 5pt),
    [#rect([Il numero totale di computazioni di _M_ su una stringa di lunghezza _n_ è al più $2^q(n)$, con $q(n)$ polinomio.])]
  )

  Sia _N_ la MdT deterministica equivalente a _M_, a cui aggiungiamo un nastro per contare le computazioni accettanti.
  $
    L_k = {w | "ci sono almeno" k "computazioni di M che accettano" w}
  $
  MdT per calcolare _f_, su input _w_:
  - Determino se  $w in L_(1/2 2^(q(n)))$ usando N e confrontando il numero di computazioni accettanti _k_ con $1/2 2^q(n)$.
    - Se $k < 1/2 2^q(n)$, rifaccio con $L_(1/4 2^(q(n)))$;
    - Se $k >= 1/2 2^q(n)$, rifaccio con $L_(3/4 2^(q(n)))$.

  Complessità in tempo:
  - $forall k, L_k in "PSpace" ==> L_k in "P"$;
  - Il numero di linguaggi da controllare non è $2^q(n)$, ma $Omicron(log(2^(q(n)))) = Omicron(q(n))$ (ricerca binaria)
] // Dimostrazione? BOH

#example(multiple: true)[
  + \#SAT: Dato un polinomio booleano, determinare quanti sono gli assegnamenti che lo soddisfano. (\#SAT $in$ \#P)
  + \#CYCLE: Dato un grafo orientato, determinare il numero di cicli semplici
]

#problem("CYCLE")[
  Dato un grafo orientato (diretto), esiste un ciclo semplice?
]

#observation()[
  Se fosse vero che \#SAT $in cal(F)P, "allora" ==> "#SAT" in "P" ==> "P" = "NP"$
]

#proposition()[
  Se fosse vero che \#CYCLE $in cal(F)P$, allora $"P" = "NP"$ 
]
#proof()[
  Facciamo vedere che HAM $in$ P (dato che HAM è un problema NP, se dimostriamo che è $in$ P, allora vale che $"P" = "NP"$).
  Sia G un grafo orientato:
  - Costruiamo un nuovo grafo orientato G';
  - Facciamo vedere che:
    - G ha un circuito hamiltoniano $<==>$ G' ha almeno $n^n^2$ cicli.

  Costruzioni di G', supponiamo che $(u, v)$ sia un lato di G.
  #image("/assets/image-9.png")
  Ogni lato di $(u, v)$ di G corrisponde a $2^m$ cammini semplici da _u_ a _v_ in G'. Pertanto, ogni ciclo semplice di lunghezza _l_ di G corrisponde a $(2^m)^l$ cicli semplici in G'.

  Scegliamo $m = n log_2(n)$ (per semplicità, supponiamo che _n_ sia una potenza di 2).

  $==>)$ G ha un circuito hamiltoniano . Il numero dei cicli di G' è $>= (2^m)^n$ ($n = l$) = $(2^(n log_2(n)))^n = (n^n)^n = n^n^2$.\
  $<==)$ G non ha un circuito hamiltoniano $==>$ il più lungo ciclo di G ha lunghezza al più $n - 1$. Il numero totale di cicli di G è al massimo $n^(n-1)$.

  Il numero di cicli di G' è $<= (2^m)^(n-1)$
]