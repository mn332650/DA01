/*ex1: list of CITY names from STATION for cities that have an even ID number
Print the results in any order, but exclude duplicates from the answer */
select distinct city 
from station
where ID%2=0 
--ex2:  difference between the total number of CITY entries in the table and the number of distinct CITY
select count(city) - count(distinct(city)) as difference
from station
--ex3: 





/*ex4:find the mean number of items per order on Alibaba,
rounded to 1 decimal place using tables which includes information on the count of items*/ 
SELECT round(cast(sum(item_count*order_occurrences)/sum(order_occurrences)  
as decimal),1) as mean
FROM items_per_order;

--ex5: candidates who are proficient in Python, Tableau, and PostgreSQL, sort asc
SELECT candidate_id
FROM candidates
where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill) =3
order by candidate_id asc;

/*ex6: ach user who posted at least twice in 2021,
write a query to find the number of days between
each user’s first post of the year and last post of the year in the year 2021 */
SELECT user_id, date(max(post_date))-date(min(post_date))
as days_between
FROM posts
where post_date>='2021-01-01' and post_date <'2022-01-01'
group by user_id
having count(post_id)>=2;

/*ex7:  name of each credit card and the difference in the number of issued cards
between the month with the highest issuance cards and the lowest issuance */
SELECT card_name, 
max(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference desc;

/*ex8:Output the manufacturer's name, the number of drugs associated with losses, 
and the total losses in absolute value */
SELECT distinct manufacturer,
count(drug) as drug_count,
abs(sum(total_sales-cogs)) as total_loss
FROM pharmacy_sales
where total_sales < cogs
group by manufacturer
order by total_loss desc;

--ex9: movies with an odd-numbered ID and a description that is not "boring"
select *
from cinema
where id%2=1 and description <> 'boring'
order by rating desc;

--ex10:number of unique subjects each teacher teaches in the university
select teacher_id, 
count(distinct subject_id) as cnt
from teacher
group by teacher_id;

--ex11:each user, return the number of followers
select user_id, 
count(follower_id) as followers_count
from followers
group by user_id
order by user_id asc;

--ex12: class has at least 5 students
select class
from courses
group by class
having count(student) >=5;







