#!/bin/bash

# Create header for the create_observation.sh

echo '#!/bin/bash' > create_observation.sh
echo "" >> create_observation.sh

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
query_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
number_of_datastream=`cat configuration.txt | grep datastream_name | wc -l`
for (( i=1; i<=$number_of_datastream; i++ )); do
	# Remember that datastream(s) in the server is(are) reversed with the configuration.txt file
	datastream_id=`echo $query_result | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | tail -$i | head -1 |cut -d ":" -f 2 | cut -d "," -f 1`
	datastream_name=`cat configuration.txt | grep datastream_name | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Datastream name $i is $datastream_name."
        datastream_description=`cat configuration.txt | grep datastream_description | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Datastream description $i is $datastream_description."
        datastream_observation_type=`cat configuration.txt | grep datastream_observation_type | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Datastream observation type $i is $datastream_observation_type."
        unit_of_measurement_name=`cat configuration.txt | grep unit_of_measurement_name | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Unit of measurement name $i is $unit_of_measurement_name."
        unit_of_measurement_symbol=`cat configuration.txt | grep unit_of_measurement_symbol | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Unit of measurement symbol $i is $unit_of_measurement_symbol."
        unit_of_measurement_definition=`cat configuration.txt | grep unit_of_measurement_definition | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Unit of measurement definition $i is $unit_of_measurement_definition."
        observed_property_name=`cat configuration.txt | grep observed_property_name | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Observed property name $i is $observed_property_name."
        observed_property_description=`cat configuration.txt | grep observed_property_description | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Observed property description $i is $observed_property_description."
        observed_property_definition=`cat configuration.txt | grep observed_property_definition | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Observed property definition $i is $observed_property_definition."
        sensor_name=`cat configuration.txt | grep sensor_name | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Sensor name $i is $sensor_name."
        sensor_description=`cat configuration.txt | grep sensor_description | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Sensor description $i is $sensor_description."
	sensor_encoding_type=`cat configuration.txt | grep sensor_encoding_type | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Sensor encoding type $i is $sensor_encoding_type."
        sensor_metadata=`cat configuration.txt | grep sensor_metadata | head -$i | tail -1 | cut -d "=" -f 2`
        echo "Sensor metadata $i is $sensor_metadata."
        datastream='{"name": "'$datastream_name'",
                   "description": "'$datastream_description'",
                   "observationType": "'$datastream_observation_type'",
                   "unitOfMeasurement": {
                                "name": "'$unit_of_measurement_name'",
                                "symbol": "'$unit_of_measurement_symbol'",
                                "definition": "'$unit_of_measurement_definition'"
                   }}'
	curl -X PATCH -H "Content-Type: application/json" -d "$datastream" "$base_url/Datastreams($datastream_id)"

	# Update create_observation.sh
	observation_command=`cat configuration.txt | grep observation_command | head -$i | tail -1 | cut -d "=" -f 2`
	echo 'time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`' >> create_observation.sh
	echo 'observation_result=`sudo python observation/'$observation_command'`' >> create_observation.sh
	echo 'curl -X POST -H "Content-Type: application/json" -d "{' >> create_observation.sh
		echo '\"phenomenonTime\": \"$time\",' >> create_observation.sh
		echo '\"resultTime\": \"$time\",' >> create_observation.sh
		echo '\"result\": \"$observation_result\",' >> create_observation.sh
		echo '\"Datastream\":{\"@iot.id\":'$datastream_id'}' >> create_observation.sh
	echo '}" "'$base_url'/Observations"' >> create_observation.sh
	echo
	echo "##########################################################"
	echo "# Datastream $i with ID $datastream_id has been updated. #"
	echo "##########################################################"
	echo ""
done
