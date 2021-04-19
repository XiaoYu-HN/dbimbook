@../userlogin
set echo on
alter table lineorder no inmemory;
set pages 999
set lines 180
set timing on
select lo_shipmode, sum(lo_quantity) from lineorder group by lo_shipmode;
set timing off
@../showplan
@../imstats

@../userlogin
set echo on
alter table lineorder inmemory;
exec popwait('SSB', 'LINEORDER', 120);
set timing on
select lo_shipmode, sum(lo_quantity) from lineorder group by lo_shipmode;
set timing off
@../showplan
@../imstats

exit
