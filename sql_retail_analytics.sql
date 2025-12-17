--Exploration Data

select *
from public.customer
limit 5;

select count(*) as total_rows
from public.customer;
--customer have 4 columns and 99457 rows 

select *
from public.sales
limit 5;

select count(*) as total_rows
from public.sales;
--sales have 7 columns and 99457 rows 


--missing value
select
	sum (case when customer_id is null then 1 end) as missing_customer_id,
	sum (case when gender is null then 1 end) as missing_gender,
	sum (case when age is null then 1 end) as missing_age,
	sum (case when payment_method is null then 1 end) as missing_payment_method
from public.customer;
--119 null at age column in customer table

select
	sum (case when invoice_no is null then 1 end) as missing_invoice_no,
	sum (case when customer_id is null then 1 end) as missing_customer_id,
	sum (case when category is null then 1 end) as missing_category,
	sum (case when quantity is null then 1 end) as missing_quantity,
	sum (case when price is null then 1 end) as missing_price,
	sum (case when invoice_date is null then 1 end) as missing_invoice_date,
	sum (case when shopping_mall is null then 1 end) as missing_shopping_mall
from public.sales;
--nothing null in sales

--Data Cleaning
 CREATE TABLE public.sales_data AS (
SELECT 
    s.invoice_no,
    s.customer_id,
    s.category,
    s.quantity,
	(s.price / NULLIF(s.quantity, 0)) AS price,
	s.price as revenue,
    s.invoice_date,
    s.shopping_mall,
    c.gender,
    c.age,
    c.payment_method
FROM public.sales AS s
INNER JOIN public.customer AS c
    ON c.customer_id = s.customer_id );

select *
from public.sales_data
limit 10;

--Data Preparation
--age Group
SELECT *,
CASE
	WHEN age IS NULL THEN 'unknown'
	WHEN age BETWEEN 0 AND 18 THEN '0-18'
	WHEN age BETWEEN 19 AND 25 THEN '19-25'
	WHEN age BETWEEN 26 AND 35 THEN '26-35'
	WHEN age BETWEEN 36 AND 50 THEN '36-50'
	ELSE '50+'
END AS age_group
FROM public.sales_data;

--Business Analysis Queries
--Revenue by Month
SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    SUM(revenue) AS total_revenue
FROM public.sales_data
GROUP BY month
ORDER BY month;

-- Top 5 Malls by Revenue
SELECT
    shopping_mall,
    SUM(revenue) AS total_revenue
FROM public.sales_data
GROUP BY shopping_mall
ORDER BY total_revenue DESC
LIMIT 5;

-- Revenue by Category
SELECT
    category,
    SUM(revenue) AS total_revenue
FROM public.sales_data
GROUP BY category
ORDER BY total_revenue DESC;
--clothing is the most sold item

--order by gender
select gender, count(*)
	from public.sales_data
	group by gender
order by count(*) desc;
-- "Female"	59482 dan "Male” 39975


