
--- Reading the Schema and tables created

set search_path = nairobi_academy;

Select *
from students;

Select *
from subjects;

Select *
from exams_results;

Insert into students (student_id, first_name, last_name, gender, date_of_birth, class, city)
values (1, 'Amina', 'Wanjiku', 'F', '2008-03-12', 'Form 3', 'Nairobi'),
(2, 'Brian', 'Ochieng', 'M', '2007-07-25', 'Form 4', 'Mombasa'),
(3, 'Cynthia', 'Mutua', 'F', '2008-11-05', 'Form 3', 'Kisumu'),
(4, 'David','Kamau', 'M', '2007-02-18', 'Form 4', 'Nairobi'),
(5, 'Esther', 'Akinyi', 'F', '2009-06-30', 'Form 2','Nakuru'),
(6, 'Felix', 'Otieno', 'M', '2009-09-14', 'Form 2', 'Eldoret'),
(7, 'Grace', 'Mwangi', 'F', '2008-01-22', 'Form 3', 'Nairobi'),
(8, 'Hassan', 'Abdi', 'M', '2007-04-09', 'Form 4', 'Mombasa'),
(9, 'Ivy', 'Chebet', 'F', '2009-12-01', 'Form 2', 'Nakuru'),
(10, 'James', 'Kariuki', 'M', '2008-08-17', 'Form 3', 'Nairobi');


insert into subjects (subject_id, subject_name, department, teacher_name, credit_hours)
values (1, 'Mathematics', 'Sciences', 'Mr.Njoroge', 4),
(2, 'English', 'Languages', 'Ms.Adhiambo', 3),
(3, 'Bioloby', 'Sciences', 'Ms. Otieno', 4),
(4, 'History', 'Humanities', 'Mr.Waweru', 3),
(5, 'Kiswahili','Languages', 'Ms.Nduta', 3),
(6, 'Physics', 'Sciences', 'Mr.Kamande', 4),
(7, 'Georgraphy', 'Humanities', 'Ms.Chebet', 3),
(8, 'Chemistry', 'Sciences', 'Ms.Muthoni', 4),
(9, 'Computer Studies', 'Sciences','Mr.Oduya',3),
(10, 'Business Studies', 'Humanities', 'Ms.Wangari', 3);


Insert into exams_results (result_id, student_id, subject_id, marks, exam_date, grade)
values (1, 1,1,78,'2024-03-15', 'B'),
(2,1,2, 85, '2024-03-16','A'),
(3,2,1, 92, '2024-03-15', 'A'),
(4,2,3, 55, '2024-03-17','C'),
(5,3,2, 49, '2024-03-16','D'),
(6,3,4, 71, '2024-03-18','B'),
(7,4,1, 88, '2024-03-15', 'A'),
(8,4,6, 63, '2024-03-19', 'C'),
(9,5,5, 39, '2024-03-20', 'F'),
(10,6,9, 95, '2024-03-21', 'A');


select *
from students;

select *
from subjects;

select *
from exams_results;


--- Update Esther Akinyi City from Nakuru to Nairobi
-- No need to use 'select' here. Just use 'Update' 
-- sytax in Update table name > set, then column being changed, then condition > where, info on row being selected,
--UPDATE table
--SET column = value
--WHERE condition;

Update students
set city = 'Nairobi'
where student_id = 5 and city = 'Nakuru';


-- Update marks for results ID 5 from 49 t059

Update exams_results
set marks = 59
where result_id = 5 and marks = 49;


-- DELETE exam results for student result_id 9
-- drop removes entire tables or database
-- delete removes specific rows only

delete from exams_results 
where result_id = 9; 


--C) QUERYING DATA (FILTERING USING WHERE)

-- All students in Form 4

Select*
from students
where class = 'Form 4';

-- All subjects in the Science department

select *
from subjects
where department = 'Sciences';


-- All Exam results where marks are greater thanor equal to 70 ( >=)

Select *
from exams_results
where marks >= 70;

-- All female students

Select *
from students
where gender = 'F';

-- All students who are in Form 3 AND from Nairobi

Select *
from students
where class = 'Form 3' AND city = 'Nairobi';

-- All students who are in Form 2 or Form 4

Select *
from students
where class = 'Form 2' or Class = 'Form 4';


--PART 2 -BETWEEN, IN/NOT IN, LIKE, COUNT and CASE WHEN
-- SECTION A - Range, Membership & Search Operators

-- All exam results where marks are between 50 & 80 (inclusive)

Select *
from exams_results
where marks between 50 and 80;

-- All exams took place between 15th March 2024 and 18th March 2024

select *
from exams_results
where exam_date between '2024-03-15' and '2024-03-18';

-- All students who live 'IN' Nairobi, Mombasa or Kisumu 

Select *
from students
where city in ('Nairobi', 'Mombasa', 'Kisumu');

-- All students who are 'NOT IN' form 2 or 3

select *
from students
where class not in ('Form 2','Form 3');

-- All students whos's first name startes with letter 'A'or 'E'
--(LIKE)

select *
from students 
where first_name like 'A%'
or first_name like 'E%';

-- All subjects whos subject name contains the word 'Studies'

Select *
from subjects
where subject_name like '%Studies%';


-- SECTION B - COUNT

-- Total students currently in For 3

Select count (*) as Total_Form3_Students
from students
where class = 'Form 3';

select count (*) as Above_Average_Results
from exams_results
where marks >= 70;


/*
 * -- SECTION C - CASE WHEN
USE CASE WHEN to label each exam result with a grade description:
•	'Distinction' if marks >= 80
•	'Merit' if marks >= 60
•	'Pass' if marks >= 40
•	'Fail' if marks below 40
Call the new column performance.
*/

select *
from exams_results;


select student_id, marks, grade,
case
	when marks >= 80 then 'Distinction'
	when marks >= 60 then 'Merit'
	when marks >= 40 then 'Pass'
	else 'Fail'
End as Performance
from exams_results;

/*
 *using CASE WHEN to label each student as:
•	'Senior' if they are in Form 3 or Form 4
•	'Junior' if they are in Form 2 or Form 1
Call the new column student_level. Show the student's first name, last name, class, and student_level in your result.
 */

select *
from students;

select first_name, last_name, class,
case
	when class = 'Form 3' or class = 'Form 4' then 'Senior'
	else 'Junior'
end as Student_level
from students;

















