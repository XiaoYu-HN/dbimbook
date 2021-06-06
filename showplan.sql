set lines 200
set pages 9999
select * from table(dbms_xplan.display_cursor());
