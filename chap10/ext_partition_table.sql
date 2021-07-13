DROP DIRECTORY default_dir;

CREATE DIRECTORY default_dir AS '/home/oracle/dbimbook/chap10';

DROP TABLE test_ext_partition;

CREATE TABLE test_ext_partition (
    id  NUMBER,
    t   DATE
)
ORGANIZATION EXTERNAL(
TYPE ORACLE_LOADER
DEFAULT DIRECTORY default_dir
)
PARTITION BY RANGE (t) 
(
PARTITION p2020 VALUES LESS THAN (TO_DATE('01-Jan-2021','dd-MON-yyyy')) LOCATION ('2020.csv'),
PARTITION p2021 VALUES LESS THAN (TO_DATE('01-Jan-2022','dd-MON-yyyy')) LOCATION ('2021.csv')
);

INSERT INTO test_ext_partition VALUES (
    10000,
    TO_DATE('01-Feb-2021', 'dd-MON-yyyy')
);

SET lines 200
SET pages 9999
COL partition_name FOR a14
COL high_value FOR a23
COL table_name FOR a20
COL type_name FOR a20
COL default_directory_name FOR a30

SELECT table_name, partition_name, partition_position, high_value FROM user_tab_partitions;

SELECT external, hybrid FROM user_tables WHERE table_name = 'TEST_EXT_PARTITION';

SELECT table_name, type_name, default_directory_name FROM all_xternal_part_tables;

