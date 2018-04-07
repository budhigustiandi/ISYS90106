#!/bin/bash

base_url=`cat ../configuration.txt | grep base_url | cut -d "=" -f 2`
echo "Base URL: $base_url"
datastream_id=1931626
echo "Datastream ID: $datastream_id"

# Read current observation result from the server to find the observation id
observation_id=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/Observations"`
observation_id=`echo $observation_id | sed -e 's/"@iot.id":/\n"@iot.id":/g' | grep '"@iot.id":'`
observation_id=`echo $observation_id | cut -d "," -f 1`
observation_id=`echo $observation_id | cut -d ":" -f 2`
echo "Observation ID: $observation_id"

observation_time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
echo "Observation Time: $observation_time"
observation_result=$1
echo "Observation Result: $observation_result"
curl -X PATCH -H "Content-Type: application/json" -d "{
	\"phenomenonTime\": \"$observation_time\",
        \"resultTime\": \"$observation_time\",
        \"result\": \"$observation_result\"
}" "$base_url/Observations($observation_id)"
