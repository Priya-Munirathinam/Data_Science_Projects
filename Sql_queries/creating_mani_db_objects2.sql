/* -- create database
create database techmac_db;
use techmac_db;
-- create table
create table techhyve_employees( EmployeeID varchar(10) primary key, Firstname varchar(10) not null, Lastname varchar(10) not null, gender varchar(10) not null, age int unique);
create table techcloud_employees( EmployeeID varchar(10) primary key, Firstname varchar(10) not null, Lastname varchar(10) not null, gender varchar(10) not null, age int unique);
create table techsoft_employees( EmployeeID varchar(10) primary key, Firstname varchar(10) not null, Lastname varchar(10) not null, gender varchar(10) not null, age int unique);
-- insert values in techhyve table
insert into techhyve_employees values ('TH001', 'Eli', 'Evans', 'Male', 26);
insert into techhyve_employees values ('TH002', 'Carlos', 'Simmons', 'Male', 32);
insert into techhyve_employees values ('TH003', 'Kathie', 'Bryant', 'Female', 25);
insert into techhyve_employees values ('TH004', 'Joey', 'Hughes', 'Male', 41);
insert into techhyve_employees values ('TH005', 'Alice', 'Mathews', 'Female', 52);
-- insert intotechcloud
insert into techcloud_employees values ('TC001', 'Teresa', 'Bryant', 'Female', 39);
insert into techcloud_employees values ('TC002', 'Alexis', 'Patterson', 'Male', 48);
insert into techcloud_employees values ('TC003', 'Rose', 'Bell', 'Female', 42);
insert into techcloud_employees values ('TC004', 'Gemma', 'Watkins', 'Female', 44);
insert into techcloud_employees values ('TC005', 'Kingston', 'Martinez', 'Male', 29);
-- insert into techsoft
insert into techsoft_employees values ('TS001', 'Peter', 'Burtler', 'Male', 44);
insert into techsoft_employees values ('TS002', 'Harold', 'Simmons', 'Male', 54);
insert into techsoft_employees values ('TS003', 'Juliana', 'Sanders', 'Female', 36);
insert into techsoft_employees values ('TS004', 'Paul', 'Ward', 'Male', 29);
insert into techsoft_employees values ('TS005', 'Nicole', 'Bryant', 'Female', 30);*/
use techmac_db;
insert into techhyve_employees values ('TH003', 'Kathie', 'Bryant', 'Female', 25); -- inserting the values deleted in sprint1
insert into techhyve_employees values ('TH005', 'Alice', 'Mathews', 'Female', 52);
insert into techcloud_employees values ('TC001', 'Teresa', 'Bryant', 'Female', 39);
insert into techcloud_employees values ('TC004', 'Gemma', 'Watkins', 'Female', 44);

-- task 1a.
alter table techhyve_employees modify Firstname varchar(20) not null; -- add not null constraint
alter table techhyve_employees modify Lastname varchar(10) not null;
alter table techcloud_employees modify Firstname varchar(20) not null;
alter table techcloud_employees modify Lastname varchar(10) not null;
alter table techsoft_employees modify Firstname varchar(20) not null;
alter table techsoft_employees modify Lastname varchar(10) not null;
-- task 1b
alter table techhyve_employees modify age int default 21; -- add default constraint
alter table techcloud_employees modify age int default 21;
alter table techsoft_employees modify age int default 21;
-- task 1c
alter table techhyve_employees add constraint age check(age between 21 and 55); -- add check constraint
alter table techhyve_employees add constraint age check(age between 21 and 55);
alter table techhyve_employees add constraint age check(age between 21 and 55);
-- task 1d
alter table techhyve_employees add column(Username varchar(10) unique, pass_word varchar(10) not null); -- add 2 new columns
alter table techcloud_employees add column(Username varchar(10) unique, pass_word varchar(10) not null);
alter table techsoft_employees add column(Username varchar(10) unique, pass_word varchar(10) not null);
-- task 1e
alter table techhyve_employees add constraint gender check(gender in ('Male', 'Female')); -- check constraint for gender
alter table techcloud_employees add constraint gender check(gender in ('Male', 'Female'));
alter table techsoft_employees add constraint gender check(gender in ('Male', 'Female'));
-- task 2
alter table techhyve_employees add column(Communication_proficiency int default 1); -- add column with default constraint
alter table techcloud_employees add column(Communication_proficiency int default 1);
alter table techsoft_employees add column(Communication_proficiency int default 1);
--
alter table techhyve_employees add constraint Communication_proficiency check(Communication_proficiency between 1 and 5); -- add check constraint in communication proficiency
alter table techcloud_employees add constraint Communication_proficiency check(Communication_proficiency between 1 and 5);
alter table techsoft_employees add constraint Communication_proficiency check(Communication_proficiency between 1 and 5);
-- task 3 
use backup_techmac_db;

create table backup_techmac_db.techhyve_employees_bkp1 like techmac_db.techhyve_employees; -- create new backup 
insert backup_techmac_db.techhyve_employees_bkp1 select * from techmac_db.techhyve_employees;-- insert values and 
drop table backup_techmac_db.techhyve_employees_bkp; -- dropping the old one

select * from backup_techmac_db.techhyve_employees_bkp1;

create table backup_techmac_db.techcloud_employees_bkp1 like techmac_db.techcloud_employees; -- create new backup 
insert backup_techmac_db.techcloud_employees_bkp1 select * from techmac_db.techcloud_employees;-- insert values and 
drop table backup_techmac_db.techcloud_employees_bkp; -- dropping the old one

create table backup_techmac_db.techsoft_employees_bkp1 like techmac_db.techsoft_employees; -- create new backup 
insert backup_techmac_db.techsoft_employees_bkp1 select * from techmac_db.techsoft_employees;-- insert values and 
drop table backup_techmac_db.techsoft_employees_bkp; -- dropping the old one

-- merge 2 table
create table techhyvecloud_employees like techhyve_employees; -- merge 2 tables into new table
insert techhyvecloud_employees select * from techhyve_employees;
insert techhyvecloud_employees select * from techcloud_employees; -- insert values from both table

select * from techhyvecloud_employees;

-- drop the 2 tables
drop table techmac_db.techhyve_employees; -- 2 tables are deleted in techmac db
drop table techmac_db.techcloud_employees; -- the deleted 2 tables are retained in backup
