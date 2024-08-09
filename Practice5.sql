/*CITY and COUNTRY tables, 
query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population)
rounded down to the nearest integer */

select a.continent, floor(avg(b.population)) as avg_population --question require ROUND DOWN--
from country a
join city b on a.code=b.countrycode
group by a.continent
order by round(avg(b.population),0) asc;

/*ex2: ew TikTok users sign up with their emails. 
They confirmed their signup by replying to the text confirmation to activate their accounts.
Users may receive multiple text messages for account confirmation until they have confirmed their new account.
A senior analyst is interested to know the activation rate of specified users in the emails table. 
Write a query to find the activation rate. Round the percentage to 2 decimal places */

select
round(sum(case when t.signup_action='Confirmed' then 1 else 0 end)::decimal/count(distinct e.email_id),2)
as activation_rate
from emails e  
left join texts t on e.email_id=t.email_id;

/*ex3:Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. 
Round the percentage to 2 decimal places in the output */

SELECT b.age_bucket,
ROUND(100.0*SUM(CASE WHEN activity_type = 'send' THEN time_spent END)::decimal/SUM(CASE WHEN activity_type = 'send' or activity_type = 'open' THEN time_spent END)::decimal,2) AS send_perc,
ROUND(100.0*SUM(CASE WHEN activity_type = 'open' THEN time_spent END)::decimal/SUM(CASE WHEN activity_type = 'send' or activity_type = 'open' THEN time_spent END)::decimal,2) AS open_perc
FROM activities a  
JOIN age_breakdown b
ON a.user_id = b.user_id
GROUP BY age_bucket

/*ex4: A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product category listed in the products table.
Write a query that identifies the customer IDs of these Supercloud customers */

SELECT a.customer_id
FROM customer_contracts a  
join products b on a.product_id=b.product_id
group by a.customer_id
having count(distinct product_category) >=3;

/*ex5: Write a solution to report the ids and the names of all managers, the number of employees who report directly to them,
and the average age of the reports rounded to the nearest integer. Return the result table ordered by employee_id */
--select * and then see the overall table first then will know which table to grab data
select
mng.employee_id,
mng.name,
count(emp.employee_id) as reports_count,
round(avg(emp.age),0) as average_age
from employees emp
join employees mng on mng.employee_id=emp.reports_to
group by mng.employee_id
order by mng.employee_id asc;

/*ex6: Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount */

select p.product_name,
sum(o.unit) as unit
from products p
join orders o on p.product_id=o.product_id
where o.order_date between '2020-02-01' and '2020-02-29'
group by p.product_name
having sum(o.unit) >=100;

/*ex7: Write a query to return the IDs of the Facebook pages that have zero likes. 
The output should be sorted in ascending order based on the page IDs */

SELECT a.page_id
FROM pages a  
left join page_likes b on a.page_id=b.page_id
where b.page_id is null 
order by a.page_id asc;





