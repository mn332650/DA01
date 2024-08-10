--SUBQUERIES IN WHERE- truy van con trong 1 truy van 
--Tim nhung hoa don co so tien lown hon so tien trung binh cac hoa don 

select avg(amount) as avg_amount from payment; --tinh so tien trung binh cua cac hoa don

select * from payment 
where amount > (select avg(amount) from payment ); --combine

--tim hoa don cua khach hang co ten la Adam 

select customer_id 
from customer
where first_name='ADAM'; --find customer_id of Adam

select * from payment 
where customer_id=(select customer_id  -- use '=' thi subquery used only return to 1 result 
from customer
where first_name='ADAM');

/*if subquery return a list of result thi where customer_id IN */

select * from payment 
where customer_id IN (select customer_id from customer);

/*tim nhung bo phim co thoi luong lon hon trung binh cac bo phim (return film_id, title)
--tim nhung phim co o store 2 it nhat 3 lan (return film_id, title)
--tim nhung kh den tu california and da chi nhieu hon 100 */

select film_id, title
from film
where length > (select avg(length) from film);

select film_id
from inventory
where store_id=2
group by film_id
having count(*) >=3; --nhung bo phim co o store 2 & xuat hien 3 times

select film_id, title
from film 
where film_id in (select film_id
from inventory
where store_id=2
group by film_id
having count(*) >=3);

select customer_id,
	first_name,
	last_name, 
	email
from customer
where customer_id in (select customer_id from payment 
group by customer_id
having sum(amount) >100) ;

select customer_id from payment 
group by customer_id
having sum(amount) >100; -- kh chi tieu hon 100 

--SUBQUERIES IN FROM 
--tim nhung kh co nhieu hon 30 hoa don 

select customer_id,
count (payment_id) as quantity
from payment 
group by customer_id
having count(payment_id) >30; --use Having but if use subquery, like BELOW

select first_name, last_name, new_table.quantity from 
(select customer_id,
count (payment_id) as quantity
from payment 
group by customer_id) as new_table --use as a new table after FROM 
join customer on new_table.customer_id=customer.customer_id
where quantity>30;

--SUBQUERIES IN SELECT 

select *, 
(select avg(amount) from payment), --create a new column 
(select avg(amount) from payment) - amount
from payment;

select *, 
(select amount from payment limit 1) --use LIMIT because this subquery return a list of result, therefore SQL doesn't know which value to show
from payment;

/*tim chenh lenh giua so tien tung hoa don so voi so tien thanh toan lon nhat ma cong ty nhan duoc */
 
select payment_id, amount,
(select max(amount) from payment) as max_amount, 
(select max(amount) from payment) - amount as diff
from payment;

--CORRELATED SUBQUERIES IN WHERE(TRUY VAN CON TUONG QUAN)
--LAY RA THONG TIN KH TU BANG CUSTOMER CO TONG HOA DON LA 100

select a.customer_id, sum(b.amount) as tong_hoa_don from customer a 
join payment b on a.customer_id=b.customer_id
group by a.customer_id
having sum(b.amount) >100;

select customer_id
from payment
group by customer_id
having sum(amount) >100;

select * from customer
where customer_id IN (select customer_id 
from payment
group by customer_id
having sum(amount) >100); 

select * from customer a
where customer_id = (select customer_id --if use '=', have to add WHERE clause in subquery
from payment b
where a.customer_id=b.customer_id 
group by customer_id
having sum(amount) >100);

--OR: instead of using customer_id = subquery, use EXISTS

select * from customer a
where exists (select customer_id --only use EXISTS in correlated subqueries
from payment b
where a.customer_id=b.customer_id 
group by customer_id
having sum(amount) >100);

--CORRELATED SUBQUERIES IN SELECT 
--ma kh, ten kh, ma thanh thoan, so tien lon nhat cua tung kh */

select 
	a.customer_id,
	a.first_name || ' ' || a.last_name  as ten_khach_hang,
	b.payment_id,
	(select max(amount) from payment  
	where customer_id=a.customer_id ---ADD 'WHERE' 
	group by customer_id) --only do subquery with ONLY 1 RESULT
from customer a
join payment b on a.customer_id=b.customer_id
group by a.customer_id,
a.first_name || ' ' || a.last_name, --khong bo AS in GROUP BY 
b.payment_id
order by customer_id

select customer_id, max(amount) 
from payment 
group by customer_id; --so tien lon nhat cua tung kh

/* list cac khoan thanh toan voi tong so hoa don va tong so tien moi kh phai tra */

--1st solution: SUBQUERY IN WHERE
select a.*, b.count_payment, b.sum_amount --clarify getting (*) from table a
from payment a
join (select customer_id, 
count(*) as count_payment, 
sum(amount) as sum_amount  
from payment
group by customer_id) b on a.customer_id=b.customer_id

-- write a separate subquery for the condition
select customer_id, 
count(*) as count_payment, --tong so hoa don
sum(amount) as sum_amount  --tong so tien cua moi kh
from payment
group by customer_id; 

--2nd Solution: SUBQUERY IN SELECT
select a.*,
(select count(*) from payment b
where customer_id=a.customer_id group by customer_id) as count_payment, 
(select sum(amount) from payment b
where customer_id=a.customer_id group by customer_id) as sum_amount
from payment a;

/*lay dsanh cac film co chi phi that the lon nhat trong moi loai rating. --DIEU KIEN LOC, PUT SUBQUERY IN WHERE
Can hien thi them chi phi thay the tbinh cua moi loai rating do */ --HIEN THI, PUT SUBQUERY IN SELECT

select film_id, title, rating, replacement_cost,
(select avg(replacement_cost) from film b
where a.rating=b.rating
group by rating) as avg_replacement_cost
from film a
WHERE replacement_cost =(select max(replacement_cost) from film c
	where a.rating=c.rating group by rating);

select avg(replacement_cost)
from film
group by rating; --tinh chi phi trung binh cua moi loai rating, group by rating

select rating, max(replacement_cost)
from film 
group by rating; -- chi phi thay the lon nhat trong moi loai rating, group by rating

--CTEs: Common Table Expression - bang chua du lieu tam thoi 
/* WITH + CTE name(name of the temporary table) + AS
(CTE body - SELECT ... FROM ... WHERE) + SELECT ... FROM CTE table */

/*tim kh co nhieu hon 30 hoa don.
Output: ma kh, ten kh, so luong hoa don, tong so tien, tgian thue tbinh */

With twt_total_payment as 
(select customer_id, count(payment_id) as quantity,
sum(amount) as total_amount
from payment
group by customer_id), 
twt_avg_rental_time as
(select customer_id, avg(return_date-rental_date) as rental_time
from rental
group by customer_id
	)
select a.customer_id, a.first_name, b.quantity, b.total_amount, c.rental_time
from customer a
join twt_total_payment b on a.customer_id=b.customer_id
join twt_avg_rental_time c on a.customer_id=c.customer_id
order by customer_id asc

