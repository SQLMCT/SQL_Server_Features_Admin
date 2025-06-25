--Hey John! Make sure you are on SQLN1

--Backup Encryption Demo
USE master
GO
--The first step is to create a Database Master Key. 
--This can only be performed once.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SQL$ecurity3SQL$ecurity3';
GO

--Check to see if key is encrypted by Server
SELECT name,  is_master_key_encrypted_by_server 
FROM sys.databases
GO
SELECT * FROM sys.symmetric_keys
GO

--Backup Encryption Demo
USE AdventureWorks2022
GO
--The first step is to create a Database Master Key. 
--This can only be performed once.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SQL$ecurity3SQL$ecurity3';
GO

--Check to see if key is encrypted by Server
SELECT name,  is_master_key_encrypted_by_server 
FROM sys.databases
GO
SELECT * FROM sys.symmetric_keys
GO

--Create Certificate for backup
USE MASTER
GO
CREATE CERTIFICATE BackupCert 
WITH SUBJECT = 'Certificate for Backup Encryption'
GO

--Verify and write down thumbprint
SELECT name, thumbprint FROM sys.certificates
GO

--0xACFBBF42EC2B625EFF4DF50021A034C2AF399929
--0xACFBBF42EC2B625EFF4DF50021A034C2AF399929

--Backup Certificate for later
BACKUP CERTIFICATE BackupCert TO FILE = N'C:\Demos\BackupCertifiate.cer'
WITH PRIVATE KEY (FILE = N'C:\Demos\BackupCertificate.pvk',
ENCRYPTION BY PASSWORD = N'J3nnY8675309JeNNi');

--Backup Database (Unsecure and Secure)
BACKUP DATABASE AdventureWorks2022 
TO DISK = N'C:\Demos\ADWorkUnsecure.bak' WITH FORMAT

BACKUP DATABASE AdventureWorks2022 
TO DISK = N'C:\Demos\ADWorkSecure.bak' 
WITH FORMAT, ENCRYPTION(ALGORITHM = AES_256, SERVER CERTIFICATE = BackupCert)
GO

--Check the header of each backup
RESTORE HEADERONLY FROM DISK = N'C:\Demos\ADWorkUnsecure.bak'
RESTORE HEADERONLY FROM DISK = N'C:\Demos\ADWorkSecure.bak'
GO

RESTORE FILELISTONLY FROM DISK = N'C:\Demos\ADWorkUnsecure.bak'
RESTORE FILELISTONLY FROM DISK = N'C:\Demos\ADWorkSecure.bak'
GO

--Look at the thumbprint again
SELECT name, thumbprint FROM sys.certificates
GO






