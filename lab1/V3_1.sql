USE master
GO

CREATE DATABASE [MIKITA_BITKIN]
GO

USE [MIKITA_BITKIN]
GO

CREATE SCHEMA [sales]
GO

CREATE SCHEMA [persons]
GO

CREATE TABLE [sales].[Orders] (OrderNum INT NULL)
GO

BACKUP DATABASE [MIKITA_BITKIN] TO DISK = 'D:\Study\DB\lab1\mikita_bitkin.bak' WITH INIT
GO

USE master
GO

DROP DATABASE [MIKITA_BITKIN]
GO

RESTORE DATABASE [MIKITA_BITKIN] FROM DISK = 'D:\Study\DB\lab1\mikita_bitkin.bak'
GO