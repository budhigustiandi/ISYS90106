#!/bin/bash

time_between_observation=`cat configuration.txt | grep time_between_observation | cut -d "=" -f 2`
while [ True ]; do
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_temperature.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1626003}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_humidity.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1626006}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
sleep $time_between_observation
done
