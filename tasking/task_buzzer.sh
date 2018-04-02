#!/bin/bash

# Ensure that it refers to the right configuration file...
base_url=`cat ../configuration.txt | grep base_url | cut -d "=" -f 2`
datastream_id=1931626

# Find if there is an observation value in the datastream
observation_count=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/Observations"`
observation_count=`echo $observation_count | cut -d "," -f 1`
observation_count=`echo $observation_count | cut -d ":" -f 2`

# Make a default observation value if it does not exist
if [[ "$observation_count" == "0" ]]; then
	time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
	observation_result='Please choose "On" or "Off"'
	curl -X POST -H "Content-Type: application/json" -d "{
	\"phenomenonTime\": \"$time\",
	\"resultTime\": \"$time\",
	\"result\": \"$observation_result\",
	\"Datastream\":{\"@iot.id\":$datastream_id}
	}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
fi

# Read status of buzzer from a "result" value in the observation entity
result=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/Observations"`
result=`echo $result | sed -e 's/^{//g' -e 's/}$//g' -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"phenomenonTime":/\n"phenomenonTime":/g' -e 's/"result":/\n"result":/g' -e 's/"resultTime":/\n"resultTime":/g' -e 's/"Datastream@iot.navigationLink":/\n"Datastream@iot.navigationLink":/g' -e 's/"FeatureOfInterest@iot.navigationLink":/\n"FeatureOfInterest@iot.navigationLink":/g' | grep '"result":'`
result=`echo $result | cut -d "\"" -f 4`

# Command the buzzer through a python script
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
if [[ "$result" == "On" ]]; then
	sudo python turn_on_buzzer.py
	observation_result=On
elif [[ "$result" == "Off" ]]; then
	sudo python turn_off_buzzer.py
	observation_result=Off
else
	observation_result='Please choose "On" or "Off"'
fi

# Update the result in the observation
curl -X PATCH -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":$datastream_id}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
