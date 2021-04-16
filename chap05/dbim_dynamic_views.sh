sqlplus / as sysdba <<'EOF'
	alter session set container=orclpdb1;
	set pages 9999
	select object_name from dba_objects where regexp_like(object_name, '^V\$IM|^V\$INMEM') order by 1;
EOF
