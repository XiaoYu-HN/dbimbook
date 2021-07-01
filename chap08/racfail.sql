SET LINES 120
SET PAGES 9999
COL segment_name FOR a12

SELECT
    inst_id,
    segment_name,
    inmemory_size / 1024 / 1024      im_mb,
    bytes / 1024 / 1024              disk_mb,
    bytes_not_populated,
    populate_status              AS pop_status
FROM
    gv$im_segments;

SELECT
    inst_id,
    COUNT(inst_id)
FROM
    gv$im_header
WHERE
    is_head_piece = 1
GROUP BY
    inst_id;
    
SELECT
    inst_id,
    imcu_addr,
    num_rows,
    to_char(timestamp, 'HH24:MI:SS') AS timestamp
FROM
    gv$im_header
WHERE
    is_head_piece = 1
ORDER BY
    initial_timestamp;
