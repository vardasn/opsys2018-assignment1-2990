#!/bin/bash

fileName=$1

mkdir unzip
tar xf $fileName -C unzip
find unzip | grep .txt >> textFilesPaths.txt
pathsOfFiles='textFilesPaths.txt'

if [[ ! -d  assignments ]]
then
	mkdir assignments
fi

while read line;do
	temp="$line"
	while read tempLine;do
		#echo "LINE READ: $tempLine"
		if [[ "$tempLine" != "#"* ]] && [[ "$tempLine" == https* ]]; then
			git -C assignments clone "$tempLine" >/dev/null 2>&1 && echo "$tempLine: Cloning OK" || echo "$tempLine: Cloning FAILED" >&2
		fi
	done <$temp
	#echo "/////FILE READ END/////"
	#echo " "
	#echo " "
done <$pathsOfFiles

for dir in assignments/*;do
	flag=false

	find $dir -type d > directory.txt
	find $dir | grep .txt >text.txt

	countD=$(find $dir -type d | grep -v .git | wc -l)
	countD=$((countD - 1))   								#metra k to directory pou vriskete mesa
	countT=$(find $dir | grep .txt | grep -v .git | wc -l)
	countAll=$(find $dir | grep -v "$dir/\." | grep -v .git | wc -l)	
	countAll=$((countAll-1))
	countOther=$((countAll-countD-countT))
	
	rightCountD=1
	rightCounT=3

	tempD='directory.txt'
	tempT='text.txt'
	file="$dir"

	if [[ "$rightCountD" -eq "$countD" ]] && [[ "$rightCounT" -eq "$countT" ]]; then
		firstD=$(sed -n '1p' <$tempD)
	        secondD=$(sed -n '2p' <$tempD)
        	firstT=$(sed -n '1p' <$tempT)
        	secondT=$(sed -n '2p' <$tempT)
        	thirdT=$(sed -n '3p' <$tempT)
 
	if [[ "$firstD" == "$file" ]] && [[ "$secondD" == "$file/more" ]] || [[ "$secondD" == "$file" ]] && [[ "$firstD" == "$file/more" ]]; then 
		if [[ "$firstT" == "$file/dataA.txt" ]] && [[ "$secondT" == "$file/more/dataB.txt" ]] && [[ "$thirdT" == "$file/more/dataC.txt" ]]; then
			flag=true
		fi

		if [[ "$secondT" == "$file/dataA.txt" ]] && [[ "$firstT" == "$file/more/dataB.txt" ]] && [[ "$thirdT" == "$file/more/dataC.txt" ]]; then
        		flag=true
 	        fi

		if [[ "$firstT" == "$file/dataA.txt" ]] && [[ "$thirdT" == "$file/more/dataB.txt" ]] && [[ "$secondT" == "$file/more/dataC.txt" ]]; then
        flag=true
                fi

		if [[ "$thirdT" == "$file/dataA.txt" ]] && [[ "$firstT" == "$file/more/dataB.txt" ]] && [[ "$secondT" == "$file/more/dataC.txt" ]]; then
        flag=true
                fi

		if [[ "$thirdT" == "$file/dataA.txt" ]] && [[ "$secondT" == "$file/more/dataB.txt" ]] && [[ "$firstT" == "$file/more/dataC.txt" ]]; then
        flag=true
                fi

		if [[ "$secondT" == "$file/dataA.txt" ]] && [[ "$thirdT" == "$file/more/dataB.txt" ]] && [[ "$firstT" == "$file/more/dataC.txt" ]]; then
        flag=true
                fi

	fi
	fi

	name=$(basename $file)
	echo "$name:"
	echo "Number of directories: $countD"
	echo "Number of txt files: $countT"
	echo "Number of other files: $countOther"
	if [[ $flag == true ]]; then
		echo "Directory structure is OK."
	else
		echo "Directory structure is NOT OK."
 	fi

	rm $tempD
	rm $tempT
	  
done

rm $pathsOfFiles
