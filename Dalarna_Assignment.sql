----@Author:Elias Posluk
----Student-ID:h16elipo
----@Date: 2020-05-11
----Assignment 
----Course: GIK23M
----Dalarna University

-- sequence for 
create sequence pk_seq start with 1 increment by 1; 
-----------------------------------customer
create table customer(
CUST_ID varchar2(11) not null,
FIRST_NAME varchar2(25) not null,
LAST_NAME varchar2(25) not null,
PASSWD varchar2(16) not null);

alter table customer
add constraint customer_CUST_ID_pk primary key(CUST_ID)
add constraint customer_PASSWD_uq unique(PASSWD);



-----------------------------------account_type
create table account_type(
ACCTY_ID number(6) not null,
ACCTY_NAME varchar2(20) not null,
present_interest number(5,2) not null);

alter table account_type
add constraint accountType_ACCTY_ID_pk primary key(ACCTY_ID);

-----------------------------------interest_change
create table interest_change(
INTCH_ID number(6) not null,
ACCTY_ID number(6) not null, 
INTEREST number(5,2) not null,
DATE_TIME date not null);


alter table interest_change
add constraint interest_change_INTCH_ID_pk primary key(INTCH_ID)
add constraint interest_change_ACCTY_ID_fk foreign key(ACCTY_ID) references account_type(ACCTY_ID);
----------------------------------account
create table account(
ACC_ID number(8) not null,
ACCTY_ID number(6) not null,
DATE_TIME date not null,
BALANCE number(10,2));

alter table account
add constraint account_ACC_ID_pk primary key(ACC_ID)
add constraint account_ACCTY_ID_fk foreign key(ACCTY_ID) references account_type(ACCTY_ID);

------------------------------------------------- account_owner
create table account_owner(
accow_id number(9) not null,
cust_id varchar2(11) not null,
acc_id number(8) not null);

alter table account_owner
add constraint account_owner_ACCOW_ID_pk primary key(ACCOW_ID)
add constraint account_owner_CUST_ID_fk foreign key(CUST_ID) references customer(CUST_ID)
add constraint account_owner_ACC_ID_fk foreign key(ACC_ID) references account(ACC_ID);

-------------------------------------------------- withdrawal
create table withdrawal(
WIT_ID number(9) not null,
CUST_ID varchar2(11) not null,
ACC_ID number(8) not null,
AMOUNT number(10,2),
DATE_TIME date not null);

alter table withdrawal 
add constraint withdrawal_WIT_ID_pk primary key(WIT_ID)
add constraint withdrawal_CUST_ID_fk foreign key(CUST_ID) references customer(CUST_ID)
add constraint withdrawal_ACC_ID_fk foreign key(ACC_ID) references account(ACC_ID);

------------------------------------------------------------------------ deposition
create table deposition(
DEP_ID number(9) not null,
CUST_ID varchar2(11) not null,
ACC_ID number(8) not null,
AMOUNT number(10,2),
DATE_TIME date not null);

alter table deposition
add constraint deposition_DEP_ID_pk primary key(DEP_ID)
add constraint deposition_CUST_ID_fk foreign key(CUST_ID) references customer(CUST_ID)
add constraint deposition_ACC_ID_fk foreign key(ACC_ID) references account(ACC_ID);

-------------------------------------------------------------------------- transfer
create table transfer(
TRA_ID number(9) not null,
CUST_ID varchar2(11) not null,
FROM_ACC_ID number(8) not null,
TO_ACC_ID number(8) not null,
AMOUNT number(10,2),
DATE_TIME date not null);

alter table transfer
add constraint transfer_TRA_ID_pk primary key(TRA_ID)
add constraint transfer_CUST_ID_fk foreign key(CUST_ID) references customer(CUST_ID)
add constraint transfer_FROM_ACC_ID_fk foreign key(FROM_ACC_ID) references account(ACC_ID)
add constraint transfer_TO_ACC_ID_fk foreign key(TO_ACC_ID) references account(ACC_ID);

commit;

----------------------------------------------------------------------------- create customers with accounts

create or replace procedure do_new_customer(
p_CUST_ID in customer.CUST_ID%type,
p_FIRST_NAME in customer.FIRST_NAME%type,
p_LAST_NAME in customer.LAST_NAME%type, 
p_PASSWD in customer.PASSWD%type)
as

begin

    insert into customer(CUST_ID, FIRST_NAME, LAST_NAME, PASSWD)
                values(p_CUST_ID, p_FIRST_NAME, p_LAST_NAME, p_PASSWD);
commit;

end;

-----------------putting in customers
BEGIN
do_new_customer('650707-1111','Tito','Ortiz','qwerTY');
do_new_customer('560126-1148','Margreth','Andersson','olle85');
do_new_customer('840317-1457','Mary','Smith','asdfgh');
do_new_customer('861124-4478','Vincent','Ortiz','qwe123');
COMMIT;
END;
/
---------------------

--------------------------giving accounts to customers
INSERT INTO account_type(accty_id,accty_name,present_interest)
VALUES(1,'farmer account',2.4);
INSERT INTO account_type (accty_id,accty_name,present_interest)
VALUES(2,'potato account',3.4);
INSERT INTO account_type (accty_id,accty_name,present_interest)
VALUES(3,'hog account',4.4);
COMMIT;

INSERT INTO account(acc_id,accty_id,date_time,balance)
VALUES(123,1,SYSDATE - 321,500);
INSERT INTO account(acc_id,accty_id,date_time,balance)
VALUES(5899,2,SYSDATE - 2546,200);
INSERT INTO account(acc_id,accty_id,date_time,balance)
VALUES(5587,3,SYSDATE - 10,399);
INSERT INTO account(acc_id,accty_id,date_time,balance)
VALUES(8896,1,SYSDATE - 45,0);
COMMIT;


INSERT INTO account_owner(accow_id,cust_id,acc_id)
VALUES(pk_seq.NEXTVAL,'650707-1111',123);
INSERT INTO account_owner(accow_id,cust_id,acc_id)
VALUES(pk_seq.NEXTVAL,'560126-1148',123);
INSERT INTO account_owner(accow_id,cust_id,acc_id)
VALUES(pk_seq.NEXTVAL,'650707-1111',5899);
INSERT INTO account_owner(accow_id,cust_id,acc_id)
VALUES(pk_seq.NEXTVAL,'861124-4478',8896);
COMMIT;
----------------------------------------------------------------------- see that the sequence works and correct information prints out.
select * 
from account_owner;
-----------------------------------------------------------------------
----------------------Creating log in function


create or replace function log_in(p_CUST_ID in varchar2, p_PASSWD in varchar2)
return varchar2
as
  match_count number;
begin
  select count(*)
    into match_count
    from customer
    where CUST_ID = p_CUST_ID
    and passwd = p_PASSWD;
  if match_count = 0 then
    return '0';
  elsif match_count = 1 then
    return '1';
  else
    return 'Too many matches, this should never happen!';
  end if;
end;
/
-------------------------------------
SELECT log_in('560126-1148','olle85') -- with 560126-1148 and olle85, you should get 1 as true, otherwise 0 as false and therefore not able to log in. 
FROM dual;

--------------------------------------

create or replace function get_authorityy(
p_cust_id account_owner.cust_id%type,
p_acc_id account_owner.acc_id%type)
return number

as 

account_id   account_owner.accow_id%type;

begin

    select max(o.accow_id)
    into account_id
    from account_owner o
    where o.cust_id = p_cust_id
    and o.acc_id  = p_acc_id;
    
    return case when account_id is not null then 1
                     else 0
        end;
        
end;

select get_authorityy('650707-1111', 123) res_1,
 
          get_authorityy('861124-4478', 5899) res_4
        from dual;
        
select get_authorityy('650707-1111', 123) res_1,
        get_authorityy('861124-4478', 5899) res_2
        from dual;
        
----------------
create or replace function get_balance(p_acc_id in number)
return number
as
v_balance account.balance%type;
begin
select balance 
into v_balance
from account
where acc_id = p_acc_id;
return v_balance;
end;
/

create or replace 
trigger bifer_withdrawal ---------trigger
before insert on withdrawal 
for each row 
begin
   if get_balance(:NEW.acc_id) <= :NEW.amount
   then
      raise_application_error(-20001, 'Not enough money in account!');
   end if;
end; 
/

select get_balance(123) Balance
from dual;
------------------ 
create or replace trigger aifer_deposit
after insert
on deposition
for each row 
begin
update account
set BALANCE = BALANCE + :new.amount
where account.ACC_ID = :new.ACC_ID;
end;
--------------------------

CREATE OR REPLACE PROCEDURE aifer_withdrawal(account_no_in IN NUMBER,
                                             bal_in IN NUMBER)
IS
  current_balance number(20);
BEGIN
  select BALANCE
    into current_balance
    from account
    where ACC_ID = account_no_in;

  if current_balance < bal_in then
   dbms_output.put_line('The amount entered is more than the amount balance');
  else
    update account
      set BALANCE = bal_in - current_balance
      where ACC_ID = account_no_in;
      dbms_output.put_line('Money has been withdrawn successfully');
  end if; 
  
END;

exec aifer_withdrawal(5587, 200);

-------------------------------------------------

create or replace function get_balance(account_id account.acc_id%type)
return number
as
  account_exists number := 0;
  current_balance account.acc_id%type;
begin
  current_balance := 0;
  
  select count(*) into account_exists from account where acc_id = account_id;
  
  if account_exists > 0
  then
      select balance 
      into current_balance
      from account
      where acc_id = account_id;
      
      return current_balance;
  else
      account_exists := -1;
      return account_exists;
  end if;
end;

select get_balance(200) Balance
from dual;

--------------------

create or replace function get_authority(
p_cust_id account_owner.cust_id%type,
p_acc_id account_owner.acc_id%type)
return number
as
account_exists number := 0;
account_id account_owner.accow_id%type;

begin

	select count(*) 
	into account_exists 
	from account_owner 
	where cust_id = p_cust_id;
	
	if account_exists > 0
  then
	    select accow_id
	    into account_id
	    from account_owner
	    where cust_id = p_cust_id
	    and acc_id  = p_acc_id;
      
      	return case when account_id is not null then 1
              else 0
      	end;
	else
      account_exists := 0;
      return account_exists;
    end if;
        
end;

select get_authority('650707-1111', 123) res_1,
        get_authority('560126-11348', 123) res_3,
        get_authority('650707-1111', 5899) res_2,
          get_authority('861124-4478',8896) res_4
        from dual;