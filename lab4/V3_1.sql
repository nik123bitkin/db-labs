USE [AdventureWorks]
GO

CREATE TABLE [Production].[WorkOrderHst] (
	[ID] INT IDENTITY(1,1) PRIMARY KEY,
	[Action] NVARCHAR(6) NOT NULL,
	[ModifiedDate] DATETIME NOT NULL,
	[SourceID] INT NOT NULL,
	[UserName] nvarchar(128) NOT NULL
);
GO

CREATE TRIGGER [TR_Production_WorkOrder_DML]
ON [Production].[WorkOrder]
AFTER INSERT, UPDATE, DELETE   
AS IF EXISTS (SELECT * FROM [inserted]) AND EXISTS (SELECT * FROM [deleted])
	INSERT INTO [Production].[WorkOrderHst] 
	SELECT 
		'update',
		CURRENT_TIMESTAMP,
		[WorkOrderID],
		CURRENT_USER
	FROM inserted
ELSE IF EXISTS (SELECT * FROM [inserted])
	INSERT INTO [Production].[WorkOrderHst] 
	SELECT 
		'insert',
		CURRENT_TIMESTAMP,
		[WorkOrderID],
		CURRENT_USER
	FROM inserted
ELSE IF EXISTS (SELECT * FROM [deleted])
	INSERT INTO [Production].[WorkOrderHst]
	SELECT 
		'delete',
		CURRENT_TIMESTAMP,
		[WorkOrderID],
		CURRENT_USER
	FROM deleted;	
GO

CREATE VIEW [Production].[VI_WorkOrder] AS SELECT * FROM [Production].[WorkOrder];
GO

INSERT INTO [Production].[VI_WorkOrder] (
	[ProductID],
    [OrderQty],
    [ScrappedQty],
    [StartDate],
    [EndDate],
    [DueDate],
    [ScrapReasonID],
    [ModifiedDate]
)
VALUES (
	1,
	1337,
	228,
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP,
	1,
	CURRENT_TIMESTAMP
);

UPDATE [Production].[VI_WorkOrder]
SET [ModifiedDate] = CURRENT_TIMESTAMP
WHERE ModifiedDate > '2020-10-30';
GO

DELETE FROM [Production].[VI_WorkOrder]
WHERE ModifiedDate > '2020-10-30';
GO

SELECT * FROM [Production].[WorkOrderHst];
GO