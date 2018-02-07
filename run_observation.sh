#!/bin/bash

time_between_observation=`cat configuration.txt | grep time_between_observation | cut -d "=" -f 2`
while [ True ]; do
	time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
	observation_result=`sudo python observation/$observation_command`
	base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
	curl -X POST -H "Content-Type: application/json" -d "{
		\"phenomenonTime\": \"$time\",
		\"resultTime\": \"$time\",
		\"result\": \"$observation_result\",
		\"Datastream\":{\"@iot.id\":$datastream_id}
	}" "$base_url/Observations"
	sleep $time_between_observation
done
