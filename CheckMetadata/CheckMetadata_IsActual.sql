/* 
Проверка актуальных метаданных на дубли
Флаг _IsActual = 0x01 должен быть установлен только у последней версии метаданных
*/
SELECT
	n.Type						as Type,
	n.Name						as Name,
	md._MetadataId				as MetadataId,
	md._MetadataVersionNumber	as MetadataVersionNumber,
	e.MetadataMaxVersion		as MetadataMaxVersion
FROM [dbo].[_DataHistoryMetadata] as md
	inner join (
		SELECT
			md._MetadataId,
			MAX(md._MetadataVersionNumber) as MetadataMaxVersion
		FROM [dbo].[_DataHistoryMetadata] as md
			left join [dbo].[_DataHistoryMetadataName] as n
				on md._MetadataId = n._MetadataId
		where md._IsActual = 0x01
		group by 
			n.Type,
			n.Name,
			md._MetadataId
		having count(md._MetadataVersionNumber) > 1
	) as e
		on md._MetadataId = e._MetadataId
	left join [dbo].[_DataHistoryMetadataName] as n
		on md._MetadataId = n._MetadataId

order by 1,2,3