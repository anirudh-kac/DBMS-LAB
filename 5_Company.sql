--creating tables

-- Consider the schema for Company Database:
-- EMPLOYEE(SSN, Name, Address, Sex, Salary, SuperSSN, DNo)
-- DEPARTMENT(DNo, DName, MgrSSN, MgrStartDate)
-- DLOCATION(DNo,DLoc)
-- PROJECT(PNo, PName, PLocation, DNo)
-- WORKS_ON(SSN, PNo, Hours)

CREATE TABLE EMPLOYEE(
    SSN NUMBER(10),
    Name VARCHAR(10),
    Address VARCHAR(20),
    Sex CHAR,
    Salary NUMBER(10),
    SuperSSN NUMBER(10),
    Dno NUMBER(10),
    CONSTRAINT EMPLOYEE_PK PRIMARY KEY(SSN)
);

CREATE TABLE DEPARTMENT(
    DNo NUMBER(10),
    Dname VARCHAR(10),
    MgrSSN NUMBER(10),
    MgrStartDate DATE,
    CONSTRAINT DEPARTMENT_PK PRIMARY KEY (Dno),
    CONSTRAINT DEPARTMENT_FK FOREIGN KEY (MgrSSN) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE
);

CREATE TABLE DLOCATION (
    DNo NUMBER(10),
    DLoc VARCHAR(20),
    CONSTRAINT DLOCATION_PK PRIMARY KEY (DNo,DLoc),
    CONSTRAINT DLOCATION_FK FOREIGN KEY (DNo) REFERENCES DEPARTMENT (DNo) ON DELETE CASCADE
);

CREATE TABLE PROJECT(
    PNo NUMBER(10),
    PName VARCHAR(10),
    PLocation VARCHAR(20),
    DNo NUMBER(20),
    CONSTRAINT PROJECT_PK PRIMARY KEY (PNo),
    CONSTRAINT PROJECT_FK FOREIGN KEY(DNo) REFERENCES DEPARTMENT (DNo) ON DELETE CASCADE
);


CREATE TABLE WORKS_ON(
    SSN NUMBER(10),
    PNo NUMBER(10),
    Hours NUMBER(3),
    CONSTRAINT WORKS_ON_PK PRIMARY KEY (SSN,PNo),
    CONSTRAINT WORKS_ON_FK1 FOREIGN KEY (SSN) REFERENCES EMPLOYEE(SSN) ON DELETE CASCADE,
    CONSTRAINT WORKS_ON_FK2 FOREIGN KEY (PNo) REFERENCES PROJECT(PNo) ON DELETE CASCADE
);

--add fk on employee
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMPLOYEE_FK FOREIGN KEY (DNo) REFERENCES DEPARTMENT (DNo) ON DELETE CASCADE;


--INSERTING DATA

INSERT INTO EMPLOYEE VALUES (&SSN , '&Name' , '&Address' , '&Sex',&Salary,&SuperSSN,&DNo);
INSERT INTO DEPARTMENT VALUES (&DNo , '&DName' , &MgrSSN,'&MgrStartDate');
INSERT INTO DLOCATION VALUES (&DNo,'&DLoc');
INSERT INTO PROJECT VALUES (&PNo,'&PName','&PLocation',&DNo);
INSERT INTO WORKS_ON VALUES (&SSN,&PNo,&Hours);


--QUERIES

--1

-- Make a list of all project numbers for projects that involve an employee whose
-- last name is ‘Scott’, either as a worker or as a manager of the department that
-- controls the project

(
    SELECT DISTINCT P.PNo 
    FROM PROJECT P , EMPLOYEE E , WORKS_ON W 
    WHERE E.Name = 'Scott' AND E.SSN = W.SSN AND W.PNo = P.PNo
)
UNION
(
    SELECT DISTINCT P1.PNo
    FROM PROJECT P1 , EMPLOYEE E1 , DEPARTMENT D 
    WHERE E1.Name ='Scott' AND D.DNo = P1.DNo AND D.MgrSSN = E1.SSN
);

--2

-- Show the resulting salaries if every employee working on the ‘IoT’ project is
-- given a 10 percent raise.

SELECT E.SSN , (E.Salary * 1.1)) AS NEW_SALARY
FROM EMPLOYEE E  , PROJECT P , WORKS_ON W 
WHERE P.PName = 'IOT' and E.SSN = W.SSN AND W.PNo = P.PNo;

--3

-- Find the sum of the salaries of all employees of the ‘Accounts’ department, as
-- well as the maximum salary, the minimum salary, and the average salary in this
-- department

SELECT  SUM(E.SALARY) , MIN(E.SALARY) , MAX(E.SALARY) , AVG(E.SALARY)
FROM DEPARTMENT D , EMPLOYEE E
WHERE D.DName = 'ACCOUNTS' ;


--4

-- Retrieve the name of each employee who works on all the projects controlledby
-- department number 5 (use NOT EXISTS operator).

SELECT E.Name 
FROM EMPLOYEE E 
WHERE NOT EXISTS(
    (
        SELECT P.PNo 
        FROM PROJECT P 
        WHERE P.Dno = 5
    )
    MINUS
    (
        SELECT W.PNo
        FROM WORKS_ON W 
        WHERE W.SSN = E.SSN
    )
);

--5

-- For each department that has more than five employees, retrieve the department
-- number and the number of its employees who are making more than Rs.
-- 6,00,000.


SELECT DNo , COUNT(*)
FROM EMPLOYEE
WHERE SALARY > 60000  AND DNo IN (
    SELECT E.DNo 
    FROM EMPLOYEE E 
    GROUP BY E.DNo
    HAVING COUNT(*) > 5
)
GROUP BY DNo;

