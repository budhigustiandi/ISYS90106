#!/bin/bash

# mandatory property

thing_name=`cat configuration.txt | grep thing_name | cut -d ":" -f 2`
thing_description=`cat configuration.txt | grep thing_description | cut -d ":" -f 2`
url="https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things"
mandatory_content="\"name\": \"$thing_name\",
                   \"description\": \"$thing_description\""

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

function insert_optional_property {
	for (( i=0, j=1; i<${#property_name[@]}; i++, j++ ))
	do
		echo -n "\"${property_name[$i]}\": \"${property_description[$i]}\""
		if [[ $j -lt ${#property_name[@]} ]]
		then
			echo ","
		fi
	done
}
optional_property=`insert_optional_property`
optional_content="\"properties\": {
                 	$optional_property
                 }"

# location property

location_default=`cat configuration.txt | grep location_default | cut -d ":" -f 2`
location_name=`cat configuration.txt | grep location_name | cut -d ":" -f 2`
location_description=`cat configuration.txt | grep location_description | cut -d ":" -f 2`
location_longitude=`cat configuration.txt | grep location_longitude | cut -d ":" -f 2`
location_latitude=`cat configuration.txt | grep location_latitude | cut -d ":" -f 2`
location="\"Locations\": [{
		\"name\": \"$location_name\",
                \"description\": \"$location_description\",
                \"encodingType\": \"application/vnd.geo+json\",
                \"location\": {
                	\"type\": \"Point\",
                        \"coordinates\": [$location_longitude, $location_latitude]
                }
         }]"

if [[ ${#property_name[@]} -eq 0 && "$location-default" == "False" ]]; then
	content="{
               	$mandatory_content
        }"
elif [[ ${#property_name[@]} -eq 0 && "$location-default" == "True" ]]; then
	content="{
		$mandatory_content,
		$location
	}"
elif [[ ${#property_name[@]} -ne 0 && "$location-default" == "False" ]]; then
	content="{
               	$mandatory_content,
               	$optional_content
        }"
else
	content="{
        	$mandatory_content,
        	$optional_content,
                $location
	}"
fi
curl -XPOST -H "Content-type: application/json" -d "$content" "$url"
