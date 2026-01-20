<!-- This is going to lab notes for all the SQL lab work -->

# SQL Lab Notes

## Introduction
This repository contains notes and exercises related to SQL (Structured Query Language) labs. The purpose of these notes is to help reinforce concepts learned during SQL lab sessions and provide a reference for future use.

## Table of Contents
1. [Introduction to SQL](#introduction-to-sql)
2. [Database Setup](#database-setup)
3. [User Management](#user-management)
4. [DDL Commands (Data Definition Language)](#ddl-commands-data-definition-language)
5. [DML Commands (Data Manipulation Language)](#dml-commands-data-manipulation-language)
6. [Constraints in SQL](#constraints-in-sql)
7. [SQL Queries - Basic to Advanced](#sql-queries---basic-to-advanced)
8. [Common SQL Patterns](#common-sql-patterns)

---

## Introduction to SQL
SQL is a standard language for managing and manipulating relational databases. It allows users to create, read, update, and delete data stored in database tables.

**Key Features:**
- **DDL (Data Definition Language)**: CREATE, ALTER, DROP, TRUNCATE
- **DML (Data Manipulation Language)**: INSERT, UPDATE, DELETE, SELECT
- **DCL (Data Control Language)**: GRANT, REVOKE
- **TCL (Transaction Control Language)**: COMMIT, ROLLBACK, SAVEPOINT

---

## Database Setup

### How to start Oracle Database

**For Mac:**
```bash
docker exec -it oracle19 sqlplus sys/Password123@localhost:1521/ORCLCDB as sysdba
```

**For Windows:**
1. Open Command Prompt (cmd)
2. Connect as sys as sysdba
3. Password: `Password123`

---

## User Management

### Creating a User
In Oracle, users with the prefix `C##` are created for container databases (CDB).

```sql
-- Basic user creation
CREATE USER C##admin_emp IDENTIFIED BY admin123;

-- More examples
CREATE USER C##lab_user IDENTIFIED BY password123;
CREATE USER C##employee_admin IDENTIFIED BY empadmin123;
CREATE USER C##dml_user IDENTIFIED BY dmlpass123;
```

**Syntax:**
```sql
CREATE USER username IDENTIFIED BY password;
```

---

## DDL Commands (Data Definition Language)

DDL commands are used to define and modify database structure.

### 1. CREATE TABLE

Creates a new table in the database.

```sql
-- Basic table creation
CREATE TABLE students (
    roll NUMBER(6),
    name CHAR(50),
    marks NUMBER(3)
);

-- Table with more columns
CREATE TABLE student (
    roll NUMBER(6),
    name CHAR(50),
    branch CHAR(20),
    marks NUMBER(3)
);
```

**Common Data Types:**
- `NUMBER(precision, scale)`: Numeric data
- `CHAR(size)`: Fixed-length character data
- `VARCHAR2(size)`: Variable-length character data
- `DATE`: Date and time data

### 2. ALTER TABLE

Modifies an existing table structure.

```sql
-- Add a new column
ALTER TABLE employee ADD emp_email CHAR(100);

-- Modify an existing column
ALTER TABLE employee MODIFY emp_email CHAR(100) NOT NULL;

-- Add constraints
ALTER TABLE employee ADD CONSTRAINT pk_emp_id PRIMARY KEY (emp_id);
ALTER TABLE employee ADD CONSTRAINT uq_emp_email UNIQUE (emp_email);
```

**Common ALTER Operations:**
- `ADD`: Add new columns or constraints
- `MODIFY`: Change column definitions
- `DROP`: Remove columns or constraints

---

## DML Commands (Data Manipulation Language)

DML commands are used to manipulate data within tables.

### 1. INSERT

Adds new records to a table.

```sql
-- Insert with all columns specified
INSERT INTO student(roll, name, branch, marks) VALUES(1, 'Alice', 'CSE', 85);
INSERT INTO student(roll, name, branch, marks) VALUES(2, 'Bob', 'ECE', 90);
INSERT INTO student(roll, name, branch, marks) VALUES(3, 'Charlie', 'ME', 78);

-- Insert using TO_DATE function
INSERT INTO constraint_employees VALUES(
    201, 
    'Michael Brown', 
    TO_DATE('2018-05-10', 'YYYY-MM-DD'), 
    'M', 
    14000.00, 
    'manager'
);
```

### 2. SELECT

Retrieves data from one or more tables.

```sql
-- Select all columns
SELECT * FROM student;

-- Select specific columns
SELECT emp_no, emp_name FROM employees_assign;

-- Select with column aliases
SELECT emp_no AS "NUMBER", emp_name AS "NAME" FROM employees_assign;

-- Select specific values only
SELECT salary FROM employees_assign;
```

### 3. UPDATE

Modifies existing records in a table.

```sql
-- Update with WHERE clause
UPDATE student SET marks = 88 WHERE roll = 1;

-- Update multiple records
UPDATE employee SET emp_email = 'john.doe@example.com' WHERE emp_id = 101;
UPDATE employee SET emp_email = 'jane.smith@example.com' WHERE emp_id = 102;
```

**Important:** Always use WHERE clause to avoid updating all records!

### 4. DELETE

Removes records from a table.

```sql
-- Delete specific record
DELETE FROM student WHERE roll = 3;
```

**Important:** Always use WHERE clause to avoid deleting all records!

---

## Constraints in SQL

Constraints enforce rules at the table level to maintain data integrity.

### Types of Constraints

#### 1. PRIMARY KEY
Uniquely identifies each record in a table.

```sql
CREATE TABLE constraint_employees (
    employee_id NUMBER(6) PRIMARY KEY,
    -- other columns
);

-- Or add later
ALTER TABLE employee ADD CONSTRAINT pk_emp_id PRIMARY KEY (emp_id);
```

#### 2. NOT NULL
Ensures a column cannot have NULL values.

```sql
CREATE TABLE constraint_employees (
    name CHAR(50) NOT NULL,
    -- other columns
);
```

#### 3. CHECK
Ensures values in a column meet a specific condition.

```sql
CREATE TABLE constraint_employees (
    sex CHAR(1) CHECK(sex IN ('M','F')),
    employee_department VARCHAR2(30) CHECK(employee_department IN ('executive', 'accountant', 'manager'))
);
```

#### 4. DEFAULT
Sets a default value for a column when no value is specified.

```sql
CREATE TABLE constraint_employees (
    salary NUMBER(8, 2) DEFAULT 10000.00
);
```

#### 5. UNIQUE
Ensures all values in a column are different.

```sql
ALTER TABLE employee ADD CONSTRAINT uq_emp_email UNIQUE (emp_email);
```

### Complete Example with Multiple Constraints

```sql
CREATE TABLE constraint_employees (
    employee_id NUMBER(6) PRIMARY KEY,
    name CHAR(50) NOT NULL,
    dateofjoining DATE,
    sex CHAR(1) CHECK(sex IN ('M','F')),
    salary NUMBER(8, 2) DEFAULT 10000.00,
    employee_department VARCHAR2(30) CHECK(employee_department IN ('executive', 'accountant', 'manager'))
);
```

---

## SQL Queries - Basic to Advanced

### 1. Basic SELECT Queries

```sql
-- Select all data
SELECT * FROM employees_assign;

-- Select specific columns
SELECT emp_no, emp_name FROM employees_assign;

-- Select with aliases
SELECT emp_no AS "NUMBER", emp_name AS "NAME" FROM employees_assign;
```

### 2. WHERE Clause - Filtering Data

#### Simple Conditions

```sql
-- Single condition
SELECT * FROM employees_assign WHERE dept_no = 20;

-- Comparison operators
SELECT * FROM employees_assign WHERE salary > 2000;
```

#### Multiple Conditions

```sql
-- AND operator
SELECT * FROM employees_assign WHERE dept_no = 10 AND hire_date > TO_DATE('1982-01-01', 'YYYY-MM-DD');

-- OR operator
SELECT * FROM employees_assign WHERE dept_no = 10 OR dept_no = 20;

-- IN operator (cleaner than multiple ORs)
SELECT * FROM employees_assign WHERE dept_no IN (10, 20);
SELECT * FROM employees_assign WHERE job IN ('manager', 'president');
```

#### Complex Conditions

```sql
-- Multiple AND/OR combinations
SELECT * FROM employees_assign 
WHERE job = 'manager' OR (dept_no = 10 AND job = 'clerk');

-- Combining different conditions
SELECT * FROM employees_assign 
WHERE (dept_no = 10 AND job = 'manager') 
   OR (dept_no = 20 AND job = 'clerk');
```

### 3. NULL Value Handling

```sql
-- Check for NULL values
SELECT * FROM employees_assign WHERE commission IS NULL;

-- Check for specific value (including 0)
SELECT * FROM employees_assign WHERE commission = 0;
```

**Note:** Use `IS NULL` or `IS NOT NULL` for NULL comparisons, not `= NULL`.

### 4. Date Operations

```sql
-- Filter by date
SELECT * FROM employees_assign WHERE hire_date > TO_DATE('1982-01-01', 'YYYY-MM-DD');

-- Insert dates
INSERT INTO employees_assign VALUES(
    101, 
    'Atul Anand', 
    10, 
    'manager', 
    TO_DATE('1980-06-15', 'YYYY-MM-DD'), 
    3000.00, 
    NULL
);
```

### 5. Arithmetic Operations in Queries

```sql
-- Compare column with calculation
SELECT * FROM employees_assign WHERE commission > 0.6 * salary;

-- Calculate percentage
SELECT emp_name, salary, commission, (commission/salary)*100 AS commission_percent 
FROM employees_assign;
```

### 6. Comparison Operators

- `=` : Equal to
- `>` : Greater than
- `<` : Less than
- `>=` : Greater than or equal to
- `<=` : Less than or equal to
- `<>` or `!=` : Not equal to

```sql
-- Greater than or equal
SELECT * FROM employees_assign WHERE dept_no >= 20;

-- Not equal (two methods)
SELECT * FROM employees_assign WHERE job != 'manager';
SELECT * FROM employees_assign WHERE job <> 'manager';
```

### 7. NOT Operator

```sql
-- NOT IN
SELECT * FROM employees_assign WHERE job NOT IN ('manager', 'clerk');

-- Complex NOT conditions
SELECT * FROM employees_assign 
WHERE job NOT IN ('manager', 'clerk') AND salary >= 2000;
```

### 8. ORDER BY Clause

Sorts result set in ascending or descending order.

```sql
-- Ascending order (default)
SELECT salary FROM employees_assign ORDER BY salary;

-- Descending order
SELECT salary FROM employees_assign ORDER BY salary DESC;

-- Multiple columns
SELECT * FROM employees_assign ORDER BY dept_no, salary DESC;
```

---

## Common SQL Patterns

### Pattern 1: Filtering by Multiple Departments

```sql
-- Employees in dept 10 or 20
SELECT * FROM employees_assign WHERE dept_no IN (10, 20);
```

### Pattern 2: Filtering by Job Role

```sql
-- Specific roles in specific department
SELECT * FROM employees_assign WHERE dept_no = 10 AND job IN ('manager', 'clerk');
```

### Pattern 3: Complex Filtering with Multiple Conditions

```sql
-- Managers in dept 10, clerks in dept 20, or others with high salary
SELECT * FROM employees_assign 
WHERE (dept_no = 10 AND job = 'manager') 
   OR (dept_no = 20 AND job = 'clerk') 
   OR (job NOT IN ('manager', 'clerk') AND salary >= 2000);
```

### Pattern 4: Date-Based Filtering

```sql
-- Employees hired after a specific date
SELECT * FROM employees_assign WHERE hire_date > TO_DATE('1982-01-01', 'YYYY-MM-DD');

-- Department-specific date filtering
SELECT * FROM employees_assign 
WHERE dept_no = 10 AND hire_date > TO_DATE('1982-01-01', 'YYYY-MM-DD');
```

### Pattern 5: Commission-Based Queries

```sql
-- Employees with no commission
SELECT * FROM employees_assign WHERE commission IS NULL;

-- Employees with zero commission
SELECT * FROM employees_assign WHERE commission = 0;

-- High commission earners
SELECT * FROM employees_assign WHERE commission > 0.6 * salary;
```

---

## Key Takeaways

1. **Always use WHERE clause** when updating or deleting to avoid affecting all records
2. **Use constraints** to maintain data integrity
3. **Use IN operator** instead of multiple OR conditions for cleaner code
4. **Use IS NULL** for NULL comparisons, not `= NULL`
5. **Use TO_DATE()** function for date operations in Oracle
6. **Use column aliases** (AS keyword) for better readability in SELECT statements
7. **ORDER BY** defaults to ascending; use DESC for descending order
8. **Use parentheses** to make complex WHERE conditions clear and unambiguous

---

## Practice Resources

- [lab01/01_intro.sql](lab01/01_intro.sql) - Introduction and basic table creation
- [lab02/02_ddl_commands.sql](lab02/02_ddl_commands.sql) - DDL commands and basic DML
- [lab03/01_employees.sql](lab03/01_employees.sql) - Constraints implementation
- [lab03/03_dml_commands.sql](lab03/03_dml_commands.sql) - Advanced DML and ALTER commands
- [lab04/01_assign.sql](lab04/01_assign.sql) - Complex query examples and patterns