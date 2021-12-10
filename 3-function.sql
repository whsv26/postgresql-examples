CREATE OR REPLACE FUNCTION generate_peoples(
    IN size INT,
    OUT id INT,
    OUT age INT,
    OUT name TEXT
) RETURNS SETOF RECORD
AS $$
BEGIN
    RETURN QUERY SELECT
        generate_series(1, size) AS id,
        (random() * 100)::INT AS age,
        substring(md5(random()::TEXT) FOR 5) AS name;
END
$$
LANGUAGE plpgsql;

SELECT * FROM generate_peoples(5);