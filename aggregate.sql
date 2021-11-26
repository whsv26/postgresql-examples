drop aggregate jsonb_merge(jsonb);
create aggregate jsonb_merge(jsonb) (
  SFUNC = jsonb_concat,
  STYPE = jsonb,
  INITCOND = '{}'
);

with input(id, obj) as (values
    (1, '{"x": 1}'::jsonb),
    (1, '{"x": 2, "y": 1}'::jsonb),
    (1, '{"x": 3, "y": 2}'::jsonb)
)
select
    id,
    jsonb_merge(obj)
from input
group by id;
