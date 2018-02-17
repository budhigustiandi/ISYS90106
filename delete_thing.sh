#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
#thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
thing_id=$1
curl -X DELETE -H "Content-Type: application/json" -H -d "$base_url/Things($thing_id)"
