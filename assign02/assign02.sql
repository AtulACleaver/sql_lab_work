-- ============================================================
-- SQL ASSIGNMENT 2 - PL/SQL Solutions
-- Table used: EMP (standard Oracle EMP table)
-- ============================================================
-- EMP table columns:
--   empno, ename, job, mgr, hiredate, sal, comm, deptno
-- Standard EMP data used throughout
-- ============================================================

SET SERVEROUTPUT ON;

-- ============================================================
-- Q1. Display names, jobs and bonus:
--     MANAGER -> Rs.500, CLERK -> Rs.200,
--     PRESIDENT -> 20% of salary, others -> Rs.350
-- ============================================================
-- Expected Output:
-- Name: SMITH,  Job: CLERK,     Bonus: 200
-- Name: ALLEN,  Job: SALESMAN,  Bonus: 350
-- Name: WARD,   Job: SALESMAN,  Bonus: 350
-- Name: JONES,  Job: MANAGER,   Bonus: 500
-- Name: MARTIN, Job: SALESMAN,  Bonus: 350
-- Name: BLAKE,  Job: MANAGER,   Bonus: 500
-- Name: CLARK,  Job: MANAGER,   Bonus: 500
-- Name: SCOTT,  Job: ANALYST,   Bonus: 350
-- Name: KING,   Job: PRESIDENT, Bonus: 1000
-- Name: TURNER, Job: SALESMAN,  Bonus: 350
-- Name: ADAMS,  Job: CLERK,     Bonus: 200
-- Name: JAMES,  Job: CLERK,     Bonus: 200
-- Name: FORD,   Job: ANALYST,   Bonus: 350
-- Name: MILLER, Job: CLERK,     Bonus: 200
BEGIN
    FOR r IN (SELECT ename, job, sal FROM emp) LOOP
        DECLARE
            bonus NUMBER;
        BEGIN
            IF r.job = 'MANAGER' THEN
                bonus := 500;
            ELSIF r.job = 'CLERK' THEN
                bonus := 200;
            ELSIF r.job = 'PRESIDENT' THEN
                bonus := 0.20 * r.sal;
            ELSE
                bonus := 350;
            END IF;
            DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Job: ' || r.job || ', Bonus: ' || bonus);
        END;
    END LOOP;
END;
/

-- ============================================================
-- Q2. Display names and bonus (20% of salary, max Rs.200)
-- ============================================================
-- Expected Output:
-- Name: SMITH,  Bonus: 160
-- Name: ALLEN,  Bonus: 200
-- Name: WARD,   Bonus: 200
-- Name: JONES,  Bonus: 200
-- Name: MARTIN, Bonus: 200
-- Name: BLAKE,  Bonus: 200
-- Name: CLARK,  Bonus: 200
-- Name: SCOTT,  Bonus: 200
-- Name: KING,   Bonus: 200
-- Name: TURNER, Bonus: 200
-- Name: ADAMS,  Bonus: 200
-- Name: JAMES,  Bonus: 190
-- Name: FORD,   Bonus: 200
-- Name: MILLER, Bonus: 200
BEGIN
    FOR r IN (SELECT ename, sal FROM emp) LOOP
        DECLARE
            bonus NUMBER;
        BEGIN
            bonus := 0.20 * r.sal;
            IF bonus > 200 THEN
                bonus := 200;
            END IF;
            DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Bonus: ' || bonus);
        END;
    END LOOP;
END;
/

-- ============================================================
-- Q3. Display employee details in a sentence form
--     e.g. "MILLER joined on the twenty-third of January of the year eighty second"
-- ============================================================
-- Expected Output:
-- MILLER joined on the twenty-third of January of the year Nineteen Eighty-Two
-- (Note: TO_CHAR spell-out format varies by Oracle version/NLS settings)
BEGIN
    FOR r IN (SELECT ename, hiredate FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(
            r.ename || ' joined on the ' ||
            TO_CHAR(r.hiredate, 'fmDdspth "of" Month "of the year" Year')
        );
    END LOOP;
END;
/

-- ============================================================
-- Q4. Display name and "Greater" or "Smaller" based on salary vs 1500
-- ============================================================
-- Expected Output:
-- SMITH:  Smaller
-- ALLEN:  Greater
-- WARD:   Smaller
-- JONES:  Greater
-- MARTIN: Smaller
-- BLAKE:  Greater
-- CLARK:  Greater
-- SCOTT:  Greater
-- KING:   Greater
-- TURNER: Smaller  (exactly 1500, so not > 1500)
-- ADAMS:  Smaller
-- JAMES:  Smaller
-- FORD:   Greater
-- MILLER: Smaller
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

-- ============================================================
-- Q5. Display DA of all employees:
--     sal >= 5000 -> 75% of sal
--     sal >= 3000 -> 60% of sal
--     else        -> 50% of sal
-- ============================================================
-- Expected Output:
-- Name: SMITH,  DA: 400
-- Name: ALLEN,  DA: 800
-- Name: WARD,   DA: 625
-- Name: JONES,  DA: 1785
-- Name: MARTIN, DA: 625
-- Name: BLAKE,  DA: 1710
-- Name: CLARK,  DA: 1225
-- Name: SCOTT,  DA: 1800
-- Name: KING,   DA: 3750
-- Name: TURNER, DA: 750
-- Name: ADAMS,  DA: 550
-- Name: JAMES,  DA: 475
-- Name: FORD,   DA: 1800
-- Name: MILLER, DA: 650
BEGIN
    FOR r IN (SELECT ename, sal FROM emp) LOOP
        DECLARE
            da NUMBER;
        BEGIN
            IF r.sal >= 5000 THEN
                da := 0.75 * r.sal;
            ELSIF r.sal >= 3000 THEN
                da := 0.60 * r.sal;
            ELSE
                da := 0.50 * r.sal;
            END IF;
            DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', DA: ' || da);
        END;
    END LOOP;
END;
/

-- ============================================================
-- Q6. Display names, job and hire date ordered by dept,
--     hire date descending within each dept
-- ============================================================
-- Expected Output (ordered by deptno ASC, hiredate DESC):
-- Dept: 10, Name: MILLER, Job: CLERK,    HireDate: 23-JAN-82
-- Dept: 10, Name: CLARK,  Job: MANAGER,  HireDate: 09-JUN-81
-- Dept: 10, Name: KING,   Job: PRESIDENT,HireDate: 17-NOV-81
-- Dept: 20, Name: ADAMS,  Job: CLERK,    HireDate: 12-JAN-83
-- Dept: 20, Name: SCOTT,  Job: ANALYST,  HireDate: 09-DEC-82
-- Dept: 20, Name: SMITH,  Job: CLERK,    HireDate: 17-DEC-80
-- Dept: 20, Name: JONES,  Job: MANAGER,  HireDate: 02-APR-81
-- Dept: 20, Name: FORD,   Job: ANALYST,  HireDate: 03-DEC-81
-- Dept: 30, Name: MARTIN, Job: SALESMAN, HireDate: 28-SEP-81
-- Dept: 30, Name: TURNER, Job: SALESMAN, HireDate: 08-SEP-81
-- Dept: 30, Name: ALLEN,  Job: SALESMAN, HireDate: 20-FEB-81
-- Dept: 30, Name: WARD,   Job: SALESMAN, HireDate: 22-FEB-81
-- Dept: 30, Name: JAMES,  Job: CLERK,    HireDate: 03-DEC-81
-- Dept: 30, Name: BLAKE,  Job: MANAGER,  HireDate: 01-MAY-81
BEGIN
    FOR r IN (SELECT ename, job, hiredate, deptno FROM emp ORDER BY deptno, hiredate DESC) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Dept: ' || r.deptno ||
            ', Name: ' || r.ename ||
            ', Job: ' || r.job ||
            ', HireDate: ' || TO_CHAR(r.hiredate, 'DD-MON-YY')
        );
    END LOOP;
END;
/

-- ============================================================
-- Q7. What would be the date after two months?
-- ============================================================
-- Expected Output (if today is 08-MAR-2026):
-- Date after two months: 08-MAY-2026
BEGIN
    DBMS_OUTPUT.PUT_LINE('Date after two months: ' || TO_CHAR(ADD_MONTHS(SYSDATE, 2), 'DD-MON-YYYY'));
END;
/

-- ============================================================
-- Q8. Employee number and name (initcap), dept no descending
-- ============================================================
-- Expected Output:
-- EmpNo: 7876, Name: Adams,  Dept: 20
-- EmpNo: 7788, Name: Scott,  Dept: 20
-- EmpNo: 7369, Name: Smith,  Dept: 20
-- EmpNo: 7566, Name: Jones,  Dept: 20
-- EmpNo: 7902, Name: Ford,   Dept: 20
-- EmpNo: 7499, Name: Allen,  Dept: 30
-- EmpNo: 7521, Name: Ward,   Dept: 30
-- EmpNo: 7654, Name: Martin, Dept: 30
-- EmpNo: 7698, Name: Blake,  Dept: 30
-- EmpNo: 7844, Name: Turner, Dept: 30
-- EmpNo: 7900, Name: James,  Dept: 30
-- EmpNo: 7839, Name: King,   Dept: 10
-- EmpNo: 7782, Name: Clark,  Dept: 10
-- EmpNo: 7934, Name: Miller, Dept: 10
BEGIN
    FOR r IN (SELECT empno, INITCAP(ename) AS ename, deptno FROM emp ORDER BY deptno DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('EmpNo: ' || r.empno || ', Name: ' || r.ename || ', Dept: ' || r.deptno);
    END LOOP;
END;
/

-- ============================================================
-- Q9. Concatenate name and job separated by three spaces
-- ============================================================
-- Expected Output:
-- SMITH   CLERK
-- ALLEN   SALESMAN
-- WARD    SALESMAN
-- JONES   MANAGER
-- MARTIN  SALESMAN
-- BLAKE   MANAGER
-- CLARK   MANAGER
-- SCOTT   ANALYST
-- KING    PRESIDENT
-- TURNER  SALESMAN
-- ADAMS   CLERK
-- JAMES   CLERK
-- FORD    ANALYST
-- MILLER  CLERK
BEGIN
    FOR r IN (SELECT CONCAT(ename, CONCAT('   ', job)) AS name_job FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.name_job);
    END LOOP;
END;
/

-- ============================================================
-- Q10. Display names padded to the right up to 16 characters with '.'
-- ============================================================
-- Expected Output:
-- SMITH...........
-- ALLEN...........
-- WARD............
-- JONES...........
-- MARTIN..........
-- BLAKE...........
-- CLARK...........
-- SCOTT...........
-- KING............
-- TURNER..........
-- ADAMS...........
-- JAMES...........
-- FORD............
-- MILLER..........
BEGIN
    FOR r IN (SELECT RPAD(ename, 16, '.') AS padded_name FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.padded_name);
    END LOOP;
END;
/

-- ============================================================
-- Q11. Show first three characters of each employee name
-- ============================================================
-- Expected Output:
-- SMI
-- ALL
-- WAR
-- JON
-- MAR
-- BLA
-- CLA
-- SCO
-- KIN
-- TUR
-- ADA
-- JAM
-- FOR
-- MIL
BEGIN
    FOR r IN (SELECT SUBSTR(ename, 1, 3) AS short_name FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.short_name);
    END LOOP;
END;
/

-- ============================================================
-- Q12. Find salary of all employees rounded to nearest Rs.1000
-- ============================================================
-- Expected Output:
-- SMITH:  1000
-- ALLEN:  2000
-- WARD:   1000
-- JONES:  3000
-- MARTIN: 1000
-- BLAKE:  3000
-- CLARK:  2000
-- SCOTT:  3000
-- KING:   5000
-- TURNER: 2000
-- ADAMS:  1000
-- JAMES:  1000
-- FORD:   3000
-- MILLER: 1000
BEGIN
    FOR r IN (SELECT ename, ROUND(sal, -3) AS rounded_sal FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || r.rounded_sal);
    END LOOP;
END;
/

-- ============================================================
-- Q13. Find employees whose name's last character = job's last character
-- ============================================================
-- Expected Output:
-- Name: BLAKE, Job: MANAGER   (E = R? No... let's check: BLAKE->E, MANAGER->R No)
-- After checking all: ALLEN->N, SALESMAN->N: ALLEN matches!
-- Name: ALLEN, Job: SALESMAN
-- (Verify: SMITH->H, CLERK->K No; WARD->D, SALESMAN->N No;
--  TURNER->R, SALESMAN->N No; MILLER->R, CLERK->K No)
-- Only ALLEN (ends N) matches SALESMAN (ends N)
BEGIN
    FOR r IN (
        SELECT ename, job
        FROM emp
        WHERE SUBSTR(ename, -1) = SUBSTR(job, -1)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Job: ' || r.job);
    END LOOP;
END;
/

-- ============================================================
-- Q14. Display names and salary in descending order of total income
--      (salary + commission)
-- ============================================================
-- Expected Output (income = sal + NVL(comm,0)):
-- Name: MARTIN, Income: 2650   (1250+1400)
-- Name: KING,   Income: 5000
-- Name: SCOTT,  Income: 3000
-- Name: FORD,   Income: 3000
-- Name: JONES,  Income: 2975
-- Name: BLAKE,  Income: 2850
-- Name: ALLEN,  Income: 1900   (1600+300)
-- Name: CLARK,  Income: 2450
-- Name: WARD,   Income: 1750   (1250+500)
-- Name: TURNER, Income: 1500   (1500+0)
-- Name: MILLER, Income: 1300
-- Name: ADAMS,  Income: 1100
-- Name: JAMES,  Income: 950
-- Name: SMITH,  Income: 800
BEGIN
    FOR r IN (
        SELECT ename, sal, NVL(comm, 0) AS comm
        FROM emp
        ORDER BY (sal + NVL(comm, 0)) DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Income: ' || (r.sal + r.comm));
    END LOOP;
END;
/

-- ============================================================
-- Q15. Display names of all employees with 'A' anywhere in the name
-- ============================================================
-- Expected Output:
-- ALLEN
-- WARD
-- MARTIN
-- BLAKE
-- CLARK
-- ADAMS
-- JAMES
-- WARD  (already listed above)
-- (All names containing 'A')
BEGIN
    FOR r IN (SELECT ename FROM emp WHERE ename LIKE '%A%') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

-- ============================================================
-- Q16. Show employees hired before the 16th of the month
-- ============================================================
-- Expected Output:
-- ALLEN  (20-FEB-81 -> day 20, skip)
-- Actually: hired before 16th means day < 16
-- SMITH:  17-DEC-80 -> 17, skip
-- ALLEN:  20-FEB-81 -> 20, skip
-- WARD:   22-FEB-81 -> 22, skip
-- JONES:  02-APR-81 -> 02, match
-- MARTIN: 28-SEP-81 -> 28, skip
-- BLAKE:  01-MAY-81 -> 01, match
-- CLARK:  09-JUN-81 -> 09, match
-- SCOTT:  09-DEC-82 -> 09, match
-- KING:   17-NOV-81 -> 17, skip
-- TURNER: 08-SEP-81 -> 08, match
-- ADAMS:  12-JAN-83 -> 12, match
-- JAMES:  03-DEC-81 -> 03, match
-- FORD:   03-DEC-81 -> 03, match
-- MILLER: 23-JAN-82 -> 23, skip
-- Expected: JONES, BLAKE, CLARK, SCOTT, TURNER, ADAMS, JAMES, FORD
BEGIN
    FOR r IN (
        SELECT ename, hiredate
        FROM emp
        WHERE TO_NUMBER(TO_CHAR(hiredate, 'DD')) < 16
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || TO_CHAR(r.hiredate, 'DD-MON-YY'));
    END LOOP;
END;
/

-- ============================================================
-- Q17. Show all employees with YES/NO for commission
--      YES if comm is not null and > 0, else NO
-- ============================================================
-- Expected Output:
-- SMITH:  NO
-- ALLEN:  YES  (comm=300)
-- WARD:   YES  (comm=500)
-- JONES:  NO
-- MARTIN: YES  (comm=1400)
-- BLAKE:  NO
-- CLARK:  NO
-- SCOTT:  NO
-- KING:   NO
-- TURNER: NO   (comm=0, not > 0)
-- ADAMS:  NO
-- JAMES:  NO
-- FORD:   NO
-- MILLER: NO
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

-- ============================================================
-- Q18. Show employees with name starting with J, K, L, or M
-- ============================================================
-- Expected Output:
-- JONES
-- MARTIN
-- KING
-- JAMES
-- MILLER
BEGIN
    FOR r IN (SELECT ename FROM emp WHERE ename LIKE 'J%' OR ename LIKE 'K%' OR ename LIKE 'L%' OR ename LIKE 'M%') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

-- ============================================================
-- Q19. Display the length of each employee's name
-- ============================================================
-- Expected Output:
-- SMITH:  5
-- ALLEN:  5
-- WARD:   4
-- JONES:  5
-- MARTIN: 6
-- BLAKE:  5
-- CLARK:  5
-- SCOTT:  5
-- KING:   4
-- TURNER: 6
-- ADAMS:  5
-- JAMES:  5
-- FORD:   4
-- MILLER: 6
BEGIN
    FOR r IN (SELECT ename, LENGTH(ename) AS len FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || r.len);
    END LOOP;
END;
/

-- ============================================================
-- Q20. Display name and job of employees with no manager
-- ============================================================
-- Expected Output:
-- Name: KING, Job: PRESIDENT
BEGIN
    FOR r IN (SELECT ename, job FROM emp WHERE mgr IS NULL) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Job: ' || r.job);
    END LOOP;
END;
/

-- ============================================================
-- Q21. Find employees whose name is 5 characters long and ends with 'N'
-- ============================================================
-- Expected Output:
-- ALLEN
-- Check: SMITH(5,H), ALLEN(5,N)match, WARD(4), JONES(5,S),
--        BLAKE(5,E), CLARK(5,K), SCOTT(5,T), ADAMS(5,S), JAMES(5,S), FORD(4)
-- Only ALLEN matches
BEGIN
    FOR r IN (SELECT ename FROM emp WHERE LENGTH(ename) = 5 AND ename LIKE '%N') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

-- ============================================================
-- Q22. Employee name and dept no for depts 10 and 30, alphabetical order
-- ============================================================
-- Expected Output:
-- Name: ALLEN,  Dept: 30
-- Name: BLAKE,  Dept: 30
-- Name: CLARK,  Dept: 10
-- Name: JAMES,  Dept: 30
-- Name: KING,   Dept: 10
-- Name: MARTIN, Dept: 30
-- Name: MILLER, Dept: 10
-- Name: TURNER, Dept: 30
-- Name: WARD,   Dept: 30
BEGIN
    FOR r IN (
        SELECT ename, deptno
        FROM emp
        WHERE deptno IN (10, 30)
        ORDER BY ename
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Dept: ' || r.deptno);
    END LOOP;
END;
/

-- ============================================================
-- Q23. Employees with no commission OR commission < 100
--      (comm IS NULL OR comm < 100)
-- ============================================================
-- Expected Output:
-- Name: SMITH,  Comm: NULL
-- Name: JONES,  Comm: NULL
-- Name: BLAKE,  Comm: NULL
-- Name: CLARK,  Comm: NULL
-- Name: SCOTT,  Comm: NULL
-- Name: KING,   Comm: NULL
-- Name: TURNER, Comm: 0      (0 < 100)
-- Name: ADAMS,  Comm: NULL
-- Name: JAMES,  Comm: NULL
-- Name: FORD,   Comm: NULL
-- Name: MILLER, Comm: NULL
BEGIN
    FOR r IN (
        SELECT ename, comm
        FROM emp
        WHERE comm IS NULL OR comm < 100
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Comm: ' || NVL(TO_CHAR(r.comm), 'NULL'));
    END LOOP;
END;
/

-- ============================================================
-- Q24. Find employees whose commission is exactly Rs.0
-- ============================================================
-- Expected Output:
-- TURNER has commission 0
BEGIN
    FOR r IN (SELECT ename, comm FROM emp WHERE comm = 0) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ' has commission ' || r.comm);
    END LOOP;
END;
/
