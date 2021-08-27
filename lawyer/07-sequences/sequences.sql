USE [Lawyer]
GO

/****** Object:  Sequence [JurCase].[seqJegalDesicion]    Script Date: 27.08.2021 17:29:41 ******/
CREATE SEQUENCE [JurCase].[seqJegalDesicion] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO

/****** Object:  Sequence [RefData].[seqDepartment]    Script Date: 27.08.2021 17:29:55 ******/
CREATE SEQUENCE [RefData].[seqDepartment] 
 AS [bigint]
 START WITH 2
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO


/****** Object:  Sequence [RefData].[seqStateLegalDecision]    Script Date: 27.08.2021 17:30:19 ******/
CREATE SEQUENCE [RefData].[seqStateLegalDecision] 
 AS [bigint]
 START WITH 4
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO



