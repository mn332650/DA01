/* Basic Statistics Definitions: 
1/ Descriptive VS Inferential Statistics
- Thong ke mo ta (Descriptive): mo ta ket qua nghien cuu through charts, dashboards, etc.
- Hai thuoc do chinh:
     + Xu huong tap trung: trung binh, trung vi, yeu vi
     + Do phan tan: phuong sai, do lech chuan, khoang

- Thong ke suy luan (Inferential): suy luan ra tinh chat cua tong the, bao gom cac gia 
thuyet thu nghiem va cac uoc tinh phat sinh. 
      + Phuong phap: tuong quan, hoi quy

2/ Tong the (Population) va mau (Sample), thong ke va tham so (Parameter)
- Population: bao gom tat ca doi tuong cua nghien cuu
     + Paramater describe population. 
     + Trung binh - Mean(y), Std dev - Do lech chuan (sigma), sample size determination (N)
- Sample: la tap con lay ra from population 
     + Statistics singular describe sample
     + Trung binh - Mean(x), Do lech chuan - standard deviation(s), Co mau-sample size determination(n)

3/ Trung binh - Mean, trung vi - Median, yeu vi - Mode
- Mean = average
- Median: middle value in a sorted dataset
      + Find a median: sort the data asc > Odd number: median=middle number > Even number: median=avg(2 middle numbers)
- Mode: value that occurs most frequently. 1 sample can have 1 or more modes

4/ Khoang (Range), Phuong sai (Variance), Do lech chuan (Standard Deviation)
- All are measures for disperison

- Cong thuc tinh variance (phuong sai) for sample & population (in notebook)
- Standard deviation (do lech chuan): do lech trung binh giua cac quan sat rieng le trong mot phan phoi 
va gia tri trung binh cua mot mau

- Range: su khac biet giua gia tri quan sat lon nhat & nho nhat cua mot mau
- Khoang tu phan vi - Interquartile Range (IQR)
      + IQR: hieu so giua phan vi thu 3 (Q3=75%) va phan vi thu nhat (Q1=25%) 
      + Phan vi thu 2 (Q=50%) chinh la trung vi
- Percentile (bach phan vi): percentile thu p la data ma tai do p% nho hon va (100-p)% data lon hon
      + Percentitle thu 50 chinh la trung vi (median)
      + Find a percentile: sort data asc > n=p% x #data and round up to next int > count from left to right for 'n' > from n, numbers on the right is n percentitle, numbers on the left are (100-n) percentitle 
- Quartile (tu phan vi): Q1 (percentile 25th), Q2 (trung vi-percentile 50), Q3 (percentle 75th)
- Interquatile Range (IQR) = Q3 - Q1

5/ Box Plot: a graph summarising a set of data (google for more images & references)
- Define Q1(25% p), Q2(50% p), Q3(75% p)
- Draw a line > put Q1,2,3 number to a horizontal line > mark verticle lines on top of each percentile
> connect the vertical lines making a box > mark the smallest & biggest number on the horizontal line 
> mark a dot on top of them and make the lines to the box created for IQR (reference: D18, 1)

6/ Phan phoi chuan - Normal Distribution
- Normal distribution: la su phan bo du lieu ma do do gia tri tap trung nhieu nhat o khoang giua va cac gia tri 
con lai rai deu doi xung ve phia cac diem cuc tri. 
- Features: symmetric, mean/ median/ mode are the same
- Read a ND graph: follow rule 68-95-99.7 (3 sigma)
        + u: trung binh, sigma: do lech chuan 
        + 68.27% data range from u-sigma to u+sigma
        + 95.45% data range from u-2sigma to u+2sigma
        + 99.73% data range from u-3sigma to u+3sigma

7/ Z-Score: phuong phap chuan hoa bang cach chuyen gia tri ban dau sang thanh diem do lech chuan
Z=(Observed value-mean)/ std dev 
Z=(gia tri quan sat - trung binh)/ do lech chuan 

- What Z-Score used for? 
        + calculate % of percentile
        + compare 2 observed values with different scoring system
        + detect outlier

8/ Detect Outlier:
- Where outlier from?
        + Loi phat sinh trong qua trinh nhap va chinh sua du lieu > bad data need to be discarded to increase the accuracy of model or reports
        + An event that creates significant increase/decrease in data > potential 
- Ways to detect Outlier: Boxplot (back to 5/) & Z-Score (back to 7/)
- More notes in notebook

/* Detect Outlier in SQL */

select * from user_data;

--Use IQR/BOXPLOT to detect outlier
--B1: Find Q1, Q3, IQR
--B2: find min=Q1-1.5*IQR, max=Q3+1.5*IQR

With c as
(
	select
	Q1-1.5*IQR as min_value, 
	Q3+1.5*IQR as max_value
	from (
	select 
	percentile_cont(0.25) within group(order by users) as Q1,-- find Q1
	percentile_cont(0.75) within group(order by users) as Q3,-- find Q3
	percentile_cont(0.75) within group(order by users)-percentile_cont(0.25) within group(order by users) as IQR
	from user_data
	)
	as a
	)

--B3: xac dinh outlier <min or >max

select * from user_data
where users< (select min_value from twt_min_max_value)
or users> (select max_value from twt_min_max_value);

--USE Z-Score to detect outliers =(users-avg)/std dev

select avg(users),
stddev(users) 
from user_data;


with cte as 
(
select data_date,
users,
(select avg(users)
from user_data) as avg,
(select stddev(users) 
from user_data) as stddev
from user_data) 
, twt_outlier as (	
select data_date, users, (users-avg)/stddev as z_score
from cte
where abs((users-avg)/stddev)>3) --find outlier

update user_data 
set users=(select avg(users) from user_data)
where users in (select users from twt_outlier);  --update outlier values = avg 

delete from user_data 
where users in (select users from twt_outlier); -- delete the old table with outlier 

/*CLEAN DATA CHECKLIST 
1/ Xoa cac quan sat trung lap hoac khong lien quan
2/ Sua loi cau truc (loi chinh ta or viet hoa khong chinh xac)
3/ Loc outlier
4/ Xu ly du lieu thieu */

--Tim address bi trung lap, loai ban ghi cu hon














