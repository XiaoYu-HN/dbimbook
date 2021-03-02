
@../userlogin.sql


DECLARE 
	n number;
	dmlstr varchar2(100);
	popresult number;
	ratio number;
BEGIN
	FOR i IN 1..2
	LOOP

		EXECUTE IMMEDIATE 'ALTER TABLE lineorder NO INMEMORY';
		EXECUTE IMMEDIATE 'ALTER TABLE lineorder INMEMORY MEMCOMPRESS FOR QUERY LOW';

		n := dbms_utility.get_time;

		SELECT DBMS_INMEMORY_ADMIN.POPULATE_WAIT(PRIORITY=>'NONE') into popresult FROM DUAL;

		n := (dbms_utility.get_time - n)/100;


		SELECT
			round(bytes / inmemory_size, 2) into ratio 
		FROM
			v$im_segments;

		insert into t1 values(n, ratio);
		commit;

		dbms_output.put_line('pop time is:' || n);
		dbms_output.put_line('ratio is:' || ratio);

	END LOOP;
END;
/

EXIT;

