USE WideWorldImporters;
GO

CREATE MESSAGE TYPE
    [//WideWorldImporters/Invoices/InvoicesRequest]	
    VALIDATION = WELL_FORMED_XML ;


CREATE MESSAGE TYPE
    [//WideWorldImporters/Invoices/InvoicesReplay]	
    VALIDATION = WELL_FORMED_XML ;
GO


CREATE CONTRACT [//WideWorldImporters/Invoices/InvoicesContract]
      ([//WideWorldImporters/Invoices/InvoicesRequest]
       SENT BY INITIATOR,
       [//WideWorldImporters/Invoices/InvoicesReplay]
       SENT BY TARGET
      );
GO

CREATE QUEUE TargetQueue1WWI;

CREATE SERVICE
       [//WideWorldImporters/Invoices/TargetService]
       ON QUEUE TargetQueue1WWI
       ([//WideWorldImporters/Invoices/InvoicesContract]);


CREATE QUEUE InitiatorQueue1WWI;

CREATE SERVICE
       [//WideWorldImporters/Invoices/InitiatorService]
       ON QUEUE InitiatorQueue1WWI;
GO

/*********************************************************************************/

CREATE OR ALTER PROCEDURE SendCustomerRequest 
	@BeginPeriod date,
    @EndPeriod date,
    @CustID int
AS
DECLARE @InitDlgHandle UNIQUEIDENTIFIER;
DECLARE @RequestMsg NVARCHAR(max);

BEGIN TRANSACTION;

BEGIN DIALOG @InitDlgHandle
     FROM SERVICE
      [//WideWorldImporters/Invoices/InitiatorService]
     TO SERVICE
      N'//WideWorldImporters/Invoices/TargetService'
     ON CONTRACT
      [//WideWorldImporters/Invoices/InvoicesContract]
     WITH
         ENCRYPTION = OFF;

WITH Request_CTE
AS
(
	SELECT distinct [CustomerID], CAST(@BeginPeriod AS NVARCHAR(10)) as BeginPeriod, CAST(@EndPeriod AS NVARCHAR(10)) as EndPeriod 
	FROM [WideWorldImporters].[Sales].[Invoices] WHERE CustomerID = @CustID
)

SELECT @RequestMsg = (SELECT * FROM Request_CTE FOR XML PATH ('Request')); -- заявка); 

--SELECT @RequestMsg; 


SEND ON CONVERSATION @InitDlgHandle
     MESSAGE TYPE 
     [//WideWorldImporters/Invoices/InvoicesRequest]
     (@RequestMsg);

--SELECT @RequestMsg AS SentRequestMsg;

COMMIT TRANSACTION;
GO

/***********************************************************************************/
CREATE OR ALTER PROCEDURE SendAnswerCreateReport
AS
DECLARE @RecvReqDlgHandle UNIQUEIDENTIFIER;
DECLARE @RecvReqMsg xml;--NVARCHAR(100);
DECLARE @DateTimeStampAnswer DATETIME2 = GETDATE();
DECLARE @CID INT, @BP DATE, @EP DATE; 
DECLARE @RecvReqMsgName sysname,
 @CustomerID xml;

BEGIN TRANSACTION;

RECEIVE TOP(1)
    @RecvReqDlgHandle = conversation_handle,
    @RecvReqMsg = message_body,
    @RecvReqMsgName = message_type_name
  FROM TargetQueue1WWI
;

SET @CustomerID = CAST(@RecvReqMsg AS xml );
SELECT @CID = @CustomerID.value('(/Request/CustomerID)[1]', 'int'), @BP = @CustomerID.value('(/Request/BeginPeriod)[1]', 'date'), @EP = @CustomerID.value('(/Request/EndPeriod)[1]', 'date');

IF OBJECT_ID (N'dbo.InsurerReport', N'U') IS NULL  
	CREATE TABLE dbo.InsurerReport
	(
		CustomerName NVARCHAR(100) NOT NULL,
		OrdersCount INT NOT NULL,
		DateTimeStampAnswer DATETIME2 NOT NULL
	);



WITH Report_CTE (CustomerName, OrdersCount)
AS
(
	SELECT C.CustomerName, COUNT(O.OrderID) AS OrdersCount FROM [Sales].[Orders] O
	INNER JOIN  [Sales].[Customers] C 
		ON O.CustomerID = C.CustomerID
	WHERE O.CustomerID = @CID AND O.OrderDate between @BP and  @EP
	GROUP BY C.CustomerName
)

INSERT INTO dbo.InsurerReport(CustomerName, OrdersCount, DateTimeStampAnswer) SELECT CustomerName, OrdersCount, @DateTimeStampAnswer FROM Report_CTE;

--IF @RecvReqMsgName =  N'//WideWorldImporters/Invoices/InvoicesRequest'
--BEGIN
     DECLARE @ReplyMsg NVARCHAR(100);
     SELECT @ReplyMsg =
     N'<ReplyMsg>Record is added</ReplyMsg>';
 


     SEND ON CONVERSATION @RecvReqDlgHandle
          MESSAGE TYPE 
          [//WideWorldImporters/Invoices/InvoicesReplay]
          (@ReplyMsg);

     END CONVERSATION @RecvReqDlgHandle;
--END

--SELECT @RecvReqMsg AS SentReplyMsg   ;

COMMIT TRANSACTION;
GO

/*******************************************/
ALTER QUEUE [dbo].[TargetQueue1WWI] WITH ACTIVATION (
    STATUS=ON,
    PROCEDURE_NAME=dbo.SendAnswerCreateReport,
    EXECUTE AS SELF,
    MAX_QUEUE_READERS=1);





/**********************************************************************************/

------------------------------------------------------

EXEC SendCustomerRequest '2013-01-01', '2020-12-31', 48;
EXEC SendCustomerRequest '2013-01-01', '2020-12-31', 100;
EXEC SendCustomerRequest '2013-01-01', '2020-12-31', 11;

-----------------------------------------------------------

/* DROP TABLE dbo.InsurerReport
DROP SERVICE [//WideWorldImporters/Invoices/TargetService];
DROP QUEUE [dbo].[TargetQueue1WWI];
DROP SERVICE [//WideWorldImporters/Invoices/InitiatorService];
DROP QUEUE [dbo].[InitiatorQueue1WWI];
DROP CONTRACT [//WideWorldImporters/Invoices/InvoicesContract];
DROP MESSAGE TYPE [//WideWorldImporters/Invoices/InvoicesReplay];
DROP MESSAGE TYPE  [//WideWorldImporters/Invoices/InvoicesRequest]; */
GO