# Übung

## Aufgabe 1
Zeige alle Vertreter mit `NAME` und `VNR` an, deren Name länger als `6` Zeichen ist.

### Lösung
```sql
SELECT vname, VNR
FROM Vertreter
WHERE LENGTH(VNAME) > 6;
```

## Aufgabe 2
Zeige alle Vertreter, die im Juli oder im Mai geboren sind.

### Lösung
```sql
SELECT vname, geburtsdatum
FROM vertreter
WHERE TO_CHAR(geburtsdatum, 'mm') = '06' 
OR TO_CHAR(geburtsdatum, 'mm') = '05' ;
```

## Aufgabe 3

Erzeuge folgende Ausgabe:

| VNR  | VNAME_UP | PROV_GRD  |
| ---- | -------- | --------- |
| 1010 | MUELLER  | ,1        |
| 3401 | SCHMITZ  | ,1        |
| 5337 | RITSCH   | ,1        |
| 4321 | JAHRED   | 0         |

### Lösung
```sql
SELECT provision, vname, vnr
FROM vertreter
WHERE round(1,)
```

## Aufgabe 4
Zeige alle Artikel an, die mit `Wi` beginnen. Löse diese Aufgabe mit der substr()-Funktion.

### Lösung
```sql
SELECT ANAME
FROM artikel
WHERE SUBSTR(ANAME,1,2) = 'Wi';
```

## Aufgabe 5
Erzeuge folgende Ausgabe:

| VNR   | VNAME   | DAT   |
| ----  | ------- | ----- |
| 1010  | Mueller | 03-05 |
| 3401  | Schmitz | 15-08 |
| 5337  | Ritsch  | 23-07 |
| 4321  | Jahred  | 27-12 |

### Lösung
```sql
SELECT VNR, VNAME, geburtsdatum
from vertreter;
```

## Aufgabe 6
Zeige alle Vertreter (`VNR`, `VNAME`) an, die im selben Jahr geboren sind wie der Vertreter Jahred.

### Lösung
```sql
SELECT VNR,VNAME
FROM vertreter
WHERE TO_CHAR(geburtsdatum,'yyyy') = (
SELECT TO_CHAR(geburtsdatum,'yyyy') 
FROM VERTRETER 
WHERE VNAME LIKE 'Jahred');  
```

## Aufgabe 7
Erhöhe bei den Vertretern den Bonus um `300`, die in einem Monat geboren sind, der `31` Tage hat.

### Lösung
```sql
UPDATE vertreter
set bonus = bonus + 300
WHERE vnr IN (
	SELECT vnr
	FROM vertreter
	WHERE TO_CHAR(Geburtsdatum, 'mm') IN (
		SELECT TO_CHAR(LAST_DAY(Geburtsdatum), 'mm')
		FROM vertreter
		WHERE TO_CHAR(LAST_DAY(Geburtsdatum), 'dd') = '31'
));
```
