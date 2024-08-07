/*ex1: calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership.
Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views. */

SELECT 
sum(case when device_type='laptop' then 1 else 0 end) as laptop_views,
sum(case when device_type='tablet' or device_type='phone' then 1 else 0 end) as mobile_views
FROM viewership;

/*ex2: Report for every three line segments whether they can form a triangle. */

select x,y,z, 
case when x+y>z and x+z>y and y+z>x then 'Yes' else 'No'
end as triangle 
from triangle;

/*ex3: some calls cannot be neatly categorised.
These uncategorised calls are labeled as “n/a”, or are left empty when the support agent does not enter anything into the call category field.
Write a query to calculate the percentage of calls that cannot be categorised. Round your answer to 1 decimal place */

SELECT 
round(sum(case
when call_category='n/a' then 1 
when call_category is null then 1
else 0 end)*100.0/count(case_id),1) as uncategorised_call_pct
from callers;

/ex4: Find the names of the customer that are not referred by the customer with id = 2*/

select name
from customer
where referee_id <> 2 or referee_id is null;

/*ex5: showing the number of survivors and non-survivors by passenger class.
Classes are categorized based on the pclass value as:
pclass = 1: first_class
pclass = 2: second_classs
pclass = 3: third_class
Output the number of survivors and non-survivors by each class */

select survived, 
sum(case when pclass=1 then 1 else 0 end) as first_class, 
sum(case when pclass=2 then 1 else 0 end) as second_class,
sum(case when pclass=3 then 1 else 0 end) as third_class
from titanic
group by survived


