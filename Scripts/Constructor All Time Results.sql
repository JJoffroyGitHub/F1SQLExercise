SELECT

c.constructorId,
c.constructorRef,
c.name,
SUM(cr.points) AS 'Total Points All Time',
r.minracedate AS 'First Race for Constructor',
r.maxracedate AS 'Last Race for Constructor',
CONCAT(ROUND(DATEDIFF(r.maxracedate, r.minracedate) / 365.25, 2), " Years") AS 'Time Spent in F1',
IF(r.maxracedate = "2022-11-20", "Active", "Inactive") AS 'Status'

FROM constructors AS c

JOIN(
SELECT
cr.constructorId,
MAX(r.RaceDate) AS maxracedate,
MIN(r.RaceDate) AS minracedate

From Races as R

JOIN
constructor_results AS cr
ON
r.raceId = cr.raceId

GROUP BY cr.constructorId
) AS r
ON c.constructorId = r.constructorId

JOIN constructor_results as cr
ON c.constructorId = cr.constructorId


GROUP BY c.constructorId, c.constructorRef, c.name, r.minracedate, r.maxracedate;