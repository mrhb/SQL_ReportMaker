
/****** Object:  StoredProcedure [rpt].[QueryGenerator]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP PROCEDURE [rpt].[QueryGenerator]
GO

/****** Object:  StoredProcedure [rpt].[FormGenerator]    Script Date: 10/03/1400 12:32:46 ب.ظ ******/
DROP PROCEDURE [rpt].[FormGenerator]
GO

/****** Object:  Table [rpt].[tblSettingTemp]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt].[tblSettingTemp]') AND type in (N'U'))
DROP TABLE [rpt].[tblSettingTemp]
GO
/****** Object:  Table [rpt].[tblSetting]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt].[tblSetting]') AND type in (N'U'))
DROP TABLE [rpt].[tblSetting]
GO
/****** Object:  Table [rpt].[tblGroups]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt].[tblGroups]') AND type in (N'U'))
DROP TABLE [rpt].[tblGroups]
GO
/****** Object:  Table [rpt].[tblFilter]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt].[tblFilter]') AND type in (N'U'))
DROP TABLE [rpt].[tblFilter]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[rpt].[tblFilds]') AND type in (N'U'))
DROP TABLE [rpt].[tblFilds]
GO

/****** Object:  UserDefinedFunction [rpt].[String_criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP FUNCTION [rpt].[String_criteriaBuilder]
GO
/****** Object:  UserDefinedFunction [rpt].[Number_criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP FUNCTION [rpt].[Number_criteriaBuilder]
GO
/****** Object:  UserDefinedFunction [rpt].[DateTime_criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP FUNCTION [rpt].[DateTime_criteriaBuilder]
GO
/****** Object:  UserDefinedFunction [rpt].[criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP FUNCTION [rpt].[criteriaBuilder]
GO
/****** Object:  UserDefinedTableType [rpt].[SettingType]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP TYPE [rpt].[SettingType]
GO
/****** Object:  UserDefinedTableType [rpt].[FilterType]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP TYPE [rpt].[FilterType]
GO
/****** Object:  Schema [rpt]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
DROP SCHEMA [rpt]
GO
/****** Object:  Schema [rpt]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
CREATE SCHEMA [rpt]
GO
/****** Object:  UserDefinedTableType [rpt].[FilterType]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
CREATE TYPE [rpt].[FilterType] AS TABLE(
	[fldID] [bigint] IDENTITY(1,1) NOT NULL,
	[fldFieldName] [nvarchar](50) NOT NULL,
	[fldFieldType] [nvarchar](10) NOT NULL,
	[fldOperator] [nvarchar](10) NOT NULL,
	[fldOprand] [nvarchar](max) NULL,
	CHECK (([fldOperator]='x=a' OR [fldOperator]='x<>a' OR [fldOperator]='x<a' OR [fldOperator]='x<=a' OR [fldOperator]='x>a' OR [fldOperator]='x>=a' OR [fldOperator]='b<x<a' OR [fldOperator]='b<x<=a' OR [fldOperator]='b<=x<=a' OR [fldOperator]='b<=x<a' OR [fldOperator]='in' OR [fldOperator]='notIn' OR [fldOperator]='like' OR [fldFieldType]='NUMBER' OR [fldFieldType]='STRING' OR [fldFieldType]='DATETIME'))
)
GO
/****** Object:  UserDefinedTableType [rpt].[SettingType]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
CREATE TYPE [rpt].[SettingType] AS TABLE(
	[FieldName] [varchar](50) NULL,
	[AggreegateFunc] [varchar](10) NULL,
	[IsGrouped] [bit] NULL,
	CHECK (([AggreegateFunc]='VARP' OR [AggreegateFunc]='VAR' OR [AggreegateFunc]='SUM' OR [AggreegateFunc]='STRING_AGG' OR [AggreegateFunc]='STDEVP' OR [AggreegateFunc]='STDEV' OR [AggreegateFunc]='MIN' OR [AggreegateFunc]='MAX' OR [AggreegateFunc]='GROUPING_ID' OR [AggreegateFunc]='GROUPING' OR [AggreegateFunc]='COUNT_BIG' OR [AggreegateFunc]='COUNT' OR [AggreegateFunc]='CHECKSUM_AGG' OR [AggreegateFunc]='AVG' OR [AggreegateFunc]='APPROX_COUNT_DISTINCT' OR [AggreegateFunc]=''))
)
GO
/****** Object:  UserDefinedFunction [rpt].[criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		M.Reza Hajjar
-- Create date: 1400/03/02
-- Description: این تابع  ورودی ها را به رشته معتبری از محدودیت تبدیل میکند 
-- و در صورت بروز خطا آنرا در پیامها پرینت میکند
-- =============================================
CREATE FUNCTION [rpt].[criteriaBuilder]
(	
	@FieldName [nvarchar](50),
	@FieldType [nvarchar](10),
	@Operator  [nvarchar](10),
	@Oprand    [nvarchar](max)
)
RETURNS nvarchar(50)  
AS
BEGIN
	declare @Criteria [nvarchar](50);
   SET @Criteria =   
        CASE  
			WHEN @FieldType='DATE&TIME' THEN [rpt].[DateTime_criteriaBuilder](@FieldName,@Operator,@Oprand)
			WHEN @FieldType='NUMBER' THEN  [rpt].[Number_criteriaBuilder](@FieldName,@Operator,@Oprand)
			WHEN @FieldType='STRING' THEN  [rpt].[String_criteriaBuilder](@FieldName,@Operator,@Oprand)
			ELSE  'null in Criteria Builder'
		END;  
RETURN  @Criteria;
END;  
GO
/****** Object:  UserDefinedFunction [rpt].[DateTime_criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		M.Reza Hajjar
-- Create date: 1400/03/02
-- Description: این تابع  ورودی ها را به رشته معتبری از محدودیت تبدیل میکند 
-- و در صورت بروز خطا آنرا در پیامها پرینت میکند
-- =============================================
CREATE FUNCTION [rpt].[DateTime_criteriaBuilder]
(	
	@FieldName [nvarchar](50),
	@Operator  [nvarchar](10),
	@Oprand    [nvarchar](max)
)
RETURNS nvarchar(50)   
AS
BEGIN
	-- Declare the return variable here
	DECLARE @criteria nvarchar(50)  

	-- Add the T-SQL statements to compute the return value here
	SELECT @criteria = null

	-- Return the result of the function
	RETURN @criteria

END
GO
/****** Object:  UserDefinedFunction [rpt].[Number_criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		M.Reza Hajjar
-- Create date: 1400/03/02
-- Description: این تابع  ورودی ها را به رشته معتبری از محدودیت تبدیل میکند 
-- و در صورت بروز خطا آنرا در پیامها پرینت میکند
-- =============================================
CREATE FUNCTION [rpt].[Number_criteriaBuilder]
(	
	@FieldName [nvarchar](50),
	@Operator  [nvarchar](10),
	@Oprand    [nvarchar](max)
)
RETURNS nvarchar(50)   
AS
BEGIN 
	declare @Criteria [nvarchar](50)=' ';
	 
declare @indx  int,@Oprand_a [nvarchar](max),@Oprand_b [nvarchar](max);
if (@Oprand='') return null; 
select @indx=CHARINDEX('@@',@Oprand)
select  @Oprand_a=@Oprand
IF (@indx>0)
BEGIN
	select  @Oprand_a=LEFT(@Oprand,@indx - 1)
	select  @Oprand_b=Right(@Oprand,LEN(@Oprand)-@indx) 
END


	
IF ((CHARINDEX('x>',@Operator)>0) or  (CHARINDEX('x<',@Operator)>0))
	BEGIN
		SET @Criteria = REPLACE(@Operator, 'x', '['+@FieldName+']');
		IF ((CHARINDEX('a',@Operator)>0))
			BEGIN
				SET @Criteria =SUBSTRING(@Criteria, 1,Len(@Criteria)-1) + @Oprand_a;
			END
		IF ((CHARINDEX('b',@Operator)>0))
			BEGIN
			if (@Oprand_b='') return null;
				SET @Criteria = @Oprand_b + SUBSTRING(@Criteria, 2,Len(@Criteria)) ;
			END
	SET	@Criteria = @Criteria+' ';
	END
ELSE If(@Operator='in')
	BEGIN
		SET	@Criteria ='['+@FieldName+'] IN ('+REPLACE(@Oprand, '@@', ',')+') ';
	END
ELSE If( @Operator='notIn' )
	BEGIN
		SET	@Criteria ='['+@FieldName+'] NOT IN ('+REPLACE(@Oprand, '@@', ',')+') ';
	END
ELSE	
	SET	@Criteria = 'NULL in Number_criteriaBuilder ' ;
	RETURN @criteria
END
GO
/****** Object:  UserDefinedFunction [rpt].[String_criteriaBuilder]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		M.Reza Hajjar
-- Create date: 1400/03/02
-- Description: این تابع  ورودی ها را به رشته معتبری از محدودیت تبدیل میکند 
-- و در صورت بروز خطا آنرا در پیامها پرینت میکند
-- =============================================
CREATE FUNCTION [rpt].[String_criteriaBuilder]
(	
	@FieldName [nvarchar](50),
	@Operator  [nvarchar](10),
	@Oprand    [nvarchar](max)
)
RETURNS nvarchar(50)   
AS
BEGIN 

declare @indx  int;


declare @Criteria [nvarchar](50);

If(@Operator='like')
	BEGIN
		select @indx=CHARINDEX('@@',@Oprand)
		if (@indx>0) return null;	
		SET	@Criteria =  '['+@FieldName+'] like %'+@Oprand+'@@ ';
	END
ELSE If(@Operator='in')
	BEGIN
		SET	@Criteria ='['+@FieldName+'] IN ('+REPLACE(@Oprand, '@@', ',')+') ';
	END
ELSE If( @Operator='notIn' )
	BEGIN
		SET	@Criteria ='['+@FieldName+'] NOT IN ('+REPLACE(@Oprand, '@@', ',')+') ';
	END
ELSE	
	SET	@Criteria =  'NULL';
	RETURN @criteria
END
GO
/****** Object:  Table [rpt].[tblFilter]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[tblFilter](
	[fldID] [bigint] IDENTITY(1,1) NOT NULL,
	[fldUserId] [nvarchar](150) NOT NULL,
	[fldReportName] [nvarchar](50) NOT NULL,
	[fldFieldName] [nvarchar](50) NOT NULL,
	[fldOperator] [nvarchar](10) NOT NULL,
	[fldOprand] [nvarchar](max) NULL,
		CHECK (([fldOperator]='x=a' OR [fldOperator]='x<>a' OR [fldOperator]='x<a' OR [fldOperator]='x<=a' OR [fldOperator]='x>a' OR [fldOperator]='x>=a' OR [fldOperator]='b<x<a' OR [fldOperator]='b<x<=a' OR [fldOperator]='b<=x<=a' OR [fldOperator]='b<=x<a' OR [fldOperator]='in' OR [fldOperator]='notIn' OR [fldOperator]='like' )),
CONSTRAINT [PK_tblFilter] PRIMARY KEY CLUSTERED 
(
	[fldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 

/****** Object:  Table [rpt].[tblGroups]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[tblGroups](
	[fldGroupName] [nvarchar](50) NOT NULL,
	[fldFieldName] [nvarchar](50) NOT NULL,
	[fldType] [nvarchar](50) NOT NULL,
	[fldAutoCompQuery] [nvarchar](50) NULL,
	[fldIsGroupable] [bit] NOT NULL,
	[fldFuncDef] [nvarchar](50) NOT NULL,
	[fldIsGroupedDef] [bit] NOT NULL,
	[fldIncludedDef] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [rpt].[tblSetting]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[tblSetting](
	[fldID] [bigint] IDENTITY(1,1) NOT NULL,
	[fldUserId] [nvarchar](150) NOT NULL,
	[fldGroupName] [nvarchar](50) NOT NULL,
	[fldReportName] [nvarchar](50) NOT NULL,
	[FieldName] [varchar](50) NULL,
	[AggreegateFunc] [varchar](10) NULL,
	[IsGrouped] [bit] NULL, CONSTRAINT [PK_tblSetting] PRIMARY KEY CLUSTERED 
(
	[fldID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 

/****** Object:  Table [rpt].[tblSettingTemp]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [rpt].[tblSettingTemp](
	[Included] [bit] NOT NULL,
	[fldUserId] [nvarchar](150) NULL,
	[FieldName] [varchar](50) NULL,
	[AggreegateFunc] [varchar](10) NULL,
	[IsGrouped] [bit] NULL,
	[fldFilterOperator] [nvarchar](10)  NULL,
) ON [PRIMARY]
GO



/****** Object:  Table [rpt].[tblFilds]    Script Date: 05/03/1400 01:57:01 ب.ظ ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [rpt].[tblFilds](
	[fldName] [nvarchar](500) NULL,
	[fldFildName] [nvarchar](500) NULL,
	[fldFieldType] [nvarchar](50) NOT NULL,
	[fldOperator] [nvarchar](10) NOT NULL,
	[fldOrder] [int] NULL,
	[fldStyle] [nvarchar](max) NULL,
	[fldFildLabelTdStyle] [nvarchar](max) NULL,
	[fldFildDivStyle] [nvarchar](max) NULL,
	[fldFildTdStyle] [nvarchar](max) NULL,
	[flDModal] [nvarchar](50) NULL,
	[fldTypeCode] [nvarchar](20) NULL,
	[fldDisable] [bit] NULL,
	[fldVisible] [bit] NULL,
	[fldRegularExp] [nvarchar](250) NULL,
	[fldAutoCompelete] [nvarchar](max) NULL,
	[fldDefault] [nvarchar](100) NULL,
	[fldTypeName] [nvarchar](50) NULL,
	[fldNewLine] [bit] NULL,
	[fldSize] [nvarchar](50) NULL,
	[fldSubmitName] [nvarchar](50) NULL,
	[fldSubmitQuery] [nvarchar](200) NULL,
	[fldSubmitRedirect] [nvarchar](500) NULL,
	[fldLabelText] [nvarchar](max) NULL,
	[fldListQuery] [nvarchar](max) NULL,
	[fldListTitle] [nvarchar](150) NULL,
	[fldframeURL] [nvarchar](max) NULL,
	[fldframeHeight] [nvarchar](50) NULL,
	[fldIsComputedFilde] [bit] NULL,
	[fldComputedQuery] [nvarchar](200) NULL,
	[fldComputedDependenceFilde] [nvarchar](500) NULL,
	[fldLabel] [bit] NULL,
	[fldFrameWith] [nvarchar](20) NULL,
	[fldButtonOnClick] [nvarchar](1350) NULL,
	[fldTextAreaRows] [int] NULL,
	[fldTextAreaColumns] [int] NULL,
	[fldSubmitConfirm] [bit] NULL,
	[fldSubmitConfirmMessage] [nvarchar](450) NULL,
	[fldIsPassWord] [bit] NULL,
	[fldEncrypt] [bit] NULL,
	[fldencryptionKey] [nvarchar](max) NULL,
	[fldSplit] [bit] NULL,
	[fldDate] [bit] NULL,
	[fldFixDate] [bit] NULL,
	[fldWaitOnSubmit] [bit] NULL,
	[fldDisableAfterDone] [bit] NULL,
	[fldDate10] [bit] NULL,
	[fldFileAccept] [nvarchar](100) NULL,
	[fldFileMaxSize] [bigint] NULL,
	[fldRequired] [bit] NULL,
	[fldSubmitPreControl] [nvarchar](250) NULL,
	[fldFileMultiple] [bit] NULL,
	[fldDirectScan] [bit] NULL,
	[fldEnClient] [bit] NULL,
	[fldReportName] [nvarchar](250) NULL,
	[fldAutoSplitChar] [nvarchar](250) NULL,
	[fldPlaceHolder] [nvarchar](250) NULL,
	[fldProgram] [nvarchar](250) NULL,
	[fldLazyReport] [bit] NULL,
	[fldAccess] [bit] NULL,
	[fldLog] [bit] NULL,
	[fldSubmitLog] [nvarchar](250) NULL,
	[fldSync] [bit] NULL,
	[fldSubmitSuccessfullMessage] [nvarchar](1500) NULL,
	[fldGroupName] [nvarchar](250) NULL,
CHECK (([fldOperator]='' OR[fldOperator]='x=a' OR [fldOperator]='x<>a' OR [fldOperator]='x<a' OR [fldOperator]='x<=a' OR [fldOperator]='x>a' OR [fldOperator]='x>=a' OR [fldOperator]='b<x<a' OR [fldOperator]='b<x<=a' OR [fldOperator]='b<=x<=a' OR [fldOperator]='b<=x<a' OR [fldOperator]='in' OR [fldOperator]='notIn' OR [fldOperator]='like' OR [fldFieldType]='NUMBER' OR [fldFieldType]='STRING' OR [fldFieldType]='DATETIME'))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO



/****** Object:  StoredProcedure [rpt].[QueryGenerator]    Script Date: 05/03/1400 08:19:16 ق.ظ ******/
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

CREATE PROCEDURE [rpt].[QueryGenerator] 
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

	set @Query='select top 100  ';

    -- Insert statements for procedure here
	SELECT
	--@filter=  @filter+ rpt.criteriaBuilder(fldFieldName,'STRING',fldOperator,fldOprand) + 'AND'
	@filter=CASE  
			WHEN rpt.criteriaBuilder(fldFieldName,[fldFieldType],fldOperator,fldOprand) IS NULL THEN  @filter 
			ELSE   @filter +' '+ rpt.criteriaBuilder(fldFieldName,[fldFieldType],fldOperator,fldOprand) + 'AND'
		END
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
         WHEN IsGrouped<1 and AggreegateFunc=''  THEN @Query+ ' COUNT('+FieldName+') '+FieldName+'_COUNT,'  
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

select @Query=reverse(stuff(reverse(@Query), 1, 1, ''))
--SELECT @Query= @Query+  CHAR(13) + ' OFFSET '+CAST(@pageSize as varchar(10)) +'*('+CAST(@index as varchar(10))+' -1) rows  FETCH NEXT '+CAST(@pageSize as varchar(10))+' rows only'

		PRINT @Query
RETURN
END
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [rpt].[FormGenerator]
	  @userId [nvarchar](150) ,
	  @ReportName [nvarchar](50) ,
	  @GroupName [nvarchar](50)
AS
BEGIN
declare @QueryAndReportName  nvarchar(200),@connection nvarchar(100),
@fldName  [nvarchar](50),@fldFormId bigint ,@btnRefreshReportID bigint,@fldReportID bigint,@tblReportID bigint



select @fldName='rptcnfg_'+@GroupName+'_'+ @ReportName

--پپیدا کردن شناسه فرم مربوطه
SELECT @fldFormId=fldID FROM  [tblForms] WHERE  fldName= @fldName
--حذف کوئری و گزارش قبلی تعریف شده
select @QueryAndReportName=N'rpt_Generated_Form'+CAST(@fldFormId AS VARCHAR) 
delete from [tblQuery] where fldName=@QueryAndReportName
delete from [tblReport] where [fldName]=@QueryAndReportName

--پیدا کردن شناسه دکمه ساخت کوئری گزارش در فرم مربوطه
SELECT @btnRefreshReportID=[fldID]
FROM [dbo].[tblFormFilds]
where fldFormID=@fldFormId and fldFildName= 'rpt_btnBuildQuery'

--پیدا کردن شناسه فیلد نمایش کوئری ساخته شده
SELECT @fldReportID=[fldID]
FROM [dbo].[tblFormFilds]
where fldFormID=@fldFormId and fldFildName=@QueryAndReportName

delete [dbo].[tblFildDependence]
where [fldFildID]=@fldReportID and  [fldFildDepID]=@btnRefreshReportID

delete from [dbo].[tblForms] where fldName= @fldName
delete from tblFormFilds where fldFormID= @fldFormId
 
INSERT INTO [dbo].[tblForms]
           (
		   [fldTitle]
           ,[fldName]
           --,[fldInputCount]
           ,[fldPreQuery]
           --,[fldAfterQuery]
           ,[fldScript]
           ,[fldStyle]
           ,[fldOnCloseCheck]
           ,[fldOnCloseCheckQuery]
           --,[fldProgram]
           ,[fldGroupName]
           ,[fldRefreshByChilds]
           ,[fldAccess]
           ,[fldLog]
           ,[fldOpenLog]
           ,[fldOfferWidth]
           ,[fldOfferHeight]
           --,[fldParentForm]
		   )
     VALUES
           (  N'فرم تنظیمات گزارش'+@ReportName
           ,@fldName
           --,<fldInputCount, int,>
           ,'simple'--,<fldPreQuery, nvarchar(200),>
           --<fldAfterQuery, nvarchar(max),>
           ,''--,<fldScript, nvarchar(max),>
           ,''--,<fldStyle, nvarchar(max),>
           ,0--,<fldOnCloseCheck, bit,>
           ,''--,<fldOnCloseCheckQuery, nvarchar(250),>
           --,<fldProgram, nvarchar(250),>
           ,'گزارش ساز'--,<fldGroupName, nvarchar(200),>
           ,0--,<fldRefreshByChilds, bit,>
           ,0--,<fldAccess, bit,>
           ,0--,<fldLog, bit,>
           ,''--,<fldOpenLog, nvarchar(250),>
           ,'50%'--,<fldOfferWidth, nvarchar(50),>
           ,'70%'--,<fldOfferHeight, nvarchar(50),>
           --,<fldParentForm, nvarchar(350),>
		   )

-- read form ID
SELECT @fldFormId=fldID FROM  [tblForms] WHERE  fldName= @fldName

select @QueryAndReportName=N'rpt_Generated_Form'+CAST(@fldFormId AS VARCHAR) ,@connection='BANK'



DECLARE  @filters rpt.FilterType
INSERT INTO @filters ([fldFieldName],[fldFieldType],[fldOperator],[fldOprand])
SELECT   
       f.[fldFieldName]+'_'+CAST(f.fldID as varchar(max))
	  ,S.fldType
      ,f.[fldOperator]
      ,f.[fldFieldName]--,f.[fldOprand]
  FROM [rpt].[tblFilter] as f
  outer APPLY 
   ( 
	SELECT g.fldType ,s.FieldName,g.fldFieldName, s.fldReportName  from   [rpt].[tblSetting] as s
     outer APPLY 
   ( 
   SELECT g.fldType ,g.fldFieldName  from  [rpt].[tblGroups]as g
	 where g.fldFieldName=S.FieldName and  g.fldGroupName=@GroupName 
   ) G 
	 where   fldGroupName=@GroupName and s.fldReportName=@ReportName and s.fldUserId=@userId
	 ) S 
  where  f.fldReportName=@ReportName  and f.fldFieldName=s.FieldName

INSERT INTO [dbo].[tblFormFilds]
           ([fldName]
           ,[fldFildName]
           ,[fldFormID]
           ,[fldOrder]
           ,[fldStyle]
           ,[fldFildLabelTdStyle]
           ,[fldFildDivStyle]
           ,[fldFildTdStyle]
           ,[flDModal]
           ,[fldTypeCode]
           ,[fldDisable]
           ,[fldVisible]
           ,[fldRegularExp]
           ,[fldAutoCompelete]
           ,[fldDefault]
           ,[fldTypeName]
           ,[fldNewLine]
           ,[fldSize]
           ,[fldSubmitName]
           ,[fldSubmitQuery]
           ,[fldSubmitRedirect]
           ,[fldLabelText]
           ,[fldListQuery]
           ,[fldListTitle]
           ,[fldframeURL]
           ,[fldframeHeight]
           ,[fldIsComputedFilde]
           ,[fldComputedQuery]
           ,[fldComputedDependenceFilde]
           ,[fldLabel]
           ,[fldFrameWith]
           ,[fldButtonOnClick]
           ,[fldTextAreaRows]
           ,[fldTextAreaColumns]
           ,[fldSubmitConfirm]
           ,[fldSubmitConfirmMessage]
           ,[fldIsPassWord]
           ,[fldEncrypt]
           ,[fldencryptionKey]
           ,[fldSplit]
           ,[fldDate]
           ,[fldFixDate]
           ,[fldWaitOnSubmit]
           ,[fldDisableAfterDone]
           ,[fldDate10]
           ,[fldFileAccept]
           ,[fldFileMaxSize]
           ,[fldRequired]
           ,[fldSubmitPreControl]
           ,[fldFileMultiple]
           ,[fldDirectScan]
           ,[fldEnClient]
           ,[fldReportName]
           ,[fldAutoSplitChar]
           ,[fldPlaceHolder]
           ,[fldProgram]
           ,[fldLazyReport]
           ,[fldAccess]
           ,[fldLog]
           ,[fldSubmitLog]
           ,[fldSync]
           ,[fldSubmitSuccessfullMessage]
           ,[fldGroupName])
     
SELECT 
		--'     ('+f.fldOprand+')         '+ isnull(D.fldValue,[fldName]) 
		'     ('+ isnull(D.fldValue,f.fldOprand) +')         '+ [fldName]
      ,f.fldFieldName
      ,@fldFormId
      ,[fldOrder]
      ,[fldStyle]
      ,[fldFildLabelTdStyle]
      ,[fldFildDivStyle]
      ,[fldFildTdStyle]
      ,[flDModal]
      ,[fldTypeCode]
      ,[fldDisable]
      ,[fldVisible]
      ,[fldRegularExp]
      ,[fldAutoCompelete]
      ,[fldDefault]
      ,[fldTypeName]
      ,[fldNewLine]
      ,[fldSize]
      ,[fldSubmitName]
      ,[fldSubmitQuery]
      ,[fldSubmitRedirect]
      ,[fldLabelText]
      ,[fldListQuery]
      ,[fldListTitle]
      ,[fldframeURL]
      ,[fldframeHeight]
      ,[fldIsComputedFilde]
      ,[fldComputedQuery]
      ,[fldComputedDependenceFilde]
      ,[fldLabel]
      ,[fldFrameWith]
      ,[fldButtonOnClick]
      ,[fldTextAreaRows]
      ,[fldTextAreaColumns]
      ,[fldSubmitConfirm]
      ,[fldSubmitConfirmMessage]
      ,[fldIsPassWord]
      ,[fldEncrypt]
      ,[fldencryptionKey]
      ,[fldSplit]
      ,[fldDate]
      ,[fldFixDate]
      ,[fldWaitOnSubmit]
      ,[fldDisableAfterDone]
      ,[fldDate10]
      ,[fldFileAccept]
      ,[fldFileMaxSize]
      ,[fldRequired]
      ,[fldSubmitPreControl]
      ,[fldFileMultiple]
      ,[fldDirectScan]
      ,[fldEnClient]
      ,[fldReportName]
      ,[fldAutoSplitChar]
      ,[fldPlaceHolder]
      ,[fldProgram]
      ,[fldLazyReport]
      ,[fldAccess]
      ,[fldLog]
      ,[fldSubmitLog]
      ,[fldSync]
      ,[fldSubmitSuccessfullMessage]
       ,'گزارش ساز'--,[fldGroupName]
	   from @filters AS f
 outer APPLY 
   ( 
   SELECT * FROM [rpt].[tblFilds] AS g
	 where f.fldFieldType=g.fldFieldType  and g.fldFieldType <>'DEFAULT'  and g.fldOperator= f.fldOperator
   ) G 
  outer apply(SELECT Top 1 [fldValue]   FROM [dbo].[tblDictionary] D 
  where D.fldKey=f.fldOprand
	) d
   /* افزودن فیلد های پیش فرض*/
INSERT INTO [dbo].[tblFormFilds]
           ([fldName]
           ,[fldFildName]
           ,[fldFormID]
           ,[fldOrder]
           ,[fldStyle]
           ,[fldFildLabelTdStyle]
           ,[fldFildDivStyle]
           ,[fldFildTdStyle]
           ,[flDModal]
           ,[fldTypeCode]
           ,[fldDisable]
           ,[fldVisible]
           ,[fldRegularExp]
           ,[fldAutoCompelete]
           ,[fldDefault]
           ,[fldTypeName]
           ,[fldNewLine]
           ,[fldSize]
           ,[fldSubmitName]
           ,[fldSubmitQuery]
           ,[fldSubmitRedirect]
           ,[fldLabelText]
           ,[fldListQuery]
           ,[fldListTitle]
           ,[fldframeURL]
           ,[fldframeHeight]
           ,[fldIsComputedFilde]
           ,[fldComputedQuery]
           ,[fldComputedDependenceFilde]
           ,[fldLabel]
           ,[fldFrameWith]
           ,[fldButtonOnClick]
           ,[fldTextAreaRows]
           ,[fldTextAreaColumns]
           ,[fldSubmitConfirm]
           ,[fldSubmitConfirmMessage]
           ,[fldIsPassWord]
           ,[fldEncrypt]
           ,[fldencryptionKey]
           ,[fldSplit]
           ,[fldDate]
           ,[fldFixDate]
           ,[fldWaitOnSubmit]
           ,[fldDisableAfterDone]
           ,[fldDate10]
           ,[fldFileAccept]
           ,[fldFileMaxSize]
           ,[fldRequired]
           ,[fldSubmitPreControl]
           ,[fldFileMultiple]
           ,[fldDirectScan]
           ,[fldEnClient]
           ,[fldReportName]
           ,[fldAutoSplitChar]
           ,[fldPlaceHolder]
           ,[fldProgram]
           ,[fldLazyReport]
           ,[fldAccess]
           ,[fldLog]
           ,[fldSubmitLog]
           ,[fldSync]
           ,[fldSubmitSuccessfullMessage]
           ,[fldGroupName])
     SELECT TOP (1000) 
	   [fldName]
      ,[fldFildName]
      ,@fldFormId
      ,[fldOrder]
      ,[fldStyle]
      ,[fldFildLabelTdStyle]
      ,[fldFildDivStyle]
      ,[fldFildTdStyle]
      ,[flDModal]
      ,[fldTypeCode]
      ,[fldDisable]
      ,[fldVisible]
      ,[fldRegularExp]
      ,[fldAutoCompelete]
      ,[fldDefault]
      ,[fldTypeName]
      ,[fldNewLine]
      ,[fldSize]
      ,[fldSubmitName]
      ,[fldSubmitQuery]
      ,[fldSubmitRedirect]
      ,[fldLabelText]
      ,[fldListQuery]
      ,[fldListTitle]
      ,[fldframeURL]
      ,[fldframeHeight]
      ,[fldIsComputedFilde]
      ,[fldComputedQuery]
      ,[fldComputedDependenceFilde]
      ,[fldLabel]
      ,[fldFrameWith]
      ,[fldButtonOnClick]
      ,[fldTextAreaRows]
      ,[fldTextAreaColumns]
      ,[fldSubmitConfirm]
      ,[fldSubmitConfirmMessage]
      ,[fldIsPassWord]
      ,[fldEncrypt]
      ,[fldencryptionKey]
      ,[fldSplit]
      ,[fldDate]
      ,[fldFixDate]
      ,[fldWaitOnSubmit]
      ,[fldDisableAfterDone]
      ,[fldDate10]
      ,[fldFileAccept]
      ,[fldFileMaxSize]
      ,[fldRequired]
      ,[fldSubmitPreControl]
      ,[fldFileMultiple]
      ,[fldDirectScan]
      ,[fldEnClient]
      ,[fldReportName]
      ,[fldAutoSplitChar]
      ,[fldPlaceHolder]
      ,[fldProgram]
      ,[fldLazyReport]
      ,[fldAccess]
      ,[fldLog]
      ,[fldSubmitLog]
      ,[fldSync]
      ,[fldSubmitSuccessfullMessage]
       ,'گزارش ساز'--,[fldGroupName]
  FROM [rpt].[tblFilds]
  where fldFieldType ='DEFAULT'
  /*افزودن فیلد گزارش*/
INSERT INTO [dbo].[tblFormFilds]
           ([fldName]
           ,[fldFildName]
           ,[fldFormID]
           ,[fldOrder]
           ,[fldStyle]
           ,[fldFildLabelTdStyle]
           ,[fldFildDivStyle]
           ,[fldFildTdStyle]
           ,[flDModal]
           ,[fldTypeCode]
           ,[fldDisable]
           ,[fldVisible]
           ,[fldRegularExp]
           ,[fldAutoCompelete]
           ,[fldDefault]
           ,[fldTypeName]
           ,[fldNewLine]
           ,[fldSize]
           ,[fldSubmitName]
           ,[fldSubmitQuery]
           ,[fldSubmitRedirect]
           ,[fldLabelText]
           ,[fldListQuery]
           ,[fldListTitle]
           ,[fldframeURL]
           ,[fldframeHeight]
           ,[fldIsComputedFilde]
           ,[fldComputedQuery]
           ,[fldComputedDependenceFilde]
           ,[fldLabel]
           ,[fldFrameWith]
           ,[fldButtonOnClick]
           ,[fldTextAreaRows]
           ,[fldTextAreaColumns]
           ,[fldSubmitConfirm]
           ,[fldSubmitConfirmMessage]
           ,[fldIsPassWord]
           ,[fldEncrypt]
           ,[fldencryptionKey]
           ,[fldSplit]
           ,[fldDate]
           ,[fldFixDate]
           ,[fldWaitOnSubmit]
           ,[fldDisableAfterDone]
           ,[fldDate10]
           ,[fldFileAccept]
           ,[fldFileMaxSize]
           ,[fldRequired]
           ,[fldSubmitPreControl]
           ,[fldFileMultiple]
           ,[fldDirectScan]
           ,[fldEnClient]
           ,[fldReportName]
           ,[fldAutoSplitChar]
           ,[fldPlaceHolder]
           ,[fldProgram]
           ,[fldLazyReport]
           ,[fldAccess]
           ,[fldLog]
           ,[fldSubmitLog]
           ,[fldSync]
           ,[fldSubmitSuccessfullMessage]
           ,[fldGroupName])VALUES
  (N'گزارش پویا', N'DynamicReport',@fldFormId, 1000,
N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ',
N'width: 50%; height: 10%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: inline; align-items: center; position: absolute; left: 10%; top: 10%; overflow: scroll;',
N'width: 100%;  z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center;left: 10%; top: 10%; overflow: scroll;',
N'', N'', N'REPORT', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 0, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL,@QueryAndReportName, N'', N'', NULL, 1, 0, 0, N'', 0, N'', N'')

--***********************ساخت کویری*********************
DECLARE  @setting rpt.SettingType
		,@command nvarchar(max)
delete @filters
INSERT INTO @filters ([fldFieldName],[fldFieldType],[fldOperator],[fldOprand])
SELECT   
       f.[fldFieldName]
	  ,S.fldType
      ,f.[fldOperator]
     -- , f.[fldOprand]
	  ,'#'+f.[fldFieldName]+'_'+CAST(f.fldID as varchar(max))+'#'
  FROM [rpt].[tblFilter] as f
  outer APPLY 
   ( 
	SELECT g.fldType ,s.FieldName,g.fldFieldName, s.fldReportName  from   [rpt].[tblSetting] as s
     outer APPLY 
   ( 
   SELECT g.fldType ,g.fldFieldName  from  [rpt].[tblGroups]as g
	 where g.fldFieldName=S.FieldName and  g.fldGroupName=@GroupName 
   ) G 
	 where   fldGroupName=@GroupName and s.fldReportName=@ReportName and s.fldUserId=@userId
	 ) S 
  where  f.fldReportName=@ReportName  and f.fldFieldName=s.FieldName

INSERT INTO @setting (FieldName, AggreegateFunc,IsGrouped)
select FieldName,AggreegateFunc ,IsGrouped
from rpt.tblSetting
where fldGroupName=@GroupName and fldReportName=@ReportName and fldUserId=@userId


EXEC	 [rpt].[QueryGenerator]
		@Setting = @setting,
		@Filters = @filters,
		@ReportName = @GroupName,
		@index =1,
		@pageSize =50,
		@Query = @command OUTPUT

--********************افزودن کویری************************


--set @command='SELECT TOP (100) [fldID]
--      ,[fldBedBesFlag]
--      ,[fldDate]
--      ,[fldTime]
--      ,[fldHesabType]
--      ,[fldHesabID]
--      ,[fldBed]
--      ,[fldBes]
--      ,[fldSanadID]
    
--  FROM [VsanadCustomer]'
INSERT INTO [dbo].[tblQuery]
           ([fldName]
           ,[fldCommand]
           ,[fldConnectionName]
           ,[fldProgram]
           ,[fldGroupName])
     VALUES
           (@QueryAndReportName
           ,@command
           ,@connection
           ,NULL
           ,'گزارش ساز ')
--*******************افزودن گزارش*****************
INSERT [tblReport] ( [fldName], [fldTitle], [fldHeadTitle], [fldQuery], [fldGroupName], [fldIntialize], [fldPerLineIntialize], [fldShowAllColumns], [fldDesignID], [fldSpecial], [fldSpecialPattern], [fldFootTitle], [fldQueryTitle], [fldBorder], [fldTableCSSClass], [fldStyle], [fldTokenEncrypt], [fldScript], [fldShowSQLError], [fldUserReorder], [fldTrStyle], [fldSelectRow], [fldMulitpleSelect], [fldKeyField], [fldPrintHeadTitle], [fldPrintFootTitle], [fldSettingHidden], [fldProgram], [fldPrintUseHeader], [fldEndLinePage], [fldEndLine], [fldExportEnable], [fldRightClick], [fldExportDefault]) 
VALUES 
( @QueryAndReportName, N'گزارش اتومات' +@ReportName, N'', @QueryAndReportName, N'گزارش ساز', NULL, NULL, 1, NULL, 0, N'', N'', N'simple', 1, N'', N'', NULL, NULL, NULL, 1, NULL, 1, 0, N'', N'', N'', 1, NULL, NULL, NULL, NULL, 1, NULL, NULL)

select @tblReportID=fldId From [tblReport]
where [fldName]=@QueryAndReportName

--**********Set Dependencies**************
SELECT @btnRefreshReportID=[fldID]
FROM [KosarWebDBBank].[dbo].[tblFormFilds]
where fldFormID=@fldFormId and fldFildName= 'rpt_btnBuildQuery'

SELECT @fldReportID=[fldID]
FROM [dbo].[tblFormFilds]
where fldFormID=@fldFormId and fldFildName='DynamicReport'
INSERT INTO [dbo].[tblFildDependence]
           (
		   [fldFildID]
           ,[fldFildDepName]
           ,[fldQuery]
           ,[fldReportReSelect]
           ,[fldProgram]
           ,[fldFildDepID])
		   values(@fldReportID,'rpt_btnBuildQuery','simple',null,null, @btnRefreshReportID)
END

--*****************افزودن فیلد های گزارش *************


 delete FROM [tblReportFilde]
  where [fldReportID]=@tblReportID 
INSERT INTO [dbo].[tblReportFilde]
           (
		[fldReportID]
      ,[fldTitle]
      ,[fldName]
      ,[fldOrder]
      --,[fldLink]
      ,[fldLinkShow]
      ,[fldButton]
      ,[fldButtonFunction]
      ,[fldStyle]
      ,[fldShowType]
      ,[fldSplit]
     -- ,[fldCalcExperssion]
      ,[fldSum]
      --,[fldEncrypt]
      --,[fldEncKey]
      --,[fldTdStyle]
      --,[fldWidth]
      --,[fldNoWrap]
      --,[fldPrint]
      --,[fldForeColor]
      --,[fldBackColor]
      --,[fldFont]
      --,[fldFontSize]
      --,[fldEditable]
      --,[fldIsReport]
      --,[fldProgram]
      ,[fldDiv])
SELECT @tblReportID ,N'ردیف' ,'rowNumber',1,'',0,'','',2,0,0,0 union all
SELECT TOP (1000) @tblReportID,
CASE
	WHEN IsGrouped<1 and AggreegateFunc!=''  THEN   ISNULL(D.fldValue,[FieldName])+'_'+ AggreegateFunc
    WHEN IsGrouped<1 and AggreegateFunc=''  THEN   ISNULL(D.fldValue,[FieldName])+'_COUNT'  
    ELSE   ISNULL(D.fldValue,[FieldName])
END 
,CASE
	WHEN IsGrouped<1 and AggreegateFunc!=''  THEN  [FieldName]+'_'+ AggreegateFunc
    WHEN IsGrouped<1 and AggreegateFunc=''  THEN  [FieldName]+'_COUNT'  
    ELSE   [FieldName]
END 
,1,'',0,'','',2,0,0,0
  FROM [rpt].[tblSetting] s
    outer apply(SELECT Top 1 [fldValue]   FROM [dbo].[tblDictionary] D 
  where D.fldKey=s.[FieldName]
	) d
  where fldGroupName=@GroupName and fldReportName=@ReportName and fldUserId=@userId 