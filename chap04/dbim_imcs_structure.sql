set echo on
select count(*) from lineorder;

col segment_name for a16
set lines 100
set pages 999

select segment_name, bytes, blocks, extents, initial_extent/1024 as "EXTENT(KB)", next_extent/1024 as "N_EXTENT(KB)" from user_segments where segment_name = 'LINEORDER';

/*
alter table lineorder no inmemory;
alter table lineorder inmemory;
select dbms_inmemory_admin.populate_wait(priority => 'NONE') from dual;
*/


