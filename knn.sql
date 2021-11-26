drop table if exists places;
create temporary table places as (
    select * from (values
        ('Ставрополь', point(45.0390, 41.9632)),
        ('Краснодар', point(45.0360, 38.9746)),
        ('Москва', point(55.7558, 37.6173)),
        ('Георгиевск', point(44.4299494, 42.407439)),
        ('Михайловск', point(45.1300, 42.0284)),
        ('Лондон', point(51.5072, 0.1276))
    ) as v(geo, location)
);

create index on places using gist(location);

select
    p.geo as place,
    nnn.neighbours
from places p
    join lateral (
        select array_agg(nn.geo) as neighbours
        from (
            select n.geo
            from places n
            where n.geo <> p.geo
            order by n.location <-> p.location
            limit 2
        ) nn
    ) as nnn on true;

