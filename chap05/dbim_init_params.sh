sql -S / as sysdba <<-EOF
	set pages 999
	show parameter inmem
	exit;
EOF
