#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
location_id=$1
#curl -X DELETE -H "Content-type: application/json" -H -d "$base_url/Locations($location_id)"
