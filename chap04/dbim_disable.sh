sqlplus -S / as sysdba <<-EOF

ALTER SYSTEM SET inmemory_size = 0 SCOPE = SPFILE;

SHUTDOWN IMMEDIATE

STARTUP

EOF
