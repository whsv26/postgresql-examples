DROP TABLE IF EXISTS places;
CREATE TEMPORARY TABLE places AS (
    SELECT * FROM (VALUES
        ('Ставрополь', point(45.0390, 41.9632)),
        ('Краснодар', point(45.0360, 38.9746)),
        ('Москва', point(55.7558, 37.6173)),
        ('Георгиевск', point(44.4299494, 42.407439)),
        ('Михайловск', point(45.1300, 42.0284)),
        ('Лондон', point(51.5072, 0.1276))
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

