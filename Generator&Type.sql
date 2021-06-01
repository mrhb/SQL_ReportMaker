USE [BankDB]
GO

/****** Object:  StoredProcedure [rpt].[ReportGenerator]    Script Date: 03/03/1400 10:10:52 ق.ظ ******/
DROP PROCEDURE [rpt].[ReportGenerator]
GO
USE [BankDB]
GO

/****** Object:  UserDefinedTableType [rpt].[ReportSettingType]    Script Date: 03/03/1400 10:10:38 ق.ظ ******/
DROP TYPE [rpt].SettingType
GO

/****** Object:  UserDefinedTableType [rpt].[ReportSettingType]    Script Date: 03/03/1400 10:10:38 ق.ظ ******/
CREATE TYPE [rpt].[SettingType] AS TABLE(
	[FieldName] [varchar](50) NULL,
	[AggreegateFunc] [varchar](10) NULL,
	[IsGrouped] [bit] NULL,
	CHECK (([AggreegateFunc]='VARP' OR [AggreegateFunc]='VAR' OR [AggreegateFunc]='SUM' OR [AggreegateFunc]='STRING_AGG' OR [AggreegateFunc]='STDEVP' OR [AggreegateFunc]='STDEV' OR [AggreegateFunc]='MIN' OR [AggreegateFunc]='MAX' OR [AggreegateFunc]='GROUPING_ID' OR [AggreegateFunc]='GROUPING' OR [AggreegateFunc]='COUNT_BIG' OR [AggreegateFunc]='COUNT' OR [AggreegateFunc]='CHECKSUM_AGG' OR [AggreegateFunc]='AVG' OR [AggreegateFunc]='APPROX_COUNT_DISTINCT' OR [AggreegateFunc]=''))
)
GO


/****** Object:  UserDefinedTableType [rpt].[FilterType]    Script Date: 03/03/1400 10:12:19 ق.ظ ******/
DROP TYPE [rpt].[FilterType]
GO

/****** Object:  UserDefinedTableType [rpt].[FilterType]    Script Date: 03/03/1400 10:12:19 ق.ظ ******/
CREATE TYPE [rpt].[FilterType] AS TABLE(
	[fldID] [int] NOT NULL,
	[fldFieldName] [nvarchar](50) NOT NULL,
	[fldFieldType] [nvarchar](10) NOT NULL,
	[fldOperator] [nvarchar](10) NOT NULL,
	[fldOprand] [nvarchar](max) NULL,
	PRIMARY KEY CLUSTERED 
(
	[fldID] ASC
)WITH (IGNORE_DUP_KEY = OFF),
	CHECK (([fldOperator]='x=a' OR [fldOperator]='x<>a' OR [fldOperator]='x<a' OR [fldOperator]='x<=a' OR [fldOperator]='x>a' OR [fldOperator]='x>=a' OR [fldOperator]='b<x<a' OR [fldOperator]='b<x<=a' OR [fldOperator]='b<=x<=a' OR [fldOperator]='b<=x<a' OR [fldOperator]='in' OR [fldOperator]='notIn' OR [fldOperator]='like'
	OR [fldFieldType]='NUMBER' OR [fldFieldType]='STRING' OR [fldFieldType]='DATETIME'))
)
GO

/****** Object:  StoredProcedure [rpt].[ReportGenerator]    Script Date: 03/03/1400 10:10:52 ق.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		m.Reza Hajjar
-- Create date: 1400/02/25
-- Description:	گزارش گیری با امکان شخصی سازی توسط کاربر
--این پروسجور اطلاعات تنظیمات گزارش را در قالب یک جدول از کاربر میگیرد  
-- و کوئری مناسب را میسازد
-- =============================================

CREATE PROCEDURE [rpt].[ReportGenerator] 
	-- Add the parameters for the stored procedure here
	@Setting SettingType READONLY,
	@Filters FilterType READONLY,
	@ReportName nvarchar(50) ,
	@index int,
	@pageSize int,
	@Query nvarchar(max) OUTPUT  
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--declare @Query nvarchar(max);
	--*******************Generate Criterias**********************
BEGIN TRY  
    declare @filter nvarchar(max);

	IF EXISTS (SELECT * FROM @filters )
		set @filter= CHAR(13)+ 'where ';
	else 
		set @filter= '';

	set @Query='select ';

    -- Insert statements for procedure here
	SELECT
	--@filter=  @filter+ rpt.criteriaBuilder(fldFieldName,'STRING',fldOperator,fldOprand) + 'AND'
	@filter=CASE  
			WHEN rpt.criteriaBuilder(fldFieldName,[fldFieldType],fldOperator,fldOprand) IS NULL THEN  @filter 
			ELSE   @filter +' '+ rpt.criteriaBuilder(fldFieldName,[fldFieldType],fldOperator,fldOprand) + 'AND'
		END
		--select *
	    From  @Filters as f
	set @filter=SUBSTRING(@filter,0,Len(@filter)-3)+' ';
	PRINT @filter
END TRY  
BEGIN CATCH  
    PRINT 'Error in Generate Criterias' 
END CATCH  
	--**************/Generate Criterias*******************************


	--**************/Generate Report*******************************
    -- Insert statements for procedure here
	SELECT @Query= CASE
         WHEN IsGrouped<1 and AggreegateFunc!=''  THEN @Query+' '+ AggreegateFunc+'('+FieldName+') '+FieldName+'_'+ AggreegateFunc+','  
         WHEN IsGrouped<1 and AggreegateFunc=''  THEN @Query+ ' COUNT('+FieldName+') '+FieldName+'_'+ AggreegateFunc+','  
         ELSE @Query+' '+FieldName+' AS '+FieldName+','  
       END 
	    From  @Setting

select @Query=reverse(stuff(reverse(@Query), 1, 1, ''))


	SELECT @Query= @Query+ CHAR(10)+ 'From '+@ReportName+ @filter + CHAR(13) +'Group by ';

	SELECT @Query= CASE
         WHEN IsGrouped<1  THEN @Query
         ELSE @Query+ ' '+FieldName+','
       END 
	    From  @Setting


			SELECT *
	    From  @Setting
select @Query=reverse(stuff(reverse(@Query), 1, 1, ''))
SELECT @Query= @Query+  CHAR(13) + ' OFFSET '+CAST(@pageSize as varchar(10)) +'*('+CAST(@index as varchar(10))+' -1) rows  FETCH NEXT '+CAST(@pageSize as varchar(10))+' rows only'

		PRINT @Query
RETURN
END
GO


