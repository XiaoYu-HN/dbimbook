#!/bin/bash
# this script will drop user SSB and 5 SSB tables under it

sqlplus / as sysdba <<-EOF

ALTER SESSION SET CONTAINER = orclpdb1;

DROP USER ssb CASCADE;

EOF
