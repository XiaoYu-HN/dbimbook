SET PAGES 9999
SET LINES 250

select * from table(dbms_xplan.display_cursor);
