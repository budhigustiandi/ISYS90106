#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
query_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
number_of_datastream=`echo $query_result | cut -d ":" -f 2 | cut -d "," -f 1`
for (( i=1; i<=$number_of_datastream; i++ )); do
        datastream_id=`echo $query_result | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | head -$i | tail -1 |cut -d ":" -f 2 | cut -d "," -f 1`
        curl -X DELETE -H "Content-Type: application/json" -H -d "$base_url/Datastreams($datastream_id)"
		echo "##################################################"
		echo "# Datastream ID $datastream_id has been deleted. #"
		echo "##################################################"
		echo ""
	done
done
