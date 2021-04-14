for f in [1234]_[1234].sql;do
	echo Run SSB Sample SQL $f
	sqlplus /nolog <<-EOF
		@../../../userlogin.sql
		@$f
		exit
	EOF
done
