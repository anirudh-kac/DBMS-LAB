--creating tables

-- Consider the schema for College Database:
-- STUDENT(USN, SName, Address, Phone, Gender)
-- SEMSEC(SSID, Sem, Sec)
-- CLASS(USN, SSID)
-- COURSE(Subcode, Title, Sem, Credits)
-- IAMARKS(USN, Subcode, SSID, Test1, Test2, Test3, FinalIA)

CREATE TABLE STUDENT(
    USN VARCHAR(10),
    SName VARCHAR(10),
    Address VARCHAR(10),
    Phone NUMBER(10),
    Gender CHAR,
    CONSTRAINT STUDENT_PK PRIMARY KEY (USN)
);

CREATE TABLE SEMSEC(
    SSID VARCHAR(10),
    Sem NUMBER(10),
    Sec CHAR,
    CONSTRAINT TABLE_PK PRIMARY KEY (SSID),
    CONSTRAINT C CHECK (Sem BETWEEN 1 AND 8)
);

CREATE TABLE CLASS(
    USN VARCHAR(10),
    SSID VARCHAR(10),
    CONSTRAINT CLASS_PK PRIMARY KEY(USN,SSID),
    CONSTRAINT CLASS_FK1 FOREIGN KEY (USN) REFERENCES STUDENT(USN) ON DELETE CASCADE,
    CONSTRAINT CLASS_FK2 FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID) ON DELETE CASCADE
);

CREATE TABLE COURSE(
    Subcode VARCHAR(10),
    Title VARCHAR(20),
    Sem NUMBER(1),
    Credits NUMBER(2),
    CONSTRAINT COURSE_C CHECK (Sem BETWEEN 1 AND 8),
    CONSTRAINT COURSE_PK PRIMARY KEY(Subcode)
);

CREATE TABLE IAMARKS(
    USN VARCHAR(10),
    Subcode VARCHAR(10),
    SSID VARCHAR(10),
    Test1 NUMBER(3),
    Test2 NUMBER(3),
    Test3 NUMBER(3),
    FinalIA NUMBER(3),
    CONSTRAINT IAMARKS_PK PRIMARY KEY (USN , SubCode , SSID),
    CONSTRAINT IAMARKS_FK1 FOREIGN KEY (USN )REFERENCES STUDENT(USN),
    CONSTRAINT IAMARKS_FK2 FOREIGN KEY (Subcode) REFERENCES COURSE(Subcode),
    CONSTRAINT IAMARKS_FK3 FOREIGN KEY (SSID) REFERENCES SEMSEC(SSID)
);

--inserting data

INSERT INTO STUDENT VALUES ('&USN','&SName','&Address','&Phone','&Gender');
INSERT INTO SEMSEC VALUES ('&SSID',&Sem,'&Sec');
INSERT INTO CLASS VALUES ('&USN','&SSID');
INSERT INTO COURSE VALUES ('&Subcode','&Title',&Sem,&Credits);
INSERT INTO IAMARKS VALUES ('&USN','&Subcode','&SSID',&Test1,&Test2,&Test3,&FinalIA);

--queries

--1 (set sem and section as mentioned)

-- List all the student details studying in fourth semester ‘C’ section

SELECT S.USN , S.SName , S.Address
FROM STUDENT S, SEMSEC SS , CLASS C
WHERE S.USN = C.USN AND SS.SSID = C.SSID AND SS.SEM = 4 AND SS.Sec = 'C';

--2 

-- Compute the total number of male and female students in each semester and in
-- each section.

SELECT SS.Sem , SS.Sec , S.Gender , COUNT(S.Gender) 
FROM STUDENT S , CLASS C , SEMSEC SS
WHERE S.USN = C.USN AND C.SSID = SS.SSID
GROUP BY SS.Sem ,SS.Sec , S.gender
ORDER BY SS.Sem , SS.Sec;

--3  (set usn acc to query)

-- Create a view of Test1 marks of student USN ‘1BI15CS101’ in all Courses.

CREATE VIEW S1IA AS
SELECT S.USN , IA.Test1 
FROM STUDENT S , IAMARKS IA
WHERE S.USN = IA.USN  AND S.USN = '1mv16cs001';

SELECT * FROM S1IA;

--4

-- Calculate the FinalIA (average of best two test marks) and update the
-- corresponding table for all students

UPDATE IAMARKS 
SET FinalIA = ((Test1+Test2+Test3) - (CASE
            WHEN Test1<Test2 and Test1<Test3 THEN Test1
            WHEN Test2<Test1 and Test2<Test3 THEN Test2
            ELSE Test3
            END
            ))/2;


--5 (set sem values accordingly)

-- Categorize students based on the following criterion:
-- If FinalIA = 17 to 20 then CAT = ‘Outstanding’
-- If FinalIA = 12 to 16 then CAT = ‘Average’
-- If FinalIA< 12 then CAT = ‘Weak’
-- Give these details only for 8th semester A, B, and C section students

SELECT S.USN , S.Sname , IA.FinalIA , (CASE
    WHEN IA.FinalIA BETWEEN 17 AND 20 THEN 'Outstanding'
    WHEN IA.FinalIA BETWEEN 12 AND 16 THEN 'Average'
    ELSE 'Weak'
    END
) as CAT 
FROM STUDENT S , IAMARKS IA, CLASS C , SEMSEC SS 
WHERE S.USN = IA.USN AND SS.SSID = IA.SSID AND SS.Sem = 8 AND (SS.Sec = 'A' OR SS.Sec = 'B' OR SS.Sec = 'C');