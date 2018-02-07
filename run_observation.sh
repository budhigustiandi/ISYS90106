#!/bin/bash

while [ True ]; do
	observation_result=`sudo python observation/read_temperature.py`
	base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
	curl -X POST -H "Content-Type: application/json" -d "{
		\"phenomenonTime\": \"2018-02-07T11:34:00.000Z\",
		\"resultTime\": \"2018-02-07T11:34:00.000Z\",
		\"result\": \"$observation_result\",
		\"Datastream\":{\"@iot.id\":1624188}
	}" "$base_url/Observations"
	sleep 10
done
