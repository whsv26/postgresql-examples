with input(id, age, name) as (values
    (1, 30, 'Alex'),
    (2, 33, 'Bob'),
    (3, 20, 'Tom'),
    (4, 45, 'Gym boss')
)

select *
from input
order by
    -- order by constant ASC, x DESC = order by x DESC
    -- order by x ASC, constant DESC = order by x ASC

    -- name optional sorting
    (case when :sorting = 'name:asc' then name end),
    (case when :sorting = 'name:desc' then name end) DESC,

    -- age optional sorting
    (case when :sorting = 'age:asc' then age end),
    (case when :sorting = 'age:desc' then age end) DESC;