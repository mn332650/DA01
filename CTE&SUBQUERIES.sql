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




