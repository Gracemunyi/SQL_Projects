/*
======================================================SUBQUERY  & CTES FUNCTIONS============================================================================================
======================================================QUESTIONS 71-80===============================================================================================
* 
**/
set search_path to sales_inventory;

select * from customers;
select * from inventory;
select * from products;
select * from sales;


-- 71. Rank customers based on the total amount they have spent.
-- tables customers, sales 
-- columns total_amount, customer names,customer_id
-- rank () over (order by total_amount)
-- join sales and customer tables
-- group by customer_id
select * from customers;
select * from sales;
select * from products;

select c.customer_id, c.first_name, sum(total_amount) as Amount_totals, 
dense_rank() over (order by sum(s.total_amount)desc) as Amount_Ranks
from sales s
join customers c
on c.customer_id = s.customer_id
group by c.customer_id;

-- 72. Rank products based on total quantity sold.

--rank
select p.product_id, p.product_name, sum(s.quantity_sold) as Total_sold,
rank()over (order by sum(s.quantity_sold)desc) as Quantity_rank
from products p
join sales s
on s.product_id = p.product_id
group by p.product_id;

--dense_rank
select p.product_id, p.product_name, sum(s.quantity_sold) as Total_sold,
dense_rank()over (order by sum(s.quantity_sold)desc) as Quantity_rank
from products p
join sales s
on s.product_id = p.product_id
group by p.product_id;

-- 73. Identify the 3rd highest spending customer.

with Customer_spending as(
select c.customer_id, c.first_name, sum(s.total_amount) as Totals,
dense_rank()over (order by sum(s.total_amount)desc) as Spending_rank
from sales s
join customers c
on c.customer_id = s.customer_id
group by c.customer_id)
select * from Customer_spending
where Spending_rank = 3;

-- 74. Identify the 2nd most expensive product.

with Product_cost as (
select p.product_id, p.product_name, p.price,
dense_rank()over (order by p.price desc) as Price_rank
from products p)
select * from Product_cost
where price_rank = 2;

-- 75. Show the ranking of products within each category based on price.
select p.product_id,p.product_name, p.category, p.price,
dense_rank()over (partition by category order by price desc) as Category_rank
from products p;

-- 76. Show the ranking of customers based on the number of purchases they made.
-- customers and their purchases, then rank them
-- count of sale_id then dense_rank () over (order by count(sale_id) as 
select s.customer_id, c.first_name, count(s.sale_id) as no_of_sales, 
dense_rank()over (order by count(sale_id)) as Rank_of_Purchases
from sales s
join customers c
on c.customer_id = s.customer_id
group by  s.customer_id,c.first_name;

-- 77. Show the running total of sales amounts ordered by sale_date.
--- add like a bank statement does ie 
-- last transaction balance added to new deposit to create a new total
-- columns - total_amount, sale_date 
-- running total = sum(total_amount), then add window function OVER (ORDERBY sale_date)
--sum of total_amount
select sale_date, total_amount, 
sum(total_amount)

-- to calculate the running total
over(order by sale_date) as Running_totals 


select sale_date, total_amount, 
sum(total_amount) over(order by sale_date) as Running_totals
from sales; 


-- 78. Show the previous sale amount for each sale ordered by sale_date.
-- order by sale_date
-- then use LAG to find the previous
-- REAL LIFE USAGE - were my sales higher than or lower today than yesterday or last month
select total_amount, sale_date,
lag(total_amount) over (order by sale_date) as previous_sale_amount
from sales;

-- If you want to show output by last 2 days ie lag skipping every 2 days 
-- add 2 next to lag(total_amount)

select total_amount, sale_date,
lag(total_amount, 2) over (order by sale_date) as previous_sale_amount
from sales;


-- 79. Show the next sale amount for each sale ordered by sale_date.

select total_amount, sale_date,
lead(total_amount) over (order by sale_date) as next_sale_amount
from sales;

-- 80. Divide customers into 4 groups based on total spending.

select c.customer_id, c.first_name, sum(total_amount) as total_spending,
ntile(4) over (order by sum(total_amount)desc) as Ntile_Groups
from customers c
join sales s
on c.customer_id = s.customer_id
group by c.customer_id;
