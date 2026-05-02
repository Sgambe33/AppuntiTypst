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
  Dato $G=(V, E)$ grafo non orientato, un *vertex cover* di G è un sottoinsieme $C subset.eq V$ t.c. $forall{x,y} in E, x in C "oppure" y in C$
]
#problem()[
  Dato G grafo non orientato e $k in NN$, esiste un VC $C "di" G$ con $abs(C) = k?$
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