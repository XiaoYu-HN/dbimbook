sqlplus -S /nolog <<'EOF'

@../userlogin.sql

col segment_name for a16
col partition_name for a16
column inmemory_compression heading 'INMEMORY|COMPRESSION' format a18;
column inmemory_priority heading 'INMEMORY|PRIORITY' format a10;
set lines 100

SELECT
    segment_name,
--    partition_name,
    segment_type,
    inmemory,
    inmemory_priority,
    inmemory_compression
FROM
    dba_segments
WHERE
    segment_name IN ( 'CUSTOMER', 'DATE_DIM', 'LINEORDER', 'PART', 'SUPPLIER', 'T2' );
    --segment_name IN ( 'CUSTOMER', 'DATE_DIM', 'LINEORDER', 'PART', 'SUPPLIER' );

EOF
