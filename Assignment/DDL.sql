-- CLASS DAY 1

-- Creating a schema if it doesnt exist

CREATE SCHEMA IF NOT EXISTS training;

set  search_path = training;

-- We are Creating Department table 

CREATE TABLE training.departments (
department_id SERIAL PRIMARY KEY,
department_name VARCHAR(50) NOT NULL,
location VARCHAR(50)
);

-- We are creating an employees table inside the Training Schema with 8 columns
CREATE TABLE training.employees (
employee_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100),
department VARCHAR(50),
job_title VARCHAR(50),
salary NUMERIC(10,2),
hire_date DATE,
is_active BOOLEAN DEFAULT TRUE
);
-- creating the second table called customer table 

CREATE TABLE training.customers (
customer_id SERIAL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(100),
city VARCHAR(50),
country VARCHAR(50)
);

-- Creating a third table called Orders table

CREATE TABLE training.orders (
order_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES training.customers(customer_id),
order_date DATE NOT NULL,
total_amount NUMERIC(10,2),
status VARCHAR(20)
);


--- CLASS DAY 2 
-- PART 1 - DDL (DATA DEFINITION LANGUAGE)
--CREATE table
--ALTER table
--DROP Table
--TRUNCATE

-- PART 2 - DML (DATA MANIPULATION LANGUAGE)
-- INSERT INTO
-- SELECT
-- UPDATE
-- DELETE

**/

-- We are creating 3 tables 
--1) CUSTOMERS TABLE
--Store info about the people who oder books
--Variables: Customer_id, Customer_name, Email, City
--2) BOOKS TABLE
-- List of books available for purchase
-- variables: book_id, title. author, price, stock
--3) Order table
-- Recors each time a customer buy a book
-- It will reference table one and two  hence we will have to pick two keys from the first 2 tables
-- Customer_id, book_id, order_id. quantity, order_date


-- PART 1 - DDL (DATA DEFINITION LANGUAGE)
-- This is how we define and shape the structure of our database
-- Create a table we will need;
-- column name, data type, constraints (rules like Not Null, unique)

-- CREATE A SCHEMA FIRST 
CREATE SCHEMA IF NOT EXISTS Bookshopdb;

-- Set a path to the created schema above instead of having to add the schema name every time in your tables 
set search_path = Bookshopdb;

-- CREATING CUSTOMER TABLE inside the Schema
CREATE TABLE customers(
Customer_id int Primary key,
Customer_name varchar (100) not null,
Email varchar (100) not null unique,
City varchar (100) 
);


-- BOOKS TABLE
--Decimal 8 is max length, 2 is No of decimal points
-- In Stock if zero, it will reflect default value
Create table books(
 Book_id int primary key,
 Title Varchar (100) NOT NULL,
 Author Varchar (100) NOT NULL,
 Price decimal (8,2),
 Stock int default 0
);

-- view books table
select *
from books;


-- ORDERS TABLE
 Create table Orders(
 Order_id int Primary Key,
 Customer_id Int,
 Book_id int, 
 Quantity Int default 1,
 Order_date date
 );
 
-- ALTER TABLE
-- Changing or correcting the structure of a table
-- You can add or remove columns here from an already created table instead of deleting the table first 

--ADD New column in the customers table
Alter table customers
add column Phone Varchar (100);

select * from customers;

-- MODIFY/ 2 ALTERS
-- If you want to modify a column. e.g change data type or size
-- We want to increase customer names to 150 to accomodate people with Nigerians long names
-- You have to add the command TYP, also no need to add not null since it wont be modified
-- Modify is for MySQl. In PostgreSQL we use A second Alter

Alter table customers
Alter column Customer_name TYPE varchar (150);


-- RENAME 
-- Renaming a COLUMN e.g for City to Town

Alter table customers
Rename column city to town;

-- DROP COLUMN
-- To drop a column/ remove it completely

Alter table customers
drop column phone;

-- DROP/DELETING THE WHOLE TABLE

-- drop table orders;


-- TRUNCATE
-- It keeps a table empty but keeps its structure
-- It removes all rows + data inside a table but keeps the table itself

truncate table orders;

-- COMPARISON BETWEEN DELETE, TRUNCATE AND DROP
-- DELETE (with WHERE) - removes data (for some rows only). Remove table structure(NO)
-- TRUNCATE - removes all rows, removes structure (NO)
-- DROP - removes all rows, removes structure (YES, whole table gone)


-- PART 2 - DML (DATA MANIPULATION LANGUAGE)
-- INSERT INTO
-- SELECT
-- UPDATE
-- DELETE

-- INSERT INTO
-- Used for adding new data rows 
-- Insert one customer in customer table
-- insert into table_name (column_name 1, column_name2, colum_name 3)
-- values (id, name email);

Insert into customers( Customer_id , Customer_name, Email,Town)
values (1, 'Grace', 'grace21@gmail.com', 'Nairobi');

-- Inserting for Multiple data points e.g in books

Insert into books (book_id, title, author,price, stock)
values
(1, 'Things Fall Apart', 'Chinua Achebe', 850.00, 21),
(2, 'Kifo Kisimani', 'Kithaka wa Mberia', 670.00, 37),
(3, 'Siku Njema', 'Ken Walibora', 750.00, 14),
(4, 'Weep not child', 'Ngugi Wathingo', 500.00, 10);

select * from Books;

Insert into customers( Customer_id , Customer_name, Email,Town)
values 
(2, 'Brian Otieno', 'briano@gmail.com', 'Mombasa'),
(3, 'Cynthia Mutua', 'Cynthia@gmail.com', 'Kisumu'),
(4, 'Eva Achieng', 'Eva@yahoo.com', 'Nakuru'),
(5, 'Moses kibe', 'Kibet@yahoo.com', 'Eldoret')

-- SELECT  ,

-- Used for reading from the table e.g book title and price
-- Select 2 columns only
-- Select, mention column names, table name

Select title, price
from books; 

-- SELECT (WHERE) ie with a condion using WHERE
-- WHERE - To filter only returns rows that match the conditions

Select * from customers
where town = 'Mombasa';

-- Selecting where customer name is brian otieno

Select *
From customers
Where customer_name = 'Brian Otieno';

-- Selecting title and stock where stock is greater than 12
select title, stock 
from books
where stock < 12;

-- UPDATE (WHERE)
-- Used for changing existing data
-- Always use it with WHERE clause so as to not change whole data set.
-- E.g you are updating customers table info from current town to thika

update customers
set town = 'Thika'
Where customer_id =2;

-- Update things fall apart books stock to 50

Update books
set stock = 50
where title = 'Things Fall Apart';

-- UPDATING MULTIPLE COLUMNS AT THE SAME TIME
-- update price and stock
-- Update title of table, 
-- Set the two columns you are adjusting with their values
-- Where primary_ key == XXX;

Update books
set price = 1000.000, stock = 48
where book_id = 2;


-- DELETE (WHERE)
-- Is used for removing rows from a table
-- This removes specific rows from a table 
--Always use WHERE unless you really want to delete everything

delete from books
where book_id =4; 

select*
from books;

-- VIEWING THE TABLE WITH PRIMARY KEY IN ASCENDING ORDER
-- Use ORDER by ASC, or ORDER by DESC

-- e.g selecting the books table with Book_id in ascending order
-- Select
-- From title of table
-- Order by Title of column you want ordered
-- Asc;

Select *
From books
Order by book_id Asc;


-- CLASS 3 
-- FILTERING ie >, <, count, 
-- Telling SQL dont give me everything, only give me rows that match my conditions
-- PART 1: Comparison operators (=, >, <, >=, <>, <=)
-- PART 2 : logical operators ( AND, OR, NOT)
-- PART 3 - BETWEEN
-- PART 4 - IN, NOT IN
-- PART 5 - Search (LIKE)
-- PART 6 - Count with filters

-- SYNTAX
-- select*
-- from table_name
--where condition;


--PART 1: Comparison operators (=, >, <, >=, <>, <=)
-- compare a column's value against something
-- (=) EQUAL to - WHERE town = 'Nairobi'
--(1=) Not equal to -WHERE town != 'Nairobi'
-- (>) Greater than - WHERE Price > 800
-- (<) Less than - WHERE Price < 800
-- (>=) Greater than or equal to WHERE Price >=800
-- (<=)

-- TO START CONNECT TO PREVIOUS DATA SCHEMA

set search_path to bookshopdb;

select *
from customers;

-- EQUAL TO (=) AND NOT EQUAL TO (!=)
-- Find all customers who live in Nairobi

Select *
from customers
where town = 'Nairobi';


-- Find all customers NOT in Nairobi
Select *
from customers
where town != 'Nairobi';

-- LESS AND GREATER THAN (< and >)
-- Find books that cost more tha 850

Select title, price from books
where price > 850

Select title, price from books
where price < 850

-- GREATER THAN OR EQUAL TO (=) and LESS THAN OR EQUAL TO (<=)
Select title, price from books
where price >= 850

Select title, price from books
where price <= 850

=/*
-- PART 2 
-Lets you combine multiple conditions in one WHERE clause
-Instead of running two seperate queries you can ask SQL to check two things at onceALTER 
-AND - Both conditions must be TRUE - WHERE Price is > 700 AND Stock > 10
-OR - Atleast one condition is TRUE - WHERE Town = 'Nairobi' or town = 'Mombasa'
- NOT - Reverses the condition - WHERE NOT Town = 'Nairobi'
***/


-- AND
-- Get books that cost more than 730 AND stock more than 18

select* from books;

SELECT title, stock 
from books
where  price  > 730 and stock > 18;


-- OR
-- find customers from Kisumu or Nairobi

select * from customers;

Select customer_name, town 
from customers
where town = 'Nairobi' or town = 'Kisumu';

-- NOT/ EXCLUDING
-- Flips condition
--Find all books where author is not Ngugi wa Thiongp

select title, author
from books
where not author = 'Ngugu wa Thiongo';


-- COMBINING AND + OR TOGETHER
-- Find books by Ken Walibora that cost more than 550
-- we use brackets () to be clear about which conditions go together

select title, author
from books
where author = 'Ken Walibora' and price > 500;


-- AND OR

select title, author
from books
where author = 'Ken Walibora' and price > 500 or price > 830;

-- More than 3 conditions

select title, author
from books
where (author = 'Ken Walibora' and price > 500) or stock > 19;


-- PART 3 BETWEEN or (<= >=)
-- Checks if a value falls within a range - btwn a min value and a max valye 

-- find books which are priced between 400 and 900

Select title, author
from books
where price between 400 and 900;

Select title, author
from books
where price  >= 400 and price <= 900;

-- NOT BETWEEN
-- Prices not in this range

Select title, author
from books
where price not between 400 and 900;

-- PART 4: IN, NOT IN

-- IN 
-- IN lets you check if a value matches any item in a list
-- Instead of writing many OR condition, you list all the items/ values you want outputed

-- WHERE, COLUMN NAME, IN (value1, value2, value3)


-- FIND Customers in Nakuru, Nairobi, Kisumu
Select customer_name, town
from customers
where town in ('Nakuru', 'Nairobi', 'Kisumu')

Select stock, title
from books
where stock in (14, 10, 8)

-- NOT IN
-- Gives me rows that do not match the list
-- Any value in the list is excluded
-- FIND Customers NOT IN Nakuru, Nairobi, Kisumu

Select customer_name, town
from customers
where town not in ('Nakuru', 'Nairobi', 'Kisumu')


-- PART 5 SEARCH (LIKE)
-- This lets you search for a PATTERN inside a text column.
-- We use some special Wildcards/symbols (%a%b%), (_)
-- % - This means any number of characters including zero - 'A%', '%ing'
-- (_) - Means exactly ONE Character - _rian. Any name that ends with rian but has one character/letter before it
-- e.g brian. but Libraian will not be included as it has 4 characters before rian. For this we use %
 
-- Formular is : WHERE, COLUMN NAME, LIKE ' PATTERN'


-- %-- 
-- Where title starts with TH and any other character after that
select *
from books;

Select title 
from books
where title like 'Th%';

select * from customers;

Select email
from customers
where email like '%gmail.com'
 
-- where customer name has 'ia' in it
select customer_name
from customers
where customer_name like '%ia%';


-- NOT LIKE
-- Excludes a pattern

select customer_name
from customers
where customer_name not like '%ia%';


-- (_)
-- We want to see town from customer atble where town ends with airobi

Select town
from customers
where town like '_airobi';

-- Two underscores (_ _)
Select town
from customers
where town like '__irobi';


-- PART 6 COUNT with Filters

-- COUNT tells you how many rows match your condition
-- Count (*) - Counts all rows

-- How many books are in the database in total
--SELECT, COUNT (*) AS ' TITLE OF COLUMn'
--FROM TABLE NAME

select count(*) as total_books
from books;

-- How many books cost more than 600 - Two columns conditions- books and price

--SELECT, COUNT (*) AS ' TITLE OF COLUMN'
--FROM TABLE NAME
-- WHERE SECOND COLUMN NAME , CONDTION

select count(*) as Premium_books
from books
where price > 800;

-- How many customers are from Nairobi

Select count (*) as Nairobi_customers
from customers
where town = 'Nairobi';

-- Counting books and books low on stock
-- low stock is <= 14

select count(*) as Low_stock
from books
where stock <= 14;

-- TEST QUESTIONS

-- Find all books that cost exactly 750

Select title, price
from books
where price > 750;

--Find all books that are NOT Written by Ken Walibora

Select title, author 
from books
where not author = 'Ken Walibora';

Select title, author 
from books
where author != 'Ken Walibora';

-- Find all books where stock is greater than or equal to 14

select title, stock
from books 
where stock >= 14;

-- Customers who live in Kisumu and Eldoret


Select customer_name, town
from customers
where  town in ('Kisumu', 'Eldoret');

-- Find books whose stock is NOT between 20 and 10

Select *
from books
where stock not between 10 and 20;


-- PART 7: ADDING NEW COLUMNS USING 'CASE WHEN'
/*
--Its sql's way of asking 'if this, then taht' - like making a decision
-- lets you create new column in your results based on a condition you define

-- SYNTAX - how you write
-- Select column_name,
	CASE
		When condition1 Then 'result1'
		When condition2 Then 'result2'
		ELSE 'default result'
	End as new_column_name
FROM your_table;


-- CASE - starts CASE WHEN block- Saying i am about to make a decision
-- WHEN - the condition to check - IF this is true do this xxx
-- Then - What value to return whe the condition is TRUE,
-- ELSE - What values to return if NONE of the WHEN condition is matched/ defaulr/fallback
--END - It closes the CASE WHEN block - Must be there
--AS - gives new column a name of your results
 
 *
 *EXAMPLE- in our books table, add label that says each book is Premium, Affordable or Cheap
 *Price below 700 = Cheap, Price between 700 and 850 is affordable, Above 850 = Premium 
*/
 
Select * 
from books;
	
-- We want title, author and price

Select title, author, price,
case 
	when price < 750 then 'Cheap'
	when price between 750 and 850 then 'Affordable' -- we can also use <=850 instead
	Else 'Premium'
end as price_category
from books;


-- We want to look at each book and show message like 'In Stock' or 'Out of Stock' based on stock column in books table
-- In stock above 14 , Out of stock less than 14 

Select title, stock,
Case
	when stock > 14 then 'In Stock'
	Else 'Out of Stock'
End as Stock_Availabilty
from books;
END

-- Group towns as HQ and Branch Town;
-- Nairobi as HQ

Select customer_name, town,
CASE
	when town = 'Nairobi' then 'HQ Town'
	Else 'Branch Town'
End as Town_type
from customers;
END
