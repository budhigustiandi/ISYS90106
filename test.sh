#!/bin/bash

function update_thing_id {
	number_of_line=`cat configuration.txt | wc -l`
	echo "There are $number_of_line lines in configuration.txt"
	for (( i=1; i<=$number_of_line; i++ )); do
		string=`cat configuration.txt | head -$i | tail -1 | grep thing_id`
		if [[ $? -eq 0 ]]; then
			echo "thing_id=773288" >> temporary_configuration.txt
		else
			cat configuration.txt | head -$i | tail -1 >> temporary_configuration.txt
		fi
	done
	mv temporary_configuration.txt configuration.txt
}
