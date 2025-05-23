
/*List of DMVs related to SQLOS*/
select * from sys.dm_os_sys_info
select * from sys.dm_os_schedulers
select * from sys.dm_os_waiting_tasks
select * from sys.dm_os_wait_stats
select * from sys.dm_os_threads
select * from sys.dm_os_performance_counters
select * from sys.dm_os_ring_buffers

/*Other useful DMVs cotaining SQL Server information*/
select * from sys.dm_os_windows_info
select * from sys.dm_server_registry
select * from sys.dm_os_sys_info
select * from sys.dm_server_services
select * from sys.dm_server_memory_dumps

--John's demo for Processor Counts
SELECT cpu_count, hyperthread_ratio, max_workers_count, 
	scheduler_count, scheduler_total_count, os_quantum,
	affinity_type, affinity_type_desc,
	softnuma_configuration, softnuma_configuration_desc,
	socket_count, cores_per_socket, numa_node_count
FROM sys.dm_os_sys_info

--Logical Processor Counts
EXEC sys.xp_readerrorlog 0, 1, N'detected', N'socket';

--List all DMVs and DMFs.
SELECT name, type FROM sys.system_objects
WHERE name LIKE 'dm_%'
order by name

--Database Scoped
SELECT name, type, type_desc 
FROM sys.system_objects 
WHERE name LIKE N'dm%[_]db[_]%' 
ORDER BY name;

--Finding Total Memory
SELECT total_physical_memory_kb / 1024 AS MemoryMb 
FROM sys.dm_os_sys_memory

--SQL Configurations
SELECT name, value_in_use 
FROM sys.configurations 
WHERE name LIKE 'max server memory%'

-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-memory-clerks-transact-sql?view=sql-server-ver16

--Checking Memory Objects
SELECT [type] AS [ClerkType],
SUM(pages_kb) / 1024 AS [SizeMb]
FROM sys.dm_os_memory_clerks WITH (NOLOCK)
WHERE [type] LIKE 'Cachestore_OBJCP' OR
	[type] LIKE 'Cachestore_SQLCP'
GROUP BY [type]
ORDER BY SUM(pages_kb) DESC
  
/* This Sample Code is provided for the purpose of illustration only and is not intended 
to be used in a production environment.  THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE 
PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR 
PURPOSE.  We grant You a nonexclusive, royalty-free right to use and modify the Sample Code
and to reproduce and distribute the object code form of the Sample Code, provided that You 
agree: (i) to not use Our name, logo, or trademarks to market Your software product in which
the Sample Code is embedded; (ii) to include a valid copyright notice on Your software product
in which the Sample Code is embedded; and (iii) to indemnify, hold harmless, and defend Us and
Our suppliers from and against any claims or lawsuits, including attorneys’ fees, that arise or 
result from the use or distribution of the Sample Code.
*/