DECLARE @data XML = (
    SELECT 
		[Person].[BusinessEntityID] [ID],
		[Person].[FirstName] [FirstName],
		[Person].[LastName] [LastName]
    FROM [Person].[Person]
    FOR XML PATH ('Person'), ROOT ('Persons')
)

--SELECT @data

CREATE TABLE #temp
(
    BusinessEntityID INT NOT NULL,
    FirstName        NVARCHAR(20),
    LastName         NVARCHAR(20)
)

INSERT #temp
SELECT [xml].value('(./ID)[1]', 'INT')					[BusinessEntityID],
       [xml].value('(./FirstName)[1]', 'NVARCHAR(20)')    [FirstName],
       [xml].value('(./LastName)[1]', 'NVARCHAR(20)')		[LastName]
FROM @data.nodes('/Persons/Person') XmlData([xml])

SELECT * FROM #temp;