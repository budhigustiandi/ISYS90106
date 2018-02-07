#!/bin/bash

# Create header for the run_observation.sh

echo '#!/bin/bash' > run_observation.sh
echo "" >> run_observation.sh
echo 'time_between_observation=`cat configuration.txt | grep time_between_observation | cut -d "=" -f 2`' >> run_observation.sh
echo 'while [ True ]; do' >> run_observation.sh

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
	datastream_url="$base_url/Datastreams"
	curl -X POST -H "Content-Type: application/json" -d "$datastream" "$datastream_url"
	observation_command=`cat configuration.txt | grep observation_command | head -$i | tail -1 | cut -d "=" -f 2`
	query_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
	# This is a little bit different query since new datastreams are pushed to the top
	datastream_id=`echo $query_result | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | head -1 | tail -1 |cut -d ":" -f 2 | cut -d "," -f 1`

	# Update run_observation.sh

		echo 'time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`' >> run_observation.sh
		echo 'observation_result=`sudo python observation/'$observation_command'`' >> run_observation.sh
		echo 'curl -X POST -H "Content-Type: application/json" -d "{' >> run_observation.sh
			echo '\"phenomenonTime\": \"$time\",' >> run_observation.sh
			echo '\"resultTime\": \"$time\",' >> run_observation.sh
			echo '\"result\": \"$observation_result\",' >> run_observation.sh
			echo '\"Datastream\":{\"@iot.id\":'$datastream_id'}' >> run_observation.sh
		echo '}" "'$base_url'/Observations"' >> run_observation.sh
done

echo 'sleep $time_between_observation' >> run_observation.sh
echo "done" >> run_observation.sh
