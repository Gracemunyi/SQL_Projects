--- Creating the SCHEMA

CREATE SCHEMA IF NOT EXISTS Nairobi_academy;

-- Set a path to the created schema above instead of having to add the schema name every time in your tables
Set search_path = Nairobi_academy;

-- Students table and its columns

Create table students(
student_id int PRIMARY KEY,
first_name varchar (50) Not null,
last_name varchar (50) not null,
gender varchar (1),
date_of_birth date,
class varchar (10),
city varchar (50)
);


-- Subjects table and its columns
Create table subjects(
subject_id INT PRIMARY KEY,
subject_name varchar(100) NOT NULL UNIQUE,
department varchar(50),
teacher_name varchar(100), 
credits INT
 );
 

-- Exams_Result Table  and its columns
-- It relies on student and subject table hence we are including their primary keys here as secondary keys
Create table Exams_results (
result_id int PRIMARY KEY,
student_id int NOT NULL,
Subject_id int NOT NULL,
Marks int NOT NULL,
Exam_date date,
grade varchar (2)
);


-- Add new column phone number in students table
Alter table students
add column phone_number varchar (20);

select *
from students;

-- Rename column credit to credit_hours in subjects table

Alter table subjects
rename column credits to credit_hours;

-- Remove/drop completely column phone_number in students table
Alter table students
drop column phone_number;

select*
from students;



