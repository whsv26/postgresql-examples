with

input(level_1, level_2, level_3, qty) as (values
    ('a', 'aa', 'aaa', 1),
    ('a', 'ab', 'aba', 2),
    ('a', 'ab', 'abb', 3),
    ('b', 'ba', 'baa', 4)
),

grouping_sets as (
    select
        level_1,
        level_2,
        level_3,
        sum(qty) as qty,
        grouping(level_1) as g1,
        grouping(level_2) as g2,
        grouping(level_3) as g3
    from input
    group by rollup (level_1, level_2, level_3)
),

json_fragment_level_3 as (
    select
        l3.level_1,
        l3.level_2,
        json_agg(json_build_object(
            'id', l3.level_3,
            'qty', l3.qty
        )) as json_array
    from grouping_sets l3
    where l3.g1 = 0
        and l3.g2 = 0
        and l3.g3 = 0
    group by l3.level_1, l3.level_2
),

json_fragment_level_2 as (
    select
        l2.level_1,
        json_agg(json_build_object(
            'id', l2.level_2,
            'qty', l2.qty,
            'sub', coalesce(l3.json_array, '[]')
        )) as json_array
    from grouping_sets l2
        left join json_fragment_level_3 l3
            on l2.level_1 = l3.level_1
                and l2.level_2 = l3.level_2
    where l2.g1 = 0
        and l2.g2 = 0
        and l2.g3 = 1
    group by l2.level_1
),

json_fragment_level_1 as (
    select
        json_agg(json_build_object(
            'id', l1.level_1,
            'qty', l1.qty,
            'sub', coalesce(l2.json_array, '[]')
        )) as json_array
    from grouping_sets l1
        left join json_fragment_level_2 l2
            on l1.level_1 = l2.level_1
    where l1.g1 = 0
        and l1.g2 = 1
        and l1.g3 = 1
),

json_fragment_level_0 as (
    select
        json_build_object(
            'qty', l0.qty,
            'sub', coalesce(l1.json_array, '[]')
        ) as json_array
    from grouping_sets l0
        left join json_fragment_level_1 l1
            on true
    where l0.g1 = 1
        and l0.g2 = 1
        and l0.g3 = 1
)

select * from json_fragment_level_0;
