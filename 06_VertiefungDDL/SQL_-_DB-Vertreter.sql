set feedback off
set define off


PROMP Tabelle Vertreter loeschen...
DROP TABLE Vertreter cascade constraints;

PROMPT Tabelle Artikel loeschen...
DROP TABLE Artikel cascade constraints;

PROMPT Tabelle Verkauf loeschen...
DROP TABLE Verkauf cascade constraints;

PROMPT Tabelle Verterter anlegen...
Create Table Vertreter
(
	VNr NUMBER(4,0),
	VName varchar2(15), 
	Geburtsdatum date, 
	Provision NUMBER(3,2)
);

PROMPT Tabelle Artikel anlegen...
Create Table Artikel
(
	ANr NUMBER(4,0),
	AName varchar2(15), 
	APreis NUMBER(8,2)
);

PROMPT Tabelle Verkauf anlegen...
Create Table Verkauf
(
	UNr NUMBER(4,0),
	VNr NUMBER (4,0),
	ANr NUMBER(4,0),
	Anzahl NUMBER(4,0) Not Null,
	Datum date Not Null
);

PROMPT Datensaetze in Vertreter einfuegen ...
Insert Into Vertreter Values(1010, 'Mueller', to_date('03.05.1988','dd.mm.yyyy'), 0.07);
Insert Into Vertreter Values(3401, 'Schmitz', to_date('15.08.1982','dd.mm.yyyy'), 0.05);
Insert Into Vertreter Values(5337, 'Ritsch', to_date('23.07.1973','dd.mm.yyyy'), 0.06);
Insert Into Vertreter Values(4321, 'Jahred', to_date('27.12.1988','dd.mm.yyyy'), 0.04);

PROMPT Datensaetze in Artikel einfuegen ...
Insert Into Artikel Values (12, 'Stiefel', 89.99);
Insert Into Artikel Values (22, 'Jeanshose', 79.50);
Insert Into Artikel Values (11, 'Pullover', 35.20);
Insert Into Artikel Values (13, 'Wintermantel', 123.80);

PROMPT Datensaetze in Verkauf einfuegen ...
Insert Into Verkauf Values(1000, 3401, 12, 10, to_date('27.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1001, 3401, 11, 20, to_date('28.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1002, 3401, 13,  5, to_date('28.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1003, 5337, 11, 70, to_date('27.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1004, 5337, 22, 35, to_date('28.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1005, 5337, 12, 10, to_date('28.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1006, 1010, 11, 40, to_date('27.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1007, 1010, 13, 35, to_date('27.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1008, 1010, 12, 20, to_date('28.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1009, 4321, 13, 35, to_date('27.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1010, 4321, 12,  7, to_date('27.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1011, 4321, 11, 15, to_date('27.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1012, 4321, 13, 21, to_date('28.06.2015','dd.mm.yyyy'));
Insert Into Verkauf Values(1013, 4321, 22, 18, to_date('28.06.2015','dd.mm.yyyy'));

COMMIT;
set feedback on
set define on
prompt Done.
