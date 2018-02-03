#!/bin/bash

thing_id=1608083
url="http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things($thing_id)?$expand=Datastreams"
#echo $url
curl -X GET -H "Content-Type: application/json" "$url"
