--Connect to SQLN2 and try to attach files.
CREATE DATABASE AdventureWorks2022 ON
(FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.JDSQL2022\MSSQL\DATA\AdventureWorks2022.mdf'),
(FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.JDSQL2022\MSSQL\DATA\AdventureWorks2022_Log.ldf')
FOR ATTACH
GO

--Switch back to SQLN1 and rerun code to attach AdventureWorks2022.

--Now Backup Database on SQLN1 and try to restore on SQLN2
--Notice we are not using WITH ENCRYPTION on the Backup.

BACKUP DATABASE AdventureWorks2022 TO DISK = N'D:\DATA\ADWorksTDE.bak' WITH FORMAT
GO

RESTORE FILELISTONLY FROM DISK = N'D:\DATA\ADWorksTDE.bak'
GO

--Try to restore on SQLN2
RESTORE DATABASE ADWorksTDE FROM DISK = N'D:\DATA\ADWorksTDE.bak'
WITH MOVE 'AdventureWorks2017' TO 'D:\DATA2\ADwork2.mdf',
     MOVE 'AdventureWorks2017_Log' TO 'D:\DATA2\ADwork2_log.ldf'

--To attach or restore on SQLN2 we would need
--to backup the certificate on SQLN1 and restore on SQLN2.