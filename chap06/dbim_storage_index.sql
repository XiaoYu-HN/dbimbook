@../userlogin

set echo on

drop table t1;

create table t1 as select rownum-1 k, mod(rownum, 1000000) v from dual connect by level <= 2000000;
exec dbms_stats.gather_table_stats('','T1');

-- should be 2000000/10000
select count(*) from t1 where v = 100;

-- alter inmemory and populate
alter table t1 inmemory;
exec popwait('SSB', 'T1', 120);

select inmemory_size, bytes from v$im_segments where segment_name = 'T1';

-- display storage index in each IMCU
select HEAD_PIECE_ADDRESS as IMCU, COLUMN_NUMBER, utl_raw.cast_to_number(MINIMUM_VALUE) min, utl_raw.cast_to_number(MAXIMUM_VALUE) max
from v$im_col_cu 
where objd in (select objd from v$im_header where table_objn in (select object_id from user_objects where object_name = 'T1'))
and column_number = 2
order by 2,1;

-- verify storage index is used
select count(*) from t1 where v >= 900000;
@../imstats.sql

@../userlogin
set echo on
select count(*) from t1 where v = 800000;
@../imstats.sql

-- add attribute clustering will not evict the table from IMCS
alter table t1 add clustering by linear order (v) without materialized zonemap;
-- but alter move will evict the table from IMCS
alter table t1 move;

-- populate table
exec popwait('SSB', 'T1', 120);

select HEAD_PIECE_ADDRESS as IMCU, COLUMN_NUMBER, utl_raw.cast_to_number(MINIMUM_VALUE) min, utl_raw.cast_to_number(MAXIMUM_VALUE) max
from v$im_col_cu 
where objd in (select objd from v$im_header where table_objn in (select object_id from user_objects where object_name = 'T1'))
and column_number = 2
order by 2,1;

@../userlogin
select count(*) from t1 where v = 800000;
@../imstats.sql
