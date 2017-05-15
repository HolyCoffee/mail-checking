#!/bin/bash

emptyPost="+OK 0 0"
exampleError='-ERR authorization failed'
exampleError2="Escape character is '^]'."

while [ 1 ] ; do

(
	echo "USER login"
	sleep 1
	echo "PASS password"
	sleep 1
	echo "STAT"
	sleep 1
) | telnet name_server 110 | tee -a ./check.txt

newPost=$(tail -n1 ./check.txt &)
typicalError=$(tail ./check.txt &)

if [ "$newPost" = "$exampleError" ] ; then
	echo "authorization failed"
else
	if [ "$newPost" = "$exampleError2" ] ; then
		echo "authorization failed"
	else
		if [ "$newPost" != "" ] ; then
			if [ "$newPost" != "$emptyPost" ] ; then
				iterationVar=0
				while [ $iterationVar -lt 10 ] ; do
					echo -en "\a" > /dev/tty5
					sleep 1
					iterationVar=$[ iterationVar+1 ]
				done
			else
				echo "No new messages"
			fi
		else
			echo "error"
		fi
	fi
fi

rm ./check.txt
sleep 10

done
