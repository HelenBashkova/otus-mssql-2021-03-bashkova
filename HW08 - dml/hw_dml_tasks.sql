/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

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
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/

DECLARE @CDate DATETIME2  = GETDATE();
INSERT INTO [Sales].[Customers]
 (
      [CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy]
      ,[ValidFrom]
      ,[ValidTo]
)
VALUES
('Benton, John B Jr', (SELECT CAST(current_value AS INT) FROM sys.sequences WHERE name = 'CustomerID'), 7, 2, 2, NULL, 1, 24062, 24062, NULL, @CDate, 0.000, 0, 0, 7, '(504)621-8927', '(504)845-1427', NULL, NULL, 'http://www.bentonjohnbjr.com', '6649 N Blue Gum St, New Orleans', NULL, 70116, NULL, '6649 N Blue Gum St, New Orleans', NULL,  70116, 1, DEFAULT, DEFAULT),
('Chanay, Jeffrey A Esq', (SELECT CAST(current_value AS INT) FROM sys.sequences WHERE name = 'CustomerID'), 7, 2, 2, NULL, 1, 4054, 4054, NULL, @CDate, 0.000, 0, 0, 7, '(810)292-9388', '(810)374-9840', NULL, NULL, 'http://www.chanayjeffreyaesq.com', '4 B Blue Ridge Blvd, Brighton', NULL, 48116, NULL, '4 B Blue Ridge Blvd, Brighton', NULL,  48116, 1, DEFAULT, DEFAULT),
('Chemel, James L Cpa', (SELECT CAST(current_value AS INT) FROM sys.sequences WHERE name = 'CustomerID'), 7, 2, 2, NULL, 1, 4003, 4003, NULL, @CDate, 0.000, 0, 0, 7, '(856)636-8749','(856)264-4130', NULL, NULL, 'http://www.chemeljameslcpa.com', '8 W Cerritos Ave #54', NULL, 08014, NULL, '8 W Cerritos Ave #54', NULL, 08014, 1, DEFAULT, DEFAULT),
('Feltz Printing Service', (SELECT CAST(current_value AS INT) FROM sys.sequences WHERE name = 'CustomerID'), 7, 2, 2, NULL, 1, 798, 798, NULL, @CDate, 0.000, 0, 0, 7, '(907)385-4412','(907)921-2010', NULL, NULL, 'http://www.feltzprintingservice.com', '639 Main St, Anchorage', NULL, 99501, NULL, '639 Main St, Anchorage', NULL, 99501, 1, DEFAULT, DEFAULT),
('Printing Dimensions', (SELECT CAST(current_value AS INT) FROM sys.sequences WHERE name = 'CustomerID'), 7, 2, 2, NULL, 1, 14401, 14401, NULL, @CDate, 0.000, 0, 0, 7, '(513)570-1893', '(513)549-4561', NULL, NULL, 'http://www.printingdimensions.com', '34 Center St, Hamilton',  NULL, 45011, NULL, '34 Center St, Hamilton', NULL, 45011, 1, DEFAULT, DEFAULT)

/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

DELETE FROM [Sales].[Customers] WHERE CustomerName = 'Benton, John B Jr'


/*
3. Изменить одну запись, из добавленных через UPDATE
*/

UPDATE [Sales].[Customers] 
SET 
	[DeliveryAddressLine1] = '8 W Cerritos Ave #54, Bridgeport',
	[DeliveryAddressLine2] = '8 W Cerritos Ave #54, Bridgeport'
WHERE CustomerName = 'Chemel, James L Cpa'

/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/

DECLARE @CDate DATETIME2  = GETDATE();
MERGE INTO [Sales].[Customers] AS Target 
USING 
(
VALUES
	('Benton, John B Jr', -1, 7, 2, 2, NULL, 1, 24062, 24062, NULL, @CDate, 0.000, 0, 0, 7, '(504)621-8927', '(504)845-1427', NULL, NULL, 'http://www.bentonjohnbjr.com',    '6649 N Blue Gum St, New Orleans',   NULL, 70116, NULL, '6649 N Blue Gum St, New Orleans', NULL,  70116, 1), --, DEFAULT, DEFAULT),
	('Industrial Paper Shredders Inc', -1, 7, 2, 2, NULL, 1, 11094, 11094,  NULL, @CDate, 0.000, 0, 0, 7, '(703)235-3937','(703)475-7568', NULL, NULL, 'http://www.industrialpapershreddersinc.com', '64 5th Ave #1153, Fairfax', NULL, 22102, NULL, '64 5th Ave #1153, Fairfax', NULL, 22102, 1)--, DEFAULT, DEFAULT)
) AS Source ([CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy])     
ON Target.CustomerName = Source.CustomerName 
WHEN MATCHED THEN 
UPDATE SET
	[DeliveryAddressLine2] = Source.[DeliveryAddressLine1],
	[BillToCustomerID] = [CustomerID]
WHEN NOT MATCHED BY TARGET THEN  
INSERT ([CustomerName]
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy])
  VALUES (Source.[CustomerName]
      ,(SELECT CAST(current_value AS INT) FROM sys.sequences WHERE name = 'CustomerID')
      ,Source.[CustomerCategoryID]
      ,Source.[BuyingGroupID]
      ,Source.[PrimaryContactPersonID]
      ,Source.[AlternateContactPersonID]
      ,Source.[DeliveryMethodID]
      ,Source.[DeliveryCityID]
      ,Source.[PostalCityID]
      ,Source.[CreditLimit]
      ,Source.[AccountOpenedDate]
      ,Source.[StandardDiscountPercentage]
      ,Source.[IsStatementSent]
      ,Source.[IsOnCreditHold]
      ,Source.[PaymentDays]
      ,Source.[PhoneNumber]
      ,Source.[FaxNumber]
      ,Source.[DeliveryRun]
      ,Source.[RunPosition]
      ,Source.[WebsiteURL]
      ,Source.[DeliveryAddressLine1]
      ,Source.[DeliveryAddressLine2]
      ,Source.[DeliveryPostalCode]
      ,Source.[DeliveryLocation]
      ,Source.[PostalAddressLine1]
      ,Source.[PostalAddressLine2]
      ,Source.[PostalPostalCode]
      ,Source.[LastEditedBy])
 OUTPUT $action, deleted.*, inserted.*;   

/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

--напишите здесь свое решение

DECLARE @command AS sysname
DECLARE @source AS VARCHAR(200)='[WideWorldImporters].[Sales].[Customers]'
DECLARE @target AS VARCHAR(MAX) =  'C:\Lena\customers.txt'
DECLARE @result int;  
	
SET @command = 'bcp '+ @source +' out "'+ @target + '" -T -c'
    

EXEC @result = xp_cmdshell  @command, NO_OUTPUT
IF (@result = 0)  
   PRINT 'Success'  
ELSE  
   PRINT 'Failure';  
GO

-------------------------------
SELECT *
INTO    [Sales].[Customers_new]
FROM    [Sales].[Customers]
WHERE 1=0

BULK INSERT [Sales].[Customers_new]
FROM 'C:\Lena\customers.txt