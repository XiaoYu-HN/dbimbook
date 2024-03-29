sqlplus -S /nolog <<'EOF'

@../userlogin.sql

COL pool FOR a10
COL populate_status FORMAT a16

SELECT inst_id, pool, round(alloc_bytes/1024) as "ALLOC(KB)", round(used_bytes/1024) as "USED(KB)", populate_status, con_id FROM gv$inmemory_area;

EOF
