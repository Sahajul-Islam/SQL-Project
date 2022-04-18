-- Create datebase

CREATE DATABASE db1267784
GO

USE db1267784
GO

create table departments
(
	departmentid int identity primary key,
	departmentname nvarchar(40) not null
)
go
create table employees
(
	employeeid int identity primary key,
	employeename nvarchar(50) not null,
	joiningdate date not null,
	email nvarchar(50) not null,
	phone nvarchar(20) null,
	departmentid int not null references departments (departmentid)
)
go
create table grades
(
	gradeid int identity primary key,
	grade nvarchar(15) not null
)
go
create table designations
(
	designationid int identity primary key,
	designation nvarchar(25) not null
)
go
create table designationhistories
(
	employeeid int not null references employees (employeeid),
	designationid int not null references designations (designationid),
	startdate date not null,
	enddate date null,
	primary key (employeeid, designationid)
)
go
create table gradehistories
(
	employeeid int not null references employees (employeeid),
	gradeid int not null references grades (gradeid),
	startdate date not null,
	enddate date null,
	primary key (employeeid, gradeid)
)
go
--------------function  ----------------------

create function employeecurrenstatus (@employeeid int ) returns @tbl TABLE (employeename nvarchar(50),currentgrade nvarchar(15), currentdesignation nvarchar(25))
AS
begin
insert into @tbl
select e.employeename,g.grade, d.designation
from employees e
inner join designationhistories dh on e.employeeid = dh.employeeid
inner join gradehistories gh on gh.employeeid = e.employeeid
inner join grades g on gh.gradeid = g.gradeid
inner join designations d on d.designationid = dh.designationid
where e.employeeid =@employeeid and dh.enddate is null and gh.enddate is null
return
end
GO
----------View ----------------
CREATE VIEW VVAllEmloyee
WITH ENCRYPTION
AS
SELECT E.employeename,De.departmentname,E.joiningdate,E.email,E.phone
	FROM Employees E             -------Employees Table
	INNER JOIN Departments De
	ON E.departmentid = De.departmentid -------Department table
GO
----------View All Employee gradehistories Companny----------------

CREATE VIEW  VVgradehistories
WITH ENCRYPTION
AS
SELECT E.employeename,Gr.grade,D.departmentname, G.startDate,G.endDate
FROM gradehistories G
	INNER JOIN Employees E
	ON G.employeeid = E.employeeid
	INNER JOIN Grades Gr
	ON G.gradeid = Gr.gradeid
	INNER JOIN Departments D
	ON D.departmentid = E.departmentid
GO
---------Procedures-----------------
CREATE PROC SpEmployees     
@name NVARCHAR(50),
@jd DATETIME,
@Em NVARCHAR(50),
@phn NVARCHAR(15),
@dpt INT
AS
INSERT INTO Employees (employeename,joiningdate,email,phone,departmentid)
VALUES (@name,@jd,@Em,@phn,@dpt)
GO
 ----------gradehistories--------------
CREATE PROC SPgradehistories
@gid INT,
@Std DATETIME,
@End DATETIME
AS
INSERT INTO gradehistories (gradeid,startDate,endDate) VALUES (@gid,@Std,@End)
GO
----------Designations-------------
CREATE PROC SpDesignations    
@d NVARCHAR(50)
AS
INSERT INTO Designations (Designation) VALUES (@d)
GO
-------Designationhistories-------------
CREATE PROC SPDesignationhistories
@empid INT,
@dgn INT,
@std DATETIME,
@end DATETIME
AS 
INSERT INTO Designationhistories (employeeid,Designationid,startDate,endDate) VALUES (@empid,@dgn,@std,@end)
GO
------------------Grades-----------------------

CREATE PROC spInsert_Grades @gr NVARCHAR(20)
AS
DECLARE @id INT
SELECT @id = ISNULL(MAX(gradeid), 0)+1 FROM Grades
BEGIN TRY
	INSERT INTO Grades(gradeid, grade)
	VALUES (@id, @gr )
	RETURN @id
	END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO
------------------Departments-----------------------

CREATE PROC spInsert_Departments @dptn NVARCHAR(60)
AS
DECLARE @id INT
SELECT @id = ISNULL(MAX(departmentid), 0)+1 FROM Departments
BEGIN TRY
	INSERT INTO Departments(departmentid, departmentname)
	VALUES (@id, @dptn )
	RETURN @id
	END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO
------------------Employees-----------------------

CREATE PROC spInsert_Employees @name NVARCHAR(50),
							   @joiningdate DATETIME,
							   @em NVARCHAR(50),
							   @phn NVARCHAR (15),
							   @dpt INT

AS
DECLARE @id INT
SELECT @id = ISNULL(MAX(employeeid), 0)+1 FROM Employees
BEGIN TRY
	INSERT INTO Employees(employeeid, employeename,joiningdate,email,phone,departmentid)
	VALUES (@id, @name,@joiningdate,@em,@phn,@dpt)
	RETURN @id
	END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO
CREATE PROC spInsert_gradehistories @Gr INT,
									 @Stda DATETIME,
									 @endDate DATE
AS
DECLARE @id INT
SELECT @id = ISNULL(MAX(employeeid), 0)+1 FROM gradehistories
BEGIN TRY
	INSERT INTO gradehistories (employeeid, gradeid,startDate, endDate)
	VALUES (@id,@Gr, @Stda,@endDate)
	RETURN @id
	END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO
------------------Designations-----------------------

CREATE PROC spInsert_Designations @Dn NVARCHAR(50)
AS
DECLARE @id INT
SELECT @id = ISNULL(MAX(designationid), 0)+1 FROM Designations
BEGIN TRY
	INSERT INTO Designations (designationid, Designation)
	VALUES (@id,@Dn)
	RETURN @id
	END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO
------------------Designationhistories-----------------------

CREATE PROC spInsert_Designationhistories @D INT,
									      @Stda DATETIME,
								          @endDate DATETIME
                                     
AS
DECLARE @id INT
SELECT @id = ISNULL(MAX(employeeid), 0)+1 FROM Designationhistories
BEGIN TRY
	INSERT INTO Designationhistories (employeeid,Designationid,startDate,endDate)
	VALUES (@id,@D,@Stda,@endDate)
	RETURN @id
	END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO
------------------Grades-----------------------

CREATE PROC spUpdate_Grades @id INT,@n NVARCHAR(20)
AS
BEGIN TRY
	UPDATE Grades
	SET grade = @n
	WHERE gradeid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO


------------------Departments-----------------------

CREATE PROC spUpdate_Departments @id INT,@n NVARCHAR(60)
AS
BEGIN TRY
	UPDATE Departments
	SET departmentname = @n
	WHERE departmentid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

------------------Employees-----------------------

CREATE PROC spUpdate_Employees @id INT,
							   @name NVARCHAR(50),
							   @joiningdate DATETIME,
							   @em NVARCHAR(50),
							   @phn NVARCHAR (15),
							   @dpt INT

AS
BEGIN TRY
	UPDATE Employees
	SET employeename = @name,
		joiningdate = @joiningdate,
		email = @em,
		phone = @phn,
		departmentid = @dpt
	WHERE employeeid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

------------------gradehistories-----------------------

CREATE PROC spUpdate_gradehistories @id INT,
							   @Gr INT,
							   @Stda DATETIME,
							   @endDate DATETIME
AS
BEGIN TRY
	UPDATE gradehistories
	SET gradeid = @Gr ,
		startDate = @Stda
	WHERE employeeid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

------------------Designations-----------------------

CREATE PROC spUpdate_Designations @id INT,
							   @Dn NVARCHAR(50)
AS
BEGIN TRY
	UPDATE Designations
	SET Designation = @Dn
	WHERE designationid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

------------------Designationhistories-----------------------

CREATE PROC spUpdate_Designationhistories @id INT,
                                          @D INT,
									      @Stda DATETIME,
								          @endDate DATETIME
AS
BEGIN TRY
	UPDATE Designationhistories
	SET Designationid = @D ,
		startDate = @Stda,
		endDate = @endDate
	WHERE employeeid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO


------------------Grades-----------------------

CREATE PROC spDelete_Grades @id INT
AS
BEGIN TRY
	DELETE Grades
	WHERE gradeid  = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

------------------Departments-----------------------

CREATE PROC spDelete_Departments @id INT
AS
BEGIN TRY
	DELETE Departments
	WHERE departmentid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO


------------------Employees-----------------------

CREATE PROC spDelete_Employees @id INT,
							   @name NVARCHAR(50),
							   @joiningdate DATETIME,
							   @em NVARCHAR(50),
							   @phn NVARCHAR (15),
							   @dpt INT
AS
BEGIN TRY
	DELETE Employees
	WHERE employeeid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

------------------gradehistories-----------------------

CREATE PROC spDelete_gradehistories @id INT,
									 @Gr INT,
									 @Stda DATETIME,
									 @endDate DATETIME
AS
BEGIN TRY
	DELETE gradehistories
	WHERE employeeid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

------------------Designations-----------------------

CREATE PROC spDelete_Designations @id INT
									 
AS
BEGIN TRY
	DELETE Designations
	WHERE designationid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO


------------------Designationhistories-----------------------

CREATE PROC spDelete_Designationhistories @id INT,
                                          @D INT,
									      @Stda DATETIME,
								          @endDate DATETIME
									 
AS
BEGIN TRY
	DELETE Designationhistories
	WHERE employeeid = @id
END TRY
BEGIN CATCH
	;
	THROW 50001, 'Error encountered', 1
	RETURN 0
END CATCH
GO

 -------------------------employee--------------------------------

create procedure spInsertEmployee	@employeename nvarchar(50),
									@joiningdate date ,
									@email nvarchar(50),
									@phone nvarchar(20),
									@departmentid int,
									@designation nvarchar(25),
									@grade nvarchar(15)
as
	declare @designationid int, @gradeid int, @employeeid int
	IF exists( select 1 FROM designations where designation= @designation)
		SELECT @designationid = designationid FROM designations where designation= @designation
	else
	begin
		insert into designations (designation) values(@designation)
		set @designationid = SCOPE_IDENTITY()
	end
	select	@gradeid=gradeid from grades where grade = @grade
	--insert employee row
	insert into employees (employeename, joiningdate, email, phone, departmentid)
	values (@employeename, @joiningdate, @email, @phone, @departmentid)
	set @employeeid = SCOPE_IDENTITY()
	--entry designation history
	insert into designationhistories(employeeid, designationid, startdate)
	values (@employeeid, @designationid, @joiningdate)
	--entry grade history
	insert into gradehistories (employeeid, gradeid,startdate)
	values (@employeeid, @gradeid, @joiningdate)
	--done
return
go


----------------------------User Defined Function(UDF)----------------------------------------

CREATE FUNCTION fnEmployee_Designation (@employeename NVARCHAR(500)) RETURNS TABLE
AS
RETURN
(
	SELECT E.employeename,D.Designation,De.departmentname,G.grade,E.email,E.phone,Gh.startDate,Gh.endDate
	FROM Employees E             -------Employees Table
	INNER JOIN Departments De
	ON E.departmentid = De.departmentid --------department table
	INNER JOIN Designationhistories Dh
	ON Dh.employeeid = E.employeeid ----------------Designationhistorie table
	INNER JOIN Designations D
	ON Dh.Designationid = D.designationid     --------------Designations table
	INNER JOIN gradehistories Gh     -----------------gradehistories table
	ON Gh.employeeid = E.employeeid
	INNER JOIN Grades G   -------------------------------------Grades table
	ON Gh.gradeid = G.gradeid
	WHERE E.employeename = @employeename
)
GO

CREATE PROC spUpEmployees 
			@emid INT,
			@name NVARCHAR(50),
			@jd DATETIME OUTPUT,
			@Em NVARCHAR(50),
			@phn NVARCHAR(15),
			@dpt INT		
AS
BEGIN TRY
	UPDATE Employees SET employeename =ISNULL(@name,employeename),joiningdate = ISNULL(@jd,joiningdate),email=ISNULL(@em, email),
	phone =ISNULL(@phn,phone),departmentid = ISNULL(@dpt,departmentid)
	WHERE employeeid = @emid	
END TRY
BEGIN CATCH
	DECLARE @errmessage nvarchar(500)
	set @errmessage = ERROR_MESSAGE()
	RAISERROR( @errmessage, 11, 1)
	return 
END CATCH
return 
GO 
----------------triggers----
create trigger  tremployeeinsert
on employees
after insert
as
begin
	declare @eid int
	select @eid=employeeid from inserted
	delete from gradehistories where employeeid=@eid
	delete from gradehistories where employeeid=@eid
end
--USE master
--GO
--DROP DATABASE HR
--GO