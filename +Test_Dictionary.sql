declare  @userId [nvarchar](150) ,@ReportName [nvarchar](50) ,@GroupName [nvarchar](50)
select @userId='hajjar'
select @GroupName='rpt.VSanadHesabVam',@ReportName='report1'


IF(1 = 1)
BEGIN  
delete from rpt.tblSettingTemp
	where [fldUserId]=@userId
Insert into rpt.tblSettingTemp   
  SELECT 
    CASE WHEN m.FieldName IS NULL THEN 0 ELSE 1 END,
    @userId,
    g.[fldFieldName],
    ISNULL(m.[AggreegateFunc],g.fldFuncDef),
	ISNULL(m.[IsGrouped],g.fldIsGroupedDef),
	ff.fldOperator
 --  m.[fldGroupName]
FROM  [rpt].[tblGroups] g
    OUTER APPLY
    (
        SELECT  *
        FROM [rpt].[tblSetting] s
        WHERE g.[fldGroupName]=s.[fldGroupName] and s.FieldName=g.fldFieldName and s.[fldReportName]=@ReportName	 and [fldUserId]=@userId 
    ) m

	OUTER APPLY
    (
        SELECT  *
        FROM [rpt].[tblFilter] f
        WHERE m.fldReportName=f.fldReportName and m.FieldName=f.fldFieldName and f.[fldUserId]=@userId 
    ) ff
	where  g.[fldGroupName]=@GroupName 	
    

END

  select TOP (1000) 
  ROW_NUMBER() OVER(ORDER BY [Included] DESC,FieldName DESC) rowNum ,
   [Included] fldIncluded,
   [FieldName] fldFieldName,
   ISNULL(D.fldValue,[FieldName])  as fa_fldFieldName,
   [AggreegateFunc] fldFunc,
   [IsGrouped] fldIsGrouped,
   [fldFilterOperator] fldFilterOperator

   from rpt.tblSettingTemp T
    outer apply(SELECT Top 1 [fldValue]   FROM [dbo].[tblDictionary] D 
  where D.fldKey=T.FieldName
	) d
   WHERE [fldUserId]=@userId
    order by  [Included] DESC,[FieldName] DESC 