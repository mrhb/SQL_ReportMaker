DECLARE  @setting rpt.SettingType
		,@filters rpt.FilterType
		,@query nvarchar(max)

INSERT INTO @setting (FieldName, AggreegateFunc,IsGrouped)
  VALUES
  ('fldName', 'Avg', 'TRUE'), 
  ('fldVamType', 'Count', 'TRUE'), 
  ('fldVamGroup','Min','False');
INSERT INTO @filters ([fldID],[fldFieldName],[fldFieldType],[fldOperator],[fldOprand])
  VALUES
   (1, 'fldName1', 'STRING','in'  ,'#fldName1#')
  ,(2, 'fldqwme2', 'STRING','like','fte5cdesrt')
  ,(4, 'fldName2', 'NUMBER','x>=a','fte56')
  ,(3, 'fldqwme2', 'NUMBER','b<x<=a','fte56#srt');

EXEC	 [rpt].[ReportGenerator]
		@Setting = @setting,
		@Filters = @filters,
		@ReportName = 'rpt.vsanadVam',
		@index =1,
		@pageSize =50,
		@Query = @query OUTPUT
SELECT	@query as N'Result Query'

