#!/bin/bash
# this script display row count of SSB tables

sqlplus -S / as sysdba <<-EOF

ALTER SESSION SET CONTAINER = orclpdb1;
ALTER SESSION SET CURRENT_SCHEMA = ssb;

col table_name for a20;
col count format 999,999,999,999;

select
   table_name,
   to_number(
   extractvalue(
      xmltype(
         dbms_xmlgen.getxml('select count(*) c from '||table_name))
    ,'/ROWSET/ROW/C')) count
from 
   all_tables
where owner = 'SSB'
order by 
   table_name;

EOF
