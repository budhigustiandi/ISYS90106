#!/bin/bash

# This script is not only create datastream(s) for the registered thing, but also create create_observation.sh script that process all the sensor readings automatically.

# Create header for the create_observation.sh

echo '#!/bin/bash' > create_observation.sh
echo "" >> create_observation.sh

# Count number of datastream(s) connected to the thing

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
number_of_datastream=`cat configuration.txt | grep datastream_name | wc -l`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`

# For each datastream, create a new datastream entity

for (( i=1; i<=$number_of_datastream; i++ )); do
	bash read_datastream.sh
	curl -X POST -H "Content-Type: application/json" -d "$datastream" "$base_url/Datastreams"
	observation_command=`cat configuration.txt | grep observation_command | head -$i | tail -1 | cut -d "=" -f 2`
	query_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
	
	# The query is reversed since new datastreams are pushed to the top
	
	datastream_id=`echo $query_result | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | head -1 | tail -1 | cut -d ":" -f 2 | cut -d "," -f 1`

	# Update create_observation.sh

	echo 'time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`' >> create_observation.sh
	echo 'observation_result=`sudo python observation/'$observation_command'`' >> create_observation.sh
	echo 'curl -X POST -H "Content-Type: application/json" -d "{' >> create_observation.sh
		echo '\"phenomenonTime\": \"$time\",' >> create_observation.sh
		echo '\"resultTime\": \"$time\",' >> create_observation.sh
		echo '\"result\": \"$observation_result\",' >> create_observation.sh
		echo '\"Datastream\":{\"@iot.id\":'$datastream_id'}' >> create_observation.sh
	echo '}" "'$base_url'/Observations"' >> create_observation.sh
done
