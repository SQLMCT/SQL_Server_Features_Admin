USE master;
GO

--If Event Session Exists Drop
DROP EVENT SESSION [CheckResourceUsage] ON SERVER;
GO

-- Replace the value of SPID on line 14 and 18 with the session ID from the
-- 02. Generate Load for XE Profiler.sql tab.

CREATE EVENT SESSION [CheckResourceUsage] ON SERVER 
ADD EVENT sqlserver.sp_statement_completed(
    ACTION(sqlserver.query_hash)
    WHERE ([package0].[equal_uint64]([sqlserver].[session_id],(SPID)) 
		AND [sqlserver].[query_hash]<>(0))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.query_hash)
    WHERE ([package0].[equal_uint64]([sqlserver].[session_id],(SPID)) 
		AND [sqlserver].[query_hash]<>(0)))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO



ALTER EVENT SESSION [CheckResourceUsage] ON SERVER  
STATE = start;  
GO  
