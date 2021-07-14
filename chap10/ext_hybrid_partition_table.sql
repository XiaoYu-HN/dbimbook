DROP DIRECTORY default_dir;

CREATE DIRECTORY default_dir AS '/tmp';

DROP TABLE test_hypt_part;
CREATE TABLE test_hypt_part (
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
) INMEMORY;

INSERT INTO test_hypt_part VALUES (
    10000,
    TO_DATE('01-Jan-2028', 'dd-MON-yyyy')
);

UPDATE test_hypt_part
SET
    t = TO_DATE('01-Jan-2029', 'dd-MON-yyyy')
WHERE
    id = 10000;

SET lines 200
SET pages 9999
COL partition_name FOR a14
COL high_value FOR a23
COL table_name FOR a20
COL type_name FOR a20
COL default_directory_name FOR a30
SET ECHO ON

SELECT table_name, partition_name, partition_position, high_value FROM user_tab_partitions;

SELECT external, hybrid FROM user_tables WHERE table_name = 'TEST_HYPT_PART';

SELECT table_name, type_name, default_directory_name FROM all_xternal_part_tables;

