-- Introduction
-- This SQL script sets up the initial database schema

-- Setup for mac
-- docker exec -it oracle19 sqlplus sys/Password123@localhost:1521/ORCLCDB as sysdba

-- Setup for windows
-- connect as sys as sysdba
-- password: Password123

-- Create a new user
create user C##admin_emp identified by admin123; -- Create user C##admin_emp with password admin123

-- Create table Students
create table students(
    roll number(6),
    name char(50),
    marks number(3)
);