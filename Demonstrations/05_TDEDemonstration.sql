--Hey John! Make sure you are on JDSQL19
USE MASTER
GO
--The first step is to create a Database Master Key. 
--This can only be performed once.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SQL$ecurity3SQL$ecurity3';
GO

--TDE Demo
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


USE MASTER
GO
CREATE CERTIFICATE TDECert WITH SUBJECT = 'Certificate for TDE DB'
GO
SELECT name, thumbprint FROM master.sys.certificates
GO

--0xB1B638CF0A61D5785403742E1525E1604B0AA264

--Create the Database Encyrption Key
USE AdventureWorks2022
GO
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDECert
GO

SELECT DB_NAME(database_id) AS DBName,
	CASE encryption_state	
		WHEN 0 THEN 'No database encryption key present'
		WHEN 1 THEN 'Unencrypted'
		WHEN 2 THEN 'Encryption in Progress'
		WHEN 3 THEN 'Encrypted'
		WHEN 4 THEN 'Key Change in Progress'
		WHEN 5 THEN 'Decryption in Progress'
		WHEN 6 THEN 'Changing DEK certificate'
	END AS encyrption_state_desc,
	percent_complete, *
FROM sys.dm_database_encryption_keys
WHERE database_id > 4 --Hey, John! Why are you doing this?

/*
Notice that the Key has been created, 
but the database has not been encrypted.
The encryption process will be asynchronous,
and will not block other users. */
ALTER DATABASE AdventureWorks2022 SET ENCRYPTION ON
GO
--Run Query to try to see Encryption in Progress
SELECT DB_NAME(database_id) AS DBName,
	CASE encryption_state	
		WHEN 0 THEN 'No database encryption key present'
		WHEN 1 THEN 'Unencrypted'
		WHEN 2 THEN 'Encryption in Progress'
		WHEN 3 THEN 'Encrypted'
		WHEN 4 THEN 'Key Change in Progress'
		WHEN 5 THEN 'Decryption in Progress'
		WHEN 6 THEN 'Changing DEK certificate'
	END AS encyrption_state_desc,
	percent_complete, *
FROM sys.dm_database_encryption_keys



--Detach AdventureWorks2022 from JDSQL19
USE MASTER
GO
EXEC master.dbo.sp_detach_db @dbname = N'AdventureWorks2022'
GO
--Connect to JDSQL22 and try to attach database
--Switch over to the TDEServer02Attach.sql file

-- To clean up demonstration
-- Turn off TDE (Make sure you are back on JDSQL19)
USE master;
GO
ALTER DATABASE AdventureWorks2022 SET ENCRYPTION OFF;
GO
-- Wait a minute for Encryption to turn off
-- Remove Encryption Key from Database 

USE AdventureWorks2022;
GO
DROP DATABASE ENCRYPTION KEY;
GO

/*Cleanup
USE MASTER
GO
DROP Certificate backupcert
DROP Certificate TDECert
DROP Database ADWorks2
*/
--Make sure to clean up D:\Backups folder