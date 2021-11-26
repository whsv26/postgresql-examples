with

employees(id, department, name, salary) as (values
    (1, 'Dep 1', 'User A', 500),
    (2, 'Dep 2', 'User B', 999),
    (3, 'Dep 1', 'User C', 5000),
    (4, 'Dep 1', 'User D', 1000)
)

select
    e.id,
    e.department,
    e.name,
    e.salary,
    count(e.id) over dep as empoyees_in_department,
    100 * e.salary / max(e.salary) over dep as significance
from employees e
window dep as (partition by department);

with

transactions(id, username, amount, created_at) as (values
    (1, 'User A',   100, '2021-01-01 00:00:00'::timestamp),
    (2, 'User A',   -20, '2021-01-01 01:00:00'::timestamp),
    (3, 'User A', -3000, '2021-01-01 02:00:00'::timestamp),
    (4, 'User A',  5000, '2021-01-01 03:00:00'::timestamp),
    (5, 'User B',  1000, '2021-01-01 00:00:00'::timestamp)
)

select
    username,
    created_at as actual_at,
    sum(amount) over running_totals as balance
from transactions t
window running_totals as (
    partition by username
    order by created_at
    rows between unbounded preceding and current row
);
