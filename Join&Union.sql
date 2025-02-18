--INNER JOIN

select t1.*,t2.*
from table1 as t1
inner join table2 as t2
on t1.key1=t2.key2;

select p.payment_id,p.customer_id,
c.first_name, c.last_name
from payment p 
inner join customer c
on p.customer_id=c.customer_id
order by customer_id asc;

/*co bao nhieu nguoi chon ghe theo business, economy, comfort */

select s.fare_conditions,
count(b.seat_no) as quanity
from seats s
inner join boarding_passes b on s.seat_no=b.seat_no
group by fare_conditions;

--LEFT-RIGHT JOIN 
select t1.*,t2.*   --hien thi thong tin tu tables
from table1 as t1  --bang goc, SQL returns all values from t1
left join table2 as t2  --bang tham chieu, chi tra values matches t1, if not, return null
on t1.key1=t2.key2;

select t1.*,t2.*   --hien thi thong tin tu tables
from table1 as t1  --bang tham chieu
right join table2 as t2  --bang goc, SQL return all values from t1 then match value with t1, if no, return null
on t1.key1=t2.key2;

--tim thong tin cac chuyen bay cua tung may bay 
--from tables: aircrafts_data & flights

select t1.aircraft_code,t2.flight_no
from aircrafts_data t1 --bang goc 
left join flights t2 on t1.aircraft_code=t2.aircraft_code 
where t2.flight_no is null; --may bay nao khong co chuyen bay nao

/*ghe nao duoc lua chon thuong xuyen nhat
(dam bao all seats are listed even it didn't get booked)
--co cho ngoi ngoi nao chua bao gio duoc dat lai khong
--hang ghe nao duoc dat thuong xuyen nhat */ -- extract from seat_no

select a.seat_no,
	count(flight_id) as quantity
from seats a
left join boarding_passes b on a.seat_no=b.seat_no
group by a.seat_no
order by count(flight_id) desc; --ghe duoc chon thuong xuyen nhat


select a.seat_no
from seats a
left join boarding_passes b on a.seat_no=b.seat_no
where b.seat_no is null;

select right(a.seat_no,1) as seat_row,
count(flight_id) as quantity
from seats a
left join boarding_passes b on a.seat_no=b.seat_no
group by right(a.seat_no,1)
order by count(flight_id) desc;

--FULL OUTER JOIN
select t1.*, t2.*
from table1 as t1 
full join table2 as t2
on t1.key1=t2.key2;

select count(*)
from boarding_passes a
full join tickets b   
on a.ticket_no=b.ticket_no
where a.ticket_no is null; --nhung ticket o table a k co boarding_no len may bay, boarding_no co o a but not in b

--JOIN ON MULTIPLE CONDITONS
--tinh gia trung binh cua tung so ghe may bay
--B1: output, input
--seat_no & avg

select a.seat_no, 
round(avg(b.amount),2) as avg_amount
from boarding_passes a
left join ticket_flights b on a.ticket_no=b.ticket_no and a.flight_id=b.flight_id
group by a.seat_no --gom nhom theo so ghe 
order by avg(b.amount) asc; 

--JOIN MULTIPLE TABLES
--so ve, ten kh, gia ve, gio bay, gio ket thuc

select a.ticket_no, a.passenger_name,b.amount, c.scheduled_departure, c.actual_arrival
from tickets a 
inner join ticket_flights b on a.ticket_no=b.ticket_no
inner join flights c on b.flight_id=c.flight_id;

/*find first_name, last_name, email and country tu tat ca kh tu Brazil */

select a.first_name, a.last_name, a.email, d.country
from customer a
join address b on a.address_id=b.address_id
join city c on b.city_id=c.city_id
join country d on c.country_id=d.country_id
where d.country= 'Brazil';

--SELF-JOIN

CREATE TABLE employee (
	employee_id INT,
	name VARCHAR (50),
	manager_id INT
);

INSERT INTO employee 
VALUES
	(1, 'Liam Smith', NULL),
	(2, 'Oliver Brown', 1),
	(3, 'Elijah Jones', 1),
	(4, 'William Miller', 1),
	(5, 'James Davis', 2),
	(6, 'Olivia Hernandez', 2),
	(7, 'Emma Lopez', 2),
	(8, 'Sophia Andersen', 2),
	(9, 'Mia Lee', 3),
	(10, 'Ava Robinson', 3);

select emp.employee_id,emp.name as emp_name, emp.manager_id,mng.name as mng_name
from employee as emp
left join employee as mng on emp.manager_id=mng.employee_id;

/*tim nhung bo phim co cung thoi luong phim
output: title1, title2, length */

select f1.title as title1, f2.title as title2, f1.length 
from film as f1
join film as f2 on f1.length=f2.length
where f1.title <> f2.title;

--UNION & UNION ALL
--NOTE: # of Columns from tables must be similar
--Data type from the same column must be the same
--UNION discard duplicates but UNION ALL get all 

select col1, col2,col3,...,coln
from table 1
union/union all 
select col1, col2, col3,...,coln
from table2
union/union all
select col,col2,col3,...,coln
from table3;

select first_name, 'actor' as source from actor --as source to distinguish first_name from which table 
union all
select first_name, 'customer' as source from customer
union all
select first_name, 'staff' as source from staff
order by first_name;
