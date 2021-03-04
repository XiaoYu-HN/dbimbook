sqlplus -S / as sysdba <<-EOF
	show parameter sga_target
	show parameter sga_max_size
	show parameter inmemory_size
EOF
