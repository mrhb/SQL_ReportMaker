declare @indx  int,@Operator  [nvarchar](10),@Criteria    [nvarchar](max),	@Oprand    [nvarchar](max)
,@Oprand_a    [nvarchar](max),@Oprand_b    [nvarchar](max);
select @Operator='a<=x<=b',@Oprand='dfthdfztrhgzbfg#kjhfuyf' ,@Criteria=''
select @indx=CHARINDEX('#',@Oprand)

select @Oprand_a=LEFT(@Oprand,@indx - 1) , @Oprand_b=Right(@Oprand,LEN(@Oprand)-@indx) 
select @Oprand_a, @Oprand_b

select @Criteria = REPLACE(@Operator, 'x', '[fldId]');
select @Criteria

select  @Criteria =  SUBSTRING(@Criteria, 1,Len(@Criteria)-1) + @Oprand_a;
select @Criteria

select  @Oprand_b + SUBSTRING(@Criteria, 2,Len(@Criteria)) ;

--SELECT REPLACE('SQL TutTorial' COLLATE sql_latin1_general_cp1_cs_as , 'T', 'M');
