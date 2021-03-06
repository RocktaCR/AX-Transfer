USE [MDSPOC]
GO
/****** Object:  StoredProcedure [dbo].[TruncateDomainTables]    Script Date: 10/9/2020 5:25:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TruncateDomainTables] 
	@Domain nvarchar(100),
	@Staging nvarchar(100),
	@BatchTag nvarchar(100)
AS
BEGIN
    Declare @SourceTable nvarchar(50)
	Declare @SourceEntityID int
	Declare @SourceModelID int
	Declare @script nvarchar(1000)
	SELECT @SourceModelID = ID from [mdm].[tblModel] where [Name] = 'AX' 
	SELECT @SourceEntityID = ID from [mdm].[tblEntity] where Model_ID = @SourceModelID and [Name] = @Domain
	SELECT @SourceTable = EntityTable from [mdm].[tblEntity] where ID = @SourceEntityID
	
	Set @script = ' TRUNCATE TABLE [stg].['+@Staging+'_Leaf]'

	exec sp_executesql @script
	
	Set @script = 'INSERT INTO [stg].['+@Staging+'_Leaf] (ImportType,ImportStatus_ID,BatchTag,Code)
	SELECT
	4 AS ImportType
	,0 AS ImportStatus_ID
	,'''+@BatchTag+''' AS BatchTag
	,Code
	FROM mdm.'+@SourceTable+' ' 
	exec sp_executesql @script

	Set @script = '[stg].[udp_'+@Staging+'_Leaf] @VersionName = ''VERSION_1'', @LogFlag = 0, @BatchTag = '''+@BatchTag+''''
	exec sp_executesql @script


	Set @script = 'TRUNCATE TABLE stg.['+@Staging+'_Leaf]'
	exec sp_executesql @script

	Set @script = 'mdm.udpDeletedMembersPurge @ModelName = N''AX'', @EntityName = N'''+@Domain+''', @VersionName = N''Version_1'''
	exec sp_executesql @script

	Set @script = 'UPDATE i SET i.LargestCodeValue = 0
					FROM mdm.tblEntity e
					JOIN [mdm].[tblCodeGenInfo] i ON i.EntityId = e.id
					WHERE  model_id = '+cast(@SourceModelID as nvarchar(100)) +' AND NAME = '''+@Domain+''''

    exec sp_executesql @script

END




