with recursive

input(id, parent_id, level) as (values
    (1, 0, 'level 1'),
    (2, 1, 'level 2'),
    (3, 2, 'level 3'),
    (4, 3, 'level 4')
),

hierarchy as (
    select id, parent_id, level
    from input
    where id = 3 -- start point
    union all
    -- stop when join result is empty set (0 rows returned)
    select i.id, i.parent_id, i.level
    from hierarchy h -- previous result set stored in temporary table
        join input i
            on i.id = h.parent_id
)

select *
from hierarchy
