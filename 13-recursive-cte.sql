WITH RECURSIVE

-- adjacency list
input(id, parent_id, level) AS (VALUES
    (1, 0, 'level 1'),
    (2, 1, 'level 2'),
    (3, 2, 'level 3'),
    (4, 3, 'level 4')
),

hierarchy AS (
    SELECT id, parent_id, level
    FROM input
    WHERE id = 3 -- start point
    UNION ALL
    -- stop when join result is empty set (0 rows returned)
    SELECT i.id, i.parent_id, i.level
    FROM hierarchy h -- previous result set stored in temporary table
        JOIN input i
            ON i.id = h.parent_id
)

SELECT * FROM hierarchy
