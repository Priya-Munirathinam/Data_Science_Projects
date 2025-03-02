use modelcarsdb;
/*create view custEmp_profitSales as select c.customerNumber, c.customerName, sum(od.priceEach*od.quantityOrdered)as Total_sales, sum((od.priceEach-p.buyPrice)*od.quantityOrdered)as profit, c.salesRepEmployeeNumber as Rep_Emp_no, concat(e.firstName,' ',e.lastName) as emp_fullName, e.officeCode 
from employees e join customers c join orders o join orderdetails od join products p on 
e.employeeNumber = c.salesRepEmployeeNumber and c.customerNumber = o.customerNumber and o.orderNumber = od.orderNumber and od.productCode = p.productCode group by c.customerNumber;
            -- view is created fro simplification
            -- datas like full name of employee, their No, their office code, their assigned customer no, Name, total sales, profit group by customer No*/
select * from custEmp_profitSales;

--                                        task 1 Customer Data Analysis
-- 1. top 10 customers by credit limit
select * from customers order by creditLimit desc limit 10;
/* top 10 customers having high credit limit belongs to countries like Denmark, Germany,...; 
customer: Euro+ Shopping Channel from Spain has the highest credit limit with 227600;
3 customers from USA are in top 10 list*/ 

-- 2. average credit limit for customers in each country
select country, avg(creditLimit) as Average_credit_limit from customers group by country;
/* Denmark's customers have average credit limit 1lakh above; Norway, France, Italy, Finland, New Zealand has above 90000; 
While Poland has negative credit limit; Portugal, Netherlands, SouthAfrica, Russia, Israel has 0 average credit limit*/

-- 3. no of customers in each state
select state, count(*) as No_of_customers from customers group by state;
/* state is not mentioned for 73 customers; CA has the highest no of customers followed by MA;*/

-- 4. customers who havent ordered
select customerNumber, customerName from customers 
where customerNumber not in (select customerNumber from orders) order by customerNumber; -- 24 customers haven't placed any order.

-- 5. total sales for each customer
select customerNumber, customerName, Total_sales from custEmp_profitSales order by Total_sales desc;
-- Customer No 141 - Euro+ Shopping Channel has done sales for 820689.54 while customer No 219 - Boards & Toys Co. has done lowest purchase of 7918.60

-- 6. customers with their assigned sales representative
select c.customerNumber, c.customerName, c.salesRepEmployeeNumber, e.firstName from customers c inner join employees e 
on c.salesRepEmployeeNumber = e.employeeNumber where c.salesRepEmployeeNumber = e.employeeNumber; 
-- Total of 15 employees assigned for all those customers

-- 7. customer information with most recent payment details
select c.*, p.paymentDate, p.amount from customers c inner join payments p on c.customerNumber = p.customerNumber order by p.paymentDate desc limit 1; 
-- recent order of 46656.94 has been payed on 2005-06-09 by customer No:353 - Reims Collectables from France handled by employee No:1337	

-- 8. customers who have exceeded their credit limit
select c.customerNumber, c.customerName, c.creditLimit, sum(p.amount) as Total_sales from customers c inner join payments p on 
c.customerNumber = p.customerNumber where c.creditLimit < ( select sum(amount) from payments) group by c.customerNumber; 
/* 98 customers exceeded their credit limit; initially 24 customers are dormant; And hence out of 122 customers 
98 who have placed orders all have exceeded their credit limit*/

-- 9 customer names who placed an order for specific product line
select c.customerNumber, c.customerName, p.productLine from customers c inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.orderNumber = od.orderNumber
inner join products p on od.productCode = p.productCode group by c.customerNumber, c.customerName, p.productLine having p.productLine = 'ships'; 
-- can get list for all 7 productLines:  Classic Cars, Motorcycles, Planes, Ships, Trains, Trucks and Buses, Vintage Cars

-- 10. Customer names who place order for expensive product
select c.customerNumber, c.customerName, od.productCode, od.priceEach as Rate from customers c inner join orders o inner join orderdetails od 
on c.customerNumber = o.customerNumber and o.orderNumber = od.orderNumber where od.priceEach = (select max(priceEach) from orderdetails);
-- 3 customers ordered the same product with price 214.30

-- extra queries
-- No sales rep for cust
select customerNumber from customers where salesRepEmployeeNumber is NULL; -- 22 out of 122 customers arent assigned any sales Rep employee
-- sales rep responsible for dormant customers
select customerNumber, customerName, salesRepEmployeeNumber from customers 
where customerNumber not in (select customerNumber from orders) order by customerNumber; 
   -- 2 customers have sales rep employee who hasnt ordered but remaining 22 are the customers who werent assigned any sales rep from before query
-- customers and their region
select country, count(*) as No_of_Customer from customers group by country; -- customers are from 27 countires with 36 from USA; USA, Germany and spain comprises half of the customer population
-- No of orders placed by each customers
select customerNumber, (select customerName from customers where customers.customerNumber= orders.customerNumber) as CustomerName, count(orderNumber) as Count_of_orders from orders group by customerNumber order by Count_of_orders desc;
    -- customer No: 141 has placed 26 orders followed by 124 who placed 17 orders while the lowest no of orders made by customer no 415
-- total amount paid by each customers
select c.customerNumber, c.customerName, sum(p.amount) as Amount_paid from customers c inner join payments p on c.customerNumber = p.customerNumber
group by c.customerNumber order by Amount_paid; 
    -- customer No 141- Euro+ Shopping Channel	has highest order 715738.98, followed by customer No 124- Mini Gifts Distributors Ltd. who paid 584188.24
select customerNumber, customerName, Total_sales from custEmp_profitSales order by Total_sales desc limit 10;
/* summary:
sales: Customer No 141 - Euro+ Shopping Channel has done sales for 820689.54 while customer No 219 - Boards & Toys Co. has done lowest purchase of 7918.60
Credit Limit: customer Euro+ Shopping Channel from Spain has the highest credit limit with 227600
Denmark's customers have average credit limit 1lakh above; Norway, France, Italy, Finland, New Zealand has above 90000; 
While Poland has negative credit limit; Portugal, Netherlands, SouthAfrica, Russia, Israel has 0 average credit limit
98 customers exceeded their credit limit; initially 24 customers are dormant; And hence out of 122 customers 
98 who have placed orders all have exceeded their credit limit
Region: customers are from 27 countires with 36 from USA; USA, Germany and spain comprises half of the customer population
Sales Rep employee: 22 out of 122 customers arent assigned any sales Rep; 
2 customers have sales rep employee who hasnt ordered but remaining 22 are the customers who werent assigned any sales rep
Orders: highest payment of 214.30 by 3 customers for product S10_1949- 1952 Alpine Renault 1300- classic Cars
24 customers haven't placed any order; 2 customers have sales rep employee but hasnt ordered but remaining 22 werent assigned any sales rep
customer No 141- Euro+ Shopping Channel	has highest order 715738.98 followed by customer No 124 Mini Gifts Distributors Ltd. 591827.34
while customer No 219 - Boards & Toys Co. has done lowest purchase of 7918.60
recent order of 46656.94 has been payed on 2005-06-09 by customer Reims Collectables from France;
customer No 141 has placed 26 orders followed by 124 who placed 17 orders while the lowest no of orders made by customer no 415
*/


--                                              task 2 Office Data Analysis
-- 1. No of employees in each office
select officeCode, count(*) as No_of_employees from employees group by officeCode; 
-- office code 1, 4 and 6 has high no of employees while remaining has 2 employees in each

-- 2. offices with less than certain number of employees
select officeCode, count(*) as No_of_employees from employees group by officeCode order by No_of_employees limit 5; 
-- office code 2,3,5,7 all offices has only 2 employees

-- 3. list offices along with their territories
select officeCode, territory from offices; -- offices and the territories are shown

-- 4. office with no employees
select officeCode from employees group by officeCode having count(employeeNumber) = 0; -- there is no office without employees

-- 5. most profitable office based on sales
select officeCode, sum(profit) as Profit from custEmp_profitSales group by officeCode order by Profit desc limit 1; -- used earlier created view; 
-- the office Code of 4 has the highest profit 1237142.31

-- 6. office with highest no of employees
select officeCode from employees group by officeCode order by count(employeeNumber) desc limit 1; -- office code 1 in San Francisco, USA

-- 7. average credit limit for customers in each office
select e.officeCode, avg(c.creditLimit) as Avg_credit_limit from employees e inner join customers c 
on c.salesRepEmployeeNumber = e.employeeNumber group by e.officeCode;
-- Customers handled by employees from office code 6 and 7 has high average credit limit, while from 3 the lowest

-- 8. No of offices in each country
select country, count(*) from offices group by country; -- 3 offices in USA while France, Japan, Australia and UK has each 1 office

-- extra, office details and count of employees in it
select ofc.*, count(e.officeCode) as No_of_employees from offices ofc inner join employees e on ofc.officeCode=e.officeCode group by officeCode;
 -- office code 1 has highest no of employees 6
-- sales made by employees in each office
select officeCode, sum(Total_sales) as totalSales from cust_sales_with_emp group by officeCode order by officeCode; 
    -- office code 4 from Paris made highest sales 3083761.58
-- amount paid by customers to the office
select e.officeCode, sum(pm.amount) as AmountPaid from payments pm join customers c join employees e on pm.customerNumber=c.customerNumber 
and c.salesRepEmployeeNumber = e.employeeNumber group by e.officeCode; 
     -- office code 4 recieved highest amount 2819169 and lowest from office 5 of amount 457110.07
/* summary
employee distribution: office code 1, 4 and 6 has high no of employees while 2,3,5,7 has 2 employees in each;  there is no office without employees
office code 1 in San Fransico has highest no of employees also President, VP, VP marketing all are in office code 1;
Global presence: Offices are in France, UK, Australia, Japan are countries especially 3 are in USA
profit & sales: office code 4 with highest profit 1237142.31 and highest sales 3083761.58 
credit limit: Customers handled by employees from office code 6 and 7 has high average credit limit, while from 3 the lowest
*/

--                                     Task 3 Product Data Analysis
-- 1. No of products in each product line
select productLine, count(productName) as Total_products from products group by productLine; 
-- classic cars and vintage cars have high number of products in it, together comprising more than half of products

-- 2. product line with highest avg product price 
select p.productLine, avg(od.priceEach) as Avg_Price from products p inner join orderdetails od on p.productCode = od.productCode
group by p.productLine order by Avg_Price desc limit 1; -- Average on ordered price is 108
select productLine, avg(MSRP) as Avg_Price from products group by productLine order by Avg_Price desc limit 1; -- Avg on MSRP is 118
select productLine, avg(buyPrice) as Avg_Price from products group by productLine order by Avg_Price desc limit 1; -- Avg on bought price is 64.44
-- here, price for the product are taken from buy price, MSRP and ordered price; in all 3 cases, classic cars has the highest average price

-- 3. Products with price above/below certain value and MSRP between 50 and 100
select productCode, productName, buyPrice, MSRP from products where buyPrice < 60 and MSRP between 50 and 100; 
-- total of 49 products have the range 50 to 100 for MSRP; out of 110 products

-- 4. Total sales for each productline
select p.productLine, sum(od.priceEach*od.quantityOrdered) as Total_sales from products p inner join orderdetails od 
on p.productCode = od.productCode group by p.productLine; 
-- classic cars exceeds all the other product line followed by vintage cars; classic cars sales is doubled the vintage cars

-- 5.product with low inventorylevels
select productCode, productName, quantityInStock from products where quantityInStock < 10; 
-- No product is in a low inventory levels; the minimum stock is for Ford Mustang of classic cars;

-- 6. Most expensive product based on MSRP
select productName, productLine, MSRP from products where MSRP = (select max(MSRP) from products); 
-- 1952 Alpine Renault 1300 of Classic Cars is of MSRP 214.30 being the costliest among all

-- 7. Total sales for each product
select productName, productCode, sum(Total_sales) as Sales_Total from 
(select p.productName, od.productCode, od.quantityOrdered*od.priceEach as Total_sales from orderdetails od join products p 
on od.productCode = p.productCode group by p.productName, od.productCode, od.quantityOrdered*od.priceEach) as T 
group by productCode order by Sales_Total desc; 
/* highest sales of 276839.98 is made from product code: S18_3232- 1992 Ferrari 360 Spider red of Classic Cars
lowest sales of 28052.94 from product of code: S24_1937	1939 - Chevrolet Deluxe Coupe from Vintage Cars*/

-- 8. stored procedure for finding top ordered products
DELIMITER //
CREATE PROCEDURE sp_top_n_prod_based_on_quantity(in in_top_no int)
BEGIN
DECLARE numb int;
select p.productCode, p.productName, od.quantityOrdered from products p inner join orderdetails od 
on p.productCode = od.productCode order by od.quantityOrdered desc limit in_top_no;
END //
CALL sp_top_n_prod_based_on_quantity(7); -- with an input and calling the stored procedure returns the list

select productCode from orderdetails order by quantityOrdered desc limit 7;
select * from products; -- simple query to verify 

-- 9. products with less inventory in Classic cars, Motorcycles
select productCode, productName, productLine, quantityInStock from products 
where quantityInStock < 10 and productLine in ('Motorcycles', 'Classic Cars'); 
-- There are no low inventory products in Classic cars and motorcycles

-- 10. products ordered by more than 10 customers
select p.productCode, p.productName, count(*) as No_Of_customers from products p inner join orderdetails od inner join orders o 
on p.productCode = od.productCode and od.orderNumber = o.orderNumber group by p.productCode, p.productName order by No_Of_customers desc;
-- ALl the products ordered are ordered by more than 10 customers

-- 11. products ordered more than average of orders of their productline
select p.productCode, p.productName, p.productLine, od.quantityOrdered from products p inner join orderdetails od on p.productCode = od.productCode 
where od.quantityOrdered > (select avg(quantityOrdered) from orderdetails) group by p.productCode, p.productName, p.productLine, od.quantityOrdered;
/*990 orders are placed whose quantity ordered are more than the average of orders of their productline 
while remaining 1053 of 2043 orders are below average of orders of their productLine*/

-- extra: products not ordered
select productName, productCode, productLine from products where productCode not in (select productCode from orderdetails);
     -- 1985 Toyota Supra(S18_3233) of Classic Cars is the only product that hasnt been ordered
select quantityInStock from products where productCode = 'S18_3233'; -- a stock of 7733 remains for 1985 Toyota Supra

-- product, buy price, avg of price paid & top 10 and bottom 10 profit each
select p.productName, p.productCode, p.buyPrice, avg(od.priceEach) as AveragePrice,  avg(od.priceEach)-p.buyPrice as AvgProfit from products p join orderdetails od on p.productCode = od.productCode 
group by p.productName, p.productCode, p.buyPrice order by AvgProfit desc limit 10;-- 1952 Alpine Renault 1300 gains an average of profit 98.73 and bottom 10 ranges from 98.73 to 65.90
select p.productName, p.productCode, p.buyPrice, avg(od.priceEach) as AveragePrice,  avg(od.priceEach)-p.buyPrice as AvgProfit from products p join orderdetails od on p.productCode = od.productCode 
group by p.productName, p.productCode, p.buyPrice order by AvgProfit limit 10; -- 1939 Chevrolet Deluxe Coupe gains an average of profit 7.36 and bottom 10 ranges from 7.36 to 16.15


/*summary:
Variants: classic cars and vintage cars have high number of products in it, together comprising more than half of products
Sales:  highest sales of 276839.98 is made from product code: S18_3232- 1992 Ferrari 360 Spider red of Classic Cars
lowest sales of 28052.94 from product of code: S24_1937	1939 - Chevrolet Deluxe Coupe from Vintage Cars 
Profit:  1952 Alpine Renault 1300 gains an average of profit 98.73 and bottom 10 ranges from 98.73 to 65.90
1939 Chevrolet Deluxe Coupe gains an average of profit 7.36 and bottom 10 ranges from 7.36 to 16.15
classic cars sales exceeds all the other product line followed by vintage cars; classic cars sales is doubled the vintage cars
Quantity in stock: No product is in a low inventory levels; the minimum stock is for Ford Mustang of classic cars;
There are no low inventory products in Classic cars and motorcycles
order: ALl the products ordered are ordered by more than 10 customers
990 orders are placed whose quantity ordered are more than the average of orders of their productline 
while remaining 1053 of 2043 orders are below average of orders of their productLine
Price: price for the products given in data are buy price, MSRP and ordered price; in all 3 cases, classic cars has the highest average price
total of 49 products have the range 50 to 100 for MSRP; out of 110 products
1952 Alpine Renault 1300 of Classic Cars is of MSRP 214.30 being the costliest among all
unordered product: 1985 Toyota Supra(S18_3233) of Classic Cars is the only product that hasnt been ordered; a stock of 7733 remains for it
*/
