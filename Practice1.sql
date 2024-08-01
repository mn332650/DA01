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
