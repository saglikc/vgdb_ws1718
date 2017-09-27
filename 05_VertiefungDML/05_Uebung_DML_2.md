# Übung

Löse folgende Aufgaben mit Hilfe von Unterabfragen.

## Aufgabe 1
Zeige alle Vertreter (`VNR`, `VNAME`) an, die bereits Artikel mit der `ANR` = `13` verkauft haben.

### Lösung
```sql
SELECT vt.VNR, vt.VNAME 
FROM Vertreter vt
WHERE VT.VNR IN (
	SELECT vk.VNR
	FROM verkauf vk
	WHERE vk.ANR = 13
) 
AND vt.VNAME IS NOT NULL;


## Aufgabe 2
Zeige alle Artikel (`ANR`, `ANAME`) an, die der Vertreter mit der `VNR` = `4321` am `27.06.2015` verkauft hat.

### Lösung
SELECT a.ANR, a.ANAME
FROM artikel a 
WHERE a.ANR IN (
SELECT vk.anr 
FROM verkauf vk, vertreter vt
 WHERE vt.vnr = 4321 AND vk.datum = to_date('27.06.2015', 'dd.mm.yyyy'));

Deine Lösung
```

## Aufgabe 3
Zeige alle Vertreter (`VNR`, `VNAME`) an, die bereits Artikel verkauft haben, deren Preis über `100`€ liegt.

### Lösung
```sql
SELECT vt.VNR, vt.VNAME
FROM Vertreter vt
WHERE vt.vnr IN(
SELECT vk.vnr
FROM artikel a 
INNER JOIN verkauf vk ON vk.anr = a.anr
WHERE a.apreis > 100);
```

## Aufgabe 4
Zeige alle Vertreter, die noch nie den Artikel mit der `ANR` = `22` verkauft haben.

### Lösung
```sql
SELECT vt.vname
FROM Vertreter vt
WHERE VT.VNR NOT IN (
	SELECT vk.VNR
	FROM verkauf vk
	WHERE vk.anr = 22);
``` 

## Aufgabe 5
Welche Vertreter (`VNR`) haben am `27.06.2015` mehr Artikel mit `ANR` = `12` verkauft als der Vertreter mit `VNR` = `4321`?

### Lösung
```sql
 

``` 

