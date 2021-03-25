for i in {1..100};
do
	sqlplus /nolog <<-EOF
		@../userlogin.sql
		@imadvisor_workload.sql
		exec dbms_session.sleep(1);	
	EOF
done
