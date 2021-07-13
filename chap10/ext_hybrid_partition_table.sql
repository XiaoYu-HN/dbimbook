DROP DIRECTORY default_dir;

CREATE DIRECTORY default_dir AS '/home/oracle/dbimbook/chap10';

DROP TABLE test_hypt_partition;
CREATE TABLE test_hypt_partition (
    id  NUMBER,
    t   DATE
)
EXTERNAL PARTITION ATTRIBUTES(
TYPE ORACLE_LOADER
DEFAULT DIRECTORY default_dir
)
PARTITION BY RANGE (t) 
(
PARTITION p2020 VALUES LESS THAN (TO_DATE('01-Jan-2021','dd-MON-yyyy')) EXTERNAL LOCATION ('2020.csv'),
PARTITION p2021 VALUES LESS THAN (TO_DATE('01-Jan-2022','dd-MON-yyyy')) EXTERNAL LOCATION ('2021.csv'),
PARTITION pmax VALUES LESS THAN (MAXVALUE) 
);

INSERT INTO test_hypt_partition VALUES (
    10000,
    TO_DATE('01-Jan-2028', 'dd-MON-yyyy')
);

UPDATE test_hypt_partition
SET
    t = TO_DATE('01-Jan-2029', 'dd-MON-yyyy')
WHERE
    id = 10000;

SET lines 200
COL partition_name FOR a14
COL tablespace_name FOR a15
COL table_name FOR a20
SELECT table_name, partition_name, high_value, tablespace_name, read_only FROM user_tab_partitions;
