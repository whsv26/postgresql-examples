WITH

users(id, username) AS (VALUES
    (1, 'User A with comments'),
    (2, 'User B without comments'),
    (3, 'User C with comments'),
    (4, 'User D without comments')
),

comments(user_id, text, created_at) AS (VALUES
    (1, 'User A comment 1', '2021-01-01 00:00:00'::TIMESTAMP),
    (1, 'User A comment 2', '2021-01-01 01:00:00'::TIMESTAMP),
    (1, 'User A comment 3', '2021-01-01 02:00:00'::TIMESTAMP),
    (3, 'User C comment 1', '2021-01-01 00:00:00'::TIMESTAMP)
)

SELECT
    u.username,
    cc.text last_comment
FROM users u
    INNER JOIN LATERAL (
        SELECT c.text
        FROM comments c
        WHERE c.user_id = u.id
        ORDER BY c.created_at DESC
        LIMIT 2
    ) cc ON TRUE

