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




