use projects;
select * FROM HR;

-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?

select gender, count(*) as count from hr 
where termdate is null
group by gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?

select race, count(*) as count from hr 
where termdate is null
group by race
order by count(*) desc;

-- 3. What is the age distribution of employees in the company?

select 
	max(age) as oldest,
    min(age) as youngest
from hr;
select case 
	WHEN AGE >= 18 AND AGE <=24 THEN '18-24'
	WHEN AGE >= 25 AND AGE <=34 THEN '25-34'
	WHEN AGE >= 35 AND AGE <=44 THEN '35-44'
	WHEN AGE >= 45 AND AGE <=54 THEN '45-54'
	WHEN AGE >= 55 AND AGE <=64 THEN '55-64'
    ELSE '+64'
end as age_group,gender,
count(*) as count from hr
group by age_group,gender
order by age_group,gender;


-- 4. How many employees work at headquarters versus remote locations?

select location, count(*) as count from hr
group by location; 

-- 5. What is the average length of employment for employees who have been terminated?

SELECT ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr
WHERE termdate <= CURDATE() ;

-- 6. How does the gender distribution vary across departments and job titles?

SELECT department, gender, COUNT(*) as count
FROM hr
GROUP BY department, gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?

SELECT jobtitle, COUNT(*) as count
FROM hr
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?

SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate is null THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate is null THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr
GROUP BY department
ORDER BY termination_rate DESC;

-- 9. What is the distribution of employees across locations by city and state?

SELECT location_state, COUNT(*) as count
FROM hr
GROUP BY location_state
ORDER BY count DESC;


-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate is null AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate is null  AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate is null  AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM hr
GROUP BY YEAR(hire_date)
ORDER BY YEAR(hire_date) ASC;

-- 11. What is the tenure distribution for each department?

SELECT year, hires, terminations, (hires - terminations) AS net_change,
    ROUND(((hires - terminations) / hires * 100), 2) AS net_change_percent
FROM (
    SELECT YEAR(hire_date) AS year, COUNT(*) AS hires, 
        SUM(CASE WHEN termdate is null AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM hr
    GROUP BY YEAR(hire_date)
) subquery
ORDER BY year ASC;
