sqlplus -S /nolog << 'EOF'

@../userlogin.sql

COL owner FORMAT A6
COL segment_name heading 'SEGMENT|NAME' FORMAT A16
COL populate_status heading 'POPULATED|STATUS'
COL "IN_MEM_SIZE(KB)" heading 'IN MEM|SIZE(KB)' FORMAT 999,999,999
COL "ON_DISK_SIZE(KB)" heading 'ON DISK|SIZE(KB)' FORMAT 999,999,999
COL bytes_not_populated heading 'BYTES NOT|POPULATED' 
COL compression_ratio heading 'COMPRESSION|RATIO'
SET LINESIZE 140
SET PAGES 9999

SELECT
    owner,
    segment_name,
    inmemory_size / 1024                 AS "IN_MEM_SIZE(KB)",
    bytes / 1024                         AS "ON_DISK_SIZE(KB)",
    round(bytes / inmemory_size, 2)      AS "COMPRESSION_RATIO",
    bytes_not_populated,
    populate_status
FROM
    v$im_segments;

select sum(bytes)/1024 as "TOTAL_DISK_SIZE(KB)", sum(inmemory_size)/1024 as "TOTAL_IM_SIZE(KB)",
round(sum(bytes)/sum(inmemory_size),2) as OVERALL_COMPRESSION_RATIO from v$im_segments;

EOF
