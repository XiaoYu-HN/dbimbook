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
