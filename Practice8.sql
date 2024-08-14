/*ex1: If the customer's preferred delivery date is the same as the order date, then the order is called immediate; otherwise, it is called scheduled.
The first order of a customer is the order with the earliest order date that the customer made. It is guaranteed that a customer has precisely one first order.
Write a solution to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places. */

With cte_first_order_date as 
(
    select customer_id, 
    min(order_date) as date1
    from delivery
    group by customer_id --find the first order date of each customer
)
select 
round(avg(case when a.date1=b.customer_pref_delivery_date then 1 else 0 end)*100,2)
as immediate_percentage
from delivery b 
join cte_first_order_date a
on a.customer_id=b.customer_id
and a.date1=b.order_date;

/*ex2: Write a solution to report the fraction of players that logged in again on the day after the day they first logged in,
rounded to 2 decimal places. In other words, you need to count the number of players that logged in
for at least two consecutive days starting from their first login date, then divide that number by the total number of players*/

with cte_first_login_date as 
(
select player_id, 
 min(event_date) as date1
 from activity
 group by player_id      --find the first login date for each player
)
select 
round(sum(datediff(b.event_date,a.date1)=1)/ count(distinct b.player_id),2) as fraction  
from cte_first_login_date a
join activity b on a.player_id=b.player_id                                                                                                             

/*ex3: Write a solution to swap the seat id of every two consecutive students.
If the number of students is odd, the id of the last student is not swapped.
Return the result table ordered by id in ascending order. */

with seat_rank as 
(
select id, student, 
row_number() over(order by id) as seat_rank
from seat --rank the seat number order by student id
)  
select id, 
coalesce( --return the first non-null value in the list
    case when seat_rank%2=0 then lag(student) over()         --even number, return the previous stud
    else lead(student) over()                                --else=odd number, return the next student
    end, student) as student
from seat_rank;


/*ex4: restaurant growth 
You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).
Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). 
average_amount should be rounded to two decimal places.
Return the result table ordered by visited_on in ascending order. */

select
    a.visited_on as visited_on,
    sum(amount) as amount,
    round(sum(amount)/7, 2) as average_amount
from
(select distinct visited_on from Customer) a
left join Customer b
on datediff(a.visited_on, b.visited_on) >= 0 --first day
and datediff(a.visited_on, b.visited_on) <= 6  --after 6 days
group by a.visited_on
having count(distinct b.visited_on) = 7
order by visited_on;

/*ex8: Write a solution to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.
Return the result table in any order. */

with cte as
(
    select *, 
    dense_rank() over(partition by product_id order by change_date desc) as rn from products --rank *, phan cum by product_id, order by change_date desc so we will get the biggest value in the main code
    where change_date <='2019-08-16'
)
select product_id, 
new_price as price
from cte
where rn=1   --top value of each partition, top 1
union
select product_id, 10 --if product id not in the cte, then product_id will go with 10 price
from products
where product_id not in (select product_id from cte);












