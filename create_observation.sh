#!/bin/bash

time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":2111930}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":2111933}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
curl -X POST -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":2111936}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations"
