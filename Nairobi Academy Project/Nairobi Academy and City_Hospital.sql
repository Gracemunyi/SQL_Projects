--========================================== GRACE MUNYI================================================================================ 
--========================================ASSIGMENT 2 SQL================================================================================ 

/*==============================Part 1 – String Functions ( using: Nairobi_academy)================================================================================
 */ 

set search_path to nairobi_academy, city_hospital;


--1)Write a query to display each student's full name in UPPERCASE and their city in lowercase. Name the columns upper_name and lower_city.

select 
	upper(concat(first_name, ' ', last_name)) as upper_name,
	lower(city) as lower_city
from students;

--2)	Write a query to show each student's first name and the LENGTH of their first name. Order the results from longest to shortest name.

select 
	first_name, 
	length(first_name) as first_name_length
from students
order by first_name desc;

--3)	Write a query to show each subject's name and a short version - the first 4 characters of the subject name ... called short_name. Also show the full subject name length.

-- subject name
--short version 1st 4 characters - short_name
-- subject name length

select * from subjects;

select subject_name, 
	left(subject_name, 4)as short_name,
	length(subject_name) as subject_length
from subjects;

--4)	Write a query using CONCAT to produce a sentence for each student in this format: 'Amina Wanjiku is in Form 3 and comes from Nairobi'. Call the column student_summary.

select concat(first_name, ' ', last_name, ' ', 'is in Form 3 and comes from Nairobi')as student_summary
from students;	



/*=================================Part 2- Number Functions  (using: Nairobi_academy) ================================================================================
 */ 

-- 1) Write a query to show each exam result alongside the mark rounded to 1 decimal place, the mark rounded UP to the nearest 10 using CEIL, and the mark rounded DOWN using FLOOR.
--mark rounded to 1 decimal place
--mark rounded UP to nearest 10
--mark rounded DOWN using FLOOR

select * from exams_results;

select result_id,
	grade,
	round(marks, 1) as rounded_marks,
	ceil(marks/10) * 10  as round_up_10,
	floor(marks) as rounded_down
from exams_results;


-- 2)Write a query to calculate the following summary statistics for exam_results in one query: total number of results (COUNT), average mark (AVG rounded to 2 decimal places), highest mark (MAX), lowest mark (MIN), and total marks added together (SUM).

select 
	count(result_id) as total_no_of_results,
	round(avg(marks), 2) as avg_marks,
	max(marks) as highest_marks,
	min(marks) as lowest_marks,
	sum(marks) as total_marks
from exams_results;

set search_path to nairobi_academy; 


-- 3)The school wants to apply a 10% bonus to all marks. Write a query to show each result_id, the original marks, and the new boosted_mark rounded to the nearest whole number.

select  result_id, marks,
round((marks * 0.1),0)+ marks as bonus_marks
from exams_results
group by result_id, marks;

select  result_id, marks,
round((marks * 0.1),0) as rounded_marks, 
round((marks * 0.1),0)+ marks as bonus_marks
from exams_results;

/*================================Part 3 – Date & Time Functions(PostgreSQL) – using: nairobi_academy=================================================================================
 */ 

--1)	Write a query to extract the birth year, birth month, and birth day from each student's date_of_birth as three separate columns. Show first_name alongside them.

select  first_name, 
	to_char(date_of_birth,'YYYY') as birth_year,
	to_char(date_of_birth, 'FMMonth') as birth_month, --use FMMonth to show months as Jan, feb etc
	to_char(date_of_birth, 'd') as birth_day
from students;

-- or

select first_name,
	extract(year from date_of_birth) as birth_year,
	extract(month from date_of_birth) as birth_month,
	extract(day from date_of_birth) as birth_day	
from students;

--2)	Write a query to show each student's full name, their date_of_birth, and their age in complete years. Order from oldest to youngest.

-- age = current_year - birth_year

select 
	concat(first_name, ' ', last_name),
	date_of_birth,
	extract(year from current_date)  - extract(year from date_of_birth) as age
from students
order by age desc;

--3)	Write a query to display each exam date in this exact format: 'Friday, 15th March 2024'.. Call the column formatted_date.

select 
	to_char(exam_date,'FMday, DDth FMMonth  YYYY') as formatted_date
from exams_results;

/*====================================Part 4 – SQL JOINS (Using: city_hospital) =================================================================================
 */  

--1)	Write an INNER JOIN query to show each appointment alongside the patient's full name, the doctor's full name, the appointment date, and the diagnosis.
-- tablest - appointments, patients, doctors, 
a.appointement_id, p.full_name, d.full_name, a.appt_date, a.diagnosis

select 
	a.appointment_id, 
	p.full_name as patient_name,
	d.full_name as doctor_name,
	a.appt_date, 
	a.diagnosis
from doctors d
inner join appointments a on d.doctor_id = a.doctor_id
inner join patients p on p.patient_id = a.patient_id;

--2)	Write a LEFT JOIN query to show ALL patients - and if they have an appointment, show the appointment date and diagnosis. Patients with no appointments should still appear with NULL values
-- patients to start on the left then join appointments
-- p.patients, a.appointment_id, a.appt_date, a.diagnosis

select p.patient_id, 
	a.appointment_id, 
	a.appt_date, 
	a.diagnosis
from patients p 
left join appointments a on p.patient_id = a.patient_id; 

--3)	Write a RIGHT JOIN query to show ALL doctors - and if they have seen a patient, show the patient name. Doctors with no appointments should still appear.

-- right side is doctors table 
-- starting table is patient
 p.patient_id, p.full_name, 
 -- doctors with no appointment shouldnt be excluded this either left or right join
 
select p.patient_id,
 	p.full_name as patient_name, 
 	d.full_name as doctor_name
from patients p
right join appointments a on a.patient_id = p.patient_id
right join doctors d on d.doctor_id = a.doctor_id;

--4)Write a query using LEFT JOIN and WHERE IS NULL to find all patients who have NEVER had an appointment. Show patient full_name and city.

select p.city,
	p.full_name as patient_name, 
	a.appointment_id
from patients p
left join appointments a on a.patient_id = p.patient_id
where appointment_id is null
order by patient_name, p.city;

--5)	Write a three-table INNER JOIN to show each appointment with: the patient name, the doctor name, and the medicine prescribed (from prescriptions). Show appointment_id, patient name, doctor name, and medicine_name.

a.appointment_id, p.full_name, d.full_name, medicine_name

--Tables joining - Patientsv> appointments > doctors > prescription 

patient - patient_id, 
appointment = appointment_id, patient_id, doctor_id
prescr- prescrp_id , appointment_id
department - dept_id
doctor - doctor_id, dept_id

select 
	pr.medicine_name,
	p.full_name as patient_name,
	d.full_name as doctor_name, 
	a.appointment_id
from patients p
inner join appointments a on a.patient_id = p.patient_id
inner join doctors d on d.doctor_id = a.doctor_id
inner join prescriptions pr on pr.appointment_id = a.appointment_id;

/*=====================================Part 5 - Window Functions (using: nairobi_academy)================================================ =================================
 */ 

--1)	Write a query using ROW_NUMBER() to assign a unique rank to each exam result, ordered from highest mark to lowest. Show result_id, student_id, marks, and row_num.

--ROW_NUMBER() to each exam result/marks
--then order the mark from highest mark to lowest
--Show result_id, student_id, marks, and row_num

select result_id,student_id, marks, 
	row_number() over (order by marks desc) as row_num
from exams_results;
	
--2)	Write a query using RANK() and DENSE_RANK() on exam results ordered by marks descending. Show both columns side by side so the difference between them is visible.

-- using RANK() and DENSE_RANK() on exam result/marks
-- marks ordered desc
-- name rank() column and dense_rank() column
-- rank skips number when there are ties and dense_rank does not skip

select student_id, marks,
	rank() over (order by marks desc) as marks_rank,
	dense_rank() over(order by marks desc) as marks_dense_rank
from exams_results;

--3)	Write a query using NTILE(3) to divide all exam results into 3 performance bands (1 = top, 2 = middle, 3 = bottom). Show result_id, marks, and band. Also add another column named performance bands of exam results based on the NTILES

FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
-- can't reference marks_bands alias in case when because it is a column being created under select hence its not yet available
-- SQL evaluates clauses in order above 

select result_id, marks,
	ntile(3) over(order by marks) as marks_bands,
	case
		when ntile(3) over(order by marks) = 1 then 'Top'
		when ntile(3) over(order by marks) = 2 then 'Middle'
		when ntile(3) over(order by marks) = 3 then 'Bottom'
		end as performance_bands
from exams_results;

--4)	Write a query using AVG() OVER(PARTITION BY student_id) to show each exam result alongside that student's personal average mark. Show student_id, marks, and student_avg rounded to 2 decimal places.

--AVG() OVER(PARTITION BY student_id)
-- show each exam result/marks
--student's personal average mark
-- student_id, marks, and student_avg rounded to 2 decimal places

select student_id, marks,
	round(avg(marks) over (partition by student_id), 2) as avg_marks
from exams_results;

--5)	Write a query using LAG() to show each exam result alongside the previous result's marks for the same student. Also calculate the improvement (current marks minus previous marks). Use PARTITION BY student_id.

-- using LAG() - alwasy include order by so that lag knows which was the previous row.
-- BY student_id
-- each exam result alongside the previous result's marks for the same student
--calculate the improvement (current marks minus previous marks)

select student_id, result_id, marks,
	lag(marks) over(partition by student_id order by result_id) as previous_marks,
	marks -lag(marks) over(partition by student_id order by result_id) as improvement
from exams_results;


--===================================Part 6 - SET Operators (using both databases)=====================================================
 
-- 1)	Write a UNION query to show a combined list of all unique cities from the students table and the patients table. Order alphabetically.

select * from patients;
select * from students;

select city
from students

union 

select city
from patients 

order by city asc;

-- 2)	Write a UNION ALL query to combine all student first names and all patient full names into one list. Add a second column called source that says 'Student' or 'Patient' so you can tell where each name came from.

--- To take students first name and have patients full name 
select 
first_name as name,
'Student' as source
from students

union all 

select 
full_name as name,
'Patient' as source
from patients;

----- To take students first name and extract patients first name only

select 
first_name as name,
'Student' as source
from students

union all 

select split_part(full_name, ' ', 1)as name,
'Patient' as source
from patients;

-- 3)	Write an INTERSECT query to find cities that appear in BOTH the students table and the patients table - cities that are home to both students and patients.

select city 
from students

intersect

select city 
from patients;

-- 4)	Write a query that combines all of the following into one result using UNION ALL - student names (labelled 'Student'), patient full names (labelled 'Patient'), and doctor full names (labelled 'Doctor'). Order the final result by the source label, then by name.

-- combine using UNION ALL
-- student names (labelled 'Student')
-- patient full names (labelled 'Patient')
-- doctor full names (labelled 'Doctor')
-- Order the final result by the source label, then by name.

select
full_name as name,
'Patient' as source
from patients

union all

select
concat(first_name,' ', last_name) as name,
'Student' as source
from students

union all

select 
full_name as name,
'Doctor' as source
from doctors

order by name, source; -- orders in alphabet




#city_hospital
select * from appointments;
select * from departments;
select * from doctors;
select * from patients;
select * from students;
select * from prescriptions;


#nairobi_academy
select * from employees_windows_dataset;
select * from exams_results;
select * from students;
select * from subjects;


