/* 1.Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE */

select year_id, 
	productline, 
	dealsize, 
	sum(sales) as revenue
from sales_dataset_rfm_prj_clean
group by productline, year_id, dealsize
order by year_id

/* 2. Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER*/
select month_id, year_id, revenue, order_number
from 
(select month_id, year_id, count(ordernumber) as order_number, 
sum(sales) as revenue, 
row_number() over(partition by year_id order by sum(sales) desc) as rank_per_month
from sales_dataset_rfm_prj_clean 
group by month_id, year_id
order by year_id, revenue desc) as a
where rank_per_month=1;
--Best months: 11/2023, 11/2004, 5/2005

/* 3. Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER */
select month_id, year_id, productline, order_number, revenue
from 
(select month_id, year_id, productline, count(ordernumber) as order_number, 
sum(Sales) as revenue, 
row_number() over(partition by year_id order by sum(sales) desc) as rank 
from sales_dataset_rfm_prj_clean
where month_id=11
group by month_id, year_id, productline
order by year_id, revenue desc) as a
where rank=1;
--Both November 2003 and 2004, Classic Cars are the best seller product line. No result for 2005

/* 4. Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK */

select year_id, productline, revenue, rank
from 
(select year_id, productline, sum(sales) as revenue,
rank() over(partition by year_id order by sum(sales) desc) as rank 
from sales_dataset_rfm_prj_clean
where country='UK'
group by year_id, productline) as a
where rank=1
--2003: classic cars, 2004: classic cars, 2005: motocycles

/* 5. Ai là khách hàng tốt nhất, phân tích dựa vào RFM */
--B1: Find R-F-M

with customer_rfm as 
(select 
	customername,
current_date-max(orderdate) as R,
count(distinct ordernumber) as F, 
sum(sales) as M
from sales_dataset_rfm_prj_clean 
group by customername)

--B2: chia cac gia tri thanh cac khoang tren thang diem 1-5
, rfm_score as 
(select customername,
ntile(5) over(order by r desc) as r_score,
ntile(5) over(order by f desc) as f_score,
ntile(5) over(order by m desc) as m_score
from customer_rfm)

--B3: phan nhom theo 124 to hop RFM
, rfm_final as (select customername,
cast(r_score as varchar)||cast(f_score as varchar)||cast(m_score as varchar) as rfm_score
from rfm_score)

select customername, segment from 
(select a.customername, b.segment 
from rfm_final a
join segment_score b on a.rfm_score=b.scores) as a
where segment='Champions'

--4 best customers are: Mini Auto Werke, Austrilian Gift Network, Boards&Toys Co, Austrilian Collectables






