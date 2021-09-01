-- basic comparision
ALTER TABLE lineorder INMEMORY;
ALTER TABLE customer INMEMORY;
exec popwait('SSB', 'LINEORDER');
exec popwait('SSB', 'CUSTOMER');

@../userlogin.sql

ALTER SESSION SET inmemory_deep_vectorization = FALSE;

set timing on

SELECT /*+ NO_VECTOR_TRANSFORM */ COUNT(*)
FROM
    customer,
    lineorder
WHERE
        c_custkey = lo_custkey
AND c_nation = 'FRANCE';

set timing off

@../showplan
@../imstats

ALTER SESSION SET inmemory_deep_vectorization = TRUE;

set timing on

SELECT /*+ NO_VECTOR_TRANSFORM */ COUNT(*)
FROM
    customer,
    lineorder
WHERE
        c_custkey = lo_custkey
AND c_nation = 'FRANCE';

set timing off

@../showplan
@../imstats

-- advanced comparison (with join group)
ALTER TABLE lineorder NO INMEMORY;
ALTER TABLE customer NO INMEMORY;
CREATE INMEMORY JOIN GROUP jg1 (lineorder(lo_custkey), customer(c_custkey));
ALTER TABLE lineorder INMEMORY;
ALTER TABLE customer INMEMORY;
exec popwait('SSB', 'LINEORDER');
exec popwait('SSB', 'CUSTOMER');

@../userlogin.sql

ALTER SESSION SET inmemory_deep_vectorization = FALSE;

set timing on

SELECT /*+ NO_VECTOR_TRANSFORM */ COUNT(*)
FROM
    customer,
    lineorder
WHERE
        c_custkey = lo_custkey
AND c_nation = 'FRANCE';

set timing off

@../showplan
@../imstats

ALTER SESSION SET inmemory_deep_vectorization = TRUE;

set timing on

SELECT /*+ NO_VECTOR_TRANSFORM */ COUNT(*)
FROM
    customer,
    lineorder
WHERE
        c_custkey = lo_custkey
AND c_nation = 'FRANCE';

set timing off

@../showplan
@../imstats

DROP INMEMORY JOIN GROUP jg1;
