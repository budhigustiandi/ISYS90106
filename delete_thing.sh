#!/bin/bash

url="https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things"
thing_id=$1
url="$url($thing_id)"
curl -X DELETE -H "Content-Type: application/json" -H -d "$url"
