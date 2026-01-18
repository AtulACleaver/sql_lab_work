-- 03 DML Commands (Data Manipulation Language) Commands

-- 00: Boilerplate: Creating a user and table & inserting initial data
create user C##dml_user identified by dmlpass123;
create table employee(
    emp_id number(6),
    emp_name char(50),
    emp_salary number(10,2)
);
insert into employee(emp_id, emp_name, emp_salary) values(101, 'John Doe', 55000.00);
insert into employee(emp_id, emp_name, emp_salary) values(102, 'Jane Smith', 62000.00);
insert into employee(emp_id, emp_name, emp_salary) values(103, 'Mike Johnson', 58000.00);

-- 01: Current data in the employee table
select * from employee;

-- 02: Adding a column to the employee table
alter table employee add emp_email char(100);

-- 03: Updating data in the employee table to include email addresses
update employee set emp_email = 'john.doe@example.com' where emp_id = 101;
update employee set emp_email = 'jane.smith@example.com' where emp_id = 102;
update employee set emp_email = 'mike.johnson@example.com' where emp_id = 103;
select * from employee;

-- 04: Altering constraints - Making emp_email NOT NULL
alter table employee modify emp_email char(100) not null; -- This will fail if there are NULL values in emp_email
-- Primary key
alter table employee add constraint pk_emp_id primary key (emp_id);
-- Unique constraint
alter table employee add constraint uq_emp_email unique (emp_email);
