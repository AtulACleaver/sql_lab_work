-- Create SQL of Employees with following columns:
-- employee_id - primary key
-- name not null
-- dateofjoining date
-- sex check constraint to accept only 'M' or 'F'
-- salary with default value 10000.00
-- employee_department check constraint to accept only 'executive', 'accountant' & 'manager

create user C##employee_admin identified by empadmin123;

-- create employees table
create table constraint_employees(
    employee_id number (6) primary key,
    name char (50) not null,
    dateofjoining date,
    sex char(1) check(sex in ('M','F')),
    salary number(8, 2) default 10000.00,
    employee_department varchar2(30) check(employee_department in ('executive', 'accountant', 'manager'))
);

-- insert data into employees table
insert into constraint_employees values(201, 'Michael Brown', to_date('2018-05-10', 'YYYY-MM-DD'), 'M', 14000.00, 'manager');
insert into constraint_employees values(202, 'Emily Davis', to_date('2020-11-25', 'YYYY-MM-DD'), 'F', 12500.00, 'accountant');

select * from constraint_employees;