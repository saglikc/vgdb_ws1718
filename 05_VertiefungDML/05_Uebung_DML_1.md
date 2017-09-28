# Übungen

Löse die Aufgaben durch `JOIN` der Tabellen.

## Aufgabe 1
Erzeuge eine Ausgabe, in der jeder Vertreter (`VNR` und `VNAME`) mit all seinen Verkäufen (`DATUM`, `ANZAHL` und `ANR`) gelistet wird.

### Lösung
```sql
SELECT vt.VNR, vt.VNAME, vk.ANR, vk.anzahl, vk.datum
FROM Vertreter vt
INNER JOIN Verkauf vk ON vt.VNR = vk.VNR;	

```

## Aufgabe 2
Reduziere die Ausgabe aus Aufgabe 1 auf Vertreter und ihre Verkäufe, bei denen mehr als 10 Artikel verkauft wurden.

### Lösung
```sql
SELECT vt.VNR, vt.VNAME, vk.ANR, vk.anzahl, vk.datum
FROM Vertreter vt
INNER JOIN Verkauf vk ON vt.VNR = vk.VNR;
WHERE anzahl > 10;
```

## Aufgabe 3
Ergänze die Ausgabe aus Aufgabe 2 um den Namen und den Preis der jeweils verkaufen Artikel.
Verwende dazu zwei JOIN-Befehle wie unten dargestellt.

```sql
SELECT <SPALTE/N>
FROM <TABELLE/N>
 INNER JOIN <TABELLE_A> ON (<JOIN-Bedingung>)
 INNER JOIN <TABELLE_B> ON (JOIN-Bedingung);
```

### Lösung
```sql
SELECT vt.VNR, vt.VNAME, vk.ANR, vk.anzahl, vk.datum, a.ANAME, a.APREIS
FROM Vertreter vt
INNER JOIN Verkauf vk ON vt.VNR = vk.VNR
INNER JOIN Artikel a ON vk.ANR = a.ANR
WHERE anzahl > 10;
```


## Aufgabe 4
Zeige für den Verkäufer mit `VNR` = `1010` alle Verkäufe (`ANZAHL`, `DATUM`) an, die sich auf Stiefel oder Wintermäntel beziehen und am `27.06.2015` getätigt wurden.

### Lösungen
```sql
SELECT vt.VNR, vk.anzahl, vk.datum, a.aname
FROM vertreter vt
INNER JOIN Verkauf vk ON vt.VNR = vk.VNR
INNER JOIN Artikel a ON vk.ANR = a.ANR
WHERE vt.VNR = 1010 
AND vk.datum = to_date('27.06.2015', 'dd.mm.yyyy')
AND a.Aname IN('Stiefel', 'Wintermantel');

```
