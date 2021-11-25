with recursive

input(id, parent_id, level) as (values
    (1, null, 'level 1'),
    (2, 1, 'level 2'),
    (3, 2, 'level 3'),
    (4, 3, 'level 4'),
),

-- hierarchy as (
--     select
--     from input i
-- )
--
-- select *
-- from input
