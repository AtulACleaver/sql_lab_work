-- Using Cursor
-- 1. Print the Student Name, Branch Name, and Grade
-- 2. Count O, E Grade if semester 4
--      mark >= 90 - O
--      mark >= 80 where mark <= 89 - E
--      mark >= 70 where mark <= 79 - A
--      else - F

SET SERVEROUTPUT ON;

DECLARE
    CURSOR branch_cursor IS
        SELECT s.name, b.br_name, s.marks
        FROM Student s
        JOIN Branch b ON s.br_id = b.br_id
        WHERE s.subjects = 'SEM-4';

    v_name   Student.name%TYPE;
    v_branch Branch.br_name%TYPE;
    v_marks  Student.marks%TYPE;
    v_grade  VARCHAR2(2);
    count_o  NUMBER := 0;
    count_e  NUMBER := 0;
    count_a  NUMBER := 0;

BEGIN
    OPEN branch_cursor;
    LOOP
        FETCH branch_cursor INTO v_name, v_branch, v_marks;
        EXIT WHEN branch_cursor%NOTFOUND;

        IF v_marks >= 90 THEN
            v_grade := 'O';
            count_o := count_o + 1;
        ELSIF v_marks >= 80 THEN
            v_grade := 'E';
            count_e := count_e + 1;
        ELSIF v_marks >= 70 THEN
            v_grade := 'A';
            count_a := count_a + 1;
        ELSE
            v_grade := 'F';
        END IF;

        DBMS_OUTPUT.PUT_LINE('Name: ' || v_name || ', Branch: ' || v_branch || ', Marks: ' || v_marks || ', Grade: ' || v_grade);
    END LOOP;
    CLOSE branch_cursor;

    DBMS_OUTPUT.PUT_LINE('Count O: ' || count_o);
    DBMS_OUTPUT.PUT_LINE('Count E: ' || count_e);
    DBMS_OUTPUT.PUT_LINE('Count A: ' || count_a);
END;
/
