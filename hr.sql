-- join8
select *
from countries ;

select *
from regions;

SELECT r.region_id, r.region_name, c.country_name
FROM countries c, regions r
WHERE r.region_id = 1 AND c.region_id = r.region_id;

SELECT r.region_id, r.region_name, c.country_name
FROM countries c JOIN regions r ON r.region_id = 1 AND c.region_id = r.region_id ;

-- join9
select *
from countries ;

select *
from regions;

select *
from locations;

SELECT r.region_id, r.region_name, c.country_name, l.city
FROM countries c, regions r, locations l
WHERE r.region_id = 1 AND r.region_id = c.region_id AND c.country_id = l.country_id;

SELECT r.region_id, r.region_name, c.country_name, l.city
FROM (countries c JOIN regions r ON c.region_id = r.region_id) JOIN locations l ON c.country_id = l.country_id AND r.region_id = '1';

-- join 10
select *
from countries ;

select *
from regions;

select *
from locations;

select *
from departments;

SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM countries c, regions r, locations l, departments d 
WHERE r.region_id = 1 AND r.region_id = c.region_id AND c.country_id = l.country_id AND d.location_id = l.location_id;

SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name
FROM ((countries c JOIN regions r ON c.region_id = r.region_id) JOIN locations l ON c.country_id = l.country_id) JOIN departments d ON l.location_id = d.location_id AND r.region_id = 1;

-- join 11
select *
from countries ;

select *
from regions;

select *
from locations;

select *
from departments;

select *
from employees;

SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name, (e.first_name || e.last_name) name 
FROM countries c, regions r, locations l, departments d, employees e
WHERE r.region_id = 1 AND r.region_id = c.region_id AND c.country_id = l.country_id AND d.location_id = l.location_id AND e.department_id = d.department_id;

SELECT r.region_id, r.region_name, c.country_name, l.city, d.department_name, (e.first_name || e.last_name) name 
FROM (((countries c JOIN regions r ON c.region_id = r.region_id) JOIN locations l ON c.country_id = l.country_id) JOIN departments d ON l.location_id = d.location_id) JOIN employees e ON d.department_id = e.department_id AND r.region_id = 1;

-- join 12
select *
from employees;
select *
from jobs;

SELECT e.employee_id, (e.first_name || e.last_name) name, j.job_id, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id;

-- join 13
SELECT e.manager_id mgr_id, (e.first_name || e.last_name) mgr_name, e.employee_id, (e.first_name || e.last_name) name, e.job_id, j.job_title
FROM employees e, employees m, jobs j
WHERE e.job_id = j.job_id AND e.employee_id = m.manager_id AND e.manager_id IS NOT NULL;