#!/bin/bash
# This script generate SQL base on input file or object names specified in command args
# the format of object name should be: owner.tablename or "owner"."tablename"
# you can also store many object names in input file.
# 
# You can generate 3 types of script:
# -t im: 	ALTER TABLE ... INMEMORY;
# -t noim: 	ALTER TABLE ... NO INMEMORY;
# -t pop: 	EXEC DBMS_INMEMORY.POPULATE(...);

gen_im_script()
{
	local filetype=$1
	local owner
	local table

	while read obj
	do
		case "$filetype" in
			"im")
				echo "ALTER TABLE $obj INMEMORY;"
				;;
			"noim")
				echo "ALTER TABLE $obj NO INMEMORY;"
				;;
			"pop")
				obj=${obj//\"/}
				owner=${obj%.*}
				table=${obj#*.}
				echo "EXEC DBMS_INMEMORY.POPULATE('${owner}', '${table}');"
				;;
			*)
				echo "Invalid option."
				return
				;;
		esac
	done
}

show_help()
{
	echo "Usage: $0 [-t filetype] -f filename | stirng1 string2 string3 ... "
	echo "filetype should be {im | noim | pop}"
	echo "filetype im mean: ALTER TABLE ... INMEMORY;"
	echo "filetype noim mean: ALTER TABLE ... NO INMEMORY;"
	echo "filetype pop mean: EXEC DBMS_INMEMORY.POPULATE(...);"
	echo 'string format: owner.tablename or "owner"."tablename"'
}

# default file type is im
filetype=im
filename=
while getopts "f:t:h" opt; do
    case $opt in
        f)
			filename="$OPTARG"
			if [[ ! -f $filename ]]; then
				echo $filename do not exist or is not a regular file!
				exit 1
			fi
            ;;
		t)
			filetype="$OPTARG"
			if [[ $filetype != "im" && $filetype != "noim" && $filetype != "pop" ]]; then
				echo "Invalid file type!"
				show_help
				exit 1
			fi
			;;
        h)
			show_help
            exit 0
            ;;
        ?)
            echo "Invalid option. Use -h to show help!"
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

if [[ -n $filename ]]; then
	cat $filename | gen_im_script $filetype
else
	for objstr in "$@"; do
   		echo $objstr | gen_im_script $filetype 
	done
fi

