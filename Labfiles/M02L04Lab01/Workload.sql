USE AdventureWorks2022
GO
--create objects
 
DROP PROCEDURE IF EXISTS getRowsByProductID
GO
 
CREATE PROCEDURE getRowsByProductID
@ProductID INT
AS
SELECT SOD.*, P.*
 FROM Sales.SalesOrderDetail AS SOD
 JOIN Production.Product AS P
   ON P.ProductID = SOD.ProductID
WHERE SOD.ProductID = @ProductID;
 
GO
 
-- clear the cache:
DBCC FREEPROCCACHE;
 
--get skinny plan
EXECUTE getRowsByProductID 897;
 
-- clear the cache:
DBCC FREEPROCCACHE;
 
-- introduce paramter sniffing with wide plan
EXECUTE getRowsByProductID 870;
 
DECLARE @counter int;
SET @counter = 0;

--run the workload
--the sproc will run with each parameter twice and alternate compiling with 870 and 897
--each param wil run an equal number of exeuctions with each iteration of the query plan
WHILE(SELECT 1) = 1
BEGIN
 
--run the sproc with each param as a base
EXECUTE getRowsByProductID 897;
EXECUTE getRowsByProductID 870;

DBCC FREEPROCCACHE

IF @counter%2=0
	BEGIN 
		--compile with 879
		EXECUTE getRowsByProductID 897;
		--run with 870 to keep the executions equal
		EXECUTE getRowsByProductID 870;
	END
ELSE
	BEGIN
		--compile with 870
		EXECUTE getRowsByProductID 870;
		--run with 897 to keep the executions equal
		EXECUTE getRowsByProductID 897;
	END

SET @counter = @counter + 1;

END; 