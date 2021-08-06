-- 23. 
-- 1. fetching
select *, (sal*0.95) as decrement_sal from emp where job in('clerk');

-- 2.
select empno, ename from emp where sal between 2000 and 3000; 

-- 3. deptno
select empno,job from emp where deptno in(10,20);

-- 4.
select empno,mgr from emp where sal>2000 or deptno>10 or job="clerk";

-- 5. increment sal by 15% who is not reporting to anyone.
select *,(sal*1.15) as increment_sal  from emp where mgr is null;
 
 -- 24. 
 -- 1. increment and desc
 select *,(sal*1.7) as increment_sal from emp where mgr is not null order by (sal*1.7) desc;
 
 -- 2.
 select empno, ename from emp where sal between 2000 and 3000 order by empno asc;
 
 -- 3.
 select distinct empno,job from emp where deptno in(10,20);

-- 4.
select distinct job from emp where job!="manager";

-- 25.
-- 1.
select count(empno) as count from emp;

-- 2.
select deptno,count(empno) as count from emp group by deptno;

-- 3.
select min(sal) from emp;
-- 4.
select deptno, max(sal) as maximumSalary from emp group by deptno;
-- 5.
select count(sal) from emp where sal>2000;
-- 6.
select deptno, count(sal) from emp group by 1 having count(sal)<3000;
-- 7.
select deptno, count(deptno) from emp group by 1 having count(deptno)<6;
-- 8.
select deptno, max(sal) from emp group by 1 having max(sal)>3000;

-- 26.
-- 1.
select *, (sal*1.07) as increment_amount
	from emp as e
	left join dept as d
    using(deptno)
	where d.loc='BOSTON';
    
select * from emp;

-- 2.
select *, COUNT(*)
from emp as e
inner join dept as d
	on e.deptno = d.deptno
where d.dname = 'RESEARCH'
group by e.deptno;

-- 3.
select *, max(sal) from emp as e
	right join dept as d
    on e.empno = d.deptno
    where d.dname='SALES';

-- 4.
select hiredate 
	from emp as e
    join dept as d
    where d.loc is null;


-- 27. 
-- create table student_info with columns rno,name,city
-- where rno is a primary key and all columns do not accept null.
CREATE TABLE student_info (
	rno INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    sname VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL 
);

-- 1. 
-- Insert below records:
-- 1,'gautam','jalgaon'
-- 2,'balaji','parbhani'
-- 3,'rushin','jalgaon'
INSERT INTO student_info(sname, city) VALUES('gautam', 'jalgaon');
INSERT INTO student_info(sname, city) VALUES('balaji', 'parbhani');
INSERT INTO student_info(sname, city) VALUES('rushin', 'jalgaon');

-- 2. create table marks with columns rno,sub_code number,marks and insert below records:
CREATE TABLE marks (
	rno INT NOT NULL,
    sub_code INT NOT NULL,
    marks INT
);

-- 3.
-- 1,100,80
-- 2,100,null
-- 1,101,90
-- 2,101,78
-- 3,100,30
-- 3,101,null
INSERT INTO marks(rno, sub_code, marks) VALUES(1, 100, 80);
INSERT INTO marks(rno, sub_code, marks) VALUES(2, 100, null);
INSERT INTO marks(rno, sub_code, marks) VALUES(1, 101, 90);
INSERT INTO marks(rno, sub_code, marks) VALUES(2, 101, 78);
INSERT INTO marks(rno, sub_code, marks) VALUES(3, 100, 30);
INSERT INTO marks(rno, sub_code, marks) VALUES(3, 101, null);

-- 4. create table subject with columns sub_code number,sub_name
CREATE TABLE subjects (
	sub_code INT,
    sub_name VARCHAR(50)
);

-- 5.
-- Insert below records:
-- 100,'dbms'
-- 101,'SE'
INSERT INTO subjects(sub_code, sub_name) VALUES (100, 'dbms');
INSERT INTO subjects(sub_code, sub_name) VALUES (101, 'SE');

-- 6. Find out average marks of each student along with roll number of student.
SELECT rno, AVG(marks) AS avg_marks
FROM marks
GROUP BY rno;

-- 7. Find out how many students have failed i.e. obtained less than 40 marks in DBMS.
SELECT COUNT(*) AS failed_students
FROM marks
WHERE marks < 40 AND sub_code = (
	SELECT sub_code FROM subjects
    WHERE sub_name = 'dbms'
);

-- 8. Find names of Students who are absent in Exam i.e. students having null marks.
SELECT sname, marks
FROM student_info
INNER JOIN marks
	ON student_info.rno = marks.rno
HAVING marks.marks IS NULL;

-- 9. Find the name of students who live in either ‘pune’ or 'jalgaon’.
SELECT sname FROM student_info
WHERE city IN ('pune', 'jalgaon');

-- 10. Find out roll no and total marks of each student.
SELECT rno, SUM(marks) AS total_marks
FROM marks
GROUP BY rno;

-- 11. Find those student names which start with 'ba'.
SELECT sname FROM student_info
WHERE sname LIKE 'ba%';

-- 12. Display total no of students having greater than 75 marks in any one subject.
SELECT rno, MAX(marks) AS max_marks
FROM marks
GROUP BY rno
HAVING max_marks > 75;

-- 13. Display marks of all students for DBMS subject.
SELECT rno, marks FROM marks
WHERE sub_code = (
	SELECT sub_code FROM subjects
    WHERE sub_name = 'dbms'
);

-- 14. Display no of students appeared for the exam.


-- 15. Display all subjects marks of students whose name is gautam.
SELECT sub_code, marks FROM marks
WHERE rno = (
	SELECT rno FROM student_info
    WHERE sname = 'gautam'
);

-- 28.
-- 1.
select * from emp order by hiredate desc;
-- 2.
select *, (sal*1.05) as increment_sal from emp where year(hiredate) > (3*365);
-- 3.
select *, (sal*1.07) as increment_sal from emp where year(hiredate) > (5*365) and sal < 2000;
-- 4.
select year(hiredate), count(year(hiredate)) from emp group by year(hiredate);
-- 5.
select month(hiredate), count(month(hiredate)) from emp group by month(hiredate);
-- 6.
drop table funCopy;
create table funCopy select * from emp where year(hiredate)> year(curdate())-1;
select * from funCopy;


-- 29.
-- 1.
-- Create a procedure to Display employees experience level with company. (With In as Empid and Out as Level)
-- If worked more than 2 and less than 4 years  - Middle
-- If worked more than 4 years - Seniour
-- else Juniour
DELIMITER $$
CREATE PROCEDURE GetEmpExperienceLevel(
	IN empId INT,
    OUT empLevel VARCHAR(20)
)
BEGIN 
	DECLARE expyear DECIMAL DEFAULT 0;  -- variable declaration
    
    SELECT floor(DATEDIFF(CURRENT_DATE(), hiredate)/365) INTO expyear FROM emp WHERE empno = empId;
    
    IF expyear>2 AND expyear<4 THEN
		SET empLevel='Middle';
	ELSEIF expyear>4 THEN
		SET empLevel='Senior';
	ELSE
		SET empLevel='Junior'; 
	END IF;
END $$
DELIMITER ;

-- 2.
-- Create a function to give incremented salary value if passed Int and Percentage parameter.
-- salIncre(2000,10) --> Output 2200   (10% incremented)
DELIMITER $$
CREATE FUNCTION salInc( 
	salary INT,
    percentage INT
)
RETURNS INT
DETERMINISTIC
BEGIN 
	RETURN salary+((salary*percentage)/100);
END $$
DELIMITER ;