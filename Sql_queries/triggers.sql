use ecoomerceinvdb;

-- task 1
DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `ecommerceinvdb`.`before_insert_order` BEFORE INSERT ON `order_items` FOR EACH ROW
BEGIN
declare current_stock int;
select stock_level into current_stock from products where product_id = new.product_id;
if new.quantity <= 0 or current_stock < new.quantity then
 signal sqlstate '43000' set message_text = 'Negative quantity order or insufficient stock';
 end if;
END$$
DELIMITER ;
-- insert
insert into order_items(order_id, product_id, quantity) values (1,3,0);
insert into order_items(order_id, product_id, quantity) values (1,3,-1);


-- Task 2 add column and create table daily sales; trigger
alter table orders add column total_amount decimal(10,2);
-- update total amount to be 0
update orders set total_amount = 0 where order_id = 1;
update orders set total_amount = 0 where order_id = 2;
update orders set total_amount = 0 where order_id =3 ;
update orders set total_amount = 0 where order_id = 4;
update orders set total_amount = 0 where order_id = 5;
update orders set total_amount = 0 where order_id = 6 ;
update orders set total_amount = 0 where order_id = 7;
update orders set total_amount = 0 where order_id = 8;
update orders set total_amount = 0 where order_id = 9;
update orders set total_amount = 0 where order_id = 10;
update orders set total_amount = 0 where order_id = 11;
-- create dail_sales table
create table daily_sales( Id int primary key auto_increment, sales_date date, total_sales decimal(10,2));
-- trigger
DELIMITER $$
CREATE DEFINER = CURRENT_USER TRIGGER `ecommerceinvdb`.`calc_total_amount_into_daily` AFTER INSERT ON `order_items` FOR EACH ROW
BEGIN
 declare unit_price decimal(10,2);
 declare amount decimal(10,2);
 select price into unit_price from products where product_id = new.product_id;
 update orders set total_amount = total_amount + (new.quantity * unit_price) 
 where order_id = new.order_id and status like 'placed';
 select total_amount into amount from orders where order_id = new.order_id;
 insert into daily_sales (sales_date, total_sales) 
 values (curdate(), amount);
END$$
DELIMITER ;
-- insert
insert into order_items (order_id, product_id, quantity) values(10, 1, 2);