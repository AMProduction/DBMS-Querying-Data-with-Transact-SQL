--Task 1
use DoctorWho
go

SELECT [CompanionName] AS [Companion Name]
FROM tblCompanion AS C
LEFT JOIN tblEpisodeCompanion AS EC
ON C.CompanionId = EC.CompanionId
WHERE EC.CompanionId IS NULL

--Task 2
use WorldEvents
go

SELECT E1.[EventName], E1.[EventDate], C.[CountryName]
FROM tblEvent AS E1
LEFT JOIN tblCountry AS C
ON E1.CountryID = C.CountryID
WHERE E1.EventDate > (
	SELECT MAX(E2.EventDate)
	FROM tblEvent AS E2
	WHERE E2.CountryID = 21
)
ORDER BY E1.EventDate DESC

--Task 3
SELECT C.CountryName
FROM (
	SELECT CountryID, COUNT(CountryID) as EventCount
	FROM tblEvent
	GROUP BY CountryID
) as E
INNER JOIN tblCountry as C
ON E.CountryID = C.CountryID
WHERE E.EventCount > 8
ORDER BY C.CountryName ASC

--Task 4
WITH ThisAndThat AS (
SELECT EventID,
		CASE WHEN EventDetails LIKE '%This%' THEN 1 ELSE 0
		END AS cteIfThis,
		CASE WHEN EventDetails LIKE '%That%' THEN 1 ELSE 0
		END AS cteIfThat
FROM tblEvent
)

SELECT 
	CASE cteIfThis WHEN 1 THEN 1 ELSE 0
	END AS IfThis,
	CASE cteIfThat WHEN 1 THEN 1 ELSE 0
	END AS IfThat,
	COUNT(EventID) AS NumderOfEvents
FROM ThisAndThat
GROUP BY cteIfThis, cteIfThat;

SELECT E.EventName, E.EventDetails
FROM tblEvent as E
INNER JOIN ThisAndThat AS CTE
ON E.EventID = CTE.EventID
WHERE CTE.cteIfThis = 1 AND CTE.cteIfThat = 1

--Task 5
WITH ManyCountries AS (
SELECT [ContinentID], COUNT ([CountryID]) AS [COUNT]
FROM tblCountry AS C
GROUP BY [C].[ContinentID]
HAVING COUNT ([CountryID]) > 3
)
,
FewEvents AS (
SELECT C.ContinentID, COUNT(E.EventID) AS Count FROM tblEvent AS E
INNER JOIN tblCountry AS C ON E.CountryID = C.CountryID
GROUP BY C.ContinentID
HAVING COUNT(E.EventID) < 11
)

SELECT [C].[ContinentName] AS [CONTINENT], [MC].[COUNT] AS [Country count], [FE].[Count]
FROM [tblContinent] AS C
INNER JOIN ManyCountries AS MC
ON [C].[ContinentID] = [MC].[ContinentID]
INNER JOIN FewEvents AS FE
ON [MC].[ContinentID] = [FE].[ContinentID]

--Task 6
WITH EraForEvent AS (
SELECT
	CASE
		WHEN YEAR ([E].[EventDate]) < 1900 THEN
			'19th century and earlier'
		WHEN YEAR ([E].[EventDate]) < 2000 THEN
			'20th century'
		ELSE '21st century'
	END AS Era,
[E].[EventID]
FROM tblEvent AS E
)

SELECT [E].[Era], COUNT ([E].[EventID]) FROM EraForEvent AS E
GROUP BY [E].[Era]

--Task 7
WITH EpisodInfo AS (
SELECT YEAR ([E].[EpisodeDate]) AS [EpisodeYear], [E].[SeriesNumber], [E].[EpisodeId]
FROM tblEpisode AS E
)

SELECT * FROM [EpisodInfo] AS SourceTable
PIVOT (COUNT([EpisodeId]) FOR [SeriesNumber] IN ([1],[2],[3],[4],[5])
) AS PivotTable;