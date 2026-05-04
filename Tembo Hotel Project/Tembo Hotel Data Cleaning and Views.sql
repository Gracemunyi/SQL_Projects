create schema tembo_hotel;

set search_path to tembo_hotel;
 
create table staging_bookings(  -- So as to allow all the data to import in SQL without excluding some of the datapoints with errors

booking_id text,
guest_name text,
guest_phone TEXT,
guest_city TEXT,
guest_nationality TEXT,
room_no TEXT,
room_type TEXT,
room_rate_per_night TEXT,
check_in_date TEXT,
check_out_date TEXT,
nights_stayed TEXT,
staff_name TEXT,
staff_department TEXT,
staff_salary TEXT,
payment_method TEXT,
booking_status TEXT,
total_amount TEXT,
service_used TEXT,
service_price TEXT,
guest_rating TEXT
);
--- ORIGINAL DATASET
select * from staging_bookings;


----- DUPLICATE THE TABLE TO CREATE BACKUP
create table cleaned_bookings as 
select * from staging_bookings;

select * from cleaned_bookings;

--========================================== DATA CLEANING PROCESS=========================================================================================
/*-- ===================== PART 1 - INSPECTING THE DATA TO FIND PROBLEMS FIRST================================================================================================================================

--First step was to inspect the data set to understand what aspects need to be cleaned.

Problems we found on our table job_applications
 1) Different check_in & chec_out_date formats e.g 2/3/24, 8/25/2024
 2) Different names formats
 3) some guest_phones had characters such as +254 and dashes e.g 07-25-73-64
 4) guest_nationality names were in different formats e.g Capital KENYAN and small Kenyan
 5) Room_type data the same was also in mixed formats e.g dlx, deluxe etc
 6) Other columns had leading and trailing spaces in the names
 7) Room numbers had empty rows, spaces, junk characters like commas, KES 250000 etc
 8) Payment method names hax mixed formats M-Pesa and mpesa
 
 STEP 2) TRIM AND CLEAN TEXT
 STEP 3) FIXING NUMERICS 
 STEP 4) VALIDATE BEFORE CONVERTING
  - check ros that will fail conversion 
  -- Numeric check 
  SELECT room_rate_per_night
FROM cleaned_bookings
WHERE room_rate_per_night !~ '^[0-9]+(\.[0-9]+)?$';

 - date check 
 SELECT check_in_date
FROM cleaned_bookings
WHERE TO_DATE(check_in_date, 'YYYY-MM-DD') IS NULL;

STEP 5) CONVERTED COLUMNS TO IDEAL DATA TYPES
--- Final step after cleaning is convert columns data type from text to ideal data types ie
--- INT for whole number columns such as 
-- DATE for check_in and check_out date columns
-- VARCHAR for descriptive columns
-- NUMERIC for columns dealing decimal points such as money or measurements ie decimal points,  such as service_price 
*/


--====================================================Makosa ikifanyika================================================================================================================

--RUN THE BELOW QUERY TO REPLACE DATA ON ERRORED COLUMN FROM YOUR BACKUP TABLE

select cb.total_amount wrongvalue_, -- from your working table column
sb.total_amount correctvalue_ -- backup table column/
from cleaned_bookings cb
join staging_bookings sb
on cb.booking_id = sb.booking_id; -- using common key
 
update cleaned_bookings cb -- you update working table
set total_amount = sb.total_amount
from staging_bookings sb
where cb.booking_id = sb.booking_id;


/*
--===============================================================================================================================================
-- =============================PART 2 - FIXING NAMES and TEXT PROBLEMS=================================================================================
 
-- STEP 2) TRIM AND CLEAN TEXT
-- Remove spaces, junk characters
-- View the inconcistencies by column in order to change them view the 
*/

SELECT guest_city, COUNT(*) 
FROM cleaned_bookings 
GROUP BY guest_city
ORDER BY COUNT(*) DESC;

-- Correcting inconsistencies in the whole column
-- A) INITCAP - Capitalising the first letters of each name 
update cleaned_bookings
set guest_name = initcap(guest_name)
where guest_name != initcap(guest_name);

update cleaned_bookings
set guest_city = initcap(guest_city) 
where guest_city != initcap(guest_city);

update cleaned_bookings
set room_type = initcap (room_type)
where room_type != initcap(room_type);
 
update cleaned_bookings
set booking_status = initcap(booking_status)
where booking_status != initcap(booking_status);
 
-- B) TRIM - Removed leading and trailing spaces in the names
-- guest_name
update cleaned_bookings
set guest_name = trim(guest_name)
where guest_name != trim(guest_name);
-- guste_city
update cleaned_bookings
set guest_city = trim(guest_city) 
where guest_city != trim(guest_city);

--- staff_name 
update cleaned_bookings
set staff_name = trim(staff_name)
where staff_name !=trim(staff_name);

-- staff department
update cleaned_bookings
set staff_department = trim(staff_department)
where staff_department !=trim(staff_department);

-- booking status
update cleaned_bookings
set booking_status = trim(booking_status)
where booking_status !=trim(booking_status);

-- Payment_method
update cleaned_bookings
set payment_method = trim(payment_method)
where payment_method !=trim(payment_method);

-- Service_used
update cleaned_bookings
set service_used = trim(service_used)
where service_used !=trim(service_used);

-- C) Correcting spellings in names/lables 
update  cleaned_bookings
set guest_city = 'Thika'
where guest_city = 'Thikax';

-- D) Filling blank text columns with unknown
-- guest_city
update  cleaned_bookings
set guest_city = 'Unknown'
where guest_city = '';

-- service used
update cleaned_bookings
set service_used = 'Unknown'
where service_used = '';

-- E) Standardize the format of Nationality and proper case

update cleaned_bookings
set guest_nationality  = 'Kenyan'
where guest_nationality = 'KENYAN';

-- standardize room_type
update cleaned_bookings
set room_type = 'Deluxe'
where room_type = 'Dlx';

update cleaned_bookings
set room_type = 'Standard'
where room_type = 'Std';

update cleaned_bookings
set payment_method = 'M-Pesa'
where payment_method = 'mpesa';

--===========================================================================================================================================
--==============================PART 2 - FIXING NUMERIC COLUMNS =================================================================================

-- A) TRIM & REMOVED Unnecessary variables and leading and trailing spaces in numerics
-- this is to standardise the phone number

-- Phone number column
-- First, we tested the format change by creating a temporary column
select guest_phone,
       '0' || right(guest_phone, 9) as new_format
from cleaned_bookings
where guest_phone like '+254%'
limit 10;

--- Now we apply the fix
update cleaned_bookings
set guest_phone = '0' || right(guest_phone, 9)
where guest_phone like '+254%';

--- Phone numbers 
-- removing the hyphen (-) 0745-678-901
select replace(guest_phone, '-','') as cleaned_number
from cleaned_bookings;

update cleaned_bookings
set guest_phone = replace(guest_phone, '-', '');

--OR
update cleaned_bookings
set guest_phone = replace (guest_phone, '-', '')
where guest_phone like '%-%';

-- Fill in the blank columns with unknown
update cleaned_bookings
set guest_phone = 'Unknown'
where guest_phone = '';

---- TRIM date to remove unnecessary spaces

update cleaned_bookings
set guest_phone = trim(guest_phone)
where guest_phone !=trim(guest_phone);


-- B) CHANGING DATES - to ideal format DD-MM-YYYY
-- there were two error types of dates in the check_in and check_out dates 27-05-24 and 2024-06-23

--- CHECK_IN_DATE CHANGE 
-- converts any date format with a SLASH(/) e.g 04/12/2023 to date format with a  DASH(-) ie 04-12-2023
update cleaned_bookings
set check_in_date = to_date(check_in_date, 'DD-MM-YYYY')::text
where check_in_date like '%/%';

----change this date 27-05-24 to normal format of 05/06/2024
update cleaned_bookings
set check_in_date = to_date(check_in_date, 'DD-MM-YY')::text
where check_in_date like '%-%' and length (check_in_date) = 8;
 
--- change this date format 06-23-2023 to the normal one format
-- under split_part  bracket we indicate 1 because its month (which starts) that should be less than 12.
update cleaned_bookings
set check_in_date = to_date(check_in_date, 'MM-DD-YYYY')::text
where check_in_date like '%-%' and length (check_in_date) = 10 and split_part (check_in_date,'-',1)::integer <=12;
 
-- We use this if our date format was DD-MM-YYYY and we want to change to the MM-DD-YYY format.
-- under split_part bracket, we are changing from 1 to 2, because its month that should be less than 12.
update cleaned_bookings
set check_in_date = to_date(check_in_date, 'DD-MM-YYYY')::text
where check_in_date like '%-%' and length (check_in_date) = 10 and split_part (check_in_date,'-',2)::integer <=12;

--- When you have specific date that you are to change only
update cleaned_bookings
set check_in_date = '2024-11-15'
where check_in_date = '15-11-2024';

------CHECK_OUT_DATE CHANGE
-- converts any date format with a SLASH(/) e.g 04/12/2023 to date format with a  DASH(-) IE 04-12-2023
update cleaned_bookings
set check_out_date = to_date(check_out_date, 'DD-MM-YYYY')::text
where check_out_date like '%/%';

----change this date 27-05-24 to normal format of 05/06/2024
update cleaned_bookings
set check_out_date = to_date(check_out_date, 'DD-MM-YY')::text
where check_out_date like '%-%' and length (check_out_date) = 8;
 
---change this date format 06-23-2023 to the normal one format
-- under split_part  bracket we indicate 1 because its month (which starts) that should be less than 12.
update cleaned_bookings
set check_out_date = to_date(check_out_date, 'MM-DD-YYYY')::text
where check_out_date like '%-%' and length (check_out_date) = 10 and split_part (check_out_date,'-',1)::integer <=12;
 
-- We use this if our date format was DD-MM-YYYY and we want to change to the MM-DD-YYY format.
-- under split_part  bracket we are changing from 1 to 2, because its month that should be less than 12.
update cleaned_bookings
set check_out_date = to_date(check_out_date, 'DD-MM-YYYY')::text
where check_out_date like '%-%' and length (check_out_date) = 10 and split_part (check_out_date,'-',2)::integer <=12;

--When you have specific date that you are to change only
update cleaned_bookings
set check_out_date = '2024-11-17'
where check_out_date = '17-11-2024';


-- Remove -ve in Nights_stayed_ column
-- Its the row where the check in date is after check out date
-- likely we exclude it

--- C) STAFF SALARY
-- Replace 'KES ,' rows with unknown
update cleaned_bookings
set staff_salary = 'Unknown'
where staff_salary = 'KES ,';

-- to enable the column accept it as numeric when converting column type 

update cleaned_bookings
set staff_salary = null
where staff_salary = 'Unknown';


update cleaned_bookings
set staff_salary = trim(staff_salary)
where staff_salary !=trim(staff_salary);

-- D) Total_amount
-- The column has errors such as characters, mixed currecy format ie KES 65000, commas, extra space in values
-- we need to TRIM the space, replace the ',' with unknown and remove the KES and be left with the value only.

-- Triming
update cleaned_bookings
set total_amount = trim(total_amount)
where total_amount !=trim(total_amount);

--- Remove the KES
select
    total_amount,
   replace(total_amount, 'KES ', '') as total_amount_cleaned
from cleaned_bookings;

update cleaned_bookings
set total_amount = replace(total_amount, 'KES ', '')
where total_amount like 'KES %';

-- Remove the  comma in currencies (8,500)
update cleaned_bookings
set total_amount = replace (total_amount,',', '')
where total_amount like '%,%';


-- Replace the ',' and blanks with Unknown
update cleaned_bookings
set total_amount = 'Unknown'
where total_amount = ',';

update cleaned_bookings
set total_amount = 'Unknown'
where total_amount = '';

-- Convert Unknown to NULL - to enable the column accept it as numeric when converting column type 

update cleaned_bookings
set total_amount = null
where total_amount = 'Unknown';

update cleaned_bookings
set total_amount = ''
where total_amount = null;

select * from cleaned_bookings;

--- SERVICE PRICE 
-- over 60% of its columns were blanks. 
-- We should replace them with unknown

update cleaned_bookings
set service_price = trim(service_price)
where service_price != trim(service_price);
 
update cleaned_bookings
set service_price = 'Unknown'
where service_price = '';
--- Convert Unknown to NULL - to enable the column accept it as numeric when converting column type 
update cleaned_bookings
set service_price = null
where service_price = 'Unknown'; 

-- GUEST RATING
-- triming
update cleaned_bookings
set guest_rating = trim(guest_rating)
where guest_rating != trim(guest_rating);

-- Convert Unknown to NULL - to enable the column accept it as numeric when converting column type 
update cleaned_bookings
set guest_rating = null
where guest_rating = ''; 

--COLUMNS WITH NO ISSUES
-- Room_rate_per_night
-- Room_no

--===========================================================================================================================================
--========================================PART 3 - REMOVE DUPLICATES===================================================================================

-- Find rows where the entire record is identical across every column.

select booking_id, count(*) as total
from cleaned_bookings
group by booking_id 
having count (*) > 1;


select * from cleaned_bookings
where booking_id = 'BK0006';

---------OR 

--YOU CAN CHECK DUPLICATES BY CHECKING IF ALL COLUMNS MATCH 
--Using a sub query.
-- check the count over partition by all columns
-- the put that inside an outer Select * from, WHERE inner table is > 1

select * from (
	select *, count(*) over (partition by guest_phone, guest_city, guest_nationality, room_no, room_type, room_rate_per_night, 
	check_in_date, check_out_date, nights_stayed, staff_name, staff_department, staff_salary, payment_method, booking_status, 
	total_amount, service_used, service_price, guest_rating) as dup_count 
	from cleaned_bookings) t 
where dup_count > 1;


-- DELETE the DUPLICATE once you confirm that the duplicate figure is the same 
delete from cleaned_bookings
where ctid in (
select ctid from (select ctid,row_number() over (partition by booking_id order by booking_id) as duplicate
from cleaned_bookings) t
where t.duplicate > 1 );


select * from cleaned_bookings
where booking_id = 'BK0006';



--===========================================================================================================================================
--===============================PART 4 -CHANGING COLUMNS DATA TYPE===================================================================================
/*
-- Once data cleaning is done, then we can convert columns type
booking_id - PRIMARY KEY -  to be set as a UNIQUE clause 
guest_name - varchar
guest_phone - varchar
guest_city - varchar
guest_nationality - varchar
room_no - varchar
room_type - varchar
room_rate_per_night - decimal
check_in_date - date
check_out_date - date
nights_stayed - numeric/int
staff_name - varchar
staff_department - varchar
staff_salary - decimal
payment_method - varchar
booking_status - varchar
total_amount - decimal
service_used - varchar
service_price - decimal
guest_rating - integer
*/
/*
alter table cleaned_bookings
add constraint pk_booking_id primary key (booking_id);
alter column room_rate_per_night type decimal using room_rate_per_night::decimal;
alter column guest_phone type varchar (50) using guest_phone::varchar(50);
alter column guest_city type varchar (100) using guest_city::varchar (100);
alter column guest_nationality type varchar (100) using guest_nationality::varchar (100);
alter column room_no type varchar (5) using room_no::varchar (5);
alter column room_type type varchar (20) using room_type::varchar (20);
alter column room_rate_per_night type decimal using room_rate_per_night::decimal;
alter column check_in_date type date using check_in_date::date;
alter column check_in_out type date using check_in_out::date;
alter column nights_stayed type numeric using nights_stayed ::numeric;
alter column staff_name type varchar (100) using staff_name::varchar (100);
alter column staff_department type varchar(50) using staff_department::varchar (50);
alter column staff_salary type varchar(100) using staff_salary::varchar(100);
alter column staff_salary type decimal using staff_salary::decimal;
alter column payment_method type varchar(50) using payment_method::varchar(50);
alter column booking_status type varchar(50) using booking_status::varchar(50);
alter column total_amount type decimal using total_amount::decimal;
alter column service_used type varchar(100) using service_used::varchar(100);
alter column service_price type decimal using service_price::decimal;
alter column guest_rating type int using guest_rating ::int;
*/

alter table cleaned_bookings
add constraint pk_booking_id primary key (booking_id);

--- test to confirm if booking_id  has been converted to primary key
-- It should not be able to insert a duplicate
Insert into cleaned_bookings (booking_id, guest_name, guest_phone, guest_city, guest_nationality, room_no, room_type, room_rate_per_night, check_in_date, check_out_date, nights_stayed, staff_name, staff_department, staff_salary, payment_method, booking_status, total_amount, service_used, service_price, guest_rating)
values ('BK0006', 'Felix Hassan', '0767890123', 'Nairobi', 'Kenyan', '101', 'Standard', '5500', '2024-01-10', '2024-01-15', '5', 'Amina Juma', 'Restaurant', '65000', 'Cash', 'Checked Out', '27500', 'Unknown', 'Unknown', '2'),
('BK0006', 'Felix Hassan', '0767890123', 'Nairobi', 'Kenyan', '101', 'Standard', '5500', '2024-01-10', '2024-01-15', '5', 'Amina Juma', 'Restaurant', '65000', 'Cash', 'Checked Out', '27500', 'Unknown', 'Unknown', '2');

alter table cleaned_bookings
alter column guest_name type varchar(100) using guest_name :: varchar(100);
 
 
alter table cleaned_bookings
alter column guest_phone type varchar (10) using guest_phone::varchar (10);
 
alter table cleaned_bookings
alter column guest_city type varchar (20) using guest_city::varchar (20);
 
alter table cleaned_bookings
alter column guest_nationality type varchar (20) using guest_nationality::varchar (20);
 
alter table cleaned_bookings
alter column room_no type varchar (5) using room_no::varchar (5);
 
alter table cleaned_bookings
alter column room_type type varchar (20) using room_type::varchar (20);
 
 
alter table cleaned_bookings
alter column room_rate_per_night type decimal using room_rate_per_night::decimal;
 
 
alter table cleaned_bookings
alter column check_in_date type date using check_in_date::date;
 
alter table cleaned_bookings
alter column check_out_date type date using check_out_date::date;
 
 
alter table cleaned_bookings
alter column nights_stayed type int using nights_stayed::int;
 
 
alter table cleaned_bookings
alter column staff_name type varchar (100) using staff_name::varchar (100);
 
 
alter table cleaned_bookings
alter column staff_department type varchar (50) using staff_department::varchar (50);
 
 
alter table cleaned_bookings
alter column staff_salary type decimal using staff_salary::decimal;
 
alter table cleaned_bookings
alter column payment_method type varchar (50) using payment_method::varchar (50);
 
alter table cleaned_bookings
alter column booking_status type varchar (50) using booking_status::varchar (50);
 
alter table cleaned_bookings
alter column total_amount type decimal using total_amount::decimal;
 
alter table cleaned_bookings
alter column service_used type varchar (50) using service_used::varchar (50);
 
alter table cleaned_bookings
alter column service_price type decimal using service_price::decimal;
 
alter table cleaned_bookings
alter column guest_rating type int using guest_rating::int;


--=======================================PART 5) CREATE A FINAL CLEAN TABLE=======================================================
-- This will later be used for PowerBI workflow
-- It can be exported as the final table anytime
-- Once can create it as a view to connect to PowerBI later

create table cleaned_bookings_final as
select *
from cleaned_bookings;

--======================================PART 6) ANALYSIS==========================================

--- Revenue analysis; Total revenue by month, by room type and by payment method

select * from cleaned_bookings_final;



---===1. Revenue analysis: Total revenue by month, by room type, by payment method
--a).Total revenue by month
select
date_part('month',check_out_date) as month,
date_part('year',check_out_date)::text as year,
sum(total_amount) as revenueamount_
from cleaned_bookings_final
group by month,year
order by year,month;

---b).Revenue by room type
select
room_type, sum(total_amount) as Revenue_by_room_type
from cleaned_bookings_final
group by room_type;

--c).Revenue by payment type
select payment_method,
sum(total_amount) as Revenue_by_payment_method
from cleaned_bookings_final
group by payment_method;



---2.Occupancy: 
---a).Room_types Booked the most 
select room_type,count(Booking_id) as bookingcount
from cleaned_bookings_final
group by room_type;

---or showing in desc
with Bookings as 
(select room_type,count(Booking_id) as bookingcount
from cleaned_bookings_final
group by room_type)
select room_type,bookingcount from bookings order by bookingcount desc;

--b).Average nights stayed per room type
select room_type,round(AVG(nights_stayed),0) as avg_stayed_per_roomtype
from cleaned_bookings_final
group by room_type;

---3.Guest insights:  
---a)Top 10 cities where guests come from 
select guest_city,count(booking_id) as count_by_city
from cleaned_bookings_final
group by guest_city 
order by count_by_city desc
limit 10;

---b)Average rating per room type
select room_type, round(avg(guest_rating),2) as avg_rating
from cleaned_bookings_final
group by room_type;

select *from cleaned_bookings_final;

---4.Staff performance: 
--a)Which staff handled the most bookings? 
select * from (
select staff_name,count(booking_id), dense_rank() over(order by count(booking_id)desc) 
as bookings_per_staff
from cleaned_bookings_final
group by staff_name)
where bookings_per_staff = 1;

--b)---Which department generates most revenue?
select staff_department, total_rev from (
select staff_department,sum(total_amount) as total_rev,
dense_rank()over(order by sum(total_amount)desc) as revenue_per_department
from cleaned_bookings_final
group by staff_department)
where revenue_per_department= 1;--- Subquery way

--OR the CTE way
with revenueby_staff_department_ as (
select staff_department,sum(total_amount) as deptrevenue_
from cleaned_bookings_final
group by staff_department)
select * from revenueby_staff_department_
where deptrevenue_ = (select max(deptrevenue_) from revenueby_staff_department_);

----5).Trends: 
--a)Revenue growth month over month (window function)
--- With percentage comparison
SELECT 
DATE_TRUNC ('month', check_in_date) AS month,
  SUM(total_amount) AS monthly_revenue,
  LAG(SUM(total_amount)) OVER (
    ORDER BY DATE_TRUNC('month',check_in_date )
  ) AS prev_month_revenue,
ROUND(
    (SUM(total_amount) - LAG(SUM(total_amount)) OVER (
        ORDER BY DATE_TRUNC('month', check_in_date))) 
    / LAG(SUM(total_amount)) OVER (ORDER BY DATE_TRUNC('month', check_in_date)
     ) * 100,2
  ) AS mom_growth_pct
FROM cleaned_bookings_final
GROUP BY DATE_TRUNC('month', check_in_date)
ORDER BY month;

----without the percentage comparison
select date_trunc ('month', check_in_date) as month,sum(total_amount) as monthlyrevenue_,
lag(sum(total_amount)) over (order by date_trunc('month',check_in_date )) 
as prevmonthrevenue__,
(sum(total_amount) - lag(sum(total_amount)) 
over (order by date_trunc('month', check_in_date))) as momgrowth_
from cleaned_bookings_final
group by date_trunc('month', check_in_date)
order by month;

---- USING CTE
with monthlyrevenue_ as(
select
date_part('month', check_in_date) as month,
date_part('year', check_in_date)::text as year,
sum(total_amount) as curentmonth_revenue_
from cleaned_bookings_final
group by 1, 2)
select *, lag(curentmonth_revenue_) over(order by mv.year,mv.month ) as previousmonth_
from monthlyrevenue_ mv;

---b).. Busiest vs quietest months
select * from cleaned_bookings_final;

with sum_bookings as (
select date_trunc('month', check_in_date) as month,
date_trunc('year', check_in_date)::text as year,
sum(total_amount) as bookings_per_month_total from cleaned_bookings_final
group by month, year)
select * from sum_bookings
where bookings_per_month_total = (select MAX(bookings_per_month_total) from sum_bookings)or bookings_per_month_total = (select MIN(bookings_per_month_total) from sum_bookings);

----6). Cancellations:  
 --- a).Cancellation rate per room type.
select booking_status,room_type, count(distinct booking_id)
from cleaned_bookings_final
where booking_status= 'Cancelled'
group by booking_status,room_type;

---Revenue Lost from cancellations and No shows
select booking_status, sum(total_amount) as lost_revenue
from cleaned_bookings_final
where booking_status= 'Cancelled' or booking_status= 'No Show'
group by booking_status;





--Total revenue by month
select
date_part('month',check_out_date) as month,
date_part('year',check_out_date)::text as year,
sum(total_amount) as revenueamount_
from cleaned_bookings_final
group by month,year
order by year,month;


-- Room Type
 
select room_type, sum(total_amount) as revenueby_roomtype_
from cleaned_bookings_final
group by room_type;
 
 
-- Payment Method
 
select payment_method, sum(total_amount) as revenueby_pm_
from cleaned_bookings_final
group by payment_method;

-- OCCUPANCY: Which room types are booked most? Average nights stayed per room type
*/
select room_type,
count(booking_id) as nightstayed_
from cleaned_bookings_final
group by room_type;

 -- b)average nights stayed per room type

--=========================================================================================================================================
-- VIEWS, INDEXING & POWERBI

-- INDEXING IS LIKE TABLE OF CONTENT

-- Index columns that you will regulary reference
-- Indexing columns that are likely foreign keys then we index them 
-- ie (room_no, )
-- Primary key - no need to index since SQL indexes automatically 
-- It helps Postgre retrieved the column's history faster 

-- COMPOSITE INDEX - Indexing more than one column
-- Columns frequentry filtered together e.g customer_id and order_date

-- Partial index -- Only indexes rows that meet a certain condition
-- e.g where phone number is not null

-- columns mostly used in WHERE BY and GROUP BY

Syntax
Create index index_name you want to give it
on table name (pass columns you are indexing)
-- e.g
CREATE INDEX index_name
ON table_name (column1, column2, ...);

create index guest_bookings
on cleaned_bookings_final(room_no, staff_name, guest_city, check_in_date);

-- to confirm index has been created
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'cleaned_bookings_final';


--======================= VIEWS ====================================

















