# change directory to ssb-dbgen, then run below commands
export PATH=$PATH:.
dbgen -s 8 -T c
dbgen -s 24 -T p
dbgen -s 8 -T s
dbgen -s 1 -T d
dbgen -s 2 -T l

ls -lh *.tbl
