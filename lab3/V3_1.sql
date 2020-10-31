USE [temp_db]
GO

ALTER TABLE [dbo].[Address]
ADD [AddressType] nvarchar(50) NULL;

DECLARE @temp_var TABLE (
	[AddressID] [int] NOT NULL,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](20) NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[AddressType] nvarchar(50) NULL
)

INSERT INTO @temp_var (
	[AddressID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[StateProvinceID],
	[PostalCode],
	[ModifiedDate],
	[AddressType]
)
SELECT
	[a].[AddressID],
	[a].[AddressLine1],
	[a].[AddressLine2],
	[a].[City],
	[a].[StateProvinceID],
	[a].[PostalCode],
	[a].[ModifiedDate],
	[at].[Name] 
FROM [dbo].[Address] [a]
INNER JOIN [Person].[BusinessEntityAddress] [bea] ON [a].AddressID = [bea].[AddressID]
INNER JOIN [Person].[AddressType] [at] ON [bea].[AddressTypeID] = [at].[AddressTypeID]

UPDATE [dbo].[Address]
SET [AddressType] = [tv].[AddressType],
	[AddressLine2] = ISNULL([tv].[AddressLine2], [tv].[AddressLine1])
FROM @temp_var [tv]
WHERE [tv].[PostalCode] = [dbo].[Address].[PostalCode] AND [tv].[StateProvinceID] = [dbo].[Address].[StateProvinceID]
--using PK of PostalCode and StateProvinceID from lab2, not AddressID.

SELECT * FROM [dbo].[Address]

DELETE FROM [dbo].[Address]
FROM [dbo].[Address] [a]
INNER JOIN (
	SELECT 
		  [AddressType],
		  MAX([AddressID]) [MaxID] 
	FROM [dbo].[Address]
	GROUP BY [AddressType]
) [maxIDs] ON [maxIDs].[AddressType] = [a].[AddressType]
WHERE [a].[AddressID] <> [maxIDs].[MaxID];

SELECT * FROM [dbo].[Address]

ALTER TABLE [dbo].[Address]
DROP COLUMN [AddressType]

DECLARE @Command  nvarchar(1000) = 'ALTER TABLE [dbo].[Address] DROP CONSTRAINT '

SELECT @Command += [name] + ', '
FROM sys.objects 
WHERE [type] IN ('C', 'D') AND [parent_object_id] = (
SELECT object_id
FROM sys.objects
WHERE schema_Name(schema_id) = 'dbo' AND [name] = 'Address')
SET @Command = RTRIM(SUBSTRING(@Command, 0, LEN(@Command)))
PRINT @Command

EXECUTE (@Command)

DROP TABLE [dbo].[Address]
