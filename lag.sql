WITH

users(id, username) AS (VALUES
    (1, 'User A'),
    (2, 'User B')
),

comments(user_id, text, created_at) AS (VALUES
    (1, 'User A comment 1', '2021-01-01 01:00:00'::TIMESTAMP),
    (1, 'User A comment 2', '2021-01-01 03:00:00'::TIMESTAMP),
    (1, 'User A comment 3', '2021-01-01 04:00:00'::TIMESTAMP),
    (2, 'User B comment 1', '2021-01-02 00:01:00'::TIMESTAMP),
    (2, 'User B comment 2', '2021-01-02 00:05:00'::TIMESTAMP),
    (2, 'User B comment 3', '2021-01-02 00:07:00'::TIMESTAMP),
    (2, 'User B comment 4', '2021-01-02 00:10:00'::TIMESTAMP)
)

SELECT dd.username most_active
FROM (
    SELECT
        d.username,
        avg(delta) avg_delta
    FROM (
        SELECT
            u.username,
            c.created_at - lag(c.created_at) OVER (
                PARTITION BY c.user_id
                ORDER BY c.created_at
            ) delta
        FROM users u
            JOIN comments c
                ON u.id = c.user_id
    ) d
    GROUP BY d.username
) dd
ORDER BY dd.avg_delta
LIMIT 1;
