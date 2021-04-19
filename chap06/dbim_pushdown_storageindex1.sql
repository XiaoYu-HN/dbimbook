@../userlogin
set echo on
alter table lineorder no inmemory;
set pages 999
set lines 180
set timing on
select count(*) from lineorder where lo_orderkey < 1000000;
set timing off
@../showplan
@../imstats

@../userlogin
set echo on
alter table lineorder inmemory;
alter table lineorder inmemory no memcompress(lo_orderkey);
exec popwait('SSB', 'LINEORDER', 120);
set timing on
select count(*) from lineorder where lo_orderkey < 1000000;
set timing off
@../showplan
@../imstats

exit
