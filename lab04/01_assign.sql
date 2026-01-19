-- SOL ASSIGNMENT-1
-- 1. Query the employee table.
-- 2. List employee number and the name of the employee.
-- 3. List employee number and name of employee with the headings as NUMBER and NAME. 4. List the employees working in department 20.
-- 5. List the employees of department 10 and 20.
-- 6. List the employees who joined after 01/01/82.
-- 7. List the employees of dept 10 who joined after 01/01/82.
-- 8. List the salary of all the employees.
-- 9. List the employees who do not receive commission.
-- 10. List the employees who receive 0 commission.
-- 11. Select the employees in department 30.
-- 12. List the names, numbers and the names of employees of all departments with department number greater than or equal to 20.
-- 13. Find the employees whose commission is greater than 60 percent of their salary.
-- 14. List the name, job and salary of all employees in department 20 who earn more than Rs. 2000. 15. Find all salesmen in department 30 whose salary is greater than or equal to Rs. 1500.
-- 16. Find all employees whose job is either manager or president.
-- 17. Find the details of managers and clerks in department 10.
-- 18. Find details of all managers in any department and all clerks in department 10.
-- 19. Find details of all managers in department 10 and all clerks in department 20.
-- 20. Find the details of all the managers in department 10 all clerks in department 20 and all employees who are neither managers nor clerk and whose salary is greater than or equal to Rs. 2000.
-- 21. List salaries of all employees in descending order.

-- 0. Crete employee table and insert sample data
create table employees_assign (
    emp_no number primary key,
    emp_name varchar2(50),
    dept_no number,
    job varchar2(50),
    hire_date date,
    salary number(10, 2),
    commission number(10, 2)
);

insert into employees_assign values(101, 'Atul Anand', 10, 'manager', to_date('1980-06-15', 'YYYY-MM-DD'), 3000.00, null);
insert into employees_assign values(102, 'Ravi Kumar', 20, 'clerk', to_date('1985-09-23', 'YYYY-MM-DD'), 1500.00, 200.00);
insert into employees_assign values(103, 'Sunita Sharma', 30, 'salesman', to_date('1990-12-01', 'YYYY-MM-DD'), 1800.00, 300.00);

-- 1. Query the employee table.
select * from employees_assign;

-- 2. List employee number and the name of the employee.
select emp_no, emp_name from employees_assign;

-- 3. List employee number and name of employee with the headings as NUMBER and NAME.
select emp_no as "NUMBER", emp_name as "NAME" from employees_assign;

-- 4. List the employees working in department 20.
select * from employees_assign where dept_no = 20;

-- 5. List the employees of department 10 and 20.
select * from employees_assign where dept_no in (10, 20);

-- 6. List the employees who joined after 01/01/82.
select * from employees_assign where hire_date > to_date('1982-01-01', 'YYYY-MM-DD');

-- 7. List the employees of dept 10 who joined after 01/01/82.
select * from employees_assign where dept_no = 10 and hire_date > to_date('1982-01-01', 'YYYY-MM-DD');

-- 8. List the salary of all the employees.
select salary from employees_assign;

-- 9. List the employees who do not receive commission.
select * from employees_assign where commission is null;

-- 10. List the employees who receive 0 commission.
select * from employees_assign where commission = 0;

-- 11. Select the employees in department 30.
select * from employees_assign where dept_no = 30;

-- 12. List the names, numbers and the names of employees of all departments with department number greater than or equal to 20.
select emp_name, emp_no from employees_assign where dept_no >= 20;

-- 13. Find the employees whose commission is greater than 60 percent of their salary.
select * from employees_assign where commission > 0.6 * salary;

-- 14. List the name, job and salary of all employees in department 20 who earn more than Rs. 2000.
select emp_name, job, salary from employees_assign where dept_no = 20 and salary > 2000;

-- 15. Find all salesmen in department 30 whose salary is greater than or equal to Rs. 1500.
select * from employees_assign where job = 'salesman' and dept_no = 30 and salary >= 1500;

-- 16. Find all employees whose job is either manager or president.
select * from employees_assign where job in ('manager', 'president');

-- 17. Find the details of managers and clerks in department 10.
select * from employees_assign where dept_no = 10 and job in ('manager', 'clerk');

-- 18. Find details of all managers in any department and all clerks in department 10.
select * from employees_assign where job = 'manager' or (dept_no = 10 and job = 'clerk');

-- 19. Find details of all managers in department 10 and all clerks in department 20.
select * from employees_assign where (dept_no = 10 and job = 'manager') or (dept_no = 20 and job = 'clerk');

-- 20. Find the details of all the managers in department 10 all clerks in department 20 and all employees who are neither managers nor clerk and whose salary is greater than or equal to Rs. 2000.
select * from employees_assign where (dept_no = 10 and job = 'manager') or (dept_no = 20 and job = 'clerk') or (job not in ('manager', 'clerk') and salary >= 2000);

-- 21. List salaries of all employees in descending order.
select salary from employees_assign order by salary desc; 