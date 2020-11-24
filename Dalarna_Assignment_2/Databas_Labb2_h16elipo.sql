----@Author:Elias Posluk
----Student-ID:h16elipo
----@Date: 2020-02-10
----Assignment 2
----Course: GIK23M
----Dalarna University

--Tabeller
CREATE TABLE kund(
username VARCHAR2(8) PRIMARY KEY,
passwd VARCHAR2(8) NOT NULL,
fnamn VARCHAR2(20) NOT NULL,
enamn VARCHAR2(20) NOT NULL,
yrke VARCHAR2(20),
regdatum DATE NOT NULL,
årslön NUMBER(7));

----------Insert Data-----------

INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MrBig','MBisKING','Roger','nyberg','Officer',TO_DATE('1998-NOV-29','YYYY-MON-DD'),317000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MEZcal','P33kssa','maria','Nyberg','psykolog',TO_DATE('1999-08-29','YYYY-MM-DD'),435000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('KLÖven','bintje','Tomas','kvist','Potatisbonde',TO_DATE('2000-02-28','YYYY-MM-DD'),198000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('OlleBull','Bullas','hans','Lindqvist',NULL,TO_DATE('2002-05-05','YYYY-MM-DD'),116000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('MrMDI','MDIisit','Hans','Rosenboll','adjunkt',TO_DATE('1997-01-15','YYYY-MM-DD'),307000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('King25','asdf1234','charlotte','Ortiz','tandläkare',TO_DATE('2003-12-10','YYYY-MM-DD'),586000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('h01hanro','T56xxL','Sven','Larsson',NULL,TO_DATE('2003-08-09','YYYY-MM-DD'),NULL);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('XXXL','IRule','Margareta','ek','VD',TO_DATE('2001-06-29','YYYY-MM-DD'),942000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('Rolven','revolver','roger','nyberg',NULL,TO_DATE('1998-10-29','YYYY-MM-DD'),240000);
INSERT INTO kund(username,passwd,fnamn,enamn,yrke,regdatum,årslön)
VALUES('IceMan','Quantos','Maria','Nyberg','Ingenjör',TO_DATE('1998-02-14','YYYY-MM-DD'),412000);
COMMIT;

--Uppgift 1
--Visa all data om alla kunder i tabellen, sortera på enamn stigande (a-ö).

select username, passwd, fnamn, enamn, yrke, regdatum, årslön
from kund
order by enamn asc;

--Uppgift 2
--Visa all data om alla kunder i tabellen, sortera på enamn fallande (ö-a).
select username, passwd, fnamn, enamn, yrke, regdatum, årslön
from kund
order by enamn desc;

--Uppgift 3
--Visa hur många kunder som finns lagrade i tabellen (antalet rader). 
--Rätt svar = 10

select count(username)
from kund;

--Uppgift 4
--Visa hur många kunder som har en årsinkomst som är större än 300 000 SEK.
--Rätt svar = 6
select count(username)
from kund
where årslön > 300000;

--Uppgift 5
--Visa hur många kunder som har en årsinkomst som är mindre än 300 000 SEK.
--Rätt svar = 3 
select count(username)
from kund
where årslön < 300000;

--Uppgift 6
--Visa medelön för alla kunder i tabellen. Kolumnrubriken skall vara: Medellön 
select avg(nvl(årslön, 0)) medellön
from kund;

--Uppgift 7
--Visa username, fnamn, enamn, årslön för de kunder som har en årslön som är mindre än medellönen för alla kunder. Rätt svar:

select username, fnamn, enamn, nvl(årslön,0)
from kund
where årslön < 355300;

--Uppgift 8
--Visa fnamn, enamn med VERSALER för de kunder som har ett 's' i efternamnet.

select upper(fnamn) as FNAMN, upper(enamn) as ENAMN
from kund 
where enamn like'%s%';

--Uppgift 9
--Visa fnamn, enamn och yrke med gemener för de kunder som har ett förnamn som slutar på 's'. 
--Om NULL finns i kolumnen yrke skall strängen 'arbetsfri' visas istället. 

select fnamn, enamn, nvl(yrke, 'arbetsfri') as yrke
from kund
where fnamn like '%s';

--Uppgift 10
--Visa yrke, samt antalet kunder i respektive yrkeskategori sorterat på yrke stigande (a-ö).
--Kolumnrubrikerna skall vara yrke och antal. Om NULL finns i klomnen yrke skall teckensträngen 'Arbetsfri' ersätta NULL-värdet.
--Yrke skall visas med stor begynnelsebokstav. Tips! Funktionen INITCAP().  
select nvl(INITCAP(yrke), 'Arbetsfri') as yrke, count(username) as antal
from kund
group by yrke
order by yrke asc;

--Uppgift 11
--Visa fnamn konkatenerat med ett blanksteg och enamn under rubriken KUNDNAMN. Namnen skall visas med stor begynnelsebokstav. 
--Konkatenering i Oracle sker med 'sträng1'||'sträng2'||'sträng3'..
select INITCAP(fnamn) || ' ' ||INITCAP(enamn) as kundnamn
from kund;


--Uppgift 12
--Visa antal kunder som har exakt ASCII-matchning av username = 'King25' och passwd = 'asdf1234' med rubriken inloggad.
select count(username) as inloggad
from kund
where initcap(username) = 'King25' and lower(passwd) = 'asdf1234';

--Uppgift 13
--Visa antal kunder som har exakt ASCII-matchning av username = 'KING25' och passwd = 'ASDF1234' med rubriken inloggad. 
--Du ska alltså inte använda upper eller lower funktionerna utan SQL-satsen ska göra skillnad på stora och små bokstäver. 
select count(username) as inloggad
from kund
where username = 'KING25' and passwd = 'ASDF1234';

--Uppgift 14
--Visa username och passwd för de kunder som registreade sig före år 2000.
select username, passwd, regdatum
from kund
where regdatum < TO_DATE('2000-01-01','YYYY-MM-DD');

--Uppgift 15
--Visa username och passwd för de kunder som registreade sig mellan
--den 1 januari 2001 och den 1 oktober 2003. 
select username, passwd, regdatum
from kund
where regdatum between TO_DATE('2001-01-01','YYYY-MM-DD') and TO_DATE('2003-10-01','YYYY-MM-DD');

--Uppgift 16
--Visa username, passwd, fnamn, enamn för de kunder som heter 'nyberg' eller 'kvist' i efternamn men som inte heter 'roger' i förnamn. 
select username, passwd, fnamn, enamn
from kund
where lower(enamn) in ('nyberg','kvist') and not lower(fnamn) in ('roger');

--Uppgift 17
--Visa fnamn, enamn, årslön för den kund som har den högsta årslönen av alla kunder.
select fnamn, enamn, årslön
from kund
where årslön =(select max(årslön)
                            from kund);

--Uppgift 18
--Visa fnamn, enamn, årslön för den kund som har den lägsta årslönen av alla kunder. 
--Ta inte med de som har NULL i lön. 

select fnamn, enamn, nvl(årslön,0) årslön
from kund
where årslön =(select min(årslön)
                            from kund);
                            
--Uppgift 19
--Visa fnamn, enamn för de kunder som har NULL i kolumnen yrke. 
select fnamn, enamn
from kund
where yrke is NULL;


