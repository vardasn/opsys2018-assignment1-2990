##!/bin/bash

file=$1

while read line; do

if [[ "$line" != "#"* ]]; then

	html=$(curl -s $line)


	res=$?
	
	filename=$(echo "$line" | tr --delete /)
        	touch $filename.txt
	

	if test "$res" != "0"; then
		
		echo "$line FAILED"
		rm $filename.txt
		echo "FAILED">>"$filename".txt	
			

	else
	

		cont=$(<$filename.txt)
	
		if [ "$cont" == "" ]; then
			echo "$line INIT"
		elif [ "$cont" != "$html" ]; then
			echo "$line INIT"
		fi
	

		rm $filename.txt
		echo "$html">>"$filename".txt
	
	fi
fi

done <$file
