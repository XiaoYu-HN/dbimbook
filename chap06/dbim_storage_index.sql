drop table t1;

create table t1 as select rownum-1 k, mod(rownum, 1000000) v from dual connect by level <= 2000000;
exec dbms_stats.gather_table_stats('','T1');

-- should be 2000000/10000
select count(*) from t1 where v = 100;

-- alter inmemory and populate
alter table t1 inmemory;
select /*+ FULL(p) NO_PARALLEL(p) */ count(*) from t1 p;
-- EXEC DBMS_INMEMORY.POPULATE('SSB', 'T1');

select inmemory_size, bytes from v$im_segments where segment_name = 'T1';

-- display storage index in each IMCU
select HEAD_PIECE_ADDRESS as IMCU, COLUMN_NUMBER, utl_raw.cast_to_number(MINIMUM_VALUE) min, utl_raw.cast_to_number(MAXIMUM_VALUE) max
from v$im_col_cu 
where objd in (select objd from v$im_header where table_objn in (select object_id from user_objects where object_name = 'T1'))
and column_number = 2
order by 2,1;

-- verify storage index is used
set autotrace on
select count(*) from t1 where v >= 900000;

select count(*) from t1 where v = 800000;
set autotrace off

-- add attribute clustering will not evict the table from IMCS
alter table t1 add clustering by linear order (v) without materialized zonemap;
-- but alter move will evict the table from IMCS
alter table t1 move;

-- populate table
SELECT /*+ FULL(p) NO_PARALLEL(p) */ COUNT(*) FROM t1 p;

select HEAD_PIECE_ADDRESS as IMCU, COLUMN_NUMBER, utl_raw.cast_to_number(MINIMUM_VALUE) min, utl_raw.cast_to_number(MAXIMUM_VALUE) max
from v$im_col_cu 
where objd in (select objd from v$im_header where table_objn in (select object_id from user_objects where object_name = 'T1'))
and column_number = 2
order by 2,1;

set autotrace on
select count(*) from t1 where v = 800000;
