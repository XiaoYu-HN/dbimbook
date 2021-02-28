sqlplus -S / as sysdba <<-EOF

ALTER SYSTEM SET inmemory_size = 1G SCOPE = SPFILE;

SHUTDOWN IMMEDIATE

STARTUP

EOF
