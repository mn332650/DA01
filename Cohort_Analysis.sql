/* Cohort Analysis Concept: 
- How to keep customer's retention?
- When is the best time to reconnect with users?
- When is the best time to bring back the marketing campaign?

COHORT ANALYSIS (PHAN TICH TO HOP):  behavioral analytics in which you take a group of users, 
and analyze their usage patterns in a certain time period based on their shared 
traits to better track, understand their experience and then improve them.

HOW TO READ COHORT ANALYSIS CHART:
- First left column (size): example: weekly, monthly, etc
- Top horizontal row: number of months
- 1st way - Horizontal: 
     + Used when: de biet so luong kh con lai moi thang sau thoi gian mua dich vu/ san pham lan dau tien.
     + The hien thoi gian ton tai cua nguoi dung, so luong kh con lai sau n thang
- 2nd way - Vertical: 
     + Cho thay su cai thien ve san pham cua minh theo thoi gian ntn?
     + Used when: khi can biet ty le quay lai cua kh co tot hon theo thoi gian hay khong
                (ban co dang giu chan tot nhung nhom kh moi gan day so voi kh cu hay khong?)
- 3rd way - Diagonal:
     + The hien con so thuc su mua hang tung thang 

CALCULATION: 
1/ Customer retention = so luong kh quay lai @n thang/ $thang dau tien(first colum)
(KH come back)

2/ Customer Churn= 1-Customer retention rate
(KH left)

3/ Net dollar( or net revenue) retention= n/ $gia tri first month */

/* B1: EXPLORE and CLEAN DATA
- Chung ta dang quan tam den truong nao?
- Check null
- Chuyen doi kieu du lieu
- So tien va so luong >0
- Check dup */

--541909 records, 135080 records of customerid null

select count(*) from online_retail --check how many records are there in a table

Select * from online_retail
where customerid='';-- check null values

Select count(*) from online_retail
where customerid=''; -- clean null values steps!!!

Select * from online_retail
where customerid<>''; -- values that are not null

with online_retail_convert as(
select 
invoiceno,
description,
stockcode,
cast(quantity as int) as quantity,
cast(invoicedate as timestamp) invoicedate,
cast(unitprice as numeric) as unitprice,
customerid,
country
from public.online_retail
where customerid <>'' --change datatype of the records which are not null <>''
and cast(quantity as int) >0 and cast(unitprice as numeric) >0) -- loc records>0

,online_retail_main as
(select * from 
(select t.* ,
row_number() over(partition by invoiceno, stockcode, quantity order by invoicedate) as dup_flag --dem stt row xem which records duplicate
from online_retail_covert t ) x
where dup_flag =1 ) --only keep records that has 1 line, no duplicate

/*B2:
- Tim ngay mua hang dau tien cua moi kh => cohort_date
- Tim index=thang (ngay mua hang ngay dau tien) +1
- Count so luong KH hoac tong doanh thu tai moi cohort_date va index tuong ung
- Pivot table */
 --- begin analyst 
--select * from online_retail_main
,online_retail_index as(
SELECT 
customerid,
	amount,
	TO_CHAR(first_purchase_date, 'yyyy-mm') as cohort_date, --only care about month & year
	invoicedate,
	(extract('year' from invoicedate)-extract('year' from first_purchase_date))*12
	+(extract('month' from invoicedate)-extract('month' from first_purchase_date))+1 as index
--calculate so chenh lech thang cua 2 thoi diem bat ki: (year-year)*12months+(month-month)
FROM(
	SELECT customerid,
	quantity*unitprice AS amount, -- so tien moi kh da purchased
MIN(invoicedate) over(PARTITION BY customerid) as first_purchase_date, --tim ngay mua hang dau tien cua moi kh, phai sap xep theo nhom
invoicedate
from online_retail_main t
) a)

,xxx as(
SELECT 
cohort_date,
index,
count(distinct customerid) as cnt,
sum(amount) as revenue
from online_retail_index
group by cohort_date, index) --bang tong hop cohort date, index, so luong kh va tong doanh thu from previous ctes

--- customer_cohort
     
,customer_cohort as (
select 
cohort_date,
sum(case when index=1 then cnt else 0 end ) as m1,
sum(case when index=2 then cnt else 0 end ) as m2,
sum(case when index=3 then cnt else 0 end ) as m3,
sum(case when index=4 then cnt else 0 end ) as m4,
sum(case when index=5 then cnt else 0 end ) as m5,
sum(case when index=6 then cnt else 0 end ) as m6,
sum(case when index=7then cnt else 0 end ) as m7,
sum(case when index=8 then cnt else 0 end ) as m8,
sum(case when index=9then cnt else 0 end ) as m9,
sum(case when index=10 then cnt else 0 end ) as m10,
sum(case when index=11 then cnt else 0 end ) as m11,
sum(case when index=12 then cnt else 0 end ) as m12,
sum(case when index=13 then cnt else 0 end ) as m13
from xxx
group by cohort_date
order by cohort_date)
     
-- retention cohort
, retention_cohort as (     
select
cohort_date,
round(100.00* m1/m1,2)||'%' as m1,
round(100.00* m2/m1,2)|| '%' as m2,
round(100.00* m3/m1,2) || '%' as m3,
round(100.00* m4/m1,2) || '%' as m4,
round(100.00* m5/m1,2) || '%' as m5,
round(100.00* m6/m1,2) || '%' as m6,
round(100.00* m7/m1,2) || '%' as m7,
round(100.00* m8/m1,2) || '%' as m8,
round(100.00* m9/m1,2) || '%' as m9,
round(100.00* m10/m1,2) || '%' as m10,
round(100.00* m11/m1,2) || '%' as m11,
round(100.00* m12/m1,2) || '%' as m12,
round(100.00* m13/m1,2) || '%' as m13
from customer_cohort)
     
-- churn cohort

select
cohort_date,
(100-round(100.00* m1/m1,2))||'%' as m1,
(100-round(100.00* m2/m1,2))|| '%' as m2,
(100-round(100.00* m3/m1,2)) || '%' as m3,
(100-round(100.00* m4/m1,2)) || '%' as m4,
(100-round(100.00* m5/m1,2)) || '%' as m5,
(100-round(100.00* m6/m1,2)) || '%' as m6,
(100-round(100.00* m7/m1,2)) || '%' as m7,
(100-round(100.00* m8/m1,2)) || '%' as m8,
(100-round(100.00* m9/m1,2)) || '%' as m9,
(100-round(100.00* m10/m1,2)) || '%' as m10,
(100-round(100.00* m11/m1,2)) || '%' as m11,
(100-round(100.00* m12/m1,2)) || '%' as m12,
(100-round(100.00* m13/m1,2)) || '%' as m13
from customer_cohort











