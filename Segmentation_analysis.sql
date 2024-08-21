/* Segmentation Analysis (phan loai kh): chien luoc phan tich, chia nho kh thanh nhung nhom doi tuong co chung cac dac diem va tieu chi
Include: Demographics (nhan khau), geographic (dia li), psychologic (tam li), behavioral (hanh vi)

RFM (Recency - Frequency - Monetary):
    + Lan gan day kh giao dich? 
    + KH co thuong xuyen giao dich khong?
    + Moi lan KH giao dich bao nhieu tien?

B1: Tinh gia tri R-F-M
1. Recency: khoang thoi gian tinh tu lan cuoi giao dich toi hien tai.
R= ngay phan tich - ngay giao dich gan nhat
2. Frequency: tan suat giao dich
F= tong so lan mua hang/(ngay giao dich gan nhat - ngay giao dich dau tien)
3. Monetary: tong so tien KH da chi tra
M= cong gop so tien ma KH da thanh toan

B2: chia cac gia tri thanh cac khoang tren thang diem 1-5(refer to Q1, Q2, Q3 and IQR)
B3: Phan nhom theo 125 to hop E-F-M (5 groups R, 5 Fs, 5 Ms = 5x5x5)
B4: Truc quan phan tich RFM: answer which customer group is the biggest
B5: Dua vao phan tich RFM va dua ra marketing campaigns

-Group 1: Champions: frequent purchases and high retention rate > de xuat chuong trinh than thiet voi gia tri khac biet va tinh ca nhan hoa cao
-Group 2: Loyal Customers and Potential Loyalist > chuong trinh uu dai gan lien voi cac nguong chi tieu hoac chuong trinh gioi thieu ban be
-Group 3: Recent Customers & Promising Customers > How to make them become loyal > Business create quy trinh cham soc bai ban va duoc ca nhan hoa cao de tao dung mqh
-Group 4: Customers Needing Attention & At Risk > Why customers used to buy but not buy anymore ? Research to find reasons
-Group 5: Customers About To Sleep, Hibernating & Lost > retargeting campaigns, short promotion like discount, voucher, etc */

EXAMPLE: 
--B1: find R-F-M
--R= ngay phan tich - ngay giao dich gan nhat (max(order_date))
--F=tong so lan mua hang/(ngay giao dich gan nhat - ngay giao dich dau tien) --count(order_id)
--M=cong gop so tien ma KH da thanh toan

with customer_RFM as 
(
select a.customer_id, 
current_date-max(order_date) as R,
count(distinct order_id) as F, 
sum(sales) as M
from customer a
join sales b on a.customer_id=b.customer_id
group by a.customer_id),

--B2: chia cac gia tri thanh cac khoang tren thang diem 1-5
RFM_score as
	(select customer_id, 
ntile(5) over(order by R desc) as R_score, --the bigger R is=big gap from last transaction
ntile(5) over(order by F asc)	as F_score,
ntile(5) over(order by M asc) as M_score
from customer_RFM
)

--B3: Phan nhom theo 125 to hop R-F-M
, rfm_final as 
	(
	select 
customer_id,
cast(r_score as varchar)||cast(F_score as varchar)||cast(m_score as varchar) as RFM_score --can't substring int > cast to varchar
from rfm_score)

select segment, count(*) from --count #customers each segment
(select a.customer_id, b.segment
from rfm_final a join segment_score b on a.rfm_score=b.scores) as a --phan nhom customer to each segment
group by segment
order by count(*) 

--Insights: At risk group is the most=customers used to buy but don't come back
--Focus on champions group!

--B4: truc quan phan tich RFM - bieu do Hitmap
--Download excel > insert > chart >treemap (top row, middle chart)





