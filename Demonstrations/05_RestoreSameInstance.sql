
--Restore File on Same instance. (Server JDSQL19)
--NOTE: No mention of encryption or decryption during restore
RESTORE DATABASE ADWorks2 FROM DISK = N'C:\Demos\ADWorkSecure.bak'
WITH MOVE 'AdventureWorks2022' TO 'C:\Demos\ADwork2.mdf',
     MOVE 'AdventureWorks2022_Log' TO 'E:\DATA2\ADwork2_log.ldf'

--Restore File on Different instance. (Server JDSQL22)
--NOTE: Switch connection to JDSQL22
RESTORE DATABASE ADWorks2 FROM DISK = N'E:\Demos\ADWorkSecure.bak'
WITH MOVE 'AdventureWorks2022' TO 'E:\Demos\ADwork2.mdf',
     MOVE 'AdventureWorks2022_Log' TO 'E:\Demos\ADwork2_log.ldf'

--Verify certificate does not exist on JDSQL22
SELECT name, thumbprint FROM sys.certificates
GO

--Make sure connection is on JDSQL22 and Restore Certificate
--The first step is to create a Master Key. Can only perform once.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SQLProtection#1';
GO
SELECT is_master_key_encrypted_by_server FROM sys.databases
GO
SELECT * FROM sys.symmetric_keys
GO

CREATE CERTIFICATE BackupCert FROM FILE = N'C:\Demos\BackupCertifiate.cer'
WITH PRIVATE KEY (FILE = N'C:\Demos\BackupCertificate.pvk',
DECRYPTION BY PASSWORD = N'J3nnY8675309JeNNi');

--Verify certificate DOES exist on JDSQL22
SELECT name, thumbprint FROM sys.certificates
GO

--Restore File on Different instance. (Server JDSQL02)
--NOTE: Connection should still be on JDSQL02
RESTORE DATABASE ADWorks2 FROM DISK = N'E:\Demos\ADWorkSecure.bak'
WITH MOVE 'AdventureWorks2022' TO 'E:\Demos\ADwork2.mdf',
     MOVE 'AdventureWorks2022_Log' TO 'E:\Demos\ADwork2_log.ldf'



