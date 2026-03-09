SET SERVEROUTPUT ON;

DECLARE
    v_emp_exists NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_emp_exists
    FROM user_tables
    WHERE table_name = 'EMP';

    IF v_emp_exists = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE TABLE emp (
                empno NUMBER(4) PRIMARY KEY,
                ename VARCHAR2(10),
                job VARCHAR2(9),
                mgr NUMBER(4),
                hiredate DATE,
                sal NUMBER(7,2),
                comm NUMBER(7,2),
                deptno NUMBER(2)
            )';

        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7369, 'SMITH', 'CLERK', 7902, TO_DATE('17-DEC-1980', 'DD-MON-YYYY'), 800, NULL, 20)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7499, 'ALLEN', 'SALESMAN', 7698, TO_DATE('20-FEB-1981', 'DD-MON-YYYY'), 1600, 300, 30)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7521, 'WARD', 'SALESMAN', 7698, TO_DATE('22-FEB-1981', 'DD-MON-YYYY'), 1250, 500, 30)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7566, 'JONES', 'MANAGER', 7839, TO_DATE('02-APR-1981', 'DD-MON-YYYY'), 2975, NULL, 20)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7654, 'MARTIN', 'SALESMAN', 7698, TO_DATE('28-SEP-1981', 'DD-MON-YYYY'), 1250, 1400, 30)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7698, 'BLAKE', 'MANAGER', 7839, TO_DATE('01-MAY-1981', 'DD-MON-YYYY'), 2850, NULL, 30)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7782, 'CLARK', 'MANAGER', 7839, TO_DATE('09-JUN-1981', 'DD-MON-YYYY'), 2450, NULL, 10)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7788, 'SCOTT', 'ANALYST', 7566, TO_DATE('09-DEC-1982', 'DD-MON-YYYY'), 3000, NULL, 20)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7839, 'KING', 'PRESIDENT', NULL, TO_DATE('17-NOV-1981', 'DD-MON-YYYY'), 5000, NULL, 10)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7844, 'TURNER', 'SALESMAN', 7698, TO_DATE('08-SEP-1981', 'DD-MON-YYYY'), 1500, 0, 30)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7876, 'ADAMS', 'CLERK', 7788, TO_DATE('12-JAN-1983', 'DD-MON-YYYY'), 1100, NULL, 20)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7900, 'JAMES', 'CLERK', 7698, TO_DATE('03-DEC-1981', 'DD-MON-YYYY'), 950, NULL, 30)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7902, 'FORD', 'ANALYST', 7566, TO_DATE('03-DEC-1981', 'DD-MON-YYYY'), 3000, NULL, 20)]';
        EXECUTE IMMEDIATE q'[INSERT INTO emp VALUES (7934, 'MILLER', 'CLERK', 7782, TO_DATE('23-JAN-1982', 'DD-MON-YYYY'), 1300, NULL, 10)]';

        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Setup: EMP table created and seeded with sample rows.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Setup: EMP table already exists in current schema.');
    END IF;
END;
/

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

BEGIN
    FOR r IN (SELECT ename, hiredate FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(
            r.ename || ' joined on the ' ||
            TO_CHAR(r.hiredate, 'fmDdspth "of" Month "of the year" Year')
        );
    END LOOP;
END;
/

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

BEGIN
    DBMS_OUTPUT.PUT_LINE('Date after two months: ' || TO_CHAR(ADD_MONTHS(SYSDATE, 2), 'DD-MON-YYYY'));
END;
/

BEGIN
    FOR r IN (SELECT empno, INITCAP(ename) AS ename, deptno FROM emp ORDER BY deptno DESC) LOOP
        DBMS_OUTPUT.PUT_LINE('EmpNo: ' || r.empno || ', Name: ' || r.ename || ', Dept: ' || r.deptno);
    END LOOP;
END;
/

BEGIN
    FOR r IN (SELECT CONCAT(ename, CONCAT('   ', job)) AS name_job FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.name_job);
    END LOOP;
END;
/

BEGIN
    FOR r IN (SELECT RPAD(ename, 16, '.') AS padded_name FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.padded_name);
    END LOOP;
END;
/

BEGIN
    FOR r IN (SELECT SUBSTR(ename, 1, 3) AS short_name FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.short_name);
    END LOOP;
END;
/

BEGIN
    FOR r IN (SELECT ename, ROUND(sal, -3) AS rounded_sal FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || r.rounded_sal);
    END LOOP;
END;
/

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

BEGIN
    FOR r IN (SELECT ename FROM emp WHERE ename LIKE '%A%') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

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

BEGIN
    FOR r IN (SELECT ename FROM emp WHERE ename LIKE 'J%' OR ename LIKE 'K%' OR ename LIKE 'L%' OR ename LIKE 'M%') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

BEGIN
    FOR r IN (SELECT ename, LENGTH(ename) AS len FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ': ' || r.len);
    END LOOP;
END;
/

BEGIN
    FOR r IN (SELECT ename, job FROM emp WHERE mgr IS NULL) LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || r.ename || ', Job: ' || r.job);
    END LOOP;
END;
/

BEGIN
    FOR r IN (SELECT ename FROM emp WHERE LENGTH(ename) = 5 AND ename LIKE '%N') LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename);
    END LOOP;
END;
/

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

BEGIN
    FOR r IN (SELECT ename, comm FROM emp WHERE comm = 0) LOOP
        DBMS_OUTPUT.PUT_LINE(r.ename || ' has commission ' || r.comm);
    END LOOP;
END;
/
