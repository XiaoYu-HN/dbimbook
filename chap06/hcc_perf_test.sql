select bytes from user_segments where segment_name = 'LINEORDER';

create table  t1 nologging as select * from lineorder;
create table  t2 nologging as select * from lineorder;
create table  t3 nologging as select * from lineorder;
create table  t4 nologging as select * from lineorder;

set timing on
alter table t1 move compress for query low;
alter table t2 move compress for query high;
alter table t3 move compress for archive low;
alter table t4 move compress for archive high;

select segment_name, 1409286144/bytes from user_segments where segment_name in ('T1', 'T2', 'T3', 'T4');

set serveroutput on size unlimited
alter system flush buffer_cache
/
col value noprint new_value start_cpu
select value
from v$sesstat s, v$statname n
where sid = SYS_CONTEXT('USERENV','SID')
and s.statistic# = n.statistic#
and n.name in ('CPU used by this session')
/
col value noprint new_value start_reads
select value
from v$sesstat s, v$statname n
where sid = SYS_CONTEXT('USERENV','SID')
and s.statistic# = n.statistic#
and n.name in ('session logical reads')
/
set autot on explain stat
set timing on

select
  lo_shipmode,
  sum(lo_ordtotalprice)
from
  t4
group by
  lo_shipmode;
 /
--
-- Repeat the test by replacing the tablename above with 
-- the other compressed table names
--
set autot off
select value - &start_cpu cpu_consumed
from v$sesstat s, v$statname n
where sid = SYS_CONTEXT('USERENV','SID')
and s.statistic# = n.statistic#
and n.name in ('CPU used by this session')
/
select value - &start_reads logical_reads
from v$sesstat s, v$statname n
where sid = SYS_CONTEXT('USERENV','SID')
and s.statistic# = n.statistic#
and n.name in ('session logical reads')
/
