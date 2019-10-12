-- Create a database
USE master;
IF EXISTS (SELECT * FROM sys.sysdatabases WHERE name = 'DemoDW')
	DROP DATABASE DemoDW;
GO
CREATE DATABASE DemoDW;
GO
ALTER DATABASE DemoDW SET RECOVERY SIMPLE 
GO

-- Create filegroups
Use DemoDW;
ALTER DATABASE DemoDW ADD FILEGROUP FG0000
GO
ALTER DATABASE DemoDW ADD FILE (NAME = F0000, FILENAME = 'D:\Demofiles\Mod03\F0000.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG0000;
GO
ALTER DATABASE DemoDW ADD FILEGROUP FG2000
GO
ALTER DATABASE DemoDW ADD FILE (NAME = F2000, FILENAME = 'D:\Demofiles\Mod03\F2000.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2000;
GO
ALTER DATABASE DemoDW ADD FILEGROUP FG2001
GO
ALTER DATABASE DemoDW ADD FILE (NAME = F2001, FILENAME = 'D:\Demofiles\Mod03\F2001.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2001;
GO
ALTER DATABASE DemoDW ADD FILEGROUP FG2002
GO
ALTER DATABASE DemoDW ADD FILE (NAME = F2002, FILENAME = 'D:\Demofiles\Mod03\F2002.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2002;
GO

-- Create partition function and scheme
CREATE PARTITION FUNCTION PF (int) AS RANGE RIGHT FOR VALUES (20000101, 20010101, 20020101);
CREATE PARTITION SCHEME PS AS PARTITION PF TO (FG0000, FG2000, FG2001, FG2002);

-- Create a partitioned table
CREATE TABLE fact_table
 (datekey int, measure int)
ON PS(datekey);
GO

-- Insert data into the partitioned table
INSERT fact_table VALUES (20000101, 100);
INSERT fact_table VALUES (20001231, 100);
INSERT fact_table VALUES (20010101, 100);
INSERT fact_table VALUES (20010403, 100);
GO

-- Query the table
SELECT datekey, measure, $PARTITION.PF(datekey) PartitionNo
FROM fact_table;

-- View filegroups, partitions, and rows
SELECT OBJECT_NAME(p.object_id) as obj_name, f.name, p.partition_number, p.rows
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
JOIN sys.filegroups f ON a.filegroup_id = f.data_space_id
WHERE p.object_id = OBJECT_ID(N'dbo.fact_table')
ORDER BY obj_name, p.index_id, p.partition_number;
GO

-- Add a new filegroup and make it the next used
ALTER DATABASE DemoDW ADD FILEGROUP FG2003
GO
ALTER DATABASE DemoDW ADD FILE (NAME = F2003, FILENAME = 'D:\Demofiles\Mod03\F2003.ndf', SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2003;
GO
ALTER PARTITION SCHEME PS
NEXT USED FG2003;
GO

-- Split the empty partition at the end
ALTER PARTITION FUNCTION PF() SPLIT RANGE(20030101);
GO

-- Insert new data
INSERT fact_table VALUES (20020101, 100);
INSERT fact_table VALUES (20021005, 100);
GO

-- View partition metadata
SELECT DISTINCT OBJECT_NAME(p.object_id) as obj_name, f.name, p.partition_number, p.rows
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
JOIN sys.filegroups f ON a.filegroup_id = f.data_space_id
WHERE p.object_id = OBJECT_ID(N'dbo.fact_table')
ORDER BY obj_name, p.partition_number;
GO

-- Merge the 2000 and 2001 partitions
ALTER PARTITION FUNCTION PF() MERGE RANGE(20010101);
GO

-- View partition metadata
SELECT DISTINCT OBJECT_NAME(p.object_id) as obj_name, f.name, p.partition_number, p.rows
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
JOIN sys.filegroups f ON a.filegroup_id = f.data_space_id
WHERE p.object_id = OBJECT_ID(N'dbo.fact_table')
ORDER BY obj_name, p.partition_number;
GO
