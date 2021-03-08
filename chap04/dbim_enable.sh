# make sure your OS RAM >= 5GB
sqlplus -S / as sysdba <<-EOF

ALTER system SET sga_target = 2500M SCOPE = SPFILE ;
ALTER system SET sga_max_size = 2500M SCOPE = SPFILE ;
ALTER system SET inmemory_size = 1500M SCOPE = SPFILE ;

SHUTDOWN IMMEDIATE

STARTUP

EOF
