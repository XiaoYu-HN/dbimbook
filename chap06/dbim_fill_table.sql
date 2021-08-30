
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

ALTER TABLE t1 ADD PRIMARY KEY(id);

COL TABLE_NAME FOR A16
COL SEGMENT_NAME FOR A16
COL INDEX_NAME FOR A20

SELECT table_name, compression, compress_for FROM user_tables WHERE table_name IN ('T1');

CREATE TABLE t1_tmp ROW STORE COMPRESS ADVANCED AS SELECT * FROM t1 WHERE 1=2;

EXEC dbms_redefinition.can_redef_table('ssb', 't1');

EXEC dbms_redefinition.start_redef_table('ssb', 't1', 't1_tmp');

DECLARE
  num_errs PLS_INTEGER;
BEGIN
	dbms_redefinition.COPY_TABLE_DEPENDENTS('ssb', 't1', 't1_tmp',
	dbms_redefinition.cons_orig_params,TRUE, TRUE, TRUE, TRUE, num_errs);
END;
/


EXEC dbms_redefinition.sync_interim_table('ssb', 't1', 't1_tmp');

EXEC dbms_redefinition.finish_redef_table('ssb', 't1', 't1_tmp');

SELECT segment_name, BYTES FROM user_segments WHERE segment_name IN ('T1', 'T1_TMP');

SELECT table_name, compression, compress_for FROM user_tables WHERE table_name IN ('T1', 'T1_TMP');

SELECT index_name, table_name, uniqueness FROM user_indexes WHERE table_name IN ('T1', 'T1_TMP');

DROP TABLE t1_tmp;
DROP TABLE t1;
