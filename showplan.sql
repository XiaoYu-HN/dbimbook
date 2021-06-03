set lines 200
select * from table(dbms_xplan.display_cursor());
