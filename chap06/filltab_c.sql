DROP TABLE t1;

CREATE TABLE t1 (
    id    CHAR(4),
    song  VARCHAR2(64)
);

CREATE OR REPLACE PROCEDURE filltab_c(
    p_rows NUMBER DEFAULT 10000
) AS
    TYPE list_of_songs_t IS
        TABLE OF VARCHAR2(64);
    songs list_of_songs_t := list_of_songs_t();
BEGIN
    songs.extend(10);
    songs(1) := 'A Song For You';
    songs(2) := 'Close to You';
    songs(3) := 'Top Of The World';
    songs(4) := 'Touch Me When We''re Dancing';
    songs(5) := 'Yesterday Once More';
    songs(6) := 'I''ll Never Fall In Love Again';
    songs(7) := 'I Won''t Last A Day Without You';
    songs(8) := 'Rainy Days And Mondays';
    songs(9) := 'All You Get From Love Is A Love Song';
    songs(10) := 'The End Of The World';

    FOR i IN 1..p_rows LOOP
        INSERT INTO t1 VALUES (
            dbms_random.string('p', 4),
            songs(floor(dbms_random.value(1, 11)))
        );

        IF MOD(i, 1000) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
END;
/

