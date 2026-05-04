/*
======================================================SUBQUERY FUNCTIONS============================================================================================
======================================================QUESTIONS 51   ===============================================================================================
* 
**/
set search_path to sales_inventory;

select * from customers;
select * from inventory;
select * from products;
select * from sales;

-- 51. Which customers have spent more than the average spending of all customers?

-- first query is the spending of all customers
-- sub query will be the average spend

-- spending of all customers
select c.first_name, s.total_amount
from sales s join customers c
on s.customer_id = c.customer_id

-- average customers
select avg(s.total_amount) as avg_spent
from sales;

-- where total_amount is > avg_spent

select c.first_name, s.total_amount
from sales s join customers c
on s.customer_id = c.customer_id
where s.total_amount > (select avg(s.total_amount) as avg_spent  -- subquery in the WHERE clause
from sales s);

-- 52. Which products are priced higher than the average price of all products?
-- average price of all products
select avg(price) as avg_price
from products

---show p.product_name, p.product_id, p.price

select product_name, product_id, price
from products
where price > (select avg(price) as avg_price
from products);

-- 53. Which customers have never made a purchase?
-- customers in customer table but ids are not in the sales table
-- query 1) select the customers 
-- query 2) LEFT JOIN customer and sales table - to math everyone including NULLs (customers who did make sales)
-- query 3) WHERE customer_id NOT IN (query 1) -- to filter those who never made sales.

select customer_id from sales 

select c.first_name, c.last_name,c.customer_id
from customers c
left join sales s on c.customer_id= s.customer_id
where c.customer_id not in (select customer_id from sales);

-- 54. Which products have never been sold?
-- query 1) select all products 
-- query 2) LEFT JOIN sales and products table
-- query 3) WHERE product_id NOT IN (query 1)

select * 
from products p
left join sales s on p.product_id= s.product_id
where p.product_id not in (select product_id from sales);

-- 55. Which customer made the single most expensive purchase (total amount)?
--- query 1 ) MAX total amount from sales 
-- query 2) LEFT JOIN customers and sales table
-- query 3) Where total_amount = Query 1

select max(total_amount) from sales;

select c.first_name, c.customer_id, s.total_amount
from customers c 
join sales s on c.customer_id= s.customer_id
where total_amount=(select max(total_amount) from sales);

-- 56. Which products have total sales greater than the average total sales across all products?

-- avrg total sales is avg (total_amount)

select avg(total_amount) from sales as avg_amount;---- inner query

select p. product_name, p.product_id, s.total_amount
from products p
join sales s on p.product_id= s.product_id
where total_amount >(select avg(total_amount) from sales as avg_amount);


-- 57. Which customers registered earlier than the average registration date?
-- Average of a date column can be calculated using; SELECT TO_TIMESTAMP(AVG(EXTRACT(EPOCH FROM registration_date)))::DATE FROM assignment.customers

--query 1) Average registration date column  - inner query
SELECT TO_TIMESTAMP(AVG(EXTRACT(EPOCH FROM registration_date)))::DATE FROM customers; -- 

select first_name, last_name,registration_date 
from customers
where registration_date < (SELECT TO_TIMESTAMP(AVG(EXTRACT(EPOCH FROM registration_date)))::DATE FROM assignment.customers);

-- 58. Which products have a price higher than the average price within their own category?

-- query 1) average price per category 
-- query 2) compare 

select avg(p1.price)
from products p1

select p.product_id, p.product_name, p.category, p.price
from products p

where p.price >


select p.product_id, p.product_name, p.category, p.price
from products p
where p.price > (
    select avg(p1.price)
	from products p1
	where p1.category = p.category
);

-- 59. Which customers have spent more than the customer with ID = 10?


-- 60. Which products have total quantity sold greater than the overall average quantity sold?
