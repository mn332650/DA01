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
