DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers AS (
    SELECT
        generate_series(1000000, 1, -1) AS id,
        generate_series(1, 1000000) AS num
);

-- External merge sort without limit
-- And top-N heap sort with limit
SELECT id
FROM numbers
ORDER BY num DESC
LIMIT 10000;

------------------------------------------------------------------------------------------------------------------------
-- With LIMIT
------------------------------------------------------------------------------------------------------------------------
-- Limit  (cost=39357.78..40524.53 rows=10000 width=8) (actual time=1139.878..1194.042 rows=10000 loops=1)
--   ->  Gather Merge  (cost=39357.78..136586.87 rows=833334 width=8) (actual time=1139.871..1166.450 rows=10000 loops=1)
--         Workers Planned: 2
--         Workers Launched: 2
--         ->  Sort  (cost=38357.76..39399.43 rows=416667 width=8) (actual time=1135.556..1142.107 rows=4277 loops=3)
--               Sort Key: num DESC
--               Sort Method: top-N heapsort  Memory: 1706kB
--               Worker 0:  Sort Method: top-N heapsort  Memory: 1706kB
--               Worker 1:  Sort Method: top-N heapsort  Memory: 1706kB
--               ->  Parallel Seq Scan on numbers  (cost=0.00..8591.67 rows=416667 width=8) (actual time=0.059..553.352 rows=333333 loops=3)
-- Planning Time: 0.073 ms
-- Execution Time: 1208.130 ms
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
-- Without LIMIT
------------------------------------------------------------------------------------------------------------------------
-- Sort  (cost=127757.34..130257.34 rows=1000000 width=8) (actual time=2910.781..4311.636 rows=1000000 loops=1)
--   Sort Key: num DESC
--   Sort Method: external merge  Disk: 17696kB
--   ->  Seq Scan on numbers  (cost=0.00..14425.00 rows=1000000 width=8) (actual time=0.044..1331.192 rows=1000000 loops=1)
-- Planning Time: 0.043 ms
-- Execution Time: 5630.481 ms
------------------------------------------------------------------------------------------------------------------------

