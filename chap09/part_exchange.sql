DROP TABLE p_supplier PURGE;
DROP TABLE tmp_supplier PURGE;

COL table_name FOR A20
COL partition_name FOR A20
COL segment_name FOR A16
CREATE TABLE p_supplier PARTITION BY RANGE (pkey) INTERVAL(1)
  (PARTITION p1 VALUES LESS THAN(1) ) AS SELECT 1 AS pkey, supplier.* FROM supplier;

INSERT INTO p_supplier SELECT 2, supplier.* FROM supplier;

EXEC dbms_stats.gather_table_stats('','P_SUPPLIER')
SELECT table_name, partition_name, inmemory, num_rows FROM user_tab_partitions WHERE table_name = 'P_SUPPLIER';

ALTER TABLE p_supplier INMEMORY;
SELECT /*+ FULL(s) NO_PARALLEL(s) */ COUNT(*) FROM p_supplier s;
SELECT segment_name, partition_name, inmemory_size, bytes, populate_status FROM v$im_segments;

CREATE TABLE tmp_supplier FOR EXCHANGE WITH TABLE p_supplier;
INSERT INTO tmp_supplier SELECT 0 AS key_no, supplier.* FROM supplier;
ALTER TABLE tmp_supplier INMEMORY;
SELECT /*+ FULL(s) NO_PARALLEL(s) */ COUNT(*) FROM tmp_supplier s;

SELECT segment_name, partition_name, inmemory_size, BYTES, populate_status FROM v$im_segments;

SELECT COUNT(*) FROM p_supplier PARTITION(p1);
ALTER TABLE p_supplier MODIFY PARTITION p1 NO INMEMORY;
ALTER TABLE p_supplier EXCHANGE PARTITION p1 WITH TABLE tmp_supplier;
SELECT COUNT(*) FROM p_supplier PARTITION(p1);
SELECT COUNT(*) FROM tmp_supplier;

SELECT segment_name, partition_name, inmemory_size, BYTES, populate_status FROM v$im_segments;

SELECT INMEMORY FROM user_tables WHERE table_name = 'TMP_SUPPLIER';

