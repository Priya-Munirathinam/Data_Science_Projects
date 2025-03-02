use librarydb;

-- task 1 recieve age as para & returns popular books
DELIMITER //
CREATE PROCEDURE sp_top_books_for_age(in p_age_group varchar(20))
BEGIN
select bk.title, bk.author, count(*) as borrows from books bk 
inner join loans ln inner join borrowers bw on 
bk.book_id = ln.book_id and ln.borrower_id = bw.borrower_id 
where bw.age_group = p_age_group group by bk.title, bk.author order by borrows desc;
END //

CALL sp_top_books_for_age('Adults (25-64)');


-- task 2 no of loans for each month in the given year 
DELIMITER //
CREATE PROCEDURE sp_get_loans_per_month(in p_year year)
BEGIN
select month(loan_date) as 'Month_no', count(loan_id) as 'Total_loans' from loans where year(loan_date)=p_year group by Month_no;
END //

CALL sp_get_loans_per_month('2024');


-- task 3 new record to loans table
DELIMITER //
CREATE PROCEDURE sp_new_entry_to_loan(in p_book_id int, in p_borrower_id int)
BEGIN
insert into loans(book_id, borrower_id, loan_date)
values(p_book_id, p_borrower_id, curdate());
END //

CALL sp_new_entry_to_loan(4,3);

-- task 4 update return date to current date for passed loan id
DELIMITER //
CREATE PROCEDURE sp_update_return_date(in p_loan_id int)
BEGIN
update loans set return_date = curdate() where loan_id = p_loan_id;
END //

CALL sp_update_return_date(6);


-- task 5 update borrowers table with id
DELIMITER //
CREATE PROCEDURE sp_update_borrower_by_id(in p_borrower_id int, in p_name varchar(50), in p_email varchar(50))
BEGIN 
update borrowers set name = p_name, email = p_email where borrower_id = p_borrower_id;
END //

CALL sp_update_borrower_by_id(10, 'Laura Anderson', 'l@ur@anders0n@mail.com'); 

-- task 6 eligible or not eligible based on count of overdue
DELIMITER //
CREATE PROCEDURE sp_is_borrower_eligible(in in_borrower_id int, out out_overdue_count int, out out_is_eligible varchar(20))
BEGIN
select count(*) into out_overdue_count from loans where borrower_id = in_borrower_id and return_date is NULL;
if out_overdue_count > 0 then
 set out_is_eligible = 'Not Eligible';
else
 set out_is_eligible = 'Eligible'; 
end if;
END //

DELIMITER //
CREATE PROCEDURE sp_call_borrower_eligible(in in_borrower_id int)
BEGIN 
DECLARE overdue_count int;
DECLARE is_eligible varchar(20);
CALL sp_is_borrower_eligible(in_borrower_id, @overdue_count, @is_eligible);
select concat ('Total count of overdue is ', @overdue_count, ' so,the borrower is ', @is_eligible) as 'Response';
END //

CALL sp_call_borrower_eligible(4);



