USE [AdventureWorks]
GO

-- task a 

CREATE TABLE [dbo].[Address](
	[AddressID] INT NOT NULL,
	[AddressLine1] NVARCHAR(60) NOT NULL,
	[AddressLine2] NVARCHAR(60) NULL,
	[City] NVARCHAR(30) NOT NULL,
	[StateProvinceID] INT NOT NULL,
	[PostalCode] NVARCHAR(15) NOT NULL,
	[ModifiedDate] datetime NOT NULL,
);
GO

-- end task a

-- task b

ALTER TABLE [dbo].[Address]
ADD CONSTRAINT [PK_StateProvinceID_PostalCode]
PRIMARY KEY ([StateProvinceID], [PostalCode]);

-- end task b

-- task c

ALTER TABLE [dbo].[Address]
ADD CONSTRAINT [CH_PostalCode]
CHECK ([PostalCode] LIKE '%[^A-Za-zА-Яа-я]%');

-- end task c

-- task d

ALTER TABLE [dbo].[Address]
ADD CONSTRAINT [DF_ModifiedDate] 
DEFAULT GETDATE() FOR [ModifiedDate];

-- end task d

-- task e

INSERT INTO [dbo].[Address] (
	[AddressID], 
	[AddressLine1], 
	[AddressLine2], 
	[City], 
	[StateProvinceID], 
	[PostalCode], 
	[ModifiedDate])
SELECT
	[temp].[AddressID], 
	[temp].[AddressLine1], 
	[temp].[AddressLine2], 
	[temp].[City], 
	[temp].[StateProvinceID], 
	[temp].[PostalCode], 
	[temp].[ModifiedDate]
FROM
	(SELECT 
	[a].[AddressID], 
	[a].[AddressLine1], 
	[a].[AddressLine2], 
	[a].[City], 
	[a].[StateProvinceID], 
	[a].[PostalCode], 
	[a].[ModifiedDate],
	MAX([a].[AddressID]) OVER(PARTITION BY [a].[StateProvinceID], [a].[PostalCode]) AS [MaxAddressID]
	FROM [Person].[Address] [a]
	INNER JOIN [Person].[StateProvince] [sp] ON [a].[StateProvinceID] = [sp].[StateProvinceID]
	WHERE [sp].[CountryRegionCode] ='US' AND [a].[PostalCode] LIKE '%[^A-Za-zА-Яа-я]%'
	) AS [temp]
WHERE [temp].[AddressID] = [temp].[MaxAddressID];

-- end task e

SELECT * FROM [dbo].[Address]

-- task f

ALTER TABLE [dbo].[Address]
ALTER COLUMN [City] NVARCHAR(20);

-- end task f

