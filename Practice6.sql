/*ex1: Write a query to retrieve the count of companies that have posted duplicate job listings.
Definition:
Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions */

with duplicate_jobs as 
(
select company_id,title,description, 
count(job_id) as job_counts
from job_listings
group by company_id, title, description --which companies have duplicate jobs, job count number 
)
select count(distinct company_id) as duplicate_companies
from duplicate_jobs
where job_counts>1 --don't have group by after bc use count right after SELECT 

/*ex2: */



/*ex3: query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the case_id column */

with call_counts as 
(
select policy_holder_id, 
count(case_id) as call_counts
from callers 
group by policy_holder_id 
having count(case_id) >=3) --count how many policy_holder having 3 or more calls 
select count(policy_holder_id) as policy_holder_count 
from call_counts;

/*ex4: Write a query to return the IDs of the Facebook pages that have zero likes. 
The output should be sorted in ascending order based on the page IDs */

SELECT a.page_id
FROM pages a  --contains page_id, page_name
left join page_likes b on a.page_id=b.page_id --contains user_id, page_id, liked_date
where b.page_id is null --left join to retrieve all page_id from table a and page_id from table b is null=it appears in table a but not in table b bc table 2 contains liked_date info
order by a.page_id asc;














