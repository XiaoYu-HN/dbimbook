drop table t1;
drop table t2;

create table t1 (x, y)
partition by range (x)
(
partition P1 values less than (2500),
partition P2 values less than (5000),
partition P3 values less than (7500),
partition P4 values less than (10000)
)
as
select rownum, rownum from dual connect by level < 10000;

create table t2 (x, y)
partition by range (x)
(
partition P1 values less than (5000),
partition P2 values less than (10000),
partition P3 values less than (15000),
partition P4 values less than (20000)
)
as
select rownum, rownum from dual connect by level < 20000;


exec dbms_stats.gather_table_stats('','t1');
exec dbms_stats.gather_table_stats('','t2');

select count(*) from t1,t2
where t1.x = t2.x;

set lines 120
set pages 9999
select * from table(dbms_xplan.display_cursor);
