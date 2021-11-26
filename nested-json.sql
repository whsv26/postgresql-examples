WITH

input(level_1, level_2, level_3, qty) AS (VALUES
    ('a', 'aa', 'aaa', 1),
    ('a', 'ab', 'aba', 2),
    ('a', 'ab', 'abb', 3),
    ('b', 'ba', 'baa', 4)
),

grouping_sets AS (
    SELECT
        level_1,
        level_2,
        level_3,
        sum(qty) qty,
        grouping(level_1) g1,
        grouping(level_2) g2,
        grouping(level_3) g3
    FROM input
    GROUP BY ROLLUP (level_1, level_2, level_3)
),

json_fragment_level_3 AS (
    SELECT
        l3.level_1,
        l3.level_2,
        json_agg(json_build_object(
            'id', l3.level_3,
            'qty', l3.qty
        )) json_array
    FROM grouping_sets l3
    WHERE l3.g1 = 0
        AND l3.g2 = 0
        AND l3.g3 = 0
    GROUP BY l3.level_1, l3.level_2
),

json_fragment_level_2 AS (
    SELECT
        l2.level_1,
        json_agg(json_build_object(
            'id', l2.level_2,
            'qty', l2.qty,
            'sub', coalesce(l3.json_array, '[]')
        )) json_array
    FROM grouping_sets l2
        LEFT JOIN json_fragment_level_3 l3
            ON l2.level_1 = l3.level_1
                AND l2.level_2 = l3.level_2
    WHERE l2.g1 = 0
        AND l2.g2 = 0
        AND l2.g3 = 1
    GROUP BY l2.level_1
),

json_fragment_level_1 AS (
    SELECT
        json_agg(json_build_object(
            'id', l1.level_1,
            'qty', l1.qty,
            'sub', coalesce(l2.json_array, '[]')
        )) json_array
    FROM grouping_sets l1
        LEFT JOIN json_fragment_level_2 l2
            ON l1.level_1 = l2.level_1
    WHERE l1.g1 = 0
        AND l1.g2 = 1
        AND l1.g3 = 1
),

json_fragment_level_0 AS (
    SELECT
        json_build_object(
            'qty', l0.qty,
            'sub', coalesce(l1.json_array, '[]')
        ) json_array
    FROM grouping_sets l0
        LEFT JOIN json_fragment_level_1 l1
            ON TRUE
    WHERE l0.g1 = 1
        AND l0.g2 = 1
        AND l0.g3 = 1
)

SELECT * FROM json_fragment_level_0;
