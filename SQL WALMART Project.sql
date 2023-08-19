create schema walmart;
create database IF NOT EXISTS walmartsales;
create table IF NOT EXISTS sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null, 
city varchar(30) not null, 
customer_type varchar(30) not null,
gender varchar(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float4 not null, 
total decimal(12,4) not null, 
date datetime not null,
time TIME not null,
payment_method varchar(15) not null,
cogs decimal(10,2) not null,
gross_margin_pct float8, 
gross_income decimal(12,4) not null,
rating float
 );
select * from sales;

/*-- --------------------------feature engineering-------------------------------------------------------
- ----------------------------------------------------------------------------------------------------

-- adding column time-of-day*/

select 
time,
(case 
when time between '00:00:00' and '12:00:00' then "Morning"
when time between '12:01:00' and '16:00:00' then "Afternoon"
else "Evening"
end)
as time_of_date
from sales; 

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
case 
when sales.time between "00:00:00" and "12:00:00" then "Morning"
when sales.time between "12:01:00" and "16:00:00" then "Afternoon"
else "Evening"
end);
  
-- adding column day_name
select date,
dayname(date)
from sales;

alter table sales add column day_name varchar(10);
update sales
set day_name= dayname(date);

-- adding column month_name
 select date,
 monthname(date)
 from sales;
 
 alter table sales add column month_name varchar(10);
 update sales
 set month_name = monthname(date);
 
 -- ---------------------------EXPLORATORY DATA ANALYSIS----------------------------------------
 -- --------------------------------------------------------------------------------------------
 -- -------------------------business questions-------------------------------------------------
 
 -- -------------------------------GENERIC-----------------------------------------------------
 -- how many unique cities and branches does the data have?
 select distinct city from sales;
 
 select distinct branch from sales;
 -- in which city is each branch?
 select distinct city, branch from sales;
 
 -- ------------------------------PRODUCT-------------------------------------------------------
 
 -- How many unique product lines does the data have?
 select count(distinct product_line) from sales;
 
 -- what is the most common payment method?
 select payment_method, count(payment_method) as cnt from sales group by payment_method order by cnt desc;
 
 -- what is the most selling product_line?
select product_line, count(product_line) as cnt from sales group by product_line order by cnt desc;

-- what is the total revenue by month?
select month_name as month,
sum(total) as total_revenue 
from sales 
group by month_name
order by total_revenue desc;

-- what month had the largest COGS?
select month_name as month,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- what product had the largest revenue?
select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- what city has the largest revenue?
select branch,city,
sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;

-- what product line has the largest vat?
select product_line,
avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;
 
 -- which branch sold more products than average products sold?
 select branch,
 sum(quantity) as qty
 from sales 
 group by branch
 having sum(quantity) > (select avg(quantity) from sales);
 
 -- what is the most common product_line by gender?
 select gender,
 product_line,
 count(gender) as total_cnt
 from sales group by gender, product_line
 order by total_cnt desc;
 
 -- what is the average rating of each product line?
 select round(avg(rating),2) as avg_rating,
 product_line 
 from sales
 group by product_line
 order by avg_rating desc;
 
 -- -----------------------SALES-------------------------------------------------------
 -- -----------------------------------------------------------------------------------
 -- number of sales made in each time of the day per weekday?
 select 
 time_of_day,
 count(*) as total_sales 
 from sales
 group by time_of_day
 order by total_sales desc;
 
 -- which of the customer type brings the most revenue?
 select customer_type,
 sum(total) as total_rev
 from sales
 group by customer_type
 order by total_rev desc;
 
 -- which city has the largest VAT?
 select city,
 avg(VAT) as vat
from sales
group by city
order by vat desc;

-- which customer type pays the most in VAT?
 select customer_type,
 avg(VAT) as vat
 from sales
 group by customer_type
 order by vat desc; 
 
 -- ------------------------------CUSTOMERS---------------------------------------------
 -- ------------------------------------------------------------------------------------
 
 -- how many unique customer types does the data have?
 select distinct customer_type
 from sales;
 
 -- how many unique payment methods does the data have?
  select distinct payment_method
 from sales;
 
 -- which customer type buys the most?
select customer_type,
count(*) as cstm_cnt
from sales
group by customer_type;

-- what is the gender of the most customers?
select gender,
count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- what is the gender distribution per branch?
select gender,
count(*) as gender_cnt
from sales
where branch= "A"
group by gender
order by gender_cnt desc;

select gender,
count(*) as gender_cnt
from sales
where branch= "B"
group by gender
order by gender_cnt desc;

select gender,
count(*) as gender_cnt
from sales
where branch= "C"
group by gender
order by gender_cnt desc;

-- What time of the day do the customers give most ratings?
select time_of_day,
avg(rating) as avg_rating
from sales 
group by time_of_day
order by avg_rating desc;

-- which tme of the day do the customers give most ratings for branch C?
select time_of_day,
avg(rating) as avg_rating
from sales 
where branch ='C'
group by time_of_day
order by avg_rating desc;

-- which day of the week has the best average ratings?
select day_name,
avg(rating) as avg_rating
from sales 
group by day_name
order by avg_rating desc;

-- which day of the week has the best average rating per branch?
-- for branch A
select day_name,
avg(rating) as avg_rating
from sales 
where branch ='A'
group by day_name
order by avg_rating desc;

-- for branch B--
select day_name,
avg(rating) as avg_rating
from sales 
where branch ='B'
group by day_name
order by avg_rating desc;

-- for branch C
select day_name,
avg(rating) as avg_rating
from sales 
where branch ='C'
group by day_name
order by avg_rating desc;


-- ------------------------------------------Revenue and profit calculations -----------------------------
-- -------------------------------------------------------------------------------------------------------

-- what is the COGS per branch?
alter table sales add column COGSey float8;
select * from sales;

update sales
set COGSey= unit_price * quantity
where branch ='A' ;
select COGSey from sales;

-- for branch B --
update sales
set COGSey= unit_price * quantity
where branch ='B' ;
select COGSey from sales;

-- For branch C--
update sales
set COGSey= unit_price * quantity
where branch ='C' ;
select COGSey from sales;












 


 
 
 
 

 
 
 

