#!/bin/bash

thing_url=`cat configuration.txt | grep thing_url | cut -d "=" -f 2`
thing_id=$1
url="$thing_url($thing_id)"
curl -X DELETE -H "Content-Type: application/json" -H -d "$url"
