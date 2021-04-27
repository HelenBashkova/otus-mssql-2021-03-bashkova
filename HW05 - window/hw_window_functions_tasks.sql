/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

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
-- ---------------------------------------------------------------------------

USE WideWorldImporters
/*
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/
SET STATISTICS TIME, IO ON;

WITH IlSale ([InvoiceID], InvoiceDate, IlSum)
AS
(
SELECT i.[InvoiceID],i.[InvoiceDate], SUM(il.[Quantity]*il.[UnitPrice]) as IlSum 
FROM [Sales].[Invoices] i
INNER JOIN [Sales].[InvoiceLines] il
	ON i.[InvoiceID] = il.[InvoiceID]
WHERE i.[InvoiceDate] between '2015-01-01' and '2015-12-31' --and i.InvoiceID=39321
GROUP BY i.[InvoiceID], i.[InvoiceDate]
)
,
MnthSum (yr, mnth, mnthsum)
AS
(
SELECT  year(InvoiceDate) as yr, month(InvoiceDate) as mnth, SUM(IlSum) as mntsum FROM IlSale
GROUP BY year(InvoiceDate), month(InvoiceDate)
) 
SELECT Inv.InvoiceID, Inv.CustomerName, Inv.InvoiceDate, TotalByMonth.TOTAL --c.CustomerID, c.[CustomerName], TOTAL
FROM 
(
	SELECT s.mnth, s.mnthsum, COALESCE(SUM(t2.mnthsum), 0) AS TOTAL
	FROM MnthSum  s
	INNER JOIN MnthSum t2
		 ON t2.mnth <= s.mnth
	GROUP BY s.mnth , s.mnthsum
) TotalByMonth 
CROSS APPLY
(
	SELECT i.InvoiceID, i.InvoiceDate, c.CustomerName FROM [Sales].[Invoices] i
	INNER JOIN [Sales].[Customers] c
		ON i.CustomerID = c.CustomerID
	WHERE month(i.InvoiceDate) = TotalByMonth.mnth AND i.[InvoiceDate] between '2015-01-01' and '2015-12-31'
) Inv
ORDER BY Inv.InvoiceDate;
/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/
WITH IlSale ([InvoiceID], InvoiceDate, IlSum)
AS
(
SELECT i.[InvoiceID],i.[InvoiceDate], SUM(il.[Quantity]*il.[UnitPrice]) as IlSum 
FROM [Sales].[Invoices] i
INNER JOIN [Sales].[InvoiceLines] il
	ON i.[InvoiceID] = il.[InvoiceID]
WHERE i.[InvoiceDate] between '2015-01-01' and '2015-12-31' --and i.InvoiceID=39321
GROUP BY i.[InvoiceID], i.[InvoiceDate]
)
SELECT IlS.InvoiceID, c.[CustomerName], IlS.InvoiceDate, SUM(IlS.IlSum) OVER (ORDER BY MONTH(i.[InvoiceDate])) AS MNTHS
FROM IlSale IlS
INNER JOIN  [Sales].[Invoices] i
	ON IlS.InvoiceID = i.InvoiceID AND i.[InvoiceDate] BETWEEN '2015-01-01' and '2015-12-31' 
INNER JOIN [Sales].[Customers] c
	ON i.[CustomerID]=c.[CustomerID]
ORDER BY I.[InvoiceDate], i.InvoiceID
----------------
/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/
---
SELECT sub.MNTH, itms.StockItemID, itms.StockItemName, sub.TopQ FROM
(
	SELECT MONTH(i.InvoiceDate) AS MNTH, il.StockItemID, COUNT(il.Quantity) AS TopQ, 
			ROW_NUMBER() OVER(PARTITION BY MONTH(i.InvoiceDate) ORDER BY COUNT(il.Quantity) DESC) AS RN
	FROM [Sales].[Invoices] i
	INNER JOIN [Sales].[InvoiceLines] il
		ON i.InvoiceID = il.InvoiceID
	WHERE i.InvoiceDate BETWEEN '2016-01-01' AND '2016-12-31'
	GROUP BY  MONTH(i.InvoiceDate), il.StockItemID
) sub
INNER JOIN [Warehouse].[StockItems] itms
	ON sub.StockItemID = itms.StockItemID
WHERE sub.RN <=2
ORDER BY MNTH, TopQ DESC

/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

SELECT si.StockItemID, si.[StockItemName],
	ROW_NUMBER() OVER(PARTITION BY LEFT(si.[StockItemName],1) ORDER BY si.[StockItemName]) AS RN, 
	COUNT([StockItemID]) OVER() AS CNT,
	COUNT(LEFT(si.[StockItemName],1)) OVER(PARTITION BY LEFT(si.[StockItemName],1)) CNTLETTER,
	LEAD(si.StockItemID, 1, 0) OVER(ORDER BY si.[StockItemName]) AS NXT,
	LAG(si.StockItemID, 1, 0) OVER(ORDER BY si.[StockItemName]) AS PREV,
	LAG(si.[StockItemName], 2, 'No items') OVER(ORDER BY si.[StockItemName]) AS PREV2,
	NTILE(30) OVER (ORDER BY si.[TypicalWeightPerUnit]) as NTILE30
FROM [Warehouse].[StockItems] si
ORDER BY si.[StockItemName]

/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

WITH SalesPersons (Id, FullName)
AS
(
	SELECT DISTINCT p.PersonID, p.FullName FROM [Application].[People] p 
	WHERE p.IsSalesperson = 1
)
,
AmountOfSaleByInvId (InvoiceID, AmountOfSaleByInv)
AS
(
	SELECT InvoiceID, SUM([Quantity]*[UnitPrice]) AS AmountOfSaleByInv FROM [Sales].[InvoiceLines] il
	GROUP BY InvoiceID	
)
,
LastDateOfSale (SalespersonPersonID, MAXDate)
AS
(
	SELECT i.[SalespersonPersonID], MAX(i.InvoiceDate) FROM [Sales].[Invoices] i
	GROUP BY i.[SalespersonPersonID]
)
,
InvId (InvoiceID)
AS
(
	SELECT distinct LAST_VALUE(i.InvoiceID) OVER(PARTITION BY i.SalespersonPersonID ORDER BY i.InvoiceDate)		
	FROM [Sales].[Invoices] i
	INNER JOIN LastDateOfSale ls
		ON i.InvoiceDate = ls.MAXDate AND i.SalespersonPersonID = ls.SalespersonPersonID
)
SELECT i.InvoiceID, sp.Id, sp.FullName, c.CustomerID, c.CustomerName, i.InvoiceDate, asli.AmountOfSaleByInv	
FROM [Sales].[Invoices] i
INNER JOIN SalesPersons sp
    ON sp.ID = i.SalespersonPersonID
INNER JOIN [Sales].[Customers] c
	ON i.CustomerID = c.CustomerID
INNER JOIN AmountOfSaleByInvId asli
	ON asli.InvoiceID = i.InvoiceID
WHERE i.InvoiceID IN (SELECT InvoiceID FROM InvId)
ORDER BY sp.FullName

/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

WITH ItemsRange (StockItemID, CustomerID,  RN, UnitPrice, InvoiceDate)
AS
(
	SELECT il.StockItemID, i.CustomerID, ROW_NUMBER() OVER(PARTITION BY i.CustomerID ORDER BY il.UnitPrice DESC) rn, il.UnitPrice, i.InvoiceDate
	FROM [Sales].[Invoices] i
	INNER JOIN [Sales].[InvoiceLines] il
		ON i.InvoiceID = il.InvoiceID
		
)
SELECT c.CustomerID, c.CustomerName, itms.[StockItemID], itms.[StockItemName], ir.UnitPrice, ir.InvoiceDate FROM ItemsRange ir 
INNER JOIN [Sales].[Customers] c
	ON ir.CustomerID = c.CustomerID
INNER JOIN [Warehouse].[StockItems] itms
	ON ir.StockItemID = itms.StockItemID
WHERE RN <=2
ORDER BY CustomerID

Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность. 