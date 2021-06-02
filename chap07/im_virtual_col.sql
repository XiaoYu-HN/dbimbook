alter table lineorder no inmemory;
alter table lineorder drop column vcol01;

set numformat 999,999,999,999,999
set echo on

set timing on
select lo_orderpriority, sum(lo_extendedprice * (1 - lo_discount/100)) as discount_price from lineorder group by lo_orderpriority order by lo_orderpriority;
set timing off

alter table lineorder inmemory;

exec popwait('SSB', 'LINEORDER');

set timing on
select lo_orderpriority, sum(lo_extendedprice * (1 - lo_discount/100)) as discount_price from lineorder group by lo_orderpriority order by lo_orderpriority;
set timing off

@../imstats

alter system set inmemory_virtual_columns='ENABLE';
alter table lineorder add vcol01 as (lo_extendedprice * (1 - lo_discount/100));
alter table lineorder no inmemory;
alter table lineorder inmemory;

exec popwait('SSB', 'LINEORDER');

set timing on
select lo_orderpriority, sum(lo_extendedprice * (1 - lo_discount/100)) as discount_price from lineorder group by lo_orderpriority order by lo_orderpriority;
set timing off

@../imstats
