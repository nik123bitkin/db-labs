-- restore backup

USE master
GO

RESTORE DATABASE [AdventureWorks]
FROM DISK = 'D:\Study\DB\lab1\AdventureWorks2012-Full Database Backup.bak'
WITH MOVE 'AdventureWorks2012_Data' TO 'D:\Study\DB\AdventureWorks2012_Data.mdf',
MOVE 'AdventureWorks2012_log' TO 'D:\Study\DB\AdventureWorks_log.ldf';
GO

-- end restore

-- task 1

USE [AdventureWorks];
GO

SELECT [DepartmentID], 
	[Name] 
FROM [HumanResources].[Department]
WHERE [Name] LIKE 'P%'

-- end task 1

-- task 2

SELECT [BusinessEntityID], 
	[JobTitle], 
	[Gender],
	[VacationHours],
	[SickLeaveHours]
FROM [HumanResources].[Employee]
WHERE [VacationHours] BETWEEN 10 AND 13

-- end task 2

-- task 3

SELECT [BusinessEntityID], 
	[JobTitle], 
	[Gender],
	[BirthDate],
	[HireDate]
FROM [HumanResources].[Employee]
WHERE DAY([HireDate]) = 1 AND MONTH([HireDate]) = 7
ORDER BY [BusinessEntityID]
OFFSET 3 ROWS FETCH NEXT 5 ROWS ONLY

-- end task 3