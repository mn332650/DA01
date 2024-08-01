--ex1: 
select name
from city
where population>120000 and countrycode = 'USA';
--ex2:
select *
from city
where countrycode = 'JPN';
--ex3:
select city, state 
from station;
--ex4: starting with vowels
select distinct city 
from station 
where city like 'A%'
or city like 'E%'
or city like 'I%'
or city like 'O%'
or city like 'U%';
--ex5: ending with vowels
select distinct city 
from station 
where city like '%a'
or city like '%e'
or city like '%i'
or city like '%o'
or city like '%u';
--ex6: not starting with vowels, pay attention to capital letters
select distinct city
from station 
where city not like 'U%'
and city not like 'E%'
and city not like 'O%'
and city not like 'A%'
and city not like 'I%';
--ex7: order name alphabetically 
select name 
from employee
order by name asc;
--ex8: 
select name 
from employee
where salary>2000 and months<10
order by employee_id asc;
--ex9: 
select product_id
from products
where low_fats = 'Y' and recyclable ='Y'
--ex10: customer who don't get refered by customer with id=2
select name
from customer
where referee_id <> 2 or referee_id is null;
--ex11:
select name, population, area
from world
where population >= 25000000 or area >= 3000000;
--ex12:
select distinct author_id as id
from views
where author_id = viewer_id 
order by id asc;
--ex13: 
SELECT part, assembly_step
from parts_assembly
where finish_date is NULL;
--ex14: 
select *
from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >70000;
--ex15: 
select advertising_channel
from uber_advertising
where money_spent >100000 and year = '2019';






