USE [Lawyer]
GO
/****** Object:  StoredProcedure [Application].[FormXMLDocOut]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[FormXMLDocOut]
	@DocOutID bigint
AS
	SET NOCOUNT ON;	
	SELECT CONVERT(nvarchar(max),
			(	
				SELECT * FROM [JurCase].[vDocOut] do 
				WHERE do.DocOutID = @DocOutID 
				FOR XML PATH ('DocOut'), root ('Document')))
GO
/****** Object:  StoredProcedure [Application].[InsertCourt]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertCourt]
	@CourtName [nvarchar](80)
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[Court]
            (
				CourtName				
			)
			VALUES
            (
				@CourtName			
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertDepartment]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertDepartment]
	@DepartmentID [int],
	@DepartmentName [nvarchar](100),
	@OPFRID [int]
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[Department]
            (
				[DepartmentID],
				[DepartmentName],
				[OPFRID] 		
			)
			VALUES
            (
				NEXT VALUE FOR [RefData].[seqDepartment]
				,@DepartmentName
				,@OPFRID		
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertDocBase]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertDocBase]
	@DocTypeID bigint,
    @Number nvarchar(29),
    @Date Date,
    @DocBaseSum decimal(18, 2),
	@ParentDocBaseID bigint,
    @InsurerID int
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[DocBase]
			(	
				[DocTypeID]
				,[Number]
				,[Date]
				,[DocBaseSum]
				,[ParentDocBaseID]
				,[InsurerID]
			)
			VALUES
			(
				@DocTypeID          
				,@Number
				,@Date
				,@DocBaseSum
				,@ParentDocBaseID
				,@InsurerID
			)

		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertDocOut]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertDocOut] (
	@InsurerID int,
	@DocBaseID bigint,
	@NomenclatureID int,
	@PenaltyTypeID int,
	@JudicialOrganID int,
    @DocOutNN bigint,
	@DocOutPersons smallint,
	@JudicalOrganDate date, 
	@DocOutAddressID bigint,
	@DocOutExecutive bigint,
	@DocOutArgSubject varchar(255),
	@Notes nvarchar(max),
	@ProcessNumber nvarchar(10),
	@ThirdPersons nvarchar(250),
	@Canceling bit,
	@OrdCancelCaseDate date,
	@OrdCancelCaseNumber nvarchar(20),
	@DocTypeID int,
	@EmployeeID int,
	@LegalDecisionID bigint,
	@InsurerFileID bigint)
AS
	SET NOCOUNT ON;	
	BEGIN TRY
		DECLARE 
		@DocOutParentID  bigint = 0,		
		@StateID int,
		@DocOutStateDate date = GETDATE(),
		@DocOutID bigint,
		@DocBaseDocOutID bigint,
		@CurrYear smallint = YEAR(GETDATE());
		
		DECLARE @InsertedDocID TABLE 
		(
			DocOutID bigint
		);

		DECLARE @InsertedDocBaseDocOutID TABLE 
		(
			DocBaseDocOutID bigint
		);

	 
	SET @StateID = (SELECT TOP (1) StateID FROM [RefData].[State] WHERE [StateName] = 'Черновик'); 
		BEGIN TRANSACTION			
			INSERT INTO [JurCase].[DocOut]
			(
				[NomenclatureID]
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
				,[LegalDecisionID])
			OUTPUT INSERTED.DocOutID INTO @InsertedDocID
			VALUES
			(
				 @NomenclatureID
				,@PenaltyTypeID
	            ,@JudicialOrganID
		        ,@DocOutNN
			    ,@DocOutPersons
			    ,@JudicalOrganDate
			    ,@DocOutAddressID
			    ,@DocOutExecutive 
				,@DocOutArgSubject
				,@Notes
				,@ProcessNumber
				,@ThirdPersons
				,@Canceling
				,@OrdCancelCaseDate
				,@OrdCancelCaseNumber
				,@DocOutParentID
				,@DocTypeID
				,@EmployeeID
				,@LegalDecisionID
			);
			
			SET @DocOutID = (SELECT DocOutID FROM @InsertedDocID);

			INSERT INTO [JurCase].[DocOutState]
			(
				 [StateID]
				,[DocOutID]
				,[DocOutStateDate]
			)			
			VALUES
			(
			  	  @StateID
				 ,@DocOutID
				 ,@DocOutStateDate
		    );
			INSERT INTO [JurCase].[DocBaseDocOut]
            (
				[DocBaseID]
				,[DocOutID]
				,[InsurerFileID]
			)
			--OUTPUT INSERTED.DocBaseDocOutID INTO @InsertedDocBaseDocOutID
			VALUES
			(
				 @DocBaseID
				,@DocOutID
				,@InsurerFileID
			)
			
			--SET @DocBaseDocOutID = (SELECT DocBaseDocOutID FROM @InsertedDocBaseDocOutID);

			--INSERT INTO [JurCase].[InsurerFile]
   --         (			
			--	[InsurerID]
			--	,[InsurerFileINumber]
			--	,[InsurerFileYear]
			--	,[DocBaseDocOutID])
			--VALUES
   --        (
			--	@InsurerID
			--	,@InsurerFileINumber
			--	,@CurrYear
			--	,@DocBaseDocOutID
			--)
		COMMIT TRANSACTION;  
	END TRY 
	BEGIN CATCH
		SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		    ,ERROR_SEVERITY() AS ErrorSeverity  
		    ,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;  
  
		IF @@TRANCOUNT > 0  
			ROLLBACK TRANSACTION; 
	END CATCH 
GO
/****** Object:  StoredProcedure [Application].[InsertDocOutState]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Application].[InsertDocOutState] 
	@StateID int, 
	@DocOutID bigint,
	@DocOutStateDate date
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO [JurCase].[DocOutState]
			(
				[StateID]
				,[DocOutID]
				,[DocOutStateDate])
			VALUES
			(
				@StateID
				,@DocOutID
				,@DocOutStateDate
			);
    
      END TRY
	  BEGIN CATCH  
		SELECT   
			 ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;  
  
		IF @@TRANCOUNT > 0  
			ROLLBACK TRANSACTION;  
	END CATCH;  
  
	IF @@TRANCOUNT > 0  
		COMMIT TRANSACTION;

GO
/****** Object:  StoredProcedure [Application].[InsertDocType]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertDocType]
	@DocTypeName varchar(250),
	@InTag [bit]
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[DocType]
            (
				DocTypeName
				,InTag
			)
			VALUES
            (
				@DocTypeName
				,@InTag
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertEmployee]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Application].[InsertEmployee]
	@EmployeeFirstName nvarchar(100),
	@EmployeeLastName nvarchar(100),
	@EmployeeMiddleName nvarchar(100),
	@EmployeeDOB date,
	@DepartmentID int,
	@PostID int
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY		
			INSERT INTO [RefData].[Employee]
			(
				[EmployeeFirstName]
				,[EmployeeLastName]
				,[EmployeeMiddleName]
				,[EmployeeDOB]
				,[DepartmentID]
				,[PostID]
			)
			VALUES
			(  
				@EmployeeFirstName
				,@EmployeeLastName
				,@EmployeeMiddleName
				,@EmployeeDOB
				,@DepartmentID
				,@PostID
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertInsurer]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertInsurer] 
@InsurerRegNum nvarchar(12),
@InsurerFullName nvarchar(1000),
@InsurerShortName nvarchar(1000),
@InsurerLastName nvarchar(255),
@InsurerFirstName nvarchar(255),
@InsurerMiddleName nvarchar(255),
@InsurerJurZipCode nvarchar(6),
@InsurerJurHouse nvarchar(50),
@InsurerJurBuilding nvarchar(50),
@InsurerJurFlat nvarchar(50),
@InsurerJurSubject nvarchar(255),
@InsurerJurRegion nvarchar(255),
@InsurerJurCity nvarchar(255),
@InsurerJurTown nvarchar(255),
@InsurerJurStreet nvarchar(255),
@InsurerFactZipcode nvarchar(6),
@InsurerFactHouse nvarchar(50),
@InsurerFactBuilding nvarchar(50),
@InsurerFactSubject nvarchar(255),
@InsurerFactRegion nvarchar(255),
@InsurerFactCity nvarchar(255),
@InsurerFactTown nvarchar(255),
@InsurerFactStreet nvarchar(255),
@InsurerFactFlat nvarchar(50),
@IsFactEqualsJuridical bit
AS
	SET NOCOUNT ON;
	IF 
		@IsFactEqualsJuridical = 1 
	BEGIN
	   SET @InsurerFactZipcode = @InsurerJurZipCode;
	   SET @InsurerFactHouse = @InsurerJurHouse;
	   SET @InsurerFactBuilding = @InsurerJurBuilding;
       SET @InsurerFactSubject = @InsurerJurSubject;
       SET @InsurerFactRegion =  @InsurerJurRegion;
       SET @InsurerFactCity = @InsurerJurCity;
       SET @InsurerFactTown = @InsurerJurTown;
       SET @InsurerFactStreet = @InsurerJurStreet;
       SET @InsurerFactFlat = @InsurerJurFlat;	
	END;

	INSERT INTO [dbo].[Insurer]
           ([InsurerRegNum]
           ,[InsurerFullName]
           ,[InsurerShortName]
           ,[InsurerLastName]
           ,[InsurerFirstName]
           ,[InsurerMiddleName]
           ,[InsurerJurZipCode]
           ,[InsurerJurHouse]
           ,[InsurerJurBuilding]
           ,[InsurerJurFlat]
           ,[InsurerJurSubject]
           ,[InsurerJurRegion]
           ,[InsurerJurCity]
           ,[InsurerJurTown]
           ,[InsurerJurStreet]
           ,[InsurerFactZipcode]
           ,[InsurerFactHouse]
           ,[InsurerFactBuilding]
           ,[InsurerFactSubject]
           ,[InsurerFactRegion]
           ,[InsurerFactCity]
           ,[InsurerFactTown]
           ,[InsurerFactStreet]
           ,[InsurerFactFlat])
	VALUES
			(@InsurerRegNum
			,@InsurerFullName
			,@InsurerShortName
			,@InsurerLastName
			,@InsurerFirstName
			,@InsurerMiddleName
			,@InsurerJurZipCode
			,@InsurerJurHouse
			,@InsurerJurBuilding
			,@InsurerJurFlat
			,@InsurerJurSubject
			,@InsurerJurRegion
			,@InsurerJurCity
			,@InsurerJurTown
			,@InsurerJurStreet
			,@InsurerFactZipcode
			,@InsurerFactHouse
			,@InsurerFactBuilding
			,@InsurerFactSubject
			,@InsurerFactRegion
			,@InsurerFactCity
			,@InsurerFactTown
			,@InsurerFactStreet
			,@InsurerFactFlat);
	
GO
/****** Object:  StoredProcedure [Application].[InsertInsurerFile]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertInsurerFile] (
	@InsurerID bigint,
	@InsurerFileINumber nvarchar(50),
	@InsurerFileYear nvarchar(8)
)
AS
	SET NOCOUNT ON;
	INSERT INTO [JurCase].[InsurerFile]
           ([InsurerID]
           ,[InsurerFileINumber]
           ,[InsurerFileYear])
     VALUES
     (		
			@InsurerID,
			@InsurerFileINumber,
			@InsurerFileYear
	 )
GO
/****** Object:  StoredProcedure [Application].[InsertLegalDecision]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Application].[InsertLegalDecision]
	@LawCaseNumber nvarchar(16),
	@DateToUpfr datetime2(7),
	@LegalDecisionSumm decimal(17,2),
	@DateToPU datetime2(7),
	@LegalDecisionSummDenied decimal(17,2),
	@StateLegalDecisionID bigint,
	@LegalDecisionName nvarchar(150),
	@DocOutID bigint
AS
	SET NOCOUNT ON;
	DECLARE @InsVals TABLE
	(
		LegalDecisionID bigint
	)
	BEGIN TRAN
		BEGIN TRY		
			INSERT INTO [JurCase].[LegalDecision]
			(
				[LawCaseNumber]
				,[DateToUpfr]
				,[LegalDecisionSumm]
				,[DateToPU]
				,[LegalDecisionSummDenied]
				,[StateLegalDecisionID]
				,[LegalDecisionName]
			)
			OUTPUT inserted.LegalDecisionID INTO @InsVals 
			VALUES
			(				
				@LawCaseNumber
				,@DateToUpfr
				,@LegalDecisionSumm
				,@DateToPU
				,@LegalDecisionSummDenied
				,@StateLegalDecisionID
				,@LegalDecisionName
			)
			UPDATE [JurCase].[DocOut] SET LegalDecisionID = (SELECT TOP 1 LegalDecisionID FROM @InsVals) WHERE DocOutID = @DocOutID;
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
	IF @@TRANCOUNT > 0  
		COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertOPFR]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Application].[InsertOPFR]
	@OPFRName [nvarchar](150),
	@OPFRAddress [nvarchar](250),
	@OPFRPhone [nvarchar](11),
	@OPFRFax [nvarchar](11),
	@OPFREmail [nvarchar](50),
	@OKPO [nvarchar](10),
	@OGRN [nvarchar](20),
	@INN_KPP [nvarchar](25)
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[OPFR]
           (
				[OPFRName],
				[OPFRAddress],
				[OPFRPhone],
				[OPFRFax],
				[OPFREmail],
				[OKPO],
				[OGRN],
				[INN_KPP]
			)
			VALUES
			(
				@OPFRName,
				@OPFRAddress,
				@OPFRPhone,
				@OPFRFax,
				@OPFREmail,
				@OKPO,
				@OGRN,
				@INN_KPP
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertPenaltyType]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [Application].[InsertPenaltyType]
	@NN [bigint],
	@Number [nvarchar](5),
	@Description [nvarchar](50),
	@Year [smallint]
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[Nomenclature]
           (
				[NN],
				[Number],
				[Description],
				[Year]
			)
			VALUES
			(
				@NN,
				@Number,
				@Description,
				@Year
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertPost]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [Application].[InsertPost]
	@PostName [nvarchar](100)
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[Post]
            (
				PostName				
			)
			VALUES
            (
				@PostName				
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertState]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Application].[InsertState]
	@StateName  nvarchar(150),
	@Note nvarchar(max)
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
			INSERT INTO [RefData].[State]
            (
				[StateName]
				,[Note]
			)
			VALUES
            (
				@StateName,
				@Note
			)
		END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
/****** Object:  StoredProcedure [Application].[InsertStateLegalDecision]    Script Date: 27.08.2021 17:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [Application].[InsertStateLegalDecision]
	@StateLegalDecisionName	nvarchar(100)
AS
	SET NOCOUNT ON;
	BEGIN TRAN
		BEGIN TRY	
		INSERT INTO [RefData].[StateLegalDecision]
           (
				[StateLegalDecisionID]
				,[StateLegalDecisionName]
			)
		VALUES
		(
			NEXT VALUE FOR [RefData].[seqStateLegalDecision]  
           ,@StateLegalDecisionName
		)
	END TRY  
		BEGIN CATCH  
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;  
  
			IF @@TRANCOUNT > 0  
				ROLLBACK TRANSACTION;  
		END CATCH;  
  
		IF @@TRANCOUNT > 0  
			COMMIT TRANSACTION;  
GO
