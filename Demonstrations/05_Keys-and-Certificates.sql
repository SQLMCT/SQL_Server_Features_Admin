CREATE DATABASE CellEncryption
GO

USE CellEncryption
GO
/*
--========================================================================--
Encrypting data using Symmetric Key encrypted by Asymmetric Key
The purpose of creating the Asymmetric key is to encrypt our Symmetric Key
--========================================================================--
*/

USE MASTER
-- Creates a database master key encrypted by password $Str0nGPa$$w0rd
CREATE MASTER KEY ENCRYPTION BY PASSWORD  = '$tr0nGPa$$w0rd12E' 
GO
-- Creates an asymmetric key encrypted by password '$e1ectPa$$w0rd'
CREATE ASYMMETRIC KEY MyAsymmetricKey 
    WITH ALGORITHM = RSA_2048
    ENCRYPTION BY PASSWORD  = '$e1ectPa$$w0rd12e'
GO

--Execute the query below, to view the information about asymmetric key
SELECT * FROM [sys].[asymmetric_keys] 
GO

-- Creates an symmetric key encrypted by asymmetric key
CREATE SYMMETRIC KEY MySymmetricKey
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY ASYMMETRIC KEY MyAsymmetricKey
GO

--Execute the query below, to view the information about symmetric key
SELECT * FROM [sys].[symmetric_keys] 
GO

/*
Create a table called TestEncryption. This table has three columns Name, CreditCardNumber and EncryptedCreditCardNumnber. 
The EncryptedCreatedCardNumber stores the encrypted credit card number stored in CreditCardNumber column. 
Also insert some dummy data:
*/
CREATE TABLE TestEncryption
([Name]                            [varchar] (256)
,[CreditCardNumber]                [varchar](16)
,[EncryptedCreditCardNumber]       [varbinary](max))
GO

INSERT INTO TestEncryption ([Name], [CreditCardNumber])
SELECT 'Simon Jones', '9876123456782378'
UNION ALL
SELECT 'Kim Brian', '1234567898765432'
GO

SELECT * FROM TestEncryption


-- Opening the symmetric key
OPEN SYMMETRIC KEY MySymmetricKey
DECRYPTION BY ASYMMETRIC KEY MyAsymmetricKey 
WITH PASSWORD  = '$e1ectPa$$w0rd12e'
GO

--Execute the following query returns the list of opened key
SELECT * FROM [sys].[openkeys]
GO

/*
Now execute the following script update the TestEncryption table to insert the values in 
EncryptedCreditCardNumbers column from CreditCardNumbers column
*/

--As you can see we are using ENCRYPTBYKEY function to encrypt the column values
UPDATE TestEncryption
SET [EncryptedCreditCardNumber] = ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), CreditCardNumber)
GO

--Once successfully executed, Verify the value inside EncryptedCreditCardNumber column by running the following query
SELECT * FROM [TestEncryption]
GO

--Executing the following query to retrieve the data inside EncryptedCreditCardNumber column using DECRYPTBYKEY encryption function
SELECT CONVERT([varchar](16), DECRYPTBYKEY([EncryptedCreditCardNumber]))
 FROM [TestEncryption]
GO


