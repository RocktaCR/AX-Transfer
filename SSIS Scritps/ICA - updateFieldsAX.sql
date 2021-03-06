USE [ICADev4]
GO
/****** Object:  StoredProcedure [dbo].[updateFieldsAX]    Script Date: 10/12/2020 4:27:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[updateFieldsAX]
	@Name nvarchar(250),
	@Code nvarchar(100),
	@Entity nvarchar(100)
AS
BEGIN

Declare @Query nvarchar(1000)

Set @Query  = 'Update Query_BackUp Set ' +  (CASE WHEN ISNULL(@Entity,'') = '' THEN 'ProductType' ELSE @Entity END)  +  ' = ' +  ''''+ (CASE WHEN ISNULL(@Code,'') = '' THEN 'ProductType' ELSE @Code END) + '''' +' where '+ (CASE WHEN ISNULL(@Entity,'') = '' THEN 'ProductType' ELSE @Entity END) + ' = ' + ''''+ (CASE WHEN ISNULL(@Name,'') = '' THEN 'ProductType' ELSE REPLACE(@Name, '''','''''') END) + ''''
--print @query
Exec (@Query)
END
