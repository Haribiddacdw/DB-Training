-- Q1Write a SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy
SELECT SUM(SALARY) FROM EMPLOYEE_TABLE
JOIN DEPARTMENTS ON EMPLOYEE_TABLE.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID WHERE CITY = 'Toronto' and FIRST_NAME NOT LIKE('Nancy');




--Q2.Fetch all details of employees who has salary more than the avg salary by each department.
SELECT E.FIRST_NAME , E.LAST_NAME , E.SALARY ,E.DEPARTMENT_ID ,ROUND(E1.SALARY,2) AS AVERAGE_SALARY FROM EMPLOYEE_TABLE E JOIN 
(SELECT EMP.DEPARTMENT_ID ,AVG(SALARY) AS SALARY FROM EMPLOYEE_TABLE EMP GROUP BY EMP.DEPARTMENT_ID) E1
ON (E.DEPARTMENT_ID = E1.DEPARTMENT_ID AND E.SALARY > E1.SALARY ) 
ORDER BY E.SALARY;




--Q3.Write a SQL query to find the number of employees and its location whose salary is greater than or equal to 70000 and less than 100000
SELECT L.CITY, COUNT(E.EMPLOYEE_ID) AS num_employees
FROM LOCATIONS L
INNER JOIN DEPARTMENTS D ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN EMPLOYEE_TABLE E ON d.department_id = E.DEPARTMENT_ID
WHERE E.SALARY >= 7000 AND E.SALARY < 10000
GROUP BY L.CITY;


//review comment query
SELECT  CITY, MIN_SALARY_TABLE.SALARY,EMPLOYEE_ID FROM EMPLOYEE_TABLE 
JOIN (SELECT L.CITY, MIN(SALARY) AS SALARY 
FROM LOCATIONS L
INNER JOIN DEPARTMENTS D ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN EMPLOYEE_TABLE E ON d.department_id = E.DEPARTMENT_ID
GROUP BY L.CITY) MIN_SALARY_TABLE ON EMPLOYEE_TABLE.SALARY = MIN_SALARY_TABLE.SALARY
ORDER BY MIN_SALARY_TABLE.SALARY;


--Q4 Fetch max salary, min salary and avg salary by job and department. 
--Info:  grouped by department id and job id ordered by department id and max salary

SELECT DEPARTMENT_ID,JOB_ID ,MAX(SALARY) AS MAX_SALARY, MIN(SALARY) AS MIN_SALARY, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEE_TABLE
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY DEPARTMENT_ID,MAX(SALARY) DESC;

--Q5.Write a SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy
SELECT SUM(SALARY) AS TOTAL_SALARY FROM EMPLOYEE_TABLE
JOIN DEPARTMENTS ON EMPLOYEE_TABLE.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID 
JOIN COUNTRIES ON LOCATIONS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
WHERE COUNTRIES.COUNTRY_ID = 'US' and FIRST_NAME NOT LIKE('Nancy');

--Q6.Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department.
SELECT FIRST_NAME,JOB_ID,DEPARTMENT_ID,MAX(salary) AS max_salary, MIN(salary) AS min_salary, AVG(salary) AS avg_salary
FROM EMPLOYEE_TABLE WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID
    FROM EMPLOYEE_TABLE 
    GROUP BY DEPARTMENT_ID 
    HAVING COUNT(DISTINCT job_id) > 1
) 
GROUP BY JOB_ID,DEPARTMENT_ID,FIRST_NAME
ORDER BY FIRST_NAME
;




--Q7.Display the employee count in each department and also in the same result.Info: * the total employee count categorized as "Total" the null department count categorized as "-"

SELECT TO_CHAR(DEPARTMENT_ID)  AS DEPT_ID, COUNT(*) AS COUNT_IN_EACH_DEPT  FROM EMPLOYEE_TABLE
GROUP BY DEPARTMENT_ID HAVING DEPARTMENT_ID IS NOT NULL
UNION 
SELECT 'TOTAL', COUNT(*) FROM EMPLOYEE_TABLE
UNION
SELECT '-' , COUNT(*) FROM EMPLOYEE_TABLE WHERE DEPARTMENT_ID IS NULL;


--Q8.Display the jobs held and the employee count.

-- Hint: every employee is part of at least 1 job
-- Hint: use the previous questions answer
-- Sample
-- JobsHeld EmpCount
-- 1 100
-- 2 4

SELECT CNT,COUNT(CNT) AS EMPLOYEE_COUNT FROM
(
(SELECT EMPLOYEE_ID,COUNT(EMPLOYEE_ID) AS CNT FROM JOB_HISTORY GROUP BY EMPLOYEE_ID)
UNION 
(SELECT EMPLOYEE_ID,COUNT(EMPLOYEE_ID) AS CNT FROM EMPLOYEE_TABLE GROUP BY EMPLOYEE_ID ORDER BY EMPLOYEE_ID)
)
GROUP BY CNT;


//Q9.Display average salary by department and country

SELECT D.DEPARTMENT_NAME, L.COUNTRY_ID, AVG(E.SALARY) AS AVERAGE_SALARY
FROM EMPLOYEE_TABLE E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID 
GROUP BY D.DEPARTMENT_NAME,L.COUNTRY_ID;


//Q10.Display manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country

SELECT C.COUNTRY_NAME,M.FIRST_NAME AS manager_name, COUNT(*) AS employee_count
FROM EMPLOYEE_TABLE E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID
JOIN EMPLOYEE_TABLE M ON E.MANAGER_ID = M.EMPLOYEE_ID
GROUP BY C.COUNTRY_NAME, M.FIRST_NAME;


-- Q11.Group salaries of employees in 4 buckets eg: 0-10000, 10000-20000,.. (Like the previous question) but now group by department and categorize it like below.
-- Eg :
-- DEPT ID 0-10000 10000-20000
-- 50 2 10
-- 60 6 5

SELECT DEPARTMENT_ID,
       SUM(CASE WHEN E.SALARY >= 0 AND E.SALARY < 10000 THEN 1 ELSE 0 END) as "0-10000",
       SUM(CASE WHEN E.SALARY >= 10000 AND E.SALARY < 20000 THEN 1 ELSE 0 END) as "10000-20000",
       SUM(CASE WHEN E.SALARY >= 20000 AND E.SALARY < 30000 THEN 1 ELSE 0 END) as "20000-30000",
       SUM(CASE WHEN E.SALARY >= 30000 THEN 1 ELSE 0 END) AS "ABOVE 30000"
FROM EMPLOYEE_TABLE E
GROUP BY DEPARTMENT_ID;

-- Q12.Display employee count by country and the avg salary
-- Eg :
-- Emp Count Country Avg Salary
-- 10 Germany 34242.8
SELECT COUNT(EMPLOYEE_ID) AS EMPLOYEE_COUNT ,COUNTRIES.COUNTRY_NAME, AVG(SALARY) FROM EMPLOYEE_TABLE 
JOIN DEPARTMENTS ON DEPARTMENTS.DEPARTMENT_ID = EMPLOYEE_TABLE.DEPARTMENT_ID
JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID 
JOIN COUNTRIES ON LOCATIONS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
GROUP BY COUNTRIES.COUNTRY_NAME;


--Q13.Display region and the number off employees by department

-- Eg :
-- Dept ID America Europe Asia
-- 10 22 - -
-- 40 - 34 -
-- (Please put "-" instead of leaving it NULL or Empty)

select * from(
select EMPLOYEE_TABLE.department_id,regions.region_name as region, count(countries.region_id) as count_of from EMPLOYEE_TABLE
 join 
departments on EMPLOYEE_TABLE.DEPARTMENT_ID=departments.department_id
 join 
locations on locations.location_id=departments.location_id
 join
countries on countries.country_id=locations.country_id
 join 
regions on regions.region_id=countries.region_id
group by EMPLOYEE_TABLE.department_id , regions.region_name)
as datas
PIVOT (
  SUM(count_of)
  FOR region
  IN ('Americas', 'Europe','Middle East and Africa')
) AS PivotTable
;



--14.Select the list of all employees who work either for one or more departments or have not yet joined / allocated to any department

SELECT EMPLOYEE_ID FROM EMPLOYEE_TABLE E
JOIN DEPARTMENTS D
ON E.DEPARTMENT_ID= D.DEPARTMENT_ID
WHERE D.DEPARTMENT_ID IS NULL OR E.DEPARTMENT_ID IS NOT NULL;



--Q15write a SQL query to find the employees and their respective managers. Return the first name, last name of the employees and their managers

SELECT E.FIRST_NAME AS "Employee Name", M.FIRST_NAME AS "Manager" FROM EMPLOYEE_TABLE E 
JOIN EMPLOYEE_TABLE M
ON E.MANAGER_ID = M.EMPLOYEE_ID

;

-- Q16write a SQL query to display the department name, city, and state province for each department.

SELECT DEPARTMENT_NAME,CITY,STATE_PROVINCE FROM DEPARTMENTS JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID;

-- Q17write a SQL query to list the employees (first_name , last_name, department_name) who belong to a department or don't


SELECT e.first_name, e.last_name, d.department_name
FROM EMPLOYEE_TABLE e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name is not NULL OR d.department_name IS NULL;

SELECT * FROM EMPLOYEE_TABLE;

--Q18.The HR decides to make an analysis of the employees working in every department. Help him to determine the salary given in average per department and the total number of employees working in a department. List the above along with the department id, department name
SELECT DEPARTMENTS.DEPARTMENT_ID, DEPARTMENTS.DEPARTMENT_NAME, 
round(AVG(EMPLOYEE_TABLE.SALARY),0) AS AVERAGE_SALARY, COUNT(*) AS TOTAL_EMPLOYEES
FROM DEPARTMENTS 
JOIN EMPLOYEE_TABLE ON DEPARTMENTS.DEPARTMENT_ID = EMPLOYEE_TABLE.department_id
GROUP BY DEPARTMENTS.DEPARTMENT_ID, DEPARTMENTS.DEPARTMENT_NAME;




-- Q19.Write a SQL query to combine each row of the employees with each row of the jobs to obtain a consolidated results. (i.e.) Obtain every possible combination of rows from the employees and the jobs relation
SELECT * FROM EMPLOYEE_TABLE CROSS join JOBS;

--Q20.Write a query to display first_name, last_name, and email of employees who are from Europe and Asia

SELECT FIRST_NAME , LAST_NAME , EMAIL,REGION_NAME FROM EMPLOYEE_TABLE 
JOIN DEPARTMENTS ON DEPARTMENTS.DEPARTMENT_ID = EMPLOYEE_TABLE.DEPARTMENT_ID
JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID 
JOIN COUNTRIES ON LOCATIONS.COUNTRY_ID = COUNTRIES.COUNTRY_ID
JOIN REGIONS ON COUNTRIES.REGION_ID = REGIONS.REGION_ID
WHERE REGION_NAME IN ('Europe','Asia');


-- 21. Write a query to display full name with alias as FULL_NAME (Eg: first_name = 'John' and last_name='Henry' - full_name = "John Henry") who are from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.

SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME , LOCATIONS.CITY , DEPARTMENTS.DEPARTMENT_NAME
FROM EMPLOYEE_TABLE
JOIN DEPARTMENTS ON EMPLOYEE_TABLE.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
JOIN LOCATIONS ON LOCATIONS.LOCATION_ID = DEPARTMENTS.LOCATION_ID
WHERE  LOCATIONS.CITY = 'Oxford' 
AND LAST_NAME LIKE '%e_' 
AND DEPARTMENT_NAME NOT IN ('Finance', 'Shipping');




--22.Display the first name and phone number of employees who have less than 50 months of experience

SELECT CTE.EMPLOYEE_ID, SUM(CTE.EXP_MONTH) AS TOTAL_EXP FROM
(
SELECT E.EMPLOYEE_ID,DATEDIFF(MONTH, E.HIRE_DATE, GETDATE()) AS EXP_MONTH  FROM EMPLOYEE_TABLE E
UNION 
SELECT EMPLOYEE_ID, SUM(DATEDIFF(MONTH, START_DATE, END_DATE)) AS EXP_MONTH FROM JOB_HISTORY  
GROUP BY EMPLOYEE_ID 
ORDER BY EMPLOYEE_ID
) CTE
GROUP BY CTE.EMPLOYEE_ID
HAVING TOTAL_EXP>50;


--23.Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year. (For eg: John and Deepika joined on year 2023, and john has a salary of 5000, and Deepika has a salary of 6500. Output should show Deepika’s details only).

SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.HIRE_DATE, E.SALARY
FROM EMPLOYEE_TABLE E 
JOIN 
(SELECT EMPLOYEE_ID, ROW_NUMBER() OVER (PARTITION BY YEAR(HIRE_DATE) ORDER BY SALARY DESC) AS TOP FROM EMPLOYEE_TABLE ) CTE
ON E.EMPLOYEE_ID = CTE.EMPLOYEE_ID
WHERE TOP=1
ORDER BY YEAR(HIRE_DATE);
