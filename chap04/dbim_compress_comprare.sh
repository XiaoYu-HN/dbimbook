sqlplus -S /nolog <<'EOF'

@../userlogin.sql

ALTER TABLE lineorder NO INMEMORY;
ALTER TABLE lineorder INMEMORY MEMCOMPRESS FOR QUERY HIGH;

SET TIMING ON
SELECT DBMS_INMEMORY_ADMIN.POPULATE_WAIT(PRIORITY=>'NONE') POP_STATUS FROM DUAL;
SET TIMING OFF

SELECT
	segment_name,
    round(bytes / 1024 / 1024, 2)                  AS "ON_DISK_SIZE(MB)",
    round(inmemory_size / 1024 / 1024, 2)          AS "IN_MEM_SIZE(MB) ",
    inmemory_compression                 AS compression_level,
    round(bytes / inmemory_size, 2)      AS compression_ratio
FROM
    v$im_segments;

EOF

