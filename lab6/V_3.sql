CREATE PROCEDURE [Production].[GetMedianPriceByCategory](@ProductClasses NVARCHAR(max)) AS
BEGIN
	DECLARE @query nvarchar(max) = '
        SELECT [Name], ' + @ProductClasses + '
        FROM (
            SELECT [ListPrice],
				   [Class],
				   [PSC].[Name]
			FROM [Production].[Product] [P]
            JOIN [Production].[ProductSubcategory] [PSC]
            ON [P].[ProductSubcategoryID] = [PSC].[ProductSubcategoryID]
        ) AS [temp]
        PIVOT (AVG([ListPrice]) FOR [temp].[Class] IN (' + @ProductClasses + ')) AS [pivot]';

    Execute sp_executesql @query
END;


EXECUTE [Production].[GetMedianPriceByCategory] '[H],[L],[M]';