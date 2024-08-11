/*ex1: Write a query to retrieve the count of companies that have posted duplicate job listings.
Definition:
Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions */

with duplicate_jobs as 
(
select company_id,title,description, 
count(job_id) as job_counts
from job_listings
group by company_id, title, description --which companies have duplicate jobs, job count number 
)
select count(distinct company_id) as duplicate_companies
from duplicate_jobs
where job_counts>1 --don't have group by after bc use count right after SELECT 

/*ex2:  write a query to identify the top two highest-grossing products within each category in the year 2022.
The output should include the category, product, and total spend.*/

with ranked_category_appliance as 
(
select category, product, 
sum(spend) as total_spend
from product_spend
where extract(year from transaction_date)='2022' 
and category='appliance'
group by category, product
order by sum(spend) DESC 
limit 2    --retrieve top 2 highest rank from category Appliance
),
ranked_category_electronics as (select category, product, 
sum(spend) as total_spend
from product_spend
where extract(year from transaction_date)='2022' 
and category='electronics'
group by category, product
order by sum(spend) DESC 
limit 2) --top 2 highest rank from category Electronics
  
select category, product, total_spend
from ranked_category_appliance 
UNION ALL  --combine top 2 from 2 CTEs
select category, product, total_spend
from ranked_category_electronics  

/*ex3: query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the case_id column */

with call_counts as 
(
select policy_holder_id, 
count(case_id) as call_counts
from callers 
group by policy_holder_id 
having count(case_id) >=3) --count how many policy_holder having 3 or more calls 
  
select count(policy_holder_id) as policy_holder_count 
from call_counts;

/*ex4: Write a query to return the IDs of the Facebook pages that have zero likes. 
The output should be sorted in ascending order based on the page IDs */

SELECT a.page_id
FROM pages a  --contains page_id, page_name
left join page_likes b on a.page_id=b.page_id --contains user_id, page_id, liked_date
where b.page_id is null --left join to retrieve all page_id from table a and page_id from table b is null=it appears in table a but not in table b bc table 2 contains liked_date info
order by a.page_id asc;

/*ex5: user retention */

with active_user_june as 
( SELECT distinct user_id, extract(month from event_date) as month --1 nguoi co the hoat dong nhieu lan trong 1 thang nen phai dung distinct 
from user_actions 
where event_type in ('sign-in','like','comment')
and extract(month from event_date)='06'
and extract(year from event_date)='2022'  --active users in june
), 
active_user_july as 
(SELECT distinct user_id, extract(month from event_date) as month
from user_actions 
where event_type in ('sign-in','like','comment')
and extract(month from event_date)='07'
and extract(year from event_date)='2022') --active user in July 

select b.month,count(b.user_id) as monthly_active_users
from active_user_june a  
join active_user_july b 
on a.user_id=b.user_id 
group by b.month

/*ex6: SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount */

select date_format(trans_date, '%Y-%m') as month, 
country, 
count(*) as trans_count, 
sum(if(state='approved',1,0)) as approved_count, 
sum(amount) as trans_total_amount, 
sum(if(state='approved',amount,0)) as approved_total_amount
from transactions
group by month, country;

/*ex7: Write a solution to select the product id, year, quantity, and price for the first year of every product sold */

with min_year as 
( 
    select product_id, 
    min(year) as min_year
    from sales 
    group by product_id --find first_year of each product
)
select a.product_id, b.min_year as first_year, a.quantity, a.price
from sales a
join min_year b 
on a.product_id=b.product_id
and a.year=b.min_year; 

/*ex8: Write a solution to report the customer ids from the Customer table that bought all the products in the Product table. */

with distinct_customer as
(
    select distinct customer_id, product_key
    from customer --which products each customer bought 
)
select customer_id 
from distinct_customer
group by customer_id 
having count(*) in (select count(*) from product) --if the number of distinct products a customer has purchased matches the total number of products available.

  --OR: Second Solution for ex8: 

select customer_id
from customer
group by customer_id
having count(distinct product_key)=(Select count(*) from product) --
  
/*ex9: Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company.
When a manager leaves the company, their information is deleted from the Employees table,
but the reports still have their manager_id set to the manager that left.
Return the result table ordered by employee_id. */

select employee_id
from employees
where salary <30000 and manager_id not in 
( 
    select employee_id
    from employees
)
order by employee_id;

/*ex10: Employees can belong to multiple departments.
When the employee joins other departments, they need to decide which department is their primary department. 
Note that when an employee belongs to only one department, their primary column is 'N'.
Write a solution to report all the employees with their primary department. For employees who belong to one department, report their only department. */

select employee_id, department_id
from employee
where primary_flag='Y' or employee_id in 
( select employee_id
from employee
group by employee_id
having count(*)=1)
order by employee_id;

/*ex11: Write a solution to:
- Find the name of the user who has rated the greatest number of movies. In case of a tie, return the lexicographically smaller user name.
- Find the movie name with the highest average rating in February 2020. In case of a tie, return the lexicographically smaller movie name. 
There are 3 tables a,b,c with proper names below. Idea is to create each cte for each condition then combine them */

with cte_greatest_user as --CTE for condition1
(
    select a.name,
    count(movie_id) as movie_counts
    from users a
    join movierating b on a.user_id=b.user_id
    group by a.name
    order by count(movie_id) desc,a.name asc --ALWAYS put aggregate functions in GROUP BY, order by grestes #movies, and by name 
    limit 1),
cte_highest_movie_rating as 
(
    select c.title, 
    avg(b.rating) as total_rating
    from movies c 
    join movierating b on c.movie_id=b.movie_id 
    where extract(month from b.created_at)='02'
    and extract(year from b.created_at)='2020'
    group by c.title
    order by avg(b.rating) desc, c.title asc
    limit 1
)
select name as results
from cte_greatest_user 
union all 
select title as results
from cte_highest_movie_rating;

/ex12: Write a solution to find the people who have the most friends and the most friends number.
The test cases are generated so that only one person has the most friends */

with cte1 as --find the id has most friends
(
    select requester_id as id, count(*) as num
    from requestaccepted
    group by requester_id 
),
cte2 as --find the most friends number
(
    select accepter_id as id, count(*) as num 
    from requestaccepted
    group by accepter_id
),
cte3 as --combine cte1 and cte2 
(
    select id, num from cte1
    union all 
    select id, num from cte2
)
  
select id, sum(num) as num --final table return results from cte3 and sum(num) 
from cte3
group by id
order by num desc 
limit 1

    --OR: Second way to shorten the code

with cte as 
(
  select requester_id as id from requestaccepted
  union all
  select accepter_id as id from requestaccepted
)
select id, count(*) as num 
from cte 
group by id
order by num desc
limit 1












