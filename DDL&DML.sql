--DDL (Data Definition Language): CREATE, ALTER, DROP -- anh huong den data structure
                             --ALTER: thay doi cau truc doi tuong: add col/ delete dol
                             --DROP: delete doi tuong tren database

--DML (Data Manipulation Language): INSERT, DELETE, TRUNCATE, UPDATE

--In a schema, focus on TABLES, VIEW, FUNCTIONS, and PROCEDURES
--VIEW: la bang ao, made from different code then save to temporary tables as in VIEW

--DDL: CREATE, DROP, ALTER

/*CREATE OR DROP TABLE */

create table manager 
(
	manager_id int primary key,
	user_name varchar(20) unique, --limit how many letters/ unique: co the null but not duplicate
	first_name varchar(50),
	last_name varchar(50) default 'NA',
	date_of_birth date,
	address_id int
);
	
DROP table manager, --because we already created the manager table, so if you want to update,
                   --you have to delete the previous table(DROP) and then run the create table again

/*truy van du lieu lay ra danh sach kh va dia chi tuong ung,
sau do luu thong tin do vao bang dat ten la customer_info
(customer_id, full_name, email, address) */

create table customer_info as --create a physical table, however this table data will not be updated as the main tables get updated
(
select
a.customer_id,
a.first_name || ' '|| a.last_name as full_name,
a.email, 
b.address
from customer a 
join address b on a.address_id=b.address_id
);

/*CREATE TEMPORARY TABLE */

create temp table temp_customer_info as --or create global temp for everyone to use
(
select
a.customer_id,
a.first_name || ' '|| a.last_name as full_name,
a.email, 
b.address
from customer a 
join address b on a.address_id=b.address_id);

select * from temp_customer_info;

--Temp table and create table don't save/ update date if we exist out, instead, create VIEW
/* CREATE VIEW */ --when tables update data, view table will update data too!

/
create view vw_customer_info as 
(
select
a.customer_id,
a.first_name || ' '|| a.last_name as full_name,
a.email, 
b.address
from customer a 
join address b on a.address_id=b.address_id);

select * from vw_customer_info

create or replace view vw_customer_info as --use this to always able to update any cols
(
select
a.customer_id,
a.first_name || ' '|| a.last_name as full_name,
a.email, 
b.address, a.active
from customer a 
join address b on a.address_id=b.address_id);

drop view vw_customer_info;

/*tao view co ten movies_category hien thi danh sach cac film,
bao gom title, length, category name duoc sap xep giam dan theo length.
Filter only move in 'Action' and 'Comedy' category */

create or replace view movies_category as
(select 
	a.title,
	a.length,
	c.name as category_name
from film a 
join film_category b on a.film_id=b.film_id
join category c on b.category_id=c.category_id);

select *
from movies_category
where category_name='Action' or category_name='Comedy'
order by length desc;

/*ALTER TABLE */
--ADD, DELETE COLUMNS
alter table manager
drop first_name

alter table manager
add column first_name varchar(50);
	
--RENAME COLUMNS
alter table manager
rename column first_name to ten_kh;

--ALTER DATA TYPES
alter table manager
alter column ten_kh type text;
	
select * from manager;

/*DDL: INSERT, UPDATE, DELETE, TRUNCATE */

select * from city
	where city_id=3;

insert into city
values 
(1001, 'BACD', 33,'2020-01-02 16:10:20');

insert into city(city,country_id)
values ('C', 45);

update city 
set country_id=100
where city_id=3;

/*update gia cho thue film 0.99 thanh 1.99
- dieu chinh bang customer: 
. them cot initals (data type varchar(!0))
. update du lieu vao cot initials */

update film 
set rental_rate=1.99
where rental_rate=0.99;

select * from film where rental_rate=0.99

alter table customer 
add column initials varchar(10)

	alter table customer
	drop intitials;
select * from customer

update customer 
set initials=left(first_name,1)||'.'||left(last_name,1)

/*DELETE & TRUNCATE */

INSERT INTO manager
values
(1,'HAPT','TRAN','2000-04-05',20,'HA'),
(2,'HAIS','NGUYEN','2002-04-22',12,'HOA'),
(3,'AJS','ASNKD','2001-05-06',12,'SD')

SELECT * from manager;

delete from manager  
where manager_id=1;

truncate table manager;









