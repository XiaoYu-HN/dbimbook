sqlplus -S /nolog << 'EOF'

@../userlogin.sql

col segment_name for a16
col partition_name for a16
set lines 100

SELECT
    segment_name,
    partition_name,
    segment_type,
    inmemory,
    inmemory_priority,
    inmemory_compression
FROM
    user_segments
WHERE
    segment_name IN ( 'CUSTOMER', 'DATE_DIM', 'LINEORDER', 'PART', 'SUPPLIER' );

EOF
