declare @filters rpt.FilterType;
INSERT INTO @filters ([fldFieldName],[fldFieldType],[fldOperator],[fldOprand])
  VALUES
   ( 'Name1', 'NUMBER','in'  ,'vdfhbte')
  ,( 'Name2', 'NUMBER','x<a','frye')

    -- Insert statements for procedure here
	SELECT
	 rpt.Number_criteriaBuilder(fldFieldName,fldOperator,fldOprand)
	    From  @filters 
