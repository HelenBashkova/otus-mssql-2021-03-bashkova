/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

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
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Опционально - если вы знакомы с insert, update, merge, то загрузить эти данные в таблицу Warehouse.StockItems.
Существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 
*/

DECLARE @XMLDoc XML
DECLARE @CurrDate DATETIME2 = GETDATE(), @LastEditedBy int = 1

SELECT @XMLDoc = BulkColumn FROM OPENROWSET(BULK 'C:\Users\GGG\Desktop\LENA\otus-mssql-2021-03-bashkova\HW07 - xml-json\StockItems.xml', single_clob) as data;

--SELECT @XMLDoc as [@xmlDocument]

DECLARE @DocHandle int
EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XMLDoc

-- docHandle - это просто число
--SELECT @DocHandle as docHandle

IF object_id('tempdb.dbo.#XMLData') is not null
	DROP TABLE #XMLData

CREATE TABLE #XMLData 
(
	StockItemName nvarchar(100) COLLATE Latin1_General_100_CI_AS,
	SupplierID int,
	UnitPackageID int,
	OuterPackageID int,
	QuantityPerOuter int,
	TypicalWeightPerUnit decimal(18,3),
	LeadTimeDays int,
	IsChillerStock bit,
	TaxRate decimal(18,3),
	UnitPrice decimal(18,3)	
)

INSERT INTO #XMLData
SELECT StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 
FROM OPENXML(@docHandle, N'StockItems/Item')
WITH (
	[StockItemName] nvarchar(100) '@Name',
	[SupplierID] int 'SupplierID',
	[UnitPackageID] int 'Package/UnitPackageID',
	[OuterPackageID] int 'Package/OuterPackageID',
	[QuantityPerOuter] int 'Package/QuantityPerOuter',
	[TypicalWeightPerUnit] decimal(18,3) 'Package/TypicalWeightPerUnit',
	[LeadTimeDays] int 'LeadTimeDays',
	[IsChillerStock] bit 'IsChillerStock',
	[TaxRate] decimal(18,3) 'TaxRate',
	[UnitPrice] decimal(18,3) 'UnitPrice')


 MERGE Warehouse.StockItems AS target  
    USING (
	    SELECT StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice
		FROM #XMLData 
	) AS source (StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice)  
    ON (target.StockItemName = source.StockItemName COLLATE Latin1_General_100_CI_AS)  
    WHEN MATCHED THEN
        UPDATE SET TaxRate = source.TaxRate,
				   UnitPrice = source.UnitPrice
    WHEN NOT MATCHED THEN  
        INSERT 
			(
				StockItemName,
				SupplierID, 
				UnitPackageID, 
				OuterPackageID, 
				QuantityPerOuter, 
				TypicalWeightPerUnit, 
				LeadTimeDays, 
				IsChillerStock, 
				TaxRate, 
				UnitPrice, 
				LastEditedBy, 
				ValidFrom, 
				ValidTo
			)  
        VALUES 
			(
			   	source.StockItemName,
				source.SupplierID,
				source.UnitPackageID,
				source.OuterPackageID,
				source.QuantityPerOuter,
				source.TypicalWeightPerUnit,
				source.LeadTimeDays,
				source.IsChillerStock,
				source.TaxRate,
				source.UnitPrice,
				@LastEditedBy,
				default,
				default
			);
   -- OUTPUT $action, deleted.*, inserted.*;  

EXEC sp_xml_removedocument @DocHandle;


/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
*/

SELECT 
	[StockItemName] AS '@Name',
	[SupplierID] AS 'SupplierID',
	[UnitPackageID] AS 'Package/UnitPackageID',
	[OuterPackageID] AS 'Package/OuterPackageID',
	[QuantityPerOuter] AS 'Package/QuantityPerOuter',
	[TypicalWeightPerUnit] AS 'Package/TypicalWeightPerUnit',
	[LeadTimeDays] AS 'LeadTimeDays',
	[IsChillerStock] AS 'IsChillerStock',
	[TaxRate] AS 'TaxRate',
	[UnitPrice] AS 'UnitPrice'
FROM [Warehouse].[StockItems]
FOR XML PATH ('Item'), ROOT ('StockItems')
--------------------------
DECLARE @XmlTitle AS VARCHAR(MAX)= '<?xml version="1.0" encoding="UTF-8"?>'
	
   -- SET @command= 'bcp "SELECT TOP 1 [Code] from  [tec_Dev].[dbo].[MasterXml] where PurchaseOrderID='+          
        -- CAST( @PurchaseOrderID As varchar(20))+'" queryout '            
         -- +@uploadFolder + CAST(@PurchaseOrderID AS varchar(20))+'.xml' +' -T -N -c -C65001'
    SET @command = 'bcp "SELECT '+@XmlTitle+'"[StockItemName] AS \'@Name\', [SupplierID] AS \'SupplierID\', [UnitPackageID] AS \'Package/UnitPackageID\', [OuterPackageID] AS \'Package/OuterPackageID\', [QuantityPerOuter] AS \'Package/QuantityPerOuter\', [TypicalWeightPerUnit] AS \'Package/TypicalWeightPerUnit\', [LeadTimeDays] AS \'LeadTimeDays\', [IsChillerStock] AS \'IsChillerStock\', [TaxRate] AS \'TaxRate\', [UnitPrice] AS \'UnitPrice\' FROM [Warehouse].[StockItems] FOR XML PATH (\'Item\'), ROOT (\'StockItems\')" queryout res.xml -d WideWorldImporters -x -c -T'
    print @command

EXEC xp_cmdshell @command 
/*
3. В таблице Warehouse.StockItems  колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

SELECT [StockItemID], [StockItemName], JSON_VALUE(CustomFields,'$.CountryOfManufacture') AS CountryOfManufacture,  JSON_VALUE(CustomFields,'$.Tags[0]') AS FirstTag 
FROM [Warehouse].[StockItems]

/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

SELECT [StockItemID], [StockItemName], JSON_QUERY(CustomFields,'$.Tags') AS Tags
FROM [Warehouse].[StockItems]
	CROSS APPLY OPENJSON(CustomFields,'$.Tags') AS Tags
WHERE Tags.Value='Vintage'

