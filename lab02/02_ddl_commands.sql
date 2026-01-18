-- DDL( Data Definition Language ) Commands

-- 00: Creating a user
create user C##lab_user identified by password123;

-- 01: Creating a table
create table student(
    roll number(6),
    name char(50),
    branch char(20),
    marks number(3)
);

-- 01: Inserting data into a table
insert into student(roll, name, branch, marks) values(1, 'Alice', 'CSE', 85);
insert into student(roll, name, branch, marks) values(2, 'Bob', 'ECE', 90);
insert into student(roll, name, branch, marks) values(3, 'Charlie', 'ME', 78);

-- 02: View data from a table
select * from student;

-- 03: Updating data in a table
update student set marks = 88 where roll = 1;
select * from student;

-- 04: Deleting data from a table
delete from student where roll = 3;
select * from student;