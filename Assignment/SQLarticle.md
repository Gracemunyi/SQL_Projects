# Understanding PostgreSQL The Practical Way: From Database Structure to Data Querying

Week 3 of my Data Engineering journey was all about hands-on PostgreSQL. Here’s a simple summary of what I learnt, from building database structures to managing and transforming data with SQL queries.

**Database structure (Schema / structure design)**
- `Creating tables` using CREATE TABLE
- `Defining columns` and data types

**Data management (DML)**
- `INSERT` → adding data  
- `UPDATE` → modifying data  
- `DELETE` → removing data 

**Data transformation (querying logic)**
- `CASE WHEN` → converting raw values into categories
- `WHERE` → filtering specific data sets
- Operators like `=`, `>`, `BETWEEN`, `IN`, and `LIKE`

## 1. What are DDL and DML in SQL?

In SQL, commands are generally divided into Five main categories: **Data Definition Language (DDL)**, **Data Manipulation Language (DML)**, **Data Query Language (DQL)**, **Transaction Control Language (TCL)**, and Data Control Language (DCL)**.

Today, we cover the first two: **DDL** and **DML**

**DDL (Data Definition Language)**: It is used to define, shape  and manage the **structure** of a database. This includes creating, altering, and deleting schemas and tables.

**DML (Data Manipulation Language)**: It deals with the **data inside the database**. It is used to manage the data within the tables e.g. adding, updating, or removing records.


## 2. DDL (Data Definition Language): 
We create schema and tables structure here. 
Commands mostly used here include:

- **CREATE** : Used to build things inside an SQL database
To create a table, we we will need **column name, data type, constraints (rules like Not Null, unique)**
- **ALTER**: Used for changing or correcting the structure of a table. You can add or remove columns here from an already created table instead of deleting the whole table first to create a new updated one.    
- **DROP**: Used to delete the whole table or just one column 
- **TRUNCATE**: Used to removes all rows and data inside a table but retains the structure of the table.

Additional commands such as **Int, varchar, date, decimal** will also be used in defining the **column types**. 

-**_Varchar_**: used to refer to texts, strings characters columns e.g _`Grace Munyi`_. 
-**_Int_** : used to refer to integers, numbers e.g _`1,2, 34,65,100`_
-**_Decimal_** : Used to refer to values that are not in whole number format e.g currency _`3563.75`_, _`56926.77`_ etc
-**_Date_** : used to refer to calendar date columns e.g _`2026-04-12`_

### How I  created a Schema, Schema Path and Tables

###### 1) Creating a Schema 
-- Creating a schema if it doesn't exist

```sql
CREATE SCHEMA IF NOT EXISTS training;

```
###### 2) Set a path to the created schema above
-This is done instead of having to add the schema name in the table names that you will create. E.g. instead of creating students table called `training.students`,  your name will simply be `students`.

``` sql
set search_path = trainingdb;
```
###### 3) Create tables
-- Creating a table called students inside the Schema.

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    grade VARCHAR(10),
    enrollment_date DATE
);
```

###### 4) Alter a table
- We are adding a column into the students table created

```sql
ALTER TABLE students 
ADD COLUMN email VARCHAR(100);
```
###### 5) DROP Whole table or One Column
- To drop the whole students table created.

``` sql
DROP TABLE students;
```
-- To drop just one column in the students table created e.g   `enrollment_date` column

```sql
ALTER TABLE students
DROP COLUMN enrollment_date;
```
###### 6) RENAME a Column
-- If we want to rename one column e.g _email column_ added earlier to _student_email_

```sql
ALTER TABLE students
RENAME COLUMN email to student_email;
```

###### 7) TRUNCATE
-- If we wanted to clear the students table by deleting the data that was in it, we will use `Truncate`.
```sql
TRUNCATE TABLE students;
```
---

#### DML (Data Manipulation Language) 
Used to manage the data within the tables i.e. adding, updating, or removing records.

###### 1) INSERT data 
To insert data in the column names created

```sql
INSERT INTO students (name, age, grade)
VALUES ('Alice', 20, 'A', 'Alice@gmail.com');
```

###### 2) UPDATE data 
- To update a variable in the table e.g Change Alice's grade from an `A` to `B`.

```sql
UPDATE students
SET grade = 'B'
WHERE name = 'Alice';
```

###### 3) DELETE data 
To delete a student record from the table.
 
```sql
DELETE FROM students
WHERE name = 'Alice';
```

**Please remember**; When using `UPDATE` and `DELETE` always include the  `WHERE` command too to specify the specific column/s you want affected. Otherwise, without it, every row gets affected.

These commands helped me fully manage both the structure and the data in my database.

---
### 3. How filtering with WHERE works

The **WHERE clause** is used to filter records based on specific conditions. It allowed to retrieve only the data i needed.
Commands used together with **WHERE** include; `=`, `>`, `BETWEEN`, `IN`, `LIKE`)
- Here we use;
 
**SELECT * From Table name**
**WHERE  column name, filter condition**

Examples of operators:

###### 1) **= (equals)**

```sql
SELECT * FROM students
WHERE grade = 'A';
```

###### 2) **> (greater than)**

```sql
SELECT * FROM students
WHERE age > 18;
```

###### 3) **BETWEEN**

```sql
SELECT * FROM students
WHERE age BETWEEN 18 AND 22;
```

###### 4) **IN**

```sql
SELECT * FROM students
WHERE grade IN ('A', 'B');
```

###### 5) **LIKE** (pattern matching)

```sql
SELECT * FROM students
WHERE name LIKE 'A%';  -- names starting with A
```

`WHERE` clause is very important because it helps narrow down results efficiently.

---

### 4. How CASE WHEN helps in transforming data

The **CASE WHEN** statement allows us to create conditional logic inside SQL queries. It helps transform or categorize data thus making the data easier to understand and analyze.

`Example 1`:

```sql
SELECT name, marks, grade,
case
	WHEN marks >= 80 then 'Distinction'
	WHEN marks >= 60 then 'Merit'
	WHEN marks >= 40 then 'Pass'
	ELSE 'Fail'
End as Performance
from students;
```
In this example, students are grouped into categories based on their marks with a new column created called `Performance`.

`Example 2`:

```sql
SELECT name, age,
    CASE
        WHEN age < 18 THEN 'Minor'
        WHEN age BETWEEN 18 AND 25 THEN 'Young Adult'
        ELSE 'Adult'
    END AS age_group
FROM students;
```
In this example, students are grouped into categories based on their age with a new column created called `Age_group`. 



---

### 5. Reflection

• Every SQL statement must end with a **semicolon ( ; )**
• Text values must always be in **single quotes** - 'Nairobi' 
• Numbers do **NOT** need quotes - WHERE marks > 70 
• Always use **WHERE** with UPDATE and DELETE - without it, every row gets affected
• Dates are written as **'YYYY-MM-DD'** - e.g. '2024-03-15'
• BETWEEN is **inclusive** - BETWEEN 50 AND 80 includes 50 and 80 themselves 
• IN uses **brackets and commas** - IN ('Nairobi', 'Mombasa') 
• LIKE patterns - 'A%' starts with A, '%Studies%' contains Studies 
• CASE WHEN always ends with **END** - don't forget it! 
• Give your CASE WHEN result a name using **AS**

