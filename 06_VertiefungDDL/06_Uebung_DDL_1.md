# Übungen

## Aufgabe 1
Erzeuge eine View, die folgendes Ergebnis repräsentiert, das nur Verkäufe vom `27.06.2015` umfasst:

| VNR  | VNAME    | UNR  | ANZAHL | ANR | ANAME         | APREIS  |
| ---- | -------- | ---- | ------ | --- | ------------- | ------- |
| 4321 | Jahred   | 1010 | 7      | 12  | Stiefel       | 89,99   |
| 3401 | Schmitz  | 1000 | 10     | 12  | Stiefel       | 89,99   |
| 4321 | Jahred   | 1011 | 15     | 11  | Pullover      | 35,2    |
| 1010 | Mueller  | 1006 | 40     | 11  | Pullover      | 35,2    |
| 5337 | Ritsch   | 1003 | 70     | 11  | Pullover      | 35,2    |
| 4321 | Jahred   | 1009 | 35     | 13  | Wintermantel  | 123,8   |
| 1010 | Mueller  | 1007 | 35     | 13  | Wintermantel  | 123,8   |

### Lösung
```sql
CREATE OR REPLACE VIEW v_vt_vk_a AS
SELECT vt.VNR, VNAME, UNR, ANZAHL, vk.ANR, ANAME, APREIS
FROM vertreter vt
INNER JOIN verkauf vk ON (vt.vnr = vk.vnr)
INNER JOIN artikel a ON (vk.anr = a.anr)
WHERE TO_CHAR (datum, 'dd.mm.yyyy') = '27.06.2015';
```

## Aufgabe 2
Wie viele **Verkäufe** hat der Vertreter Mueller am `27.06.15` durchgeführt?

### Lösung
```sql
SELECT COUNT (VNR)
FROM verkauf
WHERE DATUM IN (
SELECT DATUM 
FROM VERKAUF
 WHERE TO_CHAR(datum, 'dd.mm.yyyy') = '27.06.2015')
AND VNR = (
SELECT VNR
 FROM VERTRETER
 WHERE VNAME = 'Mueller');


```

## Aufgabe 3
Wie viele **Artikel** hat der Vertreter Mueller am `27.06.15 verkauft?

### Lösung
```sql
SELECT COUNT (ANR)
FROM verkauf
WHERE DATUM IN (
SELECT DATUM 
FROM artikel
 WHERE TO_CHAR(datum, 'dd.mm.yyyy') = '27.06.2015')
AND anr = (
SELECT anr
 FROM VERTRETER
 WHERE VNAME = 'Mueller');
```

## Aufgabe 4
Wie viele Artikel wurden durchschnittlich am `27.06.15` verkauft?

### Lösung
```sql
SELECT COUNT (ANR)
FROM verkauf
WHERE DATUM IN (
SELECT DATUM 
FROM artikel
 WHERE TO_CHAR(datum, 'dd.mm.yyyy') = '27.06.2015');

```

## Aufgabe 5
Welcher Artikel (`ANR` und `ANAME`) wurde am `27.06.15` nicht verkauft?

### Lösung
```sql
SELECT ANR, ANAME
FROM Artikel
WHERE ANR NOT IN (
SELECT DISTINCT ANR
 FROM v_vt_vk_a);
```
