#!/bin/bash
# mandatory property
name="Temperature Monitoring System"
description="Sensor system monitoring area temperature"
url="https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things"
# optional property
property_name_1="Deployment Condition"
property_description_1="Deployed in a third floor balcony"
property_name_2="Case Used"
property_description_2="Radiation Shield"
property_name_3="Owner"
property_description_3="Budhi Gustiandi"
curl -XPOST -H "Content-type: application/json" -d '{
	"name": "$name",
	"description": "$description",
	"properties": {
		"$property_name_1": "$property_description_1",
		"$property_name_2": "$property_description_2",
		"$property_name_3": "$property_description_3"
	}
}' "$url"
