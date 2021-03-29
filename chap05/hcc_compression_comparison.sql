-- execute this script as below
-- sqlplus /nolog <this_sql>
@../userlogin

create table t1 as select * from lineorder;
set serveroutput on

declare
	bytes_uncomp number;
	bytes_comp number;
	type array_t is varray(6) of varchar2(64);
	array array_t := array_t(
		'compress for query low',
		'compress for query high',
		'compress for archive low',
		'compress for archive high',
		'row store compress advanced',
		'row store compress basic'
	);
begin
	select sum(bytes) into bytes_uncomp from user_segments where segment_name = 'T1';

	for i in 1..array.count loop
		execute immediate 'alter table t1 move ' || array(i);	
		select sum(bytes) into bytes_comp from user_segments where segment_name = 'T1';
		dbms_output.put_line('Compression ratio for ' || array(i) || ' is:' || round(bytes_uncomp/bytes_comp, 2));
   	end loop;
	
end;
/

drop table t1;
exit;
