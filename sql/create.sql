--  create.sql -- Standard ORACLE example database for generic installation
--
--  Description
--
--      Copyright (C) Jari Aalto
--
--      This is a conversion of the original "ORACLE SQL1 lab
--      Cretabs.sql" command script that sets up Oracle education
--      environment for tables and data. The conversion is NOT
--      COMPLETE.
--
--      NOTE: Table and column names are case sensitive in some
--      Operating Systems. Double check your typing in SQL commands.
--
--  Data type differences to original Oracle SQL:
--
--      The following conversions were done:
--
--          ORACLE                  Portable for other DBMS
--          ---------------         ------------------------
--          NUMBER(8,2)             NUMERIC(8,2)
--          VARCHAR2(14)            VARCHAR(14)
--          LONG                    LONGTEXT
--
--  Reserved keywords
--
--      Some databaes do not accept reserved keyword in table names. The
--      original Oracle table ORD has thus named as ORDX to avoid
--      conflicts with reserved words. Other examples:
--
--          CREATE TABLE ORDER ....
--                       =====
--                       possibly interpreted as "ORDER BY" in older MySQL?
--
--  Names
--
--      In some databases the column and table names are *case*
--      *sensitive* if the Operating System treats files case
--      sensitive (like in Unix). Here, all the fields and table
--      names have been written in all lowercase letters.
--
--      In Oracle, field and table names are not case sensitive.
--
--  Date differencies
--
--      The dates in Oracle are different from other DBMS products,
--      Consult documention. In general Oracle's DD-MON-YY dates were
--      converted into ISO 8601 YYYY-MM-DD dates.
--
--  Primary key and Foreign key constraints
--
--      Not all DBMS products support contraints used here.
--      The statements may be accepted but not actual integrity
--       checks may not be happening. Check DBMS manual for the behavior.
--
-- Character sets
--
--      Some DBMS products may default to Latin-1 in tables (e.g. MySQL).
--      In order to user UTF-8, this must be changed by the user or
--      system administrator. Check DBMS manual for the behavior.
--
--      EXAMPLES FOR MYSQL after login with 'mysql' client:
--
--      http://dev.mysql.com/doc/refman/5.0/en/charset-applications.html
--
--           CHARACTER SET utf8
--           COLLATE       utf8_general_ci
--
--     Server startup parameters:
--
--          [mysqld]
--          character-set-server=utf8
--          collation-server=utf8_general_ci
--
--  Views
--
--      Views are not created. Not all DBMS products support views.
--
--  Command execution differencies
--
--      Oracle ignores any DROP TABLE command if the table does not exist.
--
--      Some databases (like MySQL) stops running a script if there is
--      no table before DROP TABLE command. In order to circumvent
--      this, a non-SQL92 standard, but widely available, syntax is used:
--
--          DROP TABLE IF EXISTS emp;
--                     =========
--                     Note: not a SQL-92 compliant statement
--
--  Tables created:
--
--      Database 1:
--
--          emp
--          dept
--          salgrade
--
--      Database 2:
--
--          item
--          ordx
--          price
--          product
--          bonus
--          customer
--
--      Extra table:
--
--          dummy
--
-- ----------------------------------------------------------------------
--
--
--          Deleting tables, views and other DB structures
--
--
-- ----------------------------------------------------------------------


--    This were a Oracle terminal command. Commented out
--
-- set termout off

--   Do not create views or iterators. Commented out.

-- DROP VIEW SALES;

-- DROP SEQUENCE ORDID;
-- DROP SEQUENCE CUSTID;
-- DROP SEQUENCE PRODID;



-- ----------------------------------------------------------------------
--
--
--          Creating TABLES
--
--
-- ----------------------------------------------------------------------

DROP TABLE IF EXISTS DEPT;
DROP TABLE IF EXISTS dept;

CREATE TABLE dept
(
    deptno                INTEGER       NOT NULL UNIQUE
    , dname               VARCHAR(14)
    , loc                 VARCHAR(13)

    , CONSTRAINT dept_primary_key
      PRIMARY KEY (deptno)
);

CREATE UNIQUE INDEX dept_deptno_pk
    ON dept (deptno);

DROP TABLE IF EXISTS EMP;
DROP TABLE IF EXISTS emp;

CREATE TABLE emp
(
    empno                 INTEGER       NOT NULL UNIQUE
    , ename               VARCHAR(10)
    , job                 VARCHAR(9)

    , mgr                 INTEGER
    , hiredate            DATE
    , sal                 NUMERIC(7,2)
    , comm                NUMERIC(7,2)
    , deptno              INTEGER       NOT NULL

    , CONSTRAINT emp_empno_pk
      PRIMARY KEY (empno)

    , CONSTRAINT emp_mgr_fk
      FOREIGN KEY (mgr)
      REFERENCES emp (empno)

    , CONSTRAINT emp_deptno_fk
      FOREIGN KEY (deptno)
      REFERENCES dept (deptno)
);

CREATE UNIQUE INDEX emp_empno_uindex
    ON emp (empno);


DROP TABLE IF EXISTS BONUS;
DROP TABLE IF EXISTS bonus;

CREATE TABLE bonus
(
    ename                 VARCHAR(10)
    , job                 VARCHAR(9)
    , sal                 NUMERIC
    , comm                NUMERIC
);

DROP TABLE IF EXISTS SALGRADE;
DROP TABLE IF EXISTS salgrade;

CREATE TABLE salgrade
(
    grade                 INTEGER NOT NULL UNIQUE
    , losal               NUMERIC NOT NULL
    , hisal               NUMERIC NOT NULL

    , CONSTRAINT salgrade_primary_key
      PRIMARY KEY (grade)

    , CONSTRAINT losal_unique_key
      UNIQUE (losal)

    , CONSTRAINT hisal_unique_key
      UNIQUE (hisal)
);


-- DUAL conflicts with MySQL / NOT INSTALLED
--
-- [13.2.7. SELECT Syntax /5.0.12 manual] From MySQL 4.1.0 on, you are
-- allowed to specify DUAL as a dummy table name in situations where
-- no tables are referenced
-- http://dev.mysql.com/doc/refman/5.0/en/select.html
--
-- Oracle has dummy table DUAL from where you can query the
-- commands, like calculating the yearly income:
--
--     SELECT 9455 * 12 AS "Yearly income"  FROM dual;

-- DROP TABLE IF EXISTS DUAL;
-- DROP TABLE IF EXISTS dual;
--
-- CREATE TABLE dual
-- (
--     dummy               VARCHAR(1) NULL
-- );

-- Oracle contains default value 'X' in the table DUAL

-- INSERT INTO dual VALUES ('X');


DROP TABLE IF EXISTS CUSTOMER;
DROP TABLE IF EXISTS customer;

CREATE TABLE customer
(
    custid                INTEGER       NOT NULL UNIQUE
    , name                VARCHAR(45)
    , address             VARCHAR(40)
    , city                VARCHAR(30)
    , state               VARCHAR(2)
    , zip                 VARCHAR(9)
    , area                INTEGER
    , phone               VARCHAR(9)
    , repid               INTEGER       NOT NULL
    , creditlimit         NUMERIC(9,2)
    -- LONGTEXT
    , comments            VARCHAR(1024)

    , CONSTRAINT customer_custid_pk
      PRIMARY KEY (custid)

    , CONSTRAINT customer_custid_ck
      CHECK (custid > 0)
);

CREATE UNIQUE INDEX customer_custid_uindex
    ON customer (custid);

-- This table is named ORD in Oracle, but in MySQL the word
-- is reserved SQL92 word and thus not accepted.

DROP TABLE IF EXISTS ORDX;
DROP TABLE IF EXISTS ordx;

CREATE TABLE ordx
(
      ordid               INTEGER       NOT NULL UNIQUE
    , orderdate           DATE
    , commplan            VARCHAR(1)
    , custid              INTEGER       NOT NULL
    , shipdate            DATE
    , total               NUMERIC(8,2)

    , CONSTRAINT ord_custid_fk
      FOREIGN KEY (custid)
      REFERENCES customer (custid)

    , CONSTRAINT ord_ordid_pk
      PRIMARY KEY (ordid)

    , CONSTRAINT ord_total_ck
      CHECK (TOTAL >= 0)
);

CREATE UNIQUE INDEX ordx_ordid_uindex
    ON ordx (ordid);


DROP TABLE IF EXISTS ITEM;
DROP TABLE IF EXISTS item;

CREATE TABLE item
(
    ordid                 INTEGER       NOT NULL UNIQUE
    , itemid              INTEGER       NOT NULL
    , prodid              INTEGER
    , actualprice         NUMERIC(8,2)
    , qty                 INTEGER
    , itemtot             NUMERIC(8,2)

    , CONSTRAINT  item_ordid_fk
      FOREIGN KEY (ordid)
      REFERENCES  ordx (ordid)

    , CONSTRAINT  item_ordid_itemid_pk
      PRIMARY KEY (ordid, itemid)
);

CREATE UNIQUE INDEX item_ordid_uindex
    ON item (ordid, itemid);

DROP TABLE IF EXISTS PRODUCT;
DROP TABLE IF EXISTS product;

CREATE TABLE product
(
    prodid                INTEGER
    , descrip             VARCHAR (30)

    , CONSTRAINT prodid_pk
      PRIMARY KEY (prodid)
);

CREATE UNIQUE INDEX product_prodid_uindex
    ON product (prodid);


DROP TABLE IF EXISTS PRICE;
DROP TABLE IF EXISTS price;

CREATE TABLE price
(
    prodid                INTEGER       NOT NULL UNIQUE
    , stdprice            NUMERIC (8,2)
    , minprice            NUMERIC (8,2)
    , startdate           DATE
    , enddate             DATE

    , CONSTRAINT price_pk
      PRIMARY KEY (prodid)
);

CREATE INDEX  price_index
    ON price (prodid, startdate);


-- CREATE UNIQUE INDEX price_prodid_uindex ON price (prodid);


-- ----------------------------------------------------------------------
--
--
--          Creating SEQUENCES
--
--
-- ----------------------------------------------------------------------


-- CREATE SEQUENCE ORDID
--     INCREMENT BY 1
--     START WITH 622
--     NOCACHE;
--
--
-- CREATE SEQUENCE PRODID
--     INCREMENT BY 1
--     START WITH 200381
--     NOCACHE;
--
-- CREATE SEQUENCE CUSTID
--     INCREMENT BY 1
--     START WITH 109
--     NOCACHE;
--
--


-- ----------------------------------------------------------------------
--
--
--          Creating VIEWS
--
--
-- ----------------------------------------------------------------------


-- CREATE VIEW SALES AS
--     SELECT REPID, ORD.CUSTID, CUSTOMER.NAME CUSTNAME, PRODUCT.PRODID,
--     DESCRIP PRODNAME, SUM(ITEMTOT) AMOUNT
--     FROM ORD, ITEM, CUSTOMER, PRODUCT
--     WHERE ORD.ORDID = ITEM.ORDID
--     AND ORD.CUSTID = CUSTOMER.CUSTID
--     AND ITEM.PRODID = PRODUCT.PRODID
--     GROUP BY REPID, ORD.CUSTID, NAME, PRODUCT.PRODID, DESCRIP
--     ;
--


-- ----------------------------------------------------------------------
--
--
--          Inserting data to tables
--
--
-- ----------------------------------------------------------------------



-- ----------------------------------------------------------------------
--
--          Insert DEPT
--
-- ----------------------------------------------------------------------


INSERT INTO dept VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO dept VALUES (20,'RESEARCH','DALLAS');
INSERT INTO dept VALUES (30,'SALES','CHICAGO');
INSERT INTO dept VALUES (40,'OPERATIONS','BOSTON');


-- ----------------------------------------------------------------------
--
--          Insert EMP
--
-- ----------------------------------------------------------------------


INSERT INTO emp VALUES (7839,'KING','PRESIDENT',NULL,'1981-11-17',5000,NULL,10);
INSERT INTO emp VALUES (7698,'BLAKE','MANAGER',7839,'1981-05-01',2850,NULL,30);
INSERT INTO emp VALUES (7782,'CLARK','MANAGER',7839,'1981-06-09',2450,NULL,10);
INSERT INTO emp VALUES (7566,'JONES','MANAGER',7839,'1981-04-02',2975,NULL,20);
INSERT INTO emp VALUES (7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250,1400,30);
INSERT INTO emp VALUES (7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600,300,30);
INSERT INTO emp VALUES (7844,'TURNER','SALESMAN',7698,'1981-09-08',1500,0,30);
INSERT INTO emp VALUES (7900,'JAMES','CLERK',7698,'1981-12-03',950,NULL,30);
INSERT INTO emp VALUES (7521,'WARD','SALESMAN',7698,'1981-02-22',1250,500,30);
INSERT INTO emp VALUES (7902,'FORD','ANALYST',7566,'1981-12-03',3000,NULL,20);
INSERT INTO emp VALUES (7369,'SMITH','CLERK',7902,'1980-12-17',800,NULL,20);
INSERT INTO emp VALUES (7788,'SCOTT','ANALYST',7566,'1982-12-09',3000,NULL,20);
INSERT INTO emp VALUES (7876,'ADAMS','CLERK',7788,'1983-01-12',1100,NULL,20);
INSERT INTO emp VALUES (7934,'MILLER','CLERK',7782,'1982-01-23',1300,NULL,10);


-- ----------------------------------------------------------------------
--
--          Insert SALGRADE
--
-- ----------------------------------------------------------------------



INSERT INTO salgrade VALUES (1,700,1200);
INSERT INTO salgrade VALUES (2,1201,1400);
INSERT INTO salgrade VALUES (3,1401,2000);
INSERT INTO salgrade VALUES (4,2001,3000);
INSERT INTO salgrade VALUES (5,3001,9999);


-- ----------------------------------------------------------------------
--
--          Insert CUSTOMER
--
-- ----------------------------------------------------------------------


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    96711, 'CA', 7844, '598-6609',
    'JOCKSPORTS',
    100, 5000, 'BELMONT', 415, '345 VIEWRIDGE',
    'Very friendly people to work with -- sales rep likes to be called Mike.'
);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    94061, 'CA', 7521, '368-1223',
    'TKB SPORT SHOP',
    101, 10000, 'REDWOOD CITY', 415, '490 BOLI RD.',
    'Rep called 5/8 about change in order - contact shipping.'
);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    95133, 'CA', 7654, '644-3341',
    'VOLLYRITE',
    102, 7000, 'BURLINGAME', 415, '9722 HAMILTON',
    'Company doing heavy promotion beginning 10/89. Prepare for large orders during winter.'

);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    97544, 'CA', 7521, '677-9312',
    'JUST TENNIS',
    103, 3000, 'BURLINGAME', 415, 'HILLVIEW MALL',
    'Contact rep about new line of tennis rackets.'
);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    93301, 'CA', 7499, '996-2323',
    'EVERY MOUNTAIN',
    104, 10000, 'CUPERTINO', 408, '574 SURRY RD.',
    'Customer with high market share (23%) due to aggressive advertising.'
);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    91003, 'CA', 7844, '376-9966',
    'K + T SPORTS',
    105, 5000, 'SANTA CLARA', 408, '3476 EL PASEO',
    'Tends to order large amounts of merchandise at once. Accounting is considering raising their credit limit. Usually pays on time.'

);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    94301, 'CA', 7521, '364-9777',
    'SHAPE UP',
    106, 6000, 'PALO ALTO', 415, '908 SEQUOIA',
    'Support intensive. Orders small amounts (< 800) of merchandise at a time.'

);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    93301, 'CA', 7499, '967-4398',
    'WOMENS SPORTS',
    107, 10000, 'SUNNYVALE', 408, 'VALCO VILLAGE',
    'First sporting goods store geared exclusively towards women. Unusual promotional style and very willing to take chances towards new products!'
);


INSERT INTO customer
(
    zip, state, repid, phone, name, custid, creditlimit,
    city, area, address, comments
)
VALUES
(
    55649, 'MN', 7844, '566-9123',
    'NORTH WOODS HEALTH AND FITNESS SUPPLY CENTER',
    108, 8000, 'HIBBING', 612, '98 LONE PINE WAY', NULL
);


-- ----------------------------------------------------------------------
--
--          Insert ORDER
--
-- ----------------------------------------------------------------------


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (101.4, '1987-01-08', 610, '1987-01-07', 101, 'A');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (45, '1987-01-11', 611, '1987-01-11', 102, 'B');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (5860, '1987-01-20', 612, '1987-01-15', 104, 'C');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (2.4, '1986-05-30', 601, '1986-05-01', 106, 'A');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (56, '1986-06-20', 602, '1986-06-05', 102, 'B');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (698, '1986-06-30', 604, '1986-06-15', 106, 'A');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (8324, '1986-07-30', 605, '1986-07-14', 106, 'A');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (3.4, '1986-07-30', 606, '1986-07-14', 100, 'A');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (97.5, '1986-08-15', 609, '1986-08-01', 100, 'B');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (5.6, '1986-07-18', 607, '1986-07-18', 104, 'C');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (35.2, '1986-07-25', 608, '1986-07-25', 104, 'C');


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (224, '1986-06-05', 603, '1986-06-05', 102, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (4450, '1987-03-12', 620, '1987-03-12', 100, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (6400, '1987-02-01', 613, '1987-02-01', 108, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (23940, '1987-02-05', 614, '1987-02-01', 102, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (764, '1987-02-10', 616, '1987-02-03', 103, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (1260, '1987-02-04', 619, '1987-02-22', 104, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (46370, '1987-03-03', 617, '1987-02-05', 105, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (710, '1987-02-06', 615, '1987-02-01', 107, NULL);


INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (3510.5, '1987-03-06', 618, '1987-02-15', 102, 'A');

INSERT INTO ordx (total, shipdate, ordid, orderdate, custid, commplan)
 VALUES (730, '1987-01-01', 621, '1987-03-15', 100, 'A');


-- ----------------------------------------------------------------------
--
--          Insert ITEM
--
-- ----------------------------------------------------------------------


INSERT INTO item (qty, prodid, ordid, itemtot, itemid, actualprice)
 VALUES (1, 100890, 610, 58, 3, 58);

INSERT INTO item (qty , prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 100861, 611, 45, 1, 45);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 100860, 612, 3000, 1, 30);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 200376, 601, 2.4, 1, 2.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (20, 100870, 602, 56, 1, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (3, 100890, 604, 174, 1, 58);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (2, 100861, 604, 84, 2, 42);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 100860, 604, 440, 3, 44);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (4, 100860, 603, 224, 2, 56);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 100860, 610, 35, 1, 35);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (3, 100870, 610, 8.4, 2, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (200, 200376, 613, 440, 4, 2.2);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (444, 100860, 614, 15540, 1, 35);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1000, 100870, 614, 2800, 2, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (20, 100861, 612, 810, 2, 40.5);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (150, 101863, 612, 1500, 3, 10);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 100860, 620, 350, 1, 35);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1000, 200376, 620, 2400, 2, 2.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (500, 102130, 620, 1700, 3, 3.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 100871, 613, 560, 1, 5.6);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (200, 101860, 613, 4800, 2, 24);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (150, 200380, 613, 600, 3, 4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 102130, 619, 340, 3, 3.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (50, 100860, 617, 1750, 1, 35);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 100861, 617, 4500, 2, 45);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1000, 100871, 614, 5600, 3, 5.6);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 100861, 616, 450, 1, 45);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (50, 100870, 616, 140, 2, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (2, 100890, 616, 116, 3, 58);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 102130, 616, 34, 4, 3.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 200376 , 616, 24, 5, 2.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 200380, 619, 400, 1, 4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 200376, 619, 240, 2, 2.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (4, 100861, 615, 180, 1, 45);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 100871, 607, 5.6, 1, 5.6);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 100870, 615, 280, 2, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (500, 100870, 617, 1400, 3, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (500, 100871, 617, 2800, 4, 5.6);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (500, 100890, 617, 29000, 5, 58);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 101860, 617, 2400, 6, 24);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (200, 101863, 617, 2500, 7, 12.5);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 102130, 617, 340, 8, 3.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (200, 200376, 617, 480, 9, 2.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (300, 200380, 617, 1200, 10, 4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (5, 100870, 609, 12.5, 2, 2.5);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 100890, 609, 50, 3, 50);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (23, 100860, 618, 805, 1, 35);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (50, 100861, 618, 2255.5, 2, 45.11);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 100870, 618, 450, 3, 45);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 100861, 621, 450, 1, 45);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 100870, 621, 280, 2, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (50, 100871, 615, 250, 3, 5);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 101860, 608, 24, 1, 24);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (2, 100871, 608, 11.2, 2, 5.6);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 100861, 609, 35, 1, 35);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (1, 102130, 606, 3.4, 1, 3.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 100861, 605, 4500, 1, 45);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (500, 100870, 605, 1400, 2, 2.8);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (5, 100890, 605, 290, 3, 58);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (50, 101860, 605, 1200, 4, 24);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 101863, 605, 900, 5, 9);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (10, 102130, 605, 34, 6, 3.4);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (100, 100871, 612, 550, 4, 5.5);

INSERT INTO item (qty, prodid , ordid , itemtot , itemid , actualprice)
 VALUES (50, 100871, 619, 280, 4, 5.6);


-- ----------------------------------------------------------------------
--
--          Insert PRICE
--
-- ----------------------------------------------------------------------

INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (4.8, '1985-01-01', 100871, 3.2, '1985-12-01');
-- INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
--  VALUES (5.6, '1986-01-01', 100871, 4.8, NULL);
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (58, '1985-01-01', 100890, 46.4, NULL);
-- INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
--  VALUES (54, '1984-06-01', 100890, 40.5, '1984-05-31');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (35, '1986-06-01', 100860, 28, NULL);
-- INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
--  VALUES (32, '1986-01-01', 100860, 25.6, '1986-05-31');
-- INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
--  VALUES (30, '1985-01-01', 100860, 24, '1985-12-31');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (45, '1986-06-01', 100861, 36, NULL);
-- INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
--  VALUES (42, '1986-01-01', 100861, 33.6, '1986-05-31');
-- INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
--  VALUES (39, '1985-01-01', 100861, 31.2, '1985-12-31');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (2.8, '1986-01-01', 100870, 2.4, NULL);
-- INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
--  VALUES (2.4, '1985-01-01', 100870, 1.9, '1985-12-01');
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (24, '1985-02-15', 101860, 18, NULL);
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (12.5, '1985-02-15', 101863, 9.4, NULL);
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (3.4, '1985-08-18', 102130, 2.8, NULL);
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (2.4, '1986-11-15', 200376, 1.75, NULL);
INSERT INTO price (stdprice, startdate, prodid, minprice, enddate)
 VALUES (4, '1986-11-15', 200380, 3.2, NULL);


-- ----------------------------------------------------------------------
--
--          Insert PRODUCT
--
-- ----------------------------------------------------------------------


INSERT INTO product (prodid, descrip)
 VALUES (100860, 'ACE TENNIS RACKET I');

INSERT INTO product (prodid, descrip)
 VALUES (100861, 'ACE TENNIS RACKET II');

INSERT INTO product (prodid, descrip)
 VALUES (100870, 'ACE TENNIS BALLS-3 PACK');

INSERT INTO product (prodid, descrip)
 VALUES (100871, 'ACE TENNIS BALLS-6 PACK');

INSERT INTO product (prodid, descrip)
 VALUES (100890, 'ACE TENNIS NET');

INSERT INTO product (prodid, descrip)
 VALUES (101860, 'SP TENNIS RACKET');

INSERT INTO product (prodid, descrip)
 VALUES (101863, 'SP JUNIOR RACKET');

INSERT INTO product (prodid, descrip)
 VALUES (102130, 'RH: "GUIDE TO TENNIS"');

INSERT INTO product (prodid, descrip)
 VALUES (200376, 'SB ENERGY BAR-6 PACK');

INSERT INTO product (prodid, descrip)
 VALUES (200380, 'SB VITA SNACK-6 PACK');

-- End of file
