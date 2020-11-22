----------------------------------TASK 1-------------------------------------------------

CREATE FUNCTION [Purchasing].[GetOrderTotal] (@OrderId INT)
RETURNS MONEY AS
BEGIN
	RETURN (SELECT SUM(LineTotal) FROM [Purchasing].[PurchaseOrderDetail] [pod] WHERE [pod].[PurchaseOrderID] = @OrderId)
END
GO

PRINT([Purchasing].[GetOrderTotal](2));
GO

----------------------------------TASK 2-------------------------------------------------

CREATE FUNCTION [Sales].[GetTopOrdersByCustomer](@CustomerID INT, @RowCount INT)
RETURNS TABLE AS RETURN (
	SELECT TOP(@RowCount) *
	FROM [Sales].[SalesOrderHeader]
	WHERE [CustomerID] = @CustomerID
	ORDER BY [TotalDue] DESC
);
GO

SELECT * FROM [Sales].[Customer] CROSS APPLY [Sales].[GetTopOrdersByCustomer]([CustomerID], 2);
SELECT * FROM [Sales].[Customer] OUTER APPLY [Sales].[GetTopOrdersByCustomer]([CustomerID], 2);

----------------------------------TASK 3-------------------------------------------------

CREATE FUNCTION [Sales].[GetTopOrdersByCustomerMultiStatement](@CustomerID INT, @RowCount INT)
RETURNS @result TABLE(
	[SalesOrderID] INT NOT NULL,
	[RevisionNumber] TINYINT NOT NULL,
	[OrderDate] DATETIME NOT NULL,
	[DueDate] DATETIME NOT NULL,
	[ShipDate] DATETIME NULL,
	[Status] TINYINT NOT NULL,
	[OnlineOrderFlag] [dbo].[Flag] NOT NULL,
	[SalesOrderNumber] NVARCHAR(25),
	[PurchaseOrderNumber] [dbo].[OrderNumber] NULL,
	[AccountNumber] [dbo].[AccountNumber] NULL,
	[CustomerID] INT NOT NULL,
	[SalesPersonID] INT NULL,
	[TerritoryID] INT NULL,
	[BillToAddressID] INT NOT NULL,
	[ShipToAddressID] INT NOT NULL,
	[ShipMethodID] INT NOT NULL,
	[CreditCardID] INT NULL,
	[CreditCardApprovalCode] VARCHAR(15) NULL,
	[CurrencyRateID] INT NULL,
	[SubTotal] MONEY NOT NULL ,
	[TaxAmt] MONEY NOT NULL,
	[Freight] MONEY NOT NULL,
	[TotalDue] MONEY NOT NULL,
	[Comment] NVARCHAR(128) NULL,
	[rowguid] UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
	[ModifiedDate] DATETIME NOT NULL
) AS BEGIN
	INSERT INTO @result
	SELECT TOP(@RowCount)
		[SalesOrderID],
		[RevisionNumber],
		[OrderDate],
		[DueDate],
		[ShipDate],
		[Status],
		[OnlineOrderFlag],
		[SalesOrderNumber],
		[PurchaseOrderNumber],
		[AccountNumber],
		[CustomerID],
		[SalesPersonID],
		[TerritoryID],
		[BillToAddressID],
		[ShipToAddressID],
		[ShipMethodID],
		[CreditCardID],
		[CreditCardApprovalCode],
		[CurrencyRateID],
		[SubTotal],
		[TaxAmt],
		[Freight],
		[TotalDue],
		[Comment],
		[rowguid],
		[ModifiedDate]
	FROM [Sales].[SalesOrderHeader]
	WHERE [CustomerID] = @CustomerID
	ORDER BY [TotalDue] DESC
	RETURN
END;
GO

SELECT * FROM [Sales].[Customer] CROSS APPLY [Sales].[GetTopOrdersByCustomerMultiStatement]([CustomerID], 2);