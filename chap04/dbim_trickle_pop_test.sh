sqlplus -S /nolog <<'EOF'

	@../userlogin.sql

	DROP TABLE t1;

	CREATE TABLE t1
	INMEMORY
	    AS
		SELECT
		    level       AS id,
		    'AAAAAAAA'  AS value
		FROM
		    dual
		CONNECT BY 1 = 1
			   AND level <= 1000000;

	select dbms_inmemory_admin.populate_wait(priority => 'NONE') from dual;

	update t1 set value = 'BBBBBBBB' where rownum <= 150000;
	commit;

	set lines 120
	set pages 999
	
	SELECT
	    total_rows,
	    invalid_rows,
	    invalid_blocks,
	    prepopulated,
	    repopulated,
	    trickle_repopulated
	FROM
	    v$im_smu_head  a,
	    v$im_header    b
	WHERE
		a.objd = b.objd
	    AND a.total_rows = b.num_rows;		

	select count(*) from t1 where value in ('A', 'B');

	select * from table(dbms_xplan.display_cursor());

 	@../imstats.sql	
	
	@test_if_no_invalid_rows.sql
	
	SELECT
	    total_rows,
	    invalid_rows,
	    invalid_blocks,
	    prepopulated,
	    repopulated,
	    trickle_repopulated
	FROM
	    v$im_smu_head  a,
	    v$im_header    b
	WHERE
		a.objd = b.objd
	    AND a.total_rows = b.num_rows;		
EOF
