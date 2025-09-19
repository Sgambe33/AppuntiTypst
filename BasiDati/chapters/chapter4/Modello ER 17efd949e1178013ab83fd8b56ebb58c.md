# Modello ER

=== Modelli di dati

- Modelli logici: sono usati dai DBMS esistenti per l'organizzazione dei dati (relazionali, reticolare, a oggetti etc)
- Modelli concettuali: permettono di rappresentare i dati in modo indipendente da ogni sistema descrivendo i concetti del mondo reale (Entity-Relationship).

I m. concettuali ci permettono di rappresentare le classi  di oggetti di interesse e loro correlazioni anche graficamente.

![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image.png)

=== Modello ER

I costrutti del modello ER sono i seguenti:

- Entità:
    
    Un'entità è una classe di oggetti (fatti persone cose) della realtà con proprietà. Un'istanza (o occorrenza) di entità è un elemento della classe (il fatto, la persona, la cosa). Ogni entità possiede un nome (***SINGOLARE***) che la identifica univocamente dello schema.
    
    ![Rappresentazione grafica delle entità.](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%201.png)
    
    Rappresentazione grafica delle entità.
    
- Relationship: 
E' un legame logico fra due o più entità, rilevante nell'applicazione di interesse. Si chiama anche relazione, correlazione o associazione. Ogni relationship ha un nome che la identifica univocamente (***SINGOLARE, SOSTANTIVI INVECE DI VERBI SE POSSIBILE***)
    
    ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%202.png)
    
    Una occorrenza di una relationship binaria è una coppia di occorrenze di entità, una per ciascuna entità coinvolta. Per una relationship n-aria è una n-upla di occorrenze di entità, una per ogni entità coinvolta. Non ci possono essere occorrenze ripetute (è sottoinsieme del prodotto cartesiano).
    
- Attributo:
Proprietà elementari di un'entità o di una relationship. Associa ad ogni occorrenza di ent. o rel. un valore appartenente a un insieme detto dominio dell'attributo.
    
    ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%203.png)
    
- Cardinalità
    - Di relationship: coppia di valori associati ad ogni entità in partecipazione alla relation. Specificano il numero min e max di occorrenze delle relationship cui ciascuna occorrenza di una entità può partecipare:
        - 0: partecipazione opzionale
        - 1: partecipazione obbligatoria
        - N: partecipazione massima/senza limite
        
        ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%204.png)
        
        In base alla cardinalità massima delle relation., esse si dividono in:
        
        - uno a uno
            
            ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%205.png)
            
        - uno a molti
            
            ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%206.png)
            
        - molti a molti
            
            ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%207.png)
            
    - Di attributo: è possibile associare delle cardinalità anche agli attributi con due scopi:
        - indicare opzionalità
        - indicare attributi multivalore
        
        ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%208.png)
        
- Identificatore
Strumento per identificare univocamente le occorrenze di un'entità. E' formato da
    - attributi dell'entità → **IDENTIFICATORE INTERNO**
        
        ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%209.png)
        
    - (attributi +) entità esterne attraverso relationship → **IDENTIFICATOR ESTERNO**
        
        ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%2010.png)
        
    
    <aside>
    💡
    
    Ogni entità deve possedere almeno un identificatore, ma anche più. Una identificazione esterna è possibile solo attraverso una relationship a cui l'entità da identificare partecipa con cardinalità (1,1).
    
    </aside>
    
- Generalizzazione
Mette in relazione una o più entità $E_1, E_2,...,E_n$ con una entità $E$ che cle comprende come casi particolari. $E$ si dice **GENERALIZZAZIONE** di $E_1,E_2,...,E_n$ mentre quest'ultime sono specializzazioni di $E$.
    
    ![image.png](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%2011.png)
    
    **EREDITARIETA'**: tutte le proprietà dell'entità genitore (attributi, relation., generalizzazioni) vengono ereditate dalle entità figlie e non rappresentate esplicitamente.
    
    Le generalizzazioni possono essere di due tipi:
    
    - **TOTALE:** se ogni occorrenza dell'entità genitore è occorrenza di almeno una delle entità figlie, altrimenti è **PARZIALE**
    - **ESCLUSIVA:** se ogni occorrenza dell'entità genitore è occorrenza al più di una delle entità figlie, altrimenti è **SOVRAPPOSTA**

![Parziale e sovrapposta](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%2012.png)

Parziale e sovrapposta

![Parziale ed esclusiva](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%2013.png)

Parziale ed esclusiva

![Totale ed esclusiva](Modello%20ER%2017efd949e1178013ab83fd8b56ebb58c/image%2014.png)

Totale ed esclusiva