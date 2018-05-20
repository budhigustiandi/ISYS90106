#!/bin/bash

##############################################
# Configuration: #
# VCC pin is connected to pin #17 (3.3v) #
# RED LED is connected to pin #21 (GPIO09) #
# GREEN LED is connected to pin #19 (GPIO10) #
# BLUE LED is connected to pin #23 (GPIO11) #
##############################################

# Exports GPIO pins to userspace
echo "9" > /sys/class/gpio/export
echo "10" >> /sys/class/gpio/export
echo "11" >> /sys/class/gpio/export

# Sets pin GPIO09, GPIO10, GPIO11 as outputs
echo "out" > /sys/class/gpio/gpio9/direction
echo "out" > /sys/class/gpio/gpio10/direction
echo "out" > /sys/class/gpio/gpio11/direction

function turn_on_red_LED {
turn_off_all_LED
# Sets pin GPIO09 to low
echo "0" > /sys/class/gpio/gpio9/value
}
function turn_off_red_LED {
# Sets pin GPIO09 to high
echo "1" > /sys/class/gpio/gpio9/value
}
function turn_on_green_LED {
turn_off_all_LED
# Sets pin GPIO10 to low
echo "0" > /sys/class/gpio/gpio10/value
}
function turn_off_green_LED {
# Sets pin GPIO10 to high
echo "1" > /sys/class/gpio/gpio10/value
}
function turn_on_blue_LED {
turn_off_all_LED
# Sets pin GPIO10 to low
echo "0" > /sys/class/gpio/gpio11/value
}
function turn_off_blue_LED {
# Sets pin GPIO10 to high
echo "1" > /sys/class/gpio/gpio11/value
}
function turn_on_white_LED {
# Sets pin GPIO09, GPIO10, and GPIO11 to low
echo "0" > /sys/class/gpio/gpio9/value
echo "0" > /sys/class/gpio/gpio10/value
echo "0" > /sys/class/gpio/gpio11/value
}
function turn_on_yellow_LED {
turn_off_all_LED
# Sets pin GPIO09 and GPIO10 to low
echo "0" > /sys/class/gpio/gpio9/value
echo "0" > /sys/class/gpio/gpio10/value
}
function turn_on_magenta_LED {
turn_off_all_LED
# Sets pin GPIO09 and GPIO11 to low
echo "0" > /sys/class/gpio/gpio9/value
echo "0" > /sys/class/gpio/gpio11/value
}
function turn_on_cyan_LED {
turn_off_all_LED
# Sets pin GPIO10 and GPIO11 to low
echo "0" > /sys/class/gpio/gpio10/value
echo "0" > /sys/class/gpio/gpio11/value
}
function turn_off_all_LED {
turn_off_red_LED
turn_off_green_LED
turn_off_blue_LED
}

# Do not change the datastream ID value as it will be generated automatically by the system!
datastream_id=2190567

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
echo "Base URL: $base_url"
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
observation_result=NULL
echo "Observation Result: $observation_result"
curl -X POST -H "Content-Type: application/json" -d '{
"phenomenonTime": "'$observation_time'",
"resultTime": "'$observation_time'",
"result": "'$observation_result'",
"Datastream":{"@iot.id":'$datastream_id'}
}' "$base_url/Observations"
fi

# Read current observation result from the server
server_observation_result=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/Observations"`
#server_observation_result=`echo $server_observation_result | sed -e 's/"result":/n"result":/g' | grep '"result":'`
server_observation_result=`echo $server_observation_result | cut -d '"' -f 18`
echo "Server Observation Result: $server_observation_result"

# Turn on or off LED color based on the server_observation_result
if [[ "$server_observation_result" == "Red" ]]; then
turn_on_red_LED
echo "The LED color is red."
elif [[ "$server_observation_result" == "Green" ]]; then
turn_on_green_LED
echo "The LED color is green."
elif [[ "$server_observation_result" == "Blue" ]]; then
turn_on_blue_LED
echo "The LED color is blue."
elif [[ "$server_observation_result" == "White" ]]; then
turn_on_white_LED
echo "The LED color is white."
elif [[ "$server_observation_result" == "Yellow" ]]; then
turn_on_yellow_LED
echo "The LED color is yellow."
elif [[ "$server_observation_result" == "Magenta" ]]; then
turn_on_magenta_LED
echo "The LED color is magenta."
elif [[ "$server_observation_result" == "Cyan" ]]; then
turn_on_cyan_LED
echo "The LED color is cyan."
else
turn_off_all_LED
echo "The input is undefined."
fi
