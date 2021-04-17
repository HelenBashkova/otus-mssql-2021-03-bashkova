/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

SELECT p.PersonID, p.FullName
FROM [Application].[People] p
WHERE  p.IsSalesPerson = 1 AND p.PersonID NOT IN 
(SELECT i.SalespersonPersonID 
	FROM [Sales].[Invoices] i
	WHERE [InvoiceDate] = '2015-07-04');
	
	
	
SELECT p.PersonID, p.FullName
FROM [Application].[People] p
WHERE  p.IsSalesPerson = 1 AND NOT EXISTS
(SELECT *
	FROM [Sales].[Invoices] i
	WHERE [InvoiceDate] = '2015-07-04' AND i.SalespersonPersonID = p.PersonID);

/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

SELECT itm.StockItemID, itm.StockItemName, itm.UnitPrice 
FROM [Warehouse].[StockItems] itm
WHERE itm.UnitPrice = (SELECT TOP 1 min(UnitPrice) FROM [Warehouse].[StockItems])

---2 ВАРИАНТ 
SELECT itm.StockItemID, itm.StockItemName, itm.UnitPrice 
FROM [Warehouse].[StockItems] itm
WHERE itm.UnitPrice = ALL (SELECT min(UnitPrice) FROM [Warehouse].[StockItems])

/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

SELECT c.CustomerID, c.CustomerName FROM [Sales].[Customers] c
WHERE c.CustomerID IN 
	(SELECT TOP 5 CustomerID FROM Sales.CustomerTransactions t ORDER BY t.TransactionAmount desc)
-----------------
SELECT c.CustomerID, c.CustomerName FROM [Sales].[Customers] c
INNER JOIN (SELECT TOP 5 CustomerID FROM Sales.CustomerTransactions t ORDER BY t.TransactionAmount desc) Top5Trans
	on c.CustomerID  =  Top5Trans.CustomerID;
--------------
WITH Top5Trans (CustomerID)
AS
(
	SELECT TOP 5 CustomerID FROM Sales.CustomerTransactions t ORDER BY t.TransactionAmount desc
)
SELECT c.CustomerID, c.CustomerName FROM [Sales].[Customers] c
INNER JOIN Top5Trans t
	ON c.CustomerID = t.CustomerID

/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/

WITH NumberedStockItems 
AS
(
	SELECT si.StockItemID, si.UnitPrice, Row_NUMBER() OVER (ORDER BY si.UnitPrice DESC) AS RN 
			FROM [Warehouse].[StockItems] si		
)
,
Top3StockItems (StockItemID)
AS
(
	SELECT StockItemID FROM NumberedStockItems WHERE RN <=3
)
SELECT DISTINCT ct.CityID,ct.CityName, p.FullName, tsi.StockItemID FROM [Sales].[Orders] o
INNER JOIN [Sales].[OrderLines] ol
	ON O.OrderID = ol.OrderID
INNER JOIN Top3StockItems tsi
	ON ol.StockItemID = tsi.StockItemID
INNER JOIN [Sales].[Customers] c
	ON  o.CustomerID = c.CustomerID
INNER JOIN [Application].[Cities] ct
	ON c.DeliveryCityID = ct.CityID
INNER JOIN [Application].[People] p
	ON  o.[PickedByPersonID] = p.PersonID
ORDER BY ct.CityID,ct.CityName, p.FullName, tsi.StockItemID


-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

--------------------------------------
/*
Выбирает данные отсортированные по убыванию общей суммы по счёту-фактуре, с указанием InvoiceID, дата счета-фактуры, имени сотрудника, 
который оформил заказ, итоговой сумма по счету-фактуре, общей суммы, выбранных позиций товаров,
где общая сумма счёта-фактуры превышает 27000

*/
--------------------------------------

WITH SalesPerson (SalesPersonID, SalesPersonName)
AS
(
	SELECT p.PersonID as SalesPersonID, p.FullName as SalesPersonName
		FROM Application.People p		
)
,
PickingCompleteOrders (OrderId)
AS
(
	SELECT o.OrderId 
			FROM Sales.Orders o			
			WHERE o.PickingCompletedWhen IS NOT NULL
)
,
TotalSummForPickedItems (OrderId, TotalSumForPickedItems) 
AS
(
	SELECT ol.OrderId, SUM(ol.PickedQuantity*ol.UnitPrice) AS TotalSumForPickedItems
		FROM Sales.OrderLines ol
		GROUP BY ol.OrderId 
),
SalesTotals (InvoiceId, TotalSumm) 
AS
(
	SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
		FROM Sales.InvoiceLines
		GROUP BY InvoiceId
		HAVING SUM(Quantity*UnitPrice) > 27000
)
SELECT 
	i.InvoiceID, 
	i.InvoiceDate,	
	sp.SalesPersonName,
	st.TotalSumm AS TotalSummByInvoice,	
	tsmp.TotalSumForPickedItems
FROM Sales.Invoices	i
	INNER JOIN SalesPerson sp
		ON sp.SalesPersonID = i.SalespersonPersonID	
	INNER JOIN SalesTotals st
		ON i.InvoiceID = st.InvoiceID
	INNER JOIN PickingCompleteOrders pco
		ON i.OrderID = pco.OrderId
	INNER JOIN TotalSummForPickedItems tsmp
		ON pco.OrderId = tsmp.OrderId
ORDER BY TotalSumm DESC

