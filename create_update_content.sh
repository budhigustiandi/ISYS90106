#!/bin/bash

echo "Create content..."

# mandatory property

thing_name=`cat configuration.txt | grep thing_name | cut -d "=" -f 2`
thing_description=`cat configuration.txt | grep thing_description | cut -d "=" -f 2`
mandatory_content="\"name\": \"$thing_name\",
                   \"description\": \"$thing_description\""
echo "Thing's name is $thing_name."
echo "Thing's description is $thing_description."
content=$mandatory_content

# optional property

property_name=()
property_description=()
number_of_optional_property=`cat configuration.txt | grep property_name | wc -l`
if [[ $number_of_optional_property -gt 0 ]]; then
	if [[ $number_of_optional_property -eq 1 ]]; then
		echo "There is 1 optional property."
	else
		echo "There are $number_of_optional_property optional properties."
	fi
	for (( i=1; i<=$number_of_optional_property; i++ )); do
        	name_of_property=`cat configuration.txt | grep property_name | head -$i | tail -1 | cut -d "=" -f 2`
        	property_name+=("$name_of_property")
		echo "Optional property name $i is $name_of_property."
        	description_of_property=`cat configuration.txt | grep property_description | head -$i | tail -1 | cut -d "=" -f 2`
        	property_description+=("$description_of_property")
		echo "Optional property description $i is $description_of_property."
	done
	function insert_optional_property {
        for (( i=0, j=1; i<$number_of_optional_property; i++, j++ )); do
            echo -n "\"${property_name[$i]}\": \"${property_description[$i]}\""
            if [[ $j -lt $number_of_optional_property ]]; then
                echo ","
            fi
        done
	}
	optional_property=`insert_optional_property`
	optional_content="\"properties\": {$optional_property}"
	content="$content, $optional_content"
fi

# datastream property

add_datastream=`cat configuration.txt | grep add_datastream | cut -d "=" -f 2`
if [[ "$add_datastream" == "True" ]]; then
	datastream_name=`cat configuration.txt | grep datastream_name | cut -d "=" -f 2`
	echo "Datastream name is $datastream_name."
	datastream_description=`cat configuration.txt | grep datastream_description | cut -d "=" -f 2`
	echo "Datastream description is $datastream_description."
	datastream_observation_type=`cat configuration.txt | grep datastream_observation_type | cut -d "=" -f 2`
	echo "Datastream observation type is $datastream_observation_type."
	unit_of_measurement_name=`cat configuration.txt | grep unit_of_measurement_name | cut -d "=" -f 2`
	echo "Unit of measurement name is $unit_of_measurement_name."
	unit_of_measurement_symbol=`cat configuration.txt | grep unit_of_measurement_symbol | cut -d "=" -f 2`
	echo "Unit of measurement symbol is $unit_of_measurement_symbol."
	unit_of_measurement_definition=`cat configuration.txt | grep unit_of_measurement_definition | cut -d "=" -f 2`
	echo "Unit of measurement definition is $unit_of_measurement_definition."
	observed_property_name=`cat configuration.txt | grep observed_property_name | cut -d "=" -f 2`
	echo "Observed property name is $observed_property_name."
	observed_property_description=`cat configuration.txt | grep observed_property_description | cut -d "=" -f 2`
	echo "Observed property description is $observed_property_description."
	observed_property_definition=`cat configuration.txt | grep observed_property_definition | cut -d "=" -f 2`
	echo "Observed property definition is $observed_property_definition."
	sensor_name=`cat configuration.txt | grep sensor_name | cut -d "=" -f 2`
	echo "Sensor name is $sensor_name."
	sensor_description=`cat configuration.txt | grep sensor_description | cut -d "=" -f 2`
	echo "Sensor description is $sensor_description."
	sensor_encoding_type=`cat configuration.txt | grep sensor_encoding_type | cut -d "=" -f 2`
	echo "Sensor encoding type is $sensor_encoding_type."
	sensor_metadata=`cat configuration.txt | grep sensor_metadata | cut -d "=" -f 2`
	echo "Sensor metadata is $sensor_metadata."
	datastream="\"Datastreams\": [{
					\"name\": \"$datastream_name\",
					\"description\": \"$datastream_description\",
					\"observationType\": \"$datastream_observation_type\",
					\"unitOfMeasurement\": {
						\"name\": \"$unit_of_measurement_name\",
						\"symbol\": \"$unit_of_measurement_symbol\",
						\"definition\": \"$unit_of_measurement_definition\"
					},
					\"ObservedProperty\": {
						\"name\": \"$observed_property_name\",
						\"description\": \"$observed_property_description\",
						\"definition\": \"$observed_property_definition\"
					},
					\"Sensor\": {
						\"name\": \"$sensor_name\",
						\"description\": \"$sensor_description\",
						\"encodingType\": \"$sensor_encoding_type\",
						\"metadata\": \"$sensor_metadata\"
					}
			   }]"
	content="$content, $datastream"
fi

content_placeholder="{$content}"
echo "$content_placeholder" > content_placeholder
