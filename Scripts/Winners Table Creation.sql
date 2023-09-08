CREATE TABLE winners

SELECT
rr.raceId,
rr.driverId,
CONCAT(d.forename, " ", d.surname) AS driver_name,
rr.position,
rr.points,
MAX(r.RaceDate) AS raceDwinnersate
FROM results AS RR

JOIN
drivers as d
ON rr.driverId = d.driverId

JOIN
(
SELECT
r.raceId,
MAX(r.RaceDate)
FROM
races as r
) AS r
ON r.raceId = rr.raceId

WHERE rr.position = 1
GROUP BY rr.raceId, rr.driverId, driver_name, rr.position, rr.points
ORDER BY raceDate;
