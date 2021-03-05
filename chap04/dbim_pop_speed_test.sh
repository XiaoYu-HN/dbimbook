for i in {1..10}; do
CPU_COUNT=8
for i in $(seq 1 $CPU_COUNT ); do
	echo "# pop_processes: $i"
	sqlplus -S / as sysdba <<-EOF
		alter system set INMEMORY_MAX_POPULATE_SERVERS = $i;
		@../userlogin.sql
		!./dbim_alter_table_off.sh > /dev/null
		!./dbim_alter_table_on.sh > /dev/null
		@dbim_pop_wait_simple.sql
		!./dbim_alter_table_off.sh > /dev/null
	EOF
done
done
