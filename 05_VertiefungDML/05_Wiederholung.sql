# Übungen

Im folgenden Skript werden die Beispiel-Tabellen `VERTRETER`, `VERKAUF` und `ARTIKEL` verwendet.

## Aufgabe 1
Führe das SQL-Skript [DB-Vertreter](./SQL_-_DB-Vertreter.sql) in SQLPlus aus, um die Tabellen anzulegen und mit Beispieldaten zu füllen. Wie lautet dein Befehl um das SQL-Skript auszuführen?

### Lösung
```sql
start 
```

## Aufgabe 2
Mache dich mit den Tabellen vertraut bzgl.:
* Spalten und Datentypen
* Beziehung der Tabellen zueinander
* Datensätzen in den Tabellen und was diese bedeuten

## Aufgabe 3
Zeige alle Vertreter mit `NAME` und `VNR` an, die eine Provision von  weniger als 7% erhalten.

### Lösung
```sql
Deine Lösung

SELECT VNR, VNAME
FROM vertreter
WHERE Provision <1.07;
```

## Aufgabe 4
 Bei welchen Artikeln (`NAME` und `ARTIKELNUMMER`) liegt der Preis über `100`?
 
 ###Lösung
 ```sql
 Deine Lösung
 
 SELECT ANAME, ANR
 FROM artikel
 WHERE APREIS >100;