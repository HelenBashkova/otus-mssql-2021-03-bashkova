
EXEC sp_configure 'show advanced options', 1
RECONFIGURE;
EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;

USE WideWorldImporters

DROP FUNCTION IF EXISTS dbo.fn_MDYToDMY; 

DROP ASSEMBLY IF EXISTS MDYToDMYProject
GO
CREATE ASSEMBLY MDYToDMYProject FROM 'C:\Users\GGG\Desktop\LENA\otus-mssql-2021-03-bashkova\HW10 - CLR\MDYToDMYProject\bin\MDYToDMYProject.dll';  
GO  
  
CREATE FUNCTION dbo.fn_MDYToDMY(@date Nvarchar(10)) RETURNS Nvarchar(10)  
AS EXTERNAL NAME [MDYToDMYProject].[MDYToDMYProject.ClrFunction].MDYToDMY;   
GO  
 

 ----------------------------»—œŒÀ‹«Œ¬¿Õ»≈ 
SELECT dbo.fn_MDYToDMY('08/21/2021');  
GO  