# make sure your OS RAM >= 5GB
sqlplus -S / as sysdba <<-EOF

ALTER system SET sga_target = 6000M SCOPE = SPFILE ;
ALTER system SET sga_max_size = 6000M SCOPE = SPFILE ;
ALTER system SET inmemory_size = 4000M SCOPE = SPFILE ;

SHUTDOWN IMMEDIATE

STARTUP

EOF
