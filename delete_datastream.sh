#!/bin/bash

datastream_id="$1"
base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
datastream_url="$base_url/Datastreams($datastream_id)"
curl -X DELETE -H "Content-Type: application/json" -H -d "$datastream_url"
