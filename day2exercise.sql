
//QUESTIION 1 
DELETE FROM EMPLOYEES WHERE FIRST_NAME LIKE '%even';

//QUESTION 2
SELECT * FROM EMPLOYEE_TABLE ORDER BY SALARY DESC LIMIT 3;
SELECT SALARY,count(EMPLOYEE_ID) FROM EMPLOYEE_TABLE group by SALARY order by salary desc;

SELECT DISTINCT SALARY FROM EMPLOYEE_TABLE GROUP BY SALARY ORDER BY SALARY DESC LIMIT 2 OFFSET 3;

SELECT SALARY FROM EMPLOYEE_TABLE ORDER BY SALARY DESC  ;

//QUESTION 3
CREATE TABLE EMPLOYEE_TABLE AS SELECT * FROM EMPLOYEES;
DELETE FROM EMPLOYEES;

//QUESTION4
ALTER TABLE EMPLOYEES DROP COLUMN AGE;

//QUESTION5
SELECT CONCAT(FIRST_NAME,LAST_NAME) AS NAME ,EMAIL ,YEAR(HIRE_DATE) AS JOINEDYEAR FROM EMPLOYEE_TABLE WHERE YEAR(HIRE_DATE)<2000;


//QUESTION6
//Fetch the employee_id and job_id of those employees whose start year lies  in the range of 1990 and 1999
SELECT EMPLOYEE_ID , JOB_ID FROM EMPLOYEE_TABLE WHERE YEAR(HIRE_DATE) BETWEEN 1990 AND 1999;

//QUESTION7
//7.Find the first occurrence of the letter 'A' in each employees Email ID Return the employee_id, email id and the letter position
SELECT EMPLOYEE_ID , EMAIL, CHARINDEX('A', EMAIL) AS LETTER_POSITION FROM EMPLOYEE_TABLE;

//QUESTION8
//Fetch the list of employees(Employee_id, full name, email) whose full name holds characters less than 12
SELECT EMPLOYEE_ID, CONCAT(FIRST_NAME,LAST_NAME) AS FULL_NAME , EMAIL FROM EMPLOYEE_TABLE WHERE LENGTH(CONCAT(FIRST_NAME,LAST_NAME))<12;

//QUESTION9
//9.	Create a unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID Return the employee_id, and their corresponding UNQ_ID;

SELECT EMPLOYEE_ID,CONCAT_WS('-',FIRST_NAME,LAST_NAME,EMAIL) AS UNQ_ID FROM EMPLOYEE_TABLE;

//QUESTION10
//Write a SQL query to update the size of email column to 30
ALTER TABLE EMPLOYEE_TABLE MODIFY COLUMN EMAIL VARCHAR(30);

//QUESTION11
//11.	Write a SQL query to change the location of Diana to London
-- SELECT * FROM EMPLOYEE_TABLE WHERE FIRST_NAME  = 'Diana';
-- SELECT * FROM LOCATIONS WHERE CITY = 'London';
-- select * from departments;
-- UPDATE EMPLOYEE_TABLE SET LOCATIONS.CITY = 'London'
update location set SELECT * FROM EMPLOYEE_TABLE 
INNER JOIN DEPARTMENTS ON EMPLOYEE_TABLE.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
INNER JOIN LOCATIONS ON DEPARTMENTS.LOCATION_ID = LOCATIONS.LOCATION_ID WHERE EMPLOYEE_TABLE.FIRST_NAME='Diana'
;



//QUESTION12
//12.	Fetch all employees with their first name , email , phone (without extension part) and extension (just the extension)  
//Info : this mean you need to separate phone into 2 parts 
//eg: 123.123.1234.12345 => 123.123.1234 and 12345 . first half in phone column and second half in extension column
-- SELECT FIRST_NAME,EMAIL, substr(PHONE_NUMBER,1,12) as PHONE_NUMBER , split_part(PHONE_NUMBER,'.',4) AS EXTENSION FROM EMPLOYEE_TABLE;
-- SELECT PHONE_NUMBER FROM EMPLOYEE_TABLE;

select first_name, email,
split(phone_number,'.') as number_array,
array_to_string(array_slice(number_array,0,array_size(number_array)-1),'.') as phone_number,
split_part(phone_number,'.',-1) as extension 
from employee_table;

//QUESTION13

SELECT SALARY FROM EMPLOYEE_TABLE GROUP BY SALARY ORDER BY SALARY DESC LIMIT 2 OFFSET 1;


//QUESTION14
//Fetch all details of top 3 highly paid employees who are in department Shipping and IT
SELECT * FROM EMPLOYEE_TABLE WHERE DEPARTMENT_ID IN 
(SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME IN ('IT','Shipping'))
ORDER BY SALARY DESC LIMIT 3;


//question15
//Display employee id and the positions(jobs) held by that employee (including the current position)
SELECT et.EMPLOYEE_ID , j.job_id, j.JOB_TITLE FROM EMPLOYEE_TABLE et , JOB_HISTORY jh, JOBS j 
WHERE et.EMPLOYEE_ID = jh.EMPLOYEE_ID 
AND jh.job_id = j.job_id 
order by employee_id;


//QUESTION16
SELECT EMPLOYEE_ID ,CONCAT(DAYNAME(HIRE_DATE),', ',MONTHNAME(HIRE_DATE),' ',DAY(HIRE_DATE),', ',year(hire_date)) AS DateJoined FROM EMPLOYEE_TABLE;


//Q17
//17.	The company holds a new job opening for Data Engineer (DT_ENGG) with a minimum salary of 12,000 and maximum salary of 30,000 .  
//The job position might be removed based on market trends (so, save the changes) . 
// - Later, update the maximum salary to 40,000 . 
//- Save the entries as well.
//-  Now, revert back the changes to the initial state, where the salary was 30,000
-- SELECT * FROM JOBS WHERE JOB_ID='DT_ENGG';
ALTER SESSION SET autocommit=false;
INSERT INTO JOBS VALUES('DT_ENGG','Data Engineer',12000,30000);
COMMIT;
UPDATE JOBS SET MAX_SALARY = 40000 WHERE JOB_ID='DT_ENGG';
UPDATE JOBS SET MAX_SALARY = 50000 WHERE JOB_ID='DT_ENGG';
ROLLBACK;

create table demo(
    name varchar,
    value number
);
insert into demo(name,value) values('hari',2000);
select * from demo;
ALTER SESSION SET autocommit=false;
insert into demo(name,value) values('two',6000);
update demo set value = 800 where name ='one';
rollback;
commit;


-- select * from jobs;
-- delete from jobs where job_id='DT_ENGG';

//Q18
//18.	Find the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals
-- SELECT HIRE_DATE FROM EMPLOYEE_TABLE;

SELECT round(avg(SALARY), 3) FROM EMPLOYEE_TABLE WHERE hire_date between '1996-01-08' and '2000-01-01';
SELECT floor(avg(SALARY)) FROM EMPLOYEE_TABLE;

//Q19
//Display  Australia, Asia, Antarctica, Europe along with the regions in the region table (Note: Do not insert data into the table)
//A. Display all the regions


SELECT * FROM REGIONS;
SELECT REGION_NAME FROM REGIONS 
UNION ALL SELECT 'Australia'
UNION ALL SELECT 'Asia'
UNION ALL SELECT 'Antartica'
UNION ALL SELECT 'Europe'

//B. Display all the unique regions
SELECT * FROM REGIONS;
SELECT REGION_NAME FROM REGIONS 
UNION  SELECT 'Australia'
UNION  SELECT 'Asia'
UNION  SELECT 'Antartica'
UNION  SELECT 'Europe'

//Q20
DROP TABLE EMPLOYEE_TABLE;



SELECT * FROM EMPLOYEE_TABLE WHERE FIRST_NAME IN ('Neena','Lex','Bruce');
