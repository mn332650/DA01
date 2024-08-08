/*CITY and COUNTRY tables, 
query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population)
rounded down to the nearest integer */

select a.continent, floor(avg(b.population)) as avg_population --question require ROUND DOWN--
from country a
join city b on a.code=b.countrycode
group by a.continent
order by round(avg(b.population),0) asc
