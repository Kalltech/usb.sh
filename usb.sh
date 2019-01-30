#!/bin/bash

sleep 1
# Fetching usbs location and putting them in array
locIterator="0"
locArr=()
df >df.txt
while read row
do
    loc=$( echo $row | grep /share/external/ | awk '{print $6}' )
    if [ "$loc" != "" ]; then
		locArr[ $locIterator ]="$loc"
		(( locIterator++ ))
    fi    
done < df.txt

# Fetching usbs serial numbers and putting them in array
snIterator="0"
snArr=()
cat /proc/scsi/usb-storage/* >usb.txt
while read row
do
    sn=$( echo $row | grep 'Serial Number:' | sed -r 's/^Serial Number://' )
	if [ "$sn" != "" ]; then 
		snArr[ $snIterator ]="${sn:15}"  
		(( snIterator++ ))
	fi	
done < usb.txt

# Generating Output by looping through both arrays
output=""
for (( i = 0 ; i < ${#locArr[@]} ; i++ ))
do
	if [ "$i" != "0"  ]; then
		output="$output|"
	fi
	output="$output${locArr[$i]}"
done
echo $output
