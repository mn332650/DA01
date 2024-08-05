/* khach hang co ho hoac ten nhieu hon 10 ki tu, ket qua o dang chu thuong */

select lower(first_name),
lower(last_name)
from customer
where length(first_name) >10
or length(last_name)>10;

/* 5 last ky tu cua email, dia chi email luon ket thuc bang '.org', trich xuat only '.' */

select email,
left(right(email,4),1)
from customer;

/*mask data only get first 3 letters and 1 last letters, middle use *** */

select email,
concat(left(email,3),'***',right(email,20)) 
from customer;

/*lay ra thong tin ho cua khach hang tu email*/

select email,
substring(email from position('.' in email)+1 for position('@' in email) -position('.' in email)-1),
position('.' in email), --tim vi tri cua '.' in email, cong them 1 boi vi first letter after '.'
position('@' in email), --tim so luong ki tu cua email boi vi last name in between '.' and '@' 
position('@' in email) -position('.' in email)-1 -- vi tri last name in between 
from customer;

/* trich xuat ten tu email and concatenate w/ last_name
ket qua under: 'Last_name, first_name' */
-- position('.' in email): vi tri cua '.' and first_name will be one letter before so -1

select email,
last_name,
substring(email from 1 for position('.' in email)-1) as first_name,
substring(email from 1 for position('.' in email)-1) || ',' || last_name
from customer;

/*EXTRACT: in 2020, co bao nhieu don hang cho thue trong moi thang */
select 
	extract(month from rental_date),
	count(*)
from rental
where extract(year from rental_date)='2020'
group by extract(month from rental_date); --cho thue moi thang

/*thang nao co tong so tien cao nhat
--ngay nao trong tuan co tong so tien thanh toan cao nhat (0 la chu nhat)
--so tien cao nhat mot kh da chi tieu trong mot tuan la bao nhieu*/

select extract(month from payment_date) as month_of_year,
sum(amount) as total_amount
from payment
group by extract(month from payment_date)
order by sum(amount) desc;

select extract(dow from payment_date) as day_of_week,
sum(amount) as total_amount
from payment
group by  extract(dow from payment_date)
order by sum(amount) desc;

select customer_id, 
extract(week from payment_date),
sum(amount) as total_amount
from payment
group by customer_id, extract(week from payment_date)
order by sum(amount) desc;

--INTERVAL
select customer_id, 
	rental_date, 
	return_date,
	return_date - rental_date,
extract(day from return_date - rental_date)*24 + --lay ngay tu interval * 24h + hour from interval 
extract(hour from return_date - rental_date) || ' ' || 'hours' 
from rental;

/*tao thoi gian da thue cua cus_id = 35 
--kh nao co thoi gian thue trung binh dai nhat */

select customer_id,
rental_date, 
return_date,
return_date - rental_date as rental_intervals
from rental
where customer_id = '35';

select  customer_id,
avg(return_date - rental_date) as avg_rental_time
from rental
group by customer_id
order by avg(return_date - rental_date) desc;
