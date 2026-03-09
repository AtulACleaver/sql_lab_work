-- DDL( Data Definition Language ) Commands

-- 00: Creating a user
create user C##lab_user identified by password123;

-- 01: Creating a table
create table student(
    roll number(6),
    name char(50),
    branch char(20),
    marks number(3),
    dateOfBirth date
);

-- 01: Inserting data into a table
insert into student(roll, name, branch, marks, dateOfBirth) values(1, 'Alice', 'CSE', 85, to_date('2002-05-15', 'YYYY-MM-DD'));
insert into student(roll, name, branch, marks, dateOfBirth) values(2, 'Bob', 'ECE', 90, to_date('2001-08-22', 'YYYY-MM-DD'));
insert into student(roll, name, branch, marks, dateOfBirth) values(3, 'Charlie', 'ME', 78, to_date('2003-11-30', 'YYYY-MM-DD'));

-- 02: View data from a table
select * from student;

-- 03: Updating data in a table
update student set marks = 88 where roll = 1;
select * from student;

-- 04: Deleting data from a table
delete from student where roll = 3;
select * from student;