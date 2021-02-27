@../userlogin.sql

COL pool FOR a10
COL populate_status FORMAT a16

SELECT
    *
FROM
    v$inmemory_area;
