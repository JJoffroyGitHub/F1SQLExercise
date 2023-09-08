CREATE TABLE LatestWinners

SELECT
    c.circuitName,
    rr.driverId,
    CONCAT(d.forename, " ", d.surname) AS 'Driver Name',
    rr.position,
    rr.points,
    r.RaceDate
FROM
    circuits AS c
JOIN
    (
    SELECT
        r.circuitId,
        MAX(r.RaceDate) AS LatestRaceDate
    FROM
        races AS r
    JOIN
        results AS rr ON r.raceId = rr.raceId
    WHERE
        rr.position = 1
    GROUP BY
        r.circuitId
    ) AS latestRace ON c.circuitId = latestRace.circuitId
JOIN
    races AS r ON c.circuitId = r.circuitId AND r.RaceDate = latestRace.LatestRaceDate
JOIN
    results AS rr ON r.raceId = rr.raceId AND rr.position = 1
JOIN
    drivers AS d ON rr.driverId = d.driverId
ORDER BY
    r.RaceDate DESC;

