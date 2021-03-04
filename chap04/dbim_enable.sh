# make sure your OS RAM >= 5GB
sqlplus -S / as sysdba <<-EOF

ALTER system SET sga_target = 3000M SCOPE = SPFILE ;
ALTER system SET sga_max_size = 3000M SCOPE = SPFILE ;
ALTER system SET inmemory_size = 2000M SCOPE = SPFILE ;

SHUTDOWN IMMEDIATE

STARTUP

EOF
