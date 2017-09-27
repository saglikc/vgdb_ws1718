# Übungen

Im folgenden Skript werden die Beispiel-Tabellen `VERTRETER`, `VERKAUF` und `ARTIKEL` verwendet.

## Aufgabe 1
Führe das SQL-Skript [DB-Vertreter](./SQL_-_DB-Vertreter.sql) in SQLPlus aus, um die Tabellen anzulegen und mit Beispieldaten zu füllen. Wie lautet dein Befehl um das SQL-Skript auszuführen?

### Lösung
```sql
start Pfad eingeben
```

## Aufgabe 2
Mache dich mit den Tabellen vertraut bzgl.:
* Spalten und Datentypen
* Beziehung der Tabellen zueinander
* Datensätzen in den Tabellen und was diese bedeuten

## Aufgabe 3
<<<<<<< HEAD
Zeige alle Vertreter mit `NAME` und `VNR` an, die eine Provision von  weniger als 7% erhalten. 

### Lösung
```sql
Deine Lösung
```

## Aufgabe 4
Bei welchen Artikeln (`NAME` und `ARTIKELNUMMER`) liegt der Preis über `100`?
=======
Zeige alle Vertreter mit `NAME` und `VNR` an, die eine Provision von  weniger als 7% erhalten.
>>>>>>> loesung 05

### Lösung
```sql
Deine Lösung

SELECT VNR, VNAME
FROM vertreter
WHERE Provision < 0.07;
```

## Aufgabe 4
 Bei welchen Artikeln (`NAME` und `ARTIKELNUMMER`) liegt der Preis über `100`?
 
 ###Lösung
 ```sql
 Deine Lösung
 
 SELECT ANAME, ANR
 FROM artikel
 WHERE APREIS >100;
 ``
 
 ## Aufgabe 5
 ### Lösung
 ```sql
 
 SELECT GEBURTSDATUM, VNAME
 FROM VERTRETER
 WHERE to_date(GEBURTSDATUM, 'dd.mm.yyyy') < '01.01.1980' and VNAME LIKE '%i%';
 ```
 
 ## Aufgabe 6
 ### Lösung
 ```sql
 INSERT INTO VERTRETER (PROVISION, VNR)
 values (0.06, 7777);
 ```
 
 ## Aufgabe 7
 ### Lösung
 ```sql
 INSERT INTO VERKAUF (UNR, VNR, ANR, ANZAHL, DATUM)
 VALUES (1014, 7777, 13, 22, '27.09.2017');
 ````
 
 
 ## Aufgabe 8
 ### Lösung
 ```sql
 UPDATE ARTIKEL
 SET APREIS = 88.90 
 WHERE ANR = 12;
 ```
 
 ##Aufgabe 9
### Lösung
```sql
 ALTER TABLE VERTRETER
 ADD (bonus NUMBER(4,0);
 ```
 
 ## Aufgabe 10
### Lösung
```sql
UPDATE VERTRETER
SET BONUS = 500;
```

## Aufgabe 11
###Lösung
```sql
ALTER TABLE VERTRETER
MODIFY (VNAME VARCGAR2(20));
```


## Aufagbe 12
### Lösung
```sql
SELECT DISCTINCT DATUM
FROM VERKAUF;
```
`
 
 
 