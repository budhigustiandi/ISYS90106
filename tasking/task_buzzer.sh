#!/bin/bash

#################################################################
# Configuration:                                                #
# Connect S pin of the buzzer to GPIO07 pin of the Raspberry Pi #
# Connect - pin of the buzzer to GND pin of the Raspberry Pi    #
#################################################################

# Exports GPIO07 pin to userspace
echo "7" > /sys/class/gpio/export

# Sets GPIO07 pin as an output
echo "out" > /sys/class/gpio/gpio7/direction

function turn_on_buzzer {
	# Sets GPIO07 pin to high
	echo "1" > /sys/class/gpio/gpio7/value
}
function turn_off_buzzer {
	# Sets GPIO07 pin to low
	echo "0" > /sys/class/gpio/gpio7/value
}

base_url=`cat ../configuration.txt | grep base_url | cut -d "=" -f 2`
echo "Base URL: $base_url"
datastream_id=1931626
echo "Datastream ID: $datastream_id"

# Find if there is already an observation value in the datastream
observation_count=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/Observations"`
observation_count=`echo $observation_count | cut -d "," -f 1`
observation_count=`echo $observation_count | cut -d ":" -f 2`
echo "Observation Count: $observation_count"

# Make an observation if it does not exist
if [[ "$observation_count" == "0" ]]; then
	echo "There is no observation exist in the datastream. An observation will be created."
	observation_time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
	echo "Observation Time: $observation_time"
	observation_result=Off
	echo "Observation Result: $observation_result"
	curl -X POST -H "Content-Type: application/json" -d "{
		\"phenomenonTime\": \"$observation_time\",
		\"resultTime\": \"$observation_time\",
		\"result\": \"$observation_result\",
		\"Datastream\":{\"@iot.id\":$datastream_id}
	}" "$base_url/Observations"
fi

# Endless loop
while [ true ]; do

# Read current observation result from the server
server_observation_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/Observations"`
server_observation_result=`echo $server_observation_result | sed -e 's/"result":/\n"result":/g' | grep '"result":'`
server_observation_result=`echo $server_observation_result | cut -d '"' -f 4`
echo "Server Observation Result: $server_observation_result"

# Turn on or off buzzer based on the server_observation_result
if [[ "$server_observation_result" == "On" ]]; then
	turn_on_buzzer
	echo "The buzzer is on."
elif [[ "$server_observation_result" == "Off" ]]; then
	turn_off_buzzer
	echo "The buzzer is off."
fi

sleep 1
done
