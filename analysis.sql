use books_analysis 

CREATE TABLE books(
Book_ID int PRIMARY KEY NOT NULL,
Title varchar(100),
Author varchar(100),
Genre varchar(30),
Published_Year int,
Price decimal(2,2),
stock int );

CREATE TABLE customers(
Customer_ID int PRIMARY KEY NOT NULL,
Name varchar(100),
Email varchar(100),
Phone varchar(15),
City varchar(100),
Country varchar(100)
);

CREATE TABLE orders(
Order_ID int PRIMARY KEY NOT NULL,
Customer_ID int REFERENCES customers(Customer_ID),
Book_ID	 int REFERENCES books(Book_Id),
Order_Date	date ,
Quantity int,
Total_Amount decimal(10,2),
);

--1. Retrieve all the books in fiction genere:
select *
from books
where Genre = 'Fiction'

--2. Find the books published after the year 1950
 select * from books
 where Published_Year > 1950;

 --3. List all the customers from Canada
 select * from customers
 where Country = 'Canada';

 --4. Show order placed in Nov 2023
 select * from orders
 where MONTH(Order_Date) = 11
 AND YEAR(Order_Date) = 2023;

 --5. Retrieve total stock of book available
 select SUM(stock) as total_stock
 from books;

 --6 Find the details of the most expensive book
 select TOP 1 * from books
 ORDER BY Price DESC ;

 --7 Show all the customers who ordered more than 1 quantity of books
 select*from orders
 where Quantity >1;

 --8 Retrieve all the orders where Total_Amount exceeds $20

 select * from orders
 where Total_Amount > 20;

 --9 List all the genres available in the books table

 select distinct Genre from books;

 --10 Find the book with lowest stock

 select TOP 1 * from books
 order by stock;

 --11 Calculate the total revenue generated from all orders

 select sum(Total_Amount) as total_revenue
 from orders;

 --ADVANCED QUESTIONS

 --1 Retrieve total number of books sold for each genre
  
  select books.Genre, sum(orders.quantity) as total_no_of_books
  from books 
  join orders 
  on books.Book_ID = orders.Book_ID
  group by  books.Genre;

  --2 Find the average price of books in fantacy genre
   
   select AVG(Price) AS avg_price
   from books
   where Genre = 'Fantasy';

   --3 List customers who has placed atleast 2 orders

   select c.Name, c.Customer_ID, COUNT(o.Order_ID) as total_orders
   from customers as c
   join orders as o
   on c.Customer_ID = o.Customer_ID
   group by c.Customer_ID, c.Name
  having COUNT( o.Order_ID) >= 2;
  
   --or
   
   select Customer_ID, COUNT(Order_ID) as total_orders
   from orders
   group by Customer_ID
   having COUNT(Order_ID) >=2;

   --4 Find most frequently ordered book

   select TOP 1 Book_ID, COUNT(Order_ID) as frequent_bbok
   from orders
   group by Book_ID
   Order BY frequent_bbok DESC;

   --

   select TOP 1 o.Book_ID, b.Title, COUNT(o.Order_ID) as frequent_bbok
   from orders as o
   JOIN books as b
   on b.Book_ID = o.Book_ID
   group by o.Book_ID, b.Title
   Order BY frequent_bbok DESC;

   --5 Show top 3 most expensive book of Fantasy Genere
   
   select TOP 3 * from  books
   where Genre = 'Fantasy'
   order by Price DESC;

   --6 Retrieve total quantity of books sold by each author

   select  b.Author, SUM(o.Quantity) as total_Quantity
   from books b
   join orders o
   on b.Book_ID = o.Book_ID
   group by b.Author;

   --7 List the cities where customer who spent over $30 are prseent

   select DISTINCT c.City
   FROM customers as c
   join orders as o
   on c.Customer_ID = o.Customer_ID
   where o.Total_Amount > 30;

   --8 Find the customer who spent most on the orders

   select TOP 1 c.Name, c.Customer_ID,SUM( o.Total_Amount) as Total_Spent
   from customers as c
   join orders as o
   on c.Customer_ID = o.Customer_ID
   group by c.Name, c.Customer_ID
   order by Total_Spent DESC;


   --9 Calculate the stock remaining after fulfilling all the order

 select b.Book_ID,b.Title,b.stock, COALESCE(SUM(o.Quantity),0) as Total_quantity,
  b.stock-COALESCE(SUM(o.Quantity),0) as Remaining_quantity
  from books as b
  left join orders as o
  on b.Book_ID = o.Book_ID
  group by b.Book_ID,b.Title,b.stock;
