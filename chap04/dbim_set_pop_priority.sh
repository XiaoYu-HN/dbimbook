IFS=$'\r\n' GLOBIGNORE='*' command eval  'options=($(cat POP_PRIORITY.list))'

select cl in "${options[@]}"; do 
	echo Your selection is ${REPLY}: $cl
	break
done

echo

cat ../SSB_TABLES.list | while read t; do
	echo ALTER TABLE ${t,,} INMEMORY ${cl}\;
	echo
done

cat ../SSB_TABLES.list | while read t; do
	echo SELECT INMEMORY_PRIORITY FROM user_tables WHERE table_name = \'${t^^}\'\;
	echo
done
