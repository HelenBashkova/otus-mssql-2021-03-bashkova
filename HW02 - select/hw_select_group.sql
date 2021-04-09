/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

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
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

select si.StockItemID, si.StockItemName from Warehouse.StockItems si
where si.StockItemName like '%urgent%' OR si.StockItemName like 'Animal%' 

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

select s.SupplierID, s.SupplierName 
from Purchasing.Suppliers s
left join Purchasing.PurchaseOrders o
on s.SupplierID = o.SupplierID
where o.PurchaseOrderID IS NULL;

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

select o.OrderID, CONVERT(nvarchar(16), o.OrderDate, 104) as OrderDate, DATENAME(m, MONTH(o.OrderDate)) as OrderM, DATEPART(qq, o.OrderDate) as OrderQ,
case 
	when MONTH(o.OrderDate) between 1 and 4 then '1'
	when MONTH(o.OrderDate) between 5 and 8 then '2'
	when MONTH(o.OrderDate) between 9 and 12 then '3'
end as OrderD,
c.CustomerName 
from Sales.Orders o
inner join Sales.OrderLines ol
on o.OrderID = ol.OrderID
inner join Sales.Customers c
on o.CustomerID = c.CustomerID
where (ol.UnitPrice > 100 or ol.Quantity > 20) and o.PickingCompletedWhen is not null

----вариант с OFFSET

select o.OrderID, CONVERT(nvarchar(16), o.OrderDate, 104) as OrderDate, DATENAME(m, MONTH(o.OrderDate)) as OrderM, DATEPART(qq, o.OrderDate) as OrderQ,
case 
	when MONTH(o.OrderDate) between 1 and 4 then '1'
	when MONTH(o.OrderDate) between 5 and 8 then '2'
	when MONTH(o.OrderDate) between 9 and 12 then '3'
end as OrderD,
c.CustomerName from Sales.Orders o
inner join Sales.OrderLines ol
on o.OrderID = ol.OrderID
inner join Sales.Customers c
on o.CustomerID = c.CustomerID
where (ol.UnitPrice > 100 or ol.Quantity > 20) and o.PickingCompletedWhen is not null
order by 
	DATEPART(qq, o.OrderDate), 
	case 
		when MONTH(o.OrderDate) between 1 and 4 then '1'
		when MONTH(o.OrderDate) between 5 and 8 then '2'
		when MONTH(o.OrderDate) between 9 and 12 then '3'
	end,
	o.OrderDate
    OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

select dm.DeliveryMethodName, o.ExpectedDeliveryDate, s.SupplierName, p.FullName  
from Purchasing.PurchaseOrders o 
inner join Purchasing.Suppliers s on o.SupplierID = s.SupplierID
inner join Application.DeliveryMethods dm on o.DeliveryMethodID = dm.DeliveryMethodID
inner join Application.People p on o.ContactPersonID = p.PersonID
where (o.ExpectedDeliveryDate between '01-01-2013' and '31-01-2013') and 
(DeliveryMethodName = 'Air Freight' OR DeliveryMethodName = 'Refrigerated Air Freight') and o.IsOrderFinalized = 1

/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

select top 10 c.CustomerName, p.FullName as EmployeeName 
from Sales.Invoices i
inner join Sales.Customers c on i.CustomerID = c.CustomerID
inner join Application.People p on i.SalespersonPersonID = p.PersonID
order by i.InvoiceDate desc

/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

select i.CustomerID, c.CustomerName, c.PhoneNumber 
from Sales.Invoices i
inner join Sales.Customers c on i.CustomerID = c.CustomerID
inner join Sales.InvoiceLines il on i.InvoiceID = il.InvoiceID
inner join Warehouse.StockItems sti on il.StockItemID = sti.StockItemID
where sti.StockItemName = 'Chocolate frogs 250g'

/*
7. Посчитать среднюю цену товара, общую сумму продажи по месяцам
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select year(i.InvoiceDate) as [year], month(i.InvoiceDate) as [month], AVG(il.UnitPrice) as avgprice, SUM(il.UnitPrice*il.Quantity) as suminv
from Sales.Invoices i
inner join Sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
group by year(i.InvoiceDate), month(i.InvoiceDate)
order by year(i.InvoiceDate), month(i.InvoiceDate)

/*
8. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select year(i.InvoiceDate) as [year], month(i.InvoiceDate) as [month], SUM(il.UnitPrice*il.Quantity) as suminv
from Sales.Invoices i
inner join 
Sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
group by year(i.InvoiceDate), month(i.InvoiceDate)
having SUM(il.UnitPrice*il.Quantity) > 10000
order by year(i.InvoiceDate), month(i.InvoiceDate)

/*
9. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

select year(i.InvoiceDate) as y, month(i.InvoiceDate) as m, COALESCE(si.StockItemName, '') as prodname, SUM(il.Quantity*il.UnitPrice) as sumitm, MIN(i.InvoiceDate) as firstdate, SUM(il.Quantity) as qitm
from Sales.Invoices i
inner join 
Sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
inner join Warehouse.StockItems si
on il.StockItemID = si.StockItemID
group by cube(year(i.InvoiceDate), month(i.InvoiceDate), si.StockItemName) 
having SUM(il.Quantity) < 50
order by year(i.InvoiceDate), month(i.InvoiceDate) 

-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 8-9 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
---8
select ym.year as [year], ym.month as [month], COALESCE(suminv, 0) as suminv
from (select year(i.InvoiceDate) as [year], mnth.m as [month] from 
(VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS mnth(m)
, Sales.Invoices i group by year(i.InvoiceDate), mnth.m) ym 
left join 
(select year(i.InvoiceDate) as [year], month(i.InvoiceDate) as [month], SUM(il.UnitPrice*il.Quantity) as suminv
from Sales.Invoices i
inner join 
Sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
group by year(i.InvoiceDate), month(i.InvoiceDate)
having SUM(il.UnitPrice*il.Quantity) > 10000
) invs
on ym.year = invs.year and ym.month = invs.month
order by [year], [month]

--------9
select ymp.year, ymp.month, ymp.item, COALESCE(inv.sumitm,0) as sumitm, COALESCE(inv.firstdate, '1900-01-01') as firstfate, COALESCE(inv.qitm,0) as qitm
from
(select year(i.InvoiceDate) as [year], mnth.m as [month], si.StockItemName as item 
from 
(VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS mnth(m), Sales.Invoices i 
inner join
Sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
inner join Warehouse.StockItems si
on il.StockItemID = si.StockItemID
group by year(i.InvoiceDate), mnth.m, si.StockItemName
) ymp
left join
(select year(i.InvoiceDate) as y, month(i.InvoiceDate) as m, si.StockItemName as item, SUM(il.Quantity*il.UnitPrice) as sumitm, MIN(i.InvoiceDate) as firstdate, SUM(il.Quantity) as qitm
from
Sales.Invoices i
inner join 
Sales.InvoiceLines il
on i.InvoiceID = il.InvoiceID
inner join Warehouse.StockItems si
on il.StockItemID = si.StockItemID
group by cube(year(i.InvoiceDate), month(i.InvoiceDate), si.StockItemName) 
having SUM(il.Quantity) < 50) inv  
on ymp.year = inv.y and ymp.month=inv.m and ymp.item = inv.item 
order by ymp.year, ymp.month

