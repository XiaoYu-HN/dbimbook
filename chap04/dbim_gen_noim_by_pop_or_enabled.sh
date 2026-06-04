sqlplus -S /nolog <<'EOF'

@../userlogin.sql

Rem SET FEEDBACK OFF
SET PAGES 9999

PROMPT ALTER ... NO INMEMPRY CLAUSE based on populated inmemory segments ...

SELECT
    'ALTER TABLE '
    || owner
    || '.'
    || segment_name
    || ' NO INMEMORY;'
FROM
    v$im_segments;

PROMPT ALTER ... NO INMEMPRY CLAUSE based on segments withe inmemory enabled ...
SELECT
    'ALTER TABLE '
    || owner
    || '.'
    || segment_name
    || ' NO INMEMORY;'
FROM
    dba_segments
WHERE
    inmemory='ENABLED';  

EOF
