use hr;

-- task1 emp id, first and last name for it dept emp
select e.employee_id, e.first_name, e.last_name from employees e
inner join departments d on e.department_id = d.department_id where d.department_name='IT';

-- task 2 max salary in each department
select d.department_name, max(e.Salary) as 'Max salary' from employees e 
inner join departments d on e.department_id = d.department_id group by d.department_name;

-- task 3 top cities with highest no of employees
select locations.City, count(employees.employee_id) as 'Number_of' from employees inner join departments inner join locations on 
employees.department_id = departments.department_id and departments.location_id = locations.location_id 
group by locations.City order by Number_of desc;

-- task 4 empl whose end date is 1999-12-31
select e.employee_id, e.first_name, e.last_name from employees e
inner join job_history j on e.employee_id = j.employee_id where j.end_date = '1999--12-31';

-- task 5 emps with more than 25 years exp
select e.employee_id, e.first_name, d.department_name, year(curdate())-year(e.hire_date) as 'Experience' from employees e
inner join departments d on e.department_id = d.department_id where year(curdate())-year(e.hire_date) >= 25;

-- extra calc
select * from employees;
select * from departments;
select * from locations;
select * from job_history;
select count(location_id) from locations; -- 23
select location_id, count(location_id) from departments group by location_id; -- gives 7 rows
select department_id from employees group by department_id; -- 10 to 110
-- end of calc