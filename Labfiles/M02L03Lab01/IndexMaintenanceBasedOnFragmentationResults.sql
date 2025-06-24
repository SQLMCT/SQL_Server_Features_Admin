USE [AdventureWorks2022]
GO
--------------------------------------Index Maintenance -------------------------------------------------------------------
 ---- Pick the  Indexstatement from last Select statement and execute it
Use AdventureWorks2022;
ALTER INDEX AK_NewPerson_rowguid ON dbo.Newperson REBUILD;
Use AdventureWorks2022;
ALTER INDEX IX_NewPerson_LastName_FirstName_MiddleName ON dbo.Newperson REBUILD;
Use AdventureWorks2022;
ALTER INDEX IX_NewPerson_PersonType ON dbo.Newperson REORGANIZE;