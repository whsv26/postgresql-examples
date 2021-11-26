with input(id, age, name) as (values
    (1, 30, 'Alex'),
    (2, 33, 'Bob'),
    (3, 20, 'Tom'),
    (4, 45, 'Gym boss')
)

select *
from input
where
    -- (:param isnull or predicate) is always true if :param is null (not passed)
    -- (:param isnull or predicate) is always predicate if :param is not null (passed)

    -- (true or a = aa) and (true or b = bb) and (false or c = cc)
    -- is equals to (true) and (true) and (c = cc)
    -- is equals to (c = cc)

    -- age optional filter
    (:age_filter isnull or age = :age_filter) and

    -- name optional filter
    (:name_filter isnull or name = :name_filter) and

    -- id optional filter
    (:id_filter isnull or id = :id_filter) and

    -- ids optional filter
    (:ids_filter isnull or id = any (string_to_array(:ids_filter, ',')::int[]));