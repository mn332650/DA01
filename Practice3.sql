/*Ex1: Name of any student in STUDENTS who scored higher thanb 75Marks. Order your output by the last three characters of each name.
If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.),
secondary sort them by ascending ID */

select name
from students 
where marks>75
order by right(name,3), ID asc;

/*Ex2: Fix the names so that only the first character is uppercase and the rest are lowercase.
Return the result table ordered by user_id */

select user_id, 
concat (upper(left(name,1)),lower(right(name,length(name)-1))) as name
from users
order by user_id;

--(upper(left(name,1)) -- lay chu cai dau tien (left) va viet hoa 
--right(name,length(name)-1))-- lay cac chu cai dem tu ben phai qua using right(string, vi tri cua letter),
                             -- length(name)-1: vi tri cua the rest of name, lay do dai cua 'name' minus 1=minus first letter

/*Ex3:  calculate the total drug sales for each manufacturer.
Round the answer to the nearest million and report your results in descending order of total sales. 
In case of any duplicates, sort them alphabetically by the manufacturer name */

SELECT manufacturer,
concat('$',round(sum(total_sales)/1000000,0),' ','million') as sale
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer;










