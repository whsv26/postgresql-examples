DROP TABLE IF EXISTS places;
CREATE TEMPORARY TABLE places AS (
    SELECT * FROM (VALUES
        ('London', point(51.509865, -0.118092)),
        ('New York City', point(40.730610, -73.935242)),
        ('Berlin', point(52.520008, 13.404954)),
        ('Moscow', point(55.751244, 37.618423)),
        ('Paris', point(48.864716, 2.349014)),
        ('Tokyo', point(35.652832, 139.839478))
    ) AS v(geo, location)
);

CREATE INDEX ON places USING gist(location);

SELECT
    p.geo place,
    nnn.neighbours
FROM places p
    JOIN LATERAL (
        SELECT array_agg(nn.geo) neighbours
        FROM (
            SELECT n.geo
            FROM places n
            WHERE n.geo <> p.geo
            ORDER BY n.location <-> p.location
            LIMIT 2
        ) nn
    ) nnn ON TRUE;

