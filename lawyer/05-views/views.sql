USE [Lawyer]
GO
/****** Object:  View [RefData].[vInsurers]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [RefData].[vInsurers]  
WITH SCHEMABINDING 
AS  
	SELECT [InsurerID], [InsurerRegNum], [InsurerShortName]  as Name FROM [RefData].[Insurer] JurInsurer
	WHERE JurInsurer.InsurerFirstName IS NULL AND JurInsurer.InsurerLastName IS NULL
	UNION ALL
	SELECT [InsurerID], [InsurerRegNum], CONCAT_WS(' ',[InsurerLastName], [InsurerFirstName],  [InsurerMiddleName])  as Name  FROM [RefData].[Insurer] IndivInsurer
	WHERE IndivInsurer.InsurerFullName IS NULL
GO
/****** Object:  View [RefData].[vInsurerFile]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [RefData].[vInsurerFile]
AS
	SELECT insfl.[InsurerFileID], ins.[InsurerRegNum], ins.[Name], insfl.[InsurerFileINumber], insfl.[InsurerFileYear] 
	FROM [JurCase].[InsurerFile] insfl
	INNER JOIN [RefData].[vInsurers] ins
		ON insfl.[InsurerID] = ins.[InsurerID]
GO
/****** Object:  View [RefData].[vEmployee]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     VIEW [RefData].[vEmployee]
WITH SCHEMABINDING
AS
SELECT [EmployeeID], CONCAT_WS(' ', [EmployeeLastName], [EmployeeFirstName],[EmployeeMiddleName]) AS FullName, [EmployeeDOB], d.DepartmentName, p.PostName 
FROM [RefData].[Employee] e
INNER JOIN [RefData].[Department] d
	ON e.DepartmentID = d.DepartmentID
INNER JOIN [RefData].[Post] p
	ON e.PostID = p.PostID
GO
/****** Object:  View [RefData].[vDocBase]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--/****** Object:  View [RefData].[vDocBase]    Script Date: 19.08.2021 22:01:49 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE   VIEW [RefData].[vDocBase]
WITH SCHEMABINDING
AS
	WITH ParentDocBase(DocBaseID,  Number, DocBaseSum, [Date], ParentDocBaseFull)
AS
(
	 SELECT dbp.[DocBaseID],  dbp.[Number], dbp.[DocBaseSum], dbp.[Date], CONCAT_WS(' от ', CONCAT_WS(' №', dt.DocTypeName, dbp.[Number]), dbp.[Date]) as ParentDocBase
	 FROM [RefData].[DocBase] dbp
	 INNER JOIN [RefData].[DocType] dt
		ON dbp.DocTypeID = dt.DocTypeID
	WHERE dbp.ParentDocBaseID = 0
)

SELECT db.[DocBaseID],  db.[Number]      
      , db.[DocBaseSum], db.Date
      , db.[ParentDocBaseID]
      , db.[InsurerID], --db.DocTypeID,
	  dt.DocTypeName, CONCAT_WS(' от ', CONCAT_WS(' №', dt.DocTypeName, db.[Number]), db.[Date]) AS DocFull, ParentDocBaseFull, i.Name 
	FROM [RefData].[DocBase] db 
	INNER JOIN [RefData].[DocType] dt
		ON db.[DocTypeID] = dt.DocTypeID
	INNER JOIN [RefData].[vInsurers] i
		ON db.InsurerID = i.InsurerID
	LEFT JOIN ParentDocBase pdb 
		ON db.ParentDocBaseID = pdb.DocBaseID
GO
/****** Object:  View [JurCase].[vDocOutActualState]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    VIEW [JurCase].[vDocOutActualState]
AS
WITH MAXDateDocOut (DocOutID, MAXStateDate)
AS
(
	SELECT ds.DocOutID, MAX(ds.DocOutStateDate) FROM [JurCase].[DocOutState] ds
	GROUP BY ds.DocOutID
)
SELECT ds.DocOutID, ds.DocOutStateDate, s.StateName FROM [JurCase].[DocOutState] ds 	
	INNER JOIN MAXDateDocOut md 	
		ON md.DocOutID = ds.DocOutID and md.MAXStateDate = ds.DocOutStateDate
	INNER JOIN [RefData].[State] s
		ON ds.StateID = s.StateID
GO
/****** Object:  View [JurCase].[vLegalDecision]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [JurCase].[vLegalDecision]
AS
SELECT [LegalDecisionID], [LawCaseNumber], [DateToUpfr], [LegalDecisionSumm], [DateToPU], [LegalDecisionSummDenied], [LegalDecisionName], [StateLegalDecisionName] 
FROM [JurCase].[LegalDecision] ld
INNER JOIN [RefData].[StateLegalDecision] sld
	ON ld.[StateLegalDecisionID] = sld.[StateLegalDecisionID]
GO
/****** Object:  View [JurCase].[vDocOut]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--SET STATISTICS IO, TIME ON;
CREATE      VIEW [JurCase].[vDocOut]
AS
  SELECT CONCAT_WS('-', (CONCAT_WS('/', nmcl.[Number], CAST(nmcl.[NN] AS nvarchar(100)))), do.[DocOutNN]) FullNumber,   
      pt.[PenaltyTypeID],
	  pt.[PenaltyTypeName],
      jo.[JudicialOrganID], 
	  jo.[JudicialOrganName],
	  jo.[Address],       
       do.[DocOutPersons]
      ,do.[JudicalOrganDate]
      ,do.[DocOutAddressID]
      ,do.[DocOutExecutive]
      ,do.[DocOutArgSubject]
      ,do.[Notes]
      ,do.[ProcessNumber]
      ,do.[ThirdPersons]
      ,do.[Canceling]
      ,do.[OrdCancelCaseDate]
      ,do.[OrdCancelCaseNumber]
      ,do.[DocOutParentID]
	  --,docparent.DocOutNN
	  --,CONCAT_WS(' ', dpdt.DocTypeName, CONCAT_WS('-', (CONCAT_WS('/', dpnmcl.[Number], CAST(dpnmcl.[NN] AS nvarchar(100)))), docparent.[DocOutNN])) dpFullNumber
      ,dt.[DocTypeID], dt.[DocTypeName]
      ,e.[EmployeeID], e.[FullName]
      ,ld.[LegalDecisionID],
	  CONCAT_WS(' ', vDB.DocTypeName, CONCAT(' № ', vDB.Number, CONCAT(' от ', [Date]))) Сlaim,
	  vDB.Name
		,[DocOutStateDate]
		,[StateName]
		,lvd.[LawCaseNumber]
		,lvd.[LegalDecisionName]
		,lvd.[DateToUpfr]
		,lvd.[LegalDecisionSumm]
		,lvd.[DateToPU]
		,lvd.[LegalDecisionSummDenied]
		,lvd.[StateLegalDecisionName]
	FROM [JurCase].[DocOut] do
	INNER JOIN [RefData].[Nomenclature] nmcl
		ON do.[NomenclatureID] = nmcl.[NomenclatureID]
	INNER JOIN [RefData].[PenaltyType] pt
		ON pt.[PenaltyTypeID] = do.[PenaltyTypeID]
	INNER JOIN [JurCase].[JudicialOrgan] jo
		ON jo.[JudicialOrganID] = do.[JudicialOrganID]
	INNER JOIN [RefData].[DocType] dt
		ON dt.[DocTypeID] = do.[DocTypeID]
	INNER JOIN [RefData].[vEmployee] e
		ON e.[EmployeeID] = do.[EmployeeID]
	INNER JOIN [JurCase].[LegalDecision] ld
		ON ld.[LegalDecisionID] = do.[LegalDecisionID]
	INNER JOIN [JurCase].[DocBaseDocOut] DocBaseDocOutRel --ЗАМЕНИ НА INNER
		ON do.DocOutID = DocBaseDocOutRel.DocOutID
	INNER JOIN [RefData].[vDocBase] vDB
		ON DocBaseDocOutRel.[DocBaseID] = vDB.DocBaseID 
	INNER JOIN [JurCase].[vDocOutActualState] actst
		ON do.DocOutID = actst.DocOutID
	INNER JOIN [JurCase].[vLegalDecision] lvd
		ON do.LegalDecisionID = lvd.LegalDecisionID
	--INNER JOIN [JurCase].[DocOut] docparent
	--	ON do.DocOutParentID = do.DocOutID
	--INNER JOIN [RefData].[Nomenclature] dpnmcl
	--	ON docparent.[NomenclatureID] = dpnmcl.[NomenclatureID]
	--INNER JOIN [RefData].[DocType] dpdt
		--ON dpdt.[DocTypeID] = docparent.[DocTypeID]
	

GO
/****** Object:  View [JurCase].[vDocOutMovement]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [JurCase].[vDocOutMovement]
AS
SELECT  ds.DocOutID      
	  ,s.StateName
	  ,ds.DocOutStateDate
  FROM [JurCase].[DocOutState] ds		 
	INNER JOIN [RefData].[State] s
		ON ds.StateID = s.StateID
GO
/****** Object:  View [JurCase].[vDocOutState_del]    Script Date: 24.08.2021 16:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [JurCase].[vDocOutState_del]
AS
SELECT  d.[DocOutID]
      ,[NomenclatureID]
      ,[PenaltyTypeID]
      ,[JudicialOrganID]
      ,[DocOutNN]
      ,[DocOutPersons]
      ,[JudicalOrganDate]
      ,[DocOutAddressID]
      ,[DocOutExecutive]
      ,[DocOutArgSubject]
      ,[Notes]
      ,[ProcessNumber]
      ,[ThirdPersons]
      ,[Canceling]
      ,[OrdCancelCaseDate]
      ,[OrdCancelCaseNumber]
      ,[DocOutParentID]
      ,[DocTypeID]
      ,[EmployeeID]
      ,[LegalDecisionID]
	  ,s.StateName
	  ,ds.DocOutStateDate
  FROM [Lawyer].[JurCase].[DocOut] d
	INNER JOIN [JurCase].[DocOutState] ds
		ON d.[DocOutID] = ds.DocOutID
	INNER JOIN [RefData].[State] s
		ON ds.StateID = s.StateID
GO
