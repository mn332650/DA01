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

