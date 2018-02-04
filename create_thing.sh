#!/bin/bash

echo "Create a new thing..."
bash create_update_content.sh
content_placeholder=`cat content_placeholder`
rm content_placeholder
url=`cat configuration.txt | grep url | cut -d "=" -f 2`
curl -XPOST -H "Content-type: application/json" -d "$content_placeholder" "$url"
bash retrieve_thing.sh
