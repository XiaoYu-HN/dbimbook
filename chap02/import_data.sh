# you should create ssb schema first before loading data into it, e.g.
# ./create_ssb_schema.sh
# please copy this script to directory where SSB data files located, e.g.
# cp import_data.sh ~/ssb-dbgen/
# cd ~/ssb-dbgen/
# ./import_data.sh
# imput ssb password first
# then input directory of controlfiles, e.g.
# /home/oracle/dbimbook/chap02/controlfiles

read -sp "Please input SSB user password:" SSBPWD
echo
read -p "Please input control files directory:" CTLDIR
echo

sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_supplier.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_part.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_customer.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_date.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_lineorder.ctl

