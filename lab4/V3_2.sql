USE [temp_db]
GO

CREATE VIEW [VI_WorkOrder_ScrapReason_Product] 
WITH SCHEMABINDING, ENCRYPTION AS 
SELECT 
	[wo].[WorkOrderID],
	[wo].[ProductID],
    [wo].[OrderQty],
	[wo].[StockedQty],
    [wo].[ScrappedQty],
    [wo].[StartDate],
    [wo].[EndDate],
    [wo].[DueDate],
    [wo].[ScrapReasonID],
    [wo].[ModifiedDate] AS WorkOrderModifiedDate,
	[sr].[Name] AS ScrapReasonName,
	[sr].[ModifiedDate] AS ScrapReasonModifiedDate,
	[p].[Name] AS ProductName
FROM [Production].[WorkOrder] [wo]
INNER JOIN [Production].[ScrapReason] [sr] ON [wo].[ScrapReasonID] = [sr].[ScrapReasonID]
INNER JOIN [Production].[Product] [p] ON [wo].[ProductID] = [p].[ProductID]
GO

CREATE UNIQUE CLUSTERED INDEX [VI_WorkOrder_ScrapReason_Product_WorkOrderID_IX]
	ON [VI_WorkOrder_ScrapReason_Product]([WorkOrderID]);
GO	

CREATE TRIGGER [TR_IN_WorkOrder_ScrapReason_Product_DML]
ON [VI_WorkOrder_ScrapReason_Product]
INSTEAD OF INSERT AS
BEGIN
	INSERT INTO [Production].[ScrapReason]
	SELECT
		[ScrapReasonName],
		[ScrapReasonModifiedDate]
	FROM [inserted]
	INNER JOIN [Production].[Product] AS [p] ON [inserted].[ProductName] = [p].[Name];

	INSERT INTO [Production].[WorkOrder] 
	SELECT 
		[p].[ProductID],
		[inserted].[OrderQty],
		[inserted].[ScrappedQty],
		[inserted].[StartDate],
		[inserted].[EndDate],
		[inserted].[DueDate],
		SCOPE_IDENTITY(),
		[inserted].[WorkOrderModifiedDate]
	FROM [inserted]
	INNER JOIN [Production].[Product] AS [p] ON [inserted].[ProductName] = [p].[Name];
END;
GO

CREATE TRIGGER [TR_UP_WorkOrder_ScrapReason_Product_DML]
ON [VI_WorkOrder_ScrapReason_Product]
INSTEAD OF UPDATE AS
BEGIN
	IF UPDATE([WorkOrderID])
	BEGIN
		RAISERROR('UPDATE of PK is not allowed.', 18, 1);
		ROLLBACK;
	END
	ELSE
	BEGIN
		UPDATE [Production].[ScrapReason]
		SET
			[Name] = [inserted].[ScrapReasonName],
			[ModifiedDate] = [inserted].[ScrapReasonModifiedDate]
		FROM [Production].[ScrapReason] [sr]		
		INNER JOIN [inserted] ON [sr].[ScrapReasonID] = [inserted].[ScrapReasonID]
		INNER JOIN [Production].[Product] AS [p] ON [inserted].[ProductName] = [p].[Name]

		UPDATE [Production].[WorkOrder]
		SET 
			[ScrappedQty] = [inserted].[ScrappedQty],
			[StartDate] = [inserted].[StartDate],
			[EndDate] = [inserted].[EndDate],
			[DueDate] = [inserted].[DueDate],
			[ModifiedDate] = [inserted].[WorkOrderModifiedDate]
		FROM [Production].[WorkOrder] [wo]		
		INNER JOIN [inserted] ON [wo].[WorkOrderID] = [inserted].[WorkOrderID]
		INNER JOIN [Production].[Product] [p] ON [p].[Name] = [inserted].[ProductName]
	END
END;
GO

CREATE TRIGGER [TR_DE_WorkOrder_ScrapReason_Product_DML]
ON [VI_WorkOrder_ScrapReason_Product]
INSTEAD OF DELETE AS
BEGIN
	UPDATE [Production].[WorkOrder]
	SET 
		[ScrapReasonID] = NULL
	WHERE [ScrapReasonID] IN (
		SELECT [ScrapReasonID]
		FROM [deleted]
		INNER JOIN [Production].[Product] AS [p] ON [deleted].[ProductName] = [p].[Name]
	);

	DELETE FROM [Production].[ScrapReason]
	WHERE [Production].[ScrapReason].[ScrapReasonID] IN (
		SELECT [ScrapReasonID]
		FROM [deleted]
		INNER JOIN [Production].[Product] AS [p] ON [deleted].[ProductName] = [p].[Name]
	);

	DELETE FROM [Production].[WorkOrder]
	WHERE [Production].[WorkOrder].[WorkOrderID] IN (
		SELECT [WorkOrderID]
		FROM [deleted]
		INNER JOIN [Production].[Product] AS [p] ON [deleted].[ProductName] = [p].[Name]
	);
END;
GO

INSERT INTO [dbo].[VI_WorkOrder_ScrapReason_Product] (
	ProductName,
	[OrderQty],
    [ScrappedQty],
    [StartDate],
    [EndDate],
    [DueDate],
	[WorkOrderModifiedDate],
	[ScrapReasonName],
	[ScrapReasonModifiedDate]
)
VALUES (
	'Adjustable Race',
	1,
	1,
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP,
	'New Reason',
	CURRENT_TIMESTAMP
);

UPDATE [dbo].[VI_WorkOrder_ScrapReason_Product]
SET 
	[OrderQty] = 2,
    [ScrappedQty] = 2,
    [StartDate] = '2020-10-30',
    [EndDate] = '2020-10-30',
    [DueDate] = '2020-10-30',
	[WorkOrderModifiedDate] = '2020-10-30',
	[ScrapReasonName] = 'new reason name',
	[ScrapReasonModifiedDate] = '2020-10-30'
WHERE [ProductName] = 'Adjustable Race';	
GO

DELETE 
FROM [VI_WorkOrder_ScrapReason_Product] 
WHERE [ProductName] = 'Adjustable Race';
GO