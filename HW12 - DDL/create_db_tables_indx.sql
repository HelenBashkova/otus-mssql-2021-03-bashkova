USE [master]
GO

/****** Object:  Database [Lawyer]    Script Date: 28.06.2021 0:19:59 ******/
CREATE DATABASE [Lawyer]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Lawyer', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSRV2017\MSSQL\DATA\Lawyer.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Lawyer_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLSRV2017\MSSQL\DATA\Lawyer_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Lawyer].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [Lawyer] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [Lawyer] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [Lawyer] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [Lawyer] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [Lawyer] SET ARITHABORT OFF 
GO

ALTER DATABASE [Lawyer] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [Lawyer] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [Lawyer] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [Lawyer] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [Lawyer] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [Lawyer] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [Lawyer] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [Lawyer] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [Lawyer] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [Lawyer] SET  DISABLE_BROKER 
GO

ALTER DATABASE [Lawyer] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [Lawyer] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [Lawyer] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [Lawyer] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [Lawyer] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [Lawyer] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [Lawyer] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [Lawyer] SET RECOVERY FULL 
GO

ALTER DATABASE [Lawyer] SET  MULTI_USER 
GO

ALTER DATABASE [Lawyer] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [Lawyer] SET DB_CHAINING OFF 
GO

ALTER DATABASE [Lawyer] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [Lawyer] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [Lawyer] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [Lawyer] SET QUERY_STORE = OFF
GO

ALTER DATABASE [Lawyer] SET  READ_WRITE 
GO


/*****************************************/
USE [Lawyer]
GO
/****** Object:  Table [dbo].[Court]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Court](
	[CourtID] [int] IDENTITY(1,1) NOT NULL,
	[CourtName] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_Court] PRIMARY KEY CLUSTERED 
(
	[CourtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] NOT NULL,
	[DepartmentName] [nvarchar](100) NOT NULL,
	[OPFRID] [int] NOT NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocIn]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocIn](
	[DocInID] [bigint] NOT NULL,
	[DocTypeID] [int] NOT NULL,
	[Number] [nvarchar](15) NOT NULL,
	[Date] [datetime2](7) NOT NULL,
	[DocInSum] [decimal](18, 2) NOT NULL,
	[ParentDocIn] [bigint] NOT NULL,
	[Sum] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_DocIn] PRIMARY KEY CLUSTERED 
(
	[DocInID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocinDocout]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocinDocout](
	[DocinDocoutID] [bigint] NOT NULL,
	[DocInID] [bigint] NOT NULL,
	[DocOutID] [bigint] NOT NULL,
 CONSTRAINT [PK_docindocout] PRIMARY KEY CLUSTERED 
(
	[DocinDocoutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocOut]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocOut](
	[DocOutID] [bigint] NOT NULL,
	[NomenclatureID] [int] NOT NULL,
	[PenaltyTypeID] [int] NOT NULL,
	[JudicialOrganID] [int] NOT NULL,
	[DocOutDateCr] [datetime2](7) NOT NULL,
	[DocOutDateReg] [datetime2](7) NOT NULL,
	[DocOutNN] [bigint] NOT NULL,
	[DocOutTotalSum] [decimal](17, 2) NOT NULL,
	[DocOutPersons] [smallint] NULL,
	[DocOutAnnulDate] [datetime2](7) NULL,
	[DocOutAnnulReason] [nvarchar](300) NULL,
	[JudicalOrganDate] [datetime2](7) NOT NULL,
	[DocOutAddressID] [bigint] NOT NULL,
	[DocOutExecutive] [nvarchar](80) NOT NULL,
	[DocOutArgSubject] [varchar](255) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[ProcessNumber] [nvarchar](10) NOT NULL,
	[ThirdPersons] [nvarchar](250) NOT NULL,
	[Canceling] [bit] NOT NULL,
	[OrdCancelCaseDate] [datetime2](7) NOT NULL,
	[OrdCancelCaseNumber] [nvarchar](20) NOT NULL,
	[DocOutParentID] [bigint] NOT NULL,
	[DocTypeID] [int] NOT NULL,
	[StatusID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LegalDecisionID] [bigint] NULL,
 CONSTRAINT [PK_Docout] PRIMARY KEY CLUSTERED 
(
	[DocOutID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocType]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocType](
	[DocTypeID] [int] IDENTITY(1,1) NOT NULL,
	[DocTypeName] [varchar](250) NOT NULL,
	[InTag] [bit] NOT NULL,
 CONSTRAINT [PK_DocType] PRIMARY KEY CLUSTERED 
(
	[DocTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
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
/****** Object:  Table [dbo].[Insurer]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Insurer](
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
/****** Object:  Table [dbo].[InsurerFile]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsurerFile](
	[InsurerFileID] [bigint] NOT NULL,
	[InsurerID] [int] NOT NULL,
	[InsurerFileINumber] [nvarchar](50) NOT NULL,
	[InsurerFileYear] [nvarchar](8) NOT NULL,
	[InsurerFileIParentID] [bigint] NULL,
	[DocinDocoutID] [bigint] NOT NULL,
 CONSTRAINT [PK_InsurerFile] PRIMARY KEY CLUSTERED 
(
	[InsurerFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JudicialOrgan]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JudicialOrgan](
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
/****** Object:  Table [dbo].[LegalDecision]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LegalDecision](
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
/****** Object:  Table [dbo].[Nomenclature]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nomenclature](
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
/****** Object:  Table [dbo].[OPFR]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OPFR](
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
/****** Object:  Table [dbo].[PenaltyType]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PenaltyType](
	[PenaltyTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PenaltyTypeName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_PenaltyType] PRIMARY KEY CLUSTERED 
(
	[PenaltyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Post]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Post](
	[PostID] [int] IDENTITY(1,1) NOT NULL,
	[PostName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Post] PRIMARY KEY CLUSTERED 
(
	[PostID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StateLegalDecision]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateLegalDecision](
	[StateLegalDecisionID] [bigint] NOT NULL,
	[StateLegalDecisionName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_StateLegalDecision] PRIMARY KEY CLUSTERED 
(
	[StateLegalDecisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Status]    Script Date: 28.06.2021 0:14:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_Department_OPFR] FOREIGN KEY([OPFRID])
REFERENCES [dbo].[OPFR] ([OPFRID])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_Department_OPFR]
GO
ALTER TABLE [dbo].[DocIn]  WITH CHECK ADD  CONSTRAINT [FK_DocIn_DocType] FOREIGN KEY([DocTypeID])
REFERENCES [dbo].[DocType] ([DocTypeID])
GO
ALTER TABLE [dbo].[DocIn] CHECK CONSTRAINT [FK_DocIn_DocType]
GO
ALTER TABLE [dbo].[DocinDocout]  WITH CHECK ADD  CONSTRAINT [FK_DocinDocout_DocIn] FOREIGN KEY([DocInID])
REFERENCES [dbo].[DocIn] ([DocInID])
GO
ALTER TABLE [dbo].[DocinDocout] CHECK CONSTRAINT [FK_DocinDocout_DocIn]
GO
ALTER TABLE [dbo].[DocinDocout]  WITH CHECK ADD  CONSTRAINT [FK_DocinDocout_DocOut] FOREIGN KEY([DocOutID])
REFERENCES [dbo].[DocOut] ([DocOutID])
GO
ALTER TABLE [dbo].[DocinDocout] CHECK CONSTRAINT [FK_DocinDocout_DocOut]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_Docout_DocType] FOREIGN KEY([DocTypeID])
REFERENCES [dbo].[DocType] ([DocTypeID])
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [FK_Docout_DocType]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_Docout_Employee] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employee] ([EmployeeID])
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [FK_Docout_Employee]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_Docout_JudicialOrgan] FOREIGN KEY([JudicialOrganID])
REFERENCES [dbo].[JudicialOrgan] ([JudicialOrganID])
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [FK_Docout_JudicialOrgan]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_DocOut_LegalDecision] FOREIGN KEY([LegalDecisionID])
REFERENCES [dbo].[LegalDecision] ([LegalDecisionID])
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [FK_DocOut_LegalDecision]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_Docout_Nomenclature] FOREIGN KEY([NomenclatureID])
REFERENCES [dbo].[Nomenclature] ([NomenclatureID])
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [FK_Docout_Nomenclature]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_Docout_PenaltyType] FOREIGN KEY([PenaltyTypeID])
REFERENCES [dbo].[PenaltyType] ([PenaltyTypeID])
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [FK_Docout_PenaltyType]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [FK_Docout_Status] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Status] ([StatusID])
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [FK_Docout_Status]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Department]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Post] FOREIGN KEY([PostID])
REFERENCES [dbo].[Post] ([PostID])
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Post]
GO
ALTER TABLE [dbo].[InsurerFile]  WITH CHECK ADD  CONSTRAINT [FK_InsurerFile_DocinDocout] FOREIGN KEY([DocinDocoutID])
REFERENCES [dbo].[DocinDocout] ([DocinDocoutID])
GO
ALTER TABLE [dbo].[InsurerFile] CHECK CONSTRAINT [FK_InsurerFile_DocinDocout]
GO
ALTER TABLE [dbo].[InsurerFile]  WITH CHECK ADD  CONSTRAINT [FK_InsurerFile_Insurer] FOREIGN KEY([InsurerID])
REFERENCES [dbo].[Insurer] ([InsurerID])
GO
ALTER TABLE [dbo].[InsurerFile] CHECK CONSTRAINT [FK_InsurerFile_Insurer]
GO
ALTER TABLE [dbo].[JudicialOrgan]  WITH CHECK ADD  CONSTRAINT [FK_JudicialOrgan_Court] FOREIGN KEY([CourtID])
REFERENCES [dbo].[Court] ([CourtID])
GO
ALTER TABLE [dbo].[JudicialOrgan] CHECK CONSTRAINT [FK_JudicialOrgan_Court]
GO
ALTER TABLE [dbo].[LegalDecision]  WITH CHECK ADD  CONSTRAINT [FK_LegalDecision_StateLegalDecision] FOREIGN KEY([StateLegalDecisionID])
REFERENCES [dbo].[StateLegalDecision] ([StateLegalDecisionID])
GO
ALTER TABLE [dbo].[LegalDecision] CHECK CONSTRAINT [FK_LegalDecision_StateLegalDecision]
GO
ALTER TABLE [dbo].[DocOut]  WITH CHECK ADD  CONSTRAINT [CK_DocOutTotalSum] CHECK  (([DocOutTotalSum]>(0)))
GO
ALTER TABLE [dbo].[DocOut] CHECK CONSTRAINT [CK_DocOutTotalSum]
GO
/********************************************************************************/
/****** Object:  Index [NCI_InsurerRegNum]    Script Date: 28.06.2021 0:29:00 ******/
CREATE NONCLUSTERED INDEX [NCI_InsurerRegNum] ON [dbo].[Insurer]
(
	[InsurerRegNum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
