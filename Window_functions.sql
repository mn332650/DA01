--WINDOW FUNCTIONS: 
--PARTITION: phan cum # GROUP BY: gom nhom 
--Mot khoi = 1 window, moi dong gia tri trong 1 cua so same

/* SUM(FIELD) OVER (PARTITION BY FIELD) AS NAME: tong hop field over chia thanh khoi chia theo FIELD va dat ten theo name*/

--Tong hop: SUM, AVG, MIN, MAX, COUNT
--Xep hang: RANK
--Phan tich: LEAD, LAG

--WINDOW FUNCTIONS with SUM( ), COUNT( ), AVG( )
--FORMAT: 
select col1, col2, col3, 
Aggregate functions ( ) OVER (PARTITION BY col1, col2) 
                    --mo cua so--
	                             --gom nhom by--   
From table name;

--OVER( ) with PARTITION BY--
/* Tinh ti le so tien thanh toan tung ngay voi tong so tien da thanh toan cua moi KH.
Output: ma kh, ngay thanh toan, so tien thanh toan tai ngay, tong so tien da 
thanh toan, ti le */

select a.customer_id, b.first_name, a.payment_date, a.amount,
(select sum(amount) 
from payment c
where a.customer_id=c.customer_id
group by customer_id), --Find total_amount for each customer
a.amount/ (select sum(amount) 
from payment c
where a.customer_id=c.customer_id
group by customer_id) as ti_le
from payment a 
join customer b on a.customer_id=b.customer_id
group by a.customer_id, b.first_name, a.payment_date, a.amount;

     --OR: USE CTEs
With cte_total_payment as 
(
	select customer_id, 
	sum(amount) as total_amount
	from payment
	group by customer_id
)
select a.customer_id, b.first_name, a.payment_date, a.amount,
c.total_amount, a.amount/c.total_amount as ti_le
from payment a
join customer b on a.customer_id=b.customer_id
join cte_total_payment c on c.customer_id=a.customer_id;

      --OR: USE WINDOW FUNCTIONS
select a.customer_id, b.first_name, a.payment_date, a.amount,
sum(a.amount) over (partition by a.customer_id) as total_amount
from payment a 
join customer b on a.customer_id=b.customer_id;

--in WINDOW FUNCTION, just need to group the results by 1 field, but in GROUP BY, you have to choose all the fields in SELECT 

/*List movies include: film_id, title, length, category, 
avg(length) phim in that category. Sap xep theo film_id */ 

select a.film_id, a.title, a.length, c.name,
round(avg(a.length) over (partition by c.name),2) as avg_length
from film a
join film_category b on a.film_id=b.film_id
join category c on b.category_id=c.category_id;

/*list tat ca cac thanh toan bao gom so lan thanh toan duoc thuc hien boi 
kh va so tien do. Sap xep theo payment_id */

select *,
count(*) over(partition by customer_id, amount) as payment_times
from payment
order by payment_id; 

--OVER( ) WITH ORDER BY--

select payment_date, amount, 
sum(amount) over(order by payment_date) as total_amount --tinh den thoi diem hien tai thi total amount la bao nhieu? =current value+ previous value
from payment; --sap xep theo chieu tang dan cua payment_date, sau do cong luy ke tat ca previous payment and current payment

select payment_date, customer_id, amount,
sum(amount) over(partition by customer_id order by payment_date) as total_amount
from payment; --phan nhom theo tung kh & sau do cong theo chieu tang dan 

--PARTITION BY: phan cum theo certain field
--ORDER BY: tinh luy ke, sua khi sap xep theo 1 trinh tu thi se duoc tinh luy ke theo cac dong truoc 

select col1, col2,...,coln
agg(col) over(partition by col1 order by col2) as name
from table 

--WINDOW FUNCTIONS with RANK FUNCTION
--Xep hang do dai phim trong tung the loai
--output: film_id, category, length, xep hang do dai phim trong tung category

select a.film_id, c.name, a.length,
rank() over(partition by c.name order by a.length desc) as rank1,
dense_rank() over(partition by c.name order by a.length desc) as rank2,
row_number() over(partition by c.name order by a.length desc) as rank3
from film a 
join film_category b on a.film_id=b.film_id
join category c on c.category_id=b.category_id;

--DENSE_RANK: so thu tu goi dau, vd: 1,1,2,3,4,5 |
--RANK: vd: 1,1,3,4,5,6,7,8                      |  RUN THE CODE ABOVE TO SEE THE DIFFERENCE
--ROW_NUMBER: vd: 1,2,3,4,5,6,7,8                |

/*list ten kh (first+last name), country, so luong thanh toan.
Tao bang xep hang nhung kh co doanh thu cao nhat cho moi quoc gia.
Limit top 3 kh cua moi quoc gia*/

select * from 
(
select a.first_name || ' '|| a.last_name as full_name,
d.country, 
sum(e.amount) as payment_quan, 
rank() over(partition by d.country order by sum(e.amount) desc) as orders
from customer a
join address b on a.address_id=b.address_id
join city c on b.city_id=c.city_id
join country d on c.country_id=d.country_id
join payment e on a.customer_id=e.customer_id
group by  a.first_name || ' '|| a.last_name,
d.country
) t --cte table to find customers has highest payment from each country
where t.orders<=3;--Top 3 only
