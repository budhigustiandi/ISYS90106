#!/bin/bash

# Count number of datastream(s) connected to the thing

number_of_datastream=`cat configuration.txt | grep datastream_name | wc -l`
#thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
thing_id=1617538

# For each datastream, create a new datastream entity

for (( i=1; i<=$number_of_datastream; i++ )); do
	datastream_name=`cat configuration.txt | grep datastream_name | cut -d "=" -f 2`
	echo "Datastream name $i is $datastream_name."
	datastream_description=`cat configuration.txt | grep datastream_description | cut -d "=" -f 2`
	echo "Datastream description $i is $datastream_description."
	datastream_observation_type=`cat configuration.txt | grep datastream_observation_type | cut -d "=" -f 2`
	echo "Datastream observation type $i is $datastream_observation_type."
	unit_of_measurement_name=`cat configuration.txt | grep unit_of_measurement_name | cut -d "=" -f 2`
	echo "Unit of measurement name $i is $unit_of_measurement_name."
	unit_of_measurement_symbol=`cat configuration.txt | grep unit_of_measurement_symbol | cut -d "=" -f 2`
	echo "Unit of measurement symbol $i is $unit_of_measurement_symbol."
	unit_of_measurement_definition=`cat configuration.txt | grep unit_of_measurement_definition | cut -d "=" -f 2`
	echo "Unit of measurement definition $i is $unit_of_measurement_definition."
	observed_property_name=`cat configuration.txt | grep observed_property_name | cut -d "=" -f 2`
	echo "Observed property name $i is $observed_property_name."
	observed_property_description=`cat configuration.txt | grep observed_property_description | cut -d "=" -f 2`
	echo "Observed property description $i is $observed_property_description."
	observed_property_definition=`cat configuration.txt | grep observed_property_definition | cut -d "=" -f 2`
	echo "Observed property definition $i is $observed_property_definition."
	sensor_name=`cat configuration.txt | grep sensor_name | cut -d "=" -f 2`
	echo "Sensor name $i is $sensor_name."
	sensor_description=`cat configuration.txt | grep sensor_description | cut -d "=" -f 2`
	echo "Sensor description $i is $sensor_description."
	sensor_encoding_type=`cat configuration.txt | grep sensor_encoding_type | cut -d "=" -f 2`
	echo "Sensor encoding type $i is $sensor_encoding_type."
	sensor_metadata=`cat configuration.txt | grep sensor_metadata | cut -d "=" -f 2`
	echo "Sensor metadata $i is $sensor_metadata."
	datastream="{\"name\": \"$datastream_name\",
          	   \"description\": \"$datastream_description\",
          	   \"observationType\": \"$datastream_observation_type\",
          	   \"unitOfMeasurement\": {
        		\"name\": \"$unit_of_measurement_name\",
                	\"symbol\": \"$unit_of_measurement_symbol\",
                	\"definition\": \"$unit_of_measurement_definition\"
          	   },
	  	   \"Thing\":{\"@iot.id\":$thing_id},
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
        	   } }"
	base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
	url="$base_url/Datastreams"
	curl -X POST -H "Content-Type: application/json" -d "$datastream" "$url"
done
