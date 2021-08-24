USE Lawyer;  

CREATE NONCLUSTERED INDEX [FK_DocBaseDocOut_DocBase] ON [dbo].[DocBaseDocOut](DocBaseID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocBaseDocOut_DocOut] ON [dbo].[DocBaseDocOut](DocOutID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NC_DocBaseDocOut_DocBaseDocOutID_DocBaseID] ON [dbo].[DocBaseDocOut](DocBaseDocOutID ASC) 
INCLUDE (DocBaseID, DocOutID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NCDocBaseDocOut_DocBaseDocOutID_DocBaseID] ON [dbo].[DocBaseDocOut](DocBaseDocOutID ASC, DocBaseID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_DocType] ON [dbo].[DocOut](DocTypeID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_Employee] ON [dbo].[DocOut](EmployeeID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_JuridicalOrgan] ON [dbo].[DocOut](JudicialOrganID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_LegalDecision] ON [dbo].[DocOut](LegalDecisionID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_Nomeclature] ON [dbo].[DocOut](NomenclatureID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_PenalityType] ON [dbo].[DocOut](PenaltyTypeID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NC_DocOut_DocOutID_Includes] ON [dbo].[DocOut](DocOutID ASC) 
INCLUDE (NomenclatureID, PenaltyTypeID, JudicialOrganID, DocOutNN, DocOutPersons, JudicalOrganDate, DocOutAddressID, DocOutExecutive, DocOutArgSubject, Notes, ProcessNumber, ThirdPersons, Canceling, OrdCancelCaseDate, OrdCancelCaseNumber, DocOutParentID, DocTypeID, EmployeeID, LegalDecisionID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [CI_Insurer_InsurerRegNum] ON [dbo].[Insurer](InsurerRegNum ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE UNIQUE NONCLUSTERED INDEX [GRAPH_UNIQUE_INDEX_D9FA2ACB9A64457E9137B005BE434FDC] ON [dbo].[Person](graph_id_04BA75A90E824938AB965DAD433E23A2 ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocBaseDocOut_DocBase] ON [JurCase].[DocBaseDocOut](DocBaseID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocBaseDocOut_DocOut] ON [JurCase].[DocBaseDocOut](DocOutID ASC) 
INCLUDE (DocBaseDocOutID, DocBaseID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NC_DocBaseDocOut_DocBaseDocOutID_DocBaseID_] ON [JurCase].[DocBaseDocOut](DocBaseDocOutID ASC) 
INCLUDE (DocBaseID, DocOutID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_EmpoyeeID] ON [JurCase].[DocOut](EmployeeID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_NomenclatureID] ON [JurCase].[DocOut](NomenclatureID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOut_PenaityTypeID] ON [JurCase].[DocOut](PenaltyTypeID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocOutState_DocOutID] ON [JurCase].[DocOutState](DocOutID ASC) 
INCLUDE (DocOutStateDate, StateID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NC_DocOutState_DocOutID_DocOutStateDate] ON [JurCase].[DocOutState](DocOutID ASC) 
INCLUDE (DocOutStateDate)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NC_DocOutState_DocOutStateDate] ON [JurCase].[DocOutState](DocOutStateDate ASC) 
INCLUDE (DocOutID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NC_LegalDecision_LegalDecisionID_INCL] ON [JurCase].[LegalDecision](LegalDecisionID ASC, StateLegalDecisionID ASC) 
INCLUDE (LawCaseNumber, DateToUpfr, LegalDecisionSumm, DateToPU, LegalDecisionSummDenied, LegalDecisionName)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocBase_DocType] ON [RefData].[DocBase](DocTypeID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [FK_DocBase_InsurerID] ON [RefData].[DocBase](InsurerID ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NI_DocBase_Date_DocBaseIDNumber] ON [RefData].[DocBase](Date ASC, DocBaseID ASC) 
INCLUDE (Number, DocBaseSum, ParentDocBaseID, InsurerID)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NI_DocBase_ParentDocBaseID] ON [RefData].[DocBase](ParentDocBaseID ASC) 
INCLUDE (DocBaseID, Number, DocBaseSum, Date)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [NC_DocType_DocTypeID_DocTypeName] ON [RefData].[DocType](DocTypeID ASC) 
INCLUDE (DocTypeName)
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE NONCLUSTERED INDEX [CI_Insurer_InsurerRegNum] ON [RefData].[Insurer](InsurerRegNum ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE UNIQUE NONCLUSTERED INDEX [GRAPH_UNIQUE_INDEX_D9FA2ACB9A64457E9137B005BE434FDC] ON [RefData].[Person](graph_id_98B89EFA3E9E4F52B25503153AC4F00D ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
 
CREATE UNIQUE NONCLUSTERED INDEX [GRAPH_UNIQUE_INDEX_E58E574678834FB981948CAF9170311B] ON [RefData].[Person](graph_id_98B89EFA3E9E4F52B25503153AC4F00D ASC) 
WITH (PAD_INDEX = OFF, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, SORT_IN_TEMPDB = OFF, FILLFACTOR =0) ON [PRIMARY];
/************************************************************************************************************************/
CREATE FULLTEXT CATALOG LawyerDocFTCat;   
/************************************************************************************************************************/
CREATE FULLTEXT INDEX ON [RefData].[Insurer]
(
	[InsurerRegNum]
		LANGUAGE Russian,
	[InsurerFullName]
		LANGUAGE Russian,
	[InsurerLastName]
		LANGUAGE Russian
) 
KEY INDEX [PK_Insurer] ON [LawyerDocFTCat] --Unique index  
WITH CHANGE_TRACKING AUTO ;           --Population type;  
--GO  

SELECT *
FROM [RefData].[Insurer] 
WHERE CONTAINS([InsurerFullName], N'"я*"');

SELECT *
FROM [RefData].[Insurer] 
WHERE CONTAINS([InsurerRegNum], N'"777032*"');

SELECT *
FROM [RefData].[Insurer] 
WHERE CONTAINS([InsurerLastName], N'"к*"');

/*****************************************************************************************************************************/
CREATE FULLTEXT INDEX ON [RefData].[DocBase]
(
	[Number]
		LANGUAGE Russian
) 
KEY INDEX [PK_DocBaseID] ON [LawyerDocFTCat] --Unique index  
WITH CHANGE_TRACKING AUTO ;           --Population type;  
GO  

SELECT *
FROM [RefData].[DocBase]
WHERE CONTAINS([Number], N'"063S1*"');
