DROP TABLE iot_read PURGE;

CREATE TABLE iot_read (
    id     NUMBER PRIMARY KEY,
    value  CHAR(8)
)
SEGMENT CREATION IMMEDIATE
MEMOPTIMIZE FOR READ;

BEGIN
    FOR i IN 1..1000000 LOOP
        INSERT INTO iot_read VALUES (
            i,
            dbms_random.string('L', 4)
        );

        IF MOD(i, 5000) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;

    COMMIT;
END;
/

EXEC dbms_stats.gather_table_stats(ownname=>NULL, tabname=>'IOT_READ');

SELECT
    n.name,
    s.value
FROM
    v$sysstat   s,
    v$statname  n
WHERE
        n.statistic# = s.statistic#
    AND n.name LIKE 'memopt r%' AND s.value != 0;

SELECT
    t1.name,
    t2.value
FROM
    v$sysstat  t1,
    v$mystat   t2
WHERE
        t1.statistic# = t2.statistic#
    AND t2.value != 0
    AND t1.name LIKE 'memopt%';
  
exec dbms_memoptimize.populate('SSB', 'IOT_READ_BAK');

col memoptimize_read for a25
col memoptimize_write for a25
SELECT memoptimize_read,  memoptimize_write FROM user_tables WHERE table_name = 'IOT_READ';
desc user_tables


SELECT bytes, blocks FROM user_segments WHERE segment_name = 'IOT_READ';

select * from v$sga_dynamic_components where COMPONENT like 'memopt%';
