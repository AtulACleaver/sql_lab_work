-- LAB 05 PL/SQL SOLUTIONS
-- Setting up environment
SET SERVEROUTPUT ON;

-- 0. Setup Sample Data (EMP and DEPT tables)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE emp CASCADE CONSTRAINTS';
    EXECUTE IMMEDIATE 'DROP TABLE dept CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

CREATE TABLE dept (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    job VARCHAR2(9),
    mgr NUMBER(4),
    hiredate DATE,
    sal NUMBER(7,2),
    comm NUMBER(7,2),
    deptno NUMBER(2) REFERENCES dept(deptno)
);

INSERT INTO dept VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO dept VALUES (20, 'RESEARCH', 'DALLAS');
INSERT INTO dept VALUES (30, 'SALES', 'CHICAGO');
INSERT INTO dept VALUES (40, 'OPERATIONS', 'BOSTON');

INSERT INTO emp VALUES (7369, 'SMITH', 'CLERK', 7902, TO_DATE('17-DEC-1980', 'DD-MON-YYYY'), 800, NULL, 20);
INSERT INTO emp VALUES (7499, 'ALLEN', 'SALESMAN', 7698, TO_DATE('20-FEB-1981', 'DD-MON-YYYY'), 1600, 300, 30);
INSERT INTO emp VALUES (7521, 'WARD', 'SALESMAN', 7698, TO_DATE('22-FEB-1981', 'DD-MON-YYYY'), 1250, 500, 30);
INSERT INTO emp VALUES (7566, 'JONES', 'MANAGER', 7839, TO_DATE('02-APR-1981', 'DD-MON-YYYY'), 2975, NULL, 20);
INSERT INTO emp VALUES (7654, 'MARTIN', 'SALESMAN', 7698, TO_DATE('28-SEP-1981', 'DD-MON-YYYY'), 1250, 1400, 30);
INSERT INTO emp VALUES (7698, 'BLAKE', 'MANAGER', 7839, TO_DATE('01-MAY-1981', 'DD-MON-YYYY'), 2850, NULL, 30);
INSERT INTO emp VALUES (7782, 'CLARK', 'MANAGER', 7839, TO_DATE('09-JUN-1981', 'DD-MON-YYYY'), 2450, NULL, 10);
INSERT INTO emp VALUES (7788, 'SCOTT', 'ANALYST', 7566, TO_DATE('09-DEC-1982', 'DD-MON-YYYY'), 3000, NULL, 20);
INSERT INTO emp VALUES (7839, 'KING', 'PRESIDENT', NULL, TO_DATE('17-NOV-1981', 'DD-MON-YYYY'), 5000, NULL, 10);
INSERT INTO emp VALUES (7844, 'TURNER', 'SALESMAN', 7698, TO_DATE('08-SEP-1981', 'DD-MON-YYYY'), 1500, 0, 30);
INSERT INTO emp VALUES (7876, 'ADAMS', 'CLERK', 7788, TO_DATE('12-JAN-1983', 'DD-MON-YYYY'), 1100, NULL, 20);
INSERT INTO emp VALUES (7900, 'JAMES', 'CLERK', 7698, TO_DATE('03-DEC-1981', 'DD-MON-YYYY'), 950, NULL, 30);
INSERT INTO emp VALUES (7902, 'FORD', 'ANALYST', 7566, TO_DATE('03-DEC-1981', 'DD-MON-YYYY'), 3000, NULL, 20);
INSERT INTO emp VALUES (7934, 'MILLER', 'CLERK', 7782, TO_DATE('23-JAN-1982', 'DD-MON-YYYY'), 1300, NULL, 10);

COMMIT;

-- 1. Display the names, jobs and bonus for all employees assuming all managers get a
-- bonus of Rs. 500, clerks get Rs.200 and all others except the president Rs.350. the
-- president gets 20 percent of his salary as bonus.
PROMPT Question 1;
BEGIN
    FOR r IN (SELECT ename, job, sal FROM emp) LOOP
        DECLARE
            bonus NUMBER;
        BEGIN
            IF r.job = 'MANAGER' THEN bonus := 500;
            ELSIF r.job = 'CLERK' THEN bonus := 200;
            ELSIF r.job = 'PRESIDENT' THEN bonus := 0.20 * r.sal;
            ELSE bonus := 350;
            END IF;
            DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Job: ' || r.job || ', Bonus: ' || bonus);
        END;
    END LOOP;
END;
/

-- 2. Display the names of all employees and their bonus. Assume each employee gets
-- a bonus of 20 percent of his salary subject to the maximum of Rs. 200.
PROMPT Question 2;
BEGIN
    FOR r IN (SELECT ename, sal FROM emp) LOOP
        DECLARE
            bonus NUMBER;
        BEGIN
            bonus := 0.20 * r.sal;
            IF bonus > 200 THEN bonus := 200; END IF;
            DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Bonus: ' || bonus);
        END;
    END LOOP;
END;
/

-- 3. Display the employee details in the following manner. „Miller joined on the
-- twenty-third of January of the year eighty second‟
PROMPT Question 3;
BEGIN
    FOR r IN (SELECT ename, hiredate FROM emp WHERE ename = 'MILLER') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ' joined on the ' || TO_CHAR(r.hiredate, 'fmDdspth "of" Month "of the year" Year'));
    END LOOP;
END;
/

-- 4. Display the name of all employees, and „Greater‟ or „smaller‟ depending on
-- where the salary of the employees is greater than or less than 1500.
PROMPT Question 4;
BEGIN
    FOR r IN (SELECT ename, sal FROM emp) LOOP
        IF r.sal > 1500 THEN
            DBMS_OUTPUT.PUT_LINE(r.ename || ': Greater');
        ELSE
            DBMS_OUTPUT.PUT_LINE(r.ename || ': Smaller');
        END IF;
    END LOOP;
END;
/

-- 5. Display the DA of all employees and calculation is in the following manner
-- If salary >=5000 then DA is 75% of Salary
-- If salary >=3000 and salary<5000 then DA is 60% of Salary Else DA
-- is 50% of Salary.
PROMPT Question 5;
BEGIN
    FOR r IN (SELECT ename, sal FROM emp) LOOP
        DECLARE
            da NUMBER;
        BEGIN
            IF r.sal >= 5000 THEN da := 0.75 * r.sal;
            ELSIF r.sal >= 3000 THEN da := 0.60 * r.sal;
            ELSE da := 0.50 * r.sal;
            END IF;
            DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', DA: ' || da);
        END;
    END LOOP;
END;
/

-- 6. Display the names, job and hire date of employees with there hire dates in desc
-- order inside each department.
PROMPT Question 6;
BEGIN
    FOR r IN (SELECT ename, job, hiredate, deptno FROM emp ORDER BY deptno, hiredate DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('Dept: ' || r.deptno || ', Name: ' || r.ename || ', Job: ' || r.job || ', HireDate: ' || r.hiredate);
    END LOOP;
END;
/

-- 7. What would be the date after two months?
PROMPT Question 7;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Date after two months: ' || ADD_MONTHS(SYSDATE, 2));
END;
/

-- 8. List the employee number, name of all employees Employee names should have
-- only the first letter in upper case and department no in descending order.
PROMPT Question 8;
BEGIN
    FOR r IN (SELECT empno, INITCAP(ename) as name, deptno FROM emp ORDER BY deptno DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('EmpNo: ' || r.empno || ', Name: ' || r.name || ', Dept: ' || r.deptno);
    END LOOP;
END;
/

-- 9. Concatenate the name of the person with his job separated by three spaces
-- (CONCAT).
PROMPT Question 9;
BEGIN
    FOR r IN (SELECT CONCAT(ename, CONCAT('   ', job)) as name_job FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.name_job);
    END LOOP;
END;
/

-- 10. Display the names of all employees, padding them to the right up to 16 characters
-- with.
PROMPT Question 10;
BEGIN
    FOR r IN (SELECT RPAD(ename, 16, '.') as padded_name FROM emp) LOOP
            DBMS_OUTPUT.PUT_LINE(r.padded_name);
        END;
    END LOOP;
END;
/

-- 11. Show the first three characters of names of all employees.
PROMPT Question 11;
BEGIN
    FOR r IN (SELECT SUBSTR(ename, 1, 3) as short_name FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.short_name);
    END LOOP;
END;
/

-- 12. Find the salary of all employees rounding it to the nearest Rs.1000.
PROMPT Question 12;
BEGIN
    FOR r IN (SELECT ename, ROUND(sal, -3) as rounded_sal FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || r.rounded_sal);
    END LOOP;
END;
/

-- 13. Find employees name and job whose employees names last character is equal to
-- jobs last character.
PROMPT Question 13;
BEGIN
    FOR r IN (SELECT ename, job FROM emp WHERE SUBSTR(ename, -1) = SUBSTR(job, -1)) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Job: ' || r.job);
    END LOOP;
END;
/

-- 14. Display the names and salary of the employees in the descending order of their
-- income.
PROMPT Question 14;
BEGIN
    FOR r IN (SELECT ename, sal, NVL(comm, 0) as comm FROM emp ORDER BY (sal + NVL(comm, 0)) DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Income: ' || (r.sal + r.comm));
    END LOOP;
END;
/

-- 15. Display the names of all employees with any „A‟ at any place of the name.
PROMPT Question 15;
BEGIN
    FOR r IN (SELECT ename FROM emp WHERE ename LIKE '%A%') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

-- 16. Show all employees who were hired in the first half of the month (Before the 16th
-- of the month).
PROMPT Question 16;
BEGIN
    FOR r IN (SELECT ename, hiredate FROM emp WHERE TO_CHAR(hiredate, 'DD') < 16) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || r.hiredate);
    END LOOP;
END;
/

-- 17. Show all employees, and indicate with “YES” or “NO” whether they receive a
-- commission.
PROMPT Question 17;
BEGIN
    FOR r IN (SELECT ename, comm FROM emp) LOOP
        IF r.comm IS NOT NULL AND r.comm > 0 THEN
            DBMS_OUTPUT.PUT_LINE(r.ename || ': YES');
        ELSE
            DBMS_OUTPUT.PUT_LINE(r.ename || ': NO');
        END IF;
    END LOOP;
END;
/

-- 18. Show those employees that have a name starting with J, K, L, or M.
PROMPT Question 18;
BEGIN
    FOR r IN (SELECT ename FROM emp WHERE REGEXP_LIKE(ename, '^[JKLM]')) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

-- 19. Display the length of all employees.
-- PROMPT Question 19;
BEGIN
    FOR r IN (SELECT ename, LENGTH(ename) as len FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || r.len);
    END LOOP;
END;
/

-- 20. Display the name and job of all employees who do not have a manager.
-- PROMPT Question 20;
BEGIN
    FOR r IN (SELECT ename, job FROM emp WHERE mgr IS NULL) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Job: ' || r.job);
    END LOOP;
END;
/

-- 21. Find all employees whose name are 5 characters long and end with „N‟.
-- PROMPT Question 21;
BEGIN
    FOR r IN (SELECT ename FROM emp WHERE LENGTH(ename) = 5 AND ename LIKE '%N') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

-- 22. Display the employee name and department no of all employees in department
-- 10,30 in alphabetical order by name.
PROMPT Question 22;
BEGIN
    FOR r IN (SELECT ename, deptno FROM emp WHERE deptno IN (10, 30) ORDER BY ename) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Dept: ' || r.deptno);
    END LOOP;
END;
/

-- 23. Find employees who do not receive a commission or whose commission is less
-- than Rs.100. (comm. Is null or comm. < 100)
PROMPT Question 23;
BEGIN
    FOR r IN (SELECT ename, comm FROM emp WHERE comm IS NULL OR comm < 100) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Comm: ' || NVL(TO_CHAR(r.comm), 'NULL'));
    END LOOP;
END;
/

-- 24. Find the employees whose commission is Rs.0.
PROMPT Question 24;
BEGIN
    FOR r IN (SELECT ename, comm FROM emp WHERE comm = 0) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ' has 0 commission');
    END LOOP;
END;
/
