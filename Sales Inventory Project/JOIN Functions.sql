/*
===================================JOIN FUNCTIONS ====================================================================
====================================QUESTIONS 13-50 =========================================================================================
* 
**/

set search_path to sales_inventory;

select * from customers;
select * from inventory;
select * from products;
select * from sales;

-- 13. Write a query to find customers who have purchased products with a price greater than 1000.

--- We are joining customers, 'purchased products', price > 100
---- customer table has customer names only
--- product table has products and price
-- sales table has quantities of products sold to the customers
-- Thus we are joining the three tables using primary keys
-- Customer_id in customers > join/match to customer_id in sales
-- products_id in sales > join/match to products_id in products.
--- Apply filter where price >1000
--- start by selecting columns needed from each of the three tables
-- Alias where from which tables all the columns picked in the whole code came from
-- Sytax : 
/*
select 
list column names
from 1st table ie customers
inner or left join 2nd table on primary keys
inner or left join 3rd table on primary key
where price> 1000 
*/

select 
	c.customer_id,
	c.first_name,
	c.last_name,
	p.product_id,
	p.product_name,
	p.category,
	p.price
from customers c
left join sales s on c.customer_id = s.customer_id
left join products p on s.product_id = p.product_id
where price > 1000;
	
-- 14. Write a query to join the `Sales` and `Products` tables on product_id, and Show product name and total sales amount per product
-- join sales and products tables 
--primary_key product_id
-- columns - p > product_id, product_name, stock_quantity, S > product_id, total_amount

select 
	p.product_id,
	p.product_name,
	p.stock_quantity,
	s.total_amount
from products p
inner join sales s on p.product_id = s.product_id;

-- 15. Write a query to join the `Customers` and `Sales` tables and find the total amount spent by each customer.

select * from customers;
select * from sales;
-- join the Customers and Sales tables
-- list total amount spent by each customer

select 
	c.customer_id,
	c.first_name,
	c.last_name,
	s.total_amount
from customers c
inner join sales s on c.customer_id = s.customer_id; 
-- Whenever you have an aggregate function in your select item, you MUST have a GROUP BY clause.
select 
	c.customer_id,
	c.first_name,
	c.last_name,
	s.total_amount,
	sum (total_amount) as customer_sum -- if 1 customer bought multiple items
from customers c
inner join sales s on c.customer_id = s.customer_id
group by 
	c.customer_id,
	c.first_name,
	c.last_name,
	s.total_amount;

-- 16. Write a query to join the `Customers`, `Sales`, and `Products` tables, and show each customer's first and last name, product name, and quantity sold.
-- 

select * from customers;
select * from inventory;
select * from products;
select * from sales;

select
	c.customer_id,
	concat(c.first_name,' ', c.last_name) as full_name,
	p.product_id,
	p.product_name,
	s.quantity_sold
from customers c
inner join sales s on c.customer_id = s.customer_id
inner join products p on p.product_id = s.product_id;

-- 17. Write a query to perform a self-join on the `Customers` table and find all pairs of customers who have the same membership status.
-- Table - customers table only
-- Because we are using a self-join, we will assign the same table two different aliases.
-- self join can be used to det. organogram/hierarchy of an organisation

select
	c.first_name,
	c.last_name,
	d.first_name,
	d.last_name,
	c.membership_status
from customers c
inner join customers d on c.membership_status = d.membership_status
where c.customer_id != d.customer_id; -- to avoid the same customer being matched in both tables.

-- 18. Write a query to join the `Sales` and `Products` tables, and calculate the total number of sales for each product.

select
	p.product_id,
	p.product_name,
	p.category,
	s.quantity_sold,
	count (s.sale_id) as sale_count
from products p
inner join sales s on p.product_id = p.product_id
group by 
	p.product_id,
	p.product_name,
	p.category,
	s.quantity_sold;

-- 19. Write a query to find the products in the `Products` table where the stock quantity is less than 50.
-- product name
-- select product name, where > find quantity < 50

select * from products;
select * from sales;

select product_name, stock_quantity
from products
where stock_quantity < 50;

-- 20. Write a query to join the `Sales` table and the `Products` table, and find products with total sales quantity greater than 2.

-- join 2 tables
-- product name, quantity_sold > 2

select product_name, quantity_sold
from products p
inner join sales s on s.product_id = p.product_id
where quantity_sold > 2;

-- 21. Write a query to select customers who have purchased products that are either in the 'Electronics' or 'Appliances' category.
-- 3 tables  customer > sales > products
select 
	c.first_name,
	p.product_name,
	p.category
from customers c
inner join sales s on s.customer_id = c.customer_id
inner join products p on p.product_id = s.product_id
where category in ('Electronics', 'Appliances');

where category = 'Electronics' or category ='Appliances'; 

-- 22. Write a query to calculate the total sales amount per product and group the result by product name.
select * from products;
select * from sales;

select 
	p.product_name,
	s.total_amount
from sales s
inner join products p on p.product_id = s.product_id
group by 
	p.product_name,
	s.total_amount;

-- 23. Write a query to join the `Sales` table with the `Customers` table and select customers who made a purchase in the year 2023.

-- select customers, purchase year 2023

select
	c.first_name,
	s.sale_date
from customers c
join sales s on s.customer_id = c.customer_id
where date_part('year', sale_date) = '2023'; 
where extract(year from sale_date) = '2023'. -- To extract year only you can use date_part or extract

-- 24. Write a query to find the customers with the highest total sales in 2023.

-- find customers with sales 2023 and have to be highest total sale
-- find the highest by;
-- ranking  the customers based on total amount ie use rank, dense_rank etc.
-- dense_rank by total_amount in desc order
-- then choose who had highest sales
-- Use CTE and subquery

-- part 1 - table_x
select
	c.first_name,
	s.total_amount,
	s.sale_date,
	dense_rank ()over(order by s.total_amount desc) as rank
from customers c
join sales s on s.customer_id = c.customer_id
where date_part('year', sale_date) = '2023' 
 

-- part 2

select *  from table_x where rank = 1

select * from
(select
	c.first_name,
	s.total_amount,
	s.sale_date,
	dense_rank ()over(order by s.total_amount desc) as rank
from customers c
join sales s on s.customer_id = c.customer_id
where date_part('year', sale_date) = '2023' ) m  -- alias table_x using m after brackets
where m.rank = 1;

or 
-- when you want to have columns first_name and total_amount in the final table 
select m.first_name, m.total_amount, m.rank from
(select
	c.first_name,
	s.total_amount,
	s.sale_date,
	dense_rank ()over(order by s.total_amount desc) as rank
from customers c
join sales s on s.customer_id = c.customer_id
where date_part('year', sale_date) = '2023' ) m  -- alias table_x using m after brackets
where m.rank = 1;

--CTEs
-- define a cte which is a virtual table called highest sales

with highest_sales as 
(select
	c.first_name,
	s.total_amount,
	s.sale_date,
	dense_rank ()over(order by s.total_amount desc) as rank
from customers c
join sales s on s.customer_id = c.customer_id
where date_part('year', sale_date) = '2023' )
select * from highest_sales
where rank = 1;

or 
-- to specify the columns we want to see

with highest_sales as 
(select
	c.first_name,
	s.total_amount,
	s.sale_date,
	dense_rank ()over(order by s.total_amount desc) as rank
from customers c
join sales s on s.customer_id = c.customer_id
where date_part('year', sale_date) = '2023' )
select hs.first_name, hs.total_amount from highest_sales hs
where rank = 1;

-- 25. Write a query to join the `Products` and `Sales` tables and select the most expensive product sold.
-- join product & sales 
-- rank in desc order
-- select rank 1
select * from (
 select s.product_id, p.product_name, p.category, p.price,
 dense_rank () over (order by p.price desc) as price_rank
 from products p
 inner join sales s on s.product_id = p.product_id) m
 where m.price_rank = 1;

-- 26. Write a query to find the total number of customers who have purchased products worth more than 500.

select * from customers;
select * from inventory;
select * from products;
select * from sales;

-- tables - customers, products, sales
-- columns - c.customer_id, c.first_name, p.product_name, p.product_id, s.total_amount
-- left join the three tables
-- dense_rank total amount
-- subquery or CTE 
-- where total amount > 500
select * from (
select c.customer_id, c.first_name, p.product_name, p.product_id, s.total_amount,
dense_rank () over (order by s.total_amount desc) as total_amount_ranking
from customers c
left join sales s on c.customer_id = s.customer_id
left join products p on p.product_id = s.product_id) tar
where tar.total_amount> 500;

-- 27. Write a query to join the `Products`, `Sales`, and `Customers` tables and find the total number of sales made by customers who are in the 'Gold' membership tier.
-- join tables product, sales and customers
--

-- 28. Write a query to join the `Products` and `Inventory` tables and find all products that have low stock (less than 10).

-- 29. Write a query to find customers who have purchased more than 5 products and show the total quantity of products they have bought.

-- 30. Write a query to find the average quantity sold per product.

-- 31. Write a query to find the number of sales made in the month of December 2023.

-- 32. Write a query to find the total amount spent by each customer in 2023 and list the customers in descending order.
-- a) Write a query to find the total amount spent by each customer in 2023
-- b) list the customers in descending order.

-- find total amount spent by each customer
-- list customer in descending order - ORDER BY total amount from highest to lowers
-- filter in 2023
-- customer_name, total amount
-- we have aggregate function, so use group by

select c.first_name, sum(s.total_amount) as sum_total_amount
from sales s
inner join customers c on s.customer_id = c.customer_id
where extract(year from sale_date) = '2023'
group by c.first_name 
order by sum_total_amount desc;

--- subquery
Sytanx select * from table_x x .....

select * from 
(select c.first_name,s.sale_date, sum(s.total_amount) as sum_total_amount
from sales s
join customers c on s.customer_id = c.customer_id 
group by first_name,s.sale_date
order by sum_total_amount desc) c_d -- Alias customers_detail or c_d
where extract(year from customers_detail.sale_date) = 2023;


or 

select c_d.first_name, c_d.sum_total_amount from 
(select c.first_name,s.sale_date, sum(s.total_amount) as sum_total_amount
from sales s
join customers c on s.customer_id = c.customer_id 
group by first_name,s.sale_date
order by sum_total_amount desc) c_d -- Alias customers_detail or c_d
where extract(year from c_d.sale_date) = 2023;

---- CTE
--- Syntax starts with;
with table_x as 
(table_x)
select (columns) from table_x
where extract (year from);


with customer_details as
(select c.first_name,s.sale_date, sum(s.total_amount) as sum_total_amount
from sales s
left join customers c on s.customer_id = c.customer_id 
group by first_name,s.sale_date
order by sum_total_amount desc)
select c_d.first_name,c_d.sum_total_amount from customer_details c_d
where extract(year from c_d.sale_date) = 2023;


-- 33. Write a query to find all products that have been sold but have less than 50 units left in stock.

select * from customers;
select * from inventory;
select * from products;
select * from sales;

-- tables - products, sales, inventory (stock left)
-- product_name, stock_quantity , quantity_sold, stock_left (derived column)
-- deduct stock_quantity - quantity_sold = stock_left 
--joining products & sales using product_id

select 
	p.product_name,
	p.stock_quantity,
	s.quantity_sold,
	(p.stock_quantity- s.quantity_sold) as stock_left
from products p
left join sales s on p.product_id = s.product_id
where p.stock_quantity- s.quantity_sold < 50;	
	

-- 34. Write a query to find the total sales for each product and order the result by the highest sales.

-- sum of purchases made by each client for each product ie sum total amount for each product
-- order in desc order ie highest sales.




-- 35. Write a query to find all customers who bought products within 7 days of their registration date.

-- customers who purchase after registering
-- (registration_date - sale_date) <= 7 
-- column - customer_name, sale_date, registration_date
-- tables - sales, customers 

select 
	 concat(c.first_name, ' ', c.last_name),
	 abs(c.registration_date::date - s.sale_date::date) as post_registration_date
from customers c 
inner join sales s on c.customer_id = s.customer_id
where c.registration_date::date - s.sale_date::date >=1 and c.registration_date::date - s.sale_date::date <= 100;


select 
	 concat(c.first_name, ' ', c.last_name),
	 abs(s.sale_date::date -c.registration_date::date) as post_registration_date
from customers c 
inner join sales s on c.customer_id = s.customer_id
where s.sale_date::date - c.registration_date::date >=1 and s.sale_date::date - c.registration_date::date <= 100;

-- 36. Write a query to join the `Sales` table with the `Products` table and filter the results by products priced between 100 and 500.




-- 37. Write a query to find the most frequent customer who made purchases from the `Sales` table.

-- we are counting the number of distinct purchases
-- join tables sales and customers 
-- customer_id, customer_name, 
-- find MAX of the most frequent customer
-- rank the customer_id count (use dense_rank so that they dont skip ranking)
-- dense_rank is always followed by over (order by)

select 
	c.first_name,
	s.customer_id,
	count(s.customer_id), -- count the number of times customers appeared in the store
	dense_rank() over (order by count(s.customer_id)) as purchase_frequency -- we have ranked them to established who appeared there most. 
from customers c
inner join sales s on s.customer_id = c.customer_id
group by 
	c.first_name, 
	s.customer_id;

--- subquery
select * from
(select 
	c.first_name,
	s.customer_id,
	count(s.customer_id), -- count the number of times customers appeared in the store
	dense_rank() over (order by count(s.customer_id)) as purchase_frequency -- we have ranked them to established who appeared there most. 
from customers c
inner join sales s on s.customer_id = c.customer_id
group by 
	c.first_name, 
	s.customer_id) 
where purchase_frequency =1;

--- CTE

with frequent_customer as
(select 
	c.first_name,
	s.customer_id,
	count(s.customer_id), -- count the number of times customers appeared in the store
	dense_rank() over (order by count(s.customer_id)) as purchase_frequency -- we have ranked them to established who appeared there most. 
from customers c
inner join sales s on s.customer_id = c.customer_id
group by 
	c.first_name, 
	s.customer_id)
select * from frequent_customer
where purchase_frequency = 1;

-- 38. Write a query to find the total quantity of products sold per customer.
select 
	concat(c.first_name, ' ', c.last_name) as full_name,
	sum(s.quantity_sold) as total_quantity
from sales s
join customers c on s.customer_id = c.customer_id
group by c.customer_id;

select 
	concat(c.first_name, ' ', c.last_name) as full_name,
	sum(s.quantity_sold) as total_quantity
from sales s
join customers c on s.customer_id = c.customer_id
group by full_name;

-- 39. Write a query to find the products with the highest stock and lowest stock, and display them together in a single result set.

-- tables - products or inventory
-- columns - stock_quantity, product_name, product_id
-- use UNION ALL - Its stacks on top of each other to produce both results as one output in a single table including duplicate stocks
-- UNION removes duplicates, UNION ALL keeps them

(
    SELECT p.product_name, p.product_id, p.stock_quantity
    FROM products p
    WHERE p.stock_quantity = (SELECT MAX(stock_quantity) FROM products)
)
UNION ALL
(
    SELECT p.product_name, p.product_id, p.stock_quantity
    FROM products p
    WHERE p.stock_quantity = (SELECT MIN(stock_quantity) FROM products)
);

--OR
(
	select * 
	from products 
	where stock_quantity = (select MAX(stock_quantity) from products)
)

union all
(
	select * 
	from products 
	where stock_quantity = (select MIN(stock_quantity) from products)
);


-- 40. Write a query to find products whose names contain the word 'Phone' and their total sales.

select * from customers;
select * from inventory;
select * from products;
select * from sales;

-- product_id, product_name, category, total_amount, 
-- sum(total_sales)
-- WHERE category LIKE '%Phone%'
-- tables - sales and products

select 
	p.product_id,
	p.product_name,
	sum(s.total_amount) as "total_sales"
from sales s
join products p on s.product_id = p.product_id
where p.product_name like '%phone%'
group by p.product_id,
		p.product_name;

-- 41. Write a query to perform an `INNER JOIN` between `Customers` and `Sales`, then display the total sales amount and the product names for customers in the 'Gold' membership status.

-- first_name, cutomer_id,  membership_status, total sales, product_name
--tables - customers, sales, product table
-- filter membership_status = 'Gold'
-- INNER JOIN the three tables
select 
	concat(c.first_name, ' ', c.last_name),
	c.customer_id,
	c.membership_status,
	p.product_name,
	sum(s.total_amount)
from sales s
join customers c on s.customer_id = c.customer_id
join products p on s.product_id = p.product_id
where c.membership_status = 'Gold'
group by 
	concat(c.first_name, ' ', c.last_name),
	c.customer_id,
	c.membership_status,
	p.product_name;
 
--- sub query

select * from 
(select concat(c.first_name, ' ', c.last_name), c.customer_id, c.membership_status, p.product_name, sum(s.total_amount)
from sales s
join customers c on s.customer_id = c.customer_id
join products p on s.product_id = p.product_id
group by concat(c.first_name, ' ', c.last_name), c.customer_id, c.membership_status, p.product_name) ts
where ts.membership_status = 'Gold';

-- CTEs

with table_x from
select * from table_x x where x.membership_status = 'Gold'

-- 42. Write a query to find the total sales of products by category.
-- total sales for each category
--sum total_amount as total sales
-- group by category
-- join sales and product tables

select p.category, sum(s.total_amount) as "Total sales"
from sales s
join products p on s.product_id = p.product_id
group by p.category;

-- 43. Write a query to join the `Products` table with the `Sales` table, and calculate the total sales for each product, grouped by month and year.
-- sum(s.total_amount), s.sale_date, p.product_name
-- extract year and date in the select part of sale_date
-- In GROUP BY clause then you paste it to match it. 

select 
	p.product_name,
	sum(s.total_amount) as total_sales,
	extract(year from s.sale_date)::text as Year, to_CHAR(sale_date, 'Month') as month
from sales s
join products p on s.product_id = p.product_id
group by 
	p.product_name, 
	extract(year from s.sale_date), to_CHAR(sale_date, 'Month');

-- 44. Write a query to join the `Sales` and `Inventory` tables and find products that have been sold but still have stock remaining.
--product_name, stock_quantity, quantity_sold, 
--(stock_quantity, quantity_sold )as remaining_stock
-- use where so as to exclude rows that have zero remaining stock becuase we used INNER JOIN which did not exlude them.

select p.product_name,(i.stock_quantity - s.quantity_sold) as remaining_stock
from sales s
left join products p on s.product_id = p.product_id
left join inventory i on p.product_id = i.product_id
where (i.stock_quantity - s.quantity_sold) > 0;

-- 45. Write a query to find the top 5 customers who have made the highest purchases.
-- sum(total_amount)
-- top 5 using limit
-- highest purchase using dense_rank
select
	c.first_name,
	c. last_name, 
	sum(s.total_amount) as highest_purchases,
	dense_rank () over(order by sum(s.total_amount)desc)
from customers c
inner join sales s on c.customer_id = s.customer_id
group by 
	c.first_name,
	c. last_name
limit 5;

-- 46. Write a query to calculate the total number of unique products sold in 2023.

select * from customers;
select * from inventory;
select * from products;
select * from sales;

-- product_name, product_id, count(product_id)
-- join sales and products 
-- extract sold in 2023 -- extract(year from sale_date)

select
	p.product_name,
	s.product_id,
	s.sale_date,
	count(distinct s.product_id),
	extract(year from sale_date)
from sales s
join products p on  p.product_id = s.product_id
where extract(year from s.sale_date) ='2023'
group by 
	p.product_name,
	s.product_id,
	s.sale_date,
	extract(year from sale_date);

-- 47. Write a query to find the products that have not been sold in the last 6 months.
-- product, sales table
-- extract (month from s.sale_date)= '6month' from 2024-02-05
-- p.product_id, p.product_name,sale_date 
--A LEFT JOIN keeps all rows from products and tries to match rows from sales
--If no match is found → sales columns become NULL

select p.product_id, p.product_name,s.sale_date
from products p
left join sales s on p.product_id = s.product_id
and s.sale_date >= date '2024-02-05' - interval '6 months'
where s.product_id is null;

--- if i didnt know my actual latest date, i could use MAX(DATE)
select p.product_id, p.product_name, sale_date
from products p
left join sales s on p.product_id = s.product_id
and s.sale_date >= (select max(sale_date) from sales) - INTERVAL '6 months'
where s.product_id is null;

-- 48. Write a query to select the products with a price range between $200 and $800, and find the total quantity sold for each.
-- join product and sales 
-- p.product_name, s.product_id, p.price, 
-- sum(s.quantity_sold) 
-- WHERE price BETWEEN (200 AND 800))

select
	p.product_name,
	p.price,
	s.product_id,
	sum(s.quantity_sold) as total_quatity_sold
from products p
inner join sales s on p.product_id = s.product_id
where price between 200 and 800
group by
	p.product_name,
	p.price,
	s.product_id;

-- 49. Write a query to find the customers who spent the most money in the year 2023.
--- subquery
-- columns- c.customer_id, c.first_name, sum(s.total_amount)
-- dense_rank () OVER (ORDER BY sum total)
-- extract(year from sale_date) = '2023'
select * from (
select c.customer_id, c.first_name, sum(s.total_amount), 
dense_rank() over (order by sum(s.total_amount) desc) as rank
from customers c
left join sales s on c.customer_id = s.customer_id
where extract(year from sale_date) = '2023'
group by c.customer_id, c.first_name)
where rank <= 5;

-- 50. Write a query to select the products that have been sold more than 100 times and have a price greater than 200.

-- count(s.product_id) as highest_product_sold
--
select p. product_name, s. product_id,p.price, count(s.product_id) as highest_product_sold
from products p
inner join sales s
on p.product_id=s.product_id 
where price >200 
group by p. product_name, s. product_id,p.price
having count(*)=1;



