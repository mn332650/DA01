/* 1. Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm) , total_user, total_orde
Insight là gì? ( nhận xét về sự tăng giảm theo thời gian) */

select  FORMAT_DATE("%Y-%m",created_at) as month_year,
count(distinct user_id) as total_users,
count(order_id) as total_orders
from bigquery-public-data.thelook_ecommerce.orders
where 
created_at between '2019-01-01' and '2022-04-30'
group by 1
order by 1 asc;

--Insight: the number of total users and total orders increase significantly from 01/2019 to 04/2022.
--It reaches its peak in March 2023 with 1508 users and 1538 orders placed. */

/* 2. Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng 
( Từ 1/2019-4/2022)
Output: month_year ( yyyy-mm), distinct_users, average_order_value */

select  FORMAT_DATE("%Y-%m",a.created_at) as month_year,
count(distinct a.user_id) as distinct_users,  --tong so nguoi dung
round((sum(b.sale_price)/count(a.order_id)),2) as average_order_value --gia tri trung binh 
from bigquery-public-data.thelook_ecommerce.orders as a 
join bigquery-public-data.thelook_ecommerce.order_items as b
on a.user_id=b.user_id
where a.created_at between '2019-01-01' and '2022-04-30'
group by 1
order by 1 asc;

--Insights: the average order value remain fairly stable from 01/2019 to 04/2022 ranging $54.48 to $69.96.

/* 3. Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất) */

with cte_category as 
(select gender, min(age) as min_age, max(age) as max_age 
from bigquery-public-data.thelook_ecommerce.users
group by gender), --cte query min age and max age group by gender
cte_youngest as 
(select a.gender, a.age, count(*) as count, 'youngest' as tag
from bigquery-public-data.thelook_ecommerce.users a
join cte_category b on a.gender=b.gender 
where a.age=b.min_age
and created_at between'2019-01-01' and '2022-04-30'
group by a.gender, a.age), -- cte query total youngest users group by gender
cte_oldest as 
(select a.gender, a.age, count(*) as count, 'oldest' as tag
from bigquery-public-data.thelook_ecommerce.users a
join cte_category b on a.gender=b.gender 
where a.age=b.max_age
and created_at between'2019-01-01' and '2022-04-30'
group by a.gender, a.age) --cte query total oldest users group by gender
select * from cte_youngest
union all
select * from cte_oldest;

--Insight: The youngest age recorded is 12-year-old with 457 females and 467 males. Whereas, 70 is the oldest age with 511 females and 487 males.  

/* 4. Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
Hint: Sử dụng hàm dense_rank() */

with cte_prod_profit as --calculate sales, cost, profit of each product_id in time period 
(select format_date('%Y-%m',a.created_at) as month_year, a.product_id, b.name as product_name,   --Y in capital letter to make the right format
round(sum(a.sale_price),2) as sales, --total doanh thu
round(b.cost,2) as cost, --expense
round(sum(a.sale_price)-sum(b.cost),2) as profit --loi nhuan
from bigquery-public-data.thelook_ecommerce.order_items a
join bigquery-public-data.thelook_ecommerce.products b
on a.id=b.id
where created_at between '2019-01-01' and '2022-04-30'
group by format_date('%Y-%m',a.created_at), a.product_id, b.name, b.cost),
cte_high_profit as 
(
select *,
dense_rank() over(partition by month_year order by profit desc) as rank_per_month --rank profit of each product_id group by month_year
from cte_prod_profit)
select * 
from cte_high_profit 
where rank_per_month <=5
order by month_year asc;

/* 5. Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
Output: dates (yyyy-mm-dd), product_categories, revenue */

with cte_revenue as 
(select format_date('%Y-%m-%d',a.created_at) as dates,
b.category,
round(sum(a.sale_price),2) as total_revenue 
from bigquery-public-data.thelook_ecommerce.order_items a 
join bigquery-public-data.thelook_ecommerce.products b 
on a.id=b.id
group by format_date('%Y-%m-%d',a.created_at), b.category
order by dates asc)  --total revenue by dates
select * 
from cte_revenue
where date(dates) BETWEEN date_sub(date '2022-04-15', INTERVAL 3 MONTH) AND date '2022-04-15'
order by dates asc --filter out the dates

/* PART 2: */ 

with cte_index as 
(select user_id, amount, 
format_date('%Y-%m',first_purchase_date) as cohort_date,
created_at,
(extract(year from created_at)-extract(year from first_purchase_date))*12
+ (extract(month from created_at)-extract(month from first_purchase_date))+1 as index
from 
(select user_id, 
round(sale_price,2) as amount, 
min(created_at) over(partition by user_id) as first_purchase_date,
created_at
from bigquery-public-data.thelook_ecommerce.order_items)
),
  
xxx as
(
select cohort_date, index, count(distinct user_id) as cnt, 
round(sum(amount),2) as revenue,
from cte_index
group by cohort_date, index),
customer_cohort as 
  
(
select cohort_date,
sum(case when index=1 then cnt else 0 end ) as m1,
sum(case when index=2 then cnt else 0 end ) as m2,
sum(case when index=3 then cnt else 0 end ) as m3
from xxx
group by cohort_date
order by cohort_date)
  
, retention_cohort as (
select cohort_date, 
round(100.00* m1/m1,2)||'%' as m1,
round(100.00* m2/m1,2)|| '%' as m2,
round(100.00* m3/m1,2) || '%' as m3
from customer_cohort)
  
select cohort_date,
(100-round(100.00* m1/m1,2))||'%' as m1,
(100-round(100.00* m2/m1,2))|| '%' as m2,
(100-round(100.00* m3/m1,2)) || '%' as m3
from retention_cohort

/*PART 2: Find Metrics based on dataset */

select month, year, product_category, tpv, tpo, 
round((tpv-lag(tpv) over(order by month, year)*100)/tpv,2)||'%' as revenue_growth,
round((tpo-lag(tpo) over(order by month,year)*100)/tpo,2)||'%' as order_growth,
total_cost, 
round(tpv-total_cost,2) as total_profit, 
round(tpv/total_cost,2) as profit_to_cost_ratio 
from 
(
select 
extract(month from a.created_at) as month,
extract(year from a.created_at) as year, 
c.category as product_category, 
round(sum(b.sale_price),2) as TPV, 
count(b.order_id) as TPO,
round(sum(c.cost),2) as total_cost
from bigquery-public-data.thelook_ecommerce.orders a
join bigquery-public-data.thelook_ecommerce.order_items b on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products c on b.id=c.id
group by extract(month from a.created_at),
extract(year from a.created_at), c.category)


