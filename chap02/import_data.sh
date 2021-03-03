# please copy this script to directory where SSB data files located
read -sp "Please input SSB user password:" SSBPWD
read -sp "Please input control files directory:" CTLDIR
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_supplier.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_part.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_customer.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_date.ctl
sqlldr ssb/$SSBPWD@orclpdb1 control=$CTLDIR/control_lineorder.ctl

