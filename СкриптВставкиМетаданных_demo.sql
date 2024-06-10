USE [<BaseName, varchar(80),>]
GO

TRUNCATE TABLE [dbo].[_DataHistoryMetadataName]

INSERT INTO [dbo].[_DataHistoryMetadataName]
			([_MetadataId]
			,[Type]
			,[Name])
		VALUES
			(Val1, Val2, Val3)
GO