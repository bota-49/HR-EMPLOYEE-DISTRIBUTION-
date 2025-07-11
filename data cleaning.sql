use projects;

select * from hr;

alter table hr
change column ï»؟id ID varchar(20) null;

describe hr;

select birthdate from hr;

SET sql_safe_updates = 0;

update hr 
set birthdate = case 
	when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d') 
	when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d') 
    else null
end;

alter table hr 
modify column birthdate date;

select birthdate from hr 
where year(birthdate) > year(curdate());

update hr 
set birthdate = date_sub(birthdate,interval 100 year) 
where year(birthdate) > year(curdate());

select birthdate from hr;

select hire_date from hr;

update hr 
set hire_date = case 
	when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d') 
	when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d') 
    else null
end;

select hire_date from hr;
alter table hr 
modify column hire_date date;

select termdate from hr;

UPDATE hr
SET termdate = DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';

UPDATE hr
SET termdate = null
WHERE termdate IS NULL OR termdate = '';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;
select termdate from hr;

alter table hr add column age int;

update hr 
set age = timestampdiff(year,birthdate, curdate());
select age from hr;

select 
	max(age) as oldest,
    min(age) as youngest
from hr;

select count(*) from hr where age <18;
select count(*) from hr where termdate <curdate();
select count(*) from hr where termdate = '0000-00-00';

select location from hr;



















