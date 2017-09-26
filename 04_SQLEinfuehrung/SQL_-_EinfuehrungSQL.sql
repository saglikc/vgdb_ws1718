spool c:\temp\db_ws1415.log
set feedback off
set define off

prompt Dropping FACH...
drop table FACH cascade constraints;
prompt Dropping FACHBEREICH...
drop table FACHBEREICH cascade constraints;
prompt Dropping STUDIENGANG...
drop table STUDIENGANG cascade constraints;
prompt Dropping ANGEBOT...
drop table ANGEBOT cascade constraints;
prompt Dropping KLAUSUR...
drop table KLAUSUR cascade constraints;
prompt Dropping NOTENSKALA...
drop table NOTENSKALA cascade constraints;
prompt Dropping studentische_person...
drop table studentische_person cascade constraints;
prompt Dropping ANMELDUNG...
drop table ANMELDUNG cascade constraints;
prompt Dropping KLAUS_BEZIE_ANGEBO...
drop table KLAUS_BEZIE_ANGEBO cascade constraints;
prompt Dropping LEISTUNGSSCHEIN...
drop table LEISTUNGSSCHEIN cascade constraints;
prompt Dropping EMP...
drop table EMP cascade constraints;
prompt Dropping DEPT...
drop table DEPT cascade constraints;
prompt Dropping BONUS...
drop table BONUS cascade constraints;
prompt Dropping SALGRADE...
drop table SALGRADE cascade constraints;

prompt Creating FACH...
create table FACH
(
  FACHNR           NUMBER(8) not null,
  BEZEICHNUNG      VARCHAR2(50) not null
)
;
alter table FACH
  add primary key (FACHNR);
alter table FACH
  add constraint C_FACHNR_GROESSER_NULL
  check (fachnr > 0  );

prompt Creating FACHBEREICH...
create table FACHBEREICH
(
  FACHBEREICHNR NUMBER(8) not null,
  BEZEICHNUNG   VARCHAR2(50) not null
)
;
alter table FACHBEREICH
  add primary key (FACHBEREICHNR);
alter table FACHBEREICH
  add constraint C_PK_GROESSER_NULL
  check (fachbereichnr >0  );

prompt Creating STUDIENGANG...
create table STUDIENGANG
(
  STUDIENGANGNR NUMBER(8) not null,
  BEZEICHNUNG   VARCHAR2(50) not null,
  FACHBEREICHNR NUMBER(8) not null
)
;
alter table STUDIENGANG
  add primary key (STUDIENGANGNR);
alter table STUDIENGANG
  add constraint FK_STUDIENGANG_FACHBEREICH foreign key (FACHBEREICHNR)
  references FACHBEREICH (FACHBEREICHNR);
alter table STUDIENGANG
  add constraint C_PK_GOESSER_NULL
  check (studiengangnr > 0  );

prompt Creating ANGEBOT...
create table ANGEBOT
(
  STUDIENGANGNR NUMBER(8) not null,
  FACHNR        NUMBER(8) not null
)
;
alter table ANGEBOT
  add primary key (STUDIENGANGNR, FACHNR);
alter table ANGEBOT
  add constraint FK_ANGEBOT_FACH foreign key (FACHNR)
  references FACH (FACHNR);
alter table ANGEBOT
  add constraint FK_ANGEBOT_STGANG foreign key (STUDIENGANGNR)
  references STUDIENGANG (STUDIENGANGNR);

prompt Creating KLAUSUR...
create table KLAUSUR
(
  KLAUSURNR   NUMBER(8) not null,
  DATUM       DATE not null,
  HILFSMITTEL VARCHAR2(2000),
  DOZENTEN    VARCHAR2(200) default '' not null,
  RAUM        VARCHAR2(50)
)
;
alter table KLAUSUR
  add primary key (KLAUSURNR);
alter table KLAUSUR
  add constraint C_KLNR_GROESSER_NULL
  check (klausurnr > 0  );

prompt Creating NOTENSKALA...
create table NOTENSKALA
(
  NOTEN NUMBER(2,1) not null
)
;
alter table NOTENSKALA
  add constraint PK_NOTENSKALA primary key (NOTEN);
alter table NOTENSKALA
  add constraint C_NOTEN
  check (noten in (1,1.3,1.7,2,2.3,2.7,3,3.3,3.7,4,5)  );

prompt Creating studentische_person...
create table studentische_person
(
  MATRIKELNR       NUMBER(8) not null,
  NAME             VARCHAR2(50) not null,
  STUDIENGANGNR    NUMBER(8) not null,
  UNIX_NAME        CHAR(8)
)
;
alter table studentische_person
  add primary key (MATRIKELNR);
alter table studentische_person
  add constraint U_UNIX_NAME unique (UNIX_NAME);
alter table studentische_person
  add constraint FK_STUDENT_STGANG foreign key (STUDIENGANGNR)
  references STUDIENGANG (STUDIENGANGNR);
alter table studentische_person
  add constraint C_MAT_GROESSER_NULL
  check (matrikelnr > 0  );
alter table studentische_person
  add constraint C_UNIX_NAME
  check (unix_name = upper(unix_name)  );

prompt Creating ANMELDUNG...
create table ANMELDUNG
(
  MATRIKELNR NUMBER(8) not null,
  KLAUSURNR  NUMBER(8) not null,
  NOTE       NUMBER(2,1)
)
;
alter table ANMELDUNG
  add primary key (MATRIKELNR, KLAUSURNR);
alter table ANMELDUNG
  add constraint FK_ANMELDUNG_KLAUSUR foreign key (KLAUSURNR)
  references KLAUSUR (KLAUSURNR);
alter table ANMELDUNG
  add constraint FK_ANMELDUNG_STUDENT foreign key (MATRIKELNR)
  references studentische_person (MATRIKELNR);
alter table ANMELDUNG
  add constraint FK_NOTEN foreign key (NOTE)
  references NOTENSKALA (NOTEN);

prompt Creating KLAUS_BEZIE_ANGEBO...
create table KLAUS_BEZIE_ANGEBO
(
  KLAUSURNR     NUMBER(8) not null,
  STUDIENGANGNR NUMBER(8) not null,
  FACHNR        NUMBER(8) not null
)
;
alter table KLAUS_BEZIE_ANGEBO
  add primary key (KLAUSURNR, STUDIENGANGNR, FACHNR);
alter table KLAUS_BEZIE_ANGEBO
  add constraint FK_KLAUS_BEZIE_ANGEBO_ANGEBOT foreign key (STUDIENGANGNR, FACHNR)
  references ANGEBOT (STUDIENGANGNR, FACHNR);
alter table KLAUS_BEZIE_ANGEBO
  add constraint FK_KLAUS_BEZIE_ANGEBO_KLAUSUR foreign key (KLAUSURNR)
  references KLAUSUR (KLAUSURNR)
  deferrable initially deferred;

prompt Creating LEISTUNGSSCHEIN...
create table LEISTUNGSSCHEIN
(
  MATRIKELNR      NUMBER(8) not null,
  FACHNR          NUMBER(8) not null,
  NOTE            NUMBER(2,1),
  ANZAHL_VERSUCHE NUMBER(1)
)
;
alter table LEISTUNGSSCHEIN
  add primary key (MATRIKELNR, FACHNR);
alter table LEISTUNGSSCHEIN
  add constraint FK_LSCHEIN_FACH foreign key (FACHNR)
  references FACH (FACHNR);
alter table LEISTUNGSSCHEIN
  add constraint FK_LSCHEIN_STUDENT foreign key (MATRIKELNR)
  references studentische_person (MATRIKELNR);
alter table LEISTUNGSSCHEIN
  add constraint FK_SCHEIN_ foreign key (NOTE)
  references NOTENSKALA (NOTEN);
alter table LEISTUNGSSCHEIN
  add constraint C_ANZAHL_VERSUCHE
  check (((anzahl_versuche in (1,2,3) or anzahl_versuche is null) and note is not null) or (note is null and anzahl_versuche =1)  );

prompt Disabling foreign key constraints for STUDIENGANG...
alter table STUDIENGANG disable constraint FK_STUDIENGANG_FACHBEREICH;
prompt Disabling foreign key constraints for ANGEBOT...
alter table ANGEBOT disable constraint FK_ANGEBOT_FACH;
alter table ANGEBOT disable constraint FK_ANGEBOT_STGANG;
prompt Disabling foreign key constraints for studentische_person...
alter table studentische_person disable constraint FK_STUDENT_STGANG;
prompt Disabling foreign key constraints for ANMELDUNG...
alter table ANMELDUNG disable constraint FK_ANMELDUNG_KLAUSUR;
alter table ANMELDUNG disable constraint FK_ANMELDUNG_STUDENT;
alter table ANMELDUNG disable constraint FK_NOTEN;
prompt Disabling foreign key constraints for KLAUS_BEZIE_ANGEBO...
alter table KLAUS_BEZIE_ANGEBO disable constraint FK_KLAUS_BEZIE_ANGEBO_ANGEBOT;
alter table KLAUS_BEZIE_ANGEBO disable constraint FK_KLAUS_BEZIE_ANGEBO_KLAUSUR;
prompt Disabling foreign key constraints for LEISTUNGSSCHEIN...
alter table LEISTUNGSSCHEIN disable constraint FK_LSCHEIN_FACH;
alter table LEISTUNGSSCHEIN disable constraint FK_LSCHEIN_STUDENT;
alter table LEISTUNGSSCHEIN disable constraint FK_SCHEIN_;
prompt Loading FACH...
insert into FACH (FACHNR, BEZEICHNUNG)
values (1, 'Statistik');
insert into FACH (FACHNR, BEZEICHNUNG)
values (2, 'Mathematik');
insert into FACH (FACHNR, BEZEICHNUNG)
values (3, 'Grundlagen Datenbanken');
insert into FACH (FACHNR, BEZEICHNUNG)
values (4, 'Steuern');
insert into FACH (FACHNR, BEZEICHNUNG)
values (5, 'Steuern fuer Fortgeschrittene');
insert into FACH (FACHNR, BEZEICHNUNG)
values (6, 'BWL I');
commit;
prompt 6 records loaded
prompt Loading FACHBEREICH...
insert into FACHBEREICH (FACHBEREICHNR, BEZEICHNUNG)
values (10, 'Wirtschaft');
insert into FACHBEREICH (FACHBEREICHNR, BEZEICHNUNG)
values (6, 'Informatik');
commit;
prompt 2 records loaded
prompt Loading STUDIENGANG...
insert into STUDIENGANG (STUDIENGANGNR, BEZEICHNUNG, FACHBEREICHNR)
values (903, 'BSc Wirtschaftsinformatik', 10);
insert into STUDIENGANG (STUDIENGANGNR, BEZEICHNUNG, FACHBEREICHNR)
values (904, 'BA Betriebswirtschaft', 10);
insert into STUDIENGANG (STUDIENGANGNR, BEZEICHNUNG, FACHBEREICHNR)
values (916, 'BA International Business', 10);
insert into STUDIENGANG (STUDIENGANGNR, BEZEICHNUNG, FACHBEREICHNR)
values (933, 'MSc Wirtschaftsinformatik', 10);
insert into STUDIENGANG (STUDIENGANGNR, BEZEICHNUNG, FACHBEREICHNR)
values (934, 'MA International Business Management', 10);
insert into STUDIENGANG (STUDIENGANGNR, BEZEICHNUNG, FACHBEREICHNR)
values (943, 'BSc Informatik', 6);
insert into STUDIENGANG (STUDIENGANGNR, BEZEICHNUNG, FACHBEREICHNR)
values (944, 'MSc Informatik', 6);
commit;
prompt 7 records loaded
prompt Loading ANGEBOT...
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (903, 1);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (903, 2);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (903, 4);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (903, 6);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (904, 1);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (904, 2);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (904, 4);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (904, 5);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (904, 6);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (916, 1);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (916, 2);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (916, 4);
insert into ANGEBOT (STUDIENGANGNR, FACHNR)
values (916, 6);
commit;
prompt 13 records loaded
prompt Loading KLAUSUR...
insert into KLAUSUR (KLAUSURNR, DATUM, HILFSMITTEL, DOZENTEN, RAUM)
values (1, to_date('17-01-2015 09:00:00', 'dd-mm-yyyy hh24:mi:ss'), 'Alle papiergebundenen Unterlagen', 'Fuchs, Hase', 'Aula');
insert into KLAUSUR (KLAUSURNR, DATUM, HILFSMITTEL, DOZENTEN, RAUM)
values (2, to_date('18-01-2015 10:0:00', 'dd-mm-yyyy hh24:mi:ss'), 'Keine ', 'Maus', 'HS3, Aula');
insert into KLAUSUR (KLAUSURNR, DATUM, HILFSMITTEL, DOZENTEN, RAUM)
values (3, to_date('19-01-2015 14:30:00', 'dd-mm-yyyy hh24:mi:ss'), 'Taschenrechner, Alle papiergebundenen Unterlagen', 'Katze', null);
insert into KLAUSUR (KLAUSURNR, DATUM, HILFSMITTEL, DOZENTEN, RAUM)
values (4, to_date('20-01-2015 11:15:00', 'dd-mm-yyyy hh24:mi:ss'), 'Keine', 'Fisch', 'HS3');
insert into KLAUSUR (KLAUSURNR, DATUM, HILFSMITTEL, DOZENTEN, RAUM)
values (5, to_date('21-01-2015 12:00:00', 'dd-mm-yyyy hh24:mi:ss'), 'Sparsam kommentierte Gesetzestexte', 'Pferd, Kuh', 'Aula');
commit;
prompt 5 records loaded
prompt Loading NOTENSKALA...
insert into NOTENSKALA (NOTEN)
values (1);
insert into NOTENSKALA (NOTEN)
values (1.3);
insert into NOTENSKALA (NOTEN)
values (1.7);
insert into NOTENSKALA (NOTEN)
values (2);
insert into NOTENSKALA (NOTEN)
values (2.3);
insert into NOTENSKALA (NOTEN)
values (2.7);
insert into NOTENSKALA (NOTEN)
values (3);
insert into NOTENSKALA (NOTEN)
values (3.3);
insert into NOTENSKALA (NOTEN)
values (3.7);
insert into NOTENSKALA (NOTEN)
values (4);
insert into NOTENSKALA (NOTEN)
values (5);
commit;
prompt 11 records loaded
prompt Loading studentische_person...
insert into studentische_person (MATRIKELNR, NAME,  STUDIENGANGNR, UNIX_NAME)
values (123456, 'Hugo McKinnock',  903, 'MCKINNOH');
insert into studentische_person (MATRIKELNR, NAME, STUDIENGANGNR, UNIX_NAME)
values (234567, 'Nicole Mueller', 916, 'MUELLERN');
insert into studentische_person (MATRIKELNR, NAME, STUDIENGANGNR, UNIX_NAME)
values (345678, 'Katja Strauch', 904, 'STRAUCHK');
insert into studentische_person (MATRIKELNR, NAME,  STUDIENGANGNR, UNIX_NAME)
values (567890, 'Jana Mai', 904, 'MAIJANA ');
commit;
prompt 4 records loaded
prompt Loading ANMELDUNG...
insert into ANMELDUNG (MATRIKELNR, KLAUSURNR, NOTE)
values (123456, 4, null);
insert into ANMELDUNG (MATRIKELNR, KLAUSURNR, NOTE)
values (123456, 1, 2.3);
insert into ANMELDUNG (MATRIKELNR, KLAUSURNR, NOTE)
values (123456, 2, 2);
insert into ANMELDUNG (MATRIKELNR, KLAUSURNR, NOTE)
values (123456, 3, 2.7);
insert into ANMELDUNG (MATRIKELNR, KLAUSURNR, NOTE)
values (234567, 3, 2.7);
insert into ANMELDUNG (MATRIKELNR, KLAUSURNR, NOTE)
values (345678, 3, 2.7);
commit;
prompt 6 records loaded
prompt Loading KLAUS_BEZIE_ANGEBO...
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (1, 903, 1);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (1, 904, 1);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (1, 916, 1);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (2, 904, 4);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (2, 916, 4);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (3, 904, 5);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (4, 903, 2);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (5, 903, 6);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (5, 904, 6);
insert into KLAUS_BEZIE_ANGEBO (KLAUSURNR, STUDIENGANGNR, FACHNR)
values (5, 916, 6);
commit;
prompt 10 records loaded
prompt Loading LEISTUNGSSCHEIN...
insert into LEISTUNGSSCHEIN (MATRIKELNR, FACHNR, NOTE, ANZAHL_VERSUCHE)
values (234567, 4, null, 1);
insert into LEISTUNGSSCHEIN (MATRIKELNR, FACHNR, NOTE, ANZAHL_VERSUCHE)
values (123456, 4, null, 1);
insert into LEISTUNGSSCHEIN (MATRIKELNR, FACHNR, NOTE, ANZAHL_VERSUCHE)
values (123456, 3, null, null);
insert into LEISTUNGSSCHEIN (MATRIKELNR, FACHNR, NOTE, ANZAHL_VERSUCHE)
values (123456, 5, 2.7, null);
insert into LEISTUNGSSCHEIN (MATRIKELNR, FACHNR, NOTE, ANZAHL_VERSUCHE)
values (234567, 5, 2.7, 2);
insert into LEISTUNGSSCHEIN (MATRIKELNR, FACHNR, NOTE, ANZAHL_VERSUCHE)
values (345678, 5, 1.7, 1);
insert into LEISTUNGSSCHEIN (MATRIKELNR, FACHNR, NOTE, ANZAHL_VERSUCHE)
values (123456, 1, 4, 1);
commit;
prompt 7 records loaded
prompt Enabling foreign key constraints for STUDIENGANG...
alter table STUDIENGANG enable constraint FK_STUDIENGANG_FACHBEREICH;
prompt Enabling foreign key constraints for ANGEBOT...
alter table ANGEBOT enable constraint FK_ANGEBOT_FACH;
alter table ANGEBOT enable constraint FK_ANGEBOT_STGANG;
prompt Enabling foreign key constraints for studentische_person...
alter table studentische_person enable constraint FK_STUDENT_STGANG;
prompt Enabling foreign key constraints for ANMELDUNG...
alter table ANMELDUNG enable constraint FK_ANMELDUNG_KLAUSUR;
alter table ANMELDUNG enable constraint FK_ANMELDUNG_STUDENT;
alter table ANMELDUNG enable constraint FK_NOTEN;
prompt Enabling foreign key constraints for KLAUS_BEZIE_ANGEBO...
alter table KLAUS_BEZIE_ANGEBO enable constraint FK_KLAUS_BEZIE_ANGEBO_ANGEBOT;
alter table KLAUS_BEZIE_ANGEBO enable constraint FK_KLAUS_BEZIE_ANGEBO_KLAUSUR;
prompt Enabling foreign key constraints for LEISTUNGSSCHEIN...
alter table LEISTUNGSSCHEIN enable constraint FK_LSCHEIN_FACH;
alter table LEISTUNGSSCHEIN enable constraint FK_LSCHEIN_STUDENT;
alter table LEISTUNGSSCHEIN enable constraint FK_SCHEIN_;

prompt
prompt Creating view KLAUSURANMELDUNG
prompt ==============================
prompt
create or replace view klausuranmeldung as
select klausurnr,datum,hilfsmittel,dozenten,raum
-- select klausurnr,datum,substr(hilfsmittel,1,40)
from klausur
where
-- datum - (sysdate + 14) >= 0 and
klausurnr in
(select klausurnr from klaus_bezie_angebo
        where
        (fachnr,studiengangnr) in
        (
                select fachnr,studiengangnr from angebot where
                studiengangnr =
                (select studiengangnr from studentische_person where Unix_name=user )
                and
                fachnr in
                (select fachnr from fach where fachnr not in
                                (select
                                fachnr from leistungsschein where matrikelnr=
                                (select matrikelnr from studentische_person where
                                unix_name =user)
                                and (note is not null or anzahl_versuche =3)
                                )
                )
        )
)
/

prompt
prompt Creating view NOTEN
prompt ===================
prompt
create or replace view noten as
select klausurnr,note
from anmeldung
where matrikelnr =
   (select matrikelnr
    from studentische_person
   where unix_name=user)
and
   note is not null
/

prompt
prompt Creating function ANMELDUNG_ZULAESSIG
prompt =====================================
prompt
create or replace function 
anmeldung_zulaessig(matrikelnr_in IN number,klausurnr_in IN number)

return boolean
as
v_ergebnis char(2):='no';
begin

select 'ok' into v_ergebnis
from dual
where exists
(
      select klausurnr
      from klausur
      where klausurnr= klausurnr_in and
      datum - (sysdate + 14) >= 0 and
      klausurnr in
      (select klausurnr from klaus_bezie_angebo
              where
              (fachnr,studiengangnr) in
              (
                 select fachnr,studiengangnr from angebot where
                 studiengangnr =
                      (select studiengangnr from studentische_person where MATRIKELNR = matrikelnr_in)
                      and
                      fachnr in
                      (select fachnr from fach where fachnr not in
                                (select fachnr
                                 from leistungsschein
                                 where matrikelnr=matrikelnr_in
                                 and ((note is not null and note <= 4) or anzahl_versuche=3)
                                 )
                      )
              )
      )
);
 if v_ergebnis='ok' then
        return TRUE;
 else
        return false;
 end if;
 exception
 when others then
  raise_application_error(-20030,'Fehler in anmeldung_zulaessig function!'||substr(SQLERRM,1,80));
 end;
/

prompt
prompt Creating procedure DROP_ANMELD_KLAUSUR
prompt ======================================
prompt
create or replace procedure drop_anmeld_klausur(klausur_nr_in in number)
as
v_matrikelnr studentische_person.matrikelnr%type;
v_klausurnr klausuranmeldung.klausurnr%type;

begin
	begin
	select matrikelnr into v_matrikelnr
	from studentische_person
	where unix_name=user for update;
	exception
	when no_data_found then
        raise_application_error(-20008,'Es gibt keinen Studierenden mit dieser Kennung!');
	end;

	begin
	select klausurnr into v_klausurnr
	from klausuranmeldung
	where klausurnr=klausur_nr_in for update;
	exception
	when no_data_found then
        raise_application_error(-20009,'Es liegt keine Anmeldung vor fur den Studierenden zu der Klausur!');
	end;

delete from anmeldung
where matrikelnr=v_matrikelnr and
klausurNr=klausur_nr_in
;


exception
when others then
        raise_application_error(-20010,'proc drop_anmeld_klausur: '|| substr(SQLERRM,1,80));
end;
/

prompt
prompt Creating procedure GET_KLAUSUR_ANGEMELDET
prompt =========================================
prompt
create or replace procedure get_klausur_angemeldet(in_klausur_nr in number,
out_angemeldet out number)
as
v_matrikelnr studentische_person.matrikelnr%type;
v_klausurnr anmeldung.klausurnr%type;

begin
	begin
	select matrikelnr into v_matrikelnr
	from studentische_person
	where unix_name=user;
	exception
	when no_data_found then
        raise_application_error(-20008,'Es gibt keinen Studierenden mit dieser Kennung!');
	end;

	begin
	select klausurnr into v_klausurnr
	from anmeldung
	where matrikelnr=v_matrikelnr and klausurnr=in_klausur_nr;
	out_angemeldet:=1;
	exception
	when no_data_found then
        out_angemeldet:=0;
	end;
exception
when others then
        raise_application_error(-20010,'proc get_klausur_angemeldet: '|| substr(SQLERRM,1,80));
end;
/

prompt
prompt Creating procedure GET_KLAUSUR_FACH_INFO
prompt ========================================
prompt
CREATE OR REPLACE PROCEDURE Get_Klausur_Fach_Info (in_klausurnr IN NUMBER,
out_fachbezeichnung OUT VARCHAR2)
AS
v_fachnr FACH.fachnr%TYPE;
BEGIN
	begin
	SELECT DISTINCT fachnr INTO v_fachnr
	FROM KLAUS_BEZIE_ANGEBO
	WHERE klausurnr=in_klausurnr;
	exception
	when no_data_found then
        raise_application_error(-20011,'Es gibt keinen Eintrag in KLAUS_BEZIE_ANGEBO zu dieser Klausur!');
	end;

	begin
	SELECT bezeichnung INTO out_fachbezeichnung
	FROM FACH
	WHERE fachnr=v_fachnr;
	exception
	when no_data_found then
        raise_application_error(-20011,'Es gibt keinen Eintrag in KLAUS_BEZIE_ANGEBO zu dieser Klausur!');
	end;

EXCEPTION
WHEN OTHERS THEN
        raise_application_error(-20010,'proc get_klausur_info: '|| substr(SQLERRM,1,80));
END;
/

prompt
prompt Creating procedure GET_STUDENTEN_INFO
prompt =====================================
prompt
create or replace procedure get_studenten_info (unix_id in varchar2,
out_name out varchar2,
-- out_studienabschnitt out varchar2,
out_studiengang out varchar2,
out_fachbereich out varchar2,
out_matrikelnr out varchar2
)
as
v_studiengangnr studiengang.studiengangnr%type;
v_fachbereichsnr fachbereich.fachbereichnr%type;
begin
		begin
		select name,studiengangnr,matrikelnr
		  into out_name, v_studiengangnr ,out_matrikelnr
		  from studentische_person
		  where unix_name=unix_id;
	      exception
			when no_data_found then
				raise_application_error(-20011,'Es gibt keinen Studierenden mit dieser Kennung!');
		end;

		begin
		select bezeichnung,fachbereichnr
		  into out_studiengang,v_fachbereichsnr
		  from studiengang
		  where studiengangnr=v_studiengangnr;
		EXCEPTION
		  WHEN no_data_found THEN
             raise_application_error(-20015,'Den Studiengang '||v_studiengangnr||' gibt es nicht!');
		end;

		begin
		select bezeichnung
		  into out_fachbereich
		  from fachbereich
		  where fachbereichnr=v_fachbereichsnr;
		  EXCEPTION
		  	WHEN no_data_found THEN
        	raise_application_error(-20016,'Den Fachbereich '||v_fachbereichsnr||' gibt es nicht!');
		end;

EXCEPTION
WHEN OTHERS THEN
        raise_application_error(-20010,'proc get_studenten_info: '|| substr(SQLERRM,1,80));
end;
/

prompt
prompt Creating procedure PUT_ANMELD_KLAUSUR
prompt =====================================
prompt
create or replace procedure put_anmeld_klausur(klausur_nr_in in number)
as
v_matrikelnr studentische_person.matrikelnr%type;
v_klausurnr klausuranmeldung.klausurnr%type;

begin
		begin
		select matrikelnr into v_matrikelnr
		from studentische_person
		where unix_name=user for update;
		exception
			when no_data_found then
        	raise_application_error(-20003,'Es gibt keinen Studierenden mit dieser Kennung!');
		end;

		begin
		select klausurnr into v_klausurnr
		from klausuranmeldung
		where klausurnr=klausur_nr_in for update;
		exception
			when no_data_found then
        	raise_application_error(-20003,'Es gibt keine Klausuranmeldung fuer diesen Studenten!');
		end;

insert into anmeldung(matrikelnr,klausurnr,note)
 values(v_matrikelnr, klausur_nr_in,null);

exception
when others then
        raise_application_error(-20031,'proc put_anmeld_klausur: '|| substr(SQLERRM,1,80));
end;
/

prompt
prompt Creating trigger ANMELDUNG_D
prompt ============================
prompt
CREATE OR REPLACE TRIGGER anmeldung_d
AFTER DELETE
ON ANMELDUNG
FOR EACH ROW
DECLARE
v_matrikelnr studentische_person.matrikelnr%TYPE;
v_fachnr FACH.fachnr%TYPE;
v_anzahl_versuche LEISTUNGSSCHEIN.anzahl_versuche%TYPE :=-1;
v_err_msg VARCHAR2(200);
v_klausurdatum DATE;

BEGIN

SELECT DATUM INTO v_klausurdatum
FROM KLAUSUR
WHERE KLAUSURNR = :OLD.KLAUSURNR for update;

IF v_klausurdatum < SYSDATE + 14 THEN
   RAISE_APPLICATION_ERROR(-20050,'Abmeldung jetzt nicht mehr moeglich!');
END IF;

BEGIN
    SELECT DISTINCT fachnr INTO v_fachnr
    FROM KLAUS_BEZIE_ANGEBO
    WHERE klausurnr=:OLD.klausurnr;
    EXCEPTION
 WHEN OTHERS THEN
 v_err_msg:='Trigger:ANMELDUNG_D: '||SUBSTR(SQLERRM,1,80);
  RAISE_APPLICATION_ERROR(-20020,v_err_msg);
END;

begin
SELECT anzahl_versuche INTO v_anzahl_versuche
FROM LEISTUNGSSCHEIN
WHERE matrikelnr=:OLD.matrikelnr AND fachnr=v_fachnr;
EXCEPTION
 WHEN no_data_found THEN
  RAISE_APPLICATION_ERROR(-20020,'Kein Leistungsschein gefunden zu '||:OLD.matrikelnr||','||v_fachnr);
end;

IF v_anzahl_versuche = 1 THEN
   DELETE FROM LEISTUNGSSCHEIN
   WHERE matrikelnr=:OLD.matrikelnr AND fachnr=v_fachnr;
ELSE
   UPDATE LEISTUNGSSCHEIN
   SET anzahl_versuche = anzahl_versuche -1
   WHERE matrikelnr=:OLD.matrikelnr AND fachnr=v_fachnr;
END IF;

EXCEPTION
WHEN OTHERS THEN
  v_err_msg:='Trigger:ANMELDUNG_D: '||SUBSTR(SQLERRM,1,80);
   RAISE_APPLICATION_ERROR(-20020,v_err_msg);
END;
/

prompt
prompt Creating trigger ANMELDUNG_I
prompt ============================
prompt
create or replace trigger anmeldung_i
before insert on anmeldung
for each row
DECLARE
   V_FACHNR          FACH.FACHNR%TYPE;
   V_ANZAHL_VERSUCHE LEISTUNGSSCHEIN.ANZAHL_VERSUCHE%TYPE := -1;
   V_ERR_MSG         VARCHAR2(4000);
BEGIN

   IF NOT ANMELDUNG_ZULAESSIG(:NEW.MATRIKELNR, :NEW.KLAUSURNR) THEN
      RAISE_APPLICATION_ERROR(-20040,
                              'Anmeldung nicht kompatibel fuer Studierenden!');
   END IF;

   BEGIN
      SELECT DISTINCT FACHNR
        INTO V_FACHNR
        FROM KLAUS_BEZIE_ANGEBO
       WHERE KLAUSURNR = :NEW.KLAUSURNR;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20010, 'Kein Fach zur Klausur!');
   END;

   SELECT ANZAHL_VERSUCHE
     INTO V_ANZAHL_VERSUCHE
     FROM LEISTUNGSSCHEIN
    WHERE MATRIKELNR = :NEW.MATRIKELNR
      AND FACHNR = V_FACHNR
      FOR UPDATE;

   UPDATE LEISTUNGSSCHEIN
      SET ANZAHL_VERSUCHE = ANZAHL_VERSUCHE + 1
    WHERE MATRIKELNR = :NEW.MATRIKELNR
      AND FACHNR = V_FACHNR;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
      INSERT INTO LEISTUNGSSCHEIN
      VALUES
         (:NEW.MATRIKELNR, V_FACHNR, NULL, 1);
   WHEN OTHERS THEN
      V_ERR_MSG := 'Trigger:ANMELDUNG_I: ' || SUBSTR(SQLERRM, 1, 80);
      RAISE_APPLICATION_ERROR(-20020, V_ERR_MSG);
END;
/

prompt
prompt Creating trigger KLAUS_BEZIE_ANGEBO_IU
prompt ======================================
prompt
create or replace trigger klaus_bezie_angebo_iu
before insert or update on klaus_bezie_angebo
for each row
declare
testfeld char(1) :='';
begin
  select 'x' into testfeld
  from dual
  where not exists
  (select 'x' from
  klaus_bezie_angebo
  where klausurnr=:new.klausurnr
  and fachnr!=:new.fachnr);
exception
when others then
 raise_application_error(-20001,'Klausur darf sich nur auf ein Fach beziehen !');
end;
/

prompt
prompt Creating trigger KLAUSUR_I
prompt ==========================
prompt
CREATE OR REPLACE TRIGGER klausur_i
BEFORE INSERT OR UPDATE OF klausurnr ON KLAUSUR
FOR EACH ROW
DECLARE
v_klausurnr KLAUSUR.KLAUSURNR%TYPE;
v_err_msg VARCHAR2(200);
BEGIN
  SELECT DISTINCT klausurnr INTO v_klausurnr
  FROM KLAUS_BEZIE_ANGEBO
  WHERE klausurnr=:NEW.klausurnr;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20100,'Klausur ist noch keinem Angebot zugeordnet');
WHEN OTHERS THEN
 v_err_msg:='Trigger:ANMELDUNG_I: '||SUBSTR(SQLERRM,1,80);
  RAISE_APPLICATION_ERROR(-20020,v_err_msg);
END;
/

prompt
prompt Creating table DEPT
prompt ===================
prompt

CREATE TABLE DEPT
       (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14) ,
	LOC VARCHAR2(13) ) ;

prompt
prompt Creating table EMP
prompt ==================
prompt

CREATE TABLE EMP
       (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2),
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);


prompt
prompt loading DEPT...

INSERT INTO DEPT VALUES
	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES
	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES
	(40,'OPERATIONS','BOSTON');
COMMIT;

prompt 4 records loaded
prompt loading EMP....

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',7566,to_date('13-7-1987','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',7788,to_date('13-7-87', 'dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);
COMMIT;

prompt 14 records loaded
prompt
prompt Creating table BONUS
prompt ====================
prompt

CREATE TABLE BONUS
	(
	ENAME VARCHAR2(10)	,
	JOB VARCHAR2(9)  ,
	SAL NUMBER,
	COMM NUMBER
	) ;


prompt
prompt Creating table SALGRADE
prompt =======================
prompt

CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );

prompt loading SALGRADE...

INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);
COMMIT;
prompt 5 records loaded

set feedback on
set define on
prompt Done.
spool off
