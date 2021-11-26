WITH input(id, age, name) AS (VALUES
    (1, 30, 'Alex'),
    (2, 33, 'Bob'),
    (3, 20, 'Tom'),
    (4, 45, 'Gym boss')
)

SELECT *
FROM input
WHERE
    -- (:param isnull or predicate) is always true if :param is null (not passed)
    -- (:param isnull or predicate) is always predicate if :param is not null (passed)

    -- (true or a = aa) and (true or b = bb) and (false or c = cc)
    -- is equals to (true) and (true) and (c = cc)
    -- is equals to (c = cc)

    -- age optional filter
    (:age_filter ISNULL OR age = :age_filter) AND

    -- name optional filter
    (:name_filter ISNULL OR name = :name_filter) AND

    -- id optional filter
    (:id_filter ISNULL OR id = :id_filter) AND

    -- ids optional filter
    (:ids_filter ISNULL OR id = ANY (string_to_array(:ids_filter, ',')::INT[]));