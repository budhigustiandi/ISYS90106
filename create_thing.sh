#!/bin/bash

# mandatory property

name=`cat configuration.txt | grep thing_name | cut -d ":" -f 2`
description=`cat configuration.txt | grep thing_description | cut -d ":" -f 2`
url="https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things"

# optional property

property_name=()
property_description=()
number_of_optional_property=`cat configuration.txt | grep property_name | wc -l`

for (( i=1; i<=$number_of_optional_property; i++ ))
do
	name_of_property=`cat configuration.txt | grep property_name | head -$i | tail -1 | cut -d ":" -f 2`
	property_name+=("$name_of_property")
	description_of_property=`cat configuration.txt | grep property_description | head -$i | tail -1 | cut -d ":" -f 2`
	property_description+=("$description_of_property")
done

#property_name+=("Deployment Condition")
#property_description+=("Deployed in a third floor balcony")
#property_name+=("Case Used")
#property_description+=("Radiation shield")
#property_name+=("Owner")
#property_description+=("Budhi Gustiandi")

function insert_optional_property {
	for (( i=0, j=1; i<${#property_name[@]}; i++, j++ ))
	do
		echo -n "\"${property_name[$i]}\": \"${property_description[$i]}\""
		if [ $j -lt ${#property_name[@]} ]
		then
			echo ","
		fi
	done
}
optional_property=`insert_optional_property`

if [ ${#property_name[@]} -eq 0 ]
then
	content="{
		\"name\": \"$name\",
		\"description\": \"$description\"
	}"
else
	content="{
        	\"name\": \"$name\",
        	\"description\": \"$description\",
        	\"properties\": {
			$optional_property
        	}
	}"
fi
curl -XPOST -H "Content-type: application/json" -d "$content" "$url"
