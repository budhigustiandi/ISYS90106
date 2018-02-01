#!/bin/bash
curl -XPOST -H "Content-type: application/json" -d '{
	"name": "Temperature Monitoring System",
	"description": "Sensor system monitoring area temperature",
	"properties": {
		"Deployment Condition": "Deployed in a third floor balcony",
		"Case Used": "Radiation shield",
		"Owner": "Budhi Gustiandi"
	}
}' "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things"
