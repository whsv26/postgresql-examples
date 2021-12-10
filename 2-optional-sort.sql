WITH input(id, age, name) AS (VALUES
    (1, 30, 'Alex'),
    (2, 33, 'Bob'),
    (3, 20, 'Tom'),
    (4, 45, 'Gym boss')
)

SELECT *
FROM input
ORDER BY
    -- ORDER BY constant ASC, x DESC = ORDER BY x DESC
    -- ORDER BY x ASC, constant DESC = ORDER BY x ASC

    -- name optional sorting
    (CASE WHEN :sorting = 'name:asc' THEN name END),
    (CASE WHEN :sorting = 'name:desc' THEN name END) DESC,

    -- age optional sorting
    (CASE WHEN :sorting = 'age:asc' THEN age END),
    (CASE WHEN :sorting = 'age:desc' THEN age END) DESC;