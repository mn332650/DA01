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


--MID_COURSE TEST
/*Q1: Tạo danh sách tất cả chi phí thay thế (replacement costs )  khác nhau của các film.
Question: Chi phí thay thế thấp nhất là bao nhiêu? */
Select distinct replacement_cost
from film
order by replacement_cost asc; --9.99

/*Q2: : Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim 
có chi phí thay thế trong các phạm vi chi phí sau
1.	low: 9.99 - 19.99
2.	medium: 20.00 - 24.99
3.	high: 25.00 - 29.99
Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”? */
select
case when replacement_cost between '9.99' and '19.99' then 'Low'
	when replacement_cost between '20.00' and '24.99' then 'Medium'
	else 'High'
end as category,
count(*) as quantity
from film
group by category; --514

/*Q3: Tạo danh sách các film_title 
bao gồm tiêu đề (title), độ dài (length) và tên danh mục (category_name) 
được sắp xếp theo độ dài giảm dần. 
Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.
Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu? */

select a.title, a.length, c.name as category
from film a 
join film_category b on a.film_id=b.film_id
join category c on b.category_id=c.category_id
where c.name='Drama' or c.name='Sports'
order by a.length desc; --Sports: 184

/*Q4: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).
Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim? */

select c.name as category, count(a.title) as quantity
from film a 
join film_category b on a.film_id=b.film_id
join category c on b.category_id=c.category_id
group by c.name
order by count(a.title) desc; --Sports: 74 titles

/*Q5: Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên
cũng như số lượng phim họ tham gia.
Question: Diễn viên nào đóng nhiều phim nhất?
Answer: Susan Davis : 54 movies*/

select a.first_name, a.last_name,
count(b.film_id) as movie_quantity
from actor a
join film_actor b on a.actor_id=b.actor_id
group by a.first_name, a.last_name
order by count(b.film_id) desc; --Susan Davis: 54 

/*Q6: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.
Question: Có bao nhiêu địa chỉ như vậy? */

select count(a.address_id) as quantity
from address a
left join customer c on a.address_id=c.address_id
where c.address_id is null; --Quantity=4

/*Q7: : Danh sách các thành phố và doanh thu tương ừng trên từng thành phố 
Question:Thành phố nào đạt doanh thu cao nhất?
Answer: Cape Coral : 221.55 */

select a.city, sum(d.amount) as amount
from city a
join address b on a.city_id=b.city_id
join customer c on b.address_id=c.address_id
join payment d on c.customer_id=d.customer_id
group by a.city
order by sum(d.amount) desc;  --CAPE CORAL: 221.55




