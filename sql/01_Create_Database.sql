-- SQL script to create the database and schemas for the Commercial Banking Analysis project

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DB_Aurora_Bank')
    DROP DATABASE DB_Aurora_Bank;
GO

CREATE DATABASE DB_Aurora_Bank;
GO

-- SQL script to create the schemas for the Commercial Banking Analysis project

USE DB_Aurora_Bank;
GO

CREATE SCHEMA Bronze;
GO

CREATE SCHEMA Silver;
GO

CREATE SCHEMA Gold;
GO