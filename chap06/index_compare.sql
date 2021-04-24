alter table lineorder inmemory;
exec popwait('SSB', 'LINEORDER');

prompt IMCS vs Index Test 1
prompt ___________________
set timing on
select sum(lo_quantity) from lineorder where lo_orderkey = 1;
set timing off
@../xplan

create index idx1 on lineorder(lo_orderkey);
set timing on
select sum(lo_quantity) from lineorder where lo_orderkey = 1;
set timing off
@../xplan
drop index idx1;


prompt IMCS vs Index Test 2
prompt ___________________
set timing on
select count(*) from lineorder where lo_orderpriority like '%LOW%';
set timing off
@../xplan

create index idx1 on lineorder(lo_orderpriority);
set timing on
select /*+ NO_INMEMORY */ count(*) from lineorder where lo_orderpriority like '%LOW%';
set timing off
@../xplan
drop index idx1;

set timing on
select /*+ NO_INMEMORY */ count(*) from lineorder where lo_orderpriority like '%LOW%';
set timing off
@../xplan

