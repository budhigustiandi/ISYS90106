#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`

bash read_thing.sh

curl -X PATCH -H "Content-Type: application/json" -d "$thing" "$base_url/Things($thing_id)"

echo "###########################"
echo "# Thing has been updated. #"
echo "###########################"
echo ""