sqlplus -S /nolog <<'EOF'

@../userlogin.sql

col segment_name for a16
col partition_name for a16
column inmemory_compression heading 'INMEMORY|COMPRESSION' format a18;
column inmemory_priority heading 'INMEMORY|PRIORITY' format a10;
column inmemory_duplicate heading 'INMEMORY|DUPLICATE' format a16;
column inmemory_distribute heading 'INMEMORY|DISTRIBUTE' format a16;
set lines 140

SELECT
    segment_name,
    segment_type,
    inmemory_priority,
    inmemory_compression,
    inmemory_duplicate,
    inmemory_distribute
FROM
    dba_segments
WHERE
    inmemory='ENABLED';    

EOF
