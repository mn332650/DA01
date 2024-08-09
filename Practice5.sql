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


