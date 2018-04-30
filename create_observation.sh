#!/bin/bash

observation_result=`sudo python observation/read_temperature.py`
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":2183670}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
observation_result=`sudo python observation/read_humidity.py`
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":2183673}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
observation_result=`sudo python observation/read_light.py`
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":2183676}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
