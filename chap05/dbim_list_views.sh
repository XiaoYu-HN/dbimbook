sqlplus -S / as sysdba <<'EOF'
-- select object_name from dba_objects where regexp_like(object_name, '^V\$IM|^V\$INMEM') order by 1;
set pages 999

SELECT
    object_name
FROM
    dba_objects
WHERE
    REGEXP_LIKE ( object_name,
                  '^V\$IM|^V\$INMEM' )
ORDER BY 1;

EOF

