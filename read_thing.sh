#!/bin/bash

# Get mandatory property(ies) from the configuration.txt file

thing_name=`cat configuration.txt | grep thing_name | cut -d "=" -f 2`
echo "Thing's name is $thing_name."
thing_description=`cat configuration.txt | grep thing_description | cut -d "=" -f 2`
echo "Thing's description is $thing_description."
thing='"name": "'$thing_name'",
      "description": "'$thing_description'"'

# Get optional property(ies) from the configuration.txt file

number_of_optional_property=`cat configuration.txt | grep ^property_name | wc -l`
if [[ $number_of_optional_property -gt 0 ]]; then
	if [[ $number_of_optional_property -eq 1 ]]; then
		echo "There is 1 optional property."
	else
		echo "There are $number_of_optional_property optional properties."
	fi
	optional_content='"properties": {'
	for (( i=1; i<=$number_of_optional_property; i++ )); do
		property_name=`cat configuration.txt | grep ^property_name | head -$i | tail -1 | cut -d "=" -f 2`
		echo "Optional property name $i is $property_name."
		property_description=`cat configuration.txt | grep ^property_description | head -$i | tail -1 | cut -d "=" -f 2`
		echo "Optional property description $i is $property_description."
		optional_content=$optional_content'"'$property_name'": "'$property_description'"'
		if (( i<$number_of_optional_property )); then
			echo ","
		fi
	done
	optional_content=$optional_content}
	thing="$thing, $optional_content"
fi