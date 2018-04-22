#!/bin/bash

# This script is not only create datastream(s) for the registered thing, but also create create_observation.sh script that processes all the sensor readings and update the tasking capability script(s) available in the tasking directory automatically.

# Create header for the create_observation.sh

echo '#!/bin/bash' > create_observation.sh
echo "" >> create_observation.sh

# Count number of datastream(s) connected to the thing

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
number_of_datastream=`cat configuration.txt | grep datastream_name | wc -l`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`

# For each datastream, create a new datastream entity

for (( i=1; i<=$number_of_datastream; i++ )); do
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
                   },
                   "Thing":{"@iot.id":'$thing_id'},
                   "ObservedProperty": {
                                "name": "'$observed_property_name'",
                                "description": "'$observed_property_description'",
                                "definition": "'$observed_property_definition'"
                   },
                   "Sensor": {
                                "name": "'$sensor_name'",
                                "description": "'$sensor_description'",
                                "encodingType": "'$sensor_encoding_type'",
                                "metadata": "'$sensor_metadata'"
                   }}'
	curl -X POST -H "Content-Type: application/json" -d "$datastream" "$base_url/Datastreams"
	observation_command=`cat configuration.txt | grep observation_command | head -$i | tail -1 | cut -d "=" -f 2`
	query_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`

	# The query is reversed since new datastreams are pushed to the top

	datastream_id=`echo $query_result | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | head -1 | tail -1 | cut -d ":" -f 2 | cut -d "," -f 1`

	# Update create_observation.sh with conditional flow between sensing and tasking capability

	if [[ "$datastream_observation_type" == "actuator" || "$datastream_observation_type" == "Actuator" || "$datastream_observation_type" == "ACTUATOR" ]]; then
		while read line; do
			echo $line | grep ^datastream_id
			if [[ $? -eq 0 ]]; then
				echo "datastream_id=$datastream_id" >> tasking/temporary_$observation_command
			else
				echo $line >> tasking/temporary_$observation_command
			fi
		done < tasking/$observation_command
		mv tasking/temporary_$observation_command tasking/$observation_command
		chmod 755 tasking/$observation_command
		chown pi:pi tasking/$observation_command
	else
		# Conditional flow for python and bash script type of observation command

        	observation_command_extention=`echo $observation_command | cut -d "." -f 2`
        	if [[ "$observation_command_extention" == "py" ]]; then
                	echo 'observation_result=`sudo python observation/'$observation_command'`' >> create_observation.sh
        	elif [[ "$observation_command_extention" = "sh" ]]; then
                	echo 'observation_result=`bash observation/'$observation_command'`' >> create_observation.sh
        	fi
		echo 'time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`' >> create_observation.sh
		echo 'curl -X POST -H "Content-Type: application/json" -d "{' >> create_observation.sh
			echo '\"phenomenonTime\": \"$time\",' >> create_observation.sh
			echo '\"resultTime\": \"$time\",' >> create_observation.sh
			echo '\"result\": \"$observation_result\",' >> create_observation.sh
			echo '\"Datastream\":{\"@iot.id\":'$datastream_id'}' >> create_observation.sh
		echo '}" "'$base_url'/Observations"' >> create_observation.sh
	fi
done
