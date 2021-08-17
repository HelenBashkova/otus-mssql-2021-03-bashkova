ALTER DATABASE  [WideWorldImporters]
ADD FILEGROUP partition1fg;  
GO  
ALTER DATABASE [WideWorldImporters] 
ADD FILEGROUP partition2fg;  
GO  
ALTER DATABASE  [WideWorldImporters]
ADD FILEGROUP partition3fg;  
GO  
ALTER DATABASE  [WideWorldImporters]  
ADD FILEGROUP partition4fg;   

ALTER DATABASE [WideWorldImporters]   
ADD FILE   
(  
    NAME = partition1fg,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSRV2017\MSSQL\DATA\wwi_part\p1dat1.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP partition1fg;  
ALTER DATABASE [WideWorldImporters]   
ADD FILE   
(  
    NAME = partition2fg,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSRV2017\MSSQL\DATA\wwi_part\p2dat2.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP partition2fg;  
GO  
ALTER DATABASE [WideWorldImporters]   
ADD FILE   
(  
    NAME = partition3fg,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSRV2017\MSSQL\DATA\wwi_part\p3dat3.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP partition3fg;  
GO  
ALTER DATABASE [WideWorldImporters]   
ADD FILE   
(  
    NAME = partition4fg,  
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSRV2017\MSSQL\DATA\wwi_part\p4dat4.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 5MB  
)  
TO FILEGROUP partition4fg;  
GO  

--DROP TABLE IF EXISTS  [Sales].[InvoicesByYear];
--DROP PARTITION SCHEME [fnRangeInvoicesPS];
--DROP PARTITION FUNCTION [fnRangeInvoicesY];

CREATE PARTITION FUNCTION fnRangeInvoicesY (int)  
    AS RANGE LEFT FOR VALUES (2013, 2014, 2015) ;  
GO  

CREATE PARTITION SCHEME fnRangeInvoicesPS  
    AS PARTITION fnRangeInvoicesY  
     TO (partition1fg, partition2fg, partition3fg, partition4fg) ;   
GO  

CREATE TABLE [Sales].[InvoicesByYear](
	[InvoiceID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[BillToCustomerID] [int] NOT NULL,
	[OrderID] [int] NULL,
	[DeliveryMethodID] [int] NOT NULL,
	[ContactPersonID] [int] NOT NULL,
	[AccountsPersonID] [int] NOT NULL,
	[SalespersonPersonID] [int] NOT NULL,
	[PackedByPersonID] [int] NOT NULL,
	[InvoiceDate] [date] NOT NULL,
	[CustomerPurchaseOrderNumber] [nvarchar](20) NULL,
	[IsCreditNote] [bit] NOT NULL,
	[CreditNoteReason] [nvarchar](max) NULL,
	[Comments] [nvarchar](max) NULL,
	[DeliveryInstructions] [nvarchar](max) NULL,
	[InternalComments] [nvarchar](max) NULL,
	[TotalDryItems] [int] NOT NULL,
	[TotalChillerItems] [int] NOT NULL,
	[DeliveryRun] [nvarchar](5) NULL,
	[RunPosition] [nvarchar](5) NULL,
	[ReturnedDeliveryData] [nvarchar](max) NULL,
	[ConfirmedDeliveryTime]  AS (TRY_CONVERT([datetime2](7),json_value([ReturnedDeliveryData],N'$.DeliveredWhen'),(126))),
	[ConfirmedReceivedBy]  AS (json_value([ReturnedDeliveryData],N'$.ReceivedBy')),
	[LastEditedBy] [int] NOT NULL,
	[LastEditedWhen] [datetime2](7) NOT NULL,
	[YearInvoice] AS YEAR([InvoiceDate]) PERSISTED NOT NULL
	
) ON fnRangeInvoicesPS([YearInvoice])

INSERT INTO [Sales].[InvoicesByYear]
(
[InvoiceID]
	,[CustomerID]
	,[BillToCustomerID] 
	,[OrderID] 
	,[DeliveryMethodID]
	,[ContactPersonID]
	,[AccountsPersonID]
	,[SalespersonPersonID] 
	,[PackedByPersonID]
	,[InvoiceDate]
	,[CustomerPurchaseOrderNumber] 
	,[IsCreditNote]
	,[CreditNoteReason] 
	,[Comments]
	,[DeliveryInstructions]
	,[InternalComments]
	,[TotalDryItems]
	,[TotalChillerItems]
	,[DeliveryRun]
	,[RunPosition]
	,[ReturnedDeliveryData]
	,[LastEditedBy]
	,[LastEditedWhen] 
)
SELECT 
[InvoiceID]
      ,[CustomerID]
      ,[BillToCustomerID]
      ,[OrderID]
      ,[DeliveryMethodID]
      ,[ContactPersonID]
      ,[AccountsPersonID]
      ,[SalespersonPersonID]
      ,[PackedByPersonID]
      ,[InvoiceDate]
      ,[CustomerPurchaseOrderNumber]
      ,[IsCreditNote]
      ,[CreditNoteReason]
      ,[Comments]
      ,[DeliveryInstructions]
      ,[InternalComments]
      ,[TotalDryItems]
      ,[TotalChillerItems]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[ReturnedDeliveryData]
      ,[LastEditedBy]
      ,[LastEditedWhen]

FROM Sales.Invoices;
GO

ALTER TABLE [Sales].[InvoicesByYear]
ADD CONSTRAINT PK_InvoiceID_YearInvoice
   PRIMARY KEY CLUSTERED (YearInvoice, InvoiceID)
   ON fnRangeInvoicesPS(YearInvoice)
GO