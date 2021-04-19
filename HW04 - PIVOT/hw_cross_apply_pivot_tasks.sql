/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "05 - Операторы CROSS APPLY, PIVOT, UNPIVOT".

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
1. Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys.
Имя клиента нужно поменять так чтобы осталось только уточнение.
Например, исходное значение "Tailspin Toys (Gasport, NY)" - вы выводите только "Gasport, NY".
Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+-------------+--------------+------------
InvoiceMonth | Peeples Valley, AZ | Medicine Lodge, KS | Gasport, NY | Sylvanite, MT | Jessie, ND
-------------+--------------------+--------------------+-------------+--------------+------------
01.01.2013   |      3             |        1           |      4      |      2        |     2
01.02.2013   |      7             |        3           |      4      |      2        |     1
-------------+--------------------+--------------------+-------------+--------------+------------
*/

SELECT  
					FDATE,
                    ISNULL([Peeples Valley, AZ], 0) [Peeples Valley, AZ],
                    ISNULL([Medicine Lodge, KS], 0) [Medicine Lodge, KS], 
					ISNULL([Gasport, NY], 0) [Gasport, NY], 
					ISNULL([Sylvanite, MT], 0) [Sylvanite, MT],
					ISNULL([Jessie, ND],0) [Jessie, ND]
FROM
(SELECT CONVERT(VARCHAR(10), DATEADD(mm, DATEDIFF(mm, 0, I.InvoiceDate), 0), 104) AS FDATE, 
     SUBSTRING(c.CustomerName, CHARINDEX('(', c.CustomerName)+1, LEN(c.CustomerName)-(CHARINDEX('(', c.CustomerName)+1)) as customer,
	 count(i.InvoiceID) as quantity
FROM [Sales].[Invoices] i
INNER JOIN [Sales].[Customers] c
	ON i.CustomerID = c.CustomerID
WHERE c.CustomerId between 2 and 6
GROUP BY CONVERT(VARCHAR(10), DATEADD(mm, DATEDIFF(mm, 0, I.InvoiceDate), 0), 104), 
SUBSTRING(c.CustomerName, CHARINDEX('(', c.CustomerName)+1, LEN(c.CustomerName)-(CHARINDEX('(', c.CustomerName)+1))
) subq
PIVOT
(
SUM(subq.quantity) FOR customer IN ([Peeples Valley, AZ],  [Medicine Lodge, KS], [Gasport, NY],  [Sylvanite, MT], [Jessie, ND])
) AS PivotTable;

/*
2. Для всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

Пример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

SELECT CustomerName, AddressLine 
FROM
	(SELECT c.CustomerName, c.DeliveryAddressLine1, c.DeliveryAddressLine2 FROM [Sales].[Customers] c
		WHERE c.CustomerName LIKE 'Tailspin Toys%') AS cst
UNPIVOT (AddressLine FOR [Address] IN (DeliveryAddressLine1, DeliveryAddressLine2)) AS unpt;


/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/


SELECT CountryID, CountryName, Code 
FROM
	(SELECT C.CountryID, C.CountryName, C.IsoAlpha3Code, CAST(C.IsoNumericCode AS nvarchar(3)) AS IsoNCode FROM [Application].[Countries] C) AS CNTR
UNPIVOT (Code FOR IsoCode IN (IsoAlpha3Code, IsoNCode)) AS UNPT;


/*
4. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

SELECT c.CustomerID, c.CustomerName, Ord.StockItemID, Ord.UnitPrice, ord.OrderDate
FROM Sales.Customers c
CROSS APPLY (SELECT TOP 2 ol.StockItemID, ol.UnitPrice, o.OrderDate 
                FROM Sales.OrderLines ol
				INNER JOIN Sales.Orders o
					ON ol.OrderID = o.OrderID
                WHERE o.CustomerID =  c.CustomerID					
                ORDER BY ol.UnitPrice DESC) AS Ord
ORDER BY c.CustomerName, Ord.UnitPrice, ord.StockItemID;

