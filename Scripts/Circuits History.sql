SELECT 
c.circuitId, 
c.CircuitName, 
c.location,
c.country,
TotalRaceTable.`Total Races At this Location`,
lw.RaceDate AS 'Last Race At This Location',
lw.`Last Winner` AS 'Last Race Winner at This Track',
FastestLaps.`Fastest Lap Time` AS 'Fastest Lap on This Track',
FastestLaps.`Fastest Lap Speed` AS 'Fastest Lap Speed on this Track'
FROM
circuits AS c

LEFT JOIN
(
SELECT
c.circuitId,
COUNT(r.raceId) AS 'Total Races At this Location'
FROM
races as r
LEFT JOIN circuits AS C
ON c.circuitid = r.circuitid
GROUP BY c.circuitId
) AS TotalRaceTable
ON c.circuitId = TotalRaceTable.circuitId

LEFT JOIN
(
SELECT
c.circuitId,
MIN(rr.fastestlapTime) AS 'Fastest Lap Time',
CONCAT(MAX(rr.fastestlapSpeed), ' km/h') AS 'Fastest Lap Speed'
FROM circuits as C
LEFT JOIN races as r
ON c.circuitId = r.circuitId
LEFT JOIN results as rr
ON r.raceId = rr.raceId
LEFT JOIN drivers as d
ON rr.driverId = d.driverId
WHERE rr.fastestlapTime IS NOT NULL AND rr.fastestlapTime > 0
GROUP BY c.circuitId
) AS FastestLaps
ON c.circuitId = FastestLaps.circuitId 

LEFT JOIN
(
SELECT
lw.circuitName,
lw.RaceDate,
lw.`Driver Name` AS 'Last Winner'
FROM latestwinners as lw
) AS lw
ON c.circuitName = lw.circuitName

GROUP BY c.circuitId, c.CircuitName, c.location, c.country, 
TotalRaceTable.`Total Races At this Location`, `Last Race At This Location`, 
`Last Race Winner at This Track`, `Fastest Lap on This Track`, `Fastest Lap Speed on this Track`
ORDER BY `Total Races At this Location` DESC, `Last Race At This Location` DESC;

