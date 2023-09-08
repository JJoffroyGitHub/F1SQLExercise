-- ALTER TABLE drivers
-- RENAME COLUMN number TO drivernumber;

ALTER TABLE races
-- RENAME COLUMN date to RaceDate,
-- RENAME COLUMN Year to RaceYear,
RENAME COLUMN name to raceName;

ALTER TABLE circuits
RENAME Column name to CircuitName;

DELETE FROM results
WHERE position = 0;
