# Algebra relazionale

E' un insieme di operatori logici su relazioni che producono a loro volta relazioni e che possono essere composti:

- Unione, intersezione, differenza
- Ridenominazione
- Selezione
- Proiezione
- Join (naturale, prodotto cartesiano, theta-join)

Ricordando che le relazioni sono insiemi, anche i risultati di queste operazioni devono sempre essere relazioni. Le op. di unione, intersezione e differenza possono essere applicate solo ad relazioni su gli stessi attributi.

![Esempio intersezione](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image.png)

Esempio intersezione

![Esempio differenza](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%201.png)

Esempio differenza

![Esempio unione](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%202.png)

Esempio unione

![Esempio di unione impossibile](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%203.png)

Esempio di unione impossibile

== Ridenominazione

E' un operatore monadico (un solo argomento). Modifica lo schema lasciando inalterata l'istanza dell'operando. (semplicemente modifico il nome degli attributi)

<aside>
💡

Data $r$ di schema  $R(A_1,…,A_k)$ e un insieme di attributi $B_1, …, B_k$ l'operatore di ridenominazione:

$$
\rho_{B_1 ... B_k \leftarrow A_1 ... A_k} (r) \space oppure \space REN_{B_1...B_k\leftarrow A_1...A_k(r)}
$$

Produce una relazione di schema $R(B_1,...,B_k)$ che contiene una tupla $t'$ per ogni tupla $t$ contenuta nella relazione originaria in modo tale  che $t'[B_i]=t[A_i] \space \forall i$

</aside>

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%204.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%205.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%206.png)

== Selezione

Ovvero una **decomposizione orizzontale**. Permette di effettuare un taglio sulla tabella in base ad una condizione specificata. Produce un risultato che ha lo stesso schema dell'operando. Contiene un sottoinsieme delle ennuple dell'operando, ovvero quelle che soddisfano una condizione.

<aside>
💡

Formula proposizionale per schema $R(A_1,...,A_k)$:

- $A_i \theta A_j$  con $\theta \in \{=,\not =, >, <, \geq, \leq\}$ è una formula
- $A_i \theta c$ con $c\in dom(A_i)$ è una formula
- Se $F_1$ e $F_2$ sono formule allora anche $F_1 and F_2$, $F_1orF_2$ e $notF_1$ sono formule
</aside>

<aside>
💡

Data $r$ di schema $R(A_1,...,A_k)$ e $F$ formula proposizionale, l'operatore di selezione

$$
\sigma_F(r) \space oppure \space SEL_F(r)
$$

produce una relazione sugli attributi di $R$ che contiene le tuple di $r$ su cui $F$ è vera.

</aside>

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%207.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%208.png)

== Proiezione

Ovvero una **decomposizione verticale**. E' un operatore monadico che produce un risultato che ha parte degli attributi dell'operando.  Praticamente mostra l'intera tabella ma senza le colonne che non vogliamo vedere. Contiene ennuple cui contribuiscono tutte le ennuple dell'operando.

<aside>
💡

Dato l'insieme di attributi $X = \{A_1, · · · ,A_k\}$, la relazione $r$ di schema $R(X)$  e un sottoinsieme $Y \subset X$  l'operatore di proiezione 

$$
\pi Y(r) \space oppure \space PROJ_Y(r)
$$

produce una relazione su $Y$ ottenuta dalla tuple di $r$ considerando solo i valori su $Y$.

</aside>

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%209.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2010.png)

Una proiezione contiene al più tante ennuple quante l'operando ma può contenerne di meno. Se $~~X~~$ è una superchiave (insieme di attributi che include una chiave) di $R$, allora $\pi_X (R)$ contiene esattamente tante ennuple quante $R$.

Selezione e proiezione possono essere combinati insieme per estrarre informazioni da una sola relazione.

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2011.png)

Osservazione: L'operazione di selezione nell'algebra relazionale corrisponde al WHERE in SQL mentre la proiezione all'istruzione SELECT “nome attributo”. Nell'esempio precedente sarebbe:

```sql
SELECT Matricola, Cognome FROM impiegati WHERE Stipendio>50;
```

== Join

Permette di congiungere dati in relazioni/tabelle diverse. E' un operatore binario generalizzabile ovvero che normalmente lavora su due argomenti ma volendo può lavorare su di più.

Produce un risultato sull'unione degli attributi degli operandi, con ennuple costruite ciascuna a partire da una ennupla di ognuno degli operandi.

<aside>
💡

Dati $R_1(X_1)$ e $R_2(X_2)$ il join naturale $R_1 \Join R_2$ oppure $R_1$JOIN $R_2$ è una relazione sull'unione $X_1 \cup X_2$:

$$
R_1 \Join R_2 = \{t \in X_1 \cup X_2 | \exist t_1 \in R_1 \space e \space t_2 \in R_2 \space t.c. \space
t[X_1] = t_1 \space e \space t[X_2] = t_2\}
$$

</aside>

Le tuple del risultato di un join naturale sono ottenute combinando tuple degli operandi con valori uguali sugli attributi.

- Se X1 e X2 hanno attributi in comune si ha la definizione tradizionale di join naturale.
- Se X1 e X2 sono disgiunti si ha la definizione di prodotto cartesiano.
- Se X1 e X2 coincidono si ha la definizione dell'intersezione.

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2012.png)

Date $r, s$ definite su insiemi di attributi non disgiunti: $R(A_1,...,A_k,...,A_n)$ e $S(A_1,...,A_k,B_1,...,B_m)$  il risultato di
$r \Join s$ è una relazione definita su $A_1,...,A_n,B_1,...,B_m$:

$$
Z(A_1,...,A_n,B_1,...,B_m)
$$

che contiene il seguente insieme di tuple $\{t | t[A_1,...,A_n] \in r \land t[A_1,...,A_k ,B_1,_,B_m] \in s\}$

![Join completo](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2013.png)

Join completo

![Join non completo](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2014.png)

Join non completo

![Join vuoto](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2015.png)

Join vuoto

=== Cardinalità del join

Il join di R1 e R2 contiene un numero di ennuple compreso fra zero e il prodotto di $|R_1|$ e $|R_2|$:

- Se il join coinvolge una chiave di $R_2$, allora il numero di ennuple è compreso fra zero e $|R_1|$;
- Se il join coinvolge una chiave di R2 e un vincolo di integrità referenziale, allora il numero di ennuple `e pari a |R1|.

Date $R_1(A,B)$,  $R_2(B,C)$  in generale si ha:

- $0 \leq |R_1 \Join R_2| \leq |R_1| \times |R_2|$

Se $B$  è chiave in $R_2$ 

- $0 \leq |R_1 \Join R_2| \leq |R_1|$

Se $B$ è chiave in $R_2$ ed esiste vincolo di integrità referenziale fra $B$ (in $R_1$) e $R_2$: 

- $|R_1 \Join R_2| = |R_1|$

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2016.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2017.png)

=== Join esterno

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2018.png)

Il join esterno estende, con valori nulli, le ennuple che verrebbero tagliate fuori da un join (interno). Esiste in tre versioni:

- sinistro: mantiene tutte le ennuple del primo operando, estendendole con valori nulli, se necessario;
    
    ![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2019.png)
    
- destro: . . . del secondo operando . . .
    
    ![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2020.png)
    
- completo: . . . di entrambi gli operandi . . .
    
    ![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2021.png)
    

<aside>
💡

Date $r$, $s$ deﬁnite su insiemi di attributi non disgiunti $R(A1, · · · , Ak , · · · , An)$ e $S(A1, · · · , Ak , B1, · · · , Bm)$ il risultato di
$r \Join_{FULL} s$ è una relazione deﬁnita su $A1, · · · , An, B1, · · · , Bm$:

$$
Z (A1, · · · , An, B1, · · · , Bm)

$$

deﬁnita come segue:

$$
r \Join_{FULL} s = r \Join s \space ∪
$$

$$
(r − π_{A1,··· ,An} (r \Join s)) \times \{B1 = null, · · · , Bm = null\} ∪
\{Ak+1 = null, · · · , An = null\} \times (s − πA1,··· ,Ak ,B1,··· ,Bm (r \Join s))
$$

Le tuple che non contribuiscono al join naturale vengono unite con tuple nulle.

</aside>

=== Prodotto cartesiano

<aside>
💡

Date $r$, $s$ con schemi di relazione $R(A_1,...,A_n)$ e $S(B_1,...,B_m)$ il risultato di $r \times s$ è una relazione definita su $A_1,...,A_n,B_1,...,B_m$:

$$
Z(A_1,...,A_n,B_1,...,B_m)
$$

le cui tuple sono ottenute concatenando ogni tupla di $r$ con tutte le tuple di $s$ ottenendo l'insieme:

$$
\{t | t = uv \space \text{con} \space u ∈ r e v ∈ s\}
$$

</aside>

 NOTA: il prodotto è un operatore primitivo, insieme a ridenominazione, unione, differenza, selezione e proiezione. Invece, per l'intersezione si ha $r ∩ s = r − (r − s)$. Inoltre un join naturale su relazioni senza attributi in comune, coincide con il loro prodotto.

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2022.png)

=== $\theta$ -join

Il prodotto cartesiano in pratica ha senso solo se eseguita da selezione:

$$
\sigma_{Condizione}(R_1 \times R_2)
$$

L'operazione viene chiamata theta-join e indicata con:

$$
R_1 \Join_{Condizione} R_2
$$

La condizione è spesso una congiunzione (AND) di atomi di confronto $A_1 \theta A_2$ dove $\theta$ è uno degli operatori di confronto($=, >, <, \ge, \le$). Se l'operatore di confronto nel theta join è sempre l'uguaglianza (=) si parla di equi-join

<aside>
💡

Date $r$, $s$ con schemi $R(A_1, \dots,A_n)$ e $S(B_1,\dots,B_m)$, $A_i \neq B_j$ il risultato di $r \Join_{A_i \theta B_j}$ $s$ è una relazione definita su $A_1, \dots ,A_n,B_1, \dots ,B_m$:

$$
Z(A_1, \dots, A_n, B_1, \dots, B_m)
$$

che contiene il seguente insieme di tuple 

$$
\{t | t = uv \space con \space  u \in r, v \in s, u[A_i
] \space \theta \space v[B_j]\}
$$

Si ha $r\Join_{A_i \theta B_j} s = \sigma A_i \theta B_j (r × s)$

</aside>

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2023.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2024.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2025.png)

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2026.png)

== Equivalenze

Due espressioni sono equivalenti se producono lo stesso risultato qualunque sia l'istanza attuale della base di dati. L'equivalenza è importante in pratica perché i DBMS cercano di eseguire espressioni equivalenti a quelle date, ma meno costose.

![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2027.png)

== Viste - relazioni derivate

- Relazioni di base: contenuto autonomo.
- Relazioni derivate: relazioni il cui contenuto è funzione del contenuto di altre relazioni (definito per mezzo di interrogazioni). Le relazioni derivate possono essere definite su altre derivate.
    - viste materializzate: relazioni derivate memorizzate nella base di dati. Immediatamente disponibili per le interrogazioni ma ridondanti, appesantiscono gli aggiornamenti, sono raramente supportate dai DBMS.
    - relazioni virtuali (o viste): sono supportate dai DBMS (tutti) e una interrogazione su una vista viene eseguita ricalcolando la vista.

== Limiti dell'algebra

Ci sono interrogazioni interessanti non esprimibili con l'algebra:

- Calcolo di valori derivati: possiamo solo estrarre valori, non calcolarne di nuovi.
- Calcoli di interesse: a livello di ennupla o di singolo valore (conversioni, somme, differenze, etc.)
su insiemi di ennuple (somme, medie, etc.)
- Interrogazioni inerentemente ricorsive, come la chiusura transitiva.

<aside>
💡

Data $r$ di schema $R(X,Y )$, la chiusura transitiva $r^*$ di $r$  è la relazione che si ottiene aggiungendo, fino a quando è possibile, alle tuple in $r$  la coppia $(a, b)$  se esiste un valore $c$  tale che le coppie $(a, c)$  e $(c, b)$  sono in $r$  o sono state aggiunte precedentemente.

</aside>

- Esempio chiusura transitiva
    
    Per ogni impiegato, trovare tutti i superiori (cioè il capo, il capo del capo e così via).
    
    ![In questo esempio, basta il join della relazione con se stessa, previa opportuna ridenominazione](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2028.png)
    
    In questo esempio, basta il join della relazione con se stessa, previa opportuna ridenominazione
    
    ![image.png](Algebra%20relazionale%2017efd949e11780898da5d8b6f4ef101f/image%2029.png)
    
    Non esiste in algebra la possibilità di esprimere l'interrogazione che, per ogni relazione binaria, ne calcoli la chiusura transitiva. Per ciascuna relazione, è possibile calcolare la chiusura transitiva, ma con un'espressione ogni volta diversa. Quanti join servono? Non c'`e limite!
    

== Esercizi

Nome degli autori di nazionalità “nazione1”

$$
\pi_{nome}(\sigma_{nazionalita='nazione1'}(Autore))
$$

Partita iva dei negozi

Nome, indirizzo e città de negozi che del disco di codice 3 hanno venduto più di 2 copie

$$
\pi_{nome, indirizzo, citta}(Negozio \Join \pi_{p_iva}(\sigma_{disco_id=3 and copie>2}(Vendita)))
$$

Nome indirizzo e città dei negozi che hanno venduto più di 2 copie di un disco di titolo Titolo3

$$
\pi_{nome, indirizzo,citta}(Negozio \Join \pi_{p\_iva}(\sigma_{titolo='titolo3'\space and \space copie>2}(Disco \Join Vendita)))
$$

Cinema(Nome,indirizzo, Telefono)

Regista(Codice, Nome, Cognome, AnnoNascita)

Genere(Codice, Nome)

Sala(Cinema, Numero, Posti)

Proiezione(Sala, Orario, Film)

Film(Titolo, Nazionalità, *Regista*, *Genere*) 

Istituzione(Codice, Nome, Indirizzo, Nazione)

Volume(Anno, Titolo)

Autore(Codice, Cognome, Nome, E-mail, *ISTITUZIONE*)

AutoreArticolo(CodiceArt, CodiceAut)

Articolo(Codice, Titolo, Sottotitolo, Testo,  PagIniz, PagFin, *CODICE, NUMERO, ANNO*)

Pubblicazione(Numero, Anno, Data)

Musicista(Codice, Nome)