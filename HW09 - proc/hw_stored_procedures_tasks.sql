/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "12 - Хранимые процедуры, функции, триггеры, курсоры".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

USE WideWorldImporters;
GO

/*
Во всех заданиях написать хранимую процедуру / функцию и продемонстрировать ее использование.
*/

/*
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/

USE [WideWorldImporters]
GO

CREATE OR ALTER FUNCTION [Sales].ufn_CustomersWithMaxPurchase() 
RETURNS @resTable TABLE
(
    CustomerName nvarchar(100) NOT NULL,    
    OrdersSum decimal(18,2) NOT NULL
)
AS 
BEGIN
	DECLARE @MAXBUYSUMM DECIMAL(18,2), @INV INT;
	WITH BuySum_CTE(InvoiceID, BuyFullSumByInv)
	AS
	(
		SELECT DISTINCT InvoiceID, SUM(IL.Quantity*IL.UnitPrice) OVER(PARTITION BY InvoiceID) BuyFullSumByInv
			FROM [Sales].[InvoiceLines] IL  
	)
	SELECT @MAXBUYSUMM = (SELECT MAX(BuyFullSumByInv) FROM BuySum_CTE), 
			@INV = (SELECT InvoiceID FROM BuySum_CTE 
	WHERE BuyFullSumByInv = (SELECT MAX(BuyFullSumByInv) FROM BuySum_CTE));

	INSERT @resTable
    SELECT Cust.CustomerName, @MAXBUYSUMM FROM [Sales].[Customers] Cust 
	INNER JOIN [Sales].[Invoices] Inv
	   ON Cust.CustomerID = Inv.CustomerID
	WHERE Inv.InvoiceID = @INV		
	RETURN
END;
GO

SELECT * FROM [Sales].ufn_CustomersWithMaxPurchase();

/*
2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

CREATE OR ALTER PROCEDURE [Sales].CalcBuySumByCustomerID 
	@CustID int
AS
SET NOCOUNT ON;
SELECT distinct CS.CustomerName, 
	SUM(IL.Quantity*IL.UnitPrice) OVER(PARTITION BY I.CustomerID) BuyFullSumByInv
FROM [Sales].[InvoiceLines] IL
	INNER JOIN [Sales].[Invoices] I
		ON IL.InvoiceID = I.InvoiceID
	INNER JOIN [Sales].[Customers] CS
		ON I.CustomerID = CS.CustomerID
WHERE I.CustomerID = @CustID;
GO

EXECUTE [Sales].CalcBuySumByCustomerID 198;

/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
*/

CREATE OR ALTER FUNCTION [Sales].udf_StockItemPurchasingAmount (@StockItemID int)
RETURNS INT
 ---возвращает сколько раз был куплен товар
AS
BEGIN
	DECLARE @PurchasingAmount int = 0;
	SET @PurchasingAmount = (SELECT count(il.StockItemID) as Amount FROM [Sales].[InvoiceLines] il 
							WHERE il.StockItemID = @StockItemID)
)
RETURN @PurchasingAmount;
END;

select [Sales].udf_StockItemPurchasingAmount(42);


-------------------
CREATE OR ALTER PROCEDURE [Sales].udp_StockItemPurchasingAmount 
	@StockItemID INT = 1, 	
	@c INT = 0 OUT
--WITH TRANSACTION ISOLATION LEVEL =  SNAPSHOT
AS
	SET NOCOUNT ON;
	SET @c = (SELECT count(il.StockItemID) as Amount
					FROM [Sales].[InvoiceLines] il 
				WHERE il.StockItemID = @StockItemID)
	RETURN @C;
GO

--
DECLARE @c INT;
exec [Sales].udp_StockItemPurchasingAmount 42, @c out
PRINT @c

/*Функция выполняется быстрее хранимой процедуры в данном случае, потому как простой sql запрос и функция является скалярной
План запроса сформировался разный. Приложен в виде картинки
*/ 

/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/

CREATE OR ALTER FUNCTION [Sales].udf_GetCustomerDiscountByQnty(@CustomerID int)
RETURNS TABLE
AS
RETURN
---РАСЧИТЫВАЕТ ВЕЛИЧИНУ СКИДКИ ДЛЯ КЛИЕНТА, В ЗАВИСИМОСТИ ОТ КУПЛЕННОГО КОЛИЧЕСТВА И ТОВАРА
(
	SELECT  i.CustomerID, st.StockItemName, SUM(iv.Quantity) AS qnty, 
	CASE
	    WHEN SUM(iv.Quantity) < 50  THEN 0
		WHEN (SUM(iv.Quantity) >= 50 AND SUM(iv.Quantity) < 100) THEN 0.1
		WHEN SUM(iv.Quantity) >= 100 AND SUM(iv.Quantity) < 300 THEN 0.3
		ELSE 0.5 END as Discount 
	FROM [Sales].[Invoices] i 
		INNER JOIN [Sales].[InvoiceLines] iv
			ON i.InvoiceID = iv.InvoiceID	
		INNER JOIN [Warehouse].[StockItems] st
			ON iv.StockItemID = st.StockItemID
	WHERE i.CustomerID = @CustomerID
	GROUP BY  i.CustomerID, st.StockItemName
);
GO

SELECT c.CustomerName, Discount.StockItemName, Discount.Discount FROM [Sales].[Customers] c 
CROSS APPLY [Sales].udf_GetCustomerDiscountByQnty(c.CustomerID) AS Discount
ORDER BY c.CustomerName,  Discount.StockItemName

/*
5) Опционально. Во всех процедурах укажите какой уровень изоляции транзакций вы бы использовали и почему. 
*/
/*TRANSACTION ISOLATION LEVEL

Applies to: SQL Server 2014 (12.x) and later and Azure SQL Database.

Required for natively compiled stored procedures. Specifies the transaction isolation level for the stored procedure. The options are as follows:

For more information about these options, see SET TRANSACTION ISOLATION LEVEL (Transact-SQL).

REPEATABLE READ Specifies that statements cannot read data that has been modified but not yet committed by other transactions. 
If another transaction modifies data that has been read by the current transaction, the current transaction fails.

SERIALIZABLE Specifies the following:

Statements cannot read data that has been modified but not yet committed by other transactions.
If another transactions modifies data that has been read by the current transaction, the current transaction fails.
If another transaction inserts new rows with key values that would fall in the range of keys read by any statements in the current transaction, the current transaction fails.

SNAPSHOT Specifies that data read by any statement in a transaction is the transactionally consistent version of the data that existed at the start of the transaction.*/
/*Думаю, что прежде всего при выборе уровня изоляции от решаемой задачи

Но скорее всего бы выбрала SET TRANSACTION ISOLATION LEVEL SNAPSHOT;  

*/