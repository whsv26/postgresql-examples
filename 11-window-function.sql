WITH

employees(id, department, name, salary) AS (VALUES
    (1, 'Dep 1', 'User A', 500),
    (2, 'Dep 2', 'User B', 999),
    (3, 'Dep 1', 'User C', 5000),
    (4, 'Dep 1', 'User D', 1000)
)

SELECT
    e.id,
    e.department,
    e.name,
    e.salary,
    count(e.id) OVER dep empoyees_in_department,
    100 * e.salary / max(e.salary) OVER dep significance
FROM employees e
WINDOW dep AS (PARTITION BY department);

WITH

transactions(id, username, amount, created_at) AS (VALUES
    (1, 'User A',   100, '2021-01-01 00:00:00'::TIMESTAMP),
    (2, 'User A',   -20, '2021-01-01 01:00:00'::TIMESTAMP),
    (3, 'User A', -3000, '2021-01-01 02:00:00'::TIMESTAMP),
    (4, 'User A',  5000, '2021-01-01 03:00:00'::TIMESTAMP),
    (5, 'User B',  1000, '2021-01-01 00:00:00'::TIMESTAMP)
)

SELECT
    username,
    created_at actual_at,
    sum(amount) OVER running_totals balance
FROM transactions t
WINDOW running_totals AS (
    PARTITION BY username
    ORDER BY created_at
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
);
