CREATE DATABASE BOOKSTORE
CREATE TABLE BOOKS (
	BOOK_ID INT PRIMARY KEY,
	TITLE VARCHAR(100),
	AUTHOR VARCHAR(100),
	GENRE VARCHAR(50),
	PUBLISHED_YEAR INT,
	PRICE NUMERIC(10, 2),
	STOCK INT
);

SELECT*FROM BOOKS
DROP TABLE IF EXISTS CUSTOMERS;

CREATE TABLE CUSTOMERS (
	CUSTOMER_ID INT PRIMARY KEY,
	NAME VARCHAR(100),
	EMAIL VARCHAR(100),
	PHONE INT,
	CITY VARCHAR(100),
	COUNTRY VARCHAR(100)
);

SELECT*FROM CUSTOMERS



DROP TABLE IF EXISTS ORDERS;

CREATE TABLE ORDERS (
	ORDER_ID SERIAL PRIMARY KEY,
	CUSTOMER_ID INT REFERENCES CUSTOMERS (CUSTOMER_ID),
	BOOK_ID INT REFERENCES BOOKS (BOOK_ID),
	ORDER_DATE DATE,
	QUANTITY INT,
	TOTAL_AMOUNT NUMERIC(10, 2)
);
SELECT*FROM Orders;

COPY BOOKS (
	BOOK_ID,
	TITLE,
	AUTHOR,
	GENRE,
	PUBLISHED_YEAR,
	PRICE,
	STOCK
)
FROM 'D:\sql_project\Books.csv'
DELIMITER ','
CSV HEADER;

COPY CUSTOMERS (CUSTOMER_ID, NAME, EMAIL, PHONE, CITY, COUNTRY)
FROM 'D:\sql_project\Customers.csv' 
DELIMITER ','
CSV HEADER;

COPY ORDERS (
	ORDER_ID,
	CUSTOMER_ID,
	BOOK_ID,
	ORDER_DATE,
	QUANTITY,
	TOTAL_AMOUNT
)
FROM 'D:\sql_project\Orders.csv' 
DELIMITER ','
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:
select * from books
where genre='Fiction';

-- 2) Find books published after the year 1950:
select*from books
where published_year>1950;


-- 3) List all customers from the Canada:
select * from CUSTOMERS
where country='Canada';

-- 4) Show orders placed in November 2023:
select*from orders
where order_date BETWEEN '2023-11-01' AND '2023-11-30'


-- 5) Retrieve the total stock of books available:
select sum(stock)Total_Stock from books; 


-- 6) Find the details of the most expensive book:
SELECT  *
FROM books
ORDER BY price DESC
LIMIT  1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
select*from orders
where quantity>1;


-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT*FROM orders
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
select distinct  genre from books
 
-- 10) Find the book with the lowest stock:
select* from books
order by stock asc
limit 1;

-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount)Revenue from orders


-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:
select b.genre, sum(o.quantity)TotalBooksAreSolded  from books as b
join orders as o
on b.book_id=o.book_id
group by b.genre


-- 2) Find the average price of books in the "Fantasy" genre:
select genre, avg(price)AvgPriceOfGenrBook from books
where genre='Fantasy'
group by genre

-- 3) List customers who have placed at least 2 orders:
select c.customer_id,name,quantity from customers as  c
join orders as o 
on c.customer_id=o.customer_id
where quantity >2;


-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select genre,price from books
where genre='Fantasy'
order by price desc
limit 3;

-- 6) Retrieve the total quantity of books sold by each author:

select b.author, sum(o.quantity) as "books sold by each author" from books as b
join orders as o
on b.book_id=o.book_id
group by b.author

-- 7) List the cities where customers who spent over $30 are located:

select distinct c.city,o.total_amount from customers as c
join orders as o
on o.customer_id=c.customer_id
where o.total_amount>30;

-- 8) Find the customer who spent the most on orders:

SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent from customers as c
join orders as o
on c.customer_id=o.customer_id
group by c.customer_id, c.name
order by Total_Spent desc
limit 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;