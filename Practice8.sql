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
