
--creating tables
CREATE TABLE SALESMAN
(
	Salesman_id number(4),
	Name VARCHAR(15),
	City VARCHAR (15),
	Commission NUMBER(7,2),
	Constraint pk_salesmanid PRIMARY KEY (Salesman_id)
);

CREATE TABLE CUSTOMER
(
	Customer_id NUMBER(4),
	Customer_name VARCHAR(15),
	City VARCHAR(15),
	Grade NUMBER(3),
	Salesman_id NUMBER(4),
	Constraint pk_customerid PRIMARY KEY (Customer_id),
	Constraint fk_salesmanid FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id) ON DELETE CASCADE
);

CREATE TABLE ORDERS
(
	Ord_no NUMBER(4),
	Purchase_amt NUMBER(10,2),
	Ord_date DATE,
	Customer_id NUMBER(4),
	Salesman_id NUMBER(4),
	Constraint pk_ordno PRIMARY KEY(Ord_no),
	Constraint fk_salesmanid1 FOREIGN KEY (Salesman_id) REFERENCES SALESMAN(Salesman_id) ON DELETE CASCADE,
	Constraint fk_customerid FOREIGN KEY(Customer_id) REFERENCES CUSTOMER(Customer_id) ON DELETE CASCADE
);

--inserting data

INSERT INTO SALESMAN VALUES (&salesman_id, '&name', '&city', &commission);
INSERT INTO CUSTOMER VALUES (&customer_id, '&customer_name', '&city', &grade, &salesman_id);
INSERT INTO ORDERS VALUES (&ord_no, &purchase_amt, '&ord_date', &customer_id, &salesman_id);


--queries

--1
SELECT COUNT(C.Customer_id)
FROM CUSTOMER C
WHERE C.Grade > (SELECT AVG(GRAD) FROM CUSTOMER WHERE CITY ='bangalore');

--2
SELECT S.Name, S.Salesman_id
FROM Salesman S, CUSTOMER C
WHERE S.Salesman_id = C.Salesman_id
GROUP BY S.name, S.salesman_id
HAVING COUNT (Customer_id) > 1;

--3
(SELECT S.Name, S.Salesman_id, C.Customer_name
FROM Salesman S, Customer C
WHERE S.Salesman_id = C.Salesman_id and S.city=C.city)
UNION
(SELECT s1.Name, s1.Salesman_id, 'No customer'
	FROM Salesman s1, Customer c1
	WHERE s1.Salesman_id = c1.Salesman_id and s1.City != C1.city
);

--4

CREATE VIEW MAX_ORD AS
	SELECT S.Salesman_id, S.name, C.Customer_id, C.Customer_name, O.Ord_date, O.Purchase_amt
	FROM Salesman S, Customer C, Orders O
	WHERE S.Salesman_id = C.Salesman_id and C.customer_id = S.customer_id;

SELECT * FROM MAX_ORD M
WHERE M.Purchase_amt = (SELECT MAX(M1.Purchase_amt) FROM MAX_ORD M1 WHERE M.Ord_date = M1.Ord_date);

--5
DELETE FROM SALESMAN WHERE Salesman_id = 1;


