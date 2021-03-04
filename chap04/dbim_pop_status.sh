sqlplus -S /nolog << 'EOF'

@../userlogin.sql

COL owner FORMAT A10
COL segment_name FORMAT A12
COL populate_status FORMAT A15
COL "IN_MEM_SIZE(KB)" FORMAT 999,999,999,999
COL "ON_DISK_SIZE(KB)" FORMAT 999,999,999,999
SET LINESIZE 160

SELECT
    owner,
    segment_name,
    inmemory_size / 1024                 AS "IN_MEM_SIZE(KB)",
    bytes / 1024                         AS "ON_DISK_SIZE(KB)",
    round(bytes / inmemory_size, 2)      AS "COMPRESSION_RATIO",
    round((bytes - bytes_not_populated) / bytes, 2) * 100  AS "POPULATED%",
    populate_status
FROM
    v$im_segments;

EOF
