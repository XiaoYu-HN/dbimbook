@../userlogin
set echo on
alter table lineorder no inmemory;
set pages 999
set lines 180
set timing on
set termout off
select * from lineorder where lo_partkey=53439;
set termout on
set timing off
@../showplan
@../imstats

@../userlogin
set echo on
alter table lineorder inmemory;
exec popwait('SSB', 'LINEORDER', 120);
set timing on
set termout off
select * from lineorder where lo_partkey=53439;
set termout on
set timing off
@../showplan
@../imstats

exit
