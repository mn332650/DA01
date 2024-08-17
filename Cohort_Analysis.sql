/* Cohort Analysis Concept: 
- How to keep customer's retention?
- When is the best time to reconnect with users?
- When is the best time to bring back the marketing campaign?

COHORT ANALYSIS (PHAN TICH TO HOP):  behavioral analytics in which you take a group of users, 
and analyze their usage patterns in a certain time period based on their shared 
traits to better track, understand their experience and then improve them.

HOW TO READ COHORT ANALYSIS CHART:
- First left column (size): example: weekly, monthly, etc
- Top horizontal row: number of months
- 1st way - Horizontal: 
     + Used when: de biet so luong kh con lai moi thang sau thoi gian mua dich vu/ san pham lan dau tien.
     + The hien thoi gian ton tai cua nguoi dung, so luong kh con lai sau n thang
- 2nd way - Vertical: 
     + Cho thay su cai thien ve san pham cua minh theo thoi gian ntn?
     + Used when: khi can biet ty le quay lai cua kh co tot hon theo thoi gian hay khong
                (ban co dang giu chan tot nhung nhom kh moi gan day so voi kh cu hay khong?)
- 3rd way - Diagonal:
     + The hien con so thuc su mua hang tung thang 

CALCULATION: 
1/ Customer retention = so luong kh quay lai @n thang/ $thang dau tien(first colum)
(KH come back)

2/ Customer Churn= 1-Customer retention rate
(KH left)

3/ Net dollar( or net revenue) retention= n/ $gia tri first month */

/* B1: EXPLORE and CLEAN DATA
- Chung ta dang quan tam den truong nao?
- Check null
- Chuyen doi kieu du lieu
- So tien va so luong >0
- Check dup */

--541909 records, 135080 records of customerid null

select count(*) from online_retail --check how many records are there in a table

Select * from online_retail
where customerid='';-- check null values

Select count(*) from online_retail
where customerid=''; -- clean null values steps!!!

Select * from online_retail
where customerid<>''; -- values that are not null














