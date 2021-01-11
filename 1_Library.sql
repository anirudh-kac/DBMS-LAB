--creating tables

CREATE TABLE BOOK (
    Book_id NUMBER(4),
    Title VARCHAR(20),
    Publisher_name VARCHAR(20),
    Pub_year NUMBER(4) ,
    CONSTRAINT PK_A PRIMARY KEY (Book_id)
);

DESC BOOK;

CREATE TABLE BOOK_AUTHORS (
    Book_id NUMBER(4),
    Author_name VARCHAR(20),
    CONSTRAINT FK_A FOREIGN Key (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE
);

DESC BOOK_AUTHORS;

CREATE TABLE PUBLISHER (
    Name VARCHAR(20),
    Address VARCHAR(20),
    Phone NUMBER(20)
);

DESC PUBLISHER ;

CREATE TABLE LIBRARY_PROGRAMME (
    Programme_id NUMBER(4),
    Programme_name VARCHAR(20),
    Address VARCHAR(20),
    CONSTRAINT PK_B PRIMARY KEY (Programme_id)
);

DESC LIBRARY_PROGRAMME;

CREATE TABLE BOOK_COPIES (
    Book_id NUMBER(4),
    Programme_id NUMBER(4),
    No_of_copies NUMBER(4),
    CONSTRAINT FK_B FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE,
    CONSTRAINT FK_C FOREIGN KEY (Programme_id) REFERENCES LIBRARY_PROGRAMME (Programme_id) ON DELETE CASCADE
);

DESC BOOK_COPIES;

CREATE TABLE BOOK_LENDING (
    Book_id NUMBER(4),
    Programme_id NUMBER(4),
    Card_no NUMBER(4),
    Date_out DATE,
    Due_date DATE,
    CONSTRAINT PK_C PRIMARY KEY (Card_no),
    CONSTRAINT FK_D FOREIGN KEY (Book_id) REFERENCES BOOK(Book_id) ON DELETE CASCADE,
    CONSTRAINT FK_E FOREIGN KEY (Programme_id) REFERENCES LIBRARY_PROGRAMME(Programme_id) ON DELETE CASCADE
);

DESC BOOK_LENDING;

--inserting data

INSERT INTO BOOK VALUES (&Book_id,'&Title','&Publisher',&Pub_year);
INSERT INTO BOOK_AUTHORS VALUES (&Book_id,'&Author_name');
INSERT INTO PUBLISHER VALUES ('&Name','&Address',&Phone);
INSERT INTO LIBRARY_PROGRAMME VALUES (&Programme_id,'&Programme_name','&Address');
INSERT INTO BOOK_COPIES VALUES (&Book_id,&Programme_id,&No_of_copies);
INSERT INTO BOOK_LENDING VALUES (&Book_id,&Programme_id,&Card_no,'&Date_out','&Due_date');

--queries


--1
SELECT B.Book_id , B.Title , B.Publisher_name , B.Pub_year , A.Author_name , C.No_of_copies , L.Programme_id
FROM BOOK B , BOOK_AUTHORS A , BOOK_COPIES C , LIBRARY_PROGRAMME L
WHERE B.Book_id = A.Book_id AND B.Book_id = C.Book_id AND L.Programme_id = C.Programme_id
AND (C.Programme_id ,C.Book_id) IN (
    SELECT Programme_id , Book_id 
    FROM BOOK_COPIES 
    GROUP BY Programme_id , Book_id
)
--2
SELECT * FROM BOOK_LENDING
WHERE Due_date BETWEEN '01-JAN-17' AND '28-FEB-21' AND 
Card_no IN (
    SELECT Card_no FROM BOOK_LENDING
    GROUP BY Card_no 
    HAVING COUNT(Card_no) > 3
);

--3
DELETE FROM BOOK WHERE Book_id = 3;

--4
connect / as sysdba
grant create view to anirudh
connect anirudh/password

CREATE VIEW YEAR AS 
SELECT Pub_year 
FROM BOOK;

SELECT * FROM YEAR;

--5
CREATE VIEW ALL_BOOKS AS
SELECT B.Title , L.Programme_name , C.No_of_copies , L.Programme_name
FROM BOOK B , LIBRARY_PROGRAMME L , BOOK_COPIES C
WHERE B.Book_id = C.Book_id AND L.Programme_id = C.Programme_id;

SELECT * FROM ALL_BOOKS;