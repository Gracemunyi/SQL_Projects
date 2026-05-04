/*
===================================AGGREGATE FUNCTIONS ====================================================================
====================================QUESTIONS 1- 12=========================================================================================
* They mostly us GROUP BY () and sometimes WHERE()
**/

set search_path to sales_inventory;

select * from customers;
select * from inventory;
select * from products;
select * from sales;

-- 1. Write a query to select all data from the `Customers` table.

select * from customers;

-- 2. Write a query to select the total number of products from the `Products` table.

select count(product_id) as total_products
from products;

-- 3. Write a query to select the product name and its price from the `Products` table where the price is greater than 500.
-- columns - product name, price 
-- table - products table
--- WHERE condition - price > 500
-- select > from> where

select product_name, price
from products
where price > 500;

-- 4. Write a query to find the average price of all products from the `Products` table.
-- table - products
-- columns- price 
-- condition - AVG(price)

select avg(price) as Avg_price
from products;

-- 5. Write a query to find the total sales amount across all records from the `Sales` table.
-- Condition - sum of all sales SUM(*)
-- Table - sales table
-- Column - quantity_sold

select SUM(quantity_sold) as total_sales
from sales;

-- 6. Write a query to select distinct membership statuses from the `Customers` table.
-- table - customers
-- columns - membership status
-- Condition- DISTINCT (*)

select distinct (Membership_status)
from customers;

-- 7. Write a query to concatenate first and last names of all customers and show the result as `full_name`.
-- columns - customer_id, first_name, last_name, email, phone_number
-- table - customers
-- condition - CONCAT(*) as full_name

select customer_id, email, phone_number,
concat(first_name, ' ',last_name) as full_name
from customers;

-- 8. Write a query to find all products in the `Products` table where the category is 'Electronics'.
select * from products;

select *
from products
where category = 'Electronics';


-- 9. Write a query to find the highest price from the `Products` table.
-- condition MAX(*)
select max(price) as highest_price
from products;

-- 10. Write a query to count the number of sales for each product from the `Sales` table.
select * from sales;
-- COUNT quantity_sold
-- GROUP BY product_id

select product_id,
count (quantity_sold) as product_sales
from sales
group by product_id;

-- 11. Write a query to find the total quantity sold for each product from the `Sales` table.

-- sum quantity_sold
-- group by product_id

select product_id,
sum(quantity_sold) as total_quantity
from sales
group by product_id;

-- 12. Write a query to find the lowest price of products in the `Products` table.
select * from products;
-- 1) write lowest price - Min(price) as lowest_price condition
-- 2) write outer select * FROM condition so as to see the full list of products

select *
from products
where price = (select min(price) as lowest_price
from products);

--================================================END=======================================================================
