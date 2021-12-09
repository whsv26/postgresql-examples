DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers AS (
    SELECT
        generate_series(1000000, 1, -1) AS id,
        generate_series(1, 1000000) AS num
);

 -- Trigger index only scan with id column inclusion
CREATE INDEX ON numbers (num ASC) INCLUDE (id);
CREATE INDEX ON numbers (num DESC) INCLUDE (id);
VACUUM ANALYZE; -- Update visibility map to eliminate heap fetches for index only scan

EXPLAIN ANALYZE SELECT id
FROM numbers
ORDER BY num DESC
LIMIT 10000;

------------------------------------------------------------------------------------------------------------------------
-- ASC index + DESC order by
------------------------------------------------------------------------------------------------------------------------
-- Limit  (cost=0.42..260.23 rows=10000 width=8) (actual time=0.051..45.009 rows=10000 loops=1)
--   ->  Index Only Scan Backward using numbers_num_id_idx on numbers  (cost=0.42..25980.42 rows=1000000 width=8) (actual time=0.048..16.768 rows=10000 loops=1)
--         Heap Fetches: 0
-- Planning Time: 0.165 ms
-- Execution Time: 59.288 ms
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- DESC index + DESC order by
------------------------------------------------------------------------------------------------------------------------
-- Limit  (cost=0.42..260.23 rows=10000 width=8) (actual time=0.070..45.714 rows=10000 loops=1)
--   ->  Index Only Scan using numbers_num_id_idx on numbers  (cost=0.42..25980.42 rows=1000000 width=8) (actual time=0.066..15.718 rows=10000 loops=1)
--         Heap Fetches: 0
-- Planning Time: 0.234 ms
-- Execution Time: 60.651 ms
------------------------------------------------------------------------------------------------------------------------
