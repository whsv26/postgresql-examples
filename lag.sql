with

users(id, username) as (values
    (1, 'User A'),
    (2, 'User B')
),

comments(user_id, text, created_at) as (values
    (1, 'User A comment 1', '2021-01-01 01:00:00'::timestamp),
    (1, 'User A comment 2', '2021-01-01 03:00:00'::timestamp),
    (1, 'User A comment 3', '2021-01-01 04:00:00'::timestamp),
    (2, 'User B comment 1', '2021-01-02 00:01:00'::timestamp),
    (2, 'User B comment 2', '2021-01-02 00:05:00'::timestamp),
    (2, 'User B comment 3', '2021-01-02 00:07:00'::timestamp),
    (2, 'User B comment 4', '2021-01-02 00:10:00'::timestamp)
)

select dd.username as most_active
from (
    select
        d.username,
        avg(delta) as avg_delta
    from (
        select
            u.username,
            c.created_at - lag(c.created_at) over (
                partition by c.user_id
                order by c.created_at
            ) as delta
        from users u
            join comments c
                on u.id = c.user_id
    ) d
    group by d.username
) dd
order by dd.avg_delta
limit 1;
