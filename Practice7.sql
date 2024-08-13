/*ex1: Assume you're given a table containing information about Wayfair user transactions for different products. 
Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.
The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage,
rounded to 2 decimal places*/

with cte_prev_spend AS
(
select extract(year from transaction_date) as year,
product_id, 
spend as curr_year_spend,
lag(spend) over(partition by product_id order by extract(year from transaction_date)) as prev_year_spend
from user_transactions
) 
select year, 
product_id, 
curr_year_spend, 
prev_year_spend, 
round((curr_year_spend-prev_year_spend)/prev_year_spend*100,2) as yoy_rate
from cte_prev_spend;


