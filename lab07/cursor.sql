SET SERVEROUTPUT ON;

DECLARE
    TYPE student_cur_t IS REF CURSOR;
    branch_cursor student_cur_t;

    v_name   Student.name%TYPE;
    v_branch Student.branch%TYPE;
    v_marks  Student.marks%TYPE;
    v_grade  VARCHAR2(2);

    count_o NUMBER := 0;
    count_e NUMBER := 0;
    count_a NUMBER := 0;

    v_has_subjects NUMBER := 0;

BEGIN

    SELECT COUNT(*)
    INTO v_has_subjects
    FROM user_tab_columns
    WHERE table_name = 'STUDENT'
    AND column_name = 'SUBJECTS';

    IF v_has_subjects > 0 THEN
        OPEN branch_cursor FOR
            'SELECT name, branch, marks
             FROM Student
             WHERE subjects = :1'
        USING 'SEM-4';

    ELSE
        DBMS_OUTPUT.PUT_LINE('Note: SUBJECTS column not found, processing all STUDENT rows.');

        OPEN branch_cursor FOR
            'SELECT name, branch, marks
             FROM Student';
    END IF;

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

        DBMS_OUTPUT.PUT_LINE(
            'Name: ' || v_name ||
            ', Branch: ' || v_branch ||
            ', Marks: ' || v_marks ||
            ', Grade: ' || v_grade
        );

    END LOOP;

    CLOSE branch_cursor;

    DBMS_OUTPUT.PUT_LINE('Count O: ' || count_o);
    DBMS_OUTPUT.PUT_LINE('Count E: ' || count_e);
    DBMS_OUTPUT.PUT_LINE('Count A: ' || count_a);

END;
/