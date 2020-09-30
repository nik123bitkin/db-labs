USE [AdventureWorks]
GO
-- task 1

SELECT [e].[BusinessEntityID],
	[e].[JobTitle],
	[d].[DepartmentID],
	[d].[Name]
FROM [HumanResources].[Employee] [e]
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] [edh] ON [e].[BusinessEntityID] = [edh].[BusinessEntityID]
INNER JOIN [HumanResources].[Department] [d] ON  [edh].[DepartmentID] = [d].[DepartmentID]
WHERE [edh].[EndDate] IS NULL --maybe as well end date == today??

-- end task 1

-- task 2

SELECT [d].[DepartmentID],
	COUNT([edh].[DepartmentID]) AS [EmpCount] 
FROM [HumanResources].[Department] [d]
INNER JOIN [HumanResources].[EmployeeDepartmentHistory] [edh] ON [d].[DepartmentID] = [edh].[DepartmentID]
WHERE [edh].[EndDate] IS NULL
GROUP BY [d].[DepartmentID]

--end task 2

-- task 3

SELECT [e].[JobTitle],
	[eph].[Rate],
	[eph].[RateChangeDate], 
	('The rate for ' + [e].[JobTitle] + 
	' was set to ' + CAST([eph].[Rate] AS nvarchar) +
	' at ' + CONVERT(nvarchar, [eph].[RateChangeDate], 106)) AS [Report]
FROM [HumanResources].[Employee] [e]
INNER JOIN [HumanResources].[EmployeePayHistory] [eph] 
ON [e].[BusinessEntityID] = [eph].[BusinessEntityID]; 

-- end task 3

