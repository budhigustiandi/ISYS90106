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
	bash read_datastream.sh
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
