#!/bin/bash
# mandatory property
name="Temperature Monitoring System"
description="Sensor system monitoring area temperature"
url="https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things"
# optional property
property_name=()
property_name+=("Deployment Condition")
property_name+=("Case Used")
property_name+=("Owner")
property_description=("Deployed in a third floor balcony" "Radiation shield" "Budhi Gustiandi")
content='{
	"name": "Temperature Monitoring System",
	"description": "Sensor system monitoring area temperature",
	"properties": {
		"Deployment Condition": "Deployed in a third floor balcony",
		"Case Used": "Radiation shield",
		"Owner": "Budhi Gustiandi"
	}
}'
attributes=`echo $content`
curl -XPOST -H "Content-type: application/json" -d "$content" "$url"
