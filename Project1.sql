select * from SALES_DATASET_RFM_PRJ;

--1/ Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
select * from SALES_DATASET_RFM_PRJ;

alter table SALES_DATASET_RFM_PRJ
alter column 
	priceeach type numeric using(trim(priceeach)::numeric);

alter table SALES_DATASET_RFM_PRJ
alter column 
	ordernumber type numeric using(trim(ordernumber)::numeric);

alter table SALES_DATASET_RFM_PRJ
alter column quantityordered type int using(trim(quantityordered)::int);

alter table SALES_DATASET_RFM_PRJ
alter column 
	orderlinenumber type int using(trim(orderlinenumber)::int);

alter table SALES_DATASET_RFM_PRJ
alter column
	sales type numeric using(trim(sales)::numeric);

alter table SALES_DATASET_RFM_PRJ
alter column orderdate type date using(trim(orderdate)::date);

alter table SALES_DATASET_RFM_PRJ
alter column
	status type varchar(10) using(trim(status)::varchar(10));

alter table SALES_DATASET_RFM_PRJ
alter column
	productline type varchar(20) using(trim(productline)::varchar(20));

alter table SALES_DATASET_RFM_PRJ
alter column
	msrp type int using(trim(msrp)::int);

alter table SALES_DATASET_RFM_PRJ
alter column
	productcode type char(10) using(trim(productcode)::char(10));

alter table SALES_DATASET_RFM_PRJ
alter column
	customername type varchar(50) using(trim(customername)::varchar(50));

alter table SALES_DATASET_RFM_PRJ
alter column
	phone type char(10) using(trim(phone)::char(10));

alter table SALES_DATASET_RFM_PRJ
alter column
	addressline1 type varchar(50) using(trim(addressline1)::varchar(50));

alter table SALES_DATASET_RFM_PRJ
alter column
	addressline2 type varchar(50) using(trim(addressline2)::varchar(50));

alter table SALES_DATASET_RFM_PRJ
alter column
	city type varchar(20) using(trim(city)::varchar(20));

alter table SALES_DATASET_RFM_PRJ
alter column
	state type varchar(20) using(trim(state)::varchar(20));

alter table SALES_DATASET_RFM_PRJ
alter column
	postalcode type char(10) using(trim(postalcode)::char(10));

alter table SALES_DATASET_RFM_PRJ
alter column
	country type varchar(20) using(trim(country)::varchar(20));

alter table SALES_DATASET_RFM_PRJ
alter column
	territory type varchar(10) using(trim(territory)::varchar(10));

alter table SALES_DATASET_RFM_PRJ
alter column
	contactfullname type char(50) using(trim(contactfullname)::char(50));

alter table SALES_DATASET_RFM_PRJ
alter column
	dealsize type varchar(10) using(trim(dealsize)::varchar(10));

/* 2/ Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, 
QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE */

select ORDERNUMBER from sales_dataset_rfm_prj 
where ordernumber is null; 

select QUANTITYORDERED from sales_dataset_rfm_prj 
where QUANTITYORDERED is null; 

select PRICEEACH from sales_dataset_rfm_prj 
where PRICEEACH is null; 

select ORDERLINENUMBER from sales_dataset_rfm_prj 
where ORDERLINENUMBER is null; 

select SALES from sales_dataset_rfm_prj 
where SALES is null;

select ORDERDATE from sales_dataset_rfm_prj 
where ORDERDATE is null;

/*3/ Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME
Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa,
chữ cái tiếp theo viết thường. Hint: ( ADD column sau đó UPDATE) */

alter table sales_dataset_rfm_prj
add column contactlastname varchar(50);

alter table sales_dataset_rfm_prj
add column contactfirstname varchar(50);
	
select * from sales_dataset_rfm_prj; --TABLE

select initcap(substring(contactfullname from 1 for position('-' in contactfullname)-1))
from sales_dataset_rfm_prj; --lastname

select 
initcap(substring(contactfullname from position('-' in contactfullname)+1))
from sales_dataset_rfm_prj; --firstname

update sales_dataset_rfm_prj
set contactlastname=initcap(substring(contactfullname from 1 for position('-' in contactfullname)-1));
update sales_dataset_rfm_prj
set contactfirstname=initcap(substring(contactfullname from position('-' in contactfullname)+1));
	
 




















