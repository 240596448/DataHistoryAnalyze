USE [<BaseName, varchar(80),>]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[_DataHistoryMetadataName]'))
DROP TABLE [dbo].[_DataHistoryMetadataName]
GO

CREATE TABLE [dbo].[_DataHistoryMetadataName](
	[_MetadataId] [binary](16) NOT NULL,
	[Type] [varchar](30) NOT NULL,
	[Name] [varchar](80) NOT NULL
)
GO

CREATE UNIQUE CLUSTERED INDEX [ClusteredIndex] ON [dbo].[_DataHistoryMetadataName](
[_MetadataId] ASC
)
GO
