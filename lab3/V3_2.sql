USE [AdventureWorks]
GO

ALTER TABLE [dbo].[Address]
ADD [CountryRegionCode] NVARCHAR(3) NULL,
	[TaxRate] SMALLMONEY NULL,
	[DiffMin] AS [TaxRate] - 5.00

CREATE TABLE [#Address](
	[AddressID] [int] NOT NULL PRIMARY KEY,
	[AddressLine1] [nvarchar](60) NOT NULL,
	[AddressLine2] [nvarchar](60) NULL,
	[City] [nvarchar](20) NULL,
	[StateProvinceID] [int] NOT NULL,
	[PostalCode] [nvarchar](15) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[CountryRegionCode] [nvarchar](3) NULL,
	[TaxRate] [smallmoney] NULL
	);

WITH [CTE] AS (
	SELECT 
		[a].[AddressID],
		[a].[AddressLine1],
		[a].[AddressLine2],
		[a].[City],
		[a].[StateProvinceID],
		[a].[PostalCode],
		[a].[ModifiedDate],
		[sp].[CountryRegionCode],
		[str].[TaxRate]
	FROM [dbo].[Address] [a]
	INNER JOIN [Person].[StateProvince] [sp] ON [a].[StateProvinceID] = [sp].[StateProvinceID]
	INNER JOIN [Sales].[SalesTaxRate] [str] ON [sp].[StateProvinceID] = [str].[StateProvinceID]
	WHERE [str].[TaxRate] > 5.00
)
INSERT INTO [#Address]  
SELECT * FROM [CTE];

SELECT * FROM [#Address];

DELETE TOP(1) FROM [dbo].[Address]
WHERE [StateProvinceID] = 36;
--here I have 6 rows in my db, task is to delete one row. that's why TOP(1). 

MERGE [dbo].[Address] [target]
USING [#Address] [source] 
ON ([source].[AddressID] = [target].[AddressID])
WHEN MATCHED THEN 
UPDATE
SET 
	[target].[TaxRate] = [source].[TaxRate],
	[target].[CountryRegionCode] = [source].[CountryRegionCode]
WHEN NOT MATCHED BY TARGET THEN
INSERT (  
	[AddressID],
	[AddressLine1],
	[AddressLine2],
	[City],
	[StateProvinceID],
	[PostalCode],
	[ModifiedDate],
	[CountryRegionCode],
	[TaxRate])
VALUES (
	[source].[AddressID],
	[source].[AddressLine1],
	[source].[AddressLine2],
	[source].[City],
	[source].[StateProvinceID],
	[source].[PostalCode],
	[source].[ModifiedDate],
	[source].[CountryRegionCode],
	[source].[TaxRate])
WHEN NOT MATCHED BY SOURCE THEN DELETE;

SELECT * FROM [dbo].[Address]