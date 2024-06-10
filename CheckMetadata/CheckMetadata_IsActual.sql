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
	INNER JOIN (
		SELECT
			md._MetadataId,
			MAX(md._MetadataVersionNumber) as MetadataMaxVersion
		FROM [dbo].[_DataHistoryMetadata] as md
		WHERE 
			md._IsActual = 0x01
		GROUP BY 
			md._MetadataId
		HAVING COUNT(md._MetadataVersionNumber) > 1
	) as e
		ON md._MetadataId = e._MetadataId
		--and md._Fld2983 = 0   -- имя разделителя
	LEFT JOIN [dbo].[_DataHistoryMetadataName] as n
		ON md._MetadataId = n._MetadataId

ORDER BY 1,2,3