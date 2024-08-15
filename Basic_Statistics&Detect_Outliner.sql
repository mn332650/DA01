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














