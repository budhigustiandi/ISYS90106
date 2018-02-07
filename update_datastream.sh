#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
query_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
number_of_datastream=`echo $query_result | cut -d ":" -f 2 | cut -d "," -f 1`
for (( i=1; i<=$number_of_datastream; i++ )); do
	j=`echo "( 2 * $i - 1)" | bc`
	k=`echo "( 2 * $i )" | bc`
	datastream_id=`echo $query_result | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | head -$i | tail -1 |cut -d ":" -f 2 | cut -d "," -f 1`
	datastream_name=`echo $query_result | sed 's/name/\nname/g' | grep name | head -$j | tail -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	datastream_description=`echo $query_result | sed 's/description/\ndescription/g' | grep description | head -$i | tail -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	datastream_observation_type=`echo $query_result | sed 's/observationType/\nobservationType/g' | grep observationType | head -$i | tail -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	unit_of_measurement_name=`echo $query_result | sed 's/name/\nname/g' | grep name | head -$k | tail -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	unit_of_measurement_symbol=`echo $query_result | sed 's/symbol/\nsymbol/g' | grep symbol | head -$i | tail -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	unit_of_measurement_definition=`echo $query_result | sed 's/definition/\ndefinition/g' | grep definition | head -$i | tail -1 | cut -d ":" -f 2 | cut -d "}" -f 1`
	read -p "Old datastream name is $datastream_name. Please enter new datastream name. > " datastream_name
	read -p "Old datastream description is $datastream_description. Please enter new datastream description. > " datastream_description
	read -p "Old datastream observation type is $datastream_observation_type. Please enter new datastream observation type. > " datastream_observation_type
	read -p "Old unit of measurement name is $unit_of_measurement_name. Please enter new unit of measurement name. > " unit_of_measurement_name
	read -p "Old unit of measurement symbol is $unit_of_measurement_symbol. Please enter new unit of measurement symbol. > " unit_of_measurement_symbol
	read -p "Old unit of measurement definition is $unit_of_measurement_definition. Please enter new unit of measurement definition. > " unit_of_measurement_definition
	datastream="{\"name\": \"$datastream_name\",
         	   \"description\": \"$datastream_description\",
         	   \"observationType\": \"$datastream_observation_type\",
          	   \"unitOfMeasurement\": {
        		\"name\": \"$unit_of_measurement_name\",
                	\"symbol\": \"$unit_of_measurement_symbol\",
                	\"definition\": \"$unit_of_measurement_definition\"
          	   }}"
	url="$base_url/Datastreams($datastream_id)"
	curl -X PATCH -H "Content-Type: application/json" -d "$datastream" "$url"
	echo
	echo "Datastream $i with ID $datastream_id has been updated."
done
