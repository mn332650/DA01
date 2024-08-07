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



