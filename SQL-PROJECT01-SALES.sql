create database if not exists sales;
use sales;
 create table info(
 transactions_id int primary key ,
 sale_date date,
 sale_time time,
 customer_id int not null,
 gender enum('Male','Female','Other'),
 age int,
 category varchar(50),
 quantiy int,
 price_per_unit	float,
 cogs float , 
 total_sale float 
);

select * from info;

-- 1.DATA CLEANING
select * from info 
where transactions_id is null 
or
sale_date is null
or 
sale_time is null
or
customer_id is null
or 
gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or
cogs is null
or
total_sale is null;

select count(*) from info;
SET SQL_SAFE_UPDATES = 0;

DELETE FROM info
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

INSERT INTO info (transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantiy, price_per_unit, cogs, total_sale)
VALUES
(2001, '2025-08-18', '10:30:00', 101, 'Male', 25, 'Electronics', 2, 300.00, 250.00, 600.00),
(2002, NULL, '12:15:00', 102, 'Female', 30, 'Clothing', NULL, 50.00, 40.00, NULL),
(2003, '2025-08-18', NULL, 204, NULL, NULL, 'Grocery', 5, 10.00, 8.00, 50.00);


select count(distinct(customer_id)) as total_cust from info ;
-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select distinct(category) as total_cust from info ;
select * from info where sale_date = 2022-11-05;

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from info
where category = 'Clothing' and quantiy >= 3 and  date_format(sale_date, '%Y-%m') = '2022-11';

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.:
select category , sum(total_sale) as TOTAL_REVENUE , count(total_sale) as TOTAL_PRODUCT from info group by category;

-- --4.Write a SQL query to find the min/avg age of customers who purchased items from the 'Beauty' category.:

select  customer_id , gender , age from info where category = 'Beauty' and age = (select min(age) from info);
select category , round(avg(age),2) from info where category = 'Beauty'; 

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select count(transactions_id) from info where total_sale > 1000;
select transactions_id from info where total_sale > 1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select gender , category , count(*) as total from info group by gender , category;

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select date_format(sale_date,'%M') as months , avg(total_sale) from info group by months order by avg(total_sale) desc;

-- 8 . **Write a SQL query to find the top 5 customers based on the highest total sales **:

select customer_id , sum(total_sale) as total_sale from info group by customer_id order by total_sale desc limit 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.
select category , count(distinct(customer_id)) from info group by category;

-- 10 .Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with hourly_sales as (
  select 
    *,
    case 
      when extract(hour from sale_time) < 12 then 'Morning'
      when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
      else 'Evening'
    end as sale_period
  from info
)
select
sale_period,
count(*) as total_order
from hourly_sales
group by sale_period;
