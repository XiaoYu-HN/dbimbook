@../userlogin
set echo on
alter table lineorder no inmemory;
set pages 999
set lines 180
set timing on
select lo_shipmode, sum(lo_quantity) from lineorder where lo_shipmode not in ('SHIP', 'FOB') group by lo_shipmode order by 2;
set timing off
@../showplan
@../imstats

@../userlogin
set echo on
alter table lineorder inmemory;
exec popwait('SSB', 'LINEORDER', 120);
set timing on
select lo_shipmode, sum(lo_quantity) from lineorder where lo_shipmode not in ('SHIP', 'FOB') group by lo_shipmode order by 2;
set timing off
@../showplan
@../imstats

select count(*) as NUMBER_OF_IMCUs from v$im_header where is_head_piece = 1
	and table_objn in (select object_id from user_objects where object_name = 'LINEORDER');

select count(*) from lineorder where lo_shipmode not in ('FOB', 'SHIP');

exit
