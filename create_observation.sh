#!/bin/bash

time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_temperature.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1684062}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_humidity.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1684065}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_light.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1684068}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
