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

/*ex2: Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. 
The launch month is the earliest record in the monthly_cards_issued table for a given card.
Order the results starting from the biggest issued amount. */

SELECT
distinct card_name, 
first_value(issued_amount) over(partition by card_name order by issued_amount, issue_month) 
as issued_amount
from monthly_cards_issued
order by issued_amount desc;

/*ex3: Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date. */

with cte_date_rank as 
(
SELECT user_id, spend,
transaction_date, 
rank() over(partition by user_id order by transaction_date) as rank_date --phan cum by user_id and sap xep theo transaction date
from transactions
)
select user_id, spend, transaction_date
from cte_date_rank 
where rank_date=3; --get all the info from 3rd transaction date

/*ex4: Assume you're given a table on Walmart user transactions.
Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.
Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date. */

with cte_recent_date as 
( 
SELECT transaction_date, 
user_id, 
spend, product_id,
rank() over(partition by user_id order by transaction_date desc) as rank_date --phan cum by user_id, sap xep theo date desc
from user_transactions --sap xep transaction_date desc, most recent date=top 1
)
select transaction_date,
user_id, 
count(product_id) as purchase_count 
from cte_recent_date
where rank_date=1
group by transaction_date, user_id;

/*ex5: rolling tweets */






/*ex6: */





/*ex7: write a query to identify the top two highest-grossing products within each category in the year 2022. 
The output should include the category, product, and total spend. */

with cte as 
(
select category, 
product,
sum(spend) as spend,
rank() over(partition by category order by sum(spend) desc) as spend_rank
from product_spend
where extract(year from transaction_date)='2022'
group by category, product
)
select category, product, spend as total_spend
from cte 
where spend_rank <=2;

/*ex8: top 5 artists 
Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. 
Display the top 5 artist names in ascending order, along with their song appearance ranking.
If two or more artists have the same number of song appearances, they should be assigned the same ranking, 
and the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5). */

with cte_frequent_songs as 
(
    SELECT a.artist_name, COUNT(c.rank) AS song_appearances,
    DENSE_RANK() OVER(ORDER BY COUNT(c.rank) DESC) as artist_rank
    FROM artists a
    JOIN songs b  ON a.artist_id =b.artist_id 
    JOIN global_song_rank c  ON b.song_id = c.song_id
    WHERE c.rank <= 10
    GROUP BY a.artist_name
)
select artist_name, 
artist_rank
from cte_frequent_songs
where artist_rank <=5

















