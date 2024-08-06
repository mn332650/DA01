/*CASE WHEN: find how many movies are there per category */
Select 
Case 
	When length<60 then 'short'
	When length between 60 and 120 then 'medium'
	when length>120 then 'long' --OR: else 'long'
End category, 
Count(*) as quantity
From film
Group by category;

/*bo phim co tag la 1 if rating = 'G' or 'PG' tag la 0 if else */
select film_id,
case
	when rating ='G' or rating ='PG' then '1'
	else '0'
end tag
from film;

--OR--
select film_id,
case 
when rating in ('PG','G') then 1
when rating not in ('PG','G') then 0
end tag
from film;

/*cty da ban bao nhieu ve:
low price ticket: total_amount <20000
mid price ticket: total_amount between 20000 and 150000
high price ticket: total amount >=150000 */

select 
case 
	when amount<20000 then 'low_price_ticket'
	when amount between 20000 and 150000 then 'mid_price_ticket'
	else 'high_price-ticket'
end category,
count(*) as quantity
from bookings.ticket_flights
group by category;

/*bao nhieu flights departed in:
--Spring: month 2,3,4
--Summer: 5,6,7
--Fall: 8,9,10
--winter: 11,12,1 */

select 
case
	when extract(month from scheduled_departure) in ('02','03','04') then 'Spring'
	when extract(month from scheduled_departure) in ('05','06','07') then 'Summer'
	when extract(month from scheduled_departure) in ('08','09','10') then 'Fall'
	else 'Winter'
end Season,
	count(*) as flight_quantity
from bookings.flights
group by season;

/*tao danh sach film phan cap do:
--Rating 'PG' or 'PG-13' or length>210 --'Great rating or long (tier 1)'
--description contain 'Drama' and length>90 -- Long drama(tier 2 )
--description contain 'Drama' and length<=90 -- Shcity drama (tier 3)
--rental_rate <1 --'Very cheap(tier 4)'
sort those movies only have 1 category */

select film_id,
case
	when (rating='PG' or rating='PG-13') or length>210 then 'Tier 1'
	when description like '%Drama' and length>90 then 'Tier 2'
	when description like '%Drama%' and length<=90 then 'Tier 3'
	when rental_rate<1 then 'Tier 4'
end as category
from film
where case
	when (rating='PG' or rating='PG-13') or length>210 then 'Tier 1'
	when description like '%Drama' and length>90 then 'Tier 2'
	when description like '%Drama%' and length<=90 then 'Tier 3'
	when rental_rate<1 then 'Tier 4'
end is not null
group by film_id;

/* tinh tong so tien theo tung loai hoa don high-medium-low 
cua tung kh
--high: amount>10
--medium: 5<= amount <=10
--low: amount<5 */

select customer_id,
case 
	when amount>10 then 'High'
	when amount between 5 and 10 then 'Medium'
	when amount <5 then 'Low'
end as category,
sum(amount)
from payment
group by customer_id, category; -- don't show in an easily viewed format

--USE PIVOT TABLE with CASE WHEN

select customer_id,
sum(case 
	when amount>10 then amount
	else 0
	end) as High,
sum(case
	when amount between 5 and 10 then amount
	else 0
	end) as Medium,
sum(case
	when amount <5 then amount
	else 0
	end) as Low
from payment
group by customer_id
order by customer_id asc;

/*thong ke bao nhieu bo phim duoc danh gia la R, PG, PG-13
o cac the loai phim long-medium-short */

select 
case 
	When length<60 then 'short'
	When length between 60 and 120 then 'medium'
	when length>120 then 'long' --OR: else 'long' 
end as category,
sum(case when rating='R' then 1 else 0 end) as R,
sum(case when rating='PG' then 1 else 0 end) as PG,
sum(case when rating='PG-13' then 1 else 0 end) as PG_13
from film 
group by category;
