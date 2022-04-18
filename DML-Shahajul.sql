
USE db1267784
GO
------------Insert data-----------------

INSERT INTO Grades (grade) VALUES ('G03'), ('GO1'), ('M03')
GO ----Grades table

SELECT * FROM Grades
GO

INSERT INTO Departments (departmentname) VALUES ('Accounts'),('Admin'),('Marketing')
GO -----Departments Table

SELECT * FROM Departments
Go

INSERT INTO Employees (emploteename,joindate,email,phone,departmentid) VALUES ('Rahmatullah Muzahid','2017-07-01','rmuzahid@gmail.com','01934675987',300),
	('Kaiser Faisal','2017-01-01','faisal@gmail.com','01934612612',301),
	('Azad Ahmed','2018-03-01','azad@yahoo.com','01751123123',300)
GO
SELECT * FROM Employees
GO
-------insert into data gradehistories----

INSERT INTO gradehistories (employeeid,gradeid,startDate,endDate) VALUES (1000,1,'2017-07-01','2018-06-30'),
(1000,2,'2018-07-01','2019-06-30'),(1000,3,'2019-07-01','')

GO

INSERT INTO gradehistories (employeeid,gradeid,startDate,endDate) VALUES (1001,1,'2020-07-01','2022-06-30'),
(1002,2,'2021-07-01','2022-06-30'),(1002,3,'2022-07-01','')

GO

SELECT * FROM gradehistories
GO

---------inert into Designations-------------

INSERT INTO Designations (Designation) VALUES ('Accounts Assistant'),('Accountant'),('Assistant Accounts Manager')
GO

SELECT * FROM Designations
GO

---------inert into Designationhistories-------------
INSERT INTO Designationhistories(employeeid,designationid,startDate,endDate) VALUES
(1000,500,'2017-07-01','2018-06-30'),
(1000,501,'2018-07-01','2019-06-30'),
(1000,502,'2019-07-01','')
GO
INSERT INTO Designationhistories(employeeid,designationid,startDate,endDate) VALUES
(1001,500,'2020-07-01','2020-06-30'),
(1001,501,'2019-08-01','2020-06-30'),
(1002,502,'2019-08-01','')
GO

SELECT * FROM Designationhistories
GO


-------------------Index Creation------------------------
CREATE INDEX IxEmpName						
ON Employees (emploteename)
GO
EXEC sp_helpindex 'Employees'
GO

----------------Create view---------------------
/*
	A new employee must be registered with a designation and a grade.
	It must be implemented in procedural ways
*/



SELECT * FROM employeecurrenstatus(1)
GO





SELECT * FROM VVAllEmloyee
GO



SELECT * FROM VVgradehistories
GO

---------------Stored insert Procedures ------------------------

CREATE PROC SpGrades ---------insert Procedures table Grades
@G NVARCHAR(20)
AS 
INSERT INTO Grades (grade) VALUES (@G)
GO

-----------Test the procedure-------------
EXEC SpGrades 'MO1'
GO

SELECT * FROM Grades
GO

CREATE PROC SpDepartments   ---------insert Procedures table Departments
@dpt NVARCHAR(60)
AS 
INSERT INTO Departments (departmentname) VALUES (@dpt)
GO

-----------Test the procedure-------------
EXEC SpDepartments 'Marketing'
GO

SELECT * FROM Departments
GO




-----------Test the procedure-------------
EXEC SpEmployees @name ='tanjim', @jd = '2021-06-04',@Em = 'rest@gmail.com',@phn = '0123548',@dpt = 304
GO

SELECT * FROM Employees
GO



-----------Test the procedure-------------
EXEC SPgradehistories @gid = 2, @Std = '2019-06-04',@End= '2021-07-05'
GO

SELECT * FROM gradehistories
GO



-----------Test the procedure-------------
EXEC SpDesignations @d = 'Sales'
GO

SELECT * FROM Designations
GO



-----------Test the procedure-------------
EXEC SPDesignationhistories @empid = 1002, @dgn = 503,@std = '2020-12-17',@end = '2021-11-25'
GO

SELECT * FROM Designationhistories
GO





SELECT * FROm Departments



------------------Store procedure Insert gradehistories-----------------------







-----------Test the procedure-------------
EXEC spInsertEmployee	@employeename='Rahmatullah Muzahid',
									@joiningdate ='2017-07-01' ,
									@email='rmuzahid@gmail.com',
									@phone = '01934675987',
									@departmentid =3,
									@designation ='Account Assistant',
									@grade ='AM02'
EXEC spInsertEmployee	@employeename='Kaiser Failsal',
									@joiningdate ='2017-01-01' ,
									@email='kf@gmail.com',
									@phone = '01934675987',
									@departmentid =1,
									@designation ='Assistant Manager',
									@grade ='M03'
EXEC spInsertEmployee	@employeename='Ayub ALi',
									@joiningdate ='2018-03-01' ,
									@email='aali@gmail.com',
									@phone = '01934675987',
									@departmentid =1,
									@designation ='Executive',
									@grade ='E02'
go
--effects employees, gradehistories, designationhistories and designations only if designation not existes
SELECT * FROM employees
select * from designations
select * from gradehistories
select * from designationhistories
go


SELECT * from dbo.fnEmployee_Designation('Rahmatullah Muzahid')
GO







