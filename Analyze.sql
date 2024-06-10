--drop table #DataHistoryAnalyze

-- Сбор данных
SELECT
	q.Type						as Type,
	q.Name						as Name,
	q.MetadataId				as MetadataId,
	q.UserName					as UserName,
	Count(Distinct q.DataId)	as CountDataId,
	Count(q.VersionNumber)		as CountVer,
	Max(q.VersionNumber)		as MaxVer,
	Sum(q.Size)/1024			as SizeKb,
	Min(q.Date)					as MinDate,
	Max(q.Date)					as MaxDate
INTO #DataHistoryAnalyze
FROM (
	SELECT
		n.Type					as Type,
		n.Name					as Name,
		md._MetadataId			as MetadataId,
		l._DataId				as DataId,
		v._UserName				as UserName,
		v._VersionNumber		as VersionNumber,
		16 + 9 + 9 + 10 + 5 + 16 
			+ DATALENGTH(v._UserName)*2
			+ DATALENGTH(v._UserFullName)*2
			+ DATALENGTH(v._Comment)*2
			+ 16 + 1 + 4 + 16
			+ DATALENGTH(v._Content)
								as Size,
		v._Date					as Date
	FROM [dbo].[_DataHistoryMetadata] as md
		left join [dbo].[_DataHistoryMetadataName] as n
			on md._MetadataId = n._MetadataId
			--and md._Fld2983 = 0   -- имя разделителя
		inner join [dbo].[_DataHistoryLatestVersions] as l
			on md._MetadataId = l._MetadataId 
		left join [dbo].[_DataHistoryVersions] as v
			on v._HistoryDataId = l._HistoryDataId
				and v._MetadataVersionNumber = md._MetadataVersionNumber	

	Where md._IsActual = 0x01

	UNION ALL

	-- закоментировать если таблица _DataHistoryLatestVersions1 отсутсвует
	SELECT
		n.Type,
		n.Name,
		md._MetadataId,
		l._DataId,
		v._UserName,
		v._VersionNumber,
		16 + 9 + 9 + 10 + 5 + 16 
			+ DATALENGTH(v._UserName)*2
			+ DATALENGTH(v._UserFullName)*2
			+ DATALENGTH(v._Comment)*2
			+ 16 + 1 + 4 + 16
			+ DATALENGTH(v._Content),
		v._Date
	FROM [dbo].[_DataHistoryMetadata] as md 
		left join [dbo].[_DataHistoryMetadataName] as n
			on md._MetadataId = n._MetadataId
			--and md._Fld2983 = 0   -- имя разделителя
		inner join [dbo].[_DataHistoryLatestVersions1] as l
			on md._MetadataId = l._MetadataId 
			--and md._Fld2983 = l._Fld2983
		left join [dbo].[_DataHistoryVersions] as v
			on v._HistoryDataId = l._HistoryDataId
				and v._MetadataVersionNumber = md._MetadataVersionNumber
				
	Where md._IsActual = 0x01

	UNION ALL

	-- закоментировать если таблица _DataHistoryLatestVersions2 отсутсвует
	SELECT
		n.Type,
		n.Name,
		md._MetadataId,
		l._DataId,
		v._UserName,
		v._VersionNumber,
		16 + 9 + 9 + 10 + 5 + 16 
			+ DATALENGTH(v._UserName)*2
			+ DATALENGTH(v._UserFullName)*2
			+ DATALENGTH(v._Comment)*2
			+ 16 + 1 + 4 + 16
			+ DATALENGTH(v._Content),
		v._Date
	FROM [dbo].[_DataHistoryMetadata] as md 
		left join [dbo].[_DataHistoryMetadataName] as n
			on md._MetadataId = n._MetadataId
		inner join [dbo].[_DataHistoryLatestVersions2] as l
			on md._MetadataId = l._MetadataId
			--and md._Fld2983 = l._Fld41535
		left join [dbo].[_DataHistoryVersions] as v
			on v._HistoryDataId = l._HistoryDataId
				and v._MetadataVersionNumber = md._MetadataVersionNumber

	Where md._IsActual = 0x01

) as q

Group by
	q.Type,
	q.Name,
	q.MetadataId,
	q.UserName
	
option (maxdop 8)
GO
;

-- Анализ
SELECT TOP (1000) 
	q.Type					as Type,
	q.Name					as Name,
	--q.UserName			as _UserName,
	Sum(q.CountVer)			as CountVer,
	Sum(q.CountDataId) 		as CountDataId,
	Max(q.MaxVer)			as MaxVer,
	Sum(q.SizeKb)				as SizeKb,
	Min(q.MinDate)			as MinDate,
	Max(q.MaxDate)			as MaxDate

from #DataHistoryAnalyze as q

Group by
	q.Type,
	q.Name
	--,q.UserName
	
Order by
	--CountVer desc,
	SizeKb desc
