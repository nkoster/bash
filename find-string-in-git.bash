#!/bin/bash

me=`basename $0`

if [ "$#" -ne 1 ]
then
	echo "$me usage: $me 'string'"
    exit 1
fi

echo
echo "Searching for \"${1}\""

for repo in `find . -mindepth 1 -maxdepth 1 -type d`
do
	if [ -e ${repo}/.git/config ]
	then
		result=`egrep -lir "$1" "$repo" | grep -v "^${repo}/.git"`
		if [ ! -z "$result" ]
		then
			count=$(echo "$result"|wc -l)
        	echo
			echo -n "Git repository \"${repo}\" has a match for \"${1}\" in $count file"
			[ $count -eq 1 ] || echo -n s
			echo ":"
			for n in "$result"
			do
				echo "$n"
			done
		fi
	fi
done

echo
