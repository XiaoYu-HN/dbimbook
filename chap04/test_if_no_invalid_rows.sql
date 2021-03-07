set serveroutput on

declare
	n number;
	t1 varchar(16);
	t2 varchar(16);
begin
	select to_char(sysdate, 'hh:mi:ss') into t1 from dual;
	loop
		select sum(invalid_rows) into n from V$IM_SMU_HEAD;
		exit when n=0;
	end loop;
	select to_char(sysdate, 'hh:mi:ss') into t2 from dual;

	dbms_output.put_line(t1 || ' ' || t2);
end;
/
