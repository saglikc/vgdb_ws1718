# Übungen

Führe das Skript [DB-Vertreter](./SQL_-_DB-Vertreter.sql) aus.

## Aufgabe 1
Lege für die Tabellen `VERTRETER`, `VERKAUF` und `ARTIKEL` Primary Key Constraints (`PK`) an.

### Lösung
```sql
CREATE TABLE vertreter
vnr number (3,0)
Constraint PKPER Primary KEY (vnr);

CREATE TABLE verkauf
UNR NUMBER (4,0)
Constraint PKPER Primary KEY (UNR);

CREATE TABLE ARTIKEL
APREIS NUMBER (8,2)
Constraint PKPER Primary KEY (APREIS);
```

## Aufgabe 2
Lege für die Tabelle `VERKAUF` alle notwendigen Foreign Key Constraints (`FK`) an.

### Lösung
```sql
ALTER TABLE VERKAUF
ADD CONSTRAINT FKVERK_ART Foreign KEY(ANR) REFERNCES ARTIKEL;

ALTER TABLE VERKAUF
ADD CONSTRAINT FKVERK_VERK Foreign KEY(VNR) REFERNCES VERTRETER;
```

## Aufgabe 3
Lösche den Foreign Key Constraint `FK_DEPTNO`. Dieser ist für die Spalte `DEPTNO` in der Tabelle `EMP` definiert.

### Lösung
```sql
ALTER TABLE DEPTNO
DROP CONSTRAINT FK_DEPTNO;
```

## Aufgabe 4
Lege den benötigten Foreign Key Constraint (`FK`) für die Tabelle `EMP` neu an.

### Lösung
```sql
ALTER TABLE EMP
ADD CONSTRAINT FK_DEPTNO FOREIGN KEY(DEPTNO) REFERNCES DEPT;
```

