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
	
 /* 4/ Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là 
Qúy, tháng, năm được lấy ra từ ORDERDATE */

alter table sales_dataset_rfm_prj
add column qtr_id int;

alter table sales_dataset_rfm_prj
add column month_id int;

alter table sales_dataset_rfm_prj
add column year_id int;

select * from sales_dataset_rfm_prj;

select orderdate,
extract(month from orderdate) as month,
extract(year from orderdate) as year,
extract(quarter from orderdate) as quarter
from sales_dataset_rfm_prj;

update sales_dataset_rfm_prj
set qtr_id=extract(quarter from orderdate);

update sales_dataset_rfm_prj
set month_id=extract(month from orderdate);

update sales_dataset_rfm_prj
set year_id=extract(year from orderdate);

/*5/ Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và 
hãy chọn cách xử lý cho bản ghi đó (2 cách) */

--BOXPLOT

with cte as
(
select 
Q1-1.5*IQR as min_value, 
Q3+1.5*IQR as max_value
from
(
select 
percentile_cont(0.25) within group(order by quantityordered) as Q1,-- find Q1
percentile_cont(0.75) within group(order by quantityordered) as Q3,-- find Q3
percentile_cont(0.75) within group(order by quantityordered)-percentile_cont(0.25) within group(order by quantityordered) as IQR
from sales_dataset_rfm_prj) as a)

select * from sales_dataset_rfm_prj
where quantityordered<(select min_value from cte)
or quantityordered>(select max_value from cte) --return all values that are outliers

--Z-Score

select avg(quantityordered),
stddev(quantityordered) 
from sales_dataset_rfm_prj;

with cte as 
(
select ordernumber, 
quantityordered,
(select avg(quantityordered)
from sales_dataset_rfm_prj) as avg,
(select stddev(quantityordered) 
from sales_dataset_rfm_prj) as stddev
from sales_dataset_rfm_prj) 
, twt_outlier as (	
select ordernumber,quantityordered, (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev)>3)
	
update sales_dataset_rfm_prj 
set quantityordered=(select avg(quantityordered) from sales_dataset_rfm_prj)
where quantityordered in (select quantityordered from twt_outlier)

/* DELETE STATEMENT 

delete from sales_dataset_rfm_prj 
where quantityordered in (select quantityordered from twt_outlier) */

































