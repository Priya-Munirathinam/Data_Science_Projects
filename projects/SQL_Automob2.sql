use modelcarsdb;
--                                           task 1 Employee data Analysis
-- 1. total number of employees
select count(*) as Total_Employees from employees; -- Total of 23 employees
-- 2. List employees with basic information
select employeeNumber, concat(firstName, ' ',lastName) as FullName, jobTitle, reportsTo, officeCode from employees; -- Employees information are shown
-- 3.No of employees with each job title
select jobTitle, count(*) from employees group by jobTitle; -- 17 sales Representative, 3 Manager, 1 VP marketing, 1 VP and 1 president
-- 4. employees who dont have manager 
select employeeNumber, concat(firstName, ' ',lastName) as FullName, jobTitle from employees where reportsTo is NULL; -- President is the only employee who doesnt report to anyone
-- 5. Total sales by each representative
select Rep_Emp_nO as Emp_NO, emp_fullName, sum(Total_sales) as totalSales from custEmp_profitSales group by Emp_NO, emp_fullName, emp_fullName;
--  total sales = qty ordered * price each taken from earlier created view custEmp_profitSales
-- Employee No 1370- Gerard Hernandez made highest sal of 1258577.81, while	Martin Gerard made the lowest 387477.47

-- 6. most profitable sales rep based on total sales
select Rep_Emp_no, emp_fullName, profit as max_profit from custEmp_profitSales where profit = (select max(profit) from custEmp_profitSales);
-- The employee whose number is 1370 earns highest profit of 326519.66; 
-- view is used here

-- 7. employees who sold more than the average of total sales
select Rep_Emp_no, emp_fullName, sum(Total_sales) as TotalSale from custEmp_profitSales group by Rep_Emp_no, emp_fullName having TotalSale > (select avg(TotalSales) 
from (select Rep_Emp_no, sum(Total_sales) as TotalSales from custEmp_profitSales group by Rep_Emp_no) as v); -- average sales of employees is 640279
  -- 6 employees have made sales more than the average while the reamining 9 sales employees have made less than average sales

-- extra
-- No of employees in each country
select o.country, count(*) as No_of_office from offices o inner join employees e on o.officeCode = e.officeCode group by o.country; 
    -- USA has highest of 10 employees while UK having lowest of 2 employees
-- employee doesnt have customers assigned
select employeeNumber, firstName, jobTitle from employees 
where employeeNumber not in (select salesRepEmployeeNumber from customers where  employeeNumber=salesRepEmployeeNumber) order by employeeNumber; 
    -- 2 sales rep doesnt have customers assigned while rest are President, 2 VPs and 3 managers
-- employees handling no of customers
select salesRepEmployeeNumber, count(customerNumber) as Handling_cust from customers group by salesRepEmployeeNumber order by Handling_cust desc; 
    -- employee Number 1401 handles 10 customers and the rest all employees handle a minimum of 5 customers each; 15 out of 23 employees handle customers
    -- 22 customers with no rep employee asigned some have made no purchase
/* Summary:
Distribution: Total of 23 employees: 17 sales Representative, 3 Manager, 1 VP marketing, 1 VP and 1 president
Customer Employee relation: 22 customers with no rep employee asigned some have made no purchase; 
2 sales rep doesnt have customers assigned while rest 6 are President, VP and managers; A total of 8 employees doesnt handle customers
employee Number 1401 handles 10 customers and the rest all employees handle a minimum of 5 customers each; 15 out of 23 employees handle customers
Sales: Gerard Hernandez made highest sal of 1258577.81, while	Martin Gerard made the lowest 387477.47
6 employees have made sales more than the average while the reamining 9 sales employees have made less than average sale
Managed by: President is the only employee who doesnt report to anyone; every other sales rep comes under manager
*/

--                            task 2. Order Analysis
-- 1. average order amount for each cuctomer
select customerNumber, customerName, avg(Total_sales) as Avg_total from custEmp_profitSales group by customerNumber, customerName; -- average sales from each customer 
-- customer: Euro+ Shopping Channel highest average 820690 while Boards & Toys Co. has lowest 7918.600000

-- 2.  No of orders placed in month
select month(orderDate), count(*) as No_of_orders from orders group by month(orderDate);
 -- highest number of 63 orders were made in december while lowest of 17 in august while the rest of months ranges in 20s
 
-- 3. orders that are still pending
select orderNumber from orders where status = 'Pending'; -- no orders are pending
-- 4. list orders along with customers
select o.orderNumber, o.customerNumber, c.customerName, c.phone, c.addressLine1, c.city, c.country, o.orderDate, o.status, o.shippedDate from orders o join customers c on c.customerNumber = o.customerNumber order by orderNumber; -- customer and their orders are shown
-- 5. Retieve most recent order based on order date
select * from orders order by orderDate desc limit 1; 
-- most recent order has been plced on 2005-05-31 by customer No 141 but the status is still in progress 
-- 6. total sales for each order
select orderNumber, sum(Sales) as Total_sales from (select orderNumber, priceEach*quantityOrdered as Sales from orderdetails 
group by orderNumber, priceEach*quantityOrdered) as C group by orderNumber ;
-- highest sales of 67400 from order 10165 and lowest sales from order 10408 of 615

-- 7. highest value order based on total sales
select orderNumber, sum(Sales) as Total_sales from (select orderNumber, priceEach*quantityOrdered as Sales from orderdetails 
group by orderNumber, priceEach*quantityOrdered) as C group by orderNumber order by Total_sales desc limit 1;
-- highest sales of 67400 from order 10165; 

-- 8. orders with their corresponding order details
select * from orders natural join orderdetails order by orderNumber; -- order and its details are shown
-- 9. most frequently ordered products
select p.productCode, p.productName, p.productLine, count(od.productCode) as quantity_ordered from products p inner join orderdetails od 
on p.productCode = od.productCode group by  p.productCode, p.productName, p.productLine order by quantity_ordered desc limit 1; 
-- 1992 Ferrari 360 Spider red of Classic Cars is frequently ordere, a total of 53 ordered

-- 10. total revenue for each order; revenue = quantity ordered * price per unit
select orderNumber, productCode, quantityOrdered*priceEach as Revenue from orderdetails 
group by orderNumber, productCode, quantityOrdered*priceEach order by Revenue desc; 
-- highest Revenue of 11503 of order number 10403 and the product code S10_4698 while lowest revenue of 481 from order no 10419(S24_2972)

-- 11. most profitable orders based on total revenue
select od.orderNumber, od.productCode, p.productName, p.productLine, od.quantityOrdered*(od.priceEach-p.buyPrice) as profit_revenue from orderdetails od inner join products p on p.productCode= od.productCode
group by od.orderNumber, p.productCode, p.productName, p.productLine, od.quantityOrdered*(od.priceEach-p.buyPrice) order by profit_revenue desc limit 1;
/*The product 1952 Alpine Renault 1300	of Classic Cars	has made profit of revenue 5554.56 from the order number 10312; 
while 1939 Chevrolet Deluxe Coupe of Vintage Cars made lowest of 79.60
revenue here is calculated by quantityOrdered*(priceEach-buyPrice)*/

-- 12. list all orders with detailed product inf
select * from orderdetails natural join products natural join productlines; -- orderdetailis along with product details is displayed
-- 13. orders with delayed shipping
select orderNumber, shippedDate, requiredDate from orders where shippedDate > requiredDate; -- only 1 order of number 10165 is delayed

-- 14. most popular product combination within orders --- ??????
select prodCodes, count(*) as occurs from (select orderNumber, group_concat(productCode) as prodCodes
from orderdetails group by orderNumber) as P group by prodCodes order by occurs desc;
-- S10_4757,S18_1662,S18_3029,S18_3856,S24_2841,S24_3420,S24_3816,S700_2047,S72_1253 are the combination of productcodes that are ordered 4 times
select productName from products where productCode in ('S10_4757', 'S18_1662', 'S18_3029', 'S18_3856', 'S24_2841', 'S24_3420', 'S24_3816', 'S700_2047', 'S72_1253');
-- or 
select od1.productcode as p1,od2.productcode as p2
FROM orderdetails AS od1
JOIN orderdetails AS od2 ON od1.orderNumber = od2.orderNumber 
where od1.productCode < od2.productCode;

-- 15. revenue for each product and identify the top 10 most profitable
select od.productCode, p.productName, od.quantityOrdered*od.priceEach as Revenue, od.quantityOrdered*(od.priceEach-p.buyPrice) as profit_revenue from products p 
inner join orderdetails od on p.productCode = od.productCode order by profit_revenue desc limit 10;
-- product 1952 Alpine Renault 1300	 yields revenue 10286.40 of profit 5554.56; Revenue and profit revenue is listed along
-- revenue here is calculated by quantityOrdered*(priceEach-buyPrice); revenue is quantityOrdered*(priceEach)

-- 16. trigger that updates customers credit limit after new order is placed, by reducing it with total order
DELIMITER $$
USE `modelcarsdb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `modelcarsdb`.`climit_after_od_update` AFTER INSERT ON `orderdetails` FOR EACH ROW
BEGIN
declare custNo int;
select customerNumber into custNo from orders where orderNumber = new.orderNumber;
update customers set creditLimit = creditLimit - (new.quantityOrdered*new.priceEach) where customerNumber = custNo;
END$$
DELIMITER ;
/*Trigger is created on orderdetails, whenever new record is inserted in orderdetails after orders table, 
an update is made on credit limit for the ordered customer on customers table*/

-- 17. trigger that logs product quantity changes whenever order detail in inserted or updated 
create table product_quantity_log(orderLogId int primary key auto_increment, orderNo int, prodcode varchar(20), quantityChange int, dateOrdered date);
DELIMITER $$
CREATE TRIGGER `log_product_update`
AFTER INSERT ON `orderdetails`
FOR EACH ROW 
BEGIN
insert into product_quantity_log(orderNo, prodcode, quantityChange, dateOrdered)
values(new.orderNumber, new.productCode, new.quantityOrdered, curdate());
END; $$
-- trigger to enter new order quantity for each product in log table

/*drop trigger log_product_update;

update customers set creditLimit = 5000 where customerNumber in (125, 168);
update customers set creditLimit = 0 where customerNumber in (125, 168);

insert into orders values(10426, '2003-01-06', '2003-01-13', '2003-01-11', 'Shipped',  null, 125);
insert into orderdetails(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber) values (10426, 'S18_1749', 3, 55.00, 3);

insert into orders values(10427, '2003-01-06', '2003-01-13', '2003-01-11', 'Shipped',  null, 125);
insert into orderdetails(orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber) values (10427, 'S18_1749', 13, 55.00, 3);

delete from orders where orderNumber in (10426, 10427);
delete from orderdetails where orderNumber in (10426, 10427);*/

-- extra
-- order status
select status, count(*) as Total from orders group by status; -- most orders are shipped while 6 cancelled & 4 on hold; 
-- product & quantity ordered top & bottom 10
select p.productName, sum(od.quantityOrdered) as totalQuantityOrdered from products p join orderdetails od on p.productCode=od.productCode 
group by p.productName order by totalQuantityOrdered limit 10; -- 1957 Ford Thunderbird is of lowest quantity ordered  767 & range of bottom 10 is 767 to 880
select p.productName, sum(od.quantityOrdered) as totalQuantityOrdered from products p join orderdetails od on p.productCode=od.productCode 
group by p.productName order by totalQuantityOrdered desc limit 10; --  1992 Ferrari 360 Spider red is of highest quantity ordered 1808 & range of top 10 is 1808 to 1052
-- productline preference
select p.productLine, count(od.orderNumber) as TotalOrder from products p join orderdetails od on p.productCode = od.productCode group by p.productLine;
   -- classic cars has been placed 1010 orders while the lowest is trains with only 81
-- top & bottom 10 order wise sales
select orderNumber, sum(priceEach*quantityOrdered) as Amount from orderdetails group by orderNumber order by Amount desc limit 10; -- highest order of 67392.85 in order No.10165 
select orderNumber, sum(priceEach*quantityOrdered) as Amount from orderdetails group by orderNumber order by Amount limit 10; -- highest order of 615.45 in order No.10408  

/* Summary:
customer No 239 made higghest average order of amount 80th above while customer No 219 made the lowest average order around 4th
sales from orders: highest sales of 67400 from order 10165 and lowest sales from order 10408 of 615
orders: highest number of 63 orders were made in december while lowest of 17 in august while the rest of months ranges in 20s
classic cars has been placed 1010 orders while the lowest is trains with only 81
1992 Ferrari 360 Spider red of Classic Cars is frequently ordere, a total of 53 ordered
most orders are shipped while 6 cancelled & 4 on hold
no orders are pending; only 1 order of number 10165 is delayed
most recent order has been plced on 2005-05-31 by customer No 141 but the status is still in progress 
Revenue: revenue here is calculated by quantityOrdered*(priceEach-buyPrice); revenue is quantityOrdered*(priceEach)
highest Revenue of 11503 of order number 10403 while lowest revenue of 481 from order no 10419
The product 1952 Alpine Renault 1300	of Classic Cars	has made profit of revenue 5554.56 from the order number 10312; 
while 1939 Chevrolet Deluxe Coupe of Vintage Cars made lowest of 79.60
*/

