sqlplus -S /nolog << 'EOF'

@../userlogin.sql

COL segment_name FORMAT A12
COL populate_status FORMAT A20

SELECT
    segment_name,
    bytes_not_populated,
    populate_status
FROM
    v$im_segments;

EOF
