CREATE TABLE t1 (x, y) INMEMORY
PARTITION BY RANGE (x)
(
PARTITION p1 VALUES LESS THAN (2500),
PARTITION p2 VALUES LESS THAN (5000),
PARTITION p3 VALUES LESS THAN (7500),
PARTITION p4 VALUES LESS THAN (10000)
)
AS
SELECT ROWNUM, round(dbms_random.VALUE(1,10)) FROM dual CONNECT BY LEVEL < 10000;

CREATE TABLE t2 (x, y) INMEMORY
PARTITION BY RANGE (x)
(
PARTITION p1 VALUES LESS THAN (2500),
PARTITION p2 VALUES LESS THAN (5000),
PARTITION p3 VALUES LESS THAN (7500),
PARTITION p4 VALUES LESS THAN (10000)
)
AS
SELECT ROWNUM, round(dbms_random.VALUE(1,10)) FROM dual CONNECT BY LEVEL < 10000;

SET PAGES 9999
SET LINES 200

ALTER SESSION DISABLE PARALLEL QUERY;
EXPLAIN PLAN FOR
SELECT SUM(t1.y + t2.y) FROM t1,t2 WHERE t1.x = t2.x;
SELECT plan_table_output
FROM TABLE(dbms_xplan.display('plan_table',NULL,'all -bytes -rows'));

EXPLAIN PLAN FOR
SELECT /*+ PARALLEL(2) NO_PX_JOIN_FILTER(t1) NO_PX_JOIN_FILTER(t2) */ SUM(t1.y + t2.y) FROM t1,t2 WHERE t1.x = t2.x;
SELECT plan_table_output
FROM TABLE(dbms_xplan.display('plan_table',NULL,'all -bytes -rows'));

DROP TABLE t1 PURGE;
DROP TABLE t2 PURGE;

