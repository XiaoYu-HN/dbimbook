set pages 9999
set lines 120
col expression_text for a50

show parameter expression;

select lo_orderpriority, sum(lo_extendedprice * (1 - lo_discount/100)) as
 discount_price from lineorder group by lo_orderpriority order by lo_orderpriority;

exec dbms_stats.flush_database_monitoring_info;

select expression_text,
       fixed_cost, 
       evaluation_count, 
       snapshot 
from   user_expression_statistics 
where  table_name = 'LINEORDER' 
order by fixed_cost desc;

EXEC DBMS_INMEMORY_ADMIN.IME_CAPTURE_EXPRESSIONS('CURRENT'); 
