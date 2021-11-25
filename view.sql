drop table if exists input;
create table input as (
    select
        generate_series(1, 1000000) as id,
        floor(random() * 100) as age,
        substring(md5(random()::text) for 5) as sensitive
);

drop view if exists input_no_sensitive;
create view input_no_sensitive as (
    select id, age
    from input
);

select * from input_no_sensitive;

