DROP TABLE IF EXISTS input;
CREATE TABLE input AS (
    SELECT
        generate_series(1, 1000000) id,
        floor(random() * 100) age,
        substring(md5(random()::TEXT) FOR 5) name
);

DROP MATERIALIZED VIEW IF EXISTS input_materialized;
CREATE MATERIALIZED VIEW input_materialized AS (
    SELECT age, count(*)
    FROM input
    WHERE age BETWEEN 20 AND 30
    GROUP BY age
);

REFRESH MATERIALIZED VIEW input_materialized; -- no unique index required

CREATE UNIQUE INDEX ON input_materialized (age);
REFRESH MATERIALIZED VIEW CONCURRENTLY input_materialized; -- requires unique index

SELECT * FROM input_materialized;

