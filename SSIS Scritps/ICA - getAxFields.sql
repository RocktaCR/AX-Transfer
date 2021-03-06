USE [ICADev4]
GO
/****** Object:  StoredProcedure [dbo].[getAxFields]    Script Date: 10/27/2020 10:57:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
alter PROCEDURE [dbo].[getAxFields]
	@ColumnName nvarchar(max) 
AS
BEGIN
	 Declare @script  nvarchar(1000)
	 IF @ColumnName = 'Bit'
	 BEGIN
	 SET @script = 'SELECT 0 as RowNum, ''False'' as Name 
					UNION SELECT 1 as RowNum,  ''True'' as Name'
	 END
	 ElSE if @ColumnName = 'BOM_Unit'
	 set @script = 'Select Row_Number() OVER (ORDER BY t2.Name ASC) AS RowNum,t2.* from ( 
						Select distinct Name from (
						Select distinct BOM_Unit as Name From Query where BOM_Unit is not null 
						union all Select distinct InventoryUnit as Name From Query where InventoryUnit is not null 
						union all Select distinct SoldUnit as Name From Query where SoldUnit is not null 
						union all Select distinct Unit as Name From Query where Unit is not null 
						union all Select distinct UnitUnitsequenceGroupID as Name From Query where UnitUnitsequenceGroupID is not null ) as t3
					) as t2 
					where t2.Name <> '''' and t2.Name <> ''NULL'''
	 Else if @ColumnName = 'DeliveryDateControl'
	  Begin
	    SET @script = 'SELECT 0 as RowNum,  ''None'' as Name 
					   UNION 
					   SELECT 1 as RowNum,  ''SalesLeadTime'' as Name
					   UNION 
					   SELECT 2 as RowNum,  ''ATP'' as Name
					   UNION 
					   SELECT 3 as RowNum,  ''ATPPlusIssueMargin'' as Name
					   UNION 
					   SELECT 4 as RowNum,  ''CTP'' as Name'
	 end
	Else if @ColumnName = 'ProductSubType'
	 Begin
	   SET @script = 'SELECT 0 as RowNum,  ''Product'' as Name 
					  UNION 
					  SELECT 1 as RowNum,  ''Product Master'' as Name'
	 END
	Else if @ColumnName = 'ProductClass' or @ColumnName = 'BusinessUnit' or @ColumnName = 'Vendor' or @columnName = 'ProductType2' 
	 Begin
	  set @script = 'Select Code as RowNum, EntityValue as Name from AX_Values where Entity  = '''+@ColumnName+''''
	 end
	Else
	 Begin
	 set @script = 'Select Row_Number() OVER (ORDER BY t2.Name ASC) AS RowNum,t2.* from ( Select distinct ' + (CASE WHEN isnull(@ColumnName,'') = '' THEN 'ProductType' ELSE @ColumnName END )+ ' as Name From Query where ' + (CASE WHEN isnull(@ColumnName,'') = '' THEN 'ProductType' ELSE @ColumnName END )+ ' is not null) as t2 where t2.Name <> '''' and t2.Name <> ''NULL'''
	 End
	 exec sp_executesql @script

END
