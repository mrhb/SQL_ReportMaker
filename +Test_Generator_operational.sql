declare  @userId [nvarchar](150) , @fldName  [nvarchar](50) ,@GroupName [nvarchar](50),@ReportName [nvarchar](50),@fldFormId bigint
select @userId='hajjar'
select @GroupName='rpt.VSanadHesabVam',@ReportName='report2'
select @fldName='rptcnfg_'+@GroupName+'_'+ @ReportName

DECLARE  @setting rpt.SettingType
		,@filters rpt.FilterType
		,@query nvarchar(max)

INSERT INTO @setting (FieldName, AggreegateFunc,IsGrouped)
select FieldName,AggreegateFunc ,IsGrouped
from rpt.tblSetting
where fldGroupName=@GroupName and fldReportName=@ReportName and fldUserId=@userId


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

  select * from @filters
--where fldGroupName=@GroupName and fldReportName=@ReportName and fldUserId=@userId
--  select * from rpt.tblFilter
--where  fldReportName=@ReportName and fldUserId=@userId
EXEC	 [rpt].[ReportGenerator]
		@Setting = @setting,
		@Filters = @filters,
		@ReportName = @GroupName,
		@index =1,
		@pageSize =50,
		@Query = @query OUTPUT
SELECT	@query as rpt_fldQueryString


