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

/*ex3: */






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





