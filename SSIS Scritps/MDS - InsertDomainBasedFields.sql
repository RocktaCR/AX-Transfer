USE [MDSPOC]
GO
/****** Object:  StoredProcedure [dbo].[InsertDomainBasedFields]    Script Date: 10/9/2020 8:04:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Jorge Solano>
-- Create date: <7/7/2020>
-- Description:	<SP to update the ProductCode and MasterCode of AX product all based on PSOT information, MDS script>
-- =============================================
CREATE PROCEDURE [dbo].[InsertDomainBasedFields]
	@Entity nvarchar(100),
	@EName nvarchar(250),
	@ECode nvarchar(250),
	@BatchTag nvarchar(100),
	@ImportType int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
-- =============================================
--Inserts
-- =============================================
--Insert on Staging Table
SET @EName = REPLACE(@EName, '''', '')
Declare @Script nvarchar(max)

		Set @Script ='Insert Into [stg].['+@Entity+'_Leaf] (ImportType, BatchTag, [Code], [Name] )
			Values ('+cast(@ImportType as varchar)+','''+@BatchTag+''','''+@ECode+''','''+ @EName+''')'
		
--Insert on Staging Table
exec sp_executesql @Script
WITH RESULT SETS NONE;

--print  @Script
END
