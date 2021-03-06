USE [MDSPOC]
GO
/****** Object:  StoredProcedure [dbo].[AXETL_ValidateEntities]    Script Date: 10/27/2020 10:51:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AXETL_ValidateEntities] 
	@Entity_Name nvarchar(100)
AS
BEGIN


DECLARE @ModelName nVarchar(50) = 'AX'
DECLARE @Model_id int
DECLARE @UserName nvarchar(50)= 'NOVUS\Jorge.Solano'
DECLARE @User_ID int
DECLARE @Version_ID int
Declare @Entity_ID nvarchar(100)
SET @User_ID = (SELECT ID
                 FROM mdm.tblUser u
                 WHERE u.UserName = @UserName)
SET @Model_ID = (SELECT Top 1 Model_ID
                 FROM mdm.viw_SYSTEM_SCHEMA_VERSION
                 WHERE Model_Name = @ModelName)
SET @Version_ID = (SELECT MAX(ID)
                 FROM mdm.viw_SYSTEM_SCHEMA_VERSION
                 WHERE Model_ID = @Model_ID)
SET @Entity_ID = (Select top 1 ID from mdm.tblEntity where [Model_ID] = @Model_ID and [Name] = @Entity_Name)



EXECUTE mdm.[udpValidateEntity] @User_ID,@Version_ID, @Entity_ID



END




