drop table if exists input;
create table input as (
    select
        generate_series(1, 1000000) as id,
        floor(random() * 100) as age,
        substring(md5(random()::text) for 5) as name
);

drop materialized view if exists input_materialized;
create materialized view input_materialized as (
    select age, count(*)
    from input
    where age between 20 and 30
    group by age
);

refresh materialized view input_materialized; -- no unique index required

create unique index on input_materialized (age);
refresh materialized view concurrently input_materialized; -- requires unique index

select * from input_materialized;

