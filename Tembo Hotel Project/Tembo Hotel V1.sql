--create schema tembo_hotel;

set search_path to tembo_hotel;
 
create table staging_bookings(
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


----- DUPLICATE THE TABLE AS BACKUP
create table cleaned_bookings as 
select * from staging_bookings;


select * from cleaned_bookings;

--========================================== DATA CLEANING PROCESS=========================================================================================
/*-- ===================== PART 1 - INSPECTING THE DATA TO FIND PROBLEMS FIRST================================================================================================================================

--First step was to inspect the data set to understand what aspects need to be cleaned.

/*Problems we found on our table job_applications
 * 1) UPPERCASE names - N- Convert to proper case
 * 2) lowercase names -   grace mwangi  - Convert to proper case
 * 3) NULL emails -  app_id 5, 14 -  identify them and handle 
 * 4) NULL phone values - app_id 6,14 - identify them and handle the nulls 
 * 5) NULL city values - app_id 12 - identify them and handle the nulls 
 * 6) Phone number formats chaose - '07', '254', '+254' - standardise to one format
 * 7) Inconsistent gender values - ' F, M, Male & Female' - standardise to 'M' or 'F'
 * 8) Inconsistent DATE - (01/03/2024, 2024-03-02) - standardise to one format
 * 9) City typo - 'Thikax' (double i) - Fix the typo with REPLACE or UPDATE 
 * 10) Inconsistent city casing - 'mombasa', 'NAIROBI', 'nairobi' - standardise all to 'Nairobi', 'Mombasa'
 * 11) Extra spaces in name - '  grace mwangi  ' - TRIM leading/trailing spaces 
 * 12) Salary stored as text - 'KES 55000' - Strip non-numeric characters, cast to INT
 * 13) Duplicate entry - app_id 2 and 11 are the same - Detect and remove the duplicates





 
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

 What needs to be cleaned by column
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

alter table cleaned_bookings
alter column room_rate_per_night type decimal using room_rate_per_night::decimal;
alter column guest_phone type varchar (50) using guest_phone::varchar(50);
alter column guest_city type varchar (100) using guest_city::varchar (100);
alter column guest_nationality type varchar (100) using guest_nationality::varchar (100);
alter column room_no type varchar (100) using room_no::varchar (100);
alter column room_type type varchar (100) using room_type::varchar (100);
alter column room_rate_per_night type decimal using room_rate_per_night::decimal;
alter column check_in_date type date using check_in_date::date;
alter column check_in_out type date using check_in_out::date;
alter column nights_stayed type numeric using nights_stayed ::numeric;
alter column staff_name type varchar (100) using staff_name::varchar (100);
alter column staff_department type varchar(50) using staff_department::varchar (50);
alter column staff_salary type varchar(100) using staff_salary::varchar(100);
alter column staff_salary type decimal using staff_salary::decimal;
alter column payment_method type varchar(50) using payment_method::varchar(50);
alter column booking_status type varchar(100) using booking_status::varchar(100);
alter column total_amount type decimal using total_amount::decimal;
alter column service_used type varchar(100) using service_used::varchar(100);
alter column service_price type decimal using service_price::decimal;
alter column guest_rating type int using sguest_rating ::int;
*/

--===============================================================================================================================================
-- =============================PART 2 - FIXING NAMES and TEXT PROBLEMS=================================================================================
*/
 -- STEP 2) TRIM AND CLEAN TEXT
 -- Remove spaces, junk characters
-- View the inconcistencies by column in order to change them view the 
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

-- A) TRIM & REMOVED Unnecessary variables and leading and trailing spaces in the names
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
select guest_phone = '0' || right(guest_phone, 9)
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

-- Replace the ',' with Unknown
update cleaned_bookings
set total_amount = 'Unknown'
where total_amount = ',';

--- Remove the KES

SELECT 
    total_amount,
    REPLACE(total_amount, 'KES ', '') AS total_amount_cleaned
FROM cleaned_bookings;

update cleaned_bookings
set total_amount = replace(total_amount,'KES ', '')
where total_amount ='KES %';



-- OK columns
-- Room_rate_per_night
-- Room_no

--------------------------------------



select * from cleaned_bookings;

SELECT total_amount, COUNT(*) 
FROM cleaned_bookings 
GROUP BY total_amount
ORDER BY COUNT(*) DESC;




