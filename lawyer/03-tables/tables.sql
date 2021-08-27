USE [Lawyer]
GO
/****** Object:  Table [JurCase].[DocBaseDocOut]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [JurCase].[DocBaseDocOut](
	[DocBaseDocOutID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocBaseID] [bigint] NOT NULL,
	[DocOutID] [bigint] NOT NULL,
	[InsurerFileID] [bigint] NOT NULL,
 CONSTRAINT [PK_DocBaseDocOut] PRIMARY KEY CLUSTERED 
(
	[DocBaseDocOutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [JurCase].[DocOut]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [JurCase].[DocOut](
	[DocOutID] [bigint] IDENTITY(1,1) NOT NULL,
	[NomenclatureID] [int] NOT NULL,
	[PenaltyTypeID] [int] NOT NULL,
	[JudicialOrganID] [int] NOT NULL,
	[DocOutNN] [bigint] NOT NULL,
	[DocOutPersons] [smallint] NULL,
	[JudicalOrganDate] [date] NOT NULL,
	[DocOutAddressID] [bigint] NOT NULL,
	[DocOutExecutive] [nvarchar](80) NOT NULL,
	[DocOutArgSubject] [varchar](255) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[ProcessNumber] [nvarchar](10) NOT NULL,
	[ThirdPersons] [nvarchar](250) NOT NULL,
	[Canceling] [bit] NOT NULL,
	[OrdCancelCaseDate] [date] NOT NULL,
	[OrdCancelCaseNumber] [nvarchar](20) NOT NULL,
	[DocOutParentID] [bigint] NOT NULL,
	[DocTypeID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LegalDecisionID] [bigint] NOT NULL,
 CONSTRAINT [PK_DocOutID] PRIMARY KEY CLUSTERED 
(
	[DocOutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [JurCase].[DocOutState]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [JurCase].[DocOutState](
	[DocOutStateID] [bigint] IDENTITY(1,1) NOT NULL,
	[StateID] [int] NOT NULL,
	[DocOutID] [bigint] NOT NULL,
	[DocOutStateDate] [date] NOT NULL,
 CONSTRAINT [PK_DocOutState] PRIMARY KEY CLUSTERED 
(
	[DocOutStateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [JurCase].[InsurerFile]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [JurCase].[InsurerFile](
	[InsurerFileID] [bigint] IDENTITY(1,1) NOT NULL,
	[InsurerID] [bigint] NOT NULL,
	[InsurerFileINumber] [nvarchar](50) NOT NULL,
	[InsurerFileYear] [nvarchar](8) NOT NULL,
 CONSTRAINT [PK_InsurerFileID] PRIMARY KEY CLUSTERED 
(
	[InsurerFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [JurCase].[JudicialOrgan]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [JurCase].[JudicialOrgan](
	[JudicialOrganID] [int] NOT NULL,
	[JudicialOrganName] [nvarchar](150) NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
	[CourtID] [int] NOT NULL,
 CONSTRAINT [PK_JudicialOrgan] PRIMARY KEY CLUSTERED 
(
	[JudicialOrganID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [JurCase].[LegalDecision]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [JurCase].[LegalDecision](
	[LegalDecisionID] [bigint] NOT NULL,
	[LawCaseNumber] [nvarchar](16) NOT NULL,
	[DateToUpfr] [datetime2](7) NOT NULL,
	[LegalDecisionSumm] [decimal](17, 2) NOT NULL,
	[DateToPU] [datetime2](7) NOT NULL,
	[LegalDecisionSummDenied] [decimal](17, 2) NOT NULL,
	[StateLegalDecisionID] [bigint] NOT NULL,
	[LegalDecisionName] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_LegalDecision] PRIMARY KEY CLUSTERED 
(
	[LegalDecisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[Court]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[Court](
	[CourtID] [int] IDENTITY(1,1) NOT NULL,
	[CourtName] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_Court] PRIMARY KEY CLUSTERED 
(
	[CourtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[Department]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[Department](
	[DepartmentID] [int] NOT NULL,
	[DepartmentName] [nvarchar](100) NOT NULL,
	[OPFRID] [int] NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[DocBase]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[DocBase](
	[DocBaseID] [bigint] IDENTITY(1,1) NOT NULL,
	[DocTypeID] [int] NOT NULL,
	[Number] [nvarchar](29) NOT NULL,
	[Date] [date] NOT NULL,
	[DocBaseSum] [decimal](18, 2) NOT NULL,
	[ParentDocBaseID] [bigint] NOT NULL,
	[InsurerID] [int] NULL,
 CONSTRAINT [PK_DocBaseID] PRIMARY KEY CLUSTERED 
(
	[DocBaseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[DocType]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[DocType](
	[DocTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DocTypeName] [varchar](250) NOT NULL,
	[InTag] [bit] NOT NULL,
 CONSTRAINT [PK_DocType] PRIMARY KEY CLUSTERED 
(
	[DocTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[Employee]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[Employee](
	[EmployeeID] [int] NOT NULL,
	[EmployeeFirstName] [nvarchar](100) NOT NULL,
	[EmployeeLastName] [nvarchar](100) NOT NULL,
	[EmployeeMiddleName] [nvarchar](100) NOT NULL,
	[EmployeeDOB] [date] NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[PostID] [int] NOT NULL,
 CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[Insurer]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[Insurer](
	[InsurerID] [int] IDENTITY(1,1) NOT NULL,
	[InsurerRegNum] [nvarchar](12) NOT NULL,
	[InsurerFullName] [nvarchar](1000) NULL,
	[InsurerShortName] [nvarchar](1000) NULL,
	[InsurerLastName] [nvarchar](255) NULL,
	[InsurerFirstName] [nvarchar](255) NULL,
	[InsurerMiddleName] [nvarchar](255) NULL,
	[InsurerJurZipCode] [nvarchar](6) NOT NULL,
	[InsurerJurHouse] [nvarchar](50) NOT NULL,
	[InsurerJurBuilding] [nvarchar](50) NULL,
	[InsurerJurFlat] [nvarchar](50) NULL,
	[InsurerJurSubject] [nvarchar](255) NOT NULL,
	[InsurerJurRegion] [nvarchar](255) NOT NULL,
	[InsurerJurCity] [nvarchar](255) NULL,
	[InsurerJurTown] [nvarchar](255) NULL,
	[InsurerJurStreet] [nvarchar](255) NOT NULL,
	[InsurerFactZipcode] [nvarchar](6) NOT NULL,
	[InsurerFactHouse] [nvarchar](50) NOT NULL,
	[InsurerFactBuilding] [nvarchar](50) NULL,
	[InsurerFactSubject] [nvarchar](255) NOT NULL,
	[InsurerFactRegion] [nvarchar](255) NOT NULL,
	[InsurerFactCity] [nvarchar](255) NULL,
	[InsurerFactTown] [nvarchar](255) NULL,
	[InsurerFactStreet] [nvarchar](255) NOT NULL,
	[InsurerFactFlat] [nvarchar](50) NULL,
 CONSTRAINT [PK_Insurer] PRIMARY KEY CLUSTERED 
(
	[InsurerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[JudicialOrgan]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[JudicialOrgan](
	[JudicialOrganID] [int] NOT NULL,
	[JudicialOrganName] [nvarchar](150) NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
	[CourtID] [int] NOT NULL,
 CONSTRAINT [PK_JudicialOrgan] PRIMARY KEY CLUSTERED 
(
	[JudicialOrganID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [RefData].[Nomenclature]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[Nomenclature](
	[NomenclatureID] [int] IDENTITY(1,1) NOT NULL,
	[NN] [bigint] NOT NULL,
	[Number] [nvarchar](5) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
	[Year] [smallint] NOT NULL,
 CONSTRAINT [PK_Nomenclature] PRIMARY KEY CLUSTERED 
(
	[NomenclatureID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[OPFR]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[OPFR](
	[OPFRID] [int] IDENTITY(1,1) NOT NULL,
	[OPFRName] [nvarchar](150) NOT NULL,
	[OPFRAddress] [nvarchar](250) NOT NULL,
	[OPFRPhone] [nvarchar](11) NOT NULL,
	[OPFRFax] [nvarchar](11) NOT NULL,
	[OPFREmail] [nvarchar](50) NOT NULL,
	[OKPO] [nvarchar](10) NOT NULL,
	[OGRN] [nvarchar](20) NOT NULL,
	[INN_KPP] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Opfr] PRIMARY KEY CLUSTERED 
(
	[OPFRID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[PenaltyType]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[PenaltyType](
	[PenaltyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PenaltyTypeName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_PenaltyType] PRIMARY KEY CLUSTERED 
(
	[PenaltyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[Person]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[Person](
	[ID] [int] NOT NULL,
	[name] [varchar](100) NULL,
	[email] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
AS NODE ON [PRIMARY]
GO
/****** Object:  Table [RefData].[Post]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[Post](
	[PostID] [int] IDENTITY(1,1) NOT NULL,
	[PostName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[PostID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [RefData].[State]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[State](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [nvarchar](150) NOT NULL,
	[Note] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [RefData].[StateLegalDecision]    Script Date: 27.08.2021 17:26:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RefData].[StateLegalDecision](
	[StateLegalDecisionID] [bigint] NOT NULL,
	[StateLegalDecisionName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_StateLegalDecision] PRIMARY KEY CLUSTERED 
(
	[StateLegalDecisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [JurCase].[LegalDecision] ADD  DEFAULT (NEXT VALUE FOR [JurCase].[seqJegalDesicion]) FOR [LegalDecisionID]
GO
ALTER TABLE [JurCase].[DocBaseDocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocBaseDocOut_DocBase] FOREIGN KEY([DocBaseID])
REFERENCES [RefData].[DocBase] ([DocBaseID])
GO
ALTER TABLE [JurCase].[DocBaseDocOut] CHECK CONSTRAINT [FK_DocBaseDocOut_DocBase]
GO
ALTER TABLE [JurCase].[DocBaseDocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocBaseDocOut_DocBaseDocOut] FOREIGN KEY([DocBaseDocOutID])
REFERENCES [JurCase].[DocBaseDocOut] ([DocBaseDocOutID])
GO
ALTER TABLE [JurCase].[DocBaseDocOut] CHECK CONSTRAINT [FK_DocBaseDocOut_DocBaseDocOut]
GO
ALTER TABLE [JurCase].[DocBaseDocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocBaseDocOut_DocOut] FOREIGN KEY([DocOutID])
REFERENCES [JurCase].[DocOut] ([DocOutID])
GO
ALTER TABLE [JurCase].[DocBaseDocOut] CHECK CONSTRAINT [FK_DocBaseDocOut_DocOut]
GO
ALTER TABLE [JurCase].[DocBaseDocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocBaseDocOut_InsurerFile] FOREIGN KEY([InsurerFileID])
REFERENCES [JurCase].[InsurerFile] ([InsurerFileID])
GO
ALTER TABLE [JurCase].[DocBaseDocOut] CHECK CONSTRAINT [FK_DocBaseDocOut_InsurerFile]
GO
ALTER TABLE [JurCase].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocOut_DocType] FOREIGN KEY([DocTypeID])
REFERENCES [RefData].[DocType] ([DocTypeID])
GO
ALTER TABLE [JurCase].[DocOut] CHECK CONSTRAINT [FK_DocOut_DocType]
GO
ALTER TABLE [JurCase].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocOut_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [RefData].[Employee] ([EmployeeID])
GO
ALTER TABLE [JurCase].[DocOut] CHECK CONSTRAINT [FK_DocOut_Employee]
GO
ALTER TABLE [JurCase].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocOut_LegalDecision] FOREIGN KEY([LegalDecisionID])
REFERENCES [JurCase].[LegalDecision] ([LegalDecisionID])
GO
ALTER TABLE [JurCase].[DocOut] CHECK CONSTRAINT [FK_DocOut_LegalDecision]
GO
ALTER TABLE [JurCase].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocOut_Nomenclature] FOREIGN KEY([NomenclatureID])
REFERENCES [RefData].[Nomenclature] ([NomenclatureID])
GO
ALTER TABLE [JurCase].[DocOut] CHECK CONSTRAINT [FK_DocOut_Nomenclature]
GO
ALTER TABLE [JurCase].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocOut_PenaltyType] FOREIGN KEY([PenaltyTypeID])
REFERENCES [RefData].[PenaltyType] ([PenaltyTypeID])
GO
ALTER TABLE [JurCase].[DocOut] CHECK CONSTRAINT [FK_DocOut_PenaltyType]
GO
ALTER TABLE [JurCase].[DocOutState]  WITH CHECK ADD  CONSTRAINT [FK_DocOutState_DocOut] FOREIGN KEY([DocOutID])
REFERENCES [JurCase].[DocOut] ([DocOutID])
GO
ALTER TABLE [JurCase].[DocOutState] CHECK CONSTRAINT [FK_DocOutState_DocOut]
GO
ALTER TABLE [JurCase].[DocOutState]  WITH CHECK ADD  CONSTRAINT [FK_DocOutState_State] FOREIGN KEY([StateID])
REFERENCES [RefData].[State] ([StateID])
GO
ALTER TABLE [JurCase].[DocOutState] CHECK CONSTRAINT [FK_DocOutState_State]
GO
ALTER TABLE [JurCase].[LegalDecision]  WITH CHECK ADD  CONSTRAINT [FK_LegalDecision_StateLegalDecision] FOREIGN KEY([StateLegalDecisionID])
REFERENCES [RefData].[StateLegalDecision] ([StateLegalDecisionID])
GO
ALTER TABLE [JurCase].[LegalDecision] CHECK CONSTRAINT [FK_LegalDecision_StateLegalDecision]
GO
ALTER TABLE [RefData].[Department]  WITH CHECK ADD  CONSTRAINT [FK_Department_OPFR] FOREIGN KEY([OPFRID])
REFERENCES [RefData].[OPFR] ([OPFRID])
GO
ALTER TABLE [RefData].[Department] CHECK CONSTRAINT [FK_Department_OPFR]
GO
ALTER TABLE [RefData].[DocBase]  WITH CHECK ADD  CONSTRAINT [FK_DocBase_DocBase] FOREIGN KEY([DocBaseID])
REFERENCES [RefData].[DocBase] ([DocBaseID])
GO
ALTER TABLE [RefData].[DocBase] CHECK CONSTRAINT [FK_DocBase_DocBase]
GO
ALTER TABLE [RefData].[DocBase]  WITH CHECK ADD  CONSTRAINT [FK_DocBase_DocBase_Insurer] FOREIGN KEY([InsurerID])
REFERENCES [RefData].[Insurer] ([InsurerID])
GO
ALTER TABLE [RefData].[DocBase] CHECK CONSTRAINT [FK_DocBase_DocBase_Insurer]
GO
ALTER TABLE [RefData].[DocBase]  WITH CHECK ADD  CONSTRAINT [FK_DocBase_DocType] FOREIGN KEY([DocTypeID])
REFERENCES [RefData].[DocType] ([DocTypeID])
GO
ALTER TABLE [RefData].[DocBase] CHECK CONSTRAINT [FK_DocBase_DocType]
GO
ALTER TABLE [RefData].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Department] FOREIGN KEY([DepartmentID])
REFERENCES [RefData].[Department] ([DepartmentID])
GO
ALTER TABLE [RefData].[Employee] CHECK CONSTRAINT [FK_Employee_Department]
GO
ALTER TABLE [RefData].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Post] FOREIGN KEY([PostID])
REFERENCES [RefData].[Post] ([PostID])
GO
ALTER TABLE [RefData].[Employee] CHECK CONSTRAINT [FK_Employee_Post]
GO
ALTER TABLE [RefData].[JudicialOrgan]  WITH CHECK ADD  CONSTRAINT [FK_JudicialOrgan_Court] FOREIGN KEY([CourtID])
REFERENCES [RefData].[Court] ([CourtID])
GO
ALTER TABLE [RefData].[JudicialOrgan] CHECK CONSTRAINT [FK_JudicialOrgan_Court]
GO
