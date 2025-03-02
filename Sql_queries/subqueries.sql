use hr;

-- task 1 fetch details from 2 tables --> non correlated subquery, both are independent with 1 common column
select employee_id, first_name, last_name, (select department_name from departments where employees.department_id=departments.department_id) from employees;

-- task 2 fetch details of emp whose salary > than avg of all
select e.first_name, e.last_name, e.salary, e.department_id from employees e where salary > 
(select avg(salary) from employees) group by e.department_id, e.first_name, e.last_name, e.salary; -- 

-- task 3 --> details of sales employees whose salary < than average of their dept salary
select first_name, last_name, salary, department_id from employees 
where salary < (select avg(salary) from employees where department_id in (select department_id from departments where department_name like '%Sales%'))
and department_id in (select department_id from departments where department_name like '%Sales%');

--  task 4 --> all salary greater than of IT dept
select first_name, last_name, salary from employees where salary > all (select salary from employees where job_id = 'IT_PROG') order by salary;

-- task 5 --> records of employee with min salary grouped by job-id
select * from employees where salary in (select min(salary) from employees group by job_id) order by salary;

-- task 6 --> details of emp whose salary > 60% of sum of salary
select e.first_name, e.last_name, e.department_id as dept, e.salary from employees as e 
where salary > (select sum(salary)*0.6 from employees as el where el.department_id = e.department_id);


-- task 7 first name, last name under UK
select first_name, last_name from employees where department_id in 
(select department_id from departments where location_id in 
(select location_id from locations where country_id in 
(select country_id from countries where country_name = 'United Kingdom')));

-- task 8 data export
(select first_name, last_name, salary from employees order by salary desc limit 6)
INTO OUTFILE
'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\TopSalary.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
