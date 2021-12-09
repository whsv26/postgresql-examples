DROP TABLE IF EXISTS places;
CREATE TEMPORARY TABLE places AS (
    SELECT * FROM (VALUES
        ('London', point(51.509865, -0.118092)),
        ('New York City', point(40.730610, -73.935242)),
        ('Berlin', point(52.520008, 13.404954)),
        ('Moscow', point(55.751244, 37.618423)),
        ('Paris', point(48.864716, 2.349014)),
        ('Tokyo', point(35.652832, 139.839478))
    ) AS v(geo, location)
);

CREATE INDEX ON places USING gist(location);

SELECT
    p.geo place,
    nnn.neighbours
FROM places p
    JOIN LATERAL (
        SELECT array_agg(nn.geo) neighbours
        FROM (
            SELECT n.geo
            FROM places n
            WHERE n.geo <> p.geo
            ORDER BY n.location <-> p.location
            LIMIT 2
        ) nn
    ) nnn ON TRUE;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS places;
CREATE TEMPORARY TABLE places AS (
    SELECT
        generate_series(1, 1000) AS id,
        point(
            random() * 180 * (CASE WHEN random() > 0.5 THEN 1 ELSE -1 END),
            random() * 180 * (CASE WHEN random() > 0.5 THEN 1 ELSE -1 END)
        ) AS location
);

CREATE INDEX ON places USING gist(location);

SELECT
    p.location,
    nnn.neighbours
FROM places p
    JOIN LATERAL (
        SELECT array_agg(nn.location) neighbours
        FROM (
            SELECT n.location
            FROM places n
            WHERE n.location <> p.location
            ORDER BY n.location <-> p.location
            LIMIT 2
        ) nn
    ) nnn ON TRUE;

------------------------------------------------------------------------------------------------------------------------
-- Nested Loop  (cost=52.43..89213.25 rows=1700 width=48) (actual time=3.439..2548.916 rows=1000 loops=1)
--   ->  Seq Scan on places p  (cost=0.00..27.00 rows=1700 width=16) (actual time=0.011..1.372 rows=1000 loops=1)
--   ->  Aggregate  (cost=52.43..52.44 rows=1 width=32) (actual time=2.540..2.541 rows=1 loops=1000)
--         ->  Limit  (cost=52.40..52.41 rows=2 width=24) (actual time=2.525..2.530 rows=2 loops=1000)
--               ->  Sort  (cost=52.40..56.63 rows=1692 width=24) (actual time=2.521..2.522 rows=2 loops=1000)
--                     Sort Key: ((n.location <-> p.location))
--                     Sort Method: top-N heapsort  Memory: 25kB
--                     ->  Seq Scan on places n  (cost=0.00..35.48 rows=1692 width=24) (actual time=0.003..1.282 rows=999 loops=1000)
--                           Filter: (location <> p.location)
--                           Rows Removed by Filter: 1
-- Planning Time: 0.151 ms
-- Execution Time: 2550.311 ms
------------------------------------------------------------------------------------------------------------------------

-- VS

------------------------------------------------------------------------------------------------------------------------
-- Nested Loop  (cost=0.35..398.88 rows=1000 width=48) (actual time=0.093..52.179 rows=1000 loops=1)
--   ->  Seq Scan on places p  (cost=0.00..17.00 rows=1000 width=16) (actual time=0.006..1.295 rows=1000 loops=1)
--   ->  Aggregate  (cost=0.35..0.36 rows=1 width=32) (actual time=0.045..0.046 rows=1 loops=1000)
--         ->  Limit  (cost=0.14..0.32 rows=2 width=24) (actual time=0.031..0.039 rows=2 loops=1000)
--               ->  Index Only Scan using places_location_idx on places n  (cost=0.14..90.63 rows=995 width=24) (actual time=0.025..0.030 rows=2 loops=1000)
--                     Order By: (location <-> p.location)
--                     Filter: (location <> p.location)
--                     Rows Removed by Filter: 1
--                     Heap Fetches: 3000
-- Planning Time: 0.194 ms
-- Execution Time: 53.416 ms
------------------------------------------------------------------------------------------------------------------------
