----@Author:Elias Posluk
----Student-ID:h16elipo
----@Date: 2020-05-10
----Assignment 5
----Course: GIK23M
----Dalarna University

---------uppgift 5
-----------------------------------bankkund
create table bankkund(
pnr varchar2(11) not null,
fnamn varchar2(25) not null,
enamn varchar2(25) not null,
passwd varchar2(16) not null);

alter table bankkund
add constraint bkund_pnr_pk primary key(pnr)
add constraint bkund_passwd_uq unique(passwd);
-----------------------------------kontotyp
create table kontotyp(
ktnr number(6) not null,
ktnamn varchar2(20) not null,
ränta number(5,2) not null);

alter table kontotyp
add constraint kontotyp_ktnr_pk primary key(ktnr);
-----------------------------------ränteändring
create table ränteändring(
rnr number(6) not null,
ktnr number(6) not null,
ränta number(5,2) not null,
rnr_datum date not null);

alter table ränteändring
add constraint ränteändring_rnr_pk primary key(rnr)
add constraint ränteändring_ktnr_fk foreign key(ktnr) references kontotyp(ktnr);
----------------------------------konto
create table konto(
knr number(8) not null,
ktnr number(6) not null,
regdatum date not null,
saldo number(10,2));

alter table konto
add constraint konto_knr_pk primary key(knr)
add constraint konto_ktnr_fk foreign key(ktnr) references kontotyp(ktnr);

------------------------------------------------- kontoägare
create table kontoägare(
kontoägare_radnr number(9) not null,
pnr varchar2(11) not null,
knr number(8) not null);

alter table kontoägare
add constraint kontoägare_radnr_pk primary key(kontoägare_radnr)
add constraint kontoägare_pnr_fk foreign key(pnr) references bankkund(pnr)
add constraint kontoägare_knr_fk foreign key(knr) references konto(knr);
-------------------------------------------------- uttag
create table uttag(
uttag_radnr number(9) not null,
pnr varchar2(11) not null,
knr number(8) not null,
belopp number(10,2),
datum date not null);

alter table uttag 
add constraint uttag_radnr_pk primary key(uttag_radnr) 
add constraint uttag_pnr_fk foreign key(pnr) references bankkund(pnr)
add constraint uttag_knr_fk foreign key(knr) references konto(knr);
------------------------------------------------------ insättning
create table insättning(
insättning_radnr number(9) not null,
pnr varchar2(11) not null,
knr number(8) not null,
belopp number(10,2),
datum date not null);

alter table insättning
add constraint insättning_radnr_pk primary key(insättning_radnr)
add constraint insättning_pnr_fk foreign key(pnr) references bankkund(pnr)
add constraint insättning_knr_fk foreign key(knr) references konto(knr);
------------------------------------------------------- överföring
create table överföring(
överföring_radnr number(9) not null,
pnr varchar2(11) not null,
från_knr number(8) not null,
till_knr number(8) not null,
belopp number(10,2),
datum date not null);

alter table överföring
add constraint överföring_radnr_pk primary key(överföring_radnr)
add constraint överföring_pnr_fk foreign key(pnr) references bankkund(pnr)
add constraint överföring_från_knr_fk foreign key(från_knr) references konto(knr)
add constraint överföring_till_knr_fk foreign key(till_knr) references konto(knr);

--Uppgift 3
--Skapa en trigger med namnet biufer_bankkund 

create or replace trigger biufer_bankkund
before insert or update of passwd
on bankkund
for each row
when(length(new.passwd) != 6)
begin
 raise_application_error(-20001,'Lösenordet får bara vara 6 tecken lång!');
end;

--Uppgift 4
--Skapa en procedur med namnet do_bankkund. 

create or replace procedure do_bankkund(
p_pnr in bankkund.pnr%type,
p_fnamn in bankkund.fnamn%type,
p_enamn in bankkund.enamn%type, 
p_passwd in bankkund.passwd%type)
as

begin

    insert into bankkund(pnr, fnamn, enamn, passwd)
                values(p_pnr, p_fnamn, p_enamn, p_passwd);
commit;

end;

--Insert Data
--Insert into Kontotyp
INSERT INTO kontotyp(ktnr,ktnamn,ränta)
VALUES(1,'bondkonto',3.4);
INSERT INTO kontotyp(ktnr,ktnamn,ränta)
VALUES(2,'potatiskonto',4.4);
INSERT INTO kontotyp(ktnr,ktnamn,ränta)
VALUES(3,'griskonto',2.4);
COMMIT;

--Insert into Konto
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(123,1,SYSDATE - 321,0);
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(5899,2,SYSDATE - 2546,0);
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(5587,3,SYSDATE - 10,0);
INSERT INTO konto(knr,ktnr,regdatum,saldo)
VALUES(8896,1,SYSDATE - 45,0);
COMMIT;

--Insert into kontoägare
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'540126-1111',123);
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'691124-4478',123);
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'540126-1111',5899);
INSERT INTO kontoägare(radnr,pnr,knr)
VALUES(radnr_seq.NEXTVAL,'691124-4478',8896);
COMMIT;
--Insert end

--Uppgift 5
--Triggertest  =   
EXEC do_bankkund('691124-4478','Leena','Kvist','qwe');

--Uppgift 6
--Börja med att skapa en sekvens med namnet radnr_seq. 

create sequence radnr_seq start with 1 increment by 1;

--Uppgift 7
/*
Skapa en funktion med namnet logga_in. 
Denna skall returnera 1 eller 0 beroende av hur det gick. 
Inloggning sker med att en bankund lämnar sitt personnummer och lösenord, 
dvs kolumnerna pnr och passwd i tabellen bankkund. 
Testa att funktionen fungerar genom att göra:
*/
create or replace function logga_in(p_pnr in varchar2, p_passwd in varchar2)
return varchar2
as
 antalTraffar number;
begin
  select count(*)
    into antalTraffar
    from bankkund
    where pnr = p_pnr
    and passwd = p_passwd;
  if antalTraffar = 0 then
    return '0';
  elsif antalTraffar = 1 then
    return '1';
  end if;
end;

--Uppgift 8
--Skapa en funktion med namnet get_saldo

create or replace function get_saldo(konto_id konto.knr%type)
return number
as
  konto_finns number := 0;
  nuvarande_balans konto.knr%type;
begin
  nuvarande_balans := 0;
  select count(*) 
  into konto_finns 
  from konto 
  where knr = konto_id;
  if konto_finns > 0
  then
      select saldo 
      into nuvarande_balans
      from konto
      where knr = konto_id;
      return nuvarande_balans;
  else
      konto_finns := -1;
      return konto_finns;
  end if;
end;


--Uppgift 9
--Skapa en funktion med namnet get_behörighet
create or replace function get_behörighet(
p_pnr kontoägare.pnr%type,
p_knr kontoägare.knr%type)
return number
as
konto_id   kontoägare.knr%type;
begin
    select max(kä.knr)
    into konto_id
    from kontoägare kä
    where kä.pnr = p_pnr
    and kä.knr  = p_knr;
    
      	return case when konto_id is not null then 1
              else 0
      	end;
end;

--Uppgift 10
--Skapa en trigger med namnet aifer_insättning. 
create or replace trigger aifer_insättning
after insert
   on insättning
   for each row

declare
    gammal_saldo number(10,2);
    ny_saldo number(10,2);
begin
    select saldo into gammal_saldo from konto where knr = :NEW.knr;

    update konto set saldo = saldo + :NEW.belopp where knr = :NEW.knr;
   
    select saldo into ny_saldo from konto where knr = :NEW.knr;
   
    if ny_saldo - gammal_saldo != :NEW.belopp
    then
      raise_application_error(-20001,'Det angivna beloppet är mer än tillgängligt saldo');
    end if;
end;


--Uppgift 11
--Skapa en trigger med namnet bifer_uttag
create or replace trigger bifer_uttag
before insert
   on uttag
   for each row
declare
    tillgänglig_saldo number(10,2); 
begin
    select get_saldo(:NEW.knr) into tillgänglig_saldo from dual; 
    
    if tillgänglig_saldo > -1
    then
      if :NEW.belopp > tillgänglig_saldo
      then
        raise_application_error(-20001,'Du kan inte ta ut ett belopp mer än det tillgängliga saldot');
      end if;
    else
       raise_application_error(-20001,'Det angivna konto-ID är inte tillgängligt i systemet');
    end if;
end;

--Uppgift 12
--Skapa en trigger med namnet aifer_uttag. 

create or replace trigger aifer_uttag
after insert
   on uttag
   for each row 
declare
   tillgänglig_saldo number(10,2);
begin
  select saldo into tillgänglig_saldo from konto where knr = :new.knr; 
   
   if tillgänglig_saldo >= :new.belopp
   then
     update konto
     set saldo = saldo - :NEW.belopp
     where knr = :new.knr;
   else
     raise_application_error(-20001,'Det angivna beloppet är mer än tillgängligt saldo');
   end if;
end;

--Uppgift 13
--Skapa ytterligare en trigger. Denna gång med namnet bifer_överföring. 

create or replace trigger bifer_överföring
before insert
   on överföring
   for each row
declare
    tillgänglig_saldo number(10,2);   
begin
    select get_saldo(:NEW.från_knr) into tillgänglig_saldo from dual; 
    
    if tillgänglig_saldo > -1
    then
      if :NEW.belopp > tillgänglig_saldo
      then
        raise_application_error(-20001,'Du kan inte ta ut mer pengar än det finns tillgängligt på kontot som du flyttar pengar från');
      end if;
    else
       raise_application_error(-20001,'Det angivna konto-ID är inte tillgängligt i systemet');
    end if;
end;  

--Uppgift 14
--Skapa nu den sista triggern i denna labb. Triggern skall ha namnet aifer_överföring. 

create or replace trigger aifer_överföring
after insert
   on överföring
   for each row 
declare
   tillgänglig_saldo number(10,2); 
begin
  select saldo into tillgänglig_saldo from konto where knr = :NEW.från_knr;

  if tillgänglig_saldo >= :NEW.belopp
  then
    update konto set saldo = saldo - :NEW.belopp
    where knr = :NEW.från_knr;
    
    update konto set saldo = saldo + :NEW.belopp
    where knr = :NEW.till_knr;
  else
     raise_application_error(-20001,'Det angivna beloppet är mer än tillgängligt saldo');  
  end if;
end;


--Uppgift 15
--Skapa en procedur med namnet do_insättning. 

create or replace procedure do_insättning
as
  ny_id insättning.insättning_radnr%type;
  kund_id bankkund.pnr%type;
  konto_id konto.knr%type;
  insättning_belopp insättning.belopp%type;
  insättning_datum insättning.datum%type;
  ny_saldo konto.saldo%type;
  
begin
  kund_id := '691124-4478'; konto_id := 123; insättning_belopp := 100000; insättning_datum := SYSDATE;

  select nvl((max(insättning_radnr)+1),1) into ny_id from insättning;

  insert into insättning (insättning_radnr, pnr, knr, belopp,datum)
  values(ny_id, kund_id, konto_id, insättning_belopp, insättning_datum);
  
  select saldo into ny_saldo from konto where knr = konto_id;
  
  dbms_output.put_line('Nya beloppet för konto-id ' || konto_id || ' är: ' || ny_saldo); 
end; 

--Uppgift 16
--Testa att proceduren do_insättning fungerar.

--Alla konton är nollade
select *
from konto;

--Sätter in pengar
begin 
do_insättning;
end;

--Första kontot med KTNR får insättning in i kontot
--Se dokumentet.
select *
from konto;


--Uppgift 17
--Skapa en procedur som heter do_uttag. 

create or replace procedure do_uttag
as
  verifierad integer;
  ny_id uttag.uttag_radnr%type;
  kund_id bankkund.pnr%type;
  konto_id konto.knr%type;
  uttag_belopp uttag.belopp%type;
  uttag_datum uttag.datum%type;
  ny_saldo konto.saldo%type;
  
  obehörig exception;

begin
kund_id := '691124-4478'; konto_id := 123; uttag_belopp := 100000; uttag_datum := SYSDATE;

  select get_behörighet('691124-4478',123) into verifierad from dual;

  if(verifierad = 1)
  then
  select nvl((max(uttag_radnr)+1),1) into ny_id from uttag;
  
  insert into uttag (uttag_radnr, pnr, knr, belopp,datum)
  values(ny_id, kund_id, konto_id, uttag_belopp, uttag_datum);
  
  select saldo INTO ny_saldo from konto where knr = 123;
  dbms_output.put_line('Den nya saldot för konto-id ' || konto_id || ' är: ' || ny_saldo);
  
  else
    raise obehörig;
  end if;
  
  exception
   when obehörig
   then raise_application_error(-20000, 'Obehörig användare!');
  
end;

--Uppgift 18
--Se dokumentet.

--Uppgift 19
--Skapa labbens sista objekt som är en procedur med namnet do_överföring. 

create or replace procedure do_överföring
as
  verifierad integer := 0;
  ny_id överföring.överföring_radnr%type;
  kund_id bankkund.pnr%type;
  avsändare_konto_knr konto.knr%type;
  mottagare_konto_knr konto.knr%type;
  överföring_belopp överföring.belopp%type;
  överföring_datum överföring.datum%type;
  avsändare_saldo konto.saldo%type;
  mottagare_saldo konto.saldo%type;
  
  obehörig exception;

begin
  kund_id := '691124-4478'; avsändare_konto_knr := 123; mottagare_konto_knr := 5899; överföring_belopp := 155; överföring_datum := SYSDATE;

  select get_behörighet(kund_id,avsändare_konto_knr) into verifierad from dual;

  if(verifierad = 1)
  then
  select nvl((max(överföring_radnr)+1),1) into ny_id from överföring;
  
  insert into överföring(överföring_radnr, pnr, från_knr, till_knr, belopp, datum)
  values(ny_id, kund_id, avsändare_konto_knr, mottagare_konto_knr, överföring_belopp, överföring_datum);
  
  select saldo into avsändare_saldo from konto where knr = avsändare_konto_knr;
  select saldo into mottagare_saldo from konto where knr = mottagare_konto_knr;
  
  dbms_output.put_line('Den nya saldot för avsändaren med konto-id ' || avsändare_konto_knr || ' är : '|| avsändare_saldo); 
  dbms_output.put_line('Den nya saldot för mottagaren med konto-id ' || mottagare_konto_knr || ' är : '|| mottagare_saldo); 
  
  else
    raise obehörig;
  end if;
 
  exception
   when obehörig
   then raise_application_error(-20000, 'Obehörig användare!'); 
end;

--Uppgift 20
--Se dokumentet.
