#import "../../../../dvd.typ": *
#import "@preview/in-dexter:0.7.2": *

= Shell

== Concetti fondamentali di un Sistema Operativo

Un computer è composto da *hardware*, che è l'equipaggiamento fisico, e *software*, che rappresenta l'equipaggiamento logico. Il software si divide in:
- *Software applicativo* ovvero programmi per gli utilizzatori finali.
- *Software di base o di sistema* che include programmi essenziali per il funzionamento del computer, come il *Sistema Operativo* e i *Driver delle periferiche*.

Alla base dell'esecuzione del software ci sono gli *algoritmi*.
#definition("Algoritmo")[
  Un *algoritmo* è definito come un procedimento finito di passi elementari per risolvere un problema, caratterizzato da finitezza, generalità, non ambiguità, correttezza ed efficienza.
]
Un *programma* è la descrizione di un algoritmo in un linguaggio eseguibile da un computer ed è un'entità statica. Quando un programma è in esecuzione, diventa un *processo*, che è un'entità dinamica. In particolare, un programma viene caricato sulla RAM quando è inizializzato per l'esecuzione, trasformandosi in un processo.

Il *Sistema Operativo (SO)* è un software di base, anche detto piattaforma operativa, indispensabile per il funzionamento del computer. Le sue funzioni principali includono la *gestione delle risorse*, come le periferiche, l'esecuzione simultanea di programmi sul processore, la memorizzazione e sicurezza dei dati tramite il file system, e la funzione multi-utente (gestione dei login).

Un SO può essere visto come un *framework* per l'esecuzione dei programmi e la gestione/archiviazione dei file. È composto da sottosistemi o componenti software quali:
- *Kernel*
- *Scheduler*
- *File System*
- *Gestore della Memoria*
- *Gestore delle Periferiche*
- *Interfaccia Utente*
Le funzionalità dei SO riguardano principalmente la condivisione delle risorse e la cooperazione/comunicazione tra processi. Un *file* è una collezione di dati salvati su disco, mentre un *program* è una collezione di byte che rappresentano codice o dati inclusi in un file.

#align(center, image("images/2025-09-10-23-24-49.png", width: 60%))

== UNIX

Il sistema *UNIX* è un sistema operativo proprietario, sviluppato dai ricercatori dei laboratori AT&T e Bell Labs negli anni '60. Le sue caratteristiche principali sono essere un sistema:
- Multi-utente
- Multi-tasking
- Portabile su varie architetture hardware
- Orientato alla programmazione
UNIX è la base di molti sistemi operativi moderni, inclusi Mac OS X e GNU/Linux.

#align(center, image("images/2025-09-10-23-25-48.png", width: 50%))

L'architettura UNIX è composta da:
- *Kernel*: il nucleo del sistema operativo che fornisce accesso controllato all'hardware.
- *Shell*: un programma applicativo che realizza l'interfaccia utente.
- *Tools*: un insieme di programmi applicativi che utilizzano le primitive del Kernel.
Lo standard UNIX include diverse *utilities* come editor, compilatori, utility di sorting, interfacce grafiche e shell. Due standard importanti sono:
- Il linguaggio *C* (ANSI dal 1989, poi ISO, con la C Standard Library)
- *POSIX* (IEEE dal 1988, poi ISO), che definisce un'interfaccia portabile per sistemi operativi di tipo Unix.
Le funzioni di UNIX, come il parallel processing, la comunicazione tra processi e la gestione dei file, sono accessibili tramite programmazione in C attraverso routine chiamate *System Call*. La filosofia di UNIX si basa sul concetto di *Pipe*, dove l'output di un processo diventa l'input di un altro.

=== Avvio di un sistema Linux

Quando si accende un computer Linux, si verifica una sequenza di eventi:
- L'hardware esegue test di diagnostica (interrupt, RAM, tastiera, dischi, porte).
- Il kernel di Linux viene caricato dal device di root.
- Il *BIOS* (Basic Input/Output System), un insieme di routine software, dà i primi comandi al sistema durante il processo di BOOT.
- Il BIOS cerca il *Master Boot Record (MBR)* sull'hard disk.
- Il primo settore di dati fisico da 512 byte del disco rigido viene caricato in memoria, e il controllo passa al *boot loader* (es. GRUB, LILO), che risiede all'inizio di questo settore.
- Il boot loader cede il controllo al kernel Linux.
- Il kernel si avvia e inizializza le risorse.
- Il kernel lancia `init`, il processo padre di tutti i processi utente, che stabilisce una gerarchia.

#align(center, image("images/2025-09-10-23-38-38.png", width: 50%))

Il processo `init` esegue diverse azioni:
- Controlla il file system, esegue programmi di routing per la rete, rimuove file temporanei.
- Successivamente, `init` genera il processo `getty`, che gestisce i login degli utenti. `getty` visualizza "login: " e si sostituisce con il processo `login`, che accetta user ID e password, li verifica con `/etc/passwd` (e `/etc/shadow`), e in caso di successo, si sostituisce con il programma di avvio dell'utente, di solito una shell (come bash). Può comparire anche il messaggio del giorno da `/etc/motd`. Un esempio di login è:
  ```sh
  Login: stefano
  Password:
  Last login: Fri Feb 16 16:21:49 from …
  stefano@ubuntu:~$
  ```

=== Spegnimento di un sistema Linux

Lo spegnimento di un sistema Linux richiede una procedura specifica. La RAM non utilizzata dal kernel o dalle applicazioni viene usata come cache di disco, sincronizzata con il disco ogni 30 secondi circa. È fondamentale terminare correttamente il processo della cache di disco prima di spegnere il PC, altrimenti si rischia di danneggiare seriamente il file system. Non si deve spegnere il PC premendo direttamente il pulsante POWER. Si devono usare i comandi `halt` o `shutdown`, ad esempio:
- `shutdown -h 20:00` (spegne alle 20:00)
- `shutdown -r now` (riavvia immediatamente)
Per eseguire questi comandi è necessario accedere con l'account speciale *root*, che è l'amministratore di sistema e può accedere a ogni file. Si può effettuare il login come root o usare il comando `su` per passare a root da un altro utente, fornendo la password di root. Ad esempio:
#figure([
  ```sh
  login: root
  Password:
  root@ubuntu:/home/paolo= shutdown -h now
  ```
  oppure
])


#figure([
  ```sh
  stefano@ubuntu:~$ su
  Password:
  root@ubuntu:/home/paolo= shutdown -h now
  ```
])


=== Shell

In un sistema operativo con interfaccia testuale, il *PROMPT* è il simbolo a video che indica che il computer è pronto a ricevere comandi. Dopo il login in sistemi UNIX/Linux, simboli come `$` o `%` sono prompt visualizzati in un programma speciale chiamato *SHELL*, che è l'interprete dei comandi e media tra l'utente e il sistema. Ad esempio, `stefano@ubuntu:~$` indica l'utente `stefano`, l'host `ubuntu` e la directory corrente `~` (home directory). La shell legge i comandi digitati dall'utente e li traduce per il sistema operativo.
Storicamente, le shell più popolari includono:
- BOURNE SHELL
- KORN SHELL
- C SHELL
- BASH (BOURNE AGAIN SHELL)
- Dash (Debian Almquist Shell), che è la shell di sistema predefinita in Ubuntu (`/bin/sh`)

Il formato generale della sintassi dei comandi è `$ command -options arguments`. Alcuni esempi di comandi sono:
- `ls -al`
- `clear`
- `cd /etc/network`
- `cd ..`
- `wc -w passwd` (conta le parole in `/etc/passwd`)
- `wc -c passwd` (conta i caratteri in `/etc/passwd`)
- `wc -l passwd` (conta le linee in `/etc/passwd`)
- `cat file1 file2 file3`
Se un comando restituisce un errore come `<command>: command not found`, è necessario verificare due cose:
1. La corretta digitazione del comando (Linux è *case sensitive*, quindi `cat` è diverso da `Cat`)
2. Se il file eseguibile del comando è installato usando `whereis`. Ad esempio, `whereis cat` potrebbe mostrare `cat: /bin/cat /usr/share/man/man1/cat.1.gz`.

==== Caratteri di controllo
Esistono caratteri di controllo (che usano `CTRL`):
- `^C` (Interrupt): interrompe il programma e fa tornare al prompt.
- `^Z` (Sospende): ferma il programma mettendolo in pausa. Per riprendere l'esecuzione si digita `fg`.
- `^D` (Fine del file): se digitato al prompt, fa uscire dalla shell. Ad esempio, dopo aver digitato del testo con `cat`, `^D` chiude l'input.
Per controllare lo scorrimento del testo a schermo:
- `^S`: ferma lo scorrimento.
- `^Q`: riprende lo scorrimento.

==== Manuale di aiuto on-line di Linux

Il comando `man` visualizza il manuale di aiuto per un comando selezionato: `man command_name`. Ad esempio, `man man` o `man -help` forniscono aiuto per il comando `man` stesso.
Si può specificare la sezione, ad esempio `man 2 kill`. Ogni capitolo ha pagine introduttive come `man 1 intro`. Le opzioni di `man` includono `-f command-name` (breve descrizione, analogo a `whatis`) e `-k keyword` (mostra comandi la cui descrizione contiene la parola chiave).
Il comando `info` è un altro programma per leggere la documentazione sulle utilities. Esempi: `info info`, `info emacs`, `info bash`, `info uname`. Il comando `uname -a` stampa informazioni sulla macchina e sul sistema operativo.

== File System

I file di Linux sono organizzati gerarchicamente in una struttura a directory, che appare agli utenti come un albero gerarchico che segue la semantica UNIX. I file possono essere di tre tipi:
- *Files ordinari*: contengono sequenze di byte (codice o dati).
- *Files directory*: memorizzati su disco in formato speciale, formano l'ossatura del file system.
- *Files speciali*: corrispondono a periferiche come stampanti o dischi.
La struttura gerarchica parte da una *radice* (o root), che è il nodo principale. I rami collegano i nodi successivi (directory, file di dati o altri tipi di file) al loro genitore. Per identificare un nodo, si usa un *percorso (path)*, una sequenza di nomi di nodi separati da `/`. La `/` è la directory root, punto di riferimento per tutte le directory, e ogni file ha un pathname non ambiguo, come `/home/user1/papers`.

#align(center, image("images/2025-09-10-23-45-55.png", width: 60%))

=== Directory standard nei sistemi UNIX
Alcune directory standard includono:
- `/bin`: programmi di sistema essenziali.
- `/boot`: file richiesti per avviare Linux.
- `/dev`: file corrispondenti ai device.
- `/etc`: file di configurazione.
- `/home`: directory personali degli utenti (es. `/home/rossi`).
- `/lib`: librerie per le applicazioni di sistema.
- `/lost+found`: file ripristinati da danni al file system, spesso dovuti a shutdown errati.
- `/mnt`: per il "mount" di periferiche e altri file system.
- `/opt`: software aggiuntivo.
- `/proc`: pseudo-file system il cui contenuto è disponibile solo quando vi si accede (es. `/proc/interrupts`).
- `/root`: home directory dell'amministratore (root).
- `/sbin`: programmi dell'amministratore di sistema.
- `/tmp`: file temporanei, accessibile a tutti gli utenti.
- `/usr`: elementi collegati agli utenti, eseguibili e librerie non essenziali per l'avvio.
- `/var`: file di log del sistema, programmi, ecc..

=== Working Directory e Pathname
Ogni processo è associato a una *working directory*. Quando si accede a Linux, la shell si avvia nella *home directory* (es. `/home/stefano`).
- `pwd`: visualizza la working directory.
- `cd`: torna alla home directory.
Un pathname relativo alla root è un *pathname assoluto* (es. `/usr/src`), mentre un file può essere specificato con un *pathname relativo* alla working directory (es. se `/usr/include/` è la working directory, `/linux/time.h` è il pathname relativo di `time.h`).
Il file system fornisce campi speciali per i path relativi:
- `.` : current directory.
- `..`: parent directory (directory genitore).
- `~`: home directory.

=== Collegamenti (Link)
Nei file system UNIX, non è sempre un vero albero perché è possibile inserire *collegamenti (link)* aggiuntivi che creano percorsi alternativi. Esistono due tipi:
- *Collegamenti fisici (hard link)*: una volta creati, hanno lo stesso livello di importanza dei dati a cui si riferiscono e sono indistinguibili da essi.
- *Collegamenti simbolici (symlink)*: sono file speciali che contengono un riferimento a un altro percorso e quindi a un altro nodo (inode) del grafo di directory e file.

=== Contenuti di una directory
Il comando `ls` elenca i contenuti della working directory. Con `ls dir_name` si elencano i contenuti di una directory specifica.
Opzioni di `ls`:
- `-a`: mostra tutti i file, inclusi quelli nascosti.
- `-F`: aggiunge `/` per le directory, `*` per gli eseguibili, `@` per i link simbolici.
- `-l`: formato completo, mostra dettagli per i file.
- `-h`: formato leggibile dall'uomo ("human-readable").
- `-R`: ricorsivo, include le sottodirectory.
- `-t`: elenca secondo la data dell'ultima modifica.
- `-u`: elenca secondo la data dell'ultimo accesso.
- `-i`: mostra l'inode di ciascun file.

=== Wild-cards
I caratteri jolly ("wild-cards") sono usati per la ricerca di stringhe:
- `*`: significa "zero o più caratteri". Es. `chap*` trova `chap01`, `chapa`, `chap_end`, e `chap`. Se usato da solo (`*`), trova tutti i file.
- `?`: significa "un solo carattere arbitrario". Es. `chap?` trova `chapa` e `chap1`, ma non `chap01` o `chap`.

=== Attributi di un file
A ogni file sono associati diversi attributi:
- *Timestamp*: tre date (creazione, ultima modifica, ultimo accesso).
- *Proprietario*: l'utente che possiede il file.
- *Gruppo*: un gruppo di utenti associato al file (spesso "users").
- *Permessi*: stabiliscono chi può accedere, modificare o eseguire il file, assegnati separatamente a proprietario, gruppo e altri utenti.
Il comando `ls -l` mostra queste informazioni, inclusi tipo di file, permessi, numero di hard link, proprietario, gruppo, dimensione in byte e timestamp.
#figure([```sh
$ ls -l
totale 28
drwxrwxr-x 4 paolo paolo  4096 mar 27 16:52 Desktop/
drwxrwxr-x 2 paolo paolo  4096 mar 21 17:35 didattica/
drwxr-xr-x 2 paolo paolo  4096 mar 14 19:21 Documents/
-rwx------ 1 paolo paolo  1999 mar 31 13:25 file*
-rw-r--r-- 1 paolo paolo  123 mar 31 12:58 file1
drwxrwxr-x 2 paolo paolo  4096 mar 21 17:35 ricerca/
drwx------ 2 paolo paolo  4096 mar 14 18:50 tmp/
```])

Nei sistemi UNIX/GNU Linux, anche l'accesso alle periferiche avviene tramite file in `/dev`, e senza i permessi adeguati non è possibile utilizzarle. Il proprietario di un file è di default colui che lo ha creato. I permessi sono forniti non solo per singoli account ma anche per gruppi, per facilitare l'accesso condiviso. Il comando `groups` mostra i gruppi di cui un utente è membro.
I permessi sui file si dividono in tre categorie:
- Permessi del proprietario.
- Permessi di gruppo.
- Permessi per tutti gli altri.

=== Permessi (directory)
Per le directory, i simboli dei permessi hanno significati specifici:
- `r` (lettura): indica che il contenuto della directory può essere elencato.
- `w` (scrittura): indica che il contenuto della directory può essere cambiato (copiare, spostare, cancellare, creare nuovi file). I permessi sulla directory, non sul file, determinano se un file può essere cancellato.
- `x` (esecuzione): indica che gli utenti possono eseguire il comando `cd` in quella directory, permettendo di attraversarla per accedere a file e sottodirectory (ma non di elencarne il contenuto, per cui serve anche il permesso di lettura).

==== Modifica dei permessi
Il comando `chmod` modifica i permessi di un file/directory. Si specificano tre cifre (ottali) o simboli per proprietario (`u`), gruppo (`g`), altri (`o`) o tutti (`a`), e l'azione (`+` aggiungi, `-` cancella, `=` assegna) e il permesso (`r` lettura, `w` scrittura, `x` esecuzione).
Esempi:
- `chmod a+rw hello.c`
- `chmod o-w hello.c`
- `chmod og+rx prog*`
- `chmod g=rw rep*`
- `chmod +w *`
L'opzione `-R` cambia ricorsivamente i permessi di una directory e dei suoi contenuti.

=== Creazione/Cancellazione Directory e File
- `mkdir dir_name`: crea una directory. Es. `mkdir appunti`, `mkdir {appunti,lucidi}`.
- `rmdir dir_name`: cancella directory vuote, senza avvisi. Es. `rmdir appunti`.
- `rm -r dir_name`: cancella directory non vuote ricorsivamente. Es. `rm -r appunti`.
- `cat > file_name`: scrive l'input dalla tastiera nel file `file_name`. Es. `cat > prova` (terminato con `^D`).
- `rm file_name`: cancella il file, senza avvisi. Es. `rm pippo`.
Opzioni di `rm`:
- `-r` (recursive): rimuove contenuti di directory ricorsivamente.
- `-i` (interactive): avvisa prima di cancellare.
- `-f` (force): forza la cancellazione ignorando errori o avvertimenti.


=== Comandi per la gestione dei file
==== Copiare (cp)
Il comando `cp options x1 x2` copia `x1` in `x2`. Se `x2` non esiste, `cp` lo crea; altrimenti lo sovrascrive. Se `x2` è una directory, `cp` copia `x1` al suo interno.
Esempi:
- `cp /etc/passwd pass`
- `cp problemi/* ~/backup`
- `cp pippo /articoli`
- `cp /etc/passwd .`
Opzioni di `cp`:
- `-i`: avvisa prima di sovrascrivere.
- `-p`: conserva i permessi.
- `-r`: copia file e sottodirectory ricorsivamente.

==== Spostare (mv)
Il comando `mv olddirectory newdirectory` rinomina una directory. Se `newdirectory` esiste, `mv` sposta `olddirectory` al suo interno.
`mv oldname newname` rinomina un file. Se `newname` esiste, `mv` sovrascrive `newname` con `oldname`.
Opzioni di `mv`:
- `-i`: avvisa prima di sovrascrivere.
- `-f`: forza l'azione senza avvisi.
`mv file path` sposta un file dalla directory corrente a una nuova directory specificata.
Esempi:
- `mv chap book` (sposta file specifici)
- `mv chap book` (sposta un range di file)

==== Mostrare contenuti dei file
- `cat filename`: mostra l'intero contenuto del file.
- `more filename`: mostra la prima schermata, si avanza con la barra spaziatrice, si chiude automaticamente.
- `less filename`: mostra la prima schermata, si avanza con la barra spaziatrice, si scorre con le frecce, si esce con `q` o `Q`.
- `head -n filename`: mostra le prime `n` linee (default 10).
- `tail -n filename`: mostra le ultime `n` linee (default 10).


=== Descrittori di file

Nei sistemi operativi Unix e Unix-like, un *descrittore di file (file descriptor)* è un numero intero non negativo che rappresenta un file, una pipe o un socket aperto da un processo per operazioni di input/output. Convenzionalmente, i descrittori 0, 1 e 2 rappresentano rispettivamente lo *standard input*, lo *standard output* e lo *standard error* di un processo. I file sono i principali mezzi di comunicazione tra programmi e permangono per tutta la durata del processo.
- Lo standard input (0) fornisce un modo per inviare dati a un processo, letto di default dalla tastiera.
- Lo standard output (1) permette al programma di rendere disponibili i dati, visualizzato di default sullo schermo.
- Lo standard error (2) è dove il programma registra gli errori, anch'esso indirizzato di default allo schermo.

== Reindirizzare Input e Output

UNIX usa i caratteri speciali `<` e `>` per il reindirizzamento di input e output.
- `command < file1`: reindirizza l'input da `file1` invece che dalla tastiera. Es. `more < /etc/passwd`.
- `command > file2`: reindirizza l'output a `file2` invece che allo schermo. Se `file2` esiste, viene sovrascritto. Es. `sort pippo > pippo_ordinato`.
- `command >> file2`: accoda l'output di `command` alla fine di `file2`. Se `file2` non esiste, viene creato. Es. `ls /bin > ~/bin; ls /usr/sbin >> ~/bin; wc -l ~/bin`.
- `command 1> pippo`: invia lo standard output al file `pippo` (equivalente a `command > pippo`).
- `command 2> pippo`: invia lo standard error al file `pippo`. Es. `list 2> pippo`.
- `command >& file1`: inserisce sia lo standard error che lo standard output in `file1`. Se `file1` esiste, viene sovrascritto. Es. `ls abcdef >& lserror`.

== Pipes (tubi)

UNIX consente di connettere processi tramite *pipe*, usando il simbolo `|`, in modo che lo standard output di un processo diventi lo standard input di un altro. Una sequenza di comandi concatenati in questo modo è chiamata *pipeline*. Questo permette di eseguire compiti complessi combinando processi semplici.
Esempi:
- `cat /etc/passwd | sort > ~/pass_ord`
- `ls | sort`

=== Sequenze e Valori di uscita

Comandi semplici o pipeline separati da punto e virgola (`;`) vengono eseguiti in sequenza da sinistra a destra. Es. `pwd ; echo = ; echo $HOME`.
Ogni processo Linux termina con un *valore di uscita*: `0` indica successo, mentre un valore diverso da zero indica fallimento. La variabile di shell `$?` contiene il valore del codice di uscita del comando precedente.
#example()[
  ```sh
  $ date
     Thu Nov 30 16:34:25 CET 2023
  $ echo $?
     0
  ```
]

=== Sequenze condizionali

- `command1 && command2`: `command2` viene eseguito solo se `command1` ha codice di uscita `0` (successo). Es. `date && ls`.
- `command1 || command2`: `command2` viene eseguito solo se `command1` ha codice di uscita diverso da `0` (fallimento). Es. `abcdef || date`.

== Utility: find (ricerca di file)

L'utility `find` è molto versatile per cercare file in base a diverse condizioni e eseguire azioni sui risultati. La sintassi è `$ find <path> <search-condition(s)> <action>`. `find` discende ricorsivamente attraverso il path e applica le condizioni di ricerca a ogni file.
Condizioni di ricerca (`<search-condition(s)>`):
- `-atime n`: file visitati `n` giorni fa.
- `-mtime n`: file modificati `n` giorni fa.
- `-size n[bckwMG]`: file di dimensione `n` (con unità specificate).
- `-type c`: tipo di file (es. `f` per file, `d` per directory, `l` per link).
- `-name "name"`: trova file con un nome specifico (es. `*.c`).
Azioni (`<action>`):
- `-exec command [options] { } \;`: esegue un comando usando il file trovato come input. `{ }` rappresenta il percorso del file, `\;` termina il comando.
- `-ok command [options] { } \;`: come `-exec` ma richiede conferma.
- `-print;`: mostra i file trovati sullo schermo.
Esempio: `find /tmp/ -type s -print 2>/dev/null` (ricerca in `/tmp/` file di tipo `s` reindirizzando gli errori a `/dev/null`).

== Utility: grep (filtrare i file)

`grep` (get regular expression) cerca file contenenti un motivo specifico. La sintassi è `$ grep <options> <search-pattern> <file(s)>`. `grep` mostra le linee che contengono il motivo (`<search-pattern>`) in ciascuno dei file specificati (`<file(s)>`).
Esempi:
- `grep ciao ~/prova.txt`
- `grep if /usr/include/time.h`
Opzioni:
- `-n`: visualizza anche il numero di riga.
- `-c`: mostra il numero di linee in cui la sequenza è trovata.
- `-i`: non distingue tra maiuscole e minuscole.
- `-w`: trova solo parole intere.
- `-q` (quiet): restituisce `0` se il testo è trovato, `1` altrimenti, senza scrivere nulla sull'output standard.
- `-l`: visualizza solo i nomi dei file che contengono le righe corrispondenti.

== Gestione dei pacchetti (Debian-based)

Il sistema di gestione dei pacchetti usa un database per tracciare i pacchetti installati, non installati e disponibili. Il programma `apt-get` usa questo database per installare pacchetti e le loro dipendenze.
- `(sudo) apt-get update`: aggiorna l'elenco dei pacchetti disponibili dagli archivi in `/etc/apt/sources.list`.
- `(sudo) apt-get install nomepacchetto`: installa un pacchetto e le sue dipendenze.
- `(sudo) apt-get remove nomepacchetto`: rimuove un pacchetto.
APT recupera i file necessari dalle sorgenti e li archivia in `/var/cache/apt/archives/`. Per gestire questo archivio:
- `apt-get clean`: elimina tutto da `/var/cache/apt/archives/` (tranne i file di lock), forzando un nuovo download in caso di reinstallazione.
- `apt-get autoclean`: rimuove solo i file inutili.

== File compressi: tar.gz

Un file `tar.gz` è un modo comune per archiviare sorgenti, spesso chiamato "tarball". Esistono altri formati come `bz2` e `zip`.
- `tar -czf nome.tar.gz fileDaComprimere`: comprime file in un archivio `tar.gz`.
- `tar -zxvf nome.tar.gz`: estrae file da un archivio `tar.gz`.

== Controllo: processi

Per controllare i processi:
- `ps`: lista i processi attivi.
- `top`: mostra una lista dinamica dei processi in esecuzione (può essere sospeso con `CTRL Z`).
Per terminare un processo:
- `sudo kill -9 <ID proc>`: termina forzatamente un processo con un dato ID.

== Controllo: spazio su disco

- `du -h`: stima l'utilizzo dello spazio per le cartelle.
- `df -h`: descrive l'utilizzo dello spazio su disco del file system.

=== Shell: scripting

La shell è programmabile; è possibile creare *shell script*, che sono file contenenti sequenze di comandi per il sistema operativo, facilitando l'esecuzione ripetuta. Un esempio di script base è:
```bash
=!/bin/bash
= My first script
echo "Hello World!"
```
La prima riga (`=!/bin/bash`) indica al sistema che il file deve essere eseguito da `/bin/bash`, il percorso standard della shell bash sui sistemi Unix-based.
