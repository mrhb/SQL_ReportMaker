TRUNCATE TABLE [rpt].[tblGroups]
TRUNCATE TABLE [rpt].[tblSetting]
TRUNCATE TABLE [rpt].[tblSettingTemp]
TRUNCATE TABLE [rpt].[tblFilds]
TRUNCATE TABLE [rpt].[tblFilter]
INSERT [rpt].[tblGroups] ([fldGroupName], [fldFieldName], [fldType], [fldIsGroupable], [fldFuncDef], [fldIsGroupedDef], [fldIncludedDef]) VALUES 
 (N'rpt.VSanadHesabVam', N'fldDate', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldHesabType', N'NUMBER', 0, N'MAX', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldHesabID', N'NUMBER', 0, N'MAX', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldBed', N'NUMBER', 0, N'MAX', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldBes', N'NUMBER', 0, N'MAX', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldSanadID', N'NUMBER', 0, N'MAX', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldDescription', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldOperationType', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VSanadHesabVam', N'fldNaghdPrice', N'NUMBER', 0, N'', 0, 1)

,(N'rpt.VsanadCustomer', N'fldDate', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldTime', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldHesabType', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldHesabID', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldBed', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldBes', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldSanadID', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldDescription', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldOperationType', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldNaghdPrice', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldReference', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldStatus', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldOperator', N'NUMBER', 0, N'', 0, 1)
,(N'rpt.VsanadCustomer', N'fldLastUpdateDate', N'NUMBER', 0, N'', 0, 1)
GO
INSERT [rpt].[tblSetting] ([fldUserId], [fldGroupName], [fldReportName], [FieldName], [AggreegateFunc], [IsGrouped]) VALUES
 (N'hajjar', N'rpt.VSanadHesabVam', N'report2', N'fldHesabID', N'MAX', 1)
,(N'hajjar', N'rpt.VSanadHesabVam', N'report2', N'fldBed', N'COUNT', 0)
,(N'hajjar', N'rpt.VSanadHesabVam', N'report2', N'fldBes', N'AVG', 0)

,(N'hajjar', N'rpt.VsanadCustomer', N'sanadReport', N'fldHesabType', N'MIN', 0)
,(N'hajjar', N'rpt.VsanadCustomer', N'sanadReport', N'fldBed', N'MIN', 0)
,(N'hajjar', N'rpt.VsanadCustomer', N'sanadReport', N'fldBes', N'MIN', 1)

,(N'hajjar', N'rpt.VSanadHesabVam', N'report1', N'fldDate', N'', 0)
,(N'hajjar', N'rpt.VSanadHesabVam', N'report1', N'fldHesabID', N'MIN', 0)
,(N'hajjar', N'rpt.VSanadHesabVam', N'report1', N'fldBes', N'AVG', 0)
,(N'hajjar', N'rpt.VSanadHesabVam', N'report1', N'fldSanadID', N'MAX', 1)
GO
--INSERT [rpt].[tblSettingTemp] ([Included], [fldUserId], [FieldName], [AggreegateFunc], [IsGrouped]) VALUES 
-- (0, N'hajjar', N'fldDate', N'', 0)
--,(0, N'hajjar', N'fldTime', N'', 0)
--,(1, N'hajjar', N'fldHesabType', N'MIN', 0)
--,(0, N'hajjar', N'fldHesabID', N'', 0)
--,(1, N'hajjar', N'fldBed', N'MIN', 0)
--,(1, N'hajjar', N'fldBes', N'MIN', 1)
--,(0, N'hajjar', N'fldSanadID', N'', 0)
--,(0, N'hajjar', N'fldDescription', N'', 0)
--,(0, N'hajjar', N'fldOperationType', N'', 0)
--,(0, N'hajjar', N'fldNaghdPrice', N'', 0)
--,(0, N'hajjar', N'fldReference', N'', 0)
--,(0, N'hajjar', N'fldStatus', N'', 0)
--,(0, N'hajjar', N'fldOperator', N'', 0)
--,(0, N'hajjar', N'fldLastUpdateDate', N'', 0)
--GO
INSERT INTO [rpt].[tblFilter]([fldUserId],[fldReportName],[fldFieldName],[fldOperator],[fldOprand])VALUES
 (N'hajjar', N'report2', N'fldHesabID', N'x<a', '')
,(N'hajjar', N'report2', N'fldBed', N'x>a', '')
,(N'hajjar', N'report2', N'fldBes', N'x>a', '') 
,(N'hajjar', N'report2', N'fldBes', N'x<a', '') 

,(N'hajjar', N'sanadReport', N'fldHesabType', N'x<a','')
,(N'hajjar', N'sanadReport', N'fldBed', N'x<a', '')
,(N'hajjar', N'sanadReport', N'fldBes', N'x>a', '')

,(N'hajjar', N'report1', N'fldDate', N'x>a', '')
,(N'hajjar', N'report1', N'fldHesabID', N'x>a', '')
,(N'hajjar', N'report1', N'fldBes', N'x>a', '')
,(N'hajjar', N'report1', N'fldSanadID', N'x>a', 1)
GO

INSERT [rpt].[tblFilds] ( [fldName], [fldFildName], [fldFieldType], [fldOperator], [fldOrder], [fldStyle], [fldFildLabelTdStyle], [fldFildDivStyle], [fldFildTdStyle], [flDModal], [fldTypeCode], [fldDisable], [fldVisible], [fldRegularExp], [fldAutoCompelete], [fldDefault], [fldTypeName], [fldNewLine], [fldSize], [fldSubmitName], [fldSubmitQuery], [fldSubmitRedirect], [fldLabelText], [fldListQuery], [fldListTitle], [fldframeURL], [fldframeHeight], [fldIsComputedFilde], [fldComputedQuery], [fldComputedDependenceFilde], [fldLabel], [fldFrameWith], [fldButtonOnClick], [fldTextAreaRows], [fldTextAreaColumns], [fldSubmitConfirm], [fldSubmitConfirmMessage], [fldIsPassWord], [fldEncrypt], [fldencryptionKey], [fldSplit], [fldDate], [fldFixDate], [fldWaitOnSubmit], [fldDisableAfterDone], [fldDate10], [fldFileAccept], [fldFileMaxSize], [fldRequired], [fldSubmitPreControl], [fldFileMultiple], [fldDirectScan], [fldEnClient], [fldReportName], [fldAutoSplitChar], [fldPlaceHolder], [fldProgram], [fldLazyReport], [fldAccess], [fldLog], [fldSubmitLog], [fldSync], [fldSubmitSuccessfullMessage], [fldGroupName])VALUES 
 (N'از:', N'NumberGreater', N'NUMBER', N'x>a', 1, N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ', N'width: 15%; height: 9.41375%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; align-items: center; left: 89.5132%; top: 4.06486%;', N'width: 100px; height: 6.56835%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center; left: 70.289%; top: 4.51313%;', N'', N'', N'TEXT', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 1, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', NULL, 0, 0, 0, N'', 0, N'', N'')
,(N'مساوی یا بیشتر از :', N'NumberGreaterOrEqual', N'NUMBER', N'x>=a', 1, N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ', N'width: 15%; height: 9.41375%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; align-items: center; left: 89.5132%; top: 4.06486%;', N'width: 100px; height: 6.56835%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center; left: 70.289%; top: 4.51313%;', N'', N'', N'TEXT', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 1, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', NULL, 0, 0, 0, N'', 0, N'', N'')
,(N'تا:', N'NumberLess', N'NUMBER', N'x<a', 1, N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ', N'width: 15%; height: 9.41375%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center;  left: 89.5132%; top: 4.06486%;', N'width: 100px;height: 6.56835%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center;  left: 70.289%; top: 4.51313%;', N'', N'', N'TEXT', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 1, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', NULL, 0, 0, 0, N'', 0, N'', N'')
,(N'مساوی یا کمتر از:', N'NumberLessOrEqual', N'NUMBER', N'x<=a', 1, N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ', N'width: 15%; height: 9.41375%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center;  left: 89.5132%; top: 4.06486%;', N'width: 100px;height: 6.56835%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center;  left: 70.289%; top: 4.51313%;', N'', N'', N'TEXT', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 1, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', NULL, 0, 0, 0, N'', 0, N'', N'')
,(N'از تاریخ:', N'fldDATE', N'STRING', N'x<a', 1, N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ', N'width:15%; height: 9.41375%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center; left: 89.5132%; top: 4.06486%;', N'width: 100px ; height: 6.56835%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center; left: 70.289%; top: 4.51313%;', N'', N'', N'TEXT', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 1, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', NULL, 0, 0, 0, N'', 0, N'', N'')
,(N'اجرای گزارش', N'rpt_btnBuildQuery', N'DEFAULT', N'', 999, N'z-index: 10; height: 100%; width: 40%; font-size: 1.5vw; ', N'width:15%; height: 9.41375%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center; left: 89.5132%; top: 4.06486%;', N'width: 100%;  z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center;left: 10%; top: 10%;', N'', N'', N'SUBMITN', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'اجرای گزارش', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 1, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', NULL, 0, 0, 0, N'', 0, N'', N'')
--,(N'کوئری ساخته شده', N'rpt_fldQueryString', N'DEFAULT', N'', 1000, N'z-index: 10;  width: 100%;height: 150px; font-size: 1.5vw;  ', N'width:15%; height: 9.41375%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center; left: 89.5132%; top: 4.06486%;', N'width: 100%;  z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl;  align-items: center;left: 10%; top: 10%;', N'', N'', N'TEXTAREA', 0, 1, NULL, N'', N'', NULL, 1, NULL, N'', N'', N'', N'', N'', N'', N'', NULL, NULL, NULL, NULL, 1, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', NULL, 0, 0, 0, N'', 0, N'', N'')
,(N'نام گزارش', N'htxtReportName', N'DEFAULT', N'', 997, N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ', N'width: 15%; height: 10.4084%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center; position: absolute; left: 59.82%; top: 2.03232%;', N'width: 22.3691%; height: 6.89508%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center; position: absolute; left: 40.5586%; top: 3.36114%;', N'', N'', N'HIDDEN', 0, 1, NULL, N'', N'#PQ:ReportName|#UP:ReportName##', NULL, 0, NULL, N'', N'', N'', N'', N'reportNames', N'نام گزارش', N'', NULL, NULL, NULL, NULL, 0, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', N'BankdariWeb', 0, 0, 0, N'', 0, N'', N'')
,(N'گروه گزارش', N'htxtGroupName', N'DEFAULT', N'', 998, N'z-index: 10; height: 100%; width: 100%; font-size: 1.5vw; ', N'width: 15%; height: 10.4084%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center; position: absolute; left: 91.0448%; top: 2.56714%;', N'width: 22.3691%; height: 6.89508%; z-index: 10; font-size: 1.5vw; text-align: right; direction: rtl; display: grid; align-items: center; position: absolute; left: 71.3249%; top: 3.36114%;', N'', N'', N'HIDDEN', 0, 1, NULL, N'', N'#PQ:GroupName|#UP:GroupName##', NULL, 0, NULL, N'', N'', N'', N'', N'reportGroups', N'گروه گزارش', N'', NULL, NULL, NULL, NULL, 0, NULL, N'', 0, 0, 0, N'', 0, 0, N'', 0, 0, 0, 0, 0, 0, N'', 0, NULL, NULL, 0, 0, NULL, N'', N'', N'', N'BankdariWeb', 0, 0, 0, N'', 0, N'', N'')

GO

