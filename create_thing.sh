#!/bin/bash

echo "Create a new thing..."
bash create_update_content.sh
content_placeholder=`cat content_placeholder`
rm content_placeholder
thing_url=`cat configuration.txt | grep thing_url | cut -d "=" -f 2`
curl -XPOST -H "Content-type: application/json" -d "$content_placeholder" "$thing_url"
bash retrieve_thing.sh
