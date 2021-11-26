with

users(id, username) as (values
    (1, 'User A'),
    (2, 'User B'),
    (3, 'User C'),
    (4, 'User D')
),

comments(user_id, text, created_at) as (values
    (1, 'User A comment 1', '2021-01-01 00:00:00'::timestamp),
    (1, 'User A comment 2', '2021-01-01 01:00:00'::timestamp),
    (1, 'User A comment 3', '2021-01-01 02:00:00'::timestamp),
    (3, 'User C comment 1', '2021-01-01 00:00:00'::timestamp)
)

select
    u.username,
    cc.text
from users u
    join lateral (
        select c.text
        from comments c
        where c.user_id = u.id
        order by c.created_at desc
        limit 2
    ) as cc on true

