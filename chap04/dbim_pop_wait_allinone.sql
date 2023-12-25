-- foreground populate all in-memory tables
-- calculate the population time
-- show IMCU distribution

SET TIMING ON

VARIABLE pop_status NUMBER

BEGIN
    SELECT
        dbms_inmemory_admin.populate_wait(priority => 'NONE', percentage => 100)
    INTO :pop_status
    FROM
        dual;

END;
/

PRINT pop_status

SET TIMING OFF


set lines 120
col start_pop_time for a40
col finish_pop_time for a40
col time_taken for a30

SELECT
    MIN(timestamp) as start_pop_time,
    MAX(timestamp) as finish_pop_time,
    MAX(timestamp) - MIN(timestamp) time_taken
FROM
    gv$im_header;


select sum(TIME_TO_POPULATE)/1000/60/24/2 as pop_minutes from GV$IM_HEADER;

col object_name for a16
set pages 9999
SELECT
    object_name,
    SUM(time_to_populate)
FROM
    gv$im_header imh, user_objects uobj
WHERE
    imh.table_objn = uobj.object_id and
    imh.is_head_piece = 1
GROUP BY
    object_name;

select inst_id, sum(num_disk_extents), sum(num_rows), sum(num_blocks), sum(time_to_populate) from gv$im_header
    where table_objn in (select object_id from dba_objects where object_name = 'LINEORDER') and num_rows != 0 group by inst_id;
