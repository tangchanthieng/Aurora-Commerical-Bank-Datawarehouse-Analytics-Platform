// SQL script to create the database and schemas for the Commercial Banking Analysis project


USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'DB_Aurora_Bank')
    DROP DATABASE DB_Aurora_Bank;
GO

CREATE DATABASE DB_Aurora_Bank;
GO

// SQL script to create the schemas for the Commercial Banking Analysis project

USE DB_Aurora_Bank;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO