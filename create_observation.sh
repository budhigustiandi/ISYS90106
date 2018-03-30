#!/bin/bash

time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_temperature.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1931611}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_humidity.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1931620}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_light.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1931623}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=`sudo python observation/read_buzzer_status.py`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1931626}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
