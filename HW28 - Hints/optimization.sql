/*
1. Убрать из Where DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 

2. Убрать из Where коррелирующий подзапрос (Select SupplierId FROM Warehouse.StockItems AS It Where It.StockItemID = det.StockItemID) = 12 
   Заменила подзапрос на inner join c Warehouse.StockItems  c фильтором в соединении
  
3. Убрать из Where коррелирующий подзапрос  

	SELECT SUM(Total.UnitPrice*Total.Quantity) FROM Sales.OrderLines AS Total 
	--		Join Sales.Orders AS ordTotal 
	--			On ordTotal.OrderID = Total.OrderID 
	--	WHERE ordTotal.CustomerID = Inv.CustomerID
	--) > 250000 AND DATEDIFF(dd, Inv.InvoiceDate, ord.OrderDate) = 0 
	функцию заменила сравнением дат в inner join c CTE
Заменила на CTE TotalPrice с оконной функцтей расчета сумм  и inner join
*/


----Было

(3619 rows affected)
Таблица "StockItemTransactions". Число просмотров 1, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 29, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "StockItemTransactions". Считано сегментов 1, пропущено 0.
Таблица "OrderLines". Число просмотров 4, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 331, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "OrderLines". Считано сегментов 2, пропущено 0.
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "CustomerTransactions". Число просмотров 5, логических чтений 261, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Orders". Число просмотров 2, логических чтений 883, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Invoices". Число просмотров 1, логических чтений 44525, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "StockItems". Число просмотров 1, логических чтений 2, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.

(1 row affected)

 Время работы SQL Server:
   Время ЦП = 484 мс, затраченное время = 14008 мс.
Время синтаксического анализа и компиляции SQL Server: 
 время ЦП = 0 мс, истекшее время = 0 мс.

 Время работы SQL Server:
   Время ЦП = 0 мс, затраченное время = 0 мс.

Completion time: 2021-08-07T23:27:19.5745514+03:00


/**Стало **/


(3619 rows affected)
Таблица "StockItemTransactions". Число просмотров 1, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 29, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "StockItemTransactions". Считано сегментов 1, пропущено 0.
Таблица "OrderLines". Число просмотров 4, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 331, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "OrderLines". Считано сегментов 2, пропущено 0.
Таблица "Worktable". Число просмотров 0, логических чтений 0, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "CustomerTransactions". Число просмотров 5, логических чтений 261, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Invoices". Число просмотров 1, логических чтений 11400, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "Orders". Число просмотров 2, логических чтений 883, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.
Таблица "StockItems". Число просмотров 1, логических чтений 2, физических чтений 0, упреждающих чтений 0, lob логических чтений 0, lob физических чтений 0, lob упреждающих чтений 0.

(1 row affected)

 Время работы SQL Server:
   Время ЦП = 328 мс, затраченное время = 498 мс.
Время синтаксического анализа и компиляции SQL Server: 
 время ЦП = 0 мс, истекшее время = 0 мс.
 
 ------------------------------ Новый  запрос
use WideWorldImporters;
set statistics io on;
set statistics time on;

WITH TotalPrice(CustomerID, TPrice)
AS
(
	SELECT DISTINCT ordTotal.CustomerID, SUM(Total.UnitPrice*Total.Quantity) OVER (PARTITION BY ordTotal.CustomerID) TPrice
	FROM Sales.OrderLines AS Total 
		Join Sales.Orders AS ordTotal 
			On ordTotal.OrderID = Total.OrderID 			
)

SELECT ord.CustomerID, det.StockItemID, SUM(det.UnitPrice) SumPrice, SUM(det.Quantity) SumQuant, COUNT(ord.OrderID) OrderCount
FROM Sales.Orders AS ord 
JOIN Sales.OrderLines AS det 
	ON det.OrderID = ord.OrderID 
JOIN Sales.Invoices AS Inv 
	ON Inv.OrderID = ord.OrderID AND Inv.InvoiceDate = ord.OrderDate
JOIN Sales.CustomerTransactions AS Trans 
	ON Trans.InvoiceID = Inv.InvoiceID 
JOIN Warehouse.StockItemTransactions AS ItemTrans 
	ON ItemTrans.StockItemID = det.StockItemID 
INNER JOIN  Warehouse.StockItems AS It
	ON It.StockItemID = det.StockItemID 
INNER JOIN TotalPrice TP 
	ON Inv.CustomerID = TP.CustomerID AND TPrice > 250000  
WHERE Inv.BillToCustomerID != ord.CustomerID AND It.SupplierID= 12 
GROUP BY ord.CustomerID, det.StockItemID 
ORDER BY ord.CustomerID, det.StockItemID

