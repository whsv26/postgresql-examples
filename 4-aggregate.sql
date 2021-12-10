DROP AGGREGATE jsonb_merge(JSONB);
CREATE AGGREGATE jsonb_merge(JSONB) (
  SFUNC = jsonb_concat,
  STYPE = JSONB,
  INITCOND = '{}'
);

WITH input(id, obj) AS (VALUES
    (1, '{"x": 1}'::JSONB),
    (1, '{"x": 2, "y": 1}'::JSONB),
    (1, '{"x": 3, "y": 2}'::JSONB)
)
SELECT id, jsonb_merge(obj)
FROM input
GROUP BY id;
