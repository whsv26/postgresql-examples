DROP TABLE IF EXISTS input;
CREATE TABLE input AS (
    SELECT
        generate_series(1, 1000000) id,
        floor(random() * 100) age,
        substring(md5(random()::TEXT) FOR 5) sensitive
);

DROP VIEW IF EXISTS input_no_sensitive;
CREATE VIEW input_no_sensitive AS (
    SELECT id, age
    FROM input
);

SELECT * FROM input_no_sensitive;

