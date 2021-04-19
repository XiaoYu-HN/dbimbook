@../userlogin
set echo on
alter table lineorder no inmemory;
set pages 999
set lines 180
SET TERMOUT OFF
set timing on
select * from lineorder where lo_shipmode = 'RAIL' and lo_quantity > 20;
set timing off
SET TERMOUT ON
@../showplan
@../imstats

@../userlogin
set echo on
alter table lineorder inmemory;
exec popwait('SSB', 'LINEORDER', 120);
SET TERMOUT OFF
set timing on
select * from lineorder where lo_shipmode = 'RAIL' and lo_quantity > 20;
set timing off
SET TERMOUT ON
@../showplan
@../imstats

exit
