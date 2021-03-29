DROP TABLE t1;

CREATE TABLE t1 (
    id      INT,
    singer  VARCHAR(16)
);

CREATE OR REPLACE PROCEDURE filltab (
    p_rows NUMBER DEFAULT 10000
) AS
    TYPE list_of_singers_t IS
        TABLE OF VARCHAR2(16);
    singers list_of_singers_t := list_of_singers_t();
BEGIN
    singers.extend(15);
    singers(1) := 'Michael Jackson';
    singers(2) := 'Taylor Swift';
    singers(3) := 'Mariah Carey';
    singers(4) := 'Josh Turner';
    singers(5) := 'Andrea Bocelli';
    singers(6) := 'Celine Dion';
    singers(7) := 'Whitney Houston';
    singers(8) := 'Alan Walker';
    singers(9) := 'Avril Lavigne';
    singers(10) := 'Backstreet Boys';
    singers(11) := 'Air Supply';
    singers(12) := 'Roxette';
    singers(13) := 'Carpenters';
    singers(14) := 'Bob Dylan';
    singers(15) := 'Declan Galbraith';
    FOR i IN 1..p_rows LOOP
        INSERT INTO t1 VALUES (
            i,
            singers(floor(dbms_random.value(1, 16)))
        );

        IF MOD(i, 1000) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
END;
/

EXEC filltab(1000000);

/*
alter table t1 inmemory no inmemory(id);

select /*+ FULL(p) NO_PARALLEL(p) */ count(*) from t1 p;

select inmemory_size, bytes from v$im_segments where segment_name = 'T1';

*/

