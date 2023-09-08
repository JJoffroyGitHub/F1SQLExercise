SELECT
    d.drivernumber,
    CONCAT(d.forename, " ", d.surname) AS 'Driver Name',
    rs.total_seasons AS 'Total Seasons (All Time)',
    r.total_races AS 'Total Races (All Time)',
    r.total_laps AS 'Total Laps (All Time)',
    r.total_points AS 'Total Points (All Time)',
    r.points_per_race AS 'Points Per Race',
    r.total_wins AS 'Total Wins (All Time)',
    r.total_podiums AS 'Total Podiums (All Time)',
    q.total_pole_positions AS 'Total Pole Positions (All Time)',
    sr.total_sprint_wins AS 'Total Sprint Wins (All Time)',
    sr.total_sprint_podiums AS 'Total Sprint Podiums (All Time)',
    rDisq.disqualifications AS 'Total Disqualifications',
    rRetire.retirements AS 'Total Retirements'
FROM drivers AS d

LEFT JOIN (
    SELECT
        r.driverId,
        SUM(r.points) AS total_points,
        COUNT(driverId) AS total_races,
        COUNT(CASE WHEN r.position = 1 THEN 1 END) AS total_wins,
        COUNT(CASE WHEN r.position <= 3 AND r.position >= 1 THEN 1 END) AS total_podiums,
	    FORMAT(SUM(r.points) / COUNT(driverId), 2) AS points_per_race,
        SUM(r.laps) AS total_laps
    FROM results AS r
    GROUP BY r.driverId
) 
AS r ON d.driverId = r.driverId

LEFT JOIN (
    SELECT
        q.driverId,
        COUNT(CASE WHEN q.position = 1 THEN 1 END) AS total_pole_positions
    FROM qualifying AS q
    GROUP BY q.driverId
) 
AS q ON d.driverId = q.driverId

LEFT JOIN (
	SELECT
		sr.driverId,
        COUNT(CASE WHEN sr.position = 1 THEN 1 END) AS total_sprint_wins,
        COUNT(CASE WHEN sr.position >=1 AND sr.position <= 3 THEN 1 END) AS total_sprint_podiums
        FROM sprint_results as sr
        GROUP BY sr.driverId
        )
AS sr ON d.driverId = sr.driverId

LEFT JOIN
	(
    SELECT
		r.driverId,
		COUNT(DISTINCT rs.RaceYear) As total_seasons
    FROM results AS R
    LEFT JOIN races AS rs ON r.raceId = rs.RaceId
    GROUP BY R.driverId
    )
AS rs ON d.driverId = rs.driverId

LEFT JOIN (
    SELECT
		r.driverId,
        COUNT(r.StatusId) AS disqualifications
    FROM results AS r
    WHERE r.StatusId = 2
    GROUP BY r.driverId
) AS rDisq
ON d.driverId = rDisq.driverId

LEFT JOIN (
    SELECT
		r.driverId,
        COUNT(r.StatusId) AS retirements
    FROM results AS r
    WHERE r.StatusId = 31
    GROUP BY r.driverId
) AS rRetire
ON d.driverId = rRetire.driverId
WHERE d.drivernumber > 0
ORDER BY `Total Points (All Time)` DESC;

