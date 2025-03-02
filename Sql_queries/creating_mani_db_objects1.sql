-- create database
create database techmac_db;
use techmac_db;

-- create table
create table techhyve_employees( EmployeeID varchar(10) primary key, Firstname varchar(10) not null, Lastname varchar(10) not null, gender varchar(10) not null, age int unique);
create table techcloud_employees( EmployeeID varchar(10) primary key, Firstname varchar(10) not null, Lastname varchar(10) not null, gender varchar(10) not null, age int unique);
create table techsoft_employees( EmployeeID varchar(10) primary key, Firstname varchar(10) not null, Lastname varchar(10) not null, gender varchar(10) not null, age int unique);

desc techhyve_employees; -- show structure
desc techcloud_employees;
desc techsoft_employees;

-- insert values in techhyve table
insert into techhyve_employees values ('TH001', 'Eli', 'Evans', 'Male', 26);
insert into techhyve_employees values ('TH002', 'Carlos', 'Simmons', 'Male', 32);
insert into techhyve_employees values ('TH003', 'Kathie', 'Bryant', 'Female', 25);
insert into techhyve_employees values ('TH004', 'Joey', 'Hughes', 'Male', 41);
insert into techhyve_employees values ('TH005', 'Alice', 'Mathews', 'Female', 52);

select * from techhyve_employees;

-- insert intotechcloud
insert into techcloud_employees values ('TC001', 'Teresa', 'Bryant', 'Female', 39);
insert into techcloud_employees values ('TC002', 'Alexis', 'Patterson', 'Male', 48);
insert into techcloud_employees values ('TC003', 'Rose', 'Bell', 'Female', 42);
insert into techcloud_employees values ('TC004', 'Gemma', 'Watkins', 'Female', 44);
insert into techcloud_employees values ('TC005', 'Kingston', 'Martinez', 'Male', 29);

select * from techcloud_employees;

-- insert into techsoft
insert into techsoft_employees values ('TS001', 'Peter', 'Burtler', 'Male', 44);
insert into techsoft_employees values ('TS002', 'Harold', 'Simmons', 'Male', 54);
insert into techsoft_employees values ('TS003', 'Juliana', 'Sanders', 'Female', 36);
insert into techsoft_employees values ('TS004', 'Paul', 'Ward', 'Male', 29);
insert into techsoft_employees values ('TS005', 'Nicole', 'Bryant', 'Female', 30);

select * from techsoft_employees;

-- clonning for backup 
create database backup_techmac_db; -- create database for backup
use backup_techmac_db;

create table techhyve_employees_bkp like techmac_db.techhyve_employees
insert techhyve_employees_bkp select * from techmac_db.techhyve_employees;
select * from techhyve_employees_bkp;

create table techcloud_employees_bkp like techmac_db.techcloud_employees
insert techcloud_employees_bkp select * from techmac_db.techcloud_employees;
select * from techcloud_employees_bkp;

create table techsoft_employees_bkp like techmac_db.techsoft_employees
insert techsoft_employees_bkp select * from techmac_db.techsoft_employees;

-- deletion of few employee
delete from techhyve_employees where EmployeeID='TH003';
delete from techhyve_employees where EmployeeID='TH005';
select * from techhyve_employees;
 
delete from techcloud_employees where EmployeeID='TC001';
delete from techcloud_employees where EmployeeID='TC004';
select * from techcloud_employees;
