
ALTER DATABASE ADWorks2
SET READ_COMMITTED_SNAPSHOT OFF;


SELECT is_read_committed_snapshot_on FROM sys.databases 
WHERE name= 'AdWorks2'