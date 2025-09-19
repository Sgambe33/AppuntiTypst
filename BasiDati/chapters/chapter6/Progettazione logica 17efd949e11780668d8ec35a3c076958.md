# Progettazione logica

Lo scopo della progettazione logica è quello di tradurre lo schema concettuale in uno schema logico che rappresenti gli stessi dati in maniera corretta ed efficiente.

![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image.png)

La ristrutturazione dello schema ER è necessaria per semplificare la traduzione e ottimizzare le prestazioni. Gli **INDICATORI** delle prestazioni sono:

- **SPAZIO:** numero di occorrenze previste per le entità e le relazioni
- **TEMPO:** numero di occorrenze visitate durante un'operazione

=== Fasi della ristrutturazione

1. **Analisi ridondanze**
Sono informazioni significative ma ricavabili da altre già presenti:
    1. Attributi derivabili
        
        ![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%201.png)
        
        ![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%202.png)
        
    2. Relationship derivabili
        
        ![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%203.png)
        
2. **Eliminazione generalizzazioni**
Il modello relazionale non può rappresentare direttamente le generalizzazioni che quindi devono essere trasformate in entità e relations.
    
    ![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%204.png)
    
    ![Accorpamento figlie → genitore. L'attributo tipo serve a distinguere il tipo di occorrenza di E0.](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%205.png)
    
    Accorpamento figlie → genitore. L'attributo tipo serve a distinguere il tipo di occorrenza di E0.
    
    ![Accorpamento genitore → figlie. Conviene se gli accessi alle figlie sono distinti e la generalizzazione è totale.](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%206.png)
    
    Accorpamento genitore → figlie. Conviene se gli accessi alle figlie sono distinti e la generalizzazione è totale.
    
    ![Generalizzazione con associazioni. Devono essere aggiunti vincoli: ogni occorrenza di E0 o appartiene ad un'occorrenza di RG1 o di RG2. Conviene quando gli accessi alle figlie sono separati dagli accessi al padre.](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%207.png)
    
    Generalizzazione con associazioni. Devono essere aggiunti vincoli: ogni occorrenza di E0 o appartiene ad un'occorrenza di RG1 o di RG2. Conviene quando gli accessi alle figlie sono separati dagli accessi al padre.
    
    Esistono anche soluzioni ibride.
    
3. **Partizionamento/accorpamento di entità e relationship**
Sono effettuate per rendere più efficienti le operazioni. Si possono ridurre gli accessi:
    1. Separando gli attributi di un concetto che vengono acceduti separatamente.
    2. Raggruppando attributi di concetti diversi acceduti insieme.
    
    Ecco alcuni esempi:
    
    ![Partizionamento verticale di entità](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%208.png)
    
    Partizionamento verticale di entità
    
    ![Eliminazione attributi multivalore](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%209.png)
    
    Eliminazione attributi multivalore
    
    ![Accorpamento entità](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2010.png)
    
    Accorpamento entità
    
    ![Partizionamento associazione](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2011.png)
    
    Partizionamento associazione
    
    ![Partizionamento verticale di entità](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2012.png)
    
    Partizionamento verticale di entità
    
    ![Eliminazione attributi multivalore](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2013.png)
    
    Eliminazione attributi multivalore
    
    ![Accorpamento entità](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2014.png)
    
    Accorpamento entità
    
    ![Partizionamento associazione](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2015.png)
    
    Partizionamento associazione
    
4. **Scelta identificatori primari**

Operazione indispensabile per la traduzione nel modello relazionale.

- assenza di opzionalità (vanno esclusi attributi con valori nulli);
- semplicità (questo garantisce che gli indici siano di dimensioni ridotte);
- utilizzo nelle operazioni pi`u frequenti o importanti.

Se nessuno degli identiﬁcatori soddisfa questi requisiti, si introducono nuovi attributi (codici) contenenti valori speciali generati appositamente per questo scopo. (I famosi autoincrement)

![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2016.png)

![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2017.png)

![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2018.png)

=== Esempio

![image.png](Progettazione%20logica%2017efd949e11780668d8ec35a3c076958/image%2019.png)