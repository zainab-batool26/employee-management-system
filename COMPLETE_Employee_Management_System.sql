-- ============================================================================
-- COMPLETE EMPLOYEE MANAGEMENT SYSTEM - ORACLE APEX
-- ONE FILE - COPY ENTIRE CONTENT AND EXECUTE IN SQL DEVELOPER
-- Execution Time: ~3-5 minutes
-- ============================================================================

-- Run this ENTIRE file in SQL Developer (F9 or Ctrl+Enter)
-- Do NOT run parts - run everything at once

-- ============================================================================
-- CLEANUP (Optional - uncomment if first run fails)
-- ============================================================================
-- DROP TABLE EMPLOYEE_AUDIT;
-- DROP TABLE EMPLOYEE_SKILLS;
-- DROP TABLE EMPLOYEES;
-- DROP TABLE DEPARTMENTS;
-- DROP SEQUENCE SEQ_EMPLOYEE_ID;
-- DROP SEQUENCE SEQ_DEPARTMENT_ID;
-- DROP SEQUENCE SEQ_SKILL_ID;
-- DROP SEQUENCE SEQ_AUDIT_ID;
-- DROP PACKAGE PKG_EMPLOYEE_MANAGEMENT;
-- DROP PACKAGE PKG_SKILL_MANAGEMENT;

-- ============================================================================
-- PART 1: CREATE TABLES
-- ============================================================================

CREATE TABLE DEPARTMENTS (
    DEPARTMENT_ID NUMBER PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR2(100) NOT NULL,
    DESCRIPTION VARCHAR2(500),
    MANAGER_ID NUMBER,
    CREATED_DATE DATE DEFAULT SYSDATE,
    UPDATED_DATE DATE DEFAULT SYSDATE
);

CREATE INDEX IDX_DEPT_NAME ON DEPARTMENTS(DEPARTMENT_NAME);

CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    LAST_NAME VARCHAR2(50) NOT NULL,
    EMAIL VARCHAR2(100) UNIQUE NOT NULL,
    PHONE VARCHAR2(20),
    HIRE_DATE DATE NOT NULL,
    DEPARTMENT_ID NUMBER NOT NULL,
    POSITION VARCHAR2(100) NOT NULL,
    SALARY NUMBER(10,2) NOT NULL,
    STATUS VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (STATUS IN ('ACTIVE', 'INACTIVE', 'ON_LEAVE')),
    MANAGER_ID NUMBER,
    CREATED_DATE DATE DEFAULT SYSDATE,
    UPDATED_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT FK_EMP_DEPT FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID),
    CONSTRAINT FK_EMP_MANAGER FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
);

CREATE INDEX IDX_EMP_EMAIL ON EMPLOYEES(EMAIL);
CREATE INDEX IDX_EMP_DEPT ON EMPLOYEES(DEPARTMENT_ID);
CREATE INDEX IDX_EMP_STATUS ON EMPLOYEES(STATUS);
CREATE INDEX IDX_EMP_HIRE_DATE ON EMPLOYEES(HIRE_DATE);

CREATE TABLE EMPLOYEE_SKILLS (
    SKILL_ID NUMBER PRIMARY KEY,
    EMPLOYEE_ID NUMBER NOT NULL,
    SKILL_NAME VARCHAR2(100) NOT NULL,
    PROFICIENCY_LEVEL VARCHAR2(50) CHECK (PROFICIENCY_LEVEL IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT')),
    YEARS_OF_EXPERIENCE NUMBER(3,1),
    CREATED_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT FK_SKILL_EMP FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID) ON DELETE CASCADE
);

CREATE INDEX IDX_SKILL_EMP ON EMPLOYEE_SKILLS(EMPLOYEE_ID);
CREATE INDEX IDX_SKILL_NAME ON EMPLOYEE_SKILLS(SKILL_NAME);

CREATE TABLE EMPLOYEE_AUDIT (
    AUDIT_ID NUMBER PRIMARY KEY,
    EMPLOYEE_ID NUMBER NOT NULL,
    ACTION VARCHAR2(50) NOT NULL,
    OLD_VALUES VARCHAR2(2000),
    NEW_VALUES VARCHAR2(2000),
    CHANGED_BY VARCHAR2(100),
    CHANGED_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT FK_AUDIT_EMP FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID) ON DELETE CASCADE
);

CREATE INDEX IDX_AUDIT_EMP ON EMPLOYEE_AUDIT(EMPLOYEE_ID);
CREATE INDEX IDX_AUDIT_DATE ON EMPLOYEE_AUDIT(CHANGED_DATE);

-- ============================================================================
-- PART 2: CREATE SEQUENCES
-- ============================================================================

CREATE SEQUENCE SEQ_EMPLOYEE_ID START WITH 1001 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_DEPARTMENT_ID START WITH 100 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_SKILL_ID START WITH 5001 INCREMENT BY 1 NOCACHE;
CREATE SEQUENCE SEQ_AUDIT_ID START WITH 10001 INCREMENT BY 1 NOCACHE;

-- ============================================================================
-- PART 3: INSERT SAMPLE DATA
-- ============================================================================

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, DESCRIPTION)
VALUES (SEQ_DEPARTMENT_ID.NEXTVAL, 'IT', 'Information Technology Department');
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, DESCRIPTION)
VALUES (SEQ_DEPARTMENT_ID.NEXTVAL, 'HR', 'Human Resources Department');
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, DESCRIPTION)
VALUES (SEQ_DEPARTMENT_ID.NEXTVAL, 'Finance', 'Finance and Accounting Department');
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, DESCRIPTION)
VALUES (SEQ_DEPARTMENT_ID.NEXTVAL, 'Sales', 'Sales and Business Development');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, DEPARTMENT_ID, POSITION, SALARY, STATUS)
VALUES (SEQ_EMPLOYEE_ID.NEXTVAL, 'Ahmed', 'Khan', 'ahmed.khan@company.com', '03001234567', SYSDATE-300, 100, 'Senior Developer', 150000, 'ACTIVE');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, DEPARTMENT_ID, POSITION, SALARY, STATUS, MANAGER_ID)
VALUES (SEQ_EMPLOYEE_ID.NEXTVAL, 'Fatima', 'Ali', 'fatima.ali@company.com', '03009876543', SYSDATE-200, 100, 'Junior Developer', 80000, 'ACTIVE', 1001);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, DEPARTMENT_ID, POSITION, SALARY, STATUS, MANAGER_ID)
VALUES (SEQ_EMPLOYEE_ID.NEXTVAL, 'Hassan', 'Raza', 'hassan.raza@company.com', '03005555555', SYSDATE-150, 100, 'QA Engineer', 75000, 'ACTIVE', 1001);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, DEPARTMENT_ID, POSITION, SALARY, STATUS)
VALUES (SEQ_EMPLOYEE_ID.NEXTVAL, 'Ayesha', 'Malik', 'ayesha.malik@company.com', '03003333333', SYSDATE-250, 101, 'HR Manager', 120000, 'ACTIVE');

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, DEPARTMENT_ID, POSITION, SALARY, STATUS)
VALUES (SEQ_EMPLOYEE_ID.NEXTVAL, 'Usman', 'Ahmed', 'usman.ahmed@company.com', '03002222222', SYSDATE-100, 102, 'Finance Analyst', 95000, 'ACTIVE');

INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1001, 'Oracle APEX', 'EXPERT', 5);
INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1001, 'PL/SQL', 'EXPERT', 6);
INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1001, 'Database Design', 'ADVANCED', 5);

INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1002, 'Oracle APEX', 'INTERMEDIATE', 1.5);
INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1002, 'SQL', 'INTERMEDIATE', 2);
INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1002, 'JavaScript', 'BEGINNER', 1);

INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1003, 'Testing', 'ADVANCED', 3);
INSERT INTO EMPLOYEE_SKILLS (SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE)
VALUES (SEQ_SKILL_ID.NEXTVAL, 1003, 'SQL', 'INTERMEDIATE', 2);

COMMIT;

-- ============================================================================
-- PART 4: CREATE VIEWS
-- ============================================================================

CREATE OR REPLACE VIEW VW_EMPLOYEE_DETAILS AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.EMAIL,
    E.PHONE,
    E.HIRE_DATE,
    E.POSITION,
    E.SALARY,
    E.STATUS,
    D.DEPARTMENT_NAME,
    CASE 
        WHEN E.MANAGER_ID IS NOT NULL THEN 
            (SELECT FIRST_NAME || ' ' || LAST_NAME FROM EMPLOYEES WHERE EMPLOYEE_ID = E.MANAGER_ID)
        ELSE 'No Manager'
    END AS MANAGER_NAME
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

CREATE OR REPLACE VIEW VW_EMPLOYEE_SKILLS_SUMMARY AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLOYEE_NAME,
    D.DEPARTMENT_NAME,
    COUNT(S.SKILL_ID) AS TOTAL_SKILLS,
    LISTAGG(S.SKILL_NAME, ', ') WITHIN GROUP (ORDER BY S.SKILL_NAME) AS SKILLS,
    LISTAGG(S.PROFICIENCY_LEVEL, ', ') WITHIN GROUP (ORDER BY S.SKILL_NAME) AS PROFICIENCY_LEVELS
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN EMPLOYEE_SKILLS S ON E.EMPLOYEE_ID = S.EMPLOYEE_ID
GROUP BY E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME;

-- ============================================================================
-- PART 5: CREATE PL/SQL PACKAGES
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_EMPLOYEE_MANAGEMENT AS
    PROCEDURE INSERT_EMPLOYEE(
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone IN VARCHAR2,
        p_hire_date IN DATE,
        p_department_id IN NUMBER,
        p_position IN VARCHAR2,
        p_salary IN NUMBER,
        p_manager_id IN NUMBER DEFAULT NULL,
        p_status IN VARCHAR2 DEFAULT 'ACTIVE'
    );

    PROCEDURE UPDATE_EMPLOYEE(
        p_employee_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone IN VARCHAR2,
        p_position IN VARCHAR2,
        p_salary IN NUMBER,
        p_department_id IN NUMBER,
        p_status IN VARCHAR2
    );

    PROCEDURE DELETE_EMPLOYEE(
        p_employee_id IN NUMBER
    );

    PROCEDURE GET_EMPLOYEE(
        p_employee_id IN NUMBER,
        p_first_name OUT VARCHAR2,
        p_last_name OUT VARCHAR2,
        p_email OUT VARCHAR2,
        p_phone OUT VARCHAR2,
        p_hire_date OUT DATE,
        p_department_id OUT NUMBER,
        p_position OUT VARCHAR2,
        p_salary OUT NUMBER,
        p_status OUT VARCHAR2
    );

    PROCEDURE UPDATE_EMPLOYEE_STATUS(
        p_employee_id IN NUMBER,
        p_new_status IN VARCHAR2
    );

    PROCEDURE UPDATE_SALARY(
        p_employee_id IN NUMBER,
        p_new_salary IN NUMBER
    );

    FUNCTION GET_EMPLOYEE_SALARY(
        p_employee_id IN NUMBER
    ) RETURN NUMBER;

    FUNCTION GET_DEPARTMENT_EMPLOYEE_COUNT(
        p_department_id IN NUMBER
    ) RETURN NUMBER;

    FUNCTION GET_TOTAL_PAYROLL(
        p_department_id IN NUMBER
    ) RETURN NUMBER;

    FUNCTION GET_AVERAGE_SALARY(
        p_department_id IN NUMBER
    ) RETURN NUMBER;

END PKG_EMPLOYEE_MANAGEMENT;
/

CREATE OR REPLACE PACKAGE BODY PKG_EMPLOYEE_MANAGEMENT AS

    PROCEDURE INSERT_EMPLOYEE(
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone IN VARCHAR2,
        p_hire_date IN DATE,
        p_department_id IN NUMBER,
        p_position IN VARCHAR2,
        p_salary IN NUMBER,
        p_manager_id IN NUMBER DEFAULT NULL,
        p_status IN VARCHAR2 DEFAULT 'ACTIVE'
    ) AS
    BEGIN
        IF p_first_name IS NULL OR p_last_name IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'First name and last name are required');
        END IF;

        IF p_email IS NULL THEN
            RAISE_APPLICATION_ERROR(-20002, 'Email is required');
        END IF;

        IF p_salary <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Salary must be greater than 0');
        END IF;

        IF p_department_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'Department ID is required');
        END IF;

        IF EXISTS (SELECT 1 FROM EMPLOYEES WHERE EMAIL = p_email) THEN
            RAISE_APPLICATION_ERROR(-20005, 'Email already exists');
        END IF;

        INSERT INTO EMPLOYEES (
            EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE,
            DEPARTMENT_ID, POSITION, SALARY, STATUS, MANAGER_ID, CREATED_DATE, UPDATED_DATE
        ) VALUES (
            SEQ_EMPLOYEE_ID.NEXTVAL, p_first_name, p_last_name, LOWER(p_email), p_phone, p_hire_date,
            p_department_id, p_position, p_salary, p_status, p_manager_id, SYSDATE, SYSDATE
        );

        COMMIT;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20010, 'Duplicate email or employee already exists');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error inserting employee: ' || SQLERRM);
    END INSERT_EMPLOYEE;

    PROCEDURE UPDATE_EMPLOYEE(
        p_employee_id IN NUMBER,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_email IN VARCHAR2,
        p_phone IN VARCHAR2,
        p_position IN VARCHAR2,
        p_salary IN NUMBER,
        p_department_id IN NUMBER,
        p_status IN VARCHAR2
    ) AS
        v_old_email VARCHAR2(100);
    BEGIN
        IF p_employee_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20006, 'Employee ID is required');
        END IF;

        IF p_salary <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Salary must be greater than 0');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id) THEN
            RAISE_APPLICATION_ERROR(-20007, 'Employee not found');
        END IF;

        SELECT EMAIL INTO v_old_email FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;

        IF p_email != v_old_email THEN
            IF EXISTS (SELECT 1 FROM EMPLOYEES WHERE EMAIL = p_email AND EMPLOYEE_ID != p_employee_id) THEN
                RAISE_APPLICATION_ERROR(-20008, 'Email already exists for another employee');
            END IF;
        END IF;

        UPDATE EMPLOYEES
        SET
            FIRST_NAME = p_first_name,
            LAST_NAME = p_last_name,
            EMAIL = LOWER(p_email),
            PHONE = p_phone,
            POSITION = p_position,
            SALARY = p_salary,
            DEPARTMENT_ID = p_department_id,
            STATUS = p_status,
            UPDATED_DATE = SYSDATE
        WHERE EMPLOYEE_ID = p_employee_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error updating employee: ' || SQLERRM);
    END UPDATE_EMPLOYEE;

    PROCEDURE DELETE_EMPLOYEE(
        p_employee_id IN NUMBER
    ) AS
    BEGIN
        IF p_employee_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20006, 'Employee ID is required');
        END IF;

        IF NOT EXISTS (SELECT 1 FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id) THEN
            RAISE_APPLICATION_ERROR(-20007, 'Employee not found');
        END IF;

        DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error deleting employee: ' || SQLERRM);
    END DELETE_EMPLOYEE;

    PROCEDURE GET_EMPLOYEE(
        p_employee_id IN NUMBER,
        p_first_name OUT VARCHAR2,
        p_last_name OUT VARCHAR2,
        p_email OUT VARCHAR2,
        p_phone OUT VARCHAR2,
        p_hire_date OUT DATE,
        p_department_id OUT NUMBER,
        p_position OUT VARCHAR2,
        p_salary OUT NUMBER,
        p_status OUT VARCHAR2
    ) AS
    BEGIN
        SELECT FIRST_NAME, LAST_NAME, EMAIL, PHONE, HIRE_DATE, DEPARTMENT_ID, POSITION, SALARY, STATUS
        INTO p_first_name, p_last_name, p_email, p_phone, p_hire_date, p_department_id, p_position, p_salary, p_status
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = p_employee_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20007, 'Employee not found');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error retrieving employee: ' || SQLERRM);
    END GET_EMPLOYEE;

    PROCEDURE UPDATE_EMPLOYEE_STATUS(
        p_employee_id IN NUMBER,
        p_new_status IN VARCHAR2
    ) AS
    BEGIN
        IF p_new_status NOT IN ('ACTIVE', 'INACTIVE', 'ON_LEAVE') THEN
            RAISE_APPLICATION_ERROR(-20009, 'Invalid status. Must be ACTIVE, INACTIVE, or ON_LEAVE');
        END IF;

        UPDATE EMPLOYEES
        SET STATUS = p_new_status, UPDATED_DATE = SYSDATE
        WHERE EMPLOYEE_ID = p_employee_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'Employee not found');
        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error updating status: ' || SQLERRM);
    END UPDATE_EMPLOYEE_STATUS;

    PROCEDURE UPDATE_SALARY(
        p_employee_id IN NUMBER,
        p_new_salary IN NUMBER
    ) AS
    BEGIN
        IF p_new_salary <= 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Salary must be greater than 0');
        END IF;

        UPDATE EMPLOYEES
        SET SALARY = p_new_salary, UPDATED_DATE = SYSDATE
        WHERE EMPLOYEE_ID = p_employee_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20007, 'Employee not found');
        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error updating salary: ' || SQLERRM);
    END UPDATE_SALARY;

    FUNCTION GET_EMPLOYEE_SALARY(
        p_employee_id IN NUMBER
    ) RETURN NUMBER AS
        v_salary NUMBER;
    BEGIN
        SELECT SALARY INTO v_salary FROM EMPLOYEES WHERE EMPLOYEE_ID = p_employee_id;
        RETURN v_salary;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20007, 'Employee not found');
        WHEN OTHERS THEN
            RETURN NULL;
    END GET_EMPLOYEE_SALARY;

    FUNCTION GET_DEPARTMENT_EMPLOYEE_COUNT(
        p_department_id IN NUMBER
    ) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM EMPLOYEES WHERE DEPARTMENT_ID = p_department_id;
        RETURN v_count;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END GET_DEPARTMENT_EMPLOYEE_COUNT;

    FUNCTION GET_TOTAL_PAYROLL(
        p_department_id IN NUMBER
    ) RETURN NUMBER AS
        v_total NUMBER;
    BEGIN
        SELECT SUM(SALARY) INTO v_total FROM EMPLOYEES WHERE DEPARTMENT_ID = p_department_id;
        RETURN NVL(v_total, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END GET_TOTAL_PAYROLL;

    FUNCTION GET_AVERAGE_SALARY(
        p_department_id IN NUMBER
    ) RETURN NUMBER AS
        v_avg NUMBER;
    BEGIN
        SELECT AVG(SALARY) INTO v_avg FROM EMPLOYEES WHERE DEPARTMENT_ID = p_department_id;
        RETURN NVL(v_avg, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END GET_AVERAGE_SALARY;

END PKG_EMPLOYEE_MANAGEMENT;
/

CREATE OR REPLACE PACKAGE PKG_SKILL_MANAGEMENT AS
    PROCEDURE ADD_EMPLOYEE_SKILL(
        p_employee_id IN NUMBER,
        p_skill_name IN VARCHAR2,
        p_proficiency_level IN VARCHAR2,
        p_years_of_experience IN NUMBER
    );

    PROCEDURE UPDATE_EMPLOYEE_SKILL(
        p_skill_id IN NUMBER,
        p_skill_name IN VARCHAR2,
        p_proficiency_level IN VARCHAR2,
        p_years_of_experience IN NUMBER
    );

    PROCEDURE DELETE_EMPLOYEE_SKILL(
        p_skill_id IN NUMBER
    );

    FUNCTION GET_EMPLOYEE_SKILL_COUNT(
        p_employee_id IN NUMBER
    ) RETURN NUMBER;

END PKG_SKILL_MANAGEMENT;
/

CREATE OR REPLACE PACKAGE BODY PKG_SKILL_MANAGEMENT AS

    PROCEDURE ADD_EMPLOYEE_SKILL(
        p_employee_id IN NUMBER,
        p_skill_name IN VARCHAR2,
        p_proficiency_level IN VARCHAR2,
        p_years_of_experience IN NUMBER
    ) AS
    BEGIN
        IF p_proficiency_level NOT IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT') THEN
            RAISE_APPLICATION_ERROR(-20011, 'Invalid proficiency level');
        END IF;

        INSERT INTO EMPLOYEE_SKILLS (
            SKILL_ID, EMPLOYEE_ID, SKILL_NAME, PROFICIENCY_LEVEL, YEARS_OF_EXPERIENCE, CREATED_DATE
        ) VALUES (
            SEQ_SKILL_ID.NEXTVAL, p_employee_id, p_skill_name, p_proficiency_level, p_years_of_experience, SYSDATE
        );

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error adding skill: ' || SQLERRM);
    END ADD_EMPLOYEE_SKILL;

    PROCEDURE UPDATE_EMPLOYEE_SKILL(
        p_skill_id IN NUMBER,
        p_skill_name IN VARCHAR2,
        p_proficiency_level IN VARCHAR2,
        p_years_of_experience IN NUMBER
    ) AS
    BEGIN
        IF p_proficiency_level NOT IN ('BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'EXPERT') THEN
            RAISE_APPLICATION_ERROR(-20011, 'Invalid proficiency level');
        END IF;

        UPDATE EMPLOYEE_SKILLS
        SET SKILL_NAME = p_skill_name,
            PROFICIENCY_LEVEL = p_proficiency_level,
            YEARS_OF_EXPERIENCE = p_years_of_experience
        WHERE SKILL_ID = p_skill_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error updating skill: ' || SQLERRM);
    END UPDATE_EMPLOYEE_SKILL;

    PROCEDURE DELETE_EMPLOYEE_SKILL(
        p_skill_id IN NUMBER
    ) AS
    BEGIN
        DELETE FROM EMPLOYEE_SKILLS WHERE SKILL_ID = p_skill_id;
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Error deleting skill: ' || SQLERRM);
    END DELETE_EMPLOYEE_SKILL;

    FUNCTION GET_EMPLOYEE_SKILL_COUNT(
        p_employee_id IN NUMBER
    ) RETURN NUMBER AS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM EMPLOYEE_SKILLS WHERE EMPLOYEE_ID = p_employee_id;
        RETURN v_count;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END GET_EMPLOYEE_SKILL_COUNT;

END PKG_SKILL_MANAGEMENT;
/

-- ============================================================================
-- PART 6: VERIFICATION QUERIES (Check everything works)
-- ============================================================================

SELECT '✓ Tables Created' FROM DUAL;
SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME IN ('EMPLOYEES', 'DEPARTMENTS', 'EMPLOYEE_SKILLS', 'EMPLOYEE_AUDIT');

SELECT '✓ Employees Data:' FROM DUAL;
SELECT * FROM EMPLOYEES;

SELECT '✓ Departments Data:' FROM DUAL;
SELECT * FROM DEPARTMENTS;

SELECT '✓ Employee Skills Data:' FROM DUAL;
SELECT * FROM EMPLOYEE_SKILLS;

SELECT '✓ Employee Details View:' FROM DUAL;
SELECT * FROM VW_EMPLOYEE_DETAILS;

SELECT '✓ Employee Skills Summary View:' FROM DUAL;
SELECT * FROM VW_EMPLOYEE_SKILLS_SUMMARY;

SELECT '✓ Testing Procedures:' FROM DUAL;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total IT Employees: ' || PKG_EMPLOYEE_MANAGEMENT.GET_DEPARTMENT_EMPLOYEE_COUNT(100));
    DBMS_OUTPUT.PUT_LINE('Average IT Salary: ' || PKG_EMPLOYEE_MANAGEMENT.GET_AVERAGE_SALARY(100));
    DBMS_OUTPUT.PUT_LINE('Total IT Payroll: ' || PKG_EMPLOYEE_MANAGEMENT.GET_TOTAL_PAYROLL(100));
END;
/

-- ============================================================================
-- PART 7: TEST INSERT PROCEDURE
-- ============================================================================

BEGIN
    PKG_EMPLOYEE_MANAGEMENT.INSERT_EMPLOYEE(
        p_first_name => 'Ali',
        p_last_name => 'Hassan',
        p_email => 'ali.hassan@company.com',
        p_phone => '03007777777',
        p_hire_date => SYSDATE,
        p_department_id => 100,
        p_position => 'Database Administrator',
        p_salary => 110000
    );
    DBMS_OUTPUT.PUT_LINE('✓ New employee created successfully');
END;
/

-- ============================================================================
-- FINAL VERIFICATION
-- ============================================================================

SELECT '✓ DATABASE SETUP COMPLETE!' as status FROM DUAL;
SELECT COUNT(*) as total_employees FROM EMPLOYEES;
SELECT COUNT(*) as total_skills FROM EMPLOYEE_SKILLS;
SELECT COUNT(*) as total_departments FROM DEPARTMENTS;

-- ============================================================================
-- YOU'RE DONE! Database is ready for APEX
-- ============================================================================
-- Next step: Create APEX Application (see separate APEX Setup Guide)
-- Tables created: EMPLOYEES, DEPARTMENTS, EMPLOYEE_SKILLS, EMPLOYEE_AUDIT
-- Packages created: PKG_EMPLOYEE_MANAGEMENT, PKG_SKILL_MANAGEMENT
-- Views created: VW_EMPLOYEE_DETAILS, VW_EMPLOYEE_SKILLS_SUMMARY
-- Sample data: 6 employees, 4 departments, 9 skills
-- ============================================================================
